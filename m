Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632538;
	b=ETLV6sRdwINFEjOVbqkNxJ9fQAXlwj3fIt8vyd8LIhkKO65ljL5c+JiiEXuegbiBm1Jv
	 z/RXmm/qNSpTBTAjtCu96a8FTWjbi/vU855y+M1jnmz4Z+I9JDAGI73LJaXoz42KnBmW3
	 /+EawXwlrmXvkT0Ug/sfJrDEjtTOKjanNthH0StAFvn5nh+ghRzf6I9dmVpahYkjqK+8d
	 26jX8v0nRugU61aQODos1qMuDrjdqkj0EsZic8YDlsUzBy1YnBtNru3hq5ubCcESaj3a2
	 lvVXbJ0bkouv7opRu5ahRm2Ed2pzAlMLKvCTAIrObaKCAqo5vo78UztO3Y0O0Z0ZY0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632538;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dnYw/H+GVmNLOE4g5HmY0OBnOl2i3cufGRO2fDxlCtI=;
	b=Q3VcOkOrW9IboNx1PTuayhBqQCoY3fbdQ8emY1TmJNqId7k5lzTCagQYpw08ugxaNFiQ
	 FEtZyRND3r+NCCjOepCyPC7QVlBnluLLGe7mUT52GzLohooCdIula2DtbUDyKvU2nYVLB
	 N+kCAcotmwA95/1wQn+hne7koUYMChPIHL7xJxxic7k0e7aZQbDtB6AP2r8wSbBz7fTil
	 5QoEwquT6b79GFCmV5xWmqSRqORHJ3wMyi2/qU4nJASkWPzlvNizm8C4H10nyU4jvbNq3
	 pKRffjC4vnSNWmfP+WaxDmvKwO52/YHKaWhldqtgwufRKPoUBh1bO3RWsYJEewAh5cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=kRcfqOq3;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A10607B783;
	Mon,  2 Nov 2026 15:15:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49A10607B783
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=kRcfqOq3
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=dnYw/H+GVmNLOE4g5HmY0OBnOl2i3cufGRO2fDxlCtI=; b=kRcfqOq3WPVF4zlSpgTlNcx5nl
	DiDtJXz98AMuvCn3O2j1V+I4rFlwqzEoHevJNQnyGQh2CI2wxoHlFyq/4yNY9aOcq0MnBfR/XbRmq
	nwQ5CCKzzA+XU3K5X+79sT25uNqNaU/fz4YcpVev5EE+acjcvmWtKuCtLAIKY18SArsDaslhuQ7E+
	zsRf5ZYrw4yl21ZdbQpLJ0YHg0yiGx4sKQNDSJaeteYzN6DGsIDJLjJlLwmXpYA7l21bqT2GhUT23
	FcjEhlo9yLR1b4iuQ95op0VB+sS/mtIbtEa0qIW3vrKe28Emufr4f7KmSS0nG5t8j2TsJ25bbmsIW
	G4x1QO6A==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xNtku-00000000aSV-2Ejl;
	Mon, 02 Nov 2026 12:15:29 -0300
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
Subject: [PATCH 11/15] smb: client: retry writeback on interrupts and allocation failures
Date: Mon,  2 Nov 2026 12:15:21 -0300
Message-ID: <20261102151525.925058-12-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102151525.925058-1-pc@manguebit.org>
References: <20261102151525.925058-1-pc@manguebit.org>
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
index 8d7d308a785d..7e45498a4057 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -187,6 +187,9 @@ static void __cifs_issue_write(struct netfs_io_subrequest *subreq)
 	struct cifs_sb_info *sbi = CIFS_SB(subreq->rreq->inode->i_sb);
 	int rc;
 
+	if (wdata->replay && wdata->cur_sleep)
+		msleep(wdata->cur_sleep);
+
 	if (cifs_forced_shutdown(sbi)) {
 		rc = smb_EIO(smb_eio_trace_forced_shutdown);
 		goto fail;
@@ -317,6 +320,9 @@ static void cifs_issue_read(struct netfs_io_subrequest *subreq)
 		 __func__, rreq->debug_id, subreq->debug_index, rreq->mapping,
 		 subreq->transferred, subreq->len);
 
+	if (rdata->replay && rdata->cur_sleep)
+		msleep(rdata->cur_sleep);
+
 	rc = -EIO;
 	if (cifs_io_aborted(rdata))
 		goto failed;
@@ -2741,6 +2747,14 @@ void cifs_write_subrequest_terminated(struct cifs_io_subrequest *wdata, ssize_t
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
index c7b4ea287cb7..29e60f827c84 100644
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
@@ -5284,12 +5280,8 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
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

