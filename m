Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DB427467E
	for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 08:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769848421; cv=none; b=rF+85QEzd5wOmDg0LM4HYpxs0fFHEEZpMeitNla2Z4LnkKNzRXqqhAxHDDm4e0MfcEPxmMgESOMW1ZNsoZw9Ye2sjr3t/8XqEeWa4VshmXuB982s9DCc9RMgsZRINdxhlbPjKP+qNHEzyoWKC6UBsi9pYV9rTdNj8w7QiM86Z4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769848421; c=relaxed/simple;
	bh=PZReqsRFqEbjyH3sRN7Lx0F/Gj66WLJnFALoI9BOb90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVXnRgbNRM1VNraZLHz0w9GVOF8CNK12dxPd9eB++/zgovqshXC44oy8UgH4Tc5j4AmdFM9LkN5uLBvFDovpw2odwzoXPK+xJB6smyoBDJhA4rWQbpbJN/eq+vCXGnOVQFdj/3cIqeaWQIKrccbRorqJArVrAOlul6qk3hM3ANE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h913ZVAD; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h913ZVAD"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-bd1ce1b35e7so1688238a12.0
        for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 00:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769848419; x=1770453219; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rOZ6ZHcm6ppEdluoyXDcvmAOKAm8r5cFvGsVVYHXadE=;
        b=h913ZVADwMDnU2QfARYl6uEhG3avL2rOzA8ycAlRNtbpz5U88Q14xJUkZmDM3jItVF
         fKvLFc8xuM2qrugoXgvBqxMkLSmZt/SL3M7w0bNslT4Cz1llcjdgF/Pg5q6QPr64VJ5s
         8tVHDK/HlFB8xy0fBPJUYAIDD4SZ6BT3AzUO4Rtzzn4Xgu/uoVZg9dbhy1jeRWZLj52H
         s9G5JX+eSEX1p7HWvml2E7izQkaJ7F3AyrU4MxpQf/z5682K/31rr0m4IKBIzfj/NOPH
         EpsvgA2EO91fhXZa1mZhY14jo9jmggOc8+BqfrLPJLD/IV6VYK7N9PE2zPPyxI2zIlpl
         9KfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769848419; x=1770453219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rOZ6ZHcm6ppEdluoyXDcvmAOKAm8r5cFvGsVVYHXadE=;
        b=GbnHr8CAqiBjXDJZ2c02YHTgi72Z2CwSCuXJ8ojejEvK5AZHqNF4TbfX60H8CrTTMN
         W6xzds/4/7apVARziCXWd/Y8QlV9xApivrFwQQBI0r4/IaOYkb6Wh+G6/wZOX0PYkBE0
         hNk9CN9q6Jla/V+Q4I40NNMcZWBtqJ6CDw5xNg0T5/atBHulaa8ZkhSmMam2Mz1Y+D2y
         J9nG8v0eGAw6x/+cC2huO5rw3u1+vqaEGJIIr1Nq3Qg2+T1Ti97xk1SXc70/OWv6/N5d
         YsvvrOGmispcCnVxz5Otk7a1wDRMjaAHssH+cTdHLlEkZiCkImGREOooLx0an5mq5S1j
         a6Rw==
X-Gm-Message-State: AOJu0YxVN24IonCk/pYalYC0SjdAvl9BvRzJOlwSgYyxtJmKb+pK7WEr
	tcuaLoonlqWtvniv32oUD2Hx/1q/taRanMSvGkzpM3/PAnVZ3CAjxYA9nOvKhA5a
X-Gm-Gg: AZuq6aIv2FwcXB2A/zzB2zxwmvWSoGxnUIqtZQwTlWSjOAphYD2pgMITZXFnXTSdXW5
	bLVT9B7Gw/3sl7c3/hhr78qB+SH5GhB09Ik3IvjRW5uFaVHPF1VGVsfaJ3G6FOfFBAp6hJmJo6J
	wNdzy0xwCeT3o/uWuUtQMu7O3+eKOSXbFKFU1gz/OJLHCPQmPJs9UrUCkvuavAiK92j1JvlzcOz
	Yk4vsufjeqaTMkK8p7+WpvGPkYzlaDmCZ/Mcy9km9vbUkjNO2peld+fcfJsAVIvt8m6VrhdTCjg
	TDgZo6UlRoLnzdiaZp0u7dajGjstpUKGPjZl3gyutTXWR1KYWeQtnaLjZIisvjTT8rrjMkHW/D4
	oBA+yS46cWbeXeLY1XyL4AqSLglSJoqx6kMbhAlj1y/Re0y4lgQUSSEM16l04zKCIV287J1zibL
	n2d7XxAWReUTvAu5U40HmXLFpnEjoFAllt4Lflkh4=
X-Received: by 2002:a05:6a21:3991:b0:334:a99a:1796 with SMTP id adf61e73a8af0-392dfff8f95mr5124238637.11.1769848419161;
        Sat, 31 Jan 2026 00:33:39 -0800 (PST)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-353f610266esm13479121a91.4.2026.01.31.00.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jan 2026 00:33:38 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	netfs@lists.linux.dev
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v4 4/4] cifs: make retry logic in read/write path consistent with other paths
Date: Sat, 31 Jan 2026 14:03:06 +0530
Message-ID: <20260131083325.945635-4-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260131083325.945635-1-sprasad@microsoft.com>
References: <20260131083325.945635-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Today in most other code paths in cifs.ko, the decision of whether
to retry a command depends on two mount options: retrans and hard.
However, the read/write code paths diverged from this and would only
retry if the error returned was -EAGAIN. However, there are other
replayable errors in cifs.ko, for which is_replayable_errors helper
was written. This change makes read/write codepaths consistent with
other code-paths.

This change also does the following:
1. The SMB2 read/write code diverged significantly (presumably since
they were changed during netfs refactor at different times). This
changes the response verification logic to be consistent.
2. Moves the netfs tracepoints to slightly different locations in order
to make debugging easier.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsglob.h |  2 +
 fs/smb/client/smb2pdu.c  | 79 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 74 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 3eca5bfb70303..f6ebd3fd176d7 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1507,6 +1507,8 @@ struct cifs_io_subrequest {
 	int				result;
 	bool				have_xid;
 	bool				replay;
+	unsigned int			retries;	/* number of retries so far */
+	unsigned int			cur_sleep;	/* time to sleep before replay */
 	struct kvec			iov[2];
 	struct TCP_Server_Info		*server;
 #ifdef CONFIG_CIFS_SMB_DIRECT
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 7d75ba675f774..fa22702a61a6e 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4650,9 +4650,19 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 			iov_iter_truncate(&rqst.rq_iter, rdata->got_bytes);
 			rc = smb2_verify_signature(&rqst, server);
-			if (rc)
+			if (rc) {
 				cifs_tcon_dbg(VFS, "SMB signature verification returned error = %d\n",
-					 rc);
+					      rc);
+				rdata->subreq.error = rc;
+				rdata->result = rc;
+
+				if (is_replayable_error(rc)) {
+					trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_retry_needed);
+					__set_bit(NETFS_SREQ_NEED_RETRY, &rdata->subreq.flags);
+				} else
+					trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_bad);
+			} else
+				trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_progress);
 		}
 		/* FIXME: should this be counted toward the initiating task? */
 		task_io_account_read(rdata->got_bytes);
@@ -4728,6 +4738,14 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		if (rdata->got_bytes)
 			__set_bit(NETFS_SREQ_MADE_PROGRESS, &rdata->subreq.flags);
 	}
+
+	/* see if we need to retry */
+	if (is_replayable_error(rdata->result) &&
+	    smb2_should_replay(tcon,
+			       &rdata->retries,
+			       &rdata->cur_sleep))
+		rdata->replay = true;
+
 	trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, rdata->credits.value,
 			      server->credits, server->in_flight,
 			      0, cifs_trace_rw_credits_read_response_clear);
@@ -4776,7 +4794,7 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 	rc = smb2_new_read_req(
 		(void **) &buf, &total_len, &io_parms, rdata, 0, 0);
 	if (rc)
-		return rc;
+		goto out;
 
 	if (smb3_encryption_required(io_parms.tcon))
 		flags |= CIFS_TRANSFORM_REQ;
@@ -4788,6 +4806,13 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 
 	shdr = (struct smb2_hdr *)buf;
 
+	if (rdata->replay) {
+		/* Back-off before retry */
+		if (rdata->cur_sleep)
+			msleep(rdata->cur_sleep);
+		smb2_set_replay(server, &rqst);
+	}
+
 	if (rdata->credits.value > 0) {
 		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(io_parms.length,
 						SMB2_MAX_BUFFER_SIZE));
@@ -4823,6 +4848,17 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 
 async_readv_out:
 	cifs_small_buf_release(buf);
+
+out:
+	/* if the send error is retryable, let netfs know about it */
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon,
+			       &rdata->retries,
+			       &rdata->cur_sleep)) {
+		trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_retry_needed);
+		__set_bit(NETFS_SREQ_NEED_RETRY, &rdata->subreq.flags);
+	}
+
 	return rc;
 }
 
@@ -4936,14 +4972,20 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
-		trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_progress);
 		credits.value = le16_to_cpu(rsp->hdr.CreditRequest);
 		credits.instance = server->reconnect_instance;
 		result = smb2_check_receive(mid, server, 0);
 		if (result != 0) {
-			trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_bad);
+			if (is_replayable_error(result)) {
+				trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_retry_needed);
+				__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
+			} else {
+				wdata->subreq.error = result;
+				trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_bad);
+			}
 			break;
 		}
+		trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_progress);
 
 		written = le32_to_cpu(rsp->DataLength);
 		/*
@@ -4958,7 +5000,7 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		cifs_stats_bytes_written(tcon, written);
 
 		if (written < wdata->subreq.len) {
-			wdata->result = -ENOSPC;
+			result = -ENOSPC;
 		} else if (written > 0) {
 			wdata->subreq.len = written;
 			__set_bit(NETFS_SREQ_MADE_PROGRESS, &wdata->subreq.flags);
@@ -5000,6 +5042,7 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	}
 #endif
 	if (result) {
+		wdata->result = result;
 		cifs_stats_fail_inc(tcon, SMB2_WRITE_HE);
 		trace_smb3_write_err(wdata->rreq->debug_id,
 				     wdata->subreq.debug_index,
@@ -5022,6 +5065,14 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 			      server->credits, server->in_flight,
 			      0, cifs_trace_rw_credits_write_response_clear);
 	wdata->credits.value = 0;
+
+	/* see if we need to retry */
+	if (is_replayable_error(wdata->result) &&
+	    smb2_should_replay(tcon,
+			       &wdata->retries,
+			       &wdata->cur_sleep))
+		wdata->replay = true;
+
 	cifs_write_subrequest_terminated(wdata, result ?: written);
 	release_mid(server, mid);
 	trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, 0,
@@ -5140,8 +5191,12 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 	}
 #endif
 
-	if (wdata->subreq.retry_count > 0)
+	if (wdata->replay) {
+		/* Back-off before retry */
+		if (wdata->cur_sleep)
+			msleep(wdata->cur_sleep);
 		smb2_set_replay(server, &rqst);
+	}
 
 	cifs_dbg(FYI, "async write at %llu %u bytes iter=%zx\n",
 		 io_parms->offset, io_parms->length, iov_iter_count(&wdata->subreq.io_iter));
@@ -5187,6 +5242,16 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 async_writev_out:
 	cifs_small_buf_release(req);
 out:
+	/* if the send error is retryable, let netfs know about it */
+	if (is_replayable_error(rc) &&
+	    smb2_should_replay(tcon,
+			       &wdata->retries,
+			       &wdata->cur_sleep)) {
+		wdata->replay = true;
+		trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_retry_needed);
+		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
+	}
+
 	if (rc) {
 		trace_smb3_rw_credits(wdata->rreq->debug_id,
 				      wdata->subreq.debug_index,
-- 
2.43.0

