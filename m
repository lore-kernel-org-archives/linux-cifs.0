Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6365ECAAD8
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Sep 2022 13:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiITNVB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Sep 2022 09:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiITNVB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Sep 2022 09:21:01 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E90C3DBE8
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 06:21:00 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id iw17so2393619plb.0
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 06:21:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=OtTNvzDwdt8zM14tNoGDhevPuRdtk44YBNelmuHNpBI=;
        b=1ZS03eSXzjDw0GG3SsP4UMSnlMKjZ0w8rFma74NmSaCT48s5EiHrpblnNkWpb3eDNg
         OJ8/Y1+SU7kPsP9PBfgnnMYtyBvbI1Q8oHooMCMATcofrTnyOzsS4x2KkSwsyvNPizPr
         cpUTriePDfZWBzDa62HvZvqAAGDCnZXyR+5ld2Sty+g70Wh/yzc8hQNWlSmtuIPsYo7p
         2r/YJLtNwDNbVCl/z6r330Q5ZCdvHxNe3sFWu9IRf+f6SgIFn7/UNUkNg4Co+hvm3wAj
         ow58H+Oy0PDsd16BDikXXw+6V/4VZ3/RHQOntxLnwEaURUupzZf4oqN+zPH2QlEhYoq2
         O6XQ==
X-Gm-Message-State: ACrzQf04Tg5frP+EOgOCvyCVpCgKWLO+QfUJppZFQ1oEqR+Wr7xJFM0k
        F5zfKf+TXE5dE06k54iq/aV2YQVaoOI=
X-Google-Smtp-Source: AMsMyM7367ENU1ndc6eyPGliPbY6jgekspR//11nh8FW+mbKUSihr1y7ZnwdcM1LC4n7fUrWdiovYg==
X-Received: by 2002:a17:90a:db04:b0:203:6731:caf8 with SMTP id g4-20020a17090adb0400b002036731caf8mr3988361pjv.190.1663680059504;
        Tue, 20 Sep 2022 06:20:59 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id ix18-20020a170902f81200b001767f6f04efsm1360851plb.242.2022.09.20.06.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 06:20:58 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/3] ksmbd: change security id to the one samba used for posix extension
Date:   Tue, 20 Sep 2022 22:20:43 +0900
Message-Id: <20220920132045.5055-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Samba set SIDOWNER and SIDUNIX_GROUP in create posix context and
set SIDUNIX_USER/GROUP in other sids for posix extension.
This patch change security id to the one samba used.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/oplock.c  | 6 +++---
 fs/ksmbd/smb2pdu.c | 4 ++--
 fs/ksmbd/smb2pdu.h | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index 2e56dac1fa6e..c26f02086783 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1616,7 +1616,7 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp)
 	memset(buf, 0, sizeof(struct create_posix_rsp));
 	buf->ccontext.DataOffset = cpu_to_le16(offsetof
 			(struct create_posix_rsp, nlink));
-	buf->ccontext.DataLength = cpu_to_le32(52);
+	buf->ccontext.DataLength = cpu_to_le32(56);
 	buf->ccontext.NameOffset = cpu_to_le16(offsetof
 			(struct create_posix_rsp, Name));
 	buf->ccontext.NameLength = cpu_to_le16(POSIX_CTXT_DATA_LEN);
@@ -1642,9 +1642,9 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp)
 	buf->reparse_tag = cpu_to_le32(fp->volatile_id);
 	buf->mode = cpu_to_le32(inode->i_mode);
 	id_to_sid(from_kuid_munged(&init_user_ns, vfsuid_into_kuid(vfsuid)),
-		  SIDNFS_USER, (struct smb_sid *)&buf->SidBuffer[0]);
+		  SIDOWNER, (struct smb_sid *)&buf->SidBuffer[0]);
 	id_to_sid(from_kgid_munged(&init_user_ns, vfsgid_into_kgid(vfsgid)),
-		  SIDNFS_GROUP, (struct smb_sid *)&buf->SidBuffer[20]);
+		  SIDUNIX_GROUP, (struct smb_sid *)&buf->SidBuffer[28]);
 }
 
 /*
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index f33a04e9e458..bc6c7ce17ea8 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3573,9 +3573,9 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 		if (d_info->hide_dot_file && d_info->name[0] == '.')
 			posix_info->DosAttributes |= FILE_ATTRIBUTE_HIDDEN_LE;
 		id_to_sid(from_kuid_munged(&init_user_ns, ksmbd_kstat->kstat->uid),
-			  SIDNFS_USER, (struct smb_sid *)&posix_info->SidBuffer[0]);
+			  SIDUNIX_USER, (struct smb_sid *)&posix_info->SidBuffer[0]);
 		id_to_sid(from_kgid_munged(&init_user_ns, ksmbd_kstat->kstat->gid),
-			  SIDNFS_GROUP, (struct smb_sid *)&posix_info->SidBuffer[20]);
+			  SIDUNIX_GROUP, (struct smb_sid *)&posix_info->SidBuffer[16]);
 		memcpy(posix_info->name, conv_name, conv_len);
 		posix_info->name_len = cpu_to_le32(conv_len);
 		posix_info->NextEntryOffset = cpu_to_le32(next_entry_offset);
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index af455278d005..32c525bf790a 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -158,7 +158,7 @@ struct create_posix_rsp {
 	__le32 nlink;
 	__le32 reparse_tag;
 	__le32 mode;
-	u8 SidBuffer[40];
+	u8 SidBuffer[44];
 } __packed;
 
 struct smb2_buffer_desc_v1 {
@@ -439,7 +439,7 @@ struct smb2_posix_info {
 	__le32 HardLinks;
 	__le32 ReparseTag;
 	__le32 Mode;
-	u8 SidBuffer[40];
+	u8 SidBuffer[32];
 	__le32 name_len;
 	u8 name[1];
 	/*
-- 
2.25.1

