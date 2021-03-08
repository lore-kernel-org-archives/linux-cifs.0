Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EFCEC433E0
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 21:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2D1464EE7
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 21:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhCHVJt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 16:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhCHVJK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 16:09:10 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AF2C06174A
        for <linux-cifs@vger.kernel.org>; Mon,  8 Mar 2021 13:09:10 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id n22so339361wmc.2
        for <linux-cifs@vger.kernel.org>; Mon, 08 Mar 2021 13:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WDwbkZzMt07KM2n3yjwWopLS40fgmnN4z4M/mAWc6nw=;
        b=rUj7eAbTAvWO+kTX5pk8Jx6YBjGTaTzJDkeBkCyVda5rVi0ZZXl5QdZt0ONdr+cM9Z
         wylUAoQF/9ahqjZbZzkkvo8AyS4mYFUTf4v62K+VHWKtrExp//hzdIAOXg3eRK8PX1Xs
         k/MMBozioqb7R6xjfjOCaTiJ2sLemzcFT9rC2h7U/pojBzKowQ8x50zjjxUyVh5+vie3
         T4xX/1bQUWVhCaRle/H9Lc1X6XZE+0RicLSqDSWrG1vsQUHvdIwT7pr6Rl7prnF2g6n0
         yDT0onoK+LjVw47WCYs18SQEiq9+XmOI4EdqoEmfjUP8KOiZYQ80uXBPA0tnmOATwF+z
         +deQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WDwbkZzMt07KM2n3yjwWopLS40fgmnN4z4M/mAWc6nw=;
        b=MYLSnVSc5A7Vq4dugswOyl4GGiaFxyLAKwjjsK8/31yAsn1v+/97E88xyGHpMj5mfV
         t4LLWcE3BFmAVNQTt3Xvw/hMqt/rXatj67980jQw+IfvNJXnw+V8hldAAO2xOoFRQwWU
         zLVxc9fzO4BsDaic9GhdsTZDvc+TiZJVWbgsM+oM2aZmk2O031Tm/+BOV4spM0uclOZo
         XkaoRmyfIW3+MDlg5mQSlVSiNjeDlpWif5n9lBsJCniSaOwaACGUq/FgHv/G3If3MolG
         T1SqriKmrwgjyxkN036C5gn4OsLBzGTWvNUL2B6zBjFQRRCJ+3udbDLsBH8HSt9XqsDq
         zl1g==
X-Gm-Message-State: AOAM533VgvergcI0VdVdOK+OJIbxtWgjPcAReZpCe353cIyZ6Ej+2AYf
        bccHMvEnzmWKR1EZ3z8etiAv69d13lqptfmtKv0tbK6VLT0=
X-Google-Smtp-Source: ABdhPJx9rdXKiCRchozkKFKeIpOGNVdQ2qbwDWcEB/g39CtBMb4m5VdKG64kKdpPJSSIMfAYBNHqKPAe+QvX+N6G7SU=
X-Received: by 2002:a1c:7fc9:: with SMTP id a192mr607956wmd.15.1615237748899;
 Mon, 08 Mar 2021 13:09:08 -0800 (PST)
MIME-Version: 1.0
References: <20210308150050.19902-1-pc@cjr.nz> <20210308150050.19902-3-pc@cjr.nz>
In-Reply-To: <20210308150050.19902-3-pc@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 8 Mar 2021 15:08:58 -0600
Message-ID: <CAH2r5mt1hF3AjgT0mhjH9wgaoFby9TvnKZ_u+=bLj8LvxKS9hw@mail.gmail.com>
Subject: Re: [PATCH 3/4] cifs: return proper error code in statfs(2)
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

cc:stable?

On Mon, Mar 8, 2021 at 9:01 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> In cifs_statfs(), if server->ops->queryfs is not NULL, then we should
> use its return value rather than always returning 0.  Instead, use rc
> variable as it is properly set to 0 in case there is no
> server->ops->queryfs.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/cifsfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index d43e935d2df4..099ad9f3660b 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -290,7 +290,7 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
>                 rc = server->ops->queryfs(xid, tcon, cifs_sb, buf);
>
>         free_xid(xid);
> -       return 0;
> +       return rc;
>  }
>
>  static long cifs_fallocate(struct file *file, int mode, loff_t off, loff_t len)
> --
> 2.30.1
>


-- 
Thanks,

Steve
