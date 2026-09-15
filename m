Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7537B4519BA;
	Tue, 15 Sep 2026 19:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501840; cv=none; b=KlE7iFoDEFQmF8MLSJgEoBmUepwg2zWQs1Y7KV8kWoCfMQV/M/eSlfsa8w1ChzR0hM29NCnEgh7D/QuT7iLgbaIy51WJ8758DpOfTvq305faXIJOhcV9IHVqXyNgH7OhetWI7bP532LKnKl+aZ6j9xlrG+JkMtONICua+94yxJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501840; c=relaxed/simple;
	bh=TgxzQLrRd9uzzcrn+pfr+KgIsHItqf1+KpmhQP4o0UI=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FQNklLBxKhdx8ZS9ep1rUzfwOWhJSI2rqLot2UlW/p/0Z98VSWA5cfsngbKmVkDO8pU1rjjwIEuXXGUeH4qjflCmSTQla/ULOnHRXTTnRO3zp+oB+pk0aA8qOtZwei2dWDlrabTDIoxnfvsQ5EGOWIjS1rkrsd55QXuEtOgvm2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CeA6RnPP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CeA6RnPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6031F00893;
	Tue, 15 Sep 2026 19:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789501839;
	bh=ESvxtaK+PgBhk7HTCZwC8JnF+9fk+V+R1qQ0jSEaNIA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=CeA6RnPPg8ncrKEfPqlPiryN+mzssVfZCg/ekrrAr3iRind3RwRHCAlrte/60Q04A
	 XdDousqop57WxuRITnhKbe6nUvpKrZvlf/Tj1BZmSmeiSz/qN1zWoGTW+e8jnNSLPO
	 deqVnFh1yLuaefYVR2rRALKkCeXnv3598UNNnkWeytrKg42LMmACTAXOQn2S/sOKVM
	 6AiExYCWxEfMxvV7CWwNcFWR/GM+h+pf9hepvUKQ78cU8ZTz5gk/DvZhkQLNrrJw57
	 b+kI4zeaqJhj/ezDhyJZUHpjdGkBlAsqRCZTX8pqEOgx+UfNJm/uxKJcXpNQjso4fj
	 iVx4IU4vnXEbQ==
Subject: Re: [PATCH net-next v15 05/15] quic: provide quic.h header files for
 kernel and userspace
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
Date: Tue, 15 Sep 2026 19:50:36 +0000
Message-ID: <178950183690.22033.5066425057612255956@kernel.org>
In-Reply-To: =?utf-8?q?=3C77d4a44c4825bb55aa1cc94f1cfa2682ad2da20d=2E1789393?=
 =?utf-8?q?775=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C77d4a44c4825bb55aa1cc94f1cfa2682ad2da20d=2E17893937?=
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 0 · Low: 1

- [Low] Kernel-doc contradicts the exported interface contract: the new
  kernel-doc blocks added in net/quic/socket.c for quic_do_setsockopt()…

--

quic: provide quic.h header files for kernel and userspace

This patch adds include/uapi/linux/quic.h with the QUIC socket API
definitions (cmsgs, socket options, events) and adds include/linux/quic.h
so in-kernel consumers can reach quic_do_setsockopt()/quic_do_getsockopt()
now that kernel_get/setsockopt() is gone. The two functions lose their
static qualifier and are exported with EXPORT_SYMBOL_GPL().

Link: https://datatracker.ietf.org/doc/html/draft-lxin-quic-socket-apis

> diff --git a/include/linux/quic.h b/include/linux/quic.h
> new file mode 100644
> index 0000000000000..51c099e9547f5
> --- /dev/null
> +++ b/include/linux/quic.h
> @@ -0,0 +1,38 @@

[ ... ]

> +#include <linux/sockptr.h>
> +#include <uapi/linux/quic.h>
> +
> +struct sock;
> +
> +#if IS_REACHABLE(CONFIG_IP_QUIC)
> +int quic_do_setsockopt(struct sock *sk, int optname, sockptr_t optval,
> +		       unsigned int optlen);
> +int quic_do_getsockopt(struct sock *sk, int optname, sockptr_t optval,
> +		       sockptr_t optlen);

[ ... ]

> diff --git a/net/quic/socket.c b/net/quic/socket.c
> index 1c97d95c61b2c..0e0a13235fa42 100644
> --- a/net/quic/socket.c
> +++ b/net/quic/socket.c
> @@ -111,11 +111,25 @@ static void quic_close(struct sock *sk, long timeout)
>  	sk_common_release(sk);
>  }
>  
> -static int quic_do_setsockopt(struct sock *sk, int optname, sockptr_t optval,
> -			      unsigned int optlen)
> +/**
> + * quic_do_setsockopt - set a QUIC socket option
> + * @sk: socket to configure
> + * @optname: option name (QUIC-level)
> + * @optval: user buffer containing the option value
                ^^^^^^^^^^^

[Severity: Low]
This isn't a functional bug, but should the kernel-doc for optval here say
"user buffer"?  The parameter is a sockptr_t, and the whole point of the new
include/linux/quic.h plus the EXPORT_SYMBOL_GPL() below is to let in-kernel
consumers call this with a kernel buffer:

include/linux/sockptr.h:
    /*
     * Support for "universal" pointers that can point to either kernel or
     * userspace memory.
     */
    ...
    static inline sockptr_t KERNEL_SOCKPTR(void *p)

Would something like "buffer (user or kernel, see sockptr_t) containing the
option value" describe the contract more accurately?

> + * @optlen: size of the option value
> + *
> + * Sets a QUIC socket option on a given socket.
> + *
> + * Return:
> + * - On success, 0 is returned.
> + * - On error, a negative error value is returned.
> + */
> +int quic_do_setsockopt(struct sock *sk, int optname, sockptr_t optval,
> +		       unsigned int optlen)
>  {
>  	return -EOPNOTSUPP;
>  }
> +EXPORT_SYMBOL_GPL(quic_do_setsockopt);
>  
>  static int quic_setsockopt(struct sock *sk, int level, int optname,
>  			   sockptr_t optval, unsigned int optlen)
> @@ -127,11 +141,25 @@ static int quic_setsockopt(struct sock *sk, int level, int optname,
>  	return quic_do_setsockopt(sk, optname, optval, optlen);
>  }
>  
> -static int quic_do_getsockopt(struct sock *sk, int optname, sockptr_t optval,
> -			      sockptr_t optlen)
> +/**
> + * quic_do_getsockopt - get a QUIC socket option
> + * @sk: socket to query
> + * @optname: option name (QUIC-level)
> + * @optval: user buffer to receive the option value
> + * @optlen: pointer to buffer size; updated with actual size on return
                ^^^^^^^^^^^^^^^^^^^^

[Severity: Low]
Same question for quic_do_getsockopt(): optval is described as a "user
buffer" and optlen as a "pointer to buffer size", but both are sockptr_t
rather than plain or __user pointers.

The distinction is visible right below in quic_getsockopt(), which has to
wrap its own pointers:

    return quic_do_getsockopt(sk, optname, USER_SOCKPTR(optval),
                              USER_SOCKPTR(optlen));

while a kernel consumer would pass KERNEL_SOCKPTR().  Should the optlen
description mention it is a sockptr_t holding the buffer size, so callers
don't read this as a plain int pointer?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1789393775.git.lucien.xin%40gmail.com
