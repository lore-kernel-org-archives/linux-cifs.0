Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA79FC433C1
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 04:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67DD4619FE
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 04:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbhCZEyv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Mar 2021 00:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbhCZEyu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Mar 2021 00:54:50 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9934AC0613AF
        for <linux-cifs@vger.kernel.org>; Thu, 25 Mar 2021 21:54:50 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id m132so4661698ybf.2
        for <linux-cifs@vger.kernel.org>; Thu, 25 Mar 2021 21:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7moedfkBaBng/rtJ0qqpFBNCpACtK0tqIY0PWxHZq6g=;
        b=pWD7wSTGbd7HWDDbF38kM3ni4hdRmjb6UliRiacf5z4pgsJtZsXQ/Hux8/BW2i3aOj
         NcVeFTkRBh955Ec2f8SEH+CF9F3dBi6iE2rLUrsVrtPDLz7L9JTG9QymPPXToPT7m3iM
         cn9VoQ09PTYndxf/oYO/i89uhdBz88SeJ9cLvyYqoB1x4Y3+ZhEwt3R+317TC3BgOLiI
         Gv7eK1xNJODIO5U450PPzDGU4Yul2U6QxMyXhYXrdPWnQthSADrqVLn6MlW+eBZsgr69
         Nmro5GbLqANgtpr5Gclhf+EqtuUjqnkxCtaYAy78ChZJAjKqg1KjJADSmL2xi9S1MdwE
         zVDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7moedfkBaBng/rtJ0qqpFBNCpACtK0tqIY0PWxHZq6g=;
        b=QEVV3XFkjCiXJjkcxbisbY8cNYe7Wcdthj/OfVmW7El/9CT2/cBtTMSqPhC1P+VF5m
         WGyh53U815unPd6DiCuN2q3bciwihkUQxL0GZ2YPRPSKOieqO+N9qdjAa2v2DknQ9F+1
         VWvoFtiGCIhzABnQeViTiWEpJ/wZhVGu84xdBusrsLWwhT0hyjcjJ6+ySXtp2AJqkhk9
         xh5VZoiBji57JA7rig59jAHgP/00XRysOvpBYBCjeabal6c0IvMN+vsjhxgbuU1mawdn
         0taIgWfdhpFjmVCS7JOGG9JYGEUXT5OFyAbeKCqB9V9zuXZHEmehsKYFRR8GQzp0qp80
         Pslg==
X-Gm-Message-State: AOAM530BvJit4yOQ+g8FJrHXAcZ38BNu6SiwOgXj+bGoDB6EiYg2MHDC
        yjMrqKL6fGh4amMTY6ksGVw4fgirb+6k0lnp9VM=
X-Google-Smtp-Source: ABdhPJz8q7oF32dkbnv0T72Uoq+ogv9MJZ36/LyWOCo/i+3KgSgBFDSJVx+HAAfmn8c8AAuegRZEj4ni9b9L2fkLxEY=
X-Received: by 2002:a25:694c:: with SMTP id e73mr1778833ybc.327.1616734489824;
 Thu, 25 Mar 2021 21:54:49 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=qKxu17O__xWzwfbJJ4RAAK4whg63Yx6P6FGKVYrMkxOg@mail.gmail.com>
 <CAN05THSVmeYGqky=jG2_Jrf0GxdPumASnWoMx8TrzQ85hbDLDQ@mail.gmail.com>
 <CANT5p=p4j0ngRxsE-f9KF8b-QmoP2isdDoKGiWHGvn_q8W3C-A@mail.gmail.com> <CAN05THSSMByhwUVRxFKoF_DdYFDMefz2ieCmdiRwbuxzL5kMKw@mail.gmail.com>
In-Reply-To: <CAN05THSSMByhwUVRxFKoF_DdYFDMefz2ieCmdiRwbuxzL5kMKw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 26 Mar 2021 10:24:38 +0530
Message-ID: <CANT5p=r1rZJrZ9kghmLwhnR7xHqJ-dwptn1ojqTgqyfd8wXd+w@mail.gmail.com>
Subject: Re: [PATCH] cifs: Adjust key sizes and key generation routines for
 AES256 encryptions.
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000f66bd805be6954bb"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000f66bd805be6954bb
Content-Type: text/plain; charset="UTF-8"

Thanks Ronnie.

Sending out a revised patch with cifs_dbg() for dumping keys fixed.
Also rolling back my changes to the ioctl for dumping keys. For now,
it will not work for AES256. But will not break AES128.
For some reason, "smbinfo keys" fails with "syscall failed: [Errno 25]
Inappropriate ioctl for device" even without these changes. Need to
check why?

Regards,
Shyam

On Thu, Mar 25, 2021 at 6:50 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
>
> Handling all the keys as 32byte arrays internally should be fine
> but for the cifs_dbg() output I think you should add a conditional and
> print them either as 16 or 32 bytes, not always as 32 bytes.
>
> I.e. don't print the 16 byte padding for the aes128 cases.
>
> On Thu, Mar 25, 2021 at 11:08 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >
> > Aargh. Here goes... :)
> >
> > On Thu, Mar 25, 2021 at 6:29 PM ronnie sahlberg
> > <ronniesahlberg@gmail.com> wrote:
> > >
> > > -ENOPATCH ?
> > >
> > > On Thu, Mar 25, 2021 at 10:53 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > > >
> > > > Hi Steve,
> > > >
> > > > Please include this fix for AES 256 encryption algorithm based mounts.
> > > > I've validated this by mounting and performing I/O.
> > > >
> > > > --
> > > > Regards,
> > > > Shyam
> >
> >
> >
> > --
> > Regards,
> > Shyam



-- 
Regards,
Shyam

--000000000000f66bd805be6954bb
Content-Type: application/octet-stream; 
	name="0001-cifs-Adjust-key-sizes-and-key-generation-routines-fo.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Adjust-key-sizes-and-key-generation-routines-fo.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kmptvm6n0>
X-Attachment-Id: f_kmptvm6n0

RnJvbSBkZThmZGE2YTMxOWVkYjZkY2NiZTQwZmE1ZWQ1MjBkZDcyNDM0NmFkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBUaHUsIDI1IE1hciAyMDIxIDEyOjM0OjU0ICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogQWRqdXN0IGtleSBzaXplcyBhbmQga2V5IGdlbmVyYXRpb24gcm91dGluZXMgZm9yIEFF
UzI1NgogZW5jcnlwdGlvbnMuCgpGb3IgQUVTMjU2IGVuY3J5cHRpb24gKEdDTSBhbmQgQ0NNKSwg
d2UgbmVlZCB0byBhZGp1c3QgdGhlIHNpemUgb2YgYSBmZXcKZmllbGRzIHRvIDMyIGJ5dGVzIGlu
c3RlYWQgb2YgMTYgdG8gYWNjb21tb2RhdGUgdGhlIGxhcmdlciBrZXlzLgoKQWxzbywgdGhlIEwg
dmFsdWUgc3VwcGxpZWQgdG8gdGhlIGtleSBnZW5lcmF0b3IgbmVlZHMgdG8gYmUgY2hhbmdlZCBm
cm9tCnRvIDI1NiB3aGVuIHRoZXNlIGFsZ29yaXRobXMgYXJlIHVzZWQuCgpLZWVwaW5nIHRoZSBp
b2N0bCBzdHJ1Y3QgZm9yIGR1bXBpbmcga2V5cyBvZiB0aGUgc2FtZSBzaXplIGZvciBub3cuCldp
bGwgc2VuZCBvdXQgYSBkaWZmZXJlbnQgcGF0Y2ggZm9yIHRoYXQgb25lLgoKU2lnbmVkLW9mZi1i
eTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2Np
ZnNnbG9iLmggICAgICB8ICA0ICsrLS0KIGZzL2NpZnMvY2lmc3BkdS5oICAgICAgIHwgIDUgKysr
KysKIGZzL2NpZnMvc21iMmdsb2IuaCAgICAgIHwgIDEgKwogZnMvY2lmcy9zbWIyb3BzLmMgICAg
ICAgfCAgOSArKysrKy0tLS0KIGZzL2NpZnMvc21iMnRyYW5zcG9ydC5jIHwgMzcgKysrKysrKysr
KysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLQogNSBmaWxlcyBjaGFuZ2VkLCA0MSBpbnNlcnRp
b25zKCspLCAxNSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNnbG9iLmgg
Yi9mcy9jaWZzL2NpZnNnbG9iLmgKaW5kZXggMzFmYzg2OTVhYmQ2Li42N2MwNTZhOWE1MTkgMTAw
NjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2dsb2IuaAorKysgYi9mcy9jaWZzL2NpZnNnbG9iLmgKQEAg
LTkxOSw4ICs5MTksOCBAQCBzdHJ1Y3QgY2lmc19zZXMgewogCWJvb2wgYmluZGluZzoxOyAvKiBh
cmUgd2UgYmluZGluZyB0aGUgc2Vzc2lvbj8gKi8KIAlfX3UxNiBzZXNzaW9uX2ZsYWdzOwogCV9f
dTggc21iM3NpZ25pbmdrZXlbU01CM19TSUdOX0tFWV9TSVpFXTsKLQlfX3U4IHNtYjNlbmNyeXB0
aW9ua2V5W1NNQjNfU0lHTl9LRVlfU0laRV07Ci0JX191OCBzbWIzZGVjcnlwdGlvbmtleVtTTUIz
X1NJR05fS0VZX1NJWkVdOworCV9fdTggc21iM2VuY3J5cHRpb25rZXlbU01CM19FTkNfREVDX0tF
WV9TSVpFXTsKKwlfX3U4IHNtYjNkZWNyeXB0aW9ua2V5W1NNQjNfRU5DX0RFQ19LRVlfU0laRV07
CiAJX191OCBwcmVhdXRoX3NoYV9oYXNoW1NNQjJfUFJFQVVUSF9IQVNIX1NJWkVdOwogCiAJX191
OCBiaW5kaW5nX3ByZWF1dGhfc2hhX2hhc2hbU01CMl9QUkVBVVRIX0hBU0hfU0laRV07CmRpZmYg
LS1naXQgYS9mcy9jaWZzL2NpZnNwZHUuaCBiL2ZzL2NpZnMvY2lmc3BkdS5oCmluZGV4IDY0ZmU1
YTQ3YjVlOC4uOWFkYzc0YmQ5ZjhmIDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNwZHUuaAorKysg
Yi9mcy9jaWZzL2NpZnNwZHUuaApAQCAtMTQ3LDYgKzE0NywxMSBAQAogICovCiAjZGVmaW5lIFNN
QjNfU0lHTl9LRVlfU0laRSAoMTYpCiAKKy8qCisgKiBTaXplIG9mIHRoZSBzbWIzIGVuY3J5cHRp
b24vZGVjcnlwdGlvbiBrZXlzCisgKi8KKyNkZWZpbmUgU01CM19FTkNfREVDX0tFWV9TSVpFICgz
MikKKwogI2RlZmluZSBDSUZTX0NMSUVOVF9DSEFMTEVOR0VfU0laRSAoOCkKICNkZWZpbmUgQ0lG
U19TRVJWRVJfQ0hBTExFTkdFX1NJWkUgKDgpCiAjZGVmaW5lIENJRlNfSE1BQ19NRDVfSEFTSF9T
SVpFICgxNikKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMmdsb2IuaCBiL2ZzL2NpZnMvc21iMmds
b2IuaAppbmRleCA5OWExOTUxYTAxZWMuLmQ5YTk5MGM5OTEyMSAxMDA2NDQKLS0tIGEvZnMvY2lm
cy9zbWIyZ2xvYi5oCisrKyBiL2ZzL2NpZnMvc21iMmdsb2IuaApAQCAtNTgsNiArNTgsNyBAQAog
I2RlZmluZSBTTUIyX0hNQUNTSEEyNTZfU0laRSAoMzIpCiAjZGVmaW5lIFNNQjJfQ01BQ0FFU19T
SVpFICgxNikKICNkZWZpbmUgU01CM19TSUdOS0VZX1NJWkUgKDE2KQorI2RlZmluZSBTTUIzX0dD
TTEyOF9DUllQVEtFWV9TSVpFICgxNikKICNkZWZpbmUgU01CM19HQ00yNTZfQ1JZUFRLRVlfU0la
RSAoMzIpCiAKIC8qIE1heGltdW0gYnVmZmVyIHNpemUgdmFsdWUgd2UgY2FuIHNlbmQgd2l0aCAx
IGNyZWRpdCAqLwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJv
cHMuYwppbmRleCA5YmFlN2U4ZGViMDkuLjNlOTRmODM4OTdlOSAxMDA2NDQKLS0tIGEvZnMvY2lm
cy9zbWIyb3BzLmMKKysrIGIvZnMvY2lmcy9zbWIyb3BzLmMKQEAgLTQxNTgsNyArNDE1OCw3IEBA
IHNtYjJfZ2V0X2VuY19rZXkoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLCBfX3U2NCBz
ZXNfaWQsIGludCBlbmMsIHU4ICprZXkpCiAJCQlpZiAoc2VzLT5TdWlkID09IHNlc19pZCkgewog
CQkJCXNlc19lbmNfa2V5ID0gZW5jID8gc2VzLT5zbWIzZW5jcnlwdGlvbmtleSA6CiAJCQkJCXNl
cy0+c21iM2RlY3J5cHRpb25rZXk7Ci0JCQkJbWVtY3B5KGtleSwgc2VzX2VuY19rZXksIFNNQjNf
U0lHTl9LRVlfU0laRSk7CisJCQkJbWVtY3B5KGtleSwgc2VzX2VuY19rZXksIFNNQjNfRU5DX0RF
Q19LRVlfU0laRSk7CiAJCQkJc3Bpbl91bmxvY2soJmNpZnNfdGNwX3Nlc19sb2NrKTsKIAkJCQly
ZXR1cm4gMDsKIAkJCX0KQEAgLTQxODUsNyArNDE4NSw3IEBAIGNyeXB0X21lc3NhZ2Uoc3RydWN0
IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLCBpbnQgbnVtX3Jxc3QsCiAJaW50IHJjID0gMDsKIAlz
dHJ1Y3Qgc2NhdHRlcmxpc3QgKnNnOwogCXU4IHNpZ25bU01CMl9TSUdOQVRVUkVfU0laRV0gPSB7
fTsKLQl1OCBrZXlbU01CM19TSUdOX0tFWV9TSVpFXTsKKwl1OCBrZXlbU01CM19FTkNfREVDX0tF
WV9TSVpFXTsKIAlzdHJ1Y3QgYWVhZF9yZXF1ZXN0ICpyZXE7CiAJY2hhciAqaXY7CiAJdW5zaWdu
ZWQgaW50IGl2X2xlbjsKQEAgLTQyMDksMTAgKzQyMDksMTEgQEAgY3J5cHRfbWVzc2FnZShzdHJ1
Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsIGludCBudW1fcnFzdCwKIAl0Zm0gPSBlbmMgPyBz
ZXJ2ZXItPnNlY21lY2guY2NtYWVzZW5jcnlwdCA6CiAJCQkJCQlzZXJ2ZXItPnNlY21lY2guY2Nt
YWVzZGVjcnlwdDsKIAotCWlmIChzZXJ2ZXItPmNpcGhlcl90eXBlID09IFNNQjJfRU5DUllQVElP
Tl9BRVMyNTZfR0NNKQorCWlmICgoc2VydmVyLT5jaXBoZXJfdHlwZSA9PSBTTUIyX0VOQ1JZUFRJ
T05fQUVTMjU2X0NDTSkgfHwKKwkJKHNlcnZlci0+Y2lwaGVyX3R5cGUgPT0gU01CMl9FTkNSWVBU
SU9OX0FFUzI1Nl9HQ00pKQogCQlyYyA9IGNyeXB0b19hZWFkX3NldGtleSh0Zm0sIGtleSwgU01C
M19HQ00yNTZfQ1JZUFRLRVlfU0laRSk7CiAJZWxzZQotCQlyYyA9IGNyeXB0b19hZWFkX3NldGtl
eSh0Zm0sIGtleSwgU01CM19TSUdOX0tFWV9TSVpFKTsKKwkJcmMgPSBjcnlwdG9fYWVhZF9zZXRr
ZXkodGZtLCBrZXksIFNNQjNfR0NNMTI4X0NSWVBUS0VZX1NJWkUpOwogCiAJaWYgKHJjKSB7CiAJ
CWNpZnNfc2VydmVyX2RiZyhWRlMsICIlczogRmFpbGVkIHRvIHNldCBhZWFkIGtleSAlZFxuIiwg
X19mdW5jX18sIHJjKTsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnRyYW5zcG9ydC5jIGIvZnMv
Y2lmcy9zbWIydHJhbnNwb3J0LmMKaW5kZXggZWJjY2Q3MWNjNjBhLi5lNmZhNzZhYjcwYmUgMTAw
NjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnRyYW5zcG9ydC5jCisrKyBiL2ZzL2NpZnMvc21iMnRyYW5z
cG9ydC5jCkBAIC0yOTgsNyArMjk4LDggQEAgc3RhdGljIGludCBnZW5lcmF0ZV9rZXkoc3RydWN0
IGNpZnNfc2VzICpzZXMsIHN0cnVjdCBrdmVjIGxhYmVsLAogewogCXVuc2lnbmVkIGNoYXIgemVy
byA9IDB4MDsKIAlfX3U4IGlbNF0gPSB7MCwgMCwgMCwgMX07Ci0JX191OCBMWzRdID0gezAsIDAs
IDAsIDEyOH07CisJX191OCBMMTI4WzRdID0gezAsIDAsIDAsIDEyOH07CisJX191OCBMMjU2WzRd
ID0gezAsIDAsIDEsIDB9OwogCWludCByYyA9IDA7CiAJdW5zaWduZWQgY2hhciBwcmZoYXNoW1NN
QjJfSE1BQ1NIQTI1Nl9TSVpFXTsKIAl1bnNpZ25lZCBjaGFyICpoYXNocHRyID0gcHJmaGFzaDsK
QEAgLTM1NCw4ICszNTUsMTQgQEAgc3RhdGljIGludCBnZW5lcmF0ZV9rZXkoc3RydWN0IGNpZnNf
c2VzICpzZXMsIHN0cnVjdCBrdmVjIGxhYmVsLAogCQlnb3RvIHNtYjNzaWdua2V5X3JldDsKIAl9
CiAKLQlyYyA9IGNyeXB0b19zaGFzaF91cGRhdGUoJnNlcnZlci0+c2VjbWVjaC5zZGVzY2htYWNz
aGEyNTYtPnNoYXNoLAotCQkJCUwsIDQpOworCWlmICgoc2VydmVyLT5jaXBoZXJfdHlwZSA9PSBT
TUIyX0VOQ1JZUFRJT05fQUVTMjU2X0NDTSkgfHwKKwkJKHNlcnZlci0+Y2lwaGVyX3R5cGUgPT0g
U01CMl9FTkNSWVBUSU9OX0FFUzI1Nl9HQ00pKSB7CisJCXJjID0gY3J5cHRvX3NoYXNoX3VwZGF0
ZSgmc2VydmVyLT5zZWNtZWNoLnNkZXNjaG1hY3NoYTI1Ni0+c2hhc2gsCisJCQkJTDI1NiwgNCk7
CisJfSBlbHNlIHsKKwkJcmMgPSBjcnlwdG9fc2hhc2hfdXBkYXRlKCZzZXJ2ZXItPnNlY21lY2gu
c2Rlc2NobWFjc2hhMjU2LT5zaGFzaCwKKwkJCQlMMTI4LCA0KTsKKwl9CiAJaWYgKHJjKSB7CiAJ
CWNpZnNfc2VydmVyX2RiZyhWRlMsICIlczogQ291bGQgbm90IHVwZGF0ZSB3aXRoIExcbiIsIF9f
ZnVuY19fKTsKIAkJZ290byBzbWIzc2lnbmtleV9yZXQ7CkBAIC0zOTAsNiArMzk3LDkgQEAgZ2Vu
ZXJhdGVfc21iM3NpZ25pbmdrZXkoc3RydWN0IGNpZnNfc2VzICpzZXMsCiAJCQljb25zdCBzdHJ1
Y3QgZGVyaXZhdGlvbl90cmlwbGV0ICpwdHJpcGxldCkKIHsKIAlpbnQgcmM7CisjaWZkZWYgQ09O
RklHX0NJRlNfREVCVUdfRFVNUF9LRVlTCisJc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVy
ID0gc2VzLT5zZXJ2ZXI7CisjZW5kaWYKIAogCS8qCiAJICogQWxsIGNoYW5uZWxzIHVzZSB0aGUg
c2FtZSBlbmNyeXB0aW9uL2RlY3J5cHRpb24ga2V5cyBidXQKQEAgLTQyMiwxMSArNDMyLDExIEBA
IGdlbmVyYXRlX3NtYjNzaWduaW5na2V5KHN0cnVjdCBjaWZzX3NlcyAqc2VzLAogCQlyYyA9IGdl
bmVyYXRlX2tleShzZXMsIHB0cmlwbGV0LT5lbmNyeXB0aW9uLmxhYmVsLAogCQkJCSAgcHRyaXBs
ZXQtPmVuY3J5cHRpb24uY29udGV4dCwKIAkJCQkgIHNlcy0+c21iM2VuY3J5cHRpb25rZXksCi0J
CQkJICBTTUIzX1NJR05fS0VZX1NJWkUpOworCQkJCSAgU01CM19FTkNfREVDX0tFWV9TSVpFKTsK
IAkJcmMgPSBnZW5lcmF0ZV9rZXkoc2VzLCBwdHJpcGxldC0+ZGVjcnlwdGlvbi5sYWJlbCwKIAkJ
CQkgIHB0cmlwbGV0LT5kZWNyeXB0aW9uLmNvbnRleHQsCiAJCQkJICBzZXMtPnNtYjNkZWNyeXB0
aW9ua2V5LAotCQkJCSAgU01CM19TSUdOX0tFWV9TSVpFKTsKKwkJCQkgIFNNQjNfRU5DX0RFQ19L
RVlfU0laRSk7CiAJCWlmIChyYykKIAkJCXJldHVybiByYzsKIAl9CkBAIC00NDIsMTQgKzQ1Miwy
MyBAQCBnZW5lcmF0ZV9zbWIzc2lnbmluZ2tleShzdHJ1Y3QgY2lmc19zZXMgKnNlcywKIAkgKi8K
IAljaWZzX2RiZyhWRlMsICJTZXNzaW9uIElkICAgICUqcGhcbiIsIChpbnQpc2l6ZW9mKHNlcy0+
U3VpZCksCiAJCQkmc2VzLT5TdWlkKTsKKwljaWZzX2RiZyhWRlMsICJDaXBoZXIgdHlwZSAgICVk
XG4iLCBzZXJ2ZXItPmNpcGhlcl90eXBlKTsKIAljaWZzX2RiZyhWRlMsICJTZXNzaW9uIEtleSAg
ICUqcGhcbiIsCiAJCSBTTUIyX05UTE1WMl9TRVNTS0VZX1NJWkUsIHNlcy0+YXV0aF9rZXkucmVz
cG9uc2UpOwogCWNpZnNfZGJnKFZGUywgIlNpZ25pbmcgS2V5ICAgJSpwaFxuIiwKIAkJIFNNQjNf
U0lHTl9LRVlfU0laRSwgc2VzLT5zbWIzc2lnbmluZ2tleSk7Ci0JY2lmc19kYmcoVkZTLCAiU2Vy
dmVySW4gS2V5ICAlKnBoXG4iLAotCQkgU01CM19TSUdOX0tFWV9TSVpFLCBzZXMtPnNtYjNlbmNy
eXB0aW9ua2V5KTsKLQljaWZzX2RiZyhWRlMsICJTZXJ2ZXJPdXQgS2V5ICUqcGhcbiIsCi0JCSBT
TUIzX1NJR05fS0VZX1NJWkUsIHNlcy0+c21iM2RlY3J5cHRpb25rZXkpOworCWlmICgoc2VydmVy
LT5jaXBoZXJfdHlwZSA9PSBTTUIyX0VOQ1JZUFRJT05fQUVTMjU2X0NDTSkgfHwKKwkJKHNlcnZl
ci0+Y2lwaGVyX3R5cGUgPT0gU01CMl9FTkNSWVBUSU9OX0FFUzI1Nl9HQ00pKSB7CisJCWNpZnNf
ZGJnKFZGUywgIlNlcnZlckluIEtleSAgJSpwaFxuIiwKKwkJCQlTTUIzX0dDTTI1Nl9DUllQVEtF
WV9TSVpFLCBzZXMtPnNtYjNlbmNyeXB0aW9ua2V5KTsKKwkJY2lmc19kYmcoVkZTLCAiU2VydmVy
T3V0IEtleSAlKnBoXG4iLAorCQkJCVNNQjNfR0NNMjU2X0NSWVBUS0VZX1NJWkUsIHNlcy0+c21i
M2RlY3J5cHRpb25rZXkpOworCX0gZWxzZSB7CisJCWNpZnNfZGJnKFZGUywgIlNlcnZlckluIEtl
eSAgJSpwaFxuIiwKKwkJCQlTTUIzX0dDTTEyOF9DUllQVEtFWV9TSVpFLCBzZXMtPnNtYjNlbmNy
eXB0aW9ua2V5KTsKKwkJY2lmc19kYmcoVkZTLCAiU2VydmVyT3V0IEtleSAlKnBoXG4iLAorCQkJ
CVNNQjNfR0NNMTI4X0NSWVBUS0VZX1NJWkUsIHNlcy0+c21iM2RlY3J5cHRpb25rZXkpOworCX0K
ICNlbmRpZgogCXJldHVybiByYzsKIH0KLS0gCjIuMjUuMQoK
--000000000000f66bd805be6954bb--
