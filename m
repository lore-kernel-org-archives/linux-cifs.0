Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 523C3C07E95
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 18:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37ED461C81
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 18:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbhGGSoj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbhGGSog (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Jul 2021 14:44:36 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C27C061767
        for <linux-cifs@vger.kernel.org>; Wed,  7 Jul 2021 11:40:23 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id u18so6506041lff.9
        for <linux-cifs@vger.kernel.org>; Wed, 07 Jul 2021 11:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=pu8gyira5Skp8iMTpC2i3Oq0LD7WW20LKfir8GJKH6Y=;
        b=k4PRO/zI0sdTS5LeDogcxanX9OmmFATXftENxDK+Svqt2pYkvQA74pUEyOZqREHZ0u
         wNBrE6WwgKAd+t+sSWV/hMu9FkquRK6TocBxPNYA34YrH+iN/PHjjoQi5/3R8nyRLMyq
         BlDiJqheJqhW8klCHxQW1wDJRWi2DFKe9E0GBAXvkVH3fIIG7amAc0Irt5yELgYzJcJI
         ue34XihktyniTE8jq/YstUmiU5hGSRsAKoAig0DgQMXK+nPgwL7TV0TDTKb/B8Ny85T9
         LyeAZNjwNrxQV2Lw33W8mw4RwYNxv6MxXNbfaK2S4gJ1W+tlbtmc4Ema+zgV1lNIl7pQ
         ETOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=pu8gyira5Skp8iMTpC2i3Oq0LD7WW20LKfir8GJKH6Y=;
        b=h1mJ+i/LbVXAzcUHv6Hak7Wd9+rQ3wgkCDBb0h8XP7TqCnPsC8nNKGUcDII5tNzIV+
         XWnka+HDvTaSK+cDCL94sU1kX5g6aubierDR40SuR6AurAMrJ2yrLtDXdfCZ+GhMwIn/
         o4uVRjjwmTR4dCAmCe40CLfpzRl+5gXMWLpzeRpPG8pZUqC77UtPaiq9uk2vPzu0Y+ts
         cSqclVXeSTFCq4mhZ9XBJnqaW2k75j5FNJ+JqW/0T+t49NCZ71jVlfxRYurJkF71R6ep
         5TrOJFjsCjl6S6aSOq5sYkFzj8nQ5Tnq48g383HVSjqZw/TzeOavXyd7akdA9nekTF+w
         9MKg==
X-Gm-Message-State: AOAM533tI836gx6smE76BdKTA0KAzWbYRAfL4as6BGzcjRspra2RdbBW
        JOB35a/yjk7C/Y7Ga+zufFDe7jnelBiI998+cDYv1BjepC4=
X-Google-Smtp-Source: ABdhPJy/XxwS0FGz6ujE9fPl7/vyryuY1RzqTlJBJy+Pbpk6h0iWsTvfr72DnNzKtknlnC1crsRp+AzimBKtIWoI388=
X-Received: by 2002:a2e:b5a3:: with SMTP id f3mr10885874ljn.406.1625683221581;
 Wed, 07 Jul 2021 11:40:21 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 7 Jul 2021 13:40:08 -0500
Message-ID: <CAH2r5msZ8+-HcjXK0xgRDjBRkUg597_mGWx8ry2-PxhJY16mkw@mail.gmail.com>
Subject: [PATCH][CIFS] Clarify SMB1 code for rename open file
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000f0ac2205c68cdef4"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000f0ac2205c68cdef4
Content-Type: text/plain; charset="UTF-8"

And one more trivial coverity issue related patch ...
(with fewer old issues like this, in the future it will be easier
to spot important new ones that tools like this report)

Coverity also complains about the way we calculate the offset
(starting from the address of a 4 byte array within the
header structure rather than from the beginning of the struct
plus 4 bytes) for SMB1 RenameOpenFile. This changeset
doesn't change the address but makes it slightly clearer.

Addresses-Coverity: 711521 ("Out of bounds write")
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifssmb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 0863238ddd20..16bd4cf3bceb 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2767,7 +2767,8 @@ int CIFSSMBRenameOpenFile(const unsigned int
xid, struct cifs_tcon *pTcon,
  param_offset = offsetof(struct smb_com_transaction2_sfi_req, Fid) - 4;
  offset = param_offset + params;

- data_offset = (char *) (&pSMB->hdr.Protocol) + offset;
+ /* SMB offsets are from the beginning of SMB which is 4 bytes in,
after RFC1001 field */
+ data_offset = (char *)(pSMB) + offset + 4;
  rename_info = (struct set_file_rename *) data_offset;
  pSMB->MaxParameterCount = cpu_to_le16(2);
  pSMB->MaxDataCount = cpu_to_le16(1000); /* BB find max SMB from sess */

-- 
Thanks,

Steve

--000000000000f0ac2205c68cdef4
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-CIFS-Clarify-SMB1-code-for-rename-open-file.patch"
Content-Disposition: attachment; 
	filename="0001-CIFS-Clarify-SMB1-code-for-rename-open-file.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kqttt1yb0>
X-Attachment-Id: f_kqttt1yb0

RnJvbSBhMmM2YjVmOTUyMjZkNThmODU4NjRmNWEzMGU4OTJiNWVjODg1YmQ2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgNyBKdWwgMjAyMSAxMzozNDo0NyAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIENJ
RlM6IENsYXJpZnkgU01CMSBjb2RlIGZvciByZW5hbWUgb3BlbiBmaWxlCgpDb3Zlcml0eSBhbHNv
IGNvbXBsYWlucyBhYm91dCB0aGUgd2F5IHdlIGNhbGN1bGF0ZSB0aGUgb2Zmc2V0CihzdGFydGlu
ZyBmcm9tIHRoZSBhZGRyZXNzIG9mIGEgNCBieXRlIGFycmF5IHdpdGhpbiB0aGUKaGVhZGVyIHN0
cnVjdHVyZSByYXRoZXIgdGhhbiBmcm9tIHRoZSBiZWdpbm5pbmcgb2YgdGhlIHN0cnVjdApwbHVz
IDQgYnl0ZXMpIGZvciBTTUIxIFJlbmFtZU9wZW5GaWxlLiBUaGlzIGNoYW5nZXNldApkb2Vzbid0
IGNoYW5nZSB0aGUgYWRkcmVzcyBidXQgbWFrZXMgaXQgc2xpZ2h0bHkgY2xlYXJlci4KCkFkZHJl
c3Nlcy1Db3Zlcml0eTogNzExNTIxICgiT3V0IG9mIGJvdW5kcyB3cml0ZSIpClNpZ25lZC1vZmYt
Ynk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2Np
ZnNzbWIuYyB8IDMgKystCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0
aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzc21iLmMgYi9mcy9jaWZzL2NpZnNzbWIu
YwppbmRleCAwODYzMjM4ZGRkMjAuLjE2YmQ0Y2YzYmNlYiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9j
aWZzc21iLmMKKysrIGIvZnMvY2lmcy9jaWZzc21iLmMKQEAgLTI3NjcsNyArMjc2Nyw4IEBAIGlu
dCBDSUZTU01CUmVuYW1lT3BlbkZpbGUoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNp
ZnNfdGNvbiAqcFRjb24sCiAJcGFyYW1fb2Zmc2V0ID0gb2Zmc2V0b2Yoc3RydWN0IHNtYl9jb21f
dHJhbnNhY3Rpb24yX3NmaV9yZXEsIEZpZCkgLSA0OwogCW9mZnNldCA9IHBhcmFtX29mZnNldCAr
IHBhcmFtczsKIAotCWRhdGFfb2Zmc2V0ID0gKGNoYXIgKikgKCZwU01CLT5oZHIuUHJvdG9jb2wp
ICsgb2Zmc2V0OworCS8qIFNNQiBvZmZzZXRzIGFyZSBmcm9tIHRoZSBiZWdpbm5pbmcgb2YgU01C
IHdoaWNoIGlzIDQgYnl0ZXMgaW4sIGFmdGVyIFJGQzEwMDEgZmllbGQgKi8KKwlkYXRhX29mZnNl
dCA9IChjaGFyICopKHBTTUIpICsgb2Zmc2V0ICsgNDsKIAlyZW5hbWVfaW5mbyA9IChzdHJ1Y3Qg
c2V0X2ZpbGVfcmVuYW1lICopIGRhdGFfb2Zmc2V0OwogCXBTTUItPk1heFBhcmFtZXRlckNvdW50
ID0gY3B1X3RvX2xlMTYoMik7CiAJcFNNQi0+TWF4RGF0YUNvdW50ID0gY3B1X3RvX2xlMTYoMTAw
MCk7IC8qIEJCIGZpbmQgbWF4IFNNQiBmcm9tIHNlc3MgKi8KLS0gCjIuMzAuMgoK
--000000000000f0ac2205c68cdef4--
