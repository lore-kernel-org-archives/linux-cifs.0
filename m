Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3231F16B
	for <linux-cifs@vger.kernel.org>; Wed,  4 Dec 2024 16:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733329854; cv=none; b=nsSir6t6LbwSck+FzPAYcE91MwQHb4xB1+Tzb/etbL2IF1DLh7x0u9pSf0Db1hnc4Y8pRzPkbBLUBMETk+Vt3bEZYLOMLgqpJ4RRBBipol2ZIE19s4kXFrjZVhiiFCKMa2xeLmrjEyFn/1gbS5pbXOMjk0meMx94iGaPnoOUWsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733329854; c=relaxed/simple;
	bh=DS6oou6GXrCiiwWzQWg3FcfNbSLaDiSZ/OkQ+DRi4NA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pOML+YEWPjFXsD/NGTjI0TKF0UaJttXVDJJR81sVe2OHqxNdPomympOIS6g2VtiXM/IRndqLRoigCxsjri17a648rykHFeTwnmPx+SicGFnH9sy1VsspEhnykwkgnv7awi7ooPY+/Jm05e9j/h6/anQKjYHDE8Sb7yasYkynpY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I+qoAJ7B; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I+qoAJ7B"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aa549d9dffdso1097215666b.2
        for <linux-cifs@vger.kernel.org>; Wed, 04 Dec 2024 08:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733329851; x=1733934651; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lsadV2Xputvi/aBNMCZX/pxIKDtBYvOMirWbN5uteDU=;
        b=I+qoAJ7BiZWy+pca+/6rWW6H4LyDthk9/J5DeBnyCbl9gPalq0rmooPWi635DtYmuC
         UjPVJidhoFUAKlhHc/zcucXmLToP2s0x7w47ApADcICmtiYjblSiMN7v3TR5ZPys+ADH
         Is/JsnJi2k51ItXLd5Ra2vVLeGi6SnZKt1hjSkN4ro8uKdu1is3noXWv94+zRqbrv3EK
         qRgJ9XYTyIqhBHNx1k+82NF+LLAyYMesytt3GeQK6vwL1Aq+oAiaokloyXoBCy7T6kOR
         KIprkhuatXQQyNkGSk48qFN9QAql9e3cWSVCaLntBAGbho60mutWc+JW04xhAWuThQHT
         Sr6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733329851; x=1733934651;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lsadV2Xputvi/aBNMCZX/pxIKDtBYvOMirWbN5uteDU=;
        b=jhzjSUDf1RgoWAzw4ktSa+TvYpIfxsatR+7Zei/AlCpoYs2xG1f7CJ1peh11M7oUie
         KppJJQ9cyhDnZVK1ZyNCJsKYPJVXA6jZ9YF1YdxZWDz7+6oA8fDLdHAWGX/tHjlbDQuB
         RcMzxN5FgAK2w6+PMzhPnVr+o9xs59Ypdgx0GJmspX44Qa6g+CfkTbSw5QvN/toy8dC2
         AgjUFvCQDvBNSQ3o35ShXxmvlbt8o/q51GotJaB1d/CJrD6uHewUXDAa99PYVmjhbCdm
         FxA4HPZ9XtZJtTVMhKKY/1qCmiy0b27Zerhy6L6yWJQndMDvOuaflxgDbA30QHIGC1PN
         s8Lw==
X-Forwarded-Encrypted: i=1; AJvYcCWpNj3ICWFWKJiE68EhOZqxdtB1bw9a/2kELKgv4vbYOuQAN1V4pb81ba26Hv7ikmEA4vcb/fTqB60O@vger.kernel.org
X-Gm-Message-State: AOJu0YyEg+w5knKogHTBm1y5aW1JVk44MtXwD5dr6sMUhIW/DOtXVBcN
	Fav8d7jjCcBNmJ8IBLXOQrwnei0T2Jd1XVICqL58Ib1AqVgIWovCPPoq4XOWajAH4Oyj83CO8u/
	grLL+gmVmss9W4IaesP0xA4QdkBw=
X-Gm-Gg: ASbGncsjbYnhGdTWNKl2qwiWGpCyyAXCOe144V5avny9MCYu/us6rxktsVPPzkrnmIb
	sLeYzDBfWF47gsztIWxzUmWoQyr8tOa/mltyy5ZpYyDhSS/ebQy00f1qc0L3zgg==
X-Google-Smtp-Source: AGHT+IE4XC3vcR5fok9yYKBttBI+bkGcPyDovSidq4YXZyzIRwxzmSp1z+Du+ywpNOpt/8vbNTa/oqba6GstqJ7xioo=
X-Received: by 2002:a17:906:3097:b0:aa6:1c4b:9c5b with SMTP id
 a640c23a62f3a-aa61c4ba102mr34523966b.7.1733329848733; Wed, 04 Dec 2024
 08:30:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANT5p=pUGYwswgXM-pniMjEWwbLK0cKXPBOJB9cG_cOrkBwQhg@mail.gmail.com>
 <CANT5p=qBwjBm-D8soFVVtswGEfmMtQXVW83=TNfUtvyHeFQZBA@mail.gmail.com>
 <505338.1733181074@warthog.procyon.org.uk> <526707.1733224486@warthog.procyon.org.uk>
In-Reply-To: <526707.1733224486@warthog.procyon.org.uk>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Wed, 4 Dec 2024 22:00:36 +0530
Message-ID: <CANT5p=pO28C+XEC44taAT-Z6W_spB-QzJb+MOXv68bDRGqJn=w@mail.gmail.com>
Subject: Re: null-ptr deref found in netfs code
To: David Howells <dhowells@redhat.com>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 3, 2024 at 4:44=E2=80=AFPM David Howells <dhowells@redhat.com> =
wrote:
>
> Okay, I think I see the problem.
>
> Looking at the following extraction from the trace:
>
> > netfs_rreq_ref: R=3D0000290e NEW         r=3D1
> > netfs_read: R=3D0000290e READAHEAD c=3D00000000 ni=3D0 s=3D85e00000 l=
=3D800000 sz=3D280000000
> > netfs_folio: i=3Df1c2900000000000 ix=3D85e00-85fff read
> > netfs_folio: i=3Df1c2900000000000 ix=3D86000-861ff read
> > netfs_folio: i=3Df1c2900000000000 ix=3D86200-863ff read
> > netfs_folio: i=3Df1c2900000000000 ix=3D86400-865ff read
>
> We're requesting reads of four folios, each consisting of 512 pages for a
> total of 8MiB.
>
> > netfs_sreq: R=3D0000290e[1] DOWN SUBMT f=3D02 s=3D85e00000 0/100000 e=
=3D0
> > netfs_sreq: R=3D0000290e[2] DOWN SUBMT f=3D02 s=3D85f00000 0/100000 e=
=3D0
> > netfs_sreq: R=3D0000290e[3] DOWN SUBMT f=3D02 s=3D86000000 0/100000 e=
=3D0
> > netfs_sreq: R=3D0000290e[4] DOWN SUBMT f=3D02 s=3D86100000 0/100000 e=
=3D0
> > netfs_sreq: R=3D0000290e[5] DOWN SUBMT f=3D02 s=3D86200000 0/100000 e=
=3D0
> > netfs_sreq: R=3D0000290e[6] DOWN SUBMT f=3D02 s=3D86300000 0/100000 e=
=3D0
> > netfs_sreq: R=3D0000290e[7] DOWN SUBMT f=3D02 s=3D86400000 0/100000 e=
=3D0
> > netfs_sreq: R=3D0000290e[8] DOWN SUBMT f=3D02 s=3D86500000 0/100000 e=
=3D0
>
> That got broken down into 8 submissions, each for a 1MiB slice.
>
> > netfs_sreq: R=3D0000290e[1] DOWN IO    f=3D02 s=3D85e00000 100000/10000=
0 e=3D0
> > netfs_progress: R=3D0000290e[01] s=3D85e00000 ct=3D0/100000 pa=3D100000=
/100000 sl=3D0
> > netfs_donate: R=3D0000290e[01] -> [02] to-next am=3D100000
>
> Subrequest 1 completed, but wasn't large enough to cover a whole folio, s=
o it
> donated its coverage forwards to subreq 2.
>
> > netfs_sreq: R=3D0000290e[6] DOWN IO    f=3D02 s=3D86300000 100000/10000=
0 e=3D0
> > netfs_progress: R=3D0000290e[06] s=3D86300000 ct=3D0/100000 pa=3D100000=
/100000 sl=3D2
> > netfs_donate: R=3D0000290e[06] -> [05] tail-to-prev am=3D100000
>
> Subrequest 6 completed, but wasn't large enough to cover a whole folio, s=
o it
> donated its coverage backwards to subreq 5.
>
> > netfs_sreq: R=3D0000290e[2] DOWN IO    f=3D02 s=3D85f00000 100000/10000=
0 e=3D0
> > netfs_progress: R=3D0000290e[02] s=3D85e00000 ct=3D0/200000 pa=3D200000=
/200000 sl=3D0
> > netfs_folio: i=3Df1c2900000000000 ix=3D85e00-85fff read-done
> > netfs_folio: i=3Df1c2900000000000 ix=3D85e00-85fff read-unlock
>
> Subreq 2 completed, and with the donation from subreq 1, had sufficient t=
o
> unlock the first folio.
>
> > netfs_sreq: R=3D0000290e[5] DOWN IO    f=3D02 s=3D86200000 100000/10000=
0 e=3D0
> > netfs_progress: R=3D0000290e[05] s=3D86200000 ct=3D0/200000 pa=3D200000=
/200000 sl=3D2
> > netfs_folio: i=3Df1c2900000000000 ix=3D86200-863ff read-done
> > netfs_folio: i=3Df1c2900000000000 ix=3D86200-863ff read-unlock
>
> Subreq 5 completed, and with the donation from subreq 6, had sufficient t=
o
> unlock the third folio.
>
> > netfs_sreq: R=3D0000290e[3] DOWN IO    f=3D02 s=3D86000000 100000/10000=
0 e=3D0
> > netfs_progress: R=3D0000290e[03] s=3D86000000 ct=3D0/100000 pa=3D100000=
/100000 sl=3D1
> > netfs_donate: R=3D0000290e[03] -> [04] to-next am=3D100000
>
> Subrequest 3 completed, but wasn't large enough to cover a whole folio, s=
o it
> donated its coverage forwards to subreq 4.  So far, so good.
>
> > netfs_sreq: R=3D0000290e[7] DOWN IO    f=3D02 s=3D86400000 100000/10000=
0 e=3D0
> > netfs_progress: R=3D0000290e[07] s=3D86400000 ct=3D0/100000 pa=3D100000=
/100000 sl=3D3
> > netfs_donate: R=3D0000290e[07] -> [04] to-prev am=3D0
>
> Subreq 7 completed, but wasn't large enough to cover a whole folio, so it
> donated its coverage backwards to subreq 4.  This is a bug as subreq 7 is=
 not
> contiguous with subreq 4.  It should instead have donated forwards to sub=
req
> 8.
>
> > netfs_sreq: R=3D0000290e[4] DOWN IO    f=3D02 s=3D86100000 100000/10000=
0 e=3D0
> > netfs_sreq: R=3D0000290e[4] DOWN +DON  f=3D02 s=3D86000000 300000/30000=
0 e=3D0
> > netfs_progress: R=3D0000290e[04] s=3D86000000 ct=3D0/300000 pa=3D200000=
/300000 sl=3D1
> > netfs_folio: i=3Df1c2900000000000 ix=3D86000-861ff read-done
> > netfs_folio: i=3Df1c2900000000000 ix=3D86000-861ff read-unlock
>
> Subreq 4 completed, and with the donation from subreq 2, had sufficient t=
o
> unlock the second folio.  However, it also has some excess from subreq 7 =
that
> it can't do anything with - and this gets lost.
>
> > netfs_sreq: R=3D0000290e[8] DOWN IO    f=3D02 s=3D86500000 100000/10000=
0 e=3D0
> > netfs_progress: R=3D0000290e[08] s=3D86500000 ct=3D0/100000 pa=3D100000=
/100000 sl=3D3
> > netfs_donate: R=3D0000290e[08] -> [04] tail-to-prev am=3D100000
>
> Here's a repeat of the bug: subreq 8 donates to subreq 4, but, again, is =
not
> contiguous.  As these are happening concurrently, the other thread hasn't
> delisted subreq 4 yet.
>
> > netfs_sreq: R=3D0000290e[4] DOWN +DON  f=3D02 s=3D86000000 400000/40000=
0 e=3D0
> > netfs_progress: R=3D0000290e[04] s=3D86200000 ct=3D200000/400000 pa=3D2=
00000/200000 sl=3D2
>
> The request screwed at this point: subreq 4 shows the extra stuff it has =
been
> donated, but it is unable to do anything with it.  There is no folio to
> wrangle as the third slot (sl=3D2) in the queue has already been cleared.
>
> (Note that this bug shouldn't happen with the patches currently on my
> netfs-writeback branch as I got rid of the donation mechanism in preferen=
ce
> for something simpler with single-threaded collection.)
>
> David
>

Hi David,

Tried your submitted patch "netfs: Fix non-contiguous donation between
completed reads" with the same workload.
It seems to be crashing elsewhere. I'm trying to get the OOPS message
and ftrace, but it seems to be crashing the kernel.

--=20
Regards,
Shyam
