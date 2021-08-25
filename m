Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8733EC432BE
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Aug 2021 20:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68D1D6108E
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Aug 2021 20:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbhHYUyi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Aug 2021 16:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbhHYUyi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 Aug 2021 16:54:38 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE6EC061757
        for <linux-cifs@vger.kernel.org>; Wed, 25 Aug 2021 13:53:51 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id bq28so1661103lfb.7
        for <linux-cifs@vger.kernel.org>; Wed, 25 Aug 2021 13:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C9//a+LSuIWJkkEL76kxV5/lkLm/niGmSfRELtsM7Ug=;
        b=fTX9lNNy9nklfnn3MsTand4oEIvDqYsL2MVuNouXPfNEtk4bIchclxBMq2AfdsJEqg
         5Q9KfvAOJKVrWXlGLQyY9Gen6UwcZO52tG059yHDGHIYTygDwXZ6FQRp+pkkNdBokz8b
         0Bnde/daOI1dvpSSt5n0zHqjeQgd+XvSENWa8ALY5SI4bxcVeDNxu89DcN3nxAMXYSej
         rGEJal52ezRzIzDAGBpMPpopjb6qYyJgYZfqDYnTIWRYYsi6jzMYljEW4ugaY3LPTeX1
         1rgE3CaW6SFZYlbF1+3eMFU4ujCkC2X46a5cNhbF4LZkjIwYDmcQqTCYrNZ52eiXM85P
         r0YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C9//a+LSuIWJkkEL76kxV5/lkLm/niGmSfRELtsM7Ug=;
        b=Kw5BF91iSCX/kpr7F6BTYRcyowTP2Ia3T7mJIvts0K6Si40CtFDNTFz2cEGu5w/0/z
         zZiDpa8FWaErlpthg6hzlQywCLK3oC9/W4jJbJJtoC6KMU2BhZxVh9Qp0wJlGKlg6N0k
         KSBlIBACvHbqQa9GGpVumHX2ur+hCs4XI4jOwRJvOTIcrwOhA/69uNr1fsF8IrSCUa9C
         YIKlR9Cla+x1NtQcirT1K03rfEyMVC7xu32YPQAEJFvVDGvzy806DjtbqKJ2XbJNVori
         X+TDQc9JdjGjVykCb4Nz38K1u71loBkA6t2aGnpvXKOGbzHOeOFmGokfl+yLKx6e6BeS
         0BRA==
X-Gm-Message-State: AOAM530cgQgood7RNiRUQROnvbDG/7YPro7Z3H2qyzx1oEgH3PcWgfQ0
        fgx8EES7e1K5a0fgqba5yHaZupBP49EDQrVehqgwzUJL
X-Google-Smtp-Source: ABdhPJzSuqHixgfZoxefLM2Mxx9TyxYrWqbKTziQDSXT0BVU6vjJmiv+6VwPFAk7l0SBrLcJQCVwqHPihpf+GIij20Q=
X-Received: by 2002:a05:6512:3ef:: with SMTP id n15mr58019lfq.184.1629924829953;
 Wed, 25 Aug 2021 13:53:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mu-QRnkdaB=nNVY2Q3Dhb5vgnk4n0XnMADMWkEGbtchFw@mail.gmail.com>
 <YSXgH2KobLW0JEjP@infradead.org>
In-Reply-To: <YSXgH2KobLW0JEjP@infradead.org>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 25 Aug 2021 15:53:38 -0500
Message-ID: <CAH2r5mvDcO8aHfw8Do4jS=DDpsCE6P+SNjCguKDMuusBeA898w@mail.gmail.com>
Subject: Re: [PATCH] cifs: cifs_md4 convert to SPDX identifier
To:     Christoph Hellwig <hch@infradead.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000080228b05ca6872d0"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000080228b05ca6872d0
Content-Type: text/plain; charset="UTF-8"

Removed the file name from the top of header comments as suggested.

On Wed, Aug 25, 2021 at 1:16 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Tue, Aug 24, 2021 at 12:15:05PM -0500, Steve French wrote:
> > - *   fs/smb2/smb2maperror.c
> > + *   fs/cifs/smb2maperror.c
>
>
> >  /*
> > + * fs/cifs_common/cifs_md4.c
> > + *
>
> This is a good reminder on why putting the file name into the top of
> file comment is stupid.  Just don't do it.
>


-- 
Thanks,

Steve

--00000000000080228b05ca6872d0
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-cifs_md4-convert-to-SPDX-identifier.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-cifs_md4-convert-to-SPDX-identifier.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ksrz4u3f0>
X-Attachment-Id: f_ksrz4u3f0

RnJvbSAzOGY0OTEwYjhiMjZkM2E5NDAxNjdmMjA3YmRkZmNjNTg5MzEwYzhhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjQgQXVnIDIwMjEgMTI6MDc6NDYgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBjaWZzX21kNCBjb252ZXJ0IHRvIFNQRFggaWRlbnRpZmllcgoKQWRkIFNQRFggbGljZW5z
ZSBpZGVudGlmaWVyIGFuZCByZXBsYWNlIGxpY2Vuc2UgYm9pbGVycGxhdGUKZm9yIGNpZnNfbWQ0
LmMKClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4K
LS0tCiBmcy9jaWZzL3NtYjJtYXBlcnJvci5jICAgIHwgMSAtCiBmcy9jaWZzX2NvbW1vbi9jaWZz
X21kNC5jIHwgNiArLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDYgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIybWFwZXJyb3IuYyBiL2ZzL2NpZnMv
c21iMm1hcGVycm9yLmMKaW5kZXggY2VhMzliY2VjYmFiLi4xODE1MTRiODc3MGQgMTAwNjQ0Ci0t
LSBhL2ZzL2NpZnMvc21iMm1hcGVycm9yLmMKKysrIGIvZnMvY2lmcy9zbWIybWFwZXJyb3IuYwpA
QCAtMSw2ICsxLDUgQEAKIC8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBMR1BMLTIuMQogLyoK
LSAqICAgZnMvc21iMi9zbWIybWFwZXJyb3IuYwogICoKICAqICAgRnVuY3Rpb25zIHdoaWNoIGRv
IGVycm9yIG1hcHBpbmcgb2YgU01CMiBzdGF0dXMgY29kZXMgdG8gUE9TSVggZXJyb3JzCiAgKgpk
aWZmIC0tZ2l0IGEvZnMvY2lmc19jb21tb24vY2lmc19tZDQuYyBiL2ZzL2NpZnNfY29tbW9uL2Np
ZnNfbWQ0LmMKaW5kZXggZGJmOTExM2I4NjAwLi41MGY3OGNmYzZjZTkgMTAwNjQ0Ci0tLSBhL2Zz
L2NpZnNfY29tbW9uL2NpZnNfbWQ0LmMKKysrIGIvZnMvY2lmc19jb21tb24vY2lmc19tZDQuYwpA
QCAtMSwzICsxLDQgQEAKKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wCiAvKgog
ICogQ3J5cHRvZ3JhcGhpYyBBUEkuCiAgKgpAQCAtMTQsMTEgKzE1LDYgQEAKICAqIENvcHlyaWdo
dCAoYykgMjAwMiBEYXZpZCBTLiBNaWxsZXIgKGRhdmVtQHJlZGhhdC5jb20pCiAgKiBDb3B5cmln
aHQgKGMpIDIwMDIgSmFtZXMgTW9ycmlzIDxqbW9ycmlzQGludGVyY29kZS5jb20uYXU+CiAgKgot
ICogVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0
IGFuZC9vciBtb2RpZnkKLSAqIGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwg
UHVibGljIExpY2Vuc2UgYXMgcHVibGlzaGVkIGJ5Ci0gKiB0aGUgRnJlZSBTb2Z0d2FyZSBGb3Vu
ZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9mIHRoZSBMaWNlbnNlLCBvcgotICogKGF0IHlvdXIg
b3B0aW9uKSBhbnkgbGF0ZXIgdmVyc2lvbi4KLSAqCiAgKi8KICNpbmNsdWRlIDxsaW51eC9pbml0
Lmg+CiAjaW5jbHVkZSA8bGludXgva2VybmVsLmg+Ci0tIAoyLjMwLjIKCg==
--00000000000080228b05ca6872d0--
