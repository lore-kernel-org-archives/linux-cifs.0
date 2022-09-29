Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE4AC04A95
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 02:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbiI2CsW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbiI2CsW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 22:48:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68ED4DF3AF
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 19:48:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0353C6181D
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 02:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665B7C433C1
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 02:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664419699;
        bh=x2M+Lo1mfIGjpxUi7+yVAwR8f3axlrXqyKXJYWUYcqQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=eIo1CNuTVaegQzh8LTSGoQwn2H3GXrFRFOtjG0si71TuOSQbSGb0nxZ0NxPkkof/F
         7p6CskQqzHZR/MccszI88WCm85uthzQbbSAukhaoCTufG+QGD05YsMO2fYR5Xl3rrm
         FDFE55voo0EY1I/EP1C8u2Kp7Eu5+ogQ2Ob9cTamXRM0VSfJNZzf9qvFTPYH5attpl
         sDbMhE4lXX62S/XqebaKrtwt7H1fCw/WxjvPW636GYr5lAGv9qDjNRyb9ll8jCjMAF
         I/A14rpqgbSXEO7OD05u/PaEVuI6QeFmk/HK5NezK7LfC2gaH+pBOH30E5Ss9iREyD
         Y/nBFKx9tpKwA==
Received: by mail-ot1-f43.google.com with SMTP id br15-20020a056830390f00b0061c9d73b8bdso150644otb.6
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 19:48:19 -0700 (PDT)
X-Gm-Message-State: ACrzQf36qzVgJZR9nCr7KAtwtGUOhD+LR/g5mjNpLSWjVwGacj0v5f0d
        C3BsyMn6lgDj0C4/Qo1LV8xSLvPnABUpeeXp/tI=
X-Google-Smtp-Source: AMsMyM7WZbteyG2GyUR+ijmxiAAS5+FHiV/xHYrQ01pQ6EXIgYsOZz0XjhvNlAqkxJGlN7FpeFV6zgkDJwvKSMOxi4U=
X-Received: by 2002:a9d:5603:0:b0:639:683b:82c7 with SMTP id
 e3-20020a9d5603000000b00639683b82c7mr410551oti.187.1664419698560; Wed, 28 Sep
 2022 19:48:18 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Wed, 28 Sep 2022 19:48:18
 -0700 (PDT)
In-Reply-To: <YzT+FFwTmcvjppVc@google.com>
References: <20220927215151.6931-1-linkinjeon@kernel.org> <60322098-648f-2610-bcf2-1cec581d4f86@talpey.com>
 <YzT+FFwTmcvjppVc@google.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 29 Sep 2022 11:48:18 +0900
X-Gmail-Original-Message-ID: <CAKYAXd91OCHYXxO++S0yHrrh6-_W7OzE6Av5R-Uru73dc-AE3Q@mail.gmail.com>
Message-ID: <CAKYAXd91OCHYXxO++S0yHrrh6-_W7OzE6Av5R-Uru73dc-AE3Q@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: hide socket error message when ipv6 config is disable
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com, atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-29 11:08 GMT+09:00, Sergey Senozhatsky <senozhatsky@chromium.org>:
> On (22/09/28 11:25), Tom Talpey wrote:
>> > diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
>> > index 143bba4e4db8..9b35afcdcf0d 100644
>> > --- a/fs/ksmbd/transport_tcp.c
>> > +++ b/fs/ksmbd/transport_tcp.c
>> > @@ -399,7 +399,8 @@ static int create_socket(struct interface *iface)
>> >   	ret = sock_create(PF_INET6, SOCK_STREAM, IPPROTO_TCP,
>> > &ksmbd_socket);
>> >   	if (ret) {
>> > -		pr_err("Can't create socket for ipv6, try ipv4: %d\n", ret);
>> > +		if (ret != -EAFNOSUPPORT)
>> > +			pr_err("Can't create socket for ipv6, try ipv4: %d\n", ret);
>>
>> Why not just eliminate the splat? The only real error seems to be
>> that IPv6 is not configured, which is undoubtedly intentional, and
>> in any case there's nothing to do about it. Suggesting to "try ipv4"
>> is kind of pointless, isn't it?
>
> Yeah, that pr_err() sounds like a suggestion, but in fact it's not.
> It meant to say "ipv6 socket creation failed, fallback to ipv4".
I agree that it's better to change it to "fallback to ipv4" instead of
"try ipv4".
>
