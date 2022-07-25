Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C59C43334
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jul 2022 03:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiGYDxQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Jul 2022 23:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiGYDxO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Jul 2022 23:53:14 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EF8B875
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 20:53:13 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id c3so9541597vsc.6
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 20:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=vMX64v3lO6R78aE0hkfqjTyO6T5HJrTDFvQQiADpQ3I=;
        b=k9JMiBx4QCBMocH7XgwN53tmdvnU07zId8DvRT9kKprca9VYkFwF/iHvdqlB6wrHOy
         7uDsVTwoKO3B6mnKTDsO25wvx8yew0Z8IKpnhdgXqgggSI+FOQi6kQnkG7a9UWSBEVF2
         9iB15oVPLIMQxnMh21MIiK5bljIiYdcrJ3PjbmnVKPsiXiTm33gpiW53HV4Nea5Ympa+
         N3c6y4ekpcspeHph1Jbkf+bClu7f9ygnaGMWiDPfledorir/oelPoX/dkyO9m3tnQaUL
         wv2a3ibDKbugJEt1PjZ0dZicfW5rosdwzzGJxF6GJPxWfYneUlfUF3Zoll6xck1s5UfF
         7nlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=vMX64v3lO6R78aE0hkfqjTyO6T5HJrTDFvQQiADpQ3I=;
        b=uEyF3LITtuYlEgjmoFxYrvUrT8Ob7id/+V/MyQnqrjMczfHhX/mHSPjgUVGYlvZOvs
         l9npcirrC2Kl+81N9AF3Px0hm1BSkAEv+HML26fAQv12qKn+jLHQz6soV4xCShLEuA/T
         6fj63JyheVTMDYcCduhuVORbT9q8VedvuBbt6C3nas4F4iD5vqFCPzrGdofLIGjzc1rM
         SRiocujeU3dZ36Cml1XMTIOA6uHKrJj1iFsP5WYcA/vcfUiPlk2lurOwToayGxzbwGU7
         amcTBZBRwmcBRoS1r5r6YG0bOXd+TIbZW8aNp19eo8mmjc1Uj1ZjUMi3z8Kf3OT3zQhe
         Il/g==
X-Gm-Message-State: AJIora9ZCiXTYV8bLb+OMnQiykSJQPtn1AjbB49nhPEmcV1gY7Q7gznz
        H6d3hPodCEAMLc5MWUrKEFkdhuItkZHiQ2nME+Cts7TFKX4Stw==
X-Google-Smtp-Source: AGRyM1tRBdm3XpwbM8IFOms3Dhnc1gS5IWsJNyix0zjqWBqLe8O+e+sju66DMmvhMAPgiyLNtrC4cZ9jfcv6EnOh50Q=
X-Received: by 2002:a05:6102:c94:b0:357:c72d:b7b3 with SMTP id
 f20-20020a0561020c9400b00357c72db7b3mr2949678vst.17.1658721192234; Sun, 24
 Jul 2022 20:53:12 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 24 Jul 2022 22:53:01 -0500
Message-ID: <CAH2r5ms8B87Bm_-fSGmUn2okV9jMQvXAATx9+b2u_rE20yM1vg@mail.gmail.com>
Subject: [PATCH][CIFS] cleanup remaining distracting build warnings
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000071e6e605e4991f68"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000071e6e605e4991f68
Content-Type: text/plain; charset="UTF-8"

Removed remaining warnings related to externs.  See attached patch.
These warnings
although harmless could be distracting e.g.

 fs/cifs/cifsfs.c: note: in included file:
 fs/cifs/cifsglob.h:1968:24: warning: symbol 'sesInfoAllocCount' was
not declared. Should it be static?

-- 
Thanks,

Steve

--00000000000071e6e605e4991f68
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-remove-remaining-build-warnings.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-remove-remaining-build-warnings.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l607qkvm0>
X-Attachment-Id: f_l607qkvm0

RnJvbSA2OTE4MWZkZmFmYWRiM2ZlYTdmYWQ0ZmNhNjNiYjBkYzY2OTBjZWZlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgMjQgSnVsIDIwMjIgMjI6NDc6NTkgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiByZW1vdmUgcmVtYWluaW5nIGJ1aWxkIHdhcm5pbmdzCgpSZW1vdmVkIHJlbWFpbmluZyB3
YXJuaW5ncyByZWxhdGVkIHRvIGV4dGVybnMuICBUaGVzZSB3YXJuaW5ncwphbHRob3VnaCBoYXJt
bGVzcyBjb3VsZCBiZSBkaXN0cmFjdGluZyBlLmcuCgogZnMvY2lmcy9jaWZzZnMuYzogbm90ZTog
aW4gaW5jbHVkZWQgZmlsZToKIGZzL2NpZnMvY2lmc2dsb2IuaDoxOTY4OjI0OiB3YXJuaW5nOiBz
eW1ib2wgJ3Nlc0luZm9BbGxvY0NvdW50JyB3YXMgbm90IGRlY2xhcmVkLiBTaG91bGQgaXQgYmUg
c3RhdGljPwoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQu
Y29tPgotLS0KIGZzL2NpZnMvY2lmc2ZzLmMgICB8IDE5ICsrKysrKysrKysrKysrKysrKysKIGZz
L2NpZnMvY2lmc2dsb2IuaCB8IDIyICsrKysrKysrKysrLS0tLS0tLS0tLS0KIDIgZmlsZXMgY2hh
bmdlZCwgMzAgaW5zZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMv
Y2lmcy9jaWZzZnMuYyBiL2ZzL2NpZnMvY2lmc2ZzLmMKaW5kZXggZjkwOWQ5ZTlmYWFhLi5lYmE4
NzlmODZlNGQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2ZzLmMKKysrIGIvZnMvY2lmcy9jaWZz
ZnMuYwpAQCAtNjgsNiArNjgsMjUgQEAgYm9vbCBlbmFibGVfbmVnb3RpYXRlX3NpZ25pbmc7IC8q
IGZhbHNlIGJ5IGRlZmF1bHQgKi8KIHVuc2lnbmVkIGludCBnbG9iYWxfc2VjZmxhZ3MgPSBDSUZT
U0VDX0RFRjsKIC8qIHVuc2lnbmVkIGludCBudGxtdjJfc3VwcG9ydCA9IDA7ICovCiB1bnNpZ25l
ZCBpbnQgc2lnbl9DSUZTX1BEVXMgPSAxOworCisvKgorICogR2xvYmFsIHRyYW5zYWN0aW9uIGlk
IChYSUQpIGluZm9ybWF0aW9uCisgKi8KK3Vuc2lnbmVkIGludCBHbG9iYWxDdXJyZW50WGlkOwkv
KiBwcm90ZWN0ZWQgYnkgR2xvYmFsTWlkX1NlbSAqLwordW5zaWduZWQgaW50IEdsb2JhbFRvdGFs
QWN0aXZlWGlkOyAvKiBwcm90IGJ5IEdsb2JhbE1pZF9TZW0gKi8KK3Vuc2lnbmVkIGludCBHbG9i
YWxNYXhBY3RpdmVYaWQ7CS8qIHByb3QgYnkgR2xvYmFsTWlkX1NlbSAqLworc3BpbmxvY2tfdCBH
bG9iYWxNaWRfTG9jazsgLyogcHJvdGVjdHMgYWJvdmUgJiBsaXN0IG9wZXJhdGlvbnMgb24gbWlk
USBlbnRyaWVzICovCisKKy8qCisgKiAgR2xvYmFsIGNvdW50ZXJzLCB1cGRhdGVkIGF0b21pY2Fs
bHkKKyAqLworYXRvbWljX3Qgc2VzSW5mb0FsbG9jQ291bnQ7CithdG9taWNfdCB0Y29uSW5mb0Fs
bG9jQ291bnQ7CithdG9taWNfdCB0Y3BTZXNOZXh0SWQ7CithdG9taWNfdCB0Y3BTZXNBbGxvY0Nv
dW50OworYXRvbWljX3QgdGNwU2VzUmVjb25uZWN0Q291bnQ7CithdG9taWNfdCB0Y29uSW5mb1Jl
Y29ubmVjdENvdW50OworCiBhdG9taWNfdCBtaWRfY291bnQ7CiBhdG9taWNfdCBidWZfYWxsb2Nf
Y291bnQ7CiBhdG9taWNfdCBzbWFsbF9idWZfYWxsb2NfY291bnQ7CmRpZmYgLS1naXQgYS9mcy9j
aWZzL2NpZnNnbG9iLmggYi9mcy9jaWZzL2NpZnNnbG9iLmgKaW5kZXggOWI3ZjQwOWJmYzhjLi41
NGVhNzA5ZmUwZGQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2dsb2IuaAorKysgYi9mcy9jaWZz
L2NpZnNnbG9iLmgKQEAgLTE5NTgsMjAgKzE5NTgsMjAgQEAgZXh0ZXJuIHNwaW5sb2NrX3QJCWNp
ZnNfdGNwX3Nlc19sb2NrOwogLyoKICAqIEdsb2JhbCB0cmFuc2FjdGlvbiBpZCAoWElEKSBpbmZv
cm1hdGlvbgogICovCi1HTE9CQUxfRVhURVJOIHVuc2lnbmVkIGludCBHbG9iYWxDdXJyZW50WGlk
OwkvKiBwcm90ZWN0ZWQgYnkgR2xvYmFsTWlkX1NlbSAqLwotR0xPQkFMX0VYVEVSTiB1bnNpZ25l
ZCBpbnQgR2xvYmFsVG90YWxBY3RpdmVYaWQ7IC8qIHByb3QgYnkgR2xvYmFsTWlkX1NlbSAqLwot
R0xPQkFMX0VYVEVSTiB1bnNpZ25lZCBpbnQgR2xvYmFsTWF4QWN0aXZlWGlkOwkvKiBwcm90IGJ5
IEdsb2JhbE1pZF9TZW0gKi8KLUdMT0JBTF9FWFRFUk4gc3BpbmxvY2tfdCBHbG9iYWxNaWRfTG9j
azsgIC8qIHByb3RlY3RzIGFib3ZlICYgbGlzdCBvcGVyYXRpb25zICovCi0JCQkJCSAgLyogb24g
bWlkUSBlbnRyaWVzICovCitleHRlcm4gdW5zaWduZWQgaW50IEdsb2JhbEN1cnJlbnRYaWQ7CS8q
IHByb3RlY3RlZCBieSBHbG9iYWxNaWRfU2VtICovCitleHRlcm4gdW5zaWduZWQgaW50IEdsb2Jh
bFRvdGFsQWN0aXZlWGlkOyAvKiBwcm90IGJ5IEdsb2JhbE1pZF9TZW0gKi8KK2V4dGVybiB1bnNp
Z25lZCBpbnQgR2xvYmFsTWF4QWN0aXZlWGlkOwkvKiBwcm90IGJ5IEdsb2JhbE1pZF9TZW0gKi8K
K2V4dGVybiBzcGlubG9ja190IEdsb2JhbE1pZF9Mb2NrOyAvKiBwcm90ZWN0cyBhYm92ZSAmIGxp
c3Qgb3BlcmF0aW9ucyBvbiBtaWRRIGVudHJpZXMgKi8KKwogLyoKICAqICBHbG9iYWwgY291bnRl
cnMsIHVwZGF0ZWQgYXRvbWljYWxseQogICovCi1HTE9CQUxfRVhURVJOIGF0b21pY190IHNlc0lu
Zm9BbGxvY0NvdW50OwotR0xPQkFMX0VYVEVSTiBhdG9taWNfdCB0Y29uSW5mb0FsbG9jQ291bnQ7
Ci1HTE9CQUxfRVhURVJOIGF0b21pY190IHRjcFNlc05leHRJZDsKLUdMT0JBTF9FWFRFUk4gYXRv
bWljX3QgdGNwU2VzQWxsb2NDb3VudDsKLUdMT0JBTF9FWFRFUk4gYXRvbWljX3QgdGNwU2VzUmVj
b25uZWN0Q291bnQ7Ci1HTE9CQUxfRVhURVJOIGF0b21pY190IHRjb25JbmZvUmVjb25uZWN0Q291
bnQ7CitleHRlcm4gYXRvbWljX3Qgc2VzSW5mb0FsbG9jQ291bnQ7CitleHRlcm4gYXRvbWljX3Qg
dGNvbkluZm9BbGxvY0NvdW50OworZXh0ZXJuIGF0b21pY190IHRjcFNlc05leHRJZDsKK2V4dGVy
biBhdG9taWNfdCB0Y3BTZXNBbGxvY0NvdW50OworZXh0ZXJuIGF0b21pY190IHRjcFNlc1JlY29u
bmVjdENvdW50OworZXh0ZXJuIGF0b21pY190IHRjb25JbmZvUmVjb25uZWN0Q291bnQ7CiAKIC8q
IFZhcmlvdXMgRGVidWcgY291bnRlcnMgKi8KIGV4dGVybiBhdG9taWNfdCBidWZfYWxsb2NfY291
bnQ7CS8qIGN1cnJlbnQgbnVtYmVyIGFsbG9jYXRlZCAgKi8KLS0gCjIuMzQuMQoK
--00000000000071e6e605e4991f68--
