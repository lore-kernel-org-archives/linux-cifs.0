Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7183A7F69;
	Thu,  5 Feb 2026 11:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770292506; cv=none; b=XJOHf+/xSrsir513/Yd2sIZdh4ihnl+HW+0jF/WqAU69eozFNaeLOw521S0E+Z7fW8cfc42a4hZCUsDLSNKtHpNBy6igUoDjtzUWeR8gSS5v4gQpsxTxqx28UkjW/b1ZEnemPtPCvbTvd598/htwov9BFUi/r2lARII4Nlw5nYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770292506; c=relaxed/simple;
	bh=eEh9oWe3EbivTJiP0XSfCLNXXEAKP/YY9MULBTv57Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gwm8OQpB4NRSOTjxhfLIl20MKN3dl+cxN0jPP+Y8BqLZUnSgnqBaEyW4dTGoYMyq1qc3eO/ak7fk/SGw1nFYrO2Qw2RPcQzRgcs18CdYiGILiLp+bFLUupk64rer9AXniv67vowkyzoFYopvguLmf+clEb2VSU/1o20DEhSpeio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QhDNkXZ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QhDNkXZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2390C4CEF7;
	Thu,  5 Feb 2026 11:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770292505;
	bh=eEh9oWe3EbivTJiP0XSfCLNXXEAKP/YY9MULBTv57Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhDNkXZ4CWBS1Be7G2bkG/UdMnr9UoWQd2IRhmWKldIdYDkJLC56A5631DKNEMlX2
	 X9tZ3piBj4AKIIIPPwqKkgn0oiovz9LLKtGeCW5y0WYO4PlNCL+ljRDgvSEctavOBt
	 5vG8bIU2J30kh6NOnS2VsjGbeP5zvZDZRY68vNifNvnDPbDhTSZ8tXBqGHb+1byybj
	 Az+EbequgltDZ0Bf8hOhJcD0SDIM+CctVefVtl0eLtc4FoKMU/eHP+MNgnKFRK+GQ7
	 NidN0c+OzYcYvNBV9KY9tp2oYXZG2lgFdoaWgE75haxsuS51560g3pnwJFJxgG48qP
	 ZoOx4QWQGgxZg==
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
Subject: Re: [net-next,v9,03/15] quic: provide common utilities and data structures
Date: Thu,  5 Feb 2026 11:54:49 +0000
Message-ID: <20260205115449.2195294-1-horms@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <74174c085fb11b8a63e72a7df730b6f4a7479c5c.1770042461.git.lucien.xin@gmail.com>
References: <74174c085fb11b8a63e72a7df730b6f4a7479c5c.1770042461.git.lucien.xin@gmail.com>
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
quic: provide common utilities and data structures

This patch provides foundational data structures and utilities for
the QUIC stack, including hash tables for socket lookup, connection
ID management, and helpers for encoding/decoding transport parameters.

> diff --git a/net/quic/common.c b/net/quic/common.c
> new file mode 100644
> index 000000000000..94321f3f213d
> --- /dev/null
> +++ b/net/quic/common.c

[ ... ]

> +/* Reads a QUIC transport parameter value. */
> +u8 quic_get_param(u64 *pdest, u8 **pp, u32 *plen)
> +{
> +	u64 valuelen;
> +
> +	if (!quic_get_var(pp, plen, &valuelen))
> +		return 0;
> +
> +	if (*plen < valuelen)
> +		return 0;
> +
> +	if (!quic_get_var(pp, plen, pdest))
> +		return 0;
> +
> +	return (u8)valuelen;
> +}

Does quic_get_param() need to verify that quic_get_var() consumed exactly
valuelen bytes?

The function reads valuelen at the first quic_get_var() call, then decodes
the value with the second quic_get_var(). However, quic_get_var() determines
how many bytes to consume based on the varint prefix in the data, not from
valuelen.

If a malformed packet has valuelen=2 but the varint encoding requires 4 bytes,
quic_get_var() will consume 4 bytes while the function returns valuelen=2.
This could desynchronize parsing of subsequent parameters since the caller
expects the buffer to have advanced by valuelen bytes based on the return
value.

> diff --git a/net/quic/common.h b/net/quic/common.h
> new file mode 100644
> index 000000000000..bfec0aaf2907
> --- /dev/null
> +++ b/net/quic/common.h

[ ... ]

> +#define QUIC_CONN_ID_MAX_LEN	20

[ ... ]

> +struct quic_conn_id {
> +	u8 data[QUIC_CONN_ID_MAX_LEN];
> +	u8 len;
> +};
> +
> +static inline void quic_conn_id_update(struct quic_conn_id *conn_id, u8 *data, u32 len)
> +{
> +	memcpy(conn_id->data, data, len);
> +	conn_id->len = (u8)len;
> +}

Should quic_conn_id_update() validate that len does not exceed
QUIC_CONN_ID_MAX_LEN before the memcpy?

The destination buffer conn_id->data is a 20-byte array, but the len
parameter is u32 with no bounds check. If a caller passes len > 20, the
memcpy would overflow the buffer.
