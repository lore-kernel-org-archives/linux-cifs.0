Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F5B369211
	for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2026 19:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781293299; cv=pass; b=PG6VpBz1/kri8DLVkSkqQWU4nXH5+Ci12slfZ5EYHeADco+ToxURLDlMwmEJQT+LifWjzNsHS8tr5OrAdyazmXd45KOLN42lp99nBohO38rjehsGQCvfFVPAMBFc1tIxJdkwdncdY5jnWlg/fAyu5m92ZTsFEUBSg0xdm0xvXHU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781293299; c=relaxed/simple;
	bh=8ZLOGvGFodYhD0qua0VuzQdoTndbnD664tOVgr1qn2c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=olkpUZABD3/OOO1QYYbvWsGJ9U22t5Z5bmxoPM+RV6YrJn/1aXiPWJ9Tzc/WtmgDaSjjnjZKROKRZtcY1E+9C220dPfqYICG5NkKk4Eg//LUeBHYBiqSUHJsg9RTPqXM9nqPuzrPRDIUthM0z3hTTBaAaQd3IFSlzl/nVGxpLYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=shfDh4E5; arc=pass smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="shfDh4E5"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8422871b42dso877675b3a.3
        for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2026 12:41:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781293298; cv=none;
        d=google.com; s=arc-20240605;
        b=EDrM8cujq2FYiN21cw4X7ArZGNNgCwrtezdLPtlJkmoUL4vlZKdcSlqtvcBgwC7x7V
         Gik+NrxB91R+Dajbuvz5f8gTZ4t4NoQLSOZ6AVAZOYkT9yvAmiJ5vKdH5Ew15dW39+Gs
         OZnpfwZEF3K6HBvWzfho3v4dKL3rkbxywi/N6hvkFrUsbKCIYP8zzbVobp57eYIqFxmx
         zHnxkjN+VDQ5531MlXPXY9YCPLLczccgMm/0rYfwEQIoauu08gynrZ615P15B/eXV7xy
         yOJ6oHmpF7xltpeO8xDvzA8I9V3TVU3Vgm/2sOJrhU4cq+QQMMIIfjTLG7LI/PCCP6XM
         c3MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Rbi30ru7gSioJ7/e48J895iPmcFfwsVcpIndfODcrgQ=;
        fh=10zYu2xDT3XRduIjK80UagrJTZqlh2ML+Z0qfj3U5zw=;
        b=kOqTLxV6u6FtRY8X7xYxnCMyi6z3oyEpMlh/o6eVQuwUx8GF6IYTzdgNCl/gCYVWPa
         JeWcs20Tq62ZSa9Ib4pLIFbGIwz6QnfvL1hDOxRK589tVqGVWDvgA4g1gUvbZU8yfebe
         TqFab2Dq0PWsein5P3KgrlX/2cMw789yiGA5nlHViFKDnqawRVuzcLEu4c2NWFRoO23b
         phLV6LcmbPIeFwRIr7ShC61D63TkGOtRPI7mKH3qrNhrg17LwyZXVCAgUQD2Sx6DGF1n
         RoDd9rPs0Qhob8Guv7+fGOewigUUbjwqhw50EuefY1lvAuFPnDbb//mZjKKxBncEQbw5
         xm/A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781293298; x=1781898098; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Rbi30ru7gSioJ7/e48J895iPmcFfwsVcpIndfODcrgQ=;
        b=shfDh4E5C1zufMfR1LU5U6amaDdkIGzntIK5JptXPmIXPyTZfMbVnUelrPu4jxQlU8
         aL6DLro/v59IYt5baaEe+0848jo2VilIMZK3oXL8DbvHvJjY8vl8Ioo6GIJKEMZ569ky
         5dTyCi/SrdvA7tFM3tMKK8I8uroh1b//lSilaCS8DjFwjc0Kp7/GXY49n5KK0OczfyyM
         DIMMdKJtR1UFEPDUByg0NfrgBepJq64rqVtaxMpe1jkqdNoJIu31JH1bksTsZaY4Za6O
         vzOFEyQw26JB35EcaMCkJl1n2qnLu7h2nFN8p6a96R+4ZejwfwkV3iGTzDSG5ZH7JL2a
         YEnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781293298; x=1781898098;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rbi30ru7gSioJ7/e48J895iPmcFfwsVcpIndfODcrgQ=;
        b=kcJgvwogNdpiIVUZ9ymC5XUR+tUE6LkfLYRjX1XjR6uCOsphTZlNTx5e3B42t2pA16
         46RaANgn8mem6wS0+dYikDdtyn4LhT0sFCyveOrTmSgTUC6AFJXcOBRVT9hgp4GjUTEo
         hKYArjg4kU5Wad6adD0joGfzGBzCsobjBGOwcgkQMbhDDgJRI/9rXIvmv9u4hLz28ZU7
         oc1D70peCzjCDX+RUH9EXwb87QkNWmubqKmbEkuHp4L9c66eZc4hkmlmXIT+YaNgwuh7
         pN2GmSLYauv/1DTz5bc5vfuBmbHk8nNkE5ibWtHaDtUYVLz0rKtJy3/v2fBYB/9gNA4j
         X5Sw==
X-Forwarded-Encrypted: i=1; AFNElJ/P/+fjokqSLm0/MDH5BHbFLiVPkPfMhVpnM1HWavrGRp6g11KwVpnQJvtZWNwlgu5VCNWxUAbTlpxY@vger.kernel.org
X-Gm-Message-State: AOJu0YyC1NnbyuITY1UFOq7wNDI9M1uIYsJlO2XIx+8+cE1XofrnlNdI
	gu7Tt7sATF7dqhbgSYW/5Y/6j4/RNNE1o+uenOnVnz8qjLzJjdqDp4GM0QWCXTwTRutZxH22jHG
	MctjyJBSM4z2R/h4wE7GulbHQH/A7LYE=
X-Gm-Gg: Acq92OHjNjRoOyS/c2jLuhhxv7WyqOKiw+LsiysRDkJD+CxLg0FpWZ0BnU/K6DguBfa
	s8YFoff0WKIIuQIYAvsXgV6EvSe9K+Q1atcRfuiApvdV3c7CeFfb76NgWM1SCWCf8ejBNoEapEu
	HhJJnzivpr75AIvdthsa0ObHSTWimmTQnBCdJOEc50208dYVm4gEzr5Ze3ZfeS7cWZA/5BnpKbi
	vxHbhZMgRymn8iuyFMpkb7hrCtT+1q2zhoooyDf5J5vGZFqqdHEFs38XuXh8Obc2RQd9Uzqqz8H
	Jc2EDsMjnmH/yRWVS+pIj94sALOJ5sJmxD96sWmwx0/gW8GAwlOV8Vw2usVCfzB1TDcBBphe6+z
	AiBdpuUfVqeFq9tss
X-Received: by 2002:a05:6a00:18aa:b0:842:4387:34b7 with SMTP id
 d2e1a72fcca58-8434cd41f33mr4652675b3a.10.1781293298066; Fri, 12 Jun 2026
 12:41:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1780855296.git.lucien.xin@gmail.com> <e73d8f69b67fdeeec076fbe772ca465d7e1af4cb.1780855297.git.lucien.xin@gmail.com>
In-Reply-To: <e73d8f69b67fdeeec076fbe772ca465d7e1af4cb.1780855297.git.lucien.xin@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 12 Jun 2026 15:41:26 -0400
X-Gm-Features: AVVi8CccjtCVNlXysoHMU93ce-8zqlj8T5zFjNLF2CVr-6fSHzwtKPVAgQLYHfw
Message-ID: <CADvbK_e7wpf=-C9h97b2JWUMQ6YkQLtVeTcxxCdQPaFTN+Litw@mail.gmail.com>
Subject: Re: [PATCH net-next v13 04/15] quic: provide family ops for address
 and protocol
To: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>, 
	kernel-tls-handshake@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>, 
	Jeff Layton <jlayton@kernel.org>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, 
	Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>, 
	Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, 
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Daniel Stenberg <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>, 
	mef@scarletmail.rutgers.edu, paul@jakma.org
Content-Type: text/plain; charset="UTF-8"

[sashiko-claude]

> +static void quic_v4_lower_xmit(struct sock *sk, struct sk_buff *skb,
> +        struct flowi *fl)
> +{
> + struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
> + u8 tos = (inet_sk(sk)->tos | cb->ecn), ttl;
> + struct flowi4 *fl4 = &fl->u.ip4;
> + struct dst_entry *dst;
> + __be16 df = 0;
> +
> + pr_debug("%s: skb: %p, len: %d, num: %llu, %pI4:%d -> %pI4:%d\n",
> + __func__, skb, skb->len, cb->number, &fl4->saddr,
> + ntohs(fl4->fl4_sport), &fl4->daddr, ntohs(fl4->fl4_dport));
Should cb->number use %lld here rather than %llu? Looking at struct
quic_skb_cb in net/quic/common.h:
    s64 number;  /* Parsed packet number, or the largest previously seen */
Since number is s64, a negative initial value (such as -1 for "largest
previously seen") would be printed as 18446744073709551615 with %llu, and
compilers with -Wformat-signedness flag the mismatch.
[ ... ]
> +static void quic_v6_lower_xmit(struct sock *sk, struct sk_buff *skb,
> +        struct flowi *fl)
> +{
> + struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
> + u8 tc = (inet6_sk(sk)->tclass | cb->ecn), ttl;
> + struct flowi6 *fl6 = &fl->u.ip6;
> + struct dst_entry *dst;
> + __be32 label;
> +
> + pr_debug("%s: skb: %p, len: %d, num: %llu, %pI6c:%d -> %pI6c:%d\n",
> + __func__, skb, skb->len, cb->number, &fl6->saddr,
> + ntohs(fl6->fl6_sport), &fl6->daddr, ntohs(fl6->fl6_dport));
Same question about cb->number being printed with %llu while the field is
declared s64.

A minor one but legit, will fix it.

Thanks.
