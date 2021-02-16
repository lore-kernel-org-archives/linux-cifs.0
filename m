Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E36C433E9
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Feb 2021 19:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 658DA64EB8
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Feb 2021 19:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbhBPT5V (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Feb 2021 14:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbhBPT5T (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Feb 2021 14:57:19 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01C4C061756
        for <linux-cifs@vger.kernel.org>; Tue, 16 Feb 2021 11:56:38 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id r23so13441242ljh.1
        for <linux-cifs@vger.kernel.org>; Tue, 16 Feb 2021 11:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NS5Oy6C+U8c9hL3HYjP9lyNPCmQg5PE+G9AwyBr4zME=;
        b=bUV7yCooG270VkNfVtUPFBTPkwG8uw6nh19mjN4BNTU+fluwhgpK3M8O9bP17cyAxe
         JT+shFrhBJqjnL80tUdMxF6HqsePbgZdjxrBfGs0rmhfvGCtjuYdIwRCda/fbyD97rmM
         43HFIjBEdCpx3N1dM4w0AvD5fS+F65oRPzS6lkf5D9FfFD4DLmYPSM+ISoQypP1eEfqr
         T3cBIGScYS5DFFT7wfnyehPPemUB3uw/FcRK77/Ulk4Dneo+EqQBYRDHIdUw5OlqlYqA
         4OeUYyAU6pqn1DfcrJPzOs5BywLBo3YmsDWc57McTkEv9CtM9kidkXwK2hmKN5kDN+lE
         NpBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NS5Oy6C+U8c9hL3HYjP9lyNPCmQg5PE+G9AwyBr4zME=;
        b=DMF6jZeThUc8DDkbiCtUjhipm1WyTafZ0Tkv4N9tyNzalBjl2of43JXoGKOKPppdmo
         Bz5SPW/Q7b2gSKXttP4L/cCaunizzKvQbwi4pQVp8+FY29Amu7Mm8+WtNYxVrAJsnmyn
         z1BCmAiH12EiAKrna9LWWRxvojk8GlbXRhk8YSP6rAymE9bsZxeE0Z3NFPOCjUepMsKQ
         9Qg5ibxBCoyh+dy3dOPtPc5pOwOn1R7J7kczRCeLvbdevk4F+Z/qNxhpPI8rANFd4xlW
         ZECDDLykjTVdYBcERBQgAY9d/QL82xnEddGCgdqgB22ONWbuCc5DH7MZ2w6+0HBzFOFr
         vYlA==
X-Gm-Message-State: AOAM530XYy2+fUqucLZyEi8Rozv8MmXGxG4EAutd90m5E0wqn3YXSnVO
        JCQVBOXHKg5Vf26QdqnM8oP6LU2f1miQGNitdUo=
X-Google-Smtp-Source: ABdhPJzbUuYqcOxio82N0Yn8miaFXhP1lSvNFQrFeSv7Yi8snKTacsdFgYsyeJg5ascd4PnZk8xCdxAuhLGayZXeO2c=
X-Received: by 2002:a2e:9582:: with SMTP id w2mr12978923ljh.218.1613505397276;
 Tue, 16 Feb 2021 11:56:37 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=o9Tw9E+o3PWytsNh5eDKxswJ+YPLZLWac7QwR_u-UJaw@mail.gmail.com>
 <87h7msnnme.fsf@suse.com> <CANT5p=qGTC4E4Rf_-t9xXOo4yf3W=xtk97J1jg-WRLhwf0juBA@mail.gmail.com>
 <87a6sjopsc.fsf@suse.com> <CANT5p=qQJwvF11MJpiuV7S1GpH9=HZ-g=hmfOV-a07N9xkYqnA@mail.gmail.com>
 <CAH2r5mv0TzWpYi38HtuVG2gtYvW60-RDOri3a1FUUtprn19Dzw@mail.gmail.com>
 <87lfbyn647.fsf@suse.com> <CANT5p=qJjeVk1HDhvaiAQSYH3mj-rNBNA-j2TAUnoqQVTOQ_Ww@mail.gmail.com>
 <875z2yn0lx.fsf@suse.com> <CAKywueRoFL17DiMzmorZcd=OJvDY_8+P8WxGqKDx-tdnJrr_HQ@mail.gmail.com>
 <6aad7fc3-3c3f-848c-4d65-e5c7f1dd8107@talpey.com> <CANT5p=o4=uy8HV4L_nXfPUJ=bUO5Oyf8p6=Y7dY5PxsabHxJYQ@mail.gmail.com>
In-Reply-To: <CANT5p=o4=uy8HV4L_nXfPUJ=bUO5Oyf8p6=Y7dY5PxsabHxJYQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 16 Feb 2021 13:56:26 -0600
Message-ID: <CAH2r5muAhJaVTkGnzgTKXhLKaEXocgSk-WOguA4KkZWb5rMraQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] cifs: Reformat DebugData and index connections by conn_id.
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Tom Talpey <tom@talpey.com>, Pavel Shilovsky <piastryyy@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Feb 16, 2021 at 6:29 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Hi Pavel,
>
> Thanks for the review.
> As Tom pointed out, the server name is currently a field in
> TCP_Session_Info struct.
> We do store the struct sockaddr_storage, which I'm guessing holds the
> IP address in binary format, and we could use that. And may need to
> consider IPv4 vs IPv6 when we do it.
> I'll submit that as a new patch later on.
>
> Hi Tom,
>
> > Including the transport type (TCP, RDMA...) and multichannel attributes
> > (link speed, RSS count, ...) would be useful too.
> Can you please clarify this for me?
> From what I can see from the code, RDMA connection DebugData is a
> superset of TCP connection. The RDMA specific details get printed only
> when server->rdma is set.
>
> Regards,
> Shyam
>
> On Thu, Feb 11, 2021 at 11:41 AM Tom Talpey <tom@talpey.com> wrote:
> >
> > On 2/11/2021 12:12 PM, Pavel Shilovsky wrote:
> > > Hi Shyam,
> > >
> > > The output looks very informative! I have one comment:
> > >
> > > Servers:
> > > 1) ConnectionId: 0x1
> > > Number of credits: 326 Dialect 0x311
> > > TCP status: 1 Instance: 1
> > > Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0
> > > In Send: 0 In MaxReq Wait: 0
> > >
> > > Sessions:
> > > 1) Name: 10.229.158.38 Uses: 1 Capability: 0x300077 Session Status: 1
> > >                       ^^^^
> > > Isn't this name (or hostname) a property of the connection? I would
> > > expect an IP or a hostname to be printed in the connection settings
> > > above.
> >
> > The servername is a property of the session, in this case since the
> > mount specified a dotted quad, it would correctly appear as the
> > servername at this level.
> >
> > However, I definitely agree that an IP address is important in the
> > per-connection (channel) stanzas. Multichannel, multihoming, witness
> > redirects, and any number of things can vary among them. It would
> > be useful indeed to display them.
> >
> > Including the transport type (TCP, RDMA...) and multichannel attributes
> > (link speed, RSS count, ...) would be useful too.

It does show whether interface supports RSS or RDMA in the channel
list for every session
(and whether that interface is 'CONNECTED' for that session).  See
below example from his
sample /proc/fs/cifs/DebugData output (although this part did not
change with his patch)

4) Speed: 1000000000 bps
Capabilities: rss
IPv4: 10.229.158.38
[CONNECTED]


Thanks,

Steve
