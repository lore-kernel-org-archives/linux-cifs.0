Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9156C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Mar 2022 17:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351751AbiCURUF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Mar 2022 13:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351741AbiCURUD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Mar 2022 13:20:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 92BE82716A
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 10:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647883115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9IUWS2/B4HpsLrVca9rX8H3mlz0F0TJVc24LTOd2FQM=;
        b=A+W7R49d2R09pZ0UlOIxyqDplhYyieQ+PYVjODDStFE6hrjDwJGI1bzeNyHjAOe6qOJUXD
        VgLElG/pfBcjOwVRcsjL4nWX7hFIPxhnrggbyvWPmDYriPSZYsfmeh1BNC4GbdkltJhlxl
        cBfOXlBVNkuq5OMN44QhErFMJEnZmaE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-Vpo2_J_OM7eHW44pJVEMow-1; Mon, 21 Mar 2022 13:18:32 -0400
X-MC-Unique: Vpo2_J_OM7eHW44pJVEMow-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2EB4833942;
        Mon, 21 Mar 2022 17:18:31 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C1F01C3327C;
        Mon, 21 Mar 2022 17:18:30 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CACdtm0acOifDsToq3-ocxV2pfXkBX2CoJ64_B_vxMu6mJvN7bA@mail.gmail.com>
References: <CACdtm0acOifDsToq3-ocxV2pfXkBX2CoJ64_B_vxMu6mJvN7bA@mail.gmail.com> <CACdtm0YuO+t46wQf9pKu9-U-=vguvwpEu6VXrkXV3JDocFM2qg@mail.gmail.com> <2314914.1646986773@warthog.procyon.org.uk> <2315193.1646987135@warthog.procyon.org.uk> <CACdtm0Y_F7JjoqvC63+3CU0brETf+iEQ_UjMyx+WzhtwE1HGSw@mail.gmail.com> <4085703.1647475640@warthog.procyon.org.uk> <230153.1647562888@warthog.procyon.org.uk> <CAH2r5mv_V5j_kr=NwCuj1GZesaBVasgZZsHajiCk2Q5UpZ4Lsw@mail.gmail.com>
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>, Jeff Layton <jlayton@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, natomar@microsoft.com
Subject: Re: cifs conversion to netfslib
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1147494.1647883110.1@warthog.procyon.org.uk>
Date:   Mon, 21 Mar 2022 17:18:30 +0000
Message-ID: <1147495.1647883110@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rohith Surabattula <rohiths.msft@gmail.com> wrote:

> Snippet from cifs_writev:
>         rc = extract_iter_to_iter(from, ctx->len, &ctx->iter, &ctx->bv);
>         if (rc < 0) {
>                 kref_put(&ctx->refcount, cifs_aio_ctx_release);
>                 return rc;
>         }
>         ctx->npages = rc;
>         ctx->len = iov_iter_count(&ctx->iter);

Bah.  ctx->len is 0 at the point of the extraction.  That should be:

	rc = extract_iter_to_iter(from, iov_iter_count(from), &ctx->iter, &ctx->bv);

David

