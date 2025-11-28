Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB3722F76F
	for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 22:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764369319; cv=none; b=kT/FqTButWXQxvaH0eHEkGjGh5wAYjVAL6K8uj7jYHO8daxXz25tH2kvo29jGgcOS257tRt7qr4PgsU02ooTgaqJg09bR2q8+ito9yMrDR2J7n7Qf1RoJb18vjCckgJ/zm09geoFEkHodXlfzA+ZP5cnZX2pCSooLLg9I9rKNGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764369319; c=relaxed/simple;
	bh=S+Mpc1wlbHkCS86rCBjYrtHFETwOD9dQfan7zpMgPu4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cR1IUq5ULgHpfLQSNlChxE3UTSnJL/Y5MXND81JMOlRz0y0lLuU/XcAo4Ea/JRFDeFa5/VJbxb3y1Sqz0OZqtOhSsObfy3BUZzy/YEOXh8d6hyrQoPybxnyUmQuJZuXiplIs2Gq2fNTa9OIO7lXKvkXaTCnJA54wsob8AWDtx2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rY6TgPc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rY6TgPc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A2EC113D0
	for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 22:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764369318;
	bh=S+Mpc1wlbHkCS86rCBjYrtHFETwOD9dQfan7zpMgPu4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rY6TgPc0LPw+M54diNjS8Zoi5/60XDm7NvRevHwd76iSwCpZeQnYsqCm6N3E+eyU9
	 Noi5AF07zACktN5qIUS1eqjG2lyO1ykDNVGG8gSStxNs95vR6QSIBCK8u3BT8jctdQ
	 UT6Gl4OEwi9BP5JeEByslkFuiZrUk9NpORdcpem/LyLXZiN57CPACMjQkqwxuL/YXF
	 ifM+Bp3ISaIKFVNMZ77zkEMwj4x3JO+roo3ZuN/ZZOpq2bzdXge/qA3PjSPCpOKpLI
	 MnYOEoRmA5M4bM6OA0eHqgUA+D2r1aRIBJeEjQ/I9kE23Oldj46VnBovlYU4i9bXh4
	 Se/DYHEniQBQg==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6419aaced59so3476780a12.0
        for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 14:35:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCURaXgKV3JNK+R27sDfBC/rBfRi9CjNC/A2Dm9fcDJNegANnAaFmiEp4n5eKaLlWHJvgnlRqpaaMgGo@vger.kernel.org
X-Gm-Message-State: AOJu0YzG/Koyw6ZiFquyk3Y733SEm42+TeboCQTKGNXJYyAZqCTwR/KX
	WeOvKSKnO8DganZ57o4j9m7ZcLbWG44hdUBI/W5EaZNqBKE/EytIW/7yV3bhrqM+3Km3emtQzxS
	sdgmonaZjpkdvnu0a4W5aqqaHMKzseSg=
X-Google-Smtp-Source: AGHT+IGZJMfP+2VSSrV4uP88weqgT8/jFOOGQ0EKxJ1Cf5a0QhAsxPSjnendDLzoTrW5XwUwYKqUPIVgpgHgXUO/gnY=
X-Received: by 2002:a05:6402:2713:b0:640:ecaa:1973 with SMTP id
 4fb4d7f45d1cf-6455469c1cfmr24132348a12.24.1764369317091; Fri, 28 Nov 2025
 14:35:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128134951.2331836-1-metze@samba.org> <CAH2r5msBaRVPNkaMy0iQKPq9COR+p5+UUNf-B-Fh6=v7zKNRnQ@mail.gmail.com>
 <7ff0bc80-f94c-4cc9-b85a-0ddc1393c9a1@samba.org> <CAH2r5msAQ7JZvOksSWJiW9SrZmX85yzcbHJ1Zb7r=P9yU+p5Ew@mail.gmail.com>
 <e67a626a-828a-434d-8921-4bd8fcaeabcb@samba.org>
In-Reply-To: <e67a626a-828a-434d-8921-4bd8fcaeabcb@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 29 Nov 2025 07:35:05 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9CouGFSOjFCL3gk=tggsX7r02wcs8XkzOdxM0XJ93NHQ@mail.gmail.com>
X-Gm-Features: AWmQ_bm56QToV0Lx9Q4KqE7qKuIHb8umGTkIDJmcRY4S_9T82enMsgEoYuNgVqs
Message-ID: <CAKYAXd9CouGFSOjFCL3gk=tggsX7r02wcs8XkzOdxM0XJ93NHQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: change git.samba.org to https
To: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

You should first buy a Mellanox connectX series NIC. That's what most
people use. ksmbd rdma is actually having issues with Windows client +
connectX-7 after applying your work. This is what I was most worried
about when you started this, and the patches are so fucking chopped up
that they're hard to find. I'm absolutely against splitting the
smbdirect section, and every time you unilaterally apply something to
smbdirect.ko, it affects ksmbd rdma.

Thanks.

On Sat, Nov 29, 2025 at 3:51=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Am 28.11.25 um 19:15 schrieb Steve French:
> > ok - this change seems harmless.   I also want to look at way to add
> > you to MAINTAINERS to make clear you are "expert" at RDMA/SMBDIRECT
> > and either reviewer or co-maintainer for smb client/server/common more
> > generally.  Wanted to look at a few other examples in MAINTAINERS and
> > compare
>
> I compared things like
> NETWORKING [GENERAL]
> and
> NETWORKING [SOCKETS]
>
> They are 2 sections, but some files overlab.
>
> scripts/get_maintainer.pl include/net/sock.h
> Eric Dumazet <edumazet@google.com> (maintainer:NETWORKING [SOCKETS])
> Kuniyuki Iwashima <kuniyu@google.com> (maintainer:NETWORKING [SOCKETS])
> Paolo Abeni <pabeni@redhat.com> (maintainer:NETWORKING [SOCKETS])
> Willem de Bruijn <willemb@google.com> (maintainer:NETWORKING [SOCKETS])
> "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING [GENERAL])
> Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING [GENERAL])
> Simon Horman <horms@kernel.org> (reviewer:NETWORKING [GENERAL])
> netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
> linux-kernel@vger.kernel.org (open list)
>
> And I think we might want an additional section that covers
> F:     fs/smb/common/smbdirect/
> F:     fs/smb/client/smbdirect.*
> F:     fs/smb/server/transport_rdma.*
>
> That way the maintainers for the smbdirect section will appear
> first followed by the more general results.
>
> I first thought to have excludes for fs/smb/common/smbdirect/
> in the cifs.ko and ksmbd.ko sections, but we can leave that out
> and just let it overlab.
>
> > On Fri, Nov 28, 2025 at 12:00=E2=80=AFPM Stefan Metzmacher <metze@samba=
.org> wrote:
> >>
> >> Am 28.11.25 um 18:48 schrieb Steve French:
> >>> On Fri, Nov 28, 2025 at 7:49=E2=80=AFAM Stefan Metzmacher <metze@samb=
a.org> wrote:
> >>>>
> >>>> This is the preferred way to access the server.
> >>>
> >>> Are you sure that is the preferred way?  75% of the entries in
> >>> MAINTAINERS use "git git://" not "git http://" but ... I did notice
> >>> that for all github and gitlab ones they use "git http://"
> >>
> >> It seems a lot of them were created long time ago.
> >>
> >>> But maybe for samba.org there is an advantage to https?!
> >>
> >> Yes, the admins of git.samba.org prefer that clients use https://
> >> instead of git://
> >>
> >> I also checked what linux-net uses and it also uses https most of the =
time:
> >>
> >> $ git lo -187 linux-next/master  | grep 'Merge branch .*\/\/'| grep ht=
tps | wc -l
> >> 178
> >> $ git lo -187 linux-next/master  | grep 'Merge branch .*\/\/'| grep -v=
 https | cut -d ' ' -f2-
> >> Merge branch 'main' of git://git.infradead.org/users/willy/xarray.git
> >> Merge branch 'master' of git://www.linux-watchdog.org/linux-watchdog-n=
ext.git
> >> Merge branch 'master' of git://git.code.sf.net/p/tomoyo/tomoyo.git
> >> Merge branch 'next' of git://linuxtv.org/media-ci/media-pending.git
> >> Merge branch 'docs-next' of git://git.lwn.net/linux.git
> >> Merge branch 'master' of git://git.kernel.org/pub/scm/virt/kvm/kvm.git
> >>
> >> metze
> >
> >
> >
>
