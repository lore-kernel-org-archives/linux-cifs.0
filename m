Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9577DC433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Apr 2022 04:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240437AbiD3EOz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 30 Apr 2022 00:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239650AbiD3EOy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 30 Apr 2022 00:14:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C222E6AC
        for <linux-cifs@vger.kernel.org>; Fri, 29 Apr 2022 21:11:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1484BB838AF
        for <linux-cifs@vger.kernel.org>; Sat, 30 Apr 2022 04:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEB5C385AF
        for <linux-cifs@vger.kernel.org>; Sat, 30 Apr 2022 04:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651291891;
        bh=BugBkKJ/ZCJK2loc3bAyDQUpGKo2rK8nmyxvKRlHazI=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=s3SSA+JdFFBaw8Z4IH+EokP/qqrTGaZWv+1jtr6Y8HyXOY4KrVC202CftSu3YwjzW
         Dmmy+Li64QsMZ6wAzJRz+Jpvvqo4fQbUxp5qlruzYcNkWgTe6qQefA9AjihJvf5v3T
         9qSAOwPGPZopnDMXBlpO9XNDZNV7UjSTlAoqM+J6uRFLHGTyBYFiHQzjxKTNz9wTv6
         ipFh5+lZqBWC21YUoqbHxdoaqg0nLZa8RDHH+/5tKEC5LWvQij7nZf444Vhf2ZaZXo
         jD3cyEpRZpIqmKfGTc6HagJYPwIS9XC90cxF11LF8UaZd2poSuVBF0G+kI2Cj9OUQA
         wgPyf+GMOO54A==
Received: by mail-wm1-f51.google.com with SMTP id v64-20020a1cac43000000b0038cfd1b3a6dso7995406wme.5
        for <linux-cifs@vger.kernel.org>; Fri, 29 Apr 2022 21:11:31 -0700 (PDT)
X-Gm-Message-State: AOAM5317vuG0RdBiZt+plUpOXhvI8PA09Q2nwgXG7Hmo9gOMNOnKW1MT
        Ha2VkhkX0ff4UQHvdFB6SVC8DtczekVTqj9mYUA=
X-Google-Smtp-Source: ABdhPJzKZlt/W0rcm57NpADskuzTs2t+PzwxeoElmdPVZ4+OfDIeINx32I5/gAuvYdij/iG0e62Lc2EqDxP1EJpxo6Y=
X-Received: by 2002:a05:600c:3494:b0:390:8a95:1b95 with SMTP id
 a20-20020a05600c349400b003908a951b95mr5922735wmq.15.1651291889989; Fri, 29
 Apr 2022 21:11:29 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:64e7:0:0:0:0:0 with HTTP; Fri, 29 Apr 2022 21:11:29
 -0700 (PDT)
In-Reply-To: <20220429233029.42741-5-hyc.lee@gmail.com>
References: <20220429233029.42741-1-hyc.lee@gmail.com> <20220429233029.42741-5-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 30 Apr 2022 13:11:29 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8uS62jrWxGTYXqHmcXAibMWDdxHGfc=+K3UFWgAvXudw@mail.gmail.com>
Message-ID: <CAKYAXd8uS62jrWxGTYXqHmcXAibMWDdxHGfc=+K3UFWgAvXudw@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] ksmbd: smbd: handle multiple Buffer descriptors
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Yufan Chen <wiz.chen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-04-30 8:30 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> Make ksmbd handle multiple buffer descriptors
> when reading and writing files using SMB direct:
> Post the work requests of rdma_rw_ctx for
> RDMA read/write in smb_direct_rdma_xmit(), and
> the work request for the READ/WRITE response
> with a remote invalidation in smb_direct_writev().
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
