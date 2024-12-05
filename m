Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776C114A90
	for <linux-cifs@vger.kernel.org>; Thu,  5 Dec 2024 04:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733374057; cv=none; b=j2Pvk+jAHyXov4wMDE2VNgcTFynPZCFelbt0spJkzJSnOiIjlTBiv0P5FUQGyoylGrjXhUsM1Q01WDfqjoLmX5V484H3HMQrJatzDflAkFufEVzNQvJtqNma3CwZGrw+nBv/bp3tyawN4X9J/GL0i2uXvib5KxjhNNnNrqB5k8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733374057; c=relaxed/simple;
	bh=f3GNTOX9G+NnYyYK8wh6/0wXg9AE1a3EUdkqFZSnmmo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VZi17lkyY902ATq+DeqQ+GwvG8g6N+4ImWsTwNmsnzwakocF32gt12iqH3T84u44jC9tQ7jAps3RJawiBQNax7Rc5JypR7f2P9Qw3fUwnMf1adhLmXCbnvEDP9kBYEdqbLkoPvc4mSFkKAZk2bRYO+lAPrxTxh5b+MHafjMUGpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KHC9/Aqn; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KHC9/Aqn"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aa549f2fa32so90465766b.0
        for <linux-cifs@vger.kernel.org>; Wed, 04 Dec 2024 20:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733374054; x=1733978854; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ZAX9J3HUZ9GowWtCKzxuKoUZ3mW3ORSFDGhGDBOmVM=;
        b=KHC9/Aqnt7mgl1NqEz5F5zAtdWh4Eil8VCeVrhn71FQDoIoHRoF2Ip4cnjx5tNk3gG
         V0xRjtG36vN1HBOZK/DXWzr0/RFhsqf2eBrfHrCv0bDU+iwcup7oSQrvtIgUFxr9IVwn
         yFSHUwc/xVaIiAWTe/PDjkkNtONune6u5ToARBcRTkxymQ1nsLFVcomOP7JsLgkKVhPL
         yBrOJ2OK+eBITsI+nKq9lc323z+zA1cntN3JBRv44czkfyPhsAKe2OiOCQiiRHX1L2M8
         BG46zGMbMekNkDhNdREzsCwlO4L3GcekywoEtz4lEFYDJ5IrxejUChiakCV7ORr1/cwj
         zNWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733374054; x=1733978854;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3ZAX9J3HUZ9GowWtCKzxuKoUZ3mW3ORSFDGhGDBOmVM=;
        b=h77P3vZYC1sKViblqdChghzs2fAyC8sIWaB9yTP+HtT9Doq4jl1m6/jWqR6NIOpK5r
         pz/2LukrQapXwWuAJxkMTnwS0wrrEhB7avBemzq68xtyYshJB5Cpw5sdn+9BSO1PN6fD
         hevfuvnezN4CRcxECgtKUgkBWD2K7vY5juTjNFKW0Qja75AyU6KfRby9Uuw5QywGtSlw
         sWVcPBtwcmp6Yb7QQuf8oFbDEcMP+PgjnD/FEKJn+BYjn2F17Psj93KgaEQJ/38DNCM2
         4MlRKpYDf7Bt1biZGEa6sWQt/ooYSM1riZ19SieEwIlF2UU64qsN1Vcso2hLHxEoYbWZ
         uhow==
X-Forwarded-Encrypted: i=1; AJvYcCWu5Dmr2hlQY2O3qki5TRnAZwKrnqKXos+AxNpqrNv2JhSIdvdCaDMj08ioJaE4t0GRZLK96YkrHh74@vger.kernel.org
X-Gm-Message-State: AOJu0YyBQaFIxox9bKzuPkFqBmAnGtn8+yXXSj4vmfDXBYwNaJIKlRrg
	BcyBL4tvfLfUWouSGO1ECyhCZwY4gvTzlrqKjO6rIHFik0Pgmx/uREH3KoS2obUzB1Ejo3BYx8v
	aOPro+xz+McH/oRCJ8Lkg3rTg/II=
X-Gm-Gg: ASbGnct+dM8ab2ATefvGdntubUZJc78ETW3bZRiYX8nqfg+wEsvwSIOMA1rQYLiKmBt
	LwXfNLvatIMO8FBpBm0rfeXOCSHqXo186xaFIBT6n+cBFkDy5mAZ5NkHjwt1Bdg==
X-Google-Smtp-Source: AGHT+IGuDgVb2HOzeGM/tC6ImYgvT5Rs327VV/0pUCUnLknp8oomLWnTMWrWB+bIU9UhEAkefe3Vf07N1fbPVxvSerQ=
X-Received: by 2002:a17:906:18a9:b0:aa5:3982:660f with SMTP id
 a640c23a62f3a-aa5f7da0fcdmr831173966b.27.1733374053683; Wed, 04 Dec 2024
 20:47:33 -0800 (PST)
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
 <CANT5p=qc97-Ncs4E6_KfcYVxBYU5cw5LnPJoccb3gePa8OuCKg@mail.gmail.com> <CAN05THTXWKGDynqPLzSfT2j0vvQ9At0YKBHYWMm0KM4mCgyOxA@mail.gmail.com>
In-Reply-To: <CAN05THTXWKGDynqPLzSfT2j0vvQ9At0YKBHYWMm0KM4mCgyOxA@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 5 Dec 2024 10:17:22 +0530
Message-ID: <CANT5p=rFSLgCyZ8D1CUcSBzmyW+voAbxbOwRHH+=vPgxhLaRfw@mail.gmail.com>
Subject: Re: null-ptr deref found in netfs code
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 5, 2024 at 2:20=E2=80=AFAM ronnie sahlberg <ronniesahlberg@gmai=
l.com> wrote:
>
> If you run the kernel under gdb and set a breakpoint on panic you
> should be able to see the exact line where it failedand you will also
> be able to check the variables and what they are set to.
>
> On Thu, 5 Dec 2024 at 02:31, Shyam Prasad N <nspmangalore@gmail.com> wrot=
e:
> >
> > On Wed, Dec 4, 2024 at 10:00=E2=80=AFPM Shyam Prasad N <nspmangalore@gm=
ail.com> wrote:
> > >
> > > On Tue, Dec 3, 2024 at 4:44=E2=80=AFPM David Howells <dhowells@redhat=
.com> wrote:
> > > >
> > > > Okay, I think I see the problem.
> > > >
> > > > Looking at the following extraction from the trace:
> > > >
> > > > > netfs_rreq_ref: R=3D0000290e NEW         r=3D1
> > > > > netfs_read: R=3D0000290e READAHEAD c=3D00000000 ni=3D0 s=3D85e000=
00 l=3D800000 sz=3D280000000
> > > > > netfs_folio: i=3Df1c2900000000000 ix=3D85e00-85fff read
> > > > > netfs_folio: i=3Df1c2900000000000 ix=3D86000-861ff read
> > > > > netfs_folio: i=3Df1c2900000000000 ix=3D86200-863ff read
> > > > > netfs_folio: i=3Df1c2900000000000 ix=3D86400-865ff read
> > > >
> > > > We're requesting reads of four folios, each consisting of 512 pages=
 for a
> > > > total of 8MiB.
> > > >
> > > > > netfs_sreq: R=3D0000290e[1] DOWN SUBMT f=3D02 s=3D85e00000 0/1000=
00 e=3D0
> > > > > netfs_sreq: R=3D0000290e[2] DOWN SUBMT f=3D02 s=3D85f00000 0/1000=
00 e=3D0
> > > > > netfs_sreq: R=3D0000290e[3] DOWN SUBMT f=3D02 s=3D86000000 0/1000=
00 e=3D0
> > > > > netfs_sreq: R=3D0000290e[4] DOWN SUBMT f=3D02 s=3D86100000 0/1000=
00 e=3D0
> > > > > netfs_sreq: R=3D0000290e[5] DOWN SUBMT f=3D02 s=3D86200000 0/1000=
00 e=3D0
> > > > > netfs_sreq: R=3D0000290e[6] DOWN SUBMT f=3D02 s=3D86300000 0/1000=
00 e=3D0
> > > > > netfs_sreq: R=3D0000290e[7] DOWN SUBMT f=3D02 s=3D86400000 0/1000=
00 e=3D0
> > > > > netfs_sreq: R=3D0000290e[8] DOWN SUBMT f=3D02 s=3D86500000 0/1000=
00 e=3D0
> > > >
> > > > That got broken down into 8 submissions, each for a 1MiB slice.
> > > >
> > > > > netfs_sreq: R=3D0000290e[1] DOWN IO    f=3D02 s=3D85e00000 100000=
/100000 e=3D0
> > > > > netfs_progress: R=3D0000290e[01] s=3D85e00000 ct=3D0/100000 pa=3D=
100000/100000 sl=3D0
> > > > > netfs_donate: R=3D0000290e[01] -> [02] to-next am=3D100000
> > > >
> > > > Subrequest 1 completed, but wasn't large enough to cover a whole fo=
lio, so it
> > > > donated its coverage forwards to subreq 2.
> > > >
> > > > > netfs_sreq: R=3D0000290e[6] DOWN IO    f=3D02 s=3D86300000 100000=
/100000 e=3D0
> > > > > netfs_progress: R=3D0000290e[06] s=3D86300000 ct=3D0/100000 pa=3D=
100000/100000 sl=3D2
> > > > > netfs_donate: R=3D0000290e[06] -> [05] tail-to-prev am=3D100000
> > > >
> > > > Subrequest 6 completed, but wasn't large enough to cover a whole fo=
lio, so it
> > > > donated its coverage backwards to subreq 5.
> > > >
> > > > > netfs_sreq: R=3D0000290e[2] DOWN IO    f=3D02 s=3D85f00000 100000=
/100000 e=3D0
> > > > > netfs_progress: R=3D0000290e[02] s=3D85e00000 ct=3D0/200000 pa=3D=
200000/200000 sl=3D0
> > > > > netfs_folio: i=3Df1c2900000000000 ix=3D85e00-85fff read-done
> > > > > netfs_folio: i=3Df1c2900000000000 ix=3D85e00-85fff read-unlock
> > > >
> > > > Subreq 2 completed, and with the donation from subreq 1, had suffic=
ient to
> > > > unlock the first folio.
> > > >
> > > > > netfs_sreq: R=3D0000290e[5] DOWN IO    f=3D02 s=3D86200000 100000=
/100000 e=3D0
> > > > > netfs_progress: R=3D0000290e[05] s=3D86200000 ct=3D0/200000 pa=3D=
200000/200000 sl=3D2
> > > > > netfs_folio: i=3Df1c2900000000000 ix=3D86200-863ff read-done
> > > > > netfs_folio: i=3Df1c2900000000000 ix=3D86200-863ff read-unlock
> > > >
> > > > Subreq 5 completed, and with the donation from subreq 6, had suffic=
ient to
> > > > unlock the third folio.
> > > >
> > > > > netfs_sreq: R=3D0000290e[3] DOWN IO    f=3D02 s=3D86000000 100000=
/100000 e=3D0
> > > > > netfs_progress: R=3D0000290e[03] s=3D86000000 ct=3D0/100000 pa=3D=
100000/100000 sl=3D1
> > > > > netfs_donate: R=3D0000290e[03] -> [04] to-next am=3D100000
> > > >
> > > > Subrequest 3 completed, but wasn't large enough to cover a whole fo=
lio, so it
> > > > donated its coverage forwards to subreq 4.  So far, so good.
> > > >
> > > > > netfs_sreq: R=3D0000290e[7] DOWN IO    f=3D02 s=3D86400000 100000=
/100000 e=3D0
> > > > > netfs_progress: R=3D0000290e[07] s=3D86400000 ct=3D0/100000 pa=3D=
100000/100000 sl=3D3
> > > > > netfs_donate: R=3D0000290e[07] -> [04] to-prev am=3D0
> > > >
> > > > Subreq 7 completed, but wasn't large enough to cover a whole folio,=
 so it
> > > > donated its coverage backwards to subreq 4.  This is a bug as subre=
q 7 is not
> > > > contiguous with subreq 4.  It should instead have donated forwards =
to subreq
> > > > 8.
> > > >
> > > > > netfs_sreq: R=3D0000290e[4] DOWN IO    f=3D02 s=3D86100000 100000=
/100000 e=3D0
> > > > > netfs_sreq: R=3D0000290e[4] DOWN +DON  f=3D02 s=3D86000000 300000=
/300000 e=3D0
> > > > > netfs_progress: R=3D0000290e[04] s=3D86000000 ct=3D0/300000 pa=3D=
200000/300000 sl=3D1
> > > > > netfs_folio: i=3Df1c2900000000000 ix=3D86000-861ff read-done
> > > > > netfs_folio: i=3Df1c2900000000000 ix=3D86000-861ff read-unlock
> > > >
> > > > Subreq 4 completed, and with the donation from subreq 2, had suffic=
ient to
> > > > unlock the second folio.  However, it also has some excess from sub=
req 7 that
> > > > it can't do anything with - and this gets lost.
> > > >
> > > > > netfs_sreq: R=3D0000290e[8] DOWN IO    f=3D02 s=3D86500000 100000=
/100000 e=3D0
> > > > > netfs_progress: R=3D0000290e[08] s=3D86500000 ct=3D0/100000 pa=3D=
100000/100000 sl=3D3
> > > > > netfs_donate: R=3D0000290e[08] -> [04] tail-to-prev am=3D100000
> > > >
> > > > Here's a repeat of the bug: subreq 8 donates to subreq 4, but, agai=
n, is not
> > > > contiguous.  As these are happening concurrently, the other thread =
hasn't
> > > > delisted subreq 4 yet.
> > > >
> > > > > netfs_sreq: R=3D0000290e[4] DOWN +DON  f=3D02 s=3D86000000 400000=
/400000 e=3D0
> > > > > netfs_progress: R=3D0000290e[04] s=3D86200000 ct=3D200000/400000 =
pa=3D200000/200000 sl=3D2
> > > >
> > > > The request screwed at this point: subreq 4 shows the extra stuff i=
t has been
> > > > donated, but it is unable to do anything with it.  There is no foli=
o to
> > > > wrangle as the third slot (sl=3D2) in the queue has already been cl=
eared.
> > > >
> > > > (Note that this bug shouldn't happen with the patches currently on =
my
> > > > netfs-writeback branch as I got rid of the donation mechanism in pr=
eference
> > > > for something simpler with single-threaded collection.)
> > > >
> > > > David
> > > >
> > >
> > > Hi David,
> > >
> > > Tried your submitted patch "netfs: Fix non-contiguous donation betwee=
n
> > > completed reads" with the same workload.
> > > It seems to be crashing elsewhere. I'm trying to get the OOPS message
> > > and ftrace, but it seems to be crashing the kernel.
> > >
> > > --
> > > Regards,
> > > Shyam
> >
> > Here's what I managed to get before the VM crashed:
> >
> > [Wed Dec  4 16:27:10 2024] BUG: kernel NULL pointer dereference,
> > address: 0000000000000068
> > [Wed Dec  4 16:27:10 2024] #PF: supervisor read access in kernel mode
> > [Wed Dec  4 16:27:10 2024] #PF: error_code(0x0000) - not-present page
> > [Wed Dec  4 16:27:10 2024] PGD 0 P4D 0
> > [Wed Dec  4 16:27:10 2024] Oops: Oops: 0000 [#1] SMP PTI
> > [Wed Dec  4 16:27:10 2024] CPU: 6 UID: 0 PID: 1263 Comm: kworker/6:3
> > Tainted: G           OE      6.12.0-mainline #10
> > [Wed Dec  4 16:27:10 2024] Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MO=
DULE
> > [Wed Dec  4 16:27:10 2024] Hardware name: Microsoft Corporation
> > Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1
> > 08/23/2024
> > [Wed Dec  4 16:27:10 2024] Workqueue: cifsiod smb2_readv_worker [cifs]
> > [Wed Dec  4 16:27:10 2024] RIP:
> > 0010:netfs_consume_read_data.isra.0+0x2d6/0xbe0 [netfs]
> > [Wed Dec  4 16:27:10 2024] Code: 48 8b 43 78 4c 8b 7d c0 4c 8b 43 68
> > 48 85 c0 0f 85 76 05 00 00 48 8b 55 90 48 8b 73 30 48 83 c2 70 48 39
> > d6 74 16 48 8b 7d 88 <48> 8b 4f 68 48 03 4f 60 48 39 4b 60 0f 84 58 06
> > 00 00 49 29 c0 48
> > [Wed Dec  4 16:27:10 2024] RSP: 0018:ffffad4a4582bd98 EFLAGS: 00010283
> > [Wed Dec  4 16:27:10 2024] RAX: 0000000000000000 RBX: ffff9810d6ff6280
> > RCX: 0000000000100000
> > [Wed Dec  4 16:27:10 2024] RDX: ffff981154071eb0 RSI: ffff9810d6ff71a8
> > RDI: 0000000000000000
> > [Wed Dec  4 16:27:10 2024] workqueue: smb2_readv_worker [cifs] hogged
> > CPU for >10000us 4 times, consider switching to WQ_UNBOUND
> > [Wed Dec  4 16:27:10 2024] RBP: ffffad4a4582be10 R08: 0000000000100000
> > R09: 0000000000000000
> > [Wed Dec  4 16:27:10 2024] R10: 0000000000000008 R11: fefefefefefefeff
> > R12: 0000000000000000
> > [Wed Dec  4 16:27:10 2024] workqueue: smb2_readv_worker [cifs] hogged
> > CPU for >10000us 5 times, consider switching to WQ_UNBOUND
> > [Wed Dec  4 16:27:10 2024] workqueue: smb2_readv_worker [cifs] hogged
> > CPU for >10000us 7 times, consider switching to WQ_UNBOUND
> > [Wed Dec  4 16:27:10 2024] R13: ffff981154072028 R14: 0000000000200000
> > R15: ffff981154072028
> > [Wed Dec  4 16:27:10 2024] workqueue: smb2_readv_worker [cifs] hogged
> > CPU for >10000us 11 times, consider switching to WQ_UNBOUND
> >
> >
> > --
> > Regards,
> > Shyam
> >

Ack. Will check further on this today.

--=20
Regards,
Shyam
