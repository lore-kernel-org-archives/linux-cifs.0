Return-Path: <SRS0=wCsU=WX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A3EC3A59F
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Aug 2019 02:11:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9EA62080C
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Aug 2019 02:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbfH0CLp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Aug 2019 22:11:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59370 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbfH0CLp (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 26 Aug 2019 22:11:45 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6606D88305;
        Tue, 27 Aug 2019 02:11:44 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-71.bne.redhat.com [10.64.54.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE56C60BE2;
        Tue, 27 Aug 2019 02:11:43 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: create a helper to find a writeable handle by path name
Date:   Tue, 27 Aug 2019 12:11:37 +1000
Message-Id: <20190827021137.30345-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 27 Aug 2019 02:11:44 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

rename() takes a path for old_file and in SMB2 we used to just create
a compound for create(old_path)/rename/close().
If we already have a writable handle we can avoid the create() and close()
altogether and just use the existing handle.

For this situation, as we avoid doing the create()
we also avoid triggering an oplock break for the existing handle.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsproto.h |  2 ++
 fs/cifs/file.c      | 35 ++++++++++++++++++++
 fs/cifs/smb2inode.c | 93 ++++++++++++++++++++++++++++++++++++++---------------
 3 files changed, 104 insertions(+), 26 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 592a6cea2b79..be206744407c 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -137,6 +137,8 @@ extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *, bool);
 extern int cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
 				  bool fsuid_only,
 				  struct cifsFileInfo **ret_file);
+extern int cifs_get_writable_path(struct cifs_tcon *tcon, const char *name,
+				  struct cifsFileInfo **ret_file);
 extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, bool);
 extern unsigned int smbCalcSize(void *buf, struct TCP_Server_Info *server);
 extern int decode_negTokenInit(unsigned char *security_blob, int length,
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 97090693d182..b67f17b06bcd 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1980,6 +1980,41 @@ find_writable_file(struct cifsInodeInfo *cifs_inode, bool fsuid_only)
 	return cfile;
 }
 
+int
+cifs_get_writable_path(struct cifs_tcon *tcon, const char *name,
+		       struct cifsFileInfo **ret_file)
+{
+	struct list_head *tmp;
+	struct cifsFileInfo *cfile;
+	struct cifsInodeInfo *cinode;
+	char *full_path;
+
+	*ret_file = NULL;
+
+	spin_lock(&tcon->open_file_lock);
+	list_for_each(tmp, &tcon->openFileList) {
+		cfile = list_entry(tmp, struct cifsFileInfo,
+			     tlist);
+		full_path = build_path_from_dentry(cfile->dentry);
+		if (full_path == NULL) {
+			spin_unlock(&tcon->open_file_lock);
+			return -ENOMEM;
+		}
+		if (strcmp(full_path, name)) {
+			kfree(full_path);
+			continue;
+		}
+		kfree(full_path);
+
+		cinode = CIFS_I(d_inode(cfile->dentry));
+		spin_unlock(&tcon->open_file_lock);
+		return cifs_get_writable_file(cinode, 0, ret_file);
+	}
+
+	spin_unlock(&tcon->open_file_lock);
+	return -ENOENT;
+}
+
 static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 {
 	struct address_space *mapping = page->mapping;
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index d8d9cdfa30b6..70342bcd89b4 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -51,7 +51,8 @@ static int
 smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		 struct cifs_sb_info *cifs_sb, const char *full_path,
 		 __u32 desired_access, __u32 create_disposition,
-		 __u32 create_options, void *ptr, int command)
+		 __u32 create_options, void *ptr, int command,
+		 struct cifsFileInfo *cfile)
 {
 	int rc;
 	__le16 *utf16_path = NULL;
@@ -83,10 +84,16 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
 	memset(rsp_iov, 0, sizeof(rsp_iov));
 
+	/* We already have a handle so we can skip the open */
+	if (cfile)
+		goto after_open;
+
 	/* Open */
 	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
-	if (!utf16_path)
-		return -ENOMEM;
+	if (!utf16_path) {
+		rc = -ENOMEM;
+		goto finished;
+	}
 
 	oparms.tcon = tcon;
 	oparms.desired_access = desired_access;
@@ -106,7 +113,9 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc)
 		goto finished;
 
-	smb2_set_next_command(tcon, &rqst[num_rqst++]);
+	smb2_set_next_command(tcon, &rqst[num_rqst]);
+ after_open:
+	num_rqst++;
 
 	/* Operation */
 	switch (command) {
@@ -210,14 +219,23 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		size[1] = len + 2 /* null */;
 		data[1] = (__le16 *)ptr;
 
-		rc = SMB2_set_info_init(tcon, &rqst[num_rqst], COMPOUND_FID,
-					COMPOUND_FID, current->tgid,
-					FILE_RENAME_INFORMATION,
+		if (cfile)
+			rc = SMB2_set_info_init(tcon, &rqst[num_rqst],
+						cfile->fid.persistent_fid,
+						cfile->fid.volatile_fid,
+					current->tgid, FILE_RENAME_INFORMATION,
+					SMB2_O_INFO_FILE, 0, data, size);
+		else {
+			rc = SMB2_set_info_init(tcon, &rqst[num_rqst],
+					COMPOUND_FID, COMPOUND_FID,
+					current->tgid, FILE_RENAME_INFORMATION,
 					SMB2_O_INFO_FILE, 0, data, size);
+			smb2_set_next_command(tcon, &rqst[num_rqst]);
+			smb2_set_related(&rqst[num_rqst]);
+		}
 		if (rc)
 			goto finished;
-		smb2_set_next_command(tcon, &rqst[num_rqst]);
-		smb2_set_related(&rqst[num_rqst++]);
+		num_rqst++;
 		trace_smb3_rename_enter(xid, ses->Suid, tcon->tid, full_path);
 		break;
 	case SMB2_OP_HARDLINK:
@@ -254,20 +272,36 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc)
 		goto finished;
 
+	/* We already have a handle so we can skip the close */
+	if (cfile)
+		goto after_close;
 	/* Close */
 	memset(&close_iov, 0, sizeof(close_iov));
 	rqst[num_rqst].rq_iov = close_iov;
 	rqst[num_rqst].rq_nvec = 1;
 	rc = SMB2_close_init(tcon, &rqst[num_rqst], COMPOUND_FID,
 			     COMPOUND_FID);
-	smb2_set_related(&rqst[num_rqst++]);
+	smb2_set_related(&rqst[num_rqst]);
 	if (rc)
 		goto finished;
-
-	rc = compound_send_recv(xid, ses, flags, num_rqst, rqst,
-				resp_buftype, rsp_iov);
+ after_close:
+	num_rqst++;
+
+	if (cfile) {
+		cifsFileInfo_put(cfile);
+		cfile = NULL;
+		rc = compound_send_recv(xid, ses, flags, num_rqst - 2,
+					&rqst[1], &resp_buftype[1],
+					&rsp_iov[1]);
+	} else
+		rc = compound_send_recv(xid, ses, flags, num_rqst,
+					rqst, resp_buftype,
+					rsp_iov);
 
  finished:
+	if (cfile)
+		cifsFileInfo_put(cfile);
+
 	SMB2_open_free(&rqst[0]);
 	switch (command) {
 	case SMB2_OP_QUERY_INFO:
@@ -404,7 +438,7 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 			      FILE_READ_ATTRIBUTES, FILE_OPEN, create_options,
-			      smb2_data, SMB2_OP_QUERY_INFO);
+			      smb2_data, SMB2_OP_QUERY_INFO, NULL);
 	if (rc == -EOPNOTSUPP) {
 		*symlink = true;
 		create_options |= OPEN_REPARSE_POINT;
@@ -413,7 +447,7 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 				      FILE_READ_ATTRIBUTES, FILE_OPEN,
 				      create_options, smb2_data,
-				      SMB2_OP_QUERY_INFO);
+				      SMB2_OP_QUERY_INFO, NULL);
 	}
 	if (rc)
 		goto out;
@@ -430,7 +464,7 @@ smb2_mkdir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 {
 	return smb2_compound_op(xid, tcon, cifs_sb, name,
 				FILE_WRITE_ATTRIBUTES, FILE_CREATE,
-				CREATE_NOT_FILE, NULL, SMB2_OP_MKDIR);
+				CREATE_NOT_FILE, NULL, SMB2_OP_MKDIR, NULL);
 }
 
 void
@@ -449,7 +483,8 @@ smb2_mkdir_setinfo(struct inode *inode, const char *name,
 	data.Attributes = cpu_to_le32(dosattrs);
 	tmprc = smb2_compound_op(xid, tcon, cifs_sb, name,
 				 FILE_WRITE_ATTRIBUTES, FILE_CREATE,
-				 CREATE_NOT_FILE, &data, SMB2_OP_SET_INFO);
+				 CREATE_NOT_FILE, &data, SMB2_OP_SET_INFO,
+				 NULL);
 	if (tmprc == 0)
 		cifs_i->cifsAttrs = dosattrs;
 }
@@ -460,7 +495,7 @@ smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 {
 	return smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
 				CREATE_NOT_FILE,
-				NULL, SMB2_OP_RMDIR);
+				NULL, SMB2_OP_RMDIR, NULL);
 }
 
 int
@@ -469,13 +504,14 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 {
 	return smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
 				CREATE_DELETE_ON_CLOSE | OPEN_REPARSE_POINT,
-				NULL, SMB2_OP_DELETE);
+				NULL, SMB2_OP_DELETE, NULL);
 }
 
 static int
 smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
 		   const char *from_name, const char *to_name,
-		   struct cifs_sb_info *cifs_sb, __u32 access, int command)
+		   struct cifs_sb_info *cifs_sb, __u32 access, int command,
+		   struct cifsFileInfo *cfile)
 {
 	__le16 *smb2_to_name = NULL;
 	int rc;
@@ -486,7 +522,7 @@ smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
 		goto smb2_rename_path;
 	}
 	rc = smb2_compound_op(xid, tcon, cifs_sb, from_name, access,
-			      FILE_OPEN, 0, smb2_to_name, command);
+			      FILE_OPEN, 0, smb2_to_name, command, cfile);
 smb2_rename_path:
 	kfree(smb2_to_name);
 	return rc;
@@ -497,8 +533,12 @@ smb2_rename_path(const unsigned int xid, struct cifs_tcon *tcon,
 		 const char *from_name, const char *to_name,
 		 struct cifs_sb_info *cifs_sb)
 {
-	return smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
-				  DELETE, SMB2_OP_RENAME);
+	struct cifsFileInfo *cfile;
+
+	cifs_get_writable_path(tcon, from_name, &cfile);
+
+	return smb2_set_path_attr(xid, tcon, from_name, to_name,
+				  cifs_sb, DELETE, SMB2_OP_RENAME, cfile);
 }
 
 int
@@ -507,7 +547,8 @@ smb2_create_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
 		     struct cifs_sb_info *cifs_sb)
 {
 	return smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
-				  FILE_READ_ATTRIBUTES, SMB2_OP_HARDLINK);
+				  FILE_READ_ATTRIBUTES, SMB2_OP_HARDLINK,
+				  NULL);
 }
 
 int
@@ -519,7 +560,7 @@ smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
 
 	return smb2_compound_op(xid, tcon, cifs_sb, full_path,
 				FILE_WRITE_DATA, FILE_OPEN, 0, &eof,
-				SMB2_OP_SET_EOF);
+				SMB2_OP_SET_EOF, NULL);
 }
 
 int
@@ -541,7 +582,7 @@ smb2_set_file_info(struct inode *inode, const char *full_path,
 
 	rc = smb2_compound_op(xid, tlink_tcon(tlink), cifs_sb, full_path,
 			      FILE_WRITE_ATTRIBUTES, FILE_OPEN, 0, buf,
-			      SMB2_OP_SET_INFO);
+			      SMB2_OP_SET_INFO, NULL);
 	cifs_put_tlink(tlink);
 	return rc;
 }
-- 
2.13.6

