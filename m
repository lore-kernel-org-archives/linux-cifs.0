Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE37233D60
	for <linux-cifs@vger.kernel.org>; Fri,  8 Nov 2024 18:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731090006; cv=none; b=mqpFvkSgnx7Hq8ou+HjilIR4834nU9nRxJ4bv70D+Yi8ZLi2tkMJ7wunoNjr6GdadWaH9c497CVcoGNNN+UgM2JOONQSSNwqTJIFEsVd5K3n/GuP0yQgts0+0aqvbifuKxHYbX8mO29nq+IsTtphykP/oiaP3+yc0P5BzdLfN1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731090006; c=relaxed/simple;
	bh=mmPm4RDxK6Q3CDVJrgw2yuCavOQLo7KAtZ1N/VCEgn4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lFpoIszhfK1pb1mvU3u1b6JCXAeftESouIQ2Y0BPCrB4GDvSvKDI5CdW3ts+yiuflX/rrKDJNgKBtEGRGInIj3buRKJVWv+iWypq3O37/u1e84L2CSVNqabWE45L8j63h8/obmXOhszZfirbx7ZzVPbUC15Zndl82njmNu4mOwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QBQmBPxq; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QBQmBPxq"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-539f76a6f0dso2680812e87.1
        for <linux-cifs@vger.kernel.org>; Fri, 08 Nov 2024 10:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731090003; x=1731694803; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wHLHa9lSlTNVPcwLhwEnVF08BPx8GSIXuwNd8O2kVxU=;
        b=QBQmBPxqBIKxueP3TbgyrWsl5b6dC/npgvlzYrF2RoCYRFC95dS56oifMt4/Yk/KtT
         BM1FtoDTt0lsuOloBdBCMHImKDdPgSxXLhnoyhxnKDS48c8SdDhOevPqCNPqXK/QOnku
         Qa9t7aYzmw9wR/H7tuFiOBaB2/bBSrkJ2H+ZmQkzhQ3oWkGRcoyStoS50oXZadKczSSM
         LksVG+JKua11J796XjJ5+CwP8ErsY+hOx0OJfu1R3/pDqVyoR3OH9RNdG7OwuIWzgxBB
         6+6p1NSBk+uE1iECqwmZLhK+grlng4HO3sFjkJ3e5HnIaLptn/AHWQafrVdS7p4bRndY
         TI3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731090003; x=1731694803;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wHLHa9lSlTNVPcwLhwEnVF08BPx8GSIXuwNd8O2kVxU=;
        b=uBfIl1gvH//FM5PrTGE1rs7SMa6jC46Xt/O7cJW7l5O91/prn4rgWAKSXoBoEYa7qr
         6ZlDORChQVg+dD0P0uaDDmNu2BvQj2b4Vbh9i89m68TuM4jWFnKiIGBwEC1saesXHTeX
         Vdv753BsFQBBYpCdwXP4zhNJFY83RqK5G1Qel77AeOca8Det3ln/WfcDwLQ+rfC5zK9E
         GB580xSPkuJiA8XXShBeWtmzqj/QGyaGb7F52jo/PH/LgFCHHR7PSg8ELbq0ML6BeToC
         6P150sK4THiR3zAHBPPf6yIz0fU9ds1Ar486LBjtgo93XVb9icbYaa78Q5/mVzoTzQXM
         9Shw==
X-Forwarded-Encrypted: i=1; AJvYcCVaUiUfC3zlyTZjm5XSkxqaFmBFDPifV0zYo6jN0IT0Cij6Jc5fAs76REvT9cXMgWlUCzGLaqeWhpSr@vger.kernel.org
X-Gm-Message-State: AOJu0YxbgAkBVM+ujIeW4JEDC0+TjOebEWCrJLFwL6i9YC1U87VPgrE7
	J4MvEN6OFtheJJFHO0H6ecMa3JI7VI91gpHLA0S1QPVdXtnEV8ZdAjoSsvB2Vd+0W200s5EcNeX
	po6exgVdr0O96hNyVugMLkrHI5hY=
X-Google-Smtp-Source: AGHT+IGT4BH5Im9piCaAYM+u+c8fbsfRXvPzC5gS4J76I+lHbZIsR56h6t8aiWhZsuAPyX2axlQJPOhdpUzRKT2gX74=
X-Received: by 2002:a2e:9549:0:b0:2fb:6465:3198 with SMTP id
 38308e7fff4ca-2ff201e6deamr21378931fa.5.1731090002355; Fri, 08 Nov 2024
 10:20:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241030142829.234828-1-meetakshisetiyaoss@gmail.com>
 <1f8a225b0d16fdfa05c417e0f6602489@manguebit.com> <CANT5p=rm90eHDeA669yRNdKvT=GL+NE1PVTJVS-htQ8pbfiwUA@mail.gmail.com>
In-Reply-To: <CANT5p=rm90eHDeA669yRNdKvT=GL+NE1PVTJVS-htQ8pbfiwUA@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 8 Nov 2024 23:49:51 +0530
Message-ID: <CANT5p=pFCbi1H-JzRLx5XqL4Qwy-YbOWAX6XmoWXezSn2i__mQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: during remount, make sure passwords are in sync
To: Paulo Alcantara <pc@manguebit.com>
Cc: meetakshisetiyaoss@gmail.com, smfrench@gmail.com, sfrench@samba.org, 
	sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org, 
	bharathsm.hsk@gmail.com, Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 8, 2024 at 5:47=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.c=
om> wrote:
>
> Hi Paulo,
>
> Thanks for the review.
>
> On Fri, Nov 8, 2024 at 12:01=E2=80=AFAM Paulo Alcantara <pc@manguebit.com=
> wrote:
> >
> > meetakshisetiyaoss@gmail.com writes:
> >
> > > From: Shyam Prasad N <sprasad@microsoft.com>
> > >
> > > We recently introduced a password2 field in both ses and ctx structs.
> > > This was done so as to allow the client to rotate passwords for a mou=
nt
> > > without any downtime. However, when the client transparently handles
> > > password rotation, it can swap the values of the two password fields
> > > in the ses struct, but not in smb3_fs_context struct that hangs off
> > > cifs_sb. This can lead to a situation where a remount unintentionally
> > > overwrites a working password in the ses struct.
> >
> > I don't see password rotation being handled for SMB1.  I mounted a shar=
e
> > with 'vers=3D1.0,password=3Dfoo,password2=3Dbar' and didn't get any war=
nings
> > or errors about it being usupported.  I think users would like to have
> > that.
>
> Good point. We could add support for SMB1 or document clearly that
> this is only for SMB2+.
>
> >
> > What about SMB sessions from cifs_tcon::dfs_ses_list?  I don't see thei=
r
> > password getting updated over remount.
>
> This is in our to-do list as well.

I did some code reading around how DFS automount works.
@Paulo Alcantara Correct me if I'm wrong, but it sounds like we make
an assumption that when a DFS namespace has a junction to another
share, the same credentials are to be used to perform the mount of
that share. Is that always the case?
If we go by that assumption, for password2 to work with DFS mounts, we
only need to make sure that in cifs_do_automount, cur_ctx passwords
are synced up to the current ses passwords. That should be quite easy.

>
> >
> > If you don't plan to support any of the above, then don't allow users t=
o
> > mount/remount when password rotation can't be handled.
> >
> > > In order to fix this, we first get the passwords in ctx struct
> > > in-sync with ses struct, before replacing them with what the password=
s
> > > that could be passed as a part of remount.
> > >
> > > Also, in order to avoid race condition between smb2_reconnect and
> > > smb3_reconfigure, we make sure to lock session_mutex before changing
> > > password and password2 fields of the ses structure.
> > >
> > > Fixes: 35f834265e0d ("smb3: fix broken reconnect when password changi=
ng on the server by allowing password rotation")
> > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > > Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
> > > ---
> > >  fs/smb/client/fs_context.c | 69 +++++++++++++++++++++++++++++++++---=
--
> > >  1 file changed, 60 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> > > index 5c5a52019efa..73610e66c8d9 100644
> > > --- a/fs/smb/client/fs_context.c
> > > +++ b/fs/smb/client/fs_context.c
> > > @@ -896,6 +896,7 @@ static int smb3_reconfigure(struct fs_context *fc=
)
> > >       struct dentry *root =3D fc->root;
> > >       struct cifs_sb_info *cifs_sb =3D CIFS_SB(root->d_sb);
> > >       struct cifs_ses *ses =3D cifs_sb_master_tcon(cifs_sb)->ses;
> > > +     char *new_password =3D NULL, *new_password2 =3D NULL;
> > >       bool need_recon =3D false;
> > >       int rc;
> > >
> > > @@ -915,21 +916,71 @@ static int smb3_reconfigure(struct fs_context *=
fc)
> > >       STEAL_STRING(cifs_sb, ctx, UNC);
> > >       STEAL_STRING(cifs_sb, ctx, source);
> > >       STEAL_STRING(cifs_sb, ctx, username);
> > > +
> > >       if (need_recon =3D=3D false)
> > >               STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
> > >       else  {
> > > -             kfree_sensitive(ses->password);
> > > -             ses->password =3D kstrdup(ctx->password, GFP_KERNEL);
> > > -             if (!ses->password)
> > > -                     return -ENOMEM;
> > > -             kfree_sensitive(ses->password2);
> > > -             ses->password2 =3D kstrdup(ctx->password2, GFP_KERNEL);
> > > -             if (!ses->password2) {
> > > -                     kfree_sensitive(ses->password);
> > > -                     ses->password =3D NULL;
> > > +             if (ctx->password) {
> > > +                     new_password =3D kstrdup(ctx->password, GFP_KER=
NEL);
> > > +                     if (!new_password)
> > > +                             return -ENOMEM;
> > > +             } else
> > > +                     STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
> > > +     }
> > > +
> > > +     /*
> > > +      * if a new password2 has been specified, then reset it's value
> > > +      * inside the ses struct
> > > +      */
> > > +     if (ctx->password2) {
> > > +             new_password2 =3D kstrdup(ctx->password2, GFP_KERNEL);
> > > +             if (!new_password2) {
> > > +                     if (new_password)
> >
> > Useless non-NULL check as kfree_sensitive() already handles it.
> >
> > > +                             kfree_sensitive(new_password);
> > >                       return -ENOMEM;
> > >               }
> > > +     } else
> > > +             STEAL_STRING_SENSITIVE(cifs_sb, ctx, password2);
> > > +
> > > +     /*
> > > +      * we may update the passwords in the ses struct below. Make su=
re we do
> > > +      * not race with smb2_reconnect
> > > +      */
> > > +     mutex_lock(&ses->session_mutex);
> > > +
> > > +     /*
> > > +      * smb2_reconnect may swap password and password2 in case sessi=
on setup
> > > +      * failed. First get ctx passwords in sync with ses passwords. =
It should
> > > +      * be okay to do this even if this function were to return an e=
rror at a
> > > +      * later stage
> > > +      */
> > > +     if (ses->password &&
> > > +         cifs_sb->ctx->password &&
> > > +         strcmp(ses->password, cifs_sb->ctx->password)) {
> > > +             kfree_sensitive(cifs_sb->ctx->password);
> > > +             cifs_sb->ctx->password =3D kstrdup(ses->password, GFP_K=
ERNEL);
> >
> > Missing allocation failure check.
> >
> > > +     }
> > > +     if (ses->password2 &&
> > > +         cifs_sb->ctx->password2 &&
> > > +         strcmp(ses->password2, cifs_sb->ctx->password2)) {
> > > +             kfree_sensitive(cifs_sb->ctx->password2);
> > > +             cifs_sb->ctx->password2 =3D kstrdup(ses->password2, GFP=
_KERNEL);
> >
> > Ditto.
> >
> > > +     }
> > > +
> > > +     /*
> > > +      * now that allocations for passwords are done, commit them
> > > +      */
> > > +     if (new_password) {
> > > +             kfree_sensitive(ses->password);
> > > +             ses->password =3D new_password;
> > > +     }
> > > +     if (new_password2) {
> > > +             kfree_sensitive(ses->password2);
> > > +             ses->password2 =3D new_password2;
> > >       }
> > > +
> > > +     mutex_unlock(&ses->session_mutex);
> > > +
> > >       STEAL_STRING(cifs_sb, ctx, domainname);
> > >       STEAL_STRING(cifs_sb, ctx, nodename);
> > >       STEAL_STRING(cifs_sb, ctx, iocharset);
> > > --
> > > 2.46.0.46.g406f326d27
>
>
>
> --
> Regards,
> Shyam



--=20
Regards,
Shyam
