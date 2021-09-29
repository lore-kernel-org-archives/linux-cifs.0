Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B25C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 16:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 018DB61262
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 16:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345641AbhI2QrU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 12:47:20 -0400
Received: from p3plsmtpa12-04.prod.phx3.secureserver.net ([68.178.252.233]:36158
        "EHLO p3plsmtpa12-04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229561AbhI2QrU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 29 Sep 2021 12:47:20 -0400
Received: from [192.168.0.100] ([173.76.240.186])
        by :SMTPAUTH: with ESMTPSA
        id Vci9mdy6RbDvjVciAmWVWb; Wed, 29 Sep 2021 09:45:38 -0700
X-CMAE-Analysis: v=2.4 cv=U4ZXscnu c=1 sm=1 tr=0 ts=61549832
 a=jWrLioA5F7WmVvax94MGYQ==:117 a=jWrLioA5F7WmVvax94MGYQ==:17
 a=IkcTkHD0fZMA:10 a=m4jEnqaFAAAA:8 a=2L7MFlTnB4VszwA5CYYA:9 a=QEXdDO2ut3YA:10
 a=H2Gg6w7js8da1G-FyEO3:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
To:     Ralph Boehme <slow@samba.org>, Jeremy Allison <jra@samba.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
References: <20210926135543.119127-1-linkinjeon@kernel.org>
 <a15a1d99-1a2f-0f41-773e-def5b83f2304@samba.org>
 <CAKYAXd8G5xBBLTS0vS_p1TFoULuxSf-CFjE4n98D+sQrtjpjcw@mail.gmail.com>
 <b9449e7f-5c27-c766-f8e0-1564b8848f7b@samba.org>
 <8f57cac6-1c8a-cbce-b245-bb4015575569@samba.org>
 <CAKYAXd88PNFg4oXisxw8fnUBzCQyceC=2KvPhdU7q6DUgatQbw@mail.gmail.com>
 <79ed52be-c92e-1c62-423f-ee126b3da409@samba.org>
 <YVNR6w7dq0HMIcFA@jeremy-acer>
 <76fcdc45-0a94-d9e6-14c8-1c638d0bd00f@talpey.com>
 <YVSJWPa8dalyzsl0@jeremy-acer>
 <ce52c130-74de-feaa-6995-6a0d947816a6@samba.org>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <27908e3e-140e-8c7a-e792-414fec5b5190@talpey.com>
Date:   Wed, 29 Sep 2021 12:45:37 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ce52c130-74de-feaa-6995-6a0d947816a6@samba.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfHKPdeBMBg1aMQYqQY5EulpnbNxPLI+qUihUOGK+paiS/jHiJTcnV+4yXFsVFHpDLtno4bVuCbmpj1w7cd3fn1p/sV/PpBldEl4Vcgr0as/yaRSXLEQg
 zuNDJQFUrSwKFKk2yVL2N3cchyvG5mUKRxv/pxfxJIovq8RrlB7fvXTFUCzFa6M/GaLHXOkcYjui1ywh6Ei3HFyQlq+b69tKViP4bLV/zeD7j66EOrOIMBXq
 4U3dfZYS95NWjq2Umz9wq1hdWkdZ1ts4cZ8RPay5n+XDu8rE5TYqTunm557B/X04QeYvuFaEUKsfjMlkx9n6C0G8zGHhaDA4JxM2BQqtYjxgmwnmaLbdKIKt
 qnqqRq7v2Ct9Hr0E5rX3ZP71N6jH2N7j0TCYv9duwNDfg313/K8=
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/29/2021 12:38 PM, Ralph Boehme wrote:
> Am 29.09.21 um 17:42 schrieb Jeremy Allison:
>> On Wed, Sep 29, 2021 at 11:28:09AM -0400, Tom Talpey wrote:
>>>
>>> I completely agree that email is inefficient, but git is a terrible
>>> way to have a discussion. We should attempt to be sure we have
>>> those, and that everybody has a chance to see the proposals without
>>> having to go to the web five times a day.
>>>
>>> Please take this as a request for regular git-send-email updates to
>>> this list, so I can see them if I'm not online. Maybe add a boilerplate
>>> line to direct to the git repo webui. I'm sure a few others will
>>> appreciate it too.
>>
>> Samba does well with the web-based discussion mechanism
>> around merge-requests (MR's) in gitlab. I assume github
>> has something similar.
>>
>> Maybe send the initial patch to the list with a link
>> to the github MR so people interested in reviewing/discussing
>> can follow along there ?
> 
> well, if I could have it the way I wanted, then this would be it. But I 
> understand that adopting new workflows is not something I can impose -- 
> at least not without paying for an insane amount of Lakritz-Gitarren 
> that I tend to use to bribe metze into doing something I want him to do. :)

I'm in for github if you send me some too!

https://www.gutschmecker.com/produkt/haevy-metal-salzige-gitarren-10-x-150-g-tuete/


> The problem is not so much doing the *review* on patches sent to the 
> list. While Samba has moved away from doing review on patch emails, it 
> can certainly be done.

Clearly, this effort bridges the Linux and Samba processes. We can
definitely try. I guess I'm going to take some convincing.

Tom.

> The point is, once you go beyond "review" by taking someone else's 
> patchset, modifying it deeply, reordering patches, adding patches, 
> rewriting patches, dropping patches and so on, that's when the 
> patchset-as-email workflow explodes and coordination via git is needed.
> 
> Once such a collaboratively worked on patchset stabilizes, it can of 
> course again go to the mailing list.
> 
> -slow
> 
