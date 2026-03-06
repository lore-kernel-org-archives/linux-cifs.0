Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E652635BDC4
	for <linux-cifs@vger.kernel.org>; Fri,  6 Mar 2026 23:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772839447; cv=pass; b=MwfXuh7vEQfqZXpzOLEXOVyzcO0jH6Xske3rAccs3QSzE5o4UATg13ypWNbGXXhDbpcDoFUyzUu2xLzk7Y5UIFXnRGcJoBM/UC7FG8e/eZOOi0wVXca+rX5+vZBZajfFdNGA/MvkefrN6oE7W56NsbhZkhGRdsH7aOHUWVjtu1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772839447; c=relaxed/simple;
	bh=Ihzdl60WXLrCKbvm5l00X83jPZzcevSpMpwMOk4ZAsY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f5d9z5byumGaI1zjs3QGT10AnpvtxFK8j6fZjMYlaU25T9/0FuBY/oOZFqqPV5bEWekLloNk/w7iLVCEAzKBLR12Qdd0EplcyDRVyq61ZVzY0MeOE+WxQ+iB502MTRec+DrXRePwN2R+R7IhI9WIzw5TRsS2OC0OcA3OZv9uTRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l8qkv1Ub; arc=pass smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l8qkv1Ub"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-899fa7d0780so61720976d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 06 Mar 2026 15:24:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772839445; cv=none;
        d=google.com; s=arc-20240605;
        b=XgnYhf3Fw/xZkV9wuhpd7AufJinXnJtgUyVpsB6BmQM/kZAwyytl1kO9SkXGXsNyuJ
         lMjCzPxTI7nzVYGX/RB2MnYyZzNnoynqXayZA7SPhtc6AlzIks/uCcFgZal+P/dmMZll
         pJYH+/aXECYt8Fe3m1UX0tdkEPeGZvBktiR3P8rPxrHN0iwQ9gB2r8iwQ6mRG/seLDki
         VqUZv1jRGbLPyyIYZC/BRvvTyRoK3wM6rbAAkti0kRT/Ye5QcN45kcC0ibzX/3SD6wea
         4AchP5VbGK4ByV2CIf5IsQ6zMQnEXcBjj//XpPrlIY4reR1Ox/BGzw2MehWHcU3N6MV6
         iopw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PT1fWqc0qe7ly9MH3YS5q6bsLcq0zlKw2O5NYlsr7+U=;
        fh=pthKZ+QkKKZbyHmydDFLtJydsm0si97Wq2OFpgmmJNQ=;
        b=f9qW5Hs1CtRVKw4EI3FCLqQLpfF4/amvTO2Q4zpNbOfqwks2OmVpQBerJAAJKdvTOW
         XDK1xHGaCbgZlZB9MAEelhm904pV2Mti6q6EYKvuPB+6y2/Gde8rvP6vWDEJS90cObR2
         Kd24veaim19mNG2f/qfVM/Pdzwfzm3uxMFGZl+4aFTiuhAfRSUTN7a63lcwgfagPIBhU
         n9iqm1cyaDuPbS7iNqQQ9kzCQ4h4N5OAaNuiwEO2te4dSNeBuJl/kSbqBA7N+eqYAbdp
         zVIbqVHKUlnLwbOYCmkZMxQ72V4xn1ugVG0u98KLgIRNQL04n4SZKTUuh28S0nCgCNiN
         SV/w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772839445; x=1773444245; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PT1fWqc0qe7ly9MH3YS5q6bsLcq0zlKw2O5NYlsr7+U=;
        b=l8qkv1UbKcJW9GyGl2tlwahB6d7tdy6sOgRtI9KLcx43XHuV8wlA4FsA4t4MhJDBBo
         hsrklSwJi3PF1pRQ5EEMxFwBxvNpzqzD2kcqEiEBUT6g6lBb8WyRt6jb5i0l9VOXAIdH
         ab1NWwYMFZhaI06cr8zAb32D00bPll1slkK5cLBXcTrRpSH86iuq/ZywzBMPnOGq6ZAn
         /eZ1XWVBm9UbxiOjA9t0TzUFvpSdvm6UYXB7LLueHuBtYVeHuk21zjrFwJCv8KeVRile
         57uTemahDqEAOJGnyiAMFWMlEcIaQx7Imre3tlWTTrIFYteaAph/iBG7iS798c9mbRbX
         4YQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772839445; x=1773444245;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PT1fWqc0qe7ly9MH3YS5q6bsLcq0zlKw2O5NYlsr7+U=;
        b=ZwIfelQXmWaJYFIoX9cTqqkJXWtF1loGC/f8bq5xNJnklhVYZLm9BRPjfLHeWpGZtH
         UDApyCV20ZUlaZMDyifm2RlwLOdqYhNHUl7+5mgMGGw3en4H8LrxaAAnyphS5s1FYSdw
         gyqNUqd8NMr/8jX0v546MsMjPpfEg6DLL+JEeAHa74DZoHAHTvg8yB5mreadDX5o6cQp
         k2QY18zEELgHmOaP1vs8wFyvLrL6osId2ZdXqgR7Bv2j3mcaGibjHBIQMDzoDvRy3dR7
         MhtBHFOfjJ99dgBaameNATILXZdTa5WWTVKdIUJ3b8SZMen5u6QcB7z26vS89wThiVVz
         FbrA==
X-Forwarded-Encrypted: i=1; AJvYcCVva7r4fAUqNTLcm+WT3N/PUISA8SNMCPjrNs0L4l2gVeEgtX/uRElOywxmkNK1OIC7qq0FeycwfZxQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9SnOBbZls5eb55SdYnm2nNyatydlojrEPqLh6nS1d9mZLavVa
	deR93eVxzB8SiNzG9YjYS+a3VZKzDzzmIACg1h4bMGoJLCwtRzStPGMSNTvNO5kFfOrtkbsZjnn
	I+F8FbOJ7gCVJACIVLudbIq5Hry2sWt8=
X-Gm-Gg: ATEYQzyECFz2g4zI84/f5vuHlgjcP69NWfJH05T7qibREIxnD5o/3vHB9IR/gctpCTK
	R0sn5R63Nyi15qYr5wXOuv5HjOFSBJyMj5iojtxxnzIRLov+Mcw/l9eupNDVcVE8tyyzTQngwfP
	pSIQzkbYZqFcSJdt+QZt2TO0bHvzyIi6VgC6ARYXOtF6qgpyHQUU6ks/dsowb4iW2aZrPg8adi/
	c7KWAlJ1wXVE5IMzR1Q5ZOiydHRZKAhIyPwOYs2BknHcKTNvRh/VxH9C86JJWrz/S0CatzIjURH
	/dVGiQz3QUX17/k3yPYE0sk7sixGadtZ7tWFWP1qLDR5OYrRCox3PwuHwiagLGaFzqUgR1XFY36
	2LLqFr+xQ88f0Tf17jJEEeQYwF7aE2KjVB7ejidWgKAuONJdzdcV/8AC32n1FATdYh8m+9SOHsK
	WAovOEpWXLzumLYIxIPTU2Nw==
X-Received: by 2002:ad4:5aeb:0:b0:89a:b37:6b20 with SMTP id
 6a1803df08f44-89a30a2a62cmr55365116d6.1.1772839444975; Fri, 06 Mar 2026
 15:24:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260304122910.1612435-1-sprasad@microsoft.com>
 <CANT5p=rk44fGgUL_Swp1pbVUeE80GJS4hxF00U0X4_xUbb-7hw@mail.gmail.com>
 <4rrxsl6mx3lbpt32l4ly6psg3ni5nsfzgfiufzt4xecsbjh22o@z272atyrzzvh>
 <CAH2r5mt4mDP+o4FWcJLhiXxcnjou7jxzPzUv1RqvmJxb=OSh6A@mail.gmail.com> <9ef8fa889e302e58846ca6d33957077f@manguebit.org>
In-Reply-To: <9ef8fa889e302e58846ca6d33957077f@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Fri, 6 Mar 2026 17:23:53 -0600
X-Gm-Features: AaiRm51GXaBstBxixTOxESCrTW5sYFXv-HES3QioMVnxXcpNp1RznNuKwYoThpc
Message-ID: <CAH2r5muKHGze-uNX2qJgX7z+WF+1H1vQ3hxFUexAybCC3pNhgA@mail.gmail.com>
Subject: Re: [PATCH] cifs: implementation id context as negotiate context
To: Paulo Alcantara <pc@manguebit.org>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>, Shyam Prasad N <nspmangalore@gmail.com>, 
	linux-cifs@vger.kernel.org, bharathsm@microsoft.com, dhowells@redhat.com, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 6, 2026 at 5:19=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> w=
rote:
>
> Steve French <smfrench@gmail.com> writes:
>
> > On Fri, Mar 6, 2026 at 4:45=E2=80=AFPM Henrique Carvalho
> > <henrique.carvalho@suse.com> wrote:
> >>
> >> On Wed, Mar 04, 2026 at 06:04:05PM +0530, Shyam Prasad N wrote: > On W=
ed, Mar 4, 2026 at 5:59=E2=80=AFPM <nspmangalore@gmail.com> wrote: From: Sh=
yam Prasad N <sprasad@microsoft.com>
> >> >
> >> > A proof-of-concept based on this draft from Bharath.
> >> > Looking for comments on how to improve.
> >>
> >> Looks good.
> >>
> >> Just one minor thing for now. To me the cifs.ko module version doesn't
> >> say much as it seems to be not reliable (apologies if I'm mistaken).
> >
> > It does get incremented every 10 weeks.
> >
> >> Also, the same version could have different implementations in differe=
nt
> >> distributions. modinfo -F srcversion cifs is a better way to
> >> differentiate cifs versions but not to compare versions. So the soluti=
on
> >> is either remove this or bump it in every change using X.Y.Z.
> >
> > We do bump the module version every kernel release, e.g. we are at
> > 2.59 in Linux 7.0 (7.0-rc2)
> > Would bump it when someone does a 'full backport' of most cifs fixes
> > to an earlier kernel.
>
> Who?
>
> >> Further, have you thought about how the client can use this in its fav=
or
> >> other than diagnosing/debugging a faulty server?
> >
> > I thought this was for the reverse - so the server support team can
> > get metrics on whether the client is an old client with known bugs
>
> The client version is entirely pointless, especially for distribution
> kernels.  The support team can't figure out by just looking at the
> client version as the backports are what really matter in terms of a
> distro kernel.  Most distro kernels don't even bother backporting those
> commits that bump the client version, which makes it even more
> inaccurate.
>
> >> I think we need to be clear on what is allowed here, to me it seems
> >> quirks, workarounds and perf tuning? Maybe this can be used to improve
> >> interaction between linux client and linux server?
> >
> > presumably primarily for customer support to be able to recognise
> > known client problems on clients accessing a server
>
> Neither the client or kernel version will tell you _exactly_ where the
> problem is in distro kernels.

The combination of the various version fields would be 99% likely to
be able to match to a particular distro version (at least for the
major ones, SuSE, Redhat, Ubuntu, Mariner).  Unfortunately there are
many customers out there who run kernels more than four years old so
can be helpful to know client os version

--=20
Thanks,

Steve
