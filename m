Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8C8C4361A
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 16:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2081A20754
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 16:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501906AbgLCQrQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Dec 2020 11:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2501905AbgLCQrP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Dec 2020 11:47:15 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621BAC061A4E
        for <linux-cifs@vger.kernel.org>; Thu,  3 Dec 2020 08:46:35 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id r24so3665254lfm.8
        for <linux-cifs@vger.kernel.org>; Thu, 03 Dec 2020 08:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Fzvw5Hkqfbo5TLY9NX/bYB5mc5DQCNuykP/hGSnvTk=;
        b=n+wGpLMBj4/QmWRRFRonFid+p9gntQKClQKJBqhSAm8fiXC5EhqElvQZMvBjOGe4sM
         zrCi4mOvtf2Qv3NNpt/TR2aBJrBaHhpSNAtDgCZ/8FryGD0Wi5751c4WE/QjWk9XTVAD
         fHZOl/lDO7NVboeeO7Zd12Dq9SPniyfgkqFz9r6IxOfWsV9stVLC/1kbBxoxcu3EIZfo
         YP2m4jso59pq6WuN4FXh9G/EHo/CY1SDjdfvMCtZbbm9botALKPcgZUBJEYFroX+mh6p
         +OShJgezUnOhwfp8gqY8go1hs//XQPqcAaHZ1D8ikD6LNyvbXCpWCzW0UCI4UAHnwgEP
         bobw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Fzvw5Hkqfbo5TLY9NX/bYB5mc5DQCNuykP/hGSnvTk=;
        b=MeT5YOnjDBZ+bqUd7cDscclBFltEoxgPT+pTLLTVbtQVZlJsdafo24hzPfdRs8kZIr
         Rr65bKTFuVHy9uAqSU81F+SC0hnjV3am9C1z7bAQsWymkgLZZtkKbPeyMFwMaJDSnEvj
         u5uBbBxD4D3PLpIpbxzdyrmhbg1il6G55+60OFYVOAdxNsKkglboZT8zudJEd61SpTcQ
         JdkVWM3bpJagZREA/5sCeTxg9JWoDU1OtdZ8MR0r52JvSk19ln1qqxC4iqm7oFGNR9BM
         5WJQ1xnS22VZ5rjCrXocQUsqjeuANlNJwE9pGemN5p/Vac+AJdCOE8IJaE7N7A/5XkxS
         cx/A==
X-Gm-Message-State: AOAM531CDUGNf58vLOXRzE8jJ1S/y5D6INkszRB0gcymisr6YmCwzHq8
        5vDsuLyB9nbBTZ32qibL+wJSsg4N2d6tT6+iTZYC3RBy7KE=
X-Google-Smtp-Source: ABdhPJx0ADdVDteTiJDIkY2CSSYXt5pl5ah31MAL+dfkK0IZHBBIrR6NeI+Kl2CIYIs+gllX1hTI7R87/0l0wMJl4kc=
X-Received: by 2002:a19:228f:: with SMTP id i137mr1556958lfi.477.1607013993415;
 Thu, 03 Dec 2020 08:46:33 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtkt6-ezyTC6zoi+DBjYQ3qFwW3UneF0_4qETEt51Tm9w@mail.gmail.com>
 <CAH2r5mt+=ELCwSASFsPPjET=qf80_1tOTMPN-gG9cF=BQd-VBg@mail.gmail.com>
In-Reply-To: <CAH2r5mt+=ELCwSASFsPPjET=qf80_1tOTMPN-gG9cF=BQd-VBg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 3 Dec 2020 10:46:22 -0600
Message-ID: <CAH2r5mv9_gvVtmBNSBDdnqkMAZMo9+fQExdgYEb+jEAMY4ad3A@mail.gmail.com>
Subject: Re: [SMB3][PATCH] ifs: refactor create_sd_buf() and and avoid
 corrupting the buffer
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000003a1aab05b5921a8e"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000003a1aab05b5921a8e
Content-Type: text/plain; charset="UTF-8"

updated the patch slightly by creating local variable for ace_count
and acl_size to avoid excessive endian conversions

On Mon, Nov 30, 2020 at 10:19 PM Steve French <smfrench@gmail.com> wrote:
>
> Updated patch with fixes for various endian sparse warnings
>
>
> On Mon, Nov 30, 2020 at 12:02 AM Steve French <smfrench@gmail.com> wrote:
> >
> > When mounting with "idsfromsid" mount option, Azure
> > corrupted the owner SIDs due to excessive padding
> > caused by placing the owner fields at the end of the
> > security descriptor on create.  Placing owners at the
> > front of the security descriptor (rather than the end)
> > is also safer, as the number of ACEs (that follow it)
> > are variable.
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--0000000000003a1aab05b5921a8e
Content-Type: text/x-patch; charset="US-ASCII"; name="refactor-create-sd-ver3.patch"
Content-Disposition: attachment; filename="refactor-create-sd-ver3.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ki92mk0d0>
X-Attachment-Id: f_ki92mk0d0

ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXgg
NDQ1ZTgwODYyODY1Li4xYjI3ZDhkOTA2MDcgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5j
CisrKyBiL2ZzL2NpZnMvc21iMnBkdS5jCkBAIC0yMjcyLDE3ICsyMjcyLDE1IEBAIHN0YXRpYyBz
dHJ1Y3QgY3J0X3NkX2N0eHQgKgogY3JlYXRlX3NkX2J1Zih1bW9kZV90IG1vZGUsIGJvb2wgc2V0
X293bmVyLCB1bnNpZ25lZCBpbnQgKmxlbikKIHsKIAlzdHJ1Y3QgY3J0X3NkX2N0eHQgKmJ1ZjsK
LQlzdHJ1Y3QgY2lmc19hY2UgKnBhY2U7Ci0JdW5zaWduZWQgaW50IHNkbGVuLCBhY2VsZW47CisJ
X191OCAqcHRyLCAqYWNscHRyOworCXVuc2lnbmVkIGludCBhY2VsZW4sIGFjbF9zaXplLCBhY2Vf
Y291bnQ7CiAJdW5zaWduZWQgaW50IG93bmVyX29mZnNldCA9IDA7CiAJdW5zaWduZWQgaW50IGdy
b3VwX29mZnNldCA9IDA7CisJc3RydWN0IHNtYjNfYWNsIGFjbDsKIAotCSpsZW4gPSByb3VuZHVw
KHNpemVvZihzdHJ1Y3QgY3J0X3NkX2N0eHQpICsgKHNpemVvZihzdHJ1Y3QgY2lmc19hY2UpICog
MiksIDgpOworCSpsZW4gPSByb3VuZHVwKHNpemVvZihzdHJ1Y3QgY3J0X3NkX2N0eHQpICsgKHNp
emVvZihzdHJ1Y3QgY2lmc19hY2UpICogNCksIDgpOwogCiAJaWYgKHNldF9vd25lcikgewotCQkv
KiBvZmZzZXQgZmllbGRzIGFyZSBmcm9tIGJlZ2lubmluZyBvZiBzZWN1cml0eSBkZXNjcmlwdG9y
IG5vdCBvZiBjcmVhdGUgY29udGV4dCAqLwotCQlvd25lcl9vZmZzZXQgPSBzaXplb2Yoc3RydWN0
IHNtYjNfYWNsKSArIChzaXplb2Yoc3RydWN0IGNpZnNfYWNlKSAqIDIpOwotCiAJCS8qIHNpemVv
ZihzdHJ1Y3Qgb3duZXJfZ3JvdXBfc2lkcykgaXMgYWxyZWFkeSBtdWx0aXBsZSBvZiA4IHNvIG5v
IG5lZWQgdG8gcm91bmQgKi8KIAkJKmxlbiArPSBzaXplb2Yoc3RydWN0IG93bmVyX2dyb3VwX3Np
ZHMpOwogCX0KQEAgLTIyOTEsMjYgKzIyODksMjIgQEAgY3JlYXRlX3NkX2J1Zih1bW9kZV90IG1v
ZGUsIGJvb2wgc2V0X293bmVyLCB1bnNpZ25lZCBpbnQgKmxlbikKIAlpZiAoYnVmID09IE5VTEwp
CiAJCXJldHVybiBidWY7CiAKKwlwdHIgPSAoX191OCAqKSZidWZbMV07CiAJaWYgKHNldF9vd25l
cikgeworCQkvKiBvZmZzZXQgZmllbGRzIGFyZSBmcm9tIGJlZ2lubmluZyBvZiBzZWN1cml0eSBk
ZXNjcmlwdG9yIG5vdCBvZiBjcmVhdGUgY29udGV4dCAqLworCQlvd25lcl9vZmZzZXQgPSBwdHIg
LSAoX191OCAqKSZidWYtPnNkOwogCQlidWYtPnNkLk9mZnNldE93bmVyID0gY3B1X3RvX2xlMzIo
b3duZXJfb2Zmc2V0KTsKLQkJZ3JvdXBfb2Zmc2V0ID0gb3duZXJfb2Zmc2V0ICsgc2l6ZW9mKHN0
cnVjdCBvd25lcl9zaWQpOworCQlncm91cF9vZmZzZXQgPSBvd25lcl9vZmZzZXQgKyBvZmZzZXRv
ZihzdHJ1Y3Qgb3duZXJfZ3JvdXBfc2lkcywgZ3JvdXApOwogCQlidWYtPnNkLk9mZnNldEdyb3Vw
ID0gY3B1X3RvX2xlMzIoZ3JvdXBfb2Zmc2V0KTsKKworCQlzZXR1cF9vd25lcl9ncm91cF9zaWRz
KHB0cik7CisJCXB0ciArPSBzaXplb2Yoc3RydWN0IG93bmVyX2dyb3VwX3NpZHMpOwogCX0gZWxz
ZSB7CiAJCWJ1Zi0+c2QuT2Zmc2V0T3duZXIgPSAwOwogCQlidWYtPnNkLk9mZnNldEdyb3VwID0g
MDsKIAl9CiAKLQlzZGxlbiA9IHNpemVvZihzdHJ1Y3Qgc21iM19zZCkgKyBzaXplb2Yoc3RydWN0
IHNtYjNfYWNsKSArCi0JCSAyICogc2l6ZW9mKHN0cnVjdCBjaWZzX2FjZSk7Ci0JaWYgKHNldF9v
d25lcikgewotCQlzZGxlbiArPSBzaXplb2Yoc3RydWN0IG93bmVyX2dyb3VwX3NpZHMpOwotCQlz
ZXR1cF9vd25lcl9ncm91cF9zaWRzKG93bmVyX29mZnNldCArIHNpemVvZihzdHJ1Y3QgY3JlYXRl
X2NvbnRleHQpICsgOCAvKiBuYW1lICovCi0JCQkrIChjaGFyICopYnVmKTsKLQl9Ci0KLQlidWYt
PmNjb250ZXh0LkRhdGFPZmZzZXQgPSBjcHVfdG9fbGUxNihvZmZzZXRvZgotCQkJCQkoc3RydWN0
IGNydF9zZF9jdHh0LCBzZCkpOwotCWJ1Zi0+Y2NvbnRleHQuRGF0YUxlbmd0aCA9IGNwdV90b19s
ZTMyKHNkbGVuKTsKKwlidWYtPmNjb250ZXh0LkRhdGFPZmZzZXQgPSBjcHVfdG9fbGUxNihvZmZz
ZXRvZihzdHJ1Y3QgY3J0X3NkX2N0eHQsIHNkKSk7CiAJYnVmLT5jY29udGV4dC5OYW1lT2Zmc2V0
ID0gY3B1X3RvX2xlMTYob2Zmc2V0b2Yoc3RydWN0IGNydF9zZF9jdHh0LCBOYW1lKSk7CiAJYnVm
LT5jY29udGV4dC5OYW1lTGVuZ3RoID0gY3B1X3RvX2xlMTYoNCk7CiAJLyogU01CMl9DUkVBVEVf
U0RfQlVGRkVSX1RPS0VOIGlzICJTZWNEIiAqLwpAQCAtMjMxOSw2ICsyMzEzLDcgQEAgY3JlYXRl
X3NkX2J1Zih1bW9kZV90IG1vZGUsIGJvb2wgc2V0X293bmVyLCB1bnNpZ25lZCBpbnQgKmxlbikK
IAlidWYtPk5hbWVbMl0gPSAnYyc7CiAJYnVmLT5OYW1lWzNdID0gJ0QnOwogCWJ1Zi0+c2QuUmV2
aXNpb24gPSAxOyAgLyogTXVzdCBiZSBvbmUgc2VlIE1TLURUWVAgMi40LjYgKi8KKwogCS8qCiAJ
ICogQUNMIGlzICJzZWxmIHJlbGF0aXZlIiBpZSBBQ0wgaXMgc3RvcmVkIGluIGNvbnRpZ3VvdXMg
YmxvY2sgb2YgbWVtb3J5CiAJICogYW5kICJEUCIgaWUgdGhlIERBQ0wgaXMgcHJlc2VudApAQCAt
MjMyNiwyOCArMjMyMSwzOSBAQCBjcmVhdGVfc2RfYnVmKHVtb2RlX3QgbW9kZSwgYm9vbCBzZXRf
b3duZXIsIHVuc2lnbmVkIGludCAqbGVuKQogCWJ1Zi0+c2QuQ29udHJvbCA9IGNwdV90b19sZTE2
KEFDTF9DT05UUk9MX1NSIHwgQUNMX0NPTlRST0xfRFApOwogCiAJLyogb2Zmc2V0IG93bmVyLCBn
cm91cCBhbmQgU2J6MSBhbmQgU0FDTCBhcmUgYWxsIHplcm8gKi8KLQlidWYtPnNkLk9mZnNldERh
Y2wgPSBjcHVfdG9fbGUzMihzaXplb2Yoc3RydWN0IHNtYjNfc2QpKTsKLQlidWYtPmFjbC5BY2xS
ZXZpc2lvbiA9IEFDTF9SRVZJU0lPTjsgLyogU2VlIDIuNC40LjEgb2YgTVMtRFRZUCAqLworCWJ1
Zi0+c2QuT2Zmc2V0RGFjbCA9IGNwdV90b19sZTMyKHB0ciAtIChfX3U4ICopJmJ1Zi0+c2QpOwor
CS8qIFNoaXAgdGhlIEFDTCBmb3Igbm93LiB3ZSB3aWxsIGNvcHkgaXQgaW50byBidWYgbGF0ZXIu
ICovCisJYWNscHRyID0gcHRyOworCXB0ciArPSBzaXplb2Yoc3RydWN0IGNpZnNfYWNsKTsKKwor
CWFjbC5BY2xSZXZpc2lvbiA9IEFDTF9SRVZJU0lPTjsgLyogU2VlIDIuNC40LjEgb2YgTVMtRFRZ
UCAqLwogCiAJLyogY3JlYXRlIG9uZSBBQ0UgdG8gaG9sZCB0aGUgbW9kZSBlbWJlZGRlZCBpbiBy
ZXNlcnZlZCBzcGVjaWFsIFNJRCAqLwotCXBhY2UgPSAoc3RydWN0IGNpZnNfYWNlICopKHNpemVv
ZihzdHJ1Y3QgY3J0X3NkX2N0eHQpICsgKGNoYXIgKilidWYpOwotCWFjZWxlbiA9IHNldHVwX3Nw
ZWNpYWxfbW9kZV9BQ0UocGFjZSwgKF9fdTY0KW1vZGUpOworCWFjZWxlbiA9IHNldHVwX3NwZWNp
YWxfbW9kZV9BQ0UoKHN0cnVjdCBjaWZzX2FjZSAqKXB0ciwgKF9fdTY0KW1vZGUpOworCXB0ciAr
PSBhY2VsZW47CisJYWNsX3NpemUgPSBhY2VsZW4gKyBzaXplb2Yoc3RydWN0IHNtYjNfYWNsKTsK
KwlhY2VfY291bnQgPSAxOwogCiAJaWYgKHNldF9vd25lcikgewogCQkvKiB3ZSBkbyBub3QgbmVl
ZCB0byByZWFsbG9jYXRlIGJ1ZmZlciB0byBhZGQgdGhlIHR3byBtb3JlIEFDRXMuIHBsZW50eSBv
ZiBzcGFjZSAqLwotCQlwYWNlID0gKHN0cnVjdCBjaWZzX2FjZSAqKShhY2VsZW4gKyAoc2l6ZW9m
KHN0cnVjdCBjcnRfc2RfY3R4dCkgKyAoY2hhciAqKWJ1ZikpOwotCQlhY2VsZW4gKz0gc2V0dXBf
c3BlY2lhbF91c2VyX293bmVyX0FDRShwYWNlKTsKLQkJLyogaXQgZG9lcyBub3QgYXBwZWFyIG5l
Y2Vzc2FyeSB0byBhZGQgYW4gQUNFIGZvciB0aGUgTkZTIGdyb3VwIFNJRCAqLwotCQlidWYtPmFj
bC5BY2VDb3VudCA9IGNwdV90b19sZTE2KDMpOwotCX0gZWxzZQotCQlidWYtPmFjbC5BY2VDb3Vu
dCA9IGNwdV90b19sZTE2KDIpOworCQlhY2VsZW4gPSBzZXR1cF9zcGVjaWFsX3VzZXJfb3duZXJf
QUNFKChzdHJ1Y3QgY2lmc19hY2UgKilwdHIpOworCQlwdHIgKz0gYWNlbGVuOworCQlhY2xfc2l6
ZSArPSBhY2VsZW47CisJCWFjZV9jb3VudCArPSAxOworCX0KIAogCS8qIGFuZCBvbmUgbW9yZSBB
Q0UgdG8gYWxsb3cgYWNjZXNzIGZvciBhdXRoZW50aWNhdGVkIHVzZXJzICovCi0JcGFjZSA9IChz
dHJ1Y3QgY2lmc19hY2UgKikoYWNlbGVuICsgKHNpemVvZihzdHJ1Y3QgY3J0X3NkX2N0eHQpICsK
LQkJKGNoYXIgKilidWYpKTsKLQlhY2VsZW4gKz0gc2V0dXBfYXV0aHVzZXJzX0FDRShwYWNlKTsK
KwlhY2VsZW4gPSBzZXR1cF9hdXRodXNlcnNfQUNFKChzdHJ1Y3QgY2lmc19hY2UgKilwdHIpOwor
CXB0ciArPSBhY2VsZW47CisJYWNsX3NpemUgKz0gYWNlbGVuOworCWFjZV9jb3VudCArPSAxOwor
CisJYWNsLkFjbFNpemUgPSBjcHVfdG9fbGUxNihhY2xfc2l6ZSk7CisJYWNsLkFjZUNvdW50ID0g
Y3B1X3RvX2xlMTYoYWNlX2NvdW50KTsKKwltZW1jcHkoYWNscHRyLCAmYWNsLCBzaXplb2Yoc3Ry
dWN0IGNpZnNfYWNsKSk7CiAKLQlidWYtPmFjbC5BY2xTaXplID0gY3B1X3RvX2xlMTYoc2l6ZW9m
KHN0cnVjdCBjaWZzX2FjbCkgKyBhY2VsZW4pOworCWJ1Zi0+Y2NvbnRleHQuRGF0YUxlbmd0aCA9
IGNwdV90b19sZTMyKHB0ciAtIChfX3U4ICopJmJ1Zi0+c2QpOworCSpsZW4gPSBwdHIgLSAoX191
OCAqKWJ1ZjsKIAogCXJldHVybiBidWY7CiB9CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUu
aCBiL2ZzL2NpZnMvc21iMnBkdS5oCmluZGV4IGYwNWY5YjEyZjY4OS4uZmE1N2IwM2NhOThjIDEw
MDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuaAorKysgYi9mcy9jaWZzL3NtYjJwZHUuaApAQCAt
OTYzLDggKzk2Myw2IEBAIHN0cnVjdCBjcnRfc2RfY3R4dCB7CiAJc3RydWN0IGNyZWF0ZV9jb250
ZXh0IGNjb250ZXh0OwogCV9fdTgJTmFtZVs4XTsKIAlzdHJ1Y3Qgc21iM19zZCBzZDsKLQlzdHJ1
Y3Qgc21iM19hY2wgYWNsOwotCS8qIEZvbGxvd2VkIGJ5IGF0IGxlYXN0IDQgQUNFcyAqLwogfSBf
X3BhY2tlZDsKIAogCg==
--0000000000003a1aab05b5921a8e--
