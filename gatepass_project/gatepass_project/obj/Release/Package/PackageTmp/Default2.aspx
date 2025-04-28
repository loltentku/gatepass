<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default2.aspx.cs" Inherits="gatepass_project.Default2" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>Gate Pass Form</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.4.0/css/all.min.css" integrity="sha512-pK0j4bdSlQ5H2z5+2eFzI/IR0TL+Ek2nW4G2z3IZMRJdIiz47dx/HPxf6Xc1AOm03ZhdFj3W0chO6JcDlwBM6w==" crossorigin="anonymous" referrerpolicy="no-referrer" />

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

        <form id="form1" runat="server">

          <!-- Header -->
<div class="text-center mb-4">
    <h2 class="text-primary font-weight-bold">Gate Pass for finished goods Form</h2>
</div>

<!-- Doc No and Date Fields -->
<div class="d-flex justify-content-between">
    <!-- Doc No (Left) -->
   <!-- Doc No Field (Read-Only) -->
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
        
<div class="row">
    
   
    <div class="col-md-6">
        <div class="form-group mt-3 mb-3 border p-3">
            <label class="font-weight-bold mr-3">Factory:</label>
            <div class="d-flex flex-wrap">
                <div class="form-check form-check-inline">
                    <asp:RadioButton ID="rbNETL" runat="server" GroupName="factoryGroup" CssClass="form-check-input" />
                    <label class="form-check-label" for="rbNETL">NETL</label>
                </div>
                <div class="form-check form-check-inline">
                    <asp:RadioButton ID="rbNETR" runat="server" GroupName="factoryGroup" CssClass="form-check-input" />
                    <label class="form-check-label" for="rbNETR">NETR</label>
                </div>
                <div class="form-check form-check-inline">
                    <asp:RadioButton ID="rbNPTA" runat="server" GroupName="factoryGroup" CssClass="form-check-input" />
                    <label class="form-check-label" for="rbNPTA">NPTA</label>
                </div>
                <div class="form-check form-check-inline">
                    <asp:RadioButton ID="rbNPTR" runat="server" GroupName="factoryGroup" CssClass="form-check-input" />
                    <label class="form-check-label" for="rbNPTR">NPTR</label>
                </div>
                <div class="form-check form-check-inline">
                    <asp:RadioButton ID="rbNCOT" runat="server" GroupName="factoryGroup" CssClass="form-check-input" />
                    <label class="form-check-label" for="rbNCOT">NCOT</label>
                </div>
                <div class="form-check form-check-inline">
                    <asp:RadioButton ID="rbNDCT" runat="server" GroupName="factoryGroup" CssClass="form-check-input" />
                    <label class="form-check-label" for="rbNDCT">NDCT</label>
                </div>
                <div class="form-check form-check-inline">
                    <asp:RadioButton ID="rbNDCC" runat="server" GroupName="factoryGroup" CssClass="form-check-input" />
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
                    <asp:RadioButton ID="rbPart" runat="server" GroupName="TypeGroup" CssClass="form-check-input" />
                    <label class="form-check-label" for="rbPart">Part</label>
                </div>
                <div class="form-check form-check-inline">
                    <asp:RadioButton ID="rbMachine" runat="server" GroupName="TypeGroup" CssClass="form-check-input" />
                    <label class="form-check-label" for="rbMachine">Machine</label>
                </div>
                <div class="form-check form-check-inline">
                    <asp:RadioButton ID="rbOther" runat="server" GroupName="TypeGroup" CssClass="form-check-input" />
                    <label class="form-check-label" for="rbOther">Others</label>
                </div>
            </div>
        </div>
    </div>

</div>





            <!-- Personal & Vehicle Info -->
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="txtName">👤 Name:</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="txtVehicle">🚗 Vehicle Register No:</label>
                        <asp:TextBox ID="txtVehicle" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="txtAsset">💰 External Transfer Assets No:</label>
                        <asp:TextBox ID="txtAsset" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                </div>
                

                <div class="col-md-6">
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
                        <label for="txtTimeout">⏰ Departure Time:</label>
                        <asp:TextBox ID="txtTimeout" runat="server" CssClass="form-control" TextMode="Time"></asp:TextBox>
                    </div>
                </div>
            </div>


            <div class="form-group">
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


       
 

            <!-- Item Table -->
 <div class="card border-dark mt-4">

    <div class="card-header bg-primary text-white text-center">
        <h5>📦 Items List</h5>
    </div>
    <div class="card-body">
        <!-- ✅ FIX: Ensure GridView stays inside a responsive wrapper -->
        <div class="table-responsive">
            <asp:GridView ID="GridView1" runat="server" CssClass="table table-bordered border border-dark"

                AutoGenerateColumns="False">
                <Columns>
                    <asp:TemplateField HeaderText="Invoice no.">
                        <ItemTemplate>
                            <asp:TextBox ID="txtInvoice" runat="server" CssClass="form-control description"
                                Text='<%# Bind("Invoice") %>'></asp:TextBox>
                        </ItemTemplate>
                    </asp:TemplateField>
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
                </Columns>
            </asp:GridView>
        </div>
 <asp:HiddenField ID="hiddenGridData" runat="server" ClientIDMode="Static" />
        
        <table class="table table-bordered table-striped">
            <thead>
                <tr> 
                    <th>Invoice no.</th>
                    <th>Description</th>
                    <th>Quantity</th>
                    <th>Purpose</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody id="itemsTable"></tbody>
        </table>

        <!-- ✅ Buttons -->
        <div class="text-center">
            <asp:Button ID="btnAddRow" runat="server" CssClass="btn btn-success"
                Text="➕ Add Row" OnClientClick="return false;" />
            <asp:Button ID="btnFinish" runat="server" Text="Finish" CssClass="btn btn-primary"
                OnClick="btnFinish_Click" />
        </div>
    </div>
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
                        <label for="txtCheck">✅ Checked by:</label>
                        <asp:TextBox ID="txtCheck" runat="server" CssClass="form-control" ></asp:TextBox>
                    </div>
                    </div>

                    <div class="col-md-6">
                        
                     
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
          const returnDateInput = document.getElementById("returnDate");
          const rbReturnWithDate = document.getElementById("rbReturnWithDate");
          const noReturn = document.getElementById("noReturn");


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
                updateHiddenField(); // ✅ Ensure data is stored

                if (!validateMainForm()) {
                    event.preventDefault();

                    // ✅ Replace modal with SweetAlert
                    Swal.fire({
                        title: "⚠️ Missing Information!",
                        text: "Please fill out all required fields before submitting.",
                        icon: "warning",
                        confirmButtonText: "OK"
                    });

                } else {
                    // ✅ Mark the form as successfully submitted
                    sessionStorage.setItem("FormSubmitted", "true");

                    // ✅ Unlock the grid immediately
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
            <td><input type="text" class="form-control invoice_no"></td>
            <td><input type="text" class="form-control description" required></td>
            <td><input type="number" class="form-control quantity" min="1" required></td>
            <td><input type="text" class="form-control purpose" required></td>
            <td><button type="button" class="btn btn-danger removeRow">❌</button></td>
        `;

              // Append row to table
              itemsTable.appendChild(newRow);

              // Attach event listeners, update total and hidden field
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
              document.querySelectorAll(".invoice_no, .description, .quantity, .purpose").forEach(input => {
                  input.setAttribute("readonly", true);
              });
          }

          // ✅ Step 7: Unlock the item input fields after form submission
          function unlockItemList() {
              document.querySelectorAll(".invoice_no, .description, .quantity, .purpose").forEach(input => {
                  input.removeAttribute("readonly");
              });
          }

          // ✅ Step 8: Validate Only the Main Form Fields (Excludes GridView)
            function validateMainForm() {
                let isValid = true;

                // Loop through all input fields
                document.querySelectorAll("input[type='text'], input[type='number'], input[type='date'], input[type='time']").forEach(input => {
                    // Skip validation for disabled inputs (for example, returnDate when "No return" is selected)
                    if (input.disabled) {
                        return; // continue to the next input
                    }
                    if (
                        input.value.trim() === "" &&
                        !input.classList.contains("description") &&
                        !input.classList.contains("quantity") &&
                        !input.classList.contains("purpose")
                    ) {
                        isValid = false;
                    }
                });

                // Check if a factory group radio button is selected
                if (!document.querySelector("input[name='factoryGroup']:checked")) {
                    isValid = false;
                    Swal.fire({
                        title: "Missing Selection",
                        text: "Please select a factory group before proceeding.",
                        icon: "warning",
                        confirmButtonText: "OK"
                    });
                }

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
                  // ✅ Replace modal with SweetAlert
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
                  let invoice_no = row.querySelector(".invoice_no").value.trim();
                  let description = row.querySelector(".description").value.trim();
                  let quantity = row.querySelector(".quantity").value.trim();
                  let purpose = row.querySelector(".purpose").value.trim();

                  // Only push rows with non-empty values
                  if (description !== "" && quantity !== "" && purpose !== "") {
                      data.push({ invoice_no, description, quantity, purpose });
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
                   <td><input type="text" class="form-control invoice_no" value="${item.invoice_no}" required></td>
                    <td><input type="text" class="form-control description" value="${item.description}" required></td>
                    <td><input type="number" class="form-control quantity" min="1" value="${item.quantity}" required></td>
                    <td><input type="text" class="form-control purpose" value="${item.purpose}" required></td>
                    <td><button type="button" class="btn btn-danger removeRow">❌</button></td>
                `;
                      itemsTable.appendChild(newRow);
                  });
                  attachQuantityListeners();
                  calculateTotal();
              }
              rbReturnWithDate.addEventListener("change", function () {
                  if (rbReturnWithDate.checked) {
                      returnDateInput.disabled = false;
                  }
              });
              noReturn.addEventListener("change", function () {
                  if (noReturn.checked) {
                      returnDateInput.disabled = true;
                  }
              });
            }


          loadHiddenFieldData();
          attachQuantityListeners();
          calculateTotal();
      });




    </script>

</body>
</html>