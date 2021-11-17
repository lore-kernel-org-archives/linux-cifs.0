Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80361C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Nov 2021 17:25:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BF9061B50
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Nov 2021 17:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237579AbhKQR2r (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Nov 2021 12:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhKQR2p (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Nov 2021 12:28:45 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681E4C061570;
        Wed, 17 Nov 2021 09:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=F+SAy1fSwo/1UHb21eYJQXpRzry7kLwoyhF6lnmVgT8=; b=ichtO4UKbCgnWjXKeOn77AH9e5
        575oB77g6fC/qjmlvzfoBE1xbdkKGVne2WRkPlxrzrNWzTsAURXAcX4IjG1WxPpO4s5hP4jb3F78P
        d4ivkFmLlmV4XDmAb5txmKFKFyNiBL0QYOvNVgm69oNGNV4uK0KY1gNSxx20p/9CmVHPWMDgCKmR1
        nXGdemvIA/jHm3a+ZGeTxxHnoTZxfrsfLYVvlFYpzmkVfAsXICwUeOOJfnRv9wlknVHg6A/tYGS1p
        6TeDC21wMkMBApXMgnf2G46Lj4WObbqA8y+SsI3fM10CQdGpJzJ7VuWYJNgcW4yYXls10sArZWxHg
        gZwFirqfskQ9e6NE2wfZczfUD37JSnZ2w0ZFtwfJqC2yO3uvbwVIzCuhhtewzbYH/i+S1pjyAidyO
        FS4YdEcYOI7E2ArLDWYvEOGKdvM860lRtTNCt1Ai++Jj3NKJ3A18yb5NOSvHdIXYSmI/od4O2lqUt
        hm8fBEWz+VI+1Tq4ij9LzpVP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mnOgn-007aa4-Fu; Wed, 17 Nov 2021 17:25:41 +0000
Date:   Wed, 17 Nov 2021 09:25:37 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: ksmbd: Unsupported addition info
Message-ID: <YZU7EdoJmvisai+z@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <5831447.lOV4Wx5bFT@natalenko.name>
 <CAKYAXd-KmxMeYWP8z6RYYK6za-Sj81Qtb3RO=oG+Yy3kXDaLjg@mail.gmail.com>
 <2865530.e9J7NaK4W3@natalenko.name>
 <CAKYAXd9wKDTE5WPQWcBZ_mHfaAOOY+pDj7=yndi17gf2KqWpwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKYAXd9wKDTE5WPQWcBZ_mHfaAOOY+pDj7=yndi17gf2KqWpwg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Nov 17, 2021 at 06:58:50PM +0900, Namjae Jeon wrote:
>2021-11-17 16:00 GMT+09:00, Oleksandr Natalenko <oleksandr@natalenko.name>:
>> Hello.
>>
>> On středa 17. listopadu 2021 0:36:53 CET Namjae Jeon wrote:
>>> 2021-11-17 6:44 GMT+09:00, Oleksandr Natalenko
>>> <oleksandr@natalenko.name>:
>>> > With the latest ksmbd from the next branch I have an issue with wife's
>>> > Windows
>>> > 10 laptop while copying/removing files from the network share. On her
>>> > client it
>>> > looks like copy operation (server -> laptop) reaches 99% and then
>>> > stalls,
>>> > and
>>> > on the server side there's this in the kernel log:
>>> >
>>> > ```
>>> > ksmbd: Unsupported addition info: 0xf)
>>> > ksmbd: Unsupported addition info: 0x20)

Namjae, looks like your code is handling the
following flags in query security descriptor:

         if (addition_info & ~(OWNER_SECINFO | GROUP_SECINFO | DACL_SECINFO |
                               PROTECTED_DACL_SECINFO |
                               UNPROTECTED_DACL_SECINFO)) {
                 pr_err("Unsupported addition info: 0x%x)\n",
                        addition_info);

 From the Samba code we have (the names are pretty
similar):

         /* security_descriptor->type bits */
         typedef [public,bitmap16bit] bitmap {
                 SEC_DESC_OWNER_DEFAULTED        = 0x0001,
                 SEC_DESC_GROUP_DEFAULTED        = 0x0002,
                 SEC_DESC_DACL_PRESENT           = 0x0004,
                 SEC_DESC_DACL_DEFAULTED         = 0x0008,
                 SEC_DESC_SACL_PRESENT           = 0x0010,
                 SEC_DESC_SACL_DEFAULTED         = 0x0020,
                 SEC_DESC_DACL_TRUSTED           = 0x0040,
                 SEC_DESC_SERVER_SECURITY        = 0x0080,
                 SEC_DESC_DACL_AUTO_INHERIT_REQ  = 0x0100,
                 SEC_DESC_SACL_AUTO_INHERIT_REQ  = 0x0200,
                 SEC_DESC_DACL_AUTO_INHERITED    = 0x0400,
                 SEC_DESC_SACL_AUTO_INHERITED    = 0x0800,
                 SEC_DESC_DACL_PROTECTED         = 0x1000,
                 SEC_DESC_SACL_PROTECTED         = 0x2000,
                 SEC_DESC_RM_CONTROL_VALID       = 0x4000,
                 SEC_DESC_SELF_RELATIVE          = 0x8000
         } security_descriptor_type;

0xF == (SEC_DESC_OWNER_DEFAULTED|SEC_DESC_GROUP_DEFAULTED|SEC_DESC_DACL_PRESENT|SEC_DESC_DACL_DEFAULTED)

and:

0x20 == SEC_DESC_SACL_DEFAULTED

Looks like you need to handle these bits.

Hope this helps,

Jeremy.
