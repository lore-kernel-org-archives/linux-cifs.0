Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3092FBE;
	Tue,  8 Sep 2026 01:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788829408; cv=none; b=u+QWIESWioL8VMm5mKwOWM5K3tg21qAtoR6hUYbyM0vgqpZ/6lgmMZMCl0YOhg6g/3OHGERfPRHMDSInxxYVfAxuWRt3jPvmtw8wwnZVP1HkwcLotE4eCA1gbEXA8Gpb2/kv9YhJCOCtjSILhpl/4CdWOyZxKyhOjsbG9V0T3Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788829408; c=relaxed/simple;
	bh=ACHt+C0f4V78ysrvCcUvOdzTUZBfX9QWd4yo6JAJs00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BK2sUGZUSxdT9bsgaFiN0nqnZbtOxU8tXgRSLFNpg74w36DrAPr7QnLVgEQEpBJ8AnaylAklV2IkM4D1Ix559QYDjVlPrsR6jvks3Xzq1Og+JoUj37kzI4eJ4NBL1LCsYctqMZr9k/Ds9fzRF85FWxjsEG9/cIT4HVarQscMZGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z5IqF6xr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z5IqF6xr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C33B1F00A3A;
	Tue,  8 Sep 2026 01:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788829406;
	bh=MTR9Fu8FTAYADS7oSxCBRThc5kVTzB4IHU+lvHxIqTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z5IqF6xrLDLkRYA5wc/NoiwU0P77UYRzDaJD5JWCwer1EhYqN7i+GxP4HmU1PM1Wl
	 qHXPnboRLRsE4j2ts5fcuJKDJYjtmxk15qypmVyvQVVRLO/E7fnjk9BJAPjr3K3itb
	 rFMw10ZO34Iml+90D16lTZbkKhqRtQ/8sWI0EmQxCpFuTilh6jcGPQlROug8S1IjX5
	 Awiku/FjJuHiX6nXzngueTBXDwG52plWzYaQQUs5THq4/UUlysYdNxfV48QRnHjPG6
	 R7ZFtIi0Uqsosei6FdU2xxgs3rKW84VhXGh9GgkoYuDL8kPSGrUKJhgzryKAVVt4Op
	 qmnBIVSFVp0cQ==
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
Subject: [PATCH 5.15.y 1/2] cifs: SMB1 split: connect.c
Date: Mon,  7 Sep 2026 21:03:22 -0400
Message-ID: <20260908010323.1670112-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026090337-dismiss-carload-0d51@gregkh>
References: <2026090337-dismiss-carload-0d51@gregkh>
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
  fs/smb/client/cifssmb.c
  fs/smb/client/connect.c
  fs/smb/client/smb1ops.c
  fs/smb/client/smb1proto.h
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 65deb1835934 ("smb: client: reject a tree connect response whose byte count is too small")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifssmb.c | 128 +++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/connect.c | 129 ----------------------------------------------
 2 files changed, 128 insertions(+), 129 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 11a400663b9f2..5b58e198c2f0e 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -582,6 +582,134 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
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
+		tcon->tidStatus = CifsGood;
+		tcon->need_reconnect = false;
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
+		strlcpy(tcon->treeName, tree, sizeof(tcon->treeName));
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
+				 (smb_buffer_response->WordCount == 7))
+			/* field is in same location */
+			tcon->Flags = le16_to_cpu(pSMBr->OptionalSupport);
+		else
+			tcon->Flags = 0;
+		cifs_dbg(FYI, "Tcon flags: 0x%x\n", tcon->Flags);
+	}
+	cifs_buf_release(smb_buffer);
+	return rc;
+}
+
 int
 CIFSSMBTDis(const unsigned int xid, struct cifs_tcon *tcon)
 {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d35474b836007..12205e2f04cda 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3628,135 +3628,6 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 }
 #endif
 
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
-		tcon->tidStatus = CifsGood;
-		tcon->need_reconnect = false;
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
-		strlcpy(tcon->treeName, tree, sizeof(tcon->treeName));
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
-	}
-
-	cifs_buf_release(smb_buffer);
-	return rc;
-}
-
 static void delayed_free(struct rcu_head *p)
 {
 	struct cifs_sb_info *cifs_sb = container_of(p, struct cifs_sb_info, rcu);
-- 
2.53.0

