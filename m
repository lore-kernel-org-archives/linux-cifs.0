Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB6E526AB8;
	Mon,  7 Sep 2026 20:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788811227; cv=none; b=hooKnzbkB76wnhorvQq437HEH5x+6ZIq9vmKKjTKymtQV2zihK+11GkFSAE6KTKUcciQlYcoLNMHIWMtW5z5CCbd6mqsfYuTfYRHgcXHvPrOHLN5jzFONA/xFUqhRGPd6gSHUJBzxi82CXWb2AaGtkfJjM8Rk5+RWu63+b+0e8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788811227; c=relaxed/simple;
	bh=Nk7ADkLaz7Y6NlvhW34HKZY/vtZI6LdUUJr6W4g/s9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CG5uRzg6xnTW6b5SBWTe/eTj/LvESbCVrkgEHQHOqJx0zVgMXuHDNEBp1cvOorWwG3RIwHiXLwjfJbwOCZvUyeH22CjrBoHVoaVHE0dg18EuHPNctanIAqOb5fdkOzKTOOza5OvzZnmCzizR9i+2hDuSwKz/fC42UAg205ZGVvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lmsWZmuo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lmsWZmuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CB41F00A3A;
	Mon,  7 Sep 2026 20:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788811226;
	bh=WJl/L59oE7qKwx54Pfp3l5Qf9mfZTxtVJ+YO8gmp35A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lmsWZmuoRxU+h3cHBFF2WffNzzJRbjpC+lctt1nvXcAekN3U8HkWcJsQ+Fcu9MIJa
	 pSiIG+axvTMbSDV+q4BCuMIZ7mfVHoJsgIZWZeKmbDFvGTSL/i1pgQs29qgQ7y+QfR
	 /UZOo1+nr5MusBUWAM1dIjTyMNqI5wbw1fBRwdPVpZXmb3qg8Ncn7Ov42uGQyYZnMW
	 og+EBPC8sxjhvTBjEArqKAesZoHcRHIA444re5xMSUM9/EddvPlTUzL1Om/CAoUex6
	 C6fbSVeCvuc2rikaaYTK5sKW4iKOY3rWW9puniSmX8ibuc72XMiGz0kDtA9yK/QbiK
	 UPBF/5Z0hhOhg==
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
Subject: [PATCH 6.12.y 2/3] cifs: SMB1 split: connect.c
Date: Mon,  7 Sep 2026 16:00:21 -0400
Message-ID: <20260907200022.327035-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907200022.327035-1-sashal@kernel.org>
References: <2026090336-rising-foyer-5fb8@gregkh>
 <20260907200022.327035-1-sashal@kernel.org>
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

[ sashal: Reduced backport -- upstream 88f7d7e32d9e0 touches 5 file(s), this
  backport carries 4. Not backported here:
  fs/smb/client/smb1ops.c
  fs/smb/client/smb1proto.h
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 65deb1835934 ("smb: client: reject a tree connect response whose byte count is too small")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsproto.h |   3 +
 fs/smb/client/cifssmb.c   | 140 +++++++++++++++++++++++++++++++++++++
 fs/smb/client/connect.c   | 142 --------------------------------------
 fs/smb/client/trace.h     |  11 +++
 4 files changed, 154 insertions(+), 142 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index d2d004764a708..37af29544dade 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -18,6 +18,9 @@ struct statfs;
 struct smb_rqst;
 struct smb3_fs_context;
 
+/* This stable branch does not carry the SMB EIO tracing infrastructure. */
+#define smb_EIO2(trace, info, info2) (-EIO)
+
 /*
  *****************************************************************
  * All Prototypes
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 01c78d9e7ec0e..696b2a800d7e3 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -509,6 +509,146 @@ CIFSSMBNegotiate(const unsigned int xid,
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
index 52ac9b096a402..b98177a27808f 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3798,148 +3798,6 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
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
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 7b3675cfa7717..d619e407f6409 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -20,6 +20,15 @@
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
 #define smb3_rw_credits_traces \
 	EM(cifs_trace_rw_credits_call_readv_adjust,	"rd-call-adj") \
 	EM(cifs_trace_rw_credits_call_writev_adjust,	"wr-call-adj") \
@@ -84,6 +93,7 @@
 #define EM(a, b) a,
 #define E_(a, b) a
 
+enum smb_eio_trace		{ smb_eio_traces } __mode(byte);
 enum smb3_rw_credits_trace	{ smb3_rw_credits_traces } __mode(byte);
 enum smb3_tcon_ref_trace	{ smb3_tcon_ref_traces } __mode(byte);
 
@@ -97,6 +107,7 @@ enum smb3_tcon_ref_trace	{ smb3_tcon_ref_traces } __mode(byte);
 #define EM(a, b) TRACE_DEFINE_ENUM(a);
 #define E_(a, b) TRACE_DEFINE_ENUM(a);
 
+smb_eio_traces;
 smb3_rw_credits_traces;
 smb3_tcon_ref_traces;
 
-- 
2.53.0

