Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66E55476DD
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 15:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789573432; cv=pass; b=YWZWjqjQ25DeUG5mCuSCB5KRUnBq72XEHfBUuLoqGwZ5+y+IW5spQatGLvCOzsg43efK6jEdG3DolNeDHaGei/UO65+VG4NO2MRBjWXf1RFtwn2HUC685ckjNfmhiTOwZpV/dSxKPldE4qBUi4JpOZDOzMAtFG+7CUgcYNnAaxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789573432; c=relaxed/simple;
	bh=5r9oITh6Ke0h0LdwQAODmCkNekYxLU9BUgIqqL0e/CQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iQ61qeL4hZTpe06/CeUXdjSWBnGVDD0tASzELIX7VhOMDPJvmotGix+zx6dOrY1sFK470GH+QWncsQs837QZesDBhUKM4kqXXnb3C3fT9OPrz0u4mCUQLSikxwRbhmhv8BuVLXCEB86fOoTNqIL/oRmBkjEiZSzAaPpOz9ekn/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HAR5is7y; arc=pass smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HAR5is7y"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85469b2e1d5so950679b3a.1
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 08:43:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789573429; cv=none;
        d=google.com; s=arc-20260327;
        b=O4+o+36g4uWgFZQBWBFY0iddHo2dL4J9zmu62On90wisgT6nPsGMQEj5zmkcIGBdX3
         p20rr/FtTzm0iTjyGnOKQT+nSfp25sv6qGP4FagMv+YaZTnz6jtQFIM7pzRkB1LMvjzS
         SZN7Qv4xTODOKpT/rCN5wsYQ5PYqHOFMOE3U0mCxLnNXONDILn62sicBGPLgyb04WPmg
         Jag4qJmrc8UMyHLCdEZM/topCvMTXUJvLp6P4vVlDXQcAe5kO3YKuKgparfXI8X9s8uC
         +a3RpdYaH6OBHssiBuB/439rmlOPZPTtDssPlpSXFb+dQLjxpk+eIz3xr0mBl2Dn9uK9
         Ja1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ODqiZXRBdCHmyesWjPny1yNGa+YI4ZP+iScqkVqOaCM=;
        fh=w0F6iHwPIaVwPrhRYIBOMo2t6Zw3/mKbzAFNanUji5Q=;
        b=jphC1RRJJTYNvpFzf7DuFwLkSoJh8/iojI+ctoHU0xZoQkUGqvAtCUj8qGWVDzH6Ds
         LP6rtVc5tn8whmwzAByToiU72CZvP+t4iBG02Rk1shGqoxVg3GJIBIndHTAd8EjAG6Rl
         0aFs4kaG51oCqeTz4kD4nOI78WywYRtyX7tgaPkoHZc42NsEB0HSMRDIpE2LzVGmC8oo
         Wkc1aIpsWMmjK4Rtw1U46IAqlNJogPIo5QOGwOCq+ULKxqW6uvPJsQrY4ctyGbWwjobD
         W1Nwv8DLuQulPrV8Qk3+GhWD1GCgFjYwmHLI6BkMSOJgMBjOnAULtVMYEXUwYUQPZURz
         092A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789573429; x=1790178229; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ODqiZXRBdCHmyesWjPny1yNGa+YI4ZP+iScqkVqOaCM=;
        b=HAR5is7yOUURS5rRWXWE/wvsJcYzvA/PYQefMQRrSg2MYylTiFMSJ7s/dl8rExo6D4
         QCQHOoOQ390nXTZKxaMUSfE8dplM8j9yzuC1lWatomtRZ0OEtMMLgcE2RVX/kOnZg/qc
         jesgvl4eKbjnn8c4UVh9PgrihA81yIdP8XHGRUUJRzH3GPc99l433ByuYNarus15onhQ
         +FIujV28QjrkA86ndnTQUAezvmK4/NSoaW9SHGX6gxOdZ+DZji2iIpmT+Td1dbYakIDZ
         MsS8yW71AplQP+40apNwR23dt8McJfm/v4XaDDhN6LLWnTJ5SYh1OBtu8Zuk/pNbzpEU
         FubQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789573429; x=1790178229;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ODqiZXRBdCHmyesWjPny1yNGa+YI4ZP+iScqkVqOaCM=;
        b=09anlMUjR98UJyzhbq9MVe3knmDZ9AWInfavoTncGBrLSQdFIMIkWLVud+rD80ELG2
         oP/Qv/Q2eHAY/W19xcDSiSsWzMHvp3OxAigJ6Dlxw/xnypM0kUjIIi+Y0AmYmU9LYKCY
         fGRPzjAamN9UyszmGsObjFc3yfPL5wz5175r7F9LtaJQKX4bW104Mhnjy3yaYxUUTayE
         oT5aA/HwTTnNjQv1EN1ukS93IIZUid2Xiox4xpNKZ/LhK4xv6DuQxlS2W8Q5P1259zwo
         +jfkUoGTtN9PGmCFzXRhDku7cAUhKNJS+POiuoM0LxzJ+8Do8tDgqhTnVCN1XhUj3YKP
         sAGw==
X-Forwarded-Encrypted: i=1; AKwUvBz1LG/WUC9+Jn/UASXkvSVk8LqaLmzrGTeM7d36cVLUqWHDjaSbbmRTvJRbG0P1kQVCrXpGXz/wFMT7@vger.kernel.org
X-Gm-Message-State: AFuF++lvZaOITWZoa11oJB5ULxyR1r/fOF02Gp3f2BQ1W3NNV9lT4sN4
	MXjzleZ4k1dZxYj1rRMiku3f9O5tGPw6ZquP/33DRt4cULkFnOM6j3ul0P2z6wfXEaE29nIit1l
	zzImWMqz2qM5G65mTMg5TmRGm1y1KTfI=
X-Gm-Gg: AYBFou1jPpBbkC+PgymYc0xadRZ21q+H8L/eIz17voBWwhUY/MJc5RdH2yMQMeJwuKX
	RP2DM7F6kSYOTQmRowRaHhtY2Qduw3xjs2MXgNecl+ZhiKyisvolXFucag1on92nODwLAioKDIf
	vO+FCvkY4HSVMTZcrg67BiwvqitIy5NTCt4bFvyQQ7pE+KddyoSXPopSlUUTLZDZcs79tuMw7sz
	hOy0UECDmvvgQszXltpV9Su6gpW0lBwiiSoC3W1u92h3SXG6GH6BX6Z9mUkJN01lT6LsqS37W1Y
	Svp0z18+ToXkb/jvNoDPnVMy0lyxVK1SlmsF8Lmf1N2+78Li0cuGFki4q4r6joWgT7NmtUoCaLi
	nxhNPGF+YeLB3dldiMf3WpsDSCebZGHVfl7evjMPVwa2UE2g1xg9hZdEO
X-Received: by 2002:a05:6a00:4406:b0:86a:141e:2a8d with SMTP id
 d2e1a72fcca58-872379b1f8cmr7321250b3a.11.1789573429057; Wed, 16 Sep 2026
 08:43:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <375ee7fe827d9df248a27a8072c84a7c167fc50a.1789393775.git.lucien.xin@gmail.com>
 <178950184430.22033.8793987707688483661@kernel.org>
In-Reply-To: <178950184430.22033.8793987707688483661@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 16 Sep 2026 11:43:37 -0400
X-Gm-Features: AcwNN1XSc3BIya9VHdn-b90bW5THPSIgMzBCtVU9z3ZhvPnGIT-zThpbhq1QirI
Message-ID: <CADvbK_dwf3bMTs_TnOsqJQMAnCCvnr1M8x8DyCtesaL2Wy5ceg@mail.gmail.com>
Subject: Re: [PATCH net-next v15 08/15] quic: add path management
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org, 
	metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com, 
	dreibh@simula.no, linux-cifs@vger.kernel.org, pc@manguebit.org, 
	linkinjeon@kernel.org, tom@talpey.com, kernel-tls-handshake@lists.linux.dev, 
	chuck.lever@oracle.com, jlayton@kernel.org, steved@redhat.com, hare@suse.de, 
	aahringo@redhat.com, dhowells@redhat.com, matttbe@kernel.org, 
	mail@johnericson.me, xiyou.wangcong@gmail.com, alibuda@linux.alibaba.com, 
	jbaron@akamai.com, illiliti@protonmail.com, sd@queasysnail.net, 
	marcelo.leitner@gmail.com, daniel@haxx.se, andrew.gospodarek@broadcom.com, 
	mef@scarletmail.rutgers.edu, paul@jakma.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 3:50=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 7 potential
> issue(s) to consider:
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 2 =C2=B7 Low: 5
>
> - [Medium] quic_path_swap() opens a write section on a bare seqcount_t
>   (paths->path_seq) with only local_bh_disable() for context protection.
> - [Medium] In the explicit-port branch of quic_path_bind(), an existing
>   UDP tunnel socket is reused whenever quic_cmp_sk_addr() matches.
> - [Low] Commit message claims PLPMTUD/ICMP feedback is integrated, but at
>   this commit quic_udp_err() is a stub returning 0 and no quic_path_pl_*=
=E2=80=A6
> - [Low] quic_path_pl_send()'s kernel-doc ("Called immediately after
>   sending a probe packet in QUIC Path MTU Discovery") and the matching=E2=
=80=A6
> - [Low] The new file net/quic/path.c carries the header comment
>   "Initialization/cleanup for QUIC protocol support." =E2=80=94 verbatim=
=E2=80=A6
> - [Low] quic_path_pl_recv()'s documented contract ("Return: New PMTU to
>   apply if search completes, or 0 if no change") disagrees with the=E2=80=
=A6
> - [Low] The three PLPMTUD pr_debug() statements in quic_path_pl_send(),
>   quic_path_pl_recv() and quic_path_pl_toobig() print the label "dst:=E2=
=80=A6
>
> --
>
> quic: add path management
>
> This patch adds struct quic_path / struct quic_path_group plus the global
> hash table of UDP tunnel sockets, with helpers to bind, unbind, swap and
> detect alternate paths for connection migration.  It also adds the RFC 88=
99
> PLPMTUD state machine helpers (quic_path_pl_send/recv/toobig/reset/confir=
m)
> and a quic_wq workqueue used to release UDP tunnel sockets.
>
> A few questions below.
>
> > diff --git a/net/quic/path.c b/net/quic/path.c
> > new file mode 100644
> > index 0000000000000..a9e02fc22e609
> > --- /dev/null
> > +++ b/net/quic/path.c
>
> [ ... ]
>
> > +             head =3D quic_udp_sock_head(net, port);
> > +             mutex_lock(&head->lock);
> > +             us =3D quic_udp_sock_lookup(sk, a, port);
> > +             if (us) {
> > +                     if (!uid_eq(sk->sk_uid, us->sk->sk_uid)) {
> > +                             mutex_unlock(&head->lock);
> > +                             return -EADDRINUSE;
> > +                     }
> > +                     /* Allow reuse of an existing UDP tunnel socket.
> > +                      * However, if it is in the middle of asynchronou=
s
> > +                      * teardown (via workqueue), it is temporarily un=
usable.
> > +                      * Return -EAGAIN (not -EADDRINUSE) to signal the=
 caller
> > +                      * to retry soon.
> > +                      */
> > +                     if (!quic_udp_sock_get(us)) {
> > +                             mutex_unlock(&head->lock);
> > +                             return -EAGAIN;
> > +                     }
> > +             } else {
> > +                     us =3D quic_udp_sock_create(sk, a);
> > +                     if (IS_ERR(us)) {
> > +                             mutex_unlock(&head->lock);
> > +                             return PTR_ERR(us);
> > +                     }
> > +             }
> > +             mutex_unlock(&head->lock);
> > +             quic_path_set_udp_sk(&paths->path[path], us);
> > +             return 0;
> > +     }
>
> [Severity: Medium]
> Can this reuse branch bind a path to a source address the host does not o=
wn?
>
> quic_udp_sock_lookup() calls quic_cmp_sk_addr(us->sk, &us->addr, a), so t=
he
> existing tunnel socket address is the first argument, and
> net/quic/family.c:quic_v4_cmp_sk_addr() has:
>
>         /* Match only if socket is also ANY-bound. */
>         if (addr->v4.sin_addr.s_addr =3D=3D htonl(INADDR_ANY))
>                 return a->v4.sin_addr.s_addr =3D=3D htonl(INADDR_ANY);
>         if (a->v4.sin_addr.s_addr =3D=3D htonl(INADDR_ANY))
>                 return true;
>
> That second test means an ANY-bound tunnel socket matches a request for a=
n
> arbitrary specific address (quic_v6_cmp_sk_addr() has the same rule for
> IPv6).
>
> On that branch quic_path_bind() returns 0 without ever going through
> quic_udp_sock_create() -> udp_sock_create() -> kernel_bind(), so
> __inet_bind()'s address ownership check (inet_addr_type() must be
> RTN_LOCAL/MULTICAST/BROADCAST unless IP_FREEBIND, ip_nonlocal_bind or
> CAP_NET_ADMIN) never runs, and paths->path[path].saddr keeps the
> unvalidated address:
>
>   process A: bind 0.0.0.0:P     -> quic_udp_sock_create(), tunnel sk is A=
NY
>   process B (same uid): bind <non-local addr>:P
>                                -> quic_udp_sock_lookup() matches the ANY =
sk
>                                -> quic_udp_sock_get(), return 0
>
> The same request would be rejected if no wildcard tunnel socket existed f=
or
> port P, since then udp_sock_create() would do the bind and validate the
> address.  Should the reuse branch validate the requested source address
> before accepting it?
>
False:

The source address to bind is validated by quic_get_user_addr() when the
quic_bind() socket API is added in the next patchset, including the
FREEBIND and sysctl_ip_nonlocal_bind checks.

> [ ... ]
>
> > +void quic_path_swap(struct quic_path_group *paths)
> > +{
> > +     struct quic_path path =3D paths->path[0];
> > +
> > +     paths->alt_probes =3D 0;
> > +     paths->alt_state =3D QUIC_PATH_ALT_SWAPPED;
> > +
> > +     /* Protect path[0] modifications with seqcount for RCU readers in
> > +      * quic_sock_lookup(). The seqcount allows readers to detect torn=
 reads
> > +      * during the non-atomic structure assignment.
> > +      */
> > +     local_bh_disable();
> > +     write_seqcount_begin(&paths->path_seq);
>
> [Severity: Medium]
> Is local_bh_disable() enough to open a write section on a bare seqcount_t=
?
>
> path_seq is declared as a plain counter in net/quic/path.h:
>
>         seqcount_t path_seq;      /* Protects path[0] during swap */
>
> so there is no associated write serialization lock, and
> write_seqcount_begin() expands to seqprop_assert(s), which for seqcount_t=
 is
> lockdep_assert_preemption_disabled().  On PREEMPT_RT
> __local_bh_disable_ip() only takes softirq_ctrl.lock and does
> migrate_disable(); it does not touch preempt_count():
>
>         kernel/softirq.c (CONFIG_PREEMPT_RT)
>         void __local_bh_disable_ip(unsigned long ip, unsigned int cnt)
>         {
>                 ...
>                 local_lock(&softirq_ctrl.lock);
>                 ...
>         }
>
> Does that make write_seqcount_begin() warn on every path swap with lockde=
p
> enabled on PREEMPT_RT?
>
> The other half of the same point: the odd-sequence window becomes
> preemptible, and the reader added later in the series busy-waits on it:
>
>         do {
>                 seq =3D read_seqcount_begin(&paths->path_seq);
>                 ...
>         } while (read_seqcount_retry(&paths->path_seq, seq));
>
> Would preempt_disable_nested() around the write section, or declaring the
> counter as a seqcount_LOCKNAME_t associated with the socket lock, be a
> better fit here?
>
True:

I missed that local_bh_disable() does not disable preemption on PREEMPT_RT.
I'll add preempt_disable_nested(), which disables preemption on PREEMPT_RT.

Thanks.
