Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794007120;
	b=XvlNFkdsTI3AN/OSycdkUnOwWkqzLjk0YCVTvkr5BEJrFdFCNe+r/h0kuhSrNmabDsaw
	 TpNi4QFWt9sprma+gurjIyXbrLZic1BmBlgLav3oPaiYEEh0Lqdns4GklK5q9DH0vehKQ
	 nZs2nCe5x190EVwsvnoszjwHubCA+Qu7NTud6z+CD7y2MgDXKWJQSgsNhRqTjtDu0DNIE
	 er1bl/1Hsotwjcd1hQ+lFBEe7woXaTI9CaFK0IeF+c9zZ8K1p/wl3C/dH+De6qtMHTXRC
	 TRvl8EZoL9iylUieuBjHSzbeXGhi670xpSnVg+ChikPfQ8i8yNuJij6YuGtIatT5rCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794007120;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=BrifJQ4gacd4ZwkZnHpS1JoeGEyUGf/5MClugtFcKkk=;
	b=k/I5AUdMg68ceSOnIVDAWAN9rYeMSrvCTtH8iPHWZU4FLPcW0WjIhhqJ1wIvl6T2KJ/A
	 h4l1rIKm45uxiIPFerCNCdKgHmrt0qJ9IRq9pgYtQ1kQf27VydI/JS8RVD7mBqDdbjpBP
	 up5YSg9DAAP+bjdRBsnat0QLBdpzJZITUDTlg7EiDG5rmqEeXgWHj+LcJio5safcizU0Q
	 bV84EQaGrlSftHjXSIOej384hHzm4nWkKjbZ07c71oZ0w0y7oVe+6GpwWyf8VqniExYiR
	 bdLZIgDYrurwNZdBQ0obKfJh630Z26zeFromM+2d2E/t0sF9Zr0a7oVhyaTn4Hg/l1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=YjDoi4qm;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649FA606A333;
	Fri,  6 Nov 2026 23:18:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 649FA606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=YjDoi4qm
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=BrifJQ4gacd4ZwkZnHpS1JoeGEyUGf/5MClugtFcKkk=; b=YjDoi4qmMsdhPMRmcFL7vH9KnC
	jUm/9Q0DxuGD3k1xAXlKcds5C31jW8ukfsVtEPCoj4+KUecjg2XOP1vC4rQjFVQvTNGbr1VWtXzso
	l2zByuMw0vEXFh+tnFR0o+fXKOI86K1fAMDrQ9xop8a/EZsjbT7S92rdZI0xVottTeHKq1mHx1D2V
	TMr+t8JLuY/OX+Snsfk45Fib42uDLvtGp0cmRGp4/XMsVXZUUhGEAkiFdpMvjNzLKE7fkuBlrne77
	nQFR6AI6iwAZnS+ujZKF3A/o3B3cYml5bjUzdJyGktm+qWRyV5NQxiJEE4uSBslhoS1GFMn6VtYuu
	stAGzn/A==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPTCX-000000014E8-184P;
	Fri, 06 Nov 2026 20:18:30 -0300
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
Subject: [PATCH v7 07/19] smb: client: don't retry failed writes forever regardless of mount options
Date: Fri,  6 Nov 2026 20:18:15 -0300
Message-ID: <20261106231827.2604956-8-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261106231827.2604956-1-pc@manguebit.org>
References: <20261106231827.2604956-1-pc@manguebit.org>
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

smb2_writev_callback() marks a write for retry whenever the server fails
it with a replayable status, ignoring smb2_should_replay() and so the
hard and retrans mount options.  The latter is only used to decide on a
backoff, so on a soft mount with no retrans, a server that keeps failing
a write with e.g. STATUS_INSUFFICIENT_RESOURCES gets it resent forever,
thousands of times per second, hanging anything waiting on its
writeback:

  smb3_write_err: R=005c359e[2] ... offset=0x27000 len=0xfdf0 rc=-11
  (569410 times in 255 seconds, same subrequest, no growing delay)

Only retry such writes when cifs_io_should_replay() allows it, as already
done for send errors in smb2_async_writev(), otherwise let them fail.
Writeback thus keeps retrying them with backoff, within its retry
window.  Base the decision on the result of this attempt rather than on
wdata->result, which is never reset on success and may hold the error of
a previous attempt.

Writes cut short by a reconnect get retried regardless too.  Have
writeback ones go through cifs_io_should_replay() as well, so that they
back off and soft mounts give up on them after the retry window, as on
other replayable errors.  Other writes cut short keep being retried,
without spending the mount's retries, but as replays, since they may
have reached the server, unless umount -f stopped them, which fails them
with -EIO.

Fixes: 2c1238a7477a ("cifs: make retry logic in read/write path consistent with other paths")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/smb2pdu.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index ecc127d9f0af..736c5c693c79 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5056,6 +5056,7 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	};
 	unsigned int rreq_debug_id = wdata->rreq->debug_id;
 	unsigned int subreq_debug_index = wdata->subreq.debug_index;
+	bool cut_short = false;
 	ssize_t result = 0;
 	size_t written = 0;
 
@@ -5069,10 +5070,7 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		credits.instance = server->reconnect_instance;
 		result = smb2_check_receive(mid, server, 0);
 		if (result != 0) {
-			if (is_replayable_error(result)) {
-				trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_retry_needed);
-				__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
-			} else {
+			if (!is_replayable_error(result)) {
 				wdata->subreq.error = result;
 				trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_bad);
 			}
@@ -5101,12 +5099,9 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		break;
 	case MID_REQUEST_SUBMITTED:
 		trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_req_submitted);
-		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
-		result = -EAGAIN;
-		break;
+		fallthrough;
 	case MID_RETRY_NEEDED:
-		trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_retry_needed);
-		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
+		cut_short = true;
 		result = -EAGAIN;
 		break;
 	case MID_RESPONSE_MALFORMED:
@@ -5160,9 +5155,17 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	wdata->credits.value = 0;
 
 	/* see if we need to retry */
-	if (is_replayable_error(wdata->result) &&
-	    cifs_io_should_replay(wdata))
+	if (is_replayable_error(result) &&
+	    ((cut_short && wdata->rreq->origin != NETFS_WRITEBACK &&
+	      !cifs_io_stopped(wdata)) ||
+	     cifs_io_should_replay(wdata))) {
 		wdata->replay = true;
+		trace_netfs_sreq(&wdata->subreq,
+				 netfs_sreq_trace_io_retry_needed);
+		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
+	} else if (cut_short && cifs_io_stopped(wdata)) {
+		result = -EIO;
+	}
 
 	cifs_write_subrequest_terminated(wdata, result ?: written);
 	release_mid(server, mid);
-- 
2.56.0

