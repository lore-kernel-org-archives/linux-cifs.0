Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A91D17335C
	for <linux-cifs@vger.kernel.org>; Wed,  4 Dec 2024 20:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733345421; cv=none; b=hI3TkJ8j8+Jdt13ZgVD7LCKTo5+wLFaRPYZn8HYKtNniqHlfc2HNPinXVKCXc/bYm1rBy6pC5JGwdI2MqPrYwS62ulSO9bWSmXkjVLAOG4S6EsJxUCMu8RgkAfXvUjTj/JrSJ1xbMa5+6J4eewb+swY0Z7ReQqiDTLwFXIm9PCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733345421; c=relaxed/simple;
	bh=zS/S5iQaUxwqYsuRHngSz7VCbNKGq10Bz2AmTZWMMZA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qDXRn4LL43suFFoanqDsNW1vazqZjVjuHF71ieP4lMEJUHzKkNYS1ItRArkJ7vbx57kMb9Ixac4Wvm9VmqCSbQc0FKlASgq2x2Bw4Ns594OMUjWVr6aC2/yqfbnNZHyvjre8W9dJ2FAO49g8+VQbiK9gebRkKt1gYco06xchQyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FT0KV/7/; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FT0KV/7/"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2ee86a1a92dso182203a91.1
        for <linux-cifs@vger.kernel.org>; Wed, 04 Dec 2024 12:50:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733345418; x=1733950218; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zqjUu1TaL94H4DtlEcTBsxSwFBHL7CZGTxLr1XjWF1U=;
        b=FT0KV/7/vFZxNJg5UzKb0NqfSl2EPqFCR9nU/cSAW4J3lIwrNvSnJKUeMITSrMUlpv
         6d7kGHixtw5qUKgHUIXN41jNUWi90E2J4U4QPQGNn8bcKiAOxV80dRUF5NWKdh/A7Fxn
         U5opBlo+zQqHMUMFbeBXFQXMRW5sPQDXk69+TeQA5WvxtTqY6kljt2/FGP8iDZAy6CNx
         Hni5a1RmZPbjoyCxjGb2dvSMjjcUGi4BbYowrdDXFjxnHLBU23IbvpWUUL2BTW6Vwf4d
         mNlERk78YQgX5gSZm16/g4u0n1s73xuthxI1x78ksi8ZM08Dxs0Df284402fhBSa9k2y
         mF8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733345418; x=1733950218;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zqjUu1TaL94H4DtlEcTBsxSwFBHL7CZGTxLr1XjWF1U=;
        b=lnokVMs1XcfMduh0Rq7rm78yqrRPB9aV9wiQu0n6gnMN2nJ65c6uzdN2xK2j/FUyeC
         5uJHWafxi8xQS6FTWsLfdudFQjgat+lrH1e24S+xAyYXyh1ReKZCykq5XY4Uu1UbRKX6
         mgMN3nlPh81YwqNLo/jSbjyfi59UFF/TNXd34EG47CfTr9uwSejgvOI3TNKV6gxU7NZR
         XPjqDs8myc6Du2YP0PVaXzJHf5ro+KwutnzjmMQ+0S9PklWCM1CA5isqzYhQAGrgkBqi
         8Q3IvmA3Zmi/R/xQ9F4ykt9eD+ydd5NEF2iQ8U+WYnC8z1zXVfgLtBC1huQTI9aY63Pz
         bdOw==
X-Forwarded-Encrypted: i=1; AJvYcCUf7uvDFzC/Z0t7f/Ozze68TSebWyiQHVJU+SBW1dhYtPDOsb0SG7rR/dapreFzweklII7mjL/4GQrK@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6b54KCXSDjsl3FtjVBDRKWNkRzsGHyfLcNzScf6Hot0pV33EI
	x7IRfMfTJB72E7Q8IxMsn11nADXZGtWW5PyWyU1VrB0HZVrjAI4hGwyqDFmTn9rExkwobVpuBZx
	n5pbdBK+B8vtevt6g5/i71jTi4c0=
X-Gm-Gg: ASbGncvTCFt2o/XffiWsjtBYwoezD3h988oyn/Heo2hsoDhFUkVgXV/EpbiZU7TMx5/
	1hgKWa2F5BSxegcR5bzFt/wuxQORq/ew=
X-Google-Smtp-Source: AGHT+IET7+OCIVOzYjbk5AAWwR9t/xOQKVvkZKOOdOMWDsqfXwyPu1c3a9M2fh2eZWX8Vfp9inL4uMTmnqOelKQxXjo=
X-Received: by 2002:a17:90a:ec87:b0:2ee:f19b:86e5 with SMTP id
 98e67ed59e1d1-2ef0120125cmr11070912a91.14.1733345417727; Wed, 04 Dec 2024
 12:50:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANT5p=pUGYwswgXM-pniMjEWwbLK0cKXPBOJB9cG_cOrkBwQhg@mail.gmail.com>
 <CANT5p=qBwjBm-D8soFVVtswGEfmMtQXVW83=TNfUtvyHeFQZBA@mail.gmail.com>
 <505338.1733181074@warthog.procyon.org.uk> <526707.1733224486@warthog.procyon.org.uk>
 <CANT5p=pO28C+XEC44taAT-Z6W_spB-QzJb+MOXv68bDRGqJn=w@mail.gmail.com> <CANT5p=qc97-Ncs4E6_KfcYVxBYU5cw5LnPJoccb3gePa8OuCKg@mail.gmail.com>
In-Reply-To: <CANT5p=qc97-Ncs4E6_KfcYVxBYU5cw5LnPJoccb3gePa8OuCKg@mail.gmail.com>
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Thu, 5 Dec 2024 06:50:05 +1000
Message-ID: <CAN05THTXWKGDynqPLzSfT2j0vvQ9At0YKBHYWMm0KM4mCgyOxA@mail.gmail.com>
Subject: Re: null-ptr deref found in netfs code
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

If you run the kernel under gdb and set a breakpoint on panic you
should be able to see the exact line where it failedand you will also
be able to check the variables and what they are set to.

On Thu, 5 Dec 2024 at 02:31, Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> On Wed, Dec 4, 2024 at 10:00=E2=80=AFPM Shyam Prasad N <nspmangalore@gmai=
l.com> wrote:
> >
> > On Tue, Dec 3, 2024 at 4:44=E2=80=AFPM David Howells <dhowells@redhat.c=
om> wrote:
> > >
> > > Okay, I think I see the problem.
> > >
> > > Looking at the following extraction from the trace:
> > >
> > > > netfs_rreq_ref: R=3D0000290e NEW         r=3D1
> > > > netfs_read: R=3D0000290e READAHEAD c=3D00000000 ni=3D0 s=3D85e00000=
 l=3D800000 sz=3D280000000
> > > > netfs_folio: i=3Df1c2900000000000 ix=3D85e00-85fff read
> > > > netfs_folio: i=3Df1c2900000000000 ix=3D86000-861ff read
> > > > netfs_folio: i=3Df1c2900000000000 ix=3D86200-863ff read
> > > > netfs_folio: i=3Df1c2900000000000 ix=3D86400-865ff read
> > >
> > > We're requesting reads of four folios, each consisting of 512 pages f=
or a
> > > total of 8MiB.
> > >
> > > > netfs_sreq: R=3D0000290e[1] DOWN SUBMT f=3D02 s=3D85e00000 0/100000=
 e=3D0
> > > > netfs_sreq: R=3D0000290e[2] DOWN SUBMT f=3D02 s=3D85f00000 0/100000=
 e=3D0
> > > > netfs_sreq: R=3D0000290e[3] DOWN SUBMT f=3D02 s=3D86000000 0/100000=
 e=3D0
> > > > netfs_sreq: R=3D0000290e[4] DOWN SUBMT f=3D02 s=3D86100000 0/100000=
 e=3D0
> > > > netfs_sreq: R=3D0000290e[5] DOWN SUBMT f=3D02 s=3D86200000 0/100000=
 e=3D0
> > > > netfs_sreq: R=3D0000290e[6] DOWN SUBMT f=3D02 s=3D86300000 0/100000=
 e=3D0
> > > > netfs_sreq: R=3D0000290e[7] DOWN SUBMT f=3D02 s=3D86400000 0/100000=
 e=3D0
> > > > netfs_sreq: R=3D0000290e[8] DOWN SUBMT f=3D02 s=3D86500000 0/100000=
 e=3D0
> > >
> > > That got broken down into 8 submissions, each for a 1MiB slice.
> > >
> > > > netfs_sreq: R=3D0000290e[1] DOWN IO    f=3D02 s=3D85e00000 100000/1=
00000 e=3D0
> > > > netfs_progress: R=3D0000290e[01] s=3D85e00000 ct=3D0/100000 pa=3D10=
0000/100000 sl=3D0
> > > > netfs_donate: R=3D0000290e[01] -> [02] to-next am=3D100000
> > >
> > > Subrequest 1 completed, but wasn't large enough to cover a whole foli=
o, so it
> > > donated its coverage forwards to subreq 2.
> > >
> > > > netfs_sreq: R=3D0000290e[6] DOWN IO    f=3D02 s=3D86300000 100000/1=
00000 e=3D0
> > > > netfs_progress: R=3D0000290e[06] s=3D86300000 ct=3D0/100000 pa=3D10=
0000/100000 sl=3D2
> > > > netfs_donate: R=3D0000290e[06] -> [05] tail-to-prev am=3D100000
> > >
> > > Subrequest 6 completed, but wasn't large enough to cover a whole foli=
o, so it
> > > donated its coverage backwards to subreq 5.
> > >
> > > > netfs_sreq: R=3D0000290e[2] DOWN IO    f=3D02 s=3D85f00000 100000/1=
00000 e=3D0
> > > > netfs_progress: R=3D0000290e[02] s=3D85e00000 ct=3D0/200000 pa=3D20=
0000/200000 sl=3D0
> > > > netfs_folio: i=3Df1c2900000000000 ix=3D85e00-85fff read-done
> > > > netfs_folio: i=3Df1c2900000000000 ix=3D85e00-85fff read-unlock
> > >
> > > Subreq 2 completed, and with the donation from subreq 1, had sufficie=
nt to
> > > unlock the first folio.
> > >
> > > > netfs_sreq: R=3D0000290e[5] DOWN IO    f=3D02 s=3D86200000 100000/1=
00000 e=3D0
> > > > netfs_progress: R=3D0000290e[05] s=3D86200000 ct=3D0/200000 pa=3D20=
0000/200000 sl=3D2
> > > > netfs_folio: i=3Df1c2900000000000 ix=3D86200-863ff read-done
> > > > netfs_folio: i=3Df1c2900000000000 ix=3D86200-863ff read-unlock
> > >
> > > Subreq 5 completed, and with the donation from subreq 6, had sufficie=
nt to
> > > unlock the third folio.
> > >
> > > > netfs_sreq: R=3D0000290e[3] DOWN IO    f=3D02 s=3D86000000 100000/1=
00000 e=3D0
> > > > netfs_progress: R=3D0000290e[03] s=3D86000000 ct=3D0/100000 pa=3D10=
0000/100000 sl=3D1
> > > > netfs_donate: R=3D0000290e[03] -> [04] to-next am=3D100000
> > >
> > > Subrequest 3 completed, but wasn't large enough to cover a whole foli=
o, so it
> > > donated its coverage forwards to subreq 4.  So far, so good.
> > >
> > > > netfs_sreq: R=3D0000290e[7] DOWN IO    f=3D02 s=3D86400000 100000/1=
00000 e=3D0
> > > > netfs_progress: R=3D0000290e[07] s=3D86400000 ct=3D0/100000 pa=3D10=
0000/100000 sl=3D3
> > > > netfs_donate: R=3D0000290e[07] -> [04] to-prev am=3D0
> > >
> > > Subreq 7 completed, but wasn't large enough to cover a whole folio, s=
o it
> > > donated its coverage backwards to subreq 4.  This is a bug as subreq =
7 is not
> > > contiguous with subreq 4.  It should instead have donated forwards to=
 subreq
> > > 8.
> > >
> > > > netfs_sreq: R=3D0000290e[4] DOWN IO    f=3D02 s=3D86100000 100000/1=
00000 e=3D0
> > > > netfs_sreq: R=3D0000290e[4] DOWN +DON  f=3D02 s=3D86000000 300000/3=
00000 e=3D0
> > > > netfs_progress: R=3D0000290e[04] s=3D86000000 ct=3D0/300000 pa=3D20=
0000/300000 sl=3D1
> > > > netfs_folio: i=3Df1c2900000000000 ix=3D86000-861ff read-done
> > > > netfs_folio: i=3Df1c2900000000000 ix=3D86000-861ff read-unlock
> > >
> > > Subreq 4 completed, and with the donation from subreq 2, had sufficie=
nt to
> > > unlock the second folio.  However, it also has some excess from subre=
q 7 that
> > > it can't do anything with - and this gets lost.
> > >
> > > > netfs_sreq: R=3D0000290e[8] DOWN IO    f=3D02 s=3D86500000 100000/1=
00000 e=3D0
> > > > netfs_progress: R=3D0000290e[08] s=3D86500000 ct=3D0/100000 pa=3D10=
0000/100000 sl=3D3
> > > > netfs_donate: R=3D0000290e[08] -> [04] tail-to-prev am=3D100000
> > >
> > > Here's a repeat of the bug: subreq 8 donates to subreq 4, but, again,=
 is not
> > > contiguous.  As these are happening concurrently, the other thread ha=
sn't
> > > delisted subreq 4 yet.
> > >
> > > > netfs_sreq: R=3D0000290e[4] DOWN +DON  f=3D02 s=3D86000000 400000/4=
00000 e=3D0
> > > > netfs_progress: R=3D0000290e[04] s=3D86200000 ct=3D200000/400000 pa=
=3D200000/200000 sl=3D2
> > >
> > > The request screwed at this point: subreq 4 shows the extra stuff it =
has been
> > > donated, but it is unable to do anything with it.  There is no folio =
to
> > > wrangle as the third slot (sl=3D2) in the queue has already been clea=
red.
> > >
> > > (Note that this bug shouldn't happen with the patches currently on my
> > > netfs-writeback branch as I got rid of the donation mechanism in pref=
erence
> > > for something simpler with single-threaded collection.)
> > >
> > > David
> > >
> >
> > Hi David,
> >
> > Tried your submitted patch "netfs: Fix non-contiguous donation between
> > completed reads" with the same workload.
> > It seems to be crashing elsewhere. I'm trying to get the OOPS message
> > and ftrace, but it seems to be crashing the kernel.
> >
> > --
> > Regards,
> > Shyam
>
> Here's what I managed to get before the VM crashed:
>
> [Wed Dec  4 16:27:10 2024] BUG: kernel NULL pointer dereference,
> address: 0000000000000068
> [Wed Dec  4 16:27:10 2024] #PF: supervisor read access in kernel mode
> [Wed Dec  4 16:27:10 2024] #PF: error_code(0x0000) - not-present page
> [Wed Dec  4 16:27:10 2024] PGD 0 P4D 0
> [Wed Dec  4 16:27:10 2024] Oops: Oops: 0000 [#1] SMP PTI
> [Wed Dec  4 16:27:10 2024] CPU: 6 UID: 0 PID: 1263 Comm: kworker/6:3
> Tainted: G           OE      6.12.0-mainline #10
> [Wed Dec  4 16:27:10 2024] Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODU=
LE
> [Wed Dec  4 16:27:10 2024] Hardware name: Microsoft Corporation
> Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1
> 08/23/2024
> [Wed Dec  4 16:27:10 2024] Workqueue: cifsiod smb2_readv_worker [cifs]
> [Wed Dec  4 16:27:10 2024] RIP:
> 0010:netfs_consume_read_data.isra.0+0x2d6/0xbe0 [netfs]
> [Wed Dec  4 16:27:10 2024] Code: 48 8b 43 78 4c 8b 7d c0 4c 8b 43 68
> 48 85 c0 0f 85 76 05 00 00 48 8b 55 90 48 8b 73 30 48 83 c2 70 48 39
> d6 74 16 48 8b 7d 88 <48> 8b 4f 68 48 03 4f 60 48 39 4b 60 0f 84 58 06
> 00 00 49 29 c0 48
> [Wed Dec  4 16:27:10 2024] RSP: 0018:ffffad4a4582bd98 EFLAGS: 00010283
> [Wed Dec  4 16:27:10 2024] RAX: 0000000000000000 RBX: ffff9810d6ff6280
> RCX: 0000000000100000
> [Wed Dec  4 16:27:10 2024] RDX: ffff981154071eb0 RSI: ffff9810d6ff71a8
> RDI: 0000000000000000
> [Wed Dec  4 16:27:10 2024] workqueue: smb2_readv_worker [cifs] hogged
> CPU for >10000us 4 times, consider switching to WQ_UNBOUND
> [Wed Dec  4 16:27:10 2024] RBP: ffffad4a4582be10 R08: 0000000000100000
> R09: 0000000000000000
> [Wed Dec  4 16:27:10 2024] R10: 0000000000000008 R11: fefefefefefefeff
> R12: 0000000000000000
> [Wed Dec  4 16:27:10 2024] workqueue: smb2_readv_worker [cifs] hogged
> CPU for >10000us 5 times, consider switching to WQ_UNBOUND
> [Wed Dec  4 16:27:10 2024] workqueue: smb2_readv_worker [cifs] hogged
> CPU for >10000us 7 times, consider switching to WQ_UNBOUND
> [Wed Dec  4 16:27:10 2024] R13: ffff981154072028 R14: 0000000000200000
> R15: ffff981154072028
> [Wed Dec  4 16:27:10 2024] workqueue: smb2_readv_worker [cifs] hogged
> CPU for >10000us 11 times, consider switching to WQ_UNBOUND
>
>
> --
> Regards,
> Shyam
>
