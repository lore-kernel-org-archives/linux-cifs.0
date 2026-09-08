Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4254534460;
	Tue,  8 Sep 2026 12:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788870026; cv=none; b=lix8ST3UhjtMne++mhRZ0OVqvePad4ytNcp4k66qCVX5vQmKwWbQZvkNJ6iLTYM/L9BpYWlaPDlTceDH/gZy0zdzRPILhwIz7FbPj32OuGVmdO2/yRgaJxA7quv+hTKYQY7DChMydyklg14Ve9TRafXXCQiUFvy+rvtDYacYuCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788870026; c=relaxed/simple;
	bh=byAJOdTpBF4CGlWDA5AzH0j6A2+DrEKRxxsIboe9xrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLjiZBAJT0tnTb2k3kK6dcXN5mYx+jBZf551cmLw1qCLl8m2HTtPQa7QpuwcS3sZL/eDmk1ywCAi+UPTl7Kj1E7DvrvceYemWHvV4rYO1MiC88sPpXJDWAnMd49+Eyqufqlgfk38vQdk0eLXoKHqXeNfr6OyRVkaWK4D7ynRBVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OkLMwUgT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OkLMwUgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EF21F00A3A;
	Tue,  8 Sep 2026 12:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788870018;
	bh=RfmNEGjJsS/8c2GKuZ5ounjH9LtPffgjWi3vpyDzxbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OkLMwUgTKFv4raOZUv4p+4J63le4/YXeU13EuJBy1LqxqbdNNHtlicHzn+Kplyz5L
	 qUAK1hFZwfaRlbV135r2cvtZEYxww0H9xjjk4AJAzztAcJOspXAXm3wOMJ/5DT5cs0
	 slbNhAQxRKrN5LTFC/H72y+/yROHVWxrMDCtf8gUNgK05WWcoi5dPopCXL5x9TnsGE
	 uiP/7ink7TysEMkobIZA8Naq4SIbe38Ue0FlUYK8+mboRoX1S6cjPM7T9nMmisYLvn
	 sFuBPM3L79pjse8K767ewj9vTC+93698Dd/CysrnKmdidUva4WoOn5y53rVauTALEX
	 hVXbtTGMYL4lQ==
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
Subject: [PATCH 5.10.y 1/2] cifs: SMB1 split: connect.c
Date: Tue,  8 Sep 2026 08:20:14 -0400
Message-ID: <20260908122015.2050174-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026090337-crease-stuffing-cff2@gregkh>
References: <2026090337-crease-stuffing-cff2@gregkh>
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
 fs/cifs/cifssmb.c | 161 +++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/connect.c | 162 ----------------------------------------------
 2 files changed, 161 insertions(+), 162 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 67ff1669cab2a..e69ab38a648d2 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -699,6 +699,167 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
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
+	if (tcon->pipe || (ses->server->sec_mode & SECMODE_USER)) {
+		pSMB->PasswordLength = cpu_to_le16(1);	/* minimum */
+		*bcc_ptr = 0; /* password is null byte */
+		bcc_ptr++;              /* skip password */
+		/* already aligned so no need to do it below */
+	} else {
+		pSMB->PasswordLength = cpu_to_le16(CIFS_AUTH_RESP_SIZE);
+		/* BB FIXME add code to fail this if NTLMv2 or Kerberos
+		   specified as required (when that support is added to
+		   the vfs in the future) as only NTLM or the much
+		   weaker LANMAN (which we do not send by default) is accepted
+		   by Samba (not sure whether other servers allow
+		   NTLMv2 password here) */
+#ifdef CONFIG_CIFS_WEAK_PW_HASH
+		if ((global_secflags & CIFSSEC_MAY_LANMAN) &&
+		    (ses->sectype == LANMAN))
+			calc_lanman_hash(tcon->password, ses->server->cryptkey,
+					 ses->server->sec_mode &
+					    SECMODE_PW_ENCRYPT ? true : false,
+					 bcc_ptr);
+		else
+#endif /* CIFS_WEAK_PW_HASH */
+		rc = SMBNTencrypt(tcon->password, ses->server->cryptkey,
+					bcc_ptr, nls_codepage);
+		if (rc) {
+			cifs_dbg(FYI, "%s Can't generate NTLM rsp. Error: %d\n",
+				 __func__, rc);
+			goto out;
+		}
+
+		bcc_ptr += CIFS_AUTH_RESP_SIZE;
+		if (ses->capabilities & CAP_UNICODE) {
+			/* must align unicode strings */
+			*bcc_ptr = 0; /* null byte password */
+			bcc_ptr++;
+		}
+	}
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
+out:
+	cifs_buf_release(smb_buffer);
+	return rc;
+}
+
 int
 CIFSSMBTDis(const unsigned int xid, struct cifs_tcon *tcon)
 {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a95b9d2318fa2..16bc181a25647 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4838,168 +4838,6 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
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
-	if (tcon->pipe || (ses->server->sec_mode & SECMODE_USER)) {
-		pSMB->PasswordLength = cpu_to_le16(1);	/* minimum */
-		*bcc_ptr = 0; /* password is null byte */
-		bcc_ptr++;              /* skip password */
-		/* already aligned so no need to do it below */
-	} else {
-		pSMB->PasswordLength = cpu_to_le16(CIFS_AUTH_RESP_SIZE);
-		/* BB FIXME add code to fail this if NTLMv2 or Kerberos
-		   specified as required (when that support is added to
-		   the vfs in the future) as only NTLM or the much
-		   weaker LANMAN (which we do not send by default) is accepted
-		   by Samba (not sure whether other servers allow
-		   NTLMv2 password here) */
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
-		if ((global_secflags & CIFSSEC_MAY_LANMAN) &&
-		    (ses->sectype == LANMAN))
-			calc_lanman_hash(tcon->password, ses->server->cryptkey,
-					 ses->server->sec_mode &
-					    SECMODE_PW_ENCRYPT ? true : false,
-					 bcc_ptr);
-		else
-#endif /* CIFS_WEAK_PW_HASH */
-		rc = SMBNTencrypt(tcon->password, ses->server->cryptkey,
-					bcc_ptr, nls_codepage);
-		if (rc) {
-			cifs_dbg(FYI, "%s Can't generate NTLM rsp. Error: %d\n",
-				 __func__, rc);
-			cifs_buf_release(smb_buffer);
-			return rc;
-		}
-
-		bcc_ptr += CIFS_AUTH_RESP_SIZE;
-		if (ses->capabilities & CAP_UNICODE) {
-			/* must align unicode strings */
-			*bcc_ptr = 0; /* null byte password */
-			bcc_ptr++;
-		}
-	}
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
 	struct cifs_sb_info *sbi = container_of(p, struct cifs_sb_info, rcu);
-- 
2.53.0

