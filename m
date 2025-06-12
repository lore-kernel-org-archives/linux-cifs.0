Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EE02F4334
	for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 17:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749748682; cv=none; b=YB+bp07PpqNykhzqqW2qWVz4u88lY/e+JKqZiaLGgjq1KK+Eqm/C7u9v7WSX+Ka63ZfzcWBdbN9RZ7uTEbwwFmZplzthqrfASE0gsmcyYrtvorSARTP2qTERzvIo2D4cLJDPd8BDHkwcBT777M311p/YyqOV+FtKNhYIx8LJeGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749748682; c=relaxed/simple;
	bh=bw03RNOnKa4cvZDy49m2knX/CzqcmfgAEtkur2taWiY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FvqfIWG29HPnkWcWW4gKRMOCWxumSuvZ7DSEWA56ci8CU0gh743ww8SPIhYhmmBMTsqLmEV0s4WQT+gyJG0KSvxtan8Dlg/OsBO6e5vb3fOHFQ0MliCxab1pIoYIISqK/zpd8He0R523MbSnqycxiCVT2jxN62fLw3GYOTr/ASM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LKx584Cj; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LKx584Cj"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-32a658c4cc4so10363331fa.2
        for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 10:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749748678; x=1750353478; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E5nTnU9/LbbSFYeSSw5vx6TfddosqJk4Bo5Q4HhlLCk=;
        b=LKx584CjQKtHAAl6w5wV4YiFIqHKZV2B+/2ZXcFcWVXMr7eDhCDymHzrxlLboBCbR6
         Xpy4iQufyirD9LGt8fs18aRFXa55uLHLWVV/NAkvZZfmTLok4I8b1QqvNY99r9r0Cmy/
         VCtzpD2LQkvazn2XxkbNHCh88Y1fxkFhSk3jVyxUfjC9vLlo2/iXM6PaceYz/e15/uHr
         aBSIaG0x1x19PdLkSnmCWaXaBBC5dSylnpy56ABy2DzWrkWozxf1RZ8as1+6ydLujQw1
         TpzHcsFnVPBNAxbAlFFMsllCJWyv+CeMsDwLk8LXy6rCIxK4Lj+IgMkLNyUc0JEgTRf3
         lw3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749748678; x=1750353478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E5nTnU9/LbbSFYeSSw5vx6TfddosqJk4Bo5Q4HhlLCk=;
        b=LU8dKIqTssQl9nA9iT2yPBm5hQZWr1PpQViVVMN0RKKjtiTKVLuy/Do/gPjobyG6cI
         tKdXJ0ASoJiK/BD+RoAsHsFHViFEy1JJjaDd78akrVRvCIaaiPLo13mio/XlAhFioPXo
         O/yOBJ7gLttGzghH9CDQO5CRBl3/N3lgh+Qa/nP+VZjywcgPjDhNWH/IJmTD0koXJt1h
         E2KH1dkZn/Xdv5RFPWUfTgF4xSmXpaajb6vXpaiP381cpqDWiIXSarddAq43K+RCVBG8
         axN6ILMvzmM+X7wsGTepwRL9tRcpd/8mErbkPG3QcHejullMvaV5fOExhFLNfuehySs4
         RGOw==
X-Forwarded-Encrypted: i=1; AJvYcCWgBNktctXs+YpmnxSv/mQWIJYxbmpDGbiBKJUuEatm+DuXiuF3tdK5Zyp24jv5fZz+zO1Pr2TJDPLO@vger.kernel.org
X-Gm-Message-State: AOJu0Yyiy/2v2/hExX5waubu5J7faK5R5Rjc+vLD+0WAap533aVIhmiQ
	KWUl1XPZS+17VlyXmiRuXGTQI/BgPm27ZSskOjbtlc5ZjaUDCLQDUIofRoj2eX/D4kW94dzjk2g
	nGY0+qvTuGeiw7+kyye69sN/Rb83z0Vk+yW5A
X-Gm-Gg: ASbGnctf1U4+CTdIrWXJLms1SJ3wY+xuzqd5ey5Kc3f3HeM4cg0741hMgCINsopIig5
	9VXkW6/NGXog4q501/h5b/UCCbRDTXUy42ehqrwAgzNN5YWUdmUjhaNh6zKXHITl6g+OJm1CbHE
	+VPzVNZ3qAUHO+vjg055zgDyS+lg3PAFl0ZFKnMJevcQ==
X-Google-Smtp-Source: AGHT+IGU2xRs2qOEkzNkpcTHNRuhkzFtHt7KwAyCt8waktUwNPrUS/AxK4WX7aIPx8CPd6iF95OgD/AF2xPAdfvypNU=
X-Received: by 2002:a2e:b88e:0:b0:32a:61cd:81f6 with SMTP id
 38308e7fff4ca-32b3cc3c6demr2656481fa.19.1749748678203; Thu, 12 Jun 2025
 10:17:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muQB8CgN7r8SE8okujV2rpvQoKYAP=yD95a_R1hLjKWqA@mail.gmail.com>
 <466171.1749738030@warthog.procyon.org.uk> <ecuf27sge23drhun5h3gckvzibwuienqwnyvvzxn4aong5ovd5@rlsymwdyrxk4>
In-Reply-To: <ecuf27sge23drhun5h3gckvzibwuienqwnyvvzxn4aong5ovd5@rlsymwdyrxk4>
From: Steve French <smfrench@gmail.com>
Date: Thu, 12 Jun 2025 12:17:45 -0500
X-Gm-Features: AX0GCFsENBSXBgTdCe2P5hhYSWTfYSxPbmKoh2GOSM_5YiAcfBBSbhIUdLCpCx0
Message-ID: <CAH2r5mtp7brd5pzBd7Dxy8pK3Kp5Eg1wuoveC2S1JgEEkFoPLA@mail.gmail.com>
Subject: Re: netfs hang in xfstest generic/013
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

My best theory so far is that it is related to recent netfs changes
(and oddly doesn't affect non-multichannel, at least I can't repro it
to that) e.g.

commit 2b1424cd131cfaba4cf7040473133d26cddac088
Author: David Howells <dhowells@redhat.com>
Date:   Mon May 19 10:07:04 2025 +0100

    netfs: Fix wait/wake to be consistent about the waitqueue used

    Fix further inconsistencies in the use of waitqueues
    (clear_and_wake_up_bit() vs private waitqueue).

    Move some of this stuff from the read and write sides into common code =
so
    that it can be done in fewer places.

    To make this work, async I/O needs to set NETFS_RREQ_OFFLOAD_COLLECTION=
 to
    indicate that a workqueue will do the collecting and places that call t=
he
    wait function need to deal with it returning the amount transferred.

    Fixes: e2d46f2ec332 ("netfs: Change the read result collector to
only use one work item")

On Thu, Jun 12, 2025 at 9:48=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> I'm not sure this is the same issue I saw a while ago...
>
> generic/013 sends a lot of ioctls (copychunk writes and set zero data)
> which can take a good amount of time to process (~10s each on my test
> machine, for example).
>
> When/if the server gets too busy processing them, it starts responding
> with STATUS_PENDING (mostly for reads and writes, AFAICS).
>
> Currently we just release the mid for such responses, this means:
> - write callbacks are not reached:
>    mostly dangling/wrong metadata left on cifs side, but netfs
>    reqs/subreqs are not terminated (probably leaking)
> - for reads, similarly, mid ("metadata") is gone now, but netfs keeps
>    waiting for the data (because of unterminated reqs/subreqs too)
>
> I have a WIP patch for that, I'll test and send to the list later.
>
>
> Cheers,
>
> enzo
>
> On 06/12, David Howells wrote:
> >Steve French <smfrench@gmail.com> wrote:
> >
> >> I saw a hang in xfstest generic/013 once today (with 6.16-rc1 and a
> >> directory lease patch from Bharath and the fix for the readdir
> >> regression from Neil which look unrelated to the hang).
> >>
> >> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builde=
rs/5/builds/487/steps/29/logs/stdio
> >>
> >> There were no requests in flight, and the share worked fine (could
> >> e.g. ls /mnt/test) but fsstress was hung so looks like a locking leak,
> >> or lock ordering issue with netfs. Any thoughts?
> >>
> >> root@fedora29:~# cat /proc/fs/cifs/open_files
> >> # Version:1
> >> # Format:
> >> # <tree id> <ses id> <persistent fid> <flags> <count> <pid> <uid>
> >> <filename> <mid>
> >> 0x5 0x234211540000091 0x5c5698c8 0xc000 2 32005 0
> >> f24XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 6928
> >
> >Can you grab the contents of /proc/fs/netfs/{stats,requests} ?
> >
> >I presume you're running without a cache?
> >
> >Would you be able to try reproducing it with some netfs tracing on?
> >
> >David
> >
> >



--
Thanks,

Steve
