Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF6FC6FA83
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Sep 2022 21:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiILVLv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 12 Sep 2022 17:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiILVLk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 12 Sep 2022 17:11:40 -0400
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA764A138
        for <linux-cifs@vger.kernel.org>; Mon, 12 Sep 2022 14:11:38 -0700 (PDT)
Received: by mail-vk1-xa2f.google.com with SMTP id 134so4856616vkz.11
        for <linux-cifs@vger.kernel.org>; Mon, 12 Sep 2022 14:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=OCzUBFDjZ9LDdzFT/vq01ardY8WFuVe7fdACs/gZjGI=;
        b=SQPxz6cF2tHwTiY2mY+R5z2Dcrlakc8plLsk1G3xMr/FSLXpt3qDSTVHHUaHZ2wBjf
         sHSx4GNqFgyDv6e1qJNvpNSWB1ukpvXWJB6iidQ9D0wMTq0zopkmIMbcX0Xzs7w/p2zH
         tM5Ne+aCy5rRwtUoGyEBhBqLkyFVSc4cvMc5tOFN/3KLeKBp8mB4XcbdgBot0975fO5f
         WVwQRcGWcWzRJD7WFHZ7sOuycNe75VlETVG8/mx9+KICaTAH3d6fGZ1u2V3pIzu0s6R9
         4LKu5BMOPxGZUff9fBmBYYsEyYcrlT23ZLZrKlVi+Pox0PB4zZlXi0M3qGL8TCk4xwck
         zQLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=OCzUBFDjZ9LDdzFT/vq01ardY8WFuVe7fdACs/gZjGI=;
        b=nIi8omsFFlPWiwfAWO4FC5oe3OA0d59Rb+RTuWz3PoenYJOZ+hC0tC2PX9/DvjY3Xp
         2Injyh/s4RaWUwQH+jG7ktn0iufT5btfCFAP7GiBzdggpTfMOFbF8x2o71pc1iBMIBpR
         rI2C8AofTSwWIVvbKLIhPKgmnTfiCB58L2LI/toMY7mtFnBO1cmTAUpGDdJzWuJvs4/k
         wcFCJSIotmrcVmigqQd8+Arhk0f8OWLCCXFR5C4s1qkxl04HgZDMzemPw75d3gEfTTlS
         FoLovA4pYNtxCNSr0W/ctiRHY8REP5W1BeT41GswcPkKKIGo98S0+Tx8pbfhD1Lua+nT
         b+Jw==
X-Gm-Message-State: ACgBeo2JI3zeIFvzf12KqgZu4a2q+hFNSDP7Gbd0MjutKdhs9ttACMrX
        v/YXEJCwnOj4gA1km+QBgrIui4+5XT/z0qAbMAw=
X-Google-Smtp-Source: AA6agR6IwwLmZBsGzfz65V1vWx8xt64MdJAMQX2IV+CShMb1M3QbAqvRy58sAYR6RLD/dBseJ74t/luJgzzrB87eGxc=
X-Received: by 2002:a1f:918d:0:b0:3a1:e376:7463 with SMTP id
 t135-20020a1f918d000000b003a1e3767463mr6048642vkd.38.1663017097634; Mon, 12
 Sep 2022 14:11:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvC5sqwuLyLt=3PXYvPegOm-8rqSMYcCpjM3+T64fv2sg@mail.gmail.com>
 <f19d2bf6-6b05-f782-fcfa-1c09c867dcb2@samba.org>
In-Reply-To: <f19d2bf6-6b05-f782-fcfa-1c09c867dcb2@samba.org>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 12 Sep 2022 16:11:25 -0500
Message-ID: <CAH2r5mucwiYKjVSOCggeNJCTor2krV7UneZaVuDvF7wB2WhZ4g@mail.gmail.com>
Subject: Re: [PATCH][SMB3.1.1 client] fallback to query fs all info if posix
 query fs not supported
To:     Stefan Metzmacher <metze@samba.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000005ca3b005e88157ad"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000005ca3b005e88157ad
Content-Type: text/plain; charset="UTF-8"

updated the patch to remove the fall back - and simply do the
compounding for this code path (when statfs is posix query fs info) as
we already do for the non-POSIX statfs code path.

On Mon, Sep 12, 2022 at 12:51 AM Stefan Metzmacher <metze@samba.org> wrote:
>
> Am 12.09.22 um 07:36 schrieb Steve French via samba-technical:
> > A version of Samba that I was testing, supported POSIX extensions, but
> > not the query fs info
> > level.  Fall back to query fs all info if POSIX query fs info not
> > supported.
> >
> > Also fixes the problem that compounding wasn't being used for posix
> > qfs info in this path (statfs) but was being used in others, so
> > improves performance of posix query fs info.
>
> I don't think having hacks to work with work in progress branches should be
> added, instead the server should be fixed.
>
> metze
>


-- 
Thanks,

Steve

--0000000000005ca3b005e88157ad
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb311-compound-SMB311-posix-query-fs-info-for-statf.patch"
Content-Disposition: attachment; 
	filename="0001-smb311-compound-SMB311-posix-query-fs-info-for-statf.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l7z9filz0>
X-Attachment-Id: f_l7z9filz0

RnJvbSA0YzUzM2E4MjAwY2EyODg5MTE3YTYwNDU5OTcwMTlmMGVhM2UzZDE5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgMTEgU2VwIDIwMjIgMTk6NDk6MDQgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzMTE6IGNvbXBvdW5kIFNNQjMxMSBwb3NpeCBxdWVyeSBmcyBpbmZvIGZvciBzdGF0ZnMKCkZp
eGVzIHRoZSBwcm9ibGVtIHRoYXQgY29tcG91bmRpbmcgd2Fzbid0IGJlaW5nIHVzZWQgZm9yIHBv
c2l4CnFmcyBpbmZvIGluIHRoaXMgcGF0aCAoc3RhdGZzKSBidXQgd2FzIGJlaW5nIHVzZWQgaW4g
b3RoZXJzLCBzbwppbXByb3ZlcyBwZXJmb3JtYW5jZSBvZiBwb3NpeCBxdWVyeSBmcyBpbmZvLgoK
U2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0K
IGZzL2NpZnMvc21iMm9wcy5jICAgfCA0MCArKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0t
LS0tLS0tLS0tCiBmcy9jaWZzL3NtYjJwZHUuYyAgIHwgIDIgKy0KIGZzL2NpZnMvc21iMnByb3Rv
LmggfCAgMiArKwogMyBmaWxlcyBjaGFuZ2VkLCAyNiBpbnNlcnRpb25zKCspLCAxOCBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21iMm9wcy5j
CmluZGV4IDQyMWJlNDNhZjQyNS4uZDZkZDgzOWNhMWJiIDEwMDY0NAotLS0gYS9mcy9jaWZzL3Nt
YjJvcHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtMjU1NywzMSArMjU1NywzNyBAQCBz
dGF0aWMgaW50CiBzbWIzMTFfcXVlcnlmcyhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3Qg
Y2lmc190Y29uICp0Y29uLAogCSAgICAgICBzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiLCBz
dHJ1Y3Qga3N0YXRmcyAqYnVmKQogeworCXN0cnVjdCBzbWIyX3F1ZXJ5X2luZm9fcnNwICpyc3A7
CisJc3RydWN0IGt2ZWMgcnNwX2lvdiA9IHtOVUxMLCAwfTsKKwlGSUxFX1NZU1RFTV9QT1NJWF9J
TkZPICppbmZvID0gTlVMTDsKKwlpbnQgYnVmdHlwZSA9IENJRlNfTk9fQlVGRkVSOwogCWludCBy
YzsKLQlfX2xlMTYgc3JjaF9wYXRoID0gMDsgLyogTnVsbCAtIG9wZW4gcm9vdCBvZiBzaGFyZSAq
LwotCXU4IG9wbG9jayA9IFNNQjJfT1BMT0NLX0xFVkVMX05PTkU7Ci0Jc3RydWN0IGNpZnNfb3Bl
bl9wYXJtcyBvcGFybXM7Ci0Jc3RydWN0IGNpZnNfZmlkIGZpZDsKIAogCWlmICghdGNvbi0+cG9z
aXhfZXh0ZW5zaW9ucykKIAkJcmV0dXJuIHNtYjJfcXVlcnlmcyh4aWQsIHRjb24sIGNpZnNfc2Is
IGJ1Zik7CiAKLQlvcGFybXMudGNvbiA9IHRjb247Ci0Jb3Bhcm1zLmRlc2lyZWRfYWNjZXNzID0g
RklMRV9SRUFEX0FUVFJJQlVURVM7Ci0Jb3Bhcm1zLmRpc3Bvc2l0aW9uID0gRklMRV9PUEVOOwot
CW9wYXJtcy5jcmVhdGVfb3B0aW9ucyA9IGNpZnNfY3JlYXRlX29wdGlvbnMoY2lmc19zYiwgMCk7
Ci0Jb3Bhcm1zLmZpZCA9ICZmaWQ7Ci0Jb3Bhcm1zLnJlY29ubmVjdCA9IGZhbHNlOwotCi0JcmMg
PSBTTUIyX29wZW4oeGlkLCAmb3Bhcm1zLCAmc3JjaF9wYXRoLCAmb3Bsb2NrLCBOVUxMLCBOVUxM
LAotCQkgICAgICAgTlVMTCwgTlVMTCk7CisJcmMgPSBzbWIyX3F1ZXJ5X2luZm9fY29tcG91bmQo
eGlkLCB0Y29uLCAiIiwKKwkJCQkgICAgICBGSUxFX1JFQURfQVRUUklCVVRFUywKKwkJCQkgICAg
ICBGU19QT1NJWF9JTkZPUk1BVElPTiwKKwkJCQkgICAgICBTTUIyX09fSU5GT19GSUxFU1lTVEVN
LAorCQkJCSAgICAgIHNpemVvZihGSUxFX1NZU1RFTV9QT1NJWF9JTkZPKSwKKwkJCQkgICAgICAm
cnNwX2lvdiwgJmJ1ZnR5cGUsIGNpZnNfc2IpOwogCWlmIChyYykKLQkJcmV0dXJuIHJjOworCQln
b3RvIHBxZnNfZXhpdDsKIAotCXJjID0gU01CMzExX3Bvc2l4X3Fmc19pbmZvKHhpZCwgdGNvbiwg
ZmlkLnBlcnNpc3RlbnRfZmlkLAotCQkJCSAgIGZpZC52b2xhdGlsZV9maWQsIGJ1Zik7CisJcnNw
ID0gKHN0cnVjdCBzbWIyX3F1ZXJ5X2luZm9fcnNwICopcnNwX2lvdi5pb3ZfYmFzZTsKIAlidWYt
PmZfdHlwZSA9IFNNQjJfU1VQRVJfTUFHSUM7Ci0JU01CMl9jbG9zZSh4aWQsIHRjb24sIGZpZC5w
ZXJzaXN0ZW50X2ZpZCwgZmlkLnZvbGF0aWxlX2ZpZCk7CisJaW5mbyA9IChGSUxFX1NZU1RFTV9Q
T1NJWF9JTkZPICopKAorCQlsZTE2X3RvX2NwdShyc3AtPk91dHB1dEJ1ZmZlck9mZnNldCkgKyAo
Y2hhciAqKXJzcCk7CisJcmMgPSBzbWIyX3ZhbGlkYXRlX2lvdihsZTE2X3RvX2NwdShyc3AtPk91
dHB1dEJ1ZmZlck9mZnNldCksCisJCQkgICAgICAgbGUzMl90b19jcHUocnNwLT5PdXRwdXRCdWZm
ZXJMZW5ndGgpLAorCQkJICAgICAgICZyc3BfaW92LAorCQkJICAgICAgIHNpemVvZihGSUxFX1NZ
U1RFTV9QT1NJWF9JTkZPKSk7CisJaWYgKCFyYykKKwkJY29weV9wb3NpeF9mc19pbmZvX3RvX2tz
dGF0ZnMoaW5mbywgYnVmKTsKKworcHFmc19leGl0OgorCWZyZWVfcnNwX2J1ZihidWZ0eXBlLCBy
c3BfaW92Lmlvdl9iYXNlKTsKIAlyZXR1cm4gcmM7CiB9CiAKZGlmZiAtLWdpdCBhL2ZzL2NpZnMv
c21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXggNjM1MmFiMzJjN2U3Li4wMWYwY2Mx
NjIwYmQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5jCisrKyBiL2ZzL2NpZnMvc21iMnBk
dS5jCkBAIC01MjUxLDcgKzUyNTEsNyBAQCBzbWIyX2NvcHlfZnNfaW5mb190b19rc3RhdGZzKHN0
cnVjdCBzbWIyX2ZzX2Z1bGxfc2l6ZV9pbmZvICpwZnNfaW5mLAogCXJldHVybjsKIH0KIAotc3Rh
dGljIHZvaWQKK3ZvaWQKIGNvcHlfcG9zaXhfZnNfaW5mb190b19rc3RhdGZzKEZJTEVfU1lTVEVN
X1BPU0lYX0lORk8gKnJlc3BvbnNlX2RhdGEsCiAJCQlzdHJ1Y3Qga3N0YXRmcyAqa3N0KQogewpk
aWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycHJvdG8uaCBiL2ZzL2NpZnMvc21iMnByb3RvLmgKaW5k
ZXggM2Y3NDBmMjRiOTZhLi5jOTZjNmNhZDkwYTQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBy
b3RvLmgKKysrIGIvZnMvY2lmcy9zbWIycHJvdG8uaApAQCAtMjY3LDYgKzI2Nyw4IEBAIGV4dGVy
biBpbnQgc21iMl92YWxpZGF0ZV9hbmRfY29weV9pb3YodW5zaWduZWQgaW50IG9mZnNldCwKIGV4
dGVybiB2b2lkIHNtYjJfY29weV9mc19pbmZvX3RvX2tzdGF0ZnMoCiAJIHN0cnVjdCBzbWIyX2Zz
X2Z1bGxfc2l6ZV9pbmZvICpwZnNfaW5mLAogCSBzdHJ1Y3Qga3N0YXRmcyAqa3N0KTsKK2V4dGVy
biB2b2lkIGNvcHlfcG9zaXhfZnNfaW5mb190b19rc3RhdGZzKEZJTEVfU1lTVEVNX1BPU0lYX0lO
Rk8gKnJlc3BvbnNlX2RhdGEsCisJCQkJCSAgc3RydWN0IGtzdGF0ZnMgKmtzdCk7CiBleHRlcm4g
aW50IHNtYjMxMV9jcnlwdG9fc2hhc2hfYWxsb2NhdGUoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAq
c2VydmVyKTsKIGV4dGVybiBpbnQgc21iMzExX3VwZGF0ZV9wcmVhdXRoX2hhc2goc3RydWN0IGNp
ZnNfc2VzICpzZXMsCiAJCQkJICAgICAgc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLAot
LSAKMi4zNC4xCgo=
--0000000000005ca3b005e88157ad--
