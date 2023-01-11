Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5439BC5479D
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Jan 2023 10:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjAKKGK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Jan 2023 05:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbjAKKEg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Jan 2023 05:04:36 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B377F5A
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jan 2023 02:01:58 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id e13so15523884ljn.0
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jan 2023 02:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PCtV0QI1LlIvDoSIIVB4V8S+QinvWJz57qqe58f5mV8=;
        b=YvvIMFkjCXesmfTAP0FWpNynGqglG99LdKTxK94zLvWPXmZh37Rivmp5wWHnpDQl2R
         IMd8EH5SuFYbDfGO2UHx1uzhsYToE2lc7WhvleA64X+uCr9hyVuf0NVDCLWhLISs1OGQ
         5CpUc4H4s+zwQxCcPMvsO8zx4Oj8J2hmp5tDjfDjiNKf9cwVP30QL4u9fP+u9UbiDC/R
         IecL7e5EE86yQ9Sr9b9fjTqpboU92fVsIHw2gTflkeDFDEIRCXm5dbqu0x4Cb5NAz9je
         MN1lxB0WsgRy4ze/iioNCU5C/bjCpJ2TrC4qwmHLrJ/ZdlZ3KTFiJckKhF0FoBzQczlC
         gYuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PCtV0QI1LlIvDoSIIVB4V8S+QinvWJz57qqe58f5mV8=;
        b=HWsgxmRJdfY8S1uUYYHevXwaE6mp3eB20yjm0nwTZb4DNBuaUKpLRQF9BeclWcfv0V
         MWJkFGLGVQwc6kxTrInq3joI9L/hZ0EdBOPUydqrgNma4NdmqxQOUE2j+5XPTIuD1Bm7
         1qvE4p2G2Zmrkgy7P28BKIoZc/J9l1DTduNtzH73XRu9GelNUcNKseTpq1cNuP8Dg3an
         RoS5BOoCp7vsgykkUfk6ObIKxs3yuPGdQpEYwedep2UOtT1plgcarw7ns1rw7V92qEVj
         Tz8ZPJ6tRg4n16fwIFxpAMaEnlN1NLsvqX4I2PJcHfQb0lD74ClI1Z0wWsT3tqy9GUqL
         hHcg==
X-Gm-Message-State: AFqh2kosax9k4hPKX/oI2l/iFpJSHjM4RJp75znezWBFJbp3zo5Mitbv
        XMS2kQy0SE8dU35hrEj4yyalEx+8BhF3K8ZOfYg=
X-Google-Smtp-Source: AMrXdXuI6fBEakYniVaSdfIbZ143JFJYBW6dOSC0ZkzG1JT04EgleaWDrdobbMXy418YEq22bfeyewFg7yIxbugibEo=
X-Received: by 2002:a2e:a5c5:0:b0:280:5b72:c3ce with SMTP id
 n5-20020a2ea5c5000000b002805b72c3cemr1850654ljp.203.1673431316853; Wed, 11
 Jan 2023 02:01:56 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=p5vHbitjNMCJ56xT48m0amNaWKhfnASCwcHha3ZvTErQ@mail.gmail.com>
 <CA+5B0FOrTzfqoij0NBTn8wnGodqpAtMCatkAfvpYGPmHp8aPzA@mail.gmail.com> <c928a1db-1240-4fc1-2034-cfbdcf536c51@talpey.com>
In-Reply-To: <c928a1db-1240-4fc1-2034-cfbdcf536c51@talpey.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 11 Jan 2023 15:31:45 +0530
Message-ID: <CANT5p=rOTYxahfWrsBEmUhs+RRNGfWxjxyD-ROfaP43Q6LKd+g@mail.gmail.com>
Subject: Re: Connection sharing in SMB multichannel
To:     Tom Talpey <tom@talpey.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aurelien.aptel@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Tom,

Thanks for the review.
Please read my comments below.

On Wed, Jan 11, 2023 at 7:47 AM Tom Talpey <tom@talpey.com> wrote:
>
> On 1/10/2023 8:00 AM, Aur=C3=A9lien Aptel wrote:
> > Hey Shyam,
> >
> > I remember thinking that channels should be part of the server too
> > when I started working on this but switched it up to session as I kept
> > working on it and finding it was the right choice.
>
> Channels are absolutely a property of the session. Server multichannel
> enables their use, but the decision to actually use them is per-session.

Agreed. I'm not proposing to change that.
>
> > I don't remember all the details so my comments will be a bit vague.
> >
> > On Tue, Jan 10, 2023 at 10:16 AM Shyam Prasad N <nspmangalore@gmail.com=
> wrote:
> >> 1.
> >> The way connections are organized today, the connections of primary
> >> channels of sessions can be shared among different sessions and their
> >> channels. However, connections to secondary channels are not shared.
> >> i.e. created with nosharesock.
> >> Is there a reason why we have it that way?
>
> That sounds wrong. Normally we want to share connections, to preserve
> resources. Howe3ver, for certain greedy flows, it may be a good idea to
> create dedicated channels (connections). This is a policy decision, and
> should not be wired-in.

Yeah. We only share primary channels today with other sessions.
I plan to change this in two stages. First, will enforce nosharesock
for multichannel.
I'll submit another patch later to reuse existing connections, unless
the user has explicitly used nosharesock as a mount option.

>
> >> We could have a pool of connections for a particular server. When new
> >> channels are to be created for a session, we could simply pick
> >> connections from this pool.
>
> Yes and no. There are similar reasons to avoid using pooled channels.
> Performance is one obvious one - some connections may be faster (RDMA),
> or tuned for specific advantages (lower latency, more secure). Selection
> of channel should allow for certain types of filtering.

For users looking for performance, we could advise that they mount
with nosharesock, in addition to multichannel. That way, those
connections would be dedicated to only that session, and will not be
shared.
For others (maybe they're using multichannel for network tolerance),
we make use of connection pool.

>
> >> Another approach could be not to share sockets for any of the channels
> >> of multichannel mounts. This way, multichannel would implicitly mean
> >> nosharesock. Assuming that multichannel is being used for performance
> >> reasons, this would actually make a lot of sense. Each channel would
> >> create new connection to the server, and take advantage of number of
> >> interfaces and RSS capabilities of server interfaces.
> >> I'm planning to take the latter approach for now, since it's easier.
> >> Please let me know about your opinions on this.
> >
> > First, in the abstract models, Channels are kept in the Session object.
> > https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/8=
174c219-2224-4009-b96a-06d84eccb3ae
> >
> > Channels and sessions are intertwined. Channels signing keys depend on
> > the session it is connected to (See "3.2.5.3.1 Handling a New
> > Authentication" and "3.2.5.3.3 Handling Session Binding").
> > Think carefully on what should be done on disconnect/reconnect.
> > Especially if the channel is shared with multiple sessions.
>
> Yes, absolutely. Shared channels require careful processing when a
> disconnect is used. It's incredibly rude to close a shared connection.

I agree. But we do that today when sessions share a connection.

>
> > Problem with the pool approach is mount options might require
> > different connections so sharing is not so easy. And reconnecting
> > might involve different fallbacks (dfs) for different sessions.
> >
> > You should see the server struct as the "final destination". Once it's
> > picked we know it's going there.
> >
> >> 2.
> >> Today, the interface list for a server hangs off the session struct. W=
hy?
> >> Doesn't it make more sense to hang it off the server struct? With my
> >> recent changes to query the interface list from the server
> >> periodically, each tcon is querying this and keeping the results in
> >> the session struct.
> >> I plan to move this to the server struct too. And avoid having to
> >> query this too many times unnecessarily. Please let me know if you see
> >> a reason not to do this.
>
> This makes sense, but only if the channel selection is sensibly
> filterable. A non-RDMA mount should not be selecting an RDMA
> channel. An encrypted share may want to prefer an adapter which
> can support bus or CPU affinity. Etc.

This is interesting. I should be able to do the RDMA filtering based
on whether the mount specified rdma as an option.
How do we know whether the server adapter can support bus or CPU
affinity? The only two capabilities that the server can advertise are
RSS_CAPABLE or RDMA_CAPABLE.
https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/fcd86=
2d1-1b85-42df-92b1-e103199f531f

>
> > It's more convenient to have the interface list at the same place as
> > the channel list but it could be moved I suppose.
> > In the abstract model it's in the server apparently.
> >
> >> 4.
> >> I also feel that the way an interface is selected today for
> >> multichannel will not scale.
> >> We keep selecting the fastest server interface, if it supports RSS.
> >> IMO, we should be distributing the requests among the server
> >> interfaces, based on the interface speed adveritsed.
>
> That's part of it, definitely. "Fastest" is hard to measure. Fast
> as in latency? Bandwidth? CPU overhead?

Fast as in advertised speed in the query interface response i.e. bandwidth.

>
> > RSS means the interface can process packets in parallel queues. The
> > problem is we don't know how many queues it has.
>
> Yup. RSS is only a hint. It's not a metric.
>
> > I'm not sure you can find an optimal algorithm for all NIC
> > vendor/driver combinations. Probably you need to do some tests with a
> > bunch of different HW or find someone knowledgeable.
> >  From my small experience now at mellanox/nvidia I have yet to see less
> > than 8 rx/combined queues. You can get/set the number with ethtool
> > -l/-L.
>
> RSS is only meaningful on the machine doing the receiving, in this
> case, the server. The client has no clue how to optimize that. But
> assuming a handful of RSS queues is a good idea. Personally I'd
> avoid a number as large as 8. But over time, cores are increasing,
> so it's a crapshoot.

I could modify my patch to take an interleaved weighted round robin,
so that each new connection is done to the next server interface.
This would ensure that the number of connections to each server
interface would be evenly shared.

>
> > I've set the max channel connection to 16 at the time but I still
> > don't know what large scale high-speed deployment of SMB look like.
> > For what it's worth, in the NVMe-TCP tests I'm doing at the moment and
> > the systems we use to test (fio reads with a 100gbs eth nic with 63 hw
> > queues, 96 cores cpu on the host&target, reading from a null block
> > target), we get diminishing returns around 24 parallel connections. I
> > don't know how transferable this data point is.
>
> 16 seems high, especially on a gigabit interface. At hundreds of Gb,
> well, that's possibly different. I'd avoid making too many assumptions
> (guesses!).
>
> Tom.
>
> > On that topic, for best performance, some possible future project
> > could be to assign steering rules on the client to force each channel
> > packet processing on different cpus and making sure the cpus are the
> > same as the demultiplex thread (avoids context switches and
> > contentions). See
> > https://www.kernel.org/doc/Documentation/networking/scaling.txt
> > (warning, not an easy read lol)
> >
> > Cheers,
> >



--=20
Regards,
Shyam
