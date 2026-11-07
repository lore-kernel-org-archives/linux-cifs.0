Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794024587;
	b=IHvNc6trSd3sSzHSDqRYGVzXNkCitV9R0WU/14XSNTDsXn5snhP/6b/cC5igHlF7fDO+
	 Q17u20mudPrX7QY1LHTOL5Wyq4daAi/eXRhbqfOvkH/5Fy10YzXskkmi1cHN8PcThKJsw
	 D1/9ZxeQz4M8NwNPCmqjhxSHYPau3A6HWlkJbmtq2MwrrJ1jgV+gUMiw2n0+wNpQR8pKV
	 n1v2E4qz28yjx15vbXFqCfxcZE/GwpRFC7fxX0YSKndULqk8HvLeGpwaFRP99WhWZqMu5
	 Xol0x7N9fAiI3LYKHY9VubXuPRIwxNETbN+x/euNmOp19SCbbcHz+uKpY0tpXtfTNQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794024587;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IBwfieRPIka76G7Cq1DpiJDEAb5M15wjIM/UYMHCko0=;
	b=OcVKSIFOgwpWVqC3pftMgPlNqigXdRsYGwU64LvY1l/mpbMZY09jjqOHW46dpcYTSzDX
	 9pcL6027CTn84DWwOA1LFK1sHc71T/TklgHD4clqbpeHr253dakgPKXBkUp+xDlorrFia
	 160P1r0TTuylTqfzvSamNY0eGqhYjpxeYXya/oyfYh2NHkF9ucWauTMYVauZmtRFG8KRK
	 EpoOMoYrUUdZhcJm0gki4GwbDDiYNcqidfGYNqwLy8PYqGdzWPU3ag+YhToV6PfPrDkCq
	 2B8eZD9CQ/nKvyBnhWgK75Smxdt+ErSHsHA3D1F2RCeLftsGB73QYCLO8Z+faSCsE2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=YF99EJae;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA00606A337;
	Sat,  7 Nov 2026 04:09:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BBA00606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=YF99EJae
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=IBwfieRPIka76G7Cq1DpiJDEAb5M15wjIM/UYMHCko0=; b=YF99EJaevBQgjL258u+ii8dD21
	4tjl4rm6o80M1RGoVHP+iXlXESiQ3vd+LBym0aUnV305FQgg2qasf/knHhigtWSRUt/LXZcD9LW7c
	+mq+vTivcLdx4w87Rm2Usn5iR25iQ7GAhqYEsSPlYWYrTYSQrKqMJLvS338yJ9z1uLeaYDLygUtHD
	Dho2smQw95WjJJEHJ5Q8PAAb716637xhgBf+nwnKSfU4Ew+Ghabdwb+dLfeYA1NejMQAgxo/FzbpV
	1FOt5EyG5H+4WRfVxMU/p0iZAwpJ6hrPi0qsbpX6jHrlor8HYYPpr1Rt2vSUatb2z10L2Rr4ncMzz
	UjToco6w==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPXkO-000000015NQ-0jJo;
	Sat, 07 Nov 2026 01:09:45 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	David Howells <dhowells@redhat.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Christian Brauner <brauner@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v8 12/19] smb: client: retry writeback on interrupts and allocation failures
Date: Sat,  7 Nov 2026 01:09:33 -0300
Message-ID: <20261107040940.2692656-13-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107040940.2692656-1-pc@manguebit.org>
References: <20261107040940.2692656-1-pc@manguebit.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Issuing writes from a worker only helps when the task is already dying
at issue time.  A fatal signal can still arrive after that check and
before __smb_send_rqst() checks again, or while waiting for a credit in
cifs_call_async(), or in the middle of a send.  The write then fails
with -ERESTARTSYS, which isn't a replayable error, so netfs marks the
subrequest failed and drops its folios clean:

  netfs_sreq: R=000041f6[2] UPLD SUBMT ... s=400000 0/400000
  smb3_write_err: R=000041f6[2] ... offset=0x400000 len=0x400000 rc=-512
  netfs_failure: R=000041f6[2] UPLD ... upload e=-512

losing 4MiB of a 64MiB file closed by a task killed meanwhile.  A failed
memory allocation while building or sending a write drops its data the
same way.

No server status maps to an interrupt error or to -ENOMEM, so for
writeback such errors always mean the client gave up locally.  Mark the
subrequest for retry, with backoff and giving up on umount -f, as cifs
did with is_retryable_error() before switching to netfslib and as NFS
does for these errors.  netfs collects writeback from a workqueue, so
the retry gets prepared and issued with no signals pending.

Only the SMB2 read and write paths sleep before replaying, so SMB1 would
resend such writes right away.  Move the sleep to cifs_issue_read() and
__cifs_issue_write().

Fixes: 3ee1a1fc3981 ("cifs: Cut over to using netfslib")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/file.c    | 14 ++++++++++++++
 fs/smb/client/smb2pdu.c | 12 ++----------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 396524c3f2b6..abbf6a1be9e2 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -212,6 +212,9 @@ static void __cifs_issue_write(struct netfs_io_subrequest *subreq)
 	if (wdata->req->cfile->invalidHandle)
 		goto fail;
 
+	if (wdata->replay && wdata->cur_sleep)
+		msleep(wdata->cur_sleep);
+
 	wdata->server->ops->async_writev(wdata);
 out:
 	return;
@@ -350,6 +353,9 @@ static void cifs_issue_read(struct netfs_io_subrequest *subreq)
 	    subreq->rreq->origin != NETFS_DIO_READ)
 		__set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
 
+	if (rdata->replay && rdata->cur_sleep)
+		msleep(rdata->cur_sleep);
+
 	trace_netfs_sreq(subreq, netfs_sreq_trace_submit);
 	rc = rdata->server->ops->async_readv(rdata);
 	if (rc)
@@ -2754,6 +2760,14 @@ void cifs_write_subrequest_terminated(struct cifs_io_subrequest *wdata, ssize_t
 		spin_unlock(&inode->i_lock);
 	}
 
+	if ((is_interrupt_error(result) || result == -ENOMEM) &&
+	    wreq->origin == NETFS_WRITEBACK && cifs_io_should_replay(wdata)) {
+		wdata->replay = true;
+		trace_netfs_sreq(&wdata->subreq,
+				 netfs_sreq_trace_io_retry_needed);
+		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
+	}
+
 	netfs_write_subrequest_terminated(&wdata->subreq, result);
 }
 
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index be003200efa8..bf22e7f6445d 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4880,12 +4880,8 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 
 	shdr = (struct smb2_hdr *)buf;
 
-	if (rdata->replay) {
-		/* Back-off before retry */
-		if (rdata->cur_sleep)
-			msleep(rdata->cur_sleep);
+	if (rdata->replay)
 		smb2_set_replay(server, &rqst);
-	}
 
 	if (rdata->credits.value > 0) {
 		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(io_parms.length,
@@ -5285,12 +5281,8 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 	}
 #endif
 
-	if (wdata->replay) {
-		/* Back-off before retry */
-		if (wdata->cur_sleep)
-			msleep(wdata->cur_sleep);
+	if (wdata->replay)
 		smb2_set_replay(server, &rqst);
-	}
 
 	cifs_dbg(FYI, "async write at %llu %u bytes iter=%zx\n",
 		 io_parms->offset, io_parms->length, iov_iter_count(&wdata->subreq.io_iter));
-- 
2.56.0

