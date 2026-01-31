Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3367C2E0405
	for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 08:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769846585; cv=none; b=nK+PBJ0Tsw/BT/clk7NTq21mCJ4sULPuRH9VbbsV91lCXKuY3qUnRX4klq5lPSZVVE34KGlXlWeFIffJv3HQCfKpr2QipJy/jkQvBPuP3EF3t+t3N6eD2N7AaiaIl0ycyFMg/05/TrIl5uoyB0E2uNKnVlffA5EIHGjIqHuvR+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769846585; c=relaxed/simple;
	bh=dBbkA3s8ZDlYOu+fYRUqtVqIzyY2MkklyEgHq02a5fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrNZ+5I342QaUtsqTAlD/WPUGjWlYfaRax6p24KDhEKyzvPM3IGbZWOkGoj5gzr3R7kB6CZbt2RbxTQv1PpuhZVH6aq0+wlo7/bxtPq0w5WIhC8+PpbP/cCt9pFU4h1qNHXdBez01O5ZVzS0X1XguK8TDof9BQ/sAItFEphiFws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VMe8LG9p; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VMe8LG9p"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a79ded11a2so19664395ad.3
        for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 00:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769846583; x=1770451383; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2XcWW/vYfFgkZEN1KNi9wjY+Xh26NCKHQFJADTAEK40=;
        b=VMe8LG9p9LvaiT2CX/lJZ7XcM0lCSdiOcrsZZ8H+1r8VoeDcTVON+rAcA57oZaDid+
         xh2wxKeZ0F8tkKjtbJga4vPNo9c4xJssQZpwKZjGMtmFOIMRN6flPYSdVMUS7OdEfVLD
         Atx3Qh2tKFYXzteIRklvb7ZmkujzqcQsmXT14PP4E+36lDHeuCJatNZSb6aMSJQF4w3C
         mcknrpxThbRxHzIUH7sD3zmVxCaTjdsV7NWWE8gkW+2xRJZJinpN2u6nUp/y/y0141nE
         3K9u3MgVVTOLEl+3T9algye9YB1gWeV+sOwPtzzatkxUuF8SaL/PycHy9OpBeX2aTna0
         gGIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769846583; x=1770451383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2XcWW/vYfFgkZEN1KNi9wjY+Xh26NCKHQFJADTAEK40=;
        b=h9UVr7OyHzIGLKP87IKTpX1ocHrmKQJ7k4c+en7CaUrd8TQB1RBW2e9zqoSJ+7E37r
         cTH0qYFqaTrm+voo6LoyRd1FQqGzcOLdgrwOuB19+B/1PwSVNb1Yf1My1sjS9ziExGLI
         NYO5TMp+KRqQLkYYQVC8TZp1zCG9GpojNXRuPmihY609VJBDtgdU2QAtDoSrhneZcg/6
         n35L0+ika4yahlMb02Vz22QrPjAxvUNvjvx1pdP8pUc0ItKrSzlZiOmM+Oj4IGsvDEOw
         mNVfZFzLObS2j2JsylVw8lp5+qTMKx58ySGJgBJPfTDsgMioxPHQ4j/SO+aGg9JzZ8Jv
         yg7Q==
X-Gm-Message-State: AOJu0YzrIum+s5y1HrngnfuMRF3iSmjtbEAP0daehFc9e4wD+BYBZZ7B
	Umsfcc5Y8LO1mX80+LkxitaghmxR26fG7Rfcn3G1E90G1LYsqIuN9LLAlE5mmQ==
X-Gm-Gg: AZuq6aJov7okVdFD2I70uQzJ/hyV3ay8VgfhLJE469RNQ2b2DqBhJtOIAIqFJz83IZP
	HDdhekKYcwMnU7uUCE6pAzS6eQNz8Gi99JEHm1OlASDPbFHX/2jQ1Ltvz9sdtTWq9MFfN0MyAFK
	IrfdEqv5LVVEAsOl7wd/6+F2egYuaXXd/2l/fD45RX6X2Dn6vOWtGA8qa+3uP7VNdguB0Fj/vkA
	ICl0B99T3VVJOHl+5agPH9SbIRdRXXHn/Hl4YhY5xY5zlbJMkb7l8+WgC8VLtxaO7Kvwk2xnsuA
	Pj1SpvvSsipdeQFlnSzZrW3h989XPRy/HpUcs+1qTy4Aqu4NHeEH9CKtyv8+RQsUAqQ6nnc1c5Q
	eqh00yf8ui6689muI0kWmFXzXpBY1Y3SJn3R3PISYkQ7xoqYFxSR7XHZa4dIpeXT4nHvg9BTEOZ
	7E6qRBlCwO2qKyWa1Tp9A4KqCt6AfxI9rR4S4C6c1m
X-Received: by 2002:a17:902:e88a:b0:2a0:c1ed:c8c2 with SMTP id d9443c01a7336-2a8d99458d9mr49139415ad.55.1769846582973;
        Sat, 31 Jan 2026 00:03:02 -0800 (PST)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b7f6c7csm98853045ad.98.2026.01.31.00.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jan 2026 00:03:02 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] cifs: Fix locking usage for tcon fields
Date: Sat, 31 Jan 2026 13:32:16 +0530
Message-ID: <20260131080239.943483-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260131080239.943483-1-sprasad@microsoft.com>
References: <20260131080239.943483-1-sprasad@microsoft.com>
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
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 1db7ab6c2529c..84c3aea18a1a7 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -788,11 +788,11 @@ static void cfids_laundromat_worker(struct work_struct *work)
 		cfid->dentry = NULL;
 
 		if (cfid->is_open) {
-			spin_lock(&cifs_tcp_ses_lock);
+			spin_lock(&tcon->tc_lock);
 			++cfid->tcon->tc_count;
 			trace_smb3_tcon_ref(cfid->tcon->debug_id, cfid->tcon->tc_count,
 					    netfs_trace_tcon_ref_get_cached_laundromat);
-			spin_unlock(&cifs_tcp_ses_lock);
+			spin_unlock(&tcon->tc_lock);
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
index c1aaf77e187b6..6f930d6c78adb 100644
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
+		cifs_put_tcon(tcon);
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
-- 
2.43.0

