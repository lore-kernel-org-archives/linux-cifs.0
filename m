Return-Path: <SRS0=jgI2=DY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C154C433DF
	for <linux-cifs@archiver.kernel.org>; Sat, 17 Oct 2020 09:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB286206DD
	for <linux-cifs@archiver.kernel.org>; Sat, 17 Oct 2020 09:03:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oNAeAZ/0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411724AbgJQJD6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 17 Oct 2020 05:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408830AbgJQJD5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 17 Oct 2020 05:03:57 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCDDC061755
        for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2020 02:03:57 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id i2so5316163ljg.4
        for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2020 02:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=1644VA1in5OCiyTa4ZQ9eoTWA69oPpYauzaK3e8eaBY=;
        b=oNAeAZ/0JkpHve+/+j9KmYV7WYZ0Q0FUgsNczgUrb+PCwoA6P+B4ECphfjfjfuf0ov
         C/LzikQVh1bh6WR/o3DcKO/6UtMksOnnxGFiC7ei/FjMhFSUEY3IPZK2hJNAd39ssEwF
         LbhtrWWFESrWu8JiWb0vzoRqqbOmU+AJgAIoNgf8dCBsmiPcRzaCm/h8Wv1fN8oB0eGf
         eu3S72CZQjA4HS3HEoaRJ/2pKfaEZiDh+C/mily5vrd2I73yybPpVF1e12+7Esjq3iAD
         YpivPSU3YGw2jXNlGRHKRkOySnUnwczqXdZB7ds6qOUVBYmzqI50QtAYJDMvabvJX7LQ
         GwPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=1644VA1in5OCiyTa4ZQ9eoTWA69oPpYauzaK3e8eaBY=;
        b=lJSo1CeKpMfIrZhiNdcxl0ywd7cZd+XHCwwUSkub3+2Pmojij77Wo8LtMGDd0zMGmr
         FSewjb1swngn9CLTTWcsMzwdL44+J4Ol9z1yq4orjS8RPfOltSNT6OYkAgR1Ns2SOcbz
         RyCWm6OZderem6cyoxqJ7wB56NBnE7IFze0Q7LpVwS+CP1WOgeyr1naVDd5InL/tlAoL
         RTW0tzXS0FzIo7KgDjreQfzyrCF5EWeCd0x2O6JV18xMRWSAh+FMTCvu13l0nsL4ir5u
         fx4YVAam+le0cN813MHH23MWIYH+B8OOBhA55hhNfEEBzPnUrfR3hldXUEoGK/kaYboW
         kxFw==
X-Gm-Message-State: AOAM533h6JXaiDQeBjV5jM8ZXGdM67NOzTrRZ08OxzfyG8MMQ6+xNztr
        Si8cgKyGmd4UnDDbFihVFDME/wMItI6AD66nfy+NaGWw5qurCw==
X-Google-Smtp-Source: ABdhPJyJwg4vHgeJIP2EQ6jUcrL/olzDbIn99dvz67q2n67VS0/OGNmDCg2tXLA7PDWW9M07XvTFfsyoCR6T5NX2Qtk=
X-Received: by 2002:a2e:82cf:: with SMTP id n15mr2876594ljh.394.1602925435415;
 Sat, 17 Oct 2020 02:03:55 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 17 Oct 2020 04:03:44 -0500
Message-ID: <CAH2r5mv_0rLQF=npjc4CVJBDhsc8Eu_sJtY6xUDbBXs7aYhSzA@mail.gmail.com>
Subject: [PATCH][SMB3.1.1] do not fail if no encryption required when server
 doesn't support encryption
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000002e09ee05b1da299b"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000002e09ee05b1da299b
Content-Type: text/plain; charset="UTF-8"

    There are cases where the server can return a cipher type of 0 and
    it not be an error. For example, if server only supported AES256_CCM
    (very unlikely) or server supported no encryption types or
    had all disabled. In those cases encryption would not be supported,
    but that can be ok if the client did not require encryption on mount.

    In the case in which mount requested encryption ("seal" on mount)
    then checks later on during tree connection will return the proper
    rc, but if seal was not requested by client, since server is allowed
    to return 0 to indicate no supported cipher, we should not fail mount.

    Reported-by: Pavel Shilovsky <pshilov@microsoft.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>


-- 
Thanks,

Steve

--0000000000002e09ee05b1da299b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3.1.1-do-not-fail-if-no-encryption-required-but-s.patch"
Content-Disposition: attachment; 
	filename="0001-smb3.1.1-do-not-fail-if-no-encryption-required-but-s.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kgdger7o0>
X-Attachment-Id: f_kgdger7o0

RnJvbSBjNmRiNDBjYzFhNDY3MzBhNzhkYzNlNzlkMDc5MWUxMDc1MmQ2ODUzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMTcgT2N0IDIwMjAgMDM6NTQ6MjcgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzLjEuMTogZG8gbm90IGZhaWwgaWYgbm8gZW5jcnlwdGlvbiByZXF1aXJlZCBidXQgc2VydmVy
CiBkb2Vzbid0IHN1cHBvcnQgaXQKClRoZXJlIGFyZSBjYXNlcyB3aGVyZSB0aGUgc2VydmVyIGNh
biByZXR1cm4gYSBjaXBoZXIgdHlwZSBvZiAwIGFuZAppdCBub3QgYmUgYW4gZXJyb3IuIEZvciBl
eGFtcGxlLCBpZiBzZXJ2ZXIgb25seSBzdXBwb3J0ZWQgQUVTMjU2X0NDTQoodmVyeSB1bmxpa2Vs
eSkgb3Igc2VydmVyIHN1cHBvcnRlZCBubyBlbmNyeXB0aW9uIHR5cGVzIG9yCmhhZCBhbGwgZGlz
YWJsZWQuIEluIHRob3NlIGNhc2VzIGVuY3J5cHRpb24gd291bGQgbm90IGJlIHN1cHBvcnRlZCwK
YnV0IHRoYXQgY2FuIGJlIG9rIGlmIHRoZSBjbGllbnQgZGlkIG5vdCByZXF1aXJlIGVuY3J5cHRp
b24gb24gbW91bnQuCgpJbiB0aGUgY2FzZSBpbiB3aGljaCBtb3VudCByZXF1ZXN0ZWQgZW5jcnlw
dGlvbiAoInNlYWwiIG9uIG1vdW50KQp0aGVuIGNoZWNrcyBsYXRlciBvbiBkdXJpbmcgdHJlZSBj
b25uZWN0aW9uIHdpbGwgcmV0dXJuIHRoZSBwcm9wZXIKcmMsIGJ1dCBpZiBzZWFsIHdhcyBub3Qg
cmVxdWVzdGVkIGJ5IGNsaWVudCwgc2luY2Ugc2VydmVyIGlzIGFsbG93ZWQKdG8gcmV0dXJuIDAg
dG8gaW5kaWNhdGUgbm8gc3VwcG9ydGVkIGNpcGhlciwgd2Ugc2hvdWxkIG5vdCBmYWlsIG1vdW50
LgoKUmVwb3J0ZWQtYnk6IFBhdmVsIFNoaWxvdnNreSA8cHNoaWxvdkBtaWNyb3NvZnQuY29tPgpT
aWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQog
ZnMvY2lmcy9zbWIycGR1LmMgfCAxNiArKysrKysrKysrKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwg
MTMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3Nt
YjJwZHUuYyBiL2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4IGQ1MDRiYzI5NjM0OS4uMDI1ZGI1ZThj
MTgzIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUu
YwpAQCAtNjE2LDkgKzYxNiwxOSBAQCBzdGF0aWMgaW50IGRlY29kZV9lbmNyeXB0X2N0eChzdHJ1
Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsCiAJCQlyZXR1cm4gLUVPUE5PVFNVUFA7CiAJCX0K
IAl9IGVsc2UgaWYgKGN0eHQtPkNpcGhlcnNbMF0gPT0gMCkgewotCQkvKiBlLmcuIGlmIHNlcnZl
ciBvbmx5IHN1cHBvcnRlZCBBRVMyNTZfQ0NNICh2ZXJ5IHVubGlrZWx5KSAqLwotCQljaWZzX2Ri
ZyhWRlMsICJTZXJ2ZXIgZG9lcyBub3Qgc3VwcG9ydCByZXF1ZXN0ZWQgZW5jcnlwdGlvbiB0eXBl
c1xuIik7Ci0JCXJldHVybiAtRU9QTk9UU1VQUDsKKwkJLyoKKwkJICogZS5nLiBpZiBzZXJ2ZXIg
b25seSBzdXBwb3J0ZWQgQUVTMjU2X0NDTSAodmVyeSB1bmxpa2VseSkKKwkJICogb3Igc2VydmVy
IHN1cHBvcnRlZCBubyBlbmNyeXB0aW9uIHR5cGVzIG9yIGhhZCBhbGwgZGlzYWJsZWQuCisJCSAq
IFNpbmNlIEdMT0JBTF9DQVBfRU5DUllQVElPTiB3aWxsIGJlIG5vdCBzZXQsIGluIHRoZSBjYXNl
CisJCSAqIGluIHdoaWNoIG1vdW50IHJlcXVlc3RlZCBlbmNyeXB0aW9uICgic2VhbCIpIGNoZWNr
cyBsYXRlcgorCQkgKiBvbiBkdXJpbmcgdHJlZSBjb25uZWN0aW9uIHdpbGwgcmV0dXJuIHByb3Bl
ciByYywgYnV0IGlmCisJCSAqIHNlYWwgbm90IHJlcXVlc3RlZCBieSBjbGllbnQsIHNpbmNlIHNl
cnZlciBpcyBhbGxvd2VkIHRvCisJCSAqIHJldHVybiAwIHRvIGluZGljYXRlIG5vIHN1cHBvcnRl
ZCBjaXBoZXIsIHdlIGNhbid0IGZhaWwgaGVyZQorCQkgKi8KKwkJc2VydmVyLT5jaXBoZXJfdHlw
ZSA9IDA7CisJCXNlcnZlci0+Y2FwYWJpbGl0aWVzICY9IH5TTUIyX0dMT0JBTF9DQVBfRU5DUllQ
VElPTjsKKwkJcHJfd2Fybl9vbmNlKCJTZXJ2ZXIgZG9lcyBub3Qgc3VwcG9ydCByZXF1ZXN0ZWQg
ZW5jcnlwdGlvbiB0eXBlc1xuIik7CisJCXJldHVybiAwOwogCX0gZWxzZSBpZiAoKGN0eHQtPkNp
cGhlcnNbMF0gIT0gU01CMl9FTkNSWVBUSU9OX0FFUzEyOF9DQ00pICYmCiAJCSAgIChjdHh0LT5D
aXBoZXJzWzBdICE9IFNNQjJfRU5DUllQVElPTl9BRVMxMjhfR0NNKSAmJgogCQkgICAoY3R4dC0+
Q2lwaGVyc1swXSAhPSBTTUIyX0VOQ1JZUFRJT05fQUVTMjU2X0dDTSkpIHsKLS0gCjIuMjUuMQoK
--0000000000002e09ee05b1da299b--
