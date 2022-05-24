Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E03EC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 24 May 2022 09:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbiEXJQd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 May 2022 05:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiEXJQc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 May 2022 05:16:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B01812AB0
        for <linux-cifs@vger.kernel.org>; Tue, 24 May 2022 02:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653383790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=99hKCjXRT0pB1MVSlsjAQkxWtG1Zv3Y2HE+riwAtc+8=;
        b=YQrSneO1y3BwQRyqKRFxKTsgMdZwLENG1Bf8J5n1G3/Ps2mmRpx2y+6z1ypb4nmJ78Cu6z
        8raCgYGiHKMtrggEamldKDig/Uw6pGaBO04j9+OXtcU27fWWfWQM+foC7ZflM3tTfA/wRO
        1YVaNS55jisQRcjDYLIyUPGLln51qDQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20-68SprKreMtCIz9gvA8nbRg-1; Tue, 24 May 2022 05:16:27 -0400
X-MC-Unique: 68SprKreMtCIz9gvA8nbRg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A76CA85A5AA;
        Tue, 24 May 2022 09:16:26 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B663C1410DD5;
        Tue, 24 May 2022 09:16:25 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <307f1f2c-900b-8158-78a8-a3dd7564f2f8@talpey.com>
References: <307f1f2c-900b-8158-78a8-a3dd7564f2f8@talpey.com> <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com> <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com> <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com> <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com> <84589.1653070372@warthog.procyon.org.uk> <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com> <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com> <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com> <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com>
To:     Tom Talpey <tom@talpey.com>
Cc:     dhowells@redhat.com, Namjae Jeon <linkinjeon@kernel.org>,
        Long Li <longli@microsoft.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: RDMA (smbdirect) testing
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1502010.1653383785.1@warthog.procyon.org.uk>
Date:   Tue, 24 May 2022 10:16:25 +0100
Message-ID: <1502011.1653383785@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Is there some way for cifs to ask the RDMA layer what it supports?

David

