Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA492010FC
	for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2024 17:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731517498; cv=none; b=p5y4ofeViWbZZezFAEUN+H9Sc12nef5tq/T0YJ1YrxU8mfCoIaLAqLw5XvDDW1x7z3y+qfXTegGjU7z7gxyc2ro4RwLz30cTiw+OZrHrUhwObbBWHa6XHlU/uAd6d1MDiEuWtFbpc9gAlsR893uz9xq6/f6i4w4pv76deWBr36c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731517498; c=relaxed/simple;
	bh=6l7dDdSJGlfXIF54SuWj6Mc7HvwUNhcWnkdM0BYWdEU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lGlZqQYn11gq6Pewej+Thjl4qVema0PbDDpBBfDbfrM0rXn8qMyKT2YQJw9qDWXMVC+XDMIeuXRf/ObBykzbGA+N9eWbDdOaxNKVdbTyAkXavyv/eHw0MoB9AbCm9lNNTo0xSsoaI/85aPKpfNXPcLvmjGsCkxo3eu89D6l7q74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DYjYWS2P; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DYjYWS2P"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-53d9ff92ee9so1334247e87.1
        for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2024 09:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731517495; x=1732122295; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KQZ79Lw82rVSWWCSrfPfW4ab/AxpsZOyyM4PRFeMB4Q=;
        b=DYjYWS2PH96XvyQbMq1bwUyU8aZlj+P5VCl8pvMJ86DvX2mJIiQZ1ohBxFbWq0+FZU
         CwGW1ZTwiEnle0K2LkDJrv+YP6PRJT8v7iocQJxuEUUP1+Dh5LpchnTdymAJr4ZwgAO2
         TKAEiPohqrCDqcmsj6dFaA+8XBiyFQF23c1p20/ToIHV7W/oiqSVQuXeQTUCGI/V0YXR
         6WK+ZnzuxboT12H/2GiFeYVRx4Y7CHzeh6qzewSejf9D0yVrBwH0TuPEodoJuZmZrmSj
         lgE5X32NuYrNCaSAqqcnA8x1m401bFgFEIBekSeTgFfTDL9u3HAFbzzLKov2j8h1gsLm
         Tcxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731517495; x=1732122295;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KQZ79Lw82rVSWWCSrfPfW4ab/AxpsZOyyM4PRFeMB4Q=;
        b=FkjqnMjiQ9hcL9/S9V9RgEpENyoz15MOX9gDmzaMGL21LHDCM4leUnRRzE0CFQZ5tL
         F0PwXBlL2OwVDqm63cFIjknycCschdm3V3c3qerPsEZq2o4QdWMwcgEgBpuYZkFANUky
         UVjTkpoY9jIESk8EPCdzj557UNLUiyXeOFXbeYSnWwOXukWLzTPI2DXRKcqJyASCQJjV
         useRKFU/EBqU9tpACtXano59fSTztBiTsWBDI9f6ZbgUlqw+KeORKmyg5K4jUADWOXY9
         QT01FOA5miLZlE8eOC08HCVNLPtbAfph+uInR5MZll73Oc45k6KJuSfCgzGlEHWEpBD6
         gFOA==
X-Gm-Message-State: AOJu0Yx6FbMTJxi7yDQIFtkT7Ojd/guZVWpNfh0w/dVQ7X1eusnEipQS
	rtJ0HwN36nlz0YUpQ7nfz7G3fsBlRHmOLg277EMDODk7a9fzRZC1vvbsQuANktX6rx6s3IjLBmg
	v0wCdTSoak8oU22aGx4ETraA5X1U=
X-Google-Smtp-Source: AGHT+IHaAzvNwnH5VZjVWNTdv+YBNoh5dE0mP8REGybyx7cCNfIMvKhQcSHSyHyJTf+wmRblkrKjlMWrr27y+RriDKc=
X-Received: by 2002:ac2:53aa:0:b0:53d:a24b:47d5 with SMTP id
 2adb3069b0e04-53da24b4873mr1114757e87.57.1731517494699; Wed, 13 Nov 2024
 09:04:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241111134055.66981-1-pc@manguebit.com>
In-Reply-To: <20241111134055.66981-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 13 Nov 2024 11:04:43 -0600
Message-ID: <CAH2r5msM-q+98-PSZN+VwcwNaZPdfGYiesfaKN=6tA6LuQ31sg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix use-after-free of signing key
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, Jay Shin <jaeshin@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending testing and
additional review

On Mon, Nov 11, 2024 at 7:41=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Customers have reported use-after-free in @ses->auth_key.response with
> SMB2.1 + sign mounts which occurs due to following race:
>
> task A                         task B
> cifs_mount()
>  dfs_mount_share()
>   get_session()
>    cifs_mount_get_session()    cifs_send_recv()
>     cifs_get_smb_ses()          compound_send_recv()
>      cifs_setup_session()        smb2_setup_request()
>       kfree_sensitive()           smb2_calc_signature()
>                                    crypto_shash_setkey() *UAF*
>
> Fix this by ensuring that we have a valid @ses->auth_key.response by
> checking whether @ses->ses_status is SES_GOOD or SES_EXITING with
> @ses->ses_lock held.  After commit 24a9799aa8ef ("smb: client: fix UAF
> in smb2_reconnect_server()"), we made sure to call ->logoff() only
> when @ses was known to be good (e.g. valid ->auth_key.response), so
> it's safe to access signing key when @ses->ses_status =3D=3D SES_EXITING.
>
> Reported-by: Jay Shin <jaeshin@redhat.com>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  fs/smb/client/smb2proto.h     |  2 --
>  fs/smb/client/smb2transport.c | 56 +++++++++++++++++++++++++----------
>  2 files changed, 40 insertions(+), 18 deletions(-)
>
> diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
> index 6f9885e4f66c..71504b30909e 100644
> --- a/fs/smb/client/smb2proto.h
> +++ b/fs/smb/client/smb2proto.h
> @@ -37,8 +37,6 @@ extern struct mid_q_entry *smb2_setup_request(struct ci=
fs_ses *ses,
>                                               struct smb_rqst *rqst);
>  extern struct mid_q_entry *smb2_setup_async_request(
>                         struct TCP_Server_Info *server, struct smb_rqst *=
rqst);
> -extern struct cifs_ses *smb2_find_smb_ses(struct TCP_Server_Info *server=
,
> -                                          __u64 ses_id);
>  extern struct cifs_tcon *smb2_find_smb_tcon(struct TCP_Server_Info *serv=
er,
>                                                 __u64 ses_id, __u32  tid)=
;
>  extern int smb2_calc_signature(struct smb_rqst *rqst,
> diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.=
c
> index b486b14bb330..475b36c27f65 100644
> --- a/fs/smb/client/smb2transport.c
> +++ b/fs/smb/client/smb2transport.c
> @@ -74,7 +74,7 @@ smb311_crypto_shash_allocate(struct TCP_Server_Info *se=
rver)
>
>
>  static
> -int smb2_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *=
key)
> +int smb3_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *=
key)
>  {
>         struct cifs_chan *chan;
>         struct TCP_Server_Info *pserver;
> @@ -168,16 +168,41 @@ smb2_find_smb_ses_unlocked(struct TCP_Server_Info *=
server, __u64 ses_id)
>         return NULL;
>  }
>
> -struct cifs_ses *
> -smb2_find_smb_ses(struct TCP_Server_Info *server, __u64 ses_id)
> +static int smb2_get_sign_key(struct TCP_Server_Info *server,
> +                            __u64 ses_id, u8 *key)
>  {
>         struct cifs_ses *ses;
> +       int rc =3D -ENOENT;
> +
> +       if (SERVER_IS_CHAN(server))
> +               server =3D server->primary_server;
>
>         spin_lock(&cifs_tcp_ses_lock);
> -       ses =3D smb2_find_smb_ses_unlocked(server, ses_id);
> +       list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
> +               if (ses->Suid !=3D ses_id)
> +                       continue;
> +
> +               rc =3D 0;
> +               spin_lock(&ses->ses_lock);
> +               switch (ses->ses_status) {
> +               case SES_EXITING: /* SMB2_LOGOFF */
> +               case SES_GOOD:
> +                       if (likely(ses->auth_key.response)) {
> +                               memcpy(key, ses->auth_key.response,
> +                                      SMB2_NTLMV2_SESSKEY_SIZE);
> +                       } else {
> +                               rc =3D -EIO;
> +                       }
> +                       break;
> +               default:
> +                       rc =3D -EAGAIN;
> +                       break;
> +               }
> +               spin_unlock(&ses->ses_lock);
> +               break;
> +       }
>         spin_unlock(&cifs_tcp_ses_lock);
> -
> -       return ses;
> +       return rc;
>  }
>
>  static struct cifs_tcon *
> @@ -236,14 +261,16 @@ smb2_calc_signature(struct smb_rqst *rqst, struct T=
CP_Server_Info *server,
>         unsigned char *sigptr =3D smb2_signature;
>         struct kvec *iov =3D rqst->rq_iov;
>         struct smb2_hdr *shdr =3D (struct smb2_hdr *)iov[0].iov_base;
> -       struct cifs_ses *ses;
>         struct shash_desc *shash =3D NULL;
>         struct smb_rqst drqst;
> +       __u64 sid =3D le64_to_cpu(shdr->SessionId);
> +       u8 key[SMB2_NTLMV2_SESSKEY_SIZE];
>
> -       ses =3D smb2_find_smb_ses(server, le64_to_cpu(shdr->SessionId));
> -       if (unlikely(!ses)) {
> -               cifs_server_dbg(FYI, "%s: Could not find session\n", __fu=
nc__);
> -               return -ENOENT;
> +       rc =3D smb2_get_sign_key(server, sid, key);
> +       if (unlikely(rc)) {
> +               cifs_server_dbg(FYI, "%s: [sesid=3D0x%llx] couldn't find =
signing key: %d\n",
> +                               __func__, sid, rc);
> +               return rc;
>         }
>
>         memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
> @@ -260,8 +287,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP=
_Server_Info *server,
>                 shash =3D server->secmech.hmacsha256;
>         }
>
> -       rc =3D crypto_shash_setkey(shash->tfm, ses->auth_key.response,
> -                       SMB2_NTLMV2_SESSKEY_SIZE);
> +       rc =3D crypto_shash_setkey(shash->tfm, key, sizeof(key));
>         if (rc) {
>                 cifs_server_dbg(VFS,
>                                 "%s: Could not update with response\n",
> @@ -303,8 +329,6 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP=
_Server_Info *server,
>  out:
>         if (allocate_crypto)
>                 cifs_free_hash(&shash);
> -       if (ses)
> -               cifs_put_smb_ses(ses);
>         return rc;
>  }
>
> @@ -570,7 +594,7 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP=
_Server_Info *server,
>         struct smb_rqst drqst;
>         u8 key[SMB3_SIGN_KEY_SIZE];
>
> -       rc =3D smb2_get_sign_key(le64_to_cpu(shdr->SessionId), server, ke=
y);
> +       rc =3D smb3_get_sign_key(le64_to_cpu(shdr->SessionId), server, ke=
y);
>         if (unlikely(rc)) {
>                 cifs_server_dbg(FYI, "%s: Could not get signing key\n", _=
_func__);
>                 return rc;
> --
> 2.47.0
>


--=20
Thanks,

Steve
