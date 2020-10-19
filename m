Return-Path: <SRS0=xrBw=D2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F2E7C433E7
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Oct 2020 07:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B53F22243
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Oct 2020 07:28:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uXkUyfKy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbgJSH2y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Oct 2020 03:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727420AbgJSH2y (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Oct 2020 03:28:54 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539D5C061755
        for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2020 00:28:54 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x7so10179886wrl.3
        for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2020 00:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T9kW5tsMHR8hY9Kdwdtf3e4jijodpFGpPAKdcAMdJuU=;
        b=uXkUyfKyKSQ3oDhw/G8k3Gj5J+GGlS+xB0ZEPU7BS3NyICCJtTzAk1FSf8ij6SQ+IT
         Xtzbug4HHNcehELo7r3MNFnt7M8wQuYqkqGsLnDShf+r12qL5iSK+cKarH9uXzJNLo3y
         z7qR2yZv3lOCd42/eD8qniR+RcukWu7LDVybsDX2lzDvEvDKknPE/Pw+lsFJq24cReEM
         jgisDdXXyxG9HGky26NPcbwfq4DhXqe83xVDWXVGTm+yF015RB+Doygbs/EYRsjczzst
         Ch/NqHFzr7U2exbE5hO5JfRlLMjh1dchXebxxEV/TFl6CG+vf/NFCbtHiTOP8ktsS/Fm
         1TYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T9kW5tsMHR8hY9Kdwdtf3e4jijodpFGpPAKdcAMdJuU=;
        b=KYKxXz4ageQEKJLojneK4YIFCV6sOsYkNadgmM6U055v9Ew7zDRGdO6D0m6sEUMwCj
         lNQWvB+M/JRnvxQ71IF3wTZUGu0sBRXQVpKUQo/A6sGY0Q51bgAVR5ku+N7vYlb5esnD
         w8QFyVgIttCG/LcmEZ9gnogdFT1vxtCAD6n3qCxDwcmnf2wCoCJENKNQ6hnMv1NrAZJT
         F2WdGSdvh+LLhkttFnndf1Sb1iotBs5jRflk10quByN+46veoTX5Wjpw0yhAg0muNodN
         teJZAfZBKfcJxw21hyboxi7+9V1ikkh9QK/wYcrnNPdz+TovyYljc5KuPLrjYmINEmBF
         7oug==
X-Gm-Message-State: AOAM533syUfT3+lkXNPJWAmHZtuzyr/HCn/6EJFDVIZ59T1pCwiyTtw0
        SAujrT2k2jpOnBbxxJIJORrmEZJU7tao0BO/5WzLSWLO
X-Google-Smtp-Source: ABdhPJy/2zBSAE4mkfTBgyF933uaw8lqj9j163+ZGBBGn4J5z/leiUQg5GTN1jAb/rk8/Wkvs3imTOIKtrPeHbWKVqE=
X-Received: by 2002:adf:9282:: with SMTP id 2mr17552718wrn.43.1603092532924;
 Mon, 19 Oct 2020 00:28:52 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0YWG1Ni5JnOpnH4OVnF7RpiE_E_WXYrTBEP=K+SL=Yuog@mail.gmail.com>
 <CAH2r5msodNEQPFO7fwY1wpy=qUNPTH+8iPDxZSvMrjg+SkJHEg@mail.gmail.com>
 <CAKywueR8u8DHUF7s9WXiowN5s2e_jmT5CqRBNS3qfewmmBcJhw@mail.gmail.com>
 <CACdtm0Y7mFEbF0FtUR2+M54mWnPpMtR=QOESUu=a4HKgEzfTPg@mail.gmail.com> <CAKywueSQQPBKrfGX-a1cFdHAv9X8xFnqALz27ws+OGNZ35n==A@mail.gmail.com>
In-Reply-To: <CAKywueSQQPBKrfGX-a1cFdHAv9X8xFnqALz27ws+OGNZ35n==A@mail.gmail.com>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Mon, 19 Oct 2020 12:58:41 +0530
Message-ID: <CACdtm0ahqPsvpdz7AMHixvo_kdb09sJ4H03Oa1f=qiWiN9_c8w@mail.gmail.com>
Subject: Re: [PATCH] Resolve data corruption of TCP server info fields
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        sribhat.msa@outlook.com, linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000f7df1505b20110de"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000f7df1505b20110de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Pavel,

Corrected the patch with the suggested changes.
Attached the patch.

Regards,
Rohith

On Thu, Oct 15, 2020 at 9:39 PM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> In receive_encrypted_standard(), server->total_read is set to the
> total packet length before calling decrypt_raw_data(). The total
> packet length includes the transform header but the idea of updating
> server->total_read after decryption is to set it to a decrypted packet
> size without the transform header (see memmove in decrypt_raw_data).
>
> We would probably need to backport the patch to stable trees, so, I
> would try to make the smallest possible change in terms of scope -
> meaning just fixing the read codepath with esize mount option turned
> on.
>
> --
> Best regards,
> Pavel Shilovsky
>
> =D1=81=D1=80, 14 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 20:21, Rohith Su=
rabattula <rohiths.msft@gmail.com>:
> >
> > Hi Pavel,
> >
> > In receive_encrypted_standard function also, server->total_read is
> > updated properly before calling decrypt_raw_data. So, no need to
> > update the same field again.
> >
> > I have checked all instances where decrypt_raw_data is used and didn=E2=
=80=99t
> > find any issue.
> >
> > Regards,
> > Rohith
> >
> > On Thu, Oct 15, 2020 at 4:18 AM Pavel Shilovsky <piastryyy@gmail.com> w=
rote:
> > >
> > > Hi Rohith,
> > >
> > > Thanks for catching the problem and proposing the patch!
> > >
> > > I think there is a problem with just removing server->total_read
> > > updates inside decrypt_raw_data():
> > >
> > > The same function is used in receive_encrypted_standard() which then
> > > calls cifs_handle_standard(). The latter uses server->total_read in a=
t
> > > least two places: in server->ops->check_message and cifs_dump_mem().
> > >
> > > There may be other places in the code that assume server->total_read
> > > to be correct. I would avoid simply removing this in all code paths
> > > and would rather make a more specific fix for the offloaded reads.
> > >
> > > --
> > > Best regards,
> > > Pavel Shilovsky
> > >
> > > =D1=87=D1=82, 8 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 13:36, Steve =
French <smfrench@gmail.com>:
> > > >
> > > > Fixed up 2 small checkpatch warnings and merged into cifs-2.6.git f=
or-next
> > > >
> > > > On Thu, Oct 8, 2020 at 9:40 AM Rohith Surabattula
> > > > <rohiths.msft@gmail.com> wrote:
> > > > >
> > > > > Hi All,
> > > > >
> > > > > With the "esize" mount option, I observed data corruption and cif=
s
> > > > > reconnects during performance tests.
> > > > >
> > > > > TCP server info field server->total_read is modified parallely by
> > > > > demultiplex thread and decrypt offload worker thread. server->tot=
al_read
> > > > > is used in calculation to discard the remaining data of PDU which=
 is
> > > > > not read into memory.
> > > > >
> > > > > Because of parallel modification, =E2=80=9Cserver->total_read=E2=
=80=9D value got
> > > > > corrupted and instead of discarding the remaining data, it discar=
ded
> > > > > some valid data from the next PDU.
> > > > >
> > > > > server->total_read field is already updated properly during read =
from
> > > > > socket. So, no need to update the same field again after decrypti=
on.
> > > > >
> > > > > Regards,
> > > > > Rohith
> > > >
> > > >
> > > >
> > > > --
> > > > Thanks,
> > > >
> > > > Steve

--000000000000f7df1505b20110de
Content-Type: application/octet-stream; 
	name="0001-Resolve-data-corruption-of-TCP-server-info-fields.patch"
Content-Disposition: attachment; 
	filename="0001-Resolve-data-corruption-of-TCP-server-info-fields.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kgg7vqil0>
X-Attachment-Id: f_kgg7vqil0

RnJvbSAwNWIzOGZlNzIwYzllYThhYTQzMGE2YTY5MjMxMWM3OWNhZmUyMzNkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNAbWljcm9zb2Z0
LmNvbT4KRGF0ZTogVGh1LCA4IE9jdCAyMDIwIDA5OjU4OjQxICswMDAwClN1YmplY3Q6IFtQQVRD
SF0gUmVzb2x2ZSBkYXRhIGNvcnJ1cHRpb24gb2YgVENQIHNlcnZlciBpbmZvIGZpZWxkcwoKVENQ
IHNlcnZlciBpbmZvIGZpZWxkIHNlcnZlci0+dG90YWxfcmVhZCBpcyBtb2RpZmllZCBwYXJhbGxl
bHkgYnkKZGVtdWx0aXBsZXggdGhyZWFkIGFuZCBkZWNyeXB0IG9mZmxvYWQgd29ya2VyIHRocmVh
ZC4gc2VydmVyLT50b3RhbF9yZWFkCmlzIHVzZWQgaW4gY2FsY3VsYXRpb24gdG8gZGlzY2FyZCB0
aGUgcmVtYWluaW5nIGRhdGEgb2YgUERVIHdoaWNoIGlzCm5vdCByZWFkIGludG8gbWVtb3J5LgoK
QmVjYXVzZSBvZiBwYXJhbGxlbCBtb2RpZmljYXRpb24sIHNlcnZlci0+dG90YWxfcmVhZCBjYW4g
Z2V0IGNvcnJ1cHRlZAphbmQgY2FuIHJlc3VsdCBpbiBkaXNjYXJkaW5nIHRoZSB2YWxpZCBkYXRh
IG9mIG5leHQgUERVLgoKU2lnbmVkLW9mZi1ieTogUm9oaXRoIFN1cmFiYXR0dWxhIDxyb2hpdGhz
QG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIyb3BzLmMgfCAxMiArKysrKysrLS0tLS0K
IDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvZnMvY2lmcy9zbWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMuYwppbmRleCAzMmY5MGRj
ODJjODQuLjMxMzgxNzNmNjNhMiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyb3BzLmMKKysrIGIv
ZnMvY2lmcy9zbWIyb3BzLmMKQEAgLTQxMDMsNyArNDEwMyw4IEBAIHNtYjNfaXNfdHJhbnNmb3Jt
X2hkcih2b2lkICpidWYpCiBzdGF0aWMgaW50CiBkZWNyeXB0X3Jhd19kYXRhKHN0cnVjdCBUQ1Bf
U2VydmVyX0luZm8gKnNlcnZlciwgY2hhciAqYnVmLAogCQkgdW5zaWduZWQgaW50IGJ1Zl9kYXRh
X3NpemUsIHN0cnVjdCBwYWdlICoqcGFnZXMsCi0JCSB1bnNpZ25lZCBpbnQgbnBhZ2VzLCB1bnNp
Z25lZCBpbnQgcGFnZV9kYXRhX3NpemUpCisJCSB1bnNpZ25lZCBpbnQgbnBhZ2VzLCB1bnNpZ25l
ZCBpbnQgcGFnZV9kYXRhX3NpemUsCisJCSBib29sIGlzX29mZmxvYWRlZCkKIHsKIAlzdHJ1Y3Qg
a3ZlYyBpb3ZbMl07CiAJc3RydWN0IHNtYl9ycXN0IHJxc3QgPSB7TlVMTH07CkBAIC00MTI5LDcg
KzQxMzAsOCBAQCBkZWNyeXB0X3Jhd19kYXRhKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZl
ciwgY2hhciAqYnVmLAogCiAJbWVtbW92ZShidWYsIGlvdlsxXS5pb3ZfYmFzZSwgYnVmX2RhdGFf
c2l6ZSk7CiAKLQlzZXJ2ZXItPnRvdGFsX3JlYWQgPSBidWZfZGF0YV9zaXplICsgcGFnZV9kYXRh
X3NpemU7CisJaWYgKCFpc19vZmZsb2FkZWQpCisJCXNlcnZlci0+dG90YWxfcmVhZCA9IGJ1Zl9k
YXRhX3NpemUgKyBwYWdlX2RhdGFfc2l6ZTsKIAogCXJldHVybiByYzsKIH0KQEAgLTQzNDIsNyAr
NDM0NCw3IEBAIHN0YXRpYyB2b2lkIHNtYjJfZGVjcnlwdF9vZmZsb2FkKHN0cnVjdCB3b3JrX3N0
cnVjdCAqd29yaykKIAlzdHJ1Y3QgbWlkX3FfZW50cnkgKm1pZDsKIAogCXJjID0gZGVjcnlwdF9y
YXdfZGF0YShkdy0+c2VydmVyLCBkdy0+YnVmLCBkdy0+c2VydmVyLT52YWxzLT5yZWFkX3JzcF9z
aXplLAotCQkJICAgICAgZHctPnBwYWdlcywgZHctPm5wYWdlcywgZHctPmxlbik7CisJCQkgICAg
ICBkdy0+cHBhZ2VzLCBkdy0+bnBhZ2VzLCBkdy0+bGVuLCB0cnVlKTsKIAlpZiAocmMpIHsKIAkJ
Y2lmc19kYmcoVkZTLCAiZXJyb3IgZGVjcnlwdGluZyByYz0lZFxuIiwgcmMpOwogCQlnb3RvIGZy
ZWVfcGFnZXM7CkBAIC00NDQ4LDcgKzQ0NTAsNyBAQCByZWNlaXZlX2VuY3J5cHRlZF9yZWFkKHN0
cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwgc3RydWN0IG1pZF9xX2VudHJ5ICoqbWlkLAog
CiBub25fb2ZmbG9hZGVkX2RlY3J5cHQ6CiAJcmMgPSBkZWNyeXB0X3Jhd19kYXRhKHNlcnZlciwg
YnVmLCBzZXJ2ZXItPnZhbHMtPnJlYWRfcnNwX3NpemUsCi0JCQkgICAgICBwYWdlcywgbnBhZ2Vz
LCBsZW4pOworCQkJICAgICAgcGFnZXMsIG5wYWdlcywgbGVuLCBmYWxzZSk7CiAJaWYgKHJjKQog
CQlnb3RvIGZyZWVfcGFnZXM7CiAKQEAgLTQ1MDQsNyArNDUwNiw3IEBAIHJlY2VpdmVfZW5jcnlw
dGVkX3N0YW5kYXJkKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwKIAlzZXJ2ZXItPnRv
dGFsX3JlYWQgKz0gbGVuZ3RoOwogCiAJYnVmX3NpemUgPSBwZHVfbGVuZ3RoIC0gc2l6ZW9mKHN0
cnVjdCBzbWIyX3RyYW5zZm9ybV9oZHIpOwotCWxlbmd0aCA9IGRlY3J5cHRfcmF3X2RhdGEoc2Vy
dmVyLCBidWYsIGJ1Zl9zaXplLCBOVUxMLCAwLCAwKTsKKwlsZW5ndGggPSBkZWNyeXB0X3Jhd19k
YXRhKHNlcnZlciwgYnVmLCBidWZfc2l6ZSwgTlVMTCwgMCwgMCwgZmFsc2UpOwogCWlmIChsZW5n
dGgpCiAJCXJldHVybiBsZW5ndGg7CiAKLS0gCjIuMjUuMQoK
--000000000000f7df1505b20110de--
