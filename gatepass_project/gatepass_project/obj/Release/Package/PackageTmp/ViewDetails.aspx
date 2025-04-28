<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewDetails.aspx.cs" Inherits="gatepass_project.ViewDetails" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>View Document Details</title>
    <!-- Bootstrap & Font Awesome -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.4.0/css/all.min.css" />
    
    <!-- jQuery & Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            background: #fff;
            padding: 30px;
            border-radius: 8px;
        }
        h2, h5 {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .border-dark {
       border: 1.7px solid black !important; /* Thicker black border */
        }

        /* Card headers for consistency */
        .card-header {
            font-size: 1.2rem;
            font-weight: bold;
        }
        .form-control {
            border-radius: 5px;
            background-color: #e9ecef;
        }
        .btn-custom {
            padding: 10px 20px;
            font-size: 1rem;
            border-radius: 5px;
        }
        /* Enhanced table style */
        .table thead {
            background-color: #343a40;
            color: #fff;
        }
        /* Back button */
        .btn-back {
            font-size: 1rem;
            font-weight: bold;
             margin-top: 50px;
        }
    </style>
</head>
<body>
      <div class="container-fluid mt-4">
    <div class="container bg-white p-4 rounded shadow-lg border border-dark">

        <form id="form1" runat="server">
            <!-- Header Section -->
            <div class="text-center mb-4">
                <h2 class="text-primary"><i class="fas fa-file-alt"></i> Document Details</h2>
            </div>
            
            <!-- Document Details Card -->
            <div class="card border-dark mb-4">
                <div class="card-header bg-primary text-white text-center">
                    <i class="fas fa-info-circle"></i> Document Information
                </div>
                <div class="card-body">
                    <div class="row">
                        <!-- Document Number -->
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="txtDocNo"><i class="fas fa-hashtag"></i> Doc No:</label>
                                <asp:TextBox ID="txtDocNo" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>
                        <!-- Date -->
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="txtDate"><i class="fas fa-calendar-alt"></i> Date:</label>
                                <asp:TextBox ID="txtDate" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Personal & Vehicle Information Card -->
            <div class="card border-info mb-4">
                <div class="card-header bg-info text-white text-center">
                    <i class="fas fa-user"></i> Personal & Vehicle Information
                </div>
                <div class="card-body">
                    <div class="row">
                        <!-- Left Column -->
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="txtName"><i class="fas fa-user-tie"></i> Name:</label>
                                <asp:TextBox ID="txtName" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label for="txtAddress"><i class="fas fa-home"></i> Address:</label>
                                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label for="txtVehicle"><i class="fas fa-car"></i> Vehicle Register No:</label>
                                <asp:TextBox ID="txtVehicle" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>
                        <!-- Right Column -->
                            <div class="col-md-6">
                    <div class="form-group">
                    <label for="ddlCompany">🏢 Factory :</label>
                    <asp:DropDownList ID="ddlCompany" runat="server" CssClass="form-control" ReadOnly="true">
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
                                <label for="txtTel"><i class="fas fa-phone"></i> Telephone No:</label>
                                <asp:TextBox ID="txtTel" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label for="txtTimeout"><i class="fas fa-clock"></i> Time:</label>
                                <asp:TextBox ID="txtTimeout" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Items List Card -->
            <!-- Items List Card -->
<div class="card border-secondary mb-4">
    <div class="card-header bg-secondary text-white text-center">
        <i class="fas fa-box-open"></i> Items List
    </div>
    <div class="card-body">
        <div class="table-responsive">
                        <asp:GridView ID="GridView1" runat="server" 
    CssClass="table table-striped table-bordered border border-dark text-center"
    AutoGenerateColumns="False" 
    EmptyDataText="⚠️ No items found."
    OnRowDataBound="GridView1_RowDataBound"> 

    <HeaderStyle CssClass="bg-dark text-white" />

    <Columns>
        <asp:TemplateField HeaderText="No." ItemStyle-CssClass="text-center">
            <ItemTemplate>
                <asp:Label ID="lblRowNumber" runat="server" />
            </ItemTemplate>
        </asp:TemplateField>

        <asp:BoundField DataField="Description" HeaderText="Description" ItemStyle-CssClass="text-left"/>
        <asp:BoundField DataField="Quantity" HeaderText="Quantity" ItemStyle-CssClass="text-center item-quantity"/>
        <asp:BoundField DataField="Purpose" HeaderText="Purpose" ItemStyle-CssClass="text-left"/>
    </Columns>
</asp:GridView>


        </div>

        <!-- Display Total Quantity -->
        <div class="text-right mt-3">
            <h6><strong>Total Quantity : <span id="totalQuantity">0</span></strong></h6>
        </div>
    </div>
</div>

            
            <!-- Approval Section Card -->
            <div class="card border-success mb-4">
                <div class="card-header bg-success text-white text-center">
                    <h5>✔️ Approval Section</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <!-- Left Column -->
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="txtRequester"><i class="fas fa-user-edit"></i> Requester:</label>
                                <asp:TextBox ID="txtRequester" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label for="txtDept"><i class="fas fa-building"></i> Department:</label>
                                <asp:TextBox ID="txtDept" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label for="txSect"><i class="fas fa-user-cog"></i> Section Manager:</label>
                                <asp:TextBox ID="txSect" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>
                        <!-- Right Column -->
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="txtTel2"><i class="fas fa-phone"></i> Telephone No:</label>
                                <asp:TextBox ID="txtTel2" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label for="txtDgm"><i class="fas fa-user-shield"></i> DGM:</label>
                                <asp:TextBox ID="txtDgm" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label for="txtSecurityGuard"><i class="fas fa-shield-alt"></i> Security Guard:</label>
                                <asp:TextBox ID="txtSecurityGuard" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label for="txtTime"><i class="fas fa-hourglass-half"></i> Time:</label>
                                <asp:TextBox ID="txtTime" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="text-center mt-2 mb-2">
    <asp:Button ID="btnApprove" runat="server" Text="✅ Approve" CssClass="btn btn-success mb-2"
        OnClick="btnApprove_Click" Visible="false" />
</div>
                    <div class="form-group text-center">
                        <h5><strong>Approval Count: </strong> <asp:Label ID="lblApprovalCount" runat="server" CssClass="text-primary font-weight-bold"></asp:Label>/4</h5>
                    </div>

                </div>
            </div>
            <!-- Approval List Card -->
<div class="card border-primary mt-4">
    <div class="card-header bg-success text-white text-center">
        <h5>✔️ Approval List</h5>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <asp:GridView ID="gvApprovalList" runat="server" CssClass="table table-striped table-bordered text-center"
                AutoGenerateColumns="False" EmptyDataText="⚠️ No approvals yet.">
                <HeaderStyle CssClass="bg-dark text-white" />
                <Columns>
                    <asp:BoundField DataField="Approver" HeaderText="Approver" ItemStyle-CssClass="text-left"/>
                    <asp:BoundField DataField="ApprovedAt" HeaderText="Approved At" ItemStyle-CssClass="text-center"/>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</div>



            <!-- Back Button -->
           <!-- Back Button (Wrapped in a Div for Exclusion) -->
<div id="excludePrint" class="text-center mb-4">
   <asp:HyperLink ID="lnkBackToDocuments" runat="server" CssClass="btn btn-secondary btn-back">
    ⬅ Back to Documents
</asp:HyperLink>

    <div class="text-right mt-3">
    <button type="button" class="btn btn-lg btn-danger font-weight-bold px-4 py-2" onclick="exportToPDF()">
        📄 Export to PDF
    </button>
</div>

</div>

        </form>
    </div>
               </div>


    <script>
    $(document).ready(function () {
        calculateTotalQuantity(); // Run the function on page load
    });

    function calculateTotalQuantity() {
        let total = 0;

        // Loop through all quantity values in the GridView
        $(".item-quantity").each(function () {
            let quantity = parseInt($(this).text().trim()) || 0; // Ensure valid integer
            total += quantity;
        });

        // Display total quantity
        $("#totalQuantity").text(total);
        }

        function exportToPDF() {
            let { jsPDF } = window.jspdf;
            let doc = new jsPDF({
                orientation: 'portrait',
                unit: 'mm',
                format: 'a4'
            });

            // Hide Back Button Before Export
            document.getElementById("excludePrint").style.display = "none";

            html2canvas(document.body, { scale: 2 }).then(canvas => {
                let imgData = canvas.toDataURL("image/png");
                let imgWidth = 210; // A4 width
                let imgHeight = (canvas.height * imgWidth) / canvas.width;

                doc.addImage(imgData, "PNG", 0, 0, imgWidth, imgHeight);
                doc.save("DocumentDetails.pdf");

                // Show Back Button Again After Export
                document.getElementById("excludePrint").style.display = "block";
            });
        }
    </script>


</body>
</html>
