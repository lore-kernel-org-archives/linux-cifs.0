Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E3B8C2B9F4
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 23:02:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CC9C60FD8
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 23:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhFVXEr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 19:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhFVXEq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Jun 2021 19:04:46 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCB5C061574
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 16:02:29 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id f13so380809ljp.10
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 16:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=c/ruWRnwSmVfnqBUYQrCozS8iPWLOvHZHnppNj8oZ2E=;
        b=b/59NIoxgtJOpJjkJK/GoBNvv7o5kr82U3HB/5o+11SNC2mOhe53pA6LCJmyyel1j8
         wZ9rmHFiMiloPxoCRVrwGhoRPUfqxbDRI8Ev0gCYXzfc4/R6ahETSBTqKFYsfzMkFs2M
         hNttSK5XKodIJP594/YxL6srTFA5rQOK1YCTE3uD6Wy/NOWYPPtsGtSOEq5ceP2iuNHS
         WDisaSJJjS3Yamz+L8xC193upThQElli4+6E1/4RBYxvLMyWeqxRc/MN2GDsEYL1jPTL
         5/MR92yvyasCDerI3+KDAQN7YXyHARK+slAG4SR255w3BANQuAEUeGHVSkM5tE5OxAdm
         Nbzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=c/ruWRnwSmVfnqBUYQrCozS8iPWLOvHZHnppNj8oZ2E=;
        b=E8qS9BLhPdoab6FYWbJVeWvsnZjLa6S/YGXakJyPf6o+GFSdMXvOiNNHEnp5TZ3frU
         Z1rux9Qn4D8QY+I16iZ1apaMOwBziCsQtsxzen/36CD/zTaa54Gex43dj1VFueg5ZXN2
         MYnMLvtu5TdseXWTIzwKGJVFpCjmsgB4YVhzUL1gKKYWbpyH7ZnW58MYfkVyGXQpc1EH
         NOYFuMNKhet52FBEAqAJ7GnKuhELuDTd+96+jf0g3yE4u6/pGB9QgEQGP9F6OaI4LVVb
         eUXpQ7yVhDkVrI1yDb0KXQC2nYbv/AaFhD70PFubUFzFLPzvZy92w9sr1cxAy5jF9Twi
         4HQg==
X-Gm-Message-State: AOAM532PUsHeWpW0u3f36hn/JYKg4a5CINL30CJNDceAv7Eky8asN2Us
        dSlX8lm2Z0jabjTTbkIbzfjorynJLVM/zPdlYEYzmcZxsF+bGQ==
X-Google-Smtp-Source: ABdhPJx/ncupXyfh+klLMSjl8x/Uq4mjstQoI7RqpY6Hdq5eg5yvVXJwKOCoo6tqhCE7aU8zFxbfz+yEi0P2c/X2ZZE=
X-Received: by 2002:a2e:509:: with SMTP id 9mr5463172ljf.6.1624402947448; Tue,
 22 Jun 2021 16:02:27 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 22 Jun 2021 18:02:16 -0500
Message-ID: <CAH2r5ms_paV2a7KZwWkmz25pn4iS2kEDErGpNapOWZ5Kd_bUNw@mail.gmail.com>
Subject: [PATCH][CIFS] Fix uninitialized pointer access to dacl_ptr in build_sec_desc
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000a7d55a05c562c852"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000a7d55a05c562c852
Content-Type: text/plain; charset="UTF-8"

    smb3: fix possible access to uninitialized pointer to DACL

    dacl_ptr can be null so we must check for it (ie if dacloffset is
set) everywhere dacl_ptr is
    used in build_sec_desc - and we were missing one check

    Addresses-Coverity: 1475598 ("Explicit null dereference")


-- 
Thanks,

Steve

--000000000000a7d55a05c562c852
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-possible-access-to-unitialized-pointer-to-D.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-possible-access-to-unitialized-pointer-to-D.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kq8njpk10>
X-Attachment-Id: f_kq8njpk10

RnJvbSBlYzA2Y2IwNDM3NmU1YWJjOTI3YTliODVkZDc2OGNlODcyODk2NWJiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjIgSnVuIDIwMjEgMTc6NTQ6NTAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggcG9zc2libGUgYWNjZXNzIHRvIHVuaW5pdGlhbGl6ZWQgcG9pbnRlciB0byBEQUNM
CgpkYWNsX3B0ciBjYW4gYmUgbnVsbCBzbyB3ZSBtdXN0IGNoZWNrIGZvciBpdCBldmVyeXdoZXJl
IGl0IGlzCnVzZWQgaW4gYnVpbGRfc2VjX2Rlc2MuCgpBZGRyZXNzZXMtQ292ZXJpdHk6IDE0NzU1
OTggKCJFeHBsaWNpdCBudWxsIGRlcmVmZXJlbmNlIikKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJl
bmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY2lmc2FjbC5jIHwgMiAr
LQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0t
Z2l0IGEvZnMvY2lmcy9jaWZzYWNsLmMgYi9mcy9jaWZzL2NpZnNhY2wuYwppbmRleCA3ODQ0MDdm
OTI4MGYuLjI1YTgxMzkzMzZmYSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzYWNsLmMKKysrIGIv
ZnMvY2lmcy9jaWZzYWNsLmMKQEAgLTEzMDgsNyArMTMwOCw3IEBAIHN0YXRpYyBpbnQgYnVpbGRf
c2VjX2Rlc2Moc3RydWN0IGNpZnNfbnRzZCAqcG50c2QsIHN0cnVjdCBjaWZzX250c2QgKnBubnRz
ZCwKIAkJbmRhY2xfcHRyID0gKHN0cnVjdCBjaWZzX2FjbCAqKSgoY2hhciAqKXBubnRzZCArIG5k
YWNsb2Zmc2V0KTsKIAkJbmRhY2xfcHRyLT5yZXZpc2lvbiA9CiAJCQlkYWNsb2Zmc2V0ID8gZGFj
bF9wdHItPnJldmlzaW9uIDogY3B1X3RvX2xlMTYoQUNMX1JFVklTSU9OKTsKLQkJbmRhY2xfcHRy
LT5udW1fYWNlcyA9IGRhY2xfcHRyLT5udW1fYWNlczsKKwkJbmRhY2xfcHRyLT5udW1fYWNlcyA9
IGRhY2xvZmZzZXQgPyBkYWNsX3B0ci0+bnVtX2FjZXMgOiAwOwogCiAJCWlmICh1aWRfdmFsaWQo
dWlkKSkgeyAvKiBjaG93biAqLwogCQkJdWlkX3QgaWQ7Ci0tIAoyLjMwLjIKCg==
--000000000000a7d55a05c562c852--
