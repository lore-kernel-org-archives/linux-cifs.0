Return-Path: <SRS0=suyG=SL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46AB2C10F0E
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Apr 2019 13:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E96F2084F
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Apr 2019 13:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfDIN7v (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Apr 2019 09:59:51 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42628 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbfDIN7v (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Apr 2019 09:59:51 -0400
Received: by mail-qt1-f195.google.com with SMTP id p20so19801582qtc.9
        for <linux-cifs@vger.kernel.org>; Tue, 09 Apr 2019 06:59:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x0cZ+g683FZyBL7+frGl602RNkveClouz8ahLCcu1JU=;
        b=npueRfegWHRxgL3G1NrkF71aQrnZkhpR5uBU4jSj58p+cBme097FjAZOh1gJCwIiSL
         7VuPobMCwUuMpiDSVTpWu77OsbLOyUwY2Q5MhaV0ID+SxqNNGfn9+ikDztJbImBxVOc0
         D0surdrtH7fzkVqdWasfxohbfwAl4S0VAApiuf+Q+DkgXVKEsK4LtjWXM7WoxQMWaTKZ
         LeWwZvbNY4dPWAshDiF/FFvIV+FnAOmouxxrooT2Xigv5xdGv0feXmI7nb7jUw4a81Uc
         hxJyyX/7/9XmfeTst4zXcK6AwsGrqqEX67nAuwTGR0yiLSiHGZ+tJFpdhrDdBc4oQG2T
         s8Xw==
X-Gm-Message-State: APjAAAXe8FFmrGtspbI1+TeISXajSXQBlYdyXA0QYcLZJ8gEI0djvyUm
        bpRp9xLWZ7MRp01Wc4nG88Prm3qYY4vEa0kpjqw76A==
X-Google-Smtp-Source: APXvYqwq/vRwyHHPEKnBd/5CG8/lSMeWGMuxfwgNQ3DV7hSVbpqVRuszBWmPBqLajuZxqDqQJ6POyf6siz259flMxgE=
X-Received: by 2002:a0c:b656:: with SMTP id q22mr29744135qvf.205.1554818390493;
 Tue, 09 Apr 2019 06:59:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190409131716.15212-1-xifeng@redhat.com>
In-Reply-To: <20190409131716.15212-1-xifeng@redhat.com>
From:   Kenneth Dsouza <kdsouza@redhat.com>
Date:   Tue, 9 Apr 2019 19:29:39 +0530
Message-ID: <CAA_-hQJjJUGKTRenzqgSCjsc9BnL1B=aGgfBZjF+O6yywiovSg@mail.gmail.com>
Subject: Re: [PATCH v1] CIFS: display noacl and locallease in the mount options
To:     XiaoLi Feng <xifeng@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        "fengxiaoli0714@gmai.com" <fengxiaoli0714@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We already have locallease patch in for next.
https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=1d4fcc75b71f8a9f9807a000da53d9885546e2f3
Can you resend this patch only for noacl?

On Tue, Apr 9, 2019 at 6:47 PM XiaoLi Feng <xifeng@redhat.com> wrote:
>
> From: "fengxiaoli0714@gmai.com" <fengxiaoli0714@gmail.com>
>
> The mount option noacl and locallease aren't shown in /proc/mounts
> even if they are mounted successfully. Now display them.
>
> Signed-off-by: fengxiaoli0714@gmai.com <fengxiaoli0714@gmail.com>
> ---
>  fs/cifs/cifsfs.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index f9b71c12cc9f..44dbace210d2 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -503,6 +503,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
>                 seq_puts(s, ",unix");
>         else
>                 seq_puts(s, ",nounix");
> +       if (tcon->local_lease)
> +               seq_puts(s, ",locallease");
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS)
>                 seq_puts(s, ",nodfs");
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
> @@ -535,6 +537,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
>                 seq_puts(s, ",dynperm");
>         if (root->d_sb->s_flags & SB_POSIXACL)
>                 seq_puts(s, ",acl");
> +       else
> +               seq_puts(s, ",noacl");
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
>                 seq_puts(s, ",mfsymlinks");
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)
> --
> 2.18.1
>
