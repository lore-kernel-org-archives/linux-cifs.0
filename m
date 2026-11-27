Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795797657;
	b=2ExfBtXgSs7UY+CxYOiYzQvr+ldhw/GoYRcEEIkPQqUx7wHbKuN/zS6/bm23Jg3R78GT
	 AleAaMCjneTrJ7QMbKeO8HToQ5XQI9D5Q+TSCYD+EkG1yI4mHxxuxAJdFWPqlB94FvsBg
	 lXQG6CpxhiR5+EpaAlvTACjIEXSf1fMxUgB0jd/5WY268nLRsNiud2/4dXkoJnXNHJSno
	 lmoxgFwwDwJhQodxRZizzbBXcvtSkue2AnKlqAgygI39Nfesx1wR4gYc9F90nEiszOa3l
	 yHeVFWeJS2E0uenLCusSO6oE1hr+S1pxTIQ4LASMenVccqE9CPByHEhff8VqkVZf9MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795797657;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=f7dNhFkog+LzfRqkkKZ0oNscJ7BmxES2USuLPJqA5LM=;
	b=UFKsAZd6aWcGD7zBsFe+mqVwyrBgKkEwBQfmKlZd8f4d8IANyXYJF6SQ79+qsymOIiGT
	 u8fNtSebUz2E8LkXkGRPSlLodkiVYd9NPBUjVCMINYUk7HOE9KSOrLn4Di/cKVesjnoe6
	 FGTNXDqDzlJdvq5VGVFUsO+YpeNbuCi7SHJV3TTf4BzgKvsJwaFdrKvLHPbLT1vYHORoN
	 wrfjaguTHPe88WeNVpPtYRYEMVoBOMurMLWaa+cNaW/O+CCdBMvssvEKNDYEXqsJkeAEm
	 7jOzrO1tOC745vdrJFqLGhYcbGJMvqzqhLRLoC4zZ7XLNlcOVvx7bDozo0GHJyF+RWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b="NYn/if9l";
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A272606A6AD;
	Fri, 27 Nov 2026 16:40:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A272606A6AD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=NYn/if9l
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=f7dNhFkog+LzfRqkkKZ0oNscJ7BmxES2USuLPJqA5LM=; b=NYn/if9ljApeC/Jl1iKgxvGNEc
	gUmTW97Naaj4icy7+8Gx6A3obhR3FWgB4z6L/+7w7qAJhLJ/q2tLw+sXoJOFOTgMc0SvBCaKtdXXd
	/mJbiP2oWgBoHaXa9OmiMIaT1mWZmnPoaxKdYZ4rU24lss5ayqzTtqopare550BBKh2IGmTL7q+OH
	hCFlT2mp3xnKx1fYgA/gKjVHWnZKLaNeZfmv4n4h6eMD21a8k8zdhGJadyo9lEUiD6ojR0lZlFGjV
	R8CU1fgXtRyIa5sUjxsyts+5dlzFIoQgvzUhNdPeVbDrTSaSMw+TqcKrdIiSfpVBELmL+TJsCVvP3
	NFyIK7g7Z7UneN7xPO4//CH45bYD89jNy9BqS8OExcwSPmoFUZUTqFrJCvk938ll3LQTvGF9DWmrN
	UFhgdXoS3Jvn9jTkRaIDBHXdbhd4J6jlZQZl6u2v9h+CaZgI4+13iIPFuHcwtmK9bJ1Xwrg+7Tc3e
	cc9OUE1PLWCJVBNwx4OQ2gRs;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWz0D-00000001PvK-3YIH;
	Fri, 27 Nov 2026 16:40:49 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	Sashiko <sashiko-bot+sashiko@kernel.org>
Subject: [PATCH v2 02/13] smb: smbdirect: don't post sends on a torn-down connection
Date: Fri, 27 Nov 2026 17:40:21 +0100
Message-ID: <4ba92691e8e06b83ff3420371e198bf94e76fcf9.1795794871.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795794871.git.metze@samba.org>
References: <cover.1795794871.git.metze@samba.org>
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

smbdirect_connection_post_send_wr() only checked sc->first_error before
ib_post_send(sc->ib.qp, ...). A concurrent smbdirect_socket_release()
can run the teardown to smbdirect_connection_destroy_qp(), which zeroes
sc->ib.qp, in the window between that check and the ib_post_send(),
leading to a NULL pointer dereference.

Re-check sc->first_error after incrementing send_io.pending.count and
pair it with smbdirect_socket_destroy(): first_error is set before the
teardown, the QP is drained, and we now wait for send_io.pending.count
to reach 0 before destroying the QP. So a sender either observes
first_error and backs off before touching sc->ib.qp, or its increment
is observed by the wait and the QP stays alive across ib_post_send().

The send completions that drop send_io.pending.count run on the CQ
workqueue and don't take the handler lock held during destroy, and the
QP is already drained at that point, so the wait does not block.

smbdirect_connection_send_io_done() also has to drop
send_io.pending.count for a signaled send completing with an error,
e.g. after a link down, otherwise smbdirect_socket_destroy() would
wait forever. The unsignaled siblings arriving via skip_free are not
counted.

smbdirect_connect_negotiate_send_done() and
smbdirect_accept_negotiate_send_done() now also wake up
send_io.pending.zero_wait_queue when the count reaches 0, like all
other places. They can't hang smbdirect_socket_destroy(), as it calls
ib_drain_qp() before waiting, but we shouldn't depend on that.

Fixes: 422a2436697d ("smb: smbdirect: introduce smbdirect_socket_destroy[_sync]()")
Cc: stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Closes: https://sashiko.dev/#/patchset/cover.1791225453.git.metze%40samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/smbdirect/accept.c     |  3 ++-
 fs/smb/smbdirect/connect.c    |  3 ++-
 fs/smb/smbdirect/connection.c | 38 ++++++++++++++++++++++++++++++++++-
 fs/smb/smbdirect/socket.c     | 14 +++++++++++++
 4 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/fs/smb/smbdirect/accept.c b/fs/smb/smbdirect/accept.c
index 85e37d11f43d..9fb0676a3035 100644
--- a/fs/smb/smbdirect/accept.c
+++ b/fs/smb/smbdirect/accept.c
@@ -697,7 +697,8 @@ static void smbdirect_accept_negotiate_send_done(struct ib_cq *cq, struct ib_wc
 
 	/* Note this frees wc->wr_cqe, but not wc */
 	smbdirect_connection_free_send_io(send_io);
-	atomic_dec(&sc->send_io.pending.count);
+	if (atomic_dec_and_test(&sc->send_io.pending.count))
+		wake_up(&sc->send_io.pending.zero_wait_queue);
 
 	if (unlikely(wc->status != IB_WC_SUCCESS || WARN_ON_ONCE(wc->opcode != IB_WC_SEND))) {
 		if (wc->status != IB_WC_WR_FLUSH_ERR)
diff --git a/fs/smb/smbdirect/connect.c b/fs/smb/smbdirect/connect.c
index 0d02f03063ac..ce00e6466690 100644
--- a/fs/smb/smbdirect/connect.c
+++ b/fs/smb/smbdirect/connect.c
@@ -560,7 +560,8 @@ static void smbdirect_connect_negotiate_send_done(struct ib_cq *cq, struct ib_wc
 
 	/* Note this frees wc->wr_cqe, but not wc */
 	smbdirect_connection_free_send_io(send_io);
-	atomic_dec(&sc->send_io.pending.count);
+	if (atomic_dec_and_test(&sc->send_io.pending.count))
+		wake_up(&sc->send_io.pending.zero_wait_queue);
 
 	if (unlikely(wc->status != IB_WC_SUCCESS || WARN_ON_ONCE(wc->opcode != IB_WC_SEND))) {
 		if (wc->status != IB_WC_WR_FLUSH_ERR)
diff --git a/fs/smb/smbdirect/connection.c b/fs/smb/smbdirect/connection.c
index e6c7b343fe87..e375584ab447 100644
--- a/fs/smb/smbdirect/connection.c
+++ b/fs/smb/smbdirect/connection.c
@@ -885,13 +885,32 @@ int smbdirect_connection_post_send_wr(struct smbdirect_socket *sc,
 		return sc->first_error;
 
 	atomic_inc(&sc->send_io.pending.count);
+	/*
+	 * Re-check first_error after counting ourselves in
+	 * send_io.pending.count, and pair it with the drain in
+	 * smbdirect_socket_destroy(): that path sets first_error, drains
+	 * the QP and then waits for send_io.pending.count to reach 0
+	 * before smbdirect_connection_destroy_qp() zeroes sc->ib.qp. So
+	 * either we observe first_error here and back off before touching
+	 * sc->ib.qp, or our increment is observed by that wait and the QP
+	 * stays alive across the ib_post_send() below.
+	 */
+	smp_mb__after_atomic();
+	if (unlikely(sc->first_error)) {
+		ret = sc->first_error;
+		if (atomic_dec_and_test(&sc->send_io.pending.count))
+			wake_up(&sc->send_io.pending.zero_wait_queue);
+		return ret;
+	}
+
 	ret = ib_post_send(sc->ib.qp, wr, NULL);
 	if (ret) {
-		atomic_dec(&sc->send_io.pending.count);
 		smbdirect_log_rdma_send(sc, SMBDIRECT_LOG_ERR,
 			"ib_post_send() failed %1pe\n",
 			SMBDIRECT_DEBUG_ERR_PTR(ret));
 		smbdirect_socket_schedule_cleanup(sc, ret);
+		if (atomic_dec_and_test(&sc->send_io.pending.count))
+			wake_up(&sc->send_io.pending.zero_wait_queue);
 	}
 
 	return ret;
@@ -1406,6 +1425,12 @@ static void smbdirect_connection_send_io_done(struct ib_cq *cq, struct ib_wc *wc
 		 * of the siblings too, which will cause
 		 * use after free problems for the others
 		 * triggered from ib_drain_qp().
+		 *
+		 * We also must not drop send_io.pending.count
+		 * here: smbdirect_connection_post_send_wr()
+		 * counted the whole chain only once and the
+		 * signaled final message drops it, also on
+		 * failure, as all posted messages are flushed.
 		 */
 		if (wc->status != IB_WC_SUCCESS)
 			goto skip_free;
@@ -1435,6 +1460,17 @@ static void smbdirect_connection_send_io_done(struct ib_cq *cq, struct ib_wc *wc
 	lcredits += 1;
 
 	if (unlikely(wc->status != IB_WC_SUCCESS || WARN_ON_ONCE(wc->opcode != IB_WC_SEND))) {
+		/*
+		 * The signaled send_io was counted in
+		 * send_io.pending.count by
+		 * smbdirect_connection_post_send_wr(),
+		 * so drop it also on failure, otherwise
+		 * smbdirect_socket_destroy() waits forever.
+		 * The unsignaled siblings arriving via
+		 * skip_free were not counted.
+		 */
+		if (atomic_dec_and_test(&sc->send_io.pending.count))
+			wake_up(&sc->send_io.pending.zero_wait_queue);
 skip_free:
 		if (wc->status != IB_WC_WR_FLUSH_ERR)
 			smbdirect_log_rdma_send(sc, SMBDIRECT_LOG_ERR,
diff --git a/fs/smb/smbdirect/socket.c b/fs/smb/smbdirect/socket.c
index e270e36b3145..749a85274f97 100644
--- a/fs/smb/smbdirect/socket.c
+++ b/fs/smb/smbdirect/socket.c
@@ -669,6 +669,20 @@ static void smbdirect_socket_destroy(struct smbdirect_socket *sc)
 			"freeing mr list\n");
 	smbdirect_connection_destroy_mr_list(sc);
 
+	/*
+	 * first_error is set by now, so no new
+	 * smbdirect_connection_post_send_wr() will proceed past its
+	 * re-check. Wait for any that already counted themselves in
+	 * send_io.pending.count to finish their ib_post_send() before we
+	 * destroy the QP, so none of them runs on a NULL sc->ib.qp.
+	 *
+	 * The send completions that drop the count run on the CQ
+	 * workqueue and don't take the handler lock we hold here, and the
+	 * QP was already drained above, so this does not block.
+	 */
+	wait_event(sc->send_io.pending.zero_wait_queue,
+		   atomic_read(&sc->send_io.pending.count) == 0);
+
 	if (sc->listen.backlog == -1) /* was not a listener */
 		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
 			"destroying qp\n");
-- 
2.43.0

