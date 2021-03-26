Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A4FC433C1
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 12:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0B6161A2A
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 12:12:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhCZMML (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Mar 2021 08:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbhCZMLj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Mar 2021 08:11:39 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68169C0613AA
        for <linux-cifs@vger.kernel.org>; Fri, 26 Mar 2021 05:11:39 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id o66so5602736ybg.10
        for <linux-cifs@vger.kernel.org>; Fri, 26 Mar 2021 05:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=sNVwtGw7Krw8xGvbdtMZu7SCnduU+UsXfRy+PPDBJK8=;
        b=MKV2Ffgsh/fFT58pxq4Nkhl5aI0e0PD4ipa5cp2lkV/3S2cYSKg6iAABfCYCpKmahy
         +4tJlnrG1h/3yaOZReY0triyy5YayxrsAtPjQyPlD0gCxbUNqCwS+bMRjHq+A4VuD/Ng
         QJcrf6XC8NBdYFVrMvu5aFH2/fCucl/6Tvf3tP6OgnEZV/IBBIFVwU6tA7vshBlgxkQb
         LyUdpl3M8/yI3gDlQJeUf49PT1FlvvJYHpdmK5px2NB28oUET9zyHeqCHOXCNsGskrgO
         cwzDPptvMOoVWmyYO7L2LQXhmIHS/Mpw4jsmjsJsMofk6yye6bKsDSvr7yfN6UiYoXUg
         gckg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=sNVwtGw7Krw8xGvbdtMZu7SCnduU+UsXfRy+PPDBJK8=;
        b=AxEEkbFbAbLSOSi6DV/BCHUR+C/bKKylxdYjNYBbDvJaqV0APnPCYWkIE0QQOafLCL
         0ZC89a3xHncTKwxv8zMJczBCtIEeunPJ0lwdOIT1ZP/+AcAAuYrVfIgWDVwclOOlw8rk
         EkppV6E9yPs5fYgXbwL9dTwSwXqvDVx7kDQFDWtuzeciI0eVClSQ8WAhONXYPXjfyeAa
         G3yn4044pa3B5rhjmCowX131nwG3u9iIZ7g9FameRN+NFEVZMFYytGTvpGVuwauukxe5
         yzsuSyVypo5S+ykqgsz4TIA0T6kLrz8IAPGTW77SSgIDWTOKtOVJQuHg4Rcaa1RIsyIA
         HDkg==
X-Gm-Message-State: AOAM532ajKyVIggU6L2A64ujdYyG85Xb9Glki9O4dKEkIpxQ6oEuU7Op
        8on0B/Ob9ZdE1iUp3QfNtLy2GeCBsPEYNzKO1fNsA4vh0Q8=
X-Google-Smtp-Source: ABdhPJwUlofmzlYkE3tN+QAA0y2/oltkuQD2svWNgSYnF386DebOy7V+52yKM+CxLPdsm4Y39ClufL3E25fuPNB7XSk=
X-Received: by 2002:a25:dd06:: with SMTP id u6mr19619032ybg.97.1616760698660;
 Fri, 26 Mar 2021 05:11:38 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 26 Mar 2021 17:41:27 +0530
Message-ID: <CANT5p=rr-rDZ1Jo_rzM0_63-pHOKPcRSnML0ucOVkSBVWrSc4A@mail.gmail.com>
Subject: cifs: Fix chmod with modefromsid when an older ACE already exists.
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000002190f205be6f6f5d"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000002190f205be6f6f5d
Content-Type: text/plain; charset="UTF-8"

Found a regression in modefromsid with my last fix in cifsacl.
Tested against mode check tests for both cifsacl and modefromsid this time.

-- 
Regards,
Shyam

--0000000000002190f205be6f6f5d
Content-Type: application/octet-stream; 
	name="0001-cifs-Fix-chmod-with-modefromsid-when-an-older-ACE-al.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Fix-chmod-with-modefromsid-when-an-older-ACE-al.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kmq8019v0>
X-Attachment-Id: f_kmq8019v0

RnJvbSBkZjEyZjg2NmQ1N2VjNTdkOGUyNGVlOTIxN2Q4NzhiOTc1MTI4YWE1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBGcmksIDI2IE1hciAyMDIxIDEwOjI4OjE2ICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogRml4IGNobW9kIHdpdGggbW9kZWZyb21zaWQgd2hlbiBhbiBvbGRlciBBQ0UgYWxyZWFk
eQogZXhpc3RzLgoKTXkgcmVjZW50IGZpeGVzIHRvIGNpZnNhY2wgdG8gbWFpbnRhaW4gaW5oZXJp
dGVkIEFDRXMgaGFkCnJlZ3Jlc3NlZCBtb2RlZnJvbXNpZCB3aGVuIGFuIG9sZGVyIEFDTCBhbHJl
YWR5IGV4aXN0cy4KClRoZSBjaWZzYWNsIGZpeCB0aGF0IGNhdXNlZCB0aGlzIHJlZ3Jlc3Npb246
CmNpZnM6IFJldGFpbiBvbGQgQUNFcyB3aGVuIGNvbnZlcnRpbmcgYmV0d2VlbiBtb2RlIGJpdHMg
YW5kIEFDTC4KCkZpeGluZyBpdCBoZXJlLgoKU2lnbmVkLW9mZi1ieTogU2h5YW0gUHJhc2FkIE4g
PHNwcmFzYWRAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNhY2wuYyB8IDMgKy0tCiAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvZnMvY2lmcy9jaWZzYWNsLmMgYi9mcy9jaWZzL2NpZnNhY2wuYwppbmRleCAyYmUyMmE1YzY5
MGYuLmQxNzhjZjg1ZTkyNiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzYWNsLmMKKysrIGIvZnMv
Y2lmcy9jaWZzYWNsLmMKQEAgLTExMzAsOCArMTEzMCw3IEBAIHN0YXRpYyBpbnQgc2V0X2NobW9k
X2RhY2woc3RydWN0IGNpZnNfYWNsICpwZGFjbCwgc3RydWN0IGNpZnNfYWNsICpwbmRhY2wsCiAJ
CX0KIAogCQkvKiBJZiBpdCdzIGFueSBvbmUgb2YgdGhlIEFDRSB3ZSdyZSByZXBsYWNpbmcsIHNr
aXAhICovCi0JCWlmICghbW9kZV9mcm9tX3NpZCAmJgotCQkJCSgoY29tcGFyZV9zaWRzKCZwbnRh
Y2UtPnNpZCwgJnNpZF91bml4X05GU19tb2RlKSA9PSAwKSB8fAorCQlpZiAoKChjb21wYXJlX3Np
ZHMoJnBudGFjZS0+c2lkLCAmc2lkX3VuaXhfTkZTX21vZGUpID09IDApIHx8CiAJCQkJKGNvbXBh
cmVfc2lkcygmcG50YWNlLT5zaWQsIHBvd25lcnNpZCkgPT0gMCkgfHwKIAkJCQkoY29tcGFyZV9z
aWRzKCZwbnRhY2UtPnNpZCwgcGdycHNpZCkgPT0gMCkgfHwKIAkJCQkoY29tcGFyZV9zaWRzKCZw
bnRhY2UtPnNpZCwgJnNpZF9ldmVyeW9uZSkgPT0gMCkgfHwKLS0gCjIuMjUuMQoK
--0000000000002190f205be6f6f5d--
