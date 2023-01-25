Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31FEDC54E94
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Jan 2023 22:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbjAYWo3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Jan 2023 17:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjAYWo2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 Jan 2023 17:44:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A6311165
        for <linux-cifs@vger.kernel.org>; Wed, 25 Jan 2023 14:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674686625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BMmqFbeqCS9tVWmTlgJ9Iag3txprivIxoCp7WQSjAuo=;
        b=L1kDcCNHPXhrptilvnIWyre0+W8l01NocgrEeYvxVJszU+8Hxwj6XaGq263xV/WOjktBfQ
        NGduJV5Dt2tdELdxr3Pc4fYYluOVPyEUTXjcIz6v9Zndaohdyr7onydrfqGeAExXqNSm9v
        jS1GG4CaUuF9TQi1sMiXaNGQjE5ptAU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-330-Q67qt_36P7SI1l6f80sTSw-1; Wed, 25 Jan 2023 17:43:41 -0500
X-MC-Unique: Q67qt_36P7SI1l6f80sTSw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 641E629AA3BE;
        Wed, 25 Jan 2023 22:43:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FFD22026D4B;
        Wed, 25 Jan 2023 22:43:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <3006f2ac-c70f-57d0-8286-ffd5892571f7@talpey.com>
References: <3006f2ac-c70f-57d0-8286-ffd5892571f7@talpey.com> <fa35788a-c858-11c5-5d9a-1d5c837020b6@talpey.com> <1130899.1674582538@warthog.procyon.org.uk> <2132364.1674655333@warthog.procyon.org.uk> <2302242.1674679279@warthog.procyon.org.uk>
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
Content-ID: <2341328.1674686619.1@warthog.procyon.org.uk>
Date:   Wed, 25 Jan 2023 22:43:39 +0000
Message-ID: <2341329.1674686619@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tom Talpey <tom@talpey.com> wrote:

> What are you trying to test?

I'm trying to make sure my iteratorisation patches work, including with RDMA.
I have some functions to decant some data an iterator either into a
scatterlist and into an RDMA SGE array without the need to get refs on pages.

> Since encrypted SMBDirect traffic is known to have an issue, I guess I'd
> suggest turning off encryption-by-default on the share.

How do I do that?  In the ksmbd config?

	[global]
		smb3 encryption = yes

David

