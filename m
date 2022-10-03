Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D94C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Oct 2022 15:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiJCPdA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Oct 2022 11:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiJCPc7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Oct 2022 11:32:59 -0400
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED83027DF3
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 08:32:58 -0700 (PDT)
Received: by mail-vk1-xa34.google.com with SMTP id i5so1838964vka.9
        for <linux-cifs@vger.kernel.org>; Mon, 03 Oct 2022 08:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=lcd/xVvWRJGJ6u+jgugwWW6ZbIMgbRFeQClbu4ACgW0=;
        b=dSWJFvu+TPDya4ZbAgMeYMP9QPgAgJ1Yxqe9pu9NppgNMN15vgoxJ93x0ylLFJYRd+
         93wf5d6nwQmuHlhb3cpsxIVwpvtfOwKwMTzE8/qbNZpSFYfheOMvM8mrVX5l4++uWf1P
         5oTzS3WcVo3z+vjeGDPU8CykwizXNIkssGzkwriYa+IN5y7Kxt+SJalTdzeyErmMrE2d
         f5G/EdDO91f+PCjcowCECJ3oNRgalLhtFnmvdFQmpDKPRnoXhZdv81wB1fG6uUK8dnZT
         buPXAvdnrr5TaTiv1X2a+ufKxrzO9Dx3QEgyZWSxrT8ve8YZ/bkD1ljg1R56LGnJJ/Yd
         YxOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=lcd/xVvWRJGJ6u+jgugwWW6ZbIMgbRFeQClbu4ACgW0=;
        b=KAqvmksf1Or0+OSHQCHCufojm5gvqSx22SAjF4G23GB2ZucwKa8SPc/5qQzfpoLwZ1
         dDt38w12nXudOdbXPoqQgceIW0D/6dPkNuQxUjw3cwnUvOxN2wp5O1WRV+8E9r/W8jMR
         EqmA/baDd9Qlb0EpwfAq4luI1lL+PXMfUYlHr0ED9b5JCPFEHIwQyMhStJ7ZLWLggQql
         OFJxBOEea1yNTIgj2MHbPe0iNeWjLZCBXo7HRRBDDAjDRD/lVYL/gWNqCIXOJWyluiDn
         DLeyyLOElhIbR9PTgnuXO6ikkb8pZSaOx4w4r/++1lKftmIkaD2jWhz1wxf91e9WCSc/
         3wIA==
X-Gm-Message-State: ACrzQf3hCleGCs2O2HJVbfmfL3tdBOi4p6hS9snIA/o1EtavKokghqmr
        iWvx0aTqupU1oux3door+lK91LNkMYwWOpDhb3M=
X-Google-Smtp-Source: AMsMyM4+5912Kc3bOfdcScoufLPriNOqRAROmu3aTfBfb4LbPv/ZfHNSUQpIaUSmndhaHtK6P9SNGREHYs4ekiIpUww=
X-Received: by 2002:a1f:d583:0:b0:3aa:9112:570f with SMTP id
 m125-20020a1fd583000000b003aa9112570fmr1405112vkg.3.1664811161245; Mon, 03
 Oct 2022 08:32:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtzWgXbod2tdZsRvZuhBZsv=H9Vf2GA3Q_bQe0nHhjfiQ@mail.gmail.com>
 <93bf9e29-32b6-7def-3595-598e59c8c46e@talpey.com> <20221003145326.nx2hjsugeiweb2uy@suse.de>
 <50e0c130-8836-8463-ec8f-fb7cfa6cd7ab@talpey.com> <20221003152043.6skowwnlwoidi3yl@suse.de>
 <026fba64-073d-fd2c-644e-1b53c77abc92@talpey.com>
In-Reply-To: <026fba64-073d-fd2c-644e-1b53c77abc92@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 3 Oct 2022 10:32:30 -0500
Message-ID: <CAH2r5mtH8F6FwPTMFO8fe6=LDbqjApuEiUw6cMr9ApL73ziA+g@mail.gmail.com>
Subject: Re: [PATCH][smb311 client] fix oops in smb3_calc_signature
To:     Tom Talpey <tom@talpey.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000e2dce805ea230da4"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e2dce805ea230da4
Content-Type: text/plain; charset="UTF-8"

updated to include a similar initialization in smb2_calc_signature

See attached.

On Mon, Oct 3, 2022 at 10:27 AM Tom Talpey <tom@talpey.com> wrote:
>
> On 10/3/2022 11:20 AM, Enzo Matsumiya wrote:
> > On 10/03, Tom Talpey wrote:
> >> On 10/3/2022 10:53 AM, Enzo Matsumiya wrote:
> >>> On 10/03, Tom Talpey wrote:
> >>>> On 10/2/2022 11:54 PM, Steve French wrote:
> >>>>> shash was not being initialized in one place in smb3_calc_signature
> >>>>>
> >>>>> Suggested-by: Enzo Matsumiya <ematsumiya@suse.de>
> >>>>> Signed-off-by: Steve French <stfrench@microsoft.com>
> >>>>>
> >>>>
> >>>> I don't see the issue. The shash pointer is initialized in both
> >>>> arms of the "if (allocate_crypto)" block.
> >>>
> >>> True, but cifs_alloc_hash() returns 0 if *sdesc is not NULL, so
> >>> crypto_shash_setkey() got stack garbage as sdesc.
> >>
> >> Sorry, I still don't get it.
> >>
> >>     if (allocate_crypto) {
> >>         rc = cifs_alloc_hash("cmac(aes)", &hash, &sdesc);
> >
> > I think you're looking at an old HEAD.  We've hit this bug after my
> > patch 10c6c7b0f060 "cifs: secmech: use shash_desc directly, remove sdesc"
>
> Aha. But I'm looking at Steve's current cifs-2.6. Where should
> I be looking?
>
>
> Tom.
>
>
> > which changes the above line to:
> >
> >          rc = cifs_alloc_hash("cmac(aes)", &shash);
> >
> > In that patch, shash is the only struct to be initialized.
> > cifs_alloc_hash() is:
> >
> > cifs_alloc_hash(const char *name, struct shash_desc **sdesc)
> > {
> >         int rc = 0;
> >         struct crypto_shash *alg = NULL;
> >
> >         if (*sdesc)
> >                 return 0;
> > ...
> >
> > Hence, sdesc having the stack garbage, cifs_alloc_hash returns 0 and
> > crypto_shash_setkey crashes.
> >
> >>         if (rc)
> >>             return rc;
> >>
> >>         shash = &sdesc->shash;
> >>     } else {
> >>         hash = server->secmech.cmacaes;
> >>         shash = &server->secmech.sdesccmacaes->shash;
> >>     }
> >>
> >> The "shash" pointer is initialized one line later.
> >> And, "sdesc" is already initilized to NULL.
> >>
> >> Steve's patch initializes "shash", but now you're referring to
> >> sdesc, and it still looks correct to me. Confused...
> >>
> >>>> But if you do want to add this, them smb2_calc_signature has
> >>>> the same code.
> >>>
> >>> True.  Steve will you add it to this patch please?
> >>
> >> FYI, smb2_calc_signature() also initializes sdesc, and not shash.
> >> Does it not oops? Same code.
> >>
> >> Tom.
> >



-- 
Thanks,

Steve

--000000000000e2dce805ea230da4
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-oops-in-calculating-shash_setkey.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-oops-in-calculating-shash_setkey.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l8sxkngu0>
X-Attachment-Id: f_l8sxkngu0

RnJvbSAxMWIxYzk4ZDA5ODYxYzY1ZDc4MTVmMWRjNDYzMWU0ZWQ2ZWI0NGExIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgMiBPY3QgMjAyMiAyMjowOTo0NSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGZpeCBvb3BzIGluIGNhbGN1bGF0aW5nIHNoYXNoX3NldGtleQoKc2hhc2ggd2FzIG5vdCBi
ZWluZyBpbml0aWFsaXplZCBpbiBvbmUgcGxhY2UgaW4gc21iM19jYWxjX3NpZ25hdHVyZQphbmQg
c21iMl9jYWxjX3NpZ25hdHVyZQoKUmV2aWV3ZWQtYnk6IEVuem8gTWF0c3VtaXlhIDxlbWF0c3Vt
aXlhQHN1c2UuZGU+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9z
b2Z0LmNvbT4KLS0tCiBmcy9jaWZzL3NtYjJ0cmFuc3BvcnQuYyB8IDQgKystLQogMSBmaWxlIGNo
YW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9j
aWZzL3NtYjJ0cmFuc3BvcnQuYyBiL2ZzL2NpZnMvc21iMnRyYW5zcG9ydC5jCmluZGV4IGRmY2Jj
YzBiODZlNC4uOGUzZjI2ZTZmNmI5IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJ0cmFuc3BvcnQu
YworKysgYi9mcy9jaWZzL3NtYjJ0cmFuc3BvcnQuYwpAQCAtMjE1LDcgKzIxNSw3IEBAIHNtYjJf
Y2FsY19zaWduYXR1cmUoc3RydWN0IHNtYl9ycXN0ICpycXN0LCBzdHJ1Y3QgVENQX1NlcnZlcl9J
bmZvICpzZXJ2ZXIsCiAJc3RydWN0IGt2ZWMgKmlvdiA9IHJxc3QtPnJxX2lvdjsKIAlzdHJ1Y3Qg
c21iMl9oZHIgKnNoZHIgPSAoc3RydWN0IHNtYjJfaGRyICopaW92WzBdLmlvdl9iYXNlOwogCXN0
cnVjdCBjaWZzX3NlcyAqc2VzOwotCXN0cnVjdCBzaGFzaF9kZXNjICpzaGFzaDsKKwlzdHJ1Y3Qg
c2hhc2hfZGVzYyAqc2hhc2ggPSBOVUxMOwogCXN0cnVjdCBzbWJfcnFzdCBkcnFzdDsKIAogCXNl
cyA9IHNtYjJfZmluZF9zbWJfc2VzKHNlcnZlciwgbGU2NF90b19jcHUoc2hkci0+U2Vzc2lvbklk
KSk7CkBAIC01MzUsNyArNTM1LDcgQEAgc21iM19jYWxjX3NpZ25hdHVyZShzdHJ1Y3Qgc21iX3Jx
c3QgKnJxc3QsIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwKIAl1bnNpZ25lZCBjaGFy
ICpzaWdwdHIgPSBzbWIzX3NpZ25hdHVyZTsKIAlzdHJ1Y3Qga3ZlYyAqaW92ID0gcnFzdC0+cnFf
aW92OwogCXN0cnVjdCBzbWIyX2hkciAqc2hkciA9IChzdHJ1Y3Qgc21iMl9oZHIgKilpb3ZbMF0u
aW92X2Jhc2U7Ci0Jc3RydWN0IHNoYXNoX2Rlc2MgKnNoYXNoOworCXN0cnVjdCBzaGFzaF9kZXNj
ICpzaGFzaCA9IE5VTEw7CiAJc3RydWN0IHNtYl9ycXN0IGRycXN0OwogCXU4IGtleVtTTUIzX1NJ
R05fS0VZX1NJWkVdOwogCi0tIAoyLjM0LjEKCg==
--000000000000e2dce805ea230da4--
