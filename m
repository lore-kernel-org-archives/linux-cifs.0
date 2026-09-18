Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BB151FCA9
	for <linux-cifs@vger.kernel.org>; Fri, 18 Sep 2026 19:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789761084; cv=pass; b=YedbVTitgW/JFEeVbZF9azLh1O69iLEuxEnWdl70BCR7zgZEdVMIku2n6W6rxoK20ErJ/XnDQN1Bs7Xp4I807e6BZ2X0qI/vS4ZbLaeFCSyr4dmiUAF13Kr+tlbGZfgYcd+s7Pk3yBBWyV2Nk72GOM/M8bpt93mOJsnCovNWCKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789761084; c=relaxed/simple;
	bh=y/292QxEdUMf5pPsOfQZfieYF0PKSz2Ezz35GxIZDCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cEBHs0BqYvEB0Ch2Cw8Gu2kRx7R7wo5KVhRXCamOgS3hin2u44YMYEAUPZ2dLV5Db6kw92D5QrtsIpor+KICVtMKk9chK5SASNmgmWAwFqwfJjW6MpxEPqMf64llPl+i7EfZczBW/UDuRY5VRAhQsuItfLAgUPidGQ8ztIsmLPg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lc2AWPgg; arc=pass smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lc2AWPgg"
Received: by mail-pz2-f42.google.com with SMTP id d2e1a72fcca58-86efece610cso1000965b3a.0
        for <linux-cifs@vger.kernel.org>; Fri, 18 Sep 2026 12:51:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789761082; cv=none;
        d=google.com; s=arc-20260327;
        b=eIh9L0H9euIQVC/DW0L6J6ZhFWHkSJ8yq7mUAdu72fpm7x6w17XqXM13a4mcN70bCS
         ZqIJ9r59/GH/7ev63VXW/FLiNkWs2ALESSZJaKfHDeB56wRg8ULZ+dX+qugpyQF8P/4L
         /dd01EeTX0HjXTXOVpkD8FnTstI0wNPtlYvef/oJrzS2wopQz5x7u1wFzILOKWRC1Z5D
         +Mwtxs0zIswwRbak6qrv1y1V/DXvdq1KX2ciY2hCxlyvY+73aSsCgryzZUaNJmuLb7NG
         ydrp0SQxd7lEb1Syx/tE70VyLX4z0rSn3NrFt/F9awrLdi7zTSOofbdLINIidDQnZt8K
         4Pdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=87V+Fh4sb0y1GssnVq8tqPVBCLJOUuiDb7vS0kmG6PY=;
        fh=wlmpV3DqwHi1CyfCDzeBZGyg6sYfcfOCPRIG5nf0zJ0=;
        b=NKHk0fSTuVMsnZhRhUNWbCqlpClJec1WAidnNiD5ogG2vJM09stLOv3W1qQnSJ2jHU
         3WnLYdVgaj8PeEJAL/VYNf0yITp0RiJC4M0/qhUF6kwiVoVuuHcB+2o3Ig3eFUxspwZp
         E7OCrPIqRs/X3p+5lt1z/XEBJLEhzVJiZrxolYG2Enop1tK5ya2dlqFoM35KgG+McvhQ
         23SwllPzj9fh1YzotWcoEXmwOMu7EgeIIyJc0qJSRjrt+PndFVHOju1gHR1x+Yh8cQNv
         MJTtW8OGuLY+/jsZEJYxzbAhiifBRvhUbusDlRTkAeKD5Ps8Kjp1YdbwGEBvxzbTXa6L
         Kofw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789761082; x=1790365882; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=87V+Fh4sb0y1GssnVq8tqPVBCLJOUuiDb7vS0kmG6PY=;
        b=Lc2AWPggj1t+NG78OaGgJrUMRVniORVrZ9OmckywK411wMJyp2gJv9IAcSiiekjKY6
         aCW2rzSY67m7ituBph+TZ4s46cUAZALx+GDAQGQ0x4KXCMRwKR5vEam2oGnwi6hBknh8
         OVzJhMnMMRhw5nOv73VGjKnFaJ9efTiZzCeRo9WGhPqBZFIUMegZJeQaAXuCCSE6qs20
         ri8EH1f8YKkC+vK3I3IPkU8vrSyVBYe/VX7iPrYm4pDtiXms0TMQgoDmjTvYGt51fuBF
         f8iRJjLLLKN1AeLsNCg1+v/KALt9CQ4QAsz9nLWhyBAWEUagVUxPqg9v51Jzdivn9Gj3
         J8EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789761082; x=1790365882;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=87V+Fh4sb0y1GssnVq8tqPVBCLJOUuiDb7vS0kmG6PY=;
        b=XFJIfjFGOszEN8EogmYIhoZNf2qlGl7TUVMsPja3xpSd1oBV68iVprh48B8MGqHLfq
         6rGbP1xxZIzFCKQix9G0GajtpNQ3DWR2AG36axwQxlQHVCJ8bG+wzBZorO+MMgsn3G5a
         q/X00oPQ9BLzOOL88BLgPmamgdz0SdnXpMkBnC1r4FGseQI73sn3qgHiGBJ+pghf3S+e
         khcns/OFUuqlYFyD1aLCm/ThXlAqqOimbq7YdI/jJ/2Kuwh46+/Z13evG44z61FBm3cW
         9/1utPvo0ivGoRbn9f08ZmBlNpvl5X0wX+fBhRsilTZftT6SmkX56hnOKjMJ1xZt6x4b
         8FNA==
X-Forwarded-Encrypted: i=1; AKwUvBxI8GCoDpWzwZ8qeFj8u8//KhGTKAE93uWADmFMbNEyijhV7bcSekK9kYoIyqRsbpYy8kih3C8fGCTj@vger.kernel.org
X-Gm-Message-State: AFuF++lytKSREQpR3FpeoH6ylLAi2oWVIgL++zlXjPPh/YBoG1Gz3bMq
	8QyPzQP5nrdaaEAcoBlt2i0jrLtBbf29tm5n3TwUV+J09MSjtkfa4f0glhjvAZgGB9yTAMF4l9u
	A3Uw/KMAb2KMmKvwGCm7ZZLfJh/sA6G8=
X-Gm-Gg: AYBFou3J4alEQwyeis6zlGbQGR/vi7+OmQZSNupPmO6uRYMJCsKtOTxAbud/8QWm7N/
	wg/uN+fKPKHhaKla8qA8ZGOrYClU1GzLUKWa8hvkvKFGkeQjZSn3FQqZ8KYBPMbFxyKUhoTvwV2
	SApmNK01pUCWFDBwcNpqyP9o8ZnGz+lLCkbLx6xYej42/P3/zqpzde4fi8XuVEmYq7/wWlVxykT
	fi8oVOSrDAZvOu/XJ671cmjITry0H8GmhcagDRLpZkmqjuVs+nUoaU60iiAV9138Fvds07AqEu8
	xxjLhmdKd+/s81SCWG2/EL1PxHuOERYepBcp9ReevhLvnkifVw97bGT5xYZ0PcqGxfsxejCQHbk
	FxfdTjwX3YA+fOE5Mp74Gq9g0b/cJE5MfBvLKUxnxPqgAUL0aUdbsD39N
X-Received: by 2002:a05:6a00:4185:b0:86b:b308:b926 with SMTP id
 d2e1a72fcca58-874dcbed261mr7094177b3a.14.1789761082116; Fri, 18 Sep 2026
 12:51:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADvbK_dHPkHjkPwu0RepYgDsHs5reHepprRHU9hDFBxQM9_RGw@mail.gmail.com>
 <20260916234654.420056-1-kuniyu@google.com> <CADvbK_df5X=Szsd-d8=0gndhoBSHJhnEqSh826iYUW6=Ce_xEw@mail.gmail.com>
 <CAAVpQUCRcBQOS4H5zJBOoYeCgsQBiGyu8gjhXaocDXDw9jqTOg@mail.gmail.com>
In-Reply-To: <CAAVpQUCRcBQOS4H5zJBOoYeCgsQBiGyu8gjhXaocDXDw9jqTOg@mail.gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 18 Sep 2026 15:51:09 -0400
X-Gm-Features: AcwNN1VIcCElFEGPge_VRMPC4oISQAbf6IB5C7NCKiJGMnhf9LEZN0g8RJucO_Q
Message-ID: <CADvbK_cweNjHtX-m=Ba5BT3g3aHhJ7se5TqaW44OXicONW6oYQ@mail.gmail.com>
Subject: Re: [PATCH net-next v15 15/15] quic: add packet parser base
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: aahringo@redhat.com, alibuda@linux.alibaba.com, 
	andrew.gospodarek@broadcom.com, chuck.lever@oracle.com, daniel@haxx.se, 
	davem@davemloft.net, dhowells@redhat.com, dreibh@simula.no, 
	edumazet@google.com, hare@suse.de, hepengtao@xiaomi.com, horms@kernel.org, 
	illiliti@protonmail.com, jbaron@akamai.com, jlayton@kernel.org, 
	kernel-tls-handshake@lists.linux.dev, kuba@kernel.org, linkinjeon@kernel.org, 
	linux-cifs@vger.kernel.org, mail@johnericson.me, marcelo.leitner@gmail.com, 
	matttbe@kernel.org, mbuhl@openbsd.org, mef@scarletmail.rutgers.edu, 
	metze@samba.org, netdev-bot+sashiko@kernel.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, paul@jakma.org, pc@manguebit.org, quic@lists.linux.dev, 
	sd@queasysnail.net, steved@redhat.com, tfanelli@redhat.com, tom@talpey.com, 
	xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 17, 2026 at 3:06=E2=80=AFPM Kuniyuki Iwashima <kuniyu@google.co=
m> wrote:
>
> On Thu, Sep 17, 2026 at 6:38=E2=80=AFAM Xin Long <lucien.xin@gmail.com> w=
rote:
> >
> > On Wed, Sep 16, 2026 at 7:46=E2=80=AFPM Kuniyuki Iwashima <kuniyu@googl=
e.com> wrote:
> > >
> > > From: Xin Long <lucien.xin@gmail.com>
> > > Date: Wed, 16 Sep 2026 14:08:22 -0400
> > > > > > +struct sock *quic_listen_sock_lookup(struct sk_buff *skb, unio=
n quic_addr *sa,
> > > > > > +                                  union quic_addr *da, struct =
sock *usk,
> > > > > > +                                  struct quic_data *alpns)
> > > > > > +{
> > > > >
> > > > > [ ... ]
> > > > >
> > > > > > +out:
> > > > > > +     if (sk && sk->sk_reuseport)
> > > > > > +             sk =3D reuseport_select_sock(sk, quic_addr_hash(n=
et, da), skb, 1);
> > > > >
> > > > > [Severity: Medium]
> > > > > Should the hdr_len argument be 0 rather than 1 here?
> > > > >
> > > > > quic_udp_rcv() already did skb_pull(skb, sizeof(struct udphdr)) b=
efore
> > > > > quic_packet_rcv() is reached, so skb->data points at the QUIC pay=
load, and
> > > > > reuseport_select_sock() documents hdr_len as how far the pointer =
must advance
> > > > > to reach the payload.
> > > > >
> > > > > With a classic SO_ATTACH_REUSEPORT_CBPF program, run_bpf_filter()=
 does:
> > > > >
> > > > > net/core/sock_reuseport.c:
> > > > >         if (unlikely(!pskb_may_pull(skb, hdr_len)))
> > > > >                 return -EINVAL;
> > > > >         ...
> > > > >         pskb_pull(skb, hdr_len);
> > > > >         ...
> > > > >         __skb_push(skb, hdr_len);
> > > > >
> > > > > so the filter would see the datagram starting one byte into the Q=
UIC header:
> > > > > all its offsets are shifted and the first byte (form/fixed/type b=
its) is
> > > > > invisible, which can select the wrong socket in the reuseport gro=
up.
> > > > >
> > > > > [ ... ]
> > > > >
> > > > True:
> > > >
> > > > BPF programs may need to access the QUIC header, so I will pass 0 t=
o
> > > > reuseport_select_sock() to ensure the full QUIC packet is visible.
> > >
> > > Why do you use reuseport_select_sock() here ?
> >
> > Because QUIC socket supports SO_REUSEPORT and allows multiple sockets
> > listening on the same addr/port/ALPNs:
> >
> > https://github.com/lxin/quic/blob/main/modules/net/quic/socket.c#L724
>
> Okay, I was wondering how it was supposed to work without
> reuseport_add_sock() etc.
>
> reuseport_select_sock() should be moved to a later patch.
>
I'll try. Thanks.
