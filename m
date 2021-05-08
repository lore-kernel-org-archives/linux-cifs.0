Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C25BC433ED
	for <linux-cifs@archiver.kernel.org>; Sat,  8 May 2021 15:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 367F2611BE
	for <linux-cifs@archiver.kernel.org>; Sat,  8 May 2021 15:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhEHPxn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 8 May 2021 11:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhEHPxl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 8 May 2021 11:53:41 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAAAC06175F
        for <linux-cifs@vger.kernel.org>; Sat,  8 May 2021 08:52:07 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id i9so10482114lfe.13
        for <linux-cifs@vger.kernel.org>; Sat, 08 May 2021 08:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yPH5SNWMUA6DhON3B+Ef9o+S9wXUcKzSR90WK8Z94SE=;
        b=B62WK+MO1oHMnx+H4NrshhxsoNpoS4tZ2Z2logM4R3X45Az+JK1tXm0u1TklElmo6H
         TFyLuEFzP4oPaKrGUFvPy+0p/XDx3El5drKwA4RnpauDxi1cPir20GHK3Gyx4QUt5H7V
         g0hGQ28M2MzVq1/b508V7euRgMZ/WvMQrxOjXsaYMpUyaaDi+1IlG8DJeGVk1Q840AHv
         UmiIPTtiGDkv237JiuI+LoGIyNMfLnlTrRWxC/1JgDF86RRFd7ixzsGb+cpyhyaglcMn
         xgpz6wNVwNbvfL+9GUJ4uQ5gPyi785AD8G54o56LhTs2RssftwhqbTV6c/Oi+K9WALJi
         pwTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yPH5SNWMUA6DhON3B+Ef9o+S9wXUcKzSR90WK8Z94SE=;
        b=OT1EstcAsf4vNoqykkK0+H8IA90FRLcUilvVAtuwFz89qdz2wYjPSYkNYgNkPpRHlL
         qFmJyAMpjx5ct+hO6OygVB+Azy3X9uXHfVyUbdIS33JdDz4vJVvhDGZKHtBmeEJjpP9a
         pu9fbdEqOLBL0OdQi3pXhbLKtXTNYnTsJsj1hasQ3EF+f1ePQ3vwtgjrm9P7Qm0xcjkB
         RZ4XAPmXLEC64dVS5xnR6zlYTczIiu4frNUaz5BdPYo/+QW3qMjM8T7XsaH7+5jRnVva
         UMxR+nOwfTXdi/1QqIW9846+6jq00I1wvfGqdMwkekShvbWV3Mohyl1Wfkvc1TLv13cC
         JwUQ==
X-Gm-Message-State: AOAM531VvR9bbsAIwMeoHKzwZtwIrvM54s/PVok84e4WDPOemByZPw3/
        0gwyC3noS/TEc5SoPiIPhoj0LPOUBl3VgfB12Ls=
X-Google-Smtp-Source: ABdhPJyIf0vtKK35nc5KmJ58vg0dlsgaFhB9PWB+dv+4EF+/SZbZcixxlTPGBvjvOuAwlomri22T9kT+vhLxWso/i2U=
X-Received: by 2002:a19:614e:: with SMTP id m14mr10004598lfk.395.1620489126128;
 Sat, 08 May 2021 08:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mu3m6FWWqrfOeQugXWGZOPiEE+Xgk8wc0rn8OgLRVPSWQ@mail.gmail.com>
 <98a3e99b-3d2e-0480-55db-f843c7016351@talpey.com> <CAH2r5ms-f7YRxeOHPQnGn_+n5dVaCE-WHzfNAstvLjT2HcfhDw@mail.gmail.com>
 <b54ad9a9-c145-639c-ef3c-c603988e41d4@talpey.com>
In-Reply-To: <b54ad9a9-c145-639c-ef3c-c603988e41d4@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 8 May 2021 10:51:54 -0500
Message-ID: <CAH2r5muNUwHKZ8z37UZW63et-TVdEGifkoKo4N6VvrkMiVRWJA@mail.gmail.com>
Subject: Re: [PATCH][SMB3] 3 small multichannel client patches
To:     Tom Talpey <tom@talpey.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

added RB tag and added cc:stable to those two as well

On Sat, May 8, 2021 at 10:20 AM Tom Talpey <tom@talpey.com> wrote:
>
> LGTM
>
> Reviewed-By: Tom Talpey <tom@talpey.com>
>
> On 5/8/2021 11:10 AM, Steve French wrote:
> > On Sat, May 8, 2021 at 8:29 AM Tom Talpey <tom@talpey.com> wrote:
> >>
> >> On 5/7/2021 9:13 PM, Steve French wrote:
> >>> 1) we were not setting CAP_MULTICHANNEL on negotiate request
> >>
> >>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> >>> index e36c2a867783..a8bf43184773 100644
> >>> --- a/fs/cifs/smb2pdu.c
> >>> +++ b/fs/cifs/smb2pdu.c
> >>> @@ -841,6 +841,8 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
> >>>                req->SecurityMode = 0;
> >>>
> >>>        req->Capabilities = cpu_to_le32(server->vals->req_capabilities);
> >>> +     if (ses->chan_max > 1)
> >>> +             req->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
> >>>
> >>>        /* ClientGUID must be zero for SMB2.02 dialect */
> >>>        if (server->vals->protocol_id == SMB20_PROT_ID)
> >>> @@ -1032,6 +1034,9 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
> >>>
> >>>        pneg_inbuf->Capabilities =
> >>>                        cpu_to_le32(server->vals->req_capabilities);
> >>> +     if (tcon->ses->chan_max > 1)
> >>> +             pneg_inbuf->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
> >>> +
> >>
> >> This doesn't look quite right, and it can lead to failed negotiate by
> >> setting CAP_MULTI_CHANNEL when the server didn't actually send the bit.
> >> Have you tested this with servers that don't do multichannel?
> >
> > Yes.   Validate negotiate ioctl request is supposed to validate what
> > the client sent not what the server responded, so according to
> > MS-SMB2, I must send in the ioctl what I sent before on negprot
> > request
> >
> > Section 3.2.5.5 says for validate negotiate "Capabilities is set to
> > Connection.ClientCapabilities."  where
> > "Connection.ClientCapabilities: The capabilities sent by the client in
> > the SMB2 NEGOTIATE Request"   (not what the server responded with,
> > what the ClientCapabilities were sent)
> >
> > I tested it with two cases that don't support multichannel: Samba, and
> > also an azure server target where multichannel was disabled.
> >
> >
> >>
> >>> 2) we were ignoring whether the server set CAP_NEGOTIATE in the response
> >>
> >> Is this "CAP_NEGOTIATE" a typo? I think you mean CAP_MULTI_CHANNEL.
> >
> > Yes - typo
> >
> >>
> >>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> >>> index 63d517b9f2ff..a391ca3166f3 100644
> >>> --- a/fs/cifs/sess.c
> >>> +++ b/fs/cifs/sess.c
> >>> @@ -97,6 +97,12 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
> >>>                return 0;
> >>>        }
> >>>
> >>> +     if ((ses->server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL) == false) {
> >>
> >> This compares a bit to a boolean. "false" should be "0"?
> >
> > I changed it to the more common style  if (!(ses->...capabilities & SMB@....))
> >>
> >>> +             cifs_dbg(VFS, "server does not support CAP_MULTI_CHANNEL, multichannel disabled\n");
> >>
> >> The wording could be clearer. Technically speaking, the server does not
> >> support _multichannel_, which it indicated by not setting CAP_MULTI_CHANNEL.
> >> Also, wouldn't it be more useful to add the servername to this message?
> >>          "server %s does not support multichannel, using single channel"
> >> or similar.
> >
> > Good idea
> >
> >>> 3) we were silently ignoring multichannel when "max_channels" was > 1
> >>> but the user forgot to include "multichannel" in mount line.
> >>
> >>   > diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> >>   > index 3bcf881c3ae9..8f7af6fcdc76 100644
> >>   > --- a/fs/cifs/fs_context.c
> >>   > +++ b/fs/cifs/fs_context.c
> >>   > @@ -1021,6 +1021,9 @@ static int smb3_fs_context_parse_param(struct
> >> fs_context *fc,
> >>   >                      goto cifs_parse_mount_err;
> >>   >              }
> >>   >              ctx->max_channels = result.uint_32;
> >>   > +            /* If more than one channel requested ... they want multichan */
> >>   > +            if ((ctx->multichannel == false) && (result.uint_32 > 1))
> >>   > +                    ctx->multichannel = true;
> >>
> >> Wouldn't this be clearer and simpler as just "if (result.uint32 > 1)" ?
> >
> > made that change
> >
> > Updated two of the patches as described above - attached.
> >



-- 
Thanks,

Steve
