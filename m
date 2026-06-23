Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD14C35675B
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 20:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782246025; cv=none; b=XMx0xp0wXCxZFAm2hu5OYvtzfFF8+4Z5uzt2ICiZaTcNa9S+s5Ql7PTK5QLYtdrdKKvsWvuhjmRxq1gU/p5f5QL6TNPAActFjs+jEyc+/EBKhnwp0RWEMcLEKoypwP4XB4UM4ZLQWutR8l0kwRkerPoUlkW3Fnm2yyU8Q3UwQ1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782246025; c=relaxed/simple;
	bh=kj1OQw+HsYFGhsZgIiMFRGUbTfFWlSl0TlyuBC48U1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RvIX07kDgt7Z2x3+5vj4zINaf0B7nzxvMQ9wlQsuh5PQcLVJK0ja1ANL3u9M7CMJjVCTD8rUdCl78C80iCPbj3OrVp3R3rW7GsXME/gbA2zALQlnsXWZAU+Xn4ArbJs14K1YvAfo/xKNfvKwXFCVYI9SCbf38GBWPsK+B6xKLJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y9ShNwV4; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y9ShNwV4"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-6a0e3a9c3a1so144250eaf.1
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 13:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782246022; x=1782850822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EPSfYsXswTBYy0A7mOwIHCKv3mwk1n4okkKtZhPbO2k=;
        b=Y9ShNwV4vWp7LTcw/l3wsa0Lko1O6uA8syYRLUZRs0qknCmiK98lsRLrjRHcGgMDCS
         A+Gg+vv0gdLv68h6v6/WEbSTsgiUrXqRELYyrvpXV0p3wDYTPQkgM5fNOyseKThn0ReA
         zG4bJrfEZv9bntbLGdPGTcQjBs306rvyoMJTs1VrGlWiS+UUSyoQcwHQSBYHMAF36FuD
         TgTzmdQv9cg+49er+fEyKiRBvIkG55V2GNxbh3B6vfSeyV/eG57hciuevH3RBZiQgzcO
         WbOS7cpQjgL/qxson7uqNDMv3P6ptAPoF1etI64whG5q4xGy0gpbABHKlLHETN+sl5kl
         /s2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782246022; x=1782850822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EPSfYsXswTBYy0A7mOwIHCKv3mwk1n4okkKtZhPbO2k=;
        b=KT4pIlk2TmcPLscjkiLkyXqkpdxkSV0Jwqa8tzaqXyrqMXnZOpNwWnYS6Rf8PRD+Zu
         u3xsqnGMRo+FFmtfx1n3qrSfZewUrQju4o1zxQGYphO0ZfqGoNIZo3skbg5m6Pz+jVF1
         X+IW3P3ei1fpM0yLDCL0wEw/I967F6M7F6frzsHBc8eJy7F4nPul9SEjCCUgJ69wIEh4
         aelMJS0FXvHNRaFmOJ+njlm5nd2d8fv9LA9RFivKHr0CfK8AoHtSnW56UXyHVfqSm5qe
         hOLc63U9isXmxvs+GZ0PuyaH0UmdU5qN5pjpehRG2ONMLab9xKV15j1RxNavByay0R8Y
         5VVg==
X-Gm-Message-State: AOJu0YyHRwEXfPJCMXYe0bK2LPW5LnH1AmDJiCOv7JBuxHTCLvw5j7NJ
	7hCKcXODBejhEjw9ycmMetCl9ga5cWL5jq1SUXsvwKpzdoGR2m76A5/2T6tAfq3n
X-Gm-Gg: AfdE7clxcIaNivOnTpP4TDDp/3uL2JH/ScidBTzj+KlLAb5PoEpO7eXzPIbNli41UaX
	tXOzsf5AFqB/t7oGlEmFFkUKxVke7V8XlhEtSPhwVrnXQ7ae0i4eDeJME0xTzP3hR0sqAAOxl5w
	kQDuumtpGUseE1ixsXOBy7VI3BqRDx9uRKp+bA+gMYpo+M+aF26KfJS1b/1j1lxAfi8kZ2PdtzT
	qLAdY58KCuYXIx+fhfCF0DCINQx0Ke0XK5Fbgg0yqjvf31A0rHW+I29hsuHE99z3Kc3nhBeU4Ul
	KN9b31V+aO//5d/5Pi6r1Ak112yqIQlfX2GD7oVAbPy6Ri8JIHPb5jwOoIHAdH/+sF/BP9H4nvv
	VG9KaR9uUWjP3Tt6vmphw1dJh6QmiVCVplmkBCvEHH5Ndw4UNLhVQVMdVKpQUWtheLP1cDo3iRf
	iwWnUa+LOZWeBrcPRn1SutYWB8vaK79bM6ivi0idJnw/KKprZdv42Pxp9KaMKZdwW7/viWBuM8e
	drtyfPkYYsBcjEEC7pCiXgZbfasrU/dJ4CVo+XJcqV8iP6AcoMQDiPn0rfy0A/9ddZ6pPuJyeMQ
	3Ltx6Q1WqsbxZb24dBZMZrp5v+Y=
X-Received: by 2002:a05:6820:2008:b0:69e:86af:a8a9 with SMTP id 006d021491bc7-6a122eacea5mr223794eaf.3.1782246021564;
        Tue, 23 Jun 2026 13:20:21 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:7d5b:9c51:3ae4:81e2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a11e6ef161sm1000243eaf.5.2026.06.23.13.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 13:20:21 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 02/16] cifs: optimize readdir for small directories
Date: Tue, 23 Jun 2026 15:13:29 -0500
Message-ID: <20260623201344.2043841-2-stfrench@microsoft.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260623201344.2043841-1-stfrench@microsoft.com>
References: <20260623201344.2043841-1-stfrench@microsoft.com>
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
 fs/smb/client/smb2ops.c   | 158 ++++++++++++++++++++++++++++++++++----
 fs/smb/client/smb2pdu.c   |  19 +++--
 fs/smb/client/smb2pdu.h   |  11 +++
 fs/smb/client/smb2proto.h |   3 +-
 4 files changed, 170 insertions(+), 21 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index d4875f9532b4..7b09b20148d6 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2456,18 +2456,21 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -2482,8 +2485,15 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -2507,7 +2517,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 		goto qdf_free;
 	smb2_set_next_command(tcon, &rqst[0]);
 
-	/* Query directory */
+	/* First Query directory */
 	srch_inf->entries_in_buffer = 0;
 	srch_inf->index_of_last_entry = 2;
 
@@ -2518,11 +2528,27 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -2530,10 +2556,11 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -2565,14 +2592,113 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
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
+				last_entry_in_qd1 = (FILE_DIRECTORY_INFO *)
+					((char *)last_entry_in_qd1 + next_offset);
+			}
+
+			/* Chain last QD1 entry to first QD2 entry */
+			last_entry_in_qd1->NextEntryOffset =
+				cpu_to_le32(qd2_entries_start - (char *)last_entry_in_qd1);
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
@@ -2581,8 +2707,10 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
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
index b4cd5514b77b..0bcecc56ca3b 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5515,18 +5515,27 @@ int SMB2_query_directory_init(const unsigned int xid,
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
@@ -5708,7 +5717,7 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = SMB2_query_directory_init(xid, tcon, server,
 				       &rqst, persistent_fid,
 				       volatile_fid, index,
-				       srch_inf->info_level);
+				       srch_inf->info_level, 0);
 	if (rc)
 		goto qdir_exit;
 
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 30d70097fe2f..fe304583b102 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -129,6 +129,17 @@ struct share_redirect_error_context_rsp {
  */
 #define MAX_SMB2_CREATE_RESPONSE_SIZE 880
 
+/* Size of the minimal QueryDir response for checking if more data exists */
+#define SMB2_QD2_RESPONSE_SIZE 1024
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
index 1ceb95b907e6..6b4dc4fea21e 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -199,7 +199,8 @@ int SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
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
2.53.0

