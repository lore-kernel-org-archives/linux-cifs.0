Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8302AC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 24 May 2022 20:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238161AbiEXUNB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 May 2022 16:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237502AbiEXUNB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 May 2022 16:13:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6B82182165
        for <linux-cifs@vger.kernel.org>; Tue, 24 May 2022 13:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653423179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GEnkxinvgnbmYZYJSRj+ehVhLEaXoS/qDe5aTUiCKro=;
        b=cbrtY2Un2g/hQDdsOvJyI1Sos2QHaUHVUlUW2MOsPquYwkYMV6uS1d0mwxO/TeyNg8lrE3
        u46/G+i4eWyWmR/eAAWO6/i7osKWZ0WRCc5TdJjBE6Ky//PrdOZYBvRU1qzpjrXS28xrya
        U+1D7goeSBDhEAIs7Am2EYe2OwM1vuc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-NLvGfW4oMrOiIMa3YIWOog-1; Tue, 24 May 2022 16:12:58 -0400
X-MC-Unique: NLvGfW4oMrOiIMa3YIWOog-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82699858EEE;
        Tue, 24 May 2022 20:12:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A88751121315;
        Tue, 24 May 2022 20:12:56 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
References: <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
To:     Steve French <smfrench@gmail.com>
Cc:     dhowells@redhat.com, Namjae Jeon <linkinjeon@kernel.org>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, Long Li <longli@microsoft.com>
Subject: Re: RDMA (smbdirect) testing
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1733478.1653423175.1@warthog.procyon.org.uk>
Date:   Tue, 24 May 2022 21:12:55 +0100
Message-ID: <1733479.1653423175@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Okay - I got it working; somewhat at least.  Now to take out the mass of print
statements.

David

