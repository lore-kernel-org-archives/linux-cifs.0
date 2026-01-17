Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33ECF136351
	for <linux-cifs@vger.kernel.org>; Sat, 17 Jan 2026 03:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768618817; cv=pass; b=TAqncBoCfghld6dm5Ql1C5mjk+xrxDwk0QiGIso9rldVzw8c0hea+dBZ8NIvARl9nC0FDtawgtt9LjP3d171yJywEZQPs/Ro5PRhpJ/jSwTCOYkhojMjVhvvH8srpRoYehBhJwSsvF7/jprhvH6/5SJzgk277TduDdSYjs/6Nr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768618817; c=relaxed/simple;
	bh=9u7ntoS7JO6Zuuh8BQh2Fn75SrSlyIZfjl6zov6dt3Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pNtZAOaAruKRITTnsNcPVJV4VRpyGOwEzkGFgozdshMCAlOe6kh3RrzmKd1lxXZdd1w7X/ImyhSZ1C1LYr8k/ly2bMOYn0y8GcjRhCNaWs3QIhdwXddfSsmK2B7NcLT0EWAORqfw1CTsH+zgb3EenmxQDWCFPhQFOilSZfpEXkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zlt4hEua; arc=pass smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zlt4hEua"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8888a1c50e8so32909086d6.0
        for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 19:00:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768618815; cv=none;
        d=google.com; s=arc-20240605;
        b=Q2CJsPanlbm1Mb7SiACi/mVF4Ymez2Me8Y3RlvZzMzEQvs2v1U/6Im6tRmQHirHdmk
         Y/5LOgnqfa7kIBvwgUIipd4v5tBGh86RNWzrSe/brv8DivWgHRmoXtdz+WrMJ457VbG1
         GaTgnWuQS5awa+f7SZ1BtvdZxwa+6OX2FdlteFbjR9+lr9zOHxOKt2hffZ2z5ci+yeSu
         AlAuSsj5FY+THsbYGYq1bBgw7yc/SA2irgFgtiUwMuFshAGRLMvRqPy8K507CQHtnXjN
         P+PuKWMztQBcY6r3ts3aCy5wPanpC9v6ORNgO1CLrWgNnCb4VPjA2zaNN+hSfnOjl3GL
         1ZRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UZCVd0YMFyNPW15zeMXyMtu6UQyFGLqzjtd5fZJqsBM=;
        fh=kvjeg0eh59E4UGW2xW7yGZeIXGVBc15mSG5YzSeLI4E=;
        b=SSSEfvo0MGMbTF2ZUjwjqIIak+fxV3DtoXReroTuohLTUcp6tGZV4K/xZxoUziC7eI
         NxwA1T4ei9ONIegGjgu3P4w6ricZvoPpKncwzIP5vb8yPd789GCaYLyk7EErePaKYKDw
         h7hwu60dE/6qdH9Rg8uKeGz0/jgkW1E8CRx8PDrVMXejEmfXAzC3xWKaw6tgMJ9QTSq6
         o9feKtDMkT7tgXNKRxjE99xV7uz0ESjW8OIFxIuF4KyjvQEOFcfeRoCo1EuQ8bZl6rVm
         Xxe+qFN4TbdIchgcMTzhjllZQK1VF2InCSkP3ZVOpUii+uTTHTo+Miew+A87BpcplTUM
         tIag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768618815; x=1769223615; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UZCVd0YMFyNPW15zeMXyMtu6UQyFGLqzjtd5fZJqsBM=;
        b=Zlt4hEua2Us/SI0slDNGkwOFYPUQ01Kv3Pv4NVFR+2Qf2Pj7HJp2+AfelOmciXM8IK
         8IYQj/HaEwP7aYWlFwINVGaYk9eAeZ6oppab57OvhzQzm/v5kzUR+OIxFUH7qaLdPNVP
         OvULOTuiOgo2FwkcEt4NXS2i6AsKzpvhSfbvh6jHHxJ7C/uZCJNthqXhCu7RADfy868L
         MwhJKhTUjJheb6g8Z2Dlm8biIKlvJNdFDwtXKIInqef+pL2jtDakm1os0gHmH1dfoMDk
         bfABDuj2lf1EuhJIzycDGrrbggcpNzUvsq2KjWgHX8IpqBVu1X+sYBJJ1QLE1YehMw+M
         U/2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768618815; x=1769223615;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UZCVd0YMFyNPW15zeMXyMtu6UQyFGLqzjtd5fZJqsBM=;
        b=F/8KXKuaO9cP8m+sy7l5IDgrRasG2p85AhDTd90N92WtbikOWFLA9kTtfgCZPcesra
         LcTgQZ8h5f1OmH1Mg/fhv3spKbBr0UzJn+c4ClRgVZVuWsXaBXT6DxjbOxtKXMshssr9
         v1ijUBTFn8excPyztD4AAI8MrRDlfhXTylyOCcUJwasRFE9i1oBDx5fnn/7K0OefFmYj
         c3IZY2o/b8mA0RVrM0KkKkORKLG/xfDV0TLEUTLhmM7Uxnorc3lVWBeeBxxVswAArson
         XtbT7pV4LNSkZFYa78kIt6tX60o+LUaBXxrcpenvi5iWIUMhRbk/p1VhenYeE68Do/V9
         5/qg==
X-Forwarded-Encrypted: i=1; AJvYcCV3Q6S2HQfmXuC6yxeEPETZPFDtfvY3pVd28HiCsCmT/FEGINe6Of4bwIOD6gc3jWzEZhArfBVqIXl2@vger.kernel.org
X-Gm-Message-State: AOJu0YwqO0QlT901DRZ37z1Aka+x+RY002nBXGPK1ys0VKrFZnUQv7S5
	A3kULJ8dH6ZpoLRiD5+ssm6or5bb69/JvdHT8Xyh008pnbfys/RO+1zN3ONBPBRfQ9eqK4l9pqE
	nr478AuUPLVy3RoOSpe4yhBdLuTxFXOo=
X-Gm-Gg: AY/fxX4OQ0EaPa88sVzhPTUqpwi1qub0VJY0jX5mWVb8ppFT3667PutRH3a7lx1quge
	D7jamqtmhrJoPnvckzEhkFEZqubjWgvsh9/roTbVy1F6ONhpBaid31cw4XjbNgO0/l65ETKaaFP
	giRTZKe/fSg+5t2O1BdKmApKulkjCV3+0ly6Srbiexx4h20uNh+BhPxjQXKKt4y5W+TjhAcuXOg
	O71/RqDQErNx/ZfEWPS64spxJwoUJ12dr/kfu8tLqHd5ZfdQS4+hUhzqdf0yCjAOCV3OeBpY5Hr
	iJWAQParfpiQR6A0Ei56cEaLTFRYnr7n4Rbu9+si5m+p9C+vIMDR9bUzkhKppvqdUv5qNuvWBz0
	F8eiBk8GN4Mcm1BGgYso/rO7M4YdK7R2fGTcq6eiGGrll0+eHXGzr3EJz56AOB5nM5yD9WdLWMW
	ru/B4mq+WjZQ==
X-Received: by 2002:a05:6214:e69:b0:890:33cd:eea1 with SMTP id
 6a1803df08f44-8942dbf4f13mr74809276d6.17.1768618814821; Fri, 16 Jan 2026
 19:00:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116220641.322213-1-henrique.carvalho@suse.com>
In-Reply-To: <20260116220641.322213-1-henrique.carvalho@suse.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 16 Jan 2026 21:00:01 -0600
X-Gm-Features: AZwV_QiHUAcxwjrlHSXJetgsCMI_G1aYwSF1WHV8uH5YltM6xxvVqB_Ew37mfps
Message-ID: <CAH2r5msry=T5pv+is1qzOPBvHtpWG4_GT-oLYOLcKF4obf0jOw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] smb: client: introduce multichannel async work
 during mount
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively applied to cifs-2.6.git for-next pending more testing and revie=
w

On Fri, Jan 16, 2026 at 4:07=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> Mounts can experience large delays when servers advertise interfaces
> that are unreachable from the client.
>
> To fix this, decouple channel addition from the synchronous mount path
> by introducing struct mchan_mount and running channel setup as
> background work.
>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/cifsglob.h |  5 ++++
>  fs/smb/client/connect.c  | 58 +++++++++++++++++++++++++++++++++++++---
>  2 files changed, 60 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 3eca5bfb7030..ebb106e927c4 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1796,6 +1796,11 @@ struct cifs_mount_ctx {
>         struct cifs_tcon *tcon;
>  };
>
> +struct mchan_mount {
> +       struct work_struct work;
> +       struct cifs_ses *ses;
> +};
> +
>  static inline void __free_dfs_info_param(struct dfs_info3_param *param)
>  {
>         kfree(param->path_name);
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index ce620503e9f7..d6c93980d1b6 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -64,6 +64,10 @@ static int generic_ip_connect(struct TCP_Server_Info *=
server);
>  static void tlink_rb_insert(struct rb_root *root, struct tcon_link *new_=
tlink);
>  static void cifs_prune_tlinks(struct work_struct *work);
>
> +static struct mchan_mount *mchan_mount_alloc(struct cifs_ses *ses);
> +static void mchan_mount_free(struct mchan_mount *mchan_mount);
> +static void mchan_mount_work_fn(struct work_struct *work);
> +
>  /*
>   * Resolve hostname and set ip addr in tcp ses. Useful for hostnames tha=
t may
>   * get their ip addresses changed at some point.
> @@ -3899,15 +3903,61 @@ int cifs_is_path_remote(struct cifs_mount_ctx *mn=
t_ctx)
>         return rc;
>  }
>
> +static struct mchan_mount *
> +mchan_mount_alloc(struct cifs_ses *ses)
> +{
> +       struct mchan_mount *mchan_mount;
> +
> +       mchan_mount =3D kzalloc(sizeof(*mchan_mount), GFP_KERNEL);
> +       if (!mchan_mount)
> +               return ERR_PTR(-ENOMEM);
> +
> +       INIT_WORK(&mchan_mount->work, mchan_mount_work_fn);
> +
> +       spin_lock(&cifs_tcp_ses_lock);
> +       cifs_smb_ses_inc_refcount(ses);
> +       spin_unlock(&cifs_tcp_ses_lock);
> +       mchan_mount->ses =3D ses;
> +
> +       return mchan_mount;
> +}
> +
> +static void
> +mchan_mount_free(struct mchan_mount *mchan_mount)
> +{
> +       cifs_put_smb_ses(mchan_mount->ses);
> +       kfree(mchan_mount);
> +}
> +
> +static void
> +mchan_mount_work_fn(struct work_struct *work)
> +{
> +       struct mchan_mount *mchan_mount =3D container_of(work, struct mch=
an_mount, work);
> +
> +       smb3_update_ses_channels(mchan_mount->ses, mchan_mount->ses->serv=
er, false, false);
> +
> +       mchan_mount_free(mchan_mount);
> +}
> +
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>  int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx=
)
>  {
>         struct cifs_mount_ctx mnt_ctx =3D { .cifs_sb =3D cifs_sb, .fs_ctx=
 =3D ctx, };
> +       struct mchan_mount *mchan_mount =3D NULL;
>         int rc;
>
>         rc =3D dfs_mount_share(&mnt_ctx);
>         if (rc)
>                 goto error;
> +
> +       if (ctx->multichannel) {
> +               mchan_mount =3D mchan_mount_alloc(mnt_ctx.ses);
> +               if (IS_ERR(mchan_mount)) {
> +                       rc =3D PTR_ERR(mchan_mount);
> +                       goto error;
> +               }
> +       }
> +
>         if (!ctx->dfs_conn)
>                 goto out;
>
> @@ -3926,17 +3976,19 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, stru=
ct smb3_fs_context *ctx)
>         ctx->prepath =3D NULL;
>
>  out:
> -       smb3_update_ses_channels(mnt_ctx.ses, mnt_ctx.server,
> -                                 false /* from_reconnect */,
> -                                 false /* disable_mchan */);
>         rc =3D mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
>         if (rc)
>                 goto error;
>
> +       if (ctx->multichannel)
> +               queue_work(cifsiod_wq, &mchan_mount->work);
> +
>         free_xid(mnt_ctx.xid);
>         return rc;
>
>  error:
> +       if (ctx->multichannel && !IS_ERR_OR_NULL(mchan_mount))
> +               mchan_mount_free(mchan_mount);
>         cifs_mount_put_conns(&mnt_ctx);
>         return rc;
>  }
> --
> 2.50.1
>
>


--=20
Thanks,

Steve
