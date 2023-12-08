Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BNDpbyxd"
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC0DAC
	for <linux-cifs@vger.kernel.org>; Fri,  8 Dec 2023 02:59:06 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2ca0f21e48cso23955821fa.2
        for <linux-cifs@vger.kernel.org>; Fri, 08 Dec 2023 02:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702033144; x=1702637944; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7HVfrfjaK5m5b1/OV3mRGN/mUkV29WUyz/fM9Vgyw1c=;
        b=BNDpbyxdzm2mvUtueWlky56nJo62vOeV/XAVaXcuWqVI1htqNaKS5YIs6zA9jay7Np
         HbjxUvus0yXWGa196XG0t022vz5XFMgBHWVM/26Q9Nj2bK4SqDRc8z+p7o2Fa0v7EZg3
         BVg3W1ayhmZHQKXTcfa/spd91wYSrrCCnkZNh+NfeZyne+YGrFRpNFc8c/4y13Kdv1n0
         wjlGv3Ngyg/ePc790CZJJ099kj1VhCQ8/yZSFGP/cI/rKpjhBZ1dlkHv2WasIsP9ap88
         76kQWQ7kjcLVWr3Zk73t5V96w4ck4hXMYA125men+t56njkvjNQwAsEIJJ35/QUiQXCJ
         sqYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702033144; x=1702637944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7HVfrfjaK5m5b1/OV3mRGN/mUkV29WUyz/fM9Vgyw1c=;
        b=THklFQwdrTeQcKzPsGAAhzzjzVG5ID+tp+Tn5SkfAtAl/V2hmVuSIHczpAu5/6d7Jk
         C2te7VmQS5bvMZlGH3+qRP4dH72YJPYetBCcVNEI+2cACT9stAUUWv40Fik0ztL2/Ny5
         cXnVJfd0vlZfavzToqCPH9FOQ+grRhcmk/zXFBGpbw/QHgCQhKj8XrQh9GiSZp9VA0uh
         kyqISdnKCvj7cX8OBu1WnnhU088X67lYsseIQytIo8GIuykZxb9tMc99TgV2xsAWhKaV
         M4fID3+zSt+xP7gD/qSLdHTrWFp8ubJBUycYnCQmX1BbGUN/Fl3s5SCX05T6DejW7Ktn
         YKTw==
X-Gm-Message-State: AOJu0Yx/J/c/46+13RdeFM21puBmz2A5gYHINUxBuU4Es/Hstr0UzSfg
	OPOJ3kasXg8j6yuns8LTaPZXbRUK+MadJ85Wokk4qW9y
X-Google-Smtp-Source: AGHT+IFJeLR7OjvBNjU6SJ0L1Bm9fBNUbKK3jcayqSvkZdd1uZZ62KddiAM1WUQBN+oCBUtlGzUtrpOFWf4t4rpw86M=
X-Received: by 2002:a2e:9416:0:b0:2ca:1e6a:923c with SMTP id
 i22-20020a2e9416000000b002ca1e6a923cmr2309647ljh.36.1702033144106; Fri, 08
 Dec 2023 02:59:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231204045632.72226-1-meetakshisetiyaoss@gmail.com>
 <65d6d76197069e56b472bbfead425913@manguebit.com> <CANT5p=qnEFJDTTrSRkdBfkE9Kzw9BzGRegtCuW6Hb4xc7PSdaQ@mail.gmail.com>
 <9980a249-043c-4140-a5ee-bc06cf156747@talpey.com>
In-Reply-To: <9980a249-043c-4140-a5ee-bc06cf156747@talpey.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 8 Dec 2023 16:28:52 +0530
Message-ID: <CANT5p=p0Fk5j73Hu50DeywQdBSffKo8TNvZhSjQaj+-LtrNOTA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Reuse file lease key in compound operations
To: Tom Talpey <tom@talpey.com>
Cc: Paulo Alcantara <pc@manguebit.com>, meetakshisetiyaoss@gmail.com, 
	linux-cifs@vger.kernel.org, smfrench@gmail.com, bharathsm.hsk@gmail.com, 
	lsahlber@redhat.com, Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 6, 2023 at 7:12=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote:
>
> On 12/6/2023 12:31 AM, Shyam Prasad N wrote:
> > On Wed, Dec 6, 2023 at 1:02=E2=80=AFAM Paulo Alcantara <pc@manguebit.co=
m> wrote:
> >>
> >> meetakshisetiyaoss@gmail.com writes:
> >>
> >>> From: Meetakshi Setiya <msetiya@microsoft.com>
> >>>
> >>> Lock contention during unlink operation causes cifs lease break ack
> >>> worker thread to block and delay sending lease break acks to server.
> >>> This case occurs when multiple threads perform unlink, write and leas=
e
> >>> break acks on the same file. Thhis patch fixes the problem by reusing
> >>> the existing lease keys for rename, unlink and set path size compound
> >>> operations so that the client does not break its own lease.
> >>>
> >>> Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
> >>> ---
> >>>   fs/smb/client/cifsglob.h  |  6 ++---
> >>>   fs/smb/client/cifsproto.h |  8 +++----
> >>>   fs/smb/client/cifssmb.c   |  6 ++---
> >>>   fs/smb/client/inode.c     | 12 +++++-----
> >>>   fs/smb/client/smb2inode.c | 49 +++++++++++++++++++++++++-----------=
---
> >>>   fs/smb/client/smb2proto.h |  8 +++----
> >>>   6 files changed, 51 insertions(+), 38 deletions(-)
> >>
> >> NAK.  This patch broke some xfstests.
> >>
> >> Consider this reproducer:
> >>
> >> $ cat repro.sh
> >> #!/bin/sh
> >>
> >> umount /mnt/1 &>/dev/null
> >> mount.cifs //srv/share /mnt/1 -o ...,vers=3D3.1.1
> >> rm /mnt/1/* &>/dev/null
> >> pushd /mnt/1 >/dev/null
> >> touch foo
> >> ln -v foo bar
> >> rm -v bar
> >> popd >/dev/null
> >> umount /mnt/1 &>/dev/null
> >> $ ./repro.sh
> >> 'bar' =3D> 'foo'
> >> rm: cannot remove 'bar': Invalid argument
> >>
> >> This is what going on
> >>
> >> - client creates 'foo' with RHW lease granted.
> >> - client creates hardlink file 'bar'.
> >>
> >> At this point, we have two positive dentries (foo & bar) which share
> >> same inode.
> >>
> >> - The client then attempts to remove 'bar' by re-using lease key from
> >> 'foo' through compound request CREATE(DELETE)+CLOSE, which fails with
> >> STATUS_INVALID_PARAMETER.
> >
> > That's interesting. I'm assuming that the STATUS_INVALID_PARAMETER is
> > due to the server not recognizing the lease id for the file bar.
> > I'm not sure that this is a client bug.
> > If the server supports hard links, then should it not be aware that
> > foo and bar are the same files? AFAIK, file lease is associated with a
> > file, and not the dentry.
>
> Lease keys are tied to the _filename_, including the full path. They
> are basically guid's, and are used as lookup keys in the lease list,
> from which the lease itself is the resulting value. The value is then
> inspected for a match to the filename for which it was created.
> They are not about the _handle_, which is what is apparently being
> assumed here.
>
> MS-SMB2 section 3.3.5.9.8 says this, which the server in question is
> correctly enforcing [emphasis added]:
>
> > The server MUST attempt to locate a Lease by performing a lookup in the=
 LeaseTable.LeaseList
> > using the LeaseKey in the SMB2_CREATE_REQUEST_LEASE as the lookup key. =
If a lease is found,
> > Lease.FileDeleteOnClose is FALSE, and *Lease.Filename does not match th=
e file name* for the
> > incoming request, the request MUST be failed with STATUS_INVALID_PARAME=
TER
>
> IOW, hard links are, from a protocol leasing standpoint, not the
> same "file".

This is interesting. I would assume that leases are a mechanism that
assure client that it is free to cache the file locally, and that the
server would inform the client when that is not safe anymore.
Hard links are in-fact pointing to the same file. So I would've
assumed that the server would have treated both links to have the same
lease.
So either the server should share leases between hard links.
If not, at least an existing RWH lease on link1 would be broken by RWH
lease requested by another client on link2. At least for the Windows
file server, that does not happen either.
Isn't this a bug from the correctness stand point?

>
> Tom.
>
>
> > Meetakshi, can you please follow the repro steps provided by Paulo
> > (against Windows file server) and check why the invalid parameter
> > error is being returned?
> >



--=20
Regards,
Shyam
