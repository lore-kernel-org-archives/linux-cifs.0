Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17933F9D2
	for <linux-cifs@vger.kernel.org>; Sun, 19 Jan 2025 11:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737285084; cv=none; b=MJoZ5ggDkilq31vT2tveRWUYCC7aU81Iq5Mnh+IFtw7yz365OK8GLGpCmaRKFk0dnb5sfYxkg4KWi6z4yWtDmfQtcIPXWd6k8qkWX5lJiX9osvimmLfLkGnFePscspK5+sD0VRZd5vgaRbe66dt5VJllZZEv3PVHRSWve+vpjZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737285084; c=relaxed/simple;
	bh=LWUC3r7DowputLsEzfVja8Q/ji/8+ENMv/Eg1q8T19o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZDAjehAjuwszSvKlJaKVHAPRGtXOsk0ISDspcgUuQHbVkEM6w5qlfmnjkTK8WbqJwOunwEf/ne07dhbWWGunosUqSMxicpy7rHk97AuGAivz4w7hgKQYu9WQmuj8bo0NI26cr/uUNm2bZX9IG4L3lM9wgzj2uO45oQ85jupqAbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AP0f8ISR; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AP0f8ISR"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aaee2c5ee6eso609704866b.1
        for <linux-cifs@vger.kernel.org>; Sun, 19 Jan 2025 03:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737285079; x=1737889879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QhyLn7FF7VSvJSHEkp5q8q9MhRYdFFrHYNlwQaxU0LI=;
        b=AP0f8ISR4mUtPQeuRokXaSJLt8Os6gpmr77iN6NjVPzo3ganERyhYw4Dw65z3lzthM
         +1L0RQQ80NS2inBClTIyAVDdHljIS51IdHJFkWp8UtSh31kDoMW/TEuiqlIvwpGZ5mHJ
         S9yttkgz9KNmZKnhAdjXL7eXE/xCi7hy1NPnqTPT3A3Wfzk7SbArGOj77imeGpMjIvdd
         uvTnWbrhIZ34AmdJ81nJZz17IZKxeP+aIFrea3am2SG9OHK7ZGNuHbyW45IpaYMj2wFl
         60DlulgpkwZNRQj609WkM4stKKtIXvlLlEOaeUl8w5X1uXrOjYQPln2JCwoVgH1TwpNR
         Xk2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737285079; x=1737889879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QhyLn7FF7VSvJSHEkp5q8q9MhRYdFFrHYNlwQaxU0LI=;
        b=c7C7R/1P/3K2xWp7xkLC4DbIaFBKw2qUBL2Xs5e31yCK8O3hPKjVK+ylF2VC0a5zaU
         HBydlhpNkjHFnW5kDpla1wFgaM56XUAasozIX8BJQMzc7244JVq3lqlEy01dgPqtqzSr
         vo1XEb4opFm51sgmD+HGI+SXL3uuc/NQZRrRQyWeW1hDIjnh+SL5rksLGJV5a44LFbvo
         nQA6QoygibKJiTRbSaSd0vuonnis5Y5mIsK1+FQMR38YfD0ooT1ALCaYlsju3VWCNSoj
         M2BA+pjUws2kjIPO3Dt9cEfYF3jQ51pU1mZp+qne/4xs2VAGw5cP3ypL8440cGhrRGTY
         paQA==
X-Forwarded-Encrypted: i=1; AJvYcCXi23/q8I4g/yS7rY1r+/1yc+K3A11HPaJQfVukSQrU9RxMC3OblwpT9hzA1k8cG8f1ijQBDhlUnyL6@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3fv1+cP5L77ZC8JaYgfJp6lYt1r+y49p71FDy6BYbUugwgMhA
	/SsGUFuDfzh6TEH0/1v5kRCWS1qaLxotDbRNM64iUoWHUyKJt5QT
X-Gm-Gg: ASbGncufviDWNQBwbjWf53EQr+WyYVaEZuvQoL/sj3qV2aIJwVaOfJaiaxlIL+7oKYq
	7EAk9G6VWs8F4XpZuGnBHtmQ9SUoItkrfq8e4/r/OxA5mRy0S/Lrka9Jok9HMcHyEFsiCg20sJj
	9bcq4eq/6+rh98+XdFK4RFcW4VWEs+ZhLro3Gd0/DbAQRz8Tj6x5qnAngrLO3UMO8iIX1A+7rU9
	pBvOxQ8gkJ6zSZul54Y3D5rPzBswgTxacjlWuODmhirkb03bKW09G3fm6QsGgR7aqe96mteey65
	z1SUbDdSb7r/
X-Google-Smtp-Source: AGHT+IEJ1q4IA7PuXEqAmfdb8MAUWwoVAbph+IppwIcwEbQiYl3RGRgw97LLfDm8pH2lO+QVuhMdnQ==
X-Received: by 2002:a17:907:7253:b0:aa6:8a1b:8b78 with SMTP id a640c23a62f3a-ab38b0b7f43mr741894666b.6.1737285078744;
        Sun, 19 Jan 2025 03:11:18 -0800 (PST)
Received: from localhost.localdomain ([2a02:a03f:e6d8:fc01:121f:74ff:fe57:106])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384d2c9c7sm470062966b.76.2025.01.19.03.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2025 03:11:18 -0800 (PST)
From: Ruben Devos <devosruben6@gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix order of arguments of tracepoints
Date: Sun, 19 Jan 2025 12:11:17 +0100
Message-ID: <13701770.uLZWGnKmhe@localhost.localdomain>
In-Reply-To:
 <CAH2r5mvU738RRMBpp9vZPXeG4k9ohJB6OJ6U5BoW5Md+pMMUyw@mail.gmail.com>
References:
 <20250118200330.21020-1-devosruben6@gmail.com>
 <CAH2r5mvMRgiK1jFr3CKJPp1qN2FTBT6NH_M2jRWxjR7p+O5A-w@mail.gmail.com>
 <CAH2r5mvU738RRMBpp9vZPXeG4k9ohJB6OJ6U5BoW5Md+pMMUyw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On zondag 19 januari 2025 at 08:16:29  Steve French wrote:
> Here is a minor patch to add the missing tracepoint (see attached).
> Let me know if any thoughts, or other obviousb missing tracepoints
Hi Steve,

Thank you for your review.=20
I noticed the missing trace_smb3_query_wsl_ea_compound_enter too but I
was not sure if it was left out for a reason.
I'm not aware of other missing tracepoints.=20

I saw that both your patch and my patch are in your for-next tree now.=20
Does this mean everything is OK and there is no need for a v2?

>=20
>     smb3: add missing tracepoint for querying wsl EAs
>=20
>     We had tracepoints for the return code for querying WSL EAs
>     (trace_smb3_query_wsl_ea_compound_err and
>     trace_smb3_query_wsl_ea_compound_done) but were missing one for
>     trace_smb3_query_wsl_ea_compound_enter.
>=20
>     Fixes: ea41367b2a60 ("smb: client: introduce SMB2_OP_QUERY_WSL_EA")
>=20
>=20
> On Sat, Jan 18, 2025 at 10:38=E2=80=AFPM Steve French <smfrench@gmail.com=
> wrote:
> >
> > Good catch.
> >
> > Looking at your patch, I noticed one trace point was missing from the
> > original patch:
> >
> >          trace_smb3_query_wsl_ea_compound_enter
> >
> > commit ea41367b2a602f602ea6594fc4a310520dcc64f4
> > Author: Paulo Alcantara <pc@manguebit.com>
> > Date:   Sun Jan 28 01:12:01 2024 -0300
> >
> >     smb: client: introduce SMB2_OP_QUERY_WSL_EA
> >
> > On Sat, Jan 18, 2025 at 2:04=E2=80=AFPM Ruben Devos <devosruben6@gmail.=
com> wrote:
> > >
> > > The tracepoints based on smb3_inf_compound_*_class have tcon id and
> > > session id swapped around. This results in incorrect output in
> > > `trace-cmd report`.
> > >
> > > Fix the order of arguments to resolve this issue. The trace-cmd output
> > > below shows the before and after of the smb3_delete_enter and
> > > smb3_delete_done events as an example. The smb3_cmd_* events show the
> > > correct session and tcon id for reference.
> > >
> > > Also fix tracepoint set -> get in the SMB2_OP_GET_REPARSE case.
> > >
> > > BEFORE:
> > > rm-2211  [001] .....  1839.550888: smb3_delete_enter:    xid=3D281 si=
d=3D0x5 tid=3D0x3d path=3D\hello2.txt
> > > rm-2211  [001] .....  1839.550894: smb3_cmd_enter:        sid=3D0x1ac=
000000003d tid=3D0x5 cmd=3D5 mid=3D61
> > > rm-2211  [001] .....  1839.550896: smb3_cmd_enter:        sid=3D0x1ac=
000000003d tid=3D0x5 cmd=3D6 mid=3D62
> > > rm-2211  [001] .....  1839.552091: smb3_cmd_done:         sid=3D0x1ac=
000000003d tid=3D0x5 cmd=3D5 mid=3D61
> > > rm-2211  [001] .....  1839.552093: smb3_cmd_done:         sid=3D0x1ac=
000000003d tid=3D0x5 cmd=3D6 mid=3D62
> > > rm-2211  [001] .....  1839.552103: smb3_delete_done:     xid=3D281 si=
d=3D0x5 tid=3D0x3d
> > >
> > > AFTER:
> > > rm-2501  [001] .....  3237.656110: smb3_delete_enter:    xid=3D88 sid=
=3D0x1ac0000000041 tid=3D0x5 path=3D\hello2.txt
> > > rm-2501  [001] .....  3237.656122: smb3_cmd_enter:        sid=3D0x1ac=
0000000041 tid=3D0x5 cmd=3D5 mid=3D84
> > > rm-2501  [001] .....  3237.656123: smb3_cmd_enter:        sid=3D0x1ac=
0000000041 tid=3D0x5 cmd=3D6 mid=3D85
> > > rm-2501  [001] .....  3237.657909: smb3_cmd_done:         sid=3D0x1ac=
0000000041 tid=3D0x5 cmd=3D5 mid=3D84
> > > rm-2501  [001] .....  3237.657909: smb3_cmd_done:         sid=3D0x1ac=
0000000041 tid=3D0x5 cmd=3D6 mid=3D85
> > > rm-2501  [001] .....  3237.657922: smb3_delete_done:     xid=3D88 sid=
=3D0x1ac0000000041 tid=3D0x5
> > >
> > > Signed-off-by: Ruben Devos <devosruben6@gmail.com>
> > > ---
> > >  fs/smb/client/dir.c       |   6 +--
> > >  fs/smb/client/smb2inode.c | 108 +++++++++++++++++++-----------------=
=2D-
> > >  2 files changed, 57 insertions(+), 57 deletions(-)
> > >
> > > diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> > > index 864b194dbaa0..1822493dd084 100644
> > > --- a/fs/smb/client/dir.c
> > > +++ b/fs/smb/client/dir.c
> > > @@ -627,7 +627,7 @@ int cifs_mknod(struct mnt_idmap *idmap, struct in=
ode *inode,
> > >                 goto mknod_out;
> > >         }
> > >
> > > -       trace_smb3_mknod_enter(xid, tcon->ses->Suid, tcon->tid, full_=
path);
> > > +       trace_smb3_mknod_enter(xid, tcon->tid, tcon->ses->Suid, full_=
path);
> > >
> > >         rc =3D tcon->ses->server->ops->make_node(xid, inode, direntry=
, tcon,
> > >                                                full_path, mode,
> > > @@ -635,9 +635,9 @@ int cifs_mknod(struct mnt_idmap *idmap, struct in=
ode *inode,
> > >
> > >  mknod_out:
> > >         if (rc)
> > > -               trace_smb3_mknod_err(xid,  tcon->ses->Suid, tcon->tid=
, rc);
> > > +               trace_smb3_mknod_err(xid,  tcon->tid, tcon->ses->Suid=
, rc);
> > >         else
> > > -               trace_smb3_mknod_done(xid, tcon->ses->Suid, tcon->tid=
);
> > > +               trace_smb3_mknod_done(xid, tcon->tid, tcon->ses->Suid=
);
> > >
> > >         free_dentry_path(page);
> > >         free_xid(xid);
> > > diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> > > index a55f0044d30b..274672755c19 100644
> > > --- a/fs/smb/client/smb2inode.c
> > > +++ b/fs/smb/client/smb2inode.c
> > > @@ -298,8 +298,8 @@ static int smb2_compound_op(const unsigned int xi=
d, struct cifs_tcon *tcon,
> > >                                 goto finished;
> > >                         }
> > >                         num_rqst++;
> > > -                       trace_smb3_query_info_compound_enter(xid, ses=
=2D>Suid,
> > > -                                                            tcon->ti=
d, full_path);
> > > +                       trace_smb3_query_info_compound_enter(xid, tco=
n->tid,
> > > +                                                            ses->Sui=
d, full_path);
> > >                         break;
> > >                 case SMB2_OP_POSIX_QUERY_INFO:
> > >                         rqst[num_rqst].rq_iov =3D &vars->qi_iov;
> > > @@ -334,18 +334,18 @@ static int smb2_compound_op(const unsigned int =
xid, struct cifs_tcon *tcon,
> > >                                 goto finished;
> > >                         }
> > >                         num_rqst++;
> > > -                       trace_smb3_posix_query_info_compound_enter(xi=
d, ses->Suid,
> > > -                                                                  tc=
on->tid, full_path);
> > > +                       trace_smb3_posix_query_info_compound_enter(xi=
d, tcon->tid,
> > > +                                                                  se=
s->Suid, full_path);
> > >                         break;
> > >                 case SMB2_OP_DELETE:
> > > -                       trace_smb3_delete_enter(xid, ses->Suid, tcon-=
>tid, full_path);
> > > +                       trace_smb3_delete_enter(xid, tcon->tid, ses->=
Suid, full_path);
> > >                         break;
> > >                 case SMB2_OP_MKDIR:
> > >                         /*
> > >                          * Directories are created through parameters=
 in the
> > >                          * SMB2_open() call.
> > >                          */
> > > -                       trace_smb3_mkdir_enter(xid, ses->Suid, tcon->=
tid, full_path);
> > > +                       trace_smb3_mkdir_enter(xid, tcon->tid, ses->S=
uid, full_path);
> > >                         break;
> > >                 case SMB2_OP_RMDIR:
> > >                         rqst[num_rqst].rq_iov =3D &vars->si_iov[0];
> > > @@ -363,7 +363,7 @@ static int smb2_compound_op(const unsigned int xi=
d, struct cifs_tcon *tcon,
> > >                                 goto finished;
> > >                         smb2_set_next_command(tcon, &rqst[num_rqst]);
> > >                         smb2_set_related(&rqst[num_rqst++]);
> > > -                       trace_smb3_rmdir_enter(xid, ses->Suid, tcon->=
tid, full_path);
> > > +                       trace_smb3_rmdir_enter(xid, tcon->tid, ses->S=
uid, full_path);
> > >                         break;
> > >                 case SMB2_OP_SET_EOF:
> > >                         rqst[num_rqst].rq_iov =3D &vars->si_iov[0];
> > > @@ -398,7 +398,7 @@ static int smb2_compound_op(const unsigned int xi=
d, struct cifs_tcon *tcon,
> > >                                 goto finished;
> > >                         }
> > >                         num_rqst++;
> > > -                       trace_smb3_set_eof_enter(xid, ses->Suid, tcon=
=2D>tid, full_path);
> > > +                       trace_smb3_set_eof_enter(xid, tcon->tid, ses-=
>Suid, full_path);
> > >                         break;
> > >                 case SMB2_OP_SET_INFO:
> > >                         rqst[num_rqst].rq_iov =3D &vars->si_iov[0];
> > > @@ -429,8 +429,8 @@ static int smb2_compound_op(const unsigned int xi=
d, struct cifs_tcon *tcon,
> > >                                 goto finished;
> > >                         }
> > >                         num_rqst++;
> > > -                       trace_smb3_set_info_compound_enter(xid, ses->=
Suid,
> > > -                                                          tcon->tid,=
 full_path);
> > > +                       trace_smb3_set_info_compound_enter(xid, tcon-=
>tid,
> > > +                                                          ses->Suid,=
 full_path);
> > >                         break;
> > >                 case SMB2_OP_RENAME:
> > >                         rqst[num_rqst].rq_iov =3D &vars->si_iov[0];
> > > @@ -469,7 +469,7 @@ static int smb2_compound_op(const unsigned int xi=
d, struct cifs_tcon *tcon,
> > >                                 goto finished;
> > >                         }
> > >                         num_rqst++;
> > > -                       trace_smb3_rename_enter(xid, ses->Suid, tcon-=
>tid, full_path);
> > > +                       trace_smb3_rename_enter(xid, tcon->tid, ses->=
Suid, full_path);
> > >                         break;
> > >                 case SMB2_OP_HARDLINK:
> > >                         rqst[num_rqst].rq_iov =3D &vars->si_iov[0];
> > > @@ -496,7 +496,7 @@ static int smb2_compound_op(const unsigned int xi=
d, struct cifs_tcon *tcon,
> > >                                 goto finished;
> > >                         smb2_set_next_command(tcon, &rqst[num_rqst]);
> > >                         smb2_set_related(&rqst[num_rqst++]);
> > > -                       trace_smb3_hardlink_enter(xid, ses->Suid, tco=
n->tid, full_path);
> > > +                       trace_smb3_hardlink_enter(xid, tcon->tid, ses=
=2D>Suid, full_path);
> > >                         break;
> > >                 case SMB2_OP_SET_REPARSE:
> > >                         rqst[num_rqst].rq_iov =3D vars->io_iov;
> > > @@ -523,8 +523,8 @@ static int smb2_compound_op(const unsigned int xi=
d, struct cifs_tcon *tcon,
> > >                                 goto finished;
> > >                         }
> > >                         num_rqst++;
> > > -                       trace_smb3_set_reparse_compound_enter(xid, se=
s->Suid,
> > > -                                                             tcon->t=
id, full_path);
> > > +                       trace_smb3_set_reparse_compound_enter(xid, tc=
on->tid,
> > > +                                                             ses->Su=
id, full_path);
> > >                         break;
> > >                 case SMB2_OP_GET_REPARSE:
> > >                         rqst[num_rqst].rq_iov =3D vars->io_iov;
> > > @@ -549,8 +549,8 @@ static int smb2_compound_op(const unsigned int xi=
d, struct cifs_tcon *tcon,
> > >                                 goto finished;
> > >                         }
> > >                         num_rqst++;
> > > -                       trace_smb3_get_reparse_compound_enter(xid, se=
s->Suid,
> > > -                                                             tcon->t=
id, full_path);
> > > +                       trace_smb3_get_reparse_compound_enter(xid, tc=
on->tid,
> > > +                                                             ses->Su=
id, full_path);
> > >                         break;
> > >                 case SMB2_OP_QUERY_WSL_EA:
> > >                         rqst[num_rqst].rq_iov =3D &vars->ea_iov;
> > > @@ -656,11 +656,11 @@ static int smb2_compound_op(const unsigned int =
xid, struct cifs_tcon *tcon,
> > >                         }
> > >                         SMB2_query_info_free(&rqst[num_rqst++]);
> > >                         if (rc)
> > > -                               trace_smb3_query_info_compound_err(xi=
d,  ses->Suid,
> > > -                                                                  tc=
on->tid, rc);
> > > +                               trace_smb3_query_info_compound_err(xi=
d,  tcon->tid,
> > > +                                                                  se=
s->Suid, rc);
> > >                         else
> > > -                               trace_smb3_query_info_compound_done(x=
id, ses->Suid,
> > > -                                                                   t=
con->tid);
> > > +                               trace_smb3_query_info_compound_done(x=
id, tcon->tid,
> > > +                                                                   s=
es->Suid);
> > >                         break;
> > >                 case SMB2_OP_POSIX_QUERY_INFO:
> > >                         idata =3D in_iov[i].iov_base;
> > > @@ -683,15 +683,15 @@ static int smb2_compound_op(const unsigned int =
xid, struct cifs_tcon *tcon,
> > >
> > >                         SMB2_query_info_free(&rqst[num_rqst++]);
> > >                         if (rc)
> > > -                               trace_smb3_posix_query_info_compound_=
err(xid,  ses->Suid,
> > > -                                                                    =
    tcon->tid, rc);
> > > +                               trace_smb3_posix_query_info_compound_=
err(xid,  tcon->tid,
> > > +                                                                    =
    ses->Suid, rc);
> > >                         else
> > > -                               trace_smb3_posix_query_info_compound_=
done(xid, ses->Suid,
> > > -                                                                    =
     tcon->tid);
> > > +                               trace_smb3_posix_query_info_compound_=
done(xid, tcon->tid,
> > > +                                                                    =
     ses->Suid);
> > >                         break;
> > >                 case SMB2_OP_DELETE:
> > >                         if (rc)
> > > -                               trace_smb3_delete_err(xid,  ses->Suid=
, tcon->tid, rc);
> > > +                               trace_smb3_delete_err(xid, tcon->tid,=
 ses->Suid, rc);
> > >                         else {
> > >                                 /*
> > >                                  * If dentry (hence, inode) is NULL, =
lease break is going to
> > > @@ -699,59 +699,59 @@ static int smb2_compound_op(const unsigned int =
xid, struct cifs_tcon *tcon,
> > >                                  */
> > >                                 if (inode)
> > >                                         cifs_mark_open_handles_for_de=
leted_file(inode, full_path);
> > > -                               trace_smb3_delete_done(xid, ses->Suid=
, tcon->tid);
> > > +                               trace_smb3_delete_done(xid, tcon->tid=
, ses->Suid);
> > >                         }
> > >                         break;
> > >                 case SMB2_OP_MKDIR:
> > >                         if (rc)
> > > -                               trace_smb3_mkdir_err(xid,  ses->Suid,=
 tcon->tid, rc);
> > > +                               trace_smb3_mkdir_err(xid, tcon->tid, =
ses->Suid, rc);
> > >                         else
> > > -                               trace_smb3_mkdir_done(xid, ses->Suid,=
 tcon->tid);
> > > +                               trace_smb3_mkdir_done(xid, tcon->tid,=
 ses->Suid);
> > >                         break;
> > >                 case SMB2_OP_HARDLINK:
> > >                         if (rc)
> > > -                               trace_smb3_hardlink_err(xid,  ses->Su=
id, tcon->tid, rc);
> > > +                               trace_smb3_hardlink_err(xid,  tcon->t=
id, ses->Suid, rc);
> > >                         else
> > > -                               trace_smb3_hardlink_done(xid, ses->Su=
id, tcon->tid);
> > > +                               trace_smb3_hardlink_done(xid, tcon->t=
id, ses->Suid);
> > >                         SMB2_set_info_free(&rqst[num_rqst++]);
> > >                         break;
> > >                 case SMB2_OP_RENAME:
> > >                         if (rc)
> > > -                               trace_smb3_rename_err(xid,  ses->Suid=
, tcon->tid, rc);
> > > +                               trace_smb3_rename_err(xid, tcon->tid,=
 ses->Suid, rc);
> > >                         else
> > > -                               trace_smb3_rename_done(xid, ses->Suid=
, tcon->tid);
> > > +                               trace_smb3_rename_done(xid, tcon->tid=
, ses->Suid);
> > >                         SMB2_set_info_free(&rqst[num_rqst++]);
> > >                         break;
> > >                 case SMB2_OP_RMDIR:
> > >                         if (rc)
> > > -                               trace_smb3_rmdir_err(xid,  ses->Suid,=
 tcon->tid, rc);
> > > +                               trace_smb3_rmdir_err(xid, tcon->tid, =
ses->Suid, rc);
> > >                         else
> > > -                               trace_smb3_rmdir_done(xid, ses->Suid,=
 tcon->tid);
> > > +                               trace_smb3_rmdir_done(xid, tcon->tid,=
 ses->Suid);
> > >                         SMB2_set_info_free(&rqst[num_rqst++]);
> > >                         break;
> > >                 case SMB2_OP_SET_EOF:
> > >                         if (rc)
> > > -                               trace_smb3_set_eof_err(xid,  ses->Sui=
d, tcon->tid, rc);
> > > +                               trace_smb3_set_eof_err(xid, tcon->tid=
, ses->Suid, rc);
> > >                         else
> > > -                               trace_smb3_set_eof_done(xid, ses->Sui=
d, tcon->tid);
> > > +                               trace_smb3_set_eof_done(xid, tcon->ti=
d, ses->Suid);
> > >                         SMB2_set_info_free(&rqst[num_rqst++]);
> > >                         break;
> > >                 case SMB2_OP_SET_INFO:
> > >                         if (rc)
> > > -                               trace_smb3_set_info_compound_err(xid,=
  ses->Suid,
> > > -                                                                tcon=
=2D>tid, rc);
> > > +                               trace_smb3_set_info_compound_err(xid,=
  tcon->tid,
> > > +                                                                ses-=
>Suid, rc);
> > >                         else
> > > -                               trace_smb3_set_info_compound_done(xid=
, ses->Suid,
> > > -                                                                 tco=
n->tid);
> > > +                               trace_smb3_set_info_compound_done(xid=
, tcon->tid,
> > > +                                                                 ses=
=2D>Suid);
> > >                         SMB2_set_info_free(&rqst[num_rqst++]);
> > >                         break;
> > >                 case SMB2_OP_SET_REPARSE:
> > >                         if (rc) {
> > > -                               trace_smb3_set_reparse_compound_err(x=
id,  ses->Suid,
> > > -                                                                   t=
con->tid, rc);
> > > +                               trace_smb3_set_reparse_compound_err(x=
id, tcon->tid,
> > > +                                                                   s=
es->Suid, rc);
> > >                         } else {
> > > -                               trace_smb3_set_reparse_compound_done(=
xid, ses->Suid,
> > > -                                                                    =
tcon->tid);
> > > +                               trace_smb3_set_reparse_compound_done(=
xid, tcon->tid,
> > > +                                                                    =
ses->Suid);
> > >                         }
> > >                         SMB2_ioctl_free(&rqst[num_rqst++]);
> > >                         break;
> > > @@ -764,18 +764,18 @@ static int smb2_compound_op(const unsigned int =
xid, struct cifs_tcon *tcon,
> > >                                 rbuf =3D reparse_buf_ptr(iov);
> > >                                 if (IS_ERR(rbuf)) {
> > >                                         rc =3D PTR_ERR(rbuf);
> > > -                                       trace_smb3_set_reparse_compou=
nd_err(xid,  ses->Suid,
> > > -                                                                    =
       tcon->tid, rc);
> > > +                                       trace_smb3_get_reparse_compou=
nd_err(xid, tcon->tid,
> > > +                                                                    =
       ses->Suid, rc);
> > >                                 } else {
> > >                                         idata->reparse.tag =3D le32_t=
o_cpu(rbuf->ReparseTag);
> > > -                                       trace_smb3_set_reparse_compou=
nd_done(xid, ses->Suid,
> > > -                                                                    =
        tcon->tid);
> > > +                                       trace_smb3_get_reparse_compou=
nd_done(xid, tcon->tid,
> > > +                                                                    =
        ses->Suid);
> > >                                 }
> > >                                 memset(iov, 0, sizeof(*iov));
> > >                                 resp_buftype[i + 1] =3D CIFS_NO_BUFFE=
R;
> > >                         } else {
> > > -                               trace_smb3_set_reparse_compound_err(x=
id, ses->Suid,
> > > -                                                                   t=
con->tid, rc);
> > > +                               trace_smb3_get_reparse_compound_err(x=
id, tcon->tid,
> > > +                                                                   s=
es->Suid, rc);
> > >                         }
> > >                         SMB2_ioctl_free(&rqst[num_rqst++]);
> > >                         break;
> > > @@ -792,11 +792,11 @@ static int smb2_compound_op(const unsigned int =
xid, struct cifs_tcon *tcon,
> > >                                 }
> > >                         }
> > >                         if (!rc) {
> > > -                               trace_smb3_query_wsl_ea_compound_done=
(xid, ses->Suid,
> > > -                                                                    =
 tcon->tid);
> > > +                               trace_smb3_query_wsl_ea_compound_done=
(xid, tcon->tid,
> > > +                                                                    =
 ses->Suid);
> > >                         } else {
> > > -                               trace_smb3_query_wsl_ea_compound_err(=
xid, ses->Suid,
> > > -                                                                    =
tcon->tid, rc);
> > > +                               trace_smb3_query_wsl_ea_compound_err(=
xid, tcon->tid,
> > > +                                                                    =
ses->Suid, rc);
> > >                         }
> > >                         SMB2_query_info_free(&rqst[num_rqst++]);
> > >                         break;
> > > --
> > > 2.48.1
> > >
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>=20
>=20
>=20
>=20




