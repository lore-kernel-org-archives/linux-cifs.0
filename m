Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF31270575
	for <linux-cifs@vger.kernel.org>; Sun,  2 Nov 2025 07:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762068776; cv=none; b=hrZUpvLNQoI4Zdi5lSWcWuKl6gOGQGsMHMHFgB/twWPI8feHhrNZ8QbMP1vBNc4cd7a3GucF2xOibNA72pji1/vTelj+puQ1/oETkq1laNuZsdlPjvM6enUsDalDH9qEjKZFGgSzQojOmDsbeyBu8j6DPkyofLa90ErPOCYYfkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762068776; c=relaxed/simple;
	bh=ZToxbSB1MZkyOG2yrD/6qOPPKmik2SLu3xK4XhDo8Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNUmnd/+WzVBDOHl2zoCv1PAMTLSv3NvnsY458K4atzUFiQ/F2cvu6tXF1lDokfvsWNJV1AQuCwpnpkD92ugPSXt5/9MCElJBB2wds1OYRgAoDT4RmbQUd8JmLgph2iLC87kUzTEDc/Qqe8H2GwNHzydimqR6RqaUi/UqQ6A2DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o3Xl2LNU; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o3Xl2LNU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762068773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aQYpgFdtrKR79GKUD4OULuzRB+7PaS9gHAwG2epxgaQ=;
	b=o3Xl2LNU6kMItIcBCRa7A0v24WB2SBUG/R1g+Z62xlZzXWNEVxd4ysA75t7LJwSZbF7EVx
	68AEZq7HYmnm7CGmU8wUD0OGu6y7URF4xt8w0F1UmtYjedp6OkMdZwKZyXDIsY5ez03vmx
	CKQOV+lzbcUTxd2kCFXZCruoFybMnHE=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v5 13/14] smb: do some cleanups
Date: Sun,  2 Nov 2025 15:30:58 +0800
Message-ID: <20251102073059.3681026-14-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Modify the following places:

  - Add documentation references
  - ATTR_REPARSE -> ATTR_REPARSE_POINT: consistent with MS-SMB 2.2.1.2.1
  - Remove unused File Attribute flags from server, if the server uses
    them in the future, we can move the client-side definitions to common
  - Remove unused SMB1_CLIENT_GUID_SIZE from server

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 51 +++++++++++++++++++++-----------------
 fs/smb/client/readdir.c    | 10 ++++----
 fs/smb/client/reparse.h    |  8 +++---
 fs/smb/client/smb1ops.c    |  2 +-
 fs/smb/client/smb2inode.c  |  2 +-
 fs/smb/server/smb_common.h | 19 +++++---------
 6 files changed, 45 insertions(+), 47 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 2c454e450dfa..37e78ec47574 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -19,6 +19,7 @@
 #define BAD_PROT 0xFFFF
 
 /* SMB command codes:
+ * See MS-CIFS 2.2.2.1
  * Note some commands have minimal (wct=0,bcc=0), or uninteresting, responses
  * (ie which include no useful data other than the SMB error code itself).
  * This can allow us to avoid response buffer allocations and copy in some cases
@@ -152,6 +153,7 @@
 
 /*
  * SMB flag definitions
+ * See MS-CIFS 2.2.3.1
  */
 #define SMBFLG_EXTD_LOCK 0x01	/* server supports lock-read write-unlock smb */
 #define SMBFLG_RCV_POSTED 0x02	/* obsolete */
@@ -165,6 +167,8 @@
 
 /*
  * SMB flag2 definitions
+ * See MS-CIFS 2.2.3.1
+ *     MS-SMB 2.2.3.1
  */
 #define SMBFLG2_KNOWS_LONG_NAMES cpu_to_le16(1)	/* can send long (non-8.3)
 						   path names in response */
@@ -225,29 +229,30 @@
 /*
  * File Attribute flags
  */
-#define ATTR_READONLY  0x0001
-#define ATTR_HIDDEN    0x0002
-#define ATTR_SYSTEM    0x0004
-#define ATTR_VOLUME    0x0008
-#define ATTR_DIRECTORY 0x0010
-#define ATTR_ARCHIVE   0x0020
-#define ATTR_DEVICE    0x0040
-#define ATTR_NORMAL    0x0080
-#define ATTR_TEMPORARY 0x0100
-#define ATTR_SPARSE    0x0200
-#define ATTR_REPARSE   0x0400
-#define ATTR_COMPRESSED 0x0800
-#define ATTR_OFFLINE    0x1000	/* ie file not immediately available -
-					on offline storage */
-#define ATTR_NOT_CONTENT_INDEXED 0x2000
-#define ATTR_ENCRYPTED  0x4000
-#define ATTR_POSIX_SEMANTICS 0x01000000
-#define ATTR_BACKUP_SEMANTICS 0x02000000
-#define ATTR_DELETE_ON_CLOSE 0x04000000
-#define ATTR_SEQUENTIAL_SCAN 0x08000000
-#define ATTR_RANDOM_ACCESS   0x10000000
-#define ATTR_NO_BUFFERING    0x20000000
-#define ATTR_WRITE_THROUGH   0x80000000
+#define ATTR_READONLY		0x0001		/* See MS-CIFS 2.2.1.2.3 */
+#define ATTR_HIDDEN		0x0002		/* See MS-CIFS 2.2.1.2.3 */
+#define ATTR_SYSTEM		0x0004		/* See MS-CIFS 2.2.1.2.3 */
+#define ATTR_VOLUME		0x0008
+#define ATTR_DIRECTORY		0x0010		/* See MS-CIFS 2.2.1.2.3 */
+#define ATTR_ARCHIVE		0x0020		/* See MS-CIFS 2.2.1.2.3 */
+#define ATTR_DEVICE		0x0040
+#define ATTR_NORMAL		0x0080		/* See MS-CIFS 2.2.1.2.3 */
+#define ATTR_TEMPORARY		0x0100		/* See MS-CIFS 2.2.1.2.3 */
+#define ATTR_SPARSE		0x0200		/* See MS-SMB 2.2.1.2.1 */
+#define ATTR_REPARSE_POINT	0x0400		/* See MS-SMB 2.2.1.2.1 */
+#define ATTR_COMPRESSED		0x0800		/* See MS-CIFS 2.2.1.2.3 */
+#define ATTR_OFFLINE		0x1000		/* See MS-SMB 2.2.1.2.1
+						   ie file not immediately available -
+						   on offline storage */
+#define ATTR_NOT_CONTENT_INDEXED 0x2000		/* See MS-SMB 2.2.1.2.1 */
+#define ATTR_ENCRYPTED		0x4000		/* See MS-SMB 2.2.1.2.1 */
+#define ATTR_POSIX_SEMANTICS	0x0100000	/* See MS-CIFS 2.2.1.2.3 */
+#define ATTR_BACKUP_SEMANTICS	0x0200000	/* See MS-CIFS 2.2.1.2.3 */
+#define ATTR_DELETE_ON_CLOSE	0x0400000	/* See MS-CIFS 2.2.1.2.3 */
+#define ATTR_SEQUENTIAL_SCAN	0x0800000	/* See MS-CIFS 2.2.1.2.3 */
+#define ATTR_RANDOM_ACCESS	0x1000000	/* See MS-CIFS 2.2.1.2.3 */
+#define ATTR_NO_BUFFERING	0x2000000	/* See MS-CIFS 2.2.1.2.3 */
+#define ATTR_WRITE_THROUGH	0x8000000	/* See MS-CIFS 2.2.1.2.3 */
 
 /* ShareAccess flags */
 #define FILE_NO_SHARE     0x00000000
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 2fd95c1e91ab..7ff728503ed1 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -98,7 +98,7 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 			default:
 				break;
 			}
-		} else if (fattr->cf_cifsattrs & ATTR_REPARSE) {
+		} else if (fattr->cf_cifsattrs & ATTR_REPARSE_POINT) {
 			reparse_need_reval = true;
 		}
 
@@ -138,7 +138,7 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 				 * reparse tag and ctime haven't changed.
 				 */
 				rc = 0;
-				if (fattr->cf_cifsattrs & ATTR_REPARSE) {
+				if (fattr->cf_cifsattrs & ATTR_REPARSE_POINT) {
 					if (likely(reparse_inode_match(inode, fattr))) {
 						fattr->cf_mode = inode->i_mode;
 						fattr->cf_rdev = inode->i_rdev;
@@ -190,7 +190,7 @@ cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
 	 * TODO: go through all documented  reparse tags to see if we can
 	 * reasonably map some of them to directories vs. files vs. symlinks
 	 */
-	if ((fattr->cf_cifsattrs & ATTR_REPARSE) &&
+	if ((fattr->cf_cifsattrs & ATTR_REPARSE_POINT) &&
 	    cifs_reparse_point_to_fattr(cifs_sb, fattr, &data))
 		goto out_reparse;
 
@@ -258,7 +258,7 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 	fattr->cf_nlink = le32_to_cpu(info->HardLinks);
 	fattr->cf_cifsattrs = le32_to_cpu(info->DosAttributes);
 
-	if (fattr->cf_cifsattrs & ATTR_REPARSE)
+	if (fattr->cf_cifsattrs & ATTR_REPARSE_POINT)
 		fattr->cf_cifstag = le32_to_cpu(info->ReparseTag);
 
 	/* The Mode field in the response can now include the file type as well */
@@ -316,7 +316,7 @@ static void cifs_fulldir_info_to_fattr(struct cifs_fattr *fattr,
 	__dir_info_to_fattr(fattr, info);
 
 	/* See MS-FSCC 2.4.14, 2.4.19 */
-	if (fattr->cf_cifsattrs & ATTR_REPARSE)
+	if (fattr->cf_cifsattrs & ATTR_REPARSE_POINT)
 		fattr->cf_cifstag = le32_to_cpu(di->EaSize);
 	cifs_fill_common_info(fattr, cifs_sb);
 }
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index 66269c10beba..19caab2fd11e 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -93,7 +93,7 @@ static inline bool reparse_inode_match(struct inode *inode,
 	if (cinode->reparse_tag != IO_REPARSE_TAG_INTERNAL &&
 	    cinode->reparse_tag != fattr->cf_cifstag)
 		return false;
-	return (cinode->cifsAttrs & ATTR_REPARSE) &&
+	return (cinode->cifsAttrs & ATTR_REPARSE_POINT) &&
 		timespec64_equal(&ctime, &fattr->cf_ctime);
 }
 
@@ -107,7 +107,7 @@ static inline bool cifs_open_data_reparse(struct cifs_open_info_data *data)
 
 		attrs = le32_to_cpu(fi->DosAttributes);
 		if (data->reparse_point) {
-			attrs |= ATTR_REPARSE;
+			attrs |= ATTR_REPARSE_POINT;
 			fi->DosAttributes = cpu_to_le32(attrs);
 		}
 
@@ -116,12 +116,12 @@ static inline bool cifs_open_data_reparse(struct cifs_open_info_data *data)
 
 		attrs = le32_to_cpu(fi->Attributes);
 		if (data->reparse_point) {
-			attrs |= ATTR_REPARSE;
+			attrs |= ATTR_REPARSE_POINT;
 			fi->Attributes = cpu_to_le32(attrs);
 		}
 	}
 
-	ret = attrs & ATTR_REPARSE;
+	ret = attrs & ATTR_REPARSE_POINT;
 
 	return ret;
 }
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index ca8f3dd7ff63..a15ebd3f0d50 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -647,7 +647,7 @@ static int cifs_query_path_info(const unsigned int xid,
 
 	if (!rc) {
 		move_cifs_info_to_smb2(&data->fi, &fi);
-		data->reparse_point = le32_to_cpu(fi.Attributes) & ATTR_REPARSE;
+		data->reparse_point = le32_to_cpu(fi.Attributes) & ATTR_REPARSE_POINT;
 	}
 
 #ifdef CONFIG_CIFS_XATTR
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 09e3fc81d7cb..b5ae07734b7e 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -50,7 +50,7 @@ static inline __u32 file_create_options(struct dentry *dentry)
 
 	if (dentry) {
 		ci = CIFS_I(d_inode(dentry));
-		if (ci->cifsAttrs & ATTR_REPARSE)
+		if (ci->cifsAttrs & ATTR_REPARSE_POINT)
 			return OPEN_REPARSE_POINT;
 	}
 	return 0;
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index afeba063cc27..6c1607b43eb3 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -38,17 +38,6 @@
 #define F_CREATED	2
 #define F_OVERWRITTEN	3
 
-/*
- * File Attribute flags
- */
-#define ATTR_POSIX_SEMANTICS		0x01000000
-#define ATTR_BACKUP_SEMANTICS		0x02000000
-#define ATTR_DELETE_ON_CLOSE		0x04000000
-#define ATTR_SEQUENTIAL_SCAN		0x08000000
-#define ATTR_RANDOM_ACCESS		0x10000000
-#define ATTR_NO_BUFFERING		0x20000000
-#define ATTR_WRITE_THROUGH		0x80000000
-
 /* Combinations of file access permission bits */
 #define SET_FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA \
 		| FILE_READ_ATTRIBUTES \
@@ -80,11 +69,15 @@
 		FILE_EXECUTE | FILE_DELETE_CHILD | \
 		FILE_READ_ATTRIBUTES | FILE_WRITE_ATTRIBUTES)
 
-#define SMB_COM_NEGOTIATE		0x72
-#define SMB1_CLIENT_GUID_SIZE		(16)
+#define SMB_COM_NEGOTIATE		0x72 /* See MS-CIFS 2.2.2.1 */
 
+/* See MS-CIFS 2.2.3.1 */
 #define SMBFLG_RESPONSE 0x80	/* this PDU is a response from server */
 
+/*
+ * See MS-CIFS 2.2.3.1
+ *     MS-SMB 2.2.3.1
+ */
 #define SMBFLG2_IS_LONG_NAME	cpu_to_le16(0x40)
 #define SMBFLG2_EXT_SEC		cpu_to_le16(0x800)
 #define SMBFLG2_ERR_STATUS	cpu_to_le16(0x4000)
-- 
2.43.0

