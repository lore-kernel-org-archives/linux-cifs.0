Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C681C04A95
	for <linux-cifs@archiver.kernel.org>; Sun, 25 Sep 2022 13:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiIYNSZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 25 Sep 2022 09:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiIYNSZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 25 Sep 2022 09:18:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED362D772
        for <linux-cifs@vger.kernel.org>; Sun, 25 Sep 2022 06:18:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA449B80946
        for <linux-cifs@vger.kernel.org>; Sun, 25 Sep 2022 13:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4267DC433C1
        for <linux-cifs@vger.kernel.org>; Sun, 25 Sep 2022 13:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664111901;
        bh=WBZelspSn21SqpiI2KUKRURUenQh2cfLAkW73b376sE=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=FK9A+uY90DMLQAl/eB0eQg9LTLb1BTDdoxF3RpT9Ms4rOPdZ3s4QHXP9/c9KCkKx4
         W8u7Wzd22jZ4sZ0eKvrepFtbf++Rh0PCZLegiEXIHoEP0iVCPRaiV0Nl7XN9nA+8iz
         H6baKqjCs/4yXLjvRDVlZtxsbJczgB1rFQiIyt2yuSzoa4yliMTgVSJayAWEiAfbnJ
         MXgyK6v0TD9u5Rvf/Oxol5Q0nqGl7sWrUKfXkgEVwUAHOIHWJUiGoC9jXFE/Y/Qcn5
         1WIY34QvEGO324WrNnt0/NoHjHv64goe3SVHeXklvexRb9ri2Dv+rqf/mscq6eO/ri
         fEb+/Kkmq7evA==
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-12b542cb1d3so6164750fac.13
        for <linux-cifs@vger.kernel.org>; Sun, 25 Sep 2022 06:18:21 -0700 (PDT)
X-Gm-Message-State: ACrzQf1ho4bx4Z0rk6gSPsQ5XjnnAVv2gkj05lsWSq0YUhZmbOp9x4/0
        FEWa072w0O346GdU0XC1cA80pjo79tagtG6Bd8o=
X-Google-Smtp-Source: AMsMyM4AbEBJETHNTOVPdcL1VQknIzEpLNn1i/LhVmDmNr4PD1JJGzZlMF/OrC3RkYKCTmJ5T2wXj3I+HIkzt0MDYzI=
X-Received: by 2002:a05:6870:9a26:b0:12d:7e1:e9c7 with SMTP id
 fo38-20020a0568709a2600b0012d07e1e9c7mr10573315oab.257.1664111900378; Sun, 25
 Sep 2022 06:18:20 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Sun, 25 Sep 2022 06:18:19
 -0700 (PDT)
In-Reply-To: <20220924022313.281318-1-atteh.mailbox@gmail.com>
References: <20220924022313.281318-1-atteh.mailbox@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 25 Sep 2022 22:18:19 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8MtTXfzm16a1+f=dCR4VVLx5Hre9rQqh4Z5cA=B_hr0Q@mail.gmail.com>
Message-ID: <CAKYAXd8MtTXfzm16a1+f=dCR4VVLx5Hre9rQqh4Z5cA=B_hr0Q@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: make utf-8 file name comparison work in __caseless_lookup()
To:     =?UTF-8?Q?Atte_Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-24 11:23 GMT+09:00, Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>:
> Case-insensitive file name lookups with __caseless_lookup() use
> strncasecmp() for file name comparison. strncasecmp() assumes an
> ISO8859-1-compatible encoding, which is not the case here as UTF-8
> is always used. As such, use of strncasecmp() here produces correct
> results only if both strings use characters in the ASCII range only.
> Fix this by using utf8_strncasecmp() if CONFIG_UNICODE is set. On
> failure or if CONFIG_UNICODE is not set, fallback to strncasecmp().
> Also, as we are adding an include for `linux/unicode.h', include it
> in `fs/ksmbd/connection.h' as well since it should be explicit there.
>
> Signed-off-by: Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>
> ---
>  fs/ksmbd/connection.h |  1 +
>  fs/ksmbd/vfs.c        | 20 +++++++++++++++++---
>  fs/ksmbd/vfs.h        |  2 ++
>  3 files changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
> index 41d96f5cef06..3643354a3fa7 100644
> --- a/fs/ksmbd/connection.h
> +++ b/fs/ksmbd/connection.h
> @@ -14,6 +14,7 @@
>  #include <net/request_sock.h>
>  #include <linux/kthread.h>
>  #include <linux/nls.h>
> +#include <linux/unicode.h>
>
>  #include "smb_common.h"
>  #include "ksmbd_work.h"
> diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
> index 4fcf96a01c16..a3269df7c7b3 100644
> --- a/fs/ksmbd/vfs.c
> +++ b/fs/ksmbd/vfs.c
> @@ -1145,12 +1145,23 @@ static int __caseless_lookup(struct dir_context
> *ctx, const char *name,
>  			     unsigned int d_type)
>  {
>  	struct ksmbd_readdir_data *buf;
> +	int cmp;
cmp should be initialized with -EINVAL to fallback strncasecmp() ?

>
>  	buf =3D container_of(ctx, struct ksmbd_readdir_data, ctx);
>
>  	if (buf->used !=3D namlen)
>  		return 0;
> -	if (!strncasecmp((char *)buf->private, name, namlen)) {
> +	if (IS_ENABLED(CONFIG_UNICODE) && buf->um) {
> +		const struct qstr q_buf =3D {.name =3D buf->private,
> +					   .len =3D buf->used};
> +		const struct qstr q_name =3D {.name =3D name,
> +					    .len =3D namlen};
> +
> +		cmp =3D utf8_strncasecmp(buf->um, &q_buf, &q_name);
> +	}
> +	if (!(IS_ENABLED(CONFIG_UNICODE) && buf->um) || cmp < 0)
I wonder why ->um is checked with CONFIG_UNICODE.

Thanks.
> +		cmp =3D strncasecmp((char *)buf->private, name, namlen);
> +	if (!cmp) {
>  		memcpy((char *)buf->private, name, namlen);
>  		buf->dirent_count =3D 1;
>  		return -EEXIST;
> @@ -1166,7 +1177,8 @@ static int __caseless_lookup(struct dir_context *ct=
x,
> const char *name,
>   *
>   * Return:	0 on success, otherwise error
>   */
> -static int ksmbd_vfs_lookup_in_dir(const struct path *dir, char *name,
> size_t namelen)
> +static int ksmbd_vfs_lookup_in_dir(const struct path *dir, char *name,
> +				   size_t namelen, struct unicode_map *um)
>  {
>  	int ret;
>  	struct file *dfilp;
> @@ -1176,6 +1188,7 @@ static int ksmbd_vfs_lookup_in_dir(const struct pat=
h
> *dir, char *name, size_t na
>  		.private	=3D name,
>  		.used		=3D namelen,
>  		.dirent_count	=3D 0,
> +		.um		=3D um,
>  	};
>
>  	dfilp =3D dentry_open(dir, flags, current_cred());
> @@ -1238,7 +1251,8 @@ int ksmbd_vfs_kern_path(struct ksmbd_work *work, ch=
ar
> *name,
>  				break;
>
>  			err =3D ksmbd_vfs_lookup_in_dir(&parent, filename,
> -						      filename_len);
> +						      filename_len,
> +						      work->conn->um);
>  			path_put(&parent);
>  			if (err)
>  				goto out;
> diff --git a/fs/ksmbd/vfs.h b/fs/ksmbd/vfs.h
> index d7542a2dab52..593059ca8511 100644
> --- a/fs/ksmbd/vfs.h
> +++ b/fs/ksmbd/vfs.h
> @@ -12,6 +12,7 @@
>  #include <linux/namei.h>
>  #include <uapi/linux/xattr.h>
>  #include <linux/posix_acl.h>
> +#include <linux/unicode.h>
>
>  #include "smbacl.h"
>  #include "xattr.h"
> @@ -60,6 +61,7 @@ struct ksmbd_readdir_data {
>  	unsigned int		used;
>  	unsigned int		dirent_count;
>  	unsigned int		file_attr;
> +	struct unicode_map	*um;
>  };
>
>  /* ksmbd kstat wrapper to get valid create time when reading dir entry *=
/
> --
> 2.37.3
>
>
