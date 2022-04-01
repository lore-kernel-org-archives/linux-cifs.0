Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07211C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Apr 2022 03:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244541AbiDADZw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 31 Mar 2022 23:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244529AbiDADZv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 31 Mar 2022 23:25:51 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D363B2CE00
        for <linux-cifs@vger.kernel.org>; Thu, 31 Mar 2022 20:24:00 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z92so1408952ede.13
        for <linux-cifs@vger.kernel.org>; Thu, 31 Mar 2022 20:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rPdFCQI4TPNgYrvq3B6+CLUA66BmI8w7MlzP0g3MO7M=;
        b=SgZ3/gAgfAPVDRCW1QyA1L0t9njKigO3KWOqV7O1EAfeNF/WtAzpqi5VsE8d6F+VYT
         SKg4WFsHtzVFVrBYfq+wC/UDEHX/5ZTf9bzDQabS+IYW31oVPmeTAKC6GQGK0RaFXlpi
         7nHaWog79GBr7f7oSn4hG6r9jfqDb7GSLUyc3fZ+xFKO0o3/py4htE4qPHbzJKO1Xj5B
         BsbEfcJYKzdq4wMODGS2s6IfO5Zz8GFu+VDrB+Mm0aZXa7D97Aoxi9wkhKz4LBETtVx4
         sjQW9ccAJ5h/xsVs3Mrl/7g4jxUlLo3QxU2HpstK/QMRqldnmJKOPPBpVgsRyc3Nlhjv
         lYyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rPdFCQI4TPNgYrvq3B6+CLUA66BmI8w7MlzP0g3MO7M=;
        b=mum72AFP22g8lJemRDJ3JCRLfAUcaR6Rh0DKmfrs7ZGzwyd4JkcbwswcisMPAzqYEn
         MKEpYEixGM30o8EMQutLAQpPiHl4E8Ne/wZRpw39fHQnAyn8sLSxOn3tV1UTHxAgON4m
         obqhWd/NlcbL4XwKtpQDArVISPykpV9Y2xpHf2SDl+OglnWw2UmUyTqf6Ru55xrBTlHx
         p/L8u1F64T600EDCUeEVrGe2v3FgUouEsdSs80NvaS7U4s1DXPLLLx1knbbmzwFdRhHP
         arjcrjcaxe7kWg/j0Ds6wK4S+wwn9aNKGopLFg+2JvjsDLpuo2AVR74iibk7C0Ju/0r3
         ep0g==
X-Gm-Message-State: AOAM530wJQanG0GwTa8wnGxdKRQToQ/y6uVPFnY7fKgEfE/GsdlupCyu
        r5qxY1d4fWlL+zMV1krRAmQEK+utio65vZ4T8xY=
X-Google-Smtp-Source: ABdhPJx2W/18zMb2yGnkCGjUxI+e5j1QA/GbBuGw3HcGjbjy1m4T9SwrNYqzMvbLbTYb34ZBiF86XDgUoVuW/wgRWfE=
X-Received: by 2002:a05:6402:50d0:b0:419:7df9:55c8 with SMTP id
 h16-20020a05640250d000b004197df955c8mr18926207edb.79.1648783439250; Thu, 31
 Mar 2022 20:23:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220331180151.5301-1-pc@cjr.nz>
In-Reply-To: <20220331180151.5301-1-pc@cjr.nz>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 1 Apr 2022 08:53:48 +0530
Message-ID: <CANT5p=qBK9wUaxxbEHmaqQ1J=dNC+5=HuxOzyPyhCr0uLzoYGQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: fix potential race with cifsd thread
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Apr 1, 2022 at 4:38 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> To avoid racing with demultiplex thread while it is handling data on
> socket, use cifs_signal_cifsd_for_reconnect() helper for marking
> current server to reconnect and let the demultiplex thread handle the
> rest.
>
> Fixes: dca65818c80c ("cifs: use a different reconnect helper for non-cifsd threads")
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/connect.c | 2 +-
>  fs/cifs/netmisc.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index ee3b7c15e884..3ca06bd88b6e 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -4465,7 +4465,7 @@ static int tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *tco
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
> --
> 2.35.1
>

Oh. Did I miss these?
Looks good to me.

Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>

-- 
Regards,
Shyam
