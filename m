Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E8F1EDA0B;
	Sat, 23 Aug 2025 18:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755974335; cv=none; b=i3JRq12UHa9PufGACMZas0XQnnO1gzAv0Of+CaJR3XRqvli4al9gSW78alknqiwUVt+r8hGP3vLTVg0poTFT83mtgHz7/U2Qa2oMSxVTV6at5M2+/beKMIKwifvDstZgri+WalNEEO7MhyknOmnCAFIcQtKn1c04PGMQOZ2CGDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755974335; c=relaxed/simple;
	bh=oDVXvpiKxpr3c0kqrtTAXtEiqo4KWRDKicFiwWIhotI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QjnaVsXbdQO1bP2RinLd9aPi94wykRSDuXoFnuvay5hKt+o/FoMAo+kfzrJdZwcuEtgHHuJ+uZc69LxhaeR6I30a9E84VzOQlR6K4E7nlN4xQ33lhLxknjtiUT2sxneoCNigkB7Lf4JQXuJiv/UeBctk5N8y79RJUoYIkjbfV4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RvPV6UbX; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RvPV6UbX"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3e67e6a1cc8so18259315ab.1;
        Sat, 23 Aug 2025 11:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755974333; x=1756579133; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1jUIUF6ZY6U8MjwBCMuchcHLJGd676CBVlVvwermg10=;
        b=RvPV6UbXP9r7ClijpX3X6zHPW+BfzxvcMVyL1f4cmHeY+v8ISvqmQV67JCMNhFOv93
         2Xs2AuQdgdLqnCmOGKZXwFOUObjrgTJIi1NAqq2SjIfpGPAt4CyK9uCMdGX9cVzqy/x8
         zKRpssL6qhrViBt7N9cu8Pfm1vXkD9xNMznKHZwV3jHMwk76VulFRx+/Q3U9GMQuth8X
         dBZkeW3UYG+VmNn/OUL3FST93E5Ijnlmr5ctDN+D9OAxZEwDuwcnyrP6aNVWUcT7nYoo
         m978WLqYJtE56XO/SyfgkgAyM72udVXE+3x/Xfq2GzSVHU4hWnflsJ7V3wA7wdsQ2sjb
         jTjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755974333; x=1756579133;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1jUIUF6ZY6U8MjwBCMuchcHLJGd676CBVlVvwermg10=;
        b=sPwPnOCilRQRdufYxrolSYyAslIjemWGL8lTnJB/Qs2/xUC6LgqP+JVCgQyzahmGNx
         5EMACWXWiTvAQR3guB6iOzuihki+GzwUnLUVHj4gxZZ27dZx5Zq2NS3tjU1kClYqs1Nr
         FRi/SBifhVDTbMsQXj02qyVPK0/CY9RnYRQXoOfC5YGtMsxnP6ddZ3urm1SptWM5yo24
         uSog6q0nZDMN69rQM+BIVXQAwoifM5DQoy4hLMPVLIy2wxwGeIBlS+QqHMf+hYxfgWHZ
         Bf5w/95NS+re58eE8XpFBy+b/BY4+wk0YiCGVYaMQjNfUQrrhZAaycz7tHrDE0Cn8isQ
         cByQ==
X-Forwarded-Encrypted: i=1; AJvYcCUx1NuVQSjKz7PC8obekEHZekijVp6Dyv5enMNZIEKYCNzjXZvqbaVW+IH2gzEd7UdylnupelCke3WV@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz0Hq/UTacpOnCvzLhZTniRYowFH9t0GZ3mSAhtnd8g4QO9xxt
	kql6IkEG7jUVB6abX8DuBNGnhhKS/lXLsf3Ud1zlaBqq+fld5TH2kfmZf8kxc3lh1r7Bv8Ks938
	tXE2qUosDmB0icQ9HuScZsI6WAWXsEh4=
X-Gm-Gg: ASbGncsgZ/LdImJkGv93Gzm6xPQrDRgavNt0hWvGB+axDEsnEK8FmY8M8kBExuYn5bK
	XkiA0LfrXrUGYaX1gFG41VssCRo4fVqDIi4PfOQSkZlptsxeovfx7NgLrmOCoFeagBCkNO8mIhr
	lWI5XA/Fjtz6Zh3OHywOVxTftKkfADwWq+KKL/lShga/XTggQEXHaU8RGzFJ0QeH0oeugen5QIB
	o5VXsEfHQ==
X-Google-Smtp-Source: AGHT+IHjqCRqA5bCUScez5a0pAsH33Kb+WtLn6JdoplwFwpk8wVaOFWIXmhQcq/pIGPV6GcDpv3H4C8jNquyCWCSAcI=
X-Received: by 2002:a05:6e02:1a86:b0:3eb:b611:2d0d with SMTP id
 e9e14a558f8ab-3ebb61130fcmr6651985ab.10.1755974332802; Sat, 23 Aug 2025
 11:38:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755525878.git.lucien.xin@gmail.com> <0456736751c8beb50a089368d8adb71ecccb32b1.1755525878.git.lucien.xin@gmail.com>
 <ec99ef48-c805-4ce8-99d5-dcf254f6e189@redhat.com>
In-Reply-To: <ec99ef48-c805-4ce8-99d5-dcf254f6e189@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 23 Aug 2025 14:38:41 -0400
X-Gm-Features: Ac12FXzw8WAlfIH_Sg1ayu84V-ToxTSjwW2bXEf5ZWX563u_u__-ehR5B6Rhpm4
Message-ID: <CADvbK_d+BqJdwDW1ngX4qh_dySQQcLuO5oEZKEFmNzm=P9NPeA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 02/15] net: build socket infrastructure for
 QUIC protocol
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

On Thu, Aug 21, 2025 at 7:17=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On 8/18/25 4:04 PM, Xin Long wrote:
> > diff --git a/net/Makefile b/net/Makefile
> > index aac960c41db6..7c6de28e9aa5 100644
> > --- a/net/Makefile
> > +++ b/net/Makefile
> > @@ -42,6 +42,7 @@ obj-$(CONFIG_PHONET)                +=3D phonet/
> >  ifneq ($(CONFIG_VLAN_8021Q),)
> >  obj-y                                +=3D 8021q/
> >  endif
> > +obj-$(CONFIG_IP_QUIC)                +=3D quic/
> >  obj-$(CONFIG_IP_SCTP)                +=3D sctp/
> >  obj-$(CONFIG_RDS)            +=3D rds/
> >  obj-$(CONFIG_WIRELESS)               +=3D wireless/
> > diff --git a/net/quic/Kconfig b/net/quic/Kconfig
> > new file mode 100644
> > index 000000000000..b64fa398750e
> > --- /dev/null
> > +++ b/net/quic/Kconfig
> > @@ -0,0 +1,35 @@
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +#
> > +# QUIC configuration
> > +#
> > +
> > +menuconfig IP_QUIC
> > +     tristate "QUIC: A UDP-Based Multiplexed and Secure Transport (Exp=
erimental)"
> > +     depends on INET
> > +     depends on IPV6
>
> What if IPV6=3Dm ?
I think 'depends on IPV6' will include IPV6=3Dm.

>
> > +     select CRYPTO
> > +     select CRYPTO_HMAC
> > +     select CRYPTO_HKDF
> > +     select CRYPTO_AES
> > +     select CRYPTO_GCM
> > +     select CRYPTO_CCM
> > +     select CRYPTO_CHACHA20POLY1305
> > +     select NET_UDP_TUNNEL
>
> Possibly:
>         default n
I missed that..

>
> ?
> [...]
> > +static int quic_init_sock(struct sock *sk)
> > +{
> > +     sk->sk_destruct =3D inet_sock_destruct;
> > +     sk->sk_write_space =3D quic_write_space;
> > +     sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
> > +
> > +     WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(sysctl_quic_wmem[1]));
> > +     WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(sysctl_quic_rmem[1]));
> > +
> > +     local_bh_disable();
>
> Why?
Good catch, there was a quic_put_port() before, and I forgot to
delete local_bh_disable()f while removing quic_put_port().

>
> > +     sk_sockets_allocated_inc(sk);
> > +     sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
> > +     local_bh_enable();
> > +
> > +     return 0;
> > +}
> > +
> > +static void quic_destroy_sock(struct sock *sk)
> > +{
> > +     local_bh_disable();
>
> Same question :)
>
> [...]
> > +static int quic_disconnect(struct sock *sk, int flags)
> > +{
> > +     quic_set_state(sk, QUIC_SS_CLOSED); /* for a listen socket only *=
/
> > +     return 0;
> > +}
>
> disconnect() primary use-case is creating a lot of syzkaller reports.
> Since there should be no legacy/backward compatibility issue, I suggest
> considering a simple implementation always failing.
>
OK. This means shutdown(listensk) won't work.

Thanks Paolo for all the helpful feedback!
