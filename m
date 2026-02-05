Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC6B3ACF1A;
	Thu,  5 Feb 2026 11:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770292532; cv=none; b=MaAPhV7BndJIYYG4oQuJuzdTqwOt98D8V23o1nd0ZFxF3ZTNgpEJlpPZVWAGWHghG87Q3cxpyNECgDuGQkWiylhO5/J7McEtvhZJLmQpSsWB+n5HFaPQFbK9k/StybCgn6GlCmSHUsBUkVg1n3bW7EhlMWYk5SFWKGfXRGR1N4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770292532; c=relaxed/simple;
	bh=eMBP8cLJYQcn7U8uiQZoqQPZDyjRAeNP+d8V03xmqlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiZeLuinaebwJgPx5DFi12D9Ef8VQ1Kp2aWxAGSZnF8h9LdqHZgVzRdev6bcW1JljlOqb4qA+qIkQEalB+XRdZ6NJXhNPPbIYjYPAeBonPuELBvkJRdaSWftp87ynn0Zjclk2xgJv7Bnto+uKD8IcN95WBlLwaKnQd3r/Ja3Zqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M8kXQYPL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M8kXQYPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5ADC4CEF7;
	Thu,  5 Feb 2026 11:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770292531;
	bh=eMBP8cLJYQcn7U8uiQZoqQPZDyjRAeNP+d8V03xmqlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8kXQYPLi7aCDTBrjZPv1egf12WrNAiD1lVfQSYqOCToZ9GtT5ra/Z0fEmUrtYjhy
	 hUrBmsEyPxatqkPKpY1J/vcF98ixkJeEy/ehZHi60QlvUp1NinN5Jy8v12sjHnE5Gs
	 y5JY4fwAT9yI+zwIuC9igl+HOBXTXz7QKY7FWX2N4zgZW7Khq7JVZkoAPEskmMNInX
	 t2Bw1yEOZ3/xasoPMQnnIdKJaZQ8NDPCe2HcxVTodRGTnU7XjaCG2dEs9iRHMNPrqB
	 8QOpPQoOZJcaRzrQabcuBD7ErG5U1udsF2gDfdSh8Ns0DSN52khpSwqN/oa8wuiNAR
	 gnX8jC8BiuGdw==
From: Simon Horman <horms@kernel.org>
To: lucien.xin@gmail.com
Cc: Simon Horman <horms@kernel.org>,
	steved@redhat.com,
	marcelo.leitner@gmail.com,
	aahringo@redhat.com,
	alibuda@linux.alibaba.com,
	jbaron@akamai.com,
	hare@suse.de,
	kuba@kernel.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	daniel@haxx.se,
	quic@lists.linux.dev,
	jlayton@kernel.org,
	tfanelli@redhat.com,
	dhowells@redhat.com,
	linkinjeon@kernel.org,
	hepengtao@xiaomi.com,
	pc@manguebit.com,
	kernel-tls-handshake@lists.linux.dev,
	illiliti@protonmail.com,
	xiyou.wangcong@gmail.com,
	andrew.gospodarek@broadcom.com,
	mail@johnericson.me,
	edumazet@google.com,
	pabeni@redhat.com,
	matttbe@kernel.org,
	netdev@vger.kernel.org,
	smfrench@gmail.com,
	metze@samba.org,
	mbuhl@openbsd.org,
	chuck.lever@oracle.com,
	dreibh@simula.no,
	davem@davemloft.net,
	sd@queasysnail.net
Subject: Re: [net-next,v9,06/15] quic: add stream management
Date: Thu,  5 Feb 2026 11:55:18 +0000
Message-ID: <20260205115518.2195328-1-horms@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <d3a376cf555e7740330a50d83e6201c9084bff01.1770042461.git.lucien.xin@gmail.com>
References: <d3a376cf555e7740330a50d83e6201c9084bff01.1770042461.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.

For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
---
quic: add stream management

This patch introduces stream management infrastructure for the QUIC
protocol, including a hash table for tracking active streams, functions
for acquiring and releasing streams, and logic for detecting stream
ID limits.

> diff --git a/net/quic/socket.c b/net/quic/socket.c
> index b86989080184..d6f25669c693 100644
> --- a/net/quic/socket.c
> +++ b/net/quic/socket.c
> @@ -41,6 +41,9 @@ static int quic_init_sock(struct sock *sk)
>  	sk->sk_write_space = quic_write_space;
>  	sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
>
> +	if (quic_stream_init(quic_streams(sk)))
> +		return -ENOMEM;

If quic_stream_init() fails here, the function returns before calling
sk_sockets_allocated_inc() and sock_prot_inuse_add() below. However,
when initialization fails, inet_create() calls sk_common_release() which
invokes quic_destroy_sock():

quic_init_sock()
    quic_stream_init() fails
    return -ENOMEM
        -> sk_common_release()
            -> quic_destroy_sock()
                -> sk_sockets_allocated_dec()  // underflow
                -> sock_prot_inuse_add(..., -1)  // underflow

Can this cause counter underflow since the increments never executed but
the decrements in quic_destroy_sock() are unconditional?

> +
>  	WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(sysctl_quic_wmem[1]));
>  	WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(sysctl_quic_rmem[1]));
>
> @@ -52,6 +55,8 @@ static int quic_init_sock(struct sock *sk)
>
>  static void quic_destroy_sock(struct sock *sk)
>  {
> +	quic_stream_free(quic_streams(sk));
> +
>  	quic_data_free(quic_ticket(sk));

[ ... ]
