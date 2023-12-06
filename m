Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fsH0+dtE"
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029A518F
	for <linux-cifs@vger.kernel.org>; Tue,  5 Dec 2023 21:38:43 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-54ca339ae7aso4523650a12.3
        for <linux-cifs@vger.kernel.org>; Tue, 05 Dec 2023 21:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701841121; x=1702445921; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DZHHAnZbLzWC36gsOmhniC8vWZUquQBdTXahMRwelIQ=;
        b=fsH0+dtElEKCfl7CQGcMO/sXeEEF+sqSRwI2oqqLfYQht2E/QyhIg05XWeKi7Q34gp
         GgX2dpRRZO/33OgNK4HXVEbpEyUCx45xqhjWKRMxM0x0vk3duEHkbsO8cFDBRLHzR8F2
         mHVypBoWO3f9oG3+zzEW/eKd82/QH+AcVB03ZyA7AXuFqCOmzqQDMe1fsjCaNZ+C/Fnp
         tRuZI73EjRmICHIGUzGHr+vzuj48AaIWDHRSH6fjwbQvgo/IDO0KkmdJLx7dZuzQEQlA
         8iJYCWwqnLxqjvXJgkNzil7ZpUAX6Ew6igsAfx2ixPBGEtGOT+QfkqOPulvT2/p2e9wD
         nsnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701841121; x=1702445921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DZHHAnZbLzWC36gsOmhniC8vWZUquQBdTXahMRwelIQ=;
        b=uEu/+V8jmIEN63+5Askfx1sStAqBjwfOifk4+tM9u0C5ny1jazj2WwWBWCYpoozPjW
         9C4jNDxNU71Wu91pKs5MmMxxMBvrU8zZLavAjXoCPvELzMIQJlArMJgWrrt/vX+0x5iT
         qR7ncIgbKjZCY1wj89Sl6XMUrhj7VoBjldlWE7D0Gzw6pzS1kHDHPDRpYYt1Y/0Vcq9T
         U04vxAOBoBMJJfbUp4tBGNnlWfy3LazER6pZwt8CDi5WLHPNCN5kANCFCpP9i37P/PfF
         SEGYmhFgLeSj4BKd3iroAT7Dm8Y97zewv8JNNRpiZNGTc3OoyzhPI/Rh9D8uOpm/SjHW
         4+Ow==
X-Gm-Message-State: AOJu0Ywe/6HAywUb3uQh4xTSC+PlcCuR4xbIfH/vU1MvDHNA47xWqzke
	6pRcqtwSgRAna+z9Q4/MMArZxFPel9pUkZGqux0=
X-Google-Smtp-Source: AGHT+IFbpluZLeEgnYXNlRWIBr8AO6mjMlx0NCFRoVrlWDDv/8VI6mMmqbyTiThDe6vQGoi0mZsbW7kPwMZXNImXvgI=
X-Received: by 2002:a17:906:590b:b0:a18:db59:d060 with SMTP id
 h11-20020a170906590b00b00a18db59d060mr199153ejq.66.1701841121268; Tue, 05 Dec
 2023 21:38:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231204045632.72226-1-meetakshisetiyaoss@gmail.com>
 <65d6d76197069e56b472bbfead425913@manguebit.com> <CANT5p=qnEFJDTTrSRkdBfkE9Kzw9BzGRegtCuW6Hb4xc7PSdaQ@mail.gmail.com>
In-Reply-To: <CANT5p=qnEFJDTTrSRkdBfkE9Kzw9BzGRegtCuW6Hb4xc7PSdaQ@mail.gmail.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Wed, 6 Dec 2023 11:08:28 +0530
Message-ID: <CAFTVevUZpqjr5Swvfe6SDfpfJxLdtUOV3-awav-cmwQM+KtR8A@mail.gmail.com>
Subject: Re: [PATCH] cifs: Reuse file lease key in compound operations
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org, smfrench@gmail.com, 
	bharathsm.hsk@gmail.com, lsahlber@redhat.com, tom@talpey.com, 
	Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I will check and get back to you.
---
Thanks
Meetakshi


On Wed, Dec 6, 2023 at 11:02=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Wed, Dec 6, 2023 at 1:02=E2=80=AFAM Paulo Alcantara <pc@manguebit.com>=
 wrote:
> >
> > meetakshisetiyaoss@gmail.com writes:
> >
> > > From: Meetakshi Setiya <msetiya@microsoft.com>
> > >
> > > Lock contention during unlink operation causes cifs lease break ack
> > > worker thread to block and delay sending lease break acks to server.
> > > This case occurs when multiple threads perform unlink, write and leas=
e
> > > break acks on the same file. Thhis patch fixes the problem by reusing
> > > the existing lease keys for rename, unlink and set path size compound
> > > operations so that the client does not break its own lease.
> > >
> > > Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
> > > ---
> > >  fs/smb/client/cifsglob.h  |  6 ++---
> > >  fs/smb/client/cifsproto.h |  8 +++----
> > >  fs/smb/client/cifssmb.c   |  6 ++---
> > >  fs/smb/client/inode.c     | 12 +++++-----
> > >  fs/smb/client/smb2inode.c | 49 +++++++++++++++++++++++++------------=
--
> > >  fs/smb/client/smb2proto.h |  8 +++----
> > >  6 files changed, 51 insertions(+), 38 deletions(-)
> >
> > NAK.  This patch broke some xfstests.
> >
> > Consider this reproducer:
> >
> > $ cat repro.sh
> > #!/bin/sh
> >
> > umount /mnt/1 &>/dev/null
> > mount.cifs //srv/share /mnt/1 -o ...,vers=3D3.1.1
> > rm /mnt/1/* &>/dev/null
> > pushd /mnt/1 >/dev/null
> > touch foo
> > ln -v foo bar
> > rm -v bar
> > popd >/dev/null
> > umount /mnt/1 &>/dev/null
> > $ ./repro.sh
> > 'bar' =3D> 'foo'
> > rm: cannot remove 'bar': Invalid argument
> >
> > This is what going on
> >
> > - client creates 'foo' with RHW lease granted.
> > - client creates hardlink file 'bar'.
> >
> > At this point, we have two positive dentries (foo & bar) which share
> > same inode.
> >
> > - The client then attempts to remove 'bar' by re-using lease key from
> > 'foo' through compound request CREATE(DELETE)+CLOSE, which fails with
> > STATUS_INVALID_PARAMETER.
>
> That's interesting. I'm assuming that the STATUS_INVALID_PARAMETER is
> due to the server not recognizing the lease id for the file bar.
> I'm not sure that this is a client bug.
> If the server supports hard links, then should it not be aware that
> foo and bar are the same files? AFAIK, file lease is associated with a
> file, and not the dentry.
> Meetakshi, can you please follow the repro steps provided by Paulo
> (against Windows file server) and check why the invalid parameter
> error is being returned?
>
> --
> Regards,
> Shyam
