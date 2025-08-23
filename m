Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378E812B93;
	Sat, 23 Aug 2025 15:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755963665; cv=none; b=DwNDbkqiQu29E25OPjimJMca4FdNl53nVdIVIzF92yvg8SC8PVjyRY3XQbDkQpTD2xEPXixVKN9BgHEPStQlm7ue4ZUxNRwQKbl788gb/r9fByauIE4nKe6TIHVgEnOQnv/JmFnNw0GhASXUnhvuOmQmjcNyKeEuSsm82FsMtSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755963665; c=relaxed/simple;
	bh=6iU2aynSLSee+E5Dopkej0Rgy69kifMRkgq2/0PXcH8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SuXcBxlYGy2jcKuaYlbMwiBln7fwd1/iLfdJo7IuBAXI79OG4ToXL6ogbpZUWptJKHtnJzFUdqu+e25audmHytpmcAstyD84Hv/TKSQvwr5rjDKNGDe74mM3oma/U7WXvnFuYdjjKHzEuxSRSW+4Gpo3yJse+3BJbiVidzDGStU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YL2mtwNG; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YL2mtwNG"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3e7c238bc0eso10295535ab.3;
        Sat, 23 Aug 2025 08:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755963663; x=1756568463; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GK970f6W8v3dUSj26yOJRFemswkS/yBYwR0vBetrEbo=;
        b=YL2mtwNGAm4BkWOAfJnPVvW2/MImqlbz1VBii1qL2v16cb7GuT1Uo0FmAMs6N+b5Xp
         yvcvYiS7JSpUIxbHw2JR8/+FVKsu9KFNDxbU1TuOAjoIbdL55N9YZluL4lLICe01i5Sa
         ruFDH3C+821dS1Dobqvw/Agd3OSV+n6m7ul9KWZz41UeeMeYIiFr7XO+TdizzBW8RSW8
         wZ2/HqJwcJRzie4kIg0Qoc9MPjbuKb8QcADBENX3t3dTg7u+yWDIGFVRODbeI08q866u
         ZZbvJ1+A49PVWJtz0wSSRg/9xAF4h8Q+oQicmt4okjUEpxrxCj1BLINTvJPQad16ptPm
         Anuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755963663; x=1756568463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GK970f6W8v3dUSj26yOJRFemswkS/yBYwR0vBetrEbo=;
        b=g+6DirlkdTL8OimIhOcBGwbUpF6qT17OyHD3jhf8UVYNHuoWnIEwnm97VngIW4d663
         1srymoLBMJP+q655A8RHBqAY4f4HNJLz0NPKc+yqQmU+8iv9prFZw+9HZRvJK4zEJprz
         cL7nCP7MuS+ui3CgtNxVH75WS+EHfMOqB5lxzyNVgAhSJS8svptKxCUdMpHmKo5SVpwY
         CAy9mWWSoC3xx/s/OQqHGlJHJCEAzy1By5ptG/dEDb+g5KBVfzjbWr0U0MH8R4gY8eUZ
         pQy1S17o8GcBbNoMcE8TEuM+116jINcsclVJzLokpzjizw73CKgmY+pBs8yP1KDSVYXi
         d1pA==
X-Forwarded-Encrypted: i=1; AJvYcCXqW8rPWOrwUZCc2b5H0VkowKk1e4V1HbQxmlIOteZ8zjPJtegKHdDNmKSQ6cjZdcOaKOObtaZeErHF@vger.kernel.org
X-Gm-Message-State: AOJu0YyiNmt2Qvc8Pl3uwTTojKHKyY1njdJo80CMj4rWXqcZjvyhDiPn
	NJg18fDafJ3jWcs21FJwVvROmeCSy5BYG04qad+S+Ns/Wx9HN/Y9Gomjiy8YEUTGuAB/8TuLHDp
	oxYl6FthjDC/5EEFZqngPY0TeBWsJucI=
X-Gm-Gg: ASbGncupcZRfAODg3QlciLOOrAEAqzanuZ0cBQg4MFc/rDrAOIIfZ5+L+ahuR99Wckt
	tQ63eh069FFPjjjqdk/EddBBuvHosRidNEE/hd2xuf63mr+MazS4H+VsqoSOKxJGFdoS+d9SSqC
	W6c7fgYI9yjQu4WfVU00wWkgjajakQ06wBpv/XvQgirpc9JB8nx5retk8INhc3CJsIalXfJP1kO
	qu2WaeZnA==
X-Google-Smtp-Source: AGHT+IESYRh8i7xlc71145sLwSk6o7jgXXpkeEyxFOYt+GdWSWEwp55HWkwzH5gnJnP9Y4VANKPEMbZ8VhasRb2Fw20=
X-Received: by 2002:a05:6e02:1541:b0:3ea:9da1:b653 with SMTP id
 e9e14a558f8ab-3ea9da1bb37mr37217535ab.16.1755963663223; Sat, 23 Aug 2025
 08:41:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755525878.git.lucien.xin@gmail.com> <507c85525538f0dc64e536f7ccdd7862b542a227.1755525878.git.lucien.xin@gmail.com>
 <a45ba272-685f-41dd-8582-6bbc5bc086bb@redhat.com>
In-Reply-To: <a45ba272-685f-41dd-8582-6bbc5bc086bb@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 23 Aug 2025 11:40:52 -0400
X-Gm-Features: Ac12FXzb4OuOZTD0SjAL8bodcf6jguLEYM91QZYQC9_n7a90QBtcGXoJbtIyI_M
Message-ID: <CADvbK_eLTAQkFPNF58fBRqeZzRycBX0EeNk-P=HPc+Z-__JU9g@mail.gmail.com>
Subject: Re: [PATCH net-next v2 08/15] quic: add path management
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

On Thu, Aug 21, 2025 at 10:18=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wr=
ote:
>
> On 8/18/25 4:04 PM, Xin Long wrote:
> > +/* Lookup a quic_udp_sock in the global hash table. If not found, crea=
tes and returns a new one
> > + * associated with the given kernel socket.
> > + */
> > +static struct quic_udp_sock *quic_udp_sock_lookup(struct sock *sk, uni=
on quic_addr *a, u16 port)
> > +{
> > +     struct net *net =3D sock_net(sk);
> > +     struct quic_hash_head *head;
> > +     struct quic_udp_sock *us;
> > +
> > +     head =3D quic_udp_sock_head(net, port);
> > +     hlist_for_each_entry(us, &head->head, node) {
> > +             if (net !=3D sock_net(us->sk))
> > +                     continue;
> > +             if (a) {
> > +                     if (quic_cmp_sk_addr(us->sk, &us->addr, a) &&
> > +                         (!us->bind_ifindex || !sk->sk_bound_dev_if ||
> > +                          us->bind_ifindex =3D=3D sk->sk_bound_dev_if)=
)
> > +                             return us;
> > +                     continue;
> > +             }
> > +             if (ntohs(us->addr.v4.sin_port) =3D=3D port)
> > +                     return us;
> > +     }
> > +     return NULL;
> > +}
>
> The function description does not match the actual function implementatio=
n.
Right, I forgot to update the description after moving the creation out.

>
> > +
> > +/* Binds a QUIC path to a local port and sets up a UDP socket. */
> > +int quic_path_bind(struct sock *sk, struct quic_path_group *paths, u8 =
path)
> > +{
> > +     union quic_addr *a =3D quic_path_saddr(paths, path);
> > +     int rover, low, high, remaining;
> > +     struct net *net =3D sock_net(sk);
> > +     struct quic_hash_head *head;
> > +     struct quic_udp_sock *us;
> > +     u16 port;
> > +
> > +     port =3D ntohs(a->v4.sin_port);
> > +     if (port) {
> > +             head =3D quic_udp_sock_head(net, port);
> > +             mutex_lock(&head->m_lock);
> > +             us =3D quic_udp_sock_lookup(sk, a, port);
> > +             if (!quic_udp_sock_get(us)) {
> > +                     us =3D quic_udp_sock_create(sk, a);
> > +                     if (!us) {
> > +                             mutex_unlock(&head->m_lock);
> > +                             return -EINVAL;
> > +                     }
> > +             }
> > +             mutex_unlock(&head->m_lock);
> > +
> > +             quic_udp_sock_put(paths->path[path].udp_sk);
> > +             paths->path[path].udp_sk =3D us;
> > +             return 0;
> > +     }
> > +
> > +     inet_get_local_port_range(net, &low, &high);
>
> you could/should use inet_sk_get_local_port_range().
>
True, will update.

Thanks.
