Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0450438B147
	for <linux-cifs@vger.kernel.org>; Tue,  1 Sep 2026 01:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788224660; cv=none; b=eIZ8JlST1aGgx5H3khjtCSsCyd12lynO7jJp3S3xfxSy2WroM10XeQ97C/Jxpw0milVgkTo1czjSPqfDH+ttsRpEp8jXy9aULQB4Ugh6+FX//B3OtPQVqnVTQ/K/NAkjJZgJhPqkG1NZCVAaScnZYJsqZVyiYk+cla0IT/9jpcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788224660; c=relaxed/simple;
	bh=GUwiZLLo2yMk9EhUHo0O1rnq3Dvb/rJYeM7DPCTmN8w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Bn7jNSOBCeTJY9bChQS/C0MJbETCUifHT+P3yCxgvGXh5cuSYHYqhf1LFDUfMgKBw9hWqbgvnLxc3a8eogD5QvP5iyhMJctJWcirEMqkYwsctqY/r+w0RKFP+5wIF+HEpH8sS3lwYCVuAHqxG9aIppt4OjSrBcJB20KbARt6Uc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=s8Fuxqk8; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="s8Fuxqk8"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788224654; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=OSiMktLCJgFsziJ6nP9uG/LEiKHGjniP5ZmAq3pMhKs=;
	b=s8Fuxqk8TSx4Jb+ilXM34pjHggbPh3K8+kL/bO7ogX5BntDpF8kzX38H9TePCBjljCFbEI4mMLzw890Y/3GgJsZuwLg83CySQeTIWjIM3UNn5wV25l32UJ4fMKmMFP1cKsA7EsAR5nSyM/jEaOv+0TTnNFtkkk8BjpjCCIYm2g8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XA0dD6k_1788224653;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XA0dD6k_1788224653 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Sep 2026 09:04:13 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] smb: client: fix use-after-free of iface in cifs_try_adding_channels()
Date: Tue,  1 Sep 2026 09:04:13 +0800
Message-Id: <20260901010413.368183-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_try_adding_channels() iterates ses->iface_list with
list_for_each_entry_safe_from(), which captures the next entry
(niface) under iface_lock.  The loop body then drops iface_lock for
the whole duration of cifs_ses_add_channel().

A concurrent interface refresh (SMB3_request_interfaces() ->
parse_server_interfaces()) marks all ifaces inactive and removes and
frees any that are not re-advertised via list_del() + kref_put(),
where release_iface() is a bare kfree().  Since niface typically has
no channel holding a reference, the list reference is its last and it
can be freed inside the unlocked window.  On continue, the iterator
advance step then dereferences niface->iface_head.next, and the loop
body reads iface->rdma_capable/is_active, both on freed memory.

Fix this by never keeping an unreferenced list pointer across the
unlocked window.  Each channel attempt now re-scans the list from the
head under iface_lock, takes a kref on the selected candidate, and
passes only that referenced candidate to cifs_ses_add_channel().
weight_fulfilled still tracks selection progress, so restarting the
scan preserves the original weighted distribution and the
weight_fulfilled-before-kref_put ordering on the failure path.

Add a per-pass attempts cap so a flapping interface refresh cannot
keep the inner loop spinning within a single tries increment.

Fixes: aa45dadd34e4 ("cifs: change iface_list from array to sorted linked list")
Cc: stable@vger.kernel.org
Assisted-by: Qoder:Qwen3.8-Max
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/smb/client/sess.c | 106 ++++++++++++++++++++++++++-----------------
 1 file changed, 64 insertions(+), 42 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 7cf7dd104f7c..e095f41b5882 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -149,9 +149,9 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
 	int old_chan_count, new_chan_count;
 	int left;
 	int rc = 0;
-	int tries = 0;
+	int tries = 0, attempts;
 	size_t iface_weight = 0, iface_min_speed = 0;
-	struct cifs_server_iface *iface = NULL, *niface = NULL;
+	struct cifs_server_iface *iface = NULL, *candidate = NULL;
 	struct cifs_server_iface *last_iface = NULL;
 
 	spin_lock(&ses->chan_lock);
@@ -197,67 +197,89 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
 			break;
 		}
 
-		if (!iface)
-			iface = list_first_entry(&ses->iface_list, struct cifs_server_iface,
-						 iface_head);
 		last_iface = list_last_entry(&ses->iface_list, struct cifs_server_iface,
 					     iface_head);
 		iface_min_speed = last_iface->speed;
+		spin_unlock(&ses->iface_lock);
 
-		list_for_each_entry_safe_from(iface, niface, &ses->iface_list,
-				    iface_head) {
-			/* do not mix rdma and non-rdma interfaces */
-			if (iface->rdma_capable != ses->server->rdma)
-				continue;
-
-			/* skip ifaces that are unusable */
-			if (!iface->is_active ||
-			    (is_ses_using_iface(ses, iface) &&
-			     !iface->rss_capable))
-				continue;
+		attempts = 0;
+		while (left > 0) {
+			spin_lock(&ses->iface_lock);
 
-			/* check if we already allocated enough channels */
-			iface_weight = iface->speed / iface_min_speed;
+			/*
+			 * iface_lock must be dropped while opening a channel,
+			 * and a concurrent interface refresh may remove and
+			 * free entries during that window, so no list entry
+			 * may be kept across it without a reference.  Scan
+			 * the list from the beginning each time and only pass
+			 * a referenced candidate to cifs_ses_add_channel();
+			 * weight_fulfilled tracks the progress so that no
+			 * iface is selected beyond its weight.
+			 */
+			candidate = NULL;
+			list_for_each_entry(iface, &ses->iface_list, iface_head) {
+				/* do not mix rdma and non-rdma interfaces */
+				if (iface->rdma_capable != ses->server->rdma)
+					continue;
+
+				/* skip ifaces that are unusable */
+				if (!iface->is_active ||
+				    (is_ses_using_iface(ses, iface) &&
+				     !iface->rss_capable))
+					continue;
+
+				/* check if we already allocated enough channels */
+				iface_weight = iface->speed / iface_min_speed;
+
+				if (iface->weight_fulfilled >= iface_weight)
+					continue;
+
+				/* take ref before unlock */
+				kref_get(&iface->refcount);
+				candidate = iface;
+				break;
+			}
 
-			if (iface->weight_fulfilled >= iface_weight)
-				continue;
+			if (!candidate) {
+				/* no usable iface. reset weight_fulfilled and start over */
+				list_for_each_entry(iface, &ses->iface_list, iface_head)
+					iface->weight_fulfilled = 0;
+				spin_unlock(&ses->iface_lock);
+				break;
+			}
 
-			/* take ref before unlock */
-			kref_get(&iface->refcount);
+			attempts++;
+			if (attempts > 3 * ses->chan_max) {
+				kref_put(&candidate->refcount, release_iface);
+				spin_unlock(&ses->iface_lock);
+				break;
+			}
 
 			spin_unlock(&ses->iface_lock);
-			rc = cifs_ses_add_channel(ses, iface);
+			rc = cifs_ses_add_channel(ses, candidate);
 			spin_lock(&ses->iface_lock);
 
 			if (rc) {
 				cifs_dbg(VFS, "failed to open extra channel on iface:%pIS rc=%d\n",
-					 &iface->sockaddr,
+					 &candidate->sockaddr,
 					 rc);
 				/* failure to add chan should increase weight */
-				iface->weight_fulfilled++;
-				kref_put(&iface->refcount, release_iface);
+				candidate->weight_fulfilled++;
+				kref_put(&candidate->refcount, release_iface);
+				spin_unlock(&ses->iface_lock);
 				continue;
 			}
 
-			iface->num_channels++;
-			iface->weight_fulfilled++;
+			candidate->num_channels++;
+			candidate->weight_fulfilled++;
 			cifs_info("successfully opened new channel on iface:%pIS\n",
-				 &iface->sockaddr);
-			break;
-		}
-
-		/* reached end of list. reset weight_fulfilled and start over */
-		if (list_entry_is_head(iface, &ses->iface_list, iface_head)) {
-			list_for_each_entry(iface, &ses->iface_list, iface_head)
-				iface->weight_fulfilled = 0;
+				 &candidate->sockaddr);
 			spin_unlock(&ses->iface_lock);
-			iface = NULL;
-			continue;
-		}
-		spin_unlock(&ses->iface_lock);
 
-		left--;
-		new_chan_count++;
+			left--;
+			new_chan_count++;
+			break;
+		}
 	}
 
 	return new_chan_count - old_chan_count;
-- 
2.39.3

