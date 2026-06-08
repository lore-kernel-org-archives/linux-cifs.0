Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F207C325494
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2026 15:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780934354; cv=none; b=eccLoJIPNGnW9B+8BWhfZu7mfbIeoS15T6Q125NdVojqwWtLNineDwBMmUJCDj2N2wLnUPcoOMlv3VQNfJ01j8WeEsZpyFdCAmB+UP1D2AI8i3wlSmq7CHxa7lMnSiN+LD76Z84g2nJb5kIIOa6UDGlliArSBhSP+yKrgdK8yg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780934354; c=relaxed/simple;
	bh=CkD+hgo7ELEAb42XPUvTGbEZx1/cmIaSU0FV/8hMOzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y63xNynPJG1tcdNleZ4mFb1dSqtbK9d9Fv596wnUXR26jGJENbXurpBH+y6WUSv28sVKWjLsgbwWmpd5mR3vRtQI01NOP84DR6HIgOiACS9pgJoTVuj+U5jNVBxePYbzwXePKyAjkneG3aJxIo2+AfYPh/eI4zMIOzJVyBzRzKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OGi+D0Ud; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OGi+D0Ud"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780934351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YJwY2N+5Lb2QrI52432vcHfxYgOsVAa/9f3J1FZ+86U=;
	b=OGi+D0UdeHSfaPu+QqhdsMBqsYmdopC9zpEwn+gpPyMZ14CPE4sOrkGfnS7gBVA0GGGUvd
	/0UeMsoLoQExxbocggrokLZ0q7Hndyr1iXpnSdEp8XXXtBPOyf5QdS/pRslF+XDUITpQro
	C0hz5wSIWSe6f2yRJXgJpk53faj6boA=
From: Huiwen He <huiwen.he@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v2 3/3] smb/client: allow FS_IOC_SETFLAGS to clear compression
Date: Mon,  8 Jun 2026 23:57:31 +0800
Message-ID: <20260608155731.634984-4-huiwen.he@linux.dev>
In-Reply-To: <20260608155731.634984-1-huiwen.he@linux.dev>
References: <20260608155731.634984-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

The CIFS FS_IOC_SETFLAGS path can set FS_COMPR_FL now, but it cannot
clear it again. This can be reproduced on a share backed by a filesystem
that supports compression, for example btrfs exported by Samba:

	[compress_share]
		vfs objects = btrfs

	$ touch test.bin
	$ chattr +c test.bin
	$ lsattr test.bin
	$ chattr -c test.bin

The final chattr -c fails with EOPNOTSUPP, and leaves the remote object
with the compressed attribute still set, because the client always sends
FSCTL_SET_COMPRESSION with COMPRESSION_FORMAT_DEFAULT. That is correct
for setting FS_COMPR_FL, but clearing FS_COMPR_FL requires sending
COMPRESSION_FORMAT_NONE.

Fix this by passing the requested compression state through the
set_compression operation.  The SMB1 and SMB2 helpers no longer hard-code
COMPRESSION_FORMAT_DEFAULT.

When FS_COMPR_FL is set, send COMPRESSION_FORMAT_DEFAULT.  When it is
cleared, send COMPRESSION_FORMAT_NONE.  If the server accepts the request,
update the cached FILE_ATTRIBUTE_COMPRESSED bit under i_lock so
FS_IOC_GETFLAGS reports the new state.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsglob.h  |  2 +-
 fs/smb/client/cifssmb.c   |  4 ++--
 fs/smb/client/ioctl.c     | 43 ++++++++++++++++++++++++++++-----------
 fs/smb/client/smb1ops.c   |  5 +++--
 fs/smb/client/smb1proto.h |  2 +-
 fs/smb/client/smb2ops.c   |  4 ++--
 fs/smb/client/smb2pdu.c   |  6 +++---
 fs/smb/client/smb2proto.h |  3 ++-
 8 files changed, 45 insertions(+), 24 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 943b7cd2c096..a462c1590a9e 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -425,7 +425,7 @@ struct smb_version_operations {
 	int (*set_file_info)(struct inode *, const char *, FILE_BASIC_INFO *,
 			     const unsigned int);
 	int (*set_compression)(const unsigned int, struct cifs_tcon *,
-			       struct cifsFileInfo *);
+			       struct cifsFileInfo *, __u16);
 	/* check if we can send an echo or nor */
 	bool (*can_echo)(struct TCP_Server_Info *);
 	/* send echo request */
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 9e27bfa7376b..d39175cdf1b1 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3207,7 +3207,7 @@ struct inode *cifs_create_reparse_inode(struct cifs_open_info_data *data,
 
 int
 CIFSSMB_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
-		    __u16 fid)
+		    __u16 fid, __u16 compression_state)
 {
 	int rc = 0;
 	int bytes_returned;
@@ -3222,7 +3222,7 @@ CIFSSMB_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 	in_len = rc;
 
-	pSMB->compression_state = cpu_to_le16(COMPRESSION_FORMAT_DEFAULT);
+	pSMB->compression_state = cpu_to_le16(compression_state);
 
 	pSMB->TotalParameterCount = 0;
 	pSMB->TotalDataCount = cpu_to_le32(2);
diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index 886e6893a552..9fa743be3652 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -68,7 +68,8 @@ static long cifs_ioctl_query_info(unsigned int xid, struct file *filep,
 }
 
 static int cifs_set_compression_by_path(unsigned int xid, struct file *filep,
-					struct cifs_tcon *tcon)
+					struct cifs_tcon *tcon,
+					__u16 compression_state)
 {
 	struct inode *inode = file_inode(filep);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
@@ -127,7 +128,8 @@ static int cifs_set_compression_by_path(unsigned int xid, struct file *filep,
 		goto close;
 	}
 
-	rc = server->ops->set_compression(xid, tcon, tmp_cfile);
+	rc = server->ops->set_compression(xid, tcon, tmp_cfile,
+					 compression_state);
 
 close:
 	server->ops->close(xid, tcon, &fid);
@@ -141,7 +143,8 @@ static int cifs_set_compression_by_path(unsigned int xid, struct file *filep,
 
 static int cifs_ioctl_set_compression(unsigned int xid, struct file *filep,
 				      struct cifs_tcon *tcon,
-				      struct cifsFileInfo *cfile)
+				      struct cifsFileInfo *cfile,
+				      __u16 compression_state)
 {
 	struct cifsFileInfo *wfile;
 	struct cifs_tcon *wtcon;
@@ -152,7 +155,8 @@ static int cifs_ioctl_set_compression(unsigned int xid, struct file *filep,
 		return -EOPNOTSUPP;
 
 	if (cfile && (cfile->fid.access & FILE_WRITE_DATA)) {
-		rc = tcon->ses->server->ops->set_compression(xid, tcon, cfile);
+		rc = tcon->ses->server->ops->set_compression(xid, tcon, cfile,
+							       compression_state);
 		if (rc != -EACCES)
 			return rc;
 	}
@@ -160,7 +164,8 @@ static int cifs_ioctl_set_compression(unsigned int xid, struct file *filep,
 	rc = cifs_get_writable_file(CIFS_I(inode), FIND_FSUID_ONLY, &wfile);
 	if (!rc) {
 		wtcon = tlink_tcon(wfile->tlink);
-		rc = wtcon->ses->server->ops->set_compression(xid, wtcon, wfile);
+		rc = wtcon->ses->server->ops->set_compression(xid, wtcon, wfile,
+							       compression_state);
 		cifsFileInfo_put(wfile);
 		if (rc != -EACCES)
 			return rc;
@@ -168,7 +173,8 @@ static int cifs_ioctl_set_compression(unsigned int xid, struct file *filep,
 		return rc;
 	}
 
-	return cifs_set_compression_by_path(xid, filep, tcon);
+	return cifs_set_compression_by_path(xid, filep, tcon,
+					    compression_state);
 }
 
 static long cifs_ioctl_copychunk(unsigned int xid, struct file *dst_file,
@@ -460,6 +466,8 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 	struct tcon_link *tlink;
 	struct cifs_sb_info *cifs_sb;
 	__u64	ExtAttrBits = 0;
+	bool enable_compression;
+	__u16 compression_state;
 #ifdef CONFIG_CIFS_POSIX
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	__u64   caps;
@@ -523,17 +531,28 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 			 *	break;
 			 */
 
-			/* Currently only flag we can set is compressed flag */
-			if ((ExtAttrBits & FS_COMPR_FL) == 0)
+			/* Currently only flag we can set or clear is compressed. */
+			if (ExtAttrBits & ~FS_COMPR_FL) {
+				rc = -EOPNOTSUPP;
 				break;
+			}
+
+			enable_compression = ExtAttrBits & FS_COMPR_FL;
+			compression_state = enable_compression ?
+				COMPRESSION_FORMAT_DEFAULT :
+				COMPRESSION_FORMAT_NONE;
 
-			/* Try to set compress flag */
 			rc = cifs_ioctl_set_compression(xid, filep, tcon,
-							pSMBFile);
+						pSMBFile,
+						compression_state);
 			if (rc == 0) {
 				spin_lock(&inode->i_lock);
-				CIFS_I(inode)->cifsAttrs |=
-					FILE_ATTRIBUTE_COMPRESSED;
+				if (enable_compression)
+					CIFS_I(inode)->cifsAttrs |=
+						FILE_ATTRIBUTE_COMPRESSED;
+				else
+					CIFS_I(inode)->cifsAttrs &=
+						~FILE_ATTRIBUTE_COMPRESSED;
 				spin_unlock(&inode->i_lock);
 			}
 			cifs_dbg(FYI, "set compress flag rc %d\n", rc);
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index e198e3dda917..d34b3d99f6ed 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -1110,9 +1110,10 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 
 static int
 cifs_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
-		   struct cifsFileInfo *cfile)
+		   struct cifsFileInfo *cfile, __u16 compression_state)
 {
-	return CIFSSMB_set_compression(xid, tcon, cfile->fid.netfid);
+	return CIFSSMB_set_compression(xid, tcon, cfile->fid.netfid,
+				       compression_state);
 }
 
 static int
diff --git a/fs/smb/client/smb1proto.h b/fs/smb/client/smb1proto.h
index 5f522d359952..80eaeb3dd2ec 100644
--- a/fs/smb/client/smb1proto.h
+++ b/fs/smb/client/smb1proto.h
@@ -117,7 +117,7 @@ struct inode *cifs_create_reparse_inode(struct cifs_open_info_data *data,
 					struct kvec *reparse_iov,
 					struct kvec *xattr_iov);
 int CIFSSMB_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
-			    __u16 fid);
+			    __u16 fid, __u16 compression_state);
 int cifs_do_get_acl(const unsigned int xid, struct cifs_tcon *tcon,
 		    const unsigned char *searchName, struct posix_acl **acl,
 		    const int acl_type, const struct nls_table *nls_codepage,
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 89230141b5dd..23807023c027 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2246,10 +2246,10 @@ smb2_duplicate_extents(const unsigned int xid,
 
 static int
 smb2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
-		   struct cifsFileInfo *cfile)
+		   struct cifsFileInfo *cfile, __u16 compression_state)
 {
 	return SMB2_set_compression(xid, tcon, cfile->fid.persistent_fid,
-			    cfile->fid.volatile_fid);
+			    cfile->fid.volatile_fid, compression_state);
 }
 
 static int
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index fbeb2156ddb6..6a185b805c1e 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3626,14 +3626,14 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 
 int
 SMB2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
-		     u64 persistent_fid, u64 volatile_fid)
+		     u64 persistent_fid, u64 volatile_fid,
+		     __u16 compression_state)
 {
 	int rc;
 	struct  compress_ioctl fsctl_input;
 	char *ret_data = NULL;
 
-	fsctl_input.CompressionState =
-			cpu_to_le16(COMPRESSION_FORMAT_DEFAULT);
+	fsctl_input.CompressionState = cpu_to_le16(compression_state);
 
 	rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
 			FSCTL_SET_COMPRESSION,
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 1ceb95b907e6..78a4e1c340f9 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -216,7 +216,8 @@ int SMB2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 		u64 persistent_fid, u64 volatile_fid,
 		struct smb2_file_full_ea_info *buf, int len);
 int SMB2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
-			 u64 persistent_fid, u64 volatile_fid);
+			 u64 persistent_fid, u64 volatile_fid,
+			 __u16 compression_state);
 int SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 		      const u64 persistent_fid, const u64 volatile_fid,
 		      __u8 oplock_level);
-- 
2.43.0

