Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D77C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Mar 2022 17:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236766AbiCQRbH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Mar 2022 13:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235939AbiCQRbH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Mar 2022 13:31:07 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B715D214FB7
        for <linux-cifs@vger.kernel.org>; Thu, 17 Mar 2022 10:29:49 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id bu29so10274918lfb.0
        for <linux-cifs@vger.kernel.org>; Thu, 17 Mar 2022 10:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+SL7TRZZS+4/wJwXl0j0NaleS3TG8kwBRdWneXMvCKo=;
        b=HjWBF0HuxtUVB/75Gg+kk1AHrQLxEJbEoxYEoFMGCes3fRdI97jyHrZdn8ho0JO7BH
         B+PVfSBmyHyMpPdBEKZDbLbUT3BQzixJ1IJ/9EQBSON0Kxrz/zOePdrDASmHkBXUeb3o
         Q38z+0anwq43JHpYBiPNbuPYdK6M7zkP+sMLVENrxjoSwhl4Dc4931yc7s2hxjVf8Wbu
         fP7ubcGq0vmwNXsyACIYM9fW7v4xMvibgL69PPdicgojcg2kpqRT48Bss7ZRauSdt50/
         iXQzG1HSIwlKiaUd1NkQKqIa32/QRYxF6z2ilodsHBNqEtVA0mHeLd8fxoAARs+vX9C8
         1QtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+SL7TRZZS+4/wJwXl0j0NaleS3TG8kwBRdWneXMvCKo=;
        b=PgMXXlzOw+fv4PCtuwkHjTDQiiWUAvCmrBBJqzDmn+kpjhFPSBmVWrspMZhv3HOiwP
         QziAZcrBFVyk6Ki1S7cBwRvbvHLTHrD6vv7rRjLPc8aPR8ycjJiFjMvaMiAbx53tClvo
         qtXb+901ceZyC8tZED5Eydi81S1aNX0LrVpayUEKfG3PpJjVC1Pjnifa1nESOMfUpPDt
         LMNhxRDwARberFYddShqGaMq8VI7meKauAhaMhsGpHfK/XTRxASlfuaM4kfDZ/kIF9/p
         lCnlpScas/NPo9eHp1j4OJL7f/EljMH1C7+y6Ut2WXFfmt3bu6cueLbPpnPgrjSq0dhC
         rO7w==
X-Gm-Message-State: AOAM533CB8i4XqLGEZ9H0o9Q53iB7E0p/kS6PL8zGeGKtHHp3W6a3RPT
        2gRak/1jDs/tfJmG8ig2QR9x7sIMbv6Y8oDIbsZOMU3vJkY=
X-Google-Smtp-Source: ABdhPJwVzghTBIBG6zUm4kHs9+NB24QntGXwfVQuh2cX44Bj+Gnl+KN40gYrRXKl/sH/fFSL9PlaPrCde99yzu94JsE=
X-Received: by 2002:a05:6512:3704:b0:448:599e:30ea with SMTP id
 z4-20020a056512370400b00448599e30eamr3517240lfr.311.1647538187398; Thu, 17
 Mar 2022 10:29:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mth2fYLzU5+oN09ipT7peRdyAiPCF-7_fLPsTpA-fKKLA@mail.gmail.com>
 <CAN05THRxcqQ7SSjC3xetcJZnYNUXkhpmO7tW8fzZTrMnRrDMzw@mail.gmail.com>
 <CANT5p=oKgNJn7Dn0BDCbF28V+zKE9w8dgL0-Ra1fafKdjKHYaA@mail.gmail.com>
 <5a951b61-41b7-91b5-b774-75314df190c8@leemhuis.info> <CAH2r5mtxg-HZTDSfPbWBT3FxnQq2F6Jq9uz7o1wJmjPPRBNcdw@mail.gmail.com>
In-Reply-To: <CAH2r5mtxg-HZTDSfPbWBT3FxnQq2F6Jq9uz7o1wJmjPPRBNcdw@mail.gmail.com>
From:   Satadru Pramanik <satadru@gmail.com>
Date:   Thu, 17 Mar 2022 13:29:34 -0400
Message-ID: <CAFrh3J8c8rF76+iJJkXzdFn8EbWX30AYbfAinzcJL1SKXgK3CQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3] fix multiuser mount regression
To:     Steve French <smfrench@gmail.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000006a25bf05da6d607b"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000006a25bf05da6d607b
Content-Type: text/plain; charset="UTF-8"

Neither the one line patch nor the longer patch solve the issue.

Dmesg is attached from booting up with a kernel built with the longer
patch. It covers sleeping, rebooting server, noticing cifs mount is
broken, unmounting and remounting the cifs mount, putting the laptop
to sleep again, rebooting the server, waking the laptop, and noticing
the mount is broken again.


On Thu, Mar 17, 2022 at 1:01 PM Steve French <smfrench@gmail.com> wrote:
>
> > And if it does, out of curiosity: Is the patch considered to be too
> invasive for 5.17
>
> Good question - I am testing it right now and weighing the option of
> the one line patch which fixes at least one of the problems, vs. the
> longer patch (about 50 lines of code IIRC) of Shyam's that I am
> testing now.    We will defer the larger changes Ronnie, Shyam and I
> have discussed to make the state machine more readable/understandable
> (and less likely to run into this in the future by changing the state
> names in the enum) for the three structures (server socket we are
> connected to, authenticated user session, tree connect for the share
> we have mounted)
>
> On Thu, Mar 17, 2022 at 11:57 AM Thorsten Leemhuis
> <regressions@leemhuis.info> wrote:
> >
> > On 17.03.22 16:47, Shyam Prasad N wrote:
> > > I looked at this problem in more detail.
> >
> > Thx. Is that patch something Satadru should test to see if it fixes his
> > regression?
> > https://lore.kernel.org/linux-cifs/CAFrh3J9soC36%2BBVuwHB=g9z_KB5Og2%2Bp2_W%2BBBoBOZveErz14w@mail.gmail.com/
> >
> > And if it does, out of curiosity: Is the patch considered to be too
> > invasive for 5.17 as the final is just a few days away?
> >
> > Ciao, Thorsten
> >
> > > Here's a summary of what happened:
> > > Before my recent changes, when mchan was used, and a
> > > negotiate/sess-setup happened, all other channels were paused. So
> > > things were a lot simpler during a connect/reconnect.
> > > What I did with my recent changes is to allow I/O to flow in other
> > > channels when connect/reconnect happened on one of the channels. This
> > > meant that there could be multiple channels that do negotiate/session
> > > setup for the same session in parallel. i.e. first channel would
> > > create a new session. Other channels would bind to the same session.
> > > This meant that the server->tcpStatus needed to indicate an ongoing
> > > sess setup. So that multiple channels could do session setup in
> > > parallel.
> > > Unfortunately, I did not account for multiuser scenario, which does
> > > the reverse. i.e. uses the same server for different tcp sessions.
> > >
> > > Here's a patch I propose to fix this issue. Please review and let me
> > > know what you think.
> > > https://github.com/sprasad-microsoft/smb3-kernel-client/commit/34333e9de1526c46e9ae5ff9a54f0199b827fd0e.patch
> > >
> > > Essentially, I'm doing 3 changes in this patch:
> > > 1. Making sure that tcpStatus is only till the end of tcp connection
> > > establishment. This means that tcpStatus reaches CifsGood when the tcp
> > > connection is good
> > > 2. Once cifs_negotiate_protocol starts, anything done will affect the
> > > session state, and should not modify tcpStatus.
> > > 3. To detect the small window between tcp connection setup and before
> > > negotiate, use need_neg()
> > >
> > > On Thu, Mar 17, 2022 at 9:14 AM ronnie sahlberg
> > > <ronniesahlberg@gmail.com> wrote:
> > >>
> > >> On Thu, Mar 17, 2022 at 1:20 PM Steve French <smfrench@gmail.com> wrote:
> > >>>
> > >>> cifssmb3: fix incorrect session setup check for multiuser mounts
> > >>
> > >> If it fixes multiuser then Acked-by me.
> > >> We are so close to rc8 that we can not do intrusive changes,   so if
> > >> it fixes it short term.
> > >> For longer term, post rc8 we need to rewrite the statemaching completely
> > >> and separate out "what happens in server->tcpStatus" as one statemachine and
> > >> "what happens in server->status" as a separate one. Right now it is a mess.
> > >>
> > >>
> > >>>
> > >>> A recent change to how the SMB3 server (socket) and session status
> > >>> is managed regressed multiuser mounts by changing the check
> > >>> for whether session setup is needed to the socket (TCP_Server_info)
> > >>> structure instead of the session struct (cifs_ses). Add additional
> > >>> check in cifs_setup_sesion to fix this.
> > >>>
> > >>> Fixes: 73f9bfbe3d81 ("cifs: maintain a state machine for tcp/smb/tcon sessions")
> > >>> Reported-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > >>> Signed-off-by: Steve French <stfrench@microsoft.com>
> > >>> ---
> > >>>  fs/cifs/connect.c | 3 ++-
> > >>>  1 file changed, 2 insertions(+), 1 deletion(-)
> > >>>
> > >>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > >>> index 053cb449eb16..d3020abfe404 100644
> > >>> --- a/fs/cifs/connect.c
> > >>> +++ b/fs/cifs/connect.c
> > >>> @@ -3924,7 +3924,8 @@ cifs_setup_session(const unsigned int xid,
> > >>> struct cifs_ses *ses,
> > >>>
> > >>>   /* only send once per connect */
> > >>>   spin_lock(&cifs_tcp_ses_lock);
> > >>> - if (server->tcpStatus != CifsNeedSessSetup) {
> > >>> + if ((server->tcpStatus != CifsNeedSessSetup) &&
> > >>> +     (ses->status == CifsGood)) {
> > >>>   spin_unlock(&cifs_tcp_ses_lock);
> > >>>   return 0;
> > >>>   }
> > >>>
> > >>> --
> > >>> Thanks,
> > >>>
> > >>> Steve
> > >
> > >
> > >
>
>
>
> --
> Thanks,
>
> Steve

--0000000000006a25bf05da6d607b
Content-Type: application/gzip; name="dmesg.txt.gz"
Content-Disposition: attachment; filename="dmesg.txt.gz"
Content-Transfer-Encoding: base64
Content-ID: <f_l0v9o3590>
X-Attachment-Id: f_l0v9o3590

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
--0000000000006a25bf05da6d607b--
