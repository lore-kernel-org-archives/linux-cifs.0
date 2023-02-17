Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9851C636D6
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Feb 2023 08:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjBQIXs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Feb 2023 03:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjBQIXp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Feb 2023 03:23:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF1A1BACE
        for <linux-cifs@vger.kernel.org>; Fri, 17 Feb 2023 00:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676622178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zInBRG4vGlL2IBFmyTUip6dc+8ZEb/Tg+kZ1FQXvyF8=;
        b=QwHUfYtp+M/go47Qj74pgAMraPMUxrak+AT5gu14enMivs392/0XT9tAplAomXVJ/pcVNX
        1Gswl9urEtxBWetIxD/LBvM5CYO7iEZSTGNkr8RbnBLkMiLjDCpOtpkMcxWdtJ5/LKrWq0
        AI0qQyPGRtkrHm+SK5jrtf+lsP5F0I8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-343-r-0ri5L5PACA0Yf7u0NRfA-1; Fri, 17 Feb 2023 03:22:55 -0500
X-MC-Unique: r-0ri5L5PACA0Yf7u0NRfA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 435A780280C;
        Fri, 17 Feb 2023 08:22:54 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DDDE1121314;
        Fri, 17 Feb 2023 08:22:52 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5mtXfAF19zrRzoLCnHYK593L8HyFTScw-FeaB=Mt7Wj0AQ@mail.gmail.com>
References: <CAH2r5mtXfAF19zrRzoLCnHYK593L8HyFTScw-FeaB=Mt7Wj0AQ@mail.gmail.com> <20230216214745.3985496-1-dhowells@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     dhowells@redhat.com, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Tom Talpey <tom@talpey.com>,
        Stefan Metzmacher <metze@samba.org>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/17] smb3: Use iov_iters down to the network transport and fix DIO page pinning
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4009931.1676622171.1@warthog.procyon.org.uk>
Date:   Fri, 17 Feb 2023 08:22:51 +0000
Message-ID: <4009932.1676622171@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> wrote:

> tentatively merged the first 13 of this series into cifs-2.6.git
> for-next (pending additional testing and any more review comments)

I've fixed the mistakes in the descriptions of patches 3 and 11 pointed out by
you and Eric and fixed up most of the checkpatch warnings in 14.  I've the the
code-to-be-removed #if'd out as it's removed in patch 16.

David

