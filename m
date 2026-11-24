Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795483266;
	b=KUWYBx39O8PZcFwu+NmwijGVXwlhjhIY3P39HS+Z/UB08xaOgUNeQCdCqO2RQMK6pv/5
	 b0niJQenrN4ZU1W/6MUtjCjsHYVpCg2rsqBT4OH2dqXSSkijLdAx7FbbTUS+e20GOx3gH
	 200w/N1nkO69H9GPrWGmDMubfg5HrooY6Q/sxVMkmY7bYB/PtKLP2HE8Wg7EwQX63Vs3z
	 FgAKLKoI5mt+sp92k/DFwN0DF6cjOv/SoazZPFTFB2smNfIGY1CMYsEjRCCfncDX2Zh3P
	 RgSTs0FDVZgNhC5KZpQnBOpN4HD7fMmz36iEyjTMLLEpr8M4mr8hS49vKFUFmO5liUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795483266;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=JCXlR7hTHRaWQL6LHxsE3KF3SHeDzRxPw03OBuJYzAU=;
	b=pfxWR/Kgpx7/KAMm4YRmJx/VTvaEGjXT9b1E0cHn14xxW4DnPiLRRgOIQgL9YSZNk6Wp
	 UjHnB0FpNDWTwdUpt2Iok1XHCqECFZqGsr8GbKD9scEXJ10x24Y+RScCqTK8Jfc3fjmHf
	 4CQh1YMjtckoIpc2+B9u7ujOZ03o1q5bBmenWI4qUSEdB7nRlxt0plA4OGnu7x3/IiDjX
	 djGaXHejSWS+XFLkdKjheo3s/iw26NHN9hoEsqxApRK3Xcda3hT3MV0zTo4OnT2d/2fqx
	 YXWii3848pVEbg6rO1+RjzmRyr/my9VbKKRnCs7XeN3Tu9OVGZZ1QU6iHePshqlN8sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QGIhWQ4P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8841A606A31E;
	Tue, 24 Nov 2026 01:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QGIhWQ4P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9871F000C0;
	Tue, 24 Nov 2026 01:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795483266;
	bh=JCXlR7hTHRaWQL6LHxsE3KF3SHeDzRxPw03OBuJYzAU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=QGIhWQ4PP2o4vIAGlSpTdpVY92BGxP+S2RqCksrb3xjpw8hX9YPDI7QYSctDvotgX
	 pfTby7f31rWU2Uoy2Pguq0i7pa0TN2dEwSGQu4d7jc3yLdGGApAJfrARURv3rI7UmV
	 yPkDk3jFF7E7b5rXOYQasQuYN9Zt4RZ4kTQYOiYGesB/52TsblAW0ZYea7VxIP/AM4
	 UMsFp5Bmuuwov2A4XqSskaELpOyyaGsGI+dSwqUKZyxyugKlVCMDpI5tDZbnKcQd0k
	 /WG7/jb8NbVPdfMnqSKEsB+ZAGKu1YNdLn1G2FaNFPn1aJKnxHz7eMvuqLG//D+EvO
	 LCwFFz3sZgNOQ==
Subject: Re: [PATCH net-next v19 03/15] quic: provide common utilities and
 data structures
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
Date: Tue, 24 Nov 2026 01:21:03 +0000
Message-ID: <179548326380.3135.10486164570925258517@kernel.org>
In-Reply-To: <8b73dfa59d4aad8195f3ab2e3d673d3576e379cf.1795393691.git.lucien.xin@gmail.com>
References: <8b73dfa59d4aad8195f3ab2e3d673d3576e379cf.1795393691.git.lucien.xin@gmail.com>
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

- [Low] quic_data_from_string() (net/quic/common.c:527-567) handles empty
  tokens and whitespace inconsistently.
- [Low] The comment on quic_data_from_string()
  (net/quic/common.c:521-526) says only that "Elements are stored in…

--

quic: provide common utilities and data structures

This patch adds the common data structures and helpers for the QUIC
stack. These include packet header types, connection IDs, address
handling, and the hash tables used for socket and connection ID lookup.
It also adds the quic_data binary type with helpers for parsing, matching
and memory management, plus encode/decode helpers for transport
parameters and frames.

> diff --git a/net/quic/common.c b/net/quic/common.c
> new file mode 100644
> index 0000000000000..e13848f5a72d9
> --- /dev/null
> +++ b/net/quic/common.c
> @@ -0,0 +1,567 @@

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
This isn't a bug, but the comment only says that to->len "is updated".
The code also reads to->len as an input. It is the capacity of the
caller-supplied to->data buffer, and every write is checked against it.

> +	struct quic_data d;
> +	u8 *p = to->data;
> +
> +	to->len = 0;

On an -EOVERFLOW or -EINVAL return, to->len holds the partial count of
completed tokens. That is neither the original capacity nor a valid
result. to->data may also hold a partly written element.

Could the comment say that to->len must be set to the buffer size on
input? Could it also say what to->data and to->len contain on failure?

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
> +		if (!d.len)
> +			return -EINVAL;

[Severity: Low]
Does this check catch an empty token at the end of the string? The v19
changelog says "Reject empty tokens in quic_data_from_string()". Inputs
",a" and "a,,b" do return -EINVAL here.

For "a,", the inner loop consumes the final ',' and len drops to 0. The
outer while (len) loop then exits and the function returns 0. The empty
element after the comma is never checked.

For "a, ", the leading-space loop consumes the rest of the input. The
if (!len) break then returns 0 as well.

Spaces are also only stripped on one side. Leading spaces are skipped,
but every byte up to the next ',' is copied by:

	*p++ = *from++;

So "h3 ,h3-29" stores the element "h3 " (length 3), while " h3" becomes
"h3". quic_data_has() and quic_data_match() compare these lists byte for
byte, for example the quic_alpn() list. Could an element with a trailing
space ever match the peer's value?

Should trailing empty tokens also be rejected, and trailing spaces
trimmed the same way as leading ones?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1795393690.git.lucien.xin%40gmail.com
