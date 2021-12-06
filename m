Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D93C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Dec 2021 13:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244804AbhLFN4A (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Dec 2021 08:56:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26297 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244764AbhLFN4A (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Dec 2021 08:56:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638798751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RDThPooAIOqs03BpgsSLOKF7ZGnX08P/7E7UUC7nyL4=;
        b=H6WoH0oT1RZEWyOmml3emm0fMqw0zqlV3rYQX19cBJ/EdOqzCNddcK3vOIZJkFwQgFF7G7
        pSl2M29GZcuQnF2wBj10aXEuAJ1G6dv2lvtFBqEKHzkJyZL4lJS3AvDVEaIlFmG2ovY3q2
        TpvmNpTCE0visbdQFlfSryp7oOrDSVM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-ztLEa-mePtq3Xd9bxENH2Q-1; Mon, 06 Dec 2021 08:52:28 -0500
X-MC-Unique: ztLEa-mePtq3Xd9bxENH2Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23FCD81C9A9;
        Mon,  6 Dec 2021 13:52:27 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A808F363E;
        Mon,  6 Dec 2021 13:52:22 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CANT5p=qXbQU4g4VX=W9mOQo1SjMxnFGfpkLOJWgCpicyDLvt-w@mail.gmail.com>
References: <CANT5p=qXbQU4g4VX=W9mOQo1SjMxnFGfpkLOJWgCpicyDLvt-w@mail.gmail.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     dhowells@redhat.com, Jeff Layton <jlayton@redhat.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>,
        linux-cachefs@redhat.com
Subject: Re: [PATCH] cifs: wait for tcon resource_id before getting fscache super
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1355653.1638798741.1@warthog.procyon.org.uk>
Date:   Mon, 06 Dec 2021 13:52:21 +0000
Message-ID: <1355654.1638798741@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> wrote:

> @@ -1376,6 +1376,13 @@ struct inode *cifs_root_iget(struct super_block *sb)
>   inode = ERR_PTR(rc);
>   }
> 
> + /*
> + * The cookie is initialized from volume info returned above.
> + * Inside cifs_fscache_get_super_cookie it checks
> + * that we do not get super cookie twice.
> + */
> + cifs_fscache_get_super_cookie(tcon);

Ummm...  Does this handle the errors correctly?  What happens if rc != 0 at
this point and the inode has been marked failed?  It looks like it will
abandon creation of the superblock without cleaning up the super cookie.
Maybe - or maybe it can't happen because of the:

	iget_no_retry:
		if (!inode) {
			inode = ERR_PTR(rc);
			goto out;
		}

check - but then why is rc being checked?

> +
>  out:
>   kfree(path);
>   free_xid(xid);

David

