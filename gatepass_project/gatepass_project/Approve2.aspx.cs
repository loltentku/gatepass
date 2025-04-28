using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Net;
using System.IO;
using System.Linq;

namespace gatepass_project
{
    public partial class Approve2 : System.Web.UI.Page
    {
        private gatepassEntities db = new gatepassEntities();
        private string host = "http://10.231.2.34/nidec/login/API/authenticate_flowlites.php";
        private string email = string.Empty; // Store email from link

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string docNo = Request.QueryString["doc_no"] ?? string.Empty;
                email = Request.QueryString["email"] ?? txtApproverEmail.Text; // Use textbox if query string is empty

                if (string.IsNullOrEmpty(docNo))
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                LoadFormData(docNo);
                LoadItemList(docNo);
                LoadApprovalList(docNo);

                ddlCompany.Enabled = false;

                int approvalCount = db.approvals.Count(a => a.doc_no == docNo);
                lblApprovalCount.Text = approvalCount.ToString();
                progressBar.Style["width"] = $"{approvalCount * 50}%";

                btnApprove.Visible = true;
                btnApprove.Enabled = true;
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
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "NoDocumentError",
                    "Swal.fire({title: '❌ Error', text: 'Document not found.', icon: 'error'});", true);
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

        protected void btnApprove_Click(object sender, EventArgs e)
        {
            string docNo = Request.QueryString["doc_no"];
            if (string.IsNullOrEmpty(docNo))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "NoDocNoError",
                    "Swal.fire({title: '❌ Error', text: 'No document number provided.', icon: 'error'});", true);
                return;
            }

            // Use email from textbox if query string didn’t provide it
            string email = !string.IsNullOrEmpty(Request.QueryString["email"]) ? Request.QueryString["email"] : txtApproverEmail.Text;
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

                var existingApproval = db.approvals.FirstOrDefault(a => a.doc_no == docNo && a.approver_name == email);
                if (existingApproval != null)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "AlreadyApprovedError",
                        "Swal.fire({title: '❌ Already Approved', text: 'You have already approved this document.', icon: 'error'});", true);
                    return;
                }

                const int maxStatus = 2;


                if (document.status.HasValue && document.status.Value >= maxStatus)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "FullyApproved",
                        $"Swal.fire({{title: '✅ Fully Approved', text: 'This document has received all required approvals ({maxStatus}).', icon: 'success'}}).then(() => {{ window.location.href = 'Login.aspx'; }});", true);
                    return;
                }


                // Check if the email matches an entry in approveflow where type = 1
                var approvedEmail = db.approveflows.FirstOrDefault(a => a.PC_email == email && a.type == 1);
                if (approvedEmail == null)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "InvalidEmailError",
                        "Swal.fire({title: '❌ Error', text: 'The email provided is not authorized for approval.', icon: 'error'});", true);
                    return;
                }

                document.status = (document.status.HasValue ? document.status.Value : 0) + 1;

                var newApproval = new approval
                {
                    doc_no = docNo,
                    approver_name = email,
                    approver_department = "PC",
                    approved_at = DateTime.Now
                };
                db.approvals.Add(newApproval);

                try
                {
                    db.SaveChanges();
                    ScriptManager.RegisterStartupScript(this, GetType(), "ApprovalSuccess",
                        "Swal.fire({title: '✅ Approved', text: 'Your approval has been recorded.', icon: 'success'});", true);

                    lblApprovalCount.Text = document.status.Value.ToString();
                    progressBar.Style["width"] = $"{document.status.Value * 50}%";
                    LoadApprovalList(docNo);
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "SaveError",
                        $"Swal.fire({{title: '❌ Error', text: 'Failed to save approval: {ex.Message}', icon: 'error'}});", true);
                    return;
                }
            }
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

    }
}