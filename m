Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C21AC43334
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jun 2022 03:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiFBDpd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Jun 2022 23:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiFBDpc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Jun 2022 23:45:32 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3921EDD2F
        for <linux-cifs@vger.kernel.org>; Wed,  1 Jun 2022 20:45:31 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id 67so3513511vsh.2
        for <linux-cifs@vger.kernel.org>; Wed, 01 Jun 2022 20:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BxeVHvh8rErYe9sju/SoRZRPjzbrW7x9CNv6K6uacE8=;
        b=nF7zC6kJBRweNF2Apvt7viILHCulciDB9lwlwuLizIemHstC5xAEzAHAbZzr5zT8me
         LIxeW+rqvvNpvHiifR7XvQtyoOeb/3sRDViQ/3jcZYjPr3Vm/ab5DZ0dfBiNoCGnbC4D
         Afu/l7dKjK2PUqoGx7U6YIN9Byw4/LNFkmQUFql3yA830+S20UvgEB6ZAZOcgNA92+2O
         Yw7s3J8APq3PaNoMGF76uOCFhVfwTA6Z9XWekz7t7n/kEPWq/H2zNBSxoeBqr/KIiM5e
         /OowXQCHjUeIobNS9pjdhw1rwqVJpQnHZ4J8bpbrTQA48bHdYwDhTYny1mLiHF9R9BKG
         xWeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BxeVHvh8rErYe9sju/SoRZRPjzbrW7x9CNv6K6uacE8=;
        b=nmDnH8ynWfkzk74U22iHe6bO7KcnP4QrWsZL3VNuBkKPA8WQrHbXWuFpK59g5hVRcq
         wvwfrI33fXoDT/oCQpjWafXagOEJUV7fN/2f6Xs5TxDzSC2Dk0YuM9udWIXiraSt8aHp
         hEeokzc6I4UCS2m3EkTJEAveo79c0xNoqGxi+k/QcXfIVec20NOgesQzHT9JNWF9Yv9/
         MJn1iOPqAp+ysTq2T2+qIyBnBacx3uWNpLEHvs0I4bIcpU2D2xCkPJ1R1F9UtG+Yl+vu
         SsoBHE1GojbTvRPrg7KjHnETkDsEBeLOKy+FxH72ze3yzV/0jdVK+M+vvyyPlCwrVVtO
         sgSg==
X-Gm-Message-State: AOAM530ua7wzGd2IVVEysZeufJCgMCv7/OnKZvsG55OV4qnl/VQyreBY
        PhfkhU0Q9j3nszIUwfBINirYVKRZ272zP6m5bg4+gfBS
X-Google-Smtp-Source: ABdhPJytLqGepTXkclHcLLzSAjaXZOLscKldGKn0W5nkKMELKa0rhr1Kdj9hxUGelySUiGdXjIkdSsnr31RlnnyzbYQ=
X-Received: by 2002:a67:1787:0:b0:337:d8cd:35b2 with SMTP id
 129-20020a671787000000b00337d8cd35b2mr1143078vsx.29.1654141530119; Wed, 01
 Jun 2022 20:45:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtUe2f0xi5zu0Np0bkyv7K9BKKgUkUJp2b25BteHBFjeg@mail.gmail.com>
In-Reply-To: <CAH2r5mtUe2f0xi5zu0Np0bkyv7K9BKKgUkUJp2b25BteHBFjeg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 1 Jun 2022 22:45:19 -0500
Message-ID: <CAH2r5mufZdKWrUGbp0Pha5C6YrYqUR-=vT2Pw8TixtzVaQuk0Q@mail.gmail.com>
Subject: Re: [PATCH][CIFS] Do not build smb1ops.c if legacy support is disabled
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000004fbd2805e06ed6e8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000004fbd2805e06ed6e8
Content-Type: text/plain; charset="UTF-8"

Another minor one to remove some unneeded SMB20 code when legacy is disabled


On Wed, Jun 1, 2022 at 9:39 PM Steve French <smfrench@gmail.com> wrote:
>
> We should not be including unused SMB1/CIFS functions when legacy
> support is disabled (CONFIG_CIFS_ALLOW_INSECURE_LEGACY turned
> off), but especially obvious is not needing to build smb1ops.c
> at all when legacy support is disabled. Over time we can move
> more SMB1/CIFS and SMB2.0 legacy functions into ifdefs but this
> is a good start (and shrinks the module size a few percent).
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--0000000000004fbd2805e06ed6e8
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-version-operations-for-smb20-unneeded-when-lega.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-version-operations-for-smb20-unneeded-when-lega.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l3wh5ctu0>
X-Attachment-Id: f_l3wh5ctu0

RnJvbSA3ZWY5M2ZmY2NkNTVmYjBiYTAwMGVkMTZlZjZhODFjZDdkZWUwN2I1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMSBKdW4gMjAyMiAyMjowODo0NiAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIGNp
ZnM6IHZlcnNpb24gb3BlcmF0aW9ucyBmb3Igc21iMjAgdW5uZWVkZWQgd2hlbiBsZWdhY3kKIHN1
cHBvcnQgZGlzYWJsZWQKCldlIHNob3VsZCBub3QgYmUgaW5jbHVkaW5nIHVudXNlZCBzbWIyMCBz
cGVjaWZpYyBjb2RlIHdoZW4gbGVnYWN5CnN1cHBvcnQgaXMgZGlzYWJsZWQgKENPTkZJR19DSUZT
X0FMTE9XX0lOU0VDVVJFX0xFR0FDWSB0dXJuZWQKb2ZmKS4gIEZvciBleGFtcGxlIHNtYjJfb3Bl
cmF0aW9ucyBhbmQgc21iMl92YWx1ZXMgYXJlbid0IHVzZWQKaW4gdGhhdCBjYXNlLiAgT3ZlciB0
aW1lIHdlIGNhbiBtb3ZlIG1vcmUgYW5kIG1vcmUgU01CMS9DSUZTIGFuZCBTTUIyLjAKY29kZSBp
bnRvIHRoZSBpbnNlY3VyZSBsZWdhY3kgaWZkZWZzCgpSZXZpZXdlZC1ieTogUm9ubmllIFNhaGxi
ZXJnIDxsc2FobGJlckByZWRoYXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0
ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzZ2xvYi5oIHwgNCArKystCiBm
cy9jaWZzL3NtYjJvcHMuYyAgfCA3ICsrKysrKy0KIDIgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRp
b25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBi
L2ZzL2NpZnMvY2lmc2dsb2IuaAppbmRleCBkNTg5ZTY4NzYxMWQuLmY4NzMzNzkwNjZjNyAxMDA2
NDQKLS0tIGEvZnMvY2lmcy9jaWZzZ2xvYi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAt
MTk2MywxMSArMTk2MywxMyBAQCBleHRlcm4gbWVtcG9vbF90ICpjaWZzX21pZF9wb29scDsKIAog
LyogT3BlcmF0aW9ucyBmb3IgZGlmZmVyZW50IFNNQiB2ZXJzaW9ucyAqLwogI2RlZmluZSBTTUIx
X1ZFUlNJT05fU1RSSU5HCSIxLjAiCisjZGVmaW5lIFNNQjIwX1ZFUlNJT05fU1RSSU5HICAgICIy
LjAiCisjaWZkZWYgQ09ORklHX0NJRlNfQUxMT1dfSU5TRUNVUkVfTEVHQUNZCiBleHRlcm4gc3Ry
dWN0IHNtYl92ZXJzaW9uX29wZXJhdGlvbnMgc21iMV9vcGVyYXRpb25zOwogZXh0ZXJuIHN0cnVj
dCBzbWJfdmVyc2lvbl92YWx1ZXMgc21iMV92YWx1ZXM7Ci0jZGVmaW5lIFNNQjIwX1ZFUlNJT05f
U1RSSU5HCSIyLjAiCiBleHRlcm4gc3RydWN0IHNtYl92ZXJzaW9uX29wZXJhdGlvbnMgc21iMjBf
b3BlcmF0aW9uczsKIGV4dGVybiBzdHJ1Y3Qgc21iX3ZlcnNpb25fdmFsdWVzIHNtYjIwX3ZhbHVl
czsKKyNlbmRpZiAvKiBDSUZTX0FMTE9XX0lOU0VDVVJFX0xFR0FDWSAqLwogI2RlZmluZSBTTUIy
MV9WRVJTSU9OX1NUUklORwkiMi4xIgogZXh0ZXJuIHN0cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRp
b25zIHNtYjIxX29wZXJhdGlvbnM7CiBleHRlcm4gc3RydWN0IHNtYl92ZXJzaW9uX3ZhbHVlcyBz
bWIyMV92YWx1ZXM7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21i
Mm9wcy5jCmluZGV4IDAzYWIyOGMzNDFjNC4uOThhNzZmYTc5MWMwIDEwMDY0NAotLS0gYS9mcy9j
aWZzL3NtYjJvcHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtNDM0NSwxMSArNDM0NSwx
MyBAQCBzbWIzX3NldF9vcGxvY2tfbGV2ZWwoc3RydWN0IGNpZnNJbm9kZUluZm8gKmNpbm9kZSwg
X191MzIgb3Bsb2NrLAogCX0KIH0KIAorI2lmZGVmIENPTkZJR19DSUZTX0FMTE9XX0lOU0VDVVJF
X0xFR0FDWQogc3RhdGljIGJvb2wKIHNtYjJfaXNfcmVhZF9vcChfX3UzMiBvcGxvY2spCiB7CiAJ
cmV0dXJuIG9wbG9jayA9PSBTTUIyX09QTE9DS19MRVZFTF9JSTsKIH0KKyNlbmRpZiAvKiBDSUZT
X0FMTE9XX0lOU0VDVVJFX0xFR0FDWSAqLwogCiBzdGF0aWMgYm9vbAogc21iMjFfaXNfcmVhZF9v
cChfX3UzMiBvcGxvY2spCkBAIC01NDQ4LDcgKzU0NTAsNyBAQCBzbWIyX21ha2Vfbm9kZSh1bnNp
Z25lZCBpbnQgeGlkLCBzdHJ1Y3QgaW5vZGUgKmlub2RlLAogCXJldHVybiByYzsKIH0KIAotCisj
aWZkZWYgQ09ORklHX0NJRlNfQUxMT1dfSU5TRUNVUkVfTEVHQUNZCiBzdHJ1Y3Qgc21iX3ZlcnNp
b25fb3BlcmF0aW9ucyBzbWIyMF9vcGVyYXRpb25zID0gewogCS5jb21wYXJlX2ZpZHMgPSBzbWIy
X2NvbXBhcmVfZmlkcywKIAkuc2V0dXBfcmVxdWVzdCA9IHNtYjJfc2V0dXBfcmVxdWVzdCwKQEAg
LTU1NDcsNiArNTU0OSw3IEBAIHN0cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRpb25zIHNtYjIwX29w
ZXJhdGlvbnMgPSB7CiAJLmlzX3N0YXR1c19pb190aW1lb3V0ID0gc21iMl9pc19zdGF0dXNfaW9f
dGltZW91dCwKIAkuaXNfbmV0d29ya19uYW1lX2RlbGV0ZWQgPSBzbWIyX2lzX25ldHdvcmtfbmFt
ZV9kZWxldGVkLAogfTsKKyNlbmRpZiAvKiBDSUZTX0FMTE9XX0lOU0VDVVJFX0xFR0FDWSAqLwog
CiBzdHJ1Y3Qgc21iX3ZlcnNpb25fb3BlcmF0aW9ucyBzbWIyMV9vcGVyYXRpb25zID0gewogCS5j
b21wYXJlX2ZpZHMgPSBzbWIyX2NvbXBhcmVfZmlkcywKQEAgLTU4NzgsNiArNTg4MSw3IEBAIHN0
cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRpb25zIHNtYjMxMV9vcGVyYXRpb25zID0gewogCS5pc19u
ZXR3b3JrX25hbWVfZGVsZXRlZCA9IHNtYjJfaXNfbmV0d29ya19uYW1lX2RlbGV0ZWQsCiB9Owog
CisjaWZkZWYgQ09ORklHX0NJRlNfQUxMT1dfSU5TRUNVUkVfTEVHQUNZCiBzdHJ1Y3Qgc21iX3Zl
cnNpb25fdmFsdWVzIHNtYjIwX3ZhbHVlcyA9IHsKIAkudmVyc2lvbl9zdHJpbmcgPSBTTUIyMF9W
RVJTSU9OX1NUUklORywKIAkucHJvdG9jb2xfaWQgPSBTTUIyMF9QUk9UX0lELApAQCAtNTg5OCw2
ICs1OTAyLDcgQEAgc3RydWN0IHNtYl92ZXJzaW9uX3ZhbHVlcyBzbWIyMF92YWx1ZXMgPSB7CiAJ
LnNpZ25pbmdfcmVxdWlyZWQgPSBTTUIyX05FR09USUFURV9TSUdOSU5HX1JFUVVJUkVELAogCS5j
cmVhdGVfbGVhc2Vfc2l6ZSA9IHNpemVvZihzdHJ1Y3QgY3JlYXRlX2xlYXNlKSwKIH07CisjZW5k
aWYgLyogQUxMT1dfSU5TRUNVUkVfTEVHQUNZICovCiAKIHN0cnVjdCBzbWJfdmVyc2lvbl92YWx1
ZXMgc21iMjFfdmFsdWVzID0gewogCS52ZXJzaW9uX3N0cmluZyA9IFNNQjIxX1ZFUlNJT05fU1RS
SU5HLAotLSAKMi4zNC4xCgo=
--0000000000004fbd2805e06ed6e8--
