Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676D128934F
	for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 08:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769848419; cv=none; b=dh4Wc0VoPkg7uIs7HSVfpy1Cs6Mmmj1p0GNxS6hEwnGW0++B+0mJXO2p/YlrFtUnW5eDCrH3R2adUluQqDxrf0r+J37X/gK0se1ynn6Y0xV0mZU8zV2kDI8PnzMljFnfSQl5FLbfgpK0GtDERjQVXDts5/64TzM9vf6LJ1vVtaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769848419; c=relaxed/simple;
	bh=gPPehgrbADvFMOonMviodhY47VlKs3L4ySp2VaTA8VI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eTnRi4MblzBgeOV3RE4YpxUKgLzThixjOu2EXf+6OpMYwVrnC9Vnar+n1dyBb+6nLHThxQh9xXnl3MFhMxSX5ofhn27m6wi+48Hzqtken6M96hg2csWr6beyO/OWUjC5aZcfGvkxZn17Ml4qfn1GzYaudfuH6GHHzlULSH0H62c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K1kxg4Lb; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K1kxg4Lb"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-34c363eb612so1571197a91.0
        for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 00:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769848416; x=1770453216; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KbfLfGKKFtyXPaJ1KnjL4S60yxLyN8RnReLVa1iKPJ4=;
        b=K1kxg4LbZQGZKkU+twm5M7Mg+lKNjZrtgj3XaZff3GhseDlcJBJE7Caf4rJcch3JoB
         2jSYx103+A/kEPjAq4TT51iHMnWQUaYL0V3RRzV62Lt4PqC7LVqynSMbE6SqW1a8Kfk2
         rNZPU8lgjul7v41fdgjvhJbBAZG98u68bJwxGK39FLXE4E82VudvkRr8+ju7O/u//P+z
         XoRgOfJ1jiVaixai1mc7MwqBciG52LriqSYRparhsnGWRkGO0Tt3FvQj0AM5Rrazgixm
         1y636CpCKRe/KpUVv8DddJH3kwf88I2+thQAInY4T1Am037hiv1gF7NCLgDaaqk4k+RE
         3w5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769848416; x=1770453216;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KbfLfGKKFtyXPaJ1KnjL4S60yxLyN8RnReLVa1iKPJ4=;
        b=J1eNsqj/bn5gyswFAK/5rnakuezZkjtywRTy1OBDmdpcShcfAyOAw9EuOzTXXJ7Asa
         kYbxLx3pNtrvq6Itcf2ElvXaApy7ufQPtPyZ74q5RJfHJvf/eGxpiwCoe84+7uOClwPw
         qkU44nKTe7qqJnlxXYc8IpqL7gZso57yi+6HoyvEY2z3gnjVVge1e12vtRNqXDoWM/Jj
         Wy7lPhBH/TkMwzkcxrP5TV8b7mX0/vbTjfvV+Tm9N5bVnmZ6lrpckXiLpBJ6S481bj9X
         RQtv0hOiQuWdsIMI6ysZPg2sjIjqgctgXdiLOkqDSrcETt710OcSGAUOYfXQ6QWsRbrm
         3dow==
X-Gm-Message-State: AOJu0Yywh2k9fIhOmO2NtoL56GT/uMieVB9VZ3abhEoKDhadwqxY+u83
	2sWX+h9sXhXWDGl4ZqVxzckCd3UKIbtvUqxvBIZIBHtfpIqg1ZJDF5Li7MCY/RJl
X-Gm-Gg: AZuq6aIUMOFqsU0VgfGCOg1rnSNmWhg+RIU8QKlwj4CwSnuoPDZNBbZUG9EIZhR6TPc
	grX2TprCciKuNfp/bvdWCdUlmptLtfr+KnUtlDR6S7rEt55I2MMv+y0QatVrihdaGksb22R1rWd
	XEpkafYP4o96vRsnCn6/Ef7wM6hfm5o6OAEfzU1j4gIQbBGB1LVvPwZKLNqCm6umMtTvoEsbbRP
	90tQl5VMl9bPt7Sd9N9X+lOax5poOIg+F1HscuYeAAUcMeHkHH2UoQryk/88+rmhRRRpjXA54sb
	pi7Ikt3B47ABEg15KPqMWF/aK0VKye05luXF40liWh8xkLDUZzqdzt0hVNQ7ZqC4+p3/1w1qMMQ
	pGftywb7vgpBzT0RUC1D7ki+VnMDmOGgj1bvY00PNgD31zq6Oj50c9DHO2csEDyq0giOu+nikGI
	HGS+5tvttlUFcV/+iEMBVzHm490dGgCZgtHpkJWg4=
X-Received: by 2002:a17:90b:3849:b0:330:6d2f:1b5d with SMTP id 98e67ed59e1d1-3543b3ac87cmr5936614a91.26.1769848416270;
        Sat, 31 Jan 2026 00:33:36 -0800 (PST)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-353f610266esm13479121a91.4.2026.01.31.00.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jan 2026 00:33:35 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	netfs@lists.linux.dev
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v4 1/4] cifs: on replayable errors back-off before replay, not after
Date: Sat, 31 Jan 2026 14:03:03 +0530
Message-ID: <20260131083325.945635-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

On replayable errors, we call smb2_should_replays that does these
things today:
1. decide if we need to replay the command again
2. sleep to back-off the failed request
3. update the next sleep value

We will not be able to use this for async requests, when this is
processed in callbacks (as this will be called in cifsd threads that
should not sleep in response processing).

Modify the behaviour by taking the sleep out of smb2_should_replay
and performing the sleep for back-off just before actually
performing the replay.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c |   6 +-
 fs/smb/client/smb2inode.c  |  21 +++++--
 fs/smb/client/smb2ops.c    |  32 ++++++++---
 fs/smb/client/smb2pdu.c    | 112 +++++++++++++++++++++++++++----------
 4 files changed, 129 insertions(+), 42 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 1db7ab6c2529c..df9977030d199 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -154,7 +154,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	struct cached_fid *cfid;
 	struct cached_fids *cfids;
 	const char *npath;
-	int retries = 0, cur_sleep = 1;
+	int retries = 0, cur_sleep = 0;
 	__le32 lease_flags = 0;
 
 	if (cifs_sb->root == NULL)
@@ -304,6 +304,10 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	smb2_set_related(&rqst[1]);
 
 	if (retries) {
+		/* Back-off before retry */
+		if (cur_sleep)
+			msleep(cur_sleep);
+
 		smb2_set_replay(server, &rqst[0]);
 		smb2_set_replay(server, &rqst[1]);
 	}
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 2ded3246600c0..498a26a7bd415 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -188,7 +188,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	struct reparse_data_buffer *rbuf;
 	struct TCP_Server_Info *server;
 	int resp_buftype[MAX_COMPOUND];
-	int retries = 0, cur_sleep = 1;
+	int retries = 0, cur_sleep = 0;
 	__u8 delete_pending[8] = {1,};
 	struct kvec *rsp_iov, *iov;
 	struct inode *inode = NULL;
@@ -638,18 +638,26 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	num_rqst++;
 
 	if (cfile) {
-		if (retries)
+		if (retries) {
+			/* Back-off before retry */
+			if (cur_sleep)
+				msleep(cur_sleep);
 			for (i = 1; i < num_rqst - 2; i++)
 				smb2_set_replay(server, &rqst[i]);
+		}
 
 		rc = compound_send_recv(xid, ses, server,
 					flags, num_rqst - 2,
 					&rqst[1], &resp_buftype[1],
 					&rsp_iov[1]);
 	} else {
-		if (retries)
+		if (retries) {
+			/* Back-off before retry */
+			if (cur_sleep)
+				msleep(cur_sleep);
 			for (i = 0; i < num_rqst; i++)
 				smb2_set_replay(server, &rqst[i]);
+		}
 
 		rc = compound_send_recv(xid, ses, server,
 					flags, num_rqst,
@@ -1180,7 +1188,7 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 {
 	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
 	__le16 *utf16_path __free(kfree) = NULL;
-	int retries = 0, cur_sleep = 1;
+	int retries = 0, cur_sleep = 0;
 	struct TCP_Server_Info *server;
 	struct cifs_open_parms oparms;
 	struct smb2_create_req *creq;
@@ -1242,6 +1250,9 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 		goto err_free;
 
 	if (retries) {
+		/* Back-off before retry */
+		if (cur_sleep)
+			msleep(cur_sleep);
 		for (int i = 0; i < ARRAY_SIZE(rqst);  i++)
 			smb2_set_replay(server, &rqst[i]);
 	}
@@ -1262,7 +1273,7 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	if (rc == -EINVAL && dentry) {
 		dentry = NULL;
 		retries = 0;
-		cur_sleep = 1;
+		cur_sleep = 0;
 		goto again;
 	}
 	/*
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index c1aaf77e187b6..f6806946d0eee 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1184,7 +1184,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	struct smb2_file_full_ea_info *ea;
 	struct smb2_query_info_rsp *rsp;
 	int rc, used_len = 0;
-	int retries = 0, cur_sleep = 1;
+	int retries = 0, cur_sleep = 0;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -1314,6 +1314,9 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	smb2_set_related(&rqst[2]);
 
 	if (retries) {
+		/* Back-off before retry */
+		if (cur_sleep)
+			msleep(cur_sleep);
 		smb2_set_replay(server, &rqst[0]);
 		smb2_set_replay(server, &rqst[1]);
 		smb2_set_replay(server, &rqst[2]);
@@ -1582,7 +1585,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 	void *data[2];
 	int create_options = is_dir ? CREATE_NOT_FILE : CREATE_NOT_DIR;
 	void (*free_req1_func)(struct smb_rqst *r);
-	int retries = 0, cur_sleep = 1;
+	int retries = 0, cur_sleep = 0;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -1731,6 +1734,9 @@ smb2_ioctl_query_info(const unsigned int xid,
 	smb2_set_related(&rqst[2]);
 
 	if (retries) {
+		/* Back-off before retry */
+		if (cur_sleep)
+			msleep(cur_sleep);
 		smb2_set_replay(server, &rqst[0]);
 		smb2_set_replay(server, &rqst[1]);
 		smb2_set_replay(server, &rqst[2]);
@@ -2446,7 +2452,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	struct smb2_query_directory_rsp *qd_rsp = NULL;
 	struct smb2_create_rsp *op_rsp = NULL;
 	struct TCP_Server_Info *server;
-	int retries = 0, cur_sleep = 1;
+	int retries = 0, cur_sleep = 0;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -2504,6 +2510,9 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	smb2_set_related(&rqst[1]);
 
 	if (retries) {
+		/* Back-off before retry */
+		if (cur_sleep)
+			msleep(cur_sleep);
 		smb2_set_replay(server, &rqst[0]);
 		smb2_set_replay(server, &rqst[1]);
 	}
@@ -2780,10 +2789,14 @@ bool smb2_should_replay(struct cifs_tcon *tcon,
 		return false;
 
 	if (tcon->retry || (*pretries)++ < tcon->ses->server->retrans) {
-		msleep(*pcur_sleep);
-		(*pcur_sleep) = ((*pcur_sleep) << 1);
-		if ((*pcur_sleep) > CIFS_MAX_SLEEP)
-			(*pcur_sleep) = CIFS_MAX_SLEEP;
+		/* Update sleep time for exponential backoff */
+		if (!(*pcur_sleep))
+			(*pcur_sleep) = 1;
+		else {
+			(*pcur_sleep) = ((*pcur_sleep) << 1);
+			if ((*pcur_sleep) > CIFS_MAX_SLEEP)
+				(*pcur_sleep) = CIFS_MAX_SLEEP;
+		}
 		return true;
 	}
 
@@ -2814,7 +2827,7 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc;
 	__le16 *utf16_path;
 	struct cached_fid *cfid;
-	int retries = 0, cur_sleep = 1;
+	int retries = 0, cur_sleep = 0;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -2904,6 +2917,9 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	smb2_set_related(&rqst[2]);
 
 	if (retries) {
+		/* Back-off before retry */
+		if (cur_sleep)
+			msleep(cur_sleep);
 		if (!cfid) {
 			smb2_set_replay(server, &rqst[0]);
 			smb2_set_replay(server, &rqst[2]);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 5d57c895ca37a..7d75ba675f774 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2904,7 +2904,7 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 	unsigned int total_len;
 	__le16 *utf16_path = NULL;
 	struct TCP_Server_Info *server;
-	int retries = 0, cur_sleep = 1;
+	int retries = 0, cur_sleep = 0;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -3016,8 +3016,12 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 	trace_smb3_posix_mkdir_enter(xid, tcon->tid, ses->Suid, full_path, CREATE_NOT_FILE,
 				    FILE_WRITE_ATTRIBUTES);
 
-	if (retries)
+	if (retries) {
+		/* Back-off before retry */
+		if (cur_sleep)
+			msleep(cur_sleep);
 		smb2_set_replay(server, &rqst);
+	}
 
 	/* resource #4: response buffer */
 	rc = cifs_send_recv(xid, ses, server,
@@ -3265,7 +3269,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	int resp_buftype = CIFS_NO_BUFFER;
 	int rc = 0;
 	int flags = 0;
-	int retries = 0, cur_sleep = 1;
+	int retries = 0, cur_sleep = 0;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -3293,8 +3297,12 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	trace_smb3_open_enter(xid, tcon->tid, tcon->ses->Suid, oparms->path,
 		oparms->create_options, oparms->desired_access);
 
-	if (retries)
+	if (retries) {
+		/* Back-off before retry */
+		if (cur_sleep)
+			msleep(cur_sleep);
 		smb2_set_replay(server, &rqst);
+	}
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags,
@@ -3478,7 +3486,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	int resp_buftype = CIFS_NO_BUFFER;
 	int rc = 0;
 	int flags = 0;
-	int retries = 0, cur_sleep = 1;
+	int retries = 0, cur_sleep = 0;
 
 	if (!tcon)
 		return smb_EIO(smb_eio_trace_null_pointers);
@@ -3518,8 +3526,12 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	if (rc)
 		goto ioctl_exit;
 
-	if (retries)
+	if (retries) {
+		/* Back-off before retry */
+		if (cur_sleep)
+			msleep(cur_sleep);
 		smb2_set_replay(server, &rqst);
+	}
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags,
@@ -3675,7 +3687,7 @@ __SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	int flags = 0;
 	bool query_attrs = false;
-	int retries = 0, cur_sleep = 1;
+	int retries = 0, cur_sleep = 0;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -3707,8 +3719,12 @@ __SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc)
 		goto close_exit;
 
-	if (retries)
+	if (retries) {
+		/* Back-off before retry */
+		if (cur_sleep)
+			msleep(cur_sleep);
 		smb2_set_replay(server, &rqst);
+	}
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
@@ -3878,7 +3894,7 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	struct TCP_Server_Info *server;
 	int flags = 0;
 	bool allocated = false;
-	int retries = 0, cur_sleep = 1;
+	int retries = 0, cur_sleep = 0;
 
 	cifs_dbg(FYI, "Query Info\n");
 
@@ -3912,8 +3928,12 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	trace_smb3_query_info_enter(xid, persistent_fid, tcon->tid,
 				    ses->Suid, info_class, (__u32)info_type);
 
-	if (retries)
+	if (retries) {
+		/* Back-off before retry */
+		if (cur_sleep)
+			msleep(cur_sleep);
 		smb2_set_replay(server, &rqst);
+	}
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
@@ -4069,7 +4089,7 @@ SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
 	int resp_buftype = CIFS_NO_BUFFER;
 	int flags = 0;
 	int rc = 0;
-	int retries = 0, cur_sleep = 1;
+	int retries = 0, cur_sleep = 0;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -4100,8 +4120,12 @@ SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
 	trace_smb3_notify_enter(xid, persistent_fid, tcon->tid, ses->Suid,
 				(u8)watch_tree, completion_filter);
 
-	if (retries)
+	if (retries) {
+		/* Back-off before retry */
+		if (cur_sleep)
+			msleep(cur_sleep);
 		smb2_set_replay(server, &rqst);
+	}
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
@@ -4405,7 +4429,7 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	int resp_buftype = CIFS_NO_BUFFER;
 	int flags = 0;
 	int rc = 0;
-	int retries = 0, cur_sleep = 1;
+	int retries = 0, cur_sleep = 0;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -4431,8 +4455,12 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 
 	trace_smb3_flush_enter(xid, persistent_fid, tcon->tid, ses->Suid);
 
-	if (retries)
+	if (retries) {
+		/* Back-off before retry */
+		if (cur_sleep)
+			msleep(cur_sleep);
 		smb2_set_replay(server, &rqst);
+	}
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
@@ -5190,7 +5218,7 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	int flags = 0;
 	unsigned int total_len;
 	struct TCP_Server_Info *server;
-	int retries = 0, cur_sleep = 1;
+	int retries = 0, cur_sleep = 0;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -5238,8 +5266,12 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = n_vec + 1;
 
-	if (retries)
+	if (retries) {
+		/* Back-off before retry */
+		if (cur_sleep)
+			msleep(cur_sleep);
 		smb2_set_replay(server, &rqst);
+	}
 
 	rc = cifs_send_recv(xid, io_parms->tcon->ses, server,
 			    &rqst,
@@ -5590,7 +5622,7 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_ses *ses = tcon->ses;
 	struct TCP_Server_Info *server;
 	int flags = 0;
-	int retries = 0, cur_sleep = 1;
+	int retries = 0, cur_sleep = 0;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -5615,8 +5647,12 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc)
 		goto qdir_exit;
 
-	if (retries)
+	if (retries) {
+		/* Back-off before retry */
+		if (cur_sleep)
+			msleep(cur_sleep);
 		smb2_set_replay(server, &rqst);
+	}
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
@@ -5725,7 +5761,7 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_ses *ses = tcon->ses;
 	struct TCP_Server_Info *server;
 	int flags = 0;
-	int retries = 0, cur_sleep = 1;
+	int retries = 0, cur_sleep = 0;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -5758,8 +5794,12 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 	}
 
-	if (retries)
+	if (retries) {
+		/* Back-off before retry */
+		if (cur_sleep)
+			msleep(cur_sleep);
 		smb2_set_replay(server, &rqst);
+	}
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags,
@@ -5838,7 +5878,7 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 	struct kvec iov[1];
 	struct kvec rsp_iov;
 	int resp_buf_type;
-	int retries = 0, cur_sleep = 1;
+	int retries = 0, cur_sleep = 0;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -5868,8 +5908,12 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = 1;
 
-	if (retries)
+	if (retries) {
+		/* Back-off before retry */
+		if (cur_sleep)
+			msleep(cur_sleep);
 		smb2_set_replay(server, &rqst);
+	}
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buf_type, flags, &rsp_iov);
@@ -5971,7 +6015,7 @@ SMB311_posix_qfs_info(const unsigned int xid, struct cifs_tcon *tcon,
 	struct TCP_Server_Info *server;
 	FILE_SYSTEM_POSIX_INFO *info = NULL;
 	int flags = 0;
-	int retries = 0, cur_sleep = 1;
+	int retries = 0, cur_sleep = 0;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -5992,8 +6036,12 @@ SMB311_posix_qfs_info(const unsigned int xid, struct cifs_tcon *tcon,
 	rqst.rq_iov = &iov;
 	rqst.rq_nvec = 1;
 
-	if (retries)
+	if (retries) {
+		/* Back-off before retry */
+		if (cur_sleep)
+			msleep(cur_sleep);
 		smb2_set_replay(server, &rqst);
+	}
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
@@ -6036,7 +6084,7 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	struct TCP_Server_Info *server;
 	unsigned int rsp_len, offset;
 	int flags = 0;
-	int retries = 0, cur_sleep = 1;
+	int retries = 0, cur_sleep = 0;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -6073,8 +6121,12 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	rqst.rq_iov = &iov;
 	rqst.rq_nvec = 1;
 
-	if (retries)
+	if (retries) {
+		/* Back-off before retry */
+		if (cur_sleep)
+			msleep(cur_sleep);
 		smb2_set_replay(server, &rqst);
+	}
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
@@ -6136,7 +6188,7 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	int flags = CIFS_NO_RSP_BUF;
 	unsigned int total_len;
 	struct TCP_Server_Info *server;
-	int retries = 0, cur_sleep = 1;
+	int retries = 0, cur_sleep = 0;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -6172,8 +6224,12 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = 2;
 
-	if (retries)
+	if (retries) {
+		/* Back-off before retry */
+		if (cur_sleep)
+			msleep(cur_sleep);
 		smb2_set_replay(server, &rqst);
+	}
 
 	rc = cifs_send_recv(xid, tcon->ses, server,
 			    &rqst, &resp_buf_type, flags,
-- 
2.43.0

