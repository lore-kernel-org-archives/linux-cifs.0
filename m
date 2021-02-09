Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E07EDC433E0
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 23:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D93364E3F
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 23:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbhBIXlh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Feb 2021 18:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbhBIWHM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Feb 2021 17:07:12 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC84BC061788
        for <linux-cifs@vger.kernel.org>; Tue,  9 Feb 2021 13:19:19 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id v5so28390466lft.13
        for <linux-cifs@vger.kernel.org>; Tue, 09 Feb 2021 13:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5NXrj70SaJJJRtMQWC0+3w4cmGywCfZjtndBL9rb8Bo=;
        b=g8n7RWB/hph+MNS6KsfC0GffC4feoLtbwfzXkMDO5VGlvyK682yT02RPRIOW6hieUR
         nxG1Mlzbyp5mtI1Do4dwBB4pr2NfNtLSNxuXGIfX+Az+7iAT6uxAH+/kuEuPZoNDiHrT
         JX8A9+J4I4DIw7KDC1ACDk8XTP+nwuXWBZL+g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5NXrj70SaJJJRtMQWC0+3w4cmGywCfZjtndBL9rb8Bo=;
        b=HeoMfQJ9uttZlKAIutKCIfnukzqmaq+yB6Nu86MRcwPw12Jj975J82MbZWojD4I1pp
         ay8v6oSYIpUT+escA8WNy03AlzK3BsgLkMv4sOIAWPl3lpbPRlFwG8aGHG2wnip/dY1F
         0QJDnYrbrVYuzx+VvYvVHi+4hGaqF1KDI23HqeohN0gHk7/39Ax93G3trJZ1U1VROPv/
         NGyXWyvpvc/ytzdcMpzIh0LugQxmCNiIbbrG7QC6T1UNxUfsOFigjAOxvB3SZra6Wg4J
         NCLOR2WrPbSr0TEH+qSkYv9zta7DxuzMO3nyBIV/Ou8Vdvh4hQjJH8E01fDldP+84Vf6
         3poA==
X-Gm-Message-State: AOAM532rttzGdgqlWLW+IYVtCvFltjZC18YXE3eH1PdR5wd09ZoInNfs
        Zbae89ft7vGJn9Lh7PCMfpom2RexYezwvA==
X-Google-Smtp-Source: ABdhPJxrtHl1eKIiU6c5vHi7IqgsUWnRVRSk3kYaz/kOFmC+MNXnPWlP0EtpHe3eNHHE6f6kA3rt4g==
X-Received: by 2002:a05:6512:358d:: with SMTP id m13mr14114353lfr.648.1612905558449;
        Tue, 09 Feb 2021 13:19:18 -0800 (PST)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id v68sm1043315lfa.137.2021.02.09.13.19.17
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 13:19:18 -0800 (PST)
Received: by mail-lj1-f176.google.com with SMTP id a22so5280ljp.10
        for <linux-cifs@vger.kernel.org>; Tue, 09 Feb 2021 13:19:17 -0800 (PST)
X-Received: by 2002:a2e:b1c8:: with SMTP id e8mr15253931lja.251.1612905557284;
 Tue, 09 Feb 2021 13:19:17 -0800 (PST)
MIME-Version: 1.0
References: <591237.1612886997@warthog.procyon.org.uk> <CAHk-=wj-k86FOqAVQ4ScnBkX3YEKuMzqTEB2vixdHgovJpHc9w@mail.gmail.com>
 <20210209202134.GA308988@casper.infradead.org>
In-Reply-To: <20210209202134.GA308988@casper.infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 9 Feb 2021 13:19:01 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh+2gbF7XEjYc=HV9w_2uVzVf7vs60BPz0gFA=+pUm3ww@mail.gmail.com>
Message-ID: <CAHk-=wh+2gbF7XEjYc=HV9w_2uVzVf7vs60BPz0gFA=+pUm3ww@mail.gmail.com>
Subject: Re: [GIT PULL] fscache: I/O API modernisation and netfs helper library
To:     Matthew Wilcox <willy@infradead.org>
Cc:     David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        David Wysochanski <dwysocha@redhat.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        ceph-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cachefs@redhat.com, CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        v9fs-developer@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Feb 9, 2021 at 12:21 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> Yeah, I have trouble with the private2 vs fscache bit too.  I've been
> trying to persuade David that he doesn't actually need an fscache
> bit at all; he can just increment the page's refcount to prevent it
> from being freed while he writes data to the cache.

Does the code not hold a refcount already?

Honestly, the fact that writeback doesn't take a refcount, and then
has magic "if writeback is set, don't free" code in other parts of the
VM layer has been a problem already, when the wakeup ended up
"leaking" from a previous page to a new allocation.

I very much hope the fscache bit does not make similar mistakes,
because the rest of the VM will _not_ have special "if fscache is set,
then we won't do X" the way we do for writeback.

So I think the fscache code needs to hold a refcount regardless, and
that the fscache bit is set the page has to have a reference.

So what are the current lifetime rules for the fscache bit?

             Linus
