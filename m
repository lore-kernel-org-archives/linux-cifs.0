Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F314F472A;
	Thu,  3 Sep 2026 21:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788470970; cv=none; b=KEZEqqiuz6mgHx+WEBc1PqJ+nMO/+OpUfOQHBQXWvTm0+Ltr7sJIJtlzusww1MqQctcTub6uK5Yvru8ntUKISJ/pNPkxAif94jMmWmK8uEaq+EjCO8KY39jaL7K7zy0TDcPGv+7WJStiRHEZc6eeIxjO4hpCE+dyeTsVFHwUKrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788470970; c=relaxed/simple;
	bh=q8pcMeogMkU4qlO11JFsyWnAN9o9cBMIfEFlSdec1J0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pv3USAU58jaSd1+OXB5mxzvR0lyRvmegRRiqbG+H0BS4mds4K4F0yWR1dHZ8ZEvba10RUS9FP4k0BWe/NRr/VOwa4B9sXa8eHrMBk8XKxoYmbiiPgFy1gnu5o1htN6D4Pz2iK6pJdXDZ+5b+/LPm9WnxBu9W6L5tjJm9uwsDzso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=XyrXqoz+; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="XyrXqoz+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1788470967; x=1820006967;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=b/PGv6fsBLjQbBYQNjtr/sT7YdkX65+4zpGYMWEY4wg=;
  b=XyrXqoz+ictQzPveF9Die19y2Bz8pKsp0HoAovpkFJY9GqY1Dbm4wVLp
   I4SiMcAgPQj8O1b5Mj+e28j5bO4JevtQVVliTjvNlpwxs8us3hpZL8TUm
   ZiZVxd78Rg65RROvkvEZagSyNbO0SFtm5AokgkCK83vjgDZlHAdGxvt/h
   e+CS5GwoO5KLluj5hZm/xCcpOlifFHaZ2KxmWuKU88KOQrrdrKnwIMMHR
   zVyoIBstd2e3U/4oO5K5hf1ucYKXQUN3KDjxsTjaTAP5I9aeFuAqIyh5R
   r0YSGkPPbI4Mo3m0GIYfK1c3cDHSyfwHsgDFEa9vGqynl4qxF5n93Lw/v
   Q==;
X-CSE-ConnectionGUID: xUH+S3glS0G/uhRxa2+pog==
X-CSE-MsgGUID: 2IsLZ4BOR66tMo0I3nrOZw==
X-IronPort-AV: E=Sophos;i="6.25,260,1779148800"; 
   d="scan'208";a="27765075"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 21:29:24 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:16399]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.7.25:2525] with esmtp (Farcaster)
 id 01491d37-20cd-435e-a351-19c601d532f6; Thu, 3 Sep 2026 21:29:23 +0000 (UTC)
X-Farcaster-Flow-ID: 01491d37-20cd-435e-a351-19c601d532f6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 3 Sep 2026 21:29:23 +0000
Received: from dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com (10.169.119.5)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Thu, 3 Sep 2026 21:29:22 +0000
From: Bjoern Doebel <doebel@amazon.de>
To: Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>
CC: <stable@vger.kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, "Bharath
 SM" <bharathsm@microsoft.com>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, <linux-kernel@vger.kernel.org>, "Aurelien
 Aptel" <aaptel@suse.com>, <doebel@amazon.de>
Subject: [PATCH] smb: client: avoid leaking refcount in cifs_queue_oplock_break()
Date: Thu, 3 Sep 2026 21:28:58 +0000
Message-ID: <20260903212858.728118-1-doebel@amazon.de>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D035UWB003.ant.amazon.com (10.13.138.85) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

cifs_queue_oplock_break() unconditionally takes a reference on the
target file before queueing cifs_oplock_break(). Only that work item
decreases the reference counter again.

If another oplock break arrives while that work is still queued,
queue_work() will return false and not queue this second work item. As a
result, we will never reach the point to drop the file reference again
and are leaking this reference. This can be triggered when interacting
with a slow-responding server.

As a result, later unmount operations for this file system will fail with

  BUG: Dentry ... still in use (1) [unmount of cifs cifs]
  VFS: Busy inodes after unmount of cifs (cifs)
  kernel BUG at fs/super.c:777!

Fix this by only incrementing the reference count if the work has been
queued successfully. Taking it after queue_work() is safe because all
three callers hold tcon->open_file_lock across the call and
_cifsFileInfo_put() decrements under that same lock, so a worker that
starts the handler in the window cannot drop the reference before it has
been taken.

Fixes: b98749cac4a69 ("CIFS: keep FileInfo handle live during oplock break")
Cc: stable@vger.kernel.org
Assisted-by: Kiro:claude-opus-5
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
---
 fs/smb/client/misc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 46e1382e8e04b..dc7070d70467f 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -378,10 +378,11 @@ void cifs_queue_oplock_break(struct cifsFileInfo *cfile)
 	 * open_file_lock to enforce the validity of it for the oplock
 	 * break handler. The matching put is done at the end of the
 	 * handler.
+	 *
+	 * Only take a reference if the work is actually queued.
 	 */
-	cifsFileInfo_get(cfile);
-
-	queue_work(cifsoplockd_wq, &cfile->oplock_break);
+	if (queue_work(cifsoplockd_wq, &cfile->oplock_break))
+		cifsFileInfo_get(cfile);
 }
 
 void cifs_done_oplock_break(struct cifsInodeInfo *cinode)
-- 
2.50.1

