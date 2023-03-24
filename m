Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0929EC6FD20
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Mar 2023 07:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjCXHAy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Mar 2023 03:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjCXHAx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Mar 2023 03:00:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A909825283
        for <linux-cifs@vger.kernel.org>; Fri, 24 Mar 2023 00:00:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 461FDB822B5
        for <linux-cifs@vger.kernel.org>; Fri, 24 Mar 2023 07:00:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D28C433D2
        for <linux-cifs@vger.kernel.org>; Fri, 24 Mar 2023 07:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679641249;
        bh=crpH+oE2DZJ4KU5OcU+pLZwGJ1J7/14vb2MyzEWzIfY=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=jLA2XxCekKfhBpgOl5BYX5PUoJVROwvw/H25Gbt4wEyqKd0ygvDlhE8JcXuw7kud7
         fOQGLfeWmJ4hxP5nm7nbjhOzYSmEJYLGVp6P5MIL6ny3Tbweh4wu8PSWhc3VygJFDy
         ylk3fkSIyRbRjiDVHtuIUee3mtE0IuzFBC/H4OlCMuWPI7uJT8EzcofONiPXm8Qu9D
         Hf/JsbwcY8cEFehyBHxzERyUL0OB+DfAQtfLiGIraU+0Urvp3j5X7ylGvNxXW1YC/J
         +MvgWSdJtwLCq5t7eWxSyVHOhVvcKzBFsjxERZWojs8qpcYF/m0bT2DpOQZXNUZOP/
         zQtrdedQaNVCA==
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-17ebba88c60so887977fac.3
        for <linux-cifs@vger.kernel.org>; Fri, 24 Mar 2023 00:00:49 -0700 (PDT)
X-Gm-Message-State: AO0yUKWsp1IU4pUfm33BF4M7Fi1+zcxcJ5A9cLSEpuQVK6US3EScxx5z
        8B/GJhKt0kcFhKj1R6vEFX1zWFlcBFApg6/dwPg=
X-Google-Smtp-Source: AK7set/knsaLc1CNPOcoY9JLWxcaql9V33tZGMFErxqP+d5Dxt7EdjFJ7F3z6KT+K8XW13iVEZ8nQueVwNStDumVmt8=
X-Received: by 2002:a05:6871:2798:b0:17e:d09f:9fa9 with SMTP id
 zd24-20020a056871279800b0017ed09f9fa9mr774944oab.1.1679641249044; Fri, 24 Mar
 2023 00:00:49 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:774e:0:b0:4c8:b94d:7a80 with HTTP; Fri, 24 Mar 2023
 00:00:48 -0700 (PDT)
In-Reply-To: <20230324054529.GG3271889@google.com>
References: <20230321133312.103789-1-linkinjeon@kernel.org>
 <20230324035000.GD3271889@google.com> <CAKYAXd_y+xh_2Rp9RLi1xWfrsgYSBvQENMkE0uS=W1Wnp6Espg@mail.gmail.com>
 <20230324054529.GG3271889@google.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 24 Mar 2023 16:00:48 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-DqR-Uw1vCdBGi=pVsT_4B1MGPnP1fFY0hz+ixe47=pQ@mail.gmail.com>
Message-ID: <CAKYAXd-DqR-Uw1vCdBGi=pVsT_4B1MGPnP1fFY0hz+ixe47=pQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: don't terminate inactive sessions after a few seconds
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com,
        atteh.mailbox@gmail.com, Steve French <stfrench@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-03-24 14:45 GMT+09:00, Sergey Senozhatsky <senozhatsky@chromium.org>:
> On (23/03/24 13:28), Namjae Jeon wrote:
>> > By the way, ksmbd_tcp_readv() calls kvec_array_init() on each
>> > iteration.
>> > Shouldn't we call it only if length > 0? That is only if the most
>> > recent
>> > call to kernel_recvmsg() has read some data.
>> If length == to_read is equal then it is not called. And in case
>> length < to_read, we have to call it which reinitialize io vec again
>> for reading the rest of the data.
>
> What I'm saying is: if length == 0 on the previous iteration then
> we don't need to kvec_array_init(). But maybe I'm missing something.
You're right. We can improve it with another patch.

Thanks for your review!
>
