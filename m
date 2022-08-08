Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF91C25B08
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Aug 2022 04:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbiHHE5d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Aug 2022 00:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbiHHE5c (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Aug 2022 00:57:32 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7639B10AE
        for <linux-cifs@vger.kernel.org>; Sun,  7 Aug 2022 21:57:29 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id p10so9534026wru.8
        for <linux-cifs@vger.kernel.org>; Sun, 07 Aug 2022 21:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=vEDxEVJbslgjsFD5hUASe6JMVIKONDQK1J0lOvUQ+FE=;
        b=XXQkVIdirdXH+4o7zhaFUmlUeotluMR/yF5ZRps9yA6TfTGBLzjFlqm363nlv6Ksfs
         xT7TI38YR0vlPMhDx+azJ9q1koirA4eq/IzGHZWTAr9FnS/SmrSTbEs1zBHDtmwNae+X
         f4j2jW0RpZdKY8FnK9YzM+BdKQGI0RmR3l90aE2iH6C4z/6pG2ibL4c1hA300u/8pPxO
         3t9GO6s+iKN6Og0JDIRoaSzy7VRPRCSGwGEDfxjSVegHT+ao5Nbx84iTZfZ/2Xv6evtt
         9bkf3kBvOvUfQ9//nKPsGxscn0P9/DOQcJetrRDWz0d3HnvcJyY3XLlNuQWxll9OjSE5
         bOdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=vEDxEVJbslgjsFD5hUASe6JMVIKONDQK1J0lOvUQ+FE=;
        b=zKvDXwEv/tn08kKB/tiv3SnhL/QBZl7e+n6h+tHsKHfyzy8IJpq9OfB3B7+WNUwq5+
         RxqOiYKO4+js86KQw+OH/6LDbWKm4yQdNwvCNBNAOlEL1xaphKlFts3yaBHXEnAws5j2
         TrfKVRbsc9IAULIgMe1/E5hCqeWBLD5g8OnLQFqBJEV+Gdei2lrk/aLCqmNcf6uG76Dv
         jiZ//YcNi9kJWupJ0x5D5ekk3xxwz7OkOZ8Y8a72pom9qlWdQizibJCOagY+wqOBC6Tb
         gSaUXBaOP2SfF7MdcCEKrsIN+OmKC2UzCRVRxM0PN7NsOnkmMh+2+YcMCPA4B1KKeWqg
         VCJw==
X-Gm-Message-State: ACgBeo0QroXq2EySLrlfB4Oa9SQEHo0S5RjrTECnxGSKlMh7z9bgygCW
        liVqy30RlMnib/w1PGJAkgeDq6SdyWuHH6UMIiI=
X-Google-Smtp-Source: AA6agR6t4yfZDrGdkRkyB2X0TWvhKtn+YKJgo4FCfaKR/SUUphAolGSVE6vvnAh6Z2nntIZwtukJl0Y7jnKRuNPv2R0=
X-Received: by 2002:a5d:5266:0:b0:21f:1280:85f with SMTP id
 l6-20020a5d5266000000b0021f1280085fmr10604931wrc.412.1659934647818; Sun, 07
 Aug 2022 21:57:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220808024341.63913-1-atteh.mailbox@gmail.com>
In-Reply-To: <20220808024341.63913-1-atteh.mailbox@gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 8 Aug 2022 13:57:16 +0900
Message-ID: <CANFS6bZMD-E-7C4Bjkkpnxzb-32oB7d2AHEySDOau9Yomz_RgQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] ksmbd: request update to stale share config
To:     atheik <atteh.mailbox@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello atheik,

2022=EB=85=84 8=EC=9B=94 8=EC=9D=BC (=EC=9B=94) =EC=98=A4=EC=A0=84 11:47, a=
theik <atteh.mailbox@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> ksmbd_share_config_get() retrieves the cached share config as long
> as there is at least one connection to the share. This is an issue when
> the user space utilities are used to update share configs. In that case
> there is a need to inform ksmbd that it should not use the cached share
> config for a new connection to the share. With these changes the tree
> connection flag KSMBD_TREE_CONN_FLAG_UPDATE indicates this. When this
> flag is set, ksmbd removes the share config from the shares hash table
> meaning that ksmbd_share_config_get() ends up requesting a share config
> from user space.
>
> Signed-off-by: Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>
> ---
>  ksmbd_netlink.h     |  2 ++
>  mgmt/share_config.c |  6 +++++-
>  mgmt/share_config.h |  1 +
>  mgmt/tree_connect.c | 14 ++++++++++++++
>  4 files changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/ksmbd_netlink.h b/ksmbd_netlink.h
> index 192cb13..5d77b72 100644
> --- a/ksmbd_netlink.h
> +++ b/ksmbd_netlink.h
> @@ -349,6 +349,7 @@ enum KSMBD_TREE_CONN_STATUS {
>  #define KSMBD_SHARE_FLAG_STREAMS               BIT(11)
>  #define KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS       BIT(12)
>  #define KSMBD_SHARE_FLAG_ACL_XATTR             BIT(13)
> +#define KSMBD_SHARE_FLAG_UPDATE                BIT(14)
>
>  /*
>   * Tree connect request flags.
> @@ -364,6 +365,7 @@ enum KSMBD_TREE_CONN_STATUS {
>  #define KSMBD_TREE_CONN_FLAG_READ_ONLY         BIT(1)
>  #define KSMBD_TREE_CONN_FLAG_WRITABLE          BIT(2)
>  #define KSMBD_TREE_CONN_FLAG_ADMIN_ACCOUNT     BIT(3)
> +#define KSMBD_TREE_CONN_FLAG_UPDATE            BIT(4)
>
>  /*
>   * RPC over IPC.
> diff --git a/mgmt/share_config.c b/mgmt/share_config.c
> index 70655af..c9bca1c 100644
> --- a/mgmt/share_config.c
> +++ b/mgmt/share_config.c
> @@ -51,12 +51,16 @@ static void kill_share(struct ksmbd_share_config *sha=
re)
>         kfree(share);
>  }
>
> -void __ksmbd_share_config_put(struct ksmbd_share_config *share)
> +void ksmbd_share_config_del(struct ksmbd_share_config *share)
>  {
>         down_write(&shares_table_lock);
>         hash_del(&share->hlist);
>         up_write(&shares_table_lock);
> +}
>
> +void __ksmbd_share_config_put(struct ksmbd_share_config *share)
> +{
> +       ksmbd_share_config_del(share);
>         kill_share(share);
>  }
>
> diff --git a/mgmt/share_config.h b/mgmt/share_config.h
> index 28bf351..902f2cb 100644
> --- a/mgmt/share_config.h
> +++ b/mgmt/share_config.h
> @@ -64,6 +64,7 @@ static inline int test_share_config_flag(struct ksmbd_s=
hare_config *share,
>         return share->flags & flag;
>  }
>
> +void ksmbd_share_config_del(struct ksmbd_share_config *share);
>  void __ksmbd_share_config_put(struct ksmbd_share_config *share);
>
>  static inline void ksmbd_share_config_put(struct ksmbd_share_config *sha=
re)
> diff --git a/mgmt/tree_connect.c b/mgmt/tree_connect.c
> index 7d467e1..0cf6265 100644
> --- a/mgmt/tree_connect.c
> +++ b/mgmt/tree_connect.c
> @@ -65,6 +65,20 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struc=
t ksmbd_session *sess,
>         }
>
>         tree_conn->flags =3D resp->connection_flags;
> +       if (test_tree_conn_flag(tree_conn, KSMBD_TREE_CONN_FLAG_UPDATE)) =
{
> +               struct ksmbd_share_config *new_sc;
> +
> +               ksmbd_share_config_del(sc);
> +               new_sc =3D ksmbd_share_config_get(share_name);
> +               if (!new_sc) {
> +                       pr_err("Failed to update stale share config\n");
> +                       status.ret =3D -ESTALE;

We need to set proper rsp->hdr.Status for ESTALE in smb2_tree_connect, othe=
rwise
ksmbd will send a response with STATUS_ACCESS_DENIED for this error.

> +                       goto out_error;
> +               }
> +               ksmbd_share_config_put(sc);
> +               sc =3D new_sc;
> +       }
> +
>         tree_conn->user =3D sess->user;
>         tree_conn->share_conf =3D sc;
>         status.tree_conn =3D tree_conn;
> --
> 2.37.1
>


--=20
Thanks,
Hyunchul
