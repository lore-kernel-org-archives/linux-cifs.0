Return-Path: <SRS0=G37X=TC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F0AC43219
	for <linux-cifs@archiver.kernel.org>; Thu,  2 May 2019 15:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1FB520675
	for <linux-cifs@archiver.kernel.org>; Thu,  2 May 2019 15:13:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JlolP3VN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbfEBPNg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 May 2019 11:13:36 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33493 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfEBPNg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 May 2019 11:13:36 -0400
Received: by mail-pl1-f194.google.com with SMTP id y3so1184641plp.0
        for <linux-cifs@vger.kernel.org>; Thu, 02 May 2019 08:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ytkeotxqZMK+Pphx8YBNVSrBa2jJYvjrofY1/wEO/Ns=;
        b=JlolP3VNtmB3piHgYExaILh0eaeOxzoKa+o453ZqajfxAFvKoQc6BLCOE75V5ReScE
         refIkDa20vnCkTZiqEkYTvrI0jqEEh2AXSNySkCe7iI69qIbcjROTlYKzM4Ba57b+FQK
         02eBqdG37b38nBHCUVa9VLn9HTBOMFWMyQdTySHfwJgHS4PKg6+SzgakucErnmOLwuJo
         unnkASs6OnyWNP7qUB6BkC/H/MbJGmRJo2OSfr/7YlN2upBwcECQSdIes8RZkmzxzvE7
         agwihi4+d5t4uoL7qz6h0+NH6Z7J6XEuyJKC+OdEBIDw7Bk1CYl9bQM5B+GxKZ8u2nvD
         KUiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ytkeotxqZMK+Pphx8YBNVSrBa2jJYvjrofY1/wEO/Ns=;
        b=oWaQ0oGEztB2vBsObwYoRgKxA85TS6bh2A3MI0hQJsWphyXsymb/A+EGy5NbE8n/X5
         UWyyuhzzr4lS2seHmOn8Ww4BW8VngZVYTDaCdcKKFBGUy52j8bHe34BTMZLSFdoNsgjt
         zN8QnhoKjp4ej2BMK8cagBUNWchbJZAWtIoibxrb3jOgfK13EPIfW4213c+zpIXD+/2s
         BDBFBLx3zWpKBtcVcpfRiKVSG3sReEOntrmeLXwZBQIRylyvu/tJQrCFH8f3QIT2p7W2
         Pi0jnyo5LC37R9OOHlZCMflxLwJxxd1yqNSIywy/8hydK3RSo8fI/dpBSfIFLS6xgTbT
         5Pzw==
X-Gm-Message-State: APjAAAUV47wtfh2qS4gUoUU+r+HiibTM4xuNfIO5PB1HpepLgiUX+el9
        NbwDw9W+Zny1BqejJ4dpFBgbAfD1y7xL9U8CE8k=
X-Google-Smtp-Source: APXvYqxRaVJ1ZvMD65K8iaD0idLyT/VtUkYbZ8zzx61uHRVijYtv/xeXUpqjfHikDuVpgLwynuVM9Erapx7YybujNYo=
X-Received: by 2002:a17:902:b617:: with SMTP id b23mr4120030pls.73.1556810015180;
 Thu, 02 May 2019 08:13:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190501205541.GC30899@veci.piliscsaba.redhat.com>
In-Reply-To: <20190501205541.GC30899@veci.piliscsaba.redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 2 May 2019 10:13:23 -0500
Message-ID: <CAH2r5mt+j9ozVuvNB8qZ=KmnHHqT4Vyd6f_jKVY2232aECH04w@mail.gmail.com>
Subject: Re: [RFC PATCH] network fs notification
To:     Miklos Szeredi <miklos@szeredi.hu>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Adding linux-cifs

Will take a look today - looks promising

On Wed, May 1, 2019 at 3:55 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> This is a really really trivial first iteration, but I think it's enough to
> try out CIFS notification support.  Doesn't deal with mark deletion, but
> that's best effort anyway: fsnotify() will filter out unneeded events.
>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/notify/fanotify/fanotify_user.c |    6 +++++-
>  fs/notify/inotify/inotify_user.c   |    2 ++
>  include/linux/fs.h                 |    1 +
>  3 files changed, 8 insertions(+), 1 deletion(-)
>
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -1041,9 +1041,13 @@ static int do_fanotify_mark(int fanotify
>                 else if (mark_type == FAN_MARK_FILESYSTEM)
>                         ret = fanotify_add_sb_mark(group, mnt->mnt_sb, mask,
>                                                    flags, fsid);
> -               else
> +               else {
>                         ret = fanotify_add_inode_mark(group, inode, mask,
>                                                       flags, fsid);
> +
> +                       if (!ret && inode->i_op->notify_update)
> +                               inode->i_op->notify_update(inode);
> +               }
>                 break;
>         case FAN_MARK_REMOVE:
>                 if (mark_type == FAN_MARK_MOUNT)
> --- a/fs/notify/inotify/inotify_user.c
> +++ b/fs/notify/inotify/inotify_user.c
> @@ -754,6 +754,8 @@ SYSCALL_DEFINE3(inotify_add_watch, int,
>
>         /* create/update an inode mark */
>         ret = inotify_update_watch(group, inode, mask);
> +       if (!ret && inode->i_op->notify_update)
> +               inode->i_op->notify_update(inode);
>         path_put(&path);
>  fput_and_out:
>         fdput(f);
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1852,6 +1852,7 @@ struct inode_operations {
>                            umode_t create_mode);
>         int (*tmpfile) (struct inode *, struct dentry *, umode_t);
>         int (*set_acl)(struct inode *, struct posix_acl *, int);
> +       void (*notify_update)(struct inode *inode);
>  } ____cacheline_aligned;
>
>  static inline ssize_t call_read_iter(struct file *file, struct kiocb *kio,



-- 
Thanks,

Steve
