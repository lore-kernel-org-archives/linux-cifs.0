Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB703EBF02;
	Fri,  4 Sep 2026 10:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518577; cv=none; b=jpig1krTe9MMtRK8gv4BLsDsZY6s64QJVc2o6RKLvGjqJ/6wdMo5r29ZWIeEcFoqPbJwVqca7jxvYF+Bv1O5itOUJnuYm2XPlknYov1pxzBeVxERseAS/Xg8vtSIvyJZo0zRnv1XYfFaZKKIZXCxiNaaFvOCbun7ZFzPsYhcBro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518577; c=relaxed/simple;
	bh=Y8UTqHVFs/r62sanvMXXP9+HJolAKZbONmVh+mhmW0o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nbjILhniKHTbdFjYZbaU1FvU0bk4kAIxhpruK3M7c1syuAcHzksx88w9Bg2V7guDyPYDnokKerFDyx34olPsMbhOmYJ8SuiKiiZTvG1rjHt99QQebv6/iXFDBECQvYfm8AP8KyoqusBh5HzlVuiUnGku32xjIJKl3QhUuOi9BWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=HM232USl; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="HM232USl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1788518576; x=1820054576;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cBCALBt8dP5FYvLBAGh85PuC3GAiNBF8WE57CqvCcoM=;
  b=HM232USlgjn/qNLnOs23dj0FfxYa2YKxVPXi8cxahRUTrh8MHuc+PihA
   6847FDoA3cfWCUD17Zg9a8YPO+JZYOrNvLRL9UBb1Syw79WOh1Lr6/xYc
   v8xickXpDCznO035htVbBp9BekezlbMc33aYSKHaegzXty6RK0RfF6tqf
   9VgqvhTZY6vMOkmga2lKP+GFrkd4M7N0qF8Xr6J5zX3JMK21DdFI4Xwf+
   lmufjWSJZtHRAjDB3acv6JZTITb32d0osbDckY09LN1yJv4y2NHpG+3g/
   iIVi+otA2f/+Z1iVk0OXeF/rSTUmB9lFYnkCb1MxCka5YnefkkOVmGsP7
   A==;
X-CSE-ConnectionGUID: fUVXw/NBT2GWluzFoxATqg==
X-CSE-MsgGUID: 5uk5q8UrRwqbMB9C6o6yVA==
X-IronPort-AV: E=Sophos;i="6.25,260,1779148800"; 
   d="scan'208";a="27716154"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 10:42:53 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:28466]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.14.124:2525] with esmtp (Farcaster)
 id 09f58dd1-d0d9-4aa6-94d7-0237688b3269; Fri, 4 Sep 2026 10:42:53 +0000 (UTC)
X-Farcaster-Flow-ID: 09f58dd1-d0d9-4aa6-94d7-0237688b3269
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Fri, 4 Sep 2026 10:42:53 +0000
Received: from dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com (10.169.119.5)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Fri, 4 Sep 2026 10:42:51 +0000
From: Bjoern Doebel <doebel@amazon.de>
To: Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>
CC: <stable@vger.kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, "Bharath
 SM" <bharathsm@microsoft.com>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, <linux-kernel@vger.kernel.org>,
	<doebel@amazon.de>
Subject: [PATCH] smb: client: avoid leaking refcount when cifs_sb_tlink() fails
Date: Fri, 4 Sep 2026 10:42:36 +0000
Message-ID: <20260904104236.1603533-1-doebel@amazon.de>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D036UWC001.ant.amazon.com (10.13.139.233) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

cifs_oplock_break() takes over the reference that
cifs_queue_oplock_break() acquired when it queued the work, and drops it
with _cifsFileInfo_put() once the break has been processed.

Only in setups with "-o multiuser", cifs_sb_tlink() may fail, at which
point cifs_oplock_break() returns without putting the file reference,
mirroring the reference leak we already fixed in the companion patch to
cifs_queue_oplock_break().

This would trigger a crash due to busy inodes on the next unmount:

  BUG: Dentry ... still in use (1) [unmount of cifs cifs]
  VFS: Busy inodes after unmount of cifs (cifs)

Drop the reference on that path as well. Doing so before the out label
mirrors the normal path, which also puts the reference before
cifs_done_oplock_break().

Found by Sashiko code review. The failure path was not exercised at
runtime.

Fixes: e8f5f849ffce2 ("cifs: fix potential oops in cifs_oplock_break")
Cc: stable@vger.kernel.org
Assisted-by: Kiro:claude-opus-5
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
---
 fs/smb/client/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index d7b0a9512dfa3..27b58d9072034 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3348,8 +3348,11 @@ void cifs_oplock_break(struct work_struct *work)
 			TASK_UNINTERRUPTIBLE);
 
 	tlink = cifs_sb_tlink(cifs_sb);
-	if (IS_ERR(tlink))
+	if (IS_ERR(tlink)) {
+		/* drop the reference taken when the break was queued */
+		_cifsFileInfo_put(cfile, false /* do not wait for ourself */, false);
 		goto out;
+	}
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 
-- 
2.50.1

