<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewDocuments.aspx.cs" Inherits="gatepass_project.ViewDocuments" MaintainScrollPositionOnPostBack="true" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>View Documents | Gate Pass System</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet" />
    <style>
        body {
            background: #f0f2f5;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .container-fluid {
            width: 95%;
            max-width: 1600px;
            margin: 0 auto;
            padding: 20px;
        }

        .admin-panel {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.3s ease;
        }

        .admin-panel:hover {
            transform: translateY(-5px);
        }

        .panel-header {
            background: linear-gradient(135deg, #60a5fa, #93c5fd);
            color: #1e3a8a;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .panel-header h2 {
            font-size: 1.75rem;
            font-weight: 700;
            margin: 0;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
        }

        .user-info {
            background: rgba(255, 255, 255, 0.5);
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 1rem;
            font-weight: 500;
            color: #1e3a8a;
        }

        .logout-link {
            color: #ef4444;
            font-weight: 600;
            text-decoration: none;
            margin-left: 15px;
        }

        .logout-link:hover {
            text-decoration: underline;
            color: #ff8787;
        }

        .panel-content {
            padding: 30px;
            background: #fafafa;
        }

        h2.document-title {
            font-size: 2rem;
            color: #1e3a8a;
            text-align: center;
            margin-bottom: 30px;
            font-weight: 600;
        }

        .btn-create {
            border-radius: 0px !important;
            padding: 10px 20px;
            font-size: 16px;
        }

        .btn-create:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .search-bar {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
        }

        .search-bar .form-control {
            border-radius: 25px;
            padding: 20px 20px;
            border: 2px solid #d1d5db;
            box-shadow: none;
            transition: border-color 0.3s ease;
        }

        .search-bar .form-control:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
        }

        .search-bar .btn-info {
            border-radius: 25px;
            padding: 12px 20px;
            font-weight: 600;
        }

        .search-bar .btn-secondary {
            border-radius: 25px;
            padding: 12px 20px;
            font-weight: 600;
            background-color: #6b7280;
            border-color: #6b7280;
        }

        .search-bar .btn-secondary:hover {
            background-color: #4b5563;
            border-color: #4b5563;
        }

        .form-type-filter {
            padding: 20px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            margin: 20px auto;
            max-width: 800px;
        }

        .filter-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #1e3a8a;
            margin-bottom: 20px !important;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .radio-container {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 15px;
            transition: all 0.3s ease;
            margin-bottom: 10px;
        }

        .radio-container:hover {
            background: #eef2ff;
            border-color: #60a5fa;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .custom-control-input:checked ~ .custom-control-label {
            color: #1e3a8a;
            font-weight: 600;
        }

        .custom-control-label {
            font-size: 1.1rem;
            color: #4b5563;
            cursor: pointer;
            display: flex;
            align-items: center;
            padding-left: 10px;
        }

        .custom-control-label i {
            font-size: 1.2rem;
            color: #60a5fa;
            transition: color 0.3s ease;
        }

        .custom-control-input:checked ~ .custom-control-label i {
            color: #1e3a8a;
        }

        .custom-control-input {
            cursor: pointer;
        }

        .table {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }

        .table thead {
            background: #1e3a8a;
            color: white;
        }

        .table th, .table td {
            padding: 15px;
            vertical-align: middle;
            border: none;
        }

        .table tbody tr {
            transition: background 0.2s ease;
        }

        .table tbody tr:hover {
            background: #f1f5f9;
        }

        .pagination-ys {
            justify-content: center;
            margin-top: 20px;
        }

        .alert-warning {
            border-radius: 10px;
            padding: 15px;
            font-weight: 500;
        }

        .actions-container {
            display: flex;
            gap: 5px;
            justify-content: center;
            align-items: center;
            flex-wrap: nowrap;
        }

        .actions-container .btn {
            padding: 6px 12px;
            font-size: 14px;
        }

        .alert-info {
            background-color: #e3f2fd;
            border-color: #b3d7ff;
            color: #004085;
            font-size: 1rem;
            font-weight: 500;
        }

        .status-approved {
            color: #28a745;
            font-weight: 600;
        }

        .status-pending {
            color: #f39c12;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid">
            <div class="admin-panel mt-4">
                <div class="panel-header">
                    <h2>Gate Pass System</h2>
                    <div class="user-info">
                        <asp:Label ID="lblUserName" runat="server" CssClass="font-weight-bold"></asp:Label>
                    </div>
                </div>
                <div class="panel-content">
                    <h2 class="document-title"><i class="fas fa-folder-open mr-2"></i> Document List</h2>

                    <div class="text-center mb-4">
                        <asp:Button ID="btnCreateForm1" runat="server" Text="Create Gate Pass" CssClass="btn btn-primary btn-create" OnClick="btnCreateForm1_Click" />
                        <asp:Button ID="btnCreateForm2" runat="server" Text="Create Gate Pass for Finished Goods" CssClass="btn btn-success btn-create ml-3" OnClick="btnCreateForm2_Click" />
                        <asp:Button ID="btnManageUsers" runat="server" Text="Manage Users" CssClass="btn btn-warning btn-create ml-3" OnClick="btnManageUsers_Click" Visible="False" />
                        <asp:Button ID="btnDashboard" runat="server" Text="Dashboard" CssClass="btn btn-primary btn-create ml-3" PostBackUrl="Dashboard.aspx" />
                    </div>

                    <div class="search-bar">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" Placeholder="Search by Document No, Name, or Company..." />
                        <asp:Button ID="btnSearch" runat="server" Text="🔍 Search" CssClass="btn btn-info" OnClick="btnSearch_Click" />
                        <asp:Button ID="btnRefresh" runat="server" Text="🔄 Refresh" CssClass="btn btn-secondary" OnClick="btnRefresh_Click" />
                    </div>

                    <asp:Label ID="lblNoRecords" runat="server" CssClass="alert alert-warning text-center w-100" Visible="False">
                        ⚠ No documents found.
                    </asp:Label>

                    <div class="form-type-filter text-center">
                        <label class="d-block mb-3 filter-title">Form Type:</label>
                        <asp:DropDownList ID="ddlFormType" runat="server" CssClass="form-control w-50 mx-auto" onchange="filterDocuments(this.value);">
                            <asp:ListItem Text="All" Value="-1" Selected="True" />
                            <asp:ListItem Text="Gate Pass" Value="1" />
                            <asp:ListItem Text="Gate Pass for Finished Goods" Value="2" />
                        </asp:DropDownList>
                    </div>

                    <asp:HiddenField ID="hiddenFormType" runat="server" ClientIDMode="Static" />
                    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />

                    <asp:UpdatePanel runat="server">
                        <ContentTemplate>
                            <div class="mt-4">
                                <asp:GridView ID="gvDocuments" runat="server" AutoGenerateColumns="False"
    AllowPaging="True" PageSize="10" AllowSorting="True"
    OnSorting="gvDocuments_Sorting" OnPageIndexChanging="gvDocuments_PageIndexChanging"
    CssClass="table table-striped table-hover">
    <HeaderStyle CssClass="bg-dark text-white" />
    <Columns>
        <asp:BoundField DataField="doc_no" HeaderText="📄 Document No" SortExpression="doc_no" />
        <asp:BoundField DataField="type" HeaderText="🛠️ Type" />
        <asp:BoundField DataField="name" HeaderText="🦱 Creator Name" />
        <asp:BoundField DataField="factory" HeaderText="🏢 Factory" />
        <asp:BoundField DataField="company" HeaderText="🏢 To Company" />
        <asp:BoundField DataField="date" HeaderText="📅 Date" SortExpression="date" DataFormatString="{0:yyyy-MM-dd}" />
        <asp:TemplateField HeaderText="📊 Approval Status" SortExpression="status">
            <ItemTemplate>
                <span class='<%# Eval("ApprovalStatus").ToString() == "Approved" ? "status-approved" : "status-pending" %>'>
                    <%# Eval("ApprovalStatus") %>
                </span>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="⚡ Actions">
            <ItemTemplate>
                <div class="actions-container">
                    <%# ShowViewButton(Eval("doc_no").ToString(), Convert.ToInt32(Eval("formtype"))) %>
                    <%# ShowEditButton(Eval("doc_no").ToString(), Convert.ToInt32(Eval("formtype"))) %>
                    <%# ShowDeleteButton(Eval("doc_no").ToString()) %>
                </div>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    <PagerStyle CssClass="pagination-ys" />
</asp:GridView>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
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

        function filterDocuments(selectedFormType) {
            window.location.href = "ViewDocuments.aspx?formType=" + selectedFormType;
        }

        function updateWarehouseCheck(docNo, element) {
            Swal.fire({
                title: "Confirm Warehouse Check",
                text: "Are you sure you want to mark this document as checked?",
                icon: "question",
                showCancelButton: true,
                confirmButtonText: "Yes, Confirm",
                cancelButtonText: "Cancel"
            }).then((result) => {
                if (result.isConfirmed) {
                    PageMethods.MarkWarehouseCheck(docNo, function (response) {
                        if (response.trim() === "✅") {
                            element.innerHTML = "✅";
                            element.style.pointerEvents = "none";
                        } else {
                            Swal.fire("Error", "Failed to update warehouse check.", "error");
                        }
                    }, function (error) {
                        Swal.fire("Error", "An error occurred while updating.", "error");
                    });
                }
            });
        }

        function deleteDocument(docNo) {
            Swal.fire({
                title: 'Are you sure to delete?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, delete it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    PageMethods.DeleteDocument(docNo, function (response) {
                        if (response === "success") {
                            Swal.fire(
                                'Deleted!',
                                'The document has been deleted.',
                                'success'
                            ).then(() => {
                                location.reload();
                            });
                        } else {
                            Swal.fire('Error', 'Failed to delete the document.', 'error');
                        }
                    }, function (error) {
                        Swal.fire('Error', 'An error occurred while deleting.', 'error');
                    });
                }
            });
        }
    </script>
</body>
</html>