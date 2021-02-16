Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D88C433DB
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Feb 2021 12:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3E9664DDA
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Feb 2021 12:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbhBPMaJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Feb 2021 07:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbhBPMaH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Feb 2021 07:30:07 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1316C061786
        for <linux-cifs@vger.kernel.org>; Tue, 16 Feb 2021 04:29:26 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id p186so10302637ybg.2
        for <linux-cifs@vger.kernel.org>; Tue, 16 Feb 2021 04:29:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Dk/kmP4YEEjwvgLxXa/bzqD/OCSIumYVTeoGpXoNCzI=;
        b=UGJZzUFV9ZY1ve1cQDhZnnct/LPQj6DhcG0A9RLJi2f5ZD67H1pdm8gKqOo4OqGl0f
         RDAc+2OLfglv3vXNGaxCMmFvzn/wo0H0TZtLXnPEN/Abfr0O9wgw0YXNuCN/lVnM3yR/
         k0D3GVvvkx3S4s2Z6b3BvwWUcnJ6RHff3kL8H9DY8PYhFhBgqK5G/ecG1cEAsiSsbeJ8
         k9ZbDym18nQGdVoAqFihSR1q3BS2Oyni2iJYa2Kw+Di4byixEjZzjObYSgmik8lOFNoS
         lIkA/RNwGG/UcjBevxzErdRHFDa7wStsAJG4DdeG2m4pOZ68TimqLNELHsQZZelm3m4W
         tHtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Dk/kmP4YEEjwvgLxXa/bzqD/OCSIumYVTeoGpXoNCzI=;
        b=D1mYd01OC5wo3rOhF5LzyJxbH3BFWes50cOEUNK2BIob24JgQsg2jM1z9hlKsITN2/
         5Hzs2BiJpn+YpRd6yuG6iq1LDlCcWG1wZjivPDP48j1ZKk2+J+JPVNH2NY5zXYQgT58s
         7rAJpUrRelXCqoV87LV3kH7tXXtR5Rjsh6LXfJLAjrlNH8tYF3wsLWtJIU6pH2Usmb1E
         thCPx9JQObMyYjg7OsSwaXDhxeIzBbQDY+rgYtIRzf5LE5RKBGRhiFzVzvA1mu64Eap/
         UgnI+aJ4L9udWNpmixZpa/WlNEqFJApXaFHhX2tjNLTvqSp+XGTX4WhmxeEWKxs3Umar
         FLsg==
X-Gm-Message-State: AOAM530ZBkvUWdMoMsLvlN0imTUd0crm3MfTtDlLL2fJfi09gTudN7Xw
        xQlKSGhLlv4Asara9eVmtk5HzAlZPQd9X+H3QUi/3uPR9iE7sw==
X-Google-Smtp-Source: ABdhPJwWdioCjxIIaK76G4KCxZ/YQd/NSgB9cncm87m7RU5lAp62CsHAJtB3rWJ5RsskpVNmL2BlZ1F5g4UyYDGpoYg=
X-Received: by 2002:a25:ab82:: with SMTP id v2mr16493621ybi.97.1613478565972;
 Tue, 16 Feb 2021 04:29:25 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=o9Tw9E+o3PWytsNh5eDKxswJ+YPLZLWac7QwR_u-UJaw@mail.gmail.com>
 <87h7msnnme.fsf@suse.com> <CANT5p=qGTC4E4Rf_-t9xXOo4yf3W=xtk97J1jg-WRLhwf0juBA@mail.gmail.com>
 <87a6sjopsc.fsf@suse.com> <CANT5p=qQJwvF11MJpiuV7S1GpH9=HZ-g=hmfOV-a07N9xkYqnA@mail.gmail.com>
 <CAH2r5mv0TzWpYi38HtuVG2gtYvW60-RDOri3a1FUUtprn19Dzw@mail.gmail.com>
 <87lfbyn647.fsf@suse.com> <CANT5p=qJjeVk1HDhvaiAQSYH3mj-rNBNA-j2TAUnoqQVTOQ_Ww@mail.gmail.com>
 <875z2yn0lx.fsf@suse.com> <CAKywueRoFL17DiMzmorZcd=OJvDY_8+P8WxGqKDx-tdnJrr_HQ@mail.gmail.com>
 <6aad7fc3-3c3f-848c-4d65-e5c7f1dd8107@talpey.com>
In-Reply-To: <6aad7fc3-3c3f-848c-4d65-e5c7f1dd8107@talpey.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 16 Feb 2021 04:29:15 -0800
Message-ID: <CANT5p=o4=uy8HV4L_nXfPUJ=bUO5Oyf8p6=Y7dY5PxsabHxJYQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] cifs: Reformat DebugData and index connections by conn_id.
To:     Tom Talpey <tom@talpey.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Pavel,

Thanks for the review.
As Tom pointed out, the server name is currently a field in
TCP_Session_Info struct.
We do store the struct sockaddr_storage, which I'm guessing holds the
IP address in binary format, and we could use that. And may need to
consider IPv4 vs IPv6 when we do it.
I'll submit that as a new patch later on.

Hi Tom,

> Including the transport type (TCP, RDMA...) and multichannel attributes
> (link speed, RSS count, ...) would be useful too.
Can you please clarify this for me?
From what I can see from the code, RDMA connection DebugData is a
superset of TCP connection. The RDMA specific details get printed only
when server->rdma is set.

Regards,
Shyam

On Thu, Feb 11, 2021 at 11:41 AM Tom Talpey <tom@talpey.com> wrote:
>
> On 2/11/2021 12:12 PM, Pavel Shilovsky wrote:
> > Hi Shyam,
> >
> > The output looks very informative! I have one comment:
> >
> > Servers:
> > 1) ConnectionId: 0x1
> > Number of credits: 326 Dialect 0x311
> > TCP status: 1 Instance: 1
> > Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0
> > In Send: 0 In MaxReq Wait: 0
> >
> > Sessions:
> > 1) Name: 10.229.158.38 Uses: 1 Capability: 0x300077 Session Status: 1
> >                       ^^^^
> > Isn't this name (or hostname) a property of the connection? I would
> > expect an IP or a hostname to be printed in the connection settings
> > above.
>
> The servername is a property of the session, in this case since the
> mount specified a dotted quad, it would correctly appear as the
> servername at this level.
>
> However, I definitely agree that an IP address is important in the
> per-connection (channel) stanzas. Multichannel, multihoming, witness
> redirects, and any number of things can vary among them. It would
> be useful indeed to display them.
>
> Including the transport type (TCP, RDMA...) and multichannel attributes
> (link speed, RSS count, ...) would be useful too.
>
> Tom.
>
> >
> > --
> > Best regards,
> > Pavel Shilovsky
> >
> > =D1=87=D1=82, 11 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 06:24, A=
ur=C3=A9lien Aptel <aaptel@suse.com>:
> >>
> >> Shyam Prasad N <nspmangalore@gmail.com> writes:
> >>> I noticed that the output looks rather odd when used with multichanne=
l.
> >>> Attaching a revised patch with the changes.
> >>>
> >>> Also attached a sample of new output.
> >>
> >> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> >>
> >> --
> >> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> >> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> >> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnbe=
rg, DE
> >> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
> >>
> >



--=20
Regards,
Shyam
