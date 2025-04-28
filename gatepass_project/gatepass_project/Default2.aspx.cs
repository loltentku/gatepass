using System;
using System.Data;
using System.Linq;
using System.Web.UI;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Web.UI.WebControls;

namespace gatepass_project
{
    public partial class Default2 : Page
    {
        private gatepassEntities db = new gatepassEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminUser"] == null || Session["AdminUser"].ToString() == "Guest")
            {
                Response.Redirect("Login.aspx");
                return;
            }
            BindGrid();

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
                        txtName.Text = Session["AdminUser"].ToString();
                        txtName.Enabled = false;
                    }

                    // Auto-assign factory based on Session["UserFactory"]
                    string userFactory = Session["UserFactory"]?.ToString();
                    if (!string.IsNullOrEmpty(userFactory))
                    {
                        switch (userFactory)
                        {
                            case "NETL":
                                rbNETL.Checked = true;
                                break;
                            case "NETR":
                                rbNETR.Checked = true;
                                break;
                            case "NPTA":
                                rbNPTA.Checked = true;
                                break;
                            case "NPTR":
                                rbNPTR.Checked = true;
                                break;
                            case "NCOT":
                                rbNCOT.Checked = true;
                                break;
                            case "NDCT":
                                rbNDCT.Checked = true;
                                break;
                            case "NDCC":
                                rbNDCC.Checked = true;
                                break;
                            default:
                                rbNETL.Checked = true; // Fallback to NETL if invalid
                                break;
                        }
                    }
                    else
                    {
                        rbNETL.Checked = true; // Fallback if UserFactory is null
                    }

                    // Disable all factory radio buttons
                    rbNETL.Enabled = false;
                    rbNETR.Enabled = false;
                    rbNPTA.Enabled = false;
                    rbNPTR.Enabled = false;
                    rbNCOT.Enabled = false;
                    rbNDCT.Enabled = false;
                    rbNDCC.Enabled = false;

                    // Default selections for other fields
               
                    noReturn.Checked = true;

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
                dt.Columns.Add("Invoice");
                dt.Columns.Add("Description");
                dt.Columns.Add("Quantity");
                dt.Columns.Add("Purpose");
                dt.Columns.Add("image_url"); // Add column for image URLs
            }

            ViewState["ItemsTable"] = dt;
            GridView1.DataSource = dt;
            GridView1.DataBind();
        }


        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                
                using (gatepassEntities db = new gatepassEntities())
                {
                    string currentYearMonth = DateTime.Now.ToString("yyyyMM");
                    string newDocNo = Session["CurrentDocNo"] as string ?? GenerateNewDocNo(currentYearMonth, db);
                    Session["CurrentDocNo"] = newDocNo;

                    var existingHeading = db.headings.FirstOrDefault(h => h.doc_no == newDocNo);
                    if (existingHeading == null)
                    {
                        // Retrieve return status and date from the form
                        string returnStatus = Request.Form["returnStatus"]; // "No Return" or "Return With Date"
                        DateTime? returnDateValue = null;

                        if (rbReturnWithDate.Checked)
                        {
                            // The "returnDate" control is a server control; use its Value property
                            if (!string.IsNullOrWhiteSpace(returnDate.Value))
                            {
                                DateTime parsedDate;
                                if (DateTime.TryParse(returnDate.Value, out parsedDate))
                                {
                                    returnDateValue = parsedDate;
                                }
                            }
                        }
                        var newHeading = new heading
                        {
                            doc_no = newDocNo,
                            name = txtName.Text.Trim(),
                            company = ddlCompany.SelectedValue,
                            asset_no = txtAsset.Text.Trim(),
                            factory = GetSelectedRadioButtonValue(),
                            type = 1,
              
                            time_out = TimeSpan.TryParse(txtTimeout.Text, out TimeSpan timeout) ? (TimeSpan?)timeout : null,
                            date = DateTime.Now,
                           
                            return_date = returnDateValue,
                            status = 0,
                            checkin_status = 0,
                            checkout_status = 0,
                            formtype = 2,
                          
                            address = txtAddress.Text.Trim() 

                        };

                        db.headings.Add(newHeading);
                        db.SaveChanges();
                    }
                    Session["FormSubmitted"] = true;
                    btnAddRow.Enabled = true;
                    btnFinish.Enabled = true;

                    ScriptManager.RegisterStartupScript(this, GetType(), "unlockAddRow", "sessionStorage.setItem('FormSubmitted', 'true');", true);

                    Response.Redirect(Request.RawUrl, false); // ✅ Fix: Prevents session loss
                }
            }
            catch (Exception ex)
            {
                string errorMessage = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"alert('❌ Error: {errorMessage.Replace("'", "\\'")}');", true);
            }
        }
        private string GetSelectedRadioButtonValue()
        {
            if (rbNETL.Checked) return "NETL";
            if (rbNETR.Checked) return "NETR";
            if (rbNPTA.Checked) return "NPTA";
            if (rbNPTR.Checked) return "NPTR";
            if (rbNCOT.Checked) return "NCOT";
            if (rbNDCT.Checked) return "NDCT";
            if (rbNDCC.Checked) return "NDCC";
            return string.Empty; 
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

                    // 🛠️ Step 1: Ensure UI Items are Stored in ViewState
                    UpdateItemsTableFromUI();
                    DataTable dt = ViewState["ItemsTable"] as DataTable ?? new DataTable();

                    // ✅ Fix: Validate if at least one valid row exists
                    bool hasValidItems = dt.Rows.Cast<DataRow>().Any(row => !string.IsNullOrWhiteSpace(row["Description"].ToString()));

                    if (!hasValidItems)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('❌ No valid items to save!');", true);
                        return;
                    }

                    // 🛠️ Step 2: Remove Existing Records for Current Document
                    var existingItems = db.detail_pass.Where(d => d.doc_no == currentDocNo);
                    if (existingItems.Any())
                    {
                        db.detail_pass.RemoveRange(existingItems);
                        db.SaveChanges();
                    }

                    // 🛠️ Step 3: Add New Items to Database
                    List<detail_pass> newItems = new List<detail_pass>();
                    foreach (DataRow row in dt.Rows)
                    {
                        if (!string.IsNullOrWhiteSpace(row["Description"].ToString()))
                        {
                            newItems.Add(new detail_pass
                            {
                                doc_no = currentDocNo,
                                invoice_no = row["Invoice"].ToString(),
                                description = row["Description"].ToString(),
                                quantity = int.TryParse(row["Quantity"].ToString(), out int qty) ? qty : 0,
                                purpose = row["Purpose"].ToString(),
                                image_url = row["image_url"].ToString()
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
            // Create a new DataTable with the necessary columns
            DataTable dt = new DataTable();
            dt.Columns.Add("Invoice");
            dt.Columns.Add("Description");
            dt.Columns.Add("Quantity");
            dt.Columns.Add("Purpose");
            dt.Columns.Add("image_url");
            string json = hiddenGridData.Value;

            if (!string.IsNullOrEmpty(json))
            {
                
                var serializer = new JavaScriptSerializer();
                var items = serializer.Deserialize<List<Dictionary<string, string>>>(json);

                // Loop through the deserialized items and add them to the DataTable.
                foreach (var item in items)
                {
                    // Check that all necessary keys are present and that the description is not empty.
                    if (item.ContainsKey("description") &&
                        item.ContainsKey("quantity") &&
                        item.ContainsKey("purpose") &&
                        !string.IsNullOrWhiteSpace(item["description"]))
                    {
                        DataRow dr = dt.NewRow();
                        dr["Invoice"] = item["invoice_no"];
                        dr["Description"] = item["description"];
                        dr["Quantity"] = item["quantity"];
                        dr["Purpose"] = item["purpose"];
                        dr["image_url"] = item.ContainsKey("image_url") ? item["image_url"] : string.Empty;
                        dt.Rows.Add(dr);
                    }
                }
            }

            // Update ViewState and rebind the GridView.
            ViewState["ItemsTable"] = dt;
            GridView1.DataSource = dt;
            GridView1.DataBind();
        }

        private void LoadFormData(heading existingHeading)
        {
            txtName.Text = existingHeading.name;

            // Set factory based on Session["UserFactory"] instead of database value for consistency
            string userFactory = Session["UserFactory"]?.ToString();
            if (!string.IsNullOrEmpty(userFactory))
            {
                switch (userFactory)
                {
                    case "NETL":
                        rbNETL.Checked = true;
                        break;
                    case "NETR":
                        rbNETR.Checked = true;
                        break;
                    case "NPTA":
                        rbNPTA.Checked = true;
                        break;
                    case "NPTR":
                        rbNPTR.Checked = true;
                        break;
                    case "NCOT":
                        rbNCOT.Checked = true;
                        break;
                    case "NDCT":
                        rbNDCT.Checked = true;
                        break;
                    case "NDCC":
                        rbNDCC.Checked = true;
                        break;
                    default:
                        rbNETL.Checked = true; // Fallback
                        break;
                }
            }
            else
            {
                rbNETL.Checked = true; // Fallback if UserFactory is null
            }

            // Ensure factory radio buttons are disabled
            rbNETL.Enabled = false;
            rbNETR.Enabled = false;
            rbNPTA.Enabled = false;
            rbNPTR.Enabled = false;
            rbNCOT.Enabled = false;
            rbNDCT.Enabled = false;
            rbNDCC.Enabled = false;

            

            txtTimeout.Text = existingHeading.time_out?.ToString(@"hh\:mm") ?? "";
            txtDate.Text = existingHeading.date?.ToString("yyyy-MM-dd") ?? "";
       
            txtAsset.Text = existingHeading.asset_no;
            if (ddlCompany.Items.FindByValue(existingHeading.company) != null)
            {
                ddlCompany.SelectedValue = existingHeading.company;
            }
 

            if (existingHeading.return_date != null)
            {
                rbReturnWithDate.Checked = true;
                returnDate.Value = existingHeading.return_date.Value.ToString("yyyy-MM-dd");
                returnDate.Disabled = false;
            }
            else
            {
                noReturn.Checked = true;
                returnDate.Value = "";
                returnDate.Disabled = true;
            }
            LockFormExceptItems();
        }

        protected void LoadSavedItems(string docNo, gatepassEntities db)
        {
            var items = db.detail_pass.Where(d => d.doc_no == docNo).ToList();
            if (items.Any())
            {
                DataTable dt = new DataTable();
                dt.Columns.Add("Invoice");
                dt.Columns.Add("Description");
                dt.Columns.Add("Quantity");
                dt.Columns.Add("Purpose");
                dt.Columns.Add("image_url");
                foreach (var item in items)
                {
                    DataRow dr = dt.NewRow();
                    dr["Invoice"] = item.invoice_no ?? "";
                    dr["Description"] = item.description ?? ""; // Use directly, no validation needed
                    dr["Quantity"] = item.quantity;
                    dr["Purpose"] = item.purpose ?? "";
                    dr["image_url"] = item.image_url ?? "";
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
                TextBox txtInvoice = row.FindControl("txtInvoice") as TextBox;
                TextBox txtDescription = row.FindControl("txtDescription") as TextBox;
                TextBox txtQuantity = row.FindControl("txtQuantity") as TextBox;
                TextBox txtPurpose = row.FindControl("txtPurpose") as TextBox;
                Image imgItem = row.FindControl("imgItem") as Image; // Retrieve the image control

                if (txtInvoice != null) txtInvoice.Enabled = false;
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
                TextBox txtInvoice = row.FindControl("txtInvoice") as TextBox;
                TextBox txtDescription = row.FindControl("txtDescription") as TextBox;
                TextBox txtQuantity = row.FindControl("txtQuantity") as TextBox;
                TextBox txtPurpose = row.FindControl("txtPurpose") as TextBox;
                Image imgItem = row.FindControl("imgItem") as Image; // Retrieve the image control

                if (txtInvoice != null) txtInvoice.Enabled = true;
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
            rbNETL.Enabled = false;
            rbNETR.Enabled = false;
            rbNPTA.Enabled = false;
            rbNPTR.Enabled = false;
            rbNDCC.Enabled = false;
            rbNDCT.Enabled = false;
            rbNCOT.Enabled = false;
      
            txtTimeout.Enabled = false;
            txtDate.Enabled = false;
         
            txtAsset.Enabled = false;
            noReturn.Enabled = false;
            rbReturnWithDate.Enabled = false;

            btnAddRow.Enabled = true;
        }
        protected void btnViewDocuments_Click(object sender, EventArgs e)
        {
            Response.Redirect("ViewDocuments.aspx");
        }

    }
}