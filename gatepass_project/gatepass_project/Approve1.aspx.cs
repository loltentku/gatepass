using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Collections.Generic;
using System.Net.Mail;
using System.Net;

namespace gatepass_project
{
    public partial class Approve1 : System.Web.UI.Page
    {
        private gatepassEntities db = new gatepassEntities();
        private string host = "http://10.231.2.34/nidec/login/API/authenticate_flowlites.php";
        private string email = string.Empty; // Store email from link

        protected void Page_Load(object sender, EventArgs e)
        {
            Session["RedirectLink"] = "Approve1";
            if (!IsPostBack)
            {
                string docNo = Request.QueryString["doc_no"];
                string formType = Request.QueryString["formType"] ?? "-1";

                if (!string.IsNullOrEmpty(docNo))
                {
                    Session["DocNo"] = docNo;
                    LoadFormData(docNo);
                    LoadItemList(docNo);
                    LoadApprovalList(docNo);
                    ddlFactory.Enabled = false;
                    ddlCompany.Enabled = false;
                    ddlItemType.Enabled = false;

                    var document = db.headings.FirstOrDefault(h => h.doc_no == docNo);
                    if (document != null && document.type.HasValue)
                    {
                        int maxStatus = GetApprovalRequirements(document.type.Value).Count + 1; // +1 for creator
                        int approvalCount = db.approvals.Count(a => a.doc_no == docNo);
                        lblApprovalCount.Text = approvalCount.ToString();
                        progressBar.Style["width"] = $"{(approvalCount * 100) / maxStatus}%";
                        progressBar.Attributes["aria-valuemax"] = maxStatus.ToString();
                        progressBar.Attributes["aria-valuenow"] = approvalCount.ToString();
                    }

                    btnApprove.Visible = true;
                }
                else
                {
                    docNo = Session["DocNo"] as string;
                    if (!string.IsNullOrEmpty(docNo))
                    {
                        Response.Redirect($"Approve1.aspx?doc_no={HttpUtility.UrlEncode(docNo)}");
                    }
                    else
                    {
                        Response.Redirect("Login.aspx");
                    }
                }
            }
        }

        private void LoadFormData(string docNo)
        {
            var document = db.headings.FirstOrDefault(h => h.doc_no == docNo);
            if (document != null)
            {
                txtDocNo.Text = document.doc_no;
                txtDate.Text = document.date?.ToString("yyyy-MM-dd HH:mm:ss") ?? "N/A";
                txtName.Text = document.name;
                ddlCompany.SelectedValue = document.company;
                ddlFactory.SelectedValue = document.factory;
                txtAddress.Text = document.address;
                txtTel.Text = document.tel_no.ToString();
                txtTimeout.Text = document.time_out?.ToString(@"hh\:mm") ?? "";
                txtRequester.Text = document.requester;
                txtDept.Text = document.department;
                txtTel2.Text = document.requester_tel.ToString();
                txSect.Text = document.manager;
                txtDgm.Text = document.dgm;
                txtSecurityGuard.Text = document.security;
                txtTime.Text = document.time?.ToString(@"hh\:mm") ?? "";
                if (document.type.HasValue)
                {
                    switch (document.type.Value)
                    {
                        case 2:
                            ddlItemType.SelectedValue = "Scrap";
                            break;
                        case 3:
                            ddlItemType.SelectedValue = "Assets";
                            break;
                        case 4:
                            ddlItemType.SelectedValue = "Accessories";
                            break;
                        case 5:
                            ddlItemType.SelectedValue = "Waste";
                            break;
                        case 6:
                            ddlItemType.SelectedValue = "Others";
                            break;
                        default:
                            ddlItemType.SelectedIndex = 0; // Default to first item if no match
                            break;
                    }
                }
                else
                {
                    ddlItemType.SelectedIndex = 0; // Default if type is null
                }
            }
        }

        private void LoadItemList(string docNo)
        {
            var items = db.detail_pass.Where(d => d.doc_no == docNo).ToList();
            if (items.Any())
            {
                DataTable dt = new DataTable();
                dt.Columns.Add("Description");
                dt.Columns.Add("Quantity");
                dt.Columns.Add("Purpose");
                dt.Columns.Add("image_url");
                foreach (var item in items)
                {
                    DataRow dr = dt.NewRow();
                    dr["Description"] = item.description;
                    dr["Quantity"] = item.quantity;
                    dr["Purpose"] = item.purpose;
                    dr["image_url"] = item.image_url ?? string.Empty;
                    dt.Rows.Add(dr);
                }
                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
        }

        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                int rowIndex = e.Row.RowIndex + 1; // Start numbering from 1
                Label lblRowNumber = (Label)e.Row.FindControl("lblRowNumber");
                if (lblRowNumber != null)
                {
                    lblRowNumber.Text = rowIndex.ToString();
                }
            }
        }

        protected void btnApprove_Click(object sender, EventArgs e)
        {
            string docNo = Request.QueryString["doc_no"];
            if (string.IsNullOrEmpty(docNo))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "NoDocNoError",
                    "Swal.fire({title: '❌ Error', text: 'No document number provided.', icon: 'error'});", true);
                return;
            }

            string email = !string.IsNullOrEmpty(Request.QueryString["email"]) ? Request.QueryString["email"] : txtApproverEmail.Text.Trim();
            if (string.IsNullOrEmpty(email))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "NoEmailError",
                    "Swal.fire({title: '❌ Error', text: 'Please enter your email for approval.', icon: 'error'});", true);
                return;
            }

            using (gatepassEntities db = new gatepassEntities())
            {
                var document = db.headings.FirstOrDefault(h => h.doc_no == docNo);
                if (document == null)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "NoDocumentError",
                        "Swal.fire({title: '❌ Error', text: 'Document not found.', icon: 'error'});", true);
                    return;
                }

                // Check if already approved by this user
                var existingApproval = db.approvals.FirstOrDefault(a => a.doc_no == docNo && a.approver_name == email);
                if (existingApproval != null)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "AlreadyApprovedError",
                        "Swal.fire({title: '❌ Already Approved', text: 'You have already approved this document.', icon: 'error'});", true);
                    return;
                }

                // Get approval requirements for this document type
                var approvalRequirements = GetApprovalRequirements(document.type.Value);
                int maxStatus = GetApprovalRequirements(document.type.Value).Count + 1;

                if (document.status.HasValue && document.status.Value >= maxStatus)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "FullyApproved",
                        $"Swal.fire({{title: '✅ Fully Approved', text: 'This document has received all required approvals ({maxStatus}).', icon: 'success'}}).then(() => {{ window.location.href = 'Login.aspx'; }});", true);
                    return;
                }

                // Get current status (starts at 1 for creator approval)
                int currentStatus = document.status ?? 1;
                int nextStatus = currentStatus + 1;

                // Verify this is the correct approver for the next status
                string expectedApprover = GetExpectedApprover(document.type.Value, nextStatus, db);
                if (string.IsNullOrEmpty(expectedApprover))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "NoApproverError",
                        "Swal.fire({title: '❌ Error', text: 'No approver email found in the database. Please contact the system administrator.', icon: 'error'});", true);
                    return;
                }

                if (email != expectedApprover)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "WrongApproverError",
                        $"Swal.fire({{title: '❌ Wrong Approver', text: 'The email provided is not authorized for approval.', icon: 'error'}});", true);
                    return;
                }

                // Update document status
                document.status = nextStatus;

                // Record the approval
                var newApproval = new approval
                {
                    doc_no = docNo,
                    approver_name = email,
                    approver_department = GetDepartmentFromApprovalFlow(email, document.type.Value, db),
                    approved_at = DateTime.Now
                };
                db.approvals.Add(newApproval);

                try
                {
                    db.SaveChanges();

                    // Update UI
                    lblApprovalCount.Text = document.status.Value.ToString();
                    progressBar.Style["width"] = $"{(document.status.Value * 100) / maxStatus}%";
                    progressBar.Attributes["aria-valuemax"] = maxStatus.ToString();
                    progressBar.Attributes["aria-valuenow"] = document.status.Value.ToString();

                    ScriptManager.RegisterStartupScript(this, GetType(), "ApprovalSuccess",
                        "Swal.fire({title: '✅ Approved', text: 'Your approval has been recorded.', icon: 'success'});", true);

                    LoadApprovalList(docNo);

                    // Send email to next approver if not fully approved
                    if (document.status.Value < maxStatus)
                    {
                        string nextApprover = GetExpectedApprover(document.type.Value, document.status.Value + 1, db);
                        if (!string.IsNullOrEmpty(nextApprover))
                        {
                            SendApprovalEmail(docNo, nextApprover);
                        }
                        else
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "NoNextApproverError",
                                "Swal.fire({title: '⚠️ Warning', text: 'No next approver found in the database. Please contact the system administrator.', icon: 'warning'});", true);
                        }
                    }
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "SaveError",
                        $"Swal.fire({{title: '❌ Error', text: 'Failed to save approval: {ex.Message}', icon: 'error'}});", true);
                }
            }
        }

        private List<string> GetApprovalRequirements(int documentType)
        {
            switch (documentType)
            {
                case 2:  // Scrap: PC → BOI → GA (3 approvals after creator)
                    return new List<string> { "PC", "BOI", "GA" };
                case 3:  // Assets: DIR → GA (2 approvals after creator)
                    return new List<string> { "DIR", "GA" };
                case 4:  // Accessories: PC → PD → GA (3 approvals after creator)
                    return new List<string> { "PC", "PD", "GA" };
                case 5:  // Waste: SAFETY → GAAC → GA (3 approvals after creator)
                    return new List<string> { "SAFETY", "GAAC", "GA" };
                case 6:  // Others: PD → GAAC → GA (3 approvals after creator)
                    return new List<string> { "PD", "GAAC", "GA" };
                default: // Fallback
                    return new List<string> { "PC", "BOI", "GA" };
            }
        }

        private string GetExpectedApprover(int documentType, int status, gatepassEntities db)
        {
            var approvalFlow = db.approveflows.FirstOrDefault(af => af.type == documentType);
            if (approvalFlow == null) return null;

            // Status 1 is creator approval (already done)
            var requirements = GetApprovalRequirements(documentType);
            int approvalIndex = status - 2; // -2 because status starts at 1 (creator) and array is 0-based

            if (approvalIndex < 0 || approvalIndex >= requirements.Count)
                return null;

            string requiredDepartment = requirements[approvalIndex];

            // Map department to email field
            switch (requiredDepartment)
            {
                case "PC": return approvalFlow.PC_email;
                case "BOI": return approvalFlow.BOI_email;
                case "DIR": return approvalFlow.DIR_email;
                case "GA": return approvalFlow.GA_email;
                case "PD": return approvalFlow.PD_email;
                case "SAFETY": return approvalFlow.SAFETY_email;
                case "GAAC": return approvalFlow.GAAC_email;
                default: return null;
            }
        }

        private string GetDepartmentFromApprovalFlow(string email, int documentType, gatepassEntities db)
        {
            var approvalFlow = db.approveflows.FirstOrDefault(af => af.type == documentType);
            if (approvalFlow == null) return "Unknown";

            if (email == approvalFlow.PC_email) return "PC";
            else if (email == approvalFlow.BOI_email) return "BOI";
            else if (email == approvalFlow.DIR_email) return "DIR";
            else if (email == approvalFlow.GA_email) return "GA";
            else if (email == approvalFlow.PD_email) return "PD";
            else if (email == approvalFlow.SAFETY_email) return "SAFETY";
            else if (email == approvalFlow.GAAC_email) return "GAAC";
            else return "Unknown";
        }
        private void LoadApprovalList(string docNo)
        {
            using (gatepassEntities db = new gatepassEntities())
            {
                var approvalList = db.approvals
                    .Where(a => a.doc_no == docNo)
                    .OrderBy(a => a.approved_at)
                    .ToList()
                    .Select(a => new
                    {
                        Approver = a.approver_name,
                        ApprovedAt = a.approved_at.HasValue
                            ? a.approved_at.Value.ToString("yyyy-MM-dd HH:mm")
                            : "N/A",
                        Approver_department = a.approver_department
                    })
                    .ToList();

                gvApprovalList.DataSource = approvalList;
                gvApprovalList.DataBind();
            }
        }


        private void SendApprovalEmail(string docNo, string toEmail)
        {
            // **Fix 4: Use a system email or current approver’s email instead of Session["UserEmail"] if appropriate**
            string userEmail = (Session["UserEmail"] as string)?.Trim() ?? "gatepass-system@nidec.com"; // Fallback to system email
            var document = db.headings.FirstOrDefault(h => h.doc_no == docNo);
            if (document == null) return;

            string subject = $"Approval Notification for Document {docNo}";
            string approvalLink = $"https://localhost:44352/Approve1.aspx?doc_no={docNo}";
            string body = $@"
Dear User,

The document with Document No: {document.doc_no} has been submitted for approval.

Please click the link below to review and approve:
{approvalLink}

Document Details:
- Doc No: {document.doc_no}
- Date & Time Created: {document.date?.ToString("yyyy-MM-dd HH:mm:ss") ?? "N/A"}
- Requester: {document.name}
- Company: {document.company}
- To Factory: {document.factory}

This is an automated message from the Gatepass System.
";

            using (MailMessage mail = new MailMessage())
            {
                mail.From = new MailAddress(userEmail);
                mail.To.Add(toEmail);
                mail.Subject = subject;
                mail.Body = body;
                mail.IsBodyHtml = false;

                using (SmtpClient smtpServer = new SmtpClient())
                {
                    smtpServer.Host = "10.231.2.98";
                    smtpServer.Port = 25;
                    smtpServer.DeliveryMethod = SmtpDeliveryMethod.Network;
                    smtpServer.Send(mail);
                }
            }
        }

        private string GetTypeName(int type)
        {
            switch (type)
            {
                case 2: return "Scrap";
                case 3: return "Assets";
                case 4: return "Accessories";
                case 5: return "Waste";
                case 6: return "Others";
                default: return "Unknown";
            }
        }
    }
}