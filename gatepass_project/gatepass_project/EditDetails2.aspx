<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditDetails2.aspx.cs" Inherits="gatepass_project.EditDetails2" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>Edit Gate Pass</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</head>
<body>
    <form id="form1" runat="server">
        <div class="container mt-4">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h3>📝 Edit Gate Pass</h3>
                </div>
                <div class="card-body">
                 
                    <div class="d-flex justify-content-between">
                        <!-- Doc No Field (Read-Only) -->
                        <div class="d-flex align-items-center">
                            <label for="txtDocNo" class="mr-2 font-weight-bold">📄 Doc No:</label>
                            <asp:TextBox ID="txtDocNo" runat="server" CssClass="form-control w-auto" ReadOnly="true"></asp:TextBox>
                        </div>

                        <!-- Date Field -->
                        <div class="d-flex align-items-center">
                            <label for="txtDate" class="mr-2 font-weight-bold">📅 Date:</label>
                            <asp:TextBox ID="txtDate" runat="server" CssClass="form-control w-auto" ReadOnly="true" TextMode="Date"></asp:TextBox>
                        </div>
                    </div>

                    <hr />
                    <div class="row">
    
<!-- Factory Section -->
<div class="col-md-6">
    <div class="form-group mt-3 mb-3 border p-3">
        <label class="font-weight-bold mr-3">Factory:</label>
        <div class="d-flex flex-wrap">
            <div class="form-check form-check-inline">
                <asp:RadioButton ID="rbNETL" runat="server" GroupName="factoryGroup" CssClass="form-check-input" Enabled="false" />
                <label class="form-check-label" for="rbNETL">NETL</label>
            </div>
            <div class="form-check form-check-inline">
                <asp:RadioButton ID="rbNETR" runat="server" GroupName="factoryGroup" CssClass="form-check-input" Enabled="false" />
                <label class="form-check-label" for="rbNETR">NETR</label>
            </div>
            <div class="form-check form-check-inline">
                <asp:RadioButton ID="rbNPTA" runat="server" GroupName="factoryGroup" CssClass="form-check-input" Enabled="false" />
                <label class="form-check-label" for="rbNPTA">NPTA</label>
            </div>
            <div class="form-check form-check-inline">
                <asp:RadioButton ID="rbNPTR" runat="server" GroupName="factoryGroup" CssClass="form-check-input" Enabled="false" />
                <label class="form-check-label" for="rbNPTR">NPTR</label>
            </div>
            <div class="form-check form-check-inline">
                <asp:RadioButton ID="rbNCOT" runat="server" GroupName="factoryGroup" CssClass="form-check-input" Enabled="false" />
                <label class="form-check-label" for="rbNCOT">NCOT</label>
            </div>
            <div class="form-check form-check-inline">
                <asp:RadioButton ID="rbNDCT" runat="server" GroupName="factoryGroup" CssClass="form-check-input" Enabled="false" />
                <label class="form-check-label" for="rbNDCT">NDCT</label>
            </div>
            <div class="form-check form-check-inline">
                <asp:RadioButton ID="rbNDCC" runat="server" GroupName="factoryGroup" CssClass="form-check-input" Enabled="false" />
                <label class="form-check-label" for="rbNDCC">NDCC</label>
            </div>
        </div>
    </div>
</div>

    <div class="col-md-6">
        <div class="form-group mt-3 mb-3 border p-3">
            <label class="font-weight-bold mr-3">Type:</label>
            <div class="d-flex flex-wrap">
                <div class="form-check form-check-inline">
                  <asp:TextBox ID="txtType" runat="server" CssClass="form-control w-auto" Text="Finished goods" ReadOnly="true"></asp:TextBox>
                </div>
                
               
            </div>
        </div>
    </div>

</div>
                 
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <!-- Left Column -->
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="txtName"><i class="fas fa-user-tie"></i>👤 Name:</label>
                                    <asp:TextBox ID="txtName" runat="server" CssClass="form-control" ></asp:TextBox>
                                </div>
                              
                                <div class="form-group">
                                    <label for="txtAsset">💰External Transfer Assets No:</label>
                                    <asp:TextBox ID="txtAsset" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                                <!-- Return Status Section -->
                                <div class="form-group mt-4">
    <label class="font-weight-bold">📦 Return Status:</label>
    <div class="d-flex align-items-center">
        <asp:RadioButton ID="noReturn" runat="server" ClientIDMode="Static"
            GroupName="returnStatus" Value="No Return" CssClass="mr-2" />
        <label for="noReturn">No return to Company</label>
    </div>
    <div class="d-flex align-items-center mt-2">
        <asp:RadioButton ID="rbReturnWithDate" runat="server" ClientIDMode="Static"
            GroupName="returnStatus" Value="Return With Date" CssClass="mr-2" />
        <label for="rbReturnWithDate">Return date to Company</label>
        <input type="date" id="returnDate" runat="server" ClientIDMode="Static"
               name="returnDate" class="form-control ml-2 w-auto" disabled="disabled" />
    </div>
</div>
                            </div>

                       
                <div class="col-md-6">
            
                                <div class="form-group">
                                    <label for="txtTimeout">⏰Departure Time:</label>
                                    <asp:TextBox ID="txtTimeout" runat="server" CssClass="form-control" TextMode="Time"></asp:TextBox>
                                </div>
                            <div class="form-group">
                    <label for="ddlCompany">🏢 To Company:</label>
                    <asp:DropDownList ID="ddlCompany" runat="server" CssClass="form-control">
                        <asp:ListItem Text="NETL" Value="NETL"></asp:ListItem>
                        <asp:ListItem Text="NETR" Value="NETR"></asp:ListItem>
                        <asp:ListItem Text="NPTA" Value="NPTA"></asp:ListItem>
                        <asp:ListItem Text="NPTR" Value="NPTR"></asp:ListItem>
                        <asp:ListItem Text="NCOT" Value="NCOT"></asp:ListItem>
                        <asp:ListItem Text="NDCT" Value="NDCT"></asp:ListItem>
                        <asp:ListItem Text="NDCC" Value="NDCC"></asp:ListItem>
                        <asp:ListItem Text="Others" Value="Others"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                     <div class="form-group">
                        <label for="txtAddress">🏠 Supplier Address:</label>
                        <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                            </div>
                        </div>
                 
                    <asp:HiddenField ID="hiddenDeletedItems" runat="server" />

                    <!-- Item List -->
                    <div class="card border-primary mt-4">
                        <div class="card-header bg-primary text-white text-center">
                            <h5>📦 Items List</h5>
                        </div>
         <div class="card-body">
                            <div class="table-responsive">
                                <asp:GridView ID="GridView1" runat="server" ClientIDMode="Static" CssClass="table table-bordered"
    AutoGenerateColumns="False"
    DataKeyNames="item_no"
    ShowHeaderWhenEmpty="True">
    <Columns>
<asp:TemplateField HeaderText="Description">
    <ItemTemplate>
        <asp:HiddenField ID="hdnId" runat="server" Value='<%# Eval("item_no") %>'/>
        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control description" 
            Text='<%# Bind("description") %>'></asp:TextBox> <!-- Changed to TextBox -->
    </ItemTemplate>
</asp:TemplateField>
                <asp:TemplateField HeaderText="Invoice no.">
            <ItemTemplate>
                <asp:TextBox ID="txtInvoice" runat="server" CssClass="form-control invoice_no"
                    Text='<%# Bind("invoice_no") %>' AutoPostBack="false"></asp:TextBox>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Quantity">
            <ItemTemplate>
                <asp:TextBox ID="txtQuantity" runat="server" CssClass="form-control quantity"
                    TextMode="Number" Text='<%# Bind("quantity") %>' AutoPostBack="false"></asp:TextBox>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Purpose">
            <ItemTemplate>
                <asp:TextBox ID="txtPurpose" runat="server" CssClass="form-control purpose"
                    Text='<%# Bind("purpose") %>' AutoPostBack="false"></asp:TextBox>
            </ItemTemplate>
        </asp:TemplateField>
           <asp:TemplateField HeaderText="Image URL">
    <ItemTemplate>
        <asp:TextBox ID="txtImageUrl" runat="server" CssClass="form-control image-url" 
            Text='<%# Bind("image_url") %>' ></asp:TextBox>
    </ItemTemplate>
</asp:TemplateField>
        <asp:TemplateField HeaderText="Actions">
            <ItemTemplate>
                <button type="button" class="btn btn-danger btn-sm btnRemove">❌</button>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    <EmptyDataTemplate>
        <tr>
            <td colspan="4" class="text-center">No items available.</td>
        </tr>
    </EmptyDataTemplate>
</asp:GridView>


                                <!-- Hidden field to store JSON data -->
                                <asp:HiddenField ID="hiddenGridData" runat="server" ClientIDMode="Static" />
                            </div>

                           <div class="text-center mt-3">
<asp:Button ID="btnAddRow" runat="server" CssClass="btn btn-success"
                Text="➕ Add Row" OnClientClick="return false;" />
</div>

                            </div>
                        </div>
                    </div>


                    <!-- Submit & Cancel Buttons -->
                    <div class="text-center mt-4">
                        <asp:Button ID="btnUpdate" runat="server" Text="✅ Update Gate Pass" CssClass="btn btn-success" OnClick="btnUpdate_Click" />
                       <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-secondary" Text="❌ Cancel" OnClick="btnCancel_Click" />

                    </div>
                </div>
            </div>
       
    </form>
   <script>
       $(document).ready(function () {
           // Use the GridView's table element (ClientIDMode=Static ensures its id is "GridView1")
           let gridView = document.getElementById("GridView1");
           let itemsTable = gridView.querySelector("tbody");
           if (!itemsTable) {
               itemsTable = document.createElement("tbody");
               gridView.appendChild(itemsTable);
           }
           const companyDropdown = document.getElementById("<%= ddlCompany.ClientID %>");
           const addressField = document.getElementById("<%= txtAddress.ClientID %>");
           function toggleAddressField() {
               if (companyDropdown.value === "Others") {
                   addressField.disabled = false;
                   addressField.removeAttribute("readonly"); // Ensure it's editable
               } else {
                   addressField.disabled = true;
                   addressField.setAttribute("readonly", "readonly"); // Make it read-only
                   addressField.value = ""; // Optional: Clear the field when locked
               }
           }

           // Initial toggle based on current value
           toggleAddressField();
           companyDropdown.addEventListener("change", toggleAddressField);
           // Add Row Button functionality
           $("#btnAddRow").click(function () {
               let newRow = document.createElement("tr");
               newRow.classList.add("itemRow");
               newRow.innerHTML = `
                <td><input type="text" class="form-control description" required></td>
                <td><input type="text" class="form-control invoice_no" required></td>
                <td><input type="number" class="form-control quantity" min="1" required></td>
                <td><input type="text" class="form-control purpose" required></td>
                <td><input type="url" class="form-control image-url" placeholder="Image URL"></td>
                <td><button type="button" class="btn btn-danger btn-sm btnRemove">❌</button></td>
            `;
               itemsTable.appendChild(newRow);
               updateHiddenField();
           });

           // Delete Row functionality
           $(document).on("click", ".btnRemove", function () {
               $(this).closest("tr").remove();
               updateHiddenField();
           });

           // Update hidden field when any input or select value changes
           $(document).on("input change", ".invoice_no, .description, .quantity, .purpose, .image-url", function () {
               updateHiddenField();
           });

           // Update hidden field function (fixed to handle both server-bound and dynamic rows)
           function updateHiddenField() {
               let itemsData = [];

               // Process all rows in the GridView (both server-bound and dynamically added)
               $("#GridView1 tbody tr").each(function () {
                   let $row = $(this);

                   // Check if the row has a description field (select element)
                   let descriptionElement = $row.find("input.description");
                   if (descriptionElement.length > 0) {
                       let invoice_no = $row.find("input.invoice_no").val()?.trim() || "";
                       let description = descriptionElement.val();
                       let quantity = $row.find("input.quantity").val()?.trim() || "";
                       let purpose = $row.find("input.purpose").val()?.trim() || "";
                       let imageUrl = $row.find("input.image-url").val()?.trim() || "";

                       // Only add row if required fields have values
                       if (description && quantity && purpose && invoice_no) {
                           itemsData.push({
                               invoice_no: invoice_no,
                               Description: description,
                               Quantity: quantity,
                               Purpose: purpose,
                               image_url: imageUrl
                           });
                       }
                   }
               });

               // Debug log to console
               console.log("Items data:", itemsData);

               // Save the JSON data to the hidden field and to session storage
               $("#hiddenGridData").val(JSON.stringify(itemsData));
               sessionStorage.setItem("EditDetailsItems", JSON.stringify(itemsData));
           }

           // Before form submission, update the hidden field
           $("#btnUpdate").click(function () {
               updateHiddenField();
               let hiddenData = $("#hiddenGridData").val();

               if (!hiddenData || hiddenData === "[]" || hiddenData === "null") {
                   Swal.fire({
                       title: "No items found",
                       text: "Please add at least one item before saving.",
                       icon: "warning",
                       confirmButtonText: "OK"
                   });
                   return false;
               }
               // Add this block
               if ($("#rbReturnWithDate").is(":checked")) {
                   let returnDateValue = $("#returnDate").val();
                   if (!returnDateValue) {
                       Swal.fire({
                           title: "Missing return date",
                           text: "Please specify a return date.",
                           icon: "warning",
                           confirmButtonText: "OK"
                       });
                       return false;
                   }
               }
               return true;
           });

           // Load existing item data from sessionStorage (if any)
           function loadExistingData() {
               if ($("#GridView1 tbody tr").length > 0) {
                   sessionStorage.removeItem("EditDetailsItems");
                   return;
               }

               let storedData = sessionStorage.getItem("EditDetailsItems");
               if (storedData) {
                   let items = JSON.parse(storedData);
                   items.forEach(function (item) {
                       let newRow = document.createElement("tr");
                       newRow.classList.add("itemRow");
                       newRow.innerHTML = `
                        <td><input type="text" class="form-control description" value="${item.Description || ''}" required></td>
                        <td><input type="text" class="form-control invoice_no" value="${item.invoice_no || ''}" required></td>
                        <td><input type="number" class="form-control quantity" min="1" value="${item.Quantity || ''}" required></td>
                        <td><input type="text" class="form-control purpose" value="${item.Purpose || ''}" required></td>
                        <td><input type="url" class="form-control image-url" value="${item.image_url || ''}" placeholder="Image URL"></td>
                        <td><button type="button" class="btn btn-danger btn-sm btnRemove">❌</button></td>
                    `;
                       itemsTable.appendChild(newRow);
                   });
                   updateHiddenField();
               }
           }

           loadExistingData();

           // Return Status Radio Button Logic
           const returnDateInput = document.getElementById("returnDate");
           const rbReturnWithDate = document.getElementById("rbReturnWithDate");
           const noReturn = document.getElementById("noReturn");

           rbReturnWithDate.addEventListener("change", function () {
               if (rbReturnWithDate.checked) {
                   returnDateInput.disabled = false;
               }
           });

           noReturn.addEventListener("change", function () {
               if (noReturn.checked) {
                   returnDateInput.disabled = true;
                   returnDateInput.value = ""; // Add this line
               }
           });
       });
   </script>
</body>
</html>

