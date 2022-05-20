Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25403C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 20 May 2022 00:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242963AbiETAV0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 May 2022 20:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343966AbiETAVX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 19 May 2022 20:21:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1571C41FBC
        for <linux-cifs@vger.kernel.org>; Thu, 19 May 2022 17:21:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C62861AA0
        for <linux-cifs@vger.kernel.org>; Fri, 20 May 2022 00:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B113DC385AA
        for <linux-cifs@vger.kernel.org>; Fri, 20 May 2022 00:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653006077;
        bh=mhYy+pvHOFhusX/971hZXSwm4cCC27gnEAMlGzteXL4=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=UmNWIC1sPxjs2npq7NGK4RGYZ35S3lA5a6/EGBPg3+2vlyVnnq/EuBX/F7armi5ku
         A9O5NYUjd49fr/sgA+nULAbEMZbe4IjVZCtn77uaQlYRisg9TIRr4wmUSYrWO8XwUq
         rTvq004l/N5X5MMeVAjcdD6Z7ET+kYpnGumlZbAtyhyGNBvC7mG9mXabjLFVlSGl7d
         uSLpc3uZiWXnOrzaTr1/HBbEX7FeNBBXln9eLXnZziUf/+kZyiD8pA+V2GjvYZuh4N
         uxPLjJdj1EXWcGXBYckhaQxzugHGkIn6TvCBwtnsy1sntxTClNVXoJ+xWilaEjKguz
         AZLn8QGhWNbrg==
Received: by mail-wr1-f53.google.com with SMTP id w4so9352457wrg.12
        for <linux-cifs@vger.kernel.org>; Thu, 19 May 2022 17:21:17 -0700 (PDT)
X-Gm-Message-State: AOAM531f6vXIWmWulRuLZUfWA6qqXicIvjENOSO9JMdli5iB/pr2btPc
        7CM8y+cqIJ/XCHin7umzndn/jlJQwSIxisiDGX8=
X-Google-Smtp-Source: ABdhPJws2SjUNh3yZieOjfjxb8vWpGT1nmvqqhcNQ0k3SlC6/vIUiRWDatuR1jBj5k1IS/PS03eurz4LRoKKa6L2UYA=
X-Received: by 2002:a5d:584a:0:b0:20c:45fe:b02e with SMTP id
 i10-20020a5d584a000000b0020c45feb02emr6056662wrf.504.1653006075989; Thu, 19
 May 2022 17:21:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:f344:0:0:0:0:0 with HTTP; Thu, 19 May 2022 17:21:15
 -0700 (PDT)
In-Reply-To: <20220517214608.283538-2-hyc.lee@gmail.com>
References: <20220517214608.283538-1-hyc.lee@gmail.com> <20220517214608.283538-2-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 20 May 2022 09:21:15 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8Wc+epkZc7OwTNPxSD13N9c4VApAGszyE=v7C=F-ep9Q@mail.gmail.com>
Message-ID: <CAKYAXd8Wc+epkZc7OwTNPxSD13N9c4VApAGszyE=v7C=F-ep9Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: smbd: fix connection dropped issue
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Yufan Chen <wiz.chen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-05-18 6:46 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> When there are bursty connection requests,
> RDMA connection event handler is deferred and
> Negotiation requests are received even if
> connection status is NEW.
>
> To handle it, set the status to CONNECTED
> if Negotiation requests are received.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> Reported-by: Yufan Chen <wiz.chen@gmail.com>
> Tested-by: Yufan Chen <wiz.chen@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
