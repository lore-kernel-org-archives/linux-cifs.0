Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06CBC433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 19 Jan 2022 10:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348607AbiASKiz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 19 Jan 2022 05:38:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41068 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240089AbiASKiz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 19 Jan 2022 05:38:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642588734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JITo1IbmRg4QBCngpVVwY2JnCsrfMgBtUBMFC81XcNg=;
        b=FDtffsLiqktvyagIvzliKYGsgdrmlkbFD+5PXwupQlPpEjaqes6Qqkw1AwRHU81ADe7dch
        xV6tUKJNWnGjxVpr2HULa6i7u7AWDDM4RTF57sP7oiS39LfKStkPpqX6TrhnysovK8W22Q
        a388ZLIjIBQ3jfwUAgxEnCRCM4Vn2Q0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-BlECXh52MdWAOkgLNTaodQ-1; Wed, 19 Jan 2022 05:38:53 -0500
X-MC-Unique: BlECXh52MdWAOkgLNTaodQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3990D46860;
        Wed, 19 Jan 2022 10:38:52 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 138E76128B;
        Wed, 19 Jan 2022 10:38:50 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CANT5p=pM_frmMwyLcXeCHsSDObz=nKXs_juy3vaKYh=rkNFFRw@mail.gmail.com>
References: <CANT5p=pM_frmMwyLcXeCHsSDObz=nKXs_juy3vaKYh=rkNFFRw@mail.gmail.com> <164251396932.3435901.344517748027321142.stgit@warthog.procyon.org.uk> <164251411336.3435901.17077059669994001060.stgit@warthog.procyon.org.uk> <CAH2r5muTanw9pJqzAHd01d9A8keeChkzGsCEH6=0rHutVLAF-A@mail.gmail.com> <3762846.1642581170@warthog.procyon.org.uk>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        rohiths msft <rohiths.msft@gmail.com>
Subject: Re: [PATCH 11/11] cifs: Support fscache indexing rewrite
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3924745.1642588730.1@warthog.procyon.org.uk>
Date:   Wed, 19 Jan 2022 10:38:50 +0000
Message-ID: <3924746.1642588730@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> wrote:

> Can you let us know the branch name that you're working on in your tree?
> I do not see this last patch in fscache-rewrite branch. Is there
> another branch we should be looking at?

I hadn't got round to pushing it yet.  I've done that now.

David

