Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68834C433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Mar 2022 06:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242342AbiCSGiW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 19 Mar 2022 02:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbiCSGiK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 19 Mar 2022 02:38:10 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F26B2E6D6C
        for <linux-cifs@vger.kernel.org>; Fri, 18 Mar 2022 23:36:47 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id m67so19408861ybm.4
        for <linux-cifs@vger.kernel.org>; Fri, 18 Mar 2022 23:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vcyeVr0bLyPWDRxzCOsf9WH8TwVYCUCHRkM8P9lL1gQ=;
        b=KOfzur/PrwyhQKWw2+Vr1wMI1Q5mZ8eNUGKGDbxuTCoOFYGzu1ZYhqXku9DF0kVW/d
         Px8kFZJb4ednq7hbjDwwFenKPzCtavUd2GAz+OWd0tiUtUR6rUMBxeNk1a3+epfm3Tj5
         S5W94kEUazJYeerCOZsjJ7BIG9oxyT7cv7zZoO9YU6YPMsniDEHCdfLdsxf+9/fiO/Xu
         hmWQtAa/BGdxNDVJy753fE7tb/NT2qxHQuZl9ftthEdsDHvO/1LiRB8eeK/9BrHDeQSK
         2bX7KquMDhyhbSkzYdmHiza42kszGhfZP9gcz9Ish34d+4KdhJnokmwP7YkMstaGeamu
         rhNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vcyeVr0bLyPWDRxzCOsf9WH8TwVYCUCHRkM8P9lL1gQ=;
        b=3VmSENHjyqQbeLHXgfX1FhmXGt6JNc3d5JMfwkwn1CE9SuxuDuFk+Ecf675geN6F4s
         hwFNlssEQZdRbhX60OGa4dq/NiFM/MzzSFrNBK61K5TpMO0XgLD6k8cLqEs1A1XWUqVk
         FfwPcG8qHls0Znqvm61ZtxYHdMw7ZysM2Xqy4XgLTon38EiHO2N1bHk6voBy5hTmxdil
         1jWIYKsq/uLad8YSGsHGmpP3XQNPicRKC20nO5xl57Phj8WQIxl67R2AXBsThQlZXidd
         L/rtRFKhTevCaIVIlIFzxFKQ028i0LEKH/hVz1MU+XHEDo5p9nXyBP2xXZUt2XLFHQhz
         bHvg==
X-Gm-Message-State: AOAM531KuJOKs9QLb60ITAuocZSGHbeLRSX64g43Z87VLxSwgk0w7B3V
        EjaF2iHRCbyEthGU9iWiPoclCGj39ByYpjNPIJ1FxK64
X-Google-Smtp-Source: ABdhPJyJSwBVJ7xKB4JRtkj/m1c2luOw/9mP63XInxrSatADCe7eYH6Un9Gu9IYUcxIDXEl9beZ86U24X4fORJivDk4=
X-Received: by 2002:a25:c08f:0:b0:633:910d:498b with SMTP id
 c137-20020a25c08f000000b00633910d498bmr13102664ybf.531.1647671805759; Fri, 18
 Mar 2022 23:36:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muJaVBkWeW847yn8Dz=VoTXg=FEKyBHy0KJannzSbHmzw@mail.gmail.com>
In-Reply-To: <CAH2r5muJaVBkWeW847yn8Dz=VoTXg=FEKyBHy0KJannzSbHmzw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Sat, 19 Mar 2022 16:36:34 +1000
Message-ID: <CAN05THTUnyAf4R8tzBe1sGra-p+=tmoDPGpnBCy-t=v7a-=Z4Q@mail.gmail.com>
Subject: Re: does "cifs: we do not need a spinlock around the tree access
 during umount" need to go to stable as well
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I would say maybe.
Because it is just suppressing some warnings during umount for "sleep
during spinlock".
As far as I can tell, in this particular situation, the warnings
should be harmless
as we won't be entering this same function concurrently from any other
thread during umount.

The warning that is printed is valid, we should not potentially sleep
while holding a spinlock
because that can cause a different thread to spin for very long trying
to grab that same spinlock.
But in this case I don't think it can happen.

So the patch is I think mostly cosmetic. Prevent a warning message
from being printed to dmesg which in 99% of the
cases are something that can cause real issues and in very few special
cases, like this,  is still a bug but benign.

But lets push it to stable.   Even if benign in this particular case,
stable-users do not deserve to see these messages
in the log.


On Sat, Mar 19, 2022 at 2:10 PM Steve French <smfrench@gmail.com> wrote:
>
> Since "cifs: we do not need a spinlock around the tree access during
> umount" fixes "cifs: fix handlecache and multiuser" (commit
> 47178c7722ac528ea08aa82c3ef9ffa178962d7a) which was marked for stable.
> I marked "cifs: we do not need a spinlock around the tree access
> during umount" for stable as well.
>
> Let me know if you want me to change that.
>
>
> --
> Thanks,
>
> Steve
