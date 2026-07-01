Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC98A481FD4
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 13:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782912173; cv=pass; b=GnuHU1cg2G2E9OSXDFN/MlYzw1QhC/s6jot8nbeUMdUhVIvDWkUXOYdBeu2qVrCI2ahQhT1QwNiuNeOIB7cK1sIP/42+J0MM0PbIa/IOd5PXXj9fxJ40KVYVvh9RAgb/oeGgEdVQx4N4ZGPASgducmfsWddwTVfW1dyessu01Rk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782912173; c=relaxed/simple;
	bh=l1JZZOMwldKH+vAwt8JE3tL7W4vKwsI+BgJBpbx74yA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o/bt4fRj2nV7Aq9eI8qJ4fBMNESvdD+9JEGjSQkoMGJ9DmDwAAKMJEaW66vkSH+g1roWQZeDlHsqk0Mvo3ytvNJcfZwCNJLvAONYdQFYHDrAGwuXIviHbunjPziEDdkxi+rO3LzVn9wOIr8VNL2u8VP46K3eh7+QNfYyvTACowQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LSNOiXYF; arc=pass smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LSNOiXYF"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8efbafa1bacso4151626d6.1
        for <linux-cifs@vger.kernel.org>; Wed, 01 Jul 2026 06:22:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782912171; cv=none;
        d=google.com; s=arc-20260327;
        b=NorPFRTRh9W+QL6grTbQTi9OMwomAlu5GoanvcsZn50LB0+wPgg6K8iHuxHLpm1HKS
         87EG9wCZMm/6TosiykRHnvdG/bV9S0ccwVvSwArNlPV8xgUI7HCfay7DicURfJhsRRJM
         /ciF7KlkLQWAqLqlLyNBVJKkZq7ktGhnGo0mXHcuoTuR3izXPZfMsM3vkNfLu/VZjHMB
         IFh30irwfILN5TDL223q4hcVZ0FQJrx3rRKilYss+4Ta6TFo9EJ0C6nmx4Yjnvz9n3j4
         5Cs3X/xwLaZ2L0ksiMwoeaI6SZ/ivo8Jk94RteoHMiuvPeBpZPj/SQ1/T409RtH66vVW
         74WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5mmApg2yStCma6fHM1nvozOhWXIo6WfD9QC9kGdViB8=;
        fh=vPxIfTVElyuMvvt5J0+7oO+tL8kgKdqS+va99nc366M=;
        b=Oxg8/zIOKgofHBNnMtClP1agwYP1qDfYnY4CMdAAVrQwvtuWJAFavb55DfpF3u1QAH
         whhLvfuvtLO7JlDcdfALeKrTvXcpkUtNvVUIccJQuo+WQ9VD9KIxyBA4kdn+mP9TSqUU
         dOW2u+aOEbzmOG6c/glGuHMwfaue9jeDFlrN6aodSdQP8DBoNk1LTDUgx6eSlO/Bhqrp
         BQJT0arRwdlDjqe0EKLX8HmpECKxYi/cPNSxHG2S6KNRxYTTuk9LceNZvEZbikEJazp6
         CDEQNSSqq5p2i/iGoPIPHLJdJ49TSFec33dzztpdVdmx13KEwjkSNTA64aA5ljyvk+Gu
         2Luw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782912171; x=1783516971; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5mmApg2yStCma6fHM1nvozOhWXIo6WfD9QC9kGdViB8=;
        b=LSNOiXYF6Kp3LGPlr3uB+xrvp7HRRD75hO/N6IPyGHZQQECYTbBA2ov3H192VpD0xO
         9i2rlzGT6D1w7Ah45L/eINb9MVXoPKsL2r3kf15ITqdxMUOG85E8f8oHWu1O8bUqiPeM
         r5UGy3h22VDhrZPIiFGHPjOE5ymTB8f3DhIqAkdqhIz2heRQSbtB+Kqy6qFQScslJZxQ
         eqtQLLyEPeE5XQyOY3cestk5T34+2hjnXBziHIMPHxWr/S2wl+af/TeLLE6WYH3r/dJP
         EDMtak5OBD5lCVth+VSTsgp9Dezx0cjFFYLd9GQJXgLhaXz14sbCOOYu48aPvDMyk8XH
         N+0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782912171; x=1783516971;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5mmApg2yStCma6fHM1nvozOhWXIo6WfD9QC9kGdViB8=;
        b=RmCX9wP+VGyAbAUFGYtVzyRa6ih0ewbVdeEgir/hmXwzleIquih3vFgXYtaKcScVge
         ZjPzZ3kf4Xf2LWTCE0i7EZzbncGVAUtLeOAiesaNQnkKre6m7u5G80xeQJNuiYyi4Aqd
         KwmCmHL0GCyrxRr3m0MPVJ9oU9uwiW7ESHJK22MHDkxck5+InCfbJkq3kYUsFCDI+SVu
         vJJcgObOaCdHqZP0ib7V68yK/hp5gH8tdaWu031Q+PYH0fBesx2j8VxpUVPARvpjjO5M
         oCSuIBhSFd3Ax2rdh5X4Oashfn5mF69l4E7pV8w6cgHfe0gi55XNpe/1GFl4oZcHEqaa
         aknA==
X-Gm-Message-State: AOJu0Yzb5vfevqVhH2uE90ZrbYmGrgLqJcPg3EM2WcydhWQ7+BpyVrm/
	9NPqO++f/ubeQ1WILNK2BQ9Ly8VuG6hJ8FW4gunsDjO7/wN5Jv4XcdQKk9PdRO/yIdEZPDvtn+L
	9Mdeo3OXI55asu9J8JSqO2UPeaEdLkJE=
X-Gm-Gg: AfdE7ckzVfHUyqa0BTxKmq1ffgSVgbcCYGdcnM/D7rneescWvFVQY3Me0hxrVplmXWJ
	HH/4PXkQ81vMBIULXJKkkldaZ0v0ESIBYjzSiT9LSS07o5k7YH8ZFIjDnut58D/+PBJMk3CGikC
	EoNwEqr5eYVI2X1OkQSk9Bw8pvJx0MNCIQni0r9rDI/bMdEp6Rbau9v8uUiPgYUU5HXdjirZhgs
	Rx+oR0FWpYb32fmBjuBZ/Lcz1OVhzvpwjpFxowiiA3X4OE+uU+sPk9HisQJ8v66i/9AXTIE6L6J
	LmitS+wyCgR5+HHDb/oXoboASUAFkh6K2G6LoMGmpHRaqHxiHtITAbqhuMWJaVyrgZj3G/y8mfY
	61OQLGs268SaqzneD23s8ZIYvOtpTc69j6ZzE4ggz5A4NOzi9F8XvyeqM1K3I/YA8gom0J+PqZA
	muAFJduHz/9bc=
X-Received: by 2002:a05:6214:8012:b0:8e9:f5de:d5b8 with SMTP id
 6a1803df08f44-8f3c98c1c05mr18897566d6.47.1782912170156; Wed, 01 Jul 2026
 06:22:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701103313.3499731-1-rajasimandalos@gmail.com>
In-Reply-To: <20260701103313.3499731-1-rajasimandalos@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 1 Jul 2026 08:22:37 -0500
X-Gm-Features: AVVi8Cd5gB1LASYsvpeG1Bw9cd688VTkwtv2r3vWo4nqONSiZLRCew79hQ39fGA
Message-ID: <CAH2r5mtqjhcnCbT0HyipdrAW2ZjH5g4e_yRRVt9Oza=afiJB8g@mail.gmail.com>
Subject: Re: [PATCH 1/2] smb: client: review fixes for remount ctx/retrans
 sync (patches 1-4)
To: rajasimandalos@gmail.com
Cc: linux-cifs@vger.kernel.org, Rajasi Mandal <rajasimandal@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

do you have updated/rebased versions of the patches with the fixes?

Can you resend me the patches?

On Wed, Jul 1, 2026 at 5:35=E2=80=AFAM <rajasimandalos@gmail.com> wrote:
>
> From: Rajasi Mandal <rajasimandal@microsoft.com>
>
> Fold the review feedback for the first four remount patches into one
> change.  Each fix, in two lines:
>
> - ctx sync (patch 1): sync runtime state into a private reconfigure
>   context, never the shared cifs_sb->ctx, to avoid racing concurrent
>   fspick/remount and /proc/mounts readers.
> - ctx sync (patch 1): compare the new context against a runtime-synced
>   private base_ctx (dup + sync), freed before commit, instead of the raw
>   cifs_sb->ctx.
> - ctx sync (patch 1): drop the fabricated "nopersistent =3D !use_persiste=
nt"
>   derivation; nopersistent is an independent user option and must keep th=
e
>   dup'd value.
> - block options (patch 2): mention "(signloosely)" in the ignore_signatur=
e
>   remount rejection so the message names the user-facing option.
> - retrans (patch 3): read/write server->retrans with READ_ONCE/WRITE_ONCE
>   to pair the new remount writer with the lockless retry-path reader.
> - retrans (patch 3): seed the baseline from READ_ONCE(server->retrans) so=
 a
>   bare remount carries the live value forward instead of clobbering it.
> - block cache (patch 4): reword the cache-mode comment to state that
>   cache=3Dro sets cache_ro and cache=3Dsingleclient sets cache_rw.
>
> Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> ---
>  fs/smb/client/cifsfs.c     |   6 +-
>  fs/smb/client/connect.c    |   4 +-
>  fs/smb/client/fs_context.c | 122 +++++++++++++++++++++++++++++--------
>  fs/smb/client/smb2ops.c    |   2 +-
>  4 files changed, 104 insertions(+), 30 deletions(-)
>
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index 6b97f7a91235..e99d427fb2c5 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -612,6 +612,7 @@ cifs_show_options(struct seq_file *s, struct dentry *=
root)
>         struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
>         struct sockaddr *srcaddr;
>         unsigned int sbflags;
> +       unsigned int retrans;
>
>         srcaddr =3D (struct sockaddr *)&tcon->ses->server->srcaddr;
>
> @@ -765,8 +766,9 @@ cifs_show_options(struct seq_file *s, struct dentry *=
root)
>                 seq_printf(s, ",rasize=3D%u", cifs_sb->ctx->rasize);
>         if (tcon->ses->server->min_offload)
>                 seq_printf(s, ",esize=3D%u", tcon->ses->server->min_offlo=
ad);
> -       if (tcon->ses->server->retrans)
> -               seq_printf(s, ",retrans=3D%u", tcon->ses->server->retrans=
);
> +       retrans =3D READ_ONCE(tcon->ses->server->retrans);
> +       if (retrans)
> +               seq_printf(s, ",retrans=3D%u", retrans);
>         seq_printf(s, ",echo_interval=3D%lu",
>                         tcon->ses->server->echo_interval / HZ);
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 104658e318b6..14dd472c2b0f 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -1657,7 +1657,7 @@ static int match_server(struct TCP_Server_Info *ser=
ver,
>         if (server->min_offload !=3D ctx->min_offload)
>                 return 0;
>
> -       if (server->retrans !=3D ctx->retrans)
> +       if (READ_ONCE(server->retrans) !=3D ctx->retrans)
>                 return 0;
>
>         return 1;
> @@ -1872,7 +1872,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
>          */
>         __module_get(THIS_MODULE);
>         tcp_ses->min_offload =3D ctx->min_offload;
> -       tcp_ses->retrans =3D ctx->retrans;
> +       WRITE_ONCE(tcp_ses->retrans, ctx->retrans);
>         /*
>          * at this point we are the only ones with the pointer
>          * to the struct since the kernel thread not created yet
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 53f986d8e9e0..89bf6f4604b3 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -928,18 +928,22 @@ static void smb3_fs_context_free(struct fs_context =
*fc)
>  }
>
>  /*
> - * Sync cifs_sb->ctx with runtime state from tcon/server/ses so the
> - * baseline matches what cifs_show_options() displays.  Wide fields
> - * (dstaddr, ops/vals) are protected by the matching server/tcon lock;
> - * the remaining word-sized scalars rely on the same unsynchronized-read
> - * pattern already used by cifs_show_options().
> + * Sync a private reconfigure context with runtime state from
> + * tcon/server/ses so the baseline matches what cifs_show_options()
> + * displays.  @ctx must be the caller's freshly-duplicated context, not
> + * the live cifs_sb->ctx: this function writes into @ctx, and mutating
> + * the shared cifs_sb->ctx here would race with concurrent fspick/remoun=
t
> + * and /proc/mounts readers.  Wide fields (dstaddr, ops/vals) are read
> + * under the matching server/tcon lock; the remaining word-sized scalars
> + * rely on the same unsynchronized-read pattern already used by
> + * cifs_show_options().
>   */
> -static int smb3_sync_ctx_from_runtime(struct cifs_sb_info *cifs_sb)
> +static int smb3_sync_ctx_from_runtime(struct cifs_sb_info *cifs_sb,
> +                                     struct smb3_fs_context *ctx)
>  {
>         struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
>         struct TCP_Server_Info *server =3D tcon->ses->server;
>         struct cifs_ses *ses =3D tcon->ses;
> -       struct smb3_fs_context *ctx =3D cifs_sb->ctx;
>         const char *domain;
>         int unicode;
>
> @@ -961,6 +965,16 @@ static int smb3_sync_ctx_from_runtime(struct cifs_sb=
_info *cifs_sb)
>         ctx->nosharesock =3D server->nosharesock;
>         spin_unlock(&server->srv_lock);
>
> +       /*
> +        * retrans lives on the shared TCP_Server_Info and can be updated=
 by
> +        * a remount of any mount sharing the connection.  Sync it from t=
he
> +        * live server so a bare remount carries the current value forwar=
d
> +        * instead of writing a stale per-mount copy back in
> +        * smb3_sync_server_opts().  Read with READ_ONCE to pair with the
> +        * lockless WRITE_ONCE writers and the runtime retry-path reader.
> +        */
> +       ctx->retrans =3D READ_ONCE(server->retrans);
> +
>         /*
>          * tcon->unix_ext can be flipped post-mount by reset_cifs_unix_ca=
ps()
>          * on SMB1 reconnect (smb1_reconnect path). Read under tc_lock to=
 pair
> @@ -978,15 +992,27 @@ static int smb3_sync_ctx_from_runtime(struct cifs_s=
b_info *cifs_sb)
>         }
>         spin_unlock(&tcon->tc_lock);
>         ctx->seal         =3D tcon->seal;
> +       /*
> +        * persistent reflects the live tcon->use_persistent so the basel=
ine
> +        * matches what cifs_show_options() reports (persistenthandles). =
 Do
> +        * NOT derive nopersistent from use_persistent: persistent and
> +        * nopersistent are independent user options and use_persistent i=
s a
> +        * derived runtime result.  nopersistent is not reported by
> +        * cifs_show_options(), so it must keep the user's original value
> +        * (carried by the dup); fabricating it here would, after the
> +        * reconfigure commits the ctx, wrongly suppress persistent-handl=
e
> +        * auto-enable on continuous-availability shares at reconnect.
> +        */
>         ctx->persistent   =3D tcon->use_persistent;
> -       ctx->nopersistent =3D !tcon->use_persistent;
>         ctx->resilient    =3D tcon->use_resilient;
>         ctx->witness      =3D tcon->use_witness;
>
>         /*
>          * Session fields: domainName and unicode are effectively
>          * write-once (set during session setup, never freed/replaced
> -        * while the session exists), so plain reads are safe.
> +        * while the session exists), so plain reads are safe.  @ctx is
> +        * the caller's private copy, so filling in a missing domainname
> +        * here cannot leak or race.
>          */
>         domain =3D ses->domainName;
>         unicode =3D ses->unicode;
> @@ -1180,7 +1206,7 @@ static int smb3_verify_reconfigure_ctx(struct fs_co=
ntext *fc,
>                 return -EINVAL;
>         }
>         if (new_ctx->ignore_signature !=3D old_ctx->ignore_signature) {
> -               cifs_errorf(fc, "can not change ignore_signature during r=
emount\n");
> +               cifs_errorf(fc, "can not change ignore_signature (signloo=
sely) during remount\n");
>                 return -EINVAL;
>         }
>         if (new_ctx->seal !=3D old_ctx->seal) {
> @@ -1212,7 +1238,11 @@ static int smb3_verify_reconfigure_ctx(struct fs_c=
ontext *fc,
>                 cifs_errorf(fc, "can not change rdma during remount\n");
>                 return -EINVAL;
>         }
> -       /* init default: cache_ro =3D false, cache_rw =3D false (i.e. cac=
he=3Dstrict) */
> +       /*
> +        * cache=3Dro sets cache_ro and cache=3Dsingleclient sets cache_r=
w; the
> +        * other cache modes (strict/loose/none) leave both clear and are
> +        * handled separately in smb3_update_mnt_flags().
> +        */
>         if (new_ctx->cache_ro !=3D old_ctx->cache_ro) {
>                 cifs_errorf(fc, "can not change cache=3Dro during remount=
\n");
>                 return -EINVAL;
> @@ -1340,7 +1370,7 @@ static void smb3_sync_server_opts(struct cifs_sb_in=
fo *cifs_sb)
>         struct TCP_Server_Info *server =3D cifs_sb_master_tcon(cifs_sb)->=
ses->server;
>         struct smb3_fs_context *ctx =3D cifs_sb->ctx;
>
> -       server->retrans =3D ctx->retrans;
> +       WRITE_ONCE(server->retrans, ctx->retrans);
>  }
>
>  static int smb3_reconfigure(struct fs_context *fc)
> @@ -1348,6 +1378,7 @@ static int smb3_reconfigure(struct fs_context *fc)
>         struct smb3_fs_context *ctx =3D smb3_fc2context(fc);
>         struct smb3_fs_context *new_ctx =3D NULL;
>         struct smb3_fs_context *old_ctx =3D NULL;
> +       struct smb3_fs_context *base_ctx =3D NULL;
>         struct dentry *root =3D fc->root;
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(root->d_sb);
>         struct cifs_ses *ses =3D cifs_sb_master_tcon(cifs_sb)->ses;
> @@ -1360,9 +1391,37 @@ static int smb3_reconfigure(struct fs_context *fc)
>         if (ses->expired_pwd)
>                 need_recon =3D true;
>
> -       rc =3D smb3_verify_reconfigure_ctx(fc, ctx, cifs_sb->ctx, need_re=
con);
> +       /*
> +        * Compare the new context against a runtime-synced baseline, not=
 the
> +        * raw cifs_sb->ctx.  smb3_init_fs_context() syncs the new contex=
t
> +        * (fc->fs_private) from runtime state, so the comparison baselin=
e must
> +        * be synced the same way; otherwise a field that drifted at runt=
ime
> +        * (e.g. dstaddr after witness failover, or use_persistent auto-e=
nabled
> +        * on a continuous-availability share) would look like a user-req=
uested
> +        * change and be rejected on an otherwise bare remount.  Sync a p=
rivate
> +        * copy rather than cifs_sb->ctx: s_umount serializes reconfigure=
s, but
> +        * not the fspick/fsconfig init path, which dup()s cifs_sb->ctx i=
n
> +        * smb3_init_fs_context() before reconfigure_super() takes s_umou=
nt.  An
> +        * in-place sync would therefore race that lockless dup (e.g. a t=
orn
> +        * read of the 128-byte dstaddr).
> +        */
> +       base_ctx =3D kzalloc_obj(*base_ctx);
> +       if (!base_ctx)
> +               return -ENOMEM;
> +       rc =3D smb3_fs_context_dup(base_ctx, cifs_sb->ctx);
>         if (rc)
> -               return rc;
> +               goto free_base_ctx;
> +       rc =3D smb3_sync_ctx_from_runtime(cifs_sb, base_ctx);
> +       if (rc)
> +               goto cleanup_base_ctx;
> +
> +       rc =3D smb3_verify_reconfigure_ctx(fc, ctx, base_ctx, need_recon)=
;
> +       if (rc)
> +               goto cleanup_base_ctx;
> +
> +       smb3_cleanup_fs_context_contents(base_ctx);
> +       kfree(base_ctx);
> +       base_ctx =3D NULL;
>
>         rc =3D smb3_handle_conflicting_options(fc);
>         if (rc)
> @@ -1537,6 +1596,13 @@ static int smb3_reconfigure(struct fs_context *fc)
>  free_old_ctx:
>         kfree(old_ctx);
>
> +       return rc;
> +
> +cleanup_base_ctx:
> +       smb3_cleanup_fs_context_contents(base_ctx);
> +free_base_ctx:
> +       kfree(base_ctx);
> +
>         return rc;
>  }
>
> @@ -2258,28 +2324,34 @@ int smb3_init_fs_context(struct fs_context *fc)
>          * instead of building one from scratch with init defaults.
>          *
>          * VFS sets fc->root before calling init_fs_context for reconfigu=
re,
> -        * so we can access the existing superblock's context.  We first =
sync
> -        * cifs_sb->ctx with runtime state (tcon/server/ses) so that ctx
> -        * matches what cifs_show_options() displays.  Then we dup old_ct=
x
> -        * into new_ctx.  The parser will overwrite only the options
> -        * explicitly passed on remount, so any difference between new_ct=
x
> -        * and old_ctx in smb3_verify_reconfigure_ctx() represents a real=
,
> -        * intentional change by the user.
> +        * so we can access the existing superblock's context.  We dup th=
e
> +        * live cifs_sb->ctx into a private new_ctx, then sync new_ctx wi=
th
> +        * runtime state (tcon/server/ses) so it matches what
> +        * cifs_show_options() displays.  Syncing into the private copy (=
not
> +        * the shared cifs_sb->ctx) avoids racing with concurrent
> +        * fspick/remount and /proc/mounts readers.  The parser will over=
write
> +        * only the options explicitly passed on remount, so any differen=
ce
> +        * between new_ctx and old_ctx in smb3_verify_reconfigure_ctx()
> +        * represents a real, intentional change by the user.
>          */
>         if (fc->purpose =3D=3D FS_CONTEXT_FOR_RECONFIGURE) {
>                 struct cifs_sb_info *cifs_sb =3D CIFS_SB(fc->root->d_sb);
>                 int rc;
>
> -               rc =3D smb3_sync_ctx_from_runtime(cifs_sb);
> -               if (rc)
> -                       return rc;
> -
>                 ctx =3D kzalloc_obj(struct smb3_fs_context);
>                 if (!ctx)
>                         return -ENOMEM;
>
>                 rc =3D smb3_fs_context_dup(ctx, cifs_sb->ctx);
>                 if (rc) {
> +                       smb3_cleanup_fs_context_contents(ctx);
> +                       kfree(ctx);
> +                       return rc;
> +               }
> +
> +               rc =3D smb3_sync_ctx_from_runtime(cifs_sb, ctx);
> +               if (rc) {
> +                       smb3_cleanup_fs_context_contents(ctx);
>                         kfree(ctx);
>                         return rc;
>                 }
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index a8f8feeeccb5..b30c16b0d157 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -2806,7 +2806,7 @@ bool smb2_should_replay(struct cifs_tcon *tcon,
>         if (!pretries || !pcur_sleep)
>                 return false;
>
> -       if (tcon->retry || (*pretries)++ < tcon->ses->server->retrans) {
> +       if (tcon->retry || (*pretries)++ < READ_ONCE(tcon->ses->server->r=
etrans)) {
>                 /* Update sleep time for exponential backoff */
>                 if (!(*pcur_sleep))
>                         (*pcur_sleep) =3D 1;
> --
> 2.43.0
>
>


--=20
Thanks,

Steve
