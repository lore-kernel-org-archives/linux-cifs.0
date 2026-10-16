Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9EE4F85B8
	for <linux-cifs@vger.kernel.org>; Fri, 16 Oct 2026 15:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792164577; cv=none; b=Ze/mRqeIkV4k0S6u/9YIHAo/GZ2NBA9OfcH952BTfAKfqyktYVTRRpw9exu+1xTSn1JfzG1P9GOfEwYFApCOykpCDef7MFL54SSOf5VemCnGi+V7QvWqR2JLcUAco8PrEnAKe7abcqjAIREHw5GE1Mncai9BTtEBI7hjCZWhFzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792164577; c=relaxed/simple;
	bh=qm+daEYJ5tJjlxvAyC8hlsDbkGIdpOhjBpdnXtGqhyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5XLFWSw/csNBXI8v9m7UcLX9i4qrll2UMdb3EgYDvG6Q4+mEv1/iJZ4ZM9+uGdPfmwjWx7gfnwOPk1/qTNw3DxSiglOEqTgLP+GsLHGZ15dtCrhGJ6Xowqe/KRmJWY5dxsTD/tSOsUg5He0USrtD8Eyk/nw1+kXv+JuldTidGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nKpOsQUz; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nKpOsQUz"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-91ba702cceaso1198046d6.0
        for <linux-cifs@vger.kernel.org>; Fri, 16 Oct 2026 08:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792164565; x=1792769365; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ox0DuGpnoBTg+DZUDVZjtF3th659wMvIlaXiuPHkklw=;
        b=nKpOsQUzrI/txpqNSvhFPtK/iSAJBXccRNtGvoFb39GWxR1flLKrKidvm6LIdkwWBH
         VCIsh7THtAsjF5c8NWeXDkOFqKI/We3GWPNVmEvTB++jxAIZphnYs5DRc4j/KLTL/J6Y
         CTU2bjeeON3WVuqv8WS/APagdlMqFzn16AgQcty2k8ucUgyOksoDtu1PIxI4zToSWChr
         D6MasyJdFgxDpAGgB+tbFpjPbcxdL4QITlvp5rs0u/oijuas+2iPylk7ftOjixJyf0ZV
         fVOHqebWGIpHWAzUsOHMvvNG5c/PtRc871TiNtThQLQVZWXrnZvuM1QH9x6KVvKlvLme
         J6JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792164565; x=1792769365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ox0DuGpnoBTg+DZUDVZjtF3th659wMvIlaXiuPHkklw=;
        b=JDYN+PIfJ8opYCV46W0z1cr60lw8uOVGyF9MhNVuWm2I6NQXKdQJc8b963ObIGHs+q
         +yFSoA1oxkO0JHZ4K7gyIUUShcLrsFmnRPzvmzOAY2InZGqBBpA4xM1vDExgUAQlK74t
         OP8yoZfmCgUx/eJEy+4/tqTbOVGFzptA/RKLksHN0RW06muZvbpXo3g2UHvjq3lB8YRY
         WzsGAU3OdogsqVB3WFhMi14nf6JIVG3ana3i8JWxRuf4B7REDj+zYJ2i4Y+4S7n2/KJT
         rgp+7UT1Dm5F9Pp0GHM9bW6MBBvXWrFE95KSuouaY5Oa3ZAvtywslJflSS5FbHuFZT0A
         bfVg==
X-Forwarded-Encrypted: i=1; AKwUvBwHA9hnru4roTRLjDeomZ332CqZc0FakR1qJglR62CvwnA9Ga06A/FKsiF+MlVlefDGwug5V83cTkV8@vger.kernel.org
X-Gm-Message-State: AFq9FYIfVfo/wHukmkA5VFYRf/Aa0osj+wkottolydlsAdRdVJU43eYR
	92kvBkSqZzFO3ghaN2fFRMWasNPNKsfm/X1quwz7KJuHGLBlWkla+PjO
X-Gm-Gg: AYBFou1SgiDU/zQN1QB5tAseOGT8dxDf01oCavGyDOGKHmdKQz397bzhaatGMgnAE3v
	JJ5Vqx1uJWCNv7JXqLtrVqjfhPYTLjBqvpplkJ9mjvlepp6r3gqBChJ0IEqdSIwcNBmx5PDJ2Pm
	g3Mhd2k3Ia5XI9vb4hHU+sMkdITMw3FxEgKHu5ZKdcZQPh6CSKYayaFGumKzAo/dTcnxEuCCZYw
	R8IV/d1T+8hDFJAgJ2PSbUr4aQw3/2WYsKhOAa393fm6xVa1kx48Kadr4AT8gl8zcFwIZHZcFO3
	sjNJ+u0thhA3au2JmXUdax5/MFZFBJ8/zeiYT3M94BcVfU2i5eg7jkt4RGtDE5qpHKjl7V6TUSE
	VwsHUn3d058/AGtT5uf/+o0nluxUDhoZwsPa5sNVdxxUCVv55GedKHIa/dX7+s20TvZ0P5/4/8h
	Gaoe6DzUW5AmZgnjwP/CuxL6mg0P1A0IyXV1uS7I4niScR2S0RLKMGGQYe58ER7MoreDJpiK796
	0lTg8B5XEd4+HB7zZSB3F8fIHoNC9D2hMjLXneKrnXf9DIemuu5iZAYfCwZd4chv6Ob6bAn7lp6
	O2OpIRAI1Js/5hMmNtu0W4A57AKt2oQ8u+I9iPf8LQ==
X-Received: by 2002:a05:6214:19e5:b0:91b:d32a:9ea9 with SMTP id 6a1803df08f44-91bdf2e2286mr5379736d6.54.1792164564750;
        Fri, 16 Oct 2026 08:29:24 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91bcba473easm25601866d6.17.2026.10.16.08.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 08:29:24 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	quic@lists.linux.dev
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>,
	Thomas Dreibholz <dreibh@simula.no>,
	linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	kernel-tls-handshake@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Steve Dickson <steved@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Alexander Aring <aahringo@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>,
	illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	mef@scarletmail.rutgers.edu,
	paul@jakma.org,
	Kuniyuki Iwashima <kuniyu@google.com>
Subject: [PATCH net-next v17 13/15] quic: add timer management
Date: Fri, 16 Oct 2026 11:27:16 -0400
Message-ID: <59f4457d5a3b3f5dcc54acb6bc31f13434d18e77.1792164438.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1792164438.git.lucien.xin@gmail.com>
References: <cover.1792164438.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduces 'quic_timer' to unify and manage the five main
timers used in QUIC: loss detection, delayed ACK, path validation,
PMTU probing, and pacing. These timers are critical for driving
retransmissions, connection liveness, and flow control.

Each timer type is initialized, started, reset, or stopped using a common
set of operations.

- quic_timer_reset(): Reset a timer with type and timeout

- quic_timer_start(): Start a timer with type and timeout

- quic_timer_stop(): Stop a timer with type

Although handler functions for each timer are defined, they are currently
placeholders; their logic will be implemented in upcoming patches for
packet transmission and outqueue handling.

Deferred timer actions are also integrated through quic_release_cb(),
which dispatches to the appropriate handler when timers expire.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
---
Sashiko, do not report any of the following concerns:
  - Ignore the concern about timeout = 0 being silently ignored in
    quic_timer_start() and quic_timer_reset(). A timeout value of 0 means
    no timer is armed by design; callers do not use it to request immediate
    expiration. Immediate timer expiry should be handled explicitly by the
    caller if needed.

  - Ignore the potential truncation of 64-bit timeout values in
    usecs_to_jiffies(). QUIC timer values are bounded by protocol and
    implementation limits and cannot exceed the range accepted by
    usecs_to_jiffies(). Therefore, the conversion to unsigned int does not
    truncate a valid QUIC timeout value.

  - Ignore the concern about QUIC_TIMER_PACE accepting a zero timeout.
    Callers of quic_timer_start() with QUIC_TIMER_PACE will ensure the
    timeout is never 0 in the next patchset, so the pacing timer does not
    need an additional zero-timeout check here.

  - Ignore the concern about timer callbacks racing with quic_timer_free().
    quic_timer_free() is called from quic_destroy_sock() only after
    quic_close() has set sk_state to CLOSED.  In the next patchset, any
    timer callback that runs after that point checks sk_state and returns
    immediately when it is CLOSED, without accessing the other quic_sock
    members. Therefore, asynchronous timer cancellation does not result in
    a use-after-free here.

  - Ignore the concern about quic_tsq_enum sharing bit positions with TCP's
    tsq_enum. sk_tsq_flags is used independently by each socket protocol,
    and QUIC's deferred flags are only interpreted by QUIC's release_cb
    path. There is no cross-protocol interpretation of these bits, so
    reusing the low bits is safe and does not require starting the QUIC
    enum above TCP's range.

  - Ignore the concern about QUIC_F_MTU_REDUCED_DEFERRED being cleared
    without a matching __sock_put(). The QUIC_F_MTU_REDUCED_DEFERRED
    handling in quic_release_cb() will be added in the next patch, before
    anything sets this bit and takes the corresponding socket reference.
    Therefore, this patch cannot trigger the described reference leak.

  - Ignore the concern about the timeout parameter having different
    semantics for QUIC_TIMER_PACE. This is intentional: QUIC_TIMER_PACE
    expects an absolute timestamp in nanoseconds, while the other timer
    types expect a relative delay in microseconds. The callers use the
    appropriate units and semantics for each timer type.

  - Ignore the concern about the hrtimer_is_queued() / sock_hold() race.
    quic_timer_start() is called under the socket lock in the next
    patchset, so concurrent callers cannot execute this check-and-arm
    sequence simultaneously. Therefore, only one caller can observe the
    timer as unqueued and take the corresponding sock_hold(). Also adding
    lockdep_assert_held() is unnecessary since such assertions are not
    commonly used in this implementation.

  - Ignore the concern about quic_timer_pace_timeout() potentially reaching
    a sleeping cra_exit() through sock_put(). The crypto algorithms used by
    QUIC have cra_exit() implementations that do not sleep; their teardown
    paths only perform non-sleeping operations. Therefore, releasing the
    socket reference from the softirq context of the pace timer is safe.

  - Ignore the concern about the timer-held socket reference preventing
    quic_destroy_sock() from running. quic_destroy_sock() is called from
    quic_close() via sk_common_release(), so quic_timer_free() is reached
    during socket close and can cancel the pending timers and release their
    references. The timers therefore do not keep closed sockets alive until
    expiration.

  - Ignore the concern about leaking the socket counters in
    quic_init_sock(). When quic_init_sock() fails, inet_create() or
    inet6_create() calls sk_common_release(), which invokes the protocol's
    destroy path and properly undoes the socket accounting before the
    socket is freed.

  - Ignore the concern about container_of() requiring type to be a
    compile-time constant in quic_timer_timeout(). The container_of()
    expression uses the address of t and computes the containing struct
    quic_sock from the selected array element; the array subscript is
    evaluated at runtime before the address is passed to container_of().
    Therefore, a runtime type is valid and does not prevent the code from
    compiling.

  - Ignore the concern about the hrtimer callback accessing the freed timer
    after sock_put(). __run_hrtimer() does not access timer->is_queued
    after the callback returns; the callback state is stored in
    base->running, where base points to the per-CPU hrtimer clock base
    captured before invoking the callback. Therefore, even if the
    callback's sock_put() frees the socket containing the hrtimer, the
    hrtimer infrastructure does not dereference the freed timer afterward.

  - Ignore the concern about not waiting for timer handlers to complete.
    The timer callbacks safely handle the closed socket state, so
    quic_timer_free() only needs to cancel the timers; synchronously
    waiting for an already-running callback is unnecessary during teardown.

v5:
  - Rename QUIC_TSQ_DEFERRED to QUIC_PACE_DEFERRED.
v11:
  - Note for AI reviews: it is safe to avoid synchronous timer shutdown,
    as the timer holds a socket reference and handlers will not access
    pnspace/crypto/cong data once sk_state is closed in later patches.
  - Note for AI reviews: QUIC_F_MTU_REDUCED_DEFERRED will be used in a
    later patch; handling in quic_release_cb() will be added then.
  - Set maximum line length to 80 characters.
  - Add a check for type in quic_timer_reset().
  - Extract quic_timer_timeout() from
    quic_timer_sack/loss/path/pmtu/pace_timeout() (noted by AI review).
v12:
  - Remove quic_timer_reset_path() as it is no longer used.
v16:
  - Improve timer.c file description.
---
 net/quic/Makefile |   2 +-
 net/quic/socket.c |  33 ++++++++++
 net/quic/socket.h |  33 ++++++++++
 net/quic/timer.c  | 154 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/timer.h  |  45 ++++++++++++++
 5 files changed, 266 insertions(+), 1 deletion(-)
 create mode 100644 net/quic/timer.c
 create mode 100644 net/quic/timer.h

diff --git a/net/quic/Makefile b/net/quic/Makefile
index 58bb18f7926d..2ccf01ad9e22 100644
--- a/net/quic/Makefile
+++ b/net/quic/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_IP_QUIC) += quic.o
 
 quic-y := common.o family.o protocol.o socket.o stream.o connid.o path.o \
-	  cong.o pnspace.o crypto.o
+	  cong.o pnspace.o crypto.o timer.o
diff --git a/net/quic/socket.c b/net/quic/socket.c
index 9b1106a9f5e7..c90e24a93f17 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -68,6 +68,8 @@ static int quic_init_sock(struct sock *sk)
 	quic_path_init(quic_paths(sk));
 	quic_cong_init(quic_cong(sk));
 
+	quic_timer_init(sk);
+
 	if (quic_stream_init(quic_streams(sk)))
 		return -ENOMEM;
 
@@ -83,6 +85,8 @@ static void quic_destroy_sock(struct sock *sk)
 {
 	u8 i;
 
+	quic_timer_free(sk);
+
 	for (i = 0; i < QUIC_PNSPACE_MAX; i++)
 		quic_pnspace_free(quic_pnspace(sk, i));
 
@@ -214,6 +218,35 @@ static int quic_getsockopt(struct sock *sk, int level, int optname,
 
 static void quic_release_cb(struct sock *sk)
 {
+	/* Similar to tcp_release_cb(). */
+	unsigned long nflags, flags = smp_load_acquire(&sk->sk_tsq_flags);
+
+	do {
+		if (!(flags & QUIC_DEFERRED_ALL))
+			return;
+		nflags = flags & ~QUIC_DEFERRED_ALL;
+	} while (!try_cmpxchg(&sk->sk_tsq_flags, &flags, nflags));
+
+	if (flags & QUIC_F_LOSS_DEFERRED) {
+		quic_timer_loss_handler(sk);
+		__sock_put(sk);
+	}
+	if (flags & QUIC_F_SACK_DEFERRED) {
+		quic_timer_sack_handler(sk);
+		__sock_put(sk);
+	}
+	if (flags & QUIC_F_PATH_DEFERRED) {
+		quic_timer_path_handler(sk);
+		__sock_put(sk);
+	}
+	if (flags & QUIC_F_PMTU_DEFERRED) {
+		quic_timer_pmtu_handler(sk);
+		__sock_put(sk);
+	}
+	if (flags & QUIC_F_PACE_DEFERRED) {
+		quic_timer_pace_handler(sk);
+		__sock_put(sk);
+	}
 }
 
 static int quic_disconnect(struct sock *sk, int flags)
diff --git a/net/quic/socket.h b/net/quic/socket.h
index d7811391cc8b..c5654fdc06b5 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -21,6 +21,7 @@
 #include "cong.h"
 
 #include "protocol.h"
+#include "timer.h"
 
 extern struct proto quic_prot;
 extern struct proto quicv6_prot;
@@ -32,6 +33,31 @@ enum quic_state {
 	QUIC_SS_ESTABLISHED	= TCP_ESTABLISHED,
 };
 
+enum quic_tsq_enum {
+	QUIC_MTU_REDUCED_DEFERRED,
+	QUIC_LOSS_DEFERRED,
+	QUIC_SACK_DEFERRED,
+	QUIC_PATH_DEFERRED,
+	QUIC_PMTU_DEFERRED,
+	QUIC_PACE_DEFERRED,
+};
+
+enum quic_tsq_flags {
+	QUIC_F_MTU_REDUCED_DEFERRED	= BIT(QUIC_MTU_REDUCED_DEFERRED),
+	QUIC_F_LOSS_DEFERRED		= BIT(QUIC_LOSS_DEFERRED),
+	QUIC_F_SACK_DEFERRED		= BIT(QUIC_SACK_DEFERRED),
+	QUIC_F_PATH_DEFERRED		= BIT(QUIC_PATH_DEFERRED),
+	QUIC_F_PMTU_DEFERRED		= BIT(QUIC_PMTU_DEFERRED),
+	QUIC_F_PACE_DEFERRED		= BIT(QUIC_PACE_DEFERRED),
+};
+
+#define QUIC_DEFERRED_ALL (QUIC_F_MTU_REDUCED_DEFERRED |	\
+			   QUIC_F_LOSS_DEFERRED |		\
+			   QUIC_F_SACK_DEFERRED |		\
+			   QUIC_F_PATH_DEFERRED |		\
+			   QUIC_F_PMTU_DEFERRED |		\
+			   QUIC_F_PACE_DEFERRED)
+
 struct quic_sock {
 	struct inet_sock		inet;
 	struct list_head		reqs;
@@ -47,6 +73,8 @@ struct quic_sock {
 	struct quic_cong		cong;
 	struct quic_pnspace		space[QUIC_PNSPACE_MAX];
 	struct quic_crypto		crypto[QUIC_CRYPTO_MAX];
+
+	struct quic_timer		timers[QUIC_TIMER_MAX];
 };
 
 struct quic6_sock {
@@ -119,6 +147,11 @@ static inline struct quic_crypto *quic_crypto(const struct sock *sk, u8 level)
 	return &quic_sk(sk)->crypto[level];
 }
 
+static inline void *quic_timer(const struct sock *sk, u8 type)
+{
+	return (void *)&quic_sk(sk)->timers[type];
+}
+
 static inline bool quic_is_establishing(struct sock *sk)
 {
 	return sk->sk_state == QUIC_SS_ESTABLISHING;
diff --git a/net/quic/timer.c b/net/quic/timer.c
new file mode 100644
index 000000000000..e40157e790ee
--- /dev/null
+++ b/net/quic/timer.c
@@ -0,0 +1,154 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* QUIC kernel implementation
+ * (C) Copyright Red Hat Corp. 2023
+ *
+ * This file is part of the QUIC kernel implementation
+ *
+ * Timer management.
+ *
+ * Written or modified by:
+ *    Xin Long <lucien.xin@gmail.com>
+ */
+
+#include "socket.h"
+
+static void quic_timer_timeout(struct quic_timer *t, int type, int defer_bit,
+			       void (*handler)(struct sock *sk))
+{
+	struct quic_sock *qs = container_of(t, struct quic_sock, timers[type]);
+	struct sock *sk = &qs->inet.sk;
+
+	bh_lock_sock(sk);
+	if (sock_owned_by_user(sk)) {
+		if (!test_and_set_bit(defer_bit, &sk->sk_tsq_flags))
+			sock_hold(sk);
+		goto out;
+	}
+
+	handler(sk);
+out:
+	bh_unlock_sock(sk);
+	sock_put(sk);
+}
+
+void quic_timer_sack_handler(struct sock *sk)
+{
+}
+
+static void quic_timer_sack_timeout(struct timer_list *t)
+{
+	quic_timer_timeout((struct quic_timer *)t, QUIC_TIMER_SACK,
+			   QUIC_SACK_DEFERRED, quic_timer_sack_handler);
+}
+
+void quic_timer_loss_handler(struct sock *sk)
+{
+}
+
+static void quic_timer_loss_timeout(struct timer_list *t)
+{
+	quic_timer_timeout((struct quic_timer *)t, QUIC_TIMER_LOSS,
+			   QUIC_LOSS_DEFERRED, quic_timer_loss_handler);
+}
+
+void quic_timer_path_handler(struct sock *sk)
+{
+}
+
+static void quic_timer_path_timeout(struct timer_list *t)
+{
+	quic_timer_timeout((struct quic_timer *)t, QUIC_TIMER_PATH,
+			   QUIC_PATH_DEFERRED, quic_timer_path_handler);
+}
+
+void quic_timer_pmtu_handler(struct sock *sk)
+{
+}
+
+static void quic_timer_pmtu_timeout(struct timer_list *t)
+{
+	quic_timer_timeout((struct quic_timer *)t, QUIC_TIMER_PMTU,
+			   QUIC_PMTU_DEFERRED, quic_timer_pmtu_handler);
+}
+
+void quic_timer_pace_handler(struct sock *sk)
+{
+}
+
+static enum hrtimer_restart quic_timer_pace_timeout(struct hrtimer *hr)
+{
+	quic_timer_timeout((struct quic_timer *)hr, QUIC_TIMER_PACE,
+			   QUIC_PACE_DEFERRED, quic_timer_pace_handler);
+	return HRTIMER_NORESTART;
+}
+
+void quic_timer_reset(struct sock *sk, u8 type, u64 timeout)
+{
+	struct timer_list *t = quic_timer(sk, type);
+
+	/* Note that type must never be QUIC_TIMER_PACE for this helper. */
+	if (WARN_ON_ONCE(type == QUIC_TIMER_PACE))
+		return;
+	if (timeout && !mod_timer(t, jiffies + usecs_to_jiffies(timeout)))
+		sock_hold(sk);
+}
+
+void quic_timer_start(struct sock *sk, u8 type, u64 timeout)
+{
+	struct timer_list *t;
+	struct hrtimer *hr;
+
+	if (type == QUIC_TIMER_PACE) {
+		hr = quic_timer(sk, type);
+
+		if (!hrtimer_is_queued(hr)) {
+			hrtimer_start(hr, ns_to_ktime(timeout),
+				      HRTIMER_MODE_ABS_PINNED_SOFT);
+			sock_hold(sk);
+		}
+		return;
+	}
+
+	t = quic_timer(sk, type);
+	if (timeout && !timer_pending(t)) {
+		if (!mod_timer(t, jiffies + usecs_to_jiffies(timeout)))
+			sock_hold(sk);
+	}
+}
+
+void quic_timer_stop(struct sock *sk, u8 type)
+{
+	if (type == QUIC_TIMER_PACE) {
+		if (hrtimer_try_to_cancel(quic_timer(sk, type)) == 1)
+			sock_put(sk);
+		return;
+	}
+	if (timer_delete(quic_timer(sk, type)))
+		sock_put(sk);
+}
+
+void quic_timer_init(struct sock *sk)
+{
+	timer_setup(quic_timer(sk, QUIC_TIMER_LOSS), quic_timer_loss_timeout,
+		    0);
+	timer_setup(quic_timer(sk, QUIC_TIMER_SACK), quic_timer_sack_timeout,
+		    0);
+	timer_setup(quic_timer(sk, QUIC_TIMER_PATH), quic_timer_path_timeout,
+		    0);
+	timer_setup(quic_timer(sk, QUIC_TIMER_PMTU), quic_timer_pmtu_timeout,
+		    0);
+	/* Use hrtimer for pace timer, ensuring precise control over send
+	 * timing.
+	 */
+	hrtimer_setup(quic_timer(sk, QUIC_TIMER_PACE), quic_timer_pace_timeout,
+		      CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED_SOFT);
+}
+
+void quic_timer_free(struct sock *sk)
+{
+	quic_timer_stop(sk, QUIC_TIMER_LOSS);
+	quic_timer_stop(sk, QUIC_TIMER_SACK);
+	quic_timer_stop(sk, QUIC_TIMER_PATH);
+	quic_timer_stop(sk, QUIC_TIMER_PMTU);
+	quic_timer_stop(sk, QUIC_TIMER_PACE);
+}
diff --git a/net/quic/timer.h b/net/quic/timer.h
new file mode 100644
index 000000000000..4f6366037602
--- /dev/null
+++ b/net/quic/timer.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* QUIC kernel implementation
+ * (C) Copyright Red Hat Corp. 2023
+ *
+ * This file is part of the QUIC kernel implementation
+ *
+ * Written or modified by:
+ *    Xin Long <lucien.xin@gmail.com>
+ */
+
+enum {
+	QUIC_TIMER_LOSS, /* Loss detection timer: retransmit on packet loss */
+	QUIC_TIMER_SACK, /* ACK delay timer, also used as idle timer alias */
+	QUIC_TIMER_PATH, /* Path validation timer: verifies path connectivity */
+	QUIC_TIMER_PMTU, /* PLPMTUD probing timer */
+	QUIC_TIMER_PACE, /* Pacing timer: controls packet transmission pacing */
+	QUIC_TIMER_MAX,
+	QUIC_TIMER_IDLE = QUIC_TIMER_SACK,
+};
+
+struct quic_timer {
+	union {
+		struct timer_list t;
+		struct hrtimer hr;
+	};
+};
+
+#define QUIC_MIN_PROBE_TIMEOUT	5000000
+
+#define QUIC_MIN_PATH_TIMEOUT	1500000
+
+#define QUIC_MIN_IDLE_TIMEOUT	1000000
+#define QUIC_DEF_IDLE_TIMEOUT	30000000
+
+void quic_timer_reset(struct sock *sk, u8 type, u64 timeout);
+void quic_timer_start(struct sock *sk, u8 type, u64 timeout);
+void quic_timer_stop(struct sock *sk, u8 type);
+void quic_timer_init(struct sock *sk);
+void quic_timer_free(struct sock *sk);
+
+void quic_timer_loss_handler(struct sock *sk);
+void quic_timer_pace_handler(struct sock *sk);
+void quic_timer_path_handler(struct sock *sk);
+void quic_timer_sack_handler(struct sock *sk);
+void quic_timer_pmtu_handler(struct sock *sk);
-- 
2.47.1

