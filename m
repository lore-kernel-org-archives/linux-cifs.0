Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B64D1C4332F
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Dec 2022 14:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiLWOQc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Dec 2022 09:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiLWOQb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Dec 2022 09:16:31 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DB617E05
        for <linux-cifs@vger.kernel.org>; Fri, 23 Dec 2022 06:16:29 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id y4so5141594ljc.9
        for <linux-cifs@vger.kernel.org>; Fri, 23 Dec 2022 06:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=svTJoL6IQTh903zAmrlrC4wMMencUFmD7aklOmuO+DI=;
        b=WMaQsGms4O3N7AIwaFNGkL1NjFxiae+bTQkV/SVi19r/ur8eJcQr+EycWpFWBHi7zr
         vCtiFz43HnDEYUPMebYjiwmJhBDDPAQ9sWc1I0uFLPd66xy1k8OoqWfove51MN8FXnPh
         3Z/59H7Lg7i6KcCmhOuCcgbAdOi6eZPLut2xc6OS//i6JDoFcq0RCrqKVK8Xyz2DWzpb
         6SAuKinEKzUJesH9CxAagc3QyHdgnGnzkdKsrsYrYRz3+O5de0+9xWaFvgREqbEDeamn
         crH+jto45y/k9t5FvjbruWDWCUCkTJlLMGMf2P2fhsWNg8YjMQGIXcbnqXvBgwvjhpm0
         2g1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=svTJoL6IQTh903zAmrlrC4wMMencUFmD7aklOmuO+DI=;
        b=E49zimPFrlk0ytNRsCAK19v6rtsUt8YT7TTOYFpZISeNtEYYyWz2rr+nogohNj7h9P
         H7iB2piYeJZ5u8MZxkQpiWCxmRi/pAHQEpnDwchnN8gXEiqDBNyhWviIYKhZH0U06QZx
         YMUe2DfOFQVAciNJlqy3IR4uK9Nogz9hn3zc86omK0eizdJ6WFcYeJtf/JbAJj+SrWqt
         TWflT0zT9TFkZHoYf73s3vBxHQ09vDn4sDHu4lIWgh8gYRw6On9tr3C7n2solLYBrwQG
         ZrFnWJ6H/mbIOkEtff4BR0TS1hh2sy0Ff/xN57+ZWAI+Zl6JDDmJzvme8YtnaTYA38oA
         7AFg==
X-Gm-Message-State: AFqh2ko5bhv+kUr33ctF3CzsyfP0Cx6RHYtyt6/BbSjVdLLylw/KT5vF
        aPT0ipiPc654uUqndGuYJPvfGp6NjpHnZfG1eFM=
X-Google-Smtp-Source: AMrXdXtwOUWuSF0I7XjcF4U8H/zaEiJ2r2N2/d3dXy7UtqvjZpTNLhCE/liqN1/SVSkx/txCFVUJLwigsFe7UKTP58Q=
X-Received: by 2002:a2e:9c9a:0:b0:279:e618:445d with SMTP id
 x26-20020a2e9c9a000000b00279e618445dmr395889lji.182.1671804988073; Fri, 23
 Dec 2022 06:16:28 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=oKQEB6HnopL=jAd0pxd-+OukcfrVgc76X-suShqUiA9w@mail.gmail.com>
 <CAH2r5muGBpwvpt6tTXDj2s=UHhJyG1=p94mcTaZ7QbrpuZ2R+w@mail.gmail.com>
 <6b39f048-b292-a0fd-af8a-abad97d22ed7@talpey.com> <CANT5p=rje_XAHySDoxL50C6=EUkvdawN4neU+0xyvFDLAbYW6A@mail.gmail.com>
 <73b86766-75cf-cc1e-0d21-01eaeea71a49@talpey.com> <CANT5p=pTu848=CUK_FqNk=BB+QcecBAkSysp6WxA62krX4rDbQ@mail.gmail.com>
In-Reply-To: <CANT5p=pTu848=CUK_FqNk=BB+QcecBAkSysp6WxA62krX4rDbQ@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 23 Dec 2022 19:46:16 +0530
Message-ID: <CANT5p=pGnUAFLSCdadAzv9JNNmr8A-OsLcXzCFogQYtMQOzLhw@mail.gmail.com>
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

On Thu, Dec 22, 2022 at 3:26 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> On Wed, Dec 21, 2022 at 10:17 PM Tom Talpey <tom@talpey.com> wrote:
> >
> > Question on this:
> >
> >  > We will not be mixing traffic here. Channel bandwidth and type are
> >  > considered while establishing a new channel.
> >  > This change is only for distributing the requests among the channels
> >  > for the session.
> >
> > I disagree. The iface_cmp() function in cifsglob.h returns a positive
> > value for all interfaces which are as fast or faster than the one
> > being compared-to. And weirdly, it only looks at rdma_capable when the
> > speeds are equal, and it ignores rss_capable unless rdma_capable
> > matches.
> >
>
> Hi Tom,
>
> What I meant by my statement was that this change does not modify the
> decision about which server interface the channels are connected to.
>
> You are right about what iface_cmp does.
> The goal of this function was to compare two interfaces, and return 1
> if interface 'a' is more preferred; 0 if both are the same; and -1 if
> b is preferred.
> The one that is preferred sits closer to the head of the list after
> parse_server_interfaces.
> The "preference" is based on 3 factors:
> 1. speed
> 2. rdma_capable
> 3. rss_capable
> I missed the case where interfaces could have both rdma and rss
> capability. Will fix that soon.
>
> Do you see any problem if channels of the same session mix rdma/rss
> capable interfaces?
> I've kept the overall logic the same as before my changes.
>
> > It also makes the following questionable assumption:
> >
> >      * The iface_list is assumed to be sorted by speed.
> >
> > In parse_server_interfaces(), new eligible entries are added in the
> > order the server returns them. The protocol doesn't require this! It's
> > entirely implementation specific.
>
> If the server returns interfaces of different speeds, the end result
> of parse_server_interfaces is in decreasing order of speed; then rdma
> capable; then rss capable interfaces.
> The protocol does not require this. But the implementation we had
> always chose to connect to the fastest interfaces first.
>
> >
> > In any event, I think if the client connects to a server on a 1GbE
> > interface, and discovers a 10GbE one, it will mix traffic on both.
> > In the current code, every other operation will switch interfaces.
> > In your code, it will only slightly prefer the 10GbE, when bulk data
> > begins to backlog the 1GbE.
>
> Again, do you see a problem in mixing the interfaces, if we make
> connections based on the speed of the connection?
> I plan to change this logic to do a weighted distribution of channels
> among interfaces (weight decided by speed of the interface), instead
> of simply choosing the fastest one.
> That way, parse_server_interfaces will not need to sort anymore.
>
> >
> > So, unless you fix iface_cmp, and rework the selection logic in
> > parse_server_interfaces, I don't think the change does much.
> >
> > What about the runtime selection?
>
> It should not be necessary.
>
> I spoke to Steve about this yesterday. He doesn't mind doing away with
> the old logic of simple round robin too.
> However, when in-flight == 0 for all channels, he feels that we should
> not favour the same channel all the time.
> So I'm planning to make some modifications to the current code in that
> direction.
>

Here's the updated version of the patch:
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/ea9b6b0d65756e55e4f6b89313da6bda61687929.patch
@Steve French @Tom Talpey Please review.

I'm working on another patch for interface selection while creating a
new channel.
Will send that out soon.

> >
> > Tom.
> >
> >
> >
> > On 12/21/2022 10:33 AM, Shyam Prasad N wrote:
> > > On Tue, Dec 20, 2022 at 11:48 PM Tom Talpey <tom@talpey.com> wrote:
> > >>
> > >> I'd suggest a runtime configuration, personally. A config option
> > >> is undesirable, because it's very difficult to deploy. A module
> > >> parameter is only slightly better. The channel selection is a
> > >> natural for a runtime per-operation decision. And for the record,
> > >> I think a round-robin selection is a bad approach. Personally
> > >> I'd just yank it.
> > >
> > > Hi Tom,
> > >
> > > Thanks for taking a look at this.
> > > I was considering doing so. But was unsure if we'll still need a way
> > > to do round robin.
> > > Steve/Aurelien: Any objections to just remove the round-robin approach?
> > >
> > >>
> > >> I'm uneasy about ignoring the channel bandwidth and channel type.
> > >> Low bandwidth channels, or mixing RDMA and non-RDMA, are going to
> > >> be very problematic for bulk data. In fact, the Windows client
> > >> never mixes such alternatives, it always selects identical link
> > >> speeds and transport types. The traffic will always find a way to
> > >> block on the slowest/worst connection.
> > >>
> > >> Do you feel there is some advantage to mixing traffic? If so, can
> > >> you elaborate on that?
> > >
> > > We will not be mixing traffic here. Channel bandwidth and type are
> > > considered while establishing a new channel.
> > > This change is only for distributing the requests among the channels
> > > for the session.
> > >
> > > That said, those decisions are sub-optimal today, IMO.
> > > I plan to send out some changes there too.
> > >
> > >>
> > >> The patch you link to doesn't seem complete. If min_in_flight is
> > >> initialized to -1, how does the server->in_flight < min_in_flight
> > >> test ever return true?
> > >
> > > min_in_flight is declared as unsigned and then assigned to -1.
> > > I'm relying on the compiler to use the max value for the unsigned int
> > > based on this.
> > > Perhaps I should have been more explicit by assigning this to
> > > UINT_MAX. Will do so now.
> > >
> > >>
> > >> Tom.
> > >>
> > >> On 12/20/2022 9:47 AM, Steve French wrote:
> > >>> maybe a module load parm would be easier to use than kernel config
> > >>> option (and give more realistic test comparison data for many)
> > >>>
> > >>> On Tue, Dec 20, 2022 at 7:29 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > >>>>
> > >>>> Hi Steve,
> > >>>>
> > >>>> Below is a patch for a new channel allocation strategy that we've been
> > >>>> discussing for some time now. It uses the least loaded channel to send
> > >>>> requests as compared to the simple round robin. This will help
> > >>>> especially in cases where the server is not consuming requests at the
> > >>>> same rate across the channels.
> > >>>>
> > >>>> I've put the changes behind a config option that has a default value of true.
> > >>>> This way, we have an option to switch to the current default of round
> > >>>> robin when needed.
> > >>>>
> > >>>> Please review.
> > >>>>
> > >>>> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/28b96fd89f7d746fc2b6c68682527214a55463f9.patch
> > >>>>
> > >>>> --
> > >>>> Regards,
> > >>>> Shyam
> > >>>
> > >>>
> > >>>
> > >
> > >
> > >
>
>
>
> --
> Regards,
> Shyam



-- 
Regards,
Shyam
