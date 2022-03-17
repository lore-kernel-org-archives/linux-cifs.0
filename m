Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BB07C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Mar 2022 17:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbiCQRCT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Mar 2022 13:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiCQRCS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Mar 2022 13:02:18 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD65186884
        for <linux-cifs@vger.kernel.org>; Thu, 17 Mar 2022 10:01:01 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id l20so10009829lfg.12
        for <linux-cifs@vger.kernel.org>; Thu, 17 Mar 2022 10:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=76bs/MM99AR10S+nEmseBsHZpugNacwBRX7Ie0w4Fc4=;
        b=OT0NEYBdUzCGtZbSZesRhVugwnFvjHfmIg7Q+LTk3nzmLEyMoq39ubABQ3dI2aEuB8
         TgHZXmxFPitq6qgQ0V1dyg1CY6P/J2jej7BcV9e8Q5ZjYDxmsJtk/M18euUcDgC9+NBl
         PKrGVOuZU+MGji9jmP07WTkWQr/ubUV6TGmFP716HAumhgHcwBcZqZ+wc05Ou934d9+Z
         7oJjcnJdRstJa7SvoZvv7v8es5QDLOAKznjCxWG/K/1TZmNVMGWAZVTKusuYx/Iif8KD
         L0hlOKLioem213dnROUkqLaGoVleES9RPyPFQm4gXmH1LVcaymhPE/S8wC+jg72RNMp2
         VXaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=76bs/MM99AR10S+nEmseBsHZpugNacwBRX7Ie0w4Fc4=;
        b=OGv/yd+43Ee2ARc429TxsckR0wMl3zKMsJjv2aOkqc8h6QoeJd4zFFGdNl6ZVmSBKT
         q5pb9xRucbiIovMbNae80ZM7VRbfTHmOALQOcDLOCTLoSIAan1KU4zGGXlPLl3/6bPvJ
         HZR6KxthVrob20QrzoZ4eGfyI1ubvDqgrmNHF35Ou3flt+yuL5dGkOr7qGqxg8bphbr4
         aymzfH8u90HTfybC9jDS/2sQpzDRA53/lzJeHjJH6KdlqD/bkSSNaW4demdgNHQAuwNR
         d6fCxHoxAZVPIW2l7SBOIWcSfDVbDocDXc1JQczgr/M8u0jifuLAmihENNBSlQpGkbJd
         SrwA==
X-Gm-Message-State: AOAM533IaxWu/coNsMLvUzh9qmfyDLDVCTHVMF3SFsSr9uN/cp8A4ih3
        xlEWVA1GEuQMC6mNpaL/sTmyTXaw1cS3G11dR5EWnjii6Z4=
X-Google-Smtp-Source: ABdhPJzIUyQHfcxSriLqu+DxDnErfS7RaDYesOJVU0HosDP7QylcTs7WPigG4peuWAJ5JVKNUIDJo7wyW+a7995jMeI=
X-Received: by 2002:a19:490f:0:b0:448:4bf8:6084 with SMTP id
 w15-20020a19490f000000b004484bf86084mr3360074lfa.537.1647536459364; Thu, 17
 Mar 2022 10:00:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mth2fYLzU5+oN09ipT7peRdyAiPCF-7_fLPsTpA-fKKLA@mail.gmail.com>
 <CAN05THRxcqQ7SSjC3xetcJZnYNUXkhpmO7tW8fzZTrMnRrDMzw@mail.gmail.com>
 <CANT5p=oKgNJn7Dn0BDCbF28V+zKE9w8dgL0-Ra1fafKdjKHYaA@mail.gmail.com> <5a951b61-41b7-91b5-b774-75314df190c8@leemhuis.info>
In-Reply-To: <5a951b61-41b7-91b5-b774-75314df190c8@leemhuis.info>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 17 Mar 2022 12:00:48 -0500
Message-ID: <CAH2r5mtxg-HZTDSfPbWBT3FxnQq2F6Jq9uz7o1wJmjPPRBNcdw@mail.gmail.com>
Subject: Re: [PATCH][SMB3] fix multiuser mount regression
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Satadru Pramanik <satadru@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> And if it does, out of curiosity: Is the patch considered to be too
invasive for 5.17

Good question - I am testing it right now and weighing the option of
the one line patch which fixes at least one of the problems, vs. the
longer patch (about 50 lines of code IIRC) of Shyam's that I am
testing now.    We will defer the larger changes Ronnie, Shyam and I
have discussed to make the state machine more readable/understandable
(and less likely to run into this in the future by changing the state
names in the enum) for the three structures (server socket we are
connected to, authenticated user session, tree connect for the share
we have mounted)

On Thu, Mar 17, 2022 at 11:57 AM Thorsten Leemhuis
<regressions@leemhuis.info> wrote:
>
> On 17.03.22 16:47, Shyam Prasad N wrote:
> > I looked at this problem in more detail.
>
> Thx. Is that patch something Satadru should test to see if it fixes his
> regression?
> https://lore.kernel.org/linux-cifs/CAFrh3J9soC36%2BBVuwHB=g9z_KB5Og2%2Bp2_W%2BBBoBOZveErz14w@mail.gmail.com/
>
> And if it does, out of curiosity: Is the patch considered to be too
> invasive for 5.17 as the final is just a few days away?
>
> Ciao, Thorsten
>
> > Here's a summary of what happened:
> > Before my recent changes, when mchan was used, and a
> > negotiate/sess-setup happened, all other channels were paused. So
> > things were a lot simpler during a connect/reconnect.
> > What I did with my recent changes is to allow I/O to flow in other
> > channels when connect/reconnect happened on one of the channels. This
> > meant that there could be multiple channels that do negotiate/session
> > setup for the same session in parallel. i.e. first channel would
> > create a new session. Other channels would bind to the same session.
> > This meant that the server->tcpStatus needed to indicate an ongoing
> > sess setup. So that multiple channels could do session setup in
> > parallel.
> > Unfortunately, I did not account for multiuser scenario, which does
> > the reverse. i.e. uses the same server for different tcp sessions.
> >
> > Here's a patch I propose to fix this issue. Please review and let me
> > know what you think.
> > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/34333e9de1526c46e9ae5ff9a54f0199b827fd0e.patch
> >
> > Essentially, I'm doing 3 changes in this patch:
> > 1. Making sure that tcpStatus is only till the end of tcp connection
> > establishment. This means that tcpStatus reaches CifsGood when the tcp
> > connection is good
> > 2. Once cifs_negotiate_protocol starts, anything done will affect the
> > session state, and should not modify tcpStatus.
> > 3. To detect the small window between tcp connection setup and before
> > negotiate, use need_neg()
> >
> > On Thu, Mar 17, 2022 at 9:14 AM ronnie sahlberg
> > <ronniesahlberg@gmail.com> wrote:
> >>
> >> On Thu, Mar 17, 2022 at 1:20 PM Steve French <smfrench@gmail.com> wrote:
> >>>
> >>> cifssmb3: fix incorrect session setup check for multiuser mounts
> >>
> >> If it fixes multiuser then Acked-by me.
> >> We are so close to rc8 that we can not do intrusive changes,   so if
> >> it fixes it short term.
> >> For longer term, post rc8 we need to rewrite the statemaching completely
> >> and separate out "what happens in server->tcpStatus" as one statemachine and
> >> "what happens in server->status" as a separate one. Right now it is a mess.
> >>
> >>
> >>>
> >>> A recent change to how the SMB3 server (socket) and session status
> >>> is managed regressed multiuser mounts by changing the check
> >>> for whether session setup is needed to the socket (TCP_Server_info)
> >>> structure instead of the session struct (cifs_ses). Add additional
> >>> check in cifs_setup_sesion to fix this.
> >>>
> >>> Fixes: 73f9bfbe3d81 ("cifs: maintain a state machine for tcp/smb/tcon sessions")
> >>> Reported-by: Ronnie Sahlberg <lsahlber@redhat.com>
> >>> Signed-off-by: Steve French <stfrench@microsoft.com>
> >>> ---
> >>>  fs/cifs/connect.c | 3 ++-
> >>>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >>> index 053cb449eb16..d3020abfe404 100644
> >>> --- a/fs/cifs/connect.c
> >>> +++ b/fs/cifs/connect.c
> >>> @@ -3924,7 +3924,8 @@ cifs_setup_session(const unsigned int xid,
> >>> struct cifs_ses *ses,
> >>>
> >>>   /* only send once per connect */
> >>>   spin_lock(&cifs_tcp_ses_lock);
> >>> - if (server->tcpStatus != CifsNeedSessSetup) {
> >>> + if ((server->tcpStatus != CifsNeedSessSetup) &&
> >>> +     (ses->status == CifsGood)) {
> >>>   spin_unlock(&cifs_tcp_ses_lock);
> >>>   return 0;
> >>>   }
> >>>
> >>> --
> >>> Thanks,
> >>>
> >>> Steve
> >
> >
> >



-- 
Thanks,

Steve
