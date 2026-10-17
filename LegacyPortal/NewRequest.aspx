<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeBehind="NewRequest.aspx.cs" Inherits="LegacyPortal.NewRequest" Title="新規申請" ValidateRequest="false" %>
<asp:Content ID="NewContent" ContentPlaceHolderID="MainContent" runat="server">
    <h1>新規申請</h1>
    <p>保存した申請は「確認待ち」になります。架空の氏名と内容を入力してください。</p>
    <p class="hint">文字数はUTF-16の単位数です。前後の空白を除き、補助文字は2単位として数えます。</p>
    <asp:ValidationSummary ID="Errors" runat="server" ValidationGroup="request" CssClass="error" HeaderText="入力を確認してください。" />
    <asp:Label ID="InputError" runat="server" CssClass="error" Visible="false" />
    <div class="field">
        <asp:Label runat="server" AssociatedControlID="RequestTitle" Text="件名（1〜80文字）" />
        <asp:TextBox ID="RequestTitle" runat="server" MaxLength="80" />
        <asp:RequiredFieldValidator ID="TitleRequired" runat="server" ControlToValidate="RequestTitle" ValidationGroup="request" ErrorMessage="件名を入力してください。" Display="Dynamic" CssClass="error" />
        <asp:CustomValidator ID="TitleValid" runat="server" ControlToValidate="RequestTitle" ValidationGroup="request" OnServerValidate="Text_ServerValidate" Display="Dynamic" CssClass="error" />
    </div>
    <div class="field">
        <asp:Label runat="server" AssociatedControlID="Applicant" Text="架空の申請者名（1〜40文字）" />
        <asp:TextBox ID="Applicant" runat="server" MaxLength="40" />
        <asp:RequiredFieldValidator ID="ApplicantRequired" runat="server" ControlToValidate="Applicant" ValidationGroup="request" ErrorMessage="申請者名を入力してください。" Display="Dynamic" CssClass="error" />
        <asp:CustomValidator ID="ApplicantValid" runat="server" ControlToValidate="Applicant" ValidationGroup="request" OnServerValidate="Text_ServerValidate" Display="Dynamic" CssClass="error" />
    </div>
    <div class="field">
        <asp:Label runat="server" AssociatedControlID="Department" Text="部署" />
        <asp:DropDownList ID="Department" runat="server">
            <asp:ListItem Value="">選択してください</asp:ListItem>
            <asp:ListItem Value="engineering">開発部</asp:ListItem>
            <asp:ListItem Value="sales">営業部</asp:ListItem>
            <asp:ListItem Value="corporate">管理部</asp:ListItem>
            <asp:ListItem Value="design">デザイン部</asp:ListItem>
        </asp:DropDownList>
        <asp:RequiredFieldValidator ID="DepartmentRequired" runat="server" ControlToValidate="Department" ValidationGroup="request" ErrorMessage="部署を選択してください。" Display="Dynamic" CssClass="error" />
    </div>
    <div class="field">
        <asp:Label runat="server" AssociatedControlID="Kind" Text="種別" />
        <asp:DropDownList ID="Kind" runat="server">
            <asp:ListItem Value="">選択してください</asp:ListItem>
            <asp:ListItem Value="equipment">備品購入</asp:ListItem>
            <asp:ListItem Value="training">研修参加</asp:ListItem>
            <asp:ListItem Value="remote">在宅勤務</asp:ListItem>
        </asp:DropDownList>
        <asp:RequiredFieldValidator ID="KindRequired" runat="server" ControlToValidate="Kind" ValidationGroup="request" ErrorMessage="種別を選択してください。" Display="Dynamic" CssClass="error" />
    </div>
    <div class="field">
        <asp:Label runat="server" AssociatedControlID="Details" Text="内容（10〜1000文字、改行可）" />
        <asp:TextBox ID="Details" runat="server" TextMode="MultiLine" Rows="7" />
        <asp:RequiredFieldValidator ID="DetailsRequired" runat="server" ControlToValidate="Details" ValidationGroup="request" ErrorMessage="内容を入力してください。" Display="Dynamic" CssClass="error" />
        <asp:CustomValidator ID="DetailsValid" runat="server" ControlToValidate="Details" ValidationGroup="request" OnServerValidate="Text_ServerValidate" Display="Dynamic" CssClass="error" />
    </div>
    <div class="actions">
        <asp:Button ID="SaveButton" runat="server" Text="申請を保存" ValidationGroup="request" OnClick="SaveButton_Click" CssClass="button" />
        <a href="Default.aspx">保存せず一覧へ</a>
    </div>
</asp:Content>
