Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795186533;
	b=4J0QeQdRHEzlTIetwp8egNaRyFjxgGfa0BVPJ5FA76By+we7ccGdo7F5Ef4LDA1Z/O6Z
	 qFHVYFd3pvR0mWnW8z1tnBt+nwoe75gEtY+0nmiszRyBeSzIQZ+Q+xaj3ZBn8da/Jk9iY
	 Y8q8fMx75+5F1HdQKyoXYqEhN4KdJOSNoIOvdP8zzAbQBmF585Q03MCx8gCnpFHXz1iwV
	 1gzQe963ozIuQenN44qLHDZK4KlUajIMsiNgMYzq7BFKB2UnfsS4WZsutO11LEWDkXNHg
	 mhkyf+Xs+Dc5Do5eN3kY9HhrSZ4BniW5gYWLjYgmZ+tj1pQZo0pkbFjOGjfh6LWsWoA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186533;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=zpoWzG1+g8sYeNmdw7RPLfc/0HSn9Ajkmbs7oAG/5Qs=;
	b=NcYDYw0xeK3oI/Wn+7xw+miWau9BTsDnn7GV7SHWZJf9tY3tfguYcRLj7t3MwLsrM+e5
	 WscZ5l/iZGZvOdMbePlRKvhBR0lJANXY1ZVacB6WJ6k/cehr+S+fdwlqwg2cOh81joWpk
	 AqUWItTZS5BoQCyZYOn00zRHFVLLY8LzwXy7mMlcmZ4qezoXUkotRpTjovw1KfvsDWi10
	 JFvVy+P/HljRq744sTeKPyDxIsIfJnxeAZhOna3SoSAAQsV7k5A94474sh+QTovNJ8rGT
	 0nEKTPOyIZv7opWBB6mup0uDirQehlKd9F4OWD/VzHxj21UGO5Y+Swksw0RMb1H5WWA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="XT71/E4r";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E95B606A33A
	for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 14:55:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E95B606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XT71/E4r
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b8786bb305so1228278a12.0
        for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 06:55:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795186532; cv=none;
        d=google.com; s=arc-20260327;
        b=MnoF4llORXNKCEiZR6ZtBXJVJy9ZEcbs5LJeItpEmBP+/y/Wks4HWvFEKwwxoR4Oip
         lr9PUoXY2jXfmIWj84fty5RbRIxTaZ4iRjV2b7BZMwSAxgkq1aJmStgS84+bxBGvVkD9
         aT1YpktA2GnEXT4HKa6A9hXMNGSqNgTzpzTFA69Xm/BwxP0OHjeZzo34RrRnnscIc3Iu
         bMDtMFuKIeDi1wqHg6qg8177ProkC7SblulwEoJb524hLJjwIpjodwocbwlOhse/PrGn
         X72PiEKAeI/frFDQqr9CFDiVaMwI5b21zBpH+fPnuLpuPO2dm8aFjh66XWKL8f7JLIIu
         e+Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zpoWzG1+g8sYeNmdw7RPLfc/0HSn9Ajkmbs7oAG/5Qs=;
        fh=Y8amXDovnGsE2rBMYgKxBo85kuPZpQZ/MyXMUSD0Q5g=;
        b=pps/NAIccacHqeXep6bsnQ7z98Os5lN5gUevfqKDsELn7hu0gMggPD6VRyhT9CNGR/
         TErtuX2FoN+lzlGaN0beFsHv1EWoHpibv44cpvNItc4DOmIJqKAvL4KOPrXRZ7d7SGcQ
         vymEWRS4436dEwB9P0J9GZ3OGpkdtCIBGHn821SG9Kk9DhCmmREePZ8sGiryjRhWw7dr
         RVKcpdkart4MFRB6Fli3KtLfc+GgTcgq+HMeIr+fx6rItEdEbKgT8MA/RhwKAMWiK/fz
         hw60bs1WzM1+1OtypkKWf+/JayRB60tHoKAuAWJhLr5foAF8ol9KrhOv/eeEDp6DTIgZ
         PIFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795186532; x=1795791332; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zpoWzG1+g8sYeNmdw7RPLfc/0HSn9Ajkmbs7oAG/5Qs=;
        b=XT71/E4radr+V0uXgPEtpy0gTEoHCeyDzLAY8K94G59n90O+uv++nCc8LBTX/toK/0
         oCtVL35qsDqsHFCvztHPd6HhjbqSJ8Vwc8ZJfStI7YYUhYzRNmLNpBIQMkc69ILk7c36
         ZDgsLeuC7kJXyHt7GV7DGWfHYIq4655Im+cirBeI+iUHoUj7bKjfKZyUnrONaVl4D44J
         ww0U5x8tM0ESZ2EwqzQw4R3/0gUwPfGJym0p5b3otFIF//GO/UwhtCfcmLJW/40OkP+W
         CdiJIaGOl4B0ABFgWYbTFah8knh1vRGWghRZ7vMT9mim8VxC0/RTV9tBJ5cW6vANuiQ4
         lwrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186532; x=1795791332;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zpoWzG1+g8sYeNmdw7RPLfc/0HSn9Ajkmbs7oAG/5Qs=;
        b=1qG/1uVJXpj6l2L+ePmiYiyr+dlQgBPGr7tz1WkbguCU0YaxjxeSNkpIXzZHdbR0gJ
         1PzzbvVxIPkkx5esyCoM+cUlMl0YIq/HiDKIgxhkelC2V//4cwfhD4Ap29UWHbvZuarG
         Wej87YTzx5lZIJHCVLRpkEHj1mMnYgGUlAAyxMlr0/RszVwPEdm7FL1t1XlYAicxTNiJ
         AAKiAGCYt3EYYJgAxCEuc/bK/q6iLrFMSyU351Gz69WayWy516/DcwqwkLxE7pHNkXVQ
         QuO20cNlmLx/uPNPQbpMhfr+udwZOQvjn3Kx31DHebfFLAUp83q1S0uKPJSXfQD0wh7u
         41Qg==
X-Forwarded-Encrypted: i=1; AL+hErH89UtPRD7JgV9S0NX86rr80uvFO3fqjMM1g/VrH4a1V6zXmZ/Q3LqKVGLZf3ZAY0qxgZ+Q9jhuo0yu@vger.kernel.org
X-Gm-Message-State: APuU4Z+9TNbTYYYoagDaeRnpSfEirT9zQigbgRHIaUjpVIW1drXXYlxf
	nA82lDFKJp0MVi4f6UXdKMu/M2nxzOTzRDH2k7RmwuwCNUbomvCdTg8JkeUkHmzFHiqg5mWKHMW
	qsz7QLtlrb3w51hhvbx5xcX86+KY2Ewc=
X-Gm-Gg: AZFdTZfQtmqYSwjMKmfqF3wNvZP+6XiTFR3zJFHHWp9Bo2Hs4cusuWGEVHd7uosalTF
	UbfaHZu/1dauHLil1OTQ1vj6Rq5lfjwkt56nfVONM+HU3Wsq4z6uCl0SxoDSaiLHBcOKl+s3x5B
	UvnbF59BpbV64f8m7oXB108av5ed8M99UAMOHWkp1ecobmCC2veHPQyofA6p7+mHbcGUWlnbbHa
	KrurihhU7C3bTpcE7xVMmEDruL2G0nrl5Ws7GLyOLb4GiKcsYGEVl39flEr1hAOMsx2ryxMDPGW
	APktpKAkUrkG3gelog/m9WtLYK4pJ4WqhvRwmY/+6N2rviJPnh+Hqom1ucAvfjvjy+mxIUgpGgf
	0oUaUENT7ItOhOVjicfVa8m7t6Cv1qF8gLjzidYkWGnWf5JKoj1CZWcHPcr2iroo96D0ouA==
X-Received: by 2002:a05:6402:3223:b0:6b8:5f08:931b with SMTP id
 4fb4d7f45d1cf-6ba37ea44b2mr2503989a12.26.1795186531571; Fri, 20 Nov 2026
 06:55:31 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-9-koray.fra@gmail.com>
 <CAOQ4uxgoNsOH82FyrCxc+qSoid_CFmbmpL0qgWFw-e8E689fFA@mail.gmail.com>
 <DMZJ4PL1JVA4.2YEB7EPYJR5Q7@gmail.com> <CAOQ4uxi6h9BBP7pf4sR+gc2+4XtkEgbxXZha45iZzdB_wGFVgQ@mail.gmail.com>
 <DN02S2XNGRZD.1KNOZJ0GGDJNG@gmail.com>
In-Reply-To: <DN02S2XNGRZD.1KNOZJ0GGDJNG@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Nov 2026 15:55:19 +0100
X-Gm-Features: Aa3M54om4CtJTUNd2Te8u7pI-ZPclkwXdtuzgdSJLpiBpdV9ZiFnAJvfZll4Px8
Message-ID: <CAOQ4uxh+d-wNC0aWLEexPFz7zj=TZjLyu61kaEmwBx9_hKn2gg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 08/10] nfs: add provenance time (ptime) via FATTR4_TIME_CREATE
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 2:34=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Fri Nov 20, 2026 at 7:45 AM CET, Amir Goldstein wrote:
> > On Thu, Nov 19, 2026 at 11:10=E2=80=AFPM koraynilay <koray.fra@gmail.co=
m> wrote:

> >> >                    fa->fsx_xflags |=3D FS_XFLAG_CASENONPRESERVING;
> >> > +                 fa->fsx_xflags_mask |=3D FS_XFLAG_CASENONPRESERVIN=
G;
> >> > +                 fa->fsx_xflags_ro_mask |=3D FS_XFLAG_CASENONPRESER=
VING;
> >> Uhm, why both in _mask and _ro_mask? If it's a RDONLY flag shouldn't
> >> it *only* be in _ro_mask? (same for CASEFOLD)
> >>
> >
> > Good question. Maybe
> > I guess if you want to follow some percent
> > FS_FL_USER_MODIFIABLE is a subset of FS_FL_USER_VISIBLE
> > but I think that exporting ro_mask and _mask is going to be easier and
> > cleaner than rw_mask but not sure.
>
> Hmm I asked that also because you said in the xfs shared extent thread:
>
> > The advantage being that it makes the interface symmetric.
> > User can alway setattr() with the buffer they got from getattr()
> > and instead of randomly ignoring flags in set, the fsx_ro_mask
> > along with fsx_mask defines the behavior exactly.
>
> But by putting the ro flags in _mask too, a user would have to clean
> them out or vfs will reject the call with -EINVAL/something else, since
> in that case the vfs would see the user say "I want to change this [ro]
> flag".
>

That's just a matter of interpretation.

You could say that if flag FS_XFLAG_CASENONPRESERVING
is in ro_mask then its value may not be modified and fs needs to
fail the set if the user given value is not a match to the current
kernel's value.

Could be used for an "atomic flag set" operation, but I think
this is taking this too far.

I am fine with xflags_ro_mask and xflags_rw_mask I guess this
is the less ambiguous option.

Thanks,
Amir.
