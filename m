Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 806EEC77B60
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Apr 2023 05:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjD1Fsr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Apr 2023 01:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345171AbjD1Fsq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Apr 2023 01:48:46 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549D12D65
        for <linux-cifs@vger.kernel.org>; Thu, 27 Apr 2023 22:48:44 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4efea4569f5so7591682e87.3
        for <linux-cifs@vger.kernel.org>; Thu, 27 Apr 2023 22:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682660922; x=1685252922;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wqjgbmsYsMkZ6eC3MabADIbC+0b8uCCAxkga6OD8xrw=;
        b=f5vMskTWd56vuqjnXox/o3NWUC7tBnAZ4WkrUJSgUUKW8KO8s+jYhgoaYCjF/XW+dI
         z3hv9L48X+179W2nG/dcwY07u03RPHR3Pz/F7PdUyBZUXiNWiPcwXgbjfxXCIqG0YiDb
         MHpzhyrjkbzqa+R1Dvg1OyHLp4jfm88WLDo/UF/MbW0Z642q1TAJAlKJeT/seo5/vWIy
         mMSwtF3RcAXYjewbqI4DAVkDj0nzqUIHWhT44JUMRp5hRxil8WlJwlMWqim4lTjD9oLR
         Sy6Ov5dO2oPY1LriagYtiRwwiLRi9BCCP5MCZco0I2VvM5RYPlgfGwL19P/tmnS/5ywj
         XL7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682660922; x=1685252922;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wqjgbmsYsMkZ6eC3MabADIbC+0b8uCCAxkga6OD8xrw=;
        b=jbgIRfwLbTqFjRifhsQsXf+B+o0hAL1XaUBuDhfw+aPeXOpMQEAUXQu8M5N0r7GJzz
         meh0rahtYnjudYIsNd2odad0bFyDps8mnNW2tLU6Ap9WUSKqd6YxGW+sUCMXjcW5zdYf
         EIzK6HyDqLIbiZc7xW6lFSXIv7qjTPK9moe1M3mHPhUdAZ/73uk+1p56+BqTIZeebY74
         olj4n7iAPd4fNv50LU8YeZRc8yoeRhuO3YbBXp0+Wb5MwMowjrmEYhLR0xAGmdjXsM9D
         pFn1vbzftj/Kwzh00LXm/Lj5haKLbEFGpGh1tNdxitDAlYzisg8S/cQNJsolRVNqgGAA
         Wm+g==
X-Gm-Message-State: AC+VfDwpCJWW2Yy9+vKeP3CSlbQzkEFFW3lNZAY3tao1WzUF0rjVdS03
        F7PoP4lqLnnT8mnlSvC66UtyF8rxgYN0FMbpbhpQ17oi
X-Google-Smtp-Source: ACHHUZ4TNJMQ2vwCTudjzxYjO9OIj20XXlrEr3vVFOBLnd/H4fCebX3/MXoLe5tel+bnGa7lsMo39gVFFETCp30LJH0=
X-Received: by 2002:a05:6512:484:b0:4eb:40d4:e0d2 with SMTP id
 v4-20020a056512048400b004eb40d4e0d2mr1286142lfq.38.1682660922011; Thu, 27 Apr
 2023 22:48:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms+mTNU746nkbAjb9FOdiaAcK9rQK76NMv6Njd0MsDq7A@mail.gmail.com>
In-Reply-To: <CAH2r5ms+mTNU746nkbAjb9FOdiaAcK9rQK76NMv6Njd0MsDq7A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 28 Apr 2023 00:48:30 -0500
Message-ID: <CAH2r5muyLyhc_y8k6XwTyfpF4hhSTAezRmvfCCd+wjzpLqkwMg@mail.gmail.com>
Subject: Re: [PATCH][CIFS] fix incorrect size for query_on_disk_id
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Content-Type: multipart/mixed; boundary="00000000000088e23205fa5f06cf"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000088e23205fa5f06cf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

forgot to remove the old incorrect struct (now unused).  Patch fixed
and reattached

On Fri, Apr 28, 2023 at 12:24=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> We were assuming the wrong size for the struct, use the ksmbd
>     version of this struct and move it to common code.
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

--00000000000088e23205fa5f06cf
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-incorrect-size-for-query_on_disk_id-open-co.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-incorrect-size-for-query_on_disk_id-open-co.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lh04uyw80>
X-Attachment-Id: f_lh04uyw80

RnJvbSA2MTRmMjE1YzdiNzM3MWFjNzZhYThiMjM0YjIxYjU5N2MwNjgwMTAwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMjggQXByIDIwMjMgMDA6MjE6MTAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggaW5jb3JyZWN0IHNpemUgZm9yIHF1ZXJ5X29uX2Rpc2tfaWQgb3BlbiBjb250ZXh0
CgpXZSB3ZXJlIGFzc3VtaW5nIHRoZSB3cm9uZyBzaXplIGZvciB0aGUgc3RydWN0LCB1c2UgdGhl
IGtzbWJkCnZlcnNpb24gb2YgdGhpcyBzdHJ1Y3QgYW5kIG1vdmUgaXQgdG8gY29tbW9uIGNvZGUu
CgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0t
LQogZnMvY2lmcy9zbWIycGR1LmMgICAgICAgICB8ICAyICstCiBmcy9jaWZzL3NtYjJwZHUuaCAg
ICAgICAgIHwgIDkgLS0tLS0tLS0tCiBmcy9rc21iZC9zbWIycGR1LmggICAgICAgIHwgIDggLS0t
LS0tLS0KIGZzL3NtYmZzX2NvbW1vbi9zbWIycGR1LmggfCAxMSArKysrKysrKysrKwogNCBmaWxl
cyBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCAxOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9mcy9jaWZzL3NtYjJwZHUuYyBiL2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4IDI4MWUwYjEyNjU4
ZC4uMDUyMWFhMWRhNjQ0IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuYworKysgYi9mcy9j
aWZzL3NtYjJwZHUuYwpAQCAtMjA2Myw3ICsyMDYzLDcgQEAgY3JlYXRlX3JlY29ubmVjdF9kdXJh
YmxlX2J1ZihzdHJ1Y3QgY2lmc19maWQgKmZpZCkKIHN0YXRpYyB2b2lkCiBwYXJzZV9xdWVyeV9p
ZF9jdHh0KHN0cnVjdCBjcmVhdGVfY29udGV4dCAqY2MsIHN0cnVjdCBzbWIyX2ZpbGVfYWxsX2lu
Zm8gKmJ1ZikKIHsKLQlzdHJ1Y3QgY3JlYXRlX29uX2Rpc2tfaWQgKnBkaXNrX2lkID0gKHN0cnVj
dCBjcmVhdGVfb25fZGlza19pZCAqKWNjOworCXN0cnVjdCBjcmVhdGVfZGlza19pZF9yc3AgKnBk
aXNrX2lkID0gKHN0cnVjdCBjcmVhdGVfZGlza19pZF9yc3AgKiljYzsKIAogCWNpZnNfZGJnKEZZ
SSwgInBhcnNlIHF1ZXJ5IGlkIGNvbnRleHQgMHglbGx4IDB4JWxseFxuIiwKIAkJcGRpc2tfaWQt
PkRpc2tGaWxlSWQsIHBkaXNrX2lkLT5Wb2x1bWVJZCk7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3Nt
YjJwZHUuaCBiL2ZzL2NpZnMvc21iMnBkdS5oCmluZGV4IDIxMTRlOGEwYzYzYS4uZWZlNTVhNTcy
ZTRjIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuaAorKysgYi9mcy9jaWZzL3NtYjJwZHUu
aApAQCAtMTcwLDE1ICsxNzAsNiBAQCBzdHJ1Y3QgZHVyYWJsZV9yZWNvbm5lY3RfY29udGV4dF92
MiB7CiAJX19sZTMyIEZsYWdzOyAvKiBzZWUgYWJvdmUgREhBTkRMRV9GTEFHX1BFUlNJU1RFTlQg
Ki8KIH0gX19wYWNrZWQ7CiAKLS8qIFNlZSBNUy1TTUIyIDIuMi4xNC4yLjkgKi8KLXN0cnVjdCBj
cmVhdGVfb25fZGlza19pZCB7Ci0Jc3RydWN0IGNyZWF0ZV9jb250ZXh0IGNjb250ZXh0OwotCV9f
dTggICBOYW1lWzhdOwotCV9fbGU2NCBEaXNrRmlsZUlkOwotCV9fbGU2NCBWb2x1bWVJZDsKLQlf
X3UzMiAgUmVzZXJ2ZWRbNF07Ci19IF9fcGFja2VkOwotCiAvKiBTZWUgTVMtU01CMiAyLjIuMTQu
Mi4xMiAqLwogc3RydWN0IGR1cmFibGVfcmVjb25uZWN0X2NvbnRleHRfdjJfcnNwIHsKIAlfX2xl
MzIgVGltZW91dDsKZGlmZiAtLWdpdCBhL2ZzL2tzbWJkL3NtYjJwZHUuaCBiL2ZzL2tzbWJkL3Nt
YjJwZHUuaAppbmRleCA5NDIwZGQyODEzZmIuLmJjZjcxZmQ0ZGMxZSAxMDA2NDQKLS0tIGEvZnMv
a3NtYmQvc21iMnBkdS5oCisrKyBiL2ZzL2tzbWJkL3NtYjJwZHUuaApAQCAtMTQ0LDE0ICsxNDQs
NiBAQCBzdHJ1Y3QgY3JlYXRlX214YWNfcnNwIHsKIAlfX2xlMzIgTWF4aW1hbEFjY2VzczsKIH0g
X19wYWNrZWQ7CiAKLXN0cnVjdCBjcmVhdGVfZGlza19pZF9yc3AgewotCXN0cnVjdCBjcmVhdGVf
Y29udGV4dCBjY29udGV4dDsKLQlfX3U4ICAgTmFtZVs4XTsKLQlfX2xlNjQgRGlza0ZpbGVJZDsK
LQlfX2xlNjQgVm9sdW1lSWQ7Ci0JX191OCAgUmVzZXJ2ZWRbMTZdOwotfSBfX3BhY2tlZDsKLQog
LyogZXF1aXZhbGVudCBvZiB0aGUgY29udGVudHMgb2YgU01CMy4xLjEgUE9TSVggb3BlbiBjb250
ZXh0IHJlc3BvbnNlICovCiBzdHJ1Y3QgY3JlYXRlX3Bvc2l4X3JzcCB7CiAJc3RydWN0IGNyZWF0
ZV9jb250ZXh0IGNjb250ZXh0OwpkaWZmIC0tZ2l0IGEvZnMvc21iZnNfY29tbW9uL3NtYjJwZHUu
aCBiL2ZzL3NtYmZzX2NvbW1vbi9zbWIycGR1LmgKaW5kZXggYWNlMTMzY2Y2MDcyLi5lYWI4MDFl
ZTVjZjMgMTAwNjQ0Ci0tLSBhL2ZzL3NtYmZzX2NvbW1vbi9zbWIycGR1LmgKKysrIGIvZnMvc21i
ZnNfY29tbW9uL3NtYjJwZHUuaApAQCAtMTE4MCw2ICsxMTgwLDcgQEAgc3RydWN0IGNyZWF0ZV9w
b3NpeCB7CiAKICNkZWZpbmUgU01CMl9MRUFTRV9LRVlfU0laRQkJCTE2CiAKKy8qIFNlZSBNUy1T
TUIyIDIuMi4xMy4yLjggKi8KIHN0cnVjdCBsZWFzZV9jb250ZXh0IHsKIAlfX3U4IExlYXNlS2V5
W1NNQjJfTEVBU0VfS0VZX1NJWkVdOwogCV9fbGUzMiBMZWFzZVN0YXRlOwpAQCAtMTE4Nyw2ICsx
MTg4LDcgQEAgc3RydWN0IGxlYXNlX2NvbnRleHQgewogCV9fbGU2NCBMZWFzZUR1cmF0aW9uOwog
fSBfX3BhY2tlZDsKIAorLyogU2VlIE1TLVNNQjIgMi4yLjEzLjIuMTAgKi8KIHN0cnVjdCBsZWFz
ZV9jb250ZXh0X3YyIHsKIAlfX3U4IExlYXNlS2V5W1NNQjJfTEVBU0VfS0VZX1NJWkVdOwogCV9f
bGUzMiBMZWFzZVN0YXRlOwpAQCAtMTIxMCw2ICsxMjEyLDE1IEBAIHN0cnVjdCBjcmVhdGVfbGVh
c2VfdjIgewogCV9fdTggICBQYWRbNF07CiB9IF9fcGFja2VkOwogCisvKiBTZWUgTVMtU01CMiAy
LjIuMTQuMi45ICovCitzdHJ1Y3QgY3JlYXRlX2Rpc2tfaWRfcnNwIHsKKwlzdHJ1Y3QgY3JlYXRl
X2NvbnRleHQgY2NvbnRleHQ7CisJX191OCAgIE5hbWVbOF07CisJX19sZTY0IERpc2tGaWxlSWQ7
CisJX19sZTY0IFZvbHVtZUlkOworCV9fdTggIFJlc2VydmVkWzE2XTsKK30gX19wYWNrZWQ7CisK
IC8qIFNlZSBNUy1TTUIyIDIuMi4zMSBhbmQgMi4yLjMyICovCiBzdHJ1Y3Qgc21iMl9pb2N0bF9y
ZXEgewogCXN0cnVjdCBzbWIyX2hkciBoZHI7Ci0tIAoyLjM0LjEKCg==
--00000000000088e23205fa5f06cf--
