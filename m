Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB970C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Mar 2022 00:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbiCRAWx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Mar 2022 20:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbiCRAWw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Mar 2022 20:22:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 90DA21606A2
        for <linux-cifs@vger.kernel.org>; Thu, 17 Mar 2022 17:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647562894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oxJdBC19aJNOj8IaSNKRH7syFE9P5dVMUBse2qPynvw=;
        b=YABRa1gtho/zxkYQh7M9hSowTFCfP9p3vv3nEEoEV/ax3tedj9Y0dbn2iOqXYZsNFExQX6
        IXRLEuXUhVKXxATMTD5sz7IdjdnOOkEMe2ZqkWZhRwKR+6gjiQWETj9XLC97tTPoRX1dq2
        IDOE8ytcQvJWLVfCJxLGDe/KfWc0bxY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-_BTlbTuyPVGZWdSdG7wAdw-1; Thu, 17 Mar 2022 20:21:31 -0400
X-MC-Unique: _BTlbTuyPVGZWdSdG7wAdw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B363580005D;
        Fri, 18 Mar 2022 00:21:30 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70E4FC28100;
        Fri, 18 Mar 2022 00:21:29 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <4085703.1647475640@warthog.procyon.org.uk>
References: <4085703.1647475640@warthog.procyon.org.uk> <CACdtm0YuO+t46wQf9pKu9-U-=vguvwpEu6VXrkXV3JDocFM2qg@mail.gmail.com> <2314914.1646986773@warthog.procyon.org.uk> <2315193.1646987135@warthog.procyon.org.uk> <CACdtm0Y_F7JjoqvC63+3CU0brETf+iEQ_UjMyx+WzhtwE1HGSw@mail.gmail.com>
To:     Rohith Surabattula <rohiths.msft@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     dhowells@redhat.com, Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>, jlayton@kernel.org,
        linux-cifs@vger.kernel.org
Subject: Re: cifs conversion to netfslib
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <230152.1647562888.1@warthog.procyon.org.uk>
Date:   Fri, 18 Mar 2022 00:21:28 +0000
Message-ID: <230153.1647562888@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Rohith, Steve,

I've updated my cifs-experimental branch.  What I have there seems to work
much the same as without the patches.

I've managed to run some xfstests on it.  I note that various xfstests fail,
even without my patches, and some of them seem quite slow, again even without
my patches.

Note that I'm comparing the speed to afs which does a lot of directory
management locally compared to other network filesystems, so I might be
comparing apples and oranges.  For example, I can run generic/013 on afs in
4-7s, whereas it's 3m-7m on cifs.  However, since /013 does a bunch of
directory ops, afs probably has an advantage by caching the entire dir
contents locally, thereby satisfying lookup and readdir from local cache and
using a bulk status fetch to stat files from a dir in batches of 50 or so.
This is probably worth further investigation at some point.

David

