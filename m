Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DDE5C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 27 May 2022 12:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346349AbiE0MkV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 May 2022 08:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352147AbiE0Mjz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 27 May 2022 08:39:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 278A311CA33
        for <linux-cifs@vger.kernel.org>; Fri, 27 May 2022 05:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653654463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RJxrf4ooyTqpiAItg7I/Q/q7XnsebEkQQNQ2A5YOD9I=;
        b=Co1tSshUMCi3FjIl3T0V4I6phbN7o0O2EuWQrOy5KdBQr8SAi7iiToXeOpmgclAAIo5ko+
        ofRWtrkEW6pdyB2gdAOoNTWGKCQ9gurXP9Kozl2pDcRPQezKhzPnVlyUxx/VbDeNljka0D
        qeWs5+0w7ZzZ4l72Be4JkHUr9aOEPC8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-251-jXjVmR17Pi2O2lmDWrKoXw-1; Fri, 27 May 2022 08:27:38 -0400
X-MC-Unique: jXjVmR17Pi2O2lmDWrKoXw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29875101AA45;
        Fri, 27 May 2022 12:27:37 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2504E1410DD5;
        Fri, 27 May 2022 12:27:34 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <202205190704.1DC660E5E@keescook>
References: <202205190704.1DC660E5E@keescook> <165296786831.3591209.12111293034669289733.stgit@warthog.procyon.org.uk>
To:     Kees Cook <keescook@chromium.org>
Cc:     dhowells@redhat.com, jlayton@kernel.org,
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
        linux-fsdevek@vger.kernel.org, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfs: Fix gcc-12 warning by embedding vfs inode in netfs_i_context
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3598051.1653654453.1@warthog.procyon.org.uk>
Date:   Fri, 27 May 2022 13:27:33 +0100
Message-ID: <3598052.1653654453@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Kees,

Is v2 good for you?  I realise I left your R-b attached to it when I posted
it, but I can remove that if you don't have time to review it.

David

