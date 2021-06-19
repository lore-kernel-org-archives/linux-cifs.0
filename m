Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B75C2B9F4
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Jun 2021 21:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF79460FE9
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Jun 2021 21:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbhFSVbS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 19 Jun 2021 17:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhFSVbS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 19 Jun 2021 17:31:18 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718DCC061574
        for <linux-cifs@vger.kernel.org>; Sat, 19 Jun 2021 14:29:05 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id m21so22997110lfg.13
        for <linux-cifs@vger.kernel.org>; Sat, 19 Jun 2021 14:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=rEiWUXE2a7U8vX2G+sJywEz4jd5xUVUJf0/NXsG3dXc=;
        b=JFaSt2TOpklAbbGw1SGnSvxUyN8585V115VkA1XD4rl5wbLPO/i2pvQ4rG1H+QAQHy
         cFPbp7TGrRuB3oElbpOE/vR/uIXwM1QLW6Yi4QPJYMcVTpNhujHGly8HvwJlPH2qtgO3
         VwYY1BVO32hMqe5SV1RBz3WwFt+vu9zkt7Sr40jxU+0eJy+9ZblOcAt74idZACYBVosq
         UqQbhTuOVxtaMXqPvDahkRpYtUayPI7x7LM8FJJo1bIl0KuJQQcxwHfO/rex4tWtXPX/
         4nCsDnIBHSI1fdKsHtgVRUnd8bq/D32LuRkOXXzitlfEI210vywxgRGcSKuxKf+MQom/
         d2kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=rEiWUXE2a7U8vX2G+sJywEz4jd5xUVUJf0/NXsG3dXc=;
        b=TAAbBQK1Fxc/TFd4PYgD03aWjAa3FWFWHi5wXXp8NSVxO2J3Prf4wFlriMLtAmt6xL
         uAIJGTUglBviSXIOvUabTLrSvdRTxkeVtvc/LNFweLTRpfPKsy6WDTBE5sWfggIhzNoo
         D3xtVNNF601axWmuI6bsUK4DI28MHoJNGKY7k9ThnHwY8IVv7F0mwBcUSogiMddRL9TA
         xdjhRrWh3kAqTMTDLwuozJXu0IpQG5Tv/2xvy0foMwrjUKQYPgzin7Ldby8y1bSoQtmW
         VOur4dvmXnrfvtS1qyWkHd45Iflcdt1/hmVbPK8wXSyCDIwwdO3WAkdGGpxfg++UvmoY
         kEMA==
X-Gm-Message-State: AOAM5322KIQAsOF+PIcDlM+WSgHF+VPYTmgCFl5WizgK6J/ESUuPIkLH
        ZtC6kP5YpcADQGQyw4Srr0B7gZe3aezOQmgkMt/TXfnz5KlYPw==
X-Google-Smtp-Source: ABdhPJxaH9KrMtouS2ivRgSFu0/3IG/ql3OxYGW0Ah2b6S0+nQQJ/Opg9v9H1hZv3w4HNrEero6ERIU5DFQJiE+K0Zw=
X-Received: by 2002:a19:6a0e:: with SMTP id u14mr8472264lfu.184.1624138143058;
 Sat, 19 Jun 2021 14:29:03 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 19 Jun 2021 16:28:51 -0500
Message-ID: <CAH2r5mug9H-J8PQnrBvSNaK3Sz3-aji8FwPdNEfANf_X_keDzw@mail.gmail.com>
Subject: [PATCH][SMB311] remove dead code for non-compounded SMB311 posix
 query info
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000015664c05c525218c"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000015664c05c525218c
Content-Type: text/plain; charset="UTF-8"

Although we may need this in some cases in the future, remove the
currently unused, non-compounded version of POSIX query info,
SMB11_posix_query_info (instead smb311_posix_query_path_info is now
called e.g. when revalidating dentries or retrieving info for getattr)

Addresses-Coverity: 1495708 ("Resource leaks")

-- 
Thanks,

Steve

--00000000000015664c05c525218c
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb311-remove-dead-code-for-non-compounded-posix-que.patch"
Content-Disposition: attachment; 
	filename="0001-smb311-remove-dead-code-for-non-compounded-posix-que.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kq49wagh0>
X-Attachment-Id: f_kq49wagh0

RnJvbSA0ZjBiYWM2YjY2ZGEzNjE4ZDcxYjg5ZjNjOThmYWVjNWQxYzNmYWM4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMTkgSnVuIDIwMjEgMTY6MTk6MDkgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzMTE6IHJlbW92ZSBkZWFkIGNvZGUgZm9yIG5vbiBjb21wb3VuZGVkIHBvc2l4IHF1ZXJ5IGlu
Zm8KCkFsdGhvdWdoIHdlIG1heSBuZWVkIHRoaXMgaW4gc29tZSBjYXNlcyBpbiB0aGUgZnV0dXJl
LCByZW1vdmUgdGhlCmN1cnJlbnRseSB1bnVzZWQsIG5vbi1jb21wb3VuZGVkIHZlcnNpb24gb2Yg
UE9TSVggcXVlcnkgaW5mbywKU01CMTFfcG9zaXhfcXVlcnlfaW5mbyAoaW5zdGVhZCBzbWIzMTFf
cG9zaXhfcXVlcnlfcGF0aF9pbmZvIGlzIG5vdwpjYWxsZWQgZS5nLiB3aGVuIHJldmFsaWRhdGlu
ZyBkZW50cmllcyBvciByZXRyaWV2aW5nIGluZm8gZm9yIGdldGF0dHIpCgpBZGRyZXNzZXMtQ292
ZXJpdHk6IDE0OTU3MDggKCJSZXNvdXJjZSBsZWFrcyIpClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZy
ZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL3NtYjJwZHUuYyB8IDQg
KysrKwogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL2Np
ZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXggNGEyNDRjYzRlOTAyLi45ODU4
Njg3NmE5NTUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5jCisrKyBiL2ZzL2NpZnMvc21i
MnBkdS5jCkBAIC0zNDg0LDYgKzM0ODQsOCBAQCBpbnQgU01CMl9xdWVyeV9pbmZvKGNvbnN0IHVu
c2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCQkgIE5VTEwpOwogfQog
CisjaWZkZWYgMAorLyogY3VycmVudGx5IHVudXNlZCwgYXMgbm93IHdlIGFyZSBkb2luZyBjb21w
b3VuZGluZyBpbnN0ZWFkIChzZWUgc21iMzExX3Bvc2l4X3F1ZXJ5X3BhdGhfaW5mbykgKi8KIGlu
dAogU01CMzExX3Bvc2l4X3F1ZXJ5X2luZm8oY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0
IGNpZnNfdGNvbiAqdGNvbiwKIAkJdTY0IHBlcnNpc3RlbnRfZmlkLCB1NjQgdm9sYXRpbGVfZmlk
LCBzdHJ1Y3Qgc21iMzExX3Bvc2l4X3FpbmZvICpkYXRhLCB1MzIgKnBsZW4pCkBAIC0zNDk1LDcg
KzM0OTcsOSBAQCBTTUIzMTFfcG9zaXhfcXVlcnlfaW5mbyhjb25zdCB1bnNpZ25lZCBpbnQgeGlk
LCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCXJldHVybiBxdWVyeV9pbmZvKHhpZCwgdGNvbiwg
cGVyc2lzdGVudF9maWQsIHZvbGF0aWxlX2ZpZCwKIAkJCSAgU01CX0ZJTkRfRklMRV9QT1NJWF9J
TkZPLCBTTUIyX09fSU5GT19GSUxFLCAwLAogCQkJICBvdXRwdXRfbGVuLCBzaXplb2Yoc3RydWN0
IHNtYjMxMV9wb3NpeF9xaW5mbyksICh2b2lkICoqKSZkYXRhLCBwbGVuKTsKKwkvKiBOb3RlIGNh
bGxlciBtdXN0IGZyZWUgImRhdGEiIChwYXNzZWQgaW4gYWJvdmUpLiBJdCBtYXkgYmUgYWxsb2Nh
dGVkIGluIHF1ZXJ5X2luZm8gY2FsbCAqLwogfQorI2VuZGlmCiAKIGludAogU01CMl9xdWVyeV9h
Y2woY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKLS0gCjIu
MzAuMgoK
--00000000000015664c05c525218c--
