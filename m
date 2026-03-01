Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD79220010A;
	Sun,  1 Mar 2026 01:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329542; cv=none; b=PM+dcflVVR4ApGSHQvWLVGL9t7rKTUfJkbtJ4QaUZG9kkDHK4778+ekBQ9g9DHOh8ymDU9W420E/uiCTcCo1xSOlGljTQr6ef1VLxyRHT6NJ9mmqmZ6v6xiCu/JHYAFKcHU8ma1Q1ghIAqa2bj5snqsT0BghvvCRWYG14tAevCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329542; c=relaxed/simple;
	bh=ADXywvsFL28fBcG5U+1XbOomq1Y3q/BrEPXYTyjNkNA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VSntbfXG7XszKPT0aHhvhUFH+p9WSCDdbnrECi9ILwk1sEI4k17mgRRGfbqmsq8lYTtHUZ791P2N9HmO4/NeNit1NJPyPS8MTKL/7YPGDCT+91HbFSTp4k/SmEX9rydbPJ+7HpNrEMg2rZmheurWDv9LG5IcYmXfbdJr64eQ8f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LMbcBoUg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LMbcBoUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFA4C19421;
	Sun,  1 Mar 2026 01:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329542;
	bh=ADXywvsFL28fBcG5U+1XbOomq1Y3q/BrEPXYTyjNkNA=;
	h=From:To:Cc:Subject:Date:From;
	b=LMbcBoUgE14ZdIBLtk5rJY+RidzX6EI6PpoMCMl4VNxxA0Ceq2m08zskhe0SCkfG4
	 1NhlOlAnS1cEzdfQtYd0srNuvP9kY78DaiTWNaFPjx9jvt1dyjnXfnSsjXKYP4uOqd
	 Epc086vOANZR4NMITAzHBn4lgtZy06g9f5gg60GkouLV0PVkDRWzX3t2swoLhmMQ3A
	 D6itDxxBL3vVsySzg20sJ4VI6CexozjBiJLY6SIUrikgXO967sIyHmse8jiBOiQUKw
	 LYODPXwBSoWBiEvdQ7kdZnkeoSENIsDFyvtmUV+NGy8vv2Rl44P+HQ2UqoaPt5EzsF
	 QOQc5pouWbmsw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	sprasad@microsoft.com
Cc: Steve French <stfrench@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: FAILED: Patch "cifs: Fix locking usage for tcon fields" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:45:40 -0500
Message-ID: <20260301014541.1708363-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 96c4af418586ee9a6aab61738644366426e05316 Mon Sep 17 00:00:00 2001
From: Shyam Prasad N <sprasad@microsoft.com>
Date: Sun, 1 Feb 2026 00:21:13 +0530
Subject: [PATCH] cifs: Fix locking usage for tcon fields

We used to use the cifs_tcp_ses_lock to protect a lot of objects
that are not just the server, ses or tcon lists. We later introduced
srv_lock, ses_lock and tc_lock to protect fields within the
corresponding structs. This was done to provide a more granular
protection and avoid unnecessary serialization.

There were still a couple of uses of cifs_tcp_ses_lock to provide
tcon fields. In this patch, I've replaced them with tc_lock.

Cc: stable@vger.kernel.org
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/cached_dir.c | 4 ++--
 fs/smb/client/smb2misc.c   | 6 +++---
 fs/smb/client/smb2ops.c    | 8 +++-----
 fs/smb/client/smb2pdu.c    | 2 ++
 fs/smb/client/trace.h      | 1 +
 5 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index df9977030d199..2a6b8ce80be23 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -792,11 +792,11 @@ static void cfids_laundromat_worker(struct work_struct *work)
 		cfid->dentry = NULL;
 
 		if (cfid->is_open) {
-			spin_lock(&cifs_tcp_ses_lock);
+			spin_lock(&cfid->tcon->tc_lock);
 			++cfid->tcon->tc_count;
 			trace_smb3_tcon_ref(cfid->tcon->debug_id, cfid->tcon->tc_count,
 					    netfs_trace_tcon_ref_get_cached_laundromat);
-			spin_unlock(&cifs_tcp_ses_lock);
+			spin_unlock(&cfid->tcon->tc_lock);
 			queue_work(serverclose_wq, &cfid->close_work);
 		} else
 			/*
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index f3cb62d914502..0871b9f1f86a6 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -820,14 +820,14 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 	int rc;
 
 	cifs_dbg(FYI, "%s: tc_count=%d\n", __func__, tcon->tc_count);
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&tcon->tc_lock);
 	if (tcon->tc_count <= 0) {
 		struct TCP_Server_Info *server = NULL;
 
 		trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 				    netfs_trace_tcon_ref_see_cancelled_close);
 		WARN_ONCE(tcon->tc_count < 0, "tcon refcount is negative");
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&tcon->tc_lock);
 
 		if (tcon->ses) {
 			server = tcon->ses->server;
@@ -841,7 +841,7 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 	tcon->tc_count++;
 	trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 			    netfs_trace_tcon_ref_get_cancelled_close);
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&tcon->tc_lock);
 
 	rc = __smb2_handle_cancelled_cmd(tcon, SMB2_CLOSE_HE, 0,
 					 persistent_fid, volatile_fid);
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index f6806946d0eee..653e2f29384d4 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3107,7 +3107,9 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 						struct cifs_tcon,
 						tcon_list);
 		if (tcon) {
+			spin_lock(&tcon->tc_lock);
 			tcon->tc_count++;
+			spin_unlock(&tcon->tc_lock);
 			trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 					    netfs_trace_tcon_ref_get_dfs_refer);
 		}
@@ -3176,13 +3178,9 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
  out:
 	if (tcon && !tcon->ipc) {
 		/* ipc tcons are not refcounted */
-		spin_lock(&cifs_tcp_ses_lock);
-		tcon->tc_count--;
+		cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_dfs_refer);
 		trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 				    netfs_trace_tcon_ref_dec_dfs_refer);
-		/* tc_count can never go negative */
-		WARN_ON(tcon->tc_count < 0);
-		spin_unlock(&cifs_tcp_ses_lock);
 	}
 	kfree(utf16_path);
 	kfree(dfs_req);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index fa22702a61a6e..a88b21e5b30e2 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4263,7 +4263,9 @@ void smb2_reconnect_server(struct work_struct *work)
 
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			if (tcon->need_reconnect || tcon->need_reopen_files) {
+				spin_lock(&tcon->tc_lock);
 				tcon->tc_count++;
+				spin_unlock(&tcon->tc_lock);
 				trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 						    netfs_trace_tcon_ref_get_reconnect_server);
 				list_add_tail(&tcon->rlist, &tmp_list);
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index a584a77431132..191f02344dcdd 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -189,6 +189,7 @@
 	EM(netfs_trace_tcon_ref_put_cancelled_close_fid, "PUT Cn-Fid") \
 	EM(netfs_trace_tcon_ref_put_cancelled_mid,	"PUT Cn-Mid") \
 	EM(netfs_trace_tcon_ref_put_mnt_ctx,		"PUT MntCtx") \
+	EM(netfs_trace_tcon_ref_put_dfs_refer,		"PUT DfsRfr") \
 	EM(netfs_trace_tcon_ref_put_reconnect_server,	"PUT Reconn") \
 	EM(netfs_trace_tcon_ref_put_tlink,		"PUT Tlink ") \
 	EM(netfs_trace_tcon_ref_see_cancelled_close,	"SEE Cn-Cls") \
-- 
2.51.0




