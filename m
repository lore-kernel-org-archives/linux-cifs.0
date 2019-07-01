Return-Path: <SRS0=A2J+=U6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B1ADC5B578
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Jul 2019 21:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E9F520665
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Jul 2019 21:05:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JSJxaBst"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfGAVFC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Jul 2019 17:05:02 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45271 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbfGAVFB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Jul 2019 17:05:01 -0400
Received: by mail-pl1-f194.google.com with SMTP id bi6so7938420plb.12;
        Mon, 01 Jul 2019 14:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9TxhAvO9zqAfxuKK8PfvfOCDHKXA4YLihM6253x59/Q=;
        b=JSJxaBstqFZKbF2uwtUC+RgbaVu19OlukIYYjnsLbDW8o7UXh++H+tFzsjZCkoGQeL
         4f8+/EX0gs8ZbQ0hYtLP0WushVycqWKx0cv7tHlcWSMj0N6az2xYwcpeogULMW4FKL/I
         1AZhuoDkhtXPqaagbe1grxRA3h/eAbGworSZveeSRu/9mT3iqRhk8DE8mRBxSephFWAy
         kg6HIlJpjZvT6yJfrdOK1yhheAQIMR7yewY46Sg1tC9GWKNPFpqHSYDYxgrvYumfEUvH
         fXfHVtAQmHuhVlfp3IlrHeHwCN9iRKwdR+Dc1n8Vkxl/SCdMJtt4SUzwCd8IeQVntUrn
         vtUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9TxhAvO9zqAfxuKK8PfvfOCDHKXA4YLihM6253x59/Q=;
        b=YIaaA91iQld2qUu/IjiN78gWxXvaQYMUD+nDZ2Iu/JmYKIAFtsiUqzgTHD8LWWAhSa
         dBaV1Bm6r3LDQWdnIBrBzQT97PQMtmbYnJ60SW50+2gqxHS6Gw2N9c2VyuOclco5WM3S
         nxX4m0MDrZnHMqh2DetsblCEQx53Qn4hq4HN12k5jJkIV6YaHdNYX/JqFrOyMI9/3mEq
         zFAzOCYGbyQ6J+wfQHffAGSoi8sL4w8E7/if+W8R4Bt2XmiQKGboSne/EwlyWt11OG6w
         /9m5JFoBAqruBf9ojnQbNCcwsF+1Xkc49jyLb8M36zkiSOoPuwcCzpvYO9+04Ch2DOyp
         ajDQ==
X-Gm-Message-State: APjAAAU2ua5a88ucZgL1lRkjp8KIMLqUaEiJfRr+5cbaTMvXK1PCzXag
        1z+fd7KKzBXJRXPJWD8AWnCkYfS1Q7WCaCFIe7Y=
X-Google-Smtp-Source: APXvYqzhWaBYh+OXaLyUrrHU2hgCXHUa/EEucvYceNVZUyL8/hvy3wIdjun0LOA71RTxAo4nsKWQM2IIleJCfnADpio=
X-Received: by 2002:a17:902:2a68:: with SMTP id i95mr31602176plb.167.1562015100563;
 Mon, 01 Jul 2019 14:05:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190701030325.18188-1-sergey.senozhatsky@gmail.com>
In-Reply-To: <20190701030325.18188-1-sergey.senozhatsky@gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 1 Jul 2019 16:04:49 -0500
Message-ID: <CAH2r5mutRM0d9oLG0rpRAzTC9DMWL61i0ewbri8v7Lgu1Ud5yQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix build by selecting CONFIG_KEYS
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000341b41058ca4fb33"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000341b41058ca4fb33
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I had already merged the attached (similar) fix into cifs-2.6.git for-next


On Sun, Jun 30, 2019 at 10:24 PM Sergey Senozhatsky
<sergey.senozhatsky.work@gmail.com> wrote:
>
> CONFIG_CIFS_ACL had a dependency "depends on KEYS" which was
> dropped with the removal of CONFIG_CIFS_ACL. This breaks the
> build on systems which don't have CONFIG_KEYS in .config:
>
> cifsacl.c:37:15: error: variable =E2=80=98cifs_idmap_key_acl=E2=80=99 has
>                  initializer but incomplete type
>    37 | static struct key_acl cifs_idmap_key_acl =3D {
>       |               ^~~~~~~
> cifsacl.c:38:3: error: =E2=80=98struct key_acl=E2=80=99 has no member
>                 named =E2=80=98usage=E2=80=99
>    38 |  .usage =3D REFCOUNT_INIT(1),
>       |   ^~~~~
> [..]
>
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> ---
>  fs/cifs/Kconfig   | 1 +
>  fs/cifs/cifsacl.c | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index 3eee73449bdd..5912751e6f09 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -17,6 +17,7 @@ config CIFS
>         select CRYPTO_ECB
>         select CRYPTO_AES
>         select CRYPTO_DES
> +       select KEYS
>         help
>           This is the client VFS module for the SMB3 family of NAS protoc=
ols,
>           (including support for the most recent, most secure dialect SMB=
3.1.1)
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 78eed72f3af0..8ca479caf902 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -24,6 +24,7 @@
>  #include <linux/fs.h>
>  #include <linux/slab.h>
>  #include <linux/string.h>
> +#include <linux/key.h>
>  #include <linux/keyctl.h>
>  #include <linux/key-type.h>
>  #include <keys/user-type.h>
> --
> 2.22.0
>


--=20
Thanks,

Steve

--000000000000341b41058ca4fb33
Content-Type: text/x-patch; charset="US-ASCII"; name="0001-CIFS-Fix-module-dependency.patch"
Content-Disposition: attachment; 
	filename="0001-CIFS-Fix-module-dependency.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jxkvgaqw0>
X-Attachment-Id: f_jxkvgaqw0

RnJvbSAyNzVlMzUxNTJlNzEzY2IxODYzMzhiZDI1NzEzOWVkMjhkNDk4NzI2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgMzAgSnVuIDIwMTkgMTg6MDA6NDEgLTA1MDAKU3ViamVjdDogW1BBVENIXSBD
SUZTOiBGaXggbW9kdWxlIGRlcGVuZGVuY3kKCktFWVMgaXMgcmVxdWlyZWQgbm90IHRoYXQgQ09O
RklHX0NJRlNfQUNMIGlzIGFsd2F5cyBvbgphbmQgdGhlIGlmZGVmIGZvciBpdCByZW1vdmVkLgoK
U2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0K
IGZzL2NpZnMvS2NvbmZpZyB8IDUgKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMo
KyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9LY29uZmlnIGIvZnMvY2lm
cy9LY29uZmlnCmluZGV4IGNiMzA5NmZhYmJiZS4uZTM5YzE1MjY3YmI0IDEwMDY0NAotLS0gYS9m
cy9jaWZzL0tjb25maWcKKysrIGIvZnMvY2lmcy9LY29uZmlnCkBAIC0xNyw2ICsxNyw3IEBAIGNv
bmZpZyBDSUZTCiAJc2VsZWN0IENSWVBUT19FQ0IKIAlzZWxlY3QgQ1JZUFRPX0FFUwogCXNlbGVj
dCBDUllQVE9fREVTCisJc2VsZWN0IEtFWVMKIAloZWxwCiAJICBUaGlzIGlzIHRoZSBjbGllbnQg
VkZTIG1vZHVsZSBmb3IgdGhlIFNNQjMgZmFtaWx5IG9mIE5BUyBwcm90b2NvbHMsCiAJICAoaW5j
bHVkaW5nIHN1cHBvcnQgZm9yIHRoZSBtb3N0IHJlY2VudCwgbW9zdCBzZWN1cmUgZGlhbGVjdCBT
TUIzLjEuMSkKQEAgLTExMCw3ICsxMTEsNyBAQCBjb25maWcgQ0lGU19XRUFLX1BXX0hBU0gKIAog
Y29uZmlnIENJRlNfVVBDQUxMCiAJYm9vbCAiS2VyYmVyb3MvU1BORUdPIGFkdmFuY2VkIHNlc3Np
b24gc2V0dXAiCi0JZGVwZW5kcyBvbiBDSUZTICYmIEtFWVMKKwlkZXBlbmRzIG9uIENJRlMKIAlz
ZWxlY3QgRE5TX1JFU09MVkVSCiAJaGVscAogCSAgRW5hYmxlcyBhbiB1cGNhbGwgbWVjaGFuaXNt
IGZvciBDSUZTIHdoaWNoIGFjY2Vzc2VzIHVzZXJzcGFjZSBoZWxwZXIKQEAgLTE3Nyw3ICsxNzgs
NyBAQCBjb25maWcgQ0lGU19ERUJVR19EVU1QX0tFWVMKIAogY29uZmlnIENJRlNfREZTX1VQQ0FM
TAogCWJvb2wgIkRGUyBmZWF0dXJlIHN1cHBvcnQiCi0JZGVwZW5kcyBvbiBDSUZTICYmIEtFWVMK
KwlkZXBlbmRzIG9uIENJRlMKIAlzZWxlY3QgRE5TX1JFU09MVkVSCiAJaGVscAogCSAgRGlzdHJp
YnV0ZWQgRmlsZSBTeXN0ZW0gKERGUykgc3VwcG9ydCBpcyB1c2VkIHRvIGFjY2VzcyBzaGFyZXMK
LS0gCjIuMjAuMQoK
--000000000000341b41058ca4fb33--
