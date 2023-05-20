Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A92EDC7EE2E
	for <linux-cifs@archiver.kernel.org>; Sat, 20 May 2023 09:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjETJwv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 20 May 2023 05:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbjETJwu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 20 May 2023 05:52:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1587EF7
        for <linux-cifs@vger.kernel.org>; Sat, 20 May 2023 02:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684576326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i3MXR5vwAlfKtddPj9gA3/q/baC/SH/wWtpYvDWrk3w=;
        b=C1zpYYpoX+ht2a6YBTyYflzqYPYQuoWD+Df2DDlzhoLXO15ukD7D0jJE6QZqEdF81QfVTR
        5aXHsX1VlyHGq9bIdoNEsTlMgtf+2mlDnDNFf7Q/kzK07GQhd2CJ2GsR8ibl2Qy2oQFg0W
        jTKgBN+yDKLmjnhxmi6UwZFotvCt/SU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-KL2kr8WWOnKAxXEfx7zgIA-1; Sat, 20 May 2023 05:51:58 -0400
X-MC-Unique: KL2kr8WWOnKAxXEfx7zgIA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C0DE1C05B18;
        Sat, 20 May 2023 09:51:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7D887C52;
        Sat, 20 May 2023 09:51:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
In-Reply-To: <20230520-sekunde-vorteil-f2d588e40b68@brauner>
References: <20230520-sekunde-vorteil-f2d588e40b68@brauner> <20230520000049.2226926-1-dhowells@redhat.com> <20230520000049.2226926-4-dhowells@redhat.com>
To:     Christian Brauner <brauner@kernel.org>
Cc:     dhowells@redhat.com, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Jeff Layton <jlayton@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Hillf Danton <hdanton@sina.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Christoph Hellwig <hch@lst.de>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH v21 03/30] splice: Rename direct_splice_read() to copy_splice_read()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2294856.1684576277.1@warthog.procyon.org.uk>
From:   David Howells <dhowells@redhat.com>
Date:   Sat, 20 May 2023 10:51:54 +0100
Message-ID: <2294949.1684576314@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Christian Brauner <brauner@kernel.org> wrote:

> For the future it'd be nice if exported functions would always get
> proper kernel doc,

Good point.  It wasn't meant to remain exported originally.  I'll add a patch
to add that.

David

