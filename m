Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077352EBBA1
	for <linux-cifs@vger.kernel.org>; Thu,  8 Jan 2026 18:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767895676; cv=none; b=EuvU16PRNzttfmUGiHXlHYyXg/8TN6UqFLlqeyYbS/u3KWR5Ph/V03TVr+akAKZRstFRtOYy5TnkXC8nS64GIvrlHZ8IjqxnefRXsDVB7ntAuNBLmLO5DBuwL51/1YpVbPTGqOgGZUG1uOPJbGgi1t+G2dAn5q0nEv2y5/53n7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767895676; c=relaxed/simple;
	bh=eFlE0EEPfk3rewZOji/LmMkHrW23JLC2qQUHwRdkLWA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vEFsYPdO0uFBb0ECwpv0pj/828eZMgqicwTNTcwHFoEGySY6gzZ40Onb9jmBx7EPXIlgyojh3J6RUepRiIv+bWwXA4IcPsKuREudWRrlcFdW3C/2x4my2YgNkP0MCMrrkbY//pJBcylflAC7gqaW+sCy2s+ox73OFEnW9zGeS8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d3Ie1A6C; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d3Ie1A6C"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a1022dda33so22491015ad.2
        for <linux-cifs@vger.kernel.org>; Thu, 08 Jan 2026 10:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767895674; x=1768500474; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kG0qxlR7DkmzCTUi0X2cIVFJ3HHiLT6S36Wu9RwdLVQ=;
        b=d3Ie1A6CGa28Ttr1TTaKTI0CqL8UfzfbBVnc3kQpnc9smokQ52Tb6Sp86W9+fGob7l
         xIvuagbJfFwoNaZXsYlpRW3bYpwdKwAF+0qd1j6q5UhCxY6q1lNO4vKVELrn+Tj5WUnB
         z7MZdkwG8Pkr8/j1CD6mISZKVUni+Tggx+69xD5bQsPICnuUOWP5V+ggww6NdGSYb3/w
         xewNz/iW+grwID73F9Tk47golQ1MtyjboFtmgauJwiV/hxs0tlU0siMozBg3nwZmKkFi
         FBOkK6bQFCQKQY4BGQVX/dUKN7zEhzDy2q06POFbW70+wwqMPxEnOgH0H9/uaY8jk1bX
         4e3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767895674; x=1768500474;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kG0qxlR7DkmzCTUi0X2cIVFJ3HHiLT6S36Wu9RwdLVQ=;
        b=rdLFPsuAURGJvRJEArtmEJ7A360ZI3/vq0Kjd6LwyK/hDXHNdU4kb40B/fg28IuJXi
         xSfZtRCXqERxeE34rrSP91eqFUAFSBr2A5ZOaIL42zCD/SA/6cQezz5w9KOOBE4H0ckM
         DOq1KYv/n/ZaOUb8Oh9w3r33OZ1RO9Wht0rYA/FG41UrlQSnuriT3LbxLBkeg8Vo5MpO
         YSja1knwmS3TBLsqaU+lILA6+N/HRRHukFXfgfFZd+aYHoasTqIQ1HUc/0jSu+zxcRc6
         /Z9Pv3A9aK5UXkgx961iHZnZrDzizJLqlDaS3lULkpKCkfmrp8WUjR5bpxlOk+ISoe3X
         LaAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPETm7WbDbB/0QyNyWxsdV5yGAN4BgT0/8Fd0vJM5LQE8vwlbNAeQ+4I1zCM0x/RkKtV5U2BwEnKWH@vger.kernel.org
X-Gm-Message-State: AOJu0Yxxlw+r/t2OkLLaycbb9MbILjxXzK8up9IeK18Lk3X7H7gYtwsK
	0TfHIHzij1pvXpdO+ZgMDrrNHnKtkJ86KEbKjhOFauH3Tx+eN6xDLwdI27glVarQ1MRU/aCHZRj
	qHFXXGrXoMTqGD+LaVpfvwhyCuxT6J9Q=
X-Gm-Gg: AY/fxX4bcDU9JeowXsqF+Egx4+hLp9nsg2x6xI/3hB6qX1Z9IpHjNfit4JGlAQhI+m+
	9uP2e6M9YKdU/nmSmuhSi/+zMqCycXhYIXvY/lNBFXqGWHKw+k88WxBibHCfgwkcTGwc7+4Z0Ya
	Y1FRAt39cFZQm0U/I+ICJWxauuQLogOLfVZM1aBPGzeuU77oT6qAVAnpZuMxP5nM6l+fswlgOGH
	EgNvqqflSBpuJP3vVYWj3FaDrCDBWLF/KaqkjwTJJguOUoWjUEsJWq8/Q17XKkMmt2E1U+AuoFr
	PNd5pqFfZwp8BkanEzshgw5TWi2w
X-Google-Smtp-Source: AGHT+IE9Y4d720NUxx7X6c0Vop4TSZunxU0aBEXsPFaXcnftPaEKDqjIyJPqDzTbJ8MhAvkZSc7J6WYOjD4cMrQ1F1Y=
X-Received: by 2002:a17:903:124e:b0:2a1:3cd8:d2dc with SMTP id
 d9443c01a7336-2a3ee4b74a9mr74559005ad.57.1767895674105; Thu, 08 Jan 2026
 10:07:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1767621882.git.lucien.xin@gmail.com> <79bf90a6e105c6e6ac692de21a90ec621af47cc5.1767621882.git.lucien.xin@gmail.com>
 <ec28c852-e80a-41c9-94ce-a0fce8ee07e7@redhat.com>
In-Reply-To: <ec28c852-e80a-41c9-94ce-a0fce8ee07e7@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 8 Jan 2026 13:07:42 -0500
X-Gm-Features: AQt7F2q4UBD6cchiuW4fIBTslqGz6vf73cyh9XXwWjTaKPFND-PFSs14ShxZDj8
Message-ID: <CADvbK_dKYZ6_NyxcsweKRPkFEq046+1RENA7vH9hBhG-6xNxxw@mail.gmail.com>
Subject: Re: [PATCH net-next v6 07/16] quic: add connection id management
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

On Thu, Jan 8, 2026 at 10:52=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On 1/5/26 3:04 PM, Xin Long wrote:
> > +/* Remove connection IDs from the set with sequence numbers less than =
or equal to a number. */
> > +void quic_conn_id_remove(struct quic_conn_id_set *id_set, u32 number)
> > +{
> > +     struct quic_common_conn_id *common, *tmp;
> > +     struct list_head *list;
> > +
> > +     list =3D &id_set->head;
> > +     list_for_each_entry_safe(common, tmp, list, list) {
> > +             if (common->number <=3D number) {
> > +                     if (id_set->active =3D=3D common)
> > +                             id_set->active =3D tmp;
> > +                     quic_conn_id_del(common);
> > +                     id_set->count--;
> > +             }
>
> Since the list is sorted by number you could break the loop as soon as
> common->number > number.
>
> > +     }
> > +}
> > +
> > +struct quic_conn_id *quic_conn_id_find(struct quic_conn_id_set *id_set=
, u32 number)
> > +{
> > +     struct quic_common_conn_id *common;
> > +
> > +     list_for_each_entry(common, &id_set->head, list)
> > +             if (common->number =3D=3D number)
> > +                     return &common->id;
>
> Same here, you can break the loop when common->number > number
>
Yup, this will save some rounds.

>
> > +static inline u32 quic_conn_id_first_number(struct quic_conn_id_set *i=
d_set)
> > +{
> > +     struct quic_common_conn_id *common;
> > +
> > +     common =3D list_first_entry(&id_set->head, struct quic_common_con=
n_id, list);
>
> id_set can be empty at creation time. The above assumes it contains at
> least an element. Does the caller need to check for such condition?
> Possibly moving the check here would simplify the code?
>
quic_conn_id_first_number() is always called in the socket that is not
in CLOSE state,
and there must be at least one ID in the id_set in such states. I will
leave a comment
in this function if you're okay with it.

Thanks.
