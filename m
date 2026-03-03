Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DFE6FC3
	for <linux-cifs@vger.kernel.org>; Tue,  3 Mar 2026 08:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772526190; cv=pass; b=R6iR7OI8bfsKhqQ0Aei08rAZ+BH8R9L2PUreNL7InE6J46ilQKKSlEgAv4ETq+gujk1FYT5yiZXE95rlko0CqerJ+cHj8yk/SeTiSaQ6m0uOo2BYnSo7C/krQfdIQZYzIXUxuusRdwlyBt4cd/zqPKt0Jo2d1A89beAAQ+hF3dw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772526190; c=relaxed/simple;
	bh=FIcra+QdGWbVK7dEeENktNZZV+zMM40tLcIz85kVF4E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F3QubmX9hoZuLf9tWMfjffyak4FrbCTMld21dHI2kCzJZgK3tjfFkak5XmkhNTr4oXl0C/sJggT01fc3Whi/8VPuBlxk10wkGdv7wAwF1p2olmlAzGk4vhtjeBG9h9bHp+P9JAaM2/464FNcR3KTVkqGWG71PUW4MCRfzSoczTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X0tvKrBs; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dz5ZPSTz; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X0tvKrBs";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dz5ZPSTz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772526186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bNVvSG62xl9Jk3X2cnvC9Xwc7/DlqVbGbtIj6kzPkCk=;
	b=X0tvKrBso6l3yTBz8ynidhn9/1LAllAolU7cXdnpZWZhDQmHxOJ2inQCyFNu+Y6ABFN3vs
	QGlU/cIJJrLRq0Wx02jYQxBpk6u1ZGyQA8QR3lRRz58rJnMH+Pw8eSqT50qV60ERgkiKW1
	IWAGWRasmpL9AxaK0/hv30st3uswKrY=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-416-ulN16J0EPSeBbzTJfT8xrw-1; Tue, 03 Mar 2026 03:23:05 -0500
X-MC-Unique: ulN16J0EPSeBbzTJfT8xrw-1
X-Mimecast-MFC-AGG-ID: ulN16J0EPSeBbzTJfT8xrw_1772526185
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-794b74a8b2bso71260207b3.3
        for <linux-cifs@vger.kernel.org>; Tue, 03 Mar 2026 00:23:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772526185; cv=none;
        d=google.com; s=arc-20240605;
        b=XLfC1MY3Hy+u+xp00onSOff/Y4tT4BG31BTJnEkzHukUvb5YNQBqLECnByqoS7a9io
         iT8Nv07NMMvTibJwzZTYvIIKzSm5csndJizGwvaB2Fx2PEh2iCHXIsekjuH36m1QVWnN
         y+MUznvR0IXkr+1izJLtZwaAn6+nWm/wldh9SfZzknWvEBhmxk9vOFy3UHTaBOvxRfad
         7KJ9GXVBDonoOMHQZX/GSftqVnGGvd2KFNykxZeNi0AhBCUYtSs92KRYTx0CJHG+wHh2
         KGikYIcNSLGkvc+O03ZFIWCZ1q65sfOIC7ZxoQrkxZLMb6l2CM6oBHBnBaax466cD8Mv
         RZYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bNVvSG62xl9Jk3X2cnvC9Xwc7/DlqVbGbtIj6kzPkCk=;
        fh=oPgD4K4S+llXh+siup9FJ4n/ml7/zdzhb1x7Ed2tsow=;
        b=kfQQFz+2Eveb68AC5TPg9hYNd36ZaBQbllr9J+QSYk1wo1QQs0b9Ks+w5uLKT5JuG5
         DwmGdACLtD+i+hlPBcQLGB0E8JLOgObgqHPpLRxyPzGVXVKlqhO4abRwIT2l6m/1KLeH
         RmmpiTJw6bCfcFSO0jUlDYf6AWfRid17XHOv2ZjMzBnWWoYTVS79IcqJKKc/4VVuvnxK
         QenvRRNjidRHR2ELdJusVtzAU79UhIG/q/5RRPNdNsPvzwuhtHHydRb1/gkCxma92yCI
         wmrPvM7Cud+ZgyiMkxCCY23FJIRm0L+PwQF1XBlD3WP/Wz+OsbRSoJhTdAWSsdJCw8BU
         rkLw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772526185; x=1773130985; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bNVvSG62xl9Jk3X2cnvC9Xwc7/DlqVbGbtIj6kzPkCk=;
        b=Dz5ZPSTzB1QnHShb7H3duoiabAMi1QRIPPx2HelXRQwedTnemV1ufDLx5vFCk2pWHy
         2szjC+W9eOL36AtP77ka72hSc0PLAEDGOhEe83rydjgx0tLS1Y/znmh3mncsP4SWZU4w
         4JTLqNVrLGpngTAfTiW9oYOnZqbv+C9tDA6Jq8TP67wgETh+xnVH9knxSeR2kRyyvMa6
         uAArwaSYPlMLXMbEOzSa+i//t4gI3VdHwTPBV7IzCxwdDcQKthgzIsRx4euOrqCPmgao
         ZJzPQ+N1mWYOQnKeqq0zXApN4c1OV/BuNVaQpRC657XLjUW1umc7uQGswkU1XZl9WoVz
         rDwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772526185; x=1773130985;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bNVvSG62xl9Jk3X2cnvC9Xwc7/DlqVbGbtIj6kzPkCk=;
        b=nJTw8EkHp1dS+jr1w4zhCx/EbT80TYTpP/3Vkbi9r7l8k+r1IsUyFJ50w7GLjaLFbh
         N6ZgsblQj8H4lzSEjmWiecUrJQWnE35MMKayFRq5dsLNK767FjBk1iFWLvcmQSZzfPRg
         QOzW0qwusa7OAiJixX+xwOgAw7kd4XfI2tp+n1NijqMjWSG6gFxWsguuhd0bysUETgRV
         b0vRMg4K6mEs7KXW9/4WEX9NO2aN1qpbLfCSAO+EWsc9GG0EMnmJZdujCuRAiDzMShwn
         OBvNLjS/Rjp2ZbbsQKcMDOOugMlwaxVZecNPflduKEt4wPZudg9Xh+WQOy2FDFnzyV3W
         auYQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0vsPPreeeoQAiM906l8g0TzX+SDDPfwLqTKyjGUURIHEAU4Uo0RVq3W5fadTTpm9cHoZGN6MQSI/+@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9UHUD9qoLDb8yIoZlXsVQzoejzoUVwrhFv5FBmVUqmrQK/5V3
	7n2J+cpbE6cqVlwTwKRMHuoBSYBPneF/8dDnJTOSfIDlevyPHt/+3u7ddbUnm77nqb4moD7Ju9g
	0rE3QlulUzT7UPKE+LSV7+eeHspBOsPb+k60zIJu5SKLzxxlLBovj0S8SeC43RQxjOZudeUPUuC
	oaGQ4+NjquQGu44wVs3bqAlBWGDRjmp9bUVqjXfg==
X-Gm-Gg: ATEYQzyDgFZA+hNkfzuwaDRauZphkpPUIbRQ18CZSbMp40l+rAtftFWJjLds6NVgca0
	Q1vNzbMUxVzMB2trBOIyCwsEjfD6TppLZXyS2rCWvq73Lte1hzE6EipyxJrGj2hHR+gnImlJUwH
	ewuUbaB5hethZ/AskObzf4tloNEfbViIU4tojjzpTE+BGzFzoJybgxEzGSDPJaR762Fb8d98DZx
	2M9rZw=
X-Received: by 2002:a05:690c:4b01:b0:797:a162:f7c1 with SMTP id 00721157ae682-7988547cfe9mr125761017b3.16.1772526185024;
        Tue, 03 Mar 2026 00:23:05 -0800 (PST)
X-Received: by 2002:a05:690c:4b01:b0:797:a162:f7c1 with SMTP id
 00721157ae682-7988547cfe9mr125760857b3.16.1772526184694; Tue, 03 Mar 2026
 00:23:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1771986861.git.lucien.xin@gmail.com> <4e03deebdc944d9c963b0732abe8ba631893d82e.1771986861.git.lucien.xin@gmail.com>
In-Reply-To: <4e03deebdc944d9c963b0732abe8ba631893d82e.1771986861.git.lucien.xin@gmail.com>
From: Paolo Abeni <pabeni@redhat.com>
Date: Tue, 3 Mar 2026 09:22:53 +0100
X-Gm-Features: AaiRm53wLfsp6dwR6Y3kD8_sIr5QwiEb9N3a51XBSB8vMJnsYCaEYRcNMDa3ON8
Message-ID: <CAF6piC+W=QKU53vix1f8JxxFhRKCcMvXaX1NKBT3kcZLfCydEA@mail.gmail.com>
Subject: Re: [PATCH net-next v10 08/15] quic: add path management
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
> +/* Binds a QUIC path to a local port and sets up a UDP socket. */
> +int quic_path_bind(struct sock *sk, struct quic_path_group *paths, u8 path)
> +{
> +     union quic_addr *a = quic_path_saddr(paths, path);
> +     int rover, low, high, remaining;
> +     struct net *net = sock_net(sk);
> +     struct quic_uhash_head *head;
> +     struct quic_udp_sock *us;
> +     u16 port;
> +
> +     port = ntohs(a->v4.sin_port);
> +     if (port) {
> +             head = quic_udp_sock_head(net, port);
> +             mutex_lock(&head->lock);
> +             us = quic_udp_sock_lookup(sk, a, port);
> +             if (us) {

When the quick socket is already bound to a local port, reusing an
existing udp tunnel sock is allowed, but when the quick socket is not
bound, UDP tunnel sock reused is prevented. This looks confusing and not
documented, please clarify the behavior and/or make it consistent.


> +                     if (!quic_udp_sock_get(us)) { /* Releasing in workqueue; retry later. */
> +                             mutex_unlock(&head->lock);
> +                             return -EAGAIN;

Why not -EADDRINUSE here?

> +                     }
> +             } else {
> +                     us = quic_udp_sock_create(sk, a);
> +                     if (!us) {
> +                             mutex_unlock(&head->lock);
> +                             return -EINVAL;

It's probably better to propagate an error code (PTR_ERR) from
quic_udp_sock_create(), or use -ENOMEM

[...]
> @@ -332,6 +333,12 @@ static __init int quic_init(void)
>       if (err)
>               goto err_hash;
>
> +     quic_wq = create_workqueue("quic_workqueue");
> +     if (!quic_wq) {
> +             err = -ENOMEM;
> +             goto err_wq;
> +     }

AI review noted that:

This isn't a bug, but create_workqueue() is a legacy API marked with
__WQ_LEGACY in include/linux/workqueue.h. Should new subsystem code use
alloc_workqueue() with explicit flags instead?

Looking at include/linux/workqueue.h, create_workqueue() implicitly sets
WQ_PERCPU, creating per-CPU worker threads. Since quic_wq only handles
infrequent UDP socket cleanup via quic_udp_sock_put_work() in path.c, is
per-CPU allocation necessary here? Would alloc_workqueue("quic_workqueue",
WQ_MEM_RECLAIM, 0) be more appropriate, or could this simply use system_wq
if memory reclaim safety is not required?


/P

