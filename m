Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE396153800;
	Tue, 10 Sep 2024 02:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725935511; cv=none; b=pEvR9y2ZixbRpJcHKYQsHZgDj79gGnqjasxHUjghA9p94LbkC7HcDOMPcvebiysNczls5WONNhfluh42+iwZzERykKQtBvGbofkVzqGrrW7JtGKagD2gneeQ46proB+xKNx6qnGYUu1bmXSXnFsb/Qf+hMG0FHkx21f+F6I5V5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725935511; c=relaxed/simple;
	bh=jpuzbIhb7je/iBljgORmUy5tR3CprUXlqNxn3+UBeAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p43JaDmjwkLPbb9YMHCH+TrEeLSeIYyYltAu0URxZGsFHx9+27aiGtSTyveK7D2EwdjSYLjzXBAK1mlnflGF8j+7+sV5zzSAJg9kGyuwFUKDDAjfRpTg9OC/nu5elhs8sZeeZR2ennYr+vL8YAzAoaeCS6iNv5oPEuYg+ui4J60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GiNQc4fO; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GiNQc4fO"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7a99d23e036so254604285a.1;
        Mon, 09 Sep 2024 19:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725935508; x=1726540308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UNNtw40uQSQZbwWWnLBGkGiKcVvxU2yrFk6Vg0kaCjQ=;
        b=GiNQc4fOw8unn4UTGo0Vywy3gwSudNnt1pZx5/YTHOIAz5RhISjYstL+9ayDekEnmV
         zxlSkIuUnhSjusNjGHNOSr3MUU6ml8ItzDeegI9NR6xEpTQdZZRPzo8S+6JXz4gvFdI5
         Sg8CM0aY6h/LNJuIl9/aRWYKjrJAONqbi8ByFatYaYiG7dwn/4SLOcYVcX9fnltvPPuv
         CVgnVr+MI3h6rEWeZ5jFcZ0cqEKRqY6cwmRWnsVXKfv0/bzRDnbEGYsSqaVz73Mwe0FF
         mPpyKLfjRUKHv/EjZv0X0x870yavzKV0ztJeOL+TYDUbssgPIO79coFM7OqkXePkFuSW
         xouA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725935508; x=1726540308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UNNtw40uQSQZbwWWnLBGkGiKcVvxU2yrFk6Vg0kaCjQ=;
        b=sGx4zDb13HTofIvmingQqz+NBtixl4lCEpr+bb8fHHuuIwSTFswmfpPYJjA8+c8Q2K
         80jTVVqmoekyXffydgcEOUcp+nX5EhNp+MeZie9+neVKNlBiqaA/2ubCW023rEV+Iwsw
         GKbRJ6KH4n9A/Pu1Vjes2uNctRuFPziaY5eORBUABcXWHveXX8NnUvXhW7Jfq3r3YRRW
         KG+Kf67QDqdeiNmcCVf2aIxXnd2j04YS0YSvmf2ON4yMdlVDZPwckAgr4Hx8Mj3UNTmh
         Y06jvnRgezfnFSLIBmjPvHzNBAwFMd9YRTjqOx045FIzTXP6MOGSqwyhcmAhQOFXrYYV
         4XSA==
X-Forwarded-Encrypted: i=1; AJvYcCXl7bLohXktdMgAo6r/kR7KVPWEGTILe1/nB6Ti8yjoMwtuUoIODuVaGiVyzwQJ5r1AqjS/572JnXMs@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+P4/y59mzUAUgWy/+ObCqIJkznU5yzXoZgSagEvdr/caQTh9G
	tbCy0D+iIJuf7JypK0pYl6fTJhfxvRIXJzuyf0ywD2s3UYO0xVX4drsNMsNq
X-Google-Smtp-Source: AGHT+IEQNq+bqPRE+PDVk/zG6vGoRkF3aXnhQWmCJ0jFFnL23iYwfcidZakjYG/TWYtozs7KtqlSZg==
X-Received: by 2002:a05:620a:4005:b0:7a9:be8f:5c65 with SMTP id af79cd13be357-7a9be8f5fddmr353265285a.15.1725935508339;
        Mon, 09 Sep 2024 19:31:48 -0700 (PDT)
Received: from wsfd-netdev15.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a9a7a1f594sm270429885a.121.2024.09.09.19.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 19:31:48 -0700 (PDT)
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
Subject: [PATCH net-next 2/5] net: include quic.h in include/uapi/linux for QUIC protocol
Date: Mon,  9 Sep 2024 22:30:17 -0400
Message-ID: <69a652ff40f0a9c6ca6894ed0a815515a949861a.1725935420.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1725935420.git.lucien.xin@gmail.com>
References: <cover.1725935420.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit introduces quic.h to the include/uapi/linux directory,
providing header file with necessary definitions for QUIC. Including
quic.h enables both user space applications and kernel consumers to
access QUIC-related Send/Receive Control Messages, Socket Options and
Events/Notifications APIs.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Moritz Buhl <mbuhl@openbsd.org>
Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
Signed-off-by: Pengtao He <hepengtao@xiaomi.com>
---
 include/uapi/linux/quic.h | 192 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 192 insertions(+)
 create mode 100644 include/uapi/linux/quic.h

diff --git a/include/uapi/linux/quic.h b/include/uapi/linux/quic.h
new file mode 100644
index 000000000000..aab7b85838d6
--- /dev/null
+++ b/include/uapi/linux/quic.h
@@ -0,0 +1,192 @@
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
+#ifndef __uapi_quic_h__
+#define __uapi_quic_h__
+
+#include <linux/socket.h>
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
+
+/* Send or Receive Options APIs */
+enum quic_cmsg_type {
+	QUIC_STREAM_INFO,
+	QUIC_HANDSHAKE_INFO,
+};
+
+#define QUIC_STREAM_TYPE_SERVER_MASK	0x01
+#define QUIC_STREAM_TYPE_UNI_MASK	0x02
+#define QUIC_STREAM_TYPE_MASK		0x03
+
+enum quic_msg_flags {
+	/* flags for stream_flags */
+	MSG_STREAM_NEW		= 0x400,
+	MSG_STREAM_FIN		= 0x200,
+	MSG_STREAM_UNI		= 0x800,
+	MSG_STREAM_DONTWAIT	= 0x10000,
+
+	/* extented flags for msg_flags */
+	MSG_DATAGRAM		= 0x10,
+	MSG_NOTIFICATION	= 0x8000,
+};
+
+enum quic_crypto_level {
+	QUIC_CRYPTO_APP,
+	QUIC_CRYPTO_INITIAL,
+	QUIC_CRYPTO_HANDSHAKE,
+	QUIC_CRYPTO_EARLY,
+	QUIC_CRYPTO_MAX,
+};
+
+struct quic_handshake_info {
+	uint8_t	crypto_level;
+};
+
+struct quic_stream_info {
+	int64_t  stream_id;
+	uint32_t stream_flags;
+};
+
+/* Socket Options APIs */
+#define QUIC_SOCKOPT_EVENT				0
+#define QUIC_SOCKOPT_STREAM_OPEN			1
+#define QUIC_SOCKOPT_STREAM_RESET			2
+#define QUIC_SOCKOPT_STREAM_STOP_SENDING		3
+#define QUIC_SOCKOPT_CONNECTION_CLOSE			4
+#define QUIC_SOCKOPT_CONNECTION_MIGRATION		5
+#define QUIC_SOCKOPT_KEY_UPDATE				6
+#define QUIC_SOCKOPT_TRANSPORT_PARAM			7
+#define QUIC_SOCKOPT_CONFIG				8
+#define QUIC_SOCKOPT_TOKEN				9
+#define QUIC_SOCKOPT_ALPN				10
+#define QUIC_SOCKOPT_SESSION_TICKET			11
+#define QUIC_SOCKOPT_CRYPTO_SECRET			12
+#define QUIC_SOCKOPT_TRANSPORT_PARAM_EXT		13
+#define QUIC_SOCKOPT_RETIRE_CONNECTION_ID		14
+#define QUIC_SOCKOPT_ACTIVE_CONNECTION_ID		15
+
+#define QUIC_VERSION_V1			0x1
+#define QUIC_VERSION_V2			0x6b3343cf
+
+struct quic_transport_param {
+	uint8_t		remote;
+	uint8_t		disable_active_migration;
+	uint8_t		grease_quic_bit;
+	uint8_t		stateless_reset;
+	uint8_t		disable_1rtt_encryption;
+	uint8_t		disable_compatible_version;
+	uint64_t	max_udp_payload_size;
+	uint64_t	ack_delay_exponent;
+	uint64_t	max_ack_delay;
+	uint64_t	active_connection_id_limit;
+	uint64_t	max_idle_timeout;
+	uint64_t	max_datagram_frame_size;
+	uint64_t	max_data;
+	uint64_t	max_stream_data_bidi_local;
+	uint64_t	max_stream_data_bidi_remote;
+	uint64_t	max_stream_data_uni;
+	uint64_t	max_streams_bidi;
+	uint64_t	max_streams_uni;
+};
+
+struct quic_config {
+	uint32_t	version;
+	uint32_t	plpmtud_probe_interval;
+	uint64_t	initial_smoothed_rtt;
+	uint8_t		congestion_control_algo;
+	uint8_t		validate_peer_address;
+	uint32_t	payload_cipher_type;
+	uint8_t		receive_session_ticket;
+	uint8_t		certificate_request;
+};
+
+struct quic_crypto_secret {
+	uint8_t send;  /* send or recv */
+	uint8_t level; /* crypto level */
+	uint32_t type; /* TLS_CIPHER_* */
+	uint8_t secret[48];
+};
+
+enum {
+	QUIC_CONG_ALG_RENO,
+	QUIC_CONG_ALG_CUBIC,
+	QUIC_CONG_ALG_MAX,
+};
+
+struct quic_errinfo {
+	uint64_t stream_id;
+	uint32_t errcode;
+};
+
+struct quic_connection_id_info {
+	uint32_t source;
+	uint32_t dest;
+};
+
+struct quic_event_option {
+	uint8_t type;
+	uint8_t on;
+};
+
+/* Event APIs */
+enum quic_event_type {
+	QUIC_EVENT_NONE,
+	QUIC_EVENT_STREAM_UPDATE,
+	QUIC_EVENT_STREAM_MAX_STREAM,
+	QUIC_EVENT_CONNECTION_CLOSE,
+	QUIC_EVENT_CONNECTION_MIGRATION,
+	QUIC_EVENT_KEY_UPDATE,
+	QUIC_EVENT_NEW_TOKEN,
+	QUIC_EVENT_NEW_SESSION_TICKET,
+	QUIC_EVENT_END,
+	QUIC_EVENT_MAX = QUIC_EVENT_END - 1,
+};
+
+enum {
+	QUIC_STREAM_SEND_STATE_READY,
+	QUIC_STREAM_SEND_STATE_SEND,
+	QUIC_STREAM_SEND_STATE_SENT,
+	QUIC_STREAM_SEND_STATE_RECVD,
+	QUIC_STREAM_SEND_STATE_RESET_SENT,
+	QUIC_STREAM_SEND_STATE_RESET_RECVD,
+
+	QUIC_STREAM_RECV_STATE_RECV,
+	QUIC_STREAM_RECV_STATE_SIZE_KNOWN,
+	QUIC_STREAM_RECV_STATE_RECVD,
+	QUIC_STREAM_RECV_STATE_READ,
+	QUIC_STREAM_RECV_STATE_RESET_RECVD,
+	QUIC_STREAM_RECV_STATE_RESET_READ,
+};
+
+struct quic_stream_update {
+	uint64_t id;
+	uint32_t state;
+	uint32_t errcode;
+	uint64_t finalsz;
+};
+
+struct quic_connection_close {
+	uint32_t errcode;
+	uint8_t frame;
+	uint8_t phrase[];
+};
+
+union quic_event {
+	struct quic_stream_update update;
+	struct quic_connection_close close;
+	uint64_t max_stream;
+	uint8_t local_migration;
+	uint8_t key_update_phase;
+};
+
+#endif /* __uapi_quic_h__ */
-- 
2.43.0

