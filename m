Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 998C0C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 08:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FCA8611CB
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 08:46:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239682AbhI1IsI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Sep 2021 04:48:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28110 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239563AbhI1IsI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 28 Sep 2021 04:48:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632818788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wn4ZdzWjv23T7mmE2Jcr442NbvTpnmSX7UQJ+IcvLPo=;
        b=OFpxSNp+9N5pnKfTTToUSh1Dhy8Nm1m+8RswqeeXYDbn3u1lEmvUZ5OU1hVF70P1A3aIty
        at3y4wVR6lKOy5bzQPJU6qskHpNvzSlJS9oXtTEVYiMjoINcZSPd1/zsh66zV7059c/+p5
        fVuq4NFAeoQe2Wwx0svz9JHpR1Y3k4s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-zU5-jaokOj-CQNefXUckPQ-1; Tue, 28 Sep 2021 04:46:26 -0400
X-MC-Unique: zU5-jaokOj-CQNefXUckPQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5085801B3D;
        Tue, 28 Sep 2021 08:46:25 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 47BE15E255;
        Tue, 28 Sep 2021 08:46:25 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5mvKm265qyfx4Ev3emQ9rF-pvHhLQYs2YkJ=u+LmKJwbXA@mail.gmail.com>
References: <CAH2r5mvKm265qyfx4Ev3emQ9rF-pvHhLQYs2YkJ=u+LmKJwbXA@mail.gmail.com> <163214005516.2945267.7000234432243167892.stgit@warthog.procyon.org.uk>
To:     Steve French <smfrench@gmail.com>
Cc:     dhowells@redhat.com, CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Fwd: [RFC PATCH] fscache, 9p, afs, cifs, nfs: Deal with some warnings from W=1
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2790023.1632818784.1@warthog.procyon.org.uk>
Date:   Tue, 28 Sep 2021 09:46:24 +0100
Message-ID: <2790024.1632818784@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> wrote:

> Updated patch (just including the cifs change) to avoid merge conflicts.
> 
> Tentatively merged into cifs-2.6.git for-next

I see your W=1 changes got merged and all my cifs bits are now gone.

David

