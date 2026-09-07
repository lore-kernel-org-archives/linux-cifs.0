Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4DE35E950;
	Mon,  7 Sep 2026 23:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788823222; cv=none; b=TSnO9JUOTwFMAb2wTDZf85oI9MBoIeTNn2MqkTRuvJHXxDJz4TFGTXGzTDOAuRRAXSFujBMhA0ECN6ePMh0hLXoG7H7EjYYiEHQBheSY9gdsjRLDJlo5tlE/CygJHGvTnAIKSJISyY1Mes6hSE5ME0Tbb47JfjQNvzaBHhE6xjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788823222; c=relaxed/simple;
	bh=kCQfFLIOVqYQLC/8h795GCFpUIMpFi76KliZmzWY5/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0C3NxA6WTEwwUxKBYHL1tIvIGolmO3sqZghGm0++XIuhF17gVvSfQexUZuwA1lxNNwu8TtisBDrrm1enn2ECqUVih0VVqJTnr2e6OWoIztGQ3sNL7qQnIg02aExxCsQM4V04KyIfyZEWZ9mGZxnCVpTz6jNA/3tNg5Y1INdbD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aKXMh5wj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aKXMh5wj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2421F00A3D;
	Mon,  7 Sep 2026 23:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788823220;
	bh=/XQWf0AmeuhJmMavm5CJ7++J1yNTa94TFbNdigd3oK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aKXMh5wjcRNPRHGS1tX/DSWBouKzqw4/oFyRSYTJWLNTm8DFz/p4cGi/EiHpqQJSe
	 lVCsP81AL/cAZKwTcfzM/J1uOGHatVvLP9xeRPVyJQAMLLzmClTiw+NYZ6wabb5cpT
	 PLzrWoDEwk8wPSvS2rYO8u7F1SudZw8Ph/c5fE80YoMrSmBubpzGoZQ1KJ4qz8xWJC
	 V8haQp3mglYRqMGnJ1CqspvRfXMO/02VIKeOyW8JDkExzGPc1bNgSjspz9G8OZlcKH
	 S8wAnxvfCo2j7M37RlEeoKF/eDBPLRDpS/lb/Hx1UjPEEx0Pjb92TxFMmdoR7q4Pt6
	 WNxRnL4We3nXA==
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
Subject: [PATCH 6.1.y 2/3] cifs: SMB1 split: connect.c
Date: Mon,  7 Sep 2026 19:20:15 -0400
Message-ID: <20260907232016.765564-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907232016.765564-1-sashal@kernel.org>
References: <2026090336-expend-runaround-0e93@gregkh>
 <20260907232016.765564-1-sashal@kernel.org>
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
  backport carries 2. Not backported here:
  fs/smb/client/cifsproto.h
  fs/smb/client/smb1ops.c
  fs/smb/client/smb1proto.h
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 65deb1835934 ("smb: client: reject a tree connect response whose byte count is too small")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 140 +++++++++++++++++++++++++++++++++++++++
 fs/smb/client/connect.c | 142 ----------------------------------------
 2 files changed, 140 insertions(+), 142 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 95cf7e69a411d..f0a7dd1656910 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -497,6 +497,146 @@ CIFSSMBNegotiate(const unsigned int xid,
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
+			NULL /*no tid */ , 4 /*wct */ );
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
+	if (ses->capabilities & CAP_STATUS32) {
+		smb_buffer->Flags2 |= SMBFLG2_ERR_STATUS;
+	}
+	if (ses->capabilities & CAP_DFS) {
+		smb_buffer->Flags2 |= SMBFLG2_DFS;
+	}
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
index 096e69c591722..b4c4f06d15ff2 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4031,148 +4031,6 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
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
-			NULL /*no tid */ , 4 /*wct */ );
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
-	if (ses->capabilities & CAP_STATUS32) {
-		smb_buffer->Flags2 |= SMBFLG2_ERR_STATUS;
-	}
-	if (ses->capabilities & CAP_DFS) {
-		smb_buffer->Flags2 |= SMBFLG2_DFS;
-	}
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
-- 
2.53.0

