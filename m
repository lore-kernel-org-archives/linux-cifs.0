Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07DB3C433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Jan 2021 17:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDA6723B31
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Jan 2021 17:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbhANRLC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Jan 2021 12:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbhANRLB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Jan 2021 12:11:01 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61278C061574
        for <linux-cifs@vger.kernel.org>; Thu, 14 Jan 2021 09:10:21 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id g24so6476550edw.9
        for <linux-cifs@vger.kernel.org>; Thu, 14 Jan 2021 09:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=R03Q6f+F7ZyjvvZuBDIMKXAMOubig/aHfjcAooIoFgc=;
        b=fAJYnz8zAMwlPEullZTrwoWF5y292NX/Ixg2/O8L5t2m/l/zMVr72kE3Rpp7Oy8fbq
         8TWAld5lc9pC3+WMxRivoV1ZIZdCnD6M4sfs8uqa5P0HXBrBznOX2o+aRFT+YC9MhBAJ
         5qaj7e9mOSQDQRTkorbqHxxTiKvsUrO8XaqulOlMbIm0ory1U1ZHT2xRmTHDsZo3jtHL
         krKPf7WnhkOz4Q5kNXO/u/Lz+8fQpYMe0mqcZvNGzoxkcxsfDcs725Q14J8HeRQM+Mko
         xQ7nEWFIY4aMO6r/R/UDta/r1v8O0o1myw6Xw2BE5lKItlWAt0lZvo4AdMUlsnofWgR8
         d9Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=R03Q6f+F7ZyjvvZuBDIMKXAMOubig/aHfjcAooIoFgc=;
        b=SZZpcoSwOqq8Y4FMPCeFvx/nmxIgoRgUs1z5lBcXgUaz4lwqkbkTpnbDro/XAE0USw
         Z1w9I4DZWdj0TgG7/K1GV9QtNixIHmoYaUditrO7u+bz6kvXd2BbbvCUgjwXquBjFvTe
         ejxHy6y3fGCJe6q5buUP38dP940OfSNgq79G8RQwvHt2BPjk7ZgdfhBB7i0AagmvvGky
         xymeU5fR5fNOpQVNoclh/OZkfgoYiPPPNQrlnskFj3zfz/Jl9JN57pT6nhGPDtBVcJVd
         x4S4R1AV6QFyBnP3ehjxu30R8XSCfpL1zgi0dCRV5v8IklNoFCmGdhtHJ/f8LN3drDx0
         8X8A==
X-Gm-Message-State: AOAM531HpJwXxpIfmQRzP38AwdSjhgNj1Yggo5w0BMdMY6paVB4hD7cJ
        BCbE69+ORc5KPOaAMd/D84drAfJsMZmw9Dvhfg==
X-Google-Smtp-Source: ABdhPJz6W81EzGnm5fFGOyu6MO6Wn9xckSoonQLdo4xn4yCJHsEaj5B8f9rXO7tZEV3ilChzWvIGApntGTQvt7T58KM=
X-Received: by 2002:a05:6402:310f:: with SMTP id dc15mr6419087edb.225.1610644220145;
 Thu, 14 Jan 2021 09:10:20 -0800 (PST)
MIME-Version: 1.0
References: <CAE-Mgq2kwwZJicbU9oenD4M5SQhbErhXovGX+LKtcnRbLC4xSg@mail.gmail.com>
 <87ft35kojo.fsf@suse.com> <CAKywueQ9jmyTaKqR2x0nL-Q8A=-V1fP_1L2n=b+OdUzVhV083Q@mail.gmail.com>
 <87h7nk6art.fsf@cjr.nz> <CAH2r5msvYs4nLbje4vP+XNF_7SR=b5QehQ=t1WT4o=Ki6imPxg@mail.gmail.com>
 <CAKywueT0U3+t3RdC452ZiqVpg1n1KFi_HK=83yGmS__2gALpJg@mail.gmail.com> <87a6tblf25.fsf@suse.com>
In-Reply-To: <87a6tblf25.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 14 Jan 2021 09:10:09 -0800
Message-ID: <CAKywueRAwZOvG3PJaQdPXi2=aLeNWx9zfaUvoN-aR67XOPD-WA@mail.gmail.com>
Subject: Re: [bug report] Inconsistent state with CIFS mount after interrupted
 process in Linux 5.10
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        Duncan Findlay <duncf@duncf.ca>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Great, thanks for adding the test!
--
Best regards,
Pavel Shilovsky

=D1=87=D1=82, 14 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 07:21, Aur=C3=A9li=
en Aptel <aaptel@suse.com>:
>
> Thanks Paulo and Pavel for the quick fix and review.
>
> I've added an xfstest test for it on the buildbot. It's essentially
> doing this:
>
>     set -e
>     rm -f x
>     sleep 5 > x &
>     pid=3D$!
>     sleep 1
>     kill $pid
>     wait $pid &> /dev/null || true
>     timeout 2 stat x > /dev/null
>     timeout 2 rm  x
>
> this fails without the fix
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>
