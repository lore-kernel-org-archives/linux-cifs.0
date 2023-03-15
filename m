Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7153AC61DA4
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Mar 2023 13:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbjCONZb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Mar 2023 09:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbjCONZ0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Mar 2023 09:25:26 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACEA1EFDE
        for <linux-cifs@vger.kernel.org>; Wed, 15 Mar 2023 06:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=klM021FBVtacpRPK1rpakjfz9zCAFYsaUnmD8BdJDyY=; b=HBv/5JyfSZD3s5Dxr+Pmhriq32
        0ioDkWKEIlC2Jon2Grsv6VVHZHuKXkeHqzLu8Le5ql3+8yJDrlaf+VuzsyDMk7e+4HiYreePAhRYz
        enOGAaasfga8BJr8KKiozxCZK2XK2EavVI5FmO8mxZGLsIgp93A/0G3IWN5YPisDIjksTV1b68XLw
        wA4bytab4FgalgR5kfKEFF1EFJs+HoQF2hN4TZS/OKj92+uiGj1WCg0vYRVkcOIKalxKhV1kBzPv7
        6yeov+8RXNw8LF6PsrsacJe6rZkR557Cmpjc1vz3AAX7AvBUWBzKe+7A6mkuBreaBuZy3+AhuD+aI
        Xw9/srJVxZHH8cqGuiDLFKB8bsuiJ9BRjoBLDbQvK86RAmgEODzOH45185/H2+aWV7BNcAzrvjEL/
        BonAfUMIJCsp/PayszWcAgBnJDy/lYDgW4piHRchsRX+9d9N8BQlOMvA/knjxnvg0vUpy6gXypkvi
        sjj41IsJBAiZrfwzsBgnVOD8;
Received: from [2a01:4f8:252:410e::177:224] (port=40716 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1pcQp7-003KNd-Tm; Wed, 15 Mar 2023 13:05:45 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 10/10] cifs: Use switch/case to dissect negprot reply ctxts
Date:   Wed, 15 Mar 2023 13:05:31 +0000
Message-Id: <f046f81ff9cb3fbba28e65d15fc14d0c82affca2.1678885349.git.vl@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1678885349.git.vl@samba.org>
References: <cover.1678885349.git.vl@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Easier to read than nested if/else statements

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/smb2pdu.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 0c1dc33aff05..567f2017d143 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -718,23 +718,30 @@ static int smb311_decode_neg_context(struct smb2_negotiate_rsp *rsp,
 		if (clen > len_of_ctxts)
 			break;
 
-		if (pctx->ContextType == SMB2_PREAUTH_INTEGRITY_CAPABILITIES)
+		switch (pctx->ContextType) {
+		case SMB2_PREAUTH_INTEGRITY_CAPABILITIES:
 			decode_preauth_context(
 				(struct smb2_preauth_neg_context *)pctx);
-		else if (pctx->ContextType == SMB2_ENCRYPTION_CAPABILITIES)
+			break;
+		case SMB2_ENCRYPTION_CAPABILITIES:
 			rc = decode_encrypt_ctx(server,
 				(struct smb2_encryption_neg_context *)pctx);
-		else if (pctx->ContextType == SMB2_COMPRESSION_CAPABILITIES)
+			break;
+		case SMB2_COMPRESSION_CAPABILITIES:
 			decode_compress_ctx(server,
 				(struct smb2_compression_capabilities_context *)pctx);
-		else if (pctx->ContextType == SMB2_POSIX_EXTENSIONS_AVAILABLE)
+			break;
+		case SMB2_POSIX_EXTENSIONS_AVAILABLE:
 			server->posix_ext_supported = true;
-		else if (pctx->ContextType == SMB2_SIGNING_CAPABILITIES)
+			break;
+		case SMB2_SIGNING_CAPABILITIES:
 			decode_signing_ctx(server,
 				(struct smb2_signing_capabilities *)pctx);
-		else
+			break;
+		default:
 			cifs_server_dbg(VFS, "unknown negcontext of type %d ignored\n",
 				le16_to_cpu(pctx->ContextType));
+		}
 
 		if (rc)
 			break;
-- 
2.30.2

