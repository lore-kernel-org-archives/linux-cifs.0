Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45AA5C54EAA
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Jan 2023 19:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbjAZTuM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 Jan 2023 14:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbjAZTuL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 Jan 2023 14:50:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271CD3C38
        for <linux-cifs@vger.kernel.org>; Thu, 26 Jan 2023 11:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674762564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kVpm5vjQszxs9mFOSWjKMqeM/NY/HMw2fsvwI+s8BqI=;
        b=WyzP9ExwZkfVVb5kboI9hZFae68GghCSrzUh3/whhUH2k9IoTWme+Cm2R1W0hVo7jZZl6q
        +Neq+NMjjEZ01yoVZh657iTBmy46lH156tFuH9LCfM5CUY58t37agtYX8RhJAcPU1IHtsV
        8Iu0bSxdu8uhe33s3pwdrhkB5WouRd0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-317-1NiOhCn_MdyyfXaAsmjVLA-1; Thu, 26 Jan 2023 14:49:22 -0500
X-MC-Unique: 1NiOhCn_MdyyfXaAsmjVLA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92C4B85A588;
        Thu, 26 Jan 2023 19:49:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A166C15BA0;
        Thu, 26 Jan 2023 19:49:20 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <c0bc974c-22f2-31ed-80b5-b5ec0103823f@talpey.com>
References: <c0bc974c-22f2-31ed-80b5-b5ec0103823f@talpey.com> <0d4d0b2f-bb2b-a69b-2009-8c883119c10d@talpey.com> <1130899.1674582538@warthog.procyon.org.uk> <2132364.1674655333@warthog.procyon.org.uk> <2861100.1674746423@warthog.procyon.org.uk>
To:     Tom Talpey <tom@talpey.com>
Cc:     dhowells@redhat.com, Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix oops due to uncleared server->smbd_conn in reconnect
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2896343.1674762559.1@warthog.procyon.org.uk>
Date:   Thu, 26 Jan 2023 19:49:19 +0000
Message-ID: <2896344.1674762559@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tom Talpey <tom@talpey.com> wrote:

> Maybe this is a softiWARP issue?

That should be softRoCE.

David

