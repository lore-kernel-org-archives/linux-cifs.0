Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A753DC2D0E4
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Nov 2020 10:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FB68206CA
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Nov 2020 10:25:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cBOY0Eu1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbgK0KZF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 Nov 2020 05:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgK0KZE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 27 Nov 2020 05:25:04 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4D5C0613D1
        for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2020 02:25:04 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id 2so4071725ybc.12
        for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2020 02:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0z7kz1+mgfe3rnye+4KEh4HcV3vgB4a/gI+up3FHRR8=;
        b=cBOY0Eu1RVueLzwOkswc/5bl/SYfI2YOFPbeyC+L03Im/fJv+9sPb8+fKeMTuB9Hzv
         wrNCfvsHnuaayvrjb2aMq64xWyVMwOwyWMZh7YwKnWF+SbxFPRcBOglYMDWdRLklfv/5
         4dY0qApj2HleNBCMo7k4Sx7ecwbRWG7cGN5cbiUs4m4gWV/E5Lm7NJKMSwMREoZT5T/h
         tJK41mUvNLpPjNruC8UxCYcuLGrtpMR81w3xeR2auVohdO4z2jRRsAW8zFEN/zP+td2H
         /chXmBREvgF7KZN4F2bvOuDxzuVZ+tmM/9jYWWX2GMniPKgQaL1/K9sAHqfF5iIJ+C66
         CL7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0z7kz1+mgfe3rnye+4KEh4HcV3vgB4a/gI+up3FHRR8=;
        b=QZOSsaMgD4QOuq+z0YppwAryognK66rnlPLc5nLi8X16PVe/nXc9KulzHgsZqE2mJd
         LLvv8pI3A88eQp1AroGOFwNy8m8cNloQVNv2J9lv6toEq0f4U3PB1jXP7QLxyOg3S4yK
         lMKwIvCV9+5OeeHZnq3z5gN+xUaDwItm2nQppfruPw9WmykXv14SaZO6Jid2ooDB2+u7
         b6/ZzOkOA7wg+t7R95LN+ys6F3M/lBheRPdanTSl9D0E17B+Upw13n27QQL9q/3+RY7T
         9yt5YQXPQgA3nbcVbZpxIRpmZ1MWYlS/oHr9hLHhi6fKpgv/e2FkZ9sATkP3hG/53xIk
         8TeQ==
X-Gm-Message-State: AOAM532qE/UtJBMAvnnQ7BgCHBTrhm8rG5JL6VQQaqxejVD+VlBnXxkw
        aBW0UGnX8LP/MKG9sREwlYz/cRvSuf/A4tOtvNk=
X-Google-Smtp-Source: ABdhPJzdqC31spMaT/GI5LX7DQSRD506hSos9+4aX4boHQ6sItmNFnr7mJiolRnJbz3drIsicSk40euin8Obvmu82uA=
X-Received: by 2002:a25:aea8:: with SMTP id b40mr7793937ybj.34.1606472703548;
 Fri, 27 Nov 2020 02:25:03 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=oiTY63d5yVyywiTrCqpAmvaugMVVpQRV7RT7ZA9HU2+Q@mail.gmail.com>
 <87r1r2ugzw.fsf@suse.com> <CANT5p=qV6BWojwBET+kYUwJf7tQDFoRtUb8O+pWHrqWMw5e5LQ@mail.gmail.com>
 <87wo0slr0c.fsf@suse.com> <CANT5p=rarYr0bErP77GF5QOu8=xx7Ovfy2dWdUNxnOTGkLXMKQ@mail.gmail.com>
 <87o8m4lnig.fsf@suse.com> <CANT5p=rKKZeS+HqonXQF4eaKFTod0rhb56GM4dXkYKhCcDhftw@mail.gmail.com>
 <87lfh3lexw.fsf@suse.com> <CAKywueRcmWYOJ748Tc4jmAD+8HRpNBUG9AtAKhKvm5OmmsT=pw@mail.gmail.com>
In-Reply-To: <CAKywueRcmWYOJ748Tc4jmAD+8HRpNBUG9AtAKhKvm5OmmsT=pw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 27 Nov 2020 15:54:55 +0530
Message-ID: <CANT5p=r2fwDd118_LTvB1PDDNbwzijdwXzF21O7AhpZpjxMU6w@mail.gmail.com>
Subject: Re: [PATCH][SMB3] mount.cifs: use SUDO_UID env variable for cruid
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com
Content-Type: multipart/mixed; boundary="000000000000d6379105b51412ac"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000d6379105b51412ac
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Pavel,

Please consider the attached patch instead of the one I submitted earlier.
Contains the fix to the bug identified by Aurelien.

Regards,
Shyam

On Tue, Nov 10, 2020 at 5:13 AM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> Merged. Thanks!
> --
> Best regards,
> Pavel Shilovsky
>
> =D0=BF=D0=BD, 21 =D1=81=D0=B5=D0=BD=D1=82. 2020 =D0=B3. =D0=B2 01:19, Aur=
=C3=A9lien Aptel <aaptel@suse.com>:
> >
> >
> > Thanks Shyam, looks good to me :)
> >
> > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > Here's the updated patch.
> >
> > Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> >
> > Cheers,
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnber=
g, DE
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)



--=20
-Shyam

--000000000000d6379105b51412ac
Content-Type: application/octet-stream; 
	name="0001-mount.cifs-use-SUDO_UID-env-variable-for-cruid.patch"
Content-Disposition: attachment; 
	filename="0001-mount.cifs-use-SUDO_UID-env-variable-for-cruid.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ki04cyq90>
X-Attachment-Id: f_ki04cyq90

RnJvbSA0OTMzYTA4ZjU5MjU2YmM5ZmRlMzQxZDQzN2Y4NTc4MGIxMjcxODQ5IE1vbiBTZXAgMTcg
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
aXMgYXMgYSBmYWxsYmFjayBvcHRpb24uCklmIG1vdW50IGZhaWxzIHdpdGggRU5PS0VZLCB0aGVu
IHJldHJ5IHdpdGggdGhpcyBvcHRpb24uClRvIGVuYWJsZSB0aGlzIGZhbGxiYWNrLCBJIGhhZCB0
byBtYWtlIGEgZmV3IG1pbm9yIGNoYW5nZXMgaW4gdGhlIGZsb3cuCgpTaWduZWQtb2ZmLWJ5OiBT
aHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29tPgpSZXZpZXdlZC1ieTogQXVyZWxp
ZW4gQXB0ZWwgPGFhcHRlbEBzdXNlLmNvbT4KCi0tLQogbW91bnQuY2lmcy5jIHwgODMgKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLQogMSBmaWxlIGNo
YW5nZWQsIDY3IGluc2VydGlvbnMoKyksIDE2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL21v
dW50LmNpZnMuYyBiL21vdW50LmNpZnMuYwppbmRleCA0ZmViMzk3Li5jMGZiMGU0IDEwMDY0NAot
LS0gYS9tb3VudC5jaWZzLmMKKysrIGIvbW91bnQuY2lmcy5jCkBAIC0xNzEsNyArMTcxLDExIEBA
CiAKICNkZWZpbmUgTlRGU19USU1FX09GRlNFVCAoKHVuc2lnbmVkIGxvbmcgbG9uZykoMzY5KjM2
NSArIDg5KSAqIDI0ICogMzYwMCAqIDEwMDAwMDAwKQogCi0vKiBzdHJ1Y3QgZm9yIGhvbGRpbmcg
cGFyc2VkIG1vdW50IGluZm8gZm9yIHVzZSBieSBwcml2aWxlZ2VkIHByb2Nlc3MgKi8KKy8qCisq
IHN0cnVjdCBmb3IgaG9sZGluZyBwYXJzZWQgbW91bnQgaW5mbyBmb3IgdXNlIGJ5IHByaXZpbGVn
ZWQgcHJvY2Vzcy4KKyogUGxlYXNlIGRvIG5vdCBrZWVwIHBvaW50ZXJzIGluIHRoaXMgc3RydWN0
LgorKiBUaGF0IHdheSwgcmVpbml0IG9mIHRoaXMgc3RydWN0IGlzIGEgc2ltcGxlIG1lbXNldC4K
KyovCiBzdHJ1Y3QgcGFyc2VkX21vdW50X2luZm8gewogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CiAJ
Y2hhciBob3N0W05JX01BWEhPU1QgKyAxXTsKQEAgLTE4OSw2ICsxOTMsOCBAQCBzdHJ1Y3QgcGFy
c2VkX21vdW50X2luZm8gewogCXVuc2lnbmVkIGludCB2ZXJib3NlZmxhZzoxOwogCXVuc2lnbmVk
IGludCBub2ZhaWw6MTsKIAl1bnNpZ25lZCBpbnQgZ290X2RvbWFpbjoxOworCXVuc2lnbmVkIGlu
dCBpc19rcmI1OjE7CisJdWlkX3Qgc3Vkb191aWQ7CiB9OwogCiBzdGF0aWMgY29uc3QgY2hhciAq
dGhpc3Byb2dyYW07CkBAIC04OTEsOSArODk3LDEyIEBAIHBhcnNlX29wdGlvbnMoY29uc3QgY2hh
ciAqZGF0YSwgc3RydWN0IHBhcnNlZF9tb3VudF9pbmZvICpwYXJzZWRfaW5mbykKIAogCQljYXNl
IE9QVF9TRUM6CiAJCQlpZiAodmFsdWUpIHsKLQkJCQlpZiAoIXN0cm5jbXAodmFsdWUsICJub25l
IiwgNCkgfHwKLQkJCQkgICAgIXN0cm5jbXAodmFsdWUsICJrcmI1IiwgNCkpCisJCQkJaWYgKCFz
dHJuY21wKHZhbHVlLCAibm9uZSIsIDQpKQorCQkJCQlwYXJzZWRfaW5mby0+Z290X3Bhc3N3b3Jk
ID0gMTsKKwkJCQlpZiAoIXN0cm5jbXAodmFsdWUsICJrcmI1IiwgNCkpIHsKKwkJCQkJcGFyc2Vk
X2luZm8tPmlzX2tyYjUgPSAxOwogCQkJCQlwYXJzZWRfaW5mby0+Z290X3Bhc3N3b3JkID0gMTsK
KwkJCQl9CiAJCQl9CiAJCQlicmVhazsKIApAQCAtMTE5OSw2ICsxMjA4LDEwIEBAIG5vY29weToK
IAkJc25wcmludGYob3V0ICsgb3V0X2xlbiwgd29yZF9sZW4gKyA1LCAidWlkPSVzIiwgdHh0YnVm
KTsKIAkJb3V0X2xlbiA9IHN0cmxlbihvdXQpOwogCX0KKwlpZiAocGFyc2VkX2luZm8tPmlzX2ty
YjUgJiYgcGFyc2VkX2luZm8tPnN1ZG9fdWlkKSB7CisJCWNydWlkID0gcGFyc2VkX2luZm8tPnN1
ZG9fdWlkOworCQlnb3RfY3J1aWQgPSAxOworCX0KIAlpZiAoZ290X2NydWlkKSB7CiAJCXdvcmRf
bGVuID0gc25wcmludGYodHh0YnVmLCBzaXplb2YodHh0YnVmKSwgIiV1IiwgY3J1aWQpOwogCkBA
IC0yMDEyLDEyICsyMDI1LDE3IEBAIGludCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJndikKIAlj
aGFyICpvcHRpb25zID0gTlVMTDsKIAljaGFyICpvcmlnX2RldiA9IE5VTEw7CiAJY2hhciAqY3Vy
cmVudGFkZHJlc3MsICpuZXh0YWRkcmVzczsKKwljaGFyICp2YWx1ZSA9IE5VTEw7CisJY2hhciAq
ZXAgPSBOVUxMOwogCWludCByYyA9IDA7CiAJaW50IGFscmVhZHlfdXBwZXJjYXNlZCA9IDA7CiAJ
aW50IHNsb3BweSA9IDA7CisJaW50IGZhbGxiYWNrX3N1ZG9fdWlkID0gMDsKIAlzaXplX3Qgb3B0
aW9uc19zaXplID0gTUFYX09QVElPTlNfTEVOOwogCXN0cnVjdCBwYXJzZWRfbW91bnRfaW5mbyAq
cGFyc2VkX2luZm8gPSBOVUxMOworCXN0cnVjdCBwYXJzZWRfbW91bnRfaW5mbyAqcmVpbml0X3Bh
cnNlZF9pbmZvID0gTlVMTDsKIAlwaWRfdCBwaWQ7CisJdWlkX3Qgc3Vkb191aWQgPSAwOwogCiAJ
cmMgPSBjaGVja19zZXR1aWQoKTsKIAlpZiAocmMpCkBAIC0yMDUzLDcgKzIwNzEsMjMgQEAgaW50
IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQogCQlwYXJzZWRfaW5mbyA9IE5VTEw7CiAJCWZw
cmludGYoc3RkZXJyLCAiVW5hYmxlIHRvIGFsbG9jYXRlIG1lbW9yeTogJXNcbiIsCiAJCQkJc3Ry
ZXJyb3IoZXJybm8pKTsKLQkJcmV0dXJuIEVYX1NZU0VSUjsKKwkJcmMgPSBFWF9TWVNFUlI7CisJ
CWdvdG8gbW91bnRfZXhpdDsKKwl9CisKKwlyZWluaXRfcGFyc2VkX2luZm8gPSBtYWxsb2Moc2l6
ZW9mKCpyZWluaXRfcGFyc2VkX2luZm8pKTsKKwlpZiAocmVpbml0X3BhcnNlZF9pbmZvID09IE5V
TEwpIHsKKwkJZnByaW50ZihzdGRlcnIsICJVbmFibGUgdG8gYWxsb2NhdGUgbWVtb3J5OiAlc1xu
IiwKKwkJCQlzdHJlcnJvcihlcnJubykpOworCQlyYyA9IEVYX1NZU0VSUjsKKwkJZ290byBtb3Vu
dF9leGl0OworCX0KKworCW9wdGlvbnMgPSBjYWxsb2Mob3B0aW9uc19zaXplLCAxKTsKKwlpZiAo
IW9wdGlvbnMpIHsKKwkJZnByaW50ZihzdGRlcnIsICJVbmFibGUgdG8gYWxsb2NhdGUgbWVtb3J5
LlxuIik7CisJCXJjID0gRVhfU1lTRVJSOworCQlnb3RvIG1vdW50X2V4aXQ7CiAJfQogCiAJLyog
YWRkIHNoYXJlbmFtZSBpbiBvcHRzIHN0cmluZyBhcyB1bmM9IHBhcm0gKi8KQEAgLTIxMTAsMTAg
KzIxNDQsMTMgQEAgaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQogCS8qIGNoZGlyIGlu
dG8gbW91bnRwb2ludCBhcyBzb29uIGFzIHBvc3NpYmxlICovCiAJcmMgPSBhY3F1aXJlX21vdW50
cG9pbnQoJm1vdW50cG9pbnQpOwogCWlmIChyYykgewotCQlmcmVlKG9yZ29wdGlvbnMpOwotCQly
ZXR1cm4gcmM7CisJCWdvdG8gbW91bnRfZXhpdDsKIAl9CiAKKwkvKiBCZWZvcmUgZ290byBhc3Nl
bWJsZV9yZXRyeSwgcmVpbml0aWFsaXplIHBhcnNlZF9pbmZvIHdpdGggcmVpbml0X3BhcnNlZF9p
bmZvICovCisJbWVtY3B5KHJlaW5pdF9wYXJzZWRfaW5mbywgcGFyc2VkX2luZm8sCXNpemVvZigq
cmVpbml0X3BhcnNlZF9pbmZvKSk7CisKK2Fzc2VtYmxlX3JldHJ5OgogCS8qCiAJICogbW91bnQu
Y2lmcyBkb2VzIHByaXZpbGVnZSBzZXBhcmF0aW9uLiBNb3N0IG9mIHRoZSBjb2RlIHRvIGhhbmRs
ZQogCSAqIGFzc2VtYmxpbmcgdGhlIG1vdW50IGluZm8gaXMgZG9uZSBpbiBhIGNoaWxkIHByb2Nl
c3MgdGhhdCBkcm9wcwpAQCAtMjEzMSw5ICsyMTY4LDcgQEAgaW50IG1haW4oaW50IGFyZ2MsIGNo
YXIgKiphcmd2KQogCQkvKiBjaGlsZCAqLwogCQlyYyA9IGFzc2VtYmxlX21vdW50aW5mbyhwYXJz
ZWRfaW5mbywgdGhpc3Byb2dyYW0sIG1vdW50cG9pbnQsCiAJCQkJCW9yaWdfZGV2LCBvcmdvcHRp
b25zKTsKLQkJZnJlZShvcmdvcHRpb25zKTsKLQkJZnJlZShtb3VudHBvaW50KTsKLQkJcmV0dXJu
IHJjOworCQlnb3RvIG1vdW50X2NoaWxkX2V4aXQ7CiAJfSBlbHNlIHsKIAkJLyogcGFyZW50ICov
CiAJCXBpZCA9IHdhaXQoJnJjKTsKQEAgLTIxNDcsMTkgKzIxODIsMTMgQEAgaW50IG1haW4oaW50
IGFyZ2MsIGNoYXIgKiphcmd2KQogCQkJZ290byBtb3VudF9leGl0OwogCX0KIAotCW9wdGlvbnMg
PSBjYWxsb2Mob3B0aW9uc19zaXplLCAxKTsKLQlpZiAoIW9wdGlvbnMpIHsKLQkJZnByaW50Zihz
dGRlcnIsICJVbmFibGUgdG8gYWxsb2NhdGUgbWVtb3J5LlxuIik7Ci0JCXJjID0gRVhfU1lTRVJS
OwotCQlnb3RvIG1vdW50X2V4aXQ7Ci0JfQotCiAJY3VycmVudGFkZHJlc3MgPSBwYXJzZWRfaW5m
by0+YWRkcmxpc3Q7CiAJbmV4dGFkZHJlc3MgPSBzdHJjaHIoY3VycmVudGFkZHJlc3MsICcsJyk7
CiAJaWYgKG5leHRhZGRyZXNzKQogCQkqbmV4dGFkZHJlc3MrKyA9ICdcMCc7CiAKIG1vdW50X3Jl
dHJ5OgorCW9wdGlvbnNbMF0gPSAnXDAnOwogCWlmICghY3VycmVudGFkZHJlc3MpIHsKIAkJZnBy
aW50ZihzdGRlcnIsICJVbmFibGUgdG8gZmluZCBzdWl0YWJsZSBhZGRyZXNzLlxuIik7CiAJCXJj
ID0gcGFyc2VkX2luZm8tPm5vZmFpbCA/IDAgOiBFWF9GQUlMOwpAQCAtMjI1MCw2ICsyMjc5LDI0
IEBAIG1vdW50X3JldHJ5OgogCQkJCWFscmVhZHlfdXBwZXJjYXNlZCA9IDE7CiAJCQkJZ290byBt
b3VudF9yZXRyeTsKIAkJCX0KKwkJCWJyZWFrOworCQljYXNlIEVOT0tFWToKKwkJCWlmICghZmFs
bGJhY2tfc3Vkb191aWQgJiYgcGFyc2VkX2luZm8tPmlzX2tyYjUpIHsKKwkJCQkvKiBtb3VudCBj
b3VsZCBoYXZlIGZhaWxlZCBiZWNhdXNlIGNydWlkIG9wdGlvbiB3YXMgbm90IHBhc3NlZCB3aGVu
IHRyaWdnZXJlZCB3aXRoIHN1ZG8gKi8KKwkJCQl2YWx1ZSA9IGdldGVudigiU1VET19VSUQiKTsK
KwkJCQlpZiAodmFsdWUpIHsKKwkJCQkJZXJybm8gPSAwOworCQkJCQlzdWRvX3VpZCA9IHN0cnRv
dWwodmFsdWUsICZlcCwgMTApOworCQkJCQlpZiAoZXJybm8gPT0gMCAmJiAqZXAgPT0gJ1wwJyAm
JiBzdWRvX3VpZCkgeworCQkJCQkJLyogUmVpbml0aWFsaXplIHBhcnNlZF9pbmZvIGFuZCBhc3Nl
bWJsZSBvcHRpb25zIGFnYWluIHdpdGggc3Vkb191aWQgKi8KKwkJCQkJCW1lbWNweShwYXJzZWRf
aW5mbywgcmVpbml0X3BhcnNlZF9pbmZvLCBzaXplb2YoKnBhcnNlZF9pbmZvKSk7CisJCQkJCQlw
YXJzZWRfaW5mby0+c3Vkb191aWQgPSBzdWRvX3VpZDsKKwkJCQkJCWZhbGxiYWNrX3N1ZG9fdWlk
ID0gMTsKKwkJCQkJCWdvdG8gYXNzZW1ibGVfcmV0cnk7CisJCQkJCX0KKwkJCQl9CisJCQl9CisJ
CQlicmVhazsKIAkJfQogCQlmcHJpbnRmKHN0ZGVyciwgIm1vdW50IGVycm9yKCVkKTogJXNcbiIs
IGVycm5vLAogCQkJc3RyZXJyb3IoZXJybm8pKTsKQEAgLTIyNzYsNiArMjMyMywxMCBAQCBtb3Vu
dF9leGl0OgogCQltZW1zZXQocGFyc2VkX2luZm8tPnBhc3N3b3JkLCAwLCBzaXplb2YocGFyc2Vk
X2luZm8tPnBhc3N3b3JkKSk7CiAJCW11bm1hcChwYXJzZWRfaW5mbywgc2l6ZW9mKCpwYXJzZWRf
aW5mbykpOwogCX0KKworbW91bnRfY2hpbGRfZXhpdDoKKwkvKiBPYmplY3RzIHRvIGJlIGZyZWVk
IGJvdGggaW4gbWFpbiBwcm9jZXNzIGFuZCBjaGlsZCAqLworCWZyZWUocmVpbml0X3BhcnNlZF9p
bmZvKTsKIAlmcmVlKG9wdGlvbnMpOwogCWZyZWUob3Jnb3B0aW9ucyk7CiAJZnJlZShtb3VudHBv
aW50KTsKLS0gCjIuMjUuMQoK
--000000000000d6379105b51412ac--
