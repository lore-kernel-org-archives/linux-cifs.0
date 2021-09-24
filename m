Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88FDAC433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 02:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6782061039
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 02:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243907AbhIXCOp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 22:14:45 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:37663 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243813AbhIXCOo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Sep 2021 22:14:44 -0400
Received: by mail-pj1-f44.google.com with SMTP id me5-20020a17090b17c500b0019af76b7bb4so8422435pjb.2
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 19:13:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DhbUZYXHTf40mBFr4EQcH4GdtGfNW4yPXT2vJKa5dGQ=;
        b=UUFsnzOYUlG0oBLmPqtb05+Qav8pzQWcAKCN7IsoTWTMbSYZkZqkHcqXAvC8cj1xex
         ZIot59Rwvek+ZnomMM5P8M2+gJfE+Yr5dLvH1Cc7XOlBps5kFyadXxQzSBBXoFeg+usi
         DzgTH6AXR99MUcE6xnmy1Jz2aEwAgtnA3K+qhq7W31J6c9unZDOvPZ2nBRe+9Nv9AfAC
         QvMumG5JN47llqzloZu/urSWfgKzcP9P6Iw+eYpmXeKAesdgRF6SR8o0wkBs2v1tXWIl
         Lgpte79nlFJf0VZNyiM5UoBbrHYZRmsJYmPpun6k1a/ovDaaPFOEQLlzSsAwH8/mw28R
         e+nA==
X-Gm-Message-State: AOAM531RhlPuDol1P2dtEnZQFrXbM4xwZ1xGL1v2HgQQZYACUMeYc5R6
        FdsSvh9rzh4W31T0DShHjYYrzGdldiob1Q==
X-Google-Smtp-Source: ABdhPJy9w367O87czW6VDb/q6DjhNU7c8WQuFkgL4t6lv7VmoYtQH0N1fa7NsGSmn9ohOUXW+5pO9A==
X-Received: by 2002:a17:902:7b85:b0:13d:cdc4:9531 with SMTP id w5-20020a1709027b8500b0013dcdc49531mr6657876pll.27.1632449592015;
        Thu, 23 Sep 2021 19:13:12 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id c16sm6724746pfo.163.2021.09.23.19.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 19:13:11 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 2/7] ksmbd: add request buffer validation in smb2_set_info
Date:   Fri, 24 Sep 2021 11:12:49 +0900
Message-Id: <20210924021254.27096-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210924021254.27096-1-linkinjeon@kernel.org>
References: <20210924021254.27096-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add buffer validation in smb2_set_info, and remove unused variable
in set_file_basic_info. and smb2_set_info infolevel functions take
structure pointer argument.

Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 149 ++++++++++++++++++++++++++++++++-------------
 fs/ksmbd/smb2pdu.h |   9 +++
 2 files changed, 116 insertions(+), 42 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index b22d4207c077..a930838fd6ac 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2107,16 +2107,22 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
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
-	int next = 0;
+	unsigned int next = 0;
+
+	if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength +
+			le16_to_cpu(eabuf->EaValueLength))
+		return -EINVAL;
 
 	attr_name = kmalloc(XATTR_NAME_MAX + 1, GFP_KERNEL);
 	if (!attr_name)
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
@@ -2771,7 +2783,15 @@ int smb2_open(struct ksmbd_work *work)
 		created = true;
 		user_ns = mnt_user_ns(path.mnt);
 		if (ea_buf) {
-			rc = smb2_set_ea(&ea_buf->ea, &path);
+			if (le32_to_cpu(ea_buf->ccontext.DataLength) <
+			    sizeof(struct smb2_ea_info)) {
+				rc = -EINVAL;
+				goto err_out;
+			}
+
+			rc = smb2_set_ea(&ea_buf->ea,
+					 le32_to_cpu(ea_buf->ccontext.DataLength),
+					 &path);
 			if (rc == -EOPNOTSUPP)
 				rc = 0;
 			else if (rc)
@@ -5354,7 +5374,7 @@ static int smb2_rename(struct ksmbd_work *work,
 static int smb2_create_link(struct ksmbd_work *work,
 			    struct ksmbd_share_config *share,
 			    struct smb2_file_link_info *file_info,
-			    struct file *filp,
+			    unsigned int buf_len, struct file *filp,
 			    struct nls_table *local_nls)
 {
 	char *link_name = NULL, *target_name = NULL, *pathname = NULL;
@@ -5362,6 +5382,10 @@ static int smb2_create_link(struct ksmbd_work *work,
 	bool file_present = true;
 	int rc;
 
+	if (buf_len < sizeof(struct smb2_file_link_info) +
+			le32_to_cpu(file_info->FileNameLength))
+		return -EINVAL;
+
 	ksmbd_debug(SMB, "setting FILE_LINK_INFORMATION\n");
 	pathname = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!pathname)
@@ -5418,10 +5442,10 @@ static int smb2_create_link(struct ksmbd_work *work,
 	return rc;
 }
 
-static int set_file_basic_info(struct ksmbd_file *fp, char *buf,
+static int set_file_basic_info(struct ksmbd_file *fp,
+			       struct smb2_file_basic_info *file_info,
 			       struct ksmbd_share_config *share)
 {
-	struct smb2_file_all_info *file_info;
 	struct iattr attrs;
 	struct timespec64 ctime;
 	struct file *filp;
@@ -5432,7 +5456,6 @@ static int set_file_basic_info(struct ksmbd_file *fp, char *buf,
 	if (!(fp->daccess & FILE_WRITE_ATTRIBUTES_LE))
 		return -EACCES;
 
-	file_info = (struct smb2_file_all_info *)buf;
 	attrs.ia_valid = 0;
 	filp = fp->filp;
 	inode = file_inode(filp);
@@ -5509,7 +5532,8 @@ static int set_file_basic_info(struct ksmbd_file *fp, char *buf,
 }
 
 static int set_file_allocation_info(struct ksmbd_work *work,
-				    struct ksmbd_file *fp, char *buf)
+				    struct ksmbd_file *fp,
+				    struct smb2_file_alloc_info *file_alloc_info)
 {
 	/*
 	 * TODO : It's working fine only when store dos attributes
@@ -5517,7 +5541,6 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 	 * properly with any smb.conf option
 	 */
 
-	struct smb2_file_alloc_info *file_alloc_info;
 	loff_t alloc_blks;
 	struct inode *inode;
 	int rc;
@@ -5525,7 +5548,6 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 	if (!(fp->daccess & FILE_WRITE_DATA_LE))
 		return -EACCES;
 
-	file_alloc_info = (struct smb2_file_alloc_info *)buf;
 	alloc_blks = (le64_to_cpu(file_alloc_info->AllocationSize) + 511) >> 9;
 	inode = file_inode(fp->filp);
 
@@ -5561,9 +5583,8 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 }
 
 static int set_end_of_file_info(struct ksmbd_work *work, struct ksmbd_file *fp,
-				char *buf)
+				struct smb2_file_eof_info *file_eof_info)
 {
-	struct smb2_file_eof_info *file_eof_info;
 	loff_t newsize;
 	struct inode *inode;
 	int rc;
@@ -5571,7 +5592,6 @@ static int set_end_of_file_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 	if (!(fp->daccess & FILE_WRITE_DATA_LE))
 		return -EACCES;
 
-	file_eof_info = (struct smb2_file_eof_info *)buf;
 	newsize = le64_to_cpu(file_eof_info->EndOfFile);
 	inode = file_inode(fp->filp);
 
@@ -5598,7 +5618,8 @@ static int set_end_of_file_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 }
 
 static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
-			   char *buf)
+			   struct smb2_file_rename_info *rename_info,
+			   unsigned int buf_len)
 {
 	struct user_namespace *user_ns;
 	struct ksmbd_file *parent_fp;
@@ -5611,6 +5632,10 @@ static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 		return -EACCES;
 	}
 
+	if (buf_len < sizeof(struct smb2_file_rename_info) +
+			le32_to_cpu(rename_info->FileNameLength))
+		return -EINVAL;
+
 	user_ns = file_mnt_user_ns(fp->filp);
 	if (ksmbd_stream_fd(fp))
 		goto next;
@@ -5633,14 +5658,13 @@ static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 		}
 	}
 next:
-	return smb2_rename(work, fp, user_ns,
-			   (struct smb2_file_rename_info *)buf,
+	return smb2_rename(work, fp, user_ns, rename_info,
 			   work->sess->conn->local_nls);
 }
 
-static int set_file_disposition_info(struct ksmbd_file *fp, char *buf)
+static int set_file_disposition_info(struct ksmbd_file *fp,
+				     struct smb2_file_disposition_info *file_info)
 {
-	struct smb2_file_disposition_info *file_info;
 	struct inode *inode;
 
 	if (!(fp->daccess & FILE_DELETE_LE)) {
@@ -5649,7 +5673,6 @@ static int set_file_disposition_info(struct ksmbd_file *fp, char *buf)
 	}
 
 	inode = file_inode(fp->filp);
-	file_info = (struct smb2_file_disposition_info *)buf;
 	if (file_info->DeletePending) {
 		if (S_ISDIR(inode->i_mode) &&
 		    ksmbd_vfs_empty_dir(fp) == -ENOTEMPTY)
@@ -5661,15 +5684,14 @@ static int set_file_disposition_info(struct ksmbd_file *fp, char *buf)
 	return 0;
 }
 
-static int set_file_position_info(struct ksmbd_file *fp, char *buf)
+static int set_file_position_info(struct ksmbd_file *fp,
+				  struct smb2_file_pos_info *file_info)
 {
-	struct smb2_file_pos_info *file_info;
 	loff_t current_byte_offset;
 	unsigned long sector_size;
 	struct inode *inode;
 
 	inode = file_inode(fp->filp);
-	file_info = (struct smb2_file_pos_info *)buf;
 	current_byte_offset = le64_to_cpu(file_info->CurrentByteOffset);
 	sector_size = inode->i_sb->s_blocksize;
 
@@ -5685,12 +5707,11 @@ static int set_file_position_info(struct ksmbd_file *fp, char *buf)
 	return 0;
 }
 
-static int set_file_mode_info(struct ksmbd_file *fp, char *buf)
+static int set_file_mode_info(struct ksmbd_file *fp,
+			      struct smb2_file_mode_info *file_info)
 {
-	struct smb2_file_mode_info *file_info;
 	__le32 mode;
 
-	file_info = (struct smb2_file_mode_info *)buf;
 	mode = file_info->Mode;
 
 	if ((mode & ~FILE_MODE_INFO_MASK) ||
@@ -5720,40 +5741,74 @@ static int set_file_mode_info(struct ksmbd_file *fp, char *buf)
  * TODO: need to implement an error handling for STATUS_INFO_LENGTH_MISMATCH
  */
 static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
-			      int info_class, char *buf,
+			      struct smb2_set_info_req *req,
 			      struct ksmbd_share_config *share)
 {
-	switch (info_class) {
+	unsigned int buf_len = le32_to_cpu(req->BufferLength);
+
+	switch (req->FileInfoClass) {
 	case FILE_BASIC_INFORMATION:
-		return set_file_basic_info(fp, buf, share);
+	{
+		if (buf_len < sizeof(struct smb2_file_basic_info))
+			return -EINVAL;
 
+		return set_file_basic_info(fp, (struct smb2_file_basic_info *)req->Buffer, share);
+	}
 	case FILE_ALLOCATION_INFORMATION:
-		return set_file_allocation_info(work, fp, buf);
+	{
+		if (buf_len < sizeof(struct smb2_file_alloc_info))
+			return -EINVAL;
 
+		return set_file_allocation_info(work, fp,
+						(struct smb2_file_alloc_info *)req->Buffer);
+	}
 	case FILE_END_OF_FILE_INFORMATION:
-		return set_end_of_file_info(work, fp, buf);
+	{
+		if (buf_len < sizeof(struct smb2_file_eof_info))
+			return -EINVAL;
 
+		return set_end_of_file_info(work, fp,
+					    (struct smb2_file_eof_info *)req->Buffer);
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
+		return set_file_disposition_info(fp,
+						 (struct smb2_file_disposition_info *)req->Buffer);
+	}
 	case FILE_FULL_EA_INFORMATION:
 	{
 		if (!(fp->daccess & FILE_WRITE_EA_LE)) {
@@ -5762,18 +5817,29 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
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
 
+		return set_file_position_info(fp, (struct smb2_file_pos_info *)req->Buffer);
+	}
 	case FILE_MODE_INFORMATION:
-		return set_file_mode_info(fp, buf);
+	{
+		if (buf_len < sizeof(struct smb2_file_mode_info))
+			return -EINVAL;
+
+		return set_file_mode_info(fp, (struct smb2_file_mode_info *)req->Buffer);
+	}
 	}
 
-	pr_err("Unimplemented Fileinfoclass :%d\n", info_class);
+	pr_err("Unimplemented Fileinfoclass :%d\n", req->FileInfoClass);
 	return -EOPNOTSUPP;
 }
 
@@ -5834,8 +5900,7 @@ int smb2_set_info(struct ksmbd_work *work)
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

