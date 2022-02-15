Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CEE2C433FE
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Feb 2022 19:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243741AbiBOTiG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Feb 2022 14:38:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243703AbiBOTiE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Feb 2022 14:38:04 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FFD62F5
        for <linux-cifs@vger.kernel.org>; Tue, 15 Feb 2022 11:37:52 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id b38so12499735ljr.12
        for <linux-cifs@vger.kernel.org>; Tue, 15 Feb 2022 11:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1mYiNdSpt1qVT8rdbSeKyZw5vYF855h10/7bEyfMwhI=;
        b=dGRyXNbhG7UlAKHJGLDNz7fsTn+tAY4NB0MNlMgAuPngLhC6tQwiWc+/nKn7M80unp
         6l2xor68A4JmNx6mmb3MDVhQ2yTX0iMMhPhoraNbEqOZoQg8duPosYb6PBCDJOFFyI0y
         cfhxcfYoXcDpCU/bz3xuxkDI1/jHcO3FJuJflMdowk0hIw3PfpRcMdutVTUCT2zz3/rL
         swrvB5O6AijjdWfeS7q3QdUcbr66WBpD5IyLtpruDNQh4suqYZNB+Kfd+VO7S+NqkuOI
         clf/L6CZlXudEZ0FEAOsP2YngV0ur6rqOWGj9gvIxAA03PHAv4h4t+UOtviZl+ijoILV
         DfEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1mYiNdSpt1qVT8rdbSeKyZw5vYF855h10/7bEyfMwhI=;
        b=fZxTwEl23DnVQvzOEjgElldhnnsnb172Lf263+NWWKHOTMxSjC5rfmnjGdKHpK7pph
         9Ouyn6YhptFt7hH3SVXGsacjJ7eUhYlV0Q0HunOGZbMgyhdLujo2a61FI8lkI5YDZcCU
         JOfXSAUBGIvAs2+RQw3+P06UIfZ6c9LHk2xcyHS4U6Ksi8844H7EBiLcJP0Wv5XqlmEw
         qzXyiUrGQ0Bj5qXYbX+PO/r0niS5QBpUeK0q2PEIGmOujLLP0tbF6E7ELtA5XyAdwzts
         C8aYX8yRUpUwkerbU+JxLRU5VjVY7F4y+l85Pfr2uTv7xMFjbIiV9sezvSZ7sYAlICW+
         osIA==
X-Gm-Message-State: AOAM531wDez6zFdl2eKcjWyaLYtPd8ta5rn+hE3xLRnw0DQkOfjd639h
        f44M4p3u9QmoAAtpHK8JGEViw3k/aRrK9c7PbLo=
X-Google-Smtp-Source: ABdhPJy0i5fPPbgrkdgH++AsZV9NGUYnSW6HV6399/eCMgmiqTMvoTDUhjWeiOKdAIYHG03V7hUAy34dCRgMghQBVC4=
X-Received: by 2002:a2e:9c04:: with SMTP id s4mr378633lji.229.1644953870619;
 Tue, 15 Feb 2022 11:37:50 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=oyS-49nAvmddV=s+VOz+TG0SG7RcTEs6f25g_2hC-rUQ@mail.gmail.com>
 <87leyckkzo.fsf@cjr.nz>
In-Reply-To: <87leyckkzo.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 15 Feb 2022 13:37:39 -0600
Message-ID: <CAH2r5muC7Bg5WQf1UcWd0LaPg+NVxQ5y_nz7p19U_SvVh9qJHQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: use a different reconnect helper for non-cifsd threads
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Updated and tentatively merged into cifs-2.6.git for-next and added acked-by

Shyam,
Let me know if any additional changes you see or feedback.

On Tue, Feb 15, 2022 at 1:06 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Hi Shyam,
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > My patch last week was not sufficient to fix some of the buildbot
> > failures we saw recently.
> > Please review and use the following patch for new buildbot runs.
> >
> > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/2b599dec7c9399b66b56419fcb252ab37de94e3b.patch
>
> Patch looks good, however you missed these:
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 053cb449eb16..2e00cd58a8b5 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -4416,7 +4416,7 @@ static int tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *tco
>          */
>         if (rc && server->current_fullpath != server->origin_fullpath) {
>                 server->current_fullpath = server->origin_fullpath;
> -               cifs_reconnect(tcon->ses->server, true);
> +               cifs_signal_cifsd_for_reconnect(server, true);
>         }
>
>         dfs_cache_free_tgts(tl);
> diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> index ebe236b9d9f5..235aa1b395eb 100644
> --- a/fs/cifs/netmisc.c
> +++ b/fs/cifs/netmisc.c
> @@ -896,7 +896,7 @@ map_and_check_smb_error(struct mid_q_entry *mid, bool logErr)
>                 if (class == ERRSRV && code == ERRbaduid) {
>                         cifs_dbg(FYI, "Server returned 0x%x, reconnecting session...\n",
>                                 code);
> -                       cifs_reconnect(mid->server, false);
> +                       cifs_signal_cifsd_for_reconnect(mid->server, false);
>                 }
>         }
>
> With that, feel free to add:
>
> Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>



-- 
Thanks,

Steve
