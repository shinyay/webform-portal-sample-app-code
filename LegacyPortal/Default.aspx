<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeBehind="Default.aspx.cs" Inherits="LegacyPortal.RequestList" Title="申請一覧" %>
<%@ Import Namespace="LegacyPortal.Common" %>
<asp:Content ID="ListContent" ContentPlaceHolderID="MainContent" runat="server">
    <h1>申請一覧</h1>
    <div class="summary" aria-label="申請の件数">
        全件 <strong id="total-count"><asp:Literal ID="TotalCount" runat="server" Mode="Encode" /></strong>
        ／ 確認待ち <strong id="pending-count"><asp:Literal ID="PendingCount" runat="server" Mode="Encode" /></strong>
        ／ 承認済み <strong id="approved-count"><asp:Literal ID="ApprovedCount" runat="server" Mode="Encode" /></strong>
        ／ 差し戻し <strong id="rejected-count"><asp:Literal ID="RejectedCount" runat="server" Mode="Encode" /></strong>
    </div>
    <p class="actions"><a class="button" href="NewRequest.aspx">新規申請を作成</a></p>
    <div class="table-container">
        <table class="request-table">
            <caption>作成日時の新しい順。同日時の場合はIDの大きい順です。</caption>
            <thead><tr><th scope="col">ID</th><th scope="col">件名</th><th scope="col">申請者</th><th scope="col">部署</th><th scope="col">種別</th><th scope="col">状態</th><th scope="col">作成日時（JST）</th></tr></thead>
            <tbody>
                <asp:Repeater ID="Requests" runat="server">
                    <ItemTemplate>
                        <tr>
                            <td><%# PortalValues.Html(DataBinder.Eval(Container.DataItem, "id")) %></td>
                            <td><a href="RequestDetail.aspx?id=<%# PortalValues.Html(DataBinder.Eval(Container.DataItem, "id")) %>"><%# PortalValues.Html(DataBinder.Eval(Container.DataItem, "title")) %></a></td>
                            <td><%# PortalValues.Html(DataBinder.Eval(Container.DataItem, "applicant")) %></td>
                            <td><%# PortalValues.DepartmentText((string)DataBinder.Eval(Container.DataItem, "department")) %></td>
                            <td><%# PortalValues.KindText((string)DataBinder.Eval(Container.DataItem, "kind")) %></td>
                            <td><%# PortalValues.StatusText((string)DataBinder.Eval(Container.DataItem, "status")) %></td>
                            <td class="date"><%# PortalValues.JapanTime(DataBinder.Eval(Container.DataItem, "created_at")) %></td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>
    </div>
    <asp:Label ID="EmptyMessage" runat="server" Text="申請はまだありません。" Visible="false" />
</asp:Content>
