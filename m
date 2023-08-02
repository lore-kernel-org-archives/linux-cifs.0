Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814C9C001DF
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Aug 2023 17:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjHBRI0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Aug 2023 13:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbjHBRIW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Aug 2023 13:08:22 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE19019B0
        for <linux-cifs@vger.kernel.org>; Wed,  2 Aug 2023 10:08:19 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2b703a0453fso110973911fa.3
        for <linux-cifs@vger.kernel.org>; Wed, 02 Aug 2023 10:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690996098; x=1691600898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8jGlcn7B0vBix3Cp8e5BNTP2RfsFO12ZQ1Vk7RiMXC0=;
        b=hDPFTwYUDXUdHSxKed2b3DS5mVraEe/hfAVphjDL+Dym8xtCI36qbM+ezWEuPiH+be
         rZZTn5TNu3QxFUlV/JVvI6IiZN3DHJ8z9GBMuZg9eJdO9JpR1n7np8212pXkI3b8Ofhg
         1BTDj22aVirAYNcyUkIKJcYK94w8sZ+KuZoJlgJWAHGZoyI0uehN9TiUv4WQen2lAOVK
         hEsTSr+OUzjRFZf5Woufw6GMrc4Ry8nPz9jswp0UXDrUuWi2stQlo73WmhVdiTitp+1L
         zCaePIMeToKNnFeQQKhJdzL/I/TAKzS4nT0s3hNbl+AkND2Yx+EUlxbLbq8TPphNjw9v
         Icgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690996098; x=1691600898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8jGlcn7B0vBix3Cp8e5BNTP2RfsFO12ZQ1Vk7RiMXC0=;
        b=A4TBYAYSwJyhgLGaIIUK/0bP77FcDeq+bomVvnQwT98MJQC2T0/TEjuiUQuMXxwxFP
         nPfPD3ELAn0+0H0rkFmAy/2Wu90HZ+0j4EIM7QU6r4hQyeXlacSZ5ZxmMXrv7QqMf1BC
         F2YTQdyVl0BYjZrMH/2c1LxusFzmx32Pz/QH8cAMdb3u7sFML6zHvjgHWDUOEKEYBzat
         AWEzNN0lLQVxQxh7LQycHgvfVlU7/+CXSiGirn/w6yhPhmXxUCP6ih4S3c4mO5My3Axk
         QbbJcoAWeccwtHAztGkiNlUNAT6MzDGwSoG7LU7kL0nxlmZsJA0FmjlpbqcTfrTMb+JK
         eVUQ==
X-Gm-Message-State: ABy/qLY1ZrWwkgyg85XRI833gC2vNnqe7p/1sL0Ik3gb40U6iSo+DkuO
        Sa5VFSr41Kx/TSslUrU+z9T+MROIjs4iMdx0XuEomIuIDqo=
X-Google-Smtp-Source: APBJJlE7pLFPRAC0xzdmGbFPY/ed+l/P/Ik8oY2O6FjJCOP8lRe5I430JV/XH+hZ1MMknP1dUnDAq/zyLXxsS+Uayhk=
X-Received: by 2002:a2e:781a:0:b0:2b6:9bd3:840e with SMTP id
 t26-20020a2e781a000000b002b69bd3840emr6089410ljc.21.1690996097564; Wed, 02
 Aug 2023 10:08:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230802164303.14109-1-pc@manguebit.com>
In-Reply-To: <20230802164303.14109-1-pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 2 Aug 2023 12:08:06 -0500
Message-ID: <CAH2r5mssZWBSg=12MyRbhdGC0afWreQWt=R5OpBSOCxLVwqO3A@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix dfs link mount against w2k8
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending testing

On Wed, Aug 2, 2023 at 11:43=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Customer reported that they couldn't mount their DFS link that was
> seen by the client as a DFS interlink -- special form of DFS link
> where its single target may point to a different DFS namespace -- and
> it turned out that it was just a regular DFS link where its referral
> header flags missed the StorageServers bit thus making the client
> think it couldn't tree connect to target directly without requiring
> further referrals.
>
> When the DFS link referral header flags misses the StoraServers bit
> and its target doesn't respond to any referrals, then tree connect to
> it.
>
> Fixes: a1c0d00572fc ("cifs: share dfs connections and supers")
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
>  fs/smb/client/dfs.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
> index df3fd3b720da..ee772c3d9f00 100644
> --- a/fs/smb/client/dfs.c
> +++ b/fs/smb/client/dfs.c
> @@ -177,8 +177,12 @@ static int __dfs_mount_share(struct cifs_mount_ctx *=
mnt_ctx)
>                 struct dfs_cache_tgt_list tl =3D DFS_CACHE_TGT_LIST_INIT(=
tl);
>
>                 rc =3D dfs_get_referral(mnt_ctx, ref_path + 1, NULL, &tl)=
;
> -               if (rc)
> +               if (rc) {
> +                       rc =3D cifs_mount_get_tcon(mnt_ctx);
> +                       if (!rc)
> +                               rc =3D cifs_is_path_remote(mnt_ctx);
>                         break;
> +               }
>
>                 tit =3D dfs_cache_get_tgt_iterator(&tl);
>                 if (!tit) {
> --
> 2.41.0
>


--=20
Thanks,

Steve
