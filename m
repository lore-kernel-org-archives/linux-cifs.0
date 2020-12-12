Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC5F0C4361B
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 06:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3F2521707
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 06:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405496AbgLLGIS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 12 Dec 2020 01:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404022AbgLLGHz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 12 Dec 2020 01:07:55 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E4CC0613CF
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 22:07:12 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id l11so17015127lfg.0
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 22:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eIhg+l0XA+1Iy1vHXdUnH1WaEZ8EeUeywxQRxzCDmCE=;
        b=H0h+cPnRHJ+U4NVV6ZX3NbuWAGn8rjHQbCknAxwtEo0AAmKEj4E7YfWGC+tp2PTRHL
         YXTcVJv1cdWYv9zuuDgyTBeZ1Ls0BE3+JhPVE0hKz1Qf4LNVJHllBVq+TpH6gIoVpSO0
         KFjD+weNTWHRvqG/XHLm7loDCDInY048pY/G2QFOVpQIeYBQ7hH3aBWJOdzGu0rR96jK
         xYV4AT5DRK/LtWILe/SbkQQWoSrcrHYMUo3631nFAbbtnEHxCDOFiG9OokOqVyY6uXAm
         bn7CXlCs0dtA371ZkDbaWbezDqteCA8q4GjybFCCCtt4jFhusLSAwo0akrYexK15Z17a
         FiJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eIhg+l0XA+1Iy1vHXdUnH1WaEZ8EeUeywxQRxzCDmCE=;
        b=tkUsNCW2XSqXesy7+XfPaXPlc/RDnbYwyh+CyQAxvH0WSfXaQTMsdr2dhB4sasnCoa
         Ls0zAo3VuzpOvCj8EiFR9HSWIrs6eqSD8VWNSIY/z8vytLWn+3vsceDZ2uY6QGJNWDcq
         KHF17w698w9ZvB51ys96JHreDV27kIi+t4sRMHjiXvTSLegP0067XRv64KQXGA6cgQrN
         DTx8/WkZyxOydQ3DNfjFpWJqj20uNpXg+zNY2LVCZDHovhZtUtG1SxVK/v8uOfAi26Y0
         egufLllYasGNzAdM1lH0BHAgT4lTnxGJhilpI7QCYpYcwhWsywSYytdRjI1NBTLEsURz
         IrZA==
X-Gm-Message-State: AOAM531p9BQW6eXYUEvietc5qWj3NQOxOY+SwijSOkMVtozw9LeMorgI
        qvvFCzucSg5im4MgRGNpjQm5KnGgdWnNKwqLO5o=
X-Google-Smtp-Source: ABdhPJxq52qNPt06UxnmTPUoDamU5Gndf8i9o6j/K/xZyMq2+CA+3RHgkyIoXzrPwDyi8qnlnD/dDB0e2cQNeWaiZtY=
X-Received: by 2002:a19:950:: with SMTP id 77mr5491976lfj.133.1607753231353;
 Fri, 11 Dec 2020 22:07:11 -0800 (PST)
MIME-Version: 1.0
References: <20201130180257.31787-1-scabrero@suse.de> <20201130180257.31787-10-scabrero@suse.de>
In-Reply-To: <20201130180257.31787-10-scabrero@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 12 Dec 2020 00:07:00 -0600
Message-ID: <CAH2r5msgsAwUX3d9FhQukJdO4DuqTG6OodgoOU-vi6FaAv=r4g@mail.gmail.com>
Subject: Re: [PATCH v4 09/11] cifs: Simplify reconnect code when dfs upcall is enabled
To:     Samuel Cabrero <scabrero@suse.de>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next, let me know if any
changes need to be made to it.

On Mon, Nov 30, 2020 at 12:05 PM Samuel Cabrero <scabrero@suse.de> wrote:
>
> Some witness notifications, like client move, tell the client to
> reconnect to a specific IP address. In this situation the DFS failover
> code path has to be skipped so clean up as much as possible the
> cifs_reconnect() code.
>
> Signed-off-by: Samuel Cabrero <scabrero@suse.de>
> ---
>  fs/cifs/connect.c | 21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index a298518bebb2..3af88711643b 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -296,7 +296,7 @@ static void cifs_prune_tlinks(struct work_struct *work);
>   * This should be called with server->srv_mutex held.
>   */
>  #ifdef CONFIG_CIFS_DFS_UPCALL
> -static int reconn_set_ipaddr(struct TCP_Server_Info *server)
> +static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
>  {
>         int rc;
>         int len;
> @@ -331,14 +331,7 @@ static int reconn_set_ipaddr(struct TCP_Server_Info *server)
>
>         return !rc ? -1 : 0;
>  }
> -#else
> -static inline int reconn_set_ipaddr(struct TCP_Server_Info *server)
> -{
> -       return 0;
> -}
> -#endif
>
> -#ifdef CONFIG_CIFS_DFS_UPCALL
>  /* These functions must be called with server->srv_mutex held */
>  static void reconn_set_next_dfs_target(struct TCP_Server_Info *server,
>                                        struct cifs_sb_info *cifs_sb,
> @@ -346,6 +339,7 @@ static void reconn_set_next_dfs_target(struct TCP_Server_Info *server,
>                                        struct dfs_cache_tgt_iterator **tgt_it)
>  {
>         const char *name;
> +       int rc;
>
>         if (!cifs_sb || !cifs_sb->origin_fullpath)
>                 return;
> @@ -370,6 +364,12 @@ static void reconn_set_next_dfs_target(struct TCP_Server_Info *server,
>                          "%s: failed to extract hostname from target: %ld\n",
>                          __func__, PTR_ERR(server->hostname));
>         }
> +
> +       rc = reconn_set_ipaddr_from_hostname(server);
> +       if (rc) {
> +               cifs_dbg(FYI, "%s: failed to resolve hostname: %d\n",
> +                        __func__, rc);
> +       }
>  }
>
>  static inline int reconn_setup_dfs_targets(struct cifs_sb_info *cifs_sb,
> @@ -528,11 +528,6 @@ cifs_reconnect(struct TCP_Server_Info *server)
>                  */
>                 reconn_set_next_dfs_target(server, cifs_sb, &tgt_list, &tgt_it);
>  #endif
> -               rc = reconn_set_ipaddr(server);
> -               if (rc) {
> -                       cifs_dbg(FYI, "%s: failed to resolve hostname: %d\n",
> -                                __func__, rc);
> -               }
>
>                 if (cifs_rdma_enabled(server))
>                         rc = smbd_reconnect(server);
> --
> 2.29.2
>


-- 
Thanks,

Steve
