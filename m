Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F78C433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Feb 2022 07:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbiBAHgt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Feb 2022 02:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbiBAHgt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Feb 2022 02:36:49 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCA6C06173D
        for <linux-cifs@vger.kernel.org>; Mon, 31 Jan 2022 23:36:49 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id z19so31862321lfq.13
        for <linux-cifs@vger.kernel.org>; Mon, 31 Jan 2022 23:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=elKn4vakOsBG7m79uqt+w4yX/RyLRRgctL1bVd6YaPA=;
        b=hBa/ppq71p1kvgwiphWUuRTuTwyXeUVFVtvyJ37H3a9Bk4yLuhKxbAMl0LK0DogNcf
         uQKl7cAtZ/itEaeQIQCWiGaJzqHTBMJkLV5rBvGjVvmNKIQ5Wj/Wr7FoxA2nRlVRk8Io
         humpu1a5a3ZC9WbkftdNcy32OWfS5Ye0rHzy4XZfE0Q/BYj+VxBO5A6Flm+n+WDIJ6Mo
         beoo7WSL3rucn5yIypblxJqh68KgSunJdQjAkoetQ2PSQjMky9OhNMOAFRpJK0dMw61H
         Fek57CHBShv/2RUFjcdqyb27aDBmtsSKwRbwlIpDIUm+EGa2Tn0d/b6M88PhoI2xu70I
         2pYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=elKn4vakOsBG7m79uqt+w4yX/RyLRRgctL1bVd6YaPA=;
        b=cbFEyM6Ktv2LRGOQ8XEidPvM6TsulVbsgra8dTgOjg+34CR1Ez6RvO0DYyYQTvywdI
         2uUrkEIPYtnFt2a2IVpyYNj4oxGuBlnym73XiRbN5SjRxQVJ+XHsuK5nW1vzO48qaKyU
         B92yQfi+OnzOwLKLheALsGJlol4/zQPGqQDcsKkXHwEynxhgXydECtbCXKT6irFZTKDA
         rh/ZppKYd1X2bzbw59pmqWqhfz0DsNSidC1ipQnwswNkWNl1+UveRjpc2NMa14fBL8+h
         l7zGJeK7AxD6ilVP26McRGd3YtfMCcPDyyXRuD2xPwA7PllMAdih5uTG/F3otspguFqq
         O+DQ==
X-Gm-Message-State: AOAM532vf9c35F61jWZ+7HZHwi7rYODTzPc6NVuckmH7cTas3dTRKw9M
        6s0/aL59R+j7zpBmIbQw+lWnvdioh/sOBA13jTJJ5Yk8
X-Google-Smtp-Source: ABdhPJw1Pciv5rfuxjsVknnRGJebbQ8m+RBy0v63CVMirdKBmu7K75ePNDvgKGx/8JV8iG2mKX3x9I065yRvg5tjBUA=
X-Received: by 2002:a05:6512:68e:: with SMTP id t14mr18818746lfe.366.1643701007414;
 Mon, 31 Jan 2022 23:36:47 -0800 (PST)
MIME-Version: 1.0
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Tue, 1 Feb 2022 13:06:36 +0530
Message-ID: <CACdtm0b61sLQo85HdZubh34ieMveMZdZ_tbpmf41U7u+-_LgFw@mail.gmail.com>
Subject: [PATCH] cifs: Invalidate fscache cookie
To:     Steve French <smfrench@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        David Howells <dhowells@redhat.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000aa39b805d6eff670"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000aa39b805d6eff670
Content-Type: text/plain; charset="UTF-8"

Hi All,

Currently, FScache is getting invalidated during close of the file. It
should be invalidated only when there is change in inode attributes.

Please find the below patch which will address the fscache invalidation.

Regards,
Rohith

--000000000000aa39b805d6eff670
Content-Type: application/octet-stream; 
	name="Invalidate-fscache-cookie-only-when-inode-attributes.patch"
Content-Disposition: attachment; 
	filename="Invalidate-fscache-cookie-only-when-inode-attributes.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kz3t0t0m0>
X-Attachment-Id: f_kz3t0t0m0

RnJvbSA5NjUxMzA3ZTkwNzU1YWM4MmU2YTFmZjNlODJjMjk0Y2RlMmM3ZWIyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNAbWljcm9zb2Z0
LmNvbT4KRGF0ZTogVHVlLCAxIEZlYiAyMDIyIDA3OjIyOjAyICswMDAwClN1YmplY3Q6IFtQQVRD
SF0gSW52YWxpZGF0ZSBmc2NhY2hlIGNvb2tpZSBvbmx5IHdoZW4gaW5vZGUgYXR0cmlidXRlcyBh
cmUKIGNoYW5nZWQuCgpTaWduZWQtb2ZmLWJ5OiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNA
bWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2lub2RlLmMgfCA4ICsrKystLS0tCiAxIGZpbGUg
Y2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Zz
L2NpZnMvaW5vZGUuYyBiL2ZzL2NpZnMvaW5vZGUuYwppbmRleCA3ZDhiM2NlYjJhZjMuLjYwZDg1
M2M5MmY2YSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9pbm9kZS5jCisrKyBiL2ZzL2NpZnMvaW5vZGUu
YwpAQCAtODMsNiArODMsNyBAQCBzdGF0aWMgdm9pZCBjaWZzX3NldF9vcHMoc3RydWN0IGlub2Rl
ICppbm9kZSkKIHN0YXRpYyB2b2lkCiBjaWZzX3JldmFsaWRhdGVfY2FjaGUoc3RydWN0IGlub2Rl
ICppbm9kZSwgc3RydWN0IGNpZnNfZmF0dHIgKmZhdHRyKQogeworCXN0cnVjdCBjaWZzX2ZzY2Fj
aGVfaW5vZGVfY29oZXJlbmN5X2RhdGEgY2Q7CiAJc3RydWN0IGNpZnNJbm9kZUluZm8gKmNpZnNf
aSA9IENJRlNfSShpbm9kZSk7CiAKIAljaWZzX2RiZyhGWUksICIlczogcmV2YWxpZGF0aW5nIGlu
b2RlICVsbHVcbiIsCkBAIC0xMTMsNiArMTE0LDkgQEAgY2lmc19yZXZhbGlkYXRlX2NhY2hlKHN0
cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBjaWZzX2ZhdHRyICpmYXR0cikKIAljaWZzX2RiZyhG
WUksICIlczogaW52YWxpZGF0aW5nIGlub2RlICVsbHUgbWFwcGluZ1xuIiwKIAkJIF9fZnVuY19f
LCBjaWZzX2ktPnVuaXF1ZWlkKTsKIAlzZXRfYml0KENJRlNfSU5PX0lOVkFMSURfTUFQUElORywg
JmNpZnNfaS0+ZmxhZ3MpOworCS8qIEludmFsaWRhdGUgZnNjYWNoZSBjb29raWUgKi8KKwljaWZz
X2ZzY2FjaGVfZmlsbF9jb2hlcmVuY3koJmNpZnNfaS0+dmZzX2lub2RlLCAmY2QpOworCWZzY2Fj
aGVfaW52YWxpZGF0ZShjaWZzX2lub2RlX2Nvb2tpZShpbm9kZSksICZjZCwgaV9zaXplX3JlYWQo
aW5vZGUpLCAwKTsKIH0KIAogLyoKQEAgLTIyNjEsOCArMjI2NSw2IEBAIGNpZnNfZGVudHJ5X25l
ZWRzX3JldmFsKHN0cnVjdCBkZW50cnkgKmRlbnRyeSkKIGludAogY2lmc19pbnZhbGlkYXRlX21h
cHBpbmcoc3RydWN0IGlub2RlICppbm9kZSkKIHsKLQlzdHJ1Y3QgY2lmc19mc2NhY2hlX2lub2Rl
X2NvaGVyZW5jeV9kYXRhIGNkOwotCXN0cnVjdCBjaWZzSW5vZGVJbmZvICpjaWZzaSA9IENJRlNf
SShpbm9kZSk7CiAJaW50IHJjID0gMDsKIAogCWlmIChpbm9kZS0+aV9tYXBwaW5nICYmIGlub2Rl
LT5pX21hcHBpbmctPm5ycGFnZXMgIT0gMCkgewpAQCAtMjI3Miw4ICsyMjc0LDYgQEAgY2lmc19p
bnZhbGlkYXRlX21hcHBpbmcoc3RydWN0IGlub2RlICppbm9kZSkKIAkJCQkgX19mdW5jX18sIGlu
b2RlKTsKIAl9CiAKLQljaWZzX2ZzY2FjaGVfZmlsbF9jb2hlcmVuY3koJmNpZnNpLT52ZnNfaW5v
ZGUsICZjZCk7Ci0JZnNjYWNoZV9pbnZhbGlkYXRlKGNpZnNfaW5vZGVfY29va2llKGlub2RlKSwg
JmNkLCBpX3NpemVfcmVhZChpbm9kZSksIDApOwogCXJldHVybiByYzsKIH0KIAotLSAKMi4zMi4w
Cgo=
--000000000000aa39b805d6eff670--
