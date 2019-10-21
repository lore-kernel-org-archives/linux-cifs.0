Return-Path: <SRS0=SN/X=YO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A053CA9EAF
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Oct 2019 21:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 299FA2086D
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Oct 2019 21:55:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kHVrHSQK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730409AbfJUVzL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Oct 2019 17:55:11 -0400
Received: from mail-lf1-f51.google.com ([209.85.167.51]:34304 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730355AbfJUVzL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Oct 2019 17:55:11 -0400
Received: by mail-lf1-f51.google.com with SMTP id f5so3625332lfp.1
        for <linux-cifs@vger.kernel.org>; Mon, 21 Oct 2019 14:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lPIRnXrd3Nj4VLHkeHAKaXEqRQQ9UedDJw/SKyj/YuU=;
        b=kHVrHSQK8TMMjvtfV/QSAxHzv5FmKp/IsMNemObiYYYkFJD8ninzZEvPq7AK3YQnuN
         wUJimCDilaBLXvu+hsoS4OudcXiJ2fZUwJeZQd0lJmKDqRJeTag14B1WH9WEWlODSMyP
         9xhzIJKB5MzEDPR0llVlk9JYzXL/X3ZndgaTTJtUf2/eHd7MpxmUUvgzrFANp0dMiuIz
         TPrBQKd8DMc5bQi5vSqfbZSTVAr7IEOVVXpzzCgAyWHrccn6RJYow75IwZjkmxlizkdL
         2J/KsmXhZCNOMoqy74jlv4cvbbaUL0ggD8H7ZNFp0uRkVYLmgaeHlFJU73Fv5+wK0Rp0
         RYAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lPIRnXrd3Nj4VLHkeHAKaXEqRQQ9UedDJw/SKyj/YuU=;
        b=NeRE0ZLoJ5xbEllgpwHumVS/PAHD5Zrmten2Bkvf5fDgvBezvKpLtNsN/IzsUNDIfx
         c1+YFzjYhnvS5vGf5jkRVIPm1V+dw0NyyxQHGwjg1fOrwD75FFl4S632+giu2rIRKj2j
         nM/z8Z/TaLvYXF7rUMZLO0GTeZlqvBHh4mUVh+eme3g2EaKdcQ0geW9wdoJnhxQOTS8T
         p8/aeeJLmBeCK7BnE78MTZ1offmSOCPRF8PQu/nPFFUrRiVz5UYJxCWigGmLd8dO165w
         dMZWCnRXpjnQw/F0Ys8qvGYNFnNzunwNa9CigVL2pjQmhxYh6BIR1a0qliYYB6L++tVK
         IESw==
X-Gm-Message-State: APjAAAXbBPOeWpbPeYcTR+NEq4rLejaKHHAvDc1rvJi5CWWSAUOWsP4I
        m/r7FjU9xbhps2gK4plEepEqlofKvYlKWnGVoQ==
X-Google-Smtp-Source: APXvYqxFCRviwEzmuSFMAdemY+yk2UuSKLHdpan9wWJFCkCoXO04oPOziNBLVXNKhueoCKnMXyJnuXC/SSFzsVgsmVU=
X-Received: by 2002:ac2:5a49:: with SMTP id r9mr15905810lfn.54.1571694908036;
 Mon, 21 Oct 2019 14:55:08 -0700 (PDT)
MIME-Version: 1.0
References: <CALF+zOkugWpn6aCApqj8dF+AovgbQ8zgC-Hf8_0uvwqwHYTPiw@mail.gmail.com>
 <CALF+zO=8ZJkqR951NsxOf4hDDyUZzMfyiEN-j8DgA+i+FzcfGw@mail.gmail.com>
 <DM5PR21MB018515AFDDDE766D318BC489B66D0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <CALF+zOmz5LFkzHrLpLGWcfwkOD7s-VhVz39pFgMNAFRT9_-KYg@mail.gmail.com>
 <58429039.7213410.1571348691819.JavaMail.zimbra@redhat.com>
 <DM5PR21MB0185FD6A138A5682BB9DE310B66D0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <106934753.7215598.1571352823170.JavaMail.zimbra@redhat.com>
 <CALF+zOn-J9KyDDTL6dJ23RbQ9Gh+V3ti+4-O051zqOur6Fv-PA@mail.gmail.com>
 <1884745525.7250940.1571390858862.JavaMail.zimbra@redhat.com>
 <CALF+zOkmFMtxsnrUR-anXOdMzUFxtAWG+VYLAQuq3DJuH=eDMw@mail.gmail.com>
 <DM5PR21MB0185857761946DBE12AEB3ADB66C0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <CALF+zO=heBJSLW4ELPAwKegL3rJQiSebCLAh=4syEtPYoaevgA@mail.gmail.com>
 <CALF+zO=BUC2pCcz=n6hBx7ZPsL8gABLqx_hBQXVC=OOLJ-DDig@mail.gmail.com>
 <DM5PR21MB01851871D57ABCF685712C76B66C0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <CALF+zOkTwetUsL0he3nqjvTO4QPJm6bgk2CnEbcjihW2h4CZNw@mail.gmail.com>
In-Reply-To: <CALF+zOkTwetUsL0he3nqjvTO4QPJm6bgk2CnEbcjihW2h4CZNw@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 21 Oct 2019 14:54:55 -0700
Message-ID: <CAKywueRjL=Ob1jKFyV+ApxZPXWM91aQRD8UJxe0h6kLi-iDmpA@mail.gmail.com>
Subject: Re: list_del corruption while iterating retry_list in cifs_reconnect
 still seen on 5.4-rc3
To:     David Wysochanski <dwysocha@redhat.com>
Cc:     Pavel Shilovskiy <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Frank Sorenson <sorenson@redhat.com>
Content-Type: multipart/mixed; boundary="000000000000b06fcf059572bc9a"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000b06fcf059572bc9a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=D1=81=D0=B1, 19 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 04:10, David Wysoc=
hanski <dwysocha@redhat.com>:
> Right but look at it this way.  If we conditionally set the state,
> then what is preventing a duplicate list_del_init call?  Let's say we
> get into the special case that you're not sure it could happen
> (mid_entry->mid_state =3D=3D MID_REQUEST_SUBMITTED is false), and so the
> mid_state does not get set to MID_RETRY_NEEDED inside cifs_reconnect
> but yet the mid gets added to retry_list.  In that case both the
> cifs_reconnect code path will call list_del_init as well as the other
> code paths which we're adding the conditional tests and that will
> cause a blowup again because cifs_reconnect retry_list loop will end
> up in a singleton list and exhaust the refcount, leading to the same
> crash.  This is exactly why the refcount only patch crashed again -
> it's erroneous to think it's ok to modify mid_entry->qhead without a)
> taking globalMid_Lock and b) checking mid_state is what you think it
> should be.  But if you're really concerned about that 'if' condition
> and want to leave it, and you want a stable patch, then the extra flag
> seems like the way to go.  But that has the downside that it's only
> being done for stable, so a later patch will likely remove it
> (presumably).  I am not sure what such policy is or if that is even
> acceptable or allowed.

This is acceptable and it is a good practice to fix the existing issue
with the smallest possible patch and then enhance the code/fix for the
current master branch if needed. This simplify backporting a lot.

Actually looking at the code:

cifsglob.h:

1692 #define   MID_DELETED            2 /* Mid has been dequeued/deleted */

                    ^^^
Isn't "deqeueued" what we need? It seems so because it serves the same
purpose: to indicate that a request has been deleted from the pending
queue. So, I think we need to just make use of this existing flag and
mark the mid with MID_DELETED every time we remove the mid from the
pending list. Also assume moving mids from the pending lists to the
local lists in cleanup_demultiplex_info and cifs_reconnect as a
deletion too because those lists are not exposed globally and mids are
removed from those lists before the functions exit.

I made a patch which is using MID_DELETED logic and merging
DeleteMidQEntry and cifs_mid_q_entry_release into one function to
avoid possible use-after free of mid->resp_buf.

David, could you please test the attached patch in your environment? I
only did sanity testing of it.

--
Best regards,
Pavel Shilovsky

--000000000000b06fcf059572bc9a
Content-Type: application/octet-stream; name="mid_dequeue.patch"
Content-Disposition: attachment; filename="mid_dequeue.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k20y83g10>
X-Attachment-Id: f_k20y83g10

ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXgg
OGVlNTdkMWY1MDdmLi43ZmY3NWEyYmExMWMgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5j
CisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC01NTgsNyArNTU4LDkgQEAgY2lmc19yZWNvbm5l
Y3Qoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQogCQltaWRfZW50cnkgPSBsaXN0X2Vu
dHJ5KHRtcCwgc3RydWN0IG1pZF9xX2VudHJ5LCBxaGVhZCk7CiAJCWlmIChtaWRfZW50cnktPm1p
ZF9zdGF0ZSA9PSBNSURfUkVRVUVTVF9TVUJNSVRURUQpCiAJCQltaWRfZW50cnktPm1pZF9zdGF0
ZSA9IE1JRF9SRVRSWV9ORUVERUQ7CisJCWtyZWZfZ2V0KCZtaWRfZW50cnktPnJlZmNvdW50KTsK
IAkJbGlzdF9tb3ZlKCZtaWRfZW50cnktPnFoZWFkLCAmcmV0cnlfbGlzdCk7CisJCW1pZF9lbnRy
eS0+bWlkX2ZsYWdzIHw9IE1JRF9ERUxFVEVEOwogCX0KIAlzcGluX3VubG9jaygmR2xvYmFsTWlk
X0xvY2spOwogCW11dGV4X3VubG9jaygmc2VydmVyLT5zcnZfbXV0ZXgpOwpAQCAtNTY4LDYgKzU3
MCw3IEBAIGNpZnNfcmVjb25uZWN0KHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcikKIAkJ
bWlkX2VudHJ5ID0gbGlzdF9lbnRyeSh0bXAsIHN0cnVjdCBtaWRfcV9lbnRyeSwgcWhlYWQpOwog
CQlsaXN0X2RlbF9pbml0KCZtaWRfZW50cnktPnFoZWFkKTsKIAkJbWlkX2VudHJ5LT5jYWxsYmFj
ayhtaWRfZW50cnkpOworCQljaWZzX21pZF9xX2VudHJ5X3JlbGVhc2UobWlkX2VudHJ5KTsKIAl9
CiAKIAlpZiAoY2lmc19yZG1hX2VuYWJsZWQoc2VydmVyKSkgewpAQCAtODg3LDggKzg5MCwxMCBA
QCBkZXF1ZXVlX21pZChzdHJ1Y3QgbWlkX3FfZW50cnkgKm1pZCwgYm9vbCBtYWxmb3JtZWQpCiAJ
aWYgKG1pZC0+bWlkX2ZsYWdzICYgTUlEX0RFTEVURUQpCiAJCXByaW50a19vbmNlKEtFUk5fV0FS
TklORwogCQkJICAgICJ0cnlpbmcgdG8gZGVxdWV1ZSBhIGRlbGV0ZWQgbWlkXG4iKTsKLQllbHNl
CisJZWxzZSB7CiAJCWxpc3RfZGVsX2luaXQoJm1pZC0+cWhlYWQpOworCQltaWQtPm1pZF9mbGFn
cyB8PSBNSURfREVMRVRFRDsKKwl9CiAJc3Bpbl91bmxvY2soJkdsb2JhbE1pZF9Mb2NrKTsKIH0K
IApAQCAtOTU4LDggKzk2MywxMCBAQCBzdGF0aWMgdm9pZCBjbGVhbl9kZW11bHRpcGxleF9pbmZv
KHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcikKIAkJbGlzdF9mb3JfZWFjaF9zYWZlKHRt
cCwgdG1wMiwgJnNlcnZlci0+cGVuZGluZ19taWRfcSkgewogCQkJbWlkX2VudHJ5ID0gbGlzdF9l
bnRyeSh0bXAsIHN0cnVjdCBtaWRfcV9lbnRyeSwgcWhlYWQpOwogCQkJY2lmc19kYmcoRllJLCAi
Q2xlYXJpbmcgbWlkIDB4JWxseFxuIiwgbWlkX2VudHJ5LT5taWQpOworCQkJa3JlZl9nZXQoJm1p
ZF9lbnRyeS0+cmVmY291bnQpOwogCQkJbWlkX2VudHJ5LT5taWRfc3RhdGUgPSBNSURfU0hVVERP
V047CiAJCQlsaXN0X21vdmUoJm1pZF9lbnRyeS0+cWhlYWQsICZkaXNwb3NlX2xpc3QpOworCQkJ
bWlkX2VudHJ5LT5taWRfZmxhZ3MgfD0gTUlEX0RFTEVURUQ7CiAJCX0KIAkJc3Bpbl91bmxvY2so
Jkdsb2JhbE1pZF9Mb2NrKTsKIApAQCAtOTY5LDYgKzk3Niw3IEBAIHN0YXRpYyB2b2lkIGNsZWFu
X2RlbXVsdGlwbGV4X2luZm8oc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQogCQkJY2lm
c19kYmcoRllJLCAiQ2FsbGJhY2sgbWlkIDB4JWxseFxuIiwgbWlkX2VudHJ5LT5taWQpOwogCQkJ
bGlzdF9kZWxfaW5pdCgmbWlkX2VudHJ5LT5xaGVhZCk7CiAJCQltaWRfZW50cnktPmNhbGxiYWNr
KG1pZF9lbnRyeSk7CisJCQljaWZzX21pZF9xX2VudHJ5X3JlbGVhc2UobWlkX2VudHJ5KTsKIAkJ
fQogCQkvKiAxLzh0aCBvZiBzZWMgaXMgbW9yZSB0aGFuIGVub3VnaCB0aW1lIGZvciB0aGVtIHRv
IGV4aXQgKi8KIAkJbXNsZWVwKDEyNSk7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3RyYW5zcG9ydC5j
IGIvZnMvY2lmcy90cmFuc3BvcnQuYwppbmRleCA1ZDZkNDRiZmUxMGEuLmJiNTI3NTFiYTc4MyAx
MDA2NDQKLS0tIGEvZnMvY2lmcy90cmFuc3BvcnQuYworKysgYi9mcy9jaWZzL3RyYW5zcG9ydC5j
CkBAIC04NiwyMiArODYsOCBAQCBBbGxvY01pZFFFbnRyeShjb25zdCBzdHJ1Y3Qgc21iX2hkciAq
c21iX2J1ZmZlciwgc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQogCiBzdGF0aWMgdm9p
ZCBfY2lmc19taWRfcV9lbnRyeV9yZWxlYXNlKHN0cnVjdCBrcmVmICpyZWZjb3VudCkKIHsKLQlz
dHJ1Y3QgbWlkX3FfZW50cnkgKm1pZCA9IGNvbnRhaW5lcl9vZihyZWZjb3VudCwgc3RydWN0IG1p
ZF9xX2VudHJ5LAotCQkJCQkgICAgICAgcmVmY291bnQpOwotCi0JbWVtcG9vbF9mcmVlKG1pZCwg
Y2lmc19taWRfcG9vbHApOwotfQotCi12b2lkIGNpZnNfbWlkX3FfZW50cnlfcmVsZWFzZShzdHJ1
Y3QgbWlkX3FfZW50cnkgKm1pZEVudHJ5KQotewotCXNwaW5fbG9jaygmR2xvYmFsTWlkX0xvY2sp
OwotCWtyZWZfcHV0KCZtaWRFbnRyeS0+cmVmY291bnQsIF9jaWZzX21pZF9xX2VudHJ5X3JlbGVh
c2UpOwotCXNwaW5fdW5sb2NrKCZHbG9iYWxNaWRfTG9jayk7Ci19Ci0KLXZvaWQKLURlbGV0ZU1p
ZFFFbnRyeShzdHJ1Y3QgbWlkX3FfZW50cnkgKm1pZEVudHJ5KQoteworCXN0cnVjdCBtaWRfcV9l
bnRyeSAqbWlkRW50cnkgPQorCQkJY29udGFpbmVyX29mKHJlZmNvdW50LCBzdHJ1Y3QgbWlkX3Ff
ZW50cnksIHJlZmNvdW50KTsKICNpZmRlZiBDT05GSUdfQ0lGU19TVEFUUzIKIAlfX2xlMTYgY29t
bWFuZCA9IG1pZEVudHJ5LT5zZXJ2ZXItPnZhbHMtPmxvY2tfY21kOwogCV9fdTE2IHNtYl9jbWQg
PSBsZTE2X3RvX2NwdShtaWRFbnRyeS0+Y29tbWFuZCk7CkBAIC0xNjYsNiArMTUyLDE5IEBAIERl
bGV0ZU1pZFFFbnRyeShzdHJ1Y3QgbWlkX3FfZW50cnkgKm1pZEVudHJ5KQogCQl9CiAJfQogI2Vu
ZGlmCisKKwltZW1wb29sX2ZyZWUobWlkRW50cnksIGNpZnNfbWlkX3Bvb2xwKTsKK30KKwordm9p
ZCBjaWZzX21pZF9xX2VudHJ5X3JlbGVhc2Uoc3RydWN0IG1pZF9xX2VudHJ5ICptaWRFbnRyeSkK
K3sKKwlzcGluX2xvY2soJkdsb2JhbE1pZF9Mb2NrKTsKKwlrcmVmX3B1dCgmbWlkRW50cnktPnJl
ZmNvdW50LCBfY2lmc19taWRfcV9lbnRyeV9yZWxlYXNlKTsKKwlzcGluX3VubG9jaygmR2xvYmFs
TWlkX0xvY2spOworfQorCit2b2lkIERlbGV0ZU1pZFFFbnRyeShzdHJ1Y3QgbWlkX3FfZW50cnkg
Km1pZEVudHJ5KQorewogCWNpZnNfbWlkX3FfZW50cnlfcmVsZWFzZShtaWRFbnRyeSk7CiB9CiAK
QEAgLTE3Myw4ICsxNzIsMTAgQEAgdm9pZAogY2lmc19kZWxldGVfbWlkKHN0cnVjdCBtaWRfcV9l
bnRyeSAqbWlkKQogewogCXNwaW5fbG9jaygmR2xvYmFsTWlkX0xvY2spOwotCWxpc3RfZGVsX2lu
aXQoJm1pZC0+cWhlYWQpOwotCW1pZC0+bWlkX2ZsYWdzIHw9IE1JRF9ERUxFVEVEOworCWlmICgh
KG1pZC0+bWlkX2ZsYWdzICYgTUlEX0RFTEVURUQpKSB7CisJCWxpc3RfZGVsX2luaXQoJm1pZC0+
cWhlYWQpOworCQltaWQtPm1pZF9mbGFncyB8PSBNSURfREVMRVRFRDsKKwl9CiAJc3Bpbl91bmxv
Y2soJkdsb2JhbE1pZF9Mb2NrKTsKIAogCURlbGV0ZU1pZFFFbnRyeShtaWQpOwpAQCAtODY4LDcg
Kzg2OSwxMCBAQCBjaWZzX3N5bmNfbWlkX3Jlc3VsdChzdHJ1Y3QgbWlkX3FfZW50cnkgKm1pZCwg
c3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQogCQlyYyA9IC1FSE9TVERPV047CiAJCWJy
ZWFrOwogCWRlZmF1bHQ6Ci0JCWxpc3RfZGVsX2luaXQoJm1pZC0+cWhlYWQpOworCQlpZiAoISht
aWQtPm1pZF9mbGFncyAmIE1JRF9ERUxFVEVEKSkgeworCQkJbGlzdF9kZWxfaW5pdCgmbWlkLT5x
aGVhZCk7CisJCQltaWQtPm1pZF9mbGFncyB8PSBNSURfREVMRVRFRDsKKwkJfQogCQljaWZzX2Ri
ZyhWRlMsICIlczogaW52YWxpZCBtaWQgc3RhdGUgbWlkPSVsbHUgc3RhdGU9JWRcbiIsCiAJCQkg
X19mdW5jX18sIG1pZC0+bWlkLCBtaWQtPm1pZF9zdGF0ZSk7CiAJCXJjID0gLUVJTzsK
--000000000000b06fcf059572bc9a--
