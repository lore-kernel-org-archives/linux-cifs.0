Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC78C77B60
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Apr 2023 05:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345280AbjD1FZJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Apr 2023 01:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbjD1FZJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Apr 2023 01:25:09 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23D11BFA
        for <linux-cifs@vger.kernel.org>; Thu, 27 Apr 2023 22:25:07 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4efe8991b8aso8017603e87.0
        for <linux-cifs@vger.kernel.org>; Thu, 27 Apr 2023 22:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682659506; x=1685251506;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+Pkw4IIS78xGsVo76jiygiHP0EH2VxbAPcuA/FeQLmI=;
        b=cgn2LfzuIBiXmx8G2HQwmiuzfVDVfmF27zqONYkhDSa0Hm8emzF/FVaEGOicc13dqb
         HciTptyilMsL7yU3VQL8QUy/97jM2u/skblIAsIocy7TH3MGnAQtSFpV6wgrWDagyKDg
         sLWCctEe/SCat72r/ZuQa7SdhEAXel7REiF8gBVcuWOt/kbIZZgpx7B9GEj428yVYRiH
         TDmA9Xd1ilaVGBuPvSK6jS8lfAtM/Pi7MO8cbBPcmRcZm0Es3RyfA1hO4QoYSP7Pxxg3
         C0wI7ZANJnKs8cDtloa3JZGJ6vaj1jL+K4i3wq4xkMQvZDTen1QofIta0JkrwYA9p4P+
         gzkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682659506; x=1685251506;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+Pkw4IIS78xGsVo76jiygiHP0EH2VxbAPcuA/FeQLmI=;
        b=ZjRhpmxSxbllV1TVi9a44evXI+MucbEA806oypzyn+PyB0sONx72g6accMCeIxGnxI
         fw+8bonk8QilwOixY9fCblwYdHt22l3aRod5cRhcILNKYTHqA/i3dHZISG5KxC9YUPRu
         uv7TKVCZm9SMNhYE4VUGu839n/5bwtG1KybmfZAvSB3OqJID0UWKTcAVuMrW3UhqKvN8
         JLwMqUeEr1IISQI8QslHq2YT/cnBptFTumvYPi/jq8a4Bm1R/bYwrpmhCJ0tpq9ABAqy
         kMq87vMNeJmTlZzzIwaqcECwnBr5N6ZgPEYteUIgxfYly6LVXdYWQZaVYtUts0aUl0oX
         4LSg==
X-Gm-Message-State: AC+VfDxtIqhYZRwMZv9AwWf4zqtCe+GC6v0hk7aYHysgc1ddIdqeigg5
        uY4k3/Q87+w2zrMFm/5W4TWkco5THhWEPo9o2Aj7DAyoI8o=
X-Google-Smtp-Source: ACHHUZ42la2VKSeTdIlt8+Ln2GmX7pdcn3vz2KWrDCou3L5XbRBEuJw9/sy2ph1Xbwk4hgVupbQMecwZAXJ+O2WDA34=
X-Received: by 2002:ac2:4c10:0:b0:4e9:5f8e:315a with SMTP id
 t16-20020ac24c10000000b004e95f8e315amr1131260lfq.65.1682659505576; Thu, 27
 Apr 2023 22:25:05 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 28 Apr 2023 00:24:54 -0500
Message-ID: <CAH2r5ms+mTNU746nkbAjb9FOdiaAcK9rQK76NMv6Njd0MsDq7A@mail.gmail.com>
Subject: [PATCH][CIFS] fix incorrect size for query_on_disk_id
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Content-Type: multipart/mixed; boundary="0000000000001bb46d05fa5eb287"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000001bb46d05fa5eb287
Content-Type: text/plain; charset="UTF-8"

We were assuming the wrong size for the struct, use the ksmbd
    version of this struct and move it to common code.



-- 
Thanks,

Steve

--0000000000001bb46d05fa5eb287
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-incorrect-size-for-query_on_disk_id-open-co.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-incorrect-size-for-query_on_disk_id-open-co.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lh040lq80>
X-Attachment-Id: f_lh040lq80

RnJvbSBiMWU1YTk1YTA3Y2RjYzc1NWEwMGVlMGMzZmM5MTg3Yjc3MTA5YzFmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMjggQXByIDIwMjMgMDA6MjE6MTAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggaW5jb3JyZWN0IHNpemUgZm9yIHF1ZXJ5X29uX2Rpc2tfaWQgb3BlbiBjb250ZXh0
CgpXZSB3ZXJlIGFzc3VtaW5nIHRoZSB3cm9uZyBzaXplIGZvciB0aGUgc3RydWN0LCB1c2UgdGhl
IGtzbWJkCnZlcnNpb24gb2YgdGhpcyBzdHJ1Y3QgYW5kIG1vdmUgaXQgdG8gY29tbW9uIGNvZGUu
CgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0t
LQogZnMvY2lmcy9zbWIycGR1LmMgICAgICAgICB8ICAyICstCiBmcy9rc21iZC9zbWIycGR1Lmgg
ICAgICAgIHwgIDggLS0tLS0tLS0KIGZzL3NtYmZzX2NvbW1vbi9zbWIycGR1LmggfCAxMSArKysr
KysrKysrKwogMyBmaWxlcyBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5k
ZXggMjgxZTBiMTI2NThkLi4wNTIxYWExZGE2NDQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBk
dS5jCisrKyBiL2ZzL2NpZnMvc21iMnBkdS5jCkBAIC0yMDYzLDcgKzIwNjMsNyBAQCBjcmVhdGVf
cmVjb25uZWN0X2R1cmFibGVfYnVmKHN0cnVjdCBjaWZzX2ZpZCAqZmlkKQogc3RhdGljIHZvaWQK
IHBhcnNlX3F1ZXJ5X2lkX2N0eHQoc3RydWN0IGNyZWF0ZV9jb250ZXh0ICpjYywgc3RydWN0IHNt
YjJfZmlsZV9hbGxfaW5mbyAqYnVmKQogewotCXN0cnVjdCBjcmVhdGVfb25fZGlza19pZCAqcGRp
c2tfaWQgPSAoc3RydWN0IGNyZWF0ZV9vbl9kaXNrX2lkICopY2M7CisJc3RydWN0IGNyZWF0ZV9k
aXNrX2lkX3JzcCAqcGRpc2tfaWQgPSAoc3RydWN0IGNyZWF0ZV9kaXNrX2lkX3JzcCAqKWNjOwog
CiAJY2lmc19kYmcoRllJLCAicGFyc2UgcXVlcnkgaWQgY29udGV4dCAweCVsbHggMHglbGx4XG4i
LAogCQlwZGlza19pZC0+RGlza0ZpbGVJZCwgcGRpc2tfaWQtPlZvbHVtZUlkKTsKZGlmZiAtLWdp
dCBhL2ZzL2tzbWJkL3NtYjJwZHUuaCBiL2ZzL2tzbWJkL3NtYjJwZHUuaAppbmRleCA5NDIwZGQy
ODEzZmIuLmJjZjcxZmQ0ZGMxZSAxMDA2NDQKLS0tIGEvZnMva3NtYmQvc21iMnBkdS5oCisrKyBi
L2ZzL2tzbWJkL3NtYjJwZHUuaApAQCAtMTQ0LDE0ICsxNDQsNiBAQCBzdHJ1Y3QgY3JlYXRlX214
YWNfcnNwIHsKIAlfX2xlMzIgTWF4aW1hbEFjY2VzczsKIH0gX19wYWNrZWQ7CiAKLXN0cnVjdCBj
cmVhdGVfZGlza19pZF9yc3AgewotCXN0cnVjdCBjcmVhdGVfY29udGV4dCBjY29udGV4dDsKLQlf
X3U4ICAgTmFtZVs4XTsKLQlfX2xlNjQgRGlza0ZpbGVJZDsKLQlfX2xlNjQgVm9sdW1lSWQ7Ci0J
X191OCAgUmVzZXJ2ZWRbMTZdOwotfSBfX3BhY2tlZDsKLQogLyogZXF1aXZhbGVudCBvZiB0aGUg
Y29udGVudHMgb2YgU01CMy4xLjEgUE9TSVggb3BlbiBjb250ZXh0IHJlc3BvbnNlICovCiBzdHJ1
Y3QgY3JlYXRlX3Bvc2l4X3JzcCB7CiAJc3RydWN0IGNyZWF0ZV9jb250ZXh0IGNjb250ZXh0Owpk
aWZmIC0tZ2l0IGEvZnMvc21iZnNfY29tbW9uL3NtYjJwZHUuaCBiL2ZzL3NtYmZzX2NvbW1vbi9z
bWIycGR1LmgKaW5kZXggYWNlMTMzY2Y2MDcyLi5lYWI4MDFlZTVjZjMgMTAwNjQ0Ci0tLSBhL2Zz
L3NtYmZzX2NvbW1vbi9zbWIycGR1LmgKKysrIGIvZnMvc21iZnNfY29tbW9uL3NtYjJwZHUuaApA
QCAtMTE4MCw2ICsxMTgwLDcgQEAgc3RydWN0IGNyZWF0ZV9wb3NpeCB7CiAKICNkZWZpbmUgU01C
Ml9MRUFTRV9LRVlfU0laRQkJCTE2CiAKKy8qIFNlZSBNUy1TTUIyIDIuMi4xMy4yLjggKi8KIHN0
cnVjdCBsZWFzZV9jb250ZXh0IHsKIAlfX3U4IExlYXNlS2V5W1NNQjJfTEVBU0VfS0VZX1NJWkVd
OwogCV9fbGUzMiBMZWFzZVN0YXRlOwpAQCAtMTE4Nyw2ICsxMTg4LDcgQEAgc3RydWN0IGxlYXNl
X2NvbnRleHQgewogCV9fbGU2NCBMZWFzZUR1cmF0aW9uOwogfSBfX3BhY2tlZDsKIAorLyogU2Vl
IE1TLVNNQjIgMi4yLjEzLjIuMTAgKi8KIHN0cnVjdCBsZWFzZV9jb250ZXh0X3YyIHsKIAlfX3U4
IExlYXNlS2V5W1NNQjJfTEVBU0VfS0VZX1NJWkVdOwogCV9fbGUzMiBMZWFzZVN0YXRlOwpAQCAt
MTIxMCw2ICsxMjEyLDE1IEBAIHN0cnVjdCBjcmVhdGVfbGVhc2VfdjIgewogCV9fdTggICBQYWRb
NF07CiB9IF9fcGFja2VkOwogCisvKiBTZWUgTVMtU01CMiAyLjIuMTQuMi45ICovCitzdHJ1Y3Qg
Y3JlYXRlX2Rpc2tfaWRfcnNwIHsKKwlzdHJ1Y3QgY3JlYXRlX2NvbnRleHQgY2NvbnRleHQ7CisJ
X191OCAgIE5hbWVbOF07CisJX19sZTY0IERpc2tGaWxlSWQ7CisJX19sZTY0IFZvbHVtZUlkOwor
CV9fdTggIFJlc2VydmVkWzE2XTsKK30gX19wYWNrZWQ7CisKIC8qIFNlZSBNUy1TTUIyIDIuMi4z
MSBhbmQgMi4yLjMyICovCiBzdHJ1Y3Qgc21iMl9pb2N0bF9yZXEgewogCXN0cnVjdCBzbWIyX2hk
ciBoZHI7Ci0tIAoyLjM0LjEKCg==
--0000000000001bb46d05fa5eb287--
