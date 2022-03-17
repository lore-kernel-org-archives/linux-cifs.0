Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB007C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Mar 2022 15:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbiCQPtL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Mar 2022 11:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbiCQPtK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Mar 2022 11:49:10 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76DA13E0B
        for <linux-cifs@vger.kernel.org>; Thu, 17 Mar 2022 08:47:53 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id qx21so11549866ejb.13
        for <linux-cifs@vger.kernel.org>; Thu, 17 Mar 2022 08:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kZW/9N4A2njRiMxHxSPBc3pRUzoOQ1+XaOCeWyZGAMc=;
        b=gy9eyMyQxk5Ct6AJlEBiugcjp1iGRoTtuC+2MvEJicgC3s7KSVu9gw/yvQlwTJdO06
         r1emzckuFAEXNhgYoghe/KDN2ToVszWAJ3dTtU3Z1ILJcqSzlW3juaYbK4GI9rzv4ksY
         9fsAKwuvQfvdDMENf8upYKt9nrRtRPmmr3Uz1SkF/qoVBzhES4McgYKhf5Gkaas1CnQN
         xsTQ5eISgJVcCIe0MQYbJ2Bt7u3MhuHI+GAbI1RGPEcXT7UpG83cbErdG0T5ohvp2N/N
         v3MRFI0PB76UhrRZhYiVcQ0f0XJKeVBnfQa2BVcFLzjAdTg/Nxiz/exmOfhEa0XDLhGg
         DhVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kZW/9N4A2njRiMxHxSPBc3pRUzoOQ1+XaOCeWyZGAMc=;
        b=xSv8Z4Am52XV5Jokjrxa+dxEbXljwXtFvUgpbVlWUuMMUPbaP7CfRZC4wFocY7gAbT
         aacn3VqGIZzBmq8AIlFz0Oqfj1ScC4IpK7d+3gK22SpwR2zI8dq+WiDikXgTRFAXAmPX
         3QL/QP1lWJsN7qOqQ699W8G0aNFe+95m71RGjWQ4rlRZCFmtX8GRBODWkRZEOBEFzdZH
         0wsSjoOQEsEpiBGCE0fZEB3TysDlnz5nmA0/k3/DX+WxHmBngK46h2OrNRo0kvCSE3bO
         9uTKS2RMJ11Kz9F3s5imbqgxIpMtdHYrpILhAc+nmKxjNcVwbTToARYiZB126nv957eG
         PxGg==
X-Gm-Message-State: AOAM533VrS6Tsql98U3EvxqtivAgl52GgXZcQf4H+wW4/Ly1EyJXJKWY
        JLn17OkAH4F7MXZS4/ZQU8q1tQRuhR0Y8+YaDE8NkAUMGaXFGNzk
X-Google-Smtp-Source: ABdhPJwI1Gj8Qw9RD8F0CRWTDuC13bYJk62IcMuPUDK5BOzwE3Co7YRsJp9Uw4ySV0l6100BcvDPlr5ciS4tvs40Z0k=
X-Received: by 2002:a17:907:72cc:b0:6df:7430:6634 with SMTP id
 du12-20020a17090772cc00b006df74306634mr4945782ejc.453.1647532072242; Thu, 17
 Mar 2022 08:47:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mth2fYLzU5+oN09ipT7peRdyAiPCF-7_fLPsTpA-fKKLA@mail.gmail.com>
 <CAN05THRxcqQ7SSjC3xetcJZnYNUXkhpmO7tW8fzZTrMnRrDMzw@mail.gmail.com>
In-Reply-To: <CAN05THRxcqQ7SSjC3xetcJZnYNUXkhpmO7tW8fzZTrMnRrDMzw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 17 Mar 2022 21:17:40 +0530
Message-ID: <CANT5p=oKgNJn7Dn0BDCbF28V+zKE9w8dgL0-Ra1fafKdjKHYaA@mail.gmail.com>
Subject: Re: [PATCH][SMB3] fix multiuser mount regression
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Satadru Pramanik <satadru@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I looked at this problem in more detail.

Here's a summary of what happened:
Before my recent changes, when mchan was used, and a
negotiate/sess-setup happened, all other channels were paused. So
things were a lot simpler during a connect/reconnect.
What I did with my recent changes is to allow I/O to flow in other
channels when connect/reconnect happened on one of the channels. This
meant that there could be multiple channels that do negotiate/session
setup for the same session in parallel. i.e. first channel would
create a new session. Other channels would bind to the same session.
This meant that the server->tcpStatus needed to indicate an ongoing
sess setup. So that multiple channels could do session setup in
parallel.
Unfortunately, I did not account for multiuser scenario, which does
the reverse. i.e. uses the same server for different tcp sessions.

Here's a patch I propose to fix this issue. Please review and let me
know what you think.
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/34333e9de1526c46e9ae5ff9a54f0199b827fd0e.patch

Essentially, I'm doing 3 changes in this patch:
1. Making sure that tcpStatus is only till the end of tcp connection
establishment. This means that tcpStatus reaches CifsGood when the tcp
connection is good
2. Once cifs_negotiate_protocol starts, anything done will affect the
session state, and should not modify tcpStatus.
3. To detect the small window between tcp connection setup and before
negotiate, use need_neg()

On Thu, Mar 17, 2022 at 9:14 AM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Thu, Mar 17, 2022 at 1:20 PM Steve French <smfrench@gmail.com> wrote:
> >
> > cifssmb3: fix incorrect session setup check for multiuser mounts
>
> If it fixes multiuser then Acked-by me.
> We are so close to rc8 that we can not do intrusive changes,   so if
> it fixes it short term.
> For longer term, post rc8 we need to rewrite the statemaching completely
> and separate out "what happens in server->tcpStatus" as one statemachine and
> "what happens in server->status" as a separate one. Right now it is a mess.
>
>
> >
> > A recent change to how the SMB3 server (socket) and session status
> > is managed regressed multiuser mounts by changing the check
> > for whether session setup is needed to the socket (TCP_Server_info)
> > structure instead of the session struct (cifs_ses). Add additional
> > check in cifs_setup_sesion to fix this.
> >
> > Fixes: 73f9bfbe3d81 ("cifs: maintain a state machine for tcp/smb/tcon sessions")
> > Reported-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > ---
> >  fs/cifs/connect.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 053cb449eb16..d3020abfe404 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -3924,7 +3924,8 @@ cifs_setup_session(const unsigned int xid,
> > struct cifs_ses *ses,
> >
> >   /* only send once per connect */
> >   spin_lock(&cifs_tcp_ses_lock);
> > - if (server->tcpStatus != CifsNeedSessSetup) {
> > + if ((server->tcpStatus != CifsNeedSessSetup) &&
> > +     (ses->status == CifsGood)) {
> >   spin_unlock(&cifs_tcp_ses_lock);
> >   return 0;
> >   }
> >
> > --
> > Thanks,
> >
> > Steve



-- 
Regards,
Shyam
