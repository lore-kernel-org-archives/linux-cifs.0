Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E1038552F
	for <linux-cifs@vger.kernel.org>; Tue,  3 Mar 2026 09:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772529545; cv=pass; b=V8kmNllkLEyrT6vk84JYQrG7MbXBBVWHz52O8c5ywmFWUuQrwdNvvD5ZjvMuoG0zjpkOthnZJt/0fBcSzYylJG4SBZDZlL1rilgSM6HrmSFAdLXJmII+5oKUI2/dQhmDliI2dDD17q1y4MeZ/1pnjSKfPa0oko7ChQjO9hNNAtw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772529545; c=relaxed/simple;
	bh=Sl9s33PI2gXIErv/itE1S5taIbog6hFU7zftnmcZCok=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z9f5CCCd1925QmJ2gD4wuruUFwfGbPwLlX9uVxFOuknWvLMf4a9pGrYwxWo+MFqUl5pTJHHxoXIlYlGDtVE0xQh2XsNWsH69RQ/HyZzQv5wzL2CUsg7Zqe9iC9HWCF67TG/q+IFiHSKdYbtO4J1LGcpXuhx2CbQo7FZd2HUv59Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pjel4fTi; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fzhlLUmT; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pjel4fTi";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fzhlLUmT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772529542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S88HPomaSqnbxnsyYWFXX9R+c+6772O9y0Gq71iEev0=;
	b=Pjel4fTi4O9ij1KZwh3ha2rSWqn6CsUTs3tZUGzLDvT0YoJHu7/nVo06nTXticXLHr6wMw
	+LxBKgagqfECZHoZ9aAY7d9HllEzhKp+YJ+X1OPM22XTgi2AjX8e4Yr346qPwRXNsrMPNG
	nvDFPaWmgabc31X+C4Ms8dUExIB6AVM=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-1-hW3mKD4yPg2-FpwMw2vl7g-1; Tue, 03 Mar 2026 04:19:01 -0500
X-MC-Unique: hW3mKD4yPg2-FpwMw2vl7g-1
X-Mimecast-MFC-AGG-ID: hW3mKD4yPg2-FpwMw2vl7g_1772529541
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7983f854288so92877947b3.3
        for <linux-cifs@vger.kernel.org>; Tue, 03 Mar 2026 01:19:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772529541; cv=none;
        d=google.com; s=arc-20240605;
        b=QpY1dV30r9Jt8B2UwW1lwUsIohNR4O8kQrhtJ58EI0d7ocF3AvVLHSPYL9lz4StL2J
         2iJSrSD43MKqjSx7dQSh/1LTn75UY8jiDBcGNPRomu+Sgx2yOCYvLQF/PjpTdFppUACA
         v7yaPoEL1WAOpJN99g3z4qlv9UYaFtxMfMsR6rdOruEwODUwIi8gRaPiaPZixA/d/3Cj
         W+MT39IMX5BYevrTJHLURMETez9euqJTxSTg+5KlIuilQnCMEi2DXf7tTv3dVy6R7Vm+
         p1snPriYvEVzoNHZ4fE+gl8LmbmZ1YdXyLaLy0dAQ39ztLYrb+gMcnPHTfiME9knbcmX
         91lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=S88HPomaSqnbxnsyYWFXX9R+c+6772O9y0Gq71iEev0=;
        fh=Gb8D2OpDsx1CmJXEqGA95U7/WVCZbnUMBcs2vEXlIPE=;
        b=crf7TdhZ70FTqsSFyUvLPf95Z8AvJwgbgpLHkCzWXOqF9kEMbgERV8IkS7M9ZnDpM+
         4SMT1TufKx8AyGwzEkqXC5ymRbmBvH9tFmyPKbg3wdHvbX0lPgjezCOgXPWMoTzu0lGn
         JAK8UADdKb7FFKa0sjv22Q+Tbmd6t3usZz11mCJkLdqjvikX6VGghTPsMq1LDefViQwj
         PasQlsMedFbQMUVt+SsdswJobcQ1qGvJj2/8mkifSyvKThkHXZwNVxRP1AkkD2XqW/VY
         EYV1pXw/oMCYEaGerGgXlRimpc7th/+FNKUUBu57YqzjpAZi3VeEqAhG7GtjBfLWxZKm
         I7JA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772529541; x=1773134341; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=S88HPomaSqnbxnsyYWFXX9R+c+6772O9y0Gq71iEev0=;
        b=fzhlLUmTemsvpsZ5B8OowV8sI/k6/8l7VDFNGInSOxgyoYx9xIPGFpDXxsR7SO1ROE
         fIWtiXIvMMq7j8TLrYYGdh42ek9C59l7C9gpLAi8bw2rGZ5XOhpbaCWMnj+ihOCTi4Zq
         Lu6omGfUe5od6KPi0/43SwBDnSgW0ryhOKLshXOUzAjzpEvDc8/7Q02F5X7dY6m2wMT5
         Ho5ow8CdJwFnjM4hDvKE2VhI5GZSSeWS+UmJC5XMWsX4mEoGMuxRoA4so/GMhPibPpHJ
         QwreyzmYTuPDg+XRYp/YKbmlNKQpnOve7L8akyJnwgp0ql3xP3pesofyuOZ8YeM9dzVj
         m5/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772529541; x=1773134341;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S88HPomaSqnbxnsyYWFXX9R+c+6772O9y0Gq71iEev0=;
        b=qxrInPd7jXF/dFiGMwV55N0iPj4uKuZF05RSGmNWdm2kCfkBceRlOs3Iez0sUFDtT5
         zE+uVdqrYZJNYtewi6sP0eXk37rfMaNA2jtCsHwJ+QG3qrLpInabWai7sAPAfWw3fDxI
         h5cFwwvB5/gd2KLDyluCef9r9Dfjfh4v3vAvlYunCWscN6REImO11xoziKFjlLX2qMj0
         M6xmjM9/Jk0A1RECuqoQka4ZTCNlXFDrsVXxnPyzVZdhAzv/LQMdQIdWPdKB/SkmGxJM
         H1MOMWidVptv2XisY1Rc5Lf8HLKZqLKOriKH+5MbJA0SEopGjDhYKCDJFUdyyZC7TBET
         MDFg==
X-Forwarded-Encrypted: i=1; AJvYcCUhUVxnKg0tc0fOt2c5fLVLf+YJuHfz6SitXicwt4PUqV/hWSAiiMMOTOBiBE/DTUXAFCQ6vIm+6r6w@vger.kernel.org
X-Gm-Message-State: AOJu0YyUH3PCNBkHUcTgB7dhLXad4ea+igTNulO6A2wH69wsSsk1s4Ub
	qTSR5NEejNR3mCuScPkff0x/yLFpWo7T6Vaongs5vJz6RBDHAtvJUU6dbCWtpxpZGxF/BDAHF+h
	wgGZnKE8e6E43sgLhCzAKW6yQdIucA0d63Ri7W+gZsUFV3Y1bmaaGmPF/L4WCl6wB0W7UuqOTxZ
	sRYo88m+U85QJbQZgHDPYj1aDKrf1wwwrTVtyj5g==
X-Gm-Gg: ATEYQzzhYPCJrfQzdjbNLR04HjW5mKdQHFCAsUSbqOVESkun6saXbgRZGGXM6RIqOQ5
	ZdC5xs/udueJTvYm5VELWmc77lPQljcOjsvPo2b22gk+IpK7Ik8bCeVGgG1rhA27OVHDVR/ZAM+
	VgxkvNznlISduLID0GVwYREdD3XcOcaV+h3ashJfb2TFy9MAA0ne1T+tnp+JAfJ/V5If2j0VWEy
	3LkfYY=
X-Received: by 2002:a05:690c:89:b0:798:67be:f8fa with SMTP id 00721157ae682-798854ef3aamr139425757b3.17.1772529541165;
        Tue, 03 Mar 2026 01:19:01 -0800 (PST)
X-Received: by 2002:a05:690c:89:b0:798:67be:f8fa with SMTP id
 00721157ae682-798854ef3aamr139425527b3.17.1772529540751; Tue, 03 Mar 2026
 01:19:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1771986861.git.lucien.xin@gmail.com> <e49a24b97a25a9c25bd33411b8212978dd566bd3.1771986861.git.lucien.xin@gmail.com>
In-Reply-To: <e49a24b97a25a9c25bd33411b8212978dd566bd3.1771986861.git.lucien.xin@gmail.com>
From: Paolo Abeni <pabeni@redhat.com>
Date: Tue, 3 Mar 2026 10:18:49 +0100
X-Gm-Features: AaiRm53rJ3wV-QBG6V--xu4Px23a7wXyR_Jsp_m9nNP5uOat2VsXjJ9xQsdj7Tk
Message-ID: <CAF6piCJDWjOmgkspuk28qAF8+9xj_o-zTXkUdB+3_waZqaMXBA@mail.gmail.com>
Subject: Re: [PATCH net-next v10 14/15] quic: add packet builder base
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, quic@lists.linux.dev
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>, 
	Simon Horman <horms@kernel.org>, Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, 
	Tyler Fanelli <tfanelli@redhat.com>, Pengtao He <hepengtao@xiaomi.com>, 
	Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
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

On 2/25/26 3:34 AM, Xin Long wrote:
> +/* Transmit a QUIC packet, possibly encrypting and bundling it. */
> +int quic_packet_xmit(struct sock *sk, struct sk_buff *skb)
> +{
> +     struct quic_packet *packet = quic_packet(sk);
> +     struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
> +     struct net *net = sock_net(sk);
> +     int err;
> +
> +     /* Skip encryption if taglen == 0 (e.g., disable_1rtt_encryption). */
> +     if (!packet->taglen[quic_hdr(skb)->form])
> +             goto xmit;
> +
> +     cb->crypto_done = quic_packet_encrypt_done;
> +     /* Associate skb with sk to ensure sk is valid during async encryption completion. */
> +     WARN_ON(!skb_set_owner_sk_safe(skb, sk));

This is the TX path, how can sk refcout be 0 here? Possibly use
skb_set_owner_r() directly? At least use the WARN_ON_ONCE() variant and
add a comment documenting why is needed.

> +     err = quic_crypto_encrypt(quic_crypto(sk, packet->level), skb);
> +     if (err) {
> +             if (err != -EINPROGRESS) {
> +                     QUIC_INC_STATS(net, QUIC_MIB_PKT_ENCDROP);
> +                     kfree_skb(skb);
> +                     return err;
> +             }
> +             QUIC_INC_STATS(net, QUIC_MIB_PKT_ENCBACKLOGS);
> +             return err;
> +     }
> +     if (!cb->resume) /* Encryption completes synchronously. */
> +             QUIC_INC_STATS(net, QUIC_MIB_PKT_ENCFASTPATHS);
> +
> +xmit:
> +     if (quic_packet_bundle(sk, skb))
> +             quic_packet_flush(sk);
> +     return 0;
> +}
> +
> +/* Create and transmit a new QUIC packet. */
> +int quic_packet_create_and_xmit(struct sock *sk)
> +{
> +     struct quic_packet *packet = quic_packet(sk);
> +     struct sk_buff *skb;
> +     int err;
> +
> +     err = quic_packet_number_check(sk);
> +     if (err)
> +             goto err;
> +
> +     if (packet->level)
> +             skb = quic_packet_handshake_create(sk);
> +     else
> +             skb = quic_packet_app_create(sk);
> +     if (!skb) {
> +             err = -ENOMEM;
> +             goto err;
> +     }
> +
> +     err = quic_packet_xmit(sk, skb);
> +     if (err && err != -EINPROGRESS)
> +             goto err;
> +
> +     /* Return 1 if at least one ACK-eliciting (non-PING) frame was sent. */
> +     return !!packet->frames;
> +err:
> +     pr_debug("%s: err: %d\n", __func__, err);
> +     return 0;
> +}
> +
> +/* Flush any coalesced/bundled QUIC packets. */
> +void quic_packet_flush(struct sock *sk)
> +{
> +     struct quic_path_group *paths = quic_paths(sk);
> +     struct quic_packet *packet = quic_packet(sk);
> +
> +     if (packet->head) {
> +             quic_lower_xmit(sk, packet->head,
> +                             quic_path_daddr(paths, packet->path), &paths->fl);
> +             packet->head = NULL;
> +     }
> +}
> +
> +void quic_packet_init(struct sock *sk)
> +{
> +     struct quic_packet *packet = quic_packet(sk);
> +
> +     INIT_LIST_HEAD(&packet->frame_list);
> +     packet->taglen[0] = QUIC_TAG_LEN;
> +     packet->taglen[1] = QUIC_TAG_LEN;
> +     packet->mss[0] = QUIC_MIN_UDP_PAYLOAD;
> +     packet->mss[1] = QUIC_MIN_UDP_PAYLOAD;

The magic number above looks quite obscure, and AFAICS looking at struct
quick_packet comments have different meaning. Please use some macro instead.


/P

