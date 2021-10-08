Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 791F0C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Oct 2021 23:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5803360F5E
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Oct 2021 23:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243810AbhJHXri (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Oct 2021 19:47:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231964AbhJHXri (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 8 Oct 2021 19:47:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2529F60F5E
        for <linux-cifs@vger.kernel.org>; Fri,  8 Oct 2021 23:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633736742;
        bh=zQxQN3FVxxVo6MjNF6iYC0bH7hHUEO6s6HZwUtuzeNA=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=FOnJAj1d4sdPEmY1egOtlmV0GbVJffm+ejyRsUBih1+/kr4fnavaR/mU3h9qo0mG3
         rOWwb3gC+vsCaF57FN6RR35825qrstMjScD7gBQNbrd+v0Kn4E+J07gvMt0or4Rcdk
         q2KGoKDxRVGvDEQ78cJ+lyxEDoXmQvViBCYkO7EbzVK3M+Czypii9romXdV29KlvdP
         6XyuZS9hRyXML8SXOJHcvi2hEkPAQTu5hPw7PwcVxw3yWck3Tr9DnMHyem07VabGoC
         ScGcmF/jpCWvBQ0So2tq1XRoX7uR27IwAX/chDmNO8iIYgb/YMbTSWzieQQwyxgnBd
         8HKHuzwepvTJQ==
Received: by mail-oi1-f170.google.com with SMTP id o83so8321073oif.4
        for <linux-cifs@vger.kernel.org>; Fri, 08 Oct 2021 16:45:42 -0700 (PDT)
X-Gm-Message-State: AOAM532IePyqcM8ZioRO1jQlB5OTRefYhdsxifnhyuUBUOMdBokpkok/
        6HhbQpBU4zFy/ae26j+bw80MeZCrWJ13EJ8SKCM=
X-Google-Smtp-Source: ABdhPJyMVRjX0JJb+7aRkOqbTvG7PuWWD/phvgceDojU4D9u10Iy3u/P8PDpuwxDPZ0xKHXmo103KrL8k1C4DRyS88M=
X-Received: by 2002:a05:6808:64f:: with SMTP id z15mr17716235oih.65.1633736741499;
 Fri, 08 Oct 2021 16:45:41 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Fri, 8 Oct 2021 16:45:40 -0700 (PDT)
In-Reply-To: <20211007072658.352494-1-hyc.lee@gmail.com>
References: <20211007072658.352494-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 9 Oct 2021 08:45:40 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_AG_4wHNbuD8SQQvDQZH-iv5b93E9rrs+3PM+4t3TUSQ@mail.gmail.com>
Message-ID: <CAKYAXd_AG_4wHNbuD8SQQvDQZH-iv5b93E9rrs+3PM+4t3TUSQ@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: improve credits management
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Ralph Boehme <slow@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-07 16:26 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> * Requests except READ, WRITE, IOCTL, INFO, QUERY
> DIRECOTRY, CANCEL must consume one credit.
> * If client's granted credits are insufficient,
> refuse to handle requests.
> * Windows server 2016 or later grant up to 8192
> credits to clients at once.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
