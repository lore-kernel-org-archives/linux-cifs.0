Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C79CDC32771
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Aug 2022 19:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350980AbiHSTYs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Aug 2022 15:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349705AbiHSTYs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Aug 2022 15:24:48 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94DD61DA8
        for <linux-cifs@vger.kernel.org>; Fri, 19 Aug 2022 12:24:45 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id l7so5166778vsc.0
        for <linux-cifs@vger.kernel.org>; Fri, 19 Aug 2022 12:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ZYB34bQ8bBdfKcPSlKCucm8R3g66NpEs53FSL4Nbf3c=;
        b=aiMp5N0/qTTmd30H3ChUItixGooFJrBlAaSsYRYSN4qzW363FVw3WzL3fX0BSdiWaV
         GAG6sZtWo4rsMk32nwBx6UPMwZRMNCEkrMohbBLEC/6AFWbDRFNXMrKf2uEBVzxYEZoY
         JgBnQQa7zaj0g0z5erJsHvNVPIr1w01rO83WN7qmDAouevl4GsCX7hWxwS6bNCU4/x3J
         Q+pXIw3m1or8c5iX0TRqzBdFC6hadPT2y1kp+kI5pYWEIpQ5kX3II+lS9RZHqeSJs5gy
         NwjNi8AjVcFGB/1uWgsFMupaWQsuPlloLaDvxorjdFOlvh2XnELmBCp8a4kf6QbtvDIf
         blDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ZYB34bQ8bBdfKcPSlKCucm8R3g66NpEs53FSL4Nbf3c=;
        b=MTKxDjO1w5O+8S02uk0ZbUK7L8CZ+sFKUd5NSwnYAuLKQIKdqU76U+l92wVloLFiNG
         Ns4aSK9BROZ2oXCrEOSzPL14uJeQ+IghtCCNPmRLLRvif4OvyjK3S37g+fcK4Kx1yhF/
         YnzVPrH1wDBA9KcdD8STUhsFzhWkOcTb4CsnFwuFNSStpKk+96NcgnRPdbnj3kHTewsr
         5pGffEO1IX07sSMlV4Bu7CVwQipbQVvYKGq3Wpm4UBOKZ4+bIDdP7Vhz/69UEBJroi/Z
         +Uef+Dd5Nq1aLygdHG05B9qaUfI0Iq8m2CC9UqI2VuUGlEPw05nGJ9kQYzsHt8lVvqAR
         wLOg==
X-Gm-Message-State: ACgBeo1xIWh5710F0QuJtlcbyj/1hRGvTflOoWh8n+wnZSnco0GA76V/
        ZkyhtwKEdzF381McugbA/T7P+Ug0DenbupVpZ7vARWkxLlk=
X-Google-Smtp-Source: AA6agR6A+wxBuVGtZDkZUnsmIHMCO5z8RoZZlmpaXT7GsyK3RNQiZK7mGCQdrBhdukAC9iGAuSjtX0cvXneUUEPjXuw=
X-Received: by 2002:a05:6102:1626:b0:390:2616:663e with SMTP id
 cu38-20020a056102162600b003902616663emr1407069vsb.6.1660937084482; Fri, 19
 Aug 2022 12:24:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvShnJidFDQkdULTDQFteSKimcphT_GGfVb0zXx9PkNcQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvShnJidFDQkdULTDQFteSKimcphT_GGfVb0zXx9PkNcQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 19 Aug 2022 14:24:33 -0500
Message-ID: <CAH2r5msA0T5ABYT_aKWqWbmDZKQaL9pJ6ehNCMcRPuNaLKzRPA@mail.gmail.com>
Subject: Re: missing update to deferred_close_scheduled field
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     rohiths msft <rohiths.msft@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000ea4db905e69d0c44"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000ea4db905e69d0c44
Content-Type: text/plain; charset="UTF-8"

forgot to attach the correct version of the patch (had a cut-n-paste
error on one line)


On Fri, Aug 19, 2022 at 11:48 AM Steve French <smfrench@gmail.com> wrote:
>
> > we are missing a line like this:
> >
> >        cfile->deferred_close_scheduled = false;
> >
> > in cifs_open here:
> >
> >         /* Get the cached handle as SMB2 close is deferred */
> >         rc = cifs_get_readable_path(tcon, full_path, &cfile);
> >         if (rc == 0) {
> >                 if (file->f_flags == cfile->f_flags) {
> >                         file->private_data = cfile;
> >                         spin_lock(&CIFS_I(inode)->deferred_lock);
> >                         cifs_del_deferred_close(cfile);
> >                         spin_unlock(&CIFS_I(inode)->deferred_lock);
> >                         goto use_cache;
>
> So move set of deferred_close_scheduled = false into cifs_del_deferred_close
>
> See attached
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--000000000000ea4db905e69d0c44
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-missing-update-to-whether-a-close-is-deferred-i.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-missing-update-to-whether-a-close-is-deferred-i.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l70v1pdn0>
X-Attachment-Id: f_l70v1pdn0

RnJvbSAyZTU4MWI3N2M3MzlkZGQ2YWY3Y2MzNzkxMTE3MzBjZjE2MDQyNWJlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMTkgQXVnIDIwMjIgMTE6MzM6NDQgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBtaXNzaW5nIHVwZGF0ZSB0byB3aGV0aGVyIGEgY2xvc2UgaXMgZGVmZXJyZWQgaW4gYQog
cmVvcGVuIHBhdGgKCldoZW4gZGVsZXRpbmcgYSBmaWxlIGhhbmRsZSBmcm9tIHRoZSBkZWZlcnJl
ZCBjbG9zZSBsaXN0IHdlCndlcmUgbWlzc2luZyB1cGRhdGUgdG8gY2ZpbGUtPmRlZmVycmVkX2Ns
b3NlX3NjaGVkdWxlZAoKUmV2aWV3ZWQtYnk6IFNoeWFtIFByYXNhZCBOIDxzcHJhc2FkQG1pY3Jv
c29mdC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0
LmNvbT4KLS0tCiBmcy9jaWZzL2ZpbGUuYyB8IDEgLQogZnMvY2lmcy9taXNjLmMgfCAxICsKIDIg
ZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQg
YS9mcy9jaWZzL2ZpbGUuYyBiL2ZzL2NpZnMvZmlsZS5jCmluZGV4IGZhNzM4YWRjMDMxZi4uMTJi
ZjA0MTRkYzg0IDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZpbGUuYworKysgYi9mcy9jaWZzL2ZpbGUu
YwpAQCAtOTMwLDcgKzkzMCw2IEBAIHZvaWQgc21iMl9kZWZlcnJlZF93b3JrX2Nsb3NlKHN0cnVj
dCB3b3JrX3N0cnVjdCAqd29yaykKIAogCXNwaW5fbG9jaygmQ0lGU19JKGRfaW5vZGUoY2ZpbGUt
PmRlbnRyeSkpLT5kZWZlcnJlZF9sb2NrKTsKIAljaWZzX2RlbF9kZWZlcnJlZF9jbG9zZShjZmls
ZSk7Ci0JY2ZpbGUtPmRlZmVycmVkX2Nsb3NlX3NjaGVkdWxlZCA9IGZhbHNlOwogCXNwaW5fdW5s
b2NrKCZDSUZTX0koZF9pbm9kZShjZmlsZS0+ZGVudHJ5KSktPmRlZmVycmVkX2xvY2spOwogCV9j
aWZzRmlsZUluZm9fcHV0KGNmaWxlLCB0cnVlLCBmYWxzZSk7CiB9CmRpZmYgLS1naXQgYS9mcy9j
aWZzL21pc2MuYyBiL2ZzL2NpZnMvbWlzYy5jCmluZGV4IDg3ZjYwZjczNjczMS4uM2U5OWRkNDA4
NWViIDEwMDY0NAotLS0gYS9mcy9jaWZzL21pc2MuYworKysgYi9mcy9jaWZzL21pc2MuYwpAQCAt
NzE4LDYgKzcxOCw3IEBAIGNpZnNfZGVsX2RlZmVycmVkX2Nsb3NlKHN0cnVjdCBjaWZzRmlsZUlu
Zm8gKmNmaWxlKQogCWlzX2RlZmVycmVkID0gY2lmc19pc19kZWZlcnJlZF9jbG9zZShjZmlsZSwg
JmRjbG9zZSk7CiAJaWYgKCFpc19kZWZlcnJlZCkKIAkJcmV0dXJuOworCWNmaWxlLT5kZWZlcnJl
ZF9jbG9zZV9zY2hlZHVsZWQgPSBmYWxzZTsKIAlsaXN0X2RlbCgmZGNsb3NlLT5kbGlzdCk7CiAJ
a2ZyZWUoZGNsb3NlKTsKIH0KLS0gCjIuMzQuMQoK
--000000000000ea4db905e69d0c44--
