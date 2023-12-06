Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DU977O9Q"
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5F61B5
	for <linux-cifs@vger.kernel.org>; Tue,  5 Dec 2023 21:32:10 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2ca03103155so39239451fa.0
        for <linux-cifs@vger.kernel.org>; Tue, 05 Dec 2023 21:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701840728; x=1702445528; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=grTzbFS6yVVmXUWl2bJ3zLb/r0KodpBegFOwgXDH7b8=;
        b=DU977O9Qd3z3cT0RUyH6htPOBSsGIWBA0ONIQawSftDj1oSccSP1wMLiYxBor9HrYI
         5PpCMn7HJLEnTzT9j954C/3SjKRt71L6+frKhTyv21oiRlWvyLJ63q1zjNjMpT3VGuSe
         B6epJnazb82e8Ls2nBk9MmCZH5QwJXOCNQxD6fYr9QO4zKGet8yiUINMkeq1jDnvacAp
         6zHNfbXQZDjgVagMhsda5TifDlGChyYzIx5KrU4DM7GgT0iOdjj2RDSxzzcRc1K0ZEBY
         W8RWWiaCVjnE18frnBiVKDZpumJpKQfxfwcC/OEM8vxUZnIi+oEt9Yw89JG/3LykKzh7
         LLaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701840728; x=1702445528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=grTzbFS6yVVmXUWl2bJ3zLb/r0KodpBegFOwgXDH7b8=;
        b=atzelFw3wD/ygNQvWRE9UNw/bDZfciY2fDeG+FS1BrIbhBwj6lvU7EuEgBPssObdYz
         DeAl3Snmr2V0DWBqNm4VmKXTNFjKAqz3aQqUAArMJEyz6D1sHq5aLETnXU65Qx0+qbdy
         30XccK/620Mnac4UhWnAjJxHxovBVUdfQdyA/oxwgP/9xANHphrAXFj77fif6VJ5dFH6
         WwnN0epg8vQUzvSzspTduDWsahEroDggAzo8+tDQnXLJRlXGo8yXowPPc0NmvLcnr0m9
         M5wsChAQoY8s2LrwaoVDqaCOqK7cNw51QDRKh41mjZTYQjhyl3yesbV/bMrvganHPsKa
         /CRA==
X-Gm-Message-State: AOJu0Yw4jlrW//ejP5k3NcM2TLgeUKEGvVouULlWgqZIfFVCXqMSQ7RG
	yZBFoUztMWiIz9sSJcY3A9gQ3oTU7ZN4fiZv9Pc=
X-Google-Smtp-Source: AGHT+IEtyqX2de/vViMxk2F/CLZOT7s6mcALlkoZc2U9/Yq9yGv2MhfOAOCuizzFA2BMblJum0l7vEVanKHWVdMxfQ8=
X-Received: by 2002:a2e:b6c1:0:b0:2ca:5d4:c16d with SMTP id
 m1-20020a2eb6c1000000b002ca05d4c16dmr121320ljo.54.1701840728230; Tue, 05 Dec
 2023 21:32:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231204045632.72226-1-meetakshisetiyaoss@gmail.com> <65d6d76197069e56b472bbfead425913@manguebit.com>
In-Reply-To: <65d6d76197069e56b472bbfead425913@manguebit.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Wed, 6 Dec 2023 11:01:57 +0530
Message-ID: <CANT5p=qnEFJDTTrSRkdBfkE9Kzw9BzGRegtCuW6Hb4xc7PSdaQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Reuse file lease key in compound operations
To: Paulo Alcantara <pc@manguebit.com>
Cc: meetakshisetiyaoss@gmail.com, linux-cifs@vger.kernel.org, 
	smfrench@gmail.com, bharathsm.hsk@gmail.com, lsahlber@redhat.com, 
	tom@talpey.com, Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 6, 2023 at 1:02=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> meetakshisetiyaoss@gmail.com writes:
>
> > From: Meetakshi Setiya <msetiya@microsoft.com>
> >
> > Lock contention during unlink operation causes cifs lease break ack
> > worker thread to block and delay sending lease break acks to server.
> > This case occurs when multiple threads perform unlink, write and lease
> > break acks on the same file. Thhis patch fixes the problem by reusing
> > the existing lease keys for rename, unlink and set path size compound
> > operations so that the client does not break its own lease.
> >
> > Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
> > ---
> >  fs/smb/client/cifsglob.h  |  6 ++---
> >  fs/smb/client/cifsproto.h |  8 +++----
> >  fs/smb/client/cifssmb.c   |  6 ++---
> >  fs/smb/client/inode.c     | 12 +++++-----
> >  fs/smb/client/smb2inode.c | 49 +++++++++++++++++++++++++--------------
> >  fs/smb/client/smb2proto.h |  8 +++----
> >  6 files changed, 51 insertions(+), 38 deletions(-)
>
> NAK.  This patch broke some xfstests.
>
> Consider this reproducer:
>
> $ cat repro.sh
> #!/bin/sh
>
> umount /mnt/1 &>/dev/null
> mount.cifs //srv/share /mnt/1 -o ...,vers=3D3.1.1
> rm /mnt/1/* &>/dev/null
> pushd /mnt/1 >/dev/null
> touch foo
> ln -v foo bar
> rm -v bar
> popd >/dev/null
> umount /mnt/1 &>/dev/null
> $ ./repro.sh
> 'bar' =3D> 'foo'
> rm: cannot remove 'bar': Invalid argument
>
> This is what going on
>
> - client creates 'foo' with RHW lease granted.
> - client creates hardlink file 'bar'.
>
> At this point, we have two positive dentries (foo & bar) which share
> same inode.
>
> - The client then attempts to remove 'bar' by re-using lease key from
> 'foo' through compound request CREATE(DELETE)+CLOSE, which fails with
> STATUS_INVALID_PARAMETER.

That's interesting. I'm assuming that the STATUS_INVALID_PARAMETER is
due to the server not recognizing the lease id for the file bar.
I'm not sure that this is a client bug.
If the server supports hard links, then should it not be aware that
foo and bar are the same files? AFAIK, file lease is associated with a
file, and not the dentry.
Meetakshi, can you please follow the repro steps provided by Paulo
(against Windows file server) and check why the invalid parameter
error is being returned?

--=20
Regards,
Shyam
