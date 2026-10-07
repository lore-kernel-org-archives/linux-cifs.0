Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B57A199E89;
	Wed,  7 Oct 2026 01:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791335104; cv=none; b=uYEslnNiEdiL2VBc/ts/upX6FF+MwqUc6VlgIjOLggu6b5gk2bHE5oVqDRk6zIO6n8LUAc7Nebz+8ETYjp84SjxQfgv8LnXiAULGmSygPcpaTOB5me5FTChGZYleZzmjDQUX4p0TyTxeqL1ynKqdIfUOsotebCQan7+d/huYU4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791335104; c=relaxed/simple;
	bh=9f3Ze5d/XEEAjw/F/JcqdkwXUD5DY6CTbnm/niVw93g=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=r1FU7F3WKIy1UvVIhXykWGFTX8ZKQ6eOlCREjxan1w6ThN2BgRkqfZWeJvf/gLgxIL2nPUovDo9dwf7LvkF+OYuw0pbnFfBSVj8/XraC56/smRl6+1i1dPmfcHpYJ9ilwbZgyI1szpEDfh1J41yHy/JSGCUH1n9KcFP/LmC+0RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c+7RFFhf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c+7RFFhf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF89E1F0089C;
	Wed,  7 Oct 2026 01:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791335103;
	bh=hLAs/PsokLyy10RS2rt9Eo/0SLq6/zq+7OiQ2CU3CrU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=c+7RFFhfQVJKwy/DbBctCoWy+GdujFzkQ7wFRrYAdz6xUTeLgwq5k+AjkqrZ+Zi9+
	 eTui7RQ0WMreCBJA8HlT/1WnjEm6GAQFdVFrQkaGYNLoIhQED9dbRgdiX3VmuuMv2W
	 dVs/Zuxb8JKYZuqrK7snALlhlwp1S5g28FqLoG4vlmiTNrU9F9Z7tMBHP2JpSKAGm3
	 CWS10dlbngE6M+i/3OwXF1Izumz34hjau95a1XQnDflj/jh+G9YsKt0lXUlm1W0mVn
	 rrS7/qFdYKLxq1/YY6polnlHMedIJ8JAvDHsiasRUL1z46K62FS23ZmENTEznYDByj
	 PG8BnvXhFjHaQ==
Subject: Re: [PATCH net-next v16 03/15] quic: provide common utilities and
 data structures
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
Date: Wed, 07 Oct 2026 01:05:00 +0000
Message-ID: <179133510053.434549.1175999971650785278@kernel.org>
In-Reply-To: =?utf-8?q?=3Cd70443b48ee6fb4364d692d7faed990d606a1f0f=2E1791227?=
 =?utf-8?q?050=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3Cd70443b48ee6fb4364d692d7faed990d606a1f0f=2E17912270?=
 =?utf-8?q?50=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] In net/quic/common.c, the per-token length check in
  quic_data_from_string() does not do what the v16 changelog says it…

--

quic: provide common utilities and data structures

This patch adds the base data structures and helpers for the QUIC stack:
packet header types, connection ID and address handling, and hash tables
for socket and connection ID lookup. It also adds a binary data type with
helpers for parsing, matching and memory management, plus encoders and
decoders for transport parameters and frames.

> diff --git a/net/quic/common.c b/net/quic/common.c
> new file mode 100644
> index 0000000000000..8114be4fbb1e6
> --- /dev/null
> +++ b/net/quic/common.c

[ ... ]

> +int quic_data_from_string(struct quic_data *to, u8 *from, u32 len)
> +{
> +	u32 remlen = to->len;
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

[Severity: Low]
Does this match what the v16 changelog says? The note reads:

  - Check each data length before copying to avoid partially writing
    oversized tokens before returning -EINVAL in quic_data_from_string().

The U8_MAX check sits inside the per-byte copy loop, and nothing checks
the token's length before copying starts. With a token longer than 255
bytes, *p++ = *from++ copies its first 255 bytes into to->data before
-EINVAL is returned. Every earlier token has already been written in
full by then.

Also, because to->len is set to 0 on entry, the caller's original length
is lost on every error return, both -EINVAL and -EOVERFLOW.

This doesn't look like a memory safety problem. remlen bounds every
write, and on error to->data[0..to->len) is still a valid truncated
length-prefixed list. Nothing in this series calls
quic_data_from_string() yet.

A later caller, such as an ALPN setsockopt, might expect the destination
to stay unchanged on error. Would it make sense to scan each token's
length before copying it, or else to reword the changelog to match what
the check does?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791227050.git.lucien.xin%40gmail.com
