Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578FE11C80
	for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 14:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pyt6gLnJ"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-35fd902c6b5so55385045ab.3
        for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 06:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703860535; x=1704465335; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gXdOfuEQDLUl6qm/2eLakO53zvwX3ZI8WlVJvs6vcLE=;
        b=Pyt6gLnJHc4XmP5cg0MxPPBVLkxKPqGXyj66kvid7Hl8okRvhFSgdApPvWDS/CnRv4
         DPQSaQfa5fFkFxeRLsTTrG/LNE/ZpVL5W5ZDuaQqOG0YciIuxPgSLoGnMhSIfJVqqw6y
         1towbS2nBRQJXvUcuyiBMyzvDvEzBPLm+pLnBLvhBI9OUbbUBvJ2fxfVHC5bqk9s/CXW
         nb/NIsyS5cGJVdc3XDpfbfl9yhgBHZ7Jjon/HcmlHHSFV5/7lktkmbumM1dFnEYILKpL
         iiOp6INx6iQXzKEjTib5y8qzY/vzzrHd2G0WMl9gM2KsXwt4Uh3zkv2lA6lXFlAlJQKp
         cKvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703860535; x=1704465335;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gXdOfuEQDLUl6qm/2eLakO53zvwX3ZI8WlVJvs6vcLE=;
        b=dNIuEqlx2gTikkt/xefCJW/hUBMtJghhTrN38CLOPG7sDwqUIGsWEw+E3lbXmEE/Zt
         YPlSLiwojNgnMLBGqbrtxmO5/Jd4n293sI6cAEK1Y5IfgrExyLy/hqduUFDzcrioaik4
         8jUnWYHj30vyvh5Z2z2IC7IYFWVfhaVLDmYFwQn3iTaVThMQgBAGCJQ4rPQH4cZWbOIP
         bgd/u2gbMVCwWeRzOYKiFViEyw8cF67HAQMplrWrvre9728Xj0J5cmVLqGLUzLMjKDki
         VJ5AUvj00Em13bd+YhLsmMT136rtTjIlNPamp41BWAhM1tcD0XVklbsjZJvxdMDOX0Pc
         4k/Q==
X-Gm-Message-State: AOJu0YwByC3iYNBU5TomXfHxfrY+EzaZ5MhRDWLMgJwZRv9Xo9xu7kX6
	sm0DjUajnb2K96HsNfSLVWw=
X-Google-Smtp-Source: AGHT+IGqP5ha2GefPzd6nhPOd1or/7UCijKn4fR31Hz8N2Y76X9HTWhK4XFO26V46EyOW2ZKL69/1w==
X-Received: by 2002:a05:6e02:2389:b0:35f:f01a:b141 with SMTP id bq9-20020a056e02238900b0035ff01ab141mr18160295ilb.19.1703860535331;
        Fri, 29 Dec 2023 06:35:35 -0800 (PST)
Received: from met-Virtual-Machine.. ([131.107.159.31])
        by smtp.gmail.com with ESMTPSA id h32-20020a63f920000000b005b9083b81f0sm14773082pgi.36.2023.12.29.06.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Dec 2023 06:35:34 -0800 (PST)
From: meetakshisetiyaoss@gmail.com
To: sfrench@samba.org,
	pc@manguebit.com,
	lsahlber@redhat.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	nspmangalore@gmail.com,
	bharathsm.hsk@gmail.com,
	samba-technical@lists.samba.org
Cc: Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH 1/2] smb: client: reuse file lease key in compound operations
Date: Fri, 29 Dec 2023 09:35:20 -0500
Message-Id: <20231229143521.44880-1-meetakshisetiyaoss@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Meetakshi Setiya <msetiya@microsoft.com>

Currently, when a rename, unlink or set path size compound operation
is requested on a file that has a lot of dirty pages to be written
to the server, we do not send the lease key for these requests. As a
result, the server can assume that this request is from a new client, and
send a lease break notification to the same client, on the same
connection. As a response to the lease break, the client can consume
several credits to write the dirty pages to the server. Depending on the
server's credit grant implementation, the server can stop granting more
credits to this connection, and this can cause a deadlock (which can only
be resolved when the lease timer on the server expires).
One of the problems here is that the client is sending no lease key,
even if it has a lease for the file. This patch fixes the problem by
reusing the existing lease key on the file for rename, unlink and set path
size compound operations so that the client does not break its own lease.

A very trivial example could be a set of commands by a client that
maintains open handle (for write) to a file and then tries to rename
the file, eg.,

tail -f /dev/null > myfile &
mv myfile myfile2

Presently, the network capture on the client shows that the move (or
rename) would trigger a lease break on the same client, for the same file.
With the lease key reused, the lease break request-response overhead is
eliminated, thereby reducing the roundtrips performed for this set of
operations.

This patch provides perf benefit by reusing the lease key for rename,
unlink, and set path size operations. It avoids self-inflicted lease
breaks, reduces roundtrips and prevents potential deadlocks. It
leads to more efficient operations, especially when writing many dirty
pages to the server.

Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
---
 fs/smb/client/cifsglob.h  |  4 +--
 fs/smb/client/cifsproto.h |  4 +--
 fs/smb/client/cifssmb.c   |  4 +--
 fs/smb/client/inode.c     | 10 ++++----
 fs/smb/client/smb2inode.c | 52 ++++++++++++++++++++++++---------------
 fs/smb/client/smb2proto.h |  4 +--
 6 files changed, 45 insertions(+), 33 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 54bc44a5f4c6..8ccfb83ffb53 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -364,7 +364,7 @@ struct smb_version_operations {
 			    struct cifs_open_info_data *data);
 	/* set size by path */
 	int (*set_path_size)(const unsigned int, struct cifs_tcon *,
-			     const char *, __u64, struct cifs_sb_info *, bool);
+			     const char *, __u64, struct cifs_sb_info *, bool, struct dentry *);
 	/* set size by file handle */
 	int (*set_file_size)(const unsigned int, struct cifs_tcon *,
 			     struct cifsFileInfo *, __u64, bool);
@@ -394,7 +394,7 @@ struct smb_version_operations {
 		     struct cifs_sb_info *);
 	/* unlink file */
 	int (*unlink)(const unsigned int, struct cifs_tcon *, const char *,
-		      struct cifs_sb_info *);
+		      struct cifs_sb_info *, struct dentry *);
 	/* open, rename and delete file */
 	int (*rename_pending_delete)(const char *, struct dentry *,
 				     const unsigned int);
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index afbab86331a1..7bf1d04857b0 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -402,7 +402,7 @@ extern int CIFSSMBSetFileDisposition(const unsigned int xid,
 				     __u32 pid_of_opener);
 extern int CIFSSMBSetEOF(const unsigned int xid, struct cifs_tcon *tcon,
 			 const char *file_name, __u64 size,
-			 struct cifs_sb_info *cifs_sb, bool set_allocation);
+			 struct cifs_sb_info *cifs_sb, bool set_allocation, struct dentry *dentry);
 extern int CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon,
 			      struct cifsFileInfo *cfile, __u64 size,
 			      bool set_allocation);
@@ -438,7 +438,7 @@ extern int CIFSPOSIXDelFile(const unsigned int xid, struct cifs_tcon *tcon,
 			const struct nls_table *nls_codepage,
 			int remap_special_chars);
 extern int CIFSSMBDelFile(const unsigned int xid, struct cifs_tcon *tcon,
-			  const char *name, struct cifs_sb_info *cifs_sb);
+			  const char *name, struct cifs_sb_info *cifs_sb, struct dentry *dentry);
 int CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
 		  struct dentry *source_dentry,
 		  const char *from_name, const char *to_name,
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index e9e33b0b3ac4..1941ceb48fb7 100644
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
@@ -4983,7 +4983,7 @@ CIFSSMBQFSPosixInfo(const unsigned int xid, struct cifs_tcon *tcon,
 int
 CIFSSMBSetEOF(const unsigned int xid, struct cifs_tcon *tcon,
 	      const char *file_name, __u64 size, struct cifs_sb_info *cifs_sb,
-	      bool set_allocation)
+	      bool set_allocation, struct dentry *dentry)
 {
 	struct smb_com_transaction2_spi_req *pSMB = NULL;
 	struct smb_com_transaction2_spi_rsp *pSMBr = NULL;
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index c532aa63a658..a71068bda2b4 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1851,7 +1851,7 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 		goto psx_del_no_retry;
 	}
 
-	rc = server->ops->unlink(xid, tcon, full_path, cifs_sb);
+	rc = server->ops->unlink(xid, tcon, full_path, cifs_sb, dentry);
 
 psx_del_no_retry:
 	if (!rc) {
@@ -2802,7 +2802,7 @@ void cifs_setsize(struct inode *inode, loff_t offset)
 
 static int
 cifs_set_file_size(struct inode *inode, struct iattr *attrs,
-		   unsigned int xid, const char *full_path)
+		   unsigned int xid, const char *full_path, struct dentry *dentry)
 {
 	int rc;
 	struct cifsFileInfo *open_file;
@@ -2853,7 +2853,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 	 */
 	if (server->ops->set_path_size)
 		rc = server->ops->set_path_size(xid, tcon, full_path,
-						attrs->ia_size, cifs_sb, false);
+						attrs->ia_size, cifs_sb, false, dentry);
 	else
 		rc = -ENOSYS;
 	cifs_dbg(FYI, "SetEOF by path (setattrs) rc = %d\n", rc);
@@ -2943,7 +2943,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	rc = 0;
 
 	if (attrs->ia_valid & ATTR_SIZE) {
-		rc = cifs_set_file_size(inode, attrs, xid, full_path);
+		rc = cifs_set_file_size(inode, attrs, xid, full_path, direntry);
 		if (rc != 0)
 			goto out;
 	}
@@ -3109,7 +3109,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	}
 
 	if (attrs->ia_valid & ATTR_SIZE) {
-		rc = cifs_set_file_size(inode, attrs, xid, full_path);
+		rc = cifs_set_file_size(inode, attrs, xid, full_path, direntry);
 		if (rc != 0)
 			goto cifs_setattr_exit;
 	}
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 5053a5550abe..446433606a04 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -70,7 +70,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			    __u32 create_options, umode_t mode, struct kvec *in_iov,
 			    int *cmds, int num_cmds, struct cifsFileInfo *cfile,
 			    __u8 **extbuf, size_t *extbuflen,
-			    struct kvec *out_iov, int *out_buftype)
+			    struct kvec *out_iov, int *out_buftype, struct dentry *dentry)
 {
 
 	struct reparse_data_buffer *rbuf;
@@ -87,6 +87,8 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	int resp_buftype[MAX_COMPOUND];
 	struct smb2_query_info_rsp *qi_rsp = NULL;
 	struct cifs_open_info_data *idata;
+	struct inode *inode = NULL;
+	struct cifsInodeInfo *cinode = NULL;
 	int flags = 0;
 	__u8 delete_pending[8] = {1, 0, 0, 0, 0, 0, 0, 0};
 	unsigned int size[2];
@@ -118,6 +120,16 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		goto finished;
 	}
 
+	/* if there is an existing lease, reuse it */
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
@@ -695,7 +707,7 @@ int smb2_query_path_info(const unsigned int xid,
 			      FILE_READ_ATTRIBUTES, FILE_OPEN,
 			      create_options, ACL_NO_MODE,
 			      in_iov, cmds, 1, cfile,
-			      NULL, NULL, out_iov, out_buftype);
+			      NULL, NULL, out_iov, out_buftype, NULL);
 	hdr = out_iov[0].iov_base;
 	/*
 	 * If first iov is unset, then SMB session was dropped or we've got a
@@ -723,7 +735,7 @@ int smb2_query_path_info(const unsigned int xid,
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 				      FILE_READ_ATTRIBUTES, FILE_OPEN,
 				      create_options, ACL_NO_MODE, in_iov, cmds,
-				      num_cmds, cfile, NULL, NULL, NULL, NULL);
+				      num_cmds, cfile, NULL, NULL, NULL, NULL, NULL);
 		break;
 	case -EREMOTE:
 		break;
@@ -783,7 +795,7 @@ int smb311_posix_query_path_info(const unsigned int xid,
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 			      FILE_READ_ATTRIBUTES, FILE_OPEN,
 			      create_options, ACL_NO_MODE, in_iov, cmds, 1,
-			      cfile, &sidsbuf, &sidsbuflen, out_iov, out_buftype);
+			      cfile, &sidsbuf, &sidsbuflen, out_iov, out_buftype, NULL);
 	/*
 	 * If first iov is unset, then SMB session was dropped or we've got a
 	 * cached open file (@cfile).
@@ -811,7 +823,7 @@ int smb311_posix_query_path_info(const unsigned int xid,
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 				      FILE_READ_ATTRIBUTES, FILE_OPEN,
 				      create_options, ACL_NO_MODE, in_iov, cmds,
-				      num_cmds, cfile, &sidsbuf, &sidsbuflen, NULL, NULL);
+				      num_cmds, cfile, &sidsbuf, &sidsbuflen, NULL, NULL, NULL);
 		break;
 	}
 
@@ -850,7 +862,7 @@ smb2_mkdir(const unsigned int xid, struct inode *parent_inode, umode_t mode,
 				FILE_WRITE_ATTRIBUTES, FILE_CREATE,
 				CREATE_NOT_FILE, mode, NULL,
 				&(int){SMB2_OP_MKDIR}, 1,
-				NULL, NULL, NULL, NULL, NULL);
+				NULL, NULL, NULL, NULL, NULL, NULL);
 }
 
 void
@@ -875,7 +887,7 @@ smb2_mkdir_setinfo(struct inode *inode, const char *name,
 				 FILE_WRITE_ATTRIBUTES, FILE_CREATE,
 				 CREATE_NOT_FILE, ACL_NO_MODE, &in_iov,
 				 &(int){SMB2_OP_SET_INFO}, 1,
-				 cfile, NULL, NULL, NULL, NULL);
+				 cfile, NULL, NULL, NULL, NULL, NULL);
 	if (tmprc == 0)
 		cifs_i->cifsAttrs = dosattrs;
 }
@@ -888,24 +900,24 @@ smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	return smb2_compound_op(xid, tcon, cifs_sb, name,
 				DELETE, FILE_OPEN, CREATE_NOT_FILE,
 				ACL_NO_MODE, NULL, &(int){SMB2_OP_RMDIR}, 1,
-				NULL, NULL, NULL, NULL, NULL);
+				NULL, NULL, NULL, NULL, NULL, NULL);
 }
 
 int
 smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
-	    struct cifs_sb_info *cifs_sb)
+	    struct cifs_sb_info *cifs_sb, struct dentry *dentry)
 {
 	return smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
 				CREATE_DELETE_ON_CLOSE | OPEN_REPARSE_POINT,
 				ACL_NO_MODE, NULL, &(int){SMB2_OP_DELETE}, 1,
-				NULL, NULL, NULL, NULL, NULL);
+				NULL, NULL, NULL, NULL, NULL, dentry);
 }
 
 static int smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
 			      const char *from_name, const char *to_name,
 			      struct cifs_sb_info *cifs_sb,
 			      __u32 create_options, __u32 access,
-			      int command, struct cifsFileInfo *cfile)
+			      int command, struct cifsFileInfo *cfile, struct dentry *dentry)
 {
 	struct kvec in_iov;
 	__le16 *smb2_to_name = NULL;
@@ -920,7 +932,7 @@ static int smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	in_iov.iov_len = 2 * UniStrnlen((wchar_t *)smb2_to_name, PATH_MAX);
 	rc = smb2_compound_op(xid, tcon, cifs_sb, from_name, access,
 			      FILE_OPEN, create_options, ACL_NO_MODE, &in_iov,
-			      &command, 1, cfile, NULL, NULL, NULL, NULL);
+			      &command, 1, cfile, NULL, NULL, NULL, NULL, dentry);
 smb2_rename_path:
 	kfree(smb2_to_name);
 	return rc;
@@ -939,7 +951,7 @@ int smb2_rename_path(const unsigned int xid,
 	cifs_get_writable_path(tcon, from_name, FIND_WR_WITH_DELETE, &cfile);
 
 	return smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
-				  co, DELETE, SMB2_OP_RENAME, cfile);
+				  co, DELETE, SMB2_OP_RENAME, cfile, source_dentry);
 }
 
 int smb2_create_hardlink(const unsigned int xid,
@@ -952,13 +964,13 @@ int smb2_create_hardlink(const unsigned int xid,
 
 	return smb2_set_path_attr(xid, tcon, from_name, to_name,
 				  cifs_sb, co, FILE_READ_ATTRIBUTES,
-				  SMB2_OP_HARDLINK, NULL);
+				  SMB2_OP_HARDLINK, NULL, NULL);
 }
 
 int
 smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
 		   const char *full_path, __u64 size,
-		   struct cifs_sb_info *cifs_sb, bool set_alloc)
+		   struct cifs_sb_info *cifs_sb, bool set_alloc, struct dentry *dentry)
 {
 	struct cifsFileInfo *cfile;
 	struct kvec in_iov;
@@ -971,7 +983,7 @@ smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
 				FILE_WRITE_DATA, FILE_OPEN,
 				0, ACL_NO_MODE, &in_iov,
 				&(int){SMB2_OP_SET_EOF}, 1,
-				cfile, NULL, NULL, NULL, NULL);
+				cfile, NULL, NULL, NULL, NULL, dentry);
 }
 
 int
@@ -1000,7 +1012,7 @@ smb2_set_file_info(struct inode *inode, const char *full_path,
 			      FILE_WRITE_ATTRIBUTES, FILE_OPEN,
 			      0, ACL_NO_MODE, &in_iov,
 			      &(int){SMB2_OP_SET_INFO}, 1, cfile,
-			      NULL, NULL, NULL, NULL);
+			      NULL, NULL, NULL, NULL, NULL);
 	cifs_put_tlink(tlink);
 	return rc;
 }
@@ -1035,7 +1047,7 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 				      da, cd, co, ACL_NO_MODE, in_iov,
-				      cmds, 2, cfile, NULL, NULL, NULL, NULL);
+				      cmds, 2, cfile, NULL, NULL, NULL, NULL, NULL);
 		if (!rc) {
 			rc = smb311_posix_get_inode_info(&new, full_path,
 							 data, sb, xid);
@@ -1045,7 +1057,7 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 				      da, cd, co, ACL_NO_MODE, in_iov,
-				      cmds, 2, cfile, NULL, NULL, NULL, NULL);
+				      cmds, 2, cfile, NULL, NULL, NULL, NULL, NULL);
 		if (!rc) {
 			rc = cifs_get_inode_info(&new, full_path,
 						 data, sb, xid, NULL);
@@ -1073,7 +1085,7 @@ int smb2_query_reparse_point(const unsigned int xid,
 			      FILE_READ_ATTRIBUTES, FILE_OPEN,
 			      OPEN_REPARSE_POINT, ACL_NO_MODE, &in_iov,
 			      &(int){SMB2_OP_GET_REPARSE}, 1, cfile,
-			      NULL, NULL, NULL, NULL);
+			      NULL, NULL, NULL, NULL, NULL);
 	if (rc)
 		goto out;
 
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 1e20f87a5f58..c18a262b42f0 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -75,7 +75,7 @@ int smb2_query_path_info(const unsigned int xid,
 			 struct cifs_open_info_data *data);
 extern int smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
 			      const char *full_path, __u64 size,
-			      struct cifs_sb_info *cifs_sb, bool set_alloc);
+			      struct cifs_sb_info *cifs_sb, bool set_alloc, struct dentry *dentry);
 extern int smb2_set_file_info(struct inode *inode, const char *full_path,
 			      FILE_BASIC_INFO *buf, const unsigned int xid);
 extern int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
@@ -91,7 +91,7 @@ extern void smb2_mkdir_setinfo(struct inode *inode, const char *full_path,
 extern int smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon,
 		      const char *name, struct cifs_sb_info *cifs_sb);
 extern int smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon,
-		       const char *name, struct cifs_sb_info *cifs_sb);
+		       const char *name, struct cifs_sb_info *cifs_sb, struct dentry *dentry);
 int smb2_rename_path(const unsigned int xid,
 		     struct cifs_tcon *tcon,
 		     struct dentry *source_dentry,
-- 
2.39.2

