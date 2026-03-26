Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B32E3FE374
	for <linux-cifs@vger.kernel.org>; Thu, 26 Mar 2026 15:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774537838; cv=pass; b=ci45TNltaewRd9idEtWvtFvbziNf92DwPI1fepTWADlxDpfAx0Nv1+VhH/wQ7VXDJAxGCilreqc/Tmkh2UzG7PlBhi9p6XHYCsNW/WOw1fNwk9PL4qquMXO7gVYQB8uE/8dpqpwRSWR9pXQmEz14LuluazKzXu1biCHJhre9mYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774537838; c=relaxed/simple;
	bh=qKz7GeQxZ8sggDV0R8PRl9sGjFfikJ4/Tqa/hBGF7AQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JC0M7XFZjdLb6bRhPTvhPqsDaeIUz0YSC16YxmStWIUG52pUOesRf9PzmHwqPPZVR2PHC+rKkCVZRrWUO/a1r4cTp7SFlYqqWoiB83d9H8OQGE6jxT4La5a+16jHNUd2bUK2hexYg42eCkOuGNzkellzIQBkINzWvO+gxSOxlC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jg1jV09J; arc=pass smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jg1jV09J"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-82a646c96bdso895436b3a.2
        for <linux-cifs@vger.kernel.org>; Thu, 26 Mar 2026 08:10:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774537836; cv=none;
        d=google.com; s=arc-20240605;
        b=SngrF1x1thf09rh2IUocWtor6qlyhv08pmZ+lbB+6v3qHgErbbBohMKVZXmvR2EaFl
         bxV8l31H4J/4QOoqLFqO88yiK1gbCM63YEOz2Bv5rfk8AZj1lbTNna4wRGPtTGyGieob
         aWujo7ot8kt78i1PTe1su9WTAgNjbyBkuDi/qBcI8aZgZkpNkYCVrN5YT0fbtW0rMIHt
         433CQ11bHEUihbvlHdoyCHzl/Nne0n62L3yylekbVB0FTEjlYIOVP+F0Kap298e2i3Kb
         lCA1BTvKqQxKxYglabDYT/riddrwykhahFI2ceDia1BeGWcQacFpDJkKY7V2ISfkLtLk
         TGSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mSefNftQWki8QitGf1y0R01W7kHkanHSPeWJVPTl48E=;
        fh=zp468FR0Y0e27gnln3uM+1EVME+XXuY9QY+Qbu4qqNc=;
        b=XtbC9zQwSn8yKcCSrad1WaK4m7RNVeWWMh1OcqiLunn7GWv/yafV5YpvxSpYH4+s0f
         c4oFPSFc3lQidduIYBy+pI1VVda/IuXUfqxTuYZPHwaeHGbH0mqbI417LUJXjgTH3jvu
         CUUBJxkh47MAHGRxPzjNWExNFHwHSg0BOaFMpIHLGlLqJPQprj34gxMFXZvKP5Elnyc+
         kPD0VSV0FswqhxSQOjYQhtTWxgehSXsz3t35QSi+6e9J6KFd8UM9ic5WR9E5ttSC8zwk
         JJRf3Jko6jKac0qKw1yFFrGUOplrS5hdErR4vTqwVqYlYZzb3hRgFpuppwDg6+9AFt3F
         jo0Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774537836; x=1775142636; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mSefNftQWki8QitGf1y0R01W7kHkanHSPeWJVPTl48E=;
        b=jg1jV09Jlyvu9VJnn0BkZbueVt/NGyBB2FghscoHIp9UF8ZyGTghcW+rdnPobuhmc/
         FuJOmhCkQcpHBFZnZWTrkQxfDPvFq2/LldKLRP9HsQy7tD0ax5c+bPwL0C1Kpz3Z33ZX
         UJlY1CoK7KgHaNuhqYMdjdVuXdDj2LqzxvBhHNDvVsUO7jD+lESTXVoIOVCUJDtmB1Nx
         spQbUGPxZKTIxF355hZ+KhihLf9boPKhj1mHoDYnWzrV6Rrrm38oyM/tWfKJRPA4600o
         owycm/4gvYNEOXyWUyUIoi5n0R7FPn6L385IbnBt4B8nYWFUSpJCAeUbapJxOPJ9QO2P
         qTfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774537836; x=1775142636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mSefNftQWki8QitGf1y0R01W7kHkanHSPeWJVPTl48E=;
        b=Elu8tDxNQvY5xScUaBmaKdriCL9E8fXQTa5yuK+jpw43z1kbxhsINcxlpEhcyUdQ6+
         3CSHDZY7jI4pJHX4iVLF4pl9ThehYicvZpGR7gexpqs0U/I8PiOPfKIXQZM1VGfN5JNL
         5r0LrkCDrgVD9Mh0/K+pTmXbLc4hlcQvIGKz3t+qbDMpD9PTm8stGi+j9OsS5jingECw
         TMY4ng4L9rc61stTy6LMTKsHyiTFeIsa8f09CbBXwTuulApA7xjzECFoA1JEWh/G1AbO
         GZvGWfuIenf3DgZ+qdmKuJkSj3RhxZ7eYeBTUvOrWT+XGIpXL8v9aIjl/A0bjPQycPOn
         enyA==
X-Forwarded-Encrypted: i=1; AJvYcCWsaESoQmgptca2Vs4GrqsC3YUwm1rciWlUFk4CF+ivUIanSIsAISn7ty5+Jcb37FXnhi+LN1iO3bYF@vger.kernel.org
X-Gm-Message-State: AOJu0YyyuiffKLH2+0NDFiKB0kC7nyV3yfBGbEebejSg+D5R0SU7/xET
	5FCeUgcCJyWcmXLbNss/MeSt2eyxk7rCUKBA0Krlmo2/YchCmBNKF/Aq5I81Oy0LQcMiGcpcLCe
	zXmVmS9BYwRDvIYF0NGH6+mGCxw8+g/c=
X-Gm-Gg: ATEYQzx6dSuNp+9FDeZhDFaSqifX03ks9ttbKBptlLBmp82EJQXcwyjpgFmKwabJLca
	cxdckmJnQmo8HlUIEnm6FM2LW6AyzjSUxhkbgDqxZ95YgCvOBaQzsDwOomHvFjk/2g11OFryJwO
	8cfutN8zBH9eqP+jwQp8gPSMnb03E1sXmGAXE7kHhqYx+Rh54otE1hv1WOqAV1K0p5No5o+v3Wd
	4XRNP8FszSsHdCDaSD/H3y2pkfIM475QEIlx9FPOlCFw/uu/CJlVQgAcnIDfqQmr3T1uBn+ZeTc
	cGahlSGvxPt3kU8F0CGTZnM1j3keMxqHfwf+bTBs2sENd2fuf827zvczdgg2dxvDgOstrzmwWA/
	AA/hx5T8jTYEQEodJfJQCJAZ0ctkXKhTKh+1dJIAe
X-Received: by 2002:a05:6a00:2da7:b0:824:374a:13f7 with SMTP id
 d2e1a72fcca58-82c6e15f706mr8408159b3a.55.1774537836342; Thu, 26 Mar 2026
 08:10:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1774410440.git.lucien.xin@gmail.com> <d86910330339da257534ad93db71949176961522.1774410440.git.lucien.xin@gmail.com>
In-Reply-To: <d86910330339da257534ad93db71949176961522.1774410440.git.lucien.xin@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 26 Mar 2026 11:10:25 -0400
X-Gm-Features: AQROBzCHlIqDJYnoa1tW3FE7PgOFSLHI1Wh5jc_7MECEmTiUBtm70S0dHNsViq8
Message-ID: <CADvbK_d+oVgMNWQ3fT_Rz9WGkU6i6m+Z=3J34_-QiCjEABoCpg@mail.gmail.com>
Subject: Re: [PATCH net-next v11 12/15] quic: add crypto packet encryption and decryption
To: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, Alexander Aring <aahringo@redhat.com>, 
	David Howells <dhowells@redhat.com>, Matthieu Baerts <matttbe@kernel.org>, 
	John Ericson <mail@johnericson.me>, Cong Wang <xiyou.wangcong@gmail.com>, 
	"D . Wythe" <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>, 
	illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Daniel Stenberg <daniel@haxx.se>, 
	Andy Gospodarek <andrew.gospodarek@broadcom.com>, 
	"Marc E . Fiuczynski" <marc@fiuczynski.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 24, 2026 at 11:49=E2=80=AFPM Xin Long <lucien.xin@gmail.com> wr=
ote:
>
> This patch adds core support for packet-level encryption and decryption
> using AEAD, including both payload protection and QUIC header protection.
> It introduces helpers to encrypt packets before transmission and to
> remove header protection and decrypt payloads upon reception, in line
> with QUIC's cryptographic requirements.
>
> - quic_crypto_encrypt(): Perform header protection and payload
>   encryption (TX).
>
> - quic_crypto_decrypt(): Perform header protection removal and
>   payload decryption (RX).
>
> The patch also includes support for Retry token handling. It provides
> helpers to compute the Retry integrity tag, generate tokens for address
> validation, and verify tokens received from clients during the
> handshake phase.
>
> - quic_crypto_get_retry_tag(): Compute tag for Retry packets.
>
> - quic_crypto_generate_token(): Generate retry token.
>
> - quic_crypto_verify_token(): Verify retry token.
>
> These additions establish the cryptographic primitives necessary for
> secure QUIC packet exchange and address validation.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
> v3:
>   - quic_crypto_decrypt(): return -EKEYREVOKED to defer key updates to
>     the workqueue when the packet is not marked backlog, since
>     quic_crypto_key_update()/crypto_aead_setkey() must run in process
>     context.
>   - Only perform header decryption if !cb->number_len to avoid double
>     decryption when a key-update packet (with flipped key_phase)
>     re-enters quic_crypto_decrypt() from the workqueue.
> v4:
>   - skb_dst_force() is already called in in quic_udp_rcv() on recv path,
>     so remove its call from quic_crypto_payload_decrypt(), which may be
>     called without RCU protection.
>   - Remove the incorrect (void *) cast to quic_crypto_done.
> v5:
>   - Use skb_cb->crypto_ctx for async crypto context freeing, which is
>     safer than using skb_shinfo(skb)->destructor_arg.
>   - skb_cb->number_max is removed and number is reused as the largest
>     previously seen and update quic_crypto_get_header() accordingly.
>   - Change timestamp variables from u32 to u64 and use quic_ktime_get_us(=
)
>     for current timestamps, as jiffies_to_usecs() is not accurate enough.
> v6:
>   - Rename quic_crypto_get_header() to quic_crypto_get_number(), move
>     key_phase parsing out of it, check cb->length when parsing packet
>     number, and update all callers.
>   - Use hdr->pnl + 1 instead of (*p & QUIC_PN_LEN_BITS_MASK) + 1 to get
>     packet number length, and remove the unnecessary the len variable
>     and QUIC_PN_LEN_BITS_MASK macro from quic_crypto_header_decrypt().
> v8:
>   - Move skb_cow_data() from quic_crypto_payload_decrypt() to
>     quic_crypto_header_decrypt(), as header decryption also writes to
>     the skb and is invoked earlier than payload decryption on RX path.
> v10:
>   - Fix double period at end of the comment for quic_crypto_encrypt().
> v11:
>   - Note for AI review: call quic_crypto_aead_mem_alloc() after
>     skb_cow_data() as it uses the return value for nsg. If the allocation
>     fails, skb is dropped, so no rollback of prior skb modifications is
>     needed.
The AI report on

  https://netdev-ai.bots.linux.dev/ai-review.html?id=3D1624d906-c0b6-4e12-a=
63f-5cbfc51b660e#patch-11

is already explained by this "Note for AI review", not an issue.
