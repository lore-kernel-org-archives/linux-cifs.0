Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D336AC38145
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Sep 2022 14:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbiIHO2c (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Sep 2022 10:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbiIHO23 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Sep 2022 10:28:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB35CFB8D7
        for <linux-cifs@vger.kernel.org>; Thu,  8 Sep 2022 07:28:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55E1761D1A
        for <linux-cifs@vger.kernel.org>; Thu,  8 Sep 2022 14:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B066CC433D6
        for <linux-cifs@vger.kernel.org>; Thu,  8 Sep 2022 14:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662647307;
        bh=wQDN1SGhKazbfqVPGZfDIsGsC+BpGELKjMMTIsIPG4Q=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=CY+5oWFWstCrh7k4v5aQC/0dUoaGlIJy0/zClwt+mKDkO9qHzbVAEWx3AH6DHgNCP
         jhdwXcSVNpEqd1HzmeZr92YvAL8wP3MOApp9WGQ90VrIY2zwL/WvQokEJjYivuKYyu
         iyuRZTn2LWr9pBH/UNfLkAhOonR10xNvQOnZERwA7or+5GvqsV14E3ttOUxVkvRETs
         hN2dxdJiqbUzvW08H9Raq8NJt92i7ADNjYjJZ2eadARUbD/X10hgpfvXuwxADD3tmI
         Z5PxlXsRhDcTSy5b1v8U+fgRTyi8CGmq60k1PaV1oUsi8zHD8MpprjIE524Ry8jDHA
         0x7v97pxMjbLQ==
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-1278a61bd57so26256957fac.7
        for <linux-cifs@vger.kernel.org>; Thu, 08 Sep 2022 07:28:27 -0700 (PDT)
X-Gm-Message-State: ACgBeo1VkS732nisyhR6QgZ9GMHDFMoHkCmyeOS0EL0EdD2QxnkARx+d
        +hz5Dw/9ZIi/TH3c1vvj+6/yKScpgyTL2U5BNo4=
X-Google-Smtp-Source: AA6agR4gZsircumt+zO3Rvu6jJJ5JppsazCewO1ntp0WOZf9bfl9ZYPdNxQaMhO/e5gV+9SO/zlo+CxAD240sRZtn+E=
X-Received: by 2002:aca:1106:0:b0:34b:89c9:f5f8 with SMTP id
 6-20020aca1106000000b0034b89c9f5f8mr1678005oir.8.1662647306876; Thu, 08 Sep
 2022 07:28:26 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Thu, 8 Sep 2022 07:28:26
 -0700 (PDT)
In-Reply-To: <24137999-6349-f058-2f9e-b523f2d0a2e9@talpey.com>
References: <20220906015823.12390-1-linkinjeon@kernel.org> <356b6557-fa62-b611-8ef2-df9ca10a28c7@talpey.com>
 <CAKYAXd8bo2DS8HFpd=Gq3VFQ_P8rvBfSNAK08h6aSgKZ21cH1g@mail.gmail.com> <24137999-6349-f058-2f9e-b523f2d0a2e9@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 8 Sep 2022 23:28:26 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8h=Dxw0+vN3nOMeapHu8zUnLQ5dZ5wUTO2QgjpPQO44w@mail.gmail.com>
Message-ID: <CAKYAXd8h=Dxw0+vN3nOMeapHu8zUnLQ5dZ5wUTO2QgjpPQO44w@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: update documentation
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, hyc.lee@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-08 21:50 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/6/2022 7:46 PM, Namjae Jeon wrote:
>> 2022-09-07 2:09 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>> On 9/5/2022 9:58 PM, Namjae Jeon wrote:
>>>> +3. Create /usr/local/etc/ksmbd/ksmbd.conf file, add SMB share in
>>>> smb.conf
>>>> file.
>>>
>>> Typo - "ksmbd.conf" -------------------------------------------------^
>> Will fix it.
>>>
>>> Wouldn't the ksmbd.addshare command be a safer way to do this?
>> ksmbd.addshare can't update global section now. So I thought it seems
>> appropriate to edit ksmbd.conf directly in the initial running. If you
>> still need to add, please let me know.
>
> I'm confused. If ksmbd.addshare can't add a share, what can it do?
It can only add/delete/update the share section.

>
> Tom.
>
