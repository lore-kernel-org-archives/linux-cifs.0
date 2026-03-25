Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFE82E6CA8
	for <linux-cifs@vger.kernel.org>; Wed, 25 Mar 2026 03:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774410598; cv=none; b=h//ugGo3ISrr8/pvfpuAkFgj/eL9POjp2hi2CMksEXSRzt5cvOGQDsrY2ehnnmciVMH4BsdGuetJfc5/XIeV9B6rZN5bwGDSHCWxRjIHKBDewsafx9VgLZomIC3D0z0eWuNk922NjW+Pa5SmPX7b5Iyd2AWGi/rFLhJlCf/hjMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774410598; c=relaxed/simple;
	bh=Q+XwNmUUkjG7EWq81ruU+NiO4UPFYNLyiwO4GdKFvVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ai2JO5+kjVxGrhYb0JhrR6bTY0egvhMTBPN1b27MTnRQ8B8cA+EKdNmMgrBg7jlP/3mCg9Kd93nKh66JUs+L2c8qEkSLSjqC2wVRPd3wco+Jqs2hn2tfWcKqEFphIWzzBeVQNKkFP1pq0e7Nwz/6Hg1/W7fUN7vHDzKSOkuDnF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c6/eXWDJ; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c6/eXWDJ"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50b266413fbso49554661cf.1
        for <linux-cifs@vger.kernel.org>; Tue, 24 Mar 2026 20:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774410596; x=1775015396; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZuUAes6rNoYThLRW9AbdSAfLFgKqqMFG27AYV3oLAgc=;
        b=c6/eXWDJ0w/eCK7YsfxV/OSzBYSZlRdWktT15SIS3DS2bTU+V/TGYYk1zANAHXHp3L
         rcdM5j9mGQB+n9c0D9Ldqcvn3+8AH5F3fTdcS1B3csBc0m0hqtz3uKQVEcHQcR2KSpYY
         uv3CgWbbldmnYD5kCvhZeCXUs79IJXy1C3oPxswqiR0AEjTMqOn7s9Zl2BgdzC6CvLLQ
         b/8Hhy3JGomYtMB9OQoIrfMgMjJ9IulRVBVMOjx3kHKpA27Ei/1XHaItcm7SmkseTh0l
         +vRjFoZ7y7RjREVKwIxt0QJUzbHKkq1zbXt+zTFoNebhCHpnfapJUwme0LhFphqfIhtC
         aJzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774410596; x=1775015396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZuUAes6rNoYThLRW9AbdSAfLFgKqqMFG27AYV3oLAgc=;
        b=qNEFDqOlO1kk5GwntzvJeuXGblPPWu10jzszSqaxpCXQuG1z7tsLt1a+H3ClpUylt5
         4Mg83AFPitnphOPKCUuhipnVltc+4DJODmDxBLSQqv2i7dQXUaQgV/pz40hjZed7ALye
         LX1QeITRkqjlwh78ZgpIvl8uvXHvyqKudATfV9L+1wyK4r84RHviYpl1YOEzGv82kzQv
         h69lSuGzdsb/Tao2hz8yfMOx1C16iNJMz/gU4Ajve7owSz/F+y5nhy/Jnm+xlEM3V2yh
         Px1hYofwqGGAekAb16UqnCYcACKHSJrEdvp0NnK26oRNr2jwtzLAc5bXvZsp1PRzT+YM
         CwXg==
X-Forwarded-Encrypted: i=1; AJvYcCVU8cjWT4D1AdLWi11GXBYBnt8HglCKHrLGVb72uQU3KPoC9M27ZSZJTONvURa7UTTrgwXQItelLVdW@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/ngBdDsKCALqjC0ILl7BTu4wGGWPM1YOCY5XcsteW5mfy5O6z
	tjNZH7pMiS8FXWOrJ0bWTxib92xxtTaQ44LWP1mlluStxvZF+VfCeBgY
X-Gm-Gg: ATEYQzz0neev6TIp30JUNypeDWeUFATWF9c79DL11CEVWcNnlsQB1kFdjSRPRJ8sRiy
	tDcr371VZA6X43LDSwRr7mW/oql/w5OVMsveNV5fG4cmuPDos8zggFfXcsGfsr8kVf9WC71FI24
	tbSHf8/+JKpy6Xe0covoPq2mfOkYQfhjoEMh8Gb4qXpdmduwLBhqEJAtK4iAuNTez2Xo5u9UeBF
	EjEyJOAAd6lMuJn4+iH6EXo1HSy8RcIjSCUp9KPqI1NgYMmcDPziGkqdMahp8bFhLeJDWJnpzV5
	ywQXmX/T2Cju63rOnmSI4aJKPSQ+q1wErR7OKCLd7c4f7a1sgM7WVbYPGmYCFZDhNbMn0EVvVTE
	t6Nt93ZbfE7OT6PpuSZjTCu9sQeI/OWwnP/Wn1RV0rUimVjuIeIbhIG+lGcZVX8b8bOeLVJOA05
	BFHpWzX96I7H0Qu+JOT/4N6sUL3Wem5yqemj2p0GX2QlBybA9THpdeXRk8vuvEEHaDmHP863C+u
	2QRfFXCm+ZCoeXOIrmLM5WS/1OrJ/e+8bGjtMS8GUe/p4S5npf5JsSFDU6dakavA94zKUO/Rsz+
X-Received: by 2002:a05:622a:4d4c:b0:50b:3664:b207 with SMTP id d75a77b69052e-50b80cf6d13mr31530131cf.20.1774410596054;
        Tue, 24 Mar 2026 20:49:56 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b36cb2e29sm150093001cf.1.2026.03.24.20.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 20:49:55 -0700 (PDT)
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
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.com>,
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
	"Marc E . Fiuczynski" <marc@fiuczynski.com>
Subject: [PATCH net-next v11 13/15] quic: add timer management
Date: Tue, 24 Mar 2026 23:47:18 -0400
Message-ID: <4019cfba3ffd6f91aee24713d2adc778f858b4c4.1774410440.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1774410440.git.lucien.xin@gmail.com>
References: <cover.1774410440.git.lucien.xin@gmail.com>
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

Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
---
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
---
 net/quic/Makefile |   2 +-
 net/quic/socket.c |  33 ++++++++++
 net/quic/socket.h |  33 ++++++++++
 net/quic/timer.c  | 165 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/timer.h  |  47 +++++++++++++
 5 files changed, 279 insertions(+), 1 deletion(-)
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
index 4016de4b39fe..c37cc1522254 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -51,6 +51,8 @@ static int quic_init_sock(struct sock *sk)
 	quic_conn_id_set_init(quic_dest(sk), 0);
 	quic_cong_init(quic_cong(sk));
 
+	quic_timer_init(sk);
+
 	if (quic_stream_init(quic_streams(sk)))
 		return -ENOMEM;
 
@@ -66,6 +68,8 @@ static void quic_destroy_sock(struct sock *sk)
 {
 	u8 i;
 
+	quic_timer_free(sk);
+
 	for (i = 0; i < QUIC_PNSPACE_MAX; i++)
 		quic_pnspace_free(quic_pnspace(sk, i));
 	for (i = 0; i < QUIC_CRYPTO_MAX; i++)
@@ -199,6 +203,35 @@ static int quic_getsockopt(struct sock *sk, int level, int optname,
 
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
index 000000000000..a0914eae628e
--- /dev/null
+++ b/net/quic/timer.c
@@ -0,0 +1,165 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* QUIC kernel implementation
+ * (C) Copyright Red Hat Corp. 2023
+ *
+ * This file is part of the QUIC kernel implementation
+ *
+ * Initialization/cleanup for QUIC protocol support.
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
+void quic_timer_reset_path(struct sock *sk)
+{
+	struct quic_cong *cong = quic_cong(sk);
+	u64 timeout = cong->pto * 2;
+
+	/* Calculate timeout based on cong.pto, but enforce a lower bound. */
+	if (timeout < QUIC_MIN_PATH_TIMEOUT)
+		timeout = QUIC_MIN_PATH_TIMEOUT;
+	quic_timer_reset(sk, QUIC_TIMER_PATH, timeout);
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
index 000000000000..a5dec85f7c3e
--- /dev/null
+++ b/net/quic/timer.h
@@ -0,0 +1,47 @@
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
+void quic_timer_reset_path(struct sock *sk);
+
+void quic_timer_loss_handler(struct sock *sk);
+void quic_timer_pace_handler(struct sock *sk);
+void quic_timer_path_handler(struct sock *sk);
+void quic_timer_sack_handler(struct sock *sk);
+void quic_timer_pmtu_handler(struct sock *sk);
-- 
2.47.1

