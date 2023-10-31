Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD09C4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Oct 2023 03:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbjJaDXo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 23:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbjJaDXo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 23:23:44 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E61B98
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 20:23:41 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-507c8316abcso7348313e87.1
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 20:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698722619; x=1699327419; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ERkDOGaTkkrqqAHdrCmvdvOez1c3ItEAEfKzp8QNEsA=;
        b=AHCftRftkCQHvVR3BWeUXdUD7inwTarnZVNKsdGGvj6JEahN+qzB/fguiPoD3Of88T
         L6+jtZFK2hfEDCVmVwmPGiOZFxuEWaQPeqdmspWIfV2jZXdvUnO7N1ITfbrACI+uWE+U
         pmrMKufovM8nw67nnGGlZh9A0fY4Dlb5PrfxaJY6V4vYEMPrpHu1fgqSGN2QJQf9AOd5
         3ZETsFpK3YbV1c/0TKri5ztobQxyzNkWr5pOUb+5cpNVGXVSBWNiTzKL7/0Pc32qYTBL
         f1pEaLH4+eWoEQf1PQJvnu1G3Ekb7CrpmVYn9eo70MLC2eTk5ILLUgcIsbjKJof+h7+A
         tXdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698722619; x=1699327419;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ERkDOGaTkkrqqAHdrCmvdvOez1c3ItEAEfKzp8QNEsA=;
        b=dbwDUrYuygu6vYSuv7elGrDMW5eOaTYqs5G78FE0KnbHob7V5SpntT2mvRVLQDHz+S
         P/4syp80jn4IF3qisk/FiJ5FqWAmHbWhBVb6gL+IsJVfZjxsVQnW+xVZjYFwMmfn4rV9
         aTW2aCMtR9O7a6UOn1kb1y9OqjFUy4vzfGdq3XGfoDSZxLJurMX7UJCE1WW+fdHanncv
         9FBYEHoYVLVykWJ2lIw0ZWH7+B1hY97s01IWGI39M7JLkCHMAOSyUCR5nQqO+DXiDBOU
         BOy2BbL2CpaY+RNMNey1weR5IJXpAx1aY1RllMDQDjhAl89hSgik+ZSmzOLFrK0rJqqp
         s0eg==
X-Gm-Message-State: AOJu0Yzespw11ac1CbGpIPYMM22CKl5f7KxFbWzdZ/EDh8R229OK+S5/
        x3xWMo/S5qPsbCZ4uHk9ViRcsB1Ai3CI0/eGd+n6vWL78bU=
X-Google-Smtp-Source: AGHT+IHQ94jms7/XNFVWh2rFOxiSCPDgAsilacUaIzybwi9qjNdhPI0tIDm+jMrq2MOvfyUOkYb07TnttFMfUQS+/Eg=
X-Received: by 2002:a05:6512:2349:b0:507:bc6b:38a6 with SMTP id
 p9-20020a056512234900b00507bc6b38a6mr11751954lfu.33.1698722619171; Mon, 30
 Oct 2023 20:23:39 -0700 (PDT)
MIME-Version: 1.0
References: <20231030201956.2660-1-pc@manguebit.com> <20231030201956.2660-3-pc@manguebit.com>
In-Reply-To: <20231030201956.2660-3-pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 30 Oct 2023 22:23:27 -0500
Message-ID: <CAH2r5mtSvujvEHW53NS17+b4dFqOjB+vXXFGbAK9SNoKo7UO-Q@mail.gmail.com>
Subject: Re: [PATCH 3/4] smb: client: fix potential deadlock when releasing mids
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     linux-cifs@vger.kernel.org, Frank Sorenson <sorenson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

fix was already in cifs-2.6.git for-next, but added Cc: stable

Let me know if I missed anything

On Mon, Oct 30, 2023 at 3:20=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> All release_mid() callers seem to hold a reference of @mid so there is
> no need to call kref_put(&mid->refcount, __release_mid) under
> @server->mid_lock spinlock.  If they don't, then an use-after-free bug
> would have occurred anyway.
>
> By getting rid of such spinlock also fixes a potential deadlock as
> shown below
>
> CPU 0                                CPU 1
> ------------------------------------------------------------------
> cifs_demultiplex_thread()            cifs_debug_data_proc_show()
>  release_mid()
>   spin_lock(&server->mid_lock);
>                                      spin_lock(&cifs_tcp_ses_lock)
>                                       spin_lock(&server->mid_lock)
>   __release_mid()
>    smb2_find_smb_tcon()
>     spin_lock(&cifs_tcp_ses_lock) *deadlock*
>
> Cc: Frank Sorenson <sorenson@redhat.com>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
>  fs/smb/client/cifsproto.h |  7 ++++++-
>  fs/smb/client/smb2misc.c  |  2 +-
>  fs/smb/client/transport.c | 11 +----------
>  3 files changed, 8 insertions(+), 12 deletions(-)
>
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 0c37eefa18a5..890ceddae07e 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -81,7 +81,7 @@ extern char *cifs_build_path_to_root(struct smb3_fs_con=
text *ctx,
>  extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
>  char *cifs_build_devname(char *nodename, const char *prepath);
>  extern void delete_mid(struct mid_q_entry *mid);
> -extern void release_mid(struct mid_q_entry *mid);
> +void __release_mid(struct kref *refcount);
>  extern void cifs_wake_up_task(struct mid_q_entry *mid);
>  extern int cifs_handle_standard(struct TCP_Server_Info *server,
>                                 struct mid_q_entry *mid);
> @@ -740,4 +740,9 @@ static inline bool dfs_src_pathname_equal(const char =
*s1, const char *s2)
>         return true;
>  }
>
> +static inline void release_mid(struct mid_q_entry *mid)
> +{
> +       kref_put(&mid->refcount, __release_mid);
> +}
> +
>  #endif                 /* _CIFSPROTO_H */
> diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
> index 25f7cd6f23d6..32dfa0f7a78c 100644
> --- a/fs/smb/client/smb2misc.c
> +++ b/fs/smb/client/smb2misc.c
> @@ -787,7 +787,7 @@ __smb2_handle_cancelled_cmd(struct cifs_tcon *tcon, _=
_u16 cmd, __u64 mid,
>  {
>         struct close_cancelled_open *cancelled;
>
> -       cancelled =3D kzalloc(sizeof(*cancelled), GFP_ATOMIC);
> +       cancelled =3D kzalloc(sizeof(*cancelled), GFP_KERNEL);
>         if (!cancelled)
>                 return -ENOMEM;
>
> diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> index 14710afdc2a3..d553b7a54621 100644
> --- a/fs/smb/client/transport.c
> +++ b/fs/smb/client/transport.c
> @@ -76,7 +76,7 @@ alloc_mid(const struct smb_hdr *smb_buffer, struct TCP_=
Server_Info *server)
>         return temp;
>  }
>
> -static void __release_mid(struct kref *refcount)
> +void __release_mid(struct kref *refcount)
>  {
>         struct mid_q_entry *midEntry =3D
>                         container_of(refcount, struct mid_q_entry, refcou=
nt);
> @@ -156,15 +156,6 @@ static void __release_mid(struct kref *refcount)
>         mempool_free(midEntry, cifs_mid_poolp);
>  }
>
> -void release_mid(struct mid_q_entry *mid)
> -{
> -       struct TCP_Server_Info *server =3D mid->server;
> -
> -       spin_lock(&server->mid_lock);
> -       kref_put(&mid->refcount, __release_mid);
> -       spin_unlock(&server->mid_lock);
> -}
> -
>  void
>  delete_mid(struct mid_q_entry *mid)
>  {
> --
> 2.42.0
>


--=20
Thanks,

Steve
