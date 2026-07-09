Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE38642F6FF;
	Thu,  9 Jul 2026 15:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.13.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783612506; cv=none; b=irjTaoZPNw4577aa1xLCovBn69Vd8+5/foe/YHW0EuL74zkkJ540xLGGtDT2Q8BnVrFlsegWnC0YGOYZaRXv9rs7BKcxxoKawCVBB3KlLXaTg92cCMPsgHCwxAJ4yf9QQXvlrThx/RtrSsq5ieewpDN+ktTodhKCCapV+BfWkDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783612506; c=relaxed/simple;
	bh=UQMNLf5pUz+gEnbUY8PbpD7gCW8qa0clJYZeKo4VVOs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ly31vLqFcDPPTDuvNPg/m2nPesJLCI5ei0hYNjgUU9uncLN6nRILUk/RtGHAD/qdptanUe8rRRaYDHqDz4b7vv3C53hdwIWpCh6JqeRR/FV2SHjbp4IAlKtkmKa1mcGLS9WbXeBQRh2bFJj2f+TLXRAtFBW8KYiMl24ievRLcts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=kiysJFvo; arc=none smtp.client-ip=52.13.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="kiysJFvo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1783612505; x=1815148505;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KpsSYm0NQHbrBccVG4kK8wVYLPm1aRgnUuanForo09Q=;
  b=kiysJFvouRnRT+Urmr/GDXGxqLpskwCvawHqmdH/ThYJIouNpQnq13Xr
   cMZUKK+NxCL0Ob16Y+jPyH1pDOkiQ+UPGv2p+653OFaXU67mH56riB1aS
   uAR64ax2kR9VzlxWzNecFJ9JOAaSV6QkMgC0Y5ScuCGr9VfbL8JGr6a/b
   EYIZ7zDyG3/C4ezdHWGS3oPf6FZ2hDLvm+lIqv295iyJLHnHj30VjLszJ
   3g5cpNnYUIXmj2Q9s7xQzuvWrOEfSVUq8rfzvgeQtClNHtMapiRmLEer5
   NLfO+pF1SBdsP7WYqRkrFeQCh+x/MTLWA5jUvbO2oRm9ZpWgFMzar9sCC
   w==;
X-CSE-ConnectionGUID: 3Ffw+E5gTEWk6CuCwrbLeQ==
X-CSE-MsgGUID: 2lrhdtYDQS67dp4iaqAZPg==
X-IronPort-AV: E=Sophos;i="6.25,154,1779148800"; 
   d="scan'208";a="23358795"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 15:55:01 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:17990]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.58.33:2525] with esmtp (Farcaster)
 id 846c0b8b-2925-4351-abfa-2f765fd40457; Thu, 9 Jul 2026 15:55:01 +0000 (UTC)
X-Farcaster-Flow-ID: 846c0b8b-2925-4351-abfa-2f765fd40457
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 9 Jul 2026 15:55:00 +0000
Received: from dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com (10.169.119.5)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 9 Jul 2026 15:54:59 +0000
From: Bjoern Doebel <doebel@amazon.de>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
	<sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
	<bharathsm@microsoft.com>, <linux-cifs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <samba-technical@lists.samba.org>
CC: <stable@vger.kernel.org>, <doebel@amazon.de>, <nmanthey@amazon.de>
Subject: [PATCH] smb: client: set SB_I_NODEV to prevent device node injection
Date: Thu, 9 Jul 2026 15:54:40 +0000
Message-ID: <20260709155440.2132459-3-doebel@amazon.de>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D033UWA002.ant.amazon.com (10.13.139.10) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

From: Norbert Manthey <nmanthey@amazon.de>

Set SB_I_NODEV on the superblock by default for CIFS mounts. This is
consistent with how other filesystems handle untrusted remote content
and prevents the server side from injecting device nodes on the client.

Fixes: 2e4564b31b645 ("smb3: add support for stat of WSL reparse points for special file types")
Signed-off-by: Norbert Manthey <nmanthey@amazon.de>
Assisted-by: Kiro:claude-opus-4.6
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index ea4fc0fa68cac..35eee2f9899d5 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -208,6 +208,9 @@ cifs_read_super(struct super_block *sb)
 	if (sbflags & CIFS_MOUNT_POSIXACL)
 		sb->s_flags |= SB_POSIXACL;
 
+	/* Prevent device node opens from remote filesystem by default */
+	sb->s_iflags |= SB_I_NODEV;
+
 	if (tcon->snapshot_time)
 		sb->s_flags |= SB_RDONLY;
 
-- 
2.50.1

