Return-Path: <SRS0=RdgD=7Z=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 003B8C433DF
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Jun 2020 15:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C63CA2074B
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Jun 2020 15:40:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RN6TQ4Nh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgFLPkc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Jun 2020 11:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgFLPkc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 Jun 2020 11:40:32 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04248C03E96F
        for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2020 08:40:31 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id d13so5096392ybk.8
        for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2020 08:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=kvGnRG67ud9orNAO/VmmKAXUX0xoZoI8pwsEZnbIR34=;
        b=RN6TQ4NhyO+4PNIm0tkQUpe3tpy4IkHULbdmppLUukINOezy+/BRg6jEVB+piRUVyE
         KhBIS/ghyJeF7wgFUdf3S2Knq82v5m3b86qsrRp7zpdBmZpPlLUwvwFWt/cw3sSrEuE7
         +XzMMcKz9j3Lr9+OBEJyqUC13l0AG676hY3ZG3BB/cinRxrhFsY4TOJa6BZ51MCRGPsa
         wTkkoLSkTEHMXHjCqk2wy+oivGONXTKN4LC3dA2ULSZyIgPUGUGwBe5zD6nypBujvhZy
         QWinBKT1H7qoZ8apSYfuFZozDmDPtzBPTP+K8QIAOB2WJ4rVoWGxca3Bv2aHQI71GDHT
         jFHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=kvGnRG67ud9orNAO/VmmKAXUX0xoZoI8pwsEZnbIR34=;
        b=TD5mZuAIVQaYUXuEEMw5t2nD8Db1piINMBoYTJ5L6OooodPQO3Tmz55/xZUv3eXi7y
         0bnz9JWcWGluJ0d9h2BsgKH5BZj4+fYnWCMq1xAaOJeSyZbX6xkOQ7p82BF2QYCDZLCK
         mbxplwpe5EtCMQ4NkKJTaH8V0HMyFpKVXO/4+bcSV6A3gR/WondjZ4pydEcF2t8J04Nh
         4RLi4ZCJQ/P8fviLps/V6UZFgE9KDVvartkQajJl2PxTZtu6Vg9NQsf5KaF3ozK/wlfj
         xBrM0lNHNG4Kn8IJg7wvrAiB3iteLPcdVnjMjIQcSM0rQr2YPbKQ5vSYajxhK2Y30hgI
         CPmA==
X-Gm-Message-State: AOAM531dl2m8pA42DKi9gMiWJEccwskNoPm9vn+CIkIyPA9Yl6NgIRuY
        hxGsQJxW+5L4KPTjZpvDRxcbXgELiROC6PCuCUZx5lrlxpw=
X-Google-Smtp-Source: ABdhPJyDnHhN+n0Xddrv1RzZv8zzsEHKs8TdFvC15aBeHeIQzPbKIfFshrmt9BpoNSulvKDDvELRZ562Lzh4R3nea5Y=
X-Received: by 2002:a25:ec0d:: with SMTP id j13mr21483402ybh.364.1591976430334;
 Fri, 12 Jun 2020 08:40:30 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 12 Jun 2020 10:40:19 -0500
Message-ID: <CAH2r5mupjgsgSbswUTGkB-62c+VrZvH+f3i8hubKT6n3fyvuNA@mail.gmail.com>
Subject: [PATCH] cifs: fix chown and chgrp when idsfromsid mount option enabled
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000009f125305a7e4e5a1"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000009f125305a7e4e5a1
Content-Type: text/plain; charset="UTF-8"

idsfromsid was ignored in chown and chgrp causing it to fail
when upcalls were not configured for lookup.  idsfromsid allows
mapping users when setting user or group ownership using
"special SID" (reserved for this).  Add support for chmod and chgrp
when idsfromsid mount option is enabled.

-- 
Thanks,

Steve

--0000000000009f125305a7e4e5a1
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-chown-and-chgrp-when-idsfromsid-mount-optio.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-chown-and-chgrp-when-idsfromsid-mount-optio.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kbcdnktn0>
X-Attachment-Id: f_kbcdnktn0

RnJvbSA0ZDRjNjA5MWFjNTIzMzkwZDlmZTFjMTU5N2FhODc5ZDk4ZWIzYTczIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMTIgSnVuIDIwMjAgMTA6MzY6MzcgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggY2hvd24gYW5kIGNoZ3JwIHdoZW4gaWRzZnJvbXNpZCBtb3VudCBvcHRpb24KIGVu
YWJsZWQKCmlkc2Zyb21zaWQgd2FzIGlnbm9yZWQgaW4gY2hvd24gYW5kIGNoZ3JwIGNhdXNpbmcg
aXQgdG8gZmFpbAp3aGVuIHVwY2FsbHMgd2VyZSBub3QgY29uZmlndXJlZCBmb3IgbG9va3VwLiAg
aWRzZnJvbXNpZCBhbGxvd3MKbWFwcGluZyB1c2VycyB3aGVuIHNldHRpbmcgdXNlciBvciBncm91
cCBvd25lcnNoaXAgdXNpbmcKInNwZWNpYWwgU0lEIiAocmVzZXJ2ZWQgZm9yIHRoaXMpLiAgQWRk
IHN1cHBvcnQgZm9yIGNobW9kIGFuZCBjaGdycAp3aGVuIGlkc2Zyb21zaWQgbW91bnQgb3B0aW9u
IGlzIGVuYWJsZWQuCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jv
c29mdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzYWNsLmMgfCA1NyArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDQyIGluc2VydGlv
bnMoKyksIDE1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2FjbC5jIGIv
ZnMvY2lmcy9jaWZzYWNsLmMKaW5kZXggNjNhYWEzNjNlZDE0Li42MDI1ZDdmYzdiYmYgMTAwNjQ0
Ci0tLSBhL2ZzL2NpZnMvY2lmc2FjbC5jCisrKyBiL2ZzL2NpZnMvY2lmc2FjbC5jCkBAIC0xMDAw
LDcgKzEwMDAsNyBAQCBzdGF0aWMgaW50IHBhcnNlX3NlY19kZXNjKHN0cnVjdCBjaWZzX3NiX2lu
Zm8gKmNpZnNfc2IsCiAvKiBDb252ZXJ0IHBlcm1pc3Npb24gYml0cyBmcm9tIG1vZGUgdG8gZXF1
aXZhbGVudCBDSUZTIEFDTCAqLwogc3RhdGljIGludCBidWlsZF9zZWNfZGVzYyhzdHJ1Y3QgY2lm
c19udHNkICpwbnRzZCwgc3RydWN0IGNpZnNfbnRzZCAqcG5udHNkLAogCV9fdTMyIHNlY2Rlc2Ns
ZW4sIF9fdTY0IG5tb2RlLCBrdWlkX3QgdWlkLCBrZ2lkX3QgZ2lkLAotCWJvb2wgbW9kZV9mcm9t
X3NpZCwgaW50ICphY2xmbGFnKQorCWJvb2wgbW9kZV9mcm9tX3NpZCwgYm9vbCBpZF9mcm9tX3Np
ZCwgaW50ICphY2xmbGFnKQogewogCWludCByYyA9IDA7CiAJX191MzIgZGFjbG9mZnNldDsKQEAg
LTEwNDEsMTIgKzEwNDEsMjMgQEAgc3RhdGljIGludCBidWlsZF9zZWNfZGVzYyhzdHJ1Y3QgY2lm
c19udHNkICpwbnRzZCwgc3RydWN0IGNpZnNfbnRzZCAqcG5udHNkLAogCQkJaWYgKCFub3duZXJf
c2lkX3B0cikKIAkJCQlyZXR1cm4gLUVOT01FTTsKIAkJCWlkID0gZnJvbV9rdWlkKCZpbml0X3Vz
ZXJfbnMsIHVpZCk7Ci0JCQlyYyA9IGlkX3RvX3NpZChpZCwgU0lET1dORVIsIG5vd25lcl9zaWRf
cHRyKTsKLQkJCWlmIChyYykgewotCQkJCWNpZnNfZGJnKEZZSSwgIiVzOiBNYXBwaW5nIGVycm9y
ICVkIGZvciBvd25lciBpZCAlZFxuIiwKLQkJCQkJIF9fZnVuY19fLCByYywgaWQpOwotCQkJCWtm
cmVlKG5vd25lcl9zaWRfcHRyKTsKLQkJCQlyZXR1cm4gcmM7CisJCQlpZiAoaWRfZnJvbV9zaWQp
IHsKKwkJCQlzdHJ1Y3Qgb3duZXJfc2lkICpvc2lkID0gKHN0cnVjdCBvd25lcl9zaWQgKilub3du
ZXJfc2lkX3B0cjsKKwkJCQkvKiBQb3B1bGF0ZSB0aGUgdXNlciBvd25lcnNoaXAgZmllbGRzIFMt
MS01LTg4LTEgKi8KKwkJCQlvc2lkLT5SZXZpc2lvbiA9IDE7CisJCQkJb3NpZC0+TnVtQXV0aCA9
IDM7CisJCQkJb3NpZC0+QXV0aG9yaXR5WzVdID0gNTsKKwkJCQlvc2lkLT5TdWJBdXRob3JpdGll
c1swXSA9IGNwdV90b19sZTMyKDg4KTsKKwkJCQlvc2lkLT5TdWJBdXRob3JpdGllc1sxXSA9IGNw
dV90b19sZTMyKDEpOworCQkJCW9zaWQtPlN1YkF1dGhvcml0aWVzWzJdID0gY3B1X3RvX2xlMzIo
aWQpOworCQkJfSBlbHNlIHsgLyogbG9va3VwIHNpZCB3aXRoIHVwY2FsbCAqLworCQkJCXJjID0g
aWRfdG9fc2lkKGlkLCBTSURPV05FUiwgbm93bmVyX3NpZF9wdHIpOworCQkJCWlmIChyYykgewor
CQkJCQljaWZzX2RiZyhGWUksICIlczogTWFwcGluZyBlcnJvciAlZCBmb3Igb3duZXIgaWQgJWRc
biIsCisJCQkJCQkgX19mdW5jX18sIHJjLCBpZCk7CisJCQkJCWtmcmVlKG5vd25lcl9zaWRfcHRy
KTsKKwkJCQkJcmV0dXJuIHJjOworCQkJCX0KIAkJCX0KIAkJCWNpZnNfY29weV9zaWQob3duZXJf
c2lkX3B0ciwgbm93bmVyX3NpZF9wdHIpOwogCQkJa2ZyZWUobm93bmVyX3NpZF9wdHIpOwpAQCAt
MTA2MSwxMiArMTA3MiwyMyBAQCBzdGF0aWMgaW50IGJ1aWxkX3NlY19kZXNjKHN0cnVjdCBjaWZz
X250c2QgKnBudHNkLCBzdHJ1Y3QgY2lmc19udHNkICpwbm50c2QsCiAJCQlpZiAoIW5ncm91cF9z
aWRfcHRyKQogCQkJCXJldHVybiAtRU5PTUVNOwogCQkJaWQgPSBmcm9tX2tnaWQoJmluaXRfdXNl
cl9ucywgZ2lkKTsKLQkJCXJjID0gaWRfdG9fc2lkKGlkLCBTSURHUk9VUCwgbmdyb3VwX3NpZF9w
dHIpOwotCQkJaWYgKHJjKSB7Ci0JCQkJY2lmc19kYmcoRllJLCAiJXM6IE1hcHBpbmcgZXJyb3Ig
JWQgZm9yIGdyb3VwIGlkICVkXG4iLAotCQkJCQkgX19mdW5jX18sIHJjLCBpZCk7Ci0JCQkJa2Zy
ZWUobmdyb3VwX3NpZF9wdHIpOwotCQkJCXJldHVybiByYzsKKwkJCWlmIChpZF9mcm9tX3NpZCkg
eworCQkJCXN0cnVjdCBvd25lcl9zaWQgKmdzaWQgPSAoc3RydWN0IG93bmVyX3NpZCAqKW5ncm91
cF9zaWRfcHRyOworCQkJCS8qIFBvcHVsYXRlIHRoZSBncm91cCBvd25lcnNoaXAgZmllbGRzIFMt
MS01LTg4LTIgKi8KKwkJCQlnc2lkLT5SZXZpc2lvbiA9IDE7CisJCQkJZ3NpZC0+TnVtQXV0aCA9
IDM7CisJCQkJZ3NpZC0+QXV0aG9yaXR5WzVdID0gNTsKKwkJCQlnc2lkLT5TdWJBdXRob3JpdGll
c1swXSA9IGNwdV90b19sZTMyKDg4KTsKKwkJCQlnc2lkLT5TdWJBdXRob3JpdGllc1sxXSA9IGNw
dV90b19sZTMyKDIpOworCQkJCWdzaWQtPlN1YkF1dGhvcml0aWVzWzJdID0gY3B1X3RvX2xlMzIo
aWQpOworCQkJfSBlbHNlIHsgLyogbG9va3VwIHNpZCB3aXRoIHVwY2FsbCAqLworCQkJCXJjID0g
aWRfdG9fc2lkKGlkLCBTSURHUk9VUCwgbmdyb3VwX3NpZF9wdHIpOworCQkJCWlmIChyYykgewor
CQkJCQljaWZzX2RiZyhGWUksICIlczogTWFwcGluZyBlcnJvciAlZCBmb3IgZ3JvdXAgaWQgJWRc
biIsCisJCQkJCQkgX19mdW5jX18sIHJjLCBpZCk7CisJCQkJCWtmcmVlKG5ncm91cF9zaWRfcHRy
KTsKKwkJCQkJcmV0dXJuIHJjOworCQkJCX0KIAkJCX0KIAkJCWNpZnNfY29weV9zaWQoZ3JvdXBf
c2lkX3B0ciwgbmdyb3VwX3NpZF9wdHIpOwogCQkJa2ZyZWUobmdyb3VwX3NpZF9wdHIpOwpAQCAt
MTI2OSw3ICsxMjkxLDcgQEAgaWRfbW9kZV90b19jaWZzX2FjbChzdHJ1Y3QgaW5vZGUgKmlub2Rl
LCBjb25zdCBjaGFyICpwYXRoLCBfX3U2NCBubW9kZSwKIAlzdHJ1Y3QgY2lmc19zYl9pbmZvICpj
aWZzX3NiID0gQ0lGU19TQihpbm9kZS0+aV9zYik7CiAJc3RydWN0IHRjb25fbGluayAqdGxpbmsg
PSBjaWZzX3NiX3RsaW5rKGNpZnNfc2IpOwogCXN0cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRpb25z
ICpvcHM7Ci0JYm9vbCBtb2RlX2Zyb21fc2lkOworCWJvb2wgbW9kZV9mcm9tX3NpZCwgaWRfZnJv
bV9zaWQ7CiAKIAlpZiAoSVNfRVJSKHRsaW5rKSkKIAkJcmV0dXJuIFBUUl9FUlIodGxpbmspOwpA
QCAtMTMxMiw4ICsxMzM0LDEzIEBAIGlkX21vZGVfdG9fY2lmc19hY2woc3RydWN0IGlub2RlICpp
bm9kZSwgY29uc3QgY2hhciAqcGF0aCwgX191NjQgbm1vZGUsCiAJZWxzZQogCQltb2RlX2Zyb21f
c2lkID0gZmFsc2U7CiAKKwlpZiAoY2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgJiBDSUZTX01PVU5U
X1VJRF9GUk9NX0FDTCkKKwkJaWRfZnJvbV9zaWQgPSB0cnVlOworCWVsc2UKKwkJaWRfZnJvbV9z
aWQgPSBmYWxzZTsKKwogCXJjID0gYnVpbGRfc2VjX2Rlc2MocG50c2QsIHBubnRzZCwgc2VjZGVz
Y2xlbiwgbm1vZGUsIHVpZCwgZ2lkLAotCQkJICAgIG1vZGVfZnJvbV9zaWQsICZhY2xmbGFnKTsK
KwkJCSAgICBtb2RlX2Zyb21fc2lkLCBpZF9mcm9tX3NpZCwgJmFjbGZsYWcpOwogCiAJY2lmc19k
YmcoTk9JU1ksICJidWlsZF9zZWNfZGVzYyByYzogJWRcbiIsIHJjKTsKIAotLSAKMi4yNS4xCgo=
--0000000000009f125305a7e4e5a1--
