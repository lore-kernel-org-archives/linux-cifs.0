Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4925D346FA6
	for <linux-cifs@vger.kernel.org>; Tue, 12 May 2026 22:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778626703; cv=pass; b=F9PDcAhY9wnfyIkarrDbWAic+RSU/7uDAe9Im9qChjDQmAjC+KVef6WW32NTVDFC88W091c5BzZRrxPm/rC5CvJfelcfv7i3stA8hgCPNJnvkmqF7IU2nuGYlsw8vrvTujwdK7oI1JtIehMG7Jtf12HPEPJ/QJJPCRXsObT032k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778626703; c=relaxed/simple;
	bh=GSTQTf2tVT8ET8Fh5ZEGGEtqnqWatX7f2H9NLH9RwhU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gfwoTlznFG5Ny8cK5ZBDnf21xeLrQqVgeRuSRp6Bbg3ZhbAsSKyCkKgs84lzX1n4gHJ/OTasuQyoYM6OSvtA2zcZLcOiN9KKDWFqwV0l1GiBUERATfGUSngJMC3fPf32MThnaHU8yTBtcpiwdeoGb7HzZ/fraMMMsflW+B5eyNM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AePHpN+0; arc=pass smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AePHpN+0"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8acae26e564so61807876d6.2
        for <linux-cifs@vger.kernel.org>; Tue, 12 May 2026 15:58:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778626700; cv=none;
        d=google.com; s=arc-20240605;
        b=ienZ95KCWmThs2SobDsgtuaPDvJaS73ZNqg0hLSoxrraeN534DqK7TdYEaVFf33kpx
         riw9PqNEEAvBm7T/IMwGTYF8O6JaEvhipCmyGyDXZtF5t780lyEi9eC6ynfa4NWW/yAP
         8fyQ12KbL4dYcMirPxrOBhdOyko/+VvWlwgIFzmgOD1Qw9HlFNINvcKWUlo//bLLITFj
         ODeLykX56oua0ll+JKTqu4otr7YvdiETBxooYgcOATvlVrYlh2i6JxupdbNr36DWMuun
         hsG/US5dNbmiJJNmzho2Pd0rpcuRdmgFtcINqIF0gI9XjNpyU5gIWDAE7Bfvt+jh+tzW
         veWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b6iCYH16S0W/nPMagAuzgZhbrTJ+2DSpOA0/aie2qH0=;
        fh=y2SGcBhEvqUQv4AYcEB4o6E1+Ea/mHY2utcm/6bBWIw=;
        b=DRv8lHexAvEtEHPR86KiA/UpVmIo3X0AppV1m0NlUaau1yGZXtCL2kTZsyfP2xz+Vh
         1IJ4Z8axEltlPKGo0fAp/tAkES5VNuwqYpPXyoBHZLCQTk5ElYsvBZCtPDLnOWKyGZ9L
         oJ4xKStSXbL0nONk+QagKPF69W4HQPGz5jYyt4lskwwPz0OQ3WldPGLLumpgxpkw6PcX
         oa/FngWMTkIGx+AHfOXoThGW46rpu/Ovf1ZZ0uEBDNTI8Bjy5uMK5DrpUfoksJrsAR7/
         PWPnVbC9jcQK1JfYMgT0nfWwEuPxSK7kMeJr0V0uDV0Wx6le6iTwlxJKBrNhPEGHo3p7
         XJlA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778626700; x=1779231500; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b6iCYH16S0W/nPMagAuzgZhbrTJ+2DSpOA0/aie2qH0=;
        b=AePHpN+0qqDULqOoaFkMKf+yGucXZYAXlMPqQ+e68CqyQ6i/gFnht8n5Wy1shqxp3X
         /riOW7p/UUl7y/KX4I/dQ4dISrgZQKvRbuXqQDOnQeXb2gZeYknM2ro57ZSPMLGtUEjT
         TU6RJ8GeJXVaZQQtmhsfyFOD5jnYodREeMUc8YYVbzYVyoptR73Xy/YYoSvlhmg4iuiq
         /AI/wrZhkgKaKJ6RkhNUqUma0a0uAUemdhQLvtAYakPvA5dsvMZPI9qk+6hzvsUxomU0
         llLK1ZfhOgCDEzU7AAwG6MRZ+8UeO/XQetw5pbispR75530NdP+vshhlye7SAIAhgafp
         oC0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778626700; x=1779231500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b6iCYH16S0W/nPMagAuzgZhbrTJ+2DSpOA0/aie2qH0=;
        b=AwRbzhFzSCowg8/FiJ0JoXSf1AJUWAH408m6Y0TVFx8Mkmq4HjWztcyojDJPRvAqWi
         GoNRtHicCU7UjosGtzS36c2jECYi+xdisLAKX64vP+WUKyETHleZTGYqRw3E9XgRdp/I
         8kMLuuyI0bjw+t97RnQNzppd8raxOdYT07Qw/jCATeGGLrkI3ZYSW/WhCzBHokkyFgts
         udxUCqUSggi9jc7JHSukegyD4oEyZPxH/1uAKUl8jo57OXJJH9zJ1mwxEBAdTvS9mp0X
         01rMeoned7xCqYllViwyaHClbF2FY6LqcEp/SSApKqAwmOvPsYEYFb+F4vwWpt+rIldX
         Rsnw==
X-Forwarded-Encrypted: i=1; AFNElJ8rqYDdk3qKrTUcR3uChdp/ipcu3dqehi0B/6EXiQmj2wO+9xg2SpLbYAaxREaQdq79AEj9PJ2TjDYX@vger.kernel.org
X-Gm-Message-State: AOJu0YzlKfg7t0YIVI+juxgzU2OV7NbJqwkdTEksWxdZduaXu4yF/F1y
	7CMtxARAM0u7jB4KRdD7BbBuw/qh6kOf5lcb/fEzFH/m1eEsrlz0yiUMawvbwLxCXwD9MRmTmrM
	5sFdHEtSa9iQM6ItiAeJC6TZ0gD2nqMA=
X-Gm-Gg: Acq92OGpqrpzb3ovHiQ1suyACSJp+i3EyDC6DO/LMSK+LI8ruXCDpEGP91v8x1MA9JU
	ve7WirNENxJNWT2krrBfSga7smRspzCKhtbmu0pITslo4YgG78I0dsh0mMg2Vsl8Qgyoa8c+tUJ
	DKkltI090wR9he/WBlEJMyezZKa7tRg66Ck3Bq55e5lZOaeUjBait+dKxbx0pOgf0Vm6GaJGXbO
	E2k0S0Vvc4XP0XGjo7mSV3CvHmNvKEEHF6q8g6305IA6C4nw2pBT4X04G5K3uWO1ZyZKh4l615J
	cyFqa+offmRqDSkP0E2EyKp5cDmAGJppDymzEG8BnUPYM7+G3Am+e9ig9ipqmC9nhDieoVlW2Cg
	hzNW+Ig3OsdHDwJje45VhMiAKGeD51s2IaPB52bg5Y2n/0TFXrK+jgRjzXVqydssXWn2VejzpK+
	vbewtQqduyS8HgsfVg3N5JTQ==
X-Received: by 2002:a05:6214:403:b0:89c:4f67:8d17 with SMTP id
 6a1803df08f44-8c7b8cf5673mr18194756d6.8.1778626700097; Tue, 12 May 2026
 15:58:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260501060907.3859641-1-charsyam@gmail.com> <agOgelA6HpKstxZ6@precision>
In-Reply-To: <agOgelA6HpKstxZ6@precision>
From: Steve French <smfrench@gmail.com>
Date: Tue, 12 May 2026 17:58:06 -0500
X-Gm-Features: AVHnY4KXhMZYRfoUQ72xS-MrbmAay233VrEvwPZgWfa4kHZRqitUp2xgP_XcgsE
Message-ID: <CAH2r5muQbQ+rn0XH_=Va+b6qsJb2r8mCw5CFwx6=7s8xi06FtQ@mail.gmail.com>
Subject: Re: [PATCH v5] smb: client: avoid ctx corruption on failed
 multichannel remounts
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: DaeMyung Kang <charsyam@gmail.com>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Rajasi Mandal <rajasimandal@microsoft.com>, Rajasi Mandal <rajasimandalos@gmail.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 12, 2026 at 5:37=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> On Fri, May 01, 2026 at 03:09:07PM +0900, DaeMyung Kang wrote:
> > smb3_reconfigure() moves string fields out of the live mount context
> > (cifs_sb->ctx) before updating multichannel state. If the remount fails
> > after that point, the live context can be left with NULL strings or wit=
h
> > options that do not match the session state.
> >
> > Snapshot cifs_sb->ctx on entry, build the new context separately, and
> > replace cifs_sb->ctx only after the staged reconfigure work succeeds.
> > Restore the snapshot on failure paths before committing session-side
> > state.
> >
> > Also make smb3_sync_session_ctx_passwords() all-or-nothing, and keep th=
e
> > ses->password commit before smb3_update_ses_channels() so newly added
> > channels authenticate with the new credentials.
> >
> > Fixes: ef529f655a2c ("cifs: client: allow changing multichannel mount o=
ptions on remount")
> > Reported-by: RAJASI MANDAL <rajasimandalos@gmail.com>
> > Closes: https://lore.kernel.org/lkml/CAEY6_V1+dzW3OD5zqXhsWyXwrDTrg5tAM=
GZ1AJ7_GAuRE+aevA@mail.gmail.com/
> > Link: https://lore.kernel.org/lkml/xkr2dlvgibq5j6gkcxd3yhhnj4atgxw2uy4e=
ug2pxm7wy7nbms@iq6cf5taa65v/
> > Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
>
> Thanks, this looks good to me now.
>
> Just two things.
>
> First, we don't need the update_password and update_password2
> booleans in smb3_sync_session_ctx_passwords, I believe? I suggest
> cleaning that up.

They are needed to check for what memory needs to be freed so seem
logical, unless I am missing something
or are you saying that the kstrdup of ses->password (and
ses->password2) to cifs_sb->ctx->password  (see below) is not needed?

        if (ses->password &&
            cifs_sb->ctx->password &&
            strcmp(ses->password, cifs_sb->ctx->password)) {
-               kfree_sensitive(cifs_sb->ctx->password);
-               cifs_sb->ctx->password =3D kstrdup(ses->password, GFP_KERNE=
L);
-               if (!cifs_sb->ctx->password)
+               password =3D kstrdup(ses->password, GFP_KERNEL);
+               if (!password)
                        return -ENOMEM;
+               update_password =3D true;
        }


> Minor nit, restore_new_ctx is a bit misleading, cleanup_new_ctx is
> clearer, what do you think?
>
> Other than that, you can add
>
> Reviewed-by: Henrique Carvalho <henrique.carvalho@suse.com>
>
> > ---
> > v5: (feedback from Henrique Carvalho)
> >  - Drop mchan_rc / scale_busy; the early failure paths now restore
> >    cifs_sb->ctx from a snapshot taken on entry.
> >  - Build new_ctx separately and replace cifs_sb->ctx only on success.
> >  - Make smb3_sync_session_ctx_passwords() all-or-nothing: allocate
> >    both copies first, commit only when both succeed.
> >  - Switch smb3_sync_ses_chan_max() max_channels parameter to size_t
> >    to match struct cifs_ses::chan_max.
> >  - Shorten the commit message and follow nearby CIFS log style.
> >
> >  fs/smb/client/fs_context.c | 163 +++++++++++++++++++++++++------------
> >  1 file changed, 110 insertions(+), 53 deletions(-)
> >
> > diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> > index b9544eb0381b..1f0cbcf78e17 100644
> > --- a/fs/smb/client/fs_context.c
> > +++ b/fs/smb/client/fs_context.c
> > @@ -767,7 +767,7 @@ static int smb3_fs_context_parse_param(struct fs_co=
ntext *fc,
> >  static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
> >                                           void *data);
> >  static int smb3_get_tree(struct fs_context *fc);
> > -static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int =
max_channels);
> > +static void smb3_sync_ses_chan_max(struct cifs_ses *ses, size_t max_ch=
annels);
> >  static int smb3_reconfigure(struct fs_context *fc);
> >
> >  static const struct fs_context_operations smb3_fs_context_ops =3D {
> > @@ -1041,24 +1041,35 @@ do {                                           =
                       \
> >
> >  int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb, stru=
ct cifs_ses *ses)
> >  {
> > +     char *password =3D NULL, *password2 =3D NULL;
> > +     bool update_password =3D false, update_password2 =3D false;
> > +
> >       if (ses->password &&
> >           cifs_sb->ctx->password &&
> >           strcmp(ses->password, cifs_sb->ctx->password)) {
> > -             kfree_sensitive(cifs_sb->ctx->password);
> > -             cifs_sb->ctx->password =3D kstrdup(ses->password, GFP_KER=
NEL);
> > -             if (!cifs_sb->ctx->password)
> > +             password =3D kstrdup(ses->password, GFP_KERNEL);
> > +             if (!password)
> >                       return -ENOMEM;
> > +             update_password =3D true;
> >       }
> >       if (ses->password2 &&
> >           cifs_sb->ctx->password2 &&
> >           strcmp(ses->password2, cifs_sb->ctx->password2)) {
> > -             kfree_sensitive(cifs_sb->ctx->password2);
> > -             cifs_sb->ctx->password2 =3D kstrdup(ses->password2, GFP_K=
ERNEL);
> > -             if (!cifs_sb->ctx->password2) {
> > -                     kfree_sensitive(cifs_sb->ctx->password);
> > -                     cifs_sb->ctx->password =3D NULL;
> > +             password2 =3D kstrdup(ses->password2, GFP_KERNEL);
> > +             if (!password2) {
> > +                     kfree_sensitive(password);
> >                       return -ENOMEM;
> >               }
> > +             update_password2 =3D true;
> > +     }
> > +
> > +     if (update_password) {
> > +             kfree_sensitive(cifs_sb->ctx->password);
> > +             cifs_sb->ctx->password =3D password;
> > +     }
> > +     if (update_password2) {
> > +             kfree_sensitive(cifs_sb->ctx->password2);
> > +             cifs_sb->ctx->password2 =3D password2;
> >       }
> >       return 0;
> >  }
> > @@ -1072,7 +1083,7 @@ int smb3_sync_session_ctx_passwords(struct cifs_s=
b_info *cifs_sb, struct cifs_se
> >   * with the session's channel lock. This should be called whenever the=
 maximum
> >   * allowed channels for a session changes (e.g., after a remount or re=
configure).
> >   */
> > -static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int =
max_channels)
> > +static void smb3_sync_ses_chan_max(struct cifs_ses *ses, size_t max_ch=
annels)
> >  {
> >       spin_lock(&ses->chan_lock);
> >       ses->chan_max =3D max_channels;
> > @@ -1082,12 +1093,15 @@ static void smb3_sync_ses_chan_max(struct cifs_=
ses *ses, unsigned int max_channe
> >  static int smb3_reconfigure(struct fs_context *fc)
> >  {
> >       struct smb3_fs_context *ctx =3D smb3_fc2context(fc);
> > +     struct smb3_fs_context *new_ctx =3D NULL;
> > +     struct smb3_fs_context *old_ctx =3D NULL;
> >       struct dentry *root =3D fc->root;
> >       struct cifs_sb_info *cifs_sb =3D CIFS_SB(root->d_sb);
> >       struct cifs_ses *ses =3D cifs_sb_master_tcon(cifs_sb)->ses;
> >       unsigned int rsize =3D ctx->rsize, wsize =3D ctx->wsize;
> >       char *new_password =3D NULL, *new_password2 =3D NULL;
> >       bool need_recon =3D false;
> > +     bool need_mchan_update;
> >       int rc;
> >
> >       if (ses->expired_pwd)
> > @@ -1097,6 +1111,16 @@ static int smb3_reconfigure(struct fs_context *f=
c)
> >       if (rc)
> >               return rc;
> >
> > +     old_ctx =3D kzalloc_obj(*old_ctx);
> > +     if (!old_ctx)
> > +             return -ENOMEM;
> > +
> > +     rc =3D smb3_fs_context_dup(old_ctx, cifs_sb->ctx);
> > +     if (rc) {
> > +             kfree(old_ctx);
> > +             return rc;
> > +     }
> > +
> >       /*
> >        * We can not change UNC/username/password/domainname/
> >        * workstation_name/nodename/iocharset
> > @@ -1106,16 +1130,22 @@ static int smb3_reconfigure(struct fs_context *=
fc)
> >       STEAL_STRING(cifs_sb, ctx, UNC);
> >       STEAL_STRING(cifs_sb, ctx, source);
> >       STEAL_STRING(cifs_sb, ctx, username);
> > +     STEAL_STRING(cifs_sb, ctx, domainname);
> > +     STEAL_STRING(cifs_sb, ctx, nodename);
> > +     STEAL_STRING(cifs_sb, ctx, iocharset);
> >
> > -     if (need_recon =3D=3D false)
> > +     if (!need_recon) {
> >               STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
> > -     else  {
> > +     } else {
> >               if (ctx->password) {
> >                       new_password =3D kstrdup(ctx->password, GFP_KERNE=
L);
> > -                     if (!new_password)
> > -                             return -ENOMEM;
> > -             } else
> > +                     if (!new_password) {
> > +                             rc =3D -ENOMEM;
> > +                             goto restore_ctx;
> > +                     }
> > +             } else {
> >                       STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
> > +             }
> >       }
> >
> >       /*
> > @@ -1125,11 +1155,29 @@ static int smb3_reconfigure(struct fs_context *=
fc)
> >       if (ctx->password2) {
> >               new_password2 =3D kstrdup(ctx->password2, GFP_KERNEL);
> >               if (!new_password2) {
> > -                     kfree_sensitive(new_password);
> > -                     return -ENOMEM;
> > +                     rc =3D -ENOMEM;
> > +                     goto restore_ctx;
> >               }
> > -     } else
> > +     } else {
> >               STEAL_STRING_SENSITIVE(cifs_sb, ctx, password2);
> > +     }
> > +
> > +     /* if rsize or wsize not passed in on remount, use previous value=
s */
> > +     ctx->rsize =3D rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx=
->rsize;
> > +     ctx->wsize =3D wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx=
->wsize;
> > +
> > +     new_ctx =3D kzalloc_obj(*new_ctx);
> > +     if (!new_ctx) {
> > +             rc =3D -ENOMEM;
> > +             goto restore_ctx;
> > +     }
> > +
> > +     rc =3D smb3_fs_context_dup(new_ctx, ctx);
> > +     if (rc)
> > +             goto restore_ctx;
> > +
> > +     need_mchan_update =3D ctx->multichannel !=3D cifs_sb->ctx->multic=
hannel ||
> > +                         ctx->max_channels !=3D cifs_sb->ctx->max_chan=
nels;
> >
> >       /*
> >        * we may update the passwords in the ses struct below. Make sure=
 we do
> > @@ -1140,54 +1188,55 @@ static int smb3_reconfigure(struct fs_context *=
fc)
> >       /*
> >        * smb2_reconnect may swap password and password2 in case session=
 setup
> >        * failed. First get ctx passwords in sync with ses passwords. It=
 should
> > -      * be okay to do this even if this function were to return an err=
or at a
> > -      * later stage
> > +      * be done before committing new passwords.
> >        */
> >       rc =3D smb3_sync_session_ctx_passwords(cifs_sb, ses);
> >       if (rc) {
> >               mutex_unlock(&ses->session_mutex);
> > -             kfree_sensitive(new_password);
> > -             kfree_sensitive(new_password2);
> > -             return rc;
> > +             goto restore_new_ctx;
> >       }
> >
> >       /*
> > -      * now that allocations for passwords are done, commit them
> > +      * If multichannel or max_channels has changed, update the sessio=
n's channels accordingly.
> > +      * This may add or remove channels to match the new configuration=
.
> > +      */
> > +     if (need_mchan_update) {
> > +             /* Prevent concurrent scaling operations */
> > +             spin_lock(&ses->ses_lock);
> > +             if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
> > +                     spin_unlock(&ses->ses_lock);
> > +                     mutex_unlock(&ses->session_mutex);
> > +                     rc =3D -EINVAL;
> > +                     goto restore_new_ctx;
> > +             }
> > +             ses->flags |=3D CIFS_SES_FLAG_SCALE_CHANNELS;
> > +             spin_unlock(&ses->ses_lock);
> > +     }
> > +
> > +     /*
> > +      * Commit session passwords before any channel work so newly adde=
d
> > +      * channels authenticate with the new credentials.
> >        */
> >       if (new_password) {
> >               kfree_sensitive(ses->password);
> >               ses->password =3D new_password;
> > +             new_password =3D NULL;
> >       }
> >       if (new_password2) {
> >               kfree_sensitive(ses->password2);
> >               ses->password2 =3D new_password2;
> > +             new_password2 =3D NULL;
> >       }
> >
> > -     /*
> > -      * If multichannel or max_channels has changed, update the sessio=
n's channels accordingly.
> > -      * This may add or remove channels to match the new configuration=
.
> > -      */
> > -     if ((ctx->multichannel !=3D cifs_sb->ctx->multichannel) ||
> > -         (ctx->max_channels !=3D cifs_sb->ctx->max_channels)) {
> > -
> > +     if (need_mchan_update) {
> >               /* Synchronize ses->chan_max with the new mount context *=
/
> >               smb3_sync_ses_chan_max(ses, ctx->max_channels);
> > -             /* Now update the session's channels to match the new con=
figuration */
> > -             /* Prevent concurrent scaling operations */
> > -             spin_lock(&ses->ses_lock);
> > -             if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
> > -                     spin_unlock(&ses->ses_lock);
> > -                     mutex_unlock(&ses->session_mutex);
> > -                     return -EINVAL;
> > -             }
> > -             ses->flags |=3D CIFS_SES_FLAG_SCALE_CHANNELS;
> > -             spin_unlock(&ses->ses_lock);
> >
> >               mutex_unlock(&ses->session_mutex);
> >
> > -             rc =3D smb3_update_ses_channels(ses, ses->server,
> > -                                            false /* from_reconnect */=
,
> > -                                            false /* disable_mchan */)=
;
> > +             smb3_update_ses_channels(ses, ses->server,
> > +                                      false /* from_reconnect */,
> > +                                      false /* disable_mchan */);
> >
> >               /* Clear scaling flag after operation */
> >               spin_lock(&ses->ses_lock);
> > @@ -1197,22 +1246,30 @@ static int smb3_reconfigure(struct fs_context *=
fc)
> >               mutex_unlock(&ses->session_mutex);
> >       }
> >
> > -     STEAL_STRING(cifs_sb, ctx, domainname);
> > -     STEAL_STRING(cifs_sb, ctx, nodename);
> > -     STEAL_STRING(cifs_sb, ctx, iocharset);
> > -
> > -     /* if rsize or wsize not passed in on remount, use previous value=
s */
> > -     ctx->rsize =3D rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx=
->rsize;
> > -     ctx->wsize =3D wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx=
->wsize;
> > -
> >       smb3_cleanup_fs_context_contents(cifs_sb->ctx);
> > -     rc =3D smb3_fs_context_dup(cifs_sb->ctx, ctx);
> > +     memcpy(cifs_sb->ctx, new_ctx, sizeof(*new_ctx));
> > +     kfree(new_ctx);
> > +     new_ctx =3D NULL;
> > +     smb3_cleanup_fs_context(old_ctx);
> > +     old_ctx =3D NULL;
> >       smb3_update_mnt_flags(cifs_sb);
> >  #ifdef CONFIG_CIFS_DFS_UPCALL
> >       if (!rc)
> >               rc =3D dfs_cache_remount_fs(cifs_sb);
> >  #endif
> >
> > +     return rc;
> > +
> > +restore_new_ctx:
> > +     smb3_cleanup_fs_context_contents(new_ctx);
> > +restore_ctx:
> > +     kfree(new_ctx);
> > +     kfree_sensitive(new_password);
> > +     kfree_sensitive(new_password2);
> > +     smb3_cleanup_fs_context_contents(cifs_sb->ctx);
> > +     memcpy(cifs_sb->ctx, old_ctx, sizeof(*old_ctx));
> > +     kfree(old_ctx);
> > +
> >       return rc;
> >  }
> >
> > --
> > 2.43.0
> >
>


--=20
Thanks,

Steve
