using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Collections.Generic;
using System.Net.Mail;
using System.Net;
namespace gatepass_project
{
    public partial class ViewDetails : Page
    {
        private gatepassEntities db = new gatepassEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            string userRole = (Session["UserRole"] as string)?.Trim() ?? "";
            string userFactory = (Session["UserFactory"] as string)?.Trim() ?? "";
            string userDepartment = (Session["UserDepartment"] as string)?.Trim() ?? "";

            if (!IsPostBack)
            {
                string formType = Request.QueryString["formType"] ?? "-1";
                lnkBackToDocuments.NavigateUrl = $"ViewDocuments.aspx?formType={formType}";
                string docNo = Request.QueryString["doc_no"];

                if (!string.IsNullOrEmpty(docNo))
                {
                    LoadFormData(docNo);
                    LoadItemList(docNo);
                    LoadApprovalList();
                    ddlFactory.Enabled = false;
                    ddlCompany.Enabled = false;
                    ddlItemType.Enabled = false;

                    // Calculate progress bar dynamically
                    int approvalCount = int.TryParse(lblApprovalCount.Text, out int count) ? count : 0;
                    var document = db.headings.FirstOrDefault(h => h.doc_no == docNo);
                    int maxStatus = document != null ? GetMaxStatus(document.type) : 4;
                    progressBar.Style["width"] = $"{(approvalCount * 100) / maxStatus}%";

                    if (Session["UserRole"] != null && Session["AdminUser"] != null)
                    {
                        string currentUser = Session["AdminUser"].ToString();
                        document = db.headings.FirstOrDefault(h => h.doc_no == docNo);

                        if (document != null)
                        {
                            bool matchFactory = userFactory.Equals(document.factory, StringComparison.OrdinalIgnoreCase);
                            bool isCreator = document.name.Equals(currentUser, StringComparison.OrdinalIgnoreCase);

                            // Set visibility based on role
                            switch (userRole.ToLower())
                            {
                                case "admin":
                                    btnApprove.Visible = isCreator;
                                    break;
                                case "manager":
                                    btnApprove.Visible = matchFactory;
                                    break;
                                case "creator":
                                    btnApprove.Visible = true;
                                    break;
                                default:
                                    btnApprove.Visible = false;
                                    break;
                            }
                        }
                        else
                        {
                            btnApprove.Visible = false;
                        }
                    }
                    else
                    {
                        Response.Redirect("Login.aspx");
                    }
                }
                else
                {
                    Response.Redirect("ViewDocuments.aspx");
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
                int approvalCount = db.approvals.Count(a => a.doc_no == docNo);
                lblApprovalCount.Text = approvalCount.ToString();
                lblMaxApproval.Text = GetMaxStatus(document.type).ToString(); // Set max approval

                // Corrected item type loading with reverse mapping from integer to string
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
                            ddlItemType.SelectedIndex = 0;
                            break;
                    }
                }
                else
                {
                    ddlItemType.SelectedIndex = 0;
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
                int rowIndex = e.Row.RowIndex + 1; //Start numbering from 1
                Label lblRowNumber = (Label)e.Row.FindControl("lblRowNumber");
                if (lblRowNumber != null)
                {
                    lblRowNumber.Text = rowIndex.ToString(); // Assign row number
                }
            }
        }
        protected void btnApprove_Click(object sender, EventArgs e)
        {
            string docNo = Request.QueryString["doc_no"];
            if (!string.IsNullOrEmpty(docNo) && Session["AdminUser"] != null)
            {
                string username = Session["AdminUser"].ToString().Trim() ?? "";
                string userDepartment = Session["UserDepartment"] as string ?? "";
                string userEmail = (Session["UserEmail"] as string)?.Trim() ?? "";

                using (gatepassEntities db = new gatepassEntities())
                {
                    var document = db.headings.FirstOrDefault(h => h.doc_no == docNo);
                    var existingApproval = db.approvals.FirstOrDefault(a => a.doc_no == docNo && a.approver_name == userEmail);

                    if (document != null)
                    {
                        // Check if the current user is the document creator
                        if (!document.name.Equals(username, StringComparison.OrdinalIgnoreCase))
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "UnauthorizedAlert",
                                "Swal.fire({title: '❌ Unauthorized', text: 'Only the document creator can approve this document.', icon: 'error'});", true);
                            return;
                        }

                        // Check if the user has already approved
                        if (existingApproval != null)
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "ErrorAlert",
                                "Swal.fire({title: '❌ Already Approved', text: 'You have already approved this document.', icon: 'error'});", true);
                            return;
                        }

                        // Set status to 1 (assuming this is the initial approval)
                        document.status = 1;

                        // Define the maximum status (e.g., fully approved at 4)
                        const int maxStatus = 4;

                        // Check the current status
                        int previousStatus = document.status.HasValue ? document.status.Value : 0;

                        // Handle specific document types only when status is 1
                        if (document.type.HasValue && document.status.Value == 1) // Only proceed if status is 1
                        {
                            string emailToSendTo = null;
                            string typeName = GetTypeName(document.type.Value);

                            // Determine the email recipient based on type
                            switch (document.type.Value)
                            {
                                case 2: // Scrap
                                    emailToSendTo = db.approveflows
                                        .FirstOrDefault(af =>af.type == 2)?
                                        .PC_email;
                                    break;

                                case 3: // Assets
                                    emailToSendTo = db.approveflows
                                        .FirstOrDefault(af =>af.type == 3)?
                                        .DIR_email;
                                    break;

                                case 4: // Accessories
                                    emailToSendTo = db.approveflows
                                        .FirstOrDefault(af => af.type == 4)?
                                        .PC_email;
                                    break;

                                case 5: // Waste
                                    emailToSendTo = db.approveflows
                                        .FirstOrDefault(af => af.type == 5)?
                                        .SAFETY_email;
                                    break;

                                case 6: // Others
                                    emailToSendTo = db.approveflows
                                        .FirstOrDefault(af => af.type == 6)?
                                        .PD_email;
                                    break;

                                default:
                                    ScriptManager.RegisterStartupScript(this, GetType(), "InvalidTypeAlert",
                                        $"Swal.fire({{title: '❌ Invalid Type', text: 'Unknown document type: {typeName}', icon: 'error'}});", true);
                                    return;
                            }

                            // Check if email address was found
                            if (!string.IsNullOrEmpty(emailToSendTo))
                            {
                                // Insert new approval record
                                var newApproval = new approval
                                {
                                    doc_no = docNo,
                                    approver_name = userEmail,
                                    approved_at = DateTime.Now,
                                    approver_department = userDepartment
                                };
                                db.approvals.Add(newApproval);

                                // Send email to the determined recipient
                                try
                                {
                                    SendApprovalEmail(docNo, emailToSendTo);
                                    ScriptManager.RegisterStartupScript(this, GetType(), "EmailSentAlert",
                                        $"Swal.fire({{title: '📧 Email Sent', text: 'An approval notification has been sent to the {typeName} approver.', icon: 'info'}});", true);
                                }
                                catch (Exception ex)
                                {
                                    ScriptManager.RegisterStartupScript(this, GetType(), "EmailError",
                                        $"Swal.fire({{title: '❌ Email Error', text: 'Failed to send email: {ex.Message}', icon: 'error'}});", true);
                                }
                            }
                            else
                            {
                                ScriptManager.RegisterStartupScript(this, GetType(), "NoEmailAlert",
                                    $"Swal.fire({{title: '❌ No Email', text: 'No email address found for {typeName} approver.', icon: 'error'}});", true);
                                return;
                            }
                        }
                        else
                        {
                            // For non-status-1 or other cases, use default logic
                            if (previousStatus >= maxStatus)
                            {
                                ScriptManager.RegisterStartupScript(this, GetType(), "FullApprovalAlert",
                                    "Swal.fire({title: '✅ Fully Approved', text: 'This document has received the maximum approvals.', icon: 'success'});", true);
                            }
                            else
                            {
                                document.status = previousStatus + 1;

                                // Insert new approval record
                                var newApproval = new approval
                                {
                                    doc_no = docNo,
                                    approver_name = username,
                                    approved_at = DateTime.Now,
                                    approver_department = userDepartment
                                };
                                db.approvals.Add(newApproval);

                               
                            }
                        }

                        // Save changes to the database
                        db.SaveChanges();

                        // Update UI

                        ScriptManager.RegisterStartupScript(this, GetType(), "SuccessAlert",
                            "Swal.fire({title: '✅ Approved', text: 'Your approval has been recorded.', icon: 'success'});", true);

                        lblApprovalCount.Text = document.status.Value.ToString();
                        ScriptManager.RegisterStartupScript(this, GetType(), "UpdateApprovalCount",
                            $"document.getElementById('{lblApprovalCount.ClientID}').innerText = '{document.status.Value}';", true);
                        progressBar.Style["width"] = $"{(document.status.Value * 100) / maxStatus}%"; // Dynamic progress bar
                        LoadApprovalList();
                    }
                }
            }
        }
        private int GetMaxStatus(int? type)
        {
            if (!type.HasValue) return 4; // Default to 4 if type is null
            return type.Value == 3 ? 3 : 4; // Type 3 (Assets) has maxStatus 3, others have 4
        }

        private void LoadApprovalList()
        {   
            string docNo = Request.QueryString["doc_no"];
            if (!string.IsNullOrEmpty(docNo))
            {
                using (gatepassEntities db = new gatepassEntities())
                {
                    // ✅ Fetch Data First (Without ToString)
                    var approvalList = db.approvals
                        .Where(a => a.doc_no == docNo)
                        .OrderBy(a => a.approved_at)
                        .ToList() // 
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
       
    }
      
        private void SendApprovalEmail(string docNo, string toEmail)
        {
            string userEmail = (Session["UserEmail"] as string)?.Trim() ?? "";
            var document = db.headings.FirstOrDefault(h => h.doc_no == docNo);
            if (document == null) return;

            string subject = $"Approval Notification for Document {docNo}";
            string approvalLink = $"https://localhost:44352/Approve1.aspx?doc_no={docNo}";
            string body = $@"
Dear User,

The document with Document No: {document.doc_no} has been submitted for approval.

Please click the link below to review and approve the document:
{approvalLink}

Document Details:
- Doc No: {document.doc_no}
- Date & Time Created: {document.date?.ToString("yyyy-MM-dd HH:mm:ss") ?? "N/A"}
- Requester: {document.name}
- Company: {document.company}
- To Factory: {document.factory}

This is an automated message from the Gatepass System.

Regards,
";

            using (MailMessage mail = new MailMessage())
            {
                mail.From = new MailAddress(userEmail); // Sender email (replace if needed)
                mail.To.Add(toEmail); // Recipient email
                mail.Subject = subject; // Email subject
                mail.Body = body; // Email body
                mail.IsBodyHtml = false; // Plain text email

                using (SmtpClient smtpServer = new SmtpClient())
                {
                    smtpServer.Host = "10.231.2.98"; // Internal SMTP server
                    smtpServer.Port = 25; // Port for SMTP (no SSL)
                    smtpServer.DeliveryMethod = SmtpDeliveryMethod.Network; // Direct network delivery

                    // No credentials or SSL needed if the server allows anonymous relay or is internal
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
