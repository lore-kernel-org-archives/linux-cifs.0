Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22231841;
	Sun, 14 Jan 2024 03:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W9VpVtDa"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2cd64022164so81160541fa.3;
        Sat, 13 Jan 2024 19:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705202635; x=1705807435; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gfta0bZFvjFZJvC0F4xMIC685zJ7SAda9ZzxTagHvw4=;
        b=W9VpVtDaOUUQFPLw8XvE8hWY8Vu/tBwKkyBPbo2a6AtpqP8GMJKpR8Fyux1FiResLw
         pRlY4vVyy6XztFRASezvKg8jh/lyoL1ZmMoKAe9lNEO6T2wm1a2AL6et8dl3sU3kUtmy
         53XZ0uTZ4Z/O/Ke079oerhIh3mrZGCl/GGppmvTGc2fFZnsNA80yxyeYsCO0Z+jENM4W
         79NJ8vzgqlS1XOcu8ldDmUFGF/txfMavw3uD2JS2CH9VPBdBzudKHDlXf7HvIbOpG1EK
         HD4droo9XiKE343aP/6eIdR6JoC4eZH375zQJ1l/LaliYqwaTnhwEt4FulDD3VV1FZY+
         ZDsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705202635; x=1705807435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gfta0bZFvjFZJvC0F4xMIC685zJ7SAda9ZzxTagHvw4=;
        b=WaRFHls+E7PgPfVwSjE1KMUCibfC+HzJzjBzBk7uxWvWyhLSrFbYxpnlejl8Ct6RUM
         mMytpk3ZlbxbLMh9sqIoqYxjV8Qtl5VQhZRHaWekaFJls7RSztwo0Jb5GGVeT2pzQDLC
         X7oHtosgh1qqfLNew2YkS0kIEQ3c4vIgPCO5/HDrDEN4DSsCeloK8a1f2bnSmetdem7e
         hF5FlHDbG532gxdizGi9vLf5b/u7ObftGQCwyZ0xIZPyOJDBgQ7z9Wn3hIJTg8t+JpOb
         2o1TABSRd8o1+NU63WJeckjLrczHLfORP3AOhPSuKgihM7tTl3hBBjpL9UcqTRnSJQHu
         53Zw==
X-Gm-Message-State: AOJu0Yw5F1MSPbW85MtG2E/JO+FnC50zpcsPIzvzI0wK9vaQ+kdl3LW6
	s93y/inlrHG7058/fe8FfTbUVGqy+TTkVrIPS/s=
X-Google-Smtp-Source: AGHT+IHp2Jx9EpAWnyz05z7ZSv6ATR2OJO4m7nQlWoPvbzSMzQn2WZ/mqDTyJ/wGxu1LoMGKhW1HWVA6N84aJAq1mZQ=
X-Received: by 2002:a2e:a409:0:b0:2cc:5e44:a8ee with SMTP id
 p9-20020a2ea409000000b002cc5e44a8eemr1815150ljn.105.1705202634498; Sat, 13
 Jan 2024 19:23:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a76b370f93cb928c049b94e1fde0d2da506dfcb2.camel@amazon.com>
 <ZZhrpNJ3zxMR8wcU@eldamar.lan> <8e59220d-b0f3-4dae-afc3-36acfa6873e4@leemhuis.info>
 <ZZk6qA54A-KfzmSz@eldamar.lan> <13a70cc5-78fc-49a4-8d78-41e5479e3023@leemhuis.info>
 <ZZ7Dy69ZJCEyKhhS@eldamar.lan> <2024011115-neatly-trout-5532@gregkh>
 <2162049.1705069551@warthog.procyon.org.uk> <CAH2r5mtBSvp9D8s3bX7KNWjXdTuOHPx5Z005jp8F5kuJgU3Z-g@mail.gmail.com>
 <ZaJYgkI9o5J1U3TX@eldamar.lan> <2024011316-cathouse-relearn-df14@gregkh>
In-Reply-To: <2024011316-cathouse-relearn-df14@gregkh>
From: Steve French <smfrench@gmail.com>
Date: Sat, 13 Jan 2024 21:23:43 -0600
Message-ID: <CAH2r5msjAwRmQNOvkDm5NZD0zh141iNV87urxOK04n-6FQ5wbQ@mail.gmail.com>
Subject: Re: [Regression 6.1.y] From "cifs: Fix flushing, invalidation and
 file size with copy_file_range()"
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: Salvatore Bonaccorso <carnil@debian.org>, David Howells <dhowells@redhat.com>, 
	Paulo Alcantara <pc@manguebit.com>, Shyam Prasad N <nspmangalore@gmail.com>, 
	Rohith Surabattula <rohiths.msft@gmail.com>, Matthew Wilcox <willy@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Steve French <stfrench@microsoft.com>, 
	"Jitindar Singh, Suraj" <surajjs@amazon.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>, stable@vger.kernel.org, 
	linux-cifs@vger.kernel.org, 
	Linux regressions mailing list <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tested out fine so far

On Sat, Jan 13, 2024 at 3:41=E2=80=AFAM gregkh@linuxfoundation.org
<gregkh@linuxfoundation.org> wrote:
>
> On Sat, Jan 13, 2024 at 10:31:46AM +0100, Salvatore Bonaccorso wrote:
> > Hi,
> >
> > On Fri, Jan 12, 2024 at 11:20:53PM -0600, Steve French wrote:
> > > Here is a patch similar to what David suggested.  Seems
> > > straightforward fix.  See attached.
> > > I did limited testing on it tonight with 6.1 (will do more tomorrow,
> > > but feedback welcome) but it did fix the regression in xfstest
> > > generic/001 mentioned in this thread.
> > >
> > >
> > >
> > >
> > > On Fri, Jan 12, 2024 at 8:26=E2=80=AFAM David Howells <dhowells@redha=
t.com> wrote:
> > > >
> > > > gregkh@linuxfoundation.org <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > > I guess I can just revert the single commit here?  Can someone se=
nd me
> > > > > the revert that I need to do so as I get it right?
> > > >
> > > > In cifs_flush_folio() the error check for filemap_get_folio() just =
needs
> > > > changing to check !folio instead of IS_ERR(folio).
> > > >
> > > > David
> > > >
> > > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> > > From ba288a873fb8ac3d1bf5563366558a905620c071 Mon Sep 17 00:00:00 200=
1
> > > From: Steve French <stfrench@microsoft.com>
> > > Date: Fri, 12 Jan 2024 23:08:51 -0600
> > > Subject: [PATCH] cifs: fix flushing folio regression for 6.1 backport
> > >
> > > filemap_get_folio works differenty in 6.1 vs. later kernels
> > > (returning NULL in 6.1 instead of an error).  Add
> > > this minor correction which addresses the regression in the patch:
> > >   cifs: Fix flushing, invalidation and file size with copy_file_range=
()
> > >
> > > Suggested-by: David Howells <dhowells@redhat.com>
> > > Reported-by: Salvatore Bonaccorso <carnil@debian.org>
> > > Signed-off-by: Steve French <stfrench@microsoft.com>
> > > ---
> > >  fs/smb/client/cifsfs.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> > > index 2e15b182e59f..ac0b7f229a23 100644
> > > --- a/fs/smb/client/cifsfs.c
> > > +++ b/fs/smb/client/cifsfs.c
> > > @@ -1240,7 +1240,7 @@ static int cifs_flush_folio(struct inode *inode=
, loff_t pos, loff_t *_fstart, lo
> > >     int rc =3D 0;
> > >
> > >     folio =3D filemap_get_folio(inode->i_mapping, index);
> > > -   if (IS_ERR(folio))
> > > +   if ((!folio) || (IS_ERR(folio)))
> > >             return 0;
> > >
> > >     size =3D folio_size(folio);
> >
> > I was able to test the patch with the case from the Debian bugreport
> > and seems to resolve the issue. Even if late, as Greg just queued up
> > already:
> >
> > Tested-by: Salvatore Bonaccorso <carnil@debian.org>
>
> Thanks, I've added your tested-by to the patch now.
>
> greg k-h



--=20
Thanks,

Steve
