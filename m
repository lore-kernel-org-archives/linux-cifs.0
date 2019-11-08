Return-Path: <SRS0=ZZqS=ZA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 110E9C5DF60
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Nov 2019 07:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB4D62087E
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Nov 2019 07:07:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q15vU6bG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfKHHH7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:07:59 -0500
Received: from mail-il1-f174.google.com ([209.85.166.174]:38900 "EHLO
        mail-il1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfKHHH7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Nov 2019 02:07:59 -0500
Received: by mail-il1-f174.google.com with SMTP id e16so3307589ilc.5
        for <linux-cifs@vger.kernel.org>; Thu, 07 Nov 2019 23:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=spD8TI9bSodDtWJyqO/MjqWXHMFt1zBR8mlRjLhIOBI=;
        b=Q15vU6bGvexGq9IYK1G+kPaeBZIKrMZqdE8EPmTxmBWqaVkrO7fKZQRPbwZWoADeP0
         F00WEs2nXTUjG9uBVraktp0KKtmktM/4dzLklsheovRF9vkrMMIoh22dVayJvrD5UKpk
         9AD6QxvKipTkCKTUPN6xsd3K1FTI+zHe9Nl6j/41I1C3s64S7rsBC+BT9EYh4oce+Tda
         bxFod0tAP0HN+S95szsDcroFbMgCQV55YpJWnJ+XGVo2vovq29hUH6Pah9tXADQATZH/
         uF5PfiVB60jlZ3D2u4XrgD3LIFOpmu22StxRtS5Q8Tlrwf7MoTrMiF1xHeyvmAmHRFhu
         fn5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=spD8TI9bSodDtWJyqO/MjqWXHMFt1zBR8mlRjLhIOBI=;
        b=r53Vchdt912PZYpMiO6rnVa7fKXk08s3X3WLV4vbVpRssPhHHjZG6F186l9gEIqUk+
         ePhYNJ7XXs03ADilZYU0GRQHo3KbtDNkqy+WG8zcQrrEr+Y6bT1DwkX8q+LHMfW2UVxP
         MbwDxTsMifxQCnBxtbPhFcgmPp+yPpfAe4ZDGSbdU8SCn3b5ybPkPCteCPofIAsDaeUh
         A14bWx3aQ8sJ3CRIy6ezghBlIdrNP7bMDwek1nTjUgWK3C2yCfi69LQaVQxTOlcJbXjE
         AY03M/SshJv0p2ah4qWi8+EI2dLX0IQIbBk17xFCR73Hd4qVxiQb2CmK3x61fERpRCcn
         +fwQ==
X-Gm-Message-State: APjAAAVtx1ijGRMrUiFn/93xgmx6zBqiAXPyTBJKHTWptZtl4waJj//X
        UI14SvOoDeh/F+2GuvRyeanhr+GAdWPPYhCQ6gFgBidm
X-Google-Smtp-Source: APXvYqwMa952MFP7HiDwdz+LWTFcEUbT1ln5uB2DcDerVGugSYQw3PwnkXV0j/23/r7SAnifvcgusLSscebB+3N9QW0=
X-Received: by 2002:a92:381c:: with SMTP id f28mr10615577ila.169.1573196878165;
 Thu, 07 Nov 2019 23:07:58 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5muzbhS6=G+A9rPNerH+H2FLHFb=TgcMe28=2qgU-WvG4A@mail.gmail.com>
In-Reply-To: <CAH2r5muzbhS6=G+A9rPNerH+H2FLHFb=TgcMe28=2qgU-WvG4A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 8 Nov 2019 01:07:47 -0600
Message-ID: <CAH2r5mtZhTx2nX1aTrMfBXY=QZKars-P8MzsnxAA1-EARKZddg@mail.gmail.com>
Subject: Re: [PATCH][SMB3] remove confusing dmesg when mounting with encryption
To:     CIFS <linux-cifs@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000001645e00596d07110"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000001645e00596d07110
Content-Type: text/plain; charset="UTF-8"

Here is updated patch which following Pavel's suggestion simply
removes the sometimes confusing warning rather than make a more
complex change which checks for whether the packet was decrypted
earlier or not


On Tue, Nov 5, 2019 at 4:47 PM Steve French <smfrench@gmail.com> wrote:
>
> The smb2/smb3 message checking code was logging to dmesg when mounting
> with encryption ("seal") for compounded SMB3 requests.  When encrypted
> the whole frame (including potentially multiple compounds) is read
> so the length field is longer than in the case of non-encrypted
> case (where length field will match the the calculated length for
> the particular SMB3 request in the compound being validated).
>
> Avoids the warning on mount (with "seal"):
>
>    "srv rsp padded more than expected. Length 384 not ..."
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--0000000000001645e00596d07110
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-remove-confusing-dmesg-when-mounting-with-encry.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-remove-confusing-dmesg-when-mounting-with-encry.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k2psqm2q0>
X-Attachment-Id: f_k2psqm2q0

RnJvbSAwYWQ5MmVkOWJmOWNkOWU0YmM5NDEyZDNmNmU5Y2NiZmNjMjdmYjQzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgOCBOb3YgMjAxOSAwMTowMTozNSAtMDYwMApTdWJqZWN0OiBbUEFUQ0ggMS8y
XSBzbWIzOiByZW1vdmUgY29uZnVzaW5nIGRtZXNnIHdoZW4gbW91bnRpbmcgd2l0aAogZW5jcnlw
dGlvbiAoInNlYWwiKQoKVGhlIHNtYjIvc21iMyBtZXNzYWdlIGNoZWNraW5nIGNvZGUgd2FzIGxv
Z2dpbmcgdG8gZG1lc2cgd2hlbiBtb3VudGluZwp3aXRoIGVuY3J5cHRpb24gKCJzZWFsIikgZm9y
IGNvbXBvdW5kZWQgU01CMyByZXF1ZXN0cy4gIFdoZW4gZW5jcnlwdGVkCnRoZSB3aG9sZSBmcmFt
ZSAoaW5jbHVkaW5nIHBvdGVudGlhbGx5IG11bHRpcGxlIGNvbXBvdW5kcykgaXMgcmVhZApzbyB0
aGUgbGVuZ3RoIGZpZWxkIGlzIGxvbmdlciB0aGFuIGluIHRoZSBjYXNlIG9mIG5vbi1lbmNyeXB0
ZWQKY2FzZSAod2hlcmUgbGVuZ3RoIGZpZWxkIHdpbGwgbWF0Y2ggdGhlIHRoZSBjYWxjdWxhdGVk
IGxlbmd0aCBmb3IKdGhlIHBhcnRpY3VsYXIgU01CMyByZXF1ZXN0IGluIHRoZSBjb21wb3VuZCBi
ZWluZyB2YWxpZGF0ZWQpLgoKQXZvaWRzIHRoZSB3YXJuaW5nIG9uIG1vdW50ICh3aXRoICJzZWFs
Iik6CgogICAic3J2IHJzcCBwYWRkZWQgbW9yZSB0aGFuIGV4cGVjdGVkLiBMZW5ndGggMzg0IG5v
dCAuLi4iCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5j
b20+Ci0tLQogZnMvY2lmcy9zbWIybWlzYy5jIHwgMTAgKystLS0tLS0tLQogMSBmaWxlIGNoYW5n
ZWQsIDIgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZz
L3NtYjJtaXNjLmMgYi9mcy9jaWZzL3NtYjJtaXNjLmMKaW5kZXggNGI3ZmYzZDFlODMwLi5hNTI0
ZmMxZmFkODQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMm1pc2MuYworKysgYi9mcy9jaWZzL3Nt
YjJtaXNjLmMKQEAgLTI1MCwxNiArMjUwLDEwIEBAIHNtYjJfY2hlY2tfbWVzc2FnZShjaGFyICpi
dWYsIHVuc2lnbmVkIGludCBsZW4sIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNydnIpCiAJCSAq
IG9mIGp1bmsuIE90aGVyIHNlcnZlcnMgbWF0Y2ggUkZDMTAwMSBsZW4gdG8gYWN0dWFsCiAJCSAq
IFNNQjIvU01CMyBmcmFtZSBsZW5ndGggKGhlYWRlciArIHNtYjIgcmVzcG9uc2Ugc3BlY2lmaWMg
ZGF0YSkKIAkJICogU29tZSB3aW5kb3dzIHNlcnZlcnMgYWxzbyBwYWQgdXAgdG8gOCBieXRlcyB3
aGVuIGNvbXBvdW5kaW5nLgotCQkgKiBJZiBwYWQgaXMgbG9uZ2VyIHRoYW4gZWlnaHQgYnl0ZXMs
IGxvZyB0aGUgc2VydmVyIGJlaGF2aW9yCi0JCSAqIChvbmNlKSwgc2luY2UgbWF5IGluZGljYXRl
IGEgcHJvYmxlbSBidXQgYWxsb3cgaXQgYW5kIGNvbnRpbnVlCi0JCSAqIHNpbmNlIHRoZSBmcmFt
ZSBpcyBwYXJzZWFibGUuCiAJCSAqLwotCQlpZiAoY2xjX2xlbiA8IGxlbikgewotCQkJcHJfd2Fy
bl9vbmNlKAotCQkJICAgICAic3J2IHJzcCBwYWRkZWQgbW9yZSB0aGFuIGV4cGVjdGVkLiBMZW5n
dGggJWQgbm90ICVkIGZvciBjbWQ6JWQgbWlkOiVsbHVcbiIsCi0JCQkgICAgIGxlbiwgY2xjX2xl
biwgY29tbWFuZCwgbWlkKTsKKwkJaWYgKGNsY19sZW4gPCBsZW4pCiAJCQlyZXR1cm4gMDsKLQkJ
fQorCiAJCXByX3dhcm5fb25jZSgKIAkJCSJzcnYgcnNwIHRvbyBzaG9ydCwgbGVuICVkIG5vdCAl
ZC4gY21kOiVkIG1pZDolbGx1XG4iLAogCQkJbGVuLCBjbGNfbGVuLCBjb21tYW5kLCBtaWQpOwot
LSAKMi4yMy4wCgo=
--0000000000001645e00596d07110--
