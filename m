Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794349783;
	b=qLd8ja9VsMhgQy/3EcqEWXQ0MEba3uSq9piXLzw97wBKYfT71ZIm0JINzBXsoqj0JhUX
	 71Jun/6OkJL9YUnnYuCv/1TWN13COmEGBtpiJPk0DpTes8ObHFVN+NTi7zHRwNVuuTI4b
	 Rpo4Ts+3G4kaSAxa37ye8k6u3hEr+PJRScOl4np/tivsXeycQtKlZyofdjb3MWXDgfURP
	 emq28tO5zWPnVqhz4waYjfap05G4VkNH6gN08ezbiba2i0PortPuDhbVu+mysdF+9MTkX
	 +4FggLo9Jk3/tDlX8qdgXCRszssI7ebx+9una0Yx00aTIHINRv2jqfAV+DteWlltUPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794349783;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=k4ry2FuKm6/wn7zPNOWjR0bvBTiFyxSL17iQ8UC47ho=;
	b=TNKbm4kX56WQmdytdWMA+JP6hTPFBpG9K0WpElaPWZZrGSc7DWV+Zg8HslE8QkQXXW1a
	 yqnRNB9SCbIsDzdSycZj5tDSL2huOxSCqihCDP7pp8VnfHxmO3HDdZKiXHOGhql2NXtgq
	 vjpqdGuBBxYSqDkNaSHXY3UCz7HxH/n/mTvSbDGoZYrwW/kU8cVp0oImkXeqNrNmjlUaS
	 Jw2wimJDLHBeRJd7X8mccIZPm3wwbKiXURmWcfBl4o58D0b4+zS+jFy/HhNgxqbCTOBZH
	 T4ujz1A4uIspX3NhXnk0P0m58KD+zJWxRVRxjP/TYqu2T1FxzyoHcFfdbbHWJXVXtmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="H//nUfTT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFCB606A320;
	Tue, 10 Nov 2026 22:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H//nUfTT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C461F008A4;
	Tue, 10 Nov 2026 22:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794349782;
	bh=k4ry2FuKm6/wn7zPNOWjR0bvBTiFyxSL17iQ8UC47ho=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=H//nUfTT3XeX3t9DwE+A4CWvNomW24yOHa6FTkkvKVtsa/peQfm6PclxIk6Jguaem
	 mZNpmlJJ3IqlIglJviJ2qW5XjBYByTpmZGCRAIX388ZhB+oWWOkl3PoTOsXc2DMmJI
	 NafuWLvrb9RyY58CF3TKh4726hmAYhmGQ+I4lQJrzTmiAyq+TfZinZE766gzv1d/AW
	 MOm9NMNAnKvZ/Tm1t0NHeDrO5KolAfhoEdC2LKYIIcqXtws3t1l44UZKtPYIikKLip
	 uR+4uHX3VFejym88zuvfxPWUXlAsLIbBtkr5Q2ZYc5QZdQu1UanaHnmDbV9KkmyPEI
	 90rawtZjiTZ+w==
Subject: Re: [PATCH net-next v18 08/15] quic: add path management
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com,
 dreibh@simula.no, linux-cifs@vger.kernel.org, pc@manguebit.org,
 linkinjeon@kernel.org, tom@talpey.com, kernel-tls-handshake@lists.linux.dev,
 cel@kernel.org, jlayton@kernel.org, steved@redhat.com, hare@suse.de,
 aahringo@redhat.com, dhowells@redhat.com, matttbe@kernel.org,
 mail@johnericson.me, xiyou.wangcong@gmail.com, alibuda@linux.alibaba.com,
 jbaron@akamai.com, illiliti@protonmail.com, sd@queasysnail.net,
 marcelo.leitner@gmail.com, daniel@haxx.se, andrew.gospodarek@broadcom.com,
 mef@scarletmail.rutgers.edu, paul@jakma.org, kuniyu@google.com
Date: Tue, 10 Nov 2026 22:29:40 +0000
Message-ID: <179434978039.994134.3389995581310140385@kernel.org>
In-Reply-To: <a9a2d4c0a8fc6b0d9e8abe804aac0b25d2459532.1794241656.git.lucien.xin@gmail.com>
References: <a9a2d4c0a8fc6b0d9e8abe804aac0b25d2459532.1794241656.git.lucien.xin@gmail.com>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] quic_udp_sock_create() in net/quic/path.c (line 100) always
  takes an active netns reference with get_net_track(net,…

--

quic: add path management

This patch adds struct quic_path_group to manage the active and alternate
QUIC paths. Each path is bound to a UDP tunnel socket, which is wrapped in
a refcounted struct quic_udp_sock and stored in a global hash table. The
patch also adds connection migration helpers and basic PLPMTUD state
handling.

> diff --git a/net/quic/path.c b/net/quic/path.c
> new file mode 100644
> index 0000000000000..e24968376f6b1
> --- /dev/null
> +++ b/net/quic/path.c
> @@ -0,0 +1,596 @@

[ ... ]

> +static void quic_udp_sock_put_work(struct work_struct *work)
> +{

[ ... ]

> +	head = quic_udp_sock_head(sock_net(sk), ntohs(us->addr.v4.sin_port));
> +	mutex_lock(&head->lock);
> +	__hlist_del(&us->node);
> +	mutex_unlock(&head->lock);
> +
> +	put_net_track(sock_net(sk), &us->ns_tracker);
> +	sock_put(sk);
> +	kfree(us);
> +}
> +
> +static struct quic_udp_sock *quic_udp_sock_create(struct sock *sk,
> +						  union quic_addr *a)
> +{

[ ... ]

> +	refcount_set(&us->refcnt, 1);
> +	us->sk = sock->sk;
> +	memcpy(&us->addr, a, sizeof(*a));
> +	us->bind_ifindex = udp_conf.bind_ifindex;
> +	get_net_track(net, &us->ns_tracker, GFP_KERNEL);

[Severity: Medium]
If the QUIC socket doing the bind is a kernel socket, can this active
netns reference keep the namespace alive forever?

quic_udp_sock_create() calls get_net_track() for every quic_udp_sock. The
only matching put_net_track() is in quic_udp_sock_put_work(). That work
runs only after the last path using the tunnel is unbound, which happens
through quic_destroy_sock()->quic_path_unbind() when the QUIC socket is
closed.

Kernel sockets are deliberately kept from holding an active netns
reference. sk_alloc() does:

	sk->sk_net_refcnt = kern ? 0 : 1;
	if (likely(sk->sk_net_refcnt)) {
		get_net_track(net, &sk->ns_tracker, priority);
		sock_inuse_add(net, 1);
	} else {
		net_passive_inc(net);
		...

The UDP tunnel socket created by udp_sock_create() follows that rule, but
the reference held by quic_udp_sock does not.

Consider an in-kernel user that creates a QUIC socket with
sock_create_kern() in a non-init netns. It then closes that socket from
its pernet ->exit handler, which is the usual pattern for netns-scoped
kernel sockets:

  quic_path_bind()->quic_udp_sock_create()
    get_net_track()            /* active netns ref taken */

  netns teardown:
    active netns count never drops to zero
      cleanup_net() and pernet ->exit never run
        kernel QUIC socket is never closed
          quic_udp_sock_put_work() never runs
            put_net_track() never runs

In that case, wouldn't the namespace and everything it owns be leaked?

No in-tree code creates IPPROTO_QUIC kernel sockets yet, either at this
commit or at the end of the series. So this depends on a future
in-kernel user. The code is still the same at the end of the series.

For user sockets, the extra active reference adds nothing while the
socket is alive, because the socket already holds one. Would a passive
reference (net_passive_inc()/net_passive_dec()) be enough to keep struct
net valid for sock_net() and quic_udp_sock_head() in the deferred work?
Another option would be to follow the owning socket's sk_net_refcnt
semantics.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1794241654.git.lucien.xin%40gmail.com
