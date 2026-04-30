Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FB23FE362;
	Thu, 30 Apr 2026 08:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=50.112.246.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777539476; cv=none; b=QH2NL8Dw+O7PIHRtTZXd08dO6788f9NeJRadLpA8X443Po/hU1Wg7ruaRsJS7WMLf2OaIehyxk77xbFmeTa1MhqVgyEJWAUC1Iro5T242nQK0enaXob2o2FJw5NsOKnHF0LKzNnwCl/fMRDDxDQ0yuLFrdLfiC4+tT4t+ocNgSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777539476; c=relaxed/simple;
	bh=OCHv4sNKD6FdjVg4X1i6KrqsmWVR5hjxcSUYjRoG4pA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sZD87U2Y0LXNAXo1qbBWmlO7GuhtuAm30KlieIx9iUEpIaziPu5MXW2HwzuLmplNQB3gg0cb89mjRwMh4itWwElqaNlEsKptgUGwQAprDlO9EoUS0esHk8DwOx1Wy+f3VWW2nh3MBu/z2sdJY4w5Ii5erfOZcfluIAa2BHVclcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=TWGwei1/; arc=none smtp.client-ip=50.112.246.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="TWGwei1/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1777539475; x=1809075475;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Hn9udz7Pvym1RgV7NCPW6AXSi4+7PUHyGB012LjVUYA=;
  b=TWGwei1/45oNJHrp3lvy+VAFOpMQSmwoZ2rqO3axJk5lxim/L5tTH9kA
   RVU9XrtHU/onaX7aUIt8gohoXh1NK5PiSa0uOAyloAIoKD/UKsYBVWo6B
   I9X6jFwyNUrlx7G7Bu/zM+oOhe8v7CFBoYdqK7wrbeCQN9ojwX1kdQ5O/
   ozzXjcVjklNx3rm69cG1OSCAelSDFcOGEZQrtycWzEY/leEao0GDBOliM
   d53b/SNQkFfFL4Jx/CjjDyaVBjNpWq/n1NjT7exa1pZC1xNz4TsMNmp6B
   AboyvwJ4G8Z8xVItKti07uOJpW9z5SpVfIm3Tf7vvcS/QGJGIZ161fyOP
   A==;
X-CSE-ConnectionGUID: UCavD6MDRRiX+ID+sjkW/w==
X-CSE-MsgGUID: SjeS+foHSViH+O/9vNPIFg==
X-IronPort-AV: E=Sophos;i="6.23,207,1770595200"; 
   d="scan'208";a="18367693"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 08:57:52 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:6652]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.37.224:2525] with esmtp (Farcaster)
 id 58b8f1a8-5a6f-4e28-ae21-c24da03d262c; Thu, 30 Apr 2026 08:57:52 +0000 (UTC)
X-Farcaster-Flow-ID: 58b8f1a8-5a6f-4e28-ae21-c24da03d262c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 30 Apr 2026 08:57:52 +0000
Received: from dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com (10.169.119.5)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 30 Apr 2026 08:57:50 +0000
From: Bjoern Doebel <doebel@amazon.de>
To: <sfrench@samba.org>
CC: Bjoern Doebel <doebel@amazon.de>, <stable@vger.kernel.org>, "Paulo
 Alcantara" <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, "Bharath
 SM" <bharathsm@microsoft.com>, Namjae Jeon <linkinjeon@kernel.org>, "open
 list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)"
	<linux-cifs@vger.kernel.org>, "moderated list:COMMON INTERNET FILE SYSTEM
 CLIENT (CIFS and SMB3)" <samba-technical@lists.samba.org>, open list
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] smb: client: use kzalloc to zero-initialize security descriptor buffer
Date: Thu, 30 Apr 2026 08:57:17 +0000
Message-ID: <20260430085731.1226229-1-doebel@amazon.de>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D041UWA004.ant.amazon.com (10.13.139.9) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Commit 62e7dd0a39c2d ("smb: common: change the data type of num_aces
to le16") split struct smb_acl's __le32 num_aces field into __le16
num_aces and __le16 reserved. The reserved field corresponds to Sbz2
in the MS-DTYP ACL wire format, which must be zero [1].

When building an ACL descriptor in build_sec_desc(), we are using a
kmalloc()'ed descriptor buffer and writing the fields explicitly using
le16() writes now. This never writes to the 2 byte reserved field,
leaving it as uninitialized heap data.

When the reserved field happens to contain non-zero slab garbage,
Samba rejects the security descriptor with "ndr_pull_security_descriptor
failed: Range Error", causing chmod to fail with EINVAL.

Change kmalloc() to kzalloc() to ensure the entire buffer is
zero-initialized.

Fixes: 62e7dd0a39c2d ("smb: common: change the data type of num_aces to le16")
Cc: stable@vger.kernel.org

Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Assisted-by: Kiro:claude-opus-4.6
[1] https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-dtyp/20233ed8-a6c6-4097-aafa-dd545ed24428
---
Tested using xfstests' generic/680 test on CIFS (Samba server
on localhost) with AL2023 ARM64 kernel 6.18.22 and 7.1.0-rc1.
Without the fix, the test fails after 10-40 iterations. With
the fix, we successfully completed 1,000 iterations.
---
 fs/smb/client/cifsacl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index ec5d477793040..a2750f1e3d90b 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1732,7 +1732,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 	 * descriptor parameters, and security descriptor itself
 	 */
 	nsecdesclen = max_t(u32, nsecdesclen, DEFAULT_SEC_DESC_LEN);
-	pnntsd = kmalloc(nsecdesclen, GFP_KERNEL);
+	pnntsd = kzalloc(nsecdesclen, GFP_KERNEL);
 	if (!pnntsd) {
 		kfree(pntsd);
 		cifs_put_tlink(tlink);
-- 
2.48.2




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

