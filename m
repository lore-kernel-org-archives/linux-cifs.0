Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A9A1C07E97
	for <linux-cifs@archiver.kernel.org>; Sat,  3 Jul 2021 20:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F192613E1
	for <linux-cifs@archiver.kernel.org>; Sat,  3 Jul 2021 20:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhGCU5M (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 3 Jul 2021 16:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhGCU5M (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 3 Jul 2021 16:57:12 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B497EC061762
        for <linux-cifs@vger.kernel.org>; Sat,  3 Jul 2021 13:54:37 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id r26so7464529lfp.2
        for <linux-cifs@vger.kernel.org>; Sat, 03 Jul 2021 13:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=oxwDvbSggAceEEotuy4gDNre5ZX2qK2hyg8CebLNA54=;
        b=OrQHvotJPu5jcRNyXegP4J39gFvdRjcSWK/dzIp1cBcDhHwdfuZCiYgFNr6DlxyVQK
         mYavE6hkQNT6T/2OwRz9hyKAMSBkOZn/7qaM27FaXhevlVx67n6pMSrxcsRy1McNeQJz
         cMljiF+RWJO8q56cY8wFAwwpZ8WdeBFwDkee1pMapsmxAYBs0I3KF0Tbc+mlMbyeekcx
         4sbtq1xZBXryibtPsso22WbTcWhIFAEttxrlMd0tb1lE1aTrG3ZORBsW1E4Ofb5s+qRK
         lA5t3cQD0QuHSub6uQALPwX5qdSURMQ1LZGOjw5p8Z1ncHvKkuYxi8RD5dn8g7t4OsWp
         Oy+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=oxwDvbSggAceEEotuy4gDNre5ZX2qK2hyg8CebLNA54=;
        b=GGE/nTpuc00dp68XrwsUqlO+Xpxh3FSdNlmi4r28nwY71n9Odwt6PZOKJ4BrcqwpGl
         hSU7+/Tvj8Di3+yuZMnhpU4atxn0YQttfnLgdTF0mOqm2iHxlEf9LNQKUuSkcGx5URkd
         fJkeoEH67Icv+ApGO3OrwSqfHPdH7bolZl59kdFY5QNzSDntBfdEWNHRTh6RhRoa7pPY
         hap+AGTwhqZPfUekyu0b0V7r8stH8f64mRrcpm3sdSE6v+BelLRKx2rkVQg0FLQ0S7UU
         NBSbZgjUTbO1jqX177l48XzGDpkRH1o7hvm6j4yABqHDMzffQsCTw8dEmdYdlszBCrH3
         OSBQ==
X-Gm-Message-State: AOAM5327ZjYE2B5rDlTDPwhaYdvA3xuBdFaL3DhuIwuTVLwv/u5n9aMi
        GI/dP2L8hNcsvvTFni4f/MVp96D4kWaiXlCU9aJAcPChT9POZQ==
X-Google-Smtp-Source: ABdhPJzqnYLQoydQJ34c1tWvfAl3Y32jzD0A7dyscLLuRzW6ldvNA6j0kPSFfNgzcUErV55/n7C3/JDSDLSCPaiB+0w=
X-Received: by 2002:ac2:4475:: with SMTP id y21mr2903228lfl.133.1625345675506;
 Sat, 03 Jul 2021 13:54:35 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 3 Jul 2021 15:54:23 -0500
Message-ID: <CAH2r5mtsZCW77xg_mtcQjznSZ-iBZZjDE4Z_+odfnpeEYYfNnA@mail.gmail.com>
Subject: [PATCH][SMB3] Fix typo in smb2pdu.h
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000a04c5d05c63e477a"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000a04c5d05c63e477a
Content-Type: text/plain; charset="UTF-8"

Although it compiles, the test robot correctly noted:
  'cifsacl.h' file not found with <angled> include; use "quotes" instead

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/smb2pdu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index a5c48b85549a..ba75e65924ac 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -13,7 +13,7 @@
 #define _SMB2PDU_H

 #include <net/sock.h>
-#include <cifsacl.h>
+#include "cifsacl.h"

 /*
  * Note that, due to trying to use names similar to the protocol
specifications,

-- 
Thanks,

Steve

--000000000000a04c5d05c63e477a
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-typo-in-header-file.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-typo-in-header-file.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kqo8tk9c0>
X-Attachment-Id: f_kqo8tk9c0

RnJvbSBkOGYyYjM5MGIxMDkwOTRjZDAzZDc0OTM5ZmJiNTkwZmQ2NjZmYjQ1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMyBKdWwgMjAyMSAxNTo0OTozNSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGZpeCB0eXBvIGluIGhlYWRlciBmaWxlCgpBbHRob3VnaCBpdCBjb21waWxlcywgdGhlIHRl
c3Qgcm9ib3QgY29ycmVjdGx5IG5vdGVkOgogICdjaWZzYWNsLmgnIGZpbGUgbm90IGZvdW5kIHdp
dGggPGFuZ2xlZD4gaW5jbHVkZTsgdXNlICJxdW90ZXMiIGluc3RlYWQKClJlcG9ydGVkLWJ5OiBr
ZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJl
bmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21iMnBkdS5oIHwgMiAr
LQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0t
Z2l0IGEvZnMvY2lmcy9zbWIycGR1LmggYi9mcy9jaWZzL3NtYjJwZHUuaAppbmRleCBhNWM0OGI4
NTU0OWEuLmJhNzVlNjU5MjRhYyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmgKKysrIGIv
ZnMvY2lmcy9zbWIycGR1LmgKQEAgLTEzLDcgKzEzLDcgQEAKICNkZWZpbmUgX1NNQjJQRFVfSAog
CiAjaW5jbHVkZSA8bmV0L3NvY2suaD4KLSNpbmNsdWRlIDxjaWZzYWNsLmg+CisjaW5jbHVkZSAi
Y2lmc2FjbC5oIgogCiAvKgogICogTm90ZSB0aGF0LCBkdWUgdG8gdHJ5aW5nIHRvIHVzZSBuYW1l
cyBzaW1pbGFyIHRvIHRoZSBwcm90b2NvbCBzcGVjaWZpY2F0aW9ucywKLS0gCjIuMzAuMgoK
--000000000000a04c5d05c63e477a--
