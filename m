Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD0AC433FE
	for <linux-cifs@archiver.kernel.org>; Mon, 23 May 2022 10:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbiEWKrg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 May 2022 06:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234341AbiEWKra (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 May 2022 06:47:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 224E84C7AC
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 03:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653302845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tufy4k9IUm7Dd+4tryigNXPHptoH5ASjzZkRMX/8R8c=;
        b=XzJSLb9psx8FN+RjmKg+F3qVoXN9Ef8vKa6AABx2MPw52n4VKUQImNXgrFmuwFFikCmr+w
        d0Jb/g99wLj8qL/G5DGtnhtb/6c86M2HBmynRS6CLw90nQQWdS/5WFoewBASNinDKBo0Qk
        5kFEBbtuEwYk6lvboE9Er1ZWj0SEfYI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-KDjXxgU3PtSpCbc6xpsVuA-1; Mon, 23 May 2022 06:47:02 -0400
X-MC-Unique: KDjXxgU3PtSpCbc6xpsVuA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78C7E3C222C5;
        Mon, 23 May 2022 10:47:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D71D1121314;
        Mon, 23 May 2022 10:46:58 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <1b5daa4695b62795b617049e32c784052deabad4.camel@kernel.org>
References: <1b5daa4695b62795b617049e32c784052deabad4.camel@kernel.org> <165305805651.4094995.7763502506786714216.stgit@warthog.procyon.org.uk>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     dhowells@redhat.com, keescook@chromium.org,
        Jonathan Corbet <corbet@lwn.net>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Steve French <smfrench@gmail.com>,
        William Kucharski <william.kucharski@oracle.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-doc@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-fsdevel@vger.kernel.org, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] netfs: Fix gcc-12 warning by embedding vfs inode in netfs_i_context
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <658390.1653302817.1@warthog.procyon.org.uk>
Date:   Mon, 23 May 2022 11:46:57 +0100
Message-ID: <658391.1653302817@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Jeff Layton <jlayton@kernel.org> wrote:

> 
> Note that there are some conflicts between this patch and some of the
> patches in the current ceph-client/testing branch. Depending on the
> order of merge, one or the other will need to be fixed.

Do you think it could be taken through the ceph tree?

David

