Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A43C433FE
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Oct 2022 05:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiJTFrr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 Oct 2022 01:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJTFrq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 Oct 2022 01:47:46 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B829E159A3F
        for <linux-cifs@vger.kernel.org>; Wed, 19 Oct 2022 22:47:45 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id k2so44859979ejr.2
        for <linux-cifs@vger.kernel.org>; Wed, 19 Oct 2022 22:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wtgMzaVHNkEHfbrTwYVvvoc3p95isMbzJz0Q4p9O5C0=;
        b=pTBYyIc/X3/KfkFGEuY5+v31FBR1n4rhAFNYePbLtmytVr7x1i5McTS4ziib+6WYSO
         V9WC8tC3lU0Zg9AQpDlcNpvza1qFZ0fCDMeUOYpDuOvvoPah/wrVmyPlmwJBLVaUifj/
         2MCRsVJ2sd601OuOdKCmrgpjzCZDQ01+SoVnBkW2q4X9DBvXYGZw7VGOodaeaI65bfDQ
         aUVtWo2ChFnDgY8IzgubZLnGSLTRPoI367A1SoXulBHUa8LZsVDEozF19bxn5MkcKYhW
         O0D7elc3AadxOAQnycBqxIqVRvIHaqf8hXyF84h/iMPP0qKcOcTcY5WgikEJlzDxr+4A
         M9gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wtgMzaVHNkEHfbrTwYVvvoc3p95isMbzJz0Q4p9O5C0=;
        b=Aumvpu463gH+g2MeSe+Xu0dMTSDPdIvkx1ywuRjZqMrJt0I/t7mZiLMxcQawzwsXby
         xIFaBT2p6VdupDnTytfgTFoEMuh/vYnIA7ctY2iqV6eFGRVyiTwQA1ukXd3/mImrUOi+
         yqkvCqJMxPWwUqU2nqQFQP6c/8qkXyYMRXsNyRo+TQS7AxA0c3UFF0cV6EtyfvjkVNoF
         FpnAol8VL0EVbkSXQ7juzY0OTnVnlnb8NTC8MscF8nVRHvVrqtPEspc3ewdqAI2eOxGx
         zg+9FJZHg3mnZJrgcFI8JXCiG763C781Kf7a3H5xDx6TWkOKtVxkOPBQT3JOEv1iX2av
         pInQ==
X-Gm-Message-State: ACrzQf0DWxDceBBpXmWjLnFTTObPrLfhxJfJ/dLOYpX0ZQVcuDBsHHyI
        4iUAKZBwq8p/3WDPH0wJ6x+CZlr46p/aSli4NBiMUMG9TyQa7w==
X-Google-Smtp-Source: AMsMyM5rARGlPjb3P+60oh7NEI6OrNR4jXPu8pPxPs2Ux0K7AxEaNc474aP5WTEA9v6RcksgA6c8/ND3TWwq0Mqo7us=
X-Received: by 2002:a17:907:9603:b0:742:9ed3:3af2 with SMTP id
 gb3-20020a170907960300b007429ed33af2mr9572199ejc.510.1666244864023; Wed, 19
 Oct 2022 22:47:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvf3zjMb3=ceL9wknZhMwp6CrOQEyzZ7HaXDNidYpLCBQ@mail.gmail.com>
 <bc73fcd9-3a30-75f1-5745-94f0e2509cf4@talpey.com> <CAH2r5muH+n6TYS3_O9pbwREWJ_GYuva_PvOLd88pxG+t9kVeCA@mail.gmail.com>
 <ed5577b5-3fc2-cfac-8ea8-e8f425a47069@talpey.com> <CAH2r5mvwy+foxWEznbD4R28=kv4-zdAqGwc7UTgH0WeCAceVEw@mail.gmail.com>
In-Reply-To: <CAH2r5mvwy+foxWEznbD4R28=kv4-zdAqGwc7UTgH0WeCAceVEw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 20 Oct 2022 11:17:32 +0530
Message-ID: <CANT5p=rnJD_6F4RQK2L=gqK_dVQvpH9KuvSSh9=qUJxhALjmtQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] Server interface count incorrectly calculated
To:     Steve French <smfrench@gmail.com>
Cc:     Tom Talpey <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Oct 18, 2022 at 3:22 AM Steve French <smfrench@gmail.com> wrote:
>
> Updated one is also at
>
> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=patch;h=3f825b8fa93bb300e60c932753e8c5274b253a77
>
> On Mon, Oct 17, 2022, 16:28 Tom Talpey <tom@talpey.com> wrote:
>>
>> On 10/17/2022 5:26 PM, Steve French wrote:
>> >
>> >
>> > On Mon, Oct 17, 2022, 16:03 Tom Talpey <tom@talpey.com
>> > <mailto:tom@talpey.com>> wrote:
>> >
>> >     On 10/15/2022 6:10 PM, Steve French wrote:
>> >      > smb3: interface count displayed incorrectly
>> >      >
>> >      > The "Server interfaces" count in /proc/fs/cifs/DebugData increases
>> >      > as the interfaces are requeried, rather than being reset to the new
>> >      > value.  This could cause a problem if the server disabled
>> >      > multichannel as the iface_count is checked in try_adding_channels
>> >      > to see if multichannel still supported.
>> >      >
>> >      > Cc: <stable@vger.kernel.org <mailto:stable@vger.kernel.org>>
>> >      >
>> >      > See attached
>> >      >
>> >
>> >     This zeroes the ses->iface_count under the lock, but the whole
>> >     routine is dropping and re-taking the same lock many times,
>> >     and finally sets the iface_count without holding the lock at
>> >     all.
>> >
>> >
>> > I updated the patch earlier today to fix that existing issue as well
>> > (served into same patch). If I missed something let me know
>>
>> I was just looking at the patch attached to the message I replied to.
>> I'll look again, but it will have to be tomorrow.
>>
>> Tom.

Looks good to me for fixing the issue.
One or two more changes needed in this area. You can expect additional
patches from me in the coming days.

-- 
Regards,
Shyam
