Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 796A7C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 27 May 2022 22:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354860AbiE0Wo1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 May 2022 18:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbiE0Wo0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 27 May 2022 18:44:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E6469B72
        for <linux-cifs@vger.kernel.org>; Fri, 27 May 2022 15:44:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25920B82644
        for <linux-cifs@vger.kernel.org>; Fri, 27 May 2022 22:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF067C34114
        for <linux-cifs@vger.kernel.org>; Fri, 27 May 2022 22:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653691462;
        bh=ZdFCLKWNH5t/0twJHv+SJyRnG5LuH6BD4cSSVq9as58=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=kgBdzaylmKVRouAWRJjjSQ8ZpPyVkqD/kvBNLKO4liMavxLsx6JjsZh+ZDn3Y+yjl
         jIsT/7h45XOTTDBxwqsmYY6gLu9qQ5Iwaou9YxlF6LWx/RZ1hPXCXuydG7qWq2+wcT
         tgOeR7flbD1cyiFs9st0DnLzQonKPTKFN9e7FCVN7MhqwI3DcrzJFrmQ1IAZ+0eULN
         LAMgONbtSqlY3Jc32UmzWJw3hZEaIs1JPosOBAA3TVIAOBVZa1MVOX0PITcmZCfg2p
         4VKx5T6kSy24LXkuAU0g8XjhnnBy0XxQcTUIBK5KigGTW0xzHjVts8+SkLEhoQBlez
         TIteSm/6ZqN5g==
Received: by mail-wm1-f48.google.com with SMTP id m32-20020a05600c3b2000b0039756bb41f2so3470732wms.3
        for <linux-cifs@vger.kernel.org>; Fri, 27 May 2022 15:44:22 -0700 (PDT)
X-Gm-Message-State: AOAM531cd0r/9oh3kpn+r4ls6ShlyHOPrtwLWSQWyUzhnbnhU4PsjiV2
        6Y4WQY8Ak7v5q7axRNbtnZkfvKdF9Me4GO9Ug/E=
X-Google-Smtp-Source: ABdhPJz5P/Ks3KrT29foxg4fP2TRzxeb1W/RqFbqFibwc7mCK8eVZG78G1gksIm9msPulQbSymAUtJeno978GBDTW6o=
X-Received: by 2002:a7b:c141:0:b0:397:7ab3:dadd with SMTP id
 z1-20020a7bc141000000b003977ab3daddmr8836975wmi.170.1653691461194; Fri, 27
 May 2022 15:44:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:ee4e:0:0:0:0:0 with HTTP; Fri, 27 May 2022 15:44:20
 -0700 (PDT)
In-Reply-To: <20220526235054.29434-1-hyc.lee@gmail.com>
References: <20220526235054.29434-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 28 May 2022 07:44:20 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8VVQrB1N-cnE+OjQtbzOYQAPSUrbrg13uNjq=k1Zxgtw@mail.gmail.com>
Message-ID: <CAKYAXd8VVQrB1N-cnE+OjQtbzOYQAPSUrbrg13uNjq=k1Zxgtw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: smbd: relax the count of sges required
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-05-27 8:50 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> Remove the condition that the count of sges
> must be greater than or equal to
> SMB_DIRECT_MAX_SEND_SGES(8).
> Because ksmbd needs sges only for SMB direct
> header, SMB2 transform header, SMB2 response,
> and optional payload.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
