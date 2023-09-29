Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F705E743D5
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Sep 2023 01:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjI2BN0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Sep 2023 21:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjI2BN0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Sep 2023 21:13:26 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B157BB4
        for <linux-cifs@vger.kernel.org>; Thu, 28 Sep 2023 18:13:24 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-578e33b6fb7so9255127a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 28 Sep 2023 18:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695950004; x=1696554804; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TbeWfwG75zEQCK9QefBYxhqqSXb/yT50z++T20psATk=;
        b=f96IAaZV0IFz1ObgZZlu4lj6rrgAinU6B7tFf6Z5yaFxVa+hviZC6efx/iGS03n8Eg
         /LmoLo/b30QfdzSxpDyW4nZzsnr2n0fkSHA7J0HwBRbQ4JUipH+69EaX1mGFxBdXIMZq
         VgQOESSJ2tdtPskUVghZL+JOh6wyPanEyEzVJiXSuOFPPpMGHjFdVGtDMu0+PfCH6jya
         jl+53O7ijK7j0TB+SNeQPcwKpH1q8Gn7ZYE1GLlDQbk4rZBc2iC7ucTJIKvRUfSfhKsb
         mZmBSvDGnb1y262+OXMf8V+Qi8RlxImlLoME2Am7HENP3ANVPY9ymICKxiD7/QWj0EF2
         wL5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695950004; x=1696554804;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TbeWfwG75zEQCK9QefBYxhqqSXb/yT50z++T20psATk=;
        b=TZOTc0wMsdNBCqVdhlctJTR05Yc24hGm2/MiUThpN14jdzwEdn58sQGUMEeHLVGPSi
         PgiT6N/8uHv3RL9AOt+wxNcdDM8EiDb6oPETmrctruAYEorCc/0a6QNK9aiI2Sb1lW/r
         32j6urbbhjC/BgrKmKCXiMer5cChm58yAwKSxcT9ZWQ+dANhFQf8Wi1/Vq0f4LFyRszT
         uhbnoS6EPKpaxo/VnZt81exBIwyGoK3saXpaKoIz4WCiTqyBCMWI/Li6kmiWn1zESuc2
         1ok2GMnfKDdvYSJjHLJ56+Y6jYHSed5K5AXWfDmF9defM3EHgZ9lQVs7cbB8+XtcSMil
         50NQ==
X-Gm-Message-State: AOJu0Yxx9h14vFB6yJYGIHZOHpx5NG06YRCq0mFPwWxXewoIaUs7KTut
        fZj5eq7frNsrzoGhMgBniyRYDLdoiQV7kxuo7LI=
X-Google-Smtp-Source: AGHT+IFam2/hX/foIN6jUSFUH6EqSrRAPdl0XaHCIFsVXNrIycsu4HVdRUNaKbWY2P5db1ERoaM+bFT6QU1OFYoEFkM=
X-Received: by 2002:a17:90b:603:b0:26d:1a49:d1e9 with SMTP id
 gb3-20020a17090b060300b0026d1a49d1e9mr2805934pjb.17.1695950003986; Thu, 28
 Sep 2023 18:13:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230927143009.8882-1-linkinjeon@kernel.org>
In-Reply-To: <20230927143009.8882-1-linkinjeon@kernel.org>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 29 Sep 2023 11:13:12 +1000
Message-ID: <CAN05THR3RJmvqYwjrEY=g0bbVZj-hHNCsRO3o6dt9nrBKjpMsA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: not allow to open file if delelete on close bit is set
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, tom@talpey.com, hyc.lee@gmail.com,
        atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, 28 Sept 2023 at 00:44, Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> Cthon test fail with the following error.
>
> check for proper open/unlink operation
> nfsjunk files before unlink:
>   -rwxr-xr-x 1 root root 0  9=EC=9B=94 25 11:03 ./nfs2y8Jm9
> ./nfs2y8Jm9 open; unlink ret =3D 0
> nfsjunk files after unlink:
>   -rwxr-xr-x 1 root root 0  9=EC=9B=94 25 11:03 ./nfs2y8Jm9
> data compare ok
> nfsjunk files after close:
>   ls: cannot access './nfs2y8Jm9': No such file or directory
> special tests failed
>
> Cthon expect to second unlink failure when file is already unlinked.
> ksmbd can not allow to open file if flags of ksmbd inode is set with
> S_DEL_ON_CLS flags.
>
> Reported-by: Tom Talpey <tom@talpey.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/smb/server/vfs_cache.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
> index f41f8d6108ce..f2e2a7cc24a9 100644
> --- a/fs/smb/server/vfs_cache.c
> +++ b/fs/smb/server/vfs_cache.c
> @@ -577,6 +577,11 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *=
work, struct file *filp)
>                 goto err_out;
>         }
>
> +       if (fp->f_ci->m_flags & S_DEL_ON_CLS) {
> +               ret =3D -ENOENT;
> +               goto err_out;
> +       }
> +

Is enoent the right error here? I assume that the file will still show
in a directory listing so maybe eacces would be better?


>         ret =3D __open_id(&work->sess->file_table, fp, OPEN_ID_TYPE_VOLAT=
ILE_ID);
>         if (ret) {
>                 ksmbd_inode_put(fp->f_ci);
> --
> 2.25.1
>
