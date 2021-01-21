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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C3F2C433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Jan 2021 03:52:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 047E92071C
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Jan 2021 03:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbhAUDwD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Jan 2021 22:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730601AbhAUAy1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Jan 2021 19:54:27 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE71C061575
        for <linux-cifs@vger.kernel.org>; Wed, 20 Jan 2021 16:52:13 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id m13so564668ljo.11
        for <linux-cifs@vger.kernel.org>; Wed, 20 Jan 2021 16:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SQLpMWb32I+pgu6K7NeJ8tP7Bp8SDoZc25yztIWiDzc=;
        b=bldRs2d7aQ+g9KQ9pw3rs+FS8NLq1fpz4KTDiFvf6iIcO7nTbdvGVRp2Jp0mol8x4z
         EH7SqYwRvlAAiGNX6DcQkVRoOsbV0N+mEB7R3g7cvAKmq5C+4BsGJN3wo2B74V5+53LG
         EMCjKRa/sKmeJbePAS2FEiek6LQa80kgLe5wqUKjeT5dgXE3wFQTlPnvfO6+s1r1URkq
         qmlqMJEL8mgDOJ6/dh7ckXi9TcRiTPdXhHysZAYsPkxHBgZ7VqMthTaUleb3/x2E/M+p
         G5fxmtMXe+9anPDxANwFPtRB9vkXRLGIRdNzU2LFS8mUjUZqkTf+rZB5pFF5Tt0P54at
         YDkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SQLpMWb32I+pgu6K7NeJ8tP7Bp8SDoZc25yztIWiDzc=;
        b=OIPW+ZI/yUmBExmW7LoGNNPThgj50ZWhst1OTkimWw3NwcnQXwNSrqSqFN6ieUIXQ6
         w7eT7Ak88tdF6rFN5ZbAV+UhZeEa26KMe6wGYe+SysUkLXXuIQpT7VGN3aV8PxoJKETQ
         7cbE0r/DV4K3R4cUPxhg102hy3pjDWIxOzRe+lUAtm+u5GgYmRstySiGTvZ1JAlm1TyN
         P0Wx1wtQZrjudpem/gzjxIMP6YZwr3PhqwC9hFy7x6HYxp4jcGmKxiSt6bp39x8LN4hz
         J50NjPyIKWdKQIh7q2ESOLloEpnCxbqUqJL3HhbzQc/hKYChwkLKk8Eyu74wDZNnzWM9
         Vu0w==
X-Gm-Message-State: AOAM532HMHcpa7VcW/50jR0iN62Qahk2kqoDUzLPcVRKPo/1UGTlKpzl
        pLKCSpte1Mon2NupmDELaAhGXAsFtGsqk/0V+v5XFKTIzpE=
X-Google-Smtp-Source: ABdhPJxBJiJd5KL7onDzngSkIPmJ/fu47W/zvbko2ZjnyjBIrc6UVCABUHHOem6F7bKNS8vXkcFNJC9g9Nux9/gUYLQ=
X-Received: by 2002:a2e:88c8:: with SMTP id a8mr5507132ljk.148.1611190331503;
 Wed, 20 Jan 2021 16:52:11 -0800 (PST)
MIME-Version: 1.0
References: <20210120222248.22994-1-lsahlber@redhat.com>
In-Reply-To: <20210120222248.22994-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 20 Jan 2021 18:52:00 -0600
Message-ID: <CAH2r5muKWC8f=_HTPn+NcRq8iGAYDgAzyQ-3yJx66NVZYi54GA@mail.gmail.com>
Subject: Re: [PATCH] cifs: do not fail __smb_send_rqst if non-fatal signals
 are pending
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next

On Wed, Jan 20, 2021 at 4:22 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> RHBZ 1848178
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index d629d3c03a9e..283e9022f049 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -339,7 +339,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
>         if (ssocket == NULL)
>                 return -EAGAIN;
>
> -       if (signal_pending(current)) {
> +       if (fatal_signal_pending(current)) {
>                 cifs_dbg(FYI, "signal pending before send request\n");
>                 return -ERESTARTSYS;
>         }
> --
> 2.13.6
>


-- 
Thanks,

Steve
