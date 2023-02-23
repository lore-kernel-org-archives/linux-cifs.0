Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B42C0C64ED8
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Feb 2023 21:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjBWV2j (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Feb 2023 16:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjBWV21 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Feb 2023 16:28:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4201951F90
        for <linux-cifs@vger.kernel.org>; Thu, 23 Feb 2023 13:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677187664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JXkd4bBjOVLioQAy1OHIxQD9rlQn7Lspd9Q3TTjBqx8=;
        b=Vx/9ESpPQ0/DhvZjEh2ngz49UqPSz1F68lHVMdl/ARBqfVY6Aksvx98kIX4QRbS4FiBzQt
        93Vqcg8MMPBy24wfJrbxz2WWqoJKYQ272IFyqRuX4CIJRSV3dkJteZRuvHm38cL6SmAlrN
        l0sLk4FKt4s6Q5h5QOP0qvVNEPNRMS0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-r_RG81CSNVyaNXRF7sOHiQ-1; Thu, 23 Feb 2023 16:27:40 -0500
X-MC-Unique: r_RG81CSNVyaNXRF7sOHiQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D28E282380D;
        Thu, 23 Feb 2023 21:27:39 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBBAB440D9;
        Thu, 23 Feb 2023 21:27:38 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20230224080931.6433105a@canb.auug.org.au>
References: <20230224080931.6433105a@canb.auug.org.au>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: Fixes tag needs some work in the cifs tree
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1659484.1677187658.1@warthog.procyon.org.uk>
Date:   Thu, 23 Feb 2023 21:27:38 +0000
Message-ID: <1659485.1677187658@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> In commit
> 
>   d7830041d59a ("cifs: Add some missing xas_retry() calls")
> 
> Fixes tag
> 
>   Fixes: 5f0955c98375 ("cifs: Add some helper functions")
> 
> has these problem(s):
> 
>   - Target SHA1 does not exist
> 
> Maybe you meant
> 
> Fixes: b8713c4dbfa3 ("cifs: Add some helper functions")

Sorry, yes, I was on my branch and not the one with Steve's applied version of
the patches.

David

