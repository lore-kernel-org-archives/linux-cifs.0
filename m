Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A35314D17
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 19:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769715485; cv=pass; b=CBvUp1Ria7f6Sr/kx81m/A+zIk08O8SxvxWU/hnW00kL/aTcDKuV26DZ3AuZSuV3N1SEosBeC6BbCKlXbks1OGoShn1/s0R31qn3kAOs6M/7GGedw0zUODfiIapLAQFLYQyshtZFNsFfo0epG5jpZyEmHrNJWgbwW4Cba8VBdfo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769715485; c=relaxed/simple;
	bh=an23PzgT+ETDMUmkvQg/3z0rXD8Ts/s/wrp73SCQ/LI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y1DIik1ZLtsGb6t9ET4BRL7YK61nKOdOXkgxhFh9969WF3e4X2CoBmxNejp95zo1MD7R/UCG2+2xdtH8bD8DAjKzUAjjUvqDC8ECpBsx+wAq7K4AGd9Mk0+4KB5wD7ofPj1tZey4kCj02i8Wyi2bBLuyLvwFrUJiEkPRAdrqjpU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WYZ6M0pp; arc=pass smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WYZ6M0pp"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c227206e6dcso806304a12.2
        for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 11:38:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769715484; cv=none;
        d=google.com; s=arc-20240605;
        b=Oz4D1HLh8ir+GIl988gZYmaIbOV8LyEBt1puLhUnuebNG1eMRwKzKPXkogI9bVgDoJ
         GOFPX9vx7yeBcdR9XoVmu0N2gfdLB9WrkXEV/xhrgZYelIZfXJes2v/mgrGF+5XJeheL
         aboQo4GzglJ69uIA7puzCFrhx7jB8ZdEnEcVyOwHdNjMXvzh8mYXYaSndJP+DKFWotYb
         nm5ibWjBU4jeNh1eUDbiuEBm6RFje0cIHiRncEVCISoj6GkBpETp0qByqE2w+ImxitBG
         zExENtyvZWTyy4fcwFmoegJ0xF2P/N1X+oYbeI+jSQs3fLPb7tWFv0XXaoIlF7JcOexb
         UvJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8jgscGADAtGExE/c6eNO9k9qz7qLCMhugDMGIDtgfTs=;
        fh=VM1jGCDvtkHiT/0hdftn/gUU7mkFe1+LXL2QoyZPdhY=;
        b=W4YzEoVmW+U32Au9e/Fb8M/r0OOltQV1OLjmAE/YU4Q3c73NSmdOSJ9CcQS5B44lAJ
         vmhbROHOXHYWJ2FtTpRsyLzaUZWW7oXu5NnAHxSQWCBnQPdXJfkJ20VF6b8WiiNVeA2j
         BWsQPSZEP1wQbv9TpLyPT45GAe4r0z2kGtB+X9WZ9Yx4kUQsMc1gsBoOhTHyAjZPJThc
         q1axRX7c0BtXIynxAYjF/EhVCH4XWO/6xWi+etkHAaQu0uzMS0cVLJaDACxeFVIkSsdx
         roO+bfsaqinrYfRr4TTaG8P35RaN7P73J3jrqpnQOvrMLEAIp6+hKAZo/4a3HTzFUEyp
         HL2A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769715484; x=1770320284; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8jgscGADAtGExE/c6eNO9k9qz7qLCMhugDMGIDtgfTs=;
        b=WYZ6M0pp7StBiH0QhCleefLkkUZV63AuuHjsHSdlz5vyyqS5z8ieYx2NGEgq/4rEbq
         O1hdHOHNdjzMWb2CsfCfG08SjPoJURiem90RbFKrMCruqynrKovrOFV30g78NEDDDiF6
         70Ty8ggEZPPKvKsNKzp9Ib2jva9Yg+9uDn6vEu/X/UTAhvwq7J490DDnbAdhHbm+ZWcv
         COeewiSJoU7mxEglT929POlgK2P/6kJ5Fnu9RjkFFZJn6uk/qNlU60j6UCFyJjI7eTHj
         ph3cLx3KTt9hS1WQoEKmrKP9MehBM9Vxjx/Q1tEs3amPNny9oPn+Uu3J2hELQWRJz2Ka
         1fBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769715484; x=1770320284;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8jgscGADAtGExE/c6eNO9k9qz7qLCMhugDMGIDtgfTs=;
        b=bbJ6RE17KkdWbbVDMAI+pYEFNuMa0tzvySJC/Uc4xxUWGOdCN2ZRmnxDJkqYrqTIlM
         CYOUSQcARheRHqcNv1FY7nLVISqj97CWix3SqqXCpCgE29IzS8iqlo4T7ITeeZHk73lj
         pD3/KlGXOzLSfTPpr7M3UatzMESZ/y9CjsxJzLWvmGG6VBh5Ugr4rMtDYMEVKz1PHgHI
         Lpc91zJcc1WYIFNLyYPCQLDxl7PB8oXYIHkXNoFrTENfn8omaRkTiljYuUyIotN+muPF
         hkZyqYCTNCLE9t8IHEQ78y1C5AIB/ic/3ZzZ6JjuZpOCfVfgcnQ7DMgJf7cIhOAtJWrg
         h3+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUsF+Xnzo/iUBztqUq4YMs60cDwxWRprZfH0k2+tQJ8dffNMf4sc/FEO6NS8CrQ1Rn7prWay22SlxwU@vger.kernel.org
X-Gm-Message-State: AOJu0YwxxW19XE+Vvql/O37Wpw7n2WvUMRq6RA0KF+krcHQSio7WCcq8
	TjalQ7EDnLZxGkM56L+hym1jR0xa6QFoy2yEmQ4nvi7e/0JwKTmMKeF01mHJUsrstjPjWHH/8D5
	+JcAougyKmWkTZfnYre7Q8QJeOWhrKOo=
X-Gm-Gg: AZuq6aJiXA95JQbPKzoILDKBlPRevZQ6xasOqsyHO+1p4WXP32PwrC5jjm2J/vRs2kj
	yolmrKLvN8tN1IwtILPegCqLCDSEikk+Q1OTi2GaCM0LkcMAoOocsT+XBmOzCD7+TgGDPGq0v7E
	zmCRY+tGqq62KHle+gICotK49fYj9D1zd5jwDe4viHphx1+/XTifvw1KaUw1B4Li3WVOyR933bh
	+ysoYoqaIe/odjeuuYPUnsyd0zHTNbgXEUlvBYaK2mOdUjKDe8c8XsZUYgkvkY0owY9moYPDSXe
	SqFpstnuFObotDcXK6yvp96nY4PMsC2Y5W6UIiMg
X-Received: by 2002:a17:90b:2e10:b0:32d:a0f7:fa19 with SMTP id
 98e67ed59e1d1-3543b39c961mr584686a91.17.1769715484009; Thu, 29 Jan 2026
 11:38:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1769439073.git.lucien.xin@gmail.com> <46f93cbee41da1e1f7b7f408b17915fd93b39ec1.1769439073.git.lucien.xin@gmail.com>
 <bbbaf4e5-1c31-4c84-adb4-dbb94b8d07f4@redhat.com>
In-Reply-To: <bbbaf4e5-1c31-4c84-adb4-dbb94b8d07f4@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 29 Jan 2026 14:37:51 -0500
X-Gm-Features: AZwV_Qjv2qurpUKIB7y-u0yeOaDoaz7ma2YS0Xi_VtbJ92jOQ4X9Nw-fNxtkIAs
Message-ID: <CADvbK_eHu0=8G7--neMHz5CDT4_MV-MONRu8obOsYbUhCc1ocg@mail.gmail.com>
Subject: Re: [PATCH net-next v8 15/15] quic: add packet parser base
To: Paolo Abeni <pabeni@redhat.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>, 
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
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 29, 2026 at 11:53=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wr=
ote:
>
> On 1/26/26 3:51 PM, Xin Long wrote:
> > +/* Lookup listening socket for Client Initial packet (in process conte=
xt). */
> > +static struct sock *quic_packet_get_listen_sock(struct sk_buff *skb)
> > +{
> > +     union quic_addr daddr, saddr;
> > +     struct quic_data alpns =3D {};
> > +     struct sock *sk;
> > +
> > +     quic_get_msg_addrs(skb, &daddr, &saddr);
> > +
> > +     if (quic_packet_parse_alpn(skb, &alpns))
> > +             return NULL;
> > +
> > +     local_bh_disable();
>
> Is this really needed? If so, it needs some comment explaining the
> rationale, otherwise please drop it.
>
It was needed, as a spin_lock use in quic_listen_sock_lookup(), now
it's changed to rcu_read_lock(), maybe I should drop it. will double check.

Thanks.
