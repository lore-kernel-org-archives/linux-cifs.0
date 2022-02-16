Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C19ABC433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Feb 2022 21:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbiBPV00 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:26:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235005AbiBPV0Z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Feb 2022 16:26:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 330B42B1001
        for <linux-cifs@vger.kernel.org>; Wed, 16 Feb 2022 13:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645046768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BpzGCF9SFIguWnUniPgdvjLSlBqnZZIxS9nmiCaaI8o=;
        b=g/2Bns4f6UZ41JsM9Ewo4ePV9GXjqc13C7xzoqcPF2csql5P1hnXWjDDIRbGDPuCX+UsZI
        BRQxUX3f3kRJ5CSRR0tvlUNHrc+7NY5SW7WhI9SYwMnqreMgIgvOKzFDgeyranmCCoZ5rC
        GbHeDO8hv2zW6XCBgRmb7067XYfmsEw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-VI4rogBlM2eNuESAhsuCbg-1; Wed, 16 Feb 2022 16:26:05 -0500
X-MC-Unique: VI4rogBlM2eNuESAhsuCbg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 703DD2F45;
        Wed, 16 Feb 2022 21:26:03 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB6D346993;
        Wed, 16 Feb 2022 21:26:00 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CACdtm0Z4crPr868DRGCYNd=euVXzm+T+rPHT4PdqK66TV7iioQ@mail.gmail.com>
References: <CACdtm0Z4crPr868DRGCYNd=euVXzm+T+rPHT4PdqK66TV7iioQ@mail.gmail.com>
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] [CIFS]: Add clamp_length support
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <914620.1645046759.1@warthog.procyon.org.uk>
Date:   Wed, 16 Feb 2022 21:25:59 +0000
Message-ID: <914621.1645046759@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rohith Surabattula <rohiths.msft@gmail.com> wrote:

> +	credits = kmalloc(sizeof(struct cifs_credits), GFP_KERNEL);
> ...
> +	subreq->subreq_priv = credits;

Would it be better if I made it so that the netfs could specify the size of
the netfs_read_subrequest struct to be allocated, thereby allowing it to tag
extra data on the end?

David

