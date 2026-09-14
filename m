Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF8347B41F
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 13:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789393992; cv=none; b=GefoELACNsW2MuEjpdyvUbnNW6hxwstKrsH/ovqoQspkyjkhhWLMM8GFF41k4EztJIkbE68eR3MvYi5c6qtJFn9JSuk6CX9bzn5eOqzwXVTlIobESeruj1VgkvVCfzfqT+yv8BweXBjNaDlCB//QrgRRnkyDyS1Eve1AoUODLs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789393992; c=relaxed/simple;
	bh=CUkrlQykYPA1vbTy9VTK+LPGdFXq/Vawq+FuH+4FNsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUBFWGxEXqctZs/9ZOEaKL0SVVpTC8Db6d58QuOideAw/eEauySn8v0YII/Vm1IAaUA/ChIwtBmhveo9HYaVNGZwr1D69LZwt5YPdGTzI8o5nyUHHj4Utij8p4rR2HhkAhDyOlViaiBAVjtgCnRr8TvzQwkaFfl2Fd7LptwOfig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NzZnz0rl; arc=none smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NzZnz0rl"
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d46e4cdccso16351667b3.1
        for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 06:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789393981; x=1789998781; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j0fBOVBVXabWfvHy9V0PSlfqcbjnPwae2SHbx3KCfEU=;
        b=NzZnz0rl76Dm4oPGHaTgDZLQVsrnRgOQSFBt8/ZGrQBTTY1BmBaVtqMecyaoTgMhb7
         SPvbDPTjBQmL9tcxchFcjav/f8LPQufWzwfwwkgkOKPRgpzLL0FkMRN4OvOq3DRsrM+2
         9x8/wXGLhIXQG5eZTpUIEs5eP0qO66WNHvR8IRDHxz7pY2yxegRreVG5/47ghz9dI47W
         4lgQNAa87UOnHG0PNM7GcQe8HbS9TLz/wqcWIVV+5GTx+JBE4IyF0hM1OOCqme/83YJJ
         xTI24Wnv5UI/LRSqFPyUutbWxDLZOerXi6Edodo4jW5Z165iICp10uuUq0yyU3L6Nzht
         3iLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789393981; x=1789998781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=j0fBOVBVXabWfvHy9V0PSlfqcbjnPwae2SHbx3KCfEU=;
        b=f68nzta7J8KCwTD9RwYrq93V1Fd+7Xjqxrgp+a7De4YGQN8FgcgY1mNFCfSF+JHXHT
         Le5OqInt8ie0/jj5HYhEqoPQ2hXwFvuMdN+SooN9uDlTGLlmFLsQCGc7vn0B0ehjMUxx
         rHbIaV1bM2ETDAREe3GCdgbAcneOUgwCgpbM81Jxv93Z0jb6WVF4cyGzwnZctcmk4PCH
         b1kfDQGe38uSXnCg6DeCjJVfkRh45Sil7pzocgIHihFQtM1EgOOCtVUxhAGimqZo8WJn
         gDAsfg2nTdYTUq7SNM7pSCrT0ntBQSWnneMRoq7kE77Qd6Vxwn/bTdW/H0gR+bJpBvbp
         hixA==
X-Forwarded-Encrypted: i=1; AKwUvBy6QjDFSUME7gHgSLVEqRejr8yaSSrZGNakQSNpJS4i55Q+4855kTcO0Ld7beyLEenPSfDWSATnmkhy@vger.kernel.org
X-Gm-Message-State: AFuF++lTR/wkntLOFWTXHMLcM7xewMar3LS+OqCvCFpR+yo7lYi6yRwI
	mh2azgk4SsyERP86BMHK9obVX0Ez2UNERwzE6bDrgBT3TG9CfIefYF+l
X-Gm-Gg: AYBFou0boFOPMvX6kFJ61sVgBcJ6PgrfTbyp+j3oEYTVOmiP2e7JZu/XNyvxNSF0puX
	142CQLSWORZxsSAZWFRST3dasubuXrjtYBr6T9jp4C4Pe9iMgS/+MWOZuK9kOhlJgUfZ/m+M6o8
	uv2JQqY+1PEisi9LSKZhYCS1dEHZSueMFWJYRfBvcmcuAPhBYUjK+8BEuuQXLB5y0x9t0cjam3W
	eGsrSiqEthGEVKvsE2EOebuvnVWIXZN+8ztJWvxgEGJbb0FvGZFpyc5ElmE2WiwLiv9JcXi5U14
	gJ4Y8MgKwFiAdDLQ2JqH9ExuBZxTE2LFMj/xYYf7iFfEj9t/qDaLIn/gYpeCq1AhoOTApuwA8xq
	DpwIFl9D8Ydl61tOwr4TP3DkzH6MNEkz3mhkJmjzFBByjIeTIJlwzKllBzvFMMm0NzbSgwo0ddo
	MJDiuF2A+QYIST8G/rCCqtalOqLKbs4RnJrkabFoZ8sXy1v+L1QEnwnDUVc6rpLDshYNC/HULsl
	nHbXQwndpVCt66ik6mF8cHd06NAPtvDKluteZ7Mrzdda/Cj4MFeOgu9CYgrl4RUKS9IS93uDmnU
	1jUluPyoVRkZTfZ5X6el49f+vm9eiivhM8qqvw==
X-Received: by 2002:a05:690c:f06:b0:866:e57f:58db with SMTP id 00721157ae682-88d199236fcmr11359697b3.0.1789393981312;
        Mon, 14 Sep 2026 06:53:01 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-884895001fasm36307767b3.45.2026.09.14.06.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 06:53:00 -0700 (PDT)
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
	paul@jakma.org
Subject: [PATCH net-next v15 13/15] quic: add timer management
Date: Mon, 14 Sep 2026 09:49:33 -0400
Message-ID: <02bbb6b0c5e4aaf96227693a93ca401c36f25653.1789393775.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1789393775.git.lucien.xin@gmail.com>
References: <cover.1789393775.git.lucien.xin@gmail.com>
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
    timer as unqueued and take the corresponding sock_hold().

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
index 8d3da3f03347..2632f024029c 100644
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
index 000000000000..0dd6d6580bbd
--- /dev/null
+++ b/net/quic/timer.c
@@ -0,0 +1,154 @@
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

