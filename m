Return-Path: <SRS0=6DZW=TZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A00BCC07542
	for <linux-cifs@archiver.kernel.org>; Sat, 25 May 2019 22:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DA1C2075E
	for <linux-cifs@archiver.kernel.org>; Sat, 25 May 2019 22:36:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G4qv4yss"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfEYWf7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 May 2019 18:35:59 -0400
Received: from mail-vs1-f47.google.com ([209.85.217.47]:36375 "EHLO
        mail-vs1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfEYWf7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 25 May 2019 18:35:59 -0400
Received: by mail-vs1-f47.google.com with SMTP id l20so8271704vsp.3
        for <linux-cifs@vger.kernel.org>; Sat, 25 May 2019 15:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=3yXjbWerqXcHUYa+TCJJdoQqGeMhHAiIgNdsitC+Gls=;
        b=G4qv4yssviRrZ/apbmCTipqLL3KKedhIGQCwXTgRYySin+c8NtEQVXvBphsa+asFLU
         BBnl1EfuSWgCakpS55FZ0sGfdX5InChgk0QE81mHlvAEIs3kZiKGMEF+RHJCmKXVtmTZ
         l4NMr826nCEVLI+lJYfBSMlkHLLisV2greejRYmT60n9LoA8yIr8miNVkVyi4A3B5JET
         Q5OSvow/e+5LLUdKk5RFhIaOECjs2biRZbrrTvFQoURpc/koFNkS6NoY1iATkUsR/ocg
         86guIaRlW80ErhMnWUCpXlQJUJWZnTKMBOqDpvKuCGhmBkb88xeyFE/n2w5V/86bYHza
         9j9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=3yXjbWerqXcHUYa+TCJJdoQqGeMhHAiIgNdsitC+Gls=;
        b=sUx2UsRfIeiuOxtUfp+wg4W8oQRGRO1x9z2Rs80US1r4cktlr6oNBGAQkbTWu9JgIE
         yL1U9lOdbII8o8DnHUZREaF2+Q6+5/6UA5vT6w2q/+hyXzCSWCuKwFLQO3RlFW9EECtb
         o3dOONLZDfTraNNmm2RXL+B4lgW9zce93YVyY4vFf+uPVhMBP/HOKyWxJ4WDhWdQpTqj
         eRvOA6wqnDbd+BGAOudAljKnB172Yzqk1+bEOuV5dOEpip/lIxgk4In9947GqbCt+7OV
         I1RexUaLsrAim9UIcfqEBZ49lX1zCc4WoU0O1PLjz8pUbL7kLJWo7CrT+7iqZ7QvmTQ0
         NdAQ==
X-Gm-Message-State: APjAAAWnmbjSHCovNk8S/bvhBhc6LIwRlUdG8ON+wAVDIEynG7+ltV6L
        4b2qu19pP0KvXbFgMA7+Q71YxTl7YrS/h/8zQCSYjoEpdpg=
X-Google-Smtp-Source: APXvYqzgfH7gBUyr1yuiXJJXbew/LxJpjK6taqDT/RiSKp4hJzwVydkp2tAGlnI/Q8PSlsainHo6UW8zcCjYPASAZ3E=
X-Received: by 2002:a67:ef45:: with SMTP id k5mr36013915vsr.105.1558823757884;
 Sat, 25 May 2019 15:35:57 -0700 (PDT)
MIME-Version: 1.0
From:   Adam Richter <adamrichter4@gmail.com>
Date:   Sat, 25 May 2019 15:35:47 -0700
Message-ID: <CAGn-TgiGah++0ibn3vjM+bvBkJa3XttxA12k+Qa4PGME89CTOQ@mail.gmail.com>
Subject: [PATCH] cifs-utils: smbinfo.c: probably harmless wrong memset sizes +
 printf format correction
To:     linux-cifs@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000005b58710589bdf0fd"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000005b58710589bdf0fd
Content-Type: text/plain; charset="UTF-8"

The attached patch is my attempt at fixing two possibly harmless
complaints from "cppcheck --enable=warning" from the cifs-utils git
master branch version of smbinfo.c.

1. A printf format should have been "%u" instead of "%d" in print_quota.

2. An incorrect size was being passed to memset in thirteen nearly
identical places, each using "sizeof(qi)" when "sizeof(*qi)".  I am
not sure but I think these mistakes were probably harmless because the
memset calls might all be unnecessary and the sizes passed to each
memset call might never have been larger than it was supposed to be.

Because each of the effected memset calls was immediately preceded by
the malloc which allocated the data structure and because they each
ignored the possibility that malloc could fail, I made a function,
xmalloc0 to combine allocating the memory, zeroing it and exiting with
a non-zero exit value and a failure message on allocation failure
(which appears to be a fine way to handle the error in this program).
The function uses calloc, which could introduce an unnecessary
multiply, in the hopes that some calloc implementations may avoid the
memset in the case of freshly allocated memory from mmap, which would
probably be the case in this program, although I do not know if any
calloc implementations make this optimization.  Anyhow, at least this
way, the size of the data structure is only computed once in the
source code.

I realize that these memory allocations may all be for small data
structures that should be allocated on the stack and also may not need
to be cleared to all zeroes, but I did not want to delve into coding
style conventions for stack allocation in the CIFS source tree, and I
was not 100% certain that clearing the allocated memory was
unnecessary, although I do see other lines that explicitly initialize
some field in that that allocated memory to zero.  So, please feel
free to replace my changes with something better or one that involves
less code churn.

I should also warn that my only testing of these changes was to make
sure that "cppcheck --enable=warning" no longer complains, that the
file compiled without complaint (with cifs-utils standard "-Wall
-Wextra" arguments) and that "./smbinfo quote /dev/null" got past the
memory allocation to the (correct) ioctl error for /dev/null.

Also, I am not a CIFS developer and this may be the first time I have
submitted a patch, certainly the first time I remember, so please
forgive me and feel free to instruct me if I should be following some
different process to submit this patch.

Thanks in advance for considering this patch submission.

Adam

--0000000000005b58710589bdf0fd
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="cifs-utils.smbinfo.memset_and_printf.diff"
Content-Disposition: attachment; 
	filename="cifs-utils.smbinfo.memset_and_printf.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_jw43c2ek0>
X-Attachment-Id: f_jw43c2ek0

LS0tIGNpZnMtdXRpbHMvc21iaW5mby5jLm9yaWcJMjAxOS0wNS0yNSAxNDoxOTo1Ni43NTg0NzQ1
ODggLTA3MDAKKysrIGNpZnMtdXRpbHMvc21iaW5mby5jCTIwMTktMDUtMjUgMTQ6MjY6MjIuNjMz
MjU2OTEzIC0wNzAwCkBAIC05Nyw2ICs5NywxOCBAQCB1c2FnZShjaGFyICpuYW1lKQogCWV4aXQo
MSk7CiB9CiAKK3N0YXRpYyB2b2lkICoKK3htYWxsb2MwKHNpemVfdCBuYnl0ZXMpCit7CisJdm9p
ZCAqcmVzdWx0ID0gY2FsbG9jKDEsIG5ieXRlcyk7CisJaWYgKHJlc3VsdCA9PSBOVUxMKSB7CisJ
CWZwcmludGYoc3RkZXJyLCAiJXM6IGZhaWxlZCB0byBhbGxvY2F0ZSAlenUgYnl0ZXMuXG4iLAor
CQkJX19mdW5jX18sIG5ieXRlcyk7CisJCWV4aXQoMSk7CisJfQorCXJldHVybiByZXN1bHQ7Cit9
CisKIHN0YXRpYyB2b2lkCiB3aW5fdG9fdGltZXZhbCh1aW50NjRfdCBzbWIyX3RpbWUsIHN0cnVj
dCB0aW1ldmFsICp0dikKIHsKQEAgLTIyNSw4ICsyMzcsNyBAQCBmc2N0bGdldG9iamlkKGludCBm
KQogCiAJZnN0YXQoZiwgJnN0KTsKIAotCXFpID0gbWFsbG9jKHNpemVvZihzdHJ1Y3Qgc21iX3F1
ZXJ5X2luZm8pICsgNjQpOwotCW1lbXNldChxaSwgMCwgc2l6ZW9mKHFpKSArIDY0KTsKKwlxaSA9
IHhtYWxsb2MwKHNpemVvZihzdHJ1Y3Qgc21iX3F1ZXJ5X2luZm8pICsgNjQpOwogCXFpLT5pbmZv
X3R5cGUgPSAweDkwMDljOwogCXFpLT5maWxlX2luZm9fY2xhc3MgPSAwOwogCXFpLT5hZGRpdGlv
bmFsX2luZm9ybWF0aW9uID0gMDsKQEAgLTI2OCw4ICsyNzksNyBAQCBmaWxlYWNjZXNzaW5mbyhp
bnQgZikKIAogCWZzdGF0KGYsICZzdCk7CiAKLQlxaSA9IG1hbGxvYyhzaXplb2Yoc3RydWN0IHNt
Yl9xdWVyeV9pbmZvKSArIDQpOwotCW1lbXNldChxaSwgMCwgc2l6ZW9mKHFpKSArIDQpOworCXFp
ID0geG1hbGxvYzAoc2l6ZW9mKHN0cnVjdCBzbWJfcXVlcnlfaW5mbykgKyA0KTsKIAlxaS0+aW5m
b190eXBlID0gMHgwMTsKIAlxaS0+ZmlsZV9pbmZvX2NsYXNzID0gODsKIAlxaS0+YWRkaXRpb25h
bF9pbmZvcm1hdGlvbiA9IDA7CkBAIC0zMjIsOCArMzMyLDcgQEAgZmlsZWFsaWduaW5mbyhpbnQg
ZikKIHsKIAlzdHJ1Y3Qgc21iX3F1ZXJ5X2luZm8gKnFpOwogCi0JcWkgPSBtYWxsb2Moc2l6ZW9m
KHN0cnVjdCBzbWJfcXVlcnlfaW5mbykgKyA0KTsKLQltZW1zZXQocWksIDAsIHNpemVvZihxaSkg
KyA0KTsKKwlxaSA9IHhtYWxsb2MwKHNpemVvZihzdHJ1Y3Qgc21iX3F1ZXJ5X2luZm8pICsgNCk7
CiAJcWktPmluZm9fdHlwZSA9IDB4MDE7CiAJcWktPmZpbGVfaW5mb19jbGFzcyA9IDE3OwogCXFp
LT5hZGRpdGlvbmFsX2luZm9ybWF0aW9uID0gMDsKQEAgLTM5Miw4ICs0MDEsNyBAQCBmaWxlYmFz
aWNpbmZvKGludCBmKQogewogCXN0cnVjdCBzbWJfcXVlcnlfaW5mbyAqcWk7CiAKLQlxaSA9IG1h
bGxvYyhzaXplb2Yoc3RydWN0IHNtYl9xdWVyeV9pbmZvKSArIDQwKTsKLQltZW1zZXQocWksIDAs
IHNpemVvZihxaSkgKyA0MCk7CisJcWkgPSB4bWFsbG9jMChzaXplb2Yoc3RydWN0IHNtYl9xdWVy
eV9pbmZvKSArIDQwKTsKIAlxaS0+aW5mb190eXBlID0gMHgwMTsKIAlxaS0+ZmlsZV9pbmZvX2Ns
YXNzID0gNDsKIAlxaS0+YWRkaXRpb25hbF9pbmZvcm1hdGlvbiA9IDA7CkBAIC00MzIsOCArNDQw
LDcgQEAgZmlsZXN0YW5kYXJkaW5mbyhpbnQgZikKIHsKIAlzdHJ1Y3Qgc21iX3F1ZXJ5X2luZm8g
KnFpOwogCi0JcWkgPSBtYWxsb2Moc2l6ZW9mKHN0cnVjdCBzbWJfcXVlcnlfaW5mbykgKyAyNCk7
Ci0JbWVtc2V0KHFpLCAwLCBzaXplb2YocWkpICsgMjQpOworCXFpID0geG1hbGxvYzAoc2l6ZW9m
KHN0cnVjdCBzbWJfcXVlcnlfaW5mbykgKyAyNCk7CiAJcWktPmluZm9fdHlwZSA9IDB4MDE7CiAJ
cWktPmZpbGVfaW5mb19jbGFzcyA9IDU7CiAJcWktPmFkZGl0aW9uYWxfaW5mb3JtYXRpb24gPSAw
OwpAQCAtNDYyLDggKzQ2OSw3IEBAIGZpbGVpbnRlcm5hbGluZm8oaW50IGYpCiB7CiAJc3RydWN0
IHNtYl9xdWVyeV9pbmZvICpxaTsKIAotCXFpID0gbWFsbG9jKHNpemVvZihzdHJ1Y3Qgc21iX3F1
ZXJ5X2luZm8pICsgOCk7Ci0JbWVtc2V0KHFpLCAwLCBzaXplb2YocWkpICsgOCk7CisJcWkgPSB4
bWFsbG9jMChzaXplb2Yoc3RydWN0IHNtYl9xdWVyeV9pbmZvKSArIDgpOwogCXFpLT5pbmZvX3R5
cGUgPSAweDAxOwogCXFpLT5maWxlX2luZm9fY2xhc3MgPSA2OwogCXFpLT5hZGRpdGlvbmFsX2lu
Zm9ybWF0aW9uID0gMDsKQEAgLTUwNSw4ICs1MTEsNyBAQCBmaWxlbW9kZWluZm8oaW50IGYpCiB7
CiAJc3RydWN0IHNtYl9xdWVyeV9pbmZvICpxaTsKIAotCXFpID0gbWFsbG9jKHNpemVvZihzdHJ1
Y3Qgc21iX3F1ZXJ5X2luZm8pICsgNCk7Ci0JbWVtc2V0KHFpLCAwLCBzaXplb2YocWkpICsgNCk7
CisJcWkgPSB4bWFsbG9jMChzaXplb2Yoc3RydWN0IHNtYl9xdWVyeV9pbmZvKSArIDQpOwogCXFp
LT5pbmZvX3R5cGUgPSAweDAxOwogCXFpLT5maWxlX2luZm9fY2xhc3MgPSAxNjsKIAlxaS0+YWRk
aXRpb25hbF9pbmZvcm1hdGlvbiA9IDA7CkBAIC01MzUsOCArNTQwLDcgQEAgZmlsZXBvc2l0aW9u
aW5mbyhpbnQgZikKIHsKIAlzdHJ1Y3Qgc21iX3F1ZXJ5X2luZm8gKnFpOwogCi0JcWkgPSBtYWxs
b2Moc2l6ZW9mKHN0cnVjdCBzbWJfcXVlcnlfaW5mbykgKyA4KTsKLQltZW1zZXQocWksIDAsIHNp
emVvZihxaSkgKyA4KTsKKwlxaSA9IHhtYWxsb2MwKHNpemVvZihzdHJ1Y3Qgc21iX3F1ZXJ5X2lu
Zm8pICsgOCk7CiAJcWktPmluZm9fdHlwZSA9IDB4MDE7CiAJcWktPmZpbGVfaW5mb19jbGFzcyA9
IDE0OwogCXFpLT5hZGRpdGlvbmFsX2luZm9ybWF0aW9uID0gMDsKQEAgLTU2NSw4ICs1NjksNyBA
QCBmaWxlZWFpbmZvKGludCBmKQogewogCXN0cnVjdCBzbWJfcXVlcnlfaW5mbyAqcWk7CiAKLQlx
aSA9IG1hbGxvYyhzaXplb2Yoc3RydWN0IHNtYl9xdWVyeV9pbmZvKSArIDQpOwotCW1lbXNldChx
aSwgMCwgc2l6ZW9mKHFpKSArIDQpOworCXFpID0geG1hbGxvYzAoc2l6ZW9mKHN0cnVjdCBzbWJf
cXVlcnlfaW5mbykgKyA0KTsKIAlxaS0+aW5mb190eXBlID0gMHgwMTsKIAlxaS0+ZmlsZV9pbmZv
X2NsYXNzID0gNzsKIAlxaS0+YWRkaXRpb25hbF9pbmZvcm1hdGlvbiA9IDA7CkBAIC02MTAsOCAr
NjEzLDcgQEAgZmlsZWZzZnVsbHNpemVpbmZvKGludCBmKQogewogCXN0cnVjdCBzbWJfcXVlcnlf
aW5mbyAqcWk7CiAKLQlxaSA9IG1hbGxvYyhzaXplb2Yoc3RydWN0IHNtYl9xdWVyeV9pbmZvKSAr
IDMyKTsKLQltZW1zZXQocWksIDAsIHNpemVvZihxaSkgKyAzMik7CisJcWkgPSB4bWFsbG9jMChz
aXplb2Yoc3RydWN0IHNtYl9xdWVyeV9pbmZvKSArIDMyKTsKIAlxaS0+aW5mb190eXBlID0gMHgw
MjsKIAlxaS0+ZmlsZV9pbmZvX2NsYXNzID0gNzsKIAlxaS0+YWRkaXRpb25hbF9pbmZvcm1hdGlv
biA9IDA7CkBAIC02MzQsOCArNjM2LDcgQEAgZmlsZWFsbGluZm8oaW50IGYpCiAKIAlmc3RhdChm
LCAmc3QpOwogCi0JcWkgPSBtYWxsb2Moc2l6ZW9mKHN0cnVjdCBzbWJfcXVlcnlfaW5mbykgKyBJ
TlBVVF9CVUZGRVJfTEVOR1RIKTsKLQltZW1zZXQocWksIDAsIHNpemVvZihxaSkgKyBJTlBVVF9C
VUZGRVJfTEVOR1RIKTsKKwlxaSA9IHhtYWxsb2MwKHNpemVvZihzdHJ1Y3Qgc21iX3F1ZXJ5X2lu
Zm8pICsgSU5QVVRfQlVGRkVSX0xFTkdUSCk7CiAJcWktPmluZm9fdHlwZSA9IDB4MDE7CiAJcWkt
PmZpbGVfaW5mb19jbGFzcyA9IDE4OwogCXFpLT5hZGRpdGlvbmFsX2luZm9ybWF0aW9uID0gMDsK
QEAgLTg2Miw4ICs4NjMsNyBAQCBzZWNkZXNjKGludCBmKQogCiAJZnN0YXQoZiwgJnN0KTsKIAot
CXFpID0gbWFsbG9jKHNpemVvZihzdHJ1Y3Qgc21iX3F1ZXJ5X2luZm8pICsgSU5QVVRfQlVGRkVS
X0xFTkdUSCk7Ci0JbWVtc2V0KHFpLCAwLCBzaXplb2YocWkpICsgSU5QVVRfQlVGRkVSX0xFTkdU
SCk7CisJcWkgPSB4bWFsbG9jMChzaXplb2Yoc3RydWN0IHNtYl9xdWVyeV9pbmZvKSArIElOUFVU
X0JVRkZFUl9MRU5HVEgpOwogCXFpLT5pbmZvX3R5cGUgPSAweDAzOwogCXFpLT5maWxlX2luZm9f
Y2xhc3MgPSAwOwogCXFpLT5hZGRpdGlvbmFsX2luZm9ybWF0aW9uID0gMHgwMDAwMDAwNzsgLyog
T3duZXIsIEdyb3VwLCBEYWNsICovCkBAIC04OTIsNyArODkyLDcgQEAgb25lX21vcmU6CiAKIAlt
ZW1jcHkoJnUzMiwgJnNkW29mZiArIDRdLCA0KTsKIAl1MzIgPSBsZTMydG9oKHUzMik7Ci0JcHJp
bnRmKCJTSUQgTGVuZ3RoICVkXG4iLCB1MzIpOworCXByaW50ZigiU0lEIExlbmd0aCAldVxuIiwg
dTMyKTsKIAogCW1lbWNweSgmdTY0LCAmc2Rbb2ZmICsgOF0sIDgpOwogCXdpbl90b190aW1ldmFs
KGxlNjR0b2godTY0KSwgJnR2KTsKQEAgLTk0MSw4ICs5NDEsNyBAQCBxdW90YShpbnQgZikKIAlj
aGFyICpidWY7CiAJaW50IGk7CiAKLQlxaSA9IG1hbGxvYyhzaXplb2Yoc3RydWN0IHNtYl9xdWVy
eV9pbmZvKSArIElOUFVUX0JVRkZFUl9MRU5HVEgpOwotCW1lbXNldChxaSwgMCwgc2l6ZW9mKHN0
cnVjdCBzbWJfcXVlcnlfaW5mbykgKyBJTlBVVF9CVUZGRVJfTEVOR1RIKTsKKwlxaSA9IHhtYWxs
b2MwKHNpemVvZihzdHJ1Y3Qgc21iX3F1ZXJ5X2luZm8pICsgSU5QVVRfQlVGRkVSX0xFTkdUSCk7
CiAJcWktPmluZm9fdHlwZSA9IDB4MDQ7CiAJcWktPmZpbGVfaW5mb19jbGFzcyA9IDA7CiAJcWkt
PmFkZGl0aW9uYWxfaW5mb3JtYXRpb24gPSAwOyAvKiBPd25lciwgR3JvdXAsIERhY2wgKi8K
--0000000000005b58710589bdf0fd--
