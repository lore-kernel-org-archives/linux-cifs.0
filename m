Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792445408;
	b=iSvA7Lyh68iol8sEI46nfMf8A+0ebsE0Lg1ltNJsGEBmibPEigN89RrdlV6FyG+LRIMV
	 SYjRCMgj7s4p3F6UhXLuXlaW2xwGjTWXE/QYbDgM3HXJz0ArGchsJowKnarF07sEwUSuA
	 zDJeglxJ2ly5iRdG5tHN/g307RFY2RJNtU8RHh2yWPfbrEs8rV6zk0z+7NczbD7B9bPz8
	 eVWeRi1GTenO+PHDMo/KrDsI0F7hmRpqg8capziYXt3U7MTFyOfIpeYDFfsWAL8eSSY9x
	 eJutGt+0y1wRxH5IJVXuX8ovSF4RVOijR+/k1P8UvKhrMir5qCZziyflcAg3R//0jAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792445408;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=jhvJLaNwH68MlYlkJQoHKvHnc3YWINNTcz12b9cCjeQ=;
	b=soY6bq7F4vMAaerGYBa5hPfvd/JvQr3znuW8NaN9h2LuGcbvzF5gTtYZ9bkgbNRorjZj
	 Mt7nCFmAutKQHCxvzNG4xdKi/vzTL7Xk5dEvkFvZIccwHeAZUUUk3M+SC5i5z3vnMQ6Au
	 WhdtKpU63hTUe7tQq8VHU8qNuS8Bcptcz8VmIU5dbbIIxXEkoPI7WN6AnNKWgD+Vb6jZO
	 AJ54tWN5XT+cnfl7YRaU0a/fhbzXIHdCJl6bDpPmDGJXGyjLWFEANAIyqz7MZljNMdV8n
	 lNfHbNKIlPLxeXaM0EG2RrvYKFDQPlwTkBGuk0s7l99wCsGTDYxR5ciJbSLM7l/5AMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f3ozdA+Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19FB606A31A;
	Mon, 19 Oct 2026 21:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f3ozdA+Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8851F000C9;
	Mon, 19 Oct 2026 21:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792445407;
	bh=jhvJLaNwH68MlYlkJQoHKvHnc3YWINNTcz12b9cCjeQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=f3ozdA+YCAFbuaWoO+HDrp/Ctqm6YDIYOW0fKtOxpR/0bAunb12M5sssx3jZiFvK9
	 i9UzqGEINlOOUe0q2FfQSH4bU9w+djyt1rEPrZes5jYnsr0byaJuKQcNPBD4Tb690S
	 UdaIpt/lrceG/gZCCOBN3XyOVfesiCAbAETFQupZLeiVqk85fsfg8iTih+BWqBtUAe
	 +34mWYlBDGpCOgIG1PjgAphnrL21Y9x8nsnInNUFxSggzkRoS5ttkAyxsMnOxR0G4n
	 e/9vJo9Ts0KKmsXgZJ/sxICmHGDM71mdatWw70M0TZWaUYDfwTrWszGPPe6KG0odju
	 /SOerD4S9haew==
Subject: Re: [PATCH net-next v17 11/15] quic: add crypto key derivation and
 installation
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
Date: Mon, 19 Oct 2026 21:30:04 +0000
Message-ID: <179244540463.3135.17132817693152829356@kernel.org>
In-Reply-To: =?utf-8?q?=3C1da72318e969eb252977ccf5d8e3e506c2fa2e69=2E1792164?=
 =?utf-8?q?438=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C1da72318e969eb252977ccf5d8e3e506c2fa2e69=2E17921644?=
 =?utf-8?q?38=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
X-sashiko-severity: High
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

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] quic_init_sock() (net/quic/socket.c:58) sets sk->sk_destruct =
  quic_sock_destruct.

--

quic: add crypto key derivation and installation

This patch adds quic_crypto, which derives and installs QUIC packet
protection keys for the Initial, Handshake, 0-RTT and 1-RTT levels. It
handles key updates and stateless reset token generation. It also adds a
quic_sock_destruct() callback that frees the per-level crypto transforms
when the last socket reference goes away.

> diff --git a/net/quic/socket.c b/net/quic/socket.c
> index 12f0817c8b55f..9b1106a9f5e73 100644
> --- a/net/quic/socket.c
> +++ b/net/quic/socket.c
> @@ -40,10 +40,22 @@ static void quic_write_space(struct sock *sk)
>  	rcu_read_unlock();
>  }
>  
> +static void quic_sock_destruct(struct sock *sk)
> +{
> +	u8 i;
> +
> +	/* Deferred crypto free for async encryption/decryption. */
> +	for (i = 0; i < QUIC_CRYPTO_MAX; i++)
> +		quic_crypto_free(quic_crypto(sk, i));

[Severity: High]
Is it safe to free the crypto transforms from sk_destruct, given the
context it can run in?

sk_destruct runs in whatever context drops the last socket reference.
Later in this series, several of those contexts are softirq:

  quic_packet_rcv() (UDP encap receive) ends with sock_put(sk)
  quic_timer_timeout() ends with sock_put(sk)
  quic_packet_rcv_err() drops its reference with sock_put()
  quic_packet_xmit() takes a reference per TX skb through
    skb_set_owner_sk_safe(); sock_efree() releases it on TX completion,
    usually in NAPI

If the user has already closed the socket, any of these can end up as:

  sock_put()
    __sk_destruct()
      quic_sock_destruct()
        quic_crypto_free()
          crypto_free_aead()
            crypto_destroy_tfm()
              alg->cra_exit()

The AEADs come from crypto_alloc_aead(cipher->aead, 0, 0), so an async
hardware implementation can be selected. hisi_sec2, for example, registers
both "gcm(aes)" and "ccm(aes)". Its sec_aead_exit() calls
dma_free_coherent(). Behind an IOMMU that leads to __iommu_dma_free() and
then vunmap(), which begins with:

mm/vmalloc.c:vunmap() {
	...
	BUG_ON(in_interrupt());
	...
}

Can this hit that BUG when a QUIC socket is destroyed from softirq?
Listen sockets already hold AEAD transforms in this series, via
quic_packet_get_alpn()->quic_crypto_initial_keys_install().

macsec hit the same crash and fixed it in commit 6624bba469a3 ("macsec:
use rcu_work to defer RX SA crypto cleanup out of softirq").

The note about in-flight async requests holding a socket reference covers
the lifetime of the transforms. It does not cover the context in which
the free runs.

Would it work to defer the tfm teardown to process context, for example
with a work item or rcu_work queued from quic_sock_destruct()?

> +
> +	quic_sk_destruct(sk);
> +}
> +
>  static int quic_init_sock(struct sock *sk)
>  {
>  	u8 i;
>  
> +	sk->sk_destruct = quic_sock_destruct;
>  	sk->sk_write_space = quic_write_space;
>  	sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1792164438.git.lucien.xin%40gmail.com
