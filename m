Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4401D3659FD
	for <linux-cifs@vger.kernel.org>; Wed,  4 Mar 2026 23:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772667482; cv=pass; b=Kcjzco/eQcc7UpS60Wn/+W0etVMBEINHXLzDVmqgqVMWO5vlhCWIsWwMggSZuvhQTdb5vSAmxqP6vCrhoMoTi5xCsDbmBcYjmxllRCwBhbknGn/EYLB/4j7uE4fGsiNzI1ESIINPbJvGetIDCSmxfg/2r5zlWbpzvJOsNhVRy18=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772667482; c=relaxed/simple;
	bh=w1TG5DyyD/MOa39o2nEmPuagdIYdEe1dCKPHHwXRuCo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bJOVOQDloFdsezRbf0pbnjkIHQ1s9J1q82CC1Um4jc9Xzny41WXXuMffGXY1ladL0EBYXvqgiVS3wrVJHPF/w6TsF68JvRVn+Ct8E13chG2RhIj/5Vy9vunbWZYQDvDdZ3mw0+8dIM4ybY9Y0akJvmy8VIpv6NZ0TKBzH0VuedM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JjKGLcxr; arc=pass smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JjKGLcxr"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-94acf9ce1b7so5004048241.2
        for <linux-cifs@vger.kernel.org>; Wed, 04 Mar 2026 15:38:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772667479; cv=none;
        d=google.com; s=arc-20240605;
        b=JJkRPjGOiUpVxKf0QJlBaIjyctvvuLEjXlmepdx3EBmGY1LAzoW1W8uqriVnUIRZkY
         iGAKp6s+nE9MtRBYb+Qqvw6JyLBYU7hET+aD8r7h6aEauC98Ef/lt9swDLzh/3R0OwVa
         zd+6aXCkEdUoSRptFoCe3MmnB+vmxtybtT4HjnWBX25uM5K9OD2leb1QkiNHPpYLKJ84
         1VeJzQQ5HLgOzwQoGyEijXSRRYmJAjRPD/r0Z9GJGf2IPUSBClIThOW4+LGu3bTzCR7L
         rHNOLWXb0B9bv/Fj3WaQBLzeJpQ7tjCpyoguTqAx+3IPGq0ejdynPVrzUORc3lP6GiYr
         NtgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=f2lsS6J1KrbGRFoggFb+7TwDvtJ+7CgdNNb0+XNMCDA=;
        fh=t/f/x4B7vWbivgtPM58G2R7y4ApAhx14w0mXvRZbCRI=;
        b=jnA2LywYtQDWmRKXUdl4HUnMiMpahmRLo26oGnO8hclvZ3FLadzcD6kvRI9OKXpzG0
         5hJo7a6Jt5wKRb2jopkMmKtmkCpUAPcUgXnZrwRd+k82QimjCPaz106QZJJzxoxRM135
         TJI44IOQza3s2snyFuiqgm4lF3ELLCSOkjp4skHewk6dHd+2xqtGK9gZtF/Vcdp5VmrR
         A/5fkwbv9FuBiBqoN6LOd6+TcWO6ZfK8LHU3d2wn3E5zNkHACTGorOWQMlteu/HnMV4x
         KnJoOZcsKQQNHdO2wG8up5AJY7HllN2JlMzgXM2F8mP8d0DrdOJGuVNO3J4Hl3buOvBq
         n6Ig==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772667479; x=1773272279; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f2lsS6J1KrbGRFoggFb+7TwDvtJ+7CgdNNb0+XNMCDA=;
        b=JjKGLcxrB9cR872n139JcVQYpMCorug6rQAWD5KqvQhW258szruhbN9OlFXFzUlOt9
         X2Zu087AkIi9ZYFPkUWlzCqz7fAXTrRqOslXKGTKX+9k+Zsr04xyFbjAzFS2mA2mw9NP
         Gy+QFffUq31sgIPkI7LryX2p0X+hbo5vY0O56plT45zfIzp4Luy6hhXz8rONsRxmGTIw
         ro/3/WS6lZow37jqINXeeZ7VEnJmAZ4owjYbgO79Bq2gYCYddWt3QIoHB1u+7XAxAWgd
         Sg75IZGxw7HMx0sjP4veUSF64QcoqaQTMo7CM5EhY5BG2bUOnh0InU12LgwvvResmfo8
         httg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772667479; x=1773272279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f2lsS6J1KrbGRFoggFb+7TwDvtJ+7CgdNNb0+XNMCDA=;
        b=Mr7b5hYBPy1XiE/SMpvCLkZSlLFhlwX3780ulVb4W5HQP5gbY7EL+8Lx2rXM4krEfc
         XjOmh/l+w/9lwLBPczA5rdjLJnLXGFwP47uNCVe5msDulwYOp2PNImPLY32oNBCdx2As
         TlT/jfwNs9Bb0Ql8Se+W3VHC4ZX8NvkrTAth5KCs9/hCyomO50Q6cK1ZaI9otI1XmX3j
         JPdtDB4k9Cpj9syqgCfzMZKQE1nGpr1f0ppAE9KBJsl2oOgcmhYjNI7z+D3qgiS5f+I2
         Mi8y/5+u8/7VqiC3vq1Vp9rAxnXLuhqJ2941DDAeueIpFn0+cqSdkg2GGh+OpuMkNCVY
         C4uQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOH5EvdVWapPFRAQk8jatxPQI+kWYjkSp4kbD1MXYbE6LluZm+WP7DC74nrhW4i/OXpp5PhiywvVqj@vger.kernel.org
X-Gm-Message-State: AOJu0YzF+zRth5kxlwoWui5Xpb3XPsLlaGS1DNiqn+ArOy3j5XXZaksv
	n1kfirS7B9hktoS0e2V/DxOh4P/xreiyRcG/HZR2nFDy9aYbkyZz7i48C7Ap4r+W7tVCbKOHECB
	HVy3XQr6X2xm9q3TWV/r1ASN1vBCLlcw=
X-Gm-Gg: ATEYQzwZYuXYHpjf6ZNZBlVThA4JZ4u/VMKjlLsQzXBFk9BfLnvPtdLKgYPXaLd550b
	FqlRURP61ENWqIUAhpwAt+6B0TshS6u9RR2FsJgIiBcEAM6w0PoVUstWJMrWIUDKWRaHh0K4hy0
	YaajlAH1+bTaBKa9PPIikb4NkiBoIHkEhyQ4gonXbG6nml6hoPb/o3yfAVAzeoPHajn/M+idRax
	37Cp919BWc+RgB67FeBtq25U6yNTV+VTtbtQBy+/4HglwW5fGEHNf6/oZIs6vSgYqEuNzVSvsfh
	NZ6MFndCbc8gAZyDZh+pKX7MGOqnmszRsC+DtKImfIkcNPXW/nVr4NAtThQRpBBr27s2QSMELtO
	KioORwRK5ju6IXLTB
X-Received: by 2002:a05:6102:510f:b0:5ff:a34:6ce8 with SMTP id
 ada2fe7eead31-5ffaaf1af3amr1982362137.20.1772667479118; Wed, 04 Mar 2026
 15:37:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <08a63705058aff77dd54fb388870f0bca6036c95.1771986861.git.lucien.xin@gmail.com>
 <20260303083351.35558-1-pabeni@redhat.com>
In-Reply-To: <20260303083351.35558-1-pabeni@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 4 Mar 2026 18:37:46 -0500
X-Gm-Features: AaiRm51OBlwUOZC4nFNNd6vu4H5gc_uzuMHgB2908jHUlSejY2ws0x0OMALq7Fk
Message-ID: <CADvbK_e-Tkb8aVzSy4WhVogETvQy16TrFdtWROtf3Y6oC+PczQ@mail.gmail.com>
Subject: Re: [net-next,v10,15/15] quic: add packet parser base
To: Paolo Abeni <pabeni@redhat.com>
Cc: hepengtao@xiaomi.com, kuba@kernel.org, jlayton@kernel.org, metze@samba.org, 
	davem@davemloft.net, kernel-tls-handshake@lists.linux.dev, horms@kernel.org, 
	hare@suse.de, aahringo@redhat.com, tfanelli@redhat.com, mail@johnericson.me, 
	andrew.gospodarek@broadcom.com, linkinjeon@kernel.org, dhowells@redhat.com, 
	matttbe@kernel.org, xiyou.wangcong@gmail.com, dreibh@simula.no, 
	jbaron@akamai.com, quic@lists.linux.dev, pc@manguebit.com, 
	marc@fiuczynski.com, edumazet@google.com, alibuda@linux.alibaba.com, 
	steved@redhat.com, illiliti@protonmail.com, tom@talpey.com, 
	marcelo.leitner@gmail.com, sd@queasysnail.net, linux-cifs@vger.kernel.org, 
	netdev@vger.kernel.org, mbuhl@openbsd.org, smfrench@gmail.com, 
	chuck.lever@oracle.com, daniel@haxx.se
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 3, 2026 at 3:34=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wrot=
e:
>
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
>
> For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-loca=
l.html
> ---
> quic: add packet parser base
>
> This patch uses 'quic_packet' to handle packing of QUIC packets on the
> receive (RX) path. It introduces mechanisms to parse the ALPN from
> client Initial packets to determine the correct listener socket.
> Received packets are then routed and processed accordingly.
>
> > diff --git a/net/quic/packet.c b/net/quic/packet.c
> > index a56edc745bb1..a23ce99a6656 100644
> > --- a/net/quic/packet.c
> > +++ b/net/quic/packet.c
>
> [ ... ]
>
> > +/* Extract the Destination Connection ID (DCID) from a QUIC Long heade=
r packet. */
> > +int quic_packet_get_dcid(struct quic_conn_id *dcid, struct sk_buff *sk=
b)
> > +{
> > +     u32 plen =3D skb->len;
> > +     u8 *p =3D skb->data;
> > +     u64 len;
> > +
> > +     if (plen < QUIC_HLEN + QUIC_VERSION_LEN)
> > +             return -EINVAL;
> > +     plen -=3D (QUIC_HLEN + QUIC_VERSION_LEN);
> > +     p +=3D (QUIC_HLEN + QUIC_VERSION_LEN);
> > +
> > +     if (!quic_get_int(&p, &plen, &len, 1) ||
> > +         len > plen || len > QUIC_CONN_ID_MAX_LEN)
> > +             return -EINVAL;
> > +     quic_conn_id_update(dcid, p, len);
> > +     return 0;
> > +}
>
> This parsing logic looks nearly identical to what's already in
> quic_packet_get_version_and_connid().  Both skip QUIC_HLEN +
> QUIC_VERSION_LEN, read the length byte, validate against
> QUIC_CONN_ID_MAX_LEN, and call quic_conn_id_update().
>
> Could quic_packet_get_dcid() call quic_packet_get_version_and_connid()
> with dummy parameters, or could both share a helper to extract just the
> DCID portion?
>
No, they work on different forms of QUIC packet, one for short header and
the other for long header packets.

> > diff --git a/net/quic/path.c b/net/quic/path.c
> > index 9414c4f813c5..655f38af4107 100644
> > --- a/net/quic/path.c
> > +++ b/net/quic/path.c
> > @@ -17,6 +17,8 @@
> >  #include "family.h"
> >  #include "path.h"
> >
> > +extern int quic_packet_rcv(struct sock *sk, struct sk_buff *skb, u8 er=
r);
>
> Could this include packet.h instead? The canonical declaration already
> exists in packet.h (after this patch). Using 'extern' here creates a
> duplicate signature.
>
> If the signature in packet.h changes later, this extern could silently
> become stale depending on calling conventions. Since packet.h has no
> include directives and wouldn't create a circular dependency, including
> it would keep the declaration in sync.
>
No, let's not have this dependency for now.

Thanks.
> > +
> >  static int quic_udp_rcv(struct sock *sk, struct sk_buff *skb)
> >  {
> >       memset(skb->cb, 0, sizeof(skb->cb));
>
