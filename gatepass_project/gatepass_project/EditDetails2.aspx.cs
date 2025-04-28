using System;
using System.Data;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Entity; 
using System.Collections.Generic;
using System.Web.Script.Serialization; 

namespace gatepass_project
{
    public partial class EditDetails2 : Page
    {
        private gatepassEntities db = new gatepassEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string docNo = Request.QueryString["doc_no"];
                if (!string.IsNullOrEmpty(docNo))
                {
                    LoadDetails(docNo);
                    LoadItems(docNo);
                }
                else
                {
                    Response.Redirect("ViewDocuments.aspx");
                }
                ViewState["NewItems"] = new List<detail_pass>();
            }
        }
        private void LoadDetails(string docNo)
        {
            var gatePass = db.headings.FirstOrDefault(g => g.doc_no == docNo);
            if (gatePass != null)
            {
                txtDocNo.Text = gatePass.doc_no;
                txtName.Text = gatePass.name;
                ddlCompany.SelectedValue = gatePass.company;
                txtDate.Text = gatePass.date?.ToString("yyyy-MM-dd"); // Ensure correct date format
                txtTimeout.Text = gatePass.time_out?.ToString(); // Ensure correct time format
                txtAsset.Text = gatePass.asset_no;
            
                txtAddress.Text = gatePass.address;
                // Factory radio buttons
                rbNETL.Checked = gatePass.factory == "NETL";
                rbNETR.Checked = gatePass.factory == "NETR";
                rbNPTA.Checked = gatePass.factory == "NPTA";
                rbNPTR.Checked = gatePass.factory == "NPTR";
                rbNCOT.Checked = gatePass.factory == "NCOT";
                rbNDCT.Checked = gatePass.factory == "NDCT";
                rbNDCC.Checked = gatePass.factory == "NDCC";

            

                // Return Status radio buttons and date (based on return_date)
                if (gatePass.return_date.HasValue)
                {
                    rbReturnWithDate.Checked = true;
                    returnDate.Value = gatePass.return_date.Value.ToString("yyyy-MM-dd"); // Set date if exists
                }
                else
                {
                    noReturn.Checked = true;
                    returnDate.Value = string.Empty; // Clear the date input
                }
            }
            else
            {
                Response.Write("<script>alert('Gate Pass not found'); window.location='ViewDocuments.aspx';</script>");
            }
        }

        private void LoadItems(string docNo)
        {
            var items = db.detail_pass.Where(i => i.doc_no == docNo).ToList();

            // Retrieve new rows from ViewState
            List<detail_pass> newItems = ViewState["NewItems"] as List<detail_pass>;
            if (newItems == null)
                newItems = new List<detail_pass>();

            //  Merge both lists before binding
            items.AddRange(newItems);

            GridView1.DataSource = items;
            GridView1.DataBind();
        }
        protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                GridViewRow row = GridView1.Rows[e.RowIndex];
                string docNo = txtDocNo.Text;
                string invoice_no = ((TextBox)row.FindControl("txtInvoice")).Text.Trim();
                string description = ((TextBox)row.FindControl("txtDescription")).Text.Trim();
                int quantity = int.TryParse(((TextBox)row.FindControl("txtQuantity")).Text.Trim(), out int qty) ? qty : 0;
                string purpose = ((TextBox)row.FindControl("txtPurpose")).Text.Trim();
                string imageUrl = ((TextBox)row.FindControl("txtImageUrl")).Text?.Trim() ?? string.Empty;

                var item = db.detail_pass.FirstOrDefault(i => i.doc_no == docNo && i.description == description);
                if (item != null)
                {
                    item.invoice_no = invoice_no;
                    item.quantity = quantity;
                    item.purpose = purpose;
                    item.image_url = string.IsNullOrEmpty(imageUrl) ? null : imageUrl;
                    db.SaveChanges();

                    GridView1.EditIndex = -1;
                    LoadItems(docNo);
                    Response.Write("<script>alert('Item updated successfully');</script>");
                }
                else
                {
                    Response.Write("<script>alert('Item not found');</script>");
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message.Replace("'", "\\'") + "');</script>");
            }
        }


        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                string docNo = txtDocNo.Text.Trim();
                string name = txtName.Text.Trim();

                string timeOut = txtTimeout.Text.Trim();
                string asset_no = txtAsset.Text.Trim();
         
                string address = txtAddress.Text.Trim();

                // Check for empty required fields
                List<string> missingFields = new List<string>();
                if (string.IsNullOrEmpty(docNo)) missingFields.Add("Document Number");
                if (string.IsNullOrEmpty(name)) missingFields.Add("Name");
                if (string.IsNullOrEmpty(asset_no)) missingFields.Add("Asset No.");
        

                if (string.IsNullOrEmpty(timeOut)) missingFields.Add("Time Out");
       

                // Add validation for txtAddress when ddlCompany is "Others"
                if (ddlCompany.SelectedValue == "Others" && string.IsNullOrEmpty(address))
                {
                    missingFields.Add("Supplier Address");
                }

                if (missingFields.Count > 0)
                {
                    string missingFieldsText = string.Join(", ", missingFields);
                    ShowAlert($"The following fields are required: {missingFieldsText}", true);
                    return;
                }

                // Find the gate pass record
                var gatePass = db.headings.FirstOrDefault(g => g.doc_no == docNo);
                if (gatePass == null)
                {
                    ShowAlert("Gate Pass not found.", true);
                    return;
                }

                // Update gate pass fields
                gatePass.name = name;

                gatePass.time_out = TimeSpan.TryParse(timeOut, out TimeSpan timeOutValue) ? (TimeSpan?)timeOutValue : null;
                gatePass.asset_no = asset_no;
             
                gatePass.company = ddlCompany.SelectedValue;
           
                gatePass.address = address;



                // Return Date
                if (rbReturnWithDate.Checked)
                {
                    if (DateTime.TryParse(returnDate.Value, out DateTime returnDateValue))
                    {
                        gatePass.return_date = returnDateValue;
                    }
                    else if (!string.IsNullOrEmpty(returnDate.Value))
                    {
                        ShowAlert("Invalid return date format.", true);
                        return;
                    }
                    else
                    {
                        ShowAlert("Please specify a return date when 'Return With Date' is selected.", true);
                        return;
                    }
                }
                else
                {
                    gatePass.return_date = null;
                }

                // Read JSON data from hidden field for items
                string json = hiddenGridData.Value;
                if (string.IsNullOrWhiteSpace(json) || json == "[]")
                {
                    ShowAlert("No items to save. Please add at least one item.", true);
                    return;
                }

                var serializer = new JavaScriptSerializer();
                List<Dictionary<string, string>> items = serializer.Deserialize<List<Dictionary<string, string>>>(json);

                if (items == null || items.Count == 0)
                {
                    ShowAlert("No valid items found.", true);
                    return;
                }

                // Remove existing items
                var existingItems = db.detail_pass.Where(i => i.doc_no == docNo).ToList();
                if (existingItems.Any())
                {
                    db.detail_pass.RemoveRange(existingItems);
                }

                // Insert new items from JSON
                List<detail_pass> newItems = new List<detail_pass>();
                foreach (var item in items)
                {
                    if (!item.ContainsKey("invoice_no") || !item.ContainsKey("Description") || !item.ContainsKey("Quantity") || !item.ContainsKey("Purpose"))
                    {
                        ShowAlert("Invalid item data. All items must have Invoice No, Description, Quantity, and Purpose.", true);
                        return;
                    }

                    if (!int.TryParse(item["Quantity"], out int quantity))
                    {
                        ShowAlert("Invalid quantity for an item. Please enter a valid number.", true);
                        return;
                    }

                    

                    newItems.Add(new detail_pass
                    {
                        doc_no = docNo,
                        invoice_no = item["invoice_no"],
                        description = item["Description"], 
                        quantity = quantity,
                        purpose = item["Purpose"],
                        image_url = item.ContainsKey("image_url") && !string.IsNullOrWhiteSpace(item["image_url"]) ? item["image_url"] : null
                    });
                }

                db.detail_pass.AddRange(newItems);
                db.SaveChanges();
                ShowAlert("Gate Pass updated successfully!", false, true);
            }
            catch (Exception ex)
            {
                ShowAlert($"Error: {ex.Message.Replace("'", "\\'")}", true);
            }
        }


        private void ShowAlert(string message, bool isError, bool redirect = false)
        {
            string icon = isError ? "error" : "success";
            string script = $"Swal.fire({{ title: 'Notification', text: '{message}', icon: '{icon}', confirmButtonText: 'OK' }});";

            if (redirect)
            {
                script += " setTimeout(function(){ window.location='ViewDocuments.aspx'; }, 2000);";
            }

            ClientScript.RegisterStartupScript(this.GetType(), "customAlert", script, true);
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("ViewDocuments.aspx");
        }

    }
}
