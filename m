Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36161F16B
	for <linux-cifs@vger.kernel.org>; Wed,  4 Dec 2024 16:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733329903; cv=none; b=l62HawzGFeMevQ3L3xW/SYz40j9Ms+0KLcIXzv4n7WXPRFkz8QrgHQ9dvwfbKIu+MUCFiN8gJcD4rdu668aVhKlP8608bU9JTJmGgnV/7nJTaG5j+ltlzo6duWIRZ80jEz2XTgH1a0e6nA6gWzdXgQbPL/JjolcasmYiUrLWqos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733329903; c=relaxed/simple;
	bh=5sh23WKwYxMmzzRJFfBKsTUfIQBxeAKGv0p5AQ3z2/M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I9soFIZ7D+LpcZ6CzWc1s+Brz+TvFpb83rfk2RZjxNH2f2WdheYDA3+s4UbhSWMRqioEBzbHU+xgKon4Ye0PwcxbzN0b8/vzNHS7tKb3vkNNi4PHeae1xog2cvIMiqKGsm2N3NXN4b2U+x/BuEv7lUlFqB8qmCx81SWerHSQ8to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fb2NUXK0; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fb2NUXK0"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-385d7b4da2bso5628195f8f.1
        for <linux-cifs@vger.kernel.org>; Wed, 04 Dec 2024 08:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733329900; x=1733934700; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bQBZvaxywLd6Wfw3E3LbdSvO7hL2W3G3rxs4REv3MHk=;
        b=Fb2NUXK0dnPtejxycio5CtUzRKHpf5idun3k1VlDgBypXhKlHeDgFUPU9fo5NAfuQZ
         B39YC5IkAP6souFadMIeUvI5FoY3z05GH+y+tdx1ms3S5hfSWkB15VYb8vP4UBH5zV02
         jkzJ0PnMzKFdl9aClEtElHPfUq2ZzmMF36p/594t2ETWu81BUd+pI8GREjQ6oTfJKllv
         bMpE0m2Vz9Gggq9qSHKu6asiAfVpVZGrIOwYAUcRcuXbBuskpS+GRbT1SaYBxA6NkUX6
         +toZOT7NX4N/Y/2gXUIn7V61ACKFL+jnwW5uWzAxORFr2X6W5kp9mMcJy/Kmt02rZgKd
         g+iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733329900; x=1733934700;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bQBZvaxywLd6Wfw3E3LbdSvO7hL2W3G3rxs4REv3MHk=;
        b=v4PxmX1Y+t1CaNG30M+BCDEXVjpaGQNXOcusWd0/sTaaJZbk9C8BDdVT/JtBy9lK7g
         kok2XyZd6BVaoEzAIbn0sVlzC13/9W9q35FZfNCQIO5pBZViRNxPXVNKaaUqjk9snM5e
         DWVs7UTHSoAm71MzUG7grp/tbLCJlLyZRviXBO/ur+9yLD/Zz3U4tOcKoZzFUVA5UQ/i
         p0A2GkrgU0iI8wPJiObwIE4lVDAMHUuNSgDUmBYiUjyNaELTQLW0plNNDFKyKJydAB5a
         UsLY0y9sDJjJtSU7G1WLRbZYg4KfTqsEge3BP8SFlt7Wq9M3WQTeEaEn2B12hU7bEfqM
         +Brw==
X-Forwarded-Encrypted: i=1; AJvYcCUnCSiZrwL1sAC2magcuXwjO+dSYCYM60bRBqpWyHC3+k2cKv0naQLGHcUvBGXMRGL6f6KDaCsHZCP8@vger.kernel.org
X-Gm-Message-State: AOJu0YyLYkFZyI2hlZOVMIdnLwRlplSx1e4KW5IIEJbfYQn2lm7GQ3Na
	RSUUNa5IJe0lnjM6+IZjsL6VLBMJnkEG04eT+GVAQ+Uribw9tpI58AMhyIVF5/dqV6cG33/rXPn
	irniBcx/prpyaUyTixSmiebKGKoU=
X-Gm-Gg: ASbGncuJHBayW1enk/Da5vOIxn3qT8S3MqVczu0iu6m86jk2UD+wZrqxxICmyFe3L6A
	TezSjsSe67F2baXvyp134dICYOulnP58hlr+QART59x5hRft8lpLXAQgV7WPPEA==
X-Google-Smtp-Source: AGHT+IE6i+JV+XMjmAg7wFE10ISiyzljScZOuM8QLivwRKLO90w2Gpi3lSODORYMOP0DKNFh+VKqHfMtlNlxMw02wes=
X-Received: by 2002:a5d:5988:0:b0:382:46ea:113f with SMTP id
 ffacd0b85a97d-385fd3cd9e2mr7646872f8f.10.1733329899380; Wed, 04 Dec 2024
 08:31:39 -0800 (PST)
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
In-Reply-To: <CANT5p=pO28C+XEC44taAT-Z6W_spB-QzJb+MOXv68bDRGqJn=w@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Wed, 4 Dec 2024 22:01:28 +0530
Message-ID: <CANT5p=qc97-Ncs4E6_KfcYVxBYU5cw5LnPJoccb3gePa8OuCKg@mail.gmail.com>
Subject: Re: null-ptr deref found in netfs code
To: David Howells <dhowells@redhat.com>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 10:00=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Tue, Dec 3, 2024 at 4:44=E2=80=AFPM David Howells <dhowells@redhat.com=
> wrote:
> >
> > Okay, I think I see the problem.
> >
> > Looking at the following extraction from the trace:
> >
> > > netfs_rreq_ref: R=3D0000290e NEW         r=3D1
> > > netfs_read: R=3D0000290e READAHEAD c=3D00000000 ni=3D0 s=3D85e00000 l=
=3D800000 sz=3D280000000
> > > netfs_folio: i=3Df1c2900000000000 ix=3D85e00-85fff read
> > > netfs_folio: i=3Df1c2900000000000 ix=3D86000-861ff read
> > > netfs_folio: i=3Df1c2900000000000 ix=3D86200-863ff read
> > > netfs_folio: i=3Df1c2900000000000 ix=3D86400-865ff read
> >
> > We're requesting reads of four folios, each consisting of 512 pages for=
 a
> > total of 8MiB.
> >
> > > netfs_sreq: R=3D0000290e[1] DOWN SUBMT f=3D02 s=3D85e00000 0/100000 e=
=3D0
> > > netfs_sreq: R=3D0000290e[2] DOWN SUBMT f=3D02 s=3D85f00000 0/100000 e=
=3D0
> > > netfs_sreq: R=3D0000290e[3] DOWN SUBMT f=3D02 s=3D86000000 0/100000 e=
=3D0
> > > netfs_sreq: R=3D0000290e[4] DOWN SUBMT f=3D02 s=3D86100000 0/100000 e=
=3D0
> > > netfs_sreq: R=3D0000290e[5] DOWN SUBMT f=3D02 s=3D86200000 0/100000 e=
=3D0
> > > netfs_sreq: R=3D0000290e[6] DOWN SUBMT f=3D02 s=3D86300000 0/100000 e=
=3D0
> > > netfs_sreq: R=3D0000290e[7] DOWN SUBMT f=3D02 s=3D86400000 0/100000 e=
=3D0
> > > netfs_sreq: R=3D0000290e[8] DOWN SUBMT f=3D02 s=3D86500000 0/100000 e=
=3D0
> >
> > That got broken down into 8 submissions, each for a 1MiB slice.
> >
> > > netfs_sreq: R=3D0000290e[1] DOWN IO    f=3D02 s=3D85e00000 100000/100=
000 e=3D0
> > > netfs_progress: R=3D0000290e[01] s=3D85e00000 ct=3D0/100000 pa=3D1000=
00/100000 sl=3D0
> > > netfs_donate: R=3D0000290e[01] -> [02] to-next am=3D100000
> >
> > Subrequest 1 completed, but wasn't large enough to cover a whole folio,=
 so it
> > donated its coverage forwards to subreq 2.
> >
> > > netfs_sreq: R=3D0000290e[6] DOWN IO    f=3D02 s=3D86300000 100000/100=
000 e=3D0
> > > netfs_progress: R=3D0000290e[06] s=3D86300000 ct=3D0/100000 pa=3D1000=
00/100000 sl=3D2
> > > netfs_donate: R=3D0000290e[06] -> [05] tail-to-prev am=3D100000
> >
> > Subrequest 6 completed, but wasn't large enough to cover a whole folio,=
 so it
> > donated its coverage backwards to subreq 5.
> >
> > > netfs_sreq: R=3D0000290e[2] DOWN IO    f=3D02 s=3D85f00000 100000/100=
000 e=3D0
> > > netfs_progress: R=3D0000290e[02] s=3D85e00000 ct=3D0/200000 pa=3D2000=
00/200000 sl=3D0
> > > netfs_folio: i=3Df1c2900000000000 ix=3D85e00-85fff read-done
> > > netfs_folio: i=3Df1c2900000000000 ix=3D85e00-85fff read-unlock
> >
> > Subreq 2 completed, and with the donation from subreq 1, had sufficient=
 to
> > unlock the first folio.
> >
> > > netfs_sreq: R=3D0000290e[5] DOWN IO    f=3D02 s=3D86200000 100000/100=
000 e=3D0
> > > netfs_progress: R=3D0000290e[05] s=3D86200000 ct=3D0/200000 pa=3D2000=
00/200000 sl=3D2
> > > netfs_folio: i=3Df1c2900000000000 ix=3D86200-863ff read-done
> > > netfs_folio: i=3Df1c2900000000000 ix=3D86200-863ff read-unlock
> >
> > Subreq 5 completed, and with the donation from subreq 6, had sufficient=
 to
> > unlock the third folio.
> >
> > > netfs_sreq: R=3D0000290e[3] DOWN IO    f=3D02 s=3D86000000 100000/100=
000 e=3D0
> > > netfs_progress: R=3D0000290e[03] s=3D86000000 ct=3D0/100000 pa=3D1000=
00/100000 sl=3D1
> > > netfs_donate: R=3D0000290e[03] -> [04] to-next am=3D100000
> >
> > Subrequest 3 completed, but wasn't large enough to cover a whole folio,=
 so it
> > donated its coverage forwards to subreq 4.  So far, so good.
> >
> > > netfs_sreq: R=3D0000290e[7] DOWN IO    f=3D02 s=3D86400000 100000/100=
000 e=3D0
> > > netfs_progress: R=3D0000290e[07] s=3D86400000 ct=3D0/100000 pa=3D1000=
00/100000 sl=3D3
> > > netfs_donate: R=3D0000290e[07] -> [04] to-prev am=3D0
> >
> > Subreq 7 completed, but wasn't large enough to cover a whole folio, so =
it
> > donated its coverage backwards to subreq 4.  This is a bug as subreq 7 =
is not
> > contiguous with subreq 4.  It should instead have donated forwards to s=
ubreq
> > 8.
> >
> > > netfs_sreq: R=3D0000290e[4] DOWN IO    f=3D02 s=3D86100000 100000/100=
000 e=3D0
> > > netfs_sreq: R=3D0000290e[4] DOWN +DON  f=3D02 s=3D86000000 300000/300=
000 e=3D0
> > > netfs_progress: R=3D0000290e[04] s=3D86000000 ct=3D0/300000 pa=3D2000=
00/300000 sl=3D1
> > > netfs_folio: i=3Df1c2900000000000 ix=3D86000-861ff read-done
> > > netfs_folio: i=3Df1c2900000000000 ix=3D86000-861ff read-unlock
> >
> > Subreq 4 completed, and with the donation from subreq 2, had sufficient=
 to
> > unlock the second folio.  However, it also has some excess from subreq =
7 that
> > it can't do anything with - and this gets lost.
> >
> > > netfs_sreq: R=3D0000290e[8] DOWN IO    f=3D02 s=3D86500000 100000/100=
000 e=3D0
> > > netfs_progress: R=3D0000290e[08] s=3D86500000 ct=3D0/100000 pa=3D1000=
00/100000 sl=3D3
> > > netfs_donate: R=3D0000290e[08] -> [04] tail-to-prev am=3D100000
> >
> > Here's a repeat of the bug: subreq 8 donates to subreq 4, but, again, i=
s not
> > contiguous.  As these are happening concurrently, the other thread hasn=
't
> > delisted subreq 4 yet.
> >
> > > netfs_sreq: R=3D0000290e[4] DOWN +DON  f=3D02 s=3D86000000 400000/400=
000 e=3D0
> > > netfs_progress: R=3D0000290e[04] s=3D86200000 ct=3D200000/400000 pa=
=3D200000/200000 sl=3D2
> >
> > The request screwed at this point: subreq 4 shows the extra stuff it ha=
s been
> > donated, but it is unable to do anything with it.  There is no folio to
> > wrangle as the third slot (sl=3D2) in the queue has already been cleare=
d.
> >
> > (Note that this bug shouldn't happen with the patches currently on my
> > netfs-writeback branch as I got rid of the donation mechanism in prefer=
ence
> > for something simpler with single-threaded collection.)
> >
> > David
> >
>
> Hi David,
>
> Tried your submitted patch "netfs: Fix non-contiguous donation between
> completed reads" with the same workload.
> It seems to be crashing elsewhere. I'm trying to get the OOPS message
> and ftrace, but it seems to be crashing the kernel.
>
> --
> Regards,
> Shyam

Here's what I managed to get before the VM crashed:

[Wed Dec  4 16:27:10 2024] BUG: kernel NULL pointer dereference,
address: 0000000000000068
[Wed Dec  4 16:27:10 2024] #PF: supervisor read access in kernel mode
[Wed Dec  4 16:27:10 2024] #PF: error_code(0x0000) - not-present page
[Wed Dec  4 16:27:10 2024] PGD 0 P4D 0
[Wed Dec  4 16:27:10 2024] Oops: Oops: 0000 [#1] SMP PTI
[Wed Dec  4 16:27:10 2024] CPU: 6 UID: 0 PID: 1263 Comm: kworker/6:3
Tainted: G           OE      6.12.0-mainline #10
[Wed Dec  4 16:27:10 2024] Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
[Wed Dec  4 16:27:10 2024] Hardware name: Microsoft Corporation
Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1
08/23/2024
[Wed Dec  4 16:27:10 2024] Workqueue: cifsiod smb2_readv_worker [cifs]
[Wed Dec  4 16:27:10 2024] RIP:
0010:netfs_consume_read_data.isra.0+0x2d6/0xbe0 [netfs]
[Wed Dec  4 16:27:10 2024] Code: 48 8b 43 78 4c 8b 7d c0 4c 8b 43 68
48 85 c0 0f 85 76 05 00 00 48 8b 55 90 48 8b 73 30 48 83 c2 70 48 39
d6 74 16 48 8b 7d 88 <48> 8b 4f 68 48 03 4f 60 48 39 4b 60 0f 84 58 06
00 00 49 29 c0 48
[Wed Dec  4 16:27:10 2024] RSP: 0018:ffffad4a4582bd98 EFLAGS: 00010283
[Wed Dec  4 16:27:10 2024] RAX: 0000000000000000 RBX: ffff9810d6ff6280
RCX: 0000000000100000
[Wed Dec  4 16:27:10 2024] RDX: ffff981154071eb0 RSI: ffff9810d6ff71a8
RDI: 0000000000000000
[Wed Dec  4 16:27:10 2024] workqueue: smb2_readv_worker [cifs] hogged
CPU for >10000us 4 times, consider switching to WQ_UNBOUND
[Wed Dec  4 16:27:10 2024] RBP: ffffad4a4582be10 R08: 0000000000100000
R09: 0000000000000000
[Wed Dec  4 16:27:10 2024] R10: 0000000000000008 R11: fefefefefefefeff
R12: 0000000000000000
[Wed Dec  4 16:27:10 2024] workqueue: smb2_readv_worker [cifs] hogged
CPU for >10000us 5 times, consider switching to WQ_UNBOUND
[Wed Dec  4 16:27:10 2024] workqueue: smb2_readv_worker [cifs] hogged
CPU for >10000us 7 times, consider switching to WQ_UNBOUND
[Wed Dec  4 16:27:10 2024] R13: ffff981154072028 R14: 0000000000200000
R15: ffff981154072028
[Wed Dec  4 16:27:10 2024] workqueue: smb2_readv_worker [cifs] hogged
CPU for >10000us 11 times, consider switching to WQ_UNBOUND


--=20
Regards,
Shyam
