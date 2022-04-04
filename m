Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DAE4C433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Apr 2022 01:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376883AbiDDBtx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 3 Apr 2022 21:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344091AbiDDBtw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 3 Apr 2022 21:49:52 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B16186CB
        for <linux-cifs@vger.kernel.org>; Sun,  3 Apr 2022 18:47:57 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id b17so6885371lfv.3
        for <linux-cifs@vger.kernel.org>; Sun, 03 Apr 2022 18:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=21rWQWqg6s9e3GtwFu3CjMOsuqa/vJSqxwc7F86Ymn0=;
        b=kQb1j8pFQeT8ylzt1uZn2sPoTUqHIWDmV09Fe6UrMkJ4Br1IilpOySI9tgPddDgu2g
         YlVjuNC6Q7ToGo6Qi9jmJOYCLw1Qt8atoS3qpaxkSbYPdIydFOjbjRpDkznxXEdcKPMi
         ROcpK+e/qPn6YyqoKaiUqopMWdpmYDz44SgWhhybca6OoxUOAfp8Qtt74NcQnQXruRNu
         dRacRhOjrYLSuIOljAUGAT3GDkEhgXn2EWPDzdGHGUXlfP+2ZBsQsJCNSS6E2dWLCZhi
         Ig0MmMbqXaZ2KVqeIVLvamiOBX+5nRI3BuV7qXdGS+xmmRoQ2u46p3jAUg1SmfIn5vo4
         +GjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=21rWQWqg6s9e3GtwFu3CjMOsuqa/vJSqxwc7F86Ymn0=;
        b=MC+RsznvjGP+QEzolUlJzmhAgik9pKiu6rEL0XRckE+BrrJJAHJQ7XWxlYDjFQyeXc
         Re3Ad1sR2tRTzBx18zqa8TV0V4lLnT2226pq1j1ylQ8Xh3m7Mzj9xhP1zeZ9bwB0LW2J
         TlD03UTALM9lXwHji7+OBRiTBQL41W2gg93+QtQ1aYye3TvsvEKIN2IzPXOGjtHZ9+cm
         4CcEZKaDY7Q+digcLY8s0JkSEiO0ix8QnjIe/zuYAkSmIfFNrBzD9MgkuGrpVbBco69P
         lugez6q22CsJstbe/H0QuM6X1eeMdvjOqCfb3chbRifhqEcLG0bI9h0RMaMNJ0T1nAh5
         02lQ==
X-Gm-Message-State: AOAM532o0MncILdpd/WivyMTOtv8RCI7uKJEAHvnaiETIsayueW8a/b+
        ZsPvwziN/2eHU9pD+SvgwHfqwLe3hx35h4R0yfs=
X-Google-Smtp-Source: ABdhPJwJw7hk4SXTmq629KVEQ247jwGVhmhvR/n0sij+o2juf08NxGevcCNdxL5G465ZmvkfrhO+Z0KmnU/LA0ACilA=
X-Received: by 2002:a05:6512:2387:b0:44b:22f:1db2 with SMTP id
 c7-20020a056512238700b0044b022f1db2mr2452961lfv.234.1649036875033; Sun, 03
 Apr 2022 18:47:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220331235251.4753-1-ematsumiya@suse.de> <efb1d822-4fcf-dc3b-2861-8394f50aedbe@talpey.com>
 <20220401152508.edovgwz5pxn6gnhn@cyberdelia> <d5648e12-c5b9-07de-a20b-afd49adc5f56@talpey.com>
 <20220401174145.6x443h555ch7kspd@cyberdelia>
In-Reply-To: <20220401174145.6x443h555ch7kspd@cyberdelia>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 3 Apr 2022 20:47:43 -0500
Message-ID: <CAH2r5mvG3-TT2YG28zPx_7AzvG3MYvWHh1XVYqvLY8FpYW_4vQ@mail.gmail.com>
Subject: Re: [PATCH] mount.cifs.rst: add FIPS information
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Tom Talpey <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <pshilovsky@samba.org>,
        Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

SMB2.1 or later is probably fine (and we note SMB2.1 or 3) for most
cases in our mount warning message.

But this FIPS compliance issue reminds me that we should get the other
auth mechanisms working that are 'peer to peer' (so not forced to be
domain joined).   krb5 is great, but Macs support 'peer-to-peer
kerberos' and also SCRAM (RFC 7677) so we could also presumably get
FIPS compliant login for peer-to-peer cases if we implement on or both
of those other auth mechanisms.

Anyone have some Macs or Mac VMs to test against ...?

On Fri, Apr 1, 2022 at 12:41 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> On 04/01, Tom Talpey wrote:
> >On 4/1/2022 11:25 AM, Enzo Matsumiya wrote:
> >>On 04/01, Tom Talpey wrote:
> >>>Is SMB2 really FIPS compliant? Even if it is, a server that doesn't
> >>>support anything higher is obviously far out of date.
> >>
> >>It's more that the crypto stuff used by SMB1 is *not* compliant.
> >
> >Sure, but that's not the point here. It's time to simply state
> >"don't use SMB1".
>
> I 100% agree.
>
> But, actually, that's the whole point of my commit. I just wanted to add
> what will work with mount.cifs on a FIPS compliant environment. Nothing
> else.
>
> Stating "don't use SMB1" (either FIPS or not) could come in a different
> commit.
>
> (Personally, I would've nuked all SMB1 from the kernel altogether :P)
>
> >I don't think the crypto algorithm is enough. SMB2 is vulnerable
> >to man-in-the-middle attacks and therefore the crypto type is
> >only a part of the picture. SMB3 is much stronger, even with the
> >same crypto algs.
>
> Again, I agree. But I'd say it's up to FIPS to mandate that. Even
> because their requirements only cover the crypto modules, not
> filesystems and/or versions as a whole AFAIK.
>
> >The Microsoft FIPS statement only refers to SMB3, for example:
> >
> >
> >https://docs.microsoft.com/en-us/windows/security/threat-protection/fips-140-validation
> >
> >  Is SMB3 (Server Message Block) FIPS 140 compliant in Windows?
> >
> >  SMB3 can be FIPS 140 compliant, if Windows is configured to operate in
> >  FIPS 140 mode on both client and server. In FIPS mode, SMB3 relies on
> >  the underlying Windows FIPS 140 validated cryptographic modules for
> >  cryptographic operations.
>
> But that's on a product (OS) level. We're preparing similar
> documentation for SUSE as well, for example.
>
> >I think anyone who is serious enough to want FIPS should darn well
> >be advised that the best security means running the strongest version
> >of the protocol, and the doc should not waffle around with discussion
> >of SMB1 or SMB2.
>
> And again, I also agree. My intent was to rather have specified in the
> docs what's supported in FIPS mode. Suggesting/enforcing a particular
> version or security mode was out of scope of my patch.
>
>
> Cheers,
>
> Enzo



-- 
Thanks,

Steve
