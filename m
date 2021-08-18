Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B67C4338F
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 04:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 646B160551
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 04:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbhHRELJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Aug 2021 00:11:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56183 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229449AbhHRELI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 18 Aug 2021 00:11:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629259834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hM7huVPnUx+3EmOk1XfIZeQI7nSHhBlU+w887TpQ4wg=;
        b=RPmiPK178zHBHQjAgGFzv5qfOf4NFOK26SlkWxznxNg1Jl+l1fVrQU0OPvdBqXzJNnd5hX
        gMcEfqdVwn3Mea/lkGfvpCQFxC9FQIVoyV0B4uQic5G0TcDUkeobIsvj+6n7XvQooRvy6B
        NkbqqOybwli5a8bP9D9mRFs4+66Y2qQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-Jf8dzhArPKWkXFi0xuAMMQ-1; Wed, 18 Aug 2021 00:10:32 -0400
X-MC-Unique: Jf8dzhArPKWkXFi0xuAMMQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33BFF1007C83;
        Wed, 18 Aug 2021 04:10:31 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 058561B5C0;
        Wed, 18 Aug 2021 04:10:29 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: disable ntlmssp key exchange if ARC4 is not available
Date:   Wed, 18 Aug 2021 14:10:21 +1000
Message-Id: <20210818041021.1210797-2-lsahlber@redhat.com>
In-Reply-To: <20210818041021.1210797-1-lsahlber@redhat.com>
References: <20210818041021.1210797-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This allows to build cifs.ko when ARC4 is not available.
It comes with the drawback that key-exchange is no longer negotiated.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsencrypt.c | 10 ++++++++++
 fs/cifs/sess.c        |  6 ++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 7680e0a9bea3..a5cf604f1864 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -22,7 +22,9 @@
 #include <linux/random.h>
 #include <linux/highmem.h>
 #include <linux/fips.h>
+#ifdef CRYPTO_ARC4
 #include <crypto/arc4.h>
+#endif
 #include <crypto/aead.h>
 
 int __cifs_calc_signature(struct smb_rqst *rqst,
@@ -682,6 +684,13 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	return rc;
 }
 
+#ifndef CRYPTO_ARC4
+int
+calc_seckey(struct cifs_ses *ses)
+{
+	return -ENODEV;
+}
+#else
 int
 calc_seckey(struct cifs_ses *ses)
 {
@@ -712,6 +721,7 @@ calc_seckey(struct cifs_ses *ses)
 	kfree_sensitive(ctx_arc4);
 	return 0;
 }
+#endif
 
 void
 cifs_crypto_secmech_release(struct TCP_Server_Info *server)
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 34a990e1ae44..a05ef87b0560 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -622,9 +622,10 @@ void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
 		NTLMSSP_NEGOTIATE_SEAL;
 	if (server->sign)
 		flags |= NTLMSSP_NEGOTIATE_SIGN;
+#ifdef CRYPTO_ARC4		
 	if (!server->session_estab || ses->ntlmssp->sesskey_per_smbsess)
 		flags |= NTLMSSP_NEGOTIATE_KEY_XCH;
-
+#endif
 	sec_blob->NegotiateFlags = cpu_to_le32(flags);
 
 	sec_blob->WorkstationName.BufferOffset = 0;
@@ -690,9 +691,10 @@ int build_ntlmssp_auth_blob(unsigned char **pbuffer,
 		NTLMSSP_NEGOTIATE_SEAL;
 	if (ses->server->sign)
 		flags |= NTLMSSP_NEGOTIATE_SIGN;
+#ifdef CRYPTO_ARC4		
 	if (!ses->server->session_estab || ses->ntlmssp->sesskey_per_smbsess)
 		flags |= NTLMSSP_NEGOTIATE_KEY_XCH;
-
+#endif
 	tmp = *pbuffer + sizeof(AUTHENTICATE_MESSAGE);
 	sec_blob->NegotiateFlags = cpu_to_le32(flags);
 
-- 
2.30.2

