Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4751C433FE
	for <linux-cifs@archiver.kernel.org>; Wed, 25 May 2022 09:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235824AbiEYJfZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 May 2022 05:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235532AbiEYJfZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 May 2022 05:35:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A6F38BD17
        for <linux-cifs@vger.kernel.org>; Wed, 25 May 2022 02:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653471323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TH4mDl2k9L+aHOYHNjp1xUPDzwzLUAzbuHFuW5a3sz8=;
        b=YJ7ARKSSI8YWBMDPrgo/tSK91a9GGJ9KxQzwsXOvt/WO4FljDQpu2V3NzLeZ+TGbZ3xDNH
        RfoQCNrLU8bKXVMZI1i9+RsXAfl8ehseD4zPNX/MWhgljWJaMtLzhwoXaj4MLWGC20R3VS
        I1dYOc2YmXoNNrRSKGUGyEGAy5rUO0c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-C7t6jE-LMy6VTZsZfVc_qQ-1; Wed, 25 May 2022 05:35:19 -0400
X-MC-Unique: C7t6jE-LMy6VTZsZfVc_qQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D540100BAA8;
        Wed, 25 May 2022 09:35:19 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 487D91730C;
        Wed, 25 May 2022 09:35:18 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <91acf918-e38d-a07a-ea18-0bb0052d0bde@samba.org>
References: <91acf918-e38d-a07a-ea18-0bb0052d0bde@samba.org> <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com> <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com> <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com> <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com> <84589.1653070372@warthog.procyon.org.uk> <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     dhowells@redhat.com, Tom Talpey <tom@talpey.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: RDMA (smbdirect) testing
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1922711.1653471316.1@warthog.procyon.org.uk>
Date:   Wed, 25 May 2022 10:35:16 +0100
Message-ID: <1922712.1653471316@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Stefan Metzmacher <metze@samba.org> wrote:

> I never god cifs.ko to work with smbdirect.

It works for me.  I think you need the following modules:

	modprobe rdma_cm
	modprobe ib_umad
	modprobe siw # softiwarp
	modprobe rdma_rxe # softroce

I do:

	rdma link add siw0 type siw netdev enp2s0

for softiwarp or:

	rdma link add rxe0 type rxe netdev enp6s0

for softroce on the client before doing:

	mount //192.168.6.1/test /xfstest.test -o rdma,user=shares,pass=...

David

