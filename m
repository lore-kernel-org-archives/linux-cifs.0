Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEA2C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 20 May 2022 06:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236403AbiETGUY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 May 2022 02:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345791AbiETGUS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 20 May 2022 02:20:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29F7414C764
        for <linux-cifs@vger.kernel.org>; Thu, 19 May 2022 23:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653027616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QAvrBXcqA1u/Q5DFwXZOWE06I0j8Giurss8RKXKHuxA=;
        b=GDCP8Tu6rx4ho6cK9O29FsDjil2rcQ8YYGNZGpdVugGdIEuv/UbSDSljr18BdUtLcQLJk0
        2dvftrfWFvJrfmUt4XV3c6y8sBr/vq3x7n/gKXG9qDMwRfZ8iqzskEhm1W9vxHZSrcNa9R
        FpgWYqGzWeS8qwrNdBYhXIyvRfmMimM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-BVUIwVYpP_uVelSv8VN4jw-1; Fri, 20 May 2022 02:20:13 -0400
X-MC-Unique: BVUIwVYpP_uVelSv8VN4jw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D42A63C0218B;
        Fri, 20 May 2022 06:20:12 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBD672026D6A;
        Fri, 20 May 2022 06:20:11 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
References: <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com> <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, Long Li <longli@microsoft.com>
Subject: Re: RDMA (smbdirect) testing
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3738076.1653027611.1@warthog.procyon.org.uk>
Date:   Fri, 20 May 2022 07:20:11 +0100
Message-ID: <3738077.1653027611@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Namjae Jeon <linkinjeon@kernel.org> wrote:

> You seem to be asking about soft-ROCE(or soft-iWARP). Hyunchul had been
> testing RDMA of ksmbd with it before.

Yep.  I don't have any RDMA-capable cards.  I have managed to use soft-IWarp
with NFS.

Also, if you know how to make Samba do RDMA, that would be useful.

Thanks,
David

