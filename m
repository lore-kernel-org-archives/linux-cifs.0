Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC1CCC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 25 May 2022 09:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbiEYJaI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 May 2022 05:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiEYJaH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 May 2022 05:30:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C9D417B9C1
        for <linux-cifs@vger.kernel.org>; Wed, 25 May 2022 02:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653471004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jNBU0Zjw3AKqF8z1pin/zZN7Z17sGip0DcK3NkK5wEw=;
        b=Fo2h+gL8YVpkVsjlNnDqyqkfstqq0uf7Fo6tykvgO9RBzQsSJS5226y5DHxH7vgTKZx7jG
        dX2Qc/uORlLY0jSyeQKSnrWVh5oqNiWeO2qI6c9xsNJW6Kb09ZepqU0SJpnmucauaVH/KZ
        iZ0iMCtHRo0xABqtwc9qmdBgpwt90FU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-elzO9zvYM069f-mWiMFfYw-1; Wed, 25 May 2022 05:30:01 -0400
X-MC-Unique: elzO9zvYM069f-mWiMFfYw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8D23800B21;
        Wed, 25 May 2022 09:30:00 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4FDA1121315;
        Wed, 25 May 2022 09:29:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com>
References: <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com> <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com> <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com> <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com> <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com> <84589.1653070372@warthog.procyon.org.uk> <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com> <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com> <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     dhowells@redhat.com, Tom Talpey <tom@talpey.com>,
        Long Li <longli@microsoft.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: RDMA (smbdirect) testing
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1922486.1653470999.1@warthog.procyon.org.uk>
Date:   Wed, 25 May 2022 10:29:59 +0100
Message-ID: <1922487.1653470999@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Namjae Jeon <linkinjeon@kernel.org> wrote:

> diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
> index a87fca82a796..7003722ab004 100644
> --- a/fs/cifs/smbdirect.h
> +++ b/fs/cifs/smbdirect.h
> @@ -226,7 +226,7 @@ struct smbd_buffer_descriptor_v1 {
>  } __packed;
> 
>  /* Default maximum number of SGEs in a RDMA send/recv */
> -#define SMBDIRECT_MAX_SGE      16
> +#define SMBDIRECT_MAX_SGE      6
>  /* The context for a SMBD request */
>  struct smbd_request {
>         struct smbd_connection *info;
> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> index e646d79554b8..70662b3bd590 100644
> --- a/fs/ksmbd/transport_rdma.c
> +++ b/fs/ksmbd/transport_rdma.c
> @@ -42,7 +42,7 @@
>  /* SMB_DIRECT negotiation timeout in seconds */
>  #define SMB_DIRECT_NEGOTIATE_TIMEOUT           120
> 
> -#define SMB_DIRECT_MAX_SEND_SGES               8
> +#define SMB_DIRECT_MAX_SEND_SGES               6
>  #define SMB_DIRECT_MAX_RECV_SGES               1
> 
>  /*

With that, iWarp works for me.  You can add:

Tested-by: David Howells <dhowells@redhat.com>

