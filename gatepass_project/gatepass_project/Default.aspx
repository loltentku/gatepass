<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="gatepass_project._Default" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>Gate Pass Form</title>
    
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
    


    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            
        }
        .table thead {
            background: #cf4a0d;
            color: white;
        }
        .btn-primary {
            background: #0026ff;
            border: none;
            padding: 10px 20px;
            font-size: 18px;
            border-radius: 5px;
        }
        .form-control {
            border-radius: 5px;
        }
    </style>
</head>
<body>

   <div class="container mt-4 shadow-lg border border-dark p-4 rounded">

       <!-- Back Button at the Top Left -->
<div class="d-flex justify-content-start mb-3">
    <a href="ViewDocuments.aspx" class="btn btn-secondary">
        ⬅️ Back
    </a>
</div>

        <form id="form1" runat="server">

          <!-- Header -->
<div class="text-center mb-4">
    <h2 class="text-primary font-weight-bold">Gate Pass Form</h2>
</div>

<!-- Doc No and Date Fields -->
<div class="d-flex justify-content-between">
   
<div class="d-flex align-items-center">
    <label for="txtDocNo" class="mr-2 font-weight-bold">📄 Doc No:</label>
    <asp:TextBox ID="txtDocNo" runat="server" CssClass="form-control w-auto" ReadOnly="true"></asp:TextBox>
</div>


    <!-- Date (Right) -->
   <div class="d-flex align-items-center">
    <label for="txtDate" class="mr-2 font-weight-bold">📅 Date:</label>
    <asp:TextBox ID="txtDate" runat="server" CssClass="form-control w-auto" TextMode="Date" ReadOnly="true"></asp:TextBox>
</div>

</div>

<hr />

            <!-- Personal & Vehicle Info -->
            <div class="row">
                <div class="col-md-6">
                  <div class="form-group">
    <label for="txtName">👤 Name:</label>
    <asp:TextBox ID="txtName" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
</div>
                     
                     <div class="form-group">
                        <label for="txtTel">📞 Telephone No:</label>
                        <asp:TextBox ID="txtTel" runat="server" CssClass="form-control"></asp:TextBox>
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

                  <div class="col-md-6">
                    <div class="form-group">
                    <label for="ddlFactory">🏢 Factory :</label>
                    <asp:DropDownList ID="ddlFactory" runat="server" CssClass="form-control">
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
                        <label for="txtTimeout">⏰ Departure Time:</label>
                        <asp:TextBox ID="txtTimeout" runat="server" CssClass="form-control" TextMode="Time"></asp:TextBox>
                    </div>

                    
         
                    
                </div>
            </div>
            

            <!-- Item Table -->
 <div class="card border-dark mt-4">

    <div class="card-header bg-primary text-white text-center">
        <h5>📦 Items List</h5>
    </div>
   <div class="card-body">
    <div class="table-responsive">
        <asp:GridView ID="GridView1" runat="server" CssClass="table table-bordered border border-dark" AutoGenerateColumns="False">
            <Columns>
                <asp:TemplateField HeaderText="Description">
    <ItemTemplate>
        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control description" 
            Text='<%# Bind("Description") %>'></asp:TextBox>
    </ItemTemplate>
</asp:TemplateField>
                <asp:TemplateField HeaderText="Quantity">
                    <ItemTemplate>
                        <asp:TextBox ID="txtQuantity" runat="server" CssClass="form-control quantity" 
                            TextMode="Number" Text='<%# Bind("Quantity") %>'></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Purpose">
                    <ItemTemplate>
                        <asp:TextBox ID="txtPurpose" runat="server" CssClass="form-control purpose" 
                            Text='<%# Bind("Purpose") %>'></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
               <asp:TemplateField HeaderText="Image">
    <ItemTemplate>
        <asp:FileUpload ID="fileUploadItem" runat="server" CssClass="form-control-file" />
    </ItemTemplate>
</asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <asp:HiddenField ID="hiddenGridData" runat="server" ClientIDMode="Static" />
    
    <table class="table table-bordered table-striped">
        <thead>
            <tr>
                <th>Description</th>
                <th>Quantity</th>
                <th>Purpose</th>
                <th>Image</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody id="itemsTable"></tbody>
    </table>

    <!-- Buttons -->
    <div class="text-center">
        <asp:Button ID="btnAddRow" runat="server" CssClass="btn btn-success"
            Text="➕ Add Row" OnClientClick="return false;" />
        <asp:Button ID="btnFinish" runat="server" Text="Finish" CssClass="btn btn-primary"
            OnClick="btnFinish_Click" />
    </div>

    <!-- Total Quantity Display -->
    <div class="text-right mt-2">
        <strong>Total Quantity:</strong>
        <asp:Label ID="lblTotalQuantity" runat="server" CssClass="font-weight-bold text-primary">0</asp:Label>
    </div>
</div>

             <div class="container border border-dark p-3 rounded">
    <div class="card-header bg-success text-white text-center">

                <h5>✔️ Approval Section</h5>
            </div>
            <div class="container">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="txtRequester">📝 Requester:</label>
                            <asp:TextBox ID="txtRequester" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtDept">🏢 Department:</label>
                            <asp:TextBox ID="txtDept" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txSect">👨‍💼 Section Manager:</label>
                            <asp:TextBox ID="txSect" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                                  <div class="form-group">
                        <label for="txtTime">⏳ Time:</label>
                        <asp:TextBox ID="txtTime" runat="server" CssClass="form-control" TextMode="Time"></asp:TextBox>
                    </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="txtTel2">📞 Telephone No:</label>
                            <asp:TextBox ID="txtTel2" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtDgm">👨‍💼 DGM:</label>
                            <asp:TextBox ID="txtDgm" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtSecurityGuard">🛡 Security Guard:</label>
                            <asp:TextBox ID="txtSecurityGuard" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                
                    </div>
                </div>
            </div>
        </div>

        <!-- Submit Button -->
        <div class="container">
            <asp:Button ID="btnSubmit" runat="server" Text="Submit Gate Pass" CssClass="btn btn-success" OnClick="btnSubmit_Click" />
         
        <a href="ViewDocuments.aspx" class="btn btn-info">
            📂 View Documents
        </a>
    </div>
      
        </form>
   

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            let itemsTable = document.querySelector("#itemsTable");
            let totalLabel = document.getElementById("<%= lblTotalQuantity.ClientID %>");
        let submitButton = document.getElementById("btnSubmit");
        let addRowButton = document.getElementById("btnAddRow");
        let finishButton = document.getElementById("btnFinish");
        let hiddenField = document.getElementById("hiddenGridData");
            let ddlCompany = document.getElementById("<%= ddlCompany.ClientID %>");
            let txtAddress = document.getElementById("<%= txtAddress.ClientID %>");

            // Function to toggle txtAddress based on ddlCompany value
            function toggleAddressField() {
                if (ddlCompany.value === "Others") {
                    txtAddress.removeAttribute("disabled");
                } else {
                    txtAddress.setAttribute("disabled", "disabled");
                }
            }

        
        // ✅ Step 1: Lock/Unlock Items Based on Submission State
        if (sessionStorage.getItem("FormSubmitted") === "true") {
            unlockItemList();
            addRowButton.disabled = false;
            finishButton.disabled = false;
        } else {
            lockItemList();
            addRowButton.disabled = true;
            finishButton.disabled = true;
        }

        // ✅ Ensure hidden field is updated before form submission
        submitButton.addEventListener("click", function (event) {
            updateHiddenField(); // Ensure data is stored

            if (!validateMainForm()) {
                event.preventDefault();

                Swal.fire({
                    title: "⚠️ Missing Information!",
                    text: "Please fill out all required fields before submitting.",
                    icon: "warning",
                    confirmButtonText: "OK"
                });

            } else {
                sessionStorage.setItem("FormSubmitted", "true");

                unlockItemList();
                addRowButton.disabled = false;
                finishButton.disabled = false;
            }
        });

        // ✅ Step 3: Calculate Total Quantity
        function calculateTotal() {
            let total = 0;
            document.querySelectorAll(".itemRow .quantity").forEach(input => {
                let value = parseInt(input.value) || 0;
                total += value;
            });
            totalLabel.innerText = total;
        }

        // ✅ Step 4: "Add Row" Button - Append New Row
            addRowButton.addEventListener("click", function () {
                let newRow = document.createElement("tr");
                newRow.classList.add("itemRow");
                newRow.innerHTML = `
        <td><input type="text" class="form-control description" required></td> <!-- Changed to text input -->
        <td><input type="number" class="form-control quantity" min="1" required></td>
        <td><input type="text" class="form-control purpose" required></td>
        <td><input type="url" class="form-control image-url" placeholder="Image URL"></td>
        <td><button type="button" class="btn btn-danger removeRow">❌</button></td>
    `;
                itemsTable.appendChild(newRow);
                attachQuantityListeners();
                calculateTotal();
                updateHiddenField();
            });

        // ✅ Step 5: Remove a Row & Update Total
        itemsTable.addEventListener("click", function (event) {
            if (event.target.classList.contains("removeRow")) {
                event.target.closest("tr").remove();
                calculateTotal();
                updateHiddenField();
            }
        });

        // ✅ Step 6: Lock all item input fields until the form is submitted
        function lockItemList() {
            document.querySelectorAll(".description, .quantity, .purpose, .image-url").forEach(input => {
                input.setAttribute("readonly", true);
            });
        }

        // ✅ Step 7: Unlock the item input fields after form submission
        function unlockItemList() {
            document.querySelectorAll(".description, .quantity, .purpose, .image-url").forEach(input => {
                input.removeAttribute("readonly");
            });
        }

        // ✅ Step 8: Validate Only the Main Form Fields (Excludes GridView)
            function validateMainForm() {
                let isValid = true;
                document.querySelectorAll("input[type='text'], input[type='number'], input[type='date'], input[type='time']").forEach(input => {
                    // Skip validation for disabled fields and item table fields
                    if (
                        input.value.trim() === "" &&
                        !input.disabled && // Exclude disabled fields
                        !input.classList.contains("description") &&
                        !input.classList.contains("quantity") &&
                        !input.classList.contains("purpose") &&
                        !input.classList.contains("image-url")
                    ) {
                        isValid = false;
                    }
                });
                return isValid;
            }

        // ✅ Step 9: Validate Item List Before Submission
        function validateRows() {
            let valid = false; // Start as false; check if any valid item exists
            document.querySelectorAll(".itemRow").forEach(row => {
                let description = row.querySelector(".description").value.trim();
                let quantity = row.querySelector(".quantity").value.trim();
                let purpose = row.querySelector(".purpose").value.trim();

                // If at least one row has all three fields filled, mark as valid
                if (description !== "" && quantity !== "" && purpose !== "") {
                    valid = true;
                }
            });

            if (!valid) {
                Swal.fire({
                    title: "⚠️ No Items Found!",
                    text: "Please enter at least 1 valid item before submitting.",
                    icon: "warning",
                    confirmButtonText: "OK"
                });
            }

            return valid;
        }

        // ✅ Step 10: Update Total When Quantity Fields Change
        function attachQuantityListeners() {
            document.querySelectorAll(".quantity").forEach(input => {
                input.addEventListener("input", function () {
                    calculateTotal();
                    updateHiddenField();
                });
            });
        }

        // ✅ Step 11: Validate Item List on Finish Button Click
        finishButton.addEventListener("click", function (event) {
            updateHiddenField(); // Ensure item data is saved before processing
            if (!validateRows()) {
                event.preventDefault();
            }
        });

        // ✅ Step 12: Store Data in Hidden Field Before Submission
        function updateHiddenField() {
            let data = [];
            document.querySelectorAll(".itemRow").forEach(row => {
                let description = row.querySelector(".description").value.trim();
                let quantity = row.querySelector(".quantity").value.trim();
                let purpose = row.querySelector(".purpose").value.trim();
                let imageUrl = row.querySelector(".image-url").value.trim();

                // Only push rows with non-empty values for description, quantity, and purpose
                if (description !== "" && quantity !== "" && purpose !== "") {
                    data.push({ description, quantity, purpose, image_url: imageUrl });
                }
            });
            hiddenField.value = JSON.stringify(data);
        }

        // ✅ Step 13: Load Saved Data from Hidden Field on Page Load
        function loadHiddenFieldData() {
            if (hiddenField.value) {
                let data = JSON.parse(hiddenField.value);
                data.forEach(item => {
                    let newRow = document.createElement("tr");
                    newRow.classList.add("itemRow");
                    newRow.innerHTML = `
                        <td><input type="text" class="form-control description" value="${item.description}" required></td>
                        <td><input type="number" class="form-control quantity" min="1" value="${item.quantity}" required></td>
                        <td><input type="text" class="form-control purpose" value="${item.purpose}" required></td>
                        <td><input type="url" class="form-control image-url" value="${item.image_url || ''}" placeholder="Image URL"></td>
                        <td><button type="button" class="btn btn-danger removeRow">❌</button></td>
                    `;
                    itemsTable.appendChild(newRow);
                });
                attachQuantityListeners();
                calculateTotal();
            }
        }

        loadHiddenFieldData();
        attachQuantityListeners();
            calculateTotal();

            toggleAddressField();


            ddlCompany.addEventListener("change", toggleAddressField);
    });
    </script>

</body>
</html>