Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D8BAQgPu"
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BDDF2
	for <linux-cifs@vger.kernel.org>; Sun,  3 Dec 2023 20:57:00 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1cfb4d28c43so12158955ad.1
        for <linux-cifs@vger.kernel.org>; Sun, 03 Dec 2023 20:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701665819; x=1702270619; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gCD3kZrhKniRs0Yp3Y0VJqOh2qmHopWCdYwSg9ClqYQ=;
        b=D8BAQgPuZSulxjn2Pfn+itfaIydzl7SKjM/TeTtw50FU6UQYBoFws4kHFX7w0GFvMT
         4ng5OVWUMtsJImrqApHZAQBVNnd5h8WFISIxr38CJKOeFTQdcwtR+Ann18YjwBVQ0Jbf
         8p4lgRglBoVZUia4QnqPNQqDXeAOp4RHrDphB50dpuDFnFUVM4T/JyKd03bKkPsHILnx
         1dyKNMrFQ8bFDzEzGQLzspRRZiEsc4NSI1o468e5ViMwIvf7TrBPZ8l6fgwTIUSJkM2j
         vx9V6vFeNtygB0L5yBLa8KimEqZlXhKmjyuNKDcFtvSDqqHGDoS3CcIEUgyvFfMERNO6
         zMUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701665819; x=1702270619;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gCD3kZrhKniRs0Yp3Y0VJqOh2qmHopWCdYwSg9ClqYQ=;
        b=hv2o2qAehHCTgEjObLYgKMB8YtRjoHrZsS4Iw48FrbKUFapFd5Qrik3cd5hY0LR6zO
         gXLeGgWxAAnPXJ/2eO7lae0Q+oh8zefknP9mvSZ72byIfYalDZJtPu468ViIQiKdZ3Cx
         asFGRIPFYbUGE94CLGX/4x0B8SwP91yAP9Bh6S4TG5GSMb+sM3NB5dlbW+SdDs+50yu2
         j7zPMnKMh552DzAjm0erJKzK99mPDMTtjOTMYLwIDcQvI4ofAEkD01g/eElyDJ/uhRIe
         Hd0xGbmZXZ8orF3ppFzdFHLJfG8ZuHfZR0NaHfBJNsghwjl2ry9ty4y3wDSMGaatHSvu
         NwwQ==
X-Gm-Message-State: AOJu0YzObl0EOmO+6FG/itwwDSDs/D1mOR+AE8IoQkGcZk2rqIjHpXRy
	IKkhl+qoNQe24uaxXR0mwOX59O1/Jqo=
X-Google-Smtp-Source: AGHT+IHzArx1QPXvbbnC5DTkuzgnBOR5e5ML4pKlPJiN7jbtvoQ6YeYSVxO4N8bR5pXY7rtzorDCeQ==
X-Received: by 2002:a17:902:dad0:b0:1d0:6d5e:47a7 with SMTP id q16-20020a170902dad000b001d06d5e47a7mr877945plx.60.1701665818515;
        Sun, 03 Dec 2023 20:56:58 -0800 (PST)
Received: from met-Virtual-Machine.. ([131.107.1.223])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902aa8900b001cfc50e5ae9sm7434347plr.78.2023.12.03.20.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Dec 2023 20:56:58 -0800 (PST)
From: meetakshisetiyaoss@gmail.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	nspmangalore@gmail.com,
	bharathsm.hsk@gmail.com,
	pc@manguebit.com,
	lsahlber@redhat.com,
	tom@talpey.com
Cc: Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH] cifs: Reuse file lease key in compound operations
Date: Sun,  3 Dec 2023 23:56:32 -0500
Message-Id: <20231204045632.72226-1-meetakshisetiyaoss@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Meetakshi Setiya <msetiya@microsoft.com>

Lock contention during unlink operation causes cifs lease break ack
worker thread to block and delay sending lease break acks to server.
This case occurs when multiple threads perform unlink, write and lease
break acks on the same file. Thhis patch fixes the problem by reusing
the existing lease keys for rename, unlink and set path size compound
operations so that the client does not break its own lease.

Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
---
 fs/smb/client/cifsglob.h  |  6 ++---
 fs/smb/client/cifsproto.h |  8 +++----
 fs/smb/client/cifssmb.c   |  6 ++---
 fs/smb/client/inode.c     | 12 +++++-----
 fs/smb/client/smb2inode.c | 49 +++++++++++++++++++++++++--------------
 fs/smb/client/smb2proto.h |  8 +++----
 6 files changed, 51 insertions(+), 38 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 7558167f603c..3f6f993357bd 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -355,7 +355,7 @@ struct smb_version_operations {
 			    struct cifs_open_info_data *data);
 	/* set size by path */
 	int (*set_path_size)(const unsigned int, struct cifs_tcon *,
-			     const char *, __u64, struct cifs_sb_info *, bool);
+			     const char *, __u64, struct cifs_sb_info *, bool, struct dentry *);
 	/* set size by file handle */
 	int (*set_file_size)(const unsigned int, struct cifs_tcon *,
 			     struct cifsFileInfo *, __u64, bool);
@@ -385,13 +385,13 @@ struct smb_version_operations {
 		     struct cifs_sb_info *);
 	/* unlink file */
 	int (*unlink)(const unsigned int, struct cifs_tcon *, const char *,
-		      struct cifs_sb_info *);
+		      struct cifs_sb_info *, struct dentry *);
 	/* open, rename and delete file */
 	int (*rename_pending_delete)(const char *, struct dentry *,
 				     const unsigned int);
 	/* send rename request */
 	int (*rename)(const unsigned int, struct cifs_tcon *, const char *,
-		      const char *, struct cifs_sb_info *);
+		      const char *, struct cifs_sb_info *, struct dentry *);
 	/* send create hardlink request */
 	int (*create_hardlink)(const unsigned int, struct cifs_tcon *,
 			       const char *, const char *,
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 46feaa0880bd..3bb15cc74bc2 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -397,8 +397,8 @@ extern int CIFSSMBSetFileDisposition(const unsigned int xid,
 				     bool delete_file, __u16 fid,
 				     __u32 pid_of_opener);
 extern int CIFSSMBSetEOF(const unsigned int xid, struct cifs_tcon *tcon,
-			 const char *file_name, __u64 size,
-			 struct cifs_sb_info *cifs_sb, bool set_allocation);
+			 const char *file_name, __u64 size, struct cifs_sb_info *cifs_sb,
+			 bool set_allocation, struct dentry *dentry);
 extern int CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon,
 			      struct cifsFileInfo *cfile, __u64 size,
 			      bool set_allocation);
@@ -434,10 +434,10 @@ extern int CIFSPOSIXDelFile(const unsigned int xid, struct cifs_tcon *tcon,
 			const struct nls_table *nls_codepage,
 			int remap_special_chars);
 extern int CIFSSMBDelFile(const unsigned int xid, struct cifs_tcon *tcon,
-			  const char *name, struct cifs_sb_info *cifs_sb);
+			  const char *name, struct cifs_sb_info *cifs_sb, struct dentry *dentry);
 extern int CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
 			 const char *from_name, const char *to_name,
-			 struct cifs_sb_info *cifs_sb);
+			 struct cifs_sb_info *cifs_sb, struct dentry *dentry);
 extern int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *tcon,
 				 int netfid, const char *target_name,
 				 const struct nls_table *nls_codepage,
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 9ee348e6d106..023b3bfa7b94 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -738,7 +738,7 @@ CIFSPOSIXDelFile(const unsigned int xid, struct cifs_tcon *tcon,
 
 int
 CIFSSMBDelFile(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
-	       struct cifs_sb_info *cifs_sb)
+	       struct cifs_sb_info *cifs_sb, struct dentry *dentry)
 {
 	DELETE_FILE_REQ *pSMB = NULL;
 	DELETE_FILE_RSP *pSMBr = NULL;
@@ -2152,7 +2152,7 @@ CIFSSMBFlush(const unsigned int xid, struct cifs_tcon *tcon, int smb_file_id)
 int
 CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
 	      const char *from_name, const char *to_name,
-	      struct cifs_sb_info *cifs_sb)
+	      struct cifs_sb_info *cifs_sb, struct dentry *dentry)
 {
 	int rc = 0;
 	RENAME_REQ *pSMB = NULL;
@@ -4982,7 +4982,7 @@ CIFSSMBQFSPosixInfo(const unsigned int xid, struct cifs_tcon *tcon,
 int
 CIFSSMBSetEOF(const unsigned int xid, struct cifs_tcon *tcon,
 	      const char *file_name, __u64 size, struct cifs_sb_info *cifs_sb,
-	      bool set_allocation)
+	      bool set_allocation, struct dentry *dentry)
 {
 	struct smb_com_transaction2_spi_req *pSMB = NULL;
 	struct smb_com_transaction2_spi_rsp *pSMBr = NULL;
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index d01e9ea67ccd..d5ad54733637 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1828,7 +1828,7 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 		goto psx_del_no_retry;
 	}
 
-	rc = server->ops->unlink(xid, tcon, full_path, cifs_sb);
+	rc = server->ops->unlink(xid, tcon, full_path, cifs_sb, dentry);
 
 psx_del_no_retry:
 	if (!rc) {
@@ -2227,7 +2227,7 @@ cifs_do_rename(const unsigned int xid, struct dentry *from_dentry,
 		return -ENOSYS;
 
 	/* try path-based rename first */
-	rc = server->ops->rename(xid, tcon, from_path, to_path, cifs_sb);
+	rc = server->ops->rename(xid, tcon, from_path, to_path, cifs_sb, from_dentry);
 
 	/*
 	 * Don't bother with rename by filehandle unless file is busy and
@@ -2774,7 +2774,7 @@ void cifs_setsize(struct inode *inode, loff_t offset)
 
 static int
 cifs_set_file_size(struct inode *inode, struct iattr *attrs,
-		   unsigned int xid, const char *full_path)
+		   unsigned int xid, const char *full_path, struct dentry *dentry)
 {
 	int rc;
 	struct cifsFileInfo *open_file;
@@ -2825,7 +2825,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 	 */
 	if (server->ops->set_path_size)
 		rc = server->ops->set_path_size(xid, tcon, full_path,
-						attrs->ia_size, cifs_sb, false);
+						attrs->ia_size, cifs_sb, false, dentry);
 	else
 		rc = -ENOSYS;
 	cifs_dbg(FYI, "SetEOF by path (setattrs) rc = %d\n", rc);
@@ -2915,7 +2915,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	rc = 0;
 
 	if (attrs->ia_valid & ATTR_SIZE) {
-		rc = cifs_set_file_size(inode, attrs, xid, full_path);
+		rc = cifs_set_file_size(inode, attrs, xid, full_path, direntry);
 		if (rc != 0)
 			goto out;
 	}
@@ -3081,7 +3081,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	}
 
 	if (attrs->ia_valid & ATTR_SIZE) {
-		rc = cifs_set_file_size(inode, attrs, xid, full_path);
+		rc = cifs_set_file_size(inode, attrs, xid, full_path, direntry);
 		if (rc != 0)
 			goto cifs_setattr_exit;
 	}
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index c94940af5d4b..ebee4779c743 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -48,7 +48,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			    __u32 desired_access, __u32 create_disposition, __u32 create_options,
 			    umode_t mode, void *ptr, int command, struct cifsFileInfo *cfile,
 			    __u8 **extbuf, size_t *extbuflen,
-			    struct kvec *out_iov, int *out_buftype)
+			    struct kvec *out_iov, int *out_buftype, struct dentry *dentry)
 {
 	struct smb2_compound_vars *vars = NULL;
 	struct kvec *rsp_iov;
@@ -59,6 +59,8 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_fid fid;
 	struct cifs_ses *ses = tcon->ses;
 	struct TCP_Server_Info *server;
+	struct inode *inode = NULL;
+	struct cifsInodeInfo *cinode = NULL;
 	int num_rqst = 0;
 	int resp_buftype[3];
 	struct smb2_query_info_rsp *qi_rsp = NULL;
@@ -93,6 +95,16 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		goto finished;
 	}
 
+	//if there is an existing lease, reuse it
+	if (dentry) {
+		inode = d_inode(dentry);
+		cinode = CIFS_I(inode);
+		if (cinode->lease_granted) {
+			oplock = SMB2_OPLOCK_LEVEL_LEASE;
+			memcpy(fid.lease_key, cinode->lease_key, SMB2_LEASE_KEY_SIZE);
+		}
+	}
+	
 	vars->oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
 		.path = full_path,
@@ -596,7 +608,7 @@ int smb2_query_path_info(const unsigned int xid,
 	cifs_get_readable_path(tcon, full_path, &cfile);
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, FILE_READ_ATTRIBUTES, FILE_OPEN,
 			      create_options, ACL_NO_MODE, data, SMB2_OP_QUERY_INFO, cfile,
-			      NULL, NULL, out_iov, out_buftype);
+			      NULL, NULL, out_iov, out_buftype, NULL);
 	hdr = out_iov[0].iov_base;
 	/*
 	 * If first iov is unset, then SMB session was dropped or we've got a
@@ -619,7 +631,7 @@ int smb2_query_path_info(const unsigned int xid,
 				      FILE_READ_ATTRIBUTES, FILE_OPEN,
 				      create_options, ACL_NO_MODE, data,
 				      SMB2_OP_QUERY_INFO, cfile, NULL, NULL,
-				      NULL, NULL);
+				      NULL, NULL, NULL);
 		break;
 	case -EREMOTE:
 		break;
@@ -674,7 +686,7 @@ int smb311_posix_query_path_info(const unsigned int xid,
 	cifs_get_readable_path(tcon, full_path, &cfile);
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, FILE_READ_ATTRIBUTES, FILE_OPEN,
 			      create_options, ACL_NO_MODE, data, SMB2_OP_POSIX_QUERY_INFO, cfile,
-			      &sidsbuf, &sidsbuflen, out_iov, out_buftype);
+			      &sidsbuf, &sidsbuflen, out_iov, out_buftype, NULL);
 	/*
 	 * If first iov is unset, then SMB session was dropped or we've got a
 	 * cached open file (@cfile).
@@ -696,7 +708,7 @@ int smb311_posix_query_path_info(const unsigned int xid,
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, FILE_READ_ATTRIBUTES,
 				      FILE_OPEN, create_options, ACL_NO_MODE, data,
 				      SMB2_OP_POSIX_QUERY_INFO, cfile,
-				      &sidsbuf, &sidsbuflen, NULL, NULL);
+				      &sidsbuf, &sidsbuflen, NULL, NULL, NULL);
 		break;
 	}
 
@@ -735,7 +747,7 @@ smb2_mkdir(const unsigned int xid, struct inode *parent_inode, umode_t mode,
 	return smb2_compound_op(xid, tcon, cifs_sb, name,
 				FILE_WRITE_ATTRIBUTES, FILE_CREATE,
 				CREATE_NOT_FILE, mode, NULL, SMB2_OP_MKDIR,
-				NULL, NULL, NULL, NULL, NULL);
+				NULL, NULL, NULL, NULL, NULL, NULL);
 }
 
 void
@@ -757,7 +769,7 @@ smb2_mkdir_setinfo(struct inode *inode, const char *name,
 	tmprc = smb2_compound_op(xid, tcon, cifs_sb, name,
 				 FILE_WRITE_ATTRIBUTES, FILE_CREATE,
 				 CREATE_NOT_FILE, ACL_NO_MODE,
-				 &data, SMB2_OP_SET_INFO, cfile, NULL, NULL, NULL, NULL);
+				 &data, SMB2_OP_SET_INFO, cfile, NULL, NULL, NULL, NULL, NULL);
 	if (tmprc == 0)
 		cifs_i->cifsAttrs = dosattrs;
 }
@@ -769,23 +781,24 @@ smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	drop_cached_dir_by_name(xid, tcon, name, cifs_sb);
 	return smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
 				CREATE_NOT_FILE, ACL_NO_MODE,
-				NULL, SMB2_OP_RMDIR, NULL, NULL, NULL, NULL, NULL);
+				NULL, SMB2_OP_RMDIR, NULL, NULL, NULL, NULL, NULL, NULL);
 }
 
 int
 smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
-	    struct cifs_sb_info *cifs_sb)
+	    struct cifs_sb_info *cifs_sb, struct dentry *dentry)
 {
 	return smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
 				CREATE_DELETE_ON_CLOSE | OPEN_REPARSE_POINT,
-				ACL_NO_MODE, NULL, SMB2_OP_DELETE, NULL, NULL, NULL, NULL, NULL);
+				ACL_NO_MODE, NULL, SMB2_OP_DELETE, NULL, NULL,
+				NULL, NULL, NULL, dentry);
 }
 
 static int
 smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
 		   const char *from_name, const char *to_name,
 		   struct cifs_sb_info *cifs_sb, __u32 access, int command,
-		   struct cifsFileInfo *cfile)
+		   struct cifsFileInfo *cfile, struct dentry *dentry)
 {
 	__le16 *smb2_to_name = NULL;
 	int rc;
@@ -797,7 +810,7 @@ smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 	rc = smb2_compound_op(xid, tcon, cifs_sb, from_name, access,
 			      FILE_OPEN, 0, ACL_NO_MODE, smb2_to_name,
-			      command, cfile, NULL, NULL, NULL, NULL);
+			      command, cfile, NULL, NULL, NULL, NULL, dentry);
 smb2_rename_path:
 	kfree(smb2_to_name);
 	return rc;
@@ -806,7 +819,7 @@ smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
 int
 smb2_rename_path(const unsigned int xid, struct cifs_tcon *tcon,
 		 const char *from_name, const char *to_name,
-		 struct cifs_sb_info *cifs_sb)
+		 struct cifs_sb_info *cifs_sb, struct dentry *dentry)
 {
 	struct cifsFileInfo *cfile;
 
@@ -814,7 +827,7 @@ smb2_rename_path(const unsigned int xid, struct cifs_tcon *tcon,
 	cifs_get_writable_path(tcon, from_name, FIND_WR_WITH_DELETE, &cfile);
 
 	return smb2_set_path_attr(xid, tcon, from_name, to_name,
-				  cifs_sb, DELETE, SMB2_OP_RENAME, cfile);
+				  cifs_sb, DELETE, SMB2_OP_RENAME, cfile, dentry);
 }
 
 int
@@ -824,13 +837,13 @@ smb2_create_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	return smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
 				  FILE_READ_ATTRIBUTES, SMB2_OP_HARDLINK,
-				  NULL);
+				  NULL, NULL);
 }
 
 int
 smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
 		   const char *full_path, __u64 size,
-		   struct cifs_sb_info *cifs_sb, bool set_alloc)
+		   struct cifs_sb_info *cifs_sb, bool set_alloc, struct dentry *dentry)
 {
 	__le64 eof = cpu_to_le64(size);
 	struct cifsFileInfo *cfile;
@@ -838,7 +851,7 @@ smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
 	cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
 	return smb2_compound_op(xid, tcon, cifs_sb, full_path,
 				FILE_WRITE_DATA, FILE_OPEN, 0, ACL_NO_MODE,
-				&eof, SMB2_OP_SET_EOF, cfile, NULL, NULL, NULL, NULL);
+				&eof, SMB2_OP_SET_EOF, cfile, NULL, NULL, NULL, NULL, dentry);
 }
 
 int
@@ -865,7 +878,7 @@ smb2_set_file_info(struct inode *inode, const char *full_path,
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 			      FILE_WRITE_ATTRIBUTES, FILE_OPEN,
 			      0, ACL_NO_MODE, buf, SMB2_OP_SET_INFO, cfile,
-			      NULL, NULL, NULL, NULL);
+			      NULL, NULL, NULL, NULL, NULL);
 	cifs_put_tlink(tlink);
 	return rc;
 }
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 46eff9ec302a..ec3755110da5 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -62,8 +62,8 @@ int smb2_query_path_info(const unsigned int xid,
 			 const char *full_path,
 			 struct cifs_open_info_data *data);
 extern int smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
-			      const char *full_path, __u64 size,
-			      struct cifs_sb_info *cifs_sb, bool set_alloc);
+			      const char *full_path, __u64 size, struct cifs_sb_info *cifs_sb,
+				  bool set_alloc, struct dentry *dentry);
 extern int smb2_set_file_info(struct inode *inode, const char *full_path,
 			      FILE_BASIC_INFO *buf, const unsigned int xid);
 extern int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
@@ -79,10 +79,10 @@ extern void smb2_mkdir_setinfo(struct inode *inode, const char *full_path,
 extern int smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon,
 		      const char *name, struct cifs_sb_info *cifs_sb);
 extern int smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon,
-		       const char *name, struct cifs_sb_info *cifs_sb);
+		       const char *name, struct cifs_sb_info *cifs_sb, struct dentry *dentry);
 extern int smb2_rename_path(const unsigned int xid, struct cifs_tcon *tcon,
 			    const char *from_name, const char *to_name,
-			    struct cifs_sb_info *cifs_sb);
+			    struct cifs_sb_info *cifs_sb, struct dentry *dentry);
 extern int smb2_create_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
 				const char *from_name, const char *to_name,
 				struct cifs_sb_info *cifs_sb);
-- 
2.39.2

