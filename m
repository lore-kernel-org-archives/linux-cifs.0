Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C560C0015E
	for <linux-cifs@archiver.kernel.org>; Fri, 21 Jul 2023 13:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbjGUNje (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 Jul 2023 09:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjGUNjb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 21 Jul 2023 09:39:31 -0400
Received: from smtp.rcn.com (mail.rcn.syn-alias.com [129.213.13.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D830E1722
        for <linux-cifs@vger.kernel.org>; Fri, 21 Jul 2023 06:39:29 -0700 (PDT)
X-Authed-Username: dG10YWxwZXlAcmNuLmNvbQ==
Authentication-Results:  smtp02.rcn.email-ash1.sync.lan smtp.user=<hidden>; auth=pass (PLAIN)
Received: from [96.237.161.173] ([96.237.161.173:53715] helo=[192.168.0.206])
        by smtp.rcn.com (envelope-from <tom@talpey.com>)
        (ecelerity 4.4.0.19839 r(msys-ecelerity:tags/4.4.0.0^0)) with ESMTPSA (cipher=AES128-GCM-SHA256) 
        id C9/7A-10976-09A8AB46; Fri, 21 Jul 2023 09:39:29 -0400
Message-ID: <2515b155-ad0e-a147-b174-21bd25619a06@talpey.com>
Date:   Fri, 21 Jul 2023 09:39:30 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: Potential leak in file put
Content-Language: en-US
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Bharath SM <bharathsm.hsk@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>,
        Enzo Matsumiya <ematsumiya@suse.de>
References: <CANT5p=po=GSwj+bD_-uFWZ0r_ww5XbaV1pAauZecbmuzShmcpw@mail.gmail.com>
 <d14f85d1-ff05-94da-24bb-6a1e1afe29f6@talpey.com>
 <CANT5p=omTgEfjiXcpWjhg7h8GcBwGa7jOqHyjc5OmaeHQtMPEg@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CANT5p=omTgEfjiXcpWjhg7h8GcBwGa7jOqHyjc5OmaeHQtMPEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Vade-Verdict: clean
X-Vade-Analysis-1: gggruggvucftvghtrhhoucdtuddrgedviedrhedvgdeifecutefuodetggdotefrodftvfcurfhrohhf
X-Vade-Analysis-2: ihhlvgemucfujgfpteevqfftpdftvefppdfgpfggqdftvefppdfqfgfvnecuuegrihhlohhuthemucef
X-Vade-Analysis-3: tddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggt
X-Vade-Analysis-4: gfesthekredttdefjeenucfhrhhomhepvfhomhcuvfgrlhhpvgihuceothhomhesthgrlhhpvgihrdgt
X-Vade-Analysis-5: ohhmqeenucggtffrrghtthgvrhhnpeduudekheehfedthfetjeffudfgkefgleduueeggffhteffuedv
X-Vade-Analysis-6: keetvdefhfeljeenucfkphepleeirddvfeejrdduiedurddujeefnecuvehluhhsthgvrhfuihiivgep
X-Vade-Analysis-7: tdenucfrrghrrghmpehinhgvthepleeirddvfeejrdduiedurddujeefpdhhvghloheplgduledvrddu
X-Vade-Analysis-8: ieekrddtrddvtdeingdpmhgrihhlfhhrohhmpehtohhmsehtrghlphgvhidrtghomhdprhgtphhtthho
X-Vade-Analysis-9: pehnshhpmhgrnhhgrghlohhrvgesghhmrghilhdrtghomhdprhgtphhtthhopehlihhnuhigqdgtihhf
X-Vade-Analysis-10: shesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehsmhhfrhgvnhgthhesghhmrghilhdr
X-Vade-Analysis-11: tghomhdprhgtphhtthhopehrohhnnhhivghsrghhlhgsvghrghesghhmrghilhdrtghomhdprhgtphht
X-Vade-Analysis-12: thhopegshhgrrhgrthhhshhmrdhhshhksehgmhgrihhlrdgtohhmpdhrtghpthhtohepphgtsegtjhhr
X-Vade-Analysis-13: rdhniidprhgtphhtthhopegvmhgrthhsuhhmihihrgesshhushgvrdguvg
X-Vade-Client: RCN
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 7/21/2023 7:13 AM, Shyam Prasad N wrote:
> Hi Tom,
> 
> Thanks for these points.
> 
> On Thu, Jul 20, 2023 at 8:21 PM Tom Talpey <tom@talpey.com> wrote:
>>
>> On 7/19/2023 8:10 AM, Shyam Prasad N wrote:
>>> Hi all,
>>>
>>> cifs.ko seems to be leaking handles occasionally when put under some
>>> stress testing.
>>> I was scanning the code for potential places where we could be
>>> leaking, and one particular instance caught my attention.
>>>
>>> In _cifsFileInfo_put, when the ref count of a cifs_file reaches 0, we
>>> remove it from the lists and then send the close request over the
>>> wire...
>>>           if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
>>>                   struct TCP_Server_Info *server = tcon->ses->server;
>>>                   unsigned int xid;
>>>
>>>                   xid = get_xid();
>>>                   if (server->ops->close_getattr)
>>>                           server->ops->close_getattr(xid, tcon, cifs_file);
>>>                   else if (server->ops->close)
>>>                           server->ops->close(xid, tcon, &cifs_file->fid);
>>>                   _free_xid(xid);
>>>           }
>>>
>>> But as you can see above, we do not have return value from the above handlers.
>>
>> Yeah, that's a problem. The most obvious is if the network becomes
>> partitioned and the close(s) fail. Are you injecting that kind of
>> error?
> 
> So this was revealed with a stress testing setup where the mount was
> done against a server that gave out only 512 credits per connection.
> The connection was pretty much starved for credits, which threw up
> out-of-credits errors occasionally.
> I've confirmed that when it happens for close, there are handle leaks.

Interesting. 512 credits doesn't seem like starvation, but it will
definitely stress a high workload. Good!

>> Still, the logic is going to grow some serious hair if we start
>> retrying every error. What will bound the retries, and what kind
>> of error(s) might be considered fatal? Tying up credits, message
>> id's, handles, etc can be super problematic.
>>
>> Also, have you considered using some sort of laundromat? Or is it
>> critical that these closes happen before proceeding?
>>
> 
> Steve and I discussed this yesterday. One option that came out was...
> We could cleanup the handle locally and then keep retrying the server
> close as a delayed work a fixed number of times.
> If a specified limit is exceeded, reconnect the session so that we start afresh.

Sounds reasonable, but things might get a little tricky if the
server-side handle has a lease or some other state still attached.
A subsequent client create on the same file might encounter an
unexpected conflict? It's critical to think that through.

> I guess this is what you meant by laundromat?

So by laundromat I meant background processing to handle the
close. It would have some sort of queued work list, and it
would process the work items and wash-dry-fold the results.

The main motivation would be to release the thread that fell
into the refcnt == 0 so the calling application may continue.
Stealing the thread for a full server roundtrip might be
worth avoiding, in all cases.

OTOH, if the tricky stuff above is risky or wrong, then forget
the laundromat and don't return until the close is done. But
then, think about ^C!

Tom.

>>> What would happen if the above close_getattr or close calls fail?
>>> Particularly, what would happen if the failure happens even before the
>>> request is put in flight?
>>> In this stress testing we have the server giving out lesser credits.
>>> So with the testing, the credit counters on the active connections are
>>> expected to be low in general.
>>> I'm assuming that the above condition will leak handles.
>>>
>>> I was thinking about making a change to let the above handlers return
>>> rc rather than void. And then to check the status.
>>> If failure, create a delayed work for closing the remote handle. But
>>> I'm not convinced that this is the right approach.
>>> I'd like to know more comments on this.
>>>
> 
> 
> 
