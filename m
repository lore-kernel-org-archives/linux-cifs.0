Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794241761;
	b=2+CSnCMakQyltgB74CxN78VcapAfn5bESy5UKsnS3QgKpFdxBopWr550wHO6zuaJMpDp
	 KyOm/czc/QkO8pmrWZhzSuxmG4OfalmDzJGkXhmrD8k5mIeY2TIUsRWDFH5NJ++jc5hp1
	 rql4bckV0L0Z3TGY1GX3KdreLhyJ3ZzO/44r91H0nKQipj7CqqCmfOdvXol4qCx02CUX/
	 pTCdmUVvvfNRfHsfXpc3C/gSJvrJmLeZPJSAlZ5JicW+WL8ohqQSfKoXmKDaikSQEvrRZ
	 m1Sls++JAJt0fBiJsByTuqdRMIC8K9s5ifSTPYIPtdTZR7v8dZEa08hk6mVW3Dgd0Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794241761;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8yAXsAMAwQd/0CLFQWQDzpucG2HyynwJ/ilcsAfb7lQ=;
	b=3T5N8Bf+5ywvXuf2Dg4LHC9dRUYvJvYsyyjwHzIIBm7L/nb3mQnw85f7WSyG6tz7CjIc
	 RGEw+o0Cg20+B27eT3h3nK/jXYrBxRK2LxUBllKMEZcdYWW+Y6CLW2quHz6EPPI1yJVkw
	 6BoWohPb/sUkf+kydC1C0/ZbHJ30qnZPXpxR5TzbjArGlc/8Oe/cgyd3XUcOphODJ2S2T
	 lBZrHVwVlC+9L+mc1J67tFwSCz1jzDxyp64QO48QI8KGCC+BG+zNsCyS/oVPt8dTbIPYS
	 fRAeT1enQz54qEty/cS4HTS9H4G8DFhjbCucugfxdPDS5Zd8SWaZbSmE43LuIdC+cRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QEav9Ds7;
	arc=none smtp.remote-ip=209.85.222.170
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B60C606A337
	for <linux-cifs@vger.kernel.org>; Mon,  9 Nov 2026 16:29:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B60C606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QEav9Ds7
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-9440304604aso109845285a.0
        for <linux-cifs@vger.kernel.org>; Mon, 09 Nov 2026 08:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794241759; x=1794846559; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8yAXsAMAwQd/0CLFQWQDzpucG2HyynwJ/ilcsAfb7lQ=;
        b=QEav9Ds7ZO3YTrw4j7B51GzmXupisBNi77By3j9AnHyEKDrf3kg4vIP1kpOHx0JQys
         WI9fhpLTG3D+55EAHBj0jnnS8RvJJiHFpj0vPBc+1A1sNPetnecWCeA8PzzXlayILxr7
         scRJcktvsmyoFq4P23mawcCl+fv2IOdTGUCL2JVXwxAKkZDvQ+1ctM3/jLVSx7sV2/XI
         zy4kTZYcoHWRptkDhBztWMpU82CMjjjGdrsXRGYyvFzygHQeFw5KwEG3jbVI+pcYhGzd
         1o4zc/MDpc3BKKbrBJ94gtuh4jmgmTLVKVDO29jTybR/as/X/Ymb2HacPy1DiEkXVo7G
         XzLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794241759; x=1794846559;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8yAXsAMAwQd/0CLFQWQDzpucG2HyynwJ/ilcsAfb7lQ=;
        b=kndCWgJS3sbnGwmO+uZApv3gpY1FfNxNQ+8FYTMKHJRc3ezo/O0z/xKGVrH0OdzSdv
         C7kPEp0YKpqAyPNJbJ5x69DT7rJU1CLZkluyO7fhOkQnaO4Emjvuio+dZA1DUf/ct+2v
         j8Qbt3j/6yMwv9nYuPbGoekTaoZn8O5YQoTgvXyI0aODbTuio13XkLsAwCLZN9HCInP9
         QWioUxGHl3qH5xqnRNWuLYaXofd4EPsHxndOa8Qi/+BXWmxBZf1kkQde42sHhiR+tokj
         KPUUjftFPqEfWlZC9TUjJgR6bG+WwqP24TP5gtumFC9SctCBrZmj/2dDvAtR3qJO1FBP
         BuDA==
X-Forwarded-Encrypted: i=1; AL+hErHIbNonmAmZWn5BKq2cLDUA/zcRGDGzKhz2aR0dVlCxZ0q3gkvbAWR/mcIXOGgo25ZIRIAC8NTmnozs@vger.kernel.org
X-Gm-Message-State: APuU4Z9qIqcp9Cy25Rg2y8n0N+eFT2F0z4hKR0bAmJl5fGWcnW4Cx9yy
	o6woolPZugspboo2/6GIhFN6IaDrT0x+ZeIPyrt5Rup8XQb3bhFBc7M8
X-Gm-Gg: AYBFou2QDk9lc7McQHkl+TJwA5e8iugNxbDCQHSbQK3e1u+/1zk8KzzD/+o1xaUZf1L
	aTUKwx+dygq8QbMlqt1K4tfXflYDwgcuOt8PNBaRLCcmtsps8A0WCYll7RukfwEkoxc7biYbkBa
	E7ZfmKOFyX2XYBvyep+0WB/DvjCeLxIchKutdm27l+ZDSVPVfX62ntwU/YO6XgINRT0tXSGUAoV
	7q8q+g7wui4BlCohu76IjPWgfU4vMkN7UDLngM5S4/6oVuhkOCx7UZpSLh00W3Bc1uTtYHOmNJ5
	uP3Xkcb3k2z0iN1UDbu0ZNJfpLR737DT9jPivkiCfEoYGDtrxOU4X6uBIlzT2W8VZA59Ryv4ojc
	QoaNvoz3RId+UEke9qAApB3xTgeEvpOg6JjcW/eE+IdACEHBDPJ6wX+vKbjLVKGoL/Jc+zd6/4z
	6oDgDID6tom3QaquMeHOV/xweLVkCtnC+l7BTSk8gy4c6CffOCbOWaR4dgeA+DUgwChXmxcr/0x
	d2ZRctMG7m3anwoLjNw7xNCAkaLU0IPmCHbfxrd1LooeC7+3VU2lKKW/vpGtz4biB9XFMD1b6yY
	4NwebU+G0Z6daDMuhFIvAcQd+6XOQQD4iDtT98+WaUPHJZxp6SAQXOLtUOg+zKZFVJ3OL33g/ZP
	sKOlACkFDfzMTKLJ0K9KOV0D/GXHmFiWSfL5l/NxvRsSTARjiA4HvR61m86PzCFas0qLty8A=
X-Received: by 2002:a05:620a:2a09:b0:93e:c12d:4ecc with SMTP id af79cd13be357-94604e57fc1mr1003820385a.44.1794241754698;
        Mon, 09 Nov 2026 08:29:14 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e7915e2sm9102985a.23.2026.11.09.08.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:29:12 -0800 (PST)
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
	Chuck Lever <cel@kernel.org>,
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
Subject: [PATCH net-next v18 05/15] quic: provide quic.h header files for kernel and userspace
Date: Mon,  9 Nov 2026 11:27:26 -0500
Message-ID: <279b5a89da46f1050c2bcaa43194e9490ebfc2fa.1794241655.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794241654.git.lucien.xin@gmail.com>
References: <cover.1794241654.git.lucien.xin@gmail.com>
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

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Thomas Dreibholz <dreibh@simula.no>
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

  - Ignore the concern about union quic_event lacking a type discriminator.
    The event type is provided separately and union quic_event is only used
    to parse the event-specific payload; it is not intended to contain the
    type itself. Embedding the __u8 type at the beginning would also
    introduce unwanted padding and memory holes in the UAPI layout.

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
v16:
  - Update the function annotations for quic_do_set/getsockopt() to reflect
    its actual usage, as optval argument can point to either a user or
    kernel buffer (noted by Sashiko AI review).
v18:
  - Change frame in struct quic_connection_close from u8 to u32 to avoid
    truncating frame types in the next patchset.
  - Add an explicit reserved field to the end of struct quic_stream_info
    and struct quic_errinfo to replace implicit trailing padding caused by
    the __s64 and __u32 field alignment on 64-bit architectures.
---
 MAINTAINERS               |   2 +
 include/linux/quic.h      |  38 ++++++
 include/uapi/linux/quic.h | 242 ++++++++++++++++++++++++++++++++++++++
 net/quic/socket.c         |  36 +++++-
 net/quic/socket.h         |   1 +
 usr/include/Makefile      |   1 +
 6 files changed, 316 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/quic.h
 create mode 100644 include/uapi/linux/quic.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 9849d0dad4f3..0d71fc39d617 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23319,6 +23319,8 @@ M:	Xin Long <lucien.xin@gmail.com>
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
index 000000000000..c5ce84b9c98a
--- /dev/null
+++ b/include/uapi/linux/quic.h
@@ -0,0 +1,242 @@
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
+	__u32	reserved;
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
+	__u32	reserved;
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
+	__u32	frame;
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
index 9b03fd436237..def966eb3016 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -112,11 +112,25 @@ static void quic_close(struct sock *sk, long timeout)
 	sk_common_release(sk);
 }
 
-static int quic_do_setsockopt(struct sock *sk, int optname, sockptr_t optval,
-			      unsigned int optlen)
+/**
+ * quic_do_setsockopt - set a QUIC socket option
+ * @sk: socket to configure
+ * @optname: option name (QUIC-level)
+ * @optval: user or kernel buffer containing the option value
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
@@ -128,11 +142,25 @@ static int quic_setsockopt(struct sock *sk, int level, int optname,
 	return quic_do_setsockopt(sk, optname, optval, optlen);
 }
 
-static int quic_do_getsockopt(struct sock *sk, int optname, sockptr_t optval,
-			      sockptr_t optlen)
+/**
+ * quic_do_getsockopt - get a QUIC socket option
+ * @sk: socket to query
+ * @optname: option name (QUIC-level)
+ * @optval: user or kernel buffer to receive the option value
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

