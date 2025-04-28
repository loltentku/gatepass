using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using System.Text;

namespace gatepass_project
{
    public partial class Dashboard : Page
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

        // Properties for chart data
        public string FactoryChartLabels { get; private set; }
        public string FactoryChartData { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Authentication check
            if (Session["AdminUser"] == null)
            {
                lblUserName.Text = "<a href='Login.aspx' class='text-white font-weight-bold'>🔑 Login</a>";
                Response.Redirect("Login.aspx");
            }
            else
            {
                string fullName = Session["AdminUser"].ToString();
                if (fullName == "Guest")
                {
                    lblUserName.Text = "<a href='Login.aspx' class='text-white font-weight-bold'>🔑 Login</a>";
                }
                else
                {
                    string userRole = Session["UserRole"] as string ?? "";
                    string userFactory = Session["UserFactory"] as string ?? "";
                    string userDepartment = Session["UserDepartment"] as string ?? "";
                    lblUserName.Text = $"USER: {fullName} ROLE: {userRole} FACTORY: {userFactory} DEPARTMENT: {userDepartment} <a href='#' onclick='logoutUser();' class='logout-link'> Logout</a>";
                }
            }

            if (!IsPostBack)
            {
                // Get filter values from query string
                int formType;
                if (!int.TryParse(Request.QueryString["formType"], out formType))
                {
                    formType = -1; // Default to "All Forms" if parsing fails or no value is provided
                }
                string factory = Request.QueryString["factory"] ?? "";
                string startDate = Request.QueryString["startDate"] ?? "";
                string endDate = Request.QueryString["endDate"] ?? "";

                // Populate factory dropdown
                PopulateFactoryDropdown();

                // Set selected values
                ddlFormType.SelectedValue = formType.ToString();
                if (ddlFactory.Items.FindByValue(factory) != null)
                {
                    ddlFactory.SelectedValue = factory;
                }
                txtStartDate.Text = startDate;
                txtEndDate.Text = endDate;

                // Load dashboard data
                LoadDashboardData(formType, factory, startDate, endDate);
            }
        }

        private void PopulateFactoryDropdown()
        {
            var factories = db.headings.Select(d => d.factory).Distinct().Where(f => !string.IsNullOrEmpty(f)).OrderBy(f => f).ToList();
            ddlFactory.Items.Clear();
            ddlFactory.Items.Add(new ListItem("All Factories", ""));
            foreach (var factory in factories)
            {
                ddlFactory.Items.Add(new ListItem(factory, factory));
            }
        }

        private string GetApprovalStatus(int? type, int? status)
        {
            if (!type.HasValue || !status.HasValue) return "Pending";

            int requiredApprovals;
            switch (type.Value)
            {
                case 1: requiredApprovals = 2; break; // Finished Goods
                case 2: case 4: case 5: case 6: requiredApprovals = 4; break; // Scrap, Accessories, Waste, Others
                case 3: requiredApprovals = 3; break; // Assets
                default: requiredApprovals = 4; break;
            }

            return status.Value >= requiredApprovals ? "Approved" : "Pending";
        }

        private string GetTypeString(int? typeValue)
        {
            if (!typeValue.HasValue) return "Unknown";

            switch (typeValue.Value)
            {
                case 1: return "Finished Goods";
                case 2: return "Scrap";
                case 3: return "Assets";
                case 4: return "Accessories";
                case 5: return "Waste";
                case 6: return "Others";
                default: return "Unknown";
            }
        }

        private void LoadDashboardData(int formType, string factory, string startDate, string endDate)
        {
            string userRole = (Session["UserRole"] as string ?? "").ToLower();
            string userFactory = (Session["UserFactory"] as string ?? "").Trim();

            // Query documents
            var documents = db.headings.AsQueryable();

            // Apply role-based factory filter
            if ((userRole == "security" || userRole == "admin" || userRole == "manager") && !string.IsNullOrEmpty(userFactory))
            {
                documents = documents.Where(d => d.factory.Trim() == userFactory);
            }

            // Apply form type filter
            if (formType == 1 || formType == 2)
            {
                documents = documents.Where(d => d.formtype == formType);
            }

            // Apply factory filter
            if (!string.IsNullOrEmpty(factory))
            {
                documents = documents.Where(d => d.factory.Trim() == factory);
            }

            // Apply date range filter
            DateTime? start = null;
            DateTime? end = null;
            if (!string.IsNullOrEmpty(startDate) && DateTime.TryParse(startDate, out DateTime parsedStart))
            {
                start = parsedStart;
                documents = documents.Where(d => d.date >= start);
            }
            if (!string.IsNullOrEmpty(endDate) && DateTime.TryParse(endDate, out DateTime parsedEnd))
            {
                end = parsedEnd.AddDays(1).AddTicks(-1); // Include end date
                documents = documents.Where(d => d.date <= end);
            }

            // Calculate counts
            var docList = documents.ToList();
            int totalDocs = docList.Count;
            int approvedDocs = docList.Count(d => GetApprovalStatus(d.type, d.status) == "Approved");
            int pendingDocs = docList.Count(d => GetApprovalStatus(d.type, d.status) == "Pending");

            // Counts by document type
            int finishedGoods = docList.Count(d => d.type == 1);
            int scrap = docList.Count(d => d.type == 2);
            int assets = docList.Count(d => d.type == 3);
            int accessories = docList.Count(d => d.type == 4);
            int waste = docList.Count(d => d.type == 5);
            int others = docList.Count(d => d.type == 6);

            // Update summary cards
            lblTotalDocs.Text = totalDocs.ToString();
            lblApprovedDocs.Text = approvedDocs.ToString();
            lblPendingDocs.Text = pendingDocs.ToString();
            lblFinishedGoods.Text = finishedGoods.ToString();
            lblScrap.Text = scrap.ToString();
            lblAssets.Text = assets.ToString();
            lblAccessories.Text = accessories.ToString();
            lblWaste.Text = waste.ToString();
            lblOthers.Text = others.ToString();

            // Factory chart data
            var factoryCounts = docList
                .GroupBy(d => d.factory)
                .Where(g => !string.IsNullOrEmpty(g.Key))
                .Select(g => new { Factory = g.Key, Count = g.Count() })
                .OrderBy(g => g.Factory)
                .ToList();

            FactoryChartLabels = string.Join(",", factoryCounts.Select(f => $"\"{f.Factory}\""));
            FactoryChartData = string.Join(",", factoryCounts.Select(f => f.Count));

            // Load recent documents (top 10, sorted by date descending)
            var recentDocs = docList
                .OrderByDescending(d => d.date)
                .Take(10)
                .Select(d => new
                {
                    d.doc_no,
                    type = GetTypeString(d.type),
                    d.factory,
                    d.date,
                    ApprovalStatus = GetApprovalStatus(d.type, d.status),
                    d.formtype
                })
                .ToList();

            gvRecentDocs.DataSource = recentDocs;
            gvRecentDocs.DataBind();
        }

        protected void gvRecentDocs_Sorting(object sender, GridViewSortEventArgs e)
        {
            if (SortExpression == e.SortExpression)
            {
                SortDirection = SortDirection == "ASC" ? "DESC" : "ASC";
            }
            else
            {
                SortDirection = "ASC";
                SortExpression = e.SortExpression;
            }

            int formType = -1;
            if (int.TryParse(ddlFormType.SelectedValue, out formType)) { }
            string factory = ddlFactory.SelectedValue;
            string startDate = txtStartDate.Text;
            string endDate = txtEndDate.Text;

            LoadDashboardData(formType, factory, startDate, endDate);
        }
    }
}