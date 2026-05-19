Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231CE4028F2
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 16:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779207305; cv=pass; b=QEINtXN3hqe1PPhrVTPppCpc0KMKGZuLhm/2KAwHmUENDgKN6Py/ZEW9keeFNh0/Q6+EJJEb1NOIP8WD5QpjwiOLhNYrNulqC2x989cAJ9U+XTc2tICgVhYJvnaCxklLqxKPhDn+YxpZTS5GSaBRb+uGSWx5uv+otLx8Pxd/Vyk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779207305; c=relaxed/simple;
	bh=M19ecEq181d0lWpWZfe0ke/wSg8ZTAqB73agVI91OZo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=upO556Nrz+uqFH90UG0QMx6Ll7xgRmU0DY9TvI/em14El0AUlX2RTjmcuHH/6jh0XpBaLBcLQqpZpLXZDatxndQU3HLNG75eqEbQCKVlPgtXw4BGkz+zczrRZTohfBDQ9xxXXUi4bmDDuFhGbY3aKpIp6Pr0dBdW7C6vzse7pjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FmEl72D4; arc=pass smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FmEl72D4"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8ca12973e15so53359396d6.1
        for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 09:15:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779207303; cv=none;
        d=google.com; s=arc-20240605;
        b=TZZnyR7BgH3wShgKsdZI+qRpzHuxQH8t/lupVD0gHQDnBEQddR8gOXIRuC/pACeY1H
         XtyyAnuUzrVHSbchhPYZP5lt2wteptFnFzQgsOxDxY4nx5aP66kylBl8GpoIpNCdKyI3
         eyEZUndppzNo9vYeLMmkbMDs2lKaEXnm6TQdXJuAp6TFimUz0zYtBqqdNzSM1/1E5dIw
         qxVX+ZvDkLIwYTbWoUCrcVF7m0YGwE5Gv+zBltzq+DMpHX9LoA1IS7x133EFz96LU5/q
         oN9e0zVPokv6LBb01hh867VRpy/WtrTPUCLMIdYCzS4kdyA1Weip7QeIMy/RcjDf9vW4
         P7EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MlmKO+KgXdmfWlNEoc3g93qF118MH+EY2qs+xmOSe58=;
        fh=KG7jhd5vb8hnKnkaE5qcrRhcfMn2ul768AHzhI/p6FM=;
        b=NNfsApaQ+Dlh59DT0ajT3NZZOCCFE3KKRVo6/QfuaI54908XeIZ5N/PV0z2p2imB0f
         rqpE5HvjuY3pcpJebf2VNLsg4b2btlX94pTs8L88T6Ciwpkm35IDQGRDMJ6EvogFKEWW
         Eikvzppql5BEXLRF85cfseJC4C6h2Cm1cbOIpBHHKvNWkps0nruMeeAt0wYP1Z6oxN09
         kS1pul/RHtUg8h9tLnzX1C9nVZ/Alqt3wUVZy6g/KVAaLc7P06p7lRCjovt2weUnxLie
         vpVB7fo9t1cPFdUbx6STtXSGftqG7tJLn1bG6KqHRQt0I8N8TkBvcwexUqEYvGzoIKmT
         +Bdg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779207303; x=1779812103; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MlmKO+KgXdmfWlNEoc3g93qF118MH+EY2qs+xmOSe58=;
        b=FmEl72D4MI+etR+yHbhkhlpRC7vrLIIIsz9T2TR8hYzP0gcWcB9gMNUivwr8+jTy+s
         HrqMDtclxSZt/c/JIYuRXQBtSMciDV583bLHE53+4am54Pv12hDk5TH8oZvciAuQ5dbt
         hfkwv9oabZD5UlWEcArX6h50dNNJVrvAH46FRonciT+YNdt4e5Q41IqNGZ47ftI8vWji
         brKqtAQd4hoGXAfMq5ZLzB8miuY3VtQtczpksPyDtu4VLJj5pDzQnTGNaRtwLFXL2sBu
         gVNGTfqFvlt3NjdbEvuOnJdZwd1IUo5BmSxocEDj7UJ9Og2Oddys+kAs7V5yhVrJq/Y0
         04VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779207303; x=1779812103;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MlmKO+KgXdmfWlNEoc3g93qF118MH+EY2qs+xmOSe58=;
        b=HNoY5iFWPms5uqXkjcYB0CBmvMDNsu06Yc2+R4tYJWWxbzIQ2f+W2iFksQohZH0HyX
         Tpsrv5cA9UMhrt98hDZTSqskZZ/A8i8lPxfEF6JyQE4BOHBkIrD+uUQR7u2yqRtqFUG1
         Lk9QgGSqUCyvUQvd4LAdwGioOD5dFrgybBdmRvI8oA/XXZDZlOpapbdBphqrvO8Z2/Vh
         XcCT8ijxAGN0BQW1tiM80yOPPv+gtuFFbe1zmjuSVfuvvYGWlXZpoD9vYmqQCgyPOsLk
         1cABGCH5cpIz5f8HFPpL57F4z5FIjqZSSpJtEqzFEvy+zCwd5tMVKVGi9yasKleVsJHA
         3wTA==
X-Forwarded-Encrypted: i=1; AFNElJ+iVA6DyT5XQXoY1RWDFNl3TwGlwenIhy8wALlC/o6/qEK19Vy9PKLF5R4NngOTLxFWRHwnyMnodQk3@vger.kernel.org
X-Gm-Message-State: AOJu0YyqkA3EeiJNOGpvjs4elfi6/a+kf7DP0D/RpEiqe/S/30MQW7e3
	hWBnmyqLG2Y5hnWaZPIz9t5+5u/fFHrJW7ywkyeJ3bhzO/SkV2A2Mn5ms+SJgmASVJbtCRYbioW
	FjO4NzGKkcUOqrUpzlg5Bnja5MPKMbw8=
X-Gm-Gg: Acq92OEQ4csE70Ad2ECpgzVMI9G2MkyKSzfiS31bP6I9ySAgFhunrmc+BoUq0nDvZSy
	NRhbjBFIsb6RzuN0076sA2WwQIYaPRR0LA3a246LNkTwT1AdyDUbJ+Wbr/KZK3D5u6E1kZGzlW4
	pY7DK2MuSD+iT2Euo3uYHmPIYQcmVq1TW82/Z4qafAHLlFq9jzYz4Cnw+mQL2o31R0W6VXngCbO
	toMkBOmhnOa6UJgeZes44A1x81bJkUFucHh815dSCgnmg2NUIIonKGk1/iqsq1np1JF9Z8CMU12
	vBDnc8GsdFS0aGw4iJWaYKxu3eZ3uFCJuW8a3Kw2MLwXs3ie8LMMA4JcQF19n1UKMTNhH5ZKbjg
	1OH4sLWOfObdaon3rRKvS0zAF9AUdgGm7QJV1b1vKDqw8Nqj9OLGv8lIzhs3fBhJPlgiEdE9Xj+
	REwzKRuOMVJNRo+wJs5XIN0w==
X-Received: by 2002:a05:6214:4a90:b0:8ca:1e34:5b9a with SMTP id
 6a1803df08f44-8ca1e34631fmr264705426d6.15.1779207302645; Tue, 19 May 2026
 09:15:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260519091805.220902-1-chengzhihao1@huawei.com> <CAH2r5mtBdyNOqYQEFicOv9P-PAVc23jxK2cw4D7zjLKwmCpNRg@mail.gmail.com>
In-Reply-To: <CAH2r5mtBdyNOqYQEFicOv9P-PAVc23jxK2cw4D7zjLKwmCpNRg@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 19 May 2026 11:14:49 -0500
X-Gm-Features: AVHnY4IYxCB-wfh-tkFL0wGQ9QPsH671Bem3n9VBb-4A7b2rtprPZz9AUJuqo00
Message-ID: <CAH2r5muvSrnnsq7rO-kHP==WgTmoO3VqZJvazf3HrddwDTU7zA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix busy dentry used after unmounting
To: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: sprasad@microsoft.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	yangerkun@huawei.com, yi.zhang@huawei.com, wozizhi@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Also added Cc: stable

On Tue, May 19, 2026 at 11:13=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> merged into cifs-2.6.git for-next
>
> Sashiko had some followup patch ideas, but it looks like no changes to
> this patch needed:
> https://sashiko.dev/#/patchset/20260519091805.220902-1-chengzhihao1%40hua=
wei.com
>
> On Tue, May 19, 2026 at 4:28=E2=80=AFAM Zhihao Cheng <chengzhihao1@huawei=
.com> wrote:
> >
> > Since commit 340cea84f691c ("cifs: open files should not hold ref on
> > superblock"), cifs file only holds the dentry ref_cnt, the cifs file
> > close work(cfile->deferred) could be executed after unmounting, which
> > will trigger a warning in generic_shutdown_super:
> >  BUG: Dentry 00000000a14a6845{i=3Dc,n=3Dfile}  still in use (1) [unmoun=
t of
> >  cifs cifs]
> >
> > The detailed processs is:
> >    process A           process B           kworker
> >  fd =3D open(PATH)
> >   vfs_open
> >    file->__f_path =3D *path // dentry->d_lockref.count =3D 1
> >    cifs_open
> >     cifs_new_fileinfo
> >      cfile->dentry =3D dget(dentry) // dentry->d_lockref.count =3D 2
> >  close(fd)
> >   __fput
> >   cifs_close
> >    queue_delayed_work(deferredclose_wq, cfile->deferred)
> >   dput(dentry) // dentry->d_lockref.count =3D 1
> >                                          smb2_deferred_work_close
> >                                           _cifsFileInfo_put
> >                                            list_del(&cifs_file->flist)
> >                     umount
> >                      cleanup_mnt
> >                       deactivate_super
> >                        cifs_kill_sb
> >                         cifs_close_all_deferred_files_sb
> >                          cifs_close_all_deferred_files
> >                           // cannot find cfile, skip _cifsFileInfo_put
> >                         kill_anon_super
> >                          generic_shutdown_super
> >                           shrink_dcache_for_umount
> >                            umount_check
> >                             WARN ! // dentry->d_lockref.count =3D 1
> >                                            cifsFileInfo_put_final
> >                                             dput(cifs_file->dentry)
> >                                             // dentry->d_lockref.count =
=3D 0
> >
> > Fix it by flushing 'deferredclose_wq' before calling kill_anon_super.
> >
> > Fetch a reproducer in https://bugzilla.kernel.org/show_bug.cgi?id=3D221=
548.
> >
> > Fixes: 340cea84f691c ("cifs: open files should not hold ref on superblo=
ck")
> > Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> > ---
> >  fs/smb/client/cifsfs.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> > index f557eb7875c7..ce23924f01b3 100644
> > --- a/fs/smb/client/cifsfs.c
> > +++ b/fs/smb/client/cifsfs.c
> > @@ -306,6 +306,8 @@ static void cifs_kill_sb(struct super_block *sb)
> >
> >                 /* Wait for all pending oplock breaks to complete */
> >                 flush_workqueue(cifsoplockd_wq);
> > +               /* Wait for all opened files to release */
> > +               flush_workqueue(deferredclose_wq);
> >
> >                 /* finally release root dentry */
> >                 dput(cifs_sb->root);
> > --
> > 2.52.0
> >
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
