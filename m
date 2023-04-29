Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C81DAC77B60
	for <linux-cifs@archiver.kernel.org>; Sat, 29 Apr 2023 02:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjD2CaS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Apr 2023 22:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjD2CaR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Apr 2023 22:30:17 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509672D50
        for <linux-cifs@vger.kernel.org>; Fri, 28 Apr 2023 19:30:16 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4f0037de1d1so700530e87.0
        for <linux-cifs@vger.kernel.org>; Fri, 28 Apr 2023 19:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682735414; x=1685327414;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IbANFY5nnvKO6smaITJLH+HgNZZEV0ky3z8GA/Wnruk=;
        b=hHvhQpg0L5TmFSxmJnSAHV3i2MwZuy9cQXo9xSBGayXOFg2zl4AKLfnDe3u6AckNiv
         nunSpJQf6L0ub08CYkegH1RAaCrEny2xeLzcG+6rzh5gyNjPBV8Wmb3xwSH03mnvp+ks
         KByLwyAtLAOXkYkTsFFjUEVPiyRn1TNwBYwHb0D2w3Bk+OWzvRWX7Np6tFZmjFsfotRD
         F2vd21K7nw5716y/0iPQraNCeIAuX+zwhB1XqcbYzeoISzypI96jHvLZExUfUch5f+8g
         6wFdcX5w7IELJ4NTpHpvOFeuCH8tFmNer+1VfCXs8IcKsDRjRQBmB/d9I2RsKsXUPvhD
         dR+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682735414; x=1685327414;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IbANFY5nnvKO6smaITJLH+HgNZZEV0ky3z8GA/Wnruk=;
        b=je5EJ4+Hl1cJTe6JAAEwX9p5NilYkfXexqVmGCUxTapcUL2s7UIwoScLUdTgiccDOu
         hr3xQ39H5LJJHJ15U3IDR1K7ek6tEbDEGv/tzOxOTghxLEvIaB4KrnISC86eA1kFwZtO
         lpwrRT+h1Tle0oNKx7vv5l2FoUMd4atUFg3Gp/j+MCUAnrjViBuKjH5Yvzpg+c2oPNf7
         xnfuYrQ8wEm5TYyQwhunSd8QoNDSvDmIQazdYA8kTKteJ+yyldz9kIK3cWcow+ozBkDM
         7YnMK77E3ad0hjCwn+RaR5p8xKdkNg7PDOgiw00TZYzbE2KUUQauUFFMDf7rVj2xs5PK
         hvhQ==
X-Gm-Message-State: AC+VfDzRmBxR8lxJyuWeYt0FcQptVIfCbJVb9FSYSZKnG1ArXgsqMXGZ
        /pSbRTsmVl4BWjzXikRX3IlNfCEjTqu8crQqsxhf+2Pw
X-Google-Smtp-Source: ACHHUZ4bwr6eSDqgJ9r4sH2MN8eFfPyW2XPGQVncdpJowBU23gTc680kThmSKqx9ZtvQJNe/fJegTuIGz7zNYMn90zk=
X-Received: by 2002:a05:6512:15a:b0:4f0:5b4:4863 with SMTP id
 m26-20020a056512015a00b004f005b44863mr1915941lfo.0.1682735413900; Fri, 28 Apr
 2023 19:30:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms+mTNU746nkbAjb9FOdiaAcK9rQK76NMv6Njd0MsDq7A@mail.gmail.com>
 <CAH2r5muyLyhc_y8k6XwTyfpF4hhSTAezRmvfCCd+wjzpLqkwMg@mail.gmail.com>
In-Reply-To: <CAH2r5muyLyhc_y8k6XwTyfpF4hhSTAezRmvfCCd+wjzpLqkwMg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 28 Apr 2023 21:30:02 -0500
Message-ID: <CAH2r5muDPGgFQoXhME0MDUH+9enrpcFW5z=XBLBB_gRTz7hu=g@mail.gmail.com>
Subject: Re: [PATCH][CIFS] fix incorrect size for query_on_disk_id
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Content-Type: multipart/mixed; boundary="00000000000098db2d05fa705ef4"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000098db2d05fa705ef4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

As Paulo pointed out - size was not incorrect, just confusing when the
two structs (cifs and ksmbd)
differed.  I fixed the patch description.

On Fri, Apr 28, 2023 at 12:48=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> forgot to remove the old incorrect struct (now unused).  Patch fixed
> and reattached
>
> On Fri, Apr 28, 2023 at 12:24=E2=80=AFAM Steve French <smfrench@gmail.com=
> wrote:
> >
> > We were assuming the wrong size for the struct, use the ksmbd
> >     version of this struct and move it to common code.
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

--00000000000098db2d05fa705ef4
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-move-some-common-open-context-structs-to-smbfs_.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-move-some-common-open-context-structs-to-smbfs_.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lh1d7l7j0>
X-Attachment-Id: f_lh1d7l7j0

RnJvbSBmODRiZTM5OGZlODNiNzlhYTZjNTBhNmM0NjljYjI1ZmUyNTYyZTk3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMjggQXByIDIwMjMgMDA6NDE6NTggLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBtb3ZlIHNvbWUgY29tbW9uIG9wZW4gY29udGV4dCBzdHJ1Y3RzIHRvIHNtYmZzX2NvbW1v
bgoKY3JlYXRlIGR1cmFibGUgYW5kIGNyZWF0ZSBkdXJhYmxlIHJlY29ubmVjdCBjb250ZXh0IGFu
ZCB0aGUgbWF4aW1hbAphY2Nlc3MgY3JlYXRlIGNvbnRleHQgc3RydWN0IGRlZmluaXRpb25zIGNh
biBiZSBwdXQgaW4gY29tbW9uIGNvZGUgaW4Kc21iZnNfY29tbW9uCgpTaWduZWQtb2ZmLWJ5OiBT
dGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIycGR1
LmggICAgICAgICB8IDExIC0tLS0tLS0tLS0tCiBmcy9rc21iZC9zbWIycGR1LmggICAgICAgIHwg
MjUgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogZnMvc21iZnNfY29tbW9uL3NtYjJwZHUuaCB8
IDI4ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysKIDMgZmlsZXMgY2hhbmdlZCwgMjggaW5z
ZXJ0aW9ucygrKSwgMzYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycGR1
LmggYi9mcy9jaWZzL3NtYjJwZHUuaAppbmRleCBlZmU1NWE1NzJlNGMuLjIyMDk5NGQwYTBmNyAx
MDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmgKKysrIGIvZnMvY2lmcy9zbWIycGR1LmgKQEAg
LTEzMiwxNyArMTMyLDYgQEAgc3RydWN0IHNoYXJlX3JlZGlyZWN0X2Vycm9yX2NvbnRleHRfcnNw
IHsKICNkZWZpbmUgU01CMl9MRUFTRV9IQU5ETEVfQ0FDSElOR19IRQkweDAyCiAjZGVmaW5lIFNN
QjJfTEVBU0VfV1JJVEVfQ0FDSElOR19IRQkweDA0CiAKLXN0cnVjdCBjcmVhdGVfZHVyYWJsZSB7
Ci0Jc3RydWN0IGNyZWF0ZV9jb250ZXh0IGNjb250ZXh0OwotCV9fdTggICBOYW1lWzhdOwotCXVu
aW9uIHsKLQkJX191OCAgUmVzZXJ2ZWRbMTZdOwotCQlzdHJ1Y3QgewotCQkJX191NjQgUGVyc2lz
dGVudEZpbGVJZDsKLQkJCV9fdTY0IFZvbGF0aWxlRmlsZUlkOwotCQl9IEZpZDsKLQl9IERhdGE7
Ci19IF9fcGFja2VkOwogCiAvKiBTZWUgTVMtU01CMiAyLjIuMTMuMi4xMSAqLwogLyogRmxhZ3Mg
Ki8KZGlmZiAtLWdpdCBhL2ZzL2tzbWJkL3NtYjJwZHUuaCBiL2ZzL2tzbWJkL3NtYjJwZHUuaApp
bmRleCBiY2Y3MWZkNGRjMWUuLjY3ZGM1NTJmMmVmNyAxMDA2NDQKLS0tIGEvZnMva3NtYmQvc21i
MnBkdS5oCisrKyBiL2ZzL2tzbWJkL3NtYjJwZHUuaApAQCAtNzAsMTggKzcwLDYgQEAgc3RydWN0
IGNyZWF0ZV9kdXJhYmxlX3JlcV92MiB7CiAJX191OCBDcmVhdGVHdWlkWzE2XTsKIH0gX19wYWNr
ZWQ7CiAKLXN0cnVjdCBjcmVhdGVfZHVyYWJsZV9yZWNvbm5fcmVxIHsKLQlzdHJ1Y3QgY3JlYXRl
X2NvbnRleHQgY2NvbnRleHQ7Ci0JX191OCAgIE5hbWVbOF07Ci0JdW5pb24gewotCQlfX3U4ICBS
ZXNlcnZlZFsxNl07Ci0JCXN0cnVjdCB7Ci0JCQlfX3U2NCBQZXJzaXN0ZW50RmlsZUlkOwotCQkJ
X191NjQgVm9sYXRpbGVGaWxlSWQ7Ci0JCX0gRmlkOwotCX0gRGF0YTsKLX0gX19wYWNrZWQ7Ci0K
IHN0cnVjdCBjcmVhdGVfZHVyYWJsZV9yZWNvbm5fdjJfcmVxIHsKIAlzdHJ1Y3QgY3JlYXRlX2Nv
bnRleHQgY2NvbnRleHQ7CiAJX191OCAgIE5hbWVbOF07CkBAIC0xMDksMTIgKzk3LDYgQEAgc3Ry
dWN0IGNyZWF0ZV9hcHBfaW5zdF9pZF92ZXJzIHsKIAlfX2xlNjQgQXBwSW5zdGFuY2VWZXJzaW9u
TG93OwogfSBfX3BhY2tlZDsKIAotc3RydWN0IGNyZWF0ZV9teGFjX3JlcSB7Ci0Jc3RydWN0IGNy
ZWF0ZV9jb250ZXh0IGNjb250ZXh0OwotCV9fdTggICBOYW1lWzhdOwotCV9fbGU2NCBUaW1lc3Rh
bXA7Ci19IF9fcGFja2VkOwotCiBzdHJ1Y3QgY3JlYXRlX2FsbG9jX3NpemVfcmVxIHsKIAlzdHJ1
Y3QgY3JlYXRlX2NvbnRleHQgY2NvbnRleHQ7CiAJX191OCAgIE5hbWVbOF07CkBAIC0xMzcsMTMg
KzExOSw2IEBAIHN0cnVjdCBjcmVhdGVfZHVyYWJsZV92Ml9yc3AgewogCV9fbGUzMiBGbGFnczsK
IH0gX19wYWNrZWQ7CiAKLXN0cnVjdCBjcmVhdGVfbXhhY19yc3AgewotCXN0cnVjdCBjcmVhdGVf
Y29udGV4dCBjY29udGV4dDsKLQlfX3U4ICAgTmFtZVs4XTsKLQlfX2xlMzIgUXVlcnlTdGF0dXM7
Ci0JX19sZTMyIE1heGltYWxBY2Nlc3M7Ci19IF9fcGFja2VkOwotCiAvKiBlcXVpdmFsZW50IG9m
IHRoZSBjb250ZW50cyBvZiBTTUIzLjEuMSBQT1NJWCBvcGVuIGNvbnRleHQgcmVzcG9uc2UgKi8K
IHN0cnVjdCBjcmVhdGVfcG9zaXhfcnNwIHsKIAlzdHJ1Y3QgY3JlYXRlX2NvbnRleHQgY2NvbnRl
eHQ7CmRpZmYgLS1naXQgYS9mcy9zbWJmc19jb21tb24vc21iMnBkdS5oIGIvZnMvc21iZnNfY29t
bW9uL3NtYjJwZHUuaAppbmRleCA0M2M5MmU4OThlZTkuLjNiNDNhNTFlNmY3ZSAxMDA2NDQKLS0t
IGEvZnMvc21iZnNfY29tbW9uL3NtYjJwZHUuaAorKysgYi9mcy9zbWJmc19jb21tb24vc21iMnBk
dS5oCkBAIC0xMTcyLDYgKzExNzIsMzQgQEAgc3RydWN0IGNyZWF0ZV9wb3NpeCB7CiAJX191MzIg
ICBSZXNlcnZlZDsKIH0gX19wYWNrZWQ7CiAKKy8qIFNlZSBNUy1TTUIyIDIuMi4xMy4yLjMgYW5k
IE1TLVNNQjIgMi4yLjEzLjIuNCAqLworc3RydWN0IGNyZWF0ZV9kdXJhYmxlIHsKKwlzdHJ1Y3Qg
Y3JlYXRlX2NvbnRleHQgY2NvbnRleHQ7CisJX191OCAgIE5hbWVbOF07CisJdW5pb24geworCQlf
X3U4ICBSZXNlcnZlZFsxNl07CisJCXN0cnVjdCB7CisJCQlfX3U2NCBQZXJzaXN0ZW50RmlsZUlk
OworCQkJX191NjQgVm9sYXRpbGVGaWxlSWQ7CisJCX0gRmlkOworCX0gRGF0YTsKK30gX19wYWNr
ZWQ7CisKKy8qIFNlZSBNUy1TTUIyIDIuMi4xMy4yLjUgKi8KK3N0cnVjdCBjcmVhdGVfbXhhY19y
ZXEgeworCXN0cnVjdCBjcmVhdGVfY29udGV4dCBjY29udGV4dDsKKwlfX3U4ICAgTmFtZVs4XTsK
KwlfX2xlNjQgVGltZXN0YW1wOworfSBfX3BhY2tlZDsKKworLyogU2VlIE1TLVNNQjIgMi4yLjE0
LjIuNSAqLworc3RydWN0IGNyZWF0ZV9teGFjX3JzcCB7CisJc3RydWN0IGNyZWF0ZV9jb250ZXh0
IGNjb250ZXh0OworCV9fdTggICBOYW1lWzhdOworCV9fbGUzMiBRdWVyeVN0YXR1czsKKwlfX2xl
MzIgTWF4aW1hbEFjY2VzczsKK30gX19wYWNrZWQ7CisKICNkZWZpbmUgU01CMl9MRUFTRV9OT05F
X0xFCQkJY3B1X3RvX2xlMzIoMHgwMCkKICNkZWZpbmUgU01CMl9MRUFTRV9SRUFEX0NBQ0hJTkdf
TEUJCWNwdV90b19sZTMyKDB4MDEpCiAjZGVmaW5lIFNNQjJfTEVBU0VfSEFORExFX0NBQ0hJTkdf
TEUJCWNwdV90b19sZTMyKDB4MDIpCi0tIAoyLjM0LjEKCg==
--00000000000098db2d05fa705ef4--
