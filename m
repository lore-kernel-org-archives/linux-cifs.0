Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D9BDC64EC4
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Feb 2023 01:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjBTBsi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 19 Feb 2023 20:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjBTBsh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 19 Feb 2023 20:48:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BB61B6
        for <linux-cifs@vger.kernel.org>; Sun, 19 Feb 2023 17:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676857667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s/pNa6h5YLmgrkyXgxKUZbYLSWfU78j3qdVrSDGDh/8=;
        b=fq89WXhSEtYWH3I7GHPkkKnqQxc8lixLHUT6Z+bJRhGu+YQc8TczHI4RE3qEJMuQIv/YEu
        WDfj5/EXg5qEqGKddC3+A4rRjkYBjP1Q+IoTukgMMGYvgDQVncE0iGzOqVbV+ecqfZDEZK
        BJZQYOKQFZPbmMULBeDWh1nW1vBzWTE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-92rrE8BHMZWRdMdTGwb12Q-1; Sun, 19 Feb 2023 20:47:42 -0500
X-MC-Unique: 92rrE8BHMZWRdMdTGwb12Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A72FF3813F2A;
        Mon, 20 Feb 2023 01:47:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3C50140EBF6;
        Mon, 20 Feb 2023 01:47:40 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20230220120234.161a6002@canb.auug.org.au>
References: <20230220120234.161a6002@canb.auug.org.au>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     dhowells@redhat.com, Jens Axboe <axboe@kernel.dk>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: duplicate patches in the block tree
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1214276.1676857660.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 20 Feb 2023 01:47:40 +0000
Message-ID: <1214277.1676857660@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> The following commits are also in Linus Torvalds' tree as different
> commits (but the same patches):
> =

>   78e11ab5adf7 ("mm: Pass info, not iter, into filemap_get_pages()")
>   a53cad008099 ("splice: Add a func to do a splice from a buffered file =
without ITER_PIPE")
>   f2aa2c5707ac ("splice: Add a func to do a splice from an O_DIRECT file=
 without ITER_PIPE")
>   51e851b5d16f ("iov_iter: Define flags to qualify page extraction.")
>   0fff5a38a770 ("iov_iter: Add a function to extract a page list from an=
 iterator")

In Linus's tree?  Did you mean the block tree?

David

