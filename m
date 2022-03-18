Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74E2CC433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Mar 2022 14:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235765AbiCROUw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Mar 2022 10:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbiCROUv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 18 Mar 2022 10:20:51 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398F3C1CAB
        for <linux-cifs@vger.kernel.org>; Fri, 18 Mar 2022 07:19:32 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id bi12so17363895ejb.3
        for <linux-cifs@vger.kernel.org>; Fri, 18 Mar 2022 07:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hE+UXlKQS4TF9ko9KvUX5h01fQR5X7ELan+BT4Rdznc=;
        b=aHpVKBOsyQiGfR50e9+Rlrpxhm4Xhx5vMXnuBURt6Pb9Oi4bjhRieBiVCBx3Yp4NLc
         9L6n3ud7a/WOoWjqjFA2RzhMiOm6toS77tXlzvf9IfuGE9o0Ik+7LQ5FpMVXMxlbuujR
         pEJyVhdu771wfBY67xk/Q0kQ1vYCMdVDvd7jo6SaU75T2G5+TreUKh+1rpuBS/tbxW6l
         gK8EMCTwDk7biP+HpOTOz8MzEWxIuxPD7rzQYp8zvtcEWdQqibELIwbofLt+15Gx0xjt
         RcmyBtvYe+BMD5Tnz3xWIWdrqV8/F4mPCSuXFWZRINn6iBX6WDr1ty1s+UnY67ObJ+jW
         NC/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hE+UXlKQS4TF9ko9KvUX5h01fQR5X7ELan+BT4Rdznc=;
        b=2ZN3FoGRvLzc35ddXqiD1QFJ2d5fhzN24c3QKn1xrntRmYOO5w2DzaNzBOIQrfcTvO
         xpJLPjkF0dkwwNgmvaXXa9QCoz7yXt9ym9UjBrIKD5P05nFwICJWY6IHX06aXQWRtPR1
         jXOwIRUspQuvELuVtdlCQ6z8Af8TI20K2gwCQb/Ztrm5dO8KGjF5iKiInDz1A+6HPgp9
         lGGJ0zeL8fPH6u9A5hdrNytUxPzRv46k/NkTXFrvghQU4Nwk6dnMfE2spn2mxWHx4U4i
         Z29rnfzYwz9i+JhP7PHhYMJyw3Ee7bXosHFqzZ9paJO8NdgT/CxJCEjRIev71rz8+Dgl
         DDew==
X-Gm-Message-State: AOAM530cRlf8+02PlhO0BT0kVCF2+34sQxjSJz5YDXBRaTtP5ajlUBvX
        RQLE4sphcWZpBHWq9b/YXVvDhFATkBSlTmG5xVw=
X-Google-Smtp-Source: ABdhPJzzDgeNPTG/nkaOg6CCYFfc5hMCldGvJPv0nCXWFWRcavdOkI/IHT9/r4NdcL1HH+3Tm8spIvRaOV8zzCr7KgA=
X-Received: by 2002:a17:907:c1d:b0:6db:67b:a3cc with SMTP id
 ga29-20020a1709070c1d00b006db067ba3ccmr9145979ejc.356.1647613170488; Fri, 18
 Mar 2022 07:19:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mth2fYLzU5+oN09ipT7peRdyAiPCF-7_fLPsTpA-fKKLA@mail.gmail.com>
 <CAN05THRxcqQ7SSjC3xetcJZnYNUXkhpmO7tW8fzZTrMnRrDMzw@mail.gmail.com>
 <CANT5p=oKgNJn7Dn0BDCbF28V+zKE9w8dgL0-Ra1fafKdjKHYaA@mail.gmail.com>
 <5a951b61-41b7-91b5-b774-75314df190c8@leemhuis.info> <CAH2r5mtxg-HZTDSfPbWBT3FxnQq2F6Jq9uz7o1wJmjPPRBNcdw@mail.gmail.com>
 <CAFrh3J8c8rF76+iJJkXzdFn8EbWX30AYbfAinzcJL1SKXgK3CQ@mail.gmail.com>
In-Reply-To: <CAFrh3J8c8rF76+iJJkXzdFn8EbWX30AYbfAinzcJL1SKXgK3CQ@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 18 Mar 2022 19:49:19 +0530
Message-ID: <CANT5p=rkZMhzTd8n74+Vh22qE11B_Mti5YEscGvpEf25Q39P_A@mail.gmail.com>
Subject: Re: [PATCH][SMB3] fix multiuser mount regression
To:     Satadru Pramanik <satadru@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

As discussed in the other email thread that Satadru started, I feel
that these two (multiuser regression and the sleep/resume issue) are
different issues.
Let's continue the discussion on that one in the dedicated email thread.

As for the multiuser regression, here's a slightly updated version of
my last patch here.
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/9bc6cde4609c98cf53a5f3e0462c68708dbb54b7.patch

Steve, I leave it upto you whether you want to take for 5.17 or 5.18-rc1.
For 5.18-rc1, I'll have another patch on top of this one that should
fix parallel reconnects for multichannel for good. (I'm planning to
split up session status to individual channels there).

Regards,
Shyam

On Thu, Mar 17, 2022 at 10:59 PM Satadru Pramanik <satadru@gmail.com> wrote:
>
> Neither the one line patch nor the longer patch solve the issue.
>
> Dmesg is attached from booting up with a kernel built with the longer
> patch. It covers sleeping, rebooting server, noticing cifs mount is
> broken, unmounting and remounting the cifs mount, putting the laptop
> to sleep again, rebooting the server, waking the laptop, and noticing
> the mount is broken again.
>
>
> On Thu, Mar 17, 2022 at 1:01 PM Steve French <smfrench@gmail.com> wrote:
> >
> > > And if it does, out of curiosity: Is the patch considered to be too
> > invasive for 5.17
> >
> > Good question - I am testing it right now and weighing the option of
> > the one line patch which fixes at least one of the problems, vs. the
> > longer patch (about 50 lines of code IIRC) of Shyam's that I am
> > testing now.    We will defer the larger changes Ronnie, Shyam and I
> > have discussed to make the state machine more readable/understandable
> > (and less likely to run into this in the future by changing the state
> > names in the enum) for the three structures (server socket we are
> > connected to, authenticated user session, tree connect for the share
> > we have mounted)
> >
> > On Thu, Mar 17, 2022 at 11:57 AM Thorsten Leemhuis
> > <regressions@leemhuis.info> wrote:
> > >
> > > On 17.03.22 16:47, Shyam Prasad N wrote:
> > > > I looked at this problem in more detail.
> > >
> > > Thx. Is that patch something Satadru should test to see if it fixes his
> > > regression?
> > > https://lore.kernel.org/linux-cifs/CAFrh3J9soC36%2BBVuwHB=g9z_KB5Og2%2Bp2_W%2BBBoBOZveErz14w@mail.gmail.com/
> > >
> > > And if it does, out of curiosity: Is the patch considered to be too
> > > invasive for 5.17 as the final is just a few days away?
> > >
> > > Ciao, Thorsten
> > >
> > > > Here's a summary of what happened:
> > > > Before my recent changes, when mchan was used, and a
> > > > negotiate/sess-setup happened, all other channels were paused. So
> > > > things were a lot simpler during a connect/reconnect.
> > > > What I did with my recent changes is to allow I/O to flow in other
> > > > channels when connect/reconnect happened on one of the channels. This
> > > > meant that there could be multiple channels that do negotiate/session
> > > > setup for the same session in parallel. i.e. first channel would
> > > > create a new session. Other channels would bind to the same session.
> > > > This meant that the server->tcpStatus needed to indicate an ongoing
> > > > sess setup. So that multiple channels could do session setup in
> > > > parallel.
> > > > Unfortunately, I did not account for multiuser scenario, which does
> > > > the reverse. i.e. uses the same server for different tcp sessions.
> > > >
> > > > Here's a patch I propose to fix this issue. Please review and let me
> > > > know what you think.
> > > > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/34333e9de1526c46e9ae5ff9a54f0199b827fd0e.patch
> > > >
> > > > Essentially, I'm doing 3 changes in this patch:
> > > > 1. Making sure that tcpStatus is only till the end of tcp connection
> > > > establishment. This means that tcpStatus reaches CifsGood when the tcp
> > > > connection is good
> > > > 2. Once cifs_negotiate_protocol starts, anything done will affect the
> > > > session state, and should not modify tcpStatus.
> > > > 3. To detect the small window between tcp connection setup and before
> > > > negotiate, use need_neg()
> > > >
> > > > On Thu, Mar 17, 2022 at 9:14 AM ronnie sahlberg
> > > > <ronniesahlberg@gmail.com> wrote:
> > > >>
> > > >> On Thu, Mar 17, 2022 at 1:20 PM Steve French <smfrench@gmail.com> wrote:
> > > >>>
> > > >>> cifssmb3: fix incorrect session setup check for multiuser mounts
> > > >>
> > > >> If it fixes multiuser then Acked-by me.
> > > >> We are so close to rc8 that we can not do intrusive changes,   so if
> > > >> it fixes it short term.
> > > >> For longer term, post rc8 we need to rewrite the statemaching completely
> > > >> and separate out "what happens in server->tcpStatus" as one statemachine and
> > > >> "what happens in server->status" as a separate one. Right now it is a mess.
> > > >>
> > > >>
> > > >>>
> > > >>> A recent change to how the SMB3 server (socket) and session status
> > > >>> is managed regressed multiuser mounts by changing the check
> > > >>> for whether session setup is needed to the socket (TCP_Server_info)
> > > >>> structure instead of the session struct (cifs_ses). Add additional
> > > >>> check in cifs_setup_sesion to fix this.
> > > >>>
> > > >>> Fixes: 73f9bfbe3d81 ("cifs: maintain a state machine for tcp/smb/tcon sessions")
> > > >>> Reported-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > >>> Signed-off-by: Steve French <stfrench@microsoft.com>
> > > >>> ---
> > > >>>  fs/cifs/connect.c | 3 ++-
> > > >>>  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >>>
> > > >>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > > >>> index 053cb449eb16..d3020abfe404 100644
> > > >>> --- a/fs/cifs/connect.c
> > > >>> +++ b/fs/cifs/connect.c
> > > >>> @@ -3924,7 +3924,8 @@ cifs_setup_session(const unsigned int xid,
> > > >>> struct cifs_ses *ses,
> > > >>>
> > > >>>   /* only send once per connect */
> > > >>>   spin_lock(&cifs_tcp_ses_lock);
> > > >>> - if (server->tcpStatus != CifsNeedSessSetup) {
> > > >>> + if ((server->tcpStatus != CifsNeedSessSetup) &&
> > > >>> +     (ses->status == CifsGood)) {
> > > >>>   spin_unlock(&cifs_tcp_ses_lock);
> > > >>>   return 0;
> > > >>>   }
> > > >>>
> > > >>> --
> > > >>> Thanks,
> > > >>>
> > > >>> Steve
> > > >
> > > >
> > > >
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve



-- 
Regards,
Shyam
