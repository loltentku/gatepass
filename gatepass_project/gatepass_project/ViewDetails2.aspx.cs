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
    public partial class ViewDetails2 : System.Web.UI.Page
    {
        private gatepassEntities db = new gatepassEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string userDepartment = Session["UserDepartment"] as string ?? "";
                string userEmail = (Session["UserEmail"] as string)?.Trim() ?? "";
                string formType = Request.QueryString["formType"] ?? "-1";
                lnkBackToDocuments.NavigateUrl = $"ViewDocuments.aspx?formType={formType}";
                string docNo = Request.QueryString["doc_no"] ?? (Session["DocNo"] as string) ?? "";

                if (!string.IsNullOrEmpty(docNo))
                {
                    Session["DocNo"] = docNo; // Ensure docNo is stored in session for later use

                    LoadFormData(docNo);
                    LoadItemList(docNo);
                    LoadApprovalList();

                    ddlCompany.Enabled = false;

                    int approvalCount = int.TryParse(lblApprovalCount.Text, out int count) ? count : 0;
                    progressBar.Style["width"] = $"{approvalCount * 50}%";

                    if (Session["UserRole"] != null)
                    {
                        string userRole = Session["UserRole"].ToString().ToLower();
                        string adminUser = Session["AdminUser"] as string ?? "";

                        if (userRole == "security")
                        {
                            if (Session["UserFactory"] != null)
                            {
                                string userFactory = Session["UserFactory"].ToString();
                                var document = db.headings.FirstOrDefault(h => h.doc_no == docNo);

                                if (document != null)
                                {
                                    bool matchFactory = userFactory.Equals(document.factory, StringComparison.OrdinalIgnoreCase);
                                    bool matchCompany = userFactory.Equals(document.company, StringComparison.OrdinalIgnoreCase);
                                }
                            }
                        }

                        if (userRole == "manager" || userRole == "creator" || userRole == "admin")
                        {
                            string userFactory = Session["UserFactory"]?.ToString() ?? "";
                            var document = db.headings.FirstOrDefault(h => h.doc_no == docNo);

                            if (document != null)
                            {
                                bool matchFactory = !string.IsNullOrEmpty(userFactory) && userFactory.Equals(document.factory, StringComparison.OrdinalIgnoreCase);

                                // Check if the current user (admin, manager, or creator) created the document
                                if (Session["AdminUser"] != null && document.name.Equals(adminUser, StringComparison.OrdinalIgnoreCase))
                                {
                                    btnApprove.Visible = true;
                                }
                                else if (userRole == "manager" && matchFactory) // Managers can approve if factory matches
                                {
                                    btnApprove.Visible = true;
                                }
                                else if (userRole == "creator") // Creators can always approve
                                {
                                    btnApprove.Visible = true;
                                }
                                else
                                {
                                    btnApprove.Visible = false;
                                }
                            }
                            else
                            {
                                btnApprove.Visible = false;
                            }
                        }
                        else
                        {
                            btnApprove.Visible = false;
                        }
                    }
                    else
                    {
                        btnApprove.Visible = false;
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
                txtTimeout.Text = document.time_out?.ToString(@"hh\:mm") ?? "";
                ddlCompany.SelectedValue = document.company;

               
                txtAddress.Text = document.address;
                txtAsset.Text = document.asset_no;
                int approvalCount = db.approvals.Count(a => a.doc_no == docNo);
                lblApprovalCount.Text = approvalCount.ToString();

                if (document.factory == "NETL") rbNETL.Checked = true;
                else if (document.factory == "NETR") rbNETR.Checked = true;
                else if (document.factory == "NPTA") rbNPTA.Checked = true;
                else if (document.factory == "NPTR") rbNPTR.Checked = true;
                else if (document.factory == "NCOT") rbNCOT.Checked = true;
                else if (document.factory == "NDCT") rbNDCT.Checked = true;
                else if (document.factory == "NDCC") rbNDCC.Checked = true;

                if (document.return_date != null)
                {
                    rbReturnWithDate.Checked = true;
                    noReturn.Checked = false;
                    returnDate.Value = document.return_date.Value.ToString("yyyy-MM-dd");
                    returnDate.Disabled = false;
                }
                else
                {
                    noReturn.Checked = true;
                    rbReturnWithDate.Checked = false;
                    returnDate.Value = "";
                    returnDate.Disabled = true;
                }

                LockFormControls();
            }
        }

        private void LockFormControls()
        {
            txtDocNo.Enabled = false;
            txtDate.Enabled = false;
            txtName.Enabled = false;
            txtTimeout.Enabled = false;
            rbNDCT.Enabled = false;
            rbNDCC.Enabled = false;
            rbNCOT.Enabled = false;
            rbNETL.Enabled = false;
            rbNETR.Enabled = false;
            rbNPTA.Enabled = false;
            rbNPTR.Enabled = false;
            noReturn.Enabled = false;
            rbReturnWithDate.Enabled = false;
            ddlCompany.Enabled = false;
            returnDate.Disabled = true;
        }

        private void LoadItemList(string docNo)
        {
            var items = db.detail_pass.Where(d => d.doc_no == docNo).ToList();

            if (items.Any())
            {
                DataTable dt = new DataTable();
                dt.Columns.Add("Invoice no.");
                dt.Columns.Add("Description");
                dt.Columns.Add("Quantity");
                dt.Columns.Add("Purpose");
                dt.Columns.Add("image_url");
                foreach (var item in items)
                {
                    DataRow dr = dt.NewRow();
                    dr["Invoice no."] = item.invoice_no;
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
                int rowIndex = e.Row.RowIndex + 1;
                Label lblRowNumber = (Label)e.Row.FindControl("lblRowNumber");
                if (lblRowNumber != null)
                {
                    lblRowNumber.Text = rowIndex.ToString();
                }
            }
        }

        private void LoadApprovalList()
        {
            string docNo = Session["DocNo"] as string ?? Request.QueryString["doc_no"];
            if (!string.IsNullOrEmpty(docNo))
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
        }

        protected void btnApprove_Click(object sender, EventArgs e)
        {
            string docNo = Request.QueryString["doc_no"] ?? (Session["DocNo"] as string) ?? "";
            if (!string.IsNullOrEmpty(docNo) && Session["AdminUser"] != null)
            {
                string username = Session["AdminUser"].ToString(); // Assuming this is the unique identifier for the user
                string userDepartment = Session["UserDepartment"] as string ?? "";
                string userEmail = (Session["UserEmail"] as string)?.Trim() ?? "";

                using (gatepassEntities db = new gatepassEntities())
                {
                    var document = db.headings.FirstOrDefault(h => h.doc_no == docNo);
                    var existingApproval = db.approvals.FirstOrDefault(a => a.doc_no == docNo && a.approver_name == userEmail); // Check by email for consistency

                    if (document == null)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "ErrorAlert",
                            "Swal.fire({title: '❌ Document Not Found', text: 'The document could not be found.', icon: 'error'});", true);
                        return;
                    }

                    // Check if this user has already approved the document
                    if (existingApproval != null)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "AlreadyApprovedAlert",
                            "Swal.fire({title: '❌ Already Approved', text: 'You have already approved this document. Only one approval per person is allowed.', icon: 'error'});", true);
                        return;
                    }

                    // Check if the document has reached maximum approvals
                    const int maxStatus = 2;
                    if (document.status.HasValue && document.status.Value >= maxStatus)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "FullApprovalAlert",
                            "Swal.fire({title: '✅ Fully Approved', text: 'This document has received the maximum approvals (2).', icon: 'success'});", true);
                        return;
                    }

                    // Proceed with approval
                    int previousStatus = document.status.HasValue ? document.status.Value : 0;
                    document.status = previousStatus + 1;

                    var newApproval = new approval
                    {
                        doc_no = docNo,
                        approver_name = userEmail, // Store the email for consistency
                        approved_at = DateTime.Now,
                        approver_department = userDepartment
                    };

                    db.approvals.Add(newApproval);

                    // Fetch PC_email from approveflow table where type = 1
                    string sessionDocNo = Session["DocNo"] as string;
                    var pcEmail = db.approveflows
                                    .Where(af => af.type == 1) // Filter where type is 1
                                    .Select(af => af.PC_email)
                                    .FirstOrDefault();

                    if (!string.IsNullOrEmpty(pcEmail))
                    {
                        try
                        {
                            SendApprovalEmail(docNo, pcEmail);
                            ScriptManager.RegisterStartupScript(this, GetType(), "EmailSentAlert",
                                "Swal.fire({title: '📧 Email Sent', text: 'An approval notification has been sent to PC.', icon: 'info'});", true);
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
                            "Swal.fire({title: '⚠️ No Email Found', text: 'No PC email found', icon: 'warning'});", true);
                    }

                    db.SaveChanges();

                    ScriptManager.RegisterStartupScript(this, GetType(), "SuccessAlert",
                        "Swal.fire({title: '✅ Approved', text: 'Your approval has been recorded.', icon: 'success'});", true);

                    lblApprovalCount.Text = document.status.Value.ToString();
                    progressBar.Style["width"] = $"{document.status.Value * 50}%";
                    LoadApprovalList();
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "ErrorAlert",
                    "Swal.fire({title: '❌ Invalid Session', text: 'User session is invalid or document number is missing.', icon: 'error'});", true);
            }
        }
        private void SendApprovalEmail(string docNo, string toEmail)
        {
            string userEmail = (Session["UserEmail"] as string)?.Trim() ?? "";

            var document = db.headings.FirstOrDefault(h => h.doc_no == docNo);
            if (document == null) return;

            string subject = $"Approval Notification for Document {docNo}";
            string approvalLink = $"https://localhost:44352/Approve2.aspx?doc_no={docNo}";
            string body = $@"
Dear PC Team,

Please review the details and approve the documents:
{approvalLink}

Document Details:
- Doc No: {document.doc_no}
- Date & Time Created: {document.date?.ToString("yyyy-MM-dd HH:mm:ss") ?? "N/A"}
- Requester: {document.name}
- Company: {document.company}
- To Factory: {document.factory}

This is an automated message from the Gatepass System.

Regards
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
                    smtpServer.Host = "10.231.2.98"; // Your SMTP server
                    smtpServer.Port = 25; // Or adjust as needed
                    smtpServer.DeliveryMethod = SmtpDeliveryMethod.Network;

                    try
                    {
                        smtpServer.Send(mail);
                    }
                    catch (SmtpException ex)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "EmailError",
                            $"Swal.fire({{title: '❌ Email Error', text: 'Failed to send email: {ex.Message}', icon: 'error'}});", true);
                        System.Diagnostics.Debug.WriteLine($"SMTP Error: {ex.Message}");
                    }
                    catch (Exception ex)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "GeneralError",
                            $"Swal.fire({{title: '❌ General Error', text: 'An unexpected error occurred: {ex.Message}', icon: 'error'}});", true);
                        System.Diagnostics.Debug.WriteLine($"General Error: {ex.Message}");
                    }
                }
            }
        }
    }
}