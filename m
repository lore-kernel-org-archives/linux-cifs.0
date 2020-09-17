Return-Path: <SRS0=/4jl=C2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52876C433E2
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Sep 2020 09:11:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E906E2076D
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Sep 2020 09:11:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TTaPfCE9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgIQJLr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Sep 2020 05:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgIQJLq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Sep 2020 05:11:46 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C00C061756
        for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2020 02:11:45 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id s19so1175455ybc.5
        for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2020 02:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KpxuBRJPq19VImCkGX9TX/K9XKyOEtIMlm5vPUSZY14=;
        b=TTaPfCE96hbl4PccKsqyOdHtpdGZi2A5/DN7YP2xwxv+R7bGShoXVmC5WD7k9iO56f
         YnbALUcgGoZ5T7Lk9khMwuHcI1KFks7krl9BJx/vrutBf2kEy8QW9XFTamMaDKQkKkGF
         hpqy8BeB0lirRPuKn3b7I2X2YnIe523/q8+dg3qyDllsZ4sG6r2rp0HkkDAb6/eDDn28
         q49ZMaPj+N4xBqVJI4HS8xIpqfknJJzo3rw5zJZV5URcNqSGdfjASO/lPazR5qJdx7lW
         MtcECpemViZTJN8KO9VkhYDJ/8HhwWkUll/HG6o732YROWY+4jD8LTj+hVeMSusubgfK
         jGVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KpxuBRJPq19VImCkGX9TX/K9XKyOEtIMlm5vPUSZY14=;
        b=mj4vRWlPJfa0QgXkzNsMcxlb2JTeZVHgDcQcloIBaT+NmJ19eM3YE3puJ0SaIkIiMf
         zuXz1UNJt+CI0KTmC/vtQWyRfsIrQpJnjdntQfFAuFrK2pLEo9NJ1VVPKNQmF4ipa6Lm
         bOcLy2kTjZwNVSlXqkNMXn5M8MTumd5mHiUKo8MmwHqV9dv2Btr9aeFgAhIxszSfB0Cb
         72wLnH/jub0bn1rYi41trlD30aPGW+PyVrVA5OhXpAH3XbJsySYUAYB3XP6b++PVesMK
         DgXUjrXxzWpSr4dY/lV711d7S4mU7HZIdc4EJ2jqGCvc0j+0abQ5+Ko9yajiN4GhQTqb
         QdLg==
X-Gm-Message-State: AOAM530lBrvG+1N4BONlr5ofq1IOXOQ67Q5KBaFyXLne2ZG9GG+Sl0eL
        phDn2f8PG/hE/Um4O16YC5WfQXtQZExdjF9IFIk=
X-Google-Smtp-Source: ABdhPJyOhwoTO0fVh2uf6qH5SXjGIcx2eIqf8aNwkX+Gj6mSi6dRg3UdIpTJWIZx+Tynpq8qVhDZnoU4PNctXgGW6Gk=
X-Received: by 2002:a25:aca3:: with SMTP id x35mr37584772ybi.3.1600333904560;
 Thu, 17 Sep 2020 02:11:44 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=oiTY63d5yVyywiTrCqpAmvaugMVVpQRV7RT7ZA9HU2+Q@mail.gmail.com>
 <87r1r2ugzw.fsf@suse.com> <CANT5p=qV6BWojwBET+kYUwJf7tQDFoRtUb8O+pWHrqWMw5e5LQ@mail.gmail.com>
 <87wo0slr0c.fsf@suse.com>
In-Reply-To: <87wo0slr0c.fsf@suse.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 17 Sep 2020 14:41:34 +0530
Message-ID: <CANT5p=rarYr0bErP77GF5QOu8=xx7Ovfy2dWdUNxnOTGkLXMKQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3] mount.cifs: use SUDO_UID env variable for cruid
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com
Content-Type: multipart/mixed; boundary="000000000000e7600c05af7ec5ad"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e7600c05af7ec5ad
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Attaching the patch with the review comments incorporated.
Tested a few positive and negative test cases. Works as expected.

Regards,
Shyam

On Thu, Sep 17, 2020 at 2:27 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
> >> This function later forks, so if you allocate before the fork, you nee=
d
> >> to free in parent and in the child.
> >
> > Good point.
> > I think I'm doing it right though. I allocate all that I need at the be=
ginning.
> > And the function always terminates in mount_exit, both for parent and
> > child. That is where the allocations are freed.
>
> Ah yes ok
>
> > I know the child will have the options buffer unnecessarily allocated,
> > but isn't the code flow simpler this way?
> > Please let me know if you see an issue there.
>
> No it's fine I think
>
> > Good catch. This code existed before my changes, and I had noted this
> > bug. But forgot it during my changes. :)
> > I was actually confused if I should reset after the label, or before th=
e goto.
> > After the label is an added overhead in the "happy" code path, so went
> > with this. But it does reduce the chances of missing out a reset.
> > For now I'll reset options before each goto mount_retry. Please let me
> > know if you feel the other approach is better.
>
> I think we can agree that mount.cifs is not performance critical code
> but that it should be safe so I think reset after the label is
> better. (To be honnest the whole function could use some refactoring and
> be split up probably, but that can be a patch for later on)
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

--000000000000e7600c05af7ec5ad
Content-Type: application/octet-stream; 
	name="0001-mount.cifs-use-SUDO_UID-env-variable-for-cruid.patch"
Content-Disposition: attachment; 
	filename="0001-mount.cifs-use-SUDO_UID-env-variable-for-cruid.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kf6leu7z0>
X-Attachment-Id: f_kf6leu7z0

RnJvbSBiMGQ5ZmYxNDkwY2EyOTczY2JlODcwMWU5YzFkNjVkZWQwMzY2YjhjIE1vbiBTZXAgMTcg
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
b3VudC5jaWZzLmMgfCA2OSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Ky0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNTUgaW5zZXJ0aW9ucygrKSwgMTQgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvbW91bnQuY2lmcy5jIGIvbW91bnQuY2lmcy5jCmluZGV4IDRm
ZWIzOTcuLjY5MjJkMjQgMTAwNjQ0Ci0tLSBhL21vdW50LmNpZnMuYworKysgYi9tb3VudC5jaWZz
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
ZXR1aWQoKTsKIAlpZiAocmMpCkBAIC0yMDUzLDcgKzIwNjYsMjQgQEAgaW50IG1haW4oaW50IGFy
Z2MsIGNoYXIgKiphcmd2KQogCQlwYXJzZWRfaW5mbyA9IE5VTEw7CiAJCWZwcmludGYoc3RkZXJy
LCAiVW5hYmxlIHRvIGFsbG9jYXRlIG1lbW9yeTogJXNcbiIsCiAJCQkJc3RyZXJyb3IoZXJybm8p
KTsKLQkJcmV0dXJuIEVYX1NZU0VSUjsKKwkJcmMgPSBFWF9TWVNFUlI7CisJCWdvdG8gbW91bnRf
ZXhpdDsKKwl9CisKKwlyZWluaXRfcGFyc2VkX2luZm8gPSAKKwkJKHN0cnVjdCBwYXJzZWRfbW91
bnRfaW5mbyAqKSBtYWxsb2Moc2l6ZW9mKCpyZWluaXRfcGFyc2VkX2luZm8pKTsKKwlpZiAocmVp
bml0X3BhcnNlZF9pbmZvID09IE5VTEwpIHsKKwkJZnByaW50ZihzdGRlcnIsICJVbmFibGUgdG8g
YWxsb2NhdGUgbWVtb3J5OiAlc1xuIiwKKwkJCQlzdHJlcnJvcihlcnJubykpOworCQlyYyA9IEVY
X1NZU0VSUjsKKwkJZ290byBtb3VudF9leGl0OworCX0KKworCW9wdGlvbnMgPSBjYWxsb2Mob3B0
aW9uc19zaXplLCAxKTsKKwlpZiAoIW9wdGlvbnMpIHsKKwkJZnByaW50ZihzdGRlcnIsICJVbmFi
bGUgdG8gYWxsb2NhdGUgbWVtb3J5LlxuIik7CisJCXJjID0gRVhfU1lTRVJSOworCQlnb3RvIG1v
dW50X2V4aXQ7CiAJfQogCiAJLyogYWRkIHNoYXJlbmFtZSBpbiBvcHRzIHN0cmluZyBhcyB1bmM9
IHBhcm0gKi8KQEAgLTIxMTAsMTAgKzIxNDAsMTMgQEAgaW50IG1haW4oaW50IGFyZ2MsIGNoYXIg
Kiphcmd2KQogCS8qIGNoZGlyIGludG8gbW91bnRwb2ludCBhcyBzb29uIGFzIHBvc3NpYmxlICov
CiAJcmMgPSBhY3F1aXJlX21vdW50cG9pbnQoJm1vdW50cG9pbnQpOwogCWlmIChyYykgewotCQlm
cmVlKG9yZ29wdGlvbnMpOwotCQlyZXR1cm4gcmM7CisJCWdvdG8gbW91bnRfZXhpdDsKIAl9CiAK
KwkvKiBCZWZvcmUgZ290byBhc3NlbWJsZV9yZXRyeSwgcmVpbml0aWFsaXplIHBhcnNlZF9pbmZv
IHdpdGggcmVpbml0X3BhcnNlZF9pbmZvICovCisJbWVtY3B5KHJlaW5pdF9wYXJzZWRfaW5mbywg
cGFyc2VkX2luZm8sCXNpemVvZigqcmVpbml0X3BhcnNlZF9pbmZvKSk7CisKK2Fzc2VtYmxlX3Jl
dHJ5OgogCS8qCiAJICogbW91bnQuY2lmcyBkb2VzIHByaXZpbGVnZSBzZXBhcmF0aW9uLiBNb3N0
IG9mIHRoZSBjb2RlIHRvIGhhbmRsZQogCSAqIGFzc2VtYmxpbmcgdGhlIG1vdW50IGluZm8gaXMg
ZG9uZSBpbiBhIGNoaWxkIHByb2Nlc3MgdGhhdCBkcm9wcwpAQCAtMjEzMSw5ICsyMTY0LDcgQEAg
aW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQogCQkvKiBjaGlsZCAqLwogCQlyYyA9IGFz
c2VtYmxlX21vdW50aW5mbyhwYXJzZWRfaW5mbywgdGhpc3Byb2dyYW0sIG1vdW50cG9pbnQsCiAJ
CQkJCW9yaWdfZGV2LCBvcmdvcHRpb25zKTsKLQkJZnJlZShvcmdvcHRpb25zKTsKLQkJZnJlZSht
b3VudHBvaW50KTsKLQkJcmV0dXJuIHJjOworCQlnb3RvIG1vdW50X2V4aXQ7CiAJfSBlbHNlIHsK
IAkJLyogcGFyZW50ICovCiAJCXBpZCA9IHdhaXQoJnJjKTsKQEAgLTIxNDcsMTkgKzIxNzgsMTMg
QEAgaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQogCQkJZ290byBtb3VudF9leGl0Owog
CX0KIAotCW9wdGlvbnMgPSBjYWxsb2Mob3B0aW9uc19zaXplLCAxKTsKLQlpZiAoIW9wdGlvbnMp
IHsKLQkJZnByaW50ZihzdGRlcnIsICJVbmFibGUgdG8gYWxsb2NhdGUgbWVtb3J5LlxuIik7Ci0J
CXJjID0gRVhfU1lTRVJSOwotCQlnb3RvIG1vdW50X2V4aXQ7Ci0JfQotCiAJY3VycmVudGFkZHJl
c3MgPSBwYXJzZWRfaW5mby0+YWRkcmxpc3Q7CiAJbmV4dGFkZHJlc3MgPSBzdHJjaHIoY3VycmVu
dGFkZHJlc3MsICcsJyk7CiAJaWYgKG5leHRhZGRyZXNzKQogCQkqbmV4dGFkZHJlc3MrKyA9ICdc
MCc7CiAKIG1vdW50X3JldHJ5OgorCW9wdGlvbnNbMF0gPSAnXDAnOwogCWlmICghY3VycmVudGFk
ZHJlc3MpIHsKIAkJZnByaW50ZihzdGRlcnIsICJVbmFibGUgdG8gZmluZCBzdWl0YWJsZSBhZGRy
ZXNzLlxuIik7CiAJCXJjID0gcGFyc2VkX2luZm8tPm5vZmFpbCA/IDAgOiBFWF9GQUlMOwpAQCAt
MjI1MCw2ICsyMjc1LDIxIEBAIG1vdW50X3JldHJ5OgogCQkJCWFscmVhZHlfdXBwZXJjYXNlZCA9
IDE7CiAJCQkJZ290byBtb3VudF9yZXRyeTsKIAkJCX0KKwkJCWJyZWFrOworCQljYXNlIEVOT0tF
WToKKwkJCS8qIG1vdW50IGNvdWxkIGhhdmUgZmFpbGVkIGJlY2F1c2UgY3J1aWQgb3B0aW9uIHdh
cyBub3QgcGFzc2VkIHdoZW4gdHJpZ2dlcmVkIHdpdGggc3VkbyAqLworCQkJdmFsdWUgPSBnZXRl
bnYoIlNVRE9fVUlEIik7CisJCQlpZiAodmFsdWUgJiYgIXBhcnNlZF9pbmZvLT5zdWRvX3VpZCkg
eworCQkJCWVycm5vID0gMDsKKwkJCQlzdWRvX3VpZCA9IHN0cnRvdWwodmFsdWUsICZlcCwgMTAp
OworCQkJCWlmIChlcnJubyA9PSAwICYmICplcCA9PSAnXDAnICYmIHN1ZG9fdWlkKSB7CisJCQkJ
CS8qIFJlaW5pdGlhbGl6ZSBwYXJzZWRfaW5mbyBhbmQgYXNzZW1ibGUgb3B0aW9ucyBhZ2FpbiB3
aXRoIHN1ZG9fdWlkICovCisJCQkJCW1lbWNweShwYXJzZWRfaW5mbywgcmVpbml0X3BhcnNlZF9p
bmZvLCBzaXplb2YoKnBhcnNlZF9pbmZvKSk7CisJCQkJCXBhcnNlZF9pbmZvLT5zdWRvX3VpZCA9
IHN1ZG9fdWlkOworCQkJCQlnb3RvIGFzc2VtYmxlX3JldHJ5OworCQkJCX0KKwkJCX0KKwkJCWJy
ZWFrOwogCQl9CiAJCWZwcmludGYoc3RkZXJyLCAibW91bnQgZXJyb3IoJWQpOiAlc1xuIiwgZXJy
bm8sCiAJCQlzdHJlcnJvcihlcnJubykpOwpAQCAtMjI3Niw2ICsyMzE2LDcgQEAgbW91bnRfZXhp
dDoKIAkJbWVtc2V0KHBhcnNlZF9pbmZvLT5wYXNzd29yZCwgMCwgc2l6ZW9mKHBhcnNlZF9pbmZv
LT5wYXNzd29yZCkpOwogCQltdW5tYXAocGFyc2VkX2luZm8sIHNpemVvZigqcGFyc2VkX2luZm8p
KTsKIAl9CisJZnJlZShyZWluaXRfcGFyc2VkX2luZm8pOwogCWZyZWUob3B0aW9ucyk7CiAJZnJl
ZShvcmdvcHRpb25zKTsKIAlmcmVlKG1vdW50cG9pbnQpOwotLSAKMi4yNS4xCgo=
--000000000000e7600c05af7ec5ad--
