Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D13C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Mar 2022 00:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiCCANe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Mar 2022 19:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiCCANd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Mar 2022 19:13:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D53F10DA71
        for <linux-cifs@vger.kernel.org>; Wed,  2 Mar 2022 16:12:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9E3160AFF
        for <linux-cifs@vger.kernel.org>; Thu,  3 Mar 2022 00:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B98C36AE2
        for <linux-cifs@vger.kernel.org>; Thu,  3 Mar 2022 00:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646266368;
        bh=izGjdtJli9gVltytSFcm5XQSA+pCpUq7DtAm7a85Hdg=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Npl0C6UJPiMS0VUsw1lqCyfVF3T1Vax3B+RIXUP61qK6e/z5DT+Jqj5sI4+HtCart
         JCUedamPpRhK3DWXcfQ6fA2wZXGX+o7IyKOT1hb9OTzt6I++Hftb7n5EjXdqtpJo77
         E2+YMmcfG28Wg4igJe9vOsZfDz3f49l2HFCrxkisJC3jPTxdrlno5obk2b43LtlDKe
         Ycf0wRTSl9bjZ/oistIA+1SNS8KHYCjcel9xKaf1hIGm2CiAW1PNVjwzr4+M540k+6
         FZOXWyEOcVPxxbTX9rqnN4GAPVp43pT/1N2aiTrsOISsMA0aLJa5ePcbYe8hdmKU4S
         JASSEq3vbYIHA==
Received: by mail-wr1-f41.google.com with SMTP id b5so5270008wrr.2
        for <linux-cifs@vger.kernel.org>; Wed, 02 Mar 2022 16:12:48 -0800 (PST)
X-Gm-Message-State: AOAM531cbNh2jNBF0fZOaTtYZWfgjUPvSlcVAKv1g85L7d7O/YzO3Z3H
        LcnPFYjtmdrx9Q3M6S6IR0ar7kNCq5MSISVS4XE=
X-Google-Smtp-Source: ABdhPJxA9NK5SehBTpJdlIbtSkcT2hrrhFvO6xv285NiU7NoKrR68EjEXSmmVMBfW13eZtWipPRs/N1Od574RK8OuKs=
X-Received: by 2002:a05:6000:1c16:b0:1ef:d315:8c58 with SMTP id
 ba22-20020a0560001c1600b001efd3158c58mr12019195wrb.504.1646266366498; Wed, 02
 Mar 2022 16:12:46 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a5d:4e02:0:0:0:0:0 with HTTP; Wed, 2 Mar 2022 16:12:45 -0800 (PST)
In-Reply-To: <20220302151109.19892-1-tklauser@distanz.ch>
References: <20220302151109.19892-1-tklauser@distanz.ch>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 3 Mar 2022 09:12:45 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8XaYJGZJa=hmCO2NQrneEOQS2OtOQv2Geg1Cgpw003Uw@mail.gmail.com>
Message-ID: <CAKYAXd8XaYJGZJa=hmCO2NQrneEOQS2OtOQv2Geg1Cgpw003Uw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: use netif_is_bridge_port
To:     Tobias Klauser <tklauser@distanz.ch>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-03-03 0:11 GMT+09:00, Tobias Klauser <tklauser@distanz.ch>:
> Use netif_is_bridge_port defined in <linux/netdevice.h> instead of
> open-coding it.
>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
