Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04530C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 10:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E095461078
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 10:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhKJLAM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Nov 2021 06:00:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20175 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231630AbhKJLAD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 10 Nov 2021 06:00:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636541836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pOM6Tu/e4tXfQbC4jmbPnenwZKK/f0q5QtT4hbi269Q=;
        b=Oe5Ko0Ej6cdOUyfEK2MmxbAXMyg3ErylylFVJ1XWe1ls5mEI4QQEuKbrA9uhMYU/lQaycI
        MpkCiyFfRNbxC5yIOaEDxX2FJcpFzXOtb86bUTuns5dDNVGK2IjqKb9B0vRmTMfssKku7N
        GvNkGX7fN2G6tFtZzSzO/qM0ss7F4dI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-3oyjsh6wONq11KYGfI8CcQ-1; Wed, 10 Nov 2021 05:57:14 -0500
X-MC-Unique: 3oyjsh6wONq11KYGfI8CcQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2B07DF8C0;
        Wed, 10 Nov 2021 10:57:13 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E90867856;
        Wed, 10 Nov 2021 10:57:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5mtVZg1jCCjGfeBgvcN-2iaSBODySkA-B51hx+hfYAatrg@mail.gmail.com>
References: <CAH2r5mtVZg1jCCjGfeBgvcN-2iaSBODySkA-B51hx+hfYAatrg@mail.gmail.com>
To:     Steve French <smfrench@gmail.com>
Cc:     dhowells@redhat.com, CIFS <linux-cifs@vger.kernel.org>
Subject: Re: oops in fscache
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <704398.1636541832.1@warthog.procyon.org.uk>
Date:   Wed, 10 Nov 2021 10:57:12 +0000
Message-ID: <704399.1636541832@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> wrote:

> I noticed that if I mount the same share twice (to different target
> directories) I get the warning below.  Is that expected?

This is with the upstream fscache, I presume?

David

