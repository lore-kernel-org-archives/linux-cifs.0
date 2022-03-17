Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAE2FC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Mar 2022 16:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbiCQQ6p (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Mar 2022 12:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236210AbiCQQ6p (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Mar 2022 12:58:45 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC591FA54
        for <linux-cifs@vger.kernel.org>; Thu, 17 Mar 2022 09:57:27 -0700 (PDT)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nUtRF-0005yT-O9; Thu, 17 Mar 2022 17:57:25 +0100
Message-ID: <5a951b61-41b7-91b5-b774-75314df190c8@leemhuis.info>
Date:   Thu, 17 Mar 2022 17:57:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH][SMB3] fix multiuser mount regression
Content-Language: en-US
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Satadru Pramanik <satadru@gmail.com>
References: <CAH2r5mth2fYLzU5+oN09ipT7peRdyAiPCF-7_fLPsTpA-fKKLA@mail.gmail.com>
 <CAN05THRxcqQ7SSjC3xetcJZnYNUXkhpmO7tW8fzZTrMnRrDMzw@mail.gmail.com>
 <CANT5p=oKgNJn7Dn0BDCbF28V+zKE9w8dgL0-Ra1fafKdjKHYaA@mail.gmail.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <CANT5p=oKgNJn7Dn0BDCbF28V+zKE9w8dgL0-Ra1fafKdjKHYaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1647536247;e04a5958;
X-HE-SMSGID: 1nUtRF-0005yT-O9
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 17.03.22 16:47, Shyam Prasad N wrote:
> I looked at this problem in more detail.

Thx. Is that patch something Satadru should test to see if it fixes his
regression?
https://lore.kernel.org/linux-cifs/CAFrh3J9soC36%2BBVuwHB=g9z_KB5Og2%2Bp2_W%2BBBoBOZveErz14w@mail.gmail.com/

And if it does, out of curiosity: Is the patch considered to be too
invasive for 5.17 as the final is just a few days away?

Ciao, Thorsten

> Here's a summary of what happened:
> Before my recent changes, when mchan was used, and a
> negotiate/sess-setup happened, all other channels were paused. So
> things were a lot simpler during a connect/reconnect.
> What I did with my recent changes is to allow I/O to flow in other
> channels when connect/reconnect happened on one of the channels. This
> meant that there could be multiple channels that do negotiate/session
> setup for the same session in parallel. i.e. first channel would
> create a new session. Other channels would bind to the same session.
> This meant that the server->tcpStatus needed to indicate an ongoing
> sess setup. So that multiple channels could do session setup in
> parallel.
> Unfortunately, I did not account for multiuser scenario, which does
> the reverse. i.e. uses the same server for different tcp sessions.
> 
> Here's a patch I propose to fix this issue. Please review and let me
> know what you think.
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/34333e9de1526c46e9ae5ff9a54f0199b827fd0e.patch
> 
> Essentially, I'm doing 3 changes in this patch:
> 1. Making sure that tcpStatus is only till the end of tcp connection
> establishment. This means that tcpStatus reaches CifsGood when the tcp
> connection is good
> 2. Once cifs_negotiate_protocol starts, anything done will affect the
> session state, and should not modify tcpStatus.
> 3. To detect the small window between tcp connection setup and before
> negotiate, use need_neg()
> 
> On Thu, Mar 17, 2022 at 9:14 AM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
>>
>> On Thu, Mar 17, 2022 at 1:20 PM Steve French <smfrench@gmail.com> wrote:
>>>
>>> cifssmb3: fix incorrect session setup check for multiuser mounts
>>
>> If it fixes multiuser then Acked-by me.
>> We are so close to rc8 that we can not do intrusive changes,   so if
>> it fixes it short term.
>> For longer term, post rc8 we need to rewrite the statemaching completely
>> and separate out "what happens in server->tcpStatus" as one statemachine and
>> "what happens in server->status" as a separate one. Right now it is a mess.
>>
>>
>>>
>>> A recent change to how the SMB3 server (socket) and session status
>>> is managed regressed multiuser mounts by changing the check
>>> for whether session setup is needed to the socket (TCP_Server_info)
>>> structure instead of the session struct (cifs_ses). Add additional
>>> check in cifs_setup_sesion to fix this.
>>>
>>> Fixes: 73f9bfbe3d81 ("cifs: maintain a state machine for tcp/smb/tcon sessions")
>>> Reported-by: Ronnie Sahlberg <lsahlber@redhat.com>
>>> Signed-off-by: Steve French <stfrench@microsoft.com>
>>> ---
>>>  fs/cifs/connect.c | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>>> index 053cb449eb16..d3020abfe404 100644
>>> --- a/fs/cifs/connect.c
>>> +++ b/fs/cifs/connect.c
>>> @@ -3924,7 +3924,8 @@ cifs_setup_session(const unsigned int xid,
>>> struct cifs_ses *ses,
>>>
>>>   /* only send once per connect */
>>>   spin_lock(&cifs_tcp_ses_lock);
>>> - if (server->tcpStatus != CifsNeedSessSetup) {
>>> + if ((server->tcpStatus != CifsNeedSessSetup) &&
>>> +     (ses->status == CifsGood)) {
>>>   spin_unlock(&cifs_tcp_ses_lock);
>>>   return 0;
>>>   }
>>>
>>> --
>>> Thanks,
>>>
>>> Steve
> 
> 
> 
