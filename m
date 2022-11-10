Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D4D7C433FE
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Nov 2022 22:15:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiKJWPH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Nov 2022 17:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiKJWPG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Nov 2022 17:15:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862E949B68
        for <linux-cifs@vger.kernel.org>; Thu, 10 Nov 2022 14:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668118444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2VvcYeFZk0CG8tuiTgyYTZqxInhxGb1ogdK4mON7oYA=;
        b=gxEhC8KhNnCwkV9z3pM8NShx0d7Ej0Dds5uFIjm96xco4hYDrNPlogqPzgf7y5LSAbvbdC
        +5iS+2o7JgIHV7huhuKO3W7MZs55WuzZek/S+ziol9ZdyRq9VEP0zqjv7K+03d/yEQMldG
        5JxDyPiBgVc9BZ9sz29+ybsNbN7uiMs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-Yc_CXo3UMlyN6xcI5llHjg-1; Thu, 10 Nov 2022 17:14:01 -0500
X-MC-Unique: Yc_CXo3UMlyN6xcI5llHjg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9746985A59D;
        Thu, 10 Nov 2022 22:14:00 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C45140C6DC8;
        Thu, 10 Nov 2022 22:13:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5ms6p4_PdihrLC+ZJ4W=YjqOmwYhDT-fF6swZ5SB0fP4Ww@mail.gmail.com>
References: <CAH2r5ms6p4_PdihrLC+ZJ4W=YjqOmwYhDT-fF6swZ5SB0fP4Ww@mail.gmail.com> <20221110111939.135696-1-liujian56@huawei.com>
To:     Steve French <smfrench@gmail.com>
Cc:     dhowells@redhat.com, liujian56@huawei.com,
        ZhangXiaoxu <zhangxiaoxu5@huawei.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Fwd: [PATCH] cifs: use kfree in error path of cifs_writedata_alloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3802820.1668118438.1@warthog.procyon.org.uk>
Date:   Thu, 10 Nov 2022 22:13:58 +0000
Message-ID: <3802821.1668118438@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> wrote:

> 'pages' is allocated by kcalloc(), which should freed by kfree().

Either kfree() or kvfree() will do; though kfree() is going to be slightly
faster.

David

