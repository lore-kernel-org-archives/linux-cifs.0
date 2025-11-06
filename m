Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C8133A00C
	for <linux-cifs@vger.kernel.org>; Thu,  6 Nov 2025 14:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762437774; cv=none; b=dJdrEMJiRDfGpHjCq3t6eiWMaioutkk83cQojHtw1tUyPuzQSC5Y/qRckOluYlbwoTZPSvQiy9DIbTx8Qvttdqjim3u8HI5H+ixlWVjEC821j2qDflDPDelhxG21Je4zxBmVf7xjX0hELuEAt402/0xT0X5MrRNLU91h9fITa3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762437774; c=relaxed/simple;
	bh=WvSEkVsKHi18LbupKspxuUo3UwUMwfEICSlrjEE1bZ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PLc9zM0kcbZLxr6iku/F42juLChoZgALPY/mWWoM7CukWIvs3F2smmTCy5+qsz3ixO3owSstgnunwaVL3KJtmAXB6SAwK5emZ2b6leRbcjTwZ9cVPP5inzrRdHDpLGWBnUkjLQ5E8HRRGuCp1hCN19mu0slKIlQPQHUbjI453yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V5l4V/kH; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V5l4V/kH"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-7864cef1976so30684477b3.0
        for <linux-cifs@vger.kernel.org>; Thu, 06 Nov 2025 06:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762437771; x=1763042571; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=inUDTdZs9Vh0fPhADocRHvWqcynk3OywAFkuRGyh6uA=;
        b=V5l4V/kHC41i3whnRC/eXu8RWcxU9IxGzqexoEkx5ZACrufgvAfwLD5foTzvRYGrSC
         YxmbhRF/8OatLsnCHr/B+ZKLIwz9+MdrriUPGL06Du8IZCeKoLZGRNI4FDDpheKPGq0R
         OFhO7vHKQgaA8lTPM/xUgdE2bhtJtNcCcKkaOnVSmME0/vQ4q6R+ili29qhUJXi5FRe/
         OQE54b2u5K+EW0+hoH+ZZeuL4yJWGD3IM+/i6KY5UHiHLmoXPNe11S8KnH03MA3e2BJR
         HCBXJYSrYUzV2zeYQgOGBJiuaNme8RNluOPSUbZgdo/R8G69+jJu4xCR6O5rav0vBsBd
         AGHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762437771; x=1763042571;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=inUDTdZs9Vh0fPhADocRHvWqcynk3OywAFkuRGyh6uA=;
        b=lH7wMD/9+3kUtsZ9AUSW+vhrTVC3CKCeQoNgpFdZx/NzEaypz5NtyXJ+t+GKbtvuih
         H0l15O8eHhNGjT2Yas8NavzDxlqX8ev4AtCnw1m8RJAgQc+F0CCsJkzTZYcFC1HfEBay
         UdM5TgceML8zRoD2ei786fNolEA65GuIVqo336PHU5CauYhKl+Z6/Gat0vsDjVEzgdtu
         vrjdXxOdpH26pkMnWc0Hw2K2M4bb8F7r6eoCf/HHJ7liL2A2n3TQKT9r5CEPuE8yo1Ju
         vj4/tPBloGf0HVTjoh1UPcSBGL2pjjtAbxG+Y/dYOmChzHuMxzE9ahdIGxxjbnz7jAZC
         GiuA==
X-Forwarded-Encrypted: i=1; AJvYcCWhBcuM+9jkcNxQn6vEmsMO94jCyQJtIMBaaSrJafzIaxUL03GlXGECxNWn2eI7W7PtlrqOGSBtUi4X@vger.kernel.org
X-Gm-Message-State: AOJu0YxsLJhTKv3hR43vn/9onZHcXGpincGAhlzeIe9NQOueHeN+emXj
	mmsXcc9Zf14+TwhJOMPDp2Lm8YVF9/F+Qmb+eF8HCC1gTwJ68lTBH8yIZ1+NzbAKUYJsyZUspli
	gOuocrdI58obwu0bcptiPZzaf6CqmIFW1Z4X43Ls=
X-Gm-Gg: ASbGncvsVVH2BsMTBxRJq/GoEfFiMOcmAngaCTOYvGhNKa6OGI0T3x2b6VXR7vWv/Tx
	UWqbWKEwkAgL4Icca6KVR6aNhlwA7zOnAYbShQ6snySqhYp350bVQQwB/9Wys6EyeZblaNYYhFC
	JpeTjN28lxOzf6HgsLOJt51NPLw1BUaywNWUJ4L79pI01sMM98iukPxTIDDw+NNjUv0Ik/9Mdzp
	eA+ZP1qDXK2lA7Uvn/TQTf8Nnckr74PcLSgK55st5Er6EA7a9ElvGJLNrNmYZ0E3Wm6MuNp
X-Google-Smtp-Source: AGHT+IH5rRqBdd0h/d3zF3xb5h/Gzp7i9AdCeqJZxt2JD7xsPG0L9f8JF4omL+mDvX2gYJDASpEwCiiiUakTCt5oCqo=
X-Received: by 2002:a05:690e:1402:b0:63f:ae5f:d7cb with SMTP id
 956f58d0204a3-640b52ae4e7mr2498693d50.0.1762437770721; Thu, 06 Nov 2025
 06:02:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250710165040.3525304-1-henrique.carvalho@suse.com>
 <2944136.1752224518@warthog.procyon.org.uk> <aHE0--yUyFJqK6lb@precision>
In-Reply-To: <aHE0--yUyFJqK6lb@precision>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Thu, 6 Nov 2025 06:02:39 -0800
X-Gm-Features: AWmQ_bmoYkmo6SDuLYq4N60l8-Fq8PbA7W5LXKJcb8BD7Nyh0avwRGwuCYHfANg
Message-ID: <CAGypqWyyA6nUfH-bGhQxLYD74O7EcE_6_W15=AB8jvi6yZiV_Q@mail.gmail.com>
Subject: Re: [PATCH 6.6.y] smb: client: support kvec iterators in async read path
To: Henrique Carvalho <henrique.carvalho@suse.com>, gregkh@linuxfoundation.org, 
	stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>, apais@microsoft.com, 
	Bharath S M <bharathsm@microsoft.com>
Cc: David Howells <dhowells@redhat.com>, smfrench@gmail.com, linux-cifs@vger.kernel.org, 
	Laura Kerner <laura.kerner@ichaus.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2025 at 9:01=E2=80=AFAM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> On Fri, Jul 11, 2025 at 10:01:58AM +0100, David Howells wrote:
> > Henrique Carvalho <henrique.carvalho@suse.com> wrote:
> >
> > > Add cifs_limit_kvec_subset() and select the appropriate limiter in
> > > cifs_send_async_read() to handle kvec iterators in async read path,
> > > fixing the EIO bug when running executables in cifs shares mounted
> > > with nolease.
> > >
> > > This patch -- or equivalent patch, does not exist upstream, as the
> > > upstream code has suffered considerable API changes. The affected pat=
h
> > > is currently handled by netfs lib and located under netfs/direct_read=
.c.
> >
> > Are you saying that you do see this upstream too?
> >
>
> No, the patch only targets the 6.6.y stable tree. Since version 6.8,
> this path has moved into the netfs layer, so the original bug no longer
> exists.
>
> The bug was fixed at least since the commit referred in the commit
> message -- 3ee1a1fc3981. In this commit, the call to cifs_user_readv()
> is replaced by a call to netfs_unbuffered_read_iter(), inside the
> function cifs_strict_readv().
>
> netfs_unbuffered_read_iter() itself was introduced in commit
> 016dc8516aec8, along with other netfs api changes, present in kernel
> versions 6.8+.
>
> Backporting netfs directly would be non-trivial. Instead, I:
>
> - add cifs_limit_kvec_subset(), modeled on the existing
>   cifs_limit_bvec_subset()
> - choose between the kvec or bvec limiter function early in
>   cifs_write_from_iter().
>
> The Fixes tag references d08089f649a0c, which implements
> cifs_limit_bvec_subset() and uses it inside cifs_write_from_iter().
>
> > > Reproducer:
> > >
> > > $ mount.cifs //server/share /mnt -o nolease
> > > $ cat - > /mnt/test.sh <<EOL
> > > echo hallo
> > > EOL
> > > $ chmod +x /mnt/test.sh
> > > $ /mnt/test.sh
> > > bash: /mnt/test.sh: /bin/bash: Defekter Interpreter: Eingabe-/Ausgabe=
fehler
> > > $ rm -f /mnt/test.sh
> >
> > Is this what you are expecting to see when it works or when it fails?
> >
>
> This is the reproducer for the observed bug. In english it reads "Bad
> interpreter: Input/Output error".
>
> FYI: I tried to follow Option 3 of the stable-kernel rules for submission=
:
> <https://www.kernel.org/doc/html/v6.15/process/stable-kernel-rules.html>
> Please let me know if you'd prefer a different approach or any further
> changes.
Thanks Henrique.

Hi Greg,

We are observing the same issue with the 6.6 Kernel, Can you please
help include this patch in the 6.6 stable kernel.?

Hi David and Steve,

Can you please review this patch and share your comments.?

-Bharath
