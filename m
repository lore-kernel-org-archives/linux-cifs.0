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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF20C2B9F4
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Jun 2021 21:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 336A961057
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Jun 2021 21:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhFSVh4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 19 Jun 2021 17:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhFSVh4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 19 Jun 2021 17:37:56 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41E7C061574
        for <linux-cifs@vger.kernel.org>; Sat, 19 Jun 2021 14:35:44 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id s22so19243588ljg.5
        for <linux-cifs@vger.kernel.org>; Sat, 19 Jun 2021 14:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=ImIRAzwYqrT79fVChKRnWfuro2qCzI7z+mc/nfvKPAM=;
        b=psV/qo9HVmSkSTsuEdgzyLuvamHoR9hEYymE6Y3TghWxn+If5+pe0KAdkXISyUFMe1
         fVxb4OZPYmTQqWjEoDBk/bqX6PeAkQffPpj4pQF7MMqndUsNN+ESCXKX1ZLowXhKAmrz
         CrBz0z8jfQqSMU8A2SWz8+ZLXL51MueUFZSsUrW1PoiDQ34A7KO2FmPiHVjS03Htr3YA
         EGGr8+V5WdZYnfXiwzNf4yFReTKVyvkh4egcCPMJ8Q+Zh8g/LmO9fjOR0Zt54kOsq4EH
         LAsnh1lIloO5i6hvN00PwIQDafb+LGEJevqmWp45xFKH0sv9OUO34X22Sd7Lk5Zee02B
         d6ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=ImIRAzwYqrT79fVChKRnWfuro2qCzI7z+mc/nfvKPAM=;
        b=ZpYCRGzupGzbUsjsF3f0uCtqv2lSUZQjiV2YRh/wIUiR8/yqwQU3xLMqo0nD/acJym
         /uXH1lDIQDelawTOR7B8XeJ+wgQHVVlu60LNm8q5LiOBOr5jcVB9S2i9L3PuHlVzftqc
         eTTsSBHiQ3PgT0HFHpsTEug7O5T1WEpzQQwkZYwSYSSoHlpQA2Z1+fogX8ecy0XGOsIq
         4ukbE3e9m99uz55trJ3ZDA4TCV9PgYQAvz3Bbt1tOslVnbycJVn2oH+w7OanE+iY+ORv
         bR4lM8XdmrAYpsx078NGCz0IdQXC5Q7IYDsWVn3/XRW0eQDhDBs9NIdpL5moPa/FzlAy
         2qEQ==
X-Gm-Message-State: AOAM5321+2xLHNxukrhzoZTyobkMhIvCpUJh9sMSVbdoFh2KBNR7xnS2
        /1MNb8WR6cBmL8qUj3uc/1G6HGx1OUJJjahbukjI58eyXAI=
X-Google-Smtp-Source: ABdhPJwT2JKti6OuYAsokRa1hs7d+TIv0JFTUnkuiPOuprFDv8rUA8H1CFxnnweSJCBpUYUkN+55nNZc2OUgrr1pXUs=
X-Received: by 2002:a05:651c:1697:: with SMTP id bd23mr15006674ljb.148.1624138542779;
 Sat, 19 Jun 2021 14:35:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mug9H-J8PQnrBvSNaK3Sz3-aji8FwPdNEfANf_X_keDzw@mail.gmail.com>
In-Reply-To: <CAH2r5mug9H-J8PQnrBvSNaK3Sz3-aji8FwPdNEfANf_X_keDzw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 19 Jun 2021 16:35:31 -0500
Message-ID: <CAH2r5mt8s5qNZH9RnFaJjxDX9WuFMAVdsSHpN=fG5f-dbLpx6g@mail.gmail.com>
Subject: Re: [PATCH][SMB311] remove dead code for non-compounded SMB311 posix
 query info
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000e8a4e205c5253801"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e8a4e205c5253801
Content-Type: text/plain; charset="UTF-8"

Corrected typo and reattached


On Sat, Jun 19, 2021 at 4:28 PM Steve French <smfrench@gmail.com> wrote:
>
> Although we may need this in some cases in the future, remove the
> currently unused, non-compounded version of POSIX query info,
> SMB11_posix_query_info (instead smb311_posix_query_path_info is now
> called e.g. when revalidating dentries or retrieving info for getattr)
>
> Addresses-Coverity: 1495708 ("Resource leaks")
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--000000000000e8a4e205c5253801
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb311-remove-dead-code-for-non-compounded-posix-que.patch"
Content-Disposition: attachment; 
	filename="0001-smb311-remove-dead-code-for-non-compounded-posix-que.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kq4a57y00>
X-Attachment-Id: f_kq4a57y00

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
CisjaWYgMAorLyogY3VycmVudGx5IHVudXNlZCwgYXMgbm93IHdlIGFyZSBkb2luZyBjb21wb3Vu
ZGluZyBpbnN0ZWFkIChzZWUgc21iMzExX3Bvc2l4X3F1ZXJ5X3BhdGhfaW5mbykgKi8KIGludAog
U01CMzExX3Bvc2l4X3F1ZXJ5X2luZm8oY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNp
ZnNfdGNvbiAqdGNvbiwKIAkJdTY0IHBlcnNpc3RlbnRfZmlkLCB1NjQgdm9sYXRpbGVfZmlkLCBz
dHJ1Y3Qgc21iMzExX3Bvc2l4X3FpbmZvICpkYXRhLCB1MzIgKnBsZW4pCkBAIC0zNDk1LDcgKzM0
OTcsOSBAQCBTTUIzMTFfcG9zaXhfcXVlcnlfaW5mbyhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBz
dHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCXJldHVybiBxdWVyeV9pbmZvKHhpZCwgdGNvbiwgcGVy
c2lzdGVudF9maWQsIHZvbGF0aWxlX2ZpZCwKIAkJCSAgU01CX0ZJTkRfRklMRV9QT1NJWF9JTkZP
LCBTTUIyX09fSU5GT19GSUxFLCAwLAogCQkJICBvdXRwdXRfbGVuLCBzaXplb2Yoc3RydWN0IHNt
YjMxMV9wb3NpeF9xaW5mbyksICh2b2lkICoqKSZkYXRhLCBwbGVuKTsKKwkvKiBOb3RlIGNhbGxl
ciBtdXN0IGZyZWUgImRhdGEiIChwYXNzZWQgaW4gYWJvdmUpLiBJdCBtYXkgYmUgYWxsb2NhdGVk
IGluIHF1ZXJ5X2luZm8gY2FsbCAqLwogfQorI2VuZGlmCiAKIGludAogU01CMl9xdWVyeV9hY2wo
Y29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKLS0gCjIuMzAu
MgoK
--000000000000e8a4e205c5253801--
