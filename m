Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C806E2F29
	for <linux-cifs@vger.kernel.org>; Sun, 19 Jan 2025 04:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737261499; cv=none; b=ltG9kP6NWwbxaV8X860Mag1Voj7/2NfkEvUV/XojmuNj9joK1bgvKDVPyesjFrVjk1td/BbaPIpUVskhgKmqQBQCulEwIt8e3uM5H+svQqGcBWO68fWMWysDwAcnL+VkyBrgDds0y7qBHa7kzCgRV2fVn65s/0pKNz33sSeQvqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737261499; c=relaxed/simple;
	bh=OzqWSnZ2J1MnvrReh3d1w/+/Ll0ef62fGxlOfhDNlW0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ohZC7xfKLKX3+IRJpgzOjKHyFsi/EpPOq+OuqNPhBBhrhAXXQn5xqP43CygQxQhgQuJ74OJssAciQ2TM3q2IHvKIqY9Xe2cEP+Pe79Bsbm8USYtYkGoCkesolULEiddNrpslsEbKuFKXesAsNHlDIPeZglnTqsfM4+DUZOX4kfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WPrfg0+P; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WPrfg0+P"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5439a6179a7so2628675e87.1
        for <linux-cifs@vger.kernel.org>; Sat, 18 Jan 2025 20:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737261495; x=1737866295; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i0jJP+8BkPtudpmbYVKv4su1TZlDmHvwbeekJ3Jid/o=;
        b=WPrfg0+PG+/D4IQb2K7SJpQbMs5su/DxfdudzH+X7BBVBZC/icb6gm6XHgcsklQFMq
         MaYGR78y8MoLayBV3cdTg2D8QB/meuT9GRm5GCDCI3qr7jMK5r3NyZY9bbtjwE/f1+al
         RwRFGszE21c8jiVcnLJ+TQ5hyCGsdSNmDtumP17wdMXmCo/niIwF+8sp0geKq5edT2Rw
         6WBt25YGgQKTkxeVfzCIsDmKBe5WTJg4iWzcBAbwrgviOw23g5ZeYEEHjkEIPrNzRXS9
         GRCwNQM4sFmmBok0UNJKRUyP97aT8LeinVojmNOX4Y4m3uoxt5szosrSuBsfkplTqpfx
         aHbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737261495; x=1737866295;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i0jJP+8BkPtudpmbYVKv4su1TZlDmHvwbeekJ3Jid/o=;
        b=aVksaZLdQ+HFCv0Ra3gruRpcub+DYYUj5wdiX3XrT6Qw1eRoFNq9vMDY/KFg++k8B6
         /jkk556XU5OAf1/SoK6XdMbWUdoM0hs6QzhwP/5QJQwmFIp/48F5/KZ4KYZgX5+psJsS
         iee5TS5JOYU/Bt6GdzD34LmOH5f5Zc6DF3DViZOFQCtwz9uKF8vShP/jx8Za9LLd9k1w
         6n9iSUxloczqyW3fl2jMaBzS22QsbiDzG17KX2buOk3GcAyGYJl/OQ8pvUmt36feVzH0
         sm1MP5TRq9rIrdfnAPuW5RHE4gi0zvq6lSkCCycUCjIDauAnaj6M/QpjENy57Yzbf2E6
         QKAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwDAyNc2+RvOm5IaI21Qv+IePDxQiSq/E/IsKM/lbowFMylSqwhj/q6EXWRlndbEvOYHYWtNkLE41V@vger.kernel.org
X-Gm-Message-State: AOJu0YwKlZ9Di45qXfhM6JClBvqggE28Uh4NLXEkA/RV8AJGaslTz3lZ
	bSOtKPGUtxwGWA7nhYNSwW/5VgpSDitHvyE4cW2/oRC2vD1Y9vMWJwThkmyLW+51GM9QGqh+y1A
	eLY0LQc3s2Ydg84MuKqVB9rDlzks=
X-Gm-Gg: ASbGncsfVuXNSk/jFCcLdPMUyGYfTRnjc5qPfIdVo12vn3KOSJFltdIoD/fZ6+xM/5n
	gv/VagfbtTGb74d4pOnnqatFZavETYdKn3/57cbm2xwREK+HlwqXXwSPGYP1s0Lquw+9oULRWHi
	Hn92Qtm71C
X-Google-Smtp-Source: AGHT+IE7F7QYwt5ivR+ItS/h9Uc70n+8mOqungDyWqNFQEKuUtL0FAFZ4Gt60VAvyfV+L6jxeqYP/tfCPC8ALLJkMio=
X-Received: by 2002:a05:6512:138c:b0:542:8a86:bed1 with SMTP id
 2adb3069b0e04-542abf51c36mr5615070e87.4.1737261494455; Sat, 18 Jan 2025
 20:38:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250118200330.21020-1-devosruben6@gmail.com>
In-Reply-To: <20250118200330.21020-1-devosruben6@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 18 Jan 2025 22:38:03 -0600
X-Gm-Features: AbW1kvY5e4BEsBYp7zuP3SWRqY0FGitVahHHV14at-eb0VERneD2iMgQcWa3FXg
Message-ID: <CAH2r5mvMRgiK1jFr3CKJPp1qN2FTBT6NH_M2jRWxjR7p+O5A-w@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix order of arguments of tracepoints
To: Ruben Devos <devosruben6@gmail.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good catch.

Looking at your patch, I noticed one trace point was missing from the
original patch:

         trace_smb3_query_wsl_ea_compound_enter

commit ea41367b2a602f602ea6594fc4a310520dcc64f4
Author: Paulo Alcantara <pc@manguebit.com>
Date:   Sun Jan 28 01:12:01 2024 -0300

    smb: client: introduce SMB2_OP_QUERY_WSL_EA

On Sat, Jan 18, 2025 at 2:04=E2=80=AFPM Ruben Devos <devosruben6@gmail.com>=
 wrote:
>
> The tracepoints based on smb3_inf_compound_*_class have tcon id and
> session id swapped around. This results in incorrect output in
> `trace-cmd report`.
>
> Fix the order of arguments to resolve this issue. The trace-cmd output
> below shows the before and after of the smb3_delete_enter and
> smb3_delete_done events as an example. The smb3_cmd_* events show the
> correct session and tcon id for reference.
>
> Also fix tracepoint set -> get in the SMB2_OP_GET_REPARSE case.
>
> BEFORE:
> rm-2211  [001] .....  1839.550888: smb3_delete_enter:    xid=3D281 sid=3D=
0x5 tid=3D0x3d path=3D\hello2.txt
> rm-2211  [001] .....  1839.550894: smb3_cmd_enter:        sid=3D0x1ac0000=
00003d tid=3D0x5 cmd=3D5 mid=3D61
> rm-2211  [001] .....  1839.550896: smb3_cmd_enter:        sid=3D0x1ac0000=
00003d tid=3D0x5 cmd=3D6 mid=3D62
> rm-2211  [001] .....  1839.552091: smb3_cmd_done:         sid=3D0x1ac0000=
00003d tid=3D0x5 cmd=3D5 mid=3D61
> rm-2211  [001] .....  1839.552093: smb3_cmd_done:         sid=3D0x1ac0000=
00003d tid=3D0x5 cmd=3D6 mid=3D62
> rm-2211  [001] .....  1839.552103: smb3_delete_done:     xid=3D281 sid=3D=
0x5 tid=3D0x3d
>
> AFTER:
> rm-2501  [001] .....  3237.656110: smb3_delete_enter:    xid=3D88 sid=3D0=
x1ac0000000041 tid=3D0x5 path=3D\hello2.txt
> rm-2501  [001] .....  3237.656122: smb3_cmd_enter:        sid=3D0x1ac0000=
000041 tid=3D0x5 cmd=3D5 mid=3D84
> rm-2501  [001] .....  3237.656123: smb3_cmd_enter:        sid=3D0x1ac0000=
000041 tid=3D0x5 cmd=3D6 mid=3D85
> rm-2501  [001] .....  3237.657909: smb3_cmd_done:         sid=3D0x1ac0000=
000041 tid=3D0x5 cmd=3D5 mid=3D84
> rm-2501  [001] .....  3237.657909: smb3_cmd_done:         sid=3D0x1ac0000=
000041 tid=3D0x5 cmd=3D6 mid=3D85
> rm-2501  [001] .....  3237.657922: smb3_delete_done:     xid=3D88 sid=3D0=
x1ac0000000041 tid=3D0x5
>
> Signed-off-by: Ruben Devos <devosruben6@gmail.com>
> ---
>  fs/smb/client/dir.c       |   6 +--
>  fs/smb/client/smb2inode.c | 108 +++++++++++++++++++-------------------
>  2 files changed, 57 insertions(+), 57 deletions(-)
>
> diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> index 864b194dbaa0..1822493dd084 100644
> --- a/fs/smb/client/dir.c
> +++ b/fs/smb/client/dir.c
> @@ -627,7 +627,7 @@ int cifs_mknod(struct mnt_idmap *idmap, struct inode =
*inode,
>                 goto mknod_out;
>         }
>
> -       trace_smb3_mknod_enter(xid, tcon->ses->Suid, tcon->tid, full_path=
);
> +       trace_smb3_mknod_enter(xid, tcon->tid, tcon->ses->Suid, full_path=
);
>
>         rc =3D tcon->ses->server->ops->make_node(xid, inode, direntry, tc=
on,
>                                                full_path, mode,
> @@ -635,9 +635,9 @@ int cifs_mknod(struct mnt_idmap *idmap, struct inode =
*inode,
>
>  mknod_out:
>         if (rc)
> -               trace_smb3_mknod_err(xid,  tcon->ses->Suid, tcon->tid, rc=
);
> +               trace_smb3_mknod_err(xid,  tcon->tid, tcon->ses->Suid, rc=
);
>         else
> -               trace_smb3_mknod_done(xid, tcon->ses->Suid, tcon->tid);
> +               trace_smb3_mknod_done(xid, tcon->tid, tcon->ses->Suid);
>
>         free_dentry_path(page);
>         free_xid(xid);
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index a55f0044d30b..274672755c19 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -298,8 +298,8 @@ static int smb2_compound_op(const unsigned int xid, s=
truct cifs_tcon *tcon,
>                                 goto finished;
>                         }
>                         num_rqst++;
> -                       trace_smb3_query_info_compound_enter(xid, ses->Su=
id,
> -                                                            tcon->tid, f=
ull_path);
> +                       trace_smb3_query_info_compound_enter(xid, tcon->t=
id,
> +                                                            ses->Suid, f=
ull_path);
>                         break;
>                 case SMB2_OP_POSIX_QUERY_INFO:
>                         rqst[num_rqst].rq_iov =3D &vars->qi_iov;
> @@ -334,18 +334,18 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
>                                 goto finished;
>                         }
>                         num_rqst++;
> -                       trace_smb3_posix_query_info_compound_enter(xid, s=
es->Suid,
> -                                                                  tcon->=
tid, full_path);
> +                       trace_smb3_posix_query_info_compound_enter(xid, t=
con->tid,
> +                                                                  ses->S=
uid, full_path);
>                         break;
>                 case SMB2_OP_DELETE:
> -                       trace_smb3_delete_enter(xid, ses->Suid, tcon->tid=
, full_path);
> +                       trace_smb3_delete_enter(xid, tcon->tid, ses->Suid=
, full_path);
>                         break;
>                 case SMB2_OP_MKDIR:
>                         /*
>                          * Directories are created through parameters in =
the
>                          * SMB2_open() call.
>                          */
> -                       trace_smb3_mkdir_enter(xid, ses->Suid, tcon->tid,=
 full_path);
> +                       trace_smb3_mkdir_enter(xid, tcon->tid, ses->Suid,=
 full_path);
>                         break;
>                 case SMB2_OP_RMDIR:
>                         rqst[num_rqst].rq_iov =3D &vars->si_iov[0];
> @@ -363,7 +363,7 @@ static int smb2_compound_op(const unsigned int xid, s=
truct cifs_tcon *tcon,
>                                 goto finished;
>                         smb2_set_next_command(tcon, &rqst[num_rqst]);
>                         smb2_set_related(&rqst[num_rqst++]);
> -                       trace_smb3_rmdir_enter(xid, ses->Suid, tcon->tid,=
 full_path);
> +                       trace_smb3_rmdir_enter(xid, tcon->tid, ses->Suid,=
 full_path);
>                         break;
>                 case SMB2_OP_SET_EOF:
>                         rqst[num_rqst].rq_iov =3D &vars->si_iov[0];
> @@ -398,7 +398,7 @@ static int smb2_compound_op(const unsigned int xid, s=
truct cifs_tcon *tcon,
>                                 goto finished;
>                         }
>                         num_rqst++;
> -                       trace_smb3_set_eof_enter(xid, ses->Suid, tcon->ti=
d, full_path);
> +                       trace_smb3_set_eof_enter(xid, tcon->tid, ses->Sui=
d, full_path);
>                         break;
>                 case SMB2_OP_SET_INFO:
>                         rqst[num_rqst].rq_iov =3D &vars->si_iov[0];
> @@ -429,8 +429,8 @@ static int smb2_compound_op(const unsigned int xid, s=
truct cifs_tcon *tcon,
>                                 goto finished;
>                         }
>                         num_rqst++;
> -                       trace_smb3_set_info_compound_enter(xid, ses->Suid=
,
> -                                                          tcon->tid, ful=
l_path);
> +                       trace_smb3_set_info_compound_enter(xid, tcon->tid=
,
> +                                                          ses->Suid, ful=
l_path);
>                         break;
>                 case SMB2_OP_RENAME:
>                         rqst[num_rqst].rq_iov =3D &vars->si_iov[0];
> @@ -469,7 +469,7 @@ static int smb2_compound_op(const unsigned int xid, s=
truct cifs_tcon *tcon,
>                                 goto finished;
>                         }
>                         num_rqst++;
> -                       trace_smb3_rename_enter(xid, ses->Suid, tcon->tid=
, full_path);
> +                       trace_smb3_rename_enter(xid, tcon->tid, ses->Suid=
, full_path);
>                         break;
>                 case SMB2_OP_HARDLINK:
>                         rqst[num_rqst].rq_iov =3D &vars->si_iov[0];
> @@ -496,7 +496,7 @@ static int smb2_compound_op(const unsigned int xid, s=
truct cifs_tcon *tcon,
>                                 goto finished;
>                         smb2_set_next_command(tcon, &rqst[num_rqst]);
>                         smb2_set_related(&rqst[num_rqst++]);
> -                       trace_smb3_hardlink_enter(xid, ses->Suid, tcon->t=
id, full_path);
> +                       trace_smb3_hardlink_enter(xid, tcon->tid, ses->Su=
id, full_path);
>                         break;
>                 case SMB2_OP_SET_REPARSE:
>                         rqst[num_rqst].rq_iov =3D vars->io_iov;
> @@ -523,8 +523,8 @@ static int smb2_compound_op(const unsigned int xid, s=
truct cifs_tcon *tcon,
>                                 goto finished;
>                         }
>                         num_rqst++;
> -                       trace_smb3_set_reparse_compound_enter(xid, ses->S=
uid,
> -                                                             tcon->tid, =
full_path);
> +                       trace_smb3_set_reparse_compound_enter(xid, tcon->=
tid,
> +                                                             ses->Suid, =
full_path);
>                         break;
>                 case SMB2_OP_GET_REPARSE:
>                         rqst[num_rqst].rq_iov =3D vars->io_iov;
> @@ -549,8 +549,8 @@ static int smb2_compound_op(const unsigned int xid, s=
truct cifs_tcon *tcon,
>                                 goto finished;
>                         }
>                         num_rqst++;
> -                       trace_smb3_get_reparse_compound_enter(xid, ses->S=
uid,
> -                                                             tcon->tid, =
full_path);
> +                       trace_smb3_get_reparse_compound_enter(xid, tcon->=
tid,
> +                                                             ses->Suid, =
full_path);
>                         break;
>                 case SMB2_OP_QUERY_WSL_EA:
>                         rqst[num_rqst].rq_iov =3D &vars->ea_iov;
> @@ -656,11 +656,11 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
>                         }
>                         SMB2_query_info_free(&rqst[num_rqst++]);
>                         if (rc)
> -                               trace_smb3_query_info_compound_err(xid,  =
ses->Suid,
> -                                                                  tcon->=
tid, rc);
> +                               trace_smb3_query_info_compound_err(xid,  =
tcon->tid,
> +                                                                  ses->S=
uid, rc);
>                         else
> -                               trace_smb3_query_info_compound_done(xid, =
ses->Suid,
> -                                                                   tcon-=
>tid);
> +                               trace_smb3_query_info_compound_done(xid, =
tcon->tid,
> +                                                                   ses->=
Suid);
>                         break;
>                 case SMB2_OP_POSIX_QUERY_INFO:
>                         idata =3D in_iov[i].iov_base;
> @@ -683,15 +683,15 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
>
>                         SMB2_query_info_free(&rqst[num_rqst++]);
>                         if (rc)
> -                               trace_smb3_posix_query_info_compound_err(=
xid,  ses->Suid,
> -                                                                        =
tcon->tid, rc);
> +                               trace_smb3_posix_query_info_compound_err(=
xid,  tcon->tid,
> +                                                                        =
ses->Suid, rc);
>                         else
> -                               trace_smb3_posix_query_info_compound_done=
(xid, ses->Suid,
> -                                                                        =
 tcon->tid);
> +                               trace_smb3_posix_query_info_compound_done=
(xid, tcon->tid,
> +                                                                        =
 ses->Suid);
>                         break;
>                 case SMB2_OP_DELETE:
>                         if (rc)
> -                               trace_smb3_delete_err(xid,  ses->Suid, tc=
on->tid, rc);
> +                               trace_smb3_delete_err(xid, tcon->tid, ses=
->Suid, rc);
>                         else {
>                                 /*
>                                  * If dentry (hence, inode) is NULL, leas=
e break is going to
> @@ -699,59 +699,59 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
>                                  */
>                                 if (inode)
>                                         cifs_mark_open_handles_for_delete=
d_file(inode, full_path);
> -                               trace_smb3_delete_done(xid, ses->Suid, tc=
on->tid);
> +                               trace_smb3_delete_done(xid, tcon->tid, se=
s->Suid);
>                         }
>                         break;
>                 case SMB2_OP_MKDIR:
>                         if (rc)
> -                               trace_smb3_mkdir_err(xid,  ses->Suid, tco=
n->tid, rc);
> +                               trace_smb3_mkdir_err(xid, tcon->tid, ses-=
>Suid, rc);
>                         else
> -                               trace_smb3_mkdir_done(xid, ses->Suid, tco=
n->tid);
> +                               trace_smb3_mkdir_done(xid, tcon->tid, ses=
->Suid);
>                         break;
>                 case SMB2_OP_HARDLINK:
>                         if (rc)
> -                               trace_smb3_hardlink_err(xid,  ses->Suid, =
tcon->tid, rc);
> +                               trace_smb3_hardlink_err(xid,  tcon->tid, =
ses->Suid, rc);
>                         else
> -                               trace_smb3_hardlink_done(xid, ses->Suid, =
tcon->tid);
> +                               trace_smb3_hardlink_done(xid, tcon->tid, =
ses->Suid);
>                         SMB2_set_info_free(&rqst[num_rqst++]);
>                         break;
>                 case SMB2_OP_RENAME:
>                         if (rc)
> -                               trace_smb3_rename_err(xid,  ses->Suid, tc=
on->tid, rc);
> +                               trace_smb3_rename_err(xid, tcon->tid, ses=
->Suid, rc);
>                         else
> -                               trace_smb3_rename_done(xid, ses->Suid, tc=
on->tid);
> +                               trace_smb3_rename_done(xid, tcon->tid, se=
s->Suid);
>                         SMB2_set_info_free(&rqst[num_rqst++]);
>                         break;
>                 case SMB2_OP_RMDIR:
>                         if (rc)
> -                               trace_smb3_rmdir_err(xid,  ses->Suid, tco=
n->tid, rc);
> +                               trace_smb3_rmdir_err(xid, tcon->tid, ses-=
>Suid, rc);
>                         else
> -                               trace_smb3_rmdir_done(xid, ses->Suid, tco=
n->tid);
> +                               trace_smb3_rmdir_done(xid, tcon->tid, ses=
->Suid);
>                         SMB2_set_info_free(&rqst[num_rqst++]);
>                         break;
>                 case SMB2_OP_SET_EOF:
>                         if (rc)
> -                               trace_smb3_set_eof_err(xid,  ses->Suid, t=
con->tid, rc);
> +                               trace_smb3_set_eof_err(xid, tcon->tid, se=
s->Suid, rc);
>                         else
> -                               trace_smb3_set_eof_done(xid, ses->Suid, t=
con->tid);
> +                               trace_smb3_set_eof_done(xid, tcon->tid, s=
es->Suid);
>                         SMB2_set_info_free(&rqst[num_rqst++]);
>                         break;
>                 case SMB2_OP_SET_INFO:
>                         if (rc)
> -                               trace_smb3_set_info_compound_err(xid,  se=
s->Suid,
> -                                                                tcon->ti=
d, rc);
> +                               trace_smb3_set_info_compound_err(xid,  tc=
on->tid,
> +                                                                ses->Sui=
d, rc);
>                         else
> -                               trace_smb3_set_info_compound_done(xid, se=
s->Suid,
> -                                                                 tcon->t=
id);
> +                               trace_smb3_set_info_compound_done(xid, tc=
on->tid,
> +                                                                 ses->Su=
id);
>                         SMB2_set_info_free(&rqst[num_rqst++]);
>                         break;
>                 case SMB2_OP_SET_REPARSE:
>                         if (rc) {
> -                               trace_smb3_set_reparse_compound_err(xid, =
 ses->Suid,
> -                                                                   tcon-=
>tid, rc);
> +                               trace_smb3_set_reparse_compound_err(xid, =
tcon->tid,
> +                                                                   ses->=
Suid, rc);
>                         } else {
> -                               trace_smb3_set_reparse_compound_done(xid,=
 ses->Suid,
> -                                                                    tcon=
->tid);
> +                               trace_smb3_set_reparse_compound_done(xid,=
 tcon->tid,
> +                                                                    ses-=
>Suid);
>                         }
>                         SMB2_ioctl_free(&rqst[num_rqst++]);
>                         break;
> @@ -764,18 +764,18 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
>                                 rbuf =3D reparse_buf_ptr(iov);
>                                 if (IS_ERR(rbuf)) {
>                                         rc =3D PTR_ERR(rbuf);
> -                                       trace_smb3_set_reparse_compound_e=
rr(xid,  ses->Suid,
> -                                                                        =
   tcon->tid, rc);
> +                                       trace_smb3_get_reparse_compound_e=
rr(xid, tcon->tid,
> +                                                                        =
   ses->Suid, rc);
>                                 } else {
>                                         idata->reparse.tag =3D le32_to_cp=
u(rbuf->ReparseTag);
> -                                       trace_smb3_set_reparse_compound_d=
one(xid, ses->Suid,
> -                                                                        =
    tcon->tid);
> +                                       trace_smb3_get_reparse_compound_d=
one(xid, tcon->tid,
> +                                                                        =
    ses->Suid);
>                                 }
>                                 memset(iov, 0, sizeof(*iov));
>                                 resp_buftype[i + 1] =3D CIFS_NO_BUFFER;
>                         } else {
> -                               trace_smb3_set_reparse_compound_err(xid, =
ses->Suid,
> -                                                                   tcon-=
>tid, rc);
> +                               trace_smb3_get_reparse_compound_err(xid, =
tcon->tid,
> +                                                                   ses->=
Suid, rc);
>                         }
>                         SMB2_ioctl_free(&rqst[num_rqst++]);
>                         break;
> @@ -792,11 +792,11 @@ static int smb2_compound_op(const unsigned int xid,=
 struct cifs_tcon *tcon,
>                                 }
>                         }
>                         if (!rc) {
> -                               trace_smb3_query_wsl_ea_compound_done(xid=
, ses->Suid,
> -                                                                     tco=
n->tid);
> +                               trace_smb3_query_wsl_ea_compound_done(xid=
, tcon->tid,
> +                                                                     ses=
->Suid);
>                         } else {
> -                               trace_smb3_query_wsl_ea_compound_err(xid,=
 ses->Suid,
> -                                                                    tcon=
->tid, rc);
> +                               trace_smb3_query_wsl_ea_compound_err(xid,=
 tcon->tid,
> +                                                                    ses-=
>Suid, rc);
>                         }
>                         SMB2_query_info_free(&rqst[num_rqst++]);
>                         break;
> --
> 2.48.1
>
>


--=20
Thanks,

Steve
