Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6803C4332F
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Dec 2022 09:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235199AbiLVJ47 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Dec 2022 04:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbiLVJ44 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Dec 2022 04:56:56 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66C21EC5D
        for <linux-cifs@vger.kernel.org>; Thu, 22 Dec 2022 01:56:53 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id y25so1946963lfa.9
        for <linux-cifs@vger.kernel.org>; Thu, 22 Dec 2022 01:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oFDwAp0dSW9KNYjk1L8x4+RhfkmDkkJNboX1cWotBkw=;
        b=DqcAmN6f2OPH27Pr3zvg/RXeULJtPUU7DbKc4sZ+GB9BIX5u5kSY3yC4Ye2SR5gp94
         +ydYt8P7rsiUGhmKN7Ddj36mg4vPcy9om42+GwJCmVBgWfULc/QF62lPh0uMKqyaT5fv
         n8cTjGWiH0pZs58sLCy1fCWuoxyoHNR1oy2pXMFUJseGxCKtUi3VZTCVsNTIbej51bmL
         sJT5v88F/ePTt+6ZwtHCAGsdwsgvKszcdidiLjzKBKcvaO6rgpZu2GIUJ3qgOdWhI0VN
         r6cJQbp4u+Uaf9KnImtuVjbCdfOQgLPjB8UcJVlzBrKptHYb04zs4YjAtrvOuVzA7Wd/
         9Tkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oFDwAp0dSW9KNYjk1L8x4+RhfkmDkkJNboX1cWotBkw=;
        b=nIvrTalQdY/N9JMW6/HuWfRp7ylS9zXFVDuAkuC/2d7/hcMHtu9yJ1O8ROqZngaRW7
         TtIJRNjxzTo5lPcEqOsUX9vIP5GdA9s3lMxWGjRCVALsPkPNLPMLAIHEKPxkvGik7cil
         evi2JgJZTQF+dZPiskQokEJ9locV7p0BFd2ixCmglHEZIDHw+GAaoNhT3O8uSiAj6nN+
         nwhDmu6S3vmVy1FyYnmX/JVfZR2oAW9usNTpEIl3Rlf5wCPLbnKHpg8Ch6sdi+Dp0rDN
         VAv31NZYe2qbXWPL68NYzYaU21mJzE0aRY2TimDqR56lYJ87WxUL41Fa4Eo0bsfZFz9D
         IAdw==
X-Gm-Message-State: AFqh2kqgQrWHO4sdAA6PTipl1dlxg1gpqFraJXI64fc3j+lSZb35wM/5
        aFFe7bQgEHYieQkkt8fR1/gOSKtEyEDU8bwUeuo=
X-Google-Smtp-Source: AMrXdXs6LM+UC0KANrmj+g7e2b531PEGdd5B+JPv91IHpGSQn/s8vMt4xXKKpZYUh23HQYYKMvpu5mNWHiF/glYqywU=
X-Received: by 2002:a05:6512:552:b0:4b5:9233:6e9b with SMTP id
 h18-20020a056512055200b004b592336e9bmr518099lfl.394.1671703011905; Thu, 22
 Dec 2022 01:56:51 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=oKQEB6HnopL=jAd0pxd-+OukcfrVgc76X-suShqUiA9w@mail.gmail.com>
 <CAH2r5muGBpwvpt6tTXDj2s=UHhJyG1=p94mcTaZ7QbrpuZ2R+w@mail.gmail.com>
 <6b39f048-b292-a0fd-af8a-abad97d22ed7@talpey.com> <CANT5p=rje_XAHySDoxL50C6=EUkvdawN4neU+0xyvFDLAbYW6A@mail.gmail.com>
 <73b86766-75cf-cc1e-0d21-01eaeea71a49@talpey.com>
In-Reply-To: <73b86766-75cf-cc1e-0d21-01eaeea71a49@talpey.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 22 Dec 2022 15:26:40 +0530
Message-ID: <CANT5p=pTu848=CUK_FqNk=BB+QcecBAkSysp6WxA62krX4rDbQ@mail.gmail.com>
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

On Wed, Dec 21, 2022 at 10:17 PM Tom Talpey <tom@talpey.com> wrote:
>
> Question on this:
>
>  > We will not be mixing traffic here. Channel bandwidth and type are
>  > considered while establishing a new channel.
>  > This change is only for distributing the requests among the channels
>  > for the session.
>
> I disagree. The iface_cmp() function in cifsglob.h returns a positive
> value for all interfaces which are as fast or faster than the one
> being compared-to. And weirdly, it only looks at rdma_capable when the
> speeds are equal, and it ignores rss_capable unless rdma_capable
> matches.
>

Hi Tom,

What I meant by my statement was that this change does not modify the
decision about which server interface the channels are connected to.

You are right about what iface_cmp does.
The goal of this function was to compare two interfaces, and return 1
if interface 'a' is more preferred; 0 if both are the same; and -1 if
b is preferred.
The one that is preferred sits closer to the head of the list after
parse_server_interfaces.
The "preference" is based on 3 factors:
1. speed
2. rdma_capable
3. rss_capable
I missed the case where interfaces could have both rdma and rss
capability. Will fix that soon.

Do you see any problem if channels of the same session mix rdma/rss
capable interfaces?
I've kept the overall logic the same as before my changes.

> It also makes the following questionable assumption:
>
>      * The iface_list is assumed to be sorted by speed.
>
> In parse_server_interfaces(), new eligible entries are added in the
> order the server returns them. The protocol doesn't require this! It's
> entirely implementation specific.

If the server returns interfaces of different speeds, the end result
of parse_server_interfaces is in decreasing order of speed; then rdma
capable; then rss capable interfaces.
The protocol does not require this. But the implementation we had
always chose to connect to the fastest interfaces first.

>
> In any event, I think if the client connects to a server on a 1GbE
> interface, and discovers a 10GbE one, it will mix traffic on both.
> In the current code, every other operation will switch interfaces.
> In your code, it will only slightly prefer the 10GbE, when bulk data
> begins to backlog the 1GbE.

Again, do you see a problem in mixing the interfaces, if we make
connections based on the speed of the connection?
I plan to change this logic to do a weighted distribution of channels
among interfaces (weight decided by speed of the interface), instead
of simply choosing the fastest one.
That way, parse_server_interfaces will not need to sort anymore.

>
> So, unless you fix iface_cmp, and rework the selection logic in
> parse_server_interfaces, I don't think the change does much.
>
> What about the runtime selection?

It should not be necessary.

I spoke to Steve about this yesterday. He doesn't mind doing away with
the old logic of simple round robin too.
However, when in-flight == 0 for all channels, he feels that we should
not favour the same channel all the time.
So I'm planning to make some modifications to the current code in that
direction.

>
> Tom.
>
>
>
> On 12/21/2022 10:33 AM, Shyam Prasad N wrote:
> > On Tue, Dec 20, 2022 at 11:48 PM Tom Talpey <tom@talpey.com> wrote:
> >>
> >> I'd suggest a runtime configuration, personally. A config option
> >> is undesirable, because it's very difficult to deploy. A module
> >> parameter is only slightly better. The channel selection is a
> >> natural for a runtime per-operation decision. And for the record,
> >> I think a round-robin selection is a bad approach. Personally
> >> I'd just yank it.
> >
> > Hi Tom,
> >
> > Thanks for taking a look at this.
> > I was considering doing so. But was unsure if we'll still need a way
> > to do round robin.
> > Steve/Aurelien: Any objections to just remove the round-robin approach?
> >
> >>
> >> I'm uneasy about ignoring the channel bandwidth and channel type.
> >> Low bandwidth channels, or mixing RDMA and non-RDMA, are going to
> >> be very problematic for bulk data. In fact, the Windows client
> >> never mixes such alternatives, it always selects identical link
> >> speeds and transport types. The traffic will always find a way to
> >> block on the slowest/worst connection.
> >>
> >> Do you feel there is some advantage to mixing traffic? If so, can
> >> you elaborate on that?
> >
> > We will not be mixing traffic here. Channel bandwidth and type are
> > considered while establishing a new channel.
> > This change is only for distributing the requests among the channels
> > for the session.
> >
> > That said, those decisions are sub-optimal today, IMO.
> > I plan to send out some changes there too.
> >
> >>
> >> The patch you link to doesn't seem complete. If min_in_flight is
> >> initialized to -1, how does the server->in_flight < min_in_flight
> >> test ever return true?
> >
> > min_in_flight is declared as unsigned and then assigned to -1.
> > I'm relying on the compiler to use the max value for the unsigned int
> > based on this.
> > Perhaps I should have been more explicit by assigning this to
> > UINT_MAX. Will do so now.
> >
> >>
> >> Tom.
> >>
> >> On 12/20/2022 9:47 AM, Steve French wrote:
> >>> maybe a module load parm would be easier to use than kernel config
> >>> option (and give more realistic test comparison data for many)
> >>>
> >>> On Tue, Dec 20, 2022 at 7:29 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >>>>
> >>>> Hi Steve,
> >>>>
> >>>> Below is a patch for a new channel allocation strategy that we've been
> >>>> discussing for some time now. It uses the least loaded channel to send
> >>>> requests as compared to the simple round robin. This will help
> >>>> especially in cases where the server is not consuming requests at the
> >>>> same rate across the channels.
> >>>>
> >>>> I've put the changes behind a config option that has a default value of true.
> >>>> This way, we have an option to switch to the current default of round
> >>>> robin when needed.
> >>>>
> >>>> Please review.
> >>>>
> >>>> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/28b96fd89f7d746fc2b6c68682527214a55463f9.patch
> >>>>
> >>>> --
> >>>> Regards,
> >>>> Shyam
> >>>
> >>>
> >>>
> >
> >
> >



-- 
Regards,
Shyam
