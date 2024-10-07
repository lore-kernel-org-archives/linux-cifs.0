Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A6E18B49F;
	Mon,  7 Oct 2024 21:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728334948; cv=none; b=k7z9c1EpM0LGUL5JgRyvq1V5QKXjHCry8Nm7ZShPXbTGfCJHNaPclMmlwL81ehqqaoW4/YQ86j2L+8dFm9IVJEPGwecxVuHx9ymK9fEURJuyRYPsVuoNpcHLNeo3NTpuewxDgqhsMExNVXDVcO7d8cNAOA3lST1HPYmNtaN2j3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728334948; c=relaxed/simple;
	bh=x3iuxUGYBDJdguLGcVfIWHEDbyDluY+QhQw5KcVjS8E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MzJ/OfoadeQ/VBNFYhO+QTOBFXwHrClf3RX2OIeEw7uVKjf31ePbyejZF27/1vJ50T+qlrqaHuGw8IOvOGvAfubkfKoPvX5PGRcY7i/hTaaoaRyyDGtifiqrZ1bYiu5VFSt7JUCQllkKNoz4Z+93iOPi6YWKsXgI5nlroyfRb8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=fYguzmED; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="fYguzmED"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=BgNI02FwVrxZc6jGpuXhD1WQZMR+xKms3qEKTvvbgPI=; b=fYguzmEDJMAEpZXc
	epo/SqqAE0lf+i8TPMHCyXP4ZAal2idJszUIhA9Sh4mXLdxmEummVgj0dJlB5If20r/kNz2G02Uhw
	FN8mXNychtC5TpoCAQ1GMs8V8e9pZYwukOyfmdzrkt7bA2V924ZjV2C5bYCJeISCHKG4tOneit3Nw
	BC54Hcvp3bOev7QuZu9NU8+g+lF+eB7xOtgLxgXUwZ3/LYgnSf8QrvqWm1CYVjyqHdBhIr8/KTIyh
	izwaRV3aux2pD81dPWJtuBUkicecYVKuqBnLogXJ3nwzzVhxS3fyIPU8YKqyu7KPyBmmbqaKnlJSQ
	xnsMOkLGL0QafM+cNA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1sxurv-009ZIn-2l;
	Mon, 07 Oct 2024 21:02:15 +0000
From: linux@treblig.org
To: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] cifs: Remove pre-historic unused CIFSSMBCopy
Date: Mon,  7 Oct 2024 22:02:14 +0100
Message-ID: <20241007210214.102568-1-linux@treblig.org>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

CIFSSMBCopy() is unused, remove it.

It seems to have been that way pre-git; looking in a historic
archive, I think it landed around May 2004 in Linus'
BKrev: 40ab7591J_OgkpHW-qhzZukvAUAw9g
and was unused back then.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 fs/smb/client/cifsproto.h |  7 -----
 fs/smb/client/cifssmb.c   | 63 ---------------------------------------
 2 files changed, 70 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 1d3470bca45e..8235b5a0aa2b 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -549,13 +549,6 @@ extern int generate_smb311signingkey(struct cifs_ses *ses,
 				     struct TCP_Server_Info *server);
 
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-extern int CIFSSMBCopy(unsigned int xid,
-			struct cifs_tcon *source_tcon,
-			const char *fromName,
-			const __u16 target_tid,
-			const char *toName, const int flags,
-			const struct nls_table *nls_codepage,
-			int remap_special_chars);
 extern ssize_t CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
 			const unsigned char *searchName,
 			const unsigned char *ea_name, char *EAData,
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index c6f15dbe860a..ca50ac652e02 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2339,69 +2339,6 @@ int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *pTcon,
 	return rc;
 }
 
-int
-CIFSSMBCopy(const unsigned int xid, struct cifs_tcon *tcon,
-	    const char *fromName, const __u16 target_tid, const char *toName,
-	    const int flags, const struct nls_table *nls_codepage, int remap)
-{
-	int rc = 0;
-	COPY_REQ *pSMB = NULL;
-	COPY_RSP *pSMBr = NULL;
-	int bytes_returned;
-	int name_len, name_len2;
-	__u16 count;
-
-	cifs_dbg(FYI, "In CIFSSMBCopy\n");
-copyRetry:
-	rc = smb_init(SMB_COM_COPY, 1, tcon, (void **) &pSMB,
-			(void **) &pSMBr);
-	if (rc)
-		return rc;
-
-	pSMB->BufferFormat = 0x04;
-	pSMB->Tid2 = target_tid;
-
-	pSMB->Flags = cpu_to_le16(flags & COPY_TREE);
-
-	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
-		name_len = cifsConvertToUTF16((__le16 *) pSMB->OldFileName,
-					      fromName, PATH_MAX, nls_codepage,
-					      remap);
-		name_len++;     /* trailing null */
-		name_len *= 2;
-		pSMB->OldFileName[name_len] = 0x04;     /* pad */
-		/* protocol requires ASCII signature byte on Unicode string */
-		pSMB->OldFileName[name_len + 1] = 0x00;
-		name_len2 =
-		    cifsConvertToUTF16((__le16 *)&pSMB->OldFileName[name_len+2],
-				       toName, PATH_MAX, nls_codepage, remap);
-		name_len2 += 1 /* trailing null */  + 1 /* Signature word */ ;
-		name_len2 *= 2; /* convert to bytes */
-	} else {
-		name_len = copy_path_name(pSMB->OldFileName, fromName);
-		pSMB->OldFileName[name_len] = 0x04;  /* 2nd buffer format */
-		name_len2 = copy_path_name(pSMB->OldFileName+name_len+1, toName);
-		name_len2++;    /* signature byte */
-	}
-
-	count = 1 /* 1st signature byte */  + name_len + name_len2;
-	inc_rfc1001_len(pSMB, count);
-	pSMB->ByteCount = cpu_to_le16(count);
-
-	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
-		(struct smb_hdr *) pSMBr, &bytes_returned, 0);
-	if (rc) {
-		cifs_dbg(FYI, "Send error in copy = %d with %d files copied\n",
-			 rc, le16_to_cpu(pSMBr->CopyCount));
-	}
-	cifs_buf_release(pSMB);
-
-	if (rc == -EAGAIN)
-		goto copyRetry;
-
-	return rc;
-}
-
 int
 CIFSUnixCreateSymLink(const unsigned int xid, struct cifs_tcon *tcon,
 		      const char *fromName, const char *toName,
-- 
2.46.2

