Return-Path: <SRS0=ZPc7=DR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E0B6C43457
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Oct 2020 23:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B66F2075E
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Oct 2020 23:11:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qlllb9xh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbgJJXLA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 10 Oct 2020 19:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731390AbgJJW4K (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 10 Oct 2020 18:56:10 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757AFC0604C1
        for <linux-cifs@vger.kernel.org>; Sat, 10 Oct 2020 15:54:16 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id j30so12132695lfp.4
        for <linux-cifs@vger.kernel.org>; Sat, 10 Oct 2020 15:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=umacdKU1qmBShUCe+7sYcDokc+EmtIwI1pG19qTX9PI=;
        b=Qlllb9xh2s+9qqeYnF9wdtHkOHuUinTuZLEmj+i1bglVEKZZ1Qhcvehx0GK84+iLcc
         I3U9LtXT6h8vYS3YTQi/+IS7DC/3OUiZEkNDAkQ77M7hcBYWy+N44GXDUoytejjXovs4
         XEsENFi6LQOQZZMwRj9dONKwgLPwZaXZ4rpY10nv191rAtRYbw1r7QBsE25JM5zFFu1A
         QmHAaCpQ6bJd0UxM1LQcsE0IfsdW5DtJmNtrojDiLP0HTczeGLGsR2GGmRYS4yvuRKlj
         Sg5LtlTUGiHhbm/86CarxWaYNQQ51aINQyv1crgfoXVVuNnDYv8snHzLkS7s5362rjOq
         5xYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=umacdKU1qmBShUCe+7sYcDokc+EmtIwI1pG19qTX9PI=;
        b=sjB5z+/iVP1ZE5oRToxI2i+Ttv0CtMWawDVGGNvMDKb1jsAoXzdndD+0FfdaoXOFqK
         UXltc6y/J8GZyxx+XfqzFzXkspv8nSvFYpPfCn31kzi3EYER/+qxgMn5cv40VUTOQXcb
         gpG21FhQuoDESfpFMAURXS1giARQ9ZEGPnqFxoo68t+lM0y9nLIqDtGcuO5ZZ/d+LX/j
         cpYLp971iWUMmpzkfnvU5vawdvqaaMv6L9cDh/3UxHBaulcpDOTEWq7cdrW0f6GXOOn+
         woz8H0YkAQup96G2RWC7UsRKPgzj+skCTPFFa7HpOddtlM10W5GGmCJnbiP4DNDlaD2I
         WQDg==
X-Gm-Message-State: AOAM533IZV465XNwhfrpalv52Rk4R9+J4zDSt2U/GTr8tMPFNsCFoIRk
        ZAniqgFsxCbSOa+tqz6b+7za84LUMoG86Ktr3GNe6ag0TEk=
X-Google-Smtp-Source: ABdhPJyHK0/K1DYPChLeECYPGSCY8SDcj8vg1CY/C1FNei1GAzWO858u2ATc9mcxDHSJd49100EIJxffPt8EMfdtpm4=
X-Received: by 2002:a19:83c1:: with SMTP id f184mr20352lfd.97.1602370453386;
 Sat, 10 Oct 2020 15:54:13 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 10 Oct 2020 17:54:01 -0500
Message-ID: <CAH2r5mv9wcoLkBZbrxrOB_NTsm1fpiYc04b9akOAkHDtuiCF_Q@mail.gmail.com>
Subject: [PATCH] cifs: fix memory corruption setting EAs on 32 bit systems
To:     CIFS <linux-cifs@vger.kernel.org>, vz@mleia.com,
        vladimir@tuxera.com
Content-Type: multipart/mixed; boundary="000000000000ac879d05b158f194"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000ac879d05b158f194
Content-Type: text/plain; charset="UTF-8"

Original patch was corrupted.   Fixed the whitespace/tab and
formatting issues and added cc:stable.

Merged into cifs-2.6.git for-next pending testing/review

Vladimir,
Would you verify that the updated patch matches what you expect?
Probably easier to send future patches as attachments or links to git
tree commit to avoid the usual email corruption of non-plain text
patches.
-- 
Thanks,

Steve

--000000000000ac879d05b158f194
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-memory-corruption-setting-EAs-on-32-bit-sys.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-memory-corruption-setting-EAs-on-32-bit-sys.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kg49wbr70>
X-Attachment-Id: f_kg49wbr70

RnJvbSA1YzExOWMzNzZlMTBmNGU5NDNkMTQzZDQyZGVmYjRlMGUxYmM2NGUzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBWbGFkaW1pciBaYXBvbHNraXkgPHZsYWRpbWlyQHR1eGVyYS5j
b20+CkRhdGU6IFNhdCwgMTAgT2N0IDIwMjAgMTc6NDQ6MTggLTA1MDAKU3ViamVjdDogW1BBVENI
XSBjaWZzOiBmaXggbWVtb3J5IGNvcnJ1cHRpb24gc2V0dGluZyBFQXMgb24gMzIgYml0IHN5c3Rl
bXMKCk9uIHNldHhhdHRyKCkgc3lzY2FsbCBwYXRoIGR1ZSB0byBhbiBhcHByZW50IHR5cG8gdGhl
IHNpemUgb2YgYSBkeW5hbWljYWxseQphbGxvY2F0ZWQgbWVtb3J5IGNodW5rIGZvciBzdG9yaW5n
IHN0cnVjdCBzbWIyX2ZpbGVfZnVsbF9lYV9pbmZvIG9iamVjdCBpcwpjb21wdXRlZCBpbmNvcnJl
Y3RseSwgdG8gYmUgbW9yZSBwcmVjaXNlIHRoZSBmaXJzdCBhZGRlbmQgaXMgdGhlIHNpemUgb2YK
YSBwb2ludGVyIGluc3RlYWQgb2YgdGhlIHdhbnRlZCBvYmplY3Qgc2l6ZS4gQ29pbmNpZGVudGFs
bHkgaXQgbWFrZXMgbm8KZGlmZmVyZW5jZSBvbiA2NC1iaXQgcGxhdGZvcm1zLCBob3dldmVyIG9u
IDMyLWJpdCB0YXJnZXRzIHRoZSBmb2xsb3dpbmcKbWVtY3B5KCkgd3JpdGVzIDQgYnl0ZXMgb2Yg
ZGF0YSBvdXRzaWRlIG9mIHRoZSBkeW5hbWljYWxseSBhbGxvY2F0ZWQgbWVtb3J5LgoKICBCVUcg
a21hbGxvYy0xNiAoTm90IHRhaW50ZWQpOiBSZWR6b25lIG92ZXJ3cml0dGVuCiAgLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0KCiAgRGlzYWJsaW5nIGxvY2sgZGVidWdnaW5nIGR1ZSB0byBrZXJuZWwgdGFp
bnQKICBJTkZPOiAweDc5ZTY5YTZmLTB4OWU1Y2RlY2YgQG9mZnNldD0zNjguIEZpcnN0IGJ5dGUg
MHg3MyBpbnN0ZWFkIG9mIDB4Y2MKICBJTkZPOiBTbGFiIDB4ZDM2ZDI0NTQgb2JqZWN0cz04NSB1
c2VkPTUxIGZwPTB4ZjdkMGZjN2EgZmxhZ3M9MHgzNTAwMDIwMQogIElORk86IE9iamVjdCAweDZm
MTcxZGYzIEBvZmZzZXQ9MzUyIGZwPTB4MDAwMDAwMDAKCiAgUmVkem9uZSA1ZDRmZjAyZDogY2Mg
Y2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgIC4uLi4uLi4uLi4u
Li4uLi4KICBPYmplY3QgNmYxNzFkZjM6IDAwIDAwIDAwIDAwIDAwIDA1IDA2IDAwIDczIDZlIDcy
IDc1IDYyIDAwIDY2IDY5ICAuLi4uLi4uLnNucnViLmZpCiAgUmVkem9uZSA3OWU2OWE2ZjogNzMg
NjggMzIgMGEgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNoMi4KICBQYWRk
aW5nIDU2MjU0ZDgyOiA1YSA1YSA1YSA1YSA1YSA1YSA1YSA1YSAgICAgICAgICAgICAgICAgICAg
ICAgICAgWlpaWlpaWloKICBDUFU6IDAgUElEOiA4MTk2IENvbW06IGF0dHIgVGFpbnRlZDogRyAg
ICBCICAgICAgICAgICAgIDUuOS4wLXJjOCsgIzMKICBIYXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5k
YXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyAxLjEzLjAtMSAwNC8wMS8yMDE0CiAg
Q2FsbCBUcmFjZToKICAgZHVtcF9zdGFjaysweDU0LzB4NmUKICAgcHJpbnRfdHJhaWxlcisweDEy
Yy8weDEzNAogICBjaGVja19ieXRlc19hbmRfcmVwb3J0LmNvbGQrMHgzZS8weDY5CiAgIGNoZWNr
X29iamVjdCsweDE4Yy8weDI1MAogICBmcmVlX2RlYnVnX3Byb2Nlc3NpbmcrMHhmZS8weDIzMAog
ICBfX3NsYWJfZnJlZSsweDFjMC8weDMwMAogICBrZnJlZSsweDFkMy8weDIyMAogICBzbWIyX3Nl
dF9lYSsweDI3ZC8weDU0MAogICBjaWZzX3hhdHRyX3NldCsweDU3Zi8weDYyMAogICBfX3Zmc19z
ZXR4YXR0cisweDRlLzB4NjAKICAgX192ZnNfc2V0eGF0dHJfbm9wZXJtKzB4NGUvMHgxMDAKICAg
X192ZnNfc2V0eGF0dHJfbG9ja2VkKzB4YWUvMHhkMAogICB2ZnNfc2V0eGF0dHIrMHg0ZS8weGUw
CiAgIHNldHhhdHRyKzB4MTJjLzB4MWEwCiAgIHBhdGhfc2V0eGF0dHIrMHhhNC8weGMwCiAgIF9f
aWEzMl9zeXNfbHNldHhhdHRyKzB4MWQvMHgyMAogICBfX2RvX2Zhc3Rfc3lzY2FsbF8zMisweDQw
LzB4NzAKICAgZG9fZmFzdF9zeXNjYWxsXzMyKzB4MjkvMHg2MAogICBkb19TWVNFTlRFUl8zMisw
eDE1LzB4MjAKICAgZW50cnlfU1lTRU5URVJfMzIrMHg5Zi8weGYyCgpGaXhlczogNTUxNzU1NGU0
MzEzICgiY2lmczogQWRkIHN1cHBvcnQgZm9yIHdyaXRpbmcgYXR0cmlidXRlcyBvbiBTTUIyKyIp
ClNpZ25lZC1vZmYtYnk6IFZsYWRpbWlyIFphcG9sc2tpeSA8dmxhZGltaXJAdHV4ZXJhLmNvbT4K
Q0M6IFN0YWJsZSA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gI3Y0LjE0KwpTaWduZWQtb2ZmLWJ5
OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIy
b3BzLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24o
LSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21iMm9wcy5jCmlu
ZGV4IDI0ZjEwN2Y3NjNmMC4uNzZkODJhNjBhNTUwIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJv
cHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtMTIxNiw3ICsxMjE2LDcgQEAgc21iMl9z
ZXRfZWEoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAly
cXN0WzFdLnJxX2lvdiA9IHNpX2lvdjsKIAlycXN0WzFdLnJxX252ZWMgPSAxOwogCi0JbGVuID0g
c2l6ZW9mKGVhKSArIGVhX25hbWVfbGVuICsgZWFfdmFsdWVfbGVuICsgMTsKKwlsZW4gPSBzaXpl
b2YoKmVhKSArIGVhX25hbWVfbGVuICsgZWFfdmFsdWVfbGVuICsgMTsKIAllYSA9IGt6YWxsb2Mo
bGVuLCBHRlBfS0VSTkVMKTsKIAlpZiAoZWEgPT0gTlVMTCkgewogCQlyYyA9IC1FTk9NRU07Ci0t
IAoyLjI1LjEKCg==
--000000000000ac879d05b158f194--
