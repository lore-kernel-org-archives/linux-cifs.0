Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC47C00140
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Aug 2022 05:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbiHHFTW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Aug 2022 01:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiHHFTV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Aug 2022 01:19:21 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A2363B2
        for <linux-cifs@vger.kernel.org>; Sun,  7 Aug 2022 22:19:19 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id c22so4237779wmr.2
        for <linux-cifs@vger.kernel.org>; Sun, 07 Aug 2022 22:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=cvclpQl6G/R/cDaZ5JV2w0pMgKdZItait/YtLxZjXtE=;
        b=MfmfIG7MB2fkmhVkeN0NK2IEeiAZG/dHCIx9DKKgn99wvP7Tset9csDhOfDSvCksct
         QPTTms9Q9QIMvL1ghW26qaq+KEmx6pggf//jWC5FC48sP27hMZ2PD1oBP0tL9UVLruRM
         4NwCbLdyj5ScR2SPAJupB0oBws9H0bCwFmB+o6zJRNPOrQpblspPq+4ZCVMFl0zTDTXi
         Wc49cLzPUpQo7SK0tuCgGfAN8WffOHKymkd7C6WkH5V1hrAXqouEcHYN9UWNl7Drokwi
         iIAvWTJU8QTRQUonkbNAurk0a6J9wNMb7pzt22C1JdFtSTwGkI0e10jz9wfMXqU9oXWK
         NXbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=cvclpQl6G/R/cDaZ5JV2w0pMgKdZItait/YtLxZjXtE=;
        b=kPD98SLG6s/I17JOgG8nVAG8ruCfU44b948iA4V4EnsQUirSfnpRmiszrnF71+dTL0
         5qH4WLvvkZxEBPicmvgMk8i0pa2mHRTV7j5NDJv3aprMP1Vi5UMQT0EmYHOv+nH3zB15
         LnrTBGhBvILRuVZF7PZX/A6lD/adFFVD0JabDyeag4FablENwUDuMGkXy6eCJZlqLjO4
         UX4r6xV06SPB3syBwzmB+Q5t6hI7DXztqaPMLrCAYlx5wHVAcieSK4/pVhg5EWPR+vo5
         GNC2NAag6jdtbIZzvAuFGCuYH+TtKNVjNMx7WOsmdNmxYUIGoBCyeEZp0q9nKpYDYkPO
         s9pQ==
X-Gm-Message-State: ACgBeo3ApyGTW3ku22rSk2lhUJJwvLOmSMD8ztplccS7dCeQ5Ww+GqdT
        p4O3Hr7S+/RBeAbLPhKIMnhnmB+HfrdsXa4SCCk=
X-Google-Smtp-Source: AA6agR5JxRzycMOzoU7ARZ0WKKXGZKWxjCHGVmwWeeZwtZmBgq5j8NZF04JJSMkU5MKVFfmfb5l1isWZSn2O/ZvXVVk=
X-Received: by 2002:a05:600c:1549:b0:3a3:2aa2:6f60 with SMTP id
 f9-20020a05600c154900b003a32aa26f60mr11536376wmg.57.1659935958437; Sun, 07
 Aug 2022 22:19:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220808024341.63913-1-atteh.mailbox@gmail.com> <20220808024341.63913-3-atteh.mailbox@gmail.com>
In-Reply-To: <20220808024341.63913-3-atteh.mailbox@gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 8 Aug 2022 14:19:07 +0900
Message-ID: <CANFS6bYkc6Jk8_-xGiEnd7x+=OrQFMFsNGf-5RX-nSAtV3NciA@mail.gmail.com>
Subject: Re: [PATCH 3/3] ksmbd-tools: inform ksmbd of stale share config
To:     atheik <atteh.mailbox@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 8=EC=9B=94 8=EC=9D=BC (=EC=9B=94) =EC=98=A4=EC=A0=84 11:47, a=
theik <atteh.mailbox@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> When initializing a share from a group, flag the share with
> KSMBD_SHARE_FLAG_UPDATE if the group callback mode denotes that the
> config file was reloaded. If the share was flagged, then later when
> handling a tree connect request, flag the connection with
> KSMBD_TREE_CONN_FLAG_UPDATE to inform ksmbd that its cached share
> config is stale. If there are no failures when handling the request,
> remove the share flag.
>
> Signed-off-by: Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

> ---
>  include/linux/ksmbd_server.h | 2 ++
>  lib/management/share.c       | 3 +++
>  lib/management/tree_conn.c   | 8 +++++++-
>  3 files changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/ksmbd_server.h b/include/linux/ksmbd_server.h
> index 6705dac..7e86d5d 100644
> --- a/include/linux/ksmbd_server.h
> +++ b/include/linux/ksmbd_server.h
> @@ -235,6 +235,7 @@ enum KSMBD_TREE_CONN_STATUS {
>  #define KSMBD_SHARE_FLAG_STREAMS               (1 << 11)
>  #define KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS       (1 << 12)
>  #define KSMBD_SHARE_FLAG_ACL_XATTR             (1 << 13)
> +#define KSMBD_SHARE_FLAG_UPDATE                (1 << 14)
>
>  /*
>   * Tree connect request flags.
> @@ -250,6 +251,7 @@ enum KSMBD_TREE_CONN_STATUS {
>  #define KSMBD_TREE_CONN_FLAG_READ_ONLY         (1 << 1)
>  #define KSMBD_TREE_CONN_FLAG_WRITABLE          (1 << 2)
>  #define KSMBD_TREE_CONN_FLAG_ADMIN_ACCOUNT     (1 << 3)
> +#define KSMBD_TREE_CONN_FLAG_UPDATE            (1 << 4)
>
>  /*
>   * RPC over IPC.
> diff --git a/lib/management/share.c b/lib/management/share.c
> index acd6d3f..e9492b5 100644
> --- a/lib/management/share.c
> +++ b/lib/management/share.c
> @@ -605,6 +605,9 @@ static void init_share_from_group(struct ksmbd_share =
*share,
>         if (!g_ascii_strcasecmp(share->name, "ipc$"))
>                 set_share_flag(share, KSMBD_SHARE_FLAG_PIPE);
>
> +       if (group->cb_mode =3D=3D GROUPS_CALLBACK_REINIT)
> +               set_share_flag(share, KSMBD_SHARE_FLAG_UPDATE);
> +
>         g_hash_table_foreach(group->kv, process_group_kv, share);
>
>         fixup_missing_fields(share);
> diff --git a/lib/management/tree_conn.c b/lib/management/tree_conn.c
> index 10304d1..f5c5749 100644
> --- a/lib/management/tree_conn.c
> +++ b/lib/management/tree_conn.c
> @@ -73,6 +73,8 @@ int tcm_handle_tree_connect(struct ksmbd_tree_connect_r=
equest *req,
>                 set_conn_flag(conn, KSMBD_TREE_CONN_FLAG_WRITABLE);
>         if (test_share_flag(share, KSMBD_SHARE_FLAG_READONLY))
>                 set_conn_flag(conn, KSMBD_TREE_CONN_FLAG_READ_ONLY);
> +       if (test_share_flag(share, KSMBD_SHARE_FLAG_UPDATE))
> +               set_conn_flag(conn, KSMBD_TREE_CONN_FLAG_UPDATE);
>
>         if (shm_open_connection(share)) {
>                 resp->status =3D KSMBD_TREE_CONN_STATUS_TOO_MANY_CONNS;
> @@ -207,8 +209,12 @@ bind:
>                 tcm_tree_conn_free(conn);
>                 put_ksmbd_user(user);
>         }
> +
> +       g_rw_lock_writer_lock(&share->update_lock);
> +       clear_share_flag(share, KSMBD_SHARE_FLAG_UPDATE);
> +       g_rw_lock_writer_unlock(&share->update_lock);
> +
>         return 0;
> -
>  out_error:
>         tcm_tree_conn_free(conn);
>         shm_close_connection(share);
> --
> 2.37.1
>


--=20
Thanks,
Hyunchul
