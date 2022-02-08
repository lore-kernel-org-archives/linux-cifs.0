Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B36DC433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Feb 2022 05:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243927AbiBHFxo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 8 Feb 2022 00:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241191AbiBHFxn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 8 Feb 2022 00:53:43 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4C2C0401DC
        for <linux-cifs@vger.kernel.org>; Mon,  7 Feb 2022 21:53:42 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id p21so13845700ljn.13
        for <linux-cifs@vger.kernel.org>; Mon, 07 Feb 2022 21:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=m7ynzmsN4ZpTDQPTTswhdy0Os/Znf1fxe5v/EAt/yKs=;
        b=auhXX2ebeLms1m0p8BX1BVCP1cPP96C9x9A0Dlkw3hOHiX90rMw82Qiuf3y1KDOkeK
         +ypMZQpneeJpuy8OJMwbOQrY3UScmBT+/xf+A6aaER7FwnqaehdDCObBG9L1Bbc3tte3
         WMrpOXkao47dk7gFqEj6i8FVrHsjcBhGMcfLivDPQqUA+bv+yVkjR3ho3VoseIsM2DAU
         CLaSxX7ZwsFB+gJ0K3mLBwzwc+XIQlx9Yd1qrIhPC/re+ftt1Ex3+9ZBgJrwNEgsSsQN
         Iu1cgaAtknPJ25eIDQIvrIUN7F3W9nT4k/V54TW65zRCNoyLVp0N3CQxEyzi204rJSO/
         PQcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=m7ynzmsN4ZpTDQPTTswhdy0Os/Znf1fxe5v/EAt/yKs=;
        b=0Ugw3JtxR/x9SdM8047VPDaxnt39+GBcL5aIwnJ3hRzbPg8oyq+ugXZlWNTfKwBGVw
         jgkCSy8UtObuPCKHjrLhaVL11zh28G7Mt9Ry0xAXn/p1gXllkX8E0/M79yK1IjGjizZO
         SJu/KooyYgSAfLVpVYuQAnxIMVmgQeZHwm7aYymEtzoIPLNNOJCseNyRfL7hdxF839Ca
         PrW9oFx0yl+5N1PQCo8TtrPV/uHwHpvlVGWtHEWFRu/rHtJOLmE6W1zW2ofqEwC9/p1W
         77qP2DazTWwSj9QA3iM18OLafbffsxEwTgmkP3/nrBQPgKBlLAUk8galWehrrT9fyU/I
         8nZA==
X-Gm-Message-State: AOAM5307v4PeY0p5XaPpV7MziG+phMlaTdi9Odt/XKoaXeXsgNf2z89c
        Z8CmD0gnnIK9fpHt+kqrFXxPh9TLKn+h9MabXNk=
X-Google-Smtp-Source: ABdhPJwY3W4Ixafjmb2uzxeRYaeQYXMCOozPqNAkq5r1CtpFO8YeTMzcBiC6ApSeLRJmPb9cU56wmVwMwTbmoMawBQU=
X-Received: by 2002:a2e:900a:: with SMTP id h10mr1786456ljg.356.1644299621146;
 Mon, 07 Feb 2022 21:53:41 -0800 (PST)
MIME-Version: 1.0
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Tue, 8 Feb 2022 11:23:30 +0530
Message-ID: <CACdtm0Z4crPr868DRGCYNd=euVXzm+T+rPHT4PdqK66TV7iioQ@mail.gmail.com>
Subject: [PATCH] [CIFS]: Add clamp_length support
To:     Steve French <smfrench@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000d2b58505d77b563a"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000d2b58505d77b563a
Content-Type: text/plain; charset="UTF-8"

Hi All,

Added clamp length handler to further slice the read requests based on
available credits.

This patch needs to be applied on top of Dave howells 7-patch
series(netfs integration for cifs).

@David Howells As the above 7-patch series is dependent on netfs lib
changes which are not merged yet. Please let us know the timelines for
mege process.

Regards,
Rohith

--000000000000d2b58505d77b563a
Content-Type: application/octet-stream; 
	name="CIFS-Add-clamp_length-support.patch"
Content-Disposition: attachment; 
	filename="CIFS-Add-clamp_length-support.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kzdparsf0>
X-Attachment-Id: f_kzdparsf0

RnJvbSBlMGVlZTVmZjMyOTI3Mzk4NWU0MWUzYWU5ZmViNmMyN2RjZmRiNDE5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNAbWljcm9zb2Z0
LmNvbT4KRGF0ZTogVHVlLCA4IEZlYiAyMDIyIDA1OjM4OjI5ICswMDAwClN1YmplY3Q6IFtQQVRD
SF0gW0NJRlNdOiBBZGQgY2xhbXBfbGVuZ3RoIHN1cHBvcnQKCkFkZGVkIGNsYW1wIGxlbmd0aCBo
YW5kbGVyIHRvIHNsaWNlIHRoZSByZWFkIHJlcXVlc3RzIGZ1cnRoZXIgYmFzZWQgb24gYXZhaWxh
YmxlIGNyZWRpdHMuCgpTaWduZWQtb2ZmLWJ5OiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNA
bWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2ZpbGUuYyAgICAgICAgfCA0MCArKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tCiBmcy9jaWZzL3NtYjJvcHMuYyAgICAgfCAg
MSArCiBpbmNsdWRlL2xpbnV4L25ldGZzLmggfCAgMSArCiAzIGZpbGVzIGNoYW5nZWQsIDM0IGlu
c2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9maWxlLmMg
Yi9mcy9jaWZzL2ZpbGUuYwppbmRleCAzNjU1OWRlMDJlMzcuLjhmNDk2MTk2MGJlYiAxMDA2NDQK
LS0tIGEvZnMvY2lmcy9maWxlLmMKKysrIGIvZnMvY2lmcy9maWxlLmMKQEAgLTM0NTksMTEgKzM0
NTksMTAgQEAgc3RhdGljIHZvaWQgY2lmc19yZXFfaXNzdWVfb3Aoc3RydWN0IG5ldGZzX3JlYWRf
c3VicmVxdWVzdCAqc3VicmVxKQogCXN0cnVjdCBjaWZzX3JlYWRkYXRhICpyZGF0YTsKIAlzdHJ1
Y3QgY2lmc0ZpbGVJbmZvICpvcGVuX2ZpbGUgPSBycmVxLT5uZXRmc19wcml2OwogCXN0cnVjdCBj
aWZzX3NiX2luZm8gKmNpZnNfc2IgPSBDSUZTX1NCKHJyZXEtPmlub2RlLT5pX3NiKTsKLQlzdHJ1
Y3QgY2lmc19jcmVkaXRzIGNyZWRpdHNfb25fc3RhY2ssICpjcmVkaXRzID0gJmNyZWRpdHNfb25f
c3RhY2s7CisJc3RydWN0IGNpZnNfY3JlZGl0cyAqY3JlZGl0czsKIAl1bnNpZ25lZCBpbnQgeGlk
OwogCXBpZF90IHBpZDsKIAlpbnQgcmMgPSAwOwotCXVuc2lnbmVkIGludCByc2l6ZTsKIAogCXhp
ZCA9IGdldF94aWQoKTsKIApAQCAtMzQ3OCwxOCArMzQ3NywxOCBAQCBzdGF0aWMgdm9pZCBjaWZz
X3JlcV9pc3N1ZV9vcChzdHJ1Y3QgbmV0ZnNfcmVhZF9zdWJyZXF1ZXN0ICpzdWJyZXEpCiAJCSBf
X2Z1bmNfXywgcnJlcS0+ZGVidWdfaWQsIHN1YnJlcS0+ZGVidWdfaW5kZXgsIHJyZXEtPm1hcHBp
bmcsCiAJCSBzdWJyZXEtPnRyYW5zZmVycmVkLCBzdWJyZXEtPmxlbik7CiAKKwljcmVkaXRzID0g
c3VicmVxLT5zdWJyZXFfcHJpdjsKKwogCWlmIChvcGVuX2ZpbGUtPmludmFsaWRIYW5kbGUpIHsK
IAkJZG8gewogCQkJcmMgPSBjaWZzX3Jlb3Blbl9maWxlKG9wZW5fZmlsZSwgdHJ1ZSk7CiAJCX0g
d2hpbGUgKHJjID09IC1FQUdBSU4pOwotCQlpZiAocmMpCisJCWlmIChyYykgeworCQkJYWRkX2Ny
ZWRpdHNfYW5kX3dha2VfaWYoc2VydmVyLCBjcmVkaXRzLCAwKTsKIAkJCWdvdG8gb3V0OworCQl9
CiAJfQogCi0JcmMgPSBzZXJ2ZXItPm9wcy0+d2FpdF9tdHVfY3JlZGl0cyhzZXJ2ZXIsIGNpZnNf
c2ItPmN0eC0+cnNpemUsICZyc2l6ZSwgY3JlZGl0cyk7Ci0JaWYgKHJjKQotCQlnb3RvIG91dDsK
LQogCXJkYXRhID0gY2lmc19yZWFkZGF0YV9hbGxvYyhOVUxMKTsKIAlpZiAoIXJkYXRhKSB7CiAJ
CWFkZF9jcmVkaXRzX2FuZF93YWtlX2lmKHNlcnZlciwgY3JlZGl0cywgMCk7CkBAIC0zNTA0LDcg
KzM1MDMsNyBAQCBzdGF0aWMgdm9pZCBjaWZzX3JlcV9pc3N1ZV9vcChzdHJ1Y3QgbmV0ZnNfcmVh
ZF9zdWJyZXF1ZXN0ICpzdWJyZXEpCiAJcmRhdGEtPm9mZnNldAk9IHN1YnJlcS0+c3RhcnQgKyBz
dWJyZXEtPnRyYW5zZmVycmVkOwogCXJkYXRhLT5ieXRlcwk9IHN1YnJlcS0+bGVuICAgLSBzdWJy
ZXEtPnRyYW5zZmVycmVkOwogCXJkYXRhLT5waWQJPSBwaWQ7Ci0JcmRhdGEtPmNyZWRpdHMJPSBj
cmVkaXRzX29uX3N0YWNrOworCXJkYXRhLT5jcmVkaXRzCT0gKmNyZWRpdHM7CiAJcmRhdGEtPml0
ZXIJPSBzdWJyZXEtPml0ZXI7CiAKIAlyYyA9IGFkanVzdF9jcmVkaXRzKHNlcnZlciwgJnJkYXRh
LT5jcmVkaXRzLCByZGF0YS0+Ynl0ZXMpOwpAQCAtMzUyNiw2ICszNTI1LDcgQEAgc3RhdGljIHZv
aWQgY2lmc19yZXFfaXNzdWVfb3Aoc3RydWN0IG5ldGZzX3JlYWRfc3VicmVxdWVzdCAqc3VicmVx
KQogCiBvdXQ6CiAJZnJlZV94aWQoeGlkKTsKKwlrZnJlZShjcmVkaXRzKTsKIAlpZiAocmMpCiAJ
CW5ldGZzX3N1YnJlcV90ZXJtaW5hdGVkKHN1YnJlcSwgcmMsIGZhbHNlKTsKIH0KQEAgLTM1NjYs
NiArMzU2NiwyOSBAQCBzdGF0aWMgdm9pZCBjaWZzX2V4cGFuZF9yZWFkYWhlYWQoc3RydWN0IG5l
dGZzX3JlYWRfcmVxdWVzdCAqcnJlcSkKIAkJcnJlcS0+bGVuID0gaV9zaXplIC0gcnJlcS0+c3Rh
cnQ7CiB9CiAKK3N0YXRpYyBib29sIGNpZnNfY2xhbXBfbGVuZ3RoKHN0cnVjdCBuZXRmc19yZWFk
X3N1YnJlcXVlc3QgKnN1YnJlcSkKK3sKKwlzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiID0g
Q0lGU19TQihzdWJyZXEtPnJyZXEtPmlub2RlLT5pX3NiKTsKKwlzdHJ1Y3QgVENQX1NlcnZlcl9J
bmZvICpzZXJ2ZXI7CisJc3RydWN0IGNpZnNGaWxlSW5mbyAqb3Blbl9maWxlID0gc3VicmVxLT5y
cmVxLT5uZXRmc19wcml2OworCXN0cnVjdCBjaWZzX2NyZWRpdHMgKmNyZWRpdHM7CisJdW5zaWdu
ZWQgaW50IHJzaXplOworCWludCByYzsKKworCWNyZWRpdHMgPSBrbWFsbG9jKHNpemVvZihzdHJ1
Y3QgY2lmc19jcmVkaXRzKSwgR0ZQX0tFUk5FTCk7CisJc2VydmVyID0gY2lmc19waWNrX2NoYW5u
ZWwodGxpbmtfdGNvbihvcGVuX2ZpbGUtPnRsaW5rKS0+c2VzKTsKKworCXJjID0gc2VydmVyLT5v
cHMtPndhaXRfbXR1X2NyZWRpdHMoc2VydmVyLCBjaWZzX3NiLT5jdHgtPnJzaXplLAorICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgJnJzaXplLCBjcmVk
aXRzKTsKKwlpZiAocmMpCisJCXJldHVybiBmYWxzZTsKKworCXN1YnJlcS0+bGVuID0gcnNpemU7
CisJc3VicmVxLT5zdWJyZXFfcHJpdiA9IGNyZWRpdHM7CisJcmV0dXJuIHRydWU7Cit9CisKKwog
c3RhdGljIHZvaWQgY2lmc19ycmVxX2RvbmUoc3RydWN0IG5ldGZzX3JlYWRfcmVxdWVzdCAqcnJl
cSkKIHsKIAlzdHJ1Y3QgaW5vZGUgKmlub2RlID0gcnJlcS0+aW5vZGU7CkBAIC0zNTg2LDYgKzM2
MDksNyBAQCBjb25zdCBzdHJ1Y3QgbmV0ZnNfcmVxdWVzdF9vcHMgY2lmc19yZXFfb3BzID0gewog
CS5pbml0X3JyZXEJCT0gY2lmc19pbml0X3JyZXEsCiAJLmV4cGFuZF9yZWFkYWhlYWQJPSBjaWZz
X2V4cGFuZF9yZWFkYWhlYWQsCiAJLmlzc3VlX29wCQk9IGNpZnNfcmVxX2lzc3VlX29wLAorCS5j
bGFtcF9sZW5ndGggICAgICAgICAgID0gY2lmc19jbGFtcF9sZW5ndGgsCiAJLmRvbmUJCQk9IGNp
ZnNfcnJlcV9kb25lLAogCS5jbGVhbnVwCQk9IGNpZnNfcmVxX2NsZWFudXAsCiB9OwpkaWZmIC0t
Z2l0IGEvZnMvY2lmcy9zbWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMuYwppbmRleCBlMTY0OWFj
MTk0ZGIuLjVmYWY0NTY3Mjg5MSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyb3BzLmMKKysrIGIv
ZnMvY2lmcy9zbWIyb3BzLmMKQEAgLTQ5MTcsNiArNDkxNyw3IEBAIGhhbmRsZV9yZWFkX2RhdGEo
c3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLCBzdHJ1Y3QgbWlkX3FfZW50cnkgKm1pZCwK
IAkJbGVuZ3RoID0gY29weV90b19pdGVyKGJ1ZiArIGRhdGFfb2Zmc2V0LCBkYXRhX2xlbiwgJnJk
YXRhLT5pdGVyKTsKIAkJaWYgKGxlbmd0aCA8IDApCiAJCQlyZXR1cm4gbGVuZ3RoOworCQlyZGF0
YS0+Z290X2J5dGVzID0gZGF0YV9sZW47CiAJfSBlbHNlIHsKIAkJLyogcmVhZCByZXNwb25zZSBw
YXlsb2FkIGNhbm5vdCBiZSBpbiBib3RoIGJ1ZiBhbmQgcGFnZXMgKi8KIAkJV0FSTl9PTkNFKDEs
ICJidWYgY2FuIG5vdCBjb250YWluIG9ubHkgYSBwYXJ0IG9mIHJlYWQgZGF0YSIpOwpkaWZmIC0t
Z2l0IGEvaW5jbHVkZS9saW51eC9uZXRmcy5oIGIvaW5jbHVkZS9saW51eC9uZXRmcy5oCmluZGV4
IGIwNWI3YTdkOTBlNi4uZThmYjFiMzY5NGM2IDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L25l
dGZzLmgKKysrIGIvaW5jbHVkZS9saW51eC9uZXRmcy5oCkBAIC0xNzAsNiArMTcwLDcgQEAgc3Ry
dWN0IG5ldGZzX3JlYWRfc3VicmVxdWVzdCB7CiAjZGVmaW5lIE5FVEZTX1NSRVFfU0hPUlRfUkVB
RAkJMgkvKiBTZXQgaWYgdGhlcmUgd2FzIGEgc2hvcnQgcmVhZCBmcm9tIHRoZSBjYWNoZSAqLwog
I2RlZmluZSBORVRGU19TUkVRX1NFRUtfREFUQV9SRUFECTMJLyogU2V0IGlmIC0+cmVhZCgpIHNo
b3VsZCBTRUVLX0RBVEEgZmlyc3QgKi8KICNkZWZpbmUgTkVURlNfU1JFUV9OT19QUk9HUkVTUwkJ
NAkvKiBTZXQgaWYgd2UgZGlkbid0IG1hbmFnZSB0byByZWFkIGFueSBkYXRhICovCisJdm9pZCAg
ICAgICAgICAgICAgICAgICAgKnN1YnJlcV9wcml2OwogfTsKIAogZW51bSBuZXRmc19yZWFkX29y
aWdpbiB7Ci0tIAoyLjMyLjAKCg==
--000000000000d2b58505d77b563a--
