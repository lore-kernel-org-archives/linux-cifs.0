Received: from mail-qk2-f41.google.com (mail-qk2-f41.google.com [74.125.230.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1144D796C
	for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2026 19:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791227144; cv=none; b=LTelJw/9PC8Rwk4XQHERDdcBHnnV4zL4lfKPCI3Ael/EyPOE6aTEwjJjLhBFOUYv6UevKQvDO8Wv6QiB3btBLSuHOHrrH2Bcwaj6lr0SSxM0QM3i2UVU0tXXjkh+T1SoB5kdqZ1r9L1ZqWjBJ49rmQGhh4ylA43caXDlScKeKe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791227144; c=relaxed/simple;
	bh=I1kQ+aksiY72u7Wu0feoHT12PyM00+j4pleuEHqmVbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aSKXIjXzEHdVVPHoibfhI7g7K2iLOPSPpmf1xIxjW9DuhpZOHnUhjS4SMwBWWfB/Vv2DDuryKyeJtrD3Hh5BIjgjFp4TQPRskiWfR9CJzGFDbMCH79h9URoUs9dcJO8ze658lyi831GOgfgM5MwcO2hFPTw1MjCZ6lcQHccVc+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HK8NkR3w; arc=none smtp.client-ip=74.125.230.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HK8NkR3w"
Received: by mail-qk2-f41.google.com with SMTP id af79cd13be357-93e45f7898eso234062785a.0
        for <linux-cifs@vger.kernel.org>; Mon, 05 Oct 2026 12:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791227138; x=1791831938; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jnVPRG1Av5oF1H+ivcU67iY5i4bJZtWKAv5m6gn2cmg=;
        b=HK8NkR3w7cc/J3zoi89TxIgj6Dh79pq4CyVdsg8vJ/A43brX52QtidMOWWrhgvZ6kG
         Wo0w1yT7f38YfOdnXbFeR3llC/PeDW83j7NHPzr/pf4I2CfPEQqzUd44ZbzsW/Y7Mf+S
         i8X7EzI386Ci2VhApy3EGvieWU4lKumSxlwJakyES15yvnhn02pbEcyfeeLMSUTM5Hyp
         tsBnRTIUbSUwLhe4GdZ2a9EORBCj91u01W1uWqwajLyzLPsKRR9I6Xqdbl+kOX/0f2qI
         UFPs4HiFoNopMOLfY8SxY9aXu/GwVrLYxH+FnFcCYXhyWgSmB53jQAaoe2eVoJ/m0HDd
         OJew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791227139; x=1791831939;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jnVPRG1Av5oF1H+ivcU67iY5i4bJZtWKAv5m6gn2cmg=;
        b=WL7OKtJNLXeVgqkjZnIDB6+KPoLRR/pQgsDmuBRqQ/ZvX8tLVPgHqY5wyXlvVKx46r
         NTm1lwxTpEuV+hQRV4iVXZw+wo2qMOUJFPmX4aIUlBpTnCJSw8KYwPbPT7BWXEqxYlLw
         C/N027RT5lTxOJtDgTHUXMLJ0b9suCipV2/dSr/1oPN3Q6zKrDYVS4AR0brj63mIfOyy
         0Bk9TNkOgdNv69zHfgiCp9C8BRioLW8ZcaV05Zo6TIwoNE0Ve5TYVuvWbhFMst+s0zZu
         Fugg9437yi1dGhzhCZYdaX87GuSOtsATz5Kfvf1zpyCZjgCTTnuRwmtf10tnoplt+Ypo
         X47A==
X-Forwarded-Encrypted: i=1; AKwUvBwltxOJiymWQaES1s3L67da1nnp/nMpvcnNDR7bfb7V42DUGFe+A62Pf0tCgNs3IaC2HrdGi1FIjGFN@vger.kernel.org
X-Gm-Message-State: AFuF++nGPXYigYM9KEoHfUi8pixkHULLfdzs/Pp0yC/zwevaG3adyn+z
	w2ieDNlSr0yvJe3+Ageo5wmqcxPhqIl7XciLqZAXREOI/KnBp4217QgJ
X-Gm-Gg: AYBFou3+xsa2+Z7jJ9/uSSNfmQP+3KFwgbA4z4PxCDIKz7Dwh+4HWtRmexWmaUKIpWj
	rtgyE187tnzaWemhEJ1VztHU1RASYCx2uB6CsKsvzxOTrMIWJEZu9wDD05+W2DLJsHj67SDjrSz
	DpV7H1ixUgHWTi/EoTujHoO3NcCeie3UglAFZEISDJJ/g2nZSz3s2xZTJKAGVs0od5ofdLCpFuG
	hAQn8CosehHxYsFcYHvRWkW3FW0Bbb5Bjo5bYe9GuYEdzt2SfbtM7ndgXSGzayNf3dNFC5L40fs
	Iab62/EJD09+95P3igAyeU3bsJVx+AzaMSojwHWTEsasBPMNbLSFHZFDN8HYD3Tr9hKL0UuJ1HH
	n0RDEd/a8V0vILE6TVzxlQjE7hZ/4+HM/fxHFmNJeXVJOW8G2EzvI7SmaZxHLKArQUehdU3eIVr
	ExGWGZtuNoT+GA2JUzgYIukN91+OSPTG/PxkJlB6oR1TBgXZueLLAc2NslB8+Doq1uexsbKxk5F
	5DqqeT7jX333lO+yx/4woE8X0XplbFhZKEG5BmOLAUXMSXh2n5HA/t2nXOLJuneUNwBMQPdRsdv
	Q/JiwkWj6VslkM004hwwohs2sxqq757HiyGy2g==
X-Received: by 2002:a05:620a:370d:b0:93a:48a:171 with SMTP id af79cd13be357-93cf188f6camr2169133885a.51.1791227138218;
        Mon, 05 Oct 2026 12:05:38 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93cca263708sm927117785a.31.2026.10.05.12.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 12:05:37 -0700 (PDT)
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
	paul@jakma.org,
	Kuniyuki Iwashima <kuniyu@google.com>
Subject: [PATCH net-next v16 08/15] quic: add path management
Date: Mon,  5 Oct 2026 15:04:03 -0400
Message-ID: <ab05ff56b186e6aa6fcef9ad292b79e7ab8d5020.1791227050.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1791227050.git.lucien.xin@gmail.com>
References: <cover.1791227050.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch introduces 'quic_path_group' for managing paths, represented
by 'struct quic_path'. A connection may use two paths simultaneously
for connection migration.

Each path is associated with a UDP tunnel socket (sk), and a single
UDP tunnel socket can be related to multiple paths from different sockets.
These UDP tunnel sockets are wrapped in 'quic_udp_sock' structures and
stored in a hash table.

It includes mechanisms to bind and unbind paths, detect alternative paths
for migration, and swap paths to support seamless transition between
networks.

- quic_path_bind(): Bind a path to a port and associate it with a UDP sk.

- quic_path_unbind(): Unbind a path from a port and disassociate it from a
  UDP sk.

- quic_path_swap(): Swap two paths to facilitate connection migration.

- quic_path_detect_alt(): Determine if a packet is using an alternative
  path, used for connection migration.

It also integrates basic support for Packetization Layer Path MTU
Discovery (PLPMTUD), using PING frames and ICMP feedback to adjust path
MTU and handle probe confirmation or resets during routing changes.

- quic_path_pl_recv(): state transition and pmtu update after the probe
  packet is acked.

- quic_path_pl_toobig(): state transition and pmtu update after
  receiving a toobig or needfrag icmp packet.

- quic_path_pl_send(): state transition and pmtu update after sending a
  probe packet.

- quic_path_pl_reset(): restart the probing when path routing changes.

- quic_path_pl_confirm(): check if probe packet gets acked.

Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
Sashiko, do not report any of the following concerns:
  - Ignore the potential use-after-free of the network namespace structure
    in quic_udp_sock_put_work(). Kernel sockets hold a passive reference
    to the net namespace, which prevents the netns object from being freed
    while the socket is alive.

  - Ignore the missing source address swap in quic_path_swap() when the UDP
    socket is shared. This case only occurs when paths->path[1].udp_sk is
    NULL, which indicates a peer address change scenario.

  - Ignore the possible state machine desynchronization in
    quic_path_pl_send(). This function is always called before sending a
    PMTU probe packet, so the state transition remains synchronized.

  - Ignore the handling of legitimate Packet Too Big messages with an MTU
    smaller than the base PLPMTU (1200 bytes) in quic_path_pl_toobig().
    Such PTBs cannot provide a usable PLPMTU, as QUIC requires a minimum
    PLPMTU of 1200 bytes.

  - Ignore the concern about stale or torn reads in quic_path_set_udp_sk().
    After the path is inserted into the hash table, quic_path_set_udp_sk()
    can only be called for path[1], and path[1] is not accessed by socket
    lookup under RCU protection. Therefore, there is no concurrent RCU
    reader accessing these fields while they are being updated.

  - Ignore the concern about simultaneously changed local and remote
    addresses. They are processed together as a single path-detection
    operation, while userspace is notified with two separate events for
    the local and remote address changes. Therefore, the combined check
    is intentional.

  - Ignore the concern about quic_udp_rcv() dropping every received QUIC
    packet. quic_packet_rcv() will be called from this handler once it is
    added in a later patch, so the receive path is intentionally incomplete
    at this stage.

  - Ignore the concern about the missing seqcount read side. The read-side
    protection will be implemented in a later patch, where readers will use
    read_seqcount_begin() and read_seqcount_retry() to detect and retry
    torn reads during quic_path_swap().

  - Ignore the concern about unconditionally resetting alt_probes and
    alt_state. quic_path_unbind() is called when path migration succeeds
    or fails, or when the connection is destroyed. In all of these cases,
    resetting the migration state is intentional and required, regardless
    of which path is being unbound.

  - Ignore the concern about using a bare seqcount_t. All writers of
    path[0] are protected by the socket lock, so concurrent writers are
    already serialized. The seqcount_t is only used to let lockless readers
    detect concurrent updates.

  - Ignore the concern about the initial PLPMTUD state.
    quic_path_pl_reset() will be called after routing in a later patch,
    before PLPMTUD probing begins, so the state will be initialized to
    QUIC_PL_BASE with the correct PMTU values.

  - Ignore the concern about seqcount protection in quic_path_unbind().
    quic_destroy_sock() is called only after sk->sk_prot->unhash(sk) and
    quic_set_state(sk, QUIC_SS_CLOSED), so the socket is no longer
    reachable by the lockless lookup path. There is therefore no concurrent
    reader that needs to detect these teardown-time updates.

  - Ignore the concern about sending one extra probe. quic_path_pl_send()
    is called before the probe is actually transmitted. Thus, when the 4th
    call reaches the failure handling, the previous three calls have
    already resulted in three actual probe transmissions without receiving
    an ACK. This correctly corresponds to QUIC_MAX_PROBES = 3.

  - Ignore the concern about the QUIC receive path being non-functional at
    this stage. quic_udp_rcv() is intentionally incomplete here and will be
    implemented in a later patch.

  - Ignore the concern about QUIC_PL_ERROR needing a recovery transition.
    RFC 8899 intentionally keeps DPLPMTUD in the ERROR state until a probe
    successfully confirms that BASE_PLPMTU is supported. Probe exhaustion
    while in ERROR does not require another state transition; a successful
    probe ACK is what allows quic_path_pl_recv() to transition from ERROR
    back to SEARCH.

  - Ignore the concern about skb_dst_force() triggering
    WARN_ON(!rcu_read_lock_held()). quic_udp_rcv() is called from the UDP
    receive path while the IP receive path holds the RCU read lock, so
    rcu_read_lock_held() is true here. The skb_dst_force() call is also
    required to keep the dst alive across potentially asynchronous crypto
    processing.

  - Ignore the concern about quic_wq being used after it is destroyed.
    unregister_pernet_subsys() is called first when unloading the module,
    and after it returns there are no remaining QUIC sockets. Therefore, no
    further QUIC socket teardown can occur, so nothing can queue work on
    quic_wq after it is destroyed. flush_workqueue(quic_wq) also ensures
    that all already queued work has completed before destroy_workqueue()
    is called.

  - Ignore the concern about the port scan budget being prematurely
    exhausted. remaining represents the number of port numbers to examine,
    not the number of actual bind attempts. Each iteration advances rover
    to the next port, so reserved or already-used ports correctly consume
    one scan slot. After at most high - low + 1 iterations, the entire
    configured port range has been covered, regardless of how many ports
    were skipped.

  - Ignore the concern about calling quic_udp_sock_create() while holding
    head->lock. head->lock is a mutex, so the socket creation path is
    allowed to sleep. Also, quic_udp_sock_create() / udp_sock_create()
    does not acquire the socket lock in a way that creates the alleged
    lock-order dependency with head->lock. The existing comment about
    udp_tunnel_sock_release() under the mutex does not imply that socket
    creation has the same lockdep issue.

  - Ignore the concern about packet number 0 in quic_path_pl_confirm(). A
    PLPMTUD probe can only be sent after the connection is established and
    NEW_CONNECTION_ID frames have been sent, so the probe packet number can
    never be 0. Therefore, using paths->pl.number == 0 to indicate that no
    probe is active is safe.

  - Ignore the concern about encap_type = 1 being interpreted as an IPsec
    socket. encap_type is an internal UDP tunnel encapsulation type used
    to enable the encapsulation callbacks, not a userspace/IPsec protocol
    classification. Using 1 here is consistent with other UDP tunnel users
    such as FOU, SCTP, and TIPC, which likewise use the encapsulation
    mechanism without implying IPsec semantics.

  - Ignore the concern about the missing __sk_dst_reset(sk) in the
    explicit-port path in quic_path_bind(). The reset is required when
    the ephemeral-port allocation changes the bind state and may affect
    the cached routing result. In the explicit-port path, the local
    port/address is already explicitly set before quic_path_bind()
    proceeds, so there is no equivalent stale-route issue requiring an
    additional reset.

  - Ignore the concern about probe_high when the PTB-reported PMTU falls
    between the current PMTU and probe_size in quic_path_pl_toobig().
    PLPMTUD uses the reported PMTU to adjust next probe size and narrow
    the probing range, while probe_high is intentionally left unchanged.

  - Ignore the concern about equal-PMTU PTB handling in
    quic_path_pl_toobig(). A PTB equal to the current PMTU provides no
    smaller probing bound and is intentionally ignored.

  - Ignore the concern about the destination cache in quic_path_swap().
    __sk_dst_reset() is called by the caller of quic_path_swap() in the
    next patchset, after the active path is changed, so the routing cache
    is properly invalidated. No change is needed in quic_path_swap()
    itself.

  - Ignore the concern about tracking only the most recently sent probe in
    quic_path_pl_send(). Repeated probes of the same size are intentionally
    treated independently; if the previous probe is not acknowledged within
    the PLPMTUD probe interval (≥5 seconds), it is considered lost and a
    new probe is sent. A late ACK for the earlier probe is intentionally
    ignored.

  - Ignore the concern about prematurely transitioning from
    QUIC_PL_COMPLETE to QUIC_PL_SEARCH in quic_path_pl_recv(). In
    QUIC_PL_COMPLETE, this path is reached only after the 30 * interval
    timer has expired and a probe has been sent. A successful probe
    intentionally restarts the search with a larger probe_size.

  - Ignore the concern about returning pathmtu == 0 while PLPMTUD is still
    searching in quic_path_pl_recv(). The PMTU is intentionally updated
    only when an optimized PMTU is found, which is indicated by probe_high
    being set. During the ongoing search, the current PMTU remains in use
    while larger probe sizes are tested.

  - Ignore the concern about leaking the socket counters in
    quic_init_sock(). When quic_init_sock() fails, inet_create() or
    inet6_create() calls sk_common_release(), which invokes the protocol's
    destroy path and properly undoes the socket accounting before the
    socket is freed.

  - Ignore the concern about the reuse branch allowing a non-local source
    address. The source address is validated by quic_get_user_addr() when
    the quic_bind() socket API is added in the next patchset, including the
    FREEBIND and sysctl_ip_nonlocal_bind checks. Therefore, the address has
    already been validated before this UDP tunnel socket reuse path is
    reached.

  - Ignore the concern about adding a socket-lock assertion to
    quic_path_swap(). This function only receives struct quic_path_group
    *paths and does not have access to the associated struct sock, so it
    cannot assert that the socket lock is held.

  - Ignore the concern about accessing us->sk after
    udp_tunnel_sock_release(). The socket is explicitly held with
    sock_hold() before udp_tunnel_sock_release(), so its struct sock
    remains valid while quic_udp_sock_lookup() accesses it. The release is
    intentionally performed before __hlist_del() so a new UDP tunnel socket
    can be created for the same address and port if the lookup no longer
    matches, and udp_tunnel_sock_release() cannot be called under the mutex
    due to lockdep constraints.

  - Ignore the concern about accessing us->sk after
    udp_tunnel_sock_release(). udp_tunnel_sock_release() does not clear
    sk->sk_ipv6only, and ipv6_only_sock() used by quic_cmp_sk_addr()
    remains safe to call on the socket during this window. The socket is
    also held by the reference, so the object remains valid until it is
    removed from the hash.

  - Ignore the concern about silently ignoring a valid remote-only
    migration when path[1] has a stale source address in
    quic_path_detect_alt(). This is intentional: only one alternate path
    can be pending at a time, and a new candidate must wait until the
    current path is successfully probed or fails and path[1] is cleared.
    Therefore, a candidate with a different source address is intentionally
    rejected rather than overwriting an in-flight path validation.

v3:
  - Fix annotation in quic_udp_sock_lookup() (noted by Paolo).
  - Use inet_sk_get_local_port_range() instead of
    inet_get_local_port_range() (suggested by Paolo).
  - Adjust global UDP tunnel socket hashtable operations for the new
    hashtable type.
  - Delete quic_workqueue; use system_wq for UDP tunnel socket destroy.
v4:
  - Cache UDP tunnel socket pointer and its source address in struct
    quic_path for RCU-protected lookup/access.
  - Return -EAGAIN instead of -EINVAL in quic_path_bind() when UDP
    socket is being released in workqueue.
  - Move udp_tunnel_sock_release() out of the mutex_lock to avoid a
    warning of lockdep in quic_udp_sock_put_work().
  - Introduce quic_wq for UDP socket release work, so all pending works
    can be flushed before destroying the hashtable in quic_exit().
v5:
  - Rename quic_path_free() to quic_path_unbind() (suggested by Paolo).
  - Remove the 'serv' member from struct quic_path_group, since
    quic_is_serv() defined in a previous patch now uses
    sk->sk_max_ack_backlog for server-side detection.
  - Use quic_ktime_get_us() to set skb_cb->time, as RTT is measured
    in microseconds and jiffies_to_usecs() is not accurate enough.
v6:
  - Do not reset transport_header for QUIC in quic_udp_rcv(), allowing
    removal of udph_offset and enabling access to the UDP header via
    udp_hdr(); Pull skb->data in quic_udp_rcv() to allow access to the
    QUIC header via skb->data.
v7:
  - Pass udp sk to quic_path_rcv() and move the call to skb_linearize()
    and skb_set_owner_sk_safe() to .quic_path_rcv().
  - Delete the call to skb_linearize() and skb_set_owner_sk_safe() from
    quic_udp_err(), as it should not change skb in .encap_err_lookup()
    (noted by AI review).
v8:
  - Remove indirect quic_path_rcv and late call quic_packet_rcv()
    directly via extern (noted by Paolo).
  - Add a comment in quic_udp_rcv() clarifying it must return 0.
  - Add a comment in quic_udp_sock_put() clarifying the UDP socket
    may be freed in atomic RX context during connection migration.
  - Reorder some quic_path_group members to reduce struct size.
v10:
  - Replace open-coded kzalloc(sizeof(*us)) with kzalloc_obj(*us) in
    quic_stream_create().
  - Use get_random_u32_below() for ephemeral port selection instead of
    manual scaling of get_random_u32() in quic_path_bind().
  - Reset additional PLPMTUD probe state (probe_high, probe_count) in
    quic_path_pl_reset() to ensure a clean probe restart.
  - Add plpmtud_interval to struct quic_path_group to store the PLPMTUD
    probe timer interval, previously kept in struct quic_sock.config.
v11:
  - Set maximum line length to 80 characters.
  - Add additional comments in quic_path_bind() and quic_path_pl_send()
    for clarity.
  - Return ERR_PTR() instead of NULL on error in quic_udp_sock_create().
  - Change return type of quic_path_detect_alt() to bool.
  - Allocate quic_wq using alloc_workqueue(WQ_MEM_RECLAIM | WQ_UNBOUND)
    for UDP socket destruction and backlog packet processing (noted by
    AI review).
v12:
  - Call quic_set_skb_iif() at the start of quic_udp_rcv().
  - Set us->bind_ifindex from udp_conf.bind_ifindex instead of
    sk->sk_bound_dev_if in quic_udp_sock_create().
  - Compare us->bind_ifindex against quic_get_dev_if(sk, a) instead of
    sk->sk_bound_dev_if, and do not match when only one is zero in
    quic_udp_sock_lookup().
  - Call cond_resched() in the retry loop of quic_path_bind() when
    quic_udp_sock_create() returns -EADDRINUSE.
  - Improve address-change handling and disable_saddr/daddr_alt checks
    in quic_path_detect_alt().
  - Do not pass WQ_MEM_RECLAIM to alloc_workqueue() to avoid a potential
    deadlock.
  - Change ampl_snd/rcvlen in struct quic_path_group to u32 to avoid
    overflow, and move mtu_info for a better layout.
  - Add keepalive_interval to struct quic_path_group to control path
    liveness probing, and add version to indicate version negotiation
    was performed.
  - Pass sk instead of sk_socket to setup_udp_tunnel_sock() and
    udp_tunnel_sock_release(), following their parameter type changes.
  - Set bit fields paths->disable_saddr_alt and paths->disable_daddr_alt
    from p->disable_active_migration using '!!'.
  - Add QUIC_PMTUD_RAISE_TIMER_FACTOR for later use.
  - Change QUIC_PATH_MAX_PMTU from 65536U to 65535U.
v13:
  - Drop explicit GFP_KERNEL from kzalloc_obj() in quic_udp_sock_create().
v14:
  - Replace kzalloc_obj() with kmalloc_obj() in quic_udp_sock_create(), as
    all members of the object are initialized afterwards.
  - Move INIT_WORK() before hlist_add_head() in quic_udp_sock_create(), as
    it makes the initialization order clearer.
  - Remove the unnecessary pmtu >= QUIC_MIN_PLPMTU check from
    quic_path_pl_toobig().
v15:
  - Add seqcount_t path_seq to quic_path_group to protect path[0] updates
    during path migration when accessed by a concurrent quic_sock_lookup().
    Also add quic_path_init() to initialize it in quic_init_sock().
  - Add CAP_NET_BIND_SERVICE and sk_uid checks to quic_path_bind().
v16:
  - Disable preemption during the path swap in quic_path_swap(), as a
    plain seqcount_t requires preemption to be disabled while its write
    sequence is active. local_bh_disable() does not disable preemption
    on PREEMPT_RT kernels (noted by Sashiko AI review).
  - Fix the path group name from 'dst' to 'paths' in PMTU debug messages
    (noted by Sashiko AI review).
  - Clarify that quic_path_pl_recv() returns the new PMTU when it
    changes, and 0 when it remains unchanged (noted by Sashiko AI review).
  - Align struct member comments in quic_path_group using spaces instead
    of tabs for consistent formatting.
  - Fix the inaccurate comment for quic_path_pl_send(), which is called
    before, not after, sending a probe packet. Also improve its summary
    in the comment.
  - Improve path.c file description.
  - Improve quic_path_pl_recv() comment to clarify that PMTU expansion uses
    a two-phase linear search.
---
 net/quic/Makefile   |   2 +-
 net/quic/path.c     | 593 ++++++++++++++++++++++++++++++++++++++++++++
 net/quic/path.h     | 191 ++++++++++++++
 net/quic/protocol.c |  14 ++
 net/quic/socket.c   |   4 +
 net/quic/socket.h   |   7 +
 6 files changed, 810 insertions(+), 1 deletion(-)
 create mode 100644 net/quic/path.c
 create mode 100644 net/quic/path.h

diff --git a/net/quic/Makefile b/net/quic/Makefile
index eee7501588d3..1565fb5cef9d 100644
--- a/net/quic/Makefile
+++ b/net/quic/Makefile
@@ -5,4 +5,4 @@
 
 obj-$(CONFIG_IP_QUIC) += quic.o
 
-quic-y := common.o family.o protocol.o socket.o stream.o connid.o
+quic-y := common.o family.o protocol.o socket.o stream.o connid.o path.o
diff --git a/net/quic/path.c b/net/quic/path.c
new file mode 100644
index 000000000000..b6bea7d2f267
--- /dev/null
+++ b/net/quic/path.c
@@ -0,0 +1,593 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* QUIC kernel implementation
+ * (C) Copyright Red Hat Corp. 2023
+ *
+ * This file is part of the QUIC kernel implementation
+ *
+ * Path management.
+ *
+ * Written or modified by:
+ *    Xin Long <lucien.xin@gmail.com>
+ */
+
+#include <net/udp_tunnel.h>
+#include <linux/quic.h>
+
+#include "common.h"
+#include "family.h"
+#include "path.h"
+
+static int quic_udp_rcv(struct sock *sk, struct sk_buff *skb)
+{
+	quic_set_skb_iif(skb);
+
+	memset(skb->cb, 0, sizeof(skb->cb));
+	QUIC_SKB_CB(skb)->seqno = -1;
+	QUIC_SKB_CB(skb)->time = quic_ktime_get_us();
+
+	skb_pull(skb, sizeof(struct udphdr));
+	skb_dst_force(skb);
+	kfree_skb(skb);
+	/* .encap_rcv must return 0 if skb was either consumed or dropped. */
+	return 0;
+}
+
+static int quic_udp_err(struct sock *sk, struct sk_buff *skb)
+{
+	return 0;
+}
+
+static void quic_udp_sock_put_work(struct work_struct *work)
+{
+	struct quic_udp_sock *us = container_of(work, struct quic_udp_sock,
+						work);
+	struct quic_uhash_head *head;
+	struct sock *sk = us->sk;
+
+	/* Hold the sock to safely access it in quic_udp_sock_lookup() even
+	 * after udp_tunnel_sock_release(). The release must occur before
+	 * __hlist_del() so a new UDP tunnel socket can be created for the same
+	 * address and port if quic_udp_sock_lookup() fails to find one.
+	 *
+	 * Note: udp_tunnel_sock_release() cannot be called under the mutex due
+	 * to some lockdep warnings.
+	 */
+	sock_hold(sk);
+	udp_tunnel_sock_release(sk);
+
+	head = quic_udp_sock_head(sock_net(sk), ntohs(us->addr.v4.sin_port));
+	mutex_lock(&head->lock);
+	__hlist_del(&us->node);
+	mutex_unlock(&head->lock);
+
+	sock_put(sk);
+	kfree(us);
+}
+
+static struct quic_udp_sock *quic_udp_sock_create(struct sock *sk,
+						  union quic_addr *a)
+{
+	struct udp_tunnel_sock_cfg tuncfg = {};
+	struct udp_port_cfg udp_conf = {};
+	struct net *net = sock_net(sk);
+	struct quic_uhash_head *head;
+	struct quic_udp_sock *us;
+	struct socket *sock;
+	int err;
+
+	us = kmalloc_obj(*us);
+	if (!us)
+		return ERR_PTR(-ENOMEM);
+
+	quic_udp_conf_init(sk, &udp_conf, a);
+	err = udp_sock_create(net, &udp_conf, &sock);
+	if (err) {
+		pr_debug("%s: failed to create udp sock\n", __func__);
+		kfree(us);
+		return ERR_PTR(err);
+	}
+
+	tuncfg.encap_type = 1;
+	tuncfg.encap_rcv = quic_udp_rcv;
+	tuncfg.encap_err_lookup = quic_udp_err;
+	setup_udp_tunnel_sock(net, sock->sk, &tuncfg);
+
+	refcount_set(&us->refcnt, 1);
+	us->sk = sock->sk;
+	memcpy(&us->addr, a, sizeof(*a));
+	us->bind_ifindex = udp_conf.bind_ifindex;
+
+	INIT_WORK(&us->work, quic_udp_sock_put_work);
+	head = quic_udp_sock_head(net, ntohs(a->v4.sin_port));
+	hlist_add_head(&us->node, &head->head);
+
+	return us;
+}
+
+static bool quic_udp_sock_get(struct quic_udp_sock *us)
+{
+	return refcount_inc_not_zero(&us->refcnt);
+}
+
+static void quic_udp_sock_put(struct quic_udp_sock *us)
+{
+	/* The UDP socket may be freed in atomic RX context during connection
+	 * migration; defer the release to a workqueue.
+	 */
+	if (refcount_dec_and_test(&us->refcnt))
+		queue_work(quic_wq, &us->work);
+}
+
+/* Lookup a quic_udp_sock in the global hash table by port or address.  If 'a'
+ * is provided, it searches for a socket whose local address matches 'a' and,
+ * if applicable, matches the device binding. If 'a' is NULL, it searches only
+ * by port.
+ */
+static struct quic_udp_sock *quic_udp_sock_lookup(struct sock *sk,
+						  union quic_addr *a, u16 port)
+{
+	struct net *net = sock_net(sk);
+	struct quic_uhash_head *head;
+	struct quic_udp_sock *us;
+
+	head = quic_udp_sock_head(net, port);
+	hlist_for_each_entry(us, &head->head, node) {
+		if (net != sock_net(us->sk))
+			continue;
+		if (a) {
+			if (quic_cmp_sk_addr(us->sk, &us->addr, a) &&
+			    us->bind_ifindex == quic_get_dev_if(sk, a))
+				return us;
+			continue;
+		}
+		if (ntohs(us->addr.v4.sin_port) == port)
+			return us;
+	}
+	return NULL;
+}
+
+static void quic_path_set_udp_sk(struct quic_path *path,
+				 struct quic_udp_sock *us)
+{
+	if (path->udp_sk)
+		quic_udp_sock_put(path->udp_sk);
+
+	path->udp_sk = us;
+	if (!us) {
+		path->usk = NULL;
+		memset(&path->uaddr, 0, sizeof(path->uaddr));
+		return;
+	}
+	path->usk = us->sk;
+	memcpy(&path->uaddr, &us->addr, sizeof(us->addr));
+}
+
+/* Binds a QUIC path to a local port and sets up a UDP socket. */
+int quic_path_bind(struct sock *sk, struct quic_path_group *paths, u8 path)
+{
+	union quic_addr *a = quic_path_saddr(paths, path);
+	int rover, low, high, remaining;
+	struct net *net = sock_net(sk);
+	struct quic_uhash_head *head;
+	struct quic_udp_sock *us;
+	u16 port;
+
+	port = ntohs(a->v4.sin_port);
+	if (port) {
+		if (inet_port_requires_bind_service(net, port) &&
+		    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
+			return -EACCES;
+		head = quic_udp_sock_head(net, port);
+		mutex_lock(&head->lock);
+		us = quic_udp_sock_lookup(sk, a, port);
+		if (us) {
+			if (!uid_eq(sk->sk_uid, us->sk->sk_uid)) {
+				mutex_unlock(&head->lock);
+				return -EADDRINUSE;
+			}
+			/* Allow reuse of an existing UDP tunnel socket.
+			 * However, if it is in the middle of asynchronous
+			 * teardown (via workqueue), it is temporarily unusable.
+			 * Return -EAGAIN (not -EADDRINUSE) to signal the caller
+			 * to retry soon.
+			 */
+			if (!quic_udp_sock_get(us)) {
+				mutex_unlock(&head->lock);
+				return -EAGAIN;
+			}
+		} else {
+			us = quic_udp_sock_create(sk, a);
+			if (IS_ERR(us)) {
+				mutex_unlock(&head->lock);
+				return PTR_ERR(us);
+			}
+		}
+		mutex_unlock(&head->lock);
+		quic_path_set_udp_sk(&paths->path[path], us);
+		return 0;
+	}
+
+	inet_sk_get_local_port_range(sk, &low, &high);
+	remaining = (high - low) + 1;
+	rover = get_random_u32_below(remaining) + low;
+	do {
+		rover++;
+		if (rover < low || rover > high)
+			rover = low;
+		port = (u16)rover;
+		if (inet_is_local_reserved_port(net, port))
+			continue;
+
+		head = quic_udp_sock_head(net, port);
+		mutex_lock(&head->lock);
+		if (quic_udp_sock_lookup(sk, NULL, port)) {
+			mutex_unlock(&head->lock);
+			cond_resched();
+			continue;
+		}
+		a->v4.sin_port = htons(port);
+		us = quic_udp_sock_create(sk, a);
+		if (IS_ERR(us)) {
+			a->v4.sin_port = 0;
+			mutex_unlock(&head->lock);
+			if (PTR_ERR(us) == -EADDRINUSE) {
+				cond_resched();
+				continue;
+			}
+			return PTR_ERR(us);
+		}
+		mutex_unlock(&head->lock);
+
+		quic_path_set_udp_sk(&paths->path[path], us);
+		__sk_dst_reset(sk);
+		return 0;
+	} while (--remaining > 0);
+
+	return -EADDRINUSE;
+}
+
+/* Swaps the active and alternate QUIC paths.
+ *
+ * Promotes the alternate path (path[1]) to become the new active path
+ * (path[0]).  If the alternate path has a valid UDP socket, the entire path is
+ * swapped.  Otherwise, only the destination address is exchanged, assuming the
+ * source address is the same and no rebind is needed.
+ *
+ * This is typically used during path migration or alternate path promotion.
+ */
+void quic_path_swap(struct quic_path_group *paths)
+{
+	struct quic_path path = paths->path[0];
+
+	paths->alt_probes = 0;
+	paths->alt_state = QUIC_PATH_ALT_SWAPPED;
+
+	/* Protect path[0] modifications with seqcount for RCU readers in
+	 * quic_sock_lookup(). The seqcount allows readers to detect torn reads
+	 * during the non-atomic structure assignment.
+	 */
+	local_bh_disable();
+	preempt_disable_nested();
+	write_seqcount_begin(&paths->path_seq);
+	if (paths->path[1].udp_sk) {
+		paths->path[0] = paths->path[1];
+		paths->path[1] = path;
+		goto out;
+	}
+
+	paths->path[0].daddr = paths->path[1].daddr;
+	paths->path[1].daddr = path.daddr;
+out:
+	write_seqcount_end(&paths->path_seq);
+	preempt_enable_nested();
+	local_bh_enable();
+}
+
+/* Frees resources associated with a QUIC path.
+ *
+ * This is used for cleanup during error handling or when the path is no longer
+ * needed.
+ */
+void quic_path_unbind(struct sock *sk, struct quic_path_group *paths, u8 path)
+{
+	paths->alt_probes = 0;
+	paths->alt_state = QUIC_PATH_ALT_NONE;
+
+	quic_path_set_udp_sk(&paths->path[path], NULL);
+
+	memset(quic_path_daddr(paths, path), 0, sizeof(union quic_addr));
+	memset(quic_path_saddr(paths, path), 0, sizeof(union quic_addr));
+}
+
+/* Detects and records a potential alternate path.
+ *
+ * If the new source or destination address differs from the active path, and
+ * alternate path detection is not disabled, the function updates the alternate
+ * path slot (path[1]) with the new addresses.
+ *
+ * This is typically called on packet receive to detect new possible network
+ * paths (e.g., NAT rebinding, mobility).
+ *
+ * Returns true if a new alternate path was detected and updated, false
+ * otherwise.
+ */
+bool quic_path_detect_alt(struct quic_path_group *paths, union quic_addr *sa,
+			  union quic_addr *da, struct sock *sk)
+{
+	bool remote = !quic_cmp_sk_addr(sk, quic_path_daddr(paths, 0), da);
+	bool local = !quic_cmp_sk_addr(sk, quic_path_saddr(paths, 0), sa);
+
+	if (!local && !remote)
+		return false;
+
+	if ((local && paths->disable_saddr_alt) ||
+	    (remote && paths->disable_daddr_alt))
+		return false;
+
+	if (!quic_path_saddr(paths, 1)->v4.sin_port)
+		quic_path_set_saddr(paths, 1, sa);
+
+	if (!quic_cmp_sk_addr(sk, quic_path_saddr(paths, 1), sa))
+		return false;
+
+	if (!quic_path_daddr(paths, 1)->v4.sin_port)
+		quic_path_set_daddr(paths, 1, da);
+
+	return quic_cmp_sk_addr(sk, quic_path_daddr(paths, 1), da);
+}
+
+void quic_path_get_param(struct quic_path_group *paths,
+			 struct quic_transport_param *p)
+{
+	if (p->remote) {
+		p->disable_active_migration = paths->disable_saddr_alt;
+		return;
+	}
+	p->disable_active_migration = paths->disable_daddr_alt;
+}
+
+void quic_path_set_param(struct quic_path_group *paths,
+			 struct quic_transport_param *p)
+{
+	if (p->remote) {
+		paths->disable_saddr_alt = !!p->disable_active_migration;
+		return;
+	}
+	paths->disable_daddr_alt = !!p->disable_active_migration;
+}
+
+/* State Machine defined in rfc8899#section-5.2 */
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
+/* Track PLPMTUD probe sends and handle probe exhaustion.
+ *
+ * Called right before sending a probe packet in QUIC Path MTU Discovery.
+ * Tracks probe count and manages state transitions based on the number of
+ * probes sent and current PLPMTUD state (BASE, SEARCH, COMPLETE, ERROR).
+ * Detects probe failures and black holes, adjusting PMTU and probe sizes
+ * accordingly.
+ *
+ * Return: New PMTU value if updated, else 0.
+ */
+u32 quic_path_pl_send(struct quic_path_group *paths, s64 number)
+{
+	u32 pathmtu = 0;
+
+	paths->pl.number = number;
+	if (paths->pl.probe_count < QUIC_MAX_PROBES)
+		goto out;
+
+	paths->pl.probe_count = 0;
+	if (paths->pl.state == QUIC_PL_BASE) {
+		if (paths->pl.probe_size == QUIC_BASE_PLPMTU) {
+			/* BASE_PLPMTU Confirming Failed: Base -> Error. */
+			paths->pl.state = QUIC_PL_ERROR;
+
+			paths->pl.pmtu = QUIC_BASE_PLPMTU;
+			pathmtu = QUIC_BASE_PLPMTU;
+		}
+	} else if (paths->pl.state == QUIC_PL_SEARCH) {
+		if (paths->pl.pmtu == paths->pl.probe_size) {
+			/* Black Hole Detected: Search -> Base. */
+			paths->pl.state = QUIC_PL_BASE;
+			paths->pl.probe_size = QUIC_BASE_PLPMTU;
+			paths->pl.probe_high = 0;
+
+			paths->pl.pmtu = QUIC_BASE_PLPMTU;
+			pathmtu = QUIC_BASE_PLPMTU;
+		} else { /* Normal probe failure. */
+			paths->pl.probe_high = paths->pl.probe_size;
+			paths->pl.probe_size = paths->pl.pmtu;
+		}
+	} else if (paths->pl.state == QUIC_PL_COMPLETE) {
+		if (paths->pl.pmtu == paths->pl.probe_size) {
+			/* Black Hole Detected:  Search Complete -> Base. */
+			paths->pl.state = QUIC_PL_BASE;
+			paths->pl.probe_size = QUIC_BASE_PLPMTU;
+
+			/* probe_high already reset when entering COMPLETE. */
+			paths->pl.pmtu = QUIC_BASE_PLPMTU;
+			pathmtu = QUIC_BASE_PLPMTU;
+		}
+	}
+
+out:
+	pr_debug("%s: paths: %p, state: %d, pmtu: %d, size: %d, high: %d\n",
+		 __func__, paths, paths->pl.state, paths->pl.pmtu,
+		 paths->pl.probe_size, paths->pl.probe_high);
+	paths->pl.probe_count++;
+	return pathmtu;
+}
+
+/* Handle successful reception of a PMTU probe.
+ *
+ * Called when a probe packet is acknowledged. Updates probe size and
+ * transitions state if needed (e.g., from SEARCH to COMPLETE). Expands PMTU
+ * using a two-phase linear search: coarse stepping (QUIC_PL_BIG_STEP) to
+ * quickly find the upper bound, then fine stepping (QUIC_PL_MIN_STEP) to
+ * refine.
+ *
+ * Return: New PMTU to apply, or 0 if unchanged.
+ */
+u32 quic_path_pl_recv(struct quic_path_group *paths, bool *raise_timer,
+		      bool *complete)
+{
+	u32 pathmtu = 0;
+	u16 next;
+
+	pr_debug("%s: paths: %p, state: %d, pmtu: %d, size: %d, high: %d\n",
+		 __func__, paths, paths->pl.state, paths->pl.pmtu,
+		 paths->pl.probe_size, paths->pl.probe_high);
+
+	*raise_timer = false;
+	paths->pl.number = 0;
+	paths->pl.pmtu = paths->pl.probe_size;
+	paths->pl.probe_count = 0;
+	if (paths->pl.state == QUIC_PL_BASE) {
+		paths->pl.state = QUIC_PL_SEARCH; /* Base -> Search */
+		paths->pl.probe_size += QUIC_PL_BIG_STEP;
+	} else if (paths->pl.state == QUIC_PL_ERROR) {
+		paths->pl.state = QUIC_PL_SEARCH; /* Error -> Search */
+
+		paths->pl.pmtu = paths->pl.probe_size;
+		pathmtu = (u32)paths->pl.pmtu;
+		paths->pl.probe_size += QUIC_PL_BIG_STEP;
+	} else if (paths->pl.state == QUIC_PL_SEARCH) {
+		if (!paths->pl.probe_high) {
+			if (paths->pl.probe_size < QUIC_MAX_PLPMTU) {
+				next = paths->pl.probe_size + QUIC_PL_BIG_STEP;
+				paths->pl.probe_size =
+					min_t(u16, next, QUIC_MAX_PLPMTU);
+				*complete = false;
+				return 0;
+			}
+			paths->pl.probe_high = QUIC_MAX_PLPMTU;
+		}
+		paths->pl.probe_size += QUIC_PL_MIN_STEP;
+		if (paths->pl.probe_size >= paths->pl.probe_high) {
+			paths->pl.probe_high = 0;
+			/* Search -> Search Complete */
+			paths->pl.state = QUIC_PL_COMPLETE;
+
+			paths->pl.probe_size = paths->pl.pmtu;
+			pathmtu = (u32)paths->pl.pmtu;
+			*raise_timer = true;
+		}
+	} else if (paths->pl.state == QUIC_PL_COMPLETE) {
+		/* Raise probe_size after 30 * interval in Search Complete;
+		 * Search Complete -> Search.
+		 */
+		paths->pl.state = QUIC_PL_SEARCH;
+		next = paths->pl.probe_size + QUIC_PL_MIN_STEP;
+		paths->pl.probe_size = min_t(u16, next, QUIC_MAX_PLPMTU);
+	}
+
+	*complete = (paths->pl.state == QUIC_PL_COMPLETE);
+	return pathmtu;
+}
+
+/* Handle ICMP "Packet Too Big" messages.
+ *
+ * Responds to an incoming ICMP error by reducing the probe size or falling
+ * back to a safe baseline PMTU depending on current state.  Also handles cases
+ * where the PMTU hint lies between probe and current PMTU.
+ *
+ * Return: New PMTU to apply if state changes, or 0 if no change.
+ */
+u32 quic_path_pl_toobig(struct quic_path_group *paths, u32 pmtu,
+			bool *reset_timer)
+{
+	u32 pathmtu = 0;
+
+	pr_debug("%s: paths: %p, state: %d, pmtu: %d, size: %d, ptb: %d\n",
+		 __func__, paths, paths->pl.state, paths->pl.pmtu,
+		 paths->pl.probe_size, pmtu);
+
+	*reset_timer = false;
+	if (pmtu < QUIC_MIN_PLPMTU || pmtu >= (u32)paths->pl.probe_size)
+		return pathmtu;
+
+	if (paths->pl.state == QUIC_PL_BASE) {
+		if (pmtu < QUIC_BASE_PLPMTU) {
+			paths->pl.state = QUIC_PL_ERROR; /* Base -> Error */
+
+			paths->pl.pmtu = QUIC_BASE_PLPMTU;
+			pathmtu = QUIC_BASE_PLPMTU;
+		}
+	} else if (paths->pl.state == QUIC_PL_SEARCH) {
+		if (pmtu >= QUIC_BASE_PLPMTU && pmtu < (u32)paths->pl.pmtu) {
+			paths->pl.state = QUIC_PL_BASE;  /* Search -> Base */
+			paths->pl.probe_size = QUIC_BASE_PLPMTU;
+			paths->pl.probe_count = 0;
+
+			paths->pl.probe_high = 0;
+			paths->pl.pmtu = QUIC_BASE_PLPMTU;
+			pathmtu = QUIC_BASE_PLPMTU;
+		} else if (pmtu > (u32)paths->pl.pmtu &&
+			   pmtu < (u32)paths->pl.probe_size) {
+			paths->pl.probe_size = (u16)pmtu;
+			paths->pl.probe_count = 0;
+		}
+	} else if (paths->pl.state == QUIC_PL_COMPLETE) {
+		if (pmtu >= QUIC_BASE_PLPMTU && pmtu < (u32)paths->pl.pmtu) {
+			paths->pl.state = QUIC_PL_BASE;  /* Complete -> Base */
+			paths->pl.probe_size = QUIC_BASE_PLPMTU;
+			paths->pl.probe_count = 0;
+
+			paths->pl.probe_high = 0;
+			paths->pl.pmtu = QUIC_BASE_PLPMTU;
+			pathmtu = QUIC_BASE_PLPMTU;
+			*reset_timer = true;
+		}
+	}
+	return pathmtu;
+}
+
+/* Reset PLPMTUD state for a path.
+ *
+ * Resets all PLPMTUD-related state to its initial configuration.  Called when
+ * a new path is initialized or when recovering from errors.
+ */
+void quic_path_pl_reset(struct quic_path_group *paths)
+{
+	paths->pl.number = 0;
+	paths->pl.probe_high = 0;
+	paths->pl.probe_count = 0;
+	paths->pl.state = QUIC_PL_BASE;
+	paths->pl.pmtu = QUIC_BASE_PLPMTU;
+	paths->pl.probe_size = QUIC_BASE_PLPMTU;
+}
+
+/* Check if a packet number confirms PLPMTUD probe.
+ *
+ * Checks whether the last probe (tracked by .number) has been acknowledged.
+ * If the probe number lies within the ACK range, confirmation is successful.
+ *
+ * Return: true if probe is confirmed, false otherwise.
+ */
+bool quic_path_pl_confirm(struct quic_path_group *paths, s64 largest,
+			  s64 smallest)
+{
+	return paths->pl.number && paths->pl.number >= smallest &&
+	       paths->pl.number <= largest;
+}
+
+void quic_path_init(struct quic_path_group *paths)
+{
+	seqcount_init(&paths->path_seq);
+}
diff --git a/net/quic/path.h b/net/quic/path.h
new file mode 100644
index 000000000000..c2537cf65a7d
--- /dev/null
+++ b/net/quic/path.h
@@ -0,0 +1,191 @@
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
+#define QUIC_PATH_MIN_PMTU	1200U
+#define QUIC_PATH_MAX_PMTU	65535U
+
+#define QUIC_MIN_UDP_PAYLOAD	1200
+#define QUIC_MAX_UDP_PAYLOAD	65527
+
+#define QUIC_PATH_ENTROPY_LEN	8
+
+#define QUIC_PMTUD_RAISE_TIMER_FACTOR	30
+
+extern struct workqueue_struct	*quic_wq;
+
+/* Connection Migration State Machine:
+ *
+ * +--------+      recv non-probing, free old path    +----------+
+ * |  NONE  | <-------------------------------------- | SWAPPED  |
+ * +--------+                                         +----------+
+ *      |   ^ \                                            ^
+ *      |    \ \                                           |
+ *      |     \ \   new path detected,                     | recv
+ *      |      \ \  has another DCID,                      | Path
+ *      |       \ \ snd Path Challenge                     | Response
+ *      |        \ -------------------------------         |
+ *      |         ------------------------------- \        |
+ *      | new path detected,            Path     \ \       |
+ *      | has no other DCID,            Challenge \ \      |
+ *      | request a new DCID            failed     \ \     |
+ *      v                                           \ v    |
+ * +----------+                                       +----------+
+ * | PENDING  | ------------------------------------> | PROBING  |
+ * +----------+  recv a new DCID, snd Path Challenge  +----------+
+ */
+enum {
+	QUIC_PATH_ALT_NONE,
+	QUIC_PATH_ALT_PENDING, /* Waiting for new dest conn ID for migration */
+	QUIC_PATH_ALT_PROBING, /* Validating alternate path (PATH_CHALLENGE) */
+	QUIC_PATH_ALT_SWAPPED, /* Alternate path is now active; roles swapped */
+};
+
+struct quic_udp_sock {
+	struct work_struct work; /* Workqueue to destroy UDP tunnel socket */
+	struct hlist_node node;  /* Node in addr-based UDP socket hash table */
+	union quic_addr addr; /* Source addr of underlying UDP tunnel socket */
+	int bind_ifindex;
+	refcount_t refcnt;
+	struct sock *sk; /* Underlying UDP tunnel socket */
+};
+
+struct quic_path {
+	union quic_addr daddr; /* Destination address */
+	union quic_addr saddr; /* Source address */
+
+	/* Wrapped UDP socket for receiving QUIC */
+	struct quic_udp_sock *udp_sk;
+	/* Cached UDP tunnel socket and source addr for RCU access */
+	union quic_addr uaddr;
+	struct sock *usk;
+};
+
+struct quic_path_group {
+	/* Connection ID validation during handshake (rfc9000#section-7.3) */
+	struct quic_conn_id retry_dcid; /* Source CID from Retry packet */
+	struct quic_conn_id orig_dcid;  /* Destination CID from first Initial */
+
+	/* Path validation (rfc9000#section-8.2) */
+	u8 entropy[QUIC_PATH_ENTROPY_LEN]; /* Entropy for PATH_CHALLENGE */
+	struct quic_path path[2]; /* Active path (0) and alternate path (1) */
+	seqcount_t path_seq;      /* Protects path[0] during swap */
+	struct flowi fl;          /* Flow info from routing decisions */
+
+	/* Anti-amplification limit (rfc9000#section-8) */
+	u32 ampl_sndlen; /* Bytes sent before address is validated */
+	u32 ampl_rcvlen; /* Bytes received to lift amplification limit */
+
+	/* MTU discovery handling */
+	struct { /* PLPMTUD probing (rfc8899) */
+		s64 number; /* Packet number used for current probe */
+		u16 pmtu;   /* Confirmed path MTU */
+
+		u16 probe_size; /* Current probe packet size */
+		u16 probe_high; /* Highest failed probe size */
+		u8 probe_count; /* Retry count for current probe_size */
+		u8 state;       /* Probe state machine (rfc8899#section-5.2) */
+	} pl;
+	u32 mtu_info; /* PMTU value from received ICMP, pending apply */
+
+	u32 plpmtud_interval;   /* Time interval for the PLPMTUD probe timer */
+	u32 keepalive_interval; /* Time interval to maintain path liveness */
+
+	u8 ecn_probes;  /* ECN probe counter */
+	u8 validated:1; /* Path validated with PATH_RESPONSE */
+	u8 blocked:1;   /* Blocked by anti-amplification limit */
+	u8 version:1;   /* Version negotiation performed */
+	u8 retry:1;     /* Retry used in initial packet */
+
+	/* Connection Migration (rfc9000#section-9) */
+	u8 disable_saddr_alt:1; /* Remote disable_active_migration parameter */
+	u8 disable_daddr_alt:1; /* Local disable_active_migration parameter */
+	u8 pref_addr:1; /* Preferred address offered (rfc9000#section-18.2) */
+	u8 alt_probes;  /* Number of PATH_CHALLENGE probes sent */
+	u8 alt_state;   /* Connection migration state (see above) */
+};
+
+static inline union quic_addr *quic_path_saddr(struct quic_path_group *paths,
+					       u8 path)
+{
+	return &paths->path[path].saddr;
+}
+
+static inline void quic_path_set_saddr(struct quic_path_group *paths, u8 path,
+				       union quic_addr *addr)
+{
+	memcpy(quic_path_saddr(paths, path), addr, sizeof(*addr));
+}
+
+static inline union quic_addr *quic_path_daddr(struct quic_path_group *paths,
+					       u8 path)
+{
+	return &paths->path[path].daddr;
+}
+
+static inline void quic_path_set_daddr(struct quic_path_group *paths, u8 path,
+				       union quic_addr *addr)
+{
+	memcpy(quic_path_daddr(paths, path), addr, sizeof(*addr));
+}
+
+static inline union quic_addr *quic_path_uaddr(struct quic_path_group *paths,
+					       u8 path)
+{
+	return &paths->path[path].uaddr;
+}
+
+static inline struct sock *quic_path_usock(struct quic_path_group *paths,
+					   u8 path)
+{
+	return paths->path[path].usk;
+}
+
+static inline bool quic_path_alt_state(struct quic_path_group *paths, u8 state)
+{
+	return paths->alt_state == state;
+}
+
+static inline void quic_path_set_alt_state(struct quic_path_group *paths,
+					   u8 state)
+{
+	paths->alt_state = state;
+}
+
+/* Returns the destination Connection ID (DCID) used for identifying the
+ * connection.  Per rfc9000#section-7.3, handshake packets are considered part
+ * of the same connection if their DCID matches the one returned here.
+ */
+static inline struct quic_conn_id *
+quic_path_orig_dcid(struct quic_path_group *paths)
+{
+	return paths->retry ? &paths->retry_dcid : &paths->orig_dcid;
+}
+
+void quic_path_init(struct quic_path_group *paths);
+
+bool quic_path_detect_alt(struct quic_path_group *paths, union quic_addr *sa,
+			  union quic_addr *da, struct sock *sk);
+int quic_path_bind(struct sock *sk, struct quic_path_group *paths, u8 path);
+void quic_path_unbind(struct sock *sk, struct quic_path_group *paths, u8 path);
+void quic_path_swap(struct quic_path_group *paths);
+
+u32 quic_path_pl_recv(struct quic_path_group *paths, bool *raise_timer,
+		      bool *complete);
+u32 quic_path_pl_toobig(struct quic_path_group *paths, u32 pmtu,
+			bool *reset_timer);
+u32 quic_path_pl_send(struct quic_path_group *paths, s64 number);
+
+void quic_path_get_param(struct quic_path_group *paths,
+			 struct quic_transport_param *p);
+void quic_path_set_param(struct quic_path_group *paths,
+			 struct quic_transport_param *p);
+bool quic_path_pl_confirm(struct quic_path_group *paths,
+			  s64 largest, s64 smallest);
+void quic_path_pl_reset(struct quic_path_group *paths);
diff --git a/net/quic/protocol.c b/net/quic/protocol.c
index 15cebc2af740..589075367446 100644
--- a/net/quic/protocol.c
+++ b/net/quic/protocol.c
@@ -21,6 +21,7 @@
 static unsigned int quic_net_id __read_mostly;
 
 struct percpu_counter quic_sockets_allocated;
+struct workqueue_struct *quic_wq;
 
 DEFINE_STATIC_KEY_FALSE(quic_alpn_demux_key);
 
@@ -342,6 +343,15 @@ static __init int quic_init(void)
 	if (err)
 		goto err_hash;
 
+	/* Allocate an unbound workqueue for UDP socket destruction and backlog
+	 * packet processing.
+	 */
+	quic_wq = alloc_workqueue("quic_workqueue", WQ_UNBOUND, 0);
+	if (!quic_wq) {
+		err = -ENOMEM;
+		goto err_wq;
+	}
+
 	err = register_pernet_subsys(&quic_net_ops);
 	if (err)
 		goto err_def_ops;
@@ -359,6 +369,8 @@ static __init int quic_init(void)
 err_protosw:
 	unregister_pernet_subsys(&quic_net_ops);
 err_def_ops:
+	destroy_workqueue(quic_wq);
+err_wq:
 	quic_hash_tables_destroy();
 err_hash:
 	percpu_counter_destroy(&quic_sockets_allocated);
@@ -373,6 +385,8 @@ static __exit void quic_exit(void)
 #endif
 	quic_protosw_exit();
 	unregister_pernet_subsys(&quic_net_ops);
+	flush_workqueue(quic_wq);
+	destroy_workqueue(quic_wq);
 	quic_hash_tables_destroy();
 	percpu_counter_destroy(&quic_sockets_allocated);
 	rcu_barrier();
diff --git a/net/quic/socket.c b/net/quic/socket.c
index b59f6a70464e..1ef2f7c88735 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -51,6 +51,7 @@ static int quic_init_sock(struct sock *sk)
 
 	quic_conn_id_set_init(quic_source(sk), true);
 	quic_conn_id_set_init(quic_dest(sk), false);
+	quic_path_init(quic_paths(sk));
 
 	if (quic_stream_init(quic_streams(sk)))
 		return -ENOMEM;
@@ -60,6 +61,9 @@ static int quic_init_sock(struct sock *sk)
 
 static void quic_destroy_sock(struct sock *sk)
 {
+	quic_path_unbind(sk, quic_paths(sk), 0);
+	quic_path_unbind(sk, quic_paths(sk), 1);
+
 	quic_conn_id_set_free(quic_source(sk));
 	quic_conn_id_set_free(quic_dest(sk));
 
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 68a58f0016cc..91338601905e 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -15,6 +15,7 @@
 #include "family.h"
 #include "stream.h"
 #include "connid.h"
+#include "path.h"
 
 #include "protocol.h"
 
@@ -39,6 +40,7 @@ struct quic_sock {
 	struct quic_stream_table	streams;
 	struct quic_conn_id_set		source;
 	struct quic_conn_id_set		dest;
+	struct quic_path_group		paths;
 };
 
 struct quic6_sock {
@@ -86,6 +88,11 @@ static inline struct quic_conn_id_set *quic_dest(const struct sock *sk)
 	return &quic_sk(sk)->dest;
 }
 
+static inline struct quic_path_group *quic_paths(const struct sock *sk)
+{
+	return &quic_sk(sk)->paths;
+}
+
 static inline bool quic_is_serv(const struct sock *sk)
 {
 	return !!sk->sk_max_ack_backlog;
-- 
2.47.1

