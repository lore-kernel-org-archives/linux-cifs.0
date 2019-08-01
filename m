Return-Path: <SRS0=8TPy=V5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1457C19759
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Aug 2019 17:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99874204EC
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Aug 2019 17:13:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lr++wZb3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732327AbfHARNg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Aug 2019 13:13:36 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33205 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731747AbfHARNg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Aug 2019 13:13:36 -0400
Received: by mail-pg1-f193.google.com with SMTP id n190so3119509pgn.0
        for <linux-cifs@vger.kernel.org>; Thu, 01 Aug 2019 10:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5LnDnssFNI2r2iy9SZB32EyFtQAl0/3mPNdPCS0dF4E=;
        b=Lr++wZb3TCNiBfHGSIk5iX5NVvJq1B2rUgiTsD/BhA88wtFvA1bEHazxfOkwkV6N2W
         +W6i4FSAx7DNZeQkBsnqXbFgVOIasLz0QoptaeTPzUbCVho1ON8lHKUxcqrVJtZpnzRW
         xyL0doZcWTB3I6KxODK6lhLtepwjleRipuylcNNyV9UODXyI2Apk59GcJtxpOKHJ53ye
         VgeIFMWRIP2jtmgJbUFUA6e8fnAeLWv0Tr+zU+itM0p2gXD4MxdDPpu7BNodo8Zc4nm2
         cUGdEB0UbMGpx9K2uyEtYKKJEgetzp1+OHiCH9jBF+x+xxbF9FJ1dOZfqy1f1j29mm2v
         6wyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5LnDnssFNI2r2iy9SZB32EyFtQAl0/3mPNdPCS0dF4E=;
        b=oA0yeJW/prkSANsnL/tjmcijXALGy39bIg+3V0iZ2fPGo0TylhFzcPj196ghkvBjBY
         EUGPAdUtpcgZksGeja4DbpMHxbaW8CkOtndLLhYZprfXnvOGzVwknInzUjSPghYUT78V
         gtJyjyzou5Ssb9oOaGexqvj8YHhnp/0xGQN/SzStKydBFWz7D4k+wBDJ4oP2gPNrS6Lk
         8y27HLSAtuid8h+kVh4JCIVJlHb0IFWbDZvz5kIPpwugtvQ1CC0hzV5F+PUZb5GtUEWl
         Rg/Lhlc4SHJqoJmT27veVnvPoAHI47/TtQeOXl/zeHJ/SkTeAVr45Qi+YBpllAeRQ8do
         Cy2g==
X-Gm-Message-State: APjAAAW16OauokoDMFcdXr0jYXb12H+kkVtO2VQjsFz5jq/8z5CzCCJY
        31jD65VzQVMuIiefpJmHGET31LN5HwLRXi8Pdeg=
X-Google-Smtp-Source: APXvYqyBiZAeH63tq3e65AzxEfiBW7+4MBYxO6hEdY80yQd5rhRsrlcrp+JQZ18p5OHRTxuNtJxZu6DJPqs/jY3CdOo=
X-Received: by 2002:a63:724b:: with SMTP id c11mr41592880pgn.30.1564679614836;
 Thu, 01 Aug 2019 10:13:34 -0700 (PDT)
MIME-Version: 1.0
References: <380e1b86-1911-b8a5-6b02-276b6d4be4fe@wallix.com> <CAKywueSO=choOsw6THnEnmN4UwhACHU1o1pJX8ypx0wjVTmiKQ@mail.gmail.com>
In-Reply-To: <CAKywueSO=choOsw6THnEnmN4UwhACHU1o1pJX8ypx0wjVTmiKQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 1 Aug 2019 12:13:23 -0500
Message-ID: <CAH2r5ms1qgpPrB+oOHWF7TVoZ36g3iska1PQ3dBGMrscq2K51g@mail.gmail.com>
Subject: Re: PROBLEM: Kernel oops when mounting a encryptData CIFS share with CONFIG_DEBUG_VIRTUAL
To:     Pavel Shilovsky <pavel.shilovsky@gmail.com>
Cc:     Sebastien Tisserant <stisserant@wallix.com>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Cristian Popi <cpopi@wallix.com>,
        Cyrille Mucchietto <cmucchietto@wallix.com>
Content-Type: multipart/mixed; boundary="000000000000a15fb3058f115c54"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000a15fb3058f115c54
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sebastien,
I cleaned up the patch and merged into cifs-2.6.git - can you
doublecheck it is correct?


On Thu, Jul 25, 2019 at 3:35 PM Pavel Shilovsky
<pavel.shilovsky@gmail.com> wrote:
>
> =D1=87=D1=82, 25 =D0=B8=D1=8E=D0=BB. 2019 =D0=B3. =D0=B2 09:57, Sebastien=
 Tisserant via samba-technical
> <samba-technical@lists.samba.org>:
> ...
> >
> > mount works without CONFIG_DEBUG_VIRTUAL
> >
> > If we don't set CONFIG_VMAP_STACK mount works with CONFIG_DEBUG_VIRTUAL
> >
> >
> > We have the following (very quick and dirty) patch :
> >
> > Index: linux-4.19.60/fs/cifs/smb2ops.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-4.19.60.orig/fs/cifs/smb2ops.c
> > +++ linux-4.19.60/fs/cifs/smb2ops.c
> > @@ -2545,7 +2545,15 @@ fill_transform_hdr(struct smb2_transform
> >  static inline void smb2_sg_set_buf(struct scatterlist *sg, const void =
*buf,
> >                     unsigned int buflen)
> >  {
> > -    sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
> > +      void *addr;
> > +      /*
> > +       * VMAP_STACK (at least) puts stack into the vmalloc address spa=
ce
> > +      */
> > +      if (is_vmalloc_addr(buf))
> > +              addr =3D vmalloc_to_page(buf);
> > +      else
> > +              addr =3D virt_to_page(buf);
> > +      sg_set_page(sg, addr, buflen, offset_in_page(buf));
> >  }
> >
> >  /* Assumes the first rqst has a transform header as the first iov.
> >
> >
>
> Thanks for reporting this. The patch looks good to me. Did you test
> your scenario all together with it (not only mounting)?
>
>
> Best regards,
> Pavel Shilovskiy



--=20
Thanks,

Steve

--000000000000a15fb3058f115c54
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-Kernel-oops-mounting-a-encryptData-share-with-C.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-Kernel-oops-mounting-a-encryptData-share-with-C.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jysxu1660>
X-Attachment-Id: f_jysxu1660

RnJvbSBlN2FmZGE2NWJlMzE5ODYzOWRlMGZjZjE3OTZkZGQwYTEwMWUxYWIxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWJhc3RpZW4gVGlzc2VyYW50IDxzdGlzc2VyYW50QHdhbGxp
eC5jb20+CkRhdGU6IFRodSwgMSBBdWcgMjAxOSAxMjowNjowOCAtMDUwMApTdWJqZWN0OiBbUEFU
Q0hdIFNNQjM6IEtlcm5lbCBvb3BzIG1vdW50aW5nIGEgZW5jcnlwdERhdGEgc2hhcmUgd2l0aAog
Q09ORklHX0RFQlVHX1ZJUlRVQUwKCkZpeCBrZXJuZWwgb29wcyB3aGVuIG1vdW50aW5nIGEgZW5j
cnlwdERhdGEgQ0lGUyBzaGFyZSB3aXRoCkNPTkZJR19ERUJVR19WSVJUVUFMCgpTaWduZWQtb2Zm
LWJ5OiBTZWJhc3RpZW4gVGlzc2VyYW50IDxzdGlzc2VyYW50QHdhbGxpeC5jb20+ClJldmlld2Vk
LWJ5OiBQYXZlbCBTaGlsb3Zza3kgPHBzaGlsb3ZAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZz
L3NtYjJvcHMuYyB8IDEwICsrKysrKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2Np
ZnMvc21iMm9wcy5jCmluZGV4IGZjNDY0ZGMyMGIzMC4uM2UzMjQzZDcxNTJjIDEwMDY0NAotLS0g
YS9mcy9jaWZzL3NtYjJvcHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtMzUxMCw3ICsz
NTEwLDE1IEBAIGZpbGxfdHJhbnNmb3JtX2hkcihzdHJ1Y3Qgc21iMl90cmFuc2Zvcm1faGRyICp0
cl9oZHIsIHVuc2lnbmVkIGludCBvcmlnX2xlbiwKIHN0YXRpYyBpbmxpbmUgdm9pZCBzbWIyX3Nn
X3NldF9idWYoc3RydWN0IHNjYXR0ZXJsaXN0ICpzZywgY29uc3Qgdm9pZCAqYnVmLAogCQkJCSAg
IHVuc2lnbmVkIGludCBidWZsZW4pCiB7Ci0Jc2dfc2V0X3BhZ2Uoc2csIHZpcnRfdG9fcGFnZShi
dWYpLCBidWZsZW4sIG9mZnNldF9pbl9wYWdlKGJ1ZikpOworCXZvaWQgKmFkZHI7CisJLyoKKwkg
KiBWTUFQX1NUQUNLIChhdCBsZWFzdCkgcHV0cyBzdGFjayBpbnRvIHRoZSB2bWFsbG9jIGFkZHJl
c3Mgc3BhY2UKKwkgKi8KKwlpZiAoaXNfdm1hbGxvY19hZGRyKGJ1ZikpCisJCWFkZHIgPSB2bWFs
bG9jX3RvX3BhZ2UoYnVmKTsKKwllbHNlCisJCWFkZHIgPSB2aXJ0X3RvX3BhZ2UoYnVmKTsKKwlz
Z19zZXRfcGFnZShzZywgYWRkciwgYnVmbGVuLCBvZmZzZXRfaW5fcGFnZShidWYpKTsKIH0KIAog
LyogQXNzdW1lcyB0aGUgZmlyc3QgcnFzdCBoYXMgYSB0cmFuc2Zvcm0gaGVhZGVyIGFzIHRoZSBm
aXJzdCBpb3YuCi0tIAoyLjIwLjEKCg==
--000000000000a15fb3058f115c54--
