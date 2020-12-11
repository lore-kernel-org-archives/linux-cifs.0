Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3163C4361B
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Dec 2020 00:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69FA623B45
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Dec 2020 00:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387774AbgLKAIY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Dec 2020 19:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393338AbgLKAIT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Dec 2020 19:08:19 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B83BC06179C
        for <linux-cifs@vger.kernel.org>; Thu, 10 Dec 2020 16:07:28 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id a12so10868532lfl.6
        for <linux-cifs@vger.kernel.org>; Thu, 10 Dec 2020 16:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KCohH9muLPYkPT+12kugg37Jfi5I+y3j8hpGQyuM4MY=;
        b=D8brbT3EDkrkBCSD07Mks6UNe3qhkcGzn9AG9NAILbcsVZ0/j1JDR8bpPMm7R/rMjG
         hv8l4l0HdT4gS/HzfLGA8xDQdWnge2o8VjWogZ//On0REwbI9KF/EhSc2jIZIIMrUk40
         8EJeehJ0BgERGNIrSWFCFAdFLoNsop7gk58QvT3x/ysCIZPFQSVrlhtKDhbmL4wd14wa
         zdeOHhHT514pC1VIlg4/ap23ZPO6qe4n5QbdKzBUAotYPSymgWnkxMxzaKhx3yQ7NRaC
         fvCRG1LFfZDEBqrp65OknMh1K6bYh+lVpgxzmEYFSqk3U+kYk4gPicaorJJNDK6PkpWA
         jbBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KCohH9muLPYkPT+12kugg37Jfi5I+y3j8hpGQyuM4MY=;
        b=NAL9AGz5QOYEyuDlGJM0rvsO4ovhsZgAQjiCDcthlIKjBOJaPC4keWbgf20XcOQpKU
         Y5AteE9WBWHcMRdqq1se+f2hFWvZQi9CE/85WuiBiZDtf8PY7+Xi+y91v+WTTGwSzTsl
         /d6SgDKWDuHSFuarvnNszUnnJHxLvVV5OXD1LZfSUjCiWiuW9DP+tL53OhcNKZCUDguM
         Z04iub2eI9OQUmvRkkbCGRj1/EMkVcZ2FANkqVgLUj++EQLxLoneopq0KgfDlhy8p+E1
         3PJDdhxQ7yDL1pltTZo27AXvcjo8pi3E6rzsgyLO5os9U6siCfwq0JpXo+mwI+ACqpdA
         gDRg==
X-Gm-Message-State: AOAM531X6i1oGUsHhrFUD/VT2dTr4QXvkzc50nAmSkZeKl4xHinpw3lJ
        dGFNwuETIGfgJ9bcwsjLuRbpW9D6fAvLjRijx4c=
X-Google-Smtp-Source: ABdhPJx6zAWoEbHqnF91GYwuZy3M27ihEHw0tCBMdW5H1dOSjmCbQIlcm233LBlh0Xmn2wojxbndFFiMUYYh+ac1C+Y=
X-Received: by 2002:a05:6512:2141:: with SMTP id s1mr3619422lfr.307.1607645246971;
 Thu, 10 Dec 2020 16:07:26 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mvdtdzFBMTUCk6DwK1zHW-fP-G9k3DpchD2bqnboooq8g@mail.gmail.com>
 <3aeefd61-8376-66b4-6e2d-20dcb1e53bb8@talpey.com>
In-Reply-To: <3aeefd61-8376-66b4-6e2d-20dcb1e53bb8@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 10 Dec 2020 18:07:15 -0600
Message-ID: <CAH2r5mv+-16CTfYxU84-vXxPme3uAEhRaAh=VaghAZ_e-67u=A@mail.gmail.com>
Subject: Re: [PATCH] SMB3.1.1: do not log warning message if server doesn't
 populate salt
To:     Tom Talpey <tom@talpey.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Tom Talpey <ttalpey@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If negotiate fails, due to server bug or packet corruption it would be
quite confusing if we silently fail with no indication of a server
problem.  ... And "warn_once" is used to avoid flooding the logs.   It
is quite common that these "warn_once" errors can be useful in problem
determination.  Typically when there are problems with the client
accessing a server we ask for the contents of dmesg and this kind of
thing (indications of unexpected behavior) can be helpful in problem
determination.   Currently if the preauth context is broken we can
guess that they wanted SHA512 but there is a risk if we guessed wrong
(eg server adds new algorithms in the future and breaks us due to
client or server bug) and don't note it in some way because the admin
would have nothing to report.   Logging to dmesg is something the user
generally would  not see on mount, but is useful for problem
determination and low risk.

On Thu, Dec 10, 2020 at 8:32 AM Tom Talpey <tom@talpey.com> wrote:
>
> tl;dr - the issue here goes deeper than Salt length
>
> On 12/9/2020 11:24 PM, Steve French wrote:
> > In the negotiate protocol preauth context, the server is not required
> > to populate the salt (although it is recommended, and done by most
>
> I don't think "recommended" is correct. The salt is optional, and that's
> because not all hashes use salt. Of course, the protocol currently
> only defines one hash algorithm, which does. But that could change.
> So delete "it is recommended,", and "most".
>
> > servers) so do not warn on mount if the salt is not 32 bytes, but
> > instead simply check that the preauth context is the minimum size
> > and that the salt would not overflow the buffer length.
>
> Suggest ending at "so do not warn.", see following.
>
> > CC: Stable <stable@vger.kernel.org>
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > ---
> >   fs/cifs/smb2pdu.c |  7 +++++--
> >   fs/cifs/smb2pdu.h | 14 +++++++++++---
> >   2 files changed, 16 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > index acb72705062d..8d572dcf330a 100644
> > --- a/fs/cifs/smb2pdu.c
> > +++ b/fs/cifs/smb2pdu.c
> > @@ -427,8 +427,8 @@ build_preauth_ctxt(struct smb2_preauth_neg_context
> > *pneg_ctxt)
> >    pneg_ctxt->ContextType = SMB2_PREAUTH_INTEGRITY_CAPABILITIES;
> >    pneg_ctxt->DataLength = cpu_to_le16(38);
> >    pneg_ctxt->HashAlgorithmCount = cpu_to_le16(1);
> > - pneg_ctxt->SaltLength = cpu_to_le16(SMB311_SALT_SIZE);
> > - get_random_bytes(pneg_ctxt->Salt, SMB311_SALT_SIZE);
> > + pneg_ctxt->SaltLength = cpu_to_le16(SMB311_CLIENT_SALT_SIZE);
> > + get_random_bytes(pneg_ctxt->Salt, SMB311_CLIENT_SALT_SIZE);
>
> Changing the salt size define is ok, but it's important to keep clear
> that "32" is not specified by the protocol, it just happens to be
> what Windows chose, for SHA512. I think it's a fine idea to do the
> same, since we're all using the same hash algorithm.
>
> Why not simply code a constant 32? Or, make the define something
> like LINUX_SMB3_SHA512_SALT_LENGTH_CHOICE?
>
> >    pneg_ctxt->HashAlgorithms = SMB2_PREAUTH_INTEGRITY_SHA512;
> >   }
> >
> > @@ -566,6 +566,9 @@ static void decode_preauth_context(struct
> > smb2_preauth_neg_context *ctxt)
> >    if (len < MIN_PREAUTH_CTXT_DATA_LEN) {
> >    pr_warn_once("server sent bad preauth context\n");
> >    return;
> > + } else if (len < MIN_PREAUTH_CTXT_DATA_LEN + le16_to_cpu(ctxt->SaltLength)) {
> > + pr_warn_once("server sent invalid SaltLength\n");
> > + return;
> >    }
> >    if (le16_to_cpu(ctxt->HashAlgorithmCount) != 1)
> >    pr_warn_once("Invalid SMB3 hash algorithm count\n");
>
> This comment applies to all three pr_warn's.
>
> Why are these here? The server is busted, sure, but the client is being
> a protocol validation test suite. And the information is really not very
> useful. How is a sysadmin supposed to respond? Finally, why are they
> pr_warn_once? If this server is broken, what about all the other ones,
> for which it suppresses the next warning?
>
> I say, if the negotiate response is invalid, abort the negotiate and
> forget throwing the book at it. No pr_warn's, or a simple generic one.
>
> > diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> > index fa57b03ca98c..de3127a6fc34 100644
> > --- a/fs/cifs/smb2pdu.h
> > +++ b/fs/cifs/smb2pdu.h
> > @@ -333,12 +333,20 @@ struct smb2_neg_context {
> >    /* Followed by array of data */
> >   } __packed;
> >
> > -#define SMB311_SALT_SIZE 32
> > +#define SMB311_CLIENT_SALT_SIZE 32
> >   /* Hash Algorithm Types */
> >   #define SMB2_PREAUTH_INTEGRITY_SHA512 cpu_to_le16(0x0001)
> >   #define SMB2_PREAUTH_HASH_SIZE 64
> >
> > -#define MIN_PREAUTH_CTXT_DATA_LEN (SMB311_SALT_SIZE + 6)
> > +/*
> > + * SaltLength that the server send can be zero, so the only three required
>
> It can be "any value", including zero.
>
> > + * fields (all __le16) end up six bytes total, so the minimum context data len
> > + * in the response is six.
> > + * The three required are: HashAlgorithmCount, SaltLength, and 1 HashAlgorithm
> > + * Although most servers send a SaltLength of 32 bytes, technically it is
> > + * optional.
>
> "Required" is ambiguous. All three of these fields are in the header,
> so they're all required. It's their value that's important. Obviously
> HashAlgorithmCount must be >0. SaltLength can be any value. Suggest
> removing this last sentence entirely.
>
> > + */
> > +#define MIN_PREAUTH_CTXT_DATA_LEN 6
> >   struct smb2_preauth_neg_context {
> >    __le16 ContextType; /* 1 */
> >    __le16 DataLength;
> > @@ -346,7 +354,7 @@ struct smb2_preauth_neg_context {
> >    __le16 HashAlgorithmCount; /* 1 */
> >    __le16 SaltLength;
> >    __le16 HashAlgorithms; /* HashAlgorithms[0] since only one defined */
> > - __u8 Salt[SMB311_SALT_SIZE];
> > + __u8 Salt[SMB311_CLIENT_SALT_SIZE];
>
> Incorrect! The protocol does not define this value. 32 is only an
> implementation behavior. This field is not constant, and may be 0.
>
> Tom.
>
> >   } __packed;
> >
> >   /* Encryption Algorithms Ciphers */
> >
> >



-- 
Thanks,

Steve
