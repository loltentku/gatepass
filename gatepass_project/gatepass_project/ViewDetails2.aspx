<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewDetails2.aspx.cs" Inherits="gatepass_project.ViewDetails2" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>View Document Details</title>
    <!-- Bootstrap & Font Awesome -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    
    <!-- jQuery & Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .container {
            background: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .card {
            margin-bottom: 20px;
            border: 1.7px solid #343a40;
        }
        .card-header {
            font-size: 1.4rem;
            font-weight: 600;
            background-color: #343a40;
            color: #fff;
        }
        .form-control {
            border-radius: 5px;
            background-color: #e9ecef;
            font-size: 1.1rem;
        }
        label {
            font-size: 1.1rem;
            font-weight: 500;
        }
        .btn-custom {
            padding: 12px 24px;
            font-weight: bold;
            border-radius: 5px;
            transition: all 0.3s ease;
        }
        .btn-custom:hover {
            opacity: 0.9;
            transform: scale(1.05);
        }
        .btn-custom:focus {
            outline: 2px solid #007bff;
            outline-offset: 2px;
        }
        .table thead {
            background-color: #343a40;
            color: #fff;
        }
        .badge-status {
            font-size: 1rem;
            padding: 8px 12px;
        }
        .progress {
            height: 20px;
            margin-top: 10px;
        }
        .btn-back {
            font-size: 1rem;
            font-weight: bold;
            margin-top: 20px;
        }
        .fade-out {
            opacity: 1;
            transition: opacity 1s ease-out;
        }
        .fade-out.remove {
            opacity: 0;
        }
        .form-check-inline {
            margin-right: 15px;
        }
        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }
            .btn-custom {
                width: 100%;
                margin-bottom: 10px;
            }
            .form-check-inline {
                display: block;
                margin-bottom: 10px;
            }
        }
        @media print {
            #excludePrint, .btn, .progress {
                display: none;
            }
            .card {
                border: 1px solid #000;
            }
        }
    </style>
</head>
<body>
    <div class="container-fluid mt-4">
        <div class="container">
            <form id="form1" runat="server">
      
              <!-- Header Section -->
<div class="text-center mb-4">
    <h2 class="text-primary"><i class="fas fa-file-alt"></i> Document Details</h2>
</div>
<!-- Document Number Moved to Card -->

        <!-- Document Information Card -->
<div class="card">
    <div class="card-header text-center"><i class="fas fa-info-circle"></i> Document Information</div>
    <div class="card-body">
        <div class="row">
            <div class="col-12 col-md-6">
                <div class="form-group">
                    <label for="txtDocNo"><i class="fas fa-hashtag"></i> Doc No:</label>
                    <asp:TextBox ID="txtDocNo" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                </div>
            </div>
            <div class="col-12 col-md-6">
                <div class="form-group">
                    <label for="txtDate"><i class="fas fa-calendar-alt"></i> Date & Time Created:</label>
                    <asp:TextBox ID="txtDate" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                </div>
            </div>
        </div>
    </div>
</div>

                <!-- Factory & Type (Collapsible) -->
                <div class="card">
                    <div class="card-header" id="headingFactoryType">
                        <h5 class="mb-0">
                            <button class="btn btn-link text-white" type="button" data-toggle="collapse" data-target="#collapseFactoryType" aria-expanded="true" aria-controls="collapseFactoryType">
                                <i class="fas fa-industry"></i> Factory & Type
                            </button>
                        </h5>
                    </div>
                    <div id="collapseFactoryType" class="collapse show" aria-labelledby="headingFactoryType">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-12 col-md-6">
                                    <div class="form-group mt-3 mb-3 border p-3">
                                        <label class="font-weight-bold mr-3"><i class="fas fa-building"></i> Factory:</label>
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
                    </div>
                </div>

                <!-- Personal Information Card (Collapsible) -->
                <div class="card">
                    <div class="card-header" id="headingPersonal">
                        <h5 class="mb-0">
                            <button class="btn btn-link text-white" type="button" data-toggle="collapse" data-target="#collapsePersonal" aria-expanded="true" aria-controls="collapsePersonal">
                                <i class="fas fa-user"></i> Personal Information
                            </button>
                        </h5>
                    </div>
                    <div id="collapsePersonal" class="collapse show" aria-labelledby="headingPersonal">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-12 col-md-6">
                                    <div class="form-group">
                                        <label for="txtName"><i class="fas fa-user-tie"></i> Name:</label>
                                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                                    </div>
                                    <div class="form-group">
                                        <label for="txtAsset"><i class="fas fa-dollar-sign"></i> External Transfer Assets No:</label>
                                        <asp:TextBox ID="txtAsset" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                                    </div>
                                    <div class="form-group">
                                        <label class="font-weight-bold"><i class="fas fa-box"></i> Return Status:</label>
                                        <div class="d-flex align-items-center">
                                            <asp:RadioButton ID="noReturn" runat="server" ClientIDMode="Static" GroupName="returnStatus" Value="No Return" CssClass="mr-2" Enabled="false" />
                                            <label class="form-check-label" for="noReturn">No return to Company</label>
                                        </div>
                                        <div class="d-flex align-items-center mt-2">
                                            <asp:RadioButton ID="rbReturnWithDate" runat="server" ClientIDMode="Static" GroupName="returnStatus" Value="Return With Date" CssClass="mr-2" Enabled="false" />
                                            <label class="form-check-label" for="rbReturnWithDate">Return date to Company</label>
                                            <input type="date" id="returnDate" runat="server" ClientIDMode="Static" name="returnDate" class="form-control ml-2 w-auto" disabled="disabled" />
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12 col-md-6">
                                    <div class="form-group">
                                        <label for="txtTimeout"><i class="fas fa-clock"></i> Departure Time:</label>
                                        <asp:TextBox ID="txtTimeout" runat="server" CssClass="form-control" TextMode="Time" ReadOnly="true"></asp:TextBox>
                                    </div>
                                    <div class="form-group">
                                        <label for="ddlCompany"><i class="fas fa-building"></i> To Company:</label>
                                        <asp:DropDownList ID="ddlCompany" runat="server" CssClass="form-control" Enabled="false">
                                            <asp:ListItem Text="NETL" Value="NETL"></asp:ListItem>
                                            <asp:ListItem Text="NETR" Value="NETR"></asp:ListItem>
                                            <asp:ListItem Text="NPTA" Value="NPTA"></asp:ListItem>
                                            <asp:ListItem Text="NPTR" Value="NPTR"></asp:ListItem>
                                            <asp:ListItem Text="NCOT" Value="NCOT"></asp:ListItem>
                                            <asp:ListItem Text="NDCT" Value="NDCT"></asp:ListItem>
                                            <asp:ListItem Text="NDCC" Value="NDCC"></asp:ListItem>
                                            <asp:ListItem Text="Other" Value="Others"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div class="form-group">
                                        <label for="txtAddress"><i class="fas fa-home"></i> Supplier Address:</label>
                                        <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Items List Card (Collapsible) -->
                <div class="card">
                    <div class="card-header" id="headingItems">
                        <h5 class="mb-0">
                            <button class="btn btn-link text-white" type="button" data-toggle="collapse" data-target="#collapseItems" aria-expanded="true" aria-controls="collapseItems">
                                <i class="fas fa-box-open"></i> Items List
                            </button>
                        </h5>
                    </div>
                    <div id="collapseItems" class="collapse show" aria-labelledby="headingItems">
                        <div class="card-body">
                            <div class="table-responsive">
                                <asp:GridView ID="GridView1" runat="server" CssClass="table table-striped table-bordered text-center" AutoGenerateColumns="False" EmptyDataText="⚠️ No items found." OnRowDataBound="GridView1_RowDataBound">
                                    <HeaderStyle CssClass="bg-dark text-white" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="No." ItemStyle-CssClass="text-center">
                                            <ItemTemplate>
                                                <asp:Label ID="lblRowNumber" runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                         <asp:BoundField DataField="Invoice no." HeaderText="Invoice no." ItemStyle-CssClass="text-left" />
                                          <asp:BoundField DataField="Description" HeaderText="Description" ItemStyle-CssClass="text-left" />                                     
                                        <asp:BoundField DataField="Quantity" HeaderText="Quantity" ItemStyle-CssClass="text-center item-quantity" />
                                        <asp:BoundField DataField="Purpose" HeaderText="Purpose" ItemStyle-CssClass="text-left" />
                                        <asp:TemplateField HeaderText="View Image">
                                            <ItemTemplate>
                                                <a href="javascript:void(0);" onclick='<%# "showImage(\"" + Eval("image_url") + "\")" %>' aria-label="View item image">
                                                    <i class="fas fa-eye" style="font-size:20px; color:#007bff;"></i>
                                                </a>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                            <div class="text-right mt-3">
                                <h6><strong>Total Quantity: <span id="totalQuantity">0</span></strong></h6>
                            </div>
                        </div>
                    </div>
                </div>

                <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

                <!-- Approval Section Card -->
                <div class="card">
                    <div class="card-header text-center"><i class="fas fa-check"></i> Approval Section</div>
                    <div class="card-body">
                       
                       <div class="form-group mt-4 pb-3" style="margin-bottom: 1.5rem;">

    <!-- Centered Approve Button with Margin Top -->
    <div class="text-center mt-3">
        <asp:Button ID="btnApprove" runat="server" 
            Text="Approve" 
            CssClass="btn btn-success btn-custom" 
            Visible="false" 
            OnClick="btnApprove_Click" 
            data-toggle="tooltip" 
            title="Approve this document (Creator only)" 
            aria-label="Approve document" />
    </div>
</div>
                        <div class="form-group text-center mt-3">
                            <h5><strong>Approval Count: </strong><asp:Label ID="lblApprovalCount" runat="server" CssClass="text-primary font-weight-bold"></asp:Label>/2</h5>
                            <div class="progress">
    <div id="progressBar" runat="server" class="progress-bar bg-success" role="progressbar" 
         aria-valuenow="<%# lblApprovalCount.Text %>" 
         aria-valuemin="0" 
         aria-valuemax="2"></div>
</div>
                        </div>
                    </div>
                </div>

                <!-- Approval List Card (Collapsible) -->
                <div class="card">
                    <div class="card-header" id="headingApprovalList">
                        <h5 class="mb-0">
                            <button class="btn btn-link text-white" type="button" data-toggle="collapse" data-target="#collapseApprovalList" aria-expanded="true" aria-controls="collapseApprovalList">
                                <i class="fas fa-list"></i> Approval List
                            </button>
                        </h5>
                    </div>
                    <div id="collapseApprovalList" class="collapse show" aria-labelledby="headingApprovalList">
                        <div class="card-body">
                            <div class="table-responsive">
                                <asp:GridView ID="gvApprovalList" runat="server" CssClass="table table-striped table-bordered text-center" AutoGenerateColumns="False" EmptyDataText="⚠️ No approvals yet.">
                                    <HeaderStyle CssClass="bg-dark text-white" />
                                    <Columns>
                                        <asp:BoundField DataField="Approver" HeaderText="Approver" ItemStyle-CssClass="text-left" />
                                               <asp:BoundField DataField="Approver_department" HeaderText="Approver Department" ItemStyle-CssClass="text-center" />
                                        <asp:BoundField DataField="ApprovedAt" HeaderText="Approved At" ItemStyle-CssClass="text-center" DataFormatString="{0:MM/dd/yyyy HH:mm}" />
                                   
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Navigation and Export -->
                <div id="excludePrint" class="text-center mt-4">
                    <asp:HyperLink ID="lnkBackToDocuments" runat="server" CssClass="btn btn-secondary btn-back" title="Go back to the Documents page">
                        <span aria-hidden="true">⬅</span> <span>Back to Documents</span>
                    </asp:HyperLink>
                    <div class="text-right mt-3">
                        <button type="button" class="btn btn-danger btn-custom" onclick="exportToPDF()" aria-label="Export document to PDF">
                            <i class="fas fa-file-pdf"></i> Export to PDF
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script>
        $(document).ready(function () {
            calculateTotalQuantity();
            $('[data-toggle="tooltip"]').tooltip();
            $('button').on('click', function () {
                if ($(this).hasClass('btn-custom')) {
                    $(this).html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Loading...').prop('disabled', true);
                }
            });
        });

        function calculateTotalQuantity() {
            let total = 0;
            $(".item-quantity").each(function () {
                let quantity = parseInt($(this).text().trim()) || 0;
                total += quantity;
            });
            $("#totalQuantity").text(total);
        }

        function exportToPDF() {
            let { jsPDF } = window.jspdf;
            let doc = new jsPDF({
                orientation: 'portrait',
                unit: 'mm',
                format: 'a4'
            });
            let printableArea = document.querySelector('.container');
            document.getElementById("excludePrint").style.display = "none";
            html2canvas(printableArea, { scale: 2 }).then(canvas => {
                let imgData = canvas.toDataURL("image/png");
                let imgWidth = 190;
                let imgHeight = (canvas.height * imgWidth) / canvas.width;
                doc.addImage(imgData, "PNG", 10, 10, imgWidth, imgHeight);
                doc.save("DocumentDetails.pdf");
                document.getElementById("excludePrint").style.display = "block";
            });
        }

        function showImage(url) {
            if (url && url.trim() !== "") {
                Swal.fire({
                    title: 'Image Preview',
                    imageUrl: url,
                    imageAlt: 'Full Size Image',
                    showCloseButton: true,
                    confirmButtonText: 'Close',
                    footer: '<a href="' + url + '" download>Download Image</a>'
                });
            } else {
                Swal.fire({
                    title: 'No Image Available',
                    text: 'There is no image for this item.',
                    icon: 'info',
                    confirmButtonText: 'OK'
                });
            }
        }

        function showInlineFeedback(button, message) {
            $(button).after('<span class="text-success ml-2 fade-out">' + message + '</span>');
            setTimeout(() => $('.fade-out').addClass('remove').remove(), 3000);
        }
    </script>
</body>
</html>