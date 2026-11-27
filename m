Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795797710;
	b=4ruAhPPV5D5SXjkLxkGfeBHjZuMzqvs0RoA9HgW3SqIu3BYfaWf3/uEKKGitioxa3xeI
	 3xqNIHXhnNeN0mahbMp9lrZpi5BE9mqQJHjVyFNmWzw9/26qzEUu010HtiwL8gYGxL09x
	 iJFPgnvfQYMIYAREXoUg45M43qX2pihjONCFiXTd0yrttZgSiPcpuSMhy/rhqKseuWbGh
	 un0RE087049SMqAK38gXkXExDD9J4PPkeImkrQ8fCK2/rope8RxOtXAqZGJSIsdAibbOJ
	 79XM96j35rpymElddo0OHVbcYcSGKRdm1RQ7vCvgUH7HAmtMo6QqozxmY49AFkditgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795797710;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Y3CAHhyOjOIXFCK7AjlEW+d4PSZ7SzbsOTJKekTT00w=;
	b=Bfje4kTd5PTGl0Eun7JDI7/F+4bkBgQuScNq2e8uBbqpeGqoKXgDAe+XJh2jUVC6WOv5
	 1JemFp28kGFWyUBwqtN8YtfzgR6767ZqGjt9E7H1ebzNV7kcdtgM7t4flwuGLQVtcRd70
	 7BSzmEy8K23vSj+4iv+NtKmHTy5NeB4cIhioLct6cN3UOMNoW881Dwu5q3TFs6DRWUq/p
	 HPvJ9jfxqMQCIySYQ9U2j/Hke2x51m9vxyp50Kac1AVellA0bdSqfLqM+g6b6lbtYEepw
	 6teGwmGpZe3pvsx+ZItnw4pjqz0b7uRbzBXO+3NH4Dp7SUAvd/YVXJ4b3AiEAhpvCpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=Oi6rXn1v;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA67A606A6A4;
	Fri, 27 Nov 2026 16:41:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA67A606A6A4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=Oi6rXn1v
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Y3CAHhyOjOIXFCK7AjlEW+d4PSZ7SzbsOTJKekTT00w=; b=Oi6rXn1vpxrE6NWK3kUMPdvOxr
	8ONFdLIfCC8VfmC63nKt2MolBMfJygG9zhC7cEvl0matOgfNcS/8Jkg0HBXgnpqNs/q20dLavfRxR
	P/Elqv2QZBT0yK1ZL/OEPIvm9hy76+ny4p/Crcb/e/53lC3DaQDRnlIiygDytFc5MPJTf4dbzUqfo
	YF5gbuVad1NbMTeNP9EEpyRkyXrfforYGWBiX5WTwqvyMMX4Gw0G4QVKfWUiK9PHfS+7+Zrb5qZ+m
	sBl/XEqwy9XWw5ehhGN1eXPngSE8drtyMaY+eox+NXDv11robuQpEX5OpvEOcK1sam0q4k0xNNckN
	kv+9T5rKwQnrdDrwFOOhv64Q0m5jQJ1r4TiMyisjt1POiOhEL3DDLDsthmTnaXny88zd7/f0yTxyx
	9VTmMNXgQZqOhG4+XYSSnq/An5QI9Zn8xQ8dsByp/nZqzSqYj+6j2Y/kjLVqVqKRezsG49rPjJ5UI
	Ni6eNHqPx+ZG/TcyscZ3Tk7D;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWz15-00000001Q3h-2Atu;
	Fri, 27 Nov 2026 16:41:43 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2 11/13] smb: smbdirect: don't let MR work requests miss the QP drain
Date: Fri, 27 Nov 2026 17:40:30 +0100
Message-ID: <b64f8b0dc6ce786de3218a2980822cc53f4ce0e0.1795794871.git.metze@samba.org>
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

smbdirect_connection_register_mr_io() and
smbdirect_connection_deregister_mr_io() check sc->status under
mr->mutex and then post IB_WR_REG_MR or IB_WR_LOCAL_INV.
smbdirect_socket_destroy() changes the status and drains the QP
without that mutex, it only waits for it later in
smbdirect_connection_destroy_mr_list():

CPU0                     CPU1
register_mr_io()
  mutex_lock(&mr->mutex)
  status == CONNECTED
                         smbdirect_socket_destroy()
                           status = DISCONNECTED
                           ib_drain_qp()
                           destroy_mr_list()
                             mutex_lock(&mr->mutex) [waits]
  ib_post_send(REG_MR)
  mutex_unlock(&mr->mutex)
                             disable_locked(mr)
                             mr->socket = NULL
                             kref_put(&mr->kref)
<send cq>
mr_io_register_done()
  schedule_cleanup(mr->socket == NULL)

The work request posted after the drain is flushed asynchronously, so
its completion handler passes the NULL mr->socket to
smbdirect_socket_schedule_cleanup(), and if the caller already dropped
the last reference of the mr, the cqe is part of freed memory. The
same happens with IB_WR_LOCAL_INV from
smbdirect_connection_deregister_mr_io().

Take and release each mr->mutex in smbdirect_socket_destroy() after
the status changed and before ib_drain_qp(), so a work request posted
after a status check that still saw CONNECTED is posted before the
drain, which then also runs its completion while the mr is still
attached. Later callers see the new status under the mutex and don't
post anything.

Fixes: b0432201a11b ("smb: client: let destroy_mr_list() keep smbdirect_mr_io memory if registered")
Fixes: de5ef8ec3c46 ("smb: smbdirect: introduce smbdirect_mr.c with client mr code")
Cc: stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-4461fbd8-a522-43ee-81d1-651432a55de9
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/smbdirect/internal.h |  2 ++
 fs/smb/smbdirect/mr.c       | 28 +++++++++++++++++++++++++++-
 fs/smb/smbdirect/socket.c   |  2 ++
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/fs/smb/smbdirect/internal.h b/fs/smb/smbdirect/internal.h
index 7044dd47c339..1ce89bbfaf03 100644
--- a/fs/smb/smbdirect/internal.h
+++ b/fs/smb/smbdirect/internal.h
@@ -134,6 +134,8 @@ void smbdirect_connection_invalidate_rkey(struct smbdirect_socket *sc, u32 rkey)
 
 int smbdirect_connection_create_mr_list(struct smbdirect_socket *sc);
 
+void smbdirect_connection_wait_mr_io_posts(struct smbdirect_socket *sc);
+
 void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc);
 
 int smbdirect_accept_connect_request(struct smbdirect_socket *sc,
diff --git a/fs/smb/smbdirect/mr.c b/fs/smb/smbdirect/mr.c
index 760a6049182a..c56cea10bb73 100644
--- a/fs/smb/smbdirect/mr.c
+++ b/fs/smb/smbdirect/mr.c
@@ -145,6 +145,30 @@ static void smbdirect_mr_io_free_locked(struct kref *kref)
 	kfree(mr);
 }
 
+/*
+ * smbdirect_connection_register_mr_io() and
+ * smbdirect_connection_deregister_mr_io() check the status under
+ * mr->mutex before they post IB_WR_REG_MR or IB_WR_LOCAL_INV.
+ * smbdirect_socket_destroy() calls this once the status is no longer
+ * CONNECTED and before ib_drain_qp(), so every work request posted
+ * after a check that still saw CONNECTED is posted before the drain
+ * and its completion runs while the mr is still attached to the
+ * socket. Later callers see the new status and don't post anything.
+ *
+ * The list is only changed by smbdirect_connection_create_mr_list()
+ * and smbdirect_connection_destroy_mr_list(), so we can walk it
+ * without sc->mr_io.all.lock and sleep on the mutexes.
+ */
+void smbdirect_connection_wait_mr_io_posts(struct smbdirect_socket *sc)
+{
+	struct smbdirect_mr_io *mr;
+
+	list_for_each_entry(mr, &sc->mr_io.all.list, list) {
+		mutex_lock(&mr->mutex);
+		mutex_unlock(&mr->mutex);
+	}
+}
+
 void smbdirect_connection_destroy_mr_list(struct smbdirect_socket *sc)
 {
 	struct smbdirect_mr_io *mr, *tmp;
@@ -342,7 +366,9 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 	 * smbdirect_connection_destroy_mr_list() (which runs before
 	 * smbdirect_connection_destroy_qp() zeroes sc->ib.qp) blocks on
 	 * this mutex, so the QP can't be destroyed under the
-	 * ib_post_send() below.
+	 * ib_post_send() below. smbdirect_socket_destroy() also waits
+	 * for this mutex before it drains the QP, see
+	 * smbdirect_connection_wait_mr_io_posts().
 	 *
 	 * If the teardown already disabled this mr, it also detached it
 	 * from the socket and dropped its reference, so we only drop
diff --git a/fs/smb/smbdirect/socket.c b/fs/smb/smbdirect/socket.c
index 53be81077adb..f4eae1792790 100644
--- a/fs/smb/smbdirect/socket.c
+++ b/fs/smb/smbdirect/socket.c
@@ -649,6 +649,8 @@ static void smbdirect_socket_destroy(struct smbdirect_socket *sc)
 		smbdirect_socket_wake_up_all(sc);
 	}
 
+	smbdirect_connection_wait_mr_io_posts(sc);
+
 	if (sc->ib.qp) {
 		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
 			"drain qp\n");
-- 
2.43.0

