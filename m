Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A5C437845;
	Mon,  7 Sep 2026 21:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788816997; cv=none; b=C155aZxcvBuKvzxBjIRwAlpdG1t8zKI3gT4pKpnZO5qP3WM8wshNxffvuFTHikD4oc5eiuPhKynvsr0DwQX0UGe6b39AQeWy6n+aBMdUrOOZt9SNuViVLuoUjI7OqfzKDEF+c75zFWyQmyZguaHQubIGhMUBj1yLtvGc+WgCCXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788816997; c=relaxed/simple;
	bh=GfBVyUF+LcLj4eFJGY9Go1BHP5xIQUauDedNg2G2uVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nwck/ueg396dbeFbgrvdpferTbKTyhhtlP0PjSgXWAFxZOlsSK2xnLg3hbbZIqr9GKdZ15xZlTUZGwIyUK0sHFsvFAqwCcDFPKML2XvUNA6G4eHYngK5eCvSWJ7ABoNqFSoPnt/Q5xkjRiHnQKFi4/hQxvFOUtXlNmtOFyNeh7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bXVFMvek; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bXVFMvek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F7D1F00A3F;
	Mon,  7 Sep 2026 21:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788816995;
	bh=rDFO+CGdWtJ4KH3d1i6OO355smXKE/XVV0W3L/3U3sM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bXVFMvekKHEGqeckX93o8A+n/bjshjn9qvNHjOUzGOzVMK81WpCbJJsW0v5gvJwR3
	 R0Fobqb1Si7/dzOPBa7b+6rjBfM0rXxcgDCgsEjrtoiiLLGh33lwUTcvnKQCQ1l5w2
	 OgiX8fNIQVRWPbel+cAQO+m6K8uPAPDckVCrmiDQVGDWkBG72FU3tL9d7UFHhQxIVl
	 en44MKN7UceMVhO5KhremuKvb0pAu+BruhkdgxJ7QitMq4Yo217nIvfoQrdwYXapy3
	 7IgVciwsyAh5CYL+i/uaaVdudqSWepsCO0g3ublNnisJBVYB3R+GmY6GcUfYX8ULCb
	 /qt9DdEGhjsoQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6.y 3/4] cifs: SMB1 split: connect.c
Date: Mon,  7 Sep 2026 17:36:29 -0400
Message-ID: <20260907213630.573772-3-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907213630.573772-1-sashal@kernel.org>
References: <2026090336-riverboat-makeover-fe69@gregkh>
 <20260907213630.573772-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 88f7d7e32d9e086ba87c6b04a9ba57f3f41268bd ]

Split SMB1-specific connection management stuff to smb1ops.c and move
CIFSTCon() to cifssmb.c.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Acked-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 65deb1835934 ("smb: client: reject a tree connect response whose byte count is too small")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsproto.h |  13 +-
 fs/smb/client/cifssmb.c   | 140 +++++++++++++++++++++
 fs/smb/client/connect.c   | 251 --------------------------------------
 fs/smb/client/smb1ops.c   | 107 ++++++++++++++++
 fs/smb/client/smb1proto.h |   5 +
 fs/smb/client/trace.h     |  36 +++++-
 6 files changed, 293 insertions(+), 259 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index c7f8650cf2498..4cab0c9524f2a 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -338,10 +338,6 @@ extern int CIFSSMBNegotiate(const unsigned int xid,
 			    struct cifs_ses *ses,
 			    struct TCP_Server_Info *server);
 
-extern int CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
-		    const char *tree, struct cifs_tcon *tcon,
-		    const struct nls_table *);
-
 extern int CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 		const char *searchName, struct cifs_sb_info *cifs_sb,
 		__u16 *searchHandle, __u16 search_flags,
@@ -384,9 +380,6 @@ extern int parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 			       struct dfs_info3_param **target_nodes,
 			       const struct nls_table *nls_codepage, int remap,
 			       const char *searchName, bool is_unicode);
-extern void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
-				 struct cifs_sb_info *cifs_sb,
-				 struct smb3_fs_context *ctx);
 extern int CIFSSMBQFSInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			struct kstatfs *FSData);
 extern int SMBOldQFSInfo(const unsigned int xid, struct cifs_tcon *tcon,
@@ -775,4 +768,10 @@ static inline void cifs_free_open_info(struct cifs_open_info_data *data)
 	memset(data, 0, sizeof(*data));
 }
 
+#define smb_EIO2(_trace, _info, _info2) \
+({ \
+	trace_smb3_eio((_trace), (_info), (_info2)); \
+	-EIO; \
+})
+
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index e7df15011ae33..4e3598543aef0 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -507,6 +507,146 @@ CIFSSMBNegotiate(const unsigned int xid,
 	return rc;
 }
 
+/*
+ * Issue a TREE_CONNECT request.
+ */
+int
+CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
+	 const char *tree, struct cifs_tcon *tcon,
+	 const struct nls_table *nls_codepage)
+{
+	struct smb_hdr *smb_buffer;
+	struct smb_hdr *smb_buffer_response;
+	TCONX_REQ *pSMB;
+	TCONX_RSP *pSMBr;
+	unsigned char *bcc_ptr;
+	int rc = 0;
+	int length;
+	__u16 bytes_left, count;
+
+	if (ses == NULL)
+		return -EIO;
+
+	smb_buffer = cifs_buf_get();
+	if (smb_buffer == NULL)
+		return -ENOMEM;
+
+	smb_buffer_response = smb_buffer;
+
+	header_assemble(smb_buffer, SMB_COM_TREE_CONNECT_ANDX,
+			NULL /*no tid */, 4 /*wct */);
+
+	smb_buffer->Mid = get_next_mid(ses->server);
+	smb_buffer->Uid = ses->Suid;
+	pSMB = (TCONX_REQ *) smb_buffer;
+	pSMBr = (TCONX_RSP *) smb_buffer_response;
+
+	pSMB->AndXCommand = 0xFF;
+	pSMB->Flags = cpu_to_le16(TCON_EXTENDED_SECINFO);
+	bcc_ptr = &pSMB->Password[0];
+
+	pSMB->PasswordLength = cpu_to_le16(1);	/* minimum */
+	*bcc_ptr = 0; /* password is null byte */
+	bcc_ptr++;              /* skip password */
+	/* already aligned so no need to do it below */
+
+	if (ses->server->sign)
+		smb_buffer->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
+
+	if (ses->capabilities & CAP_STATUS32)
+		smb_buffer->Flags2 |= SMBFLG2_ERR_STATUS;
+
+	if (ses->capabilities & CAP_DFS)
+		smb_buffer->Flags2 |= SMBFLG2_DFS;
+
+	if (ses->capabilities & CAP_UNICODE) {
+		smb_buffer->Flags2 |= SMBFLG2_UNICODE;
+		length =
+		    cifs_strtoUTF16((__le16 *) bcc_ptr, tree,
+			6 /* max utf8 char length in bytes */ *
+			(/* server len*/ + 256 /* share len */), nls_codepage);
+		bcc_ptr += 2 * length;	/* convert num 16 bit words to bytes */
+		bcc_ptr += 2;	/* skip trailing null */
+	} else {		/* ASCII */
+		strcpy(bcc_ptr, tree);
+		bcc_ptr += strlen(tree) + 1;
+	}
+	strcpy(bcc_ptr, "?????");
+	bcc_ptr += strlen("?????");
+	bcc_ptr += 1;
+	count = bcc_ptr - &pSMB->Password[0];
+	be32_add_cpu(&pSMB->hdr.smb_buf_length, count);
+	pSMB->ByteCount = cpu_to_le16(count);
+
+	rc = SendReceive(xid, ses, smb_buffer, smb_buffer_response, &length,
+			 0);
+
+	/* above now done in SendReceive */
+	if (rc == 0) {
+		bool is_unicode;
+
+		tcon->tid = smb_buffer_response->Tid;
+		bcc_ptr = pByteArea(smb_buffer_response);
+		bytes_left = get_bcc(smb_buffer_response);
+		length = strnlen(bcc_ptr, bytes_left - 2);
+		if (smb_buffer->Flags2 & SMBFLG2_UNICODE)
+			is_unicode = true;
+		else
+			is_unicode = false;
+
+
+		/* skip service field (NB: this field is always ASCII) */
+		if (length == 3) {
+			if ((bcc_ptr[0] == 'I') && (bcc_ptr[1] == 'P') &&
+			    (bcc_ptr[2] == 'C')) {
+				cifs_dbg(FYI, "IPC connection\n");
+				tcon->ipc = true;
+				tcon->pipe = true;
+			}
+		} else if (length == 2) {
+			if ((bcc_ptr[0] == 'A') && (bcc_ptr[1] == ':')) {
+				/* the most common case */
+				cifs_dbg(FYI, "disk share connection\n");
+			}
+		}
+		bcc_ptr += length + 1;
+		bytes_left -= (length + 1);
+		strscpy(tcon->tree_name, tree, sizeof(tcon->tree_name));
+
+		/* mostly informational -- no need to fail on error here */
+		kfree(tcon->nativeFileSystem);
+		tcon->nativeFileSystem = cifs_strndup_from_utf16(bcc_ptr,
+						      bytes_left, is_unicode,
+						      nls_codepage);
+
+		cifs_dbg(FYI, "nativeFileSystem=%s\n", tcon->nativeFileSystem);
+
+		if ((smb_buffer_response->WordCount == 3) ||
+			 (smb_buffer_response->WordCount == 7))
+			/* field is in same location */
+			tcon->Flags = le16_to_cpu(pSMBr->OptionalSupport);
+		else
+			tcon->Flags = 0;
+		cifs_dbg(FYI, "Tcon flags: 0x%x\n", tcon->Flags);
+
+		/*
+		 * reset_cifs_unix_caps calls QFSInfo which requires
+		 * need_reconnect to be false, but we would not need to call
+		 * reset_caps if this were not a reconnect case so must check
+		 * need_reconnect flag here.  The caller will also clear
+		 * need_reconnect when tcon was successful but needed to be
+		 * cleared earlier in the case of unix extensions reconnect
+		 */
+		if (tcon->need_reconnect && tcon->unix_ext) {
+			cifs_dbg(FYI, "resetting caps for %s\n", tcon->tree_name);
+			tcon->need_reconnect = false;
+			reset_cifs_unix_caps(xid, tcon, NULL, NULL);
+		}
+	}
+	cifs_buf_release(smb_buffer);
+	return rc;
+}
+
 int
 CIFSSMBTDis(const unsigned int xid, struct cifs_tcon *tcon)
 {
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 68a000956d957..3c36859b99725 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3265,115 +3265,6 @@ ip_connect(struct TCP_Server_Info *server)
 	return generic_ip_connect(server);
 }
 
-#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
-			  struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
-{
-	/*
-	 * If we are reconnecting then should we check to see if
-	 * any requested capabilities changed locally e.g. via
-	 * remount but we can not do much about it here
-	 * if they have (even if we could detect it by the following)
-	 * Perhaps we could add a backpointer to array of sb from tcon
-	 * or if we change to make all sb to same share the same
-	 * sb as NFS - then we only have one backpointer to sb.
-	 * What if we wanted to mount the server share twice once with
-	 * and once without posixacls or posix paths?
-	 */
-	__u64 saved_cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
-
-	if (ctx && ctx->no_linux_ext) {
-		tcon->fsUnixInfo.Capability = 0;
-		tcon->unix_ext = 0; /* Unix Extensions disabled */
-		cifs_dbg(FYI, "Linux protocol extensions disabled\n");
-		return;
-	} else if (ctx)
-		tcon->unix_ext = 1; /* Unix Extensions supported */
-
-	if (!tcon->unix_ext) {
-		cifs_dbg(FYI, "Unix extensions disabled so not set on reconnect\n");
-		return;
-	}
-
-	if (!CIFSSMBQFSUnixInfo(xid, tcon)) {
-		__u64 cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
-
-		cifs_dbg(FYI, "unix caps which server supports %lld\n", cap);
-		/*
-		 * check for reconnect case in which we do not
-		 * want to change the mount behavior if we can avoid it
-		 */
-		if (ctx == NULL) {
-			/*
-			 * turn off POSIX ACL and PATHNAMES if not set
-			 * originally at mount time
-			 */
-			if ((saved_cap & CIFS_UNIX_POSIX_ACL_CAP) == 0)
-				cap &= ~CIFS_UNIX_POSIX_ACL_CAP;
-			if ((saved_cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) == 0) {
-				if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP)
-					cifs_dbg(VFS, "POSIXPATH support change\n");
-				cap &= ~CIFS_UNIX_POSIX_PATHNAMES_CAP;
-			} else if ((cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) == 0) {
-				cifs_dbg(VFS, "possible reconnect error\n");
-				cifs_dbg(VFS, "server disabled POSIX path support\n");
-			}
-		}
-
-		if (cap & CIFS_UNIX_TRANSPORT_ENCRYPTION_MANDATORY_CAP)
-			cifs_dbg(VFS, "per-share encryption not supported yet\n");
-
-		cap &= CIFS_UNIX_CAP_MASK;
-		if (ctx && ctx->no_psx_acl)
-			cap &= ~CIFS_UNIX_POSIX_ACL_CAP;
-		else if (CIFS_UNIX_POSIX_ACL_CAP & cap) {
-			cifs_dbg(FYI, "negotiated posix acl support\n");
-			if (cifs_sb)
-				cifs_sb->mnt_cifs_flags |=
-					CIFS_MOUNT_POSIXACL;
-		}
-
-		if (ctx && ctx->posix_paths == 0)
-			cap &= ~CIFS_UNIX_POSIX_PATHNAMES_CAP;
-		else if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) {
-			cifs_dbg(FYI, "negotiate posix pathnames\n");
-			if (cifs_sb)
-				cifs_sb->mnt_cifs_flags |=
-					CIFS_MOUNT_POSIX_PATHS;
-		}
-
-		cifs_dbg(FYI, "Negotiate caps 0x%x\n", (int)cap);
-#ifdef CONFIG_CIFS_DEBUG2
-		if (cap & CIFS_UNIX_FCNTL_CAP)
-			cifs_dbg(FYI, "FCNTL cap\n");
-		if (cap & CIFS_UNIX_EXTATTR_CAP)
-			cifs_dbg(FYI, "EXTATTR cap\n");
-		if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP)
-			cifs_dbg(FYI, "POSIX path cap\n");
-		if (cap & CIFS_UNIX_XATTR_CAP)
-			cifs_dbg(FYI, "XATTR cap\n");
-		if (cap & CIFS_UNIX_POSIX_ACL_CAP)
-			cifs_dbg(FYI, "POSIX ACL cap\n");
-		if (cap & CIFS_UNIX_LARGE_READ_CAP)
-			cifs_dbg(FYI, "very large read cap\n");
-		if (cap & CIFS_UNIX_LARGE_WRITE_CAP)
-			cifs_dbg(FYI, "very large write cap\n");
-		if (cap & CIFS_UNIX_TRANSPORT_ENCRYPTION_CAP)
-			cifs_dbg(FYI, "transport encryption cap\n");
-		if (cap & CIFS_UNIX_TRANSPORT_ENCRYPTION_MANDATORY_CAP)
-			cifs_dbg(FYI, "mandatory transport encryption cap\n");
-#endif /* CIFS_DEBUG2 */
-		if (CIFSSMBSetFSUnixInfo(xid, tcon, cap)) {
-			if (ctx == NULL)
-				cifs_dbg(FYI, "resetting capabilities failed\n");
-			else
-				cifs_dbg(VFS, "Negotiating Unix capabilities with the server failed. Consider mounting with the Unix Extensions disabled if problems are found by specifying the nounix mount option.\n");
-
-		}
-	}
-}
-#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
-
 int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb)
 {
 	struct smb3_fs_context *ctx = cifs_sb->ctx;
@@ -3795,148 +3686,6 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 }
 #endif
 
-#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-/*
- * Issue a TREE_CONNECT request.
- */
-int
-CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
-	 const char *tree, struct cifs_tcon *tcon,
-	 const struct nls_table *nls_codepage)
-{
-	struct smb_hdr *smb_buffer;
-	struct smb_hdr *smb_buffer_response;
-	TCONX_REQ *pSMB;
-	TCONX_RSP *pSMBr;
-	unsigned char *bcc_ptr;
-	int rc = 0;
-	int length;
-	__u16 bytes_left, count;
-
-	if (ses == NULL)
-		return -EIO;
-
-	smb_buffer = cifs_buf_get();
-	if (smb_buffer == NULL)
-		return -ENOMEM;
-
-	smb_buffer_response = smb_buffer;
-
-	header_assemble(smb_buffer, SMB_COM_TREE_CONNECT_ANDX,
-			NULL /*no tid */, 4 /*wct */);
-
-	smb_buffer->Mid = get_next_mid(ses->server);
-	smb_buffer->Uid = ses->Suid;
-	pSMB = (TCONX_REQ *) smb_buffer;
-	pSMBr = (TCONX_RSP *) smb_buffer_response;
-
-	pSMB->AndXCommand = 0xFF;
-	pSMB->Flags = cpu_to_le16(TCON_EXTENDED_SECINFO);
-	bcc_ptr = &pSMB->Password[0];
-
-	pSMB->PasswordLength = cpu_to_le16(1);	/* minimum */
-	*bcc_ptr = 0; /* password is null byte */
-	bcc_ptr++;              /* skip password */
-	/* already aligned so no need to do it below */
-
-	if (ses->server->sign)
-		smb_buffer->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
-
-	if (ses->capabilities & CAP_STATUS32)
-		smb_buffer->Flags2 |= SMBFLG2_ERR_STATUS;
-
-	if (ses->capabilities & CAP_DFS)
-		smb_buffer->Flags2 |= SMBFLG2_DFS;
-
-	if (ses->capabilities & CAP_UNICODE) {
-		smb_buffer->Flags2 |= SMBFLG2_UNICODE;
-		length =
-		    cifs_strtoUTF16((__le16 *) bcc_ptr, tree,
-			6 /* max utf8 char length in bytes */ *
-			(/* server len*/ + 256 /* share len */), nls_codepage);
-		bcc_ptr += 2 * length;	/* convert num 16 bit words to bytes */
-		bcc_ptr += 2;	/* skip trailing null */
-	} else {		/* ASCII */
-		strcpy(bcc_ptr, tree);
-		bcc_ptr += strlen(tree) + 1;
-	}
-	strcpy(bcc_ptr, "?????");
-	bcc_ptr += strlen("?????");
-	bcc_ptr += 1;
-	count = bcc_ptr - &pSMB->Password[0];
-	be32_add_cpu(&pSMB->hdr.smb_buf_length, count);
-	pSMB->ByteCount = cpu_to_le16(count);
-
-	rc = SendReceive(xid, ses, smb_buffer, smb_buffer_response, &length,
-			 0);
-
-	/* above now done in SendReceive */
-	if (rc == 0) {
-		bool is_unicode;
-
-		tcon->tid = smb_buffer_response->Tid;
-		bcc_ptr = pByteArea(smb_buffer_response);
-		bytes_left = get_bcc(smb_buffer_response);
-		length = strnlen(bcc_ptr, bytes_left - 2);
-		if (smb_buffer->Flags2 & SMBFLG2_UNICODE)
-			is_unicode = true;
-		else
-			is_unicode = false;
-
-
-		/* skip service field (NB: this field is always ASCII) */
-		if (length == 3) {
-			if ((bcc_ptr[0] == 'I') && (bcc_ptr[1] == 'P') &&
-			    (bcc_ptr[2] == 'C')) {
-				cifs_dbg(FYI, "IPC connection\n");
-				tcon->ipc = true;
-				tcon->pipe = true;
-			}
-		} else if (length == 2) {
-			if ((bcc_ptr[0] == 'A') && (bcc_ptr[1] == ':')) {
-				/* the most common case */
-				cifs_dbg(FYI, "disk share connection\n");
-			}
-		}
-		bcc_ptr += length + 1;
-		bytes_left -= (length + 1);
-		strscpy(tcon->tree_name, tree, sizeof(tcon->tree_name));
-
-		/* mostly informational -- no need to fail on error here */
-		kfree(tcon->nativeFileSystem);
-		tcon->nativeFileSystem = cifs_strndup_from_utf16(bcc_ptr,
-						      bytes_left, is_unicode,
-						      nls_codepage);
-
-		cifs_dbg(FYI, "nativeFileSystem=%s\n", tcon->nativeFileSystem);
-
-		if ((smb_buffer_response->WordCount == 3) ||
-			 (smb_buffer_response->WordCount == 7))
-			/* field is in same location */
-			tcon->Flags = le16_to_cpu(pSMBr->OptionalSupport);
-		else
-			tcon->Flags = 0;
-		cifs_dbg(FYI, "Tcon flags: 0x%x\n", tcon->Flags);
-
-		/*
-		 * reset_cifs_unix_caps calls QFSInfo which requires
-		 * need_reconnect to be false, but we would not need to call
-		 * reset_caps if this were not a reconnect case so must check
-		 * need_reconnect flag here.  The caller will also clear
-		 * need_reconnect when tcon was successful but needed to be
-		 * cleared earlier in the case of unix extensions reconnect
-		 */
-		if (tcon->need_reconnect && tcon->unix_ext) {
-			cifs_dbg(FYI, "resetting caps for %s\n", tcon->tree_name);
-			tcon->need_reconnect = false;
-			reset_cifs_unix_caps(xid, tcon, NULL, NULL);
-		}
-	}
-	cifs_buf_release(smb_buffer);
-	return rc;
-}
-#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
-
 static void delayed_free(struct rcu_head *p)
 {
 	struct cifs_sb_info *cifs_sb = container_of(p, struct cifs_sb_info, rcu);
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index c80b291a14a57..fc1b02986a08d 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -15,6 +15,113 @@
 #include "cifs_unicode.h"
 #include "fs_context.h"
 
+void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
+			  struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
+{
+	/*
+	 * If we are reconnecting then should we check to see if
+	 * any requested capabilities changed locally e.g. via
+	 * remount but we can not do much about it here
+	 * if they have (even if we could detect it by the following)
+	 * Perhaps we could add a backpointer to array of sb from tcon
+	 * or if we change to make all sb to same share the same
+	 * sb as NFS - then we only have one backpointer to sb.
+	 * What if we wanted to mount the server share twice once with
+	 * and once without posixacls or posix paths?
+	 */
+	__u64 saved_cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
+
+	if (ctx && ctx->no_linux_ext) {
+		tcon->fsUnixInfo.Capability = 0;
+		tcon->unix_ext = 0; /* Unix Extensions disabled */
+		cifs_dbg(FYI, "Linux protocol extensions disabled\n");
+		return;
+	} else if (ctx)
+		tcon->unix_ext = 1; /* Unix Extensions supported */
+
+	if (!tcon->unix_ext) {
+		cifs_dbg(FYI, "Unix extensions disabled so not set on reconnect\n");
+		return;
+	}
+
+	if (!CIFSSMBQFSUnixInfo(xid, tcon)) {
+		__u64 cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
+
+		cifs_dbg(FYI, "unix caps which server supports %lld\n", cap);
+		/*
+		 * check for reconnect case in which we do not
+		 * want to change the mount behavior if we can avoid it
+		 */
+		if (ctx == NULL) {
+			/*
+			 * turn off POSIX ACL and PATHNAMES if not set
+			 * originally at mount time
+			 */
+			if ((saved_cap & CIFS_UNIX_POSIX_ACL_CAP) == 0)
+				cap &= ~CIFS_UNIX_POSIX_ACL_CAP;
+			if ((saved_cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) == 0) {
+				if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP)
+					cifs_dbg(VFS, "POSIXPATH support change\n");
+				cap &= ~CIFS_UNIX_POSIX_PATHNAMES_CAP;
+			} else if ((cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) == 0) {
+				cifs_dbg(VFS, "possible reconnect error\n");
+				cifs_dbg(VFS, "server disabled POSIX path support\n");
+			}
+		}
+
+		if (cap & CIFS_UNIX_TRANSPORT_ENCRYPTION_MANDATORY_CAP)
+			cifs_dbg(VFS, "per-share encryption not supported yet\n");
+
+		cap &= CIFS_UNIX_CAP_MASK;
+		if (ctx && ctx->no_psx_acl)
+			cap &= ~CIFS_UNIX_POSIX_ACL_CAP;
+		else if (CIFS_UNIX_POSIX_ACL_CAP & cap) {
+			cifs_dbg(FYI, "negotiated posix acl support\n");
+			if (cifs_sb)
+				cifs_sb->mnt_cifs_flags |=
+					CIFS_MOUNT_POSIXACL;
+		}
+
+		if (ctx && ctx->posix_paths == 0)
+			cap &= ~CIFS_UNIX_POSIX_PATHNAMES_CAP;
+		else if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) {
+			cifs_dbg(FYI, "negotiate posix pathnames\n");
+			if (cifs_sb)
+				cifs_sb->mnt_cifs_flags |=
+					CIFS_MOUNT_POSIX_PATHS;
+		}
+
+		cifs_dbg(FYI, "Negotiate caps 0x%x\n", (int)cap);
+#ifdef CONFIG_CIFS_DEBUG2
+		if (cap & CIFS_UNIX_FCNTL_CAP)
+			cifs_dbg(FYI, "FCNTL cap\n");
+		if (cap & CIFS_UNIX_EXTATTR_CAP)
+			cifs_dbg(FYI, "EXTATTR cap\n");
+		if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP)
+			cifs_dbg(FYI, "POSIX path cap\n");
+		if (cap & CIFS_UNIX_XATTR_CAP)
+			cifs_dbg(FYI, "XATTR cap\n");
+		if (cap & CIFS_UNIX_POSIX_ACL_CAP)
+			cifs_dbg(FYI, "POSIX ACL cap\n");
+		if (cap & CIFS_UNIX_LARGE_READ_CAP)
+			cifs_dbg(FYI, "very large read cap\n");
+		if (cap & CIFS_UNIX_LARGE_WRITE_CAP)
+			cifs_dbg(FYI, "very large write cap\n");
+		if (cap & CIFS_UNIX_TRANSPORT_ENCRYPTION_CAP)
+			cifs_dbg(FYI, "transport encryption cap\n");
+		if (cap & CIFS_UNIX_TRANSPORT_ENCRYPTION_MANDATORY_CAP)
+			cifs_dbg(FYI, "mandatory transport encryption cap\n");
+#endif /* CIFS_DEBUG2 */
+		if (CIFSSMBSetFSUnixInfo(xid, tcon, cap)) {
+			if (ctx == NULL)
+				cifs_dbg(FYI, "resetting capabilities failed\n");
+			else
+				cifs_dbg(VFS, "Negotiating Unix capabilities with the server failed. Consider mounting with the Unix Extensions disabled if problems are found by specifying the nounix mount option.\n");
+
+		}
+	}
+}
+
 /*
  * An NT cancel request header looks just like the original request except:
  *
diff --git a/fs/smb/client/smb1proto.h b/fs/smb/client/smb1proto.h
index a73213f6a2aa1..574910b5b4c8b 100644
--- a/fs/smb/client/smb1proto.h
+++ b/fs/smb/client/smb1proto.h
@@ -23,12 +23,17 @@ struct cifs_unix_set_info_args {
 /*
  * cifssmb.c
  */
+int CIFSTCon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
+	     struct cifs_tcon *tcon, const struct nls_table *nls_codepage);
 
 /*
  * smb1ops.c
  */
 extern struct smb_version_operations smb1_operations;
 extern struct smb_version_values smb1_values;
+void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
+			  struct cifs_sb_info *cifs_sb,
+			  struct smb3_fs_context *ctx);
 
 /*
  * smb1transport.c
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 036c7966e2600..ebcc2913a879f 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -20,6 +20,18 @@
 /*
  * Specify enums for tracing information.
  */
+#define smb_eio_traces \
+	EM(smb_eio_trace_sym_slash,			"sym_slash") \
+	EM(smb_eio_trace_sym_target_len,		"sym_target_len") \
+	EM(smb_eio_trace_symlink_file_size,		"symlink_file_size") \
+	EM(smb_eio_trace_tdis_in_reconnect,		"tdis_in_reconnect") \
+	EM(smb_eio_trace_tx_chained_async,		"tx_chained_async") \
+	EM(smb_eio_trace_tx_compress_failed,		"tx_compress_failed") \
+	E_(smb_eio_trace_tx_copy_iter_to_buf,		"tx_copy_iter_to_buf")
+
+#define smb3_rw_credits_traces \
+	E_(cifs_trace_rw_credits_call_readv_adjust,	"rd-call-adj")
+
 #define smb3_tcon_ref_traces					      \
 	EM(netfs_trace_tcon_ref_dec_dfs_refer,		"DEC DfsRef") \
 	EM(netfs_trace_tcon_ref_free,			"FRE       ") \
@@ -67,7 +79,9 @@
 #define EM(a, b) a,
 #define E_(a, b) a
 
-enum smb3_tcon_ref_trace { smb3_tcon_ref_traces } __mode(byte);
+enum smb_eio_trace		{ smb_eio_traces } __mode(byte);
+enum smb3_rw_credits_trace	{ smb3_rw_credits_traces } __mode(byte);
+enum smb3_tcon_ref_trace	{ smb3_tcon_ref_traces } __mode(byte);
 
 #undef EM
 #undef E_
@@ -79,6 +93,8 @@ enum smb3_tcon_ref_trace { smb3_tcon_ref_traces } __mode(byte);
 #define EM(a, b) TRACE_DEFINE_ENUM(a);
 #define E_(a, b) TRACE_DEFINE_ENUM(a);
 
+smb_eio_traces;
+smb3_rw_credits_traces;
 smb3_tcon_ref_traces;
 
 #undef EM
@@ -1218,6 +1234,24 @@ TRACE_EVENT(smb3_tcon_ref,
 		      __entry->ref)
 	    );
 
+TRACE_EVENT(smb3_eio,
+	    TP_PROTO(enum smb_eio_trace trace, unsigned long info, unsigned long info2),
+	    TP_ARGS(trace, info, info2),
+	    TP_STRUCT__entry(
+		    __field(enum smb_eio_trace,	trace)
+		    __field(unsigned long,	info)
+		    __field(unsigned long,	info2)
+			     ),
+	    TP_fast_assign(
+		    __entry->trace	= trace;
+		    __entry->info	= info;
+		    __entry->info2	= info2;
+			   ),
+	    TP_printk("%s info=%lx,%lx",
+		      __print_symbolic(__entry->trace, smb_eio_traces),
+		      __entry->info, __entry->info2)
+	    );
+
 
 #undef EM
 #undef E_
-- 
2.53.0

