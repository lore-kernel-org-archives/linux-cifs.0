Return-Path: <SRS0=3GXq=BU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 182B6C433DF
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Aug 2020 16:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA8D42076B
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Aug 2020 16:36:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VWk9BqV+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgHJQgl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Aug 2020 12:36:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34245 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725873AbgHJQgh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 10 Aug 2020 12:36:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597077395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E7cstcAHVFGfhscj0UF342G+MM1KSXqD/P1R9pHujqc=;
        b=VWk9BqV+HIdADLsHfwSjMQnQ8SrIyP6olNK3ngMaAMuX/4jL2ECSYSBiuVBzDrfTCtxPs1
        RQO7NUrZKL9N1F1UcM4W7uA7mfUcVJRPQDOoeHmWg1B42rizj751w38SYHN0+rsK/8ldQ3
        xZQxBSKbaW2D70HJfuz12jf38zAuf54=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-JxOVA5Y_PkOb6GxZaJ59Rw-1; Mon, 10 Aug 2020 12:36:30 -0400
X-MC-Unique: JxOVA5Y_PkOb6GxZaJ59Rw-1
Received: by mail-ej1-f72.google.com with SMTP id i23so4057324ejx.11
        for <linux-cifs@vger.kernel.org>; Mon, 10 Aug 2020 09:36:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E7cstcAHVFGfhscj0UF342G+MM1KSXqD/P1R9pHujqc=;
        b=nqCBwUzVpOATyLq34AIGyVhl2cTidg7SXSu9xmbpZfi5BoSx+YwPhkB4qbLxGLbIlG
         /j64JJUyV5fT2/yqn9lETg3t5f2Mh/QL8bEV8zktLn+xQGwDcmY7yU17jsgDBlrX+tMY
         z9WnO2gdSGbxYaBFHQJVJr1Msn9pFQqvQOJ6eIPCpIRcskThG+wB3NRUfysnxc/5IvHm
         JIzxPO2Q0bfkBPwMHVoa3rGcZ6NsBWQFkjkoOJH96CXUZQjlqBYkObYpWvuRUe5h8FEd
         OL4FPA7PPWXM2chV8M7ksl9uJK0M+irwvAlsnhZEUH5IhoBgeinnCRA8nmqg7TQh5mpF
         kxZQ==
X-Gm-Message-State: AOAM530F51LPRYW7Aam9HFtfocNs14kd8cGsCDnZqv4ZdwE4kAqmWvpg
        N79jbQuylS4jP7ivU3KHbhnz+ZSVQYGPv3WmifllPylehyTFJRNUsKxA2jnvGG3GV+rm8esMxcX
        0NQgJ/mqAdgAmUT1XUCjqZv5GXA0YamuFZCTqnw==
X-Received: by 2002:a17:906:a4b:: with SMTP id x11mr23475881ejf.83.1597077389407;
        Mon, 10 Aug 2020 09:36:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxf3SVX6ZuISdp8oMWj+mkcjWbaPxLFNRh9thEVecTra/0s+AaKG5bkamyJTprqlXgn7eVTDeevbLYmrbh9t0=
X-Received: by 2002:a17:906:a4b:: with SMTP id x11mr23475853ejf.83.1597077389176;
 Mon, 10 Aug 2020 09:36:29 -0700 (PDT)
MIME-Version: 1.0
References: <447452.1596109876@warthog.procyon.org.uk> <1851200.1596472222@warthog.procyon.org.uk>
 <667820.1597072619@warthog.procyon.org.uk> <CAH2r5msKipj1exNUDaSUN7h0pjanOenhSg2=EWYMv_h15yKtxg@mail.gmail.com>
 <672169.1597074488@warthog.procyon.org.uk>
In-Reply-To: <672169.1597074488@warthog.procyon.org.uk>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Mon, 10 Aug 2020 12:35:53 -0400
Message-ID: <CALF+zO=DkGmNDrrr-WxU6L1Xw8MA4+NrqVbvNMctwSKjy0Yh_w@mail.gmail.com>
Subject: Re: [GIT PULL] fscache rewrite -- please drop for now
To:     David Howells <dhowells@redhat.com>
Cc:     Steve French <smfrench@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
        linux-nfs <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Aug 10, 2020 at 11:48 AM David Howells <dhowells@redhat.com> wrote:
>
> Steve French <smfrench@gmail.com> wrote:
>
> > cifs.ko also can set rsize quite small (even 1K for example, although
> > that will be more than 10x slower than the default 4MB so hopefully no
> > one is crazy enough to do that).
>
> You can set rsize < PAGE_SIZE?
>
> > I can't imagine an SMB3 server negotiating an rsize or wsize smaller than
> > 64K in today's world (and typical is 1MB to 8MB) but the user can specify a
> > much smaller rsize on mount.  If 64K is an adequate minimum, we could change
> > the cifs mount option parsing to require a certain minimum rsize if fscache
> > is selected.
>
> I've borrowed the 256K granule size used by various AFS implementations for
> the moment.  A 512-byte xattr can thus hold a bitmap covering 1G of file
> space.
>
>

Is it possible to make the granule size configurable, then reject a
registration if the size is too small or not a power of 2?  Then a
netfs using the API could try to set equal to rsize, and then error
out with a message if the registration was rejected.

