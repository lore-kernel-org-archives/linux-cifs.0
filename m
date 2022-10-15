Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A09BC4332F
	for <linux-cifs@archiver.kernel.org>; Sat, 15 Oct 2022 01:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiJOBKY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Oct 2022 21:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiJOBKX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Oct 2022 21:10:23 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F743AB38
        for <linux-cifs@vger.kernel.org>; Fri, 14 Oct 2022 18:10:22 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id 1so2286939vsx.1
        for <linux-cifs@vger.kernel.org>; Fri, 14 Oct 2022 18:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Hu6tgbEUlNDw6Hl6G3P+dQPh54DeXlKRe5dCUJc4QBA=;
        b=R+Nrj6qBbEnTyPD4XVabu2jlqncDysQl3Z/GnCvaN/VZ6QvenmhkH93pwJb7XJVCAP
         9O4FudssxVNbJhVuMBbMCG3yAh0eeZxDCln5HwGtamN4dLj4RRIb5vz9nPSh8rzYJPuC
         qQvTOO3NInirW/W1Mnt9hV6xrJUhlpyRQt18fK8pZsdPFAbDVxyzX9A773m7kFehjnpE
         hxYSzwWPZo4WSib4JAqdIVaP/1mMDEEeom+ZcMPrhe4qzKkVcStoq8RQi6cUOjbjxeoJ
         NxiiTrSDNk/wkWRC7hN/mt9VhVA2eKkWFN7H/Ff74YiyOcO85aHTdj0GuiO+0yAaVS4Z
         7PvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hu6tgbEUlNDw6Hl6G3P+dQPh54DeXlKRe5dCUJc4QBA=;
        b=rjjp2bSZBTUcoClVXCDUhJAWJgOqQGiI56+SbKqVi0V/IRyvKze1MHLWqZJBUgURCI
         XgeoMZIwhwSl+FyRcwlF7nSbuRGt1m1ulHkb4+grxFQqcBHxjgWrcyJg+Dnrb/s/9Qee
         Kger4pUmml5mpjeNDO2ApUko7wYvlU6vJmUyIN4JRtc8KXmSl5SLa8EgAkQXXl0Aquq8
         YthNg4WTsKZlK6u0+D9Pfmr7PW1CPERkTfu3Wv2yWq55chBYdheGnLgSALPUh6CSId3/
         StRoDipejICELS/+ZainCIbzbJaouXpcv4p6ULk3Mcru7hExTJ5kNcIwttN6J8anKWUH
         bZLA==
X-Gm-Message-State: ACrzQf29KD9vkDAZE4lhbWFHGKUJ0LSkVY7VcOzkM2FdEirhMeNq4zXc
        rCSvsZp0ic01WY3iMkKfDf8lO6m6golcPuerUKBS2WJq
X-Google-Smtp-Source: AMsMyM5OFK+v4/oDct+kXZPpj58yoiSHR029YmnizcQiC2l/t70lTEx4SpoZIbHCPmkcBA0shEqW/YTzsyj2jn039Yc=
X-Received: by 2002:a05:6102:23dc:b0:3a7:9b0c:aa8e with SMTP id
 x28-20020a05610223dc00b003a79b0caa8emr225326vsr.60.1665796220865; Fri, 14 Oct
 2022 18:10:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msaxD7WVUHNUpVfZpjrabLTU=sY-kVo+WD=F04m0v4gaA@mail.gmail.com>
 <CAH2r5mvSNk7WiuvWJ6ZbHvb0F3ze8p=amp0h_BOCy_7S=nhx1w@mail.gmail.com> <CAH2r5mv4YM41jD=PAp6L77Nf+9OgAdmj9OECgox6ZHCeSML1Vw@mail.gmail.com>
In-Reply-To: <CAH2r5mv4YM41jD=PAp6L77Nf+9OgAdmj9OECgox6ZHCeSML1Vw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 14 Oct 2022 20:10:09 -0500
Message-ID: <CAH2r5mviA8iSYFturw3XHwiSyY9dxKvWHzwKU9ACyU_HY_OVoQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] minor coverity fix for unitialized MBZ ACL fields
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Paulo Alcantara <pc@cjr.nz>
Content-Type: multipart/mixed; boundary="00000000000003665e05eb086866"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000003665e05eb086866
Content-Type: text/plain; charset="UTF-8"

Add another two places that coverity pointed out (in cifs_open and
_cifsFileInfo_put) with similar issue. trivial fix.


On Fri, Oct 14, 2022 at 7:26 PM Steve French <smfrench@gmail.com> wrote:
>
> ---------- Forwarded message ---------
> From: Steve French <smfrench@gmail.com>
> Date: Fri, Oct 14, 2022 at 7:25 PM
> Subject: Re: [PATCH][SMB3 client] minor coverity fix for unitialized
> MBZ ACL fields
> To: CIFS <linux-cifs@vger.kernel.org>
> Cc: Paulo Alcantara <pc@cjr.nz>
>
>
> And one more similar one (although probably more minor)
>
>     cifs: lease key is uninitialized in smb1 paths
>
>     It is cleaner to set lease key to zero in the places where leases are not
>     supported (smb1 can not return lease keys so the field was uninitialized).
>
>     Addresses-Coverity: 1513994 ("Uninitialized scalar variable")
>
> See attached.
>
>
> On Fri, Oct 14, 2022 at 6:57 PM Steve French <smfrench@gmail.com> wrote:
> >
> > smb3: must initialize two ACL struct fields to zero
> >
> > Coverity spotted that we were not initalizing Stbz1 and Stbz2 to
> > zero in create_sd_buf.
> >
> > Addresses-Coverity: 1513848 ("Uninitialized scalar variable")
> >
> > See attached
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--00000000000003665e05eb086866
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-lease-key-is-uninitialized-in-two-additional-fu.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-lease-key-is-uninitialized-in-two-additional-fu.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l9981vyg0>
X-Attachment-Id: f_l9981vyg0

RnJvbSA2NWQ1MWNlMjlhODU0YzkwOTE2NDljOGUwMDc2ZDAwN2YyNjkzMDlkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMTQgT2N0IDIwMjIgMjA6MDA6MzIgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBsZWFzZSBrZXkgaXMgdW5pbml0aWFsaXplZCBpbiB0d28gYWRkaXRpb25hbCBmdW5jdGlv
bnMKIHdoZW4gc21iMQoKY2lmc19vcGVuIGFuZCBfY2lmc0ZpbGVJbmZvX3B1dCBhbHNvIGVuZCB1
cCB3aXRoIGxlYXNlX2tleSB1bmluaXRpYWxpemVkCmluIHNtYjEgbW91bnRzLiAgSXQgaXMgY2xl
YW5lciB0byBzZXQgbGVhc2Uga2V5IHRvIHplcm8gaW4gdGhlc2UKcGxhY2VzIHdoZXJlIGxlYXNl
cyBhcmUgbm90IHN1cHBvcnRlZCAoc21iMSBjYW4gbm90IHJldHVybiBsZWFzZSBrZXlzCnNvIHRo
ZSBmaWVsZCB3YXMgdW5pbml0aWFsaXplZCkuCgpBZGRyZXNzZXMtQ292ZXJpdHk6IDE1MTQyMDcg
KCJVbmluaXRpYWxpemVkIHNjYWxhciB2YXJpYWJsZSIpCkFkZHJlc3Nlcy1Db3Zlcml0eTogMTUx
NDMzMSAoIlVuaW5pdGlhbGl6ZWQgc2NhbGFyIHZhcmlhYmxlIikKUmV2aWV3ZWQtYnk6IFBhdWxv
IEFsY2FudGFyYSAoU1VTRSkgPHBjQGNqci5uej4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNo
IDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvZmlsZS5jIHwgNCArKy0tCiAx
IGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2ZzL2NpZnMvZmlsZS5jIGIvZnMvY2lmcy9maWxlLmMKaW5kZXggZGNlYzE2OTAzMTJiLi5m
NmZmZWU1MTRjMzQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvZmlsZS5jCisrKyBiL2ZzL2NpZnMvZmls
ZS5jCkBAIC00ODksNyArNDg5LDcgQEAgdm9pZCBfY2lmc0ZpbGVJbmZvX3B1dChzdHJ1Y3QgY2lm
c0ZpbGVJbmZvICpjaWZzX2ZpbGUsCiAJc3RydWN0IGNpZnNJbm9kZUluZm8gKmNpZnNpID0gQ0lG
U19JKGlub2RlKTsKIAlzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiID0gaW5vZGUtPmlfc2I7CiAJc3Ry
dWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiA9IENJRlNfU0Ioc2IpOwotCXN0cnVjdCBjaWZzX2Zp
ZCBmaWQ7CisJc3RydWN0IGNpZnNfZmlkIGZpZCA9IHt9OwogCXN0cnVjdCBjaWZzX3BlbmRpbmdf
b3BlbiBvcGVuOwogCWJvb2wgb3Bsb2NrX2JyZWFrX2NhbmNlbGxlZDsKIApAQCAtNTcxLDcgKzU3
MSw3IEBAIGludCBjaWZzX29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZp
bGUpCiAJdm9pZCAqcGFnZTsKIAljb25zdCBjaGFyICpmdWxsX3BhdGg7CiAJYm9vbCBwb3NpeF9v
cGVuX29rID0gZmFsc2U7Ci0Jc3RydWN0IGNpZnNfZmlkIGZpZDsKKwlzdHJ1Y3QgY2lmc19maWQg
ZmlkID0ge307CiAJc3RydWN0IGNpZnNfcGVuZGluZ19vcGVuIG9wZW47CiAJc3RydWN0IGNpZnNf
b3Blbl9pbmZvX2RhdGEgZGF0YSA9IHt9OwogCi0tIAoyLjM0LjEKCg==
--00000000000003665e05eb086866--
