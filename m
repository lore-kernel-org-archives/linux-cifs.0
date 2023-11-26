Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="s+IV2oe0"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118ACAF
	for <linux-cifs@vger.kernel.org>; Sat, 25 Nov 2023 18:55:41 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700967339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9vTkRKHFZaS0yRkAfNkwIigBdnRJPqx9grfqANfp9js=;
	b=s+IV2oe0kpEjebJ8uRcZyDwp3q0EtG50QRK+p85zYJMKzrzbIsH2fwpcFwPGcR5Ul9de9Y
	mtHigkIatH86mRXbcyPuycxxGWRThNT2cziUBmKze/zbMptOYzRQ2yN1YNgjP9lA7n9ASp
	hTLbEgT0z070IUuAYz+zk2l/p/dRGzKqpKhcsj1ELbYX0dkZGjXm7XlLmR5amfpWKuht9z
	1UksnkR7+4PA3YynEyzGJiEcf3kKmj5IGkD+d/GfJuumw4BZGPSaaQeTzEmAF5B96oC9lC
	b9CLDLDE11fU3svllELicyAKHVcSsEXivlODwQ+BdMhGmPJMgSTxeH/3tyH3mQ==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700967339; a=rsa-sha256;
	cv=none;
	b=ZVEdDNMWQuqRDr8E/LRtZmk0gAqe/kX7yQbOWN1RxSKoSp/0BzsjoDX3PjPWRH71iU0qus
	0MCW7UbR418Iq0GB6uQiwXkQxkiafhQQHEgvn6lrEfLuqg65ge8/rUvT3Zc55bB0y0wRZ9
	5D3fZt00Pu6bbCKmygCcUDETAC0w0CTHlVGLTrFqrWspdCHCCwqgk93+L6UzoNgj3fMohL
	nmjBpxmyVU3Z9dCzFXlwM4x93AcFn6IRjQX+LPsiS39y7gL0tu9vGUykLn9bDOSwXKn7+A
	NxyPqV52PZkoycTHzjPiGzhr6DfyIw+LhZHS9WsDKV88/RVsNnxtOB1Tqn6cEA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700967339; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9vTkRKHFZaS0yRkAfNkwIigBdnRJPqx9grfqANfp9js=;
	b=TsXx+M0h5odYhsZZW9gXT+ngtXxQvvz4TVUaUfMhBJ4/wDThn1jhmOF5EH/2WGxItuxnnt
	uuxiji8C9cdJTboWJx4GL46+vevElv7hwXpFerPj+2Wh9ygfZHwhZygVlUL/UWqPXEhiFh
	dbG8SgdE9mMuaEcma0U9bYx0PZ8IokGHK4dgLX26p1mNfO8FplQTCSPoSV9Uou2Izot1o7
	M+XY8Zo8ye5g0wzDLptNAh5ZyQHTcPeA7mIP1hebi6Fw1S+Y7zawOi7QnLUSBKABJ4jL8/
	kn4vnBwoGWSPnEQSAlNQeOFFBqel1Z+fRonUo7RinvlqxhW4rVFEGvll/yOZOg==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH v2 5/9] smb: client: fix renaming of reparse points
Date: Sat, 25 Nov 2023 23:55:06 -0300
Message-ID: <20231126025510.28147-6-pc@manguebit.com>
In-Reply-To: <20231126025510.28147-1-pc@manguebit.com>
References: <20231126025510.28147-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The client was sending an SMB2_CREATE request without setting
OPEN_REPARSE_POINT flag thus failing the entire rename operation.

Fix this by setting OPEN_REPARSE_POINT in create options for
SMB2_CREATE request when the source inode is a repase point.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifsglob.h  | 23 ++++++++++++++----
 fs/smb/client/cifsproto.h |  7 +++---
 fs/smb/client/cifssmb.c   |  8 +++----
 fs/smb/client/inode.c     |  4 +++-
 fs/smb/client/smb2inode.c | 50 +++++++++++++++++++++++----------------
 fs/smb/client/smb2proto.h |  8 ++++---
 6 files changed, 63 insertions(+), 37 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 4a5b2e363b1d..7ceea52058ab 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -210,9 +210,18 @@ struct cifs_open_info_data {
 	};
 };
 
-#define cifs_open_data_reparse(d) \
-	((d)->reparse_point || \
-	 (le32_to_cpu((d)->fi.Attributes) & ATTR_REPARSE))
+static inline bool cifs_open_data_reparse(struct cifs_open_info_data *data)
+{
+	struct smb2_file_all_info *fi = &data->fi;
+	u32 attrs = le32_to_cpu(fi->Attributes);
+	bool ret;
+
+	ret = data->reparse_point || (attrs & ATTR_REPARSE);
+	if (ret)
+		attrs |= ATTR_REPARSE;
+	fi->Attributes = cpu_to_le32(attrs);
+	return ret;
+}
 
 /*
  *****************************************************************
@@ -390,8 +399,11 @@ struct smb_version_operations {
 	int (*rename_pending_delete)(const char *, struct dentry *,
 				     const unsigned int);
 	/* send rename request */
-	int (*rename)(const unsigned int, struct cifs_tcon *, const char *,
-		      const char *, struct cifs_sb_info *);
+	int (*rename)(const unsigned int xid,
+		      struct cifs_tcon *tcon,
+		      struct dentry *source_dentry,
+		      const char *from_name, const char *to_name,
+		      struct cifs_sb_info *cifs_sb);
 	/* send create hardlink request */
 	int (*create_hardlink)(const unsigned int, struct cifs_tcon *,
 			       const char *, const char *,
@@ -1551,6 +1563,7 @@ struct cifsInodeInfo {
 	spinlock_t deferred_lock; /* protection on deferred list */
 	bool lease_granted; /* Flag to indicate whether lease or oplock is granted. */
 	char *symlink_target;
+	bool reparse:1;
 };
 
 static inline struct cifsInodeInfo *
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 4c5d533d98a3..e680fe46d4e8 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -439,9 +439,10 @@ extern int CIFSPOSIXDelFile(const unsigned int xid, struct cifs_tcon *tcon,
 			int remap_special_chars);
 extern int CIFSSMBDelFile(const unsigned int xid, struct cifs_tcon *tcon,
 			  const char *name, struct cifs_sb_info *cifs_sb);
-extern int CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
-			 const char *from_name, const char *to_name,
-			 struct cifs_sb_info *cifs_sb);
+int CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
+		  struct dentry *source_dentry,
+		  const char *from_name, const char *to_name,
+		  struct cifs_sb_info *cifs_sb);
 extern int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *tcon,
 				 int netfid, const char *target_name,
 				 const struct nls_table *nls_codepage,
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index bad91ba6c3a9..43a90e646a7a 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2147,10 +2147,10 @@ CIFSSMBFlush(const unsigned int xid, struct cifs_tcon *tcon, int smb_file_id)
 	return rc;
 }
 
-int
-CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
-	      const char *from_name, const char *to_name,
-	      struct cifs_sb_info *cifs_sb)
+int CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
+		  struct dentry *source_dentry,
+		  const char *from_name, const char *to_name,
+		  struct cifs_sb_info *cifs_sb)
 {
 	int rc = 0;
 	RENAME_REQ *pSMB = NULL;
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index e8c94b62c166..111e60e5e260 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -214,6 +214,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 		cifs_i->symlink_target = fattr->cf_symlink_target;
 		fattr->cf_symlink_target = NULL;
 	}
+	cifs_i->reparse = !!(fattr->cf_cifsattrs & ATTR_REPARSE);
 	spin_unlock(&inode->i_lock);
 
 	if (fattr->cf_flags & CIFS_FATTR_JUNCTION)
@@ -2242,7 +2243,8 @@ cifs_do_rename(const unsigned int xid, struct dentry *from_dentry,
 		return -ENOSYS;
 
 	/* try path-based rename first */
-	rc = server->ops->rename(xid, tcon, from_path, to_path, cifs_sb);
+	rc = server->ops->rename(xid, tcon, from_dentry,
+				 from_path, to_path, cifs_sb);
 
 	/*
 	 * Don't bother with rename by filehandle unless file is busy and
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index e7af1196779f..956f74328860 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -888,11 +888,11 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 				NULL, NULL, NULL, NULL, NULL);
 }
 
-static int
-smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
-		   const char *from_name, const char *to_name,
-		   struct cifs_sb_info *cifs_sb, __u32 access, int command,
-		   struct cifsFileInfo *cfile)
+static int smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
+			      const char *from_name, const char *to_name,
+			      struct cifs_sb_info *cifs_sb,
+			      __u32 create_options, __u32 access,
+			      int command, struct cifsFileInfo *cfile)
 {
 	struct kvec in_iov;
 	__le16 *smb2_to_name = NULL;
@@ -906,35 +906,43 @@ smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	in_iov.iov_base = smb2_to_name;
 	in_iov.iov_len = 2 * UniStrnlen((wchar_t *)smb2_to_name, PATH_MAX);
 	rc = smb2_compound_op(xid, tcon, cifs_sb, from_name, access,
-			      FILE_OPEN, 0, ACL_NO_MODE, &in_iov,
+			      FILE_OPEN, create_options, ACL_NO_MODE, &in_iov,
 			      &command, 1, cfile, NULL, NULL, NULL, NULL);
 smb2_rename_path:
 	kfree(smb2_to_name);
 	return rc;
 }
 
-int
-smb2_rename_path(const unsigned int xid, struct cifs_tcon *tcon,
-		 const char *from_name, const char *to_name,
-		 struct cifs_sb_info *cifs_sb)
+int smb2_rename_path(const unsigned int xid,
+		     struct cifs_tcon *tcon,
+		     struct dentry *source_dentry,
+		     const char *from_name, const char *to_name,
+		     struct cifs_sb_info *cifs_sb)
 {
+	struct cifsInodeInfo *ci;
 	struct cifsFileInfo *cfile;
+	__u32 co = 0;
 
+	if (source_dentry) {
+		ci = CIFS_I(d_inode(source_dentry));
+		if (ci->reparse)
+			co |= OPEN_REPARSE_POINT;
+	}
 	drop_cached_dir_by_name(xid, tcon, from_name, cifs_sb);
 	cifs_get_writable_path(tcon, from_name, FIND_WR_WITH_DELETE, &cfile);
 
-	return smb2_set_path_attr(xid, tcon, from_name, to_name,
-				  cifs_sb, DELETE, SMB2_OP_RENAME, cfile);
-}
-
-int
-smb2_create_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
-		     const char *from_name, const char *to_name,
-		     struct cifs_sb_info *cifs_sb)
-{
 	return smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
-				  FILE_READ_ATTRIBUTES, SMB2_OP_HARDLINK,
-				  NULL);
+				  co, DELETE, SMB2_OP_RENAME, cfile);
+}
+
+int
+smb2_create_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
+		     const char *from_name, const char *to_name,
+		     struct cifs_sb_info *cifs_sb)
+{
+	return smb2_set_path_attr(xid, tcon, from_name, to_name,
+				  cifs_sb, 0, FILE_READ_ATTRIBUTES,
+				  SMB2_OP_HARDLINK, NULL);
 }
 
 int
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index d4b2b339fdc3..5e68ddc7b422 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -86,9 +86,11 @@ extern int smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon,
 		      const char *name, struct cifs_sb_info *cifs_sb);
 extern int smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon,
 		       const char *name, struct cifs_sb_info *cifs_sb);
-extern int smb2_rename_path(const unsigned int xid, struct cifs_tcon *tcon,
-			    const char *from_name, const char *to_name,
-			    struct cifs_sb_info *cifs_sb);
+int smb2_rename_path(const unsigned int xid,
+		     struct cifs_tcon *tcon,
+		     struct dentry *source_dentry,
+		     const char *from_name, const char *to_name,
+		     struct cifs_sb_info *cifs_sb);
 extern int smb2_create_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
 				const char *from_name, const char *to_name,
 				struct cifs_sb_info *cifs_sb);
-- 
2.43.0

