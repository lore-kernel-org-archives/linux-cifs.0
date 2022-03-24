Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5422C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Mar 2022 18:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352728AbiCXSy3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 24 Mar 2022 14:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347682AbiCXSy3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 24 Mar 2022 14:54:29 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB71B8211
        for <linux-cifs@vger.kernel.org>; Thu, 24 Mar 2022 11:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=cnJg7cqXnZ2NM8qMLuDrdJylj4Q2t9t11dJUV7tyPVQ=; b=tnTi0kvuFrFZGcXwGMQw7i9ibD
        s9K/0BruhhlidnX8O5voHPt/zPfmlw+AoEEkXTQGyB4N6gJNY7aEweS8BigUoYxc7XeX9Y1COstV1
        FDnJH7uE9p0t0AKlrsbug35aDb2bSmM4ts9lm/lgAOsuz/cGNgbDae+B4B2Ba/jatBUCgT0LiT7lF
        oOfy0d2WNJenCG63xXS4fgoh83V5XKlCEEuH1CpgiopABXOzNXLalSja9yT+dxG+7FlfBUEN/oamv
        fOiblX/Nqy5M+5MrjN7fuOcA+vw9bHcjvfsArCF4fRzWFJjQl8Q5t/raatpYKMXOl0S/lBfHbKoHd
        i0n/H5N/Lq4N+Z5Kyx0I/41LgzvE8MidEiUo9VDW+oIoDy5XaHgBn1vV+GuCIbsVPmj8nf1KtgAoN
        9gJWM55fCb5wLINlqmnXmYPVTVK4a4JEXRDcTy2idmaTbKcFcOjKABJcwaU3A+3apjKvW7x5cCWek
        e1c/efeD7sBv+xZ+fH7oVJkL;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nXSZq-003IDw-AI; Thu, 24 Mar 2022 18:52:54 +0000
Date:   Thu, 24 Mar 2022 11:52:51 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Tom Talpey <tom@talpey.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        samba-technical@lists.samba.org, linux-cifs@vger.kernel.org,
        smfrench@gmail.com
Subject: Re: Signature check for LOGOFF response
Message-ID: <Yjy+Az4km5Tmrch/@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20220319032012.46ezg2pxjlrsdlpq@cyberdelia>
 <a0972fb5-38d3-5990-7c8e-0b7dd61d1abb@talpey.com>
 <20220323172913.56cr2atzfcunv5kf@cyberdelia>
 <e23752b1-b610-98f9-c338-5faea047494c@talpey.com>
 <YjybF0CDEIkXmVov@jeremy-acer>
 <beaa2c31-96d3-7697-7dad-44585817ae46@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <beaa2c31-96d3-7697-7dad-44585817ae46@talpey.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Mar 24, 2022 at 02:48:22PM -0400, Tom Talpey wrote:
>On 3/24/2022 12:23 PM, Jeremy Allison wrote:
>>On Thu, Mar 24, 2022 at 11:04:30AM -0400, Tom Talpey wrote:
>>>On 3/23/2022 1:29 PM, Enzo Matsumiya wrote:
>>>>Hi Tom,
>>>>
>>>>On 03/19, Tom Talpey wrote:
>>>>>What server is returning this unsigned response? Assuming it's Windows,
>>>>>that is either a doc bug or (arguably) a server bug, and should be
>>>>>reported before deciding how to address it here.
>>>>
>>>>It's a NetApp ONTAP 9.5P13. We've identified it's also setting wrong
>>>>signatures on READ responses with STATUS_END_OF_FILE.
>>>>
>>>>Our tests against Windows Server 2019 showed it to behave ok, so it
>>>>looks like something on NetApp side.
>>>
>>>In this case I don't think it is appropriate to apply the suggested
>>>patch. Allowing unsigned or invalidly signed responses will greatly
>>>reduce security. I'll be interested if NetApp provides any information.
>>
>>Welcome to our world :-). Doing:
>>
>>git log|grep -i NetApp|wc -l
>>
>>shows 32 instances (some are commit messages with NetApp in
>>them two or more times so the number is probably a little
>>smaller than 32) of commits in Samba especially to
>>deal with NetApp bugs :-).
>>
>>That's a lot of client bugfixes :-).
>
>Well, it could be argued that this is prolonging the bad behavior.
>The NFS client maintainer's approach is the opposite - if the server
>is violating the protocol, he holds the line and will not change
>the client. I know, I know, it's all in how each person sees it. :)

It's all a question of leverage. A Microsoft behavior defines
the protocol, even if it's an inadvertant bug.

For NetApp, people using cifsfs, libsmbclient or our client tools just
want the damn thing to work. NetApp only (as far as I know)
test against a Microsoft client, so we have zero leverage here.

Sucks, but as I said, "Welcome to our world" :-).
