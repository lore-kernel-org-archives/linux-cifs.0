Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794241772;
	b=B/ohwy6XgwlZDYhh+5hp1FAdBTOEzDJmQ6hZvIH/UA0t1uKSMXtucI/HvgkNef6qMTB5
	 GpJrBBK5sEPdbjoE6W/OkVnSpklfowibghbBwCAMdG1zjYCzCqpYrO2qSMOCXePqPMlsJ
	 GWl9rxgLlenOx3kksAaUbrQI+nmLMyh6ZTfKiWuTP6jDLIuOTP8ogyXvkh5WjV4QsZxbd
	 JLHTMp41FGG42FmIv2oF6Zw8HblCPrwyd3XVFeuH6/eD13D7qcmTzvGusIr1iQmhuJq84
	 BvLDKwpbAdq4M9nEqppFsRgRpEYc5qf0GJIFQBSffhhrnYGuyvEk+bT1SkCyF0uDtjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794241772;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9uGSYggaNEPzKt2/hsVCz40RdoQwrR5MiDvzyqYfubs=;
	b=uNuwitSajrYRAKO3/5J4iX8c/m0s+o2tdYQ1y+4aCUGYqULc41czSGA5bEIXfJ20ZM8p
	 mIXQ4nIFwSPDk7BaKc5InwnSsZE4riM5Eynu+sevOM5HW1stEUtcpqQGn+YAyji5oFY/U
	 e7nmEP2Ku1Bce6myFsGqK6llA6Sy9ROwen+BVf58QYtrvaTOGMtdxQxCyaPNSXfbtDAvW
	 CYZpUDEpmDXTXG3AMl29d6jav3vr3FaM0Ul8hvR5bhfNhVML+hnfIE6kJYZfMR+kAnLA/
	 31JGeBrzDmhpNmF/oJ5zcFtsOAS3qiqYI5t9tGuc439tCQ/aqHBdwrNEjpvAhhilSfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Uhw3nagO;
	arc=none smtp.remote-ip=209.85.222.175
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91DF606EEA4
	for <linux-cifs@vger.kernel.org>; Mon,  9 Nov 2026 16:29:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C91DF606EEA4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Uhw3nagO
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-93f2f2edb19so90885885a.0
        for <linux-cifs@vger.kernel.org>; Mon, 09 Nov 2026 08:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794241771; x=1794846571; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9uGSYggaNEPzKt2/hsVCz40RdoQwrR5MiDvzyqYfubs=;
        b=Uhw3nagO0wLFTVD4CE4hlLLAo+l3c3mF3J5gHkleeGbe5n5IEeEmvKPnqH+8mV1Qyu
         MZnDtMxLbbc01JaWoHyt4s3pIUpoxu5u2M4Dmiy9dWO3VXz4j54khGO9jFOj9BiD7WpH
         /mJ9zwZjZ5HgnkoCGZ+GdISGHI2uKKCy00VpDzpwcV5CmixMtJ1MN2FyyEq/Ve0hbhog
         Xoke742vb24i42nTPmmNQGjMu0urCoqbFjzhHb2Y5UVX58JCMkQhKcCxRwtll4SwbGsq
         GMxSxlvpJnTw7q+S6hgXnG8rM2lp4qxjy6eG4Jj7+c05M1a970gdjPbqyji6bXDtmms9
         Dkuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794241771; x=1794846571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9uGSYggaNEPzKt2/hsVCz40RdoQwrR5MiDvzyqYfubs=;
        b=BxsGCsI1lg2QDKrLXrtT8aQKO/64X4kPLtAuSizcUGtA33h6RZs5I4fE3vjE09jq38
         jnsYhvo+I2lTBdxcxFBmnHsoMoI9gHIB/+WS87CXmHKOaWO651wE+CSZWu/SdRIDDm3H
         jY3i4B/ReYOsS1aqjnjkl63qHXHG2I8rk8Oax4YSLABrDV1mJRAzBCYx6hXLWDRp3edj
         m/pA4Z0qCZWmoZgdKrwkasRAxXz9v49PgekvC0PTwhErPNo1nAaWTu57dKnIMJXKLeE6
         4FEY3CnFaSADanyDlwxxJ/ui5FkJmnQB3TALkQvpdCHZFMjDY+dAB2EFr023YY1N/kK4
         Wt2Q==
X-Forwarded-Encrypted: i=1; AL+hErGYzm1HldlloFpgHj5Ep6uh9X363dzmzMnXK241HwyS7vY86oBz5zjwpreBhcyVrbzaPne+bQO5CS5P@vger.kernel.org
X-Gm-Message-State: APuU4Z93hxF+l/WrklaUeObuavae3XeUZVEG3BZqxNl7eYuzBWqYx3Nj
	B6J5kjYWhwGKzTZV+uX/M0ls3mhOsYFc/AJjK4D/gkGha/nn4NWSg+W5
X-Gm-Gg: AYBFou15llDiEiyN3nLAL41E/tGGoxKj9Y2Ov2la4gXsdJ0M7TCeyMU8e9dvzoRL6Zy
	NOloR8XDLUHXt7dvrvassgxLgGsJQADh2JilWzrZeyU+vaHZzZElOH3txY2V+yE/eg85fGoGoeD
	4HcHN24QFRUBThzN88oz3da9Nzso3+lynqc61mPo3KBcOL4EDEjXu9fwJhdmpMSyVOoozJJm0qM
	x0rtSYVuEgNS7FYUSG/WqxdAmN9nThKWZN4w3uIqQZl7vAJ75v/faE5pg7DOOzT9ESXm2S+h7zj
	vGxu16WPH6jOimRE2MPMXjAuYcU69coSwCKZuXWnKBidRPfUJ8CkrOMaCmTDKmZIVhBSlG3fyeA
	ge3bsRbNEThLJa+2MpnRUh3pMfGtxbSUocdCIEkXIS8OBFBZM3yCTIB062DPZ6lbZB3vSyKYpHY
	fJU+rOgJ3flHDU+GL4J1//VSDe6RkIB8R6f8dCpVJ2bs8V1yX95pl5o9D55YF9T+8mOSvjg5yGw
	h1rw8H0YaoWY5dQ8NYZA6CT6Hnf0/ISyb2zYCtxTf8KyCpXAEv/6weKTGv0DHtL5ckToCOQ8P3N
	QwKuzYuVtk+53hi54akXYQMgKyJDlaDbUY9rHpZ9q+tlYNn6frsOUnI7dULz8qkUJpOWRfZ0rkE
	Ert93jIEjq0K7dktVoAy/emSep5W+dMcA8e8u4pdekXGWz7rDrY3vGd3GSiHNYdG+J13hwkQ=
X-Received: by 2002:a05:620a:2b46:b0:93f:3e39:efa1 with SMTP id af79cd13be357-9478485e333mr729465385a.23.1794241770386;
        Mon, 09 Nov 2026 08:29:30 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e7915e2sm9102985a.23.2026.11.09.08.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:29:29 -0800 (PST)
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
Subject: [PATCH net-next v18 14/15] quic: add packet builder base
Date: Mon,  9 Nov 2026 11:27:35 -0500
Message-ID: <389f35db3403dbfe09727dd84db98b48dedc91c7.1794241656.git.lucien.xin@gmail.com>
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

This patch introduces 'quic_packet' to handle packing of QUIC packets on
the transmit (TX) path.

It provides functionality for frame packing and packet construction. The
packet configuration includes setting the path, calculating overhead,
and verifying routing. Frames are appended to the packet before it is
created with the queued frames.

Once assembled, the packet is encrypted, bundled, and sent out. There
is also support to flush the packet when no additional frames remain.
Functions to create application (short) and handshake (long) packets
are currently placeholders for future implementation.

Key functions:

- quic_packet_config(): Set the path, compute overhead, and verify routing
  via quic_packet_route().

- quic_packet_create_and_xmit(): Create and send the packet with the queued
  frames.

- quic_packet_flush(): Send the packet if there's nothing left to bundle.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
Sashiko, do not report any of the following concerns:
  - Ignore the potential sk_wmem_alloc underflow when fragmenting bundled
    QUIC packets. Although the original QUIC skb uses
    skb_set_owner_sk_safe() and is not charged to sk_wmem_alloc, IP
    fragmentation assigns ownership to newly created fragment skbs through
    skb_set_owner_w(), which performs the required socket memory accounting
    before sock_wfree() is used.

  - Ignore the potential socket and skb leak from packet->head during
    socket destruction. packet->head only temporarily holds bundled packets
    during a single sending cycle and is always flushed before the cycle
    completes.  Therefore, there cannot be an outstanding skb referenced by
    packet->head when the socket destruction path is reached.

  - Ignore the concern about mss[QUIC_PACKET_MSS_DGRAM] not being updated.
    mss[QUIC_PACKET_MSS_DGRAM] will be set in quic_packet_mss_update() in
    the next patchset based on max_datagram_frame_size, so the current
    patch intentionally does not update it yet.

  - Ignore the concern about quic_packet_overhead() overflowing its u16
    len. quic_token(sk)->len will be limited to QUIC_TOKEN_MAX_LEN (120)
    in the next patchset, so the token contribution cannot cause the u16
    calculation to wrap.

  - Ignore the concern about pending bundled packets being misrouted after
    a path change. Path migration happens only after the handshake is done,
    at which point only short-header packets are sent. Short-header packets
    do not use packet bundling, so packet->head is NULL when
    quic_packet_empty() is true. Therefore, there are no old-path bundled
    packets to flush when changing packet->path.

  - Ignore the concern about quic_packet_route() constantly resetting
    PLPMTUD. quic_packet_route() only resets PLPMTUD when quic_flow_route()
    returns 0, indicating that the route cache has expired. In that case,
    the route needs to be refreshed and MTU discovery must be performed
    again.

  - Ignore the concern about using bitwise OR to merge ECN flags. cb->ecn
    can only be set to INET_ECN_ECT_0 in the next patchset, so the OR
    operation cannot produce an unintended CE codepoint.

  - Ignore the concern about ipfragok being enabled for application packets
    in quic_packet_config(). In Linux QUIC, QUIC_CRYPTO_APP is defined as
    0, so level being nonzero specifically identifies the handshake
    encryption levels.  Therefore, level && ... does not enable
    fragmentation for application packets.

  - Ignore the concern about using !cb->level to identify short-header
    packets in quic_packet_bundle(). In Linux QUIC, QUIC_CRYPTO_APP is 0,
    so application packets have cb->level == 0 and !cb->level correctly
    identifies them for bundle flushing.

  - Ignore the concern about leaking the socket counters in
    quic_init_sock(). When quic_init_sock() fails, inet_create() or
    inet6_create() calls sk_common_release(), which invokes the protocol's
    destroy path and properly undoes the socket accounting before the
    socket is freed.

  - Ignore the concern about packet->ipfragok not being applied to the
    outgoing skb. skb->ignore_df is set based on packet->ipfragok when the
    skb is created in the next patchset, so the setting is correctly
    propagated to the transmitted packet.

  - Ignore the concern about packet->mss[QUIC_PACKET_MSS_NORMAL] falling
    below QUIC_MIN_UDP_PAYLOAD. QUIC_MIN_UDP_PAYLOAD is only used as the
    minimum size for Initial packets when building or parsing them; it is
    not a minimum for the general UDP payload or MSS. Therefore,
    QUIC_MIN_UDP_PAYLOAD does not need to match QUIC_PATH_MIN_PMTU or
    QUIC_BASE_PLPMTU, and the resulting MSS is valid.

  - Ignore the concern about existing or nested frag_list entries in
    quic_packet_bundle(). On the QUIC TX path, there is no code, including
    skb_cow_data(), that appends an skb to the head skb before packet
    bundling, so the head cannot already have a frag_list from this path.
    Likewise, the skb being bundled does not carry a frag_list that would
    create a nested fragment list here.

  - Ignore the concern about silently ignoring encryption-level or path
    changes when a packet is pending in quic_packet_config().
    quic_packet_tail() will be added in the next patchset to verify that
    the requested level and path match the current packet configuration
    when adding a frame to the packet frame_list. If they differ, it
    transmits the pending frames before calling quic_packet_config() with
    the new configuration.

v3:
  - Adjust global connection and listen socket hashtable operations
    based on the new hashtable type.
v4:
  - Use quic_wq for QUIC packet backlog processing work.
v5:
  - Rename quic_packet_create() to quic_packet_create_and_xmit()
    (suggested by Paolo).
  - Move the packet parser base code to a separate patch, keeping only
    the packet builder base in this patch (suggested by Paolo).
  - Change sent_time timestamp from u32 to u64 to improve accuracy.
v8:
  - Remove the dependency on struct quic_frame by returning NULL in
    quic_packet_handshake/app_create() and dropping quic_packet_tail()
    and struct quic_packet_sent. This effectively strips out patch 14
    (suggested by Paolo).
v9:
  - Warn on oversized header length in quic_packet_config() (suggested by
    Paolo).
  - Factor bundle initialization into a common 'init' goto label in
    quic_packet_bundle() (suggested by Paolo).
  - Clarify comment for packet->ipfragok in quic_packet_config().
v10:
  - Set MSS to QUIC_MIN_UDP_PAYLOAD in quic_packet_init(); it serves only
    as a default for procfs dumps before a connection exists.
  - Introduce QUIC_PACKET_INVALID as a return value for invalid packet
    types used in the later patch.
  - quic_sock.config.plpmtud_probe_interval has been moved to
    quic_path_group.plpmtud_interval, so update its usage in
    quic_packet_route() and quic_packet_config() accordingly.
v11:
  - Set maximum line length to 80 characters.
  - Change return type of quic_packet_empty() to bool.
  - Propagate errors from quic_packet_route() in quic_packet_config()
    (noted by AI review).
  - Use quic_packet_taglen() instead of open-coded logic in
    quic_packet_mss(), quic_packet_max_payload(), and
    quic_packet_max_payload_dgram() (noted by AI review).
  - Replace some magic numbers with QUIC_PACKET_FORM_SHORT/LONG and
    QUIC_PACKET_MSS_NORMAL/DGRAM (noted by Paolo).
  - Use WARN_ON_ONCE() instead of WARN_ON() in quic_packet_xmit().
    skb_set_owner_w/r() cannot be used here because it performs memory
    accounting, which is not desired in this context (noted by Paolo).
v12:
  - Set the minimum PMTU to 1200 in quic_packet_route().
  - Increase overhead in struct packet from u8 to u16, update the related
    cast and remove DEBUG_NET_WARN_ON_ONCE() in quic_packet_config().
  - Fix the MSS-based bundling size check and call skb_orphan() before
    bundling the skb in quic_packet_bundle().
  - Remove the quic_packet_xmit() declaration and mark it static.
  - Extract quic_packet_overhead() from quic_packet_config().
  - Change quic_packet_create_and_xmit() to return 0 on success and an
    error code on failure.
  - Remove errframe, errcode, frame_len, and ack_requested from struct
    quic_packet as they are no longer used, and update
    quic_packet_reset() accordingly.
  - Move ack_eliciting reset from quic_packet_config() to
    quic_packet_reset(), as it will only be used on the RX path.
  - Add padding as u16 in struct quic_packet to represent total padding
    bytes appended after frames.
  - Add path_validating in struct quic_packet for TX path to indicate
    whether a path_validating frame is included in the packet, and reset
    it in quic_packet_config().
  - Move version and padding fields up in struct quic_packet for better
    layout.
  - Fix the comment for len, frames, ack_eliciting, non_probing and
    has_sack in struct quic_packet.
  - Include taglen when updating the mss in struct quic_cong.
v14:
  - Pass gfp flags to quic_packet_handshake_create(),
    quic_packet_app_create(), quic_packet_number_check(),
    quic_packet_xmit(), and quic_packet_create_and_xmit()
    for allocations in subsequent patches.
v15:
  - Improve the annotation for packet->ipfragok setting in
    quic_packet_config().
  - Set the skb socket ownership for all outgoing packets instead of only
    encrypted packets in quic_packet_xmit().
v16:
  - Update the annotation to match the order of the mss array entries in
    struct quic_packet (noted by Sashiko AI review).
  - Improve packet.c file description.
v18:
  - Use a single MSS field in struct quic_packet for all packets, rather
    than maintaining a separate MSS for DATAGRAM frames.
  - Add last to struct quic_packet to support stream and datagram frames
    without a length field in the next patchset.
  - Replace the taglen array in struct quic_packet with a single field for
    short header packets, as long header packets always use QUIC_TAG_LEN.
---
 net/quic/Makefile |   2 +-
 net/quic/packet.c | 277 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/packet.h |  98 ++++++++++++++++
 net/quic/socket.c |   1 +
 net/quic/socket.h |   8 ++
 5 files changed, 385 insertions(+), 1 deletion(-)
 create mode 100644 net/quic/packet.c
 create mode 100644 net/quic/packet.h

diff --git a/net/quic/Makefile b/net/quic/Makefile
index 2ccf01ad9e22..0f903f4a7ff1 100644
--- a/net/quic/Makefile
+++ b/net/quic/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_IP_QUIC) += quic.o
 
 quic-y := common.o family.o protocol.o socket.o stream.o connid.o path.o \
-	  cong.o pnspace.o crypto.o timer.o
+	  cong.o pnspace.o crypto.o timer.o packet.o
diff --git a/net/quic/packet.c b/net/quic/packet.c
new file mode 100644
index 000000000000..b6f76681b690
--- /dev/null
+++ b/net/quic/packet.c
@@ -0,0 +1,277 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* QUIC kernel implementation
+ * (C) Copyright Red Hat Corp. 2023
+ *
+ * This file is part of the QUIC kernel implementation
+ *
+ * Packet creation and processing.
+ *
+ * Written or modified by:
+ *    Xin Long <lucien.xin@gmail.com>
+ */
+
+#include "socket.h"
+
+#define QUIC_HLEN		1
+
+/* Make these fixed for easy coding. */
+#define QUIC_PACKET_NUMBER_LEN	QUIC_PN_MAX_LEN
+#define QUIC_PACKET_LENGTH_LEN	4
+
+static struct sk_buff *quic_packet_handshake_create(struct sock *sk, gfp_t gfp)
+{
+	return NULL;
+}
+
+static int quic_packet_number_check(struct sock *sk, gfp_t gfp)
+{
+	return 0;
+}
+
+static struct sk_buff *quic_packet_app_create(struct sock *sk, gfp_t gfp)
+{
+	return NULL;
+}
+
+/* Update the MSS and inform congestion control. */
+void quic_packet_mss_update(struct sock *sk, u32 mss)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_cong *cong = quic_cong(sk);
+
+	packet->mss = (u16)mss;
+	quic_cong_set_mss(cong, packet->mss);
+}
+
+/* Perform routing for the QUIC packet on the specified path, update header
+ * length and MSS accordingly, reset path and start PMTU timer.
+ */
+int quic_packet_route(struct sock *sk)
+{
+	struct quic_path_group *paths = quic_paths(sk);
+	struct quic_packet *packet = quic_packet(sk);
+	union quic_addr *sa, *da;
+	u32 pmtu;
+	int err;
+
+	da = quic_path_daddr(paths, packet->path);
+	sa = quic_path_saddr(paths, packet->path);
+	err = quic_flow_route(sk, da, sa, &paths->fl);
+	if (err)
+		return err < 0 ? err : 0;
+
+	packet->hlen = quic_encap_len(da);
+	pmtu = clamp(dst_mtu(__sk_dst_get(sk)),
+		     QUIC_PATH_MIN_PMTU, QUIC_PATH_MAX_PMTU);
+	quic_packet_mss_update(sk, pmtu - packet->hlen);
+
+	quic_path_pl_reset(paths);
+	quic_timer_reset(sk, QUIC_TIMER_PMTU, paths->plpmtud_interval);
+	return 0;
+}
+
+/* Return QUIC packet header overhead for the given level and path. Includes
+ * packet number, connection IDs, and for long headers also version, length,
+ * and Initial token (if present). Excludes payload.
+ */
+u16 quic_packet_overhead(struct sock *sk, u8 level, u8 path)
+{
+	struct quic_conn_id_set *source = quic_source(sk);
+	struct quic_conn_id_set *dest = quic_dest(sk);
+	u16 len = QUIC_HLEN;
+
+	len += QUIC_PACKET_NUMBER_LEN; /* Packet number length. */
+	len += quic_conn_id_choose(dest, path)->len; /* DCID length. */
+	if (level == QUIC_CRYPTO_APP)
+		return len;
+
+	len += 1; /* Length byte for DCID. */
+	/* Length byte + SCID length. */
+	len += 1 + quic_conn_id_active(source)->len;
+	/* Include token for Initial packets. */
+	if (level == QUIC_CRYPTO_INITIAL)
+		len += quic_var_len(quic_token(sk)->len) + quic_token(sk)->len;
+	len += QUIC_VERSION_LEN; /* Version length. */
+	len += QUIC_PACKET_LENGTH_LEN; /* Packet length field. */
+
+	return len;
+}
+
+/* Configure the QUIC packet header and routing based on encryption level and
+ * path.
+ */
+int quic_packet_config(struct sock *sk, u8 level, u8 path)
+{
+	struct quic_packet *packet = quic_packet(sk);
+
+	/* If packet already has data, no need to reconfigure. */
+	if (!quic_packet_empty(packet))
+		return 0;
+
+	packet->path_validating = 0;
+	packet->ipfragok = 0;
+	packet->padding = 0;
+	packet->frames = 0;
+	packet->last = 0;
+
+	packet->level = level;
+	packet->overhead = quic_packet_overhead(sk, level, path);
+	packet->len = packet->overhead + quic_packet_taglen(packet);
+
+	/* Allow fragmentation for handshake packets if PLPMTUD is enabled, as
+	 * MTU discovery does not rely on ICMP Packet Too Big once PLPMTUD is
+	 * enabled.
+	 */
+	packet->ipfragok = level && !!quic_paths(sk)->plpmtud_interval;
+
+	if (packet->path != path) {
+		/* Path changed; update and reset routing cache */
+		packet->path = path;
+		__sk_dst_reset(sk);
+	}
+
+	/* Perform routing and MSS update for the configured packet. */
+	return quic_packet_route(sk);
+}
+
+static void quic_packet_encrypt_done(struct sk_buff *skb)
+{
+	/* Free it for now, future patches will implement the actual deferred
+	 * transmission logic.
+	 */
+	kfree_skb(skb);
+}
+
+/* Coalescing Packets. */
+static int quic_packet_bundle(struct sock *sk, struct sk_buff *skb)
+{
+	struct quic_skb_cb *head_cb, *cb = QUIC_SKB_CB(skb);
+	struct quic_packet *packet = quic_packet(sk);
+	struct sk_buff *p;
+
+	if (!packet->head) /* First packet to bundle: initialize the head. */
+		goto init;
+
+	/* If bundling would exceed MSS, flush the current bundle. */
+	if (packet->head->len + skb->len > packet->mss) {
+		quic_packet_flush(sk);
+		goto init;
+	}
+	/* Bundle it and update metadata for the aggregate skb. */
+	skb_orphan(skb);
+	p = packet->head;
+	head_cb = QUIC_SKB_CB(p);
+	if (head_cb->last == p)
+		skb_shinfo(p)->frag_list = skb;
+	else
+		head_cb->last->next = skb;
+	p->data_len += skb->len;
+	p->truesize += skb->truesize;
+	p->len += skb->len;
+	head_cb->last = skb;
+	head_cb->ecn |= cb->ecn;  /* Merge ECN flags. */
+
+out:
+	/* rfc9000#section-12.2: Packets with a short header (Section 17.3) do
+	 * not contain a Length field and so cannot be followed by other
+	 * packets in the same UDP datagram.
+	 *
+	 * so Return 1 to flush if it is a Short header packet.
+	 */
+	return !cb->level;
+init:
+	packet->head = skb;
+	cb->last = skb;
+	goto out;
+}
+
+/* Transmit a QUIC packet, possibly encrypting and bundling it. */
+static int quic_packet_xmit(struct sock *sk, struct sk_buff *skb, gfp_t gfp)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	struct net *net = sock_net(sk);
+	int err;
+
+	/* Associate skb with sk to ensure sk is valid during async encryption
+	 * completion.
+	 */
+	WARN_ON_ONCE(!skb_set_owner_sk_safe(skb, sk));
+
+	/* Skip encryption if taglen == 0 (e.g., disable_1rtt_encryption). */
+	if (!quic_packet_taglen(packet))
+		goto xmit;
+
+	cb->crypto_done = quic_packet_encrypt_done;
+	err = quic_crypto_encrypt(quic_crypto(sk, packet->level), skb, gfp);
+	if (err) {
+		if (err != -EINPROGRESS) {
+			QUIC_INC_STATS(net, QUIC_MIB_PKT_ENCDROP);
+			kfree_skb(skb);
+			return err;
+		}
+		QUIC_INC_STATS(net, QUIC_MIB_PKT_ENCBACKLOGS);
+		return err;
+	}
+	if (!cb->resume) /* Encryption completes synchronously. */
+		QUIC_INC_STATS(net, QUIC_MIB_PKT_ENCFASTPATHS);
+
+xmit:
+	if (quic_packet_bundle(sk, skb))
+		quic_packet_flush(sk);
+	return 0;
+}
+
+/* Create and transmit a new QUIC packet. */
+int quic_packet_create_and_xmit(struct sock *sk, gfp_t gfp)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct sk_buff *skb;
+	int err;
+
+	err = quic_packet_number_check(sk, gfp);
+	if (err)
+		goto err;
+
+	if (packet->level)
+		skb = quic_packet_handshake_create(sk, gfp);
+	else
+		skb = quic_packet_app_create(sk, gfp);
+	if (!skb) {
+		err = -ENOMEM;
+		goto err;
+	}
+
+	err = quic_packet_xmit(sk, skb, gfp);
+	if (err && err != -EINPROGRESS)
+		goto err;
+
+	return 0;
+err:
+	pr_debug("%s: err: %d\n", __func__, err);
+	return err;
+}
+
+/* Flush any coalesced/bundled QUIC packets. */
+void quic_packet_flush(struct sock *sk)
+{
+	struct quic_path_group *paths = quic_paths(sk);
+	struct quic_packet *packet = quic_packet(sk);
+
+	if (packet->head) {
+		quic_lower_xmit(sk, packet->head,
+				quic_path_daddr(paths, packet->path),
+				&paths->fl);
+		packet->head = NULL;
+	}
+}
+
+void quic_packet_init(struct sock *sk)
+{
+	struct quic_packet *packet = quic_packet(sk);
+
+	INIT_LIST_HEAD(&packet->frame_list);
+	packet->mss = QUIC_MIN_UDP_PAYLOAD;
+	packet->taglen = QUIC_TAG_LEN;
+	packet->version = QUIC_VERSION_V1;
+}
diff --git a/net/quic/packet.h b/net/quic/packet.h
new file mode 100644
index 000000000000..a1977fcd0db0
--- /dev/null
+++ b/net/quic/packet.h
@@ -0,0 +1,98 @@
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
+	struct quic_conn_id dcid; /* Dest Conn ID from received packet */
+	struct quic_conn_id scid; /* Source Conn ID from received packet */
+	union quic_addr daddr;    /* Dest address from received packet */
+	union quic_addr saddr;    /* Source address from received packet */
+
+	struct list_head frame_list; /* Frames to pack into packet for send */
+	struct sk_buff *head;        /* Head skb for packet bundling on send */
+	u32 version;   /* QUIC version used/selected during handshake */
+	u16 overhead;  /* QUIC header length excluding frames */
+	u16 padding;   /* Total padding bytes to append after frames */
+	u16 frames;    /* Number of ack-eliciting frames */
+	u16 hlen;      /* UDP + IP header length for sending */
+	u16 len;       /* QUIC packet length including taglen for sending */
+	u16 mss;       /* MSS including taglen */
+
+	u8 path_validating:1; /* Packet contains path_validating frames */
+	u8 ack_eliciting:1;   /* Packet contains ack-eliciting frames */
+	u8 ack_immediate:1;   /* Send ACK immediately (skip ack_delay timer) */
+	u8 non_probing:1;     /* Packet contains non-probing frames */
+	u8 has_sack:1;        /* Packet contains ACK frames */
+	u8 ipfragok:1;        /* Allow IP fragmentation */
+	u8 path:1;            /* Path identifier used to send this packet */
+	u8 last:1;            /* No more frame can be appended */
+	u8 taglen;            /* Tag length for short header packets */
+	u8 level;             /* Encryption level used */
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
+#define QUIC_PACKET_INVALID		0xff
+
+#define QUIC_VERSION_LEN		4
+
+#define QUIC_PACKET_FORM_SHORT		0
+#define QUIC_PACKET_FORM_LONG		1
+
+static inline u8 quic_packet_taglen(struct quic_packet *packet)
+{
+	return packet->level == QUIC_CRYPTO_APP ? packet->taglen : QUIC_TAG_LEN;
+}
+
+static inline u32 quic_packet_mss(struct quic_packet *packet)
+{
+	return packet->mss - quic_packet_taglen(packet);
+}
+
+static inline u32 quic_packet_max_payload(struct quic_packet *packet)
+{
+	return packet->mss - packet->overhead - quic_packet_taglen(packet);
+}
+
+static inline bool quic_packet_empty(struct quic_packet *packet)
+{
+	return list_empty(&packet->frame_list);
+}
+
+static inline void quic_packet_reset(struct quic_packet *packet)
+{
+	packet->level = 0;
+	packet->has_sack = 0;
+	packet->non_probing = 0;
+	packet->ack_eliciting = 0;
+	packet->ack_immediate = 0;
+}
+
+u16 quic_packet_overhead(struct sock *sk, u8 level, u8 path);
+int quic_packet_config(struct sock *sk, u8 level, u8 path);
+
+int quic_packet_create_and_xmit(struct sock *sk, gfp_t gfp);
+int quic_packet_route(struct sock *sk);
+
+void quic_packet_mss_update(struct sock *sk, u32 mss);
+void quic_packet_flush(struct sock *sk);
+void quic_packet_init(struct sock *sk);
diff --git a/net/quic/socket.c b/net/quic/socket.c
index 53a2f76c9bda..f7792236752b 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -86,6 +86,7 @@ static int quic_init_sock(struct sock *sk)
 	quic_cong_init(quic_cong(sk));
 
 	quic_timer_init(sk);
+	quic_packet_init(sk);
 
 	if (quic_stream_init(quic_streams(sk)))
 		return -ENOMEM;
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 7ce29974baf4..173062736020 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -20,6 +20,8 @@
 #include "path.h"
 #include "cong.h"
 
+#include "packet.h"
+
 #include "protocol.h"
 #include "timer.h"
 
@@ -74,6 +76,7 @@ struct quic_sock {
 	struct quic_pnspace		*space[QUIC_PNSPACE_MAX];
 	struct quic_crypto		*crypto[QUIC_CRYPTO_MAX];
 
+	struct quic_packet		packet;
 	struct quic_timer		timers[QUIC_TIMER_MAX];
 };
 
@@ -147,6 +150,11 @@ static inline struct quic_crypto *quic_crypto(const struct sock *sk, u8 level)
 	return quic_sk(sk)->crypto[level];
 }
 
+static inline struct quic_packet *quic_packet(const struct sock *sk)
+{
+	return &quic_sk(sk)->packet;
+}
+
 static inline void *quic_timer(const struct sock *sk, u8 type)
 {
 	return (void *)&quic_sk(sk)->timers[type];
-- 
2.47.1

