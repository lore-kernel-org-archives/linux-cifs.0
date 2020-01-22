Return-Path: <SRS0=MBFb=3L=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 663BAC2D0CE
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Jan 2020 01:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 323912253D
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Jan 2020 01:29:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iZmY8KLf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgAVB3p (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Jan 2020 20:29:45 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:43841 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728750AbgAVB3p (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Jan 2020 20:29:45 -0500
Received: by mail-io1-f67.google.com with SMTP id n21so4923424ioo.10
        for <linux-cifs@vger.kernel.org>; Tue, 21 Jan 2020 17:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eJlyVnsvZxGfm93O697J4PAmCGTtCvIz4q+ZswqLvGM=;
        b=iZmY8KLfQ9wligsNH9lQMIpbjf+9L9rTyIvxiNoIPEV+tn1Na+KrTxFlhUg1zLcStj
         o4ANABNcrEF63Icm37PQVlywOv8/WNaXYHrujmQ7tmB9Rmy/GcBB8QVEcdsUX9yEY7R2
         AeRGzRd0RBnVgVGImtQ63ukZyyk0YTkIB5l0l6ysfeVckZCrfkKm45vkB2z7jBvjphGX
         cVo/tBTvHsRiL/5TjypRFjVMkxl34WkfKojfg5hPMOAESIam2CxzAOvyAB3ABK9CHrVl
         Ssszp1fGwRgaTWWgHUUAJyRnj3AFnS0FUowy8Onv+YQpVuzRXoYAzLZ3V99DKAnfeKp1
         siPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eJlyVnsvZxGfm93O697J4PAmCGTtCvIz4q+ZswqLvGM=;
        b=o1Y671dZut/HQXNS+7YrwA2qKh1w0vpfJyezznXAHutHse7L++1ZjIa8baMrC8Lo1w
         oI9FV4Jdj0uzWZnsYmnyNxkOU+Xh7W58eQ0jCCYYQmZMImhBiJ+N6nmNp5iWX84vfvEU
         x4GHWL9tZa0H5YfWXTuBIHtJ9sQYFEjCOfVUBHVpuYUL6Kfnlgb9cXd5v4XNBlEFR5eE
         Z+pOAT4v1Bt/FWKK8fKa3Ra+87U2c9/5D5WKfS06gUie0Z1a4HrPOpq/Fof8mThc0EnR
         jcAaqJ60gO67vGLU9EgzoacDnvy2ufVoGk6ifR7DAf6vj4x5ud9IQCqAsuCrNcX7Cooz
         YoXA==
X-Gm-Message-State: APjAAAU7FkbnHGFo8mlE5m0ATHGBay/13C3iBhZiXierdGGvrDGYPRTf
        bWkKtJOeB6NHGH6+7i7CqwTRDJ5GZZEijJByD/c=
X-Google-Smtp-Source: APXvYqz/6bRbVKW8vM/+UZQCzN9scF3guE7bJ5zb6G/ZBqMNQoPc6IEJfkd8rgbbq5uSqlBqAJxqUPmWE6pBdvAfmKI=
X-Received: by 2002:a02:cd12:: with SMTP id g18mr5463702jaq.76.1579656584217;
 Tue, 21 Jan 2020 17:29:44 -0800 (PST)
MIME-Version: 1.0
References: <20200122010756.30245-1-lsahlber@redhat.com>
In-Reply-To: <20200122010756.30245-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 21 Jan 2020 19:29:33 -0600
Message-ID: <CAH2r5mv8cPqGaBzAOfvDhYt_Mf4Rw4k0_2q85OWxhTsOPGp8Ng@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix NULL dereference in match_prepath
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Tue, Jan 21, 2020 at 7:08 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> RHBZ: 1760879
>
> Fix an oops in match_prepath() by making sure that the prepath string is not
> NULL before we pass it into strcmp().
>
> This is similar to other checks we make for example in cifs_root_iget()
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/connect.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 05ea0e2b7e0e..0aa3623ae0e1 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3709,8 +3709,10 @@ match_prepath(struct super_block *sb, struct cifs_mnt_data *mnt_data)
>  {
>         struct cifs_sb_info *old = CIFS_SB(sb);
>         struct cifs_sb_info *new = mnt_data->cifs_sb;
> -       bool old_set = old->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH;
> -       bool new_set = new->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH;
> +       bool old_set = (old->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) &&
> +               old->prepath;
> +       bool new_set = (new->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) &&
> +               new->prepath;
>
>         if (old_set && new_set && !strcmp(new->prepath, old->prepath))
>                 return 1;
> --
> 2.13.6
>


-- 
Thanks,

Steve
