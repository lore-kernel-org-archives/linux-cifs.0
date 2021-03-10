Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22EBFC433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Mar 2021 17:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEE7A64FEE
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Mar 2021 17:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhCJRox (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Mar 2021 12:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhCJRoX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Mar 2021 12:44:23 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C89C061760
        for <linux-cifs@vger.kernel.org>; Wed, 10 Mar 2021 09:44:23 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id b10so18747619ybn.3
        for <linux-cifs@vger.kernel.org>; Wed, 10 Mar 2021 09:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=dJzbm8J6XpSUcZ3VEqc6PBXmIc3DwnE8uwUHrcZqps8=;
        b=cqIkqAKJ9TtHWVHqq1AOOSv1o3aAJ5ic9HlZgZOal2NqMSUblxIfTCzy8wRtftarxF
         0uQq1LeGi3D6jicJtyeb3mzx8l0lYQSfhS0T681QP7l8V+uBDPVQVrX+A9rkp9dYAAER
         Nok98P+79EyR2RL1B/X6BuS5/mrpSL2NMULeX9/cevn8ruzTECWydw/bvN4bfj9zX22e
         RI4R8IOE6kHQmTWO19vWEeASMORnQk/0iOsMkbDIjeiNukhBEGcume2Sxj3972dWIAlY
         YKaHwAly2pXA+HM2+h8FVH/yHvGlKHIm7f36gr0iS+lxXx+TcZ2l6/1ARGvZT0o6ZR6V
         Q9aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=dJzbm8J6XpSUcZ3VEqc6PBXmIc3DwnE8uwUHrcZqps8=;
        b=KFz21UQtr1Q2V3wI6TjxIUE5p85RGPOdYJhU/GkCPQd6z/dob6Z2AyWWj56EAUlcMT
         dkfZqf34h/xqHFJ5mKJtrlfBgCh34HUb+UcwaTZn4ZC1w7DQ9dXLEY83jYqhPZKnECJb
         C/ID1XEqWk/xSe0oSawMs96fkJWEx5xg6IXz/Vy7h65NO+4vNG88lWuUKBPThAQMc1F1
         SkAs8EcvXfILKadC7Bn1YjdRPtFRAqKzvyPPUX7b5MbNc+1ZklW71iidqEOvBjOxan8q
         Oc++RShYckQpIZx0B3gcbmILLrIDSLuC3BjJs5y0axm3Mdey4S0qIR8alDeL+p4xNdvt
         vFLw==
X-Gm-Message-State: AOAM530P3Ua7+6KxVNUqjH6cf1uXZ/V/+tmSBl6zq/oDOcGN0KmnaLe3
        /Yu/lLM7Gmsl9sPQsyvnkyIe/KL8aquvjPJiHNw=
X-Google-Smtp-Source: ABdhPJySGqlezZi21hl95QBx1T3JVuZpjXT3b/NsFAaRK82e1Oc/nWFcJ7PuVnRqiii7ZeBuQCGJ1nplfsh7/oR6v+0=
X-Received: by 2002:a25:7645:: with SMTP id r66mr5856144ybc.331.1615398262331;
 Wed, 10 Mar 2021 09:44:22 -0800 (PST)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 10 Mar 2021 23:14:11 +0530
Message-ID: <CANT5p=o0sV5XjLw1D-9L3qnWwy4DV7WF3QOrHJ8hc5gPVjNj5Q@mail.gmail.com>
Subject: [PATCH] cifs: update new ACE pointer after populate_new_aces.
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: multipart/mixed; boundary="00000000000098f04a05bd3237c8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000098f04a05bd3237c8
Content-Type: text/plain; charset="UTF-8"

Hi Steve,

Please consider this fix for the failing generic/317 test for cifsacl
and idsfromsid,modefromsid.
This is exposed on certain combinations of default ACEs on the file.

-- 
Regards,
Shyam

--00000000000098f04a05bd3237c8
Content-Type: application/octet-stream; 
	name="0001-cifs-update-new-ACE-pointer-after-populate_new_aces.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-update-new-ACE-pointer-after-populate_new_aces.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_km3qek0q0>
X-Attachment-Id: f_km3qek0q0

RnJvbSA4ZTIwNmNkMGRjZjI3ZTVjMTg4NWM1NmQzMThiMjA1Y2I2MmExOGNmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBXZWQsIDEwIE1hciAyMDIxIDEwOjIyOjI3ICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogdXBkYXRlIG5ldyBBQ0UgcG9pbnRlciBhZnRlciBwb3B1bGF0ZV9uZXdfYWNlcy4KCkFm
dGVyIHRoZSBmaXggZm9yIHJldGFpbmluZyBleHRlcm5hbGx5IHNldCBBQ0VzIHdpdGggY2lmc2Fj
bCBhbmQKbW9kZWZyb21zaWQsaWRzZnJvbXNpZCwgdGhlcmUgd2FzIGFuIGlzc3VlIGluIHBvcHVs
YXRpbmcgdGhlCmluaGVyaXRlZCBBQ0VzIGFmdGVyIHNldHRpbmcgdGhlIEFDRXMgaW50cm9kdWNl
ZCBieSB0aGVzZSB0d28gbW9kZXMuCkZpeGVkIHRoaXMgYnkgdXBkYXRpbmcgdGhlIEFDRSBwb2lu
dGVyIGFnYWluIGFmdGVyIHRoZSBjYWxsIHRvCnBvcHVsYXRlX25ld19hY2VzLgoKU2lnbmVkLW9m
Zi1ieTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZz
L2NpZnNhY2wuYyB8IDkgKysrKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCsp
LCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2FjbC5jIGIvZnMvY2lm
cy9jaWZzYWNsLmMKaW5kZXggOWQyOWViOTY2MGMyLi4yYmUyMmE1YzY5MGYgMTAwNjQ0Ci0tLSBh
L2ZzL2NpZnMvY2lmc2FjbC5jCisrKyBiL2ZzL2NpZnMvY2lmc2FjbC5jCkBAIC0xMTE4LDcgKzEx
MTgsNiBAQCBzdGF0aWMgaW50IHNldF9jaG1vZF9kYWNsKHN0cnVjdCBjaWZzX2FjbCAqcGRhY2ws
IHN0cnVjdCBjaWZzX2FjbCAqcG5kYWNsLAogCS8qIFJldGFpbiBvbGQgQUNFcyB3aGljaCB3ZSBj
YW4gcmV0YWluICovCiAJZm9yIChpID0gMDsgaSA8IHNyY19udW1fYWNlczsgKytpKSB7CiAJCXBu
dGFjZSA9IChzdHJ1Y3QgY2lmc19hY2UgKikgKGFjbF9iYXNlICsgc2l6ZSk7Ci0JCXBubnRhY2Ug
PSAoc3RydWN0IGNpZnNfYWNlICopIChuYWNsX2Jhc2UgKyBuc2l6ZSk7CiAKIAkJaWYgKCFuZXdf
YWNlc19zZXQgJiYgKHBudGFjZS0+ZmxhZ3MgJiBJTkhFUklURURfQUNFKSkgewogCQkJLyogUGxh
Y2UgdGhlIG5ldyBBQ0VzIGluIGJldHdlZW4gZXhpc3RpbmcgZXhwbGljaXQgYW5kIGluaGVyaXRl
ZCAqLwpAQCAtMTEzMSwxNCArMTEzMCwxOCBAQCBzdGF0aWMgaW50IHNldF9jaG1vZF9kYWNsKHN0
cnVjdCBjaWZzX2FjbCAqcGRhY2wsIHN0cnVjdCBjaWZzX2FjbCAqcG5kYWNsLAogCQl9CiAKIAkJ
LyogSWYgaXQncyBhbnkgb25lIG9mIHRoZSBBQ0Ugd2UncmUgcmVwbGFjaW5nLCBza2lwISAqLwot
CQlpZiAoKGNvbXBhcmVfc2lkcygmcG50YWNlLT5zaWQsICZzaWRfdW5peF9ORlNfbW9kZSkgPT0g
MCkgfHwKKwkJaWYgKCFtb2RlX2Zyb21fc2lkICYmCisJCQkJKChjb21wYXJlX3NpZHMoJnBudGFj
ZS0+c2lkLCAmc2lkX3VuaXhfTkZTX21vZGUpID09IDApIHx8CiAJCQkJKGNvbXBhcmVfc2lkcygm
cG50YWNlLT5zaWQsIHBvd25lcnNpZCkgPT0gMCkgfHwKIAkJCQkoY29tcGFyZV9zaWRzKCZwbnRh
Y2UtPnNpZCwgcGdycHNpZCkgPT0gMCkgfHwKIAkJCQkoY29tcGFyZV9zaWRzKCZwbnRhY2UtPnNp
ZCwgJnNpZF9ldmVyeW9uZSkgPT0gMCkgfHwKLQkJCQkoY29tcGFyZV9zaWRzKCZwbnRhY2UtPnNp
ZCwgJnNpZF9hdXRodXNlcnMpID09IDApKSB7CisJCQkJKGNvbXBhcmVfc2lkcygmcG50YWNlLT5z
aWQsICZzaWRfYXV0aHVzZXJzKSA9PSAwKSkpIHsKIAkJCWdvdG8gbmV4dF9hY2U7CiAJCX0KIAor
CQkvKiB1cGRhdGUgdGhlIHBvaW50ZXIgdG8gdGhlIG5leHQgQUNFIHRvIHBvcHVsYXRlKi8KKwkJ
cG5udGFjZSA9IChzdHJ1Y3QgY2lmc19hY2UgKikgKG5hY2xfYmFzZSArIG5zaXplKTsKKwogCQlu
c2l6ZSArPSBjaWZzX2NvcHlfYWNlKHBubnRhY2UsIHBudGFjZSwgTlVMTCk7CiAJCW51bV9hY2Vz
Kys7CiAKLS0gCjIuMjUuMQoK
--00000000000098f04a05bd3237c8--
