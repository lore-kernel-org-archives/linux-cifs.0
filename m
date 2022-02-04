Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE091C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Feb 2022 09:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbiBDJHW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Feb 2022 04:07:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31018 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237095AbiBDJHV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 4 Feb 2022 04:07:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643965640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=um9SHK4dEO6wnr9IjNTCAVcSkrfvYX5pgpvTTzytlG8=;
        b=ad9/B2wKmn2Iov33LqY+zhAk8K7I60a1X/joD8BABQ/mhhn0yImn2dZywRrK5kWKJP1oGZ
        Igkr2q2tGYbVce8yBqj3uhA0xIgMigZFx+ajUlL0nhnsmuOrmvvQOj44v1BznwQwW590u7
        WKXuBNbVkLGc5QSY1PPDOLL9IZWu41Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-6mocw18zMAG96bovFqf0qA-1; Fri, 04 Feb 2022 04:07:16 -0500
X-MC-Unique: 6mocw18zMAG96bovFqf0qA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DDC083DEA7;
        Fri,  4 Feb 2022 09:07:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC65D60C24;
        Fri,  4 Feb 2022 09:07:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CACdtm0b61sLQo85HdZubh34ieMveMZdZ_tbpmf41U7u+-_LgFw@mail.gmail.com>
References: <CACdtm0b61sLQo85HdZubh34ieMveMZdZ_tbpmf41U7u+-_LgFw@mail.gmail.com>
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: [PATCH] cifs: Invalidate fscache cookie
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <808354.1643965633.1@warthog.procyon.org.uk>
Date:   Fri, 04 Feb 2022 09:07:13 +0000
Message-ID: <808355.1643965633@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rohith Surabattula <rohiths.msft@gmail.com> wrote:

> +	/* Invalidate fscache cookie */
> +	cifs_fscache_fill_coherency(&cifs_i->vfs_inode, &cd);
> +	fscache_invalidate(cifs_inode_cookie(inode), &cd, i_size_read(inode), 0);

There's a helper for that - cifs_invalidate_cache(inode, 0) - I should've made
it use it.

David

