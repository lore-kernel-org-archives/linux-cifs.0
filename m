Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C822C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Feb 2022 16:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbiBNQHI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Feb 2022 11:07:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347023AbiBNQHH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Feb 2022 11:07:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9EBCC488B6
        for <linux-cifs@vger.kernel.org>; Mon, 14 Feb 2022 08:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644854818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RdoFPo0Y+0ZyN4NwJHVlPBv+GbPGBiBUAekBTnm7+8g=;
        b=BFRCnIuQJdH8WO4fCi2hZ0+232xaoW/Ud78zbWwXh1QUfyYkHqt16BDduO4yU5Mb+rG5Qe
        roJ41L5F6Fj0RfukcuyT4hJpdegBvOQLcLK+LLL8+P6l/amCu63MlP9jABQEYIqeyAt6gP
        ceLH6CgQkOlJpKH7ITF1NKsZpv8WYkQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-9D-eZ2x3OjqcshVtQhwlIg-1; Mon, 14 Feb 2022 11:06:55 -0500
X-MC-Unique: 9D-eZ2x3OjqcshVtQhwlIg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D1B71006AA0;
        Mon, 14 Feb 2022 16:06:53 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DBC475746;
        Mon, 14 Feb 2022 16:06:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CACdtm0bi4O36cif-iwarBb2oNOj-qjECr0iPAHK821E07u7p8A@mail.gmail.com>
References: <CACdtm0bi4O36cif-iwarBb2oNOj-qjECr0iPAHK821E07u7p8A@mail.gmail.com> <164311902471.2806745.10187041199819525677.stgit@warthog.procyon.org.uk> <164311907995.2806745.400147335497304099.stgit@warthog.procyon.org.uk>
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     dhowells@redhat.com, smfrench@gmail.com, nspmangalore@gmail.com,
        jlayton@kernel.org, linux-cifs@vger.kernel.org,
        linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 3/7] cifs: Change the I/O paths to use an iterator rather than a page list
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2976357.1644854775.1@warthog.procyon.org.uk>
Date:   Mon, 14 Feb 2022 16:06:15 +0000
Message-ID: <2976358.1644854775@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rohith Surabattula <rohiths.msft@gmail.com> wrote:

> After copying the buf to the XArray iterator, "got_bytes" field is not
> updated. As a result, the read of data which is less than page size
> failed.
> Below is the patch to fix the above issue.

Okay, I've folded that in, thanks.

David

