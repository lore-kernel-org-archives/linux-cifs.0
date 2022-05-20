Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46388C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 20 May 2022 18:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352463AbiETSNI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 May 2022 14:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352472AbiETSNE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 20 May 2022 14:13:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED76418FF07
        for <linux-cifs@vger.kernel.org>; Fri, 20 May 2022 11:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653070380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/AOybZKb70WodkybWDSKteedBAO9kzMuDYnCRqs8vlo=;
        b=IbLm0AFt9UVf3SajqcjGRw1BgNuHyZLVceU5Io1TX+Ckgnytv5b7dYZZyTRleleZl8/QFx
        i8pfWzWPWNirtxmNPa0DUFZnobullBQ41NfBFU72QNis5fYu7gGlwAjaQlWx/N1BN8ubqG
        oPHakXOwrPMvfT7FKOZ2CjOn5Hr4Lbc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-RlIBjhpmNqWU6skTwSy_Mw-1; Fri, 20 May 2022 14:12:54 -0400
X-MC-Unique: RlIBjhpmNqWU6skTwSy_Mw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0651F80A0B9;
        Fri, 20 May 2022 18:12:54 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 102227AE4;
        Fri, 20 May 2022 18:12:52 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com>
References: <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com> <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com> <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com> <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
To:     Tom Talpey <tom@talpey.com>
Cc:     dhowells@redhat.com, Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: RDMA (smbdirect) testing
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <84588.1653070372.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 20 May 2022 19:12:52 +0100
Message-ID: <84589.1653070372@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tom Talpey <tom@talpey.com> wrote:

> SoftROCE is a bit of a hot mess in upstream right now. It's
> getting a lot of attention, but it's still pretty shaky.
> If you're testing, I'd STRONGLY recommend SoftiWARP.

I'm having problems getting that working.  I'm setting the client up with:

rdma link add siw0 type siw netdev enp6s0
mount //192.168.6.1/scratch /xfstest.scratch -o rdma,user=3Dshares,pass=3D=
...

and then see:

CIFS: Attempting to mount \\192.168.6.1\scratch
CIFS: VFS: _smbd_get_connection:1513 warning: device max_send_sge =3D 6 to=
o small
CIFS: VFS: _smbd_get_connection:1516 Queue Pair creation may fail
CIFS: VFS: _smbd_get_connection:1519 warning: device max_recv_sge =3D 6 to=
o small
CIFS: VFS: _smbd_get_connection:1522 Queue Pair creation may fail
CIFS: VFS: _smbd_get_connection:1559 rdma_create_qp failed -22
CIFS: VFS: _smbd_get_connection:1513 warning: device max_send_sge =3D 6 to=
o small
CIFS: VFS: _smbd_get_connection:1516 Queue Pair creation may fail
CIFS: VFS: _smbd_get_connection:1519 warning: device max_recv_sge =3D 6 to=
o small
CIFS: VFS: _smbd_get_connection:1522 Queue Pair creation may fail
CIFS: VFS: _smbd_get_connection:1559 rdma_create_qp failed -22
CIFS: VFS: cifs_mount failed w/return code =3D -2

in dmesg.

Problem is, I don't know what to do about it:-/

David

