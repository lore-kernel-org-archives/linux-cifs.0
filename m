Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31607C433FE
	for <linux-cifs@archiver.kernel.org>; Wed, 25 May 2022 09:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238681AbiEYJlj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 May 2022 05:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239021AbiEYJlg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 May 2022 05:41:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C642EBEC
        for <linux-cifs@vger.kernel.org>; Wed, 25 May 2022 02:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653471692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QqOFkQzaTlTCuP2ZM9qkTD+5kSoM+ZsTwzBMQ4mI18Y=;
        b=gzSFXvaq/vGuL7StoplkVNI7GEe+eBAzh16IQtPpRkfS3F2dv4do7WGeto9Jk0AHQN/Ogl
        D7TZBRHpMkbCc1JEamEUXus6DUlqRNG+leuaJvZtp3JnAsP+9y4D8YaQX5N+UFDdKk+5j9
        YbMNKF5fF6XT9GUbTRKAmJodfdIptsQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-2-Sgz5FhPBeAVZ2wih5lbg-1; Wed, 25 May 2022 05:41:29 -0400
X-MC-Unique: 2-Sgz5FhPBeAVZ2wih5lbg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C372858EEE;
        Wed, 25 May 2022 09:41:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CE5041637F;
        Wed, 25 May 2022 09:41:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <1922487.1653470999@warthog.procyon.org.uk>
References: <1922487.1653470999@warthog.procyon.org.uk> <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com> <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com> <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com> <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com> <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com> <84589.1653070372@warthog.procyon.org.uk> <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com> <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com> <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com>
To:     Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Cc:     dhowells@redhat.com, Tom Talpey <tom@talpey.com>,
        Long Li <longli@microsoft.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: RDMA (smbdirect) testing
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1922994.1653471687.1@warthog.procyon.org.uk>
Date:   Wed, 25 May 2022 10:41:27 +0100
Message-ID: <1922995.1653471687@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> With that, iWarp works for me.  You can add:

Note also that whilst wireshark can decode iwarp traffic carrying NFS, it
doesn't recognise iwarp traffic carrying cifs.

David

