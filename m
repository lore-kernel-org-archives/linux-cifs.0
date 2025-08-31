Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B42825BF18;
	Sun, 31 Aug 2025 12:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643795; cv=none; b=kgPUtRRmHj7z6XjdtGdE6nl4+gb72+cfOLt2EwLLxaPVsB+zXWpoAZd3ZS9TK158D1efKMSOJg+CGVsOx1zCuc+D4TYyyS8SWysYH+u9Gt1E295wEn9GsYz5BD/e7da6ZompbwjHNBidlWa+U2l1oOHdlsTznpNhqYi9PhV9rgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643795; c=relaxed/simple;
	bh=wBAUeZrOIYEFOy72ePFEAHGR9uOeu4N2neoE8ztNYoA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VHrzfvFVKL9JUdLn99iCsduUv0rSCCLKxSXEW9pX9UJfbNKHGEDrvXsnKE9Hmt/sUjDKscM5yke1UG7AanlnP5TppdWx3VF/F/OYXiim9Q4A4Ke5BR5v5sFGfDu20iLfsbIrlgRiZlAplnPOX4+VDHtpEum1zheWSAgdY2r+FSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pM0smwug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pM0smwug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78F6C4CEF8;
	Sun, 31 Aug 2025 12:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643795;
	bh=wBAUeZrOIYEFOy72ePFEAHGR9uOeu4N2neoE8ztNYoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pM0smwugvCwjBRTJQxInP7tHWyGA6ZTDWUzgARrw9ZpGYohayL1CWzvGz+QZL9+VQ
	 5q/KHvDg2cJjMjMUN9FbRHVfrEawLlMJtgWxLVMSoQeGG1V1RpxQuMbG+m/gdWXcem
	 BvL6ifzw6PiS5Yq6LmkY+XiBDo6pRtNTPOFuazAsBHU5N798TPtfkyiSlDJOPlmDBo
	 ww47vjMtTmhN9M7Gqn8Qdo/iGuR23L1OCNDsXML9WNgDW5sYoVdeEmKMnxJs44IPAE
	 vddP5yRH+00iMKh3vj2IGyYg/LehhmyWD1oi/D/GSK9eEmgWBv3wF5yXu6VC0Q9Hv9
	 FV/OYKa3n2gOQ==
Received: by pali.im (Postfix)
	id 969EFF96; Sun, 31 Aug 2025 14:36:31 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 05/35] cifs: Remove CIFSSMBSetPathInfoFB() fallback function
Date: Sun, 31 Aug 2025 14:35:32 +0200
Message-Id: <20250831123602.14037-6-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250831123602.14037-1-pali@kernel.org>
References: <20250831123602.14037-1-pali@kernel.org>
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
cifs_mkdir_setinfo() and smb_set_file_info() functions:
"Fix changing times and read-only attr over SMB1 smb_set_file_info()
function" and "Add fallback code path for cifs_mkdir_setinfo()"

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifssmb.c | 36 ------------------------------------
 1 file changed, 36 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 42ab901a08e7..0d773860fd6c 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -5518,38 +5518,6 @@ CIFSSMBSetFileDisposition(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -5626,10 +5594,6 @@ CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
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

