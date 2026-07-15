Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256753C661A
	for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 20:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784147532; cv=none; b=Jj8xPD3YIH33u5r+Qbkh4HKFszkvSPJ93BxIBxiMB6nNQ1jJXmN7TS8FcwV3V5q03gBLxwG7PQfDbu2X5slEysTk2zwwbQIuvuI9wpDAI0Wy+pk1Q+m2IsgHOrBNfb8qEQ5wV9FdwobSFvRjLveq8xQiz44FhXpCQgVCIMeo4ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784147532; c=relaxed/simple;
	bh=SH986nKk58uHLgCF90adeSIPGMZDmCv9y84ULTMUfHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uyd4DCKckhBkXfh53yrxqkNoSSfOHhYmUTQBj4/wSfqhDkmY2Z3mtrIHorSTpptBps3wPLa+5fSFOBwMUIgU78eT0VaM8RbPhuJ+qa/n85ICEH2kSkxJVrrwy55oqckq6NgFnWV+gr9lV5rRxWQhkgNiGgtVeGudxvy/hkYrtRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DgDKyyT0; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DgDKyyT0"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-902f92b8504so51158276d6.2
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 13:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784147529; x=1784752329; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nYpG3mT5d/KKB4iFsFFFD/XB8ciL4xNeqRqCKt4rTIg=;
        b=DgDKyyT02GnNdkFdCqDblslNOxeJeaGAu2BtN8vd6QMEgxsz0L0g8zTKxMiCl1GPx8
         dc++CL336G5cwVbBeqYmLHCVtwfKMeVsghqRE66gbu+96dJ7JaRDbuy+Aa370ZpmskkV
         A9WE6VQm6YHwpeQYMW9WUFBvxIkHBSmXSEqKNDvfZPH/oMybRlgwove4dKbusdnVFCmM
         nOi4Ffo4B3vD+nSGaP9QpuvR38yVxDR13w8FX6hOJN5cW0W9rBo4XolxE7/dUd+QpoL0
         JNBvkaiaNhnSGTME56+Gn7sHVD9G4CACgsqCgoLZ5nc3hJ3bG1XmX2nfT/eeoL6SwZUL
         TPvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784147529; x=1784752329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nYpG3mT5d/KKB4iFsFFFD/XB8ciL4xNeqRqCKt4rTIg=;
        b=e8E9CdOcxAqNVsWmCrgOpzv6sfVUDn4ph7yujGmrG8y5JuHs712UP/1IUTQwbBxeOo
         l7Nz20LJWMi6MsgGE1SesTudqQrTokcqYDQhU/yHyV2eQuHt4bmJhjagUFdL57aR//AD
         cRX7LI3XisxM9r7T60jrymZv4+RN97a4QSMEzX4K5H1U8YdlrNWMg8OLVDAuS8bt+kQe
         W2XBrGWGSlbsMqQBsxV224Wb3j/kVMcdTXqdef285+npM9BFqqf8vgdh7fa7GzqQ1owY
         mlEgFWfaAdw0UudLlTTjZxwhhFCNExqjyQV7NopvvKy6+aSBxDwJN3VTZLZ5H/FkIZrB
         gCqg==
X-Forwarded-Encrypted: i=1; AHgh+Rp2uxa6nTjHTupLggQWWpRQ1l1lloG4JPP6DabIFIKyR+nWM/g9AahXjJBS0HxGNKg2jyFAWC5uv0gl@vger.kernel.org
X-Gm-Message-State: AOJu0YwGoLBySH0yiC2QHdtDrpLWt0uR5Qh+H8hPTNaZmxc2YMMx8SAj
	TyqLn+HM8xhxKmL243dry55uY4FyeLgdZC9hNi0qJ8H/ZEjek6+e77w1
X-Gm-Gg: AfdE7cmRMen7vvrFNsRb7larCSURyzhcBDegaVXtWBJNMpNTFhV+SMvCMFgsV7uY0qg
	TtMFF0akXpNHExObEtCVzACx0jrPNeHcpC66K7EBiZ1e7LUYeXXP7cA+6VydiOHGYglmjEyPjic
	Qf8RFdnj12Ql/uiZLvXoaRMJrl7kdF7gb/PdO/A2uhlo5eihmluW3iaRmBqPgTbpQ5gAeLWmj97
	RNhIaYlTkVYoq2OH3x/prZHpd0UfRbVQ8PtvxFBMaEDgWg2V+faVmlUkywCvT2/bilhdphP58no
	zpfOeEr4m9WwI1cnMmbX/Ucf90EGPazheeg4QUPJ0wOBTk0gYxPu16WXB4XMHL0ryz2PMbeiqiU
	j8BUAfT2z4M3bd0rFV9TTGMj/WGA7Fa+iiucfVj/hsZLr+O1RgSoHObEIiixLh1L4zK7wcJb0w2
	j8hKf3okd01heFyzM0rVQS3zIv4htcjTU32OS8yJd2KdavFS/VSE1k+BqERWpcoGFQU29nXybmd
	aW5DW70FpAlguGnC3+2f+go4zfHyx4EewKQqCUVVwaPdxw+Kza/7Wo=
X-Received: by 2002:a05:6214:260e:b0:8e9:f5de:d5b5 with SMTP id 6a1803df08f44-90758e165f9mr49262006d6.44.1784147528792;
        Wed, 15 Jul 2026 13:32:08 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd248e666sm201326506d6.0.2026.07.15.13.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 13:32:08 -0700 (PDT)
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
Subject: [PATCH net-next v14 05/15] quic: provide quic.h header files for kernel and userspace
Date: Wed, 15 Jul 2026 16:27:08 -0400
Message-ID: <e8ec4214f03a03d8b6348d77b7333b240fbf1aa2.1784147238.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1784147238.git.lucien.xin@gmail.com>
References: <cover.1784147238.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit adds quic.h to include/uapi/linux, providing the necessary
definitions for the QUIC socket API. Exporting this header allows both
user space applications and kernel subsystems to access QUIC-related
control messages, socket options, and event/notification interfaces.

Since kernel_get/setsockopt() is no longer available to kernel consumers,
a corresponding internal header, include/linux/quic.h, is added. This
exposes quic_do_get/setsockopt() to handle QUIC socket options directly
for kernel subsystems.

Detailed descriptions of these structures are available in [1], and will
be also provided when adding corresponding socket interfaces in the
later patches.

[1] https://datatracker.ietf.org/doc/html/draft-lxin-quic-socket-apis

Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Thomas Dreibholz <dreibh@simula.no>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
---
v2:
  - Fix a kernel API description warning, found by Jakub.
  - Replace uintN_t with __uN, capitalize _UAPI_LINUX_QUIC_H, and
    assign explicit values for QUIC_TRANSPORT_ERROR_ enum in UAPI
    quic.h, suggested by David Howells.
v4:
  - Use MSG_QUIC_ prefix for MSG_* flags to avoid conflicts with other
    protocols, such as MSG_NOTIFICATION in SCTP (reported by Thomas).
  - Remove QUIC_CONG_ALG_CUBIC; only NEW RENO congestion control is
    supported in this version.
v5:
  - Add include/linux/quic.h and include/uapi/linux/quic.h to the
    QUIC PROTOCOL entry in MAINTAINERS.
v6:
  - Fix the copy/pasted the uAPI path for SCTP to the QUIC entry (noted
    by Jakub).
v7:
  - Expose quic_do_get/setsockopt() instead of quic_kernel_get/setsockopt()
    (suggested by Paolo).
v10:
  - Fix typo: 'extented' -> 'extended' (noted by AI review).
  - Add comment for inclusion of sys/socket.h in uapi quic.h.
  - Add uses-libc += linux/quic.h in usr/include/Makefile to fix the new
    build error.
  - Delete config from struct quic_sock, its members will be split into
    other subcomponents in the future patches.
  - Add explicit reserved fields to multiple structs to account for
    implicit padding and ensure UAPI stability.
  - Expand reserved fields in struct transport_param and config, handshake
    and stream_info to allow future extensions without breaking the UAPI.
v11:
  - Set maximum line length to 80 characters.
  - Drop trailing reserved fields in structs and rely on
    copy_struct_to/from_user() for extensibility; keep reserved fields
    in the middle to indicate memory holes.
v12:
  - Make the phrase field in struct quic_connection_close a fixed-size
    array.
  - Add QUIC_TRANSPORT_ERROR_VERSION_NEGOTIATION for late use.
  - Add keepalive_probe_interval to struct quic_transport_param to make
    keepalive probing configurable.
  - Relace uses-libc += linux/quic.h with no-header-test += linux/quic.h
    in usr/include/Makefile to fix the new build error.
  - Add forward declaration for struct sock in include/linux/quic.h.
---
 MAINTAINERS               |   2 +
 include/linux/quic.h      |  24 ++++
 include/uapi/linux/quic.h | 241 ++++++++++++++++++++++++++++++++++++++
 net/quic/socket.c         |  36 +++++-
 net/quic/socket.h         |   1 +
 usr/include/Makefile      |   1 +
 6 files changed, 301 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/quic.h
 create mode 100644 include/uapi/linux/quic.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 884a267b03e4..5ce461662a0c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22409,6 +22409,8 @@ M:	Xin Long <lucien.xin@gmail.com>
 L:	quic@lists.linux.dev
 S:	Maintained
 W:	https://github.com/lxin/quic
+F:	include/linux/quic.h
+F:	include/uapi/linux/quic.h
 F:	net/quic/
 
 RADEON and AMDGPU DRM DRIVERS
diff --git a/include/linux/quic.h b/include/linux/quic.h
new file mode 100644
index 000000000000..908308a6bb83
--- /dev/null
+++ b/include/linux/quic.h
@@ -0,0 +1,24 @@
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
+#ifndef _LINUX_QUIC_H
+#define _LINUX_QUIC_H
+
+#include <linux/sockptr.h>
+#include <uapi/linux/quic.h>
+
+struct sock;
+
+int quic_do_setsockopt(struct sock *sk, int optname, sockptr_t optval,
+		       unsigned int optlen);
+int quic_do_getsockopt(struct sock *sk, int optname, sockptr_t optval,
+		       sockptr_t optlen);
+
+#endif
diff --git a/include/uapi/linux/quic.h b/include/uapi/linux/quic.h
new file mode 100644
index 000000000000..d29b21f7b77c
--- /dev/null
+++ b/include/uapi/linux/quic.h
@@ -0,0 +1,241 @@
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
+#ifndef _UAPI_LINUX_QUIC_H
+#define _UAPI_LINUX_QUIC_H
+
+#include <linux/types.h>
+#ifdef __KERNEL__
+#include <linux/socket.h>
+#else
+#include <sys/socket.h> /* for MSG_* flags */
+#endif
+
+/* NOTE: Structure descriptions are specified in:
+ * https://datatracker.ietf.org/doc/html/draft-lxin-quic-socket-apis
+ */
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
+	MSG_QUIC_STREAM_NEW		= MSG_SYN,
+	MSG_QUIC_STREAM_FIN		= MSG_FIN,
+	MSG_QUIC_STREAM_UNI		= MSG_CONFIRM,
+	MSG_QUIC_STREAM_DONTWAIT	= MSG_WAITFORONE,
+	MSG_QUIC_STREAM_SNDBLOCK	= MSG_ERRQUEUE,
+
+	/* extended flags for msg_flags */
+	MSG_QUIC_DATAGRAM		= MSG_RST,
+	MSG_QUIC_NOTIFICATION		= MSG_MORE,
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
+	__u8	crypto_level;
+};
+
+struct quic_stream_info {
+	__s64	stream_id;
+	__u32	stream_flags;
+};
+
+/* Socket Options APIs */
+#define QUIC_SOCKOPT_EVENT				0
+#define QUIC_SOCKOPT_STREAM_OPEN			1
+#define QUIC_SOCKOPT_STREAM_RESET			2
+#define QUIC_SOCKOPT_STREAM_STOP_SENDING		3
+#define QUIC_SOCKOPT_CONNECTION_ID			4
+#define QUIC_SOCKOPT_CONNECTION_CLOSE			5
+#define QUIC_SOCKOPT_CONNECTION_MIGRATION		6
+#define QUIC_SOCKOPT_KEY_UPDATE				7
+#define QUIC_SOCKOPT_TRANSPORT_PARAM			8
+#define QUIC_SOCKOPT_CONFIG				9
+#define QUIC_SOCKOPT_TOKEN				10
+#define QUIC_SOCKOPT_ALPN				11
+#define QUIC_SOCKOPT_SESSION_TICKET			12
+#define QUIC_SOCKOPT_CRYPTO_SECRET			13
+#define QUIC_SOCKOPT_TRANSPORT_PARAM_EXT		14
+
+#define QUIC_VERSION_V1			0x1
+#define QUIC_VERSION_V2			0x6b3343cf
+
+struct quic_transport_param {
+	__u8	remote;
+	__u8	disable_active_migration;
+	__u8	grease_quic_bit;
+	__u8	stateless_reset;
+	__u8	disable_1rtt_encryption;
+	__u8	disable_compatible_version;
+	__u8	active_connection_id_limit;
+	__u8	ack_delay_exponent;
+	__u16	max_datagram_frame_size;
+	__u16	max_udp_payload_size;
+	__u32	max_idle_timeout;
+	__u32	max_ack_delay;
+	__u16	max_streams_bidi;
+	__u16	max_streams_uni;
+	__u64	max_data;
+	__u64	max_stream_data_bidi_local;
+	__u64	max_stream_data_bidi_remote;
+	__u64	max_stream_data_uni;
+};
+
+struct quic_config {
+	__u32	version;
+	__u32	plpmtud_probe_interval;
+	__u32	initial_smoothed_rtt;
+	__u32	payload_cipher_type;
+	__u8	congestion_control_algo;
+	__u8	validate_peer_address;
+	__u8	stream_data_nodelay;
+	__u8	receive_session_ticket;
+	__u8	certificate_request;
+	__u8	reserved[3];
+	__u32	keepalive_probe_interval;
+};
+
+struct quic_crypto_secret {
+	__u8	send;  /* send or recv */
+	__u8	level; /* crypto level */
+	__u16	reserved;
+	__u32	type; /* TLS_CIPHER_* */
+#define QUIC_CRYPTO_SECRET_BUFFER_SIZE 48
+	__u8	secret[QUIC_CRYPTO_SECRET_BUFFER_SIZE];
+};
+
+enum quic_cong_algo {
+	QUIC_CONG_ALG_RENO,
+	QUIC_CONG_ALG_MAX,
+};
+
+struct quic_errinfo {
+	__s64	stream_id;
+	__u32	errcode;
+};
+
+struct quic_connection_id_info {
+	__u8	dest;
+	__u8	reserved[3];
+	__u32	active;
+	__u32	prior_to;
+};
+
+struct quic_event_option {
+	__u8	type;
+	__u8	on;
+};
+
+/* Event APIs */
+enum quic_event_type {
+	QUIC_EVENT_NONE,
+	QUIC_EVENT_STREAM_UPDATE,
+	QUIC_EVENT_STREAM_MAX_DATA,
+	QUIC_EVENT_STREAM_MAX_STREAM,
+	QUIC_EVENT_CONNECTION_ID,
+	QUIC_EVENT_CONNECTION_CLOSE,
+	QUIC_EVENT_CONNECTION_MIGRATION,
+	QUIC_EVENT_KEY_UPDATE,
+	QUIC_EVENT_NEW_TOKEN,
+	QUIC_EVENT_NEW_SESSION_TICKET,
+	QUIC_EVENT_MAX,
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
+	__s64	id;
+	__u8	state;
+	__u8	reserved[3];
+	__u32	errcode;
+	__u64	finalsz;
+};
+
+struct quic_stream_max_data {
+	__s64	id;
+	__u64	max_data;
+};
+
+struct quic_connection_close {
+	__u32	errcode;
+	__u8	frame;
+	__u8	reserved[3];
+#define QUIC_CLOSE_PHRASE_BUFFER_SIZE 64
+	__u8	phrase[QUIC_CLOSE_PHRASE_BUFFER_SIZE];
+};
+
+union quic_event {
+	struct quic_stream_update	update;
+	struct quic_stream_max_data	max_data;
+	struct quic_connection_close	close;
+	struct quic_connection_id_info	info;
+	__u64	max_stream;
+	__u8	local_migration;
+	__u8	key_update_phase;
+};
+
+enum {
+	QUIC_TRANSPORT_ERROR_NONE			= 0x00,
+	QUIC_TRANSPORT_ERROR_INTERNAL			= 0x01,
+	QUIC_TRANSPORT_ERROR_CONNECTION_REFUSED		= 0x02,
+	QUIC_TRANSPORT_ERROR_FLOW_CONTROL		= 0x03,
+	QUIC_TRANSPORT_ERROR_STREAM_LIMIT		= 0x04,
+	QUIC_TRANSPORT_ERROR_STREAM_STATE		= 0x05,
+	QUIC_TRANSPORT_ERROR_FINAL_SIZE			= 0x06,
+	QUIC_TRANSPORT_ERROR_FRAME_ENCODING		= 0x07,
+	QUIC_TRANSPORT_ERROR_TRANSPORT_PARAM		= 0x08,
+	QUIC_TRANSPORT_ERROR_CONNECTION_ID_LIMIT	= 0x09,
+	QUIC_TRANSPORT_ERROR_PROTOCOL_VIOLATION		= 0x0a,
+	QUIC_TRANSPORT_ERROR_INVALID_TOKEN		= 0x0b,
+	QUIC_TRANSPORT_ERROR_APPLICATION		= 0x0c,
+	QUIC_TRANSPORT_ERROR_CRYPTO_BUF_EXCEEDED	= 0x0d,
+	QUIC_TRANSPORT_ERROR_KEY_UPDATE			= 0x0e,
+	QUIC_TRANSPORT_ERROR_AEAD_LIMIT_REACHED		= 0x0f,
+	QUIC_TRANSPORT_ERROR_NO_VIABLE_PATH		= 0x10,
+	QUIC_TRANSPORT_ERROR_VERSION_NEGOTIATION	= 0x11,
+
+	/* The cryptographic handshake failed. A range of 256 values is reserved
+	 * for carrying error codes specific to the cryptographic handshake that
+	 * is used. Codes for errors occurring when TLS is used for the
+	 * cryptographic handshake are described in Section 4.8 of [QUIC-TLS].
+	 */
+	QUIC_TRANSPORT_ERROR_CRYPTO			= 0x0100,
+};
+
+#endif /* _UAPI_LINUX_QUIC_H */
diff --git a/net/quic/socket.c b/net/quic/socket.c
index adde76cb7396..c54700c00ab6 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -111,11 +111,25 @@ static void quic_close(struct sock *sk, long timeout)
 	sk_common_release(sk);
 }
 
-static int quic_do_setsockopt(struct sock *sk, int optname, sockptr_t optval,
-			      unsigned int optlen)
+/**
+ * quic_do_setsockopt - set a QUIC socket option
+ * @sk: socket to configure
+ * @optname: option name (QUIC-level)
+ * @optval: user buffer containing the option value
+ * @optlen: size of the option value
+ *
+ * Sets a QUIC socket option on a given socket.
+ *
+ * Return:
+ * - On success, 0 is returned.
+ * - On error, a negative error value is returned.
+ */
+int quic_do_setsockopt(struct sock *sk, int optname, sockptr_t optval,
+		       unsigned int optlen)
 {
 	return -EOPNOTSUPP;
 }
+EXPORT_SYMBOL_GPL(quic_do_setsockopt);
 
 static int quic_setsockopt(struct sock *sk, int level, int optname,
 			   sockptr_t optval, unsigned int optlen)
@@ -127,11 +141,25 @@ static int quic_setsockopt(struct sock *sk, int level, int optname,
 	return quic_do_setsockopt(sk, optname, optval, optlen);
 }
 
-static int quic_do_getsockopt(struct sock *sk, int optname, sockptr_t optval,
-			      sockptr_t optlen)
+/**
+ * quic_do_getsockopt - get a QUIC socket option
+ * @sk: socket to query
+ * @optname: option name (QUIC-level)
+ * @optval: user buffer to receive the option value
+ * @optlen: pointer to buffer size; updated with actual size on return
+ *
+ * Gets a QUIC socket option from a given socket.
+ *
+ * Return:
+ * - On success, 0 is returned.
+ * - On error, a negative error value is returned.
+ */
+int quic_do_getsockopt(struct sock *sk, int optname, sockptr_t optval,
+		       sockptr_t optlen)
 {
 	return -EOPNOTSUPP;
 }
+EXPORT_SYMBOL_GPL(quic_do_getsockopt);
 
 static int quic_getsockopt(struct sock *sk, int level, int optname,
 			   char __user *optval, int __user *optlen)
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 0aa642e3b0ae..61df0c5867be 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -9,6 +9,7 @@
  */
 
 #include <net/udp_tunnel.h>
+#include <linux/quic.h>
 
 #include "common.h"
 #include "family.h"
diff --git a/usr/include/Makefile b/usr/include/Makefile
index ee69dd9d970e..8b4133d38da2 100644
--- a/usr/include/Makefile
+++ b/usr/include/Makefile
@@ -31,6 +31,7 @@ no-header-test += linux/omap3isp.h
 no-header-test += linux/omapfb.h
 no-header-test += linux/patchkey.h
 no-header-test += linux/phonet.h
+no-header-test += linux/quic.h
 no-header-test += linux/sctp.h
 no-header-test += linux/sysctl.h
 no-header-test += linux/usb/audio.h
-- 
2.47.1

