Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30593C32789
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 16:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245659AbiHWQ7N (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 12:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343529AbiHWQ6h (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 12:58:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4D791091
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 07:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661264098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=34PbuF0eVwU1fZKmyxntLGj0oriQwCLeUvgJJbU6faI=;
        b=SkimjIg+v5sS++gDlOtBflr/oXHiXqREU9bL9gJulnZTawChDAUzSgVjP81vnt3TIRmsAZ
        s2rAhhQ2956jXpjUtK3+GhQRiXWpRNZYjiiw1Kpb5+HaxfRnww3mvX8WnmsXMMNkja87KS
        SA6qgmnGV9tk7yxZILhzlKxtAxnlt9c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-Q7bLziqjNHmD9kYI60vzyg-1; Tue, 23 Aug 2022 10:14:56 -0400
X-MC-Unique: Q7bLziqjNHmD9kYI60vzyg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 229909682A2;
        Tue, 23 Aug 2022 14:14:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 013C81415138;
        Tue, 23 Aug 2022 14:14:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <YwTfPRDq04/DGTVT@casper.infradead.org>
References: <YwTfPRDq04/DGTVT@casper.infradead.org> <166126004083.548536.11195647088995116235.stgit@warthog.procyon.org.uk> <166126006184.548536.12909933168251738646.stgit@warthog.procyon.org.uk>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     dhowells@redhat.com, sfrench@samba.org, linux-cifs@vger.kernel.org,
        lsahlber@redhat.com, jlayton@kernel.org, dchinner@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: Re: [PATCH 3/5] smb3: fix temporary data corruption in collapse range
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <714207.1661264094.1@warthog.procyon.org.uk>
Date:   Tue, 23 Aug 2022 15:14:54 +0100
Message-ID: <714208.1661264094@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Matthew Wilcox <willy@infradead.org> wrote:

>         truncate_pagecache_range(inode, start, end);
> 
> ... and presumably, you'd also want the error check?

truncate_pagecache_range() is void.

David

