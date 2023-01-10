Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51AABC54EBC
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Jan 2023 22:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbjAJWcW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Jan 2023 17:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbjAJWcM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Jan 2023 17:32:12 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135F841D42
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 14:32:11 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id bx6so14163869ljb.3
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 14:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UltbthPde+XC9YBF1RmD5Mpc630znOoxgwSnYUs1HPw=;
        b=ZdTgPbNJ0WpPeh2qSg+kbUx/VnpGGtUezWsxj62mzj4V0wqxWhWkHkyumhY4IO6Jdj
         Uok/O0P97zqV+TueDgPnil0/cOL4G9ZTclD0HHHunnxUl+8L5wLSsNv3e3V7i3e1WuR3
         4SbrCp+AeshVwndkFul//ZwVofJ/YDCNtIpdsGsi4puA8f8OzrH9w90NAGsmJNufqyVJ
         xwmu0fo6rBXBLCO01kv5+InBd+DxJBQ8+X7faHdI8yjC/WYNPuAlb74AuNFI+IUgRbsv
         HwDVvoW9gbNv9fui+OZ6rPQ655Jvc3MqGQrvFkLR698F97T6s6jMJcO1wYyc156YbhDb
         77sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UltbthPde+XC9YBF1RmD5Mpc630znOoxgwSnYUs1HPw=;
        b=ht4bB0S2+x2/Plky14N+aiyGR78mQ56a8gI315c1MaSAfhqAep/0gDqhXB17/BRcQK
         6acWAX/ZzWvEIWgDOp1T06l4tXG1vvY7Fl7+o65nWbq+ThFU6OdZFNFqyvd/9kHVoYU1
         CkCTZ4Aa/5ZtvEIOrIJrMsc6ugNawj8/nhXsY7NaSKjAmE0SzoCWI2inCKw20LfpdNEG
         W+Ce5me3iRX6VpFaUWvNDhIUhqPUAB9DDw3mcmu39Zl51hnTc8yozPoFyIpv31vj7BEK
         iR/YTPNE7mC9KhcjNnxxyGme9r9EHiiRiKnYhhj8K3lq9dlrvs6Sg3xFtQxjgX4+X4mS
         yp2Q==
X-Gm-Message-State: AFqh2kqOrA9F2c7zVAOWBIWwq5HhmqkIBDWmy1p+RHJV0aSfWwF8wmzP
        7adfh0l3IhxcHe5mGIf+4FBcH5ZdcvGEU2f0UMc=
X-Google-Smtp-Source: AMrXdXtwIwPvHhkyHaKTHMUyp9IJy7YPv9/TusU0AiHm6jEY6RaG3gewlwjJoaitT448HKpmXNrZ6bJdY6uvoM+T8wo=
X-Received: by 2002:a05:651c:204f:b0:27f:dfc2:5037 with SMTP id
 t15-20020a05651c204f00b0027fdfc25037mr1750887ljo.229.1673389929214; Tue, 10
 Jan 2023 14:32:09 -0800 (PST)
MIME-Version: 1.0
References: <20230109164146.1910-1-pc@cjr.nz> <20230110222321.30860-1-pc@cjr.nz>
In-Reply-To: <20230110222321.30860-1-pc@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 10 Jan 2023 16:31:57 -0600
Message-ID: <CAH2r5muStxyZQX+jqLLGkkJ-KEuq-PSk=E1bBme8Vafoz0+jfA@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: do not query ifaces on smb1 mounts
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Tom Talpey <tom@talpey.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending testing and
additional reviews

On Tue, Jan 10, 2023 at 4:23 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Users have reported the following error on every 600 seconds
> (SMB_INTERFACE_POLL_INTERVAL) when mounting SMB1 shares:
>
>         CIFS: VFS: \\srv\share error -5 on ioctl to get interface list
>
> It's supported only by SMB2+, so do not query network interfaces on
> SMB1 mounts.
>
> Fixes: 6e1c1c08cdf3 ("cifs: periodically query network interfaces from server")
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
> v1 -> v2:
>         remove cifs_tcon::iface_query_poll and then check version and
>         server's capability multichannel
>
>  fs/cifs/connect.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index d371259d6808..b2a04b4e89a5 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2606,11 +2606,14 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
>         INIT_LIST_HEAD(&tcon->pending_opens);
>         tcon->status = TID_GOOD;
>
> -       /* schedule query interfaces poll */
>         INIT_DELAYED_WORK(&tcon->query_interfaces,
>                           smb2_query_server_interfaces);
> -       queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
> -                          (SMB_INTERFACE_POLL_INTERVAL * HZ));
> +       if (ses->server->dialect >= SMB30_PROT_ID &&
> +           (ses->server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
> +               /* schedule query interfaces poll */
> +               queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
> +                                  (SMB_INTERFACE_POLL_INTERVAL * HZ));
> +       }
>
>         spin_lock(&cifs_tcp_ses_lock);
>         list_add(&tcon->tcon_list, &ses->tcon_list);
> --
> 2.39.0
>


-- 
Thanks,

Steve
