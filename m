Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CFA9C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Sep 2021 16:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16CDB610FB
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Sep 2021 16:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhINQZm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Sep 2021 12:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhINQZm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 Sep 2021 12:25:42 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A179C061762
        for <linux-cifs@vger.kernel.org>; Tue, 14 Sep 2021 09:24:24 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id y28so5811885lfb.0
        for <linux-cifs@vger.kernel.org>; Tue, 14 Sep 2021 09:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uU34i+EgJe3tqn17AWoGwVGTTIh0KVlY0SraTTmp6T0=;
        b=VZdty0cyn24mKo+cOeBnS1zUwWEVr/Aq14PaZvBBUD6vKS7TpA6mbyHIis/pVaXAaf
         SJ1YKxtYZYsZj/EY0JHr31tuvOq/g1o7mjxt6H1zfFHVSNCDSLB6nO1xycpBsN8+GLla
         CROAP4iHjqNA3Dw+oLPHZ225XyXcBn1WLfKpY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uU34i+EgJe3tqn17AWoGwVGTTIh0KVlY0SraTTmp6T0=;
        b=vGXkiy+Fle5yZtzae5nYJD00UTPeeC5rb4F652c5ZSDduQCdABpSA8rF1ltLodQcKt
         nhs00v3Te4r1vtwVevPEkmQHfvihuyTaW+R5/4MVb29k6rJYcDjcsvs6HWeB9tt6nE7q
         4hVhnczlJo+VgUgjyS3F1g28Ruze/368oz2TALMYfN2PFYgN5818SWuMS0sku0KLehXQ
         1OvGI0P9ZOMo5qTikkmx4QU4eHjTZdLS8VEFMnebdugon6FAOftNFNGq3VX27R200ZNS
         l4X55EGRapN6QaDXVjt6qmCJivdyv0NHi8R9tq2EWkoSIKKlZ12MTeKQIop/SpDl/hoI
         TEjg==
X-Gm-Message-State: AOAM53021O5HO6nKFrv7iZZOoDO3FzT174flB7OxnCdOHa21Okhsz8kB
        DUCC2Ie5DT795lqLJvK0WTyXER1x5hxoP/JarDk=
X-Google-Smtp-Source: ABdhPJxw3R4B+cpRLmS4wnyp6pzH0biN9+AO7l87f4SqBQv5ABZV++d5kYTsYWyrIvkYRNtGxT2FJg==
X-Received: by 2002:a05:6512:751:: with SMTP id c17mr13428975lfs.131.1631636662645;
        Tue, 14 Sep 2021 09:24:22 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id a22sm1164625lfb.17.2021.09.14.09.24.21
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 09:24:21 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id j12so24961994ljg.10
        for <linux-cifs@vger.kernel.org>; Tue, 14 Sep 2021 09:24:21 -0700 (PDT)
X-Received: by 2002:a2e:b53a:: with SMTP id z26mr15485756ljm.95.1631636661566;
 Tue, 14 Sep 2021 09:24:21 -0700 (PDT)
MIME-Version: 1.0
References: <163162767601.438332.9017034724960075707.stgit@warthog.procyon.org.uk>
 <CAHk-=wiVK+1CyEjW8u71zVPK8msea=qPpznX35gnX+s8sXnJTg@mail.gmail.com>
In-Reply-To: <CAHk-=wiVK+1CyEjW8u71zVPK8msea=qPpznX35gnX+s8sXnJTg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 14 Sep 2021 09:24:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgR_unCDRZ+8iTb5gBO6bgRkuS4JYBpi25v12Yp6TzWVA@mail.gmail.com>
Message-ID: <CAHk-=wgR_unCDRZ+8iTb5gBO6bgRkuS4JYBpi25v12Yp6TzWVA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] fscache: Replace and remove old I/O API
To:     David Howells <dhowells@redhat.com>
Cc:     Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        v9fs-developer@lists.sourceforge.net,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        linux-cachefs@redhat.com, CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Sep 14, 2021 at 9:21 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Call it "fallback" or "simple" or something that shows the intent, but
> no, I'm not taking patches that introduce a _new_ interface and call
> it "deprecated".

Put another way: to call something "deprecated", you have to already
have the replacement all ready to go.

And if you have that, then converting existing code to a deprecated
model isn't the way to go.

So in neither situation does it make any sense to convert anything to
a model that is deprecated.

          Linus
