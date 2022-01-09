Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D23C8C433EF
	for <linux-cifs@archiver.kernel.org>; Sun,  9 Jan 2022 12:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbiAIM4Y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 9 Jan 2022 07:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbiAIM4X (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 9 Jan 2022 07:56:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3812C06173F
        for <linux-cifs@vger.kernel.org>; Sun,  9 Jan 2022 04:56:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FA01B80D35
        for <linux-cifs@vger.kernel.org>; Sun,  9 Jan 2022 12:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAB6C36AED
        for <linux-cifs@vger.kernel.org>; Sun,  9 Jan 2022 12:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641732981;
        bh=5PcopnaKDUPspgJufWbSjI5/JJdXQKA8z3GAfDtGTeU=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=hmyq5STWI6Pda4ynt7xeWi/NAjWcJTXOCKjCqFncvDZA/LSx5zlORgIK3X+fhUjQy
         I/EWaUIWp3AqWeDEQ6tGzHPpHJELkuC2DNSmwSJW6vbZYWhpRjmGnEVvn3WRXdk3T1
         tpym5SRzumD7f03aZ2eQXzExBjtVmDjgluI34U9rYmIFk9a/GwmGipsrzoQ9QQx2DO
         uNeM2VNpohwZxsJwFvZexz7oFQ8moz5PHTVyUqloZkPmq9QJwy+RQ+yJlXQO2SGBd/
         ESLw0ND3g+U8xcnm25JdigGAlIXpaozbFG36r7Ut4oaT6nLEj8Gg/QdVWzpkM+FbO0
         lNDc+bipzoGYw==
Received: by mail-yb1-f173.google.com with SMTP id 127so14757449ybb.4
        for <linux-cifs@vger.kernel.org>; Sun, 09 Jan 2022 04:56:20 -0800 (PST)
X-Gm-Message-State: AOAM533YbSt2RrF/Ol0iaWmJf81i8Su7e8eGJgiRJduI3OlYe1UnSWB3
        vDRZJGMCHP5oxG7neOUEvYHvnE1FprHxbqFHwkM=
X-Google-Smtp-Source: ABdhPJxBBt03GhvNgfm0UbGEeXi8ph5dczUSB4awiqV1NZeGIIMkWiE2s7DpT6FK8q87s4L1QFMplN3rjyNG38GpSiE=
X-Received: by 2002:a25:d6d5:: with SMTP id n204mr43269563ybg.722.1641732980101;
 Sun, 09 Jan 2022 04:56:20 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:5011:b0:123:6c39:8652 with HTTP; Sun, 9 Jan 2022
 04:56:19 -0800 (PST)
In-Reply-To: <CAH2r5mtTs5bxF9+_M0-3a7YkZB4zqBCm4_kL_QpHAPhEVAG-WA@mail.gmail.com>
References: <20220107054531.619487-1-hyc.lee@gmail.com> <20220107054531.619487-2-hyc.lee@gmail.com>
 <CAKYAXd9qYgpf9oGhK5bdE2M6nbfpeTEAOg+zDGGXomOLaNmR9Q@mail.gmail.com> <CAH2r5mtTs5bxF9+_M0-3a7YkZB4zqBCm4_kL_QpHAPhEVAG-WA@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 9 Jan 2022 21:56:19 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9ndasXA3q2F05f9JMXHPT6cQRf0M8owP-dwdv_LWggwQ@mail.gmail.com>
Message-ID: <CAKYAXd9ndasXA3q2F05f9JMXHPT6cQRf0M8owP-dwdv_LWggwQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: smbd: change the default maximum read/write,
 receive size
To:     Steve French <smfrench@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-01-09 15:44 GMT+09:00, Steve French <smfrench@gmail.com>:
> Do you have more detail on what the negotiated readsize/writesize
> would be for Windows clients with this size? for Linux clients?
Hyunchul, Please answer.

>
> It looked like it would still be 4MB at first glance (although in
> theory some Windows could do 8MB) ... I may have missed something
I understood that multiple-buffer descriptor support was required to
set a read/write size of 1MB or more. As I know, Hyunchul is currently
working on it.
It seems to be set to the smaller of max read/write size in smb-direct
negotiate and max read/write size in smb2 negotiate.

Hyunchul, I have one question more, How did you get 1048512 setting value ?
>
> On Sat, Jan 8, 2022 at 8:43 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>>
>> 2022-01-07 14:45 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
>> > Due to restriction that cannot handle multiple
>> > buffer descriptor structures, decrease the maximum
>> > read/write size for Windows clients.
>> >
>> > And set the maximum fragmented receive size
>> > in consideration of the receive queue size.
>> >
>> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
>> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
>
>
>
> --
> Thanks,
>
> Steve
>
