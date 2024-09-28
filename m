Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B73614A96;
	Sat, 28 Sep 2024 16:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727541439; cv=none; b=oT25tfWz9IE1eimtwCPghD3NfJtq/s8XluWzFSG1Cd3Cov/8+3OXu0OXXHF2GZcJzvQlAYk6N77ACcjwl9DBMdWsJfhomMAzaTvAf1Xk2ekQF/z8eGiVyHDBKvL5TDYmY+mkEB22jdtvRis1yOfDL2zvsN06nrR6SA2899QOaw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727541439; c=relaxed/simple;
	bh=koVz/ln5F1wiPscG190/9l2/xOw7jSM7KVoWY1j5LXA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OBuRSNiw+1hn7Bola7r72xFzfbV+DyHngE4JbQayg/TI+9Zf3IAwT5G9C4aOArru0Qf+zqBm4SZh57lQPpkRc/7lv5BLap1OAQnOu1uJuiKDgEFHgyqnwb4mMg2fhnQC2vkuB6geU0dtU8YGLvZ1PXO75XU6kuXE/8/ruP5uhKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N9SREswQ; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N9SREswQ"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e24a2bc0827so2881393276.2;
        Sat, 28 Sep 2024 09:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727541436; x=1728146236; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1nl9bgLuzs+y5Hwfh6ZezhQ59+LSYEnB9kHBKOLaIBc=;
        b=N9SREswQQ1py/1BU43bngXh4fF1z3L8zBmiMmU63i2kfGMO3l0iI12MzjtmTn1g1OX
         RbsFggDDoo1YiF96spnJOtPbQgkf87XeAPGcn9dL8OOEbTPAYBmcZQCZShtHvRRuRwCa
         Rcpt787sEL/kpIDC1/oavbjN+QlH7L2scPTO+43vdQ9JajA5zf6GTkg8t7YrPsmHiktw
         3Mmb0ayqqaWc5F4K0NPlKeWSVIfA594QbZg6ZnTIn4ntfhVlp95k96PYhjeVofVh1259
         iSK4zCZt7pZQ2OjaW8eQpCYVbgIWzL1sMiJvUDW7Oh7wvMiGrJ2zO0vjO0LOPTwM+4HZ
         suNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727541436; x=1728146236;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1nl9bgLuzs+y5Hwfh6ZezhQ59+LSYEnB9kHBKOLaIBc=;
        b=pAV8v0cwxbqmUlffF+ZRiUlJMHklN4DmeRg70N8KIrUtEvHQl1Eev1ldEHoWRyEdnk
         hfLrj34vcQ0MCHAwrMr7E8TttWdPRX9ESVcaFmXkVyIzCL7nvimB5Rv/zmcGVKx7PL1I
         OjEechRgqd0EraUFoHIdpORMsb3poC5F4ke9EE/cXBmvFk8lQexxXmceXolGEqlAH/8V
         +AFPRxrSGn+Pm2zIgoIY6p8sX/kfgHs3o3A1BFGWTwo9+TE2LJnzz3X8LsPTHJ+koJV+
         kQ7w7rO712SYgukHlL87kW91GXxXgFcTyUD6M8YzL5ah7hrHPSt6JanF34TNK7NcompU
         Jc1w==
X-Forwarded-Encrypted: i=1; AJvYcCU1qXXApOvfNsd7pYusPe5M3D4hsW+LynJeCon3XZ7+j4guB9gINaFWWmouKgY5uxvV2cWtoKyrYb/yRW/1@vger.kernel.org, AJvYcCVq6QW+vYWfyX4cc9TutvEJ5IYkURkK2QyBSDjdMpQE1fgyK7nqV0sXW+BmsXXYboWpy+O4bYsq@vger.kernel.org, AJvYcCXHDjOsSDP2vZGUxvXQNjuEXGCbpds7Fsqu1vGwl88i3/L/+EJhy06/xyKjGJvE/9IvJcIo2Vh6pz6h@vger.kernel.org
X-Gm-Message-State: AOJu0YzJbyxxSFKz87uwRogQBa9TgplsPI75bxjJUQnPmmlJkxuFhzTH
	M9GfkByXeDVyh1KTRgbodNMqbs86uE8CYSTajlIvBKD6e7wDNIVInajsb5bX6BfZHzSjYLAUcCX
	BZnrtrkxn3qFRWq07H2h6U9pK9AM=
X-Google-Smtp-Source: AGHT+IFqQ7hE0yBezED2+Hc1PgATK5XbX30GW43woqeLiKk3Uuz+M/WZ1ZUUSvfXvI4HMUvTVPcV1g+l4UMjKSLbbpI=
X-Received: by 2002:a05:6902:cca:b0:e24:9eba:aad0 with SMTP id
 3f1490d57ef6-e2604b3e6c3mr5956491276.14.1727541436360; Sat, 28 Sep 2024
 09:37:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <DFC1DAC5-5C6C-4DC2-807A-DAF12E4B7882@gmail.com>
 <20240923075527.3B9A.409509F4@e16-tech.com> <CABaPp_iqgUw3TffQHrVYUoVoh03Rx0UjvrNw0ALStF8FxufFrg@mail.gmail.com>
 <CABaPp_hf8haF20YCipL0cdB6NQPMHue45n1fmEUvo_BL_Wuyfg@mail.gmail.com>
In-Reply-To: <CABaPp_hf8haF20YCipL0cdB6NQPMHue45n1fmEUvo_BL_Wuyfg@mail.gmail.com>
From: james young <pronoiac@gmail.com>
Date: Sat, 28 Sep 2024 09:37:04 -0700
Message-ID: <CABaPp_iLCoCAW=2jHEvgM15UJiwWXq5BXh0rCXtu-80tk6Zuvw@mail.gmail.com>
Subject: Re: [REGRESSION] Corruption on cifs / smb write on ARM, kernels 6.3-6.9
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: pronoiac+kernel@gmail.com, stable@vger.kernel.org, 
	regressions@lists.linux.dev, linux-cifs@vger.kernel.org, 
	David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org, 
	Steve French <sfrench@samba.org>, smfrench@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I retraced my steps:
* looking for the breaking commit, between 6.2 and 6.3-rc1
* I switched to checksumming the stream and the written file; this can
save time, compared to decompression
* I checked for lzop, pigz, and pbzip2

So, breakage. I landed on different commits:
last working commit. ok: lzop, pigz, pbzip2.
16541195c6d9 cifs: Add a function to read into an iter from a socket

first broken commit. lzop failed.
d08089f649a0 cifs: Change the I/O paths to use an iterator rather than
a page list

That broken commit is right before my previous "last good" and "break".

I'm seeing some inconsistencies. I'd *thought* I was careful with dtb
files and .config; I might have dropped the ball occasionally, or
there's something else, I don't know what, that I'm stumbling over.

To check for marginal hardware, I tried another Raspberry Pi 4. I
verified baseline 6.6.52 didn't work there, and stopped there. It
doesn't have any cooling; it *almost certainly* would throttle for
thermal reasons, but I didn't want to push it.

-James


On Tue, Sep 24, 2024 at 9:35=E2=80=AFPM james young <pronoiac@gmail.com> wr=
ote:
>
> On request:
> * adding another cc for Steven
> * I tested 6.6.52, without any extra commits: it was bad.
>
> -James
>
> On Mon, Sep 23, 2024 at 12:36=E2=80=AFPM james young <pronoiac@gmail.com>=
 wrote:
> >
> > Hey there -
> >
> > On Sun, Sep 22, 2024 at 4:55=E2=80=AFPM Wang Yugui <wangyugui@e16-tech.=
com> wrote:
> > >
> > > Hi,
> > >
> > > > I was benchmarking some compressors, piping to and from a network s=
hare on a NAS, and some consistently wrote corrupted data.
> >
> > > > Important commits:
> > > > It looked like both the breakage and the fix came in during rc1 rel=
eases.
> > > >
> > > > Breakage, v6.3-rc1:
> > > > I manually bisected commits in fs/smb* and fs/cifs.
> > > >
> > > > 3d78fe73fa12 cifs: Build the RDMA SGE list directly from an iterato=
r
> > > > > lzop and pigz worked. last working. test in progress: pbzip2
> >
> > This is a first for me: lzop was fine, but pbzip2 still had issues,
> > roughly a clock hour into compression. (When lzop has issues, it's
> > usually within a minute or two.)
> >
> >
> > > > 607aea3cc2a8 cifs: Remove unused code
> > > > > lzop didn't work. first broken
> > > >
> > > >
> > > > Fix, v6.10-rc1:
> > > > I manually bisected commits in fs/smb.
> > > >
> > > > 69c3c023af25 cifs: Implement netfslib hooks
> > > > > lzop didn't work. last broken one
> > > >
> > > > 3ee1a1fc3981 cifs: Cut over to using netfslib
> > > > > lzop, pigz, pbzip2, all worked. first fixed one
> >
> > > I checked 607aea3cc2a8, it just removed some code in #if 0 ... #endif=
.
> > > so this regression is not introduced in 607aea3cc2a8,  but the reprod=
uce
> > > frequency is changed here.
> >
> > I agree. The pbzip2 results above, regarding the break bisection I
> > landed on: they mark when it became more of an issue, but not when it
> > started.
> >
> > I could re-run tests and dig into possible false negatives. It'll be
> > slower going, though.
> >
> >
> > > Another issue in 6.6.y maybe related
> > > https://lore.kernel.org/linux-fsdevel/9e8f8872-f51b-4a09-a92c-4921874=
8dd62@meta.com/T/
> >
> > In comparison: I'm relieved that my issue is something that can be
> > tested within hours, on one device.
> >
> >
> > > Do this regression still happen after the following patches are appli=
ed?
> > >
> > > a60cc288a1a2 :Luis Chamberlain: test_xarray: add tests for advanced m=
ulti-index use
> > > a08c7193e4f1 :Sidhartha Kumar: mm/filemap: remove hugetlb special cas=
ing in filemap.c
> > > 6212eb4d7a63 :Hongbo Li: mm/filemap: avoid type conversion
> > >
> > > de60fd8ddeda :Kairui Song: mm/filemap: return early if failed to allo=
cate memory for split
> > > b2ebcf9d3d5a :Kairui Song: mm/filemap: clean up hugetlb exclusion cod=
e
> > > a4864671ca0b :Kairui Song: lib/xarray: introduce a new helper xas_get=
_order
> > > 6758c1128ceb :Kairui Song: mm/filemap: optimize filemap folio adding
> >
> > No luck: I cherry-picked those commits into 6.6.52, and upon testing
> > lzop, the file didn't match the stream, and decompression failed.
> >
> > Thank you for investigating, and giving me something to try!
> >
> > -James
