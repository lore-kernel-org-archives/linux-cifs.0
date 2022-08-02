Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8916CC00140
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Aug 2022 15:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234847AbiHBPK7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Aug 2022 11:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234193AbiHBPK7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Aug 2022 11:10:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98E0817581
        for <linux-cifs@vger.kernel.org>; Tue,  2 Aug 2022 08:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659453056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9QhL27UlcT/EIpTTHsWdJYm3VvIgxY/mK1PKPEVaHvQ=;
        b=BmQBlJnrNYGVGXW/ure5xnzp31dwfJ8Eft39sAcpo5RN0i96klTA4J8L3Nt4P2LsvpG5wI
        4ybP3lB2ea2uUG1oXbPVGoXqEPMKNvhGEUf28k/SCKMxfS+jOchhXsVRgdDMKhVkvcdAHM
        5gz5VudyJLNy6ed68qWwvmqUobK//v0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-bKC0RrOfMPiLQ96Uem98hA-1; Tue, 02 Aug 2022 11:10:55 -0400
X-MC-Unique: bKC0RrOfMPiLQ96Uem98hA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCB27905E8A;
        Tue,  2 Aug 2022 15:10:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFA1320296C2;
        Tue,  2 Aug 2022 15:10:40 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <1922487.1653470999@warthog.procyon.org.uk>
References: <1922487.1653470999@warthog.procyon.org.uk> <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com> <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com> <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com> <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com> <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com> <84589.1653070372@warthog.procyon.org.uk> <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com> <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com> <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     dhowells@redhat.com, Tom Talpey <tom@talpey.com>,
        Long Li <longli@microsoft.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: RDMA (smbdirect) testing
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3343811.1659453040.1@warthog.procyon.org.uk>
Date:   Tue, 02 Aug 2022 16:10:40 +0100
Message-ID: <3343812.1659453040@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> With that, iWarp works for me.  You can add:
> 
> Tested-by: David Howells <dhowells@redhat.com>

Would it be possible to get this pushed upstream as a stopgap fix?  iWarp
still doesn't work in 5.19 with cifs.

David

