Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF6717BB2A;
	Thu, 22 Aug 2024 08:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724315070; cv=none; b=Hj+6wpMxoevQwinFLs9vwtNL51GkZFWsdictb77laNpxs5NDyW2Fvd3NdFH56cqhZ68mmBl0bQAGHHG3P4R3XwSY9dTDvCh4AqtGadqZQhXub3A1AMQgVcL4pdKWpPLh3gY2HGTz/zaJQG+IySbME8n2rHHpeNEHNCALMuFqazs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724315070; c=relaxed/simple;
	bh=VSXhsG90bDx2M4URZiLyhe8iaXWsNkJM9bcZjXsQu60=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=us4GgV8TaRYFz6YA8SFt+teLtlSed6c4gUBCIeo27K5xJRzmRjM33W1An2w6rW/U18E4brM1z0r2akmViktiVoNOGLiFdwDlGuMUK0qXmNwuu0L/DhljVvM0419mkEsIgqMqthrenn3Kr8iQt8OOxz8ajxmx+roZa/qvYiKXQvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtp78t1724314949t0neo7wc
X-QQ-Originating-IP: JWDVYgB0R2+So7TfIHsVGjRtCuXwEOa+m0l/u3o1eok=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 22 Aug 2024 16:22:25 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 12486457343126941781
From: chenxiaosong@chenxiaosong.com
To: linkinjeon@kernel.org,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com
Cc: chenxiaosong@kylinos.cn,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	chenxiaosong@chenxiaosong.com
Subject: [PATCH v2 06/12] smb/client: rename cifs_ntsd to smb_ntsd
Date: Thu, 22 Aug 2024 08:20:55 +0000
Message-Id: <20240822082101.391272-7-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com>
References: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Preparation for moving acl definitions to new common header file.

Use the following shell command to rename:

  find fs/smb/client -type f -exec sed -i \
    's/struct cifs_ntsd/struct smb_ntsd/g' {} +

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsacl.c   | 36 ++++++++++++++++++------------------
 fs/smb/client/cifsacl.h   |  6 +++---
 fs/smb/client/cifsglob.h  |  6 +++---
 fs/smb/client/cifsproto.h | 10 +++++-----
 fs/smb/client/cifssmb.c   |  6 +++---
 fs/smb/client/smb2ops.c   | 14 +++++++-------
 fs/smb/client/smb2pdu.c   |  2 +-
 fs/smb/client/smb2proto.h |  2 +-
 fs/smb/client/xattr.c     |  4 ++--
 9 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index f5b6df82e857..3f7657475cd9 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -515,8 +515,8 @@ exit_cifs_idmap(void)
 }
 
 /* copy ntsd, owner sid, and group sid from a security descriptor to another */
-static __u32 copy_sec_desc(const struct cifs_ntsd *pntsd,
-				struct cifs_ntsd *pnntsd,
+static __u32 copy_sec_desc(const struct smb_ntsd *pntsd,
+				struct smb_ntsd *pnntsd,
 				__u32 sidsoffset,
 				struct cifs_sid *pownersid,
 				struct cifs_sid *pgrpsid)
@@ -527,7 +527,7 @@ static __u32 copy_sec_desc(const struct cifs_ntsd *pntsd,
 	/* copy security descriptor control portion */
 	pnntsd->revision = pntsd->revision;
 	pnntsd->type = pntsd->type;
-	pnntsd->dacloffset = cpu_to_le32(sizeof(struct cifs_ntsd));
+	pnntsd->dacloffset = cpu_to_le32(sizeof(struct smb_ntsd));
 	pnntsd->sacloffset = 0;
 	pnntsd->osidoffset = cpu_to_le32(sidsoffset);
 	pnntsd->gsidoffset = cpu_to_le32(sidsoffset + sizeof(struct cifs_sid));
@@ -1191,7 +1191,7 @@ static int parse_sid(struct cifs_sid *psid, char *end_of_acl)
 
 /* Convert CIFS ACL to POSIX form */
 static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
-		struct cifs_ntsd *pntsd, int acl_len, struct cifs_fattr *fattr,
+		struct smb_ntsd *pntsd, int acl_len, struct cifs_fattr *fattr,
 		bool get_mode_from_special_sid)
 {
 	int rc = 0;
@@ -1249,7 +1249,7 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 }
 
 /* Convert permission bits from mode to equivalent CIFS ACL */
-static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
+static int build_sec_desc(struct smb_ntsd *pntsd, struct smb_ntsd *pnntsd,
 	__u32 secdesclen, __u32 *pnsecdesclen, __u64 *pnmode, kuid_t uid, kgid_t gid,
 	bool mode_from_sid, bool id_from_sid, int *aclflag)
 {
@@ -1279,7 +1279,7 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 			le32_to_cpu(pntsd->gsidoffset));
 
 	if (pnmode && *pnmode != NO_CHANGE_64) { /* chmod */
-		ndacloffset = sizeof(struct cifs_ntsd);
+		ndacloffset = sizeof(struct smb_ntsd);
 		ndacl_ptr = (struct cifs_acl *)((char *)pnntsd + ndacloffset);
 		ndacl_ptr->revision =
 			dacloffset ? dacl_ptr->revision : cpu_to_le16(ACL_REVISION);
@@ -1297,7 +1297,7 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 
 		*aclflag |= CIFS_ACL_DACL;
 	} else {
-		ndacloffset = sizeof(struct cifs_ntsd);
+		ndacloffset = sizeof(struct smb_ntsd);
 		ndacl_ptr = (struct cifs_acl *)((char *)pnntsd + ndacloffset);
 		ndacl_ptr->revision =
 			dacloffset ? dacl_ptr->revision : cpu_to_le16(ACL_REVISION);
@@ -1385,11 +1385,11 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 }
 
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-struct cifs_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
+struct smb_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
 				      const struct cifs_fid *cifsfid, u32 *pacllen,
 				      u32 __maybe_unused unused)
 {
-	struct cifs_ntsd *pntsd = NULL;
+	struct smb_ntsd *pntsd = NULL;
 	unsigned int xid;
 	int rc;
 	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
@@ -1410,10 +1410,10 @@ struct cifs_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
 	return pntsd;
 }
 
-static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
+static struct smb_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
 		const char *path, u32 *pacllen)
 {
-	struct cifs_ntsd *pntsd = NULL;
+	struct smb_ntsd *pntsd = NULL;
 	int oplock = 0;
 	unsigned int xid;
 	int rc;
@@ -1454,11 +1454,11 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
 }
 
 /* Retrieve an ACL from the server */
-struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *cifs_sb,
+struct smb_ntsd *get_cifs_acl(struct cifs_sb_info *cifs_sb,
 				      struct inode *inode, const char *path,
 			       u32 *pacllen, u32 info)
 {
-	struct cifs_ntsd *pntsd = NULL;
+	struct smb_ntsd *pntsd = NULL;
 	struct cifsFileInfo *open_file = NULL;
 
 	if (inode)
@@ -1472,7 +1472,7 @@ struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *cifs_sb,
 }
 
  /* Set an ACL on the server */
-int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
+int set_cifs_acl(struct smb_ntsd *pnntsd, __u32 acllen,
 			struct inode *inode, const char *path, int aclflag)
 {
 	int oplock = 0;
@@ -1528,7 +1528,7 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
 		  struct inode *inode, bool mode_from_special_sid,
 		  const char *path, const struct cifs_fid *pfid)
 {
-	struct cifs_ntsd *pntsd = NULL;
+	struct smb_ntsd *pntsd = NULL;
 	u32 acllen = 0;
 	int rc = 0;
 	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
@@ -1581,8 +1581,8 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 	__u32 nsecdesclen = 0;
 	__u32 dacloffset = 0;
 	struct cifs_acl *dacl_ptr = NULL;
-	struct cifs_ntsd *pntsd = NULL; /* acl obtained from server */
-	struct cifs_ntsd *pnntsd = NULL; /* modified acl to be sent to server */
+	struct smb_ntsd *pntsd = NULL; /* acl obtained from server */
+	struct smb_ntsd *pnntsd = NULL; /* modified acl to be sent to server */
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
 	struct smb_version_operations *ops;
@@ -1630,7 +1630,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 			nsecdesclen += 5 * sizeof(struct cifs_ace);
 	} else { /* chown */
 		/* When ownership changes, changes new owner sid length could be different */
-		nsecdesclen = sizeof(struct cifs_ntsd) + (sizeof(struct cifs_sid) * 2);
+		nsecdesclen = sizeof(struct smb_ntsd) + (sizeof(struct cifs_sid) * 2);
 		dacloffset = le32_to_cpu(pntsd->dacloffset);
 		if (dacloffset) {
 			dacl_ptr = (struct cifs_acl *)((char *)pntsd + dacloffset);
diff --git a/fs/smb/client/cifsacl.h b/fs/smb/client/cifsacl.h
index ccbfc754bd3c..1516545d7f67 100644
--- a/fs/smb/client/cifsacl.h
+++ b/fs/smb/client/cifsacl.h
@@ -33,7 +33,7 @@
  * Security Descriptor length containing DACL with 3 ACEs (one each for
  * owner, group and world).
  */
-#define DEFAULT_SEC_DESC_LEN (sizeof(struct cifs_ntsd) + \
+#define DEFAULT_SEC_DESC_LEN (sizeof(struct smb_ntsd) + \
 			      sizeof(struct cifs_acl) + \
 			      (sizeof(struct cifs_ace) * 4))
 
@@ -55,7 +55,7 @@
 #define SID_STRING_BASE_SIZE (2 + 3 + 15 + 1)
 #define SID_STRING_SUBAUTH_SIZE (11) /* size of a single subauth string */
 
-struct cifs_ntsd {
+struct smb_ntsd {
 	__le16 revision; /* revision level */
 	__le16 type;
 	__le32 osidoffset;
@@ -194,6 +194,6 @@ struct owner_group_sids {
  * Minimum security descriptor can be one without any SACL and DACL and can
  * consist of revision, type, and two sids of minimum size for owner and group
  */
-#define MIN_SEC_DESC_LEN  (sizeof(struct cifs_ntsd) + (2 * MIN_SID_LEN))
+#define MIN_SEC_DESC_LEN  (sizeof(struct smb_ntsd) + (2 * MIN_SID_LEN))
 
 #endif /* _CIFSACL_H */
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 7ebe80a25d04..2a72129236fb 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -537,11 +537,11 @@ struct smb_version_operations {
 	int (*set_EA)(const unsigned int, struct cifs_tcon *, const char *,
 			const char *, const void *, const __u16,
 			const struct nls_table *, struct cifs_sb_info *);
-	struct cifs_ntsd * (*get_acl)(struct cifs_sb_info *, struct inode *,
+	struct smb_ntsd * (*get_acl)(struct cifs_sb_info *, struct inode *,
 			const char *, u32 *, u32);
-	struct cifs_ntsd * (*get_acl_by_fid)(struct cifs_sb_info *,
+	struct smb_ntsd * (*get_acl_by_fid)(struct cifs_sb_info *,
 			const struct cifs_fid *, u32 *, u32);
-	int (*set_acl)(struct cifs_ntsd *, __u32, struct inode *, const char *,
+	int (*set_acl)(struct smb_ntsd *, __u32, struct inode *, const char *,
 			int);
 	/* writepages retry size */
 	unsigned int (*wp_retry_size)(struct inode *);
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 497bf3c447bc..36d51d57b6f4 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -233,15 +233,15 @@ extern int cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
 			      const char *path, const struct cifs_fid *pfid);
 extern int id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 					kuid_t uid, kgid_t gid);
-extern struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *, struct inode *,
+extern struct smb_ntsd *get_cifs_acl(struct cifs_sb_info *, struct inode *,
 				      const char *, u32 *, u32);
-extern struct cifs_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *,
+extern struct smb_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *,
 				const struct cifs_fid *, u32 *, u32);
 extern struct posix_acl *cifs_get_acl(struct mnt_idmap *idmap,
 				      struct dentry *dentry, int type);
 extern int cifs_set_acl(struct mnt_idmap *idmap,
 			struct dentry *dentry, struct posix_acl *acl, int type);
-extern int set_cifs_acl(struct cifs_ntsd *, __u32, struct inode *,
+extern int set_cifs_acl(struct smb_ntsd *, __u32, struct inode *,
 				const char *, int);
 extern unsigned int setup_authusers_ACE(struct cifs_ace *pace);
 extern unsigned int setup_special_mode_ACE(struct cifs_ace *pace, __u64 nmode);
@@ -570,9 +570,9 @@ extern int CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 		const struct nls_table *nls_codepage,
 		struct cifs_sb_info *cifs_sb);
 extern int CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon,
-			__u16 fid, struct cifs_ntsd **acl_inf, __u32 *buflen);
+			__u16 fid, struct smb_ntsd **acl_inf, __u32 *buflen);
 extern int CIFSSMBSetCIFSACL(const unsigned int, struct cifs_tcon *, __u16,
-			struct cifs_ntsd *, __u32, int);
+			struct smb_ntsd *, __u32, int);
 extern int cifs_do_get_acl(const unsigned int xid, struct cifs_tcon *tcon,
 			   const unsigned char *searchName,
 			   struct posix_acl **acl, const int acl_type,
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 595c4b673707..188c1e1fd316 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3391,7 +3391,7 @@ validate_ntransact(char *buf, char **ppparm, char **ppdata,
 /* Get Security Descriptor (by handle) from remote server for a file or dir */
 int
 CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
-		  struct cifs_ntsd **acl_inf, __u32 *pbuflen)
+		  struct smb_ntsd **acl_inf, __u32 *pbuflen)
 {
 	int rc = 0;
 	int buf_type = 0;
@@ -3461,7 +3461,7 @@ CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
 
 		/* check if buffer is big enough for the acl
 		   header followed by the smallest SID */
-		if ((*pbuflen < sizeof(struct cifs_ntsd) + 8) ||
+		if ((*pbuflen < sizeof(struct smb_ntsd) + 8) ||
 		    (*pbuflen >= 64 * 1024)) {
 			cifs_dbg(VFS, "bad acl length %d\n", *pbuflen);
 			rc = -EINVAL;
@@ -3481,7 +3481,7 @@ CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
 
 int
 CIFSSMBSetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
-			struct cifs_ntsd *pntsd, __u32 acllen, int aclflag)
+			struct smb_ntsd *pntsd, __u32 acllen, int aclflag)
 {
 	__u16 byte_count, param_count, data_count, param_offset, data_offset;
 	int rc = 0;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 322cabc69c6f..b7e33b28d272 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3046,11 +3046,11 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 	return rc;
 }
 
-static struct cifs_ntsd *
+static struct smb_ntsd *
 get_smb2_acl_by_fid(struct cifs_sb_info *cifs_sb,
 		    const struct cifs_fid *cifsfid, u32 *pacllen, u32 info)
 {
-	struct cifs_ntsd *pntsd = NULL;
+	struct smb_ntsd *pntsd = NULL;
 	unsigned int xid;
 	int rc = -EOPNOTSUPP;
 	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
@@ -3075,11 +3075,11 @@ get_smb2_acl_by_fid(struct cifs_sb_info *cifs_sb,
 
 }
 
-static struct cifs_ntsd *
+static struct smb_ntsd *
 get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
 		     const char *path, u32 *pacllen, u32 info)
 {
-	struct cifs_ntsd *pntsd = NULL;
+	struct smb_ntsd *pntsd = NULL;
 	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	unsigned int xid;
 	int rc;
@@ -3142,7 +3142,7 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
 }
 
 static int
-set_smb2_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
+set_smb2_acl(struct smb_ntsd *pnntsd, __u32 acllen,
 		struct inode *inode, const char *path, int aclflag)
 {
 	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
@@ -3200,12 +3200,12 @@ set_smb2_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 }
 
 /* Retrieve an ACL from the server */
-static struct cifs_ntsd *
+static struct smb_ntsd *
 get_smb2_acl(struct cifs_sb_info *cifs_sb,
 	     struct inode *inode, const char *path,
 	     u32 *pacllen, u32 info)
 {
-	struct cifs_ntsd *pntsd = NULL;
+	struct smb_ntsd *pntsd = NULL;
 	struct cifsFileInfo *open_file = NULL;
 
 	if (inode && !(info & SACL_SECINFO))
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 83facb54276a..bb82b295f1d4 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5674,7 +5674,7 @@ SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 int
 SMB2_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
 		u64 persistent_fid, u64 volatile_fid,
-		struct cifs_ntsd *pnntsd, int pacllen, int aclflag)
+		struct smb_ntsd *pnntsd, int pacllen, int aclflag)
 {
 	return send_set_info(xid, tcon, persistent_fid, volatile_fid,
 			current->tgid, 0, SMB2_O_INFO_SECURITY, aclflag,
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index b208232b12a2..c7e1b149877a 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -238,7 +238,7 @@ extern int SMB2_set_info_init(struct cifs_tcon *tcon,
 extern void SMB2_set_info_free(struct smb_rqst *rqst);
 extern int SMB2_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
 			u64 persistent_fid, u64 volatile_fid,
-			struct cifs_ntsd *pnntsd, int pacllen, int aclflag);
+			struct smb_ntsd *pnntsd, int pacllen, int aclflag);
 extern int SMB2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 		       u64 persistent_fid, u64 volatile_fid,
 		       struct smb2_file_full_ea_info *buf, int len);
diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
index 6780aa3e98a1..58a584f0b27e 100644
--- a/fs/smb/client/xattr.c
+++ b/fs/smb/client/xattr.c
@@ -162,7 +162,7 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 	case XATTR_CIFS_ACL:
 	case XATTR_CIFS_NTSD:
 	case XATTR_CIFS_NTSD_FULL: {
-		struct cifs_ntsd *pacl;
+		struct smb_ntsd *pacl;
 
 		if (!value)
 			goto out;
@@ -315,7 +315,7 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 		 * fetch owner and DACL otherwise
 		 */
 		u32 acllen, extra_info;
-		struct cifs_ntsd *pacl;
+		struct smb_ntsd *pacl;
 
 		if (pTcon->ses->server->ops->get_acl == NULL)
 			goto out; /* rc already EOPNOTSUPP */
-- 
2.34.1

