Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794071591;
	b=iSVrHdFzVLkPp7RlvU6Q4OQ2e36PX3a37ctF+46/+On/nLOcQ/wRx7p5mXu6fib+rUcG
	 YRA9QzA/GkaPHwfsGSVfPuSuq4swceJ5yogmiwyJ5h62pALqUkQiy83ozPnGoa0WHi2Sh
	 krWGuAShZDmeIXfly8tOLSmT9IStVvTRz4AAneGMRqPFjMpsBFEzv78J+i1+g6oMY4mHW
	 VfG4paIu6NzY4dUBDgc/DwzOc96U2C+Gv8+RBFrPD2WD0YOLtcl9THAiGgzM04F5vxlck
	 zs0l6u1O6KKlDIohVhlqCye5L5RvkkZb6cl0957FxOZuN5OKk0MvhEK8H52L7wizbLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794071591;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=z45gJVenqDQdfqsulcVzTmokKGR0+PriaPFVgi6XmGI=;
	b=C6FewOG37O1KPRfd1TlvNGRbj7umlbE+iZLIjkBKZG7ZBbpfhpo7nT8O0gk4ZCBkgrLR
	 hDai+cuqMC3AdIhCqZ+BCB44k9XVljKSSSllY1obOxL2HyDXMIbxaKk3XdwH8nTLGEXSR
	 i4KGfcULnBi1m8v+e3qNz4C999lx/0qZTatQLR81BzodmMoSLI0FOFO/Y/YHt8hHhfbwj
	 jCT+yR2TsdWtsRymidFzpi122fCcLNnHxSYB3TjfnsJryDqswk6jzSb8mb54NBxXZIt2y
	 19tLuhiUG8mY8c5PBkNDhwmd2eFlBVAIKOKEzbPND+B/8QQgnX+lKKcHRyCo8wo4Ryw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=Rv9ag+QE;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0D0606A32E;
	Sat,  7 Nov 2026 17:13:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF0D0606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=Rv9ag+QE
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=z45gJVenqDQdfqsulcVzTmokKGR0+PriaPFVgi6XmGI=; b=Rv9ag+QEngX3+o8ycdhbMnRPqG
	bRcIVxVK0UAaydBNk7eyRS85hwhA6o+oJh8/cUZKzoclvmV+Hsv2XMQX6McxJCVF5MSu3GmjbN/B2
	j71P8uHJxDHm54u8E5Bm5BtQ69ui81hYLM+hO5Ck2xOe18JTv5wMKcFexF23aGeOjqEUPSqKGvDt9
	HwtoE4v7NKyVtRTYVbRxtYhnDnO9+kez1454NxkFOu4RZolhPfyKq5UaA/5S/naA3gLKMymyyBPgr
	Gw6VXcT7f8j7MnN77Vvl3Iq8b0eVUZRsfOYOfFbur68HtUW5wO39yWT1/xlw65Gds9eri8z/fDtu4
	3Ttx0P0w==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPjyT-000000017fA-2ODQ;
	Sat, 07 Nov 2026 14:13:06 -0300
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
Subject: [PATCH v9 03/19] netfs: keep the prepare_read errno when abandoning read retries
Date: Sat,  7 Nov 2026 14:12:49 -0300
Message-ID: <20261107171305.2847361-4-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107171305.2847361-1-pc@manguebit.org>
References: <20261107171305.2847361-1-pc@manguebit.org>
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

When ->prepare_read() fails while retrying a read,
netfs_retry_read_subrequests() marks the subrequest failed and abandons
the rest, which overwrites the error of every failed subrequest with
-ENOMEM.  The reader then gets -ENOMEM for e.g. a handle that couldn't be
reopened (-EHOSTDOWN, -ENOENT), a credit wait interrupted by a signal
(-ERESTARTSYS) or umount -f (-EIO).  The first pass doesn't have this
problem, as netfs_cancel_read() keeps the errno.

Record the errno of ->prepare_read() in the subrequest and keep the error
of subrequests that already failed, using -ENOMEM only for those
abandoned while still waiting for a retry.

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/netfs/read_retry.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/netfs/read_retry.c b/fs/netfs/read_retry.c
index 5bd8dee5a834..8a722995fa9d 100644
--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -28,6 +28,7 @@ static void netfs_retry_read_subrequests(struct netfs_io_request *rreq)
 	struct netfs_io_subrequest *subreq;
 	struct netfs_io_stream *stream = &rreq->io_streams[0];
 	struct list_head *next;
+	int ret;
 
 	_enter("R=%x", rreq->debug_id);
 
@@ -140,8 +141,11 @@ static void netfs_retry_read_subrequests(struct netfs_io_request *rreq)
 
 			/* Renegotiate max_len (rsize) */
 			stream->sreq_max_len = subreq->len;
-			if (rreq->netfs_ops->prepare_read &&
-			    rreq->netfs_ops->prepare_read(subreq) < 0) {
+			ret = 0;
+			if (rreq->netfs_ops->prepare_read)
+				ret = rreq->netfs_ops->prepare_read(subreq);
+			if (ret < 0) {
+				subreq->error = ret;
 				trace_netfs_sreq(subreq, netfs_sreq_trace_reprep_failed);
 				__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
 				goto abandon;
@@ -221,7 +225,9 @@ static void netfs_retry_read_subrequests(struct netfs_io_request *rreq)
 				part = netfs_limit_iter(&source, 0, part, stream->sreq_max_segs);
 
 			netfs_stat(&netfs_n_rh_download);
-			if (rreq->netfs_ops->prepare_read(subreq) < 0) {
+			ret = rreq->netfs_ops->prepare_read(subreq);
+			if (ret < 0) {
+				subreq->error = ret;
 				trace_netfs_sreq(subreq, netfs_sreq_trace_reprep_failed);
 				__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
 				goto abandon;
@@ -257,7 +263,9 @@ static void netfs_retry_read_subrequests(struct netfs_io_request *rreq)
 		if (!test_bit(NETFS_SREQ_FAILED, &subreq->flags) &&
 		    !test_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags))
 			continue;
-		subreq->error = -ENOMEM;
+		if (!subreq->error ||
+		    !test_bit(NETFS_SREQ_FAILED, &subreq->flags))
+			subreq->error = -ENOMEM;
 		__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
 		__clear_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
 	}
-- 
2.56.0

