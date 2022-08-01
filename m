Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99539C00144
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Aug 2022 15:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbiHAPmz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Aug 2022 11:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiHAPmy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Aug 2022 11:42:54 -0400
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751133C8D4
        for <linux-cifs@vger.kernel.org>; Mon,  1 Aug 2022 08:42:53 -0700 (PDT)
Received: by mail-ua1-x930.google.com with SMTP id h19so3715535ual.8
        for <linux-cifs@vger.kernel.org>; Mon, 01 Aug 2022 08:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DbwbQ3Kmgt8hxohj47vkqe4TAfGsCghh9qO+EnC7QQo=;
        b=olNUKERbPFdeEy9XcRvtZvbi7g4Yns381k1w2Q/1rJ0qBM2FPXM+QpuyTGikdsnS5r
         3wl6DjilVY5vi8jqntnAeDuR3/+o52wEs7pGO8jLIt5JndqNYAH8CpvpbJxmKn1KcA2n
         tO5CZIP32BEMyqpfEMj8ByKjGWlCtp7ziCUFslBDzBptkFtb/fwKJoMjp3pdWgA94zh0
         m73IbQU0uTeTrdclesB+Wv136sOSsjCKx0ySOuyXH7D31nsojicBP0hFpSRaBOc6TuJL
         effPHkeD52S3la+Th9hZfnrNoOK3+cwHKrAMa9Gut1KLzeeLdzyz6qYV1li66v8wVedv
         WdjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DbwbQ3Kmgt8hxohj47vkqe4TAfGsCghh9qO+EnC7QQo=;
        b=OcEYjMPKqKCA2f/YfBkobfOzsyDbzy7n9d+4OZRIGhPq7/v8MM2DzXSvxY+iCzirq7
         SN00a9obZk6H6BKu82fIxhCfPlomNPlRMQExLyg4fFLMBouKNgeUrT5HEKludPDXeWsE
         XzlmqjzCNevz+vB6VjeBN3qxSo2XOFNNVweQQd9hNJY3Ow1lV+LKSBIqCizOfBFCLYGA
         0jqeGrUBOdW5aoJjmEdMTMfpXktanH0E5kE6QcnCZv6NOigd+bqsA/gxPYQi/Usrcsyh
         KqT437JMKZhscYlvJvR+MSGoi/M+YJd9RlzlF2vn+f57ap8U2UQtqaNg45x1WrOsRqw/
         bPxA==
X-Gm-Message-State: ACgBeo3m8TQ3VHavYpSco6Hlapt/VKIhsbkSrVM+iImioV0FOU/l8ZWx
        3lsji8HxnxOXWUpxNFDOzzjaKwUsnjFOaXnY+ci/0kbOV10=
X-Google-Smtp-Source: AA6agR4PmFW2hALAfqjde1scRHFVyrPLVcv3jk5Nbzraw43Hf1Q5LXGIgzIeD/vHGTEG6FL+TfEOLGrIgXsPJCgd7tM=
X-Received: by 2002:a05:6130:10b:b0:37f:a52:99fd with SMTP id
 h11-20020a056130010b00b0037f0a5299fdmr6077268uag.96.1659368571084; Mon, 01
 Aug 2022 08:42:51 -0700 (PDT)
MIME-Version: 1.0
References: <YufPFRNZtOSbuVY+@kili>
In-Reply-To: <YufPFRNZtOSbuVY+@kili>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 1 Aug 2022 10:42:40 -0500
Message-ID: <CAH2r5mt40SFX3DQo4WLKtK9sjToFd_L1pn3gwoLO032aYi5t1g@mail.gmail.com>
Subject: Re: [bug report] cifs: avoid use of global locks for high contention data
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Shyam Prasad N <sprasad@microsoft.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

this was already fixed by:

commit aea02fc40a7fa6ac2c16e3c3a6f1d0fd7e6faaba
Author: Yang Yingliang <yangyingliang@huawei.com>
Date:   Fri Jul 29 15:49:35 2022 +0800

    cifs: fix wrong unlock before return from cifs_tree_connect()

On Mon, Aug 1, 2022 at 8:14 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> Hello Shyam Prasad N,
>
> The patch fe67bd563ec2: "cifs: avoid use of global locks for high
> contention data" from Jul 27, 2022, leads to the following Smatch
> static checker warning:
>
> fs/cifs/connect.c:4641 cifs_tree_connect()
> warn: inconsistent returns '&tcon->tc_lock'.
>   Locked on  : 4587
>   Unlocked on: 4641
>
> fs/cifs/connect.c
>   4570  int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const struct nls_table *nlsc)
>   4571  {
>   4572          int rc;
>   4573          struct TCP_Server_Info *server = tcon->ses->server;
>   4574          const struct smb_version_operations *ops = server->ops;
>   4575          struct super_block *sb = NULL;
>   4576          struct cifs_sb_info *cifs_sb;
>   4577          struct dfs_cache_tgt_list tl = DFS_CACHE_TGT_LIST_INIT(tl);
>   4578          char *tree;
>   4579          struct dfs_info3_param ref = {0};
>   4580
>   4581          /* only send once per connect */
>   4582          spin_lock(&tcon->tc_lock);
>                            ^^^^^^^^^^^^^
>
>   4583          if (tcon->ses->ses_status != SES_GOOD ||
>   4584              (tcon->status != TID_NEW &&
>   4585              tcon->status != TID_NEED_TCON)) {
>   4586                  spin_unlock(&tcon->ses->ses_lock);
>                                      ^^^^^^^^^^^^^^^^^^^
> Originally this used to take a lock and then unlock it again but now it
> unlocks a different lock.
>
>   4587                  return 0;
>   4588          }
>   4589          tcon->status = TID_IN_TCON;
>   4590          spin_unlock(&tcon->tc_lock);
>   4591
>
> regards,
> dan carpenter



-- 
Thanks,

Steve
