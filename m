Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960201F7094;
	Fri, 27 Dec 2024 17:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735321275; cv=none; b=rQP9SG0krk7WMiEGvAjrxUEAB9sDG/67qimUYdH2NrIBQdsQBk/vlOBizJcln/oO4xZonmtPsuxy/9IHIgchej63q9nBCkdSVwd6tMWhwkHuRcR0b6hE5wCTMoyFPtyldtfPRiUchjDoyI/IlvGOB97yrrGo6WZojqRXBQ731qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735321275; c=relaxed/simple;
	bh=WNEeVNcPRz5TC7Suf6e8YS/I4gjtN/vDdmjJON198+Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=iTgU6p4joDkikpE4eYQUCQad0i8htR8DlkfXJBp4tvnxwYvz9bx8fX1SvzqmULFBqXgCnQs8hhdzCki6pQIGZOuNq7lLqdLmOkNeAeWqi2OEHvfQoKjhSljwUSTQbvYy2odydiWAt2K5S3t5yDdqyAig2FLcC+sa7/KOqHSmJ70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qws0P5FL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qws0P5FL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497ABC4CED0;
	Fri, 27 Dec 2024 17:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735321275;
	bh=WNEeVNcPRz5TC7Suf6e8YS/I4gjtN/vDdmjJON198+Q=;
	h=From:To:Cc:Subject:Date:From;
	b=Qws0P5FLd6oHr93Eu4Rhq2LGK2i4gvWMvdVz6m6DsvToR3cDZfE8i57VyKoihbvfs
	 F/QDTq7zdCQD63EVnpRsOIRyALaaEA+/Cjme/7mGVpR/DEzV1l89pTB77Dy6DMjvhx
	 Iv8jvaHNY9BQTf531cYc6SBVDhKVh2hbad8snOEUSjopkIUomOhsIvcBYfR3MdMsd5
	 dwYFxte38/hwn6d4dmb1RJitw/zeO0LuqRL9SUF0x1EEMUWgiGsRKwe53uKqTTCvR0
	 ZRuq1DUzD74AIduKG62qsyb/jrBzt4anbwzx4YpLW0f5eWalYCzFw47uH8F+I3FBGQ
	 1ZgOtwv0X/3rg==
Received: by pali.im (Postfix)
	id 88DD0787; Fri, 27 Dec 2024 18:41:05 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] cifs: Remove declaration of dead CIFSSMBQuerySymLink function
Date: Fri, 27 Dec 2024 18:40:45 +0100
Message-Id: <20241227174047.23030-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Function CIFSSMBQuerySymLink() was renamed to cifs_query_reparse_point() in
commit ed3e0a149b58 ("smb: client: implement ->query_reparse_point() for
SMB1"). Remove its dead declaration from header file too.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsproto.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index f0ca99e6090c..9833837c6299 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -477,9 +477,6 @@ extern int cifs_query_reparse_point(const unsigned int xid,
 				    const char *full_path,
 				    u32 *tag, struct kvec *rsp,
 				    int *rsp_buftype);
-extern int CIFSSMBQuerySymLink(const unsigned int xid, struct cifs_tcon *tcon,
-			       __u16 fid, char **symlinkinfo,
-			       const struct nls_table *nls_codepage);
 extern int CIFSSMB_set_compression(const unsigned int xid,
 				   struct cifs_tcon *tcon, __u16 fid);
 extern int CIFS_open(const unsigned int xid, struct cifs_open_parms *oparms,
-- 
2.20.1

