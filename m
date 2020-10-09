Return-Path: <SRS0=sO7z=DQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E1EDC433DF
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Oct 2020 05:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08A202222F
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Oct 2020 05:44:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XgVeU4i2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgJIFn7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Oct 2020 01:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729877AbgJIFnW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Oct 2020 01:43:22 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1E0C0613D2
        for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2020 22:43:21 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id a7so8308108lfk.9
        for <linux-cifs@vger.kernel.org>; Thu, 08 Oct 2020 22:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kXHPFApdekDliC8bum5h3hXT8xq7ASeAt/aknliLe6M=;
        b=XgVeU4i23u7KoC5AlMlWGdTKBjn8V7rUCuMmv/f1kQl4CnfSyAxyBpBP8rvwUqj2k9
         RkPkwa+Ugwqk+yiAFIPZ8kJLaWjngTiTM4/ATEQ7S1mNIv3PTDmumJMK9nQWUj6n+FbM
         YQJj2FcblqwYS1Etnzxe8+88PgxZIxbdBElKqJbSDF3GmvICOA0ww6b9BZyATv8JRyHI
         C+sGog6Hf39Tv+wpev84RHkleDPGNLmR9P9W0HgOX1voQWV24OMU1muS3TJJaN5vlIsy
         BohGWGJzVdXAMguIARpS0xCGf6KlfbgUFoD5hP+jnTpq+/vMyVWsxvtZvCWjp/3bBgsx
         UzDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kXHPFApdekDliC8bum5h3hXT8xq7ASeAt/aknliLe6M=;
        b=mjrPBFNpbqPTUIksS+gO10d1BKAudC/9iTL2l40jLzWV/OC5uRgmF2ypoaBqieB490
         xGPnBQI2yU/UbBRhH3SsQT4tm0Fx5601IdqbtmF5IrgkYF/3zvY6d0Gc+g53w/CryitI
         4Xq35TPUtu+eQtF25bz9ex8T0IIwe3G+JzVjVOgUMsUlYct0JyhqTDWhYJyDRXEQAVZz
         nfZPcWU9zREGoCbDBhFG+EQLb4tUIhKiEhMUTfNpS6EVoIYx+LFPonvw/Hd4vbb7slKP
         4VA5oPU6J2a7oy8P7I3XwtI0M9U0C/emtwJFsBl9w1nmCJxOzh9r5/CeaKLuq+aF6zR/
         PkJw==
X-Gm-Message-State: AOAM5304dwdQs97N3UWYAneyFpxiBWadJR5QjeVkHCdjDirX0TRKb/rQ
        7X6GoDLwdsYnjaGgcQbxNRJVc+pa6m1PQ1BduLE=
X-Google-Smtp-Source: ABdhPJxGL3nLjxGFS+QuT7NDSMSBxRUJJoEJa3f1wBhPF24/Ili9K1h05cwBHTmWMvJd2RDfoMo7w2xkya1ceVdBUZ4=
X-Received: by 2002:a05:6512:717:: with SMTP id b23mr3907905lfs.165.1602222198511;
 Thu, 08 Oct 2020 22:43:18 -0700 (PDT)
MIME-Version: 1.0
References: <20201008233256.27472-1-lsahlber@redhat.com>
In-Reply-To: <20201008233256.27472-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 9 Oct 2020 00:43:07 -0500
Message-ID: <CAH2r5ms0w1zZwo85RL8CbZKR40QMOPEvkf2iKeHXaHh0HYnagw@mail.gmail.com>
Subject: Re: [PATCH] cifs: handle -EINTR in cifs_setattr
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged updated patch into cifs-2.6.git for-next

On Thu, Oct 8, 2020 at 6:33 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> RHBZ: 1848178
>
> Some calls that set attributes, like utimensat(), are not supposed to return
> -EINTR and thus do not have handlers for this in glibc which causes us
> to leak -EINTR to the applications which are also unprepared to handle it.
>
> For example tar will break if utimensat() return -EINTR and abort unpacking
> the archive. Other applications may break too.
>
> To handle this we add checks, and retry, for -EINTR in cifs_setattr()
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/inode.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 3989d08396ac..0bd22c41a623 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -2879,13 +2879,18 @@ cifs_setattr(struct dentry *direntry, struct iattr *attrs)
>  {
>         struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
>         struct cifs_tcon *pTcon = cifs_sb_master_tcon(cifs_sb);
> +       int rc, retries = 0;
>
> -       if (pTcon->unix_ext)
> -               return cifs_setattr_unix(direntry, attrs);
> -
> -       return cifs_setattr_nounix(direntry, attrs);
> +       do {
> +               if (pTcon->unix_ext)
> +                       rc = cifs_setattr_unix(direntry, attrs);
> +               else
> +                       rc = cifs_setattr_nounix(direntry, attrs);
> +               retries++;
> +       } while (is_retryable_error(rc) && retries < 2);
>
>         /* BB: add cifs_setattr_legacy for really old servers */
> +       return rc;
>  }
>
>  #if 0
> --
> 2.13.6
>


-- 
Thanks,

Steve
