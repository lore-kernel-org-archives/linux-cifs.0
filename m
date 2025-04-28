Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0BB25E82E
	for <linux-cifs@vger.kernel.org>; Mon, 28 Apr 2025 14:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745849111; cv=none; b=He/zH72lxKy6pUlqsNLWEMCN9aPH9cDa0f/FxRl+jLOcS++2W9c1k1e5IWBJv1vMyPA/IhMyNKudjgzJPHomjkWXxxfamdu3wNJwuly4p/UEQ2rPEOVtfHDEyzSUtYVrAjr/PPQxRWcwiO5/wcsJq3ZkejIbqhW+cbGKwzNqEV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745849111; c=relaxed/simple;
	bh=Uzd9I6/NU4qu83qZ6ZUjKBAlSupRm97oc9dsJjsEpvM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oLSYC84tJnBy7j5wAGjOtwPd6EsmWuuj68usd9R9sJbbbw4Xyn+IjmzotnZH47KF2EU7GjtKJbeUe+V8aH+qLMtEK5/uDezkXWjprH0fu3fReoWCXS0/RYQIAHiXTc+k/TnL6nMZ7oG4JWmRM1zjpHVU6Id2BQKPClyQAluzupY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=QrD19Flg; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="QrD19Flg"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1745849107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DaWLIzfTLItFXBdI0K1HdW39W/QbUd7NCjsm2qIoPFU=;
	b=QrD19FlgsNbQvpbMR/BRz4ZLa/94S4bgN7ewwaTW13nEjbOfBMRCK9CR3OEx7ulKYwixiA
	nOnANYWCuZPCEtWwtLlMUllqlf4rQoKiI4ZMi5BaOLjynC0CdzS3OJrEDrz1Qqo7E+TEp8
	ruqka4xPsDpRPZyfkH6+atr4fYP/5jjGVd5eJy+SDVYlGSWR/9geeiVMZTl2FTCfnJByDE
	4z1kXKOSoX/W0CCJCphW2MyueImxeN5fzxS6JC28HtmS1+yTpyNyAMC/xfuZ7T5R926fKe
	x0hFzcdii5TXKxD08t6C9+GVocus0FpTPDNBgxFhN+Gf4FO6WQvu7CUuI5TGnA==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Pierguido Lambri <plambri@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>
Subject: [PATCH] smb: client: fix delay on concurrent opens
Date: Mon, 28 Apr 2025 11:05:00 -0300
Message-ID: <20250428140500.1462107-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Customers have reported open(2) calls being delayed by 30s or so, and
looking through the network traces, it is related to the client not
sending lease break acks to the server when a lease is being
downgraded from RWH to RW while having an open handle, causing
concurrent opens to be delayed and then impacting performance.

MS-SMB2 3.2.5.19.2:

  | If all open handles on this file are closed (that is, File.OpenTable
  | is empty for this file), the client SHOULD consider it as an implicit
  | acknowledgment of the lease break. No explicit acknowledgment is
  | required.

Since we hold an active reference of the open file to process the
lease break, then we should always send a lease break ack if required
by the server.

Cc: linux-cifs@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Reported-by: Pierguido Lambri <plambri@redhat.com>
Fixes: da787d5b7498 ("SMB3: Do not send lease break acknowledgment if all file handles have been closed")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/file.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 9e8f404b9e56..be9a07f2e8c6 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3146,19 +3146,12 @@ void cifs_oplock_break(struct work_struct *work)
 	oplock_break_cancelled = cfile->oplock_break_cancelled;
 
 	_cifsFileInfo_put(cfile, false /* do not wait for ourself */, false);
-	/*
-	 * MS-SMB2 3.2.5.19.1 and 3.2.5.19.2 (and MS-CIFS 3.2.5.42) do not require
-	 * an acknowledgment to be sent when the file has already been closed.
-	 */
-	spin_lock(&cinode->open_file_lock);
-	/* check list empty since can race with kill_sb calling tree disconnect */
-	if (!oplock_break_cancelled && !list_empty(&cinode->openFileList)) {
-		spin_unlock(&cinode->open_file_lock);
+	/* MS-SMB2 3.2.5.19.1 and 3.2.5.19.2 (and MS-CIFS 3.2.5.42) */
+	if (!oplock_break_cancelled) {
 		rc = server->ops->oplock_response(tcon, persistent_fid,
 						  volatile_fid, net_fid, cinode);
 		cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
-	} else
-		spin_unlock(&cinode->open_file_lock);
+	}
 
 	cifs_put_tlink(tlink);
 out:
-- 
2.49.0

