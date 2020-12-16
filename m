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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3CC9C4361B
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Dec 2020 07:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 751F223343
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Dec 2020 07:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgLPHuX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Dec 2020 02:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgLPHuW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Dec 2020 02:50:22 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96752C061793
        for <linux-cifs@vger.kernel.org>; Tue, 15 Dec 2020 23:49:41 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id m12so46010291lfo.7
        for <linux-cifs@vger.kernel.org>; Tue, 15 Dec 2020 23:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=7hQw1CN7rqeRc91OCGqhADDe8r0MUI/UCPJ4mofPVB4=;
        b=Ydnn19RMJmqceib2dWuxJkSuyc2G1uSEFqqielrWSKSNyMbtDSuAowYn9ZUfBJv4oE
         6XeG5x2SCAwarAYtLOZ217GkXLUSXfHKAyLK4/zIsMJ/amatxRL/J1H5lqJlwVbD71r/
         76mv1FZYNuXhpLqPxZSYSJvfpnEZ6C4QeLjTc1oDL6gsYvlEaxFFLWnU2cizjixg1z9U
         ghqesIERv5mZ9j9GpjP9eVIda0l/kKkUYIR9p5xQcoQ1gmhQ7o5krfl/DBBgj1UVvQzB
         qo0QzFcc8WcI+6P84VwwGeqjvQM5lqziQVga1TRhmIS5ViaDZG5acBqO9EB+uVbYsCh8
         q3EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=7hQw1CN7rqeRc91OCGqhADDe8r0MUI/UCPJ4mofPVB4=;
        b=pJCz0P9N1lTG1IV8EMXzL2B9/G6qJBYoDBoEQxzJZiKbK4TTKLzQoDGGKn0g8mdsue
         a1jqg1hJTYa4o01hwqy6+p5H4uXDqj6jpNLFyiuWWu4lSdoUm6wMhjU2H95HJKGWlgOq
         NZPcL9DTa0t9vllojalizKWEPN0QeUWQAEZAnU/ph/HUNAk+3oCCEpIMYvouSYKVbb55
         rPdQw3m0VWkB37KMBv57w1B1G6kpEh9pyr7+e8pqkXyZnmTpTh3oH6ScdxPY0/pW224R
         f8TwlaBP3U5RjfHtG/eJZ9po/jioiBpSYR8fDLJZ+Li4gJXo+jNYodv02dRkqDickpXn
         VRPg==
X-Gm-Message-State: AOAM533fopg+wW3FIi96shErgoKsUpUmrG9VhFEaHG3BUMwKKUCrDd7U
        FyOG4XRcnzLtvY1xa40h0CyjXc96asRlJXBokD6xc7/afR+gpQ==
X-Google-Smtp-Source: ABdhPJwTRVsCRlpU8vytS8XHwm+x+Oz8kcK/+QIRLj0eQUkIYPdeeGxu+GXcqM8RQwgBPtQnSlGTJLTWNE5yG4pPpjM=
X-Received: by 2002:a19:828c:: with SMTP id e134mr6986767lfd.307.1608104979759;
 Tue, 15 Dec 2020 23:49:39 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 16 Dec 2020 01:49:27 -0600
Message-ID: <CAH2r5ms=V-6bC=P2BEp_xQMiGp93JM7Oi_3Pa6CSACY97y4FoA@mail.gmail.com>
Subject: [PATCH][CIFS] correct four aliased mount parms to allow use of
 previous names
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000014bfa205b6901e70"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000014bfa205b6901e70
Content-Type: text/plain; charset="UTF-8"

    The updates to the new mount API created aliases for some
    mount parms e.g.

       esize, idsfromsid, modefromsid, signloosely
    as
       "min_enc_offload", "setuidfromacl", "modesid", "ignore_signature"

    but did not add back in the original name expected by test cases
    and current users.  It also had incorrect names for a few
    less used mount parms.

See attached patch


-- 
Thanks,

Steve

--00000000000014bfa205b6901e70
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-correct-four-aliased-mount-parms-to-allow-use-o.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-correct-four-aliased-mount-parms-to-allow-use-o.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kir467gb0>
X-Attachment-Id: f_kir467gb0

RnJvbSAyN2NmOTQ4NTNlNmQyYjVjOTgxZWQ0ZDlmNzk4OTEyMDI3MzUyNTg0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTYgRGVjIDIwMjAgMDE6MjI6NTQgLTA2MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBjb3JyZWN0IGZvdXIgYWxpYXNlZCBtb3VudCBwYXJtcyB0byBhbGxvdyB1c2Ugb2YKIHBy
ZXZpb3VzIG5hbWVzCgpUaGUgdXBkYXRlcyB0byB0aGUgbmV3IG1vdW50IEFQSSBjcmVhdGVkIGFs
aWFzZXMgZm9yIHNvbWUKbW91bnQgcGFybXMgZS5nLgoKICAgZXNpemUsIGlkc2Zyb21zaWQsIG1v
ZGVmcm9tc2lkLCBzaWdubG9vc2VseQphcwogICAibWluX2VuY19vZmZsb2FkIiwgInNldHVpZGZy
b21hY2wiLCAibW9kZXNpZCIsICJpZ25vcmVfc2lnbmF0dXJlIgoKYnV0IGRpZCBub3QgYWRkIGJh
Y2sgaW4gdGhlIG9yaWdpbmFsIG5hbWUgZXhwZWN0ZWQgYnkgdGVzdCBjYXNlcwphbmQgY3VycmVu
dCB1c2Vycy4gIEl0IGFsc28gaGFkIGluY29ycmVjdCBuYW1lcyBmb3IgYSBmZXcKbGVzcyB1c2Vk
IG1vdW50IHBhcm1zLgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNy
b3NvZnQuY29tPgpSZXZpZXdlZC1ieTogUm9ubmllIFNhaGxiZXJnIDxsc2FobGJlckByZWRoYXQu
Y29tPgotLS0KIGZzL2NpZnMvZnNfY29udGV4dC5jIHwgMTUgKysrKysrKysrKy0tLS0tCiAxIGZp
bGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9mcy9jaWZzL2ZzX2NvbnRleHQuYyBiL2ZzL2NpZnMvZnNfY29udGV4dC5jCmluZGV4IGM0Mjdl
NDk0ZWE1Ni4uMjliOTllNjhlYzgwIDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZzX2NvbnRleHQuYwor
KysgYi9mcy9jaWZzL2ZzX2NvbnRleHQuYwpAQCAtOTQsNiArOTQsNyBAQCBjb25zdCBzdHJ1Y3Qg
ZnNfcGFyYW1ldGVyX3NwZWMgc21iM19mc19wYXJhbWV0ZXJzW10gPSB7CiAJZnNwYXJhbV9mbGFn
KCJmb3JjZW1hbmRhdG9yeWxvY2siLCBPcHRfZm9yY2VtYW5kYXRvcnlsb2NrKSwKIAlmc3BhcmFt
X2ZsYWcoImZvcmNlbWFuZCIsIE9wdF9mb3JjZW1hbmRhdG9yeWxvY2spLAogCWZzcGFyYW1fZmxh
Zygic2V0dWlkZnJvbWFjbCIsIE9wdF9zZXR1aWRmcm9tYWNsKSwKKwlmc3BhcmFtX2ZsYWcoImlk
c2Zyb21zaWQiLCBPcHRfc2V0dWlkZnJvbWFjbCksCiAJZnNwYXJhbV9mbGFnX25vKCJzZXR1aWRz
IiwgT3B0X3NldHVpZHMpLAogCWZzcGFyYW1fZmxhZ19ubygiZHlucGVybSIsIE9wdF9keW5wZXJt
KSwKIAlmc3BhcmFtX2ZsYWdfbm8oImludHIiLCBPcHRfaW50ciksCkBAIC0xMDUsNiArMTA2LDcg
QEAgY29uc3Qgc3RydWN0IGZzX3BhcmFtZXRlcl9zcGVjIHNtYjNfZnNfcGFyYW1ldGVyc1tdID0g
ewogCWZzcGFyYW1fZmxhZygibG9jYWxsZWFzZSIsIE9wdF9sb2NhbGxlYXNlKSwKIAlmc3BhcmFt
X2ZsYWcoInNpZ24iLCBPcHRfc2lnbiksCiAJZnNwYXJhbV9mbGFnKCJpZ25vcmVfc2lnbmF0dXJl
IiwgT3B0X2lnbm9yZV9zaWduYXR1cmUpLAorCWZzcGFyYW1fZmxhZygic2lnbmxvb3NlbHkiLCBP
cHRfaWdub3JlX3NpZ25hdHVyZSksCiAJZnNwYXJhbV9mbGFnKCJzZWFsIiwgT3B0X3NlYWwpLAog
CWZzcGFyYW1fZmxhZygibm9hYyIsIE9wdF9ub2FjKSwKIAlmc3BhcmFtX2ZsYWcoImZzYyIsIE9w
dF9mc2MpLApAQCAtMTEyLDExICsxMTQsMTIgQEAgY29uc3Qgc3RydWN0IGZzX3BhcmFtZXRlcl9z
cGVjIHNtYjNfZnNfcGFyYW1ldGVyc1tdID0gewogCWZzcGFyYW1fZmxhZygibXVsdGl1c2VyIiwg
T3B0X211bHRpdXNlciksCiAJZnNwYXJhbV9mbGFnKCJzbG9wcHkiLCBPcHRfc2xvcHB5KSwKIAlm
c3BhcmFtX2ZsYWcoIm5vc2hhcmVzb2NrIiwgT3B0X25vc2hhcmVzb2NrKSwKLQlmc3BhcmFtX2Zs
YWdfbm8oInBlcnNpc3RlbnQiLCBPcHRfcGVyc2lzdGVudCksCi0JZnNwYXJhbV9mbGFnX25vKCJy
ZXNpbGllbnQiLCBPcHRfcmVzaWxpZW50KSwKKwlmc3BhcmFtX2ZsYWdfbm8oInBlcnNpc3RlbnRo
YW5kbGVzIiwgT3B0X3BlcnNpc3RlbnQpLAorCWZzcGFyYW1fZmxhZ19ubygicmVzaWxpZW50aGFu
ZGxlcyIsIE9wdF9yZXNpbGllbnQpLAogCWZzcGFyYW1fZmxhZygiZG9tYWluYXV0byIsIE9wdF9k
b21haW5hdXRvKSwKIAlmc3BhcmFtX2ZsYWcoInJkbWEiLCBPcHRfcmRtYSksCiAJZnNwYXJhbV9m
bGFnKCJtb2Rlc2lkIiwgT3B0X21vZGVzaWQpLAorCWZzcGFyYW1fZmxhZygibW9kZWZyb21zaWQi
LCBPcHRfbW9kZXNpZCksCiAJZnNwYXJhbV9mbGFnKCJyb290ZnMiLCBPcHRfcm9vdGZzKSwKIAlm
c3BhcmFtX2ZsYWcoImNvbXByZXNzIiwgT3B0X2NvbXByZXNzKSwKIAlmc3BhcmFtX2ZsYWcoIndp
dG5lc3MiLCBPcHRfd2l0bmVzcyksCkBAIC0xMzIsNiArMTM1LDcgQEAgY29uc3Qgc3RydWN0IGZz
X3BhcmFtZXRlcl9zcGVjIHNtYjNfZnNfcGFyYW1ldGVyc1tdID0gewogCWZzcGFyYW1fdTMyKCJk
aXJfbW9kZSIsIE9wdF9kaXJtb2RlKSwKIAlmc3BhcmFtX3UzMigicG9ydCIsIE9wdF9wb3J0KSwK
IAlmc3BhcmFtX3UzMigibWluX2VuY19vZmZsb2FkIiwgT3B0X21pbl9lbmNfb2ZmbG9hZCksCisJ
ZnNwYXJhbV91MzIoImVzaXplIiwgT3B0X21pbl9lbmNfb2ZmbG9hZCksCiAJZnNwYXJhbV91MzIo
ImJzaXplIiwgT3B0X2Jsb2Nrc2l6ZSksCiAJZnNwYXJhbV91MzIoInJzaXplIiwgT3B0X3JzaXpl
KSwKIAlmc3BhcmFtX3UzMigid3NpemUiLCBPcHRfd3NpemUpLApAQCAtMTIxMiwxNCArMTIxNiwx
NSBAQCBzdGF0aWMgaW50IHNtYjNfZnNfY29udGV4dF9wYXJzZV9wYXJhbShzdHJ1Y3QgZnNfY29u
dGV4dCAqZmMsCiAJCWJyZWFrOwogCWNhc2UgT3B0X3BlcnNpc3RlbnQ6CiAJCWlmIChyZXN1bHQu
bmVnYXRlZCkgewotCQkJaWYgKChjdHgtPm5vcGVyc2lzdGVudCkgfHwgKGN0eC0+cmVzaWxpZW50
KSkgeworCQkJY3R4LT5ub3BlcnNpc3RlbnQgPSB0cnVlOworCQkJaWYgKGN0eC0+cGVyc2lzdGVu
dCkgewogCQkJCWNpZnNfZGJnKFZGUywKIAkJCQkgICJwZXJzaXN0ZW50aGFuZGxlcyBtb3VudCBv
cHRpb25zIGNvbmZsaWN0XG4iKTsKIAkJCQlnb3RvIGNpZnNfcGFyc2VfbW91bnRfZXJyOwogCQkJ
fQogCQl9IGVsc2UgewotCQkJY3R4LT5ub3BlcnNpc3RlbnQgPSB0cnVlOwotCQkJaWYgKGN0eC0+
cGVyc2lzdGVudCkgeworCQkJY3R4LT5wZXJzaXN0ZW50ID0gdHJ1ZTsKKwkJCWlmICgoY3R4LT5u
b3BlcnNpc3RlbnQpIHx8IChjdHgtPnJlc2lsaWVudCkpIHsKIAkJCQljaWZzX2RiZyhWRlMsCiAJ
CQkJICAicGVyc2lzdGVudGhhbmRsZXMgbW91bnQgb3B0aW9ucyBjb25mbGljdFxuIik7CiAJCQkJ
Z290byBjaWZzX3BhcnNlX21vdW50X2VycjsKLS0gCjIuMjcuMAoK
--00000000000014bfa205b6901e70--
