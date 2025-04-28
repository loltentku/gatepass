using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;

namespace gatepass_project
{
    public partial class ViewDocuments : Page
    {
        private gatepassEntities db = new gatepassEntities();

        private string SortDirection
        {
            get { return ViewState["SortDirection"] as string ?? "ASC"; }
            set { ViewState["SortDirection"] = value; }
        }

        private string SortExpression
        {
            get { return ViewState["SortExpression"] as string ?? "date"; }
            set { ViewState["SortExpression"] = value; }
        }

        // Updated method to determine approval status based on type
        private string GetApprovalStatus(int? type, int? status)
        {
            if (!type.HasValue || !status.HasValue) return "Pending"; // Default to Pending if type or status is null

            int requiredApprovals;
            switch (type.Value)
            {
                case 1: // Finished Goods
                    requiredApprovals = 2;
                    break;
                case 2: // Scrap
                case 4: // Accessories
                case 5: // Waste
                case 6: // Others
                    requiredApprovals = 4;
                    break;
                case 3: // Assets
                    requiredApprovals = 3;
                    break;
                default:
                    requiredApprovals = 4; // Default for unknown types
                    break;
            }

            return status.Value >= requiredApprovals ? "Approved" : "Pending";
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminUser"] == null)
            {
                lblUserName.Text = "<a href='Login.aspx' class='text-white font-weight-bold'>🔑 Login</a>";
                btnCreateForm1.Enabled = false;
                btnCreateForm2.Enabled = false;
                btnManageUsers.Visible = false;
                Response.Redirect("Login.aspx");
            }
            else
            {
                string fullName = Session["AdminUser"].ToString();
                if (fullName == "Guest")
                {
                    lblUserName.Text = "<a href='Login.aspx' class='text-white font-weight-bold'>🔑 Login</a>";
                    btnCreateForm1.Enabled = false;
                    btnCreateForm2.Enabled = false;
                    btnManageUsers.Visible = false;
                }
                else
                {
                    string userRole = Session["UserRole"] as string ?? "";
                    string userFactory = Session["UserFactory"] as string ?? "";
                    string userDepartment = Session["UserDepartment"] as string ?? "";
                    lblUserName.Text = $"USER: {fullName} ROLE: {userRole} FACTORY: {userFactory} DEPARTMENT: {userDepartment} <a href='#' onclick='logoutUser();' class='logout-link'> Logout</a>";

                    if (userRole.ToLower() == "security" || userRole.ToLower() == "warehouse")
                    {
                        btnCreateForm1.Enabled = false;
                        btnCreateForm2.Enabled = false;
                        btnManageUsers.Visible = false;
                    }
                    else if (userRole.ToLower() == "creator")
                    {
                        btnCreateForm1.Enabled = true;
                        btnCreateForm2.Enabled = true;
                        btnManageUsers.Visible = true;
                    }
                    else
                    {
                        btnCreateForm1.Enabled = true;
                        btnCreateForm2.Enabled = true;
                        btnManageUsers.Visible = false;
                    }
                }
            }

            if (!IsPostBack)
            {
                int formType;
                if (!int.TryParse(Request.QueryString["formType"], out formType))
                {
                    formType = -1; // Default to "All"
                }

                hiddenFormType.Value = formType.ToString();
                ddlFormType.SelectedValue = formType.ToString();

                SortExpression = "doc_no";
                SortDirection = "DESC";
                LoadDocuments("", SortExpression, SortDirection, formType);
            }
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            int formType = -1;
            if (!string.IsNullOrEmpty(hiddenFormType.Value))
            {
                int.TryParse(hiddenFormType.Value, out formType);
            }
            SortExpression = "doc_no";
            SortDirection = "DESC";
            LoadDocuments("", SortExpression, SortDirection, formType);
        }

        protected string ShowEditButton(string docNo, int formType)
        {
            string userRole = Session["UserRole"] as string ?? "";
            string adminUser = Session["AdminUser"] as string ?? "";

            if (Session["AdminUser"] != null && adminUser != "Guest")
            {
                if (userRole.ToLower() == "security" || userRole.ToLower() == "warehouse")
                {
                    return "";
                }

                if (userRole.ToLower() == "admin")
                {
                    var document = db.headings.FirstOrDefault(d => d.doc_no == docNo);
                    if (document != null && document.name.Trim() == adminUser.Trim())
                    {
                        string editPage = formType == 2 ? "EditDetails2.aspx" : "EditDetails.aspx";
                        return $"<a href='{editPage}?doc_no={docNo}' class='btn btn-warning btn-sm mx-1'>🖊️ Edit</a>";
                    }
                    return "";
                }

                string editPageForOthers = formType == 2 ? "EditDetails2.aspx" : "EditDetails.aspx";
                return $"<a href='{editPageForOthers}?doc_no={docNo}' class='btn btn-warning btn-sm mx-1'>🖊️ Edit</a>";
            }
            return "";
        }

        protected string ShowDeleteButton(string docNo)
        {
            string userRole = Session["UserRole"] as string ?? "";
            string adminUser = Session["AdminUser"] as string ?? "";
            string userFactory = Session["UserFactory"]?.ToString().Trim() ?? "";

            if (Session["AdminUser"] == null || adminUser == "Guest")
            {
                return "";
            }

            using (var db = new gatepassEntities())
            {
                var document = db.headings.FirstOrDefault(h => h.doc_no == docNo);
                if (document == null) return "";

                if (userRole.ToLower() == "manager" && !string.IsNullOrEmpty(userFactory))
                {
                    bool matchFactory = userFactory.Equals(document.factory?.Trim(), StringComparison.OrdinalIgnoreCase);
                    if (matchFactory)
                    {
                        return $"<a href='#' onclick='deleteDocument(\"{docNo}\"); return false;' class='btn btn-danger btn-sm mx-1'>🗑️ Delete</a>";
                    }
                }
                else if (userRole.ToLower() == "creator")
                {
                    return $"<a href='#' onclick='deleteDocument(\"{docNo}\"); return false;' class='btn btn-danger btn-sm mx-1'>🗑️ Delete</a>";
                }
                else if (userRole.ToLower() == "admin" && document.name == adminUser)
                {
                    return $"<a href='#' onclick='deleteDocument(\"{docNo}\"); return false;' class='btn btn-danger btn-sm mx-1'>🗑️ Delete</a>";
                }
            }
            return "";
        }

        protected string ShowViewButton(string docNo, int formType)
        {
            string viewPage = formType == 1 ? "ViewDetails.aspx" : "ViewDetails2.aspx";
            return $"<a href='{viewPage}?doc_no={docNo}' class='btn btn-info btn-sm mx-1'>🔍 View</a>";
        }

        private void LoadDocuments(string searchQuery = "", string sortExpression = "date", string sortDirection = "ASC", int formType = -1)
        {
            var documents = db.headings
                .Where(d => string.IsNullOrEmpty(searchQuery) ||
                            d.doc_no.Contains(searchQuery) ||
                            d.name.Contains(searchQuery) ||
                            d.company.Contains(searchQuery) ||
                            d.factory.Contains(searchQuery));

            string adminUser = Session["AdminUser"] as string ?? "";
            string userRole = (Session["UserRole"] as string ?? "").ToLower();
            string userFactory = (Session["UserFactory"] as string ?? "").Trim();

            if ((userRole == "security" || userRole == "admin" || userRole == "manager") && !string.IsNullOrEmpty(userFactory))
            {
                documents = documents.Where(d => d.factory.Trim() == userFactory);
            }

            if (formType == 1 || formType == 2)
            {
                documents = documents.Where(d => d.formtype == formType);
            }

            switch (sortExpression)
            {
                case "doc_no":
                    documents = sortDirection == "ASC" ? documents.OrderBy(d => d.doc_no) : documents.OrderByDescending(d => d.doc_no);
                    break;
                case "date":
                    documents = sortDirection == "ASC" ? documents.OrderBy(d => d.date) : documents.OrderByDescending(d => d.date);
                    break;
                case "status":
                    documents = sortDirection == "ASC" ? documents.OrderBy(d => d.status) : documents.OrderByDescending(d => d.status);
                    break;
                default:
                    documents = documents.OrderByDescending(d => d.date);
                    break;
            }

            var docList = documents.ToList();

            if (docList.Count > 0)
            {
                gvDocuments.DataSource = docList.Select(d => new
                {
                    d.doc_no,
                    name = d.name,
                    factory = d.factory,
                    company = d.company,
                    date = d.date,
                    type = GetTypeString(d.type),
                    d.formtype,
                    d.checkin_status,
                    d.checkout_status,
                    ApprovalStatus = GetApprovalStatus(d.type, d.status), // Use type instead of formtype
                    EditButton = ShowEditButton(d.doc_no, d.formtype),
                    DeleteButton = ShowDeleteButton(d.doc_no),
                    ViewButton = ShowViewButton(d.doc_no, d.formtype)
                }).ToList();

                gvDocuments.DataBind();
                lblNoRecords.Visible = false;
            }
            else
            {
                gvDocuments.DataSource = new List<object>();
                gvDocuments.DataBind();
                lblNoRecords.Visible = true;
            }
        }

        protected void gvDocuments_Sorting(object sender, GridViewSortEventArgs e)
        {
            if (SortExpression == e.SortExpression)
            {
                SortDirection = SortDirection == "ASC" ? "DESC" : "ASC";
            }
            else
            {
                SortDirection = "ASC";
            }

            SortExpression = e.SortExpression;
            int formType = -1;
            if (!string.IsNullOrEmpty(hiddenFormType.Value))
            {
                int.TryParse(hiddenFormType.Value, out formType);
            }
            LoadDocuments(txtSearch.Text.Trim(), SortExpression, SortDirection, formType);
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            int formType = -1;
            if (!string.IsNullOrEmpty(hiddenFormType.Value))
            {
                int.TryParse(hiddenFormType.Value, out formType);
            }
            LoadDocuments(txtSearch.Text.Trim(), SortExpression, SortDirection, formType);
        }

        protected string GetStatusSymbol(int status)
        {
            return status == 0 ? "❌" : "✅";
        }

        protected void gvDocuments_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvDocuments.PageIndex = e.NewPageIndex;
            int formType = -1;
            if (!string.IsNullOrEmpty(hiddenFormType.Value))
            {
                int.TryParse(hiddenFormType.Value, out formType);
            }
            LoadDocuments(txtSearch.Text.Trim(), SortExpression, SortDirection, formType);
        }

        protected void btnCreateForm1_Click(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx");
        }

        [System.Web.Services.WebMethod]
        public static string MarkWarehouseCheck(string docNo)
        {
            using (gatepassEntities db = new gatepassEntities())
            {
                var document = db.headings.FirstOrDefault(d => d.doc_no == docNo);
                if (document != null)
                {
                    document.warehouse_check = 1;
                    document.warehouse_date = DateTime.Now;
                    db.SaveChanges();
                    return "✅";
                }
            }
            return "❌";
        }

        [System.Web.Services.WebMethod]
        public static string DeleteDocument(string docNo)
        {
            using (gatepassEntities db = new gatepassEntities())
            {
                var document = db.headings.FirstOrDefault(d => d.doc_no == docNo);
                if (document != null)
                {
                    db.headings.Remove(document);
                    db.SaveChanges();
                    return "success";
                }
            }
            return "error";
        }

        protected void btnCreateForm2_Click(object sender, EventArgs e)
        {
            Response.Redirect("Default2.aspx");
        }

        protected void btnManageUsers_Click(object sender, EventArgs e)
        {
            Response.Redirect("ManageUsers.aspx");
        }

        private string GetTypeString(int? typeValue)
        {
            if (!typeValue.HasValue)
            {
                return "Unknown";
            }

            switch (typeValue.Value)
            {
                case 1:
                    return "Finished Goods";
                case 2:
                    return "Scrap";
                case 3:
                    return "Assets";
                case 4:
                    return "Accessories";
                case 5:
                    return "Waste";
                case 6:
                    return "Others";
                default:
                    return "Unknown";
            }
        }
    }
}