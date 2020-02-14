Return-Path: <SRS0=N0Uh=4C=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 473CDC35242
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Feb 2020 05:32:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17CF2217F4
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Feb 2020 05:32:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ngX4VZK4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgBNFcy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Feb 2020 00:32:54 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:34803 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgBNFcy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Feb 2020 00:32:54 -0500
Received: by mail-il1-f196.google.com with SMTP id l4so7092158ilj.1
        for <linux-cifs@vger.kernel.org>; Thu, 13 Feb 2020 21:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tjS7ZtfBpAqwvAWPLgcFa5bEZL3CSDj8P9n48nwcsOo=;
        b=ngX4VZK4JiTcKPuU9Lvk1Op2mBSu74lAHU6kjUN3P43oJPJ6LciKSOrijk48kXrmwM
         fNNsC+kdyeL9+ZDFndsLrmR+NaYtgBaCTh+bq/GqWpR2Mw1kY2BRiSXkzFoUsoYoq2Sp
         VJAiI5UCRT6Uok6asIF6k6vXN1f4ZsN4vL/PUSqAp5GONyX4hg9Yo2cyS7BzcrsX7Wpr
         LqE0+0BJz3CTaL3QaUPHK9RgJxB0FszZSvmD+hEmgj0BOdmJe7H/L12OdhtHd9uyx5FE
         aguucz0204PnEAqNnzgXLtkQaNmC37Xqqf6An5X9+rfalMrrpKn2nCUvd8+5u+nlAYtp
         Elug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tjS7ZtfBpAqwvAWPLgcFa5bEZL3CSDj8P9n48nwcsOo=;
        b=PNgLkhrGv6k9C+S5LEdfaxbH+nmOE3+WWlZNncg/fzrEBLW40PmhDPa49eYiIyZNP6
         pnTfOxrL/k5oOOE0J2Ul1Qn5wTr+H3MSwz2fEnYJ11eQJ5vm3OC+umhA/JX6C6rhD3YI
         74m7WvlQRMPK42Nt3A+BQ1pNsr82Jm+ccfUZhDaCqngEODQrSQ3wtGcyZs+m6q6fRys1
         ml/GQ3jN7Ks7RNl96+cUkbGOQyoHmmqMSNujj+7Nw5l4HYszX1Zx/S+D1GKRjYmBs8ei
         +5H8caYi/c7jDab5b6TKXFnBnj2BOkbmTCDPttCDPuEKAwMVFguLGgqdrXu0ycvfHYFG
         cSZg==
X-Gm-Message-State: APjAAAWm+HgE6CQQhc+C9HhVw1FF8F+hB+yRBAESi4LKaZius+XFdrzf
        WkLBGz4x2b5roHx19j7eNszKn7rjcda0iaE7m6FlLmft
X-Google-Smtp-Source: APXvYqz6AWPTvdsWhmsdCL9rXpQ+2YB6U0F45G3mO2zECyDOTezpK5Ks8e41PhPxMWz/uuHxjjhGEGNNkFi1DMbeQSU=
X-Received: by 2002:a92:9f1b:: with SMTP id u27mr1405250ili.173.1581658373703;
 Thu, 13 Feb 2020 21:32:53 -0800 (PST)
MIME-Version: 1.0
References: <20200214043513.uh2jtb62qf54nmud@xzhoux.usersys.redhat.com>
In-Reply-To: <20200214043513.uh2jtb62qf54nmud@xzhoux.usersys.redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 13 Feb 2020 23:32:42 -0600
Message-ID: <CAH2r5msoTB2_TB3kefknp_AeiE62Ed4m5zO6UmKvQt6wovGa9g@mail.gmail.com>
Subject: Re: [PATCH] CIFS: unlock file across process
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Thu, Feb 13, 2020 at 10:35 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
>
> Now child can't unlock the same file that has been locked by
> parent. Fix this by not skipping unlock if requesting from
> different process.
>
> Patch tested by LTP and xfstests using samba server.
>
> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> ---
>  fs/cifs/smb2file.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
> index afe1f03aabe3..b5bca0e13d51 100644
> --- a/fs/cifs/smb2file.c
> +++ b/fs/cifs/smb2file.c
> @@ -151,8 +151,6 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
>                     (flock->fl_start + length) <
>                     (li->offset + li->length))
>                         continue;
> -               if (current->tgid != li->pid)
> -                       continue;
>                 if (cinode->can_cache_brlcks) {
>                         /*
>                          * We can cache brlock requests - simply remove a lock
> --
> 2.20.1
>


-- 
Thanks,

Steve
