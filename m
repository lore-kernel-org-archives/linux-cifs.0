Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF4F44F576;
	Tue, 15 Sep 2026 19:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501861; cv=none; b=bXo1zcfaAIrVa5wV7tSCY0BVoOkqrVXnb1y7z/EyOhjOaphlqGKUfC2IqRCJ8Z6vp3d6+/QS5goROXPwJRsw/W3qtQf1WodZ02i1J+YbHDrDSlEFXXHkzWsgcqG6rleQdUKMhx1t/2QLRbG1+cmsCfYO/1hFJa+rHU5KpDgPZeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501861; c=relaxed/simple;
	bh=TalMPwoQpgeVG1vCT2Tj0jslcu3NwKfqy0Yf4c9fzD0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sFCceK1ZxBv+WQE1kXHnqEXRQDXASeucoOnrHolarBMNt+vWdlEwvE/Ze9ofCrS0ZTOOiVAh9GT75zVVVN4rf2NSa3FMvuoEqJC7QgETw6AQflXkJZlgYAHoLtmuauA02EMO6f87EIz1wW0WpMVpm71wbFKCFLWL7zTb8RaWsZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hDC+oAEv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hDC+oAEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5BC81F000FF;
	Tue, 15 Sep 2026 19:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789501859;
	bh=nf4h7RDqFkHDmx8Mk7CO+YgG0/34neidLlQirNvNDb8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=hDC+oAEvanONx8z25scRZinvo0rXIQ3pxb+N0PF3Zee3zXQ4mYpDPSZEQthvflFik
	 JOy9FQXdnuJRYnLE2TdOz+5UWIGbhxwD/OdmuTlpfwHJtLLbPt5ebtdVzipczLp9Cf
	 5VVTg8/FIvRdvLMDvbpUd0Ov6zV/uQ9KkekNuscScA4mHMP7Vakugy6nbYIbwSWroC
	 2wrlpYl5yynAgFZGLlE8OTR3zSq+q8LUoxXixoNxLpG9/wdpOFSkc07iQaayRiZ/kt
	 m1CcKQHU6LRJPOFWFDca0sbx8/PzajU+824do+7Vhg5tb4tzcm4znmzC5+ujXySo4X
	 aNofLXgpMrxQA==
Subject: Re: [PATCH net-next v15 13/15] quic: add timer management
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
 mef@scarletmail.rutgers.edu, paul@jakma.org
Date: Tue, 15 Sep 2026 19:50:56 +0000
Message-ID: <178950185646.22033.3124819474267826359@kernel.org>
In-Reply-To: =?utf-8?q?=3C02bbb6b0c5e4aaf96227693a93ca401c36f25653=2E1789393?=
 =?utf-8?q?775=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C02bbb6b0c5e4aaf96227693a93ca401c36f25653=2E17893937?=
 =?utf-8?q?75=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 0 · Low: 2

- [Low] The new timer abstraction discards compile-time type and index
  checking: quic_timer() in net/quic/socket.h returns void * (all…
- [Low] quic_timer_stop() (net/quic/timer.c:119) cancels the timer object
  only; it never clears the matching QUIC_F_*_DEFERRED bit in…

--

quic: add timer management

This adds a quic_timer abstraction covering the loss, delayed ACK, path
validation, PMTU probing and pacing timers, with common start/reset/stop
helpers.  Expiry while the socket is owned by a user is deferred through
sk_tsq_flags and dispatched from quic_release_cb().

A couple of questions below.

> diff --git a/net/quic/socket.c b/net/quic/socket.c
> index 8d3da3f03347b..2632f024029c0 100644
> --- a/net/quic/socket.c
> +++ b/net/quic/socket.c

[ ... ]

> @@ -214,6 +218,35 @@ static int quic_getsockopt(struct sock *sk, int level, int optname,
>  
>  static void quic_release_cb(struct sock *sk)
>  {
> +	/* Similar to tcp_release_cb(). */
> +	unsigned long nflags, flags = smp_load_acquire(&sk->sk_tsq_flags);
> +
> +	do {
> +		if (!(flags & QUIC_DEFERRED_ALL))
> +			return;
> +		nflags = flags & ~QUIC_DEFERRED_ALL;
> +	} while (!try_cmpxchg(&sk->sk_tsq_flags, &flags, nflags));
> +
> +	if (flags & QUIC_F_LOSS_DEFERRED) {
> +		quic_timer_loss_handler(sk);
> +		__sock_put(sk);
> +	}

[ ... ]

> diff --git a/net/quic/socket.h b/net/quic/socket.h
> index d7811391cc8b5..c5654fdc06b59 100644
> --- a/net/quic/socket.h
> +++ b/net/quic/socket.h

[ ... ]

> @@ -119,6 +147,11 @@ static inline struct quic_crypto *quic_crypto(const struct sock *sk, u8 level)
>  	return &quic_sk(sk)->crypto[level];
>  }
>  
> +static inline void *quic_timer(const struct sock *sk, u8 type)
> +{
> +	return (void *)&quic_sk(sk)->timers[type];
> +}

[Severity: Low]
This isn't a bug today, but is the void * return here intentional?  All
the sibling accessors in this header return typed pointers
(quic_cong(), quic_crypto(), quic_pnspace(), quic_paths()), so a wrong
type would still compile:

	if (timer_delete(quic_timer(sk, type)))

With struct quic_timer being a union of struct timer_list and struct
hrtimer, passing QUIC_TIMER_PACE to quic_timer_reset()/quic_timer_stop()
would apply mod_timer()/timer_delete() to the hrtimer member, and
quic_timer_reset() has to catch that at runtime instead:

	/* Note that type must never be QUIC_TIMER_PACE for this helper. */
	if (WARN_ON_ONCE(type == QUIC_TIMER_PACE))
		return;

quic_timer_start() and quic_timer_stop() make the same timer_list versus
hrtimer choice from type with no equivalent guard.  There is also no
type < QUIC_TIMER_MAX taming here, and timers[] is the last member of
struct quic_sock.

Every caller in the series passes a compile-time enum constant
(quic_timer_init()/quic_timer_free(), and QUIC_TIMER_PMTU from
net/quic/packet.c), so nothing is reachable now.  Would returning
struct quic_timer * (or keeping the pace hrtimer in its own field) let
the compiler enforce this while the interface is still new?

> diff --git a/net/quic/timer.c b/net/quic/timer.c
> new file mode 100644
> index 0000000000000..0dd6d6580bbd9
> --- /dev/null
> +++ b/net/quic/timer.c
> @@ -0,0 +1,154 @@

[ ... ]

> +static void quic_timer_timeout(struct quic_timer *t, int type, int defer_bit,
> +			       void (*handler)(struct sock *sk))
> +{
> +	struct quic_sock *qs = container_of(t, struct quic_sock, timers[type]);
> +	struct sock *sk = &qs->inet.sk;
> +
> +	bh_lock_sock(sk);
> +	if (sock_owned_by_user(sk)) {
> +		if (!test_and_set_bit(defer_bit, &sk->sk_tsq_flags))
> +			sock_hold(sk);
> +		goto out;
> +	}
> +
> +	handler(sk);
> +out:
> +	bh_unlock_sock(sk);
> +	sock_put(sk);
> +}

The type argument here duplicates information the timer pointer already
carries, so container_of(t, struct quic_sock, timers[type]) can disagree
with the slot the timer actually lives in and silently produce a wrong
struct sock *.  Could the socket be derived from the timer pointer alone?

[ ... ]

> +void quic_timer_stop(struct sock *sk, u8 type)
> +{
> +	if (type == QUIC_TIMER_PACE) {
> +		if (hrtimer_try_to_cancel(quic_timer(sk, type)) == 1)
> +			sock_put(sk);
> +		return;
> +	}
> +	if (timer_delete(quic_timer(sk, type)))
> +		sock_put(sk);
> +}

[Severity: Low]
Can a stopped timer still get its handler called?  quic_timer_stop()
cancels the timer object but leaves the matching QUIC_F_*_DEFERRED bit
set, and quic_release_cb() is the only place that clears those bits and
it dispatches each one unconditionally:

quic_timer_timeout() (timer already fired, socket owned by user)
	if (!test_and_set_bit(defer_bit, &sk->sk_tsq_flags))
		sock_hold(sk);

then quic_timer_stop() runs and only does:
	if (timer_delete(quic_timer(sk, type)))
		sock_put(sk);

and later quic_release_cb() still does:
	if (flags & QUIC_F_LOSS_DEFERRED) {
		quic_timer_loss_handler(sk);
		__sock_put(sk);
	}

The same applies to quic_timer_free() from quic_destroy_sock().
tcp_write_timer_handler() re-checks icsk->icsk_pending before acting;
here the handlers do no such re-validation.

The reference accounting is balanced and all five handlers are empty in
this patch, and the only quic_timer_stop() calls in the series are the
five teardown calls inside quic_timer_free(), so nothing misbehaves yet.
Once the handlers have real bodies, should quic_timer_stop() also clear
the deferred bit (and drop the reference it holds), or should each
handler re-validate its timer state?

> diff --git a/net/quic/timer.h b/net/quic/timer.h
> new file mode 100644
> index 0000000000000..4f63660376027
> --- /dev/null
> +++ b/net/quic/timer.h
> @@ -0,0 +1,45 @@

[ ... ]

> +struct quic_timer {
> +	union {
> +		struct timer_list t;
> +		struct hrtimer hr;
> +	};
> +};

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1789393775.git.lucien.xin%40gmail.com
