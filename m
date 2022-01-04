Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F327C433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Jan 2022 22:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbiADWjw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 Jan 2022 17:39:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235613AbiADWjw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 Jan 2022 17:39:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A77EC061761
        for <linux-cifs@vger.kernel.org>; Tue,  4 Jan 2022 14:39:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A66236132C
        for <linux-cifs@vger.kernel.org>; Tue,  4 Jan 2022 22:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164EAC36AE0
        for <linux-cifs@vger.kernel.org>; Tue,  4 Jan 2022 22:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641335991;
        bh=tK+4AduB9L/6pgxr/LJHH9kL6eRuA/H5yoO7KWcUmI4=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=NKkzogNVDnTQm7DAjrwTgVBE46OzROgbMxT6pfsAuh4EQDku/D5J5RnVOxy9Kg+jZ
         OQzRdO6C9BVoH2i75sZQAMPjLRSaun5qEkB6HckUF/TTV2DyZhnqUPNgzct/u/Dqkz
         lvvcS/AarP3L0GQqlcGggrXaMGghwUHoKQ2wy4B8DBoT5a9SV43kIo+HMhDcoqnduN
         wBKjL/vPYDKQMz1hbMca3lNPsZEVaTytR5GjGMI/zOYRn6bZOvXbQSGQuHH6uCt8qh
         0AjCjuS0y4SgrXuwcPEOZVRfM9ULrlBt8DXQ0wCmZe9s894D0Hzk+okG0EK1PcI5sS
         ACTuhHdHD25IQ==
Received: by mail-yb1-f173.google.com with SMTP id e202so69608320ybf.4
        for <linux-cifs@vger.kernel.org>; Tue, 04 Jan 2022 14:39:51 -0800 (PST)
X-Gm-Message-State: AOAM530RJGEygFuicdi6GhI490lM42P9iaReEuKW2/P2+TDrrS2D0HVU
        QCvJS6ypZmbIWGvZkR7+7YmJKpBNOKvEubJoYds=
X-Google-Smtp-Source: ABdhPJxGk6xgsTE09SVdaBK7z8+a84LMMJvd+vtyXnQQ4va3mGyvl+E5NlZsGh9JcbBXn7HkQQmAo//xaZsZehQ5HM8=
X-Received: by 2002:a25:d6d5:: with SMTP id n204mr15739925ybg.722.1641335990264;
 Tue, 04 Jan 2022 14:39:50 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:4357:b0:11e:f0cd:2c0e with HTTP; Tue, 4 Jan 2022
 14:39:49 -0800 (PST)
In-Reply-To: <20220104055626.295912-1-hyc.lee@gmail.com>
References: <20220104055626.295912-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 5 Jan 2022 07:39:49 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_9_hSMTg_MLA0vztVuy4+oEcyyvAcbim0gNYj6qRj8Pg@mail.gmail.com>
Message-ID: <CAKYAXd_9_hSMTg_MLA0vztVuy4+oEcyyvAcbim0gNYj6qRj8Pg@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: smbd: call rdma_accept() under CM handler
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-01-04 14:56 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> if CONFIG_LOCKDEP is enabled, the following
> kernel warning message is generated because
> rdma_accept() checks whehter the handler_mutex
> is held by lockdep_assert_held. CM(Connection
> Manager) holds the mutex before CM handler
> callback is called.
>
> [   63.211405 ] WARNING: CPU: 1 PID: 345 at
> drivers/infiniband/core/cma.c:4405 rdma_accept+0x17a/0x350
> [   63.212080 ] RIP: 0010:rdma_accept+0x17a/0x350
> ...
> [   63.214036 ] Call Trace:
> [   63.214098 ]  <TASK>
> [   63.214185 ]  smb_direct_accept_client+0xb4/0x170 [ksmbd]
> [   63.214412 ]  smb_direct_prepare+0x322/0x8c0 [ksmbd]
> [   63.214555 ]  ? rcu_read_lock_sched_held+0x3a/0x70
> [   63.214700 ]  ksmbd_conn_handler_loop+0x63/0x270 [ksmbd]
> [   63.214826 ]  ? ksmbd_conn_alive+0x80/0x80 [ksmbd]
> [   63.214952 ]  kthread+0x171/0x1a0
> [   63.215039 ]  ? set_kthread_struct+0x40/0x40
> [   63.215128 ]  ret_from_fork+0x22/0x30
>
> To avoid this, move creating a queue pair and accepting
> a client from transport_ops->prepare() to
> smb_direct_handle_connect_request().
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
