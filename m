Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03DA5C433ED
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 18:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5B9F61074
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 18:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbhDISuU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 14:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbhDISuT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Apr 2021 14:50:19 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2EBC061762
        for <linux-cifs@vger.kernel.org>; Fri,  9 Apr 2021 11:50:05 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id z8so7599435ljm.12
        for <linux-cifs@vger.kernel.org>; Fri, 09 Apr 2021 11:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fEzY7r8zyTJzh+3vNFw6+7FmQp2Y2misLL+QUhfIXQo=;
        b=dfQTYXv+pTQYNQDXYNbZz/zSZkhZBYYfQXcOZTsjQqS98Ne07IURg8sHe/Ujp9Zk4f
         tGINjTt6j+33IK4Vx7GBO4DLRcNSy9/KMif37YV/z0UQXbYL01whihFt/TC8mrY8wKQ2
         yd0jf2QoRpuHtnnzou5pHqAudFPF43c8qfzl2qQlIQIUCXBodNyYh798w0fwEfehKQY2
         nvE383SxlEGKnbk/i+1GRlHmhXZub2DkYkV22S8nkZoLlSCKeIfpl0uplkhXhIlE35it
         +hnypSG6lvTrwxegJ05cFx/vMBMXnWW+kgmNLZ/niiWA1wN4xhl5bGe7QWwURlYT4Jd6
         DHDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fEzY7r8zyTJzh+3vNFw6+7FmQp2Y2misLL+QUhfIXQo=;
        b=pff637fsXNFo8kV7d+4X0laX+urUevAUYcJOQiTgiomkJj09Eq7oP3TXXO0yXP23/a
         ovDY/EcfA9jaiPgrnoyCq19yAo+vXbPIvn4wOEtNgRMJIQ0Ij6an+gjac3yEH8e3FZlT
         GfxKmshQZRmhEJyUZhEEvl4fOqUkAu0sCCJn6hZwadP/1iHPSfnV06wMO18IfT1XhNT7
         TMy1XKn4vFaSVuetA+sO/Q1TXXfJRXMLonlEBnS7WUP5e3rqVjiHt85Mp/mY8q/PWQvX
         RZvTirOJlo4DkoYJDWd5mRdbUgdUqVQGRnGTfNYj2k0UIWkEVUV9gdjpV7kbQdzEYHDQ
         gEUg==
X-Gm-Message-State: AOAM531kuwE2j6bSb5BGyOHEF4kj841kWTUuP/R9vxMFJfZGdXpj4HX0
        p699oFcvYDux+m1zZW4GBz84bhUBtBRTKdLWeCI6tlISRyw=
X-Google-Smtp-Source: ABdhPJyu9y7K/6BvwIFXJlrBw5II301tFQWN3nIyt1NKXnGxDriFI65tvjFEdIs1Em4npzEJuyi4ldUixwCWpK7O1SY=
X-Received: by 2002:a2e:a78b:: with SMTP id c11mr10339006ljf.6.1617994204339;
 Fri, 09 Apr 2021 11:50:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvnW1At==3rWAn+Mu7WZ1-jHOmYkkyWjh+axsHoo4Lh4w@mail.gmail.com>
 <20210409143137.30683-1-aaptel@suse.com>
In-Reply-To: <20210409143137.30683-1-aaptel@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 9 Apr 2021 13:49:53 -0500
Message-ID: <CAH2r5mv_qKOzW_ntGJMR-zjpdbKYMv-AmamK5i+82BoD6rj0-Q@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: simplify SWN code with dummy funcs instead of ifdefs
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     scabrero@suse.com, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending more testing

On Fri, Apr 9, 2021 at 9:32 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> From: Aurelien Aptel <aaptel@suse.com>
>
> This commit doesn't change the logic of SWN.
>
> Add dummy implementation of SWN functions when SWN is disabled instead
> of using ifdef sections.
>
> The dummy functions get optimized out, this leads to clearer code and
> compile time type-checking regardless of config options with no
> runtime penalty.
>
> Leave the simple ifdefs section as-is.
>
> A single bitfield (bool foo:1) on its own will use up one int. Move
> tcon->use_witness out of ifdefs with the other tcon bitfields.
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> ---
> changes since v1:
> * updated to apply on current for-next
>
>
>  fs/cifs/cifs_debug.c |  8 +-------
>  fs/cifs/cifs_swn.h   | 27 +++++++++++++++++++++++++++
>  fs/cifs/cifsfs.c     |  2 --
>  fs/cifs/cifsglob.h   |  4 +---
>  fs/cifs/connect.c    | 25 ++++---------------------
>  5 files changed, 33 insertions(+), 33 deletions(-)
>
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index 88a7958170ee..d8ae961a510f 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -23,9 +23,7 @@
>  #ifdef CONFIG_CIFS_SMB_DIRECT
>  #include "smbdirect.h"
>  #endif
> -#ifdef CONFIG_CIFS_SWN_UPCALL
>  #include "cifs_swn.h"
> -#endif
>
>  void
>  cifs_dump_mem(char *label, void *data, int length)
> @@ -118,10 +116,8 @@ static void cifs_debug_tcon(struct seq_file *m, stru=
ct cifs_tcon *tcon)
>                 seq_printf(m, " POSIX Extensions");
>         if (tcon->ses->server->ops->dump_share_caps)
>                 tcon->ses->server->ops->dump_share_caps(m, tcon);
> -#ifdef CONFIG_CIFS_SWN_UPCALL
>         if (tcon->use_witness)
>                 seq_puts(m, " Witness");
> -#endif
>
>         if (tcon->need_reconnect)
>                 seq_puts(m, "\tDISCONNECTED ");
> @@ -490,10 +486,8 @@ static int cifs_debug_data_proc_show(struct seq_file=
 *m, void *v)
>
>         spin_unlock(&cifs_tcp_ses_lock);
>         seq_putc(m, '\n');
> -
> -#ifdef CONFIG_CIFS_SWN_UPCALL
>         cifs_swn_dump(m);
> -#endif
> +
>         /* BB add code to dump additional info such as TCP session info n=
ow */
>         return 0;
>  }
> diff --git a/fs/cifs/cifs_swn.h b/fs/cifs/cifs_swn.h
> index 236ecd4959d5..8a9d2a5c9077 100644
> --- a/fs/cifs/cifs_swn.h
> +++ b/fs/cifs/cifs_swn.h
> @@ -7,11 +7,13 @@
>
>  #ifndef _CIFS_SWN_H
>  #define _CIFS_SWN_H
> +#include "cifsglob.h"
>
>  struct cifs_tcon;
>  struct sk_buff;
>  struct genl_info;
>
> +#ifdef CONFIG_CIFS_SWN_UPCALL
>  extern int cifs_swn_register(struct cifs_tcon *tcon);
>
>  extern int cifs_swn_unregister(struct cifs_tcon *tcon);
> @@ -22,4 +24,29 @@ extern void cifs_swn_dump(struct seq_file *m);
>
>  extern void cifs_swn_check(void);
>
> +static inline bool cifs_swn_set_server_dstaddr(struct TCP_Server_Info *s=
erver)
> +{
> +       if (server->use_swn_dstaddr) {
> +               server->dstaddr =3D server->swn_dstaddr;
> +               return true;
> +       }
> +       return false;
> +}
> +
> +static inline void cifs_swn_reset_server_dstaddr(struct TCP_Server_Info =
*server)
> +{
> +       server->use_swn_dstaddr =3D false;
> +}
> +
> +#else
> +
> +static inline int cifs_swn_register(struct cifs_tcon *tcon) { return 0; =
}
> +static inline int cifs_swn_unregister(struct cifs_tcon *tcon) { return 0=
; }
> +static inline int cifs_swn_notify(struct sk_buff *s, struct genl_info *i=
) { return 0; }
> +static inline void cifs_swn_dump(struct seq_file *m) {}
> +static inline void cifs_swn_check(void) {}
> +static inline bool cifs_swn_set_server_dstaddr(struct TCP_Server_Info *s=
erver) { return false; }
> +static inline void cifs_swn_reset_server_dstaddr(struct TCP_Server_Info =
*server) {}
> +
> +#endif /* CONFIG_CIFS_SWN_UPCALL */
>  #endif /* _CIFS_SWN_H */
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 5ddd20b62484..1b65ff9e9189 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -656,10 +656,8 @@ cifs_show_options(struct seq_file *s, struct dentry =
*root)
>                 seq_printf(s, ",multichannel,max_channels=3D%zu",
>                            tcon->ses->chan_max);
>
> -#ifdef CONFIG_CIFS_SWN_UPCALL
>         if (tcon->use_witness)
>                 seq_puts(s, ",witness");
> -#endif
>
>         return 0;
>  }
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index ec824ab8c5ca..dec0620ccca4 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1070,6 +1070,7 @@ struct cifs_tcon {
>         bool use_resilient:1; /* use resilient instead of durable handles=
 */
>         bool use_persistent:1; /* use persistent instead of durable handl=
es */
>         bool no_lease:1;    /* Do not request leases on files or director=
ies */
> +       bool use_witness:1; /* use witness protocol */
>         __le32 capabilities;
>         __u32 share_flags;
>         __u32 maximal_access;
> @@ -1094,9 +1095,6 @@ struct cifs_tcon {
>         int remap:2;
>         struct list_head ulist; /* cache update list */
>  #endif
> -#ifdef CONFIG_CIFS_SWN_UPCALL
> -       bool use_witness:1; /* use witness protocol */
> -#endif
>  };
>
>  /*
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 24668eb006c6..35dbb9c836ea 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -62,9 +62,7 @@
>  #include "dfs_cache.h"
>  #endif
>  #include "fs_context.h"
> -#ifdef CONFIG_CIFS_SWN_UPCALL
>  #include "cifs_swn.h"
> -#endif
>
>  extern mempool_t *cifs_req_poolp;
>  extern bool disable_legacy_dialects;
> @@ -314,12 +312,8 @@ cifs_reconnect(struct TCP_Server_Info *server)
>
>                 mutex_lock(&server->srv_mutex);
>
> -#ifdef CONFIG_CIFS_SWN_UPCALL
> -               if (server->use_swn_dstaddr) {
> -                       server->dstaddr =3D server->swn_dstaddr;
> -               } else {
> -#endif
>
> +               if (!cifs_swn_set_server_dstaddr(server)) {
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>                 if (cifs_sb && cifs_sb->origin_fullpath)
>                         /*
> @@ -344,9 +338,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>  #endif
>
>
> -#ifdef CONFIG_CIFS_SWN_UPCALL
>                 }
> -#endif
>
>                 if (cifs_rdma_enabled(server))
>                         rc =3D smbd_reconnect(server);
> @@ -363,9 +355,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>                         if (server->tcpStatus !=3D CifsExiting)
>                                 server->tcpStatus =3D CifsNeedNegotiate;
>                         spin_unlock(&GlobalMid_Lock);
> -#ifdef CONFIG_CIFS_SWN_UPCALL
> -                       server->use_swn_dstaddr =3D false;
> -#endif
> +                       cifs_swn_reset_server_dstaddr(server);
>                         mutex_unlock(&server->srv_mutex);
>                 }
>         } while (server->tcpStatus =3D=3D CifsNeedReconnect);
> @@ -430,10 +420,8 @@ cifs_echo_request(struct work_struct *work)
>                 cifs_dbg(FYI, "Unable to send echo request to server: %s\=
n",
>                          server->hostname);
>
> -#ifdef CONFIG_CIFS_SWN_UPCALL
>         /* Check witness registrations */
>         cifs_swn_check();
> -#endif
>
>  requeue_echo:
>         queue_delayed_work(cifsiod_wq, &server->echo, server->echo_interv=
al);
> @@ -2009,7 +1997,6 @@ cifs_put_tcon(struct cifs_tcon *tcon)
>                 return;
>         }
>
> -#ifdef CONFIG_CIFS_SWN_UPCALL
>         if (tcon->use_witness) {
>                 int rc;
>
> @@ -2019,7 +2006,6 @@ cifs_put_tcon(struct cifs_tcon *tcon)
>                                         __func__, rc);
>                 }
>         }
> -#endif
>
>         list_del_init(&tcon->tcon_list);
>         spin_unlock(&cifs_tcp_ses_lock);
> @@ -2181,9 +2167,9 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_=
context *ctx)
>                 }
>                 tcon->use_resilient =3D true;
>         }
> -#ifdef CONFIG_CIFS_SWN_UPCALL
> +
>         tcon->use_witness =3D false;
> -       if (ctx->witness) {
> +       if (IS_ENABLED(CONFIG_CIFS_SWN_UPCALL) && ctx->witness) {
>                 if (ses->server->vals->protocol_id >=3D SMB30_PROT_ID) {
>                         if (tcon->capabilities & SMB2_SHARE_CAP_CLUSTER) =
{
>                                 /*
> @@ -2209,7 +2195,6 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_=
context *ctx)
>                         goto out_fail;
>                 }
>         }
> -#endif
>
>         /* If the user really knows what they are doing they can override=
 */
>         if (tcon->share_flags & SMB2_SHAREFLAG_NO_CACHING) {
> @@ -3877,9 +3862,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, k=
uid_t fsuid)
>         ctx->sectype =3D master_tcon->ses->sectype;
>         ctx->sign =3D master_tcon->ses->sign;
>         ctx->seal =3D master_tcon->seal;
> -#ifdef CONFIG_CIFS_SWN_UPCALL
>         ctx->witness =3D master_tcon->use_witness;
> -#endif
>
>         rc =3D cifs_set_vol_auth(ctx, master_tcon->ses);
>         if (rc) {
> --
> 2.30.0
>


--=20
Thanks,

Steve
