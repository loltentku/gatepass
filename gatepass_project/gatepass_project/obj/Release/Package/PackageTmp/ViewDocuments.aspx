<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewDocuments.aspx.cs" Inherits="gatepass_project.ViewDocuments" MaintainScrollPositionOnPostBack="true" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>View Documents</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
     <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <style>
        /* Apply black border to container and tables */
        .border-dark {
            border: 2px solid black !important; /* Strong black border */
            border-radius: 8px;
        }

        /* Align text in GridView */
        .table th, .table td {
            vertical-align: middle;
        }

        /* Center align header text */
        h2 {
            font-weight: bold;
        }

        /* Improve spacing for search bar */
        .search-bar {
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Back button alignment */
        .back-btn {
            display: flex;
            justify-content: flex-start;
        }

        /* User info container */
        .user-info {
            position: absolute;
            top: 10px;
            right: 20px;
            font-size: 18px;
            font-weight: bold;
            background-color: gray; /* Dark background for contrast */
            color: white;
            padding: 8px 15px;
            border-radius: 5px;
        }

        /* Ensure the container doesn't overlap with other elements */
        .container-fluid {
            position: relative; /* Make the container a positioning context */
            padding-top: 70px; /* Add padding to prevent overlap */
            width: 100%;
        }
        /* Logout link style */
    .logout-link {
        color: #ff4d4d;
        font-weight: bold;
        margin-left: 10px;
        text-decoration: none;
        cursor: pointer;
    }

    .logout-link:hover {
        text-decoration: underline;
    }
      /* Hide the default radio circle */
  .form-check-input {
      position: absolute;
      opacity: 0;
  }

  /* Style the labels to look like interactive buttons */
  .form-check-label {
      position: relative;
      padding: 10px 20px;
      margin-bottom: 0;
      border: 2px solid #ccc;
      border-radius: 30px;
      transition: all 0.3s ease;
      cursor: pointer;
  }

  /* Change appearance when a radio is checked */
  .form-check-input:checked + .form-check-label {
      background: linear-gradient(45deg, #007bff, #00d4ff);
      border-color: #007bff;
      color: #fff;
  }

  /* Add a subtle hover effect */
  .form-check-label:hover {
      border-color: #007bff;
  }
   .form-check-input {
      position: absolute;
      opacity: 0;
  }

  /* Style the labels to look like interactive buttons */
  .form-check-label {
      position: relative;
      padding: 10px 20px;
      margin-bottom: 0;
      border: 2px solid #ccc;
      border-radius: 30px;
      transition: all 0.3s ease;
      cursor: pointer;
  }

  /* Change appearance when a radio is checked */
  .form-check-input:checked + .form-check-label {
      background: linear-gradient(45deg, #007bff, #00d4ff);
      border-color: #007bff;
      color: #fff;
  }

  /* Add a subtle hover effect */
  .form-check-label:hover {
      border-color: #007bff;
  }
  <style>
    .user-info {
        display: flex;
        align-items: center;
        font-size: 1rem;
        padding: 10px;
        background: #f8f9fa;
        border-radius: 10px;
        box-shadow: 2px 2px 8px rgba(0, 0, 0, 0.1);
        width: fit-content;
    }
    .user-info .badge {
        font-size: 0.9rem;
        border-radius: 20px;
    }
    .user-info a {
        text-decoration: none;
    }
</style>

    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid mt-4 p-4 border border-dark shadow-lg">
            <!-- Username Container -->
            <div class="user-info">
                <asp:Label ID="lblUserName" runat="server" CssClass="font-weight-bold text-white"></asp:Label>
            </div>

            <h2 class="text-center">📜 Document List</h2>

                 <div class="text-center my-4">
                <asp:Button ID="btnCreateForm1" runat="server" 
                    Text="Create Gate pass" 
                    CssClass="btn btn-primary mx-2" 
                    OnClick="btnCreateForm1_Click" />
                <asp:Button ID="btnCreateForm2" runat="server" 
                    Text="Create Gate pass for finished goods" 
                    CssClass="btn btn-success mx-2" 
                    OnClick="btnCreateForm2_Click" />
            </div>

            <!-- Search Bar with Reset Button -->
            <div class="row mb-3 search-bar">
                <div class="col-md-8">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" Placeholder="Enter Document No, Name, or Company..."></asp:TextBox>
                </div>
                <div class="col-md-2">
                    <asp:Button ID="btnSearch" runat="server" Text="🔍 Search" CssClass="btn btn-info w-100" OnClick="btnSearch_Click" />
                </div>
            </div>

            <!-- No Records Label (Hidden by Default) -->
            <asp:Label ID="lblNoRecords" runat="server" CssClass="alert alert-warning text-center w-100" Visible="False">
                ⚠ No document found.
            </asp:Label>
       
<div class="form-group mt-3 text-center">
  <label class="font-weight-bold d-block">Form Type</label>
  <div class="d-flex justify-content-center">
    <div class="form-check mr-3">
      <input type="radio" id="rbAll" runat="server" name="formType" class="form-check-input" value="-1" checked onchange="filterDocuments();" />
      <label class="form-check-label" for="rbAll">All</label>
    </div>
    <div class="form-check mr-3">
      <input type="radio" id="rbForm1" runat="server" name="formType" class="form-check-input" value="1" onchange="filterDocuments();" />
      <label class="form-check-label" for="rbForm1">Gate pass</label>
    </div>
    <div class="form-check">
      <input type="radio" id="rbForm2" runat="server" name="formType" class="form-check-input" value="2" onchange="filterDocuments();" />
      <label class="form-check-label" for="rbForm2">Gate pass for finished goods</label>
    </div>
  </div>
</div>
            <div class="text-center mt-3">
    <p>Scan this QR code to open this page on your phone:</p>
    <div id="qrcode"></div>
</div>


    <!-- Hidden Field to Store Selected Filter -->
    <asp:HiddenField ID="hiddenFormType" runat="server" ClientIDMode="Static" />
</div>


            <asp:ScriptManager runat="server" />
            <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <!-- Document List Table -->
                    <div class="mt-4">
                        <asp:GridView ID="gvDocuments" runat="server" AutoGenerateColumns="False"
                            AllowPaging="True" PageSize="10" AllowSorting="True"
                            OnSorting="gvDocuments_Sorting" OnPageIndexChanging="gvDocuments_PageIndexChanging"
                            CssClass="table table-striped table-bordered border border-dark text-center">
                            
                            <HeaderStyle CssClass="bg-dark text-white" />

                            <Columns>
                                <asp:BoundField DataField="doc_no" HeaderText="📄 Document No" SortExpression="doc_no"/>
                                <asp:BoundField DataField="name" HeaderText="🦱 Requester Name" />
                                <asp:BoundField DataField="factory" HeaderText="🏢 Factory" />
                                <asp:BoundField DataField="date" HeaderText="📅 Date" SortExpression="date" DataFormatString="{0:yyyy-MM-dd}" />
                               <asp:TemplateField HeaderText="⚡ Actions">
                                <ItemTemplate>
                                    <%# ShowViewButton(Eval("doc_no").ToString(), Convert.ToInt32(Eval("formtype"))) %>
                                   <%# ShowEditButton(Eval("doc_no").ToString(), Convert.ToInt32(Eval("formtype"))) %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            </Columns>

                            <PagerStyle CssClass="pagination-ys" />
                        </asp:GridView>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        
    </form>
    <script>

    function logoutUser() {
        Swal.fire({
            title: "Are you sure?",
            text: "You will be logged out!",
            icon: "warning",
            showCancelButton: true,
            confirmButtonColor: "#d33",
            cancelButtonColor: "#3085d6",
            confirmButtonText: "Yes, logout"
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = "Login.aspx"; 
            }
        });
        }
        function filterDocuments() {
            // Change "formTypeGroup" to "formType"
            let selectedFormType = document.querySelector("input[name='formType']:checked").value;
            document.getElementById("hiddenFormType").value = selectedFormType;
            // Reload the page with formType as an integer parameter
            window.location.href = "ViewDocuments.aspx?formType=" + selectedFormType;
        }
        let localIp = "http://192.168.1.159:44352/ViewDocuments.aspx"; // Replace PORT with actual port
        new QRCode(document.getElementById("qrcode"), {
            text: localIp,
            width: 200,
            height: 200
        });
    </script>

</body>
</html>