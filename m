Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FBDCC433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Sep 2021 02:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7597861056
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Sep 2021 02:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhISCOx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 18 Sep 2021 22:14:53 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:35335 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhISCOw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 18 Sep 2021 22:14:52 -0400
Received: by mail-pl1-f181.google.com with SMTP id bb10so8777945plb.2
        for <linux-cifs@vger.kernel.org>; Sat, 18 Sep 2021 19:13:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cqvXCZfm3adVvpKDRvLprk1jzSNCqo8c6LALxEqk90o=;
        b=J2njvVNX2c9E7xSAVXj7324gI94Fqc9UMpR/tgclhE8n07/ogJBkzLLdwsI5uI3B82
         qDvRcmO//q1Ov+xA1lKROGqZOxwuH8p4jkYaSysds8nysXlsjoqsQr+0KAWa6dLKgr4z
         Hky4ILyOdH7Iy2W2KJ7KR5PF+VExFtchZdRezM3EcPoYkV9u7V+SXb4jxANroblpXZ3x
         Ogt8cfzElf+sGpngBmpuRAmBgXil9AtFCal/yt2+Vpm/3pxOPaAEkVs7ROqTK2HAdnpx
         6tc9w8iRUuy/QKDqdaEREN5KPqKuHoGb6o4uFyAUEqTAOEHxUEPBXjZudcWd9gSgN91o
         zxdw==
X-Gm-Message-State: AOAM532p4yW8BOOkAZvkTYdHAgGTnwPkSho0sOdijfuMWSVV+k7yq0qx
        fyA5D4uA9Zgovs8dIvSkA1iKOUpi+y8NBw==
X-Google-Smtp-Source: ABdhPJyIoLPyykYy2x1+unl2340I/oL9tOP8z/B39UQZ9lM7KATfos7POf7Cf0sFVr8/Gi9uTF7N0A==
X-Received: by 2002:a17:902:9a04:b0:13a:1ae3:add2 with SMTP id v4-20020a1709029a0400b0013a1ae3add2mr16419371plp.28.1632017607953;
        Sat, 18 Sep 2021 19:13:27 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id m28sm10849537pgl.9.2021.09.18.19.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Sep 2021 19:13:27 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH v2 1/4] ksmbd: add request buffer validation in smb2_set_info
Date:   Sun, 19 Sep 2021 11:13:11 +0900
Message-Id: <20210919021315.642856-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add buffer validation in smb2_set_info.

Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 113 +++++++++++++++++++++++++++++++++++----------
 fs/ksmbd/smb2pdu.h |   9 ++++
 2 files changed, 97 insertions(+), 25 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 46e0275a77a8..7763f69e1ae8 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2107,17 +2107,23 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
  * smb2_set_ea() - handler for setting extended attributes using set
  *		info command
  * @eabuf:	set info command buffer
+ * @buf_len:	set info command buffer length
  * @path:	dentry path for get ea
  *
  * Return:	0 on success, otherwise error
  */
-static int smb2_set_ea(struct smb2_ea_info *eabuf, struct path *path)
+static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
+		       struct path *path)
 {
 	struct user_namespace *user_ns = mnt_user_ns(path->mnt);
 	char *attr_name = NULL, *value;
 	int rc = 0;
 	int next = 0;
 
+	if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength +
+			le16_to_cpu(eabuf->EaValueLength))
+		return -EINVAL;
+
 	attr_name = kmalloc(XATTR_NAME_MAX + 1, GFP_KERNEL);
 	if (!attr_name)
 		return -ENOMEM;
@@ -2181,7 +2187,13 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, struct path *path)
 
 next:
 		next = le32_to_cpu(eabuf->NextEntryOffset);
+		if (next == 0 || buf_len < next)
+			break;
+		buf_len -= next;
 		eabuf = (struct smb2_ea_info *)((char *)eabuf + next);
+		if (next < eabuf->EaNameLength + le16_to_cpu(eabuf->EaValueLength))
+			break;
+
 	} while (next != 0);
 
 	kfree(attr_name);
@@ -2790,7 +2802,9 @@ int smb2_open(struct ksmbd_work *work)
 		created = true;
 		user_ns = mnt_user_ns(path.mnt);
 		if (ea_buf) {
-			rc = smb2_set_ea(&ea_buf->ea, &path);
+			rc = smb2_set_ea(&ea_buf->ea,
+					 le32_to_cpu(ea_buf->ccontext.DataLength),
+					 &path);
 			if (rc == -EOPNOTSUPP)
 				rc = 0;
 			else if (rc)
@@ -5375,7 +5389,7 @@ static int smb2_rename(struct ksmbd_work *work,
 static int smb2_create_link(struct ksmbd_work *work,
 			    struct ksmbd_share_config *share,
 			    struct smb2_file_link_info *file_info,
-			    struct file *filp,
+			    int buf_len, struct file *filp,
 			    struct nls_table *local_nls)
 {
 	char *link_name = NULL, *target_name = NULL, *pathname = NULL;
@@ -5383,6 +5397,10 @@ static int smb2_create_link(struct ksmbd_work *work,
 	bool file_present = true;
 	int rc;
 
+	if (buf_len < sizeof(struct smb2_file_link_info) +
+			le32_to_cpu(file_info->FileNameLength))
+		return -EINVAL;
+
 	ksmbd_debug(SMB, "setting FILE_LINK_INFORMATION\n");
 	pathname = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!pathname)
@@ -5442,7 +5460,7 @@ static int smb2_create_link(struct ksmbd_work *work,
 static int set_file_basic_info(struct ksmbd_file *fp, char *buf,
 			       struct ksmbd_share_config *share)
 {
-	struct smb2_file_all_info *file_info;
+	struct smb2_file_basic_info *file_info;
 	struct iattr attrs;
 	struct timespec64 ctime;
 	struct file *filp;
@@ -5453,7 +5471,7 @@ static int set_file_basic_info(struct ksmbd_file *fp, char *buf,
 	if (!(fp->daccess & FILE_WRITE_ATTRIBUTES_LE))
 		return -EACCES;
 
-	file_info = (struct smb2_file_all_info *)buf;
+	file_info = (struct smb2_file_basic_info *)buf;
 	attrs.ia_valid = 0;
 	filp = fp->filp;
 	inode = file_inode(filp);
@@ -5619,7 +5637,8 @@ static int set_end_of_file_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 }
 
 static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
-			   char *buf)
+			   struct smb2_file_rename_info *rename_info,
+			   int buf_len)
 {
 	struct user_namespace *user_ns;
 	struct ksmbd_file *parent_fp;
@@ -5632,6 +5651,10 @@ static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 		return -EACCES;
 	}
 
+	if (buf_len < sizeof(struct smb2_file_rename_info) +
+			le32_to_cpu(rename_info->FileNameLength))
+		return -EINVAL;
+
 	user_ns = file_mnt_user_ns(fp->filp);
 	if (ksmbd_stream_fd(fp))
 		goto next;
@@ -5654,8 +5677,7 @@ static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 		}
 	}
 next:
-	return smb2_rename(work, fp, user_ns,
-			   (struct smb2_file_rename_info *)buf,
+	return smb2_rename(work, fp, user_ns, rename_info,
 			   work->sess->conn->local_nls);
 }
 
@@ -5741,40 +5763,71 @@ static int set_file_mode_info(struct ksmbd_file *fp, char *buf)
  * TODO: need to implement an error handling for STATUS_INFO_LENGTH_MISMATCH
  */
 static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
-			      int info_class, char *buf,
+			      struct smb2_set_info_req *req,
 			      struct ksmbd_share_config *share)
 {
-	switch (info_class) {
+	int buf_len = le32_to_cpu(req->BufferLength);
+
+	switch (req->FileInfoClass) {
 	case FILE_BASIC_INFORMATION:
-		return set_file_basic_info(fp, buf, share);
+	{
+		if (buf_len < sizeof(struct smb2_file_basic_info))
+			return -EINVAL;
 
+		return set_file_basic_info(fp, req->Buffer, share);
+	}
 	case FILE_ALLOCATION_INFORMATION:
-		return set_file_allocation_info(work, fp, buf);
+	{
+		if (buf_len < sizeof(struct smb2_file_alloc_info))
+			return -EINVAL;
 
+		return set_file_allocation_info(work, fp, req->Buffer);
+	}
 	case FILE_END_OF_FILE_INFORMATION:
-		return set_end_of_file_info(work, fp, buf);
+	{
+		if (buf_len < sizeof(struct smb2_file_eof_info))
+			return -EINVAL;
 
+		return set_end_of_file_info(work, fp, req->Buffer);
+	}
 	case FILE_RENAME_INFORMATION:
+	{
 		if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
 			ksmbd_debug(SMB,
 				    "User does not have write permission\n");
 			return -EACCES;
 		}
-		return set_rename_info(work, fp, buf);
 
+		if (buf_len < sizeof(struct smb2_file_rename_info))
+			return -EINVAL;
+
+		return set_rename_info(work, fp,
+				       (struct smb2_file_rename_info *)req->Buffer,
+				       buf_len);
+	}
 	case FILE_LINK_INFORMATION:
+	{
+		if (buf_len < sizeof(struct smb2_file_link_info))
+			return -EINVAL;
+
 		return smb2_create_link(work, work->tcon->share_conf,
-					(struct smb2_file_link_info *)buf, fp->filp,
+					(struct smb2_file_link_info *)req->Buffer,
+					buf_len, fp->filp,
 					work->sess->conn->local_nls);
-
+	}
 	case FILE_DISPOSITION_INFORMATION:
+	{
 		if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
 			ksmbd_debug(SMB,
 				    "User does not have write permission\n");
 			return -EACCES;
 		}
-		return set_file_disposition_info(fp, buf);
 
+		if (buf_len < sizeof(struct smb2_file_disposition_info))
+			return -EINVAL;
+
+		return set_file_disposition_info(fp, req->Buffer);
+	}
 	case FILE_FULL_EA_INFORMATION:
 	{
 		if (!(fp->daccess & FILE_WRITE_EA_LE)) {
@@ -5783,18 +5836,29 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 			return -EACCES;
 		}
 
-		return smb2_set_ea((struct smb2_ea_info *)buf,
-				   &fp->filp->f_path);
-	}
+		if (buf_len < sizeof(struct smb2_ea_info))
+			return -EINVAL;
 
+		return smb2_set_ea((struct smb2_ea_info *)req->Buffer,
+				   buf_len, &fp->filp->f_path);
+	}
 	case FILE_POSITION_INFORMATION:
-		return set_file_position_info(fp, buf);
+	{
+		if (buf_len < sizeof(struct smb2_file_pos_info))
+			return -EINVAL;
 
+		return set_file_position_info(fp, req->Buffer);
+	}
 	case FILE_MODE_INFORMATION:
-		return set_file_mode_info(fp, buf);
+	{
+		if (buf_len < sizeof(struct smb2_file_mode_info))
+			return -EINVAL;
+
+		return set_file_mode_info(fp, req->Buffer);
+	}
 	}
 
-	pr_err("Unimplemented Fileinfoclass :%d\n", info_class);
+	pr_err("Unimplemented Fileinfoclass :%d\n", req->FileInfoClass);
 	return -EOPNOTSUPP;
 }
 
@@ -5855,8 +5919,7 @@ int smb2_set_info(struct ksmbd_work *work)
 	switch (req->InfoType) {
 	case SMB2_O_INFO_FILE:
 		ksmbd_debug(SMB, "GOT SMB2_O_INFO_FILE\n");
-		rc = smb2_set_info_file(work, fp, req->FileInfoClass,
-					req->Buffer, work->tcon->share_conf);
+		rc = smb2_set_info_file(work, fp, req, work->tcon->share_conf);
 		break;
 	case SMB2_O_INFO_SECURITY:
 		ksmbd_debug(SMB, "GOT SMB2_O_INFO_SECURITY\n");
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

