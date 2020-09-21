Return-Path: <SRS0=z3C/=C6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDEF2C43463
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Sep 2020 03:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 951D7207D3
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Sep 2020 03:50:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MVLEHLBZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgIUDuU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 20 Sep 2020 23:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgIUDuT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 20 Sep 2020 23:50:19 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60A8C061755
        for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2020 20:50:18 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 133so2036872ybg.11
        for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2020 20:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cY70F/yNKC+XeurjzTwLpDsJjlj+VV8cha6ae6FBZtQ=;
        b=MVLEHLBZuuXiB9pGkIjA8Ode3c+qif8DGZH2ZmZG6xAXgBR4pUsf2e3QLJwh2NZFqu
         jvGlCFHoJQBVOpDtA7LE5tKQcvjIDsJWbA4FzHq12HZfjwsFrDUhe2/GRGDa7Jbp2WMZ
         CbbAJOyhmMkm++Ix5oRjYKTtg8nAAlJnU9nB+hMpCCl1c84PepVF79/oK+ArBVR5t60V
         mgkSMcu6uY85Fz6bwoPtqqkmIdT5FnV+mH7AVxUpvcQ2hYqGpm6cBsBEznI5P2yELrW6
         yB1D5a3QVHJPXSQfaT45bHliCvt3C6k1AebWnjgjq67POwP9Mq/TfxRb6O/brL/fR0Yr
         hBQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cY70F/yNKC+XeurjzTwLpDsJjlj+VV8cha6ae6FBZtQ=;
        b=YznyJr+9PjUrHP303SeN8ZB6m1OfIC8aeKyvbLfkzOs/gmMEzpt+EZX4arI9iOkbdj
         QbXfJEwwEDFmalBfrEtBRvY0qbP3YU+p0xbIEUcZuubZEWziHxtW8gVrKuHsPHUqL/Hm
         IWJ8O4Tkm15/nhLaTjm8nZ0WpdcZQB0w9oDwUDas4ThOzB49butYnYvxP3OIUyxJoiOs
         BWN29qqBb7TlOTnWaaSRhfYocMaLqlvj4VuRTyRQVRUX82lMPg673KWRwqkjy30OSsUd
         NuFOPfRH4r+Y7kgvBpXXafffMNrxaU30LMaGFREh7PrMCYvpwJAS24kIJnXgqULyiMTq
         MuUA==
X-Gm-Message-State: AOAM533nIGV+n/vvdr47dqJ2UqPGw07tuoD+RV6MUsxGhkY+ZEmcsQBZ
        2CRw/yZrOZygZpphRFfsBIsgFzOuwO33NJNp2P0=
X-Google-Smtp-Source: ABdhPJzAVZTCa+eVRwJIoDO/LuKIZ92uMtvzVJlwASc+1/qt6+fJUXEuZ4s3BQSTUO+ogRzHNOQ1KnLaElNCz00Wzzw=
X-Received: by 2002:a25:6193:: with SMTP id v141mr56805652ybb.34.1600660217735;
 Sun, 20 Sep 2020 20:50:17 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=oiTY63d5yVyywiTrCqpAmvaugMVVpQRV7RT7ZA9HU2+Q@mail.gmail.com>
 <87r1r2ugzw.fsf@suse.com> <CANT5p=qV6BWojwBET+kYUwJf7tQDFoRtUb8O+pWHrqWMw5e5LQ@mail.gmail.com>
 <87wo0slr0c.fsf@suse.com> <CANT5p=rarYr0bErP77GF5QOu8=xx7Ovfy2dWdUNxnOTGkLXMKQ@mail.gmail.com>
 <87o8m4lnig.fsf@suse.com>
In-Reply-To: <87o8m4lnig.fsf@suse.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 21 Sep 2020 09:20:06 +0530
Message-ID: <CANT5p=rKKZeS+HqonXQF4eaKFTod0rhb56GM4dXkYKhCcDhftw@mail.gmail.com>
Subject: Re: [PATCH][SMB3] mount.cifs: use SUDO_UID env variable for cruid
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com
Content-Type: multipart/mixed; boundary="000000000000af433105afcabfd6"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000af433105afcabfd6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Aur=C3=A9lien.
Here's the updated patch.

Regards,
Shyam

On Thu, Sep 17, 2020 at 3:43 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
> > Attaching the patch with the review comments incorporated.
> > Tested a few positive and negative test cases. Works as expected.
>
> Great, I only have one small comment:
> > +     reinit_parsed_info =3D
> > +             (struct parsed_mount_info *) malloc(sizeof(*reinit_parsed=
_info));
>
> Don't cast malloc return value (void* gets implicitely promoted to
> any pointer type).
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)



--=20
-Shyam

--000000000000af433105afcabfd6
Content-Type: application/octet-stream; 
	name="0001-mount.cifs-use-SUDO_UID-env-variable-for-cruid.patch"
Content-Disposition: attachment; 
	filename="0001-mount.cifs-use-SUDO_UID-env-variable-for-cruid.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kfbzqzfv0>
X-Attachment-Id: f_kfbzqzfv0

RnJvbSAxYzQ3OGE5MmY5OGRmM2NhMjExYWIwOGY3ZmRiNmRlZTc2NzlkYzk5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBXZWQsIDE2IFNlcCAyMDIwIDAwOjE4OjQ0IC0wNzAwClN1YmplY3Q6IFtQQVRDSF0g
bW91bnQuY2lmczogdXNlIFNVRE9fVUlEIGVudiB2YXJpYWJsZSBmb3IgY3J1aWQKCkluIHRoZSBj
dXJyZW50IG1vdW50LmNpZnMgbG9naWMsIHdoZW4gc3VkbyBpcyB1c2VkIGZvciBtb3VudCwKdWlk
PTAsIHNvIHRoZSBtb3VudCBjb21tYW5kIHNlYXJjaGVzIGZvciBjcnVpZD0wIHVubGVzcyBleHBs
aWNpdGx5CnNwZWNpZmllZCBieSB0aGUgdXNlci4gVGhlIHVzZXIgbWF5IGFscmVhZHkgaGF2ZSBj
cmVkIGNhY2hlIHBvcHVsYXRlZApidXQgbW91bnQuY2lmcyB3b3VsZCBlbmQgdXAgc2VhcmNoaW5n
IGNyZWQgY2FjaGUgZm9yIHVpZD0wLgoKbW91bnQuY2lmcyBjYW4gYXZvaWQgdGhpcyBjb25mdXNp
b24gYnkgcmVhZGluZyB0aGUgY3J1aWQgZnJvbSBTVURPX1VJRAplbnZpcm9ubWVudCB2YXJpYWJs
ZS4gSWYgaXQgaXMgc2V0IHRvIG5vbi16ZXJvLCB3ZSBjYW4gbWFrZSBjcnVpZD0kU1VET19VSUQu
CgpIb3dldmVyLCB0byBtYWludGFpbiBiYWNrd2FyZCBjb21wYXRpYmlsaXR5LCBrZWVwaW5nIHRo
aXMgYXMgYSBmYWxsYmFjayBvcHRpb24uCklmIG1vdW50IGZhaWxzIHdpdGggcGVybWlzc2lvbiBk
ZW5pZWQsIHRoZW4gcmV0cnkgd2l0aCB0aGlzIG9wdGlvbi4KVG8gZW5hYmxlIHRoaXMgZmFsbGJh
Y2ssIEkgaGFkIHRvIG1ha2UgYSBmZXcgbWlub3IgY2hhbmdlcyBpbiB0aGUgZmxvdy4KLS0tCiBt
b3VudC5jaWZzLmMgfCA2OCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Ky0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNTQgaW5zZXJ0aW9ucygrKSwgMTQgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvbW91bnQuY2lmcy5jIGIvbW91bnQuY2lmcy5jCmluZGV4IDRm
ZWIzOTcuLjI3MTBjY2EgMTAwNjQ0Ci0tLSBhL21vdW50LmNpZnMuYworKysgYi9tb3VudC5jaWZz
LmMKQEAgLTE3MSw3ICsxNzEsMTEgQEAKIAogI2RlZmluZSBOVEZTX1RJTUVfT0ZGU0VUICgodW5z
aWduZWQgbG9uZyBsb25nKSgzNjkqMzY1ICsgODkpICogMjQgKiAzNjAwICogMTAwMDAwMDApCiAK
LS8qIHN0cnVjdCBmb3IgaG9sZGluZyBwYXJzZWQgbW91bnQgaW5mbyBmb3IgdXNlIGJ5IHByaXZp
bGVnZWQgcHJvY2VzcyAqLworLyoKKyogc3RydWN0IGZvciBob2xkaW5nIHBhcnNlZCBtb3VudCBp
bmZvIGZvciB1c2UgYnkgcHJpdmlsZWdlZCBwcm9jZXNzLgorKiBQbGVhc2UgZG8gbm90IGtlZXAg
cG9pbnRlcnMgaW4gdGhpcyBzdHJ1Y3QuCisqIFRoYXQgd2F5LCByZWluaXQgb2YgdGhpcyBzdHJ1
Y3QgaXMgYSBzaW1wbGUgbWVtc2V0LgorKi8KIHN0cnVjdCBwYXJzZWRfbW91bnRfaW5mbyB7CiAJ
dW5zaWduZWQgbG9uZyBmbGFnczsKIAljaGFyIGhvc3RbTklfTUFYSE9TVCArIDFdOwpAQCAtMTg5
LDYgKzE5Myw3IEBAIHN0cnVjdCBwYXJzZWRfbW91bnRfaW5mbyB7CiAJdW5zaWduZWQgaW50IHZl
cmJvc2VmbGFnOjE7CiAJdW5zaWduZWQgaW50IG5vZmFpbDoxOwogCXVuc2lnbmVkIGludCBnb3Rf
ZG9tYWluOjE7CisJdWlkX3Qgc3Vkb191aWQ7CiB9OwogCiBzdGF0aWMgY29uc3QgY2hhciAqdGhp
c3Byb2dyYW07CkBAIC0xMTk5LDYgKzEyMDQsMTAgQEAgbm9jb3B5OgogCQlzbnByaW50ZihvdXQg
KyBvdXRfbGVuLCB3b3JkX2xlbiArIDUsICJ1aWQ9JXMiLCB0eHRidWYpOwogCQlvdXRfbGVuID0g
c3RybGVuKG91dCk7CiAJfQorCWlmIChwYXJzZWRfaW5mby0+c3Vkb191aWQpIHsKKwkJY3J1aWQg
PSBwYXJzZWRfaW5mby0+c3Vkb191aWQ7CisJCWdvdF9jcnVpZCA9IDE7CisJfQogCWlmIChnb3Rf
Y3J1aWQpIHsKIAkJd29yZF9sZW4gPSBzbnByaW50Zih0eHRidWYsIHNpemVvZih0eHRidWYpLCAi
JXUiLCBjcnVpZCk7CiAKQEAgLTIwMTIsMTIgKzIwMjEsMTYgQEAgaW50IG1haW4oaW50IGFyZ2Ms
IGNoYXIgKiphcmd2KQogCWNoYXIgKm9wdGlvbnMgPSBOVUxMOwogCWNoYXIgKm9yaWdfZGV2ID0g
TlVMTDsKIAljaGFyICpjdXJyZW50YWRkcmVzcywgKm5leHRhZGRyZXNzOworCWNoYXIgKnZhbHVl
ID0gTlVMTDsKKwljaGFyICplcCA9IE5VTEw7CiAJaW50IHJjID0gMDsKIAlpbnQgYWxyZWFkeV91
cHBlcmNhc2VkID0gMDsKIAlpbnQgc2xvcHB5ID0gMDsKIAlzaXplX3Qgb3B0aW9uc19zaXplID0g
TUFYX09QVElPTlNfTEVOOwogCXN0cnVjdCBwYXJzZWRfbW91bnRfaW5mbyAqcGFyc2VkX2luZm8g
PSBOVUxMOworCXN0cnVjdCBwYXJzZWRfbW91bnRfaW5mbyAqcmVpbml0X3BhcnNlZF9pbmZvID0g
TlVMTDsKIAlwaWRfdCBwaWQ7CisJdWlkX3Qgc3Vkb191aWQgPSAwOwogCiAJcmMgPSBjaGVja19z
ZXR1aWQoKTsKIAlpZiAocmMpCkBAIC0yMDUzLDcgKzIwNjYsMjMgQEAgaW50IG1haW4oaW50IGFy
Z2MsIGNoYXIgKiphcmd2KQogCQlwYXJzZWRfaW5mbyA9IE5VTEw7CiAJCWZwcmludGYoc3RkZXJy
LCAiVW5hYmxlIHRvIGFsbG9jYXRlIG1lbW9yeTogJXNcbiIsCiAJCQkJc3RyZXJyb3IoZXJybm8p
KTsKLQkJcmV0dXJuIEVYX1NZU0VSUjsKKwkJcmMgPSBFWF9TWVNFUlI7CisJCWdvdG8gbW91bnRf
ZXhpdDsKKwl9CisKKwlyZWluaXRfcGFyc2VkX2luZm8gPSBtYWxsb2Moc2l6ZW9mKCpyZWluaXRf
cGFyc2VkX2luZm8pKTsKKwlpZiAocmVpbml0X3BhcnNlZF9pbmZvID09IE5VTEwpIHsKKwkJZnBy
aW50ZihzdGRlcnIsICJVbmFibGUgdG8gYWxsb2NhdGUgbWVtb3J5OiAlc1xuIiwKKwkJCQlzdHJl
cnJvcihlcnJubykpOworCQlyYyA9IEVYX1NZU0VSUjsKKwkJZ290byBtb3VudF9leGl0OworCX0K
KworCW9wdGlvbnMgPSBjYWxsb2Mob3B0aW9uc19zaXplLCAxKTsKKwlpZiAoIW9wdGlvbnMpIHsK
KwkJZnByaW50ZihzdGRlcnIsICJVbmFibGUgdG8gYWxsb2NhdGUgbWVtb3J5LlxuIik7CisJCXJj
ID0gRVhfU1lTRVJSOworCQlnb3RvIG1vdW50X2V4aXQ7CiAJfQogCiAJLyogYWRkIHNoYXJlbmFt
ZSBpbiBvcHRzIHN0cmluZyBhcyB1bmM9IHBhcm0gKi8KQEAgLTIxMTAsMTAgKzIxMzksMTMgQEAg
aW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQogCS8qIGNoZGlyIGludG8gbW91bnRwb2lu
dCBhcyBzb29uIGFzIHBvc3NpYmxlICovCiAJcmMgPSBhY3F1aXJlX21vdW50cG9pbnQoJm1vdW50
cG9pbnQpOwogCWlmIChyYykgewotCQlmcmVlKG9yZ29wdGlvbnMpOwotCQlyZXR1cm4gcmM7CisJ
CWdvdG8gbW91bnRfZXhpdDsKIAl9CiAKKwkvKiBCZWZvcmUgZ290byBhc3NlbWJsZV9yZXRyeSwg
cmVpbml0aWFsaXplIHBhcnNlZF9pbmZvIHdpdGggcmVpbml0X3BhcnNlZF9pbmZvICovCisJbWVt
Y3B5KHJlaW5pdF9wYXJzZWRfaW5mbywgcGFyc2VkX2luZm8sCXNpemVvZigqcmVpbml0X3BhcnNl
ZF9pbmZvKSk7CisKK2Fzc2VtYmxlX3JldHJ5OgogCS8qCiAJICogbW91bnQuY2lmcyBkb2VzIHBy
aXZpbGVnZSBzZXBhcmF0aW9uLiBNb3N0IG9mIHRoZSBjb2RlIHRvIGhhbmRsZQogCSAqIGFzc2Vt
YmxpbmcgdGhlIG1vdW50IGluZm8gaXMgZG9uZSBpbiBhIGNoaWxkIHByb2Nlc3MgdGhhdCBkcm9w
cwpAQCAtMjEzMSw5ICsyMTYzLDcgQEAgaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQog
CQkvKiBjaGlsZCAqLwogCQlyYyA9IGFzc2VtYmxlX21vdW50aW5mbyhwYXJzZWRfaW5mbywgdGhp
c3Byb2dyYW0sIG1vdW50cG9pbnQsCiAJCQkJCW9yaWdfZGV2LCBvcmdvcHRpb25zKTsKLQkJZnJl
ZShvcmdvcHRpb25zKTsKLQkJZnJlZShtb3VudHBvaW50KTsKLQkJcmV0dXJuIHJjOworCQlnb3Rv
IG1vdW50X2V4aXQ7CiAJfSBlbHNlIHsKIAkJLyogcGFyZW50ICovCiAJCXBpZCA9IHdhaXQoJnJj
KTsKQEAgLTIxNDcsMTkgKzIxNzcsMTMgQEAgaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2
KQogCQkJZ290byBtb3VudF9leGl0OwogCX0KIAotCW9wdGlvbnMgPSBjYWxsb2Mob3B0aW9uc19z
aXplLCAxKTsKLQlpZiAoIW9wdGlvbnMpIHsKLQkJZnByaW50ZihzdGRlcnIsICJVbmFibGUgdG8g
YWxsb2NhdGUgbWVtb3J5LlxuIik7Ci0JCXJjID0gRVhfU1lTRVJSOwotCQlnb3RvIG1vdW50X2V4
aXQ7Ci0JfQotCiAJY3VycmVudGFkZHJlc3MgPSBwYXJzZWRfaW5mby0+YWRkcmxpc3Q7CiAJbmV4
dGFkZHJlc3MgPSBzdHJjaHIoY3VycmVudGFkZHJlc3MsICcsJyk7CiAJaWYgKG5leHRhZGRyZXNz
KQogCQkqbmV4dGFkZHJlc3MrKyA9ICdcMCc7CiAKIG1vdW50X3JldHJ5OgorCW9wdGlvbnNbMF0g
PSAnXDAnOwogCWlmICghY3VycmVudGFkZHJlc3MpIHsKIAkJZnByaW50ZihzdGRlcnIsICJVbmFi
bGUgdG8gZmluZCBzdWl0YWJsZSBhZGRyZXNzLlxuIik7CiAJCXJjID0gcGFyc2VkX2luZm8tPm5v
ZmFpbCA/IDAgOiBFWF9GQUlMOwpAQCAtMjI1MCw2ICsyMjc0LDIxIEBAIG1vdW50X3JldHJ5Ogog
CQkJCWFscmVhZHlfdXBwZXJjYXNlZCA9IDE7CiAJCQkJZ290byBtb3VudF9yZXRyeTsKIAkJCX0K
KwkJCWJyZWFrOworCQljYXNlIEVOT0tFWToKKwkJCS8qIG1vdW50IGNvdWxkIGhhdmUgZmFpbGVk
IGJlY2F1c2UgY3J1aWQgb3B0aW9uIHdhcyBub3QgcGFzc2VkIHdoZW4gdHJpZ2dlcmVkIHdpdGgg
c3VkbyAqLworCQkJdmFsdWUgPSBnZXRlbnYoIlNVRE9fVUlEIik7CisJCQlpZiAodmFsdWUgJiYg
IXBhcnNlZF9pbmZvLT5zdWRvX3VpZCkgeworCQkJCWVycm5vID0gMDsKKwkJCQlzdWRvX3VpZCA9
IHN0cnRvdWwodmFsdWUsICZlcCwgMTApOworCQkJCWlmIChlcnJubyA9PSAwICYmICplcCA9PSAn
XDAnICYmIHN1ZG9fdWlkKSB7CisJCQkJCS8qIFJlaW5pdGlhbGl6ZSBwYXJzZWRfaW5mbyBhbmQg
YXNzZW1ibGUgb3B0aW9ucyBhZ2FpbiB3aXRoIHN1ZG9fdWlkICovCisJCQkJCW1lbWNweShwYXJz
ZWRfaW5mbywgcmVpbml0X3BhcnNlZF9pbmZvLCBzaXplb2YoKnBhcnNlZF9pbmZvKSk7CisJCQkJ
CXBhcnNlZF9pbmZvLT5zdWRvX3VpZCA9IHN1ZG9fdWlkOworCQkJCQlnb3RvIGFzc2VtYmxlX3Jl
dHJ5OworCQkJCX0KKwkJCX0KKwkJCWJyZWFrOwogCQl9CiAJCWZwcmludGYoc3RkZXJyLCAibW91
bnQgZXJyb3IoJWQpOiAlc1xuIiwgZXJybm8sCiAJCQlzdHJlcnJvcihlcnJubykpOwpAQCAtMjI3
Niw2ICsyMzE1LDcgQEAgbW91bnRfZXhpdDoKIAkJbWVtc2V0KHBhcnNlZF9pbmZvLT5wYXNzd29y
ZCwgMCwgc2l6ZW9mKHBhcnNlZF9pbmZvLT5wYXNzd29yZCkpOwogCQltdW5tYXAocGFyc2VkX2lu
Zm8sIHNpemVvZigqcGFyc2VkX2luZm8pKTsKIAl9CisJZnJlZShyZWluaXRfcGFyc2VkX2luZm8p
OwogCWZyZWUob3B0aW9ucyk7CiAJZnJlZShvcmdvcHRpb25zKTsKIAlmcmVlKG1vdW50cG9pbnQp
OwotLSAKMi4yNS4xCgo=
--000000000000af433105afcabfd6--
