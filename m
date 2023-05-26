Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E29C77B7A
	for <linux-cifs@archiver.kernel.org>; Fri, 26 May 2023 00:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjEZAPz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 May 2023 20:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjEZAPy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 May 2023 20:15:54 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B5F18D
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 17:15:53 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4f4b2bc1565so85862e87.2
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 17:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685060151; x=1687652151;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZfhJaqPyjefpsKuZf0KN4c3vpMY0NKu2TD2PSGpqS8A=;
        b=gqGCWt6WDQ17bGEUG7Gleu5D3Bdv/HM48cSbxH9GZpRHRAv9z42DqNi2z3lgOs5V8s
         JzNTDhtgM+7sJ8qQ7bOKDPuXHjyp4PAxaNniSylg5/mlIzSLwj59tkhhRIwS0fCXJvnb
         yl352wn9G2zOFqz3xZPNOl7RdmZmlcnmXCThsXomkVWWZSM46Bgc0xujUfLL0JECX6HO
         LvGqaxP5Z9ny3ucfuaNi6taTzKqjrmiNYWi6HrYAM+/I1hWxza05Pab0GcXegasK7XF5
         l8jukyTUkB6pCF6sfHYzsaXl5n5p6uWMhXgVsKgOFC7TLqgdgo/sLrNZIs8hh/nV8rXL
         LqGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685060151; x=1687652151;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZfhJaqPyjefpsKuZf0KN4c3vpMY0NKu2TD2PSGpqS8A=;
        b=ORySrs1fjcT/0eJwXbOE+2aAyNwSU9bB5biU1Crpruq/ayu1zb6+vFanhNLmM2pigW
         PGbROHpr4SEWE20Zoc1emkxB67hGEO1rGH3/KIoUGEb7OS8UjR0zFF2IyOG/Ia8obm7U
         +qPhMUm7QvfUj7qr4xFfphiob0z/tGfT4XPiAnxpangPfYkMg1/zEsXtCIZlt/WfdSE1
         qCLDGLgKGuvCTZabiAuU7Ih7SA/HhHA+1E/p1ZF4ctlUEaMcPQ8RZwBmCe5afWneViPj
         o/giLenQ+IGNtbRL0lEga86FTBrAj6twZzqE6zyns84zUcL5uetPfORdaCeMGm/oYwTr
         kLEA==
X-Gm-Message-State: AC+VfDxnP2b7A6evGKH+fcLsEIhkxORtetxKdJQ0wmPuMTHizMiYvwuV
        9Ew00nKCySjG5SwKxEGbF56dTY2UflgapCgvni2QuYcI8sxDMCR9
X-Google-Smtp-Source: ACHHUZ6LE8cIz1gksl3d2AS1aneBPslU+v1yoAVpw9fY2RxinOzLCP3VC/QrWMqEn062CA8t64vEn2IASjzMjc1dPtc=
X-Received: by 2002:ac2:547c:0:b0:4eb:3fb2:c56d with SMTP id
 e28-20020ac2547c000000b004eb3fb2c56dmr6616116lfn.12.1685060150812; Thu, 25
 May 2023 17:15:50 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 25 May 2023 19:15:39 -0500
Message-ID: <CAH2r5msJwaietr+iS09HJx+7ZwsJrd_AHcsvgP0zS4LPmX2++Q@mail.gmail.com>
Subject: [PATCH][SMB3] missing null check in SMB2_change_notify
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Dan Carpenter <dan.carpenter@linaro.org>,
        kbuild test robot <lkp@intel.com>,
        oe-kbuild-all@lists.linux.dev
Content-Type: multipart/mixed; boundary="000000000000b8172305fc8da35f"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000b8172305fc8da35f
Content-Type: text/plain; charset="UTF-8"

If plen is null when passed in, we only checked for null
in one of the two places where it could be used. Although
plen is always valid (not null) for current callers of the
SMB2_change_notify function, this change makes it more consistent.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/all/202305251831.3V1gbbFs-lkp@intel.com/


-- 
Thanks,

Steve

--000000000000b8172305fc8da35f
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-missing-null-check-in-SMB2_change_notify.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-missing-null-check-in-SMB2_change_notify.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_li3taksv0>
X-Attachment-Id: f_li3taksv0

RnJvbSBlYTE2Mjg1OGM1MTU5YTYwNTJiZWYzZmU1MTk4YzI0ZTBkMDBjYjZjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMjUgTWF5IDIwMjMgMTg6NTM6MjggLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBtaXNzaW5nIG51bGwgY2hlY2sgaW4gU01CMl9jaGFuZ2Vfbm90aWZ5CgpJZiBwbGVuIGlz
IG51bGwgd2hlbiBwYXNzZWQgaW4sIHdlIG9ubHkgY2hlY2tlZCBmb3IgbnVsbAppbiBvbmUgb2Yg
dGhlIHR3byBwbGFjZXMgd2hlcmUgaXQgY291bGQgYmUgdXNlZC4gQWx0aG91Z2gKcGxlbiBpcyBh
bHdheXMgdmFsaWQgKG5vdCBudWxsKSBmb3IgY3VycmVudCBjYWxsZXJzIG9mIHRoZQpTTUIyX2No
YW5nZV9ub3RpZnkgZnVuY3Rpb24sIHRoaXMgY2hhbmdlIG1ha2VzIGl0IG1vcmUgY29uc2lzdGVu
dC4KClJlcG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4KUmVwb3J0
ZWQtYnk6IERhbiBDYXJwZW50ZXIgPGVycm9yMjdAZ21haWwuY29tPgpDbG9zZXM6IGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2FsbC8yMDIzMDUyNTE4MzEuM1YxZ2JiRnMtbGtwQGludGVsLmNvbS8K
U2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0K
IGZzL3NtYi9jbGllbnQvc21iMnBkdS5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9zbWIycGR1
LmMgYi9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYwppbmRleCA5ZWQ2MWI2ZjliMjEuLjcwNjNiMzk1
ZDIyZiAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9zbWIycGR1LmMKKysrIGIvZnMvc21iL2Ns
aWVudC9zbWIycGR1LmMKQEAgLTM3MjUsNyArMzcyNSw3IEBAIFNNQjJfY2hhbmdlX25vdGlmeShj
b25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQlpZiAoKm91
dF9kYXRhID09IE5VTEwpIHsKIAkJCXJjID0gLUVOT01FTTsKIAkJCWdvdG8gY25vdGlmeV9leGl0
OwotCQl9IGVsc2UKKwkJfSBlbHNlIGlmIChwbGVuKQogCQkJKnBsZW4gPSBsZTMyX3RvX2NwdShz
bWJfcnNwLT5PdXRwdXRCdWZmZXJMZW5ndGgpOwogCX0KIAotLSAKMi4zNC4xCgo=
--000000000000b8172305fc8da35f--
