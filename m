Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9EC9C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 24 May 2022 04:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbiEXE0h (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 May 2022 00:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233345AbiEXE0e (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 May 2022 00:26:34 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44BF28718
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 21:26:32 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id a127so17072253vsa.3
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 21:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=gMSQckYi3NWQ5WeN+NAuXUq698DApRYLUXkzQmqihjU=;
        b=LcFdPn230xg33IVeX79AmoL2frq4R+Wb+RvjHJwLHkfADTTJBqf1S+yu82CBO1DFh+
         PwkHOEjzxB/Cky7A1rL+n1A8lXpcF1yLPJsKCzfikmBjPKlT066moid2NEUD3zm/OjMI
         yQs1E/Y+vjogoSKse/IjK63FqijKUX6u98AE/h6nk1aKYzXHBV9m1B8r9MXNgzQAjKBv
         LP+lphh1vLG8hzrURkR5K8akXGpPlOO4xq4eXUhicEZSWvFOSm+iZPJzsxsFKdhbWMub
         BhzwI4ggqM2PBx9bUGlEnP+QZDgszK8HDlF39XiF9VWkPg16OiEKfGao75SbfLWD+hmg
         lMhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=gMSQckYi3NWQ5WeN+NAuXUq698DApRYLUXkzQmqihjU=;
        b=Dg/0GrrlWAd6bATyuPupV+NbIvNT3ECu4+b5t5102WjcQSJjwqAkKV5OsTnv0Ddqow
         omnFY5EJjWodZg4BhnzD2CdY48IfUKxWkwSdP7WE0SW9t8d5dgAqUbDBn/yplTpRUeBX
         QoTTcOZ+Jf/CbdQUEHD5At8VUElrimjr8OeswV9hl3kNu4L6x0vzRt5bmjMyiuphZ9+/
         VUk0kRNXdyL1M9I5C68Lv8lXL2/X4pBPHwvPtu+rcp8k2zr+asQJwP5gA0zeoooT0Z0y
         Mnb0UtOKci11Tc+aQ59IWokofyM1jbzPW8Kc8NI76j+lUPMd2WMmyiR+4k9XbHQbadQw
         ++Qw==
X-Gm-Message-State: AOAM531uKE9KZ+IX2IQ4O/6O8um9M/al2Stu6pD9KWR+UntanWeF5mdp
        CD0SyitGKCzL6qeq/EMQ19SzxoiJYWnOf78/ZGhrvU/SM2o=
X-Google-Smtp-Source: ABdhPJxFey5j/rl0KWH7YL9Jw8WMsGbl5uAAJdgJvUrjT5FeKpxp0XiKt7AJwNULjyVLaLitEk9xx3YDwdBWCFvY/aY=
X-Received: by 2002:a05:6102:3711:b0:337:9531:f74f with SMTP id
 s17-20020a056102371100b003379531f74fmr6374794vst.60.1653366391524; Mon, 23
 May 2022 21:26:31 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 23 May 2022 23:26:20 -0500
Message-ID: <CAH2r5msfVHD7jBSC2Pz5E3V8BUXU4FQKJCqXLpXFpp27GO2PTw@mail.gmail.com>
Subject: [SMB3] add mount option "nosparse"
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000073672c05dfba5c99"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000073672c05dfba5c99
Content-Type: text/plain; charset="UTF-8"

To reduce risk of applications breaking that mount to servers
with only partial sparse file support, add optional mount parm
 "nosparse" which disables setting files sparse (and thus
 will return EOPNOTSUPP on certain fallocate operations).


-- 
Thanks,

Steve

--00000000000073672c05dfba5c99
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-mount-parm-nosparse.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-mount-parm-nosparse.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l3jnnh6t0>
X-Attachment-Id: f_l3jnnh6t0

RnJvbSA4ZjA4NDJiZWU3YzcwYjEzNjc0ODZjNzlmNDk1ZGYzOGQyYzgxMTFjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjMgTWF5IDIwMjIgMjM6MTc6MTIgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhZGQgbW91bnQgcGFybSBub3NwYXJzZQoKVG8gcmVkdWNlIHJpc2sgb2YgYXBwbGljYXRp
b25zIGJyZWFraW5nIHRoYXQgbW91bnQgdG8gc2VydmVycwp3aXRoIG9ubHkgcGFydGlhbCBzcGFy
c2UgZmlsZSBzdXBwb3J0LCBhZGQgb3B0aW9uYWwgbW91bnQgcGFybQoibm9zcGFyc2UiIHdoaWNo
IGRpc2FibGVzIHNldHRpbmcgZmlsZXMgc3BhcnNlIChhbmQgdGh1cwp3aWxsIHJldHVybiBFT1BO
T1RTVVBQIG9uIGNlcnRhaW4gZmFsbG9jYXRlIG9wZXJhdGlvbnMpLgoKU2lnbmVkLW9mZi1ieTog
U3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY2lmc19k
ZWJ1Zy5jIHwgMyArKy0KIGZzL2NpZnMvY2lmc2ZzLmMgICAgIHwgMiArKwogZnMvY2lmcy9jb25u
ZWN0LmMgICAgfCAxICsKIGZzL2NpZnMvZnNfY29udGV4dC5jIHwgNCArKysrCiBmcy9jaWZzL2Zz
X2NvbnRleHQuaCB8IDIgKysKIDUgZmlsZXMgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc19kZWJ1Zy5jIGIvZnMvY2lmcy9j
aWZzX2RlYnVnLmMKaW5kZXggOWQzMzQ4MTZlYWMwLi4wZWZmYzRjOTUwNzcgMTAwNjQ0Ci0tLSBh
L2ZzL2NpZnMvY2lmc19kZWJ1Zy5jCisrKyBiL2ZzL2NpZnMvY2lmc19kZWJ1Zy5jCkBAIC0xMTYs
NyArMTE2LDggQEAgc3RhdGljIHZvaWQgY2lmc19kZWJ1Z190Y29uKHN0cnVjdCBzZXFfZmlsZSAq
bSwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbikKIAkJdGNvbi0+c2VzLT5zZXJ2ZXItPm9wcy0+ZHVt
cF9zaGFyZV9jYXBzKG0sIHRjb24pOwogCWlmICh0Y29uLT51c2Vfd2l0bmVzcykKIAkJc2VxX3B1
dHMobSwgIiBXaXRuZXNzIik7Ci0KKwlpZiAodGNvbi0+YnJva2VuX3NwYXJzZV9zdXApCisJCXNl
cV9wdXRzKG0sICIgbm9zcGFyc2UiKTsKIAlpZiAodGNvbi0+bmVlZF9yZWNvbm5lY3QpCiAJCXNl
cV9wdXRzKG0sICJcdERJU0NPTk5FQ1RFRCAiKTsKIAlzZXFfcHV0YyhtLCAnXG4nKTsKZGlmZiAt
LWdpdCBhL2ZzL2NpZnMvY2lmc2ZzLmMgYi9mcy9jaWZzL2NpZnNmcy5jCmluZGV4IDJiMWExYzAy
OWM3NS4uZjUzOWEzOWQ0N2Y1IDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNmcy5jCisrKyBiL2Zz
L2NpZnMvY2lmc2ZzLmMKQEAgLTU4Miw2ICs1ODIsOCBAQCBjaWZzX3Nob3dfb3B0aW9ucyhzdHJ1
Y3Qgc2VxX2ZpbGUgKnMsIHN0cnVjdCBkZW50cnkgKnJvb3QpCiAJCXNlcV9wdXRzKHMsICIsbm9j
YXNlIik7CiAJaWYgKHRjb24tPm5vZGVsZXRlKQogCQlzZXFfcHV0cyhzLCAiLG5vZGVsZXRlIik7
CisJaWYgKGNpZnNfc2ItPmN0eC0+bm9fc3BhcnNlKQorCQlzZXFfcHV0cyhzLCAiLG5vc3BhcnNl
Iik7CiAJaWYgKHRjb24tPmxvY2FsX2xlYXNlKQogCQlzZXFfcHV0cyhzLCAiLGxvY2FsbGVhc2Ui
KTsKIAlpZiAodGNvbi0+cmV0cnkpCmRpZmYgLS1naXQgYS9mcy9jaWZzL2Nvbm5lY3QuYyBiL2Zz
L2NpZnMvY29ubmVjdC5jCmluZGV4IDBiMDg2OTNkMWFmOC4uMWZkOGQ2YTk3ZDdjIDEwMDY0NAot
LS0gYS9mcy9jaWZzL2Nvbm5lY3QuYworKysgYi9mcy9jaWZzL2Nvbm5lY3QuYwpAQCAtMjUwOSw2
ICsyNTA5LDcgQEAgY2lmc19nZXRfdGNvbihzdHJ1Y3QgY2lmc19zZXMgKnNlcywgc3RydWN0IHNt
YjNfZnNfY29udGV4dCAqY3R4KQogCSAqLwogCXRjb24tPnJldHJ5ID0gY3R4LT5yZXRyeTsKIAl0
Y29uLT5ub2Nhc2UgPSBjdHgtPm5vY2FzZTsKKwl0Y29uLT5icm9rZW5fc3BhcnNlX3N1cCA9IGN0
eC0+bm9fc3BhcnNlOwogCWlmIChzZXMtPnNlcnZlci0+Y2FwYWJpbGl0aWVzICYgU01CMl9HTE9C
QUxfQ0FQX0RJUkVDVE9SWV9MRUFTSU5HKQogCQl0Y29uLT5ub2hhbmRsZWNhY2hlID0gY3R4LT5u
b2hhbmRsZWNhY2hlOwogCWVsc2UKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvZnNfY29udGV4dC5jIGIv
ZnMvY2lmcy9mc19jb250ZXh0LmMKaW5kZXggYTkyZTllZWM1MjFmLi5jYTFkNjk1N2EwOTkgMTAw
NjQ0Ci0tLSBhL2ZzL2NpZnMvZnNfY29udGV4dC5jCisrKyBiL2ZzL2NpZnMvZnNfY29udGV4dC5j
CkBAIC0xMTksNiArMTE5LDcgQEAgY29uc3Qgc3RydWN0IGZzX3BhcmFtZXRlcl9zcGVjIHNtYjNf
ZnNfcGFyYW1ldGVyc1tdID0gewogCWZzcGFyYW1fZmxhZ19ubygicGVyc2lzdGVudGhhbmRsZXMi
LCBPcHRfcGVyc2lzdGVudCksCiAJZnNwYXJhbV9mbGFnX25vKCJyZXNpbGllbnRoYW5kbGVzIiwg
T3B0X3Jlc2lsaWVudCksCiAJZnNwYXJhbV9mbGFnX25vKCJ0Y3Bub2RlbGF5IiwgT3B0X3RjcF9u
b2RlbGF5KSwKKwlmc3BhcmFtX2ZsYWcoIm5vc3BhcnNlIiwgT3B0X25vc3BhcnNlKSwKIAlmc3Bh
cmFtX2ZsYWcoImRvbWFpbmF1dG8iLCBPcHRfZG9tYWluYXV0byksCiAJZnNwYXJhbV9mbGFnKCJy
ZG1hIiwgT3B0X3JkbWEpLAogCWZzcGFyYW1fZmxhZygibW9kZXNpZCIsIE9wdF9tb2Rlc2lkKSwK
QEAgLTk0Myw2ICs5NDQsOSBAQCBzdGF0aWMgaW50IHNtYjNfZnNfY29udGV4dF9wYXJzZV9wYXJh
bShzdHJ1Y3QgZnNfY29udGV4dCAqZmMsCiAJY2FzZSBPcHRfbm9sZWFzZToKIAkJY3R4LT5ub19s
ZWFzZSA9IDE7CiAJCWJyZWFrOworCWNhc2UgT3B0X25vc3BhcnNlOgorCQljdHgtPm5vX3NwYXJz
ZSA9IDE7CisJCWJyZWFrOwogCWNhc2UgT3B0X25vZGVsZXRlOgogCQljdHgtPm5vZGVsZXRlID0g
MTsKIAkJYnJlYWs7CmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZzX2NvbnRleHQuaCBiL2ZzL2NpZnMv
ZnNfY29udGV4dC5oCmluZGV4IGU1NDA5MGQ5ZWYzNi4uNjU3NmJiMTJmNWYxIDEwMDY0NAotLS0g
YS9mcy9jaWZzL2ZzX2NvbnRleHQuaAorKysgYi9mcy9jaWZzL2ZzX2NvbnRleHQuaApAQCAtNjIs
NiArNjIsNyBAQCBlbnVtIGNpZnNfcGFyYW0gewogCU9wdF9ub2Jsb2Nrc2VuZCwKIAlPcHRfbm9h
dXRvdHVuZSwKIAlPcHRfbm9sZWFzZSwKKwlPcHRfbm9zcGFyc2UsCiAJT3B0X2hhcmQsCiAJT3B0
X3NvZnQsCiAJT3B0X3Blcm0sCkBAIC0yMjIsNiArMjIzLDcgQEAgc3RydWN0IHNtYjNfZnNfY29u
dGV4dCB7CiAJYm9vbCBub2F1dG90dW5lOjE7CiAJYm9vbCBub3N0cmljdHN5bmM6MTsgLyogZG8g
bm90IGZvcmNlIGV4cGVuc2l2ZSBTTUJmbHVzaCBvbiBldmVyeSBzeW5jICovCiAJYm9vbCBub19s
ZWFzZToxOyAgICAgLyogZGlzYWJsZSByZXF1ZXN0aW5nIGxlYXNlcyAqLworCWJvb2wgbm9fc3Bh
cnNlOjE7ICAgIC8qIGRvIG5vdCBhdHRlbXB0IHRvIHNldCBmaWxlcyBzcGFyc2UgKi8KIAlib29s
IGZzYzoxOwkvKiBlbmFibGUgZnNjYWNoZSAqLwogCWJvb2wgbWZzeW1saW5rczoxOyAvKiB1c2Ug
TWluc2hhbGwrRnJlbmNoIFN5bWxpbmtzICovCiAJYm9vbCBtdWx0aXVzZXI6MTsKLS0gCjIuMzQu
MQoK
--00000000000073672c05dfba5c99--
