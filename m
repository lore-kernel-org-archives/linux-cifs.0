Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FDDCC433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Mar 2022 16:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351653AbiCXQZg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 24 Mar 2022 12:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351657AbiCXQZe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 24 Mar 2022 12:25:34 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F49A6D3A2
        for <linux-cifs@vger.kernel.org>; Thu, 24 Mar 2022 09:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=aNMNUcnwYzm9aW+PHptjvgJwM15XvBX5OfJqXQsNVUI=; b=RyQ1Qc+fZ5gON/HqYKfLEZMsm3
        weucAA6NXIB6bBrgnIGpdhMOIOVgSEP28VXU7LIUhWkpjWtunE3MWHLlAMn/OipTPofSJErLrIDCS
        z4xOHSZp9mxLjBIvBJtktuoBOdEPLlDiEmcPSBx4b+ZHJcqoB6fYv413XLGb/uFIeCRC+Bc7p63pO
        RkUbKnhfsZ3ALS67nr8osJgBxA/KCILWRwlBWKrgLeTaV4i5oFQp1Qx0QLRwjNwlf2OkFGlfp76fX
        wqIRqIrQjFUy5jYk3LciWQI/7yGMW8CH0Be0+AN2k+Irb1nit91GpmbrSA1osJKv4zXiZ+onbAiC/
        v3Ts0B6viO4escniPiw+TYzYJx4ZmO85l1Vo5/ahgbdlfH17e218HFuTH1Beo0nvb/O1dMd5PYN9T
        bT9jhzHu9YeMxcVHU4qDggn+hCmjFaZecpZFt1lYWYh2UTl0V4qUCHUFMX6hECg/mm4SiQU3zAlma
        89YndcEd90okoI1bu/ovVZWH;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nXQFe-003GzI-Kt; Thu, 24 Mar 2022 16:23:55 +0000
Date:   Thu, 24 Mar 2022 09:23:51 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Tom Talpey <tom@talpey.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        samba-technical@lists.samba.org, linux-cifs@vger.kernel.org,
        smfrench@gmail.com
Subject: Re: Signature check for LOGOFF response
Message-ID: <YjybF0CDEIkXmVov@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20220319032012.46ezg2pxjlrsdlpq@cyberdelia>
 <a0972fb5-38d3-5990-7c8e-0b7dd61d1abb@talpey.com>
 <20220323172913.56cr2atzfcunv5kf@cyberdelia>
 <e23752b1-b610-98f9-c338-5faea047494c@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e23752b1-b610-98f9-c338-5faea047494c@talpey.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Mar 24, 2022 at 11:04:30AM -0400, Tom Talpey wrote:
>On 3/23/2022 1:29 PM, Enzo Matsumiya wrote:
>>Hi Tom,
>>
>>On 03/19, Tom Talpey wrote:
>>>What server is returning this unsigned response? Assuming it's Windows,
>>>that is either a doc bug or (arguably) a server bug, and should be
>>>reported before deciding how to address it here.
>>
>>It's a NetApp ONTAP 9.5P13. We've identified it's also setting wrong
>>signatures on READ responses with STATUS_END_OF_FILE.
>>
>>Our tests against Windows Server 2019 showed it to behave ok, so it
>>looks like something on NetApp side.
>
>In this case I don't think it is appropriate to apply the suggested
>patch. Allowing unsigned or invalidly signed responses will greatly
>reduce security. I'll be interested if NetApp provides any information.

Welcome to our world :-). Doing:

git log|grep -i NetApp|wc -l

shows 32 instances (some are commit messages with NetApp in
them two or more times so the number is probably a little
smaller than 32) of commits in Samba especially to
deal with NetApp bugs :-).

That's a lot of client bugfixes :-).
