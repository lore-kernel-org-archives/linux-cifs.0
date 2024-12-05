Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9129F2391A1
	for <linux-cifs@vger.kernel.org>; Thu,  5 Dec 2024 10:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733395782; cv=none; b=We/NiekkTGgwPIyzLR1nCp+ke4iQMb/e+Ic/fdFzQBnigmjxP+rOPgKFsP0ehWwN66js2VU8CJqPzMFelWM7kC7qRaMB89qhpoNnqDxY+UhyYhKJLEeP/R2vMgWbdaJPnUIibKxgvWEeGAzgN0L15nuLkteIw0DoPrwQBHUTgo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733395782; c=relaxed/simple;
	bh=kuCXgILOauz4v/yKod0LAz2UlQjA8QDTzjfLbHcr/xU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TUOPpaH24lWnUsKT5XmJwMvtcrRpumt+WiEKOFGgmjAxTrocf8V5qeAOPy0IUMKF770eORPkJzmO2TpfZ60WgpN3pvI/OAjBOHh6P9SeatiBmiH4DAYZYnfUlVqdVu9rp0F2ToLnUWarm5obGviFO+X+DKSWfMvATTwY0U9kOuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KoTBtUA6; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KoTBtUA6"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aa62f0cb198so26853566b.2
        for <linux-cifs@vger.kernel.org>; Thu, 05 Dec 2024 02:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733395779; x=1734000579; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s12Y7f6RRp/kqee2F8DuG/HjLXqv5eA50hV6EOntcR0=;
        b=KoTBtUA6K55YmVbF6x5JB2zJ1U3aD5eUqTnaqt8Rx0Ukz3ystR4hgNVmnA7VGo2aeQ
         lrRo41FawF8r8Gb70VxR0mE511TM8SZ/buJS5Zjiwj+VS2rn/jtVjZsXnoxKoovgBo+n
         f55q5RzhB4iFaREBVlE+cl5aQRiutdPFxLbQphoaDxxWxc+ERmiaMb1DhrgD0+RiRFAC
         WWLKwHBaKrdIArKWw+37RraxOVXCyFnQljoYkErgyNKy0/zusv2tJZoXDgIHlDm/lc4q
         2JdoTDA/GSXHVTQS6nWeAwlRWcRRl29EtcmbhzUiz4noSWUuCW4nhQxwux4XB0ySYy7H
         obzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733395779; x=1734000579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s12Y7f6RRp/kqee2F8DuG/HjLXqv5eA50hV6EOntcR0=;
        b=jnDEGIqSqCNIEfjlr/hPksjJRk/SiwlbX8Lt5CKb2naqSSmenS8RRDWJU8pdAm9BRi
         Q6m7jhDa4pWvlBw1k3cny9m60Cchp/whmis0WAQnPLXl5xlhII116MDaOkw8KxvPoHFj
         erb7MALboYVA00qDA5ec1E7ozfYHGPUIFjcZ2Yrm6oHLZt0D8WZs7/dGghfRVQ8nSBRX
         R5+heukJG4Oh8uNhdZcd9h6e7pp6lkuJdZJgOk4JyVGqEzNhnnseIpwJZe955jxucgfw
         51yPcB3zpj/anMXe4UTA9kILdOixbpt3LBE6biE6cHbn3xG7HnST3FY6+6WiY6JzsDGg
         h44Q==
X-Forwarded-Encrypted: i=1; AJvYcCV+g7snSJZifXoo9QWhfrcd2Vq2R2Uz6Qt3629FPE612F+XlhnxRNUnjQeaPmg4HXGB1Q/fPBYBSbf5@vger.kernel.org
X-Gm-Message-State: AOJu0YwdjyESTOETFkJ7pMy1PjgPPwqL8wtkhja9c4dQqycjoExRtvXv
	FE/41Pvxl6J5se10cq2ns3Q+/MiS0F0KX09txZzo7W3W6JY6uE1QcX4HGChNqw2CfbGFqLjX6Lq
	TKxcmtSCPdqpAY+/k2qcdMe2jBCLSu1T4
X-Gm-Gg: ASbGncvaqPMRgy7/JaB+gRx0UZh3yuIMH/Wp2qq+k5e5qZqVA93ppDz3poIn1rLYKrO
	c1odj3ie8/sv4qhcpbNp0vLZuWTChYII4TQUJ+qB2itlshbFIBi8ue69LK0H9zg==
X-Google-Smtp-Source: AGHT+IHWtGvApkyybSmzNYsJtxJxIY0epAZJqFPJs1XvOi54OTTk5gBZjLlbn98RaVLxpV6kY3U3yruqUb0bIE0S8RY=
X-Received: by 2002:a17:906:1baa:b0:aa6:2edd:cbe8 with SMTP id
 a640c23a62f3a-aa62eddcc47mr41178966b.12.1733395778538; Thu, 05 Dec 2024
 02:49:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANT5p=pUGYwswgXM-pniMjEWwbLK0cKXPBOJB9cG_cOrkBwQhg@mail.gmail.com>
 <CANT5p=qBwjBm-D8soFVVtswGEfmMtQXVW83=TNfUtvyHeFQZBA@mail.gmail.com>
 <505338.1733181074@warthog.procyon.org.uk> <526707.1733224486@warthog.procyon.org.uk>
 <CANT5p=pO28C+XEC44taAT-Z6W_spB-QzJb+MOXv68bDRGqJn=w@mail.gmail.com>
 <CANT5p=qc97-Ncs4E6_KfcYVxBYU5cw5LnPJoccb3gePa8OuCKg@mail.gmail.com>
 <CAN05THTXWKGDynqPLzSfT2j0vvQ9At0YKBHYWMm0KM4mCgyOxA@mail.gmail.com> <CANT5p=rFSLgCyZ8D1CUcSBzmyW+voAbxbOwRHH+=vPgxhLaRfw@mail.gmail.com>
In-Reply-To: <CANT5p=rFSLgCyZ8D1CUcSBzmyW+voAbxbOwRHH+=vPgxhLaRfw@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 5 Dec 2024 16:19:27 +0530
Message-ID: <CANT5p=rw_mewxPrp0xxQcBRY8Z7Zwg6RQMCXyc7vwWvDur5dHQ@mail.gmail.com>
Subject: Re: null-ptr deref found in netfs code
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 5, 2024 at 10:17=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Thu, Dec 5, 2024 at 2:20=E2=80=AFAM ronnie sahlberg <ronniesahlberg@gm=
ail.com> wrote:
> >
> > If you run the kernel under gdb and set a breakpoint on panic you
> > should be able to see the exact line where it failedand you will also
> > be able to check the variables and what they are set to.
> >
> > On Thu, 5 Dec 2024 at 02:31, Shyam Prasad N <nspmangalore@gmail.com> wr=
ote:
> > >
> > > On Wed, Dec 4, 2024 at 10:00=E2=80=AFPM Shyam Prasad N <nspmangalore@=
gmail.com> wrote:
> > > >
> > > > On Tue, Dec 3, 2024 at 4:44=E2=80=AFPM David Howells <dhowells@redh=
at.com> wrote:
> > > > >
> > > > > Okay, I think I see the problem.
> > > > >
> > > > > Looking at the following extraction from the trace:
> > > > >
> > > > > > netfs_rreq_ref: R=3D0000290e NEW         r=3D1
> > > > > > netfs_read: R=3D0000290e READAHEAD c=3D00000000 ni=3D0 s=3D85e0=
0000 l=3D800000 sz=3D280000000
> > > > > > netfs_folio: i=3Df1c2900000000000 ix=3D85e00-85fff read
> > > > > > netfs_folio: i=3Df1c2900000000000 ix=3D86000-861ff read
> > > > > > netfs_folio: i=3Df1c2900000000000 ix=3D86200-863ff read
> > > > > > netfs_folio: i=3Df1c2900000000000 ix=3D86400-865ff read
> > > > >
> > > > > We're requesting reads of four folios, each consisting of 512 pag=
es for a
> > > > > total of 8MiB.
> > > > >
> > > > > > netfs_sreq: R=3D0000290e[1] DOWN SUBMT f=3D02 s=3D85e00000 0/10=
0000 e=3D0
> > > > > > netfs_sreq: R=3D0000290e[2] DOWN SUBMT f=3D02 s=3D85f00000 0/10=
0000 e=3D0
> > > > > > netfs_sreq: R=3D0000290e[3] DOWN SUBMT f=3D02 s=3D86000000 0/10=
0000 e=3D0
> > > > > > netfs_sreq: R=3D0000290e[4] DOWN SUBMT f=3D02 s=3D86100000 0/10=
0000 e=3D0
> > > > > > netfs_sreq: R=3D0000290e[5] DOWN SUBMT f=3D02 s=3D86200000 0/10=
0000 e=3D0
> > > > > > netfs_sreq: R=3D0000290e[6] DOWN SUBMT f=3D02 s=3D86300000 0/10=
0000 e=3D0
> > > > > > netfs_sreq: R=3D0000290e[7] DOWN SUBMT f=3D02 s=3D86400000 0/10=
0000 e=3D0
> > > > > > netfs_sreq: R=3D0000290e[8] DOWN SUBMT f=3D02 s=3D86500000 0/10=
0000 e=3D0
> > > > >
> > > > > That got broken down into 8 submissions, each for a 1MiB slice.
> > > > >
> > > > > > netfs_sreq: R=3D0000290e[1] DOWN IO    f=3D02 s=3D85e00000 1000=
00/100000 e=3D0
> > > > > > netfs_progress: R=3D0000290e[01] s=3D85e00000 ct=3D0/100000 pa=
=3D100000/100000 sl=3D0
> > > > > > netfs_donate: R=3D0000290e[01] -> [02] to-next am=3D100000
> > > > >
> > > > > Subrequest 1 completed, but wasn't large enough to cover a whole =
folio, so it
> > > > > donated its coverage forwards to subreq 2.
> > > > >
> > > > > > netfs_sreq: R=3D0000290e[6] DOWN IO    f=3D02 s=3D86300000 1000=
00/100000 e=3D0
> > > > > > netfs_progress: R=3D0000290e[06] s=3D86300000 ct=3D0/100000 pa=
=3D100000/100000 sl=3D2
> > > > > > netfs_donate: R=3D0000290e[06] -> [05] tail-to-prev am=3D100000
> > > > >
> > > > > Subrequest 6 completed, but wasn't large enough to cover a whole =
folio, so it
> > > > > donated its coverage backwards to subreq 5.
> > > > >
> > > > > > netfs_sreq: R=3D0000290e[2] DOWN IO    f=3D02 s=3D85f00000 1000=
00/100000 e=3D0
> > > > > > netfs_progress: R=3D0000290e[02] s=3D85e00000 ct=3D0/200000 pa=
=3D200000/200000 sl=3D0
> > > > > > netfs_folio: i=3Df1c2900000000000 ix=3D85e00-85fff read-done
> > > > > > netfs_folio: i=3Df1c2900000000000 ix=3D85e00-85fff read-unlock
> > > > >
> > > > > Subreq 2 completed, and with the donation from subreq 1, had suff=
icient to
> > > > > unlock the first folio.
> > > > >
> > > > > > netfs_sreq: R=3D0000290e[5] DOWN IO    f=3D02 s=3D86200000 1000=
00/100000 e=3D0
> > > > > > netfs_progress: R=3D0000290e[05] s=3D86200000 ct=3D0/200000 pa=
=3D200000/200000 sl=3D2
> > > > > > netfs_folio: i=3Df1c2900000000000 ix=3D86200-863ff read-done
> > > > > > netfs_folio: i=3Df1c2900000000000 ix=3D86200-863ff read-unlock
> > > > >
> > > > > Subreq 5 completed, and with the donation from subreq 6, had suff=
icient to
> > > > > unlock the third folio.
> > > > >
> > > > > > netfs_sreq: R=3D0000290e[3] DOWN IO    f=3D02 s=3D86000000 1000=
00/100000 e=3D0
> > > > > > netfs_progress: R=3D0000290e[03] s=3D86000000 ct=3D0/100000 pa=
=3D100000/100000 sl=3D1
> > > > > > netfs_donate: R=3D0000290e[03] -> [04] to-next am=3D100000
> > > > >
> > > > > Subrequest 3 completed, but wasn't large enough to cover a whole =
folio, so it
> > > > > donated its coverage forwards to subreq 4.  So far, so good.
> > > > >
> > > > > > netfs_sreq: R=3D0000290e[7] DOWN IO    f=3D02 s=3D86400000 1000=
00/100000 e=3D0
> > > > > > netfs_progress: R=3D0000290e[07] s=3D86400000 ct=3D0/100000 pa=
=3D100000/100000 sl=3D3
> > > > > > netfs_donate: R=3D0000290e[07] -> [04] to-prev am=3D0
> > > > >
> > > > > Subreq 7 completed, but wasn't large enough to cover a whole foli=
o, so it
> > > > > donated its coverage backwards to subreq 4.  This is a bug as sub=
req 7 is not
> > > > > contiguous with subreq 4.  It should instead have donated forward=
s to subreq
> > > > > 8.
> > > > >
> > > > > > netfs_sreq: R=3D0000290e[4] DOWN IO    f=3D02 s=3D86100000 1000=
00/100000 e=3D0
> > > > > > netfs_sreq: R=3D0000290e[4] DOWN +DON  f=3D02 s=3D86000000 3000=
00/300000 e=3D0
> > > > > > netfs_progress: R=3D0000290e[04] s=3D86000000 ct=3D0/300000 pa=
=3D200000/300000 sl=3D1
> > > > > > netfs_folio: i=3Df1c2900000000000 ix=3D86000-861ff read-done
> > > > > > netfs_folio: i=3Df1c2900000000000 ix=3D86000-861ff read-unlock
> > > > >
> > > > > Subreq 4 completed, and with the donation from subreq 2, had suff=
icient to
> > > > > unlock the second folio.  However, it also has some excess from s=
ubreq 7 that
> > > > > it can't do anything with - and this gets lost.
> > > > >
> > > > > > netfs_sreq: R=3D0000290e[8] DOWN IO    f=3D02 s=3D86500000 1000=
00/100000 e=3D0
> > > > > > netfs_progress: R=3D0000290e[08] s=3D86500000 ct=3D0/100000 pa=
=3D100000/100000 sl=3D3
> > > > > > netfs_donate: R=3D0000290e[08] -> [04] tail-to-prev am=3D100000
> > > > >
> > > > > Here's a repeat of the bug: subreq 8 donates to subreq 4, but, ag=
ain, is not
> > > > > contiguous.  As these are happening concurrently, the other threa=
d hasn't
> > > > > delisted subreq 4 yet.
> > > > >
> > > > > > netfs_sreq: R=3D0000290e[4] DOWN +DON  f=3D02 s=3D86000000 4000=
00/400000 e=3D0
> > > > > > netfs_progress: R=3D0000290e[04] s=3D86200000 ct=3D200000/40000=
0 pa=3D200000/200000 sl=3D2
> > > > >
> > > > > The request screwed at this point: subreq 4 shows the extra stuff=
 it has been
> > > > > donated, but it is unable to do anything with it.  There is no fo=
lio to
> > > > > wrangle as the third slot (sl=3D2) in the queue has already been =
cleared.
> > > > >
> > > > > (Note that this bug shouldn't happen with the patches currently o=
n my
> > > > > netfs-writeback branch as I got rid of the donation mechanism in =
preference
> > > > > for something simpler with single-threaded collection.)
> > > > >
> > > > > David
> > > > >
> > > >
> > > > Hi David,
> > > >
> > > > Tried your submitted patch "netfs: Fix non-contiguous donation betw=
een
> > > > completed reads" with the same workload.
> > > > It seems to be crashing elsewhere. I'm trying to get the OOPS messa=
ge
> > > > and ftrace, but it seems to be crashing the kernel.
> > > >
> > > > --
> > > > Regards,
> > > > Shyam
> > >
> > > Here's what I managed to get before the VM crashed:
> > >
> > > [Wed Dec  4 16:27:10 2024] BUG: kernel NULL pointer dereference,
> > > address: 0000000000000068
> > > [Wed Dec  4 16:27:10 2024] #PF: supervisor read access in kernel mode
> > > [Wed Dec  4 16:27:10 2024] #PF: error_code(0x0000) - not-present page
> > > [Wed Dec  4 16:27:10 2024] PGD 0 P4D 0
> > > [Wed Dec  4 16:27:10 2024] Oops: Oops: 0000 [#1] SMP PTI
> > > [Wed Dec  4 16:27:10 2024] CPU: 6 UID: 0 PID: 1263 Comm: kworker/6:3
> > > Tainted: G           OE      6.12.0-mainline #10
> > > [Wed Dec  4 16:27:10 2024] Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNED_=
MODULE
> > > [Wed Dec  4 16:27:10 2024] Hardware name: Microsoft Corporation
> > > Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1
> > > 08/23/2024
> > > [Wed Dec  4 16:27:10 2024] Workqueue: cifsiod smb2_readv_worker [cifs=
]
> > > [Wed Dec  4 16:27:10 2024] RIP:
> > > 0010:netfs_consume_read_data.isra.0+0x2d6/0xbe0 [netfs]
> > > [Wed Dec  4 16:27:10 2024] Code: 48 8b 43 78 4c 8b 7d c0 4c 8b 43 68
> > > 48 85 c0 0f 85 76 05 00 00 48 8b 55 90 48 8b 73 30 48 83 c2 70 48 39
> > > d6 74 16 48 8b 7d 88 <48> 8b 4f 68 48 03 4f 60 48 39 4b 60 0f 84 58 0=
6
> > > 00 00 49 29 c0 48
> > > [Wed Dec  4 16:27:10 2024] RSP: 0018:ffffad4a4582bd98 EFLAGS: 0001028=
3
> > > [Wed Dec  4 16:27:10 2024] RAX: 0000000000000000 RBX: ffff9810d6ff628=
0
> > > RCX: 0000000000100000
> > > [Wed Dec  4 16:27:10 2024] RDX: ffff981154071eb0 RSI: ffff9810d6ff71a=
8
> > > RDI: 0000000000000000
> > > [Wed Dec  4 16:27:10 2024] workqueue: smb2_readv_worker [cifs] hogged
> > > CPU for >10000us 4 times, consider switching to WQ_UNBOUND
> > > [Wed Dec  4 16:27:10 2024] RBP: ffffad4a4582be10 R08: 000000000010000=
0
> > > R09: 0000000000000000
> > > [Wed Dec  4 16:27:10 2024] R10: 0000000000000008 R11: fefefefefefefef=
f
> > > R12: 0000000000000000
> > > [Wed Dec  4 16:27:10 2024] workqueue: smb2_readv_worker [cifs] hogged
> > > CPU for >10000us 5 times, consider switching to WQ_UNBOUND
> > > [Wed Dec  4 16:27:10 2024] workqueue: smb2_readv_worker [cifs] hogged
> > > CPU for >10000us 7 times, consider switching to WQ_UNBOUND
> > > [Wed Dec  4 16:27:10 2024] R13: ffff981154072028 R14: 000000000020000=
0
> > > R15: ffff981154072028
> > > [Wed Dec  4 16:27:10 2024] workqueue: smb2_readv_worker [cifs] hogged
> > > CPU for >10000us 11 times, consider switching to WQ_UNBOUND
> > >
> > >
> > > --
> > > Regards,
> > > Shyam
> > >
>
> Ack. Will check further on this today.
>
> --
> Regards,
> Shyam

Hi David,

Here's the output that I get with your patch. This null-ptr deref
crashes the kernel. Even with KASAN enabled, I do not see anything
significantly different:
[Thu Dec  5 09:55:18 2024] Oops: general protection fault, probably
for non-canonical address 0xdffffc000000000c: 0000 [#1] SMP KASAN PTI
[Thu Dec  5 09:55:18 2024] KASAN: null-ptr-deref in range
[0x0000000000000060-0x0000000000000067]
[Thu Dec  5 09:55:18 2024] CPU: 12 UID: 0 PID: 175 Comm: kworker/12:1
Not tainted 6.13.0-rc1-wkasan #12
[Thu Dec  5 09:55:18 2024] Hardware name: Microsoft Corporation
Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1
08/23/2024
[Thu Dec  5 09:55:18 2024] Workqueue: cifsiod smb2_readv_worker [cifs]
[Thu Dec  5 09:55:18 2024] RIP:
0010:netfs_consume_read_data.isra.0+0x74e/0x2a80 [netfs]
[Thu Dec  5 09:55:18 2024] Code: 80 3c 02 00 0f 85 aa 20 00 00 48 8b
85 38 ff ff ff 49 8b 4d 60 48 8d 78 60 48 b8 00 00 00 00 00 fc ff df
48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 0f 21 00 00 48 8b 85 38 ff ff
ff 48 8d 78 68 4c
[Thu Dec  5 09:55:18 2024] RSP: 0018:ffff8881039cfc10 EFLAGS: 00010206
[Thu Dec  5 09:55:18 2024] RAX: dffffc0000000000 RBX: 0000000000100000
RCX: 0000000002400000
[Thu Dec  5 09:55:18 2024] RDX: 000000000000000c RSI: 0000000000000000
RDI: 0000000000000060
[Thu Dec  5 09:55:18 2024] RBP: ffff8881039cfcf0 R08: 0000000000000001
R09: ffffed1020739f76
[Thu Dec  5 09:55:18 2024] R10: 0000000000000003 R11: fefefefefefefeff
R12: ffff88815fcb8c28
[Thu Dec  5 09:55:18 2024] R13: ffff88815fcb8d80 R14: ffff88813ce6fbf0
R15: ffff88813ce6fd68
[Thu Dec  5 09:55:18 2024] FS:  0000000000000000(0000)
GS:ffff889fb2e00000(0000) knlGS:0000000000000000
[Thu Dec  5 09:55:18 2024] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003=
3
[Thu Dec  5 09:55:18 2024] CR2: 0000791b35f99018 CR3: 0000000189996002
CR4: 00000000003706f0
[Thu Dec  5 09:55:18 2024] DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
[Thu Dec  5 09:55:18 2024] DR3: 0000000000000000 DR6: 00000000fffe0ff0
DR7: 0000000000000400
[Thu Dec  5 09:55:18 2024] Call Trace:
[Thu Dec  5 09:55:18 2024]  <TASK>
[Thu Dec  5 09:55:18 2024]  ? show_regs+0x64/0x70
[Thu Dec  5 09:55:18 2024]  ? die_addr+0x41/0xb0
[Thu Dec  5 09:55:18 2024]  ? exc_general_protection+0x163/0x250
[Thu Dec  5 09:55:18 2024]  ? asm_exc_general_protection+0x27/0x30
[Thu Dec  5 09:55:18 2024]  ?
netfs_consume_read_data.isra.0+0x74e/0x2a80 [netfs]
[Thu Dec  5 09:55:18 2024]  netfs_read_subreq_terminated+0x928/0xec0 [netfs=
]
[Thu Dec  5 09:55:18 2024]  ? __pfx___schedule+0x10/0x10
[Thu Dec  5 09:55:18 2024]  ? __pfx__raw_spin_lock_irq+0x10/0x10
[Thu Dec  5 09:55:18 2024]  smb2_readv_worker+0x4b/0x60 [cifs]
[Thu Dec  5 09:55:18 2024]  process_one_work+0x5f3/0xe00
[Thu Dec  5 09:55:18 2024]  ? __kasan_check_write+0x14/0x20
[Thu Dec  5 09:55:18 2024]  worker_thread+0x87c/0x1540
[Thu Dec  5 09:55:18 2024]  ? _raw_spin_lock_irqsave+0x81/0xe0
[Thu Dec  5 09:55:18 2024]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[Thu Dec  5 09:55:18 2024]  ? __pfx_worker_thread+0x10/0x10
[Thu Dec  5 09:55:18 2024]  kthread+0x2a2/0x370
[Thu Dec  5 09:55:18 2024]  ? __pfx_kthread+0x10/0x10
[Thu Dec  5 09:55:18 2024]  ret_from_fork+0x3d/0x80
[Thu Dec  5 09:55:18 2024]  ? __pfx_kthread+0x10/0x10
[Thu Dec  5 09:55:18 2024]  ret_from_fork_asm+0x1a/0x30
[Thu Dec  5 09:55:18 2024]  </TASK>
[Thu Dec  5 09:55:18 2024] Modules linked in: cmac nls_utf8 cifs
cifs_arc4 nls_ucs2_utils cifs_md4 netfs mptcp_diag xsk_diag raw_diag
unix_diag af_packet_diag netlink_diag udp_diag tcp_diag inet_diag qrtr
cfg80211 8021q garp mrp stp llc xt_conntrack nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 xt_owner xt_tcpudp nft_compat nf_tables
binfmt_misc mlx5_ib ib_uverbs macsec ib_core nls_iso8859_1
intel_rapl_msr intel_rapl_common intel_uncore_frequency_common btrfs
isst_if_common blake2b_generic xor mlx5_core mlxfw psample tls joydev
mac_hid serio_raw raid6_pq hid_generic skx_edac_common libcrc32c
crct10dif_pclmul crc32_pclmul polyval_clmulni polyval_generic
ghash_clmulni_intel sha256_ssse3 sha1_ssse3 aesni_intel crypto_simd
cryptd rapl hid_hyperv hyperv_drm vmgenid hyperv_keyboard hid
hv_netvsc hyperv_fb sch_fq_codel dm_multipath msr nvme_fabrics
efi_pstore nfnetlink ip_tables x_tables autofs4
[Thu Dec  5 09:55:18 2024] ---[ end trace 0000000000000000 ]---

RIP shows as the changed line with the patch:
(gdb) l *(netfs_consume_read_data+0x74e)
0x228be is in netfs_consume_read_data (fs/netfs/read_collect.c:260).
255              * donation and should be able to unlock folios and/or
donate nextwards.
256              */
257             if (!subreq->consumed &&
258                 !prev_donated &&
259                 !list_is_first(&subreq->rreq_link, &rreq->subrequests) =
&&
260                 subreq->start =3D=3D prev->start + prev->len) {
<<<<<<<<<<<<<<<<<<<
261                     prev =3D list_prev_entry(subreq, rreq_link);
262                     WRITE_ONCE(prev->next_donated,
prev->next_donated + subreq->len);
263                     subreq->start +=3D subreq->len;
264                     subreq->len =3D 0;


--=20
Regards,
Shyam
