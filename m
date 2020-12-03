Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB426C4361A
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 23:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B55C221EC
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 23:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731152AbgLCXNh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Dec 2020 18:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgLCXNg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Dec 2020 18:13:36 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F2BC061A53
        for <linux-cifs@vger.kernel.org>; Thu,  3 Dec 2020 15:12:56 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id d20so5149236lfe.11
        for <linux-cifs@vger.kernel.org>; Thu, 03 Dec 2020 15:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vTaXQz17KhUVKrG6BCNjQCSMgzCLxdnQJswybcfsHYA=;
        b=aOMw78DBsLlLnumaBgjX39pAUqHokLzftdjL3kX7ZpfodmLHFHQiuCoX2vkL2ngngX
         bSFWqiAftuQDY8hRyQzR/rPbQQXBX9R3sGJnlo/jBhp5A0CgpQkT2y6tI3xgeRC35zao
         ZC15UwF+TAfaVKpdlpVvQBDTPCB57AZ0JMf81kbi+8YMOZQ8Sr9f9c1T/DUwx8uewFb7
         dc+vsTTnWhxO6GaKIkaFUfxev9dbOu1wZerYG0yhuFvHO0naMzBHnA/9/ZjovProll8K
         Cl7Q21vRmye1+CG6v2i0yoegV/Gmja7QLs6z0zFFYHdbkf5ESwkvVERHWf6yGQROpmnZ
         RAzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vTaXQz17KhUVKrG6BCNjQCSMgzCLxdnQJswybcfsHYA=;
        b=as/vvIsnMYHePVI6iKeJs1f9UrXW4LGYaHBH6e7fr/zavfjS5+q6WLuR3dTT4QLhOu
         r9G+9rfZmPg8x7lpfh+CXjtpc8gcj7K/KxtKNAjEtE+FjsPvJllWKMT+FS03QUI1pT+E
         qbjZIgYDnj3OOythd4YUsslEbmvkCAKw2fihzA4utK7ydu8hxBVl9hbRlZjfLTNr6Fzg
         Nl27adQDZwXB23z71o4+BCQ0lprZZCs0KBuukb+JJdDCDwhi4boKfeSvZ62kv26Ezypz
         5DroATJWDVjffXfYtiDvJUXP1dVc1DWu3CdE6BKi1jE//5wJQsKlXcz9SWf8QL8d/fvC
         UQPg==
X-Gm-Message-State: AOAM530dcWbD2yFJJK1KNByVTsVGV4a3lWjTchJvGrnQJEc6cbY2t9R0
        9SHU4QoRpZAooohl8TGprpvJ7uwhH94kelcC+d8=
X-Google-Smtp-Source: ABdhPJzYrNc5OnFEmXfiGIKfiQi8WoXPiB8Sphxp6ZlfxlTljV0QCtnJo9twGXq3se1cgLjZYTPSi0SBfgs2fxkj5k4=
X-Received: by 2002:a19:4941:: with SMTP id l1mr2300746lfj.136.1607037174532;
 Thu, 03 Dec 2020 15:12:54 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtkt6-ezyTC6zoi+DBjYQ3qFwW3UneF0_4qETEt51Tm9w@mail.gmail.com>
 <CAH2r5mt+=ELCwSASFsPPjET=qf80_1tOTMPN-gG9cF=BQd-VBg@mail.gmail.com>
 <CAH2r5mv9_gvVtmBNSBDdnqkMAZMo9+fQExdgYEb+jEAMY4ad3A@mail.gmail.com> <CAN05THQuT8wf=-z1z5ERmEdfS4Nf72gHJiFUF_wbopR7FX-VQQ@mail.gmail.com>
In-Reply-To: <CAN05THQuT8wf=-z1z5ERmEdfS4Nf72gHJiFUF_wbopR7FX-VQQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 3 Dec 2020 17:12:42 -0600
Message-ID: <CAH2r5mvC0cLMyfWcvt-v=V4=u-EptB+_vrjemWLdawXQ=bH_gg@mail.gmail.com>
Subject: Re: [SMB3][PATCH] ifs: refactor create_sd_buf() and and avoid
 corrupting the buffer
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000edf44605b5977fca"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000edf44605b5977fca
Content-Type: text/plain; charset="UTF-8"

Updated with Ronnie's suggestion.


On Thu, Dec 3, 2020 at 4:08 PM ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
>
> LGTM.
>
> Maybe move acl.AclRevision down to where the other fields are assigned
> so they are all assigned in the same place?
>
> On Fri, Dec 4, 2020 at 2:46 AM Steve French <smfrench@gmail.com> wrote:
> >
> > updated the patch slightly by creating local variable for ace_count
> > and acl_size to avoid excessive endian conversions
> >
> > On Mon, Nov 30, 2020 at 10:19 PM Steve French <smfrench@gmail.com> wrote:
> > >
> > > Updated patch with fixes for various endian sparse warnings
> > >
> > >
> > > On Mon, Nov 30, 2020 at 12:02 AM Steve French <smfrench@gmail.com> wrote:
> > > >
> > > > When mounting with "idsfromsid" mount option, Azure
> > > > corrupted the owner SIDs due to excessive padding
> > > > caused by placing the owner fields at the end of the
> > > > security descriptor on create.  Placing owners at the
> > > > front of the security descriptor (rather than the end)
> > > > is also safer, as the number of ACEs (that follow it)
> > > > are variable.
> > > >
> > > > --
> > > > Thanks,
> > > >
> > > > Steve
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve



-- 
Thanks,

Steve

--000000000000edf44605b5977fca
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-refactor-create_sd_buf-and-and-avoid-corrupting.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-refactor-create_sd_buf-and-and-avoid-corrupting.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ki9gfkrr0>
X-Attachment-Id: f_ki9gfkrr0

RnJvbSA2MmU3MTgwNWM3ODNlYzQwYzViMWUzZGVlNjVjMTZhM2E3M2IxMjBlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+
CkRhdGU6IE1vbiwgMzAgTm92IDIwMjAgMTE6Mjk6MjAgKzEwMDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiByZWZhY3RvciBjcmVhdGVfc2RfYnVmKCkgYW5kIGFuZCBhdm9pZCBjb3JydXB0aW5nIHRo
ZQogYnVmZmVyCgpXaGVuIG1vdW50aW5nIHdpdGggImlkc2Zyb21zaWQiIG1vdW50IG9wdGlvbiwg
QXp1cmUKY29ycnVwdGVkIHRoZSBvd25lciBTSURzIGR1ZSB0byBleGNlc3NpdmUgcGFkZGluZwpj
YXVzZWQgYnkgcGxhY2luZyB0aGUgb3duZXIgZmllbGRzIGF0IHRoZSBlbmQgb2YgdGhlCnNlY3Vy
aXR5IGRlc2NyaXB0b3Igb24gY3JlYXRlLiAgUGxhY2luZyBvd25lcnMgYXQgdGhlCmZyb250IG9m
IHRoZSBzZWN1cml0eSBkZXNjcmlwdG9yIChyYXRoZXIgdGhhbiB0aGUgZW5kKQppcyBhbHNvIHNh
ZmVyLCBhcyB0aGUgbnVtYmVyIG9mIEFDRXMgKHRoYXQgZm9sbG93IGl0KQphcmUgdmFyaWFibGUu
CgpTaWduZWQtb2ZmLWJ5OiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+ClN1
Z2dlc3RlZC1ieTogUm9oaXRoIFN1cmFiYXR0dWxhIDxyb2hpdGhzQG1pY3Jvc29mdC5jb20+CkND
OiBTdGFibGUgPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+ICMgdjUuOApTaWduZWQtb2ZmLWJ5OiBT
dGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIycGR1
LmMgfCA3MSArKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQog
ZnMvY2lmcy9zbWIycGR1LmggfCAgMiAtLQogMiBmaWxlcyBjaGFuZ2VkLCAzOCBpbnNlcnRpb25z
KCspLCAzNSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuYyBiL2Zz
L2NpZnMvc21iMnBkdS5jCmluZGV4IDQ0NWU4MDg2Mjg2NS4uYWNiNzI3MDUwNjJkIDEwMDY0NAot
LS0gYS9mcy9jaWZzL3NtYjJwZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUuYwpAQCAtMjI3Miwx
NyArMjI3MiwxNSBAQCBzdGF0aWMgc3RydWN0IGNydF9zZF9jdHh0ICoKIGNyZWF0ZV9zZF9idWYo
dW1vZGVfdCBtb2RlLCBib29sIHNldF9vd25lciwgdW5zaWduZWQgaW50ICpsZW4pCiB7CiAJc3Ry
dWN0IGNydF9zZF9jdHh0ICpidWY7Ci0Jc3RydWN0IGNpZnNfYWNlICpwYWNlOwotCXVuc2lnbmVk
IGludCBzZGxlbiwgYWNlbGVuOworCV9fdTggKnB0ciwgKmFjbHB0cjsKKwl1bnNpZ25lZCBpbnQg
YWNlbGVuLCBhY2xfc2l6ZSwgYWNlX2NvdW50OwogCXVuc2lnbmVkIGludCBvd25lcl9vZmZzZXQg
PSAwOwogCXVuc2lnbmVkIGludCBncm91cF9vZmZzZXQgPSAwOworCXN0cnVjdCBzbWIzX2FjbCBh
Y2w7CiAKLQkqbGVuID0gcm91bmR1cChzaXplb2Yoc3RydWN0IGNydF9zZF9jdHh0KSArIChzaXpl
b2Yoc3RydWN0IGNpZnNfYWNlKSAqIDIpLCA4KTsKKwkqbGVuID0gcm91bmR1cChzaXplb2Yoc3Ry
dWN0IGNydF9zZF9jdHh0KSArIChzaXplb2Yoc3RydWN0IGNpZnNfYWNlKSAqIDQpLCA4KTsKIAog
CWlmIChzZXRfb3duZXIpIHsKLQkJLyogb2Zmc2V0IGZpZWxkcyBhcmUgZnJvbSBiZWdpbm5pbmcg
b2Ygc2VjdXJpdHkgZGVzY3JpcHRvciBub3Qgb2YgY3JlYXRlIGNvbnRleHQgKi8KLQkJb3duZXJf
b2Zmc2V0ID0gc2l6ZW9mKHN0cnVjdCBzbWIzX2FjbCkgKyAoc2l6ZW9mKHN0cnVjdCBjaWZzX2Fj
ZSkgKiAyKTsKLQogCQkvKiBzaXplb2Yoc3RydWN0IG93bmVyX2dyb3VwX3NpZHMpIGlzIGFscmVh
ZHkgbXVsdGlwbGUgb2YgOCBzbyBubyBuZWVkIHRvIHJvdW5kICovCiAJCSpsZW4gKz0gc2l6ZW9m
KHN0cnVjdCBvd25lcl9ncm91cF9zaWRzKTsKIAl9CkBAIC0yMjkxLDI2ICsyMjg5LDIyIEBAIGNy
ZWF0ZV9zZF9idWYodW1vZGVfdCBtb2RlLCBib29sIHNldF9vd25lciwgdW5zaWduZWQgaW50ICps
ZW4pCiAJaWYgKGJ1ZiA9PSBOVUxMKQogCQlyZXR1cm4gYnVmOwogCisJcHRyID0gKF9fdTggKikm
YnVmWzFdOwogCWlmIChzZXRfb3duZXIpIHsKKwkJLyogb2Zmc2V0IGZpZWxkcyBhcmUgZnJvbSBi
ZWdpbm5pbmcgb2Ygc2VjdXJpdHkgZGVzY3JpcHRvciBub3Qgb2YgY3JlYXRlIGNvbnRleHQgKi8K
KwkJb3duZXJfb2Zmc2V0ID0gcHRyIC0gKF9fdTggKikmYnVmLT5zZDsKIAkJYnVmLT5zZC5PZmZz
ZXRPd25lciA9IGNwdV90b19sZTMyKG93bmVyX29mZnNldCk7Ci0JCWdyb3VwX29mZnNldCA9IG93
bmVyX29mZnNldCArIHNpemVvZihzdHJ1Y3Qgb3duZXJfc2lkKTsKKwkJZ3JvdXBfb2Zmc2V0ID0g
b3duZXJfb2Zmc2V0ICsgb2Zmc2V0b2Yoc3RydWN0IG93bmVyX2dyb3VwX3NpZHMsIGdyb3VwKTsK
IAkJYnVmLT5zZC5PZmZzZXRHcm91cCA9IGNwdV90b19sZTMyKGdyb3VwX29mZnNldCk7CisKKwkJ
c2V0dXBfb3duZXJfZ3JvdXBfc2lkcyhwdHIpOworCQlwdHIgKz0gc2l6ZW9mKHN0cnVjdCBvd25l
cl9ncm91cF9zaWRzKTsKIAl9IGVsc2UgewogCQlidWYtPnNkLk9mZnNldE93bmVyID0gMDsKIAkJ
YnVmLT5zZC5PZmZzZXRHcm91cCA9IDA7CiAJfQogCi0Jc2RsZW4gPSBzaXplb2Yoc3RydWN0IHNt
YjNfc2QpICsgc2l6ZW9mKHN0cnVjdCBzbWIzX2FjbCkgKwotCQkgMiAqIHNpemVvZihzdHJ1Y3Qg
Y2lmc19hY2UpOwotCWlmIChzZXRfb3duZXIpIHsKLQkJc2RsZW4gKz0gc2l6ZW9mKHN0cnVjdCBv
d25lcl9ncm91cF9zaWRzKTsKLQkJc2V0dXBfb3duZXJfZ3JvdXBfc2lkcyhvd25lcl9vZmZzZXQg
KyBzaXplb2Yoc3RydWN0IGNyZWF0ZV9jb250ZXh0KSArIDggLyogbmFtZSAqLwotCQkJKyAoY2hh
ciAqKWJ1Zik7Ci0JfQotCi0JYnVmLT5jY29udGV4dC5EYXRhT2Zmc2V0ID0gY3B1X3RvX2xlMTYo
b2Zmc2V0b2YKLQkJCQkJKHN0cnVjdCBjcnRfc2RfY3R4dCwgc2QpKTsKLQlidWYtPmNjb250ZXh0
LkRhdGFMZW5ndGggPSBjcHVfdG9fbGUzMihzZGxlbik7CisJYnVmLT5jY29udGV4dC5EYXRhT2Zm
c2V0ID0gY3B1X3RvX2xlMTYob2Zmc2V0b2Yoc3RydWN0IGNydF9zZF9jdHh0LCBzZCkpOwogCWJ1
Zi0+Y2NvbnRleHQuTmFtZU9mZnNldCA9IGNwdV90b19sZTE2KG9mZnNldG9mKHN0cnVjdCBjcnRf
c2RfY3R4dCwgTmFtZSkpOwogCWJ1Zi0+Y2NvbnRleHQuTmFtZUxlbmd0aCA9IGNwdV90b19sZTE2
KDQpOwogCS8qIFNNQjJfQ1JFQVRFX1NEX0JVRkZFUl9UT0tFTiBpcyAiU2VjRCIgKi8KQEAgLTIz
MTksNiArMjMxMyw3IEBAIGNyZWF0ZV9zZF9idWYodW1vZGVfdCBtb2RlLCBib29sIHNldF9vd25l
ciwgdW5zaWduZWQgaW50ICpsZW4pCiAJYnVmLT5OYW1lWzJdID0gJ2MnOwogCWJ1Zi0+TmFtZVsz
XSA9ICdEJzsKIAlidWYtPnNkLlJldmlzaW9uID0gMTsgIC8qIE11c3QgYmUgb25lIHNlZSBNUy1E
VFlQIDIuNC42ICovCisKIAkvKgogCSAqIEFDTCBpcyAic2VsZiByZWxhdGl2ZSIgaWUgQUNMIGlz
IHN0b3JlZCBpbiBjb250aWd1b3VzIGJsb2NrIG9mIG1lbW9yeQogCSAqIGFuZCAiRFAiIGllIHRo
ZSBEQUNMIGlzIHByZXNlbnQKQEAgLTIzMjYsMjggKzIzMjEsMzggQEAgY3JlYXRlX3NkX2J1Zih1
bW9kZV90IG1vZGUsIGJvb2wgc2V0X293bmVyLCB1bnNpZ25lZCBpbnQgKmxlbikKIAlidWYtPnNk
LkNvbnRyb2wgPSBjcHVfdG9fbGUxNihBQ0xfQ09OVFJPTF9TUiB8IEFDTF9DT05UUk9MX0RQKTsK
IAogCS8qIG9mZnNldCBvd25lciwgZ3JvdXAgYW5kIFNiejEgYW5kIFNBQ0wgYXJlIGFsbCB6ZXJv
ICovCi0JYnVmLT5zZC5PZmZzZXREYWNsID0gY3B1X3RvX2xlMzIoc2l6ZW9mKHN0cnVjdCBzbWIz
X3NkKSk7Ci0JYnVmLT5hY2wuQWNsUmV2aXNpb24gPSBBQ0xfUkVWSVNJT047IC8qIFNlZSAyLjQu
NC4xIG9mIE1TLURUWVAgKi8KKwlidWYtPnNkLk9mZnNldERhY2wgPSBjcHVfdG9fbGUzMihwdHIg
LSAoX191OCAqKSZidWYtPnNkKTsKKwkvKiBTaGlwIHRoZSBBQ0wgZm9yIG5vdy4gd2Ugd2lsbCBj
b3B5IGl0IGludG8gYnVmIGxhdGVyLiAqLworCWFjbHB0ciA9IHB0cjsKKwlwdHIgKz0gc2l6ZW9m
KHN0cnVjdCBjaWZzX2FjbCk7CiAKIAkvKiBjcmVhdGUgb25lIEFDRSB0byBob2xkIHRoZSBtb2Rl
IGVtYmVkZGVkIGluIHJlc2VydmVkIHNwZWNpYWwgU0lEICovCi0JcGFjZSA9IChzdHJ1Y3QgY2lm
c19hY2UgKikoc2l6ZW9mKHN0cnVjdCBjcnRfc2RfY3R4dCkgKyAoY2hhciAqKWJ1Zik7Ci0JYWNl
bGVuID0gc2V0dXBfc3BlY2lhbF9tb2RlX0FDRShwYWNlLCAoX191NjQpbW9kZSk7CisJYWNlbGVu
ID0gc2V0dXBfc3BlY2lhbF9tb2RlX0FDRSgoc3RydWN0IGNpZnNfYWNlICopcHRyLCAoX191NjQp
bW9kZSk7CisJcHRyICs9IGFjZWxlbjsKKwlhY2xfc2l6ZSA9IGFjZWxlbiArIHNpemVvZihzdHJ1
Y3Qgc21iM19hY2wpOworCWFjZV9jb3VudCA9IDE7CiAKIAlpZiAoc2V0X293bmVyKSB7CiAJCS8q
IHdlIGRvIG5vdCBuZWVkIHRvIHJlYWxsb2NhdGUgYnVmZmVyIHRvIGFkZCB0aGUgdHdvIG1vcmUg
QUNFcy4gcGxlbnR5IG9mIHNwYWNlICovCi0JCXBhY2UgPSAoc3RydWN0IGNpZnNfYWNlICopKGFj
ZWxlbiArIChzaXplb2Yoc3RydWN0IGNydF9zZF9jdHh0KSArIChjaGFyICopYnVmKSk7Ci0JCWFj
ZWxlbiArPSBzZXR1cF9zcGVjaWFsX3VzZXJfb3duZXJfQUNFKHBhY2UpOwotCQkvKiBpdCBkb2Vz
IG5vdCBhcHBlYXIgbmVjZXNzYXJ5IHRvIGFkZCBhbiBBQ0UgZm9yIHRoZSBORlMgZ3JvdXAgU0lE
ICovCi0JCWJ1Zi0+YWNsLkFjZUNvdW50ID0gY3B1X3RvX2xlMTYoMyk7Ci0JfSBlbHNlCi0JCWJ1
Zi0+YWNsLkFjZUNvdW50ID0gY3B1X3RvX2xlMTYoMik7CisJCWFjZWxlbiA9IHNldHVwX3NwZWNp
YWxfdXNlcl9vd25lcl9BQ0UoKHN0cnVjdCBjaWZzX2FjZSAqKXB0cik7CisJCXB0ciArPSBhY2Vs
ZW47CisJCWFjbF9zaXplICs9IGFjZWxlbjsKKwkJYWNlX2NvdW50ICs9IDE7CisJfQogCiAJLyog
YW5kIG9uZSBtb3JlIEFDRSB0byBhbGxvdyBhY2Nlc3MgZm9yIGF1dGhlbnRpY2F0ZWQgdXNlcnMg
Ki8KLQlwYWNlID0gKHN0cnVjdCBjaWZzX2FjZSAqKShhY2VsZW4gKyAoc2l6ZW9mKHN0cnVjdCBj
cnRfc2RfY3R4dCkgKwotCQkoY2hhciAqKWJ1ZikpOwotCWFjZWxlbiArPSBzZXR1cF9hdXRodXNl
cnNfQUNFKHBhY2UpOwotCi0JYnVmLT5hY2wuQWNsU2l6ZSA9IGNwdV90b19sZTE2KHNpemVvZihz
dHJ1Y3QgY2lmc19hY2wpICsgYWNlbGVuKTsKKwlhY2VsZW4gPSBzZXR1cF9hdXRodXNlcnNfQUNF
KChzdHJ1Y3QgY2lmc19hY2UgKilwdHIpOworCXB0ciArPSBhY2VsZW47CisJYWNsX3NpemUgKz0g
YWNlbGVuOworCWFjZV9jb3VudCArPSAxOworCisJYWNsLkFjbFJldmlzaW9uID0gQUNMX1JFVklT
SU9OOyAvKiBTZWUgMi40LjQuMSBvZiBNUy1EVFlQICovCisJYWNsLkFjbFNpemUgPSBjcHVfdG9f
bGUxNihhY2xfc2l6ZSk7CisJYWNsLkFjZUNvdW50ID0gY3B1X3RvX2xlMTYoYWNlX2NvdW50KTsK
KwltZW1jcHkoYWNscHRyLCAmYWNsLCBzaXplb2Yoc3RydWN0IGNpZnNfYWNsKSk7CisKKwlidWYt
PmNjb250ZXh0LkRhdGFMZW5ndGggPSBjcHVfdG9fbGUzMihwdHIgLSAoX191OCAqKSZidWYtPnNk
KTsKKwkqbGVuID0gcHRyIC0gKF9fdTggKilidWY7CiAKIAlyZXR1cm4gYnVmOwogfQpkaWZmIC0t
Z2l0IGEvZnMvY2lmcy9zbWIycGR1LmggYi9mcy9jaWZzL3NtYjJwZHUuaAppbmRleCBmMDVmOWIx
MmY2ODkuLmZhNTdiMDNjYTk4YyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmgKKysrIGIv
ZnMvY2lmcy9zbWIycGR1LmgKQEAgLTk2Myw4ICs5NjMsNiBAQCBzdHJ1Y3QgY3J0X3NkX2N0eHQg
ewogCXN0cnVjdCBjcmVhdGVfY29udGV4dCBjY29udGV4dDsKIAlfX3U4CU5hbWVbOF07CiAJc3Ry
dWN0IHNtYjNfc2Qgc2Q7Ci0Jc3RydWN0IHNtYjNfYWNsIGFjbDsKLQkvKiBGb2xsb3dlZCBieSBh
dCBsZWFzdCA0IEFDRXMgKi8KIH0gX19wYWNrZWQ7CiAKIAotLSAKMi4yNy4wCgo=
--000000000000edf44605b5977fca--
