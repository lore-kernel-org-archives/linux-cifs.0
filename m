Return-Path: <SRS0=5iq/=YC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746DAC4360C
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Oct 2019 01:27:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45DD820873
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Oct 2019 01:27:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rCOQ28GZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729839AbfJIB1M (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 8 Oct 2019 21:27:12 -0400
Received: from mail-io1-f49.google.com ([209.85.166.49]:37250 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729700AbfJIB1L (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 8 Oct 2019 21:27:11 -0400
Received: by mail-io1-f49.google.com with SMTP id b19so1328936iob.4
        for <linux-cifs@vger.kernel.org>; Tue, 08 Oct 2019 18:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=bktyE/8x8rNhvrR/aL8M7kb8XhCxohgh5hkcLj3s5OQ=;
        b=rCOQ28GZL9yrGICbLtqVdA+Tf1j9sW2IlRg2PoFAlSxq3djb80M/VmwjbxmenM2nEs
         flOLDO3i0HYLuWKqchoiuM2cTMtQGAlArtK5ZqnEUtkfnyin7oz4lXZUxSR7Et3JUjQc
         lGRYS1ZVTwTM2zyJDtYoKVolLuHFUHCoxdsMv5iQElXkxJ8u7mH1diIT0cyzP5L6nc+a
         AnhMer8rRV1a1nKqk0VISrvzd9ei9EUtcIusRHBfkQB3aibagxZ5t2zVAUlQ8KWxb8SQ
         K7y03iWddUkjaoKkx7IednSbfUFZRJmls14VHp4BgFaPpmcC+0mqUiZ0NpWDyuFhRgQI
         2wXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=bktyE/8x8rNhvrR/aL8M7kb8XhCxohgh5hkcLj3s5OQ=;
        b=Qj9+WzZJfJjnVwp4JsznEYjCCcGhiW6BPb59gbo4XObMTlQ/X+UHe8GPi1BZGOR7is
         /LYZQTvhMlrB3PjvjENarP4bIl9So5q44k3Lv5lgkjfFGkRe+8wGFEB+YKtje6TD7HEf
         9uXee/SRCozKueylqp1hPDpEB5rSbvlGqJLiSr6GUOpJLEbX5qgDCcy8MzPKYCa14jNw
         bnxLriWP1jgG7aeIzTjPeM42RG/IndlPPSlWyOzcZuTB5eXUD7Xd8KZGIucLmw9qkqyo
         VvpIzUXD8HFWDnS1gx2bKbJmDw2XfhVE9D6u3LIqVAWcdUl/sqSQowRuIzcV6pLUc71b
         zkXQ==
X-Gm-Message-State: APjAAAUVfobko3hIkmBGAmkdbg8UW/BMNA8pxZfhlM1i62i6QNwadn4p
        1/fndj/A7l3yTzq2kroULS3qEAfSB6vefPu1j8ll0w==
X-Google-Smtp-Source: APXvYqzH3enV5PgIH84irGVuEvYF3HRBJ4srhrF4x1wqfNtW9sXI9WtuKjSM1LNj4kldwL9Kc8mEcybt+JC0WSlH4aw=
X-Received: by 2002:a6b:5c0f:: with SMTP id z15mr1242233ioh.173.1570584430681;
 Tue, 08 Oct 2019 18:27:10 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 8 Oct 2019 18:26:59 -0700
Message-ID: <CAH2r5mtrUgvc+mr04oeq9wQcmxUOSM-6PwBzL7XQ_Q9Z5V-BUw@mail.gmail.com>
Subject: [PATCH] Fix regression in SMB3 time handling
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Jeff Layton <jlayton@poochiereds.net>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000001571c90594702f48"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000001571c90594702f48
Content-Type: text/plain; charset="UTF-8"

Fixes xfstest 258 which regressed due to a recent change to add min/max time



-- 
Thanks,

Steve

--0000000000001571c90594702f48
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-Fix-regression-in-time-handling.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-Fix-regression-in-time-handling.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k1ilcscl0>
X-Attachment-Id: f_k1ilcscl0

RnJvbSBmZjkzYWJhM2U2NzFiYmRlN2Q0NmE5YjZlNmFmMTEzNjE0MmUzMWU1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgOCBPY3QgMjAxOSAwMDoyNzoxNCAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggMS8z
XSBzbWIzOiBGaXggcmVncmVzc2lvbiBpbiB0aW1lIGhhbmRsaW5nCgpGaXhlczogY2I3YTY5ZTYw
NTkwICgiY2lmczogSW5pdGlhbGl6ZSBmaWxlc3lzdGVtIHRpbWVzdGFtcCByYW5nZXMiKQoKT25s
eSB2ZXJ5IG9sZCBzZXJ2ZXJzIChlLmcuIE9TLzIgYW5kIERPUykgZGlkIG5vdCBzdXBwb3J0CkRD
RSBUSU1FICgxMDAgbmFub3NlY29uZCBncmFudWxhcml0eSkuICBGaXggdGhlIGNoZWNrcyB1c2Vk
CnRvIHNldCBtaW5pbXVtIGFuZCBtYXhpbXVtIHRpbWVzLgoKQ0M6IERlZXBhIERpbmFtYW5pIDxk
ZWVwYS5rZXJuZWxAZ21haWwuY29tPgpBY2tlZC1ieTogSmVmZiBMYXl0b24gPGpsYXl0b25Aa2Vy
bmVsLm9yZz4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQu
Y29tPgpSZXZpZXdlZC1ieTogUGF2ZWwgU2hpbG92c2t5IDxwc2hpbG92QG1pY3Jvc29mdC5jb20+
Ci0tLQogZnMvY2lmcy9jaWZzZnMuYyB8IDI0ICsrKysrKysrKysrKysrKystLS0tLS0tLQogMSBm
aWxlIGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvZnMvY2lmcy9jaWZzZnMuYyBiL2ZzL2NpZnMvY2lmc2ZzLmMKaW5kZXggMmU5YzdmNDkzZjk5
Li40NTMzMGIzMmYxYmIgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2ZzLmMKKysrIGIvZnMvY2lm
cy9jaWZzZnMuYwpAQCAtMTY5LDE4ICsxNjksMjYgQEAgY2lmc19yZWFkX3N1cGVyKHN0cnVjdCBz
dXBlcl9ibG9jayAqc2IpCiAJZWxzZQogCQlzYi0+c19tYXhieXRlcyA9IE1BWF9OT05fTEZTOwog
Ci0JLyogQkIgRklYTUUgZml4IHRpbWVfZ3JhbiB0byBiZSBsYXJnZXIgZm9yIExBTk1BTiBzZXNz
aW9ucyAqLwotCXNiLT5zX3RpbWVfZ3JhbiA9IDEwMDsKLQotCWlmICh0Y29uLT51bml4X2V4dCkg
ewotCQl0cyA9IGNpZnNfTlR0aW1lVG9Vbml4KDApOworCS8qIFNvbWUgdmVyeSBvbGQgc2VydmVy
cyBsaWtlIERPUyBhbmQgT1MvMiB1c2VkIDIgc2Vjb25kIGdyYW51bGFyaXR5ICovCisJaWYgKCh0
Y29uLT5zZXMtPnNlcnZlci0+dmFscy0+cHJvdG9jb2xfaWQgPT0gU01CMTBfUFJPVF9JRCkgJiYK
KwkgICAgKCh0Y29uLT5zZXMtPmNhcGFiaWxpdGllcyAmCisJICAgICAgdGNvbi0+c2VzLT5zZXJ2
ZXItPnZhbHMtPmNhcF9udF9maW5kKSA9PSAwKSAmJgorCSAgICAhdGNvbi0+dW5peF9leHQpIHsK
KwkJc2ItPnNfdGltZV9ncmFuID0gMjAwMDAwMDAwMDsgLyogMiBzZWNvbmRzICovCisJCXRzID0g
Y252cnREb3NVbml4VG0oY3B1X3RvX2xlMTYoU01CX0RBVEVfTUlOKSwgMCwgMCk7CiAJCXNiLT5z
X3RpbWVfbWluID0gdHMudHZfc2VjOwotCQl0cyA9IGNpZnNfTlR0aW1lVG9Vbml4KGNwdV90b19s
ZTY0KFM2NF9NQVgpKTsKKwkJdHMgPSBjbnZydERvc1VuaXhUbShjcHVfdG9fbGUxNihTTUJfREFU
RV9NQVgpLAorCQkJCSAgICBjcHVfdG9fbGUxNihTTUJfVElNRV9NQVgpLCAwKTsKIAkJc2ItPnNf
dGltZV9tYXggPSB0cy50dl9zZWM7CiAJfSBlbHNlIHsKLQkJdHMgPSBjbnZydERvc1VuaXhUbShj
cHVfdG9fbGUxNihTTUJfREFURV9NSU4pLCAwLCAwKTsKKwkJLyoKKwkJICogQWxtb3N0IGV2ZXJ5
IHNlcnZlciwgaW5jbHVkaW5nIGFsbCBTTUIyKywgdXNlcyBEQ0UgVElNRQorCQkgKiBpZSAxMDAg
bmFub3NlY29uZCB1bml0cywgc2luY2UgMTYwMS4gIFNlZSBNUy1EVFlQIGFuZCBNUy1GU0NDCisJ
CSAqLworCQlzYi0+c190aW1lX2dyYW4gPSAxMDA7CisJCXRzID0gY2lmc19OVHRpbWVUb1VuaXgo
MCk7CiAJCXNiLT5zX3RpbWVfbWluID0gdHMudHZfc2VjOwotCQl0cyA9IGNudnJ0RG9zVW5peFRt
KGNwdV90b19sZTE2KFNNQl9EQVRFX01BWCksIGNwdV90b19sZTE2KFNNQl9USU1FX01BWCksIDAp
OworCQl0cyA9IGNpZnNfTlR0aW1lVG9Vbml4KGNwdV90b19sZTY0KFM2NF9NQVgpKTsKIAkJc2It
PnNfdGltZV9tYXggPSB0cy50dl9zZWM7CiAJfQogCi0tIAoyLjIwLjEKCg==
--0000000000001571c90594702f48--
