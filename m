Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970CD36683E
	for <linux-cifs@vger.kernel.org>; Tue, 24 Feb 2026 10:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771928696; cv=pass; b=VQdN4n4HkCwSQSNMjvh5ahYaRsqETGQe1283RuYa0sV89TxSpWJgtFT4/gzYWZmUdV/AGPaRC4KtMBsow43A6LmGceElPj3gKiKIbOQeH9AJgPgnZWT2aXauIrVuVpHgpWOteUMA4rTc4t95w+c+ya8Sbr94cjUgScgjRtfZGuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771928696; c=relaxed/simple;
	bh=hHRJy8QJuXqrZvRYe1s2e7pWgh0LxMfTN14cPF1l6/w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P2TDPhV9wze7rdDqqcL/4Uhx4VsHtfVxz9jCJyabOJHeK4LskscWPQEyg+B08YxiIq6I9xdK0wbMGKQ61oQIMUgCGsSeI2Aj3XQeghdXXv5ptEofEmO3MKdS9M/LyNmJ/+BdjqhVw+qM8LECy3ISPXIMYBUJeBIk/HuHpSFzKXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MChaKYxW; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MChaKYxW"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-65f5bd5c8e3so773806a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 24 Feb 2026 02:24:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771928694; cv=none;
        d=google.com; s=arc-20240605;
        b=FGehkqjw8T1jQuR2kZgxgelzoiy5raLv49svcz0RojFQ6MjmX3tW86EHL0fro3SNQS
         11LgX/LM84RBlJVTL/J+USTcCes51SLkvPi6HHwj68GzBeYGGnoewB0b/w+KTh6BC6eZ
         TV6s/yqLw2TL3tBDmvumE6eL9T83BNDoK7fx9rFIg5erDeQlvm2ORPmmpYJQ94TUAwX/
         1XudKeD51m4idTHY4fBBAbom8cV5e1nDEkPnMFjXwbXu3FGBWFx4wN/ypg2mtfw5hu6P
         fsB0s02oEXMUL30WPY+qCgNwE9ZOhDRmUSI51F4woSPAohHbb2LTnb8hXWGPLbqKZCHC
         5FRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=R4CfP6ijHdd5S7Ck6QpALkZNQy7jw70n0RYyKMKxeBg=;
        fh=dmmm9wkGT5qALgCl2eDs3QVBXibYNbe36DaZD6QixGk=;
        b=gZhvTM1hqOAr+4nu8HvNK7iJkn7noQdTPbu4ayZyVl3vulff1/yyQ+3C8gVcAggsTl
         P7AJxWBr4Xjgq8A72FWRpVMHQg5BzA8snYDrh8DQ6/I9PjmIHbddv7XaeF7UltJJPzM7
         ulXS5NGkqdrLL5GdHyEmQd29rAG3mtcECEmE0/uTKbUlUY1zLBFxDZIVgDSTB6+i3RH3
         Ka4RhQxwjMwtLzfeIf+3UKrDT+mOsi2KzCFydOGnnx/s6ykPOS0d9JwGrjDvD4lTSP5x
         fWAEXfrvFmLP1dFqJLFLo73DgDoBq3Mo9moLgbF3mLcBBEcBSxD4E6U1PfKq7T/Q7V8L
         isxg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771928694; x=1772533494; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R4CfP6ijHdd5S7Ck6QpALkZNQy7jw70n0RYyKMKxeBg=;
        b=MChaKYxWvD+DZlEUZHvsI5mLm5EpSg1ddwUMmGClKk5+7mOWr0YwhCy2KJSflhFQYR
         +d+KHhkDKi9kCl6afnU1ilBRws0fBmZmNBPo/EsPCJ/c2UbUJFpQI+5aYObhN6pGo9gD
         CtypBg9If3bVDqJcbqCJjW6ymIJJLHkhCHMHe8Qs6rLZrSpYL3Nplxcn3OH8+jUr25kI
         WeDzG8yTRbMDSiUD0b5URHmZnxqE+YllpX4S+3nP4cd4zRlYo6ToCH+mSJ/X1IW2QT3a
         LJP5HdmauhUvgYH/bgElNAnrLRz/2mxp/cVF6Bq0+TlllmQDpEDKT0ifOg/ZJNn9mvL7
         dGvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771928694; x=1772533494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R4CfP6ijHdd5S7Ck6QpALkZNQy7jw70n0RYyKMKxeBg=;
        b=B9lDERRQdX9SU6ch7H8TLi8tzuaSiUZNbzlPmlQkuB4sGdj73aLtRxRFRGKQG+uYWx
         iHwDb3ClK4U1MK+Scf2rBs3zMZ6StC3YF0wqYdqYFM9SY5TYRgSO3zIWkE3KWUsOyHjL
         +q/bte3RLI8sLawGYGTbj3I7UtLds55RjKHERWrqmBnxGBkYE+q5kziC+qWuffF4dtp9
         s8gIZrIw2KcRbVU8qeA6FWccaJBxQ4nZQUeRz85PfIoByZIH/Krpa5Q4p8vmSIgS5Pkd
         w2zYyydOBZ2oS2hDa9NFFtT7Q5Ei0pIABd8YLc+yiyW3AyMzAEhweld/GwdfQ9KM4vQA
         TBvg==
X-Forwarded-Encrypted: i=1; AJvYcCVpk6v8YXFyNoz0ptg+ylBxCMumxjzNZBjGRKUgYV/tXuorY89DEhQFMxqGAkRcHEBR8AwRsy8JCts/@vger.kernel.org
X-Gm-Message-State: AOJu0YzXf5IZv30+tV67+V5DYoQbuqRmW/kH9adZzdvZ1XhynON8U7Ea
	8hKRG9vlQKG/M5GfsD2zMeUYOMDM2oZes7cQrSzf0cV2tyJMWD/RIComaTxp/KJxdG43ZKr7O4e
	Ev7EsUq0K1bzTldCuiAhiOnNW1VBMrKI=
X-Gm-Gg: ATEYQzwauzyyWBVAsZlOFw6K5GsJJ6s8xTUYayuh/g5sAR9Pz5s2iBVA1ZSi2/UJB3+
	Yc0piiu7ftx8h/+PFEJtQKw8QAnaWDwEvGM/J54kXh4miE/ck9pMdw2dRKAcc3B1e5KPAaCS5w/
	XnU6HHKhKS/Rsc2p/Y+GnwxFNqPqQdmw6ZHjDJtwTQcp/VnwPJPsyPyfdDWYZgsjGgd1YTzgXjx
	bznCtqN9momsstdM0gl8DWcUwjniLVbEiQRm9RzcSIJRaQZgclV3N5SmW61ptGIHLsCIfcV8Ix8
	hoKQeA==
X-Received: by 2002:a05:6402:13c2:b0:65c:23f0:a7f7 with SMTP id
 4fb4d7f45d1cf-65ea4f1a749mr6987443a12.20.1771928693804; Tue, 24 Feb 2026
 02:24:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANT5p=orpQdzqxjNronnnKUo5HFGjuVwkwpjiGHQRmwh8es0Pw@mail.gmail.com>
 <20260224051729.GB1762976@ZenIV>
In-Reply-To: <20260224051729.GB1762976@ZenIV>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 24 Feb 2026 15:54:38 +0530
X-Gm-Features: AaiRm52xL9joVWGaho_Wba2a4d4msaJGHOfSe3rD-ekT6QA6DAsfPGrW7BKXMFM
Message-ID: <CANT5p=pDDjRGF1_vCKvmK+PvXpMQTOquZEEdddFN9mUdTiksHw@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Support to split superblocks during remount
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	linux-nfs@vger.kernel.org, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 24, 2026 at 10:44=E2=80=AFAM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
>
> On Tue, Feb 17, 2026 at 10:15:58AM +0530, Shyam Prasad N wrote:
> > Filesystems today use sget/sget_fc at the time of mount to share
> > superblocks when possible to reuse resources. Often the reuse of
> > superblocks is a function of the mount options supplied. At the time
> > of umount, VFS handles the cleaning up of the superblock and only
> > notifies the filesystem when the last of those references is dropped.
> >
> > Some mount options could change during remount, and remount is
> > associated with a mount point and not the superblock it uses. Ideally,
> > during remount, the mount API needs to provide the filesystem an
> > option to call sget to get a new superblock (that can also be shared)
> > and do a put_super on the old superblock.
> >
> > I do realize that there are challenges here about how to transparently
> > failover resources (files, inodes, dentries etc) to the new
> > superblock.
>
> That's putting it way too mildly.  A _lot_ of places rely upon the follow=
ing:
>         * any struct inode instance belongs to the same superblock throug=
h the
> entire lifetime.  ->i_sb is assign-once and can be accessed as such.
>         * any struct dentry instance belongs to the same superblock throu=
gh
> the entire lifetime; ->d_sb is assign-once and can be accessed as such.  =
If it's
> postive, the corresponding inode will belong to the same superblock.
>         * any struct mount instance is associated with the same superbloc=
k
> through the entire lifetime; ->mnt_sb is assign-once and can be accessed =
as such.
>         * any opened file is associated with the same dentry and mount th=
rough
> the entire lifetime; mount and dentry are from the same superblock.
>
> Exclusion that would required to cope with the possibility of the above
> being violated would cost far too much, and that's without going into the
> amount of analysis needed to make sure that things wouldn't break.
>
> Which filesystem do you have in mind?

The following code use sget* with test functions today:
afs, btrfs, ceph, fuse, gfs2, nfs, ubifs, smb/client
... which means that they can share superblocks.

If those test functions use mount options to decide whether to share a
superblock (at least nfs and smb clients do this), those mount options
can change during remount.
At this point, the filesystems do not even have visibility into other
mounts that share the superblock. Hence they cannot even fail such
remounts.
Side effect of such remounts is that changes to mount options will
apply to all mounts that share the superblock, whether the user
intended to do that or not.

--=20
Regards,
Shyam
