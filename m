Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EFEEC54EBC
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Jan 2023 13:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbjAJNAo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Jan 2023 08:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbjAJNAn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Jan 2023 08:00:43 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C528517C3
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 05:00:42 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id m6-20020a9d7e86000000b0066ec505ae93so6902238otp.9
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 05:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Tiakb/Vhc9Y+qW9L6BW7yPXyekqDVxQwBTult65Zjcs=;
        b=GJ75itgKmOVg3qn571484I7664TWeplJPcu4z/4N2ZMliekS3cBTmrg9s76v15pvUE
         EzKi6p4nzlExwW9YJM13RVb/m0JbTBHwDYe2fshKKgBQmUqRmO3EfxTlxjWhNxzQhXOK
         U0mop3oOqw7G0CzgKgud3gsYOBSQ7DV7d22G3aw7GjX0uUjgOKCkuOWF5jgWw8PaBF/r
         lL0e1R9Z1zYLnkjiizYsdBkH3fL6mqAKEtS8KvoPSZNAU0ZcfRAm9433SR/hCJ95NG+Q
         heyVxibf7Rh+WJg69SUeUpvxtexzZ4Mf4hReQqaZR0iolY+LifQuCWKPQY8SZwBcveL6
         S0sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tiakb/Vhc9Y+qW9L6BW7yPXyekqDVxQwBTult65Zjcs=;
        b=I18mDwtH87OMWI0GD//rYIk0rkWLMyHjLB+iLoajEQXk9/O/wrfurxhPbfh2nadkJt
         bue0ItTQuZZx8tTGKtBZvjBL8egxReX5TrKFmQDoPS2POFWxOZhVCONkec7XyG+BHmSo
         YQjQOkF8p5WQcu6CBbLmjOQdiAB6XR4zddyKbNyiWvVClMDH2n0BpH3CPuEc6bynL4tZ
         0605oy4a6KFhDg7+D7GqGUgNl0ih3/4xj9LMGoPawDhiYddZPMFuBjEkaAerm5hCmZ/X
         Cz3Aiba3HDRm2bi1z9wzITz4tv+xGxo6/aOa3NR8uiO0P94uqAqWA+CxdTbvsAtO9/bt
         g6nw==
X-Gm-Message-State: AFqh2kog5cb/EWboiBVnZlcSdrF1bubKDhMRY/5lxaLajZeLDHERNliI
        SXspR+vAQiCnHF9diZx2dwwCI27lXVVhmrl0fjd42e8syzEvSw==
X-Google-Smtp-Source: AMrXdXvYnHdKYsJMTPmRNUP/26DIrSrm8cwTX4jHH5TdpnujW5Q3DTodLJWoDLWgCx9Pf7TZH9hpXBAyBkerVp9lRSk=
X-Received: by 2002:a05:6830:6010:b0:671:92e0:9bb9 with SMTP id
 bx16-20020a056830601000b0067192e09bb9mr1353988otb.302.1673355641337; Tue, 10
 Jan 2023 05:00:41 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=p5vHbitjNMCJ56xT48m0amNaWKhfnASCwcHha3ZvTErQ@mail.gmail.com>
In-Reply-To: <CANT5p=p5vHbitjNMCJ56xT48m0amNaWKhfnASCwcHha3ZvTErQ@mail.gmail.com>
From:   =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aurelien.aptel@gmail.com>
Date:   Tue, 10 Jan 2023 14:00:30 +0100
Message-ID: <CA+5B0FOrTzfqoij0NBTn8wnGodqpAtMCatkAfvpYGPmHp8aPzA@mail.gmail.com>
Subject: Re: Connection sharing in SMB multichannel
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>,
        Tom Talpey <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hey Shyam,

I remember thinking that channels should be part of the server too
when I started working on this but switched it up to session as I kept
working on it and finding it was the right choice.
I don't remember all the details so my comments will be a bit vague.

On Tue, Jan 10, 2023 at 10:16 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> 1.
> The way connections are organized today, the connections of primary
> channels of sessions can be shared among different sessions and their
> channels. However, connections to secondary channels are not shared.
> i.e. created with nosharesock.
> Is there a reason why we have it that way?
> We could have a pool of connections for a particular server. When new
> channels are to be created for a session, we could simply pick
> connections from this pool.
> Another approach could be not to share sockets for any of the channels
> of multichannel mounts. This way, multichannel would implicitly mean
> nosharesock. Assuming that multichannel is being used for performance
> reasons, this would actually make a lot of sense. Each channel would
> create new connection to the server, and take advantage of number of
> interfaces and RSS capabilities of server interfaces.
> I'm planning to take the latter approach for now, since it's easier.
> Please let me know about your opinions on this.

First, in the abstract models, Channels are kept in the Session object.
https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/8174c219-2224-4009-b96a-06d84eccb3ae

Channels and sessions are intertwined. Channels signing keys depend on
the session it is connected to (See "3.2.5.3.1 Handling a New
Authentication" and "3.2.5.3.3 Handling Session Binding").
Think carefully on what should be done on disconnect/reconnect.
Especially if the channel is shared with multiple sessions.

Problem with the pool approach is mount options might require
different connections so sharing is not so easy. And reconnecting
might involve different fallbacks (dfs) for different sessions.

You should see the server struct as the "final destination". Once it's
picked we know it's going there.

> 2.
> Today, the interface list for a server hangs off the session struct. Why?
> Doesn't it make more sense to hang it off the server struct? With my
> recent changes to query the interface list from the server
> periodically, each tcon is querying this and keeping the results in
> the session struct.
> I plan to move this to the server struct too. And avoid having to
> query this too many times unnecessarily. Please let me know if you see
> a reason not to do this.

It's more convenient to have the interface list at the same place as
the channel list but it could be moved I suppose.
In the abstract model it's in the server apparently.

> 4.
> I also feel that the way an interface is selected today for
> multichannel will not scale.
> We keep selecting the fastest server interface, if it supports RSS.
> IMO, we should be distributing the requests among the server
> interfaces, based on the interface speed adveritsed.

RSS means the interface can process packets in parallel queues. The
problem is we don't know how many queues it has.
I'm not sure you can find an optimal algorithm for all NIC
vendor/driver combinations. Probably you need to do some tests with a
bunch of different HW or find someone knowledgeable.
From my small experience now at mellanox/nvidia I have yet to see less
than 8 rx/combined queues. You can get/set the number with ethtool
-l/-L.
I've set the max channel connection to 16 at the time but I still
don't know what large scale high-speed deployment of SMB look like.
For what it's worth, in the NVMe-TCP tests I'm doing at the moment and
the systems we use to test (fio reads with a 100gbs eth nic with 63 hw
queues, 96 cores cpu on the host&target, reading from a null block
target), we get diminishing returns around 24 parallel connections. I
don't know how transferable this data point is.

On that topic, for best performance, some possible future project
could be to assign steering rules on the client to force each channel
packet processing on different cpus and making sure the cpus are the
same as the demultiplex thread (avoids context switches and
contentions). See
https://www.kernel.org/doc/Documentation/networking/scaling.txt
(warning, not an easy read lol)

Cheers,
