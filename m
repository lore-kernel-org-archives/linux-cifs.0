Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB652D3725
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 13:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769001977; cv=none; b=fa4lWRWg4onNEC4ZuR4wKXOiSmMILXQHdo+tt6lSQBFrNKJ+w0Nzsqa7MHKNX1G98rqcqtRTWWg4nJbTEexSUpdbD4+rb3raa7pa7Nk9+Eyb7qK/ZvijqSByQ7HTbw1HSoL3MQ2NvnJFUlDkn5lKUl2jkrrd/ZLSFAEf4INQJaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769001977; c=relaxed/simple;
	bh=tdKvJg43UrtkHmXYdU2PJg/EEFH3AoNZIPA1VkzJgvU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DhxrkwPrdDInmI1vtLhYt441aPGe5eHDgL5aC5yJn4Y4yFsjRLy45t07D6f5pwPFxlpqcPWjM1sY2tvlE0BqHPMml+8oMoDNjMRF8H+kfYgdi7Jh14wBJfUgOB//Z09SpNOGcpfDmxPuFfuje7T97H6pQ8YMJHumM9g35Se/sZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ko5FGn9Y; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ko5FGn9Y"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-81ed3e6b8e3so3165034b3a.2
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 05:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769001975; x=1769606775; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wfttrYf4DN817DuxuE5GpnKQOoY+dXjY1YGD1NuVaV4=;
        b=ko5FGn9YW1BTkEqzLm2B+q9Gw0+Xmbj3WWdF4XGnf7CMquWZ/QqxsgekhtVfqfVUBM
         WopJxW6XEAVyO7zG9fpSKAz7V0QMDe1MWHB6/ZVeEcn8HNPuDMxNZ4mfnWoKdt6F3zsd
         PARX4vyuGXbi76+yRUcTyB2F0skSrMre4NB4qJToKyGc4v4rBjyZHHc7Cs7XzGx3I8dp
         ZvCdfU1QNNemwIzH3cVWnS1yZsYGpnsfVPzugm1jX9C/iNQj39P+D34ttEZKJjfiPiBz
         4DD+wlbe2qjCktOxl3bLS1PbkWe0vbNvck0gzOTnwOInHVXdzKgYEJJ9yO/G03S+uEMf
         nNYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769001975; x=1769606775;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wfttrYf4DN817DuxuE5GpnKQOoY+dXjY1YGD1NuVaV4=;
        b=vbnFfuD3evqXk94ehZ/ry8jS5/+jROgPuYh7T47qO6NhxlLfTKrigflmegLe+cF0NL
         brku8Cr5DlKOAuzBSV7IpKlwBOrGkU287wc7iOzeVKRbG0I5d5I48uXWOObP2Junt2J2
         gXzuRbakPIiN0pFoXe79RGgf3oz6tC5KI8pMF3ZTZSDZAwAdsAO29nDuGb8Uw+obmogl
         Up4O1JdWPlv7+9DX3A+4/uohkAM6Ig+knEheJcC9OuZzx/rFJ1vxpU73rSM+1WMJhW6V
         AwFR+Cwd2jn6V5e91yptDMoqq4oqSxlPZpiwZKRmAjSun/A8mXxPDU8n8DFEPiz5lgvX
         XAag==
X-Gm-Message-State: AOJu0YxE5RjKl+CJjnC6sPCHEeKR9EQ6fg+44Eny9/AjXlx9YI0xY76S
	J4vIP8j7IP8n9cpWqTIQj9GowLat/u7t65MlEVEDrae0xuHlRg4FfEF34rQSBw==
X-Gm-Gg: AZuq6aLpnxAM62Kz8kG8tZkNEpEIXHoLGCnVoQ/GZiwxwhNZoADzqPUifzl20LJr4RO
	F+PTvyP4kd492MpXEB9lo0a3i37kPlafzv60tUELCvkhJJ57ZjyuBTp4swWICbj4KipA9MwBToP
	fjpu3bJm8mPuHa7vIh44KnEQZ2WLSs2IyVTTNVw0fl+zws3+BJ5jdRgwxlw6OiBslH0fndJHHCp
	THfgvzmI/2QIH7fjm4PuXJv1jkbtZYddbgXE35DRBk27/MSwH1GeMLYh9T76fD7bkVwzLBCGCZ3
	ljY8y0gljQkpal3EFcxlsXjyT4P5zCflGMisRWk845vfi9id9CivJ1N1UPY13dlVHKlGB4z71EV
	oDicdMEEuOxWjjt0iskh0Z5BPm9RkT+LE/LZ889cyqzhHz96hLkJ/CIVh/TiwSdVXEH0jmz9bNX
	yxpiELKeURz18BBoVQSHJ2Kg0hauIK1mVT4V/50urC
X-Received: by 2002:a05:6a00:14d4:b0:81f:48d4:a979 with SMTP id d2e1a72fcca58-81fa184c7dbmr15316893b3a.49.1769001974394;
        Wed, 21 Jan 2026 05:26:14 -0800 (PST)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.136])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa1094e23sm15276227b3a.4.2026.01.21.05.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 05:26:13 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	dhowells@redhat.com,
	bharathsm@microsoft.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v2] cifs: make retry logic in read/write path consistent with other paths
Date: Wed, 21 Jan 2026 18:55:53 +0530
Message-ID: <20260121132602.648695-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
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
 fs/smb/client/smb2pdu.c  | 60 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 55 insertions(+), 7 deletions(-)

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
index 5d57c895ca37a..51ca9885173be 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4622,9 +4622,19 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
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
@@ -4748,7 +4758,7 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 	rc = smb2_new_read_req(
 		(void **) &buf, &total_len, &io_parms, rdata, 0, 0);
 	if (rc)
-		return rc;
+		goto out;
 
 	if (smb3_encryption_required(io_parms.tcon))
 		flags |= CIFS_TRANSFORM_REQ;
@@ -4795,6 +4805,17 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 
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
 
@@ -4908,14 +4929,20 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
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
@@ -4930,7 +4957,7 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		cifs_stats_bytes_written(tcon, written);
 
 		if (written < wdata->subreq.len) {
-			wdata->result = -ENOSPC;
+			result = -ENOSPC;
 		} else if (written > 0) {
 			wdata->subreq.len = written;
 			__set_bit(NETFS_SREQ_MADE_PROGRESS, &wdata->subreq.flags);
@@ -4972,6 +4999,7 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	}
 #endif
 	if (result) {
+		wdata->result = result;
 		cifs_stats_fail_inc(tcon, SMB2_WRITE_HE);
 		trace_smb3_write_err(wdata->rreq->debug_id,
 				     wdata->subreq.debug_index,
@@ -4994,6 +5022,14 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
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
@@ -5112,7 +5148,7 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 	}
 #endif
 
-	if (wdata->subreq.retry_count > 0)
+	if (wdata->replay)
 		smb2_set_replay(server, &rqst);
 
 	cifs_dbg(FYI, "async write at %llu %u bytes iter=%zx\n",
@@ -5159,6 +5195,16 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
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

