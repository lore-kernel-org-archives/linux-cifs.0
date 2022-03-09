Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957E1C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Mar 2022 12:59:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbiCIM77 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Mar 2022 07:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiCIM77 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Mar 2022 07:59:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D02674A932
        for <linux-cifs@vger.kernel.org>; Wed,  9 Mar 2022 04:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646830740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kZClrl17ZyfUqzINyxD9inm0kBC9Q9OlMC1usM7AIzc=;
        b=MXnFneAy8ND/mwZqDi99H+idrdrZwPVe4JHg0YaTcKQHbtG9uUcXsKNFuOgE3wvJVNovJB
        iq+BBW7P2PVBcetrdwLZYydSVUKwwyY+vxuf+sF+iWsBe/XQojuE/MKkdXA1X0ZC655wQW
        VTTdObm5jL2D0Uy8NR9ZTe9Dd6HHugo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-8P42jTAmMdSC6d-9_Ij7pQ-1; Wed, 09 Mar 2022 07:58:56 -0500
X-MC-Unique: 8P42jTAmMdSC6d-9_Ij7pQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B652FC82;
        Wed,  9 Mar 2022 12:58:55 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6E1F8329D;
        Wed,  9 Mar 2022 12:58:51 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CACdtm0amJS+5O4=Qun-xxSK1JoCoVfEbRrpHCJ0QYVa7Tc8szQ@mail.gmail.com>
References: <CACdtm0amJS+5O4=Qun-xxSK1JoCoVfEbRrpHCJ0QYVa7Tc8szQ@mail.gmail.com> <CACdtm0Z4crPr868DRGCYNd=euVXzm+T+rPHT4PdqK66TV7iioQ@mail.gmail.com> <914621.1645046759@warthog.procyon.org.uk> <CACdtm0ZteTve1EbSgDX_jochhHT7Ufm3gJg7j28BOjmRSg8dTQ@mail.gmail.com> <2500957.1646059150@warthog.procyon.org.uk>
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] [CIFS]: Add clamp_length support
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1591073.1646830730.1@warthog.procyon.org.uk>
Date:   Wed, 09 Mar 2022 12:58:50 +0000
Message-ID: <1591074.1646830730@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rohith Surabattula <rohiths.msft@gmail.com> wrote:

> > No, I was thinking of putting a size_t in struct netfs_request_ops that
> > indicates how big the subrequest struct should be:
> ...
> Yes, It will look better. Agree with your idea. I will work on it.

See the patches I've just added to my cifs-experimental branch.

David

