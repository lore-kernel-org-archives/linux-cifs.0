Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AAF288A2
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jan 2025 15:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737647278; cv=none; b=OgLZK36EHCJiPOE80O9zVhG2NXtlwH3c3zEmzGLBl4iJImM3l4yN0BQWI3mZdM923JXvZFzqauOAkhC3oU9nPUmMerKJ1kA2sYjiUbT8U1U+3SAX13QaoFuV8G5zL6ILwzZqwdoeItpRNOOGCQpdOPrId6M022nCXoA4IMUPNew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737647278; c=relaxed/simple;
	bh=NcbKimoqshqaOMCHUqXdVwOthY0WcCsHqPGNmg5g8Bc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XsAX3miJwClVUaAgNYYM56cKaiSYuayxl8tRtrkXyjlo+tksTYyKfE6M54alUmDwYoEm4nVaTmw9e61EbFZjKS1jjGrheIxv4q5NgKEBQoMWmb4cyMnlczhCUulvmxf/lSLaN/mOQny5kzV9lIRzGD9tG/wXC+eFsHhWTAcgQKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jwh1F0Nx; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jwh1F0Nx"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-aaeef97ff02so208775566b.1
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jan 2025 07:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737647274; x=1738252074; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WhWxvpbSySfLX4KWoW4V6xTkm9JUHKZG9qrm1uci0f4=;
        b=jwh1F0NxsKuf+/3sKWLjRfbUIaVmbm40Rq1qXf3n2HisAhT9wnmJVnMYl5yJDmn9gd
         wDSqqIQOoE+56EpZZiCLXz4GNbaVEkOeDLrMM0pX8BY8VMc/O32PpIzQEygh0FyjCPsv
         Ok/fQlswNGkRvJLcmxv24FiuO0c7zFCmgmSzpq7aoSgAcBEQC22gFGcKqau3NG3Tmj1a
         Qb6mKerdFHmz9A1Re+0rgALVyygHN/dYAuDzZ9hhNk0f3daa/1FL5uhPyd0rDTdfJ3Rw
         lyA3l3ygMwW8GHPK4tiXtxOcm4aLlKiSoApnyAqSsxHnQ8EcZLJSs9UYoIAl5w2tClm5
         HW6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737647274; x=1738252074;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WhWxvpbSySfLX4KWoW4V6xTkm9JUHKZG9qrm1uci0f4=;
        b=ACAX8nnAW/M9noKYKnQabh6X9uOFwH9ADGYTmNu2j5xwCEcj8ZB81/YazVwwS3SXr0
         E8jlYy4Nyc1sBXaA5/VtQfgOBWkJLhMVs2K8bUCOX6LTSqedSVeJvfawlD2uXq4gHyaK
         b93o6N1cjXCY+vip3wW4kYf2fHjougrsW8+pSSOPn2QYWbjqFCdIwR+8YjcU6qg7Ew6F
         Qf/vrBODcrnOENPzetkfaQYPVReUgUIOod4s55dzFO39wGRC7bVl0oa9dh4G/4C5lo1e
         0vcDu9svFZZ7/gnPypbLxy5kaxbyALSU0IEo4/mufAD/HPR6W53oOnqnXaSBEZFIvct4
         k99g==
X-Forwarded-Encrypted: i=1; AJvYcCUO14eMHguUqSFwMTRmk0zTBnz0Lke/ycqVRfqT2rAQTJnOVUm+4sH3/ThokMhFvP0z4aD2CIWVVYP0@vger.kernel.org
X-Gm-Message-State: AOJu0YzCQfvJdMFGL+v4hsOlQ5SMwS4AzVTIBNdrBUTu2dnxZz+PiO0x
	GdBXTCQE/EKppTijxtvu5g/PcGEA33AUDwY1wn2F+ICvPDol3hcT+G8+++qNObQdeyzVVUvliV7
	qA9YXoMn5YyOwQfpMPqUCYBCLMjGgrw==
X-Gm-Gg: ASbGncs6c0otWlKR0zkIdDB77klt0ph384Cmf7IgqivheDo54v/XwEADJjc6e+9B5FR
	EcKxA+Hv3Gn1Xt72dh5i9ySc7mMvKJdWXy1TsbA5XfxyoNcI7hl3CZqlIeBaO/NI57gPKmh2STT
	pEyR9pGVioXz78cTUk
X-Google-Smtp-Source: AGHT+IGRzBkQ72EMEu4rxIOCoRzMhJcFh21dQmqgQWEw0rOIA1tmWk09oPJsSSIEJQiBx9XtFVlRpEH66LF6M8OzayA=
X-Received: by 2002:a17:907:72d0:b0:aa6:912f:7ec1 with SMTP id
 a640c23a62f3a-ab38b44d439mr2553834266b.39.1737647273376; Thu, 23 Jan 2025
 07:47:53 -0800 (PST)
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
 <CAN05THTXWKGDynqPLzSfT2j0vvQ9At0YKBHYWMm0KM4mCgyOxA@mail.gmail.com>
 <CANT5p=rFSLgCyZ8D1CUcSBzmyW+voAbxbOwRHH+=vPgxhLaRfw@mail.gmail.com> <CANT5p=rw_mewxPrp0xxQcBRY8Z7Zwg6RQMCXyc7vwWvDur5dHQ@mail.gmail.com>
In-Reply-To: <CANT5p=rw_mewxPrp0xxQcBRY8Z7Zwg6RQMCXyc7vwWvDur5dHQ@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 23 Jan 2025 21:17:41 +0530
X-Gm-Features: AWEUYZm3icYggS0LPgmhAM6c4whHq2JnLC4wCqUJaB_8rjZ84-828yBjqs9glrY
Message-ID: <CANT5p=peKRDJi6XHKpuDKx82sJdJKVwa-gW_KGUOcyh_rt0tWQ@mail.gmail.com>
Subject: Re: null-ptr deref found in netfs code
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000079b0be062c618815"

--00000000000079b0be062c618815
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 5, 2024 at 4:19=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.c=
om> wrote:
>
> On Thu, Dec 5, 2024 at 10:17=E2=80=AFAM Shyam Prasad N <nspmangalore@gmai=
l.com> wrote:
> >
> > On Thu, Dec 5, 2024 at 2:20=E2=80=AFAM ronnie sahlberg <ronniesahlberg@=
gmail.com> wrote:
> > >
> > > If you run the kernel under gdb and set a breakpoint on panic you
> > > should be able to see the exact line where it failedand you will also
> > > be able to check the variables and what they are set to.
> > >
> > > On Thu, 5 Dec 2024 at 02:31, Shyam Prasad N <nspmangalore@gmail.com> =
wrote:
> > > >
> > > > On Wed, Dec 4, 2024 at 10:00=E2=80=AFPM Shyam Prasad N <nspmangalor=
e@gmail.com> wrote:
> > > > >
> > > > > On Tue, Dec 3, 2024 at 4:44=E2=80=AFPM David Howells <dhowells@re=
dhat.com> wrote:
> > > > > >
> > > > > > Okay, I think I see the problem.
> > > > > >
> > > > > > Looking at the following extraction from the trace:
> > > > > >
> > > > > > > netfs_rreq_ref: R=3D0000290e NEW         r=3D1
> > > > > > > netfs_read: R=3D0000290e READAHEAD c=3D00000000 ni=3D0 s=3D85=
e00000 l=3D800000 sz=3D280000000
> > > > > > > netfs_folio: i=3Df1c2900000000000 ix=3D85e00-85fff read
> > > > > > > netfs_folio: i=3Df1c2900000000000 ix=3D86000-861ff read
> > > > > > > netfs_folio: i=3Df1c2900000000000 ix=3D86200-863ff read
> > > > > > > netfs_folio: i=3Df1c2900000000000 ix=3D86400-865ff read
> > > > > >
> > > > > > We're requesting reads of four folios, each consisting of 512 p=
ages for a
> > > > > > total of 8MiB.
> > > > > >
> > > > > > > netfs_sreq: R=3D0000290e[1] DOWN SUBMT f=3D02 s=3D85e00000 0/=
100000 e=3D0
> > > > > > > netfs_sreq: R=3D0000290e[2] DOWN SUBMT f=3D02 s=3D85f00000 0/=
100000 e=3D0
> > > > > > > netfs_sreq: R=3D0000290e[3] DOWN SUBMT f=3D02 s=3D86000000 0/=
100000 e=3D0
> > > > > > > netfs_sreq: R=3D0000290e[4] DOWN SUBMT f=3D02 s=3D86100000 0/=
100000 e=3D0
> > > > > > > netfs_sreq: R=3D0000290e[5] DOWN SUBMT f=3D02 s=3D86200000 0/=
100000 e=3D0
> > > > > > > netfs_sreq: R=3D0000290e[6] DOWN SUBMT f=3D02 s=3D86300000 0/=
100000 e=3D0
> > > > > > > netfs_sreq: R=3D0000290e[7] DOWN SUBMT f=3D02 s=3D86400000 0/=
100000 e=3D0
> > > > > > > netfs_sreq: R=3D0000290e[8] DOWN SUBMT f=3D02 s=3D86500000 0/=
100000 e=3D0
> > > > > >
> > > > > > That got broken down into 8 submissions, each for a 1MiB slice.
> > > > > >
> > > > > > > netfs_sreq: R=3D0000290e[1] DOWN IO    f=3D02 s=3D85e00000 10=
0000/100000 e=3D0
> > > > > > > netfs_progress: R=3D0000290e[01] s=3D85e00000 ct=3D0/100000 p=
a=3D100000/100000 sl=3D0
> > > > > > > netfs_donate: R=3D0000290e[01] -> [02] to-next am=3D100000
> > > > > >
> > > > > > Subrequest 1 completed, but wasn't large enough to cover a whol=
e folio, so it
> > > > > > donated its coverage forwards to subreq 2.
> > > > > >
> > > > > > > netfs_sreq: R=3D0000290e[6] DOWN IO    f=3D02 s=3D86300000 10=
0000/100000 e=3D0
> > > > > > > netfs_progress: R=3D0000290e[06] s=3D86300000 ct=3D0/100000 p=
a=3D100000/100000 sl=3D2
> > > > > > > netfs_donate: R=3D0000290e[06] -> [05] tail-to-prev am=3D1000=
00
> > > > > >
> > > > > > Subrequest 6 completed, but wasn't large enough to cover a whol=
e folio, so it
> > > > > > donated its coverage backwards to subreq 5.
> > > > > >
> > > > > > > netfs_sreq: R=3D0000290e[2] DOWN IO    f=3D02 s=3D85f00000 10=
0000/100000 e=3D0
> > > > > > > netfs_progress: R=3D0000290e[02] s=3D85e00000 ct=3D0/200000 p=
a=3D200000/200000 sl=3D0
> > > > > > > netfs_folio: i=3Df1c2900000000000 ix=3D85e00-85fff read-done
> > > > > > > netfs_folio: i=3Df1c2900000000000 ix=3D85e00-85fff read-unloc=
k
> > > > > >
> > > > > > Subreq 2 completed, and with the donation from subreq 1, had su=
fficient to
> > > > > > unlock the first folio.
> > > > > >
> > > > > > > netfs_sreq: R=3D0000290e[5] DOWN IO    f=3D02 s=3D86200000 10=
0000/100000 e=3D0
> > > > > > > netfs_progress: R=3D0000290e[05] s=3D86200000 ct=3D0/200000 p=
a=3D200000/200000 sl=3D2
> > > > > > > netfs_folio: i=3Df1c2900000000000 ix=3D86200-863ff read-done
> > > > > > > netfs_folio: i=3Df1c2900000000000 ix=3D86200-863ff read-unloc=
k
> > > > > >
> > > > > > Subreq 5 completed, and with the donation from subreq 6, had su=
fficient to
> > > > > > unlock the third folio.
> > > > > >
> > > > > > > netfs_sreq: R=3D0000290e[3] DOWN IO    f=3D02 s=3D86000000 10=
0000/100000 e=3D0
> > > > > > > netfs_progress: R=3D0000290e[03] s=3D86000000 ct=3D0/100000 p=
a=3D100000/100000 sl=3D1
> > > > > > > netfs_donate: R=3D0000290e[03] -> [04] to-next am=3D100000
> > > > > >
> > > > > > Subrequest 3 completed, but wasn't large enough to cover a whol=
e folio, so it
> > > > > > donated its coverage forwards to subreq 4.  So far, so good.
> > > > > >
> > > > > > > netfs_sreq: R=3D0000290e[7] DOWN IO    f=3D02 s=3D86400000 10=
0000/100000 e=3D0
> > > > > > > netfs_progress: R=3D0000290e[07] s=3D86400000 ct=3D0/100000 p=
a=3D100000/100000 sl=3D3
> > > > > > > netfs_donate: R=3D0000290e[07] -> [04] to-prev am=3D0
> > > > > >
> > > > > > Subreq 7 completed, but wasn't large enough to cover a whole fo=
lio, so it
> > > > > > donated its coverage backwards to subreq 4.  This is a bug as s=
ubreq 7 is not
> > > > > > contiguous with subreq 4.  It should instead have donated forwa=
rds to subreq
> > > > > > 8.
> > > > > >
> > > > > > > netfs_sreq: R=3D0000290e[4] DOWN IO    f=3D02 s=3D86100000 10=
0000/100000 e=3D0
> > > > > > > netfs_sreq: R=3D0000290e[4] DOWN +DON  f=3D02 s=3D86000000 30=
0000/300000 e=3D0
> > > > > > > netfs_progress: R=3D0000290e[04] s=3D86000000 ct=3D0/300000 p=
a=3D200000/300000 sl=3D1
> > > > > > > netfs_folio: i=3Df1c2900000000000 ix=3D86000-861ff read-done
> > > > > > > netfs_folio: i=3Df1c2900000000000 ix=3D86000-861ff read-unloc=
k
> > > > > >
> > > > > > Subreq 4 completed, and with the donation from subreq 2, had su=
fficient to
> > > > > > unlock the second folio.  However, it also has some excess from=
 subreq 7 that
> > > > > > it can't do anything with - and this gets lost.
> > > > > >
> > > > > > > netfs_sreq: R=3D0000290e[8] DOWN IO    f=3D02 s=3D86500000 10=
0000/100000 e=3D0
> > > > > > > netfs_progress: R=3D0000290e[08] s=3D86500000 ct=3D0/100000 p=
a=3D100000/100000 sl=3D3
> > > > > > > netfs_donate: R=3D0000290e[08] -> [04] tail-to-prev am=3D1000=
00
> > > > > >
> > > > > > Here's a repeat of the bug: subreq 8 donates to subreq 4, but, =
again, is not
> > > > > > contiguous.  As these are happening concurrently, the other thr=
ead hasn't
> > > > > > delisted subreq 4 yet.
> > > > > >
> > > > > > > netfs_sreq: R=3D0000290e[4] DOWN +DON  f=3D02 s=3D86000000 40=
0000/400000 e=3D0
> > > > > > > netfs_progress: R=3D0000290e[04] s=3D86200000 ct=3D200000/400=
000 pa=3D200000/200000 sl=3D2
> > > > > >
> > > > > > The request screwed at this point: subreq 4 shows the extra stu=
ff it has been
> > > > > > donated, but it is unable to do anything with it.  There is no =
folio to
> > > > > > wrangle as the third slot (sl=3D2) in the queue has already bee=
n cleared.
> > > > > >
> > > > > > (Note that this bug shouldn't happen with the patches currently=
 on my
> > > > > > netfs-writeback branch as I got rid of the donation mechanism i=
n preference
> > > > > > for something simpler with single-threaded collection.)
> > > > > >
> > > > > > David
> > > > > >
> > > > >
> > > > > Hi David,
> > > > >
> > > > > Tried your submitted patch "netfs: Fix non-contiguous donation be=
tween
> > > > > completed reads" with the same workload.
> > > > > It seems to be crashing elsewhere. I'm trying to get the OOPS mes=
sage
> > > > > and ftrace, but it seems to be crashing the kernel.
> > > > >
> > > > > --
> > > > > Regards,
> > > > > Shyam
> > > >
> > > > Here's what I managed to get before the VM crashed:
> > > >
> > > > [Wed Dec  4 16:27:10 2024] BUG: kernel NULL pointer dereference,
> > > > address: 0000000000000068
> > > > [Wed Dec  4 16:27:10 2024] #PF: supervisor read access in kernel mo=
de
> > > > [Wed Dec  4 16:27:10 2024] #PF: error_code(0x0000) - not-present pa=
ge
> > > > [Wed Dec  4 16:27:10 2024] PGD 0 P4D 0
> > > > [Wed Dec  4 16:27:10 2024] Oops: Oops: 0000 [#1] SMP PTI
> > > > [Wed Dec  4 16:27:10 2024] CPU: 6 UID: 0 PID: 1263 Comm: kworker/6:=
3
> > > > Tainted: G           OE      6.12.0-mainline #10
> > > > [Wed Dec  4 16:27:10 2024] Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNE=
D_MODULE
> > > > [Wed Dec  4 16:27:10 2024] Hardware name: Microsoft Corporation
> > > > Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1
> > > > 08/23/2024
> > > > [Wed Dec  4 16:27:10 2024] Workqueue: cifsiod smb2_readv_worker [ci=
fs]
> > > > [Wed Dec  4 16:27:10 2024] RIP:
> > > > 0010:netfs_consume_read_data.isra.0+0x2d6/0xbe0 [netfs]
> > > > [Wed Dec  4 16:27:10 2024] Code: 48 8b 43 78 4c 8b 7d c0 4c 8b 43 6=
8
> > > > 48 85 c0 0f 85 76 05 00 00 48 8b 55 90 48 8b 73 30 48 83 c2 70 48 3=
9
> > > > d6 74 16 48 8b 7d 88 <48> 8b 4f 68 48 03 4f 60 48 39 4b 60 0f 84 58=
 06
> > > > 00 00 49 29 c0 48
> > > > [Wed Dec  4 16:27:10 2024] RSP: 0018:ffffad4a4582bd98 EFLAGS: 00010=
283
> > > > [Wed Dec  4 16:27:10 2024] RAX: 0000000000000000 RBX: ffff9810d6ff6=
280
> > > > RCX: 0000000000100000
> > > > [Wed Dec  4 16:27:10 2024] RDX: ffff981154071eb0 RSI: ffff9810d6ff7=
1a8
> > > > RDI: 0000000000000000
> > > > [Wed Dec  4 16:27:10 2024] workqueue: smb2_readv_worker [cifs] hogg=
ed
> > > > CPU for >10000us 4 times, consider switching to WQ_UNBOUND
> > > > [Wed Dec  4 16:27:10 2024] RBP: ffffad4a4582be10 R08: 0000000000100=
000
> > > > R09: 0000000000000000
> > > > [Wed Dec  4 16:27:10 2024] R10: 0000000000000008 R11: fefefefefefef=
eff
> > > > R12: 0000000000000000
> > > > [Wed Dec  4 16:27:10 2024] workqueue: smb2_readv_worker [cifs] hogg=
ed
> > > > CPU for >10000us 5 times, consider switching to WQ_UNBOUND
> > > > [Wed Dec  4 16:27:10 2024] workqueue: smb2_readv_worker [cifs] hogg=
ed
> > > > CPU for >10000us 7 times, consider switching to WQ_UNBOUND
> > > > [Wed Dec  4 16:27:10 2024] R13: ffff981154072028 R14: 0000000000200=
000
> > > > R15: ffff981154072028
> > > > [Wed Dec  4 16:27:10 2024] workqueue: smb2_readv_worker [cifs] hogg=
ed
> > > > CPU for >10000us 11 times, consider switching to WQ_UNBOUND
> > > >
> > > >
> > > > --
> > > > Regards,
> > > > Shyam
> > > >
> >
> > Ack. Will check further on this today.
> >
> > --
> > Regards,
> > Shyam
>
> Hi David,
>
> Here's the output that I get with your patch. This null-ptr deref
> crashes the kernel. Even with KASAN enabled, I do not see anything
> significantly different:
> [Thu Dec  5 09:55:18 2024] Oops: general protection fault, probably
> for non-canonical address 0xdffffc000000000c: 0000 [#1] SMP KASAN PTI
> [Thu Dec  5 09:55:18 2024] KASAN: null-ptr-deref in range
> [0x0000000000000060-0x0000000000000067]
> [Thu Dec  5 09:55:18 2024] CPU: 12 UID: 0 PID: 175 Comm: kworker/12:1
> Not tainted 6.13.0-rc1-wkasan #12
> [Thu Dec  5 09:55:18 2024] Hardware name: Microsoft Corporation
> Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1
> 08/23/2024
> [Thu Dec  5 09:55:18 2024] Workqueue: cifsiod smb2_readv_worker [cifs]
> [Thu Dec  5 09:55:18 2024] RIP:
> 0010:netfs_consume_read_data.isra.0+0x74e/0x2a80 [netfs]
> [Thu Dec  5 09:55:18 2024] Code: 80 3c 02 00 0f 85 aa 20 00 00 48 8b
> 85 38 ff ff ff 49 8b 4d 60 48 8d 78 60 48 b8 00 00 00 00 00 fc ff df
> 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 0f 21 00 00 48 8b 85 38 ff ff
> ff 48 8d 78 68 4c
> [Thu Dec  5 09:55:18 2024] RSP: 0018:ffff8881039cfc10 EFLAGS: 00010206
> [Thu Dec  5 09:55:18 2024] RAX: dffffc0000000000 RBX: 0000000000100000
> RCX: 0000000002400000
> [Thu Dec  5 09:55:18 2024] RDX: 000000000000000c RSI: 0000000000000000
> RDI: 0000000000000060
> [Thu Dec  5 09:55:18 2024] RBP: ffff8881039cfcf0 R08: 0000000000000001
> R09: ffffed1020739f76
> [Thu Dec  5 09:55:18 2024] R10: 0000000000000003 R11: fefefefefefefeff
> R12: ffff88815fcb8c28
> [Thu Dec  5 09:55:18 2024] R13: ffff88815fcb8d80 R14: ffff88813ce6fbf0
> R15: ffff88813ce6fd68
> [Thu Dec  5 09:55:18 2024] FS:  0000000000000000(0000)
> GS:ffff889fb2e00000(0000) knlGS:0000000000000000
> [Thu Dec  5 09:55:18 2024] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050=
033
> [Thu Dec  5 09:55:18 2024] CR2: 0000791b35f99018 CR3: 0000000189996002
> CR4: 00000000003706f0
> [Thu Dec  5 09:55:18 2024] DR0: 0000000000000000 DR1: 0000000000000000
> DR2: 0000000000000000
> [Thu Dec  5 09:55:18 2024] DR3: 0000000000000000 DR6: 00000000fffe0ff0
> DR7: 0000000000000400
> [Thu Dec  5 09:55:18 2024] Call Trace:
> [Thu Dec  5 09:55:18 2024]  <TASK>
> [Thu Dec  5 09:55:18 2024]  ? show_regs+0x64/0x70
> [Thu Dec  5 09:55:18 2024]  ? die_addr+0x41/0xb0
> [Thu Dec  5 09:55:18 2024]  ? exc_general_protection+0x163/0x250
> [Thu Dec  5 09:55:18 2024]  ? asm_exc_general_protection+0x27/0x30
> [Thu Dec  5 09:55:18 2024]  ?
> netfs_consume_read_data.isra.0+0x74e/0x2a80 [netfs]
> [Thu Dec  5 09:55:18 2024]  netfs_read_subreq_terminated+0x928/0xec0 [net=
fs]
> [Thu Dec  5 09:55:18 2024]  ? __pfx___schedule+0x10/0x10
> [Thu Dec  5 09:55:18 2024]  ? __pfx__raw_spin_lock_irq+0x10/0x10
> [Thu Dec  5 09:55:18 2024]  smb2_readv_worker+0x4b/0x60 [cifs]
> [Thu Dec  5 09:55:18 2024]  process_one_work+0x5f3/0xe00
> [Thu Dec  5 09:55:18 2024]  ? __kasan_check_write+0x14/0x20
> [Thu Dec  5 09:55:18 2024]  worker_thread+0x87c/0x1540
> [Thu Dec  5 09:55:18 2024]  ? _raw_spin_lock_irqsave+0x81/0xe0
> [Thu Dec  5 09:55:18 2024]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
> [Thu Dec  5 09:55:18 2024]  ? __pfx_worker_thread+0x10/0x10
> [Thu Dec  5 09:55:18 2024]  kthread+0x2a2/0x370
> [Thu Dec  5 09:55:18 2024]  ? __pfx_kthread+0x10/0x10
> [Thu Dec  5 09:55:18 2024]  ret_from_fork+0x3d/0x80
> [Thu Dec  5 09:55:18 2024]  ? __pfx_kthread+0x10/0x10
> [Thu Dec  5 09:55:18 2024]  ret_from_fork_asm+0x1a/0x30
> [Thu Dec  5 09:55:18 2024]  </TASK>
> [Thu Dec  5 09:55:18 2024] Modules linked in: cmac nls_utf8 cifs
> cifs_arc4 nls_ucs2_utils cifs_md4 netfs mptcp_diag xsk_diag raw_diag
> unix_diag af_packet_diag netlink_diag udp_diag tcp_diag inet_diag qrtr
> cfg80211 8021q garp mrp stp llc xt_conntrack nf_conntrack
> nf_defrag_ipv6 nf_defrag_ipv4 xt_owner xt_tcpudp nft_compat nf_tables
> binfmt_misc mlx5_ib ib_uverbs macsec ib_core nls_iso8859_1
> intel_rapl_msr intel_rapl_common intel_uncore_frequency_common btrfs
> isst_if_common blake2b_generic xor mlx5_core mlxfw psample tls joydev
> mac_hid serio_raw raid6_pq hid_generic skx_edac_common libcrc32c
> crct10dif_pclmul crc32_pclmul polyval_clmulni polyval_generic
> ghash_clmulni_intel sha256_ssse3 sha1_ssse3 aesni_intel crypto_simd
> cryptd rapl hid_hyperv hyperv_drm vmgenid hyperv_keyboard hid
> hv_netvsc hyperv_fb sch_fq_codel dm_multipath msr nvme_fabrics
> efi_pstore nfnetlink ip_tables x_tables autofs4
> [Thu Dec  5 09:55:18 2024] ---[ end trace 0000000000000000 ]---
>
> RIP shows as the changed line with the patch:
> (gdb) l *(netfs_consume_read_data+0x74e)
> 0x228be is in netfs_consume_read_data (fs/netfs/read_collect.c:260).
> 255              * donation and should be able to unlock folios and/or
> donate nextwards.
> 256              */
> 257             if (!subreq->consumed &&
> 258                 !prev_donated &&
> 259                 !list_is_first(&subreq->rreq_link, &rreq->subrequests=
) &&
> 260                 subreq->start =3D=3D prev->start + prev->len) {
> <<<<<<<<<<<<<<<<<<<
> 261                     prev =3D list_prev_entry(subreq, rreq_link);
> 262                     WRITE_ONCE(prev->next_donated,
> prev->next_donated + subreq->len);
> 263                     subreq->start +=3D subreq->len;
> 264                     subreq->len =3D 0;
>
>
> --
> Regards,
> Shyam

Hi David,

I tried this again with 6.13-rc1 and the null-ptr deref seems to be
slightly different (same function).
It is taking me some time due to unfamiliarity of the code. Maybe
you'll get it sooner.
We're trying to see if we can hook gdb when this happens. More details
on that tomorrow.

--=20
Regards,
Shyam

--00000000000079b0be062c618815
Content-Type: text/plain; charset="US-ASCII"; name="oops.txt"
Content-Disposition: attachment; filename="oops.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_m69hxml10>
X-Attachment-Id: f_m69hxml10

W1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0t
LS0tLS0tDQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSBXQVJOSU5HOiBDUFU6IDQgUElEOiA1
NzEgYXQgZnMvbmV0ZnMvcmVhZF9jb2xsZWN0LmM6MTEwIG5ldGZzX2NvbnN1bWVfcmVhZF9kYXRh
LmlzcmEuMCsweDU5Ni8weDkwMCBbbmV0ZnNdDQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSBN
b2R1bGVzIGxpbmtlZCBpbjogY21hYyBubHNfdXRmOCBjaWZzIGNpZnNfYXJjNCBubHNfdWNzMl91
dGlscyBjaWZzX21kNCBuZXRmcyBxcnRyIGNmZzgwMjExIDgwMjFxIGdhcnAgbXJwIHN0cCBsbGMg
eHRfY29ubnRyYWNrIG5mX2Nvbm50cmFjayBuZl9kZWZyYWdfaXB2NiBuZl9kZWZyYWdfaXB2NCB4
dF9vd25lciB4dF90Y3B1ZHAgbmZ0X2NvbXBhdCBuZl90YWJsZXMgYmluZm10X21pc2MgbmxzX2lz
bzg4NTlfMSBpbnRlbF9yYXBsX21zciBpbnRlbF9yYXBsX2NvbW1vbiBpbnRlbF91bmNvcmVfZnJl
cXVlbmN5X2NvbW1vbiBpc3N0X2lmX2NvbW1vbiBza3hfZWRhY19jb21tb24gbmZpdCByYXBsIHZt
Z2VuaWQgaHlwZXJ2X2RybSBodl9iYWxsb29uIGpveWRldiBzZXJpb19yYXcgbWFjX2hpZCBzY2hf
ZnFfY29kZWwgZG1fbXVsdGlwYXRoIG52bWVfZmFicmljcyBudm1lX2tleXJpbmcgbXNyIG52bWVf
Y29yZSBudm1lX2F1dGggZWZpX3BzdG9yZSBuZm5ldGxpbmsgZG1pX3N5c2ZzIGlwX3RhYmxlcyB4
X3RhYmxlcyBhdXRvZnM0IGJ0cmZzIGJsYWtlMmJfZ2VuZXJpYyByYWlkMTAgcmFpZDQ1NiBhc3lu
Y19yYWlkNl9yZWNvdiBhc3luY19tZW1jcHkgYXN5bmNfcHEgYXN5bmNfeG9yIGFzeW5jX3R4IHhv
ciByYWlkNl9wcSBsaWJjcmMzMmMgcmFpZDEgcmFpZDAgbWx4NV9pYiBpYl91dmVyYnMgbWFjc2Vj
IGliX2NvcmUgbWx4NV9jb3JlIG1seGZ3IHBzYW1wbGUgdGxzIHBjaV9oeXBlcnYgcGNpX2h5cGVy
dl9pbnRmIGhpZF9nZW5lcmljIGh2X3N0b3J2c2MgaGlkX2h5cGVydiBoaWQgaHZfbmV0dnNjIHNj
c2lfdHJhbnNwb3J0X2ZjIGh5cGVydl9mYiBodl91dGlscyBoeXBlcnZfa2V5Ym9hcmQgY3JjdDEw
ZGlmX3BjbG11bCBjcmMzMl9wY2xtdWwgcG9seXZhbF9jbG11bG5pIHBvbHl2YWxfZ2VuZXJpYyBn
aGFzaF9jbG11bG5pX2ludGVsIHNoYTI1Nl9zc3NlMyBzaGExX3Nzc2UzIGh2X3ZtYnVzIGFlc25p
X2ludGVsIGNyeXB0b19zaW1kIGNyeXB0ZA0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gQ1BV
OiA0IFVJRDogMCBQSUQ6IDU3MSBDb21tOiBrd29ya2VyLzQ6MiBOb3QgdGFpbnRlZCA2LjEzLjAt
MDYxMzAwcmMxLWdlbmVyaWMgIzIwMjQxMjAxMjMyNw0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAy
NV0gSGFyZHdhcmUgbmFtZTogTWljcm9zb2Z0IENvcnBvcmF0aW9uIFZpcnR1YWwgTWFjaGluZS9W
aXJ0dWFsIE1hY2hpbmUsIEJJT1MgSHlwZXItViBVRUZJIFJlbGVhc2UgdjQuMSAwOC8yMy8yMDI0
DQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSBXb3JrcXVldWU6IGNpZnNpb2Qgc21iMl9yZWFk
dl93b3JrZXIgW2NpZnNdDQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSBSSVA6IDAwMTA6bmV0
ZnNfY29uc3VtZV9yZWFkX2RhdGEuaXNyYS4wKzB4NTk2LzB4OTAwIFtuZXRmc10NCltXZWQgSmFu
IDIyIDEwOjM5OjM5IDIwMjVdIENvZGU6IDQ4IDhiIDc1IDkwIDQ4IDhkIDRhIGQ4IDQ1IDMxIGM5
IDQ4IDg5IGRhIGU4IGExIGEzIGZmIGZmIDY1IGZmIDBkIGIyIGY5IDBjIDNmIDBmIDg1IDAzIGZm
IGZmIGZmIDBmIDFmIDQ0IDAwIDAwIGU5IGY5IGZlIGZmIGZmIDwwZj4gMGIgNDggOGIgNDMgNzAg
NDggOGIgNzUgOTAgNGMgODkgNTUgZDAgNGMgODkgZjkgOGIgN2QgOWMgMGYgYjcNCltXZWQgSmFu
IDIyIDEwOjM5OjM5IDIwMjVdIFJTUDogMDAxODpmZmZmYzE3MDAwZDliZDkwIEVGTEFHUzogMDAw
MTAyNDYNCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdIFJBWDogZmZmZjlkMDMwYThkZWMwMCBS
Qlg6IGZmZmY5ZDAzZTYwZjlhNDAgUkNYOiAwMDAwMDAwMDAwMDAwMDA5DQpbV2VkIEphbiAyMiAx
MDozOTozOSAyMDI1XSBSRFg6IDAwMDAwMDAwMDI4MDAwMDAgUlNJOiAwMDAwMDAwMDAwMDAwMDAw
IFJESTogMDAwMDAwMDAwMDAwMDAwMA0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gUkJQOiBm
ZmZmYzE3MDAwZDliZTAwIFIwODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6IDAwMDAwMDAwMDAyMDAw
MDANCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdIFIxMDogMDAwMDAwMDAwMDAwMDAwNSBSMTE6
IDAwMDAwMDAwMDAwMDAwMDAgUjEyOiAwMDAwMDAwMDAwMDAwMDAwDQpbV2VkIEphbiAyMiAxMDoz
OTozOSAyMDI1XSBSMTM6IGZmZmY5ZDAzNjRjODc1NjggUjE0OiAwMDAwMDAwMDAwMjAwMDAwIFIx
NTogMDAwMDAwMDAwMjYwMDAwMA0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gRlM6ICAwMDAw
MDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmY5ZDI1NTM2MDAwMDAoMDAwMCkga25sR1M6MDAwMDAw
MDAwMDAwMDAwMA0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gQ1M6ICAwMDEwIERTOiAwMDAw
IEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzMw0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAy
NV0gQ1IyOiAwMDAwNzdjZjFkZWVlMjAwIENSMzogMDAwMDAwMDEwNjJjODAwNSBDUjQ6IDAwMDAw
MDAwMDAzNzA2ZjANCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdIERSMDogMDAwMDAwMDAwMDAw
MDAwMCBEUjE6IDAwMDAwMDAwMDAwMDAwMDAgRFIyOiAwMDAwMDAwMDAwMDAwMDAwDQpbV2VkIEph
biAyMiAxMDozOTozOSAyMDI1XSBEUjM6IDAwMDAwMDAwMDAwMDAwMDAgRFI2OiAwMDAwMDAwMGZm
ZmUwZmYwIERSNzogMDAwMDAwMDAwMDAwMDQwMA0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0g
Q2FsbCBUcmFjZToNCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdICA8VEFTSz4NCltXZWQgSmFu
IDIyIDEwOjM5OjM5IDIwMjVdICA/IHNob3dfdHJhY2VfbG9nX2x2bCsweDFiZS8weDMxMA0KW1dl
ZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gID8gc2hvd190cmFjZV9sb2dfbHZsKzB4MWJlLzB4MzEw
DQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSAgPyBuZXRmc19yZWFkX3N1YnJlcV90ZXJtaW5h
dGVkKzB4MmNlLzB4NDIwIFtuZXRmc10NCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdICA/IHNo
b3dfcmVncy5wYXJ0LjArMHgyMi8weDMwDQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSAgPyBz
aG93X3JlZ3MuY29sZCsweDgvMHgxMA0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gID8gbmV0
ZnNfY29uc3VtZV9yZWFkX2RhdGEuaXNyYS4wKzB4NTk2LzB4OTAwIFtuZXRmc10NCltXZWQgSmFu
IDIyIDEwOjM5OjM5IDIwMjVdICA/IF9fd2Fybi5jb2xkKzB4YWMvMHgxMGMNCltXZWQgSmFuIDIy
IDEwOjM5OjM5IDIwMjVdICA/IG5ldGZzX2NvbnN1bWVfcmVhZF9kYXRhLmlzcmEuMCsweDU5Ni8w
eDkwMCBbbmV0ZnNdDQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSAgPyByZXBvcnRfYnVnKzB4
MTE0LzB4MTYwDQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSAgPyBoYW5kbGVfYnVnKzB4NmUv
MHhiMA0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gID8gZXhjX2ludmFsaWRfb3ArMHgxOC8w
eDgwDQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSAgPyBhc21fZXhjX2ludmFsaWRfb3ArMHgx
Yi8weDIwDQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSAgPyBuZXRmc19jb25zdW1lX3JlYWRf
ZGF0YS5pc3JhLjArMHg1OTYvMHg5MDAgW25ldGZzXQ0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAy
NV0gIG5ldGZzX3JlYWRfc3VicmVxX3Rlcm1pbmF0ZWQrMHgyY2UvMHg0MjAgW25ldGZzXQ0KW1dl
ZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gIHNtYjJfcmVhZHZfd29ya2VyKzB4MWEvMHgzMCBbY2lm
c10NCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdICBwcm9jZXNzX29uZV93b3JrKzB4MTc3LzB4
MzUwDQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSAgd29ya2VyX3RocmVhZCsweDMzYS8weDQ3
MA0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gID8gX3Jhd19zcGluX3VubG9ja19pcnFyZXN0
b3JlKzB4MTEvMHg2MA0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gID8gX19wZnhfd29ya2Vy
X3RocmVhZCsweDEwLzB4MTANCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdICBrdGhyZWFkKzB4
ZTQvMHgxMTANCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdICA/IF9fcGZ4X2t0aHJlYWQrMHgx
MC8weDEwDQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSAgcmV0X2Zyb21fZm9yaysweDQ3LzB4
NzANCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdICA/IF9fcGZ4X2t0aHJlYWQrMHgxMC8weDEw
DQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSAgcmV0X2Zyb21fZm9ya19hc20rMHgxYS8weDMw
DQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSAgPC9UQVNLPg0KW1dlZCBKYW4gMjIgMTA6Mzk6
MzkgMjAyNV0gLS0tWyBlbmQgdHJhY2UgMDAwMDAwMDAwMDAwMDAwMCBdLS0tDQpbV2VkIEphbiAy
MiAxMDozOTozOSAyMDI1XSBuZXRmczogUj0wMDAwNWEwOFthXSBzPTI2MDAwMDAtMjlmZmZmZiBj
dGw9MjAwMDAwLzQwMDAwMC80MDAwMDAgc2w9NQ0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0g
bmV0ZnM6IGZvbGlvcTogb3JkZXJzPTA5MDkwOTA5DQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1
XSBCVUc6IGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UsIGFkZHJlc3M6IDAwMDAwMDAw
MDAwMDAwMDANCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdICNQRjogc3VwZXJ2aXNvciB3cml0
ZSBhY2Nlc3MgaW4ga2VybmVsIG1vZGUNCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdICNQRjog
ZXJyb3JfY29kZSgweDAwMDIpIC0gbm90LXByZXNlbnQgcGFnZQ0KW1dlZCBKYW4gMjIgMTA6Mzk6
MzkgMjAyNV0gUEdEIDgwMDAwMDAxMGRmOWIwNjcgUDREIDgwMDAwMDAxMGRmOWIwNjcgUFVEIDEw
MjlmMjA2NyBQTUQgMA0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gT29wczogT29wczogMDAw
MiBbIzFdIFBSRUVNUFQgU01QIFBUSQ0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gQ1BVOiA0
IFVJRDogMCBQSUQ6IDU3MSBDb21tOiBrd29ya2VyLzQ6MiBUYWludGVkOiBHICAgICAgICBXICAg
ICAgICAgIDYuMTMuMC0wNjEzMDByYzEtZ2VuZXJpYyAjMjAyNDEyMDEyMzI3DQpbV2VkIEphbiAy
MiAxMDozOTozOSAyMDI1XSBUYWludGVkOiBbV109V0FSTg0KW1dlZCBKYW4gMjIgMTA6Mzk6Mzkg
MjAyNV0gSGFyZHdhcmUgbmFtZTogTWljcm9zb2Z0IENvcnBvcmF0aW9uIFZpcnR1YWwgTWFjaGlu
ZS9WaXJ0dWFsIE1hY2hpbmUsIEJJT1MgSHlwZXItViBVRUZJIFJlbGVhc2UgdjQuMSAwOC8yMy8y
MDI0DQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSBXb3JrcXVldWU6IGNpZnNpb2Qgc21iMl9y
ZWFkdl93b3JrZXIgW2NpZnNdDQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSBSSVA6IDAwMTA6
bmV0ZnNfdW5sb2NrX3JlYWRfZm9saW8rMHgzNC8weDM4MCBbbmV0ZnNdDQpbV2VkIEphbiAyMiAx
MDozOTozOSAyMDI1XSBDb2RlOiA4OSBlNSA0MSA1NyA0OSA4OSBmZiA0MSA1NiA0OSA4OSBmNiA0
MSA1NSA0MSA1NCA0ZCA4OSBjNCA1MyA0OCA4OSBkMyA0OCA4MyBlYyAxMCA0MSA4MyBmOCAxZSAw
ZiA4NyAxNyAwMyAwMCAwMCA0ZSA4YiA2YyBjMyAwOCA8ZjA+IDQxIDgwIDRkIDAwIDA4IDQ5IDhi
IDg2IDU4IDAyIDAwIDAwIGE5IDAwIDAwIDAwIDgwIDBmIDg1IGQ4IDAwDQpbV2VkIEphbiAyMiAx
MDozOTozOSAyMDI1XSBSU1A6IDAwMTg6ZmZmZmMxNzAwMGQ5YmQ0OCBFRkxBR1M6IDAwMDEwMjk3
DQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSBuZXRmczogUj0wMDAwNWEwOVthXSBzPTM2MDAw
MDAtMzhmZmZmZiBjdGw9MjAwMDAwLzMwMDAwMC8zMDAwMDAgc2w9NQ0KW1dlZCBKYW4gMjIgMTA6
Mzk6MzkgMjAyNV0gUkFYOiAwMDAwMDAwMDAwNDAwMDAwIFJCWDogZmZmZjlkMDMwYThkZWMwMCBS
Q1g6IDAwMDAwMDAwMDAwMDAwMDUNCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdIFJEWDogZmZm
ZjlkMDMwYThkZWMwMCBSU0k6IGZmZmY5ZDAzNjRjODczODAgUkRJOiBmZmZmOWQwM2U2MGY5YTQw
DQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSBSQlA6IGZmZmZjMTcwMDBkOWJkODAgUjA4OiAw
MDAwMDAwMDAwMDAwMDA1IFIwOTogMDAwMDAwMDAwMDAwMDAwMA0KW1dlZCBKYW4gMjIgMTA6Mzk6
MzkgMjAyNV0gUjEwOiAwMDAwMDAwMDAwMDAwMDA1IFIxMTogMDAwMDAwMDAwMjgwMDAwMCBSMTI6
IDAwMDAwMDAwMDAwMDAwMDUNCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdIFIxMzogMDAwMDAw
MDAwMDAwMDAwMCBSMTQ6IGZmZmY5ZDAzNjRjODczODAgUjE1OiBmZmZmOWQwM2U2MGY5YTQwDQpb
V2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6
ZmZmZjlkMjU1MzYwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwDQpbV2VkIEphbiAy
MiAxMDozOTozOSAyMDI1XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAw
MDgwMDUwMDMzDQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSBuZXRmczogZm9saW9xOiBvcmRl
cnM9MDkwOTA5MDkNCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdIENSMjogMDAwMDAwMDAwMDAw
MDAwMCBDUjM6IDAwMDAwMDAxMDYyYzgwMDUgQ1I0OiAwMDAwMDAwMDAwMzcwNmYwDQpbV2VkIEph
biAyMiAxMDozOTozOSAyMDI1XSBEUjA6IDAwMDAwMDAwMDAwMDAwMDAgRFIxOiAwMDAwMDAwMDAw
MDAwMDAwIERSMjogMDAwMDAwMDAwMDAwMDAwMA0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0g
RFIzOiAwMDAwMDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDBmZmZlMGZmMCBEUjc6IDAwMDAwMDAw
MDAwMDA0MDANCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdIENhbGwgVHJhY2U6DQpbV2VkIEph
biAyMiAxMDozOTozOSAyMDI1XSAgPFRBU0s+DQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSAg
PyBzaG93X3RyYWNlX2xvZ19sdmwrMHgxYmUvMHgzMTANCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIw
MjVdICA/IHNob3dfdHJhY2VfbG9nX2x2bCsweDFiZS8weDMxMA0KW1dlZCBKYW4gMjIgMTA6Mzk6
MzkgMjAyNV0gID8gbmV0ZnNfY29uc3VtZV9yZWFkX2RhdGEuaXNyYS4wKzB4M2FjLzB4OTAwIFtu
ZXRmc10NCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdICA/IHNob3dfcmVncy5wYXJ0LjArMHgy
Mi8weDMwDQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSAgPyBfX2RpZV9ib2R5LmNvbGQrMHg4
LzB4MTANCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdICA/IF9fZGllKzB4MmEvMHg0MA0KW1dl
ZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gID8gcGFnZV9mYXVsdF9vb3BzKzB4MTZjLzB4MTgwDQpb
V2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSAgPyBkb191c2VyX2FkZHJfZmF1bHQrMHg0YzkvMHg3
ZTANCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdICA/IHByYl9yZWFkX3ZhbGlkKzB4MWMvMHgz
MA0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gID8gZXhjX3BhZ2VfZmF1bHQrMHg4NS8weDFj
MA0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gID8gYXNtX2V4Y19wYWdlX2ZhdWx0KzB4Mjcv
MHgzMA0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gID8gbmV0ZnNfdW5sb2NrX3JlYWRfZm9s
aW8rMHgzNC8weDM4MCBbbmV0ZnNdDQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSAgbmV0ZnNf
Y29uc3VtZV9yZWFkX2RhdGEuaXNyYS4wKzB4M2FjLzB4OTAwIFtuZXRmc10NCltXZWQgSmFuIDIy
IDEwOjM5OjM5IDIwMjVdICBuZXRmc19yZWFkX3N1YnJlcV90ZXJtaW5hdGVkKzB4MmNlLzB4NDIw
IFtuZXRmc10NCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdICBzbWIyX3JlYWR2X3dvcmtlcisw
eDFhLzB4MzAgW2NpZnNdDQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSAgcHJvY2Vzc19vbmVf
d29yaysweDE3Ny8weDM1MA0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gIHdvcmtlcl90aHJl
YWQrMHgzM2EvMHg0NzANCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdICA/IF9yYXdfc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZSsweDExLzB4NjANCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdICA/
IF9fcGZ4X3dvcmtlcl90aHJlYWQrMHgxMC8weDEwDQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1
XSAga3RocmVhZCsweGU0LzB4MTEwDQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSAgPyBfX3Bm
eF9rdGhyZWFkKzB4MTAvMHgxMA0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gIHJldF9mcm9t
X2ZvcmsrMHg0Ny8weDcwDQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSAgPyBfX3BmeF9rdGhy
ZWFkKzB4MTAvMHgxMA0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gIHJldF9mcm9tX2Zvcmtf
YXNtKzB4MWEvMHgzMA0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gIDwvVEFTSz4NCltXZWQg
SmFuIDIyIDEwOjM5OjM5IDIwMjVdIE1vZHVsZXMgbGlua2VkIGluOiBjbWFjIG5sc191dGY4IGNp
ZnMgY2lmc19hcmM0IG5sc191Y3MyX3V0aWxzIGNpZnNfbWQ0IG5ldGZzIHFydHIgY2ZnODAyMTEg
ODAyMXEgZ2FycCBtcnAgc3RwIGxsYyB4dF9jb25udHJhY2sgbmZfY29ubnRyYWNrIG5mX2RlZnJh
Z19pcHY2IG5mX2RlZnJhZ19pcHY0IHh0X293bmVyIHh0X3RjcHVkcCBuZnRfY29tcGF0IG5mX3Rh
YmxlcyBiaW5mbXRfbWlzYyBubHNfaXNvODg1OV8xIGludGVsX3JhcGxfbXNyIGludGVsX3JhcGxf
Y29tbW9uIGludGVsX3VuY29yZV9mcmVxdWVuY3lfY29tbW9uIGlzc3RfaWZfY29tbW9uIHNreF9l
ZGFjX2NvbW1vbiBuZml0IHJhcGwgdm1nZW5pZCBoeXBlcnZfZHJtIGh2X2JhbGxvb24gam95ZGV2
IHNlcmlvX3JhdyBtYWNfaGlkIHNjaF9mcV9jb2RlbCBkbV9tdWx0aXBhdGggbnZtZV9mYWJyaWNz
IG52bWVfa2V5cmluZyBtc3IgbnZtZV9jb3JlIG52bWVfYXV0aCBlZmlfcHN0b3JlIG5mbmV0bGlu
ayBkbWlfc3lzZnMgaXBfdGFibGVzIHhfdGFibGVzIGF1dG9mczQgYnRyZnMgYmxha2UyYl9nZW5l
cmljIHJhaWQxMCByYWlkNDU2IGFzeW5jX3JhaWQ2X3JlY292IGFzeW5jX21lbWNweSBhc3luY19w
cSBhc3luY194b3IgYXN5bmNfdHggeG9yIHJhaWQ2X3BxIGxpYmNyYzMyYyByYWlkMSByYWlkMCBt
bHg1X2liIGliX3V2ZXJicyBtYWNzZWMgaWJfY29yZSBtbHg1X2NvcmUgbWx4ZncgcHNhbXBsZSB0
bHMgcGNpX2h5cGVydiBwY2lfaHlwZXJ2X2ludGYgaGlkX2dlbmVyaWMgaHZfc3RvcnZzYyBoaWRf
aHlwZXJ2IGhpZCBodl9uZXR2c2Mgc2NzaV90cmFuc3BvcnRfZmMgaHlwZXJ2X2ZiIGh2X3V0aWxz
IGh5cGVydl9rZXlib2FyZCBjcmN0MTBkaWZfcGNsbXVsIGNyYzMyX3BjbG11bCBwb2x5dmFsX2Ns
bXVsbmkgcG9seXZhbF9nZW5lcmljIGdoYXNoX2NsbXVsbmlfaW50ZWwgc2hhMjU2X3Nzc2UzIHNo
YTFfc3NzZTMgaHZfdm1idXMgYWVzbmlfaW50ZWwgY3J5cHRvX3NpbWQgY3J5cHRkDQpbV2VkIEph
biAyMiAxMDozOTozOSAyMDI1XSBDUjI6IDAwMDAwMDAwMDAwMDAwMDANCltXZWQgSmFuIDIyIDEw
OjM5OjM5IDIwMjVdIEJVRzoga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSwgYWRkcmVz
czogMDAwMDAwMDAwMDAwMDAwMA0KW1dlZCBKYW4gMjIgMTA6Mzk6MzkgMjAyNV0gLS0tWyBlbmQg
dHJhY2UgMDAwMDAwMDAwMDAwMDAwMCBdLS0tDQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSAj
UEY6IHN1cGVydmlzb3Igd3JpdGUgYWNjZXNzIGluIGtlcm5lbCBtb2RlDQpbV2VkIEphbiAyMiAx
MDozOTozOSAyMDI1XSAjUEY6IGVycm9yX2NvZGUoMHgwMDAyKSAtIG5vdC1wcmVzZW50IHBhZ2UN
CltXZWQgSmFuIDIyIDEwOjM5OjM5IDIwMjVdIFBHRCA4MDAwMDAwMTBkZjliMDY3IFA0RCA4MDAw
MDAwMTBkZjliMDY3IFBVRCAxMDI5ZjIwNjcgUE1EIDANCltXZWQgSmFuIDIyIDEwOjM5OjM5IDIw
MjVdIE9vcHM6IE9vcHM6IDAwMDIgWyMyXSBQUkVFTVBUIFNNUCBQVEkNCltXZWQgSmFuIDIyIDEw
OjM5OjM5IDIwMjVdIENQVTogMTggVUlEOiAwIFBJRDogNDg5IENvbW06IGt3b3JrZXIvMTg6MiBU
YWludGVkOiBHICAgICAgRCBXICAgICAgICAgIDYuMTMuMC0wNjEzMDByYzEtZ2VuZXJpYyAjMjAy
NDEyMDEyMzI3DQpbV2VkIEphbiAyMiAxMDozOTozOSAyMDI1XSBUYWludGVkOiBbRF09RElFLCBb
V109V0FSTg0KW1dlZCBKYW4gMjIgMTA6Mzk6NDAgMjAyNV0gSGFyZHdhcmUgbmFtZTogTWljcm9z
b2Z0IENvcnBvcmF0aW9uIFZpcnR1YWwgTWFjaGluZS9WaXJ0dWFsIE1hY2hpbmUsIEJJT1MgSHlw
ZXItViBVRUZJIFJlbGVhc2UgdjQuMSAwOC8yMy8yMDI0DQpbV2VkIEphbiAyMiAxMDozOTo0MCAy
MDI1XSBXb3JrcXVldWU6IGNpZnNpb2Qgc21iMl9yZWFkdl93b3JrZXIgW2NpZnNdDQpbV2VkIEph
biAyMiAxMDozOTo0MCAyMDI1XSBSSVA6IDAwMTA6bmV0ZnNfdW5sb2NrX3JlYWRfZm9saW8rMHgz
NC8weDM4MCBbbmV0ZnNdDQpbV2VkIEphbiAyMiAxMDozOTo0MCAyMDI1XSBSSVA6IDAwMTA6bmV0
ZnNfdW5sb2NrX3JlYWRfZm9saW8rMHgzNC8weDM4MCBbbmV0ZnNdDQpbV2VkIEphbiAyMiAxMDoz
OTo0MCAyMDI1XSBDb2RlOiA4OSBlNSA0MSA1NyA0OSA4OSBmZiA0MSA1NiA0OSA4OSBmNiA0MSA1
NSA0MSA1NCA0ZCA4OSBjNCA1MyA0OCA4OSBkMyA0OCA4MyBlYyAxMCA0MSA4MyBmOCAxZSAwZiA4
NyAxNyAwMyAwMCAwMCA0ZSA4YiA2YyBjMyAwOCA8ZjA+IDQxIDgwIDRkIDAwIDA4IDQ5IDhiIDg2
IDU4IDAyIDAwIDAwIGE5IDAwIDAwIDAwIDgwIDBmIDg1IGQ4IDAwDQpbV2VkIEphbiAyMiAxMDoz
OTo0MCAyMDI1XSBDb2RlOiA4OSBlNSA0MSA1NyA0OSA4OSBmZiA0MSA1NiA0OSA4OSBmNiA0MSA1
NSA0MSA1NCA0ZCA4OSBjNCA1MyA0OCA4OSBkMyA0OCA4MyBlYyAxMCA0MSA4MyBmOCAxZSAwZiA4
NyAxNyAwMyAwMCAwMCA0ZSA4YiA2YyBjMyAwOCA8ZjA+IDQxIDgwIDRkIDAwIDA4IDQ5IDhiIDg2
IDU4IDAyIDAwIDAwIGE5IDAwIDAwIDAwIDgwIDBmIDg1IGQ4IDAwDQpbV2VkIEphbiAyMiAxMDoz
OTo0MCAyMDI1XSBSU1A6IDAwMTg6ZmZmZmMxNzAwMGQ5YmQ0OCBFRkxBR1M6IDAwMDEwMjk3DQpb
V2VkIEphbiAyMiAxMDozOTo0MCAyMDI1XSBSU1A6IDAwMTg6ZmZmZmMxNzAwMTBmN2Q0OCBFRkxB
R1M6IDAwMDEwMjk3DQoNCg0KW1dlZCBKYW4gMjIgMTA6Mzk6NDAgMjAyNV0gUkFYOiAwMDAwMDAw
MDAwNDAwMDAwIFJCWDogZmZmZjlkMDMwYThkZWMwMCBSQ1g6IDAwMDAwMDAwMDAwMDAwMDUNCltX
ZWQgSmFuIDIyIDEwOjM5OjQwIDIwMjVdIFJBWDogMDAwMDAwMDAwMDQwMDAwMCBSQlg6IGZmZmY5
ZDAzMGE4ZGQ0MDAgUkNYOiAwMDAwMDAwMDAwMDAwMDA1DQpbV2VkIEphbiAyMiAxMDozOTo0MCAy
MDI1XSBSRFg6IGZmZmY5ZDAzMGE4ZGVjMDAgUlNJOiBmZmZmOWQwMzY0Yzg3MzgwIFJESTogZmZm
ZjlkMDNlNjBmOWE0MA0KW1dlZCBKYW4gMjIgMTA6Mzk6NDAgMjAyNV0gUkRYOiBmZmZmOWQwMzBh
OGRkNDAwIFJTSTogZmZmZjlkMDM2NGM4NTI4MCBSREk6IGZmZmY5ZDAzZTYwZjkwNDANCltXZWQg
SmFuIDIyIDEwOjM5OjQwIDIwMjVdIFJCUDogZmZmZmMxNzAwMGQ5YmQ4MCBSMDg6IDAwMDAwMDAw
MDAwMDAwMDUgUjA5OiAwMDAwMDAwMDAwMDAwMDAwDQpbV2VkIEphbiAyMiAxMDozOTo0MCAyMDI1
XSBSQlA6IGZmZmZjMTcwMDEwZjdkODAgUjA4OiAwMDAwMDAwMDAwMDAwMDA1IFIwOTogMDAwMDAw
MDAwMDAwMDAwMA0KW1dlZCBKYW4gMjIgMTA6Mzk6NDAgMjAyNV0gUjEwOiAwMDAwMDAwMDAwMDAw
MDA1IFIxMTogMDAwMDAwMDAwMjgwMDAwMCBSMTI6IDAwMDAwMDAwMDAwMDAwMDUNCltXZWQgSmFu
IDIyIDEwOjM5OjQwIDIwMjVdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAwMDAwMDAwMDM4
MDAwMDAgUjEyOiAwMDAwMDAwMDAwMDAwMDA1DQpbV2VkIEphbiAyMiAxMDozOTo0MCAyMDI1XSBS
MTM6IDAwMDAwMDAwMDAwMDAwMDAgUjE0OiBmZmZmOWQwMzY0Yzg3MzgwIFIxNTogZmZmZjlkMDNl
NjBmOWE0MA0KW1dlZCBKYW4gMjIgMTA6Mzk6NDAgMjAyNV0gUjEzOiAwMDAwMDAwMDAwMDAwMDAw
IFIxNDogZmZmZjlkMDM2NGM4NTI4MCBSMTU6IGZmZmY5ZDAzZTYwZjkwNDANCltXZWQgSmFuIDIy
IDEwOjM5OjQwIDIwMjVdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmOWQyNTUz
NjAwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDANCltXZWQgSmFuIDIyIDEwOjM5OjQw
IDIwMjVdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmOWQyNTUzZDAwMDAwKDAw
MDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDANCltXZWQgSmFuIDIyIDEwOjM5OjQwIDIwMjVdIENT
OiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwMzMNCltXZWQgSmFu
IDIyIDEwOjM5OjQwIDIwMjVdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAw
MDAwODAwNTAwMzMNCltXZWQgSmFuIDIyIDEwOjM5OjQwIDIwMjVdIENSMjogMDAwMDAwMDAwMDAw
MDAwMCBDUjM6IDAwMDAwMDAxMDYyYzgwMDUgQ1I0OiAwMDAwMDAwMDAwMzcwNmYwDQpbV2VkIEph
biAyMiAxMDozOTo0MCAyMDI1XSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAgQ1IzOiAwMDAwMDAwMTA2
MmM4MDAzIENSNDogMDAwMDAwMDAwMDM3MDZmMA0KW1dlZCBKYW4gMjIgMTA6Mzk6NDAgMjAyNV0g
RFIwOiAwMDAwMDAwMDAwMDAwMDAwIERSMTogMDAwMDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAwMDAw
MDAwMDAwMDANCltXZWQgSmFuIDIyIDEwOjM5OjQwIDIwMjVdIERSMDogMDAwMDAwMDAwMDAwMDAw
MCBEUjE6IDAwMDAwMDAwMDAwMDAwMDAgRFIyOiAwMDAwMDAwMDAwMDAwMDAwDQpbV2VkIEphbiAy
MiAxMDozOTo0MCAyMDI1XSBEUjM6IDAwMDAwMDAwMDAwMDAwMDAgRFI2OiAwMDAwMDAwMGZmZmUw
ZmYwIERSNzogMDAwMDAwMDAwMDAwMDQwMA0KW1dlZCBKYW4gMjIgMTA6Mzk6NDAgMjAyNV0gRFIz
OiAwMDAwMDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDBmZmZlMGZmMCBEUjc6IDAwMDAwMDAwMDAw
MDA0MDANCltXZWQgSmFuIDIyIDEwOjM5OjQwIDIwMjVdIG5vdGU6IGt3b3JrZXIvNDoyWzU3MV0g
ZXhpdGVkIHdpdGggaXJxcyBkaXNhYmxlZA0KW1dlZCBKYW4gMjIgMTA6Mzk6NDAgMjAyNV0gQ2Fs
bCBUcmFjZToNCltXZWQgSmFuIDIyIDEwOjM5OjQwIDIwMjVdICA8VEFTSz4NCltXZWQgSmFuIDIy
IDEwOjM5OjQwIDIwMjVdICA/IHNob3dfdHJhY2VfbG9nX2x2bCsweDFiZS8weDMxMA0KW1dlZCBK
YW4gMjIgMTA6Mzk6NDAgMjAyNV0gID8gc2hvd190cmFjZV9sb2dfbHZsKzB4MWJlLzB4MzEwDQpb
V2VkIEphbiAyMiAxMDozOTo0MCAyMDI1XSAgPyBuZXRmc19jb25zdW1lX3JlYWRfZGF0YS5pc3Jh
LjArMHgzYWMvMHg5MDAgW25ldGZzXQ0KW1dlZCBKYW4gMjIgMTA6Mzk6NDAgMjAyNV0gID8gc2hv
d19yZWdzLnBhcnQuMCsweDIyLzB4MzANCltXZWQgSmFuIDIyIDEwOjM5OjQwIDIwMjVdICA/IF9f
ZGllX2JvZHkuY29sZCsweDgvMHgxMA0KW1dlZCBKYW4gMjIgMTA6Mzk6NDAgMjAyNV0gID8gX19k
aWUrMHgyYS8weDQwDQpbV2VkIEphbiAyMiAxMDozOTo0MCAyMDI1XSAgPyBwYWdlX2ZhdWx0X29v
cHMrMHgxNmMvMHgxODANCltXZWQgSmFuIDIyIDEwOjM5OjQwIDIwMjVdICA/IGRvX3VzZXJfYWRk
cl9mYXVsdCsweDRjOS8weDdlMA0KW1dlZCBKYW4gMjIgMTA6Mzk6NDAgMjAyNV0gID8gZXhjX3Bh
Z2VfZmF1bHQrMHg4NS8weDFjMA0KW1dlZCBKYW4gMjIgMTA6Mzk6NDAgMjAyNV0gID8gYXNtX2V4
Y19wYWdlX2ZhdWx0KzB4MjcvMHgzMA0KW1dlZCBKYW4gMjIgMTA6Mzk6NDAgMjAyNV0gID8gbmV0
ZnNfdW5sb2NrX3JlYWRfZm9saW8rMHgzNC8weDM4MCBbbmV0ZnNdDQpbV2VkIEphbiAyMiAxMDoz
OTo0MCAyMDI1XSAgbmV0ZnNfY29uc3VtZV9yZWFkX2RhdGEuaXNyYS4wKzB4M2FjLzB4OTAwIFtu
ZXRmc10NCltXZWQgSmFuIDIyIDEwOjM5OjQwIDIwMjVdICBuZXRmc19yZWFkX3N1YnJlcV90ZXJt
aW5hdGVkKzB4MmNlLzB4NDIwIFtuZXRmc10NCltXZWQgSmFuIDIyIDEwOjM5OjQwIDIwMjVdICBz
bWIyX3JlYWR2X3dvcmtlcisweDFhLzB4MzAgW2NpZnNdDQpbV2VkIEphbiAyMiAxMDozOTo0MCAy
MDI1XSAgcHJvY2Vzc19vbmVfd29yaysweDE3Ny8weDM1MA0KW1dlZCBKYW4gMjIgMTA6Mzk6NDAg
MjAyNV0gIHdvcmtlcl90aHJlYWQrMHgzM2EvMHg0NzANCltXZWQgSmFuIDIyIDEwOjM5OjQwIDIw
MjVdICA/IF9yYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSsweDExLzB4NjANCltXZWQgSmFuIDIy
IDEwOjM5OjQwIDIwMjVdICA/IF9fcGZ4X3dvcmtlcl90aHJlYWQrMHgxMC8weDEwDQpbV2VkIEph
biAyMiAxMDozOTo0MCAyMDI1XSAga3RocmVhZCsweGU0LzB4MTEwDQpbV2VkIEphbiAyMiAxMDoz
OTo0MCAyMDI1XSAgPyBfX3BmeF9rdGhyZWFkKzB4MTAvMHgxMA0KW1dlZCBKYW4gMjIgMTA6Mzk6
NDAgMjAyNV0gIHJldF9mcm9tX2ZvcmsrMHg0Ny8weDcwDQpbV2VkIEphbiAyMiAxMDozOTo0MCAy
MDI1XSAgPyBfX3BmeF9rdGhyZWFkKzB4MTAvMHgxMA0KW1dlZCBKYW4gMjIgMTA6Mzk6NDAgMjAy
NV0gIHJldF9mcm9tX2ZvcmtfYXNtKzB4MWEvMHgzMA0KW1dlZCBKYW4gMjIgMTA6Mzk6NDAgMjAy
NV0gIDwvVEFTSz4NCltXZWQgSmFuIDIyIDEwOjM5OjQwIDIwMjVdIE1vZHVsZXMgbGlua2VkIGlu
OiBjbWFjIG5sc191dGY4IGNpZnMgY2lmc19hcmM0IG5sc191Y3MyX3V0aWxzIGNpZnNfbWQ0IG5l
dGZzIHFydHIgY2ZnODAyMTEgODAyMXEgZ2FycCBtcnAgc3RwIGxsYyB4dF9jb25udHJhY2sgbmZf
Y29ubnRyYWNrIG5mX2RlZnJhZ19pcHY2IG5mX2RlZnJhZ19pcHY0IHh0X293bmVyIHh0X3RjcHVk
cCBuZnRfY29tcGF0IG5mX3RhYmxlcyBiaW5mbXRfbWlzYyBubHNfaXNvODg1OV8xIGludGVsX3Jh
cGxfbXNyIGludGVsX3JhcGxfY29tbW9uIGludGVsX3VuY29yZV9mcmVxdWVuY3lfY29tbW9uIGlz
c3RfaWZfY29tbW9uIHNreF9lZGFjX2NvbW1vbiBuZml0IHJhcGwgdm1nZW5pZCBoeXBlcnZfZHJt
IGh2X2JhbGxvb24gam95ZGV2IHNlcmlvX3JhdyBtYWNfaGlkIHNjaF9mcV9jb2RlbCBkbV9tdWx0
aXBhdGggbnZtZV9mYWJyaWNzIG52bWVfa2V5cmluZyBtc3IgbnZtZV9jb3JlIG52bWVfYXV0aCBl
ZmlfcHN0b3JlIG5mbmV0bGluayBkbWlfc3lzZnMgaXBfdGFibGVzIHhfdGFibGVzIGF1dG9mczQg
YnRyZnMgYmxha2UyYl9nZW5lcmljIHJhaWQxMCByYWlkNDU2IGFzeW5jX3JhaWQ2X3JlY292IGFz
eW5jX21lbWNweSBhc3luY19wcSBhc3luY194b3IgYXN5bmNfdHggeG9yIHJhaWQ2X3BxIGxpYmNy
YzMyYyByYWlkMSByYWlkMCBtbHg1X2liIGliX3V2ZXJicyBtYWNzZWMgaWJfY29yZSBtbHg1X2Nv
cmUgbWx4ZncgcHNhbXBsZSB0bHMgcGNpX2h5cGVydiBwY2lfaHlwZXJ2X2ludGYgaGlkX2dlbmVy
aWMgaHZfc3RvcnZzYyBoaWRfaHlwZXJ2IGhpZCBodl9uZXR2c2Mgc2NzaV90cmFuc3BvcnRfZmMg
aHlwZXJ2X2ZiIGh2X3V0aWxzIGh5cGVydl9rZXlib2FyZCBjcmN0MTBkaWZfcGNsbXVsIGNyYzMy
X3BjbG11bCBwb2x5dmFsX2NsbXVsbmkgcG9seXZhbF9nZW5lcmljIGdoYXNoX2NsbXVsbmlfaW50
ZWwgc2hhMjU2X3Nzc2UzIHNoYTFfc3NzZTMgaHZfdm1idXMgYWVzbmlfaW50ZWwgY3J5cHRvX3Np
bWQgY3J5cHRkDQpbV2VkIEphbiAyMiAxMDozOTo0MCAyMDI1XSBDUjI6IDAwMDAwMDAwMDAwMDAw
MDANCltXZWQgSmFuIDIyIDEwOjM5OjQwIDIwMjVdIC0tLVsgZW5kIHRyYWNlIDAwMDAwMDAwMDAw
MDAwMDAgXS0tLQ0KW1dlZCBKYW4gMjIgMTA6Mzk6NDAgMjAyNV0gUklQOiAwMDEwOm5ldGZzX3Vu
bG9ja19yZWFkX2ZvbGlvKzB4MzQvMHgzODAgW25ldGZzXQ0KW1dlZCBKYW4gMjIgMTA6Mzk6NDAg
MjAyNV0gQ29kZTogODkgZTUgNDEgNTcgNDkgODkgZmYgNDEgNTYgNDkgODkgZjYgNDEgNTUgNDEg
NTQgNGQgODkgYzQgNTMgNDggODkgZDMgNDggODMgZWMgMTAgNDEgODMgZjggMWUgMGYgODcgMTcg
MDMgMDAgMDAgNGUgOGIgNmMgYzMgMDggPGYwPiA0MSA4MCA0ZCAwMCAwOCA0OSA4YiA4NiA1OCAw
MiAwMCAwMCBhOSAwMCAwMCAwMCA4MCAwZiA4NSBkOCAwMA0KW1dlZCBKYW4gMjIgMTA6Mzk6NDAg
MjAyNV0gUlNQOiAwMDE4OmZmZmZjMTcwMDBkOWJkNDggRUZMQUdTOiAwMDAxMDI5Nw0KW1dlZCBK
YW4gMjIgMTA6Mzk6NDAgMjAyNV0gUkFYOiAwMDAwMDAwMDAwNDAwMDAwIFJCWDogZmZmZjlkMDMw
YThkZWMwMCBSQ1g6IDAwMDAwMDAwMDAwMDAwMDUNCltXZWQgSmFuIDIyIDEwOjM5OjQwIDIwMjVd
IFJEWDogZmZmZjlkMDMwYThkZWMwMCBSU0k6IGZmZmY5ZDAzNjRjODczODAgUkRJOiBmZmZmOWQw
M2U2MGY5YTQwDQpbV2VkIEphbiAyMiAxMDozOTo0MCAyMDI1XSBSQlA6IGZmZmZjMTcwMDBkOWJk
ODAgUjA4OiAwMDAwMDAwMDAwMDAwMDA1IFIwOTogMDAwMDAwMDAwMDAwMDAwMA0KW1dlZCBKYW4g
MjIgMTA6Mzk6NDAgMjAyNV0gUjEwOiAwMDAwMDAwMDAwMDAwMDA1IFIxMTogMDAwMDAwMDAwMjgw
MDAwMCBSMTI6IDAwMDAwMDAwMDAwMDAwMDUNCltXZWQgSmFuIDIyIDEwOjM5OjQwIDIwMjVdIFIx
MzogMDAwMDAwMDAwMDAwMDAwMCBSMTQ6IGZmZmY5ZDAzNjRjODczODAgUjE1OiBmZmZmOWQwM2U2
MGY5YTQwDQpbV2VkIEphbiAyMiAxMDozOTo0MCAyMDI1XSBGUzogIDAwMDAwMDAwMDAwMDAwMDAo
MDAwMCkgR1M6ZmZmZjlkMjU1M2QwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwDQpb
V2VkIEphbiAyMiAxMDozOTo0MCAyMDI1XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1Iw
OiAwMDAwMDAwMDgwMDUwMDMzDQpbV2VkIEphbiAyMiAxMDozOTo0MCAyMDI1XSBDUjI6IDAwMDAw
MDAwMDAwMDAwMDAgQ1IzOiAwMDAwMDAwMTA2MmM4MDAzIENSNDogMDAwMDAwMDAwMDM3MDZmMA0K
W1dlZCBKYW4gMjIgMTA6Mzk6NDAgMjAyNV0gRFIwOiAwMDAwMDAwMDAwMDAwMDAwIERSMTogMDAw
MDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwMDAwMDAwMDANCltXZWQgSmFuIDIyIDEwOjM5OjQw
IDIwMjVdIERSMzogMDAwMDAwMDAwMDAwMDAwMCBEUjY6IDAwMDAwMDAwZmZmZTBmZjAgRFI3OiAw
MDAwMDAwMDAwMDAwNDAwDQpbV2VkIEphbiAyMiAxMDozOTo0MCAyMDI1XSBub3RlOiBrd29ya2Vy
LzE4OjJbNDg5XSBleGl0ZWQgd2l0aCBpcnFzIGRpc2FibGVkDQo=
--00000000000079b0be062c618815--
