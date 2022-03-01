Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244D3C433FE
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Mar 2022 09:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbiCAJkD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Mar 2022 04:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbiCAJkB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Mar 2022 04:40:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED79145523
        for <linux-cifs@vger.kernel.org>; Tue,  1 Mar 2022 01:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646127560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pTzdsYa5YSVczKzUN4WM0G6s7Arj4BQWQDc4bwTJlys=;
        b=S0MEP1AJnwyxnzSoFaOsCI/LXcBrKKAUcE7GTzLUqnQ4VATD5LwEvvL0EiJNhdaqkyF8Ec
        4M0/SLCJ0nA9MlNz1g6XMn31cg0W/JNdec9BU1ShOh9Iht+y9SbpQ5C51lbr1nZcBqN63w
        t0cXloift7CUXsPHJuoG3XBSygYPrak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-RvHXMJnANwOEE6MCenBbTQ-1; Tue, 01 Mar 2022 04:39:18 -0500
X-MC-Unique: RvHXMJnANwOEE6MCenBbTQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 407E7FC80;
        Tue,  1 Mar 2022 09:39:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 783E083199;
        Tue,  1 Mar 2022 09:39:12 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CACdtm0aZnQLyduKxr9dhcpYB_r00UFnR=WQvAnqL0DebxgbrOw@mail.gmail.com>
References: <CACdtm0aZnQLyduKxr9dhcpYB_r00UFnR=WQvAnqL0DebxgbrOw@mail.gmail.com> <164311902471.2806745.10187041199819525677.stgit@warthog.procyon.org.uk> <164311919732.2806745.2743328800847071763.stgit@warthog.procyon.org.uk> <CACdtm0YtxAUMet_PSxpg69OR9_TQbMQOzU5Kbm_5YDe_C7Nb-w@mail.gmail.com> <3013921.1644856403@warthog.procyon.org.uk> <CACdtm0Z4zXpbPBLJx-=AgBRd63hp_n+U-5qc0gQDQW0c2PY7gg@mail.gmail.com> <2498968.1646058507@warthog.procyon.org.uk>
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     dhowells@redhat.com, smfrench@gmail.com, nspmangalore@gmail.com,
        jlayton@kernel.org, linux-cifs@vger.kernel.org,
        linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 7/7] cifs: Use netfslib to handle reads
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2568724.1646127551.1@warthog.procyon.org.uk>
Date:   Tue, 01 Mar 2022 09:39:11 +0000
Message-ID: <2568725.1646127551@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Btw, do you have any changes on top of my cifs-experimental branch?

Also, what commands are you running to test it?  I see you're using 'vi' - is
it possible that vi is opening the file O_RDWR?

David

