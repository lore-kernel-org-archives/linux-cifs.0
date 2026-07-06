Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB55B3C553C;
	Mon,  6 Jul 2026 18:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783363737; cv=none; b=YNmelC5l6q8SQYkYz0LV0IYbuot1mGv796HFYInYsGce4cFV66Dyh1b76lF2k3gxVHYat7A9u3XMF6YsDKVttG424jhfoFq8B6gUowi0YxUt2t1dr2IXo7oURyqFzRzyt0yo/PF0U1KHGyXDFlcS4z6rmKvsJFyI7pTt5ObC0O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783363737; c=relaxed/simple;
	bh=9IfxgVrH+En7a8AcDP36XYZ+D0qf8RF3PyEDzvqOZaA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JNhuRmfdG2Q6NW9z6zQyZFrl2UFLk3bUldpFul0Tgj2flLyV7F0dxcBnBhis1ey1aD4vnd4fevdwuBh3JJNF5gf57nFGIj4n+ZVedcKCLFbcY0TUTPZsFXspJhYDEg6LJnVNa9ZUozjDjm4VN01wTB4N9L2hQQlZ2R/8H1uNRFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ICuP+g7H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ICuP+g7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83451F00A3A;
	Mon,  6 Jul 2026 18:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783363719;
	bh=Vxn+vS1k9jNleOA7QdgLCqCI0o/R6HJ5ycnSoPgwtss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ICuP+g7H/q3il7twvCkXK2alRfzUbTi3iCgqFfmY15SESTqSyNG1ngJmWFmzAmLjw
	 rjDkMg/PgCRD0Ay5wt+a0VyOYahVbRiCBpgN80Mz7kzR/RNLyOQYA63NPqzVXOOeUP
	 QqkWKI2ehI6pPn1Q7nW/9pnW8SlqTYXkZSiOpr4SjxvLNbem8pxrNzia8p8/hPR39y
	 zuayai8b9oj8drCRPRPKQV1dpJcElFHGSTgxzXyJUYwxO0S88Tj/ETlDuIXtfidvAG
	 lvJeyckSMsSymvf1TJ/ZZeumA0FBwXryloYwdwt/oPMRAsm8igbyI8wZv3X7kH8Jna
	 IQHEKzjI74Iaw==
Received: by pali.im (Postfix)
	id 82F03C8E; Mon,  6 Jul 2026 20:48:34 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 03/11] cifs: Remove CIFSSMBSetPathInfoFB() fallback function
Date: Mon,  6 Jul 2026 20:48:11 +0200
Message-Id: <20260706184819.22124-4-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260706184819.22124-1-pali@kernel.org>
References: <20260706184819.22124-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This fallback function CIFSSMBSetPathInfoFB() is called only from
CIFSSMBSetPathInfo() function. CIFSSMBSetPathInfo() is used in
smb_set_file_info() which contains all required fallback code, including
fallback via filehandle, since commit f122121796f9 ("cifs: Fix changing
times and read-only attr over SMB1 smb_set_file_info() function") and
commit 92210ccd877b ("cifs: Add fallback code path for cifs_mkdir_setinfo()").

So the CIFSSMBSetPathInfoFB() is just code duplication, which is not needed
anymore. Therefore remove it.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifssmb.c | 36 ------------------------------------
 1 file changed, 36 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index d7a6955d904e..a2f3a1582cee 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -5812,38 +5812,6 @@ CIFSSMBSetFileDisposition(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
-static int
-CIFSSMBSetPathInfoFB(const unsigned int xid, struct cifs_tcon *tcon,
-		     const char *fileName, const FILE_BASIC_INFO *data,
-		     const struct nls_table *nls_codepage,
-		     struct cifs_sb_info *cifs_sb)
-{
-	int oplock = 0;
-	struct cifs_open_parms oparms;
-	struct cifs_fid fid;
-	int rc;
-
-	oparms = (struct cifs_open_parms) {
-		.tcon = tcon,
-		.cifs_sb = cifs_sb,
-		.desired_access = GENERIC_WRITE,
-		.create_options = cifs_create_options(cifs_sb, 0),
-		.disposition = FILE_OPEN,
-		.path = fileName,
-		.fid = &fid,
-	};
-
-	rc = CIFS_open(xid, &oparms, &oplock, NULL);
-	if (rc)
-		goto out;
-
-	rc = CIFSSMBSetFileInfo(xid, tcon, data, fid.netfid, current->tgid);
-	CIFSSMBClose(xid, tcon, fid.netfid);
-out:
-
-	return rc;
-}
-
 int
 CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 		   const char *fileName, const FILE_BASIC_INFO *data,
@@ -5922,10 +5890,6 @@ CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc == -EAGAIN)
 		goto SetTimesRetry;
 
-	if (rc == -EOPNOTSUPP)
-		return CIFSSMBSetPathInfoFB(xid, tcon, fileName, data,
-					    nls_codepage, cifs_sb);
-
 	return rc;
 }
 
-- 
2.20.1

