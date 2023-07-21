Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A830EB64DA
	for <linux-cifs@archiver.kernel.org>; Fri, 21 Jul 2023 00:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjGUAA2 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 Jul 2023 20:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjGUAA2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 Jul 2023 20:00:28 -0400
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFAC1BD
        for <linux-cifs@vger.kernel.org>; Thu, 20 Jul 2023 17:00:25 -0700 (PDT)
X-QQ-mid: bizesmtp91t1689897619tjsemlb1
Received: from winn-pc ( [113.57.152.160])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 21 Jul 2023 08:00:18 +0800 (CST)
X-QQ-SSF: 00400000000000F0H000000A0000000
X-QQ-FEAT: 3M0okmaRx3hGyXXthpQW+QxQ5V34pNas6Ct8ac8f8stO7fFW8tI4zyr/gAmO1
        uqvm8sQ/57kty41fVpfK2itf0pLHM6bUlU69CIihfEuTGCaEYXELbVRWtDIkx5K242Bm1yi
        +tjKwtUdScKuLzN1l+qwOB26i9I6DlZHWVKTZ9NFrWXea5hLf2ZAIRXqDIeRLfxr3Bs8Fun
        a0rL127VZmREpQP+XIbqHXgvpLLuFMFjI7xrhPYpHvo+nIUecN0IpzhWr8Y3+j8TJzVa2Yp
        TdAuSTjmVvyIQnzcWwxPSQutNeqlzf2smnbZh04j+/sWgqjVYD/mMpPHZxadsaItiB7A5SH
        eW8KV0WJkqhaNtmqSSsEJvLnizyHHz0gheC/nc1IUEiVKH7MR696QxQa2v03A==
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14834240228054311406
Date:   Fri, 21 Jul 2023 08:00:17 +0800
From:   Winston Wen <wentao@uniontech.com>
To:     Tom Talpey <tom@talpey.com>
Cc:     Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
        pc@manguebit.com, lsahlber@redhat.com, sprasad@microsoft.com
Subject: Re: [PATCH v2] cifs: fix charset issue in reconnection
Message-ID: <76B7BCAF731C0C27+20230721080017.07569feb@winn-pc>
In-Reply-To: <8ad596bd-92f0-8ea5-95d6-e33a72228de8@talpey.com>
References: <20230718012437.1841868-1-wentao@uniontech.com>
        <CAH2r5mvPXwc4H_7bkcF_oqedLrKTSv4GKBhYkpYC9=H==d-G3g@mail.gmail.com>
        <0559DC08D92C076E+20230719123117.692feb89@winn-pc>
        <8ad596bd-92f0-8ea5-95d6-e33a72228de8@talpey.com>
Organization: Uniontech
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6a-1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, 20 Jul 2023 10:32:46 -0400
Tom Talpey <tom@talpey.com> wrote:

> On 7/19/2023 12:31 AM, Winston Wen wrote:
> > On Tue, 18 Jul 2023 10:42:27 -0500
> > Steve French <smfrench@gmail.com> wrote:
> >   
> >> I get compile warning:
> >>
> >> /home/smfrench/cifs-2.6/fs/smb/client/connect.c: In function
> >> ‘cifs_get_smb_ses’:
> >> /home/smfrench/cifs-2.6/fs/smb/client/connect.c:2293:49: warning:
> >> passing argument 1 of ‘load_nls’ discards ‘const’ qualifier from
> >> pointer target type [-Wdiscarded-qualifiers]  
> > 
> >   
> >>   2293 |         ses->local_nls =
> >> load_nls(ctx->local_nls->charset);  
> > 
> > Hi Steve,
> > 
> > Sorry about the mistake I made. I updated the patch with a very
> > small change:
> > 
> > 	ses->local_nls = load_nls((char *)ctx->local_nls->charset);
> >  
> 
> I don't like this approach. Removing a const via casting is not
> a good idea. It invites write faults or outright bugs down
> the call stack.

Agreed, I've sent a patch that make load_nls() take a const parameter,
so we don't need to do the cast any more:

https://lore.kernel.org/linux-cifs/20230720063414.2546451-1-wentao@uniontech.com/T/#u

> 
> Why is the charset not const itself?
> 
> Tom.
> 
> > It works, but I'm not sure whether it's clean enough.
> > 
> > Perhaps I should make a change to load_nls() to take a const char *
> > instead of char *? If this make sense, I'll do it soon.
> > 
> > Find the updated patch as attachment.
> >   
> 



-- 
Thanks,
Winston

