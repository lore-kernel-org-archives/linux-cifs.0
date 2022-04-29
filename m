Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D5FC433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Apr 2022 22:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380936AbiD2WVN convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 Apr 2022 18:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357045AbiD2WVN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 29 Apr 2022 18:21:13 -0400
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA044C4025
        for <linux-cifs@vger.kernel.org>; Fri, 29 Apr 2022 15:17:53 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id a21so10555966edb.1
        for <linux-cifs@vger.kernel.org>; Fri, 29 Apr 2022 15:17:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cen6IQfsF0LOBYY8u8Tu7s9Ey2x30gRYOLweJOQ1ceY=;
        b=xUL1XhpIEttEio+L//IxZjNyaooud9ABQqJny968kX+/N9abHHGP8GU8XR3vCyxl2R
         zW9LqCrLQXVCIcbOOx9N5faINY1q88nUSbxKmtL2VI8QosEGwAC+7loTpTVCBJJ3ATJj
         r3rjpX70HuWtFU68w03fwmD8sl61HYMwdLS7DGFHE8Qjumpjk2K8tHm5WbVQeTiNMXQC
         uIgkqTVzVu5in5upVI6QrOTplknxR6b5GkkP2ByichqvoTtFV9KOJhHXKe59PrIr0L7v
         zAHGtj6kDLYkVnTVVHKmhgASl4FzT/HUBcLA8MoU7nKKIp8tdrE7ezw/yR35JOATs8uv
         blHg==
X-Gm-Message-State: AOAM5339Sr9lypCD0tFp/HOgdaJ2+qIFclTwKDDCHy8X8+nMuaFjt7TK
        V31AMoGNkxOYQU66/VsxfEJFuPhBlKkXN2mwnw==
X-Google-Smtp-Source: ABdhPJy42Hoxkai9kIXBguteMps7uwkKPqNZfSkeM/Ga2KevIGCShdmPcYj/gcEQ3rBex1zReNIbljp2aHNfcMgDAgg=
X-Received: by 2002:a05:6402:845:b0:426:4bf:3454 with SMTP id
 b5-20020a056402084500b0042604bf3454mr1467582edz.264.1651270672400; Fri, 29
 Apr 2022 15:17:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220331235251.4753-1-ematsumiya@suse.de> <efb1d822-4fcf-dc3b-2861-8394f50aedbe@talpey.com>
 <20220401152508.edovgwz5pxn6gnhn@cyberdelia> <d5648e12-c5b9-07de-a20b-afd49adc5f56@talpey.com>
 <20220401174145.6x443h555ch7kspd@cyberdelia> <CAH2r5mvG3-TT2YG28zPx_7AzvG3MYvWHh1XVYqvLY8FpYW_4vQ@mail.gmail.com>
 <20220404162307.34xrmdfran3mvnvb@cyberdelia>
In-Reply-To: <20220404162307.34xrmdfran3mvnvb@cyberdelia>
From:   Pavel Shilovsky <pshilovsky@samba.org>
Date:   Fri, 29 Apr 2022 15:17:41 -0700
Message-ID: <CAKywueRHJ2J6ygLPbbKhgc7CPuEn=jJuY0anDSVmJxsCOXb1Ug@mail.gmail.com>
Subject: Re: [PATCH] mount.cifs.rst: add FIPS information
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Enzo,

Thanks for the patch.

After it is applied, the build fails on my machine:

rst2man --syntax-highlight=none mount.cifs.rst mount.cifs.8
mount.cifs.rst:952: (ERROR/3) Unknown target name:
"https://csrc.nist.gov/csrc/media/projects/cryptographic-module-validation-program/documents/fips140-2/fips1402ig.pdf<https://csrc.nist.gov/csrc/media/projects/cryptographic-module-validation-program/documents/fips140-2/fips1402ig.pdf>".

Does it compile on your side?

Best regards,
Pavel Shilovsky

пн, 4 апр. 2022 г. в 19:26, Enzo Matsumiya <ematsumiya@suse.de>:
>
> On 04/03, Steve French wrote:
> >SMB2.1 or later is probably fine (and we note SMB2.1 or 3) for most
> >cases in our mount warning message.
> >
> >But this FIPS compliance issue reminds me that we should get the other
> >auth mechanisms working that are 'peer to peer' (so not forced to be
> >domain joined).   krb5 is great, but Macs support 'peer-to-peer
> >kerberos' and also SCRAM (RFC 7677) so we could also presumably get
> >FIPS compliant login for peer-to-peer cases if we implement on or both
> >of those other auth mechanisms.
>
> Thanks, Steve. AFAIK, as I mentioned earlier, I don't see FIPS
> disapproving particular auth mechanisms, but if those you mention uses
> algorithms that are not on FIPS-validated crypto modules, we're out of
> luck there as well.
>
> (full disclosure: I'm not yet familiar with "peer-to-peer kerberos")
>
> On-topic: I'd just like to have this patch merged for informational
> purposese only. I then can start working on your's and Tom's
> suggestions.
>
> >Anyone have some Macs or Mac VMs to test against ...?
>
> Yes. But let's move this one privately please.
>
>
> Cheers,
>
> Enzo
