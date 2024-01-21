Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2AD14A86
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jan 2024 03:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705808025; cv=none; b=sgruGOO0VuAA9FeWRR+XRU4kitnvedGv2ZpXfQEYhFxxDm8gi1UxRUM2RK1/OkK1VyNHQdxR6PF2+pJVql+TFVMUZQi5p+Mzq23jGZEtfhLyh2TNflkkSe3Ua0q2cxGziuJijVT9MngXo3nQIdJC/IVwnTRHsFVIo+pKTEx7AuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705808025; c=relaxed/simple;
	bh=ACUKW61VnFCKrGirXbbh16DNdV4WxTJVl68UVrTgkaw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=efHQokOF8MINJ8qmLPv/9rGdJlMf8pPmD/7LSJ5RCvLWtSyR95yUUweGsGJXy7ss+qhJwnHNEYaedv+uhW6jlofO51sH6FEn2+nUIcUB8O4HRZ8qSGO9iHS56Ldt1hIkO4CyGGZ4lfX7EpfnkH3vF0oz8DOb5xDKsuIqBZvPM9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A07fmKVC; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A07fmKVC"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1d71b62fa87so11904015ad.0
        for <linux-cifs@vger.kernel.org>; Sat, 20 Jan 2024 19:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705808022; x=1706412822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8J1zc9ROEEswjbAYhC6JG1/9upIrapKab842HdC4SkY=;
        b=A07fmKVCeGggUkN28SBsT2BzpMg3oVw44gCszuOsAxsVj29klI0n3i8ihq1L6bxCwP
         ncWN8b+F0BYDhd4rqBL2m766ohH9nACEHMXvLtP1I2Ch+bCt3Jcs4UMtIlqElL3enQls
         mu0NL++IvMWGH/efnlUzFAhMhRjizNJsFsDi7B0y4rjv5Hb6MfWu7FqgORDCeEXV80KN
         dCeiiFXxfpeGKSUwffI+tuOANlIvbVGXOgMKW9esaM/yao9yrdp1pFCawSum2UHs5cQ9
         rzWbH4Jm7d/p8cqJnqiPjUKKTWY31Tk4rsDT7amFvVBbU4vgH13BOVwDOidGy11Lrj6F
         PXnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705808022; x=1706412822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8J1zc9ROEEswjbAYhC6JG1/9upIrapKab842HdC4SkY=;
        b=dReoCeCXc/lyabZ4IQyX2SeRN27sI06qJAn8opVQJHGHW7O4xrGxDH+b8A5h1vK3no
         26GKAEqXZQ5CWVe4kHfO2KXedSXjNYRYPY/K1+YLbpOBms6rNaW8UkTQDSFq9eLx1qJm
         yXoaUO1/xVKznwYZfcQmMsXMd57AeJg6rMN7o+IEeDwLJgj3gM1KTwRum1Ro4AoFgPjo
         IdLkB3i2AFYDvFAUWi8hgxDMMZWF71nI+ZCc42ibcr0PZL6378XSEgpNmqChLC9wKqgV
         KU66Vm67S/VMEkpenBxp7Hqk2Z9bN+A1Q3QtPg/mo+5gF82napQLWWAIxHPGr5rhG/8x
         x/9Q==
X-Gm-Message-State: AOJu0Yz/bRIhc5J0ieVjfLkaUco4DjvLCkcMutSEw8XDgfWfDvLxzwIB
	CcN6xm6KG83sJHy03GGbsSpCccILA4O/7jURVRQuva3srAo/Vjbq0r7SvdqX
X-Google-Smtp-Source: AGHT+IEh6P60T1kLGz1xRJdWtQEJBDZ/Zbn20SnoziSeYhkVhHAEY/E2kT81W6mxq/+eFwCY2Jjqgg==
X-Received: by 2002:a17:902:c40e:b0:1d7:2337:9ff4 with SMTP id k14-20020a170902c40e00b001d723379ff4mr3364010plk.46.1705808022079;
        Sat, 20 Jan 2024 19:33:42 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id lg14-20020a170902fb8e00b001d058ad8770sm5193166plb.306.2024.01.20.19.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jan 2024 19:33:41 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	tom@talpey.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 6/7] cifs: commands that are retried should have replay flag set
Date: Sun, 21 Jan 2024 03:32:47 +0000
Message-Id: <20240121033248.125282-6-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240121033248.125282-1-sprasad@microsoft.com>
References: <20240121033248.125282-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

MS-SMB2 states that the header flag SMB2_FLAGS_REPLAY_OPERATION
needs to be set when a command needs to be retried, so that
the server is aware that this is a replay for an operation that
appeared before.

This can be very important, for example, for state changing
operations and opens which get retried following a reconnect;
since the client maybe unaware of the status of the previous
open.

This is particularly important for multichannel scenario, since
disconnection of one connection does not mean that the session
is lost. The requests can be replayed on another channel.

This change also makes use of exponential back-off before replays
and also limits the number of retries to "retrans" mount option
value.

Also, this change does not modify the read/write codepath.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c |  23 +++-
 fs/smb/client/cifsglob.h   |   5 +
 fs/smb/client/smb2inode.c  |  33 ++++-
 fs/smb/client/smb2ops.c    | 123 ++++++++++++++++--
 fs/smb/client/smb2pdu.c    | 260 +++++++++++++++++++++++++++++++++----
 fs/smb/client/smb2proto.h  |   5 +
 6 files changed, 404 insertions(+), 45 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 5730c65ffb40..1daeb5714faa 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -145,21 +145,27 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	struct cached_fid *cfid;
 	struct cached_fids *cfids;
 	const char *npath;
+	int retries = 0, cur_sleep = 1;
 
 	if (tcon == NULL || tcon->cfids == NULL || tcon->nohandlecache ||
 	    is_smb1_server(tcon->ses->server) || (dir_cache_timeout == 0))
 		return -EOPNOTSUPP;
 
 	ses = tcon->ses;
-	server = cifs_pick_channel(ses);
 	cfids = tcon->cfids;
 
-	if (!server->ops->new_lease_key)
-		return -EIO;
-
 	if (cifs_sb->root == NULL)
 		return -ENOENT;
 
+replay_again:
+	/* reinitialize for possible replay */
+	flags = 0;
+	oplock = SMB2_OPLOCK_LEVEL_II;
+	server = cifs_pick_channel(ses);
+
+	if (!server->ops->new_lease_key)
+		return -EIO;
+
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (!utf16_path)
 		return -ENOMEM;
@@ -268,6 +274,11 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	 */
 	cfid->has_lease = true;
 
+	if (retries) {
+		smb2_set_replay(server, &rqst[0]);
+		smb2_set_replay(server, &rqst[1]);
+	}
+
 	rc = compound_send_recv(xid, ses, server,
 				flags, 2, rqst,
 				resp_buftype, rsp_iov);
@@ -368,6 +379,10 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	}
 	kfree(utf16_path);
 
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon, &retries, &cur_sleep))
+		goto replay_again;
+
 	return rc;
 }
 
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 6e4cfaec98e3..b5abe4d6f478 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -49,6 +49,11 @@
  */
 #define CIFS_DEF_ACTIMEO (1 * HZ)
 
+/*
+ * max sleep time before retry to server
+ */
+#define CIFS_MAX_SLEEP 2000
+
 /*
  * max attribute cache timeout (jiffies) - 2^30
  */
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index a652200540c8..05818cd6d932 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -120,6 +120,14 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	unsigned int size[2];
 	void *data[2];
 	int len;
+	int retries = 0, cur_sleep = 1;
+
+replay_again:
+	/* reinitialize for possible replay */
+	flags = 0;
+	oplock = SMB2_OPLOCK_LEVEL_NONE;
+	num_rqst = 0;
+	server = cifs_pick_channel(ses);
 
 	vars = kzalloc(sizeof(*vars), GFP_ATOMIC);
 	if (vars == NULL)
@@ -127,8 +135,6 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	rqst = &vars->rqst[0];
 	rsp_iov = &vars->rsp_iov[0];
 
-	server = cifs_pick_channel(ses);
-
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
@@ -463,15 +469,24 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	num_rqst++;
 
 	if (cfile) {
+		if (retries)
+			for (i = 1; i < num_rqst - 2; i++)
+				smb2_set_replay(server, &rqst[i]);
+
 		rc = compound_send_recv(xid, ses, server,
 					flags, num_rqst - 2,
 					&rqst[1], &resp_buftype[1],
 					&rsp_iov[1]);
-	} else
+	} else {
+		if (retries)
+			for (i = 0; i < num_rqst; i++)
+				smb2_set_replay(server, &rqst[i]);
+
 		rc = compound_send_recv(xid, ses, server,
 					flags, num_rqst,
 					rqst, resp_buftype,
 					rsp_iov);
+	}
 
 finished:
 	num_rqst = 0;
@@ -620,9 +635,6 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 	SMB2_close_free(&rqst[num_rqst]);
 
-	if (cfile)
-		cifsFileInfo_put(cfile);
-
 	num_cmds += 2;
 	if (out_iov && out_buftype) {
 		memcpy(out_iov, rsp_iov, num_cmds * sizeof(*out_iov));
@@ -632,7 +644,16 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		for (i = 0; i < num_cmds; i++)
 			free_rsp_buf(resp_buftype[i], rsp_iov[i].iov_base);
 	}
+	num_cmds -= 2; /* correct num_cmds as there could be a retry */
 	kfree(vars);
+
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon, &retries, &cur_sleep))
+		goto replay_again;
+
+	if (cfile)
+		cifsFileInfo_put(cfile);
+
 	return rc;
 }
 
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index e23577584ed6..17df0cd78698 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1108,7 +1108,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	struct smb2_compound_vars *vars;
 	struct cifs_ses *ses = tcon->ses;
-	struct TCP_Server_Info *server = cifs_pick_channel(ses);
+	struct TCP_Server_Info *server;
 	struct smb_rqst *rqst;
 	struct kvec *rsp_iov;
 	__le16 *utf16_path = NULL;
@@ -1124,6 +1124,13 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	struct smb2_file_full_ea_info *ea = NULL;
 	struct smb2_query_info_rsp *rsp;
 	int rc, used_len = 0;
+	int retries = 0, cur_sleep = 1;
+
+replay_again:
+	/* reinitialize for possible replay */
+	flags = CIFS_CP_CREATE_CLOSE_OP;
+	oplock = SMB2_OPLOCK_LEVEL_NONE;
+	server = cifs_pick_channel(ses);
 
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
@@ -1244,6 +1251,12 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 		goto sea_exit;
 	smb2_set_related(&rqst[2]);
 
+	if (retries) {
+		smb2_set_replay(server, &rqst[0]);
+		smb2_set_replay(server, &rqst[1]);
+		smb2_set_replay(server, &rqst[2]);
+	}
+
 	rc = compound_send_recv(xid, ses, server,
 				flags, 3, rqst,
 				resp_buftype, rsp_iov);
@@ -1260,6 +1273,11 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	kfree(vars);
 out_free_path:
 	kfree(utf16_path);
+
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon, &retries, &cur_sleep))
+		goto replay_again;
+
 	return rc;
 }
 #endif
@@ -1484,7 +1502,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 	struct smb_rqst *rqst;
 	struct kvec *rsp_iov;
 	struct cifs_ses *ses = tcon->ses;
-	struct TCP_Server_Info *server = cifs_pick_channel(ses);
+	struct TCP_Server_Info *server;
 	char __user *arg = (char __user *)p;
 	struct smb_query_info qi;
 	struct smb_query_info __user *pqi;
@@ -1501,6 +1519,13 @@ smb2_ioctl_query_info(const unsigned int xid,
 	void *data[2];
 	int create_options = is_dir ? CREATE_NOT_FILE : CREATE_NOT_DIR;
 	void (*free_req1_func)(struct smb_rqst *r);
+	int retries = 0, cur_sleep = 1;
+
+replay_again:
+	/* reinitialize for possible replay */
+	flags = CIFS_CP_CREATE_CLOSE_OP;
+	oplock = SMB2_OPLOCK_LEVEL_NONE;
+	server = cifs_pick_channel(ses);
 
 	vars = kzalloc(sizeof(*vars), GFP_ATOMIC);
 	if (vars == NULL)
@@ -1641,6 +1666,12 @@ smb2_ioctl_query_info(const unsigned int xid,
 		goto free_req_1;
 	smb2_set_related(&rqst[2]);
 
+	if (retries) {
+		smb2_set_replay(server, &rqst[0]);
+		smb2_set_replay(server, &rqst[1]);
+		smb2_set_replay(server, &rqst[2]);
+	}
+
 	rc = compound_send_recv(xid, ses, server,
 				flags, 3, rqst,
 				resp_buftype, rsp_iov);
@@ -1701,6 +1732,11 @@ smb2_ioctl_query_info(const unsigned int xid,
 	kfree(buffer);
 free_vars:
 	kfree(vars);
+
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon, &retries, &cur_sleep))
+		goto replay_again;
+
 	return rc;
 }
 
@@ -2227,8 +2263,14 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_open_parms oparms;
 	struct smb2_query_directory_rsp *qd_rsp = NULL;
 	struct smb2_create_rsp *op_rsp = NULL;
-	struct TCP_Server_Info *server = cifs_pick_channel(tcon->ses);
-	int retry_count = 0;
+	struct TCP_Server_Info *server;
+	int retries = 0, cur_sleep = 1;
+
+replay_again:
+	/* reinitialize for possible replay */
+	flags = 0;
+	oplock = SMB2_OPLOCK_LEVEL_NONE;
+	server = cifs_pick_channel(tcon->ses);
 
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (!utf16_path)
@@ -2278,14 +2320,15 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 
 	smb2_set_related(&rqst[1]);
 
-again:
+	if (retries) {
+		smb2_set_replay(server, &rqst[0]);
+		smb2_set_replay(server, &rqst[1]);
+	}
+
 	rc = compound_send_recv(xid, tcon->ses, server,
 				flags, 2, rqst,
 				resp_buftype, rsp_iov);
 
-	if (rc == -EAGAIN && retry_count++ < 10)
-		goto again;
-
 	/* If the open failed there is nothing to do */
 	op_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
 	if (op_rsp == NULL || op_rsp->hdr.Status != STATUS_SUCCESS) {
@@ -2333,6 +2376,11 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	SMB2_query_directory_free(&rqst[1]);
 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
+
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon, &retries, &cur_sleep))
+		goto replay_again;
+
 	return rc;
 }
 
@@ -2457,6 +2505,22 @@ smb2_oplock_response(struct cifs_tcon *tcon, __u64 persistent_fid,
 				 CIFS_CACHE_READ(cinode) ? 1 : 0);
 }
 
+void
+smb2_set_replay(struct TCP_Server_Info *server, struct smb_rqst *rqst)
+{
+	struct smb2_hdr *shdr;
+
+	if (server->dialect < SMB30_PROT_ID)
+		return;
+
+	shdr = (struct smb2_hdr *)(rqst->rq_iov[0].iov_base);
+	if (shdr == NULL) {
+		cifs_dbg(FYI, "shdr NULL in smb2_set_related\n");
+		return;
+	}
+	shdr->Flags |= SMB2_FLAGS_REPLAY_OPERATION;
+}
+
 void
 smb2_set_related(struct smb_rqst *rqst)
 {
@@ -2529,6 +2593,27 @@ smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
 	shdr->NextCommand = cpu_to_le32(len);
 }
 
+/*
+ * helper function for exponential backoff and check if replayable
+ */
+bool smb2_should_replay(struct cifs_tcon *tcon,
+				int *pretries,
+				int *pcur_sleep)
+{
+	if (!pretries || !pcur_sleep)
+		return false;
+
+	if (tcon->retry || (*pretries)++ < tcon->ses->server->retrans) {
+		msleep(*pcur_sleep);
+		(*pcur_sleep) = ((*pcur_sleep) << 1);
+		if ((*pcur_sleep) > CIFS_MAX_SLEEP)
+			(*pcur_sleep) = CIFS_MAX_SLEEP;
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * Passes the query info response back to the caller on success.
  * Caller need to free this with free_rsp_buf().
@@ -2542,7 +2627,7 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	struct smb2_compound_vars *vars;
 	struct cifs_ses *ses = tcon->ses;
-	struct TCP_Server_Info *server = cifs_pick_channel(ses);
+	struct TCP_Server_Info *server;
 	int flags = CIFS_CP_CREATE_CLOSE_OP;
 	struct smb_rqst *rqst;
 	int resp_buftype[3];
@@ -2553,6 +2638,13 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc;
 	__le16 *utf16_path;
 	struct cached_fid *cfid = NULL;
+	int retries = 0, cur_sleep = 1;
+
+replay_again:
+	/* reinitialize for possible replay */
+	flags = CIFS_CP_CREATE_CLOSE_OP;
+	oplock = SMB2_OPLOCK_LEVEL_NONE;
+	server = cifs_pick_channel(ses);
 
 	if (!path)
 		path = "";
@@ -2633,6 +2725,14 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 		goto qic_exit;
 	smb2_set_related(&rqst[2]);
 
+	if (retries) {
+		if (!cfid) {
+			smb2_set_replay(server, &rqst[0]);
+			smb2_set_replay(server, &rqst[2]);
+		}
+		smb2_set_replay(server, &rqst[1]);
+	}
+
 	if (cfid) {
 		rc = compound_send_recv(xid, ses, server,
 					flags, 1, &rqst[1],
@@ -2665,6 +2765,11 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	kfree(vars);
 out_free_path:
 	kfree(utf16_path);
+
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon, &retries, &cur_sleep))
+		goto replay_again;
+
 	return rc;
 }
 
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 5126f5f97969..0291482a3f51 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2764,7 +2764,14 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 	int flags = 0;
 	unsigned int total_len;
 	__le16 *utf16_path = NULL;
-	struct TCP_Server_Info *server = cifs_pick_channel(ses);
+	struct TCP_Server_Info *server;
+	int retries = 0, cur_sleep = 1;
+
+replay_again:
+	/* reinitialize for possible replay */
+	flags = 0;
+	n_iov = 2;
+	server = cifs_pick_channel(ses);
 
 	cifs_dbg(FYI, "mkdir\n");
 
@@ -2868,6 +2875,10 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 	/* no need to inc num_remote_opens because we close it just below */
 	trace_smb3_posix_mkdir_enter(xid, tcon->tid, ses->Suid, full_path, CREATE_NOT_FILE,
 				    FILE_WRITE_ATTRIBUTES);
+
+	if (retries)
+		smb2_set_replay(server, &rqst);
+
 	/* resource #4: response buffer */
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
@@ -2905,6 +2916,11 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 	cifs_small_buf_release(req);
 err_free_path:
 	kfree(utf16_path);
+
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon, &retries, &cur_sleep))
+		goto replay_again;
+
 	return rc;
 }
 
@@ -3100,12 +3116,18 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	struct smb2_create_rsp *rsp = NULL;
 	struct cifs_tcon *tcon = oparms->tcon;
 	struct cifs_ses *ses = tcon->ses;
-	struct TCP_Server_Info *server = cifs_pick_channel(ses);
+	struct TCP_Server_Info *server;
 	struct kvec iov[SMB2_CREATE_IOV_SIZE];
 	struct kvec rsp_iov = {NULL, 0};
 	int resp_buftype = CIFS_NO_BUFFER;
 	int rc = 0;
 	int flags = 0;
+	int retries = 0, cur_sleep = 1;
+
+replay_again:
+	/* reinitialize for possible replay */
+	flags = 0;
+	server = cifs_pick_channel(ses);
 
 	cifs_dbg(FYI, "create/open\n");
 	if (!ses || !server)
@@ -3127,6 +3149,9 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	trace_smb3_open_enter(xid, tcon->tid, tcon->ses->Suid, oparms->path,
 		oparms->create_options, oparms->desired_access);
 
+	if (retries)
+		smb2_set_replay(server, &rqst);
+
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags,
 			    &rsp_iov);
@@ -3180,6 +3205,11 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 creat_exit:
 	SMB2_open_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp);
+
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon, &retries, &cur_sleep))
+		goto replay_again;
+
 	return rc;
 }
 
@@ -3304,15 +3334,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	int resp_buftype = CIFS_NO_BUFFER;
 	int rc = 0;
 	int flags = 0;
-
-	cifs_dbg(FYI, "SMB2 IOCTL\n");
-
-	if (out_data != NULL)
-		*out_data = NULL;
-
-	/* zero out returned data len, in case of error */
-	if (plen)
-		*plen = 0;
+	int retries = 0, cur_sleep = 1;
 
 	if (!tcon)
 		return -EIO;
@@ -3321,10 +3343,23 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	if (!ses)
 		return -EIO;
 
+replay_again:
+	/* reinitialize for possible replay */
+	flags = 0;
 	server = cifs_pick_channel(ses);
+
 	if (!server)
 		return -EIO;
 
+	cifs_dbg(FYI, "SMB2 IOCTL\n");
+
+	if (out_data != NULL)
+		*out_data = NULL;
+
+	/* zero out returned data len, in case of error */
+	if (plen)
+		*plen = 0;
+
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
@@ -3339,6 +3374,9 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	if (rc)
 		goto ioctl_exit;
 
+	if (retries)
+		smb2_set_replay(server, &rqst);
+
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags,
 			    &rsp_iov);
@@ -3408,6 +3446,11 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 ioctl_exit:
 	SMB2_ioctl_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp);
+
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon, &retries, &cur_sleep))
+		goto replay_again;
+
 	return rc;
 }
 
@@ -3479,13 +3522,20 @@ __SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	struct smb_rqst rqst;
 	struct smb2_close_rsp *rsp = NULL;
 	struct cifs_ses *ses = tcon->ses;
-	struct TCP_Server_Info *server = cifs_pick_channel(ses);
+	struct TCP_Server_Info *server;
 	struct kvec iov[1];
 	struct kvec rsp_iov;
 	int resp_buftype = CIFS_NO_BUFFER;
 	int rc = 0;
 	int flags = 0;
 	bool query_attrs = false;
+	int retries = 0, cur_sleep = 1;
+
+replay_again:
+	/* reinitialize for possible replay */
+	flags = 0;
+	query_attrs = false;
+	server = cifs_pick_channel(ses);
 
 	cifs_dbg(FYI, "Close\n");
 
@@ -3511,6 +3561,9 @@ __SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc)
 		goto close_exit;
 
+	if (retries)
+		smb2_set_replay(server, &rqst);
+
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
 	rsp = (struct smb2_close_rsp *)rsp_iov.iov_base;
@@ -3544,6 +3597,11 @@ __SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 			cifs_dbg(VFS, "handle cancelled close fid 0x%llx returned error %d\n",
 				 persistent_fid, tmp_rc);
 	}
+
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon, &retries, &cur_sleep))
+		goto replay_again;
+
 	return rc;
 }
 
@@ -3674,12 +3732,19 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	struct TCP_Server_Info *server;
 	int flags = 0;
 	bool allocated = false;
+	int retries = 0, cur_sleep = 1;
 
 	cifs_dbg(FYI, "Query Info\n");
 
 	if (!ses)
 		return -EIO;
+
+replay_again:
+	/* reinitialize for possible replay */
+	flags = 0;
+	allocated = false;
 	server = cifs_pick_channel(ses);
+
 	if (!server)
 		return -EIO;
 
@@ -3701,6 +3766,9 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	trace_smb3_query_info_enter(xid, persistent_fid, tcon->tid,
 				    ses->Suid, info_class, (__u32)info_type);
 
+	if (retries)
+		smb2_set_replay(server, &rqst);
+
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
 	rsp = (struct smb2_query_info_rsp *)rsp_iov.iov_base;
@@ -3743,6 +3811,11 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 qinf_exit:
 	SMB2_query_info_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp);
+
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon, &retries, &cur_sleep))
+		goto replay_again;
+
 	return rc;
 }
 
@@ -3843,7 +3916,7 @@ SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
 		u32 *plen /* returned data len */)
 {
 	struct cifs_ses *ses = tcon->ses;
-	struct TCP_Server_Info *server = cifs_pick_channel(ses);
+	struct TCP_Server_Info *server;
 	struct smb_rqst rqst;
 	struct smb2_change_notify_rsp *smb_rsp;
 	struct kvec iov[1];
@@ -3851,6 +3924,12 @@ SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
 	int resp_buftype = CIFS_NO_BUFFER;
 	int flags = 0;
 	int rc = 0;
+	int retries = 0, cur_sleep = 1;
+
+replay_again:
+	/* reinitialize for possible replay */
+	flags = 0;
+	server = cifs_pick_channel(ses);
 
 	cifs_dbg(FYI, "change notify\n");
 	if (!ses || !server)
@@ -3875,6 +3954,10 @@ SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
 
 	trace_smb3_notify_enter(xid, persistent_fid, tcon->tid, ses->Suid,
 				(u8)watch_tree, completion_filter);
+
+	if (retries)
+		smb2_set_replay(server, &rqst);
+
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
 
@@ -3909,6 +3992,11 @@ SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rqst.rq_iov)
 		cifs_small_buf_release(rqst.rq_iov[0].iov_base); /* request */
 	free_rsp_buf(resp_buftype, rsp_iov.iov_base);
+
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon, &retries, &cur_sleep))
+		goto replay_again;
+
 	return rc;
 }
 
@@ -4151,10 +4239,16 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	struct smb_rqst rqst;
 	struct kvec iov[1];
 	struct kvec rsp_iov = {NULL, 0};
-	struct TCP_Server_Info *server = cifs_pick_channel(ses);
+	struct TCP_Server_Info *server;
 	int resp_buftype = CIFS_NO_BUFFER;
 	int flags = 0;
 	int rc = 0;
+	int retries = 0, cur_sleep = 1;
+
+replay_again:
+	/* reinitialize for possible replay */
+	flags = 0;
+	server = cifs_pick_channel(ses);
 
 	cifs_dbg(FYI, "flush\n");
 	if (!ses || !(ses->server))
@@ -4174,6 +4268,10 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 		goto flush_exit;
 
 	trace_smb3_flush_enter(xid, persistent_fid, tcon->tid, ses->Suid);
+
+	if (retries)
+		smb2_set_replay(server, &rqst);
+
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
 
@@ -4188,6 +4286,11 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
  flush_exit:
 	SMB2_flush_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp_iov.iov_base);
+
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon, &retries, &cur_sleep))
+		goto replay_again;
+
 	return rc;
 }
 
@@ -4825,18 +4928,21 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	int flags = 0;
 	unsigned int total_len;
 	struct TCP_Server_Info *server;
+	int retries = 0, cur_sleep = 1;
 
+replay_again:
+	/* reinitialize for possible replay */
+	flags = 0;
 	*nbytes = 0;
-
-	if (n_vec < 1)
-		return rc;
-
 	if (!io_parms->server)
 		io_parms->server = cifs_pick_channel(io_parms->tcon->ses);
 	server = io_parms->server;
 	if (server == NULL)
 		return -ECONNABORTED;
 
+	if (n_vec < 1)
+		return rc;
+
 	rc = smb2_plain_req_init(SMB2_WRITE, io_parms->tcon, server,
 				 (void **) &req, &total_len);
 	if (rc)
@@ -4870,6 +4976,9 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = n_vec + 1;
 
+	if (retries)
+		smb2_set_replay(server, &rqst);
+
 	rc = cifs_send_recv(xid, io_parms->tcon->ses, server,
 			    &rqst,
 			    &resp_buftype, flags, &rsp_iov);
@@ -4894,6 +5003,11 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	cifs_small_buf_release(req);
 	free_rsp_buf(resp_buftype, rsp);
+
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(io_parms->tcon, &retries, &cur_sleep))
+		goto replay_again;
+
 	return rc;
 }
 
@@ -5205,8 +5319,14 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	struct kvec rsp_iov;
 	int rc = 0;
 	struct cifs_ses *ses = tcon->ses;
-	struct TCP_Server_Info *server = cifs_pick_channel(ses);
+	struct TCP_Server_Info *server;
 	int flags = 0;
+	int retries = 0, cur_sleep = 1;
+
+replay_again:
+	/* reinitialize for possible replay */
+	flags = 0;
+	server = cifs_pick_channel(ses);
 
 	if (!ses || !(ses->server))
 		return -EIO;
@@ -5226,6 +5346,9 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc)
 		goto qdir_exit;
 
+	if (retries)
+		smb2_set_replay(server, &rqst);
+
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
 	rsp = (struct smb2_query_directory_rsp *)rsp_iov.iov_base;
@@ -5260,6 +5383,11 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 qdir_exit:
 	SMB2_query_directory_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp);
+
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon, &retries, &cur_sleep))
+		goto replay_again;
+
 	return rc;
 }
 
@@ -5326,8 +5454,14 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	int resp_buftype;
 	struct cifs_ses *ses = tcon->ses;
-	struct TCP_Server_Info *server = cifs_pick_channel(ses);
+	struct TCP_Server_Info *server;
 	int flags = 0;
+	int retries = 0, cur_sleep = 1;
+
+replay_again:
+	/* reinitialize for possible replay */
+	flags = 0;
+	server = cifs_pick_channel(ses);
 
 	if (!ses || !server)
 		return -EIO;
@@ -5355,6 +5489,8 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 	}
 
+	if (retries)
+		smb2_set_replay(server, &rqst);
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags,
@@ -5370,6 +5506,11 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 
 	free_rsp_buf(resp_buftype, rsp);
 	kfree(iov);
+
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon, &retries, &cur_sleep))
+		goto replay_again;
+
 	return rc;
 }
 
@@ -5422,12 +5563,18 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc;
 	struct smb2_oplock_break *req = NULL;
 	struct cifs_ses *ses = tcon->ses;
-	struct TCP_Server_Info *server = cifs_pick_channel(ses);
+	struct TCP_Server_Info *server;
 	int flags = CIFS_OBREAK_OP;
 	unsigned int total_len;
 	struct kvec iov[1];
 	struct kvec rsp_iov;
 	int resp_buf_type;
+	int retries = 0, cur_sleep = 1;
+
+replay_again:
+	/* reinitialize for possible replay */
+	flags = CIFS_OBREAK_OP;
+	server = cifs_pick_channel(ses);
 
 	cifs_dbg(FYI, "SMB2_oplock_break\n");
 	rc = smb2_plain_req_init(SMB2_OPLOCK_BREAK, tcon, server,
@@ -5452,15 +5599,21 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = 1;
 
+	if (retries)
+		smb2_set_replay(server, &rqst);
+
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buf_type, flags, &rsp_iov);
 	cifs_small_buf_release(req);
-
 	if (rc) {
 		cifs_stats_fail_inc(tcon, SMB2_OPLOCK_BREAK_HE);
 		cifs_dbg(FYI, "Send error in Oplock Break = %d\n", rc);
 	}
 
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon, &retries, &cur_sleep))
+		goto replay_again;
+
 	return rc;
 }
 
@@ -5546,9 +5699,15 @@ SMB311_posix_qfs_info(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	int resp_buftype;
 	struct cifs_ses *ses = tcon->ses;
-	struct TCP_Server_Info *server = cifs_pick_channel(ses);
+	struct TCP_Server_Info *server;
 	FILE_SYSTEM_POSIX_INFO *info = NULL;
 	int flags = 0;
+	int retries = 0, cur_sleep = 1;
+
+replay_again:
+	/* reinitialize for possible replay */
+	flags = 0;
+	server = cifs_pick_channel(ses);
 
 	rc = build_qfs_info_req(&iov, tcon, server,
 				FS_POSIX_INFORMATION,
@@ -5564,6 +5723,9 @@ SMB311_posix_qfs_info(const unsigned int xid, struct cifs_tcon *tcon,
 	rqst.rq_iov = &iov;
 	rqst.rq_nvec = 1;
 
+	if (retries)
+		smb2_set_replay(server, &rqst);
+
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
 	free_qfs_info_req(&iov);
@@ -5583,6 +5745,11 @@ SMB311_posix_qfs_info(const unsigned int xid, struct cifs_tcon *tcon,
 
 posix_qfsinf_exit:
 	free_rsp_buf(resp_buftype, rsp_iov.iov_base);
+
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon, &retries, &cur_sleep))
+		goto replay_again;
+
 	return rc;
 }
 
@@ -5597,9 +5764,15 @@ SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	int resp_buftype;
 	struct cifs_ses *ses = tcon->ses;
-	struct TCP_Server_Info *server = cifs_pick_channel(ses);
+	struct TCP_Server_Info *server;
 	struct smb2_fs_full_size_info *info = NULL;
 	int flags = 0;
+	int retries = 0, cur_sleep = 1;
+
+replay_again:
+	/* reinitialize for possible replay */
+	flags = 0;
+	server = cifs_pick_channel(ses);
 
 	rc = build_qfs_info_req(&iov, tcon, server,
 				FS_FULL_SIZE_INFORMATION,
@@ -5615,6 +5788,9 @@ SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 	rqst.rq_iov = &iov;
 	rqst.rq_nvec = 1;
 
+	if (retries)
+		smb2_set_replay(server, &rqst);
+
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
 	free_qfs_info_req(&iov);
@@ -5634,6 +5810,11 @@ SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 
 qfsinf_exit:
 	free_rsp_buf(resp_buftype, rsp_iov.iov_base);
+
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon, &retries, &cur_sleep))
+		goto replay_again;
+
 	return rc;
 }
 
@@ -5648,9 +5829,15 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	int resp_buftype, max_len, min_len;
 	struct cifs_ses *ses = tcon->ses;
-	struct TCP_Server_Info *server = cifs_pick_channel(ses);
+	struct TCP_Server_Info *server;
 	unsigned int rsp_len, offset;
 	int flags = 0;
+	int retries = 0, cur_sleep = 1;
+
+replay_again:
+	/* reinitialize for possible replay */
+	flags = 0;
+	server = cifs_pick_channel(ses);
 
 	if (level == FS_DEVICE_INFORMATION) {
 		max_len = sizeof(FILE_SYSTEM_DEVICE_INFO);
@@ -5682,6 +5869,9 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	rqst.rq_iov = &iov;
 	rqst.rq_nvec = 1;
 
+	if (retries)
+		smb2_set_replay(server, &rqst);
+
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
 	free_qfs_info_req(&iov);
@@ -5719,6 +5909,11 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 
 qfsattr_exit:
 	free_rsp_buf(resp_buftype, rsp_iov.iov_base);
+
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon, &retries, &cur_sleep))
+		goto replay_again;
+
 	return rc;
 }
 
@@ -5736,7 +5931,13 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	unsigned int count;
 	int flags = CIFS_NO_RSP_BUF;
 	unsigned int total_len;
-	struct TCP_Server_Info *server = cifs_pick_channel(tcon->ses);
+	struct TCP_Server_Info *server;
+	int retries = 0, cur_sleep = 1;
+
+replay_again:
+	/* reinitialize for possible replay */
+	flags = CIFS_NO_RSP_BUF;
+	server = cifs_pick_channel(tcon->ses);
 
 	cifs_dbg(FYI, "smb2_lockv num lock %d\n", num_lock);
 
@@ -5767,6 +5968,9 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = 2;
 
+	if (retries)
+		smb2_set_replay(server, &rqst);
+
 	rc = cifs_send_recv(xid, tcon->ses, server,
 			    &rqst, &resp_buf_type, flags,
 			    &rsp_iov);
@@ -5778,6 +5982,10 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 				    tcon->ses->Suid, rc);
 	}
 
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon, &retries, &cur_sleep))
+		goto replay_again;
+
 	return rc;
 }
 
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 0034b537b0b3..b3069911e9dd 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -122,6 +122,11 @@ extern unsigned long smb_rqst_len(struct TCP_Server_Info *server,
 extern void smb2_set_next_command(struct cifs_tcon *tcon,
 				  struct smb_rqst *rqst);
 extern void smb2_set_related(struct smb_rqst *rqst);
+extern void smb2_set_replay(struct TCP_Server_Info *server,
+			    struct smb_rqst *rqst);
+extern bool smb2_should_replay(struct cifs_tcon *tcon,
+			  int *pretries,
+			  int *pcur_sleep);
 
 /*
  * SMB2 Worker functions - most of protocol specific implementation details
-- 
2.34.1

