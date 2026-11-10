Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794351265;
	b=Nadj7sVOXYA4SbdJCrxHigQGohjrzuAbRmhpzheZ1Y5s1CgD+lauiQnCRqbw1ugyc7lI
	 JYF5rM2fMtIeRffCXbFRgEjdL4/k1eX6id02TGXmskjOkBY7BeCpv4hKDOW/pPq1oZLnZ
	 3OcJI0A85wYhgd4ze3ZLYBsr98gfGjKnClsVBg9AFMw8fxL8Zy6LadqgMxumxFIeWXzG+
	 qM87RNKD/hGPPRu0bHdV8isL02lwYaTk4sNxc5lO39oeWETlQt7k5jB6WknslwxPgxReY
	 1SWqTyCNBVKctFKru8Vy7gBzIW/+6sF4BP0skSec4mMiOJ3srxhyHIGamKpsns0t2lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794351265;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=j1oBxkPwUpgBKy1iCQWPCWd1bWrJpA4UCQ72t10f3R4=;
	b=se1ZPVPIVyZGGiKTm/VGw3bRnfaMG+dGWRuQMVL2+LvMS5oqHyt2uHDj1akcnHWd2ORf
	 3WTjqf858r7UFKNhZl2PPilkSM/afZF9pnKpZj/TE+HkGR8kfU2ac6sOHZ5YY9ySu3kTZ
	 NLvBKhCu68bJW/ZWNaS5ERnwASoFkpCeVZGyuvV2y/7Lyo9sXhBuVDMrv9cAuzce/qOAK
	 3EacfbmGBLRvdiEopMUn+u+MKVHl8DyhoVvuTMWfHujKtuRa7YIU4BslAkSaqFeCQMwcR
	 zVZ6KJlaxxgMrhOiH3HMCzbkNiYm0kKqGWsMnpDywf3KtkUgS0vZXdFXDuIqojjrELw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=pm0QFuNg;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC7C606A320;
	Tue, 10 Nov 2026 22:54:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6BC7C606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=pm0QFuNg
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=j1oBxkPwUpgBKy1iCQWPCWd1bWrJpA4UCQ72t10f3R4=; b=pm0QFuNgy1KEMcj30C+rEGO3iq
	s1t0szOG2z166fuh6aMjAmXCVj77gZ/NdP9+VDYdtPnvR2LpfkHwcCNdFF3tkXR5Bbd1onp7anSJK
	PLsBg9qheX6/X1F6HgebmDmSX9Tw8lqQxHp/ZeDdhMWXCjADKsjISE9uqQj6cSl0SXPpH1fKUqcuT
	mjpy30f599EJmF8ymIELFhUCh+2PpMHHqHaLqzGPwZSTD8/0GHtdc9vMsJK0y4AyhcNq2zBn/WGwb
	LqjkuTez3lBNLtn6mHnTerRMAD3RY9RDLRHiajxLBaXluDkBsAFaCg1GJKAz+6BN6xsB1WPo8w8zL
	fNFTbeIg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xQujD-00000001PHK-39RQ;
	Tue, 10 Nov 2026 19:54:12 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Giuseppe Piscitelli <ooonea@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] smb: client: retry a hard link open without a lease
Date: Tue, 10 Nov 2026 19:54:11 -0300
Message-ID: <20261110225412.3937476-1-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Opening a hard link of a file that currently holds a lease fails with
EINVAL over SMB3.  The client caches lease keys per inode, but the server
ties a lease to the file name it was granted under, so reusing the inode's
lease key to open a different name of the same inode is rejected with
STATUS_INVALID_PARAMETER (MS-SMB2 3.3.5.9.11).

Resend the open without a lease when it is rejected that way, as
smb2_rename_path() already does.  Reacting to the server response covers
every case - including a name kept open by an active handle - without
racing a handle opened concurrently.

Reported-by: Giuseppe Piscitelli <ooonea@gmail.com>
Closes: https://lore.kernel.org/r/CACmoRBbDZR3eyEM65j73sWMS7A=T89z1QAvCP=+u0WGzZhwW6g@mail.gmail.com
Fixes: 262b73ef442e ("smb3 client: fix open hardlink on deferred close file error")
Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
---
 fs/smb/client/smb2file.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index 764cfd894ad0..1e671005e83b 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -214,6 +214,19 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, data, NULL, &err_iov,
 			       &err_buftype);
 	}
+	if (rc == -EINVAL && smb2_oplock != SMB2_OPLOCK_LEVEL_NONE &&
+	    !oparms->pending) {
+		cifs_dbg(FYI, "%s: invalid lease key, resending request without lease\n",
+			 __func__);
+		free_rsp_buf(err_buftype, err_iov.iov_base);
+		memset(&err_iov, 0, sizeof(err_iov));
+		err_buftype = CIFS_NO_BUFFER;
+		smb2_oplock = SMB2_OPLOCK_LEVEL_NONE;
+		oparms->reconnect = reconnect;
+		oparms->replay = false;
+		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock,
+			       data, NULL, &err_iov, &err_buftype);
+	}
 	if (rc && data) {
 		struct smb2_hdr *hdr = err_iov.iov_base;
 
-- 
2.56.0

