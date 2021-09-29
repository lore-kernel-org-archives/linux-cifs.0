Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105EDC433FE
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 08:45:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F32ED61357
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 08:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244787AbhI2IrE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 04:47:04 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:35798 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244830AbhI2IrA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Sep 2021 04:47:00 -0400
Received: by mail-pg1-f174.google.com with SMTP id e7so1992625pgk.2
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 01:45:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gkdh2Gf/iNgxVnWmNiWvAjcpTYprou6v41r0QCTDdpA=;
        b=YyFvMgMVsDmj4xJuRI/k4zb3O58E+WxR/8nrB/EMAwZjGzBGv+8XcnuNQPfeCfQ8ak
         tJGrDdP2P7ex9AarZZ0qbiGD2+8iDkhO3W9HMgJ9uoMnH13WndmYNAx6YNkKJMb+23gq
         8OAM8+Hy77iGBJQUJ8j5OVVJW9+pa5wS6CdUmbwChD0thzZJq4lab8Okz0sX1wxxo0NA
         HKew4lugHImn++6A4CagYUHKnCduHFSDbA1epfyO8SssFKCoyOb8ATO1vWA/kXrB2fDw
         lYUuanGBfDYLX8hrk3t8fOEC3bSNfyu4E184Fb/qeQYvDarGv+tKbM50UaZOnyHXtP0x
         TIig==
X-Gm-Message-State: AOAM533q6Q51RuVpBH7w0eY3MDYLEhHLieUuRK4K8DqNvJSZy3v91Sps
        FqqROFa08X93A8f73TFjne6cofDB3UuBxg==
X-Google-Smtp-Source: ABdhPJx4MCc+yq+bvRo1Qodz5NFKruF4RX+6fkM+PFsHA5UCR5Tt6hI2jhQetLjvb8ttSqZKxyIa4Q==
X-Received: by 2002:aa7:9614:0:b0:43d:ea99:2a2a with SMTP id q20-20020aa79614000000b0043dea992a2amr9612457pfg.48.1632905119453;
        Wed, 29 Sep 2021 01:45:19 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id q3sm1912344pgf.18.2021.09.29.01.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 01:45:19 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Ralph Boehme <slow@samba.org>
Subject: [PATCH v4 3/9] ksmbd: use correct basic info level in set_file_basic_info()
Date:   Wed, 29 Sep 2021 17:44:55 +0900
Message-Id: <20210929084501.94846-4-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210929084501.94846-1-linkinjeon@kernel.org>
References: <20210929084501.94846-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use correct basic info level in set/get_file_basic_info().

Reviewed-by: Ralph Boehme <slow@samba.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 13 ++++++-------
 fs/ksmbd/smb2pdu.h |  9 +++++++++
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 9c0878862820..d874813aca90 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4161,7 +4161,7 @@ static void get_file_access_info(struct smb2_query_info_rsp *rsp,
 static int get_file_basic_info(struct smb2_query_info_rsp *rsp,
 			       struct ksmbd_file *fp, void *rsp_org)
 {
-	struct smb2_file_all_info *basic_info;
+	struct smb2_file_basic_info *basic_info;
 	struct kstat stat;
 	u64 time;
 
@@ -4171,7 +4171,7 @@ static int get_file_basic_info(struct smb2_query_info_rsp *rsp,
 		return -EACCES;
 	}
 
-	basic_info = (struct smb2_file_all_info *)rsp->Buffer;
+	basic_info = (struct smb2_file_basic_info *)rsp->Buffer;
 	generic_fillattr(file_mnt_user_ns(fp->filp), file_inode(fp->filp),
 			 &stat);
 	basic_info->CreationTime = cpu_to_le64(fp->create_time);
@@ -4184,9 +4184,8 @@ static int get_file_basic_info(struct smb2_query_info_rsp *rsp,
 	basic_info->Attributes = fp->f_ci->m_fattr;
 	basic_info->Pad1 = 0;
 	rsp->OutputBufferLength =
-		cpu_to_le32(offsetof(struct smb2_file_all_info, AllocationSize));
-	inc_rfc1001_len(rsp_org, offsetof(struct smb2_file_all_info,
-					  AllocationSize));
+		cpu_to_le32(sizeof(struct smb2_file_basic_info));
+	inc_rfc1001_len(rsp_org, sizeof(struct smb2_file_basic_info));
 	return 0;
 }
 
@@ -5412,7 +5411,7 @@ static int smb2_create_link(struct ksmbd_work *work,
 static int set_file_basic_info(struct ksmbd_file *fp, char *buf,
 			       struct ksmbd_share_config *share)
 {
-	struct smb2_file_all_info *file_info;
+	struct smb2_file_basic_info *file_info;
 	struct iattr attrs;
 	struct timespec64 ctime;
 	struct file *filp;
@@ -5423,7 +5422,7 @@ static int set_file_basic_info(struct ksmbd_file *fp, char *buf,
 	if (!(fp->daccess & FILE_WRITE_ATTRIBUTES_LE))
 		return -EACCES;
 
-	file_info = (struct smb2_file_all_info *)buf;
+	file_info = (struct smb2_file_basic_info *)buf;
 	attrs.ia_valid = 0;
 	filp = fp->filp;
 	inode = file_inode(filp);
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index bcec845b03f3..261825d06391 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -1464,6 +1464,15 @@ struct smb2_file_all_info { /* data block encoding of response to level 18 */
 	char   FileName[1];
 } __packed; /* level 18 Query */
 
+struct smb2_file_basic_info { /* data block encoding of response to level 18 */
+	__le64 CreationTime;	/* Beginning of FILE_BASIC_INFO equivalent */
+	__le64 LastAccessTime;
+	__le64 LastWriteTime;
+	__le64 ChangeTime;
+	__le32 Attributes;
+	__u32  Pad1;		/* End of FILE_BASIC_INFO_INFO equivalent */
+} __packed;
+
 struct smb2_file_alt_name_info {
 	__le32 FileNameLength;
 	char FileName[0];
-- 
2.25.1

