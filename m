Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD0CCC433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Mar 2022 15:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237482AbiCBPsd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Mar 2022 10:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240298AbiCBPsc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Mar 2022 10:48:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 983E11FCC5
        for <linux-cifs@vger.kernel.org>; Wed,  2 Mar 2022 07:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646236067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XeXN/78jQxd8GsXOx0YvNpjVCiv9Jz/thhzNwwyrg0w=;
        b=OtSk9h7HzWIMFxTXVjoysKucMvW8KUr1DZfsr1zLNVFcbDUVe8E8tQf8/Xb5EthlMxyJ/t
        G9j4EshgZcmJWz6i6Zgj2GTh7dxQ39TgTc+kIInktt3D2OKkH+MtvrQbml3+w+CTmsxBz+
        TMM31cHm0rMzlfUK+cQhr/aPj5kmu1k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-tQtrOR_uPb-oXtiu0Lwi2Q-1; Wed, 02 Mar 2022 10:47:44 -0500
X-MC-Unique: tQtrOR_uPb-oXtiu0Lwi2Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19996FC84;
        Wed,  2 Mar 2022 15:47:43 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4292627C5D;
        Wed,  2 Mar 2022 15:47:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CACdtm0b6q0vgfQ4pRuS0JcH=mB6a865MdBtDsfEK4bcYP1B-uA@mail.gmail.com>
References: <CACdtm0b6q0vgfQ4pRuS0JcH=mB6a865MdBtDsfEK4bcYP1B-uA@mail.gmail.com> <CACdtm0Z4crPr868DRGCYNd=euVXzm+T+rPHT4PdqK66TV7iioQ@mail.gmail.com> <914621.1645046759@warthog.procyon.org.uk> <CACdtm0ZteTve1EbSgDX_jochhHT7Ufm3gJg7j28BOjmRSg8dTQ@mail.gmail.com> <2500957.1646059150@warthog.procyon.org.uk> <CACdtm0amJS+5O4=Qun-xxSK1JoCoVfEbRrpHCJ0QYVa7Tc8szQ@mail.gmail.com> <3570270.1646234203@warthog.procyon.org.uk>
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] [CIFS]: Add clamp_length support
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3572525.1646236060.1@warthog.procyon.org.uk>
Date:   Wed, 02 Mar 2022 15:47:40 +0000
Message-ID: <3572526.1646236060@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rohith Surabattula <rohiths.msft@gmail.com> wrote:

> Patches which you posted today are on top of 7-patch series "[RFC][RFC
> PATCH 0/7] cifs: In-progress conversion to use iov_iters and netfslib"
> which you published earlier?

They're a subset of the patches on my netfs-lib branch on top of which the
7-patch series was based.

> or this 7-patch series needs to be reworked ?

Yeah.  I'm going to have a look at that rebasing my netfs-lib and
cifs-experimental branches tomorrow.

David

