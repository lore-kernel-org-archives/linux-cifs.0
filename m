Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841573542C3
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 17:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769708276; cv=none; b=PebMFNKGeszHxx5L4NdDvkLA/j8sqHcORvevL2th87axIHbILhmzsEkNMzl5dr7S3no4Xvz0eiBdUt2Y7k6h8U2eZdC8RZGRbJBw9VZHkgtf7eTi2rvxALLmreOTw05OpwX2EA+Jr9ORy3VU2HBO0GP+f+0VVRoqutGm+iioySY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769708276; c=relaxed/simple;
	bh=gvYiKn5oDxUVk6P5qTF/G/mVc5BjhcQ8+5P/bcMaGss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZxqS+uq4JXX74QiSH1Z4Wm/ttBwlHUA065UJYcGhv/XiZ6v83izn8F4JoMIt4LQUNI8MOoVGhL5AGOq0aDwpfPZE3q1ZwHH9Qhp0bA3uuXYW+j/5grK6zaQR8jCpSsPvdbexYdBeuqjuQVyxwiFXZbSraBPNF9/2GvNmz9V04c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tcghwsmc; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tcghwsmc"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-81f4c0e2b42so716596b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 09:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769708274; x=1770313074; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vC3j1nuoIF4S0p17bi2j91kgQDo7Qz6LfflWWUzaCxg=;
        b=Tcghwsmcr9XLARLtqsE/NuNazofCsubnL/75hI1KlbziUbdCGdlhD4KoF2ugk1vXaE
         PO8Xp32lTIwnUNYYbuIjAIm/EX41FlGY3EvKyNLYR30I4u5rdkgieSH92oSlDqf01YFp
         sb2JcY79tiJj1kj92jB2nXgo+n2Tq1GHix6jXwAIDMYC9eEjrTDLfAX8j2bRshccB4I5
         DjmiydyPlcS6Bi9E+ZOnlkqh6IZsTVeKeGEm4299a9s5RSXpP8rHMQ/6sxdTskeOX/Ua
         5RRTJVZ8UyLNS/6sbXEGJ2NvofT+dlRsYX0qKl50paoLwy5uerliOIjCqf7jv8KnbYG+
         cuyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769708274; x=1770313074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vC3j1nuoIF4S0p17bi2j91kgQDo7Qz6LfflWWUzaCxg=;
        b=QXaQeDy+qd8mrGb7MvXayrEededGA9+RmKt81a/WlWSrEWyF/AMvmrpH6f+Ijzb2Qg
         CyjhT2vOimmb09RROrY5gRQuut/mlPtCEJ+FozH5TbD1IJQBCl7wCZFPM5GHAHXO/zC1
         rYDIAx/zZBL2xdqRDQ6+pyHWoqYvktuL/9lAew9Wi86refct3GreedJO4cQY6GRLRVbL
         k8CjzYBlhv8yxgbp5GmV3Izf9ek8yQUXebfXEz+WlM7ClA65F1iAThYMZOgHwn8hLRwG
         6heiNdnx9GGlZPRxEm2jYBsUU3e2qcmyWIsIQo+eIeH0pBJT+EMqM9HnIiR2HAAdqCT3
         OdZA==
X-Gm-Message-State: AOJu0YxYlHlfp9v6PJ041WeJAyM/Bpen/m7OTSpETsHmY0EPw/szWsuh
	mGCBq1RCIB6Ng1amIl+Iugb/dudvoC+pF0WblSahYlqONr5CqybUcAB9vI/DFCy1
X-Gm-Gg: AZuq6aKy6i8fBHhsswzbBiAT02r4ejIlLMTHE6qGXa+42Eh6oz9Vac65kZVt4botYtt
	+NtaQJ2OaU+cPxdTk3xzzMKCxsMTq5gihDojTdBZ65wjzXKabr8KJDXwI2abZ4xs6bDPcT77dIb
	6eTMM3KJyqtjd8TRntyX9nFJDd0k+2qp0/Y2xaEJwaR4Q9TTapsjw8qKl00QXlUP7+8eUcBqVIx
	B8sGGTDcpv5zNLVCkE3c+rCVyZyrENQdxTyo5oO+F5zPOSSi8jPjMwc20BQcE2redPABEMznx+H
	CehtX5aOqak0vyTChUu9m1mwAV5VN7CR17hYeiHIy/y2Kgyre4lVxr1YD91IyNz/rXaBPrviQJu
	BwP40ghmATHrjSfCWuliD8buo0/8ChJ0S0IaHGAsHIop0XBjdM73dBYD/pb+hbU7blm3dBHOgj7
	9kDMDIAvdchvbIiaOyf1OzWGuCU83kp1lYjzPvG14k
X-Received: by 2002:a05:6a00:ad06:b0:821:7307:44cf with SMTP id d2e1a72fcca58-823aa43a205mr130388b3a.15.1769708274448;
        Thu, 29 Jan 2026 09:37:54 -0800 (PST)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.200])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379b6a5desm5512659b3a.28.2026.01.29.09.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 09:37:53 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	netfs@lists.linux.dev
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v3 4/4] cifs: make retry logic in read/write path consistent with other paths
Date: Thu, 29 Jan 2026 23:07:11 +0530
Message-ID: <20260129173725.887651-4-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260129173725.887651-1-sprasad@microsoft.com>
References: <20260129173725.887651-1-sprasad@microsoft.com>
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
index 7d75ba675f774..b8adfd2c55b8b 100644
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
+					trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_req_submitted);
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
+				trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_req_submitted);
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

