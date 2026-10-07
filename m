Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3BA25C818;
	Wed,  7 Oct 2026 01:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791335117; cv=none; b=c7bY/9Q4Ur+7wNFzXeHopxmDCz3dEiEVnWaFTN/Yu1yEKdZRftCYUKLrVwzCd5+fz26vHe84Lw9cRo98uq2+DMVgsxocN1cXVMyuwr7T2YzOaIi6PXTRZWtP/o9Cyjy3zZHoQkB1a/wDjCqKWGSQ8a7JgOxUujdjhz0T79PuGvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791335117; c=relaxed/simple;
	bh=GEj2uqxWXg9y7EjIuWf6LZ1lxKJ+cfupamt+NlUpCnA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KTP4D6tKHoCswPr6W6KhLFbknEkvY29VdKmj5CZrXT6V6siEbnc71+xzJUwVX+MKG3BBbXg+zuJ7l9/cHG3l1nQz6jYdXbxevY63/I8Ty8YcaZwDI9XUDiFpYRSSdh3Afjt4YavpdjlSjsgBdRpBHXs+iELaNkbCq+OV62wOGL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O+dV5muG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O+dV5muG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B481F0089C;
	Wed,  7 Oct 2026 01:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791335115;
	bh=lCiqEIDIZ1IbSXLniaLKZxRPGDyBQmgMYrWGTRFx7X0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=O+dV5muG0k0IS2Oq94y/6Jy6PKbr7TXv7cRfBk9mBdfJn0c2/Wpgic8yjZ+s2mFWW
	 n8A8cfpej9ifTmtsyxfp1t/xEHkJXh3hmcsIU2vdqnYDWEoPMHOpXCP6vDWozKmrxq
	 35uqjL83d2mORS1nWzOqhLu8nCuq9TGgZccdNJv/l5PCj8Sk8Ip7Dh2yZ7UJGU2evX
	 xQPmSKUEzDHpo+AJQudcbcGkPLY/sPPkyI3qcSo4Rmy5nrAMU2szcTQlYqiw7PJ1EK
	 Zc9qBEa0TQ2JBDeiLTDtFg8n2fWZ/Iz6azUJykoTeBv70buP4ILKlDqcUr/SbDC+yB
	 rSJeC6Kn64Vxg==
Subject: Re: [PATCH net-next v16 08/15] quic: add path management
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
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
 mef@scarletmail.rutgers.edu, paul@jakma.org, kuniyu@google.com
Date: Wed, 07 Oct 2026 01:05:13 +0000
Message-ID: <179133511349.434549.8476083447465312043@kernel.org>
In-Reply-To: =?utf-8?q?=3Cab05ff56b186e6aa6fcef9ad292b79e7ab8d5020=2E1791227?=
 =?utf-8?q?050=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3Cab05ff56b186e6aa6fcef9ad292b79e7ab8d5020=2E17912270?=
 =?utf-8?q?50=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 9 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 4 · Low: 4

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Pending UDP tunnel socket releases are not tied to netns
  teardown, so they can write to freed per-netns memory.
- [Medium] quic_udp_sock_create() does not keep an explicitly disabled
  IPV6_V6ONLY setting.
- [Medium] A dual-stack QUIC socket can reuse an existing IPv6-only UDP
  tunnel socket.
- [Medium] quic_udp_sock_create() ignores IP_FREEBIND (and
  IP_TRANSPARENT) set on the QUIC socket.
- [Medium] quic_path_bind() uses two different ideas of 'owner' when
  deciding who may share a tunnel.
- [Low] quic_path_bind() reads sk->sk_uid and us->sk->sk_uid with plain
  loads, bypassing the sk_uid() accessor in include/net/sock.h:2162-2166.
- [Low] The commit message contradicts the code it adds.
- [Low] The quic_path_detect_alt() comment says it 'Returns true if a new
  alternate path was detected and updated' and that it 'updates the…
- [Low] quic_path_pl_toobig() prints its u32 pmtu argument with "ptb:
  %d".

--

quic: add path management

This patch adds struct quic_path_group and struct quic_path to manage up
to two paths per connection. Each path is backed by a UDP tunnel socket
that can be shared, is wrapped in quic_udp_sock and is kept in a global
hash table. It adds bind, unbind, swap and alternate path detection
helpers, plus basic PLPMTUD state handling for probes, acks and ICMP
Packet Too Big messages.

> - quic_path_pl_send(): state transition and pmtu update after sending a
>   probe packet.

[Severity: Low]
Is "after sending" accurate here? The kernel-doc for quic_path_pl_send()
added in this same patch says:

 * Called right before sending a probe packet in QUIC Path MTU Discovery.

The v16 changelog says the "after" wording was inaccurate, but only the
code comment was updated.

The probe_count / QUIC_MAX_PROBES accounting assumes the call comes before
transmission. A caller that follows the commit text would be off by one.

Several lasting changes are described only in the changelog below the
"---" line:

  - the module-wide quic_wq workqueue and its init/exit handling
  - the path_seq seqcount write side in quic_path_swap(), plus
    quic_path_init()
  - the port sharing policy in quic_path_bind(): same uid reuse,
    -EADDRINUSE for a different uid, -EAGAIN during teardown, and
    CAP_NET_BIND_SERVICE for privileged ports

Could these go into the commit message itself?

> - quic_path_detect_alt(): Determine if a packet is using an alternative
>   path, used for connection migration.

quic_path_detect_alt() also writes the candidate addresses into path[1].
This description doesn't say so.

> diff --git a/net/quic/path.c b/net/quic/path.c
> new file mode 100644
> index 0000000000000..b6bea7d2f2673
> --- /dev/null
> +++ b/net/quic/path.c
> @@ -0,0 +1,593 @@

[ ... ]

> +static struct quic_udp_sock *quic_udp_sock_create(struct sock *sk,
> +						  union quic_addr *a)
> +{

[ ... ]

> +	quic_udp_conf_init(sk, &udp_conf, a);
> +	err = udp_sock_create(net, &udp_conf, &sock);
> +	if (err) {
> +		pr_debug("%s: failed to create udp sock\n", __func__);
> +		kfree(us);
> +		return ERR_PTR(err);
> +	}

[Severity: Medium]
Is an IPV6_V6ONLY of 0 on the QUIC socket kept when the tunnel is created?

quic_v6_udp_conf_init() passes the QUIC socket's setting:

    conf->ipv6_v6only = ipv6_only_sock(sk);

udp_sock_create6() only acts on it when the flag is true:

    if (cfg->ipv6_v6only) {
        err = ip6_sock_set_v6only(sock->sk);

Otherwise the new kernel socket keeps the default it got in
inet6_create():

    sk->sk_ipv6only = READ_ONCE(net->ipv6.sysctl.bindv6only);

Take a netns with net.ipv6.bindv6only=1 and a QUIC socket that sets
IPV6_V6ONLY to 0 and binds [::]:P. It gets an IPv6-only UDP tunnel.
quic_path_bind() succeeds, but IPv4 packets would never reach the
socket.

This stays latent until quic_path_bind() gets a caller.

[Severity: Medium]
Can IP_FREEBIND or IP_TRANSPARENT on the QUIC socket have any effect
here? udp_port_cfg has no freebind field, and quic_v4_udp_conf_init()
copies only:

    conf->family = AF_INET;
    conf->local_ip.s_addr = a->v4.sin_addr.s_addr;
    conf->local_udp_port = a->v4.sin_port;
    conf->bind_ifindex = sk->sk_bound_dev_if;

udp_sock_create4() and udp_sock_create6() bind the new kernel socket
right away. __inet_bind() then checks inet_can_nonlocal_bind() against
that new socket's own flags:

    return READ_ONCE(net->ipv4.sysctl_ip_nonlocal_bind) ||
        test_bit(INET_FLAGS_FREEBIND, &inet->inet_flags) ||
        test_bit(INET_FLAGS_TRANSPARENT, &inet->inet_flags);

Assume ip_nonlocal_bind=0. A QUIC socket sets IP_FREEBIND through
quic_setsockopt()->quic_common_setsockopt()->ip_setsockopt() and binds a
non-local address. Whenever a new tunnel has to be created,
quic_path_bind() would then return -EADDRNOTAVAIL.

The patch notes say quic_get_user_addr() will accept such an address
based on that flag. That check and this bind would disagree.

[ ... ]

> +static void quic_udp_sock_put(struct quic_udp_sock *us)
> +{
> +	/* The UDP socket may be freed in atomic RX context during connection
> +	 * migration; defer the release to a workqueue.
> +	 */
> +	if (refcount_dec_and_test(&us->refcnt))
> +		queue_work(quic_wq, &us->work);
> +}

[Severity: High]
Can this deferred release run after the netns pernet exit methods have
freed per-netns state?

quic_destroy_sock()
  quic_path_unbind()
    quic_path_set_udp_sk(path, NULL)
      quic_udp_sock_put()
        queue_work(quic_wq, &us->work)

The QUIC user socket is then freed and drops its active netns
reference. If that was the last one, cleanup_net() runs the pernet exit
methods.

quic_net_exit() doesn't flush quic_wq or wait for this namespace's
pending releases. Nothing orders quic_wq against the netns cleanup
workqueue.

So quic_udp_sock_put_work() could run after sock_inuse_exit_net() has
done:

    free_percpu(net->core.prot_inuse);

If udp_child_hash_entries is set, it could also run after
udp_pernet_table_free() has freed net->ipv4.udp_table. The work then
reaches:

quic_udp_sock_put_work()
  udp_tunnel_sock_release()
    sock_release()
      inet_release()
        udp_lib_close()
          sk_common_release()
            udp_lib_unhash()
              sock_prot_inuse_add(net, sk->sk_prot, -1);

That writes to the freed percpu area and takes hslot spinlocks in the
per-netns udp_table.

This is a separate issue from the lifetime of struct net. The passive
reference held by kernel sockets keeps the struct net allocation alive.
It doesn't stop the pernet exit methods from freeing these per-netns
pieces.

Other kernel UDP tunnel users such as vxlan, geneve, tipc and rxrpc
release their kernel sockets from pernet exit. Later in the series,
quic_net_ops still has only .init and .exit, and quic_net_exit() is
unchanged.

[ ... ]

> +	hlist_for_each_entry(us, &head->head, node) {
> +		if (net != sock_net(us->sk))
> +			continue;
> +		if (a) {
> +			if (quic_cmp_sk_addr(us->sk, &us->addr, a) &&
> +			    us->bind_ifindex == quic_get_dev_if(sk, a))
> +				return us;

[Severity: Medium]
Could a dual-stack QUIC socket end up sharing an IPv6-only tunnel here?
When both addresses are AF_INET6 wildcards, quic_v6_cmp_sk_addr()
returns:

    if (ipv6_addr_any(&addr->v6.sin6_addr))
        return ipv6_addr_any(&a->v6.sin6_addr);

ipv6_only_sock() is only checked when the address families differ.

Suppose QUIC socket A with IPV6_V6ONLY=1 creates a tunnel on [::]:P.
QUIC socket B, same uid, with IPV6_V6ONLY=0, then binds [::]:P. B reuses
A's v6-only tunnel and quic_path_bind() returns 0.

IPv4 lookups skip ipv6_only_sock() sockets, so B would never receive
IPv4 traffic. The same bind on plain UDP sockets would have failed with
EADDRINUSE.

[ ... ]

> +		us = quic_udp_sock_lookup(sk, a, port);
> +		if (us) {
> +			if (!uid_eq(sk->sk_uid, us->sk->sk_uid)) {
> +				mutex_unlock(&head->lock);
> +				return -EADDRINUSE;
> +			}

[Severity: Medium]
Are these two uids measuring the same owner? The tunnel's sk_uid comes
from the kernel socket created in quic_udp_sock_create():

udp_sock_create()->sock_create_kern()
  sock_alloc():
      inode->i_uid = current_fsuid();
  sock_init_data():
      sk_uid taken from SOCK_INODE(sock)->i_uid

So the tunnel owner is the fsuid of the task calling bind() at that
time. sk->sk_uid on the QUIC socket comes from its own inode at socket()
time and is updated by fchown().

The two differ in any of these cases:

  - the QUIC fd was passed over SCM_RIGHTS
  - the QUIC fd was fchown()ed
  - the task changed fsuid between socket() and bind()

Then a socket owned by the original owner gets a spurious -EADDRINUSE.
Sockets whose sk_uid matches the first binder's fsuid are allowed to
share.

[Severity: Low]
This isn't a bug, but should these reads use the sk_uid() accessor? It
is documented as paired with the WRITE_ONCE() in sockfs_setattr(), and
quic_v4_flow_route() and quic_v6_flow_route() already use it. Without
it, KCSAN would report a concurrent fchown() on the QUIC fd:

    if (!uid_eq(sk_uid(sk), sk_uid(us->sk))) {

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
> + * Returns true if a new alternate path was detected and updated, false
> + * otherwise.
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
Does the comment match the return value? path[1].saddr and daddr are
only written while their sin_port is still 0.

If path[1] is already filled in and simply matches (sa, da), this
returns true even though nothing new was detected or updated.

[ ... ]

> +u32 quic_path_pl_toobig(struct quic_path_group *paths, u32 pmtu,
> +			bool *reset_timer)
> +{
> +	u32 pathmtu = 0;
> +
> +	pr_debug("%s: paths: %p, state: %d, pmtu: %d, size: %d, ptb: %d\n",
> +		 __func__, paths, paths->pl.state, paths->pl.pmtu,
> +		 paths->pl.probe_size, pmtu);

[Severity: Low]
This isn't a bug, but pmtu is a u32 taken from the remote ICMP or ICMPv6
Packet Too Big message. Should this be "ptb: %u"? Values above INT_MAX
would print as negative numbers.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791227050.git.lucien.xin%40gmail.com
