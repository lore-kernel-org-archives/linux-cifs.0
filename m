Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793918743;
	b=XHiImjpDLiWE6pOyvyUdNdGvJAz1ds3ROTQYYZLmydeaZFldFjbMEGcnlBLKqX5Rsty0
	 /I1wj9Y+EQkYaZZr75DtzSKQpY5nVlS30aZYlFRnxCfcuP3BFkoojVzutvrz6e1JefnvE
	 R8PXQFoTSVYDfWCLqp/OSbUH3iU/YNjAy3TAOvkKmLjPoQrrY9qaD3cQ4TxkkyQUPTNQS
	 RyXR7YuqqtvMvVhipx+adKWqEZuwfhWKEXpI8TxbOzREOXwoHaqLDa/87aU0Uu+kgPLHZ
	 eXxSP8mbfbRrPwXByx43xOXUiL6/MtaRrSHSdB1Kp9JEPkM9pedX7KdDGk4aqa6HhTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793918743;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NTw9ySY/KbOKboF0Y25x7Yn7ooKHlX1svCLfc1orXfk=;
	b=J5t1GCb6lVMBeAzmFMbVDgzXTY77YaXNWOfhPQd/otSnfupEV/8Vdjii86nQJFvAcbpS
	 YhTO//IIpvWqzvtwuhb042KNai+Ei+vB7CI5X3rSovP8zeiwdGJ6jO2Ob5aBNKB36Ae2s
	 xL15dXCtmszw0NjDu6pzu2Bus3waxnQnFKVbk3aNdjjrxaIgcU/xWPmA3mzc2fZxHZTjJ
	 KhcyQv2wybbY1h3gwxDAYtulm9Te26iultPq74to6REWkbeVVosxsoYWcHlJpgl6773XA
	 1ioMETYOD2+MxI71M0MljAuz/6h0KLhOCOgZPXar8x/EpJEu/FoYdoCMPeE4nHWR7/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=yRmh+iEu;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7DD606A31B;
	Thu,  5 Nov 2026 22:45:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F7DD606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=yRmh+iEu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=NTw9ySY/KbOKboF0Y25x7Yn7ooKHlX1svCLfc1orXfk=; b=yRmh+iEuRoXMY+OD2vAgsozt6e
	qzF22cEh+U+mQhknxyYQDCP7Ti73XZeDAbDao6zWT+XTQFTW/hojEnDrYpS0sxtgOXp1BLqBCdmbl
	BIqieqqNLMsB+CMPzGBVMxmaRV+JkoSeAoPLRzg+7EanWQ6KDYPcV9zn6ZkwE5W/iQELxVAM1ag+2
	439Hn3QvGPuWYxgdXK+g6G1hKQNsR1PI3nUITz74qB+K+xyU9iv12VxzWlDFLYNeVFpQvCIX0CO2D
	R6gI81Y2e+Dhko0HfBfmap1FfP4hERyxPlBQZUo7FQTfu/0QzHs/GVtscGz1loylXFk87AeRCdZfO
	BRdlzG/Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xP6D8-00000000yoI-1nGh;
	Thu, 05 Nov 2026 19:45:35 -0300
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
Subject: [PATCH v5 10/17] smb: client: retry writeback on interrupts and allocation failures
Date: Thu,  5 Nov 2026 19:45:24 -0300
Message-ID: <20261105224531.2316211-11-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105224531.2316211-1-pc@manguebit.org>
References: <20261105224531.2316211-1-pc@manguebit.org>
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
index 3ac15442c594..20a056eae5bf 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4878,12 +4878,8 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 
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
@@ -5283,12 +5279,8 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
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

