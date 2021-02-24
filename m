Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D009C433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 18:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CC9064ECF
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 18:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhBXSVS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Feb 2021 13:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbhBXSVR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Feb 2021 13:21:17 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E13C061574
        for <linux-cifs@vger.kernel.org>; Wed, 24 Feb 2021 10:20:36 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id f1so4519674lfu.3
        for <linux-cifs@vger.kernel.org>; Wed, 24 Feb 2021 10:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NwFk13nHbNWhtKQ2wwBbEghKq+LoS9HQLKV/qMkcC6o=;
        b=LM9RMLI3YT1bq60pKw4d/eVIlqj00Q4AHzA01hPI2rO96gM4wKM8EJ0sJol9xWUf5r
         2rOJUnOeqBdvYxOhv1v9oHG29QkedcT40aZnvRnjhqeYJxbYBKp5M+KKx40yjXwUqw+Q
         wG2wXbDdzzSYzm+IQFHQ/GG6IhFj6vrvASG+oVmoED/95a9Mdq4gbYkiR3kdAyV6ixZD
         lXVbnjsgvPoGElJqiL9pjkVFHGKCXH/nEC5S0BGj46YV5Stv8iTqvmCx8kHa26TBmlQr
         V6k08rmsSbhgxS6umEDzYhv8a87Dbmbw2btPtwa/JN73K08OrpdkxxE52kz4J2xVZBu2
         nGig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NwFk13nHbNWhtKQ2wwBbEghKq+LoS9HQLKV/qMkcC6o=;
        b=s9eq5hlMmCpTzyl2jHdCLckBOJ61eW857JFF64iUyDuVF9IM0teIA0NtFL2EfSkbCW
         8J01yz/lBdf++sZx6T5Pr4uHzMGqfXYuZvkVwdRGOzU2DKqiNMhSaHvZN736/Wrwl/5L
         4JolA/2vTz7t0FWO0hHKUvWwuFWoZbY9HaCbHwvk0RudbxcFpr0SKuyQiTKzAPoTnPIS
         i4mpv0CbR1AnpeYUvkZ9i37E09UM+4XD9v5L9q4H6PZHDp+SiKXEHlV/obPuOq+4lhIQ
         4upZDUHhaKBrhuqZ8h7El1lUndMGzxrGXkARrp1/XgjvP90LNgwFGIiLvyj0HPfDk2iM
         0S+A==
X-Gm-Message-State: AOAM533JtBWHNKlWPa4J/aatMcB52tH+qR738K3G5i+ifakTNTbLiiVZ
        M/nsyuZG+/sqshRzIJlOijjvv4Gco4H/FY5xce1mCLEogGg=
X-Google-Smtp-Source: ABdhPJw0Y4qR1NAsW6dkoEEdfEjo+tkM548uecTfTy6NIAY1l8z2J60ZU3EmTR1G2vAqDVlIcwU1lz1ueDCBF727ksA=
X-Received: by 2002:a05:6512:1311:: with SMTP id x17mr19509973lfu.307.1614190834735;
 Wed, 24 Feb 2021 10:20:34 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msdUQ=CVM6s7ENeH7SP-teYAOioOGq7zY5sDXZFrFYiCA@mail.gmail.com>
 <CAH2r5mv6Oo5UUMOyFmKO_6xmdXZvQa_TtmFjgdN_ZoBcgSbJkA@mail.gmail.com>
 <10881e42-9632-30b0-344d-66ed8e9cb340@talpey.com> <CAH2r5mvGG1-DOZq1Eby3jfX86YLgpCihmYgV=EPJoR16PhEN7Q@mail.gmail.com>
In-Reply-To: <CAH2r5mvGG1-DOZq1Eby3jfX86YLgpCihmYgV=EPJoR16PhEN7Q@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 24 Feb 2021 12:20:23 -0600
Message-ID: <CAH2r5muLz67kjmxiboeW3DwJ2KhEQgJs_U6MCAxzVZ+TY+ucCA@mail.gmail.com>
Subject: Re: [PATCH] convert revalidate of directories to using directory
 metadata cache timeout
To:     Tom Talpey <tom@talpey.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000004e00a005bc1917cf"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000004e00a005bc1917cf
Content-Type: text/plain; charset="UTF-8"

Added additional patch to add "acregmax" so now behavior is more similar to nfs.

"acregmax" changes file metadata caching timeout
"acdirmax" changes directory metadata caching
"actimeo" does what it did before - and changes both.

On Wed, Feb 24, 2021 at 11:31 AM Steve French <smfrench@gmail.com> wrote:
>
> On Wed, Feb 24, 2021 at 10:11 AM Tom Talpey <tom@talpey.com> wrote:
> >
> > On 2/23/2021 8:03 PM, Steve French wrote:
> > > Updated version incorporates Ronnie's suggestion of leaving the
> > > default (for directory caching) the same as it is today, 1 second, to
> > > avoid
> > > unnecessary risk.   Most users can safely improve performance by
> > > mounting with acdirmax to a higher value (e.g. 60 seconds as NFS
> > > defaults to).
> > >
> > > nfs and cifs on Linux currently have a mount parameter "actimeo" to control
> > > metadata (attribute) caching but cifs does not have additional mount
> > > parameters to allow distinguishing between caching directory metadata
> > > (e.g. needed to revalidate paths) and that for files.
> >
> > The behaviors seem to be slightly different with this change.
> > With NFS, the actimeo option overrides the four min/max options,
> > and by default the directory ac timers range between 30 and 60.
> >
> > The CIFS code I see below seems to completely separate actimeo
> > and acdirmax, and if not set, uses the historic 1 second value.
> > That's fine, but it's completely different from NFS. Shouldn't we
> > use a different mount option, to avoid confusing the admin?
>
> Ugh ... You are probably right.  I was trying to avoid two problems:
> 1) (a minor one) adding a second mount option rather than just one (to
> solve the same problem).  But reducing confusion is worth an extra
> mount option
>
> 2) how to avoid the user specifying *both* actimeo and acregmax -
> which one 'wins' (presumably the last one in the mount line)
> We could check for this and warn the user in mount.cifs so maybe not
> important to worry about in the kernel though.
>
> I will add the acregmax mount option and change actimeo to mean
>     if (actimeo is set)
>             acregmax = acdirmax = actimeo
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--0000000000004e00a005bc1917cf
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-Add-new-parameter-acregmax-for-distinct-file-an.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Add-new-parameter-acregmax-for-distinct-file-an.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kljrjb000>
X-Attachment-Id: f_kljrjb000

RnJvbSBiZmU5ZDZkMjZkZTZmMzBkMzhiMjA2ZDI2NzYxMDk2NjA5MzFhZDRlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMjQgRmViIDIwMjEgMTI6MTI6NTMgLTA2MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBBZGQgbmV3IHBhcmFtZXRlciAiYWNyZWdtYXgiIGZvciBkaXN0aW5jdCBmaWxlIGFuZAog
ZGlyZWN0b3J5IG1ldGFkYXRhIHRpbWVvdXQKClRoZSBuZXcgb3B0aW9uYWwgbW91bnQgcGFyYW1l
dGVyICJhY3JlZ21heCIgYWxsb3dzIGEgZGlmZmVyZW50CnRpbWVvdXQgZm9yIGZpbGUgbWV0YWRh
dGEgKCJhY2Rpcm1heCIgbm93IGFsbG93cyBjb250cm9sbGluZyB0aW1lb3V0CmZvciBkaXJlY3Rv
cnkgbWV0YWRhdGEpLiAgU2V0dGluZyAiYWN0aW1lbyIgc3RpbGwgd29ya3MgYXMgYmVmb3JlLAph
bmQgY2hhbmdlcyB0aW1lb3V0IGZvciBib3RoIGZpbGVzIGFuZCBkaXJlY3RvcmllcywgYnV0CnNw
ZWNpZnlpbmcgImFjcmVnbWF4IiBvciAiYWNkaXJtYXgiIGFsbG93cyBvdmVycmlkaW5nIHRoZQpk
ZWZhdWx0IG1vcmUgZ3JhbnVsYXJseSB3aGljaCBjYW4gYmUgYSBiaWcgcGVyZm9ybWFuY2UgYmVu
ZWZpdApvbiBzb21lIHdvcmtsb2Fkcy4gImFjcmVnbWF4IiBpcyBhbHJlYWR5IHVzZWQgYnkgTkZT
IGFzIGEgbW91bnQKcGFyYW1ldGVyIChhbGJlaXQgd2l0aCBhIGxhcmdlciBkZWZhdWx0IGFuZCB0
aHVzIGxvb3NlciBjYWNoaW5nKS4KClN1Z2dlc3RlZC1ieTogVG9tIFRhbHBleSA8dG9tQHRhbHBl
eS5jb20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNv
bT4KLS0tCiBmcy9jaWZzL2NpZnNmcy5jICAgICB8IDE1ICsrKysrKysrKysrKy0tLQogZnMvY2lm
cy9jb25uZWN0LmMgICAgfCAgMiArLQogZnMvY2lmcy9mc19jb250ZXh0LmMgfCAyMyArKysrKysr
KysrKysrKysrKystLS0tLQogZnMvY2lmcy9mc19jb250ZXh0LmggfCAgNiArKysrLS0KIGZzL2Np
ZnMvaW5vZGUuYyAgICAgIHwgIDQgKystLQogNSBmaWxlcyBjaGFuZ2VkLCAzNyBpbnNlcnRpb25z
KCspLCAxMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNmcy5jIGIvZnMv
Y2lmcy9jaWZzZnMuYwppbmRleCA0ZTBiMGIyNmU4NDQuLjNiNjFmMDlmM2UxYiAxMDA2NDQKLS0t
IGEvZnMvY2lmcy9jaWZzZnMuYworKysgYi9mcy9jaWZzL2NpZnNmcy5jCkBAIC02MzcsOSArNjM3
LDE4IEBAIGNpZnNfc2hvd19vcHRpb25zKHN0cnVjdCBzZXFfZmlsZSAqcywgc3RydWN0IGRlbnRy
eSAqcm9vdCkKIAkJc2VxX3ByaW50ZihzLCAiLHNuYXBzaG90PSVsbHUiLCB0Y29uLT5zbmFwc2hv
dF90aW1lKTsKIAlpZiAodGNvbi0+aGFuZGxlX3RpbWVvdXQpCiAJCXNlcV9wcmludGYocywgIixo
YW5kbGV0aW1lb3V0PSV1IiwgdGNvbi0+aGFuZGxlX3RpbWVvdXQpOwotCS8qIGNvbnZlcnQgYWN0
aW1lbyBhbmQgZGlyZWN0b3J5IGF0dHJpYnV0ZSB0aW1lb3V0IGFuZCBkaXNwbGF5IGluIHNlY29u
ZHMgKi8KLQlzZXFfcHJpbnRmKHMsICIsYWN0aW1lbz0lbHUiLCBjaWZzX3NiLT5jdHgtPmFjdGlt
ZW8gLyBIWik7Ci0Jc2VxX3ByaW50ZihzLCAiLGFjZGlybWF4PSVsdSIsIGNpZnNfc2ItPmN0eC0+
YWNkaXJtYXggLyBIWik7CisKKwkvKgorCSAqIERpc3BsYXkgZmlsZSBhbmQgZGlyZWN0b3J5IGF0
dHJpYnV0ZSB0aW1lb3V0IGluIHNlY29uZHMuCisJICogSWYgZmlsZSBhbmQgZGlyZWN0b3J5IGF0
dHJpYnV0ZSB0aW1lb3V0IHRoZSBzYW1lIHRoZW4gYWN0aW1lbworCSAqIHdhcyBsaWtlbHkgc3Bl
Y2lmaWVkIG9uIG1vdW50CisJICovCisJaWYgKGNpZnNfc2ItPmN0eC0+YWNkaXJtYXggPT0gY2lm
c19zYi0+Y3R4LT5hY3JlZ21heCkKKwkJc2VxX3ByaW50ZihzLCAiLGFjdGltZW89JWx1IiwgY2lm
c19zYi0+Y3R4LT5hY3JlZ21heCAvIEhaKTsKKwllbHNlIHsKKwkJc2VxX3ByaW50ZihzLCAiLGFj
ZGlybWF4PSVsdSIsIGNpZnNfc2ItPmN0eC0+YWNkaXJtYXggLyBIWik7CisJCXNlcV9wcmludGYo
cywgIixhY3JlZ21heD0lbHUiLCBjaWZzX3NiLT5jdHgtPmFjcmVnbWF4IC8gSFopOworCX0KIAog
CWlmICh0Y29uLT5zZXMtPmNoYW5fbWF4ID4gMSkKIAkJc2VxX3ByaW50ZihzLCAiLG11bHRpY2hh
bm5lbCxtYXhfY2hhbm5lbHM9JXp1IiwKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIv
ZnMvY2lmcy9jb25uZWN0LmMKaW5kZXggYTlkYzM5YWVlOWY0Li45ZWNkODA5OGMyYjYgMTAwNjQ0
Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jCisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC0yMjc2
LDcgKzIyNzYsNyBAQCBjb21wYXJlX21vdW50X29wdGlvbnMoc3RydWN0IHN1cGVyX2Jsb2NrICpz
Yiwgc3RydWN0IGNpZnNfbW50X2RhdGEgKm1udF9kYXRhKQogCWlmIChzdHJjbXAob2xkLT5sb2Nh
bF9ubHMtPmNoYXJzZXQsIG5ldy0+bG9jYWxfbmxzLT5jaGFyc2V0KSkKIAkJcmV0dXJuIDA7CiAK
LQlpZiAob2xkLT5jdHgtPmFjdGltZW8gIT0gbmV3LT5jdHgtPmFjdGltZW8pCisJaWYgKG9sZC0+
Y3R4LT5hY3JlZ21heCAhPSBuZXctPmN0eC0+YWNyZWdtYXgpCiAJCXJldHVybiAwOwogCWlmIChv
bGQtPmN0eC0+YWNkaXJtYXggIT0gbmV3LT5jdHgtPmFjZGlybWF4KQogCQlyZXR1cm4gMDsKZGlm
ZiAtLWdpdCBhL2ZzL2NpZnMvZnNfY29udGV4dC5jIGIvZnMvY2lmcy9mc19jb250ZXh0LmMKaW5k
ZXggZjNiZTA3ZjQ2NzFkLi4xNGM5NTVhMzAwMDYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvZnNfY29u
dGV4dC5jCisrKyBiL2ZzL2NpZnMvZnNfY29udGV4dC5jCkBAIC0xNDEsNiArMTQxLDcgQEAgY29u
c3Qgc3RydWN0IGZzX3BhcmFtZXRlcl9zcGVjIHNtYjNfZnNfcGFyYW1ldGVyc1tdID0gewogCWZz
cGFyYW1fdTMyKCJ3c2l6ZSIsIE9wdF93c2l6ZSksCiAJZnNwYXJhbV91MzIoImFjdGltZW8iLCBP
cHRfYWN0aW1lbyksCiAJZnNwYXJhbV91MzIoImFjZGlybWF4IiwgT3B0X2FjZGlybWF4KSwKKwlm
c3BhcmFtX3UzMigiYWNyZWdtYXgiLCBPcHRfYWNyZWdtYXgpLAogCWZzcGFyYW1fdTMyKCJlY2hv
X2ludGVydmFsIiwgT3B0X2VjaG9faW50ZXJ2YWwpLAogCWZzcGFyYW1fdTMyKCJtYXhfY3JlZGl0
cyIsIE9wdF9tYXhfY3JlZGl0cyksCiAJZnNwYXJhbV91MzIoImhhbmRsZXRpbWVvdXQiLCBPcHRf
aGFuZGxldGltZW91dCksCkBAIC05MzAsMTAgKzkzMSwxMCBAQCBzdGF0aWMgaW50IHNtYjNfZnNf
Y29udGV4dF9wYXJzZV9wYXJhbShzdHJ1Y3QgZnNfY29udGV4dCAqZmMsCiAJCWN0eC0+d3NpemUg
PSByZXN1bHQudWludF8zMjsKIAkJY3R4LT5nb3Rfd3NpemUgPSB0cnVlOwogCQlicmVhazsKLQlj
YXNlIE9wdF9hY3RpbWVvOgotCQljdHgtPmFjdGltZW8gPSBIWiAqIHJlc3VsdC51aW50XzMyOwot
CQlpZiAoY3R4LT5hY3RpbWVvID4gQ0lGU19NQVhfQUNUSU1FTykgewotCQkJY2lmc19kYmcoVkZT
LCAiYXR0cmlidXRlIGNhY2hlIHRpbWVvdXQgdG9vIGxhcmdlXG4iKTsKKwljYXNlIE9wdF9hY3Jl
Z21heDoKKwkJY3R4LT5hY3JlZ21heCA9IEhaICogcmVzdWx0LnVpbnRfMzI7CisJCWlmIChjdHgt
PmFjcmVnbWF4ID4gQ0lGU19NQVhfQUNUSU1FTykgeworCQkJY2lmc19kYmcoVkZTLCAiYWNyZWdt
YXggdG9vIGxhcmdlXG4iKTsKIAkJCWdvdG8gY2lmc19wYXJzZV9tb3VudF9lcnI7CiAJCX0KIAkJ
YnJlYWs7CkBAIC05NDQsNiArOTQ1LDE4IEBAIHN0YXRpYyBpbnQgc21iM19mc19jb250ZXh0X3Bh
cnNlX3BhcmFtKHN0cnVjdCBmc19jb250ZXh0ICpmYywKIAkJCWdvdG8gY2lmc19wYXJzZV9tb3Vu
dF9lcnI7CiAJCX0KIAkJYnJlYWs7CisJY2FzZSBPcHRfYWN0aW1lbzoKKwkJaWYgKEhaICogcmVz
dWx0LnVpbnRfMzIgPiBDSUZTX01BWF9BQ1RJTUVPKSB7CisJCQljaWZzX2RiZyhWRlMsICJ0aW1l
b3V0IHRvbyBsYXJnZVxuIik7CisJCQlnb3RvIGNpZnNfcGFyc2VfbW91bnRfZXJyOworCQl9CisJ
CWlmICgoY3R4LT5hY2Rpcm1heCAhPSBDSUZTX0RFRl9BQ1RJTUVPKSB8fAorCQkgICAgKGN0eC0+
YWNyZWdtYXggIT0gQ0lGU19ERUZfQUNUSU1FTykpIHsKKwkJCWNpZnNfZGJnKFZGUywgImFjdGlt
ZW8gaWdub3JlZCBzaW5jZSBhY3JlZ21heCBvciBhY2Rpcm1heCBzcGVjaWZpZWRcbiIpOworCQkJ
YnJlYWs7CisJCX0KKwkJY3R4LT5hY2Rpcm1heCA9IGN0eC0+YWNyZWdtYXggPSBIWiAqIHJlc3Vs
dC51aW50XzMyOworCQlicmVhazsKIAljYXNlIE9wdF9lY2hvX2ludGVydmFsOgogCQljdHgtPmVj
aG9faW50ZXJ2YWwgPSByZXN1bHQudWludF8zMjsKIAkJYnJlYWs7CkBAIC0xMzY5LDcgKzEzODIs
NyBAQCBpbnQgc21iM19pbml0X2ZzX2NvbnRleHQoc3RydWN0IGZzX2NvbnRleHQgKmZjKQogCS8q
IGRlZmF1bHQgaXMgdG8gdXNlIHN0cmljdCBjaWZzIGNhY2hpbmcgc2VtYW50aWNzICovCiAJY3R4
LT5zdHJpY3RfaW8gPSB0cnVlOwogCi0JY3R4LT5hY3RpbWVvID0gQ0lGU19ERUZfQUNUSU1FTzsK
KwljdHgtPmFjcmVnbWF4ID0gQ0lGU19ERUZfQUNUSU1FTzsKIAljdHgtPmFjZGlybWF4ID0gQ0lG
U19ERUZfQUNUSU1FTzsKIAogCS8qIE1vc3QgY2xpZW50cyBzZXQgdGltZW91dCB0byAwLCBhbGxv
d3Mgc2VydmVyIHRvIHVzZSBpdHMgZGVmYXVsdCAqLwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9mc19j
b250ZXh0LmggYi9mcy9jaWZzL2ZzX2NvbnRleHQuaAppbmRleCA0NzIzNzJmZWM0ZTkuLjg3ZGQx
ZjcxNjhmMiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9mc19jb250ZXh0LmgKKysrIGIvZnMvY2lmcy9m
c19jb250ZXh0LmgKQEAgLTExOSw2ICsxMTksNyBAQCBlbnVtIGNpZnNfcGFyYW0gewogCU9wdF93
c2l6ZSwKIAlPcHRfYWN0aW1lbywKIAlPcHRfYWNkaXJtYXgsCisJT3B0X2FjcmVnbWF4LAogCU9w
dF9lY2hvX2ludGVydmFsLAogCU9wdF9tYXhfY3JlZGl0cywKIAlPcHRfc25hcHNob3QsCkBAIC0y
MzMsOCArMjM0LDkgQEAgc3RydWN0IHNtYjNfZnNfY29udGV4dCB7CiAJdW5zaWduZWQgaW50IHdz
aXplOwogCXVuc2lnbmVkIGludCBtaW5fb2ZmbG9hZDsKIAlib29sIHNvY2tvcHRfdGNwX25vZGVs
YXk6MTsKLQl1bnNpZ25lZCBsb25nIGFjdGltZW87IC8qIGF0dHJpYnV0ZSBjYWNoZSB0aW1lb3V0
IGZvciBmaWxlcyAoamlmZmllcykgKi8KLQl1bnNpZ25lZCBsb25nIGFjZGlybWF4OyAvKiBhdHRy
aWJ1dGUgY2FjaGUgdGltZW91dCBmb3IgZGlyZWN0b3JpZXMgKGppZmZpZXMpICovCisJLyogYXR0
cmlidXRlIGNhY2hlIHRpbWVtb3V0IGZvciBmaWxlcyBhbmQgZGlyZWN0b3JpZXMgaW4gamlmZmll
cyAqLworCXVuc2lnbmVkIGxvbmcgYWNyZWdtYXg7CisJdW5zaWduZWQgbG9uZyBhY2Rpcm1heDsK
IAlzdHJ1Y3Qgc21iX3ZlcnNpb25fb3BlcmF0aW9ucyAqb3BzOwogCXN0cnVjdCBzbWJfdmVyc2lv
bl92YWx1ZXMgKnZhbHM7CiAJY2hhciAqcHJlcGF0aDsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvaW5v
ZGUuYyBiL2ZzL2NpZnMvaW5vZGUuYwppbmRleCBjZmQzMWNjNDUyMGYuLjBiMGIwMWVmM2VjYiAx
MDA2NDQKLS0tIGEvZnMvY2lmcy9pbm9kZS5jCisrKyBiL2ZzL2NpZnMvaW5vZGUuYwpAQCAtMjIw
OSwxMCArMjIwOSwxMCBAQCBjaWZzX2lub2RlX25lZWRzX3JldmFsKHN0cnVjdCBpbm9kZSAqaW5v
ZGUpCiAJCQkJICAgY2lmc19pLT50aW1lICsgY2lmc19zYi0+Y3R4LT5hY2Rpcm1heCkpCiAJCQly
ZXR1cm4gdHJ1ZTsKIAl9IGVsc2UgeyAvKiBmaWxlICovCi0JCWlmICghY2lmc19zYi0+Y3R4LT5h
Y3RpbWVvKQorCQlpZiAoIWNpZnNfc2ItPmN0eC0+YWNyZWdtYXgpCiAJCQlyZXR1cm4gdHJ1ZTsK
IAkJaWYgKCF0aW1lX2luX3JhbmdlKGppZmZpZXMsIGNpZnNfaS0+dGltZSwKLQkJCQkgICBjaWZz
X2ktPnRpbWUgKyBjaWZzX3NiLT5jdHgtPmFjdGltZW8pKQorCQkJCSAgIGNpZnNfaS0+dGltZSAr
IGNpZnNfc2ItPmN0eC0+YWNyZWdtYXgpKQogCQkJcmV0dXJuIHRydWU7CiAJfQogCi0tIAoyLjI3
LjAKCg==
--0000000000004e00a005bc1917cf--
