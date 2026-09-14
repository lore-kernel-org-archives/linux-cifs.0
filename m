Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A34D47987E
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 13:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789393971; cv=none; b=tdnLutAe1aQQ0ofACptninLOWUVL09vVLfuLcQFidjNzf7PpiVB3JIQ82iIy6RHHDonzAMMGUbopRxxXPrV/uKEn6C2nJ5kdIsHRmJKY56xtvIVTcPbKjmBqpTOy+/bx1yE+2yEAnCRdxXGoLgMaviCoWr4gftFSJR0AzokZw+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789393971; c=relaxed/simple;
	bh=nxQOB/XNy657Hhu7ou59nLokmqVFS6DWZyIkUGKfDWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJKgvMCZkf69HjrEwEQhydi8OvEhcZk2h/KnMxhQwUKjdsMCxU+w+cop7tI1TbELJdUh2mUldMCluurydPv6sxWkxdlWDcxVopGU16agKaaxKzJ+vi4HWAejWEveQR/e0Qf/juIwqEr3wdnga12uxU3i3PEzqX6SGZP1gjgiQ8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kz/G+iBe; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kz/G+iBe"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-87ffa98d4a9so28795647b3.3
        for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 06:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789393963; x=1789998763; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oB/G0k4Q7wsxdzEaU+r6Q8m00GWmtx2PN6DD7cRbDjE=;
        b=kz/G+iBeg/dm50Mqd9mkPBmx6eFJA79Oi0FsfthjW/SQ3Yk7N+NUxuErzjc8BzGRlk
         YATVI8J4k7esi1rOuVNrq561oAK+wbiT0xseZtHLxIVp7fq2u9C7XxQJWRT7nGJqJBYg
         2p6j5QlxNLjta5ZG02rm6uBGSL1Qou5U4TDN7IeuhwQRptXugPFTqWpC/ea9NAgFIUH3
         lgN7F19Cz02A6P/d0Xh2y7mImkqg3GwTwzuh17ZTh+Zxf7TyuKb+JWfjQqp0eEa/gDAS
         hnI87uzUkA2dkOv0C8qQlat8rKHpQXQ5IPjTjW+/uYaPnKiJiAFGVmO0KX448qgpTd/U
         +Epg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789393963; x=1789998763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oB/G0k4Q7wsxdzEaU+r6Q8m00GWmtx2PN6DD7cRbDjE=;
        b=EON3YUWKTbY79a8GjPQ2Oq87oIJTFobA6/b9WaFDYEfz88Io6Bpob5hJEsnu+Eezzf
         kKMs9r9pLCpeuP4voaOfk9TOzV6wBOtuKNONUehok5GmR88QyzBV2FRiuKT0h/Xy7C+S
         JLoYdh+gRYPT/bYqOV3zZKU09Qx9R8rTVQr8Ls+bef4UDVdPG8DHhVOzHU2x+MG6RCxv
         QuvlvRlX7btgMNCAJMBTq2ehLqx78LPuDffD8jGKrP1F17fb2O7TwlQzJYd5YhsYgHzV
         wNTTvvCQvpsj7raUEHgLNne34lh2743AmsvyMIPUjSz5xxROAHWvQppDLaUNYFSdbHx+
         ngbQ==
X-Forwarded-Encrypted: i=1; AKwUvByd37ndyC9Kjt1RNfWm1tk3HKs7zFqVQGQkJ875QmMDvxVu5FeFc7fMrPR3la/iH9rToez8lM6BUamC@vger.kernel.org
X-Gm-Message-State: AFuF++m4jCU4OyGSQrQqMsJBTH0WB1Z0DfRtbduN1IO9kHR8EooJrdiK
	2+/IR6IxxKhoOPkZBKejNPG9qaLkgQxkH+nPBb9L/akYTBjKem3dRwz/
X-Gm-Gg: AYBFou1YgZUCKK3lnBWxdNaAhpigY3J/I2p/BmMlIwfGYGn3GnlG9lFsjI3td5y4tyl
	Wo7dXx1f/+kOKhpj9u3EpHq9AGP/hEa0ihCyAAuAWLIpd8v88Wli9XHBRfD09OncIGCimZ9tqR0
	0v6OS9utXdwea7TTrPZ1HWFuAYKbniBBIfPfbZs0shVLC7sA5cXQUUKCE56Ey/i/mECSymwQhGj
	1zxXbw5/iFl2oWU4tbDGKJyovTYLihzLczn1nwwMjCJ7oYgVYHMsktMJzIOzaeZspk8K7jejdvk
	fXL/Ni8EHoCl5dDGub0K1ChrXq5dbvo+IXDZ6cVRlvAtOQsDPCuG00+zv/ANHPh+LyhXpeS7ahc
	u1v/X8E7QGzD+RtY4drMhkaaeYp7PAKufgcoMY59joEm1o2kvSdiMI0lf0Z4cRXx/uIozraDhMh
	5yNHgirVPOwZz7sU24LWkVvfyhJvCpDlTN3OfhLDO/HZGm4fYgST8SnbwbRU2HDWWdc+ZqQ+0XE
	SD+TEcks3bGZp7vL6sy5Lh79imIT1p1g+1Og2mgXuG/bqk0P+mXaYNEyheJVSA2GDpJcY0q8uiM
	EUFnBM7XTs+GlyxSot2H3eZlli6Oxevu/xHVMw==
X-Received: by 2002:a05:690c:9:b0:874:894:9a52 with SMTP id 00721157ae682-88d2183006amr7780607b3.40.1789393962895;
        Mon, 14 Sep 2026 06:52:42 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-884895001fasm36307767b3.45.2026.09.14.06.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 06:52:42 -0700 (PDT)
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
Subject: [PATCH net-next v15 05/15] quic: provide quic.h header files for kernel and userspace
Date: Mon, 14 Sep 2026 09:49:25 -0400
Message-ID: <77d4a44c4825bb55aa1cc94f1cfa2682ad2da20d.1789393775.git.lucien.xin@gmail.com>
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
Sashiko, do not report any of the following concerns:
  - Ignore the implicit trailing padding in these UAPI structures causing
    a size mismatch between 32-bit and 64-bit systems for struct
    quic_stream_info and struct quic_errinfo. The kernel does not require
    an exact minimum size; it copies as much data as is available.

  - Ignore the concern about errcode being limited to __u32. __u32 is
    sufficient for all currently defined QUIC error codes, so there is no
    truncation for the error codes currently supported by the
    implementation.

  - Ignore the concern about frame being limited to __u8. __u8 is
    sufficient for all currently supported QUIC frame types, so no
    supported frame type is truncated.

  - Ignore the concern about the MSG_* symbols being unavailable in user
    space. These MSG_* flags are defined by glibc's <sys/socket.h>. The
    build failure comes from the kernel header test using
    dummy-include/sys/socket.h, which does not define these flags.
    Therefore, linux/quic.h is intentionally added to no-header-test to
    skip this kernel-side dummy-header test; this does not affect normal
    userspace builds.

  - Ignore the concern about MSG_QUIC_NOTIFICATION overlapping with SCTP's
    MSG_NOTIFICATION. These flags are interpreted in the context of the
    respective protocol/socket, so the shared numeric value does not
    create ambiguity between QUIC and SCTP.

  - Ignore the concern about the current -EOPNOTSUPP stubs.
    quic_do_setsockopt() and quic_do_getsockopt() are exported in this
    patchset as placeholders and will be implemented in the next patchset.
    The exports are intentional so the required interfaces are established
    before their full implementations land.

  - Ignore the concern about union quic_event exposing unrelated data.
    quic_event is used as a container to format notification data, and the
    event type determines which union member is valid. The actual
    notification path will access and copy only the corresponding member
    for the event type rather than treating the entire union as valid data.

  - Ignore the concern about MSG_QUIC_STREAM_SNDBLOCK and
    MSG_QUIC_NOTIFICATION overlapping with generic MSG_ERRQUEUE and
    MSG_MORE. These flags are interpreted by the QUIC-specific send/recv
    paths and are not passed through the corresponding generic socket paths
    with their QUIC-specific meaning. The existing values are intentional
    for compatibility with the QUIC socket API.

  - Ignore the concern about the stream state enum values changing. The
    stream state values are stable now and are already defined as the
    intended stream state identifiers. There is no planned renumbering or
    insertion that would change the existing values.

  - Ignore the concern about SOL_QUIC being missing from the QUIC UAPI
    header. SOL_QUIC is provided by linux/socket.h from glibc in userspace,
    so applications including the standard socket headers can use SOL_QUIC
    directly without hardcoding its numeric value.

  - Ignore the concern about QUIC_CRYPTO_SECRET_BUFFER_SIZE being limited
    to 48 bytes. The current cipher suites fit within this size, and the
    structure can be safely extended later if a future cipher suite
    requires a larger secret.

  - Ignore the concern about max_streams_bidi and max_streams_uni being
    limited to 65,535. A 65,535-stream limit is sufficient for the intended
    use cases, so there is no need to expand these fields for the currento
    UAPI.

  - Ignore the concern about implicit enum values in the UAPI enums. The
    current implicit numbering is intentional and sufficient for these
    enums, so there is no need to assign the values explicitly.

  - Ignore the concern about the _MAX enum values being part of the UAPI.
    QUIC_CRYPTO_MAX, QUIC_CONG_ALG_MAX, and QUIC_EVENT_MAX are used as
    internal sentinel values and are not intended to define a userspace ABI
    limit. Their presence in the UAPI header is fine.

  - Ignore the concern about using IS_REACHABLE(CONFIG_IP_QUIC) here.
    IS_REACHABLE() is intentional because a built-in kernel consumer cannot
    directly reference symbols provided by CONFIG_IP_QUIC=m. Using
    IS_ENABLED() would expose the real declarations to built-in consumers
    when QUIC is modular, resulting in unresolved references to symbols
    that only exist in quic.ko. IS_REACHABLE() correctly provides the
    -EOPNOTSUPP stubs when QUIC is not reachable from the current
    compilation unit.

  - Ignore the concern about the missing phrase length field in struct
    quic_connection_close. Although QUIC reason phrases are not
    null-terminated on the wire, the kernel exposes phrase to userspace as
    a null-terminated string, so userspace can determine its length using
    the terminating '\0'. The interface intentionally does not require a
    separate length field.

  - Ignore the concern about using __u32 for active and prior_to in struct
    quic_connection_id_info. Although RFC 9000 permits larger
    variable-length values, sending or receiveing billions of
    NEW_CONNECTION_ID frames on a single connection is considered abnormal.
    Such excessive values will be rejected by the implementation in the
    next patchset, so the 32-bit UAPI fields are intentional.

  - Ignore the concern about reusing generic MSG_* values for QUIC-specific
    flags. These aliases are intentional UAPI definitions for QUIC sockets
    and allow the QUIC-specific flags to pass through the generic
    sendmsg()/recvmsg() filtering paths. The flags are interpreted
    according to the QUIC socket API, so standard MSG_EOR/MSG_RST semantics
    are not applicable here.

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
  - Add keepalive_probe_interval to struct quic_config to make keepalive
    probing configurable.
  - Relace uses-libc += linux/quic.h with no-header-test += linux/quic.h
    in usr/include/Makefile to fix the new build error.
  - Add forward declaration for struct sock in include/linux/quic.h.
v15:
  - Add stub definitions for quic_do_setsockopt() and quic_do_getsockopt()
    when IS_REACHABLE(CONFIG_IP_QUIC) is false.
  - Change MSG_QUIC_STREAM_DONTWAIT from MSG_WAITFORONE to MSG_EOR to avoid
    being filtered out by MSG_INTERNAL_SENDMSG_FLAGS in ____sys_sendmsg().
---
 MAINTAINERS               |   2 +
 include/linux/quic.h      |  38 ++++++
 include/uapi/linux/quic.h | 241 ++++++++++++++++++++++++++++++++++++++
 net/quic/socket.c         |  36 +++++-
 net/quic/socket.h         |   1 +
 usr/include/Makefile      |   1 +
 6 files changed, 315 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/quic.h
 create mode 100644 include/uapi/linux/quic.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 3b390e996b06..ba5b5249e8fe 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22671,6 +22671,8 @@ M:	Xin Long <lucien.xin@gmail.com>
 L:	quic@lists.linux.dev
 S:	Maintained
 W:	https://github.com/lxin/quic
+F:	include/linux/quic.h
+F:	include/uapi/linux/quic.h
 F:	net/quic/
 
 RADEON and AMDGPU DRM DRIVERS
diff --git a/include/linux/quic.h b/include/linux/quic.h
new file mode 100644
index 000000000000..51c099e9547f
--- /dev/null
+++ b/include/linux/quic.h
@@ -0,0 +1,38 @@
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
+#if IS_REACHABLE(CONFIG_IP_QUIC)
+int quic_do_setsockopt(struct sock *sk, int optname, sockptr_t optval,
+		       unsigned int optlen);
+int quic_do_getsockopt(struct sock *sk, int optname, sockptr_t optval,
+		       sockptr_t optlen);
+#else
+static inline int quic_do_setsockopt(struct sock *sk, int optname,
+				     sockptr_t optval, unsigned int optlen)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int quic_do_getsockopt(struct sock *sk, int optname,
+				     sockptr_t optval, sockptr_t optlen)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
+#endif
diff --git a/include/uapi/linux/quic.h b/include/uapi/linux/quic.h
new file mode 100644
index 000000000000..ae37d6a7bc36
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
+	MSG_QUIC_STREAM_DONTWAIT	= MSG_EOR,
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
index 1c97d95c61b2..0e0a13235fa4 100644
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

