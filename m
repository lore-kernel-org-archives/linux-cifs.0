Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C93C7C27C76
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Jan 2023 07:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbjAYHtk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Jan 2023 02:49:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235190AbjAYHtc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 Jan 2023 02:49:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7342540BDD
        for <linux-cifs@vger.kernel.org>; Tue, 24 Jan 2023 23:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674632925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pR8WtQJv6/KWGsK+MiQX8gnhaGqdrT0GlvePaA0Xg10=;
        b=KfHlJVynohMK3NOhcZc/i7+9mKZy+cUhSlVciHlpjwCzd0G1dNNloUz6Vr4jsNwRZwjhVH
        87L4oPVySZL9UBM9FA6cTcGSn9KYiL+bBpo9Nwq4AUuTQHb5DK0B+GsAMhfh8CLmJN/9Uk
        85TT8KH8MmKF+S0rB+9Y8frxoqm/pvE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-nk2EncPqMBuuYskuarXC-g-1; Wed, 25 Jan 2023 02:48:42 -0500
X-MC-Unique: nk2EncPqMBuuYskuarXC-g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCD7E18E5380;
        Wed, 25 Jan 2023 07:48:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FE5E492B00;
        Wed, 25 Jan 2023 07:48:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <1130899.1674582538@warthog.procyon.org.uk>
References: <1130899.1674582538@warthog.procyon.org.uk>
Cc:     dhowells@redhat.com, Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        Paulo Alcantara <pc@cjr.nz>, Jeff Layton <jlayton@kernel.org>,
        linux-cifs@vger.kernel.org
Subject: Re: cifs-rdma: KASAN-detected UAF when using rxe driver
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1810768.1674632919.1@warthog.procyon.org.uk>
Date:   Wed, 25 Jan 2023 07:48:39 +0000
Message-ID: <1810769.1674632919@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> I was trying to test cifs rdma and KASAN detected a UAF when using the
> softRoCE RDMA driver (rxe):
> 
> 	BUG: KASAN: use-after-free in smbd_reconnect (fs/cifs/smbdirect.c:1427
> 	if (server->smbd_conn->transport_status == SMBD_CONNECTED) {

Okay, this seems to go back at least to v5.19, so it's been around for a
while.

David

