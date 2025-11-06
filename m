Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D88223DFB
	for <linux-cifs@vger.kernel.org>; Thu,  6 Nov 2025 01:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762392503; cv=none; b=dn+uKWWTJSGO0mMY1Ulrn8B68pjkomxqMG+Kd6dsWd9k0yU841CxFeFmDRzmGKL/rom83xqtN90vaDCa3E6mywemGLljDI2f6RlIN4Y9tpbCgk2JjdcqtrtblswMl7vplMt5rugvfTaF73/iSEQ1YwuMF0Ljui1WSm+yHRvfDqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762392503; c=relaxed/simple;
	bh=8JeJb5xG4/s5U4bPcvUBg29et4g0wO08cvyhmJHqqzM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UIqJolNwix1aAnCRb5+83q1oHQKctC5aN8gHFYsZWftOWTlGU1ZQPDT6Bj5gUZh2Mdv58e9wPz1vfj2gpP1kNCPpqYIK+rHIJeinQFvzhLmplhe6sEjQkhnoM1Y3XaFMbwjupG1/gaOj9W0057P0HjyuID73rdXGKRaANfM4jOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hoqHcPYo; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hoqHcPYo"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-934f0e9d4afso150324241.1
        for <linux-cifs@vger.kernel.org>; Wed, 05 Nov 2025 17:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762392500; x=1762997300; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wg1fDGVNhVSvLHI8UtrXbUR95hQdkRLxiyxAEDl4tvA=;
        b=hoqHcPYofKuU7Hn8K+JHW07uAHj0k9cCNSjxTfQY+mbjTprMBwUVQOEQZ3PTq8lazh
         IbBJu+xLpwg/sNT9gR3IDdgP99NTDbawgHqzDTNW7WLe054865l/MXq7ePslLdMuDAPd
         ++7lNt1qFAqxRC+MuSeev+M8geUauTsEciezg8KPAqP02zq69yL43lMt1wgvPli2252B
         VwZZdGtmNrfBt1B7BexcDlAE1s2aXKmepCNh9DEerQgx6FOWv/3RaYSlPSeGQafj3LTu
         a/s2aw+KuEEMoAKZ8F+OVrLw9LsPhF7MwYeIXqPStpLtJaPTgcfpKA7ps8ttw0JWCdHi
         6B/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762392500; x=1762997300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wg1fDGVNhVSvLHI8UtrXbUR95hQdkRLxiyxAEDl4tvA=;
        b=uILIZ1erM9dPKKpM5i2ciZQRiYZehdH5lV87r4+quz+gGGqatmMFqqhVoGAlkqLMEe
         xywvJlm1P/xT2kbM54yqV9VslwejR7RVDMjFCPEquU/jt86sHIaZLteyGAg4S6uQUEA/
         m6IxBcS4+ZDzTJgQq1R1JhF4z2shgGBHVO0Cy18DanytKPpp3NaLVKU1snvkEOb/CV86
         Q4JTrngggDRgRQY4dP4h4FFUh+5v97wdX3aQJsUGBki7VIiZJUuubj3U4/gaYwSIx3uu
         b0C7cuxzsH330C9KA2V5MF1+SdNDuosdZ3QcGPu8hWVx5GfM7zSeSk9DTuMYuSiw/R75
         s/3w==
X-Forwarded-Encrypted: i=1; AJvYcCWILTVVv6up1O8SPdw22rsgsFe9+7bEbbAPHgK/qUCyKya76yg6qQLQKas8EbyH6PRsFLaujT0yQ6Dg@vger.kernel.org
X-Gm-Message-State: AOJu0Ywg3nKV9l6sN0ja4yj0viHEFJJsIF4XAbKia5ov3T71ycYI/qax
	Urta45cmDyL/H/3x+BxN1K4hq0A0VfsMwKprAw8Bb+bWCiFMlp9ggUBPo1oHQjM87YYWFm+9en1
	W6+wXUpFgVXJrIGaIElVdJMWXP070Xow=
X-Gm-Gg: ASbGncuCix4wD2teDLGRfHuf2kTb98yLpxliyeGwRtO4il76aXNqdVo05+ve6jyG2v+
	tRuPcQ4u58ZIf+Egy+IAwz7oskMlUl8SVjrGLODw8smX+tRjFbS+LnCJHIu2BwvfDWOPqQE8kbW
	IyYxd6KQ7uK/C6lu22bjCC00iggUPMwGDOWHKB6zopP6GpChkrgNJZ2jixiRwnYmxfqoOZWvgbe
	TZV0AQyy+8REQDYcsanjvD+LV/lIrCFzME50KOXs1QH9LEsCxC08yRJXi/BP++ZmpIjRZpir/KZ
	07jYhQazpoldf9Q1EDArh2cpgAo35A==
X-Google-Smtp-Source: AGHT+IFAfsz2Zqzln6j7be0SXtzx+REd9Kb2WswFj06vVEvMuigO74T2v/7feYEPVzfhUHtS1CEmTfOB6DSeH1kFlos=
X-Received: by 2002:a05:6102:6c9:b0:5db:ca9e:b588 with SMTP id
 ada2fe7eead31-5dd892c2b52mr1963957137.26.1762392500379; Wed, 05 Nov 2025
 17:28:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1761748557.git.lucien.xin@gmail.com> <0ccfc094d8f69e079cc84c96bd86a31e008e1aaf.1761748557.git.lucien.xin@gmail.com>
 <914b0331-8fab-4ad6-a6a8-e511a4352cea@redhat.com>
In-Reply-To: <914b0331-8fab-4ad6-a6a8-e511a4352cea@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 5 Nov 2025 20:28:08 -0500
X-Gm-Features: AWmQ_blK1NNu_ykARGiZM3a2YMxLJcnC4eKQDvjkKcFDiJVQwG3h2Rwk05Ot31I
Message-ID: <CADvbK_dDMA5UkS8LDqSkFwg-H2p1DNqqP_4Tv7ie1hqNp-Yrrg@mail.gmail.com>
Subject: Re: [PATCH net-next v4 08/15] quic: add path management
To: Paolo Abeni <pabeni@redhat.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Benjamin Coddington <bcodding@redhat.com>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, 
	Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>, 
	Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, 
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Daniel Stenberg <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 4, 2025 at 6:50=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wrot=
e:
>
> On 10/29/25 3:35 PM, Xin Long wrote:
> > This patch introduces 'quic_path_group' for managing paths, represented
> > by 'struct quic_path'. A connection may use two paths simultaneously
> > for connection migration.
> >
> > Each path is associated with a UDP tunnel socket (sk), and a single
> > UDP tunnel socket can be related to multiple paths from different socke=
ts.
> > These UDP tunnel sockets are wrapped in 'quic_udp_sock' structures and
> > stored in a hash table.
> >
> > It includes mechanisms to bind and unbind paths, detect alternative pat=
hs
> > for migration, and swap paths to support seamless transition between
> > networks.
> >
> > - quic_path_bind(): Bind a path to a port and associate it with a UDP s=
k.
> >
> > - quic_path_free(): Unbind a path from a port and disassociate it from =
a
> >   UDP sk.
>
> I find the above name slightly misleading, as I expect such function to
> free the path argument. Possibly quic_path_unbind?
>
Makes sense.

Thanks.
