Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65273BFE24
	for <linux-cifs@vger.kernel.org>; Thu, 12 Mar 2026 15:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773330046; cv=pass; b=eePvKYogZKVZcBvuWTJ90mGlxeRrjLiNUj3RTAN7gzJAOX0Ca1LPs7JVkgA6FuG36rTCcmtHM6IodvtGY/3JoIMaGsEFShKMp4rPoev1/bL3N4gHYMzSRxXen3rWyHD3QBmbAdBsDP7hUt3sxDJc6m9uoDvJT9ICVm9MuH1L93Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773330046; c=relaxed/simple;
	bh=9U79XuSEDogMsEE6qxccDeqtvH3bBahfO34fvcv/Lvg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DBrTPpV7QsA/DD9sAXJhbSwKatJ2dwKPuZ1PbyWymz+j8Hk08FM0WLzZh5z7Xr5B+PI8bbZQa0Qegf9xVE2q0q1FqTIYTHYZJ+Rz43ooFb/il4MOh4IGON585jZYnVg86Wwgy6m/R+mE1GKb4KtuGTXQzx+R3X1M9ZPkMSXTti4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FLbRxazJ; arc=pass smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FLbRxazJ"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-899e87b04d8so4516066d6.3
        for <linux-cifs@vger.kernel.org>; Thu, 12 Mar 2026 08:40:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773330043; cv=none;
        d=google.com; s=arc-20240605;
        b=A+Y0rtky0dYzCkmvwIjfSlAgk4ueI71BfGer3Qq0vvpEJiKW/HyHtf3w1Fl8w7SBwz
         /vdJIx/IVlXVXyV7h0uSDzIPOz5488dwUdITHCVqcZLJfyNh086gPwLO/RQ5WrqYcDXT
         i+lkvaxKXWq7Wlpy7iuz1Rwy5e7N0HwGsCu8lXeuHKemX7fMqdf6lyb2bnNRLRrh+8I6
         H3UbUUsC8UDTQ3e+1GYLVkdqBGu4W3rK2ZnmLHO8VZwq3BL/0jiDwhLdcfDoitnCvbK1
         +H4QhjmLrAf6B4lxkPUQ2sr9fUCGQAPgQyEt4A4sRiIsRUTadxjw91isOEu/lJfq7aHv
         Z+cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pTMqddxceH06ae4/6PYanD/2oexQ8xHGkM95DOK/9Sw=;
        fh=Z8/GLW+n7feKaNgSMtBQK+Vs/hbGKGLg+WAVK5RQxr0=;
        b=IOgfwENOAcKILDerpeqa4G2DrehF7FMUebYOmj6PA+pIu/I1tSw0zuPhIHznaX08rG
         /PigmuAAwZy6CpErrzbyJuxTEUBqR1aWRYoJ1i4QcpvKfZ63yDV0xZpAgbsYqcDo8cWy
         xYlPJPMMdDweaQ9zve8CpERNLEODf8mEXiSqy2UmVeevVZgDjoWp9cuqkWMg6wlnh/Mp
         RxyhH0CwTwABVo1BT8YV3FoXVNmvH5gsdP6xp84oYPyb3XyYxuLAfqsJ7Nd9m5rb1Ptk
         eb8MJxMynGpS6ex05OoJjKBb/z1V7m4okWOB2ufpZfjh3Y6pIf5KEA+JG+9Wlqx3irJB
         x6qA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773330043; x=1773934843; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pTMqddxceH06ae4/6PYanD/2oexQ8xHGkM95DOK/9Sw=;
        b=FLbRxazJIzPZEV2sEZx9zrboFDwIn+alCWs5hskbczBtnRLe/otMlpIQowj+KltuzF
         dwUgUcaKyd71ghZv2xyO826u6NaTDLhL6g692D9sn40GRpRbWf4wxY1u0PYC6r9Ik4Ry
         PL4W/U1BRT4K9uf8AlbU3gXXgChiy81qi+81n+UZ4aDPM1gSsyaXSLC2SG7x89IQzJfM
         nDhckLHdULcBqGfdsC2Gy7+vslG/RbVkPU+GYhAx8+NS7nbyur/Z+wukqB/lP87FQ1hH
         xtYVq56q89qXqRAFw4xLuvrXf9l5XzAMxxcMAo5S3Cdi28+zM1w7WebovbE84O8OdspQ
         NZ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773330043; x=1773934843;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pTMqddxceH06ae4/6PYanD/2oexQ8xHGkM95DOK/9Sw=;
        b=iwHkdWf7Le8OYQxMFd4k1/bDxZfWdL0krvwjNHGFgfc8z1jAQIR/e2oLc8Pcm1lfJZ
         9Hlqwb7b2NmhhdTHp1mBCipNqui7HO//jMAlRLcAgS99zwpB2ykH4tfQoft0bdkeIN/+
         nVcrBeWwhHm+pWoi2Am6wo2y+NuIMPYDvh3cJX9Oe0N8XAg+MQm359TpFg49PB49H7Rz
         fDdYJh8/naEKdBSPt5MnKjezmPFE927IesPOqtKvDCbNU6tD6akTj1lcv5IcWZ1xADU/
         Ob0iWXxQcC8zIPDs1RMIW+uKV066AEKzdjhHMNJD1racbT6RbJ+8gejwzUtCVemUSMCD
         o9vg==
X-Forwarded-Encrypted: i=1; AJvYcCWGbqLnyexdg5tzE+sB0N1r58lZ9RZ7L/eGr1R2+kNrDeo+1dmQwVFRWSROTdkjKMryPT5LSCWolLt1@vger.kernel.org
X-Gm-Message-State: AOJu0YyrU6YyG2fo8suAWBFmHY99n0jPEVyRi5TnzeDnB9mnf+C36XGF
	v9CxZ8NDL6AGyEbmPlcSd+bFR9kyQAUbAfmIeplR2fl14ta0iiMeJaSDpB/437g7U+gKgNey6M0
	lHsmyjlUxOL42fzctKJEfM45HSKRNbskt5w==
X-Gm-Gg: ATEYQzzhqWJO+8XlwiovhKWYasyEx6InsJqWC4l9kfLsCgDna9Fbdjaa8I/s9zDNNiP
	r2P2PXoJDORt0Yn+V/qacG9vWc747GnVhMe3Mj+TllImzzqZDkPG7fcH/GiowqrLO328XA+LXp8
	UOm+h1sVzK3Q/H5hrW2QfePS+7tMarvspJ0z08KSvjKffQvkrjKLrs2gjce5xSKwTpSmo1Jy5kp
	Hi/7ZVxeQLdc/0Z1hwePasNxaSy52PygkDCnpKBZBTVNk0s4QskjpOZAd51HIwkjQI6U4OA0632
	XtbO6kC5CyJYU1Kw/oeTt1tpKB7Arg6Ijy4U5alp3d9tMAcEvwJsTggTRY5Jkfivwfmr7K5aFEA
	8oOP07AAZ3IsfeYVEAeIZWLNnKtOh/qSoNhGI+d2zju1pqoQNpLrppg/ZaXZ6UZZ6X3zdqp6Ft6
	hnraI6kPoi5Hz0JX0CZMe4oQ==
X-Received: by 2002:ad4:5ca2:0:b0:899:fd80:f79f with SMTP id
 6a1803df08f44-89a81dde5abmr2633836d6.23.1773330042750; Thu, 12 Mar 2026
 08:40:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310235642.6d9798f4@plasteblaster> <c66p7dr6vlujvnwczbnrmqx7monkdgdnm4rwewm76aibn7jza3@d3uik74dei72>
 <CANT5p=q2Lv4pSvEm5EWcM73b7NZsbt1kYEFJtjaAZRS6Gz_OjQ@mail.gmail.com> <42utcrhajix2x3feckj7ap373osq65sgfz6ximnaj4rasszret@ymhf44ddz2wh>
In-Reply-To: <42utcrhajix2x3feckj7ap373osq65sgfz6ximnaj4rasszret@ymhf44ddz2wh>
From: Steve French <smfrench@gmail.com>
Date: Thu, 12 Mar 2026 10:40:30 -0500
X-Gm-Features: AaiRm52ah7-n07dCG73FeRnFD_pUuk-pLBG0LIJHG-WBVhN-iBaM9Rrd33zCEk0
Message-ID: <CAH2r5msUyFejEbDafcWzSf5oLE3pJCdreaQTm2dxbqfmGtqCRQ@mail.gmail.com>
Subject: Re: [REGRESSION] failure to reconnect on SMB server restart with
 custom TCP port (not 445): Host is down (at least since 6.6.95)
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, 
	"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>, Steve French <sfrench@samba.org>, 
	linux-cifs@vger.kernel.org, regressions@lists.linux.dev, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 12, 2026 at 10:10=E2=80=AFAM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> On Thu, Mar 12, 2026 at 05:44:58AM +0530, Shyam Prasad N wrote:
> > On Wed, Mar 11, 2026 at 7:37=E2=80=AFAM Henrique Carvalho
> > <henrique.carvalho@suse.com> wrote:
> > >
> > > On Tue, Mar 10, 2026 at 11:56:42PM +0100, Dr. Thomas Orgis wrote:
> > > > Dear Linux-CIFS maintainer(s),
> > > >
> > > > I stumbled upon a regression in the Linux cifs/smb3 client when wor=
king
> > > > with a smbd using a non-standard port. I am not the first to note t=
his, see
> > > >
> > > >       https://bbs.archlinux.org/viewtopic.php?id=3D306712
> > > >
> > > > which is a report from mid last year, indicating the problem someti=
me
> > > > after Linux 6.6.72. It is a very simple issue, where details of the
> > > > kernel builds or mount setup don't seem to matter much: Older kerne=
ls
> > > > reconnect to a SMB server that was restarted (old processes killed =
and
> > > > replaced), newer kernels do not and just have a defunct mount.
> > > >
> > > > I reproduced this in our HPC cluster environment with such smb.conf=
 on
> > > > the server side
> > > >
> > > > [global]
> > > > security =3D user
> > > > map to guest =3D Bad Password
> > > > server role =3D standalone server
> > > > smb ports =3D 1445
> > > >
> > > > [public]
> > > > path =3D /some/path
> > > > guest ok =3D yes
> > > > read only =3D yes
> > > >
> > > > and such a mount command on the client:
> > > >
> > > > mount -t smb3 -o port=3D1445,user=3Dguest,password=3Dfoo //server/p=
ublic dir
> > > >
> > > > When I kill and re-start smbd on the server, older client kernels
> > > > reconnect and continue to return listings and files from the share,
> > > > while newer kernels give this:
> > > >
> > >
> > > My suspicion is that the regression was introduced by:
> > >
> > >     5713127da855 ("cifs: update dstaddr whenever channel iface is upd=
ated")
> > >
> > > That change causes parse_server_interfaces() -- should this be runnin=
g
> > > without multichannel mount option? -- to overwrite the port stored in
> > > server->dstaddr with CIFS_PORT.
> > >
> > > The attached patch preserves the existing port from server->dstaddr.
> > >
> > > Note that I have not yet tested this patch or confirmed the regressio=
n
> > > with a bisect. If you can't, I will try to do that tomorrow.
> > >
> > > --
> > > Henrique
> > > SUSE Labs
> >
> > Hi Henrique,
> >
> > AFAIK, the ignoring of port from the results was by design and part of
> > the original code back in 2018:
> > CIFS: parse and store info on iface queries
> >
> > Also, the comment in the code just above says why this is so.
> > [MS-SMB2] 2.2.32.5.1.1 Clients MUST ignore these
> >
> > I checked this section and it says:
> > Port (2 bytes): This field MUST NOT be used and MUST be reserved. The
> > server SHOULD set this field to zero, and the client MUST ignore it on
> > receipt.
> >
> > Based on the conversations here, it looks like smbd ignores this.
> >
> > I think the right fix would be to make sure that
> > cifs_chan_update_iface gets called only for secondary channels. That
> > way, it will not get called for single channel scenarios.
>
> Sure, I read the comment in the code and the MS-SMB2 protocol. The
> protocol states that "client MUST ignore [Port] on receipt". Since we
> are not using p->Port, I don't see how this is a protocol violation.

Agree. Looks harmless

> We're using the port that was selected on mount and copied over to
> server->dstaddr, so that when server->dstaddr is overwridden,
> server->dstaddr keeps the user selected port.
>
> Now, even if we only fix that for primary channels, the secondary
> channels will still get the wrong port when they are overwridden, no? So
> I don't see how that fixes the issue.
>
> Apologies if I'm missing something.
>
> Best regards,
>
> --
> Henrique
> SUSE Labs
>


--=20
Thanks,

Steve
