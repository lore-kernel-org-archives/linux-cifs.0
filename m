Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA85DC433FE
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Nov 2022 11:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbiKNLmC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Nov 2022 06:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236367AbiKNLlw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Nov 2022 06:41:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03981DF27
        for <linux-cifs@vger.kernel.org>; Mon, 14 Nov 2022 03:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668426054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NDGYXXdzkBlppiF4Ardi6MntA/DBzhy9kGpeMJsCAAk=;
        b=NFswepKxTNQULZvwUwoqAii55uxxiX4LWM0lk3zdOHq8fGdqRJmAZvS1gDRCm53LQOZsyi
        YebjfoewHv1vfRDnoq0H5qG/hnGCNoAf/XdsREWYPJHEK2OxEVUYMJZR4EXE8FPQIYae5I
        rHxOVr6SGDJ9moHl737n0hoTERPxF04=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-K_60a1cANxqcq4VkvtgXqA-1; Mon, 14 Nov 2022 06:40:50 -0500
X-MC-Unique: K_60a1cANxqcq4VkvtgXqA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E0378027EB;
        Mon, 14 Nov 2022 11:40:50 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DADF4C3700;
        Mon, 14 Nov 2022 11:40:49 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20221111131153.27075-1-jlayton@kernel.org>
References: <20221111131153.27075-1-jlayton@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     dhowells@redhat.com, linkinjeon@kernel.org, sfrench@samba.org,
        senozhatsky@chromium.org, tom@talpey.com,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] ksmbd: use F_SETLK when unlocking a file
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <575069.1668426046.1@warthog.procyon.org.uk>
Date:   Mon, 14 Nov 2022 11:40:46 +0000
Message-ID: <575070.1668426046@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Jeff Layton <jlayton@kernel.org> wrote:

> ksmbd seems to be trying to use a cmd value of 0 when unlocking a file.
> That activity requires a type of F_UNLCK with a cmd of F_SETLK. For
> local POSIX locking, it doesn't matter much since vfs_lock_file ignores
> @cmd, but filesystems that define their own ->lock operation expect to
> see it set sanely.
> 
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Reviewed-by: David Howells <dhowells@redhat.com>

