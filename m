Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF82FC19F28
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Aug 2022 06:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbiHCGQX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Aug 2022 02:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234289AbiHCGQW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Aug 2022 02:16:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B1C131C12F
        for <linux-cifs@vger.kernel.org>; Tue,  2 Aug 2022 23:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659507380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oJLRD/33HrzqhF+bxuhkr4ya1SbE9Iz+BEaQCreQLGQ=;
        b=Nt0r23/JdoX5Hp91PBr7d2Wa1+Rllfw/fcqGNHyxhTQrj7vj8WZsaDsbPhpXvyrNKfAAlh
        nbouTlJfwkNgXyuY9diBlgwHxEsb1G7cVWNsPjmQgTvLcfvce4kGFpLOcBFnLQyhXcWl7i
        HBrIgPB5nRmNntfOg1OkvYPlfzygh6A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-FsaSeS6sM9iMGF7K2LriQg-1; Wed, 03 Aug 2022 02:16:19 -0400
X-MC-Unique: FsaSeS6sM9iMGF7K2LriQg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 578271C04B40;
        Wed,  3 Aug 2022 06:16:19 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BDD62166B26;
        Wed,  3 Aug 2022 06:16:18 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAKYAXd-X6w-Vt0-p2X7zQd6bC+QkaViUsXXWkyWVkoGciAx6NA@mail.gmail.com>
References: <CAKYAXd-X6w-Vt0-p2X7zQd6bC+QkaViUsXXWkyWVkoGciAx6NA@mail.gmail.com> <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com> <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com> <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com> <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com> <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com> <84589.1653070372@warthog.procyon.org.uk> <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com> <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com> <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com> <1922487.1653470999@warthog.procyon.org.uk> <3343812.1659453040@warthog.procyon.org.uk> <CAKYAXd-sWDpGKZpns=yW-TcOytbVZXdFK9h2BGdmP4g0+p6v-g@mail.gmail.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     dhowells@redhat.com, Long Li <longli@microsoft.com>,
        Tom Talpey <tom@talpey.com>, Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: RDMA (smbdirect) testing
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1653144.1659507377.1@warthog.procyon.org.uk>
Date:   Wed, 03 Aug 2022 07:16:17 +0100
Message-ID: <1653145.1659507377@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Namjae Jeon <linkinjeon@kernel.org> wrote:

> Long said to change that value to 8. But max_sge in cifs need to be
> set to 6 for sw-iWARP . I wonder if there is a problem with values
> lower than 8...

Looking at the code, I think 5 might suffice.

David

