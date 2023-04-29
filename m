Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75001C77B61
	for <linux-cifs@archiver.kernel.org>; Sat, 29 Apr 2023 02:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjD2Cb7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Apr 2023 22:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjD2Cb7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Apr 2023 22:31:59 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29E22D50
        for <linux-cifs@vger.kernel.org>; Fri, 28 Apr 2023 19:31:57 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 38308e7fff4ca-2a8bcfbf276so3694931fa.3
        for <linux-cifs@vger.kernel.org>; Fri, 28 Apr 2023 19:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682735515; x=1685327515;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kubkalQ1b6Dx3BHJ50aR91Rm6UWvXo2dRPq6Cp6F+kI=;
        b=P5b5m6Fn/ks83pGoy/lvBRqxkoyKaLBfpuDege/9IVUBh7TaqGRyw9z0DBgmyMcEK4
         D0kBvLYy62P8uAe+esXBrpSOs3BU6bP4vMpgo8kDWXfcUGLlfXsCs81O/+2mhgEe4V5B
         kIfsCkH11vAcWgG1PkIbSaLkU8LZ5RPw4lphs/wtfOaO3HinvALBKVLfjpvvYYXctzUE
         yiqRV0I1pzr5wxQ1SFtK+yC2gbQtzqZmSzISw4Wst8sL+HbGHBOAop5rYWW8Falk4DsN
         KksYBOE3xLrI55/BmSCjsCzslhmgDBmCMM+OUu0Foifj3DAyUm+BXN6WSI7ThsMhDixs
         0Uhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682735515; x=1685327515;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kubkalQ1b6Dx3BHJ50aR91Rm6UWvXo2dRPq6Cp6F+kI=;
        b=BigqGcLEYWrDYUvWHtV6iWosiEYq5ARz8MBIlgyLUkyeKg1MaAgUNBNTiAktmJuXVM
         0zbEpYQiqS1E9hsAGloarbYjIC8ZqioNPd/tbjcrfK0uD76JSAX1JqOHjo1bWlCSxuX+
         KS2RI8iGTA1rZ/mhpqOAXLBkUKxHvC8ZyYDD3o0X+km5qBWUEWvN7oMTSRomfnv41p4Q
         k9QRDqRhzpS41pCcSF3TO6/y54OiFu8z7I9cedhBDPIFaVh7Ya6gWMArVuOtPsZL040q
         X5PF0YLjLBn1dULfNRknw2iRAasOA1Rc2eGqFR4PMiOtrlQfKUczpXz5/XQ/4fABk9Z/
         oD3A==
X-Gm-Message-State: AC+VfDzMi8mkMWCyFdFkqe1leWQLcUoGntOLwTj9JR9qqACFI9mlMaJH
        wPU0trjZgFNFTVHqnOClBHqGpjOQ0pAfIt7wvSQZ9jEK
X-Google-Smtp-Source: ACHHUZ5E9rM6bf6GmpxmdRohKPiDCZDA35N9uBDaWxHEnZjYM416Urlb/QPFNCvOrC3b5aE1kDGcJr5w20Yz9zRNfcM=
X-Received: by 2002:a2e:9d0c:0:b0:2ab:19a0:667b with SMTP id
 t12-20020a2e9d0c000000b002ab19a0667bmr2040640lji.0.1682735515265; Fri, 28 Apr
 2023 19:31:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms+mTNU746nkbAjb9FOdiaAcK9rQK76NMv6Njd0MsDq7A@mail.gmail.com>
 <CAH2r5muyLyhc_y8k6XwTyfpF4hhSTAezRmvfCCd+wjzpLqkwMg@mail.gmail.com> <CAH2r5muDPGgFQoXhME0MDUH+9enrpcFW5z=XBLBB_gRTz7hu=g@mail.gmail.com>
In-Reply-To: <CAH2r5muDPGgFQoXhME0MDUH+9enrpcFW5z=XBLBB_gRTz7hu=g@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 28 Apr 2023 21:31:43 -0500
Message-ID: <CAH2r5mspEcMGsgeWqNpNSLxCnog1XJt7U_m6aM=fuBDhzsNHNQ@mail.gmail.com>
Subject: Re: [PATCH][CIFS] fix incorrect size for query_on_disk_id
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Content-Type: multipart/mixed; boundary="000000000000a3c8ef05fa706472"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000a3c8ef05fa706472
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

attached wrong patch - resending with right attachment


On Fri, Apr 28, 2023 at 9:30=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> As Paulo pointed out - size was not incorrect, just confusing when the
> two structs (cifs and ksmbd)
> differed.  I fixed the patch description.
>
> On Fri, Apr 28, 2023 at 12:48=E2=80=AFAM Steve French <smfrench@gmail.com=
> wrote:
> >
> > forgot to remove the old incorrect struct (now unused).  Patch fixed
> > and reattached
> >
> > On Fri, Apr 28, 2023 at 12:24=E2=80=AFAM Steve French <smfrench@gmail.c=
om> wrote:
> > >
> > > We were assuming the wrong size for the struct, use the ksmbd
> > >     version of this struct and move it to common code.
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
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--000000000000a3c8ef05fa706472
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-make-query_on_disk_id-open-context-consistent-a.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-make-query_on_disk_id-open-context-consistent-a.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lh1d9r1s0>
X-Attachment-Id: f_lh1d9r1s0

RnJvbSA5MzdmMzA2NDk4NzYyMDY0N2I4ZmVlZWU2ZmJlNmM0OWExNjcyNWRkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMjggQXByIDIwMjMgMDA6MjE6MTAgLTA1MDAKU3ViamVjdDogW1BBVENIIDEv
Ml0gc21iMzogbWFrZSBxdWVyeV9vbl9kaXNrX2lkIG9wZW4gY29udGV4dCBjb25zaXN0ZW50IGFu
ZAogbW92ZSB0byBjb21tb24gY29kZQoKY2lmcyBhbmQga3NtYmQgd2VyZSB1c2luZyBhIHNsaWdo
dGx5IGRpZmZlcmVudCB2ZXJzaW9uIG9mIHRoZSBxdWVyeV9vbl9kaXNrX2lkCnN0cnVjdCB3aGlj
aCBjb3VsZCBiZSBjb25mdXNpbmcuIFVzZSB0aGUga3NtYmQgdmVyc2lvbiBvZiB0aGlzIHN0cnVj
dCwgYW5kCm1vdmUgaXQgdG8gY29tbW9uIGNvZGUuCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVu
Y2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIycGR1LmMgICAgICAg
ICB8ICAyICstCiBmcy9jaWZzL3NtYjJwZHUuaCAgICAgICAgIHwgIDkgLS0tLS0tLS0tCiBmcy9r
c21iZC9zbWIycGR1LmggICAgICAgIHwgIDggLS0tLS0tLS0KIGZzL3NtYmZzX2NvbW1vbi9zbWIy
cGR1LmggfCAxMSArKysrKysrKysrKwogNCBmaWxlcyBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCsp
LCAxOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuYyBiL2ZzL2Np
ZnMvc21iMnBkdS5jCmluZGV4IDI4MWUwYjEyNjU4ZC4uMDUyMWFhMWRhNjQ0IDEwMDY0NAotLS0g
YS9mcy9jaWZzL3NtYjJwZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUuYwpAQCAtMjA2Myw3ICsy
MDYzLDcgQEAgY3JlYXRlX3JlY29ubmVjdF9kdXJhYmxlX2J1ZihzdHJ1Y3QgY2lmc19maWQgKmZp
ZCkKIHN0YXRpYyB2b2lkCiBwYXJzZV9xdWVyeV9pZF9jdHh0KHN0cnVjdCBjcmVhdGVfY29udGV4
dCAqY2MsIHN0cnVjdCBzbWIyX2ZpbGVfYWxsX2luZm8gKmJ1ZikKIHsKLQlzdHJ1Y3QgY3JlYXRl
X29uX2Rpc2tfaWQgKnBkaXNrX2lkID0gKHN0cnVjdCBjcmVhdGVfb25fZGlza19pZCAqKWNjOwor
CXN0cnVjdCBjcmVhdGVfZGlza19pZF9yc3AgKnBkaXNrX2lkID0gKHN0cnVjdCBjcmVhdGVfZGlz
a19pZF9yc3AgKiljYzsKIAogCWNpZnNfZGJnKEZZSSwgInBhcnNlIHF1ZXJ5IGlkIGNvbnRleHQg
MHglbGx4IDB4JWxseFxuIiwKIAkJcGRpc2tfaWQtPkRpc2tGaWxlSWQsIHBkaXNrX2lkLT5Wb2x1
bWVJZCk7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuaCBiL2ZzL2NpZnMvc21iMnBkdS5o
CmluZGV4IDIxMTRlOGEwYzYzYS4uZWZlNTVhNTcyZTRjIDEwMDY0NAotLS0gYS9mcy9jaWZzL3Nt
YjJwZHUuaAorKysgYi9mcy9jaWZzL3NtYjJwZHUuaApAQCAtMTcwLDE1ICsxNzAsNiBAQCBzdHJ1
Y3QgZHVyYWJsZV9yZWNvbm5lY3RfY29udGV4dF92MiB7CiAJX19sZTMyIEZsYWdzOyAvKiBzZWUg
YWJvdmUgREhBTkRMRV9GTEFHX1BFUlNJU1RFTlQgKi8KIH0gX19wYWNrZWQ7CiAKLS8qIFNlZSBN
Uy1TTUIyIDIuMi4xNC4yLjkgKi8KLXN0cnVjdCBjcmVhdGVfb25fZGlza19pZCB7Ci0Jc3RydWN0
IGNyZWF0ZV9jb250ZXh0IGNjb250ZXh0OwotCV9fdTggICBOYW1lWzhdOwotCV9fbGU2NCBEaXNr
RmlsZUlkOwotCV9fbGU2NCBWb2x1bWVJZDsKLQlfX3UzMiAgUmVzZXJ2ZWRbNF07Ci19IF9fcGFj
a2VkOwotCiAvKiBTZWUgTVMtU01CMiAyLjIuMTQuMi4xMiAqLwogc3RydWN0IGR1cmFibGVfcmVj
b25uZWN0X2NvbnRleHRfdjJfcnNwIHsKIAlfX2xlMzIgVGltZW91dDsKZGlmZiAtLWdpdCBhL2Zz
L2tzbWJkL3NtYjJwZHUuaCBiL2ZzL2tzbWJkL3NtYjJwZHUuaAppbmRleCA5NDIwZGQyODEzZmIu
LmJjZjcxZmQ0ZGMxZSAxMDA2NDQKLS0tIGEvZnMva3NtYmQvc21iMnBkdS5oCisrKyBiL2ZzL2tz
bWJkL3NtYjJwZHUuaApAQCAtMTQ0LDE0ICsxNDQsNiBAQCBzdHJ1Y3QgY3JlYXRlX214YWNfcnNw
IHsKIAlfX2xlMzIgTWF4aW1hbEFjY2VzczsKIH0gX19wYWNrZWQ7CiAKLXN0cnVjdCBjcmVhdGVf
ZGlza19pZF9yc3AgewotCXN0cnVjdCBjcmVhdGVfY29udGV4dCBjY29udGV4dDsKLQlfX3U4ICAg
TmFtZVs4XTsKLQlfX2xlNjQgRGlza0ZpbGVJZDsKLQlfX2xlNjQgVm9sdW1lSWQ7Ci0JX191OCAg
UmVzZXJ2ZWRbMTZdOwotfSBfX3BhY2tlZDsKLQogLyogZXF1aXZhbGVudCBvZiB0aGUgY29udGVu
dHMgb2YgU01CMy4xLjEgUE9TSVggb3BlbiBjb250ZXh0IHJlc3BvbnNlICovCiBzdHJ1Y3QgY3Jl
YXRlX3Bvc2l4X3JzcCB7CiAJc3RydWN0IGNyZWF0ZV9jb250ZXh0IGNjb250ZXh0OwpkaWZmIC0t
Z2l0IGEvZnMvc21iZnNfY29tbW9uL3NtYjJwZHUuaCBiL2ZzL3NtYmZzX2NvbW1vbi9zbWIycGR1
LmgKaW5kZXggMzM0ZjExZWQ1MTQ2Li40M2M5MmU4OThlZTkgMTAwNjQ0Ci0tLSBhL2ZzL3NtYmZz
X2NvbW1vbi9zbWIycGR1LmgKKysrIGIvZnMvc21iZnNfY29tbW9uL3NtYjJwZHUuaApAQCAtMTE4
MSw2ICsxMTgxLDcgQEAgc3RydWN0IGNyZWF0ZV9wb3NpeCB7CiAKICNkZWZpbmUgU01CMl9MRUFT
RV9LRVlfU0laRQkJCTE2CiAKKy8qIFNlZSBNUy1TTUIyIDIuMi4xMy4yLjggKi8KIHN0cnVjdCBs
ZWFzZV9jb250ZXh0IHsKIAlfX3U4IExlYXNlS2V5W1NNQjJfTEVBU0VfS0VZX1NJWkVdOwogCV9f
bGUzMiBMZWFzZVN0YXRlOwpAQCAtMTE4OCw2ICsxMTg5LDcgQEAgc3RydWN0IGxlYXNlX2NvbnRl
eHQgewogCV9fbGU2NCBMZWFzZUR1cmF0aW9uOwogfSBfX3BhY2tlZDsKIAorLyogU2VlIE1TLVNN
QjIgMi4yLjEzLjIuMTAgKi8KIHN0cnVjdCBsZWFzZV9jb250ZXh0X3YyIHsKIAlfX3U4IExlYXNl
S2V5W1NNQjJfTEVBU0VfS0VZX1NJWkVdOwogCV9fbGUzMiBMZWFzZVN0YXRlOwpAQCAtMTIxMSw2
ICsxMjEzLDE1IEBAIHN0cnVjdCBjcmVhdGVfbGVhc2VfdjIgewogCV9fdTggICBQYWRbNF07CiB9
IF9fcGFja2VkOwogCisvKiBTZWUgTVMtU01CMiAyLjIuMTQuMi45ICovCitzdHJ1Y3QgY3JlYXRl
X2Rpc2tfaWRfcnNwIHsKKwlzdHJ1Y3QgY3JlYXRlX2NvbnRleHQgY2NvbnRleHQ7CisJX191OCAg
IE5hbWVbOF07CisJX19sZTY0IERpc2tGaWxlSWQ7CisJX19sZTY0IFZvbHVtZUlkOworCV9fdTgg
IFJlc2VydmVkWzE2XTsKK30gX19wYWNrZWQ7CisKIC8qIFNlZSBNUy1TTUIyIDIuMi4zMSBhbmQg
Mi4yLjMyICovCiBzdHJ1Y3Qgc21iMl9pb2N0bF9yZXEgewogCXN0cnVjdCBzbWIyX2hkciBoZHI7
Ci0tIAoyLjM0LjEKCg==
--000000000000a3c8ef05fa706472--
