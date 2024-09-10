Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FB2168C3F;
	Tue, 10 Sep 2024 02:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725935529; cv=none; b=LKG4Ipz/s4RgkYK84csGV0cl/vtbYoAb58w7UzpRqfUd6I39ixFFxd5uiDsSHt+mE0fqkhm/QFiQF+Idk4ANUfNg1tyiv9ISHtIIFvV6gTus+KCLmXXI3DTVLvPfcpAklCLrAQ7jE6v6XBVLKQjuge/67gm49izzLLh5Ynk/mc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725935529; c=relaxed/simple;
	bh=VbIvG98TINi//XNaNuGag23NDo88bNWcX2hcxA1ZriI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oy+aBISef2FotbgOKp9QlI9pccggQ7U281NWc/BMeHZUHtxuYt2JEyubdpoKr4tyQzjgBeQDEjtvrUHRsbD8SFLNEP50NEuuwYcyK3508Af/OxdJrgNTygIjBLFSi+ljEKtGHrM7XuOc/6GW/YZcGdIg9xphZUr+qB9h6VCQb7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gm9dnc4S; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gm9dnc4S"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7a9b3cd75e5so128001085a.0;
        Mon, 09 Sep 2024 19:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725935512; x=1726540312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xisp5uXBOiVO6OjNAmRAkS7WrQ9P/gBV2OCN+ZBsIjo=;
        b=Gm9dnc4SOVKOYRw8Y//nuapFimKcIfWc+UISJZ/1uOEGu3yKvS8KdfTuBfJKFQ7Gnn
         PnvMX8QxctaLIlSfqq0c+T6sm+1maFeXnsgYwS7ZUTZYALiVKrVGkSvwlhGk/OQ5VR5R
         eLg8qTdPQD1DCPM9zWfHjEx7MhtlIgh9gSalMkZLREMUWoohgCP8RWI2LnjRLmGJ22Mu
         3FlC/FHabdrjd8X2uGe8fAjExIyoSIm292CCaRqy0qemc0XfoHsLv+ZpEAfx3QYROdIG
         7I9eGUwS9BYoiU3AOGB4MdEfJh1fP/qDCvfQkolwMI1K4hoUXV5xCfi8rcgV7UOqZIYH
         nIfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725935512; x=1726540312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xisp5uXBOiVO6OjNAmRAkS7WrQ9P/gBV2OCN+ZBsIjo=;
        b=cEEwV8t7Sgy9cAoeS1jh85SuO2eVaTUUyboMfKXCysHnEmoJy0ZhH3tzekfDjQQWs1
         da6Sc/g5S4R9CmyZFSVOcSUBwbX4Zm+5lIflsN7Uhbt8djFWtnuQeVDFCdl+swXQtIHG
         PqrG9525Mh4mkXhOjbUtsrjXLpubwlaAM9KJKLHZqMG9k3dNOPAdzfdsywIUuZ5Ex5a+
         Dq0eKr14Zd6PkDwf81mu9fFzjKVRiTNOPWLst5OhGpKjNXvYjJajsTTyhneETVtdw+Kl
         E6A10AZfPKyc98VAKp2NeaJK+6qn7UVw+ikYOqFDQSX6QjX55Z5ba/RKUTDWya4XrfQT
         GIzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOGJsHkqZtOCv+3Bq37jFGccdGdil494OvB5YG/+WfSL5s7/aSJ3m1IZvR7KDgwn7z6KMux+RtFAj4@vger.kernel.org
X-Gm-Message-State: AOJu0YzNEZ2hIxZ/inLi3HGRRAT49rm5F3D8e1dOkoTXw9as/80NzoL5
	TT/nwOrmQHC0cDe5NwGTLmtTZTBdrjdwAyg6Qt91R8D1/dMowxmA+iVr1jLZ
X-Google-Smtp-Source: AGHT+IH7Cj/DBneh/JoVTuEq7AZ6OAJxi7UQVN3fRBj/QeBpI0nqE7/ot3l/779gEaxzz6v6xh/cFg==
X-Received: by 2002:a05:620a:2556:b0:79e:f851:66ec with SMTP id af79cd13be357-7a99738a570mr1840553185a.61.1725935510303;
        Mon, 09 Sep 2024 19:31:50 -0700 (PDT)
Received: from wsfd-netdev15.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a9a7a1f594sm270429885a.121.2024.09.09.19.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 19:31:49 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>,
	linux-cifs@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Tom Talpey <tom@talpey.com>,
	kernel-tls-handshake@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Steve Dickson <steved@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Alexander Aring <aahringo@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: [PATCH net-next 3/5] net: implement QUIC protocol code in net/quic directory
Date: Mon,  9 Sep 2024 22:30:18 -0400
Message-ID: <263f1674317f7e3b511bde44ae62a4ff32c2e00b.1725935420.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1725935420.git.lucien.xin@gmail.com>
References: <cover.1725935420.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This commit adds the initial implementation of the QUIC protocol code.
The new net/quic directory contains the necessary source files to
handle QUIC functionality within the networking subsystem:

- protocol.c: module init/exit and family_ops for inet and inet6.
- socket.c: definition of functions within the 'quic_prot' struct.
- connid.c: management of source and dest connection IDs.
- stream.c: bidi/unidirectional stream handling and management.
- cong.c: RTT measurement and congestion control mechanisms.
- timer.c: definition of essential timers including RTX/PROBE/IDLE/ACK.
- packet.c: creation and processing of various of short/long packets.
- frame.c: creation and processing of diverse types of frames.
- crypto.c: key derivation/update and header/payload de/encryption.
- pnspace.c: packet number namespaces and SACK range handling.
- input.c: socket lookup and stream/event frames enqueuing to userspace.
- output.c: frames enqueuing for send/resend as well as acknowledgment.
- path.c: src/dst path management including UDP tunnels and PLPMTUD.
- test/unit_test.c: tests for APIs defined in some of the above files.
- test/sample_test.c: a sample showcasing usage from the kernel space.

It introduces fundamental support for the following RFCs:

- RFC9000 - QUIC: A UDP-Based Multiplexed and Secure Transport
- RFC9001 - Using TLS to Secure QUIC
- RFC9002 - QUIC Loss Detection and Congestion Control
- RFC9221 - An Unreliable Datagram Extension to QUIC
- RFC9287 - Greasing the QUIC Bit
- RFC9368 - Compatible Version Negotiation for QUIC
- RFC9369 - QUIC Version 2

The QUIC module is currently labeled as "EXPERIMENTAL".

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Moritz Buhl <mbuhl@openbsd.org>
Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
Signed-off-by: Pengtao He <hepengtao@xiaomi.com>
---
 include/linux/quic.h        |   19 +
 net/quic/Kconfig            |   34 +
 net/quic/Makefile           |   19 +
 net/quic/cong.c             |  630 ++++++++++
 net/quic/cong.h             |  118 ++
 net/quic/connid.c           |  188 +++
 net/quic/connid.h           |  120 ++
 net/quic/crypto.c           |  996 ++++++++++++++++
 net/quic/crypto.h           |  153 +++
 net/quic/frame.c            | 1903 ++++++++++++++++++++++++++++++
 net/quic/frame.h            |  198 ++++
 net/quic/hashtable.h        |  145 +++
 net/quic/input.c            |  602 ++++++++++
 net/quic/input.h            |  155 +++
 net/quic/number.h           |  314 +++++
 net/quic/output.c           |  748 ++++++++++++
 net/quic/output.h           |  199 ++++
 net/quic/packet.c           | 1523 ++++++++++++++++++++++++
 net/quic/packet.h           |  125 ++
 net/quic/path.c             |  422 +++++++
 net/quic/path.h             |  143 +++
 net/quic/pnspace.c          |  184 +++
 net/quic/pnspace.h          |  209 ++++
 net/quic/protocol.c         |  950 +++++++++++++++
 net/quic/protocol.h         |   71 ++
 net/quic/socket.c           | 2183 +++++++++++++++++++++++++++++++++++
 net/quic/socket.h           |  267 +++++
 net/quic/stream.c           |  252 ++++
 net/quic/stream.h           |  150 +++
 net/quic/test/sample_test.c |  615 ++++++++++
 net/quic/test/unit_test.c   | 1190 +++++++++++++++++++
 net/quic/timer.c            |  302 +++++
 net/quic/timer.h            |   43 +
 33 files changed, 15170 insertions(+)
 create mode 100644 include/linux/quic.h
 create mode 100644 net/quic/Kconfig
 create mode 100644 net/quic/Makefile
 create mode 100644 net/quic/cong.c
 create mode 100644 net/quic/cong.h
 create mode 100644 net/quic/connid.c
 create mode 100644 net/quic/connid.h
 create mode 100644 net/quic/crypto.c
 create mode 100644 net/quic/crypto.h
 create mode 100644 net/quic/frame.c
 create mode 100644 net/quic/frame.h
 create mode 100644 net/quic/hashtable.h
 create mode 100644 net/quic/input.c
 create mode 100644 net/quic/input.h
 create mode 100644 net/quic/number.h
 create mode 100644 net/quic/output.c
 create mode 100644 net/quic/output.h
 create mode 100644 net/quic/packet.c
 create mode 100644 net/quic/packet.h
 create mode 100644 net/quic/path.c
 create mode 100644 net/quic/path.h
 create mode 100644 net/quic/pnspace.c
 create mode 100644 net/quic/pnspace.h
 create mode 100644 net/quic/protocol.c
 create mode 100644 net/quic/protocol.h
 create mode 100644 net/quic/socket.c
 create mode 100644 net/quic/socket.h
 create mode 100644 net/quic/stream.c
 create mode 100644 net/quic/stream.h
 create mode 100644 net/quic/test/sample_test.c
 create mode 100644 net/quic/test/unit_test.c
 create mode 100644 net/quic/timer.c
 create mode 100644 net/quic/timer.h

diff --git a/include/linux/quic.h b/include/linux/quic.h
new file mode 100644
index 000000000000..b3fc365e9c22
--- /dev/null
+++ b/include/linux/quic.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/* QUIC kernel implementation
+ * (C) Copyright Red Hat Corp. 2023
+ *
+ * This file is part of the QUIC kernel implementation
+ *
+ * Written or modified by:
+ *    Xin Long <lucien.xin@gmail.com>
+ */
+
+#ifndef __linux_quic_h__
+#define __linux_quic_h__
+
+#include <uapi/linux/quic.h>
+
+int quic_sock_setopt(struct sock *sk, int optname, void *optval, unsigned int optlen);
+int quic_sock_getopt(struct sock *sk, int optname, void *optval, unsigned int *optlen);
+
+#endif
diff --git a/net/quic/Kconfig b/net/quic/Kconfig
new file mode 100644
index 000000000000..076c6e4380df
--- /dev/null
+++ b/net/quic/Kconfig
@@ -0,0 +1,34 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# QUIC configuration
+#
+
+menuconfig IP_QUIC
+	tristate "QUIC: A UDP-Based Multiplexed and Secure Transport (Experimental)"
+	depends on INET
+	depends on IPV6
+	select NET_UDP_TUNNEL
+	help
+	  QUIC: A UDP-Based Multiplexed and Secure Transport
+
+	  From rfc9000 <https://www.rfc-editor.org/rfc/rfc9000.html>.
+
+	  QUIC provides applications with flow-controlled streams for structured
+	  communication, low-latency connection establishment, and network path
+	  migration.  QUIC includes security measures that ensure
+	  confidentiality, integrity, and availability in a range of deployment
+	  circumstances.  Accompanying documents describe the integration of
+	  TLS for key negotiation, loss detection, and an exemplary congestion
+	  control algorithm.
+
+	  To compile this protocol support as a module, choose M here: the
+	  module will be called quic. Debug messages are handled by the
+	  kernel's dynamic debugging framework.
+
+	  If in doubt, say N.
+
+if IP_QUIC
+config IP_QUIC_TEST
+	depends on NET_HANDSHAKE || KUNIT
+	def_tristate m
+endif
diff --git a/net/quic/Makefile b/net/quic/Makefile
new file mode 100644
index 000000000000..ca6d8c745fac
--- /dev/null
+++ b/net/quic/Makefile
@@ -0,0 +1,19 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Makefile for QUIC support code.
+#
+
+obj-$(CONFIG_IP_QUIC) += quic.o
+
+quic-y := protocol.o socket.o connid.o stream.o path.o packet.o \
+	  frame.o input.o output.o crypto.o pnspace.o timer.o cong.o
+
+ifdef CONFIG_KUNIT
+	obj-$(CONFIG_IP_QUIC_TEST) += quic_unit_test.o
+	quic_unit_test-y := test/unit_test.o
+endif
+
+ifdef CONFIG_NET_HANDSHAKE
+	obj-$(CONFIG_IP_QUIC_TEST) += quic_sample_test.o
+	quic_sample_test-y := test/sample_test.o
+endif
diff --git a/net/quic/cong.c b/net/quic/cong.c
new file mode 100644
index 000000000000..7d113d574a52
--- /dev/null
+++ b/net/quic/cong.c
@@ -0,0 +1,630 @@
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
+#include <uapi/linux/quic.h>
+#include <linux/jiffies.h>
+#include <net/sock.h>
+
+#include "cong.h"
+
+/* CUBIC APIs */
+struct quic_cubic {
+	u32 pending_w_add;
+	u32 origin_point;
+	u32 epoch_start;
+	u32 pending_add;
+	u32 w_last_max;
+	u32 w_tcp;
+	u64 k;
+
+	/* HyStart++ variables */
+	u32 current_round_min_rtt;
+	u32 css_baseline_min_rtt;
+	u32 last_round_min_rtt;
+	u16 rtt_sample_count;
+	u16 css_rounds;
+	s32 window_end;
+};
+
+/* HyStart++ constants */
+#define QUIC_HS_MIN_SSTHRESH		16
+#define QUIC_HS_N_RTT_SAMPLE		8
+#define QUIC_HS_MIN_ETA			4000
+#define QUIC_HS_MAX_ETA			16000
+#define QUIC_HS_MIN_RTT_DIVISOR		8
+#define QUIC_HS_CSS_GROWTH_DIVISOR	4
+#define QUIC_HS_CSS_ROUNDS		5
+
+static u64 cubic_root(u64 n)
+{
+	u64 a, d;
+
+	if (!n)
+		return 0;
+
+	d = __builtin_clzll(n);
+	a = 1ULL << ((64 - d) / 3 + 1);
+
+	for (; a * a * a > n;)
+		a = (2 * a + n / a / a) / 3;
+	return a;
+}
+
+static void cubic_slow_start(struct quic_cong *cong, u32 bytes, s64 number)
+{
+	struct quic_cubic *cubic = quic_cong_priv(cong);
+	u32 eta;
+
+	if (cubic->window_end <= number)
+		cubic->window_end = -1;
+
+	if (cubic->css_baseline_min_rtt != U32_MAX)
+		bytes = bytes / QUIC_HS_CSS_GROWTH_DIVISOR;
+	cong->window = min_t(u32, cong->window + bytes, cong->max_window);
+
+	if (cubic->css_baseline_min_rtt != U32_MAX) {
+		/* If CSS_ROUNDS rounds are complete, enter congestion avoidance */
+		if (++cubic->css_rounds > QUIC_HS_CSS_ROUNDS) {
+			cubic->css_baseline_min_rtt = U32_MAX;
+			cubic->w_last_max = cong->window;
+			cong->ssthresh = cong->window;
+			cubic->css_rounds = 0;
+		}
+		return;
+	}
+
+	if (cubic->last_round_min_rtt != U32_MAX &&
+	    cubic->current_round_min_rtt != U32_MAX &&
+	    cong->window >= QUIC_HS_MIN_SSTHRESH * cong->mss &&
+	    cubic->rtt_sample_count >= QUIC_HS_N_RTT_SAMPLE) {
+		eta = cubic->last_round_min_rtt / QUIC_HS_MIN_RTT_DIVISOR;
+		if (eta < QUIC_HS_MIN_ETA)
+			eta = QUIC_HS_MIN_ETA;
+		else if (eta > QUIC_HS_MAX_ETA)
+			eta = QUIC_HS_MAX_ETA;
+
+		pr_debug("%s: current_round_min_rtt: %u, last_round_min_rtt: %u, eta: %u\n",
+			 __func__, cubic->current_round_min_rtt, cubic->last_round_min_rtt, eta);
+
+		/* delay increase triggers slow start exit and enter CSS */
+		if (cubic->current_round_min_rtt >= cubic->last_round_min_rtt + eta)
+			cubic->css_baseline_min_rtt = cubic->current_round_min_rtt;
+	}
+}
+
+static void cubic_cong_avoid(struct quic_cong *cong, u32 bytes)
+{
+	struct quic_cubic *cubic = quic_cong_priv(cong);
+	u32 add, target_add, tcp_add = 0;
+	u64 tx, kx, time_delta, delta, t;
+	u64 target, cwnd_thres;
+	u64 m;
+
+	if (cubic->epoch_start == U32_MAX) {
+		cubic->epoch_start = cong->time;
+		if (cong->window < cubic->w_last_max) {
+			/*
+			 *        ┌────────────────┐
+			 *     3  │W    - cwnd
+			 *     ╲  │ max       epoch
+			 * K =  ╲ │────────────────
+			 *       ╲│       C
+			 */
+			cubic->k = cubic->w_last_max - cong->window;
+			cubic->k = cubic_root(cubic->k * 10 / 4 / cong->mss);
+			cubic->origin_point = cubic->w_last_max;
+		} else {
+			cubic->k = 0;
+			cubic->origin_point = cong->window;
+		}
+		cubic->w_tcp = cong->window;
+		cubic->pending_add = 0;
+		cubic->pending_w_add = 0;
+	}
+
+	/*
+	 * t = t        - t
+	 *      current    epoch
+	 */
+	t = cong->time - cubic->epoch_start;
+	tx = (t << 10) / USEC_PER_SEC;
+	kx = (cubic->k << 10);
+	if (tx > kx)
+		time_delta = tx - kx;
+	else
+		time_delta = kx - tx;
+	/*
+	 *                        3
+	 * W     (t) = C * (t - K)  + W
+	 *  cubic                      max
+	 */
+	delta = cong->mss * ((((time_delta * time_delta) >> 10) * time_delta) >> 10) * 4 / 10;
+	delta >>= 10;
+	if (tx > kx)
+		target = cubic->origin_point + delta;
+	else
+		target = cubic->origin_point - delta;
+
+	/*
+	 * W     (t + RTT)
+	 *  cubic
+	 */
+	cwnd_thres = (target * (((t + cong->smoothed_rtt) << 10) / USEC_PER_SEC)) >> 10;
+	pr_debug("%s: target: %llu, thres: %llu, delta: %llu, t: %llu, srtt: %u, tx: %llu, kx: %llu\n",
+		 __func__, target, cwnd_thres, delta, t, cong->smoothed_rtt, tx, kx);
+	/*
+	 *          ⎧
+	 *          ⎪cwnd            if  W     (t + RTT) < cwnd
+	 *          ⎪                     cubic
+	 *          ⎨1.5 * cwnd      if  W     (t + RTT) > 1.5 * cwnd
+	 * target = ⎪                     cubic
+	 *          ⎪W     (t + RTT) otherwise
+	 *          ⎩ cubic
+	 */
+	if (cwnd_thres < cong->window)
+		target = cong->window;
+	else if (2 * cwnd_thres > 3 * cong->window)
+		target = cong->window * 3 / 2;
+	else
+		target = cwnd_thres;
+
+	/*
+	 * target - cwnd
+	 * ─────────────
+	 *      cwnd
+	 */
+	if (target > cong->window) {
+		m = cubic->pending_add + cong->mss * (target - cong->window);
+		target_add = m / cong->window;
+		cubic->pending_add = m % cong->window;
+	} else {
+		m = cubic->pending_add + cong->mss;
+		target_add = m / (100 * cong->window);
+		cubic->pending_add = m % (100 * cong->window);
+	}
+
+	pr_debug("%s: target: %llu, window: %u, target_add: %u\n",
+		 __func__, target, cong->window, target_add);
+
+	/*
+	 *                        segments_acked
+	 * W    = W    + α      * ──────────────
+	 *  est    est    cubic        cwnd
+	 */
+	m = cubic->pending_w_add + cong->mss * bytes;
+	cubic->w_tcp += m / cong->window;
+	cubic->pending_w_add = m % cong->window;
+
+	if (cubic->w_tcp > cong->window)
+		tcp_add = cong->mss * (cubic->w_tcp - cong->window) / cong->window;
+
+	pr_debug("%s: w_tcp: %u, window: %u, tcp_add: %u\n",
+		 __func__, cubic->w_tcp, cong->window, tcp_add);
+
+	/* W_cubic(_t_) or _W_est_, whichever is bigger */
+	add = max(tcp_add, target_add);
+	cong->window += add;
+}
+
+static void cubic_recovery(struct quic_cong *cong)
+{
+	struct quic_cubic *cubic = quic_cong_priv(cong);
+	u32 min_cwnd;
+
+	cong->recovery_time = cong->time;
+	cubic->epoch_start = U32_MAX;
+	if (cong->window < cubic->w_last_max)
+		cubic->w_last_max = cong->window * 17 / 10 / 2;
+	else
+		cubic->w_last_max = cong->window;
+
+	min_cwnd = 2 * cong->mss;
+	cong->ssthresh = cong->window * 7 / 10;
+	cong->ssthresh = max(cong->ssthresh, min_cwnd);
+	cong->window = cong->ssthresh;
+}
+
+static void quic_cubic_on_packet_lost(struct quic_cong *cong, u32 time, u32 bytes, s64 number)
+{
+	u32 time_ssthresh;
+
+	time_ssthresh = cong->smoothed_rtt + max(4 * cong->rttvar, 1000U);
+	time_ssthresh = (time_ssthresh + cong->max_ack_delay) * 3;
+	if (cong->time - time > time_ssthresh) {
+		/* persistent congestion: cong_avoid -> slow_start or recovery -> slow_start */
+		pr_debug("%s: permanent congestion, cwnd: %u, ssthresh: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		cong->window = cong->mss * 2;
+		cong->state = QUIC_CONG_SLOW_START;
+		return;
+	}
+
+	switch (cong->state) {
+	case QUIC_CONG_SLOW_START:
+		pr_debug("%s: slow_start -> recovery, cwnd: %u, ssthresh: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		break;
+	case QUIC_CONG_RECOVERY_PERIOD:
+		return;
+	case QUIC_CONG_CONGESTION_AVOIDANCE:
+		pr_debug("%s: cong_avoid -> recovery, cwnd: %u, ssthresh: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		break;
+	default:
+		pr_debug("%s: wrong congestion state: %d\n", __func__, cong->state);
+		return;
+	}
+
+	cong->state = QUIC_CONG_RECOVERY_PERIOD;
+	cubic_recovery(cong);
+}
+
+static void quic_cubic_on_packet_acked(struct quic_cong *cong, u32 time, u32 bytes, s64 number)
+{
+	switch (cong->state) {
+	case QUIC_CONG_SLOW_START:
+		cubic_slow_start(cong, bytes, number);
+		if (cong->window >= cong->ssthresh) {
+			cong->state = QUIC_CONG_CONGESTION_AVOIDANCE;
+			pr_debug("%s: slow_start -> cong_avoid, cwnd: %u, ssthresh: %u\n",
+				 __func__, cong->window, cong->ssthresh);
+		}
+		break;
+	case QUIC_CONG_RECOVERY_PERIOD:
+		if (cong->recovery_time < time) {
+			cong->state = QUIC_CONG_CONGESTION_AVOIDANCE;
+			pr_debug("%s: recovery -> cong_avoid, cwnd: %u, ssthresh: %u\n",
+				 __func__, cong->window, cong->ssthresh);
+		}
+		break;
+	case QUIC_CONG_CONGESTION_AVOIDANCE:
+		cubic_cong_avoid(cong, bytes);
+		break;
+	default:
+		pr_debug("%s: wrong congestion state: %d\n", __func__, cong->state);
+		return;
+	}
+}
+
+static void quic_cubic_on_process_ecn(struct quic_cong *cong)
+{
+	switch (cong->state) {
+	case QUIC_CONG_SLOW_START:
+		pr_debug("%s: slow_start -> recovery, cwnd: %u, ssthresh: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		break;
+	case QUIC_CONG_RECOVERY_PERIOD:
+		return;
+	case QUIC_CONG_CONGESTION_AVOIDANCE:
+		pr_debug("%s: cong_avoid -> recovery, cwnd: %u, ssthresh: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		break;
+	default:
+		pr_debug("%s: wrong congestion state: %d\n", __func__, cong->state);
+		return;
+	}
+
+	cong->state = QUIC_CONG_RECOVERY_PERIOD;
+	cubic_recovery(cong);
+}
+
+static void quic_cubic_on_init(struct quic_cong *cong)
+{
+	struct quic_cubic *cubic = quic_cong_priv(cong);
+
+	cubic->epoch_start = U32_MAX;
+	cubic->origin_point = 0;
+	cubic->w_last_max = 0;
+	cubic->w_tcp = 0;
+	cubic->k = 0;
+
+	cubic->current_round_min_rtt = U32_MAX;
+	cubic->css_baseline_min_rtt = U32_MAX;
+	cubic->last_round_min_rtt = U32_MAX;
+	cubic->rtt_sample_count = 0;
+	cubic->window_end = -1;
+	cubic->css_rounds = 0;
+}
+
+static void quic_cubic_on_packet_sent(struct quic_cong *cong, u32 time, u32 bytes, s64 number)
+{
+	struct quic_cubic *cubic = quic_cong_priv(cong);
+
+	if (cubic->window_end != -1)
+		return;
+
+	cubic->window_end = number;
+	cubic->last_round_min_rtt = cubic->current_round_min_rtt;
+	cubic->current_round_min_rtt = U32_MAX;
+	cubic->rtt_sample_count = 0;
+
+	pr_debug("%s: last_round_min_rtt: %u\n", __func__, cubic->last_round_min_rtt);
+}
+
+static void quic_cubic_on_rtt_update(struct quic_cong *cong)
+{
+	struct quic_cubic *cubic = quic_cong_priv(cong);
+
+	if (cubic->window_end == -1)
+		return;
+
+	pr_debug("%s: current_round_min_rtt: %u, latest_rtt: %u\n",
+		 __func__, cubic->current_round_min_rtt, cong->latest_rtt);
+
+	if (cubic->current_round_min_rtt > cong->latest_rtt) {
+		cubic->current_round_min_rtt = cong->latest_rtt;
+		if (cubic->current_round_min_rtt < cubic->css_baseline_min_rtt) {
+			cubic->css_baseline_min_rtt = U32_MAX;
+			cubic->css_rounds = 0;
+		}
+	}
+	cubic->rtt_sample_count++;
+}
+
+/* NEW RENO APIs */
+static void quic_reno_on_packet_lost(struct quic_cong *cong, u32 time, u32 bytes, s64 number)
+{
+	u32 time_ssthresh;
+
+	time_ssthresh = cong->smoothed_rtt + max(4 * cong->rttvar, 1000U);
+	time_ssthresh = (time_ssthresh + cong->max_ack_delay) * 3;
+	if (cong->time - time > time_ssthresh) {
+		/* persistent congestion: cong_avoid -> slow_start or recovery -> slow_start */
+		pr_debug("%s: permanent congestion, cwnd: %u, ssthresh: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		cong->window = cong->mss * 2;
+		cong->state = QUIC_CONG_SLOW_START;
+		return;
+	}
+
+	switch (cong->state) {
+	case QUIC_CONG_SLOW_START:
+		pr_debug("%s: slow_start -> recovery, cwnd: %u, ssthresh: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		break;
+	case QUIC_CONG_RECOVERY_PERIOD:
+		return;
+	case QUIC_CONG_CONGESTION_AVOIDANCE:
+		pr_debug("%s: cong_avoid -> recovery, cwnd: %u, ssthresh: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		break;
+	default:
+		pr_debug("%s: wrong congestion state: %d\n", __func__, cong->state);
+		return;
+	}
+
+	cong->recovery_time = cong->time;
+	cong->state = QUIC_CONG_RECOVERY_PERIOD;
+	cong->ssthresh = max(cong->window >> 1U, cong->mss * 2);
+	cong->window = cong->ssthresh;
+}
+
+static void quic_reno_on_packet_acked(struct quic_cong *cong, u32 time, u32 bytes, s64 number)
+{
+	switch (cong->state) {
+	case QUIC_CONG_SLOW_START:
+		cong->window = min_t(u32, cong->window + bytes, cong->max_window);
+		if (cong->window >= cong->ssthresh) {
+			cong->state = QUIC_CONG_CONGESTION_AVOIDANCE;
+			pr_debug("%s: slow_start -> cong_avoid, cwnd: %u, ssthresh: %u\n",
+				 __func__, cong->window, cong->ssthresh);
+		}
+		break;
+	case QUIC_CONG_RECOVERY_PERIOD:
+		if (cong->recovery_time < time) {
+			cong->state = QUIC_CONG_CONGESTION_AVOIDANCE;
+			pr_debug("%s: recovery -> cong_avoid, cwnd: %u, ssthresh: %u\n",
+				 __func__, cong->window, cong->ssthresh);
+		}
+		break;
+	case QUIC_CONG_CONGESTION_AVOIDANCE:
+		cong->window += cong->mss * bytes / cong->window;
+		break;
+	default:
+		pr_debug("%s: wrong congestion state: %d\n", __func__, cong->state);
+		return;
+	}
+}
+
+static void quic_reno_on_process_ecn(struct quic_cong *cong)
+{
+	switch (cong->state) {
+	case QUIC_CONG_SLOW_START:
+		pr_debug("%s: slow_start -> recovery, cwnd: %u, ssthresh: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		break;
+	case QUIC_CONG_RECOVERY_PERIOD:
+		return;
+	case QUIC_CONG_CONGESTION_AVOIDANCE:
+		pr_debug("%s: cong_avoid -> recovery, cwnd: %u, ssthresh: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		break;
+	default:
+		pr_debug("%s: wrong congestion state: %d\n", __func__, cong->state);
+		return;
+	}
+
+	cong->recovery_time = cong->time;
+	cong->state = QUIC_CONG_RECOVERY_PERIOD;
+	cong->ssthresh = max(cong->window >> 1U, cong->mss * 2);
+	cong->window = cong->ssthresh;
+}
+
+static void quic_reno_on_init(struct quic_cong *cong)
+{
+}
+
+static struct quic_cong_ops quic_congs[] = {
+	{ /* QUIC_CONG_ALG_RENO */
+		.on_packet_acked = quic_reno_on_packet_acked,
+		.on_packet_lost = quic_reno_on_packet_lost,
+		.on_process_ecn = quic_reno_on_process_ecn,
+		.on_init = quic_reno_on_init,
+	},
+	{ /* QUIC_CONG_ALG_CUBIC */
+		.on_packet_acked = quic_cubic_on_packet_acked,
+		.on_packet_lost = quic_cubic_on_packet_lost,
+		.on_process_ecn = quic_cubic_on_process_ecn,
+		.on_init = quic_cubic_on_init,
+		.on_packet_sent = quic_cubic_on_packet_sent,
+		.on_rtt_update = quic_cubic_on_rtt_update,
+	},
+};
+
+/* COMMON APIs */
+void quic_cong_on_packet_lost(struct quic_cong *cong, u32 time, u32 bytes, s64 number)
+{
+	cong->ops->on_packet_lost(cong, time, bytes, number);
+}
+EXPORT_SYMBOL_GPL(quic_cong_on_packet_lost);
+
+void quic_cong_on_packet_acked(struct quic_cong *cong, u32 time, u32 bytes, s64 number)
+{
+	cong->ops->on_packet_acked(cong, time, bytes, number);
+}
+EXPORT_SYMBOL_GPL(quic_cong_on_packet_acked);
+
+void quic_cong_on_process_ecn(struct quic_cong *cong)
+{
+	cong->ops->on_process_ecn(cong);
+}
+EXPORT_SYMBOL_GPL(quic_cong_on_process_ecn);
+
+static void quic_cong_rto_update(struct quic_cong *cong)
+{
+	u32 rto, duration;
+
+	rto = cong->smoothed_rtt + cong->rttvar;
+
+	if (rto < QUIC_RTO_MIN)
+		rto = QUIC_RTO_MIN;
+	else if (rto > QUIC_RTO_MAX)
+		rto = QUIC_RTO_MAX;
+	cong->rto = rto;
+
+	duration = cong->rttvar * 4;
+	if (duration < QUIC_RTO_MIN)
+		duration = QUIC_RTO_MIN;
+	duration += cong->smoothed_rtt;
+	cong->duration = duration;
+
+	pr_debug("%s: update rto: %u, duration: %u\n", __func__, rto, duration);
+}
+
+void quic_cong_set_config(struct quic_cong *cong, struct quic_config *c)
+{
+	u8 algo = QUIC_CONG_ALG_RENO;
+
+	if (c->congestion_control_algo < QUIC_CONG_ALG_MAX)
+		algo = c->congestion_control_algo;
+
+	cong->latest_rtt = c->initial_smoothed_rtt;
+	cong->smoothed_rtt = cong->latest_rtt;
+	cong->rttvar = cong->smoothed_rtt / 2;
+	quic_cong_rto_update(cong);
+
+	cong->state = QUIC_CONG_SLOW_START;
+	cong->ssthresh = U32_MAX;
+	cong->ops = &quic_congs[algo];
+	cong->ops->on_init(cong);
+}
+EXPORT_SYMBOL_GPL(quic_cong_set_config);
+
+void quic_cong_set_param(struct quic_cong *cong, struct quic_transport_param *p)
+{
+	cong->max_window = p->max_data;
+	cong->max_ack_delay = p->max_ack_delay;
+	cong->ack_delay_exponent = p->ack_delay_exponent;
+}
+EXPORT_SYMBOL_GPL(quic_cong_set_param);
+
+static void quic_cong_update_pacing_time(struct quic_cong *cong, u16 bytes)
+{
+	unsigned long rate = READ_ONCE(cong->pacing_rate);
+	u64 prior_time, credit, len_ns;
+
+	if (!rate)
+		return;
+
+	prior_time = cong->pacing_time;
+	cong->pacing_time = max(cong->pacing_time, ktime_get_ns());
+	credit = cong->pacing_time - prior_time;
+
+	/* take into account OS jitter */
+	len_ns = div64_ul((u64)bytes * NSEC_PER_SEC, rate);
+	len_ns -= min_t(u64, len_ns / 2, credit);
+	cong->pacing_time += len_ns;
+}
+
+static void quic_cong_pace_update(struct quic_cong *cong, u32 bytes, u32 max_rate)
+{
+	u64 rate;
+
+	/* rate = N * congestion_window / smoothed_rtt */
+	rate = 2 * cong->window * USEC_PER_SEC;
+	if (likely(cong->smoothed_rtt))
+		do_div(rate, cong->smoothed_rtt);
+
+	WRITE_ONCE(cong->pacing_rate, min_t(u64, rate, max_rate));
+	pr_debug("%s: update pacing rate: %u, max rate: %u, srtt: %u\n",
+		 __func__, cong->pacing_rate, max_rate, cong->smoothed_rtt);
+}
+
+void quic_cong_on_packet_sent(struct quic_cong *cong, u32 time, u32 bytes, s64 number)
+{
+	if (!bytes)
+		return;
+	if (cong->ops->on_packet_sent)
+		cong->ops->on_packet_sent(cong, time, bytes, number);
+	quic_cong_update_pacing_time(cong, bytes);
+}
+EXPORT_SYMBOL_GPL(quic_cong_on_packet_sent);
+
+void quic_cong_on_ack_recv(struct quic_cong *cong, u32 bytes, u32 max_rate)
+{
+	if (!bytes)
+		return;
+	if (cong->ops->on_ack_recv)
+		cong->ops->on_ack_recv(cong, bytes, max_rate);
+	quic_cong_pace_update(cong, bytes, max_rate);
+}
+EXPORT_SYMBOL_GPL(quic_cong_on_ack_recv);
+
+/* Estimating the Round-Trip Time */
+void quic_cong_rtt_update(struct quic_cong *cong, u32 time, u32 ack_delay)
+{
+	u32 adjusted_rtt, rttvar_sample;
+
+	ack_delay = ack_delay * BIT(cong->ack_delay_exponent);
+	ack_delay = min(ack_delay, cong->max_ack_delay);
+
+	cong->latest_rtt = cong->time - time;
+
+	if (!cong->min_rtt)
+		cong->min_rtt = cong->latest_rtt;
+
+	if (cong->min_rtt > cong->latest_rtt)
+		cong->min_rtt = cong->latest_rtt;
+
+	adjusted_rtt = cong->latest_rtt;
+	if (cong->latest_rtt >= cong->min_rtt + ack_delay)
+		adjusted_rtt = cong->latest_rtt - ack_delay;
+
+	cong->smoothed_rtt = (cong->smoothed_rtt * 7 + adjusted_rtt) / 8;
+	rttvar_sample = abs(cong->smoothed_rtt - adjusted_rtt);
+	cong->rttvar = (cong->rttvar * 3 + rttvar_sample) / 4;
+	quic_cong_rto_update(cong);
+
+	if (cong->ops->on_rtt_update)
+		cong->ops->on_rtt_update(cong);
+}
+EXPORT_SYMBOL_GPL(quic_cong_rtt_update);
diff --git a/net/quic/cong.h b/net/quic/cong.h
new file mode 100644
index 000000000000..13b1489971e3
--- /dev/null
+++ b/net/quic/cong.h
@@ -0,0 +1,118 @@
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
+#define QUIC_RTT_INIT		333000
+#define QUIC_RTO_MIN		100000
+#define QUIC_RTO_MAX		6000000
+
+enum quic_cong_state {
+	QUIC_CONG_SLOW_START,
+	QUIC_CONG_RECOVERY_PERIOD,
+	QUIC_CONG_CONGESTION_AVOIDANCE,
+};
+
+struct quic_cong {
+	u32 smoothed_rtt;
+	u32 latest_rtt;
+	u32 duration;
+	u32 min_rtt;
+	u32 rttvar;
+	u32 rto;
+
+	u32 ack_delay_exponent;
+	u32 recovery_time;
+	u32 max_ack_delay;
+	u32 pacing_rate;
+	u64 pacing_time; /* planned time to send next packet */
+	u32 time; /* current time cache */
+
+	u32 max_window;
+	u32 ssthresh;
+	u32 window;
+	u32 mss;
+
+	struct quic_cong_ops *ops;
+	u64 priv[8];
+	u8 state;
+};
+
+struct quic_cong_ops {
+	/* required */
+	void (*on_packet_acked)(struct quic_cong *cong, u32 time, u32 bytes, s64 number);
+	void (*on_packet_lost)(struct quic_cong *cong, u32 time, u32 bytes, s64 number);
+	void (*on_process_ecn)(struct quic_cong *cong);
+	void (*on_init)(struct quic_cong *cong);
+
+	/* optional */
+	void (*on_packet_sent)(struct quic_cong *cong, u32 time, u32 bytes, s64 number);
+	void (*on_ack_recv)(struct quic_cong *cong, u32 bytes, u32 max_rate);
+	void (*on_rtt_update)(struct quic_cong *cong);
+};
+
+static inline void quic_cong_set_time(struct quic_cong *cong, u32 time)
+{
+	cong->time = time;
+}
+
+static inline void quic_cong_set_window(struct quic_cong *cong, u32 window)
+{
+	cong->window = window;
+}
+
+static inline void quic_cong_set_mss(struct quic_cong *cong, u32 mss)
+{
+	cong->mss = mss;
+}
+
+static inline void *quic_cong_priv(struct quic_cong *cong)
+{
+	return (void *)cong->priv;
+}
+
+static inline u32 quic_cong_time(struct quic_cong *cong)
+{
+	return cong->time;
+}
+
+static inline u32 quic_cong_window(struct quic_cong *cong)
+{
+	return cong->window;
+}
+
+static inline u32 quic_cong_rto(struct quic_cong *cong)
+{
+	return cong->rto;
+}
+
+static inline u32 quic_cong_duration(struct quic_cong *cong)
+{
+	return cong->duration;
+}
+
+static inline u32 quic_cong_latest_rtt(struct quic_cong *cong)
+{
+	return cong->latest_rtt;
+}
+
+static inline u64 quic_cong_pacing_time(struct quic_cong *cong)
+{
+	return cong->pacing_time;
+}
+
+void quic_cong_set_param(struct quic_cong *cong, struct quic_transport_param *p);
+void quic_cong_set_config(struct quic_cong *cong, struct quic_config *c);
+
+void quic_cong_on_packet_acked(struct quic_cong *cong, u32 time, u32 bytes, s64 number);
+void quic_cong_on_packet_lost(struct quic_cong *cong, u32 time, u32 bytes, s64 number);
+void quic_cong_on_process_ecn(struct quic_cong *cong);
+
+void quic_cong_on_packet_sent(struct quic_cong *cong, u32 time, u32 bytes, s64 number);
+void quic_cong_on_ack_recv(struct quic_cong *cong, u32 bytes, u32 max_rate);
+void quic_cong_rtt_update(struct quic_cong *cong, u32 time, u32 ack_delay);
diff --git a/net/quic/connid.c b/net/quic/connid.c
new file mode 100644
index 000000000000..7c80e7b35c9c
--- /dev/null
+++ b/net/quic/connid.c
@@ -0,0 +1,188 @@
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
+#include <uapi/linux/quic.h>
+#include <net/netns/hash.h>
+#include <linux/jhash.h>
+#include <net/sock.h>
+
+#include "hashtable.h"
+#include "connid.h"
+
+struct quic_conn_id *quic_conn_id_lookup(struct net *net, u8 *scid, u32 len)
+{
+	struct quic_hash_head *head = quic_source_conn_id_head(net, scid);
+	struct quic_source_conn_id *tmp, *s_conn_id = NULL;
+
+	spin_lock(&head->lock);
+	hlist_for_each_entry(tmp, &head->head, node) {
+		if (net == sock_net(tmp->sk) && tmp->common.id.len <= len &&
+		    !memcmp(scid, &tmp->common.id.data, tmp->common.id.len)) {
+			s_conn_id = tmp;
+			break;
+		}
+	}
+
+	spin_unlock(&head->lock);
+	return &s_conn_id->common.id;
+}
+
+bool quic_conn_id_token_exists(struct quic_conn_id_set *id_set, u8 *token)
+{
+	struct quic_common_conn_id *common;
+	struct quic_dest_conn_id *dcid;
+
+	dcid = (struct quic_dest_conn_id *)id_set->active;
+	if (!memcmp(dcid->token, token, 16)) /* fast path */
+		return true;
+
+	list_for_each_entry(common, &id_set->head, list) {
+		dcid = (struct quic_dest_conn_id *)common;
+		if (common == id_set->active)
+			continue;
+		if (!memcmp(dcid->token, token, 16))
+			return true;
+	}
+	return false;
+}
+
+static void quic_source_conn_id_free_rcu(struct rcu_head *head)
+{
+	struct quic_source_conn_id *s_conn_id;
+
+	s_conn_id = container_of(head, struct quic_source_conn_id, rcu);
+	kfree(s_conn_id);
+}
+
+static void quic_source_conn_id_free(struct quic_source_conn_id *s_conn_id)
+{
+	u8 *data = s_conn_id->common.id.data;
+	struct quic_hash_head *head;
+
+	if (!hlist_unhashed(&s_conn_id->node)) {
+		head = quic_source_conn_id_head(sock_net(s_conn_id->sk), data);
+		spin_lock(&head->lock);
+		hlist_del_init(&s_conn_id->node);
+		spin_unlock(&head->lock);
+	}
+
+	call_rcu(&s_conn_id->rcu, quic_source_conn_id_free_rcu);
+}
+
+static void quic_conn_id_del(struct quic_common_conn_id *common)
+{
+	list_del(&common->list);
+	if (!common->hashed) {
+		kfree(common);
+		return;
+	}
+	quic_source_conn_id_free((struct quic_source_conn_id *)common);
+}
+
+int quic_conn_id_add(struct quic_conn_id_set *id_set,
+		     struct quic_conn_id *conn_id, u32 number, void *data)
+{
+	struct quic_source_conn_id *s_conn_id;
+	struct quic_dest_conn_id *d_conn_id;
+	struct quic_common_conn_id *common;
+	struct quic_hash_head *head;
+	struct list_head *list;
+
+	/* find the position */
+	list = &id_set->head;
+	list_for_each_entry(common, list, list) {
+		if (number == common->number)
+			return 0;
+		if (number < common->number) {
+			list = &common->list;
+			break;
+		}
+	}
+
+	/* create and insert the node */
+	if (conn_id->len > QUIC_CONN_ID_MAX_LEN)
+		return -EINVAL;
+	common = kzalloc(id_set->entry_size, GFP_ATOMIC);
+	if (!common)
+		return -ENOMEM;
+	common->id = *conn_id;
+	common->number = number;
+	if (id_set->entry_size == sizeof(struct quic_dest_conn_id)) {
+		if (data) {
+			d_conn_id = (struct quic_dest_conn_id *)common;
+			memcpy(d_conn_id->token, data, 16);
+		}
+	} else {
+		common->hashed = 1;
+		s_conn_id = (struct quic_source_conn_id *)common;
+		s_conn_id->sk = data;
+
+		head = quic_source_conn_id_head(sock_net(s_conn_id->sk), common->id.data);
+		spin_lock(&head->lock);
+		hlist_add_head(&s_conn_id->node, &head->head);
+		spin_unlock(&head->lock);
+	}
+	list_add_tail(&common->list, list);
+
+	/* increase count with the out-of-order node considered */
+	if (number == quic_conn_id_last_number(id_set) + 1) {
+		if (!id_set->active)
+			id_set->active = common;
+		id_set->count++;
+
+		list_for_each_entry_continue(common, &id_set->head, list) {
+			if (common->number != ++number)
+				break;
+			id_set->count++;
+		}
+	}
+	return 0;
+}
+
+void quic_conn_id_remove(struct quic_conn_id_set *id_set, u32 number)
+{
+	struct quic_common_conn_id *common, *tmp;
+	struct list_head *list;
+
+	list = &id_set->head;
+	list_for_each_entry_safe(common, tmp, list, list) {
+		if (common->number <= number) {
+			quic_conn_id_del(common);
+			id_set->count--;
+		}
+	}
+
+	id_set->active = list_first_entry(list, struct quic_common_conn_id, list);
+}
+
+void quic_conn_id_set_init(struct quic_conn_id_set *id_set, bool source)
+{
+	id_set->entry_size = source ? sizeof(struct quic_source_conn_id)
+				    : sizeof(struct quic_dest_conn_id);
+	INIT_LIST_HEAD(&id_set->head);
+}
+
+void quic_conn_id_set_free(struct quic_conn_id_set *id_set)
+{
+	struct quic_common_conn_id *common, *tmp;
+
+	list_for_each_entry_safe(common, tmp, &id_set->head, list)
+		quic_conn_id_del(common);
+	id_set->count = 0;
+	id_set->active = NULL;
+}
+
+void quic_conn_id_set_param(struct quic_conn_id_set *id_set, struct quic_transport_param *p)
+{
+	id_set->max_count = p->active_connection_id_limit;
+	id_set->disable_active_migration = p->disable_active_migration;
+}
diff --git a/net/quic/connid.h b/net/quic/connid.h
new file mode 100644
index 000000000000..d2264b936775
--- /dev/null
+++ b/net/quic/connid.h
@@ -0,0 +1,120 @@
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
+#define QUIC_CONN_ID_MAX_LEN	20
+#define QUIC_CONN_ID_DEF_LEN	8
+
+#define QUIC_CONN_ID_LIMIT	7
+#define QUIC_CONN_ID_LEAST	2
+
+struct quic_conn_id {
+	u8 data[QUIC_CONN_ID_MAX_LEN];
+	u8 len;
+};
+
+struct quic_common_conn_id {
+	struct quic_conn_id id;
+	struct list_head list;
+	u32 number;
+	u8 hashed;
+};
+
+struct quic_source_conn_id {
+	struct quic_common_conn_id common;
+	struct hlist_node node;
+	struct rcu_head rcu;
+	struct sock *sk;
+};
+
+struct quic_dest_conn_id {
+	struct quic_common_conn_id common;
+	u8 token[16];
+};
+
+struct quic_conn_id_set {
+	struct quic_common_conn_id *active;
+	struct list_head head;
+	u32 entry_size;
+	u32 max_count;
+	u32 count;
+
+	u8 disable_active_migration;
+	u8 pending;
+};
+
+static inline u32 quic_conn_id_first_number(struct quic_conn_id_set *id_set)
+{
+	struct quic_common_conn_id *common;
+
+	common = list_first_entry(&id_set->head, struct quic_common_conn_id, list);
+	return common->number;
+}
+
+static inline u32 quic_conn_id_last_number(struct quic_conn_id_set *id_set)
+{
+	return quic_conn_id_first_number(id_set) + id_set->count - 1;
+}
+
+static inline void quic_conn_id_generate(struct quic_conn_id *conn_id)
+{
+	get_random_bytes(conn_id->data, QUIC_CONN_ID_DEF_LEN);
+	conn_id->len = QUIC_CONN_ID_DEF_LEN;
+}
+
+static inline void quic_conn_id_update(struct quic_conn_id *conn_id, u8 *data, u32 len)
+{
+	memcpy(conn_id->data, data, len);
+	conn_id->len = len;
+}
+
+static inline u8 quic_conn_id_disable_active_migration(struct quic_conn_id_set *id_set)
+{
+	return id_set->disable_active_migration;
+}
+
+static inline u32 quic_conn_id_max_count(struct quic_conn_id_set *id_set)
+{
+	return id_set->max_count;
+}
+
+static inline struct quic_conn_id *quic_conn_id_active(struct quic_conn_id_set *id_set)
+{
+	return &id_set->active->id;
+}
+
+static inline u32 quic_conn_id_number(struct quic_conn_id *conn_id)
+{
+	return ((struct quic_common_conn_id *)conn_id)->number;
+}
+
+static inline struct sock *quic_conn_id_sk(struct quic_conn_id *conn_id)
+{
+	return ((struct quic_source_conn_id *)conn_id)->sk;
+}
+
+static inline void quic_conn_id_set_token(struct quic_conn_id *conn_id, u8 *token)
+{
+	memcpy(((struct quic_dest_conn_id *)conn_id)->token, token, 16);
+}
+
+static inline int quic_conn_id_cmp(struct quic_conn_id *a, struct quic_conn_id *b)
+{
+	return a->len != b->len || memcmp(a->data, b->data, a->len);
+}
+
+int quic_conn_id_add(struct quic_conn_id_set *id_set, struct quic_conn_id *conn_id,
+		     u32 number, void *data);
+struct quic_conn_id *quic_conn_id_lookup(struct net *net, u8 *scid, u32 len);
+bool quic_conn_id_token_exists(struct quic_conn_id_set *id_set, u8 *token);
+void quic_conn_id_remove(struct quic_conn_id_set *id_set, u32 number);
+
+void quic_conn_id_set_param(struct quic_conn_id_set *id_set, struct quic_transport_param *p);
+void quic_conn_id_set_init(struct quic_conn_id_set *id_set, bool source);
+void quic_conn_id_set_free(struct quic_conn_id_set *id_set);
diff --git a/net/quic/crypto.c b/net/quic/crypto.c
new file mode 100644
index 000000000000..fd8ebf41a93d
--- /dev/null
+++ b/net/quic/crypto.c
@@ -0,0 +1,996 @@
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
+#include <uapi/linux/quic.h>
+#include <crypto/skcipher.h>
+#include <net/netns/hash.h>
+#include <net/udp_tunnel.h>
+#include <linux/skbuff.h>
+#include <linux/jhash.h>
+#include <crypto/aead.h>
+#include <crypto/hash.h>
+#include <net/tls.h>
+
+#include "hashtable.h"
+#include "protocol.h"
+#include "number.h"
+#include "connid.h"
+#include "stream.h"
+#include "crypto.h"
+#include "frame.h"
+
+static int quic_crypto_hkdf_extract(struct crypto_shash *tfm, struct quic_data *srt,
+				    struct quic_data *hash, struct quic_data *key)
+{
+	int err;
+
+	err = crypto_shash_setkey(tfm, srt->data, srt->len);
+	if (err)
+		return err;
+
+	return crypto_shash_tfm_digest(tfm, hash->data, hash->len, key->data);
+}
+
+static int quic_crypto_hkdf_expand(struct crypto_shash *tfm, struct quic_data *srt,
+				   struct quic_data *label, struct quic_data *hash,
+				   struct quic_data *key)
+{
+	u8 cnt = 1, info[256], *p = info, *prev = NULL;
+	u8 LABEL[] = "tls13 ", tmp[48];
+	SHASH_DESC_ON_STACK(desc, tfm);
+	int err, i, infolen;
+
+	*p++ = (u8)(key->len / 256);
+	*p++ = (u8)(key->len % 256);
+	*p++ = (u8)(sizeof(LABEL) - 1 + label->len);
+	memcpy(p, LABEL, sizeof(LABEL) - 1);
+	p += sizeof(LABEL) - 1;
+	memcpy(p, label->data, label->len);
+	p += label->len;
+	if (hash) {
+		*p++ = hash->len;
+		memcpy(p, hash->data, hash->len);
+		p += hash->len;
+	} else {
+		*p++ = 0;
+	}
+	infolen = (int)(p - info);
+
+	desc->tfm = tfm;
+	err = crypto_shash_setkey(tfm, srt->data, srt->len);
+	if (err)
+		return err;
+	for (i = 0; i < key->len; i += srt->len) {
+		err = crypto_shash_init(desc);
+		if (err)
+			goto out;
+		if (prev) {
+			err = crypto_shash_update(desc, prev, srt->len);
+			if (err)
+				goto out;
+		}
+		err = crypto_shash_update(desc, info, infolen);
+		if (err)
+			goto out;
+		BUILD_BUG_ON(sizeof(cnt) != 1);
+		if (key->len - i < srt->len) {
+			err = crypto_shash_finup(desc, &cnt, 1, tmp);
+			if (err)
+				goto out;
+			memcpy(&key->data[i], tmp, key->len - i);
+			memzero_explicit(tmp, sizeof(tmp));
+		} else {
+			err = crypto_shash_finup(desc, &cnt, 1, &key->data[i]);
+			if (err)
+				goto out;
+		}
+		cnt++;
+		prev = &key->data[i];
+	}
+out:
+	shash_desc_zero(desc);
+	return err;
+}
+
+#define KEY_LABEL_V1		"quic key"
+#define IV_LABEL_V1		"quic iv"
+#define HP_KEY_LABEL_V1		"quic hp"
+
+#define KEY_LABEL_V2		"quicv2 key"
+#define IV_LABEL_V2		"quicv2 iv"
+#define HP_KEY_LABEL_V2		"quicv2 hp"
+
+static int quic_crypto_keys_derive(struct crypto_shash *tfm, struct quic_data *s,
+				   struct quic_data *k, struct quic_data *i,
+				   struct quic_data *hp_k, u32 version)
+{
+	struct quic_data hp_k_l = {HP_KEY_LABEL_V1, 7}, k_l = {KEY_LABEL_V1, 8};
+	struct quic_data i_l = {IV_LABEL_V1, 7};
+	struct quic_data z = {};
+	int err;
+
+	if (version == QUIC_VERSION_V2) {
+		quic_data(&hp_k_l, HP_KEY_LABEL_V2, 9);
+		quic_data(&k_l, KEY_LABEL_V2, 10);
+		quic_data(&i_l, IV_LABEL_V2, 9);
+	}
+
+	err = quic_crypto_hkdf_expand(tfm, s, &k_l, &z, k);
+	if (err)
+		return err;
+	err = quic_crypto_hkdf_expand(tfm, s, &i_l, &z, i);
+	if (err)
+		return err;
+	/* Don't change hp key for key update */
+	if (!hp_k)
+		return 0;
+
+	return quic_crypto_hkdf_expand(tfm, s, &hp_k_l, &z, hp_k);
+}
+
+static int quic_crypto_tx_keys_derive_and_install(struct quic_crypto *crypto)
+{
+	struct quic_data srt = {}, k, iv, hp_k = {}, *hp = NULL;
+	int err, phase = crypto->key_phase;
+	u32 keylen, ivlen = QUIC_IV_LEN;
+	u8 tx_key[32], tx_hp_key[32];
+
+	keylen = crypto->cipher->keylen;
+	quic_data(&srt, crypto->tx_secret, crypto->cipher->secretlen);
+	quic_data(&k, tx_key, keylen);
+	quic_data(&iv, crypto->tx_iv[phase], ivlen);
+	if (!crypto->key_pending)
+		hp = quic_data(&hp_k, tx_hp_key, keylen);
+	err = quic_crypto_keys_derive(crypto->secret_tfm, &srt, &k, &iv, hp, crypto->version);
+	if (err)
+		return err;
+	err = crypto_aead_setauthsize(crypto->tx_tfm[phase], QUIC_TAG_LEN);
+	if (err)
+		return err;
+	err = crypto_aead_setkey(crypto->tx_tfm[phase], tx_key, keylen);
+	if (err)
+		return err;
+	if (hp) {
+		err = crypto_skcipher_setkey(crypto->tx_hp_tfm, tx_hp_key, keylen);
+		if (err)
+			return err;
+	}
+	pr_debug("%s: k: %16phN, iv: %12phN, hp_k:%16phN\n", __func__, k.data, iv.data, hp_k.data);
+	return 0;
+}
+
+static int quic_crypto_rx_keys_derive_and_install(struct quic_crypto *crypto)
+{
+	struct quic_data srt = {}, k, iv, hp_k = {}, *hp = NULL;
+	int err, phase = crypto->key_phase;
+	u32 keylen, ivlen = QUIC_IV_LEN;
+	u8 rx_key[32], rx_hp_key[32];
+
+	keylen = crypto->cipher->keylen;
+	quic_data(&srt, crypto->rx_secret, crypto->cipher->secretlen);
+	quic_data(&k, rx_key, keylen);
+	quic_data(&iv, crypto->rx_iv[phase], ivlen);
+	if (!crypto->key_pending)
+		hp = quic_data(&hp_k, rx_hp_key, keylen);
+	err = quic_crypto_keys_derive(crypto->secret_tfm, &srt, &k, &iv, hp, crypto->version);
+	if (err)
+		return err;
+	err = crypto_aead_setauthsize(crypto->rx_tfm[phase], QUIC_TAG_LEN);
+	if (err)
+		return err;
+	err = crypto_aead_setkey(crypto->rx_tfm[phase], rx_key, keylen);
+	if (err)
+		return err;
+	if (hp) {
+		err = crypto_skcipher_setkey(crypto->rx_hp_tfm, rx_hp_key, keylen);
+		if (err)
+			return err;
+	}
+	pr_debug("%s: k: %16phN, iv: %12phN, hp_k:%16phN\n", __func__, k.data, iv.data, hp_k.data);
+	return 0;
+}
+
+static void *quic_crypto_skcipher_mem_alloc(struct crypto_skcipher *tfm, u32 mask_size,
+					    u8 **iv, struct skcipher_request **req)
+{
+	unsigned int iv_size, req_size;
+	unsigned int len;
+	u8 *mem;
+
+	iv_size = crypto_skcipher_ivsize(tfm);
+	req_size = sizeof(**req) + crypto_skcipher_reqsize(tfm);
+
+	len = mask_size;
+	len += iv_size;
+	len += crypto_skcipher_alignmask(tfm) & ~(crypto_tfm_ctx_alignment() - 1);
+	len = ALIGN(len, crypto_tfm_ctx_alignment());
+	len += req_size;
+
+	mem = kzalloc(len, GFP_ATOMIC);
+	if (!mem)
+		return NULL;
+
+	*iv = (u8 *)PTR_ALIGN(mem + mask_size, crypto_skcipher_alignmask(tfm) + 1);
+	*req = (struct skcipher_request *)PTR_ALIGN(*iv + iv_size,
+			crypto_tfm_ctx_alignment());
+
+	return (void *)mem;
+}
+
+static int quic_crypto_header_encrypt(struct crypto_skcipher *tfm, struct sk_buff *skb, bool chacha)
+{
+	struct quic_crypto_cb *cb = QUIC_CRYPTO_CB(skb);
+	struct skcipher_request *req;
+	struct scatterlist sg;
+	u8 *mask, *iv, *p;
+	int err, i;
+
+	mask = quic_crypto_skcipher_mem_alloc(tfm, 16, &iv, &req);
+	if (!mask)
+		return -ENOMEM;
+
+	memcpy((chacha ? iv : mask), skb->data + cb->number_offset + 4, 16);
+	sg_init_one(&sg, mask, 16);
+	skcipher_request_set_tfm(req, tfm);
+	skcipher_request_set_crypt(req, &sg, &sg, 16, iv);
+	err = crypto_skcipher_encrypt(req);
+	if (err)
+		goto err;
+
+	p = skb->data;
+	*p = (u8)(*p ^ (mask[0] & (((*p & 0x80) == 0x80) ? 0x0f : 0x1f)));
+	p = skb->data + cb->number_offset;
+	for (i = 1; i <= cb->number_len; i++)
+		*p++ ^= mask[i];
+err:
+	kfree(mask);
+	return err;
+}
+
+static void *quic_crypto_aead_mem_alloc(struct crypto_aead *tfm, u32 ctx_size,
+					u8 **iv, struct aead_request **req,
+					struct scatterlist **sg, int nsg)
+{
+	unsigned int iv_size, req_size;
+	unsigned int len;
+	u8 *mem;
+
+	iv_size = crypto_aead_ivsize(tfm);
+	req_size = sizeof(**req) + crypto_aead_reqsize(tfm);
+
+	len = ctx_size;
+	len += iv_size;
+	len += crypto_aead_alignmask(tfm) & ~(crypto_tfm_ctx_alignment() - 1);
+	len = ALIGN(len, crypto_tfm_ctx_alignment());
+	len += req_size;
+	len = ALIGN(len, __alignof__(struct scatterlist));
+	len += nsg * sizeof(**sg);
+
+	mem = kzalloc(len, GFP_ATOMIC);
+	if (!mem)
+		return NULL;
+
+	*iv = (u8 *)PTR_ALIGN(mem + ctx_size, crypto_aead_alignmask(tfm) + 1);
+	*req = (struct aead_request *)PTR_ALIGN(*iv + iv_size,
+			crypto_tfm_ctx_alignment());
+	*sg = (struct scatterlist *)PTR_ALIGN((u8 *)*req + req_size,
+			__alignof__(struct scatterlist));
+
+	return (void *)mem;
+}
+
+static void quic_crypto_destruct_skb(struct sk_buff *skb)
+{
+	kfree(skb_shinfo(skb)->destructor_arg);
+	sock_efree(skb);
+}
+
+static void quic_crypto_done(void *data, int err)
+{
+	struct sk_buff *skb = data;
+
+	QUIC_CRYPTO_CB(skb)->crypto_done(skb, err);
+}
+
+static int quic_crypto_payload_encrypt(struct crypto_aead *tfm, struct sk_buff *skb,
+				       u8 *tx_iv, bool ccm)
+{
+	struct quic_crypto_cb *cb = QUIC_CRYPTO_CB(skb);
+	struct quichdr *hdr = quic_hdr(skb);
+	u8 *iv, i, nonce[QUIC_IV_LEN];
+	struct aead_request *req;
+	struct sk_buff *trailer;
+	int nsg, err, hlen, len;
+	struct scatterlist *sg;
+	void *ctx;
+	__be64 n;
+
+	len = skb->len;
+	nsg = skb_cow_data(skb, QUIC_TAG_LEN, &trailer);
+	if (nsg < 0)
+		return nsg;
+	pskb_put(skb, trailer, QUIC_TAG_LEN);
+	hdr->key = cb->key_phase;
+
+	ctx = quic_crypto_aead_mem_alloc(tfm, 0, &iv, &req, &sg, nsg);
+	if (!ctx)
+		return -ENOMEM;
+
+	sg_init_table(sg, nsg);
+	err = skb_to_sgvec(skb, sg, 0, skb->len);
+	if (err < 0)
+		goto err;
+
+	hlen = cb->number_offset + cb->number_len;
+	memcpy(nonce, tx_iv, QUIC_IV_LEN);
+	n = cpu_to_be64(cb->number);
+	for (i = 0; i < 8; i++)
+		nonce[QUIC_IV_LEN - 8 + i] ^= ((u8 *)&n)[i];
+
+	iv[0] = TLS_AES_CCM_IV_B0_BYTE;
+	memcpy(&iv[ccm], nonce, QUIC_IV_LEN);
+	aead_request_set_tfm(req, tfm);
+	aead_request_set_ad(req, hlen);
+	aead_request_set_crypt(req, sg, sg, len - hlen, iv);
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG, (void *)quic_crypto_done, skb);
+
+	err = crypto_aead_encrypt(req);
+	if (err == -EINPROGRESS) {
+		skb->destructor = quic_crypto_destruct_skb;
+		skb_shinfo(skb)->destructor_arg = ctx;
+		return err;
+	}
+
+err:
+	kfree(ctx);
+	return err;
+}
+
+static int quic_crypto_payload_decrypt(struct crypto_aead *tfm, struct sk_buff *skb,
+				       u8 *rx_iv, bool ccm)
+{
+	struct quic_crypto_cb *cb = QUIC_CRYPTO_CB(skb);
+	u8 *iv, i, nonce[QUIC_IV_LEN];
+	struct aead_request *req;
+	struct sk_buff *trailer;
+	int nsg, hlen, len, err;
+	struct scatterlist *sg;
+	void *ctx;
+	__be64 n;
+
+	len = cb->length + cb->number_offset;
+	hlen = cb->number_offset + cb->number_len;
+	if (len - hlen < QUIC_TAG_LEN)
+		return -EINVAL;
+	nsg = skb_cow_data(skb, 0, &trailer);
+	if (nsg < 0)
+		return nsg;
+	ctx = quic_crypto_aead_mem_alloc(tfm, 0, &iv, &req, &sg, nsg);
+	if (!ctx)
+		return -ENOMEM;
+
+	sg_init_table(sg, nsg);
+	err = skb_to_sgvec(skb, sg, 0, len);
+	if (err < 0)
+		goto err;
+	skb_dst_force(skb);
+
+	memcpy(nonce, rx_iv, QUIC_IV_LEN);
+	n = cpu_to_be64(cb->number);
+	for (i = 0; i < 8; i++)
+		nonce[QUIC_IV_LEN - 8 + i] ^= ((u8 *)&n)[i];
+
+	iv[0] = TLS_AES_CCM_IV_B0_BYTE;
+	memcpy(&iv[ccm], nonce, QUIC_IV_LEN);
+	aead_request_set_tfm(req, tfm);
+	aead_request_set_ad(req, hlen);
+	aead_request_set_crypt(req, sg, sg, len - hlen, iv);
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG, (void *)quic_crypto_done, skb);
+
+	err = crypto_aead_decrypt(req);
+	if (err == -EINPROGRESS) {
+		skb->destructor = quic_crypto_destruct_skb;
+		skb_shinfo(skb)->destructor_arg = ctx;
+		return err;
+	}
+err:
+	kfree(ctx);
+	return err;
+}
+
+static void quic_crypto_get_header(struct sk_buff *skb)
+{
+	struct quic_crypto_cb *cb = QUIC_CRYPTO_CB(skb);
+	struct quichdr *hdr = quic_hdr(skb);
+	u8 *p = (u8 *)hdr;
+	u32 len = 4;
+
+	p += cb->number_offset;
+	cb->key_phase = hdr->key;
+	cb->number_len = hdr->pnl + 1;
+	quic_get_int(&p, &len, &cb->number, cb->number_len);
+	cb->number = quic_get_num(cb->number_max, cb->number, cb->number_len);
+}
+
+static int quic_crypto_header_decrypt(struct crypto_skcipher *tfm, struct sk_buff *skb, bool chacha)
+{
+	struct quic_crypto_cb *cb = QUIC_CRYPTO_CB(skb);
+	struct quichdr *hdr = quic_hdr(skb);
+	int err, i, len = cb->length;
+	struct skcipher_request *req;
+	struct scatterlist sg;
+	u8 *mask, *iv, *p;
+
+	mask = quic_crypto_skcipher_mem_alloc(tfm, 16, &iv, &req);
+	if (!mask)
+		return -ENOMEM;
+
+	if (len < 4 + 16) {
+		err = -EINVAL;
+		goto err;
+	}
+	p = (u8 *)hdr + cb->number_offset;
+	memcpy((chacha ? iv : mask), p + 4, 16);
+	sg_init_one(&sg, mask, 16);
+	skcipher_request_set_tfm(req, tfm);
+	skcipher_request_set_crypt(req, &sg, &sg, 16, iv);
+	err = crypto_skcipher_encrypt(req);
+	if (err)
+		goto err;
+
+	p = (u8 *)hdr;
+	*p = (u8)(*p ^ (mask[0] & (((*p & 0x80) == 0x80) ? 0x0f : 0x1f)));
+	cb->number_len = (*p & 0x03) + 1;
+	p += cb->number_offset;
+	for (i = 0; i < cb->number_len; ++i)
+		*(p + i) = *((u8 *)hdr + cb->number_offset + i) ^ mask[i + 1];
+	quic_crypto_get_header(skb);
+
+err:
+	kfree(mask);
+	return err;
+}
+
+#define QUIC_CIPHER_MIN TLS_CIPHER_AES_GCM_128
+#define QUIC_CIPHER_MAX TLS_CIPHER_CHACHA20_POLY1305
+
+#define TLS_CIPHER_AES_GCM_128_SECRET_SIZE		32
+#define TLS_CIPHER_AES_GCM_256_SECRET_SIZE		48
+#define TLS_CIPHER_AES_CCM_128_SECRET_SIZE		32
+#define TLS_CIPHER_CHACHA20_POLY1305_SECRET_SIZE	32
+
+#define CIPHER_DESC(type, aead_name, skc_name, sha_name)[type - QUIC_CIPHER_MIN] = { \
+	.secretlen = type ## _SECRET_SIZE, \
+	.keylen = type ## _KEY_SIZE, \
+	.aead = aead_name, \
+	.skc = skc_name, \
+	.shash = sha_name, \
+}
+
+static struct quic_cipher ciphers[QUIC_CIPHER_MAX + 1 - QUIC_CIPHER_MIN] = {
+	CIPHER_DESC(TLS_CIPHER_AES_GCM_128, "gcm(aes)", "ecb(aes)", "hmac(sha256)"),
+	CIPHER_DESC(TLS_CIPHER_AES_GCM_256, "gcm(aes)", "ecb(aes)", "hmac(sha384)"),
+	CIPHER_DESC(TLS_CIPHER_AES_CCM_128, "ccm(aes)", "ecb(aes)", "hmac(sha256)"),
+	CIPHER_DESC(TLS_CIPHER_CHACHA20_POLY1305,
+		    "rfc7539(chacha20,poly1305)", "chacha20", "hmac(sha256)"),
+};
+
+static bool quic_crypto_is_cipher_ccm(struct quic_crypto *crypto)
+{
+	return crypto->cipher_type == TLS_CIPHER_AES_CCM_128;
+}
+
+static bool quic_crypto_is_cipher_chacha(struct quic_crypto *crypto)
+{
+	return crypto->cipher_type == TLS_CIPHER_CHACHA20_POLY1305;
+}
+
+int quic_crypto_encrypt(struct quic_crypto *crypto, struct sk_buff *skb)
+{
+	struct quic_crypto_cb *cb = QUIC_CRYPTO_CB(skb);
+	int err, phase = crypto->key_phase;
+	u8 *iv, cha, ccm;
+
+	cb->key_phase = phase;
+	iv = crypto->tx_iv[phase];
+	if (cb->resume)
+		goto out;
+
+	if (crypto->key_pending && !crypto->key_update_send_time)
+		crypto->key_update_send_time = jiffies_to_usecs(jiffies);
+
+	ccm = quic_crypto_is_cipher_ccm(crypto);
+	err = quic_crypto_payload_encrypt(crypto->tx_tfm[phase], skb, iv, ccm);
+	if (err)
+		return err;
+out:
+	cha = quic_crypto_is_cipher_chacha(crypto);
+	return quic_crypto_header_encrypt(crypto->tx_hp_tfm, skb, cha);
+}
+EXPORT_SYMBOL_GPL(quic_crypto_encrypt);
+
+int quic_crypto_decrypt(struct quic_crypto *crypto, struct sk_buff *skb)
+{
+	struct quic_crypto_cb *cb = QUIC_CRYPTO_CB(skb);
+	int err = 0, phase;
+	u8 *iv, cha, ccm;
+
+	if (cb->resume) {
+		quic_crypto_get_header(skb);
+		goto out;
+	}
+
+	cha = quic_crypto_is_cipher_chacha(crypto);
+	err = quic_crypto_header_decrypt(crypto->rx_hp_tfm, skb, cha);
+	if (err) {
+		pr_debug("%s: hd decrypt err %d\n", __func__, err);
+		return err;
+	}
+
+	if (cb->key_phase != crypto->key_phase && !crypto->key_pending) {
+		if (!crypto->send_ready) /* not ready for key update */
+			return -EINVAL;
+		err = quic_crypto_key_update(crypto);
+		if (err) {
+			cb->errcode = QUIC_TRANSPORT_ERROR_KEY_UPDATE;
+			return err;
+		}
+	}
+
+	phase = cb->key_phase;
+	iv = crypto->rx_iv[phase];
+	ccm = quic_crypto_is_cipher_ccm(crypto);
+	err = quic_crypto_payload_decrypt(crypto->rx_tfm[phase], skb, iv, ccm);
+	if (err)
+		return err;
+
+out:
+	/* An endpoint MUST retain old keys until it has successfully unprotected a
+	 * packet sent using the new keys. An endpoint SHOULD retain old keys for
+	 * some time after unprotecting a packet sent using the new keys.
+	 */
+	if (cb->key_phase == crypto->key_phase &&
+	    crypto->key_pending && crypto->key_update_send_time &&
+	    jiffies_to_usecs(jiffies) - crypto->key_update_send_time >= crypto->key_update_time)
+		cb->key_update = 1;
+	return err;
+}
+EXPORT_SYMBOL_GPL(quic_crypto_decrypt);
+
+int quic_crypto_set_secret(struct quic_crypto *crypto, struct quic_crypto_secret *srt,
+			   u32 version, u8 flag)
+{
+	int err = -EINVAL, secretlen;
+	struct quic_cipher *cipher;
+	void *tfm;
+
+	if (!crypto->cipher) {
+		crypto->version = version;
+		if (srt->type < QUIC_CIPHER_MIN || srt->type > QUIC_CIPHER_MAX)
+			return -EINVAL;
+
+		cipher = &ciphers[srt->type - QUIC_CIPHER_MIN];
+		tfm = crypto_alloc_shash(cipher->shash, 0, 0);
+		if (IS_ERR(tfm))
+			return PTR_ERR(tfm);
+		crypto->secret_tfm = tfm;
+
+		tfm = crypto_alloc_aead(cipher->aead, 0, CRYPTO_ALG_ASYNC);
+		if (IS_ERR(tfm)) {
+			err = PTR_ERR(tfm);
+			goto err;
+		}
+		crypto->tag_tfm = tfm;
+		crypto->cipher = cipher;
+		crypto->cipher_type = srt->type;
+	}
+
+	cipher = crypto->cipher;
+	secretlen = cipher->secretlen;
+	if (!srt->send) {
+		if (crypto->recv_ready)
+			goto err;
+		memcpy(crypto->rx_secret, srt->secret, secretlen);
+		tfm = crypto_alloc_aead(cipher->aead, 0, flag);
+		if (IS_ERR(tfm)) {
+			err = PTR_ERR(tfm);
+			goto err;
+		}
+		crypto->rx_tfm[0] = tfm;
+		tfm = crypto_alloc_aead(cipher->aead, 0, flag);
+		if (IS_ERR(tfm)) {
+			err = PTR_ERR(tfm);
+			goto err;
+		}
+		crypto->rx_tfm[1] = tfm;
+		tfm = crypto_alloc_sync_skcipher(cipher->skc, 0, 0);
+		if (IS_ERR(tfm)) {
+			err = PTR_ERR(tfm);
+			goto err;
+		}
+		crypto->rx_hp_tfm = tfm;
+
+		err = quic_crypto_rx_keys_derive_and_install(crypto);
+		if (err)
+			goto err;
+		crypto->recv_ready = 1;
+		return 0;
+	}
+
+	if (crypto->send_ready)
+		goto err;
+	memcpy(crypto->tx_secret, srt->secret, secretlen);
+	tfm = crypto_alloc_aead(cipher->aead, 0, flag);
+	if (IS_ERR(tfm)) {
+		err = PTR_ERR(tfm);
+		goto err;
+	}
+	crypto->tx_tfm[0] = tfm;
+	tfm = crypto_alloc_aead(cipher->aead, 0, flag);
+	if (IS_ERR(tfm)) {
+		err = PTR_ERR(tfm);
+		goto err;
+	}
+	crypto->tx_tfm[1] = tfm;
+	tfm = crypto_alloc_sync_skcipher(cipher->skc, 0, 0);
+	if (IS_ERR(tfm)) {
+		err = PTR_ERR(tfm);
+		goto err;
+	}
+	crypto->tx_hp_tfm = tfm;
+	err = quic_crypto_tx_keys_derive_and_install(crypto);
+	if (err)
+		goto err;
+	crypto->send_ready = 1;
+	return 0;
+err:
+	quic_crypto_destroy(crypto);
+	return err;
+}
+EXPORT_SYMBOL_GPL(quic_crypto_set_secret);
+
+int quic_crypto_get_secret(struct quic_crypto *crypto, struct quic_crypto_secret *srt)
+{
+	u8 *secret;
+
+	if (!crypto->cipher)
+		return -EINVAL;
+	srt->type = crypto->cipher_type;
+	secret = srt->send ? crypto->tx_secret : crypto->rx_secret;
+	memcpy(srt->secret, secret, crypto->cipher->secretlen);
+	return 0;
+}
+
+#define LABEL_V1	"quic ku"
+#define LABEL_V2	"quicv2 ku"
+
+int quic_crypto_key_update(struct quic_crypto *crypto)
+{
+	u8 tx_secret[QUIC_SECRET_LEN], rx_secret[QUIC_SECRET_LEN];
+	struct quic_data l = {LABEL_V1, 7}, z = {}, k, srt;
+	int err, secret_len;
+
+	if (crypto->key_pending || !crypto->recv_ready)
+		return -EINVAL;
+
+	secret_len = crypto->cipher->secretlen;
+	if (crypto->version == QUIC_VERSION_V2)
+		quic_data(&l, LABEL_V2, 9);
+
+	crypto->key_pending = 1;
+	memcpy(tx_secret, crypto->tx_secret, secret_len);
+	memcpy(rx_secret, crypto->rx_secret, secret_len);
+	crypto->key_phase = !crypto->key_phase;
+
+	quic_data(&srt, tx_secret, secret_len);
+	quic_data(&k, crypto->tx_secret, secret_len);
+	err = quic_crypto_hkdf_expand(crypto->secret_tfm, &srt, &l, &z, &k);
+	if (err)
+		goto err;
+	err = quic_crypto_tx_keys_derive_and_install(crypto);
+	if (err)
+		goto err;
+
+	quic_data(&srt, rx_secret, secret_len);
+	quic_data(&k, crypto->rx_secret, secret_len);
+	err = quic_crypto_hkdf_expand(crypto->secret_tfm, &srt, &l, &z, &k);
+	if (err)
+		goto err;
+	err = quic_crypto_rx_keys_derive_and_install(crypto);
+	if (err)
+		goto err;
+	return 0;
+err:
+	crypto->key_pending = 0;
+	memcpy(crypto->tx_secret, tx_secret, secret_len);
+	memcpy(crypto->rx_secret, rx_secret, secret_len);
+	crypto->key_phase = !crypto->key_phase;
+	return err;
+}
+EXPORT_SYMBOL_GPL(quic_crypto_key_update);
+
+void quic_crypto_destroy(struct quic_crypto *crypto)
+{
+	if (crypto->tag_tfm)
+		crypto_free_aead(crypto->tag_tfm);
+	if (crypto->rx_tfm[0])
+		crypto_free_aead(crypto->rx_tfm[0]);
+	if (crypto->rx_tfm[1])
+		crypto_free_aead(crypto->rx_tfm[1]);
+	if (crypto->tx_tfm[0])
+		crypto_free_aead(crypto->tx_tfm[0]);
+	if (crypto->tx_tfm[1])
+		crypto_free_aead(crypto->tx_tfm[1]);
+	if (crypto->secret_tfm)
+		crypto_free_shash(crypto->secret_tfm);
+	if (crypto->rx_hp_tfm)
+		crypto_free_skcipher(crypto->rx_hp_tfm);
+	if (crypto->tx_hp_tfm)
+		crypto_free_skcipher(crypto->tx_hp_tfm);
+
+	memset(crypto, 0, sizeof(*crypto));
+}
+EXPORT_SYMBOL_GPL(quic_crypto_destroy);
+
+#define QUIC_INITIAL_SALT_V1    \
+	"\x38\x76\x2c\xf7\xf5\x59\x34\xb3\x4d\x17\x9a\xe6\xa4\xc8\x0c\xad\xcc\xbb\x7f\x0a"
+#define QUIC_INITIAL_SALT_V2    \
+	"\x0d\xed\xe3\xde\xf7\x00\xa6\xdb\x81\x93\x81\xbe\x6e\x26\x9d\xcb\xf9\xbd\x2e\xd9"
+
+int quic_crypto_initial_keys_install(struct quic_crypto *crypto, struct quic_conn_id *conn_id,
+				     u32 version, bool is_serv)
+{
+	struct quic_data salt, s, k, l, dcid, z = {};
+	struct quic_crypto_secret srt = {};
+	struct crypto_shash *tfm;
+	char *tl, *rl, *sal;
+	u8 secret[32];
+	int err;
+
+	tfm = crypto_alloc_shash("hmac(sha256)", 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+	if (is_serv) {
+		rl = "client in";
+		tl = "server in";
+	} else {
+		tl = "client in";
+		rl = "server in";
+	}
+	crypto->version = version;
+	sal = QUIC_INITIAL_SALT_V1;
+	if (version == QUIC_VERSION_V2)
+		sal = QUIC_INITIAL_SALT_V2;
+	quic_data(&salt, sal, 20);
+	quic_data(&dcid, conn_id->data, conn_id->len);
+	quic_data(&s, secret, 32);
+	err = quic_crypto_hkdf_extract(tfm, &salt, &dcid, &s);
+	if (err)
+		goto out;
+
+	quic_data(&l, tl, 9);
+	quic_data(&k, srt.secret, 32);
+	srt.type = TLS_CIPHER_AES_GCM_128;
+	srt.send = 1;
+	err = quic_crypto_hkdf_expand(tfm, &s, &l, &z, &k);
+	if (err)
+		goto out;
+	err = quic_crypto_set_secret(crypto, &srt, version, CRYPTO_ALG_ASYNC);
+	if (err)
+		goto out;
+
+	quic_data(&l, rl, 9);
+	quic_data(&k, srt.secret, 32);
+	srt.type = TLS_CIPHER_AES_GCM_128;
+	srt.send = 0;
+	err = quic_crypto_hkdf_expand(tfm, &s, &l, &z, &k);
+	if (err)
+		goto out;
+	err = quic_crypto_set_secret(crypto, &srt, version, CRYPTO_ALG_ASYNC);
+out:
+	crypto_free_shash(tfm);
+	return err;
+}
+EXPORT_SYMBOL_GPL(quic_crypto_initial_keys_install);
+
+#define QUIC_RETRY_KEY_V1 "\xbe\x0c\x69\x0b\x9f\x66\x57\x5a\x1d\x76\x6b\x54\xe3\x68\xc8\x4e"
+#define QUIC_RETRY_KEY_V2 "\x8f\xb4\xb0\x1b\x56\xac\x48\xe2\x60\xfb\xcb\xce\xad\x7c\xcc\x92"
+
+#define QUIC_RETRY_NONCE_V1 "\x46\x15\x99\xd3\x5d\x63\x2b\xf2\x23\x98\x25\xbb"
+#define QUIC_RETRY_NONCE_V2 "\xd8\x69\x69\xbc\x2d\x7c\x6d\x99\x90\xef\xb0\x4a"
+
+int quic_crypto_get_retry_tag(struct quic_crypto *crypto, struct sk_buff *skb,
+			      struct quic_conn_id *odcid, u32 version, u8 *tag)
+{
+	struct crypto_aead *tfm = crypto->tag_tfm;
+	u8 *pseudo_retry, *p, *iv, *key;
+	struct aead_request *req;
+	struct scatterlist *sg;
+	int err, plen;
+
+	err = crypto_aead_setauthsize(tfm, QUIC_TAG_LEN);
+	if (err)
+		return err;
+	key = QUIC_RETRY_KEY_V1;
+	if (version == QUIC_VERSION_V2)
+		key = QUIC_RETRY_KEY_V2;
+	err = crypto_aead_setkey(tfm, key, 16);
+	if (err)
+		return err;
+
+	pseudo_retry = quic_crypto_aead_mem_alloc(tfm, 128, &iv, &req, &sg, 1);
+	if (!pseudo_retry)
+		return -ENOMEM;
+
+	p = pseudo_retry;
+	p = quic_put_int(p, odcid->len, 1);
+	p = quic_put_data(p, odcid->data, odcid->len);
+	p = quic_put_data(p, skb->data, skb->len - 16);
+	plen = p - pseudo_retry;
+	sg_init_one(sg, pseudo_retry, plen + 16);
+
+	memcpy(iv, QUIC_RETRY_NONCE_V1, 12);
+	if (version == QUIC_VERSION_V2)
+		memcpy(iv, QUIC_RETRY_NONCE_V2, 12);
+	aead_request_set_tfm(req, tfm);
+	aead_request_set_ad(req, plen);
+	aead_request_set_crypt(req, sg, sg, 0, iv);
+	err = crypto_aead_encrypt(req);
+	if (!err)
+		memcpy(tag, pseudo_retry + plen, 16);
+	kfree(pseudo_retry);
+	return err;
+}
+EXPORT_SYMBOL_GPL(quic_crypto_get_retry_tag);
+
+int quic_crypto_generate_token(struct quic_crypto *crypto, void *addr, u32 addrlen,
+			       struct quic_conn_id *conn_id, u8 *token, u32 *tokenlen)
+{
+	u8 key[16], iv[12], *retry_token, *tx_iv, *p;
+	struct crypto_aead *tfm = crypto->tag_tfm;
+	u32 ts = jiffies_to_usecs(jiffies);
+	struct quic_data srt = {}, k, i;
+	struct aead_request *req;
+	struct scatterlist *sg;
+	int err, len;
+
+	quic_data(&srt, quic_random_data, 32);
+	quic_data(&k, key, 16);
+	quic_data(&i, iv, 12);
+	err = quic_crypto_keys_derive(crypto->secret_tfm, &srt, &k, &i, NULL, QUIC_VERSION_V1);
+	if (err)
+		return err;
+	err = crypto_aead_setauthsize(tfm, QUIC_TAG_LEN);
+	if (err)
+		return err;
+	err = crypto_aead_setkey(tfm, key, 16);
+	if (err)
+		return err;
+	token++;
+	len = addrlen + sizeof(ts) + conn_id->len + QUIC_TAG_LEN;
+	retry_token = quic_crypto_aead_mem_alloc(tfm, len, &tx_iv, &req, &sg, 1);
+	if (!retry_token)
+		return -ENOMEM;
+
+	p = retry_token;
+	p = quic_put_data(p, addr, addrlen);
+	p = quic_put_int(p, ts, sizeof(ts));
+	p = quic_put_data(p, conn_id->data, conn_id->len);
+	sg_init_one(sg, retry_token, len);
+	aead_request_set_tfm(req, tfm);
+	aead_request_set_ad(req, addrlen);
+	aead_request_set_crypt(req, sg, sg, len - addrlen - QUIC_TAG_LEN, iv);
+	err = crypto_aead_encrypt(req);
+	if (!err) {
+		memcpy(token, retry_token, len);
+		*tokenlen = len + 1;
+	}
+	kfree(retry_token);
+	return err;
+}
+EXPORT_SYMBOL_GPL(quic_crypto_generate_token);
+
+int quic_crypto_verify_token(struct quic_crypto *crypto, void *addr, u32 addrlen,
+			     struct quic_conn_id *conn_id, u8 *token, u32 len)
+{
+	u8 key[16], iv[12], *retry_token, *rx_iv, *p, retry = *token;
+	u32 ts = jiffies_to_usecs(jiffies), timeout = 3000000;
+	struct crypto_aead *tfm = crypto->tag_tfm;
+	struct quic_data srt = {}, k, i;
+	struct aead_request *req;
+	struct scatterlist *sg;
+	int err;
+	u64 t;
+
+	quic_data(&srt, quic_random_data, 32);
+	quic_data(&k, key, 16);
+	quic_data(&i, iv, 12);
+	err = quic_crypto_keys_derive(crypto->secret_tfm, &srt, &k, &i, NULL, QUIC_VERSION_V1);
+	if (err)
+		return err;
+	err = crypto_aead_setauthsize(tfm, QUIC_TAG_LEN);
+	if (err)
+		return err;
+	err = crypto_aead_setkey(tfm, key, 16);
+	if (err)
+		return err;
+	len--;
+	token++;
+	retry_token = quic_crypto_aead_mem_alloc(tfm, len, &rx_iv, &req, &sg, 1);
+	if (!retry_token)
+		return -ENOMEM;
+
+	memcpy(retry_token, token, len);
+	sg_init_one(sg, retry_token, len);
+	aead_request_set_tfm(req, tfm);
+	aead_request_set_ad(req, addrlen);
+	aead_request_set_crypt(req, sg, sg, len - addrlen, iv);
+	err = crypto_aead_decrypt(req);
+	if (err)
+		goto out;
+
+	err = -EINVAL;
+	p = retry_token;
+	if (memcmp(p, addr, addrlen))
+		goto out;
+	p += addrlen;
+	len -= addrlen;
+	if (!retry)
+		timeout = 36000000;
+	if (!quic_get_int(&p, &len, &t, 4) || t + timeout < ts)
+		goto out;
+	len -= QUIC_TAG_LEN;
+	if (len > QUIC_CONN_ID_MAX_LEN)
+		goto out;
+
+	if (retry)
+		quic_conn_id_update(conn_id, p, len);
+	err = 0;
+out:
+	kfree(retry_token);
+	return err;
+}
+EXPORT_SYMBOL_GPL(quic_crypto_verify_token);
+
+static int quic_crypto_generate_key(struct quic_crypto *crypto, void *data, u32 len,
+				    char *label, u8 *token, u32 key_len)
+{
+	struct crypto_shash *tfm = crypto->secret_tfm;
+	struct quic_data salt, s, l, k, z = {};
+	u8 secret[32];
+	int err;
+
+	quic_data(&salt, data, len);
+	quic_data(&k, quic_random_data, 32);
+	quic_data(&s, secret, 32);
+	err = quic_crypto_hkdf_extract(tfm, &salt, &k, &s);
+	if (err)
+		return err;
+
+	quic_data(&l, label, strlen(label));
+	quic_data(&k, token, key_len);
+	return quic_crypto_hkdf_expand(tfm, &s, &l, &z, &k);
+}
+
+int quic_crypto_generate_stateless_reset_token(struct quic_crypto *crypto, void *data,
+					       u32 len, u8 *key, u32 key_len)
+{
+	return quic_crypto_generate_key(crypto, data, len, "stateless_reset", key, key_len);
+}
+EXPORT_SYMBOL_GPL(quic_crypto_generate_stateless_reset_token);
+
+int quic_crypto_generate_session_ticket_key(struct quic_crypto *crypto, void *data,
+					    u32 len, u8 *key, u32 key_len)
+{
+	return quic_crypto_generate_key(crypto, data, len, "session_ticket", key, key_len);
+}
+EXPORT_SYMBOL_GPL(quic_crypto_generate_session_ticket_key);
diff --git a/net/quic/crypto.h b/net/quic/crypto.h
new file mode 100644
index 000000000000..5624f6cb44c5
--- /dev/null
+++ b/net/quic/crypto.h
@@ -0,0 +1,153 @@
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
+#include <linux/crypto.h>
+
+struct quic_crypto_cb {
+	union {
+		void (*crypto_done)(struct sk_buff *skb, int err);
+		struct sk_buff *last;
+	};
+	s64 number_max;
+	s64 number;
+	u16 errcode;
+	u16 length;
+
+	u16 udph_offset;
+	u8 number_offset;
+	u8 number_len;
+	u8 level;
+
+	u8 key_update:1;
+	u8 key_phase:1;
+	u8 path_alt:2;
+	u8 backlog:1;
+	u8 resume:1;
+	u8 ecn:2;
+};
+
+#define QUIC_CRYPTO_CB(__skb)      ((struct quic_crypto_cb *)&((__skb)->cb[0]))
+
+#define QUIC_TAG_LEN	16
+#define QUIC_IV_LEN	12
+#define QUIC_SECRET_LEN	48
+
+struct quic_cipher {
+	u32 secretlen;
+	u32 keylen;
+
+	char *shash;
+	char *aead;
+	char *skc;
+};
+
+struct quic_crypto {
+	struct crypto_skcipher *tx_hp_tfm;
+	struct crypto_skcipher *rx_hp_tfm;
+	struct crypto_shash *secret_tfm;
+	struct crypto_aead *tx_tfm[2];
+	struct crypto_aead *rx_tfm[2];
+	struct crypto_aead *tag_tfm;
+	struct quic_cipher *cipher;
+	u32 cipher_type;
+
+	u8 tx_secret[QUIC_SECRET_LEN];
+	u8 rx_secret[QUIC_SECRET_LEN];
+	u8 tx_iv[2][QUIC_IV_LEN];
+	u8 rx_iv[2][QUIC_IV_LEN];
+
+	u32 key_update_send_time;
+	u32 key_update_time;
+	u64 send_offset;
+	u64 recv_offset;
+	u32 version;
+
+	u8 key_pending:1;
+	u8 send_ready:1;
+	u8 recv_ready:1;
+	u8 key_phase:1;
+};
+
+static inline u32 quic_crypto_cipher_type(struct quic_crypto *crypto)
+{
+	return crypto->cipher_type;
+}
+
+static inline void quic_crypto_set_cipher_type(struct quic_crypto *crypto, u32 type)
+{
+	crypto->cipher_type = type;
+}
+
+static inline u64 quic_crypto_recv_offset(struct quic_crypto *crypto)
+{
+	return crypto->recv_offset;
+}
+
+static inline void quic_crypto_inc_recv_offset(struct quic_crypto *crypto, u64 offset)
+{
+	crypto->recv_offset += offset;
+}
+
+static inline u64 quic_crypto_send_offset(struct quic_crypto *crypto)
+{
+	return crypto->send_offset;
+}
+
+static inline void quic_crypto_inc_send_offset(struct quic_crypto *crypto, u64 offset)
+{
+	crypto->send_offset += offset;
+}
+
+static inline u8 quic_crypto_recv_ready(struct quic_crypto *crypto)
+{
+	return crypto->recv_ready;
+}
+
+static inline u8 quic_crypto_send_ready(struct quic_crypto *crypto)
+{
+	return crypto->send_ready;
+}
+
+static inline void quic_crypto_set_key_pending(struct quic_crypto *crypto, u8 pending)
+{
+	crypto->key_pending = pending;
+}
+
+static inline void quic_crypto_set_key_update_send_time(struct quic_crypto *crypto, u32 send_time)
+{
+	crypto->key_update_send_time = send_time;
+}
+
+static inline void quic_crypto_set_key_update_time(struct quic_crypto *crypto, u32 key_update_time)
+{
+	crypto->key_update_time = key_update_time;
+}
+
+int quic_crypto_set_secret(struct quic_crypto *crypto, struct quic_crypto_secret *srt,
+			   u32 version, u8 flag);
+int quic_crypto_get_secret(struct quic_crypto *crypto, struct quic_crypto_secret *srt);
+int quic_crypto_encrypt(struct quic_crypto *crypto, struct sk_buff *skb);
+int quic_crypto_decrypt(struct quic_crypto *crypto, struct sk_buff *skb);
+int quic_crypto_key_update(struct quic_crypto *crypto);
+void quic_crypto_destroy(struct quic_crypto *crypto);
+
+int quic_crypto_initial_keys_install(struct quic_crypto *crypto, struct quic_conn_id *conn_id,
+				     u32 version, bool is_serv);
+int quic_crypto_generate_session_ticket_key(struct quic_crypto *crypto, void *data,
+					    u32 len, u8 *key, u32 key_len);
+int quic_crypto_generate_stateless_reset_token(struct quic_crypto *crypto, void *data,
+					       u32 len, u8 *key, u32 key_len);
+
+int quic_crypto_generate_token(struct quic_crypto *crypto, void *addr, u32 addrlen,
+			       struct quic_conn_id *conn_id, u8 *token, u32 *tokenlen);
+int quic_crypto_get_retry_tag(struct quic_crypto *crypto, struct sk_buff *skb,
+			      struct quic_conn_id *odcid, u32 version, u8 *tag);
+int quic_crypto_verify_token(struct quic_crypto *crypto, void *addr, u32 addrlen,
+			     struct quic_conn_id *conn_id, u8 *token, u32 len);
diff --git a/net/quic/frame.c b/net/quic/frame.c
new file mode 100644
index 000000000000..815a3c15b0d9
--- /dev/null
+++ b/net/quic/frame.c
@@ -0,0 +1,1903 @@
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
+#include <net/proto_memory.h>
+#include <linux/nospec.h>
+
+#include "socket.h"
+
+/* ACK Frame {
+ *  Type (i) = 0x02..0x03,
+ *  Largest Acknowledged (i),
+ *  ACK Delay (i),
+ *  ACK Range Count (i),
+ *  First ACK Range (i),
+ *  ACK Range (..) ...,
+ *  [ECN Counts (..)],
+ * }
+ */
+
+static bool quic_frame_copy_from_iter_full(void *addr, size_t bytes, struct iov_iter *i)
+{
+	size_t copied = _copy_from_iter(addr, bytes, i);
+
+	if (likely(copied == bytes))
+		return true;
+	iov_iter_revert(i, copied);
+	return false;
+}
+
+static struct quic_frame *quic_frame_ack_create(struct sock *sk, void *data, u8 type)
+{
+	struct quic_outqueue *outq = quic_outq(sk);
+	u64 largest, smallest, range, *ecn_count;
+	struct quic_gap_ack_block *gabs;
+	u32 frame_len, num_gabs, time;
+	u8 *p, level = *((u8 *)data);
+	struct quic_pnspace *space;
+	struct quic_frame *frame;
+	int i;
+
+	space = quic_pnspace(sk, level);
+	gabs = quic_pnspace_gabs(space);
+	type += quic_pnspace_has_ecn_count(space);
+	num_gabs = quic_pnspace_num_gabs(space);
+	WARN_ON_ONCE(num_gabs == QUIC_PN_MAX_GABS);
+	frame_len = sizeof(type) + sizeof(u32) * 7;
+	frame_len += sizeof(struct quic_gap_ack_block) * num_gabs;
+
+	largest = quic_pnspace_max_pn_seen(space);
+	time = quic_pnspace_max_pn_time(space);
+	smallest = quic_pnspace_min_pn_seen(space);
+	if (num_gabs)
+		smallest = quic_pnspace_base_pn(space) + gabs[num_gabs - 1].end;
+	range = largest - smallest;
+	frame = quic_frame_alloc(frame_len, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+	time = jiffies_to_usecs(jiffies) - time;
+	time = time / BIT(quic_outq_ack_delay_exponent(outq));
+	p = quic_put_var(frame->data, type);
+	p = quic_put_var(p, largest); /* Largest Acknowledged */
+	p = quic_put_var(p, time); /* ACK Delay */
+	p = quic_put_var(p, num_gabs); /* ACK Count */
+	p = quic_put_var(p, range); /* First ACK Range */
+
+	if (num_gabs) {
+		for (i = num_gabs - 1; i > 0; i--) {
+			p = quic_put_var(p, gabs[i].end - gabs[i].start); /* Gap */
+			/* ACK Range Length */
+			p = quic_put_var(p, gabs[i].start - gabs[i - 1].end - 2);
+		}
+		p = quic_put_var(p, gabs[0].end - gabs[0].start); /* Gap */
+		range = gabs[0].start - 1 + quic_pnspace_base_pn(space);
+		range -= (quic_pnspace_min_pn_seen(space) + 1);
+		p = quic_put_var(p, range); /* ACK Range Length */
+	}
+	if (type == QUIC_FRAME_ACK_ECN) {
+		ecn_count = quic_pnspace_ecn_count(space);
+		p = quic_put_var(p, ecn_count[1]); /* ECT0 Count */
+		p = quic_put_var(p, ecn_count[0]); /* ECT1 Count */
+		p = quic_put_var(p, ecn_count[2]); /* ECN-CE Count */
+	}
+	frame_len = (u32)(p - frame->data);
+	frame->len = frame_len;
+	frame->level = level;
+	frame->type = type;
+
+	return frame;
+}
+
+static struct quic_frame *quic_frame_ping_create(struct sock *sk, void *data, u8 type)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_frame *frame;
+	u32 *probe_size = data;
+	u32 frame_len;
+
+	if (quic_packet_config(sk, 0, 0))
+		return NULL;
+	frame_len = *probe_size - packet->overhead;
+	frame = quic_frame_alloc(frame_len, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+
+	quic_put_var(frame->data, type);
+	memset(frame->data + 1, 0, frame_len - 1);
+	frame->padding = 1;
+
+	return frame;
+}
+
+static struct quic_frame *quic_frame_padding_create(struct sock *sk, void *data, u8 type)
+{
+	struct quic_frame *frame;
+	u32 *frame_len = data;
+
+	frame = quic_frame_alloc(*frame_len + 1, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+	quic_put_var(frame->data, type);
+	memset(frame->data + 1, 0, *frame_len);
+
+	return frame;
+}
+
+static struct quic_frame *quic_frame_new_token_create(struct sock *sk, void *data, u8 type)
+{
+	struct quic_crypto *crypto = quic_crypto(sk, QUIC_CRYPTO_INITIAL);
+	struct quic_conn_id_set *id_set = quic_source(sk);
+	union quic_addr *da = quic_path_addr(quic_dst(sk), 0);
+	struct quic_frame *frame;
+	u8 token[72], *p;
+	u32 tokenlen;
+
+	p = token;
+	p = quic_put_int(p, 0, 1); /* regular token */
+	if (quic_crypto_generate_token(crypto, da, quic_addr_len(sk),
+				       quic_conn_id_active(id_set), token, &tokenlen))
+		return NULL;
+
+	frame = quic_frame_alloc(tokenlen + 4, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+	p = quic_put_var(frame->data, type);
+	p = quic_put_var(p, tokenlen);
+	p = quic_put_data(p, token, tokenlen);
+	frame->len = p - frame->data;
+
+	return frame;
+}
+
+/* STREAM Frame {
+ *  Type (i) = 0x08..0x0f,
+ *  Stream ID (i),
+ *  [Offset (i)],
+ *  [Length (i)],
+ *  Stream Data (..),
+ * }
+ */
+
+static struct quic_frame *quic_frame_stream_create(struct sock *sk, void *data, u8 type)
+{
+	u32 msg_len, hlen = 1, frame_len, max_frame_len;
+	struct quic_msginfo *info = data;
+	struct quic_stream *stream;
+	struct quic_frame *frame;
+	u8 *p;
+
+	if (quic_packet_config(sk, 0, 0))
+		return NULL;
+	max_frame_len = quic_packet_max_payload(quic_packet(sk));
+	stream = info->stream;
+	hlen += quic_var_len(stream->id);
+	if (stream->send.offset) {
+		type |= QUIC_STREAM_BIT_OFF;
+		hlen += quic_var_len(stream->send.offset);
+	}
+
+	type |= QUIC_STREAM_BIT_LEN;
+	hlen += quic_var_len(max_frame_len);
+
+	msg_len = iov_iter_count(info->msg);
+	if (msg_len <= max_frame_len - hlen) {
+		if (info->flags & MSG_STREAM_FIN)
+			type |= QUIC_STREAM_BIT_FIN;
+	} else {
+		msg_len = max_frame_len - hlen;
+	}
+
+	frame = quic_frame_alloc(msg_len + hlen, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+
+	p = quic_put_var(frame->data, type);
+	p = quic_put_var(p, stream->id);
+	if (type & QUIC_STREAM_BIT_OFF)
+		p = quic_put_var(p, stream->send.offset);
+	p = quic_put_var(p, msg_len);
+	frame_len = (u32)(p - frame->data);
+
+	if (!quic_frame_copy_from_iter_full(p, msg_len, info->msg)) {
+		quic_frame_free(frame);
+		return NULL;
+	}
+	frame_len += msg_len;
+	frame->len = frame_len;
+	frame->bytes = msg_len;
+	frame->stream = stream;
+	frame->type = type;
+
+	stream->send.offset += msg_len;
+	return frame;
+}
+
+static struct quic_frame *quic_frame_handshake_done_create(struct sock *sk, void *data, u8 type)
+{
+	struct quic_frame *frame;
+	u8 *p, buf[10];
+	u32 frame_len;
+
+	p = quic_put_var(buf, type);
+	frame_len = (u32)(p - buf);
+
+	frame = quic_frame_alloc(frame_len, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+	quic_put_data(frame->data, buf, frame_len);
+
+	return frame;
+}
+
+static struct quic_frame *quic_frame_crypto_create(struct sock *sk, void *data, u8 type)
+{
+	struct quic_msginfo *info = data;
+	u32 msg_len, hlen, max_frame_len;
+	struct quic_crypto *crypto;
+	struct quic_frame *frame;
+	u64 offset;
+	u8 *p;
+
+	if (quic_packet_config(sk, info->level, 0))
+		return NULL;
+	max_frame_len = quic_packet_max_payload(quic_packet(sk));
+	crypto = quic_crypto(sk, info->level);
+	msg_len = iov_iter_count(info->msg);
+
+	if (!info->level) {
+		if (msg_len > max_frame_len)
+			return NULL;
+		frame = quic_frame_alloc(msg_len + 8, NULL, GFP_ATOMIC);
+		if (!frame)
+			return NULL;
+		p = quic_put_var(frame->data, type);
+		p = quic_put_var(p, 0);
+		p = quic_put_var(p, msg_len);
+		if (!quic_frame_copy_from_iter_full(p, msg_len, info->msg)) {
+			quic_frame_free(frame);
+			return NULL;
+		}
+		p += msg_len;
+		frame->bytes = msg_len;
+		frame->len = p - frame->data;
+
+		return frame;
+	}
+
+	if (msg_len > max_frame_len)
+		msg_len = max_frame_len;
+	offset = quic_crypto_send_offset(crypto);
+	hlen = 1 + quic_var_len(msg_len) + quic_var_len(offset);
+	frame = quic_frame_alloc(msg_len + hlen, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+	p = quic_put_var(frame->data, type);
+	p = quic_put_var(p, offset);
+	p = quic_put_var(p, msg_len);
+	if (!quic_frame_copy_from_iter_full(p, msg_len, info->msg)) {
+		quic_frame_free(frame);
+		return NULL;
+	}
+	frame->len = msg_len + hlen;
+	quic_crypto_inc_send_offset(crypto, msg_len);
+	frame->level = info->level;
+	frame->bytes = msg_len;
+	return frame;
+}
+
+static struct quic_frame *quic_frame_retire_conn_id_create(struct sock *sk, void *data, u8 type)
+{
+	struct quic_frame *frame;
+	u64 *seqno = data;
+	u8 *p, buf[10];
+	u32 frame_len;
+
+	p = quic_put_var(buf, type);
+	p = quic_put_var(p, *seqno);
+	frame_len = (u32)(p - buf);
+
+	frame = quic_frame_alloc(frame_len, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+	quic_put_data(frame->data, buf, frame_len);
+
+	quic_conn_id_remove(quic_dest(sk), *seqno);
+	return frame;
+}
+
+static struct quic_frame *quic_frame_new_conn_id_create(struct sock *sk, void *data, u8 type)
+{
+	struct quic_crypto *crypto = quic_crypto(sk, QUIC_CRYPTO_INITIAL);
+	struct quic_conn_id scid = {};
+	u8 *p, buf[100], token[16];
+	u64 *prior = data, seqno;
+	struct quic_frame *frame;
+	u32 frame_len;
+	int err;
+
+	seqno = quic_conn_id_last_number(quic_source(sk)) + 1;
+
+	p = quic_put_var(buf, type);
+	p = quic_put_var(p, seqno);
+	p = quic_put_var(p, *prior);
+	quic_conn_id_generate(&scid);
+	p = quic_put_var(p, scid.len);
+	p = quic_put_data(p, scid.data, scid.len);
+	if (quic_crypto_generate_stateless_reset_token(crypto, scid.data, scid.len, token, 16))
+		return NULL;
+	p = quic_put_data(p, token, 16);
+	frame_len = (u32)(p - buf);
+
+	frame = quic_frame_alloc(frame_len, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+	quic_put_data(frame->data, buf, frame_len);
+
+	err = quic_conn_id_add(quic_source(sk), &scid, seqno, sk);
+	if (err) {
+		quic_frame_free(frame);
+		return NULL;
+	}
+
+	return frame;
+}
+
+static struct quic_frame *quic_frame_path_response_create(struct sock *sk, void *data, u8 type)
+{
+	u8 *p, buf[10], *entropy = data;
+	struct quic_frame *frame;
+	u32 frame_len;
+
+	p = quic_put_var(buf, type);
+	p = quic_put_data(p, entropy, 8);
+	frame_len = (u32)(p - buf);
+
+	frame = quic_frame_alloc(frame_len, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+	quic_put_data(frame->data, buf, frame_len);
+
+	return frame;
+}
+
+static struct quic_frame *quic_frame_path_challenge_create(struct sock *sk, void *data, u8 type)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_path_addr *path = data;
+	struct quic_frame *frame;
+	u32 frame_len;
+	u8 *p;
+
+	if (quic_packet_config(sk, 0, 0))
+		return NULL;
+	frame_len = QUIC_MIN_UDP_PAYLOAD - QUIC_TAG_LEN - packet->overhead;
+	get_random_bytes(quic_path_entropy(path), 8);
+
+	frame = quic_frame_alloc(frame_len, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+	p = quic_put_var(frame->data, type);
+	p = quic_put_data(p, quic_path_entropy(path), 8);
+	memset(p, 0, frame_len - 1 - 8);
+	frame->padding = 1;
+
+	return frame;
+}
+
+static struct quic_frame *quic_frame_reset_stream_create(struct sock *sk, void *data, u8 type)
+{
+	struct quic_stream_table *streams = quic_streams(sk);
+	struct quic_errinfo *info = data;
+	struct quic_stream *stream;
+	struct quic_frame *frame;
+	u8 *p, buf[20];
+	u32 frame_len;
+
+	stream = quic_stream_find(streams, info->stream_id);
+	WARN_ON(!stream);
+
+	p = quic_put_var(buf, type);
+	p = quic_put_var(p, info->stream_id);
+	p = quic_put_var(p, info->errcode);
+	p = quic_put_var(p, stream->send.offset);
+	frame_len = (u32)(p - buf);
+
+	frame = quic_frame_alloc(frame_len, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+	quic_put_data(frame->data, buf, frame_len);
+	stream->send.errcode = info->errcode;
+	frame->stream = stream;
+
+	if (quic_stream_send_active(streams) == stream->id)
+		quic_stream_set_send_active(streams, -1);
+
+	return frame;
+}
+
+static struct quic_frame *quic_frame_stop_sending_create(struct sock *sk, void *data, u8 type)
+{
+	struct quic_errinfo *info = data;
+	struct quic_frame *frame;
+	u8 *p, buf[10];
+	u32 frame_len;
+
+	p = quic_put_var(buf, type);
+	p = quic_put_var(p, info->stream_id);
+	p = quic_put_var(p, info->errcode);
+	frame_len = (u32)(p - buf);
+
+	frame = quic_frame_alloc(frame_len, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+	quic_put_data(frame->data, buf, frame_len);
+
+	return frame;
+}
+
+static struct quic_frame *quic_frame_max_data_create(struct sock *sk, void *data, u8 type)
+{
+	struct quic_inqueue *inq = data;
+	struct quic_frame *frame;
+	u8 *p, buf[10];
+	u32 frame_len;
+
+	p = quic_put_var(buf, type);
+	p = quic_put_var(p, quic_inq_max_bytes(inq));
+	frame_len = (u32)(p - buf);
+
+	frame = quic_frame_alloc(frame_len, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+	quic_put_data(frame->data, buf, frame_len);
+
+	return frame;
+}
+
+static struct quic_frame *quic_frame_max_stream_data_create(struct sock *sk, void *data, u8 type)
+{
+	struct quic_stream *stream = data;
+	struct quic_frame *frame;
+	u8 *p, buf[10];
+	u32 frame_len;
+
+	p = quic_put_var(buf, type);
+	p = quic_put_var(p, stream->id);
+	p = quic_put_var(p, stream->recv.max_bytes);
+	frame_len = (u32)(p - buf);
+
+	frame = quic_frame_alloc(frame_len, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+	quic_put_data(frame->data, buf, frame_len);
+
+	return frame;
+}
+
+static struct quic_frame *quic_frame_max_streams_uni_create(struct sock *sk, void *data, u8 type)
+{
+	struct quic_frame *frame;
+	u64 *max = data;
+	u8 *p, buf[10];
+	int frame_len;
+
+	p = quic_put_var(buf, type);
+	p = quic_put_var(p, *max);
+	frame_len = (u32)(p - buf);
+
+	frame = quic_frame_alloc(frame_len, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+	quic_put_data(frame->data, buf, frame_len);
+
+	return frame;
+}
+
+static struct quic_frame *quic_frame_max_streams_bidi_create(struct sock *sk, void *data, u8 type)
+{
+	struct quic_frame *frame;
+	u64 *max = data;
+	u8 *p, buf[10];
+	int frame_len;
+
+	p = quic_put_var(buf, type);
+	p = quic_put_var(p, *max);
+	frame_len = (u32)(p - buf);
+
+	frame = quic_frame_alloc(frame_len, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+	quic_put_data(frame->data, buf, frame_len);
+
+	return frame;
+}
+
+static struct quic_frame *quic_frame_connection_close_create(struct sock *sk, void *data, u8 type)
+{
+	struct quic_outqueue *outq = quic_outq(sk);
+	u32 frame_len, phrase_len = 0;
+	u8 *p, buf[100], *phrase;
+	struct quic_frame *frame;
+
+	p = quic_put_var(buf, type);
+	p = quic_put_var(p, quic_outq_close_errcode(outq));
+
+	if (type == QUIC_FRAME_CONNECTION_CLOSE)
+		p = quic_put_var(p, quic_outq_close_frame(outq));
+
+	phrase = quic_outq_close_phrase(outq);
+	if (phrase)
+		phrase_len = strlen(phrase);
+	p = quic_put_var(p, phrase_len);
+	p = quic_put_data(p, phrase, phrase_len);
+
+	frame_len = (u32)(p - buf);
+
+	frame = quic_frame_alloc(frame_len, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+	quic_put_data(frame->data, buf, frame_len);
+
+	return frame;
+}
+
+static struct quic_frame *quic_frame_data_blocked_create(struct sock *sk, void *data, u8 type)
+{
+	struct quic_outqueue *outq = data;
+	struct quic_frame *frame;
+	u8 *p, buf[10];
+	u32 frame_len;
+
+	p = quic_put_var(buf, type);
+	p = quic_put_var(p, quic_outq_max_bytes(outq));
+	frame_len = (u32)(p - buf);
+
+	frame = quic_frame_alloc(frame_len, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+	quic_put_data(frame->data, buf, frame_len);
+
+	return frame;
+}
+
+static struct quic_frame *quic_frame_stream_data_blocked_create(struct sock *sk,
+								void *data, u8 type)
+{
+	struct quic_stream *stream = data;
+	struct quic_frame *frame;
+	u8 *p, buf[10];
+	u32 frame_len;
+
+	p = quic_put_var(buf, type);
+	p = quic_put_var(p, stream->id);
+	p = quic_put_var(p, stream->send.max_bytes);
+	frame_len = (u32)(p - buf);
+
+	frame = quic_frame_alloc(frame_len, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+	quic_put_data(frame->data, buf, frame_len);
+	frame->stream = stream;
+
+	return frame;
+}
+
+static struct quic_frame *quic_frame_streams_blocked_uni_create(struct sock *sk,
+								void *data, u8 type)
+{
+	struct quic_frame *frame;
+	u64 *max = data;
+	u8 *p, buf[10];
+	u32 frame_len;
+
+	p = quic_put_var(buf, type);
+	p = quic_put_var(p, (*max >> 2) + 1);
+	frame_len = (u32)(p - buf);
+
+	frame = quic_frame_alloc(frame_len, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+	quic_put_data(frame->data, buf, frame_len);
+
+	return frame;
+}
+
+static struct quic_frame *quic_frame_streams_blocked_bidi_create(struct sock *sk,
+								 void *data, u8 type)
+{
+	struct quic_frame *frame;
+	u64 *max = data;
+	u8 *p, buf[10];
+	u32 frame_len;
+
+	p = quic_put_var(buf, type);
+	p = quic_put_var(p, (*max >> 2) + 1);
+	frame_len = (u32)(p - buf);
+
+	frame = quic_frame_alloc(frame_len, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+	quic_put_data(frame->data, buf, frame_len);
+
+	return frame;
+}
+
+static int quic_frame_crypto_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	struct quic_data *ticket = quic_ticket(sk);
+	struct quic_frame *nframe;
+	u32 len = frame->len;
+	u8 *p = frame->data;
+	u64 offset, length;
+	int err;
+
+	if (!quic_get_var(&p, &len, &offset))
+		return -EINVAL;
+	if (!quic_get_var(&p, &len, &length) || length > len)
+		return -EINVAL;
+
+	if (!frame->level) {
+		if (quic_data_dup(ticket, p, length))
+			return -ENOMEM;
+		if (quic_inq_event_recv(sk, QUIC_EVENT_NEW_SESSION_TICKET, ticket))
+			return -ENOMEM;
+		goto out;
+	}
+
+	nframe = quic_frame_alloc(length, p, GFP_ATOMIC);
+	if (!nframe)
+		return -ENOMEM;
+	nframe->skb = skb_get(frame->skb);
+
+	nframe->offset = offset;
+	nframe->level = frame->level;
+
+	err = quic_inq_handshake_recv(sk, nframe);
+	if (err) {
+		frame->errcode = nframe->errcode;
+		quic_inq_rfree(nframe->len, sk);
+		quic_frame_free(nframe);
+		return err;
+	}
+out:
+	len -= length;
+	return frame->len - len;
+}
+
+static int quic_frame_stream_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	struct quic_stream_table *streams = quic_streams(sk);
+	u64 stream_id, payload_len, offset = 0;
+	struct quic_stream *stream;
+	struct quic_frame *nframe;
+	u32 len = frame->len;
+	u8 *p = frame->data;
+	int err;
+
+	if (!quic_get_var(&p, &len, &stream_id))
+		return -EINVAL;
+	if (type & QUIC_STREAM_BIT_OFF) {
+		if (!quic_get_var(&p, &len, &offset))
+			return -EINVAL;
+	}
+
+	payload_len = len;
+	if (type & QUIC_STREAM_BIT_LEN) {
+		if (!quic_get_var(&p, &len, &payload_len) || payload_len > len)
+			return -EINVAL;
+	}
+
+	stream = quic_stream_recv_get(streams, stream_id, quic_is_serv(sk));
+	if (IS_ERR(stream)) {
+		err = PTR_ERR(stream);
+		if (err == -EAGAIN)
+			frame->errcode = QUIC_TRANSPORT_ERROR_STREAM_LIMIT;
+		else if (err != -ENOMEM)
+			frame->errcode = QUIC_TRANSPORT_ERROR_STREAM_STATE;
+		return err;
+	}
+
+	nframe = quic_frame_alloc(payload_len, p, GFP_ATOMIC);
+	if (!nframe)
+		return -ENOMEM;
+	nframe->skb = skb_get(frame->skb); /* use the data from skb */
+
+	nframe->offset = offset;
+	nframe->stream = stream;
+	nframe->stream_fin = (type & QUIC_STREAM_BIT_FIN);
+	nframe->offset = offset;
+	nframe->level = frame->level;
+
+	err = quic_inq_stream_recv(sk, nframe);
+	if (err) {
+		frame->errcode = nframe->errcode;
+		quic_inq_rfree(nframe->len, sk);
+		quic_frame_free(nframe);
+		return err;
+	}
+
+	len -= payload_len;
+	return frame->len - len;
+}
+
+static int quic_frame_ack_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	u64 largest, smallest, range, delay, count, gap, i, ecn_count[3];
+	u8 *p = frame->data, level = frame->level;
+	struct quic_cong *cong = quic_cong(sk);
+	struct quic_pnspace *space;
+	u32 len = frame->len;
+
+	if (!quic_get_var(&p, &len, &largest) ||
+	    !quic_get_var(&p, &len, &delay) ||
+	    !quic_get_var(&p, &len, &count) || count > QUIC_PN_MAX_GABS ||
+	    !quic_get_var(&p, &len, &range))
+		return -EINVAL;
+
+	space = quic_pnspace(sk, level);
+	if (largest >= quic_pnspace_next_pn(space)) {
+		frame->errcode = QUIC_TRANSPORT_ERROR_PROTOCOL_VIOLATION;
+		return -EINVAL;
+	}
+
+	quic_cong_set_time(cong, jiffies_to_usecs(jiffies));
+
+	smallest = largest - range;
+	quic_outq_transmitted_sack(sk, level, largest, smallest, largest, delay);
+
+	for (i = 0; i < count; i++) {
+		if (!quic_get_var(&p, &len, &gap) ||
+		    !quic_get_var(&p, &len, &range))
+			return -EINVAL;
+		largest = smallest - gap - 2;
+		smallest = largest - range;
+		quic_outq_transmitted_sack(sk, level, largest, smallest, 0, 0);
+	}
+
+	if (type == QUIC_FRAME_ACK_ECN) {
+		if (!quic_get_var(&p, &len, &ecn_count[1]) ||
+		    !quic_get_var(&p, &len, &ecn_count[0]) ||
+		    !quic_get_var(&p, &len, &ecn_count[2]))
+			return -EINVAL;
+		if (quic_pnspace_set_ecn_count(space, ecn_count)) {
+			quic_cong_on_process_ecn(cong);
+			quic_outq_sync_window(sk);
+		}
+	}
+
+	quic_outq_retransmit_mark(sk, level, 0);
+
+	return frame->len - len;
+}
+
+static int quic_frame_new_conn_id_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	struct quic_conn_id_set *id_set = quic_dest(sk);
+	u64 seqno, prior, length, first;
+	u8 *p = frame->data, *token;
+	struct quic_frame *nframe;
+	struct quic_conn_id dcid;
+	u32 len = frame->len;
+	int err;
+
+	if (!quic_get_var(&p, &len, &seqno) ||
+	    !quic_get_var(&p, &len, &prior) ||
+	    !quic_get_var(&p, &len, &length) ||
+	    !length || length > QUIC_CONN_ID_MAX_LEN || length + 16 > len)
+		return -EINVAL;
+
+	memcpy(dcid.data, p, length);
+	dcid.len = length;
+	token = p + length;
+
+	if (prior > seqno)
+		return -EINVAL;
+
+	first = quic_conn_id_first_number(id_set);
+	if (prior < first)
+		prior = first;
+	if (seqno - prior + 1 > quic_conn_id_max_count(id_set)) {
+		frame->errcode = QUIC_TRANSPORT_ERROR_CONNECTION_ID_LIMIT;
+		return -EINVAL;
+	}
+
+	err = quic_conn_id_add(id_set, &dcid, seqno, token);
+	if (err)
+		return err;
+
+	for (; first < prior; first++) {
+		nframe = quic_frame_create(sk, QUIC_FRAME_RETIRE_CONNECTION_ID, &first);
+		if (!nframe)
+			return -ENOMEM;
+		nframe->path_alt = frame->path_alt;
+		quic_outq_ctrl_tail(sk, nframe, true);
+	}
+
+	len -= (length + 16);
+	return frame->len - len;
+}
+
+static int quic_frame_retire_conn_id_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	struct quic_conn_id_set *id_set = quic_source(sk);
+	struct quic_frame *nframe;
+	u64 seqno, last, first;
+	u32 len = frame->len;
+	u8 *p = frame->data;
+
+	if (!quic_get_var(&p, &len, &seqno))
+		return -EINVAL;
+	first = quic_conn_id_first_number(id_set);
+	if (seqno < first) /* dup */
+		goto out;
+	last  = quic_conn_id_last_number(id_set);
+	if (seqno != first || seqno == last) {
+		frame->errcode = QUIC_TRANSPORT_ERROR_PROTOCOL_VIOLATION;
+		return -EINVAL;
+	}
+
+	quic_conn_id_remove(id_set, seqno);
+	if (last - seqno >= quic_conn_id_max_count(id_set))
+		goto out;
+	seqno++;
+	nframe = quic_frame_create(sk, QUIC_FRAME_NEW_CONNECTION_ID, &seqno);
+	if (!nframe)
+		return -ENOMEM;
+	nframe->path_alt = frame->path_alt;
+	quic_outq_ctrl_tail(sk, nframe, true);
+out:
+	return frame->len - len;
+}
+
+static int quic_frame_new_token_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	struct quic_data *token = quic_token(sk);
+	u32 len = frame->len;
+	u8 *p = frame->data;
+	u64 length;
+
+	if (quic_is_serv(sk)) {
+		frame->errcode = QUIC_TRANSPORT_ERROR_PROTOCOL_VIOLATION;
+		return -EINVAL;
+	}
+
+	if (!quic_get_var(&p, &len, &length) || length > len)
+		return -EINVAL;
+
+	if (quic_data_dup(token, p, length))
+		return -ENOMEM;
+
+	if (quic_inq_event_recv(sk, QUIC_EVENT_NEW_TOKEN, token))
+		return -ENOMEM;
+
+	len -= length;
+	return frame->len - len;
+}
+
+static int quic_frame_handshake_done_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	if (quic_is_serv(sk)) {
+		frame->errcode = QUIC_TRANSPORT_ERROR_PROTOCOL_VIOLATION;
+		return -EINVAL;
+	}
+	/* some implementations don't send ACKs to handshake packets, so ACK them manually */
+	quic_outq_transmitted_sack(sk, QUIC_CRYPTO_INITIAL, QUIC_PN_MAP_MAX_PN, 0, 0, 0);
+	quic_outq_transmitted_sack(sk, QUIC_CRYPTO_HANDSHAKE, QUIC_PN_MAP_MAX_PN, 0, 0, 0);
+
+	if (quic_outq_pref_addr(quic_outq(sk)))
+		quic_sock_change_daddr(sk, NULL, 0);
+	return 0; /* no content */
+}
+
+static int quic_frame_padding_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	u8 *p = frame->data;
+
+	for (; !(*p) && p != frame->data + frame->len; p++)
+		;
+	return p - frame->data;
+}
+
+static int quic_frame_ping_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return 0; /* no content */
+}
+
+static int quic_frame_path_challenge_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	struct quic_frame *nframe;
+	u32 len = frame->len;
+	u8 entropy[8];
+
+	if (len < 8)
+		return -EINVAL;
+	memcpy(entropy, frame->data, 8);
+	nframe = quic_frame_create(sk, QUIC_FRAME_PATH_RESPONSE, entropy);
+	if (!nframe)
+		return -ENOMEM;
+	nframe->path_alt = frame->path_alt;
+	quic_outq_ctrl_tail(sk, nframe, true);
+
+	len -= 8;
+	return frame->len - len;
+}
+
+static int quic_frame_reset_stream_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	struct quic_stream_table *streams = quic_streams(sk);
+	struct quic_stream_update update = {};
+	u64 stream_id, errcode, finalsz;
+	struct quic_stream *stream;
+	u32 len = frame->len;
+	u8 *p = frame->data;
+	int err;
+
+	if (!quic_get_var(&p, &len, &stream_id) ||
+	    !quic_get_var(&p, &len, &errcode) ||
+	    !quic_get_var(&p, &len, &finalsz))
+		return -EINVAL;
+
+	stream = quic_stream_recv_get(streams, stream_id, quic_is_serv(sk));
+	if (IS_ERR(stream)) {
+		err = PTR_ERR(stream);
+		if (err == -EAGAIN)
+			frame->errcode = QUIC_TRANSPORT_ERROR_STREAM_LIMIT;
+		else if (err != -ENOMEM)
+			frame->errcode = QUIC_TRANSPORT_ERROR_STREAM_STATE;
+		return err;
+	}
+
+	if (finalsz < stream->recv.highest ||
+	    (stream->recv.finalsz && stream->recv.finalsz != finalsz)) {
+		frame->errcode = QUIC_TRANSPORT_ERROR_FINAL_SIZE;
+		return -EINVAL;
+	}
+
+	update.id = stream_id;
+	update.state = QUIC_STREAM_RECV_STATE_RESET_RECVD;
+	update.errcode = errcode;
+	update.finalsz = finalsz;
+	if (quic_inq_event_recv(sk, QUIC_EVENT_STREAM_UPDATE, &update))
+		return -ENOMEM;
+	stream->recv.state = update.state;
+	stream->recv.finalsz = update.finalsz;
+	quic_inq_stream_purge(sk, stream);
+	return frame->len - len;
+}
+
+static int quic_frame_stop_sending_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	struct quic_stream_table *streams = quic_streams(sk);
+	struct quic_stream_update update = {};
+	struct quic_stream *stream;
+	struct quic_frame *nframe;
+	struct quic_errinfo info;
+	u64 stream_id, errcode;
+	u32 len = frame->len;
+	u8 *p = frame->data;
+	int err;
+
+	if (!quic_get_var(&p, &len, &stream_id) ||
+	    !quic_get_var(&p, &len, &errcode))
+		return -EINVAL;
+
+	stream = quic_stream_send_get(streams, stream_id, 0, quic_is_serv(sk));
+	if (IS_ERR(stream)) {
+		err = PTR_ERR(stream);
+		if (err == -EAGAIN)
+			frame->errcode = QUIC_TRANSPORT_ERROR_STREAM_LIMIT;
+		else if (err != -ENOMEM)
+			frame->errcode = QUIC_TRANSPORT_ERROR_STREAM_STATE;
+		return err;
+	}
+
+	info.stream_id = stream_id;
+	info.errcode = errcode;
+	nframe = quic_frame_create(sk, QUIC_FRAME_RESET_STREAM, &info);
+	if (!nframe)
+		return -ENOMEM;
+
+	update.id = stream_id;
+	update.state = QUIC_STREAM_SEND_STATE_RESET_SENT;
+	update.errcode = errcode;
+	if (quic_inq_event_recv(sk, QUIC_EVENT_STREAM_UPDATE, &update)) {
+		quic_frame_free(nframe);
+		return -ENOMEM;
+	}
+	stream->send.state = update.state;
+	quic_outq_stream_purge(sk, stream);
+	quic_outq_ctrl_tail(sk, nframe, true);
+	return frame->len - len;
+}
+
+static int quic_frame_max_data_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	struct quic_outqueue *outq = quic_outq(sk);
+	u32 len = frame->len;
+	u8 *p = frame->data;
+	u64 max_bytes;
+
+	if (!quic_get_var(&p, &len, &max_bytes))
+		return -EINVAL;
+
+	if (max_bytes >= quic_outq_max_bytes(outq))
+		quic_outq_set_max_bytes(outq, max_bytes);
+
+	return frame->len - len;
+}
+
+static int quic_frame_max_stream_data_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	struct quic_stream_table *streams = quic_streams(sk);
+	struct quic_stream *stream;
+	u64 max_bytes, stream_id;
+	u32 len = frame->len;
+	u8 *p = frame->data;
+	int err;
+
+	if (!quic_get_var(&p, &len, &stream_id) ||
+	    !quic_get_var(&p, &len, &max_bytes))
+		return -EINVAL;
+
+	stream = quic_stream_send_get(streams, stream_id, 0, quic_is_serv(sk));
+	if (IS_ERR(stream)) {
+		err = PTR_ERR(stream);
+		if (err == -EAGAIN)
+			frame->errcode = QUIC_TRANSPORT_ERROR_STREAM_LIMIT;
+		else if (err != -ENOMEM)
+			frame->errcode = QUIC_TRANSPORT_ERROR_STREAM_STATE;
+		return err;
+	}
+
+	if (max_bytes >= stream->send.max_bytes)
+		stream->send.max_bytes = max_bytes;
+
+	return frame->len - len;
+}
+
+static int quic_frame_max_streams_uni_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	struct quic_stream_table *streams = quic_streams(sk);
+	u32 len = frame->len;
+	u8 *p = frame->data;
+	u64 max, stream_id;
+
+	if (!quic_get_var(&p, &len, &max))
+		return -EINVAL;
+
+	if (max < quic_stream_send_max_uni(streams))
+		goto out;
+
+	stream_id = ((max - 1) << 2) | QUIC_STREAM_TYPE_UNI_MASK;
+	if (quic_is_serv(sk))
+		stream_id |= QUIC_STREAM_TYPE_SERVER_MASK;
+	if (quic_inq_event_recv(sk, QUIC_EVENT_STREAM_MAX_STREAM, &stream_id))
+		return -ENOMEM;
+	quic_stream_set_send_max_uni(streams, max);
+	quic_stream_set_send_uni(streams, max);
+	sk->sk_write_space(sk);
+out:
+	return frame->len - len;
+}
+
+static int quic_frame_max_streams_bidi_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	struct quic_stream_table *streams = quic_streams(sk);
+	u32 len = frame->len;
+	u8 *p = frame->data;
+	u64 max, stream_id;
+
+	if (!quic_get_var(&p, &len, &max))
+		return -EINVAL;
+
+	if (max < quic_stream_send_max_bidi(streams))
+		goto out;
+
+	stream_id = ((max - 1) << 2);
+	if (quic_is_serv(sk))
+		stream_id |= QUIC_STREAM_TYPE_SERVER_MASK;
+	if (quic_inq_event_recv(sk, QUIC_EVENT_STREAM_MAX_STREAM, &stream_id))
+		return -ENOMEM;
+	quic_stream_set_send_max_bidi(streams, max);
+	quic_stream_set_send_bidi(streams, max);
+	sk->sk_write_space(sk);
+out:
+	return frame->len - len;
+}
+
+static int quic_frame_connection_close_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	struct quic_connection_close *close;
+	u64 err_code, phrase_len, ftype = 0;
+	u8 *p = frame->data, buf[100] = {};
+	u32 len = frame->len;
+
+	if (!quic_get_var(&p, &len, &err_code))
+		return -EINVAL;
+	if (type == QUIC_FRAME_CONNECTION_CLOSE && !quic_get_var(&p, &len, &ftype))
+		return -EINVAL;
+	if (type == QUIC_FRAME_CONNECTION_CLOSE_APP && frame->level != QUIC_CRYPTO_APP) {
+		frame->errcode = QUIC_TRANSPORT_ERROR_PROTOCOL_VIOLATION;
+		return -EINVAL;
+	}
+
+	if (!quic_get_var(&p, &len, &phrase_len) || phrase_len > len)
+		return -EINVAL;
+
+	close = (void *)buf;
+	if (phrase_len) {
+		if (phrase_len > QUIC_CLOSE_PHRASE_MAX_LEN)
+			return -EINVAL;
+		memcpy(close->phrase, p, phrase_len);
+	}
+	close->errcode = err_code;
+	close->frame = ftype;
+	if (quic_inq_event_recv(sk, QUIC_EVENT_CONNECTION_CLOSE, close))
+		return -ENOMEM;
+	quic_set_state(sk, QUIC_SS_CLOSED);
+	pr_debug("%s: phrase: %d, frame: %d\n", __func__, close->errcode, close->frame);
+
+	len -= phrase_len;
+	return frame->len - len;
+}
+
+static int quic_frame_data_blocked_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	struct quic_inqueue *inq = quic_inq(sk);
+	u64 max_bytes, recv_max_bytes;
+	u32 window, len = frame->len;
+	struct quic_frame *nframe;
+	u8 *p = frame->data;
+
+	if (!quic_get_var(&p, &len, &max_bytes))
+		return -EINVAL;
+	recv_max_bytes = quic_inq_max_bytes(inq);
+
+	window = quic_inq_window(inq);
+	if (sk_under_memory_pressure(sk))
+		window >>= 1;
+
+	quic_inq_set_max_bytes(inq, quic_inq_bytes(inq) + window);
+	nframe = quic_frame_create(sk, QUIC_FRAME_MAX_DATA, inq);
+	if (!nframe) {
+		quic_inq_set_max_bytes(inq, recv_max_bytes);
+		return -ENOMEM;
+	}
+	quic_outq_ctrl_tail(sk, nframe, true);
+	return frame->len - len;
+}
+
+static int quic_frame_stream_data_blocked_process(struct sock *sk, struct quic_frame *frame,
+						  u8 type)
+{
+	struct quic_stream_table *streams = quic_streams(sk);
+	u64 stream_id, max_bytes, recv_max_bytes;
+	u32 window, len = frame->len;
+	struct quic_stream *stream;
+	struct quic_frame *nframe;
+	u8 *p = frame->data;
+	int err;
+
+	if (!quic_get_var(&p, &len, &stream_id) ||
+	    !quic_get_var(&p, &len, &max_bytes))
+		return -EINVAL;
+
+	stream = quic_stream_recv_get(streams, stream_id, quic_is_serv(sk));
+	if (IS_ERR(stream)) {
+		err = PTR_ERR(stream);
+		if (err == -EAGAIN)
+			frame->errcode = QUIC_TRANSPORT_ERROR_STREAM_LIMIT;
+		else if (err != -ENOMEM)
+			frame->errcode = QUIC_TRANSPORT_ERROR_STREAM_STATE;
+		return err;
+	}
+
+	window = stream->recv.window;
+	if (sk_under_memory_pressure(sk))
+		window >>= 1;
+
+	recv_max_bytes = stream->recv.max_bytes;
+	stream->recv.max_bytes = stream->recv.bytes + window;
+	nframe = quic_frame_create(sk, QUIC_FRAME_MAX_STREAM_DATA, stream);
+	if (!nframe) {
+		stream->recv.max_bytes = recv_max_bytes;
+		return -ENOMEM;
+	}
+	quic_outq_ctrl_tail(sk, nframe, true);
+	return frame->len - len;
+}
+
+static int quic_frame_streams_blocked_uni_process(struct sock *sk, struct quic_frame *frame,
+						  u8 type)
+{
+	struct quic_stream_table *streams = quic_streams(sk);
+	struct quic_frame *nframe;
+	u32 len = frame->len;
+	u8 *p = frame->data;
+	u64 max;
+
+	if (!quic_get_var(&p, &len, &max))
+		return -EINVAL;
+	if (max < quic_stream_recv_max_uni(streams))
+		goto out;
+	nframe = quic_frame_create(sk, QUIC_FRAME_MAX_STREAMS_UNI, &max);
+	if (!nframe)
+		return -ENOMEM;
+	quic_outq_ctrl_tail(sk, nframe, true);
+	quic_stream_set_recv_max_uni(streams, max);
+out:
+	return frame->len - len;
+}
+
+static int quic_frame_streams_blocked_bidi_process(struct sock *sk, struct quic_frame *frame,
+						   u8 type)
+{
+	struct quic_stream_table *streams = quic_streams(sk);
+	struct quic_frame *nframe;
+	u32 len = frame->len;
+	u8 *p = frame->data;
+	u64 max;
+
+	if (!quic_get_var(&p, &len, &max))
+		return -EINVAL;
+	if (max < quic_stream_recv_max_bidi(streams))
+		goto out;
+	nframe = quic_frame_create(sk, QUIC_FRAME_MAX_STREAMS_BIDI, &max);
+	if (!nframe)
+		return -ENOMEM;
+	quic_outq_ctrl_tail(sk, nframe, true);
+	quic_stream_set_recv_max_bidi(streams, max);
+out:
+	return frame->len - len;
+}
+
+static int quic_frame_path_response_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	struct quic_path_addr *path;
+	u32 len = frame->len;
+	u8 entropy[8];
+
+	if (len < 8)
+		return -EINVAL;
+	memcpy(entropy, frame->data, 8);
+
+	path = quic_src(sk); /* source address validation */
+	if (!memcmp(quic_path_entropy(path), entropy, 8) && quic_path_sent_cnt(path))
+		quic_outq_validate_path(sk, frame, path);
+
+	path = quic_dst(sk); /* dest address validation */
+	if (!memcmp(quic_path_entropy(path), entropy, 8) && quic_path_sent_cnt(path))
+		quic_outq_validate_path(sk, frame, path);
+
+	len -= 8;
+	return frame->len - len;
+}
+
+static struct quic_frame *quic_frame_invalid_create(struct sock *sk, void *data, u8 type)
+{
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_datagram_create(struct sock *sk, void *data, u8 type)
+{
+	u32 msg_len, hlen = 1, frame_len, max_frame_len;
+	struct iov_iter *msg = data;
+	struct quic_frame *frame;
+	u8 *p;
+
+	max_frame_len = quic_packet_max_payload_dgram(quic_packet(sk));
+	hlen += quic_var_len(max_frame_len);
+
+	msg_len = iov_iter_count(msg);
+	if (msg_len > max_frame_len - hlen)
+		return NULL;
+
+	frame = quic_frame_alloc(msg_len + hlen, NULL, GFP_ATOMIC);
+	if (!frame)
+		return NULL;
+
+	p = quic_put_var(frame->data, type);
+	p = quic_put_var(p, msg_len);
+	frame_len = (u32)(p - frame->data);
+
+	if (!quic_frame_copy_from_iter_full(p, msg_len, msg)) {
+		quic_frame_free(frame);
+		return NULL;
+	}
+
+	frame->bytes = msg_len;
+	frame_len += msg_len;
+	frame->len = frame_len;
+	return frame;
+}
+
+static int quic_frame_invalid_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	frame->errcode = QUIC_TRANSPORT_ERROR_FRAME_ENCODING;
+	return -EPROTONOSUPPORT;
+}
+
+static int quic_frame_datagram_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	struct quic_inqueue *inq = quic_inq(sk);
+	struct quic_frame *nframe;
+	u32 len = frame->len;
+	u8 *p = frame->data;
+	u64 payload_len;
+	int err;
+
+	payload_len = frame->len;
+	if (type == QUIC_FRAME_DATAGRAM_LEN) {
+		if (!quic_get_var(&p, &len, &payload_len) || payload_len > len)
+			return -EINVAL;
+	}
+
+	if (payload_len + (p - frame->data) + 1 > quic_inq_max_dgram(inq)) {
+		frame->errcode = QUIC_TRANSPORT_ERROR_PROTOCOL_VIOLATION;
+		return -EINVAL;
+	}
+
+	nframe = quic_frame_alloc(payload_len, p, GFP_ATOMIC);
+	if (!nframe)
+		return -ENOMEM;
+	nframe->skb = skb_get(frame->skb);
+
+	err = quic_inq_dgram_recv(sk, nframe);
+	if (err) {
+		quic_inq_rfree(nframe->len, sk);
+		quic_frame_free(nframe);
+		return err;
+	}
+
+	len -= payload_len;
+	return frame->len - len;
+}
+
+#define quic_frame_create_and_process(type) \
+	{ .frame_create = quic_frame_##type##_create, .frame_process = quic_frame_##type##_process }
+
+static struct quic_frame_ops quic_frame_ops[QUIC_FRAME_MAX + 1] = {
+	quic_frame_create_and_process(padding), /* 0x00 */
+	quic_frame_create_and_process(ping),
+	quic_frame_create_and_process(ack),
+	quic_frame_create_and_process(ack), /* ack_ecn */
+	quic_frame_create_and_process(reset_stream),
+	quic_frame_create_and_process(stop_sending),
+	quic_frame_create_and_process(crypto),
+	quic_frame_create_and_process(new_token),
+	quic_frame_create_and_process(stream),
+	quic_frame_create_and_process(stream),
+	quic_frame_create_and_process(stream),
+	quic_frame_create_and_process(stream),
+	quic_frame_create_and_process(stream),
+	quic_frame_create_and_process(stream),
+	quic_frame_create_and_process(stream),
+	quic_frame_create_and_process(stream),
+	quic_frame_create_and_process(max_data), /* 0x10 */
+	quic_frame_create_and_process(max_stream_data),
+	quic_frame_create_and_process(max_streams_bidi),
+	quic_frame_create_and_process(max_streams_uni),
+	quic_frame_create_and_process(data_blocked),
+	quic_frame_create_and_process(stream_data_blocked),
+	quic_frame_create_and_process(streams_blocked_bidi),
+	quic_frame_create_and_process(streams_blocked_uni),
+	quic_frame_create_and_process(new_conn_id),
+	quic_frame_create_and_process(retire_conn_id),
+	quic_frame_create_and_process(path_challenge),
+	quic_frame_create_and_process(path_response),
+	quic_frame_create_and_process(connection_close),
+	quic_frame_create_and_process(connection_close),
+	quic_frame_create_and_process(handshake_done),
+	quic_frame_create_and_process(invalid),
+	quic_frame_create_and_process(invalid), /* 0x20 */
+	quic_frame_create_and_process(invalid),
+	quic_frame_create_and_process(invalid),
+	quic_frame_create_and_process(invalid),
+	quic_frame_create_and_process(invalid),
+	quic_frame_create_and_process(invalid),
+	quic_frame_create_and_process(invalid),
+	quic_frame_create_and_process(invalid),
+	quic_frame_create_and_process(invalid),
+	quic_frame_create_and_process(invalid),
+	quic_frame_create_and_process(invalid),
+	quic_frame_create_and_process(invalid),
+	quic_frame_create_and_process(invalid),
+	quic_frame_create_and_process(invalid),
+	quic_frame_create_and_process(invalid),
+	quic_frame_create_and_process(invalid),
+	quic_frame_create_and_process(datagram), /* 0x30 */
+	quic_frame_create_and_process(datagram),
+};
+
+int quic_frame_process(struct sock *sk, struct quic_frame *frame)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	u8 type, level = frame->level;
+	int ret;
+
+	if (!frame->len) {
+		packet->errcode = QUIC_TRANSPORT_ERROR_PROTOCOL_VIOLATION;
+		return -EINVAL;
+	}
+
+	while (frame->len > 0) {
+		type = *frame->data++;
+		frame->len--;
+
+		if (type > QUIC_FRAME_MAX) {
+			pr_debug("%s: unsupported frame, type: %x, level: %d\n",
+				 __func__, type, level);
+			packet->errcode = QUIC_TRANSPORT_ERROR_FRAME_ENCODING;
+			return -EPROTONOSUPPORT;
+		} else if (quic_frame_level_check(level, type)) {
+			pr_debug("%s: invalid frame, type: %x, level: %d\n",
+				 __func__, type, level);
+			packet->errcode = QUIC_TRANSPORT_ERROR_PROTOCOL_VIOLATION;
+			return -EINVAL;
+		}
+		ret = quic_frame_ops[type].frame_process(sk, frame, type);
+		if (ret < 0) {
+			pr_debug("%s: failed, type: %x, level: %d, err: %d\n",
+				 __func__, type, level, ret);
+			frame->type = type;
+			packet->errcode = frame->errcode;
+			return ret;
+		}
+		pr_debug("%s: done, type: %x, level: %d\n", __func__, type, level);
+		if (quic_frame_ack_eliciting(type)) {
+			packet->ack_eliciting = 1;
+			if (quic_frame_ack_immediate(type))
+				packet->ack_immediate = 1;
+		}
+		if (quic_frame_non_probing(type))
+			packet->non_probing = 1;
+
+		frame->data += ret;
+		frame->len -= ret;
+	}
+	return 0;
+}
+
+struct quic_frame *quic_frame_create(struct sock *sk, u8 type, void *data)
+{
+	struct quic_frame *frame;
+
+	if (type > QUIC_FRAME_MAX)
+		return NULL;
+	frame = quic_frame_ops[type].frame_create(sk, data, type);
+	if (!frame) {
+		pr_debug("%s: failed, type: %x\n", __func__, type);
+		return NULL;
+	}
+	pr_debug("%s: done, type: %x, len: %u\n", __func__, type, frame->len);
+	if (!frame->type)
+		frame->type = type;
+	return frame;
+}
+
+static int quic_frame_get_conn_id(struct quic_conn_id *conn_id, u8 **pp, u32 *plen)
+{
+	u64 valuelen;
+
+	if (!quic_get_var(pp, plen, &valuelen))
+		return -1;
+
+	if (*plen < valuelen || valuelen > QUIC_CONN_ID_MAX_LEN)
+		return -1;
+
+	memcpy(conn_id->data, *pp, valuelen);
+	conn_id->len = valuelen;
+
+	*pp += valuelen;
+	*plen -= valuelen;
+	return 0;
+}
+
+static int quic_frame_get_version_info(u32 *versions, u8 *count, u8 **pp, u32 *plen)
+{
+	u64 valuelen, v;
+	u8 i;
+
+	if (!quic_get_var(pp, plen, &valuelen))
+		return -1;
+
+	if (*plen < valuelen || valuelen > 64)
+		return -1;
+
+	*count = valuelen / 4;
+	for (i = 0; i < *count; i++) {
+		quic_get_int(pp, plen, &v, 4);
+		versions[i] = v;
+	}
+	return 0;
+}
+
+static int quic_frame_get_address(union quic_addr *addr, struct quic_conn_id *conn_id,
+				  u8 *token, u8 **pp, u32 *plen, struct sock *sk)
+{
+	u64 valuelen;
+	u8 *p, len;
+
+	if (!quic_get_var(pp, plen, &valuelen))
+		return -1;
+
+	if (*plen < valuelen || valuelen < 25)
+		return -1;
+
+	quic_get_pref_addr(sk, addr, pp, plen);
+
+	p = *pp;
+	len = *p;
+	if (!len || len > QUIC_CONN_ID_MAX_LEN || valuelen != 25 + len + 16)
+		return -1;
+	conn_id->len = len;
+	p++;
+	memcpy(conn_id->data, p, len);
+	p += len;
+
+	memcpy(token, p, 16);
+	p += 16;
+
+	*pp = p;
+	*plen -= (17 + len);
+	return 0;
+}
+
+int quic_frame_set_transport_params_ext(struct sock *sk, struct quic_transport_param *params,
+					u8 *data, u32 len)
+{
+	struct quic_conn_id_set *id_set = quic_dest(sk);
+	struct quic_outqueue *outq = quic_outq(sk);
+	struct quic_conn_id *active, conn_id;
+	u8 *p = data, count = 0, token[16];
+	union quic_addr addr = {};
+	u64 type, valuelen;
+	u32 versions[16];
+
+	params->max_udp_payload_size = QUIC_MAX_UDP_PAYLOAD;
+	params->ack_delay_exponent = QUIC_DEF_ACK_DELAY_EXPONENT;
+	params->max_ack_delay = QUIC_DEF_ACK_DELAY;
+	params->active_connection_id_limit = QUIC_CONN_ID_LEAST;
+	active = quic_conn_id_active(id_set);
+
+	while (len > 0) {
+		if (!quic_get_var(&p, &len, &type))
+			return -1;
+
+		switch (type) {
+		case QUIC_TRANSPORT_PARAM_ORIGINAL_DESTINATION_CONNECTION_ID:
+			if (quic_is_serv(sk))
+				return -1;
+			if (quic_frame_get_conn_id(&conn_id, &p, &len))
+				return -1;
+			if (quic_conn_id_cmp(quic_outq_orig_dcid(outq), &conn_id))
+				return -1;
+			break;
+		case QUIC_TRANSPORT_PARAM_RETRY_SOURCE_CONNECTION_ID:
+			if (quic_is_serv(sk))
+				return -1;
+			if (quic_frame_get_conn_id(&conn_id, &p, &len))
+				return -1;
+			if (quic_conn_id_cmp(quic_outq_retry_dcid(outq), &conn_id))
+				return -1;
+			break;
+		case QUIC_TRANSPORT_PARAM_INITIAL_SOURCE_CONNECTION_ID:
+			if (quic_frame_get_conn_id(&conn_id, &p, &len))
+				return -1;
+			if (quic_conn_id_cmp(active, &conn_id))
+				return -1;
+			break;
+		case QUIC_TRANSPORT_PARAM_INITIAL_MAX_STREAM_DATA_BIDI_LOCAL:
+			if (quic_get_param(&params->max_stream_data_bidi_local, &p, &len))
+				return -1;
+			break;
+		case QUIC_TRANSPORT_PARAM_INITIAL_MAX_STREAM_DATA_BIDI_REMOTE:
+			if (quic_get_param(&params->max_stream_data_bidi_remote, &p, &len))
+				return -1;
+			break;
+		case QUIC_TRANSPORT_PARAM_INITIAL_MAX_STREAM_DATA_UNI:
+			if (quic_get_param(&params->max_stream_data_uni, &p, &len))
+				return -1;
+			break;
+		case QUIC_TRANSPORT_PARAM_INITIAL_MAX_DATA:
+			if (quic_get_param(&params->max_data, &p, &len))
+				return -1;
+			break;
+		case QUIC_TRANSPORT_PARAM_INITIAL_MAX_STREAMS_BIDI:
+			if (quic_get_param(&params->max_streams_bidi, &p, &len))
+				return -1;
+			if (params->max_streams_bidi > QUIC_MAX_STREAMS)
+				return -1;
+			break;
+		case QUIC_TRANSPORT_PARAM_INITIAL_MAX_STREAMS_UNI:
+			if (quic_get_param(&params->max_streams_uni, &p, &len))
+				return -1;
+			if (params->max_streams_uni > QUIC_MAX_STREAMS)
+				return -1;
+			break;
+		case QUIC_TRANSPORT_PARAM_MAX_IDLE_TIMEOUT:
+			if (quic_get_param(&params->max_idle_timeout, &p, &len))
+				return -1;
+			params->max_idle_timeout *= 1000;
+			break;
+		case QUIC_TRANSPORT_PARAM_MAX_UDP_PAYLOAD_SIZE:
+			if (quic_get_param(&params->max_udp_payload_size, &p, &len))
+				return -1;
+			break;
+		case QUIC_TRANSPORT_PARAM_ACK_DELAY_EXPONENT:
+			if (quic_get_param(&params->ack_delay_exponent, &p, &len))
+				return -1;
+			if (params->ack_delay_exponent > QUIC_MAX_ACK_DELAY_EXPONENT)
+				return -1;
+			break;
+		case QUIC_TRANSPORT_PARAM_DISABLE_ACTIVE_MIGRATION:
+			if (!quic_get_var(&p, &len, &valuelen))
+				return -1;
+			if (valuelen)
+				return -1;
+			params->disable_active_migration = 1;
+			break;
+		case QUIC_TRANSPORT_PARAM_DISABLE_1RTT_ENCRYPTION:
+			if (!quic_get_var(&p, &len, &valuelen))
+				return -1;
+			if (!quic_is_serv(sk) && valuelen)
+				return -1;
+			params->disable_1rtt_encryption = 1;
+			len -= valuelen;
+			p += valuelen;
+			break;
+		case QUIC_TRANSPORT_PARAM_GREASE_QUIC_BIT:
+			if (!quic_get_var(&p, &len, &valuelen))
+				return -1;
+			if (valuelen)
+				return -1;
+			params->grease_quic_bit = 1;
+			break;
+		case QUIC_TRANSPORT_PARAM_MAX_ACK_DELAY:
+			if (quic_get_param(&params->max_ack_delay, &p, &len))
+				return -1;
+			params->max_ack_delay *= 1000;
+			if (params->max_ack_delay >= QUIC_MAX_ACK_DELAY)
+				return -1;
+			break;
+		case QUIC_TRANSPORT_PARAM_ACTIVE_CONNECTION_ID_LIMIT:
+			if (quic_get_param(&params->active_connection_id_limit, &p, &len) ||
+			    params->active_connection_id_limit < QUIC_CONN_ID_LEAST)
+				return -1;
+			break;
+		case QUIC_TRANSPORT_PARAM_MAX_DATAGRAM_FRAME_SIZE:
+			if (quic_get_param(&params->max_datagram_frame_size, &p, &len))
+				return -1;
+			break;
+		case QUIC_TRANSPORT_PARAM_STATELESS_RESET_TOKEN:
+			if (quic_is_serv(sk))
+				return -1;
+			if (!quic_get_var(&p, &len, &valuelen) || len < valuelen ||
+			    valuelen != 16)
+				return -1;
+			quic_conn_id_set_token(active, p);
+			params->stateless_reset = 1;
+			len -= valuelen;
+			p += valuelen;
+			break;
+		case QUIC_TRANSPORT_PARAM_VERSION_INFORMATION:
+			if (quic_frame_get_version_info(versions, &count, &p, &len))
+				return -1;
+			if (!count || quic_packet_select_version(sk, versions, count))
+				return -1;
+			break;
+		case QUIC_TRANSPORT_PARAM_PREFERRED_ADDRESS:
+			if (quic_is_serv(sk))
+				return -1;
+			if (quic_frame_get_address(&addr, &conn_id, token, &p, &len, sk))
+				return -1;
+			if (!addr.v4.sin_port)
+				break;
+			if (quic_conn_id_add(id_set, &conn_id, 1, token))
+				return -1;
+			quic_outq_set_pref_addr(outq, 1);
+			quic_path_addr_set(quic_dst(sk), &addr, 1);
+			break;
+		default:
+			/* Ignore unknown parameter */
+			if (!quic_get_var(&p, &len, &valuelen))
+				return -1;
+			if (len < valuelen)
+				return -1;
+			len -= valuelen;
+			p += valuelen;
+			break;
+		}
+	}
+	return 0;
+}
+
+static u8 *quic_frame_put_conn_id(u8 *p, u16 id, struct quic_conn_id *conn_id)
+{
+	p = quic_put_var(p, id);
+	p = quic_put_var(p, conn_id->len);
+	p = quic_put_data(p, conn_id->data, conn_id->len);
+	return p;
+}
+
+static u8 *quic_frame_put_version_info(u8 *p, u16 id, u32 version)
+{
+	u32 *versions, i, len = 4;
+
+	versions = quic_packet_compatible_versions(version);
+	if (!versions)
+		return p;
+
+	for (i = 0; versions[i]; i++)
+		len += 4;
+	p = quic_put_var(p, id);
+	p = quic_put_var(p, len);
+	p = quic_put_int(p, version, 4);
+
+	for (i = 0; versions[i]; i++)
+		p = quic_put_int(p, versions[i], 4);
+
+	return p;
+}
+
+static u8 *quic_frame_put_address(u8 *p, u16 id, union quic_addr *addr,
+				  struct quic_conn_id *conn_id, u8 *token, struct sock *sk)
+{
+	p = quic_put_var(p, id);
+	p = quic_put_var(p, (4 + 2 + 16 + 2) + 1 + conn_id->len + 16);
+	quic_set_pref_addr(sk, p, addr);
+	p += (4 + 2 + 16 + 2);
+
+	p = quic_put_int(p, conn_id->len, 1);
+	p = quic_put_data(p, conn_id->data, conn_id->len);
+	p = quic_put_data(p, token, 16);
+	return p;
+}
+
+int quic_frame_get_transport_params_ext(struct sock *sk, struct quic_transport_param *params,
+					u8 *data, u32 *len)
+{
+	struct quic_conn_id_set *id_set = quic_source(sk);
+	struct quic_outqueue *outq = quic_outq(sk);
+	struct quic_conn_id *scid, conn_id;
+	struct quic_crypto *crypto;
+	u8 *p = data, token[16];
+	u16 param_id;
+
+	scid = quic_conn_id_active(id_set);
+	if (quic_is_serv(sk)) {
+		crypto = quic_crypto(sk, QUIC_CRYPTO_INITIAL);
+		param_id = QUIC_TRANSPORT_PARAM_ORIGINAL_DESTINATION_CONNECTION_ID;
+		p = quic_frame_put_conn_id(p, param_id, quic_outq_orig_dcid(outq));
+		if (params->stateless_reset) {
+			p = quic_put_var(p, QUIC_TRANSPORT_PARAM_STATELESS_RESET_TOKEN);
+			p = quic_put_var(p, 16);
+			if (quic_crypto_generate_stateless_reset_token(crypto, scid->data,
+								       scid->len, token, 16))
+				return -1;
+			p = quic_put_data(p, token, 16);
+		}
+		if (quic_outq_retry(outq)) {
+			param_id = QUIC_TRANSPORT_PARAM_RETRY_SOURCE_CONNECTION_ID;
+			p = quic_frame_put_conn_id(p, param_id, quic_outq_retry_dcid(outq));
+		}
+		if (quic_outq_pref_addr(outq)) {
+			quic_conn_id_generate(&conn_id);
+			if (quic_crypto_generate_stateless_reset_token(crypto, conn_id.data,
+								       conn_id.len, token, 16))
+				return -1;
+			if (quic_conn_id_add(id_set, &conn_id, 1, sk))
+				return -1;
+			param_id = QUIC_TRANSPORT_PARAM_PREFERRED_ADDRESS;
+			p = quic_frame_put_address(p, param_id, quic_path_addr(quic_src(sk), 1),
+						   &conn_id, token, sk);
+		}
+	}
+	p = quic_frame_put_conn_id(p, QUIC_TRANSPORT_PARAM_INITIAL_SOURCE_CONNECTION_ID, scid);
+	if (params->max_stream_data_bidi_local) {
+		p = quic_put_param(p, QUIC_TRANSPORT_PARAM_INITIAL_MAX_STREAM_DATA_BIDI_LOCAL,
+				   params->max_stream_data_bidi_local);
+	}
+	if (params->max_stream_data_bidi_remote) {
+		p = quic_put_param(p, QUIC_TRANSPORT_PARAM_INITIAL_MAX_STREAM_DATA_BIDI_REMOTE,
+				   params->max_stream_data_bidi_remote);
+	}
+	if (params->max_stream_data_uni) {
+		p = quic_put_param(p, QUIC_TRANSPORT_PARAM_INITIAL_MAX_STREAM_DATA_UNI,
+				   params->max_stream_data_uni);
+	}
+	if (params->max_data) {
+		p = quic_put_param(p, QUIC_TRANSPORT_PARAM_INITIAL_MAX_DATA,
+				   params->max_data);
+	}
+	if (params->max_streams_bidi) {
+		p = quic_put_param(p, QUIC_TRANSPORT_PARAM_INITIAL_MAX_STREAMS_BIDI,
+				   params->max_streams_bidi);
+	}
+	if (params->max_streams_uni) {
+		p = quic_put_param(p, QUIC_TRANSPORT_PARAM_INITIAL_MAX_STREAMS_UNI,
+				   params->max_streams_uni);
+	}
+	if (params->max_udp_payload_size != QUIC_MAX_UDP_PAYLOAD) {
+		p = quic_put_param(p, QUIC_TRANSPORT_PARAM_MAX_UDP_PAYLOAD_SIZE,
+				   params->max_udp_payload_size);
+	}
+	if (params->ack_delay_exponent != 3) {
+		p = quic_put_param(p, QUIC_TRANSPORT_PARAM_ACK_DELAY_EXPONENT,
+				   params->ack_delay_exponent);
+	}
+	if (params->disable_active_migration) {
+		p = quic_put_var(p, QUIC_TRANSPORT_PARAM_DISABLE_ACTIVE_MIGRATION);
+		p = quic_put_var(p, 0);
+	}
+	if (params->disable_1rtt_encryption) {
+		p = quic_put_var(p, QUIC_TRANSPORT_PARAM_DISABLE_1RTT_ENCRYPTION);
+		p = quic_put_var(p, 0);
+	}
+	if (!params->disable_compatible_version) {
+		p = quic_frame_put_version_info(p, QUIC_TRANSPORT_PARAM_VERSION_INFORMATION,
+						quic_config(sk)->version);
+	}
+	if (params->grease_quic_bit) {
+		p = quic_put_var(p, QUIC_TRANSPORT_PARAM_GREASE_QUIC_BIT);
+		p = quic_put_var(p, 0);
+	}
+	if (params->max_ack_delay != QUIC_DEF_ACK_DELAY) {
+		p = quic_put_param(p, QUIC_TRANSPORT_PARAM_MAX_ACK_DELAY,
+				   params->max_ack_delay / 1000);
+	}
+	if (params->max_idle_timeout) {
+		p = quic_put_param(p, QUIC_TRANSPORT_PARAM_MAX_IDLE_TIMEOUT,
+				   params->max_idle_timeout / 1000);
+	}
+	if (params->active_connection_id_limit &&
+	    params->active_connection_id_limit != QUIC_CONN_ID_LEAST) {
+		p = quic_put_param(p, QUIC_TRANSPORT_PARAM_ACTIVE_CONNECTION_ID_LIMIT,
+				   params->active_connection_id_limit);
+	}
+	if (params->max_datagram_frame_size) {
+		p = quic_put_param(p, QUIC_TRANSPORT_PARAM_MAX_DATAGRAM_FRAME_SIZE,
+				   params->max_datagram_frame_size);
+	}
+	*len = p - data;
+	return 0;
+}
+
+struct quic_frame *quic_frame_alloc(unsigned int size, u8 *data, gfp_t gfp)
+{
+	struct quic_frame *frame;
+
+	frame = kmem_cache_zalloc(quic_frame_cachep, gfp);
+	if (!frame)
+		return NULL;
+	if (data) {
+		frame->data = data;
+		goto out;
+	}
+	frame->data = kmalloc(size, gfp);
+	if (!frame->data) {
+		kmem_cache_free(quic_frame_cachep, frame);
+		return NULL;
+	}
+out:
+	frame->len  = size;
+	return frame;
+}
+
+void quic_frame_free(struct quic_frame *frame)
+{
+	if (!frame->type && frame->skb) /* type is 0 on rx path */
+		kfree_skb(frame->skb);
+	else
+		kfree(frame->data);
+	kmem_cache_free(quic_frame_cachep, frame);
+}
diff --git a/net/quic/frame.h b/net/quic/frame.h
new file mode 100644
index 000000000000..427605501739
--- /dev/null
+++ b/net/quic/frame.h
@@ -0,0 +1,198 @@
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
+#define QUIC_CLOSE_PHRASE_MAX_LEN	80
+
+enum {
+	QUIC_FRAME_PADDING = 0x00,
+	QUIC_FRAME_PING = 0x01,
+	QUIC_FRAME_ACK = 0x02,
+	QUIC_FRAME_ACK_ECN = 0x03,
+	QUIC_FRAME_RESET_STREAM = 0x04,
+	QUIC_FRAME_STOP_SENDING = 0x05,
+	QUIC_FRAME_CRYPTO = 0x06,
+	QUIC_FRAME_NEW_TOKEN = 0x07,
+	QUIC_FRAME_STREAM = 0x08,
+	QUIC_FRAME_MAX_DATA = 0x10,
+	QUIC_FRAME_MAX_STREAM_DATA = 0x11,
+	QUIC_FRAME_MAX_STREAMS_BIDI = 0x12,
+	QUIC_FRAME_MAX_STREAMS_UNI = 0x13,
+	QUIC_FRAME_DATA_BLOCKED = 0x14,
+	QUIC_FRAME_STREAM_DATA_BLOCKED = 0x15,
+	QUIC_FRAME_STREAMS_BLOCKED_BIDI = 0x16,
+	QUIC_FRAME_STREAMS_BLOCKED_UNI = 0x17,
+	QUIC_FRAME_NEW_CONNECTION_ID = 0x18,
+	QUIC_FRAME_RETIRE_CONNECTION_ID = 0x19,
+	QUIC_FRAME_PATH_CHALLENGE = 0x1a,
+	QUIC_FRAME_PATH_RESPONSE = 0x1b,
+	QUIC_FRAME_CONNECTION_CLOSE = 0x1c,
+	QUIC_FRAME_CONNECTION_CLOSE_APP = 0x1d,
+	QUIC_FRAME_HANDSHAKE_DONE = 0x1e,
+	QUIC_FRAME_DATAGRAM = 0x30, /* RFC 9221 */
+	QUIC_FRAME_DATAGRAM_LEN = 0x31,
+	QUIC_FRAME_MAX = QUIC_FRAME_DATAGRAM_LEN,
+};
+
+enum {
+	QUIC_TRANSPORT_ERROR_NONE,
+	QUIC_TRANSPORT_ERROR_INTERNAL,
+	QUIC_TRANSPORT_ERROR_CONNECTION_REFUSED,
+	QUIC_TRANSPORT_ERROR_FLOW_CONTROL,
+	QUIC_TRANSPORT_ERROR_STREAM_LIMIT,
+	QUIC_TRANSPORT_ERROR_STREAM_STATE,
+	QUIC_TRANSPORT_ERROR_FINAL_SIZE,
+	QUIC_TRANSPORT_ERROR_FRAME_ENCODING,
+	QUIC_TRANSPORT_ERROR_TRANSPORT_PARAM,
+	QUIC_TRANSPORT_ERROR_CONNECTION_ID_LIMIT,
+	QUIC_TRANSPORT_ERROR_PROTOCOL_VIOLATION,
+	QUIC_TRANSPORT_ERROR_INVALID_TOKEN,
+	QUIC_TRANSPORT_ERROR_APPLICATION,
+	QUIC_TRANSPORT_ERROR_CRYPTO_BUF_EXCEEDED,
+	QUIC_TRANSPORT_ERROR_KEY_UPDATE,
+	QUIC_TRANSPORT_ERROR_AEAD_LIMIT_REACHED,
+	QUIC_TRANSPORT_ERROR_NO_VIABLE_PATH,
+
+	/* The cryptographic handshake failed. A range of 256 values is reserved
+	 * for carrying error codes specific to the cryptographic handshake that
+	 * is used. Codes for errors occurring when TLS is used for the
+	 * cryptographic handshake are described in Section 4.8 of [QUIC-TLS].
+	 */
+	QUIC_TRANSPORT_ERROR_CRYPTO = 0x0100,
+};
+
+enum {
+	QUIC_TRANSPORT_PARAM_ORIGINAL_DESTINATION_CONNECTION_ID = 0x0000,
+	QUIC_TRANSPORT_PARAM_MAX_IDLE_TIMEOUT = 0x0001,
+	QUIC_TRANSPORT_PARAM_STATELESS_RESET_TOKEN = 0x0002,
+	QUIC_TRANSPORT_PARAM_MAX_UDP_PAYLOAD_SIZE = 0x0003,
+	QUIC_TRANSPORT_PARAM_INITIAL_MAX_DATA = 0x0004,
+	QUIC_TRANSPORT_PARAM_INITIAL_MAX_STREAM_DATA_BIDI_LOCAL = 0x0005,
+	QUIC_TRANSPORT_PARAM_INITIAL_MAX_STREAM_DATA_BIDI_REMOTE = 0x0006,
+	QUIC_TRANSPORT_PARAM_INITIAL_MAX_STREAM_DATA_UNI = 0x0007,
+	QUIC_TRANSPORT_PARAM_INITIAL_MAX_STREAMS_BIDI = 0x0008,
+	QUIC_TRANSPORT_PARAM_INITIAL_MAX_STREAMS_UNI = 0x0009,
+	QUIC_TRANSPORT_PARAM_ACK_DELAY_EXPONENT = 0x000a,
+	QUIC_TRANSPORT_PARAM_MAX_ACK_DELAY = 0x000b,
+	QUIC_TRANSPORT_PARAM_DISABLE_ACTIVE_MIGRATION = 0x000c,
+	QUIC_TRANSPORT_PARAM_PREFERRED_ADDRESS = 0x000d,
+	QUIC_TRANSPORT_PARAM_ACTIVE_CONNECTION_ID_LIMIT = 0x000e,
+	QUIC_TRANSPORT_PARAM_INITIAL_SOURCE_CONNECTION_ID = 0x000f,
+	QUIC_TRANSPORT_PARAM_RETRY_SOURCE_CONNECTION_ID = 0x0010,
+	QUIC_TRANSPORT_PARAM_MAX_DATAGRAM_FRAME_SIZE = 0x0020,
+	QUIC_TRANSPORT_PARAM_GREASE_QUIC_BIT = 0x2ab2,
+	QUIC_TRANSPORT_PARAM_VERSION_INFORMATION = 0x11,
+	QUIC_TRANSPORT_PARAM_DISABLE_1RTT_ENCRYPTION = 0xbaad,
+};
+
+struct quic_msginfo {
+	struct quic_stream *stream;
+	struct iov_iter *msg;
+	u32 flags;
+	u8 level;
+};
+
+struct quic_frame_ops {
+	struct quic_frame *(*frame_create)(struct sock *sk, void *data, u8 type);
+	int (*frame_process)(struct sock *sk, struct quic_frame *frame, u8 type);
+};
+
+struct quic_frame {
+	struct quic_stream *stream;
+	struct list_head list;
+	union {
+		struct sk_buff *skb;
+		s64 number;
+	};
+	u64 offset;	/* stream/crypto/read offset or first number */
+	u8  *data;
+	u16 bytes;	/* user data bytes */
+	u8  level;
+	u8  type;
+	u16 len;	/* data length */
+
+	u8  path_alt:2;	/* bit 1: src, bit 2: dst */
+
+	u32 sent_time;
+	u16 errcode;
+	u8  event;
+
+	u8  stream_fin:1;
+	u8  padding:1;
+	u8  dgram:1;
+	u8  first:1;
+	u8  last:1;
+	u8  ecn:2;
+};
+
+static inline bool quic_frame_ack_eliciting(u8 type)
+{
+	return type != QUIC_FRAME_ACK && type != QUIC_FRAME_ACK_ECN &&
+	       type != QUIC_FRAME_PADDING && type != QUIC_FRAME_PATH_RESPONSE &&
+	       type != QUIC_FRAME_CONNECTION_CLOSE && type != QUIC_FRAME_CONNECTION_CLOSE_APP;
+}
+
+static inline bool quic_frame_retransmittable(u8 type)
+{
+	return quic_frame_ack_eliciting(type) &&
+	       type != QUIC_FRAME_PING && type != QUIC_FRAME_PATH_CHALLENGE;
+}
+
+static inline bool quic_frame_ack_immediate(u8 type)
+{
+	return (type < QUIC_FRAME_STREAM || type >= QUIC_FRAME_MAX_DATA) ||
+	       (type & QUIC_STREAM_BIT_FIN);
+}
+
+static inline bool quic_frame_non_probing(u8 type)
+{
+	return type != QUIC_FRAME_NEW_CONNECTION_ID && type != QUIC_FRAME_PADDING &&
+	       type != QUIC_FRAME_PATH_RESPONSE && type != QUIC_FRAME_PATH_CHALLENGE;
+}
+
+static inline bool quic_frame_is_crypto(u8 type)
+{
+	return type == QUIC_FRAME_CRYPTO;
+}
+
+static inline bool quic_frame_is_dgram(u8 type)
+{
+	return type == QUIC_FRAME_DATAGRAM || type == QUIC_FRAME_DATAGRAM_LEN;
+}
+
+static inline int quic_frame_level_check(u8 level, u8 type)
+{
+	if (level == QUIC_CRYPTO_APP)
+		return 0;
+
+	if (level == QUIC_CRYPTO_EARLY) {
+		if (type == QUIC_FRAME_ACK || type == QUIC_FRAME_ACK_ECN ||
+		    type == QUIC_FRAME_CRYPTO || type == QUIC_FRAME_HANDSHAKE_DONE ||
+		    type == QUIC_FRAME_NEW_TOKEN || type == QUIC_FRAME_PATH_RESPONSE ||
+		    type == QUIC_FRAME_RETIRE_CONNECTION_ID)
+			return 1;
+		return 0;
+	}
+
+	if (type != QUIC_FRAME_ACK && type != QUIC_FRAME_ACK_ECN &&
+	    type != QUIC_FRAME_PADDING && type != QUIC_FRAME_PING &&
+	    type != QUIC_FRAME_CRYPTO && type != QUIC_FRAME_CONNECTION_CLOSE)
+		return 1;
+	return 0;
+}
+
+int quic_frame_get_transport_params_ext(struct sock *sk, struct quic_transport_param *params,
+					u8 *data, u32 *len);
+int quic_frame_set_transport_params_ext(struct sock *sk, struct quic_transport_param *params,
+					u8 *data, u32 len);
+struct quic_frame *quic_frame_alloc(unsigned int size, u8 *data, gfp_t gfp);
+void quic_frame_free(struct quic_frame *frame);
+
+struct quic_frame *quic_frame_create(struct sock *sk, u8 type, void *data);
+int quic_frame_process(struct sock *sk, struct quic_frame *frame);
diff --git a/net/quic/hashtable.h b/net/quic/hashtable.h
new file mode 100644
index 000000000000..52b6e5c291a5
--- /dev/null
+++ b/net/quic/hashtable.h
@@ -0,0 +1,145 @@
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
+struct quichdr {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 pnl:2,
+	     key:1,
+	     reserved:2,
+	     spin:1,
+	     fixed:1,
+	     form:1;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	__u8 form:1,
+	     fixed:1,
+	     spin:1,
+	     reserved:2,
+	     key:1,
+	     pnl:2;
+#endif
+};
+
+static inline struct quichdr *quic_hdr(struct sk_buff *skb)
+{
+	return (struct quichdr *)skb_transport_header(skb);
+}
+
+struct quichshdr {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 pnl:2,
+	     reserved:2,
+	     type:2,
+	     fixed:1,
+	     form:1;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	__u8 form:1,
+	     fixed:1,
+	     type:2,
+	     reserved:2,
+	     pnl:2;
+#endif
+};
+
+static inline struct quichshdr *quic_hshdr(struct sk_buff *skb)
+{
+	return (struct quichshdr *)skb_transport_header(skb);
+}
+
+union quic_addr {
+	struct sockaddr_in6 v6;
+	struct sockaddr_in v4;
+	struct sockaddr sa;
+};
+
+static inline union quic_addr *quic_addr(const void *addr)
+{
+	return (union quic_addr *)addr;
+}
+
+struct quic_hash_head {
+	spinlock_t		lock; /* protect the 'head' member access */
+	struct hlist_head	head;
+};
+
+struct quic_hash_table {
+	struct quic_hash_head *hash;
+	int size;
+};
+
+enum  {
+	QUIC_HT_SOCK,
+	QUIC_HT_UDP_SOCK,
+	QUIC_HT_CONNECTION_ID,
+	QUIC_HT_BIND_PORT,
+	QUIC_HT_MAX_TABLES,
+};
+
+static inline __u32 quic_shash(const struct net *net, const union quic_addr *a)
+{
+	__u32 addr = (a->sa.sa_family == AF_INET6) ? jhash(&a->v6.sin6_addr, 16, 0)
+						   : (__force __u32)a->v4.sin_addr.s_addr;
+
+	return  jhash_3words(addr, (__force __u32)a->v4.sin_port, net_hash_mix(net), 0);
+}
+
+static inline __u32 quic_ahash(const struct net *net, const union quic_addr *s,
+			       const union quic_addr *d)
+{
+	__u32 ports = ((__force __u32)s->v4.sin_port) << 16 | (__force __u32)d->v4.sin_port;
+	__u32 saddr = (s->sa.sa_family == AF_INET6) ? jhash(&s->v6.sin6_addr, 16, 0)
+						    : (__force __u32)s->v4.sin_addr.s_addr;
+	__u32 daddr = (d->sa.sa_family == AF_INET6) ? jhash(&d->v6.sin6_addr, 16, 0)
+						    : (__force __u32)d->v4.sin_addr.s_addr;
+
+	return  jhash_3words(saddr, ports, net_hash_mix(net), daddr);
+}
+
+extern struct quic_hash_table quic_hash_tables[QUIC_HT_MAX_TABLES];
+
+static inline struct quic_hash_head *quic_sock_head(struct net *net, union quic_addr *s,
+						    union quic_addr *d)
+{
+	struct quic_hash_table *ht = &quic_hash_tables[QUIC_HT_SOCK];
+
+	return &ht->hash[quic_ahash(net, s, d) & (ht->size - 1)];
+}
+
+static inline struct quic_hash_head *quic_listen_sock_head(struct net *net, u16 port)
+{
+	struct quic_hash_table *ht = &quic_hash_tables[QUIC_HT_SOCK];
+
+	return &ht->hash[port & (ht->size - 1)];
+}
+
+static inline struct quic_hash_head *quic_bind_port_head(struct net *net, u16 port)
+{
+	struct quic_hash_table *ht = &quic_hash_tables[QUIC_HT_BIND_PORT];
+
+	return &ht->hash[port & (ht->size - 1)];
+}
+
+static inline struct quic_hash_head *quic_source_conn_id_head(struct net *net, u8 *scid)
+{
+	struct quic_hash_table *ht = &quic_hash_tables[QUIC_HT_CONNECTION_ID];
+
+	return &ht->hash[jhash(scid, 4, 0) & (ht->size - 1)];
+}
+
+static inline struct quic_hash_head *quic_udp_sock_head(struct net *net, u16 port)
+{
+	struct quic_hash_table *ht = &quic_hash_tables[QUIC_HT_UDP_SOCK];
+
+	return &ht->hash[port & (ht->size - 1)];
+}
+
+static inline struct quic_hash_head *quic_stream_head(struct quic_hash_table *ht, u64 stream_id)
+{
+	return &ht->hash[stream_id & (ht->size - 1)];
+}
diff --git a/net/quic/input.c b/net/quic/input.c
new file mode 100644
index 000000000000..ea0368d61902
--- /dev/null
+++ b/net/quic/input.c
@@ -0,0 +1,602 @@
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
+#include <net/proto_memory.h>
+
+#include "socket.h"
+
+void quic_inq_rfree(int len, struct sock *sk)
+{
+	if (!len)
+		return;
+
+	atomic_sub(len, &sk->sk_rmem_alloc);
+	sk_mem_uncharge(sk, len);
+}
+
+void quic_inq_set_owner_r(int len, struct sock *sk)
+{
+	if (!len)
+		return;
+
+	atomic_add(len, &sk->sk_rmem_alloc);
+	sk_mem_charge(sk, len);
+}
+
+int quic_rcv(struct sk_buff *skb)
+{
+	struct quic_crypto_cb *cb = QUIC_CRYPTO_CB(skb);
+	struct quic_addr_family_ops *af_ops;
+	struct quic_conn_id *conn_id;
+	union quic_addr daddr, saddr;
+	struct sock *sk = NULL;
+	int err = -EINVAL;
+	u8 *dcid;
+
+	skb_pull(skb, skb_transport_offset(skb));
+	af_ops = quic_af_ops_get_skb(skb);
+
+	if (skb->len < sizeof(struct quichdr))
+		goto err;
+
+	if (!quic_hdr(skb)->form) { /* search scid hashtable for post-handshake packets */
+		dcid = (u8 *)quic_hdr(skb) + 1;
+		conn_id = quic_conn_id_lookup(dev_net(skb->dev), dcid, skb->len - 1);
+		if (conn_id) {
+			cb->number_offset = conn_id->len + sizeof(struct quichdr);
+			sk = quic_conn_id_sk(conn_id);
+		}
+	}
+	if (!sk) {
+		af_ops->get_msg_addr(&daddr, skb, 0);
+		af_ops->get_msg_addr(&saddr, skb, 1);
+		sk = quic_sock_lookup(skb, &daddr, &saddr);
+		if (!sk)
+			goto err;
+	}
+	bh_lock_sock(sk);
+	if (sock_owned_by_user(sk)) {
+		cb->backlog = 1;
+		if (sk_add_backlog(sk, skb, READ_ONCE(sk->sk_rcvbuf))) {
+			bh_unlock_sock(sk);
+			goto err;
+		}
+	} else {
+		sk->sk_backlog_rcv(sk, skb); /* quic_packet_process */
+	}
+	bh_unlock_sock(sk);
+	return 0;
+
+err:
+	kfree_skb(skb);
+	return err;
+}
+
+void quic_rcv_err_icmp(struct sock *sk)
+{
+	u8 taglen = quic_packet_taglen(quic_packet(sk));
+	struct quic_config *c = quic_config(sk);
+	struct quic_path_addr *s = quic_src(sk);
+	struct quic_path_addr *d = quic_dst(sk);
+	u32 pathmtu, info;
+	bool reset_timer;
+
+	info = min_t(u32, quic_path_mtu_info(d), QUIC_PATH_MAX_PMTU);
+	if (!c->plpmtud_probe_interval || quic_path_sent_cnt(s) || quic_path_sent_cnt(d)) {
+		quic_packet_mss_update(sk, info - quic_encap_len(sk));
+		return;
+	}
+	info = info - quic_encap_len(sk) - taglen;
+	pathmtu = quic_path_pl_toobig(d, info, &reset_timer);
+	if (reset_timer)
+		quic_timer_reset(sk, QUIC_TIMER_PATH, c->plpmtud_probe_interval);
+	if (pathmtu)
+		quic_packet_mss_update(sk, pathmtu + taglen);
+}
+
+int quic_rcv_err(struct sk_buff *skb)
+{
+	struct quic_addr_family_ops *af_ops;
+	union quic_addr daddr, saddr;
+	struct quic_path_addr *path;
+	struct sock *sk = NULL;
+	int ret = 0;
+	u32 info;
+
+	af_ops = quic_af_ops_get_skb(skb);
+
+	af_ops->get_msg_addr(&saddr, skb, 0);
+	af_ops->get_msg_addr(&daddr, skb, 1);
+	sk = quic_sock_lookup(skb, &daddr, &saddr);
+	if (!sk)
+		return -ENOENT;
+
+	bh_lock_sock(sk);
+	if (quic_is_listen(sk))
+		goto out;
+
+	if (quic_get_mtu_info(sk, skb, &info))
+		goto out;
+
+	ret = 1; /* processed with common mtud */
+	path = quic_dst(sk);
+	quic_path_set_mtu_info(path, info);
+	if (sock_owned_by_user(sk)) {
+		if (!test_and_set_bit(QUIC_MTU_REDUCED_DEFERRED, &sk->sk_tsq_flags))
+			sock_hold(sk);
+		goto out;
+	}
+	quic_rcv_err_icmp(sk);
+out:
+	bh_unlock_sock(sk);
+	return ret;
+}
+
+static void quic_inq_stream_tail(struct sock *sk, struct quic_stream *stream,
+				 struct quic_frame *frame)
+{
+	struct quic_inqueue *inq = quic_inq(sk);
+	struct quic_stream_update update = {};
+	u64 overlap;
+
+	overlap = stream->recv.offset - frame->offset;
+	if (overlap) {
+		quic_inq_rfree(frame->len, sk);
+		frame->data += overlap;
+		frame->len -= overlap;
+		quic_inq_set_owner_r(frame->len, sk);
+		frame->offset += overlap;
+	}
+
+	if (frame->stream_fin) {
+		update.id = stream->id;
+		update.state = QUIC_STREAM_RECV_STATE_RECVD;
+		update.errcode = frame->offset + frame->len;
+		quic_inq_event_recv(sk, QUIC_EVENT_STREAM_UPDATE, &update);
+		stream->recv.state = update.state;
+	}
+	stream->recv.offset += frame->len;
+
+	frame->offset = 0;
+	if (frame->level) {
+		frame->level = 0;
+		list_add_tail(&frame->list, &inq->early_list);
+		return;
+	}
+	list_add_tail(&frame->list, &inq->recv_list);
+	sk->sk_data_ready(sk);
+}
+
+void quic_inq_flow_control(struct sock *sk, struct quic_stream *stream, int len)
+{
+	struct quic_inqueue *inq = quic_inq(sk);
+	struct quic_frame *frame = NULL;
+	u32 window;
+
+	if (!len)
+		return;
+
+	stream->recv.bytes += len;
+	inq->bytes += len;
+
+	/* recv flow control */
+	if (inq->max_bytes - inq->bytes < inq->window / 2) {
+		window = inq->window;
+		if (sk_under_memory_pressure(sk))
+			window >>= 1;
+		inq->max_bytes = inq->bytes + window;
+		frame = quic_frame_create(sk, QUIC_FRAME_MAX_DATA, inq);
+		if (frame)
+			quic_outq_ctrl_tail(sk, frame, true);
+	}
+
+	if (stream->recv.max_bytes - stream->recv.bytes < stream->recv.window / 2) {
+		window = stream->recv.window;
+		if (sk_under_memory_pressure(sk))
+			window >>= 1;
+		stream->recv.max_bytes = stream->recv.bytes + window;
+		frame = quic_frame_create(sk, QUIC_FRAME_MAX_STREAM_DATA, stream);
+		if (frame)
+			quic_outq_ctrl_tail(sk, frame, true);
+	}
+
+	if (frame)
+		quic_outq_transmit(sk);
+}
+
+static bool quic_sk_rmem_schedule(struct sock *sk, int size)
+{
+	int delta;
+
+	if (!sk_has_account(sk))
+		return true;
+	delta = size - sk->sk_forward_alloc;
+	return delta <= 0 || __sk_mem_schedule(sk, delta, SK_MEM_RECV);
+}
+
+int quic_inq_stream_recv(struct sock *sk, struct quic_frame *frame)
+{
+	u64 offset = frame->offset, off, highest = 0;
+	struct quic_stream *stream = frame->stream;
+	struct quic_inqueue *inq = quic_inq(sk);
+	struct quic_stream_update update = {};
+	u64 stream_id = stream->id;
+	struct list_head *head;
+	struct quic_frame *pos;
+
+	if (stream->recv.offset >= offset + frame->len) { /* dup */
+		quic_frame_free(frame);
+		return 0;
+	}
+
+	quic_inq_set_owner_r(frame->len, sk);
+	if (sk_rmem_alloc_get(sk) > sk->sk_rcvbuf || !quic_sk_rmem_schedule(sk, frame->len))
+		return -ENOBUFS;
+
+	off = offset + frame->len;
+	if (off > stream->recv.highest) {
+		highest = off - stream->recv.highest;
+		if (inq->highest + highest > inq->max_bytes ||
+		    stream->recv.highest + highest > stream->recv.max_bytes) {
+			frame->errcode = QUIC_TRANSPORT_ERROR_FLOW_CONTROL;
+			return -ENOBUFS;
+		}
+		if (stream->recv.finalsz && off > stream->recv.finalsz) {
+			frame->errcode = QUIC_TRANSPORT_ERROR_FINAL_SIZE;
+			return -EINVAL;
+		}
+	}
+	if (!stream->recv.highest && !frame->stream_fin) {
+		update.id = stream->id;
+		update.state = QUIC_STREAM_RECV_STATE_RECV;
+		if (quic_inq_event_recv(sk, QUIC_EVENT_STREAM_UPDATE, &update))
+			return -ENOMEM;
+	}
+	head = &inq->stream_list;
+	if (stream->recv.offset < offset) {
+		list_for_each_entry(pos, head, list) {
+			if (pos->stream->id < stream_id)
+				continue;
+			if (pos->stream->id > stream_id) {
+				head = &pos->list;
+				break;
+			}
+			if (pos->offset > offset) {
+				head = &pos->list;
+				break;
+			}
+			if (pos->offset + pos->len >= offset + frame->len) { /* dup */
+				quic_inq_rfree(frame->len, sk);
+				quic_frame_free(frame);
+				return 0;
+			}
+		}
+		if (frame->stream_fin) {
+			if (off < stream->recv.highest ||
+			    (stream->recv.finalsz && stream->recv.finalsz != off)) {
+				frame->errcode = QUIC_TRANSPORT_ERROR_FINAL_SIZE;
+				return -EINVAL;
+			}
+			update.id = stream->id;
+			update.state = QUIC_STREAM_RECV_STATE_SIZE_KNOWN;
+			update.finalsz = off;
+			if (quic_inq_event_recv(sk, QUIC_EVENT_STREAM_UPDATE, &update))
+				return -ENOMEM;
+			stream->recv.state = update.state;
+			stream->recv.finalsz = update.finalsz;
+		}
+		list_add_tail(&frame->list, head);
+		stream->recv.frags++;
+		inq->highest += highest;
+		stream->recv.highest += highest;
+		return 0;
+	}
+
+	/* fast path: stream->recv.offset == offset */
+	inq->highest += highest;
+	stream->recv.highest += highest;
+	quic_inq_stream_tail(sk, stream, frame);
+	if (!stream->recv.frags)
+		return 0;
+
+	list_for_each_entry_safe(frame, pos, head, list) {
+		if (frame->stream->id < stream_id)
+			continue;
+		if (frame->stream->id > stream_id)
+			break;
+		if (frame->offset > stream->recv.offset)
+			break;
+		list_del(&frame->list);
+		stream->recv.frags--;
+		if (frame->offset + frame->len <= stream->recv.offset) { /* dup */
+			quic_inq_rfree(frame->len, sk);
+			quic_frame_free(frame);
+			continue;
+		}
+		quic_inq_stream_tail(sk, stream, frame);
+	}
+	return 0;
+}
+
+void quic_inq_stream_purge(struct sock *sk, struct quic_stream *stream)
+{
+	struct list_head *head = &quic_inq(sk)->stream_list;
+	struct quic_frame *frame, *next;
+	int bytes = 0;
+
+	list_for_each_entry_safe(frame, next, head, list) {
+		if (frame->stream != stream)
+			continue;
+		list_del(&frame->list);
+		bytes += frame->len;
+		quic_frame_free(frame);
+	}
+	quic_inq_rfree(bytes, sk);
+}
+
+static void quic_inq_list_purge(struct sock *sk, struct list_head *head)
+{
+	struct quic_frame *frame, *next;
+	int bytes = 0;
+
+	list_for_each_entry_safe(frame, next, head, list) {
+		list_del(&frame->list);
+		bytes += frame->len;
+		quic_frame_free(frame);
+	}
+	quic_inq_rfree(bytes, sk);
+}
+
+static void quic_inq_handshake_tail(struct sock *sk, struct quic_frame *frame)
+{
+	struct quic_inqueue *inq = quic_inq(sk);
+	struct list_head *head;
+	struct quic_frame *pos;
+
+	head = &inq->recv_list;
+
+	/* always put handshake msg ahead of data and event */
+	list_for_each_entry(pos, head, list) {
+		if (!pos->level) {
+			head = &pos->list;
+			break;
+		}
+	}
+
+	frame->offset = 0;
+	list_add_tail(&frame->list, head);
+	sk->sk_data_ready(sk);
+}
+
+int quic_inq_handshake_recv(struct sock *sk, struct quic_frame *frame)
+{
+	u64 offset = frame->offset, crypto_offset;
+	struct quic_inqueue *inq = quic_inq(sk);
+	struct quic_crypto *crypto;
+	u8 level = frame->level;
+	struct list_head *head;
+	struct quic_frame *pos;
+
+	crypto = quic_crypto(sk, level);
+	crypto_offset = quic_crypto_recv_offset(crypto);
+	pr_debug("%s: recv_offset: %llu, offset: %llu, level: %u, len: %u\n",
+		 __func__, crypto_offset, offset, level, frame->len);
+	if (offset < crypto_offset) { /* dup */
+		quic_frame_free(frame);
+		return 0;
+	}
+	quic_inq_set_owner_r(frame->len, sk);
+	if (sk_rmem_alloc_get(sk) > sk->sk_rcvbuf) {
+		frame->errcode = QUIC_TRANSPORT_ERROR_CRYPTO_BUF_EXCEEDED;
+		return -ENOBUFS;
+	}
+	head = &inq->handshake_list;
+	if (offset > crypto_offset) {
+		list_for_each_entry(pos, head, list) {
+			if (pos->level < level)
+				continue;
+			if (pos->level > level) {
+				head = &pos->list;
+				break;
+			}
+			if (pos->offset > offset) {
+				head = &pos->list;
+				break;
+			}
+			if (pos->offset == offset) { /* dup */
+				quic_inq_rfree(frame->len, sk);
+				quic_frame_free(frame);
+				return 0;
+			}
+		}
+		list_add_tail(&frame->list, head);
+		return 0;
+	}
+
+	quic_inq_handshake_tail(sk, frame);
+	quic_crypto_inc_recv_offset(crypto, frame->len);
+
+	list_for_each_entry_safe(frame, pos, head, list) {
+		if (frame->level < level)
+			continue;
+		if (frame->level > level)
+			break;
+		if (frame->offset > quic_crypto_recv_offset(crypto))
+			break;
+		list_del(&frame->list);
+
+		quic_inq_handshake_tail(sk, frame);
+		quic_crypto_inc_recv_offset(crypto, frame->len);
+	}
+	return 0;
+}
+
+void quic_inq_set_param(struct sock *sk, struct quic_transport_param *p)
+{
+	struct quic_inqueue *inq = quic_inq(sk);
+
+	inq->max_datagram_frame_size = p->max_datagram_frame_size;
+	inq->max_udp_payload_size = p->max_udp_payload_size;
+	inq->max_ack_delay = p->max_ack_delay;
+	inq->ack_delay_exponent = p->ack_delay_exponent;
+	inq->max_idle_timeout = p->max_idle_timeout;
+	inq->grease_quic_bit = p->grease_quic_bit;
+	inq->window = p->max_data;
+
+	inq->max_bytes = p->max_data;
+	sk->sk_rcvbuf = p->max_data * 2;
+	inq->disable_1rtt_encryption = p->disable_1rtt_encryption;
+}
+
+int quic_inq_event_recv(struct sock *sk, u8 event, void *args)
+{
+	struct list_head *head = &quic_inq(sk)->recv_list;
+	struct quic_stream *stream = NULL;
+	struct quic_frame *frame, *pos;
+	int args_len = 0;
+	u8 *p;
+
+	if (!event || event > QUIC_EVENT_MAX)
+		return -EINVAL;
+
+	if (!(quic_inq(sk)->events & (1 << event)))
+		return 0;
+
+	switch (event) {
+	case QUIC_EVENT_STREAM_UPDATE:
+		stream = quic_stream_find(quic_streams(sk),
+					  ((struct quic_stream_update *)args)->id);
+		if (!stream)
+			return -EINVAL;
+		args_len = sizeof(struct quic_stream_update);
+		break;
+	case QUIC_EVENT_STREAM_MAX_STREAM:
+		args_len = sizeof(u64);
+		break;
+	case QUIC_EVENT_NEW_SESSION_TICKET:
+	case QUIC_EVENT_NEW_TOKEN:
+		args_len = ((struct quic_data *)args)->len;
+		args = ((struct quic_data *)args)->data;
+		break;
+	case QUIC_EVENT_CONNECTION_CLOSE:
+		args_len = strlen(((struct quic_connection_close *)args)->phrase) +
+			   1 + sizeof(struct quic_connection_close);
+		break;
+	case QUIC_EVENT_KEY_UPDATE:
+		args_len = sizeof(u8);
+		break;
+	case QUIC_EVENT_CONNECTION_MIGRATION:
+		args_len = sizeof(u8);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	frame = quic_frame_alloc(1 + args_len, NULL, GFP_ATOMIC);
+	if (!frame)
+		return -ENOMEM;
+	p = quic_put_data(frame->data, &event, 1);
+	p = quic_put_data(p, args, args_len);
+
+	frame->event = event;
+	frame->stream = stream;
+
+	/* always put event ahead of data */
+	list_for_each_entry(pos, head, list) {
+		if (!pos->level && !pos->event) {
+			head = &pos->list;
+			break;
+		}
+	}
+	quic_inq_set_owner_r(frame->len, sk);
+	list_add_tail(&frame->list, head);
+	quic_inq(sk)->last_event = frame;
+	sk->sk_data_ready(sk);
+	return 0;
+}
+
+int quic_inq_dgram_recv(struct sock *sk, struct quic_frame *frame)
+{
+	quic_inq_set_owner_r(frame->len, sk);
+	if (sk_rmem_alloc_get(sk) > sk->sk_rcvbuf || !quic_sk_rmem_schedule(sk, frame->len))
+		return -ENOBUFS;
+
+	frame->dgram = 1;
+	list_add_tail(&frame->list, &quic_inq(sk)->recv_list);
+	sk->sk_data_ready(sk);
+	return 0;
+}
+
+static void quic_inq_decrypted_work(struct work_struct *work)
+{
+	struct quic_sock *qs = container_of(work, struct quic_sock, inq.work);
+	struct sock *sk = &qs->inet.sk;
+	struct sk_buff_head *head;
+	struct sk_buff *skb;
+
+	lock_sock(sk);
+	head = &sk->sk_receive_queue;
+	if (sock_flag(sk, SOCK_DEAD)) {
+		skb_queue_purge(head);
+		goto out;
+	}
+
+	skb = skb_dequeue(head);
+	while (skb) {
+		QUIC_CRYPTO_CB(skb)->resume = 1;
+		quic_packet_process(sk, skb);
+		skb = skb_dequeue(head);
+	}
+out:
+	release_sock(sk);
+	sock_put(sk);
+}
+
+void quic_inq_decrypted_tail(struct sock *sk, struct sk_buff *skb)
+{
+	struct quic_inqueue *inq = quic_inq(sk);
+
+	sock_hold(sk);
+	skb_queue_tail(&sk->sk_receive_queue, skb);
+
+	if (!schedule_work(&inq->work))
+		sock_put(sk);
+}
+
+void quic_inq_backlog_tail(struct sock *sk, struct sk_buff *skb)
+{
+	__skb_queue_tail(&quic_inq(sk)->backlog_list, skb);
+}
+
+void quic_inq_init(struct sock *sk)
+{
+	struct quic_inqueue *inq = quic_inq(sk);
+
+	skb_queue_head_init(&inq->backlog_list);
+	INIT_LIST_HEAD(&inq->handshake_list);
+	INIT_LIST_HEAD(&inq->stream_list);
+	INIT_LIST_HEAD(&inq->early_list);
+	INIT_LIST_HEAD(&inq->recv_list);
+	INIT_WORK(&inq->work, quic_inq_decrypted_work);
+}
+
+void quic_inq_free(struct sock *sk)
+{
+	struct quic_inqueue *inq = quic_inq(sk);
+
+	__skb_queue_purge(&sk->sk_receive_queue);
+	__skb_queue_purge(&inq->backlog_list);
+	quic_inq_list_purge(sk, &inq->handshake_list);
+	quic_inq_list_purge(sk, &inq->stream_list);
+	quic_inq_list_purge(sk, &inq->early_list);
+	quic_inq_list_purge(sk, &inq->recv_list);
+}
diff --git a/net/quic/input.h b/net/quic/input.h
new file mode 100644
index 000000000000..58c915af4ca5
--- /dev/null
+++ b/net/quic/input.h
@@ -0,0 +1,155 @@
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
+#define QUIC_MAX_ACK_DELAY_EXPONENT	20
+#define QUIC_DEF_ACK_DELAY_EXPONENT	3
+
+#define QUIC_MAX_ACK_DELAY		(16384 * 1000)
+#define QUIC_DEF_ACK_DELAY		25000
+
+struct quic_inqueue {
+	struct sk_buff_head backlog_list;
+	struct list_head handshake_list;
+	struct list_head stream_list;
+	struct list_head early_list;
+	struct list_head recv_list;
+	struct work_struct work;
+	u64 max_bytes;
+	u64 highest;
+	u64 window;
+	u64 bytes;
+
+	struct quic_frame *last_event;
+	u32 max_datagram_frame_size;
+	u32 max_udp_payload_size;
+	u32 ack_delay_exponent;
+	u32 max_idle_timeout;
+	u32 max_ack_delay;
+	u32 events;
+
+	u8 disable_1rtt_encryption:1;
+	u8 grease_quic_bit:1;
+	u8 need_sack:2;
+};
+
+static inline u32 quic_inq_max_idle_timeout(struct quic_inqueue *inq)
+{
+	return inq->max_idle_timeout;
+}
+
+static inline void quic_inq_set_max_idle_timeout(struct quic_inqueue *inq, u32 timeout)
+{
+	inq->max_idle_timeout = timeout;
+}
+
+static inline u32 quic_inq_max_ack_delay(struct quic_inqueue *inq)
+{
+	return inq->max_ack_delay;
+}
+
+static inline u32 quic_inq_max_dgram(struct quic_inqueue *inq)
+{
+	return inq->max_datagram_frame_size;
+}
+
+static inline u32 quic_inq_window(struct quic_inqueue *inq)
+{
+	return inq->window;
+}
+
+static inline u64 quic_inq_bytes(struct quic_inqueue *inq)
+{
+	return inq->bytes;
+}
+
+static inline u64 quic_inq_max_bytes(struct quic_inqueue *inq)
+{
+	return inq->max_bytes;
+}
+
+static inline void quic_inq_set_max_bytes(struct quic_inqueue *inq, u64 bytes)
+{
+	inq->max_bytes = bytes;
+}
+
+static inline u8 quic_inq_grease_quic_bit(struct quic_inqueue *inq)
+{
+	return inq->grease_quic_bit;
+}
+
+static inline struct quic_frame *quic_inq_last_event(struct quic_inqueue *inq)
+{
+	return inq->last_event;
+}
+
+static inline void quic_inq_set_last_event(struct quic_inqueue *inq, struct quic_frame *frame)
+{
+	inq->last_event = frame;
+}
+
+static inline u32 quic_inq_events(struct quic_inqueue *inq)
+{
+	return inq->events;
+}
+
+static inline void quic_inq_set_events(struct quic_inqueue *inq, u32 events)
+{
+	inq->events = events;
+}
+
+static inline struct sk_buff_head *quic_inq_backlog_list(struct quic_inqueue *inq)
+{
+	return &inq->backlog_list;
+}
+
+static inline struct list_head *quic_inq_early_list(struct quic_inqueue *inq)
+{
+	return &inq->early_list;
+}
+
+static inline struct list_head *quic_inq_recv_list(struct quic_inqueue *inq)
+{
+	return &inq->recv_list;
+}
+
+static inline u8 quic_inq_disable_1rtt_encryption(struct quic_inqueue *inq)
+{
+	return inq->disable_1rtt_encryption;
+}
+
+static inline u8 quic_inq_need_sack(struct quic_inqueue *inq)
+{
+	return inq->need_sack;
+}
+
+static inline void quic_inq_set_need_sack(struct quic_inqueue *inq, u8 need_sack)
+{
+	inq->need_sack = need_sack;
+}
+
+void quic_rcv_err_icmp(struct sock *sk);
+int quic_rcv_err(struct sk_buff *skb);
+int quic_rcv(struct sk_buff *skb);
+
+int quic_inq_handshake_recv(struct sock *sk, struct quic_frame *frame);
+int quic_inq_stream_recv(struct sock *sk, struct quic_frame *frame);
+int quic_inq_dgram_recv(struct sock *sk, struct quic_frame *frame);
+int quic_inq_event_recv(struct sock *sk, u8 event, void *args);
+
+void quic_inq_flow_control(struct sock *sk, struct quic_stream *stream, int len);
+void quic_inq_stream_purge(struct sock *sk, struct quic_stream *stream);
+void quic_inq_decrypted_tail(struct sock *sk, struct sk_buff *skb);
+void quic_inq_backlog_tail(struct sock *sk, struct sk_buff *skb);
+
+void quic_inq_set_param(struct sock *sk, struct quic_transport_param *p);
+void quic_inq_set_owner_r(int len, struct sock *sk);
+void quic_inq_rfree(int len, struct sock *sk);
+void quic_inq_init(struct sock *sk);
+void quic_inq_free(struct sock *sk);
diff --git a/net/quic/number.h b/net/quic/number.h
new file mode 100644
index 000000000000..b530852e1366
--- /dev/null
+++ b/net/quic/number.h
@@ -0,0 +1,314 @@
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
+union quic_num {
+	u8	u8;
+	__be16	be16;
+	__be32	be32;
+	__be64	be64;
+};
+
+static inline u32 quic_var_len(u64 n)
+{
+	if (n < 64)
+		return 1;
+	if (n < 16384)
+		return 2;
+	if (n < 1073741824)
+		return 4;
+	return 8;
+}
+
+static inline u8 quic_get_var(u8 **pp, u32 *plen, u64 *val)
+{
+	union quic_num n;
+	u8 *p = *pp, len;
+	u64 v = 0;
+
+	if (!*plen)
+		return 0;
+
+	len = (u8)(1u << (*p >> 6));
+	if (*plen < len)
+		return 0;
+
+	switch (len) {
+	case 1:
+		v = *p;
+		break;
+	case 2:
+		memcpy(&n.be16, p, 2);
+		n.u8 &= 0x3f;
+		v = ntohs(n.be16);
+		break;
+	case 4:
+		memcpy(&n.be32, p, 4);
+		n.u8 &= 0x3f;
+		v = ntohl(n.be32);
+		break;
+	case 8:
+		memcpy(&n.be64, p, 8);
+		n.u8 &= 0x3f;
+		v = be64_to_cpu(n.be64);
+		break;
+	}
+
+	*plen -= len;
+	*pp = p + len;
+	*val = v;
+	return len;
+}
+
+static inline u8 quic_get_int(u8 **pp, u32 *plen, u64 *val, u32 len)
+{
+	union quic_num n;
+	u8 *p = *pp;
+	u64 v = 0;
+
+	if (*plen < len)
+		return 0;
+	*plen -= len;
+
+	n.be32 = 0;
+	switch (len) {
+	case 1:
+		v = *p;
+		break;
+	case 2:
+		memcpy(&n.be16, p, 2);
+		v = ntohs(n.be16);
+		break;
+	case 3:
+		memcpy(((u8 *)&n.be32) + 1, p, 3);
+		v = ntohl(n.be32);
+		break;
+	case 4:
+		memcpy(&n.be32, p, 4);
+		v = ntohl(n.be32);
+		break;
+	case 8:
+		memcpy(&n.be64, p, 8);
+		v = be64_to_cpu(n.be64);
+		break;
+	}
+	*pp = p + len;
+	*val = v;
+	return len;
+}
+
+static inline u8 *quic_put_var(u8 *p, u64 num)
+{
+	union quic_num n;
+
+	if (num < 64) {
+		*p++ = (u8)num;
+		return p;
+	}
+	if (num < 16384) {
+		n.be16 = htons((u16)num);
+		*((__be16 *)p) = n.be16;
+		*p |= 0x40;
+		return p + 2;
+	}
+	if (num < 1073741824) {
+		n.be32 = htonl((u32)num);
+		*((__be32 *)p) = n.be32;
+		*p |= 0x80;
+		return p + 4;
+	}
+	n.be64 = cpu_to_be64(num);
+	*((__be64 *)p) = n.be64;
+	*p |= 0xc0;
+	return p + 8;
+}
+
+static inline u8 *quic_put_int(u8 *p, u64 num, u8 len)
+{
+	union quic_num n;
+
+	switch (len) {
+	case 1:
+		*p++ = (u8)num;
+		return p;
+	case 2:
+		n.be16 = htons((u16)num);
+		*((__be16 *)p) = n.be16;
+		return p + 2;
+	case 4:
+		n.be32 = htonl((u32)num);
+		*((__be32 *)p) = n.be32;
+		return p + 4;
+	default:
+		return NULL;
+	}
+}
+
+static inline u8 *quic_put_data(u8 *p, u8 *data, u32 len)
+{
+	if (!len)
+		return p;
+
+	memcpy(p, data, len);
+	return p + len;
+}
+
+static inline u8 *quic_put_param(u8 *p, u16 id, u64 value)
+{
+	p = quic_put_var(p, id);
+	p = quic_put_var(p, quic_var_len(value));
+	return quic_put_var(p, value);
+}
+
+static inline int quic_get_param(u64 *pdest, u8 **pp, u32 *plen)
+{
+	u64 valuelen;
+
+	if (!quic_get_var(pp, plen, &valuelen))
+		return -1;
+
+	if (*plen < valuelen)
+		return -1;
+
+	if (!quic_get_var(pp, plen, pdest))
+		return -1;
+	return 0;
+}
+
+static inline s64 quic_get_num(s64 max_pkt_num, s64 pkt_num, u32 n)
+{
+	s64 expected = max_pkt_num + 1;
+	s64 win = (s64)1 << (n * 8);
+	s64 hwin = win / 2;
+	s64 mask = win - 1;
+	s64 cand;
+
+	cand = (expected & ~mask) | pkt_num;
+	if (cand <= expected - hwin)
+		return cand + win;
+	if (cand > expected + hwin && cand >= win)
+		return cand - win;
+	return cand;
+}
+
+struct quic_data {
+	u8 *data;
+	u32 len;
+};
+
+static inline struct quic_data *quic_data(struct quic_data *d, u8 *data, u32 len)
+{
+	d->data = data;
+	d->len  = len;
+	return d;
+}
+
+static inline void quic_data_free(struct quic_data *d)
+{
+	kfree(d->data);
+	d->data = NULL;
+	d->len = 0;
+}
+
+static inline int quic_data_dup(struct quic_data *to, u8 *data, u32 len)
+{
+	if (!len)
+		return 0;
+
+	data = kmemdup(data, len, GFP_ATOMIC);
+	if (!data)
+		return -ENOMEM;
+
+	kfree(to->data);
+	to->data = data;
+	to->len = len;
+	return 0;
+}
+
+static inline int quic_data_cmp(struct quic_data *d1, struct quic_data *d2)
+{
+	return d1->len != d2->len || memcmp(d1->data, d2->data, d1->len);
+}
+
+static inline int quic_data_has(struct quic_data *d1, struct quic_data *d2)
+{
+	struct quic_data d;
+	u64 length;
+	u32 len;
+	u8 *p;
+
+	for (p = d1->data, len = d1->len; len; len -= length, p += length) {
+		quic_get_int(&p, &len, &length, 1);
+		quic_data(&d, p, length);
+		if (!quic_data_cmp(&d, d2))
+			return 1;
+	}
+	return 0;
+}
+
+static inline int quic_data_match(struct quic_data *d1, struct quic_data *d2)
+{
+	struct quic_data d;
+	u64 length;
+	u32 len;
+	u8 *p;
+
+	for (p = d1->data, len = d1->len; len; len -= length, p += length) {
+		quic_get_int(&p, &len, &length, 1);
+		quic_data(&d, p, length);
+		if (quic_data_has(d2, &d))
+			return 1;
+	}
+	return 0;
+}
+
+static inline void quic_data_to_string(u8 *to, u32 *plen, struct quic_data *from)
+{
+	struct quic_data d;
+	u8 *data = to, *p;
+	u64 length;
+	u32 len;
+
+	for (p = from->data, len = from->len; len; len -= length, p += length) {
+		quic_get_int(&p, &len, &length, 1);
+		quic_data(&d, p, length);
+		data = quic_put_data(data, d.data, d.len);
+		if (len - length)
+			data = quic_put_int(data, ',', 1);
+	}
+	*plen = data - to;
+}
+
+static inline void quic_data_from_string(struct quic_data *to, u8 *from, u32 len)
+{
+	struct quic_data d;
+	u8 *p = to->data;
+
+	to->len = 0;
+	while (len) {
+		d.data = p++;
+		d.len  = 1;
+		while (len && *from == ' ') {
+			from++;
+			len--;
+		}
+		while (len) {
+			if (*from == ',') {
+				from++;
+				len--;
+				break;
+			}
+			*p++ = *from++;
+			len--;
+			d.len++;
+		}
+		*d.data = d.len - 1;
+		to->len += d.len;
+	}
+}
diff --git a/net/quic/output.c b/net/quic/output.c
new file mode 100644
index 000000000000..4d5f80a227bd
--- /dev/null
+++ b/net/quic/output.c
@@ -0,0 +1,748 @@
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
+static void quic_outq_transmit_ctrl(struct sock *sk)
+{
+	struct quic_outqueue *outq = quic_outq(sk);
+	struct quic_frame *frame, *tmp;
+	struct list_head *head;
+
+	head =  &outq->control_list;
+	list_for_each_entry_safe(frame, tmp, head, list) {
+		if (!quic_crypto_send_ready(quic_crypto(sk, frame->level)))
+			break;
+		if (quic_packet_config(sk, frame->level, frame->path_alt))
+			break;
+		if (quic_packet_tail(sk, frame, 0)) {
+			outq->data_inflight += frame->bytes;
+			continue; /* packed and conintue with the next frame */
+		}
+		quic_packet_create(sk); /* build and xmit the packed frames */
+		tmp = frame; /* go back but still pack the current frame */
+	}
+}
+
+static bool quic_outq_pacing_check(struct sock *sk, u16 bytes)
+{
+	u64 pacing_time = quic_cong_pacing_time(quic_cong(sk));
+
+	if (pacing_time <= ktime_get_ns())
+		return false;
+
+	quic_timer_start(sk, QUIC_TIMER_PACE, pacing_time);
+	return true;
+}
+
+static void quic_outq_transmit_dgram(struct sock *sk)
+{
+	struct quic_outqueue *outq = quic_outq(sk);
+	struct quic_frame *frame, *tmp;
+	u8 level = outq->data_level;
+	struct list_head *head;
+
+	if (!quic_crypto_send_ready(quic_crypto(sk, level)))
+		return;
+
+	head =  &outq->datagram_list;
+	list_for_each_entry_safe(frame, tmp, head, list) {
+		if (outq->data_inflight + frame->bytes > outq->window)
+			break;
+		if (quic_outq_pacing_check(sk, frame->bytes))
+			break;
+		if (quic_packet_config(sk, level, frame->path_alt))
+			break;
+		if (quic_packet_tail(sk, frame, 1)) {
+			outq->data_inflight += frame->bytes;
+			continue;
+		}
+		quic_packet_create(sk);
+		tmp = frame;
+	}
+}
+
+static int quic_outq_flow_control(struct sock *sk, struct quic_frame *frame)
+{
+	struct quic_outqueue *outq = quic_outq(sk);
+	struct quic_frame *nframe = NULL;
+	struct quic_stream *stream;
+	u32 len = frame->bytes;
+	u8 blocked = 0;
+
+	/* congestion control */
+	if (outq->data_inflight + len > outq->window)
+		blocked = 1;
+
+	/* send flow control */
+	stream = frame->stream;
+	if (stream->send.bytes + len > stream->send.max_bytes) {
+		if (!stream->send.data_blocked &&
+		    stream->send.last_max_bytes < stream->send.max_bytes) {
+			nframe = quic_frame_create(sk, QUIC_FRAME_STREAM_DATA_BLOCKED, stream);
+			if (nframe)
+				quic_outq_ctrl_tail(sk, nframe, true);
+			stream->send.last_max_bytes = stream->send.max_bytes;
+			stream->send.data_blocked = 1;
+		}
+		blocked = 1;
+	}
+	if (outq->bytes + len > outq->max_bytes) {
+		if (!outq->data_blocked && outq->last_max_bytes < outq->max_bytes) {
+			nframe = quic_frame_create(sk, QUIC_FRAME_DATA_BLOCKED, outq);
+			if (nframe)
+				quic_outq_ctrl_tail(sk, nframe, true);
+			outq->last_max_bytes = outq->max_bytes;
+			outq->data_blocked = 1;
+		}
+		blocked = 1;
+	}
+
+	if (nframe)
+		quic_outq_transmit_ctrl(sk);
+	return blocked;
+}
+
+static void quic_outq_transmit_stream(struct sock *sk)
+{
+	struct quic_outqueue *outq = quic_outq(sk);
+	struct quic_frame *frame, *tmp;
+	u8 level = outq->data_level;
+	struct list_head *head;
+
+	if (!quic_crypto_send_ready(quic_crypto(sk, level)))
+		return;
+
+	head = &outq->stream_list;
+	list_for_each_entry_safe(frame, tmp, head, list) {
+		if (!level && quic_outq_flow_control(sk, frame))
+			break;
+		if (quic_outq_pacing_check(sk, frame->bytes))
+			break;
+		if (quic_packet_config(sk, level, frame->path_alt))
+			break;
+		if (quic_packet_tail(sk, frame, 0)) {
+			frame->stream->send.frags++;
+			frame->stream->send.bytes += frame->bytes;
+			outq->bytes += frame->bytes;
+			outq->data_inflight += frame->bytes;
+			continue;
+		}
+		quic_packet_create(sk);
+		tmp = frame;
+	}
+}
+
+/* pack and transmit frames from outqueue */
+int quic_outq_transmit(struct sock *sk)
+{
+	quic_outq_transmit_ctrl(sk);
+
+	quic_outq_transmit_dgram(sk);
+
+	quic_outq_transmit_stream(sk);
+
+	return quic_packet_flush(sk);
+}
+
+void quic_outq_wfree(int len, struct sock *sk)
+{
+	if (!len)
+		return;
+
+	WARN_ON(refcount_sub_and_test(len, &sk->sk_wmem_alloc));
+	sk_wmem_queued_add(sk, -len);
+	sk_mem_uncharge(sk, len);
+
+	if (sk_stream_wspace(sk) > 0)
+		sk->sk_write_space(sk);
+}
+
+void quic_outq_set_owner_w(int len, struct sock *sk)
+{
+	if (!len)
+		return;
+
+	refcount_add(len, &sk->sk_wmem_alloc);
+	sk_wmem_queued_add(sk, len);
+	sk_mem_charge(sk, len);
+}
+
+void quic_outq_stream_tail(struct sock *sk, struct quic_frame *frame, bool cork)
+{
+	struct quic_stream_table *streams = quic_streams(sk);
+	struct quic_stream *stream = frame->stream;
+
+	if (stream->send.state == QUIC_STREAM_SEND_STATE_READY)
+		stream->send.state = QUIC_STREAM_SEND_STATE_SEND;
+
+	if (frame->type & QUIC_STREAM_BIT_FIN &&
+	    stream->send.state == QUIC_STREAM_SEND_STATE_SEND) {
+		if (quic_stream_send_active(streams) == stream->id)
+			quic_stream_set_send_active(streams, -1);
+		stream->send.state = QUIC_STREAM_SEND_STATE_SENT;
+	}
+
+	list_add_tail(&frame->list, &quic_outq(sk)->stream_list);
+	if (!cork)
+		quic_outq_transmit(sk);
+}
+
+void quic_outq_dgram_tail(struct sock *sk, struct quic_frame *frame, bool cork)
+{
+	list_add_tail(&frame->list, &quic_outq(sk)->datagram_list);
+	if (!cork)
+		quic_outq_transmit(sk);
+}
+
+void quic_outq_ctrl_tail(struct sock *sk, struct quic_frame *frame, bool cork)
+{
+	struct list_head *head = &quic_outq(sk)->control_list;
+	struct quic_frame *pos;
+
+	if (frame->level) { /* prioritize handshake frames */
+		list_for_each_entry(pos, head, list) {
+			if (!pos->level) {
+				head = &pos->list;
+				break;
+			}
+		}
+	}
+	list_add_tail(&frame->list, head);
+	if (!cork)
+		quic_outq_transmit(sk);
+}
+
+void quic_outq_transmitted_tail(struct sock *sk, struct quic_frame *frame)
+{
+	struct list_head *head = &quic_outq(sk)->transmitted_list;
+	struct quic_frame *pos;
+
+	if (frame->level) { /* prioritize handshake frames */
+		list_for_each_entry(pos, head, list) {
+			if (!pos->level) {
+				head = &pos->list;
+				break;
+			}
+		}
+	}
+	list_add_tail(&frame->list, head);
+}
+
+void quic_outq_transmit_probe(struct sock *sk)
+{
+	struct quic_path_dst *d = (struct quic_path_dst *)quic_dst(sk);
+	struct quic_pnspace *space = quic_pnspace(sk, QUIC_CRYPTO_APP);
+	u8 taglen = quic_packet_taglen(quic_packet(sk));
+	struct quic_config *c = quic_config(sk);
+	struct quic_frame *frame;
+	u32 pathmtu;
+	s64 number;
+
+	if (!quic_is_established(sk))
+		return;
+
+	frame = quic_frame_create(sk, QUIC_FRAME_PING, &d->pl.probe_size);
+	if (frame) {
+		number = quic_pnspace_next_pn(space);
+		quic_outq_ctrl_tail(sk, frame, false);
+
+		pathmtu = quic_path_pl_send(quic_dst(sk), number);
+		if (pathmtu)
+			quic_packet_mss_update(sk, pathmtu + taglen);
+	}
+
+	quic_timer_reset(sk, QUIC_TIMER_PATH, c->plpmtud_probe_interval);
+}
+
+void quic_outq_transmit_close(struct sock *sk, u8 type, u32 errcode, u8 level)
+{
+	struct quic_outqueue *outq = quic_outq(sk);
+	struct quic_connection_close close = {};
+	struct quic_frame *frame;
+
+	if (!errcode)
+		return;
+
+	close.errcode = errcode;
+	close.frame = type;
+	if (quic_inq_event_recv(sk, QUIC_EVENT_CONNECTION_CLOSE, &close))
+		return;
+
+	quic_outq_set_close_errcode(outq, errcode);
+	quic_outq_set_close_frame(outq, type);
+
+	frame = quic_frame_create(sk, QUIC_FRAME_CONNECTION_CLOSE, NULL);
+	if (frame) {
+		frame->level = level;
+		quic_outq_ctrl_tail(sk, frame, false);
+	}
+	quic_set_state(sk, QUIC_SS_CLOSED);
+}
+
+void quic_outq_transmit_app_close(struct sock *sk)
+{
+	u32 errcode = QUIC_TRANSPORT_ERROR_APPLICATION;
+	u8 type = QUIC_FRAME_CONNECTION_CLOSE, level;
+	struct quic_outqueue *outq = quic_outq(sk);
+	struct quic_frame *frame;
+
+	if (quic_is_established(sk)) {
+		level = QUIC_CRYPTO_APP;
+		type = QUIC_FRAME_CONNECTION_CLOSE_APP;
+	} else if (quic_is_establishing(sk)) {
+		level = QUIC_CRYPTO_INITIAL;
+		quic_outq_set_close_errcode(outq, errcode);
+	} else {
+		return;
+	}
+
+	/* send close frame only when it's NOT idle timeout or closed by peer */
+	frame = quic_frame_create(sk, type, NULL);
+	if (frame) {
+		frame->level = level;
+		quic_outq_ctrl_tail(sk, frame, false);
+	}
+}
+
+void quic_outq_transmitted_sack(struct sock *sk, u8 level, s64 largest, s64 smallest,
+				s64 ack_largest, u32 ack_delay)
+{
+	struct quic_pnspace *space = quic_pnspace(sk, level);
+	struct quic_crypto *crypto = quic_crypto(sk, level);
+	u32 pathmtu, rto, acked = 0, bytes = 0, pbytes = 0;
+	struct quic_path_addr *path = quic_dst(sk);
+	struct quic_outqueue *outq = quic_outq(sk);
+	struct quic_config *c = quic_config(sk);
+	struct quic_cong *cong = quic_cong(sk);
+	struct quic_stream_update update;
+	struct quic_frame *frame, *tmp;
+	struct quic_stream *stream;
+	bool raise_timer, complete;
+	struct list_head *head;
+
+	pr_debug("%s: largest: %llu, smallest: %llu\n", __func__, largest, smallest);
+	if (quic_path_pl_confirm(path, largest, smallest)) {
+		pathmtu = quic_path_pl_recv(path, &raise_timer, &complete);
+		if (pathmtu)
+			quic_packet_mss_update(sk, pathmtu + quic_packet_taglen(quic_packet(sk)));
+		if (!complete)
+			quic_outq_transmit_probe(sk);
+		if (raise_timer) /* reuse probe timer as raise timer */
+			quic_timer_reset(sk, QUIC_TIMER_PATH, c->plpmtud_probe_interval * 30);
+	}
+
+	head = &outq->transmitted_list;
+	list_for_each_entry_safe_reverse(frame, tmp, head, list) {
+		if (level != frame->level)
+			continue;
+		if (frame->number > largest)
+			continue;
+		if (frame->number < smallest)
+			break;
+		stream = frame->stream;
+		if (frame->bytes) {
+			if (stream && !(--stream->send.frags) &&
+			    stream->send.state == QUIC_STREAM_SEND_STATE_SENT) {
+				update.id = stream->id;
+				update.state = QUIC_STREAM_SEND_STATE_RECVD;
+				if (quic_inq_event_recv(sk, QUIC_EVENT_STREAM_UPDATE, &update)) {
+					stream->send.frags++;
+					continue;
+				}
+				stream->send.state = update.state;
+			}
+			if (!quic_frame_is_crypto(frame->type))
+				pbytes += frame->bytes;
+		} else if (frame->type == QUIC_FRAME_RESET_STREAM) {
+			update.id = stream->id;
+			update.state = QUIC_STREAM_SEND_STATE_RESET_RECVD;
+			update.errcode = stream->send.errcode;
+			if (quic_inq_event_recv(sk, QUIC_EVENT_STREAM_UPDATE, &update))
+				continue;
+			stream->send.state = update.state;
+		} else if (frame->type == QUIC_FRAME_STREAM_DATA_BLOCKED) {
+			stream->send.data_blocked = 0;
+		} else if (frame->type == QUIC_FRAME_DATA_BLOCKED) {
+			outq->data_blocked = 0;
+		}
+
+		if (frame->ecn)
+			quic_set_sk_ecn(sk, INET_ECN_ECT_0);
+
+		quic_pnspace_set_max_pn_acked_seen(space, frame->number);
+		quic_pnspace_dec_inflight(space, frame->len);
+		outq->data_inflight -= frame->bytes;
+		list_del(&frame->list);
+		acked += frame->bytes;
+
+		if (frame->first) {
+			if (frame->number == ack_largest) {
+				quic_cong_rtt_update(cong, frame->sent_time, ack_delay);
+				rto = quic_cong_rto(cong);
+				quic_pnspace_set_max_time_limit(space, rto * 2);
+				quic_crypto_set_key_update_time(crypto, rto * 2);
+			}
+			if (pbytes) {
+				bytes += pbytes;
+				quic_cong_on_packet_acked(cong, frame->sent_time, pbytes,
+							  frame->number);
+				quic_outq_sync_window(sk);
+				pbytes = 0;
+			}
+		}
+
+		quic_frame_free(frame);
+	}
+
+	outq->rtx_count = 0;
+	quic_outq_wfree(acked, sk);
+	quic_cong_on_ack_recv(cong, bytes, READ_ONCE(sk->sk_max_pacing_rate));
+}
+
+void quic_outq_update_loss_timer(struct sock *sk, u8 level)
+{
+	struct quic_pnspace *space = quic_pnspace(sk, level);
+	u32 timeout, now = jiffies_to_usecs(jiffies);
+
+	timeout = quic_pnspace_loss_time(space);
+	if (timeout)
+		goto out;
+
+	if (!quic_pnspace_inflight(space))
+		return quic_timer_stop(sk, level);
+
+	timeout = quic_cong_duration(quic_cong(sk));
+	timeout *= (1 + quic_outq(sk)->rtx_count);
+	timeout += quic_pnspace_last_sent_time(space);
+out:
+	if (timeout < now)
+		timeout = now + 1;
+	quic_timer_reduce(sk, level, timeout - now);
+}
+
+void quic_outq_sync_window(struct sock *sk)
+{
+	struct quic_outqueue *outq = quic_outq(sk);
+	struct quic_cong *cong = quic_cong(sk);
+	u32 window = quic_cong_window(cong);
+
+	if (window == outq->window)
+		return;
+	outq->window = window;
+
+	if (sk->sk_userlocks & SOCK_SNDBUF_LOCK)
+		return;
+	if (sk->sk_sndbuf > 2 * window)
+		if (sk_stream_wspace(sk) > 0)
+			sk->sk_write_space(sk);
+	sk->sk_sndbuf = 2 * window;
+}
+
+/* put the timeout frame back to the corresponding outqueue */
+static void quic_outq_retransmit_one(struct sock *sk, struct quic_frame *frame)
+{
+	struct quic_outqueue *outq = quic_outq(sk);
+	struct quic_frame *pos, *tmp;
+	struct list_head *head;
+
+	head = &outq->control_list;
+	if (frame->bytes && !quic_frame_is_crypto(frame->type)) {
+		head = &outq->stream_list;
+		frame->stream->send.frags--;
+		frame->stream->send.bytes -= frame->bytes;
+		outq->bytes -= frame->bytes;
+	}
+
+	list_for_each_entry_safe(pos, tmp, head, list) {
+		if (frame->level < pos->level)
+			continue;
+		if (frame->level > pos->level) {
+			head = &pos->list;
+			break;
+		}
+		if (!pos->offset || frame->offset < pos->offset) {
+			head = &pos->list;
+			break;
+		}
+	}
+	list_add_tail(&frame->list, head);
+}
+
+int quic_outq_retransmit_mark(struct sock *sk, u8 level, u8 immediate)
+{
+	struct quic_pnspace *space = quic_pnspace(sk, level);
+	u32 time, now, rto, count = 0, freed = 0, bytes = 0;
+	struct quic_outqueue *outq = quic_outq(sk);
+	struct quic_cong *cong = quic_cong(sk);
+	struct quic_frame *frame, *tmp;
+	struct list_head *head;
+
+	quic_pnspace_set_loss_time(space, 0);
+	now = jiffies_to_usecs(jiffies);
+	quic_cong_set_time(cong, now);
+	head = &outq->transmitted_list;
+	list_for_each_entry_safe(frame, tmp, head, list) {
+		if (level != frame->level)
+			continue;
+
+		rto = quic_cong_rto(cong);
+		if (!immediate && frame->sent_time + rto > now &&
+		    frame->number + 6 > quic_pnspace_max_pn_acked_seen(space)) {
+			quic_pnspace_set_loss_time(space, frame->sent_time + rto);
+			break;
+		}
+
+		quic_pnspace_dec_inflight(space, frame->len);
+		outq->data_inflight -= frame->bytes;
+		list_del(&frame->list);
+		bytes += frame->bytes;
+
+		if (frame->last && bytes) {
+			time = quic_pnspace_max_pn_acked_time(space);
+			quic_cong_on_packet_lost(cong, time, bytes, frame->number);
+			quic_outq_sync_window(sk);
+			bytes = 0;
+		}
+		if (quic_frame_is_dgram(frame->type)) { /* no need to retransmit dgram */
+			freed += frame->bytes;
+			quic_frame_free(frame);
+		} else {
+			quic_outq_retransmit_one(sk, frame); /* mark as loss */
+			count++;
+		}
+	}
+	quic_outq_wfree(freed, sk);
+	quic_outq_update_loss_timer(sk, level);
+	return count;
+}
+
+void quic_outq_retransmit_list(struct sock *sk, struct list_head *head)
+{
+	struct quic_outqueue *outq = quic_outq(sk);
+	struct quic_frame *frame, *tmp;
+	int bytes = 0;
+
+	list_for_each_entry_safe(frame, tmp, head, list) {
+		list_del(&frame->list);
+		outq->data_inflight -= frame->bytes;
+		if (quic_frame_is_dgram(frame->type)) {
+			bytes += frame->bytes;
+			quic_frame_free(frame);
+			continue;
+		}
+		quic_outq_retransmit_one(sk, frame);
+	}
+	quic_outq_wfree(bytes, sk);
+}
+
+void quic_outq_transmit_one(struct sock *sk, u8 level)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_outqueue *outq = quic_outq(sk);
+	u32 probe_size = QUIC_MIN_UDP_PAYLOAD;
+	struct quic_frame *frame;
+
+	quic_packet_set_max_snd_count(packet, 1);
+	if (quic_outq_transmit(sk))
+		goto out;
+
+	if (quic_outq_retransmit_mark(sk, level, 0)) {
+		quic_packet_set_max_snd_count(packet, 1);
+		if (quic_outq_transmit(sk))
+			goto out;
+	}
+
+	frame = quic_frame_create(sk, QUIC_FRAME_PING, &probe_size);
+	if (frame) {
+		frame->level = level;
+		quic_outq_ctrl_tail(sk, frame, false);
+	}
+out:
+	outq->rtx_count++;
+	quic_outq_update_loss_timer(sk, level);
+}
+
+void quic_outq_validate_path(struct sock *sk, struct quic_frame *frame,
+			     struct quic_path_addr *path)
+{
+	u8 local = quic_path_udp_bind(path), path_alt = QUIC_PATH_ALT_DST;
+	struct quic_outqueue *outq = quic_outq(sk);
+	struct quic_config *c = quic_config(sk);
+	struct quic_frame *pos;
+	struct list_head *head;
+
+	if (quic_inq_event_recv(sk, QUIC_EVENT_CONNECTION_MIGRATION, &local))
+		return;
+
+	if (local) {
+		quic_path_swap_active(path);
+		path_alt = QUIC_PATH_ALT_SRC;
+	}
+	quic_path_addr_free(sk, path, 1);
+	quic_set_sk_addr(sk, quic_path_addr(path, 0), local);
+	quic_path_set_sent_cnt(path, 0);
+	quic_timer_stop(sk, QUIC_TIMER_PATH);
+	quic_timer_reset(sk, QUIC_TIMER_PATH, c->plpmtud_probe_interval);
+
+	head = &outq->control_list;
+	list_for_each_entry(pos, head, list)
+		pos->path_alt &= ~path_alt;
+
+	head = &outq->transmitted_list;
+	list_for_each_entry(pos, head, list)
+		pos->path_alt &= ~path_alt;
+
+	frame->path_alt &= ~path_alt;
+	quic_packet_set_ecn_probes(quic_packet(sk), 0);
+}
+
+void quic_outq_stream_purge(struct sock *sk, struct quic_stream *stream)
+{
+	struct quic_outqueue *outq = quic_outq(sk);
+	struct quic_frame *frame, *tmp;
+	struct quic_pnspace *space;
+	struct list_head *head;
+	int bytes = 0;
+
+	head = &outq->transmitted_list;
+	list_for_each_entry_safe(frame, tmp, head, list) {
+		if (frame->stream != stream)
+			continue;
+
+		space = quic_pnspace(sk, frame->level);
+		quic_pnspace_dec_inflight(space, frame->len);
+		outq->data_inflight -= frame->bytes;
+		list_del(&frame->list);
+		bytes += frame->bytes;
+
+		quic_frame_free(frame);
+	}
+
+	head = &outq->stream_list;
+	list_for_each_entry_safe(frame, tmp, head, list) {
+		if (frame->stream != stream)
+			continue;
+		list_del(&frame->list);
+		bytes += frame->bytes;
+		quic_frame_free(frame);
+	}
+	quic_outq_wfree(bytes, sk);
+}
+
+void quic_outq_list_purge(struct sock *sk, struct list_head *head)
+{
+	struct quic_frame *frame, *next;
+	int bytes = 0;
+
+	list_for_each_entry_safe(frame, next, head, list) {
+		list_del(&frame->list);
+		bytes += frame->bytes;
+		quic_frame_free(frame);
+	}
+	quic_outq_wfree(bytes, sk);
+}
+
+static void quic_outq_encrypted_work(struct work_struct *work)
+{
+	struct quic_sock *qs = container_of(work, struct quic_sock, outq.work);
+	struct sock *sk = &qs->inet.sk;
+	struct sk_buff_head *head;
+	struct quic_crypto_cb *cb;
+	struct sk_buff *skb;
+
+	lock_sock(sk);
+	head = &sk->sk_write_queue;
+	if (sock_flag(sk, SOCK_DEAD)) {
+		skb_queue_purge(head);
+		goto out;
+	}
+
+	skb = skb_dequeue(head);
+	while (skb) {
+		cb = QUIC_CRYPTO_CB(skb);
+		if (quic_packet_config(sk, cb->level, cb->path_alt)) {
+			kfree_skb(skb);
+			skb = skb_dequeue(head);
+			continue;
+		}
+		/* the skb here is ready to send */
+		cb->resume = 1;
+		quic_packet_xmit(sk, skb);
+		skb = skb_dequeue(head);
+	}
+	quic_packet_flush(sk);
+out:
+	release_sock(sk);
+	sock_put(sk);
+}
+
+void quic_outq_encrypted_tail(struct sock *sk, struct sk_buff *skb)
+{
+	struct quic_outqueue *outq = quic_outq(sk);
+
+	sock_hold(sk);
+	skb_queue_tail(&sk->sk_write_queue, skb);
+
+	if (!schedule_work(&outq->work))
+		sock_put(sk);
+}
+
+void quic_outq_set_param(struct sock *sk, struct quic_transport_param *p)
+{
+	struct quic_outqueue *outq = quic_outq(sk);
+	struct quic_inqueue *inq = quic_inq(sk);
+	u32 remote_idle, local_idle, pmtu;
+
+	outq->max_datagram_frame_size = p->max_datagram_frame_size;
+	pmtu = min_t(u32, dst_mtu(__sk_dst_get(sk)), QUIC_PATH_MAX_PMTU);
+	quic_packet_mss_update(sk, pmtu - quic_encap_len(sk));
+
+	outq->max_udp_payload_size = p->max_udp_payload_size;
+	outq->ack_delay_exponent = p->ack_delay_exponent;
+	outq->max_idle_timeout = p->max_idle_timeout;
+	outq->max_ack_delay = p->max_ack_delay;
+	outq->grease_quic_bit = p->grease_quic_bit;
+	outq->disable_1rtt_encryption = p->disable_1rtt_encryption;
+	outq->max_bytes = p->max_data;
+
+	remote_idle = outq->max_idle_timeout;
+	local_idle = quic_inq_max_idle_timeout(inq);
+	if (remote_idle && (!local_idle || remote_idle < local_idle))
+		quic_inq_set_max_idle_timeout(inq, remote_idle);
+
+	if (quic_inq_disable_1rtt_encryption(inq) && outq->disable_1rtt_encryption)
+		quic_packet_set_taglen(quic_packet(sk), 0);
+}
+
+void quic_outq_init(struct sock *sk)
+{
+	struct quic_outqueue *outq = quic_outq(sk);
+
+	INIT_LIST_HEAD(&outq->stream_list);
+	INIT_LIST_HEAD(&outq->control_list);
+	INIT_LIST_HEAD(&outq->datagram_list);
+	INIT_LIST_HEAD(&outq->transmitted_list);
+	skb_queue_head_init(&sk->sk_write_queue);
+	INIT_WORK(&outq->work, quic_outq_encrypted_work);
+}
+
+void quic_outq_free(struct sock *sk)
+{
+	struct quic_outqueue *outq = quic_outq(sk);
+
+	quic_outq_list_purge(sk, &outq->transmitted_list);
+	quic_outq_list_purge(sk, &outq->datagram_list);
+	quic_outq_list_purge(sk, &outq->control_list);
+	quic_outq_list_purge(sk, &outq->stream_list);
+	kfree(outq->close_phrase);
+}
diff --git a/net/quic/output.h b/net/quic/output.h
new file mode 100644
index 000000000000..cf40c5aa239a
--- /dev/null
+++ b/net/quic/output.h
@@ -0,0 +1,199 @@
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
+struct quic_outqueue {
+	struct list_head transmitted_list;
+	struct list_head datagram_list;
+	struct list_head control_list;
+	struct list_head stream_list;
+	struct work_struct work;
+	u64 last_max_bytes;
+	u64 data_inflight;
+	u64 max_bytes;
+	u64 window;
+	u64 bytes;
+
+	struct quic_conn_id retry_dcid;
+	struct quic_conn_id orig_dcid;
+	u32 max_datagram_frame_size;
+	u32 max_udp_payload_size;
+	u32 ack_delay_exponent;
+	u32 max_idle_timeout;
+	u32 max_ack_delay;
+
+	u8 disable_1rtt_encryption:1;
+	u8 grease_quic_bit:1;
+	u8 data_blocked:1;
+	u8 pref_addr:1;
+	u8 retry:1;
+	u8 serv:1;
+
+	u32 close_errcode;
+	u8 *close_phrase;
+	u8 close_frame;
+	u8 rtx_count;
+	/* Use for 0-RTT/1-RTT DATA (re)transmit,
+	 * as QUIC_CRYPTO_CB(skb)->level is always QUIC_CRYPTO_APP.
+	 * Set this level to QUIC_CRYPTO_EARLY or QUIC_CRYPTO_APP
+	 * when the corresponding crypto is ready for send.
+	 */
+	u8 data_level;
+};
+
+static inline u64 quic_outq_window(struct quic_outqueue *outq)
+{
+	return outq->window;
+}
+
+static inline u32 quic_outq_ack_delay_exponent(struct quic_outqueue *outq)
+{
+	return outq->ack_delay_exponent;
+}
+
+static inline u32 quic_outq_max_udp(struct quic_outqueue *outq)
+{
+	return outq->max_udp_payload_size;
+}
+
+static inline u64 quic_outq_max_bytes(struct quic_outqueue *outq)
+{
+	return outq->max_bytes;
+}
+
+static inline void quic_outq_set_max_bytes(struct quic_outqueue *outq, u64 bytes)
+{
+	outq->max_bytes = bytes;
+}
+
+static inline u32 quic_outq_close_errcode(struct quic_outqueue *outq)
+{
+	return outq->close_errcode;
+}
+
+static inline void quic_outq_set_close_errcode(struct quic_outqueue *outq, u32 errcode)
+{
+	outq->close_errcode = errcode;
+}
+
+static inline u8 quic_outq_close_frame(struct quic_outqueue *outq)
+{
+	return outq->close_frame;
+}
+
+static inline void quic_outq_set_close_frame(struct quic_outqueue *outq, u8 type)
+{
+	outq->close_frame = type;
+}
+
+static inline u8 *quic_outq_close_phrase(struct quic_outqueue *outq)
+{
+	return outq->close_phrase;
+}
+
+static inline void quic_outq_set_close_phrase(struct quic_outqueue *outq, u8 *phrase)
+{
+	outq->close_phrase = phrase;
+}
+
+static inline u8 quic_outq_retry(struct quic_outqueue *outq)
+{
+	return outq->retry;
+}
+
+static inline void quic_outq_set_retry(struct quic_outqueue *outq, u8 retry)
+{
+	outq->retry = retry;
+}
+
+static inline u32 quic_outq_max_dgram(struct quic_outqueue *outq)
+{
+	return outq->max_datagram_frame_size;
+}
+
+static inline u8 quic_outq_grease_quic_bit(struct quic_outqueue *outq)
+{
+	return outq->grease_quic_bit;
+}
+
+static inline struct quic_conn_id *quic_outq_orig_dcid(struct quic_outqueue *outq)
+{
+	return &outq->orig_dcid;
+}
+
+static inline void quic_outq_set_orig_dcid(struct quic_outqueue *outq,
+					   struct quic_conn_id *dcid)
+{
+	outq->orig_dcid = *dcid;
+}
+
+static inline struct quic_conn_id *quic_outq_retry_dcid(struct quic_outqueue *outq)
+{
+	return &outq->retry_dcid;
+}
+
+static inline void quic_outq_set_retry_dcid(struct quic_outqueue *outq,
+					    struct quic_conn_id *dcid)
+{
+	outq->retry_dcid = *dcid;
+}
+
+static inline void quic_outq_set_serv(struct quic_outqueue *outq)
+{
+	outq->serv = 1;
+}
+
+static inline void quic_outq_set_data_level(struct quic_outqueue *outq, u8 level)
+{
+	outq->data_level = level;
+}
+
+static inline void quic_outq_set_pref_addr(struct quic_outqueue *outq, u8 pref_addr)
+{
+	outq->pref_addr = pref_addr;
+}
+
+static inline u8 quic_outq_pref_addr(struct quic_outqueue *outq)
+{
+	return outq->pref_addr;
+}
+
+static inline u32 quic_outq_data_inflight(struct quic_outqueue *outq)
+{
+	return outq->data_inflight;
+}
+
+void quic_outq_stream_tail(struct sock *sk, struct quic_frame *frame, bool cork);
+void quic_outq_dgram_tail(struct sock *sk, struct quic_frame *frame, bool cork);
+void quic_outq_ctrl_tail(struct sock *sk, struct quic_frame *frame, bool cork);
+void quic_outq_transmit_one(struct sock *sk, u8 level);
+int quic_outq_transmit(struct sock *sk);
+
+void quic_outq_transmitted_sack(struct sock *sk, u8 level, s64 largest,
+				s64 smallest, s64 ack_largest, u32 ack_delay);
+void quic_outq_validate_path(struct sock *sk, struct quic_frame *frame,
+			     struct quic_path_addr *path);
+void quic_outq_transmitted_tail(struct sock *sk, struct quic_frame *frame);
+void quic_outq_retransmit_list(struct sock *sk, struct list_head *head);
+int quic_outq_retransmit_mark(struct sock *sk, u8 level, u8 immediate);
+void quic_outq_update_loss_timer(struct sock *sk, u8 level);
+
+void quic_outq_transmit_close(struct sock *sk, u8 frame, u32 errcode, u8 level);
+void quic_outq_stream_purge(struct sock *sk, struct quic_stream *stream);
+void quic_outq_encrypted_tail(struct sock *sk, struct sk_buff *skb);
+void quic_outq_list_purge(struct sock *sk, struct list_head *head);
+void quic_outq_transmit_app_close(struct sock *sk);
+void quic_outq_transmit_probe(struct sock *sk);
+
+void quic_outq_set_param(struct sock *sk, struct quic_transport_param *p);
+void quic_outq_set_owner_w(int len, struct sock *sk);
+void quic_outq_wfree(int len, struct sock *sk);
+void quic_outq_sync_window(struct sock *sk);
+void quic_outq_init(struct sock *sk);
+void quic_outq_free(struct sock *sk);
diff --git a/net/quic/packet.c b/net/quic/packet.c
new file mode 100644
index 000000000000..8ab4a14675ad
--- /dev/null
+++ b/net/quic/packet.c
@@ -0,0 +1,1523 @@
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
+#include <linux/version.h>
+#include <net/gro.h>
+
+#include "socket.h"
+
+#define QUIC_VERSION_NUM	2
+
+static u32 quic_versions[QUIC_VERSION_NUM][3] = {
+	/* version,	compatible versions */
+	{ QUIC_VERSION_V1,	QUIC_VERSION_V2,	0 },
+	{ QUIC_VERSION_V2,	QUIC_VERSION_V1,	0 },
+};
+
+u32 *quic_packet_compatible_versions(u32 version)
+{
+	u8 i;
+
+	for (i = 0; i < QUIC_VERSION_NUM; i++)
+		if (version == quic_versions[i][0])
+			return quic_versions[i];
+	return NULL;
+}
+
+static u8 quic_packet_version_get_type(u32 version, u8 type)
+{
+	if (version == QUIC_VERSION_V1)
+		return type;
+
+	switch (type) {
+	case QUIC_PACKET_INITIAL_V2:
+		return QUIC_PACKET_INITIAL;
+	case QUIC_PACKET_0RTT_V2:
+		return QUIC_PACKET_0RTT;
+	case QUIC_PACKET_HANDSHAKE_V2:
+		return QUIC_PACKET_HANDSHAKE;
+	case QUIC_PACKET_RETRY_V2:
+		return QUIC_PACKET_RETRY;
+	default:
+		return -1;
+	}
+	return -1;
+}
+
+static u8 quic_packet_version_put_type(u32 version, u8 type)
+{
+	if (version == QUIC_VERSION_V1)
+		return type;
+
+	switch (type) {
+	case QUIC_PACKET_INITIAL:
+		return QUIC_PACKET_INITIAL_V2;
+	case QUIC_PACKET_0RTT:
+		return QUIC_PACKET_0RTT_V2;
+	case QUIC_PACKET_HANDSHAKE:
+		return QUIC_PACKET_HANDSHAKE_V2;
+	case QUIC_PACKET_RETRY:
+		return QUIC_PACKET_RETRY_V2;
+	default:
+		return -1;
+	}
+	return -1;
+}
+
+static int quic_packet_get_version_and_connid(struct quic_packet *packet, u8 **pp, u32 *plen)
+{
+	u8 *p = *pp;
+	u64 len, v;
+
+	if (!quic_get_int(pp, plen, &v, 1))
+		return -EINVAL;
+
+	if (!quic_get_int(pp, plen, &v, QUIC_VERSION_LEN))
+		return -EINVAL;
+	packet->version = v;
+
+	if (!quic_get_int(pp, plen, &len, 1) ||
+	    len > *plen || len > QUIC_CONN_ID_MAX_LEN)
+		return -EINVAL;
+	quic_conn_id_update(&packet->dcid, *pp, len);
+	*plen -= len;
+	*pp += len;
+
+	if (!quic_get_int(pp, plen, &len, 1) ||
+	    len > *plen || len > QUIC_CONN_ID_MAX_LEN)
+		return -EINVAL;
+	quic_conn_id_update(&packet->scid, *pp, len);
+	*plen -= len;
+	*pp += len;
+
+	packet->len = *pp - p;
+	return 0;
+}
+
+int quic_packet_version_change(struct sock *sk, struct quic_conn_id *conn_id, u32 version)
+{
+	struct quic_crypto *crypto = quic_crypto(sk, QUIC_CRYPTO_INITIAL);
+
+	/* initial keys must be updated when version changes */
+	quic_crypto_destroy(crypto);
+	if (quic_crypto_initial_keys_install(crypto, conn_id, version, quic_is_serv(sk)))
+		return -EINVAL;
+	quic_config(sk)->version = version;
+	return 0;
+}
+
+int quic_packet_select_version(struct sock *sk, u32 *versions, u8 count)
+{
+	u32 best = 0;
+	u8 i, j;
+
+	for (i = 0; i < count; i++) {
+		for (j = 0; j < QUIC_VERSION_NUM; j++) {
+			if (versions[i] == quic_versions[j][0] && best < versions[i]) {
+				best = versions[i];
+				goto found;
+			}
+		}
+	}
+	return -1;
+found:
+	if (best == quic_config(sk)->version)
+		return 0;
+	return quic_packet_version_change(sk, quic_outq_orig_dcid(quic_outq(sk)), best);
+}
+
+static int quic_packet_get_token(struct quic_data *token, u8 **pp, u32 *plen)
+{
+	u64 len;
+
+	if (!quic_get_var(pp, plen, &len) || len > *plen)
+		return -EINVAL;
+	quic_data(token, *pp, len);
+	*plen -= len;
+	*pp += len;
+	return 0;
+}
+
+static void quic_packet_get_addrs(struct sock *sk, struct sk_buff *skb)
+{
+	struct quic_packet *packet = quic_packet(sk);
+
+	packet->sa = &packet->saddr;
+	packet->da = &packet->daddr;
+	quic_get_msg_addr(sk, packet->sa, skb, 0);
+	quic_get_msg_addr(sk, packet->da, skb, 1);
+}
+
+/* Retry Packet {
+ *   Header Form (1) = 1,
+ *   Fixed Bit (1) = 1,
+ *   Long Packet Type (2) = 3,
+ *   Unused (4),
+ *   Version (32),
+ *   Destination Connection ID Length (8),
+ *   Destination Connection ID (0..160),
+ *   Source Connection ID Length (8),
+ *   Source Connection ID (0..160),
+ *   Retry Token (..),
+ *   Retry Integrity Tag (128),
+ * }
+ */
+
+static struct sk_buff *quic_packet_retry_create(struct sock *sk)
+{
+	struct quic_crypto *crypto = quic_crypto(sk, QUIC_CRYPTO_INITIAL);
+	struct quic_packet *packet = quic_packet(sk);
+	u8 *p, token[72], tag[16];
+	struct quic_conn_id dcid;
+	int len, hlen, tokenlen;
+	struct quichshdr *hdr;
+	struct sk_buff *skb;
+
+	p = token;
+	p = quic_put_int(p, 1, 1); /* retry token flag */
+	if (quic_crypto_generate_token(crypto, packet->da, quic_addr_len(sk),
+				       &packet->dcid, token, &tokenlen))
+		return NULL;
+
+	quic_conn_id_generate(&dcid); /* new dcid for retry */
+	len = 1 + QUIC_VERSION_LEN + 1 + packet->scid.len + 1 + dcid.len + tokenlen + 16;
+	hlen = quic_encap_len(sk) + MAX_HEADER;
+	skb = alloc_skb(hlen + len, GFP_ATOMIC);
+	if (!skb)
+		return NULL;
+	skb_reserve(skb, hlen + len);
+
+	hdr = skb_push(skb, len);
+	hdr->form = 1;
+	hdr->fixed = !quic_outq_grease_quic_bit(quic_outq(sk));
+	hdr->type = quic_packet_version_put_type(packet->version, QUIC_PACKET_RETRY);
+	hdr->reserved = 0;
+	hdr->pnl = 0;
+	skb_reset_transport_header(skb);
+
+	p = (u8 *)hdr + 1;
+	p = quic_put_int(p, packet->version, QUIC_VERSION_LEN);
+	p = quic_put_int(p, packet->scid.len, 1);
+	p = quic_put_data(p, packet->scid.data, packet->scid.len);
+	p = quic_put_int(p, dcid.len, 1);
+	p = quic_put_data(p, dcid.data, dcid.len);
+	p = quic_put_data(p, token, tokenlen);
+	if (quic_crypto_get_retry_tag(crypto, skb, &packet->dcid, packet->version, tag)) {
+		kfree_skb(skb);
+		return NULL;
+	}
+	p = quic_put_data(p, tag, 16);
+
+	return skb;
+}
+
+static int quic_packet_retry_transmit(struct sock *sk)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct sk_buff *skb;
+
+	__sk_dst_reset(sk);
+	if (quic_flow_route(sk, packet->da, packet->sa))
+		return -EINVAL;
+	skb = quic_packet_retry_create(sk);
+	if (!skb)
+		return -ENOMEM;
+	quic_lower_xmit(sk, skb, packet->da, packet->sa);
+	return 0;
+}
+
+/* Version Negotiation Packet {
+ *   Header Form (1) = 1,
+ *   Unused (7),
+ *   Version (32) = 0,
+ *   Destination Connection ID Length (8),
+ *   Destination Connection ID (0..2040),
+ *   Source Connection ID Length (8),
+ *   Source Connection ID (0..2040),
+ *   Supported Version (32) ...,
+ * }
+ */
+
+static struct sk_buff *quic_packet_version_create(struct sock *sk)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct quichshdr *hdr;
+	struct sk_buff *skb;
+	int len, hlen;
+	u8 *p;
+
+	len = 1 + QUIC_VERSION_LEN + 1 + packet->scid.len + 1 + packet->dcid.len +
+	      QUIC_VERSION_LEN * 2;
+	hlen = quic_encap_len(sk) + MAX_HEADER;
+	skb = alloc_skb(hlen + len, GFP_ATOMIC);
+	if (!skb)
+		return NULL;
+	skb_reserve(skb, hlen + len);
+
+	hdr = skb_push(skb, len);
+	hdr->form = 1;
+	hdr->fixed = !quic_outq_grease_quic_bit(quic_outq(sk));
+	hdr->type = 0;
+	hdr->reserved = 0;
+	hdr->pnl = 0;
+	skb_reset_transport_header(skb);
+
+	p = (u8 *)hdr + 1;
+	p = quic_put_int(p, 0, QUIC_VERSION_LEN);
+	p = quic_put_int(p, packet->scid.len, 1);
+	p = quic_put_data(p, packet->scid.data, packet->scid.len);
+	p = quic_put_int(p, packet->dcid.len, 1);
+	p = quic_put_data(p, packet->dcid.data, packet->dcid.len);
+	p = quic_put_int(p, QUIC_VERSION_V1, QUIC_VERSION_LEN);
+	p = quic_put_int(p, QUIC_VERSION_V2, QUIC_VERSION_LEN);
+
+	return skb;
+}
+
+static int quic_packet_version_transmit(struct sock *sk)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct sk_buff *skb;
+
+	__sk_dst_reset(sk);
+	if (quic_flow_route(sk, packet->da, packet->sa))
+		return -EINVAL;
+	skb = quic_packet_version_create(sk);
+	if (!skb)
+		return -ENOMEM;
+	quic_lower_xmit(sk, skb, packet->da, packet->sa);
+	return 0;
+}
+
+/* Stateless Reset {
+ *   Fixed Bits (2) = 1,
+ *   Unpredictable Bits (38..),
+ *   Stateless Reset Token (128),
+ * }
+ */
+
+static struct sk_buff *quic_packet_stateless_reset_create(struct sock *sk)
+{
+	struct quic_crypto *crypto = quic_crypto(sk, QUIC_CRYPTO_INITIAL);
+	struct quic_packet *packet = quic_packet(sk);
+	struct sk_buff *skb;
+	u8 *p, token[16];
+	int len, hlen;
+
+	if (quic_crypto_generate_stateless_reset_token(crypto, packet->dcid.data,
+						       packet->dcid.len, token, 16))
+		return NULL;
+
+	len = 64;
+	hlen = quic_encap_len(sk) + MAX_HEADER;
+	skb = alloc_skb(hlen + len, GFP_ATOMIC);
+	if (!skb)
+		return NULL;
+	skb_reserve(skb, hlen + len);
+
+	p = skb_push(skb, len);
+	get_random_bytes(p, len);
+
+	skb_reset_transport_header(skb);
+	quic_hdr(skb)->form = 0;
+	quic_hdr(skb)->fixed = 1;
+
+	p += (len - 16);
+	p = quic_put_data(p, token, 16);
+
+	return skb;
+}
+
+static int quic_packet_stateless_reset_transmit(struct sock *sk)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct sk_buff *skb;
+
+	__sk_dst_reset(sk);
+	if (quic_flow_route(sk, packet->da, packet->sa))
+		return -EINVAL;
+	skb = quic_packet_stateless_reset_create(sk);
+	if (!skb)
+		return -ENOMEM;
+	quic_lower_xmit(sk, skb, packet->da, packet->sa);
+	return 0;
+}
+
+static int quic_packet_refuse_close_transmit(struct sock *sk, u32 errcode)
+{
+	struct quic_conn_id_set *source = quic_source(sk);
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_conn_id *active;
+	struct quic_frame *frame;
+	int err;
+
+	active = quic_conn_id_active(source);
+	quic_conn_id_update(active, packet->dcid.data, packet->dcid.len);
+	quic_path_addr_set(quic_src(sk), packet->sa, 1);
+	quic_path_addr_set(quic_dst(sk), packet->da, 1);
+
+	err = quic_packet_version_change(sk, active, packet->version);
+	if (err)
+		return err;
+
+	quic_outq_set_close_errcode(quic_outq(sk), errcode);
+	frame = quic_frame_create(sk, QUIC_FRAME_CONNECTION_CLOSE, NULL);
+	if (frame) {
+		frame->level = QUIC_CRYPTO_INITIAL;
+		frame->path_alt = (QUIC_PATH_ALT_SRC | QUIC_PATH_ALT_DST);
+		quic_outq_ctrl_tail(sk, frame, false);
+	}
+	return 0;
+}
+
+static int quic_packet_listen_process(struct sock *sk, struct sk_buff *skb)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	int err = 0, errcode, len = skb->len;
+	u8 *p = skb->data, type, retry = 0;
+	struct quic_crypto *crypto;
+	struct quic_conn_id odcid;
+	struct quic_data token;
+
+	/* set af_ops for now in case sk_family != addr.v4.sin_family */
+	quic_set_af_ops(sk, quic_af_ops_get_skb(skb));
+	quic_packet_get_addrs(sk, skb);
+	if (quic_request_sock_exists(sk))
+		goto enqueue;
+
+	if (QUIC_CRYPTO_CB(skb)->backlog && quic_accept_sock_exists(sk, skb))
+		goto out; /* moved skb to another sk backlog */
+
+	if (!quic_hshdr(skb)->form) { /* stateless reset always by listen sock */
+		if (len < 17) {
+			err = -EINVAL;
+			kfree_skb(skb);
+			goto out;
+		}
+		quic_conn_id_update(&packet->dcid, (u8 *)quic_hdr(skb) + 1, 16);
+		err = quic_packet_stateless_reset_transmit(sk);
+		consume_skb(skb);
+		goto out;
+	}
+
+	if (quic_packet_get_version_and_connid(packet, &p, &len)) {
+		err = -EINVAL;
+		kfree_skb(skb);
+		goto out;
+	}
+
+	if (!quic_packet_compatible_versions(packet->version)) { /* version negotication */
+		err = quic_packet_version_transmit(sk);
+		consume_skb(skb);
+		goto out;
+	}
+
+	type = quic_packet_version_get_type(packet->version, quic_hshdr(skb)->type);
+	if (type != QUIC_PACKET_INITIAL) { /* stateless reset for handshake */
+		err = quic_packet_stateless_reset_transmit(sk);
+		consume_skb(skb);
+		goto out;
+	}
+
+	if (quic_packet_get_token(&token, &p, &len)) {
+		err = -EINVAL;
+		kfree_skb(skb);
+		goto out;
+	}
+	quic_conn_id_update(&odcid, packet->dcid.data, packet->dcid.len);
+	if (quic_config(sk)->validate_peer_address) {
+		if (!token.len) {
+			err = quic_packet_retry_transmit(sk);
+			consume_skb(skb);
+			goto out;
+		}
+		crypto = quic_crypto(sk, QUIC_CRYPTO_INITIAL);
+		err = quic_crypto_verify_token(crypto, packet->da, quic_addr_len(sk),
+					       &odcid, token.data, token.len);
+		if (err) {
+			errcode = QUIC_TRANSPORT_ERROR_INVALID_TOKEN;
+			err = quic_packet_refuse_close_transmit(sk, errcode);
+			consume_skb(skb);
+			goto out;
+		}
+		retry = *(u8 *)token.data;
+	}
+
+	err = quic_request_sock_enqueue(sk, &odcid, retry);
+	if (err) {
+		errcode = QUIC_TRANSPORT_ERROR_CONNECTION_REFUSED;
+		err = quic_packet_refuse_close_transmit(sk, errcode);
+		consume_skb(skb);
+		goto out;
+	}
+enqueue:
+	if (atomic_read(&sk->sk_rmem_alloc) + skb->len > sk->sk_rcvbuf) {
+		err = -ENOBUFS;
+		kfree_skb(skb);
+		goto out;
+	}
+
+	skb_set_owner_r(skb, sk); /* handle it later when accepting the sock */
+	quic_inq_backlog_tail(sk, skb);
+	sk->sk_data_ready(sk);
+out:
+	quic_set_af_ops(sk, quic_af_ops_get(sk->sk_family));
+	return err;
+}
+
+static int quic_packet_stateless_reset_process(struct sock *sk, struct sk_buff *skb)
+{
+	struct quic_conn_id_set *id_set = quic_dest(sk);
+	struct quic_connection_close close = {};
+	u8 *token;
+
+	if (skb->len < 22)
+		return -EINVAL;
+
+	token = skb->data + skb->len - 16;
+	if (!quic_conn_id_token_exists(id_set, token))
+		return -EINVAL; /* not a stateless reset and the caller will free skb */
+
+	close.errcode = QUIC_TRANSPORT_ERROR_CRYPTO;
+	if (quic_inq_event_recv(sk, QUIC_EVENT_CONNECTION_CLOSE, &close))
+		return -ENOMEM;
+	quic_set_state(sk, QUIC_SS_CLOSED);
+	consume_skb(skb);
+	pr_debug("%s: peer reset\n", __func__);
+	return 0;
+}
+
+static int quic_packet_handshake_retry_process(struct sock *sk, struct sk_buff *skb)
+{
+	struct quic_crypto *crypto = quic_crypto(sk, QUIC_CRYPTO_INITIAL);
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_outqueue *outq = quic_outq(sk);
+	u32 len = skb->len - packet->len, version;
+	u8 *p = skb->data + packet->len, tag[16];
+	struct quic_conn_id *active;
+
+	if (len < 16)
+		goto err;
+	version = quic_config(sk)->version;
+	if (quic_crypto_get_retry_tag(crypto, skb, quic_outq_orig_dcid(outq), version, tag) ||
+	    memcmp(tag, p + len - 16, 16))
+		goto err;
+	if (quic_data_dup(quic_token(sk), p, len - 16))
+		goto err;
+	/* similar to version change, update the initial keys */
+	if (quic_packet_version_change(sk, &packet->scid, version))
+		goto err;
+	active = quic_conn_id_active(quic_dest(sk));
+	quic_conn_id_update(active, packet->scid.data, packet->scid.len);
+	quic_outq_set_retry(outq, 1);
+	quic_outq_set_retry_dcid(outq, active);
+	quic_outq_retransmit_mark(sk, QUIC_CRYPTO_INITIAL, 1);
+	quic_outq_transmit(sk);
+
+	consume_skb(skb);
+	return 0;
+err:
+	kfree_skb(skb);
+	return -EINVAL;
+}
+
+static int quic_packet_handshake_version_process(struct sock *sk, struct sk_buff *skb)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	int len = skb->len - packet->len;
+	u8 *p = skb->data + packet->len;
+	u64 version, best = 0;
+
+	if (len < 4)
+		goto err;
+
+	while (len >= 4) {
+		quic_get_int(&p, &len, &version, QUIC_VERSION_LEN);
+		if (quic_packet_compatible_versions(version) && best < version)
+			best = version;
+	}
+	if (best) {
+		if (quic_packet_version_change(sk, &packet->scid, best))
+			goto err;
+		quic_outq_retransmit_mark(sk, QUIC_CRYPTO_INITIAL, 1);
+		quic_outq_transmit(sk);
+	}
+
+	consume_skb(skb);
+	return 0;
+err:
+	kfree_skb(skb);
+	return -EINVAL;
+}
+
+static void quic_packet_decrypt_done(struct sk_buff *skb, int err)
+{
+	if (err) {
+		kfree_skb(skb);
+		pr_debug("%s: err: %d\n", __func__, err);
+		return;
+	}
+
+	quic_inq_decrypted_tail(skb->sk, skb);
+}
+
+static int quic_packet_handshake_header_process(struct sock *sk, struct sk_buff *skb)
+{
+	u8 *p = (u8 *)quic_hshdr(skb), type = quic_hshdr(skb)->type;
+	struct quic_crypto_cb *cb = QUIC_CRYPTO_CB(skb);
+	struct quic_packet *packet = quic_packet(sk);
+	int len = skb->len, version;
+	struct quic_data token;
+	u64 length;
+
+	quic_packet_reset(packet);
+	if (quic_packet_get_version_and_connid(packet, &p, &len))
+		return -EINVAL;
+	version = packet->version;
+	if (!version) {
+		quic_packet_handshake_version_process(sk, skb);
+		packet->level = 0;
+		return 0;
+	}
+	type = quic_packet_version_get_type(version, type);
+	if (version != quic_config(sk)->version) {
+		if (type != QUIC_PACKET_INITIAL || !quic_packet_compatible_versions(version))
+			return -EINVAL;
+		/* change to this compatible version */
+		if (quic_packet_version_change(sk, quic_outq_orig_dcid(quic_outq(sk)), version))
+			return -EINVAL;
+	}
+	switch (type) {
+	case QUIC_PACKET_INITIAL:
+		if (quic_packet_get_token(&token, &p, &len))
+			return -EINVAL;
+		packet->level = QUIC_CRYPTO_INITIAL;
+		if (!quic_is_serv(sk) && token.len) {
+			packet->errcode = QUIC_TRANSPORT_ERROR_PROTOCOL_VIOLATION;
+			return -EINVAL;
+		}
+		break;
+	case QUIC_PACKET_HANDSHAKE:
+		if (!quic_crypto_recv_ready(quic_crypto(sk, QUIC_CRYPTO_HANDSHAKE))) {
+			quic_inq_backlog_tail(sk, skb);
+			return 0;
+		}
+		packet->level = QUIC_CRYPTO_HANDSHAKE;
+		break;
+	case QUIC_PACKET_0RTT:
+		if (!quic_crypto_recv_ready(quic_crypto(sk, QUIC_CRYPTO_EARLY))) {
+			quic_inq_backlog_tail(sk, skb);
+			return 0;
+		}
+		packet->level = QUIC_CRYPTO_EARLY;
+		break;
+	case QUIC_PACKET_RETRY:
+		quic_packet_handshake_retry_process(sk, skb);
+		packet->level = 0;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+
+	if (!quic_get_var(&p, &len, &length) || length > len)
+		return -EINVAL;
+	cb->length = length;
+	cb->number_offset = p - skb->data;
+	return 0;
+}
+
+static int quic_packet_handshake_process(struct sock *sk, struct sk_buff *skb)
+{
+	struct quic_crypto_cb *cb = QUIC_CRYPTO_CB(skb);
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_inqueue *inq = quic_inq(sk);
+	struct quic_frame frame = {}, *nframe;
+	struct quic_conn_id *active;
+	struct quic_crypto *crypto;
+	struct quic_pnspace *space;
+	struct quichshdr *hshdr;
+	int err = -EINVAL;
+	u8 level;
+
+	WARN_ON(!skb_set_owner_sk_safe(skb, sk));
+
+	while (skb->len > 0) {
+		hshdr = quic_hshdr(skb);
+		if (!hshdr->form) { /* handle it later when setting 1RTT key */
+			cb->number_offset = 0;
+			return quic_packet_process(sk, skb);
+		}
+		if (quic_packet_handshake_header_process(sk, skb))
+			goto err;
+		if (!packet->level)
+			return 0;
+
+		/* Do decryption */
+		crypto = quic_crypto(sk, packet->level);
+		level = (packet->level % QUIC_CRYPTO_EARLY);
+		space = quic_pnspace(sk, level);
+
+		cb->number_max = quic_pnspace_max_pn_seen(space);
+		cb->crypto_done = quic_packet_decrypt_done;
+		err = quic_crypto_decrypt(crypto, skb);
+		if (err) {
+			if (err == -EINPROGRESS)
+				return err;
+			packet->errcode = cb->errcode;
+			goto err;
+		}
+		if (hshdr->reserved) {
+			packet->errcode = QUIC_TRANSPORT_ERROR_PROTOCOL_VIOLATION;
+			goto err;
+		}
+
+		pr_debug("%s: recvd, num: %llu, level: %d, len: %d\n",
+			 __func__, cb->number, packet->level, skb->len);
+
+		err = quic_pnspace_check(space, cb->number);
+		if (err) {
+			err = -EINVAL;
+			goto err;
+		}
+
+		frame.data = skb->data + cb->number_offset + cb->number_len;
+		frame.len = cb->length - cb->number_len - packet->taglen[1];
+		frame.level = packet->level;
+		frame.skb = skb;
+		err = quic_frame_process(sk, &frame);
+		if (err)
+			goto err;
+		err = quic_pnspace_mark(space, cb->number);
+		if (err)
+			goto err;
+		skb_pull(skb, cb->number_offset + cb->length);
+		if (packet->ack_eliciting) {
+			if (!quic_is_serv(sk) && packet->level == QUIC_CRYPTO_INITIAL) {
+				active = quic_conn_id_active(quic_dest(sk));
+				quic_conn_id_update(active, packet->scid.data, packet->scid.len);
+			}
+			nframe = quic_frame_create(sk, QUIC_FRAME_ACK, &level);
+			if (nframe) {
+				quic_outq_ctrl_tail(sk, nframe, true);
+				/* in case userspace doesn't send any packets, use SACK
+				 * timer to send these SACK frames out.
+				 */
+				if (!quic_inq_need_sack(inq)) {
+					quic_timer_reset(sk, QUIC_TIMER_SACK,
+							 quic_inq_max_ack_delay(inq));
+					quic_inq_set_need_sack(inq, 1);
+				}
+			}
+		}
+		cb->resume = 0;
+		skb_reset_transport_header(skb);
+	}
+
+	if (!quic_inq_need_sack(inq)) /* delay sack timer is reused as idle timer */
+		quic_timer_reset(sk, QUIC_TIMER_SACK, quic_inq_max_idle_timeout(inq));
+
+	consume_skb(skb);
+	return 0;
+err:
+	pr_debug("%s: failed, num: %llu, level: %d, err: %d\n",
+		 __func__, cb->number, packet->level, err);
+	quic_outq_transmit_close(sk, frame.type, packet->errcode, packet->level);
+	kfree_skb(skb);
+	return err;
+}
+
+static int quic_packet_app_process_done(struct sock *sk, struct sk_buff *skb)
+{
+	struct quic_pnspace *space = quic_pnspace(sk, QUIC_CRYPTO_APP);
+	struct quic_crypto *crypto = quic_crypto(sk, QUIC_CRYPTO_APP);
+	struct quic_crypto_cb *cb = QUIC_CRYPTO_CB(skb);
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_inqueue *inq = quic_inq(sk);
+	struct quic_frame *frame;
+	u8 key_phase, level = 0;
+
+	quic_pnspace_inc_ecn_count(space, quic_get_msg_ecn(sk, skb));
+
+	/* connection migration check: an endpoint only changes the address to which
+	 * it sends packets in response to the highest-numbered non-probing packet.
+	 */
+	if (packet->non_probing && cb->number == quic_pnspace_max_pn_seen(space)) {
+		if (!quic_conn_id_disable_active_migration(quic_dest(sk)) &&
+		    (cb->path_alt & QUIC_PATH_ALT_DST))
+			quic_sock_change_daddr(sk, packet->da, quic_addr_len(sk));
+		if (quic_outq_pref_addr(quic_outq(sk)) &&
+		    (cb->path_alt & QUIC_PATH_ALT_SRC))
+			quic_sock_change_saddr(sk, NULL, 0);
+	}
+
+	if (cb->key_update) {
+		key_phase = cb->key_phase;
+		if (!quic_inq_event_recv(sk, QUIC_EVENT_KEY_UPDATE, &key_phase)) {
+			quic_crypto_set_key_pending(crypto, 0);
+			quic_crypto_set_key_update_send_time(crypto, 0);
+		}
+	}
+
+	if (!packet->ack_eliciting)
+		goto out;
+
+	if (!packet->ack_immediate && !quic_pnspace_has_gap(space) &&
+	    packet->rcv_count++ < packet->max_rcv_count - 1) {
+		if (!quic_inq_need_sack(inq))
+			quic_timer_reset(sk, QUIC_TIMER_SACK, quic_inq_max_ack_delay(inq));
+		quic_inq_set_need_sack(inq, 2);
+		goto out;
+	}
+	packet->rcv_count = 0;
+	frame = quic_frame_create(sk, QUIC_FRAME_ACK, &level);
+	if (frame) {
+		frame->path_alt = cb->path_alt;
+		quic_outq_ctrl_tail(sk, frame, true);
+	}
+
+out:
+	consume_skb(skb);
+	if (!quic_inq_need_sack(inq)) /* delay sack timer is reused as idle timer */
+		quic_timer_reset(sk, QUIC_TIMER_SACK, quic_inq_max_idle_timeout(inq));
+	if (quic_is_established(sk))
+		quic_outq_transmit(sk);
+	return 0;
+}
+
+static int quic_packet_app_process(struct sock *sk, struct sk_buff *skb)
+{
+	struct quic_pnspace *space = quic_pnspace(sk, QUIC_CRYPTO_APP);
+	struct quic_crypto *crypto = quic_crypto(sk, QUIC_CRYPTO_APP);
+	struct quic_crypto_cb *cb = QUIC_CRYPTO_CB(skb);
+	struct quic_packet *packet = quic_packet(sk);
+	struct quichdr *hdr = quic_hdr(skb);
+	struct quic_frame frame = {};
+	int err = -EINVAL, taglen;
+
+	WARN_ON(!skb_set_owner_sk_safe(skb, sk));
+
+	quic_packet_reset(packet);
+	if (!hdr->fixed && !quic_inq_grease_quic_bit(quic_inq(sk)))
+		goto err;
+
+	if (!quic_crypto_recv_ready(crypto)) {
+		quic_inq_backlog_tail(sk, skb);
+		return 0;
+	}
+
+	/* Do decryption */
+	if (!cb->number_offset)
+		cb->number_offset = quic_conn_id_active(quic_source(sk))->len + sizeof(*hdr);
+	cb->length = skb->len - cb->number_offset;
+	cb->number_max = quic_pnspace_max_pn_seen(space);
+
+	taglen = quic_packet_taglen(packet);
+	cb->crypto_done = quic_packet_decrypt_done;
+	if (!taglen)
+		cb->resume = 1; /* !taglen means disable_1rtt_encryption */
+	err = quic_crypto_decrypt(crypto, skb);
+	if (err) {
+		if (err == -EINPROGRESS)
+			return err;
+		if (!quic_packet_stateless_reset_process(sk, skb))
+			return 0;
+		packet->errcode = cb->errcode;
+		goto err;
+	}
+	if (hdr->reserved) {
+		packet->errcode = QUIC_TRANSPORT_ERROR_PROTOCOL_VIOLATION;
+		goto err;
+	}
+
+	pr_debug("%s: recvd, num: %llu, len: %d\n", __func__, cb->number, skb->len);
+
+	err = quic_pnspace_check(space, cb->number);
+	if (err) {
+		if (err > 0) { /* dup packet, send ack immediately */
+			packet->ack_eliciting = 1;
+			packet->ack_immediate = 1;
+			goto out;
+		}
+		packet->errcode = QUIC_TRANSPORT_ERROR_INTERNAL;
+		err = -EINVAL;
+		goto err;
+	}
+
+	/* Set path_alt so that the replies will choose the correct path */
+	quic_packet_get_addrs(sk, skb);
+	if (!quic_path_cmp(quic_src(sk), 1, packet->sa))
+		cb->path_alt |= QUIC_PATH_ALT_SRC;
+
+	if (quic_path_cmp(quic_dst(sk), 0, packet->da)) {
+		quic_path_addr_set(quic_dst(sk), packet->da, 1);
+		cb->path_alt |= QUIC_PATH_ALT_DST;
+	}
+
+	frame.data = skb->data + cb->number_offset + cb->number_len;
+	frame.len = cb->length - cb->number_len - taglen;
+	frame.skb = skb;
+	err = quic_frame_process(sk, &frame);
+	if (err)
+		goto err;
+	err = quic_pnspace_mark(space, cb->number);
+	if (err)
+		goto err;
+
+out:
+	return quic_packet_app_process_done(sk, skb);
+
+err:
+	pr_debug("%s: failed, num: %llu, len: %d, err: %d\n",
+		 __func__, cb->number, skb->len, err);
+	quic_outq_transmit_close(sk, frame.type, packet->errcode, 0);
+	kfree_skb(skb);
+	return err;
+}
+
+int quic_packet_process(struct sock *sk, struct sk_buff *skb)
+{
+	if (quic_is_listen(sk))
+		return quic_packet_listen_process(sk, skb);
+
+	if (quic_is_closed(sk)) {
+		kfree_skb(skb);
+		return 0;
+	}
+
+	if (quic_hdr(skb)->form)
+		return quic_packet_handshake_process(sk, skb);
+
+	return quic_packet_app_process(sk, skb);
+}
+
+#define TLS_MT_CLIENT_HELLO	1
+#define TLS_EXT_alpn		16
+
+static int quic_packet_get_alpn(struct quic_data *alpn, u8 *p, u32 len)
+{
+	int err = -EINVAL, found = 0;
+	u64 length, type;
+
+	if (!quic_get_int(&p, &len, &type, 1) || type != TLS_MT_CLIENT_HELLO)
+		return err;
+	if (!quic_get_int(&p, &len, &length, 3) || length < 35 || length > len)
+		return err;
+	len = length - 35;
+	p += 35; /* legacy_version + random + legacy_session_id. */
+
+	if (!quic_get_int(&p, &len, &length, 2) || length > len) /* cipher_suites */
+		return err;
+	len -= length;
+	p += length;
+
+	if (!quic_get_int(&p, &len, &length, 1) || length > len) /* legacy_compression_methods */
+		return err;
+	len -= length;
+	p += length;
+
+	/* TLS Extensions */
+	if (!quic_get_int(&p, &len, &length, 2) || length > len)
+		return err;
+	len = length;
+	while (len > 4) {
+		if (!quic_get_int(&p, &len, &type, 2))
+			break;
+		if (!quic_get_int(&p, &len, &length, 2) || length > len)
+			break;
+		if (type == TLS_EXT_alpn) {
+			len = length;
+			found = 1;
+			break;
+		}
+		p += length;
+		len -= length;
+	}
+	if (!found) {
+		quic_data(alpn, p, 0);
+		return 0;
+	}
+
+	/* ALPNs */
+	if (!quic_get_int(&p, &len, &length, 2) || length > len)
+		return err;
+	quic_data(alpn, p, length);
+	len = length;
+	while (len) {
+		if (!quic_get_int(&p, &len, &length, 1) || length > len) {
+			quic_data(alpn, NULL, 0);
+			return err;
+		}
+		len -= length;
+		p += length;
+	}
+	pr_debug("%s: alpn_len: %d\n", __func__, alpn->len);
+	return alpn->len;
+}
+
+int quic_packet_parse_alpn(struct sk_buff *skb, struct quic_data *alpn)
+{
+	struct quic_crypto_cb *cb = QUIC_CRYPTO_CB(skb);
+	struct quichshdr *hdr = quic_hshdr(skb);
+	int len = skb->len, err = -EINVAL;
+	u8 *p = skb->data, *data, type;
+	struct quic_crypto *crypto;
+	struct quic_packet packet;
+	struct quic_data token;
+	u64 offset, length;
+
+	if (!hdr->form) /* send stateless reset later */
+		return 0;
+	if (quic_packet_get_version_and_connid(&packet, &p, &len))
+		return -EINVAL;
+	if (!quic_packet_compatible_versions(packet.version)) /* send version negotication later */
+		return 0;
+	type = quic_packet_version_get_type(packet.version, hdr->type);
+	if (type != QUIC_PACKET_INITIAL) /* send stateless reset later */
+		return 0;
+	if (quic_packet_get_token(&token, &p, &len))
+		return -EINVAL;
+	if (!quic_get_var(&p, &len, &length) || length > len)
+		return err;
+	cb->length = length;
+	crypto = kzalloc(sizeof(*crypto), GFP_ATOMIC);
+	if (!crypto)
+		return -ENOMEM;
+	data = kmemdup(skb->data, skb->len, GFP_ATOMIC);
+	if (!data) {
+		kfree(crypto);
+		return -ENOMEM;
+	}
+	err = quic_crypto_initial_keys_install(crypto, &packet.dcid, packet.version, 1);
+	if (err)
+		goto out;
+	cb->number_offset = p - skb->data;
+	cb->crypto_done = quic_packet_decrypt_done;
+	err = quic_crypto_decrypt(crypto, skb);
+	if (err) {
+		memcpy(skb->data, data, skb->len);
+		goto out;
+	}
+	cb->resume = 1;
+
+	/* QUIC CRYPTO frame */
+	err = -EINVAL;
+	p += cb->number_len;
+	len = cb->length - cb->number_len - QUIC_TAG_LEN;
+	if (!len-- || *p++ != QUIC_FRAME_CRYPTO)
+		goto out;
+	if (!quic_get_var(&p, &len, &offset) || offset)
+		goto out;
+	if (!quic_get_var(&p, &len, &length) || length > len)
+		goto out;
+
+	/* TLS CLIENT_HELLO message */
+	err = quic_packet_get_alpn(alpn, p, length);
+
+out:
+	quic_crypto_destroy(crypto);
+	kfree(crypto);
+	kfree(data);
+	return err;
+}
+
+/* make these fixed for easy coding */
+#define QUIC_PACKET_NUMBER_LEN	4
+#define QUIC_PACKET_LENGTH_LEN	4
+
+static u8 *quic_packet_pack_frames(struct sock *sk, struct sk_buff *skb, s64 number, u8 level)
+{
+	u32 now = jiffies_to_usecs(jiffies), len = 0, bytes = 0;
+	struct quic_pnspace *space = quic_pnspace(sk, level);
+	struct quic_crypto_cb *cb = QUIC_CRYPTO_CB(skb);
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_frame *frame, *next, *tmp = NULL;
+	u8 *p = skb->data + packet->len, ecn = 0;
+	struct list_head *head;
+
+	cb->number_len = QUIC_PACKET_NUMBER_LEN;
+	cb->number_offset = packet->len;
+	cb->number = number;
+	cb->level = packet->level;
+	cb->path_alt = packet->path_alt;
+
+	p = quic_put_int(p, number, cb->number_len);
+
+	head = &packet->frame_list;
+	list_for_each_entry_safe(frame, next, head, list) {
+		list_del(&frame->list);
+		p = quic_put_data(p, frame->data, frame->len);
+		pr_debug("%s: num: %llu, type: %u, packet_len: %u, frame_len: %u, level: %u\n",
+			 __func__, number, frame->type, skb->len, frame->len, packet->level);
+		if (!quic_frame_retransmittable(frame->type)) {
+			quic_frame_free(frame);
+			continue;
+		}
+		tmp = frame;
+		tmp->last = 0;
+		tmp->first = !len;
+		len += frame->len;
+
+		if (!quic_frame_is_crypto(frame->type))
+			bytes += frame->bytes;
+
+		if (!packet->level && !ecn && packet->ecn_probes < 3) {
+			packet->ecn_probes++;
+			ecn = INET_ECN_ECT_0;
+		}
+		frame->ecn = ecn;
+		cb->ecn = ecn;
+
+		quic_outq_transmitted_tail(sk, frame);
+		if (!frame->sent_time)
+			frame->offset = number;
+		frame->number = number;
+		frame->sent_time = now;
+	}
+
+	packet->snd_count++;
+	if (!len)
+		return p;
+
+	tmp->last = 1;
+	quic_pnspace_inc_inflight(space, len);
+	quic_pnspace_set_last_sent_time(space, now);
+	quic_outq_update_loss_timer(sk, level);
+	quic_cong_on_packet_sent(quic_cong(sk), now, bytes, number);
+	return p;
+}
+
+/* Initial Packet {
+ *   Header Form (1) = 1,
+ *   Fixed Bit (1) = 1,
+ *   Long Packet Type (2) = 0,
+ *   Reserved Bits (2),
+ *   Packet Number Length (2),
+ *   Version (32),
+ *   Destination Connection ID Length (8),
+ *   Destination Connection ID (0..160),
+ *   Source Connection ID Length (8),
+ *   Source Connection ID (0..160),
+ *   Token Length (i),
+ *   Token (..),
+ *   Length (i),
+ *   Packet Number (8..32),
+ *   Packet Payload (8..),
+ * }
+ *
+ * Handshake Packet {
+ *   Header Form (1) = 1,
+ *   Fixed Bit (1) = 1,
+ *   Long Packet Type (2) = 2,
+ *   Reserved Bits (2),
+ *   Packet Number Length (2),
+ *   Version (32),
+ *   Destination Connection ID Length (8),
+ *   Destination Connection ID (0..160),
+ *   Source Connection ID Length (8),
+ *   Source Connection ID (0..160),
+ *   Length (i),
+ *   Packet Number (8..32),
+ *   Packet Payload (8..),
+ * }
+ */
+
+static struct sk_buff *quic_packet_handshake_create(struct sock *sk)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	u8 *p, type, level = packet->level;
+	u32 version, len, hlen, plen = 0;
+	struct quic_conn_id_set *id_set;
+	struct quic_conn_id *active;
+	struct quichshdr *hdr;
+	struct sk_buff *skb;
+	s64 number;
+
+	type = QUIC_PACKET_INITIAL;
+	if (level == QUIC_CRYPTO_HANDSHAKE) {
+		type = QUIC_PACKET_HANDSHAKE;
+	} else if (level == QUIC_CRYPTO_EARLY) {
+		type = QUIC_PACKET_0RTT;
+		level = QUIC_CRYPTO_APP; /* space level */
+	}
+	version = quic_config(sk)->version;
+
+	len = packet->len;
+	if (level == QUIC_CRYPTO_INITIAL && !quic_is_serv(sk) &&
+	    packet->ack_eliciting && len < (QUIC_MIN_UDP_PAYLOAD - QUIC_TAG_LEN)) {
+		len = QUIC_MIN_UDP_PAYLOAD - QUIC_TAG_LEN;
+		plen = len - packet->len;
+	}
+
+	hlen = quic_encap_len(sk) + MAX_HEADER;
+	skb = alloc_skb(hlen + len + packet->taglen[1], GFP_ATOMIC);
+	if (!skb) {
+		quic_outq_retransmit_list(sk, &packet->frame_list);
+		return NULL;
+	}
+	skb->ignore_df = packet->ipfragok;
+	skb_reserve(skb, hlen + len);
+
+	number = quic_pnspace_inc_next_pn(quic_pnspace(sk, level));
+	hdr = skb_push(skb, len);
+	hdr->form = 1;
+	hdr->fixed = !quic_outq_grease_quic_bit(quic_outq(sk));
+	hdr->type = quic_packet_version_put_type(version, type);
+	hdr->reserved = 0;
+	hdr->pnl = QUIC_PACKET_NUMBER_LEN - 1;
+	skb_reset_transport_header(skb);
+
+	p = (u8 *)hdr + 1;
+	p = quic_put_int(p, version, QUIC_VERSION_LEN);
+
+	id_set = quic_dest(sk);
+	active = quic_conn_id_active(id_set);
+	p = quic_put_int(p, active->len, 1);
+	p = quic_put_data(p, active->data, active->len);
+
+	id_set = quic_source(sk);
+	active = quic_conn_id_active(id_set);
+	p = quic_put_int(p, active->len, 1);
+	p = quic_put_data(p, active->data, active->len);
+
+	if (level == QUIC_CRYPTO_INITIAL) {
+		hlen = 0;
+		if (!quic_is_serv(sk))
+			hlen = quic_token(sk)->len;
+		p = quic_put_var(p, hlen);
+		p = quic_put_data(p, quic_token(sk)->data, hlen);
+	}
+
+	packet->len = p + QUIC_PACKET_LENGTH_LEN - skb->data;
+	p = quic_put_int(p, len - packet->len + QUIC_TAG_LEN, QUIC_PACKET_LENGTH_LEN);
+	*(p - 4) |= (QUIC_PACKET_LENGTH_LEN << 5);
+
+	p = quic_packet_pack_frames(sk, skb, number, level);
+	if (plen)
+		memset(p, 0, plen);
+	return skb;
+}
+
+static int quic_packet_number_check(struct sock *sk)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_pnspace *space;
+
+	space = quic_pnspace(sk, (packet->level % QUIC_CRYPTO_EARLY));
+	if (quic_pnspace_next_pn(space) + 1 <= QUIC_PN_MAP_MAX_PN)
+		return 0;
+
+	quic_outq_retransmit_list(sk, &packet->frame_list);
+
+	if (!quic_is_closed(sk)) {
+		struct quic_connection_close *close;
+		u8 frame[10] = {};
+
+		close = (void *)frame;
+		close->errcode = 0;
+		if (quic_inq_event_recv(sk, QUIC_EVENT_CONNECTION_CLOSE, close))
+			return -ENOMEM;
+		quic_set_state(sk, QUIC_SS_CLOSED);
+	}
+	return -EPIPE;
+}
+
+/* 0-RTT Packet {
+ *   Header Form (1) = 1,
+ *   Fixed Bit (1) = 1,
+ *   Long Packet Type (2) = 1,
+ *   Reserved Bits (2),
+ *   Packet Number Length (2),
+ *   Version (32),
+ *   Destination Connection ID Length (8),
+ *   Destination Connection ID (0..160),
+ *   Source Connection ID Length (8),
+ *   Source Connection ID (0..160),
+ *   Length (i),
+ *   Packet Number (8..32),
+ *   Packet Payload (8..),
+ * }
+ */
+
+static struct sk_buff *quic_packet_app_create(struct sock *sk)
+{
+	struct quic_conn_id_set *id_set = quic_dest(sk);
+	struct quic_packet *packet = quic_packet(sk);
+	u8 *p, level = packet->level;
+	struct quic_conn_id *active;
+	struct sk_buff *skb;
+	struct quichdr *hdr;
+	u32 len, hlen;
+	s64 number;
+
+	len = packet->len;
+	hlen = quic_encap_len(sk) + MAX_HEADER;
+	skb = alloc_skb(hlen + len + packet->taglen[0], GFP_ATOMIC);
+	if (!skb) {
+		quic_outq_retransmit_list(sk, &packet->frame_list);
+		return NULL;
+	}
+	skb->ignore_df = packet->ipfragok;
+	skb_reserve(skb, hlen + len);
+
+	number = quic_pnspace_inc_next_pn(quic_pnspace(sk, level));
+	hdr = skb_push(skb, len);
+	hdr->form = 0;
+	hdr->fixed = !quic_outq_grease_quic_bit(quic_outq(sk));
+	hdr->spin = 0;
+	hdr->reserved = 0;
+	hdr->pnl = QUIC_PACKET_NUMBER_LEN - 1;
+	skb_reset_transport_header(skb);
+
+	p = (u8 *)hdr + 1;
+	active = quic_conn_id_active(id_set);
+	p = quic_put_data(p, active->data, active->len);
+	packet->len = active->len + sizeof(struct quichdr);
+
+	quic_packet_pack_frames(sk, skb, number, level);
+	return skb;
+}
+
+void quic_packet_mss_update(struct sock *sk, int mss)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	int max_udp, mss_dgram;
+
+	max_udp = quic_outq_max_udp(quic_outq(sk));
+	if (max_udp && mss > max_udp)
+		mss = max_udp;
+	packet->mss[0] = mss;
+	packet->max_rcv_count = QUIC_PATH_MAX_PMTU / mss + 1;
+	quic_cong_set_mss(quic_cong(sk), packet->mss[0] - packet->taglen[0]);
+
+	mss_dgram = quic_outq_max_dgram(quic_outq(sk));
+	if (!mss_dgram)
+		return;
+	if (mss_dgram > mss)
+		mss_dgram = mss;
+	packet->mss[1] = mss_dgram;
+}
+
+int quic_packet_route(struct sock *sk)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_path_addr *s = quic_src(sk);
+	struct quic_path_addr *d = quic_dst(sk);
+	struct quic_config *c = quic_config(sk);
+	int err, pmtu;
+
+	packet->sa = quic_path_addr(s, packet->path_alt & QUIC_PATH_ALT_SRC);
+	packet->da = quic_path_addr(d, packet->path_alt & QUIC_PATH_ALT_DST);
+	err = quic_flow_route(sk, packet->da, packet->sa);
+	if (err)
+		return err;
+
+	pmtu = min_t(u32, dst_mtu(__sk_dst_get(sk)), QUIC_PATH_MAX_PMTU);
+	quic_packet_mss_update(sk, pmtu - quic_encap_len(sk));
+
+	if (!quic_path_sent_cnt(s) && !quic_path_sent_cnt(d)) {
+		quic_path_pl_reset(d);
+		quic_timer_reset(sk, QUIC_TIMER_PATH, c->plpmtud_probe_interval);
+	}
+	return 0;
+}
+
+int quic_packet_config(struct sock *sk, u8 level, u8 path_alt)
+{
+	struct quic_conn_id_set *id_set = quic_dest(sk);
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_config *c = quic_config(sk);
+	int hlen = sizeof(struct quichdr);
+
+	if (packet->max_snd_count &&
+	    packet->snd_count >= packet->max_snd_count)
+		return -1;
+
+	if (!list_empty(&packet->frame_list))
+		return 0;
+
+	packet->ack_eliciting = 0;
+	packet->ipfragok = 0;
+	packet->padding = 0;
+	hlen += QUIC_PACKET_NUMBER_LEN; /* packet number */
+	hlen += quic_conn_id_active(id_set)->len;
+	if (level) {
+		hlen += 1;
+		id_set = quic_source(sk);
+		hlen += 1 + quic_conn_id_active(id_set)->len;
+		if (level == QUIC_CRYPTO_INITIAL)
+			hlen += quic_var_len(quic_token(sk)->len) + quic_token(sk)->len;
+		hlen += QUIC_VERSION_LEN; /* version */
+		hlen += QUIC_PACKET_LENGTH_LEN; /* length */
+		packet->ipfragok = !!c->plpmtud_probe_interval;
+	}
+	packet->len = hlen;
+	packet->overhead = hlen;
+	packet->level = level;
+	packet->path_alt = path_alt;
+
+	return quic_packet_route(sk) < 0 ? -1 : 0;
+}
+
+static void quic_packet_encrypt_done(struct sk_buff *skb, int err)
+{
+	if (err) {
+		kfree_skb(skb);
+		pr_debug("%s: err: %d\n", __func__, err);
+		return;
+	}
+
+	quic_outq_encrypted_tail(skb->sk, skb);
+}
+
+static int quic_packet_bundle(struct sock *sk, struct sk_buff *skb)
+{
+	struct quic_crypto_cb *head_cb, *cb = QUIC_CRYPTO_CB(skb);
+	struct quic_packet *packet = quic_packet(sk);
+	struct sk_buff *p;
+
+	if (!packet->head) {
+		packet->head = skb;
+		cb->last = skb;
+		goto out;
+	}
+
+	if (packet->head->len + skb->len >= packet->mss[0]) {
+		quic_lower_xmit(sk, packet->head, packet->da, packet->sa);
+		packet->head = skb;
+		cb->last = skb;
+		goto out;
+	}
+	p = packet->head;
+	head_cb = QUIC_CRYPTO_CB(p);
+	if (head_cb->last == p)
+		skb_shinfo(p)->frag_list = skb;
+	else
+		head_cb->last->next = skb;
+	p->data_len += skb->len;
+	p->truesize += skb->truesize;
+	p->len += skb->len;
+	head_cb->last = skb;
+	head_cb->ecn |= cb->ecn;
+
+out:
+	return !cb->level;
+}
+
+int quic_packet_xmit(struct sock *sk, struct sk_buff *skb)
+{
+	struct quic_crypto_cb *cb = QUIC_CRYPTO_CB(skb);
+	struct quic_packet *packet = quic_packet(sk);
+	int err;
+
+	WARN_ON(!skb_set_owner_sk_safe(skb, sk));
+
+	if (!packet->taglen[quic_hdr(skb)->form]) /* !taglen means disable_1rtt_encryption */
+		goto xmit;
+
+	cb->crypto_done = quic_packet_encrypt_done;
+	err = quic_crypto_encrypt(quic_crypto(sk, packet->level), skb);
+	if (err) {
+		if (err != -EINPROGRESS)
+			kfree_skb(skb);
+		return err;
+	}
+
+xmit:
+	if (quic_packet_bundle(sk, skb)) {
+		quic_lower_xmit(sk, packet->head, packet->da, packet->sa);
+		packet->head = NULL;
+	}
+	return 0;
+}
+
+void quic_packet_create(struct sock *sk)
+{
+	struct sk_buff *skb;
+	int err;
+
+	err = quic_packet_number_check(sk);
+	if (err)
+		goto err;
+
+	if (quic_packet(sk)->level)
+		skb = quic_packet_handshake_create(sk);
+	else
+		skb = quic_packet_app_create(sk);
+	if (!skb) {
+		err = -ENOMEM;
+		goto err;
+	}
+
+	err = quic_packet_xmit(sk, skb);
+	if (err && err != -EINPROGRESS)
+		goto err;
+	return;
+err:
+	pr_debug("%s: err: %d\n", __func__, err);
+}
+
+int quic_packet_flush(struct sock *sk)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	u16 count;
+
+	if (!list_empty(&packet->frame_list))
+		quic_packet_create(sk);
+
+	if (packet->head) {
+		quic_lower_xmit(sk, packet->head, packet->da, packet->sa);
+		packet->head = NULL;
+	}
+	count = packet->snd_count;
+
+	packet->max_snd_count = 0;
+	packet->snd_count = 0;
+	return count;
+}
+
+int quic_packet_tail(struct sock *sk, struct quic_frame *frame, u8 dgram)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	u8 taglen;
+
+	if (frame->level != (packet->level % QUIC_CRYPTO_EARLY) ||
+	    frame->path_alt != packet->path_alt || packet->padding)
+		return 0;
+
+	taglen = packet->taglen[!!packet->level];
+	if (packet->len + frame->len > packet->mss[dgram] - taglen) {
+		if (packet->len != packet->overhead)
+			return 0;
+		if (frame->type != QUIC_FRAME_PING)
+			packet->ipfragok = 1;
+	}
+	if (frame->padding)
+		packet->padding = frame->padding;
+
+	if (quic_frame_ack_eliciting(frame->type))
+		packet->ack_eliciting = 1;
+
+	list_move_tail(&frame->list, &packet->frame_list);
+	packet->len += frame->len;
+	return frame->len;
+}
+
+void quic_packet_init(struct sock *sk)
+{
+	struct quic_packet *packet = quic_packet(sk);
+
+	INIT_LIST_HEAD(&packet->frame_list);
+	packet->taglen[0] = QUIC_TAG_LEN;
+	packet->taglen[1] = QUIC_TAG_LEN;
+	packet->mss[0] = QUIC_TAG_LEN;
+	packet->mss[1] = QUIC_TAG_LEN;
+}
diff --git a/net/quic/packet.h b/net/quic/packet.h
new file mode 100644
index 000000000000..4673835cfaf7
--- /dev/null
+++ b/net/quic/packet.h
@@ -0,0 +1,125 @@
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
+struct quic_packet {
+	/* send */
+	struct list_head frame_list;
+	struct sk_buff *head;
+	union quic_addr *da;
+	union quic_addr *sa;
+	u16 max_snd_count; /* the max count of packets to send */
+	u16 snd_count;
+	u16 mss[2];
+
+	u8 ecn_probes;
+	u8 overhead;
+	u8 ipfragok:1;
+	u8 path_alt:2;
+	u8 padding:1;
+	u8 taglen[2];
+
+	/* send or recv */
+	u8 ack_eliciting:1;
+	u8 level;
+	u16 len;
+
+	/* recv */
+	struct quic_conn_id dcid;
+	struct quic_conn_id scid;
+	union quic_addr daddr;
+	union quic_addr saddr;
+	u16 max_rcv_count; /* the count of packets received to trigger an ACK */
+	u16 rcv_count;
+	u32 version;
+	u16 errcode;
+
+	u8 ack_immediate:1;
+	u8 non_probing:1;
+};
+
+#define QUIC_PACKET_INITIAL_V1		0
+#define QUIC_PACKET_0RTT_V1		1
+#define QUIC_PACKET_HANDSHAKE_V1	2
+#define QUIC_PACKET_RETRY_V1		3
+
+#define QUIC_PACKET_INITIAL_V2		1
+#define QUIC_PACKET_0RTT_V2		2
+#define QUIC_PACKET_HANDSHAKE_V2	3
+#define QUIC_PACKET_RETRY_V2		0
+
+#define QUIC_PACKET_INITIAL		QUIC_PACKET_INITIAL_V1
+#define QUIC_PACKET_0RTT		QUIC_PACKET_0RTT_V1
+#define QUIC_PACKET_HANDSHAKE		QUIC_PACKET_HANDSHAKE_V1
+#define QUIC_PACKET_RETRY		QUIC_PACKET_RETRY_V1
+
+#define QUIC_VERSION_LEN		4
+
+struct quic_request_sock;
+
+static inline void quic_packet_set_max_snd_count(struct quic_packet *packet, u16 count)
+{
+	packet->max_snd_count = count;
+}
+
+static inline u32 quic_packet_taglen(struct quic_packet *packet)
+{
+	return packet->taglen[0];
+}
+
+static inline u32 quic_packet_mss(struct quic_packet *packet)
+{
+	return packet->mss[0] - packet->taglen[!!packet->level];
+}
+
+static inline u32 quic_packet_max_payload(struct quic_packet *packet)
+{
+	return packet->mss[0] - packet->overhead - packet->taglen[!!packet->level];
+}
+
+static inline u32 quic_packet_max_payload_dgram(struct quic_packet *packet)
+{
+	return packet->mss[1] - packet->overhead - packet->taglen[!!packet->level];
+}
+
+static inline void quic_packet_set_taglen(struct quic_packet *packet, u8 taglen)
+{
+	packet->taglen[0] = taglen;
+}
+
+static inline void quic_packet_set_ecn_probes(struct quic_packet *packet, u8 probes)
+{
+	packet->ecn_probes = probes;
+}
+
+static inline void quic_packet_reset(struct quic_packet *packet)
+{
+	packet->len = 0;
+	packet->level = 0;
+	packet->errcode = 0;
+	packet->non_probing = 0;
+	packet->ack_eliciting = 0;
+	packet->ack_immediate = 0;
+}
+
+int quic_packet_tail(struct sock *sk, struct quic_frame *frame, u8 dgram);
+int quic_packet_config(struct sock *sk, u8 level, u8 path_alt);
+int quic_packet_process(struct sock *sk, struct sk_buff *skb);
+int quic_packet_xmit(struct sock *sk, struct sk_buff *skb);
+int quic_packet_flush(struct sock *sk);
+int quic_packet_route(struct sock *sk);
+
+void quic_packet_mss_update(struct sock *sk, int mss);
+void quic_packet_create(struct sock *sk);
+void quic_packet_init(struct sock *sk);
+
+int quic_packet_version_change(struct sock *sk, struct quic_conn_id *conn_id, u32 version);
+int quic_packet_select_version(struct sock *sk, u32 *versions, u8 count);
+int quic_packet_parse_alpn(struct sk_buff *skb, struct quic_data *alpn);
+u32 *quic_packet_compatible_versions(u32 version);
diff --git a/net/quic/path.c b/net/quic/path.c
new file mode 100644
index 000000000000..38e389904d47
--- /dev/null
+++ b/net/quic/path.c
@@ -0,0 +1,422 @@
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
+#include <uapi/linux/quic.h>
+#include <net/udp_tunnel.h>
+#include <linux/version.h>
+
+#include "hashtable.h"
+#include "protocol.h"
+#include "connid.h"
+#include "stream.h"
+#include "crypto.h"
+#include "input.h"
+#include "path.h"
+
+static int quic_udp_rcv(struct sock *sk, struct sk_buff *skb)
+{
+	if (skb_linearize(skb))
+		return 0;
+
+	memset(skb->cb, 0, sizeof(skb->cb));
+	QUIC_CRYPTO_CB(skb)->udph_offset = skb->transport_header;
+	skb_set_transport_header(skb, sizeof(struct udphdr));
+	quic_rcv(skb);
+	return 0;
+}
+
+static int quic_udp_err(struct sock *sk, struct sk_buff *skb)
+{
+	int ret;
+
+	skb->transport_header += sizeof(struct udphdr);
+	ret = quic_rcv_err(skb);
+	skb->transport_header -= sizeof(struct udphdr);
+
+	return ret;
+}
+
+static void quic_udp_sock_destroy(struct work_struct *work)
+{
+	struct quic_udp_sock *us = container_of(work, struct quic_udp_sock, work);
+	struct quic_hash_head *head;
+
+	head = quic_udp_sock_head(sock_net(us->sk), ntohs(us->addr.v4.sin_port));
+
+	spin_lock(&head->lock);
+	__hlist_del(&us->node);
+	spin_unlock(&head->lock);
+
+	udp_tunnel_sock_release(us->sk->sk_socket);
+	kfree(us);
+}
+
+static struct quic_udp_sock *quic_udp_sock_create(struct sock *sk, union quic_addr *a)
+{
+	struct udp_tunnel_sock_cfg tuncfg = {NULL};
+	struct udp_port_cfg udp_conf = {0};
+	struct net *net = sock_net(sk);
+	struct quic_hash_head *head;
+	struct quic_udp_sock *us;
+	struct socket *sock;
+
+	us = kzalloc(sizeof(*us), GFP_ATOMIC);
+	if (!us)
+		return NULL;
+
+	quic_udp_conf_init(sk, &udp_conf, a);
+	if (udp_sock_create(net, &udp_conf, &sock)) {
+		pr_debug("%s: failed to create udp sock\n", __func__);
+		kfree(us);
+		return NULL;
+	}
+
+	tuncfg.encap_type = 1;
+	tuncfg.encap_rcv = quic_udp_rcv;
+	tuncfg.encap_err_lookup = quic_udp_err;
+	setup_udp_tunnel_sock(net, sock, &tuncfg);
+
+	refcount_set(&us->refcnt, 1);
+	us->sk = sock->sk;
+	memcpy(&us->addr, a, sizeof(*a));
+
+	head = quic_udp_sock_head(net, ntohs(a->v4.sin_port));
+	spin_lock(&head->lock);
+	hlist_add_head(&us->node, &head->head);
+	spin_unlock(&head->lock);
+	INIT_WORK(&us->work, quic_udp_sock_destroy);
+
+	return us;
+}
+
+static struct quic_udp_sock *quic_udp_sock_get(struct quic_udp_sock *us)
+{
+	if (us)
+		refcount_inc(&us->refcnt);
+	return us;
+}
+
+static void quic_udp_sock_put(struct quic_udp_sock *us)
+{
+	if (us && refcount_dec_and_test(&us->refcnt))
+		queue_work(quic_wq, &us->work);
+}
+
+static struct quic_udp_sock *quic_udp_sock_lookup(struct sock *sk, union quic_addr *a)
+{
+	struct quic_udp_sock *tmp, *us = NULL;
+	struct quic_addr_family_ops *af_ops;
+	struct net *net = sock_net(sk);
+	struct quic_hash_head *head;
+
+	head = quic_udp_sock_head(net, ntohs(a->v4.sin_port));
+	spin_lock(&head->lock);
+	hlist_for_each_entry(tmp, &head->head, node) {
+		if (net != sock_net(tmp->sk))
+			continue;
+
+		af_ops = quic_af_ops_get(tmp->sk->sk_family);
+		if (af_ops->cmp_sk_addr(sk, &tmp->addr, a)) {
+			us = quic_udp_sock_get(tmp);
+			break;
+		}
+	}
+	spin_unlock(&head->lock);
+	if (!us)
+		us = quic_udp_sock_create(sk, a);
+	return us;
+}
+
+int quic_path_set_udp_sock(struct sock *sk, struct quic_path_addr *path, bool alt)
+{
+	struct quic_path_src *src = (struct quic_path_src *)path;
+	struct quic_udp_sock *usk;
+
+	usk = quic_udp_sock_lookup(sk, quic_path_addr(path, alt));
+	if (!usk)
+		return -EINVAL;
+
+	quic_udp_sock_put(src->udp_sk[src->a.active ^ alt]);
+	src->udp_sk[src->a.active ^ alt] = usk;
+	return 0;
+}
+
+static void quic_path_put_bind_port(struct sock *sk, struct quic_bind_port *pp)
+{
+	struct net *net = sock_net(sk);
+	struct quic_hash_head *head;
+
+	if (hlist_unhashed(&pp->node))
+		return;
+
+	head = quic_bind_port_head(net, pp->port);
+	spin_lock(&head->lock);
+	hlist_del_init(&pp->node);
+	spin_unlock(&head->lock);
+}
+
+int quic_path_set_bind_port(struct sock *sk, struct quic_path_addr *path, bool alt)
+{
+	struct quic_bind_port *port = quic_path_port(path, alt);
+	union quic_addr *addr = quic_path_addr(path, alt);
+	struct net *net = sock_net(sk);
+	struct quic_hash_head *head;
+	struct quic_bind_port *pp;
+	int low, high, remaining;
+	unsigned int rover;
+
+	quic_path_put_bind_port(sk, port);
+
+	rover = ntohs(addr->v4.sin_port);
+	if (rover) {
+		head = quic_bind_port_head(net, rover);
+		spin_lock_bh(&head->lock);
+		port->net = net;
+		port->port = rover;
+		hlist_add_head(&port->node, &head->head);
+		spin_unlock_bh(&head->lock);
+		return 0;
+	}
+
+	inet_get_local_port_range(net, &low, &high);
+	remaining = (high - low) + 1;
+	rover = (u32)(((u64)get_random_u32() * remaining) >> 32) + low;
+	do {
+		rover++;
+		if (rover < low || rover > high)
+			rover = low;
+		if (inet_is_local_reserved_port(net, rover))
+			continue;
+		head = quic_bind_port_head(net, rover);
+		spin_lock_bh(&head->lock);
+		hlist_for_each_entry(pp, &head->head, node)
+			if (pp->port == rover && net_eq(net, pp->net))
+				goto next;
+		addr->v4.sin_port = htons(rover);
+		port->net = net;
+		port->port = rover;
+		hlist_add_head(&port->node, &head->head);
+		spin_unlock_bh(&head->lock);
+		return 0;
+next:
+		spin_unlock_bh(&head->lock);
+		cond_resched();
+	} while (--remaining > 0);
+
+	return -EADDRINUSE;
+}
+
+void quic_path_addr_free(struct sock *sk, struct quic_path_addr *path, bool alt)
+{
+	struct quic_path_src *src;
+
+	if (!path->udp_bind)
+		goto out;
+
+	src = (struct quic_path_src *)path;
+	quic_udp_sock_put(src->udp_sk[path->active ^ alt]);
+	src->udp_sk[path->active ^ alt] = NULL;
+	quic_path_put_bind_port(sk, &src->port[path->active ^ alt]);
+out:
+	memset(&path->addr[path->active ^ alt], 0, path->addr_len);
+}
+
+void quic_path_free(struct sock *sk, struct quic_path_addr *path)
+{
+	quic_path_addr_free(sk, path, 0);
+	quic_path_addr_free(sk, path, 1);
+}
+
+enum quic_plpmtud_state {
+	QUIC_PL_DISABLED,
+	QUIC_PL_BASE,
+	QUIC_PL_SEARCH,
+	QUIC_PL_COMPLETE,
+	QUIC_PL_ERROR,
+};
+
+#define QUIC_BASE_PLPMTU        1200
+#define QUIC_MAX_PLPMTU         9000
+#define QUIC_MIN_PLPMTU         512
+
+#define QUIC_MAX_PROBES         3
+
+#define QUIC_PL_BIG_STEP        32
+#define QUIC_PL_MIN_STEP        4
+
+int quic_path_pl_send(struct quic_path_addr *a, s64 number)
+{
+	struct quic_path_dst *d = (struct quic_path_dst *)a;
+	int pathmtu = 0;
+
+	d->pl.number = number;
+	if (d->pl.probe_count < QUIC_MAX_PROBES)
+		goto out;
+
+	d->pl.probe_count = 0;
+	if (d->pl.state == QUIC_PL_BASE) {
+		if (d->pl.probe_size == QUIC_BASE_PLPMTU) { /* BASE_PLPMTU Confirmation Failed */
+			d->pl.state = QUIC_PL_ERROR; /* Base -> Error */
+
+			d->pl.pmtu = QUIC_BASE_PLPMTU;
+			d->pathmtu = d->pl.pmtu;
+			pathmtu = d->pathmtu;
+		}
+	} else if (d->pl.state == QUIC_PL_SEARCH) {
+		if (d->pl.pmtu == d->pl.probe_size) { /* Black Hole Detected */
+			d->pl.state = QUIC_PL_BASE;  /* Search -> Base */
+			d->pl.probe_size = QUIC_BASE_PLPMTU;
+			d->pl.probe_high = 0;
+
+			d->pl.pmtu = QUIC_BASE_PLPMTU;
+			d->pathmtu = d->pl.pmtu;
+			pathmtu = d->pathmtu;
+		} else { /* Normal probe failure. */
+			d->pl.probe_high = d->pl.probe_size;
+			d->pl.probe_size = d->pl.pmtu;
+		}
+	} else if (d->pl.state == QUIC_PL_COMPLETE) {
+		if (d->pl.pmtu == d->pl.probe_size) { /* Black Hole Detected */
+			d->pl.state = QUIC_PL_BASE;  /* Search Complete -> Base */
+			d->pl.probe_size = QUIC_BASE_PLPMTU;
+
+			d->pl.pmtu = QUIC_BASE_PLPMTU;
+			d->pathmtu = d->pl.pmtu;
+			pathmtu = d->pathmtu;
+		}
+	}
+
+out:
+	pr_debug("%s: dst: %p, state: %d, pmtu: %d, size: %d, high: %d\n",
+		 __func__, d, d->pl.state, d->pl.pmtu, d->pl.probe_size, d->pl.probe_high);
+	d->pl.probe_count++;
+	return pathmtu;
+}
+
+int quic_path_pl_recv(struct quic_path_addr *a, bool *raise_timer, bool *complete)
+{
+	struct quic_path_dst *d = (struct quic_path_dst *)a;
+	int pathmtu = 0;
+
+	pr_debug("%s: dst: %p, state: %d, pmtu: %d, size: %d, high: %d\n",
+		 __func__, d, d->pl.state, d->pl.pmtu, d->pl.probe_size, d->pl.probe_high);
+
+	*raise_timer = false;
+	d->pl.number = 0;
+	d->pl.pmtu = d->pl.probe_size;
+	d->pl.probe_count = 0;
+	if (d->pl.state == QUIC_PL_BASE) {
+		d->pl.state = QUIC_PL_SEARCH; /* Base -> Search */
+		d->pl.probe_size += QUIC_PL_BIG_STEP;
+	} else if (d->pl.state == QUIC_PL_ERROR) {
+		d->pl.state = QUIC_PL_SEARCH; /* Error -> Search */
+
+		d->pl.pmtu = d->pl.probe_size;
+		d->pathmtu = d->pl.pmtu;
+		pathmtu = d->pathmtu;
+		d->pl.probe_size += QUIC_PL_BIG_STEP;
+	} else if (d->pl.state == QUIC_PL_SEARCH) {
+		if (!d->pl.probe_high) {
+			if (d->pl.probe_size < QUIC_MAX_PLPMTU) {
+				d->pl.probe_size = min(d->pl.probe_size + QUIC_PL_BIG_STEP,
+						       QUIC_MAX_PLPMTU);
+				*complete = false;
+				return pathmtu;
+			}
+			d->pl.probe_high = QUIC_MAX_PLPMTU;
+		}
+		d->pl.probe_size += QUIC_PL_MIN_STEP;
+		if (d->pl.probe_size >= d->pl.probe_high) {
+			d->pl.probe_high = 0;
+			d->pl.state = QUIC_PL_COMPLETE; /* Search -> Search Complete */
+
+			d->pl.probe_size = d->pl.pmtu;
+			d->pathmtu = d->pl.pmtu;
+			pathmtu = d->pathmtu;
+			*raise_timer = true;
+		}
+	} else if (d->pl.state == QUIC_PL_COMPLETE) {
+		/* Raise probe_size again after 30 * interval in Search Complete */
+		d->pl.state = QUIC_PL_SEARCH; /* Search Complete -> Search */
+		d->pl.probe_size = min(d->pl.probe_size + QUIC_PL_MIN_STEP, QUIC_MAX_PLPMTU);
+	}
+
+	*complete = (d->pl.state == QUIC_PL_COMPLETE);
+	return pathmtu;
+}
+
+int quic_path_pl_toobig(struct quic_path_addr *a, u32 pmtu, bool *reset_timer)
+{
+	struct quic_path_dst *d = (struct quic_path_dst *)a;
+	int pathmtu = 0;
+
+	pr_debug("%s: dst: %p, state: %d, pmtu: %d, size: %d, ptb: %d\n",
+		 __func__, d, d->pl.state, d->pl.pmtu, d->pl.probe_size, pmtu);
+
+	*reset_timer = false;
+	if (pmtu < QUIC_MIN_PLPMTU || pmtu >= d->pl.probe_size)
+		return pathmtu;
+
+	if (d->pl.state == QUIC_PL_BASE) {
+		if (pmtu >= QUIC_MIN_PLPMTU && pmtu < QUIC_BASE_PLPMTU) {
+			d->pl.state = QUIC_PL_ERROR; /* Base -> Error */
+
+			d->pl.pmtu = QUIC_BASE_PLPMTU;
+			d->pathmtu = d->pl.pmtu;
+			pathmtu = d->pathmtu;
+		}
+	} else if (d->pl.state == QUIC_PL_SEARCH) {
+		if (pmtu >= QUIC_BASE_PLPMTU && pmtu < d->pl.pmtu) {
+			d->pl.state = QUIC_PL_BASE;  /* Search -> Base */
+			d->pl.probe_size = QUIC_BASE_PLPMTU;
+			d->pl.probe_count = 0;
+
+			d->pl.probe_high = 0;
+			d->pl.pmtu = QUIC_BASE_PLPMTU;
+			d->pathmtu = d->pl.pmtu;
+			pathmtu = d->pathmtu;
+		} else if (pmtu > d->pl.pmtu && pmtu < d->pl.probe_size) {
+			d->pl.probe_size = pmtu;
+			d->pl.probe_count = 0;
+		}
+	} else if (d->pl.state == QUIC_PL_COMPLETE) {
+		if (pmtu >= QUIC_BASE_PLPMTU && pmtu < d->pl.pmtu) {
+			d->pl.state = QUIC_PL_BASE;  /* Complete -> Base */
+			d->pl.probe_size = QUIC_BASE_PLPMTU;
+			d->pl.probe_count = 0;
+
+			d->pl.probe_high = 0;
+			d->pl.pmtu = QUIC_BASE_PLPMTU;
+			d->pathmtu = d->pl.pmtu;
+			pathmtu = d->pathmtu;
+			*reset_timer = true;
+		}
+	}
+	return pathmtu;
+}
+
+void quic_path_pl_reset(struct quic_path_addr *a)
+{
+	struct quic_path_dst *d = (struct quic_path_dst *)a;
+
+	d->pl.number = 0;
+	d->pl.state = QUIC_PL_BASE;
+	d->pl.pmtu = QUIC_BASE_PLPMTU;
+	d->pl.probe_size = QUIC_BASE_PLPMTU;
+}
+
+bool quic_path_pl_confirm(struct quic_path_addr *a, s64 largest, s64 smallest)
+{
+	struct quic_path_dst *d = (struct quic_path_dst *)a;
+
+	return d->pl.number && d->pl.number >= smallest && d->pl.number <= largest;
+}
diff --git a/net/quic/path.h b/net/quic/path.h
new file mode 100644
index 000000000000..30bf0f8e4be6
--- /dev/null
+++ b/net/quic/path.h
@@ -0,0 +1,143 @@
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
+#define QUIC_PATH_ALT_SRC	0x1
+#define QUIC_PATH_ALT_DST	0x2
+
+#define QUIC_PATH_MAX_PMTU	65536
+
+#define QUIC_MIN_UDP_PAYLOAD	1200
+#define QUIC_MAX_UDP_PAYLOAD	65527
+
+struct quic_bind_port {
+	struct hlist_node node;
+	unsigned short port;
+	struct net *net;
+	u8 retry:1;
+	u8 serv:1;
+};
+
+struct quic_udp_sock {
+	struct work_struct work;
+	struct hlist_node node;
+	union quic_addr addr;
+	refcount_t refcnt;
+	struct sock *sk;
+};
+
+struct quic_path_addr {
+	union quic_addr addr[2];
+	u8 entropy[8];
+	u8 addr_len;
+	u8 sent_cnt;
+
+	u8 udp_bind:1;
+	u8 active:1;
+};
+
+struct quic_path_src {
+	struct quic_path_addr a;
+
+	struct quic_udp_sock *udp_sk[2];
+	struct quic_bind_port port[2];
+};
+
+struct quic_path_dst {
+	struct quic_path_addr a;
+
+	u32 mtu_info;
+	u32 pathmtu;
+	struct {
+		u64 number;
+		u16 pmtu;
+
+		u16 probe_size;
+		u16 probe_high;
+		u8 probe_count;
+		u8 state;
+	} pl; /* plpmtud related */
+};
+
+static inline void quic_path_addr_set(struct quic_path_addr *a, union quic_addr *addr, bool alt)
+{
+	memcpy(&a->addr[a->active ^ alt], addr, a->addr_len);
+}
+
+static inline union quic_addr *quic_path_addr(struct quic_path_addr *a, bool alt)
+{
+	return &a->addr[a->active ^ alt];
+}
+
+static inline union quic_addr *quic_path_udp(struct quic_path_addr *a, bool alt)
+{
+	return &((struct quic_path_src *)a)->udp_sk[a->active ^ alt]->addr;
+}
+
+static inline struct quic_bind_port *quic_path_port(struct quic_path_addr *a, bool alt)
+{
+	return &((struct quic_path_src *)a)->port[a->active ^ alt];
+}
+
+static inline void quic_path_addr_init(struct quic_path_addr *a, u8 addr_len, u8 udp_bind)
+{
+	a->addr_len = addr_len;
+	a->udp_bind = udp_bind;
+}
+
+static inline int quic_path_cmp(struct quic_path_addr *a, bool alt, union quic_addr *addr)
+{
+	return memcmp(addr, quic_path_addr(a, alt), a->addr_len);
+}
+
+static inline u32 quic_path_mtu_info(struct quic_path_addr *a)
+{
+	return ((struct quic_path_dst *)a)->mtu_info;
+}
+
+static inline void quic_path_set_mtu_info(struct quic_path_addr *a, u32 mtu_info)
+{
+	((struct quic_path_dst *)a)->mtu_info = mtu_info;
+}
+
+static inline u8 quic_path_sent_cnt(struct quic_path_addr *a)
+{
+	return a->sent_cnt;
+}
+
+static inline void quic_path_set_sent_cnt(struct quic_path_addr *a, u8 cnt)
+{
+	a->sent_cnt = cnt;
+}
+
+static inline void quic_path_swap_active(struct quic_path_addr *a)
+{
+	a->active = !a->active;
+}
+
+static inline u8 *quic_path_entropy(struct quic_path_addr *a)
+{
+	return a->entropy;
+}
+
+static inline u8 quic_path_udp_bind(struct quic_path_addr *a)
+{
+	return a->udp_bind;
+}
+
+int quic_path_set_bind_port(struct sock *sk, struct quic_path_addr *a, bool alt);
+int quic_path_set_udp_sock(struct sock *sk, struct quic_path_addr *a, bool alt);
+void quic_path_addr_free(struct sock *sk, struct quic_path_addr *path, bool alt);
+void quic_path_free(struct sock *sk, struct quic_path_addr *a);
+
+int quic_path_pl_recv(struct quic_path_addr *a, bool *raise_timer, bool *complete);
+int quic_path_pl_toobig(struct quic_path_addr *a, u32 pmtu, bool *reset_timer);
+bool quic_path_pl_confirm(struct quic_path_addr *a, s64 largest, s64 smallest);
+int quic_path_pl_send(struct quic_path_addr *a, s64 number);
+void quic_path_pl_reset(struct quic_path_addr *a);
diff --git a/net/quic/pnspace.c b/net/quic/pnspace.c
new file mode 100644
index 000000000000..7551e721a3d0
--- /dev/null
+++ b/net/quic/pnspace.c
@@ -0,0 +1,184 @@
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
+#include <linux/bitmap.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+
+#include "pnspace.h"
+
+static int quic_pnspace_grow(struct quic_pnspace *space, u16 size)
+{
+	unsigned long *new;
+	unsigned long inc;
+	u16 len, offset;
+
+	if (size > QUIC_PN_MAP_SIZE)
+		return 0;
+
+	inc = ALIGN((size - space->pn_map_len), BITS_PER_LONG) + QUIC_PN_MAP_INCREMENT;
+	len = min_t(u16, space->pn_map_len + inc, QUIC_PN_MAP_SIZE);
+
+	new = kzalloc(len >> 3, GFP_ATOMIC);
+	if (!new)
+		return 0;
+
+	offset = space->max_pn_seen + 1 - space->base_pn;
+	bitmap_copy(new, space->pn_map, offset);
+	kfree(space->pn_map);
+	space->pn_map = new;
+	space->pn_map_len = len;
+
+	return 1;
+}
+
+int quic_pnspace_init(struct quic_pnspace *space)
+{
+	if (!space->pn_map) {
+		space->pn_map = kzalloc(QUIC_PN_MAP_INITIAL >> 3, GFP_KERNEL);
+		if (!space->pn_map)
+			return -ENOMEM;
+		space->pn_map_len = QUIC_PN_MAP_INITIAL;
+	} else {
+		bitmap_zero(space->pn_map, space->pn_map_len);
+	}
+
+	/* set it to a large value so that the 1st packet can update it */
+	space->next_pn = QUIC_PNSPACE_NEXT_PN;
+	space->base_pn = -1;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(quic_pnspace_init);
+
+void quic_pnspace_free(struct quic_pnspace *space)
+{
+	space->pn_map_len = 0;
+	kfree(space->pn_map);
+}
+EXPORT_SYMBOL_GPL(quic_pnspace_free);
+
+int quic_pnspace_check(struct quic_pnspace *space, s64 pn)
+{
+	if (space->base_pn == -1) {
+		quic_pnspace_set_base_pn(space, pn + 1);
+		return 0;
+	}
+
+	if (pn < space->min_pn_seen || pn >= space->base_pn + QUIC_PN_MAP_SIZE)
+		return -1;
+
+	if (pn < space->base_pn || (pn - space->base_pn < space->pn_map_len &&
+				    test_bit(pn - space->base_pn, space->pn_map)))
+		return 1;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(quic_pnspace_check);
+
+/* move base_pn next to pn */
+static void quic_pnspace_move(struct quic_pnspace *space, s64 pn)
+{
+	u16 offset;
+
+	offset = pn + 1 - space->base_pn;
+	offset = find_next_zero_bit(space->pn_map, space->pn_map_len, offset);
+	space->base_pn += offset;
+	bitmap_shift_right(space->pn_map, space->pn_map, offset, space->pn_map_len);
+}
+
+int quic_pnspace_mark(struct quic_pnspace *space, s64 pn)
+{
+	s64 mid_pn_seen;
+	u16 gap;
+
+	if (pn < space->base_pn)
+		return 0;
+
+	gap = pn - space->base_pn;
+	if (gap >= space->pn_map_len && !quic_pnspace_grow(space, gap + 1))
+		return -ENOMEM;
+
+	if (space->max_pn_seen < pn) {
+		space->max_pn_seen = pn;
+		space->max_pn_time = jiffies_to_usecs(jiffies);
+	}
+
+	if (space->base_pn == pn) {
+		if (quic_pnspace_has_gap(space))
+			quic_pnspace_move(space, pn);
+		else /* fast path */
+			space->base_pn++;
+	} else {
+		set_bit(gap, space->pn_map);
+	}
+
+	/* move forward min and mid_pn_seen only when receiving max_pn */
+	if (space->max_pn_seen != pn)
+		return 0;
+
+	mid_pn_seen = min_t(s64, space->mid_pn_seen, space->base_pn);
+	if (space->max_pn_time < space->mid_pn_time + space->max_time_limit &&
+	    space->max_pn_seen <= mid_pn_seen + QUIC_PN_MAP_LIMIT)
+		return 0;
+
+	if (space->mid_pn_seen + 1 > space->base_pn)
+		quic_pnspace_move(space, space->mid_pn_seen);
+
+	space->min_pn_seen = space->mid_pn_seen;
+	space->mid_pn_seen = space->max_pn_seen;
+	space->mid_pn_time = space->max_pn_time;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(quic_pnspace_mark);
+
+static int quic_pnspace_next_gap_ack(const struct quic_pnspace *space,
+				     s64 *iter, u16 *start, u16 *end)
+{
+	u16 start_ = 0, end_ = 0, offset = *iter - space->base_pn;
+
+	start_ = find_next_zero_bit(space->pn_map, space->pn_map_len, offset);
+	if (space->max_pn_seen <= space->base_pn + start_)
+		return 0;
+
+	end_ = find_next_bit(space->pn_map, space->pn_map_len, start_);
+	if (space->max_pn_seen <= space->base_pn + end_ - 1)
+		return 0;
+
+	*start = start_ + 1;
+	*end = end_;
+	*iter = space->base_pn + *end;
+	return 1;
+}
+
+u16 quic_pnspace_num_gabs(struct quic_pnspace *space)
+{
+	struct quic_gap_ack_block *gabs = space->gabs;
+	u16 start, end, ngaps = 0;
+	s64 iter;
+
+	if (!quic_pnspace_has_gap(space))
+		return 0;
+
+	iter = space->base_pn;
+	if (!iter) /* use min_pn_seen if base_pn hasn't moved */
+		iter = space->min_pn_seen + 1;
+
+	while (quic_pnspace_next_gap_ack(space, &iter, &start, &end)) {
+		gabs[ngaps].start = start;
+		gabs[ngaps].end = end;
+		ngaps++;
+		if (ngaps >= QUIC_PN_MAX_GABS)
+			break;
+	}
+	return ngaps;
+}
+EXPORT_SYMBOL_GPL(quic_pnspace_num_gabs);
diff --git a/net/quic/pnspace.h b/net/quic/pnspace.h
new file mode 100644
index 000000000000..706c53793339
--- /dev/null
+++ b/net/quic/pnspace.h
@@ -0,0 +1,209 @@
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
+#define QUIC_PN_MAX_GABS	256
+#define QUIC_PN_MAP_MAX_PN	((1ULL << 62) - 1)
+
+#define QUIC_PN_MAP_INITIAL	BITS_PER_LONG
+#define QUIC_PN_MAP_INCREMENT	QUIC_PN_MAP_INITIAL
+#define QUIC_PN_MAP_SIZE	4096
+#define QUIC_PN_MAP_LIMIT	(QUIC_PN_MAP_SIZE * 3 / 4)
+
+#define QUIC_PNSPACE_MAX	(QUIC_CRYPTO_MAX - 1)
+#define QUIC_PNSPACE_NEXT_PN	0
+
+struct quic_gap_ack_block {
+	u16 start;
+	u16 end;
+};
+
+/* pn_map:
+ * min_pn_seen -->  |----------------------|---------------------|...
+ *        base_pn --^        mid_pn_seen --^       max_pn_seen --^
+ *
+ * move forward:
+ *   min_pn_seen = mid_pn_seen;
+ *   base_pn = first_zero_bit from mid_pn_seen + 1;
+ *   mid_pn_seen = max_pn_seen;
+ *   mid_pn_time = now;
+ * when:
+ *   'max_pn_time - mid_pn_time >= max_time_limit' or
+ *   'max_pn_seen - mid_pn_seen > QUIC_PN_MAP_LIMIT'
+ * gaps search:
+ *    from base_pn - 1 to max_pn_seen
+ */
+struct quic_pnspace {
+	struct quic_gap_ack_block gabs[QUIC_PN_MAX_GABS];
+	unsigned long *pn_map;
+	u64 ecn_count[2][3]; /* ECT_1, ECT_0, CE count of local and peer */
+	u16 pn_map_len;
+
+	u32 max_time_limit;
+	s64 min_pn_seen;
+	s64 mid_pn_seen;
+	s64 max_pn_seen;
+	u32 mid_pn_time;
+	u32 max_pn_time;
+	s64 base_pn;
+
+	s64 max_pn_acked_seen;
+	u32 max_pn_acked_time;
+	u32 last_sent_time;
+	u32 loss_time;
+	u32 inflight;
+	s64 next_pn; /* next packet number to send */
+};
+
+static inline struct quic_gap_ack_block *quic_pnspace_gabs(struct quic_pnspace *space)
+{
+	return space->gabs;
+}
+
+static inline void quic_pnspace_set_max_time_limit(struct quic_pnspace *space, u32 max_time_limit)
+{
+	space->max_time_limit = max_time_limit;
+}
+
+static inline s64 quic_pnspace_min_pn_seen(const struct quic_pnspace *space)
+{
+	return space->min_pn_seen;
+}
+
+static inline s64 quic_pnspace_max_pn_seen(const struct quic_pnspace *space)
+{
+	return space->max_pn_seen;
+}
+
+static inline void quic_pnspace_set_max_pn_acked_seen(struct quic_pnspace *space,
+						      s64 max_pn_acked_seen)
+{
+	if (space->max_pn_acked_seen >= max_pn_acked_seen)
+		return;
+	space->max_pn_acked_seen = max_pn_acked_seen;
+	space->max_pn_acked_time = jiffies_to_usecs(jiffies);
+}
+
+static inline s64 quic_pnspace_max_pn_acked_seen(const struct quic_pnspace *space)
+{
+	return space->max_pn_acked_seen;
+}
+
+static inline s32 quic_pnspace_max_pn_acked_time(const struct quic_pnspace *space)
+{
+	return space->max_pn_acked_time;
+}
+
+static inline void quic_pnspace_set_loss_time(struct quic_pnspace *space, u32 loss_time)
+{
+	space->loss_time = loss_time;
+}
+
+static inline u32 quic_pnspace_loss_time(const struct quic_pnspace *space)
+{
+	return space->loss_time;
+}
+
+static inline void quic_pnspace_set_last_sent_time(struct quic_pnspace *space, u32 last_sent_time)
+{
+	space->last_sent_time = last_sent_time;
+}
+
+static inline u32 quic_pnspace_last_sent_time(const struct quic_pnspace *space)
+{
+	return space->last_sent_time;
+}
+
+static inline s64 quic_pnspace_next_pn(const struct quic_pnspace *space)
+{
+	return space->next_pn;
+}
+
+static inline s64 quic_pnspace_inc_next_pn(struct quic_pnspace *space)
+{
+	return space->next_pn++;
+}
+
+static inline u32 quic_pnspace_inflight(struct quic_pnspace *space)
+{
+	return space->inflight;
+}
+
+static inline void quic_pnspace_inc_inflight(struct quic_pnspace *space, u16 bytes)
+{
+	space->inflight += bytes;
+}
+
+static inline void quic_pnspace_dec_inflight(struct quic_pnspace *space, u16 bytes)
+{
+	space->inflight -= bytes;
+}
+
+static inline s64 quic_pnspace_base_pn(const struct quic_pnspace *space)
+{
+	return space->base_pn;
+}
+
+static inline void quic_pnspace_set_base_pn(struct quic_pnspace *space, s64 pn)
+{
+	space->base_pn = pn;
+	space->max_pn_seen = space->base_pn - 1;
+	space->mid_pn_seen = space->max_pn_seen;
+	space->min_pn_seen = space->max_pn_seen;
+
+	space->max_pn_time = jiffies_to_usecs(jiffies);
+	space->mid_pn_time = space->max_pn_time;
+}
+
+static inline u32 quic_pnspace_max_pn_time(const struct quic_pnspace *space)
+{
+	return space->max_pn_time;
+}
+
+static inline bool quic_pnspace_has_gap(const struct quic_pnspace *space)
+{
+	return space->base_pn != space->max_pn_seen + 1;
+}
+
+static inline void quic_pnspace_inc_ecn_count(struct quic_pnspace *space, u8 ecn)
+{
+	if (!ecn)
+		return;
+	space->ecn_count[0][ecn - 1]++;
+}
+
+static inline int quic_pnspace_set_ecn_count(struct quic_pnspace *space, u64 *ecn_count)
+{
+	if (space->ecn_count[1][0] < ecn_count[0])
+		space->ecn_count[1][0] = ecn_count[0];
+	if (space->ecn_count[1][1] < ecn_count[1])
+		space->ecn_count[1][1] = ecn_count[1];
+	if (space->ecn_count[1][2] < ecn_count[2]) {
+		space->ecn_count[1][2] = ecn_count[2];
+		return 1;
+	}
+	return 0;
+}
+
+static inline u64 *quic_pnspace_ecn_count(struct quic_pnspace *space)
+{
+	return space->ecn_count[0];
+}
+
+static inline bool quic_pnspace_has_ecn_count(struct quic_pnspace *space)
+{
+	return space->ecn_count[0][0] || space->ecn_count[0][1] || space->ecn_count[0][2];
+}
+
+int quic_pnspace_check(struct quic_pnspace *space, s64 pn);
+int quic_pnspace_mark(struct quic_pnspace *space, s64 pn);
+u16 quic_pnspace_num_gabs(struct quic_pnspace *space);
+
+void quic_pnspace_free(struct quic_pnspace *space);
+int quic_pnspace_init(struct quic_pnspace *space);
diff --git a/net/quic/protocol.c b/net/quic/protocol.c
new file mode 100644
index 000000000000..fcff930ccd10
--- /dev/null
+++ b/net/quic/protocol.c
@@ -0,0 +1,950 @@
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
+#include <net/inet_common.h>
+#include <linux/seq_file.h>
+#include <linux/version.h>
+#include <linux/proc_fs.h>
+#include <net/protocol.h>
+#include <linux/icmp.h>
+#include <net/tls.h>
+#include <net/rps.h>
+
+#include "socket.h"
+
+struct quic_hash_table quic_hash_tables[QUIC_HT_MAX_TABLES] __read_mostly;
+struct kmem_cache *quic_frame_cachep __read_mostly;
+struct workqueue_struct *quic_wq __read_mostly;
+struct percpu_counter quic_sockets_allocated;
+u8 quic_random_data[32] __read_mostly;
+
+long sysctl_quic_mem[3];
+int sysctl_quic_rmem[3];
+int sysctl_quic_wmem[3];
+
+static int quic_v6_flow_route(struct sock *sk, union quic_addr *da, union quic_addr *sa)
+{
+	struct dst_entry *dst;
+	struct flowi6 *fl6;
+	struct flowi _fl;
+
+	if (__sk_dst_check(sk, inet6_sk(sk)->dst_cookie))
+		return 1;
+
+	fl6 = &_fl.u.ip6;
+	memset(&_fl, 0x0, sizeof(_fl));
+	fl6->saddr = sa->v6.sin6_addr;
+	fl6->fl6_sport = sa->v6.sin6_port;
+	fl6->daddr = da->v6.sin6_addr;
+	fl6->fl6_dport = da->v6.sin6_port;
+
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, NULL);
+	if (IS_ERR(dst))
+		return PTR_ERR(dst);
+
+	if (!sa->v6.sin6_family) {
+		sa->v6.sin6_family = AF_INET6;
+		sa->v6.sin6_addr = fl6->saddr;
+	}
+	ip6_dst_store(sk, dst, NULL, NULL);
+	return 0;
+}
+
+static int quic_v4_flow_route(struct sock *sk, union quic_addr *da, union quic_addr *sa)
+{
+	struct flowi4 *fl4;
+	struct rtable *rt;
+	struct flowi _fl;
+
+	if (__sk_dst_check(sk, 0))
+		return 1;
+
+	fl4 = &_fl.u.ip4;
+	memset(&_fl, 0x00, sizeof(_fl));
+	fl4->saddr = sa->v4.sin_addr.s_addr;
+	fl4->fl4_sport = sa->v4.sin_port;
+	fl4->daddr = da->v4.sin_addr.s_addr;
+	fl4->fl4_dport = da->v4.sin_port;
+
+	rt = ip_route_output_key(sock_net(sk), fl4);
+	if (IS_ERR(rt))
+		return PTR_ERR(rt);
+
+	if (!sa->v4.sin_family) {
+		sa->v4.sin_family = AF_INET;
+		sa->v4.sin_addr.s_addr = fl4->saddr;
+	}
+	sk_setup_caps(sk, &rt->dst);
+	return 0;
+}
+
+static void quic_v4_lower_xmit(struct sock *sk, struct sk_buff *skb, union quic_addr *da,
+			       union quic_addr *sa)
+{
+	struct quic_crypto_cb *cb = QUIC_CRYPTO_CB(skb);
+	u8 tos = (inet_sk(sk)->tos | cb->ecn);
+	struct dst_entry *dst;
+	__be16 df = 0;
+
+	pr_debug("%s: skb: %p, len: %d, num: %llu, %pI4:%d -> %pI4:%d\n", __func__,
+		 skb, skb->len, cb->number, &sa->v4.sin_addr.s_addr, ntohs(sa->v4.sin_port),
+		 &da->v4.sin_addr.s_addr, ntohs(da->v4.sin_port));
+
+	dst = sk_dst_get(sk);
+	if (!dst) {
+		kfree_skb(skb);
+		return;
+	}
+	if (ip_dont_fragment(sk, dst) && !skb->ignore_df)
+		df = htons(IP_DF);
+
+	udp_tunnel_xmit_skb((struct rtable *)dst, sk, skb, sa->v4.sin_addr.s_addr,
+			    da->v4.sin_addr.s_addr, tos, ip4_dst_hoplimit(dst), df,
+			    sa->v4.sin_port, da->v4.sin_port, false, false);
+}
+
+static void quic_v6_lower_xmit(struct sock *sk, struct sk_buff *skb, union quic_addr *da,
+			       union quic_addr *sa)
+{
+	struct quic_crypto_cb *cb = QUIC_CRYPTO_CB(skb);
+	u8 tc = (inet6_sk(sk)->tclass | cb->ecn);
+	struct dst_entry *dst = sk_dst_get(sk);
+
+	if (!dst) {
+		kfree_skb(skb);
+		return;
+	}
+	pr_debug("%s: skb: %p, len: %d, num: %llu, %pI6c:%d -> %pI6c:%d\n", __func__,
+		 skb, skb->len, cb->number, &sa->v6.sin6_addr, ntohs(sa->v6.sin6_port),
+		 &da->v6.sin6_addr, ntohs(da->v6.sin6_port));
+
+	udp_tunnel6_xmit_skb(dst, sk, skb, NULL, &sa->v6.sin6_addr, &da->v6.sin6_addr, tc,
+			     ip6_dst_hoplimit(dst), 0, sa->v6.sin6_port, da->v6.sin6_port, false);
+}
+
+static void quic_v4_udp_conf_init(struct sock *sk, struct udp_port_cfg *conf, union quic_addr *a)
+{
+	conf->family = AF_INET;
+	conf->local_ip.s_addr = a->v4.sin_addr.s_addr;
+	conf->local_udp_port = a->v4.sin_port;
+	conf->use_udp6_rx_checksums = true;
+}
+
+static void quic_v6_udp_conf_init(struct sock *sk, struct udp_port_cfg *conf, union quic_addr *a)
+{
+	conf->family = AF_INET6;
+	conf->local_ip6 = a->v6.sin6_addr;
+	conf->local_udp_port = a->v6.sin6_port;
+	conf->use_udp6_rx_checksums = true;
+	conf->ipv6_v6only = ipv6_only_sock(sk);
+}
+
+static void quic_v4_get_msg_addr(union quic_addr *a, struct sk_buff *skb, bool src)
+{
+	struct udphdr *uh = (struct udphdr *)(skb->head + QUIC_CRYPTO_CB(skb)->udph_offset);
+	struct sockaddr_in *sa = &a->v4;
+
+	a->v4.sin_family = AF_INET;
+	if (src) {
+		sa->sin_port = uh->source;
+		sa->sin_addr.s_addr = ip_hdr(skb)->saddr;
+		memset(sa->sin_zero, 0, sizeof(sa->sin_zero));
+		return;
+	}
+
+	sa->sin_port = uh->dest;
+	sa->sin_addr.s_addr = ip_hdr(skb)->daddr;
+	memset(sa->sin_zero, 0, sizeof(sa->sin_zero));
+}
+
+static void quic_v6_get_msg_addr(union quic_addr *a, struct sk_buff *skb, bool src)
+{
+	struct udphdr *uh = (struct udphdr *)(skb->head + QUIC_CRYPTO_CB(skb)->udph_offset);
+	struct sockaddr_in6 *sa = &a->v6;
+
+	a->v6.sin6_family = AF_INET6;
+	a->v6.sin6_flowinfo = 0;
+	a->v6.sin6_scope_id = 0;
+	if (src) {
+		sa->sin6_port = uh->source;
+		sa->sin6_addr = ipv6_hdr(skb)->saddr;
+		return;
+	}
+
+	sa->sin6_port = uh->dest;
+	sa->sin6_addr = ipv6_hdr(skb)->daddr;
+}
+
+static int quic_v4_get_sk_addr(struct socket *sock, struct sockaddr *uaddr, int peer)
+{
+	return inet_getname(sock, uaddr, peer);
+}
+
+static int quic_v6_get_sk_addr(struct socket *sock, struct sockaddr *uaddr, int peer)
+{
+	return inet6_getname(sock, uaddr, peer);
+}
+
+static void quic_v4_set_sk_addr(struct sock *sk, union quic_addr *a, bool src)
+{
+	if (src) {
+		inet_sk(sk)->inet_sport = a->v4.sin_port;
+		inet_sk(sk)->inet_saddr = a->v4.sin_addr.s_addr;
+	} else {
+		inet_sk(sk)->inet_dport = a->v4.sin_port;
+		inet_sk(sk)->inet_daddr = a->v4.sin_addr.s_addr;
+	}
+}
+
+static void quic_v6_set_sk_addr(struct sock *sk, union quic_addr *a, bool src)
+{
+	if (src) {
+		inet_sk(sk)->inet_sport = a->v6.sin6_port;
+		sk->sk_v6_rcv_saddr = a->v6.sin6_addr;
+	} else {
+		inet_sk(sk)->inet_dport = a->v6.sin6_port;
+		sk->sk_v6_daddr = a->v6.sin6_addr;
+	}
+}
+
+static int quic_v4_get_mtu_info(struct sk_buff *skb, u32 *info)
+{
+	struct icmphdr *hdr;
+
+	hdr = (struct icmphdr *)(skb_network_header(skb) - sizeof(struct icmphdr));
+	if (hdr->type == ICMP_DEST_UNREACH && hdr->code == ICMP_FRAG_NEEDED) {
+		*info = ntohs(hdr->un.frag.mtu);
+		return 0;
+	}
+
+	/* can't be handled without outer iphdr known, leave it to udp_err */
+	return 1;
+}
+
+static int quic_v6_get_mtu_info(struct sk_buff *skb, u32 *info)
+{
+	struct icmp6hdr *hdr;
+
+	hdr = (struct icmp6hdr *)(skb_network_header(skb) - sizeof(struct icmp6hdr));
+	if (hdr->icmp6_type == ICMPV6_PKT_TOOBIG) {
+		*info = ntohl(hdr->icmp6_mtu);
+		return 0;
+	}
+
+	/* can't be handled without outer ip6hdr known, leave it to udpv6_err */
+	return 1;
+}
+
+static int quic_v4_get_msg_ecn(struct sk_buff *skb)
+{
+	return (ip_hdr(skb)->tos & INET_ECN_MASK);
+}
+
+static int quic_v6_get_msg_ecn(struct sk_buff *skb)
+{
+	return (ipv6_get_dsfield(ipv6_hdr(skb)) & INET_ECN_MASK);
+}
+
+static void quic_v4_set_sk_ecn(struct sock *sk, u8 ecn)
+{
+	inet_sk(sk)->tos = ((inet_sk(sk)->tos & ~INET_ECN_MASK) | ecn);
+}
+
+static void quic_v6_set_sk_ecn(struct sock *sk, u8 ecn)
+{
+	inet6_sk(sk)->tclass = ((inet6_sk(sk)->tclass & ~INET_ECN_MASK) | ecn);
+}
+
+static void quic_v4_get_pref_addr(union quic_addr *addr, u8 **pp, u32 *plen)
+{
+	u8 *p = *pp;
+
+	memcpy(&addr->v4.sin_addr, p, 4);
+	p += 4;
+	memcpy(&addr->v4.sin_port, p, 2);
+	p += 2;
+	p += 16;
+	p += 2;
+	*pp = p;
+	*plen -= 4 + 2 + 16 + 2;
+}
+
+static void quic_v6_get_pref_addr(union quic_addr *addr, u8 **pp, u32 *plen)
+{
+	u8 *p = *pp;
+
+	p += 4;
+	p += 2;
+	memcpy(&addr->v6.sin6_addr, p, 16);
+	p += 16;
+	memcpy(&addr->v6.sin6_port, p, 2);
+	p += 2;
+	*pp = p;
+	*plen -= 4 + 2 + 16 + 2;
+}
+
+static void quic_v4_set_pref_addr(u8 *p, union quic_addr *addr)
+{
+	memcpy(p, &addr->v4.sin_addr, 4);
+	p += 4;
+	memcpy(p, &addr->v4.sin_port, 2);
+	p += 2;
+	memset(p, 0, 16);
+	p += 16;
+	memset(p, 0, 2);
+	p += 2;
+}
+
+static void quic_v6_set_pref_addr(u8 *p, union quic_addr *addr)
+{
+	memset(p, 0, 4);
+	p += 4;
+	memset(p, 0, 2);
+	p += 2;
+	memcpy(p, &addr->v6.sin6_addr, 16);
+	p += 16;
+	memcpy(p, &addr->v6.sin6_port, 2);
+	p += 2;
+}
+
+static void quic_v4_seq_dump_addr(struct seq_file *seq, union quic_addr *addr)
+{
+	seq_printf(seq, "%pI4:%d\t", &addr->v4.sin_addr.s_addr, ntohs(addr->v4.sin_port));
+}
+
+static void quic_v6_seq_dump_addr(struct seq_file *seq, union quic_addr *addr)
+{
+	seq_printf(seq, "%pI6c:%d\t", &addr->v6.sin6_addr, ntohs(addr->v4.sin_port));
+}
+
+static bool quic_v4_cmp_sk_addr(struct sock *sk, union quic_addr *a, union quic_addr *addr)
+{
+	if (a->v4.sin_port != addr->v4.sin_port)
+		return false;
+	if (addr->v4.sin_family != AF_INET)
+		return false;
+	if (a->v4.sin_addr.s_addr == htonl(INADDR_ANY))
+		return true;
+	return a->v4.sin_addr.s_addr == addr->v4.sin_addr.s_addr;
+}
+
+static bool quic_v6_cmp_sk_addr(struct sock *sk, union quic_addr *a, union quic_addr *addr)
+{
+	int type = ipv6_addr_type(&a->v6.sin6_addr);
+
+	if (a->v4.sin_port != addr->v4.sin_port)
+		return false;
+	if (type == IPV6_ADDR_ANY) {
+		if (addr->v4.sin_family == AF_INET6)
+			return true;
+		return !ipv6_only_sock(sk);
+	}
+	if (type == IPV6_ADDR_MAPPED) {
+		if (ipv6_only_sock(sk) || addr->v4.sin_family == AF_INET6)
+			return false;
+		return a->v4.sin_addr.s_addr == addr->v6.sin6_addr.s6_addr32[3];
+	}
+	return !memcmp(&a->v6.sin6_addr, &addr->v6.sin6_addr, 16);
+}
+
+static struct quic_addr_family_ops quic_af_inet = {
+	.sa_family		= AF_INET,
+	.addr_len		= sizeof(struct sockaddr_in),
+	.iph_len		= sizeof(struct iphdr),
+	.udp_conf_init		= quic_v4_udp_conf_init,
+	.flow_route		= quic_v4_flow_route,
+	.lower_xmit		= quic_v4_lower_xmit,
+	.get_pref_addr		= quic_v4_get_pref_addr,
+	.set_pref_addr		= quic_v4_set_pref_addr,
+	.seq_dump_addr		= quic_v4_seq_dump_addr,
+	.get_msg_addr		= quic_v4_get_msg_addr,
+	.cmp_sk_addr		= quic_v4_cmp_sk_addr,
+	.set_sk_addr		= quic_v4_set_sk_addr,
+	.get_sk_addr		= quic_v4_get_sk_addr,
+	.get_mtu_info		= quic_v4_get_mtu_info,
+	.set_sk_ecn		= quic_v4_set_sk_ecn,
+	.get_msg_ecn		= quic_v4_get_msg_ecn,
+	.setsockopt		= ip_setsockopt,
+	.getsockopt		= ip_getsockopt,
+};
+
+static struct quic_addr_family_ops quic_af_inet6 = {
+	.sa_family		= AF_INET6,
+	.addr_len		= sizeof(struct sockaddr_in6),
+	.iph_len		= sizeof(struct ipv6hdr),
+	.udp_conf_init		= quic_v6_udp_conf_init,
+	.flow_route		= quic_v6_flow_route,
+	.lower_xmit		= quic_v6_lower_xmit,
+	.get_pref_addr		= quic_v6_get_pref_addr,
+	.set_pref_addr		= quic_v6_set_pref_addr,
+	.seq_dump_addr		= quic_v6_seq_dump_addr,
+	.cmp_sk_addr		= quic_v6_cmp_sk_addr,
+	.get_msg_addr		= quic_v6_get_msg_addr,
+	.set_sk_addr		= quic_v6_set_sk_addr,
+	.get_sk_addr		= quic_v6_get_sk_addr,
+	.get_mtu_info		= quic_v6_get_mtu_info,
+	.set_sk_ecn		= quic_v6_set_sk_ecn,
+	.get_msg_ecn		= quic_v6_get_msg_ecn,
+	.setsockopt		= ipv6_setsockopt,
+	.getsockopt		= ipv6_getsockopt,
+};
+
+struct quic_addr_family_ops *quic_af_ops_get(sa_family_t family)
+{
+	switch (family) {
+	case AF_INET:
+		return &quic_af_inet;
+	case AF_INET6:
+		return &quic_af_inet6;
+	default:
+		return NULL;
+	}
+}
+
+struct quic_addr_family_ops *quic_af_ops_get_skb(struct sk_buff *skb)
+{
+	return quic_af_ops_get(ip_hdr(skb)->version == 4 ? AF_INET : AF_INET6);
+}
+
+static int quic_inet_connect(struct socket *sock, struct sockaddr *addr, int addr_len, int flags)
+{
+	struct sock *sk = sock->sk;
+	const struct proto *prot;
+
+	if (addr_len < sizeof(addr->sa_family))
+		return -EINVAL;
+
+	prot = READ_ONCE(sk->sk_prot);
+
+	return prot->connect(sk, addr, addr_len);
+}
+
+static int quic_inet_listen(struct socket *sock, int backlog)
+{
+	struct quic_conn_id_set *source, *dest;
+	struct quic_conn_id conn_id, *active;
+	struct quic_crypto *crypto;
+	struct quic_outqueue *outq;
+	struct sock *sk = sock->sk;
+	int err = 0;
+
+	lock_sock(sk);
+
+	crypto = quic_crypto(sk, QUIC_CRYPTO_INITIAL);
+	source = quic_source(sk);
+	dest = quic_dest(sk);
+
+	if (!backlog)
+		goto free;
+
+	if (!sk_unhashed(sk))
+		goto out;
+	quic_conn_id_generate(&conn_id);
+	err = quic_conn_id_add(dest, &conn_id, 0, NULL);
+	if (err)
+		goto free;
+	quic_conn_id_generate(&conn_id);
+	err = quic_conn_id_add(source, &conn_id, 0, sk);
+	if (err)
+		goto free;
+	active = quic_conn_id_active(dest);
+	outq = quic_outq(sk);
+	quic_outq_set_serv(outq);
+
+	err = quic_crypto_initial_keys_install(crypto, active, quic_config(sk)->version, 1);
+	if (err)
+		goto free;
+	quic_set_state(sk, QUIC_SS_LISTENING);
+	sk->sk_max_ack_backlog = backlog;
+	err = sk->sk_prot->hash(sk);
+	if (err)
+		goto free;
+out:
+	release_sock(sk);
+	return err;
+free:
+	sk->sk_prot->unhash(sk);
+	sk->sk_max_ack_backlog = 0;
+	quic_crypto_destroy(crypto);
+	quic_conn_id_set_free(dest);
+	quic_conn_id_set_free(source);
+	quic_set_state(sk, QUIC_SS_CLOSED);
+	goto out;
+}
+
+static int quic_inet_getname(struct socket *sock, struct sockaddr *uaddr, int peer)
+{
+	return quic_af_ops(sock->sk)->get_sk_addr(sock, uaddr, peer);
+}
+
+static __poll_t quic_inet_poll(struct file *file, struct socket *sock, poll_table *wait)
+{
+	struct sock *sk = sock->sk;
+	struct list_head *head;
+	__poll_t mask;
+
+	poll_wait(file, sk_sleep(sk), wait);
+
+	sock_rps_record_flow(sk);
+
+	if (quic_is_listen(sk))
+		return !list_empty(quic_reqs(sk)) ? (EPOLLIN | EPOLLRDNORM) : 0;
+
+	mask = 0;
+	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
+		mask |= EPOLLERR | (sock_flag(sk, SOCK_SELECT_ERR_QUEUE) ? EPOLLPRI : 0);
+
+	head = quic_inq_recv_list(quic_inq(sk));
+	if (!list_empty(head))
+		mask |= EPOLLIN | EPOLLRDNORM;
+
+	if (quic_is_closed(sk))
+		return mask;
+
+	if (sk_stream_wspace(sk) > 0) {
+		mask |= EPOLLOUT | EPOLLWRNORM;
+	} else {
+		sk_set_bit(SOCKWQ_ASYNC_NOSPACE, sk);
+		if (sk_stream_wspace(sk) > 0)
+			mask |= EPOLLOUT | EPOLLWRNORM;
+	}
+	return mask;
+}
+
+int quic_encap_len(struct sock *sk)
+{
+	return sizeof(struct udphdr) + quic_af_ops(sk)->iph_len;
+}
+
+int quic_addr_len(struct sock *sk)
+{
+	return quic_af_ops(sk)->addr_len;
+}
+
+int quic_addr_family(struct sock *sk)
+{
+	return quic_af_ops(sk)->sa_family;
+}
+
+void quic_set_sk_addr(struct sock *sk, union quic_addr *a, bool src)
+{
+	return quic_af_ops(sk)->set_sk_addr(sk, a, src);
+}
+
+void quic_get_sk_addr(struct socket *sock, struct sockaddr *a, bool peer)
+{
+	quic_af_ops(sock->sk)->get_sk_addr(sock, a, peer);
+}
+
+void quic_get_msg_addr(struct sock *sk, union quic_addr *addr, struct sk_buff *skb, bool src)
+{
+	quic_af_ops(sk)->get_msg_addr(addr, skb, src);
+}
+
+void quic_get_pref_addr(struct sock *sk, union quic_addr *addr, u8 **pp, u32 *plen)
+{
+	quic_af_ops(sk)->get_pref_addr(addr, pp, plen);
+}
+
+void quic_set_pref_addr(struct sock *sk, u8 *p, union quic_addr *addr)
+{
+	quic_af_ops(sk)->set_pref_addr(p, addr);
+}
+
+void quic_seq_dump_addr(struct sock *sk, struct seq_file *seq, union quic_addr *addr)
+{
+	quic_af_ops(sk)->seq_dump_addr(seq, addr);
+}
+
+bool quic_cmp_sk_addr(struct sock *sk, union quic_addr *a, union quic_addr *addr)
+{
+	return quic_af_ops(sk)->cmp_sk_addr(sk, a, addr);
+}
+
+int quic_get_mtu_info(struct sock *sk, struct sk_buff *skb, u32 *info)
+{
+	return quic_af_ops(sk)->get_mtu_info(skb, info);
+}
+
+void quic_udp_conf_init(struct sock *sk, struct udp_port_cfg *conf, union quic_addr *a)
+{
+	quic_af_ops(sk)->udp_conf_init(sk, conf, a);
+}
+
+void quic_lower_xmit(struct sock *sk, struct sk_buff *skb, union quic_addr *da,
+		     union quic_addr *sa)
+{
+	quic_af_ops(sk)->lower_xmit(sk, skb, da, sa);
+}
+
+int quic_flow_route(struct sock *sk, union quic_addr *da, union quic_addr *sa)
+{
+	return quic_af_ops(sk)->flow_route(sk, da, sa);
+}
+
+int quic_get_msg_ecn(struct sock *sk, struct sk_buff *skb)
+{
+	return quic_af_ops(sk)->get_msg_ecn(skb);
+}
+
+void quic_set_sk_ecn(struct sock *sk, u8 ecn)
+{
+	quic_af_ops(sk)->set_sk_ecn(sk, ecn);
+}
+
+static struct ctl_table quic_table[] = {
+	{
+		.procname	= "quic_mem",
+		.data		= &sysctl_quic_mem,
+		.maxlen		= sizeof(sysctl_quic_mem),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax
+	},
+	{
+		.procname	= "quic_rmem",
+		.data		= &sysctl_quic_rmem,
+		.maxlen		= sizeof(sysctl_quic_rmem),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "quic_wmem",
+		.data		= &sysctl_quic_wmem,
+		.maxlen		= sizeof(sysctl_quic_wmem),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+};
+
+static int quic_seq_show(struct seq_file *seq, void *v)
+{
+	struct net *net = seq_file_net(seq);
+	struct quic_hash_head *head;
+	struct quic_outqueue *outq;
+	int hash = *(loff_t *)v;
+	union quic_addr *addr;
+	struct sock *sk;
+
+	if (hash >= 64)
+		return -ENOMEM;
+
+	head = &quic_hash_tables[QUIC_HT_SOCK].hash[hash];
+	spin_lock(&head->lock);
+	sk_for_each(sk, &head->head) {
+		if (net != sock_net(sk))
+			continue;
+
+		quic_seq_dump_addr(sk, seq, quic_path_addr(quic_src(sk), 0));
+		quic_seq_dump_addr(sk, seq, quic_path_addr(quic_dst(sk), 0));
+		addr = quic_path_udp(quic_src(sk), 0);
+		quic_af_ops_get(addr->v4.sin_family)->seq_dump_addr(seq, addr);
+
+		outq = quic_outq(sk);
+		seq_printf(seq, "%d\t%lld\t%d\t%d\t%d\t%d\t%d\t%d\n", sk->sk_state,
+			   quic_outq_window(outq), quic_packet_mss(quic_packet(sk)),
+			   quic_outq_data_inflight(outq), READ_ONCE(sk->sk_wmem_queued),
+			   sk_rmem_alloc_get(sk), sk->sk_sndbuf, sk->sk_rcvbuf);
+	}
+	spin_unlock(&head->lock);
+	return 0;
+}
+
+static void *quic_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	if (*pos >= 64)
+		return NULL;
+
+	if (*pos < 0)
+		*pos = 0;
+
+	if (*pos == 0)
+		seq_printf(seq, "LOCAL_ADDRESS\tREMOTE_ADDRESS\tUDP_ADDRESS\tSTATE\t"
+				"WINDOW\tMSS\tIN_FLIGHT\tTX_QUEUE\tRX_QUEUE\tSNDBUF\tRCVBUF\n");
+
+	return (void *)pos;
+}
+
+static void *quic_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	if (++*pos >= 64)
+		return NULL;
+
+	return pos;
+}
+
+static void quic_seq_stop(struct seq_file *seq, void *v)
+{
+}
+
+static const struct seq_operations quic_seq_ops = {
+	.show		= quic_seq_show,
+	.start		= quic_seq_start,
+	.next		= quic_seq_next,
+	.stop		= quic_seq_stop,
+};
+
+static const struct proto_ops quic_proto_ops = {
+	.family		   = PF_INET,
+	.owner		   = THIS_MODULE,
+	.release	   = inet_release,
+	.bind		   = inet_bind,
+	.connect	   = quic_inet_connect,
+	.socketpair	   = sock_no_socketpair,
+	.accept		   = inet_accept,
+	.getname	   = quic_inet_getname,
+	.poll		   = quic_inet_poll,
+	.ioctl		   = inet_ioctl,
+	.gettstamp	   = sock_gettstamp,
+	.listen		   = quic_inet_listen,
+	.shutdown	   = inet_shutdown,
+	.setsockopt	   = sock_common_setsockopt,
+	.getsockopt	   = sock_common_getsockopt,
+	.sendmsg	   = inet_sendmsg,
+	.recvmsg	   = inet_recvmsg,
+	.mmap		   = sock_no_mmap,
+};
+
+static struct inet_protosw quic_stream_protosw = {
+	.type       = SOCK_STREAM,
+	.protocol   = IPPROTO_QUIC,
+	.prot       = &quic_prot,
+	.ops        = &quic_proto_ops,
+};
+
+static struct inet_protosw quic_seqpacket_protosw = {
+	.type       = SOCK_DGRAM,
+	.protocol   = IPPROTO_QUIC,
+	.prot       = &quic_prot,
+	.ops        = &quic_proto_ops,
+};
+
+static const struct proto_ops quicv6_proto_ops = {
+	.family		   = PF_INET6,
+	.owner		   = THIS_MODULE,
+	.release	   = inet6_release,
+	.bind		   = inet6_bind,
+	.connect	   = quic_inet_connect,
+	.socketpair	   = sock_no_socketpair,
+	.accept		   = inet_accept,
+	.getname	   = quic_inet_getname,
+	.poll		   = quic_inet_poll,
+	.ioctl		   = inet6_ioctl,
+	.gettstamp	   = sock_gettstamp,
+	.listen		   = quic_inet_listen,
+	.shutdown	   = inet_shutdown,
+	.setsockopt	   = sock_common_setsockopt,
+	.getsockopt	   = sock_common_getsockopt,
+	.sendmsg	   = inet_sendmsg,
+	.recvmsg	   = inet_recvmsg,
+	.mmap		   = sock_no_mmap,
+};
+
+static struct inet_protosw quicv6_stream_protosw = {
+	.type       = SOCK_STREAM,
+	.protocol   = IPPROTO_QUIC,
+	.prot       = &quicv6_prot,
+	.ops        = &quicv6_proto_ops,
+};
+
+static struct inet_protosw quicv6_seqpacket_protosw = {
+	.type       = SOCK_DGRAM,
+	.protocol   = IPPROTO_QUIC,
+	.prot       = &quicv6_prot,
+	.ops        = &quicv6_proto_ops,
+};
+
+static int quic_protosw_init(void)
+{
+	int err;
+
+	err = proto_register(&quic_prot, 1);
+	if (err)
+		return err;
+
+	err = proto_register(&quicv6_prot, 1);
+	if (err) {
+		proto_unregister(&quic_prot);
+		return err;
+	}
+
+	inet_register_protosw(&quic_stream_protosw);
+	inet_register_protosw(&quic_seqpacket_protosw);
+	inet6_register_protosw(&quicv6_stream_protosw);
+	inet6_register_protosw(&quicv6_seqpacket_protosw);
+
+	return 0;
+}
+
+static void quic_protosw_exit(void)
+{
+	inet_unregister_protosw(&quic_seqpacket_protosw);
+	inet_unregister_protosw(&quic_stream_protosw);
+	proto_unregister(&quic_prot);
+
+	inet6_unregister_protosw(&quicv6_seqpacket_protosw);
+	inet6_unregister_protosw(&quicv6_stream_protosw);
+	proto_unregister(&quicv6_prot);
+}
+
+static int __net_init quic_net_init(struct net *net)
+{
+	if (!proc_create_net("quic", 0444, net->proc_net,
+			     &quic_seq_ops, sizeof(struct seq_net_private)))
+		return -ENOMEM;
+	return 0;
+}
+
+static void __net_exit quic_net_exit(struct net *net)
+{
+	remove_proc_entry("quic", net->proc_net);
+}
+
+static struct pernet_operations quic_net_ops = {
+	.init = quic_net_init,
+	.exit = quic_net_exit,
+};
+
+static void quic_hash_tables_destroy(void)
+{
+	struct quic_hash_table *ht;
+	int table;
+
+	for (table = 0; table < QUIC_HT_MAX_TABLES; table++) {
+		ht = &quic_hash_tables[table];
+		ht->size = 64;
+		kfree(ht->hash);
+	}
+}
+
+static int quic_hash_tables_init(void)
+{
+	struct quic_hash_head *head;
+	struct quic_hash_table *ht;
+	int table, i;
+
+	for (table = 0; table < QUIC_HT_MAX_TABLES; table++) {
+		ht = &quic_hash_tables[table];
+		ht->size = 64;
+		head = kmalloc_array(ht->size, sizeof(*head), GFP_KERNEL);
+		if (!head) {
+			quic_hash_tables_destroy();
+			return -ENOMEM;
+		}
+		for (i = 0; i < ht->size; i++) {
+			spin_lock_init(&head[i].lock);
+			INIT_HLIST_HEAD(&head[i].head);
+		}
+		ht->hash = head;
+	}
+
+	return 0;
+}
+
+static struct ctl_table_header *quic_sysctl_header;
+
+static void quic_sysctl_register(void)
+{
+	unsigned long limit;
+	int max_share;
+
+	limit = nr_free_buffer_pages() / 8;
+	limit = max(limit, 128UL);
+	sysctl_quic_mem[0] = limit / 4 * 3;
+	sysctl_quic_mem[1] = limit;
+	sysctl_quic_mem[2] = sysctl_quic_mem[0] * 2;
+
+	limit = (sysctl_quic_mem[1]) << (PAGE_SHIFT - 7);
+	max_share = min(4UL * 1024 * 1024, limit);
+
+	sysctl_quic_rmem[0] = PAGE_SIZE;
+	sysctl_quic_rmem[1] = 1024 * 1024;
+	sysctl_quic_rmem[2] = max(sysctl_quic_rmem[1], max_share);
+
+	sysctl_quic_wmem[0] = PAGE_SIZE;
+	sysctl_quic_wmem[1] = 16 * 1024;
+	sysctl_quic_wmem[2] = max(64 * 1024, max_share);
+
+	quic_sysctl_header = register_net_sysctl(&init_net, "net/quic", quic_table);
+}
+
+static void quic_sysctl_unregister(void)
+{
+	unregister_net_sysctl_table(quic_sysctl_header);
+}
+
+static __init int quic_init(void)
+{
+	int err = -ENOMEM;
+
+	if (quic_hash_tables_init())
+		goto err;
+
+	quic_frame_cachep = kmem_cache_create("quic_frame", sizeof(struct quic_frame),
+					      0, SLAB_HWCACHE_ALIGN, NULL);
+	if (!quic_frame_cachep)
+		goto err_cachep;
+
+	quic_wq = create_workqueue("quic_workqueue");
+	if (!quic_wq)
+		goto err_wq;
+
+	err = percpu_counter_init(&quic_sockets_allocated, 0, GFP_KERNEL);
+	if (err)
+		goto err_percpu_counter;
+
+	err = quic_protosw_init();
+	if (err)
+		goto err_protosw;
+
+	err = register_pernet_subsys(&quic_net_ops);
+	if (err)
+		goto err_def_ops;
+
+	quic_sysctl_register();
+
+	get_random_bytes(quic_random_data, 32);
+	pr_info("quic: init\n");
+	return 0;
+
+err_def_ops:
+	quic_protosw_exit();
+err_protosw:
+	percpu_counter_destroy(&quic_sockets_allocated);
+err_percpu_counter:
+	destroy_workqueue(quic_wq);
+err_wq:
+	kmem_cache_destroy(quic_frame_cachep);
+err_cachep:
+	quic_hash_tables_destroy();
+err:
+	return err;
+}
+
+static __exit void quic_exit(void)
+{
+	quic_sysctl_unregister();
+	unregister_pernet_subsys(&quic_net_ops);
+	quic_protosw_exit();
+	percpu_counter_destroy(&quic_sockets_allocated);
+	destroy_workqueue(quic_wq);
+	quic_hash_tables_destroy();
+	pr_info("quic: exit\n");
+}
+
+module_init(quic_init);
+module_exit(quic_exit);
+
+MODULE_ALIAS("net-pf-" __stringify(PF_INET) "-proto-261");
+MODULE_ALIAS("net-pf-" __stringify(PF_INET6) "-proto-261");
+MODULE_AUTHOR("Xin Long <lucien.xin@gmail.com>");
+MODULE_DESCRIPTION("Support for the QUIC protocol (RFC9000)");
+MODULE_LICENSE("GPL");
diff --git a/net/quic/protocol.h b/net/quic/protocol.h
new file mode 100644
index 000000000000..d28e0aa32ad8
--- /dev/null
+++ b/net/quic/protocol.h
@@ -0,0 +1,71 @@
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
+extern struct kmem_cache *quic_frame_cachep __read_mostly;
+extern struct workqueue_struct *quic_wq __read_mostly;
+extern struct percpu_counter quic_sockets_allocated;
+extern u8 quic_random_data[32] __read_mostly;
+
+extern long sysctl_quic_mem[3];
+extern int sysctl_quic_rmem[3];
+extern int sysctl_quic_wmem[3];
+
+struct quic_addr_family_ops {
+	sa_family_t sa_family;
+	int	addr_len;
+	int	iph_len;
+
+	void	(*udp_conf_init)(struct sock *sk, struct udp_port_cfg *conf, union quic_addr *addr);
+	int	(*flow_route)(struct sock *sk, union quic_addr *da, union quic_addr *sa);
+	void	(*lower_xmit)(struct sock *sk, struct sk_buff *skb, union quic_addr *da,
+			      union quic_addr *sa);
+
+	void	(*get_pref_addr)(union quic_addr *addr, u8 **pp, u32 *plen);
+	void	(*set_pref_addr)(u8 *p, union quic_addr *addr);
+	void	(*seq_dump_addr)(struct seq_file *seq, union quic_addr *addr);
+
+	void	(*get_msg_addr)(union quic_addr *addr, struct sk_buff *skb, bool src);
+	void	(*set_sk_addr)(struct sock *sk, union quic_addr *addr, bool src);
+	int	(*get_sk_addr)(struct socket *sock, struct sockaddr *addr, int peer);
+	bool	(*cmp_sk_addr)(struct sock *sk, union quic_addr *a, union quic_addr *addr);
+	int	(*get_mtu_info)(struct sk_buff *skb, u32 *info);
+
+	void	(*set_sk_ecn)(struct sock *sk, u8 ecn);
+	int	(*get_msg_ecn)(struct sk_buff *skb);
+
+	int	(*setsockopt)(struct sock *sk, int level, int optname, sockptr_t optval,
+			      unsigned int optlen);
+	int	(*getsockopt)(struct sock *sk, int level, int optname, char __user *optval,
+			      int __user *optlen);
+};
+
+void quic_get_msg_addr(struct sock *sk, union quic_addr *addr, struct sk_buff *skb, bool src);
+void quic_seq_dump_addr(struct sock *sk, struct seq_file *seq, union quic_addr *addr);
+void quic_get_pref_addr(struct sock *sk, union quic_addr *addr, u8 **pp, u32 *plen);
+void quic_set_pref_addr(struct sock *sk, u8 *p, union quic_addr *addr);
+
+bool quic_cmp_sk_addr(struct sock *sk, union quic_addr *a, union quic_addr *addr);
+void quic_get_sk_addr(struct socket *sock, struct sockaddr *a, bool peer);
+void quic_set_sk_addr(struct sock *sk, union quic_addr *a, bool src);
+
+void quic_lower_xmit(struct sock *sk, struct sk_buff *skb, union quic_addr *da,
+		     union quic_addr *sa);
+int quic_flow_route(struct sock *sk, union quic_addr *da, union quic_addr *sa);
+
+void quic_udp_conf_init(struct sock *sk, struct udp_port_cfg *conf, union quic_addr *a);
+int quic_get_mtu_info(struct sock *sk, struct sk_buff *skb, u32 *info);
+int quic_get_msg_ecn(struct sock *sk, struct sk_buff *skb);
+void quic_set_sk_ecn(struct sock *sk, u8 ecn);
+
+struct quic_addr_family_ops *quic_af_ops_get_skb(struct sk_buff *skb);
+struct quic_addr_family_ops *quic_af_ops_get(sa_family_t family);
+int quic_addr_family(struct sock *sk);
+int quic_encap_len(struct sock *sk);
+int quic_addr_len(struct sock *sk);
diff --git a/net/quic/socket.c b/net/quic/socket.c
new file mode 100644
index 000000000000..16e074391325
--- /dev/null
+++ b/net/quic/socket.c
@@ -0,0 +1,2183 @@
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
+#include <net/sock_reuseport.h>
+#include <net/inet_common.h>
+#include <linux/version.h>
+#include <net/tls.h>
+
+#include "socket.h"
+
+static DEFINE_PER_CPU(int, quic_memory_per_cpu_fw_alloc);
+static unsigned long quic_memory_pressure;
+static atomic_long_t quic_memory_allocated;
+
+static void quic_enter_memory_pressure(struct sock *sk)
+{
+	WRITE_ONCE(quic_memory_pressure, 1);
+}
+
+bool quic_request_sock_exists(struct sock *sk)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_request_sock *req;
+
+	list_for_each_entry(req, quic_reqs(sk), list) {
+		if (!memcmp(&req->sa, packet->sa, quic_addr_len(sk)) &&
+		    !memcmp(&req->da, packet->da, quic_addr_len(sk)))
+			return true;
+	}
+	return false;
+}
+
+int quic_request_sock_enqueue(struct sock *sk, struct quic_conn_id *odcid, u8 retry)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_request_sock *req;
+
+	if (sk_acceptq_is_full(sk))
+		return -ENOMEM;
+
+	req = kzalloc(sizeof(*req), GFP_ATOMIC);
+	if (!req)
+		return -ENOMEM;
+
+	req->version = packet->version;
+	req->scid = packet->scid;
+	req->dcid = packet->dcid;
+	req->orig_dcid = *odcid;
+	req->da = packet->daddr;
+	req->sa = packet->saddr;
+	req->retry = retry;
+
+	list_add_tail(&req->list, quic_reqs(sk));
+	sk_acceptq_added(sk);
+	return 0;
+}
+
+struct quic_request_sock *quic_request_sock_dequeue(struct sock *sk)
+{
+	struct quic_request_sock *req;
+
+	req = list_first_entry(quic_reqs(sk), struct quic_request_sock, list);
+
+	list_del_init(&req->list);
+	sk_acceptq_removed(sk);
+	return req;
+}
+
+int quic_accept_sock_exists(struct sock *sk, struct sk_buff *skb)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct sock *nsk;
+	int ret = 0;
+
+	local_bh_disable();
+	nsk = quic_sock_lookup(skb, packet->sa, packet->da);
+	if (nsk == sk)
+		goto out;
+	/* the request sock was just accepted */
+	bh_lock_sock(nsk);
+	if (sock_owned_by_user(nsk)) {
+		if (sk_add_backlog(nsk, skb, READ_ONCE(nsk->sk_rcvbuf)))
+			kfree_skb(skb);
+	} else {
+		sk->sk_backlog_rcv(nsk, skb);
+	}
+	bh_unlock_sock(nsk);
+	ret = 1;
+out:
+	local_bh_enable();
+	return ret;
+}
+
+static bool quic_has_bind_any(struct sock *sk)
+{
+	union quic_addr *sa, a = {};
+
+	sa = quic_path_addr(quic_src(sk), 0);
+	a.v4.sin_family = sa->v4.sin_family;
+	a.v4.sin_port = sa->v4.sin_port;
+
+	return quic_cmp_sk_addr(sk, sa, &a);
+}
+
+struct sock *quic_sock_lookup(struct sk_buff *skb, union quic_addr *sa, union quic_addr *da)
+{
+	struct net *net = dev_net(skb->dev);
+	struct quic_data alpns = {}, alpn;
+	struct sock *sk = NULL, *tmp;
+	struct quic_hash_head *head;
+	u64 length;
+	u32 len;
+	u8 *p;
+
+	/* Search for regular socket first */
+	head = quic_sock_head(net, sa, da);
+	spin_lock(&head->lock);
+	sk_for_each(tmp, &head->head) {
+		if (net == sock_net(tmp) &&
+		    !quic_path_cmp(quic_src(tmp), 0, sa) &&
+		    !quic_path_cmp(quic_dst(tmp), 0, da)) {
+			sk = tmp;
+			break;
+		}
+	}
+	spin_unlock(&head->lock);
+	if (sk)
+		return sk;
+
+	if (quic_packet_parse_alpn(skb, &alpns) < 0)
+		return NULL;
+
+	/* Search for listen socket */
+	head = quic_listen_sock_head(net, ntohs(sa->v4.sin_port));
+	spin_lock(&head->lock);
+
+	if (!alpns.len) {
+		sk_for_each(tmp, &head->head) {
+			/* alpns.data != NULL means TLS parse succeed but no ALPN was found,
+			 * in such case it only matches the sock with no ALPN set.
+			 */
+			if (net == sock_net(tmp) && quic_is_listen(tmp) &&
+			    quic_cmp_sk_addr(tmp, quic_path_addr(quic_src(tmp), 0), sa) &&
+			    (!alpns.data || !quic_alpn(tmp)->len)) {
+				sk = tmp;
+				if (!quic_has_bind_any(sk))
+					break;
+			}
+		}
+		goto unlock;
+	}
+
+	for (p = alpns.data, len = alpns.len; len; len -= length, p += length) {
+		quic_get_int(&p, &len, &length, 1);
+		quic_data(&alpn, p, length);
+		sk_for_each(tmp, &head->head) {
+			if (net == sock_net(tmp) && quic_is_listen(tmp) &&
+			    quic_cmp_sk_addr(tmp, quic_path_addr(quic_src(tmp), 0), sa) &&
+			    quic_data_has(quic_alpn(tmp), &alpn)) {
+				sk = tmp;
+				if (!quic_has_bind_any(sk))
+					break;
+			}
+		}
+		if (sk)
+			break;
+	}
+unlock:
+	spin_unlock(&head->lock);
+
+	if (sk && sk->sk_reuseport)
+		sk = reuseport_select_sock(sk, quic_shash(net, da), skb, 1);
+	return sk;
+}
+
+static void quic_write_space(struct sock *sk)
+{
+	struct socket_wq *wq;
+
+	rcu_read_lock();
+	wq = rcu_dereference(sk->sk_wq);
+	if (skwq_has_sleeper(wq))
+		wake_up_interruptible_sync_poll(&wq->wait, EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND);
+	rcu_read_unlock();
+}
+
+static void quic_transport_param_init(struct sock *sk)
+{
+	struct quic_transport_param *param = quic_local(sk);
+
+	param->max_udp_payload_size = QUIC_MAX_UDP_PAYLOAD;
+	param->ack_delay_exponent = QUIC_DEF_ACK_DELAY_EXPONENT;
+	param->max_ack_delay = QUIC_DEF_ACK_DELAY;
+	param->active_connection_id_limit = QUIC_CONN_ID_LIMIT;
+	param->max_idle_timeout = QUIC_DEF_IDLE_TIMEOUT;
+	param->max_data = QUIC_PATH_MAX_PMTU * 32;
+	param->max_stream_data_bidi_local = QUIC_PATH_MAX_PMTU * 4;
+	param->max_stream_data_bidi_remote = QUIC_PATH_MAX_PMTU * 4;
+	param->max_stream_data_uni = QUIC_PATH_MAX_PMTU * 4;
+	param->max_streams_bidi = QUIC_DEF_STREAMS;
+	param->max_streams_uni = QUIC_DEF_STREAMS;
+
+	quic_inq_set_param(sk, param);
+	quic_cong_set_param(quic_cong(sk), param);
+	quic_conn_id_set_param(quic_dest(sk), param);
+	quic_stream_set_param(quic_streams(sk), param, NULL);
+}
+
+static void quic_config_init(struct sock *sk)
+{
+	struct quic_config *config = quic_config(sk);
+
+	config->initial_smoothed_rtt = QUIC_RTT_INIT;
+	config->version = QUIC_VERSION_V1;
+
+	quic_cong_set_config(quic_cong(sk), config);
+}
+
+static int quic_init_sock(struct sock *sk)
+{
+	u8 len, i;
+
+	sk->sk_destruct = inet_sock_destruct;
+	sk->sk_write_space = quic_write_space;
+	sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
+
+	quic_set_af_ops(sk, quic_af_ops_get(sk->sk_family));
+	quic_conn_id_set_init(quic_source(sk), 1);
+	quic_conn_id_set_init(quic_dest(sk), 0);
+
+	len = quic_addr_len(sk);
+	quic_path_addr_init(quic_src(sk), len, 1);
+	quic_path_addr_init(quic_dst(sk), len, 0);
+
+	quic_transport_param_init(sk);
+	quic_config_init(sk);
+
+	quic_outq_init(sk);
+	quic_inq_init(sk);
+	quic_packet_init(sk);
+	quic_timer_init(sk);
+
+	for (i = 0; i < QUIC_PNSPACE_MAX; i++) {
+		if (quic_pnspace_init(quic_pnspace(sk, i)))
+			return -ENOMEM;
+	}
+	if (quic_stream_init(quic_streams(sk)))
+		return -ENOMEM;
+	INIT_LIST_HEAD(quic_reqs(sk));
+
+	WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(sysctl_quic_wmem[1]));
+	WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(sysctl_quic_rmem[1]));
+
+	local_bh_disable();
+	sk_sockets_allocated_inc(sk);
+	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
+	local_bh_enable();
+
+	return 0;
+}
+
+static void quic_destroy_sock(struct sock *sk)
+{
+	u8 i;
+
+	for (i = 0; i < QUIC_PNSPACE_MAX; i++)
+		quic_pnspace_free(quic_pnspace(sk, i));
+	for (i = 0; i < QUIC_CRYPTO_MAX; i++)
+		quic_crypto_destroy(quic_crypto(sk, i));
+
+	quic_timer_free(sk);
+	quic_stream_free(quic_streams(sk));
+
+	quic_data_free(quic_ticket(sk));
+	quic_data_free(quic_token(sk));
+	quic_data_free(quic_alpn(sk));
+
+	local_bh_disable();
+	sk_sockets_allocated_dec(sk);
+	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
+	local_bh_enable();
+}
+
+static int quic_bind(struct sock *sk, struct sockaddr *addr, int addr_len)
+{
+	struct quic_path_addr *path = quic_src(sk);
+	union quic_addr *a;
+	int err = 0;
+
+	lock_sock(sk);
+
+	a = quic_path_addr(path, 0);
+	if (a->v4.sin_port || addr_len < quic_addr_len(sk) ||
+	    addr->sa_family != sk->sk_family || !quic_addr(addr)->v4.sin_port) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	quic_path_addr_set(path, quic_addr(addr), 0);
+	err = quic_path_set_bind_port(sk, path, 0);
+	if (err) {
+		quic_path_addr_free(sk, path, 0);
+		goto out;
+	}
+	err = quic_path_set_udp_sock(sk, path, 0);
+	if (err) {
+		quic_path_addr_free(sk, path, 0);
+		goto out;
+	}
+	quic_set_sk_addr(sk, a, true);
+
+out:
+	release_sock(sk);
+	return err;
+}
+
+static int quic_connect(struct sock *sk, struct sockaddr *addr, int addr_len)
+{
+	struct quic_crypto *crypto = quic_crypto(sk, QUIC_CRYPTO_INITIAL);
+	struct quic_conn_id_set *source = quic_source(sk);
+	struct quic_conn_id_set *dest = quic_dest(sk);
+	struct quic_path_addr *path = quic_src(sk);
+	struct quic_outqueue *outq = quic_outq(sk);
+	struct quic_inqueue *inq = quic_inq(sk);
+	struct quic_conn_id conn_id, *active;
+	union quic_addr *sa;
+	int err = -EINVAL;
+
+	lock_sock(sk);
+	if (!quic_is_closed(sk) || addr_len < quic_addr_len(sk))
+		goto out;
+
+	quic_path_addr_set(quic_dst(sk), quic_addr(addr), 0);
+	err = quic_packet_route(sk);
+	if (err < 0)
+		goto out;
+	quic_set_sk_addr(sk, quic_addr(addr), false);
+	sa = quic_path_addr(path, 0);
+	if (!sa->v4.sin_port) { /* auto bind */
+		err = quic_path_set_bind_port(sk, path, 0);
+		if (err) {
+			quic_path_addr_free(sk, path, 0);
+			goto out;
+		}
+		err = quic_path_set_udp_sock(sk, path, 0);
+		if (err) {
+			quic_path_addr_free(sk, path, 0);
+			goto out;
+		}
+		quic_set_sk_addr(sk, sa, true);
+	}
+
+	quic_conn_id_generate(&conn_id);
+	err = quic_conn_id_add(dest, &conn_id, 0, NULL);
+	if (err)
+		goto out;
+	quic_outq_set_orig_dcid(outq, &conn_id);
+	quic_conn_id_generate(&conn_id);
+	err = quic_conn_id_add(source, &conn_id, 0, sk);
+	if (err)
+		goto free;
+	err = sk->sk_prot->hash(sk);
+	if (err)
+		goto free;
+	active = quic_conn_id_active(dest);
+	err = quic_crypto_initial_keys_install(crypto, active, quic_config(sk)->version, 0);
+	if (err)
+		goto free;
+
+	quic_timer_start(sk, QUIC_TIMER_SACK, quic_inq_max_idle_timeout(inq));
+	quic_set_state(sk, QUIC_SS_ESTABLISHING);
+out:
+	release_sock(sk);
+	return err;
+free:
+	quic_conn_id_set_free(dest);
+	quic_conn_id_set_free(source);
+	sk->sk_prot->unhash(sk);
+	goto out;
+}
+
+static int quic_hash(struct sock *sk)
+{
+	struct quic_data *alpns = quic_alpn(sk);
+	struct net *net = sock_net(sk);
+	struct quic_hash_head *head;
+	union quic_addr *sa, *da;
+	struct sock *nsk;
+	int err = 0, any;
+
+	sa = quic_path_addr(quic_src(sk), 0);
+	da = quic_path_addr(quic_dst(sk), 0);
+	if (!sk->sk_max_ack_backlog) {
+		head = quic_sock_head(net, sa, da);
+		spin_lock(&head->lock);
+
+		sk_for_each(nsk, &head->head) {
+			if (net == sock_net(nsk) &&
+			    !quic_path_cmp(quic_src(nsk), 0, sa) &&
+			    !quic_path_cmp(quic_dst(nsk), 0, da)) {
+				spin_unlock(&head->lock);
+				return -EADDRINUSE;
+			}
+		}
+		__sk_add_node(sk, &head->head);
+
+		spin_unlock(&head->lock);
+		return 0;
+	}
+
+	head = quic_listen_sock_head(net, ntohs(sa->v4.sin_port));
+	spin_lock(&head->lock);
+
+	any = quic_has_bind_any(sk);
+	sk_for_each(nsk, &head->head) {
+		if (net == sock_net(nsk) && quic_is_listen(nsk) &&
+		    !quic_path_cmp(quic_src(nsk), 0, sa)) {
+			if (!quic_data_cmp(alpns, quic_alpn(nsk))) {
+				err = -EADDRINUSE;
+				if (sk->sk_reuseport && nsk->sk_reuseport) {
+					err = reuseport_add_sock(sk, nsk, any);
+					if (!err)
+						__sk_add_node(sk, &head->head);
+				}
+				goto out;
+			}
+			if (quic_data_match(alpns, quic_alpn(nsk))) {
+				err = -EADDRINUSE;
+				goto out;
+			}
+		}
+	}
+
+	if (sk->sk_reuseport) {
+		err = reuseport_alloc(sk, any);
+		if (err)
+			goto out;
+	}
+	__sk_add_node(sk, &head->head);
+out:
+	spin_unlock(&head->lock);
+	return err;
+}
+
+static void quic_unhash(struct sock *sk)
+{
+	struct net *net = sock_net(sk);
+	struct quic_hash_head *head;
+	union quic_addr *sa, *da;
+
+	if (sk_unhashed(sk))
+		return;
+
+	sa = quic_path_addr(quic_src(sk), 0);
+	da = quic_path_addr(quic_dst(sk), 0);
+	if (sk->sk_max_ack_backlog) {
+		head = quic_listen_sock_head(net, ntohs(sa->v4.sin_port));
+		goto out;
+	}
+	head = quic_sock_head(net, sa, da);
+
+out:
+	spin_lock(&head->lock);
+	if (rcu_access_pointer(sk->sk_reuseport_cb))
+		reuseport_detach_sock(sk);
+	__sk_del_node_init(sk);
+	spin_unlock(&head->lock);
+}
+
+static int quic_msghdr_parse(struct sock *sk, struct msghdr *msg, struct quic_handshake_info *hinfo,
+			     struct quic_stream_info *sinfo, bool *has_hinfo)
+{
+	struct quic_handshake_info *h = NULL;
+	struct quic_stream_info *s = NULL;
+	struct quic_stream_table *streams;
+	struct cmsghdr *cmsg;
+	u64 active;
+
+	sinfo->stream_id = -1;
+	for_each_cmsghdr(cmsg, msg) {
+		if (!CMSG_OK(msg, cmsg))
+			return -EINVAL;
+
+		if (cmsg->cmsg_level != IPPROTO_QUIC)
+			continue;
+
+		switch (cmsg->cmsg_type) {
+		case QUIC_HANDSHAKE_INFO:
+			if (cmsg->cmsg_len != CMSG_LEN(sizeof(*h)))
+				return -EINVAL;
+			h = CMSG_DATA(cmsg);
+			hinfo->crypto_level = h->crypto_level;
+			break;
+		case QUIC_STREAM_INFO:
+			if (cmsg->cmsg_len != CMSG_LEN(sizeof(*s)))
+				return -EINVAL;
+			s = CMSG_DATA(cmsg);
+			sinfo->stream_id = s->stream_id;
+			sinfo->stream_flags = s->stream_flags;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	if (h) {
+		*has_hinfo = true;
+		return 0;
+	}
+
+	if (!s) /* in case someone uses 'flags' argument to set stream_flags */
+		sinfo->stream_flags |= msg->msg_flags;
+
+	if (sinfo->stream_id != -1)
+		return 0;
+
+	streams = quic_streams(sk);
+	active = quic_stream_send_active(streams);
+	if (active != -1) {
+		sinfo->stream_id = active;
+		return 0;
+	}
+	sinfo->stream_id = (quic_stream_send_bidi(streams) << 2);
+	if (sinfo->stream_flags & MSG_STREAM_UNI) {
+		sinfo->stream_id = (quic_stream_send_uni(streams) << 2);
+		sinfo->stream_id |= QUIC_STREAM_TYPE_UNI_MASK;
+	}
+	sinfo->stream_id |= quic_is_serv(sk);
+	return 0;
+}
+
+static int quic_wait_for_send(struct sock *sk, u64 stream_id, long timeo, u32 msg_len)
+{
+	for (;;) {
+		int err = 0, exit = 1;
+		DEFINE_WAIT(wait);
+
+		prepare_to_wait_exclusive(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
+		if (!timeo) {
+			err = -EAGAIN;
+			goto out;
+		}
+		if (sk->sk_err) {
+			err = -EPIPE;
+			pr_debug("%s: sk_err: %d\n", __func__, sk->sk_err);
+			goto out;
+		}
+		if (signal_pending(current)) {
+			err = sock_intr_errno(timeo);
+			goto out;
+		}
+		if (quic_is_closed(sk)) {
+			err = -EPIPE;
+			pr_debug("%s: sk closed\n", __func__);
+			goto out;
+		}
+
+		if (stream_id) {
+			if (!quic_stream_id_send_exceeds(quic_streams(sk), stream_id))
+				goto out;
+		} else {
+			if ((int)msg_len <= sk_stream_wspace(sk) &&
+			    sk_wmem_schedule(sk, msg_len))
+				goto out;
+		}
+
+		exit = 0;
+		release_sock(sk);
+		timeo = schedule_timeout(timeo);
+		lock_sock(sk);
+out:
+		finish_wait(sk_sleep(sk), &wait);
+		if (exit)
+			return err;
+	}
+}
+
+static struct quic_stream *quic_sock_send_stream(struct sock *sk, struct quic_stream_info *sinfo)
+{
+	struct quic_crypto *crypto = quic_crypto(sk, QUIC_CRYPTO_APP);
+	struct quic_stream_table *streams = quic_streams(sk);
+	u8 type = QUIC_FRAME_STREAMS_BLOCKED_BIDI;
+	struct quic_stream *stream;
+	struct quic_frame *frame;
+	long timeo;
+	int err;
+
+	stream = quic_stream_send_get(streams, sinfo->stream_id,
+				      sinfo->stream_flags, quic_is_serv(sk));
+	if (!IS_ERR(stream)) {
+		if (stream->send.state >= QUIC_STREAM_SEND_STATE_SENT)
+			return ERR_PTR(-EINVAL);
+		return stream;
+	} else if (PTR_ERR(stream) != -EAGAIN) {
+		return stream;
+	}
+
+	/* 0rtt data should return err if stream is not found */
+	if (!quic_crypto_send_ready(crypto))
+		return ERR_PTR(-EINVAL);
+
+	if (sinfo->stream_id & QUIC_STREAM_TYPE_UNI_MASK)
+		type = QUIC_FRAME_STREAMS_BLOCKED_UNI;
+
+	frame = quic_frame_create(sk, type, &sinfo->stream_id);
+	if (!frame)
+		return ERR_PTR(-ENOMEM);
+	quic_outq_ctrl_tail(sk, frame, false);
+
+	timeo = sock_sndtimeo(sk, sinfo->stream_flags & MSG_STREAM_DONTWAIT);
+	err = quic_wait_for_send(sk, sinfo->stream_id, timeo, 0);
+	if (err)
+		return ERR_PTR(err);
+
+	return quic_stream_send_get(streams, sinfo->stream_id,
+				    sinfo->stream_flags, quic_is_serv(sk));
+}
+
+static int quic_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
+{
+	struct quic_handshake_info hinfo = {};
+	struct quic_stream_info sinfo = {};
+	struct quic_msginfo msginfo;
+	struct quic_crypto *crypto;
+	struct quic_stream *stream;
+	struct quic_frame *frame;
+	bool has_hinfo = false;
+	int err = 0, bytes = 0;
+	long timeo;
+
+	lock_sock(sk);
+	err = quic_msghdr_parse(sk, msg, &hinfo, &sinfo, &has_hinfo);
+	if (err)
+		goto err;
+
+	if (has_hinfo) {
+		if (hinfo.crypto_level >= QUIC_CRYPTO_EARLY) {
+			err = -EINVAL;
+			goto err;
+		}
+		crypto = quic_crypto(sk, hinfo.crypto_level);
+		if (!quic_crypto_send_ready(crypto)) {
+			err = -EINVAL;
+			goto err;
+		}
+		msginfo.level = hinfo.crypto_level;
+		msginfo.msg = &msg->msg_iter;
+		while (iov_iter_count(&msg->msg_iter) > 0) {
+			frame = quic_frame_create(sk, QUIC_FRAME_CRYPTO, &msginfo);
+			if (!frame)
+				goto out;
+			if (sk_stream_wspace(sk) < frame->bytes ||
+			    !sk_wmem_schedule(sk, frame->bytes)) {
+				timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
+				err = quic_wait_for_send(sk, 0, timeo, frame->bytes);
+				if (err) {
+					quic_frame_free(frame);
+					goto err;
+				}
+			}
+			bytes += frame->bytes;
+			quic_outq_ctrl_tail(sk, frame, true);
+			quic_outq_set_owner_w(frame->bytes, sk);
+		}
+		goto out;
+	}
+
+	if (msg->msg_flags & MSG_DATAGRAM) {
+		if (!quic_outq_max_dgram(quic_outq(sk))) {
+			err = -EINVAL;
+			goto err;
+		}
+		frame = quic_frame_create(sk, QUIC_FRAME_DATAGRAM_LEN, &msg->msg_iter);
+		if (!frame) {
+			err = -EINVAL;
+			goto err;
+		}
+		if (sk_stream_wspace(sk) < frame->bytes || !sk_wmem_schedule(sk, frame->bytes)) {
+			timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
+			err = quic_wait_for_send(sk, 0, timeo, frame->bytes);
+			if (err) {
+				quic_frame_free(frame);
+				goto err;
+			}
+		}
+		bytes += frame->bytes;
+		quic_outq_dgram_tail(sk, frame, true);
+		quic_outq_set_owner_w(frame->bytes, sk);
+		goto out;
+	}
+
+	stream = quic_sock_send_stream(sk, &sinfo);
+	if (IS_ERR(stream)) {
+		err = PTR_ERR(stream);
+		goto err;
+	}
+
+	msginfo.stream = stream;
+	msginfo.msg = &msg->msg_iter;
+	msginfo.flags = sinfo.stream_flags;
+
+	while (iov_iter_count(msginfo.msg) > 0) {
+		frame = quic_frame_create(sk, QUIC_FRAME_STREAM, &msginfo);
+		if (!frame)
+			goto out;
+		if (sk_stream_wspace(sk) < frame->bytes || !sk_wmem_schedule(sk, frame->bytes)) {
+			timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
+			err = quic_wait_for_send(sk, 0, timeo, frame->bytes);
+			if (err) {
+				quic_frame_free(frame);
+				if (err == -EPIPE)
+					goto err;
+				goto out;
+			}
+		}
+		bytes += frame->bytes;
+		quic_outq_stream_tail(sk, frame, true);
+		quic_outq_set_owner_w(frame->bytes, sk);
+	}
+out:
+	err = bytes;
+	if (!(msg->msg_flags & MSG_MORE) && err)
+		quic_outq_transmit(sk);
+err:
+	release_sock(sk);
+	return err;
+}
+
+static int quic_wait_for_packet(struct sock *sk, long timeo)
+{
+	struct list_head *head = quic_inq_recv_list(quic_inq(sk));
+
+	for (;;) {
+		int err = 0, exit = 1;
+		DEFINE_WAIT(wait);
+
+		prepare_to_wait_exclusive(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
+
+		if (!list_empty(head))
+			goto out;
+
+		err = sk->sk_err;
+		if (err) {
+			pr_debug("%s: sk_err: %d\n", __func__, err);
+			goto out;
+		}
+
+		err = -ENOTCONN;
+		if (quic_is_closed(sk))
+			goto out;
+
+		err = -EAGAIN;
+		if (!timeo)
+			goto out;
+
+		err = sock_intr_errno(timeo);
+		if (signal_pending(current))
+			goto out;
+
+		exit = 0;
+		release_sock(sk);
+		timeo = schedule_timeout(timeo);
+		lock_sock(sk);
+out:
+		finish_wait(sk_sleep(sk), &wait);
+		if (exit)
+			return err;
+	}
+}
+
+static int quic_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
+			int *addr_len)
+{
+	int err, copy, copied = 0, freed = 0, bytes = 0;
+	struct quic_inqueue *inq = quic_inq(sk);
+	struct quic_handshake_info hinfo = {};
+	int nonblock = flags & MSG_DONTWAIT;
+	struct quic_stream_info sinfo = {};
+	int fin, off, event, dgram, level;
+	struct quic_frame *frame, *next;
+	struct quic_stream *stream;
+	struct list_head *head;
+	long timeo;
+
+	lock_sock(sk);
+
+	timeo = sock_rcvtimeo(sk, nonblock);
+	err = quic_wait_for_packet(sk, timeo);
+	if (err)
+		goto out;
+
+	head = quic_inq_recv_list(quic_inq(sk));
+	list_for_each_entry_safe(frame, next, head, list) {
+		off = frame->offset;
+		copy = min_t(int, frame->len - off, len - copied);
+		copy = copy_to_iter(frame->data + off, copy, &msg->msg_iter);
+		if (!copy) {
+			if (!copied) {
+				err = -EFAULT;
+				goto out;
+			}
+			break;
+		}
+		copied += copy;
+		fin = frame->stream_fin;
+		event = frame->event;
+		dgram = frame->dgram;
+		level = frame->level;
+		stream = frame->stream;
+		if (event) {
+			msg->msg_flags |= MSG_NOTIFICATION;
+		} else if (level) {
+			hinfo.crypto_level = level;
+			put_cmsg(msg, IPPROTO_QUIC, QUIC_HANDSHAKE_INFO, sizeof(hinfo), &hinfo);
+			if (msg->msg_flags & MSG_CTRUNC) {
+				err = -EINVAL;
+				goto out;
+			}
+		} else if (dgram) {
+			msg->msg_flags |= MSG_DATAGRAM;
+		}
+		if (flags & MSG_PEEK)
+			break;
+		if (copy != frame->len - off) {
+			frame->offset += copy;
+			break;
+		}
+		msg->msg_flags |= MSG_EOR;
+		bytes += frame->len;
+		if (event) {
+			if (frame == quic_inq_last_event(inq))
+				quic_inq_set_last_event(inq, NULL); /* no more event on list */
+			if (event == QUIC_EVENT_STREAM_UPDATE &&
+			    stream->recv.state == QUIC_STREAM_RECV_STATE_RESET_RECVD)
+				stream->recv.state = QUIC_STREAM_RECV_STATE_RESET_READ;
+			list_del(&frame->list);
+			quic_frame_free(frame);
+			break;
+		} else if (level) {
+			list_del(&frame->list);
+			quic_frame_free(frame);
+			break;
+		} else if (dgram) {
+			list_del(&frame->list);
+			quic_frame_free(frame);
+			break;
+		}
+		freed += frame->len;
+		list_del(&frame->list);
+		quic_frame_free(frame);
+		if (fin) {
+			stream->recv.state = QUIC_STREAM_RECV_STATE_READ;
+			sinfo.stream_flags |= MSG_STREAM_FIN;
+			break;
+		}
+
+		if (list_entry_is_head(next, head, list) || copied >= len)
+			break;
+		if (next->event || next->dgram || !next->stream || next->stream != stream)
+			break;
+	};
+
+	if (!event && stream) {
+		sinfo.stream_id = stream->id;
+		put_cmsg(msg, IPPROTO_QUIC, QUIC_STREAM_INFO, sizeof(sinfo), &sinfo);
+		if (msg->msg_flags & MSG_CTRUNC)
+			msg->msg_flags |= sinfo.stream_flags;
+
+		quic_inq_flow_control(sk, stream, freed);
+	}
+
+	quic_inq_rfree(bytes, sk);
+	err = copied;
+out:
+	release_sock(sk);
+	return err;
+}
+
+static int quic_wait_for_accept(struct sock *sk, long timeo)
+{
+	DEFINE_WAIT(wait);
+	int err = 0;
+
+	for (;;) {
+		prepare_to_wait_exclusive(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
+		if (list_empty(quic_reqs(sk))) {
+			release_sock(sk);
+			timeo = schedule_timeout(timeo);
+			lock_sock(sk);
+		}
+
+		if (!quic_is_listen(sk)) {
+			err = -EINVAL;
+			break;
+		}
+
+		if (!list_empty(quic_reqs(sk))) {
+			err = 0;
+			break;
+		}
+
+		if (signal_pending(current)) {
+			err = sock_intr_errno(timeo);
+			break;
+		}
+
+		if (!timeo) {
+			err = -EAGAIN;
+			break;
+		}
+	}
+
+	finish_wait(sk_sleep(sk), &wait);
+	return err;
+}
+
+static int quic_param_check_and_copy(struct quic_transport_param *p,
+				     struct quic_transport_param *param)
+{
+	if (p->max_udp_payload_size) {
+		if (p->max_udp_payload_size < QUIC_MIN_UDP_PAYLOAD ||
+		    p->max_udp_payload_size > QUIC_MAX_UDP_PAYLOAD)
+			return -EINVAL;
+		param->max_udp_payload_size = p->max_udp_payload_size;
+	}
+	if (p->ack_delay_exponent) {
+		if (p->ack_delay_exponent > QUIC_MAX_ACK_DELAY_EXPONENT)
+			return -EINVAL;
+		param->ack_delay_exponent = p->ack_delay_exponent;
+	}
+	if (p->max_ack_delay) {
+		if (p->max_ack_delay >= QUIC_MAX_ACK_DELAY)
+			return -EINVAL;
+		param->max_ack_delay = p->max_ack_delay;
+	}
+	if (p->active_connection_id_limit) {
+		if (p->active_connection_id_limit > QUIC_CONN_ID_LIMIT)
+			return -EINVAL;
+		param->active_connection_id_limit = p->active_connection_id_limit;
+	}
+	if (p->max_idle_timeout) {
+		if (p->max_idle_timeout < QUIC_MIN_IDLE_TIMEOUT)
+			return -EINVAL;
+		param->max_idle_timeout = p->max_idle_timeout;
+	}
+	if (p->max_datagram_frame_size) {
+		if (p->max_datagram_frame_size < QUIC_MIN_UDP_PAYLOAD ||
+		    p->max_datagram_frame_size > QUIC_MAX_UDP_PAYLOAD)
+			return -EINVAL;
+		param->max_datagram_frame_size = p->max_datagram_frame_size;
+	}
+	if (p->max_data) {
+		if (p->max_data < QUIC_PATH_MAX_PMTU * 2)
+			return -EINVAL;
+		param->max_data = p->max_data;
+	}
+	if (p->max_stream_data_bidi_local) {
+		if (p->max_stream_data_bidi_local > param->max_data)
+			return -EINVAL;
+		param->max_stream_data_bidi_local = p->max_stream_data_bidi_local;
+	}
+	if (p->max_stream_data_bidi_remote) {
+		if (p->max_stream_data_bidi_remote > param->max_data)
+			return -EINVAL;
+		param->max_stream_data_bidi_remote = p->max_stream_data_bidi_remote;
+	}
+	if (p->max_stream_data_uni) {
+		if (p->max_stream_data_uni > param->max_data)
+			return -EINVAL;
+		param->max_stream_data_uni = p->max_stream_data_uni;
+	}
+	if (p->max_streams_bidi) {
+		if (p->max_streams_bidi > QUIC_MAX_STREAMS)
+			return -EINVAL;
+		param->max_streams_bidi = p->max_streams_bidi;
+	}
+	if (p->max_streams_uni) {
+		if (p->max_streams_uni > QUIC_MAX_STREAMS)
+			return -EINVAL;
+		param->max_streams_uni = p->max_streams_uni;
+	}
+	if (p->disable_active_migration)
+		param->disable_active_migration = p->disable_active_migration;
+	if (p->disable_1rtt_encryption)
+		param->disable_1rtt_encryption = p->disable_1rtt_encryption;
+	if (p->grease_quic_bit)
+		param->grease_quic_bit = p->grease_quic_bit;
+	if (p->stateless_reset)
+		param->stateless_reset = p->stateless_reset;
+
+	return 0;
+}
+
+static int quic_sock_set_transport_param(struct sock *sk, struct quic_transport_param *p, u32 len)
+{
+	struct quic_transport_param *param = quic_local(sk);
+
+	if (len < sizeof(*param) || quic_is_established(sk))
+		return -EINVAL;
+
+	if (p->remote)
+		param = quic_remote(sk);
+
+	if (quic_param_check_and_copy(p, param))
+		return -EINVAL;
+
+	if (p->remote) {
+		if (!quic_is_establishing(sk))
+			return -EINVAL;
+		param->remote = 1;
+		quic_outq_set_param(sk, param);
+		quic_conn_id_set_param(quic_source(sk), param);
+		quic_stream_set_param(quic_streams(sk), NULL, param);
+		return 0;
+	}
+
+	quic_inq_set_param(sk, param);
+	quic_cong_set_param(quic_cong(sk), param);
+	quic_conn_id_set_param(quic_dest(sk), param);
+	quic_stream_set_param(quic_streams(sk), param, NULL);
+	return 0;
+}
+
+static int quic_copy_sock(struct sock *nsk, struct sock *sk, struct quic_request_sock *req)
+{
+	struct quic_crypto *crypto = quic_crypto(sk, QUIC_CRYPTO_APP);
+	struct quic_transport_param *param = quic_local(sk);
+	struct quic_inqueue *inq = quic_inq(sk);
+	struct sk_buff *skb, *tmp;
+	union quic_addr sa, da;
+	u32 events, type;
+
+	if (quic_data_dup(quic_alpn(nsk), quic_alpn(sk)->data, quic_alpn(sk)->len))
+		return -ENOMEM;
+
+	nsk->sk_type = sk->sk_type;
+	nsk->sk_flags = sk->sk_flags;
+	nsk->sk_protocol = IPPROTO_QUIC;
+	nsk->sk_backlog_rcv = sk->sk_prot->backlog_rcv;
+
+	nsk->sk_sndbuf = sk->sk_sndbuf;
+	nsk->sk_rcvbuf = sk->sk_rcvbuf;
+	nsk->sk_rcvtimeo = sk->sk_rcvtimeo;
+	nsk->sk_sndtimeo = sk->sk_sndtimeo;
+
+	inet_sk(nsk)->pmtudisc = inet_sk(sk)->pmtudisc;
+
+	skb_queue_walk_safe(quic_inq_backlog_list(inq), skb, tmp) {
+		quic_get_msg_addr(nsk, &da, skb, 0);
+		quic_get_msg_addr(nsk, &sa, skb, 1);
+
+		if (!memcmp(&req->sa, &da, quic_addr_len(nsk)) &&
+		    !memcmp(&req->da, &sa, quic_addr_len(nsk))) {
+			__skb_unlink(skb, quic_inq_backlog_list(inq));
+			quic_inq_backlog_tail(nsk, skb);
+		}
+	}
+
+	if (sk->sk_family == AF_INET6) /* nsk uses quicv6 ops in this case */
+		inet_sk(nsk)->pinet6 = &((struct quic6_sock *)nsk)->inet6;
+
+	quic_sock_set_transport_param(nsk, param, sizeof(*param));
+	events = quic_inq_events(inq);
+	inq = quic_inq(nsk);
+	quic_inq_set_events(inq, events);
+
+	type = quic_crypto_cipher_type(crypto);
+	crypto = quic_crypto(nsk, QUIC_CRYPTO_APP);
+	quic_crypto_set_cipher_type(crypto, type);
+
+	return 0;
+}
+
+static int quic_accept_sock_init(struct sock *sk, struct quic_request_sock *req)
+{
+	struct quic_outqueue *outq = quic_outq(sk);
+	struct quic_inqueue *inq = quic_inq(sk);
+	struct quic_conn_id conn_id;
+	struct sk_buff_head tmpq;
+	struct sk_buff *skb;
+	int err;
+
+	lock_sock(sk);
+	quic_path_addr_set(quic_dst(sk), &req->da, 0);
+	err = quic_packet_route(sk);
+	if (err < 0)
+		goto out;
+	quic_set_sk_addr(sk, quic_addr(&req->da.sa), false);
+
+	quic_conn_id_generate(&conn_id);
+	err = quic_conn_id_add(quic_source(sk), &conn_id, 0, sk);
+	if (err)
+		goto out;
+	err = quic_conn_id_add(quic_dest(sk), &req->scid, 0, NULL);
+	if (err)
+		goto out;
+
+	quic_outq_set_serv(outq);
+	err = quic_packet_version_change(sk, &req->dcid, req->version);
+	if (err)
+		goto out;
+
+	err = sk->sk_prot->hash(sk);
+	if (err)
+		goto out;
+
+	quic_outq_set_orig_dcid(outq, &req->orig_dcid);
+	if (req->retry) {
+		quic_outq_set_retry(outq, 1);
+		quic_outq_set_retry_dcid(outq, &req->dcid);
+	}
+
+	quic_timer_start(sk, QUIC_TIMER_SACK, quic_inq_max_idle_timeout(inq));
+	quic_set_state(sk, QUIC_SS_ESTABLISHING);
+
+	__skb_queue_head_init(&tmpq);
+	skb_queue_splice_init(quic_inq_backlog_list(inq), &tmpq);
+	skb = __skb_dequeue(&tmpq);
+	while (skb) {
+		quic_packet_process(sk, skb);
+		skb = __skb_dequeue(&tmpq);
+	}
+
+out:
+	release_sock(sk);
+	return err;
+}
+
+static struct sock *quic_accept(struct sock *sk, struct proto_accept_arg *arg)
+{
+	int flags = arg->flags, *errp = &arg->err;
+	struct quic_request_sock *req = NULL;
+	struct sock *nsk = NULL;
+	bool kern = arg->kern;
+	int err = -EINVAL;
+	long timeo;
+
+	lock_sock(sk);
+
+	if (!quic_is_listen(sk))
+		goto out;
+
+	timeo = sock_rcvtimeo(sk, flags & O_NONBLOCK);
+	err = quic_wait_for_accept(sk, timeo);
+	if (err)
+		goto out;
+	req = quic_request_sock_dequeue(sk);
+
+	nsk = sk_alloc(sock_net(sk), req->sa.v4.sin_family, GFP_KERNEL, sk->sk_prot, kern);
+	if (!nsk) {
+		err = -ENOMEM;
+		goto out;
+	}
+	sock_init_data(NULL, nsk);
+	err = nsk->sk_prot->init(nsk);
+	if (err)
+		goto free;
+
+	err = quic_copy_sock(nsk, sk, req);
+	if (err)
+		goto free;
+	err = nsk->sk_prot->bind(nsk, &req->sa.sa, quic_addr_len(nsk));
+	if (err)
+		goto free;
+
+	err = quic_accept_sock_init(nsk, req);
+	if (err)
+		goto free;
+out:
+	release_sock(sk);
+	*errp = err;
+	kfree(req);
+	return nsk;
+free:
+	nsk->sk_prot->close(nsk, 0);
+	nsk = NULL;
+	goto out;
+}
+
+static void quic_close(struct sock *sk, long timeout)
+{
+	lock_sock(sk);
+
+	quic_outq_transmit_app_close(sk);
+
+	quic_set_state(sk, QUIC_SS_CLOSED);
+
+	quic_outq_free(sk);
+	quic_inq_free(sk);
+
+	quic_path_free(sk, quic_src(sk));
+	quic_path_free(sk, quic_dst(sk));
+
+	quic_conn_id_set_free(quic_source(sk));
+	quic_conn_id_set_free(quic_dest(sk));
+
+	release_sock(sk);
+	sk_common_release(sk);
+}
+
+int quic_sock_change_daddr(struct sock *sk, union quic_addr *addr, u32 len)
+{
+	struct quic_path_addr *path = quic_dst(sk);
+	u8 cnt = quic_path_sent_cnt(path);
+	struct quic_frame *frame;
+
+	if (cnt)
+		return -EINVAL;
+	quic_path_swap_active(path);
+
+	if (!addr) {
+		quic_outq_set_pref_addr(quic_outq(sk), 0);
+		goto out;
+	}
+	quic_path_addr_set(path, addr, 1);
+
+out:
+	quic_set_sk_ecn(sk, 0); /* clear ecn during path migration */
+	frame = quic_frame_create(sk, QUIC_FRAME_PATH_CHALLENGE, path);
+	if (frame)
+		quic_outq_ctrl_tail(sk, frame, false);
+
+	quic_path_pl_reset(path);
+	quic_path_set_sent_cnt(path, cnt + 1);
+	quic_timer_reset(sk, QUIC_TIMER_PATH, quic_cong_rto(quic_cong(sk)) * 3);
+	return 0;
+}
+
+int quic_sock_change_saddr(struct sock *sk, union quic_addr *addr, u32 len)
+{
+	struct quic_conn_id_set *id_set = quic_source(sk);
+	struct quic_path_addr *path = quic_src(sk);
+	struct quic_outqueue *outq = quic_outq(sk);
+	u8 cnt = quic_path_sent_cnt(path);
+	struct quic_frame *frame;
+	u64 number;
+	int err;
+
+	if (cnt)
+		return -EINVAL;
+
+	if (!addr) {
+		quic_outq_set_pref_addr(outq, 0);
+		goto out;
+	}
+
+	if (len != quic_addr_len(sk) ||
+	    quic_addr_family(sk) != addr->sa.sa_family)
+		return -EINVAL;
+
+	if (!quic_is_established(sk)) { /* set preferred address param */
+		if (!quic_is_serv(sk))
+			return -EINVAL;
+		quic_outq_set_pref_addr(outq, 1);
+		quic_path_addr_set(path, addr, 1);
+		return 0;
+	}
+
+	if (quic_conn_id_disable_active_migration(id_set))
+		return -EINVAL;
+
+	quic_path_addr_set(path, addr, 1);
+	err = quic_path_set_bind_port(sk, path, 1);
+	if (err)
+		goto err;
+	err = quic_path_set_udp_sock(sk, path, 1);
+	if (err)
+		goto err;
+
+	number = quic_conn_id_first_number(quic_source(sk)) + 1;
+	frame = quic_frame_create(sk, QUIC_FRAME_NEW_CONNECTION_ID, &number);
+	if (!frame) {
+		err = -ENOMEM;
+		goto err;
+	}
+	frame->path_alt = QUIC_PATH_ALT_SRC;
+	quic_outq_ctrl_tail(sk, frame, true);
+
+out:
+	quic_set_sk_ecn(sk, 0); /* clear ecn during path migration */
+	frame = quic_frame_create(sk, QUIC_FRAME_PATH_CHALLENGE, path);
+	if (frame) {
+		frame->path_alt = QUIC_PATH_ALT_SRC;
+		quic_outq_ctrl_tail(sk, frame, false);
+	}
+
+	quic_path_pl_reset(quic_dst(sk));
+	quic_path_set_sent_cnt(path, cnt + 1);
+	quic_timer_reset(sk, QUIC_TIMER_PATH, quic_cong_rto(quic_cong(sk)) * 3);
+	return 0;
+err:
+	quic_path_addr_free(sk, path, 1);
+	return err;
+}
+
+static int quic_sock_set_token(struct sock *sk, void *data, u32 len)
+{
+	struct quic_frame *frame;
+
+	if (quic_is_serv(sk)) {
+		frame = quic_frame_create(sk, QUIC_FRAME_NEW_TOKEN, NULL);
+		if (!frame)
+			return -ENOMEM;
+		quic_outq_ctrl_tail(sk, frame, false);
+		return 0;
+	}
+
+	if (!len || len > 120)
+		return -EINVAL;
+
+	return quic_data_dup(quic_token(sk), data, len);
+}
+
+static int quic_sock_set_session_ticket(struct sock *sk, u8 *data, u32 len)
+{
+	if (!len || len > 4096)
+		return -EINVAL;
+
+	return quic_data_dup(quic_ticket(sk), data, len);
+}
+
+static int quic_sock_set_config(struct sock *sk, struct quic_config *c, u32 len)
+{
+	struct quic_config *config = quic_config(sk);
+
+	if (len < sizeof(*config) || quic_is_established(sk))
+		return -EINVAL;
+
+	if (c->validate_peer_address)
+		config->validate_peer_address = c->validate_peer_address;
+	if (c->receive_session_ticket)
+		config->receive_session_ticket = c->receive_session_ticket;
+	if (c->certificate_request) {
+		if (c->certificate_request > 3)
+			return -EINVAL;
+		config->certificate_request = c->certificate_request;
+	}
+	if (c->initial_smoothed_rtt) {
+		if (c->initial_smoothed_rtt < QUIC_RTO_MIN ||
+		    c->initial_smoothed_rtt > QUIC_RTO_MAX)
+			return -EINVAL;
+		config->initial_smoothed_rtt = c->initial_smoothed_rtt;
+	}
+	if (c->plpmtud_probe_interval) {
+		if (c->plpmtud_probe_interval < QUIC_MIN_PROBE_TIMEOUT)
+			return -EINVAL;
+		config->plpmtud_probe_interval = c->plpmtud_probe_interval;
+	}
+	if (c->payload_cipher_type) {
+		if (c->payload_cipher_type != TLS_CIPHER_AES_GCM_128 &&
+		    c->payload_cipher_type != TLS_CIPHER_AES_GCM_256 &&
+		    c->payload_cipher_type != TLS_CIPHER_AES_CCM_128 &&
+		    c->payload_cipher_type != TLS_CIPHER_CHACHA20_POLY1305)
+			return -EINVAL;
+		config->payload_cipher_type = c->payload_cipher_type;
+	}
+	if (c->version)
+		config->version = c->version;
+
+	quic_cong_set_config(quic_cong(sk), config);
+	return 0;
+}
+
+static int quic_sock_set_transport_params_ext(struct sock *sk, u8 *p, u32 len)
+{
+	struct quic_transport_param *param = quic_remote(sk);
+	u32 errcode;
+
+	if (!quic_is_establishing(sk))
+		return -EINVAL;
+
+	if (quic_frame_set_transport_params_ext(sk, param, p, len)) {
+		errcode = QUIC_TRANSPORT_ERROR_TRANSPORT_PARAM;
+		quic_outq_transmit_close(sk, 0, errcode, QUIC_CRYPTO_INITIAL);
+		return -EINVAL;
+	}
+
+	param->remote = 1;
+	quic_outq_set_param(sk, param);
+	quic_conn_id_set_param(quic_source(sk), param);
+	quic_stream_set_param(quic_streams(sk), NULL, param);
+	return 0;
+}
+
+static int quic_sock_set_crypto_secret(struct sock *sk, struct quic_crypto_secret *secret, u32 len)
+{
+	struct quic_conn_id_set *id_set = quic_source(sk);
+	struct quic_path_addr *path = quic_src(sk);
+	struct quic_outqueue *outq = quic_outq(sk);
+	struct quic_inqueue *inq = quic_inq(sk);
+	struct quic_config *c = quic_config(sk);
+	struct quic_frame *frame, *tmp;
+	struct list_head list, *head;
+	struct quic_crypto *crypto;
+	struct sk_buff_head tmpq;
+	struct sk_buff *skb;
+	u32 window, mss;
+	int err, seqno;
+	u64 prior = 1;
+
+	if (len != sizeof(*secret))
+		return -EINVAL;
+
+	if (secret->level != QUIC_CRYPTO_APP &&
+	    secret->level != QUIC_CRYPTO_EARLY &&
+	    secret->level != QUIC_CRYPTO_HANDSHAKE)
+		return -EINVAL;
+
+	crypto = quic_crypto(sk, secret->level);
+	err = quic_crypto_set_secret(crypto, secret, c->version, 0);
+	if (err)
+		return err;
+
+	if (secret->level != QUIC_CRYPTO_APP) {
+		if (!secret->send) { /* 0rtt or handshake recv key is ready */
+			__skb_queue_head_init(&tmpq);
+			skb_queue_splice_init(quic_inq_backlog_list(inq), &tmpq);
+			skb = __skb_dequeue(&tmpq);
+			while (skb) {
+				quic_packet_process(sk, skb);
+				skb = __skb_dequeue(&tmpq);
+			}
+			return 0;
+		}
+		/* 0rtt send key is ready */
+		if (secret->level == QUIC_CRYPTO_EARLY)
+			quic_outq_set_data_level(outq, QUIC_CRYPTO_EARLY);
+		return 0;
+	}
+
+	INIT_LIST_HEAD(&list);
+	if (!secret->send) { /* app recv key is ready */
+		quic_data_free(quic_ticket(sk)); /* clean it to receive new session ticket msg */
+		quic_data_free(quic_token(sk)); /* clean it to receive new token */
+		head = quic_inq_early_list(inq);
+		if (!list_empty(head)) {
+			list_splice_init(head, quic_inq_recv_list(inq));
+			sk->sk_data_ready(sk);
+		}
+		__skb_queue_head_init(&tmpq);
+		skb_queue_splice_init(quic_inq_backlog_list(inq), &tmpq);
+		skb = __skb_dequeue(&tmpq);
+		while (skb) {
+			quic_packet_process(sk, skb);
+			skb = __skb_dequeue(&tmpq);
+		}
+		if (quic_is_serv(sk)) {
+			/* some implementations don't send ACKs to handshake packets
+			 * so ACK them manually.
+			 */
+			quic_outq_transmitted_sack(sk, QUIC_CRYPTO_INITIAL,
+						   QUIC_PN_MAP_MAX_PN, 0, 0, 0);
+			quic_outq_transmitted_sack(sk, QUIC_CRYPTO_HANDSHAKE,
+						   QUIC_PN_MAP_MAX_PN, 0, 0, 0);
+			if (quic_outq_pref_addr(outq)) {
+				err = quic_path_set_bind_port(sk, path, 1);
+				if (err)
+					return err;
+				err = quic_path_set_udp_sock(sk, path, 1);
+				if (err)
+					return err;
+			}
+			frame = quic_frame_create(sk, QUIC_FRAME_NEW_TOKEN, NULL);
+			if (!frame)
+				return -ENOMEM;
+			list_add_tail(&frame->list, &list);
+			frame = quic_frame_create(sk, QUIC_FRAME_HANDSHAKE_DONE, NULL);
+			if (!frame) {
+				quic_outq_list_purge(sk, &list);
+				return -ENOMEM;
+			}
+			list_add_tail(&frame->list, &list);
+			list_for_each_entry_safe(frame, tmp, &list, list) {
+				list_del(&frame->list);
+				quic_outq_ctrl_tail(sk, frame, true);
+			}
+			quic_outq_transmit(sk);
+		}
+
+		/* enter established only when both send and recv keys are ready */
+		if (quic_crypto_send_ready(crypto)) {
+			quic_set_state(sk, QUIC_SS_ESTABLISHED);
+			quic_timer_reset(sk, QUIC_TIMER_PATH, c->plpmtud_probe_interval);
+		}
+		return 0;
+	}
+
+	/* app send key is ready */
+	quic_outq_set_data_level(outq, QUIC_CRYPTO_APP);
+	seqno = quic_conn_id_last_number(id_set) + 1;
+	for (; seqno <= quic_conn_id_max_count(id_set); seqno++) {
+		frame = quic_frame_create(sk, QUIC_FRAME_NEW_CONNECTION_ID, &prior);
+		if (!frame) {
+			while (seqno)
+				quic_conn_id_remove(quic_source(sk), seqno--);
+			quic_outq_list_purge(sk, &list);
+			return -ENOMEM;
+		}
+		list_add_tail(&frame->list, &list);
+	}
+	list_for_each_entry_safe(frame, tmp, &list, list) {
+		list_del(&frame->list);
+		quic_outq_ctrl_tail(sk, frame, true);
+	}
+
+	mss = quic_packet_mss(quic_packet(sk));
+	window = max_t(u32, mss * 2, 14720);
+	window = min_t(u32, mss * 10, window);
+	quic_cong_set_window(quic_cong(sk), window);
+	quic_outq_sync_window(sk);
+
+	if (quic_crypto_recv_ready(crypto)) {
+		quic_set_state(sk, QUIC_SS_ESTABLISHED);
+		quic_timer_reset(sk, QUIC_TIMER_PATH, c->plpmtud_probe_interval);
+	}
+	return 0;
+}
+
+static int quic_sock_retire_conn_id(struct sock *sk, struct quic_connection_id_info *info, u8 len)
+{
+	struct quic_frame *frame;
+	u64 number, first;
+
+	if (len < sizeof(*info) || !quic_is_established(sk))
+		return -EINVAL;
+
+	if (info->source) {
+		number = info->source;
+		if (number > quic_conn_id_last_number(quic_source(sk)) ||
+		    number <= quic_conn_id_first_number(quic_source(sk)))
+			return -EINVAL;
+		frame = quic_frame_create(sk, QUIC_FRAME_NEW_CONNECTION_ID, &number);
+		if (!frame)
+			return -ENOMEM;
+		quic_outq_ctrl_tail(sk, frame, false);
+		return 0;
+	}
+
+	number = info->dest;
+	first = quic_conn_id_first_number(quic_dest(sk));
+	if (number > quic_conn_id_last_number(quic_dest(sk)) || number <= first)
+		return -EINVAL;
+
+	for (; first < number; first++) {
+		frame = quic_frame_create(sk, QUIC_FRAME_RETIRE_CONNECTION_ID, &first);
+		if (!frame)
+			return -ENOMEM;
+		quic_outq_ctrl_tail(sk, frame, first != number - 1);
+	}
+	return 0;
+}
+
+#define QUIC_ALPN_MAX_LEN	128
+
+static int quic_sock_set_alpn(struct sock *sk, u8 *data, u32 len)
+{
+	struct quic_data *alpns = quic_alpn(sk);
+	u8 *p;
+
+	if (!len || len > QUIC_ALPN_MAX_LEN || quic_is_listen(sk))
+		return -EINVAL;
+
+	p = kzalloc(len + 1, GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	kfree(alpns->data);
+	alpns->data = p;
+	alpns->len  = len + 1;
+
+	quic_data_from_string(alpns, data, len);
+	return 0;
+}
+
+static int quic_sock_stream_reset(struct sock *sk, struct quic_errinfo *info, u32 len)
+{
+	struct quic_stream_table *streams = quic_streams(sk);
+	struct quic_stream *stream;
+	struct quic_frame *frame;
+
+	if (len != sizeof(*info) || !quic_is_established(sk))
+		return -EINVAL;
+
+	stream = quic_stream_send_get(streams, info->stream_id, 0, quic_is_serv(sk));
+	if (IS_ERR(stream))
+		return PTR_ERR(stream);
+
+	if (stream->send.state > QUIC_STREAM_SEND_STATE_SENT)
+		return -EINVAL;
+
+	frame = quic_frame_create(sk, QUIC_FRAME_RESET_STREAM, info);
+	if (!frame)
+		return -ENOMEM;
+
+	stream->send.state = QUIC_STREAM_SEND_STATE_RESET_SENT;
+	quic_outq_stream_purge(sk, stream);
+	quic_outq_ctrl_tail(sk, frame, false);
+	return 0;
+}
+
+static int quic_sock_stream_stop_sending(struct sock *sk, struct quic_errinfo *info, u32 len)
+{
+	struct quic_stream_table *streams = quic_streams(sk);
+	struct quic_stream *stream;
+	struct quic_frame *frame;
+
+	if (len != sizeof(*info) || !quic_is_established(sk))
+		return -EINVAL;
+
+	stream = quic_stream_recv_get(streams, info->stream_id, quic_is_serv(sk));
+	if (IS_ERR(stream))
+		return PTR_ERR(stream);
+
+	frame = quic_frame_create(sk, QUIC_FRAME_STOP_SENDING, info);
+	if (!frame)
+		return -ENOMEM;
+
+	quic_outq_ctrl_tail(sk, frame, false);
+	return 0;
+}
+
+static int quic_sock_set_event(struct sock *sk, struct quic_event_option *event, u32 len)
+{
+	struct quic_inqueue *inq = quic_inq(sk);
+	u32 events;
+
+	if (len != sizeof(*event))
+		return -EINVAL;
+	if (!event->type || event->type > QUIC_EVENT_MAX)
+		return -EINVAL;
+
+	events = quic_inq_events(inq);
+	if (event->on) {
+		quic_inq_set_events(inq, events | (1 << (event->type)));
+		return 0;
+	}
+	quic_inq_set_events(inq, events & ~(1 << event->type));
+	return 0;
+}
+
+static int quic_sock_set_connection_close(struct sock *sk, struct quic_connection_close *close,
+					  u32 len)
+{
+	struct quic_outqueue *outq = quic_outq(sk);
+	u8 *data;
+
+	if (len < sizeof(*close))
+		return -EINVAL;
+
+	len -= sizeof(*close);
+	if (len > QUIC_CLOSE_PHRASE_MAX_LEN + 1)
+		return -EINVAL;
+
+	if (len) {
+		if (close->phrase[len - 1])
+			return -EINVAL;
+		data = kmemdup(close->phrase, len, GFP_KERNEL);
+		if (!data)
+			return -ENOMEM;
+		quic_outq_set_close_phrase(outq, data);
+	}
+
+	quic_outq_set_close_errcode(outq, close->errcode);
+	return 0;
+}
+
+static int quic_do_setsockopt(struct sock *sk, int optname, sockptr_t optval, unsigned int optlen)
+{
+	void *kopt = NULL;
+	int retval = 0;
+
+	if (optlen > 0) {
+		kopt = memdup_sockptr(optval, optlen);
+		if (IS_ERR(kopt))
+			return PTR_ERR(kopt);
+	}
+
+	lock_sock(sk);
+	switch (optname) {
+	case QUIC_SOCKOPT_EVENT:
+		retval = quic_sock_set_event(sk, kopt, optlen);
+		break;
+	case QUIC_SOCKOPT_STREAM_RESET:
+		retval = quic_sock_stream_reset(sk, kopt, optlen);
+		break;
+	case QUIC_SOCKOPT_STREAM_STOP_SENDING:
+		retval = quic_sock_stream_stop_sending(sk, kopt, optlen);
+		break;
+	case QUIC_SOCKOPT_CONNECTION_CLOSE:
+		retval = quic_sock_set_connection_close(sk, kopt, optlen);
+		break;
+	case QUIC_SOCKOPT_CONNECTION_MIGRATION:
+		retval = quic_sock_change_saddr(sk, kopt, optlen);
+		break;
+	case QUIC_SOCKOPT_KEY_UPDATE:
+		retval = quic_crypto_key_update(quic_crypto(sk, QUIC_CRYPTO_APP));
+		break;
+	case QUIC_SOCKOPT_RETIRE_CONNECTION_ID:
+		retval = quic_sock_retire_conn_id(sk, kopt, optlen);
+		break;
+	case QUIC_SOCKOPT_ALPN:
+		retval = quic_sock_set_alpn(sk, kopt, optlen);
+		break;
+	case QUIC_SOCKOPT_TOKEN:
+		retval = quic_sock_set_token(sk, kopt, optlen);
+		break;
+	case QUIC_SOCKOPT_SESSION_TICKET:
+		retval = quic_sock_set_session_ticket(sk, kopt, optlen);
+		break;
+	case QUIC_SOCKOPT_TRANSPORT_PARAM:
+		retval = quic_sock_set_transport_param(sk, kopt, optlen);
+		break;
+	case QUIC_SOCKOPT_CONFIG:
+		retval = quic_sock_set_config(sk, kopt, optlen);
+		break;
+	case QUIC_SOCKOPT_TRANSPORT_PARAM_EXT:
+		retval = quic_sock_set_transport_params_ext(sk, kopt, optlen);
+		break;
+	case QUIC_SOCKOPT_CRYPTO_SECRET:
+		retval = quic_sock_set_crypto_secret(sk, kopt, optlen);
+		break;
+	default:
+		retval = -ENOPROTOOPT;
+		break;
+	}
+	release_sock(sk);
+	kfree(kopt);
+	return retval;
+}
+
+static int quic_setsockopt(struct sock *sk, int level, int optname,
+			   sockptr_t optval, unsigned int optlen)
+{
+	if (level != SOL_QUIC)
+		return quic_af_ops(sk)->setsockopt(sk, level, optname, optval, optlen);
+
+	return quic_do_setsockopt(sk, optname, optval, optlen);
+}
+
+int quic_sock_setopt(struct sock *sk, int optname, void *optval, unsigned int optlen)
+{
+	return quic_do_setsockopt(sk, optname, KERNEL_SOCKPTR(optval), optlen);
+}
+EXPORT_SYMBOL_GPL(quic_sock_setopt);
+
+static int quic_sock_get_token(struct sock *sk, int len, sockptr_t optval, sockptr_t optlen)
+{
+	struct quic_data *token = quic_token(sk);
+
+	if (quic_is_serv(sk) || len < token->len)
+		return -EINVAL;
+	len = token->len;
+
+	if (copy_to_sockptr(optlen, &len, sizeof(len)) || copy_to_sockptr(optval, token->data, len))
+		return -EFAULT;
+	return 0;
+}
+
+static int quic_sock_get_session_ticket(struct sock *sk, int len,
+					sockptr_t optval, sockptr_t optlen)
+{
+	struct quic_crypto *crypto;
+	u32 ticket_len, addr_len;
+	union quic_addr *da;
+	u8 *ticket, key[64];
+
+	if (quic_is_serv(sk)) { /* get ticket_key for server */
+		crypto = quic_crypto(sk, QUIC_CRYPTO_INITIAL);
+		da = quic_path_addr(quic_dst(sk), 0);
+		addr_len = quic_addr_len(sk);
+		if (quic_crypto_generate_session_ticket_key(crypto, da, addr_len, key, 64))
+			return -EINVAL;
+		ticket = key;
+		ticket_len = 64;
+		goto out;
+	}
+
+	ticket_len = quic_ticket(sk)->len;
+	ticket = quic_ticket(sk)->data;
+out:
+	if (len < ticket_len)
+		return -EINVAL;
+	len = ticket_len;
+
+	if (copy_to_sockptr(optlen, &len, sizeof(len)) || copy_to_sockptr(optval, ticket, len))
+		return -EFAULT;
+	return 0;
+}
+
+static int quic_sock_get_transport_param(struct sock *sk, int len,
+					 sockptr_t optval, sockptr_t optlen)
+{
+	struct quic_transport_param param, *p = quic_local(sk);
+
+	if (len < sizeof(param))
+		return -EINVAL;
+	len = sizeof(param);
+	if (copy_from_sockptr(&param, optval, len))
+		return -EFAULT;
+
+	if (param.remote)
+		p = quic_remote(sk);
+
+	param = *p;
+	if (copy_to_sockptr(optlen, &len, sizeof(len)) || copy_to_sockptr(optval, &param, len))
+		return -EFAULT;
+	return 0;
+}
+
+static int quic_sock_get_config(struct sock *sk, int len, sockptr_t optval, sockptr_t optlen)
+{
+	struct quic_config config, *c = quic_config(sk);
+
+	if (len < sizeof(config))
+		return -EINVAL;
+	len = sizeof(config);
+
+	config = *c;
+	if (copy_to_sockptr(optlen, &len, sizeof(len)) || copy_to_sockptr(optval, &config, len))
+		return -EFAULT;
+	return 0;
+}
+
+static int quic_sock_get_transport_params_ext(struct sock *sk, int len,
+					      sockptr_t optval, sockptr_t optlen)
+{
+	struct quic_transport_param *param = quic_local(sk);
+	u8 data[256];
+	u32 datalen;
+
+	if (quic_frame_get_transport_params_ext(sk, param, data, &datalen))
+		return -EINVAL;
+	if (len < datalen)
+		return -EINVAL;
+	len = datalen;
+
+	if (copy_to_sockptr(optlen, &len, sizeof(len)) || copy_to_sockptr(optval, data, len))
+		return -EFAULT;
+	return 0;
+}
+
+static int quic_sock_get_crypto_secret(struct sock *sk, int len,
+				       sockptr_t optval, sockptr_t optlen)
+{
+	struct quic_crypto_secret secret = {};
+
+	if (len < sizeof(secret))
+		return -EINVAL;
+	len = sizeof(secret);
+	if (copy_from_sockptr(&secret, optval, len))
+		return -EFAULT;
+
+	if (secret.level >= QUIC_CRYPTO_MAX)
+		return -EINVAL;
+	if (quic_crypto_get_secret(quic_crypto(sk, secret.level), &secret))
+		return -EINVAL;
+
+	if (copy_to_sockptr(optlen, &len, sizeof(len)) || copy_to_sockptr(optval, &secret, len))
+		return -EFAULT;
+	return 0;
+}
+
+static int quic_sock_get_active_conn_id(struct sock *sk, int len,
+					sockptr_t optval, sockptr_t optlen)
+{
+	struct quic_connection_id_info info;
+	struct quic_conn_id_set *id_set;
+	struct quic_conn_id *active;
+
+	if (len < sizeof(info) || !quic_is_established(sk))
+		return -EINVAL;
+
+	len = sizeof(info);
+	id_set = quic_source(sk);
+	active = quic_conn_id_active(id_set);
+	info.source = quic_conn_id_number(active);
+
+	id_set = quic_dest(sk);
+	active = quic_conn_id_active(id_set);
+	info.dest = quic_conn_id_number(active);
+
+	if (copy_to_sockptr(optlen, &len, sizeof(len)) || copy_to_sockptr(optval, &info, len))
+		return -EFAULT;
+	return 0;
+}
+
+static int quic_sock_get_alpn(struct sock *sk, int len, sockptr_t optval, sockptr_t optlen)
+{
+	struct quic_data *alpns = quic_alpn(sk);
+	u8 data[128];
+
+	if (!alpns->len) {
+		len = 0;
+		goto out;
+	}
+	if (len < alpns->len)
+		return -EINVAL;
+
+	quic_data_to_string(data, &len, alpns);
+
+out:
+	if (copy_to_sockptr(optlen, &len, sizeof(len)) || copy_to_sockptr(optval, data, len))
+		return -EFAULT;
+	return 0;
+}
+
+static int quic_sock_stream_open(struct sock *sk, int len, sockptr_t optval, sockptr_t optlen)
+{
+	struct quic_stream_table *streams = quic_streams(sk);
+	struct quic_stream_info sinfo;
+	struct quic_stream *stream;
+
+	if (len < sizeof(sinfo))
+		return -EINVAL;
+	len = sizeof(sinfo);
+	if (copy_from_sockptr(&sinfo, optval, len))
+		return -EFAULT;
+
+	if (sinfo.stream_id == -1) {
+		sinfo.stream_id = (quic_stream_send_bidi(streams) << 2);
+		if (sinfo.stream_flags & MSG_STREAM_UNI) {
+			sinfo.stream_id = (quic_stream_send_uni(streams) << 2);
+			sinfo.stream_id |= QUIC_STREAM_TYPE_UNI_MASK;
+		}
+		sinfo.stream_id |= quic_is_serv(sk);
+	}
+	sinfo.stream_flags |= MSG_STREAM_NEW;
+
+	if (copy_to_sockptr(optlen, &len, sizeof(len)) || copy_to_sockptr(optval, &sinfo, len))
+		return -EFAULT;
+
+	stream = quic_sock_send_stream(sk, &sinfo);
+	if (IS_ERR(stream))
+		return PTR_ERR(stream);
+
+	return 0;
+}
+
+static int quic_sock_get_event(struct sock *sk, int len, sockptr_t optval, sockptr_t optlen)
+{
+	struct quic_inqueue *inq = quic_inq(sk);
+	struct quic_event_option event;
+
+	if (len < sizeof(event))
+		return -EINVAL;
+	len = sizeof(event);
+	if (copy_from_sockptr(&event, optval, len))
+		return -EFAULT;
+
+	if (!event.type || event.type > QUIC_EVENT_MAX)
+		return -EINVAL;
+	event.on = quic_inq_events(inq) & (1 << event.type);
+
+	if (copy_to_sockptr(optlen, &len, sizeof(len)) || copy_to_sockptr(optval, &event, len))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int quic_sock_get_connection_close(struct sock *sk, int len, sockptr_t optval,
+					  sockptr_t optlen)
+{
+	struct quic_outqueue *outq = quic_outq(sk);
+	struct quic_connection_close *close;
+	u8 phrase_len = 0, frame[100] = {};
+	u8 *phrase;
+
+	phrase = quic_outq_close_phrase(outq);
+	if (phrase)
+		phrase_len = strlen(phrase) + 1;
+	if (len < sizeof(close) + phrase_len)
+		return -EINVAL;
+
+	len = sizeof(close) + phrase_len;
+	close = (void *)frame;
+	close->errcode = quic_outq_close_errcode(outq);
+	close->frame = quic_outq_close_frame(outq);
+
+	if (phrase_len)
+		strscpy(close->phrase, phrase, phrase_len);
+
+	if (copy_to_sockptr(optlen, &len, sizeof(len)) || copy_to_sockptr(optval, close, len))
+		return -EFAULT;
+	return 0;
+}
+
+static int quic_do_getsockopt(struct sock *sk, int optname, sockptr_t optval, sockptr_t optlen)
+{
+	int retval = 0;
+	int len;
+
+	if (copy_from_sockptr(&len, optlen, sizeof(len)))
+		return -EFAULT;
+
+	if (len < 0)
+		return -EINVAL;
+
+	lock_sock(sk);
+	switch (optname) {
+	case QUIC_SOCKOPT_EVENT:
+		retval = quic_sock_get_event(sk, len, optval, optlen);
+		break;
+	case QUIC_SOCKOPT_STREAM_OPEN:
+		retval = quic_sock_stream_open(sk, len, optval, optlen);
+		break;
+	case QUIC_SOCKOPT_CONNECTION_CLOSE:
+		retval = quic_sock_get_connection_close(sk, len, optval, optlen);
+		break;
+	case QUIC_SOCKOPT_ACTIVE_CONNECTION_ID:
+		retval = quic_sock_get_active_conn_id(sk, len, optval, optlen);
+		break;
+	case QUIC_SOCKOPT_ALPN:
+		retval = quic_sock_get_alpn(sk, len, optval, optlen);
+		break;
+	case QUIC_SOCKOPT_TOKEN:
+		retval = quic_sock_get_token(sk, len, optval, optlen);
+		break;
+	case QUIC_SOCKOPT_SESSION_TICKET:
+		retval = quic_sock_get_session_ticket(sk, len, optval, optlen);
+		break;
+	case QUIC_SOCKOPT_TRANSPORT_PARAM:
+		retval = quic_sock_get_transport_param(sk, len, optval, optlen);
+		break;
+	case QUIC_SOCKOPT_CONFIG:
+		retval = quic_sock_get_config(sk, len, optval, optlen);
+		break;
+	case QUIC_SOCKOPT_TRANSPORT_PARAM_EXT:
+		retval = quic_sock_get_transport_params_ext(sk, len, optval, optlen);
+		break;
+	case QUIC_SOCKOPT_CRYPTO_SECRET:
+		retval = quic_sock_get_crypto_secret(sk, len, optval, optlen);
+		break;
+	default:
+		retval = -ENOPROTOOPT;
+		break;
+	}
+	release_sock(sk);
+	return retval;
+}
+
+static int quic_getsockopt(struct sock *sk, int level, int optname,
+			   char __user *optval, int __user *optlen)
+{
+	if (level != SOL_QUIC)
+		return quic_af_ops(sk)->getsockopt(sk, level, optname, optval, optlen);
+
+	return quic_do_getsockopt(sk, optname, USER_SOCKPTR(optval), USER_SOCKPTR(optlen));
+}
+
+int quic_sock_getopt(struct sock *sk, int optname, void *optval, unsigned int *optlen)
+{
+	return quic_do_getsockopt(sk, optname, KERNEL_SOCKPTR(optval), KERNEL_SOCKPTR(optlen));
+}
+EXPORT_SYMBOL_GPL(quic_sock_getopt);
+
+static void quic_release_cb(struct sock *sk)
+{
+	/* similar to tcp_release_cb */
+	unsigned long nflags, flags = smp_load_acquire(&sk->sk_tsq_flags);
+
+	do {
+		if (!(flags & QUIC_DEFERRED_ALL))
+			return;
+		nflags = flags & ~QUIC_DEFERRED_ALL;
+	} while (!try_cmpxchg(&sk->sk_tsq_flags, &flags, nflags));
+
+	if (flags & QUIC_F_MTU_REDUCED_DEFERRED) {
+		quic_rcv_err_icmp(sk);
+		__sock_put(sk);
+	}
+	if (flags & QUIC_F_AP_LOSS_DEFERRED) {
+		quic_timer_loss_handler(sk, QUIC_TIMER_AP_LOSS);
+		__sock_put(sk);
+	}
+	if (flags & QUIC_F_IN_LOSS_DEFERRED) {
+		quic_timer_loss_handler(sk, QUIC_TIMER_IN_LOSS);
+		__sock_put(sk);
+	}
+	if (flags & QUIC_F_HS_LOSS_DEFERRED) {
+		quic_timer_loss_handler(sk, QUIC_TIMER_HS_LOSS);
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
+	if (flags & QUIC_F_TSQ_DEFERRED) {
+		quic_timer_pace_handler(sk);
+		__sock_put(sk);
+	}
+}
+
+static int quic_disconnect(struct sock *sk, int flags)
+{
+	quic_set_state(sk, QUIC_SS_CLOSED); /* for a listen socket only */
+	return 0;
+}
+
+static void quic_shutdown(struct sock *sk, int how)
+{
+	if (!(how & SEND_SHUTDOWN))
+		goto out;
+
+	quic_outq_transmit_app_close(sk);
+out:
+	quic_set_state(sk, QUIC_SS_CLOSED);
+}
+
+struct proto quic_prot = {
+	.name		=  "QUIC",
+	.owner		=  THIS_MODULE,
+	.init		=  quic_init_sock,
+	.destroy	=  quic_destroy_sock,
+	.shutdown	=  quic_shutdown,
+	.setsockopt	=  quic_setsockopt,
+	.getsockopt	=  quic_getsockopt,
+	.connect	=  quic_connect,
+	.bind		=  quic_bind,
+	.close		=  quic_close,
+	.disconnect	=  quic_disconnect,
+	.sendmsg	=  quic_sendmsg,
+	.recvmsg	=  quic_recvmsg,
+	.accept		=  quic_accept,
+	.hash		=  quic_hash,
+	.unhash		=  quic_unhash,
+	.backlog_rcv	=  quic_packet_process,
+	.release_cb	=  quic_release_cb,
+	.no_autobind	=  true,
+	.obj_size	=  sizeof(struct quic_sock),
+	.sysctl_mem		=  sysctl_quic_mem,
+	.sysctl_rmem		=  sysctl_quic_rmem,
+	.sysctl_wmem		=  sysctl_quic_wmem,
+	.memory_pressure	=  &quic_memory_pressure,
+	.enter_memory_pressure	=  quic_enter_memory_pressure,
+	.memory_allocated	=  &quic_memory_allocated,
+	.per_cpu_fw_alloc	=  &quic_memory_per_cpu_fw_alloc,
+	.sockets_allocated	=  &quic_sockets_allocated,
+};
+
+struct proto quicv6_prot = {
+	.name		=  "QUICv6",
+	.owner		=  THIS_MODULE,
+	.init		=  quic_init_sock,
+	.destroy	=  quic_destroy_sock,
+	.shutdown	=  quic_shutdown,
+	.setsockopt	=  quic_setsockopt,
+	.getsockopt	=  quic_getsockopt,
+	.connect	=  quic_connect,
+	.bind		=  quic_bind,
+	.close		=  quic_close,
+	.disconnect	=  quic_disconnect,
+	.sendmsg	=  quic_sendmsg,
+	.recvmsg	=  quic_recvmsg,
+	.accept		=  quic_accept,
+	.hash		=  quic_hash,
+	.unhash		=  quic_unhash,
+	.backlog_rcv	=  quic_packet_process,
+	.release_cb	=  quic_release_cb,
+	.no_autobind	=  true,
+	.obj_size	= sizeof(struct quic6_sock),
+	.ipv6_pinfo_offset	=  offsetof(struct quic6_sock, inet6),
+	.sysctl_mem		=  sysctl_quic_mem,
+	.sysctl_rmem		=  sysctl_quic_rmem,
+	.sysctl_wmem		=  sysctl_quic_wmem,
+	.memory_pressure	=  &quic_memory_pressure,
+	.enter_memory_pressure	=  quic_enter_memory_pressure,
+	.memory_allocated	=  &quic_memory_allocated,
+	.per_cpu_fw_alloc	=  &quic_memory_per_cpu_fw_alloc,
+	.sockets_allocated	=  &quic_sockets_allocated,
+};
diff --git a/net/quic/socket.h b/net/quic/socket.h
new file mode 100644
index 000000000000..473f349f323f
--- /dev/null
+++ b/net/quic/socket.h
@@ -0,0 +1,267 @@
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
+#ifndef __net_quic_h__
+#define __net_quic_h__
+
+#include <net/udp_tunnel.h>
+#include <linux/quic.h>
+
+#include "hashtable.h"
+#include "protocol.h"
+#include "pnspace.h"
+#include "number.h"
+#include "connid.h"
+#include "stream.h"
+#include "crypto.h"
+#include "frame.h"
+#include "cong.h"
+#include "path.h"
+
+#include "packet.h"
+#include "output.h"
+#include "input.h"
+#include "timer.h"
+
+extern struct proto quic_prot;
+extern struct proto quicv6_prot;
+
+extern struct proto quic_handshake_prot;
+extern struct proto quicv6_handshake_prot;
+
+enum quic_state {
+	QUIC_SS_CLOSED		= TCP_CLOSE,
+	QUIC_SS_LISTENING	= TCP_LISTEN,
+	QUIC_SS_ESTABLISHING	= TCP_SYN_RECV,
+	QUIC_SS_ESTABLISHED	= TCP_ESTABLISHED,
+};
+
+struct quic_request_sock {
+	struct list_head	list;
+	union quic_addr		da;
+	union quic_addr		sa;
+	struct quic_conn_id	dcid;
+	struct quic_conn_id	scid;
+	struct quic_conn_id	orig_dcid;
+	u8			retry;
+	u32			version;
+};
+
+enum quic_tsq_enum {
+	QUIC_MTU_REDUCED_DEFERRED,
+	QUIC_AP_LOSS_DEFERRED,
+	QUIC_IN_LOSS_DEFERRED,
+	QUIC_HS_LOSS_DEFERRED,
+	QUIC_SACK_DEFERRED,
+	QUIC_PATH_DEFERRED,
+	QUIC_TSQ_DEFERRED,
+};
+
+enum quic_tsq_flags {
+	QUIC_F_MTU_REDUCED_DEFERRED	= BIT(QUIC_MTU_REDUCED_DEFERRED),
+	QUIC_F_AP_LOSS_DEFERRED		= BIT(QUIC_AP_LOSS_DEFERRED),
+	QUIC_F_IN_LOSS_DEFERRED		= BIT(QUIC_IN_LOSS_DEFERRED),
+	QUIC_F_HS_LOSS_DEFERRED		= BIT(QUIC_HS_LOSS_DEFERRED),
+	QUIC_F_SACK_DEFERRED		= BIT(QUIC_SACK_DEFERRED),
+	QUIC_F_PATH_DEFERRED		= BIT(QUIC_PATH_DEFERRED),
+	QUIC_F_TSQ_DEFERRED		= BIT(QUIC_TSQ_DEFERRED),
+};
+
+#define QUIC_DEFERRED_ALL (QUIC_F_MTU_REDUCED_DEFERRED |	\
+			   QUIC_F_AP_LOSS_DEFERRED |		\
+			   QUIC_F_IN_LOSS_DEFERRED |		\
+			   QUIC_F_HS_LOSS_DEFERRED |		\
+			   QUIC_F_SACK_DEFERRED |		\
+			   QUIC_F_PATH_DEFERRED |		\
+			   QUIC_F_TSQ_DEFERRED)
+
+struct quic_sock {
+	struct inet_sock		inet;
+	struct list_head		reqs;
+	struct quic_path_src		src;
+	struct quic_path_dst		dst;
+	struct quic_addr_family_ops	*af_ops; /* inet4 or inet6 */
+
+	struct quic_conn_id_set		source;
+	struct quic_conn_id_set		dest;
+	struct quic_stream_table	streams;
+	struct quic_cong		cong;
+	struct quic_crypto		crypto[QUIC_CRYPTO_MAX];
+	struct quic_pnspace		space[QUIC_PNSPACE_MAX];
+
+	struct quic_transport_param	local;
+	struct quic_transport_param	remote;
+	struct quic_config		config;
+	struct quic_data		token;
+	struct quic_data		ticket;
+	struct quic_data		alpn;
+
+	struct quic_outqueue		outq;
+	struct quic_inqueue		inq;
+	struct quic_packet		packet;
+	struct quic_timer		timers[QUIC_TIMER_MAX];
+};
+
+struct quic6_sock {
+	struct quic_sock	quic;
+	struct ipv6_pinfo	inet6;
+};
+
+static inline struct quic_sock *quic_sk(const struct sock *sk)
+{
+	return (struct quic_sock *)sk;
+}
+
+static inline void quic_set_af_ops(struct sock *sk, struct quic_addr_family_ops *af_ops)
+{
+	quic_sk(sk)->af_ops = af_ops;
+}
+
+static inline struct quic_addr_family_ops *quic_af_ops(const struct sock *sk)
+{
+	return quic_sk(sk)->af_ops;
+}
+
+static inline struct quic_path_addr *quic_src(const struct sock *sk)
+{
+	return &quic_sk(sk)->src.a;
+}
+
+static inline struct quic_path_addr *quic_dst(const struct sock *sk)
+{
+	return &quic_sk(sk)->dst.a;
+}
+
+static inline struct quic_packet *quic_packet(const struct sock *sk)
+{
+	return &quic_sk(sk)->packet;
+}
+
+static inline struct quic_outqueue *quic_outq(const struct sock *sk)
+{
+	return &quic_sk(sk)->outq;
+}
+
+static inline struct quic_inqueue *quic_inq(const struct sock *sk)
+{
+	return &quic_sk(sk)->inq;
+}
+
+static inline struct quic_cong *quic_cong(const struct sock *sk)
+{
+	return &quic_sk(sk)->cong;
+}
+
+static inline struct quic_crypto *quic_crypto(const struct sock *sk, u8 level)
+{
+	return &quic_sk(sk)->crypto[level];
+}
+
+static inline struct quic_pnspace *quic_pnspace(const struct sock *sk, u8 level)
+{
+	return &quic_sk(sk)->space[level];
+}
+
+static inline struct quic_stream_table *quic_streams(const struct sock *sk)
+{
+	return &quic_sk(sk)->streams;
+}
+
+static inline void *quic_timer(const struct sock *sk, u8 type)
+{
+	return (void *)&quic_sk(sk)->timers[type];
+}
+
+static inline struct list_head *quic_reqs(const struct sock *sk)
+{
+	return &quic_sk(sk)->reqs;
+}
+
+static inline struct quic_config *quic_config(const struct sock *sk)
+{
+	return &quic_sk(sk)->config;
+}
+
+static inline struct quic_data *quic_token(const struct sock *sk)
+{
+	return &quic_sk(sk)->token;
+}
+
+static inline struct quic_data *quic_ticket(const struct sock *sk)
+{
+	return &quic_sk(sk)->ticket;
+}
+
+static inline struct quic_data *quic_alpn(const struct sock *sk)
+{
+	return &quic_sk(sk)->alpn;
+}
+
+static inline struct quic_conn_id_set *quic_source(const struct sock *sk)
+{
+	return &quic_sk(sk)->source;
+}
+
+static inline struct quic_conn_id_set *quic_dest(const struct sock *sk)
+{
+	return &quic_sk(sk)->dest;
+}
+
+static inline struct quic_transport_param *quic_local(const struct sock *sk)
+{
+	return &quic_sk(sk)->local;
+}
+
+static inline struct quic_transport_param *quic_remote(const struct sock *sk)
+{
+	return &quic_sk(sk)->remote;
+}
+
+static inline bool quic_is_serv(const struct sock *sk)
+{
+	return quic_outq(sk)->serv;
+}
+
+static inline bool quic_is_establishing(struct sock *sk)
+{
+	return sk->sk_state == QUIC_SS_ESTABLISHING;
+}
+
+static inline bool quic_is_established(struct sock *sk)
+{
+	return sk->sk_state == QUIC_SS_ESTABLISHED;
+}
+
+static inline bool quic_is_listen(struct sock *sk)
+{
+	return sk->sk_state == QUIC_SS_LISTENING;
+}
+
+static inline bool quic_is_closed(struct sock *sk)
+{
+	return sk->sk_state == QUIC_SS_CLOSED;
+}
+
+static inline void quic_set_state(struct sock *sk, int state)
+{
+	inet_sk_set_state(sk, state);
+	sk->sk_state_change(sk);
+}
+
+struct sock *quic_sock_lookup(struct sk_buff *skb, union quic_addr *sa, union quic_addr *da);
+int quic_request_sock_enqueue(struct sock *sk, struct quic_conn_id *odcid, u8 retry);
+struct quic_request_sock *quic_request_sock_dequeue(struct sock *sk);
+int quic_accept_sock_exists(struct sock *sk, struct sk_buff *skb);
+bool quic_request_sock_exists(struct sock *sk);
+
+int quic_sock_change_saddr(struct sock *sk, union quic_addr *addr, u32 len);
+int quic_sock_change_daddr(struct sock *sk, union quic_addr *addr, u32 len);
+
+#endif /* __net_quic_h__ */
diff --git a/net/quic/stream.c b/net/quic/stream.c
new file mode 100644
index 000000000000..0d571a7c96b5
--- /dev/null
+++ b/net/quic/stream.c
@@ -0,0 +1,252 @@
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
+#include <uapi/linux/quic.h>
+#include <net/netns/hash.h>
+#include <linux/jhash.h>
+#include <net/sock.h>
+
+#include "hashtable.h"
+#include "connid.h"
+#include "stream.h"
+#include "crypto.h"
+#include "frame.h"
+
+#define QUIC_STREAM_TYPE_CLIENT_BI	0x00
+#define QUIC_STREAM_TYPE_SERVER_BI	0x01
+#define QUIC_STREAM_TYPE_CLIENT_UNI	0x02
+#define QUIC_STREAM_TYPE_SERVER_UNI	0x03
+
+struct quic_stream *quic_stream_find(struct quic_stream_table *streams, u64 stream_id)
+{
+	struct quic_hash_head *head = quic_stream_head(&streams->ht, stream_id);
+	struct quic_stream *stream;
+
+	hlist_for_each_entry(stream, &head->head, node) {
+		if (stream->id == stream_id)
+			break;
+	}
+	return stream;
+}
+
+static bool quic_stream_id_is_send(u64 stream_id, bool is_serv)
+{
+	u8 type = (stream_id & QUIC_STREAM_TYPE_MASK);
+
+	if (is_serv) {
+		if (type == QUIC_STREAM_TYPE_CLIENT_UNI)
+			return false;
+	} else if (type == QUIC_STREAM_TYPE_SERVER_UNI) {
+		return false;
+	}
+	return true;
+}
+
+static struct quic_stream *quic_stream_add(struct quic_stream_table *streams, u64 stream_id,
+					   u8 is_serv)
+{
+	struct quic_hash_head *head;
+	struct quic_stream *stream;
+
+	stream = kzalloc(sizeof(*stream), GFP_ATOMIC);
+	if (!stream)
+		return NULL;
+
+	stream->id = stream_id;
+	if (stream_id & QUIC_STREAM_TYPE_UNI_MASK) {
+		stream->send.window = streams->send.max_stream_data_uni;
+		stream->recv.window = streams->recv.max_stream_data_uni;
+		stream->send.max_bytes = stream->send.window;
+		stream->recv.max_bytes = stream->recv.window;
+
+		if (quic_stream_id_is_send(stream_id, is_serv) &&
+		    streams->send.streams_uni <= (stream_id >> 2))
+			streams->send.streams_uni = (stream_id >> 2) + 1;
+		goto out;
+	}
+
+	if (streams->send.streams_bidi <= (stream_id >> 2))
+		streams->send.streams_bidi = (stream_id >> 2) + 1;
+	if (is_serv ^ !(stream_id & QUIC_STREAM_TYPE_SERVER_MASK)) {
+		stream->send.window = streams->send.max_stream_data_bidi_remote;
+		stream->recv.window = streams->recv.max_stream_data_bidi_local;
+	} else {
+		stream->send.window = streams->send.max_stream_data_bidi_local;
+		stream->recv.window = streams->recv.max_stream_data_bidi_remote;
+	}
+	stream->send.max_bytes = stream->send.window;
+	stream->recv.max_bytes = stream->recv.window;
+out:
+	head = quic_stream_head(&streams->ht, stream_id);
+	hlist_add_head(&stream->node, &head->head);
+	return stream;
+}
+
+int quic_stream_init(struct quic_stream_table *streams)
+{
+	struct quic_hash_table *ht = &streams->ht;
+	struct quic_hash_head *head;
+	int i, size = 16;
+
+	head = kmalloc_array(size, sizeof(*head), GFP_KERNEL);
+	if (!head)
+		return -ENOMEM;
+	for (i = 0; i < size; i++) {
+		spin_lock_init(&head[i].lock);
+		INIT_HLIST_HEAD(&head[i].head);
+	}
+	ht->size = size;
+	ht->hash = head;
+	return 0;
+}
+
+void quic_stream_free(struct quic_stream_table *streams)
+{
+	struct quic_hash_table *ht = &streams->ht;
+	struct quic_hash_head *head;
+	struct quic_stream *stream;
+	struct hlist_node *tmp;
+	int i;
+
+	for (i = 0; i < ht->size; i++) {
+		head = &ht->hash[i];
+		hlist_for_each_entry_safe(stream, tmp, &head->head, node) {
+			hlist_del_init(&stream->node);
+			kfree(stream);
+		}
+	}
+	kfree(ht->hash);
+}
+
+void quic_stream_set_param(struct quic_stream_table *streams, struct quic_transport_param *local,
+			   struct quic_transport_param *remote)
+{
+	if (remote) {
+		streams->send.max_stream_data_bidi_local = remote->max_stream_data_bidi_local;
+		streams->send.max_stream_data_bidi_remote = remote->max_stream_data_bidi_remote;
+		streams->send.max_stream_data_uni = remote->max_stream_data_uni;
+		streams->send.max_streams_bidi = remote->max_streams_bidi;
+		streams->send.max_streams_uni = remote->max_streams_uni;
+		streams->send.stream_active = -1;
+	}
+
+	if (local) {
+		streams->recv.max_stream_data_bidi_local = local->max_stream_data_bidi_local;
+		streams->recv.max_stream_data_bidi_remote = local->max_stream_data_bidi_remote;
+		streams->recv.max_stream_data_uni = local->max_stream_data_uni;
+		streams->recv.max_streams_bidi = local->max_streams_bidi;
+		streams->recv.max_streams_uni = local->max_streams_uni;
+	}
+}
+
+static bool quic_stream_id_is_recv(u64 stream_id, bool is_serv)
+{
+	u8 type = (stream_id & QUIC_STREAM_TYPE_MASK);
+
+	if (is_serv) {
+		if (type == QUIC_STREAM_TYPE_SERVER_UNI)
+			return false;
+	} else if (type == QUIC_STREAM_TYPE_CLIENT_UNI) {
+		return false;
+	}
+	return true;
+}
+
+bool quic_stream_id_send_exceeds(struct quic_stream_table *streams, u64 stream_id)
+{
+	if (stream_id & QUIC_STREAM_TYPE_UNI_MASK) {
+		if ((stream_id >> 2) >= streams->send.max_streams_uni)
+			return true;
+	} else {
+		if ((stream_id >> 2) >= streams->send.max_streams_bidi)
+			return true;
+	}
+	return false;
+}
+
+static bool quic_stream_id_recv_exceeds(struct quic_stream_table *streams, u64 stream_id)
+{
+	if (stream_id & QUIC_STREAM_TYPE_UNI_MASK) {
+		if ((stream_id >> 2) >= streams->recv.max_streams_uni)
+			return true;
+	} else {
+		if ((stream_id >> 2) >= streams->recv.max_streams_bidi)
+			return true;
+	}
+	return false;
+}
+
+static bool quic_stream_id_send_allowed(u64 stream_id, bool is_serv)
+{
+	u8 type = (stream_id & QUIC_STREAM_TYPE_MASK);
+
+	if (is_serv) {
+		if (type == QUIC_STREAM_TYPE_CLIENT_BI)
+			return false;
+	} else {
+		if (type == QUIC_STREAM_TYPE_SERVER_BI)
+			return false;
+	}
+	return true;
+}
+
+struct quic_stream *quic_stream_send_get(struct quic_stream_table *streams, u64 stream_id,
+					 u32 flags, bool is_serv)
+{
+	struct quic_stream *stream;
+
+	if (!quic_stream_id_is_send(stream_id, is_serv))
+		return ERR_PTR(-EINVAL);
+
+	stream = quic_stream_find(streams, stream_id);
+	if (stream) {
+		if (flags & MSG_STREAM_NEW)
+			return ERR_PTR(-EINVAL);
+		return stream;
+	}
+
+	if (!(flags & MSG_STREAM_NEW))
+		return ERR_PTR(-EINVAL);
+
+	if (!quic_stream_id_send_allowed(stream_id, is_serv))
+		return ERR_PTR(-EINVAL);
+
+	if (quic_stream_id_send_exceeds(streams, stream_id))
+		return ERR_PTR(-EAGAIN);
+
+	stream = quic_stream_add(streams, stream_id, is_serv);
+	if (!stream)
+		return ERR_PTR(-ENOMEM);
+	streams->send.stream_active = stream_id;
+	return stream;
+}
+
+struct quic_stream *quic_stream_recv_get(struct quic_stream_table *streams, u64 stream_id,
+					 bool is_serv)
+{
+	struct quic_stream *stream;
+
+	if (!quic_stream_id_is_recv(stream_id, is_serv))
+		return ERR_PTR(-EINVAL);
+
+	stream = quic_stream_find(streams, stream_id);
+	if (stream)
+		return stream;
+
+	if (quic_stream_id_recv_exceeds(streams, stream_id))
+		return ERR_PTR(-EAGAIN);
+
+	stream = quic_stream_add(streams, stream_id, is_serv);
+	if (!stream)
+		return ERR_PTR(-ENOMEM);
+	return stream;
+}
diff --git a/net/quic/stream.h b/net/quic/stream.h
new file mode 100644
index 000000000000..aae8cf1242ff
--- /dev/null
+++ b/net/quic/stream.h
@@ -0,0 +1,150 @@
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
+#define QUIC_STREAM_BIT_FIN	0x01
+#define QUIC_STREAM_BIT_LEN	0x02
+#define QUIC_STREAM_BIT_OFF	0x04
+#define QUIC_STREAM_BIT_MASK	0x08
+
+#define QUIC_DEF_STREAMS	100
+#define QUIC_MAX_STREAMS	BIT_ULL(60)
+
+struct quic_stream {
+	struct hlist_node node;
+	u64 id;
+	struct {
+		u64 last_max_bytes;
+		u64 max_bytes;
+		u64 window; /* congestion control in stream level? not now */
+		u64 offset;
+		u64 bytes;
+
+		u32 errcode;
+		u32 frags;
+		u8 state;
+
+		u8 data_blocked;
+	} send;
+	struct {
+		u64 max_bytes;
+		u64 highest;
+		u64 finalsz;
+		u64 window;
+		u64 offset;
+		u64 bytes;
+
+		u32 frags;
+		u8 state;
+	} recv;
+};
+
+struct quic_stream_table {
+	struct quic_hash_table ht;
+
+	struct {
+		u64 max_stream_data_bidi_remote;
+		u64 max_stream_data_bidi_local;
+		u64 max_stream_data_uni;
+		u64 max_streams_bidi;
+		u64 max_streams_uni;
+		u64 stream_active;
+		u64 streams_bidi;
+		u64 streams_uni;
+	} send;
+	struct {
+		u64 max_stream_data_bidi_remote;
+		u64 max_stream_data_bidi_local;
+		u64 max_stream_data_uni;
+		u64 max_streams_bidi;
+		u64 max_streams_uni;
+	} recv;
+};
+
+static inline u64 quic_stream_send_active(struct quic_stream_table *streams)
+{
+	return streams->send.stream_active;
+}
+
+static inline void quic_stream_set_send_active(struct quic_stream_table *streams, u64 active)
+{
+	streams->send.stream_active = active;
+}
+
+static inline u64 quic_stream_send_max_bidi(struct quic_stream_table *streams)
+{
+	return streams->send.max_streams_bidi;
+}
+
+static inline void quic_stream_set_send_max_bidi(struct quic_stream_table *streams, u64 max)
+{
+	streams->send.max_streams_bidi = max;
+}
+
+static inline u64 quic_stream_send_max_uni(struct quic_stream_table *streams)
+{
+	return streams->send.max_streams_uni;
+}
+
+static inline void quic_stream_set_send_max_uni(struct quic_stream_table *streams, u64 max)
+{
+	streams->send.max_streams_uni = max;
+}
+
+static inline u64 quic_stream_send_bidi(struct quic_stream_table *streams)
+{
+	return streams->send.streams_bidi;
+}
+
+static inline void quic_stream_set_send_bidi(struct quic_stream_table *streams, u64 bidi)
+{
+	streams->send.streams_bidi = bidi;
+}
+
+static inline u64 quic_stream_send_uni(struct quic_stream_table *streams)
+{
+	return streams->send.streams_uni;
+}
+
+static inline void quic_stream_set_send_uni(struct quic_stream_table *streams, u64 uni)
+{
+	streams->send.streams_uni = uni;
+}
+
+static inline u64 quic_stream_recv_max_uni(struct quic_stream_table *streams)
+{
+	return streams->recv.max_streams_uni;
+}
+
+static inline void quic_stream_set_recv_max_uni(struct quic_stream_table *streams, u64 max)
+{
+	streams->recv.max_streams_uni = max;
+}
+
+static inline u64 quic_stream_recv_max_bidi(struct quic_stream_table *streams)
+{
+	return streams->recv.max_streams_bidi;
+}
+
+static inline void quic_stream_set_recv_max_bidi(struct quic_stream_table *streams, u64 max)
+{
+	streams->recv.max_streams_bidi = max;
+}
+
+struct quic_stream *quic_stream_send_get(struct quic_stream_table *streams, u64 stream_id,
+					 u32 flags, bool is_serv);
+struct quic_stream *quic_stream_recv_get(struct quic_stream_table *streams, u64 stream_id,
+					 bool is_serv);
+struct quic_stream *quic_stream_find(struct quic_stream_table *streams, u64 stream_id);
+bool quic_stream_id_send_exceeds(struct quic_stream_table *streams, u64 stream_id);
+
+void quic_stream_set_param(struct quic_stream_table *streams, struct quic_transport_param *local,
+			   struct quic_transport_param *remote);
+void quic_stream_free(struct quic_stream_table *streams);
+int quic_stream_init(struct quic_stream_table *streams);
diff --git a/net/quic/test/sample_test.c b/net/quic/test/sample_test.c
new file mode 100644
index 000000000000..e7e4fd653455
--- /dev/null
+++ b/net/quic/test/sample_test.c
@@ -0,0 +1,615 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* QUIC kernel implementation
+ * (C) Copyright Red Hat Corp. 2023
+ *
+ * This file is kernel test of the QUIC kernel implementation
+ *
+ * Initialization/cleanup for QUIC protocol support.
+ *
+ * Written or modified by:
+ *    Xin Long <lucien.xin@gmail.com>
+ */
+
+#include <linux/completion.h>
+#include <linux/module.h>
+#include <linux/socket.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/quic.h>
+#include <linux/inet.h>
+#include <linux/net.h>
+#include <linux/key.h>
+
+#include <net/handshake.h>
+#include <net/sock.h>
+
+#define ROLE_LEN	10
+#define IP_LEN		20
+#define ALPN_LEN	20
+
+static char role[ROLE_LEN] = "client";
+static char alpn[ALPN_LEN] = "sample";
+static char ip[IP_LEN] = "127.0.0.1";
+static int port = 1234;
+static int psk;
+
+static u8 session_data[4096];
+static u8 token[256];
+
+static int quic_test_recvmsg(struct socket *sock, void *msg, int len, s64 *sid, int *flags)
+{
+	char incmsg[CMSG_SPACE(sizeof(struct quic_stream_info))];
+	struct quic_stream_info *rinfo = CMSG_DATA(incmsg);
+	struct msghdr inmsg;
+	struct kvec iov;
+	int error;
+
+	iov.iov_base = msg;
+	iov.iov_len = len;
+
+	memset(&inmsg, 0, sizeof(inmsg));
+	inmsg.msg_control = incmsg;
+	inmsg.msg_controllen = sizeof(incmsg);
+
+	error = kernel_recvmsg(sock, &inmsg, &iov, 1, len, *flags);
+	if (error < 0)
+		return error;
+
+	if (!sid)
+		return error;
+
+	*sid = rinfo->stream_id;
+	*flags = rinfo->stream_flags | inmsg.msg_flags;
+	return error;
+}
+
+static int quic_test_sendmsg(struct socket *sock, const void *msg, int len, s64 sid, int flags)
+{
+	char outcmsg[CMSG_SPACE(sizeof(struct quic_stream_info))];
+	struct quic_stream_info *sinfo;
+	struct msghdr outmsg;
+	struct cmsghdr *cmsg;
+	struct kvec iov;
+
+	iov.iov_base = (void *)msg;
+	iov.iov_len = len;
+
+	memset(&outmsg, 0, sizeof(outmsg));
+	outmsg.msg_control = outcmsg;
+	outmsg.msg_controllen = sizeof(outcmsg);
+	outmsg.msg_flags = flags;
+
+	cmsg = CMSG_FIRSTHDR(&outmsg);
+	cmsg->cmsg_level = IPPROTO_QUIC;
+	cmsg->cmsg_type = 0;
+	cmsg->cmsg_len = CMSG_LEN(sizeof(struct quic_stream_info));
+
+	outmsg.msg_controllen = cmsg->cmsg_len;
+	sinfo = (struct quic_stream_info *)CMSG_DATA(cmsg);
+	memset(sinfo, 0, sizeof(struct quic_stream_info));
+	sinfo->stream_id = sid;
+	sinfo->stream_flags = flags;
+
+	return kernel_sendmsg(sock, &outmsg, &iov, 1, len);
+}
+
+struct quic_test_priv {
+	struct completion sk_handshake_done;
+	struct file *filp;
+	int status;
+};
+
+static void quic_test_handshake_done(void *data, int status, key_serial_t peerid)
+{
+	struct quic_test_priv *priv = data;
+
+	priv->status = status;
+	complete_all(&priv->sk_handshake_done);
+}
+
+static int quic_test_client_handshake(struct socket *sock, struct quic_test_priv *priv)
+{
+	struct tls_handshake_args args = {};
+	int err;
+
+	init_completion(&priv->sk_handshake_done);
+
+	args.ta_sock = sock;
+	args.ta_done = quic_test_handshake_done;
+	args.ta_data = priv;
+	args.ta_timeout_ms = 3000;
+
+	if (psk) {
+		args.ta_my_peerids[0] = psk;
+		args.ta_num_peerids = 1;
+		err = tls_client_hello_psk(&args, GFP_KERNEL);
+		if (err)
+			return err;
+		goto wait;
+	}
+
+	args.ta_peername = "server.test";
+	err = tls_client_hello_x509(&args, GFP_KERNEL);
+	if (err)
+		return err;
+wait:
+	err = wait_for_completion_interruptible_timeout(&priv->sk_handshake_done, 5 * HZ);
+	if (err <= 0) {
+		tls_handshake_cancel(sock->sk);
+		return -EINVAL;
+	}
+	return priv->status;
+}
+
+static int quic_test_server_handshake(struct socket *sock, struct quic_test_priv *priv)
+{
+	struct tls_handshake_args args = {};
+	int err;
+
+	init_completion(&priv->sk_handshake_done);
+
+	args.ta_sock = sock;
+	args.ta_done = quic_test_handshake_done;
+	args.ta_data = priv;
+	args.ta_timeout_ms = 3000;
+
+	if (psk) {
+		err = tls_server_hello_psk(&args, GFP_KERNEL);
+		if (err)
+			return err;
+		goto wait;
+	}
+
+	err = tls_server_hello_x509(&args, GFP_KERNEL);
+	if (err)
+		return err;
+wait:
+	err = wait_for_completion_interruptible_timeout(&priv->sk_handshake_done, 5 * HZ);
+	if (err <= 0) {
+		tls_handshake_cancel(sock->sk);
+		return -EINVAL;
+	}
+	return priv->status;
+}
+
+static int quic_test_do_ticket_client(void)
+{
+	unsigned int param_len, token_len, ticket_len;
+	struct quic_transport_param param = {};
+	struct sockaddr_in ra = {}, la = {};
+	struct quic_test_priv priv = {};
+	struct quic_config config = {};
+	struct socket *sock;
+	int err, flags = 0;
+	char msg[64];
+	s64 sid;
+
+	err = __sock_create(&init_net, PF_INET, SOCK_DGRAM, IPPROTO_QUIC, &sock, 1);
+	if (err < 0)
+		return err;
+	priv.filp = sock_alloc_file(sock, 0, NULL);
+	if (IS_ERR(priv.filp))
+		return PTR_ERR(priv.filp);
+	err = quic_sock_setopt(sock->sk, QUIC_SOCKOPT_ALPN, alpn, strlen(alpn));
+	if (err)
+		goto free;
+
+	config.receive_session_ticket = 1;
+	err = quic_sock_setopt(sock->sk, QUIC_SOCKOPT_CONFIG, &config, sizeof(config));
+	if (err)
+		goto free;
+
+	ra.sin_family = AF_INET;
+	ra.sin_port = htons((u16)port);
+	if (!in4_pton(ip, strlen(ip), (u8 *)&ra.sin_addr.s_addr, -1, NULL))
+		goto free;
+	err = kernel_connect(sock, (struct sockaddr *)&ra, sizeof(ra), 0);
+	if (err < 0)
+		goto free;
+
+	err = quic_test_client_handshake(sock, &priv);
+	if (err < 0)
+		goto free;
+
+	pr_info("quic_test: handshake completed\n");
+
+	ticket_len = sizeof(session_data);
+	err = quic_sock_getopt(sock->sk, QUIC_SOCKOPT_SESSION_TICKET, session_data, &ticket_len);
+	if (err < 0)
+		goto free;
+
+	param_len = sizeof(param);
+	param.remote = 1;
+	err = quic_sock_getopt(sock->sk, QUIC_SOCKOPT_TRANSPORT_PARAM, &param, &param_len);
+	if (err < 0)
+		goto free;
+
+	token_len = sizeof(token);
+	err = quic_sock_getopt(sock->sk, QUIC_SOCKOPT_TOKEN, token, &token_len);
+	if (err < 0)
+		goto free;
+
+	err = kernel_getsockname(sock, (struct sockaddr *)&la);
+	if (err < 0)
+		goto free;
+
+	pr_info("quic_test: save session ticket: %d, transport param %d, token %d for session resumption\n",
+		ticket_len, param_len, token_len);
+
+	strscpy(msg, "hello quic server!", sizeof(msg));
+	sid = (0 | QUIC_STREAM_TYPE_UNI_MASK);
+	flags = MSG_STREAM_NEW | MSG_STREAM_FIN;
+	err = quic_test_sendmsg(sock, msg, strlen(msg), sid, flags);
+	if (err < 0) {
+		pr_info("quic_test: send err: %d\n", err);
+		goto free;
+	}
+	pr_info("quic_test: send '%s' on stream %lld\n", msg, sid);
+
+	memset(msg, 0, sizeof(msg));
+	flags = 0;
+	err = quic_test_recvmsg(sock, msg, sizeof(msg) - 1, &sid, &flags);
+	if (err < 0) {
+		pr_info("quic_test: recv err: %d\n", err);
+		goto free;
+	}
+	pr_info("quic_test: recv '%s' on stream %lld\n", msg, sid);
+
+	__fput_sync(priv.filp);
+	msleep(100);
+
+	err = __sock_create(&init_net, PF_INET, SOCK_DGRAM, IPPROTO_QUIC, &sock, 1);
+	if (err < 0)
+		return err;
+	priv.filp = sock_alloc_file(sock, 0, NULL);
+	if (IS_ERR(priv.filp))
+		return PTR_ERR(priv.filp);
+	err = quic_sock_setopt(sock->sk, QUIC_SOCKOPT_ALPN, alpn, strlen(alpn));
+	if (err)
+		goto free;
+
+	err = kernel_bind(sock, (struct sockaddr *)&la, sizeof(la));
+	if (err)
+		goto free;
+
+	ra.sin_family = AF_INET;
+	ra.sin_port = htons((u16)port);
+	if (!in4_pton(ip, strlen(ip), (u8 *)&ra.sin_addr.s_addr, -1, NULL))
+		goto free;
+	err = kernel_connect(sock, (struct sockaddr *)&ra, sizeof(ra), 0);
+	if (err < 0)
+		goto free;
+
+	err = quic_sock_setopt(sock->sk, QUIC_SOCKOPT_TOKEN, token, token_len);
+	if (err)
+		goto free;
+
+	err = quic_sock_setopt(sock->sk, QUIC_SOCKOPT_SESSION_TICKET, session_data, ticket_len);
+	if (err)
+		goto free;
+
+	err = quic_sock_setopt(sock->sk, QUIC_SOCKOPT_TRANSPORT_PARAM, &param, param_len);
+	if (err)
+		goto free;
+
+	/* send early data before handshake */
+	strscpy(msg, "hello quic server! I'm back!", sizeof(msg));
+	sid = (0 | QUIC_STREAM_TYPE_UNI_MASK);
+	flags = MSG_STREAM_NEW | MSG_STREAM_FIN;
+	err = quic_test_sendmsg(sock, msg, strlen(msg), sid, flags);
+	if (err < 0) {
+		pr_info("quic_test: send err: %d\n", err);
+		goto free;
+	}
+	pr_info("quic_test: send '%s' on stream %lld\n", msg, sid);
+
+	err = quic_test_client_handshake(sock, &priv);
+	if (err < 0)
+		goto free;
+
+	pr_info("quic_test: handshake completed\n");
+
+	memset(msg, 0, sizeof(msg));
+	flags = 0;
+	err = quic_test_recvmsg(sock, msg, sizeof(msg) - 1, &sid, &flags);
+	if (err < 0) {
+		pr_info("quic_test: recv err: %d\n", err);
+		goto free;
+	}
+	pr_info("quic_test: recv '%s' on stream %lld\n", msg, sid);
+
+	err = 0;
+free:
+	__fput_sync(priv.filp);
+	return err;
+}
+
+static int quic_test_do_sample_client(void)
+{
+	struct quic_test_priv priv = {};
+	struct sockaddr_in ra = {};
+	struct socket *sock;
+	int err, flags = 0;
+	char msg[64];
+	s64 sid;
+
+	err = __sock_create(&init_net, PF_INET, SOCK_DGRAM, IPPROTO_QUIC, &sock, 1);
+	if (err < 0)
+		return err;
+	priv.filp = sock_alloc_file(sock, 0, NULL);
+	if (IS_ERR(priv.filp))
+		return PTR_ERR(priv.filp);
+	err = quic_sock_setopt(sock->sk, QUIC_SOCKOPT_ALPN, alpn, strlen(alpn));
+	if (err)
+		goto free;
+	ra.sin_family = AF_INET;
+	ra.sin_port = htons((u16)port);
+	if (!in4_pton(ip, strlen(ip), (u8 *)&ra.sin_addr.s_addr, -1, NULL))
+		goto free;
+	err = kernel_connect(sock, (struct sockaddr *)&ra, sizeof(ra), 0);
+	if (err < 0)
+		goto free;
+
+	err = quic_test_client_handshake(sock, &priv);
+	if (err < 0)
+		goto free;
+
+	pr_info("quic_test: handshake completed\n");
+
+	/* set MSG_STREAM_NEW flag to open a stream while sending first data
+	 * or call getsockopt(QUIC_SOCKOPT_STREAM_OPEN) to open a stream.
+	 * set MSG_STREAM_FIN to mark the last data on this stream.
+	 */
+	strscpy(msg, "hello quic server!", sizeof(msg));
+	sid = (0 | QUIC_STREAM_TYPE_UNI_MASK);
+	flags = MSG_STREAM_NEW | MSG_STREAM_FIN;
+	err = quic_test_sendmsg(sock, msg, strlen(msg), sid, flags);
+	if (err < 0) {
+		pr_info("quic_test: send err: %d\n", err);
+		goto free;
+	}
+	pr_info("quic_test: send '%s' on stream %lld\n", msg, sid);
+
+	memset(msg, 0, sizeof(msg));
+	flags = 0;
+	err = quic_test_recvmsg(sock, msg, sizeof(msg) - 1, &sid, &flags);
+	if (err < 0) {
+		pr_info("quic_test: recv err: %d\n", err);
+		goto free;
+	}
+	pr_info("quic_test: recv '%s' on stream %lld\n", msg, sid);
+
+	err = 0;
+free:
+	fput(priv.filp);
+	return err;
+}
+
+static int quic_test_do_ticket_server(void)
+{
+	struct quic_test_priv priv = {};
+	struct quic_config config = {};
+	struct socket *sock, *newsock;
+	struct sockaddr_in la = {};
+	int err, flags = 0;
+	char msg[64];
+	s64 sid;
+
+	err = __sock_create(&init_net, PF_INET, SOCK_DGRAM, IPPROTO_QUIC, &sock, 1);
+	if (err < 0)
+		return err;
+
+	la.sin_family = AF_INET;
+	la.sin_port = htons((u16)port);
+	if (!in4_pton(ip, strlen(ip), (u8 *)&la.sin_addr.s_addr, -1, NULL))
+		goto free;
+	err = kernel_bind(sock, (struct sockaddr *)&la, sizeof(la));
+	if (err < 0)
+		goto free;
+	err = quic_sock_setopt(sock->sk, QUIC_SOCKOPT_ALPN, alpn, strlen(alpn));
+	if (err)
+		goto free;
+	err = kernel_listen(sock, 1);
+	if (err < 0)
+		goto free;
+	config.validate_peer_address = 1;
+	err = quic_sock_setopt(sock->sk, QUIC_SOCKOPT_CONFIG, &config, sizeof(config));
+	if (err)
+		goto free;
+
+	err = kernel_accept(sock, &newsock, 0);
+	if (err < 0)
+		goto free;
+
+	/* attach a file for user space to operate */
+	priv.filp = sock_alloc_file(newsock, 0, NULL);
+	if (IS_ERR(priv.filp)) {
+		err = PTR_ERR(priv.filp);
+		goto free;
+	}
+
+	/* do handshake with net/handshake APIs */
+	err = quic_test_server_handshake(newsock, &priv);
+	if (err < 0)
+		goto free_flip;
+
+	pr_info("quic_test: handshake completed\n");
+
+	memset(msg, 0, sizeof(msg));
+	flags = 0;
+	err = quic_test_recvmsg(newsock, msg, sizeof(msg) - 1, &sid, &flags);
+	if (err < 0) {
+		pr_info("quic_test: recv err: %d\n", err);
+		goto free_flip;
+	}
+	pr_info("quic_test: recv '%s' on stream %lld\n", msg, sid);
+
+	strscpy(msg, "hello quic client!", sizeof(msg));
+	sid = (0 | QUIC_STREAM_TYPE_SERVER_MASK);
+	flags = MSG_STREAM_NEW | MSG_STREAM_FIN;
+	err = quic_test_sendmsg(newsock, msg, strlen(msg), sid, flags);
+	if (err < 0) {
+		pr_info("quic_test: send err: %d\n", err);
+		goto free_flip;
+	}
+	pr_info("quic_test: send '%s' on stream %lld\n", msg, sid);
+
+	__fput_sync(priv.filp);
+
+	pr_info("quic_test: wait for next connection from client...\n");
+
+	err = kernel_accept(sock, &newsock, 0);
+	if (err < 0)
+		goto free;
+
+	/* attach a file for user space to operate */
+	priv.filp = sock_alloc_file(newsock, 0, NULL);
+	if (IS_ERR(priv.filp)) {
+		err = PTR_ERR(priv.filp);
+		goto free;
+	}
+
+	/* do handshake with net/handshake APIs */
+	err = quic_test_server_handshake(newsock, &priv);
+	if (err < 0)
+		goto free_flip;
+
+	pr_info("quic_test: handshake completed\n");
+
+	memset(msg, 0, sizeof(msg));
+	flags = 0;
+	err = quic_test_recvmsg(newsock, msg, sizeof(msg) - 1, &sid, &flags);
+	if (err < 0) {
+		pr_info("quic_test: recv err: %d\n", err);
+		goto free_flip;
+	}
+	pr_info("quic_test: recv '%s' on stream %lld\n", msg, sid);
+
+	strscpy(msg, "hello quic client! welcome back!", sizeof(msg));
+	sid = (0 | QUIC_STREAM_TYPE_SERVER_MASK);
+	flags = MSG_STREAM_NEW | MSG_STREAM_FIN;
+	err = quic_test_sendmsg(newsock, msg, strlen(msg), sid, flags);
+	if (err < 0) {
+		pr_info("quic_test: send err: %d\n", err);
+		goto free_flip;
+	}
+	pr_info("quic_test: send '%s' on stream %lld\n", msg, sid);
+
+	err = 0;
+free_flip:
+	__fput_sync(priv.filp);
+free:
+	sock_release(sock);
+	return err;
+}
+
+static int quic_test_do_sample_server(void)
+{
+	struct quic_test_priv priv = {};
+	struct socket *sock, *newsock;
+	struct sockaddr_in la = {};
+	int err, flags = 0;
+	char msg[64];
+	s64 sid;
+
+	err = __sock_create(&init_net, PF_INET, SOCK_DGRAM, IPPROTO_QUIC, &sock, 1);
+	if (err < 0)
+		return err;
+
+	la.sin_family = AF_INET;
+	la.sin_port = htons((u16)port);
+	if (!in4_pton(ip, strlen(ip), (u8 *)&la.sin_addr.s_addr, -1, NULL))
+		goto free;
+	err = kernel_bind(sock, (struct sockaddr *)&la, sizeof(la));
+	if (err < 0)
+		goto free;
+	err = quic_sock_setopt(sock->sk, QUIC_SOCKOPT_ALPN, alpn, strlen(alpn));
+	if (err)
+		goto free;
+	err = kernel_listen(sock, 1);
+	if (err < 0)
+		goto free;
+	err = kernel_accept(sock, &newsock, 0);
+	if (err < 0)
+		goto free;
+
+	/* attach a file for user space to operate */
+	priv.filp = sock_alloc_file(newsock, 0, NULL);
+	if (IS_ERR(priv.filp)) {
+		err = PTR_ERR(priv.filp);
+		goto free;
+	}
+
+	/* do handshake with net/handshake APIs */
+	err = quic_test_server_handshake(newsock, &priv);
+	if (err < 0)
+		goto free_flip;
+
+	pr_info("quic_test: handshake completed\n");
+
+	memset(msg, 0, sizeof(msg));
+	flags = 0;
+	err = quic_test_recvmsg(newsock, msg, sizeof(msg) - 1, &sid, &flags);
+	if (err < 0) {
+		pr_info("quic_test: recv err %d\n", err);
+		goto free_flip;
+	}
+	pr_info("quic_test: recv '%s' on stream %lld\n", msg, sid);
+
+	strscpy(msg, "hello quic client!", sizeof(msg));
+	sid = (0 | QUIC_STREAM_TYPE_SERVER_MASK);
+	flags = MSG_STREAM_NEW | MSG_STREAM_FIN;
+	err = quic_test_sendmsg(newsock, msg, strlen(msg), sid, flags);
+	if (err < 0) {
+		pr_info("quic_test: send err: %d\n", err);
+		goto free_flip;
+	}
+	pr_info("quic_test: send '%s' on stream %lld\n", msg, sid);
+
+	err = 0;
+free_flip:
+	fput(priv.filp);
+free:
+	sock_release(sock);
+	return err;
+}
+
+static int quic_test_init(void)
+{
+	pr_info("quic_test: init\n");
+	if (!strcmp(role, "client")) {
+		if (!strcmp(alpn, "ticket"))
+			return quic_test_do_ticket_client();
+		return quic_test_do_sample_client();
+	}
+	if (!strcmp(role, "server")) {
+		if (!strcmp(alpn, "ticket"))
+			return quic_test_do_ticket_server();
+		return quic_test_do_sample_server();
+	}
+	return -EINVAL;
+}
+
+static void quic_test_exit(void)
+{
+	pr_info("quic_test: exit\n");
+}
+
+module_init(quic_test_init);
+module_exit(quic_test_exit);
+
+module_param_string(role, role, ROLE_LEN, 0644);
+module_param_string(alpn, alpn, ALPN_LEN, 0644);
+module_param_string(ip, ip, IP_LEN, 0644);
+module_param_named(port, port, int, 0644);
+module_param_named(psk, psk, int, 0644);
+
+MODULE_PARM_DESC(role, "client or server");
+MODULE_PARM_DESC(ip, "server address");
+MODULE_PARM_DESC(port, "server port");
+MODULE_PARM_DESC(alpn, "alpn name");
+MODULE_PARM_DESC(psk, "key_serial_t for psk");
+
+MODULE_AUTHOR("Xin Long <lucien.xin@gmail.com>");
+MODULE_DESCRIPTION("Test For Support for the QUIC protocol (RFC9000)");
+MODULE_LICENSE("GPL");
diff --git a/net/quic/test/unit_test.c b/net/quic/test/unit_test.c
new file mode 100644
index 000000000000..e562ac261a3f
--- /dev/null
+++ b/net/quic/test/unit_test.c
@@ -0,0 +1,1190 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* QUIC kernel implementation
+ * (C) Copyright Red Hat Corp. 2023
+ *
+ * This file is kernel test of the QUIC kernel implementation
+ *
+ * Initialization/cleanup for QUIC protocol support.
+ *
+ * Written or modified by:
+ *    Xin Long <lucien.xin@gmail.com>
+ */
+
+#include <uapi/linux/quic.h>
+#include <uapi/linux/tls.h>
+#include <linux/version.h>
+#include <linux/skbuff.h>
+#include <linux/delay.h>
+#include <kunit/test.h>
+#include <net/sock.h>
+
+#include "../pnspace.h"
+#include "../connid.h"
+#include "../crypto.h"
+#include "../cong.h"
+
+static void quic_pnspace_test1(struct kunit *test)
+{
+	struct quic_pnspace _space = {}, *space = &_space;
+	struct quic_gap_ack_block *gabs;
+	int i;
+
+	KUNIT_ASSERT_EQ(test, 0, quic_pnspace_init(space));
+	quic_pnspace_set_base_pn(space, 1);
+	quic_pnspace_set_max_time_limit(space, 30000);
+	gabs = quic_pnspace_gabs(space);
+
+	KUNIT_EXPECT_EQ(test, space->base_pn, 1);
+	KUNIT_EXPECT_EQ(test, space->min_pn_seen, 0);
+	KUNIT_EXPECT_EQ(test, space->pn_map_len, QUIC_PN_MAP_INITIAL);
+
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, -1));
+	KUNIT_EXPECT_EQ(test, -ENOMEM, quic_pnspace_mark(space, QUIC_PN_MAP_SIZE + 1));
+
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 0));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 1));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 2));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 3));
+	KUNIT_EXPECT_EQ(test, 4, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 0, space->min_pn_seen);
+	KUNIT_EXPECT_EQ(test, 0, space->mid_pn_seen);
+	KUNIT_EXPECT_EQ(test, 3, space->max_pn_seen);
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_num_gabs(space));
+
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 4));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 6));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 9));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 13));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 18));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 24));
+	KUNIT_EXPECT_EQ(test, 5, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 0, space->min_pn_seen);
+	KUNIT_EXPECT_EQ(test, 0, space->mid_pn_seen);
+	KUNIT_EXPECT_EQ(test, 24, space->max_pn_seen);
+	KUNIT_EXPECT_EQ(test, 5, quic_pnspace_num_gabs(space));
+	KUNIT_EXPECT_EQ(test, 6, gabs[0].start + space->base_pn);
+	KUNIT_EXPECT_EQ(test, 6, gabs[0].end + space->base_pn);
+	KUNIT_EXPECT_EQ(test, 8, gabs[1].start + space->base_pn);
+	KUNIT_EXPECT_EQ(test, 9, gabs[1].end + space->base_pn);
+	KUNIT_EXPECT_EQ(test, 11, gabs[2].start + space->base_pn);
+	KUNIT_EXPECT_EQ(test, 13, gabs[2].end + space->base_pn);
+	KUNIT_EXPECT_EQ(test, 15, gabs[3].start + space->base_pn);
+	KUNIT_EXPECT_EQ(test, 18, gabs[3].end + space->base_pn);
+	KUNIT_EXPECT_EQ(test, 20, gabs[4].start + space->base_pn);
+	KUNIT_EXPECT_EQ(test, 24, gabs[4].end + space->base_pn);
+	KUNIT_EXPECT_EQ(test, 4, gabs[0].start - 1 + quic_pnspace_base_pn(space) -
+				 (quic_pnspace_min_pn_seen(space) + 1));
+
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 7));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 8));
+	KUNIT_EXPECT_EQ(test, 5, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 4, quic_pnspace_num_gabs(space));
+
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 5));
+	KUNIT_EXPECT_EQ(test, 10, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 3, quic_pnspace_num_gabs(space));
+
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 15));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 16));
+	KUNIT_EXPECT_EQ(test, 10, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 4, quic_pnspace_num_gabs(space));
+
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 14));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 17));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 10));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 11));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 12));
+	KUNIT_EXPECT_EQ(test, 19, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 1, quic_pnspace_num_gabs(space));
+
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 128));
+	KUNIT_EXPECT_EQ(test, 19, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 0, space->min_pn_seen);
+	KUNIT_EXPECT_EQ(test, 128, space->max_pn_seen);
+	KUNIT_EXPECT_EQ(test, 0, space->mid_pn_seen);
+	KUNIT_EXPECT_EQ(test, 128 + QUIC_PN_MAP_INITIAL, space->pn_map_len);
+	KUNIT_EXPECT_EQ(test, 2, quic_pnspace_num_gabs(space));
+
+	/* ! space->max_pn_seen <= space->mid_pn_seen + QUIC_PN_MAP_LIMIT */
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 3073));
+	KUNIT_EXPECT_EQ(test, 19, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 0, space->min_pn_seen);
+	KUNIT_EXPECT_EQ(test, 3073, space->max_pn_seen);
+	KUNIT_EXPECT_EQ(test, 3073, space->mid_pn_seen);
+	KUNIT_EXPECT_EQ(test, 3136, space->pn_map_len);
+	KUNIT_EXPECT_EQ(test, 3, quic_pnspace_num_gabs(space));
+
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 3074));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 3075));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 3090));
+	KUNIT_EXPECT_EQ(test, 19, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 3090, space->max_pn_seen);
+	KUNIT_EXPECT_EQ(test, 3073, space->mid_pn_seen);
+	KUNIT_EXPECT_EQ(test, 3136, space->pn_map_len);
+	KUNIT_EXPECT_EQ(test, 4, quic_pnspace_num_gabs(space));
+
+	/* ! space->max_pn_seen <= space->base_pn + QUIC_PN_MAP_LIMIT */
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 3190));
+	KUNIT_EXPECT_EQ(test, 3076, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 3190, space->max_pn_seen);
+	KUNIT_EXPECT_EQ(test, 3190, space->mid_pn_seen);
+	KUNIT_EXPECT_EQ(test, 3264, space->pn_map_len);
+	KUNIT_EXPECT_EQ(test, 2, quic_pnspace_num_gabs(space));
+
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 3290));
+	KUNIT_EXPECT_EQ(test, 3076, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 3290, space->max_pn_seen);
+	KUNIT_EXPECT_EQ(test, 3190, space->mid_pn_seen);
+	KUNIT_EXPECT_EQ(test, 3264, space->pn_map_len);
+	KUNIT_EXPECT_EQ(test, 3, quic_pnspace_num_gabs(space));
+
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 3289));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 3288));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 3192));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 3191));
+	KUNIT_EXPECT_EQ(test, 3076, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 3290, space->max_pn_seen);
+	KUNIT_EXPECT_EQ(test, 3190, space->mid_pn_seen);
+	KUNIT_EXPECT_EQ(test, 3264, space->pn_map_len);
+	KUNIT_EXPECT_EQ(test, 3, quic_pnspace_num_gabs(space));
+
+	for (i = 1; i <= 128; i++)
+		KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 256 * i));
+
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, QUIC_PN_MAP_SIZE + 1));
+	KUNIT_EXPECT_EQ(test, -ENOMEM,
+			quic_pnspace_mark(space, space->base_pn + QUIC_PN_MAP_SIZE + 1));
+
+	quic_pnspace_free(space);
+	KUNIT_EXPECT_EQ(test, space->pn_map_len, 0);
+}
+
+static void quic_pnspace_test2(struct kunit *test)
+{
+	struct quic_pnspace _space = {}, *space = &_space;
+	struct quic_gap_ack_block *gabs;
+
+	KUNIT_ASSERT_EQ(test, 0, quic_pnspace_init(space));
+	quic_pnspace_set_base_pn(space, 1);
+	quic_pnspace_set_max_time_limit(space, 30000);
+	gabs = quic_pnspace_gabs(space);
+
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 2));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 3));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 5));
+	KUNIT_EXPECT_EQ(test, 1, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 0, space->min_pn_seen);
+	KUNIT_EXPECT_EQ(test, 0, space->mid_pn_seen);
+	KUNIT_EXPECT_EQ(test, 5, space->max_pn_seen);
+	KUNIT_EXPECT_EQ(test, 2, quic_pnspace_num_gabs(space));
+	KUNIT_EXPECT_EQ(test, 2, gabs[0].start + space->base_pn);
+	KUNIT_EXPECT_EQ(test, 2, gabs[0].end + space->base_pn);
+	KUNIT_EXPECT_EQ(test, 5, gabs[1].start + space->base_pn);
+	KUNIT_EXPECT_EQ(test, 5, gabs[1].end + space->base_pn);
+	KUNIT_EXPECT_EQ(test, 0, gabs[0].start - 1 + quic_pnspace_base_pn(space) -
+				 (quic_pnspace_min_pn_seen(space) + 1));
+
+	msleep(50);
+	/* ! space->max_pn_time - space->mid_pn_time < space->max_time_limit */
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 4));
+	KUNIT_EXPECT_EQ(test, 1, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 1));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 6));
+	KUNIT_EXPECT_EQ(test, 7, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 0, space->min_pn_seen);
+	KUNIT_EXPECT_EQ(test, 6, space->mid_pn_seen);
+	KUNIT_EXPECT_EQ(test, 6, space->max_pn_seen);
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_num_gabs(space));
+
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 8));
+	KUNIT_EXPECT_EQ(test, 7, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 0, space->min_pn_seen);
+	KUNIT_EXPECT_EQ(test, 6, space->mid_pn_seen);
+	KUNIT_EXPECT_EQ(test, 8, space->max_pn_seen);
+	KUNIT_EXPECT_EQ(test, 1, quic_pnspace_num_gabs(space));
+
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 7));
+	KUNIT_EXPECT_EQ(test, 9, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 0, space->min_pn_seen);
+	KUNIT_EXPECT_EQ(test, 6, space->mid_pn_seen);
+	KUNIT_EXPECT_EQ(test, 8, space->max_pn_seen);
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_num_gabs(space));
+
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 11));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 10));
+	KUNIT_EXPECT_EQ(test, 9, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 0, space->min_pn_seen);
+	KUNIT_EXPECT_EQ(test, 6, space->mid_pn_seen);
+	KUNIT_EXPECT_EQ(test, 11, space->max_pn_seen);
+	KUNIT_EXPECT_EQ(test, 1, quic_pnspace_num_gabs(space));
+
+	msleep(50);
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 18));
+	KUNIT_EXPECT_EQ(test, 9, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 6, space->min_pn_seen);
+	KUNIT_EXPECT_EQ(test, 18, space->mid_pn_seen);
+	KUNIT_EXPECT_EQ(test, 18, space->max_pn_seen);
+	KUNIT_EXPECT_EQ(test, 2, quic_pnspace_num_gabs(space));
+
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 9));
+	KUNIT_EXPECT_EQ(test, 12, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 6, space->min_pn_seen);
+	KUNIT_EXPECT_EQ(test, 18, space->mid_pn_seen);
+	KUNIT_EXPECT_EQ(test, 18, space->max_pn_seen);
+	KUNIT_EXPECT_EQ(test, 1, quic_pnspace_num_gabs(space));
+
+	msleep(50);
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 17));
+	KUNIT_EXPECT_EQ(test, 12, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 6, space->min_pn_seen);
+	KUNIT_EXPECT_EQ(test, 18, space->mid_pn_seen);
+	KUNIT_EXPECT_EQ(test, 18, space->max_pn_seen);
+	KUNIT_EXPECT_EQ(test, 1, quic_pnspace_num_gabs(space));
+
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 19));
+	KUNIT_EXPECT_EQ(test, 20, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 19, space->max_pn_seen);
+	KUNIT_EXPECT_EQ(test, 19, space->mid_pn_seen);
+	KUNIT_EXPECT_EQ(test, 18, space->min_pn_seen);
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_num_gabs(space));
+
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 25));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 26));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 29));
+	KUNIT_EXPECT_EQ(test, 20, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 29, space->max_pn_seen);
+	KUNIT_EXPECT_EQ(test, 19, space->mid_pn_seen);
+	KUNIT_EXPECT_EQ(test, 18, space->min_pn_seen);
+	KUNIT_EXPECT_EQ(test, 2, quic_pnspace_num_gabs(space));
+
+	msleep(50);
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_mark(space, 30));
+	KUNIT_EXPECT_EQ(test, 20, space->base_pn);
+	KUNIT_EXPECT_EQ(test, 30, space->max_pn_seen);
+	KUNIT_EXPECT_EQ(test, 19, space->min_pn_seen);
+	KUNIT_EXPECT_EQ(test, 30, space->mid_pn_seen);
+	KUNIT_EXPECT_EQ(test, 2, quic_pnspace_num_gabs(space));
+
+	KUNIT_EXPECT_EQ(test, 1, quic_pnspace_check(space, 29));
+	KUNIT_EXPECT_EQ(test, 1, quic_pnspace_check(space, 19));
+	KUNIT_EXPECT_EQ(test, 0, quic_pnspace_check(space, 35));
+	KUNIT_EXPECT_EQ(test, -1, quic_pnspace_check(space, space->base_pn + QUIC_PN_MAP_SIZE));
+
+	quic_pnspace_free(space);
+	KUNIT_EXPECT_EQ(test, space->pn_map_len, 0);
+}
+
+static u8 secret[48] = {
+	0x55, 0xe7, 0x18, 0x93, 0x73, 0x08, 0x09, 0xf6, 0xbf, 0xa1, 0xab, 0x66, 0xe8, 0xfc, 0x02,
+	0xde, 0x17, 0xfa, 0xbe, 0xc5, 0x4a, 0xe7, 0xe4, 0xb8, 0x25, 0x48, 0xff, 0xe9, 0xd6, 0x7d,
+	0x8e, 0x0e};
+
+static u8 data[296] = {
+	0x03, 0x65, 0x85, 0x3b, 0xf1, 0xe4, 0xf4, 0x22, 0x8d, 0x45, 0x48, 0xcb, 0xb8, 0x2e, 0x7e,
+	0x05, 0x09, 0x00, 0x00, 0x00, 0x00, 0x18, 0x01, 0x01, 0x10, 0xad, 0x35, 0x67, 0x29, 0xe2,
+	0xa6, 0x99, 0x99, 0x17, 0xf4, 0xe5, 0xdc, 0x10, 0xbf, 0x4c, 0xee, 0xd5, 0x75, 0xa0, 0x77,
+	0xd0, 0x1d, 0x49, 0x78, 0x5d, 0xaa, 0xa9, 0x74, 0x70, 0x72, 0x19, 0x91, 0x18, 0x02, 0x01,
+	0x10, 0x3c, 0xdc, 0x40, 0x33, 0xe6, 0xe9, 0x35, 0xa6, 0xa9, 0x80, 0xb6, 0xe9, 0x39, 0x84,
+	0xea, 0xb7, 0xe9, 0xc2, 0x86, 0xfb, 0x84, 0x34, 0x0a, 0x26, 0x69, 0xa5, 0x9f, 0xbb, 0x02,
+	0x7c, 0xd2, 0xd4, 0x18, 0x03, 0x01, 0x10, 0x14, 0x6a, 0xa5, 0x7e, 0x82, 0x8d, 0xc0, 0xb3,
+	0x5e, 0x23, 0x1a, 0x4d, 0xd1, 0x68, 0xbf, 0x29, 0x62, 0x01, 0xda, 0x70, 0xad, 0x88, 0x8c,
+	0x7c, 0x70, 0xb1, 0xb5, 0xdf, 0xce, 0x66, 0x00, 0xfe, 0x18, 0x04, 0x01, 0x10, 0x25, 0x83,
+	0x2f, 0x08, 0x97, 0x1a, 0x99, 0xe8, 0x68, 0xad, 0x4a, 0x2c, 0xbb, 0xc9, 0x27, 0x94, 0xd4,
+	0x5d, 0x2e, 0xe6, 0xe5, 0x50, 0x47, 0xa7, 0x72, 0x6f, 0x44, 0x49, 0x9b, 0x87, 0x21, 0xec,
+	0x18, 0x05, 0x01, 0x10, 0xcf, 0xb4, 0x62, 0xdd, 0x34, 0xb7, 0x6b, 0x92, 0xd8, 0x2d, 0x6c,
+	0xd6, 0x17, 0x75, 0xdc, 0x33, 0x8c, 0x49, 0xf3, 0xd5, 0xc0, 0xf2, 0x8e, 0xc4, 0xb6, 0x97,
+	0x99, 0xe3, 0x3c, 0x97, 0x7e, 0xa5, 0x18, 0x06, 0x01, 0x10, 0x29, 0xc6, 0x70, 0x43, 0xbe,
+	0x94, 0x18, 0x8e, 0x22, 0xf7, 0xe1, 0x02, 0xc6, 0x71, 0xc9, 0xc5, 0xb1, 0x69, 0x14, 0xb5,
+	0x62, 0x59, 0x13, 0xe5, 0xff, 0xcd, 0xc7, 0xfc, 0xfc, 0x8e, 0x46, 0x1d, 0x18, 0x07, 0x01,
+	0x10, 0x38, 0x67, 0x2b, 0x1a, 0xeb, 0x2f, 0x79, 0xdc, 0x3b, 0xc0, 0x70, 0x60, 0x21, 0xce,
+	0x35, 0x80, 0x42, 0x52, 0x4d, 0x28, 0x1f, 0x25, 0xaa, 0x59, 0x57, 0x64, 0xc3, 0xec, 0xa1,
+	0xe3, 0x3c, 0x4a, 0x19, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00};
+
+static u8 encrypted_data[296] = {
+	0x03, 0x65, 0x85, 0x3b, 0xf1, 0xe4, 0xf4, 0x22, 0x8d, 0x45, 0x48, 0xcb, 0xb8, 0x2e, 0x7e,
+	0x05, 0x09, 0x26, 0x0c, 0xae, 0xc2, 0x36, 0x54, 0xd1, 0xe4, 0x34, 0xdf, 0x42, 0xf7, 0xe6,
+	0x66, 0xc5, 0x4b, 0x80, 0x04, 0x3f, 0x77, 0x9e, 0x26, 0xdb, 0x5a, 0x5c, 0xd9, 0x48, 0xc7,
+	0x21, 0xb1, 0x01, 0xaf, 0xa4, 0x4f, 0x4d, 0x46, 0xc8, 0xb6, 0x8b, 0xde, 0xdb, 0x3b, 0x23,
+	0xee, 0x0c, 0x8b, 0x57, 0xba, 0x5a, 0x5a, 0x5e, 0xa8, 0xac, 0x12, 0x48, 0x16, 0x81, 0x12,
+	0xfb, 0xa1, 0x76, 0x1a, 0x41, 0x89, 0x46, 0xb1, 0xe3, 0xa7, 0x7b, 0x38, 0x0c, 0x75, 0x4d,
+	0x49, 0xc7, 0x77, 0x13, 0x40, 0x18, 0xf0, 0x24, 0xb9, 0x4c, 0xe4, 0xff, 0xea, 0x9c, 0xb4,
+	0xfe, 0x46, 0xcf, 0xe0, 0x2e, 0x15, 0xb5, 0xe9, 0x9b, 0xe7, 0x42, 0x3b, 0x3b, 0xdf, 0x55,
+	0xd2, 0x1e, 0xa0, 0x00, 0xdb, 0xb9, 0x1b, 0x77, 0xb7, 0x06, 0x31, 0xc8, 0x67, 0xd8, 0x61,
+	0x45, 0xcc, 0x1a, 0x3f, 0x01, 0xf8, 0xd8, 0x06, 0xd2, 0xcb, 0x76, 0xf5, 0xd2, 0x9d, 0x2c,
+	0x79, 0xd5, 0x7d, 0xe6, 0x06, 0x98, 0x8c, 0x17, 0xe5, 0xc5, 0x11, 0xec, 0x39, 0x68, 0x32,
+	0x8b, 0x66, 0x25, 0xd4, 0xf3, 0xb2, 0x4b, 0x88, 0xdf, 0x82, 0x9f, 0x17, 0x87, 0xb3, 0x44,
+	0xdf, 0x9c, 0x1a, 0xd0, 0x13, 0x3a, 0xfc, 0xa9, 0x39, 0xe6, 0xa0, 0xf3, 0x82, 0x78, 0x26,
+	0x3e, 0x79, 0xe3, 0xfa, 0x5c, 0x43, 0x55, 0xa0, 0x5b, 0x24, 0x4c, 0x63, 0x43, 0x80, 0x69,
+	0x5e, 0x0c, 0x38, 0xcf, 0x82, 0x13, 0xb5, 0xbc, 0xaa, 0x40, 0x1d, 0x4d, 0x33, 0x1a, 0xfd,
+	0x91, 0x6f, 0x4f, 0xc0, 0x71, 0x1d, 0xa1, 0x55, 0xf0, 0xa5, 0x64, 0x68, 0x08, 0x43, 0xda,
+	0xa6, 0xd2, 0x23, 0xad, 0x41, 0xf5, 0xd9, 0xa8, 0x81, 0x1d, 0xd7, 0x92, 0xa5, 0xb4, 0x08,
+	0x64, 0x96, 0x23, 0xac, 0xe3, 0xbf, 0x7d, 0x1c, 0x8f, 0x9f, 0x47, 0xc7, 0x71, 0xc2, 0x48,
+	0x28, 0x5c, 0x47, 0x74, 0x8c, 0xbb, 0x8c, 0xde, 0xc3, 0xcd, 0x0e, 0x62, 0x9f, 0xbe, 0x9d,
+	0xb5, 0x61, 0xfb, 0x2f, 0x72, 0x92, 0x62, 0x74, 0x2a, 0xda, 0x12};
+
+static struct quic_crypto crypto;
+
+static void quic_encrypt_done(struct sk_buff *skb, int err)
+{
+	struct quic_crypto_cb *cb = QUIC_CRYPTO_CB(skb);
+
+	WARN_ON(!skb_set_owner_sk_safe(skb, skb->sk));
+
+	cb->number_len = 4;
+	cb->number = 0;
+	cb->number_offset = 17;
+	cb->crypto_done = quic_encrypt_done;
+	cb->resume = 1;
+	quic_crypto_encrypt(&crypto, skb);
+}
+
+static void quic_decrypt_done(struct sk_buff *skb, int err)
+{
+	struct quic_crypto_cb *cb = QUIC_CRYPTO_CB(skb);
+
+	WARN_ON(!skb_set_owner_sk_safe(skb, skb->sk));
+
+	cb->number_len = 4;
+	cb->number = 0;
+	cb->number_offset = 17;
+	cb->crypto_done = quic_decrypt_done;
+	cb->resume = 1;
+	quic_crypto_decrypt(&crypto, skb);
+}
+
+static void quic_crypto_test1(struct kunit *test)
+{
+	struct quic_conn_id conn_id, tmpid = {};
+	struct quic_crypto_secret srt = {};
+	struct sockaddr_in addr = {};
+	struct sk_buff *skb;
+	int ret, tokenlen;
+	u8 token[72];
+
+	srt.send = 1;
+	memcpy(srt.secret, secret, 48);
+
+	srt.type = 100;
+	ret = quic_crypto_set_secret(&crypto, &srt, QUIC_VERSION_V1, 0);
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+
+	srt.type = 0;
+	ret = quic_crypto_set_secret(&crypto, &srt, QUIC_VERSION_V1, 0);
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+
+	srt.type = TLS_CIPHER_AES_GCM_128;
+	ret = quic_crypto_set_secret(&crypto, &srt, QUIC_VERSION_V1, 0);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+
+	srt.send = 0;
+	srt.type = TLS_CIPHER_AES_GCM_128;
+	ret = quic_crypto_set_secret(&crypto, &srt, QUIC_VERSION_V1, 0);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+
+	ret = quic_crypto_key_update(&crypto);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+
+	quic_conn_id_generate(&conn_id);
+	quic_crypto_destroy(&crypto);
+	ret = quic_crypto_initial_keys_install(&crypto, &conn_id, QUIC_VERSION_V1, 0);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+
+	quic_crypto_destroy(&crypto);
+	ret = quic_crypto_initial_keys_install(&crypto, &conn_id, QUIC_VERSION_V2, 1);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+
+	ret = quic_crypto_generate_stateless_reset_token(&crypto, conn_id.data,
+							 conn_id.len, token, 16);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+
+	ret = quic_crypto_generate_session_ticket_key(&crypto, conn_id.data,
+						      conn_id.len, token, 16);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+
+	addr.sin_port = htons(1234);
+	token[0] = 1;
+	ret = quic_crypto_generate_token(&crypto, &addr, sizeof(addr),
+					 &conn_id, token, &tokenlen);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, tokenlen, 1 + sizeof(addr) + 4 + conn_id.len + QUIC_TAG_LEN);
+
+	ret = quic_crypto_verify_token(&crypto, &addr, sizeof(addr), &tmpid, token, tokenlen);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, tmpid.len, conn_id.len);
+	KUNIT_EXPECT_EQ(test, memcmp(tmpid.data, conn_id.data, tmpid.len), 0);
+
+	skb = alloc_skb(296, GFP_ATOMIC);
+	if (!skb)
+		goto out;
+	skb_put_data(skb, data, 280);
+
+	ret = quic_crypto_get_retry_tag(&crypto, skb, &conn_id, QUIC_VERSION_V1, token);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	kfree_skb(skb);
+out:
+	quic_crypto_destroy(&crypto);
+}
+
+static void quic_crypto_test2(struct kunit *test)
+{
+	struct quic_crypto_secret srt = {};
+	struct quic_crypto_cb *cb;
+	struct socket *sock;
+	struct sk_buff *skb;
+	int err;
+
+	err = __sock_create(&init_net, PF_INET, SOCK_DGRAM, IPPROTO_QUIC, &sock, 1);
+	if (err)
+		return;
+
+	srt.send = 1;
+	srt.level = 0;
+	srt.type = TLS_CIPHER_AES_GCM_128;
+	memcpy(srt.secret, secret, 48);
+	if (quic_crypto_set_secret(&crypto, &srt, QUIC_VERSION_V1, 0))
+		return;
+
+	skb = alloc_skb(296, GFP_ATOMIC);
+	if (!skb)
+		goto out;
+	WARN_ON(!skb_set_owner_sk_safe(skb, sock->sk));
+	skb_reset_transport_header(skb);
+
+	skb_put_data(skb, data, 280);
+	cb = QUIC_CRYPTO_CB(skb);
+	cb->number_len = 4;
+	cb->number = 0;
+	cb->number_offset = 17;
+	cb->crypto_done = quic_encrypt_done;
+	cb->resume = 0;
+	err = quic_crypto_encrypt(&crypto, skb);
+	if (err) {
+		if (err != -EINPROGRESS)
+			goto out;
+		msleep(50);
+	}
+
+	KUNIT_EXPECT_EQ(test, memcmp(encrypted_data, skb->data, skb->len), 0);
+	quic_crypto_destroy(&crypto);
+
+	srt.send = 0;
+	srt.level = 0;
+	srt.type = TLS_CIPHER_AES_GCM_128;
+	memcpy(srt.secret, secret, 48);
+	if (quic_crypto_set_secret(&crypto, &srt, QUIC_VERSION_V1, 0))
+		goto out;
+
+	WARN_ON(!skb_set_owner_sk_safe(skb, sock->sk));
+	cb->number_len = 4; /* unknown yet */
+	cb->number = 0; /* unknown yet */
+	cb->number_offset = 17;
+	cb->crypto_done = quic_decrypt_done;
+	cb->resume = 0;
+	cb->length = skb->len - cb->number_offset;
+	err = quic_crypto_decrypt(&crypto, skb);
+	if (err) {
+		if (err != -EINPROGRESS)
+			goto out;
+		msleep(50);
+	}
+
+	KUNIT_EXPECT_EQ(test, memcmp(data, skb->data, 280), 0);
+
+out:
+	kfree_skb(skb);
+	quic_crypto_destroy(&crypto);
+	sock_release(sock);
+}
+
+static void quic_cong_test1(struct kunit *test)
+{
+	struct quic_transport_param p = {};
+	struct quic_cong cong = {};
+	struct quic_config c = {};
+	u32 time, ack_delay;
+
+	p.max_ack_delay = 25000;
+	p.ack_delay_exponent = 3;
+	quic_cong_set_param(&cong, &p);
+
+	c.initial_smoothed_rtt = 333000;
+	quic_cong_set_config(&cong, &c);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 166500);
+	KUNIT_EXPECT_EQ(test, cong.rto, 499500);
+
+	quic_cong_set_time(&cong, jiffies_to_usecs(jiffies));
+	time = quic_cong_time(&cong) - 30000;
+	ack_delay = 2500;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 30000);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 30000);
+	/* (smoothed_rtt * 7 + adjusted_rtt) / 8 */
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 295125);
+	/* (rttvar * 3 + rttvar_sample) / 4 */
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 191156);
+	/* smoothed_rtt + rttvar */
+	KUNIT_EXPECT_EQ(test, cong.rto, 486281);
+
+	time = quic_cong_time(&cong) - 30000;
+	ack_delay = 2500;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 30000);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 30000);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 261984);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 201363);
+	KUNIT_EXPECT_EQ(test, cong.rto, 463347);
+
+	time = quic_cong_time(&cong) - 30000;
+	ack_delay = 2500;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 30000);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 30000);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 232986);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 201768);
+	KUNIT_EXPECT_EQ(test, cong.rto, 434754);
+
+	time = quic_cong_time(&cong) - 3000;
+	ack_delay = 250;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 3000);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 3000);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 204237);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 201635);
+	KUNIT_EXPECT_EQ(test, cong.rto, 405872);
+
+	time = quic_cong_time(&cong) - 3000;
+	ack_delay = 250;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 3000);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 3000);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 179082);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 195246);
+	KUNIT_EXPECT_EQ(test, cong.rto, 374328);
+
+	time = quic_cong_time(&cong) - 300;
+	ack_delay = 25;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 300);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 300);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 156734);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 185543);
+	KUNIT_EXPECT_EQ(test, cong.rto, 342277);
+
+	time = quic_cong_time(&cong) - 30;
+	ack_delay = 2;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 30);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 30);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 137146);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 173436);
+	KUNIT_EXPECT_EQ(test, cong.rto, 310582);
+
+	time = quic_cong_time(&cong) - 3;
+	ack_delay = 0;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 3);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 3);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 120003);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 160077);
+	KUNIT_EXPECT_EQ(test, cong.rto, 280080);
+
+	time = quic_cong_time(&cong) - 1;
+	ack_delay = 0;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 1);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 1);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 105002);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 146308);
+	KUNIT_EXPECT_EQ(test, cong.rto, 251310);
+
+	time = quic_cong_time(&cong) - 0;
+	ack_delay = 0;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 0);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 0);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 91876);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 132700);
+	KUNIT_EXPECT_EQ(test, cong.rto, 224576);
+
+	time = quic_cong_time(&cong) - 3;
+	ack_delay = 0;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 3);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 3);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 80391);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 119622);
+	KUNIT_EXPECT_EQ(test, cong.rto, 200013);
+
+	time = quic_cong_time(&cong) - 300;
+	ack_delay = 25;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 300);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 3);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 70354);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 107280);
+	KUNIT_EXPECT_EQ(test, cong.rto, 177634);
+
+	time = quic_cong_time(&cong) - 300;
+	ack_delay = 25;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 300);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 3);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 61572);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 95828);
+	KUNIT_EXPECT_EQ(test, cong.rto, 157400);
+
+	time = quic_cong_time(&cong) - 3000;
+	ack_delay = 250;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 3000);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 3);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 54000);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 85121);
+	KUNIT_EXPECT_EQ(test, cong.rto, 139121);
+
+	time = quic_cong_time(&cong) - 0;
+	ack_delay = 0;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 0);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 0);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 47250);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 75653);
+	KUNIT_EXPECT_EQ(test, cong.rto, 122903);
+
+	time = quic_cong_time(&cong) - 0;
+	ack_delay = 0;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 0);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 0);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 41343);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 67075);
+	KUNIT_EXPECT_EQ(test, cong.rto, 108418);
+
+	time = quic_cong_time(&cong) - 30000;
+	ack_delay = 2500;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 30000);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 30000);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 39925);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 52787);
+	KUNIT_EXPECT_EQ(test, cong.rto, 100000);
+
+	time = quic_cong_time(&cong) - 30000;
+	ack_delay = 2500;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 30000);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 30000);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 38684);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 41761);
+	KUNIT_EXPECT_EQ(test, cong.rto, 100000);
+
+	time = quic_cong_time(&cong) - 3000000;
+	ack_delay = 2500;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 3000000);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 30000);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 406348);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 674733);
+	KUNIT_EXPECT_EQ(test, cong.rto, 1081081);
+
+	time = quic_cong_time(&cong) - 3000000;
+	ack_delay = 2500;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 3000000);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 30000);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 728054);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 1069036);
+	KUNIT_EXPECT_EQ(test, cong.rto, 1797090);
+
+	time = quic_cong_time(&cong) - 3000000;
+	ack_delay = 2500;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 3000000);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 30000);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 1009547);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 1294390);
+	KUNIT_EXPECT_EQ(test, cong.rto, 2303937);
+
+	time = quic_cong_time(&cong) - 6000000;
+	ack_delay = 2500;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 6000000);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 30000);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 1630853);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 2058079);
+	KUNIT_EXPECT_EQ(test, cong.rto, 3688932);
+
+	time = quic_cong_time(&cong) - 10000000;
+	ack_delay = 2500;
+	quic_cong_rtt_update(&cong, time, ack_delay);
+	KUNIT_EXPECT_EQ(test, cong.latest_rtt, 10000000);
+	KUNIT_EXPECT_EQ(test, cong.min_rtt, 30000);
+	KUNIT_EXPECT_EQ(test, cong.smoothed_rtt, 2674496);
+	KUNIT_EXPECT_EQ(test, cong.rttvar, 3369935);
+	KUNIT_EXPECT_EQ(test, cong.rto, 6000000);
+}
+
+static void quic_cong_test2(struct kunit *test)
+{
+	struct quic_transport_param p = {};
+	struct quic_cong cong = {};
+	struct quic_config c = {};
+	u32 time, bytes;
+
+	p.max_data = 106496;
+	p.max_ack_delay = 25000;
+	p.ack_delay_exponent = 3;
+	quic_cong_set_param(&cong, &p);
+
+	quic_cong_set_mss(&cong, 1400);
+	quic_cong_set_window(&cong, 14720);
+
+	c.congestion_control_algo = QUIC_CONG_ALG_RENO;
+	c.initial_smoothed_rtt = 333000;
+	quic_cong_set_config(&cong, &c);
+
+	KUNIT_EXPECT_EQ(test, cong.mss, 1400);
+	KUNIT_EXPECT_EQ(test, cong.window, 14720);
+	KUNIT_EXPECT_EQ(test, cong.max_window, 106496);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_SLOW_START);
+	KUNIT_EXPECT_EQ(test, cong.ssthresh, U32_MAX);
+
+	quic_cong_set_time(&cong, jiffies_to_usecs(jiffies));
+	/* slow_start:  cwnd increases by bytes after SACK */
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 1400;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.window, 16120);
+
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 7000;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.window, 23120);
+
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 14000;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.window, 37120);
+
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 28000;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.window, 65120);
+
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 56000;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.window, 106496);
+
+	/* slow_start -> recovery: go to recovery after one loss */
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 1400;
+	quic_cong_on_packet_lost(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_RECOVERY_PERIOD);
+	KUNIT_EXPECT_EQ(test, cong.ssthresh, 53248);
+	KUNIT_EXPECT_EQ(test, cong.window, 53248);
+
+	/* recovery: no cwnd update after more loss */
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 1400;
+	quic_cong_on_packet_lost(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_RECOVERY_PERIOD);
+	KUNIT_EXPECT_EQ(test, cong.ssthresh, 53248);
+	KUNIT_EXPECT_EQ(test, cong.window, 53248);
+
+	/* recovery -> cong_avoid: go to cong_avoid after SACK if recovery_time < time */
+	msleep(20);
+	quic_cong_set_time(&cong, jiffies_to_usecs(jiffies));
+	time = quic_cong_time(&cong);
+	bytes = 1400;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_CONGESTION_AVOIDANCE);
+
+	/* cong_avoid: cwnd increase by 'mss * bytes / cwnd' after SACK */
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 1400;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_CONGESTION_AVOIDANCE);
+	KUNIT_EXPECT_EQ(test, cong.window, 53284);
+
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 1400;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_CONGESTION_AVOIDANCE);
+	KUNIT_EXPECT_EQ(test, cong.window, 53320);
+
+	/* cong_avoid -> recovery: go back to recovery after one loss */
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 1400;
+	quic_cong_on_packet_lost(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_RECOVERY_PERIOD);
+	KUNIT_EXPECT_EQ(test, cong.ssthresh, 26660);
+	KUNIT_EXPECT_EQ(test, cong.window, 26660);
+
+	/* recovery: no update after SACK if recovery_time >= time */
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 1400;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_RECOVERY_PERIOD);
+	KUNIT_EXPECT_EQ(test, cong.window, 26660);
+
+	/* recovery -> slow_start: go back to start if in persistent congestion */
+	time = quic_cong_time(&cong) - 5000000;
+	bytes = 1400;
+	quic_cong_on_packet_lost(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_SLOW_START);
+	KUNIT_EXPECT_EQ(test, cong.ssthresh, 26660);
+	KUNIT_EXPECT_EQ(test, cong.window, 2800);
+
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 20000;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_SLOW_START);
+	KUNIT_EXPECT_EQ(test, cong.window, 22800);
+
+	/* slow_start -> recovery: go to recovery after ECN */
+	quic_cong_on_process_ecn(&cong);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_RECOVERY_PERIOD);
+	KUNIT_EXPECT_EQ(test, cong.ssthresh, 11400);
+	KUNIT_EXPECT_EQ(test, cong.window, 11400);
+
+	/* recovery: no update after ECN */
+	quic_cong_on_process_ecn(&cong);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_RECOVERY_PERIOD);
+	KUNIT_EXPECT_EQ(test, cong.window, 11400);
+
+	/* recovery -> cong_avoid: go to cong_avoid after SACK if recovery_time < time */
+	time = quic_cong_time(&cong) + 20;
+	quic_cong_set_time(&cong, time);
+	bytes = 1400;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_CONGESTION_AVOIDANCE);
+
+	/* cong_avoid -> slow_start: go back to start if in persistent congestion */
+	time = quic_cong_time(&cong) - 5000000;
+	bytes = 1400;
+	quic_cong_on_packet_lost(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_SLOW_START);
+	KUNIT_EXPECT_EQ(test, cong.ssthresh, 11400);
+	KUNIT_EXPECT_EQ(test, cong.window, 2800);
+
+	/* slow_start -> cong_avoid: go to cong_void after SACK if cwnd > ssthresh */
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 10532;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_CONGESTION_AVOIDANCE);
+	KUNIT_EXPECT_EQ(test, cong.window, 13332);
+	KUNIT_EXPECT_EQ(test, cong.ssthresh, 11400);
+
+	/* cong_avoid -> recovery: go back to recovery after ECN */
+	quic_cong_on_process_ecn(&cong);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_RECOVERY_PERIOD);
+	KUNIT_EXPECT_EQ(test, cong.window, 6666);
+}
+
+static void quic_cong_test3(struct kunit *test)
+{
+	struct quic_transport_param p = {};
+	struct quic_cong cong = {};
+	struct quic_config c = {};
+	u32 time, bytes;
+	u64 number;
+
+	p.max_data = 106496;
+	p.max_ack_delay = 25000;
+	p.ack_delay_exponent = 3;
+	quic_cong_set_param(&cong, &p);
+
+	quic_cong_set_mss(&cong, 1400);
+	quic_cong_set_window(&cong, 14720);
+
+	c.congestion_control_algo = QUIC_CONG_ALG_CUBIC;
+	c.initial_smoothed_rtt = 333000;
+	quic_cong_set_config(&cong, &c);
+
+	KUNIT_EXPECT_EQ(test, cong.mss, 1400);
+	KUNIT_EXPECT_EQ(test, cong.window, 14720);
+	KUNIT_EXPECT_EQ(test, cong.max_window, 106496);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_SLOW_START);
+	KUNIT_EXPECT_EQ(test, cong.ssthresh, U32_MAX);
+
+	quic_cong_set_time(&cong, jiffies_to_usecs(jiffies));
+	/* slow_start:  cwnd increases by bytes after SACK */
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 1400;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.window, 16120);
+
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 7000;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.window, 23120);
+
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 14000;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.window, 37120);
+
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 28000;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.window, 65120);
+
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 56000;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.window, 106496);
+
+	/* slow_start -> recovery: go to recovery after one loss */
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 1400;
+	quic_cong_on_packet_lost(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_RECOVERY_PERIOD);
+	KUNIT_EXPECT_EQ(test, cong.ssthresh, 74547);
+	KUNIT_EXPECT_EQ(test, cong.window, 74547);
+
+	/* recovery: no cwnd update after more loss */
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 1400;
+	quic_cong_on_packet_lost(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_RECOVERY_PERIOD);
+	KUNIT_EXPECT_EQ(test, cong.ssthresh, 74547);
+	KUNIT_EXPECT_EQ(test, cong.window, 74547);
+
+	/* recovery -> cong_avoid: go to cong_avoid after SACK if recovery_time < time */
+	time = quic_cong_time(&cong) + 20;
+	quic_cong_set_time(&cong, time);
+	bytes = 1400;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_CONGESTION_AVOIDANCE);
+
+	/* cong_avoid: cwnd increase in Reno-friendly after SACK */
+	time = quic_cong_time(&cong) + 100000;
+	quic_cong_set_time(&cong, time);
+	bytes = 8400;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_CONGESTION_AVOIDANCE);
+	KUNIT_EXPECT_EQ(test, cong.window, 74547 + 2);
+
+	time = quic_cong_time(&cong) + 100000;
+	quic_cong_set_time(&cong, time);
+	bytes = 8400;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_CONGESTION_AVOIDANCE);
+	KUNIT_EXPECT_EQ(test, cong.window, 74547 + 2 + 5);
+
+	time = quic_cong_time(&cong) + 100000;
+	quic_cong_set_time(&cong, time);
+	bytes = 8400;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_CONGESTION_AVOIDANCE);
+	KUNIT_EXPECT_EQ(test, cong.window, 74547 + 2 + 5 + 8);
+
+	time = quic_cong_time(&cong) + 100000;
+	quic_cong_set_time(&cong, time);
+	bytes = 8400;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_CONGESTION_AVOIDANCE);
+	KUNIT_EXPECT_EQ(test, cong.window, 74547 + 2 + 5 + 8 + 11);
+
+	time = quic_cong_time(&cong) + 100000;
+	quic_cong_set_time(&cong, time);
+	bytes = 8400;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_CONGESTION_AVOIDANCE);
+	KUNIT_EXPECT_EQ(test, cong.window, 74547 + 2 + 5 + 8 + 11 + 14); /* 74587 */
+
+	/* cong_avoid: cwnd increase in concave/Convex after SACK */
+	time = quic_cong_time(&cong) + 100000;
+	quic_cong_set_time(&cong, time);
+	bytes = 8400;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_CONGESTION_AVOIDANCE);
+	KUNIT_EXPECT_EQ(test, cong.window, 74587 + 126);
+
+	time = quic_cong_time(&cong) + 5000;
+	quic_cong_set_time(&cong, time);
+	bytes = 8400;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_CONGESTION_AVOIDANCE);
+	KUNIT_EXPECT_EQ(test, cong.window, 74587 + 126 + 136);
+
+	time = quic_cong_time(&cong) + 5000;
+	quic_cong_set_time(&cong, time);
+	bytes = 8400;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_CONGESTION_AVOIDANCE);
+	KUNIT_EXPECT_EQ(test, cong.window, 74587 + 126 + 136 + 142);
+
+	time = quic_cong_time(&cong) + 5000;
+	quic_cong_set_time(&cong, time);
+	bytes = 8400;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_CONGESTION_AVOIDANCE);
+	KUNIT_EXPECT_EQ(test, cong.window, 74587 + 126 + 136 + 142 + 149);
+
+	time = quic_cong_time(&cong) + 5000;
+	quic_cong_set_time(&cong, time);
+	bytes = 8400;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_CONGESTION_AVOIDANCE);
+	KUNIT_EXPECT_EQ(test, cong.window, 74587 + 126 + 136 + 142 + 149 + 156); /* 75296 */
+
+	/* cong_avoid -> recovery: go back to recovery after one loss */
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 1400;
+	quic_cong_on_packet_lost(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_RECOVERY_PERIOD);
+	KUNIT_EXPECT_EQ(test, cong.ssthresh, 52707);
+	KUNIT_EXPECT_EQ(test, cong.window, 52707);
+
+	/* recovery: no update after SACK if recovery_time >= time */
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 1400;
+	quic_cong_on_packet_acked(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_RECOVERY_PERIOD);
+	KUNIT_EXPECT_EQ(test, cong.window, 52707);
+
+	/* recovery -> slow_start: go back to start if in persistent congestion */
+	time = quic_cong_time(&cong) - 5000000;
+	bytes = 1400;
+	quic_cong_on_packet_lost(&cong, time, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_SLOW_START);
+	KUNIT_EXPECT_EQ(test, cong.ssthresh, 52707);
+	KUNIT_EXPECT_EQ(test, cong.window, 2800);
+
+	/* test hystart++ */
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 1400;
+	number = 100;
+	quic_cong_on_packet_sent(&cong, time, bytes, number);
+	/*
+	 * cubic->window_end = 100;
+	 * cubic->last_round_min_rtt = U32_MAX;
+	 * cubic->rtt_sample_count = 0;
+	 */
+	quic_cong_rtt_update(&cong, time, 0);
+	/*
+	 * cubic->current_round_min_rtt = 300000
+	 * cubic->css_baseline_min_rtt = U32_MAX;
+	 * cubic->css_rounds = 0;
+	 * cubic->rtt_sample_count = 1;
+	 */
+	time = quic_cong_time(&cong) - 300000;
+	bytes = 14000;
+	number = 100;
+	quic_cong_on_packet_acked(&cong, time, bytes, number);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_SLOW_START);
+	KUNIT_EXPECT_EQ(test, cong.window, 16800);
+
+	/* new round */
+	time = quic_cong_time(&cong) - 500000;
+	bytes = 1400;
+	number = 110;
+	quic_cong_on_packet_sent(&cong, time, bytes, number);
+	/*
+	 * cubic->window_end = 110;
+	 * cubic->last_round_min_rtt = cubic->current_round_min_rtt;
+	 * cubic->rtt_sample_count = 0;
+	 */
+	quic_cong_rtt_update(&cong, time, 0);
+	/*
+	 * cubic->current_round_min_rtt = 500000
+	 * cubic->css_baseline_min_rtt = U32_MAX;
+	 * cubic->css_rounds = 0;
+	 * cubic->rtt_sample_count = 1;
+	 */
+	time = quic_cong_time(&cong) - 500000;
+	bytes = 14000;
+	number = 101;
+	quic_cong_on_packet_acked(&cong, time, bytes, number);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_SLOW_START);
+	KUNIT_EXPECT_EQ(test, cong.window, 30800);
+
+	/* in CSS */
+	quic_cong_rtt_update(&cong, time, 0);
+	quic_cong_rtt_update(&cong, time, 0);
+	quic_cong_rtt_update(&cong, time, 0);
+	quic_cong_rtt_update(&cong, time, 0);
+	quic_cong_rtt_update(&cong, time, 0);
+	quic_cong_rtt_update(&cong, time, 0);
+	quic_cong_rtt_update(&cong, time, 0);
+	/* cubic->rtt_sample_count = 8, and enter CSS */
+	time = quic_cong_time(&cong) - 500000;
+	bytes = 4800;
+	number = 102;
+	quic_cong_on_packet_acked(&cong, time, bytes, number);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_SLOW_START);
+	KUNIT_EXPECT_EQ(test, cong.window, 35600);
+	/* cubic->css_baseline_min_rtt = 500000 */
+	time = quic_cong_time(&cong) - 500000;
+	bytes = 4800;
+	number = 103;
+	quic_cong_on_packet_acked(&cong, time, bytes, number);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_SLOW_START);
+	KUNIT_EXPECT_EQ(test, cong.window, 36800);
+	/* cubic->rtt_sample_count = 1 */
+	time = quic_cong_time(&cong) - 500000;
+	bytes = 4800;
+	number = 104;
+	quic_cong_on_packet_acked(&cong, time, bytes, number);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_SLOW_START);
+	KUNIT_EXPECT_EQ(test, cong.window, 38000);
+	/* cubic->rtt_sample_count = 2 */
+	time = quic_cong_time(&cong) - 500000;
+	bytes = 4800;
+	number = 104;
+	quic_cong_on_packet_acked(&cong, time, bytes, number);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_SLOW_START);
+	KUNIT_EXPECT_EQ(test, cong.window, 39200);
+	/* cubic->rtt_sample_count = 3 */
+	time = quic_cong_time(&cong) - 500000;
+	bytes = 4800;
+	number = 105;
+	quic_cong_on_packet_acked(&cong, time, bytes, number);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_SLOW_START);
+	KUNIT_EXPECT_EQ(test, cong.window, 40400);
+	/* cubic->rtt_sample_count = 4 */
+	time = quic_cong_time(&cong) - 500000;
+	bytes = 4800;
+	number = 106;
+	quic_cong_on_packet_acked(&cong, time, bytes, number);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_SLOW_START);
+	KUNIT_EXPECT_EQ(test, cong.window, 41600);
+	/* cubic->rtt_sample_count = 5 */
+
+	 /* slow_start -> cong_avoid: go to cong_void after SACK if cwnd > ssthresh */
+	time = quic_cong_time(&cong) - 500000;
+	bytes = 4800;
+	number = 107;
+	quic_cong_on_packet_acked(&cong, time, bytes, number);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_CONGESTION_AVOIDANCE);
+	KUNIT_EXPECT_EQ(test, cong.window, 42800);
+	/* cubic->rtt_sample_count = 6 */
+
+	/* cong_avoid -> recovery: go back to recovery after ECN */
+	quic_cong_on_process_ecn(&cong);
+	KUNIT_EXPECT_EQ(test, cong.state, QUIC_CONG_RECOVERY_PERIOD);
+	KUNIT_EXPECT_EQ(test, cong.window, 29960);
+}
+
+static struct kunit_case quic_test_cases[] = {
+	KUNIT_CASE(quic_pnspace_test1),
+	KUNIT_CASE(quic_pnspace_test2),
+	KUNIT_CASE(quic_crypto_test1),
+	KUNIT_CASE(quic_crypto_test2),
+	KUNIT_CASE(quic_cong_test1),
+	KUNIT_CASE(quic_cong_test2),
+	KUNIT_CASE(quic_cong_test3),
+	{}
+};
+
+static struct kunit_suite quic_test_suite = {
+	.name = "quic",
+	.test_cases = quic_test_cases,
+};
+
+kunit_test_suite(quic_test_suite);
+
+MODULE_DESCRIPTION("Test QUIC Kernel API functions");
+MODULE_LICENSE("GPL");
diff --git a/net/quic/timer.c b/net/quic/timer.c
new file mode 100644
index 000000000000..52ea2d57847a
--- /dev/null
+++ b/net/quic/timer.c
@@ -0,0 +1,302 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* QUIC kernel implementation
+ * (C) Copyright Red Hat Corp. 2023
+ *
+ * This file is part of the QUIC kernel implementation
+ *
+ * Written or modified by:
+ *    Xin Long <lucien.xin@gmail.com>
+ */
+
+#include "socket.h"
+
+void quic_timer_sack_handler(struct sock *sk)
+{
+	u8 level = QUIC_CRYPTO_APP, buf[100] = {};
+	struct quic_connection_close *close;
+	struct quic_inqueue *inq;
+	struct quic_frame *frame;
+	u32 timeout;
+
+	if (quic_is_closed(sk))
+		return;
+
+	inq = quic_inq(sk);
+	if (quic_inq_need_sack(inq)) {
+		if (quic_inq_need_sack(inq) == 2) {
+			frame = quic_frame_create(sk, QUIC_FRAME_ACK, &level);
+			if (frame)
+				quic_outq_ctrl_tail(sk, frame, true);
+		}
+		quic_outq_transmit(sk);
+		quic_inq_set_need_sack(inq, 0);
+
+		timeout = quic_inq_max_idle_timeout(inq);
+		quic_timer_start(sk, QUIC_TIMER_SACK, timeout);
+		return;
+	}
+
+	close = (void *)buf;
+	if (quic_inq_event_recv(sk, QUIC_EVENT_CONNECTION_CLOSE, close)) {
+		timeout = quic_inq_max_idle_timeout(inq);
+		quic_timer_start(sk, QUIC_TIMER_SACK, timeout);
+		return;
+	}
+	quic_set_state(sk, QUIC_SS_CLOSED);
+	pr_debug("%s: idle timeout\n", __func__);
+}
+
+static void quic_timer_sack_timeout(struct timer_list *t)
+{
+	struct quic_sock *qs = from_timer(qs, t, timers[QUIC_TIMER_SACK].t);
+	struct sock *sk = &qs->inet.sk;
+
+	bh_lock_sock(sk);
+	if (sock_owned_by_user(sk)) {
+		if (!test_and_set_bit(QUIC_SACK_DEFERRED, &sk->sk_tsq_flags))
+			sock_hold(sk);
+		goto out;
+	}
+
+	quic_timer_sack_handler(sk);
+out:
+	bh_unlock_sock(sk);
+	sock_put(sk);
+}
+
+void quic_timer_loss_handler(struct sock *sk, u8 level)
+{
+	struct quic_pnspace *space;
+
+	if (quic_is_closed(sk))
+		return;
+
+	space = quic_pnspace(sk, level);
+	if (quic_pnspace_loss_time(space)) {
+		if (quic_outq_retransmit_mark(sk, level, 0))
+			quic_outq_transmit(sk);
+		return;
+	}
+
+	if (quic_pnspace_last_sent_time(space))
+		quic_outq_transmit_one(sk, level);
+}
+
+static void quic_timer_ap_loss_timeout(struct timer_list *t)
+{
+	struct quic_sock *qs = from_timer(qs, t, timers[QUIC_TIMER_AP_LOSS].t);
+	struct sock *sk = &qs->inet.sk;
+
+	bh_lock_sock(sk);
+	if (sock_owned_by_user(sk)) {
+		if (!test_and_set_bit(QUIC_AP_LOSS_DEFERRED, &sk->sk_tsq_flags))
+			sock_hold(sk);
+		goto out;
+	}
+
+	quic_timer_loss_handler(sk, QUIC_TIMER_AP_LOSS);
+out:
+	bh_unlock_sock(sk);
+	sock_put(sk);
+}
+
+static void quic_timer_in_loss_timeout(struct timer_list *t)
+{
+	struct quic_sock *qs = from_timer(qs, t, timers[QUIC_TIMER_IN_LOSS].t);
+	struct sock *sk = &qs->inet.sk;
+
+	bh_lock_sock(sk);
+	if (sock_owned_by_user(sk)) {
+		if (!test_and_set_bit(QUIC_IN_LOSS_DEFERRED, &sk->sk_tsq_flags))
+			sock_hold(sk);
+		goto out;
+	}
+
+	quic_timer_loss_handler(sk, QUIC_TIMER_IN_LOSS);
+out:
+	bh_unlock_sock(sk);
+	sock_put(sk);
+}
+
+static void quic_timer_hs_loss_timeout(struct timer_list *t)
+{
+	struct quic_sock *qs = from_timer(qs, t, timers[QUIC_TIMER_HS_LOSS].t);
+	struct sock *sk = &qs->inet.sk;
+
+	bh_lock_sock(sk);
+	if (sock_owned_by_user(sk)) {
+		if (!test_and_set_bit(QUIC_HS_LOSS_DEFERRED, &sk->sk_tsq_flags))
+			sock_hold(sk);
+		goto out;
+	}
+
+	quic_timer_loss_handler(sk, QUIC_TIMER_HS_LOSS);
+out:
+	bh_unlock_sock(sk);
+	sock_put(sk);
+}
+
+void quic_timer_path_handler(struct sock *sk)
+{
+	struct quic_path_addr *path;
+	struct quic_packet *packet;
+	struct quic_frame *frame;
+	u8 cnt, probe = 1;
+	u32 timeout;
+
+	if (quic_is_closed(sk))
+		return;
+
+	timeout = quic_cong_rto(quic_cong(sk)) * 3;
+	packet = quic_packet(sk);
+	path = quic_src(sk);
+	cnt = quic_path_sent_cnt(path);
+	if (cnt) {
+		probe = 0;
+		if (cnt >= 5) {
+			quic_path_set_sent_cnt(path, 0);
+			quic_packet_set_ecn_probes(packet, 0);
+			return;
+		}
+		frame = quic_frame_create(sk, QUIC_FRAME_PATH_CHALLENGE, path);
+		if (frame)
+			quic_outq_ctrl_tail(sk, frame, false);
+		quic_path_set_sent_cnt(path, cnt + 1);
+		quic_timer_start(sk, QUIC_TIMER_PATH, timeout);
+	}
+
+	path = quic_dst(sk);
+	cnt = quic_path_sent_cnt(path);
+	if (cnt) {
+		probe = 0;
+		if (cnt >= 5) {
+			quic_path_set_sent_cnt(path, 0);
+			quic_path_swap_active(path);
+			quic_packet_set_ecn_probes(packet, 0);
+			return;
+		}
+		frame = quic_frame_create(sk, QUIC_FRAME_PATH_CHALLENGE, path);
+		if (frame)
+			quic_outq_ctrl_tail(sk, frame, false);
+		quic_path_set_sent_cnt(path, cnt + 1);
+		quic_timer_start(sk, QUIC_TIMER_PATH, timeout);
+	}
+
+	if (probe)
+		quic_outq_transmit_probe(sk);
+}
+
+static void quic_timer_path_timeout(struct timer_list *t)
+{
+	struct quic_sock *qs = from_timer(qs, t, timers[QUIC_TIMER_PATH].t);
+	struct sock *sk = &qs->inet.sk;
+
+	bh_lock_sock(sk);
+	if (sock_owned_by_user(sk)) {
+		if (!test_and_set_bit(QUIC_PATH_DEFERRED, &sk->sk_tsq_flags))
+			sock_hold(sk);
+		goto out;
+	}
+
+	quic_timer_path_handler(sk);
+out:
+	bh_unlock_sock(sk);
+	sock_put(sk);
+}
+
+void quic_timer_pace_handler(struct sock *sk)
+{
+	if (quic_is_closed(sk))
+		return;
+	quic_outq_transmit(sk);
+}
+
+static enum hrtimer_restart quic_timer_pace_timeout(struct hrtimer *hr)
+{
+	struct quic_sock *qs = container_of(hr, struct quic_sock, timers[QUIC_TIMER_PACE].hr);
+	struct sock *sk = &qs->inet.sk;
+
+	bh_lock_sock(sk);
+	if (sock_owned_by_user(sk)) {
+		if (!test_and_set_bit(QUIC_TSQ_DEFERRED, &sk->sk_tsq_flags))
+			sock_hold(sk);
+		goto out;
+	}
+
+	quic_timer_pace_handler(sk);
+out:
+	bh_unlock_sock(sk);
+	sock_put(sk);
+	return HRTIMER_NORESTART;
+}
+
+void quic_timer_reset(struct sock *sk, u8 type, u64 timeout)
+{
+	struct timer_list *t = quic_timer(sk, type);
+
+	if (timeout && !mod_timer(t, jiffies + usecs_to_jiffies(timeout)))
+		sock_hold(sk);
+}
+
+void quic_timer_reduce(struct sock *sk, u8 type, u64 timeout)
+{
+	struct timer_list *t = quic_timer(sk, type);
+
+	if (timeout && !timer_reduce(t, jiffies + usecs_to_jiffies(timeout)))
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
+			hrtimer_start(hr, ns_to_ktime(timeout), HRTIMER_MODE_ABS_PINNED_SOFT);
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
+	if (type == QUIC_TIMER_PACE)
+		return;
+	if (del_timer(quic_timer(sk, type)))
+		sock_put(sk);
+}
+
+void quic_timer_init(struct sock *sk)
+{
+	struct hrtimer *hr;
+
+	timer_setup(quic_timer(sk, QUIC_TIMER_AP_LOSS), quic_timer_ap_loss_timeout, 0);
+	timer_setup(quic_timer(sk, QUIC_TIMER_IN_LOSS), quic_timer_in_loss_timeout, 0);
+	timer_setup(quic_timer(sk, QUIC_TIMER_HS_LOSS), quic_timer_hs_loss_timeout, 0);
+	timer_setup(quic_timer(sk, QUIC_TIMER_SACK), quic_timer_sack_timeout, 0);
+	timer_setup(quic_timer(sk, QUIC_TIMER_PATH), quic_timer_path_timeout, 0);
+
+	hr = quic_timer(sk, QUIC_TIMER_PACE);
+	hrtimer_init(hr, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED_SOFT);
+	hr->function = quic_timer_pace_timeout;
+}
+
+void quic_timer_free(struct sock *sk)
+{
+	quic_timer_stop(sk, QUIC_TIMER_AP_LOSS);
+	quic_timer_stop(sk, QUIC_TIMER_IN_LOSS);
+	quic_timer_stop(sk, QUIC_TIMER_HS_LOSS);
+	quic_timer_stop(sk, QUIC_TIMER_SACK);
+	quic_timer_stop(sk, QUIC_TIMER_PATH);
+	quic_timer_stop(sk, QUIC_TIMER_PACE);
+}
diff --git a/net/quic/timer.h b/net/quic/timer.h
new file mode 100644
index 000000000000..3c0bb267b8f5
--- /dev/null
+++ b/net/quic/timer.h
@@ -0,0 +1,43 @@
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
+	QUIC_TIMER_AP_LOSS = QUIC_CRYPTO_APP,
+	QUIC_TIMER_IN_LOSS = QUIC_CRYPTO_INITIAL,
+	QUIC_TIMER_HS_LOSS = QUIC_CRYPTO_HANDSHAKE,
+	QUIC_TIMER_SACK,
+	QUIC_TIMER_PATH,
+	QUIC_TIMER_PACE,
+	QUIC_TIMER_MAX,
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
+#define QUIC_MIN_IDLE_TIMEOUT	1000000
+#define QUIC_DEF_IDLE_TIMEOUT	30000000
+
+void quic_timer_reduce(struct sock *sk, u8 type, u64 timeout);
+void quic_timer_reset(struct sock *sk, u8 type, u64 timeout);
+void quic_timer_start(struct sock *sk, u8 type, u64 timeout);
+void quic_timer_stop(struct sock *sk, u8 type);
+void quic_timer_init(struct sock *sk);
+void quic_timer_free(struct sock *sk);
+
+void quic_timer_loss_handler(struct sock *sk, u8 level);
+void quic_timer_pace_handler(struct sock *sk);
+void quic_timer_path_handler(struct sock *sk);
+void quic_timer_sack_handler(struct sock *sk);
-- 
2.43.0

