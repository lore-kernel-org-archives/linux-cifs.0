Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE459C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 19 May 2022 08:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiESIA0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 May 2022 04:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbiESIAW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 19 May 2022 04:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4733B03C
        for <linux-cifs@vger.kernel.org>; Thu, 19 May 2022 01:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D93FB8237D
        for <linux-cifs@vger.kernel.org>; Thu, 19 May 2022 08:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182A2C34115
        for <linux-cifs@vger.kernel.org>; Thu, 19 May 2022 08:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652947215;
        bh=lgSFN2cSk4J3qUdlAG4gGYO8fLkhO33lc6NVicVyMOU=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=rP0DIFLsROJDNMU9Slm645tjyMQ2uLX16kppWcOcSn3lYJ0Atj09qS3Pe4qrZFPdR
         pX9flLr74bx7x3mtoW/X/lxyOoqZg2OeCIm8tDUEn7yDxLMvlq7lj23mYHrQeVTAJL
         HLoT6YqsN3ybxbkAT55uVyrlcvbMQaGGZcbAy0wyHX101R8uIePUIEIKjG+sFmuL4J
         jdrIaS5Is1C9ifZ0++O6+wIK7xvE78oMI0aNL4PwN9sOBYpoBm6uvnxSQ/o9ckD+pq
         zuzrl8AjpH3PJapUvTSC8owhZD1YS+XUh1+P3FV0BuwsgMZXLn9GvUKPvG9VEcbJvl
         EQ/RSsfrn1Bug==
Received: by mail-wm1-f41.google.com with SMTP id n6-20020a05600c3b8600b0039492b44ce7so2259612wms.5
        for <linux-cifs@vger.kernel.org>; Thu, 19 May 2022 01:00:14 -0700 (PDT)
X-Gm-Message-State: AOAM533/omH0hThKAXxJzr2nqnlxPT01niA+TguCjau3cJn3BlP1Mfkx
        mzjyvdunLS/95XW5OMpsjHOMNkUpDI9ShXT1TEs=
X-Google-Smtp-Source: ABdhPJyRWPTsanAVwV1+Q9U8AXyXCZDp7lVeUMktyJkEzg6TK7fKTIDl3+pjjEBoxDwFAY4odzgIYinxzTAaetR6fSI=
X-Received: by 2002:a05:600c:3512:b0:394:7c3b:53c0 with SMTP id
 h18-20020a05600c351200b003947c3b53c0mr2580599wmq.170.1652947213332; Thu, 19
 May 2022 01:00:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:f344:0:0:0:0:0 with HTTP; Thu, 19 May 2022 01:00:12
 -0700 (PDT)
In-Reply-To: <20220517214608.283538-1-hyc.lee@gmail.com>
References: <20220517214608.283538-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 19 May 2022 17:00:12 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-Lfx7jmWOxyjHkwUwsr8Kg2fMN5d58UXkRk+oEx07R5w@mail.gmail.com>
Message-ID: <CAKYAXd-Lfx7jmWOxyjHkwUwsr8Kg2fMN5d58UXkRk+oEx07R5w@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: fix outstanding credits related bugs
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
> outstanding credits must be initialized to 0,
> because it means the sum of credits consumed by
> in-flight requests.
> And outstanding credits must be compared with
> total credits in smb2_validate_credit_charge(),
> because total credits are the sum of credits
> granted by ksmbd.
>
> This patch fix the following error,
> while frametest with Windows clients:
>
> Limits exceeding the maximum allowable outstanding requests,
> given : 128, pending : 8065
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> Reported-by: Yufan Chen <wiz.chen@gmail.com>
> Tested-by: Yufan Chen <wiz.chen@gmail.com>
Please add Fixes and stable tags.

Thanks.
