Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13DE0C433E0
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Feb 2021 20:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C586B64E7C
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Feb 2021 20:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhBPUt0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Feb 2021 15:49:26 -0500
Received: from p3plsmtpa09-10.prod.phx3.secureserver.net ([173.201.193.239]:41353
        "EHLO p3plsmtpa09-10.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229628AbhBPUtZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 16 Feb 2021 15:49:25 -0500
Received: from [192.168.1.116] ([24.218.182.144])
        by :SMTPAUTH: with ESMTPSA
        id C7GwlpxCrT0LVC7GwlYPCU; Tue, 16 Feb 2021 13:48:39 -0700
X-CMAE-Analysis: v=2.4 cv=HOgGqqhv c=1 sm=1 tr=0 ts=602c2fa7
 a=ugQcCzLIhEHbLaAUV45L0A==:117 a=ugQcCzLIhEHbLaAUV45L0A==:17
 a=IkcTkHD0fZMA:10 a=pGLkceISAAAA:8 a=SEc3moZ4AAAA:8 a=APJ4vmNYoOaNcm75dh0A:9
 a=QEXdDO2ut3YA:10 a=5oRCH6oROnRZc2VpWJZ3:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH 4/4] cifs: Reformat DebugData and index connections by
 conn_id.
To:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
References: <CANT5p=o9Tw9E+o3PWytsNh5eDKxswJ+YPLZLWac7QwR_u-UJaw@mail.gmail.com>
 <87h7msnnme.fsf@suse.com>
 <CANT5p=qGTC4E4Rf_-t9xXOo4yf3W=xtk97J1jg-WRLhwf0juBA@mail.gmail.com>
 <87a6sjopsc.fsf@suse.com>
 <CANT5p=qQJwvF11MJpiuV7S1GpH9=HZ-g=hmfOV-a07N9xkYqnA@mail.gmail.com>
 <CAH2r5mv0TzWpYi38HtuVG2gtYvW60-RDOri3a1FUUtprn19Dzw@mail.gmail.com>
 <87lfbyn647.fsf@suse.com>
 <CANT5p=qJjeVk1HDhvaiAQSYH3mj-rNBNA-j2TAUnoqQVTOQ_Ww@mail.gmail.com>
 <875z2yn0lx.fsf@suse.com>
 <CAKywueRoFL17DiMzmorZcd=OJvDY_8+P8WxGqKDx-tdnJrr_HQ@mail.gmail.com>
 <6aad7fc3-3c3f-848c-4d65-e5c7f1dd8107@talpey.com>
 <CANT5p=o4=uy8HV4L_nXfPUJ=bUO5Oyf8p6=Y7dY5PxsabHxJYQ@mail.gmail.com>
 <CAH2r5muAhJaVTkGnzgTKXhLKaEXocgSk-WOguA4KkZWb5rMraQ@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <fca12259-ba25-cf79-02af-1a91cfd06244@talpey.com>
Date:   Tue, 16 Feb 2021 15:48:38 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAH2r5muAhJaVTkGnzgTKXhLKaEXocgSk-WOguA4KkZWb5rMraQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfKvZEj3WQALaQKUfi80QN7phFq85cy1G+zW5dNPggAeoM/IOzxek7Yz7OVEEe9BDttSmrE/xs48utSChkInxdhAqkTndEulE8JjO+gNVLJKqDA+dyz8W
 xK2PxxPxBHekGyPpmhl/MNkRVavuP6aC+Bx7ztLdRM0Cu6neSbvpe2GWyOdu9nBscOSqmpUcAvCXXmxPbnMwdtDjVvaTMgf5/sDUjrY8FdrP09xqtHbXrxMS
 JVnZMPimdMOGV2rvizNXvxowd5GB/dOS4mx5AFGXBoBu0rYkYb6GXSjnqVyCTMg5qBjc4iQWw6oMoj84W1BAKR00fA38GSCGWyW+85Pmydr0buEnzSXLJgoI
 eLtocrp+
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2/16/2021 2:56 PM, Steve French wrote:
> On Tue, Feb 16, 2021 at 6:29 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>>
>> Hi Pavel,
>>
>> Thanks for the review.
>> As Tom pointed out, the server name is currently a field in
>> TCP_Session_Info struct.
>> We do store the struct sockaddr_storage, which I'm guessing holds the
>> IP address in binary format, and we could use that. And may need to
>> consider IPv4 vs IPv6 when we do it.
>> I'll submit that as a new patch later on.
>>
>> Hi Tom,
>>
>>> Including the transport type (TCP, RDMA...) and multichannel attributes
>>> (link speed, RSS count, ...) would be useful too.
>> Can you please clarify this for me?
>>  From what I can see from the code, RDMA connection DebugData is a
>> superset of TCP connection. The RDMA specific details get printed only
>> when server->rdma is set.

I would hope that the client would walk its list of connections and
report the local attributes such as source+destination addresses and
ports, along with the transport such as whether it's a TCP or RDMA
connection.

Here, for example (from your patch):

...cifs_dump_channel(struct seq_file *m, int i, struct cifs_chan *chan)
...
+	seq_printf(m, "\n\n\t\tChannel: %d ConnectionId: 0x%llx"
+		   "\n\t\tNumber of credits: %d Dialect 0x%x"
+		   "\n\t\tTCP status: %d Instance: %d"
+		   "\n\t\tLocal Users To Server: %d SecMode: 0x%x Req On Wire: %d"
+		   "\n\t\tIn Send: %d In MaxReq Wait: %d",
+		   i+1, server->conn_id,

I'd strongly suggest digging into the cifs->chan  and adding at least
some of the connection data.

In the second hunk, I believe that's only invoked if CONFIG_CIFS_SMB_DIRECT
is configured, and it doesn't have any of the actual connection
information either, although it does dump the rdma flag.

Bottom line, it seems to me that a more complete picture of
the endpoints would help a lot, especially when multichannel
allows multiple sockets, NICs, and protocols to be involved.

>> Regards,
>> Shyam
>>
>> On Thu, Feb 11, 2021 at 11:41 AM Tom Talpey <tom@talpey.com> wrote:
>>>
>>> On 2/11/2021 12:12 PM, Pavel Shilovsky wrote:
>>>> Hi Shyam,
>>>>
>>>> The output looks very informative! I have one comment:
>>>>
>>>> Servers:
>>>> 1) ConnectionId: 0x1
>>>> Number of credits: 326 Dialect 0x311
>>>> TCP status: 1 Instance: 1
>>>> Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0
>>>> In Send: 0 In MaxReq Wait: 0
>>>>
>>>> Sessions:
>>>> 1) Name: 10.229.158.38 Uses: 1 Capability: 0x300077 Session Status: 1
>>>>                        ^^^^
>>>> Isn't this name (or hostname) a property of the connection? I would
>>>> expect an IP or a hostname to be printed in the connection settings
>>>> above.
>>>
>>> The servername is a property of the session, in this case since the
>>> mount specified a dotted quad, it would correctly appear as the
>>> servername at this level.
>>>
>>> However, I definitely agree that an IP address is important in the
>>> per-connection (channel) stanzas. Multichannel, multihoming, witness
>>> redirects, and any number of things can vary among them. It would
>>> be useful indeed to display them.
>>>
>>> Including the transport type (TCP, RDMA...) and multichannel attributes
>>> (link speed, RSS count, ...) would be useful too.
> 
> It does show whether interface supports RSS or RDMA in the channel
> list for every session
> (and whether that interface is 'CONNECTED' for that session).  See
> below example from his
> sample /proc/fs/cifs/DebugData output (although this part did not
> change with his patch)
> 
> 4) Speed: 1000000000 bps
> Capabilities: rss
> IPv4: 10.229.158.38
> [CONNECTED]

Steve, I believe this list is just the server's response to the
multichannel FSCTL_QUERY_NETWORK_INTERFACE_INFO, which is an
enumeration of *available* server-side interfaces? This is useful,
but isn't helpful to determine which interfaces the client session
is actually using to each one, and from what client NIC ports,
protocols, etc. All it gives is a "CONNECTED" indication to a
single server port. To figure anything else out means groveling
through netstat and guessing at port 445's.

Tom.

> 
> Thanks,
> 
> Steve
> 
