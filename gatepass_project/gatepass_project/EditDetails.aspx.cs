using System;
using System.Data;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Entity; // ✅ Ensure Entity Framework is referenced
using System.Collections.Generic;
using System.Web.Script.Serialization; // For JSON parsing


namespace gatepass_project
{
    public partial class EditDetails : Page
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
                ddlFactory.SelectedValue = gatePass.factory;
                txtAddress.Text = gatePass.address;
                txtAddress.Enabled = gatePass.company == "Others";
                txtDate.Text = gatePass.date?.ToString("yyyy-MM-dd"); // ✅ Ensure correct date format
                txtTimeout.Text = gatePass.time_out?.ToString(); // ✅ Ensure correct time format
                txtTel.Text = gatePass.tel_no?.ToString();
                txtRequester.Text = gatePass.requester;
                txtDept.Text = gatePass.department;
                txtTel2.Text = gatePass.requester_tel?.ToString();
                txSect.Text = gatePass.manager;
                txtDgm.Text = gatePass.dgm;
                txtSecurityGuard.Text = gatePass.security;
                txtTime.Text = gatePass.time?.ToString();
                if (gatePass.type.HasValue)
                {
                    switch (gatePass.type.Value)
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
            }
            else
            {
                Response.Write("<script>alert('Gate Pass not found'); window.location='ViewDocuments.aspx';</script>");
            }
        }

        private void LoadItems(string docNo)
        {
            var items = db.detail_pass.Where(i => i.doc_no == docNo).ToList();
            List<detail_pass> newItems = ViewState["NewItems"] as List<detail_pass> ?? new List<detail_pass>();
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
                string description = ((TextBox)row.FindControl("txtDescription")).Text.Trim(); 
                int quantity = int.TryParse(((TextBox)row.FindControl("txtQuantity")).Text.Trim(), out int qty) ? qty : 0;
                string purpose = ((TextBox)row.FindControl("txtPurpose")).Text.Trim();
                string imageUrl = ((TextBox)row.FindControl("txtImageUrl")).Text?.Trim() ?? string.Empty;


                var item = db.detail_pass.FirstOrDefault(i => i.doc_no == docNo && i.description == description);
                if (item != null)
                {
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
                string address = txtAddress.Text.Trim();

                string timeOut = txtTimeout.Text.Trim();
                string tel = txtTel.Text.Trim();
                string requester = txtRequester.Text.Trim();
                string dept = txtDept.Text.Trim();
                string tel2 = txtTel2.Text.Trim();
                string manager = txSect.Text.Trim();
                string dgm = txtDgm.Text.Trim();
                string security = txtSecurityGuard.Text.Trim();
                string time = txtTime.Text.Trim();


                // ✅ Check for empty required fields
                List<string> missingFields = new List<string>();
                if (string.IsNullOrEmpty(docNo)) missingFields.Add("Document Number");
                if (string.IsNullOrEmpty(name)) missingFields.Add("Name");

                if (ddlCompany.SelectedValue == "Others" && string.IsNullOrEmpty(address))
                    missingFields.Add("Address");
      
                if (string.IsNullOrEmpty(timeOut)) missingFields.Add("Time Out");
         
                if (string.IsNullOrEmpty(tel)) missingFields.Add("Telephone Number");
                if (string.IsNullOrEmpty(requester)) missingFields.Add("Requester");
                if (string.IsNullOrEmpty(dept)) missingFields.Add("Department");
                if (string.IsNullOrEmpty(tel2)) missingFields.Add("Requester Telephone");
                if (string.IsNullOrEmpty(manager)) missingFields.Add("Manager");
                if (string.IsNullOrEmpty(dgm)) missingFields.Add("DGM");
                if (string.IsNullOrEmpty(security)) missingFields.Add("Security Guard");
                if (string.IsNullOrEmpty(time)) missingFields.Add("Time");

                if (missingFields.Count > 0)
                {
                    string missingFieldsText = string.Join(", ", missingFields);
                    ShowAlert($"The following fields are required: {missingFieldsText}", true);
                    return;
                }
                if (!int.TryParse(tel, out int telNumber) || !int.TryParse(tel2, out int reqTel))
                {
                    ShowAlert("Telephone numbers must contain only numbers.", true);
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
                if (ddlCompany.SelectedValue != "Others")
                {
                    gatePass.address = null; // Or keep it unchanged, depending on requirements
                }
                else
                {
                    gatePass.address = address;
                }
                gatePass.name = name;
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


                gatePass.time_out = TimeSpan.TryParse(timeOut, out TimeSpan timeOutValue) ? (TimeSpan?)timeOutValue : null;
                gatePass.tel_no = telNumber;
                gatePass.requester = requester;
                gatePass.department = dept;
                gatePass.requester_tel = reqTel;
                gatePass.manager = manager;
                gatePass.dgm = dgm;
                gatePass.security = security;
                gatePass.time = TimeSpan.TryParse(time, out TimeSpan timeValue) ? (TimeSpan?)timeValue : null;
                gatePass.company = ddlCompany.SelectedValue;
                gatePass.factory = ddlFactory.SelectedValue;
                gatePass.type = type;
                // Read JSON data from hidden field for items
                string json = hiddenGridData.Value;
                if (string.IsNullOrWhiteSpace(json))
                {
                    ShowAlert("No data to save. Please add items before submitting.", true);
                    return;
                }

                
                var serializer = new JavaScriptSerializer();
                List<Dictionary<string, string>> items = serializer.Deserialize<List<Dictionary<string, string>>>(json);

                if (items == null || items.Count == 0)
                {
                    ShowAlert("No valid items found.", true);
                    return;
                }

     
                var existingItems = db.detail_pass.Where(i => i.doc_no == docNo).ToList();
                if (existingItems.Any())
                {
                    db.detail_pass.RemoveRange(existingItems);
                }

                //  Insert new items from JSON
                List<detail_pass> newItems = new List<detail_pass>();
                foreach (var item in items)
                {
                    if (!item.ContainsKey("Description") || !item.ContainsKey("Quantity") || !item.ContainsKey("Purpose"))
                    {
                        ShowAlert("Invalid item data. Please check the item fields.", true);
                        return;
                    }

                    int quantity = 0;
                    if (!int.TryParse(item["Quantity"], out quantity))
                    {
                        ShowAlert("Invalid quantity for an item. Please enter a valid number.", true);
                        return;
                    }

                    newItems.Add(new detail_pass
                    {
                        doc_no = docNo,
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
