Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2211E39EF2D
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 11:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634439; cv=none; b=QwdY4Hsq8zfb38d4VE3khessAAB8jcXkMeNq/UkK8rKE1/MjNpDrUV05a6zeNDNgv2dgvXMDeQ+MRGT2kOPN//NvkP3ExG4miczPWpteqFxIuOXQ13oDrg+b7mhwUE+WPKi69B9vj4YDpiYAEB+mA4I6hj5078u4TL/25F8L88E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634439; c=relaxed/simple;
	bh=6dnBavsoUPGKOpuSr3/LGHdvQnNq/ldgLGdG45nUMLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kV7WZIwbwed2MQT+z14MaMje9DGKDNHuT0rUdZ99VYNmM/nakO9Jv1CYaaHBb9aTYZO21y906QNE3y41/4AH2RCfR05LqipMsTOCnsdjruTsmvXwY4Sb0yIsVaM3msaieFJlEoXCWKjHqNX7EEjZTpkYOzums+dMtIJ5XktI0LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DqPL6MfD; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DqPL6MfD"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-82f351ca23cso860639b3a.2
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 04:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777634436; x=1778239236; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GjSkteazy2KtXict54lW3Ei5YfQmOP5DNfNIY6d4raw=;
        b=DqPL6MfDq7WJAEQsw5YNTjLWnbnein/MZd58wyBYACSllo/8pLqX4maMLN8M6iIcuX
         pfxG8tuRCgcDOnVV9dDHB+P3qPL+Gb0RRVp73cZ36LFtiD2m6kCZNoC3ckw+NrYa3Tor
         SPXgc1czG3liyFPo9HFseLlnoGs8SvR7ItUQCiIbfexWt0tJQ7pLA59jnUBpOz143f4t
         oH4t1hxsGmrtLpBLf0NsJy0IVR1v3S//PdHABcKJkBakfVELM6fuTnYHRr0prck+Cra9
         6ayrNmGp6JEX2UPg4pDeFzyd6luBVrSMopMt4tQ+yrVLHI8CI9TXDr9SaAMqt1sFttvM
         roRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634436; x=1778239236;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GjSkteazy2KtXict54lW3Ei5YfQmOP5DNfNIY6d4raw=;
        b=lDSyvAJVl6g4rSFujtY4PQZ+0QwVPn/L6doGJBb5dbGvmC1XtZDxzEge2zRw9gLXg8
         iIdM5CFOIK/HB8Lpl4arqGkGBvdlBQHq9bXSWJd+CqdgPo2ADCtynjumlgiQ2VlJzoyy
         radKO49ABfQfSd359KFN/7UQ99ZGQBKraCJGmDOEYjyWlcxuSKkT0xASgmUnW7K1HGk2
         yTEDllQFgO/n/TtRgr6oxa99CR8NTWsLoS0DqntGeDcnkdLziuzPqLnhHwe+AueoXH4B
         6xZTPKS3Z1DUyv0WJ/gSMVLElkaopz4fwd+QNGonf8ANlOPFJHkqUEY5k+lGuDJtNVxx
         LqLw==
X-Gm-Message-State: AOJu0YwQNpuhCojOJ0Bbs+c9WiIFvCwly8MuiQ4H6GRqOAkui9++v2rE
	+Pn4MwdT9ioFHD7VBAS9BO2X52poVvP+aD9Jk35QpubCtJZ05a+4WZs3g+eXcHF1Rc4=
X-Gm-Gg: AeBDiesqicJ/mNSpARLm4LR3srYwxTjK9rsMDOKoH9sTgfShbujwoj6TQRep66Q9pS7
	Jzk8q7LXTduSOOrCtGg48wddrxTKPGTCGpbSoEWQi8U/HWDHjnIUlR38ym9kYEzdDFlxw74BhWX
	dnGoCG0sJYcS8BWqAy7UdQHwwjVZS9CrRdBPl/PoFcZkto5UJwCdaGfRiqtwAligP0HfRMmCgNU
	RCfsZWQRAb9e6/ioY5HRIyGpAEUP4INXfQUj/NxN9SX704ivARdWDgBrnZCj7VCAOvNSroHfKQ7
	vidl0TuPE4T+mM/KWckpFjJusfcgIHQrEOapqfAJQx7ctAwIHyCnYmPYNKZ/AoN0DxLOWPuuPht
	VB9R3XuqcyFTDgri6E56xQKh/do5Z3vLrPzlCDKVgB9YsyfaceH/AVambX6/6WTOFhAOX8NnVuP
	QKUe2U20yY0nII9dooOdiZrJpuI+RIH1A1WF24OsBzo/uwtNWVvd2a5h9OFmimrWt9
X-Received: by 2002:a05:6a00:9a7:b0:82c:7876:a027 with SMTP id d2e1a72fcca58-834fdb4947fmr7836655b3a.18.1777634435679;
        Fri, 01 May 2026 04:20:35 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351587db67sm2331922b3a.13.2026.05.01.04.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:20:35 -0700 (PDT)
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
Subject: [PATCH v4 05/19] cifs: optimize readdir for small directories
Date: Fri,  1 May 2026 16:50:08 +0530
Message-ID: <20260501112023.338005-5-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260501112023.338005-1-sprasad@microsoft.com>
References: <20260501112023.338005-1-sprasad@microsoft.com>
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
index a9d68e5fcea91..f075330f88598 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2450,18 +2450,21 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -2476,8 +2479,15 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -2501,7 +2511,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 		goto qdf_free;
 	smb2_set_next_command(tcon, &rqst[0]);
 
-	/* Query directory */
+	/* First Query directory */
 	srch_inf->entries_in_buffer = 0;
 	srch_inf->index_of_last_entry = 2;
 
@@ -2512,11 +2522,27 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -2524,10 +2550,11 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -2559,14 +2586,111 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -2575,8 +2699,10 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
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

