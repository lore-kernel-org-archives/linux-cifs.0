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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F302C433B4
	for <linux-cifs@archiver.kernel.org>; Sat,  8 May 2021 01:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20C2B61458
	for <linux-cifs@archiver.kernel.org>; Sat,  8 May 2021 01:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhEHBOP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 May 2021 21:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhEHBOP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 May 2021 21:14:15 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422D4C061574
        for <linux-cifs@vger.kernel.org>; Fri,  7 May 2021 18:13:13 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id l13so10897244wru.11
        for <linux-cifs@vger.kernel.org>; Fri, 07 May 2021 18:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=jj44dQhNFytG5cBjQJQ75KKgUkU7SoLzGwkV07LX4VQ=;
        b=Htl2RGskie87o0poA7zfOZsL6yGcIh54PQo+pyU6Y8Cw0xTJs7tCdJgMjNp4tcsP4F
         JYVo2MjToRBHGb+IEMsXjn/rOO4XkknMrA1Uq/Ybzl8owWa8Uff96egMMsVtLwcZvgwW
         SmoUrT5WiNa3C3TANPybt10TPypXZ0R3SzfJgqh0R3oVjqAu56vnGKP//sH+QuSNdBc2
         mhmRtFOzZDqP2gWAnHAI7HFP8UzQHmJejW7m363OjHydyaYbTXmQjEvW8fQ6kUDRbEAm
         0P6Z5rfIHmnGf2lSV3ea5vpec6ym70PN3loupIDxty886bYnuKVDM5Nr6HNZvWvE7vL+
         pbSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=jj44dQhNFytG5cBjQJQ75KKgUkU7SoLzGwkV07LX4VQ=;
        b=PNFiXXExbvnuknwxdx2tDDgqKxN93tYa0XklOB8yEDdwqBzfC3KFDMu47mehw8yVZe
         J6FrLKN7Ns6gySeMHNQngeqhXbfx1QFeqevKdugs9Idq3VwsymmaaTJca1Ns6sozbX4j
         fP5aVgIiZVTqlHrh0GYAiUFWOYmWokca4BzkJg/Wt+RvPEZEVSk5ggsUQ8U8DyeOAywO
         VnnWPifOgxx1PPFwczWm3SszQHjPxUMz3xr6gexXNWYMJ0fa3Md2N4WCMcTUiIklOx52
         VFb2J6+WllP0WidfHUD4OBbflfCMntPo0mFjjCrwrYO3nNnicvysBQgJmxsSTJjDd69j
         MhGg==
X-Gm-Message-State: AOAM530QgWOOkZ1UAhqrzrc3bwhuJEMLTqpX9WFuTwIVror/5pM0V64r
        +q+L7DWKsanTtHGOoXd5cMFUJSRU8UbK3xi3lUk=
X-Google-Smtp-Source: ABdhPJxeosW9pm0pPCHmAlk2wjzfGL42NyJHa6vMlb9bqoIV/a343bcAid7cOAcZki5RP+Wrc91ZJu0SzH+N6iekKMk=
X-Received: by 2002:adf:dd4f:: with SMTP id u15mr16568694wrm.308.1620436391863;
 Fri, 07 May 2021 18:13:11 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 7 May 2021 20:13:01 -0500
Message-ID: <CAH2r5mu3m6FWWqrfOeQugXWGZOPiEE+Xgk8wc0rn8OgLRVPSWQ@mail.gmail.com>
Subject: [PATCH][SMB3] 3 small multichannel client patches
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000084d14305c1c73f71"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000084d14305c1c73f71
Content-Type: text/plain; charset="UTF-8"

1) we were not setting CAP_MULTICHANNEL on negotiate request
2) we were ignoring whether the server set CAP_NEGOTIATE in the response
3) we were silently ignoring multichannel when "max_channels" was > 1
but the user forgot to include "multichannel" in mount line.



-- 
Thanks,

Steve

--00000000000084d14305c1c73f71
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-smb3-if-max_channels-set-to-more-than-one-channel-re.patch"
Content-Disposition: attachment; 
	filename="0002-smb3-if-max_channels-set-to-more-than-one-channel-re.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kof1z5kf1>
X-Attachment-Id: f_kof1z5kf1

RnJvbSAxNmZjZjk0MjJkNzBjYjI4MDU2NTE4YjMwYzM3N2ZlODhhN2FkN2I5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgNyBNYXkgMjAyMSAxOTozMzo1MSAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggMi80
XSBzbWIzOiBpZiBtYXhfY2hhbm5lbHMgc2V0IHRvIG1vcmUgdGhhbiBvbmUgY2hhbm5lbAogcmVx
dWVzdCBtdWx0aWNoYW5uZWwKCk1vdW50aW5nIHdpdGggIm11bHRpY2hhbm5lbCIgaXMgb2J2aW91
c2x5IGltcGxpZWQgaWYgdXNlciByZXF1ZXN0ZWQKbW9yZSB0aGFuIG9uZSBjaGFubmVsIG9uIG1v
dW50IChpZSBtb3VudCBwYXJtIG1heF9jaGFubmVscz4xKS4KQ3VycmVudGx5IGJvdGggaGF2ZSB0
byBiZSBzcGVjaWZpZWQuIEZpeCB0aGF0IHNvIHRoYXQgaWYgbWF4X2NoYW5uZWxzCmlzIGdyZWF0
ZXIgdGhhbiAxIG9uIG1vdW50LCBlbmFibGUgbXVsdGljaGFubmVsIHJhdGhlciB0aGFuIHNpbGVu
dGx5CmZhbGxpbmcgYmFjayB0byBub24tbXVsdGljaGFubmVsLgoKU2lnbmVkLW9mZi1ieTogU3Rl
dmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvZnNfY29udGV4
dC5jIHwgMyArKysKIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQg
YS9mcy9jaWZzL2ZzX2NvbnRleHQuYyBiL2ZzL2NpZnMvZnNfY29udGV4dC5jCmluZGV4IDNiY2Y4
ODFjM2FlOS4uOGY3YWY2ZmNkYzc2IDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZzX2NvbnRleHQuYwor
KysgYi9mcy9jaWZzL2ZzX2NvbnRleHQuYwpAQCAtMTAyMSw2ICsxMDIxLDkgQEAgc3RhdGljIGlu
dCBzbWIzX2ZzX2NvbnRleHRfcGFyc2VfcGFyYW0oc3RydWN0IGZzX2NvbnRleHQgKmZjLAogCQkJ
Z290byBjaWZzX3BhcnNlX21vdW50X2VycjsKIAkJfQogCQljdHgtPm1heF9jaGFubmVscyA9IHJl
c3VsdC51aW50XzMyOworCQkvKiBJZiBtb3JlIHRoYW4gb25lIGNoYW5uZWwgcmVxdWVzdGVkIC4u
LiB0aGV5IHdhbnQgbXVsdGljaGFuICovCisJCWlmICgoY3R4LT5tdWx0aWNoYW5uZWwgPT0gZmFs
c2UpICYmIChyZXN1bHQudWludF8zMiA+IDEpKQorCQkJY3R4LT5tdWx0aWNoYW5uZWwgPSB0cnVl
OwogCQlicmVhazsKIAljYXNlIE9wdF9oYW5kbGV0aW1lb3V0OgogCQljdHgtPmhhbmRsZV90aW1l
b3V0ID0gcmVzdWx0LnVpbnRfMzI7Ci0tIAoyLjI3LjAKCg==
--00000000000084d14305c1c73f71
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0003-smb3-do-not-attempt-multichannel-to-server-which-doe.patch"
Content-Disposition: attachment; 
	filename="0003-smb3-do-not-attempt-multichannel-to-server-which-doe.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kof1z5kj2>
X-Attachment-Id: f_kof1z5kj2

RnJvbSA5OTg0ODQzYzdjYjViZTQ5OGMzZmVhNTBlOWZhMDE2ZGM0NDQyNGVmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgNyBNYXkgMjAyMSAyMDowMDo0MSAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggMy80
XSBzbWIzOiBkbyBub3QgYXR0ZW1wdCBtdWx0aWNoYW5uZWwgdG8gc2VydmVyIHdoaWNoIGRvZXMK
IG5vdCBzdXBwb3J0IGl0CgpXZSB3ZXJlIGlnbm9yaW5nIENBUF9NVUxUSV9DSEFOTkVMIGluIHRo
ZSBzZXJ2ZXIgcmVzcG9uc2UgLSBpZiB0aGUKc2VydmVyIGRvZXNuJ3Qgc3VwcG9ydCBtdWx0aWNo
YW5uZWwgd2Ugc2hvdWxkIG5vdCBiZSBhdHRlbXB0aW5nIGl0LgoKU2VlIE1TLVNNQjIgc2VjdGlv
biAzLjIuNS4yCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29m
dC5jb20+Ci0tLQogZnMvY2lmcy9zZXNzLmMgfCA2ICsrKysrKwogMSBmaWxlIGNoYW5nZWQsIDYg
aW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc2Vzcy5jIGIvZnMvY2lmcy9zZXNz
LmMKaW5kZXggNjNkNTE3YjlmMmZmLi5hMzkxY2EzMTY2ZjMgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMv
c2Vzcy5jCisrKyBiL2ZzL2NpZnMvc2Vzcy5jCkBAIC05Nyw2ICs5NywxMiBAQCBpbnQgY2lmc190
cnlfYWRkaW5nX2NoYW5uZWxzKHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IsIHN0cnVjdCBj
aWZzX3NlcyAqc2VzKQogCQlyZXR1cm4gMDsKIAl9CiAKKwlpZiAoKHNlcy0+c2VydmVyLT5jYXBh
YmlsaXRpZXMgJiBTTUIyX0dMT0JBTF9DQVBfTVVMVElfQ0hBTk5FTCkgPT0gZmFsc2UpIHsKKwkJ
Y2lmc19kYmcoVkZTLCAic2VydmVyIGRvZXMgbm90IHN1cHBvcnQgQ0FQX01VTFRJX0NIQU5ORUws
IG11bHRpY2hhbm5lbCBkaXNhYmxlZFxuIik7CisJCXNlcy0+Y2hhbl9tYXggPSAxOworCQlyZXR1
cm4gMDsKKwl9CisKIAkvKgogCSAqIE1ha2UgYSBjb3B5IG9mIHRoZSBpZmFjZSBsaXN0IGF0IHRo
ZSB0aW1lIGFuZCB1c2UgdGhhdAogCSAqIGluc3RlYWQgc28gYXMgdG8gbm90IGhvbGQgdGhlIGlm
YWNlIHNwaW5sb2NrIGZvciBvcGVuaW5nCi0tIAoyLjI3LjAKCg==
--00000000000084d14305c1c73f71
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-when-mounting-with-multichannel-include-it-in-r.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-when-mounting-with-multichannel-include-it-in-r.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kof1z5k40>
X-Attachment-Id: f_kof1z5k40

RnJvbSBhMmJkZDVjZWI3MDkwZWE0ZjNlZTA5MWRhMjQxOGYyM2QyNzBiMzkxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgNyBNYXkgMjAyMSAxODoyNDoxMSAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggMS80
XSBzbWIzOiB3aGVuIG1vdW50aW5nIHdpdGggbXVsdGljaGFubmVsIGluY2x1ZGUgaXQgaW4KIHJl
cXVlc3RlZCBjYXBhYmlsaXRpZXMKCkluIHRoZSBTTUIzL1NNQjMuMS4xIG5lZ290aWF0ZSBwcm90
b2NvbCByZXF1ZXN0LCB3ZSBhcmUgc3VwcG9zZWQgdG8KYWR2ZXJ0aXNlIENBUF9NVUxUSUNIQU5O
RUwgY2FwYWJpbGl0eSB3aGVuIGVzdGFibGlzaGluZyBtdWx0aXBsZQpjaGFubmVscyBoYXMgYmVl
biByZXF1ZXN0ZWQgYnkgdGhlIHVzZXIgZG9pbmcgdGhlIG1vdW50LiBTZWUgTVMtU01CMgpzZWN0
aW9ucyAyLjIuMyBhbmQgMy4yLjUuMgoKV2l0aG91dCBzZXR0aW5nIGl0IHRoZXJlIGlzIHNvbWUg
cmlzayB0aGF0IG11bHRpY2hhbm5lbCBjb3VsZCBmYWlsCmlmIHRoZSBzZXJ2ZXIgaW50ZXJwcmV0
ZWQgdGhlIGZpZWxkIHN0cmljdGx5LgoKQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPiAjIHY1
LjgrClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4K
LS0tCiBmcy9jaWZzL3NtYjJwZHUuYyB8IDUgKysrKysKIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2Vy
dGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuYyBiL2ZzL2NpZnMvc21iMnBk
dS5jCmluZGV4IGUzNmMyYTg2Nzc4My4uYThiZjQzMTg0NzczIDEwMDY0NAotLS0gYS9mcy9jaWZz
L3NtYjJwZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUuYwpAQCAtODQxLDYgKzg0MSw4IEBAIFNN
QjJfbmVnb3RpYXRlKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3NlcyAqc2Vz
KQogCQlyZXEtPlNlY3VyaXR5TW9kZSA9IDA7CiAKIAlyZXEtPkNhcGFiaWxpdGllcyA9IGNwdV90
b19sZTMyKHNlcnZlci0+dmFscy0+cmVxX2NhcGFiaWxpdGllcyk7CisJaWYgKHNlcy0+Y2hhbl9t
YXggPiAxKQorCQlyZXEtPkNhcGFiaWxpdGllcyB8PSBjcHVfdG9fbGUzMihTTUIyX0dMT0JBTF9D
QVBfTVVMVElfQ0hBTk5FTCk7CiAKIAkvKiBDbGllbnRHVUlEIG11c3QgYmUgemVybyBmb3IgU01C
Mi4wMiBkaWFsZWN0ICovCiAJaWYgKHNlcnZlci0+dmFscy0+cHJvdG9jb2xfaWQgPT0gU01CMjBf
UFJPVF9JRCkKQEAgLTEwMzIsNiArMTAzNCw5IEBAIGludCBzbWIzX3ZhbGlkYXRlX25lZ290aWF0
ZShjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uKQogCiAJcG5l
Z19pbmJ1Zi0+Q2FwYWJpbGl0aWVzID0KIAkJCWNwdV90b19sZTMyKHNlcnZlci0+dmFscy0+cmVx
X2NhcGFiaWxpdGllcyk7CisJaWYgKHRjb24tPnNlcy0+Y2hhbl9tYXggPiAxKQorCQlwbmVnX2lu
YnVmLT5DYXBhYmlsaXRpZXMgfD0gY3B1X3RvX2xlMzIoU01CMl9HTE9CQUxfQ0FQX01VTFRJX0NI
QU5ORUwpOworCiAJbWVtY3B5KHBuZWdfaW5idWYtPkd1aWQsIHNlcnZlci0+Y2xpZW50X2d1aWQs
CiAJCQkJCVNNQjJfQ0xJRU5UX0dVSURfU0laRSk7CiAKLS0gCjIuMjcuMAoK
--00000000000084d14305c1c73f71--
