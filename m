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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D7DAC47082
	for <linux-cifs@archiver.kernel.org>; Sat,  5 Jun 2021 20:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B2BF60FF2
	for <linux-cifs@archiver.kernel.org>; Sat,  5 Jun 2021 20:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhFEUik (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 5 Jun 2021 16:38:40 -0400
Received: from mail-lj1-f178.google.com ([209.85.208.178]:35724 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhFEUik (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 5 Jun 2021 16:38:40 -0400
Received: by mail-lj1-f178.google.com with SMTP id n24so2095757lji.2
        for <linux-cifs@vger.kernel.org>; Sat, 05 Jun 2021 13:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=WxJIhnV1CmW2pUXfbmK184VKomiizW310TnGgF5D+7U=;
        b=LB8XgFCw9MsTg6BCMpGnNukGTte4qxMnCJ7PJ98XEuAtFbsoFb9CHQD0nfCsAabgUD
         yN/eznX1SDndiJ2E4/STc3UG3fth/VlVVqSqood8upKrZkH1FWp+GXgtG+tXRFIwKm7G
         KaqPD3Ly+d5bg16/yt78vxiObhD3DPpwS92ARvpIVlhmeLAgiSNWPK6zS5JUzndejytc
         ZrHqf9bBQMND5PPcv+A6Iydo2o3e9B9iVqRty9I09v5/fyKP3XZ+B/TgcRGG5Ywfv28O
         RN0GxSnqNNKkoW9grchA8odYieRm5zQ03hzAJud3YDQ12fytgwJA3JzrXRm3NUj3P2GA
         0AHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=WxJIhnV1CmW2pUXfbmK184VKomiizW310TnGgF5D+7U=;
        b=pO2fxu6O8oBE+E308BQS/zqQwTnMx6kEmWTDYKYomcMx9yiKz/saIpSnSmQan25Zn0
         SCfs2OZNBEZqzSQPn9YwteUU8jQ0nNVCRd0n6+GybyBxiuqSUJJcahmNS257Y9ChbLdg
         9zJR2vfwHCzV02+9BKk1b9hw2iJPOn6yQOPL7fhfL8qKhA/zX5/b67ic6ierEcGV81s0
         sYeS1lPSOJEoa5gZQfQYlatfIduTRwWKPTVCeGl7oEZ9PXqIiOwimCvxGWmIAHp9FCrW
         skkqFeQu1zai6HQOEYp1xhQiF0iBRbK7lIXCTbf83Msrll11tuENnQmFY8rkWfuEIQkF
         wc2A==
X-Gm-Message-State: AOAM533O+FvwdxjTyk+uO/WsRQH9AboC1gKK022dqZwmJ5wCvGu42WX0
        EuyBQw+2h0kRJTYrxbdGOy5/n1gnLu3fYXIe8B1pxMm4i10=
X-Google-Smtp-Source: ABdhPJz0Oc8V4AgpNYkA4/6I+oHLcFCIrfla92a2zSlZ+kJaLtmUKsY3DaBPT138laWTIPjp8qNdSvbGSw7VUfwO9+U=
X-Received: by 2002:a2e:7819:: with SMTP id t25mr8507989ljc.406.1622925350965;
 Sat, 05 Jun 2021 13:35:50 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 5 Jun 2021 15:35:40 -0500
Message-ID: <CAH2r5msw+NW758zrjaqzUQ3unA5pbNxpu3b6quAg0gndn1_BXQ@mail.gmail.com>
Subject: [PATCH][CIFS] Remove duplicated prototype
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000000aafb705c40ac173"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000000aafb705c40ac173
Content-Type: text/plain; charset="UTF-8"

trivial patch merged into cifs-2.6.git for-next

-- 
Thanks,

Steve

--0000000000000aafb705c40ac173
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-remove-duplicated-prototype.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-remove-duplicated-prototype.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kpk7u3er0>
X-Attachment-Id: f_kpk7u3er0

RnJvbSA0MzFiOWMxNThjYjFlMWVkOTA2ODcxZjgyZmVmMDljMGFmNzI5OWRiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgNSBKdW4gMjAyMSAxNTozMzowMCAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIGNp
ZnM6IHJlbW92ZSBkdXBsaWNhdGVkIHByb3RvdHlwZQoKc21iMl9maW5kX3NtYl9zZXMgd2FzIGRl
ZmluZWQgdHdpY2UgaW4gc21iMnByb3RvLmgKClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8
c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL3NtYjJwcm90by5oIHwgMiAtLQog
MSBmaWxlIGNoYW5nZWQsIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIy
cHJvdG8uaCBiL2ZzL2NpZnMvc21iMnByb3RvLmgKaW5kZXggYTVmODdiMDJjZmFmLi40MTUyMDc3
ZTNjMDcgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnByb3RvLmgKKysrIGIvZnMvY2lmcy9zbWIy
cHJvdG8uaApAQCAtNjQsOCArNjQsNiBAQCBleHRlcm4gdm9pZCBzbWIyX2VjaG9fcmVxdWVzdChz
dHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspOwogZXh0ZXJuIF9fbGUzMiBzbWIyX2dldF9sZWFzZV9z
dGF0ZShzdHJ1Y3QgY2lmc0lub2RlSW5mbyAqY2lub2RlKTsKIGV4dGVybiBib29sIHNtYjJfaXNf
dmFsaWRfb3Bsb2NrX2JyZWFrKGNoYXIgKmJ1ZmZlciwKIAkJCQkgICAgICAgc3RydWN0IFRDUF9T
ZXJ2ZXJfSW5mbyAqc3J2KTsKLWV4dGVybiBzdHJ1Y3QgY2lmc19zZXMgKnNtYjJfZmluZF9zbWJf
c2VzKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwKLQkJCQkJICBfX3U2NCBzZXNfaWQp
OwogZXh0ZXJuIGludCBzbWIzX2hhbmRsZV9yZWFkX2RhdGEoc3RydWN0IFRDUF9TZXJ2ZXJfSW5m
byAqc2VydmVyLAogCQkJCSBzdHJ1Y3QgbWlkX3FfZW50cnkgKm1pZCk7CiAKLS0gCjIuMzAuMgoK
--0000000000000aafb705c40ac173--
