Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4AA5C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Apr 2022 22:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiDHWQI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Apr 2022 18:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiDHWQI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Apr 2022 18:16:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BACBF24D9B5
        for <linux-cifs@vger.kernel.org>; Fri,  8 Apr 2022 15:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649456042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tWvxe8CFjrISklRPT3jOcqLc5rRwq0iVlJRwB/bg4xY=;
        b=WcDkf0SvSRgnfA/KFPfruFjm/RIrsCJQwqKgKW2E6Ep2MrA//lB1/8TRMgYB5uzB8EBk1v
        lv347Kt1onsjGqPyXlk/VWfnmSjPUsPXFjaJedrfQHYd7FKi1SwIM0o3LC/Y2fhmvvxHwg
        15HtwiyL7B1HK3MerKWCABmFQZT7pMg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-2_07H6NwMJKhaGI8wXjo8g-1; Fri, 08 Apr 2022 18:14:01 -0400
X-MC-Unique: 2_07H6NwMJKhaGI8wXjo8g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62F4F185A7A4;
        Fri,  8 Apr 2022 22:14:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44FA6434836;
        Fri,  8 Apr 2022 22:14:00 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20220405142810.8208-1-dwysocha@redhat.com>
References: <20220405142810.8208-1-dwysocha@redhat.com>
To:     Dave Wysochanski <dwysocha@redhat.com>
Cc:     dhowells@redhat.com, linux-cachefs@redhat.com, jlayton@kernel.org,
        smfrench@gmail.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2] cachefiles: Fix KASAN slab-out-of-bounds in cachefiles_set_volume_xattr
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <755949.1649456039.1@warthog.procyon.org.uk>
Date:   Fri, 08 Apr 2022 23:13:59 +0100
Message-ID: <755950.1649456039@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Dave Wysochanski <dwysocha@redhat.com> wrote:

> -	len += sizeof(*buf);
> -	buf = kmalloc(len, GFP_KERNEL);
> +	buf = kmalloc(sizeof(*buf) + len, GFP_KERNEL);

Okay, your V2 is wrong and your V1 is correct (len must include the reserverd
word so that it gets saved onto disk).

David

