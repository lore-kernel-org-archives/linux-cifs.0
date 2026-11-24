Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795483290;
	b=J7CDZg0Nao//7xWCPL2744sBaSrArGdOBvsXPBNfgwy8RwH2IcqUuikq2s81zwdDMiYQ
	 /3gTC5gtu3VppOQxms0Axd3UGsgC6bbhAVnxjZsR74+rEB31mYR3nEGs2EUdUGBauv+4J
	 1qH/glrNeqY5g46+TVVM1xS7XAr8K7YFtd22tDIowqwO00AuCgjWE/E044XGl/IL/XOvq
	 hRQ41NIAmWjcFbDYXsPfFREJyUo0D9WrLtvDtM+z2mxtbYJSmHv5BXOaYd1x6Z2VlsqoU
	 3Boz5fly6CmIgsrlF7mZ/i6KvsDn1jQjS7uV0LzVUfdI6rlTDbUSBbWWX+eRteNWflQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795483290;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=W/aJuz7K+VVNBF83RN+QXZkBxEvensHYjepDsWDhvvY=;
	b=e4M6A0vt3gBqWB5Vv6Qm8uqlS6cj0SXJUvYKGjqvk9lR08rPr9FGJNJAjmOYgudnL40d
	 ojXFTiWV0s9q5VaM9ko1Zap8UgXtFWailUQi3PZtwLAkZa4kMM8IsbPT8Ak0T3Bb1KzOO
	 jo+UasV0OVxvH6hAISPzVsorYp0vJYSokFF1xWILITtZRyC3Dr/7jvauWAIqlITUwomwD
	 X+ITzEcdi/zdweKmQnebEKzYu77imtMMFT1fywPo72WMFcp9tciZczT4rOwpx4ws1OB+s
	 w3rTzd1JPbXHwhCn9znyocXRqHrgPOXxo5Hr1HEtSyEXG0Nk0UII+o3MrAT4uJNfZXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O6dX9b7p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B75606A321;
	Tue, 24 Nov 2026 01:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O6dX9b7p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6671F000C0;
	Tue, 24 Nov 2026 01:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795483289;
	bh=W/aJuz7K+VVNBF83RN+QXZkBxEvensHYjepDsWDhvvY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=O6dX9b7pqSkKLFElzCIh7pJ/BhgMH58hvd38nQpgB/UvjnMErR0kJ9Li6vdKxpSzb
	 aiSfZhdNrLR5lDrBb4Q0gicGkpT4ofZvW3UgKhbKzWsYEZUbAbeoFaJAsL28KUdx0A
	 Q6AAmBrXVhGub461gBzQGwTJhUUB++7Th3gsFJCi4oDf+aWLjF7WF6GdggaVHmkbRS
	 kFgeYk0OIm4rZmEsWIPuFQsnVehRlAlzcYYK36cp4DgZHiHntNS3WeD8QeBXz34QXc
	 IfasqzSuT1aEDDKYSNJS7CkQpejGBSTvyTBBJL2wbtZP5RwoZna73gJ2v8f3xyY+PW
	 Q0VCYKbCLCFpQ==
Subject: Re: [PATCH net-next v19 15/15] quic: add packet parser base
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
Date: Tue, 24 Nov 2026 01:21:27 +0000
Message-ID: <179548328755.3135.13551034983466058259@kernel.org>
In-Reply-To: <5c305e22057f748d5c4d4cbc94a1e14271dbc485.1795393691.git.lucien.xin@gmail.com>
References: <5c305e22057f748d5c4d4cbc94a1e14271dbc485.1795393691.git.lucien.xin@gmail.com>
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

- [Medium] When ALPN demux is enabled, a valid ClientHello with an ALPN
  extension longer than 128 bytes is silently dropped, so that client…

--

quic: add packet parser base

This patch adds RX packet parsing for QUIC. Sockets are looked up by
connection ID and address, and Initial packets are decrypted to pull ALPN
out of the TLS ClientHello so the right listener can be selected. It also
adds ICMP PMTU handling, deferred packet processing, and the request sock
and backlog infrastructure for incoming connections.

> diff --git a/net/quic/packet.c b/net/quic/packet.c
> index b6f76681b6902..919745d954403 100644
> --- a/net/quic/packet.c
> +++ b/net/quic/packet.c

[ ... ]

> +	/* Read TLS extensions length (2 bytes). */
> +	if (!quic_get_int(&p, &len, &length, 2))
> +		return err;
> +	if (len > (u32)length) /* Limit len to extensions length if larger. */
> +		len = length;
> +	while (len >= 4) { /* Scan extensions for ALPN (TLS_EXT_alpn). */
> +		if (exts++ >= TLS_MAX_EXTENSIONS)
> +			return err;
> +		if (!quic_get_int(&p, &len, &type, 2))
> +			break;
> +		if (!quic_get_int(&p, &len, &length, 2))
> +			break;
> +		/* Incomplete TLS extensions: skip ALPN demux. */
> +		if (len < (u32)length)
> +			return 0;
> +		if (type == TLS_EXT_alpn) { /* Found ALPN extension. */
> +			if (length > QUIC_ALPN_MAX_LEN)
> +				return err;

[Severity: Medium]

Is returning err the right choice in quic_packet_get_alpn() when the ALPN
extension is longer than QUIC_ALPN_MAX_LEN (128)?

RFC 7301 defines ProtocolNameList<2..2^16-1>, so a ClientHello that offers
more than 128 bytes of protocol names is still well formed.

Other cases this parser cannot demux return 0 and keep the current
listener. Those cases are a missing CRYPTO frame, a non-zero CRYPTO offset
and incomplete extensions.

The caller, quic_packet_listen_process(), frees the skb on any error:

	err = quic_packet_get_alpn(skb, &alpns);
	if (err) {
		kfree_skb(skb);
		return err;
	}

With quic_alpn_demux_key enabled, would this drop the client's first
Initial packet with no response? No request sock is created and nothing is
sent back. Each retransmit of the same ClientHello would be dropped the
same way, so the handshake would time out.

This path also does not increment any MIB drop counter. The decrypt
failure path above it counts QUIC_MIB_PKT_DECDROP.

Would it be more consistent to return 0 here and skip demux, as the
function already does for the other cases it cannot demux?

> +			len = length;
> +			found = 1;
> +			break;
> +		}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1795393690.git.lucien.xin%40gmail.com
