Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D066225D6
	for <linux-cifs@vger.kernel.org>; Thu,  3 Jul 2025 05:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751522150; cv=none; b=m0i6FLoOhw9I9tuBL7+E9Gk9hBK3F+KY3wuRf4Mi+H3HI8/sRLCXmyjAj6CSEDeLnrd5OXyKYoOFWYEJxgjdlGuHyfg42s+hCX5hQ2EaDjfIV1e0r0+P5zI+Pr/ZEQlSFin1eVvcKZRKFzYxT9aCeF+gwk0vlh5DucD+z4nMrlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751522150; c=relaxed/simple;
	bh=PbE+qbZiKwq0rVmll6vK+WE6V3yKlCGLHzv/dW/jJtQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OKzXTEtichygkF3x1oAk8EJEqQKXPLwyssRjM1QTIqAEZZIpadpVDs90Ob7W6MZZM0YdspJhFjLkeorA6saHhgklAoI20lSCOYLRh9TvnKyZ2f5CI+1xY/LjqWsfxjVw/14Veiq289KkhSl0xYbBZ+WSM75+rcifHL2w3ZV8Jbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K/PWwyJE; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K/PWwyJE"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6fad3400ea3so71053786d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 02 Jul 2025 22:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751522148; x=1752126948; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SBNlMuDNba6i9HYJ6d6wpJTQgAKiEB0KEtUy7hMrlD0=;
        b=K/PWwyJEQaAsyQWfCrROwdN9c9lGq+RftsWQbZLfzISa98BJuK3+/qB1vE50pYZkuS
         fLYPn0hveEr94Wy7IYMIWu5lUWpblcfz63wi1XCkcObm2LsZn2sS5pyDaaB2IfuveNb7
         8zevLIbZuAJ9NqgZs9Cxl2npIM6rnptviPHxsNb4uki06a3eMl5rOJqpNZZJzazh5QB+
         4uWvapLpfUY70hX6O1ZdYyfBvoPtgbrZ4Fo6FPDjgIVy7fkZRwDb5IlreH07Xsj3bZlE
         OKGvXrdtxT3v9qlfp2Dhm3gZoAi2GYqmYyep0zPegtnaraLqidUAX3En4Q3S+zhIL7bK
         QM1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751522148; x=1752126948;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SBNlMuDNba6i9HYJ6d6wpJTQgAKiEB0KEtUy7hMrlD0=;
        b=a2RGYKaM//L8l+qypBi7qf7VFzFfMyd4vvGvCS3rZoSqP3IVfDngNUY4/Q7rwdMU+v
         Rb36qh4vcM3PJwFTaqGjMMG73wrQi6McBL+mtJ7NSew69BK67nUclfWxWuB1l9yg5sPR
         QnEvxVtwVP6seywonkeXOlN8a3RNHAG3LBVMZUuNda11BIPv/cvx0qJ8TmFez/XzVItk
         CFzTXxkeFqlUtFS4DVq9oNdhJxDDpDliH9KE1s0KFJqzvpt/u3OzKWAsgBAqTcE62tad
         7k7Wm6hE/bd1SGvCBaTlAeQN0zs/gqxwoJ7KJWQSwUNxTf0KfdLXrNHOm7FcWg28AA6i
         pWPg==
X-Forwarded-Encrypted: i=1; AJvYcCXr/eCxC78Dhrygkn5B1qHlu+Gn4mWX7uT2RFr7SlATVzSYiU7d8T1lAZqHBNkbShlZwlyfJxrc2ddo@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9wzUxSASwTFbk9G+ov3QBGBbddPiOL2Xinw3wTzWVRNZbeBG8
	XmZ2RCLXwk6olKw5XZB+vQXyzY4SrDyGhS7P5Y1/3cgiwxefyITQAzxahCutTgp/zli6zrYpd5o
	T9ly2ZE11h4iU+jBpoU8MBYAwMyofH3k=
X-Gm-Gg: ASbGncs98qESLDwxf6V3AWjMSS0kNG8u6rz1FqcbPAAlksEhguz7gX9kpE/ShD0tS0F
	5XDH5U9DaHZs3wUsSvGcUnEHEeeA9jbSNwqqIgE+U8nchkmJlV24oT7mHYkm2v0vPj4I8OQcgVS
	zd0xs3vRAiQH0l26SnKyffFcA3AeJc1AZHxtluQiwrVb/PdbyV/KvyN/kO/LMYtBx8bXXn0/Dvi
	5tMAkhC9JE3HRA=
X-Google-Smtp-Source: AGHT+IGZj/bWOL2X9V/hMPO7V/8iU0gQu88SCBuNXe2wBxSuRrCZ4LOLUoFZrdT3PerJcuqYBKzkaua8EdtI17+KVGU=
X-Received: by 2002:a05:6214:5710:b0:701:9a6:9307 with SMTP id
 6a1803df08f44-702b1a6b820mr87297026d6.11.1751522147654; Wed, 02 Jul 2025
 22:55:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250630185303.12087-1-bharathsm@microsoft.com>
 <aGVkk8LT_RSwElO1@precision> <6cgznwvt25gpa2h4oxiefz2t6hrzdvhxi2ywqd6deje7bfjnws@tuzdojjvyflf>
In-Reply-To: <6cgznwvt25gpa2h4oxiefz2t6hrzdvhxi2ywqd6deje7bfjnws@tuzdojjvyflf>
From: Steve French <smfrench@gmail.com>
Date: Thu, 3 Jul 2025 00:55:36 -0500
X-Gm-Features: Ac12FXyebNZA854sE3Qp-wt9FXvTeZZkeJCrAuxBbt0ViMb1UudQUfhOCMdFUZo
Message-ID: <CAH2r5mtzXBgksfoJauUDiZgRGfrp9D9wVOcH21BiD_wH-jfpjQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] smb: invalidate and close cached directory when
 creating child entries
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>, Bharath SM <bharathsm.hsk@gmail.com>, 
	linux-cifs@vger.kernel.org, pc@manguebit.com, sprasad@microsoft.com, 
	paul@darkrain42.org, Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I tried a simple experiment with this patch, and it did fix the
problem where the new file did not show up in the cached directory
until lease expires, but I am very concerned because it added 50
percent more roundtrips for a simple example (see below - went from 12
to 18).

root@smfrench-ThinkPad-P52:/home/smfrench/cifs-2.6/fs/smb# ls
/mnt/scratch ; ls /mnt/scratch/dir1 ;  touch /mnt/scratch/dir1/filenew
; ls /mnt/scratch/dir1 ; sleep 2 ; stat /mnt/scratch ; stat
/mnt/scratch/dir1

The problem is that instead of just invalidating the directory
contents, the patch is closing the dir1 in this example but this also
strangely causes the "stat of /mnt/scratch" ie the parent directory to
not use the lease either.  If the directory is left open, and the
lease held, but just the use of the dir contents invalidated, then we
could simply do the querydir, not the extra open, and it would also
likely fix the strange extra query info on the parent directory that
the patch causes in the example I used.

The 50% extra roundtrips concern me

On Wed, Jul 2, 2025 at 3:31=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de> =
wrote:
>
> On 07/02, Henrique Carvalho wrote:
> >Hi Bharath,
> >
> >On Tue, Jul 01, 2025 at 12:23:03AM +0530, Bharath SM wrote:
> >> @@ -190,6 +190,7 @@ static int cifs_do_create(struct inode *inode, str=
uct dentry *direntry, unsigned
> >>      int disposition;
> >>      struct TCP_Server_Info *server =3D tcon->ses->server;
> >>      struct cifs_open_parms oparms;
> >> +    struct cached_fid *parent_cfid =3D NULL;
> >>      int rdwr_for_fscache =3D 0;
> >>      __le32 lease_flags =3D 0;
> >>
> >> @@ -313,10 +314,10 @@ static int cifs_do_create(struct inode *inode, s=
truct dentry *direntry, unsigned
> >>      if (!tcon->unix_ext && (mode & S_IWUGO) =3D=3D 0)
> >>              create_options |=3D CREATE_OPTION_READONLY;
> >>
> >> +
> >>  retry_open:
> >>      if (tcon->cfids && direntry->d_parent && server->dialect >=3D SMB=
30_PROT_ID) {
> >> -            struct cached_fid *parent_cfid;
> >> -
> >> +            parent_cfid =3D NULL;
> >
> >I believe setting to NULL here is unnecessary, no?
>
> It's for the cases it loops back to retry_open.
>
> >>              spin_lock(&tcon->cfids->cfid_list_lock);
> >>              list_for_each_entry(parent_cfid, &tcon->cfids->entries, e=
ntry) {
> >>                      if (parent_cfid->dentry =3D=3D direntry->d_parent=
) {
> >> @@ -327,6 +328,7 @@ static int cifs_do_create(struct inode *inode, str=
uct dentry *direntry, unsigned
> >>                                      memcpy(fid->parent_lease_key,
> >>                                             parent_cfid->fid.lease_key=
,
> >>                                             SMB2_LEASE_KEY_SIZE);
> >> +                                    parent_cfid->dirents.is_valid =3D=
 false;
> >
> >Shouldn't we set dirents.is_valid to false only after the open is
> >successful?
>
> Agreed.  Even though the most common failure cases will trigger a
> reconnect anyway (i.e. cache invalidation), it makes sense to keep the
> cache for the other cases.
>
> Also, open_cached_dir_by_dentry() gets a cfid ref, why not use it and
> have ->has_lease and ->time checked on success?  It would also look
> cleaner.
>
> Also 2: ->dirents should be accessed locked with its mutex, otherwise
> there's a risk of race with cifs_readdir() and potentially UAF on the
> close_cached_dir() below.
>
> >>                              }
> >>                              break;
> >>                      }
> >> @@ -355,6 +357,10 @@ static int cifs_do_create(struct inode *inode, st=
ruct dentry *direntry, unsigned
> >>              }
> >>              goto out;
> >>      }
> >> +
> >> +    if (parent_cfid && !parent_cfid->dirents.is_valid)
> >> +            close_cached_dir(parent_cfid);
> >> +
> >>      if (rdwr_for_fscache =3D=3D 2)
> >>              cifs_invalidate_cache(inode, FSCACHE_INVAL_DIO_WRITE);
> >>
> >
> >Apart from the above,
> >
> >Reviewed-by: Henrique Carvalho <henrique.carvalho@suse.com>
>
>
> Cheers,
>
> Enzo



--=20
Thanks,

Steve
