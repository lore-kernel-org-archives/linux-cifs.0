Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC252913
	for <linux-cifs@vger.kernel.org>; Sun, 19 Jan 2025 07:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737271008; cv=none; b=RVL4gnpAyizzJzji+CRh8/ktb8pufzMdVHdCaZjdfK2zCiuU6By2/TIk0EmGK8dhs1N0H24ehGVL11FNTyIUSahUrajFXT9WRUA0+cwQU0pC3ffqc1+cpTauozRMiVMEpiGizobdDwvF27JYiav9xHjPjs1nVPtssIZUPkFG6zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737271008; c=relaxed/simple;
	bh=/VckZPvDvwqYJ1StGd4rWuAXpDnWf1+eP7GDCo5N8BU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i3woFGdaMqBCOQDfkC/5zCW9k/1kZTdUUDWd+HB013yY7RIPlSkgB3dj9gv7wOqwTjEVDcxkIjaZ5BK7K969BfOmS8gVABBHmJIMb4Qwv3GCg6902ij/XNFIDmvdeKksDMUc2C+i+6TfgsuNyEF4fWMQtWmka+wExKT0WDA8+Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c6zntGhw; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c6zntGhw"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-54020b0dcd2so4796240e87.1
        for <linux-cifs@vger.kernel.org>; Sat, 18 Jan 2025 23:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737271004; x=1737875804; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YKoGefYLBfCakV9SRc4K5uOr51Jov+leOy+VVbypqM8=;
        b=c6zntGhwhs5GrgFYMGWCm1ZXdflVEqd9piSdfX4XrosBiEr7PTE+gYlMWVmAqg3gyf
         Z22M/h/GTh6XQvSp1nYcEJnjntOcXlBxXVgbVNybxtVs9LT4Epp2dngH3xCdUk0WDr1P
         ILQN2blJ0GZy9fJRE8W7qQi8gKllvbDyrQDz6vdfzED/1kzXG1fQ/rKkJYf6N0V8zYqT
         IqNs0orq69cY7gMqgO4mafPYQaM2cK+oNncezXMqhqb1LM97Y65x1rGaMCX6PkapsIwq
         cje4Vvt/lDUAp9kyZPEKTXSIonNZ6cRZw1EabVi7N7YFuf/A/QTEFhialJu9SiJH1zKJ
         R9Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737271004; x=1737875804;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YKoGefYLBfCakV9SRc4K5uOr51Jov+leOy+VVbypqM8=;
        b=h6IYa1lis9NpuXjXu9DTDQ1/IV30TeHjuRirEvz/UoiF5ZDr9Gj+5p7l03DpzQMp1W
         RhoKhzZnlbuK56NErinPKyfrs5VURwTZouZ0o7H7meanBRl9xrQsPbtn8hbkab4L+2kN
         dbAnhwMe9zQQ/nqu8CjjKrWMnuEFz/EXWbsFl4tYDc/GkljlCWbZXh2UZ15wMOb+1Jh0
         1DvEUXNY/F7PeKUKtWWhMGeSsdgNxdX1xiFVBN4IHfMIGOMQdQ1G3IfA1eUplNThUqWN
         EQWfSKabycw7MByj7BL4bsCkh0tt3eJWOErF1GaFHm5gQl7nNpLo1CSPDpJNPj6PsFyU
         bMJA==
X-Forwarded-Encrypted: i=1; AJvYcCW5WUJZFO4JugqaJ8BQnufC+Ryrp9Ob3Y4jb1PWhbamO2C++Zsxkejq2tkNoemFbDqj9mH1vUW9ZqoJ@vger.kernel.org
X-Gm-Message-State: AOJu0YwuuKRqzqT98E+HcENoPkai6Jzm1xdvZbxXUpsQP1r3IvSMmlwn
	VftiYf2v4ddyZEFMirHDtVWGuwzVk3L5pxTnBY15vws5/QMxTfkVV87i6y0Ly2WVgZMQZk2Cv6X
	gU9P3hnl4h2fx/Yru7Eyl47La+fF9x8L6
X-Gm-Gg: ASbGncttLosPPDhIgHgnzFZ7ytExID6eTU6avMrMLx9d9+9EAg+x52pCqdobAmGM9c9
	R1aIqKisi3+s1JaXO5K7jU86mjQsFZ5gfNN9AMaZ5FbXo9cBN5yEzpJVkc38Hoq06V6JmJHHSvh
	Wyn+IfpYQ=
X-Google-Smtp-Source: AGHT+IHzPwbT2Y1UgNqoxFkMTkP2QMSD/T0wcbjLzwVI0emDwRR8KxlNzgAXAFa/7x7hmbRbl5kwGUVNV9sSUfBhXX0=
X-Received: by 2002:ac2:4e0d:0:b0:540:20c5:f847 with SMTP id
 2adb3069b0e04-5439bfb75afmr3287788e87.22.1737271003377; Sat, 18 Jan 2025
 23:16:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250118200330.21020-1-devosruben6@gmail.com> <CAH2r5mvMRgiK1jFr3CKJPp1qN2FTBT6NH_M2jRWxjR7p+O5A-w@mail.gmail.com>
In-Reply-To: <CAH2r5mvMRgiK1jFr3CKJPp1qN2FTBT6NH_M2jRWxjR7p+O5A-w@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 19 Jan 2025 01:16:29 -0600
X-Gm-Features: AbW1kvaIVrgKovkZnsrI3G6RGweBJzFdyCY2SnzOs63D7c_P-Z-bJOUSS3z_OK0
Message-ID: <CAH2r5mvU738RRMBpp9vZPXeG4k9ohJB6OJ6U5BoW5Md+pMMUyw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix order of arguments of tracepoints
To: Ruben Devos <devosruben6@gmail.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000090e54062c09ede0"

--000000000000090e54062c09ede0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Here is a minor patch to add the missing tracepoint (see attached).
Let me know if any thoughts, or other obviousb missing tracepoints

    smb3: add missing tracepoint for querying wsl EAs

    We had tracepoints for the return code for querying WSL EAs
    (trace_smb3_query_wsl_ea_compound_err and
    trace_smb3_query_wsl_ea_compound_done) but were missing one for
    trace_smb3_query_wsl_ea_compound_enter.

    Fixes: ea41367b2a60 ("smb: client: introduce SMB2_OP_QUERY_WSL_EA")


On Sat, Jan 18, 2025 at 10:38=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> Good catch.
>
> Looking at your patch, I noticed one trace point was missing from the
> original patch:
>
>          trace_smb3_query_wsl_ea_compound_enter
>
> commit ea41367b2a602f602ea6594fc4a310520dcc64f4
> Author: Paulo Alcantara <pc@manguebit.com>
> Date:   Sun Jan 28 01:12:01 2024 -0300
>
>     smb: client: introduce SMB2_OP_QUERY_WSL_EA
>
> On Sat, Jan 18, 2025 at 2:04=E2=80=AFPM Ruben Devos <devosruben6@gmail.co=
m> wrote:
> >
> > The tracepoints based on smb3_inf_compound_*_class have tcon id and
> > session id swapped around. This results in incorrect output in
> > `trace-cmd report`.
> >
> > Fix the order of arguments to resolve this issue. The trace-cmd output
> > below shows the before and after of the smb3_delete_enter and
> > smb3_delete_done events as an example. The smb3_cmd_* events show the
> > correct session and tcon id for reference.
> >
> > Also fix tracepoint set -> get in the SMB2_OP_GET_REPARSE case.
> >
> > BEFORE:
> > rm-2211  [001] .....  1839.550888: smb3_delete_enter:    xid=3D281 sid=
=3D0x5 tid=3D0x3d path=3D\hello2.txt
> > rm-2211  [001] .....  1839.550894: smb3_cmd_enter:        sid=3D0x1ac00=
0000003d tid=3D0x5 cmd=3D5 mid=3D61
> > rm-2211  [001] .....  1839.550896: smb3_cmd_enter:        sid=3D0x1ac00=
0000003d tid=3D0x5 cmd=3D6 mid=3D62
> > rm-2211  [001] .....  1839.552091: smb3_cmd_done:         sid=3D0x1ac00=
0000003d tid=3D0x5 cmd=3D5 mid=3D61
> > rm-2211  [001] .....  1839.552093: smb3_cmd_done:         sid=3D0x1ac00=
0000003d tid=3D0x5 cmd=3D6 mid=3D62
> > rm-2211  [001] .....  1839.552103: smb3_delete_done:     xid=3D281 sid=
=3D0x5 tid=3D0x3d
> >
> > AFTER:
> > rm-2501  [001] .....  3237.656110: smb3_delete_enter:    xid=3D88 sid=
=3D0x1ac0000000041 tid=3D0x5 path=3D\hello2.txt
> > rm-2501  [001] .....  3237.656122: smb3_cmd_enter:        sid=3D0x1ac00=
00000041 tid=3D0x5 cmd=3D5 mid=3D84
> > rm-2501  [001] .....  3237.656123: smb3_cmd_enter:        sid=3D0x1ac00=
00000041 tid=3D0x5 cmd=3D6 mid=3D85
> > rm-2501  [001] .....  3237.657909: smb3_cmd_done:         sid=3D0x1ac00=
00000041 tid=3D0x5 cmd=3D5 mid=3D84
> > rm-2501  [001] .....  3237.657909: smb3_cmd_done:         sid=3D0x1ac00=
00000041 tid=3D0x5 cmd=3D6 mid=3D85
> > rm-2501  [001] .....  3237.657922: smb3_delete_done:     xid=3D88 sid=
=3D0x1ac0000000041 tid=3D0x5
> >
> > Signed-off-by: Ruben Devos <devosruben6@gmail.com>
> > ---
> >  fs/smb/client/dir.c       |   6 +--
> >  fs/smb/client/smb2inode.c | 108 +++++++++++++++++++-------------------
> >  2 files changed, 57 insertions(+), 57 deletions(-)
> >
> > diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> > index 864b194dbaa0..1822493dd084 100644
> > --- a/fs/smb/client/dir.c
> > +++ b/fs/smb/client/dir.c
> > @@ -627,7 +627,7 @@ int cifs_mknod(struct mnt_idmap *idmap, struct inod=
e *inode,
> >                 goto mknod_out;
> >         }
> >
> > -       trace_smb3_mknod_enter(xid, tcon->ses->Suid, tcon->tid, full_pa=
th);
> > +       trace_smb3_mknod_enter(xid, tcon->tid, tcon->ses->Suid, full_pa=
th);
> >
> >         rc =3D tcon->ses->server->ops->make_node(xid, inode, direntry, =
tcon,
> >                                                full_path, mode,
> > @@ -635,9 +635,9 @@ int cifs_mknod(struct mnt_idmap *idmap, struct inod=
e *inode,
> >
> >  mknod_out:
> >         if (rc)
> > -               trace_smb3_mknod_err(xid,  tcon->ses->Suid, tcon->tid, =
rc);
> > +               trace_smb3_mknod_err(xid,  tcon->tid, tcon->ses->Suid, =
rc);
> >         else
> > -               trace_smb3_mknod_done(xid, tcon->ses->Suid, tcon->tid);
> > +               trace_smb3_mknod_done(xid, tcon->tid, tcon->ses->Suid);
> >
> >         free_dentry_path(page);
> >         free_xid(xid);
> > diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> > index a55f0044d30b..274672755c19 100644
> > --- a/fs/smb/client/smb2inode.c
> > +++ b/fs/smb/client/smb2inode.c
> > @@ -298,8 +298,8 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
> >                                 goto finished;
> >                         }
> >                         num_rqst++;
> > -                       trace_smb3_query_info_compound_enter(xid, ses->=
Suid,
> > -                                                            tcon->tid,=
 full_path);
> > +                       trace_smb3_query_info_compound_enter(xid, tcon-=
>tid,
> > +                                                            ses->Suid,=
 full_path);
> >                         break;
> >                 case SMB2_OP_POSIX_QUERY_INFO:
> >                         rqst[num_rqst].rq_iov =3D &vars->qi_iov;
> > @@ -334,18 +334,18 @@ static int smb2_compound_op(const unsigned int xi=
d, struct cifs_tcon *tcon,
> >                                 goto finished;
> >                         }
> >                         num_rqst++;
> > -                       trace_smb3_posix_query_info_compound_enter(xid,=
 ses->Suid,
> > -                                                                  tcon=
->tid, full_path);
> > +                       trace_smb3_posix_query_info_compound_enter(xid,=
 tcon->tid,
> > +                                                                  ses-=
>Suid, full_path);
> >                         break;
> >                 case SMB2_OP_DELETE:
> > -                       trace_smb3_delete_enter(xid, ses->Suid, tcon->t=
id, full_path);
> > +                       trace_smb3_delete_enter(xid, tcon->tid, ses->Su=
id, full_path);
> >                         break;
> >                 case SMB2_OP_MKDIR:
> >                         /*
> >                          * Directories are created through parameters i=
n the
> >                          * SMB2_open() call.
> >                          */
> > -                       trace_smb3_mkdir_enter(xid, ses->Suid, tcon->ti=
d, full_path);
> > +                       trace_smb3_mkdir_enter(xid, tcon->tid, ses->Sui=
d, full_path);
> >                         break;
> >                 case SMB2_OP_RMDIR:
> >                         rqst[num_rqst].rq_iov =3D &vars->si_iov[0];
> > @@ -363,7 +363,7 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
> >                                 goto finished;
> >                         smb2_set_next_command(tcon, &rqst[num_rqst]);
> >                         smb2_set_related(&rqst[num_rqst++]);
> > -                       trace_smb3_rmdir_enter(xid, ses->Suid, tcon->ti=
d, full_path);
> > +                       trace_smb3_rmdir_enter(xid, tcon->tid, ses->Sui=
d, full_path);
> >                         break;
> >                 case SMB2_OP_SET_EOF:
> >                         rqst[num_rqst].rq_iov =3D &vars->si_iov[0];
> > @@ -398,7 +398,7 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
> >                                 goto finished;
> >                         }
> >                         num_rqst++;
> > -                       trace_smb3_set_eof_enter(xid, ses->Suid, tcon->=
tid, full_path);
> > +                       trace_smb3_set_eof_enter(xid, tcon->tid, ses->S=
uid, full_path);
> >                         break;
> >                 case SMB2_OP_SET_INFO:
> >                         rqst[num_rqst].rq_iov =3D &vars->si_iov[0];
> > @@ -429,8 +429,8 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
> >                                 goto finished;
> >                         }
> >                         num_rqst++;
> > -                       trace_smb3_set_info_compound_enter(xid, ses->Su=
id,
> > -                                                          tcon->tid, f=
ull_path);
> > +                       trace_smb3_set_info_compound_enter(xid, tcon->t=
id,
> > +                                                          ses->Suid, f=
ull_path);
> >                         break;
> >                 case SMB2_OP_RENAME:
> >                         rqst[num_rqst].rq_iov =3D &vars->si_iov[0];
> > @@ -469,7 +469,7 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
> >                                 goto finished;
> >                         }
> >                         num_rqst++;
> > -                       trace_smb3_rename_enter(xid, ses->Suid, tcon->t=
id, full_path);
> > +                       trace_smb3_rename_enter(xid, tcon->tid, ses->Su=
id, full_path);
> >                         break;
> >                 case SMB2_OP_HARDLINK:
> >                         rqst[num_rqst].rq_iov =3D &vars->si_iov[0];
> > @@ -496,7 +496,7 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
> >                                 goto finished;
> >                         smb2_set_next_command(tcon, &rqst[num_rqst]);
> >                         smb2_set_related(&rqst[num_rqst++]);
> > -                       trace_smb3_hardlink_enter(xid, ses->Suid, tcon-=
>tid, full_path);
> > +                       trace_smb3_hardlink_enter(xid, tcon->tid, ses->=
Suid, full_path);
> >                         break;
> >                 case SMB2_OP_SET_REPARSE:
> >                         rqst[num_rqst].rq_iov =3D vars->io_iov;
> > @@ -523,8 +523,8 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
> >                                 goto finished;
> >                         }
> >                         num_rqst++;
> > -                       trace_smb3_set_reparse_compound_enter(xid, ses-=
>Suid,
> > -                                                             tcon->tid=
, full_path);
> > +                       trace_smb3_set_reparse_compound_enter(xid, tcon=
->tid,
> > +                                                             ses->Suid=
, full_path);
> >                         break;
> >                 case SMB2_OP_GET_REPARSE:
> >                         rqst[num_rqst].rq_iov =3D vars->io_iov;
> > @@ -549,8 +549,8 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
> >                                 goto finished;
> >                         }
> >                         num_rqst++;
> > -                       trace_smb3_get_reparse_compound_enter(xid, ses-=
>Suid,
> > -                                                             tcon->tid=
, full_path);
> > +                       trace_smb3_get_reparse_compound_enter(xid, tcon=
->tid,
> > +                                                             ses->Suid=
, full_path);
> >                         break;
> >                 case SMB2_OP_QUERY_WSL_EA:
> >                         rqst[num_rqst].rq_iov =3D &vars->ea_iov;
> > @@ -656,11 +656,11 @@ static int smb2_compound_op(const unsigned int xi=
d, struct cifs_tcon *tcon,
> >                         }
> >                         SMB2_query_info_free(&rqst[num_rqst++]);
> >                         if (rc)
> > -                               trace_smb3_query_info_compound_err(xid,=
  ses->Suid,
> > -                                                                  tcon=
->tid, rc);
> > +                               trace_smb3_query_info_compound_err(xid,=
  tcon->tid,
> > +                                                                  ses-=
>Suid, rc);
> >                         else
> > -                               trace_smb3_query_info_compound_done(xid=
, ses->Suid,
> > -                                                                   tco=
n->tid);
> > +                               trace_smb3_query_info_compound_done(xid=
, tcon->tid,
> > +                                                                   ses=
->Suid);
> >                         break;
> >                 case SMB2_OP_POSIX_QUERY_INFO:
> >                         idata =3D in_iov[i].iov_base;
> > @@ -683,15 +683,15 @@ static int smb2_compound_op(const unsigned int xi=
d, struct cifs_tcon *tcon,
> >
> >                         SMB2_query_info_free(&rqst[num_rqst++]);
> >                         if (rc)
> > -                               trace_smb3_posix_query_info_compound_er=
r(xid,  ses->Suid,
> > -                                                                      =
  tcon->tid, rc);
> > +                               trace_smb3_posix_query_info_compound_er=
r(xid,  tcon->tid,
> > +                                                                      =
  ses->Suid, rc);
> >                         else
> > -                               trace_smb3_posix_query_info_compound_do=
ne(xid, ses->Suid,
> > -                                                                      =
   tcon->tid);
> > +                               trace_smb3_posix_query_info_compound_do=
ne(xid, tcon->tid,
> > +                                                                      =
   ses->Suid);
> >                         break;
> >                 case SMB2_OP_DELETE:
> >                         if (rc)
> > -                               trace_smb3_delete_err(xid,  ses->Suid, =
tcon->tid, rc);
> > +                               trace_smb3_delete_err(xid, tcon->tid, s=
es->Suid, rc);
> >                         else {
> >                                 /*
> >                                  * If dentry (hence, inode) is NULL, le=
ase break is going to
> > @@ -699,59 +699,59 @@ static int smb2_compound_op(const unsigned int xi=
d, struct cifs_tcon *tcon,
> >                                  */
> >                                 if (inode)
> >                                         cifs_mark_open_handles_for_dele=
ted_file(inode, full_path);
> > -                               trace_smb3_delete_done(xid, ses->Suid, =
tcon->tid);
> > +                               trace_smb3_delete_done(xid, tcon->tid, =
ses->Suid);
> >                         }
> >                         break;
> >                 case SMB2_OP_MKDIR:
> >                         if (rc)
> > -                               trace_smb3_mkdir_err(xid,  ses->Suid, t=
con->tid, rc);
> > +                               trace_smb3_mkdir_err(xid, tcon->tid, se=
s->Suid, rc);
> >                         else
> > -                               trace_smb3_mkdir_done(xid, ses->Suid, t=
con->tid);
> > +                               trace_smb3_mkdir_done(xid, tcon->tid, s=
es->Suid);
> >                         break;
> >                 case SMB2_OP_HARDLINK:
> >                         if (rc)
> > -                               trace_smb3_hardlink_err(xid,  ses->Suid=
, tcon->tid, rc);
> > +                               trace_smb3_hardlink_err(xid,  tcon->tid=
, ses->Suid, rc);
> >                         else
> > -                               trace_smb3_hardlink_done(xid, ses->Suid=
, tcon->tid);
> > +                               trace_smb3_hardlink_done(xid, tcon->tid=
, ses->Suid);
> >                         SMB2_set_info_free(&rqst[num_rqst++]);
> >                         break;
> >                 case SMB2_OP_RENAME:
> >                         if (rc)
> > -                               trace_smb3_rename_err(xid,  ses->Suid, =
tcon->tid, rc);
> > +                               trace_smb3_rename_err(xid, tcon->tid, s=
es->Suid, rc);
> >                         else
> > -                               trace_smb3_rename_done(xid, ses->Suid, =
tcon->tid);
> > +                               trace_smb3_rename_done(xid, tcon->tid, =
ses->Suid);
> >                         SMB2_set_info_free(&rqst[num_rqst++]);
> >                         break;
> >                 case SMB2_OP_RMDIR:
> >                         if (rc)
> > -                               trace_smb3_rmdir_err(xid,  ses->Suid, t=
con->tid, rc);
> > +                               trace_smb3_rmdir_err(xid, tcon->tid, se=
s->Suid, rc);
> >                         else
> > -                               trace_smb3_rmdir_done(xid, ses->Suid, t=
con->tid);
> > +                               trace_smb3_rmdir_done(xid, tcon->tid, s=
es->Suid);
> >                         SMB2_set_info_free(&rqst[num_rqst++]);
> >                         break;
> >                 case SMB2_OP_SET_EOF:
> >                         if (rc)
> > -                               trace_smb3_set_eof_err(xid,  ses->Suid,=
 tcon->tid, rc);
> > +                               trace_smb3_set_eof_err(xid, tcon->tid, =
ses->Suid, rc);
> >                         else
> > -                               trace_smb3_set_eof_done(xid, ses->Suid,=
 tcon->tid);
> > +                               trace_smb3_set_eof_done(xid, tcon->tid,=
 ses->Suid);
> >                         SMB2_set_info_free(&rqst[num_rqst++]);
> >                         break;
> >                 case SMB2_OP_SET_INFO:
> >                         if (rc)
> > -                               trace_smb3_set_info_compound_err(xid,  =
ses->Suid,
> > -                                                                tcon->=
tid, rc);
> > +                               trace_smb3_set_info_compound_err(xid,  =
tcon->tid,
> > +                                                                ses->S=
uid, rc);
> >                         else
> > -                               trace_smb3_set_info_compound_done(xid, =
ses->Suid,
> > -                                                                 tcon-=
>tid);
> > +                               trace_smb3_set_info_compound_done(xid, =
tcon->tid,
> > +                                                                 ses->=
Suid);
> >                         SMB2_set_info_free(&rqst[num_rqst++]);
> >                         break;
> >                 case SMB2_OP_SET_REPARSE:
> >                         if (rc) {
> > -                               trace_smb3_set_reparse_compound_err(xid=
,  ses->Suid,
> > -                                                                   tco=
n->tid, rc);
> > +                               trace_smb3_set_reparse_compound_err(xid=
, tcon->tid,
> > +                                                                   ses=
->Suid, rc);
> >                         } else {
> > -                               trace_smb3_set_reparse_compound_done(xi=
d, ses->Suid,
> > -                                                                    tc=
on->tid);
> > +                               trace_smb3_set_reparse_compound_done(xi=
d, tcon->tid,
> > +                                                                    se=
s->Suid);
> >                         }
> >                         SMB2_ioctl_free(&rqst[num_rqst++]);
> >                         break;
> > @@ -764,18 +764,18 @@ static int smb2_compound_op(const unsigned int xi=
d, struct cifs_tcon *tcon,
> >                                 rbuf =3D reparse_buf_ptr(iov);
> >                                 if (IS_ERR(rbuf)) {
> >                                         rc =3D PTR_ERR(rbuf);
> > -                                       trace_smb3_set_reparse_compound=
_err(xid,  ses->Suid,
> > -                                                                      =
     tcon->tid, rc);
> > +                                       trace_smb3_get_reparse_compound=
_err(xid, tcon->tid,
> > +                                                                      =
     ses->Suid, rc);
> >                                 } else {
> >                                         idata->reparse.tag =3D le32_to_=
cpu(rbuf->ReparseTag);
> > -                                       trace_smb3_set_reparse_compound=
_done(xid, ses->Suid,
> > -                                                                      =
      tcon->tid);
> > +                                       trace_smb3_get_reparse_compound=
_done(xid, tcon->tid,
> > +                                                                      =
      ses->Suid);
> >                                 }
> >                                 memset(iov, 0, sizeof(*iov));
> >                                 resp_buftype[i + 1] =3D CIFS_NO_BUFFER;
> >                         } else {
> > -                               trace_smb3_set_reparse_compound_err(xid=
, ses->Suid,
> > -                                                                   tco=
n->tid, rc);
> > +                               trace_smb3_get_reparse_compound_err(xid=
, tcon->tid,
> > +                                                                   ses=
->Suid, rc);
> >                         }
> >                         SMB2_ioctl_free(&rqst[num_rqst++]);
> >                         break;
> > @@ -792,11 +792,11 @@ static int smb2_compound_op(const unsigned int xi=
d, struct cifs_tcon *tcon,
> >                                 }
> >                         }
> >                         if (!rc) {
> > -                               trace_smb3_query_wsl_ea_compound_done(x=
id, ses->Suid,
> > -                                                                     t=
con->tid);
> > +                               trace_smb3_query_wsl_ea_compound_done(x=
id, tcon->tid,
> > +                                                                     s=
es->Suid);
> >                         } else {
> > -                               trace_smb3_query_wsl_ea_compound_err(xi=
d, ses->Suid,
> > -                                                                    tc=
on->tid, rc);
> > +                               trace_smb3_query_wsl_ea_compound_err(xi=
d, tcon->tid,
> > +                                                                    se=
s->Suid, rc);
> >                         }
> >                         SMB2_query_info_free(&rqst[num_rqst++]);
> >                         break;
> > --
> > 2.48.1
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

--000000000000090e54062c09ede0
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-missing-tracepoint-for-querying-wsl-EAs.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-missing-tracepoint-for-querying-wsl-EAs.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m63a99pi0>
X-Attachment-Id: f_m63a99pi0

RnJvbSA3M2E2MmJlMjVlMTQzYmU1MzRhMWY5MDI3Mzg3ZjYwOGIwYjlkYzFlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgMTkgSmFuIDIwMjUgMDE6MDI6MDYgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhZGQgbWlzc2luZyB0cmFjZXBvaW50IGZvciBxdWVyeWluZyB3c2wgRUFzCgpXZSBoYWQg
dHJhY2Vwb2ludHMgZm9yIHRoZSByZXR1cm4gY29kZSBmb3IgcXVlcnlpbmcgV1NMIEVBcwoodHJh
Y2Vfc21iM19xdWVyeV93c2xfZWFfY29tcG91bmRfZXJyIGFuZAp0cmFjZV9zbWIzX3F1ZXJ5X3dz
bF9lYV9jb21wb3VuZF9kb25lKSBidXQgd2VyZSBtaXNzaW5nIG9uZSBmb3IKdHJhY2Vfc21iM19x
dWVyeV93c2xfZWFfY29tcG91bmRfZW50ZXIuCgpGaXhlczogZWE0MTM2N2IyYTYwICgic21iOiBj
bGllbnQ6IGludHJvZHVjZSBTTUIyX09QX1FVRVJZX1dTTF9FQSIpClNpZ25lZC1vZmYtYnk6IFN0
ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50L3Nt
YjJpbm9kZS5jIHwgMiArKwogZnMvc21iL2NsaWVudC90cmFjZS5oICAgICB8IDEgKwogMiBmaWxl
cyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L3Nt
YjJpbm9kZS5jIGIvZnMvc21iL2NsaWVudC9zbWIyaW5vZGUuYwppbmRleCAyNzQ2NzI3NTVjMTku
LjdkMzY4NWRkNjU1YSAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9zbWIyaW5vZGUuYworKysg
Yi9mcy9zbWIvY2xpZW50L3NtYjJpbm9kZS5jCkBAIC01ODQsNiArNTg0LDggQEAgc3RhdGljIGlu
dCBzbWIyX2NvbXBvdW5kX29wKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rj
b24gKnRjb24sCiAJCQkJZ290byBmaW5pc2hlZDsKIAkJCX0KIAkJCW51bV9ycXN0Kys7CisJCQl0
cmFjZV9zbWIzX3F1ZXJ5X3dzbF9lYV9jb21wb3VuZF9lbnRlcih4aWQsIHRjb24tPnRpZCwKKwkJ
CQkJCQkgICAgICAgc2VzLT5TdWlkLCBmdWxsX3BhdGgpOwogCQkJYnJlYWs7CiAJCWRlZmF1bHQ6
CiAJCQljaWZzX2RiZyhWRlMsICJJbnZhbGlkIGNvbW1hbmRcbiIpOwpkaWZmIC0tZ2l0IGEvZnMv
c21iL2NsaWVudC90cmFjZS5oIGIvZnMvc21iL2NsaWVudC90cmFjZS5oCmluZGV4IDEyY2JkMzQy
OGE2ZC4uNTJiY2I1NWQ5OTUyIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3RyYWNlLmgKKysr
IGIvZnMvc21iL2NsaWVudC90cmFjZS5oCkBAIC02NzQsNiArNjc0LDcgQEAgREVGSU5FX1NNQjNf
SU5GX0NPTVBPVU5EX0VOVEVSX0VWRU5UKHNldF9lb2ZfZW50ZXIpOwogREVGSU5FX1NNQjNfSU5G
X0NPTVBPVU5EX0VOVEVSX0VWRU5UKHNldF9pbmZvX2NvbXBvdW5kX2VudGVyKTsKIERFRklORV9T
TUIzX0lORl9DT01QT1VORF9FTlRFUl9FVkVOVChzZXRfcmVwYXJzZV9jb21wb3VuZF9lbnRlcik7
CiBERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRU5URVJfRVZFTlQoZ2V0X3JlcGFyc2VfY29tcG91
bmRfZW50ZXIpOworREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VOVEVSX0VWRU5UKHF1ZXJ5X3dz
bF9lYV9jb21wb3VuZF9lbnRlcik7CiBERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRU5URVJfRVZF
TlQoZGVsZXRlX2VudGVyKTsKIERFRklORV9TTUIzX0lORl9DT01QT1VORF9FTlRFUl9FVkVOVCht
a2Rpcl9lbnRlcik7CiBERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRU5URVJfRVZFTlQodGRpc19l
bnRlcik7Ci0tIAoyLjQzLjAKCg==
--000000000000090e54062c09ede0--
