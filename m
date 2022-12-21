Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41BD3C4332F
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Dec 2022 15:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbiLUPgh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Dec 2022 10:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234884AbiLUPgA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Dec 2022 10:36:00 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B645312AA5
        for <linux-cifs@vger.kernel.org>; Wed, 21 Dec 2022 07:33:14 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id b13so24052978lfo.3
        for <linux-cifs@vger.kernel.org>; Wed, 21 Dec 2022 07:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zGFzu9g9646JJSFOPhemH5hnnp/CtmrP9HslKbW8OGU=;
        b=SlJKoJ1zp451hNYw0DqOpd7WAbstYybelswJUgKw4C231Se9gPbfev8TNUTtlRegNQ
         F9EiP7xIIfgxWHpsyPqiL364LELgusG9S3CZ28ohlqv0RyvmQIFktje2EO9BBWYAPIP1
         lAaNLVGiQBCzLBRCeFa2uZh0xt9zyhVYaWsYsgZ3rANlkxD5hfzkKelq0rj3V+YPyOTn
         KfdLmSTmUmK21AGIQoyAFa1q3vOMBBIzcxEIQdeNNQgYSMv2pCwn6JCoCZwy8zvCFdfE
         wnHXdgjtSMavD0VMwU9fWgZM10YY+I2z0YKxR1XDcH6W4XPtBDLUfqAiejMsWvqLoItO
         y3Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zGFzu9g9646JJSFOPhemH5hnnp/CtmrP9HslKbW8OGU=;
        b=nxKyTPSn8Spddg7Dnf7UIrVKFe30CxZiF1+A2+NLmbt/SaE/Qe4Ybgifjkmkxqix8p
         POXCYHLIDSAP+mtTHzCGUNPDIBTok2gWUtGPgAN1PYMGZu/vpZUkpSuNq+ImdoEidmY3
         bTMTdwY/YKe4GkLB45WIfxhJboxuNa55Gl0Cfy+5qio5p9YhdFxb4yWlS3AcIZs15JBa
         CFOnPsRyMRz7vndACf+QQqKfjArgJDfnLJo6I1Vk02l0/PWRWIUlHqhjUV3mvB/ZMNaX
         OvLKoATTAL9qDxzmex2eZuN8bLuqh7oaeQ2mXUbpcKYQrkpMLpbD0ONZytRajCVnnb+a
         GQBQ==
X-Gm-Message-State: AFqh2kruvdGY6ANwxudt+fuxGQ7aFcO8hakkwz5QbS9m5iFB356QVU6S
        OBfifI/cnNkUh2F/XxX7mPzGpRv4741nPGS5/Ks=
X-Google-Smtp-Source: AMrXdXucikRGttoBDgD69dCRW6CUBLJQt7eQJ9Q2XyamykM4hCLydvvC3Qd1IlWywa7pLNNgyuy/d38nQ8qr8GK3u3s=
X-Received: by 2002:ac2:5cca:0:b0:4b2:5c79:ae9c with SMTP id
 f10-20020ac25cca000000b004b25c79ae9cmr237931lfq.619.1671636792851; Wed, 21
 Dec 2022 07:33:12 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=oKQEB6HnopL=jAd0pxd-+OukcfrVgc76X-suShqUiA9w@mail.gmail.com>
 <CAH2r5muGBpwvpt6tTXDj2s=UHhJyG1=p94mcTaZ7QbrpuZ2R+w@mail.gmail.com> <6b39f048-b292-a0fd-af8a-abad97d22ed7@talpey.com>
In-Reply-To: <6b39f048-b292-a0fd-af8a-abad97d22ed7@talpey.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 21 Dec 2022 21:03:01 +0530
Message-ID: <CANT5p=rje_XAHySDoxL50C6=EUkvdawN4neU+0xyvFDLAbYW6A@mail.gmail.com>
Subject: Re: [PATCH] cifs: use the least loaded channel for sending requests
To:     Tom Talpey <tom@talpey.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Bharath S M <bharathsm@microsoft.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aurelien.aptel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Dec 20, 2022 at 11:48 PM Tom Talpey <tom@talpey.com> wrote:
>
> I'd suggest a runtime configuration, personally. A config option
> is undesirable, because it's very difficult to deploy. A module
> parameter is only slightly better. The channel selection is a
> natural for a runtime per-operation decision. And for the record,
> I think a round-robin selection is a bad approach. Personally
> I'd just yank it.

Hi Tom,

Thanks for taking a look at this.
I was considering doing so. But was unsure if we'll still need a way
to do round robin.
Steve/Aurelien: Any objections to just remove the round-robin approach?

>
> I'm uneasy about ignoring the channel bandwidth and channel type.
> Low bandwidth channels, or mixing RDMA and non-RDMA, are going to
> be very problematic for bulk data. In fact, the Windows client
> never mixes such alternatives, it always selects identical link
> speeds and transport types. The traffic will always find a way to
> block on the slowest/worst connection.
>
> Do you feel there is some advantage to mixing traffic? If so, can
> you elaborate on that?

We will not be mixing traffic here. Channel bandwidth and type are
considered while establishing a new channel.
This change is only for distributing the requests among the channels
for the session.

That said, those decisions are sub-optimal today, IMO.
I plan to send out some changes there too.

>
> The patch you link to doesn't seem complete. If min_in_flight is
> initialized to -1, how does the server->in_flight < min_in_flight
> test ever return true?

min_in_flight is declared as unsigned and then assigned to -1.
I'm relying on the compiler to use the max value for the unsigned int
based on this.
Perhaps I should have been more explicit by assigning this to
UINT_MAX. Will do so now.

>
> Tom.
>
> On 12/20/2022 9:47 AM, Steve French wrote:
> > maybe a module load parm would be easier to use than kernel config
> > option (and give more realistic test comparison data for many)
> >
> > On Tue, Dec 20, 2022 at 7:29 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >>
> >> Hi Steve,
> >>
> >> Below is a patch for a new channel allocation strategy that we've been
> >> discussing for some time now. It uses the least loaded channel to send
> >> requests as compared to the simple round robin. This will help
> >> especially in cases where the server is not consuming requests at the
> >> same rate across the channels.
> >>
> >> I've put the changes behind a config option that has a default value of true.
> >> This way, we have an option to switch to the current default of round
> >> robin when needed.
> >>
> >> Please review.
> >>
> >> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/28b96fd89f7d746fc2b6c68682527214a55463f9.patch
> >>
> >> --
> >> Regards,
> >> Shyam
> >
> >
> >



-- 
Regards,
Shyam
