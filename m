Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC71C433FE
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Dec 2021 16:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381996AbhLCQLq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Dec 2021 11:11:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56018 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1381976AbhLCQLp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Dec 2021 11:11:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638547701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W33Vv9l+YmnIu6ksqWy9UI6RMm5Zuz5BerrqQoMOV8o=;
        b=WydrKDCdgsBKwwn3iRPfvuU526tWyMRnmhTfzt8q3rrY1E1zD7s0WhwxtB2apUX3SvLXGp
        Y39FScmpQ9sRj1p5+7jaDp7QcOGcfnNQfHB/VLtmJ9np8DHDzQImS9HqMcZhMvJH7+WfYq
        YfljHtlrV+B0lc2K6AUUe974ks1xfYQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-e3mvcxqsONWwojBF7nFagA-1; Fri, 03 Dec 2021 11:08:18 -0500
X-MC-Unique: e3mvcxqsONWwojBF7nFagA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22F9A2F41;
        Fri,  3 Dec 2021 16:08:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E710060C13;
        Fri,  3 Dec 2021 16:08:05 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CANT5p=qXbQU4g4VX=W9mOQo1SjMxnFGfpkLOJWgCpicyDLvt-w@mail.gmail.com>
References: <CANT5p=qXbQU4g4VX=W9mOQo1SjMxnFGfpkLOJWgCpicyDLvt-w@mail.gmail.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     dhowells@redhat.com, Jeff Layton <jlayton@redhat.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>,
        linux-cachefs@redhat.com
Subject: Re: [PATCH] cifs: wait for tcon resource_id before getting fscache super
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <997926.1638547684.1@warthog.procyon.org.uk>
Date:   Fri, 03 Dec 2021 16:08:04 +0000
Message-ID: <997927.1638547684@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Your patches all got mangled.  Spaces converted to tabs.

David

