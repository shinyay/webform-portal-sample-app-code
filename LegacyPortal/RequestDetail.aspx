<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeBehind="RequestDetail.aspx.cs" Inherits="LegacyPortal.RequestDetail" Title="申請詳細" %>
<asp:Content ID="DetailContent" ContentPlaceHolderID="MainContent" runat="server">
    <h1>申請詳細 <span class="muted">#<asp:Literal ID="RequestId" runat="server" Mode="Encode" /></span></h1>
    <dl class="detail">
        <dt>件名</dt><dd id="request-title"><asp:Literal ID="RequestTitle" runat="server" Mode="Encode" /></dd>
        <dt>申請者</dt><dd id="request-applicant"><asp:Literal ID="Applicant" runat="server" Mode="Encode" /></dd>
        <dt>部署</dt><dd><asp:Literal ID="Department" runat="server" Mode="Encode" /></dd>
        <dt>種別</dt><dd><asp:Literal ID="Kind" runat="server" Mode="Encode" /></dd>
        <dt>状態</dt><dd id="request-status"><asp:Literal ID="Status" runat="server" Mode="Encode" /></dd>
        <dt>作成日時（JST）</dt><dd><asp:Literal ID="CreatedAt" runat="server" Mode="Encode" /></dd>
        <dt>内容</dt><dd><pre id="request-details"><asp:Literal ID="Details" runat="server" Mode="Encode" /></pre></dd>
    </dl>
    <asp:Panel ID="DecisionPanel" runat="server" CssClass="actions">
        <p>判断は一度だけ行えます。処理後の編集・再申請はありません。</p>
        <asp:Button ID="ApproveButton" runat="server" Text="承認する" OnClick="ApproveButton_Click" CssClass="button" />
        <asp:Button ID="RejectButton" runat="server" Text="差し戻す" OnClick="RejectButton_Click" CssClass="secondary" />
    </asp:Panel>
    <asp:Label ID="ProcessedMessage" runat="server" Text="処理済みのため、これ以上状態を変更できません。" Visible="false" />
    <p><a href="Default.aspx">申請一覧へ</a></p>
</asp:Content>
