Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82564ECAAD5
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Sep 2022 00:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiIIAIo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Sep 2022 20:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIIAIn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Sep 2022 20:08:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3663D10F8FE
        for <linux-cifs@vger.kernel.org>; Thu,  8 Sep 2022 17:08:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC90761E85
        for <linux-cifs@vger.kernel.org>; Fri,  9 Sep 2022 00:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23261C433D6
        for <linux-cifs@vger.kernel.org>; Fri,  9 Sep 2022 00:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662682122;
        bh=negfmjFyP83rHknUQQTK8OxolkQQEzs37WSzDi2WWPQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=N/J3LzCSp4ZHDt1GJGkzfIbTxTLBEe/xxAbLDNUJBRjMApLNMQ4uPZqtsNmfdzJES
         4ctwRxIppx+uvm2ZyTjxijlF8iH4ukjD7iFNKVDbG6VSSIsES3rcxzgMGvNxIdh2OL
         o16ExnnGy5wzeMb3GEqSTZOsv/l07h8Uw5TAkmqc+VaCWLPqHYNgdmjOjZUKI+OQbE
         fdJAouP92AOlWCUx/N7KYvqt7PmPEha7W2YDewDe8HWrl3WPy1v0rlhaIqOinFi6Y5
         0P3YeMMIwQKWSo+zJg5MT5uKG60MOoHq0sHJ5mdMZZN+b9lns1TuyEswM9CYSdtZec
         0D1QJNP2/ZiPg==
Received: by mail-ot1-f47.google.com with SMTP id c39-20020a05683034a700b006540d515722so117774otu.5
        for <linux-cifs@vger.kernel.org>; Thu, 08 Sep 2022 17:08:42 -0700 (PDT)
X-Gm-Message-State: ACgBeo1+rhi99dpcgQIEyU1FxHcg7orAu5AVu8NI+X+ynSH/fdi6z6eD
        RcyU5jBx23F42c18NI0n1lKqs+v2IzXj2+HSYJ8=
X-Google-Smtp-Source: AA6agR5wzaVZ604pNPb/oxRGT2CqbCiRtIfdGnEkVTE6MBOc5LvcnJQkrhNOgULavU9LO21hMKXJqjGG5CAgkT/gHnA=
X-Received: by 2002:a9d:7519:0:b0:636:d935:ee8e with SMTP id
 r25-20020a9d7519000000b00636d935ee8emr4387896otk.339.1662682121252; Thu, 08
 Sep 2022 17:08:41 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Thu, 8 Sep 2022 17:08:40
 -0700 (PDT)
In-Reply-To: <63cd9578-9cb8-60f8-ac56-0ceb497f1277@talpey.com>
References: <20220906015823.12390-1-linkinjeon@kernel.org> <356b6557-fa62-b611-8ef2-df9ca10a28c7@talpey.com>
 <CAKYAXd8bo2DS8HFpd=Gq3VFQ_P8rvBfSNAK08h6aSgKZ21cH1g@mail.gmail.com>
 <24137999-6349-f058-2f9e-b523f2d0a2e9@talpey.com> <CAKYAXd8h=Dxw0+vN3nOMeapHu8zUnLQ5dZ5wUTO2QgjpPQO44w@mail.gmail.com>
 <63cd9578-9cb8-60f8-ac56-0ceb497f1277@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 9 Sep 2022 09:08:40 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9q7KFPrCE4Vcbsn8_TzRAGO7hunP54mJYm4gxRfj5xJA@mail.gmail.com>
Message-ID: <CAKYAXd9q7KFPrCE4Vcbsn8_TzRAGO7hunP54mJYm4gxRfj5xJA@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: update documentation
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, hyc.lee@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-09 5:39 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/8/2022 10:28 AM, Namjae Jeon wrote:
>> 2022-09-08 21:50 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>> On 9/6/2022 7:46 PM, Namjae Jeon wrote:
>>>> 2022-09-07 2:09 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>>>> On 9/5/2022 9:58 PM, Namjae Jeon wrote:
>>>>>> +3. Create /usr/local/etc/ksmbd/ksmbd.conf file, add SMB share in
>>>>>> smb.conf
>>>>>> file.
>>>>>
>>>>> Typo - "ksmbd.conf" -------------------------------------------------^
>>>> Will fix it.
>>>>>
>>>>> Wouldn't the ksmbd.addshare command be a safer way to do this?
>>>> ksmbd.addshare can't update global section now. So I thought it seems
>>>> appropriate to edit ksmbd.conf directly in the initial running. If you
>>>> still need to add, please let me know.
>>>
>>> I'm confused. If ksmbd.addshare can't add a share, what can it do?
>> It can only add/delete/update the share section.
>
> I still don't get it. A share section is just a section that starts
> with [foo] where "foo" is not "global", right? And if ksmbd.addshare
> can add one, why can't it be used in the example?
What I'm trying to say is that users who see this how to run section
are new to ksmbd. And ksmbd.addshare is created to add the share while
ksmbd is running with smb.conf already configured. For initial
setting, smb.conf including global section should be edited, but
guiding the use of ksmbd.addshare that cannot add global seciton may
cause confusion.
>
> Tom.
>
