Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4149155389
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 06:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768890133; cv=none; b=X/jTZOcY7g4q71379sOjejr0v2uY/g2itO6JB/xBn9xM8iBiyy2XUmyk9j7tYC3CvHjC9Zr9WwqV8J23stsjJQ/5YpNQPCySaY9AqKIRJOXupPHAMi9JLG5BTTysgbYIWBMdC82DrSLwePE86GC1vHXqp6jhH55kfJ5NILSGqP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768890133; c=relaxed/simple;
	bh=+BcOdnrkmk3aNes8gILOEXVKm364LJ0o+g6EildFTsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNdlJmo/H0TSjx5WPXLZcKKCMPMx9OTC56aVoQTqIDPfD/jQNlF6Ta7OK1TzB1wyfMYw5JWAMd1j581wuPyqo7tPt09x6G48Zb8osBxizsVBsLlh9YYDx2WLKkfpQPUWcz+OXCxCJgDkLe0OfLNtRvLzOzkN0POg0UueQj6Miq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ic9kb+gf; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ic9kb+gf"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a0833b5aeeso51055175ad.1
        for <linux-cifs@vger.kernel.org>; Mon, 19 Jan 2026 22:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768890131; x=1769494931; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4VydpK0nFZSzKW1KDSatm8+XGDD6WJ+troX1LqEAI5E=;
        b=Ic9kb+gfyszG61XYakRm/XlUwSiVz/m9Ye0xzIlIqKiUfvFM2gz7oE29ZS5nRYOlkj
         dRbIcGxawpRYIMMb3kR39IVmML0q0YZ2UMJET7whEsiuAKZrgKpuQ59St9LHWsRAFlrT
         h8OQnJBBXdHv/uHRduMh0WzGBRryKeGdcoKRls67xEY6Uao4xWpDTqQ3ISucgqzF6miy
         ymLgCT5VliMsbTbOqxZCMWyKOAnACvhT7tmLPqCrvx8/9goxuRnzjBHo1AEBU0HRhEoF
         72viIz6jW3o3ZZ/dpSxH6hp0hJ2dO5qUvvEABpbgXrrsGx98p6d56qme5bAHELrBq+kW
         cHEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768890131; x=1769494931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4VydpK0nFZSzKW1KDSatm8+XGDD6WJ+troX1LqEAI5E=;
        b=F0IecLtU3aEL9kGIx4Se86cVQC2JuXIL+SabfDihfJixDdXzJEF8lZ5MnfrlclpTph
         IT2BufSmgqTiJvE72Vmk4/+WBlGX2M36Wy7o/HBDWs8Ozoj9tntBe3wfmug2bBfKAf5U
         f2IIDoeZKP+RbCTlYJADFjPYQfA/pqTzsXjQO1UvFItZSnxsQpzAw+jCFDZPQs75BsAH
         omdX4gpcDy0MSAzkEmzI8AJYWp52r9sTBCEOB7SolVVKj/uPho58xOnKFp5lSCBxP+Be
         BF8GO2sPBfbxe6I8qFc1d0DXSNxJbQdKtiE1D/1XLGIvdVeaYwdG7hxasbDWgmLXS4MC
         HOKw==
X-Gm-Message-State: AOJu0YyeenXvOpxoe+QrI0Xkphsl3SkauyyHX67sO8IAHeOpwLfDBWtr
	NWZZiRABCtTFCRNUBFjNmfp8A4n//HRnHCUqqLxiotWjjF9JTz1MD0ClFcxRJ0EC
X-Gm-Gg: AZuq6aL04UvHYHP1UMBdTv0yDslhrgMbP1FAX8pPPh92+oyLedmX0Q6/cxWpu+TEPKG
	4SnRzqll/rSRLFeoG8DXQjHANVXaIsFo4ma4wYrenAm7m8eRJU2xjBzkt0oXAxjiwrL01tQQvjL
	U1l/w9/Bc6Uuc9Vwmkdse4zTFegB+dog81oo6lNzgjiKOoS7HqLXDMYCrhUf0G2iCsaHSXFYu17
	hW2H2zfXe5lsfpUpgxIzVTVzenNvbmIGQMPmCg8tByrZcoZE06zI+X8g6gEe4ElI25eValZoGBj
	KI1akOcyinzCswJFj1nXw+K8KBPBmKIfHrTcbq+Z9aFjsgvrRPhwatbsjNDBUgrXmNzucUtGHf8
	tNrfQ/BahU1iskqdQY21osQgSJWpU6x0PpWDqSjr6BwoMbsFlz4g+TQoT8HQ4/wzlhw99Lj3Szr
	a9tJ76jH+T6lLRIK9rz+NDwF8JW8LqeGZRcuX3iFzH
X-Received: by 2002:a17:902:f78a:b0:297:ece8:a3cb with SMTP id d9443c01a7336-2a7188a1a0dmr117465245ad.25.1768890130609;
        Mon, 19 Jan 2026 22:22:10 -0800 (PST)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.152])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7193dd523sm112497855ad.62.2026.01.19.22.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 22:22:10 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	dhowells@redhat.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 4/4] cifs: make retry logic in read/write path consistent with other paths
Date: Tue, 20 Jan 2026 11:51:37 +0530
Message-ID: <20260120062152.628822-4-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260120062152.628822-1-sprasad@microsoft.com>
References: <20260120062152.628822-1-sprasad@microsoft.com>
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
 fs/smb/client/cifsglob.h |  2 ++
 fs/smb/client/smb2pdu.c  | 70 +++++++++++++++++++++++++++++++---------
 2 files changed, 56 insertions(+), 16 deletions(-)

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
index 5d57c895ca37a..89f728392a734 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4616,17 +4616,19 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	case MID_RESPONSE_RECEIVED:
 		credits.value = le16_to_cpu(shdr->CreditRequest);
 		credits.instance = server->reconnect_instance;
-		/* result already set, check signature */
-		if (server->sign && !mid->decrypted) {
-			int rc;
+		rdata->result = smb2_check_receive(mid, server, 0);
+		if (rdata->result != 0) {
+			rdata->subreq.error = rdata->result;
+			if (is_replayable_error(rdata->result)) {
+				trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_req_submitted);
+				__set_bit(NETFS_SREQ_NEED_RETRY, &rdata->subreq.flags);
+			} else {
+				trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_bad);
+			}
+			break;
+		} else
+			trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_progress);
 
-			iov_iter_truncate(&rqst.rq_iter, rdata->got_bytes);
-			rc = smb2_verify_signature(&rqst, server);
-			if (rc)
-				cifs_tcon_dbg(VFS, "SMB signature verification returned error = %d\n",
-					 rc);
-		}
-		/* FIXME: should this be counted toward the initiating task? */
 		task_io_account_read(rdata->got_bytes);
 		cifs_stats_bytes_read(tcon, rdata->got_bytes);
 		break;
@@ -4748,7 +4750,7 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 	rc = smb2_new_read_req(
 		(void **) &buf, &total_len, &io_parms, rdata, 0, 0);
 	if (rc)
-		return rc;
+		goto out;
 
 	if (smb3_encryption_required(io_parms.tcon))
 		flags |= CIFS_TRANSFORM_REQ;
@@ -4795,6 +4797,17 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 
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
 
@@ -4908,14 +4921,20 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
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
-		}
+		} else
+			trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_progress);
 
 		written = le32_to_cpu(rsp->DataLength);
 		/*
@@ -4930,7 +4949,7 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		cifs_stats_bytes_written(tcon, written);
 
 		if (written < wdata->subreq.len) {
-			wdata->result = -ENOSPC;
+			result = -ENOSPC;
 		} else if (written > 0) {
 			wdata->subreq.len = written;
 			__set_bit(NETFS_SREQ_MADE_PROGRESS, &wdata->subreq.flags);
@@ -4972,6 +4991,7 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	}
 #endif
 	if (result) {
+		wdata->result = result;
 		cifs_stats_fail_inc(tcon, SMB2_WRITE_HE);
 		trace_smb3_write_err(wdata->rreq->debug_id,
 				     wdata->subreq.debug_index,
@@ -4994,6 +5014,14 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
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
@@ -5112,7 +5140,7 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 	}
 #endif
 
-	if (wdata->subreq.retry_count > 0)
+	if (wdata->replay)
 		smb2_set_replay(server, &rqst);
 
 	cifs_dbg(FYI, "async write at %llu %u bytes iter=%zx\n",
@@ -5159,6 +5187,16 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
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

