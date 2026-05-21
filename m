Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91832368D41
	for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 15:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779378578; cv=pass; b=Bxs/TVEYI4hpavq4Vc+hyY63D4PBrZFZPYICywpIls1SVPyf0Xmg1fLhfoSo8+P4ioB9RCPNMhtOy2J7rDvxhtftCUjYUp4YNBeuOgZzQIx3KrqpKvkgb1nRJ/AGA2slk8EIjgbpCjXywX/bYIwvCaJVShP52jFvZGwkhlDpwTg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779378578; c=relaxed/simple;
	bh=oTJGeDYTACLQP4b7lcnYS7MF/F8SkeHi472hQfd2CPw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gnoed14J5rO2QVUiQu2qylOOQv+fUAo63srtZYhmNFy0rBhCeFYd60eMd3OfWrngvV44bCub6YHyaewELgi/WZ+WLvsuWGjyljDIHTFqXttVRPAAn7Ug/DjMPAhK/ipPAy4GkU7LwwrOVF3ycgid2jRO2C1wkDEs3ULosAPeBl4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lL1NHx9I; arc=pass smtp.client-ip=209.85.217.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lL1NHx9I"
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-6314287380bso4501346137.3
        for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 08:49:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779378575; cv=none;
        d=google.com; s=arc-20240605;
        b=RPpn6vVJiV2IF6TROThGRIhr2mYNQAET3YAajVYMhii7nnWsHNXGf+Avy/Xwly+vI7
         3KuJgWNvAzE5GbPX07slbI7JvoNC66NiG31hvLPEjErHqpGEGCSrvdRX0LJHnszUe8u+
         eR9kw9K/bZop+ACpWh19f9Qb2hpH+LkS3S/LPprskUZfKqryhfwCcXclXiTAibUIskR1
         w+psV4BVRgVGtvnR6fZSEGXtT9+xCPchpjASAxCW+VRAAs8prmyg36QkVrAs3o1B1mNs
         1Cx5MIPDUM1CH8/qU0QshV88EDGRPBX4BVcYG7/rVBX9uLwbVcTx/0VKRX+kLc+yftQc
         dgAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BTiKHHtH6isAoh5+/ntoHPqjIgkFbjjbM7Qgllx7bcY=;
        fh=4e1vhdiC3fhLgswsTy3YlQcsp86BzG24TiQjgMUm19U=;
        b=PHZbET66Ob7+fXOS/FpFgAPCVz28V+2sZNEDG4qp4W9IPGevKXmlq8Ma9H4EJKjC14
         XoAUzb8xQ0DmUYTCu2iiHsvQrCEuA6+WbhltWUWCuNYIaEsmkhvpF8FejNFedpi7xPks
         90Ezmp8DLzuf9GUCkatFqcWNHLtRMxkeB4qjKCRknoqy5K/hKpttaN/UVPmixKswbi/8
         vKfV+0djACU2RjFcCpKY7j7BECMcdWnem1m3eRUeAPcfoUDh6wCNwvw4v9z3qZD8lGKj
         hYbyOB/LtSdoduiswsklTRbodp+45epTFrnBzy0TBO45NZ9dVMbkEuzeyafmDNx/U/tX
         4uQg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779378575; x=1779983375; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BTiKHHtH6isAoh5+/ntoHPqjIgkFbjjbM7Qgllx7bcY=;
        b=lL1NHx9IIKtcx4n399OipzLHTG7xOmxIhzXqniZ5H/PlWZnBHPquJmbnT+WXpW8VGl
         gD5K7nwalvqc4Jt0om+M7KYYupeksRrANY4jRunce7CrRXOXxqnPI7tkmKyFagBaXwF0
         8hbAFX6ZrBAhSIQxY+fV56hM0QhsKH/3w0jYikbW8LAIDNiMade6YzJVU1Efx90sVY3x
         4RhbDvS072Slf7nSGxLx08t5GZTGyaCT39m+CpTwAhqunSH3Y9mmA6I+HSghd2xMwMha
         PQ0O8KzBHHVN1VIStAFdCi0DV3GfXQMWyTqCZkVW0qbXHgDdJtycc4DpHzSHcGvAFvB1
         f1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779378575; x=1779983375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BTiKHHtH6isAoh5+/ntoHPqjIgkFbjjbM7Qgllx7bcY=;
        b=T2thIVABsT87ZVxpyT1CWZmtXq9MPZB4F1nWuxmVI+L5rMzeq5UQ743sBjRi03liwE
         6VdKclMDNjQzAYpkKhTvGb7A9AHirli1fTm1tEabrPwi37nag1wpUyWey6pKdS+RcNup
         +dsXcd/yCm691nh2V9Lfkk2ArYLQlAVevW5ZMJKY45j79l8hDPibuWSJfvkkUj6uz/bP
         loXcuoqB92Tj/F3NjyDkkXP+fVJDCdE+yIHZEGwxvUPf4urJVdpBrC6CmTKc5a08lcy0
         klLOKFEnFESuzC1EN/mzI6Fh5/h08l22ZbnIhgiDvHyvS2EDQmWNmTmNzKahhOfWmf8D
         t5CQ==
X-Forwarded-Encrypted: i=1; AFNElJ9+grec5fXPTUwbPRm4MY262V7Q8MhLEa95P1OSTH+wktg35/fDo17+BILWlCa5bf9Qqd3eeCHgsWPq@vger.kernel.org
X-Gm-Message-State: AOJu0YxGD7DWgRZPoic2+Tu77bIGalyTHcDgea8pVdNAZxxp6st0ceiY
	xthAcHpd/yTKjJOmQWLycjwFUZlz03gHxGa4AJKHT98bcdrSEJ+HcDMoJcU2+Xg/P7uBezmRkH5
	ciu3zJt5nJTAHralnS95gN2AVq7Xou4A=
X-Gm-Gg: Acq92OGN2gWEknuRlrg6UhKsfOAYtG2CsYQDcgnFO+vMb8UEn5yoqKgeRlcgnlOl5c4
	BhKLaL/b4hD+MrghipN1cJFC92+QkoDGqlIQRlGRrKB6FPtirz0pDuAcE1PbgdsB6tT3xbof8zk
	UvyzB+pAwZm5mW6qiT1LCB2k60A3u9aY/kCB9NKrUhVBD/kOTE4Fh3kVwuf31FFsBPE+wyqbAAT
	LxoFu9yKduqPi5yFA6XUDCwMO+Yb8MtW7S7TQZO3eyz2ufZgUf0YpgGD9NKRhILiPFmuhD6YHvx
	/nHQapfGJ5bYC8LOOE/Atq+JDw0Qqee/ZlDNgWhY/zftfMHUy8NWwLM=
X-Received: by 2002:a05:6102:1591:b0:650:a9f6:4d29 with SMTP id
 ada2fe7eead31-67390b66b29mr2592164137.13.1779378575543; Thu, 21 May 2026
 08:49:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260328172314.45807-1-dorjoychy111@gmail.com>
 <20260416-abgraben-seeweg-a44ce660957f@brauner> <20260521-grube-leitfaden-0e5420c9bedc@brauner>
In-Reply-To: <20260521-grube-leitfaden-0e5420c9bedc@brauner>
From: Dorjoy Chowdhury <dorjoychy111@gmail.com>
Date: Thu, 21 May 2026 21:49:23 +0600
X-Gm-Features: AVHnY4JMLUcx8yOSfS2Q9vtP8tvb48vFjP_vPMN644Wd5G5CD5CLlCbq3u4DVJI
Message-ID: <CAFfO_h4Em26Hfbv-DWF+9dNS8TBuGpfWjWFBUhLr7jYCKzj3_Q@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] OPENAT2_REGULAR flag support for openat2
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-kselftest@vger.kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	jlayton@kernel.org, chuck.lever@oracle.com, alex.aring@gmail.com, 
	arnd@arndb.de, adilger@dilger.ca, mjguzik@gmail.com, smfrench@gmail.com, 
	richard.henderson@linaro.org, mattst88@gmail.com, linmag7@gmail.com, 
	tsbogend@alpha.franken.de, James.Bottomley@hansenpartnership.com, 
	deller@gmx.de, davem@davemloft.net, andreas@gaisler.com, idryomov@gmail.com, 
	amarkuze@redhat.com, slava@dubeyko.com, agruenba@redhat.com, 
	trondmy@kernel.org, anna@kernel.org, sfrench@samba.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, shuah@kernel.org, miklos@szeredi.hu, 
	hansg@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 21, 2026 at 4:54=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Thu, Apr 16, 2026 at 03:07:12PM +0200, Christian Brauner wrote:
> > On Sat, 28 Mar 2026 23:22:21 +0600, Dorjoy Chowdhury wrote:
> > > I came upon this "Ability to only open regular files" uapi feature su=
ggestion
> > > from https://uapi-group.org/kernel-features/#ability-to-only-open-reg=
ular-files
> > > and thought it would be something I could do as a first patch and get=
 to
> > > know the kernel code a bit better.
> > >
> > > The following filesystems have been tested by building and booting th=
e kernel
> > > x86 bzImage in a Fedora 43 VM in QEMU. I have tested with OPENAT2_REG=
ULAR that
> > > regular files can be successfully opened and non-regular files (direc=
tory, fifo etc)
> > > return -EFTYPE.
> > > - btrfs
> > > - NFS (loopback)
> > > - SMB (loopback)
> > >
> > > [...]
> >
> > - I've added an explanation why OPENAT2_REGULAR is only needed for some
> >   ->atomic_open() implementers but not others. What I don't like is tha=
t
> >   we need all that custom handling in there but it's managable.
> >
> > - I dropped the topmost style conversions. They really don't belong
> >   there and if we switch to something better we should use (1 << <nr>).
> >
> > - I split the EFTYPE errno introduction into a separate patch.
>
> So I've massaged this series a bit in that I moved OPENAT2_REGULAR into
> the upper 64-bit and internally use a __O_REGULAR bit. After having
> thought about it makes a lot more sense to move the openat2() only
> features into the upper 32-bit for the uapi space. I also ported the
> selftests to the TEST* framework to fit with Aleksa's recent rework.

Thanks for fixing up!

Regards,
Dorjoy
