Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D013BC43219
	for <linux-cifs@archiver.kernel.org>; Fri, 27 May 2022 11:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348335AbiE0Lvi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 May 2022 07:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352910AbiE0LvA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 27 May 2022 07:51:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F7161117E
        for <linux-cifs@vger.kernel.org>; Fri, 27 May 2022 04:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653651982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GF+Cksj+tpjX3WPl+nbTR/maPOJK/oafnBGaBYtEif0=;
        b=epzrsvHD77ekVRAkerAmovFIdkTHXTgjCmnt5tfnot1tZOMK/pNajfRRXiCdluogufxFc1
        i49yXGpI2wiQnbfIV/a/Gdby+IizTJkh2mYrrmKT3gbm15krjq17o+yp+cI6/T0Hja/i4Y
        oT78dA2sOcKS8FHPjQVR/3UuKlvb8Zo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-uBAqrPhlOGCE_Z35ma9uzQ-1; Fri, 27 May 2022 07:46:19 -0400
X-MC-Unique: uBAqrPhlOGCE_Z35ma9uzQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0ACCC3801149;
        Fri, 27 May 2022 11:46:19 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBC6A40CFD0A;
        Fri, 27 May 2022 11:46:17 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <69922c7e-d463-1f98-d0a0-7c7822fae1dc@samba.org>
References: <69922c7e-d463-1f98-d0a0-7c7822fae1dc@samba.org> <b8850e44-2772-73c0-8998-a961538b9525@samba.org> <1922487.1653470999@warthog.procyon.org.uk> <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com> <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com> <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com> <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com> <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com> <84589.1653070372@warthog.procyon.org.uk> <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com> <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com> <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com> <1922995.1653471687@warthog.procyon.org.uk> <1963315.1653474049@warthog.procyon.org.uk> <7841d1f6-a650-2c62-1518-baecf55cea39@samba.org> <3d0f1538-629e-d4a7-8ac4-500f908b0c2a@talpey.com>
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
Content-ID: <3505923.1653651977.1@warthog.procyon.org.uk>
Date:   Fri, 27 May 2022 12:46:17 +0100
Message-ID: <3505924.1653651977@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Stefan Metzmacher <metze@samba.org> wrote:

> Does https://gitlab.com/wireshark/wireshark/-/merge_requests/7025.patch

I tried applying it (there appear to be two patches therein), but it doesn't
seem to have any effect when viewing the pcap file I posted.  It says it
should decode the port as Artemis.

David

