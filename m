Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793918743;
	b=ElI8GY5Xbesy50aVu0lTjsMtVqqAyqfS93X+B+AkLim4hH2RMSJ+DK6xN/s+r5L9iMgm
	 zyZXheWugGvkNBqcsBG94/VQl8PENScYVYXe39iC7rLADtDaDdy9y5DKX1uPOspoBhHYw
	 lYs6p1lmaYVpF+fXUuDp3o03qPVlCscja6Jvd0fnw9vEfTz5ruELBSOvPiKbGOPy+TF7h
	 u2Y9svkvC7EwfQ0wZ/HOFVeySpZH4CM3kUsBGR4rfRXSeIOmiYq+h8fJ6emXsFbA9iyZ0
	 731ZDl0yPz14TmZpiPwy8pdQ5iGFaYviC1WP8nzdXwpQFUT1Djz8d2cUV/xHlrd2nFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793918743;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qlC8nm9lYCLqwrwIaCM1xTDy6nTRZJjBrgkg6gFM9cY=;
	b=mSTBWf1QHs/yUk6WTxWk8NxILPgvUw+RIhc5ZZIbp1AY4875SIcBqJs8sokgJOwBx3Cq
	 r52gfucYEYEiTklagzz+2+q5meZNu7wkFQgKRwEAJ4NeygmXFYvfh0h4kD+eygkinM4Fj
	 sAMbl+D4sY5NtAJ+VBeA1RFqZ5aD3f98BpdTbH1uBeNkfa4+4pjgR/HkYhRG6UyHRq2Ef
	 unSp/U8rKSA8JfX+optlv06YVlmx3r7PmcsSG5d78SWGdZuI5vgpJO/vXqXrA59x+ASZP
	 O/yLT1TwPrzi7PaRXNDJw6c4VZV56p2F/B3dRAzojQ1h/fYG4ZHLkeeIjmdngmwG3Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=pd6MR+yG;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F972606A32C;
	Thu,  5 Nov 2026 22:45:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F972606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=pd6MR+yG
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=qlC8nm9lYCLqwrwIaCM1xTDy6nTRZJjBrgkg6gFM9cY=; b=pd6MR+yG8l4NvUsZrsENHtJUR8
	HMOhOWpVzRyKJtbBh2GUaW2WgbtTni0tOsf5vAAyxr/85OX2mg2/GQSZS6ZxFxgqKWtTE/m65+FCL
	PR051AHAoHYr4kbBMEjhtUU3seRw92CV7L+Or1KdBeMmc2amGtQ2M9+DyedKKenw8wTFpWN4jmWBI
	c6cuRpqwPRlzT2C/e4a7VDAw7sxz5DE38WOZI+yZ351kJ7jgZSws2Oinx8mjJ8MlIPvMMyEk8lTRu
	l7V+a0pq4ZsBCiD80Fayjc/VnTMHnwCFYZA+078Y64xbEK5X+Yy3TbkCI/H3lHRCLG1PnweygelSN
	lMyhTi0g==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xP6D7-00000000yn0-0JWp;
	Thu, 05 Nov 2026 19:45:34 -0300
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
Subject: [PATCH v5 06/17] smb: client: don't retry failed writes forever regardless of mount options
Date: Thu,  5 Nov 2026 19:45:20 -0300
Message-ID: <20261105224531.2316211-7-pc@manguebit.org>
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
other replayable errors.  Other writes cut short keep being retried, but
as replays, since they may have reached the server, unless umount -f
stopped them, which fails them with -EIO.

Fixes: 2c1238a7477a ("cifs: make retry logic in read/write path consistent with other paths")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/smb2pdu.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index ecc127d9f0af..3ac15442c594 100644
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
+	    (cifs_io_should_replay(wdata) ||
+	     (cut_short && wdata->rreq->origin != NETFS_WRITEBACK &&
+	      !cifs_io_stopped(wdata)))) {
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

