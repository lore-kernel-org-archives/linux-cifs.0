Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=BAYES_05,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDFBBC4338F
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Aug 2021 17:45:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B676B60F58
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Aug 2021 17:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237866AbhHDRpT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Aug 2021 13:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237470AbhHDRpT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 Aug 2021 13:45:19 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659B7C0613D5
        for <linux-cifs@vger.kernel.org>; Wed,  4 Aug 2021 10:45:05 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id y7so3521347ljp.3
        for <linux-cifs@vger.kernel.org>; Wed, 04 Aug 2021 10:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lhwOS6p4VA/2AFxV4DFSwn/ugtZT/TgAGtve50VsoWY=;
        b=TFJ5zLqb5RMvuWlQ/CCgx6oyfDEjltbq82oIbYubhQ9E20+jQv/fp+7GovSt2Kl62k
         6oPJaBPvCy/C1Yq0RWF/XXuAKKJhU3etWsAqAa5Gw7H+YI09eftD6n/y/Um6CMFnrP4P
         5TCxJYhFJAK6Z95rpeHiwOXCPSL3Wm/BZ3VFhMee23yMajsvmYGhonTlpSQ5A2EpTHUn
         tjVF+50b3F1p6RfKZ8yyTm4ifRmKTjTx/xHfNRbf4D7SSj59j5chngsK84uhr2iYrGKt
         xIpIZjBS7gshVqZevMYyY8ucTrJJC8G7mvVkOhPRF1fnBtVR8ekXHYb2y/5HjlL9b29v
         7IxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lhwOS6p4VA/2AFxV4DFSwn/ugtZT/TgAGtve50VsoWY=;
        b=GL71v067imDpXBXdHl6a0hHzQjIIql6ZFv5r+RLneOc5Z+/1tBqCX+4wu2d7dxgB+N
         BgDZQbebZQE0Xz8T2ZtMN5mVxBz+Rbg53HbJzZcZx+T+kTKq15zUuebNm7DNisqqVeC8
         U4qNjR2TRi23IFRrO0Fj4nECMIYnmuvtpHnxm8JMvM/HEJRi6jNLJaLPm6ShQ1yZ7iMR
         pWd8G6U3IrLF2bh+dpmcUDkiL1/Rz7jvcFk5q+h8WVmh1IH0GTo1ScolpovcyicisYzB
         8xeBJJ+pqI7QB5M/slDKUjoVXucFrsJg4n3QGMF1hzzvfBy4wF4fdL1GHcT0sy5rcJqa
         a7/g==
X-Gm-Message-State: AOAM532QSzWx0KDg0h/piKZeDx8hV2bNB/5Sov2RzYgLeaFNf+y5A7TJ
        MH8XwxZwVC458EgnBNM21eQY8fRFPq5ppYGwZ89VCetKuaA=
X-Google-Smtp-Source: ABdhPJxAA6sETvxBH2czWe2ItpyDlc1SZWsiTpqKtN1OBDKq3i4t1N1bQT05culCfeI2aRZMJUi/zYuFOOAnzo4+RQI=
X-Received: by 2002:a2e:901a:: with SMTP id h26mr380850ljg.218.1628099103538;
 Wed, 04 Aug 2021 10:45:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms3XvZSLbAOb7irrZpS0aFsDUW59qRDdN19H8ZaR_YX+w@mail.gmail.com>
In-Reply-To: <CAH2r5ms3XvZSLbAOb7irrZpS0aFsDUW59qRDdN19H8ZaR_YX+w@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 4 Aug 2021 12:44:52 -0500
Message-ID: <CAH2r5mtpvw=U5unu=7qzmE5DY5gCo4Z0iq_RB0jPpfxs0=Vwhw@mail.gmail.com>
Subject: Fwd: [PATCH][CIFS] Handle race conditions during rename
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     rohiths msft <rohiths.msft@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000b9e04805c8bf5c1e"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000b9e04805c8bf5c1e
Content-Type: text/plain; charset="UTF-8"

Lightly updated version of Rohith's newer version of his deferred
close fix (fixed minor checkpatch issue and added cc:stable #5.13

-- 
Thanks,

Steve

--000000000000b9e04805c8bf5c1e
Content-Type: application/x-patch; 
	name="0001-cifs-Handle-race-conditions-during-rename.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Handle-race-conditions-during-rename.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_krxs3kop0>
X-Attachment-Id: f_krxs3kop0

RnJvbSAyMzQzMTViMDNhOWE0ZWMwNTVmZmExODM3ODAzZWRiZjJjMjhjN2E5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNAbWljcm9zb2Z0
LmNvbT4KRGF0ZTogVGh1LCAyOSBKdWwgMjAyMSAwNzo0NToyOSArMDAwMApTdWJqZWN0OiBbUEFU
Q0hdIGNpZnM6IEhhbmRsZSByYWNlIGNvbmRpdGlvbnMgZHVyaW5nIHJlbmFtZQoKV2hlbiByZW5h
bWUgaXMgZXhlY3V0ZWQgb24gZGlyZWN0b3J5IHdoaWNoIGhhcyBmaWxlcyBmb3Igd2hpY2gKY2xv
c2UgaXMgZGVmZXJyZWQsIHRoZW4gcmVuYW1lIHdpbGwgZmFpbCB3aXRoIEVBQ0NFUy4KClRoaXMg
cGF0Y2ggd2lsbCB0cnkgdG8gY2xvc2UgYWxsIGRlZmVycmVkIGZpbGVzIHdoZW4gRUFDQ0VTIGlz
IHJlY2VpdmVkCmFuZCByZXRyeSByZW5hbWUgb24gYSBkaXJlY3RvcnkuCgpTaWduZWQtb2ZmLWJ5
OiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNAbWljcm9zb2Z0LmNvbT4KQ2M6IHN0YWJsZUB2
Z2VyLmtlcm5lbC5vcmcgIyA1LjEzClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVu
Y2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2lub2RlLmMgfCAxOSArKysrKysrKysrKysr
KysrKy0tCiBmcy9jaWZzL21pc2MuYyAgfCAxMyArKysrKysrKy0tLS0tCiAyIGZpbGVzIGNoYW5n
ZWQsIDI1IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lm
cy9pbm9kZS5jIGIvZnMvY2lmcy9pbm9kZS5jCmluZGV4IGI5NmIyNTNlNzYzNS4uMWNkMDJhNTJm
ZDBmIDEwMDY0NAotLS0gYS9mcy9jaWZzL2lub2RlLmMKKysrIGIvZnMvY2lmcy9pbm9kZS5jCkBA
IC0xNjI1LDcgKzE2MjUsNyBAQCBpbnQgY2lmc191bmxpbmsoc3RydWN0IGlub2RlICpkaXIsIHN0
cnVjdCBkZW50cnkgKmRlbnRyeSkKIAkJZ290byB1bmxpbmtfb3V0OwogCX0KIAotCWNpZnNfY2xv
c2VfYWxsX2RlZmVycmVkX2ZpbGVzKHRjb24pOworCWNpZnNfY2xvc2VfZGVmZXJyZWRfZmlsZShD
SUZTX0koZF9pbm9kZShkZW50cnkpKSk7CiAJaWYgKGNhcF91bml4KHRjb24tPnNlcykgJiYgKENJ
RlNfVU5JWF9QT1NJWF9QQVRIX09QU19DQVAgJgogCQkJCWxlNjRfdG9fY3B1KHRjb24tPmZzVW5p
eEluZm8uQ2FwYWJpbGl0eSkpKSB7CiAJCXJjID0gQ0lGU1BPU0lYRGVsRmlsZSh4aWQsIHRjb24s
IGZ1bGxfcGF0aCwKQEAgLTIwODQsNiArMjA4NCw3IEBAIGNpZnNfcmVuYW1lMihzdHJ1Y3QgdXNl
cl9uYW1lc3BhY2UgKm1udF91c2VybnMsIHN0cnVjdCBpbm9kZSAqc291cmNlX2RpciwKIAlGSUxF
X1VOSVhfQkFTSUNfSU5GTyAqaW5mb19idWZfdGFyZ2V0OwogCXVuc2lnbmVkIGludCB4aWQ7CiAJ
aW50IHJjLCB0bXByYzsKKwlpbnQgcmV0cnlfY291bnQgPSAwOwogCiAJaWYgKGZsYWdzICYgflJF
TkFNRV9OT1JFUExBQ0UpCiAJCXJldHVybiAtRUlOVkFMOwpAQCAtMjExMywxMCArMjExNCwyNCBA
QCBjaWZzX3JlbmFtZTIoc3RydWN0IHVzZXJfbmFtZXNwYWNlICptbnRfdXNlcm5zLCBzdHJ1Y3Qg
aW5vZGUgKnNvdXJjZV9kaXIsCiAJCWdvdG8gY2lmc19yZW5hbWVfZXhpdDsKIAl9CiAKLQljaWZz
X2Nsb3NlX2FsbF9kZWZlcnJlZF9maWxlcyh0Y29uKTsKKwljaWZzX2Nsb3NlX2RlZmVycmVkX2Zp
bGUoQ0lGU19JKGRfaW5vZGUoc291cmNlX2RlbnRyeSkpKTsKKwlpZiAoQ0lGU19JKGRfaW5vZGUo
dGFyZ2V0X2RlbnRyeSkpKQorCQljaWZzX2Nsb3NlX2RlZmVycmVkX2ZpbGUoQ0lGU19JKGRfaW5v
ZGUodGFyZ2V0X2RlbnRyeSkpKTsKKwogCXJjID0gY2lmc19kb19yZW5hbWUoeGlkLCBzb3VyY2Vf
ZGVudHJ5LCBmcm9tX25hbWUsIHRhcmdldF9kZW50cnksCiAJCQkgICAgdG9fbmFtZSk7CiAKKwlp
ZiAocmMgPT0gLUVBQ0NFUykgeworCQl3aGlsZSAocmV0cnlfY291bnQgPCAzKSB7CisJCQljaWZz
X2Nsb3NlX2FsbF9kZWZlcnJlZF9maWxlcyh0Y29uKTsKKwkJCXJjID0gY2lmc19kb19yZW5hbWUo
eGlkLCBzb3VyY2VfZGVudHJ5LCBmcm9tX25hbWUsIHRhcmdldF9kZW50cnksCisJCQkJCSAgICB0
b19uYW1lKTsKKwkJCWlmIChyYyAhPSAtRUFDQ0VTKQorCQkJCWJyZWFrOworCQkJcmV0cnlfY291
bnQrKzsKKwkJfQorCX0KKwogCS8qCiAJICogTm8tcmVwbGFjZSBpcyB0aGUgbmF0dXJhbCBiZWhh
dmlvciBmb3IgQ0lGUywgc28gc2tpcCB1bmxpbmsgaGFja3MuCiAJICovCmRpZmYgLS1naXQgYS9m
cy9jaWZzL21pc2MuYyBiL2ZzL2NpZnMvbWlzYy5jCmluZGV4IDg0NGFiZWIyYjQ4Zi4uNmZhNmM2
NzRjYWRiIDEwMDY0NAotLS0gYS9mcy9jaWZzL21pc2MuYworKysgYi9mcy9jaWZzL21pc2MuYwpA
QCAtNzIzLDEzICs3MjMsMTYgQEAgdm9pZAogY2lmc19jbG9zZV9kZWZlcnJlZF9maWxlKHN0cnVj
dCBjaWZzSW5vZGVJbmZvICpjaWZzX2lub2RlKQogewogCXN0cnVjdCBjaWZzRmlsZUluZm8gKmNm
aWxlID0gTlVMTDsKLQlzdHJ1Y3QgY2lmc19kZWZlcnJlZF9jbG9zZSAqZGNsb3NlOwogCiAJbGlz
dF9mb3JfZWFjaF9lbnRyeShjZmlsZSwgJmNpZnNfaW5vZGUtPm9wZW5GaWxlTGlzdCwgZmxpc3Qp
IHsKLQkJc3Bpbl9sb2NrKCZjaWZzX2lub2RlLT5kZWZlcnJlZF9sb2NrKTsKLQkJaWYgKGNpZnNf
aXNfZGVmZXJyZWRfY2xvc2UoY2ZpbGUsICZkY2xvc2UpKQotCQkJbW9kX2RlbGF5ZWRfd29yayhk
ZWZlcnJlZGNsb3NlX3dxLCAmY2ZpbGUtPmRlZmVycmVkLCAwKTsKLQkJc3Bpbl91bmxvY2soJmNp
ZnNfaW5vZGUtPmRlZmVycmVkX2xvY2spOworCQlpZiAoZGVsYXllZF93b3JrX3BlbmRpbmcoJmNm
aWxlLT5kZWZlcnJlZCkpIHsKKwkJCS8qCisJCQkgKiBJZiB0aGVyZSBpcyBubyBwZW5kaW5nIHdv
cmssIG1vZF9kZWxheWVkX3dvcmsgcXVldWVzIG5ldyB3b3JrLgorCQkJICogU28sIEluY3JlYXNl
IHRoZSByZWYgY291bnQgdG8gYXZvaWQgdXNlLWFmdGVyLWZyZWUuCisJCQkgKi8KKwkJCWlmICgh
bW9kX2RlbGF5ZWRfd29yayhkZWZlcnJlZGNsb3NlX3dxLCAmY2ZpbGUtPmRlZmVycmVkLCAwKSkK
KwkJCQljaWZzRmlsZUluZm9fZ2V0KGNmaWxlKTsKKwkJfQogCX0KIH0KIAotLSAKMi4zMC4yCgo=
--000000000000b9e04805c8bf5c1e--
