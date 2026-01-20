Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64C9249E5
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 03:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768879876; cv=pass; b=ctRONEHT3sQXUOH/vQkTiJuYSXoCK0rC3vBZY5dUIyPjRDyd8lmCs+Wex3MwOU3rPOf+tk3MfLYMLfYq9r9qihed/mLbsKdQ4E3hhqzi3mDKy078utUPJdacubmJqk8NLo3JfMVP570mjyBJG6qT3UnYhkjfAcNn/IIlE+DTQlM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768879876; c=relaxed/simple;
	bh=hSv+lFIjr+jL0RIuPOev9YuAxGPh7LUkujU1Bj3ME5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nZnmGjXn8lfS6jxcgWj3FMrvJeMSN1HzNDeiWqPM3bMuOY2AL7+fnZy/NXpb2HOaqdubZOs02080oXOH8DDZzjOrVVucG7mgwBRNLLzYwYuVxtuCoQOTvPpbFSNC5VtHzRtHTwfKWQsPXurfTaQj8OQiK0C6Ecyi3zj6OLmUmew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bFWF7lkV; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bFWF7lkV"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-652fec696c9so8770090a12.3
        for <linux-cifs@vger.kernel.org>; Mon, 19 Jan 2026 19:31:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768879873; cv=none;
        d=google.com; s=arc-20240605;
        b=FJBTTOXgWRg8bRQVeCkjeMFTvVdceQC6E1QZNGpCX5bXboFc4fcQSPUdddTDxs35ZX
         ENdjIXqxDt2qZnejZPstlhJFIkeeGeWzysGfsG0k/ZCJa0lZ1goG3dhSLkZR+vpMrkqk
         znS484eie5cNW2R2HdGAcKqqjnn7oAAYpuwTWE3g8iQDJAcWXh5jhV7+cKrh8A4GaIYA
         38FTaoAMqGOeCHCZO+d0IafNgf7X2CG3wW82cYvpYnfC5f68pa3VkJiwHW3zkRYp3noX
         9ga9+aswqoo0ipVLEl0RFZ2VwDxHnL61I18XIe/zPZEku9f5ZkIFVqMmQUL8FZqxtiWJ
         XyXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9DLdt8btfOLaomE906oSd9pGWcAGD5epHO5ZuVJKmtw=;
        fh=r3JnhKOJmR4rMqjBQy1AJlUsy+gezXiY2aZpedzX954=;
        b=YBI6M5XEAJv5Rfrs9NMLiy5BPQLuvld17fhWcEYp/IKJtopKarUJN/jxK3Nsr9QMym
         S4LXKH2KwbQ7/4mP2bxzlr/lfESIrsFz3cJ+pulMUYp6COX14b43Kz0lW7HmCKqwCn/L
         YOmHhF2jJxKT9NSxwVt3lE6+HZKFAV21X5QCqj21nVO/j16rIS91pf1uP6a4qIJcqGec
         So9tqm/zFZVkNcA5OoeqnHHVJsDVvGf9DiLMmN+yw8dRa1CgRC69Uhh/WzRHRyedm1iH
         gd8zVbN5L/+U1tvouv30Dmqvkv5ZtPmQ7A6XkjtWBBthvHlD6Q5KAPFpj/Jtk1m3LFBW
         wUnA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768879873; x=1769484673; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9DLdt8btfOLaomE906oSd9pGWcAGD5epHO5ZuVJKmtw=;
        b=bFWF7lkVd/cTkP7QNA9if8OutxTIjc6txhUSUiZ6tF7ktLVaxisHNOszAFAVZl599K
         IRhLlWrfvNosiqdn9apRZioByUH2NzEqrHX/qBlSvdfp3jSb3272KEn8ltp+l1+0wD3K
         Nc95IZIIIRQtngASfzjgiFmB6Kr40quxkCz1QavR0gunFIi1yptz89dAgiOu+LABCok/
         2DgXX4xHH4I5Ls965X3NJ3DcE9WM1+1fcPO52aRWQOsMq2qP+fdqgTxfodARoR05hLkw
         ewgTcdW8eR+lVRjzWHjbArxvIk0oyZ06e+k7hpfP9RbmM9hm60X90xkymA358W3F10Aa
         b7rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768879873; x=1769484673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9DLdt8btfOLaomE906oSd9pGWcAGD5epHO5ZuVJKmtw=;
        b=FKiDrt8Iotr1a1Imh5VVSczHKWHjjV+HAdJDh3XoDHGElwnAkClRan5MnGZ4mS5Tlx
         tydFhvCHlgZ7bbL1Pl3yKNbyV5hu6Ztp93J7omHqRVbbF+CvW3WsAMIKOjnsSbxbrxhd
         EKP8WYlRoIXOqHjyZKqlPq6hmz2t2rOV6NTs9Zi1/V2bHaBlGMK5jW/JrlWbb5ERGOeQ
         l3de59bq43f/zd3XCjDk6ic/hlxOW/to9tvnMH7QlTcAYGRpJMyH8yDOYbi6RYk7DuzQ
         uxagYORKLFCiCwtfrXUCYIN+/xh42RQg7C/2PhjKMhvPWCzcV740zx1P8ac/0+GEZ3d9
         6wDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdze0tnuh//qsvvdc14+RcmOVKswrxl5h3S/u/1ykQ4Z/P+0t4ZiDlcKAlURF80SrECLbE42VjaJTd@vger.kernel.org
X-Gm-Message-State: AOJu0Ywn/uY83sg8l8T5jCp8oPWwHw3+D61q8Nce0F3A9SUq9KmZxN4Y
	sCvz87xhwujq84YMskpZJFCwGXajDH5pgbh4YjR7eHrJruUPA34xuGeS+R2Dw7y/YZbbNyaOC//
	6s8KcWle5i3/F2zrOemCaBzKfIizs4ak=
X-Gm-Gg: AY/fxX6lgFybvFBq9HY1pZHdhDZdpDPPRO8xTV324mrAhPDDCDR+Pngt+2f1p2TqtKR
	6amYxp75mDANsBOkvJsQTOfcU47fuyHd7ZwKN3dJU7BFCCGD5RAh3GOdIJA0VqJGrLaXFtzkOKe
	wPkqO+/q6UMyQR6xlSQiDCVdvfT2ni8XNt21UTQCqLnze3UHuik1Q12B/JUBKIvkkJbBmbMAVdI
	rU9xU/r5SHulRAg/u6ekg55FxedJsh3iYFGCjwlrCd5+OauoCUZIMlmGVGCwLOe+8uRBg==
X-Received: by 2002:a17:907:7211:b0:b87:965:906d with SMTP id
 a640c23a62f3a-b8792fc25dfmr1148431166b.47.1768879872937; Mon, 19 Jan 2026
 19:31:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116220641.322213-1-henrique.carvalho@suse.com> <CANT5p=r5+Fw6g-gyA25pw1pX_FCXtnxw2qUG8bt4iTNQnyrxUw@mail.gmail.com>
In-Reply-To: <CANT5p=r5+Fw6g-gyA25pw1pX_FCXtnxw2qUG8bt4iTNQnyrxUw@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 20 Jan 2026 09:01:00 +0530
X-Gm-Features: AZwV_QiN5pRXX1R9jQrQFYFUDvEaPJhj_5L2VaZUOrN9byIPZj0jrNlyYVf_uxM
Message-ID: <CANT5p=oLDiauPjeOV-4FNxB-oiu+_p5r=AbrK7V--kOZBcAncA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] smb: client: introduce multichannel async work
 during mount
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2026 at 11:00=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail=
.com> wrote:
>
> Hi Henrique,
>
> Thanks for submitting the patch.
>
> On Sat, Jan 17, 2026 at 3:37=E2=80=AFAM Henrique Carvalho
> <henrique.carvalho@suse.com> wrote:
> >
> > Mounts can experience large delays when servers advertise interfaces
> > that are unreachable from the client.
> >
> > To fix this, decouple channel addition from the synchronous mount path
> > by introducing struct mchan_mount and running channel setup as
> > background work.
> >
> > Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> > ---
> >  fs/smb/client/cifsglob.h |  5 ++++
> >  fs/smb/client/connect.c  | 58 +++++++++++++++++++++++++++++++++++++---
> >  2 files changed, 60 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> > index 3eca5bfb7030..ebb106e927c4 100644
> > --- a/fs/smb/client/cifsglob.h
> > +++ b/fs/smb/client/cifsglob.h
> > @@ -1796,6 +1796,11 @@ struct cifs_mount_ctx {
> >         struct cifs_tcon *tcon;
> >  };
> >
> > +struct mchan_mount {
> > +       struct work_struct work;
> > +       struct cifs_ses *ses;
> > +};
> > +
> >  static inline void __free_dfs_info_param(struct dfs_info3_param *param=
)
> >  {
> >         kfree(param->path_name);
> > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > index ce620503e9f7..d6c93980d1b6 100644
> > --- a/fs/smb/client/connect.c
> > +++ b/fs/smb/client/connect.c
> > @@ -64,6 +64,10 @@ static int generic_ip_connect(struct TCP_Server_Info=
 *server);
> >  static void tlink_rb_insert(struct rb_root *root, struct tcon_link *ne=
w_tlink);
> >  static void cifs_prune_tlinks(struct work_struct *work);
> >
> > +static struct mchan_mount *mchan_mount_alloc(struct cifs_ses *ses);
> > +static void mchan_mount_free(struct mchan_mount *mchan_mount);
> > +static void mchan_mount_work_fn(struct work_struct *work);
> > +
> >  /*
> >   * Resolve hostname and set ip addr in tcp ses. Useful for hostnames t=
hat may
> >   * get their ip addresses changed at some point.
> > @@ -3899,15 +3903,61 @@ int cifs_is_path_remote(struct cifs_mount_ctx *=
mnt_ctx)
> >         return rc;
> >  }
> >
> > +static struct mchan_mount *
> > +mchan_mount_alloc(struct cifs_ses *ses)
> > +{
> > +       struct mchan_mount *mchan_mount;
> > +
> > +       mchan_mount =3D kzalloc(sizeof(*mchan_mount), GFP_KERNEL);
> > +       if (!mchan_mount)
> > +               return ERR_PTR(-ENOMEM);
> > +
> > +       INIT_WORK(&mchan_mount->work, mchan_mount_work_fn);
> > +
> > +       spin_lock(&cifs_tcp_ses_lock);
> > +       cifs_smb_ses_inc_refcount(ses);
> > +       spin_unlock(&cifs_tcp_ses_lock);
> > +       mchan_mount->ses =3D ses;
> > +
> > +       return mchan_mount;
> > +}
> > +
> > +static void
> > +mchan_mount_free(struct mchan_mount *mchan_mount)
> > +{
> > +       cifs_put_smb_ses(mchan_mount->ses);
> > +       kfree(mchan_mount);
> > +}
> > +
> > +static void
> > +mchan_mount_work_fn(struct work_struct *work)
> > +{
> > +       struct mchan_mount *mchan_mount =3D container_of(work, struct m=
chan_mount, work);
> > +
> > +       smb3_update_ses_channels(mchan_mount->ses, mchan_mount->ses->se=
rver, false, false);
>
> I would keep the comment descriptions of the last two args.
> Makes it easier to read.
>
> > +
> > +       mchan_mount_free(mchan_mount);
> > +}
> > +
> >  #ifdef CONFIG_CIFS_DFS_UPCALL
> >  int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *c=
tx)
> >  {
> >         struct cifs_mount_ctx mnt_ctx =3D { .cifs_sb =3D cifs_sb, .fs_c=
tx =3D ctx, };
> > +       struct mchan_mount *mchan_mount =3D NULL;
> >         int rc;
> >
> >         rc =3D dfs_mount_share(&mnt_ctx);
> >         if (rc)
> >                 goto error;
> > +
> > +       if (ctx->multichannel) {
> > +               mchan_mount =3D mchan_mount_alloc(mnt_ctx.ses);
> > +               if (IS_ERR(mchan_mount)) {
> > +                       rc =3D PTR_ERR(mchan_mount);
> > +                       goto error;
> > +               }
> > +       }
> > +
> >         if (!ctx->dfs_conn)
> >                 goto out;
> >
> > @@ -3926,17 +3976,19 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, st=
ruct smb3_fs_context *ctx)
> >         ctx->prepath =3D NULL;
> >
> >  out:
> > -       smb3_update_ses_channels(mnt_ctx.ses, mnt_ctx.server,
> > -                                 false /* from_reconnect */,
> > -                                 false /* disable_mchan */);
> >         rc =3D mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
> >         if (rc)
> >                 goto error;
> >
> > +       if (ctx->multichannel)
> > +               queue_work(cifsiod_wq, &mchan_mount->work);
> > +
> >         free_xid(mnt_ctx.xid);
> >         return rc;
> >
> >  error:
> > +       if (ctx->multichannel && !IS_ERR_OR_NULL(mchan_mount))
> > +               mchan_mount_free(mchan_mount);
> >         cifs_mount_put_conns(&mnt_ctx);
> >         return rc;
> >  }
> > --
> > 2.50.1
> >
> >
> But otherwise, this looks good to me.
>
> --
> Regards,
> Shyam

Hi Henrique,

I reviewed this once more. Now that the adding channel logic is async
I'm concerned that there maybe a possible race with adding a channel
to ses->chans array before it is fully ready.
Earlier this would not be a problem since channel additions were
synchronous. Now that it is async, we want to make sure that the
channel is fully set up before it is added to this array.
We do not want cifs_pick_channel to pick a channel that is still not
fully initialized. Can you please look into this aspect?

--=20
Regards,
Shyam
