SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

IF DB_NAME() NOT LIKE 'WebFormsWorkshop[_]%' OR OBJECT_ID('dbo.WorkshopMetadata', 'U') IS NULL
BEGIN
    RAISERROR ('A marked workshop database is required.', 16, 1);
    ROLLBACK TRANSACTION;
    RETURN;
END;
IF NOT EXISTS (SELECT 1 FROM dbo.WorkshopMetadata WITH (UPDLOCK, HOLDLOCK)
               WHERE id = 1 AND marker = N'webform-portal-sample-app/v1')
BEGIN
    RAISERROR ('The workshop database marker does not match.', 16, 1);
    ROLLBACK TRANSACTION;
    RETURN;
END;

IF (SELECT seed_applied FROM dbo.WorkshopMetadata WHERE id = 1) = 0
BEGIN
    IF EXISTS (SELECT 1 FROM dbo.Requests)
    BEGIN
        RAISERROR ('An unseeded database already containing requests will not be overwritten.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    INSERT INTO dbo.Requests (title, applicant, department, kind, details, status, created_at)
    VALUES (N'検証用キーボードの購入', N'架空 太郎', 'engineering', 'equipment', N'動作検証用端末のキーボードが故障したため、交換用を一台購入したいです。', 'pending', '20060612 00:15:00');
    INSERT INTO dbo.Requests (title, applicant, department, kind, details, status, created_at)
    VALUES (N'提案書作成研修への参加', N'見本 花子', 'sales', 'training', N'提案書の構成と説明方法を学ぶ研修に参加し、営業資料の作成に活用したいです。', 'pending', '20060612 01:30:00');
    INSERT INTO dbo.Requests (title, applicant, department, kind, details, status, created_at)
    VALUES (N'月次集計日の在宅勤務', N'例示 次郎', 'corporate', 'remote', N'月次の架空データを集計するため、指定日の一日を在宅勤務として申請します。', 'pending', '20060613 02:00:00');
    INSERT INTO dbo.Requests (title, applicant, department, kind, details, status, created_at)
    VALUES (N'色見本帳の追加購入', N'標本 美咲', 'design', 'equipment', N'印刷物の色を比較するため、制作担当で共用する色見本帳を一冊追加したいです。', 'pending', '20060614 00:00:00');
    INSERT INTO dbo.Requests (title, applicant, department, kind, details, status, created_at)
    VALUES (N'データベース基礎研修', N'架空 健', 'engineering', 'training', N'担当業務で使用するデータベースの基礎知識を確認するため、研修参加を申請します。', 'pending', '20060614 00:00:00');
    INSERT INTO dbo.Requests (title, applicant, department, kind, details, status, created_at)
    VALUES (N'来客説明用の資料台', N'見本 悠', 'sales', 'equipment', N'来客向けの説明資料を置くため、会議室に小型の資料台を一台設置したいです。', 'approved', '20060522 01:00:00');
    INSERT INTO dbo.Requests (title, applicant, department, kind, details, status, created_at)
    VALUES (N'帳票整理日の在宅勤務', N'例示 葵', 'corporate', 'remote', N'研修用の帳票を整理する作業に集中するため、在宅勤務を一日申請します。', 'approved', '20060524 00:45:00');
    INSERT INTO dbo.Requests (title, applicant, department, kind, details, status, created_at)
    VALUES (N'画面設計講座への参加', N'標本 蓮', 'design', 'training', N'入力画面の配置と項目名の付け方を学ぶ講座に参加し、制作時の参考にします。', 'approved', '20060525 02:20:00');
    INSERT INTO dbo.Requests (title, applicant, department, kind, details, status, created_at)
    VALUES (N'端末用メモリーの購入', N'架空 遥', 'engineering', 'equipment', N'検証用端末の作業を安定させるため、互換性を確認したメモリーを購入します。', 'approved', '20060526 03:00:00');
    INSERT INTO dbo.Requests (title, applicant, department, kind, details, status, created_at)
    VALUES (N'大型展示パネルの購入', N'見本 翔', 'sales', 'equipment', N'社内の説明会で使用する展示パネルを購入したいです。寸法と保管場所は検討中です。', 'rejected', '20060529 00:30:00');
    INSERT INTO dbo.Requests (title, applicant, department, kind, details, status, created_at)
    VALUES (N'長期の在宅勤務申請', N'例示 凛', 'corporate', 'remote', N'複数日にわたる在宅勤務を申請します。対象日と引き継ぎ方法はまだ決まっていません。', 'rejected', '20060530 01:15:00');
    INSERT INTO dbo.Requests (title, applicant, department, kind, details, status, created_at)
    VALUES (N'外部講座への追加参加', N'標本 湊', 'design', 'training', N'制作に関する外部講座へ参加したいです。講座内容と参加費の詳細は後日確認します。', 'rejected', '20060531 02:00:00');
    UPDATE dbo.WorkshopMetadata SET seed_applied = 1 WHERE id = 1;
END;
COMMIT TRANSACTION;
