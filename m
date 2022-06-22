Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43783C43334
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Jun 2022 17:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376294AbiFVRkh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Jun 2022 13:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376298AbiFVRkd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Jun 2022 13:40:33 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BFA2F671
        for <linux-cifs@vger.kernel.org>; Wed, 22 Jun 2022 10:40:33 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id k19so6593891uap.7
        for <linux-cifs@vger.kernel.org>; Wed, 22 Jun 2022 10:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=V1GPNoYupLN1l6N7YoEN1tScrnyWxqAzcapEFkIJZBs=;
        b=opJR25knYoTrVZ0xqPHsRpde8BBADikg4AXMO/KzvWrz7LweSZwyeleWTm9yUrDvBJ
         BeMy/aO7rCSqJYI/OounimviS9aN4pPZSaemAI0HqHqoTltOqe1I+ec1RSU/e4hUBIA/
         EW6oAdCNXK7AYxewD+E6Ywqb1RYXgiYmgYRpTz3rrLgZszPvY68XIg0JQP12CmRT5ZvC
         xt//AXF+zmkkYfMBdO9H/5OuFC+iea+pWGUVHZteTrN4YGWcNLfrxi8o2GD9EQX0ycqb
         TxXPpdcWMYNSa3Fe4D7utgdf4cjs1PyZU7c6T0iNrzcrCSDVFe7+HW5o0RyDJJWaJqq2
         jwzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=V1GPNoYupLN1l6N7YoEN1tScrnyWxqAzcapEFkIJZBs=;
        b=6FgTAXIwv8Gs2tSuK3l2IAw4kWeb42QUUC7/0HmRo/0a6FFxhXnU468HjItvhtkD3z
         PDS8ew2LdxD6M6PgK4fy/EH94ys/EAZQYvc8nPQlwgXsiOD1EURyW+gcTb14BHxdDMdD
         kGDo5t/Zp6wY71UFM6SC8cBN6/cS+aB+b1LDM6gatOYJR6MPARRkadqnwQiw3zxxBMNW
         8Ln+LE0qkKtvkAm46qqOdhEDOi2RZGruRkPaEXJQRSKULB8zQf2heEA+QgAu2EOiEZpt
         e89+1hw368MviKlK7nth1sj5W3B5qm8ExenA4QOguXWtiydWD7f43EzkIHHhU1BSkUcm
         QTtQ==
X-Gm-Message-State: AJIora/nWIEfhidNb5hTa46DsaFjf4ezjM6wgENTHcFsgALD6S3w2JsX
        fuhK5vfsBguduleKQ9M6+JOmvF3xkShU+O/XLvA+oap7
X-Google-Smtp-Source: AGRyM1tZLK6tJkfAWd0+J5ld0bd0nieAl0L2kGXHl84TYXTZuBJcMvXL0gi1csab4/1w2eXO7ZUFa+HdafOgMKmx69c=
X-Received: by 2002:ab0:6704:0:b0:37c:c743:eebe with SMTP id
 q4-20020ab06704000000b0037cc743eebemr2549390uam.84.1655919631840; Wed, 22 Jun
 2022 10:40:31 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 22 Jun 2022 12:40:21 -0500
Message-ID: <CAH2r5mtU0EZsAdLMeTnO7RNwokK0GBVq_jFdWUSvxfJD_xTE-g@mail.gmail.com>
Subject: [PATCH][SMB3] follow on patch to make sure secondary channels use the
 primary channels hostname
To:     CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000006ed07e05e20cd52c"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000006ed07e05e20cd52c
Content-Type: text/plain; charset="UTF-8"

See attached.


-- 
Thanks,

Steve

--0000000000006ed07e05e20cd52c
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-use-netname-when-available-on-secondary-channel.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-use-netname-when-available-on-secondary-channel.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l4pvsazs0>
X-Attachment-Id: f_l4pvsazs0

RnJvbSA5N2I0MjI3MDQ5NDBiOTdlYTI1OWQ5N2Y5NzRhZDMyN2Y2NDgyMjViIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBXZWQsIDIyIEp1biAyMDIyIDEyOjM2OjM2IC0wNTAwClN1YmplY3Q6IFtQQVRDSF0g
c21iMzogdXNlIG5ldG5hbWUgd2hlbiBhdmFpbGFibGUgb24gc2Vjb25kYXJ5IGNoYW5uZWxzCgpT
b21lIHNlcnZlcnMgZG8gbm90IGFsbG93IG51bGwgbmV0bmFtZSBjb250ZXh0cywgd2hpY2ggd291
bGQgY2F1c2UKbXVsdGljaGFubmVsIHRvIHJldmVydCB0byBzaW5nbGUgY2hhbm5lbCB3aGVuIG1v
dW50aW5nIHRvIHNvbWUKc2VydmVycyAoZS5nLiBBenVyZSB4U01CKS4gVGhlIHByZXZpb3VzIHBh
dGNoIGZpeGVkIHRoYXQsIHRoaXMKcGF0Y2ggYWxzbyBmaXhlcyB0aGUgc2Vjb25kYXJ5IGNoYW5u
ZWwgY2FzZSBieSB1c2luZyB0aGUgbmV0bmFtZQpjb250ZXh0IHVzZWQgZm9yIHByaW1hcnkgY2hh
bm5lbCBmb3IgdGhlIHNlY29uZGFyeSBjaGFubmVsLgoKRml4ZXM6IDRjMTRkNzA0M2ZlZGUgKCJj
aWZzOiBwb3B1bGF0ZSBlbXB0eSBob3N0bmFtZXMgZm9yIGV4dHJhIGNoYW5uZWxzIikKU2lnbmVk
LW9mZi1ieTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0LmNvbT4KU2lnbmVkLW9m
Zi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMv
c21iMnBkdS5jIHwgMTEgKysrKysrKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMo
KyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycGR1LmMgYi9mcy9j
aWZzL3NtYjJwZHUuYwppbmRleCA1ZThjNDczN2IxODMuLjEyYjRkZGRhZWRiMCAxMDA2NDQKLS0t
IGEvZnMvY2lmcy9zbWIycGR1LmMKKysrIGIvZnMvY2lmcy9zbWIycGR1LmMKQEAgLTU0Myw2ICs1
NDMsNyBAQCBhc3NlbWJsZV9uZWdfY29udGV4dHMoc3RydWN0IHNtYjJfbmVnb3RpYXRlX3JlcSAq
cmVxLAogCQkgICAgICBzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsIHVuc2lnbmVkIGlu
dCAqdG90YWxfbGVuKQogewogCWNoYXIgKnBuZWdfY3R4dDsKKwljaGFyICpob3N0bmFtZSA9IE5V
TEw7CiAJdW5zaWduZWQgaW50IGN0eHRfbGVuLCBuZWdfY29udGV4dF9jb3VudDsKIAogCWlmICgq
dG90YWxfbGVuID4gMjAwKSB7CkBAIC01NzQsOSArNTc1LDE1IEBAIGFzc2VtYmxlX25lZ19jb250
ZXh0cyhzdHJ1Y3Qgc21iMl9uZWdvdGlhdGVfcmVxICpyZXEsCiAJKnRvdGFsX2xlbiArPSBzaXpl
b2Yoc3RydWN0IHNtYjJfcG9zaXhfbmVnX2NvbnRleHQpOwogCXBuZWdfY3R4dCArPSBzaXplb2Yo
c3RydWN0IHNtYjJfcG9zaXhfbmVnX2NvbnRleHQpOwogCi0JaWYgKHNlcnZlci0+aG9zdG5hbWUg
JiYgKHNlcnZlci0+aG9zdG5hbWVbMF0gIT0gMCkpIHsKKwkvKgorCSAqIHNlY29uZGFyeSBjaGFu
bmVscyBkb24ndCBoYXZlIHRoZSBob3N0bmFtZSBmaWVsZCBwb3B1bGF0ZWQKKwkgKiB1c2UgdGhl
IGhvc3RuYW1lIGZpZWxkIGluIHRoZSBwcmltYXJ5IGNoYW5uZWwgaW5zdGVhZAorCSAqLworCWhv
c3RuYW1lID0gQ0lGU19TRVJWRVJfSVNfQ0hBTihzZXJ2ZXIpID8KKwkJc2VydmVyLT5wcmltYXJ5
X3NlcnZlci0+aG9zdG5hbWUgOiBzZXJ2ZXItPmhvc3RuYW1lOworCWlmIChob3N0bmFtZSAmJiAo
aG9zdG5hbWVbMF0gIT0gMCkpIHsKIAkJY3R4dF9sZW4gPSBidWlsZF9uZXRuYW1lX2N0eHQoKHN0
cnVjdCBzbWIyX25ldG5hbWVfbmVnX2NvbnRleHQgKilwbmVnX2N0eHQsCi0JCQkJCXNlcnZlci0+
aG9zdG5hbWUpOworCQkJCQkgICAgICBob3N0bmFtZSk7CiAJCSp0b3RhbF9sZW4gKz0gY3R4dF9s
ZW47CiAJCXBuZWdfY3R4dCArPSBjdHh0X2xlbjsKIAkJbmVnX2NvbnRleHRfY291bnQgPSA0Owot
LSAKMi4zNC4xCgo=
--0000000000006ed07e05e20cd52c--
