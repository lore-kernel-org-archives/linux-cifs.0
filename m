Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 025EEC5479D
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Jan 2023 09:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbjAKJaH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Jan 2023 04:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbjAKJ2E (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Jan 2023 04:28:04 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9AB8FCC
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jan 2023 01:27:46 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id cf42so22617101lfb.1
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jan 2023 01:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=t95RAmLSiklWLu65kyjRwVE8Ami/UbpswRIB8cS+hW4=;
        b=IaXgyrIvTASf33vifmYPZx8XKgOpuUhqswTW4KqIia+eX/JyEvhrNNULoRHPwCBHdo
         rEeq2xyYYGwRP+VFpOaU89jSWFFh4uJPizRqZ1UwswD0kEAhmxOzQta0omxH66m2wgYj
         iXIOW+2IlogLRGj4weFY4rwDbhwnW8JaKqJG1VLv1htMS0PfwzrdV0iyYclXuf/6pv3a
         2lV0XNJA0fgQoKcEC2lIYU/GfkBc6wdGFeFj9zW/kbk0zPFdrXx7N3NT2HGrwciTXgz+
         g1QVaNL15cLUancUrMA7ZP/92K7CknGtAucejNR6x24t1eMX3Uj+cI2P60sZy4YfKPq7
         MitA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t95RAmLSiklWLu65kyjRwVE8Ami/UbpswRIB8cS+hW4=;
        b=NXNUH3oVZVyW2lDm3hd9Rpm88e3tFmMBIBnVSIk5iWcZPmNERArcZVpe8kNgTDkNqv
         jrkVI3i8+8eb3d9qQJFUbR5mvYuMWdW4Pdyt9hA19poEftHiDIMoCvojFDsJ8jpulLiP
         2lXc2S2GkrsMGnL7v7zSvaplbjtXbiPbV4rMhB+2gKbBfmbmu5DdGoX2nFypJNml25Jn
         kQ1WzRWKqbs+bszWq9Z4njgwZ0FnWPmcjaGkd9zao8MJww/BERKXx3xxEqQCCGPmKKHG
         ckTxMPncZTVNCKYtZvUIuiuiKN/11EAo99QA/xU/RFvcIxNDgNX9PAtz8PWzuAq7oXii
         vaWQ==
X-Gm-Message-State: AFqh2kqf1vOZbpSCxAoH2eBLdxjl+irrvILGCmuXBwhSQkPB332VhoS2
        KfqE2eseGx2qORDbhHIpcgNsDNZL+46dc8E1aa4=
X-Google-Smtp-Source: AMrXdXtowW97x3r9OzRJt8AJHaphIuOpcWo8FUCzH14ed/miyF91SLgNq2WFhariuqwzA10wdE+KZf91UzZjPqyShqg=
X-Received: by 2002:a05:6512:552:b0:4b5:9233:6e9b with SMTP id
 h18-20020a056512055200b004b592336e9bmr6725465lfl.394.1673429264321; Wed, 11
 Jan 2023 01:27:44 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=p5vHbitjNMCJ56xT48m0amNaWKhfnASCwcHha3ZvTErQ@mail.gmail.com>
 <20230110171853.ysh7svc5gxgnzlxp@suse.de>
In-Reply-To: <20230110171853.ysh7svc5gxgnzlxp@suse.de>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 11 Jan 2023 14:57:32 +0530
Message-ID: <CANT5p=rg8tvEtx_W-edhO5q9kDJECXpq=gDfj1Zo5mEtKYbVHg@mail.gmail.com>
Subject: Re: Connection sharing in SMB multichannel
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Steve French <smfrench@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>,
        Tom Talpey <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aurelien.aptel@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Jan 10, 2023 at 10:48 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> Hi Shyam,
>
> I 100% agree with your proposed changes. I came up with an idea and got
> to draw a diagram a while ago that would handle multichannel connections
> in a similar way you propose here.
>
> https://exis.tech/cifs-multicore-multichannel.png
>
> The main idea is to have the 'channels' (sockets) pool for a particular
> server, but also create submission/receiving queues (SQ/RQ) (similar to NVMe
> and io_uring) for each online CPU.  Then each CPU/queue is free to send
> to any of the available channels, based on whatever algorithm is chosen
> (RR, free channel, fastest NIC, etc).
>
> I still haven't got time to design the receiving flow, but it shouldn't
> change much from the reverse of the sending side.
>
> Of course, there's a lot to improve/fix in that design, but something I
> thought would enhance cifs multichannel performance a lot.
>
> I've discussed this idea with Paulo a while back, and he already
> provided me with great improvements/fixes for this.  Since I still
> haven't got the time to work on it, I hope this to serve as inspiration.
>
>
> Cheers,
>
> Enzo

Hi Enzo,

This is some detailed analysis here.
I'm not sure that I fully understand the proposed changes though.
We should discuss this further.

>
> On 01/10, Shyam Prasad N wrote:
> >Hi all,
> >
> >I wanted to revisit the way we do a few things while doing
> >multichannel mounts in cifs.ko:
> >
> >1.
> >The way connections are organized today, the connections of primary
> >channels of sessions can be shared among different sessions and their
> >channels. However, connections to secondary channels are not shared.
> >i.e. created with nosharesock.
> >Is there a reason why we have it that way?
> >We could have a pool of connections for a particular server. When new
> >channels are to be created for a session, we could simply pick
> >connections from this pool.
> >Another approach could be not to share sockets for any of the channels
> >of multichannel mounts. This way, multichannel would implicitly mean
> >nosharesock. Assuming that multichannel is being used for performance
> >reasons, this would actually make a lot of sense. Each channel would
> >create new connection to the server, and take advantage of number of
> >interfaces and RSS capabilities of server interfaces.
> >I'm planning to take the latter approach for now, since it's easier.
> >Please let me know about your opinions on this.
> >
> >2.
> >Today, the interface list for a server hangs off the session struct. Why?
> >Doesn't it make more sense to hang it off the server struct? With my
> >recent changes to query the interface list from the server
> >periodically, each tcon is querying this and keeping the results in
> >the session struct.
> >I plan to move this to the server struct too. And avoid having to
> >query this too many times unnecessarily. Please let me know if you see
> >a reason not to do this.
> >
> >3.
> >I saw that there was a bug in iface_cmp, where we did not do full
> >comparison of addresses to match them.
> >Fixed it here:
> >https://github.com/sprasad-microsoft/smb3-kernel-client/commit/cef2448dc43d1313571e21ce8283bccacf01978e.patch
> >
> >@Tom Talpey Was this your concern with iface_cmp?
> >
> >4.
> >I also feel that the way an interface is selected today for
> >multichannel will not scale.
> >We keep selecting the fastest server interface, if it supports RSS.
> >IMO, we should be distributing the requests among the server
> >interfaces, based on the interface speed adveritsed.
> >Something on these lines:
> >https://github.com/sprasad-microsoft/smb3-kernel-client/commit/ebe1ac3426111a872d19fea41de365b1b3aca0fe.patch
> >
> >The above patch assigns weights to each interface (which is a function
> >of it's advertised speed). The weight is 1 for the interface that is
> >advertising minimum speed, and for any interface that does not support
> >RSS.
> >Please let me know if you have any opinions on this change.
> >
> >====
> >Also, I did not find a good way to test out these changes yet i.e.
> >customize and change the QueryInterface response from the server on
> >successive requests.
> >So I've requested Steve not to take this into his branch yet.
> >
> >I'm thinking I'll hard code the client code to generate different set
> >of dummy interfaces on every QueryInterface call.
> >Any ideas on how I can test this more easily will be appreciated.
> >
> >--
> >Regards,
> >Shyam



-- 
Regards,
Shyam
