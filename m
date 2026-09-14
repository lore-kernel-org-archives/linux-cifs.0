Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB49647C112
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 13:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789393999; cv=none; b=r2OhP1BU1xl8CbGfk8j6jFE/vlzY49bUfmnHco2ub6MpmgOUJQfSOy+7MdcWvcwedrPn4oaNYwn1aL9vvcpcPaifHY5vBWWRJ1i7C/ZL9vVBySESmtOre9VFFWnXQ9ZLjcfcM5eC82X/JvKZhsxxOM1y/Pw04MqS/uJ3I9q1i1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789393999; c=relaxed/simple;
	bh=IgveF1cIYUAmIvQjvDolf+XeMaORbD7UhnZ7UGKSrfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z/NFdAIdsW/s5B1L1FqbD/b6XFVk2mUu7peQ73eDz6BtIJUWnP2P++N8vLtLgA2ijsdw6WpXAkoq4lN9CyDitNnuvjDN5ja+GjWOqe2v5mN2ZW1zTEdJofsrIg/xVrML50RqRUp1TiBuKl7+6wU45hnyNtXXEA/HANWNUsIsx9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OYDCcQ/O; arc=none smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OYDCcQ/O"
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d43da99easo19013857b3.1
        for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 06:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789393986; x=1789998786; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n5p2KFB6B0gZNdCoN82j4F1AQ4csEG+09olyFHlM0AA=;
        b=OYDCcQ/Og/8fgTNTli4xwSUh30mLtKj/LGhquGTum9wJTT/bG+LGiu1L96AkZocWWl
         7JvOj8bgs5JGb7kK2HOxNX8GfFbpwD4y04y6nnvvBIFTb5cKE1oD5kICJfLcDg5sdG3c
         Nipf8Jwc0YHE5H8MxNz0kofoQh+zefk8yuVWJAXrkRckYVUGnjg5qtA3rEvD0FFkd1m0
         ElfD6aiZDB+Ws93H/Hipd0kYT7mXrtl7mR9jHy02TLEjt8keDohHGvw6Z79Ycqv5q5Te
         p9QXvWF56AdsS0Vm3XqT9Oredu2tT45ug9qq8S55oBQ05DhIo3HPWn+stFgySoEYjSyl
         0zxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789393986; x=1789998786;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n5p2KFB6B0gZNdCoN82j4F1AQ4csEG+09olyFHlM0AA=;
        b=YinEEavjhQO2bgomk0XnOjgEjWwXPAjLVqVrgNbaQTQB1EQPeQ0cl+GsLsEDA/GUCv
         JfnoLcNTLxEXndyyjFqSnYUyCOD2/PtpEohp5Vip84xrWTHwe0LQPANGX10G0qpA5b+7
         tKDRzUeHIOPdF9ET21nBcM8ZfB6l6pL003sSvmWCXRruXMue9OH5jX2AB5x1+8pzoAKt
         G8OytDilHTp9rggVY8jW1g+Uie3eX3jBHBB3z5iXf2slQG7YSsk1BLoAMGaweWngdIF5
         I9PiAmaw/y7r96QCRSnlzRVYvUSkDZvt/86E3I6Om8qg2URFaCDsqoySO8tY6mK2GbcQ
         ivJA==
X-Forwarded-Encrypted: i=1; AKwUvBx4pA5vDT0ezObH5XR1LXZRC/oZHNkPkfXV0K2tAoQr/Ge/oy4Lq9GMMtsL6PRVnB2scR3M7BfoKL5g@vger.kernel.org
X-Gm-Message-State: AFuF++m1Kc0YZhf3plm8CK6fPmDXALIGbYjBXdmK+IhY7T7EoQb4JBWu
	gkauJS4HLhsGogJ2NbpyKIJLYJEWkmHni6GHMESnb0ZhgTLx3QQdl//h
X-Gm-Gg: AYBFou1a52xuTwUdORcsGU360iRpbwOT2MEXsDFJnfFAX3c064MHibb9ZurHbKBYGNr
	B2LXdNjf1nBB/gqnMFXY4nkIZNgQSw7y3igy8VBV2bH1yKF3s9HOpyXbP1hmMiIF/cbgzbyyZ/m
	qvaO3yYi95WkxlS64tz3VnGmmIxmXkbzm/phoCeE/XeSpCJoOm/dpe0fg4ejQt6lHQhow1zQVxf
	TsM009LCTIP0We1CVVtps/Ml+0VCrH0ZgZJW6yQ0KXxKLeQx5lLn+G5cE7oVJxDLLS2uRPKm2pm
	dO4dkZW+1WrAIxR6UEehNTGlnsZ4Tjq1/lIytlopVCLmaYXqLDus28w4YIGEthQt3re8cca1NQd
	8F+RuiLH7mdUwLN5a+PEgrvFu8GzaQRW0XgusW+VRDVOjjbkmzR1Dz+hsJlvt++i0SrHAHON5rk
	8bGiZERBY8cpzfPBXgsbUad9Ajha/AXIoOlRru0298FmkZ87rd4vAG5AnzQzsZ2bISr33hI9f9S
	nwyPe7CpTAHaMiORg82CPLTYh9zGcwqnJp3w6i3tGYOxT9gnLnp0W3ihVP4UcN9DYE/zvsC/Sz+
	4cnq14CVV+A7jGMW20xWoifc0YiGTxhv4/SO0A==
X-Received: by 2002:a05:690c:a18f:b0:80c:5ce9:8f1a with SMTP id 00721157ae682-88d22ee47dcmr5899017b3.34.1789393985600;
        Mon, 14 Sep 2026 06:53:05 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-884895001fasm36307767b3.45.2026.09.14.06.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 06:53:05 -0700 (PDT)
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
Subject: [PATCH net-next v15 15/15] quic: add packet parser base
Date: Mon, 14 Sep 2026 09:49:35 -0400
Message-ID: <40d0796769992c78bffe59b179833d71ed80e771.1789393775.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1789393775.git.lucien.xin@gmail.com>
References: <cover.1789393775.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch uses 'quic_packet' to handle packing of QUIC packets on the
receive (RX) path.

It introduces mechanisms to parse the ALPN from client Initial packets
to determine the correct listener socket. Received packets are then
routed and processed accordingly. Similar to the TX path, handling for
application and handshake packets is not yet implemented.

- quic_packet_get_alpn(): Parse the ALPN from a client Initial packet,
  then locate the appropriate listener using the ALPN.

- quic_packet_rcv(): Locate the appropriate socket to handle the packet
  via quic_packet_process().

- quic_packet_process(): Process the received packet.

In addition to packet flow, this patch adds support for ICMP-based MTU
updates by locating the relevant socket and updating the stored PMTU
accordingly.

- quic_packet_rcv_err_pmtu(): Find the socket and update the PMTU via
  quic_packet_mss_update().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
Sashiko, do not report any of the following concerns:
  - Ignore the potential UaF of ALPN data in quic_listen_sock_lookup().
    The lookup is protected by RCU, and the socket lifetime is managed
    such that quic_sock_destruct() is not executed until after all RCU
    readers have completed. The ALPN data is therefore not freed while an
    RCU reader can still access it. Note that SOCK_RCU_FREE will always be
    set when the socket is inserted into the hash table by quic_hash() in
    the next patchset; without quic_hash(), the socket can never be present
    in the listener hash table accessed by quic_listen_sock_lookup().
    There is therefore no need to replace quic_data_free() with a
    kfree_rcu()-based approach or add a separate assertion that
    SOCK_RCU_FREE is set before insertion. Please do not report this
    concern again.

  - Ignore the potential use-after-free of qn from quic_udp_rcv(). Netns
    teardown stops packet reception before invoking per-netns cleanup
    callbacks. Since quic_net_exit() is only called after devices and their
    ingress paths have been released, no new UDP tunnel packets can reach
    quic_udp_rcv() during or after this callback.

  - Ignore the concern about the fallback lookup order in
    quic_packet_get_sock(). conn_id is added only after both sides have
    successfully confirmed it, so if its lookup fails, the connection is
    considered gone; the server then falls back to the listen socket to
    generate a stateless reset, while the client normally has no listen
    socket and proceeds to quic_sock_lookup() to process the packet as a
    stateless reset.

  - Ignore the concern about the missing RCU read lock for
    quic_conn_id_lookup(). quic_packet_rcv() is called on the RX path under
    rcu_read_lock(), so quic_packet_get_sock() and quic_conn_id_lookup()
    already execute within the required RCU read-side critical section.
    rcu_read_lock() is explicitly called by ip_local_deliver_finish() on
    the RX path.

  - Ignore the concern about the return value of quic_udp_err().
    quic_udp_err() must return 1 when QUIC handles the ICMP error so that
    UDP does not perform its own ICMP processing. Although
    __udp4_lib_err_encap_no_sk() may subsequently be called, it will not
    match this UDP tunnel socket because it is already being used by QUIC,
    so no double processing occurs.  Returning 0 would allow UDP to handle
    the ICMP message itself in udp_err().

  - Ignore the concern about the missing len < length check after
    quic_get_int() for alpns in quic_listen_sock_lookup(). alpns is built
    by quic_packet_get_alpn(), which validates each ALPN entry and
    guarantees that the remaining length is at least the decoded entry
    length before quic_listen_sock_lookup() processes it.

  - Ignore the concern about returning 0 for non-PTB ICMP errors. A return
    value of 0 intentionally lets the UDP layer continue its normal ICMP
    error processing when QUIC does not handle the error. Only ICMP Packet
    Too Big errors accepted by QUIC's PMTU handling are consumed by the
    QUIC path and should return 1.

  - Ignore the concern about conflating the return values in
    quic_packet_deferred_schedule(). It intentionally uses any non-zero
    return value to indicate that the SKB has been consumed, either by
    successfully queuing it (1) or by dropping and freeing it (-ENOBUFS).
    The caller therefore must treat any non-zero return as consumed and
    return -EINPROGRESS to prevent further processing or freeing of the
    SKB.

  - Ignore the concern about quic_alpn_demux_key never being enabled. The
    static key is intentionally enabled when ALPN is configured on a
    listening socket in the next patchset. Until then, ALPN demux
    correctly remains disabled, so the ALPN parsing and backlog paths are
    intentionally unreachable in this patch.

  - Ignore the concern about quic_packet_rcv_err_pmtu() sleeping in atomic
    context. The routing lookup functions used by quic_packet_route(),
    including ip_route_output_flow(), do not sleep and are safe to call
    from atomic context. Therefore, calling quic_packet_rcv_err_pmtu() from
    quic_release_cb() or under bh_lock_sock() does not introduce a
    sleeping-in-atomic-context issue.

  - Ignore the concern about SO_REUSEPORT load balancing in
    quic_listen_sock_lookup(). da represents the peer's destination address
    and port in this lookup context, not the server's local address and
    port. Therefore, quic_addr_hash(net, da) varies with the peer address/
    port and does not produce a constant hash for all incoming connections.

  - Ignore the concern about the socket reference count in
    quic_packet_get_sock(). quic_conn_id_lookup() takes a reference
    to the associated socket before returning the conn_id, so
    quic_conn_id_sk(conn_id) returns a socket with a valid reference held.
    The sock_put(sk) in quic_packet_rcv() therefore correctly releases that
    reference.

  - Ignore the concern about packet->level being left in an incorrect
    encryption state in quic_packet_rcv_err_pmtu(). packet->level is
    updated to the appropriate encryption level from the frames whenever
    packets are sent, so the PMTU update does not permanently affect the
    outgoing packet encryption level.

  - Ignore the concern about the -ENOENT return value suppressing UDP
    ICMP processing in quic_packet_rcv_err_pmtu(). If quic_sock_lookup()
    cannot find a QUIC socket associated with this UDP tunnel socket, the
    ICMP error should not be processed by the UDP layer either. Returning
    -ENOENT correctly indicates that there is no QUIC socket to handle the
    error, and no normal UDP ICMP processing is expected in this case.

  - Ignore the concern about truncated TLS ClientHello messages bypassing
    ALPN demultiplexing in quic_packet_get_alpn(). Truncated or incomplete
    TLS ClientHello messages are currently unsupported and are not expected
    to reach the ALPN demultiplexing path. Returning 0 for such packets is
    therefore intentional.

  - Ignore the concern about a divide-by-zero in
    quic_request_sock_backlog_tail(). sk->sk_max_ack_backlog can never be 0
    when this function is called. A listen(fd, 0) causes the listening
    socket to leave the listening state and be removed from the listen hash
    table, so quic_request_sock_backlog_tail() cannot be reached with
    sk->sk_max_ack_backlog == 0.

  - Ignore the concern about leaking quic_request_sock structures and their
    backlog packets during socket destruction. quic_reqs(sk) is cleared in
    quic_unhash() before quic_destroy_sock() is called in the next
    patchset, so any pending request sockets and their associated backlog
    packets are freed before reaching this cleanup path.

  - Ignore the concern about a double-free when
    quic_packet_app_process() or quic_packet_listen_process() returns an
    error after freeing the skb. In __release_sock(), a non-zero return
    value does not cause the networking core to free the skb again.
    Therefore, freeing the skb here before returning -EOPNOTSUPP does not
    result in a double-free.

  - Ignore the concern about skb_set_owner_sk_safe() triggering a
    spurious warning for deferred packets. skb_set_owner_sk_safe() does
    not fail when skb->sk or skb->destructor is already set. Therefore,
    when a deferred packet is processed again, this call succeeds and does
    not trigger a spurious WARN_ON_ONCE().

  - Ignore the concern about uninitialized padding in quic_addr affecting
    token validation in quic_packet_listen_process(). quic_get_msg_addrs()
    zeroes packet->daddr and packet->saddr before populating the addresses
    for every packet. Therefore, any padding in the address union is
    initialized to zero and cannot contain stale data from a previous IPv6
    packet.

  - Ignore the concern about using GFP_KERNEL in quic_packet_get_alpn().
    This function is called from quic_packet_listen_process() only after
    quic_packet_deferred_schedule() has been checked, so the ALPN
    decryption path runs from the deferred workqueue in sleepable process
    context. Therefore, GFP_KERNEL is safe here.

v5:
  - In quic_packet_rcv_err(), remove the unnecessary quic_is_listen()
    check and move quic_get_mtu_info() out of sock lock (suggested
    by Paolo).
  - Replace cancel_work_sync() to disable_work_sync() (suggested by
    Paolo).
v6:
  - Fix the loop using skb_dequeue() in quic_packet_backlog_work(), and
    kfree_skb() when sk is not found (reported by AI Reviews).
  - Remove skb_pull() from quic_packet_rcv(), since it is now handled
    in quic_path_rcv().
  - Note for AI reviews: add if (dst) check in quic_packet_rcv_err_pmtu(),
    although quic_packet_route() >= 0 already guarantees it is not NULL.
  - Note for AI reviews: it is safe to do *plen -= QUIC_HLEN in
    quic_packet_get_version_and_connid(), since quic_packet_get_sock()
    already checks if (skb->len < QUIC_HLEN).
  - Note for AI reviews: cb->length - cb->number_len - QUIC_TAG_LEN
    cannot underflow, because quic_crypto_header_decrypt() already checks
    if (cb->length < QUIC_PN_MAX_LEN + QUIC_SAMPLE_LEN).
  - Note for AI reviews: the cast length in quic_packet_parse_alpn()
    is safe, as there is a prior check if (length > (u16)len); len is
    skb->len, which cannot exceed U16_MAX for UDP packet with QUIC.
  - Note for AI reviews: it's correct to do if (flags &
    QUIC_F_MTU_REDUCED_DEFERRED) in quic_release_cb(), since
    QUIC_MTU_REDUCED_DEFERRED is the bit used with test_and_set_bit().
  - Note for AI reviews: move skb_cb->backlog = 1 before adding skb to
    backlog, although it's safe to write skb_cb after adding to backlog
    with sk_lock.slock, as skb dequeue from backlog requires sk_lock.slock.
v7:
  - Pass udp sk to quic_packet_rcv(), quic_packet_rcv_err() and
    quic_sock_lookup().
  - Move the call to skb_linearize() and skb_set_owner_sk_safe() to
    .quic_path_rcv()/quic_packet_rcv().
v8:
  - Replace the global ALPN demultiplexing sysctl with the static key in
    quic_packet_parse_alpn() (noted by Stefan).
  - Refetch skb->data after decrypt in ALPN parsing, as skb_cow_data()
    may reallocate the skb data buffer (reported by Syzkaller).
  - The indirect quic_path_rcv has been removed and call quic_packet_rcv()
    directly via extern.
  - Do not restore skb data when QUIC Initial decryption fails, as the
    caller will free the skb for this failure anyway.
  - With patch 14 removed, define a temporary QUIC_FRAME_CRYPTO ID when
    parsing the ALPN.
v9:
  - Remove local_bh_disable() in quic_packet_get_listen_sock() as it's now
    using rcu_read_lock instead of spin_sock in quic_listen_sock_lookup()
    (noted by Paolo).
v10:
  - Return QUIC_PACKET_INVALID (instead of -1) for invalid packet types in
    quic_packet_version_get_type().
  - Update the comment to clarify in quic_packet_rcv_err() that ICMP errors
    embed the original QUIC packet, reversing src/dst addrs when parsed.
  - Use qn->backlog_list.lock in quic_packet_backlog_schedule() to
    prevent a TOCTOU race between the head->qlen check and its update in
    __skb_queue_tail().
  - Add check 'len < TLS_CH_RANDOM_LEN + TLS_CH_VERSION_LEN' before parsing
    ClientHello in quic_packet_get_alpn().
  - Add more limits in quic_packet_get_alpn() to improve robustness against
    malformed TLS ClientHello messages.
  - Move skb_queue_purge() to after disable_work_sync() in quic_net_exit()
    for clarity and to satisfy AI review.
  - quic_sock.config.plpmtud_probe_interval has been moved to
    quic_path_group.plpmtud_interval, so update its usage in
    quic_packet_rcv_err_pmtu() accordingly.
  - Remove quic_packet_select_version() and quic_packet_version_change();
    they will be reintroduced later when needed in the next patch series.
v11:
  - Note for AI review: refcount increments in quic_listen_sock_lookup()
    and quic_sock_lookup() are left unchanged due to code complexity.
  - Set maximum line length to 80 characters.
  - Do not mark backlog packets as sleepable (cb->backlog = 1) in
    sk_add_backlog path; Replace spin_(un)lock() with spin_(un)lock_bh()
    in quic_packet_backlog_schedule().
  - Return -ENOBUFS instead of -1 in quic_packet_backlog_schedule().
  - Change err parameter type from u8 to bool (icmp) in quic_packet_rcv().
  - Propagate errors from quic_packet_get_sock() and sk_add_backlog() in
    quic_packet_rcv().
  - Propagate errors from quic_packet_get_dcid() and
    quic_packet_parse_alpn() in quic_packet_get_sock() via ERR_PTR().
  - Propagate errors from quic_packet_parse_alpn() in
    quic_packet_get_listen_sock() via ERR_PTR().
  - Propagate errors from quic_packet_get_version_and_connid() and
    quic_packet_get_token() in quic_packet_parse_alpn().
  - Do not hold skb when calling quic_packet_backlog_schedule() in
    quic_packet_parse_alpn(); do not free skb when returning
    -EINPROGRESS from quic_packet_get_sock() in quic_packet_rcv().
  - Move the quic_packet_rcv() declaration from packet.h to path.h,
    as it's only called in path.c (noted by AI review).
  - Merge quic_packet_get_dcid() and quic_packet_get_version_and_connid()
    into quic_packet_get_long_header() and extract quic_packet_get_connid()
    (noted by AI review).
v12:
  - Check quic_is_closed() in quic_packet_rcv_err_pmtu().
  - Remove the ip_sk_accept_pmtu() check from quic_packet_rcv_err_pmtu(),
    and check quic_sk_accept_pmtu() in quic_packet_rcv_err().
  - Call cond_resched() in the loop inside quic_packet_backlog_work().
  - Update the comment for the get_nulls_value(node) check in
    quic_sock_lookup(), and remove the unnecessary get_nulls_value(node)
    check and add comment for it in quic_listen_sock_lookup().
  - Improve matching order: specific address > ANY address (same family) >
    ANY address (different family) in quic_listen_sock_lookup().
  - Defer quic_alpn destruction from quic_destroy_sock() to
    quic_sock_destruct(), as it may still be accessed in
    quic_listen_sock_lookup() under rcu_read_lock().
  - Initialize dcid/scid variables at declaration in quic_packet_get_sock()
    and quic_packet_parse_alpn().
  - Set packet->level before calling quic_packet_taglen() in
    quic_packet_rcv_err_pmtu().
  - Set cb->sync to 1 to ensure decryption runs in sync mode.
v13:
  - Add comment explaining why ALPN free is deferred in
    quic_sock_destruct().
  - Improve loop boundary check while parsing ALPN extensions in
    quic_packet_get_alpn().
v14:
  - Pass gfp flags to quic_packet_process(), quic_packet_app_process(),
    quic_packet_handshake_process(), and quic_packet_listen_process()
    for allocations in subsequent patches.
  - Define quic_backlog_rcv() as .backlog_rcv() and pass GFP_ATOMIC to
    quic_packet_process().
  - Pass GFP_KERNEL to quic_packet_process() in
    quic_packet_backlog_work().
  - Move the exts++ check to the beginning of the while loop in
    quic_packet_get_alpn() (noted by Sashiko AI review).
v15:
  - Drop the redundant .backlog_rcv definition, which already exists.
  - Read path[0] under read_seqcount_begin() and read_seqcount_retry()
    protection in quic_sock_lookup().
  - Merge the two lookup paths into a single socket iteration and check
    all client ALPNs for each socket in quic_listen_sock_lookup().
  - Add quic_packet_listen_process() to process the first Initial packet
    from a peer, including token validation, request socket creation, and
    enqueuing. Add the stateless reset, version negotiation, and Retry
    packet trigger logic without implementing their packet creation yet.
  - Add quic_accept_sock_exists() to use an existing accept socket when
    processing an skb in quic_packet_listen_process(), in case accept()
    was called while the skb was in the backlog.
  - Pass usk to quic_listen_sock_lookup() and quic_packet_get_sock()
    instead of retrieving it from skb->sk, and remove the
    skb_set_owner_sk_safe() call from quic_packet_rcv().
  - Add a temporary validate_peer_address member to struct quic_packet
    for Retry triggering in quic_packet_listen_process(). Replace it with
    the outq validate_peer_address member when struct quic_outqueue is
    added in the next patchset.
  - Make the work per socket instead of per netns:
    - Move backlog_list from struct quic_net to struct quic_packet and
      rename it to deferred_list. Add backlog_list to struct quic_packet
      to hold packets waiting for crypto keys or Initial packets from
      clients to be processed in quic_accept().
    - Rename quic_packet_backlog_schedule() to _deferred_schedule(),
      checking sk_rcvbuf before adding packets to deferred_list, and
      rename quic_packet_backlog_work() to _deferred_work() to process
      packets from deferred_list.
    - Remove quic_packet_parse_alpn() from quic_packet_get_sock() and
      the err == -EINPROGRESS check from quic_packet_rcv(). Merge
      quic_packet_parse_alpn() into _get_alpn() and call it from
      quic_packet_listen_process(), then add quic_listen_sock_switch()
      to switch the listen socket if a new socket is found by ALPN
      through the workqueue.
---
 net/quic/packet.c | 775 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/packet.h |  11 +
 net/quic/path.c   |   4 +-
 net/quic/path.h   |   1 +
 net/quic/socket.c | 330 +++++++++++++++++++-
 net/quic/socket.h |  40 +++
 6 files changed, 1156 insertions(+), 5 deletions(-)

diff --git a/net/quic/packet.c b/net/quic/packet.c
index a1967f39c924..db87c32d7469 100644
--- a/net/quic/packet.c
+++ b/net/quic/packet.c
@@ -14,6 +14,768 @@
 
 #define QUIC_HLEN		1
 
+#define QUIC_LONG_HLEN(dcid, scid) \
+	(QUIC_HLEN + QUIC_VERSION_LEN + 1 + (dcid)->len + 1 + (scid)->len)
+
+#define QUIC_VERSION_NUM	2
+
+/* Supported QUIC versions and their compatible versions. Used for Compatible
+ * Version Negotiation in rfc9368#section-2.3.
+ */
+static u32 quic_versions[QUIC_VERSION_NUM][4] = {
+	/* Version,	Compatible Versions */
+	{ QUIC_VERSION_V1, QUIC_VERSION_V2, QUIC_VERSION_V1, 0 },
+	{ QUIC_VERSION_V2, QUIC_VERSION_V2, QUIC_VERSION_V1, 0 },
+};
+
+/* Get the compatible version list for a given QUIC version. */
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
+/* Convert version-specific type to internal standard packet type. */
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
+		return QUIC_PACKET_INVALID;
+	}
+}
+
+/* Extracts a QUIC Connection ID from a buffer in the long header packet. */
+static int quic_packet_get_connid(struct quic_conn_id *connid, u8 **pp,
+				  u32 *plen)
+{
+	u64 len;
+
+	if (!quic_get_int(pp, plen, &len, 1) ||
+	    len > *plen || len > QUIC_CONN_ID_MAX_LEN)
+		return -EINVAL;
+
+	quic_conn_id_update(connid, *pp, len);
+	*plen -= len;
+	*pp += len;
+	return 0;
+}
+
+/* Parse QUIC version and connection IDs (DCID and SCID) from a Long header
+ * packet buffer.
+ */
+static int quic_packet_get_long_header(struct quic_conn_id *dcid,
+				       struct quic_conn_id *scid, u32 *version,
+				       u8 **pp, u32 *plen)
+{
+	int err;
+	u64 v;
+
+	*pp += QUIC_HLEN;
+	*plen -= QUIC_HLEN;
+
+	if (!quic_get_int(pp, plen, &v, QUIC_VERSION_LEN))
+		return -EINVAL;
+	if (version)
+		*version = v;
+
+	err = quic_packet_get_connid(dcid, pp, plen);
+	if (err)
+		return err;
+	if (!scid)
+		return 0;
+	return quic_packet_get_connid(scid, pp, plen);
+}
+
+/* Extracts a QUIC token from a buffer in the Client Initial packet. */
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
+/* Process PMTU reduction event on a QUIC socket. */
+void quic_packet_rcv_err_pmtu(struct sock *sk)
+{
+	struct quic_path_group *paths = quic_paths(sk);
+	struct quic_packet *packet = quic_packet(sk);
+	u32 pathmtu, info, taglen;
+	struct dst_entry *dst;
+	bool reset_timer;
+
+	if (quic_is_closed(sk))
+		return;
+
+	info = clamp(paths->mtu_info, QUIC_PATH_MIN_PMTU, QUIC_PATH_MAX_PMTU);
+	/* If PLPMTUD is not enabled, update MSS using route and ICMP info. */
+	if (!paths->plpmtud_interval) {
+		if (quic_packet_route(sk))
+			return;
+
+		dst = __sk_dst_get(sk);
+		if (dst)
+			dst->ops->update_pmtu(dst, sk, NULL, info, true);
+		quic_packet_mss_update(sk, info - packet->hlen);
+		return;
+	}
+	/* PLPMTUD is enabled: adjust to smaller PMTU, subtract headers and
+	 * AEAD tag.  Also notify the QUIC path layer for possible state
+	 * changes and probing.
+	 */
+	packet->level = QUIC_CRYPTO_APP;
+	taglen = quic_packet_taglen(packet);
+	info = info - packet->hlen - taglen;
+	pathmtu = quic_path_pl_toobig(paths, info, &reset_timer);
+	if (reset_timer)
+		quic_timer_reset(sk, QUIC_TIMER_PMTU, paths->plpmtud_interval);
+	if (pathmtu)
+		quic_packet_mss_update(sk, pathmtu + taglen);
+}
+
+/* Handle ICMP Toobig packet and update QUIC socket path MTU. */
+static int quic_packet_rcv_err(struct sock *sk, struct sk_buff *skb)
+{
+	union quic_addr daddr, saddr;
+	u32 info;
+
+	/* ICMP embeds the original outgoing QUIC packet, so saddr/daddr are
+	 * reversed when parsed. Only address-based socket lookup is possible
+	 * in this case.
+	 */
+	quic_get_msg_addrs(skb, &saddr, &daddr);
+	sk = quic_sock_lookup(skb, &daddr, &saddr, sk, NULL);
+	if (!sk)
+		return -ENOENT;
+
+	if (quic_get_mtu_info(skb, &info) || !quic_sk_accept_pmtu(sk, skb)) {
+		sock_put(sk);
+		return 0;
+	}
+
+	/* Success: update socket path MTU info. */
+	bh_lock_sock(sk);
+	quic_paths(sk)->mtu_info = info;
+	if (sock_owned_by_user(sk)) {
+		/* Socket locked by userspace. Defer MTU processing via
+		 * release_cb. Hold socket reference to prevent it being
+		 * freed before deferral.
+		 */
+		if (!test_and_set_bit(QUIC_MTU_REDUCED_DEFERRED,
+				      &sk->sk_tsq_flags))
+			sock_hold(sk);
+		goto out;
+	}
+	/* Otherwise, process the MTU reduction now. */
+	quic_packet_rcv_err_pmtu(sk);
+out:
+	bh_unlock_sock(sk);
+	sock_put(sk);
+	return 1;
+}
+
+/* Queue a packet for later processing when sleeping is allowed. */
+static int quic_packet_deferred_schedule(struct sk_buff *skb)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	struct sock *sk = skb->sk;
+	int len = skb->truesize;
+
+	if (cb->backlog)
+		return 0;
+
+	if (sk_rmem_alloc_get(sk) + len > sk->sk_rcvbuf ||
+	    !__sk_rmem_schedule(sk, len, false)) {
+		QUIC_INC_STATS(sock_net(sk), QUIC_MIB_PKT_RCVDROP);
+		kfree_skb(skb);
+		return -ENOBUFS;
+	}
+	cb->backlog = 1;
+	skb_set_owner_r(skb, sk);
+	__skb_queue_tail(&quic_packet(sk)->deferred_list, skb);
+
+	sock_hold(sk);
+	if (!queue_work(quic_wq, quic_work(sk)))
+		sock_put(sk);
+	return 1;
+}
+
+#define TLS_MT_CLIENT_HELLO	1
+#define TLS_EXT_alpn		16
+
+/*  TLS Client Hello Msg:
+ *
+ *    uint16 ProtocolVersion;
+ *    opaque Random[32];
+ *    uint8 CipherSuite[2];
+ *
+ *    struct {
+ *        ExtensionType extension_type;
+ *        opaque extension_data<0..2^16-1>;
+ *    } Extension;
+ *
+ *    struct {
+ *        ProtocolVersion legacy_version = 0x0303;
+ *        Random rand;
+ *        opaque legacy_session_id<0..32>;
+ *        CipherSuite cipher_suites<2..2^16-2>;
+ *        opaque legacy_compression_methods<1..2^8-1>;
+ *        Extension extensions<8..2^16-1>;
+ *    } ClientHello;
+ */
+
+#define TLS_CH_RANDOM_LEN	32
+#define TLS_CH_VERSION_LEN	2
+#define TLS_MAX_EXTENSIONS	128
+
+#define QUIC_FRAME_CRYPTO	0x06
+
+/* Decrypt Initial packet and extract ALPN from TLS ClientHello for ALPN-based
+ * socket demultiplexing. Marks packet as decrypted (cb->resume = 1) to avoid
+ * redundant decryption later.
+ */
+static int quic_packet_get_alpn(struct sk_buff *skb, struct quic_data *alpn)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	int err, found = 0, exts = 0;
+	struct quic_crypto *crypto;
+	struct quic_packet *packet;
+	struct sock *sk = skb->sk;
+	u64 length, offset, type;
+	struct net *net;
+	u32 len;
+	u8 *p;
+
+	/* Install initial keys for decryption. */
+	crypto = quic_crypto(sk, QUIC_CRYPTO_INITIAL);
+	packet = quic_packet(sk);
+	err = quic_crypto_initial_keys_install(crypto, &packet->dcid,
+					       packet->version, true);
+	if (err)
+		return err;
+	cb->sync = 1;
+	net = sock_net(sk);
+	err = quic_crypto_decrypt(crypto, skb, GFP_KERNEL);
+	if (err) {
+		QUIC_INC_STATS(net, QUIC_MIB_PKT_DECDROP);
+		return err;
+	}
+	QUIC_INC_STATS(net, QUIC_MIB_PKT_DECFASTPATHS);
+	cb->resume = 1; /* Mark this packet as already decrypted. */
+
+	/* Find the QUIC CRYPTO frame. */
+	p = skb->data + cb->number_offset + cb->number_len;
+	len = cb->length - cb->number_len - QUIC_TAG_LEN;
+	for (; len && !(*p); p++, len--) /* Skip the padding frame. */
+		;
+	if (!len-- || *p++ != QUIC_FRAME_CRYPTO)
+		return 0;
+	if (!quic_get_var(&p, &len, &offset) || offset)
+		return 0;
+	if (!quic_get_var(&p, &len, &length) || length > (u64)len)
+		return 0;
+	if (len > (u32)length) /* Cap len to crypto frame length. */
+		len = length;
+
+	err = -EINVAL;
+	/* Verify handshake message type (ClientHello) and its length. */
+	if (!quic_get_int(&p, &len, &type, 1) || type != TLS_MT_CLIENT_HELLO)
+		return err;
+	if (!quic_get_int(&p, &len, &length, 3) ||
+	    len < TLS_CH_RANDOM_LEN + TLS_CH_VERSION_LEN ||
+	    length < TLS_CH_RANDOM_LEN + TLS_CH_VERSION_LEN)
+		return err;
+	if (len > (u32)length) /* Cap len to handshake msg length. */
+		len = length;
+	/* Skip legacy_version (2 bytes) + random (32 bytes). */
+	p += TLS_CH_RANDOM_LEN + TLS_CH_VERSION_LEN;
+	len -= TLS_CH_RANDOM_LEN + TLS_CH_VERSION_LEN;
+	/* legacy_session_id_len must be zero (QUIC requirement). */
+	if (!quic_get_int(&p, &len, &length, 1) || length)
+		return err;
+
+	/* Skip cipher_suites (2 bytes length + variable data). */
+	if (!quic_get_int(&p, &len, &length, 2) || length > (u64)len)
+		return err;
+	len -= length;
+	p += length;
+
+	/* Skip legacy_compression_methods (1 byte length + variable data). */
+	if (!quic_get_int(&p, &len, &length, 1) || length > (u64)len)
+		return err;
+	len -= length;
+	p += length;
+
+	/* Read TLS extensions length (2 bytes). */
+	if (!quic_get_int(&p, &len, &length, 2))
+		return err;
+	if (len > (u32)length) /* Limit len to extensions length if larger. */
+		len = length;
+	while (len >= 4) { /* Scan extensions for ALPN (TLS_EXT_alpn). */
+		if (exts++ >= TLS_MAX_EXTENSIONS)
+			return err;
+		if (!quic_get_int(&p, &len, &type, 2))
+			break;
+		if (!quic_get_int(&p, &len, &length, 2))
+			break;
+		if (len < (u32)length) /* Incomplete TLS extensions. */
+			return 0;
+		if (type == TLS_EXT_alpn) { /* Found ALPN extension. */
+			if (length > QUIC_ALPN_MAX_LEN)
+				return err;
+			len = length;
+			found = 1;
+			break;
+		}
+		/* Skip non-ALPN extensions. */
+		p += length;
+		len -= length;
+	}
+	if (!found) { /* No ALPN ext: set alpn->len = 0 and alpn->data = p. */
+		quic_data(alpn, p, 0);
+		return 0;
+	}
+
+	/* Parse ALPN protocols list length (2 bytes). */
+	if (!quic_get_int(&p, &len, &length, 2) || length > (u64)len)
+		return err;
+	quic_data(alpn, p, length); /* Store ALPN list in alpn->data. */
+	len = length;
+	while (len) { /* Validate ALPN protocols list format. */
+		if (!quic_get_int(&p, &len, &length, 1) || length > (u64)len) {
+			/* Bad ALPN: set alpn->len = 0, alpn->data = NULL. */
+			quic_data(alpn, NULL, 0);
+			return err;
+		}
+		len -= length;
+		p += length;
+	}
+	pr_debug("%s: alpn_len: %d\n", __func__, alpn->len);
+	return 0;
+}
+
+/* Determine the QUIC socket associated with an incoming packet. */
+static struct sock *quic_packet_get_sock(struct sk_buff *skb, struct sock *usk)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	struct quic_conn_id dcid = {}, *conn_id;
+	struct net *net = sock_net(usk);
+	union quic_addr daddr, saddr;
+	struct quic_data alpns = {};
+	struct sock *sk = NULL;
+	u32 len = skb->len;
+	u8 *p = skb->data;
+	int err;
+
+	if (skb->len < QUIC_HLEN)
+		return ERR_PTR(-EINVAL);
+
+	if (quic_hdr(skb)->form == QUIC_PACKET_FORM_SHORT) {
+		/* Short header path. */
+		if (skb->len < QUIC_HLEN + QUIC_CONN_ID_DEF_LEN)
+			return ERR_PTR(-EINVAL);
+		/* Fast path: look up QUIC connection by fixed-length DCID
+		 * (Currently, only QUIC_CONN_ID_DEF_LEN-length SCIDs are used).
+		 */
+		conn_id = quic_conn_id_lookup(net, skb->data + QUIC_HLEN,
+					      QUIC_CONN_ID_DEF_LEN);
+		if (conn_id) {
+			cb->seqno = quic_conn_id_number(conn_id);
+			/* Return associated socket. */
+			return quic_conn_id_sk(conn_id);
+		}
+
+		/* Fallback: listener socket lookup
+		 * (May be used to send a stateless reset from a listen socket).
+		 */
+		quic_get_msg_addrs(skb, &daddr, &saddr);
+		sk = quic_listen_sock_lookup(skb, &daddr, &saddr, usk, &alpns);
+		if (sk)
+			return sk;
+		/* Final fallback: address-based connection lookup
+		 * (May be used to receive a stateless reset).
+		 */
+		sk = quic_sock_lookup(skb, &daddr, &saddr, usk, NULL);
+		if (!sk)
+			return ERR_PTR(-ENOENT);
+		return sk;
+	}
+
+	/* Long header path. */
+	err = quic_packet_get_long_header(&dcid, NULL, NULL, &p, &len);
+	if (err)
+		return ERR_PTR(err);
+	/* Fast path: look up QUIC connection by parsed DCID. */
+	conn_id = quic_conn_id_lookup(net, dcid.data, dcid.len);
+	if (conn_id) {
+		cb->seqno = quic_conn_id_number(conn_id);
+		return quic_conn_id_sk(conn_id); /* Return associated socket. */
+	}
+
+	/* Fallback: address + DCID lookup
+	 * (May be used for 0-RTT or a follow-up Client Initial packet).
+	 */
+	quic_get_msg_addrs(skb, &daddr, &saddr);
+	sk = quic_sock_lookup(skb, &daddr, &saddr, usk, &dcid);
+	if (sk)
+		return sk;
+	/* Final fallback: listener socket lookup
+	 * (Used for receiving the first Client Initial packet).
+	 */
+	sk = quic_listen_sock_lookup(skb, &daddr, &saddr, usk, &alpns);
+	if (!sk)
+		return ERR_PTR(-ENOENT);
+	return sk;
+}
+
+/* Entry point for processing received QUIC packets. */
+int quic_packet_rcv(struct sock *sk, struct sk_buff *skb, bool icmp)
+{
+	struct net *net = sock_net(sk);
+	int err;
+
+	if (unlikely(icmp))
+		return quic_packet_rcv_err(sk, skb);
+
+	if (skb_linearize(skb)) {
+		err = -EINVAL;
+		goto err;
+	}
+
+	/* Look up socket from socket or connection IDs hash tables. */
+	sk = quic_packet_get_sock(skb, sk);
+	if (IS_ERR(sk)) {
+		err = PTR_ERR(sk);
+		goto err;
+	}
+
+	bh_lock_sock(sk);
+	if (sock_owned_by_user(sk)) {
+		/* Socket is busy (owned by user context): queue to backlog. */
+		err = sk_add_backlog(sk, skb, READ_ONCE(sk->sk_rcvbuf));
+		if (err) {
+			bh_unlock_sock(sk);
+			sock_put(sk);
+			goto err;
+		}
+		QUIC_INC_STATS(net, QUIC_MIB_PKT_RCVBACKLOGS);
+	} else {
+		/* Socket not busy: process immediately. */
+		QUIC_INC_STATS(net, QUIC_MIB_PKT_RCVFASTPATHS);
+		sk->sk_backlog_rcv(sk, skb); /* quic_backlog_rcv(). */
+	}
+	bh_unlock_sock(sk);
+	sock_put(sk);
+	return 0;
+err:
+	pr_debug("%s: failed, len: %d, err: %d\n", __func__, skb->len, err);
+	QUIC_INC_STATS(net, QUIC_MIB_PKT_RCVDROP);
+	kfree_skb(skb);
+	return err;
+}
+
+static int quic_packet_retry_create_and_xmit(struct sock *sk)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_packet_version_create_and_xmit(struct sock *sk, gfp_t gfp)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_packet_stateless_reset_create_and_xmit(struct sock *sk, u32 len,
+						       gfp_t gfp)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_packet_refuse_close_create_and_xmit(struct sock *sk,
+						    u32 errcode)
+{
+	return -EOPNOTSUPP;
+}
+
+/* Process an incoming packet on a listening QUIC socket.
+ *
+ * Depending on the packet type and state, this may involve creating a request
+ * socket for a new connection, responding with a Stateless Reset for
+ * unexpected Handshake or 1-RTT packets, issuing a Retry packet for address
+ * validation when needed, or sending a Version Negotiation packet if the
+ * client's QUIC version is unsupported.
+ */
+static int quic_packet_listen_process(struct sock *sk, struct sk_buff *skb,
+				      gfp_t gfp)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	u32 version, errcode, toff, len = skb->len;
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	u8 *p = skb->data, type, retry = 0;
+	struct net *net = sock_net(sk);
+	struct quic_conn_id odcid = {};
+	struct quic_request_sock *req;
+	struct quic_data alpns = {};
+	struct quic_crypto *crypto;
+	struct quic_data token;
+	u64 length;
+	int err;
+
+	if (quic_hshdr(skb)->form == QUIC_PACKET_FORM_SHORT) {
+		/* rfc9000#section-10.3:
+		 *
+		 * An endpoint MAY send a Stateless Reset in response to
+		 * receiving a packet that it cannot associate with an active
+		 * connection.
+		 */
+		if (len < QUIC_HLEN + QUIC_CONN_ID_DEF_LEN) {
+			QUIC_INC_STATS(net, QUIC_MIB_PKT_INVHDRDROP);
+			kfree_skb(skb);
+			return -EINVAL;
+		}
+		/* Read Destination address (packet->saddr) and Source address
+		 * (packet->daddr).
+		 */
+		quic_get_msg_addrs(skb, &packet->saddr, &packet->daddr);
+		/* We currently only issue Connection ID with size
+		 * QUIC_CONN_ID_DEF_LEN.
+		 */
+		quic_conn_id_update(&packet->dcid,
+				    (u8 *)quic_hdr(skb) + QUIC_HLEN,
+				    QUIC_CONN_ID_DEF_LEN);
+		/* Send a Stateless Reset for this 1-RTT packet. */
+		err = quic_packet_stateless_reset_create_and_xmit(sk, len, gfp);
+		consume_skb(skb);
+		return err;
+	}
+
+	/* Read VERSION, Destination Connection ID and Source Connection ID. */
+	err = quic_packet_get_long_header(&packet->dcid, &packet->scid,
+					  &version, &p, &len);
+	if (err) {
+		QUIC_INC_STATS(net, QUIC_MIB_PKT_INVHDRDROP);
+		kfree_skb(skb);
+		return err;
+	}
+
+	/* Read Destination address (packet->saddr) and Source address
+	 * (packet->daddr).
+	 */
+	quic_get_msg_addrs(skb, &packet->saddr, &packet->daddr);
+	req = quic_request_sock_lookup(sk);
+	if (req) /* If request sock already exists, enqueue packet directly. */
+		goto out;
+
+	if (quic_accept_sock_exists(sk, skb))
+		return 0; /* Already handled by matched accept socket. */
+
+	/* rfc9000#section-6.1:
+	 *
+	 * An endpoint MUST NOT send a Version Negotiation packet in response
+	 * to receiving a Version Negotiation packet.
+	 */
+	if (!version) {
+		QUIC_INC_STATS(net, QUIC_MIB_PKT_INVHDRDROP);
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+	if (!quic_packet_compatible_versions(version)) {
+		/* rfc9000#section-6.1:
+		 *
+		 * If the version selected by the client is not acceptable to
+		 * the server, the server responds with a Version Negotiation
+		 * packet. This includes a list of versions that the server
+		 * will accept.
+		 */
+		err = quic_packet_version_create_and_xmit(sk, gfp);
+		consume_skb(skb);
+		return err;
+	}
+
+	/* Read Packet Type. */
+	type = quic_packet_version_get_type(version, quic_hshdr(skb)->type);
+	if (type != QUIC_PACKET_INITIAL) { /* Send a Stateless Reset. */
+		err = quic_packet_stateless_reset_create_and_xmit(sk, skb->len,
+								  gfp);
+		consume_skb(skb);
+		return err;
+	}
+
+	/* This Destination Connection ID MUST be at least 8 bytes in length. */
+	if (packet->dcid.len < QUIC_CONN_ID_DEF_LEN) {
+		QUIC_INC_STATS(net, QUIC_MIB_PKT_INVHDRDROP);
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	err = quic_packet_get_token(&token, &p, &len); /* Read Token. */
+	if (err) {
+		QUIC_INC_STATS(net, QUIC_MIB_PKT_INVHDRDROP);
+		kfree_skb(skb);
+		return err;
+	}
+	if (token.len)
+		toff = token.data - skb->data;
+
+	/* Associate skb with sk to ensure sk is valid if skb is delayed to
+	 * process in workqueue.
+	 */
+	WARN_ON_ONCE(!skb_set_owner_sk_safe(skb, sk));
+	packet->version = version;
+	if (!cb->resume && static_branch_unlikely(&quic_alpn_demux_key)) {
+		if (quic_packet_deferred_schedule(skb))
+			return -EINPROGRESS;
+		if (!quic_get_var(&p, &len, &length) || length > (u64)len) {
+			QUIC_INC_STATS(net, QUIC_MIB_PKT_INVHDRDROP);
+			kfree_skb(skb);
+			return -EINVAL;
+		}
+		cb->length = (u16)length;
+		cb->number_offset = (u16)(p - skb->data);
+		err = quic_packet_get_alpn(skb, &alpns);
+		if (err) {
+			QUIC_INC_STATS(net, QUIC_MIB_PKT_INVHDRDROP);
+			kfree_skb(skb);
+			return err;
+		}
+		if (quic_listen_sock_switch(skb, &alpns))
+			return 0; /* Switched to different listen socket. */
+		if (token.len) /* Update after skb->data may change. */
+			token.data = skb->data + toff;
+	}
+
+	/* Save original DCID for future token validation or Retry logic. */
+	quic_conn_id_update(&odcid, packet->dcid.data, packet->dcid.len);
+	/* If configured to validate client addresses, handle token logic. */
+	if (packet->validate_peer_address) {
+		if (quic_packet_deferred_schedule(skb))
+			return 0;
+		if (!token.len) {
+			/* rfc9000#section-8.1.2:
+			 *
+			 * Upon receiving the client's Initial packet, the
+			 * server can request address validation by sending a
+			 * Retry packet containing a token.
+			 */
+			err = quic_packet_retry_create_and_xmit(sk);
+			consume_skb(skb);
+			return err;
+		}
+
+		/* Distinguish token source: Retry packet or NEW_TOKEN frame. */
+		retry = *(u8 *)token.data == QUIC_TOKEN_FLAG_RETRY;
+
+		/* Verify Token. */
+		crypto = quic_crypto(sk, QUIC_CRYPTO_INITIAL);
+		err = quic_crypto_verify_token(crypto, &packet->daddr,
+					       sizeof(packet->daddr),
+					       &odcid, token.data, token.len);
+		if (err) {
+			if (!retry) {
+				err = quic_packet_retry_create_and_xmit(sk);
+				consume_skb(skb);
+				return err;
+			}
+			/* rfc9000#section-8.1.3:
+			 *
+			 * If a server receives a client Initial that contains
+			 * an invalid Retry token but is otherwise valid, it
+			 * knows the client will not accept another Retry
+			 * token.  The server SHOULD immediately close the
+			 * connection with an INVALID_TOKEN error.
+			 */
+			errcode = QUIC_TRANSPORT_ERROR_INVALID_TOKEN;
+			quic_packet_refuse_close_create_and_xmit(sk, errcode);
+			consume_skb(skb);
+			return err;
+		}
+	}
+
+	/* Add request sock for this new QUIC connection. */
+	req = quic_request_sock_create(sk, &odcid, retry, gfp);
+	if (IS_ERR(req)) {
+		if (quic_packet_deferred_schedule(skb))
+			return 0;
+		/* rfc9000#section-5.2.2:
+		 *
+		 * If a server refuses to accept a new connection, it SHOULD
+		 * send an Initial packet containing a CONNECTION_CLOSE frame
+		 * with error code CONNECTION_REFUSED.
+		 */
+		errcode = QUIC_TRANSPORT_ERROR_CONNECTION_REFUSED;
+		quic_packet_refuse_close_create_and_xmit(sk, errcode);
+		consume_skb(skb);
+		return PTR_ERR(req);
+	}
+out:
+	/* Add to backlog list and wake blocked accept() calls */
+	return quic_request_sock_backlog_tail(sk, req, skb);
+}
+
+static int quic_packet_handshake_process(struct sock *sk, struct sk_buff *skb,
+					 gfp_t gfp)
+{
+	kfree_skb(skb);
+	return -EOPNOTSUPP;
+}
+
+static int quic_packet_app_process(struct sock *sk, struct sk_buff *skb,
+				   gfp_t gfp)
+{
+	kfree_skb(skb);
+	return -EOPNOTSUPP;
+}
+
+int quic_packet_process(struct sock *sk, struct sk_buff *skb, gfp_t gfp)
+{
+	if (quic_is_closed(sk)) {
+		kfree_skb(skb);
+		return 0;
+	}
+
+	if (quic_is_listen(sk))
+		return quic_packet_listen_process(sk, skb, gfp);
+
+	if (quic_hdr(skb)->form == QUIC_PACKET_FORM_LONG)
+		return quic_packet_handshake_process(sk, skb, gfp);
+
+	return quic_packet_app_process(sk, skb, gfp);
+}
+
+/* Work function to process packets in the backlog queue. */
+static void quic_packet_deferred_work(struct work_struct *work)
+{
+	struct quic_sock *qs = container_of(work, struct quic_sock, work);
+	struct sock *sk = &qs->inet.sk;
+	struct sk_buff_head *head;
+	struct sk_buff *skb;
+
+	lock_sock(sk);
+	head = &quic_packet(sk)->deferred_list;
+	while ((skb = __skb_dequeue(head)) != NULL)
+		quic_packet_process(sk, skb, GFP_KERNEL);
+	release_sock(sk);
+	sock_put(sk);
+}
+
 /* Make these fixed for easy coding. */
 #define QUIC_PACKET_NUMBER_LEN	QUIC_PN_MAX_LEN
 #define QUIC_PACKET_LENGTH_LEN	4
@@ -271,6 +1033,10 @@ void quic_packet_init(struct sock *sk)
 	struct quic_packet *packet = quic_packet(sk);
 
 	INIT_LIST_HEAD(&packet->frame_list);
+	skb_queue_head_init(&packet->deferred_list);
+	skb_queue_head_init(&packet->backlog_list);
+	INIT_WORK(quic_work(sk), quic_packet_deferred_work);
+
 	packet->taglen[QUIC_PACKET_FORM_SHORT] = QUIC_TAG_LEN;
 	packet->taglen[QUIC_PACKET_FORM_LONG] = QUIC_TAG_LEN;
 	packet->mss[QUIC_PACKET_MSS_NORMAL] = QUIC_MIN_UDP_PAYLOAD;
@@ -278,3 +1044,12 @@ void quic_packet_init(struct sock *sk)
 
 	packet->version = QUIC_VERSION_V1;
 }
+
+void quic_packet_free(struct sock *sk)
+{
+	struct quic_packet *packet = quic_packet(sk);
+
+	flush_work(quic_work(sk));
+	__skb_queue_purge(&packet->deferred_list);
+	__skb_queue_purge(&packet->backlog_list);
+}
diff --git a/net/quic/packet.h b/net/quic/packet.h
index 18b89f505121..7f12bb53927b 100644
--- a/net/quic/packet.h
+++ b/net/quic/packet.h
@@ -14,6 +14,8 @@ struct quic_packet {
 	union quic_addr daddr;    /* Dest address from received packet */
 	union quic_addr saddr;    /* Source address from received packet */
 
+	struct sk_buff_head deferred_list; /* Packets deferred to work queue */
+	struct sk_buff_head backlog_list;  /* Packets waiting for crypto keys */
 	struct list_head frame_list; /* Frames to pack into packet for send */
 	struct sk_buff *head;        /* Head skb for packet bundling on send */
 	u32 version;   /* QUIC version used/selected during handshake */
@@ -25,6 +27,7 @@ struct quic_packet {
 	u16 hlen;      /* UDP + IP header length for sending */
 	u16 len;       /* QUIC packet length including taglen for sending */
 
+	u8 validate_peer_address:1; /* Temporary; will move to quic_outqueue */
 	u8 path_validating:1; /* Packet contains path_validating frames */
 	u8 ack_eliciting:1;   /* Packet contains ack-eliciting frames */
 	u8 ack_immediate:1;   /* Send ACK immediately (skip ack_delay timer) */
@@ -54,6 +57,8 @@ struct quic_packet {
 
 #define QUIC_VERSION_LEN		4
 
+#define QUIC_ALPN_MAX_LEN		128
+
 #define QUIC_PACKET_MSS_NORMAL		0
 #define QUIC_PACKET_MSS_DGRAM		1
 
@@ -101,6 +106,7 @@ static inline void quic_packet_reset(struct quic_packet *packet)
 	packet->ack_immediate = 0;
 }
 
+int quic_packet_process(struct sock *sk, struct sk_buff *skb, gfp_t gfp);
 u16 quic_packet_overhead(struct sock *sk, u8 level, u8 path);
 int quic_packet_config(struct sock *sk, u8 level, u8 path);
 
@@ -110,3 +116,8 @@ int quic_packet_route(struct sock *sk);
 void quic_packet_mss_update(struct sock *sk, u32 mss);
 void quic_packet_flush(struct sock *sk);
 void quic_packet_init(struct sock *sk);
+void quic_packet_free(struct sock *sk);
+
+u32 *quic_packet_compatible_versions(u32 version);
+
+void quic_packet_rcv_err_pmtu(struct sock *sk);
diff --git a/net/quic/path.c b/net/quic/path.c
index a9e02fc22e60..a41b99dd31ef 100644
--- a/net/quic/path.c
+++ b/net/quic/path.c
@@ -27,14 +27,14 @@ static int quic_udp_rcv(struct sock *sk, struct sk_buff *skb)
 
 	skb_pull(skb, sizeof(struct udphdr));
 	skb_dst_force(skb);
-	kfree_skb(skb);
+	quic_packet_rcv(sk, skb, false);
 	/* .encap_rcv must return 0 if skb was either consumed or dropped. */
 	return 0;
 }
 
 static int quic_udp_err(struct sock *sk, struct sk_buff *skb)
 {
-	return 0;
+	return quic_packet_rcv(sk, skb, true);
 }
 
 static void quic_udp_sock_put_work(struct work_struct *work)
diff --git a/net/quic/path.h b/net/quic/path.h
index 182f48bd6b43..45c3c6bb9d97 100644
--- a/net/quic/path.h
+++ b/net/quic/path.h
@@ -168,6 +168,7 @@ quic_path_orig_dcid(struct quic_path_group *paths)
 	return paths->retry ? &paths->retry_dcid : &paths->orig_dcid;
 }
 
+int quic_packet_rcv(struct sock *sk, struct sk_buff *skb, bool icmp);
 void quic_path_init(struct quic_path_group *paths);
 
 bool quic_path_detect_alt(struct quic_path_group *paths, union quic_addr *sa,
diff --git a/net/quic/socket.c b/net/quic/socket.c
index 1e278a2109b2..0fcb123d31bb 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -24,6 +24,324 @@ static void quic_enter_memory_pressure(struct sock *sk)
 	WRITE_ONCE(quic_memory_pressure, 1);
 }
 
+/* Check if a matching request sock already exists. Match is based on
+ * source/destination addresses and DCID.
+ */
+struct quic_request_sock *quic_request_sock_lookup(struct sock *sk)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_request_sock *req;
+
+	list_for_each_entry(req, quic_reqs(sk), list) {
+		if (!memcmp(&req->saddr, &packet->saddr, sizeof(req->saddr)) &&
+		    !memcmp(&req->daddr, &packet->daddr, sizeof(req->daddr)) &&
+		    !quic_conn_id_cmp(&req->dcid, &packet->dcid))
+			return req;
+	}
+	return NULL;
+}
+
+/* Create and enqueue a QUIC request sock for a new incoming connection. */
+struct quic_request_sock *quic_request_sock_create(struct sock *sk,
+						   struct quic_conn_id *odcid,
+						   u8 retry, gfp_t gfp)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	struct quic_request_sock *req;
+
+	if (sk_acceptq_is_full(sk)) /* Refuse if accept queue full. */
+		return ERR_PTR(-ENOBUFS);
+
+	req = kmalloc_obj(*req, gfp);
+	if (!req)
+		return ERR_PTR(-ENOMEM);
+
+	req->version = packet->version;
+	req->daddr = packet->daddr;
+	req->saddr = packet->saddr;
+	req->scid = packet->scid;
+	req->dcid = packet->dcid;
+	req->orig_dcid = *odcid;
+	req->retry = retry;
+
+	skb_queue_head_init(&req->backlog_list);
+	req->blen = 0;
+
+	/* Enqueue request into listen socket’s pending list for accept(). */
+	list_add_tail(&req->list, quic_reqs(sk));
+	sk_acceptq_added(sk);
+	return req;
+}
+
+int quic_request_sock_backlog_tail(struct sock *sk,
+				   struct quic_request_sock *req,
+				   struct sk_buff *skb)
+{
+	u32 limit = sk->sk_rcvbuf / sk->sk_max_ack_backlog;
+	int len = skb->truesize;
+
+	limit =  max_t(u32, limit, QUIC_MIN_UDP_PAYLOAD * 4);
+	if (req->blen + len > limit || !__sk_rmem_schedule(sk, len, false)) {
+		QUIC_INC_STATS(sock_net(sk), QUIC_MIB_PKT_RCVDROP);
+		kfree_skb(skb);
+		return -ENOBUFS;
+	}
+
+	QUIC_SKB_CB(skb)->backlog = 1;
+	skb_set_owner_r(skb, sk);
+	__skb_queue_tail(&req->backlog_list, skb);
+	req->blen += len;
+
+	sk->sk_data_ready(sk);
+	return 0;
+}
+
+/* Check if a matching accept socket exists. This is needed because an accept
+ * socket might have been created after this packet was enqueued in the listen
+ * socket's backlog.
+ */
+bool quic_accept_sock_exists(struct sock *sk, struct sk_buff *skb)
+{
+	struct quic_packet *packet = quic_packet(sk);
+	bool exist = false;
+
+	/* Skip if packet is newer than the last accept socket creation time.
+	 * No matching socket could exist in this case.
+	 */
+	if (QUIC_SKB_CB(skb)->time >
+	    quic_pnspace(sk, QUIC_CRYPTO_INITIAL)->time)
+		return exist;
+
+	/* Look up accepted socket matching packet addresses and DCID. */
+	local_bh_disable();
+	sk = quic_sock_lookup(skb, &packet->saddr, &packet->daddr,
+			      quic_path_usock(quic_paths(sk), 0),
+			      &packet->dcid);
+	if (!sk)
+		goto out;
+
+	/* Found a matching accept socket. Process packet with this socket. */
+	skb_orphan(skb);
+	bh_lock_sock_nested(sk);
+	if (sock_owned_by_user(sk)) {
+		/* Socket is busy (owned by user context): queue to backlog. */
+		if (sk_add_backlog(sk, skb, READ_ONCE(sk->sk_rcvbuf))) {
+			QUIC_INC_STATS(sock_net(sk), QUIC_MIB_PKT_RCVDROP);
+			kfree_skb(skb);
+		}
+	} else {
+		/* Socket not busy: process immediately. */
+		sk->sk_backlog_rcv(sk, skb); /* quic_packet_process(). */
+	}
+	bh_unlock_sock(sk);
+	sock_put(sk);
+	exist = true;
+out:
+	local_bh_enable();
+	return exist;
+}
+
+/* Lookup a connected QUIC socket based on address and dest connection ID.
+ *
+ * This function searches the established (non-listening) QUIC socket table for
+ * a socket that matches the source and dest addresses and, optionally, the
+ * dest connection ID (DCID). The value returned by quic_path_orig_dcid() might
+ * be the original dest connection ID from the ClientHello or the Source
+ * Connection ID from a Retry packet before.
+ *
+ * The DCID is provided from a handshake packet when searching by source
+ * connection ID fails, such as when the peer has not yet received server's
+ * response and updated the DCID.
+ *
+ * Return: A pointer to the matching connected socket, or NULL if no match is
+ * found.
+ */
+struct sock *quic_sock_lookup(struct sk_buff *skb, union quic_addr *sa,
+			      union quic_addr *da, struct sock *usk,
+			      struct quic_conn_id *dcid)
+{
+	union quic_addr *path_sa, *path_da;
+	struct net *net = sock_net(usk);
+	struct quic_path_group *paths;
+	struct hlist_nulls_node *node;
+	struct quic_shash_head *head;
+	struct sock *sk = NULL, *tmp;
+	struct quic_conn_id *odcid;
+	unsigned int hash, seq;
+	bool match;
+
+	hash = quic_sock_hash(net, sa, da);
+	head = quic_sock_head(hash);
+
+	rcu_read_lock();
+begin:
+	sk_nulls_for_each_rcu(tmp, node, &head->head) {
+		if (net != sock_net(tmp))
+			continue;
+		paths = quic_paths(tmp);
+		odcid = quic_path_orig_dcid(paths);
+
+		/* Protect path[0] reads with seqcount retry to detect torn
+		 * reads during concurrent quic_path_swap(). The seqcount
+		 * ensures we either see a consistent old or new path, never
+		 * a mix of both.
+		 */
+		do {
+			seq = read_seqcount_begin(&paths->path_seq);
+			path_sa = quic_path_saddr(paths, 0);
+			path_da = quic_path_daddr(paths, 0);
+			match = (quic_cmp_sk_addr(tmp, path_sa, sa) &&
+				 quic_cmp_sk_addr(tmp, path_da, da) &&
+				 quic_path_usock(paths, 0) == usk &&
+				 (!dcid || !quic_conn_id_cmp(odcid, dcid)));
+		} while (read_seqcount_retry(&paths->path_seq, seq));
+
+		if (match) {
+			sk = tmp;
+			break;
+		}
+	}
+	/* If the final nulls value differs from the expected one, restart the
+	 * lookup as the node may have been rehashed (e.g., due to connection
+	 * migration).
+	 */
+	if (!sk && get_nulls_value(node) != hash)
+		goto begin;
+
+	if (sk && unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
+		sk = NULL;
+	rcu_read_unlock();
+	return sk;
+}
+
+/* Find the listening QUIC socket for an incoming packet.
+ *
+ * This function searches the QUIC socket table for a listening socket that
+ * matches the dest address and port, and the ALPN(s) if presented in the
+ * ClientHello.  If multiple listening sockets are bound to the same address,
+ * port, and ALPN(s) (e.g., via SO_REUSEPORT), this function selects a socket
+ * from the reuseport group.
+ *
+ * Return: A pointer to the matching listening socket, or NULL if no match is
+ * found.
+ */
+struct sock *quic_listen_sock_lookup(struct sk_buff *skb, union quic_addr *sa,
+				     union quic_addr *da, struct sock *usk,
+				     struct quic_data *alpns)
+{
+	struct net *net = sock_net(usk);
+	struct hlist_nulls_node *node;
+	struct sock *sk = NULL, *tmp;
+	struct quic_shash_head *head;
+	struct quic_data alpn;
+	union quic_addr *a;
+	u32 hash, len;
+	u64 length;
+	u8 *p;
+
+	hash = quic_listen_sock_hash(net, ntohs(sa->v4.sin_port));
+	head = quic_listen_sock_head(hash);
+
+	rcu_read_lock();
+	/* Iterate sockets, checking ALPN requirements. Address specificity
+	 * always takes precedence over ALPN preference order.
+	 */
+	sk_nulls_for_each_rcu(tmp, node, &head->head) {
+		bool alpn_match = false;
+
+		a = quic_path_saddr(quic_paths(tmp), 0);
+		if (net != sock_net(tmp) || !quic_cmp_sk_addr(tmp, a, sa) ||
+		    quic_path_usock(quic_paths(tmp), 0) != usk)
+			continue;
+
+		if (!alpns->len) {
+			/* No ALPN extension or empty ALPN list.
+			 * If alpns->data is NULL, match any socket.
+			 * If alpns->data is set (empty ALPN), only match
+			 * sockets with no ALPN configured.
+			 */
+			alpn_match = (!alpns->data || !quic_alpn(tmp)->len);
+		} else {
+			/* Check if any client ALPN matches this socket. */
+			for (p = alpns->data, len = alpns->len; len;
+			     len -= length, p += length) {
+				quic_get_int(&p, &len, &length, 1);
+				quic_data(&alpn, p, length);
+				if (quic_data_has(quic_alpn(tmp), &alpn)) {
+					alpn_match = true;
+					break;
+				}
+			}
+		}
+
+		if (alpn_match) {
+			if (!quic_is_any_addr(a)) {
+				/* Specific address - best match. */
+				sk = tmp;
+				goto out;
+			}
+			/* ANY address - keep as candidate. */
+			if (!sk || a->sa.sa_family == sa->sa.sa_family)
+				sk = tmp;
+		}
+	}
+	/* No need to check get_nulls_value(node) != hash for !sk, as
+	 * hashtable size is fixed and a listen sk can not rehashed.
+	 */
+out:
+	if (sk && sk->sk_reuseport)
+		sk = reuseport_select_sock(sk, quic_addr_hash(net, da), skb, 1);
+
+	if (sk && unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
+		sk = NULL;
+	rcu_read_unlock();
+	return sk;
+}
+
+/* Switch packet to a different listening socket based on ALPN matching.
+ *
+ * When ALPN demultiplexing is enabled, this function attempts to find a
+ * listening socket that matches the parsed ALPN. If a different socket is
+ * found, the packet is switched to that socket for processing.
+ *
+ * Return: true if switched to a different socket, false otherwise.
+ */
+bool quic_listen_sock_switch(struct sk_buff *skb, struct quic_data *alpns)
+{
+	struct sock *nsk, *sk = skb->sk;
+	struct quic_packet *packet;
+
+	if (!alpns->data)
+		return false;
+
+	local_bh_disable();
+	packet = quic_packet(sk);
+	nsk = quic_listen_sock_lookup(skb, &packet->saddr, &packet->daddr,
+				      quic_path_usock(quic_paths(sk), 0),
+				      alpns);
+	if (!nsk)
+		goto out;
+	if (nsk == sk) {
+		sock_put(nsk);
+		goto out;
+	}
+	local_bh_enable();
+	release_sock(sk);
+
+	skb_orphan(skb);
+
+	lock_sock(nsk);
+	nsk->sk_backlog_rcv(nsk, skb); /* quic_packet_process(). */
+	release_sock(nsk);
+	sock_put(nsk);
+
+	lock_sock(sk);
+	return true;
+out:
+	local_bh_enable();
+	return false;
+}
+
 static void quic_write_space(struct sock *sk)
 {
 	__poll_t mask = EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND;
@@ -48,6 +366,9 @@ static void quic_sock_destruct(struct sock *sk)
 	for (i = 0; i < QUIC_CRYPTO_MAX; i++)
 		quic_crypto_free(quic_crypto(sk, i));
 
+	/* Deferred ALPN free for RCU readers in quic_listen_sock_lookup(). */
+	quic_data_free(quic_alpn(sk));
+
 	quic_sk_destruct(sk);
 }
 
@@ -87,6 +408,7 @@ static void quic_destroy_sock(struct sock *sk)
 	u8 i;
 
 	quic_timer_free(sk);
+	quic_packet_free(sk);
 
 	for (i = 0; i < QUIC_PNSPACE_MAX; i++)
 		quic_pnspace_free(quic_pnspace(sk, i));
@@ -101,7 +423,6 @@ static void quic_destroy_sock(struct sock *sk)
 
 	quic_data_free(quic_ticket(sk));
 	quic_data_free(quic_token(sk));
-	quic_data_free(quic_alpn(sk));
 
 	sk_sockets_allocated_dec(sk);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
@@ -228,6 +549,10 @@ static void quic_release_cb(struct sock *sk)
 		nflags = flags & ~QUIC_DEFERRED_ALL;
 	} while (!try_cmpxchg(&sk->sk_tsq_flags, &flags, nflags));
 
+	if (flags & QUIC_F_MTU_REDUCED_DEFERRED) {
+		quic_packet_rcv_err_pmtu(sk);
+		__sock_put(sk);
+	}
 	if (flags & QUIC_F_LOSS_DEFERRED) {
 		quic_timer_loss_handler(sk);
 		__sock_put(sk);
@@ -262,8 +587,7 @@ static void quic_shutdown(struct sock *sk, int how)
 
 static int quic_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 {
-	kfree_skb(skb);
-	return 0;
+	return quic_packet_process(sk, skb, GFP_ATOMIC);
 }
 
 struct proto quic_prot = {
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 1efc76ec2033..9fe78c0d4ae5 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -60,9 +60,26 @@ enum quic_tsq_flags {
 			   QUIC_F_PMTU_DEFERRED |		\
 			   QUIC_F_PACE_DEFERRED)
 
+struct quic_request_sock {
+	struct list_head	list;
+
+	struct quic_conn_id	dcid;
+	struct quic_conn_id	scid;
+	union quic_addr		daddr;
+	union quic_addr		saddr;
+
+	struct quic_conn_id	orig_dcid;
+	u32			version;
+	u8			retry;
+
+	struct sk_buff_head	backlog_list;
+	u32			blen;
+};
+
 struct quic_sock {
 	struct inet_sock		inet;
 	struct list_head		reqs;
+	struct work_struct		work;
 
 	struct quic_data		ticket;
 	struct quic_data		token;
@@ -95,6 +112,11 @@ static inline struct list_head *quic_reqs(const struct sock *sk)
 	return &quic_sk(sk)->reqs;
 }
 
+static inline struct work_struct *quic_work(const struct sock *sk)
+{
+	return &quic_sk(sk)->work;
+}
+
 static inline struct quic_data *quic_token(const struct sock *sk)
 {
 	return &quic_sk(sk)->token;
@@ -200,3 +222,21 @@ static inline void quic_set_state(struct sock *sk, int state)
 	inet_sk_set_state(sk, state);
 	sk->sk_state_change(sk);
 }
+
+struct sock *quic_listen_sock_lookup(struct sk_buff *skb, union quic_addr *sa,
+				     union quic_addr *da, struct sock *usk,
+				     struct quic_data *alpns);
+struct sock *quic_sock_lookup(struct sk_buff *skb, union quic_addr *sa,
+			      union quic_addr *da, struct sock *usk,
+			      struct quic_conn_id *dcid);
+
+bool quic_listen_sock_switch(struct sk_buff *skb, struct quic_data *alpns);
+bool quic_accept_sock_exists(struct sock *sk, struct sk_buff *skb);
+
+struct quic_request_sock *quic_request_sock_create(struct sock *sk,
+						   struct quic_conn_id *odcid,
+						   u8 retry, gfp_t gfp);
+int quic_request_sock_backlog_tail(struct sock *sk,
+				   struct quic_request_sock *req,
+				   struct sk_buff *skb);
+struct quic_request_sock *quic_request_sock_lookup(struct sock *sk);
-- 
2.47.1

