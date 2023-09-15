Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EEB1EEB596
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Sep 2023 06:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbjIOGmL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Sep 2023 02:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbjIOGmL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 15 Sep 2023 02:42:11 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCD826B8
        for <linux-cifs@vger.kernel.org>; Thu, 14 Sep 2023 23:42:05 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-5007abb15e9so3067197e87.0
        for <linux-cifs@vger.kernel.org>; Thu, 14 Sep 2023 23:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694760123; x=1695364923; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z55gAln4ybDAt+nBHpUdJ9m58txpxwncd07tIu3d7tU=;
        b=Rt5lcfAPMlZ8VJV2qNhV4CpWM2f1zKtguax++Zch41GrjApfr4SSAjHAlaOdG3E1Vb
         dMb38h8FiIvxloV9tR1B9lC19mfkQrSmvhEdRAUZjknHc9v/PfW4iEuzUe2cSdqN3Aru
         VsUqWUCuV9r2duzlERBKY92eSDwRJexTeXd8QEqEOpekb1xZwLBgtArN15Z+K1fOhFZT
         z6qGxlUmbiTDZinGSUMd/U7IZwSWhfElGrEG0mteUWlGtb6fD+CT6zb6gJm7bKTCeFGe
         5c6UmVKlaE0lUD2q2C19tJOqSHoJXX4xFjXus563hNiP5WoOsklvI2e5K9LHIsRrmCK9
         erMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694760123; x=1695364923;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z55gAln4ybDAt+nBHpUdJ9m58txpxwncd07tIu3d7tU=;
        b=B5dIh28Rnnp5OxJBbjK+9GmvaNBJZcYNAxUBEu4mMrzfW6KQKt3NDnYq8MoAzEOkVG
         acntaP7FD+TCowH0vqzzgMc3CtBdsIgPkt0kWSwzDHb2M/36/CrO0DLzpj6bgnERaPZ3
         jSvyWuphPB6WKYOHORf9FEz2vzi51PJyZkBTqSWvB7YxzFegTROG1lQ6LLSi9PnSDWp0
         oqZnRucKCu/HrCzLa4JUGbLFUWJNJbxnVt6MQikeqir36yf4fRcuzDL6X7kmpX5gkx2l
         X31shXRvvNwif9FQd50WbAK/zrXKI5j2PlkuAmqXkVLD47iZq3hd3F/gLH2OOW6rvjf/
         l/Vw==
X-Gm-Message-State: AOJu0YwKqasfX4qCZlhoRQthKxZvVUW7eUIusnsQ6xHDMMCGOuHCEbsS
        0guwUpGGZIzDoYvNUZPIvD92vea5x+j708lHo1S8H1Nxy4s=
X-Google-Smtp-Source: AGHT+IFSq8NDBax2JW4NRiEwmvUJpcHJM3Gt8HEe6ueA0PotKxTaYQ4jptoAFXf4UwL1cmwf/hN+TtSFP5ThRvt+4eA=
X-Received: by 2002:a05:6512:3b9d:b0:500:807a:f1a4 with SMTP id
 g29-20020a0565123b9d00b00500807af1a4mr983275lfv.18.1694760123393; Thu, 14 Sep
 2023 23:42:03 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 15 Sep 2023 01:41:52 -0500
Message-ID: <CAH2r5msGJ60_tF4a2kMxJT6UejgKGDS6rKuJCARJENOdTq6VDw@mail.gmail.com>
Subject: [PATCH][SMB3 client] fix minor typos and repeated words
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000002349a006056017b9"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000002349a006056017b9
Content-Type: text/plain; charset="UTF-8"

    Minor cleanup pointed out by checkpatch (repeated words, missing blank
    lines) in smb2pdu.c and old header location referred to in transport.c

See attached.

-- 
Thanks,

Steve

--0000000000002349a006056017b9
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-some-minor-typos-and-repeated-words.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-some-minor-typos-and-repeated-words.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lmk8e9st0>
X-Attachment-Id: f_lmk8e9st0

RnJvbSAyYzc1NDI2YzFmZWE1OTFiYjMzOGJhMDcyMDY4ZjgzZDJmNmJlMDg4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMTUgU2VwIDIwMjMgMDE6Mzc6MzMgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggc29tZSBtaW5vciB0eXBvcyBhbmQgcmVwZWF0ZWQgd29yZHMKCk1pbm9yIGNsZWFu
dXAgcG9pbnRlZCBvdXQgYnkgY2hlY2twYXRjaCAocmVwZWF0ZWQgd29yZHMsIG1pc3NpbmcgYmxh
bmsKbGluZXMpIGluIHNtYjJwZHUuYyBhbmQgb2xkIGhlYWRlciBsb2NhdGlvbiByZWZlcnJlZCB0
byBpbiB0cmFuc3BvcnQuYwoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBt
aWNyb3NvZnQuY29tPgotLS0KIGZzL3NtYi9jbGllbnQvc21iMnBkdS5jICAgfCA2ICsrKystLQog
ZnMvc21iL2NsaWVudC90cmFuc3BvcnQuYyB8IDIgKy0KIDIgZmlsZXMgY2hhbmdlZCwgNSBpbnNl
cnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvc21i
MnBkdS5jIGIvZnMvc21iL2NsaWVudC9zbWIycGR1LmMKaW5kZXggMzQwMzE4OGUzMTAwLi40NGQ0
OTQzZTljNTYgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvc21iMnBkdS5jCisrKyBiL2ZzL3Nt
Yi9jbGllbnQvc21iMnBkdS5jCkBAIC04OSw2ICs4OSw3IEBAIHNtYjJfaGRyX2Fzc2VtYmxlKHN0
cnVjdCBzbWIyX2hkciAqc2hkciwgX19sZTE2IHNtYjJfY21kLAogCQkgIHN0cnVjdCBUQ1BfU2Vy
dmVyX0luZm8gKnNlcnZlcikKIHsKIAlzdHJ1Y3Qgc21iM19oZHJfcmVxICpzbWIzX2hkcjsKKwog
CXNoZHItPlByb3RvY29sSWQgPSBTTUIyX1BST1RPX05VTUJFUjsKIAlzaGRyLT5TdHJ1Y3R1cmVT
aXplID0gY3B1X3RvX2xlMTYoNjQpOwogCXNoZHItPkNvbW1hbmQgPSBzbWIyX2NtZDsKQEAgLTIy
MzksNyArMjI0MCw3IEBAIGNyZWF0ZV9kdXJhYmxlX3YyX2J1ZihzdHJ1Y3QgY2lmc19vcGVuX3Bh
cm1zICpvcGFybXMpCiAJICogKG1vc3Qgc2VydmVycyBkZWZhdWx0IHRvIDEyMCBzZWNvbmRzKSBh
bmQgbW9zdCBjbGllbnRzIGRlZmF1bHQgdG8gMC4KIAkgKiBUaGlzIGNhbiBiZSBvdmVycmlkZGVu
IGF0IG1vdW50ICgiaGFuZGxldGltZW91dD0iKSBpZiB0aGUgdXNlciB3YW50cwogCSAqIGEgZGlm
ZmVyZW50IHBlcnNpc3RlbnQgKG9yIHJlc2lsaWVudCkgaGFuZGxlIHRpbWVvdXQgZm9yIGFsbCBv
cGVucwotCSAqIG9wZW5zIG9uIGEgcGFydGljdWxhciBTTUIzIG1vdW50LgorCSAqIG9uIGEgcGFy
dGljdWxhciBTTUIzIG1vdW50LgogCSAqLwogCWJ1Zi0+ZGNvbnRleHQuVGltZW91dCA9IGNwdV90
b19sZTMyKG9wYXJtcy0+dGNvbi0+aGFuZGxlX3RpbWVvdXQpOwogCWJ1Zi0+ZGNvbnRleHQuRmxh
Z3MgPSBjcHVfdG9fbGUzMihTTUIyX0RIQU5ETEVfRkxBR19QRVJTSVNURU5UKTsKQEAgLTIzODQs
NyArMjM4NSw3IEBAIGFkZF90d2FycF9jb250ZXh0KHN0cnVjdCBrdmVjICppb3YsIHVuc2lnbmVk
IGludCAqbnVtX2lvdmVjLCBfX3U2NCB0aW1ld2FycCkKIAlyZXR1cm4gMDsKIH0KIAotLyogU2Vl
IFNlZSBodHRwOi8vdGVjaG5ldC5taWNyb3NvZnQuY29tL2VuLXVzL2xpYnJhcnkvaGg1MDkwMTco
dj13cy4xMCkuYXNweCAqLworLyogU2VlIGh0dHA6Ly90ZWNobmV0Lm1pY3Jvc29mdC5jb20vZW4t
dXMvbGlicmFyeS9oaDUwOTAxNyh2PXdzLjEwKS5hc3B4ICovCiBzdGF0aWMgdm9pZCBzZXR1cF9v
d25lcl9ncm91cF9zaWRzKGNoYXIgKmJ1ZikKIHsKIAlzdHJ1Y3Qgb3duZXJfZ3JvdXBfc2lkcyAq
c2lkcyA9IChzdHJ1Y3Qgb3duZXJfZ3JvdXBfc2lkcyAqKWJ1ZjsKQEAgLTMxMjksNiArMzEzMCw3
IEBAIHZvaWQKIFNNQjJfaW9jdGxfZnJlZShzdHJ1Y3Qgc21iX3Jxc3QgKnJxc3QpCiB7CiAJaW50
IGk7CisKIAlpZiAocnFzdCAmJiBycXN0LT5ycV9pb3YpIHsKIAkJY2lmc19zbWFsbF9idWZfcmVs
ZWFzZShycXN0LT5ycV9pb3ZbMF0uaW92X2Jhc2UpOyAvKiByZXF1ZXN0ICovCiAJCWZvciAoaSA9
IDE7IGkgPCBycXN0LT5ycV9udmVjOyBpKyspCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L3Ry
YW5zcG9ydC5jIGIvZnMvc21iL2NsaWVudC90cmFuc3BvcnQuYwppbmRleCAxYjVkOTc5NGVkNWIu
LmQ1MjA1N2E1MTFlZSAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC90cmFuc3BvcnQuYworKysg
Yi9mcy9zbWIvY2xpZW50L3RyYW5zcG9ydC5jCkBAIC0xOCw3ICsxOCw3IEBACiAjaW5jbHVkZSA8
bGludXgvYnZlYy5oPgogI2luY2x1ZGUgPGxpbnV4L2hpZ2htZW0uaD4KICNpbmNsdWRlIDxsaW51
eC91YWNjZXNzLmg+Ci0jaW5jbHVkZSA8YXNtL3Byb2Nlc3Nvci5oPgorI2luY2x1ZGUgPGxpbnV4
L3Byb2Nlc3Nvci5oPgogI2luY2x1ZGUgPGxpbnV4L21lbXBvb2wuaD4KICNpbmNsdWRlIDxsaW51
eC9zY2hlZC9zaWduYWwuaD4KICNpbmNsdWRlIDxsaW51eC90YXNrX2lvX2FjY291bnRpbmdfb3Bz
Lmg+Ci0tIAoyLjM5LjIKCg==
--0000000000002349a006056017b9--
