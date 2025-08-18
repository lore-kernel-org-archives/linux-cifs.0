Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B38343D64;
	Mon, 18 Aug 2025 14:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526373; cv=none; b=HcN7ctaEgchOp8+Ap+YZYvvtSG+MVZIvGRRoKnIW+WSNs3kG9WQCayHMuM6c+N9A2lpnSz1pSs3qrIHTtyYlD1W5l7k4K3jmtvTrdJPUa/F1eqw0WksnohG4n1dOTLZhynkhLhf4W1SHThrgjtxNE7JQblaLfg+6pTX0bKFyGb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526373; c=relaxed/simple;
	bh=8wUeLCJXx3eypVR3yMlT7AWxTC/+6q6yLMUJuZYlt/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlnPfpZl+vAIArhgnn/IpHozGQb2vpx3ov2lRhI80k48LgUtcx34pSftbSPKlfTHVGBENouRy3J4obJzwPdJi9IEiQJxAH4eQd57EBY1pf7zPcSz+NoamOXbj7Qi5H9Vz2r9QtCiF72Ptklcfkd2npuuDKGmdhHFeQpP2J+2JIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aQfh2TmA; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aQfh2TmA"
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e934c8f9757so1161213276.2;
        Mon, 18 Aug 2025 07:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755526370; x=1756131170; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pu6fukY55pR9cBFtQwREOdw2dmy5xFFW7YF/Cjnm3hc=;
        b=aQfh2TmAMfJ3mkgDzGIUMu/W7z6fTsMFZrCt5zw5HdLlmCTYn5exM+ot2tvjnlNYPW
         T/0yP5KSuxRCEto7zwWhNP5ky/KIGqV8LFxpI5DRVi4v42064ysuAoipQFPa1I+Qg8VZ
         nrBWI8CZae9QPv18SdpfXrcIXKM+/k+PwZRqeQXYO4fi6qQNJYNc4xA/IFn0Ipbu8xcj
         xnZVCvneS0rMTfG8Jp5GGDletddj+5ABY9JHt5Z5NAs1p0m7Frim8nOwzV1ulJ8CF4ZM
         ucSS3nbNck9oXpsp+xYAg7rvNmF6b7eLuVoLBIHTdfGFkKoQO54tPPsDGwspbDuRnoRe
         qu2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755526370; x=1756131170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pu6fukY55pR9cBFtQwREOdw2dmy5xFFW7YF/Cjnm3hc=;
        b=gzCazFv3GXiZ8o1O+r6WKGyZAGn3EpaR3kfc3x+yLQiit0KXx84onyfhrCsCstpQge
         DmAjr6KXbfFLJgwUUgRtuYVNQ/NRPFYJ0kYJOdYlO5W4kPqdOLOm49sI39Cg45a0x90d
         wVFShVx6/ridBgKzMZ/yPV59iqhXfG8uqWE8+zzDsIGj98R7yMLcdjVmc4MLKLB3fmQg
         rfc+dfIPfjdyLKsd7eY6vz3V38v1SosFVgq2PzYqqz4AuB7M3C743EuxqjaU4Spe4Yxc
         ew5QBxzdvVBRsHYhZnesODrqoX7VcZcII7R//2ESDwK4m1KPHSB0za+ZtA9Ggo+y8dDP
         GwYA==
X-Forwarded-Encrypted: i=1; AJvYcCWJbW11DMF+eBeVWEda5FkGXPVicd6qLKnjelbjVJABwzf0uEhXjkSUMYyrssuI5gIpqrh9lPY8H81p@vger.kernel.org
X-Gm-Message-State: AOJu0YygVLWj1o67uYcUQLPOKsQYP9bWTK6LLpaRPk8eehwdKHIIiLY9
	Ann9KYlMsSsLV/l6sfvRqyGUgwa94CYmEdBNUhRqdu6gHWmF+JSGuVjLNUjBJpLeSG0=
X-Gm-Gg: ASbGnctOm4QfBXPRKsyaD4AP9grfqwPIqFmkyErUEocSNVndEdxO7YWjT9EW29vyul1
	xDTrUVc2FNcgtxMFUWtvrsqpQN/t5p9bmLuVj06raEcItBk+LEvTT1xZzjJ9EDwNXIxn5CrZ0M2
	C0P9iigQ0PCImUA9jIS7gkdCW9QEmRMkV1T0bwNadlR26nnWXbhb5WwJfWskld0USTpZB/hwr7I
	fYpOkTc5koVaa29FyjKMRdTsbz87uj9wkJjWB7wP1L+woxX5Q8iIvHFt82Bw1DhbelRdXzdDxdF
	ZwmO/yXextK/knX9oXl3mDT5e0Cg87l+WTauHLQWaeunE8BGl3PZ6fbLkaafNeYAczrrpWkMZPE
	n1XtJGHxeS9zZtFd9E2WAHod8qfFZmNZsbqQd6tgsmuTInWDMdPDszQ+QiFx/ax7iLCijEpHJSM
	Du4nhBX4gt
X-Google-Smtp-Source: AGHT+IESzjWmNF5wnINXMWM6F6aBV20/AVMPw/JuuEv+nPjArnaIZJ1V4gcXZL0A05jmxTFxn+Q1tA==
X-Received: by 2002:a05:6902:1107:b0:e93:b92c:ee20 with SMTP id 3f1490d57ef6-e93b997c0a9mr4865614276.6.1755526369797;
        Mon, 18 Aug 2025 07:12:49 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e933261c40bsm3157451276.8.2025.08.18.07.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 07:12:49 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>,
	linux-cifs@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Tom Talpey <tom@talpey.com>,
	kernel-tls-handshake@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Steve Dickson <steved@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Alexander Aring <aahringo@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>,
	illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: [PATCH net-next v2 14/15] quic: add frame encoder and decoder base
Date: Mon, 18 Aug 2025 10:04:37 -0400
Message-ID: <6f6549d9476993ea34466da61ebede98bcee629e.1755525878.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1755525878.git.lucien.xin@gmail.com>
References: <cover.1755525878.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduces 'quic_frame' to represent QUIC frames and
'quic_frame_ops' to define the associated operations for encoding,
processing, and acknowledgment.

This abstraction sets the foundation for flexible and modular frame
handling. While core operations are defined, actual implementation
will follow in subsequent patches once packet handling and
inqueue/outqueue infrastructure are in place.

The patch introduces hooks for invoking frame-specific logic:

- quic_frame_create(): Invoke the .create operation of the frame.

- quic_frame_process(): Invoke the .process operation of the frame.

- quic_frame_ack(): Invoke the .ack operation of the frame.

To manage frame lifecycles, reference counting is used, supported by

- quic_frame_get(): Increment the reference count of a frame.

- quic_frame_put(): Decrement the reference count of a frame.

- quic_frame_alloc(): Allocate a frame and set its data.

Frames are allocated through quic_frame_alloc(), and a dedicated
kmem_cache (quic_frame_cachep) is added to optimize memory usage.

For STREAM frames, additional data can be appended using

- quic_frame_stream_append(): Append more data to a STREAM frame.

Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/quic/Makefile   |   2 +-
 net/quic/frame.c    | 558 ++++++++++++++++++++++++++++++++++++++++++++
 net/quic/frame.h    | 195 ++++++++++++++++
 net/quic/protocol.c |   9 +
 net/quic/protocol.h |   1 +
 net/quic/socket.h   |   2 +
 6 files changed, 766 insertions(+), 1 deletion(-)
 create mode 100644 net/quic/frame.c
 create mode 100644 net/quic/frame.h

diff --git a/net/quic/Makefile b/net/quic/Makefile
index 2ccf01ad9e22..645ee470c95e 100644
--- a/net/quic/Makefile
+++ b/net/quic/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_IP_QUIC) += quic.o
 
 quic-y := common.o family.o protocol.o socket.o stream.o connid.o path.o \
-	  cong.o pnspace.o crypto.o timer.o
+	  cong.o pnspace.o crypto.o timer.o frame.o
diff --git a/net/quic/frame.c b/net/quic/frame.c
new file mode 100644
index 000000000000..d1e99c4f4804
--- /dev/null
+++ b/net/quic/frame.c
@@ -0,0 +1,558 @@
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
+static struct quic_frame *quic_frame_ack_create(struct sock *sk, void *data, u8 type)
+{
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_ping_create(struct sock *sk, void *data, u8 type)
+{
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_padding_create(struct sock *sk, void *data, u8 type)
+{
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_new_token_create(struct sock *sk, void *data, u8 type)
+{
+	return NULL;
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
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_handshake_done_create(struct sock *sk, void *data, u8 type)
+{
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_crypto_create(struct sock *sk, void *data, u8 type)
+{
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_retire_conn_id_create(struct sock *sk, void *data, u8 type)
+{
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_new_conn_id_create(struct sock *sk, void *data, u8 type)
+{
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_path_response_create(struct sock *sk, void *data, u8 type)
+{
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_path_challenge_create(struct sock *sk, void *data, u8 type)
+{
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_reset_stream_create(struct sock *sk, void *data, u8 type)
+{
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_stop_sending_create(struct sock *sk, void *data, u8 type)
+{
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_max_data_create(struct sock *sk, void *data, u8 type)
+{
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_max_stream_data_create(struct sock *sk, void *data, u8 type)
+{
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_max_streams_uni_create(struct sock *sk, void *data, u8 type)
+{
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_max_streams_bidi_create(struct sock *sk, void *data, u8 type)
+{
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_connection_close_create(struct sock *sk, void *data, u8 type)
+{
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_data_blocked_create(struct sock *sk, void *data, u8 type)
+{
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_stream_data_blocked_create(struct sock *sk,
+								void *data, u8 type)
+{
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_streams_blocked_uni_create(struct sock *sk,
+								void *data, u8 type)
+{
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_streams_blocked_bidi_create(struct sock *sk,
+								 void *data, u8 type)
+{
+	return NULL;
+}
+
+static int quic_frame_crypto_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_stream_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_ack_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_new_conn_id_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_retire_conn_id_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_new_token_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_handshake_done_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_padding_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_ping_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_path_challenge_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_reset_stream_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_stop_sending_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_max_data_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_max_stream_data_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_max_streams_uni_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_max_streams_bidi_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_connection_close_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_data_blocked_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_stream_data_blocked_process(struct sock *sk, struct quic_frame *frame,
+						  u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_streams_blocked_uni_process(struct sock *sk, struct quic_frame *frame,
+						  u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_streams_blocked_bidi_process(struct sock *sk, struct quic_frame *frame,
+						   u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_path_response_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static struct quic_frame *quic_frame_invalid_create(struct sock *sk, void *data, u8 type)
+{
+	return NULL;
+}
+
+static struct quic_frame *quic_frame_datagram_create(struct sock *sk, void *data, u8 type)
+{
+	return NULL;
+}
+
+static int quic_frame_invalid_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_frame_datagram_process(struct sock *sk, struct quic_frame *frame, u8 type)
+{
+	return -EOPNOTSUPP;
+}
+
+static void quic_frame_padding_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_ping_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_ack_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_reset_stream_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_stop_sending_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_crypto_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_new_token_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_stream_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_max_data_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_max_stream_data_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_max_streams_bidi_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_max_streams_uni_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_data_blocked_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_stream_data_blocked_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_streams_blocked_bidi_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_streams_blocked_uni_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_new_conn_id_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_retire_conn_id_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_path_challenge_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_path_response_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_connection_close_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_handshake_done_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_invalid_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+static void quic_frame_datagram_ack(struct sock *sk, struct quic_frame *frame)
+{
+}
+
+#define quic_frame_create_and_process_and_ack(type, eliciting) \
+	{ \
+		.frame_create	= quic_frame_##type##_create, \
+		.frame_process	= quic_frame_##type##_process, \
+		.frame_ack	= quic_frame_##type##_ack, \
+		.ack_eliciting	= eliciting \
+	}
+
+static struct quic_frame_ops quic_frame_ops[QUIC_FRAME_MAX + 1] = {
+	quic_frame_create_and_process_and_ack(padding, 0), /* 0x00 */
+	quic_frame_create_and_process_and_ack(ping, 1),
+	quic_frame_create_and_process_and_ack(ack, 0),
+	quic_frame_create_and_process_and_ack(ack, 0), /* ack_ecn */
+	quic_frame_create_and_process_and_ack(reset_stream, 1),
+	quic_frame_create_and_process_and_ack(stop_sending, 1),
+	quic_frame_create_and_process_and_ack(crypto, 1),
+	quic_frame_create_and_process_and_ack(new_token, 1),
+	quic_frame_create_and_process_and_ack(stream, 1),
+	quic_frame_create_and_process_and_ack(stream, 1),
+	quic_frame_create_and_process_and_ack(stream, 1),
+	quic_frame_create_and_process_and_ack(stream, 1),
+	quic_frame_create_and_process_and_ack(stream, 1),
+	quic_frame_create_and_process_and_ack(stream, 1),
+	quic_frame_create_and_process_and_ack(stream, 1),
+	quic_frame_create_and_process_and_ack(stream, 1),
+	quic_frame_create_and_process_and_ack(max_data, 1), /* 0x10 */
+	quic_frame_create_and_process_and_ack(max_stream_data, 1),
+	quic_frame_create_and_process_and_ack(max_streams_bidi, 1),
+	quic_frame_create_and_process_and_ack(max_streams_uni, 1),
+	quic_frame_create_and_process_and_ack(data_blocked, 1),
+	quic_frame_create_and_process_and_ack(stream_data_blocked, 1),
+	quic_frame_create_and_process_and_ack(streams_blocked_bidi, 1),
+	quic_frame_create_and_process_and_ack(streams_blocked_uni, 1),
+	quic_frame_create_and_process_and_ack(new_conn_id, 1),
+	quic_frame_create_and_process_and_ack(retire_conn_id, 1),
+	quic_frame_create_and_process_and_ack(path_challenge, 0),
+	quic_frame_create_and_process_and_ack(path_response, 0),
+	quic_frame_create_and_process_and_ack(connection_close, 0),
+	quic_frame_create_and_process_and_ack(connection_close, 0),
+	quic_frame_create_and_process_and_ack(handshake_done, 1),
+	quic_frame_create_and_process_and_ack(invalid, 0),
+	quic_frame_create_and_process_and_ack(invalid, 0), /* 0x20 */
+	quic_frame_create_and_process_and_ack(invalid, 0),
+	quic_frame_create_and_process_and_ack(invalid, 0),
+	quic_frame_create_and_process_and_ack(invalid, 0),
+	quic_frame_create_and_process_and_ack(invalid, 0),
+	quic_frame_create_and_process_and_ack(invalid, 0),
+	quic_frame_create_and_process_and_ack(invalid, 0),
+	quic_frame_create_and_process_and_ack(invalid, 0),
+	quic_frame_create_and_process_and_ack(invalid, 0),
+	quic_frame_create_and_process_and_ack(invalid, 0),
+	quic_frame_create_and_process_and_ack(invalid, 0),
+	quic_frame_create_and_process_and_ack(invalid, 0),
+	quic_frame_create_and_process_and_ack(invalid, 0),
+	quic_frame_create_and_process_and_ack(invalid, 0),
+	quic_frame_create_and_process_and_ack(invalid, 0),
+	quic_frame_create_and_process_and_ack(invalid, 0),
+	quic_frame_create_and_process_and_ack(datagram, 1), /* 0x30 */
+	quic_frame_create_and_process_and_ack(datagram, 1),
+};
+
+void quic_frame_ack(struct sock *sk, struct quic_frame *frame)
+{
+	quic_frame_ops[frame->type].frame_ack(sk, frame);
+
+	list_del_init(&frame->list);
+	frame->transmitted = 0;
+	quic_frame_put(frame);
+}
+
+int quic_frame_process(struct sock *sk, struct quic_frame *frame)
+{
+	u8 type, level = frame->level;
+	int ret;
+
+	while (frame->len > 0) {
+		type = *frame->data++;
+		frame->len--;
+
+		if (type > QUIC_FRAME_MAX) {
+			pr_debug("%s: unsupported frame, type: %x, level: %d\n",
+				 __func__, type, level);
+			return -EPROTONOSUPPORT;
+		} else if (quic_frame_level_check(level, type)) {
+			pr_debug("%s: invalid frame, type: %x, level: %d\n",
+				 __func__, type, level);
+			return -EINVAL;
+		}
+		ret = quic_frame_ops[type].frame_process(sk, frame, type);
+		if (ret < 0) {
+			pr_debug("%s: failed, type: %x, level: %d, err: %d\n",
+				 __func__, type, level, ret);
+			return ret;
+		}
+		pr_debug("%s: done, type: %x, level: %d\n", __func__, type, level);
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
+	INIT_LIST_HEAD(&frame->list);
+	if (!frame->type)
+		frame->type = type;
+	frame->ack_eliciting = quic_frame_ops[type].ack_eliciting;
+	pr_debug("%s: done, type: %x, len: %u\n", __func__, type, frame->len);
+	return frame;
+}
+
+struct quic_frame *quic_frame_alloc(u32 size, u8 *data, gfp_t gfp)
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
+	refcount_set(&frame->refcnt, 1);
+	frame->offset = -1;
+	frame->len = (u16)size;
+	frame->size = frame->len;
+	return frame;
+}
+
+static void quic_frame_free(struct quic_frame *frame)
+{
+	struct quic_frame_frag *frag, *next;
+
+	if (!frame->type && frame->skb) { /* RX path frame with skb. */
+		kfree_skb(frame->skb);
+		goto out;
+	}
+
+	for (frag = frame->flist; frag; frag = next) {
+		next = frag->next;
+		kfree(frag);
+	}
+	kfree(frame->data);
+out:
+	kmem_cache_free(quic_frame_cachep, frame);
+}
+
+struct quic_frame *quic_frame_get(struct quic_frame *frame)
+{
+	refcount_inc(&frame->refcnt);
+	return frame;
+}
+
+void quic_frame_put(struct quic_frame *frame)
+{
+	if (refcount_dec_and_test(&frame->refcnt))
+		quic_frame_free(frame);
+}
+
+int quic_frame_stream_append(struct sock *sk, struct quic_frame *frame,
+			     struct quic_msginfo *info, u8 pack)
+{
+	return -1;
+}
diff --git a/net/quic/frame.h b/net/quic/frame.h
new file mode 100644
index 000000000000..7bcdba1e9bdd
--- /dev/null
+++ b/net/quic/frame.h
@@ -0,0 +1,195 @@
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
+#define QUIC_TOKEN_MAX_LEN		120
+
+#define QUIC_TICKET_MIN_LEN		64
+#define QUIC_TICKET_MAX_LEN		4096
+
+#define QUIC_FRAME_BUF_SMALL		20
+#define QUIC_FRAME_BUF_LARGE		100
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
+/* Arguments passed to create a STREAM frame */
+struct quic_msginfo {
+	struct quic_stream *stream;	/* The QUIC stream associated with this frame */
+	struct iov_iter *msg;		/* Iterator over message data to send */
+	u32 flags;			/* Flags controlling stream frame creation */
+	u8 level;			/* Encryption level for this frame */
+};
+
+/* Arguments passed to create a PING frame */
+struct quic_probeinfo {
+	u16 size;	/* Size of the PING packet */
+	u8 level;	/* Encryption level for this frame */
+};
+
+/* Operations for creating, processing, and acknowledging QUIC frames */
+struct quic_frame_ops {
+	struct quic_frame *(*frame_create)(struct sock *sk, void *data, u8 type);
+	int (*frame_process)(struct sock *sk, struct quic_frame *frame, u8 type);
+	void (*frame_ack)(struct sock *sk, struct quic_frame *frame);
+	u8 ack_eliciting;
+};
+
+/* Fragment of data appended to a STREAM frame */
+struct quic_frame_frag {
+	struct quic_frame_frag *next;	/* Next fragment in the linked list */
+	u16 size;			/* Size of this data fragment */
+	u8 data[];			/* Flexible array member holding fragment data */
+};
+
+struct quic_frame {
+	union {
+		struct quic_frame_frag *flist;	/* For TX: linked list of appended data fragments */
+		struct sk_buff *skb;		/* For RX: skb containing the raw frame data */
+	};
+	struct quic_stream *stream;		/* Stream related to this frame, NULL if none */
+	struct list_head list;			/* Linked list node for queuing frames */
+	union {
+		s64 offset;	/* For RX: stream/crypto data offset or read data offset */
+		s64 number;	/* For TX: first packet number used */
+	};
+	u8  *data;		/* Pointer to the actual frame data buffer */
+
+	refcount_t refcnt;
+	u16 errcode;		/* Error code set during frame processing */
+	u8  level;		/* Packet number space: Initial, Handshake, or App */
+	u8  type;		/* Frame type identifier */
+	u16 bytes;		/* Number of user data bytes */
+	u16 size;		/* Allocated data buffer size */
+	u16 len;		/* Total frame length including appended fragments */
+
+	u8  ack_eliciting:1;	/* Frame requires acknowledgment */
+	u8  transmitted:1;	/* Frame is in the transmitted queue */
+	u8  stream_fin:1;	/* Frame includes FIN flag for stream */
+	u8  nodelay:1;		/* Frame bypasses Nagle's algorithm for sending */
+	u8  padding:1;		/* Padding is needed after this frame */
+	u8  dgram:1;		/* Frame represents a datagram message (RX only) */
+	u8  event:1;		/* Frame represents an event (RX only) */
+	u8  path:1;		/* Path index used to send this frame */
+};
+
+static inline bool quic_frame_new_conn_id(u8 type)
+{
+	return type == QUIC_FRAME_NEW_CONNECTION_ID;
+}
+
+static inline bool quic_frame_dgram(u8 type)
+{
+	return type == QUIC_FRAME_DATAGRAM || type == QUIC_FRAME_DATAGRAM_LEN;
+}
+
+static inline bool quic_frame_stream(u8 type)
+{
+	return type >= QUIC_FRAME_STREAM && type < QUIC_FRAME_MAX_DATA;
+}
+
+static inline bool quic_frame_sack(u8 type)
+{
+	return type == QUIC_FRAME_ACK || type == QUIC_FRAME_ACK_ECN;
+}
+
+static inline bool quic_frame_ping(u8 type)
+{
+	return type == QUIC_FRAME_PING;
+}
+
+/* Check if a given frame type is valid for the specified encryption level,
+ * based on the Frame Types table from rfc9000#section-12.4.
+ *
+ * Returns 0 if valid, 1 otherwise.
+ */
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
+int quic_frame_stream_append(struct sock *sk, struct quic_frame *frame,
+			     struct quic_msginfo *info, u8 pack);
+
+struct quic_frame *quic_frame_alloc(u32 size, u8 *data, gfp_t gfp);
+struct quic_frame *quic_frame_get(struct quic_frame *frame);
+void quic_frame_put(struct quic_frame *frame);
+
+struct quic_frame *quic_frame_create(struct sock *sk, u8 type, void *data);
+int quic_frame_process(struct sock *sk, struct quic_frame *frame);
+void quic_frame_ack(struct sock *sk, struct quic_frame *frame);
diff --git a/net/quic/protocol.c b/net/quic/protocol.c
index fb98ef10f852..4725e3aa7785 100644
--- a/net/quic/protocol.c
+++ b/net/quic/protocol.c
@@ -21,6 +21,7 @@
 
 static unsigned int quic_net_id __read_mostly;
 
+struct kmem_cache *quic_frame_cachep __read_mostly;
 struct percpu_counter quic_sockets_allocated;
 
 long sysctl_quic_mem[3];
@@ -335,6 +336,11 @@ static __init int quic_init(void)
 
 	quic_crypto_init();
 
+	quic_frame_cachep = kmem_cache_create("quic_frame", sizeof(struct quic_frame),
+					      0, SLAB_HWCACHE_ALIGN, NULL);
+	if (!quic_frame_cachep)
+		goto err;
+
 	err = percpu_counter_init(&quic_sockets_allocated, 0, GFP_KERNEL);
 	if (err)
 		goto err_percpu_counter;
@@ -363,6 +369,8 @@ static __init int quic_init(void)
 err_hash:
 	percpu_counter_destroy(&quic_sockets_allocated);
 err_percpu_counter:
+	kmem_cache_destroy(quic_frame_cachep);
+err:
 	return err;
 }
 
@@ -375,6 +383,7 @@ static __exit void quic_exit(void)
 	unregister_pernet_subsys(&quic_net_ops);
 	quic_hash_tables_destroy();
 	percpu_counter_destroy(&quic_sockets_allocated);
+	kmem_cache_destroy(quic_frame_cachep);
 	pr_info("quic: exit\n");
 }
 
diff --git a/net/quic/protocol.h b/net/quic/protocol.h
index 1df926ef0a75..92ad261199c1 100644
--- a/net/quic/protocol.h
+++ b/net/quic/protocol.h
@@ -8,6 +8,7 @@
  *    Xin Long <lucien.xin@gmail.com>
  */
 
+extern struct kmem_cache *quic_frame_cachep __read_mostly;
 extern struct percpu_counter quic_sockets_allocated;
 
 extern long sysctl_quic_mem[3];
diff --git a/net/quic/socket.h b/net/quic/socket.h
index b3cf31e005ce..75cb90177a01 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -20,6 +20,8 @@
 #include "path.h"
 #include "cong.h"
 
+#include "frame.h"
+
 #include "protocol.h"
 #include "timer.h"
 
-- 
2.47.1

