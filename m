Return-Path: <SRS0=LMmx=Z2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA146C2D0BE
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Dec 2019 22:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C06C32073C
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Dec 2019 22:54:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UN+rawYG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfLDWyZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Dec 2019 17:54:25 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35052 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728060AbfLDWyZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 Dec 2019 17:54:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575500063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=iRJb97hXPAM1Hz1LltGMDJx9JI6cvZPfYYBNwqdvCo8=;
        b=UN+rawYGJ0xG7vjRoD4lLljPAre2fY3grrselsu+YYoe0RDLcatdsTWmZAWzgPNFsJ7D0q
        g3WmtUzoSLSonVBYC8BC4Wq3st1O4VuP1vz8L/NNDtNV60OS2MirJmUTXr4P/STKX/SaP4
        orQ3gVn36iWwG7FBO9hhkjqh2QWad14=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-tflb9-3_PHiZsh8x_Xc29Q-1; Wed, 04 Dec 2019 17:54:22 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8A8F107ACC4
        for <linux-cifs@vger.kernel.org>; Wed,  4 Dec 2019 22:54:21 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-46.bne.redhat.com [10.64.54.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A00D600CC
        for <linux-cifs@vger.kernel.org>; Wed,  4 Dec 2019 22:54:21 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Subject: [PATCH 0/3] use compounding to speed up readdir()
Date:   Thu,  5 Dec 2019 08:54:07 +1000
Message-Id: <20191204225410.17514-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: tflb9-3_PHiZsh8x_Xc29Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, List

This three patches are the first step in using compounding to speed up
readdir() which currently takes a minimum of 4 roundtrips for any non-empty
directory.
With these patches we reduce one roundtrip and we can list a directory
in just 3, instead of 4, roundtrips which will benefit use-cases where
latency to the server is high.

I.e. this changes the sequence of operations for a small directory from
1, Open
2, Query and get data
3, Query loop until we get STATUS_NO_MORE_FILES
4, Close

To be the slightly better
1, Open + Query and get data
2, Query and get STATUS_NO_MORE_FILES
3, Close


In later patches we can do even better and drive this down to just 2 roundt=
rips
for a small nonempty directory by using
1, Open + Query + Query
2, Close
for the case where we get STATUS_NO_MORE_FILES for the second Query.
And bring it down to just two roundtrips.

That is probably the best we can do for Windows based servers since without
support for the SMB2_INDEX_SPECIFIED flag in the QueryDirectory request
we can not put the Close() as part of the compound.


IF we had SMB2_INDEX_SPECIFIED support on some server (Azure?) and IF we
had a way to reliably detect if the server supports this flag or not then
we could change the sequence to be
Open + Query + Query + Close
and if the second Query returned STATUS_NO_MORE_FILES we would have finishe=
d thereaddir() in a single roundtrip.
If the directory is large and the second query did not return this error th=
en
we could just continue and use this compound instead to loop until we get t=
o the end :
Open() + Query(SMB2_INDEX_SPECIFIED, Index) + Close()


regards
Ronnie Sahlberg


