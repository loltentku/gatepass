<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditDetails.aspx.cs" Inherits="gatepass_project.EditDetails" EnableViewState="true" %>

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
                            <asp:TextBox ID="txtDate" runat="server" CssClass="form-control w-auto" Enabled="false" TextMode="Date"></asp:TextBox>
                        </div>
                    </div>

                    <hr />

                    <!-- Personal & Vehicle Info -->
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>👤 Name:</label>
                          <asp:TextBox ID="txtName" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                         
                             <div class="form-group">
                                <label>⏰ Time:</label>
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
                                <label>🏠Supplier Address:</label>
                                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>

                           <div class="col-md-6">
                    <div class="form-group">
                    <label for="ddlFactory">🏢 Factory :</label>
                   <asp:DropDownList ID="ddlFactory" runat="server" CssClass="form-control" Enabled="false">
                        <asp:ListItem Text="NETL" Value="NETL"></asp:ListItem>
                        <asp:ListItem Text="NETR" Value="NETR"></asp:ListItem>
                        <asp:ListItem Text="NPTA" Value="NPTA"></asp:ListItem>
                        <asp:ListItem Text="NPTR" Value="NPTR"></asp:ListItem>
                        <asp:ListItem Text="NCOT" Value="NCOT"></asp:ListItem>
                        <asp:ListItem Text="NDCT" Value="NDCT"></asp:ListItem>
                        <asp:ListItem Text="NDCC" Value="NDCC"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                               <div class="form-group">
    <label for="ddlItemType">📋 Item Type:</label>
    <asp:DropDownList ID="ddlItemType" runat="server" CssClass="form-control">
        <asp:ListItem Text="Scrap" Value="Scrap"></asp:ListItem>
        <asp:ListItem Text="Assets" Value="Assets"></asp:ListItem>
        <asp:ListItem Text="Accessories" Value="Accessories"></asp:ListItem>
        <asp:ListItem Text="Waste" Value="Waste"></asp:ListItem>
        <asp:ListItem Text="Others" Value="Others"></asp:ListItem>
    </asp:DropDownList>
</div>
                            <div class="form-group">
                                <label>📞 Telephone No:</label>
                                <asp:TextBox ID="txtTel" runat="server" CssClass="form-control"></asp:TextBox>
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
            AutoGenerateColumns="False" DataKeyNames="item_no" ShowHeaderWhenEmpty="True">
            <Columns>
              <asp:TemplateField HeaderText="Description">
    <ItemTemplate>
        <asp:HiddenField ID="hdnId" runat="server" Value='<%# Eval("item_no") %>'/>
        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control description" 
            Text='<%# Bind("description") %>'></asp:TextBox> <!-- Note: Use "description" to match database field -->
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
                <asp:TemplateField HeaderText="Image">
                    <ItemTemplate>
                        <asp:TextBox ID="txtImageUrl" runat="server" CssClass="form-control image-url" 
                            Text='<%# Bind("image_url") %>'></asp:TextBox>
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
                    <td colspan="5" class="text-center">No items available.</td>
                </tr>
            </EmptyDataTemplate>
        </asp:GridView>
        <!-- Hidden field to store JSON data -->
        <asp:HiddenField ID="hiddenGridData" runat="server" ClientIDMode="Static" />
    </div>
    <div class="text-center mt-3">
        <asp:Button ID="btnAddRow" runat="server" CssClass="btn btn-success" Text="➕ Add Row" OnClientClick="return false;" />
    </div>
</div>


                            </div>
                        </div>
                    </div>

                    <!-- Approval Section -->
                    <div class="card mt-4">
                        <div class="card-header bg-success text-white text-center">
                            <h5>✔️ Approval Section</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>📝 Requester:</label>
                                        <asp:TextBox ID="txtRequester" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div class="form-group">
                                        <label>🏢 Department:</label>
                                        <asp:TextBox ID="txtDept" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div class="form-group">
                                        <label>👨‍💼 Section Manager:</label>
                                        <asp:TextBox ID="txSect" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                      <div class="form-group">
                                        <label>⏳ Time:</label>
                                        <asp:TextBox ID="txtTime" runat="server" CssClass="form-control" TextMode="Time"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>📞 Telephone No:</label>
                                        <asp:TextBox ID="txtTel2" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div class="form-group">
                                        <label>👨‍💼 DGM:</label>
                                        <asp:TextBox ID="txtDgm" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                    <div class="form-group">
                                        <label>🛡 Security Guard:</label>
                                        <asp:TextBox ID="txtSecurityGuard" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                  
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
             // Ensure there is a tbody for any dynamically added rows
             let itemsTable = gridView.querySelector("tbody");
             if (!itemsTable) {
                 itemsTable = document.createElement("tbody");
                 gridView.appendChild(itemsTable);
             }
             let ddlCompany = document.getElementById("<%= ddlCompany.ClientID %>");
        let txtAddress = document.getElementById("<%= txtAddress.ClientID %>");

        // Toggle txtAddress based on ddlCompany
        function toggleAddressField() {
            if (ddlCompany.value === "Others") {
                txtAddress.removeAttribute("disabled");
            } else {
                txtAddress.setAttribute("disabled", "disabled");
            }
        }

        // Add Row Button functionality
        $("#btnAddRow").click(function () {
            let newRow = document.createElement("tr");
            newRow.classList.add("itemRow");
            newRow.innerHTML = `
                <td><input type="text" class="form-control description" required></td> 
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
        $(document).on("input change", ".description, .quantity, .purpose, .image-url", function () {
            updateHiddenField();
        });

        // Update hidden field function
        function updateHiddenField() {
            let itemsData = [];
            // Select every row that contains either an input or select with the class .description
            $("#GridView1 tr").has("input.description, select.description").each(function () {
                let id = $(this).find("input[type='hidden']").first().val() || "";
                let description = $(this).find(".description").is("select") ?
                    $(this).find("select.description").val() :
                    $(this).find("input.description").val().trim();
                let quantity = $(this).find("input.quantity").val().trim();
                let purpose = $(this).find("input.purpose").val().trim();
                let imageUrl = $(this).find("input.image-url").val().trim();

                // Only push the row if all required fields have a value
                if (description && quantity && purpose) {
                    itemsData.push({
                        ItemID: id,
                        Description: description,
                        Quantity: quantity,
                        Purpose: purpose,
                        image_url: imageUrl
                    });
                }
            });

            // Save the JSON data to the hidden field and session storage
            $("#hiddenGridData").val(JSON.stringify(itemsData));
            sessionStorage.setItem("EditDetailsItems", JSON.stringify(itemsData));
        }

        // Before form submission, update the hidden field and validate
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

            // Validate main form fields, excluding disabled fields
            let isValid = true;
            $("input[type='text'], input[type='number'], input[type='date'], input[type='time']").each(function () {
                if (!$(this).is(":disabled") &&
                    !$(this).hasClass("description") &&
                    !$(this).hasClass("quantity") &&
                    !$(this).hasClass("purpose") &&
                    !$(this).hasClass("image-url") &&
                    $(this).val().trim() === "") {
                    isValid = false;
                }
            });

            if (!isValid) {
                Swal.fire({
                    title: "⚠️ Missing Information!",
                    text: "Please fill out all required fields before submitting.",
                    icon: "warning",
                    confirmButtonText: "OK"
                });
                return false;
            }
            return true;
        });

        // Load existing item data from sessionStorage (if any)
        function loadExistingData() {
            // If the GridView already has rows, do not load additional rows from sessionStorage
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
                       <td><input type="text" class="form-control description" value="${item.Description}" required></td> 
                        <td><input type="number" class="form-control quantity" min="1" value="${item.Quantity}" required></td>
                        <td><input type="text" class="form-control purpose" value="${item.Purpose}" required></td>
                        <td><input type="url" class="form-control image-url" value="${item.image_url || ''}" placeholder="Image URL"></td>
                        <td><button type="button" class="btn btn-danger btn-sm btnRemove">❌</button></td>
                    `;
                    itemsTable.appendChild(newRow);
                });
                updateHiddenField();
            }
        }

        // Initialize
        loadExistingData();
        toggleAddressField();
        ddlCompany.addEventListener("change", toggleAddressField);
    });
     </script>
</body>
</html>
