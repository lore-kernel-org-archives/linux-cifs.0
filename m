Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53B1EB64D8
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Jun 2023 21:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjFUVLu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Jun 2023 17:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjFUVLt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Jun 2023 17:11:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B901989;
        Wed, 21 Jun 2023 14:11:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A5B2616C4;
        Wed, 21 Jun 2023 21:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1798C433C0;
        Wed, 21 Jun 2023 21:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687381906;
        bh=O26sECzjqHFzFfFoCV8qOAnuIGD+u12DbfflB2M+dGE=;
        h=Date:From:To:Cc:Subject:From;
        b=Mc6VeZNlzLFFKvWLt4SfV26pH0WCzMz1WckpSDLzbdaYX8GMutcxYHze+5by4XLK2
         yHfMQLFbu2pmeEwBynpL3BEJ3tetRlPnPvJPXEKi/IRe9DkmxAZQygwAYHnlpCw/Rc
         XkEPmn+8RSuPpM6MKhI/JnuECIkGZiA8exsp9iZ8IFF0vIsd6Cb6XANXO+HEjXGN+R
         xkGt+asExn3p8hUshKNVBlmPQC3ubDd1ikaJfL9f1Xttgaqdh2SdpNRrncS4yZDHO8
         xwzkLPXl/ITfPY3/tMsiQ+nvvAYzcHK8d4nk8TY1AciXccOuXNzHYL+dSEneX0CwGL
         fQBR36Y8C8Qcg==
Date:   Wed, 21 Jun 2023 15:12:42 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] smb: Replace one-element array with flexible-array
 member
Message-ID: <ZJNnynWOoTp6uTwF@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

One-element arrays are deprecated, and we are replacing them with flexible
array members instead. So, replace one-element array with flexible-array
member in struct smb_negotiate_req.

This results in no differences in binary output.

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/317
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 fs/smb/server/smb_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 6b0d5f1fe85c..aeca0f46068f 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -200,7 +200,7 @@ struct smb_hdr {
 struct smb_negotiate_req {
 	struct smb_hdr hdr;     /* wct = 0 */
 	__le16 ByteCount;
-	unsigned char DialectsArray[1];
+	unsigned char DialectsArray[];
 } __packed;
 
 struct smb_negotiate_rsp {
-- 
2.34.1

