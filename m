Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D0A8C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Dec 2021 08:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239127AbhLWImh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Dec 2021 03:42:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29491 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235252AbhLWImf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 23 Dec 2021 03:42:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640248954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TnlGowo6vonWFJdiC3o7Qv/s2Uryf5Jz9D3Rs9oH3QI=;
        b=R6x8i3zAbne7rcf/b7TW234IzbHm9DKpsjfZm4ppGQeTdZaxeRE/jJBaVyi+1jZCDm/z24
        FSEHgkC4wMo1jyVc8+Vw1d+pS1sSOvJVV+qVNiEI16N7gemQ/jzY95izIRz0IjNUaCSDWo
        ZCyPPuXDOztjvOsCbWTeENjaSkl0BDY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-1z7AaBFUOeSpPww5dPvKug-1; Thu, 23 Dec 2021 03:42:31 -0500
X-MC-Unique: 1z7AaBFUOeSpPww5dPvKug-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 202DC100D682;
        Thu, 23 Dec 2021 08:42:30 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4A891037F51;
        Thu, 23 Dec 2021 08:42:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CANT5p=rE+Yr_xybEQ7T+guZXTt4Ddyx0ekhd-t2r89R5Ob5QNA@mail.gmail.com>
References: <CANT5p=rE+Yr_xybEQ7T+guZXTt4Ddyx0ekhd-t2r89R5Ob5QNA@mail.gmail.com> <CANT5p=rxedYesnqitKypJ3X9YU6eANo4zSDid_aKjk7EBCDStg@mail.gmail.com> <20211219222214.zetr4d26qqumqgub@cyberdelia>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     dhowells@redhat.com, Enzo Matsumiya <ematsumiya@suse.de>,
        Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: invalidate dns resolver keys after use
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <674859.1640248947.1@warthog.procyon.org.uk>
Date:   Thu, 23 Dec 2021 08:42:27 +0000
Message-ID: <674860.1640248947@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> wrote:

> Having such an option is useful. Although, getting the right TTL is
> important.

That is the real trick as the libc interface you're supposed to use these days
doesn't give you that information - and, indeed, might draw from a source that
doesn't have such information.

David

