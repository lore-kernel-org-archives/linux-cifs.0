Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794349775;
	b=Nb8LnzB+4Yqu0yBUjnYRJD5xeGhVbqXpVzqmJNdhmMlQVKgKH9tgHSXqowD+hQqFG0Sd
	 TcSPiwRCEK8kvYcQQum7ESpL7oa9GJ3oagJ8DRw1b1eLDeoHDV+oTnfCEycCLWbM6FnFp
	 m0mgWEq6vR78dI6M6Ndry1GFtZXkHVWmvOXaOIzKC6E0509DPwARHaaIq0JlNbW4YCssc
	 5hVozxI8hcXWJfJK463kQeHW64Afu7VOL3eHMBqpCK6ic7fy/RcbuGi0Y0hbdp/Q+4iAK
	 twA1HJBnPKLi3M1O+QwC79vNwqchp4sBuNNPs7hnbynu1Q6MgqNtg3ZeAJdfRhUAU/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794349775;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=9GEMNO6n5l4j1BHbxqDUod4oDMrumi+dktYyJ//4skg=;
	b=IEuqjh1IXHivpO6Vm5Dpg9jklUS0FsuPhjShlmF9xsMfYt82uaO6RYtoJ44qOWY2wYMc
	 bRMBkAf/HRZeFMXTnNNj3C9TQYur/PDXe3H9xQcH2Kyx0Hh45f5XZdpNlluaK8GK4tQi+
	 g/0DuLkROQjy2ErLXcsfYZ9+sAeBbAbh/yP3zgI7bofGQTBbvZLhh7m0Ytme/8DniGrxF
	 JUC/JOF+bOypB90sKo3sEP1JauIOH5QPIdkS0RoB5MuBRDd9Mw/HiqClB+cjjWwn4tCWf
	 bnYNYFGN/WfkgZBYrSvCHuTQA6BgZUNsi27gX4Z0dvKssVKxcWDJlKSjXSix1T3eeDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NLp3bHRJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1F0606A33D;
	Tue, 10 Nov 2026 22:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NLp3bHRJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230A91F008A3;
	Tue, 10 Nov 2026 22:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794349775;
	bh=9GEMNO6n5l4j1BHbxqDUod4oDMrumi+dktYyJ//4skg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=NLp3bHRJGksgstYMDAs7EPIraSzFPqoq5TxqDCTomQE9a4jpnV/nwAJ/0wTLdPYMg
	 2I1o+G3LGpCy+SGsu2Yu55Z0ESjIXqveoCtNKQ/NBUAkTxS6XGna4asoXEmjm+4Rlz
	 8qDLAOqVAL3lGdZUF+6zXV/NzIwH+3Gy+NMnIAB6fP+KS3X86IuPI/U1PuOrVsxR3Y
	 WdGc1kh6BCQTo1VGmDT+isdmzbH4g/vWs1nmThHfKnOP4IXe6l12af5bo69dJ4D+mY
	 2X0lkBJiUt51SXfsRtYli+hu0Ttp0ZJ7IzzNH6B+HNxcGvIDLOkJRqx8eoQBc69S8o
	 QCNbsDywDSwCA==
Subject: Re: [PATCH net-next v18 03/15] quic: provide common utilities and
 data structures
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
Date: Tue, 10 Nov 2026 22:29:32 +0000
Message-ID: <179434977271.994134.13327923655573008427@kernel.org>
In-Reply-To: <d56def04e676265cb24727723f2f66251977078a.1794241655.git.lucien.xin@gmail.com>
References: <d56def04e676265cb24727723f2f66251977078a.1794241655.git.lucien.xin@gmail.com>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] quic_data_from_string() (net/quic/common.c) splits tokens
  inconsistently.
- [Low] `struct quic_data.len` means two different things and the
  comments do not say so.

--

quic: provide common utilities and data structures

This patch adds the common QUIC data structures and helpers. These cover
packet header types, connection IDs, address handling, and hash tables
for socket and connection ID lookup. It also adds a quic_data binary type
with parsing, matching and memory helpers, plus encoders and decoders for
variable-length integers and transport parameters.

> diff --git a/net/quic/common.c b/net/quic/common.c
> new file mode 100644
> index 0000000000000..8114be4fbb1e6
> --- /dev/null
> +++ b/net/quic/common.c
> @@ -0,0 +1,565 @@

[ ... ]

> +/* Parse a comma-separated string into a 'quic_data' list format.
> + *
> + * Each comma-separated token is turned into a length-prefixed element. The
> + * first byte of each element stores the length. Elements are stored in
> + * 'to->data', and 'to->len' is updated.
> + */
> +int quic_data_from_string(struct quic_data *to, u8 *from, u32 len)
> +{
> +	u32 remlen = to->len;

[Severity: Low]
This isn't a bug, but should the comments say that to->len is an input
here as well as an output?

Everywhere else in this patch, struct quic_data.len is the number of
valid bytes. That holds for quic_data_dup(), quic_data_append(),
quic_data_free(), quic_data_cmp() and the new ticket/token/alpn members.
Here, though, to->len is read on entry as the capacity of to->data. It is
then overwritten with the produced length.

quic_data_to_string() does the same thing with *plen:

int quic_data_to_string(u8 *to, u32 *plen, struct quic_data *from)
{
	u32 remlen = *plen;
	...
}

Its comment only says "The resulting string length is written to
'*plen'". On the -EINVAL and -EOVERFLOW returns, *plen is left unchanged.

Neither helper has a caller in this patch. Suppose a later caller passes
an existing quic_data, such as quic_alpn(sk) filled by quic_data_dup().
Its payload length would then be treated as the writable buffer size.

Could the in/out convention be documented here, in quic_data_to_string(),
and on struct quic_data in common.h?

> +	struct quic_data d;
> +	u8 *p = to->data;
> +
> +	to->len = 0;
> +	while (len) {
> +		while (len && *from == ' ') {
> +			from++;
> +			len--;
> +		}
> +		if (!len)
> +			break;
> +		if (!remlen)
> +			return -EOVERFLOW;
> +		d.data = p++;
> +		d.len  = 0;
> +		remlen--;
> +		while (len) {
> +			if (*from == ',') {
> +				from++;
> +				len--;
> +				break;
> +			}
> +			if (!remlen)
> +				return -EOVERFLOW;
> +			if (d.len == U8_MAX)
> +				return -EINVAL;
> +			*p++ = *from++;
> +			len--;
> +			d.len++;
> +			remlen--;
> +		}
> +		*d.data = (u8)(d.len);
> +		to->len += d.len + 1;

[Severity: Low]
Are empty tokens and spaces handled consistently by this tokenizer?

The length byte is reserved with d.data = p++ before the code knows
whether the token has any content. The inner loop then breaks on ','
even when d.len is still 0. As a result, ",h3", "h3,,h2" and "h3, ,h2"
each store a zero-length element.

A trailing comma such as "h3," does not produce an element, because the
outer loop exits once len reaches 0.

Only leading spaces are stripped. Spaces before a comma are copied into
the token, so "h3 ,h2" stores "h3 " instead of "h3".

quic_data_has() and quic_data_match() compare elements by exact length
and memcmp():

	quic_data(&d, p, length);
	if (!quic_data_cmp(&d, d2))
		return true;

So "h3 " never matches "h3", and a zero-length element matches any
zero-length probe. quic_data_to_string() also writes the empty fields
back out, for example ",h3".

RFC 7301 does not allow empty protocol names in an ALPN list. This patch
has no caller yet, so once one is added only a user's own socket
configuration would be affected.

Should empty tokens be rejected or skipped, and spaces before a comma be
trimmed?

> +	}
> +	return 0;
> +}

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1794241654.git.lucien.xin%40gmail.com
