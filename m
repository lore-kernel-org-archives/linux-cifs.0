Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 283DDC433F5
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 10:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E873761054
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 10:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbhKGKwT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 Nov 2021 05:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbhKGKwT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 7 Nov 2021 05:52:19 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628C4C061570
        for <linux-cifs@vger.kernel.org>; Sun,  7 Nov 2021 02:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=1WdqUD6rW9e7HNWaG5tbekcdpZc8J9g520NPnVIIg68=; b=dYf9uQV/KDNn+YmzBk+1Oqm2AM
        rtLopC8/6YnkTGc7qp+cCxKo9m3dhMNzjUsHlyn9i3r1Qphn10TPknYHRkn5e18AAAQfD4WDQ8Hx0
        XVCEWohfkST9PejiMZK/NxFux9NL4tNMMBrqogUSvSX3K0pTfJM9j+R6X+2a2j84niqpUrdHPq7qx
        Tzb81iLxu3Ao/JJu8gcCS+hc+/RsSfXuYo+T0YbCol8mOs6L2DuTp4NqadnwRliOwIv4ixKuWRyQt
        pc0LEfB7Cwitei1weem3bSLmTkMi0iQpKMY48eptGbRa55Lcg00jWfwqnnxK/y+xwOgQfouDkR2f4
        K5/+c4/pcNVoz3eoNS6pEK+/tDM3onFQlM8ezg4UGsCKGmvVtC3vBd7Bmw+89W+ozWEPrYe6TT7EZ
        dCw2z8JklcwXcgPZW1kBSqfom9xNEHcEbB41V8R9SyN7Of3tHcJHmR0yrL/9ndaq+wCUvi0lNAHBR
        mTWqn2rk8L8L/y8qqGK/nLdL;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mjfjx-005dMn-A0; Sun, 07 Nov 2021 10:49:33 +0000
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
References: <CANT5p=rgHn59NVvH32FSKtNv_cyKi4ATSAExBmWT_qjb7km7Fw@mail.gmail.com>
 <20211106013854.6qx3tz53pvayqcgm@cyberdelia>
 <CAH2r5mvQG0DFmMdzojH2u_w2=_9oGRV++AnEt_d7WJzj=-uTKA@mail.gmail.com>
 <CANT5p=qOQDg4xDbx6oZafJc+gnM0pN+aYOgjokU54ZeLXq_uDQ@mail.gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH] cifs: send workstation name during ntlmssp session setup
Message-ID: <bf98a745-5feb-c38a-4641-6dd91c364c8e@samba.org>
Date:   Sun, 7 Nov 2021 11:49:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CANT5p=qOQDg4xDbx6oZafJc+gnM0pN+aYOgjokU54ZeLXq_uDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Hi Shyam,

>>>> Please review this patch, and let me know what you think.
>>>> Having this info in the workstation field of session setup helps
>>>> server debugging in two ways.
>>>> 1. It helps identify the client by node name.
>>>> 2. It helps get the kernel release running on the client side.
>>>>
>>>> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/d988e704dd9170c19ff94d9421c017e65dbbaac1.patch
>>>
>>> - AFAICS it doesn't consider runtime hostname changes. Is it important
>>>    to keep track of it? Would changing it mid-auth steps break it
>>>    somehow?
> I think that's okay. AFAIK, that's only used for
> debugging/troubleshooting purposes. So it doesn't need to be a 100%
> accurate.

That's not true, the workstation name is used for access checks.

[MS-ADA3] 2.353 Attribute userWorkstations
https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-ada3/ec941bac-bc77-48f3-a1cf-79d773a91b6b

>>>
>>> - I didn't understand the purpose of CIFS_DEFAULT_WORKSTATION_NAME. Why
>>>    not simply use utsname()->nodename? Or even init_utsname()->nodename, which
>>>    is supposed to be always valid.
> I initially did not have the utsname changes. That idea was an afterthought.
> Sure. I'll update the patch to fix this.
> 
>>>
>>> - Ditto for CIFS_MAX_WORKSTATION_LEN. utsname()->nodename has at most 65
>>>    bytes (__NEW_UTS_LEN + 1) anyway. Perhaps using MAXHOSTNAMELEN from
>>>    <asm/param.h> would be a more generic approach.
>>>    (btw this is because nodename is the unqualified hostname, sans-domain)
> Noted.
> 
>>>
>>> - Instead of setting workstation_name to "nodename:release", why not
>>>    implement the VERSION structure (MS-NLMP 2.2.2.10)? Then use
>>>    LINUX_VERSION_* from <linux/version.h> or parse utsname()->release.
> That's a good idea. Let me explore that too.

No, it's not this is for windows version numbers.
https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-nlmp/a211d894-21bc-4b8b-86ba-b83d0c167b00#Appendix_A_32

If you want to encode something you can use
2.2.2.2 Single_Host_Data

metze
