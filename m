Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D44C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Apr 2022 04:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240829AbiD3EOH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 30 Apr 2022 00:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240642AbiD3EN4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 30 Apr 2022 00:13:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D096DEEE
        for <linux-cifs@vger.kernel.org>; Fri, 29 Apr 2022 21:10:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21CB96091E
        for <linux-cifs@vger.kernel.org>; Sat, 30 Apr 2022 04:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83279C385AA
        for <linux-cifs@vger.kernel.org>; Sat, 30 Apr 2022 04:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651291834;
        bh=X5hOMYfJWVeN5X+W1CAjm2QW4tmpB3iOMMzdQ6vYsb8=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=A6XAE3H43GfcQC245JM2BXvFYv76gtdvnN4+tLCemMP2orw16FU0YU6/XFOMLKKME
         rSnGRCQtenDEHp8ecEO9/w8v1hPI75VJB5qFuE3SyZNuGqIt9wDs0J9twHB3TadKa1
         V5cGLJVtpah5TFgDzmpQf5IMYNBq5BGiXmZRC03ETa7mGXweCNPm4Cv1W/epE2NV8g
         Vx1W5LkP1DlyO0ZLBo/roit8joa8tgc2AAu55APubTmncDyioFbjdaaXLbDJlFFwsl
         zC+V/dkaKopzvn3lHAlbqjOrAWWPEnw0jGghPh8gaWv4wVhghAk0ukwFsAVOEgyaNH
         LuF8pEM2SmVQA==
Received: by mail-wm1-f49.google.com with SMTP id k126so2170564wme.2
        for <linux-cifs@vger.kernel.org>; Fri, 29 Apr 2022 21:10:34 -0700 (PDT)
X-Gm-Message-State: AOAM5312eKx7eq4x3gweH9LAZifSsBWy4kwnLgrVmST+iUsb+/XpXOZZ
        JChpWFNPteLVrD9Tbj1tERxKDXZUWawS+pSvwXU=
X-Google-Smtp-Source: ABdhPJzYyBYhaVleOVoQ/vjIeDFp5hjIW+hDzI3bLidF+Qi2GZJC2mX2lAnbSC2ny2A21iIcx59GjbTf/gKJBZtnsbU=
X-Received: by 2002:a05:600c:3503:b0:38f:fbd7:1f0d with SMTP id
 h3-20020a05600c350300b0038ffbd71f0dmr1795811wmq.170.1651291832817; Fri, 29
 Apr 2022 21:10:32 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:64e7:0:0:0:0:0 with HTTP; Fri, 29 Apr 2022 21:10:32
 -0700 (PDT)
In-Reply-To: <20220429233029.42741-2-hyc.lee@gmail.com>
References: <20220429233029.42741-1-hyc.lee@gmail.com> <20220429233029.42741-2-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 30 Apr 2022 13:10:32 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9zoYML8my02cMn1j7b_f2Sd9YvHmLQR7XHiFt+5MLKWQ@mail.gmail.com>
Message-ID: <CAKYAXd9zoYML8my02cMn1j7b_f2Sd9YvHmLQR7XHiFt+5MLKWQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] ksmbd: smbd: introduce read/write credits for RDMA read/write
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
> SMB2_READ/SMB2_WRITE request has to be granted the number
> of rw credits, the pages the request wants to transfer
> / the maximum pages which can be registered with one
> MR to read and write a file.
> And allocate enough RDMA resources for the maximum
> number of rw credits allowed by ksmbd.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
