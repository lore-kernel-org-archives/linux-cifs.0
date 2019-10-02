Return-Path: <SRS0=Gq5t=X3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 765E5ECE587
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Oct 2019 01:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4592F20873
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Oct 2019 01:35:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GEIq/Ki3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbfJBBfo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Oct 2019 21:35:44 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34923 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729676AbfJBBfn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Oct 2019 21:35:43 -0400
Received: by mail-ed1-f66.google.com with SMTP id v8so13744949eds.2;
        Tue, 01 Oct 2019 18:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Tc3oEsXss3L57smcg7ET5YqKd/3q1IBNjIpWHSb/fJo=;
        b=GEIq/Ki30tVD1G/ULWtFJFur8kJhcmFiMY+RFm8a2l3TslyzqlV1XKFXcY6yCm33EY
         7ce+RL4sYllsb7v0fs4Ugs6sjYUfJ+VmqT2Mlt6BZwv0pzMc7xpo6OVZg6T8SW6WAn6/
         ofU1K5X1d6JEbb3tFKhybysHXe6TLYkWiluzuBe85qvSqF8i8PMpmuGQ6W4gzQUeiNPk
         RSPHsnh6eJYS2UUn1HoPuuQI/QuZie5sEPTC/VRvgTL2xUJ4nwVuFAuEdJdtKNYz6uRa
         RJRclUvHAK5wYUnG5Kd5szhVJOWvrnDnSGGqxFqu8qwG0B25o2mufERVQeZkIh1uFYkK
         J1/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Tc3oEsXss3L57smcg7ET5YqKd/3q1IBNjIpWHSb/fJo=;
        b=SnLBDewtJJSPpvLN/sB7yEiQgubzAoRYJJditVe7ZwqB26td3P6+N9lQcG0H9zMt1r
         evca82OIUESO/4vIrkAoej05HWHYGCdBdtbeJsUbu2dbtRVMydShc60F1m2uAQzuQwdL
         hjzp6njzJt+KGgivfcKcurVVsUMHN5lKvmTml/3u5UEdCznbTRXbzVcTtDhxGLeOhyh0
         yr1dyVsbv4bJ7s7MsKFG0YKM8dRUeJ/j94qpIWjOPz5ROor66klPvkPFyG9/S0MHL9LH
         c4pXs44kxnlah4IxCpveiGKxuohXoWskuBFjeIgdW5UKHZLEzCcTqWKvJNRHsCXFg4Gv
         2kdg==
X-Gm-Message-State: APjAAAWEaDnR8dC6ApJM/zA/2TTKZ3zJGEbhE8E7uSHBBipTGgxvEWCQ
        +h57A9gPMHqOuFlNcOOspS5/HFeA
X-Google-Smtp-Source: APXvYqypX0UC/5A4bMaHYM9pMkJplQsRcU9RlCV+/REJUwI4kkQiIMDsvE2sPjeIc3y3rqt8pNAEwg==
X-Received: by 2002:a17:906:b84d:: with SMTP id ga13mr993370ejb.236.1569980140067;
        Tue, 01 Oct 2019 18:35:40 -0700 (PDT)
Received: from desk.local ([2a02:a03f:4080:1900:c8a8:489c:8544:d3e4])
        by smtp.gmail.com with ESMTPSA id f36sm3525242ede.28.2019.10.01.18.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 18:35:39 -0700 (PDT)
Date:   Wed, 2 Oct 2019 03:35:38 +0200
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     Steve French <smfrench@gmail.com>
Cc:     Paulo Alcantara <paulo@paulo.ac>,
        David Howells <dhowells@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-sparse@vger.kernel.org, CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Many unexpected warnings with current sparse
Message-ID: <20191002013537.2bfopy3ke5kkmqep@desk.local>
References: <CAH2r5mspD=iMnO-CuyHMf3jmS0zm7fbqNOXe0cqMcKsXfLAu-Q@mail.gmail.com>
 <20191001231017.67txq4dhrvhyzbu5@desk.local>
 <CAH2r5mvnYtmfpHY+jeUbN4JehQwY1XfBWYVNSLO+wx1wkAA6gA@mail.gmail.com>
 <20191002001859.qeyo3btl7tosz3vo@desk.local>
 <CAH2r5mtzAgcJTrGuderq4DEHBXtPujcQ8DWJUzM0w=hHX8WbJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mtzAgcJTrGuderq4DEHBXtPujcQ8DWJUzM0w=hHX8WbJQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Oct 01, 2019 at 08:24:45PM -0500, Steve French wrote:
> On Tue, Oct 1, 2019 at 7:19 PM Luc Van Oostenryck
> <luc.vanoostenryck@gmail.com> wrote:
> >
> > On Tue, Oct 01, 2019 at 06:14:23PM -0500, Steve French wrote:
> > > It may be related to the following sparse make warning:
> > >
> > > No rule to make target
> > > '/usr/include/x86_64-linux-gnu/bits/huge_val.h', needed by
> > > 'sparse-llvm.o'
> > >
> > > I don't see huge_val.h in the Ubuntu 19 version of libc6-dev
> >
> > Yes, I've been bitten myself by this. It's fixed since a little while.
> > So, just doing a clean build or removing all the deps (.*.d)
> > should allow you to build sparse.
> >
> > I've verified the problem with asm and __inline in quota.h:
> > it's autodetected by kconfig (CC_HAS_ASM_INLINE) so the exact config
> > doesn't matter (only gcc's version does) but in all cases recent
> > versions of sparse don't have a problem with it
> 
> Removed the dependencies and rebuilt as you suggested and it worked ...
> and even better ... with the noise removed I now see two real bugs

Ahh, good!

> (endian conversion missing on two lines) and only one possible problem
> with sparse/gcc itself
> 
> Sparse now flags this line from one of Paulo's DFS features merged last year:
> 
>       struct smb_vol fake_vol = {0};
> 
> with
> 
>       "warning: Using plain integer as NULL pointer"
> 
> What is the recommended way to initialize a struct to avoid the sparse warning?

Well, personally, I simply use '{}'. GCC and sparse are happy with it but, IIRC,
it's not allowed by the standard...

> And what about the "namespace" warnings from the fscache (cache.o)
> code that now show up?  I hadn't seen those before.
> Any easy way to remove them?
> 
> "WARNING: module cifs uses symbol sigprocmask from namespace
> fs/cifs/cache.o: $(deps_/home/sfrench/cifs-2.6/fs/cifs/cache.o), but
> does not import it."

This one is not from sparse, it's from modpost (see EXPORT_SYMBOL_NS).

Cheers,
-- Luc
