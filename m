Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F6CDC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 25 May 2022 10:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238228AbiEYKU6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 May 2022 06:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241558AbiEYKU6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 May 2022 06:20:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8422495DFD
        for <linux-cifs@vger.kernel.org>; Wed, 25 May 2022 03:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653474056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hQ+BKjct1HLyk45cUSWKx59N1sJml3A5PRjBa6ledWs=;
        b=R4FsLNl1U75D6ZXSCt+NjReIvHSszGBkBe4/jEFTo3JPEfW3h2oqcwDO4oUdTbNhTKV7mf
        tSNytlrFFXLcQj3VdOGo1pt0wrp5R/b3PVVMMqGhjwdPeFl/YVpePg0llYStVhi8sChqM2
        S13GuBYXL4DAOmXpNGAjW1MKVPI6FuI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-kunU1DsCMiizky-qvA_gjA-1; Wed, 25 May 2022 06:20:52 -0400
X-MC-Unique: kunU1DsCMiizky-qvA_gjA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 94C4029AA2F8;
        Wed, 25 May 2022 10:20:51 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D98B492C3B;
        Wed, 25 May 2022 10:20:50 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <b8850e44-2772-73c0-8998-a961538b9525@samba.org>
References: <b8850e44-2772-73c0-8998-a961538b9525@samba.org> <1922487.1653470999@warthog.procyon.org.uk> <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com> <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com> <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com> <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com> <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com> <84589.1653070372@warthog.procyon.org.uk> <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com> <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com> <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com> <1922995.1653471687@warthog.procyon.org.uk>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: RDMA (smbdirect) testing
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Date:   Wed, 25 May 2022 11:20:49 +0100
Message-ID: <1963315.1653474049@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--=-=-=
Content-Type: text/plain

Stefan Metzmacher <metze@samba.org> wrote:

> Can you share the capture file?

See attached.

> What version of wireshark are you using?

wireshark-3.6.2-1.fc35.x86_64
Wireshark 3.7.0 (v3.7.0rc0-1686-g64dfed53330f)

David


--=-=-=
Content-Type: application/gzip
Content-Disposition: attachment; filename=pcap-rs.gz
Content-Transfer-Encoding: base64

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
+B/m6N6tGIIAAA==
--=-=-=--

