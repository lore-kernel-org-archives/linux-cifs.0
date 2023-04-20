Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B4DFC77B73
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Apr 2023 19:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbjDTTOq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 Apr 2023 15:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbjDTTOn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 Apr 2023 15:14:43 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B59468A
        for <linux-cifs@vger.kernel.org>; Thu, 20 Apr 2023 12:14:33 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-54ee0b73e08so56560317b3.0
        for <linux-cifs@vger.kernel.org>; Thu, 20 Apr 2023 12:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682018073; x=1684610073;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KQMGCfVA+/ge06awxEc0rOQgjnrWB4pDJlSEfdztpHo=;
        b=ZCZxKw1NNagXjVBFH6xhcOp4s8gXkImPJGPG2r5nCRlDSpLTByTnoEqqF3eIBBO8JV
         1S8J27Bxe56oI6KGv9et1DljkT4W0bqIl3AbZaw71XF6EJZQGAJBUrBrtmvRoKoh/9Oa
         f1TV5q7xchBOWeryi7JTCUy6JZ+Kb5ErJplnINmJIlwvZzdREz6qA1b/JFKwllLLOkMn
         yqalmCjhlWt2c6dv8Ok3PNTCaMa2CzxsoeVF/cBYdCYmTC63s7G616E6eUcgYIHizvxM
         tDWaAd8F8r60lDqCO6H2bgcrfZZhkac4iBcPsCj6GZfxezs4E0XFIrJPwgQaLbED51+G
         Gd0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682018073; x=1684610073;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KQMGCfVA+/ge06awxEc0rOQgjnrWB4pDJlSEfdztpHo=;
        b=YZHqRMGqKOIEOOz69hlVld8Y9MLYpUaPp9zzOajCMbn8bWGdd7pp06QvSOsO0QM3gV
         uC7rwwAHMuTz4JJpElL5Nh77tGPEZVadm7ai9x4T+bfnwY4JGzlm3lm6GLRMr7CaqM81
         2G5XP1us8cTnQH4vKuBXHLq6sezRT3nWHiCrS4bw2s7s4qCgFP0UlThrZBNbGYTL3MV5
         w1ytH7j/IzU7NAlDLSKSJ7z1mrcsH2YFbt9TRvCkvlPSkknQQZ2f3NM4DXHss9zaJ+1X
         nVYAV9XqKIJIGg3Ii/vMoErxY+O14tamLcMhI+me8qaVDNBKTHMAhT2K64KG1eotQuCz
         5DOg==
X-Gm-Message-State: AAQBX9fePmRHWqBQRvzAFCkecgYE+Fw4uWA2XGMykhU+A1MwDPWrY75F
        pau1n1NPGj6ezk+kZf19WxEu1k1AZomZa5INQR8=
X-Google-Smtp-Source: AKy350anddaeyNHbywxhS7lUaAgEPepZvE3z5RsWlBA66p5MtDF4NbetBJ3RUEaG5pwcgVkKAQIof0tiE0yxwB6hygw=
X-Received: by 2002:a0d:f3c7:0:b0:552:c551:9cff with SMTP id
 c190-20020a0df3c7000000b00552c5519cffmr1496133ywf.21.1682018071440; Thu, 20
 Apr 2023 12:14:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230420160646.291053-1-bharathsm.hsk@gmail.com> <a63523569c379a1ec13a1f352687cdcf.pc@manguebit.com>
In-Reply-To: <a63523569c379a1ec13a1f352687cdcf.pc@manguebit.com>
From:   Bharath SM <bharathsm.hsk@gmail.com>
Date:   Fri, 21 Apr 2023 00:44:20 +0530
Message-ID: <CAGypqWz2nopcpdgujs7K26daMa1fLdY9iFfwELJ4xDpxxvMmPQ@mail.gmail.com>
Subject: Re: [PATCH] SMB3: Add missing locks to protect deferred close file list
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     pc@cjr.nz, sfrench@samba.org, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
        Bharath SM <bharathsm@microsoft.com>
Content-Type: multipart/mixed; boundary="000000000000a8173205f9c959d2"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000a8173205f9c959d2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 20, 2023 at 11:15=E2=80=AFPM Paulo Alcantara <pc@manguebit.com>=
 wrote:
>
> Bharath SM <bharathsm.hsk@gmail.com> writes:
>
> > From: Bharath SM <bharathsm@microsoft.com>
> >
> > cifs_del_deferred_close function has a critical section which modifies
> > the deferred close file list. We must acquire deferred_lock before
> > calling cifs_del_deferred_close function.
> >
> > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > ---
> >  fs/cifs/misc.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> > index a0d286ee723d..89bbc12e2ca7 100644
> > --- a/fs/cifs/misc.c
> > +++ b/fs/cifs/misc.c
> > @@ -742,7 +742,10 @@ cifs_close_deferred_file(struct cifsInodeInfo *cif=
s_inode)
> >       list_for_each_entry(cfile, &cifs_inode->openFileList, flist) {
> >               if (delayed_work_pending(&cfile->deferred)) {
> >                       if (cancel_delayed_work(&cfile->deferred)) {
> > +
>
> No need for this extra blank line.  Please remove the below ones as
> well.
>
> With the "Fixes:" tag added as per Ronnie's suggestion,
>
> Acked-by: Paulo Alcantara (SUSE) <pc@manguebit.com>

Done. Please find updated patch in attachments.

--000000000000a8173205f9c959d2
Content-Type: application/octet-stream; 
	name="0001-SMB3-Add-missing-locks-to-protect-deferred-close-fil.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-Add-missing-locks-to-protect-deferred-close-fil.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lgpi0wir0>
X-Attachment-Id: f_lgpi0wir0

RnJvbSAwZGIzZThhZWZmMDk3M2Y5Y2JlNmE1NTAzMDkxOGUxYjgyOGUxYjZhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCaGFyYXRoIFNNIDxiaGFyYXRoc21AbWljcm9zb2Z0LmNvbT4K
RGF0ZTogVGh1LCAyMCBBcHIgMjAyMyAxMzo1NDozMyArMDAwMApTdWJqZWN0OiBbUEFUQ0hdIFNN
QjM6IEFkZCBtaXNzaW5nIGxvY2tzIHRvIHByb3RlY3QgZGVmZXJyZWQgY2xvc2UgZmlsZSBsaXN0
CgpjaWZzX2RlbF9kZWZlcnJlZF9jbG9zZSBmdW5jdGlvbiBoYXMgYSBjcml0aWNhbCBzZWN0aW9u
IHdoaWNoIG1vZGlmaWVzCnRoZSBkZWZlcnJlZCBjbG9zZSBmaWxlIGxpc3QuIFdlIG11c3QgYWNx
dWlyZSBkZWZlcnJlZF9sb2NrIGJlZm9yZQpjYWxsaW5nIGNpZnNfZGVsX2RlZmVycmVkX2Nsb3Nl
IGZ1bmN0aW9uLgoKRml4ZXM6IGNhMDhkMGVhYzAyMCAoImNpZnM6IEZpeCBtZW1vcnkgbGVhayBv
biB0aGUgZGVmZXJyZWQgY2xvc2UiKQpTaWduZWQtb2ZmLWJ5OiBCaGFyYXRoIFNNIDxiaGFyYXRo
c21AbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL21pc2MuYyB8IDYgKysrKysrCiAxIGZpbGUg
Y2hhbmdlZCwgNiBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9taXNjLmMgYi9m
cy9jaWZzL21pc2MuYwppbmRleCBhMGQyODZlZTcyM2QuLjVmODc0ZTljMTU1NCAxMDA2NDQKLS0t
IGEvZnMvY2lmcy9taXNjLmMKKysrIGIvZnMvY2lmcy9taXNjLmMKQEAgLTc0Miw3ICs3NDIsOSBA
QCBjaWZzX2Nsb3NlX2RlZmVycmVkX2ZpbGUoc3RydWN0IGNpZnNJbm9kZUluZm8gKmNpZnNfaW5v
ZGUpCiAJbGlzdF9mb3JfZWFjaF9lbnRyeShjZmlsZSwgJmNpZnNfaW5vZGUtPm9wZW5GaWxlTGlz
dCwgZmxpc3QpIHsKIAkJaWYgKGRlbGF5ZWRfd29ya19wZW5kaW5nKCZjZmlsZS0+ZGVmZXJyZWQp
KSB7CiAJCQlpZiAoY2FuY2VsX2RlbGF5ZWRfd29yaygmY2ZpbGUtPmRlZmVycmVkKSkgeworCQkJ
CXNwaW5fbG9jaygmY2lmc19pbm9kZS0+ZGVmZXJyZWRfbG9jayk7CiAJCQkJY2lmc19kZWxfZGVm
ZXJyZWRfY2xvc2UoY2ZpbGUpOworCQkJCXNwaW5fdW5sb2NrKCZjaWZzX2lub2RlLT5kZWZlcnJl
ZF9sb2NrKTsKIAogCQkJCXRtcF9saXN0ID0ga21hbGxvYyhzaXplb2Yoc3RydWN0IGZpbGVfbGlz
dCksIEdGUF9BVE9NSUMpOwogCQkJCWlmICh0bXBfbGlzdCA9PSBOVUxMKQpAQCAtNzczLDcgKzc3
NSw5IEBAIGNpZnNfY2xvc2VfYWxsX2RlZmVycmVkX2ZpbGVzKHN0cnVjdCBjaWZzX3Rjb24gKnRj
b24pCiAJbGlzdF9mb3JfZWFjaF9lbnRyeShjZmlsZSwgJnRjb24tPm9wZW5GaWxlTGlzdCwgdGxp
c3QpIHsKIAkJaWYgKGRlbGF5ZWRfd29ya19wZW5kaW5nKCZjZmlsZS0+ZGVmZXJyZWQpKSB7CiAJ
CQlpZiAoY2FuY2VsX2RlbGF5ZWRfd29yaygmY2ZpbGUtPmRlZmVycmVkKSkgeworCQkJCXNwaW5f
bG9jaygmQ0lGU19JKGRfaW5vZGUoY2ZpbGUtPmRlbnRyeSkpLT5kZWZlcnJlZF9sb2NrKTsKIAkJ
CQljaWZzX2RlbF9kZWZlcnJlZF9jbG9zZShjZmlsZSk7CisJCQkJc3Bpbl91bmxvY2soJkNJRlNf
SShkX2lub2RlKGNmaWxlLT5kZW50cnkpKS0+ZGVmZXJyZWRfbG9jayk7CiAKIAkJCQl0bXBfbGlz
dCA9IGttYWxsb2Moc2l6ZW9mKHN0cnVjdCBmaWxlX2xpc3QpLCBHRlBfQVRPTUlDKTsKIAkJCQlp
ZiAodG1wX2xpc3QgPT0gTlVMTCkKQEAgLTgwOCw3ICs4MTIsOSBAQCBjaWZzX2Nsb3NlX2RlZmVy
cmVkX2ZpbGVfdW5kZXJfZGVudHJ5KHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sIGNvbnN0IGNoYXIg
KnBhdGgpCiAJCWlmIChzdHJzdHIoZnVsbF9wYXRoLCBwYXRoKSkgewogCQkJaWYgKGRlbGF5ZWRf
d29ya19wZW5kaW5nKCZjZmlsZS0+ZGVmZXJyZWQpKSB7CiAJCQkJaWYgKGNhbmNlbF9kZWxheWVk
X3dvcmsoJmNmaWxlLT5kZWZlcnJlZCkpIHsKKwkJCQkJc3Bpbl9sb2NrKCZDSUZTX0koZF9pbm9k
ZShjZmlsZS0+ZGVudHJ5KSktPmRlZmVycmVkX2xvY2spOwogCQkJCQljaWZzX2RlbF9kZWZlcnJl
ZF9jbG9zZShjZmlsZSk7CisJCQkJCXNwaW5fdW5sb2NrKCZDSUZTX0koZF9pbm9kZShjZmlsZS0+
ZGVudHJ5KSktPmRlZmVycmVkX2xvY2spOwogCiAJCQkJCXRtcF9saXN0ID0ga21hbGxvYyhzaXpl
b2Yoc3RydWN0IGZpbGVfbGlzdCksIEdGUF9BVE9NSUMpOwogCQkJCQlpZiAodG1wX2xpc3QgPT0g
TlVMTCkKLS0gCjIuMzQuMQoK
--000000000000a8173205f9c959d2--
