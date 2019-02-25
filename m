Return-Path: <SRS0=eDtx=RA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4BA6C43381
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 13:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C9BA2146F
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 13:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfBYNNk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Feb 2019 08:13:40 -0500
Received: from smtp03.citrix.com ([162.221.156.55]:47051 "EHLO
        SMTP03.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfBYNNj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Feb 2019 08:13:39 -0500
X-IronPort-AV: E=Sophos;i="5.58,411,1544486400"; 
   d="scan'208";a="78966070"
Subject: Re: Failure to reconnect after cluster failvoer
To:     Tom Talpey <ttalpey@microsoft.com>,
        Steve French <smfrench@gmail.com>
CC:     CIFS <linux-cifs@vger.kernel.org>
References: <70e91b0b-4bca-60ea-19cf-3df0f49d4e5a@citrix.com>
 <CAH2r5mvDFFMhwyKdEGhgb+5-+v2PyuAWpWN9drofXVvj3mQxYQ@mail.gmail.com>
 <SN4PR2101MB073663B8E9E7AC98A4D0C992A07E0@SN4PR2101MB0736.namprd21.prod.outlook.com>
 <07c8e090-afed-6219-7d24-addfa660d8dd@citrix.com>
 <SN4PR2101MB0736EDA079C01725CBB1A339A07F0@SN4PR2101MB0736.namprd21.prod.outlook.com>
From:   Ross Lagerwall <ross.lagerwall@citrix.com>
Message-ID: <4ffc3de4-ecab-d7fb-b160-b34b45ae1f0a@citrix.com>
Date:   Mon, 25 Feb 2019 13:13:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <SN4PR2101MB0736EDA079C01725CBB1A339A07F0@SN4PR2101MB0736.namprd21.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2/22/19 11:25 PM, Tom Talpey wrote:
>> -----Original Message-----
>> From: Ross Lagerwall <ross.lagerwall@citrix.com>
>> Sent: Friday, February 22, 2019 9:17 AM
>> To: Tom Talpey <ttalpey@microsoft.com>; Steve French
>> <smfrench@gmail.com>
>> Cc: CIFS <linux-cifs@vger.kernel.org>
>> Subject: Re: Failure to reconnect after cluster failvoer
>>
>> On 2/21/19 5:59 PM, Tom Talpey wrote:
>>> The reconnect is apparently using a dotted-quad as the servername, and you
>> can see the auth is forced to NTLM as a consequence. Is that the way you
>> initially mounted the share (i.e. mount 10.71.217.50:/smbshare /mnt)?
>>>
>>> -----Original Message-----
>>> From: linux-cifs-owner@vger.kernel.org <linux-cifs-owner@vger.kernel.org>
>> On Behalf Of Steve French
>>> Sent: Thursday, February 21, 2019 9:07 AM
>>> To: Ross Lagerwall <ross.lagerwall@citrix.com>
>>> Cc: CIFS <linux-cifs@vger.kernel.org>
>>> Subject: Re: Failure to reconnect after cluster failvoer
>>>
>>> Couple quick thoughts.
>>>
>>> Does this work on current kernels (5.0 for example).
>>>
>>> Was thinking about patches that might affect this like:
>>> - "cifs: connect to servername instead of IP for IPC$ share"
>>> - "smb3: on reconnect set PreviousSessionId field"
>>> - Paulo's patches (has cifs-utils coreq) to reconnect to new IP
>>> address if hostname's IP address changed and his add support for
>>> failover
>>> - Paulo's patch to remove trailing slashes from server UNC name
>>>
>> I've reproduced this with 5.0-rc7 and the latest cifs-utils from git.
>> The share was mounted as follows (yes, by IP):
>>
>> mount.cifs -o
>> vers=3.0,cache=loose,actimeo=0,username=x,domain=y,password=z
>> '//10.71.217.31/smbshare' /mnt
>>
>> Here is the tcpdump when it fails to reconnect properly:
> ...
>>
>> The initial connection is at timestamp 0s, reconnection at 13s,
>> STATUS_NETWORK_NAME_DELETED at 60s.
>>
>> For comparison, here is a tcpdump using the "fix" from my previous mail:
> ...
>>
>> The initial connection is at timestamp 0s, reconnection at 34s,
>> successful read request at 215s.
>>
>> Note that the tree connect for IPC$ only happens _after_ the tree
>> connect for the share succeeds.
> 
> Thanks for the full traces, they clarify the situation. But, I don’t see any
> meaningful difference in the client behavior. The ordering of the two
> treeconnects is the same between the two - initially, "IPC$" then
> "smbshare", and on reconnect, the other way around. So, I'm unclear
> whether your patch did anything.

There is definitely a difference. Before the patch, on reconnect the client:

* Connects to "smbshare" which fails
* Then connects to "IPC$" which succeeds
* Then tries again to connect to smbshare which fails repeatedly

After the patch, on reconnect the client:

* Connects to "smbshare" which fails
* Then tries again to connect to "smbshare" which succeeds after several 
retries
* Then tries to connect to "IPC$" which succeeds

This subtle reordering somehow makes it work. It may indeed be a server 
bug rather than a client bug. I was hoping someone could shed some light 
on this.

> 
> The STATUS_NETWORK_NAME_DELETED is a consequence of the failed
> re-establishment of the tree connect, and is not itself the problem. The
> server is simply timing out the treeid, since the client did not successfully
> reclaim it. The repeated STATUS_BAD_NETWORK_NAME is the issue.
> 
> Are you sure the clustered server is recovering properly when you are
> forcing the failover? For example, if it's a two-node cluster, maybe node A
> can take over node B, but node B has issues taking over node A. Is there
> anything relevant in the server logs?
> 

It's a two node cluster. The behaviour happens reliably when failing 
over either way. After failover, the server state is consistent. E.g. 
after a failover from node A to node B, node B shows itself as the 
primary server and the node A is marked as down. I couldn't find 
anything interesting in the server logs.

Thanks,
-- 
Ross Lagerwall
