Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B3AC05027
	for <linux-cifs@archiver.kernel.org>; Sun, 12 Feb 2023 23:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjBLXk0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 12 Feb 2023 18:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjBLXkZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 12 Feb 2023 18:40:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52C7F76E
        for <linux-cifs@vger.kernel.org>; Sun, 12 Feb 2023 15:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676245178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SK0wZXWovBD7DJL+Hoj+/Uuq1+hXGQ1+AFTjGroCWZU=;
        b=XYGVfh/xH3Y1mqYB2X3OEuKYIT4HIQjWADgMbRSLzIf2phWOtz7Upa6dGy/zmgIRgG5gXn
        0Co9BXSfugAkuL8R5xfZL/neMF/tZ9vbXj8QoFqsyVxLgMdCt+S3BPp3uxySYkMY1lyv9o
        R+8k09dYh5TJ/bKjTwR3CmgqRfGdCNI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-NCtFzw2lOdGu_e8vXRWDsg-1; Sun, 12 Feb 2023 18:39:33 -0500
X-MC-Unique: NCtFzw2lOdGu_e8vXRWDsg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 863F180006E;
        Sun, 12 Feb 2023 23:39:32 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6F494014D03;
        Sun, 12 Feb 2023 23:39:30 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20230210233205.1517459-12-dhowells@redhat.com>
References: <20230210233205.1517459-12-dhowells@redhat.com> <20230210233205.1517459-1-dhowells@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Tom Talpey <tom@talpey.com>,
        Stefan Metzmacher <metze@samba.org>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: [PATCH 11/11] cifs: Fix problem with encrypted RDMA data read
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1614386.1676245170.1@warthog.procyon.org.uk>
Date:   Sun, 12 Feb 2023 23:39:30 +0000
Message-ID: <1614387.1676245170@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Sorry, this one shouldn't have been included.  It's the one Stefan Metzmacher
objected to and provided his own changes for.

David

