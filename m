Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A13A3C433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 09:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 541B064E90
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 09:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbhBYJVI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Feb 2021 04:21:08 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55707 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236352AbhBYJTB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 25 Feb 2021 04:19:01 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5DF255C0074;
        Thu, 25 Feb 2021 04:18:11 -0500 (EST)
Received: from imap1 ([10.202.2.51])
  by compute1.internal (MEProxy); Thu, 25 Feb 2021 04:18:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        simon-taylor.me.uk; h=mime-version:message-id:in-reply-to
        :references:date:from:to:cc:subject:content-type; s=fm2; bh=R3A0
        OYO+A4Jhz+fr2u+mfG6ww+/cdLvaGAqE/xnvF3s=; b=N+eYuR1tUs8vki0Y4S3Y
        CVPV5QvUIHBGwGR0c+FV6OGs+V7YiKgRmsIAz2Bs2mQO38vrGJp3fGCxZs9MrbSZ
        eND0GIJD/GEqKsNFOTyRs+XzxpMoV8chtpc3HBs+MpyZEQCbqhOXms++Q7svDWe+
        MCvTNSNxUYf91LSiV0iugIB+PhXIThXGP/NECfaTWW4yBnQeYPSvZafkT8Dx13TK
        wVE5OQ4Ts1x48vMytmhex03G+F7Tl9motSN91++W6QJn24E1fJgROXQKXJOqr61m
        IAZs13nTl6eH1SerBdCo6UebBl4BVA/+/c9/kNuY0kWW1dG1/6IchrsgDzKqKFMX
        0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=R3A0OY
        O+A4Jhz+fr2u+mfG6ww+/cdLvaGAqE/xnvF3s=; b=OZAr6DG8mSVdAuiGwSAZG7
        A57Ie19zd0YI0LeTOrHb6Ndjb4Fxv8vrtA3hj3Y313HcooPqzqb1yCq28RicStZ4
        uEB8Uiv2TY8qsDQs3STVMOHFxmfvZ5CjI0+wBkdYJsR0U2/4PH45lQ9tVgrfjnOn
        tOcDKhlWJZvYVSujUfwGe/OjlgtsFELx3ZtFZlkz28D+pWgbMytuKU69wvKXur1+
        8xurbGp81zZRx6JvUUNENnXkpak90EUTd9mdjJd0UyeKOOR7/rY3qBz6rndW+biF
        EwoTvQdUhU3jyMzrA1goW++YdAylrymMwUwzoU4/Zy+tDO2qAEIJpkdzOmN+69ug
        ==
X-ME-Sender: <xms:Ums3YFZZLRIL9OTKRmzf0wlbXVgcD3hhTmuozdVkvNxc5WsPQNk6fQ>
    <xme:Ums3YMZp0LJIBREGci2FhWa0jbNyyi8zby81tP6bhtpGj2c9WzIgoLvuH9kzuj3pw
    nKsyt6NjrWB99CYEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeelgddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfufhimhho
    nhcuvfgrhihlohhrfdcuoehsihhmohhnsehsihhmohhnqdhtrgihlhhorhdrmhgvrdhukh
    eqnecuggftrfgrthhtvghrnhepleejvdeutdffudfghfelvddugffguedtieekheehvefg
    hedthedtffdvteetueetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepshhimhhonhesshhimhhonhdqthgrhihlohhrrdhmvgdruhhk
X-ME-Proxy: <xmx:Ums3YH9FrY8bC4Yx5r8hOdP2ccuMpXzGtZ8lx6at7UL7vW6eFYdqWQ>
    <xmx:Ums3YDodLlG4Jo9ASO_MOdsbVSb69ZUqk1WW4w5z4ycy--LYCCZdew>
    <xmx:Ums3YApSoHiuk3ios3QHT6NR1FR7vKVeqnJSaU7RBccf4SPPnk0znQ>
    <xmx:U2s3YNDV0XUVHPi9vrHvm89vgQg9ghQ1YbLmSIspwVQPcfZqoaZqNw>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id E6DEF130005E; Thu, 25 Feb 2021 04:18:10 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-141-gf094924a34-fm-20210210.001-gf094924a
Mime-Version: 1.0
Message-Id: <cd9f90aa-53f0-43a2-9683-b5730d01ca90@www.fastmail.com>
In-Reply-To: <CAN05THRTEXjZ+TQB+X2kA_i8CgKctBDB1UhbifAu0WzqHOuNmw@mail.gmail.com>
References: <0736dea6-ab54-454d-a40b-adaa372a1f53@www.fastmail.com>
 <CAN05THRTEXjZ+TQB+X2kA_i8CgKctBDB1UhbifAu0WzqHOuNmw@mail.gmail.com>
Date:   Thu, 25 Feb 2021 09:15:59 +0000
From:   "Simon Taylor" <simon@simon-taylor.me.uk>
To:     "ronnie sahlberg" <ronniesahlberg@gmail.com>
Cc:     "Steve French" <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Subject: Re: Using a password containing a comma fails with 5.11.1 kernel
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, 25 Feb 2021, at 7:37 AM, ronnie sahlberg wrote:
> Hi Simon,
> 
> Looks like the special handling of escaped ',' characters in the
> password mount argument was lost when we
> switched to the new mount api.
> 
> I just sent a patch for this to the list,  can you try that patch?
> 
> Thanks for the report.
 
Hi Ronnie,

Thanks. Your patch resolved the issue.

Regards,
Simon
