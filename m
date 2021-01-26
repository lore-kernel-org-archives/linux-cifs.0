Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A98ADC433DB
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Jan 2021 15:28:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B15622B51
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Jan 2021 15:28:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406283AbhAZP2N (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Jan 2021 10:28:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37884 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406007AbhAZP1A (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 26 Jan 2021 10:27:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611674734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VJe0QMue+MrGLDqG9YMY3B8wc1OhQAcndv4QLZtzS5Q=;
        b=SApIXfmiJfp16WI90qCKdUL8JW4ZnRzX8TFbUl4UWucYz4yhAs4HVN7gFGXCWe7Dnd95n2
        0eIhGlqMbQChW/qVsDy03wjMd7Z7gdKlxX+BD7VCHR6kaD/nJuPRzv4wferfI95TKTwQgh
        prp/v9Aw1Zks8+vDPlw2TTD7Q0K8fwg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-t2vX2xGsOcqDeXFTKrMIXg-1; Tue, 26 Jan 2021 10:25:33 -0500
X-MC-Unique: t2vX2xGsOcqDeXFTKrMIXg-1
Received: by mail-ed1-f71.google.com with SMTP id n8so9532663edo.19
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jan 2021 07:25:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VJe0QMue+MrGLDqG9YMY3B8wc1OhQAcndv4QLZtzS5Q=;
        b=iRrL5jxg6EODwtAEy7ejarw0vCgFBLmrx58ifsw1uDgO0RALzKM1glJeREXGPFmRwE
         APYTdkbW/facNjrBnOXNG0FeIwti9eFVySV+NL6ee6SCFoOyANBdaw7noa43uocahILy
         WUzeGG72aJ4OiHEYV36IODu9gR0JcTeYc10BoPkC0pl5Pp11vaFhwtHTTto0q+ytO7rc
         +2cGDhSxfo7M6OkenVoGKUUFXJPdphbBhkhgiuyvldU65mXT31gdl31Xe+yGM5gzdN61
         Ursd444ufHdvNNEJyXSpjk/2+tUSaZ98tZza5pO1ZoxMCY5nLUOSOpSQqQfYQ+Ym2/KY
         DLTg==
X-Gm-Message-State: AOAM5304/z+xJ08lJB9kW25VAkvnWri1zvOsuAzyYAz3VlRRRdZP0N4q
        wCq9+T3FPaFTDUgdADLFmneCBM5QczMzO+Y0JDjyrBicjiMgH8pDypiwXj1Ra7JJTtDKQUQbP59
        Z2UV2wLruonX1Et+xnHG5i+AFleCITYwuEFg/rw==
X-Received: by 2002:a05:6402:3589:: with SMTP id y9mr5114904edc.344.1611674731921;
        Tue, 26 Jan 2021 07:25:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzlAcqaq8CqekYAOTl5XTKJw4byUxjRunvP1wQKBAqraCVAKiDEx3Vt3nz1iiXtLgQBV8BZqw1Aaq6eAK2Q72M=
X-Received: by 2002:a05:6402:3589:: with SMTP id y9mr5114888edc.344.1611674731765;
 Tue, 26 Jan 2021 07:25:31 -0800 (PST)
MIME-Version: 1.0
References: <161161025063.2537118.2009249444682241405.stgit@warthog.procyon.org.uk>
 <161161057357.2537118.6542184374596533032.stgit@warthog.procyon.org.uk> <20210126040540.GK308988@casper.infradead.org>
In-Reply-To: <20210126040540.GK308988@casper.infradead.org>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Tue, 26 Jan 2021 10:24:55 -0500
Message-ID: <CALF+zOn80NoeaBW8i9djC8qBCEng7riaHgz77uhxipaZ+RJ5ew@mail.gmail.com>
Subject: Re: [PATCH 27/32] NFS: Refactor nfs_readpage() and
 nfs_readpage_async() to use nfs_readdesc
To:     Matthew Wilcox <willy@infradead.org>
Cc:     David Howells <dhowells@redhat.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Jeff Layton <jlayton@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
        linux-nfs <linux-nfs@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        ceph-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jan 25, 2021 at 11:06 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Mon, Jan 25, 2021 at 09:36:13PM +0000, David Howells wrote:
> > +int nfs_readpage_async(void *data, struct inode *inode,
> >                      struct page *page)
> >  {
> > +     struct nfs_readdesc *desc = (struct nfs_readdesc *)data;
>
> You don't need a cast to cast from void.
>
Right, fixing.

> > @@ -440,17 +439,16 @@ int nfs_readpages(struct file *filp, struct address_space *mapping,
> >       if (ret == 0)
> >               goto read_complete; /* all pages were read */
> >
> > -     desc.pgio = &pgio;
> > -     nfs_pageio_init_read(&pgio, inode, false,
> > +     nfs_pageio_init_read(&desc.pgio, inode, false,
>
> I like what you've done here, embedding the pgio in the desc.
>
Thanks for the review!

