Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA2DC28D13
	for <linux-cifs@archiver.kernel.org>; Sat, 20 Aug 2022 00:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244575AbiHTAHD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Aug 2022 20:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244803AbiHTAGu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Aug 2022 20:06:50 -0400
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8159810A760
        for <linux-cifs@vger.kernel.org>; Fri, 19 Aug 2022 17:06:32 -0700 (PDT)
Received: by mail-vk1-xa2e.google.com with SMTP id bi51so2977134vkb.5
        for <linux-cifs@vger.kernel.org>; Fri, 19 Aug 2022 17:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=5DH/Br20uh0S0uM7a97XFHs3DEWj4p/xGq9YXiL8J/w=;
        b=Hq6c5TPGergSrPfdWctKxf9ri6268GT7w1WFXJPAjd0phB5HZahS7Xwjy+KmwrKluG
         Sx0GvaPC+obgrevOfk62g1fItkIn8+HqiDu4aeKLr4ZD8GnHuYwMr131zXAVyeemHeWs
         5iVorihRImCaL6/HUVk/SR179zbePssHg9CYcMLpLSvDQ7erm/CyWpJC+9XC42+nkz6T
         +WwmYfwhRTDNPM7EC1EqwJB9SQ1iS2Yjs5KJj5cuzUJ/jucdfh2zGfehdwa5SNFgi+At
         9v8q9Oo/jp2Sj4wqAXH9C8N9G3SNuIKoATcJnvoQ3q/tfkOL3CchrJHEkHAJa7A7pEcN
         94qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=5DH/Br20uh0S0uM7a97XFHs3DEWj4p/xGq9YXiL8J/w=;
        b=Yvx10JlpgFEy9qVi5TMhDl4sVclxd8zRmEbqMJhnmC1/8ZDUzgqH7Gv4U7AOCX6OkP
         tYlDh3omIgdmyLdgN4hm2vVTYsZrhPTBYXXwXFC05xTFwuzCmQcCgUPmNhJwEnnu/FkW
         CoVRCyzhVU/t7dJcAicNYjcgpTDSLpxO3xCrrpB1c62E6rOxKkUXZYKOzgqB8nmWX2gE
         rGJPSsHS5uFYfRb63yzx/3vLn738CKYuZBWYKq0LkSS8LhZSQIGz6kbXFIkLWMVC/wB2
         ISjTiKU2sbWYepJizsVdPqxC4U56u2OjZ8sdhbSKlHOjoICJK9J94WeEKVu5b/y+oI3Y
         2T3A==
X-Gm-Message-State: ACgBeo2ZnpeZhqg3I9v/iCUuXDcy8H4QhaFwKSzONw2qv7HlKViMSd6j
        bN5FXhKi2uE/Aws4DqY0va45ZabeObVpqwoWvozkAoAYSh7C2A==
X-Google-Smtp-Source: AA6agR4CZfYkayjHfI5c2xoi1NInue7drQBosTIiLsdCS16Uz9bExEEgtkr2j3Hb3wOOKN1irPHM03Ma99C3mSsnaGw=
X-Received: by 2002:a1f:5c42:0:b0:382:3eac:56f7 with SMTP id
 q63-20020a1f5c42000000b003823eac56f7mr4024297vkb.24.1660953991304; Fri, 19
 Aug 2022 17:06:31 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 19 Aug 2022 19:06:20 -0500
Message-ID: <CAH2r5mtVOKN-8ET1oYC0L+ihAWpmwFY3=Q=-KP+qwcaAb002_A@mail.gmail.com>
Subject: [PATCH][SMB3] fix temporary data corruption in collapse range
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000a4242805e6a0fce4"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000a4242805e6a0fce4
Content-Type: text/plain; charset="UTF-8"

collapse range doesn't discard the affected cached region
so can risk temporarily corrupting the file data. This
fixes xfstest generic/031

I also decided to merge a minor cleanup to this into the same patch
(avoiding rereading inode size repeatedly unnecessarily) to make it
clearer.

Cc: stable@vger.kernel.org
Fixes: 5476b5dd82c8b ("cifs: add support for FALLOC_FL_COLLAPSE_RANGE")
Reported-by: David Howells <dhowells@redhat.com>
Tested-by: David Howells <dhowells@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>

See attached:
-- 
Thanks,

Steve

--000000000000a4242805e6a0fce4
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-collapse-range-temporary-data-corruption.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-collapse-range-temporary-data-corruption.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l71541xh0>
X-Attachment-Id: f_l71541xh0

RnJvbSBiY2U3YWVlZDVlOTI2MzA5NzIwOWNmN2NmYjBjN2NlMWEyYWZjY2UxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMTkgQXVnIDIwMjIgMTg6NTc6MDUgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggY29sbGFwc2UgcmFuZ2UgdGVtcG9yYXJ5IGRhdGEgY29ycnVwdGlvbgoKY29sbGFw
c2UgcmFuZ2UgZG9lc24ndCBkaXNjYXJkIHRoZSBhZmZlY3RlZCBjYWNoZWQgcmVnaW9uCnNvIGNh
biByaXNrIHRlbXBvcmFyaWx5IGNvcnJ1cHRpbmcgdGhlIGZpbGUgZGF0YS4gVGhpcwpmaXhlcyB4
ZnN0ZXN0IGdlbmVyaWMvMDMxCgpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwpGaXhlczogNTQ3
NmI1ZGQ4MmM4YiAoImNpZnM6IGFkZCBzdXBwb3J0IGZvciBGQUxMT0NfRkxfQ09MTEFQU0VfUkFO
R0UiKQpSZXBvcnRlZC1ieTogRGF2aWQgSG93ZWxscyA8ZGhvd2VsbHNAcmVkaGF0LmNvbT4KVGVz
dGVkLWJ5OiBEYXZpZCBIb3dlbGxzIDxkaG93ZWxsc0ByZWRoYXQuY29tPgpSZXZpZXdlZC1ieTog
RGF2aWQgSG93ZWxscyA8ZGhvd2VsbHNAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUg
RnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21iMm9wcy5jIHwg
MTIgKysrKysrKy0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA1IGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMm9wcy5jIGIvZnMvY2lmcy9zbWIyb3Bz
LmMKaW5kZXggOTZmM2IwNTczNjA2Li5jZDlmYTk4NDUzOGEgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMv
c21iMm9wcy5jCisrKyBiL2ZzL2NpZnMvc21iMm9wcy5jCkBAIC0zNjc3LDI0ICszNjc3LDI1IEBA
IHN0YXRpYyBsb25nIHNtYjNfY29sbGFwc2VfcmFuZ2Uoc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVj
dCBjaWZzX3Rjb24gKnRjb24sCiAJc3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGUgPSBmaWxlLT5w
cml2YXRlX2RhdGE7CiAJc3RydWN0IGNpZnNJbm9kZUluZm8gKmNpZnNpOwogCV9fbGU2NCBlb2Y7
CisJbG9mZl90IG9sZF9lb2Y7CiAKIAl4aWQgPSBnZXRfeGlkKCk7CiAKIAlpbm9kZSA9IGRfaW5v
ZGUoY2ZpbGUtPmRlbnRyeSk7CiAJY2lmc2kgPSBDSUZTX0koaW5vZGUpOwotCi0JaWYgKG9mZiA+
PSBpX3NpemVfcmVhZChpbm9kZSkgfHwKLQkgICAgb2ZmICsgbGVuID49IGlfc2l6ZV9yZWFkKGlu
b2RlKSkgeworCW9sZF9lb2YgPSBpX3NpemVfcmVhZChpbm9kZSk7CisJaWYgKChvZmYgPj0gb2xk
X2VvZikgfHwKKwkgICAgb2ZmICsgbGVuID49IG9sZF9lb2YpIHsKIAkJcmMgPSAtRUlOVkFMOwog
CQlnb3RvIG91dDsKIAl9CiAKIAlyYyA9IHNtYjJfY29weWNodW5rX3JhbmdlKHhpZCwgY2ZpbGUs
IGNmaWxlLCBvZmYgKyBsZW4sCi0JCQkJICBpX3NpemVfcmVhZChpbm9kZSkgLSBvZmYgLSBsZW4s
IG9mZik7CisJCQkJICBvbGRfZW9mIC0gb2ZmIC0gbGVuLCBvZmYpOwogCWlmIChyYyA8IDApCiAJ
CWdvdG8gb3V0OwogCi0JZW9mID0gY3B1X3RvX2xlNjQoaV9zaXplX3JlYWQoaW5vZGUpIC0gbGVu
KTsKKwllb2YgPSBjcHVfdG9fbGU2NChvbGRfZW9mIC0gbGVuKTsKIAlyYyA9IFNNQjJfc2V0X2Vv
Zih4aWQsIHRjb24sIGNmaWxlLT5maWQucGVyc2lzdGVudF9maWQsCiAJCQkgIGNmaWxlLT5maWQu
dm9sYXRpbGVfZmlkLCBjZmlsZS0+cGlkLCAmZW9mKTsKIAlpZiAocmMgPCAwKQpAQCAtMzcwMiw2
ICszNzAzLDcgQEAgc3RhdGljIGxvbmcgc21iM19jb2xsYXBzZV9yYW5nZShzdHJ1Y3QgZmlsZSAq
ZmlsZSwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAogCXJjID0gMDsKIAorCXRydW5jYXRlX3Bh
Z2VjYWNoZV9yYW5nZShpbm9kZSwgb2ZmLCBvbGRfZW9mKTsKIAljaWZzaS0+c2VydmVyX2VvZiA9
IGlfc2l6ZV9yZWFkKGlub2RlKSAtIGxlbjsKIAl0cnVuY2F0ZV9zZXRzaXplKGlub2RlLCBjaWZz
aS0+c2VydmVyX2VvZik7CiAJZnNjYWNoZV9yZXNpemVfY29va2llKGNpZnNfaW5vZGVfY29va2ll
KGlub2RlKSwgY2lmc2ktPnNlcnZlcl9lb2YpOwotLSAKMi4zNC4xCgo=
--000000000000a4242805e6a0fce4--
