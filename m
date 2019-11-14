Return-Path: <SRS0=ILFa=ZG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34FBDC432C3
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Nov 2019 01:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49ECF206E6
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Nov 2019 01:42:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dMz4ZaHe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfKNBmj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Nov 2019 20:42:39 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20522 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726410AbfKNBmj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 13 Nov 2019 20:42:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573695758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dBNbqk5MVigEAOgcXk4d1jCwEQqe63ev40KIFG/Sfc4=;
        b=dMz4ZaHeCLTEuhyT/zIdGgLqNdKnmqg+XUZJsCvnFrSFWU9o3Muu4sSuEjEtyyKgd9F1R9
        uyMMxfYEogev/Ugt3JrAS2bZKYgDHRRi8d1tFfOXLdVHZMCyudS4dAPQTt6+uYuX4Gxuqg
        8jcpUmRIANSCwRURjTil3FaZvFdZxG8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-tFbL9gPtMUq4lk6zqtqvkg-1; Wed, 13 Nov 2019 20:42:36 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89F5C107ACC5
        for <linux-cifs@vger.kernel.org>; Thu, 14 Nov 2019 01:42:35 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-39.bne.redhat.com [10.64.54.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E48935C541;
        Thu, 14 Nov 2019 01:42:34 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix race between compound_send_recv() and the demultiplex thread
Date:   Thu, 14 Nov 2019 11:42:26 +1000
Message-Id: <20191114014226.26461-2-lsahlber@redhat.com>
In-Reply-To: <20191114014226.26461-1-lsahlber@redhat.com>
References: <20191114014226.26461-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: tFbL9gPtMUq4lk6zqtqvkg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There is a race where the open() may be interrupted between when we receive=
 the reply
but before we have invoked the callback in which case we never end up calli=
ng
handle_cancelled_mid() and thus leak an open handle on the server.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/connect.c   | 1 -
 fs/cifs/transport.c | 3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ccaa8bad336f..802604a7e692 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1223,7 +1223,6 @@ cifs_demultiplex_thread(void *p)
 =09=09=09if (mids[i] !=3D NULL) {
 =09=09=09=09mids[i]->resp_buf_size =3D server->pdu_size;
 =09=09=09=09if ((mids[i]->mid_flags & MID_WAIT_CANCELLED) &&
-=09=09=09=09    mids[i]->mid_state =3D=3D MID_RESPONSE_RECEIVED &&
 =09=09=09=09    server->ops->handle_cancelled_mid)
 =09=09=09=09=09server->ops->handle_cancelled_mid(
 =09=09=09=09=09=09=09mids[i]->resp_buf,
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index ca3de62688d6..28018a7eccb2 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -1119,7 +1119,8 @@ compound_send_recv(const unsigned int xid, struct cif=
s_ses *ses,
 =09=09=09=09 midQ[i]->mid, le16_to_cpu(midQ[i]->command));
 =09=09=09send_cancel(server, &rqst[i], midQ[i]);
 =09=09=09spin_lock(&GlobalMid_Lock);
-=09=09=09if (midQ[i]->mid_state =3D=3D MID_REQUEST_SUBMITTED) {
+=09=09=09if (midQ[i]->mid_state =3D=3D MID_REQUEST_SUBMITTED ||
+=09=09=09    midQ[i]->mid_state =3D=3D MID_RESPONSE_RECEIVED) {
 =09=09=09=09midQ[i]->mid_flags |=3D MID_WAIT_CANCELLED;
 =09=09=09=09midQ[i]->callback =3D cifs_cancelled_callback;
 =09=09=09=09cancelled_mid[i] =3D true;
--=20
2.13.6

