Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6B117C219
	for <linux-cifs@vger.kernel.org>; Thu, 26 Jun 2025 04:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750910662; cv=none; b=sc9jR2QO6cl2VNK01J2RMZML4O5xAFwuZOg5tAgLuUfMThGGsgYlukNoxmaNQyFP0VHFiUWMCBAWjPonxY7xQtJBRw48DanP5VtBmBXuaQ91BVXr1/kNUcccrZBUJ7ks+uTvxBeX0hX8bkKbFuGnuOUCoSWScvPv8SC8Gx9Zook=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750910662; c=relaxed/simple;
	bh=NXVP6lv9y/1jNfT6s/0B9EKXKMJBOf5fjRYEJUiRc80=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nEdXQ1a+QPXxqw1CwJriePWhvryjA4+jQHitZ7bSwqkdiIPTBJwDAe2OC9Z0M5N1HOKx+nNGom3reRer6uHFCuzWcX+wrJ1CLoWDpW/VTFfZ48VKhz3/c4B25yJnukpdrvdp/Udle6yklCj2gy0NyU7sObe6Ss5lmczrEQnjsy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C7Qky3Dx; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C7Qky3Dx"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6facc3b9559so9403616d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 25 Jun 2025 21:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750910659; x=1751515459; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z6iCx1O1Lo/wPeKWt1nxIhTYxBaKlt49EsNi7JBbcrI=;
        b=C7Qky3Dxe+7+2ogfmRZ2WtjO1oS+eflb05ZvFEhFfehHK4POPn3dKGmFnOo5HRj8et
         0Oy556ItFfpgXsAjNot9fI1F4KFXWmp+LTgZH7bDtQAsO16KdlUx9YLsgqL0P1ZCKpy6
         md4UaaofDyIxrLns1lXBeRL/HzGqqVcqbP7oMDommI5XXf4BId090MTGNuZ5jS3wJjGt
         06OubZQ1nx1hJmqn95oF+Rcx7w0Vzks6e/vRfFnfKDWe4FY14mucZ3LrnKVAuIIjLTfD
         E9OXVESHTeZI7yDcQE9UBNJ5ClvN9w4qalVsXIFt2yKp4OxzmPvyWEHzFRMTF/oNlO7l
         S0uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750910659; x=1751515459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z6iCx1O1Lo/wPeKWt1nxIhTYxBaKlt49EsNi7JBbcrI=;
        b=lF3kAoavXg/w80rnibOih0uQAPBY+Uhy5hYMtKTRRQNGB11quWuvY9VvgJWvoJsR6Q
         yTzdN2YGq4gIPsFf5ZifVU7l/SfZEonbOgyBLflDSuFOpY7SPPprJYhUPoXcQGFZkFlq
         SJ1XxweRXP9bT+Nx8dxau1YrjN/EhXPBISl8KeWovO+8ZO3OFuJB/0V7yoy7InFYOfVR
         hwo41Ujz9DybY122FYtPO1MkvHiPEcwf7r/GiW06Oc7LWyD/FyMtL2dO9F2L4JmJrKvo
         1toXYrqPAeN8iWB73Ok/bQoUUjzc82CblY3jJdrKOHT7bVjTSnSGnwsFvUbvDiD1K0+v
         IdaA==
X-Gm-Message-State: AOJu0YzftSrsZV1d8PfDNNBW1TZ5SV6fIHVGKotd9XxJC52dsfOgAGnv
	wkXyeQ0z+v/FM2m7oG9HZXwe0yhhh8qOZdF8T1xhqVW1MOeoxpnFtOSZrmvGGKyPP/PFagVkzsd
	15A5rrsXdwFFp64IyQcu+fh5+z0tAzeEu4g==
X-Gm-Gg: ASbGncuqMu2KCH0M2f2LHRggxqWGl1Me87TVOKShfrdrfwaDbsxnpK+iziLaln8VJB9
	d5GFtOfMtfWuiWzmLZQBX/xGg5Fm0PYY7eDo5lsL3SyHmUyw7Wn49phzye5oMfxuBJXE2pvKy4t
	F3SFGzOZ7Akf3QostXZwIMBS378crketBs2NZzZ7yCaYXxDZZgfpHLREQn+nm58J1FNJ+JRs0G7
	eg09A==
X-Google-Smtp-Source: AGHT+IH9MUeUPrq20xRGYnTvjolMPv24IryUK2IwKGqEf7H1rbrkE77NYdlk9t8jGLYyb5uBUU3HX0w4qGIk1gMYLVg=
X-Received: by 2002:ad4:576f:0:b0:6fa:fb7d:6e4c with SMTP id
 6a1803df08f44-6fd5ef81cddmr88608456d6.25.1750910659259; Wed, 25 Jun 2025
 21:04:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mvHYB91=HU2NMUbinpXTWzKq82RXhRMiAPwSa-u5c6x7g@mail.gmail.com>
 <CAH2r5ms2xfU0dSrkLbVUKsN5mH1r0re=6134oH4eETtqYOLaUg@mail.gmail.com> <CAH2r5msEafHhEvmKKAp0Rn2OZjRtgEgeqL_P3F9oL8cBK0tj+g@mail.gmail.com>
In-Reply-To: <CAH2r5msEafHhEvmKKAp0Rn2OZjRtgEgeqL_P3F9oL8cBK0tj+g@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 25 Jun 2025 23:04:07 -0500
X-Gm-Features: Ac12FXxODRtqU1vM7jrpSZFJuSbWe8cyKJ3Bmsqm6m8cOKxtQcEQj7qrpmnIBlc
Message-ID: <CAH2r5msr=U0r8bAkKVZw3mSjvRTTO2+7xOCMrYfPnJzvsOqfog@mail.gmail.com>
Subject: Re: build warning with [PATCH] smb: client: set missing retry flag in
 cifs_readv callback
To: Paulo Alcantara <pc@manguebit.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, David Howells <dhowells@redhat.com>, 
	Shyam Prasad <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied updated patch from Paulo (which addresses the warning) and
applied to for-next

On Wed, Jun 25, 2025 at 10:30=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> Actuall warning goes away when I remove this patch:
>
> 3556a6e915cf (HEAD -> for-next) smb: client: fix potential deadlock
> when reconnecting channels
>
> On Wed, Jun 25, 2025 at 10:05=E2=80=AFPM Steve French <smfrench@gmail.com=
> wrote:
> >
> > I also get the same warning building with David Howell's netfs-fixes br=
anch:
> >
> > connect.c:144:1: warning: context imbalance in
> > 'cifs_signal_cifsd_for_reconnect' - wrong count at exit
> >
> > dc9b2fe5f874 (HEAD -> netfs-fixes, origin/netfs-fixes) netfs: Update
> > tracepoints in a number of ways
> > 4d2f067052f8 netfs: Renumber the NETFS_RREQ_* flags to make traces
> > easier to read
> > 9ee1c1860c95 smb: client: fix potential deadlock when reconnecting chan=
nels
> > ecd66e4e1009 cifs: Fix reading into an ITER_FOLIOQ from the smbdirect c=
ode
> > 7aea400b3ab2 cifs: Fix the smbd_reponse slab to allow usercopy
> > db6c446f962b smb: client: let smbd_post_send_iter() respect the peers
> > max_send_size and transmit all data
> > e7878f222221 smb: client: fix warning when reconnecting channel
> > 9006c79c12bd smb: client: fix regression with native SMB symlinks
> > ac6518c40791 smb: client: set missing retry flag in cifs_writev_callbac=
k()
> > 79548ed9b3b5 smb: client: set missing retry flag in cifs_readv_callback=
()
> > 020ea6c76c4e smb: client: set missing retry flag in smb2_writev_callbac=
k()
> > 5a2221d576f1 netfs: Fix ref leak on inserted extra subreq in write retr=
y
> > b2e88c77791d netfs: Fix looping in wait functions
> > 5a5ec8260ee9 netfs: Provide helpers to perform NETFS_RREQ_IN_PROGRESS
> > flag wangling
> > 4a5175d393e3 netfs: Put double put of request
> > 76a8fb1fdfd4 netfs: Fix hang due to missing case in final DIO read
> > result collection
> > 86731a2a651e (tag: v6.16-rc3) Linux 6.16-rc3
> >
> > On Wed, Jun 25, 2025 at 10:02=E2=80=AFPM Steve French <smfrench@gmail.c=
om> wrote:
> > >
> > > I get the following build warning with the patch:
> > >
> > > connect.c:144:1: warning: context imbalance in
> > > 'cifs_signal_cifsd_for_reconnect' - wrong count at exit
> > >
> > >
> > > commit 8596d54298d3170badcfda1175499ad3af240d09 (HEAD -> for-next,
> > > tmp-fn-6-25-25)
> > > Author: Paulo Alcantara <pc@manguebit.org>
> > > Date:   Wed Jun 18 15:22:27 2025 -0300
> > >
> > >     smb: client: set missing retry flag in cifs_readv_callback()
> > >
> > >     Set NETFS_SREQ_NEED_RETRY flag to tell netfslib that the subreq n=
eeds
> > >     to be retried.
> > >
> > >     Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
> > >     Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> > >     Signed-off-by: David Howells <dhowells@redhat.com>
> > >     Cc: Steve French <sfrench@samba.org>
> > >     Cc: linux-cifs@vger.kernel.org
> > >     Cc: netfs@lists.linux.dev
> > >     Signed-off-by: Steve French <stfrench@microsoft.com>
> > >
> > > It is built on:
> > >
> > > 50fa8c47b1e4 (HEAD -> for-next) smb: client: set missing retry flag i=
n
> > > smb2_writev_callback()
> > > 37743a9b6195 netfs: Fix ref leak on inserted extra subreq in write re=
try
> > > 3a335ade2c4e netfs: Fix looping in wait functions
> > > 827cb4d8a936 netfs: Provide helpers to perform NETFS_RREQ_IN_PROGRESS
> > > flag wangling
> > > cf9167613953 netfs: Put double put of request
> > > 0f05eeb631a6 netfs: Fix hang due to missing case in final DIO read
> > > result collection
> > > 3556a6e915cf smb: client: fix potential deadlock when reconnecting ch=
annels
> > > e97f9540ce00 smb: client: remove \t from TP_printk statements
> > > 1944f6ab4967 smb: client: let smbd_post_send_iter() respect the peers
> > > max_send_size and transmit all data
> > > ff8abbd248c1 smb: client: fix regression with native SMB symlinks
> > > 86731a2a651e (tag: v6.16-rc3) Linux 6.16-rc3
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
