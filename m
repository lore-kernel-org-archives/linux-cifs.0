Return-Path: <SRS0=ivIE=UH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 493F3C28CC5
	for <linux-cifs@archiver.kernel.org>; Sat,  8 Jun 2019 09:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A770214AE
	for <linux-cifs@archiver.kernel.org>; Sat,  8 Jun 2019 09:05:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hOh3SfYw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfFHJFl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 8 Jun 2019 05:05:41 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35413 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfFHJFl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 8 Jun 2019 05:05:41 -0400
Received: by mail-pl1-f193.google.com with SMTP id p1so1734257plo.2
        for <linux-cifs@vger.kernel.org>; Sat, 08 Jun 2019 02:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=5aCbh0WAoNANdEYNEvN8iUM+F/mYNTL/ue0+dwqWzas=;
        b=hOh3SfYw7/f59vxt1ecxNYHEha0KOhjSwMRyzFQ7ruhtWz6RcgC6lZlKJixzMvg3x8
         gM7YGgfGEMGQ9zWh0PVfiMTx6NmwGGRBDQ+SeiC15XdggR2/AQyOgMwq+TozDc9BPSuK
         ZfKc9HlJvYbiNDGlzh53FvJpOJYND+/x0OHDjfsoXWecGQoZg+28gCFtknuc2tYZ4YvB
         f6rz+yJjgPp3GpUE10g8oFZOsLtFcVXjLHa35nDBTxv3hF9pbMTMwTXDarp5ncuu5KaQ
         jqBiPKTBpy6Zi3VxRf+smQs3ui8T8x1uSnhLQxcTQF8tfmgqQASUvsc6Xf+0UorMnYIX
         4bIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=5aCbh0WAoNANdEYNEvN8iUM+F/mYNTL/ue0+dwqWzas=;
        b=Hf8KHkI9w3t1sHxWwxwucbwDThBHjD44PYnn7HT3DfEO89vQEnWkFq8Dtx+QzxYmK0
         cNKwy3BKAlj+PtmLGcPRETsUFr9SnrOfI2naRZrNiRVbQwXJOZa+tV1X5tNWfirK1Hs/
         BqE4yyoPcHkeWXxxBldWhwIgDGZhid/RMNlQzXe93fB/HoPqvsoy5Gy5Gx2WQfMjbpeZ
         AQ9soNNCxehEzk9oYNXBt2DH/pGjJzOcdUZE4J+QF7KKvmxnPohHNRlxufQahjDN1W9V
         YwenWWCIien9Nyqa4J3Ja3JPmpMHs6Jn0og3IwWa1A4YX5negaQkF83x7i5PpxHCx0fT
         pFIQ==
X-Gm-Message-State: APjAAAVYeQNbp8On4GxPLlK/yCyDDMH2vHKHc7wqoqmV7wUFFBqpaArT
        zww8SUy0pwr/VtvqTM8hp7b0vTrWS+gCYEXi6lbwSLbG5Ag=
X-Google-Smtp-Source: APXvYqxzySyhNt+5UeX/HnxPXmYrFwtyZR6Kr1kZB1gSFKoaG+3lQzjFZwI3rLGIjVyTLHvIIbjGMnIn0qBpmm2kS7o=
X-Received: by 2002:a17:902:2a29:: with SMTP id i38mr32530384plb.46.1559984739518;
 Sat, 08 Jun 2019 02:05:39 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 8 Jun 2019 04:05:28 -0500
Message-ID: <CAH2r5mvRQj1hyDbBY8DTMtDShr2uxmJqYWWJg+H=iO3RUDc3oQ@mail.gmail.com>
Subject: [PATCH][CIFS] Fix match_server check to allow for multidialect negotiate
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000004139e2058acc4070"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000004139e2058acc4070
Content-Type: text/plain; charset="UTF-8"

When using multidialect negotiate (default or allowing any smb3
dialect via vers=3)
allow matching on existing server session.  Before this fix if you mount
a second time to a different share on the same server, we will only reuse
the existing smb session if a single dialect is requested (e.g. specifying
vers=2.1 or vers=3.0 or vers=3.1.1 on the mount command). If a default mount
(e.g. not specifying vers=) is done then we will create a new socket
connection and SMB3 (or SMB3.1.1) session each time we connect to a
different share
on the same server rather than reusing the existing one.

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/connect.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8c4121da624e..6200207565db 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2542,8 +2542,25 @@ static int match_server(struct TCP_Server_Info
*server, struct smb_vol *vol)
     if (vol->nosharesock)
         return 0;

-    /* BB update this for smb3any and default case */
-    if ((server->vals != vol->vals) || (server->ops != vol->ops))
+    /* If multidialect negotiation see if existing sessions match one */
+    if (strcmp(vol->vals->version_string, SMB3ANY_VERSION_STRING) == 0) {
+        if (server->vals->protocol_id == SMB20_PROT_ID)
+            return 0;
+        else if (server->vals->protocol_id == SMB21_PROT_ID)
+            return 0;
+        else if (strcmp(server->vals->version_string,
+             SMB1_VERSION_STRING) == 0)
+            return 0;
+        /* else SMB3 or later, which is fine */
+    } else if (strcmp(vol->vals->version_string,
+           SMBDEFAULT_VERSION_STRING) == 0) {
+        if (server->vals->protocol_id == SMB20_PROT_ID)
+            return 0;
+        else if (strcmp(server->vals->version_string,
+             SMB1_VERSION_STRING) == 0)
+            return 0;
+        /* else SMB2.1 or later, which is fine */
+    } else if ((server->vals != vol->vals) || (server->ops != vol->ops))
         return 0;

     if (!net_eq(cifs_net_ns(server), current->nsproxy->net_ns))
-- 
2.20.1


-- 
Thanks,

Steve

--0000000000004139e2058acc4070
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-CIFS-Fix-match_server-check-to-allow-for-multidialec.patch"
Content-Disposition: attachment; 
	filename="0001-CIFS-Fix-match_server-check-to-allow-for-multidialec.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jwnamlut0>
X-Attachment-Id: f_jwnamlut0

RnJvbSBmZDVlMDFhODk3NDJiYjg1ZDc1OGE2NjUxMjk0YThhMjAxOTNiYzI3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgOCBKdW4gMjAxOSAwMzo1NjoyOSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIFtD
SUZTXSBGaXggbWF0Y2hfc2VydmVyIGNoZWNrIHRvIGFsbG93IGZvciBtdWx0aWRpYWxlY3QKIG5l
Z290aWF0ZQoKV2hlbiB1c2luZyBtdWx0aWRpYWxlY3QgbmVnb3RpYXRlIChkZWZhdWx0IG9yIGFs
bG93aW5nIGFueSBzbWIzIGRpYWxlY3QgdmlhIHZlcnM9MykKYWxsb3cgbWF0Y2hpbmcgb24gZXhp
c3Rpbmcgc2VydmVyIHNlc3Npb24uICBCZWZvcmUgdGhpcyBmaXggaWYgeW91IG1vdW50CmEgc2Vj
b25kIHRpbWUgdG8gYSBkaWZmZXJlbnQgc2hhcmUgb24gdGhlIHNhbWUgc2VydmVyLCB3ZSB3aWxs
IG9ubHkgcmV1c2UKdGhlIGV4aXN0aW5nIHNtYiBzZXNzaW9uIGlmIGEgc2luZ2xlIGRpYWxlY3Qg
aXMgcmVxdWVzdGVkIChlLmcuIHNwZWNpZnlpbmcKdmVycz0yLjEgb3IgdmVycz0zLjAgb3IgdmVy
cz0zLjEuMSBvbiB0aGUgbW91bnQgY29tbWFuZCkuIElmIGEgZGVmYXVsdCBtb3VudAooZS5nLiBu
b3Qgc3BlY2lmeWluZyB2ZXJzPSkgaXMgZG9uZSB0aGVuIHdlIHdpbGwgY3JlYXRlIGEgbmV3IHNv
Y2tldApjb25uZWN0aW9uIGFuZCBTTUIzIChvciBTTUIzLjEuMSkgc2Vzc2lvbiBlYWNoIHRpbWUg
d2UgY29ubmVjdCB0byBhIGRpZmZlcmVudCBzaGFyZQpvbiB0aGUgc2FtZSBzZXJ2ZXIgcmF0aGVy
IHRoYW4gcmV1c2luZyB0aGUgZXhpc3Rpbmcgb25lLgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJl
bmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY29ubmVjdC5jIHwgMjEg
KysrKysrKysrKysrKysrKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2Nvbm5lY3QuYyBiL2ZzL2NpZnMv
Y29ubmVjdC5jCmluZGV4IDhjNDEyMWRhNjI0ZS4uNjIwMDIwNzU2NWRiIDEwMDY0NAotLS0gYS9m
cy9jaWZzL2Nvbm5lY3QuYworKysgYi9mcy9jaWZzL2Nvbm5lY3QuYwpAQCAtMjU0Miw4ICsyNTQy
LDI1IEBAIHN0YXRpYyBpbnQgbWF0Y2hfc2VydmVyKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNl
cnZlciwgc3RydWN0IHNtYl92b2wgKnZvbCkKIAlpZiAodm9sLT5ub3NoYXJlc29jaykKIAkJcmV0
dXJuIDA7CiAKLQkvKiBCQiB1cGRhdGUgdGhpcyBmb3Igc21iM2FueSBhbmQgZGVmYXVsdCBjYXNl
ICovCi0JaWYgKChzZXJ2ZXItPnZhbHMgIT0gdm9sLT52YWxzKSB8fCAoc2VydmVyLT5vcHMgIT0g
dm9sLT5vcHMpKQorCS8qIElmIG11bHRpZGlhbGVjdCBuZWdvdGlhdGlvbiBzZWUgaWYgZXhpc3Rp
bmcgc2Vzc2lvbnMgbWF0Y2ggb25lICovCisJaWYgKHN0cmNtcCh2b2wtPnZhbHMtPnZlcnNpb25f
c3RyaW5nLCBTTUIzQU5ZX1ZFUlNJT05fU1RSSU5HKSA9PSAwKSB7CisJCWlmIChzZXJ2ZXItPnZh
bHMtPnByb3RvY29sX2lkID09IFNNQjIwX1BST1RfSUQpCisJCQlyZXR1cm4gMDsKKwkJZWxzZSBp
ZiAoc2VydmVyLT52YWxzLT5wcm90b2NvbF9pZCA9PSBTTUIyMV9QUk9UX0lEKQorCQkJcmV0dXJu
IDA7CisJCWVsc2UgaWYgKHN0cmNtcChzZXJ2ZXItPnZhbHMtPnZlcnNpb25fc3RyaW5nLAorCQkJ
IFNNQjFfVkVSU0lPTl9TVFJJTkcpID09IDApCisJCQlyZXR1cm4gMDsKKwkJLyogZWxzZSBTTUIz
IG9yIGxhdGVyLCB3aGljaCBpcyBmaW5lICovCisJfSBlbHNlIGlmIChzdHJjbXAodm9sLT52YWxz
LT52ZXJzaW9uX3N0cmluZywKKwkJICAgU01CREVGQVVMVF9WRVJTSU9OX1NUUklORykgPT0gMCkg
eworCQlpZiAoc2VydmVyLT52YWxzLT5wcm90b2NvbF9pZCA9PSBTTUIyMF9QUk9UX0lEKQorCQkJ
cmV0dXJuIDA7CisJCWVsc2UgaWYgKHN0cmNtcChzZXJ2ZXItPnZhbHMtPnZlcnNpb25fc3RyaW5n
LAorCQkJIFNNQjFfVkVSU0lPTl9TVFJJTkcpID09IDApCisJCQlyZXR1cm4gMDsKKwkJLyogZWxz
ZSBTTUIyLjEgb3IgbGF0ZXIsIHdoaWNoIGlzIGZpbmUgKi8KKwl9IGVsc2UgaWYgKChzZXJ2ZXIt
PnZhbHMgIT0gdm9sLT52YWxzKSB8fCAoc2VydmVyLT5vcHMgIT0gdm9sLT5vcHMpKQogCQlyZXR1
cm4gMDsKIAogCWlmICghbmV0X2VxKGNpZnNfbmV0X25zKHNlcnZlciksIGN1cnJlbnQtPm5zcHJv
eHktPm5ldF9ucykpCi0tIAoyLjIwLjEKCg==
--0000000000004139e2058acc4070--
