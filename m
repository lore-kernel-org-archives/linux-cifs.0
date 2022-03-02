Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E244C433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Mar 2022 11:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbiCBLGF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Mar 2022 06:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiCBLGE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Mar 2022 06:06:04 -0500
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B6A3CFC3
        for <linux-cifs@vger.kernel.org>; Wed,  2 Mar 2022 03:05:21 -0800 (PST)
Received: by mail-vs1-xe31.google.com with SMTP id j3so1410475vsi.7
        for <linux-cifs@vger.kernel.org>; Wed, 02 Mar 2022 03:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mcjbdWWiFvvsQk+lWzyVsWoNL1cENXl918noct1y1Hk=;
        b=eO13Q60mYA0e+fcfipkuhNnHyYGn1+/Z87ZXBxrUNEHxUvLnL/JEzOGzO12IrkrfG4
         VtGFWScJjrQHZVHkgMJ2Ua0fXe5YWgg6RCE3Zdnp4jTmINoXNsrachz3ZtEuNuhdIjtH
         H16FbmO8Rht7w5fPKdc3Uj2sOJYkSQWXGIA9ESBOvZ6/POwHvEd8vYQZmFfJO0uIQIyN
         90uCSKn4qSnJoikrhbxFNP6gue6wNwlt/USZcZu407aPlFcFDUxOi5SK1MbS9CeNS9ea
         7GgIK4H1v8bCV+7o/Ucb/JmBjcAvFKEn2c6+Jf2BVFQZSzXQ08GoB4W6hBlTZw8g1Lpm
         nyOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mcjbdWWiFvvsQk+lWzyVsWoNL1cENXl918noct1y1Hk=;
        b=xAdkVs8l/Zi+NpP/tLb6bMKGkJTvsC8RKT/h8e7yr7WflJ9jcG0betta2SG8N4dhjj
         qFXbDbvTTE0/nyLIPK0i7jEJSrg8c72uWgHM/tQhRfM8RbyVbB++OlbTN1kh+g452+/v
         W14R/ZZarsSwOAVsw9KquLLEs1J+uOg9N08Xq4g3+NLQt41i/gOl8qRfbwrckoDs7x4j
         VhLR37pIvaoWpVMydH/7GSnftX0WatdUizQVrQqgNMgB8TQTwGxNjmfQEHIXfZSzQDBd
         iSIAsVqSt/9YuQFdN12L7JBR/1IJTwCJ17h12Vu6RzrbmiUwGje2OovZvIo6fVbwTXNT
         nRbg==
X-Gm-Message-State: AOAM532e70/1LWc/Wpzfb+OTeIc4aZlwN/Ox8P5uQbrVX+pxsNGoZ2gv
        UnSk8+EWAwGd7R/pXVjPyfSqByhQW49FqH185Q4=
X-Google-Smtp-Source: ABdhPJxOkBbPXKG15vmxTrfImogI5GmgyuKmv7ZPgEP3ST/9T16S/P/0wHTolXu+drpd7MRXNsiOWPXR2MFKTQXLExI=
X-Received: by 2002:a67:fdc2:0:b0:30e:ef23:3349 with SMTP id
 l2-20020a67fdc2000000b0030eef233349mr11307799vsq.21.1646219120441; Wed, 02
 Mar 2022 03:05:20 -0800 (PST)
MIME-Version: 1.0
References: <CACdtm0Z4crPr868DRGCYNd=euVXzm+T+rPHT4PdqK66TV7iioQ@mail.gmail.com>
 <914621.1645046759@warthog.procyon.org.uk> <CACdtm0ZteTve1EbSgDX_jochhHT7Ufm3gJg7j28BOjmRSg8dTQ@mail.gmail.com>
 <2500957.1646059150@warthog.procyon.org.uk>
In-Reply-To: <2500957.1646059150@warthog.procyon.org.uk>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Wed, 2 Mar 2022 16:35:12 +0530
Message-ID: <CACdtm0amJS+5O4=Qun-xxSK1JoCoVfEbRrpHCJ0QYVa7Tc8szQ@mail.gmail.com>
Subject: Re: [PATCH] [CIFS]: Add clamp_length support
To:     David Howells <dhowells@redhat.com>
Cc:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Yes, It will look better. Agree with your idea. I will work on it.

Regards,
Rohith

On Mon, Feb 28, 2022 at 8:09 PM David Howells <dhowells@redhat.com> wrote:
>
> Rohith Surabattula <rohiths.msft@gmail.com> wrote:
>
> > > Rohith Surabattula <rohiths.msft@gmail.com> wrote:
> > >
> > > > +     credits = kmalloc(sizeof(struct cifs_credits), GFP_KERNEL);
> > > > ...
> > > > +     subreq->subreq_priv = credits;
> > >
> > > Would it be better if I made it so that the netfs could specify the size of
> > > the netfs_read_subrequest struct to be allocated, thereby allowing it to tag
> > > extra data on the end?
> >
> > Do you mean the clamp handler in netfs should return the size of data
> > to be allocated instead of allocating itself ?
>
> No, I was thinking of putting a size_t in struct netfs_request_ops that
> indicates how big the subrequest struct should be:
>
>         struct netfs_request_ops {
>                 ...
>                 size_t subrequest_size;
>         };
>
> and then:
>
>         struct netfs_read_subrequest *netfs_alloc_subrequest(
>                 struct netfs_read_request *rreq)
>         {
>                 struct netfs_read_subrequest *subreq;
>
>                 subreq = kzalloc(rreq->ops->subrequest_size, GFP_KERNEL);
>                 if (subreq) {
>                         INIT_LIST_HEAD(&subreq->rreq_link);
>                         refcount_set(&subreq->usage, 2);
>                         subreq->rreq = rreq;
>                         netfs_get_read_request(rreq);
>                         netfs_stat(&netfs_n_rh_sreq);
>                 }
>
>                 return subreq;
>         }
>
> This would allow you to do, for instance:
>
>         struct cifs_subrequest {
>                 struct netfs_read_subrequest subreq;
>                 struct cifs_credits credits;
>         };
>
> then:
>
>         const struct netfs_request_ops cifs_req_ops = {
>                 .subrequest_size        = sizeof(struct cifs_subrequest),
>                 .init_rreq              = cifs_init_rreq,
>                 .expand_readahead       = cifs_expand_readahead,
>                 .clamp_length           = cifs_clamp_length,
>                 .issue_op               = cifs_req_issue_op,
>                 .done                   = cifs_rreq_done,
>                 .cleanup                = cifs_req_cleanup,
>         };
>
> and then:
>
>         static bool cifs_clamp_length(struct netfs_read_subrequest *subreq)
>         {
>                 struct cifs_subrequest *cifs_subreq =
>                         container_of(subreq, struct cifs_subrequest, subreq);
>                 struct cifs_sb_info *cifs_sb = CIFS_SB(subreq->rreq->inode->i_sb);
>                 struct TCP_Server_Info *server;
>                 struct cifsFileInfo *open_file = subreq->rreq->netfs_priv;
>                 struct cifs_credits *credits = &cifs_subreq->credits;
>                 unsigned int rsize;
>                 int rc;
>
>                 server = cifs_pick_channel(tlink_tcon(open_file->tlink)->ses);
>
>                 rc = server->ops->wait_mtu_credits(server, cifs_sb->ctx->rsize,
>                                                            &rsize, credits);
>                 if (rc)
>                         return false;
>
>                 subreq->len = rsize;
>                 return true;
>         }
>
> David
>
