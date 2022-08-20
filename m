Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3DECC25B08
	for <linux-cifs@archiver.kernel.org>; Sat, 20 Aug 2022 15:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbiHTPXI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 20 Aug 2022 11:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiHTPXI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 20 Aug 2022 11:23:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341AF1CFE0
        for <linux-cifs@vger.kernel.org>; Sat, 20 Aug 2022 08:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661008986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jd6vc9tUnV3colWvbDupC4gyG/J68e4MJccWbvXVQ78=;
        b=e3qbMrJ2udl3eNxwPnJPrQ7sagupbsrsx7ZJ/d9SsUALwAcak8utjBn2pC1MKq9RrZesX8
        IeRhsaGtCXTB4APAG/9n2xQAUpduhlPfxOWcuet96WPSYMBTJcorv8NFQXpUvGv0QNbti6
        Ud9up7H7avkLavztU2Y9tlZTzQVPcHw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-4To-kHsAOCWBrgmzARGI6Q-1; Sat, 20 Aug 2022 11:23:03 -0400
X-MC-Unique: 4To-kHsAOCWBrgmzARGI6Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FF4085A581;
        Sat, 20 Aug 2022 15:23:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12B362166B29;
        Sat, 20 Aug 2022 15:23:01 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5mtVOKN-8ET1oYC0L+ihAWpmwFY3=Q=-KP+qwcaAb002_A@mail.gmail.com>
References: <CAH2r5mtVOKN-8ET1oYC0L+ihAWpmwFY3=Q=-KP+qwcaAb002_A@mail.gmail.com>
To:     Steve French <smfrench@gmail.com>
Cc:     dhowells@redhat.com, CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: [PATCH][SMB3] fix temporary data corruption in collapse range
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <36138.1661008981.1@warthog.procyon.org.uk>
Date:   Sat, 20 Aug 2022 16:23:01 +0100
Message-ID: <36140.1661008981@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> wrote:

> +	truncate_pagecache_range(inode, off, old_eof);

Upon further consideration, I think this should perhaps be before:

>  	rc = smb2_copychunk_range(xid, cfile, cfile, off + len,

so that any outstanding shared-writable mmap can be made to wait.

Also the invalidation in smb3_zero_range() only covers the hole, so
smb3_insert_range() also needs to invalidate from the bottom of the hole to
the EOF - and, again, I think it needs to do this before making changes to the
file contents.

David

