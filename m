Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDDD38735D
	for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 06:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776753618; cv=none; b=Ye5dpmcRrUr9fk+OlRJYR7KffuIW+UFbKdyAE+wyjzDPLEC+ZqOECGQdmcLKKnRb/KfPWmloDijF9du0q+WvWWk1XPQD8eX+ENife4nOQFqCj05HYL9VkOp8ua5f+Fd/ku433PjCYLIhaSVR8bxEszjWVtm4FmHKoOWkoSbXORY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776753618; c=relaxed/simple;
	bh=TjQCsyImF5U2sGLyk39BsOFNwcIVtp1SdvF+F//wutM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WiBuL+0ODl6wQdU5cQbTq3vD89eQfvrPjSh9eeK4G+wuGtnLiaE9MDcReFtnW2Snk9Q5LmJy729SkkkOmVTQd6j9WI7092BiQU2nOpOKfM1+jRwbNrgGbQT6ekBgEj0ZBEp3bP/833D1o63tnQxSleZ3pID3D7kYByst6f2nenI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iPw5mI8V; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iPw5mI8V"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c79662bbd2eso2584546a12.3
        for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 23:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776753616; x=1777358416; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eFVzoGUrnWztIccizbPMwOMp0aqT60GfJJhBLxZaJzE=;
        b=iPw5mI8VKifLjt4JM4Ao3CBsPyyPFZyP/otEbzZKT9PHw0YMBSHWT7Yvv0JXbtsO5k
         DPD7gtv5JLkdgq28CZWRK5PYRADCfQwjq8YK77lxEKzaQ0l2AQ5YabLWOhDLOgfyts3O
         qfwRF2UZXXb9vLPM94lm7tR/LRQaPFPbEwozYrwUAA1vL3WsjoRnjl6RZKfJPqvV0nkZ
         7BMYbY7BwAmK6oQQfgmlyBKRsMM/qyGWdqMsqbLmhHVf9qIdTNfuNuHCi1ZhoBKhHMgl
         MlsxF1HVwBHj4UNu5UYiyU+9HG7G5ZMbkEZXpDRSFrfZyiGpoFGwlbXaYBMeqqRQfErj
         dXbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776753616; x=1777358416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eFVzoGUrnWztIccizbPMwOMp0aqT60GfJJhBLxZaJzE=;
        b=EMP6zOHXdeAjlDqK9vVoa8oyxvIj65XLxnLm4xAZ3j57/ySvAL9xNqvwOo6HDAlM2K
         Fhh9RSNRUT6w1QlVjyaQ2HHIsgKqMQTRVKTYe1cLstJm97ir9yF1dMIxbVUpSkJJc1UZ
         +7vgW0fshNWSbUlnAsCgjTBN+u9JT/quNwO2OD3SxiqVVV/M5xmYM/ccwMoHSGoOs/bi
         rTXAf4JVDGcqf9NdAcJkE1K1Ukrr4jPMaEVj/DIMiKf9AAlJ1i9q3L4xPvR02yIpEqr3
         B+KBw4jYGrK7pjgBQZ0pB6WXkVSEjGdd4+IgVyCfY9rEjSuzUyfpns+DOupOfE8XQBdN
         vfnQ==
X-Gm-Message-State: AOJu0YwKLYRtBD7QvaJTPsKbu9MwcNfVbXHsFKPx5Lgc55ccBDFgXWCz
	jl8+O3uQdysmrF4XslbX8R7t87d/Wr+0tGoLD0R2sJhnjliFnVMkyJDNrmw1qXVsExU=
X-Gm-Gg: AeBDieuvJDKINcttzwxQ3+0aYp2oXLFz9Yk/3dlCPx+Y5xDKGhYiQgJZiQNZjcfl+iJ
	duSebyMzWik5bR5X7UK9jcSFODrXcDyXZXsQz7mOO8ZHLEp4nSVEVJLCB9ItCRQFJNDSampRhVa
	+5JbNbABW2kjeV2aGzTdXfy2buWgE3UOJBsbcek1DlE6Ns/1Tl8Oxqx7FvJwx6SJc0BmvxQcmpm
	obuAHI202Fp6s1ae6YL9wtH1wEYUYMr5/AbHe8mGnzQqr5laW9Cg1ItTPBPki7Naplae+yBUdXU
	T5d6VduuqvsHdoY8bHUPLUHxZ4Ko+B9k2qK3ZWMKgz+slnrMgkV/vOkxbhic60TK1w+fD+yltTv
	LQCgbt57E5pdyof5UQD5vL+FFBg4k9Wqaavo3yqRqTB9RXrZb2szL0a9LT2eC3n4xVnhiw5ktzr
	JYyqr74aMapT03wXCJhPNCo5Sq5WReiJ5oZbWrTCqXtXqttLpAZhlj71GXvOiTqNGb
X-Received: by 2002:a05:6a20:4326:b0:39f:3559:7501 with SMTP id adf61e73a8af0-3a08d8eb11bmr19749107637.41.1776753615389;
        Mon, 20 Apr 2026 23:40:15 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.184])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7977031729sm10032811a12.25.2026.04.20.23.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 23:40:14 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v2 5/7] cifs: optimize readdir for small directories
Date: Tue, 21 Apr 2026 12:09:53 +0530
Message-ID: <20260421063955.99164-5-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260421063955.99164-1-sprasad@microsoft.com>
References: <20260421063955.99164-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

For small directories (where the entire directory contents could be
read in a single QueryDir request), we currently do an extra
round-trip just to get a STATUS_NO_MORE_FILES back from the server.

This change avoids doing that by adding another QueryDir to the first
compound to the server for readdir. i.e. first request to readdir
will correspond to a compound of (OPEN+QD1+QD2). QD2 will request
for a smaller size (in anticipation of STATUS_NO_MORE_FILES).

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/smb2ops.c   | 156 ++++++++++++++++++++++++++++++++++----
 fs/smb/client/smb2pdu.c   |  19 +++--
 fs/smb/client/smb2pdu.h   |  11 +++
 fs/smb/client/smb2proto.h |   3 +-
 4 files changed, 168 insertions(+), 21 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 3625030d1912f..dd1f5b91dbc98 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2448,18 +2448,21 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 		     struct cifs_search_info *srch_inf)
 {
 	__le16 *utf16_path;
-	struct smb_rqst rqst[2];
-	struct kvec rsp_iov[2];
-	int resp_buftype[2];
+	struct smb_rqst rqst[3];
+	struct kvec rsp_iov[3];
+	int resp_buftype[3];
 	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
-	struct kvec qd_iov[SMB2_QUERY_DIRECTORY_IOV_SIZE];
+	struct kvec qd_iov[SMB2_QUERY_DIRECTORY_IOV_SIZE + 1]; /* +1 for padding */
+	struct kvec qd2_iov[SMB2_QUERY_DIRECTORY_IOV_SIZE + 1]; /* +1 for padding */
 	int rc, flags = 0;
 	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	struct cifs_open_parms oparms;
 	struct smb2_query_directory_rsp *qd_rsp = NULL;
+	struct smb2_query_directory_rsp *qd2_rsp = NULL;
 	struct smb2_create_rsp *op_rsp = NULL;
 	struct TCP_Server_Info *server;
 	int retries = 0, cur_sleep = 0;
+	unsigned int compound_resp_bufsize;
 
 replay_again:
 	/* reinitialize for possible replay */
@@ -2474,8 +2477,15 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
+	/*
+	 * Clamp compound Create+QD1+QD2 response sizing to a response size
+	 * for suited for one credit even if CIFSMaxBufSize is tuned larger
+	 */
+	compound_resp_bufsize = min_t(unsigned int, CIFSMaxBufSize,
+				      SMB2_MAX_BUFFER_SIZE);
+
 	memset(rqst, 0, sizeof(rqst));
-	resp_buftype[0] = resp_buftype[1] = CIFS_NO_BUFFER;
+	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
 	memset(rsp_iov, 0, sizeof(rsp_iov));
 
 	/* Open */
@@ -2499,7 +2509,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 		goto qdf_free;
 	smb2_set_next_command(tcon, &rqst[0]);
 
-	/* Query directory */
+	/* First Query directory */
 	srch_inf->entries_in_buffer = 0;
 	srch_inf->index_of_last_entry = 2;
 
@@ -2510,11 +2520,27 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = SMB2_query_directory_init(xid, tcon, server,
 				       &rqst[1],
 				       COMPOUND_FID, COMPOUND_FID,
-				       0, srch_inf->info_level);
+				       0, srch_inf->info_level,
+				       SMB2_QD1_OUTPUT_SIZE(compound_resp_bufsize));
 	if (rc)
 		goto qdf_free;
 
 	smb2_set_related(&rqst[1]);
+	smb2_set_next_command(tcon, &rqst[1]);
+
+	/* Second Query directory - minimal size to check if more data exists */
+	memset(&qd2_iov, 0, sizeof(qd2_iov));
+	rqst[2].rq_iov = qd2_iov;
+	rqst[2].rq_nvec = SMB2_QUERY_DIRECTORY_IOV_SIZE;
+
+	rc = SMB2_query_directory_init(xid, tcon, server,
+				       &rqst[2],
+				       COMPOUND_FID, COMPOUND_FID,
+				       0, srch_inf->info_level, SMB2_QD2_RESPONSE_SIZE);
+	if (rc)
+		goto qdf_free;
+
+	smb2_set_related(&rqst[2]);
 
 	if (retries) {
 		/* Back-off before retry */
@@ -2522,10 +2548,11 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 			msleep(cur_sleep);
 		smb2_set_replay(server, &rqst[0]);
 		smb2_set_replay(server, &rqst[1]);
+		smb2_set_replay(server, &rqst[2]);
 	}
 
 	rc = compound_send_recv(xid, tcon->ses, server,
-				flags, 2, rqst,
+				flags, 3, rqst,
 				resp_buftype, rsp_iov);
 
 	/* If the open failed there is nothing to do */
@@ -2557,14 +2584,111 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 		goto qdf_free;
 	}
 
-	rc = smb2_parse_query_directory(tcon, &rsp_iov[1], resp_buftype[1],
-					srch_inf);
-	if (rc) {
-		trace_smb3_query_dir_err(xid, fid->persistent_fid, tcon->tid,
-			tcon->ses->Suid, 0, 0, rc);
-		goto qdf_free;
+	qd2_rsp = (struct smb2_query_directory_rsp *)rsp_iov[2].iov_base;
+
+	/*
+	 * If QD2 has data, combine QD1 and QD2 responses before parsing.
+	 * The server cursor advances past both responses, so we can't discard QD2.
+	 */
+	if (qd2_rsp && qd2_rsp->hdr.Status == STATUS_SUCCESS &&
+	    le32_to_cpu(qd2_rsp->OutputBufferLength) > 0) {
+		char *combined_buf;
+		size_t qd1_data_len, qd2_data_len, combined_len;
+		u16 qd1_offset, qd2_offset;
+		struct smb2_query_directory_rsp *combined_rsp;
+		struct kvec combined_iov;
+		FILE_DIRECTORY_INFO *last_entry_in_qd1;
+		char *qd1_entries_start, *qd2_entries_start;
+		unsigned int next_offset;
+
+		qd1_offset = le16_to_cpu(qd_rsp->OutputBufferOffset);
+		qd2_offset = le16_to_cpu(qd2_rsp->OutputBufferOffset);
+		qd1_data_len = le32_to_cpu(qd_rsp->OutputBufferLength);
+		qd2_data_len = le32_to_cpu(qd2_rsp->OutputBufferLength);
+
+		/* Allocate buffer for: QD1 header + QD1 data + QD2 data */
+		combined_len = qd1_offset + qd1_data_len + qd2_data_len;
+		combined_buf = kmalloc(combined_len, GFP_KERNEL);
+		if (!combined_buf) {
+			rc = -ENOMEM;
+			goto qdf_free;
+		}
+
+		/* Copy QD1 header and data */
+		memcpy(combined_buf, qd_rsp, qd1_offset + qd1_data_len);
+
+		/* Append QD2 data (directory entries only, not the header) */
+		memcpy(combined_buf + qd1_offset + qd1_data_len,
+		       (char *)qd2_rsp + qd2_offset, qd2_data_len);
+
+		/* Update OutputBufferLength to reflect combined data */
+		combined_rsp = (struct smb2_query_directory_rsp *)combined_buf;
+		combined_rsp->OutputBufferLength = cpu_to_le32(qd1_data_len + qd2_data_len);
+
+		/*
+		 * Chain QD1 and QD2 entries: find the last entry in QD1 and update
+		 * its NextEntryOffset to point to the first entry in QD2.
+		 */
+		if (qd1_data_len > 0) {
+			qd1_entries_start = combined_buf + qd1_offset;
+			qd2_entries_start = combined_buf + qd1_offset + qd1_data_len;
+			last_entry_in_qd1 = (FILE_DIRECTORY_INFO *)qd1_entries_start;
+
+			/* Walk QD1 entries to find the last one with bounds checking */
+			while (1) {
+				char *end_of_qd1 = qd1_entries_start + qd1_data_len;
+
+				next_offset = le32_to_cpu(last_entry_in_qd1->NextEntryOffset);
+				if (next_offset == 0)
+					break;  /* Found last entry */
+
+				/* Bounds check before advancing */
+				if ((char *)last_entry_in_qd1 + next_offset >= end_of_qd1) {
+					cifs_dbg(VFS, "query_dir_first: invalid NextEntryOffset in QD1\n");
+					kfree(combined_buf);
+					rc = -EIO;
+					goto qdf_free;
+				}
+
+				last_entry_in_qd1 = (FILE_DIRECTORY_INFO *)((char *)last_entry_in_qd1 + next_offset);
+			}
+
+			/* Chain last QD1 entry to first QD2 entry */
+			last_entry_in_qd1->NextEntryOffset = cpu_to_le32(qd2_entries_start - (char *)last_entry_in_qd1);
+		}
+
+		/* Parse the combined buffer */
+		combined_iov.iov_base = combined_buf;
+		combined_iov.iov_len = combined_len;
+		rc = smb2_parse_query_directory(tcon, &combined_iov, CIFS_DYNAMIC_BUFFER,
+						srch_inf);
+		if (rc) {
+			kfree(combined_buf);
+			trace_smb3_query_dir_err(xid, fid->persistent_fid, tcon->tid,
+						 tcon->ses->Suid, 0, 0, rc);
+			goto qdf_free;
+		}
+		/* Ownership of combined_buf transferred to srch_inf->ntwrk_buf_start */
+		srch_inf->endOfSearch = false;
+		cifs_dbg(FYI, "query_dir_first: combined QD1 and QD2, %d entries\n",
+			 srch_inf->entries_in_buffer);
+	} else {
+		/* No data in QD2, just parse QD1 */
+		rc = smb2_parse_query_directory(tcon, &rsp_iov[1], resp_buftype[1],
+						srch_inf);
+		if (rc) {
+			trace_smb3_query_dir_err(xid, fid->persistent_fid, tcon->tid,
+						 tcon->ses->Suid, 0, 0, rc);
+			goto qdf_free;
+		}
+		resp_buftype[1] = CIFS_NO_BUFFER;
+
+		/* Check if QD2 indicates end of directory */
+		if (qd2_rsp && qd2_rsp->hdr.Status == STATUS_NO_MORE_FILES) {
+			srch_inf->endOfSearch = true;
+			cifs_dbg(FYI, "query_dir_first: small directory, all entries read\n");
+		}
 	}
-	resp_buftype[1] = CIFS_NO_BUFFER;
 
 	trace_smb3_query_dir_done(xid, fid->persistent_fid, tcon->tid,
 			tcon->ses->Suid, 0, srch_inf->entries_in_buffer);
@@ -2573,8 +2697,10 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	kfree(utf16_path);
 	SMB2_open_free(&rqst[0]);
 	SMB2_query_directory_free(&rqst[1]);
+	SMB2_query_directory_free(&rqst[2]);
 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
+	free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
 
 	if (is_replayable_error(rc) &&
 	    smb2_should_replay(tcon, &retries, &cur_sleep))
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 49dca84b169e6..2d55246d2851b 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5504,18 +5504,27 @@ int SMB2_query_directory_init(const unsigned int xid,
 			      struct TCP_Server_Info *server,
 			      struct smb_rqst *rqst,
 			      u64 persistent_fid, u64 volatile_fid,
-			      int index, int info_level)
+			      int index, int info_level,
+			      unsigned int output_size)
 {
 	struct smb2_query_directory_req *req;
 	unsigned char *bufptr;
 	__le16 asteriks = cpu_to_le16('*');
-	unsigned int output_size = CIFSMaxBufSize -
-		MAX_SMB2_CREATE_RESPONSE_SIZE -
-		MAX_SMB2_CLOSE_RESPONSE_SIZE;
 	unsigned int total_len;
 	struct kvec *iov = rqst->rq_iov;
 	int len, rc;
 
+	/*
+	 * Use provided output_size, or default to CIFSMaxBufSize calculation.
+	 * The default is for standalone QueryDir (smb2_query_dir_next).
+	 * For compounds, the caller should pass explicit output_size.
+	 */
+	if (output_size == 0) {
+		output_size = CIFSMaxBufSize -
+			MAX_SMB2_CREATE_RESPONSE_SIZE -
+			MAX_SMB2_CLOSE_RESPONSE_SIZE;
+	}
+
 	rc = smb2_plain_req_init(SMB2_QUERY_DIRECTORY, tcon, server,
 				 (void **) &req, &total_len);
 	if (rc)
@@ -5697,7 +5706,7 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = SMB2_query_directory_init(xid, tcon, server,
 				       &rqst, persistent_fid,
 				       volatile_fid, index,
-				       srch_inf->info_level);
+				       srch_inf->info_level, 0);
 	if (rc)
 		goto qdir_exit;
 
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 30d70097fe2fa..7b7a864520c68 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -129,6 +129,17 @@ struct share_redirect_error_context_rsp {
  */
 #define MAX_SMB2_CREATE_RESPONSE_SIZE 880
 
+/* Size of the minimal QueryDir response for checking if more data exists */
+#define SMB2_QD2_RESPONSE_SIZE 4096
+
+/*
+ * Output buffer size for first QueryDir in Create+QD1+QD2 compound.
+ * Accounts for shared buffer space needed for all three responses.
+ */
+#define SMB2_QD1_OUTPUT_SIZE(bufsize) \
+	((bufsize) - MAX_SMB2_CREATE_RESPONSE_SIZE - \
+	 sizeof(struct smb2_hdr) - SMB2_QD2_RESPONSE_SIZE)
+
 #define SMB2_LEASE_READ_CACHING_HE	0x01
 #define SMB2_LEASE_HANDLE_CACHING_HE	0x02
 #define SMB2_LEASE_WRITE_CACHING_HE	0x04
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 230bb1e9f4e19..9de7d2fe8d466 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -194,7 +194,8 @@ int SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 int SMB2_query_directory_init(const unsigned int xid, struct cifs_tcon *tcon,
 			      struct TCP_Server_Info *server,
 			      struct smb_rqst *rqst, u64 persistent_fid,
-			      u64 volatile_fid, int index, int info_level);
+			      u64 volatile_fid, int index, int info_level,
+			      unsigned int output_size);
 void SMB2_query_directory_free(struct smb_rqst *rqst);
 int SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon,
 		 u64 persistent_fid, u64 volatile_fid, u32 pid,
-- 
2.43.0

