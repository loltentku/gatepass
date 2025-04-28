using System;
using System.Data;
using System.Linq;
using System.Web.UI;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Web.UI.WebControls;

namespace gatepass_project
{
    public partial class _Default : Page
    {
        private gatepassEntities db = new gatepassEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminUser"] == null || Session["AdminUser"].ToString() == "Guest")
            {
                Response.Redirect("Login.aspx"); 
                return; 
            }

            if (!IsPostBack)
            {
                txtDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtDate.Attributes["readonly"] = "readonly";
                string currentYearMonth = DateTime.Now.ToString("yyyyMM");
                string docNo = Session["CurrentDocNo"] as string;

                using (gatepassEntities db = new gatepassEntities())
                {
                    if (Session["AdminUser"] != null)
                    {
                        ddlItemType.SelectedValue = "Scrap";
                        txtName.Text = Session["AdminUser"].ToString(); // Directly use session value
                        txtName.Enabled = false; // Lock the field

                        string userFactory = Session["UserFactory"]?.ToString();
                        if (!string.IsNullOrEmpty(userFactory) && ddlFactory.Items.FindByValue(userFactory) != null)
                        {
                            ddlFactory.SelectedValue = userFactory;
                            ddlFactory.Enabled = false; // Lock the factory dropdown
                        }
                        else
                        {
                            ddlFactory.SelectedValue = "NETL"; // Default factory
                            ddlFactory.Enabled = false;
                        }

             
                    }

                    if (!string.IsNullOrEmpty(docNo) && !db.headings.Any(h => h.doc_no == docNo))
                    {
                        // If the doc_no was deleted, regenerate it
                        docNo = GenerateNewDocNo(currentYearMonth, db);
                        Session["CurrentDocNo"] = docNo;
                    }
                    else if (string.IsNullOrEmpty(docNo))
                    {
                        // No doc_no in session, generate a new one
                        docNo = GenerateNewDocNo(currentYearMonth, db);
                        Session["CurrentDocNo"] = docNo;
                    }
                    txtDocNo.Text = docNo;
                    txtDocNo.Enabled = false;

                    var existingHeading = db.headings.FirstOrDefault(h => h.doc_no == docNo);
                    if (existingHeading != null)
                    {
                        LoadFormData(existingHeading);
                        LoadSavedItems(docNo, db);
                        EnableItemListEditing();
                    }
                    else
                    {
                        DisableItemListEditing();
                        txtAddress.Enabled = ddlCompany.SelectedValue == "Others";
                    }
                }

                BindGrid();

                if (Session["FormSubmitted"] != null && (bool)Session["FormSubmitted"])
                {
                    btnAddRow.Enabled = true;
                    btnFinish.Enabled = true;
                    btnSubmit.Enabled = false;

                    ClientScript.RegisterStartupScript(
                        this.GetType(),
                        "SetSessionStorage",
                        "sessionStorage.setItem('FormSubmitted', 'true');",
                        true);
                }
                else
                {
                    ClientScript.RegisterStartupScript(
                        this.GetType(),
                        "ClearSessionStorage",
                        "sessionStorage.removeItem('FormSubmitted');",
                        true);
                }
            }
        }
        private void BindGrid()
        {
            DataTable dt = ViewState["ItemsTable"] as DataTable ?? new DataTable();

            if (dt.Columns.Count == 0)
            {
                dt.Columns.Add("Description");
                dt.Columns.Add("Quantity");
                dt.Columns.Add("Purpose");
                dt.Columns.Add("image_url");
            }

            ViewState["ItemsTable"] = dt;
            GridView1.DataSource = dt;
            GridView1.DataBind();
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                if (!int.TryParse(txtTel.Text.Trim(), out int telNo) || !int.TryParse(txtTel2.Text.Trim(), out int requesterTel))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "clearSessionStorage", "sessionStorage.removeItem('FormSubmitted');", true);

                    Session["FormSubmitted"] = false;
                    btnAddRow.Enabled = false;
                    btnFinish.Enabled = false;
                    ScriptManager.RegisterStartupScript(this, GetType(), "showModal", @"
                        Swal.fire({
                            title: '❌ Invalid Number!',
                            text: 'Please enter a valid number for Telephone no.',
                            icon: 'error',
                            confirmButtonText: 'OK'
                        });
                    ", true);
                    return;
                }

                using (gatepassEntities db = new gatepassEntities())
                {
                    string currentYearMonth = DateTime.Now.ToString("yyyyMM");
                    string newDocNo = Session["CurrentDocNo"] as string ?? GenerateNewDocNo(currentYearMonth, db);
                    Session["CurrentDocNo"] = newDocNo;

                    var existingHeading = db.headings.FirstOrDefault(h => h.doc_no == newDocNo);
                    if (existingHeading == null)
                    {
                        int type = 1; // Default value
                        switch (ddlItemType.SelectedValue)
                        {
                            case "Scrap":
                                type = 2;
                                break;
                            case "Assets":
                                type = 3;
                                break;
                            case "Accessories":
                                type = 4;
                                break;
                            case "Waste":
                                type = 5;
                                break;
                            case "Others":
                                type = 6;
                                break;
                        }
                        var newHeading = new heading
                        {
                            doc_no = newDocNo,
                            name = txtName.Text.Trim(),
                            factory = ddlFactory.SelectedValue,
                            company = ddlCompany.SelectedValue,
                            address = txtAddress.Text.Trim(),
                            tel_no = telNo,
                            type = type,
                            time_out = TimeSpan.TryParse(txtTimeout.Text, out TimeSpan timeout) ? (TimeSpan?)timeout : null,
                            date = DateTime.Now,
                            requester = txtRequester.Text.Trim(),
                            department = txtDept.Text.Trim(),
                            requester_tel = requesterTel,
                            manager = txSect.Text.Trim(),
                            formtype = 1,
                            status = 0,
                            checkin_status = 0,
                            checkout_status = 0,
                            dgm = txtDgm.Text.Trim(),
                            security = txtSecurityGuard.Text.Trim(),
                            time = TimeSpan.TryParse(txtTime.Text, out TimeSpan time) ? (TimeSpan?)time : null
                        };

                        db.headings.Add(newHeading);
                        db.SaveChanges();
                    }
                    Session["FormSubmitted"] = true;
                    btnAddRow.Enabled = true;
                    btnFinish.Enabled = true;

                    ScriptManager.RegisterStartupScript(this, GetType(), "unlockAddRow", "sessionStorage.setItem('FormSubmitted', 'true');", true);

                    Response.Redirect(Request.RawUrl, false);
                }
            }
            catch (Exception ex)
            {
                string errorMessage = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"alert('❌ Error: {errorMessage.Replace("'", "\\'")}');", true);
            }
        }

        protected void btnFinish_Click(object sender, EventArgs e)
        {
            try
            {
                using (gatepassEntities db = new gatepassEntities())
                {
                    string currentDocNo = Session["CurrentDocNo"]?.ToString();
                    if (string.IsNullOrEmpty(currentDocNo))
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('❌ Please submit the heading first!');", true);
                        return;
                    }

                    UpdateItemsTableFromUI();
                    DataTable dt = ViewState["ItemsTable"] as DataTable ?? new DataTable();

                    // ✅ Fix: Validate if at least one valid row exists
                    bool hasValidItems = dt.Rows.Cast<DataRow>().Any(row => !string.IsNullOrWhiteSpace(row["Description"].ToString()));

                    if (!hasValidItems)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('❌ No valid items to save!');", true);
                        return;
                    }

                    var existingItems = db.detail_pass.Where(d => d.doc_no == currentDocNo);
                    if (existingItems.Any())
                    {
                        db.detail_pass.RemoveRange(existingItems);
                        db.SaveChanges();
                    }
                    List<detail_pass> newItems = new List<detail_pass>();
                    foreach (DataRow row in dt.Rows)
                    {
                        if (!string.IsNullOrWhiteSpace(row["Description"].ToString()))
                        {
                            newItems.Add(new detail_pass
                            {
                                doc_no = currentDocNo,
                                description = row["Description"].ToString(),
                                quantity = int.TryParse(row["Quantity"].ToString(), out int qty) ? qty : 0,
                                purpose = row["Purpose"].ToString(),
                                image_url = row["image_url"].ToString() // Correct column name
                            });
                        }
                    }

                    if (newItems.Count > 0)
                    {
                        db.detail_pass.AddRange(newItems);
                        db.SaveChanges();
                    }

                    string currentYearMonth = DateTime.Now.ToString("yyyyMM");
                    Session["CurrentDocNo"] = GenerateNewDocNo(currentYearMonth, db);
                    Session["FormSubmitted"] = false;

                    ScriptManager.RegisterStartupScript(this, GetType(), "customAlert", @"
                        Swal.fire({
                            title: 'Success ✅',
                            text: 'Document saved successfully!',
                            icon: 'success',
                            confirmButtonText: 'OK'
                        }).then((result) => {
                            if (result.isConfirmed) {
                                window.location = '" + Request.RawUrl + @"'; 
                            }
                        });
                    ", true);
                }
            }
            catch (Exception ex)
            {
                string errorMessage = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"alert('❌ Error: {errorMessage.Replace("'", "\\'")}');", true);
            }
        }

        private void UpdateItemsTableFromUI()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Description");
            dt.Columns.Add("Quantity");
            dt.Columns.Add("Purpose");
            dt.Columns.Add("image_url");

            string json = hiddenGridData.Value;
            if (!string.IsNullOrEmpty(json))
            {
                var serializer = new JavaScriptSerializer();
                var items = serializer.Deserialize<List<Dictionary<string, string>>>(json);
                foreach (var item in items)
                {
                    if (item.ContainsKey("description") && item.ContainsKey("quantity") && item.ContainsKey("purpose") &&
                        !string.IsNullOrWhiteSpace(item["description"]))
                    {
                        DataRow dr = dt.NewRow();
                        dr["Description"] = item["description"]; // From JavaScript (dropdown value)
                        dr["Quantity"] = item["quantity"];
                        dr["Purpose"] = item["purpose"];
                        dr["image_url"] = item.ContainsKey("image_url") ? item["image_url"] : string.Empty;
                        dt.Rows.Add(dr);
                    }
                }
            }

            // Update from GridView rows as well
            // Update from GridView rows as well
            foreach (GridViewRow row in GridView1.Rows)
            {
                TextBox txtDescription = row.FindControl("txtDescription") as TextBox; // Changed from DropDownList to TextBox
                TextBox txtQuantity = row.FindControl("txtQuantity") as TextBox;
                TextBox txtPurpose = row.FindControl("txtPurpose") as TextBox;

                if (txtDescription != null && txtQuantity != null && txtPurpose != null)
                {
                    DataRow dr = dt.NewRow();
                    dr["Description"] = txtDescription.Text.Trim(); // Get text from TextBox instead of SelectedValue
                    dr["Quantity"] = txtQuantity.Text.Trim();
                    dr["Purpose"] = txtPurpose.Text.Trim();
                    dr["image_url"] = ""; // No input for image URL in GridView; handled via JavaScript
                    dt.Rows.Add(dr);
                }
            }

            ViewState["ItemsTable"] = dt;
            GridView1.DataSource = dt;
            GridView1.DataBind();
        }

        private void LoadFormData(heading existingHeading)
        {
            txtName.Text = existingHeading.name;
            txtAddress.Text = existingHeading.address;
            txtTel.Text = existingHeading.tel_no.ToString();
            txtTimeout.Text = existingHeading.time_out?.ToString(@"hh\:mm") ?? "";
            txtDate.Text = existingHeading.date?.ToString("yyyy-MM-dd") ?? "";
            txtRequester.Text = existingHeading.requester;
            txtDept.Text = existingHeading.department;
            txtTel2.Text = existingHeading.requester_tel.ToString();
            txSect.Text = existingHeading.manager;
            txtDgm.Text = existingHeading.dgm;
            txtSecurityGuard.Text = existingHeading.security;
            txtTime.Text = existingHeading.time?.ToString(@"hh\:mm") ?? "";
            ddlFactory.SelectedValue = existingHeading.factory;
            ddlCompany.SelectedValue = existingHeading.company;
            txtAddress.Enabled = ddlCompany.SelectedValue == "Others";

            // Corrected item type loading with reverse mapping from integer to string
            if (existingHeading.type.HasValue)
            {
                switch (existingHeading.type.Value)
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

            LockFormExceptItems();
        }

        protected void LoadSavedItems(string docNo, gatepassEntities db)
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
                ViewState["ItemsTable"] = dt;
                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
        }

        private void DisableItemListEditing()
        {
            btnAddRow.Enabled = false;
            foreach (GridViewRow row in GridView1.Rows)
            {
                TextBox txtDescription = row.FindControl("txtDescription") as TextBox;
                TextBox txtQuantity = row.FindControl("txtQuantity") as TextBox;
                TextBox txtPurpose = row.FindControl("txtPurpose") as TextBox;
                TextBox imgItem = row.FindControl("imgItem") as TextBox;

                if (txtDescription != null) txtDescription.Enabled = false;
                if (txtQuantity != null) txtQuantity.Enabled = false;
                if (txtPurpose != null) txtPurpose.Enabled = false;
                if (imgItem != null) imgItem.Enabled = false;
            }
        }

        private void EnableItemListEditing()
        {
            btnAddRow.Enabled = true;
            foreach (GridViewRow row in GridView1.Rows)
            {
                TextBox txtDescription = row.FindControl("txtDescription") as TextBox;
                TextBox txtQuantity = row.FindControl("txtQuantity") as TextBox;
                TextBox txtPurpose = row.FindControl("txtPurpose") as TextBox;
                TextBox imgItem = row.FindControl("imgItem") as TextBox;

                if (txtDescription != null) txtDescription.Enabled = true;
                if (txtQuantity != null) txtQuantity.Enabled = true;
                if (txtPurpose != null) txtPurpose.Enabled = true;
                if (imgItem != null) imgItem.Enabled = true;
            }
        }

        private string GenerateNewDocNo(string currentYearMonth, gatepassEntities db)
        {
            var latestDoc = db.headings
                .Where(h => h.doc_no.StartsWith(currentYearMonth))
                .OrderByDescending(h => h.doc_no)
                .Select(h => h.doc_no)
                .FirstOrDefault();

            int nextNumber = 1;

            if (!string.IsNullOrEmpty(latestDoc))
            {
                string lastThreeDigits = latestDoc.Substring(6, 3);
                if (int.TryParse(lastThreeDigits, out int lastNumber))
                {
                    nextNumber = lastNumber + 1;
                }
            }

            return $"{currentYearMonth}{nextNumber:D3}";
        }

        private void LockFormExceptItems()
        {
            txtName.Enabled = false;
            ddlCompany.Enabled = false;
            ddlFactory.Enabled = false;
            txtAddress.Enabled = false;
            txtTel.Enabled = false;
            txtTimeout.Enabled = false;
            txtDate.Enabled = false;
            txtRequester.Enabled = false;
            txtDept.Enabled = false;
            txtTel2.Enabled = false;
            txSect.Enabled = false;
            txtDgm.Enabled = false;
            txtSecurityGuard.Enabled = false;
            txtTime.Enabled = false;
            btnAddRow.Enabled = true;
        }
        protected void btnViewDocuments_Click(object sender, EventArgs e)
        {
            Response.Redirect("ViewDocuments.aspx");
        }

    }
}