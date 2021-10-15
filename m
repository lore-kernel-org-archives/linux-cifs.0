Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A28C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Oct 2021 00:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FDED60EB4
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Oct 2021 00:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbhJOAwI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Oct 2021 20:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232895AbhJOAwG (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 14 Oct 2021 20:52:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C50061139
        for <linux-cifs@vger.kernel.org>; Fri, 15 Oct 2021 00:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634259001;
        bh=5Hzox0UT6YGG2z7DIfx3UpLaW08ESERLmmow0xe0E3s=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=MJfM5pl4lTs7hp7Aj9bf6n8/ZfOlnkJ5PXG94H5JMpignfAlKAYGyAPVt+0ug+qTy
         eGreoOlJXCnEXsK2BfltAXHT+941xy5szlZEfvz9mnjfKYP8yusKyH4QUheGyKbJdp
         aVZowO07BJsPm643yv2aDFX/KITDxKQXBHnb/5wFIrS2LPWE/6RzRvWTAUYmQhMHXl
         DBfPw7boia9XFG4+53ZSeIA3CR8+JP/aoCvr9d+fPfTRZgc0gIte0ijClkaFNqH006
         BhuMEbE+SsF9ALMqp4Qz7BzVqRyjbMohq7FhrBnpq8Wpo4sd4EZ7WSyhZ8qCMl2opm
         TsTwhzjw+mWTg==
Received: by mail-ot1-f42.google.com with SMTP id x33-20020a9d37a4000000b0054733a85462so10605922otb.10
        for <linux-cifs@vger.kernel.org>; Thu, 14 Oct 2021 17:50:01 -0700 (PDT)
X-Gm-Message-State: AOAM5325BI5zgIVQg93BM7ZcNRTiVd/Un8tL6n72L15wSzs6ekEPEQvN
        qBzWn4OueV1s+jIkpCoSHMExQ/QXtIBs/scIlj4=
X-Google-Smtp-Source: ABdhPJwLhbMfgfpvNix8XZjUHn6geOQBDsoJvclo5GgsKj/GYP/3/fQKD2WKh7rQi8cdpRVPEaTos7COdfYRVbj8kss=
X-Received: by 2002:a9d:c47:: with SMTP id 65mr5221725otr.232.1634259000490;
 Thu, 14 Oct 2021 17:50:00 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Thu, 14 Oct 2021 17:49:59
 -0700 (PDT)
In-Reply-To: <20211014210250.119723-1-hyc.lee@gmail.com>
References: <20211014210250.119723-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 15 Oct 2021 09:49:59 +0900
X-Gmail-Original-Message-ID: <CAKYAXd85dcuEXE49bRZmd9dVyeKqgtPF5nNR4qnmnXbePYFi7A@mail.gmail.com>
Message-ID: <CAKYAXd85dcuEXE49bRZmd9dVyeKqgtPF5nNR4qnmnXbePYFi7A@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: add buffer validation for smb direct
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Ralph Boehme <slow@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-15 6:02 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> Add buffer validation for smb direct.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
