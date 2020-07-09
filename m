Return-Path: <SRS0=36sk=AU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E9EC433E0
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jul 2020 16:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74E97207F9
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jul 2020 16:28:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IHhICDma"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgGIQ2t (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jul 2020 12:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbgGIQ2s (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Jul 2020 12:28:48 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8648C08C5CE
        for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2020 09:28:48 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id 187so1314458ybq.2
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2020 09:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+SPUZnqGGjdLP+rG1DqReELXlPzGAnp6VG9PW5FEWHE=;
        b=IHhICDmaSJucKDG0RVJf5/BoUQe/wnoHuXxSua+w+NDqhH+yju9u+6EjAp1AaOYnZQ
         zQnj+EwPL/TOwUVZ2qJbuEzOc5aKI51whD73hOw71PqY8n19Zk3IuGpo5JOkTWDEItiA
         dfE/wLarWGSiDelZxcdkTtmD37qacGDJyrqeq6zL054SlrNv19uP/eNhIBThRnT51Ji2
         Vs39j4AsI1X/9WHS3rYszc8dV3vq+sLG1rKBg0xUGfXN4Gv0gKXbvAdLk+/AdOWfNHAJ
         8GkCSM47vkpZM3G77tUINp1PL00KnM5KJaTR0eiImHrr1dXDqryoWnY5Jfy1HX9vQGT5
         nHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+SPUZnqGGjdLP+rG1DqReELXlPzGAnp6VG9PW5FEWHE=;
        b=erJU06hvPARn4e8/hUEwwAkVj8m2dAlVzIK5vsh/rFNMNsX6eNzhL+2k5WauEL7LVv
         68JuRoBwS0vca2W5y4++HemuturSCvirv4XaH7ieD73c5kpR2UOsDKn7v6lg95xj7FdB
         wxBBx1OeHqAZAslV/HQ23SwYGYzPw5pbuRZyxo3EQNkDXGAAci5misavrSOQ8kwMLRqz
         jcVHW1F9q+3r8FIF2ZnqO5AWXdeI2lN3eqFonwLVRrMHnQFCwKyEUu5tko8PqLjuoPZ9
         u8thKJgZai2dvsvuM3FOQUvXNVucxqpyx2bYG1XYoVHoriT7xVzkARFy42F0o4hrXOnD
         78yw==
X-Gm-Message-State: AOAM531bEBhZRF1348Xla49L02HAPF8JE+TQ1rWWEWleZfAz2YCLWuB+
        xorRSz4L5sbBI4lKvFcccZy3rIEnjKeuWrLkXKo=
X-Google-Smtp-Source: ABdhPJztqAU0r4oeaktbHZxYnYVBZ3n8DZmrJmFJBMw2ineRtDSoyMW+UO8XQ7d1hn3ABv9rl9J9e/j7PD1T91jt5dU=
X-Received: by 2002:a25:56c3:: with SMTP id k186mr78414123ybb.183.1594312127989;
 Thu, 09 Jul 2020 09:28:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200709103949.29944-1-lsahlber@redhat.com>
In-Reply-To: <20200709103949.29944-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 9 Jul 2020 11:28:36 -0500
Message-ID: <CAH2r5muBVTkbJjQz6ELB_a-WU9Vcq=cNzAcAtpzY64Pxt0tvDw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix reference leak for tlink
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/367
running regression tests with this and the other 3 patches

On Thu, Jul 9, 2020 at 5:41 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Don't leak a reference to tlink during the NOTIFY ioctl
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/ioctl.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> index 4a73e63c4d43..dcde44ff6cf9 100644
> --- a/fs/cifs/ioctl.c
> +++ b/fs/cifs/ioctl.c
> @@ -169,6 +169,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
>         unsigned int xid;
>         struct cifsFileInfo *pSMBFile = filep->private_data;
>         struct cifs_tcon *tcon;
> +       struct tcon_link *tlink;
>         struct cifs_sb_info *cifs_sb;
>         __u64   ExtAttrBits = 0;
>         __u64   caps;
> @@ -307,13 +308,19 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
>                                 break;
>                         }
>                         cifs_sb = CIFS_SB(inode->i_sb);
> -                       tcon = tlink_tcon(cifs_sb_tlink(cifs_sb));
> +                       tlink = cifs_sb_tlink(cifs_sb);
> +                       if (IS_ERR(tlink)) {
> +                               rc = PTR_ERR(tlink);
> +                               break;
> +                       }
> +                       tcon = tlink_tcon(tlink);
>                         if (tcon && tcon->ses->server->ops->notify) {
>                                 rc = tcon->ses->server->ops->notify(xid,
>                                                 filep, (void __user *)arg);
>                                 cifs_dbg(FYI, "ioctl notify rc %d\n", rc);
>                         } else
>                                 rc = -EOPNOTSUPP;
> +                       cifs_put_tlink(tlink);
>                         break;
>                 default:
>                         cifs_dbg(FYI, "unsupported ioctl\n");
> --
> 2.13.6
>


-- 
Thanks,

Steve
