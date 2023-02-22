Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 728B8C64EC4
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Feb 2023 08:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjBVI2y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Feb 2023 03:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjBVI2o (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Feb 2023 03:28:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4191B339
        for <linux-cifs@vger.kernel.org>; Wed, 22 Feb 2023 00:27:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677054476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mdoO5s95Na4aAS2r09uUBGkI6PI2mKVEuOEm/TcR5jM=;
        b=glExR2rmF/SPbGupc0XtaQRcVOaQC7utOWI2YLbvKKvY+c7+nBlNNfIJUO+zREJM1YV1cG
        JvUJE22G4qI0H8nNMXTnddKglUZjY1qo6ptO6+MnRuXZjNYJIejIH2nIFHDSBdEN49wOCJ
        GeSWfQypTgy7MY9SFQaxlx3+aFdqfdo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-AwZy-EmxN16bppq_h_UWGg-1; Wed, 22 Feb 2023 03:27:53 -0500
X-MC-Unique: AwZy-EmxN16bppq_h_UWGg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B181280AA26;
        Wed, 22 Feb 2023 08:27:52 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0B8D440DF;
        Wed, 22 Feb 2023 08:27:50 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20230222134927.459b036b@canb.auug.org.au>
References: <20230222134927.459b036b@canb.auug.org.au> <20230221184225.0e734f0e@canb.auug.org.au> <20230221174401.7198357d@canb.auug.org.au> <20230220152933.1ab8fa4a@canb.auug.org.au> <Y/N8hVWeR3AjssUC@casper.infradead.org> <20230220190157.3b43b9a7@canb.auug.org.au> <Y/Pe2xHklSr1hDtz@casper.infradead.org> <2351091.1676963957@warthog.procyon.org.uk> <2885897.1676990364@warthog.procyon.org.uk>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     dhowells@redhat.com, Matthew Wilcox <willy@infradead.org>,
        "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steve French <smfrench@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Tom Talpey <tom@talpey.com>, Paulo Alcantara <pc@cjr.nz>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: linux-next: manual merge of the mm-stable tree with the cifs tree
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3325857.1677054470.1@warthog.procyon.org.uk>
Date:   Wed, 22 Feb 2023 08:27:50 +0000
Message-ID: <3325858.1677054470@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> OK, so in the merge of mm-stable, I used the cifs version of
> fs/cifs/file.c with this patch applied.  The merge resolution for that
> file looks like this:

I checked it out and diffed it against mine.  Looks right, thanks!

David

