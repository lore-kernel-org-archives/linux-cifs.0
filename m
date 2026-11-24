Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795483278;
	b=kiqooIfRqFOZl7tzdNs7HPWvOgk9Y5pymU3Tq0flAjt6xwP9yzAYJyjp+DYj5jAlIV87
	 pFUezZTv9rEDkdk5Zm3rTND4prRiKuWqMzsaunxaSitWCQ3mZdy3ilGZUtQgoNcs2rp79
	 0ko5ZFRB2UBB0iNF0FcSkK6iB/xnpQ02xM+Wv1ajN06pvHzg0dJKNvBt5s1hMFBA8PITj
	 fNXu92ozkgbETLC9kSUOcAm/Id+5IEDrVhjW2DRPulRV4QXOTI8dXQB8r7yF4KmUbCW6F
	 kfSPvY4J/Z5mf21W2gFOxPDi5H6S2H4vPT2Ju8MKGZw/k9C/3N7Galsi4IWuQKOAuaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795483278;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=uC/2xSaREGiqiN/AwaPVUZl3cnTKg5jFQ7GQqjkIciw=;
	b=uCqlHy1KCj4hr856zWDyT8nJgDa3nHHQUYWf1veQEJpZ1DJB1wm/zSROxjPHVIeQxooG
	 tT3dlP5OW6wMjcz5fpgqLCfbeKFJwaL829qsyOeA6IcC/cRj8h79HXzC2HCjIm6dkfMbu
	 nHr4sU+FMbDLMkbW1BdgSBaIVmGDNb5oS5QEwb/tEPf+F3py5jkx4ohlLWjiyGmbfLNDb
	 8N0zxFqvdhyCZCQ5m0+IL0/tbUgPKs2WTzH64g61fDQaq0AF3Gm5fCyhjzzhlE3Xi9l7U
	 NxrZsq6FykWBpdDx3/OUz1FyKE4L0C+jWusa5otiBwslJuPrTy0mtev6KbRiICmyM2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N+m0yKLs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B102606A321;
	Tue, 24 Nov 2026 01:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N+m0yKLs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7961F000CA;
	Tue, 24 Nov 2026 01:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795483278;
	bh=uC/2xSaREGiqiN/AwaPVUZl3cnTKg5jFQ7GQqjkIciw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=N+m0yKLsnU0OLwkVxMQtD0SG0p3W9A8WqlkcT9h3bmZFC3QJTqGi8GdlZkSjG3dUc
	 7C9wtz/H558UXhT0SmfBP/tlu9dRLa09butmRdLwcUkFb03qdij8jlLr3qDDjn7ZC+
	 ELuMS48kHB5Nd7rBuJdA5vkR2/eijk30j/7EzRAu5/edYleqOb4ftPlwv90vR/twmk
	 rxndjnhAIprDIRWDhKwOUSdUYpv6XT//6okg2OJDYigKV/yKypIA1zj6whaoIuBvZy
	 vEMX6I05Ttw4RBQry91o24aaIz00JKGmyvJws8ejFxqKh09ZO2p5XoHKaMjWaEsu5x
	 DGvqoW7t2nFdg==
Subject: Re: [PATCH net-next v19 08/15] quic: add path management
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net,
 kuba@kernel.org, edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org,
 metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com,
 dreibh@simula.no, jamie.bainbridge@gmail.com, linux-cifs@vger.kernel.org,
 pc@manguebit.org, linkinjeon@kernel.org, tom@talpey.com,
 kernel-tls-handshake@lists.linux.dev, cel@kernel.org, jlayton@kernel.org,
 steved@redhat.com, hare@suse.de, aahringo@redhat.com, dhowells@redhat.com,
 matttbe@kernel.org, mail@johnericson.me, xiyou.wangcong@gmail.com,
 alibuda@linux.alibaba.com, jbaron@akamai.com, illiliti@protonmail.com,
 sd@queasysnail.net, marcelo.leitner@gmail.com, daniel@haxx.se,
 andrew.gospodarek@broadcom.com, mef@scarletmail.rutgers.edu, paul@jakma.org,
 kuniyu@google.com
Date: Tue, 24 Nov 2026 01:21:15 +0000
Message-ID: <179548327574.3135.6574572531783833085@kernel.org>
In-Reply-To: <6a6d9da5d2d7ae5dfd1a6cdcd409326023fc7c2c.1795393691.git.lucien.xin@gmail.com>
References: <6a6d9da5d2d7ae5dfd1a6cdcd409326023fc7c2c.1795393691.git.lucien.xin@gmail.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In net/quic/path.c, quic_path_bind() decides whether a path
  may take a port by looking at the credentials of the task that happens…
- [Medium] quic_path_bind() binds a real UDP port (explicit or ephemeral)
  on behalf of the caller via quic_udp_sock_create() ->…
- [Low] The comment on quic_path_detect_alt() in net/quic/path.c does not
  describe what the function does.
- [Low] Two PLPMTUD field comments in struct quic_path_group
  (net/quic/path.h) do not match how path.c uses the fields.

--

quic: add path management

This patch adds struct quic_path_group to manage the active and alternate
QUIC paths. Each path is backed by a refcounted UDP tunnel socket wrapper
(quic_udp_sock) kept in a global hash table, with helpers to bind, unbind,
swap and detect alternate paths for connection migration. It also adds a
basic PLPMTUD state machine that is driven by probe sends, ACKs and ICMP
feedback.

> diff --git a/net/quic/path.c b/net/quic/path.c
> new file mode 100644
> index 0000000000000..946f5e44b6350
> --- /dev/null
> +++ b/net/quic/path.c
> @@ -0,0 +1,608 @@

[ ... ]

> +static struct quic_udp_sock *quic_udp_sock_create(struct sock *sk,
> +						  union quic_addr *a)
> +{

[ ... ]

> +	us = kmalloc_obj(*us);
> +	if (!us)
> +		return ERR_PTR(-ENOMEM);
> +
> +	quic_udp_conf_init(sk, &udp_conf, a);
> +	err = udp_sock_create(net, &udp_conf, &sock);

[Severity: Medium]
Can this let a confined, unprivileged process bind UDP ports that its LSM
policy does not allow?

udp_sock_create() goes through udp_sock_create4()/udp_sock_create6(), which
call sock_create_kern() and then kernel_bind():

net/ipv4/udp_tunnel_core.c:udp_sock_create4() {
    ...
	err = sock_create_kern(net, AF_INET, SOCK_DGRAM, 0, &sock);
    ...
	err = kernel_bind(sock, (struct sockaddr_unsized *)&udp_addr,
			  sizeof(udp_addr));
    ...
}

kernel_bind() in net/socket.c calls sock->ops->bind() directly. That means
security_socket_bind() never runs for the UDP socket that actually holds
the port.

The socket is also created with kern=1, so it gets a kernel label instead
of the caller's. The user socket create hooks (LSM and cgroup-BPF inet sock
create) are skipped as well.

The only remaining bind check is on the QUIC socket. SELinux classes an
IPPROTO_QUIC socket as rawip_socket, and sel_netport_sid() with
sk_protocol == IPPROTO_QUIC does not match any udp port labels.

As a result, the port bound here is not covered by udp_socket
name_bind/node_bind rules with per-port labels, or by Smack/AppArmor network
rules. Per-packet LSM checks and netfilter socket-owner matching would also
see a kernel socket rather than the user.

Other UDP tunnel users either require CAP_NET_ADMIN (vxlan, geneve, fou,
tipc) or take the port from an admin sysctl (SCTP over UDP). Here an
unprivileged user picks the port. The CAP_NET_BIND_SERVICE and uid checks in
quic_path_bind() do not mediate the UDP bind itself.

quic_path_bind() has no callers yet in this series. quic_bind() and
quic_connect() arrive in the next patchset, so the user-reachable path
can't be confirmed here.

Does the UDP tunnel bind need some form of LSM mediation before the port is
bound on the caller's behalf?

[ ... ]

> +/* Binds a QUIC path to a local port and sets up a UDP socket. */
> +int quic_path_bind(struct sock *sk, struct quic_path_group *paths, u8 path)
> +{

[ ... ]

> +	port = ntohs(a->v4.sin_port);
> +	if (port) {
> +		if (inet_port_requires_bind_service(net, port) &&
> +		    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
> +			return -EACCES;
> +		head = quic_udp_sock_head(net, port);
> +		mutex_lock(&head->lock);
> +		us = quic_udp_sock_lookup(sk, a, port);
> +		if (us) {
> +			if (!uid_eq(current_fsuid(), sk_uid(us->sk))) {
> +				mutex_unlock(&head->lock);
> +				return -EADDRINUSE;
> +			}

[Severity: Medium]
Is it intended that both checks here use the credentials of the task that
calls quic_path_bind(), rather than the QUIC socket's own credentials?

The ns_capable(CAP_NET_BIND_SERVICE) check runs before the lookup. So it
also applies when an existing tunnel socket is only being reused and
refcounted.

The reuse branch then compares current_fsuid() with sk_uid(us->sk). That
value is the fsuid of whoever first created the kernel tunnel socket.

For comparison, the SO_REUSEPORT model in inet_csk_bind_conflict() and
udp_lib_get_port() compares the new socket's sk_uid with the existing
socket's sk_uid.

Consider a server that binds port 443 as root and then drops privileges. A
later explicit-port quic_path_bind() for 443, for example for an accepted
child socket or a migration path, would get -EACCES (capability gone) or
-EADDRINUSE (fsuid changed). Is that the expected result?

Likewise, a QUIC socket passed to another process via SCM_RIGHTS would be
judged by the receiver's credentials. A kernel thread caller would pass
both checks no matter who owns the socket.

The commit message and the code comments don't describe this model. The
only mention is the v15 changelog line. quic_path_bind() has no callers in
this series, so whether a reuse bind can follow a privilege drop depends on
the next patchset.

Would comparing sk_uid(sk) against sk_uid(us->sk), or at least documenting
the intended model, make sense here?

[ ... ]

> +/* Detects and records a potential alternate path.
> + *
> + * If the new source or destination address differs from the active path, and
> + * alternate path detection is not disabled, the function updates the alternate
> + * path slot (path[1]) with the new addresses.
> + *
> + * This is typically called on packet receive to detect new possible network
> + * paths (e.g., NAT rebinding, mobility).
> + *
> + * Returns true if the alternate path (path[1]) matches (sa, da), regardless
> + * of whether it was newly detected or already present. Returns false if the
> + * addresses don't match the alternate path.
> + */
> +bool quic_path_detect_alt(struct quic_path_group *paths, union quic_addr *sa,
> +			  union quic_addr *da, struct sock *sk)
> +{

[ ... ]

> +	if (!quic_path_saddr(paths, 1)->v4.sin_port)
> +		quic_path_set_saddr(paths, 1, sa);
> +
> +	if (!quic_cmp_sk_addr(sk, quic_path_saddr(paths, 1), sa))
> +		return false;
> +
> +	if (!quic_path_daddr(paths, 1)->v4.sin_port)
> +		quic_path_set_daddr(paths, 1, da);
> +
> +	return quic_cmp_sk_addr(sk, quic_path_daddr(paths, 1), da);
> +}

[Severity: Low]
This isn't a bug, but the comment doesn't match the code. It says path[1]
is updated with the new addresses, but path[1] is never overwritten. Only a
saddr or daddr whose port is 0 gets filled in.

The function can also modify path[1] and still return false. Suppose
path[1].saddr is empty but path[1].daddr already holds a different peer
address. Then path[1].saddr is set to sa, the daddr comparison fails, and
the function returns false.

That leaves path[1] with the new source paired with the old destination,
which matches neither candidate. The "Returns false if the addresses don't
match the alternate path" text implies the false case has no side effects.

Within this patch, path[1].daddr is only set by quic_path_detect_alt()
itself (saddr first) or by quic_path_swap(). quic_path_unbind() clears both
fields together, so this half-written state may not be reachable yet.

Could the comment describe the fill-only-empty-fields behaviour and the
possible partial update on a false return?

[ ... ]

> diff --git a/net/quic/path.h b/net/quic/path.h
> new file mode 100644
> index 0000000000000..c2537cf65a7d4
> --- /dev/null
> +++ b/net/quic/path.h
> @@ -0,0 +1,191 @@

[ ... ]

> +	/* MTU discovery handling */
> +	struct { /* PLPMTUD probing (rfc8899) */
> +		s64 number; /* Packet number used for current probe */
> +		u16 pmtu;   /* Confirmed path MTU */
> +
> +		u16 probe_size; /* Current probe packet size */
> +		u16 probe_high; /* Highest failed probe size */
> +		u8 probe_count; /* Retry count for current probe_size */

[Severity: Low]
This isn't a bug, but these two field comments don't match how path.c uses
the fields.

probe_high is also set when no probe has failed. In SEARCH state,
quic_path_pl_recv() does this once probe_size reaches the 9000 byte cap:

	paths->pl.probe_high = QUIC_MAX_PLPMTU;

so the field works as an upper search bound, not only as a failed size.

probe_count is incremented on every quic_path_pl_send() call, including the
first probe of a new size:

	paths->pl.probe_count++;

so the probe_count < QUIC_MAX_PROBES check counts total probes sent for the
current size, not retries.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1795393690.git.lucien.xin%40gmail.com
