Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47CBBC433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 27 May 2022 22:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiE0WWf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 May 2022 18:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiE0WWf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 27 May 2022 18:22:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E7DB3D102
        for <linux-cifs@vger.kernel.org>; Fri, 27 May 2022 15:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653690152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZyZh7kMMDiV5p7EUHZZ5XQC9jbplTlndFgnk9mW7UFM=;
        b=WPYBrZtod8qKePjllaUJwQeR+ZU3UwXXpgTnUVLBoYUuhoYDcOhKwXtdn4bE6yLggQXvGF
        UMCD+znKAZhyvw8HWKzus6InmTZmUh5BlAjlX27zO7mgtPdIx9+B00HRGcUWTmi/k/x+oO
        l2uR6vMVqSJX/CA9Jg2ajwyq+Msyui4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-wq_hZJySO_qWw-DAma3_AA-1; Fri, 27 May 2022 18:22:30 -0400
X-MC-Unique: wq_hZJySO_qWw-DAma3_AA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA73D1C16B44;
        Fri, 27 May 2022 22:22:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAB62C27E92;
        Fri, 27 May 2022 22:22:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <33483e99-a127-02e9-aee4-0d6690a6d934@samba.org>
References: <33483e99-a127-02e9-aee4-0d6690a6d934@samba.org> <69922c7e-d463-1f98-d0a0-7c7822fae1dc@samba.org> <b8850e44-2772-73c0-8998-a961538b9525@samba.org> <1922487.1653470999@warthog.procyon.org.uk> <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com> <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com> <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com> <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com> <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com> <84589.1653070372@warthog.procyon.org.uk> <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com> <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com> <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com> <1922995.1653471687@warthog.procyon.org.uk> <1963315.1653474049@warthog.procyon.org.uk> <7841d1f6-a650-2c62-1518-baecf55cea39@samba.org> <3d0f1538-629e-d4a7-8ac4-500f908b0c2a@talpey.com> <3505924.1653651977@warthog.procyon.org.uk>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     dhowells@redhat.com, Tom Talpey <tom@talpey.com>,
        Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Long Li <longli@microsoft.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: RDMA (smbdirect) testing
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3801207.1653690148.1@warthog.procyon.org.uk>
Date:   Fri, 27 May 2022 23:22:28 +0100
Message-ID: <3801208.1653690148@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Stefan Metzmacher <metze@samba.org> wrote:

> I found that it's needed to set the
> tcp.try_heuristic_first preference to TRUE

That works, thanks.

Tested-by: David Howells <dhowells@redhat.com>

