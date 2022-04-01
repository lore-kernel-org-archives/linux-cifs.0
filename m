Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6362C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Apr 2022 03:18:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244446AbiDADTu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 31 Mar 2022 23:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbiDADTt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 31 Mar 2022 23:19:49 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3468D25DAB5
        for <linux-cifs@vger.kernel.org>; Thu, 31 Mar 2022 20:18:01 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id bg10so3158730ejb.4
        for <linux-cifs@vger.kernel.org>; Thu, 31 Mar 2022 20:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JwfBAd/z5aTJpW9/PiVybj2iCyKeXNyZnCFwxuqaq9I=;
        b=dS0UPAI+GgA1tvjxdG6IuMOY/r3kyQrQiv002EjVB96tZDehKnhJGQme818bqgavl3
         ZfrLASZHjvVgASxyF5IDHnNH35dGLY6eOYI11gNKN6bcqHF32NscRqrIc0XQqcNm155P
         lI7t3AHPAt4UOfSIa8wPwzsCPWuIVpR11x6s6SQ08BQ6dTsl0nPagf4VRjpTi30jOECM
         1m7DUeGl7Eq4G01TrrTsP971aTizoPuvxbi/kmPirF/wVJ5hDLse81WfLAXrCVszlssB
         AF+/rpr8fu4zQ997Y3SdLtln0OGWVr1GqUhEvKRPkwgv6bkmHXYg1gxgQUgTU9aiPi5e
         rNzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JwfBAd/z5aTJpW9/PiVybj2iCyKeXNyZnCFwxuqaq9I=;
        b=OWQ8NuQYzp+2/HU+An8u4PATkkNYtlaIhQHwMLV07/Dh/VbQ5pfHcsVxZJiDXQlGZ6
         iKuixBRFye+v3TF8C6rGqQL9f69XkiEeN+hyPDbD4o4G2ArxwWZ5ywljPsZ9MHau2lBt
         yX2GG7cL1b+SgsyqHpaRUQazT0IEHj1J3/r3XsoFQWoX0Oly8z3arsvtCDacvmWnG9cf
         q5Y6orVKKTn5hyvT+DGoMm5KGJzYu+JDv3ikmHnp7tWcPBgZ2f6Gx6KPyXsiEtStctYH
         MrJROwMIR8xJ8+QhSh0I/StV2xPJfLtitoLF7ncvEf9vN056EDxdhstRHw+VhUWdrpsq
         1a6g==
X-Gm-Message-State: AOAM532pcOl5fuFenFtwOC8PfqaS/ptxDo2bFIDQh4oL7bKxJOAl/1G/
        o4ch7KtBiywuqU26sIEO6m3Q365GPkN309MVJl8=
X-Google-Smtp-Source: ABdhPJzCH7i1A4oehRGozVy6Cl7+ljjsF4lbExpwMU5Vgy4HuZi0Zua8oJyAG2+Jj2ZeTwvK5U699M+zB1k/X9JgT1c=
X-Received: by 2002:a17:906:d1c4:b0:6d5:83bb:f58a with SMTP id
 bs4-20020a170906d1c400b006d583bbf58amr7549617ejb.672.1648783079523; Thu, 31
 Mar 2022 20:17:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220331180151.5301-1-pc@cjr.nz> <20220331180151.5301-2-pc@cjr.nz>
In-Reply-To: <20220331180151.5301-2-pc@cjr.nz>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 1 Apr 2022 08:47:48 +0530
Message-ID: <CANT5p=rPMsZvacpRsYUQSg9mM_TjnGtNJtUCurVsdv_JV9cVdg@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: force new session setup and tcon for dfs
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Apr 1, 2022 at 12:42 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Do not reuse existing sessions and tcons in DFS failover as it might
> connect to different servers and shares.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/connect.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 3ca06bd88b6e..3956672a11ae 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -536,8 +536,11 @@ int cifs_reconnect(struct TCP_Server_Info *server, bool mark_smb_session)
>                 return __cifs_reconnect(server, mark_smb_session);
>         }
>         spin_unlock(&cifs_tcp_ses_lock);
> -
> -       return reconnect_dfs_server(server, mark_smb_session);
> +       /*
> +        * Ignore @mark_smb_session and invalidate all sessions & tcons as we might be connecting to
> +        * a different server or share during failover.
> +        */
> +       return reconnect_dfs_server(server, true);
>  }
>  #else
>  int cifs_reconnect(struct TCP_Server_Info *server, bool mark_smb_session)
> --
> 2.35.1
>
This makes sense.
Wondering if you could check if the reconnect happens to a new
server/share and then change mark_smb_session? Maybe that complicates
the logic.

Looks good to me.
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>

-- 
Regards,
Shyam
