Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F0AC7EE29
	for <linux-cifs@archiver.kernel.org>; Thu, 25 May 2023 16:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235065AbjEYQPr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 May 2023 12:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235665AbjEYQPr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 May 2023 12:15:47 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23A013A
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 09:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=ztcgYMBj9Yt01yBi1C4M1q81670ZmoC1VEW/2juynxM=; b=eyjI4XIQOhoe4GUPmtSqNv1Zwt
        fQMSesrAGkh6jo2tb/GjxqTcXjMwNpR1syBIdi4u/GmDUnFPwHQi+56JdR0MDgovYBj+m3R05MqyF
        IaTYKHcDHM8y9FViC08BC7SubZYhmkbYKxJdZVMh00gc49LB8QlowT6EKsYTwAbTNjB0frGDbCOXn
        UtSLP2uGGyEMilXeuJ/GCwBMqNi2bbAf2V3bCrbVgaP03eBy3B1SZs1C4Fyzot65mvTuezGxOJ4/m
        P6Mp0k8Uk5EdoFv2YSVxxDoEO6hHIwqkz4VKE1dMiFuiovmBlcWND7aArlE4eC/l5/lCVaoJvb7Hu
        XfI95AstaLljEGHL4eD8ZDSBk+AuJ50A+10QaVlGguOUrABoTUDmIZLbgpM2XM1kAcCboe4gUEi3O
        51PJeIvUgUBmE2kTWxX52+3WVYU7xg8mFwDrpORovOohAzIMyf8nnbbw8GsSwoBhZWBs0qWzLdGbi
        SK4YKTlcXgULsFbTBbcqh7fH;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1q2Dcr-00C9vq-E5; Thu, 25 May 2023 16:15:42 +0000
Date:   Thu, 25 May 2023 09:15:36 -0700
From:   Jeremy Allison <jra@samba.org>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Displaying streams as xattrs
Message-ID: <ZG+JqEwIdPHmHhVa@jeremy-rocky-laptop>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5mv8nAncg-f=Z5u8LkH4o7kfJLJdtoksYQgiguF7efKZkQ@mail.gmail.com>
 <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com>
 <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com>
 <ZGuWhzP98U9Niog+@jeremy-rocky-laptop>
 <CAN05THRnHcZtTMLxUSCYQXULVHiOXVYDU9TRy9K+_wBQQ1CFAw@mail.gmail.com>
 <ZGzo+KVlSTNk/B0r@jeremy-rocky-laptop>
 <CAN05THQyraiyQ9tV=iAbDiirWzPxqPq9rY4WsrnqavguJCEjgg@mail.gmail.com>
 <ZG0/YyAqqf0NqUuO@jeremy-rocky-laptop>
 <CAN05THSWHq-3bJ5+tzZ==j9uGFGfbALw0FoLVa9UyucaZ92bGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAN05THSWHq-3bJ5+tzZ==j9uGFGfbALw0FoLVa9UyucaZ92bGQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, May 25, 2023 at 08:57:18PM +1000, ronnie sahlberg via samba-technical wrote:
>On Wed, 24 May 2023 at 08:34, Jeremy Allison <jra@samba.org> wrote:
>>
>> ADS - "Just Say No !"
>
>I think that is a flawed argument.
>It only really means that the virus scanners are broken. So we tell
>the virus scanner folks to fix their software.
>Viruses hide inside all sort of files and metadata.
>There are viruses that hide inside JPEG files too and some of them
>even gain privilege escalations through carefully corrupted JPEG
>files.
>We fix the bugs in the parser, we don't "drop support for JPEG files".

What is the use-case for ADS on Linux ? And don't say "Windows
compatibility" - stories about your mother's advice about
jumping off a cliff have meaning here :-).

Give me an actual *need* for ADS on Linux that can't
be satified any other way before you start plumbing
this horror into the internal VFS code.
