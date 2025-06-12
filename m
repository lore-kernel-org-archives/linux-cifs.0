Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D0628A1C3
	for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 15:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749740633; cv=none; b=T58+rfF+P/XUtnb8ZxRQsuCh7Em8VV5/2cmYt8RQFTVPl6TKEhLdbUT6EMEi0zAMQmBTw3Mk8v3K540p0LnYm5Y/I/yWaPcJ8iaDF/Z8uCKyC6Bq763JqEII1z8PKfdSqETef7nEpTz3VsxBq5lKo5KKBduFxe2WnInJQ9jmYcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749740633; c=relaxed/simple;
	bh=wfXGyvEivw/LJ2WvxD4q9sH0fhjrr7+0o/s0Lu4fVHY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jRK/eliLQX4UoT/r8j8pvNqiPRbvBWy0KhdzXCswvPLoNzaukc3m6iS3+FHNf1Wcew9rrxlmWAO1RhyoRRdvzXuv1JjwVIY18Q5IPvxDzx5/ZeCzb/7mNmeIKmcf6LUMw8OSgnKUBoARBqsSAIU8Z6JhRI87vz3bcBXMriic+f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MbK3D2Dx; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MbK3D2Dx"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-32a7a5ab797so9228111fa.1
        for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 08:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749740630; x=1750345430; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U39b6bDeLkE8Dq78F5pnUfPQcgThcuGrtN9x0/dwLU8=;
        b=MbK3D2Dxkmmj3PHy7S0SLr8lOBCpsTHia5cC7uHSgxgAE5akxNxu84wDDn5TJORaW7
         YL7WoCVCuIRe/gkubb4kdAdeZYr8zF9PxhyMiJELu2wgFPz3bkX0ByJyWrBvTDHeq1st
         9breWZ60vKD0ugAmyOk+3UZDHdjHAhe5wLHIKwfTkGYo58gZI2RgKuQzFW/3GPk7J/ad
         JZl/wYEcQ5GZCv/II3KIODKuu/12XkCYCL/ZyBNujtgyqpe7YLypdM3UOeh/6rYlGJGj
         rEp7ljEYyI/RKpU3TiC5r+vTr0WCKXgOLDg6RN5PSez5JYgFt3WatVsnhYMR7Ar8paN3
         hShw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749740630; x=1750345430;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U39b6bDeLkE8Dq78F5pnUfPQcgThcuGrtN9x0/dwLU8=;
        b=HCCPlekdUHwYTzX27i4pMs6gLNdzuZKtXHdrzrzkx7YCK/CuCPXJ0s1t/qfOQduS3D
         NSjLLk4pYJZovDdB6aXub3ijL9GXlgEgti7LZhkAr+V+8BVsBqRcRWhCb1mqkOfq1tlC
         BhBLPTU8r3RiDlx4YZKUOoWBUhRGnGDU0NeruPrKFsAhlcbl4hMOgtAPDvDF/znPehaK
         lOkQCurwAN/7q+csyA77dJidPhK6bdDc1b2WsSeBQr8E20iWRwZ4B7slCdhtCNWU/C2/
         OOn0I/iW+A5PA7SuH17EBCdWWXZl09MWi1KcmAq6I3h8wAunbBKXoQIiQNUGRNHQE9yl
         +a+Q==
X-Gm-Message-State: AOJu0YyOhoBSjnVwEe8vtAQixP2fuZnbTsoF6xyhfD0MH+q8ZFkgpO7t
	UFtShqn//xGlIvsKmRNVYB4aOXVAlIlxAX+hJKI5nJQQvALCaCQaJIlcntjcmF41LvxQrHUoazk
	TXxY8yJ1zbQr41FimoQNweEQXHdQxTDYdWvOt
X-Gm-Gg: ASbGncv30KUojAXVuUPqaS9/Dr9OYgEofDR73BEuNHQJy4uLlq/rBD2YLEQjCfTk+01
	Asy3HhjMU6APMk3Pd4pyohU0fdIcFXNsvbUNqGWElNImLLe8tuhQz8r1WT1u973Qfq573kUnOq1
	Hy3RSNpxzF8dQEl73g47c7tClUBotrlx5VtHEYwuvR3Q==
X-Google-Smtp-Source: AGHT+IFOFhadU+ucy9u2ISsgO9ceez78ZVks1IzqYPTjjIasVADYo6aVHGhK+KZJLjxUNKJdLnioo/RkR3i+kc+JK6g=
X-Received: by 2002:a2e:a583:0:b0:32b:33c7:e0c9 with SMTP id
 38308e7fff4ca-32b33c7e280mr9385411fa.16.1749740627725; Thu, 12 Jun 2025
 08:03:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muQB8CgN7r8SE8okujV2rpvQoKYAP=yD95a_R1hLjKWqA@mail.gmail.com>
 <466171.1749738030@warthog.procyon.org.uk>
In-Reply-To: <466171.1749738030@warthog.procyon.org.uk>
From: Steve French <smfrench@gmail.com>
Date: Thu, 12 Jun 2025 10:03:36 -0500
X-Gm-Features: AX0GCFtA_ybV7KF82CdhgQ8_ELDFDWwVxZTIflltC0Uo0VWuKkMGdnFASGtvmp4
Message-ID: <CAH2r5msdNx3ADkr2+AGqtWWW1x2v9p7x0JdDbh8NrA1qAs5gqw@mail.gmail.com>
Subject: Re: netfs hang in xfstest generic/013
To: David Howells <dhowells@redhat.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@manguebit.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reads  : DR=3D948 RA=3D6257 RF=3D1303 RS=3D0 WB=3D0 WBZ=3D0
Writes : BW=3D14322 WT=3D0 DW=3D2111 WP=3D7265 2C=3D0
ZeroOps: ZR=3D4241 sh=3D0 sk=3D0
DownOps: DL=3D8492 ds=3D8492 df=3D6 di=3D0
CaRdOps: RD=3D0 rs=3D0 rf=3D0
UpldOps: UL=3D9387 us=3D9394 uf=3D73
CaWrOps: WR=3D0 ws=3D0 wf=3D0
Retries: rq=3D0 rs=3D0 wq=3D7 ws=3D7
Objs   : rr=3D1 sr=3D0 foq=3D1 wsc=3D0
WbLock : skip=3D25 wait=3D20
-- FS-Cache statistics --
Cookies: n=3D0 v=3D0 vcol=3D0 voom=3D0
Acquire: n=3D0 ok=3D0 oom=3D0
LRU    : n=3D0 exp=3D0 rmv=3D0 drp=3D0 at=3D0
Invals : n=3D0
Updates: n=3D0 rsz=3D0 rsn=3D0
Relinqs: n=3D0 rtr=3D0 drop=3D0
NoSpace: nwr=3D0 ncr=3D0 cull=3D0
IO     : rd=3D0 wr=3D0 mis=3D0

root@fedora29:~# cat /proc/fs/netfs/requests
REQUEST  OR REF FL ERR  OPS COVERAGE
=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D =3D=3D=3D =3D=3D =3D=3D=3D=3D =3D=3D=3D =3D=
=3D=3D=3D=3D=3D=3D=3D=3D
00003699 DW   2 3120    0   0 @16200000 0/100000

On Thu, Jun 12, 2025 at 9:20=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
> Steve French <smfrench@gmail.com> wrote:
>
> > I saw a hang in xfstest generic/013 once today (with 6.16-rc1 and a
> > directory lease patch from Bharath and the fix for the readdir
> > regression from Neil which look unrelated to the hang).
> >
> > http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builder=
s/5/builds/487/steps/29/logs/stdio
> >
> > There were no requests in flight, and the share worked fine (could
> > e.g. ls /mnt/test) but fsstress was hung so looks like a locking leak,
> > or lock ordering issue with netfs. Any thoughts?
> >
> > root@fedora29:~# cat /proc/fs/cifs/open_files
> > # Version:1
> > # Format:
> > # <tree id> <ses id> <persistent fid> <flags> <count> <pid> <uid>
> > <filename> <mid>
> > 0x5 0x234211540000091 0x5c5698c8 0xc000 2 32005 0
> > f24XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 6928
>
> Can you grab the contents of /proc/fs/netfs/{stats,requests} ?
>
> I presume you're running without a cache?
>
> Would you be able to try reproducing it with some netfs tracing on?
>
> David
>


--=20
Thanks,

Steve
