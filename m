Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5888332EA7
	for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 14:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764253153; cv=none; b=dIando5Bb3lWUHBeKnlKjGgaX823cKAXo3H6moiBfLChouhyRC9/jL+6IF4dICq5/p9idtARi5xpJ0jCdHIQHIdZYbZboaMU0jsiD5jf40+YXoPO+EPLoXgYUuK+kAL8F7Y13mThk3XD2PyMU2cn9U5aMhCIqiIjzJqT7TpfuxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764253153; c=relaxed/simple;
	bh=+rK0NdDFqbxjsxwEGy5d1mdUZ/tS/dpwvMX+IXOJ0vg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=twDVhmF3M1jlaEiYEg2OAP6aRwJP59CD9eHiXK1MSWxhwSo8LHMVuiSw0Fq/8pkB5VLkD9g983awQ8hQER8kGi/y6hLqxZtNlDSEOQSZrBOwX/tsLiT+HgUNmBVVJZzNQQl2oGtgItfSCeYPLfY2K8rCeUuK3eNX9yejrwl0b8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HkR2ObvF; arc=none smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HkR2ObvF"
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-640d8b78608so698607d50.1
        for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 06:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764253149; x=1764857949; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SiuHFLg406W9DhQLXabUumf69AD24Rb67vEaZ3vvDD0=;
        b=HkR2ObvFvjWpKTiF9mnknd9EVrWxDh3UaZqr9H1TFSrb/Xmbe/0nozzY8M94BkzBpi
         AiISjUkchR6K/YLVW3Q5uqjx9vyrL/fLc23PnmxIgEx7Y67lrotjj5vZkabIWD2tEgwH
         EV+pgXon7HloIzseVuMMcXQ+NFkRQVwYKdKc6CsETUXKAzhEjMGEAuOnoeEMB0m6zPof
         psu7C48hrI4lVJkybqFdhJcqgs11fVsreG3JNr2sItpRYgqCzsMJtdL4ev1ERITDAIcI
         KnLDChEW8eb4yq3cwaQYoEbBq4mg9CZRkLzGDx6nze4AxSEvI48Yvu6wCm31BPvVrdnB
         /lsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764253149; x=1764857949;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SiuHFLg406W9DhQLXabUumf69AD24Rb67vEaZ3vvDD0=;
        b=Mtuqi+AXO1qe8uLz4M97W3JZin3Nfponav2CQN77XhqyqObZ9sI77VXaB5CvlUzYJH
         g9rnN3KEJDDM1YS1ZumGU6is03qDUGd4bdAcN3YqqX822O92tCOPbegK7nriqAaeqJ9S
         os1Tc88Ehrt1VfRlEiUICcDHwachMytU2vLSx9W+fehnDaaHq14PxLEcciHB0/abyVVj
         f5ZNZKfEhPaFuvn1yAZBBWZQDPNULJ4LyNwJNJ7iirtzfC0/7Sd4bLGUsFSWJAZS0ZZT
         6n0cNlNwsMVvVCfISKDYHDRr+fg2Y6/kCZlKv5Pzwp5yitQOyawwFIx3Edn5eemes9HT
         1uOw==
X-Forwarded-Encrypted: i=1; AJvYcCVnowp09Kz6UKcwrIFEU3MZHBC0MPuzH0JZePDUhpur+G4cwH7A/4OK7NCgC+uiLCAnP0RV6RZt8eW4@vger.kernel.org
X-Gm-Message-State: AOJu0YydiamvJdMvHH8qsdVXod2EmQj2wB+E/z9v4FDfgjjbKPzksvWT
	FnWOVKO53AZJ3OvUc2+1OHqpByx9NpMKCNT5XXmsWBGdEspGnaJP1GDKW+4qpyy1QNDij5mZ4tF
	MmF2CYW7UlFVpuLt8vduUbHgYRyP4/WU=
X-Gm-Gg: ASbGncu/UACCB54sFL/U3Hnh6SwkaDVm0Ri8yfn38YLSFgBWNJ1heowPy+B9sO9sg14
	U1+IoHu7w4xjQd/tk54cCCqFpUXgdeWtCebc8DofRoz+D/iaO8GdBeCgfrzY2GoIwmawTBo95lk
	D/qKiBs5RzDa06e9cA7z0U/SogYXa6OslJ3TbApEmwS4fM255lqXG/X1jPvV/W4NkFYNp2wKXUV
	8qLQjWsuXJoVFXYU1dLpmTifv51EeaCgW1uSVtiHeDbube+hhfYs63GW5RoxikFkq+FcA==
X-Google-Smtp-Source: AGHT+IH9PoAq9XPvTiPzII5EfnthmkcpC3LouL1/7BuNls425a7Mp4OkuOlhOHCMfx8jqaUvqg0nrmdyPfdfvCBZVjI=
X-Received: by 2002:a05:690e:787:b0:63f:b5a5:373 with SMTP id
 956f58d0204a3-64302a2aab4mr13618764d50.10.1764253148641; Thu, 27 Nov 2025
 06:19:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250710165040.3525304-1-henrique.carvalho@suse.com>
 <2944136.1752224518@warthog.procyon.org.uk> <aHE0--yUyFJqK6lb@precision>
 <CAGypqWyyA6nUfH-bGhQxLYD74O7EcE_6_W15=AB8jvi6yZiV_Q@mail.gmail.com>
 <2025112112-icon-bunkmate-bfad@gregkh> <CAGypqWy8=Oq6CC0YGFSr72L7kqrEDOytboSqJFJBxxV5tGQgFA@mail.gmail.com>
 <2025112707-pummel-film-6bd6@gregkh>
In-Reply-To: <2025112707-pummel-film-6bd6@gregkh>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Thu, 27 Nov 2025 06:18:57 -0800
X-Gm-Features: AWmQ_bkZnXYHxZVlrw2maEPUy5EOPfRwX8Q8KPo1yxUBs5GKouSjvLobSq3_es0
Message-ID: <CAGypqWyRS0YJ_pgRw4Lx_JkhYYQhXy3DBAW4D+U5sC_HSmZvBQ@mail.gmail.com>
Subject: Re: [PATCH 6.6.y] smb: client: support kvec iterators in async read path
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>, stable@vger.kernel.org, 
	Shyam Prasad N <sprasad@microsoft.com>, apais@microsoft.com, 
	Bharath S M <bharathsm@microsoft.com>, David Howells <dhowells@redhat.com>, smfrench@gmail.com, 
	linux-cifs@vger.kernel.org, Laura Kerner <laura.kerner@ichaus.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 27, 2025 at 5:30=E2=80=AFAM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Fri, Nov 21, 2025 at 02:31:20AM -0800, Bharath SM wrote:
> > On Fri, Nov 21, 2025 at 2:02=E2=80=AFAM Greg KH <gregkh@linuxfoundation=
.org> wrote:
> > >
> > > On Thu, Nov 06, 2025 at 06:02:39AM -0800, Bharath SM wrote:
> > > > On Fri, Jul 11, 2025 at 9:01=E2=80=AFAM Henrique Carvalho
> > > > <henrique.carvalho@suse.com> wrote:
> > > > >
> > > > > On Fri, Jul 11, 2025 at 10:01:58AM +0100, David Howells wrote:
> > > > > > Henrique Carvalho <henrique.carvalho@suse.com> wrote:
> > > > > >
> > > > > > > Add cifs_limit_kvec_subset() and select the appropriate limit=
er in
> > > > > > > cifs_send_async_read() to handle kvec iterators in async read=
 path,
> > > > > > > fixing the EIO bug when running executables in cifs shares mo=
unted
> > > > > > > with nolease.
> > > > > > >
> > > > > > > This patch -- or equivalent patch, does not exist upstream, a=
s the
> > > > > > > upstream code has suffered considerable API changes. The affe=
cted path
> > > > > > > is currently handled by netfs lib and located under netfs/dir=
ect_read.c.
> > > > > >
> > > > > > Are you saying that you do see this upstream too?
> > > > > >
> > > > >
> > > > > No, the patch only targets the 6.6.y stable tree. Since version 6=
.8,
> > > > > this path has moved into the netfs layer, so the original bug no =
longer
> > > > > exists.
> > > > >
> > > > > The bug was fixed at least since the commit referred in the commi=
t
> > > > > message -- 3ee1a1fc3981. In this commit, the call to cifs_user_re=
adv()
> > > > > is replaced by a call to netfs_unbuffered_read_iter(), inside the
> > > > > function cifs_strict_readv().
> > > > >
> > > > > netfs_unbuffered_read_iter() itself was introduced in commit
> > > > > 016dc8516aec8, along with other netfs api changes, present in ker=
nel
> > > > > versions 6.8+.
> > > > >
> > > > > Backporting netfs directly would be non-trivial. Instead, I:
> > > > >
> > > > > - add cifs_limit_kvec_subset(), modeled on the existing
> > > > >   cifs_limit_bvec_subset()
> > > > > - choose between the kvec or bvec limiter function early in
> > > > >   cifs_write_from_iter().
> > > > >
> > > > > The Fixes tag references d08089f649a0c, which implements
> > > > > cifs_limit_bvec_subset() and uses it inside cifs_write_from_iter(=
).
> > > > >
> > > > > > > Reproducer:
> > > > > > >
> > > > > > > $ mount.cifs //server/share /mnt -o nolease
> > > > > > > $ cat - > /mnt/test.sh <<EOL
> > > > > > > echo hallo
> > > > > > > EOL
> > > > > > > $ chmod +x /mnt/test.sh
> > > > > > > $ /mnt/test.sh
> > > > > > > bash: /mnt/test.sh: /bin/bash: Defekter Interpreter: Eingabe-=
/Ausgabefehler
> > > > > > > $ rm -f /mnt/test.sh
> > > > > >
> > > > > > Is this what you are expecting to see when it works or when it =
fails?
> > > > > >
> > > > >
> > > > > This is the reproducer for the observed bug. In english it reads =
"Bad
> > > > > interpreter: Input/Output error".
> > > > >
> > > > > FYI: I tried to follow Option 3 of the stable-kernel rules for su=
bmission:
> > > > > <https://www.kernel.org/doc/html/v6.15/process/stable-kernel-rule=
s.html>
> > > > > Please let me know if you'd prefer a different approach or any fu=
rther
> > > > > changes.
> > > > Thanks Henrique.
> > > >
> > > > Hi Greg,
> > > >
> > > > We are observing the same issue with the 6.6 Kernel, Can you please
> > > > help include this patch in the 6.6 stable kernel.?
> > >
> > > Pleas provide a working backport and we will be glad to imclude it.
> > >
> > This fix is not needed now in the stable kernels as "[PATCH] cifs: Fix
> > uncached read into ITER_KVEC iterator" submitted
> > in email thread "Request to backport data corruption fix to stable"
> > fixes this issue.
>
> I do not understand, what commit fixed this?  You attached a fix, but
> that's not needed?

For the issue described originally in this thread, both David and
Henrique has submitted different fixes.
Since David's patch already merged to stable kernel 6.6 recently, we
don't need the patch submitted by Henriqie in this thread.

Link to david's patch that is already in 6.6 stable:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/fs/=
smb/client?h=3Dlinux-6.6.y&id=3D25d6e76639323ee3d1fb4df7066c6d79190f6c33

Thank you.!
