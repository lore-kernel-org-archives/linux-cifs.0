Return-Path: <SRS0=TaZu=3G=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EBFEC33CAF
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 02:28:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58C632075B
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 02:28:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C1GzlNB6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388783AbgAQC2Q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Jan 2020 21:28:16 -0500
Received: from mail-il1-f173.google.com ([209.85.166.173]:35357 "EHLO
        mail-il1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388334AbgAQC2P (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Jan 2020 21:28:15 -0500
Received: by mail-il1-f173.google.com with SMTP id g12so20072924ild.2
        for <linux-cifs@vger.kernel.org>; Thu, 16 Jan 2020 18:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=IdPlpkcq90MtmxsMdzgYSKR5kfEpqL6xCI+6fmuC+50=;
        b=C1GzlNB6v5kCz4oOfF5r8qB/uRQ4y4e+uvLXMgt8qN+TtS4AC5hUtLShD/HIn4YdjR
         K2h70yHYJeewaA0N5UPAbvSNx4LIE3BDUMZTXAgcsMa1RtmPz3LgethcS/MEdvY+1mzu
         AUm6CYUN+t2LbhiBirjbtkIW5MMcAh7ZcK1UcI5WYjNXJwY8vfOA1jl5YkwRYIW87QT0
         bX/mLJqgkq6u/WHPIjTKBzngl6Qecjt6XxhM+TgI/CFe42OQjP+HUXrhqC5PlC68ZkoM
         RPxtrI9kMBFqaVxo3H7s+mMNBs3+nD3nHTIUPJKFlIIiUEQRNmeuQf+tJr7JSOSd/eH7
         PUrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=IdPlpkcq90MtmxsMdzgYSKR5kfEpqL6xCI+6fmuC+50=;
        b=YLCOPVlJhNhJbpXnvu7VOnongGSV2VyjxLooxay2Aiu94hifiDS28fUUyo6ssULs/T
         PQPbHgdUTff2UMUx9y0p+71Zcw4eRMb66KjqzaE5cfJkyCA1gBmJpqo7KIP1aMW6bwJx
         8mHkOKfwfmOTNrAYQIuSMFL1P8u98xoez0TNXDfLe4BXGM4ZH4ZGB6108xJiTYexm13o
         4NmpYIuJA+c6t71ByAPn9wfzUUHVXAoGJDQvlH1w2Wc1d1bznywdGi+yoSkd81qlbwep
         cwA8M1jfm2CQp/axas1C6sFQLpdgygD2ABFuhrxyza8FhBN9PCzYfyXxwir1fnXJsPTT
         /O7Q==
X-Gm-Message-State: APjAAAXlhXH9P7riGmySax4zUYcJpCoV3fof9jSP9t3Fn6HJOXwjAIhq
        XQupQ8vOs6Ga0e0dRyknKyTTaMUz/IosRqyfw4sNrFO9r/E=
X-Google-Smtp-Source: APXvYqy/otHKfRLGVped59HBXdw0o9S3bSskkWj8YYvKswauUHyOafJzeNGGd5e5GLp9YRPF86yVeJopCCaIk3dc+h0=
X-Received: by 2002:a92:9a90:: with SMTP id c16mr1240186ill.3.1579228094607;
 Thu, 16 Jan 2020 18:28:14 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 16 Jan 2020 20:28:03 -0600
Message-ID: <CAH2r5mvLCqTXVFG93AgSJHTu8daMLwV_hpbjgJs-7orUwr7ffg@mail.gmail.com>
Subject: [PATCH][SMB3] Fix modefromsid newly created files to allow more
 permission on server
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000099acfe059c4cb191"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000099acfe059c4cb191
Content-Type: text/plain; charset="UTF-8"

    When mounting with "modefromsid" mount parm most servers will require
    that some default permissions are given to users in the ACL on newly
    created files, and for files created with the new 'sd context' -
when passing in
    an sd context on create, permissions are not inherited from the parent
    directory, so in addition to the ACE with the special SID (which contains
    the mode), we also must pass in an ACE allowing users to access the file
    (GENERIC_ALL for authenticated users seemed like a reasonable default,
    although later we could allow a mount option or config switch to make
    it GENERIC_ALL for EVERYONE special sid).




-- 
Thanks,

Steve

--00000000000099acfe059c4cb191
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-smb3-fix-default-permissions-on-new-files-when-mount.patch"
Content-Disposition: attachment; 
	filename="0002-smb3-fix-default-permissions-on-new-files-when-mount.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k5hjkwmz0>
X-Attachment-Id: f_k5hjkwmz0

RnJvbSA1Y2MxNjI0NDMzZGVlYWQ3NjgyMGJiMWI2NWMzOTM0MzMzNTVkZjg5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMTYgSmFuIDIwMjAgMTk6NTU6MzMgLTA2MDAKU3ViamVjdDogW1BBVENIIDIv
M10gc21iMzogZml4IGRlZmF1bHQgcGVybWlzc2lvbnMgb24gbmV3IGZpbGVzIHdoZW4gbW91bnRp
bmcKIHdpdGggbW9kZWZyb21zaWQKCldoZW4gbW91bnRpbmcgd2l0aCAibW9kZWZyb21zaWQiIG1v
dW50IHBhcm0gbW9zdCBzZXJ2ZXJzIHdpbGwgcmVxdWlyZQp0aGF0IHNvbWUgZGVmYXVsdCBwZXJt
aXNzaW9ucyBhcmUgZ2l2ZW4gdG8gdXNlcnMgaW4gdGhlIEFDTCBvbiBuZXdseQpjcmVhdGVkIGZp
bGVzLCBmaWxlcyBjcmVhdGVkIHdpdGggdGhlIG5ldyAnc2QgY29udGV4dCcgLSB3aGVuIHBhc3Np
bmcgaW4KYW4gc2QgY29udGV4dCBvbiBjcmVhdGUsIHBlcm1pc3Npb25zIGFyZSBub3QgaW5oZXJp
dGVkIGZyb20gdGhlIHBhcmVudApkaXJlY3RvcnksIHNvIGluIGFkZGl0aW9uIHRvIHRoZSBBQ0Ug
d2l0aCB0aGUgc3BlY2lhbCBTSUQgd2hpY2ggY29udGFpbnMKdGhlIG1vZGUsIHdlIGFsc28gbXVz
dCBwYXNzIGluIGFuIEFDRSBhbGxvd2luZyB1c2VycyB0byBhY2Nlc3MgdGhlIGZpbGUKKEdFTkVS
SUNfQUxMIGZvciBhdXRoZW50aWNhdGVkIHVzZXJzIHNlZW1lZCBsaWtlIGEgcmVhc29uYWJsZSBk
ZWZhdWx0LAphbHRob3VnaCBsYXRlciB3ZSBjb3VsZCBhbGxvdyBhIG1vdW50IG9wdGlvbiBvciBj
b25maWcgc3dpdGNoIHRvIG1ha2UKaXQgR0VORVJJQ19BTEwgZm9yIEVWRVJZT05FIHNwZWNpYWwg
c2lkKS4KCkNDOiBTdGFibGUgPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+ClNpZ25lZC1vZmYtYnk6
IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNh
Y2wuYyAgIHwgMjAgKysrKysrKysrKysrKysrKysrKysKIGZzL2NpZnMvY2lmc3Byb3RvLmggfCAg
MSArCiBmcy9jaWZzL3NtYjJwZHUuYyAgIHwgMTEgKysrKysrKystLS0KIDMgZmlsZXMgY2hhbmdl
ZCwgMjkgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZz
L2NpZnNhY2wuYyBiL2ZzL2NpZnMvY2lmc2FjbC5jCmluZGV4IDk2YWU3MmI1NTZhYy4uZmI0MWU1
MWRkNTc0IDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNhY2wuYworKysgYi9mcy9jaWZzL2NpZnNh
Y2wuYwpAQCAtODAyLDYgKzgwMiwyNiBAQCBzdGF0aWMgdm9pZCBwYXJzZV9kYWNsKHN0cnVjdCBj
aWZzX2FjbCAqcGRhY2wsIGNoYXIgKmVuZF9vZl9hY2wsCiAJcmV0dXJuOwogfQogCit1bnNpZ25l
ZCBpbnQgc2V0dXBfYXV0aHVzZXJzX0FDRShzdHJ1Y3QgY2lmc19hY2UgKnBudGFjZSkKK3sKKwlp
bnQgaTsKKwl1bnNpZ25lZCBpbnQgYWNlX3NpemUgPSAyMDsKKworCXBudGFjZS0+dHlwZSA9IEFD
Q0VTU19BTExPV0VEX0FDRV9UWVBFOworCXBudGFjZS0+ZmxhZ3MgPSAweDA7CisJcG50YWNlLT5h
Y2Nlc3NfcmVxID0gY3B1X3RvX2xlMzIoR0VORVJJQ19BTEwpOworCXBudGFjZS0+c2lkLm51bV9z
dWJhdXRoID0gMTsKKwlwbnRhY2UtPnNpZC5yZXZpc2lvbiA9IDE7CisJZm9yIChpID0gMDsgaSA8
IE5VTV9BVVRIUzsgaSsrKQorCQlwbnRhY2UtPnNpZC5hdXRob3JpdHlbaV0gPSAgc2lkX2F1dGh1
c2Vycy5hdXRob3JpdHlbaV07CisKKwlwbnRhY2UtPnNpZC5zdWJfYXV0aFswXSA9ICBzaWRfYXV0
aHVzZXJzLnN1Yl9hdXRoWzBdOworCisJLyogc2l6ZSA9IDEgKyAxICsgMiArIDQgKyAxICsgMSAr
IDYgKyAocHNpZC0+bnVtX3N1YmF1dGgqNCkgKi8KKwlwbnRhY2UtPnNpemUgPSBjcHVfdG9fbGUx
NihhY2Vfc2l6ZSk7CisJcmV0dXJuIGFjZV9zaXplOworfQorCiAvKgogICogRmlsbCBpbiB0aGUg
c3BlY2lhbCBTSUQgYmFzZWQgb24gdGhlIG1vZGUuIFNlZQogICogaHR0cDovL3RlY2huZXQubWlj
cm9zb2Z0LmNvbS9lbi11cy9saWJyYXJ5L2hoNTA5MDE3KHY9d3MuMTApLmFzcHgKZGlmZiAtLWdp
dCBhL2ZzL2NpZnMvY2lmc3Byb3RvLmggYi9mcy9jaWZzL2NpZnNwcm90by5oCmluZGV4IGY2ZjNj
YzkwY2QxOC4uOTQ4YmYzNDc0ZGIxIDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNwcm90by5oCisr
KyBiL2ZzL2NpZnMvY2lmc3Byb3RvLmgKQEAgLTIxMyw2ICsyMTMsNyBAQCBleHRlcm4gc3RydWN0
IGNpZnNfbnRzZCAqZ2V0X2NpZnNfYWNsX2J5X2ZpZChzdHJ1Y3QgY2lmc19zYl9pbmZvICosCiAJ
CQkJCQljb25zdCBzdHJ1Y3QgY2lmc19maWQgKiwgdTMyICopOwogZXh0ZXJuIGludCBzZXRfY2lm
c19hY2woc3RydWN0IGNpZnNfbnRzZCAqLCBfX3UzMiwgc3RydWN0IGlub2RlICosCiAJCQkJY29u
c3QgY2hhciAqLCBpbnQpOworZXh0ZXJuIHVuc2lnbmVkIGludCBzZXR1cF9hdXRodXNlcnNfQUNF
KHN0cnVjdCBjaWZzX2FjZSAqcGFjZSk7CiBleHRlcm4gdW5zaWduZWQgaW50IHNldHVwX3NwZWNp
YWxfbW9kZV9BQ0Uoc3RydWN0IGNpZnNfYWNlICpwYWNlLCBfX3U2NCBubW9kZSk7CiAKIGV4dGVy
biB2b2lkIGRlcXVldWVfbWlkKHN0cnVjdCBtaWRfcV9lbnRyeSAqbWlkLCBib29sIG1hbGZvcm1l
ZCk7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuYyBiL2ZzL2NpZnMvc21iMnBkdS5jCmlu
ZGV4IGEyM2NhM2QwZGNkOS4uNzA4M2Q3OWRlNGU0IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJw
ZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUuYwpAQCAtMjE5OSwxMyArMjE5OSwxNCBAQCBjcmVh
dGVfc2RfYnVmKHVtb2RlX3QgbW9kZSwgdW5zaWduZWQgaW50ICpsZW4pCiAJc3RydWN0IGNpZnNf
YWNlICpwYWNlOwogCXVuc2lnbmVkIGludCBzZGxlbiwgYWNlbGVuOwogCi0JKmxlbiA9IHJvdW5k
dXAoc2l6ZW9mKHN0cnVjdCBjcnRfc2RfY3R4dCkgKyBzaXplb2Yoc3RydWN0IGNpZnNfYWNlKSwg
OCk7CisJKmxlbiA9IHJvdW5kdXAoc2l6ZW9mKHN0cnVjdCBjcnRfc2RfY3R4dCkgKyBzaXplb2Yo
c3RydWN0IGNpZnNfYWNlKSAqIDIsCisJCQk4KTsKIAlidWYgPSBremFsbG9jKCpsZW4sIEdGUF9L
RVJORUwpOwogCWlmIChidWYgPT0gTlVMTCkKIAkJcmV0dXJuIGJ1ZjsKIAogCXNkbGVuID0gc2l6
ZW9mKHN0cnVjdCBzbWIzX3NkKSArIHNpemVvZihzdHJ1Y3Qgc21iM19hY2wpICsKLQkJIHNpemVv
ZihzdHJ1Y3QgY2lmc19hY2UpOworCQkgKDIgKiBzaXplb2Yoc3RydWN0IGNpZnNfYWNlKSk7CiAK
IAlidWYtPmNjb250ZXh0LkRhdGFPZmZzZXQgPSBjcHVfdG9fbGUxNihvZmZzZXRvZgogCQkJCQko
c3RydWN0IGNydF9zZF9jdHh0LCBzZCkpOwpAQCAtMjIzMiw4ICsyMjMzLDEyIEBAIGNyZWF0ZV9z
ZF9idWYodW1vZGVfdCBtb2RlLCB1bnNpZ25lZCBpbnQgKmxlbikKIAkvKiBjcmVhdGUgb25lIEFD
RSB0byBob2xkIHRoZSBtb2RlIGVtYmVkZGVkIGluIHJlc2VydmVkIHNwZWNpYWwgU0lEICovCiAJ
cGFjZSA9IChzdHJ1Y3QgY2lmc19hY2UgKikoc2l6ZW9mKHN0cnVjdCBjcnRfc2RfY3R4dCkgKyAo
Y2hhciAqKWJ1Zik7CiAJYWNlbGVuID0gc2V0dXBfc3BlY2lhbF9tb2RlX0FDRShwYWNlLCAoX191
NjQpbW9kZSk7CisJLyogYW5kIG9uZSBtb3JlIEFDRSB0byBhbGxvdyBhY2Nlc3MgZm9yIGF1dGhl
bnRpY2F0ZWQgdXNlcnMgKi8KKwlwYWNlID0gKHN0cnVjdCBjaWZzX2FjZSAqKShhY2VsZW4gKyAo
c2l6ZW9mKHN0cnVjdCBjcnRfc2RfY3R4dCkgKworCQkoY2hhciAqKWJ1ZikpOworCWFjZWxlbiAr
PSBzZXR1cF9hdXRodXNlcnNfQUNFKHBhY2UpOwogCWJ1Zi0+YWNsLkFjbFNpemUgPSBjcHVfdG9f
bGUxNihzaXplb2Yoc3RydWN0IGNpZnNfYWNsKSArIGFjZWxlbik7Ci0JYnVmLT5hY2wuQWNlQ291
bnQgPSBjcHVfdG9fbGUxNigxKTsKKwlidWYtPmFjbC5BY2VDb3VudCA9IGNwdV90b19sZTE2KDIp
OwogCXJldHVybiBidWY7CiB9CiAKLS0gCjIuMjQuMQoK
--00000000000099acfe059c4cb191--
