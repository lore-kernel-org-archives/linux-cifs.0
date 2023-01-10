Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664E7C54EBE
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Jan 2023 09:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjAJJRH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Jan 2023 04:17:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbjAJJQ7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Jan 2023 04:16:59 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A371544E6
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 01:16:55 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id d30so12458703lfv.8
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 01:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NsUxpSj0BfbZ519vFUTaAtUgxkGVbEXUObd/WrSFfnI=;
        b=Fl+lHwHrGnXOI59nKGSCloHslbAC0oLrDpSejz23Y7P/hlIHUVLrEHZ7UQf7FhWHPI
         DB9jT5akX06Vx4iP/kDiro0OfCpkAKMOOljhNdYOhi3534C9aa/mUXyuPDp7Q6wawBao
         8bH0vR39IGULcydGB1D9iib6MJZwNhCyApo5HrSKxWZiIIG8bSNKHRTYRIp74BOY4pE2
         HgCkWRE7HYm9E0MtzoXN4vY6FIsgkggEFErm8UBro0fuHHYAjiQ4bC35Nh02/TSE3x83
         rnfH/0WLCEM3lk+YROd7IbE7+KsrIWx8aAnfiKSYmwvcAEJMrxhjJaChXoLf96/JwydA
         ehkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NsUxpSj0BfbZ519vFUTaAtUgxkGVbEXUObd/WrSFfnI=;
        b=6gjJuf0I79tX/GxnGErIT7nPb2fla45gaq6gwkvcBPrTF5IQo2gAEr+jgZl/x0Hg1u
         bTdFK8KPmy/YHFSy3V75322zyrSOp/BaYdOhx0O5T+JYbWBnjOPyRIqfkcgvaTpDDjsG
         gfo6isb3o2rKGEU0KCesVed/joaeJwzaINLeXbpjv4P7B3+hSbQ8z6V+VfxvK5dBDzor
         KQq4/n5jPJq9MpN188A9PZ/xoOsKqL3Phf8LiKgnZWUm4SaiBM1YwPbujs81z0yl5vNu
         d+13gS/IeP/A7t+9gMk5mzkCr8XQxvwDcgpYGpJarztLgtt7dqIoToTA8bL5bY6bj3OD
         koLw==
X-Gm-Message-State: AFqh2koCAt5aH/bxRcQg7qZCntuYUOiJ34150lhZOasIhO0z55zdyNpK
        V/ZMowTV6kSRdNkT7yHd/BOhC/9YeoRlP+UjVMc=
X-Google-Smtp-Source: AMrXdXtEXvYfWI+hanKAIVWPyutKyhI3IEbigL/HKo2q6xayYrTlO4Jb5hXr6+N6IjpfFvCPJVe4l4RD0ed2TfabaRg=
X-Received: by 2002:a05:6512:3b8d:b0:4aa:f992:28aa with SMTP id
 g13-20020a0565123b8d00b004aaf99228aamr5295349lfv.459.1673342213730; Tue, 10
 Jan 2023 01:16:53 -0800 (PST)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 10 Jan 2023 14:46:42 +0530
Message-ID: <CANT5p=p5vHbitjNMCJ56xT48m0amNaWKhfnASCwcHha3ZvTErQ@mail.gmail.com>
Subject: Connection sharing in SMB multichannel
To:     Steve French <smfrench@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>,
        Tom Talpey <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aurelien.aptel@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi all,

I wanted to revisit the way we do a few things while doing
multichannel mounts in cifs.ko:

1.
The way connections are organized today, the connections of primary
channels of sessions can be shared among different sessions and their
channels. However, connections to secondary channels are not shared.
i.e. created with nosharesock.
Is there a reason why we have it that way?
We could have a pool of connections for a particular server. When new
channels are to be created for a session, we could simply pick
connections from this pool.
Another approach could be not to share sockets for any of the channels
of multichannel mounts. This way, multichannel would implicitly mean
nosharesock. Assuming that multichannel is being used for performance
reasons, this would actually make a lot of sense. Each channel would
create new connection to the server, and take advantage of number of
interfaces and RSS capabilities of server interfaces.
I'm planning to take the latter approach for now, since it's easier.
Please let me know about your opinions on this.

2.
Today, the interface list for a server hangs off the session struct. Why?
Doesn't it make more sense to hang it off the server struct? With my
recent changes to query the interface list from the server
periodically, each tcon is querying this and keeping the results in
the session struct.
I plan to move this to the server struct too. And avoid having to
query this too many times unnecessarily. Please let me know if you see
a reason not to do this.

3.
I saw that there was a bug in iface_cmp, where we did not do full
comparison of addresses to match them.
Fixed it here:
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/cef2448dc43d1313571e21ce8283bccacf01978e.patch

@Tom Talpey Was this your concern with iface_cmp?

4.
I also feel that the way an interface is selected today for
multichannel will not scale.
We keep selecting the fastest server interface, if it supports RSS.
IMO, we should be distributing the requests among the server
interfaces, based on the interface speed adveritsed.
Something on these lines:
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/ebe1ac3426111a872d19fea41de365b1b3aca0fe.patch

The above patch assigns weights to each interface (which is a function
of it's advertised speed). The weight is 1 for the interface that is
advertising minimum speed, and for any interface that does not support
RSS.
Please let me know if you have any opinions on this change.

====
Also, I did not find a good way to test out these changes yet i.e.
customize and change the QueryInterface response from the server on
successive requests.
So I've requested Steve not to take this into his branch yet.

I'm thinking I'll hard code the client code to generate different set
of dummy interfaces on every QueryInterface call.
Any ideas on how I can test this more easily will be appreciated.

-- 
Regards,
Shyam
