Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DE11ADC69;
	Sat, 23 Aug 2025 17:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755969783; cv=none; b=ZHvYV+xtdvm71kGpTnotfpBdr8s7FOFqLKKDKcak/X5s0fQE9dHxM9w/zwAslYx1Z3yjbuRdV8VO7w7PSEMDD3a9RjImj0e/Q1k01++6dynOGCflswolPCUQDSAGPQiy00p76yTXybSSi8aMxxTJSi2mYmo2/K30bnkFFkvfN5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755969783; c=relaxed/simple;
	bh=y4CJ7pNPLS1ZJkKwumtvhMv6UuLq5y7tWRpXPjkKtcg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kcGip52b0KFlKHxd4GvQMrteoFcXNAEGJnghyBx+J638rz718Lgy7IA+KYajSh6atmnDK+hfqlX+zGBwsWnTxPsuaW6a++TROaKg4mMrh/3kpWHTk53cs9C+Er+o8V5jhuoFpMw/nMzy+gxnRSyelcIkhsqQCUug84PzuyA9WWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J0xW+nJ9; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J0xW+nJ9"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3e66c013e4dso15933985ab.0;
        Sat, 23 Aug 2025 10:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755969781; x=1756574581; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wgTr60nA3z5wWgqDNNxThiGUeORtD2/iVsCPnp7jsKg=;
        b=J0xW+nJ9NITkivdd07NJtE6Ho5h5nLl40UW+fzmyjbblWCff7/TATr7HKCjek6elpI
         gYBdhy/xck94OGfAsLwA1s0nJE23sOhflCrrWcSNTseJdwqBUlZ2Eouizp7T49W6xC6M
         y6rdH5NftLv7FPd27a3vUAvcM7AOoWkQekeBaNkK8fW085OlKPlyRk6u2cepLFKsSJFm
         +rvnHfDY9QA+WtMI6iDIZzChNdlKHVl9EKMGuyqLGLcgHJhiBgY9x4DS569DZsPTwsN4
         A6Dfz6nfhWsw0gBZ4f+vqHhlj79vQZTHB5/WVvaSuuPTmhDcXJkvb2Wn2T1aIMwOqlP3
         OSmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755969781; x=1756574581;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wgTr60nA3z5wWgqDNNxThiGUeORtD2/iVsCPnp7jsKg=;
        b=kQ40b+1qe3QmUQW6zllU0FI9+zALxJ9FfKyQ8xHHZ7ijzJPdTuu0qiNGAeEo5IJJcF
         wT1mLbijzfuW9GC0KVJOZm57GFm1DK6bQD9YDaXxk1fWlETdQWiQ8TjW9EkhiAxgZrVi
         pTLFam9Lycu2qmP/IWQAZpPwXzq5GrTPwNhySohA5/T1t8to4EhRCYkPOz4wJJSjP44i
         RYXoxrl5ztwSRJHb+LkTpMJautSspUPWBM2uBYTHynrMRUw2sZoJQkfuMb/pT4I3ioUG
         riRewpp6l28uvVik59bMMx0h3AufOm/c7JgNG2zrrZdcoZj7rhuqrO+h7X9aAxMN6IpH
         IteA==
X-Forwarded-Encrypted: i=1; AJvYcCXjJjksaWuWBkPx942ClyCsYFzuSnoIGVq+M88v1a6JiaPDS6dpbSEIhRXeA+Yg4uwyf/YAm7KXuigX@vger.kernel.org
X-Gm-Message-State: AOJu0YyGhPkfyWlTjBFDmm+5MexaH3raRqnJmo3x8pGzod+yH1tlFGzk
	oHD/rN+khsbqJVvt31OIsJjKmrdVE+Fu3uVaRcT6IKDWdDyUkqRsEpPNgVcsyEJuSrNZ49QNAV9
	hyq1g1JXkeaSZhG567+U9mIgKIkGuUNs3ltWDn98=
X-Gm-Gg: ASbGncsJOT5uNzqsdtWuTABcBUe3pWeGWPdovYbyP9V1EF3EiPwSwPdDKPMLj1j8x2e
	RrYFkrsCCxykJ9MwSq7BLW1Cf/bwmmh15WsIKDHif4iMPJVkxTiXG20wybTdwZHAHJtyjLiUVOI
	7wK+JpOhO7HudwFEnQFLcit90vdMFWAXbP5RgJRjRfJirTjpwRhg8rPSqK/t3n8Jz3qPUTrYJdT
	qkcXDjbiw==
X-Google-Smtp-Source: AGHT+IGDgzVnlVzscvJnBG9FDE4WcKIMgwBQ1Jf4FgB0cD44iHYsBoMuVfqjxn2nGhLnAXbFA3c3w6iRsS6DBkXvPJM=
X-Received: by 2002:a05:6e02:4801:b0:3e5:8113:35e1 with SMTP id
 e9e14a558f8ab-3e6d6db51ddmr154390015ab.4.1755969781042; Sat, 23 Aug 2025
 10:23:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755525878.git.lucien.xin@gmail.com> <d208163af2fdd4c6ca5375e1305774e632676e5b.1755525878.git.lucien.xin@gmail.com>
 <7cfc62a6-b988-400d-829a-306211e1a156@redhat.com>
In-Reply-To: <7cfc62a6-b988-400d-829a-306211e1a156@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 23 Aug 2025 13:22:50 -0400
X-Gm-Features: Ac12FXyjyvvegt8T5QIUSsiqZo6sbk8kkevKDzpi0oloLzoWFmErRK2Y5unTX94
Message-ID: <CADvbK_cMDaSXcDC-iR_5dqPaz4O8o0mzYvNC+akQJyMzXnGq5Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 04/15] quic: provide family ops for address
 and protocol
To: Paolo Abeni <pabeni@redhat.com>
Cc: network dev <netdev@vger.kernel.org>, davem@davemloft.net, kuba@kernel.org, 
	Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Benjamin Coddington <bcodding@redhat.com>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, 
	Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, 
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Daniel Stenberg <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2025 at 9:17=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On 8/18/25 4:04 PM, Xin Long wrote:
> > This patch introduces two new abstraction structures to simplify handli=
ng
> > of IPv4 and IPv6 differences across the QUIC stack:
> >
> > - quic_addr_family_ops: for address comparison, flow routing,
> >   UDP config, MTU lookup, formatted output, etc.
> >
> > - quic_proto_family_ops: for socket address helpers and preference.
> >
> > With these additions, the QUIC core logic can remain agnostic of the
> > address family and socket type, improving modularity and reducing
> > repetitive checks throughout the codebase.
>
> Given that you wrap the ops call in quick_<op>() helper, I'm wondering
> if such abstraction is necessary/useful? 'if' statements in the quick
> helper will likely reduce the code size, and will the indirect function
> call overhead.
I'm completely fine to change things to be like:

int quic_flow_route(struct sock *sk, union quic_addr *da, union
quic_addr *sa, struct flowi *fl)
{
        return da->sa.sa_family =3D=3D AF_INET ? quic_v4_flow_route(sk,
da, sa, fl) :
                quic_v6_flow_route(sk, da, sa, fl);
}

>
> [...]
> > +static void quic_v6_set_sk_addr(struct sock *sk, union quic_addr *a, b=
ool src)
> > +{
> > +     if (src) {
> > +             inet_sk(sk)->inet_sport =3D a->v4.sin_port;
> > +             if (a->sa.sa_family =3D=3D AF_INET) {
> > +                     sk->sk_v6_rcv_saddr.s6_addr32[0] =3D 0;
> > +                     sk->sk_v6_rcv_saddr.s6_addr32[1] =3D 0;
> > +                     sk->sk_v6_rcv_saddr.s6_addr32[2] =3D htonl(0x0000=
ffff);
> > +                     sk->sk_v6_rcv_saddr.s6_addr32[3] =3D a->v4.sin_ad=
dr.s_addr;
> > +             } else {
> > +                     sk->sk_v6_rcv_saddr =3D a->v6.sin6_addr;
> > +             }
> > +     } else {
> > +             inet_sk(sk)->inet_dport =3D a->v4.sin_port;
> > +             if (a->sa.sa_family =3D=3D AF_INET) {
> > +                     sk->sk_v6_daddr.s6_addr32[0] =3D 0;
> > +                     sk->sk_v6_daddr.s6_addr32[1] =3D 0;
> > +                     sk->sk_v6_daddr.s6_addr32[2] =3D htonl(0x0000ffff=
);
> > +                     sk->sk_v6_daddr.s6_addr32[3] =3D a->v4.sin_addr.s=
_addr;
> > +             } else {
> > +                     sk->sk_v6_daddr =3D a->v6.sin6_addr;
> > +             }
> > +     }
>
> You could factor the addr assignment in an helper and avoid some code
> duplication.
>
Right, I will add a helper.

Thanks.
