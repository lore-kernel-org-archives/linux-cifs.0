Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90516C7EE23
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Mar 2023 03:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjCAD6I (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Feb 2023 22:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjCAD6H (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Feb 2023 22:58:07 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D095B61A6
        for <linux-cifs@vger.kernel.org>; Tue, 28 Feb 2023 19:58:05 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id f16so12564285ljq.10
        for <linux-cifs@vger.kernel.org>; Tue, 28 Feb 2023 19:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jVk/nmx5CCuysWO/eExH8X84Lj2rj9TYV94nuP7mkWE=;
        b=fjFWMeVeRfxqXBR+1upnqGxQr+6ND2LkrAK62FDjvnsNvfBycIiC0VqMRdc3D3hSgF
         YlbAlcxaqCwUtpM3dBYgMq0GcqzN6p3ezMG4NoChGIqO8yiO26xgPspQofipTXW4xWEh
         v08LOqIcstwXOilxCAE9zqQBPHNmGdYDUQSeEZbjbK+Cf6FtRu7/Zsb7PAD1iXxGw6vB
         HDRWvixCfslgaiztr7TvzbWDRZzlAcCbzoeIiwHk2vyQZ2+VzVCVWfYIQhyFS9bjjMxy
         E+yk0gQY7TzTF63A8lGygewxDrg7qQuD4lbAPLsAY+SvIhhevbDp0ijqF9OVc8aTjFAD
         v38Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jVk/nmx5CCuysWO/eExH8X84Lj2rj9TYV94nuP7mkWE=;
        b=MSetq01dgBjjCoDWo/PoFMUcLTJHoF5jN5FH7pacuMEvci8Se549OMaOm5KzOa7rrW
         Q/ZUbhdtt+XR1GmSKsZxKZb00S9DM6b8ZXEi3kMugKxmqYQwTjyTGsSDuJfcVuhPK0D1
         c5HGwP/VwUp7eHZE1Yc11rjGoaknKWwcntZd8SUu8WOfV2JRoQR2kVNJ3//zMHn/4ai4
         eBbZ5iRYT+HgngGTFswzITKS/3leCLCgQLtQXHUWPLXJME757X0Dh/wY7KnvqXyjNonS
         CllEX8N9LdBNKf+lBwSnboio+q1dMy/oRnDd2Nb6h9TE9A9yMrsJvIA8n7E3Z5pURVBW
         IM9A==
X-Gm-Message-State: AO0yUKUYKAqE9hjPbGNAnl/BgcOxH2/odUXroNFRpPx1RKePIM3fyPRs
        +n9AJinhxxIbdoLIDmdH9X2kq6TD6EajPi+Uav4=
X-Google-Smtp-Source: AK7set/EtX+SgpkoznRcITN9MVg+hHW+EnFeFyTVxbfKXz3lhcaL8K4a2zoLBIfz184EmcvECWezt8ZWXY4Ca+2IH0A=
X-Received: by 2002:a2e:a26e:0:b0:295:a32a:3664 with SMTP id
 k14-20020a2ea26e000000b00295a32a3664mr1561494ljm.5.1677643083850; Tue, 28 Feb
 2023 19:58:03 -0800 (PST)
MIME-Version: 1.0
References: <20230228235624.5451-1-linkinjeon@kernel.org>
In-Reply-To: <20230228235624.5451-1-linkinjeon@kernel.org>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 28 Feb 2023 21:57:52 -0600
Message-ID: <CAH2r5mvEK37L6iniO5bt7PB8XjA7Oc9zi8ujo1UzBogiXDf0KQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix wrong signingkey creation when encryption is AES256
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, senozhatsky@chromium.org,
        tom@talpey.com, Miao Lihua <441884205@qq.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

FYI - Linux client also supports AES GCM 256 encryption.  It is
enabled by default and can be set to required with:

MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM
encryption. Default: n/N/0");

On Tue, Feb 28, 2023 at 5:57=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> MacOS and Win11 support AES256 encrytion and it is included in the cipher
> array of encryption context. Especially on macOS, The most preferred
> cipher is AES256. Connecting to ksmbd fails on newer MacOS clients that
> support AES256 encryption. MacOS send disconnect request after receiving
> final session setup response from ksmbd. Because final session setup is
> signed with signing key was generated incorrectly.
> For signging key, 'L' value should be initialized to 128 if key size is
> 16bytes.
>
> Reported-by: Miao Lihua <441884205@qq.com>
> Tested-by: Miao Lihua <441884205@qq.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/auth.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
> index 6e61b5bc7d86..cead696b656a 100644
> --- a/fs/ksmbd/auth.c
> +++ b/fs/ksmbd/auth.c
> @@ -727,8 +727,9 @@ static int generate_key(struct ksmbd_conn *conn, stru=
ct ksmbd_session *sess,
>                 goto smb3signkey_ret;
>         }
>
> -       if (conn->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_CCM ||
> -           conn->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_GCM)
> +       if (key_size =3D=3D SMB3_ENC_DEC_KEY_SIZE &&
> +           (conn->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_CCM ||
> +            conn->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_GCM))
>                 rc =3D crypto_shash_update(CRYPTO_HMACSHA256(ctx), L256, =
4);
>         else
>                 rc =3D crypto_shash_update(CRYPTO_HMACSHA256(ctx), L128, =
4);
> --
> 2.25.1
>


--=20
Thanks,

Steve
