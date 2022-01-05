Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26681C433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Jan 2022 13:12:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbiAENMb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Jan 2022 08:12:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50456 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236921AbiAENM3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Jan 2022 08:12:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641388348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DMS6Hd4mc2kKsn0zoem5JM9gVHIsOxx3DE5VWK4w3+E=;
        b=DYpK6npMazrZLRLo4Ch/K9aB5VhIRiuoQD4KPaLvF4jIN6m7+2ZSwyFgxUNMMnaIRdHOvY
        GAMQH9yjRrUFBtPrVjtTSWURasj5tJjYauBxOd3ovZa5ylL6NNIjELwZZnWIpSt/w3C4En
        IKSMfFHbn3zosDPqDF+bZpAAxo0YqWM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-JMYmaTzmPiyLdmGvspL68w-1; Wed, 05 Jan 2022 08:12:23 -0500
X-MC-Unique: JMYmaTzmPiyLdmGvspL68w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96BF81006AA4;
        Wed,  5 Jan 2022 13:12:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A98774E9B;
        Wed,  5 Jan 2022 13:12:20 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20211223203327.mvzmj3mtlpke3wxn@cyberdelia>
References: <20211223203327.mvzmj3mtlpke3wxn@cyberdelia> <CANT5p=rE+Yr_xybEQ7T+guZXTt4Ddyx0ekhd-t2r89R5Ob5QNA@mail.gmail.com> <CANT5p=rxedYesnqitKypJ3X9YU6eANo4zSDid_aKjk7EBCDStg@mail.gmail.com> <20211219222214.zetr4d26qqumqgub@cyberdelia> <674860.1640248947@warthog.procyon.org.uk>
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     dhowells@redhat.com, Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: invalidate dns resolver keys after use
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2109355.1641388339.1@warthog.procyon.org.uk>
Date:   Wed, 05 Jan 2022 13:12:19 +0000
Message-ID: <2109356.1641388339@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Enzo Matsumiya <ematsumiya@suse.de> wrote:

> I'm not sure I understand. I'm using res_nquery() on my to-be-proposed
> patch and it works fine.

You're supposed to use getaddrinfo() these days, apparently.  The info you're
looking for might not be in the DNS.

David

