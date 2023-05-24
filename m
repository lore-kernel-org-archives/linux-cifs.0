Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A92AFC7EE23
	for <linux-cifs@archiver.kernel.org>; Wed, 24 May 2023 08:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240318AbjEXImV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 May 2023 04:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240477AbjEXImC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 May 2023 04:42:02 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77691BC6
        for <linux-cifs@vger.kernel.org>; Wed, 24 May 2023 01:40:49 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2af189d323fso70536771fa.1
        for <linux-cifs@vger.kernel.org>; Wed, 24 May 2023 01:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684917648; x=1687509648;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mwzlUEgLOBGCBAK9+swrDLQw93OeIBiWQuYfcnnum/0=;
        b=oLp2T/EXJrbO+puQYaddVW69Que01zlGIaI0KyuoRmBpkRUQM0d5KX02PABEw4BYKj
         gRwie0sAYp7dv3QBaMSRRgw+HiWTxs41Akqa+GqzGaoZSFGj7VXBhYQicw0UmDKWlrlu
         HD1ClxKX88rtknJxi92EuOyI/3ZKUPnGlSocxn/e49zHDeRui+VzK57FgnDeuMPjuD/Z
         e5pS+KwL7wWnPfHiMLfBV1vXN0KzFAdatx6w2rZhMKjsVuza1jeblm5eSkvjqjsQMB70
         oP6nLrBWnb4Pu4pkqWaAbR/i5nPmJ+MwvUMGM3gawGFhG6Oyi2TUVb+LkHeZC9n10Rb9
         qozQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684917648; x=1687509648;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mwzlUEgLOBGCBAK9+swrDLQw93OeIBiWQuYfcnnum/0=;
        b=WbTWp5AcNq/J7N359OuS6z6zvrRcdlVSrqxyL9794y7UEIFPbWqVhtmDqLdlOB/RUV
         WDt65VtKYKTRbu5NgPaBNX+4A9kChPzOZjljawCwJySBc47AUjIdx1YnOznDJcXwgV9m
         SPYvbMvqLGPILDSuGRrYJotdeUydK2yIW4VFg5yuTBPut/cPAVJqaOzIUKMNLkCB4SXM
         O/PBdz0COzKPLSD0TE+QJUVUh2e5II/HYkIng6dqMcYcowD4I9moeBJ8rYluOKGyjr09
         BjfYWKYk4fTvFT5AEoYha7cQHJR+nP8ATRR1QjPDM3UqCYLGPtMnM1QNEWgeKOip4MBa
         9qmw==
X-Gm-Message-State: AC+VfDxYnBK96ZdY7SsO5TuGCwqeMbbGxSg1vLwnL251U4RsYQav9fbb
        +ytSe+OxqgXqFDQZXweJMGLkdvEgEXPcnGavn2PeIKbLjj2v9Bj3
X-Google-Smtp-Source: ACHHUZ7EinVoISPWEICAo8P3ol/RtI54woZwKrKUbfTSRD4sfYJu/02Xxq1GRWRd2SQOeW+gq8Tle6HiuacoXAMKhjE=
X-Received: by 2002:a05:651c:10a9:b0:2af:1ff0:9eb3 with SMTP id
 k9-20020a05651c10a900b002af1ff09eb3mr5776224ljn.15.1684917647382; Wed, 24 May
 2023 01:40:47 -0700 (PDT)
MIME-Version: 1.0
References: <ZG1rih4YPhwaQdQs@storage>
In-Reply-To: <ZG1rih4YPhwaQdQs@storage>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 24 May 2023 03:40:35 -0500
Message-ID: <CAH2r5mv5cj-BfhLgYJ1asPR+rQ9g5gm7tcwc1qBfQffKTiXGNQ@mail.gmail.com>
Subject: Re: Bug with mount.cifs and mapchars
To:     Tyler Spivey <tspivey8@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        David Howells <dhowells@redhat.com>
Content-Type: multipart/mixed; boundary="000000000000d972a705fc6c75ea"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000d972a705fc6c75ea
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good catch.   The conversion of cifs.ko to the new mount API in the
5.11 kernel and later broke this mount option.   Patch is attached to
fix it.

Patch is attached but here is the description:

    There are two ways that (reserved for other OS like Windows)
special characters
    have been mapped in the past ("SFU" and "SFM" mappings). The default
    for Linux has been to use "mapposix" (ie the SFM mapping) but
    the conversion to the new mount API in the 5.11 kernel broke
    the ability to override the default mapping of the reserved
    characters (like '?' and '*' and '\') via "mapchars" mount option.

    This patch fixes that - so can now mount with "mapchars"
    mount option to override the default ("mapposix" ie SFM) mapping.

    Reported-by: Tyler Spivey <tspivey8@gmail.com>
    Fixes: 24e0a1eff9e2b ("cifs: switch to new mount api")
    Signed-off-by: Steve French <stfrench@microsoft.com>

On Tue, May 23, 2023 at 8:48=E2=80=AFPM Tyler Spivey <tspivey8@gmail.com> w=
rote:
>
> Hi.
>
> Note: I'm not subscribed, please CC.
>
> I'm trying to mount a Windows 10 share from Linux with mapchars,
> but it still uses the SFM mapping.
>
> Linux storage 5.15.0-72-generic #79-Ubuntu SMP Wed Apr 19 08:22:18 UTC 20=
23 x86_64 x86_64 x86_64 GNU/Linux
> mount.cifs version: 6.14
> Command line: mount //192.168.145.1/e e -o username=3Dtyler,uid=3Dtyler,m=
apchars
>
> This also failed under Arch:
>
> Linux arch1 6.3.3-arch1-1 #1 SMP PREEMPT_DYNAMIC Sun, 21 May 2023 16:15:2=
2 +0000 x86_64 GNU/Linux
> mount.cifs version: 7.0
>
> If I create a file called test? in a directory, the ?
> shows up on the Windows machine as u+f025 (SFM mapping).
> With mapchars, I would expect u+f03f (SFU mapping).
>
> Looking at the kernel source for version 6.3.3,
> it looks like sfu_remap needs to be set for this to work.
> However, I can't find anything which sets it (mapchars doesn't seem to
> be hooked up to it).
>
> Thanks,
> Tyler



--=20
Thanks,

Steve

--000000000000d972a705fc6c75ea
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-mapchars-mount-option-ignored.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-mapchars-mount-option-ignored.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_li1gecmf0>
X-Attachment-Id: f_li1gecmf0

RnJvbSAzMGY0MjgzZjQ1Mjc1NjkwNTkyNjA1MjcwMGVmZTQyMjUyNTZjNzFkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMjQgTWF5IDIwMjMgMDM6MjY6MTkgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBtYXBjaGFycyBtb3VudCBvcHRpb24gaWdub3JlZAoKVGhlcmUgYXJlIHR3byB3YXlzIHRo
YXQgKFdpbmRvd3MsIHJlc2VydmVkKSBzcGVjaWFsIGNoYXJhY3RlcnMgaGF2ZQpiZWVuIG1hcHBl
ZCBpbiB0aGUgcGFzdCAoIlNGVSIgYW5kICJTRk0iIG1hcHBpbmdzKS4gVGhlIGRlZmF1bHQKZm9y
IExpbnV4IGhhcyBiZWVuIHRvIHVzZSAibWFwcG9zaXgiIChpZSB0aGUgU0ZNIG1hcHBpbmcpIGJ1
dAp0aGUgY29udmVyc2lvbiB0byB0aGUgbmV3IG1vdW50IEFQSSBpbiB0aGUgNS4xMSBrZXJuZWwg
YnJva2UKdGhlIGFiaWxpdHkgdG8gb3ZlcnJpZGUgdGhlIGRlZmF1bHQgbWFwcGluZyBvZiB0aGUg
cmVzZXJ2ZWQKY2hhcmFjdGVycyAobGlrZSAnPycgYW5kICcqJyBhbmQgJ1wnKSB2aWEgIm1hcGNo
YXJzIiBtb3VudCBvcHRpb24uCgpUaGlzIHBhdGNoIGZpeGVzIHRoYXQgLSBzbyBjYW4gbm93IG1v
dW50IHdpdGggIm1hcGNoYXJzIgptb3VudCBvcHRpb24gdG8gb3ZlcnJpZGUgdGhlIGRlZmF1bHQg
KCJtYXBwb3NpeCIgaWUgU0ZNKSBtYXBwaW5nLgoKUmVwb3J0ZWQtYnk6IFR5bGVyIFNwaXZleSA8
dHNwaXZleThAZ21haWwuY29tPgpGaXhlczogMjRlMGExZWZmOWUyYiAoImNpZnM6IHN3aXRjaCB0
byBuZXcgbW91bnQgYXBpIikKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBt
aWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvZnNfY29udGV4dC5jIHwgOCArKysrKysrKwogMSBm
aWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvZnNfY29u
dGV4dC5jIGIvZnMvY2lmcy9mc19jb250ZXh0LmMKaW5kZXggYWNlMTFhMWE3YzhhLi4xYmRhNzU2
MDliNjQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvZnNfY29udGV4dC5jCisrKyBiL2ZzL2NpZnMvZnNf
Y29udGV4dC5jCkBAIC05MDQsNiArOTA0LDE0IEBAIHN0YXRpYyBpbnQgc21iM19mc19jb250ZXh0
X3BhcnNlX3BhcmFtKHN0cnVjdCBmc19jb250ZXh0ICpmYywKIAkJCWN0eC0+c2Z1X3JlbWFwID0g
ZmFsc2U7IC8qIGRpc2FibGUgU0ZVIG1hcHBpbmcgKi8KIAkJfQogCQlicmVhazsKKwljYXNlIE9w
dF9tYXBjaGFyczoKKwkJaWYgKHJlc3VsdC5uZWdhdGVkKQorCQkJY3R4LT5zZnVfcmVtYXAgPSBm
YWxzZTsKKwkJZWxzZSB7CisJCQljdHgtPnNmdV9yZW1hcCA9IHRydWU7CisJCQljdHgtPnJlbWFw
ID0gZmFsc2U7IC8qIGRpc2FibGUgU0ZNIChtYXBwb3NpeCkgbWFwcGluZyAqLworCQl9CisJCWJy
ZWFrOwogCWNhc2UgT3B0X3VzZXJfeGF0dHI6CiAJCWlmIChyZXN1bHQubmVnYXRlZCkKIAkJCWN0
eC0+bm9feGF0dHIgPSAxOwotLSAKMi4zNC4xCgo=
--000000000000d972a705fc6c75ea--
