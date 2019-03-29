Return-Path: <SRS0=xN7r=SA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 966B6C10F05
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Mar 2019 18:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 611C52184D
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Mar 2019 18:44:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SzhZxDDv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730049AbfC2Sov (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 Mar 2019 14:44:51 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43791 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729840AbfC2Sov (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 29 Mar 2019 14:44:51 -0400
Received: by mail-pl1-f195.google.com with SMTP id m10so1421680plt.10;
        Fri, 29 Mar 2019 11:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fT+1oDk1L4yB7bo6xrGyyD45JpUX3jBf5ZuKDzlFL18=;
        b=SzhZxDDv0OzYOc85vA+FbpQfGPrXhfjOIoEIYUw6H18OR9aj5pjmGqtZ9CKRMdWTJz
         I+m0ObdqCussVT4riM9J49FmVCAzAZQb1iXJ3QJoXbA9QYBTyYn+Az0gM2VWeT8puMGt
         DVKHID3UVVNnPVqlBJQUQYVNh/p3rT0KelnaMhRyRYMsKVzfdDhfOtTLNl7q7C7xq3wu
         fEBxItvoZZ+3cunZ6Z86xO+4mEsNsqhaycIkmg6CY3OWk0s1juKCOSNmkIRdEPNHFcWH
         aKqf62DHm5pYOnF+qw9RbqpZjekhp4DKKX4sBQfTLjz8QTKSqCuWzEgrp574VJTX17he
         CUlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fT+1oDk1L4yB7bo6xrGyyD45JpUX3jBf5ZuKDzlFL18=;
        b=Gq+rS+xcsC7djcg6JqYZL2cg1D+O/K3c7TIYeU9wX5V4pPWRM3jtABDme8/UJyIaSo
         sbecAXLgj+7Um407R2qiLd/z/2NVZji+8PDayuIw/kZZzUfvjqHZrmIOXgr7Y7oVufzP
         jHSwgljfWhvZxPqtERjJ1e5mvNFClHoLwaXLf1MGwMvumGdsY30P5nt74RHC7irk8ilQ
         VpUnnZOym52J2vXPBV6USuYPoCC5o2utfhl3ubp6ejMl7Pe/5f3Fl/9HN35l+3r7KaK/
         lkIHD9EOeE8FI2LdRFa4WUP5hZ59gBLC0F2WmY9ukDJsscl1Lz1PbcC632CRZF5pU7Au
         pW/g==
X-Gm-Message-State: APjAAAUt7ZFeh52Po3kIdbgBqboB3kCHZJhMv5xwiDJ/dv93C+RoiEdP
        vXyfqclgL9rlvtDtl9oIbpFPphPsDZq9vK/hDBmcbA==
X-Google-Smtp-Source: APXvYqx2JkMyGVOYmnHLMmwPCyXPfJ5acnmLmz/fCpu5T7MaoCTdKOusMzskZv/BBPkq2XhqAzhW6q6I6fD/oDX91ms=
X-Received: by 2002:a17:902:2b8b:: with SMTP id l11mr51715889plb.18.1553885090182;
 Fri, 29 Mar 2019 11:44:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvQ+KmoBgoxT51SRMpCXZ4OFwg+B1x_SD3DFkcrUcdZQQ@mail.gmail.com>
 <20190328170219.29c72cbf@echidna.suse.de> <CAH2r5mvb=SbYV9Qmt=n_ht7toPgKs03Y2oHXpJE7=_byptstKg@mail.gmail.com>
In-Reply-To: <CAH2r5mvb=SbYV9Qmt=n_ht7toPgKs03Y2oHXpJE7=_byptstKg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 29 Mar 2019 13:44:38 -0500
Message-ID: <CAH2r5mvyt0rjrtzvZOMeJvHF7FK3LM_pyr7pv2PxzH1n9CxZaQ@mail.gmail.com>
Subject: Re: [PATCH][smbinfo cifsutils]
To:     David Disseldorp <ddiss@suse.de>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000d2ac6a058540106a"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000d2ac6a058540106a
Content-Type: text/plain; charset="UTF-8"

Added man page update for this new smbinfo parm


On Fri, Mar 29, 2019 at 3:14 AM Steve French <smfrench@gmail.com> wrote:
>
> As requested I changed the buffer size malloced to be more obvious -
> in this case to match exactly what is returned from the first call (ie
> snapshot length + the sizeof the snapshot info structure which
> precedes the snapshot list, ie 16 bytes).  The snapshot array size is
> 12 bytes, but rounding it to 8 byte boundary causes the minimum to be
> 16 bytes.
>
> On Thu, Mar 28, 2019 at 11:02 AM David Disseldorp <ddiss@suse.de> wrote:
> >
> > On Thu, 28 Mar 2019 05:05:35 -0500, Steve French wrote:
> >
> > > +     /* Now that we know the size, query the list from the server */
> > > +
> > > +     /* Make sure the buf size is big enough even to handle unexpected server behavior */
> > > +     buf = malloc(snap_inf.snapshot_array_size + 300);
> >
> > The buffer length calculations seem pretty arbitrary here, wouldn't it
> > make sense to use something like the following (with a maximum limit)?
> > sizeof(struct smb_snapshot_array) +
> >         (snap_inf.number_of_snapshots * GMT_TOKEN_LEN)
> >
> > Cheers, David
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--000000000000d2ac6a058540106a
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smbinfo-Add-ability-to-query-snapshots-previous-vers.patch"
Content-Disposition: attachment; 
	filename="0001-smbinfo-Add-ability-to-query-snapshots-previous-vers.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jtuf1yug0>
X-Attachment-Id: f_jtuf1yug0

RnJvbSA0NmU5NTE3MTA1YTdjOWNiYjc0NGJlYTBlNzFmYjM1Yzc4MWEwYTYyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMjkgTWFyIDIwMTkgMDM6MDU6NTUgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWJpbmZvOiBBZGQgYWJpbGl0eSB0byBxdWVyeSBzbmFwc2hvdHMgKHByZXZpb3VzIHZlcnNpb25z
KQoKICJzbWJpbmZvIGxpc3Qtc25hcHNob3RzIgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNo
IDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgpSZXZpZXdlZC1ieTogUm9ubmllIFNhaGxiZXJnIDxs
c2FobGJlckByZWRoYXQuY29tPgotLS0KIHNtYmluZm8uYyAgIHwgODcgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIHNtYmluZm8ucnN0IHwgIDIg
KysKIDIgZmlsZXMgY2hhbmdlZCwgODkgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL3NtYmlu
Zm8uYyBiL3NtYmluZm8uYwppbmRleCAzM2ZjYTk1Li43Y2ZmYjg0IDEwMDY0NAotLS0gYS9zbWJp
bmZvLmMKKysrIGIvc21iaW5mby5jCkBAIC04OSw2ICs4OSw4IEBAIHVzYWdlKGNoYXIgKm5hbWUp
CiAJCSIgICAgICBQcmludHMgdGhlIHNlY3VyaXR5IGRlc2NyaXB0b3IgZm9yIGEgY2lmcyBmaWxl
LlxuIgogCQkiICBxdW90YTpcbiIKIAkJIiAgICAgIFByaW50cyB0aGUgcXVvdGEgZm9yIGEgY2lm
cyBmaWxlLlxuIgorCQkiICBsaXN0LXNuYXBzaG90czpcbiIKKwkJIiAgICAgIExpc3QgdGhlIHBy
ZXZpb3VzIHZlcnNpb25zIG9mIHRoZSB2b2x1bWUgdGhhdCBiYWNrcyB0aGlzIGZpbGUuXG4iCiAJ
CSIgIGZzY3RsLWdldG9iamlkOlxuIgogCQkiICAgICAgUHJpbnRzIHRoZSBvYmplY3RpZCBvZiB0
aGUgZmlsZSBhbmQgR1VJRCBvZiB0aGUgdW5kZXJseWluZyB2b2x1bWUuXG4iLAogCQluYW1lKTsK
QEAgLTk2Niw2ICs5NjgsODkgQEAgcXVvdGEoaW50IGYpCiAJZnJlZShxaSk7CiB9CiAKKworc3Ry
dWN0IHNtYl9zbmFwc2hvdF9hcnJheSB7CisJaW50MzJfdAludW1iZXJfb2Zfc25hcHNob3RzOwor
CWludDMyX3QJbnVtYmVyX29mX3NuYXBzaG90c19yZXR1cm5lZDsKKwlpbnQzMl90CXNuYXBzaG90
X2FycmF5X3NpemU7CisJY2hhciBzbmFwc2hvdF9kYXRhWzBdOworfTsKKworCitzdGF0aWMgdm9p
ZCBwcmludF9zbmFwc2hvdHMoc3RydWN0IHNtYl9zbmFwc2hvdF9hcnJheSAqcHNuYXApCit7CisJ
aW50IGN1cnJlbnRfc25hcHNob3RfZW50cnkgPSAwOworCisJcHJpbnRmKCJOdW1iZXIgb2Ygc25h
cHNob3RzOiAlZCBOdW1iZXIgb2Ygc25hcHNob3RzIHJldHVybmVkOiAlZFxuIiwKKwkJcHNuYXAt
Pm51bWJlcl9vZl9zbmFwc2hvdHMsCisJCXBzbmFwLT5udW1iZXJfb2Zfc25hcHNob3RzX3JldHVy
bmVkKTsKKwlwcmludGYoIlNuYXBzaG90IGxpc3Q6Iik7CisKKwlmb3IgKGludCBpID0gMDsgaSA8
IHBzbmFwLT5zbmFwc2hvdF9hcnJheV9zaXplOyBpKyspIHsKKwkJaWYgKHBzbmFwLT5zbmFwc2hv
dF9kYXRhW2ldID09ICdAJykgeworCQkJY3VycmVudF9zbmFwc2hvdF9lbnRyeSsrOworCQkJcHJp
bnRmKCJcbiVkKSAiLCBjdXJyZW50X3NuYXBzaG90X2VudHJ5KTsKKwkJfQorCQlwcmludGYoIiVj
IiwgcHNuYXAtPnNuYXBzaG90X2RhdGFbaV0pOworCX0KKwlwcmludGYoIlxuIik7Cit9CisKKyNk
ZWZpbmUgQ0lGU19FTlVNRVJBVEVfU05BUFNIT1RTIF9JT1IoQ0lGU19JT0NUTF9NQUdJQywgNiwg
c3RydWN0IHNtYl9zbmFwc2hvdF9hcnJheSkKKworI2RlZmluZSBNSU5fU05BUFNIT1RfQVJSQVlf
U0laRSAxNiAvKiBTZWUgTVMtU01CMiBzZWN0aW9uIDMuMy41LjE1LjEgKi8KKworc3RhdGljIHZv
aWQKK2xpc3Rfc25hcHNob3RzKGludCBmKQoreworCisJc3RydWN0IHNtYl9zbmFwc2hvdF9hcnJh
eSBzbmFwX2luZjsKKwlzdHJ1Y3Qgc21iX3NuYXBzaG90X2FycmF5ICpidWY7CisKKwkvKgorCSAq
IFdoZW4gZmlyc3QgZmllbGQgaW4gc3RydWN0dXJlIHdlIHBhc3MgaW4gaGVyZSBpcyB6ZXJvLCBj
aWZzLmtvIGNhbgorCSAqIHJlY29nbml6ZSB0aGF0IHRoaXMgaXMgdGhlIGZpcnN0IHF1ZXJ5IGFu
ZCB0aGF0IGl0IG11c3Qgc2V0IHRoZSBTTUIzCisJICogRlNDVEwgcmVzcG9uc2UgYnVmZmVyIHNp
emUgKGluIHRoZSByZXF1ZXN0KSB0byBleGFjdGx5IDE2IGJ5dGVzCisJICogKHdoaWNoIGlzIHJl
cXVpcmVkIGJ5IHNvbWUgc2VydmVycyB0byBwcm9jZXNzIHRoZSBpbml0aWFsIHF1ZXJ5KQorCSAq
LworCXNuYXBfaW5mLm51bWJlcl9vZl9zbmFwc2hvdHMgPSAwOworCXNuYXBfaW5mLm51bWJlcl9v
Zl9zbmFwc2hvdHNfcmV0dXJuZWQgPSAwOworCXNuYXBfaW5mLnNuYXBzaG90X2FycmF5X3NpemUg
PSBzaXplb2Yoc3RydWN0IHNtYl9zbmFwc2hvdF9hcnJheSk7CisKKwkvKiBRdWVyeSB0aGUgbnVt
YmVyIG9mIHNuYXBzaG90cyBzbyB3ZSBrbm93IGhvdyBtdWNoIHRvIGFsbG9jYXRlICovCisJaWYg
KGlvY3RsKGYsIENJRlNfRU5VTUVSQVRFX1NOQVBTSE9UUywgJnNuYXBfaW5mKSA8IDApIHsKKwkJ
ZnByaW50ZihzdGRlcnIsICJRdWVyeWluZyBzbmFwc2hvdHMgZmFpbGVkIHdpdGggJXNcbiIsIHN0
cmVycm9yKGVycm5vKSk7CisJCWV4aXQoMSk7CisJfQorCisJaWYgKHNuYXBfaW5mLm51bWJlcl9v
Zl9zbmFwc2hvdHMgPT0gMCkKKwkJcmV0dXJuOworCisJLyogTm93IHRoYXQgd2Uga25vdyB0aGUg
c2l6ZSwgcXVlcnkgdGhlIGxpc3QgZnJvbSB0aGUgc2VydmVyICovCisKKwlidWYgPSBtYWxsb2Mo
c25hcF9pbmYuc25hcHNob3RfYXJyYXlfc2l6ZSArIE1JTl9TTkFQU0hPVF9BUlJBWV9TSVpFKTsK
KworCWlmIChidWYgPT0gTlVMTCkgeworCQlwcmludGYoIkZhaWxlZCwgb3V0IG9mIG1lbW9yeS5c
biIpOworCQlleGl0KDEpOworCX0KKwkvKgorCSAqIGZpcnN0IHBhcm0gaXMgbm9uLXplcm8gd2hp
Y2ggYWxsb3dzIGNpZnMua28gdG8gcmVjb2duaXplIHRoYXQgdGhpcyBpcworCSAqIHRoZSBzZWNv
bmQgcXVlcnkgKGl0IGhhcyB0byBzZXQgcmVzcG9uc2UgYnVmIHNpemUgbGFyZ2VyKQorCSAqLwor
CWJ1Zi0+bnVtYmVyX29mX3NuYXBzaG90cyA9IHNuYXBfaW5mLm51bWJlcl9vZl9zbmFwc2hvdHM7
CisKKwlidWYtPnNuYXBzaG90X2FycmF5X3NpemUgPSBzbmFwX2luZi5zbmFwc2hvdF9hcnJheV9z
aXplOworCisJaWYgKGlvY3RsKGYsIENJRlNfRU5VTUVSQVRFX1NOQVBTSE9UUywgYnVmKSA8IDAp
IHsKKwkJZnByaW50ZihzdGRlcnIsICJRdWVyeWluZyBzbmFwc2hvdHMgZmFpbGVkIHdpdGggJXNc
biIsIHN0cmVycm9yKGVycm5vKSk7CisJCWV4aXQoMSk7CisJfQorCisJcHJpbnRfc25hcHNob3Rz
KGJ1Zik7CisJZnJlZShidWYpOworfQorCiBpbnQgbWFpbihpbnQgYXJnYywgY2hhciAqYXJndltd
KQogewogCWludCBjOwpAQCAtMTAxNiw2ICsxMTAxLDggQEAgaW50IG1haW4oaW50IGFyZ2MsIGNo
YXIgKmFyZ3ZbXSkKIAkJc2VjZGVzYyhmKTsKIAllbHNlIGlmICghc3RyY21wKGFyZ3Zbb3B0aW5k
XSwgInF1b3RhIikpCiAJCXF1b3RhKGYpOworCWVsc2UgaWYgKCFzdHJjbXAoYXJndltvcHRpbmRd
LCAibGlzdC1zbmFwc2hvdHMiKSkKKwkJbGlzdF9zbmFwc2hvdHMoZik7CiAJZWxzZSBpZiAoIXN0
cmNtcChhcmd2WzFdLCAiZnNjdGwtZ2V0b2JqaWQiKSkKIAkJZnNjdGxnZXRvYmppZChmKTsKIAll
bHNlIHsKZGlmZiAtLWdpdCBhL3NtYmluZm8ucnN0IGIvc21iaW5mby5yc3QKaW5kZXggZmQ3ZjBm
Zi4uMGM5NjA1MCAxMDA2NDQKLS0tIGEvc21iaW5mby5yc3QKKysrIGIvc21iaW5mby5yc3QKQEAg
LTY0LDYgKzY0LDggQEAgQ09NTUFORAogCiBgZnNjdGwtZ2V0b2JqaWRgOiBQcmludHMgdGhlIE9i
amVjdElECiAKK2BsaXN0LXNuYXBzaG90c2A6IExpc3RzIHRoZSBwcmV2aW91cyB2ZXJzaW9ucyBv
ZiB0aGUgdm9sdW1lIHRoYXQgYmFja3MgdGhpcyBmaWxlCisKIGBxdW90YWA6IFByaW50IHRoZSBx
dW90YSBmb3IgdGhlIHZvbHVtZSBpbiB0aGUgZm9ybQogLSBTSUQgTGVuZ3RoCiAtIENoYW5nZSBU
aW1lCi0tIAoyLjE3LjEKCg==
--000000000000d2ac6a058540106a--
