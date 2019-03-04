Return-Path: <SRS0=vRfO=RH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F11DFC43381
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Mar 2019 17:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8BBA206B8
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Mar 2019 17:04:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sKKZMl6M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfCDREZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 4 Mar 2019 12:04:25 -0500
Received: from mail-pf1-f173.google.com ([209.85.210.173]:34850 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfCDREY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 4 Mar 2019 12:04:24 -0500
Received: by mail-pf1-f173.google.com with SMTP id j5so3454141pfa.2
        for <linux-cifs@vger.kernel.org>; Mon, 04 Mar 2019 09:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=7lQW73PtYvLXBpp1U1ifNZYNKAoRMILtKwnNci+o6k0=;
        b=sKKZMl6MC0+KnHLyxjuPvs94YIZ08vlMx6DbYT9g/Fwwi4rLRUv5Xm5pct4znUkklv
         AO0YETmO0UQVZhCDRYu457D+WfnguqVdjG10wV1LCxB3RrfvwirFsvRn/RK5HmBU8wV7
         SU9nhoySDxGYRm4tUpKJP3zyD/9o6TE+ZYfoDCMNGALkojrJbz+tg2rqZx88J7/dKZJc
         Uee4DD81JK7XH4fnJEqk1b04IadnZBT++B1/JCVThSpgF6LRQwe3+hHE5Sd0qa1Lnfni
         3emaVJ42XU+kKaOzbEPShpRJR3mqs7L8eLuJBdAJTJK3x17ls9TIYGcviyZmdTIstTHT
         BMVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=7lQW73PtYvLXBpp1U1ifNZYNKAoRMILtKwnNci+o6k0=;
        b=kw3rwnCS1EhEFZB5ZuTzN+tm3+048hWrdmTPBmianxl3CBssjN6GTPNmzVf7QYWvCp
         Rpp6530F3uORgNm5CZgesVm73J1K0wf5DQaV7GQFMHhzHsYs4ZtjQmtjiwCkCRr2nWsB
         PX9Ku7iB12Qns70L/sXsBywBwRHO3p3zo+RJwSJY9B8BxpK95Q2bsELKdZ+h6COTfHz3
         3S2MbqZfLBlJJ00xobZXk9XrbzAzAHO2XogQT0P8zLSbtMLwLJB2xwO815JG4uF3AvVU
         F0mt7rZZhXa4qgEEi8ixhUWAB3/TjIuxEeQsbA+cZl1yZ8tnRbzYe90Lsxxd1jhu6+i4
         MSUQ==
X-Gm-Message-State: APjAAAWZHf7gHznJKC9+KasjFXkT31Fp5Ir9gUSe9BGdRmh3DNTKTy+f
        gg//xIp71FU/dwJUEoSCcgH/2ixZmkZlraop2BdBBr2h
X-Google-Smtp-Source: APXvYqwFsTrIfmgOaHgj5oJyxE5Xvk0ui+zJ2XSzVjiquNhjjRDPwDO807XFcZINrmRFKa3wf2gx3OHaCBSAWCb2glc=
X-Received: by 2002:a65:42c6:: with SMTP id l6mr19467006pgp.344.1551719063832;
 Mon, 04 Mar 2019 09:04:23 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5muWo48Y=xF1idGqugMpDyoUeWs+ni2RKTfPvGvjypngaA@mail.gmail.com>
In-Reply-To: <CAH2r5muWo48Y=xF1idGqugMpDyoUeWs+ni2RKTfPvGvjypngaA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 4 Mar 2019 11:04:12 -0600
Message-ID: <CAH2r5mv+2Z8urzOJmqssi0yQJ=83p7-vC5AffjMHTi8z-rZMLw@mail.gmail.com>
Subject: Re: xfstest 112 fsx aio
To:     Long Li <longli@microsoft.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Pavel Shilovskiy <pshilov@microsoft.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Retrying the Azure test run without any cifs/smb3 fixes beyond what is
in 5.0 (ie run is on mainline kernel released yesterday).

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/146

On Sun, Mar 3, 2019 at 2:45 PM Steve French <smfrench@gmail.com> wrote:
>
> I do see a failure in xfstest test in last two runs (in the Azure
> bucket (http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/106)
> although it used to work (probably Long Li's patches are related) -
> the cifs testing bucket passed.
>
> Let me know if anyone spots what the problem is.
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
