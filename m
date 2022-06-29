Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0804DC43334
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Jun 2022 08:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiF2I00 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Jun 2022 04:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbiF2I00 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Jun 2022 04:26:26 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C443C704
        for <linux-cifs@vger.kernel.org>; Wed, 29 Jun 2022 01:26:25 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id go6so15053294pjb.0
        for <linux-cifs@vger.kernel.org>; Wed, 29 Jun 2022 01:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=zbP0a5KkWNtns43J/qlm9ty8V4cWc9u5ybK4CMLezB8=;
        b=otb4z8HfGCD1vdMSGgTm0BLz8Kzn77TOSHWmb70qOJRnxtSBj6rSNyoShRXjB8STsN
         fuYHrDk7kC/IB5+5SErr1FXUT5GtRACsQeATOr/oIokMULSvVCDZnZL6q1U6bVAMQ6ao
         wZhb5jZz1MJCRNhiKCIWZq977HPUJMJnbqypLTlG01yYSw/UqW4Og4gkPNqn1snwKcql
         1dQHf5KtXheR9p41pyOgtPEsiO/0KE5Ju77YnPnEENN8OuMFNADC5CwNsG2qTCOJPQ6s
         NYPrvCHjaTNJrF0Lakljy1Pd3uBKSRR4Tl2dkBHOqjBm/vN/vCm0ACuqfeC4yzLd2D7l
         E14Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=zbP0a5KkWNtns43J/qlm9ty8V4cWc9u5ybK4CMLezB8=;
        b=CGG9QtoJmZdVQxEQmA+3XJbax/qM1ZtecoqYPfaEPJzPkPfCEw3PDcY4im4rtshsi8
         BhwQwoLGkvglkSkkToxeodtKfFpgqsHurHX+bv9COqgUrCUG3x628FFLgG2b8s7FIzN+
         rY7EcBBrMR4Kq9SFyhUtPLSpstyLKun342fdjGtT0eS0FTpGLArLqvO87QISJ9eKzi0g
         75UXXRxiW7+oSbveDzxZdXSpw9myd9gvCUDLUMMeVLW8T3CRCC3Z7RWjk6zx6xQf/SyW
         dTHA7ja1VI+N3TytyZaWasxzfBDJFBnsrsGKrlxHYbatMBTO42KyE+oQ2XV7iv68X/8h
         CjKg==
X-Gm-Message-State: AJIora85fnjCawfd2/kDTcjMHqw6yq4r2gWnssMJm+hqSXXeBnv9cIkO
        mIN0eAdiyu1/BXHYIrkawSB/PlYnz5q8wDiD5D3LxT2i
X-Google-Smtp-Source: AGRyM1skdDhQf2vnFd3mTqGG2sDPRotc7R2M328eCAWEEvpSgeT7wy9NMvCPqio6F1SAbEQ67LfFfoPNHh8cM/sZ8V8=
X-Received: by 2002:a17:90b:1d92:b0:1ed:38d5:c45e with SMTP id
 pf18-20020a17090b1d9200b001ed38d5c45emr2564343pjb.167.1656491184663; Wed, 29
 Jun 2022 01:26:24 -0700 (PDT)
MIME-Version: 1.0
From:   Bharath SM <bharathsm.hsk@gmail.com>
Date:   Wed, 29 Jun 2022 13:56:10 +0530
Message-ID: <CAGypqWyKzYL+MKwsmStP=brsxYCE9MNq=2o-8QoywFX4oPSdTw@mail.gmail.com>
Subject: [PATCH] cifs: Add mount parameter to control deferred close timeout
To:     linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
        rohiths.msft@gmail.com, lsahlber@redhat.com
Cc:     Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000a2c67b05e291e8d4"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000a2c67b05e291e8d4
Content-Type: text/plain; charset="UTF-8"

Adding a new mount parameter to specifically control timeout for deferred close.

--000000000000a2c67b05e291e8d4
Content-Type: application/octet-stream; 
	name="0001-Add-dclosetimeo-mount-parameter-to-control-deferred-.patch"
Content-Disposition: attachment; 
	filename="0001-Add-dclosetimeo-mount-parameter-to-control-deferred-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l4zbtkmr0>
X-Attachment-Id: f_l4zbtkmr0

RnJvbSBiOTI4NDE3MzVlNDMyNDk1NTRhMTE0NGJjNjc3NGNhN2I1YzFmMjg1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCaGFyYXRoIFNNIDxiaGFyYXRoc21AbWljcm9zb2Z0LmNvbT4K
RGF0ZTogVHVlLCAyOCBKdW4gMjAyMiAyMTo0ODoxNCArMDAwMApTdWJqZWN0OiBbUEFUQ0hdIEFk
ZCBkY2xvc2V0aW1lbyBtb3VudCBwYXJhbWV0ZXIgdG8gY29udHJvbCBkZWZlcnJlZCBjbG9zZQog
dGltZW91dAoKU2lnbmVkLW9mZi1ieTogQmhhcmF0aCBTTSA8YmhhcmF0aHNtQG1pY3Jvc29mdC5j
b20+Ci0tLQogZnMvY2lmcy9jaWZzZ2xvYi5oICAgfCAxMSArKysrKysrKysrKwogZnMvY2lmcy9j
b25uZWN0LmMgICAgfCAgMyArKysKIGZzL2NpZnMvZmlsZS5jICAgICAgIHwgIDQgKystLQogZnMv
Y2lmcy9mc19jb250ZXh0LmMgfCAxMCArKysrKysrKysrCiBmcy9jaWZzL2ZzX2NvbnRleHQuaCB8
ICAyICsrCiA1IGZpbGVzIGNoYW5nZWQsIDI4IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzZ2xvYi5oIGIvZnMvY2lmcy9jaWZzZ2xvYi5oCmlu
ZGV4IGE2NDNjODRmZjFlOS4uMmUyMmZhZjViMjRkIDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNn
bG9iLmgKKysrIGIvZnMvY2lmcy9jaWZzZ2xvYi5oCkBAIC01Miw2ICs1MiwxNyBAQAogICovCiAj
ZGVmaW5lIENJRlNfTUFYX0FDVElNRU8gKDEgPDwgMzApCiAKKy8qCisgKiBkZWZhdWx0IGRlZmVy
cmVkIGNsb3NlIHRpbWVvdXQKKyAqLworI2RlZmluZSBDSUZTX0RFRl9EQ0xPU0VUSU1FTyAoMSAq
IEhaKQorCisvKgorICogbWF4IGRlZmVycmVkIGNsb3NlIHRpbWVvdXQgKGppZmZpZXMpIC0gMl4z
MAorICovCisjZGVmaW5lIENJRlNfTUFYX0RDTE9TRVRJTUVPICgxIDw8IDMwKQorCisKIC8qCiAg
KiBNYXggcGVyc2lzdGVudCBhbmQgcmVzaWxpZW50IGhhbmRsZSB0aW1lb3V0IChtaWxsaXNlY29u
ZHMpLgogICogV2luZG93cyBkdXJhYmxlIG1heCB3YXMgOTYwMDAwICgxNiBtaW51dGVzKQpkaWZm
IC0tZ2l0IGEvZnMvY2lmcy9jb25uZWN0LmMgYi9mcy9jaWZzL2Nvbm5lY3QuYwppbmRleCBmYTI5
YzlhYWUyNGIuLmI4MWY3ZGFhMzU5YyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jb25uZWN0LmMKKysr
IGIvZnMvY2lmcy9jb25uZWN0LmMKQEAgLTI2MjIsNiArMjYyMiw5IEBAIGNvbXBhcmVfbW91bnRf
b3B0aW9ucyhzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCBzdHJ1Y3QgY2lmc19tbnRfZGF0YSAqbW50
X2RhdGEpCiAJaWYgKG9sZC0+Y3R4LT5hY2Rpcm1heCAhPSBuZXctPmN0eC0+YWNkaXJtYXgpCiAJ
CXJldHVybiAwOwogCisJaWYgKG9sZC0+Y3R4LT5kY2xvc2V0aW1lbyAhPSBuZXctPmN0eC0+ZGNs
b3NldGltZW8pCisJCXJldHVybiAwOworCiAJcmV0dXJuIDE7CiB9CiAKZGlmZiAtLWdpdCBhL2Zz
L2NpZnMvZmlsZS5jIGIvZnMvY2lmcy9maWxlLmMKaW5kZXggZTY0Y2RhN2E3NjEwLi5hZDFiY2E2
ZWRhN2YgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvZmlsZS5jCisrKyBiL2ZzL2NpZnMvZmlsZS5jCkBA
IC05MDMsMTIgKzkwMywxMiBAQCBpbnQgY2lmc19jbG9zZShzdHJ1Y3QgaW5vZGUgKmlub2RlLCBz
dHJ1Y3QgZmlsZSAqZmlsZSkKIAkJCQkgKiBTbywgSW5jcmVhc2UgdGhlIHJlZiBjb3VudCB0byBh
dm9pZCB1c2UtYWZ0ZXItZnJlZS4KIAkJCQkgKi8KIAkJCQlpZiAoIW1vZF9kZWxheWVkX3dvcmso
ZGVmZXJyZWRjbG9zZV93cSwKLQkJCQkJCSZjZmlsZS0+ZGVmZXJyZWQsIGNpZnNfc2ItPmN0eC0+
YWNyZWdtYXgpKQorCQkJCQkJJmNmaWxlLT5kZWZlcnJlZCwgY2lmc19zYi0+Y3R4LT5kY2xvc2V0
aW1lbykpCiAJCQkJCWNpZnNGaWxlSW5mb19nZXQoY2ZpbGUpOwogCQkJfSBlbHNlIHsKIAkJCQkv
KiBEZWZlcnJlZCBjbG9zZSBmb3IgZmlsZXMgKi8KIAkJCQlxdWV1ZV9kZWxheWVkX3dvcmsoZGVm
ZXJyZWRjbG9zZV93cSwKLQkJCQkJCSZjZmlsZS0+ZGVmZXJyZWQsIGNpZnNfc2ItPmN0eC0+YWNy
ZWdtYXgpOworCQkJCQkJJmNmaWxlLT5kZWZlcnJlZCwgY2lmc19zYi0+Y3R4LT5kY2xvc2V0aW1l
byk7CiAJCQkJY2ZpbGUtPmRlZmVycmVkX2Nsb3NlX3NjaGVkdWxlZCA9IHRydWU7CiAJCQkJc3Bp
bl91bmxvY2soJmNpbm9kZS0+ZGVmZXJyZWRfbG9jayk7CiAJCQkJcmV0dXJuIDA7CmRpZmYgLS1n
aXQgYS9mcy9jaWZzL2ZzX2NvbnRleHQuYyBiL2ZzL2NpZnMvZnNfY29udGV4dC5jCmluZGV4IDhk
YzBkOTIzZWY2YS4uNWJiNjUzODgwOGNiIDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZzX2NvbnRleHQu
YworKysgYi9mcy9jaWZzL2ZzX2NvbnRleHQuYwpAQCAtMTQ3LDYgKzE0Nyw3IEBAIGNvbnN0IHN0
cnVjdCBmc19wYXJhbWV0ZXJfc3BlYyBzbWIzX2ZzX3BhcmFtZXRlcnNbXSA9IHsKIAlmc3BhcmFt
X3UzMigiYWN0aW1lbyIsIE9wdF9hY3RpbWVvKSwKIAlmc3BhcmFtX3UzMigiYWNkaXJtYXgiLCBP
cHRfYWNkaXJtYXgpLAogCWZzcGFyYW1fdTMyKCJhY3JlZ21heCIsIE9wdF9hY3JlZ21heCksCisJ
ZnNwYXJhbV91MzIoImRjbG9zZXRpbWVvIiwgT3B0X2RjbG9zZXRpbWVvKSwKIAlmc3BhcmFtX3Uz
MigiZWNob19pbnRlcnZhbCIsIE9wdF9lY2hvX2ludGVydmFsKSwKIAlmc3BhcmFtX3UzMigibWF4
X2NyZWRpdHMiLCBPcHRfbWF4X2NyZWRpdHMpLAogCWZzcGFyYW1fdTMyKCJoYW5kbGV0aW1lb3V0
IiwgT3B0X2hhbmRsZXRpbWVvdXQpLApAQCAtMTA0OCw2ICsxMDQ5LDEzIEBAIHN0YXRpYyBpbnQg
c21iM19mc19jb250ZXh0X3BhcnNlX3BhcmFtKHN0cnVjdCBmc19jb250ZXh0ICpmYywKIAkJY3R4
LT53c2l6ZSA9IHJlc3VsdC51aW50XzMyOwogCQljdHgtPmdvdF93c2l6ZSA9IHRydWU7CiAJCWJy
ZWFrOworCWNhc2UgT3B0X2RjbG9zZXRpbWVvOgorCQljdHgtPmRjbG9zZXRpbWVvID0gSFogKiBy
ZXN1bHQudWludF8zMjsKKwkJaWYgKGN0eC0+ZGNsb3NldGltZW8gPiBDSUZTX01BWF9EQ0xPU0VU
SU1FTykgeworCQkJY2lmc19lcnJvcmYoZmMsICJkY2xvc2V0aW1lIHRvbyBsYXJnZVxuIik7CisJ
CQlnb3RvIGNpZnNfcGFyc2VfbW91bnRfZXJyOworCQl9CisJCWJyZWFrOwogCWNhc2UgT3B0X2Fj
cmVnbWF4OgogCQljdHgtPmFjcmVnbWF4ID0gSFogKiByZXN1bHQudWludF8zMjsKIAkJaWYgKGN0
eC0+YWNyZWdtYXggPiBDSUZTX01BWF9BQ1RJTUVPKSB7CkBAIC0xNTIyLDYgKzE1MzAsOCBAQCBp
bnQgc21iM19pbml0X2ZzX2NvbnRleHQoc3RydWN0IGZzX2NvbnRleHQgKmZjKQogCWN0eC0+YWNy
ZWdtYXggPSBDSUZTX0RFRl9BQ1RJTUVPOwogCWN0eC0+YWNkaXJtYXggPSBDSUZTX0RFRl9BQ1RJ
TUVPOwogCisJY3R4LT5kY2xvc2V0aW1lbyA9IENJRlNfREVGX0RDTE9TRVRJTUVPOworCiAJLyog
TW9zdCBjbGllbnRzIHNldCB0aW1lb3V0IHRvIDAsIGFsbG93cyBzZXJ2ZXIgdG8gdXNlIGl0cyBk
ZWZhdWx0ICovCiAJY3R4LT5oYW5kbGVfdGltZW91dCA9IDA7IC8qIFNlZSBNUy1TTUIyIHNwZWMg
c2VjdGlvbiAyLjIuMTQuMi4xMiAqLwogCmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZzX2NvbnRleHQu
aCBiL2ZzL2NpZnMvZnNfY29udGV4dC5oCmluZGV4IDVmMDkzY2I3ZTliOS4uZDFkOTlkY2VlMWY5
IDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZzX2NvbnRleHQuaAorKysgYi9mcy9jaWZzL2ZzX2NvbnRl
eHQuaApAQCAtMTI1LDYgKzEyNSw3IEBAIGVudW0gY2lmc19wYXJhbSB7CiAJT3B0X2FjdGltZW8s
CiAJT3B0X2FjZGlybWF4LAogCU9wdF9hY3JlZ21heCwKKwlPcHRfZGNsb3NldGltZW8sCiAJT3B0
X2VjaG9faW50ZXJ2YWwsCiAJT3B0X21heF9jcmVkaXRzLAogCU9wdF9zbmFwc2hvdCwKQEAgLTI0
Nyw2ICsyNDgsNyBAQCBzdHJ1Y3Qgc21iM19mc19jb250ZXh0IHsKIAkvKiBhdHRyaWJ1dGUgY2Fj
aGUgdGltZW1vdXQgZm9yIGZpbGVzIGFuZCBkaXJlY3RvcmllcyBpbiBqaWZmaWVzICovCiAJdW5z
aWduZWQgbG9uZyBhY3JlZ21heDsKIAl1bnNpZ25lZCBsb25nIGFjZGlybWF4OworCXVuc2lnbmVk
IGxvbmcgZGNsb3NldGltZW87CiAJc3RydWN0IHNtYl92ZXJzaW9uX29wZXJhdGlvbnMgKm9wczsK
IAlzdHJ1Y3Qgc21iX3ZlcnNpb25fdmFsdWVzICp2YWxzOwogCWNoYXIgKnByZXBhdGg7Ci0tIAoy
LjM0LjEKCg==
--000000000000a2c67b05e291e8d4--
