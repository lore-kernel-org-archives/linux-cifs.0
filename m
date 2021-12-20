Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC53C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Dec 2021 12:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhLTMzo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Dec 2021 07:55:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59879 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230262AbhLTMzo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 20 Dec 2021 07:55:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640004943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Nx2DfSvlqgcOdRMIezU5EsxEs3lXx6qD/Th3FCB/qU=;
        b=frtVV6kHBTjYwcZHJyCv0asxOR5DsqmXm449eDz/7X+ohCvAV3r85teeai+fCAuqooGrfh
        ZtZhQsn0uXSEnzX/llRJQhUurWiVaI9F2nolzPRKYRFmnW4MztOj3gPr3mLvdX154+XeDq
        eIYiQJQ4oWLKyh0/fHHDkWqIdA9WyM0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-Pa9M7hy4PemwqaYlX_bczA-1; Mon, 20 Dec 2021 07:55:42 -0500
X-MC-Unique: Pa9M7hy4PemwqaYlX_bczA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED4F510168EA;
        Mon, 20 Dec 2021 12:55:40 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97D5A1059156;
        Mon, 20 Dec 2021 12:55:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CANT5p=rxedYesnqitKypJ3X9YU6eANo4zSDid_aKjk7EBCDStg@mail.gmail.com>
References: <CANT5p=rxedYesnqitKypJ3X9YU6eANo4zSDid_aKjk7EBCDStg@mail.gmail.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: invalidate dns resolver keys after use
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2353799.1640004938.1@warthog.procyon.org.uk>
Date:   Mon, 20 Dec 2021 12:55:38 +0000
Message-ID: <2353800.1640004938@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> wrote:

> From 604ab4c350c2552daa8e77f861a54032b49bc706 Mon Sep 17 00:00:00 2001
> From: Shyam Prasad N <sprasad@microsoft.com>
> Date: Sat, 18 Dec 2021 17:28:10 +0000
> Subject: [PATCH] cifs: invalidate dns resolver keys after use
> 
> We rely on dns resolver module to upcall to userspace
> using request_key and get us the DNS mapping.
> However, the invalidate arg for dns_query was set
> to false, which meant that the key created during the
> first call for a hostname would continue to be cached
> till it expires. This expiration period depends on
> how the dns_resolver is configured.
> 
> Fixing this by setting invalidate=true during dns_query.
> This means that the key will be cleaned up by dns_resolver
> soon after it returns the data. This also means that
> the dns_resolver subsystem will not cache the key for
> an interval indicated by the DNS records TTL. But this is
> okay since we use the TTL value returned to schedule the
> next lookup.
> 
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>

Acked-by: David Howells <dhowells@redhat.com>

