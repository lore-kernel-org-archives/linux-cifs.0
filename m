Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83427EB64DA
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Jul 2023 14:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbjGTOct (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 Jul 2023 10:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjGTOcs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 Jul 2023 10:32:48 -0400
Received: from smtp.rcn.com (mail.rcn.syn-alias.com [129.213.13.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54358C6
        for <linux-cifs@vger.kernel.org>; Thu, 20 Jul 2023 07:32:47 -0700 (PDT)
X-Authed-Username: dG10YWxwZXlAcmNuLmNvbQ==
Authentication-Results:  smtp02.rcn.email-ash1.sync.lan smtp.user=<hidden>; auth=pass (PLAIN)
Received: from [96.237.161.173] ([96.237.161.173:51691] helo=[192.168.0.206])
        by smtp.rcn.com (envelope-from <tom@talpey.com>)
        (ecelerity 4.4.0.19839 r(msys-ecelerity:tags/4.4.0.0^0)) with ESMTPSA (cipher=AES128-GCM-SHA256) 
        id D2/A7-10976-E8549B46; Thu, 20 Jul 2023 10:32:46 -0400
Message-ID: <8ad596bd-92f0-8ea5-95d6-e33a72228de8@talpey.com>
Date:   Thu, 20 Jul 2023 10:32:46 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2] cifs: fix charset issue in reconnection
Content-Language: en-US
To:     Winston Wen <wentao@uniontech.com>,
        Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org, pc@manguebit.com, lsahlber@redhat.com,
        sprasad@microsoft.com
References: <20230718012437.1841868-1-wentao@uniontech.com>
 <CAH2r5mvPXwc4H_7bkcF_oqedLrKTSv4GKBhYkpYC9=H==d-G3g@mail.gmail.com>
 <0559DC08D92C076E+20230719123117.692feb89@winn-pc>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <0559DC08D92C076E+20230719123117.692feb89@winn-pc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Vade-Verdict: clean
X-Vade-Analysis-1: gggruggvucftvghtrhhoucdtuddrgedviedrhedtgdejjecutefuodetggdotefrodftvfcurfhrohhf
X-Vade-Analysis-2: ihhlvgemucfujgfpteevqfftpdftvefppdfgpfggqdftvefppdfqfgfvnecuuegrihhlohhuthemucef
X-Vade-Analysis-3: tddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggt
X-Vade-Analysis-4: gfesthekredttdefjeenucfhrhhomhepvfhomhcuvfgrlhhpvgihuceothhomhesthgrlhhpvgihrdgt
X-Vade-Analysis-5: ohhmqeenucggtffrrghtthgvrhhnpeduudekheehfedthfetjeffudfgkefgleduueeggffhteffuedv
X-Vade-Analysis-6: keetvdefhfeljeenucfkphepleeirddvfeejrdduiedurddujeefnecuvehluhhsthgvrhfuihiivgep
X-Vade-Analysis-7: tdenucfrrghrrghmpehinhgvthepleeirddvfeejrdduiedurddujeefpdhhvghloheplgduledvrddu
X-Vade-Analysis-8: ieekrddtrddvtdeingdpmhgrihhlfhhrohhmpehtohhmsehtrghlphgvhidrtghomhdprhgtphhtthho
X-Vade-Analysis-9: peifvghnthgrohesuhhnihhonhhtvggthhdrtghomhdprhgtphhtthhopehsmhhfrhgvnhgthhesghhm
X-Vade-Analysis-10: rghilhdrtghomhdprhgtphhtthhopehlihhnuhigqdgtihhfshesvhhgvghrrdhkvghrnhgvlhdrohhr
X-Vade-Analysis-11: ghdprhgtphhtthhopehptgesmhgrnhhguhgvsghithdrtghomhdprhgtphhtthhopehlshgrhhhlsggv
X-Vade-Analysis-12: rhesrhgvughhrghtrdgtohhmpdhrtghpthhtohepshhprhgrshgrugesmhhitghrohhsohhfthdrtgho
X-Vade-Analysis-13: mhdpmhhtrghhohhsthepshhmthhptddvrdhrtghnrdgvmhgrihhlqdgrshhhuddrshihnhgtrdhlrghn
X-Vade-Client: RCN
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 7/19/2023 12:31 AM, Winston Wen wrote:
> On Tue, 18 Jul 2023 10:42:27 -0500
> Steve French <smfrench@gmail.com> wrote:
> 
>> I get compile warning:
>>
>> /home/smfrench/cifs-2.6/fs/smb/client/connect.c: In function
>> ‘cifs_get_smb_ses’:
>> /home/smfrench/cifs-2.6/fs/smb/client/connect.c:2293:49: warning:
>> passing argument 1 of ‘load_nls’ discards ‘const’ qualifier from
>> pointer target type [-Wdiscarded-qualifiers]
> 
> 
>>   2293 |         ses->local_nls = load_nls(ctx->local_nls->charset);
> 
> Hi Steve,
> 
> Sorry about the mistake I made. I updated the patch with a very small
> change:
> 
> 	ses->local_nls = load_nls((char *)ctx->local_nls->charset);

I don't like this approach. Removing a const via casting is not
a good idea. It invites write faults or outright bugs down
the call stack.

Why is the charset not const itself?

Tom.

> It works, but I'm not sure whether it's clean enough.
> 
> Perhaps I should make a change to load_nls() to take a const char *
> instead of char *? If this make sense, I'll do it soon.
> 
> Find the updated patch as attachment.
> 
