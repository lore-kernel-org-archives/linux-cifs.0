Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05646EB64DA
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Jul 2023 14:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjGTOab (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 Jul 2023 10:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbjGTOaa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 Jul 2023 10:30:30 -0400
Received: from smtp.rcn.com (mail.rcn.syn-alias.com [129.213.13.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638691BF7
        for <linux-cifs@vger.kernel.org>; Thu, 20 Jul 2023 07:30:29 -0700 (PDT)
X-Authed-Username: dG10YWxwZXlAcmNuLmNvbQ==
Authentication-Results:  smtp01.rcn.email-ash1.sync.lan smtp.user=<hidden>; auth=pass (PLAIN)
Received: from [96.237.161.173] ([96.237.161.173:51688] helo=[192.168.0.206])
        by smtp.rcn.com (envelope-from <tom@talpey.com>)
        (ecelerity 4.4.0.19839 r(msys-ecelerity:tags/4.4.0.0^0)) with ESMTPSA (cipher=AES128-GCM-SHA256) 
        id 0E/94-05333-40549B46; Thu, 20 Jul 2023 10:30:28 -0400
Message-ID: <d14f85d1-ff05-94da-24bb-6a1e1afe29f6@talpey.com>
Date:   Thu, 20 Jul 2023 10:30:27 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: Potential leak in file put
Content-Language: en-US
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Bharath SM <bharathsm.hsk@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>,
        Enzo Matsumiya <ematsumiya@suse.de>
References: <CANT5p=po=GSwj+bD_-uFWZ0r_ww5XbaV1pAauZecbmuzShmcpw@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CANT5p=po=GSwj+bD_-uFWZ0r_ww5XbaV1pAauZecbmuzShmcpw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Vade-Verdict: clean
X-Vade-Analysis-1: gggruggvucftvghtrhhoucdtuddrgedviedrhedtgdejiecutefuodetggdotefrodftvfcurfhrohhf
X-Vade-Analysis-2: ihhlvgemucfujgfpteevqfftpdftvefppdfgpfggqdftvefppdfqfgfvnecuuegrihhlohhuthemucef
X-Vade-Analysis-3: tddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfhfhfgjtgfg
X-Vade-Analysis-4: sehtjeertddtfeejnecuhfhrohhmpefvohhmucfvrghlphgvhicuoehtohhmsehtrghlphgvhidrtgho
X-Vade-Analysis-5: mheqnecuggftrfgrthhtvghrnhepgeffieefveeghffgjeelhfdvudfgtdeigfehudeggfffleeghfef
X-Vade-Analysis-6: ffdukedvgefgnecukfhppeeliedrvdefjedrudeiuddrudejfeenucevlhhushhtvghrufhiiigvpedt
X-Vade-Analysis-7: necurfgrrhgrmhepihhnvghtpeeliedrvdefjedrudeiuddrudejfedphhgvlhhopegludelvddrudei
X-Vade-Analysis-8: kedrtddrvddtiegnpdhmrghilhhfrhhomhepthhomhesthgrlhhpvgihrdgtohhmpdhrtghpthhtohep
X-Vade-Analysis-9: nhhsphhmrghnghgrlhhorhgvsehgmhgrihhlrdgtohhmpdhrtghpthhtoheplhhinhhugidqtghifhhs
X-Vade-Analysis-10: sehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhmfhhrvghntghhsehgmhgrihhlrdgt
X-Vade-Analysis-11: ohhmpdhrtghpthhtoheprhhonhhnihgvshgrhhhlsggvrhhgsehgmhgrihhlrdgtohhmpdhrtghpthht
X-Vade-Analysis-12: ohepsghhrghrrghthhhsmhdrhhhskhesghhmrghilhdrtghomhdprhgtphhtthhopehptgestghjrhdr
X-Vade-Analysis-13: nhiipdhrtghpthhtohepvghmrghtshhumhhihigrsehsuhhsvgdruggv
X-Vade-Client: RCN
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 7/19/2023 8:10 AM, Shyam Prasad N wrote:
> Hi all,
> 
> cifs.ko seems to be leaking handles occasionally when put under some
> stress testing.
> I was scanning the code for potential places where we could be
> leaking, and one particular instance caught my attention.
> 
> In _cifsFileInfo_put, when the ref count of a cifs_file reaches 0, we
> remove it from the lists and then send the close request over the
> wire...
>          if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
>                  struct TCP_Server_Info *server = tcon->ses->server;
>                  unsigned int xid;
> 
>                  xid = get_xid();
>                  if (server->ops->close_getattr)
>                          server->ops->close_getattr(xid, tcon, cifs_file);
>                  else if (server->ops->close)
>                          server->ops->close(xid, tcon, &cifs_file->fid);
>                  _free_xid(xid);
>          }
> 
> But as you can see above, we do not have return value from the above handlers.

Yeah, that's a problem. The most obvious is if the network becomes
partitioned and the close(s) fail. Are you injecting that kind of
error?

Still, the logic is going to grow some serious hair if we start
retrying every error. What will bound the retries, and what kind
of error(s) might be considered fatal? Tying up credits, message
id's, handles, etc can be super problematic.

Also, have you considered using some sort of laundromat? Or is it
critical that these closes happen before proceeding?

Tom.

> What would happen if the above close_getattr or close calls fail?
> Particularly, what would happen if the failure happens even before the
> request is put in flight?
> In this stress testing we have the server giving out lesser credits.
> So with the testing, the credit counters on the active connections are
> expected to be low in general.
> I'm assuming that the above condition will leak handles.
> 
> I was thinking about making a change to let the above handlers return
> rc rather than void. And then to check the status.
> If failure, create a delayed work for closing the remote handle. But
> I'm not convinced that this is the right approach.
> I'd like to know more comments on this.
> 
