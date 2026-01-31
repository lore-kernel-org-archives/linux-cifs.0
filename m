Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85393367F4A
	for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 18:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769885566; cv=none; b=YOJ+bR3DfdEBUds/Bk8K9z+U/pwSiURdEXZXqjI9vVIv7/muconiB0yXf8tXLAYDKOiiWRcW1KUG3u39cE26aIaPD5IOC3kwwD3yV4f7zZFmMGZjSXpS39LDgfehi+FkUjxvXXCNrWgI02GjJEKpCPS4k39fLrfqSz5zVN+ok2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769885566; c=relaxed/simple;
	bh=vQq02FMVpbjplRoufcM/laGJrK4kMg9CPakD66WlICU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsiLpfycXXM146aZQ9fUpFjfmewEAKWKqhUmCG+S+9Ukhs9WHUkO+VcHDVCtD2l2us22lfJ/IOnt10tTnzlt/sYP6Ck6AjT2Is3drqOwnqsccUzbDDe1+z+25RtdwmMKDtUXLRQaV97Jl9Uuv/kO0jf/GqgrVgyflij0D0VwZOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UBMVixJ2; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UBMVixJ2"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-81e93c5961cso2614826b3a.0
        for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 10:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769885565; x=1770490365; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m/YpZuZ4iHVFgay+XuFU7jmeGrQlXbkaqzKeU5rDtPM=;
        b=UBMVixJ2luyGImWx1dZvp32ZyEHMTSXR9xxh73zp7o4R/EG+lde0q3pYkdFRsa5wLm
         SpC9bAEOJrvnN17cRMt6V5NR4OzNOXQcTmOy+BoEO1EM2EXXtEMLjRs1n7YmlAoblCbz
         ARBfKs1bPNia1zmkZ/EoAyg/n6tol1t2rHROQ21JeKIP+ziN4m+xFcZsq9f4VBZ+cuSQ
         qBG0du1VDXVDYswCoYSb0Ism2cwqvu1/n4v+Iws478F0ZALUMbO370HCHyHqR7ydN6K0
         pBPYViN3EY11r+YOwNiF7SJkzvLLfEHLOWryXyZO8v4+sgBVrLzb3YGFuu7mID9ZSdUp
         BKcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769885565; x=1770490365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m/YpZuZ4iHVFgay+XuFU7jmeGrQlXbkaqzKeU5rDtPM=;
        b=rYbJjGS8hF/F8Eo/uNEsJR9E66ryYigaoWSIZ9IWSk1URjh/m226clNX/ikQ7SO5OT
         OhOySf9DKwAW4rLqaizUE5UsV7EOFmn6AOvPpzCBqTlp5AajUV+GIj5uKoqCTtgx+PKH
         eFjXH6V0mvxM5eD3EVjax+5KrwoeTB/Exx5VYggHOigN8zmdDf4o7WSGLzAQVSzU15dk
         D8mYjFKyrNQBwqnvS6xeXprVX+mjrDOhjRo6LZhEPKur4Zlt3YvUn3+Ba1PTBzexrIYg
         I6zZqoCPXf2qEMS6BOymBbs+CKvmbMBf+dVCKLvQ3igeMulN1BQtsFc6tGfJ+9yyFjIk
         bxpQ==
X-Gm-Message-State: AOJu0Yw5DU8bk9szgLnR4Xw2FiEJkOG4DOeESMPYV5bUoUPueWy/H0hM
	OIaQBHgPndMuvR1Rk/x5E0t+jRSHXolW6W3GG9IQZa5bzYLvTo2kw52C4ZJJvG3Y
X-Gm-Gg: AZuq6aIZ98wGthOEidpZ6Dnkci8QhRXZLUJaZ8MIHagpzaI7+ZqJZkcdyjaB3P3SPN1
	akutlRAsElxYJmJvT+O/vGgn0quH+8bryXvzUTF9Rpu3daEcewIVwP7dWYvaRzN7bNvRw5GdYZr
	U3HD/J0tNdfx04dmjznbgdDOH1rfeHqN9OWRHliDKLZFmHCJMvxjsJm2D0iHh4p6H9R2k7xjnjL
	65R3Jgereh8llU5f6QddpOLWynD5EPHhVlaCq1RjIId6ksEvCN1QtqsDxO2ZTLSd9Hsb924mDaA
	f0SvFL2Ey9sA9l4iG2C6fOELOYL6dChMq7uooehusL7Bf+Ddj8d/B1PyUkipOBnluYaqTvAmMDU
	vdnnbC/bqxk7aUkY8P9yKIhOpCKfqCyApuXgL+eK7/7M/+G0K1L9Yv5BGZ0KzaE8oowra42qm0I
	lMBxMkAoGhrafZkMqL6YLPgoyWVofH1J0kuNCmPIo=
X-Received: by 2002:a05:6a00:4195:b0:823:d29:f4f0 with SMTP id d2e1a72fcca58-823ab9762d7mr6896203b3a.62.1769885564744;
        Sat, 31 Jan 2026 10:52:44 -0800 (PST)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379c22419sm11635760b3a.46.2026.01.31.10.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jan 2026 10:52:44 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/2] cifs: Fix locking usage for tcon fields
Date: Sun,  1 Feb 2026 00:21:13 +0530
Message-ID: <20260131185238.973130-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260131185238.973130-1-sprasad@microsoft.com>
References: <20260131185238.973130-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

We used to use the cifs_tcp_ses_lock to protect a lot of objects
that are not just the server, ses or tcon lists. We later introduced
srv_lock, ses_lock and tc_lock to protect fields within the
corresponding structs. This was done to provide a more granular
protection and avoid unnecessary serialization.

There were still a couple of uses of cifs_tcp_ses_lock to provide
tcon fields. In this patch, I've replaced them with tc_lock.

Cc: stable@vger.kernel.org
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 4 ++--
 fs/smb/client/smb2misc.c   | 6 +++---
 fs/smb/client/smb2ops.c    | 8 +++-----
 fs/smb/client/smb2pdu.c    | 2 ++
 fs/smb/client/trace.h      | 1 +
 5 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 1db7ab6c2529c..569030b3e68d4 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -788,11 +788,11 @@ static void cfids_laundromat_worker(struct work_struct *work)
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
index c1aaf77e187b6..0b2abd0fdad11 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3091,7 +3091,9 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 						struct cifs_tcon,
 						tcon_list);
 		if (tcon) {
+			spin_lock(&tcon->tc_lock);
 			tcon->tc_count++;
+			spin_unlock(&tcon->tc_lock);
 			trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 					    netfs_trace_tcon_ref_get_dfs_refer);
 		}
@@ -3160,13 +3162,9 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
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
index 5d57c895ca37a..c7e086dfb1765 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4239,7 +4239,9 @@ void smb2_reconnect_server(struct work_struct *work)
 
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
2.43.0

