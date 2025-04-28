<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="gatepass_project.Dashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>Dashboard | Gate Pass System</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/css/bootstrap-datepicker.min.css" rel="stylesheet" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>
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

        h2.dashboard-title {
            font-size: 2rem;
            color: #1e3a8a;
            text-align: center;
            margin-bottom: 30px;
            font-weight: 600;
        }

        .summary-cards {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }

        .doc-type-cards {
            display: flex;
            gap: 20px;
            flex-wrap: nowrap;
            margin-bottom: 30px;
        }

        .card {
            flex: 1;
            min-width: 200px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            padding: 20px;
            text-align: center;
            transition: transform 0.3s ease;
        }

        .doc-type-cards .card {
            min-width: 150px;
            flex: 1;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card h3 {
            font-size: 1.2rem;
            color: #1e3a8a;
            margin-bottom: 10px;
        }

        .card .count {
            font-size: 2rem;
            font-weight: 700;
        }

        .card.total { border-left: 5px solid #3b82f6; }
        .card.approved { border-left: 5px solid #28a745; }
        .card.pending { border-left: 5px solid #f39c12; }
        .card.finished-goods { border-left: 5px solid #17a2b8; }
        .card.scrap { border-left: 5px solid #dc3545; }
        .card.assets { border-left: 5px solid #6f42c1; }
        .card.accessories { border-left: 5px solid #fd7e14; }
        .card.waste { border-left: 5px solid #343a40; }
        .card.others { border-left: 5px solid #20c997; }

        .chart-container {
            max-width: 600px;
            margin: 0 auto 30px;
        }

      .filter-bar select.form-control {
    border-radius: 9999px; /* Fully rounded */
    padding: 8px 30px 8px 12px; 
    height: auto; 
    font-size: 17px;
    color: #333;
    box-shadow: none;
}

.filter-bar {
    display: flex;
    gap: 10px; /* space between items */
    align-items: center;
    flex-wrap: wrap; /* mobile responsive */
}


        .filter-bar .form-control:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
        }

        .filter-bar .btn {
            border-radius: 25px;
            padding: 10px 20px;
            font-weight: 600;
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

        .status-approved {
            color: #28a745;
            font-weight: 600;
        }

        .status-pending {
            color: #f39c12;
            font-weight: 600;
        }

        .btn-back {
            background-color: #20c997;
            border-color: #6b7280;
        }

        .btn-back:hover {
            background-color: #4b5563;
            border-color: #4b5563;
        }

        .datepicker {
            z-index: 1050 !important; /* Ensure datepicker is above other elements */
        }

        @media (max-width: 768px) {
            .summary-cards {
                flex-direction: column;
            }

            .doc-type-cards {
                flex-direction: column;
                gap: 10px;
            }

            .chart-container {
                max-width: 100%;
            }

            .filter-bar {
                flex-direction: column;
                align-items: stretch;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />
        <div class="container-fluid">
            <div class="admin-panel mt-4">
                <div class="panel-header">
                    <h2>Gate Pass System</h2>
                    <div class="user-info">
                        <asp:Label ID="lblUserName" runat="server" CssClass="font-weight-bold"></asp:Label>
                    </div>
                </div>
                <div class="panel-content">
                    <h2 class="dashboard-title">Dashboard</h2>
                    <div class="text-center mb-4">
        <asp:Button ID="btnBackToDocuments" runat="server" Text="Back to Documents" CssClass="btn btn-back" PostBackUrl="ViewDocuments.aspx" />
    </div>
                    <!-- Summary Cards (Total, Approved, Pending) -->
                    <div class="summary-cards">
                        <div class="card total">
                            <h3>Total Documents</h3>
                            <div class="count"><asp:Label ID="lblTotalDocs" runat="server" Text="0"></asp:Label></div>
                        </div>
                        <div class="card approved">
                            <h3>Approved Documents</h3>
                            <div class="count"><asp:Label ID="lblApprovedDocs" runat="server" Text="0"></asp:Label></div>
                        </div>
                        <div class="card pending">
                            <h3>Pending Documents</h3>
                            <div class="count"><asp:Label ID="lblPendingDocs" runat="server" Text="0"></asp:Label></div>
                        </div>
                    </div>

                    <!-- Document Type Cards (All in one row) -->
                    <div class="doc-type-cards">
                        <div class="card finished-goods">
                            <h3>Finished Goods</h3>
                            <div class="count"><asp:Label ID="lblFinishedGoods" runat="server" Text="0"></asp:Label></div>
                        </div>
                        <div class="card scrap">
                            <h3>Scrap</h3>
                            <div class="count"><asp:Label ID="lblScrap" runat="server" Text="0"></asp:Label></div>
                        </div>
                        <div class="card assets">
                            <h3>Assets</h3>
                            <div class="count"><asp:Label ID="lblAssets" runat="server" Text="0"></asp:Label></div>
                        </div>
                        <div class="card accessories">
                            <h3>Accessories</h3>
                            <div class="count"><asp:Label ID="lblAccessories" runat="server" Text="0"></asp:Label></div>
                        </div>
                        <div class="card waste">
                            <h3>Waste</h3>
                            <div class="count"><asp:Label ID="lblWaste" runat="server" Text="0"></asp:Label></div>
                        </div>
                        <div class="card others">
                            <h3>Others</h3>
                            <div class="count"><asp:Label ID="lblOthers" runat="server" Text="0"></asp:Label></div>
                        </div>
                    </div>

                    <!-- Charts -->
                    <div class="row">
                        <div class="col-md-6">
                            <div class="chart-container">
                                <canvas id="statusChart"></canvas>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="chart-container">
                                <canvas id="factoryChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- Filter Bar -->
                   <div class="filter-bar">
 <asp:DropDownList ID="ddlFormType" runat="server" CssClass="form-control" ClientIDMode="Static" 
    onchange="updateDashboard(this.value, $('#ddlFactory').val(), $('#txtStartDate').val(), $('#txtEndDate').val());">
    <asp:ListItem Text="All Forms" Value="-1" Selected="True" />
    <asp:ListItem Text="Gate Pass" Value="1" />
    <asp:ListItem Text="Gate Pass for Finished Goods" Value="2" />
</asp:DropDownList>

<asp:DropDownList ID="ddlFactory" runat="server" CssClass="form-control" ClientIDMode="Static" 
    onchange="updateDashboard($('#ddlFormType').val(), this.value, $('#txtStartDate').val(), $('#txtEndDate').val());">
    <asp:ListItem Text="All Factories" Value="" Selected="True" />
</asp:DropDownList>

    <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control datepicker" Placeholder="Start Date" ClientIDMode="Static" />
    <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control datepicker" Placeholder="End Date" ClientIDMode="Static" />

    <asp:Button ID="btnApplyDateFilter" runat="server" Text="Apply" CssClass="btn btn-primary" OnClientClick="updateDashboard($('#ddlFormType').val(), $('#ddlFactory').val(), $('#txtStartDate').val(), $('#txtEndDate').val()); return false;" />
</div>


                    <!-- Recent Documents Table -->
                    <h3 class="text-center mb-4">Recent Documents</h3>
                    <asp:UpdatePanel runat="server">
                        <ContentTemplate>
                            <asp:GridView ID="gvRecentDocs" runat="server" AutoGenerateColumns="False"
                                CssClass="table table-striped table-hover" AllowSorting="True" OnSorting="gvRecentDocs_Sorting">
                                <HeaderStyle CssClass="bg-dark text-white" />
                                <Columns>
                                    <asp:BoundField DataField="doc_no" HeaderText="📄 Document No" SortExpression="doc_no" />
                                    <asp:BoundField DataField="type" HeaderText="🛠️ Type" />
                                    <asp:BoundField DataField="factory" HeaderText="🏢 Factory" />
                                    <asp:BoundField DataField="date" HeaderText="📅 Date" SortExpression="date" DataFormatString="{0:yyyy-MM-dd}" />
                                    <asp:TemplateField HeaderText="📊 Status" SortExpression="status">
                                        <ItemTemplate>
                                            <span class='<%# Eval("ApprovalStatus").ToString() == "Approved" ? "status-approved" : "status-pending" %>'>
                                                <%# Eval("ApprovalStatus") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="🔍 View">
                                        <ItemTemplate>
                                            <a href='<%# Eval("formtype").ToString() == "1" ? "ViewDetails.aspx" : "ViewDetails2.aspx" %>?doc_no=<%# Eval("doc_no") %>' class="btn btn-info btn-sm">View</a>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </form>

    <script>
        // Initialize Datepickers
        $(document).ready(function () {
            $('#txtStartDate, #txtEndDate').datepicker({
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayHighlight: true
            });
        });

        // Initialize Status Pie Chart
        var statusChart = new Chart(document.getElementById('statusChart'), {
            type: 'pie',
            data: {
                labels: ['Approved', 'Pending'],
                datasets: [{
                    data: [<%= lblApprovedDocs.Text %>, <%= lblPendingDocs.Text %>],
                    backgroundColor: ['#28a745', '#f39c12'],
                    borderColor: ['#fff', '#fff'],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            font: { size: 14 },
                            color: '#1e3a8a'
                        }
                    },
                    title: {
                        display: true,
                        text: 'Document Status Distribution',
                        font: { size: 18, weight: 'bold' },
                        color: '#1e3a8a'
                    }
                }
            }
        });

        // Initialize Factory Bar Chart
        var factoryChart = new Chart(document.getElementById('factoryChart'), {
            type: 'bar',
            data: {
                labels: [<%= FactoryChartLabels %>],
                datasets: [{
                    label: 'Documents by Factory',
                    data: [<%= FactoryChartData %>],
                    backgroundColor: ['#3b82f6', '#17a2b8', '#dc3545', '#6f42c1', '#fd7e14', '#20c997'],
                    borderColor: ['#fff'],
                    borderWidth: 1
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                plugins: {
                    legend: {
                        display: false
                    },
                    title: {
                        display: true,
                        text: 'Documents by Factory',
                        font: { size: 18, weight: 'bold' },
                        color: '#1e3a8a'
                    }
                },
                scales: {
                    x: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1,
                            color: '#1e3a8a'
                        }
                    },
                    y: {
                        ticks: {
                            color: '#1e3a8a'
                        }
                    }
                }
            }
        });

        // Update dashboard on filter change
        function updateDashboard(formType, factory, startDate, endDate) {
            var url = `Dashboard.aspx?formType=${formType}&factory=${encodeURIComponent(factory)}`;
            if (startDate) url += `&startDate=${encodeURIComponent(startDate)}`;
            if (endDate) url += `&endDate=${encodeURIComponent(endDate)}`;
            window.location.href = url;
        }

        // Logout confirmation
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
    </script>
</body>
</html>