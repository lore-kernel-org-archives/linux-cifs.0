Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 545C2C0015E
	for <linux-cifs@archiver.kernel.org>; Sat, 29 Jul 2023 11:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjG2LSk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 29 Jul 2023 07:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjG2LSj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 29 Jul 2023 07:18:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1109E6E
        for <linux-cifs@vger.kernel.org>; Sat, 29 Jul 2023 04:18:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A69460B92
        for <linux-cifs@vger.kernel.org>; Sat, 29 Jul 2023 11:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DD6C433C8
        for <linux-cifs@vger.kernel.org>; Sat, 29 Jul 2023 11:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690629518;
        bh=iQELfK1xtJZDN047rALFGsN0odwgdU0OtPV2TWpTpnc=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=GlgEPmz+lbSd18gTGXBQuRGU/WFydNuY1JrlQk9wKI0lg/CwC3NlgrvWK9BWQKq7h
         UYXFx2zlcV5dU5eSbOMewDTTVAGtzqrtKwp3arbSkIQo8UirabMXqFuFNX+jaCw8zw
         /MUG1odddqM0cIXzdNAY9TolzxZa/jW+hkuN0tjrLQfO6CeGs0NFSBLoHuDf/o5Zb4
         Fx0QgAC0W5p/iwqfxB9WJguJY97Yb/w6bri4Q/KQm/3CREPKV5smDYjLIDRVbTBH+G
         3RGvbNrPQIY8Lt/Rx4DI6Xei9bY9noOnqURmtMyp26S2fF36v/rgREsoxmxjq5feeh
         26yqFKvtTQBNw==
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3a6f87b2993so973569b6e.3
        for <linux-cifs@vger.kernel.org>; Sat, 29 Jul 2023 04:18:37 -0700 (PDT)
X-Gm-Message-State: ABy/qLYKIji1MVjERolaLtSMULQTCbB0QHXNwv/lRValiQG6vfLDlCoY
        59mo0HafV9zsxfHvnK5tHOoEajIUFWkkBv1+Ncc=
X-Google-Smtp-Source: APBJJlE/v8VgzJQqkULhWALKtgZ3prZfTB4Rsy7jbTyAFA6OO/SM1ztREHexPwvqkPPiUAdtm0DVpruq4NiMwEgX2qI=
X-Received: by 2002:a05:6808:8f3:b0:3a1:b67c:5555 with SMTP id
 d19-20020a05680808f300b003a1b67c5555mr4596956oic.58.1690629517168; Sat, 29
 Jul 2023 04:18:37 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:7253:0:b0:4e8:f6ff:2aab with HTTP; Sat, 29 Jul 2023
 04:18:36 -0700 (PDT)
In-Reply-To: <20230729033618.3330897-1-leo.lilong@huawei.com>
References: <20230729033618.3330897-1-leo.lilong@huawei.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 29 Jul 2023 20:18:36 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_CVKJCv5RiEhDC4OCM_DurMC8YiBbKXeB6day078titw@mail.gmail.com>
Message-ID: <CAKYAXd_CVKJCv5RiEhDC4OCM_DurMC8YiBbKXeB6day078titw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: validate command request size
To:     Long Li <leo.lilong@huawei.com>
Cc:     sfrench@samba.org, linux-cifs@vger.kernel.org, yi.zhang@huawei.com,
        houtao1@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-07-29 12:36 GMT+09:00, Long Li <leo.lilong@huawei.com>:
> In commit 2b9b8f3b68ed ("ksmbd: validate command payload size"), except
> for SMB2_OPLOCK_BREAK_HE command, the request size of other commands
> is not checked, it's not expected. Fix it by add check for request
> size of other commands.
>
> Fixes: 2b9b8f3b68ed ("ksmbd: validate command payload size")
> Signed-off-by: Long Li <leo.lilong@huawei.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Applied it to #ksmbd-for-next-next.

Thanks.
