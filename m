Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0800C6FA82
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Sep 2022 14:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiIVOec (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Sep 2022 10:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbiIVOeD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Sep 2022 10:34:03 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8F6F6F49
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 07:34:01 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id d64-20020a17090a6f4600b00202ce056566so2540068pjk.4
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 07:34:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=uJJAV8vizUHtC9PWZrZW9lCNEp+Em+LxtnrW/IZYfsE=;
        b=PTQdNfU7cXfkIkALnLqWY2nsMlrLSoLOLdYuP27IZ8h4lacZPervUGlEhlP7QtlD15
         vyMfBFxV7xYQri2UH1uX+zpGnJI2R0F4tvE7p0/XL9p/hyUO5rNR9zRH2dRRrL2sn4LG
         hxK+dcO6AnkiTBjm1ha8h4Lgh8NyijeRriCrvp3bDWSKHoZHUQncM6m8tGdo6+q7P+VR
         jEWm6RG3yaTr8aZH1VZxefk2dqADAz1un3SpTLk53wwDpsZ0qMZ8hxyYVY8474Gq5WyM
         R/chLDvxE38gTpkLwo6Fp3mJo5PEErCJYSeQKf5bbNULMWW07la/Ke9ST6f14annYyod
         jyYw==
X-Gm-Message-State: ACrzQf1YxyJJpiPj0I12foqvZWSj9QMn9WQVrJWP/CdgrUiwfYG/EBXT
        OdOacv6IFkyKhQP1MrP0hfod2OTl8eY=
X-Google-Smtp-Source: AMsMyM7vzr5EX+ze4PsoafX1tSYMIKiepoKM/myP8BlWyo7MqHRLsrePeMUgt9JmEzNajDjeRsqwTg==
X-Received: by 2002:a17:902:f64d:b0:178:a963:d400 with SMTP id m13-20020a170902f64d00b00178a963d400mr3716035plg.6.1663857240917;
        Thu, 22 Sep 2022 07:34:00 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id iw20-20020a170903045400b00177324a7862sm4132808plb.45.2022.09.22.07.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 07:34:00 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 1/3] ksmbd: change security id to the one samba used for posix extension
Date:   Thu, 22 Sep 2022 23:33:36 +0900
Message-Id: <20220922143338.10368-1-linkinjeon@kernel.org>
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
 v2:
   - add the comments for Datalenth and SidBuffer.

 fs/ksmbd/oplock.c  | 17 ++++++++++++++---
 fs/ksmbd/smb2pdu.c |  9 +++++++--
 fs/ksmbd/smb2pdu.h |  6 ++++--
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index 2e56dac1fa6e..7c890daec2ba 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1616,7 +1616,11 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp)
 	memset(buf, 0, sizeof(struct create_posix_rsp));
 	buf->ccontext.DataOffset = cpu_to_le16(offsetof
 			(struct create_posix_rsp, nlink));
-	buf->ccontext.DataLength = cpu_to_le32(52);
+	/*
+	 * DataLength = nlink(4) + reparse_tag(4) + mode(4) +
+	 * domain sid(28) + unix group sid(16).
+	 */
+	buf->ccontext.DataLength = cpu_to_le32(56);
 	buf->ccontext.NameOffset = cpu_to_le16(offsetof
 			(struct create_posix_rsp, Name));
 	buf->ccontext.NameLength = cpu_to_le16(POSIX_CTXT_DATA_LEN);
@@ -1641,10 +1645,17 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp)
 	buf->nlink = cpu_to_le32(inode->i_nlink);
 	buf->reparse_tag = cpu_to_le32(fp->volatile_id);
 	buf->mode = cpu_to_le32(inode->i_mode);
+	/*
+	 * SidBuffer(44) contain two sids(Domain sid(28), UNIX group sid(16)).
+	 * Domain sid(28) = revision(1) + num_subauth(1) + authority(6) +
+	 *		    sub_auth(4 * 4(num_subauth)) + RID(4).
+	 * UNIX group id(16) = revision(1) + num_subauth(1) + authority(6) +
+	 *		       sub_auth(4 * 1(num_subauth)) + RID(4).
+	 */
 	id_to_sid(from_kuid_munged(&init_user_ns, vfsuid_into_kuid(vfsuid)),
-		  SIDNFS_USER, (struct smb_sid *)&buf->SidBuffer[0]);
+		  SIDOWNER, (struct smb_sid *)&buf->SidBuffer[0]);
 	id_to_sid(from_kgid_munged(&init_user_ns, vfsgid_into_kgid(vfsgid)),
-		  SIDNFS_GROUP, (struct smb_sid *)&buf->SidBuffer[20]);
+		  SIDUNIX_GROUP, (struct smb_sid *)&buf->SidBuffer[28]);
 }
 
 /*
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index f33a04e9e458..bb19c9d1de78 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3572,10 +3572,15 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 				FILE_ATTRIBUTE_DIRECTORY_LE : FILE_ATTRIBUTE_ARCHIVE_LE;
 		if (d_info->hide_dot_file && d_info->name[0] == '.')
 			posix_info->DosAttributes |= FILE_ATTRIBUTE_HIDDEN_LE;
+		/*
+		 * SidBuffer(32) contain two sids(Domain sid(16), UNIX group sid(16)).
+		 * UNIX sid(16) = revision(1) + num_subauth(1) + authority(6) +
+		 *		  sub_auth(4 * 1(num_subauth)) + RID(4).
+		 */
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
index af455278d005..2eb6b819c89d 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -158,7 +158,8 @@ struct create_posix_rsp {
 	__le32 nlink;
 	__le32 reparse_tag;
 	__le32 mode;
-	u8 SidBuffer[40];
+	/* SidBuffer contain two sids(Domain sid(28), UNIX group sid(16)) */
+	u8 SidBuffer[44];
 } __packed;
 
 struct smb2_buffer_desc_v1 {
@@ -439,7 +440,8 @@ struct smb2_posix_info {
 	__le32 HardLinks;
 	__le32 ReparseTag;
 	__le32 Mode;
-	u8 SidBuffer[40];
+	/* SidBuffer contain two sids (UNIX user sid(16), UNIX group sid(16)) */
+	u8 SidBuffer[32];
 	__le32 name_len;
 	u8 name[1];
 	/*
-- 
2.25.1

