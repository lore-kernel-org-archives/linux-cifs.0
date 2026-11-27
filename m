Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795782575;
	b=Kn8O8K4dtH4Wepj1ZE+DqL/o5pNYsDGdI4xsI/D2IHNgdOruiT86tI2w1RsbvtqeyPZs
	 npyThzFmDqi0d9VLzFYzvasJ4murtgz3ijwPLF/NeOI5/cBKhemqnt9aqgzzBL7U8WM/O
	 U9pDlUZvwBmZ0tNfScVBezRCmkbw6wEBon7PjcBx0mpnTCw7sshyGl3cJZ/MdhUImFIiz
	 JKoupHp8DevL0rjs/Z4Omy7+O0FpOwq44+g9tDXYvqtAf9QCBAer7iFWcJh9ClDmPXoTg
	 EX0fU6Cz/Jazczdp1pp3a0NKEx5gaWYTeOPz8mBUyZy7BnLX8xpewKHzCY459Jp0+hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795782575;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=f7dNhFkog+LzfRqkkKZ0oNscJ7BmxES2USuLPJqA5LM=;
	b=m+45CzrgVPBw3BoGu5vz4gB8uqji0cUWZLY6YlK8NEvZewAucmkr+2jQioqnNBcMNsEd
	 ofHWEOK9gRk4o3PgmoMB8MyghUTk/1hQ6sfaf18F9kgVEWWLPPrqw52NOg6bvwj+8wRIU
	 7X4lUgLQjnClz+G8hA1WgGhWKyGhMBwfqDxHyIquC7ohF2iLMycuWn808A9BFJHO4Rzti
	 ppND4iyIuq09n9WTjb3lmJJUVuYUA16EVi30cizUHZ9oEm0zAO+bgHnPQky7RYLI4fWal
	 e0F1w2hASXQncrBnOWnO7VGMT8wO6OAa+ZErFixBR8+qrdw/EXwxBJD8h/TpARaVpiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=fhTSlG7n;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84D0606A32E;
	Fri, 27 Nov 2026 12:29:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E84D0606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=fhTSlG7n
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=f7dNhFkog+LzfRqkkKZ0oNscJ7BmxES2USuLPJqA5LM=; b=fhTSlG7nxEVyeOakHVCZagr985
	By8ZHC7Fs89L08XMFZu1iAMahLZZ2PUHxZO223tRQSjb35wS9MFeaB7Ef9KeOvpWixwQvYj16xKGI
	YnVIAFMYyfqQbBfFmdMOfyyFtrmIyk1/IBI+FqEn46ANWIgLYHTK2SjRCMnWcXQyfsarf2FQsiHqD
	ilym2qeTI2haerrkPFwxckOKa13/GMgToNnqwFml80Fcc6gGzIroD0T//u4KCm5aej9KyM6WnFyXG
	6JbJoKWDcVF6PD32z/dCBg6DHr+U7KFDls4N4r3y7kknfvLoA6VoAgHMGJ0fANkMKuqR5F55XLXQ2
	Ul/3O3m1meLDb7VoctQjIcL21Nht5+O/JRcF/QVzxXEvacd6EHu+SECVMJtjREE9N9svyWHXslY1Y
	N/e1zmPmISLOVVN8ZvB6tnsy6Nu93QEXp2A3f4Xy4y5gRUiSihAMKKenmhE6FqL2OcsE90nA766V3
	XXcx357iKywWWj++i7qjt60s;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWv52-00000001La9-0gnY;
	Fri, 27 Nov 2026 12:29:32 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	Sashiko <sashiko-bot+sashiko@kernel.org>
Subject: [PATCH 02/10] smb: smbdirect: don't post sends on a torn-down connection
Date: Fri, 27 Nov 2026 13:28:59 +0100
Message-ID: <264c43d22593951a855bc5c0e6f9f164e0143bf5.1795781300.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795781300.git.metze@samba.org>
References: <cover.1795781300.git.metze@samba.org>
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

