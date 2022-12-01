Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDDFC4321E
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Dec 2022 01:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiLABFV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 30 Nov 2022 20:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiLABFR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 30 Nov 2022 20:05:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9D391C32
        for <linux-cifs@vger.kernel.org>; Wed, 30 Nov 2022 17:05:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12578B81AD6
        for <linux-cifs@vger.kernel.org>; Thu,  1 Dec 2022 01:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE124C433D6
        for <linux-cifs@vger.kernel.org>; Thu,  1 Dec 2022 01:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669856712;
        bh=c3gAqYBt0uSv8rTcnAen9rfkx+71OoVmB/4jfu7LB80=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=gAYDkUm63kbnV0SDU7659sJo0xR2pCtagKs2DLVUlXuHc4MZh7V+xgEbzUAJZKECE
         vThI6m9jcH3vjLeZkpBvMucbQDkL1CBAD/5oDJWz4Vdu6du9/pYev2Jn5p4kc224nU
         XgLDgVeBQETJJKLLEAkc5EnFMRTVF8/GiX4ecJRoG9cpSQ8f1icdinFwwkL0Z1Snxr
         M+208BCMgeuUl/WAtmDyLRal7AwhdQnyi5YSK0uaw+U7BhBzLrHqkFB1QBU++Q2BV4
         YqSVoqCPevvbUPESlZ65or+NfBJhPbIRCNa6fxaelnuv9ygRDOckcqATic4CAjjWMo
         NVTHsIYCeDOTw==
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-143ffc8c2b2so532774fac.2
        for <linux-cifs@vger.kernel.org>; Wed, 30 Nov 2022 17:05:12 -0800 (PST)
X-Gm-Message-State: ANoB5pnc2Q5wvtglixFU3abD6hlxQVvBIfJMUkD9ZtaJIV9Xf4HCMjBR
        v2EoUn7Y7R1mQm78IMhnwk4XX2pGpGKHnaansIU=
X-Google-Smtp-Source: AA0mqf7IRphi+3bdzJ5DtK3dPkaZda4jb8wo2+EPIn3UayHcMC8XLd1zzy9CZZdGIJsFbzfiuefdYnJb9jml3SwBvHQ=
X-Received: by 2002:a05:6870:430a:b0:13d:5167:43e3 with SMTP id
 w10-20020a056870430a00b0013d516743e3mr26759545oah.257.1669856711796; Wed, 30
 Nov 2022 17:05:11 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6839:1a4e:0:0:0:0 with HTTP; Wed, 30 Nov 2022 17:05:11
 -0800 (PST)
In-Reply-To: <20221129111933.2251777-1-mmakassikis@freebox.fr>
References: <20221129111933.2251777-1-mmakassikis@freebox.fr>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 1 Dec 2022 10:05:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-V-vDt4ZCS+HD1imhWj=x5emVSWOrUxRCQ18TSWcGkoA@mail.gmail.com>
Message-ID: <CAKYAXd-V-vDt4ZCS+HD1imhWj=x5emVSWOrUxRCQ18TSWcGkoA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Fix resource leak in smb2_lock()
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-11-29 20:19 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> "flock" is leaked if an error happens before smb2_lock_init(), as the
> lock is not added to the lock_list to be cleaned up.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks for your patch!
