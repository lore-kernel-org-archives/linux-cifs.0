Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D771B87F2;
	Tue, 31 Dec 2024 22:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735684630; cv=none; b=EEeoXvUnBbjKkEyJ1aX7pzOEIAeNmrtY6FPn3r4A7lOd0S7N0lRfmHS/vrHkbczcoD7fYt5xjI5RDgBS9dP4C88whaYQc1iUQhxB/FKsmXvtGT/5lrZe/O5YJeYwkKgEsTIZmRijO5I6a/eP3bVvW/UVGXi61AXFdtYW5TWUmRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735684630; c=relaxed/simple;
	bh=s1tawBVkNDFFClcfOVkRnxGeBPnAEZaUi3saaIWPAj4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YJlVYkeLGy5TKQmGHsE9hgeMEVlwYt6ZvzY9FNZ3hdoR6kJQ1RuZg3mVxLeYjIGtMZSiZVcUVgEKl7sVIXEYsbAiJWwlKszIWeATueDhRmNbo+NiIIktLcsF26lSiEqiAtq+crvkWA6tQsxznNypZgGeU36ZOxZ7cJmPWki3i6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pRFw+9ZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pRFw+9ZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF45C4CEDD;
	Tue, 31 Dec 2024 22:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735684630;
	bh=s1tawBVkNDFFClcfOVkRnxGeBPnAEZaUi3saaIWPAj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pRFw+9ZPNoC9wIIIUgv0pdhrfLre83v/2u+3QHLqgZDqHJOT4hc1h1LdLAe5mexzP
	 L8BNil5pdUxVDjevODS16HR0bYW/KmUExS1DICxppSegb+RIdp5nnlfX1hycuAg3uE
	 t9h/C5x4w8ZRODM7RT/sbL4YCIXDWfj54NJBqbJjQP/m3z5yFkBGbMNlKxehc2NT9H
	 pkzCUdTqLu4am7Q+4X4URtA/Dd/XYb7aeMmlAikAu1iVG374GNrkIuf+wR5GeFMg1Y
	 iUa77bF6MMqnZq2cMCx9Cr4lWfqGdo2QHIxA+6IHlKqB+00kK9o1ndWW7vMsT6QOyx
	 i+Mu5IOotJPLQ==
Received: by pali.im (Postfix)
	id 993D6FEC; Tue, 31 Dec 2024 23:37:01 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] cifs: Remove CIFSSMBSetPathInfoFB() fallback function
Date: Tue, 31 Dec 2024 23:36:42 +0100
Message-Id: <20241231223642.15722-12-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241231223642.15722-1-pali@kernel.org>
References: <20241231223642.15722-1-pali@kernel.org>
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
fallback via filehandle.

So the CIFSSMBSetPathInfoFB() is just code duplication, which is not needed
anymore. Therefore remove it.

This change depends on other changes which are extending
cifs_mkdir_setinfo() and smb_set_file_info() functions.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifssmb.c | 36 ------------------------------------
 1 file changed, 36 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index acbdb6d92306..9dc946138f18 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -5478,38 +5478,6 @@ CIFSSMBSetFileDisposition(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -5586,10 +5554,6 @@ CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
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

