Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F3B3C433DB
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Jan 2021 02:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23A93222B3
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Jan 2021 02:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbhAQCPU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 16 Jan 2021 21:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbhAQCPS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 16 Jan 2021 21:15:18 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83D5C061573;
        Sat, 16 Jan 2021 18:14:37 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id a12so19022784lfl.6;
        Sat, 16 Jan 2021 18:14:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X3duVnfLGgUOXJdxBxM+P5Q3DSUFcQJjQy6qXGSudtk=;
        b=g6X1N+ANfKFA+DYkoEifl/XuChSmfoe0s4puLmjgXZoGy92nuXY6kLiwlg2Z9X5ueo
         KG0z5BEL5XnolRI2iUpJy8vS3RRZ7ZHr/R3hlSVvD8BtSk9jINyK/wOWMZb73u3xSXgA
         osPx7ayib1vWIRlNEJPPgoDP9CVQapZtELgUq1fym7o8wT0j7ssMVyobhUxFbtF4RL//
         saVGpaY6sBzAHhabcCCYYAjz1/MPq/pberiLiU3oiO5OGrbF2bleIN/tGobA4NPBdHf1
         0bmpKG8xCfM0GXBNg3WMY065Ekmej1X5OrN4LFW1YzO1vt+ErtCNrZqIIIc5OIHgM7O9
         c0vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X3duVnfLGgUOXJdxBxM+P5Q3DSUFcQJjQy6qXGSudtk=;
        b=bZqXuCFunKc7kT6NQP06F6DlrXapCR3A74bcX0j+iqMmFH5yxegtbyc3NZLfL/NS09
         pLuaPBhuzHpJRFI8yQSysQJMyLKqcqIAuD5IPU0RoXGdmrD78PebIiJ2U6DmYRyhz1Fe
         NikuaXWUvsURy4FqRXO5qknEjaKK0vV7+hGN6XK2rF2CvDrZitzzhG4gvdq8BM9p0sqk
         8cVZUAWBX+UrHiiGqSUo2MNKkxFrFiwWNQJfsAR2r9a0D0Mi95jg9wXyKvZM706KbM0U
         p2TYjp8ehG/sQ3xaIByXGHeoln8gJkKoS4b61ZUrFkV0S9ccAKqLxDSj9fIUwcTwE5Uk
         Ew8Q==
X-Gm-Message-State: AOAM532DB0qA0fxFP+jwrD7RMdnyxYTyObzJiKAHx48iDkAOFqZxTO+1
        mp62+oTMS354ESYCcqVfvEifjLPrqR9cEj026PP+74t0gtce6A==
X-Google-Smtp-Source: ABdhPJy1yt5kHcmIghDGQ/Lq4hSJHskh6NUw9fR3otEqMGc1tt74+sj/6wfdHt635mzsWtDvaO7E7++3+Xtijlkes/c=
X-Received: by 2002:a19:f11e:: with SMTP id p30mr8233868lfh.395.1610849676276;
 Sat, 16 Jan 2021 18:14:36 -0800 (PST)
MIME-Version: 1.0
References: <1610618543-110743-1-git-send-email-abaci-bugfix@linux.alibaba.com>
In-Reply-To: <1610618543-110743-1-git-send-email-abaci-bugfix@linux.alibaba.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 16 Jan 2021 20:14:25 -0600
Message-ID: <CAH2r5ms2ZfPN+yYJ8MqgJqJ0zkBuOqBrAvYUKjXJwn5Tp6=5fA@mail.gmail.com>
Subject: Re: [PATCH v2] fs/cifs: Simplify bool comparison.
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The patch wouldn't merge (probably fixed with an earlier patch) so I
removed the second part of it (ie the change around line 3740) - see
below and merged the smaller change below into cifs-2.6.git for-next

commit d1639d92fc762bf80273aaf52d87eb780711714c (HEAD -> for-next,
origin/for-next)
Author: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Date:   Thu Jan 14 18:02:23 2021 +0800

    fs/cifs: Simplify bool comparison.

    Fix the follow warnings:

    ./fs/cifs/connect.c: WARNING: Comparison of 0/1 to bool variable

    Reported-by: Abaci Robot <abaci@linux.alibaba.com>
    Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7c3325c0fadc..c8ef24bac94f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2628,7 +2628,7 @@ void reset_cifs_unix_caps(unsigned int xid,
struct cifs_tcon *tcon,
        } else if (ctx)
                tcon->unix_ext = 1; /* Unix Extensions supported */

-       if (tcon->unix_ext == 0) {
+       if (!tcon->unix_ext) {
                cifs_dbg(FYI, "Unix extensions disabled so not set on
reconnect\n");
                return;
        }


On Thu, Jan 14, 2021 at 4:07 AM Jiapeng Zhong
<abaci-bugfix@linux.alibaba.com> wrote:
>
> Fix the follow warnings:
>
> ./fs/cifs/connect.c: WARNING: Comparison of 0/1 to bool variable
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
>
> ---
> Changes in v2:
>   -Modified subject.
>
>  fs/cifs/connect.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index b9df855..b7869a2 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2628,7 +2628,7 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
>         } else if (ctx)
>                 tcon->unix_ext = 1; /* Unix Extensions supported */
>
> -       if (tcon->unix_ext == 0) {
> +       if (!tcon->unix_ext) {
>                 cifs_dbg(FYI, "Unix extensions disabled so not set on reconnect\n");
>                 return;
>         }
> @@ -3740,7 +3740,7 @@ static void delayed_free(struct rcu_head *p)
>
>         if (!ses->binding) {
>                 ses->capabilities = server->capabilities;
> -               if (linuxExtEnabled == 0)
> +               if (!linuxExtEnabled)
>                         ses->capabilities &= (~server->vals->cap_unix);
>
>                 if (ses->auth_key.response) {
> --
> 1.8.3.1
>


-- 
Thanks,

Steve
