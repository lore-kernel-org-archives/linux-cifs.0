Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AE1CEB64D7
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Jun 2023 03:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjFTDmM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Jun 2023 23:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFTDmL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Jun 2023 23:42:11 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A575C6
        for <linux-cifs@vger.kernel.org>; Mon, 19 Jun 2023 20:42:10 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2b45b6adffbso54007891fa.3
        for <linux-cifs@vger.kernel.org>; Mon, 19 Jun 2023 20:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687232528; x=1689824528;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hFbkYkkrMNNIj4N+I29G2MMgLDIaZKEdSnmWCRzSWo0=;
        b=ZK7Kr7uP8pvDkzTYd4j2Z72nyj+0WL5lWS5cqdIG0g4M8KJM0YndoIQh/OaYcmEGrz
         h+G74qGI5I7upJU4ZSAjUJMhNqj6BLW6gbIUdVjwjgdKQNdG8Ex5ObHayKO/NCzuNI7G
         fngoioUmrZefGcKVgeLFhciYduDG6DocIM5es/Y+xjYL2nb9yymk4EQDrVIQVXG0lcdJ
         2Uf0EWn2EYmqdZ9gik2khPBPRNh7G6mwcHggXBLGdADiPsypeR4Uf4NQSfYEO3Xd1ysc
         sQ6oan2dEELPakjm3AczlBcA1N6K0grurAFb/FcTT4pD2ff0HAN3j0iK1XiGXVpfwf+S
         PfwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687232528; x=1689824528;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hFbkYkkrMNNIj4N+I29G2MMgLDIaZKEdSnmWCRzSWo0=;
        b=iY6ZbYIdz4Yu2LgVZpmU3wb0bP544nKwl70Rl5Z+z7zpaMdxqM9eJPKHDWRZM9FMTY
         T5+Ilj7kD4tmzeESoDxjWW+zq3Ff6Z5ThZS06F93draX6q94ivMdOrJuQY2CyWTtBvf0
         ODQRMyrbJHjW2d/Bl+9NODDaBlknCTIf5RD6C68OrBzyGLgzgeQ54nDCNrSQMekyOPaq
         xiGw9DKh2ifmi1apk3e7pDN0m/Oml53lcnO51j9pR3RYWiYEAg4h10z/eW0wU7PfRIpu
         g3Jv6isFkCTiMx+95nL6VaZsaaWUk/QJ+4875UzDUtGeAKIvpnpmP+yHcWifmuS/bQfz
         3bRQ==
X-Gm-Message-State: AC+VfDwJdLjX72jr3hnEuuLvi3/keNWpqgxlZ+5fybTz4W1pD03WP8CH
        oML8GVA+EuPt/4PwtJSCwQf4LflTf4LNw8pYJXVDwmuEmOI=
X-Google-Smtp-Source: ACHHUZ47LaP9OEcbLsRrAPhhj0j31yJe8lm0XjScN/L6sbQvclG021qSrrAdRgoYwFb5baC18TX7xtOY4QxxSU6rnAk=
X-Received: by 2002:a2e:2c0f:0:b0:2b4:765b:f6f0 with SMTP id
 s15-20020a2e2c0f000000b002b4765bf6f0mr3097600ljs.28.1687232527735; Mon, 19
 Jun 2023 20:42:07 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 19 Jun 2023 22:41:56 -0500
Message-ID: <CAH2r5mvuuCeQQKN+RRxoELjf9NOfLNOwgOjBbxdUKYiowsbY_w@mail.gmail.com>
Subject: [SMB CLIENT][PATCH] do not reserve too many oplock credits
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000007830d605fe876f64"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000007830d605fe876f64
Content-Type: text/plain; charset="UTF-8"

There were cases reported where servers will sometimes return more
credits than requested on oplock break responses, which can lead to
most of the credits being allocated for oplock breaks (instead of
for normal operations like read and write) if number of SMB3 requests
in flight always stays above 0 (the oplock and echo credits are
rebalanced when in flight requests goes down to zero).

If oplock credits gets unexpectedly large (e.g. ten is more than it
would ever be expected to be) and in flight requests are greater than
zero, then rebalance the oplock credits and regular credits (go
back to reserving just one oplock credit.

See attached

-- 
Thanks,

Steve

--0000000000007830d605fe876f64
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-do-not-reserve-too-many-oplock-credits.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-do-not-reserve-too-many-oplock-credits.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lj3qo8jy0>
X-Attachment-Id: f_lj3qo8jy0

RnJvbSBjNTBjYWUxNTkwM2ZjNzA0YzNkZjExNzAxODNjODUwNWNkMmViMGI5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMTkgSnVuIDIwMjMgMjI6MzI6MzggLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBkbyBub3QgcmVzZXJ2ZSB0b28gbWFueSBvcGxvY2sgY3JlZGl0cwoKVGhlcmUgd2VyZSBj
YXNlcyByZXBvcnRlZCB3aGVyZSBzZXJ2ZXJzIHdpbGwgc29tZXRpbWVzIHJldHVybiBtb3JlCmNy
ZWRpdHMgdGhhbiByZXF1ZXN0ZWQgb24gb3Bsb2NrIGJyZWFrIHJlc3BvbnNlcywgd2hpY2ggY2Fu
IGxlYWQgdG8KbW9zdCBvZiB0aGUgY3JlZGl0cyBiZWluZyBhbGxvY2F0ZWQgZm9yIG9wbG9jayBi
cmVha3MgKGluc3RlYWQgb2YKZm9yIG5vcm1hbCBvcGVyYXRpb25zIGxpa2UgcmVhZCBhbmQgd3Jp
dGUpIGlmIG51bWJlciBvZiBTTUIzIHJlcXVlc3RzCmluIGZsaWdodCBhbHdheXMgc3RheXMgYWJv
dmUgMCAodGhlIG9wbG9jayBhbmQgZWNobyBjcmVkaXRzIGFyZQpyZWJhbGFuY2VkIHdoZW4gaW4g
ZmxpZ2h0IHJlcXVlc3RzIGdvZXMgZG93biB0byB6ZXJvKS4KCklmIG9wbG9jayBjcmVkaXRzIGdl
dHMgdW5leHBlY3RlZGx5IGxhcmdlIChlLmcuIHRlbiBpcyBtb3JlIHRoYW4gaXQKd291bGQgZXZl
ciBiZSBleHBlY3RlZCB0byBiZSkgYW5kIGluIGZsaWdodCByZXF1ZXN0cyBhcmUgZ3JlYXRlciB0
aGFuCnplcm8sIHRoZW4gcmViYWxhbmNlIHRoZSBvcGxvY2sgY3JlZGl0cyBhbmQgcmVndWxhciBj
cmVkaXRzIChnbwpiYWNrIHRvIHJlc2VydmluZyBqdXN0IG9uZSBvcGxvY2sgY3JkaXQpLgoKU2ln
bmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZz
L3NtYi9jbGllbnQvc21iMm9wcy5jIHwgNiArKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L3NtYjJv
cHMuYyBiL2ZzL3NtYi9jbGllbnQvc21iMm9wcy5jCmluZGV4IGE4YmI5ZDAwZDMzYS4uMDI3ODBm
MTc1NTcxIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3NtYjJvcHMuYworKysgYi9mcy9zbWIv
Y2xpZW50L3NtYjJvcHMuYwpAQCAtMTA5LDcgKzEwOSwxMSBAQCBzbWIyX2FkZF9jcmVkaXRzKHN0
cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwKIAkJCXNlcnZlci0+Y3JlZGl0cy0tOwogCQkJ
c2VydmVyLT5vcGxvY2tfY3JlZGl0cysrOwogCQl9Ci0JfQorCX0gZWxzZSBpZiAoKHNlcnZlci0+
aW5fZmxpZ2h0ID4gMCkgJiYgKHNlcnZlci0+b3Bsb2NrX2NyZWRpdHMgPiAxMCkgJiYKKwkJICAg
KChvcHR5cGUgJiBDSUZTX09QX01BU0spID09IENJRlNfT0JSRUFLX09QKSkKKwkJLyogaWYgbm93
IGhhdmUgdG9vIG1hbnkgb3Bsb2NrIGNyZWRpdHMsIHJlYmFsYW5jZSBzbyBkb24ndCBzdGFydmUg
bm9ybWFsIG9wcyAqLworCQljaGFuZ2VfY29uZihzZXJ2ZXIpOworCiAJc2NyZWRpdHMgPSAqdmFs
OwogCWluX2ZsaWdodCA9IHNlcnZlci0+aW5fZmxpZ2h0OwogCXNwaW5fdW5sb2NrKCZzZXJ2ZXIt
PnJlcV9sb2NrKTsKLS0gCjIuMzQuMQoK
--0000000000007830d605fe876f64--
