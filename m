Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7982FC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 07:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 466C561186
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 07:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhKJH7i (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Nov 2021 02:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhKJH7i (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Nov 2021 02:59:38 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9F9C061764
        for <linux-cifs@vger.kernel.org>; Tue,  9 Nov 2021 23:56:50 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id l22so3947495lfg.7
        for <linux-cifs@vger.kernel.org>; Tue, 09 Nov 2021 23:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8v8M4GWe4ilnNFGwJLxpFJsqYbBLy6wr/ZopmGKfHmY=;
        b=OZDDNRl7C5u/5HAJD4ojV08mBn+8j3eqKBn6RMnyhgua6Crp6IauBneIkAWL84QqN7
         ipf4abTfO9jkQvXlQ2BJZIStZzkRTDdLs7ORaYKMDKVozKEUE3Yc6ZWFDmZapqMxJvlJ
         Wsf4FfYRbvoBPVLLsD7WMUuUqdOmvLXaJL2vFeWkSD1J+1EKuBmaRuCsGVdDfkhn/HZ3
         pzPl/6UCZXVwqU3d4GDDYVguJ7ojv0SBH200nKHRkQG4ztoD/k4aPnk4GFcrA0nWQCfm
         rH021hsfhullET44vVei9iWaJHPBEgMDe0fa9TPu8yMQ/6ETNO6NCcCDqjhVyu1ndhTz
         xp1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8v8M4GWe4ilnNFGwJLxpFJsqYbBLy6wr/ZopmGKfHmY=;
        b=1O5h0CnFtmYZr9QHOrdc6TY0tRH+2vI3X3KDnfLnHpXLHD/UIm08ICb3bCQYB4kN33
         FEpmvyJkUZBzos5y1JuNmPVqK5bWSqMzYKCXoK2Eep7eY/GGLT0ZpnxBlqQ8nl1cJAb/
         TBu32bXiIz9yYtrN2mQ0QJe7nlXbbRSDk7rUX7AY191IXd+jTQxmY2EYlHfmh1tfQZVx
         pNnzdbSAJnq73vnSsMCxtX6wm+FfLhZTgjnQphIreuWlhrNiRf6rX5XOC0lHGvxvmZNj
         UpHgM3wxxDvB2bZQqQi8vpfspNHLDcqtQzdSuqXhe3K+xbohZ1FePkvxxtI2OYs9DJKF
         FzDQ==
X-Gm-Message-State: AOAM532vi1QM3QU3ufSYlcdRP+SWGxu93jybpjqi1O758gqAFhO3xf9l
        75nrpSxRRwIZx9v7hCgD2jWdw839iDanwoooWEA=
X-Google-Smtp-Source: ABdhPJxFTejXqUQP7YBgvxuqwPNtF7unxglVFVoTlCMycEk57lVi7d/8jZ7RbBsMRoDPtKBZPfMsoB4WNAsThZCrXUQ=
X-Received: by 2002:a19:770a:: with SMTP id s10mr13839782lfc.234.1636531008892;
 Tue, 09 Nov 2021 23:56:48 -0800 (PST)
MIME-Version: 1.0
References: <YYhI1bpioEOXnFYf@jeremy-acer> <YYhJ+8ehPFX1XDhv@jeremy-acer>
 <7abcce96-9293-cd47-780b-cdc971da07e5@gmail.com> <YYhXjG46ZZ1tqpxJ@jeremy-acer>
 <5c25c989-1e58-fb23-810f-a431024da11e@gmail.com> <YYiCAcxxnIbHz4xv@jeremy-acer>
 <cd649ed2-60d3-72e3-e09a-9f0074af99cc@gmail.com> <YYlUgc6UOyKfZr7d@jeremy-acer>
 <CAH2r5muWLJu_Yhx1pv0rCaTRPqeEd_8X8DP2cipUVaMekU9xFg@mail.gmail.com>
 <eadd8209-7dcf-30fe-2c8e-cc0fd7c823a1@gmail.com> <YYsYKvyevyXjHgku@jeremy-acer>
In-Reply-To: <YYsYKvyevyXjHgku@jeremy-acer>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 10 Nov 2021 01:56:37 -0600
Message-ID: <CAH2r5mtNxiw8gOTPJe0GopBnkkMspHvsMD+0_K2+kc2VbrgdBw@mail.gmail.com>
Subject: Re: Permission denied when chainbuilding packages with mock
To:     Jeremy Allison <jra@samba.org>
Cc:     Julian Sikorski <belegdol@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000733db905d06a91b8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000733db905d06a91b8
Content-Type: text/plain; charset="UTF-8"

Fix for the kernel client attached


On Tue, Nov 9, 2021 at 6:54 PM Jeremy Allison <jra@samba.org> wrote:
>
> On Tue, Nov 09, 2021 at 10:26:59AM +0100, Julian Sikorski wrote:
> >Am 09.11.21 um 09:10 schrieb Steve French:
> >>Yes - here is a trivial reproducer (excuse the ugly sample cut-n-paste)
> >>
> >>#include <stdio.h>
> >>#include <stdlib.h>
> >>#include <unistd.h>
> >>#include <string.h>
> >>#include <fcntl.h>
> >>#include <sys/types.h>
> >>#include <sys/stat.h>
> >>
> >>int main(int argc, char *argv[]) {
> >>char *str = "Text to be added";
> >>int fd, ret, fsyncrc, fsyncr_rc, openrc, closerc, close2rc;
> >>
> >>fd = creat("test.txt", S_IWUSR | S_IRUSR);
> >>if (fd < 0) {
> >>perror("creat()");
> >>exit(1);
> >>}
> >>ret = write(fd, str, strlen(str));
> >>if (ret < 0) {
> >>perror("write()");
> >>exit(1);
> >>}
> >>openrc = open("test.txt", O_RDONLY);
> >>         if (openrc < 0) {
> >>                 perror("creat()");
> >>                 exit(1);
> >>         }
> >>fsyncr_rc = fsync(openrc);
> >>if (fsyncr_rc < 0)
> >>perror("fsync()");
> >>fsyncrc = fsync(fd);
> >>closerc = close(fd);
> >>close2rc = close(openrc);
> >>printf("read fsync rc=%d, write fsync rc=%d, close rc=%d, RO close
> >>rc=%d\n", fsyncr_rc, fsyncrc, closerc, close2rc);
> >>}
> >>
> >
> >I can confirm this fails on my machine without nostrictsync:
> >
> >$ ./test
> >
> >fsync(): Permission denied
> >
> >read fsync rc=-1, write fsync rc=0, close rc=0, RO close rc=0
> >
> >and works with nostrictsync:
> >
> >$ ./test
> >
> >read fsync rc=0, write fsync rc=0, close rc=0, RO close rc=0
> >
> >So is the bug in the Linux kernel?
>
> Yes, it's in the kernel cifsfs module which is forwarding an SMB_FLUSH request
> (which the spec says must fail on a non-writable handle) to
> a handle opened as non-writable. Steve hopefully will fix :-).



-- 
Thanks,

Steve

--000000000000733db905d06a91b8
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-do-not-error-on-fsync-when-readonly.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-do-not-error-on-fsync-when-readonly.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kvt8al0m0>
X-Attachment-Id: f_kvt8al0m0

RnJvbSBkYTkzOTg1N2NkYjZlMjVkMGM5Njc1NDdmMTEyZWVhMDdkODQ3ODcwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTAgTm92IDIwMjEgMDE6NDc6NDggLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBkbyBub3QgZXJyb3Igb24gZnN5bmMgd2hlbiByZWFkb25seQoKTGludXggYWxsb3dzIGRv
aW5nIGEgZmx1c2gvZnN5bmMgb24gYSBmaWxlIG9wZW4gZm9yIHJlYWQtb25seSwKYnV0IHRoZSBw
cm90b2NvbCBkb2VzIG5vdCBhbGxvdyB0aGF0LiAgSWYgdGhlIGZpbGUgcGFzc2VkIGluCm9uIHRo
ZSBmbHVzaCBpcyByZWFkLW9ubHkgdHJ5IHRvIGZpbmQgYSB3cml0ZWFibGUgaGFuZGxlIGZvcgp0
aGUgc2FtZSBpbm9kZSwgaWYgdGhhdCBpcyBub3QgcG9zc2libGUgc2tpcCBzZW5kaW5nIHRoZQpm
c3luYyBjYWxsIHRvIHRoZSBzZXJ2ZXIgdG8gYXZvaWQgYnJlYWtpbmcgdGhlIGFwcHMuCgpSZXBv
cnRlZC1ieTogSnVsaWFuIFNpa29yc2tpIDxiZWxlZ2RvbEBnbWFpbC5jb20+ClN1Z2dlc3RlZC1i
eTogSmVyZW15IEFsbGlzb24gPGpyYUBzYW1iYS5vcmc+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZy
ZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2ZpbGUuYyB8IDM1ICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMjkgaW5z
ZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZpbGUuYyBi
L2ZzL2NpZnMvZmlsZS5jCmluZGV4IDFiODU1ZmNiMTc5ZS4uZmVkMzBiYTU2ZDVmIDEwMDY0NAot
LS0gYS9mcy9jaWZzL2ZpbGUuYworKysgYi9mcy9jaWZzL2ZpbGUuYwpAQCAtMjY5MiwxMiArMjY5
MiwyMyBAQCBpbnQgY2lmc19zdHJpY3RfZnN5bmMoc3RydWN0IGZpbGUgKmZpbGUsIGxvZmZfdCBz
dGFydCwgbG9mZl90IGVuZCwKIAl0Y29uID0gdGxpbmtfdGNvbihzbWJmaWxlLT50bGluayk7CiAJ
aWYgKCEoY2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgJiBDSUZTX01PVU5UX05PU1NZTkMpKSB7CiAJ
CXNlcnZlciA9IHRjb24tPnNlcy0+c2VydmVyOwotCQlpZiAoc2VydmVyLT5vcHMtPmZsdXNoKQot
CQkJcmMgPSBzZXJ2ZXItPm9wcy0+Zmx1c2goeGlkLCB0Y29uLCAmc21iZmlsZS0+ZmlkKTsKLQkJ
ZWxzZQorCQlpZiAoc2VydmVyLT5vcHMtPmZsdXNoID09IE5VTEwpIHsKIAkJCXJjID0gLUVOT1NZ
UzsKKwkJCWdvdG8gc3RyaWN0X2ZzeW5jX2V4aXQ7CisJCX0KKworCQlpZiAoKE9QRU5fRk1PREUo
c21iZmlsZS0+Zl9mbGFncykgJiBGTU9ERV9XUklURSkgPT0gMCkgeworCQkJc21iZmlsZSA9IGZp
bmRfd3JpdGFibGVfZmlsZShDSUZTX0koaW5vZGUpLCBGSU5EX1dSX0FOWSk7CisJCQlpZiAoc21i
ZmlsZSkgeworCQkJCXJjID0gc2VydmVyLT5vcHMtPmZsdXNoKHhpZCwgdGNvbiwgJnNtYmZpbGUt
PmZpZCk7CisJCQkJY2lmc0ZpbGVJbmZvX3B1dChzbWJmaWxlKTsKKwkJCX0gZWxzZQorCQkJCWNp
ZnNfZGJnKEZZSSwgImlnbm9yZSBmc3luYyBmb3IgZmlsZSBub3Qgb3BlbiBmb3Igd3JpdGVcbiIp
OworCQl9IGVsc2UKKwkJCXJjID0gc2VydmVyLT5vcHMtPmZsdXNoKHhpZCwgdGNvbiwgJnNtYmZp
bGUtPmZpZCk7CiAJfQogCitzdHJpY3RfZnN5bmNfZXhpdDoKIAlmcmVlX3hpZCh4aWQpOwogCXJl
dHVybiByYzsKIH0KQEAgLTI3MDksNiArMjcyMCw3IEBAIGludCBjaWZzX2ZzeW5jKHN0cnVjdCBm
aWxlICpmaWxlLCBsb2ZmX3Qgc3RhcnQsIGxvZmZfdCBlbmQsIGludCBkYXRhc3luYykKIAlzdHJ1
Y3QgY2lmc190Y29uICp0Y29uOwogCXN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcjsKIAlz
dHJ1Y3QgY2lmc0ZpbGVJbmZvICpzbWJmaWxlID0gZmlsZS0+cHJpdmF0ZV9kYXRhOworCXN0cnVj
dCBpbm9kZSAqaW5vZGUgPSBmaWxlX2lub2RlKGZpbGUpOwogCXN0cnVjdCBjaWZzX3NiX2luZm8g
KmNpZnNfc2IgPSBDSUZTX0ZJTEVfU0IoZmlsZSk7CiAKIAlyYyA9IGZpbGVfd3JpdGVfYW5kX3dh
aXRfcmFuZ2UoZmlsZSwgc3RhcnQsIGVuZCk7CkBAIC0yNzI1LDEyICsyNzM3LDIzIEBAIGludCBj
aWZzX2ZzeW5jKHN0cnVjdCBmaWxlICpmaWxlLCBsb2ZmX3Qgc3RhcnQsIGxvZmZfdCBlbmQsIGlu
dCBkYXRhc3luYykKIAl0Y29uID0gdGxpbmtfdGNvbihzbWJmaWxlLT50bGluayk7CiAJaWYgKCEo
Y2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgJiBDSUZTX01PVU5UX05PU1NZTkMpKSB7CiAJCXNlcnZl
ciA9IHRjb24tPnNlcy0+c2VydmVyOwotCQlpZiAoc2VydmVyLT5vcHMtPmZsdXNoKQotCQkJcmMg
PSBzZXJ2ZXItPm9wcy0+Zmx1c2goeGlkLCB0Y29uLCAmc21iZmlsZS0+ZmlkKTsKLQkJZWxzZQor
CQlpZiAoc2VydmVyLT5vcHMtPmZsdXNoID09IE5VTEwpIHsKIAkJCXJjID0gLUVOT1NZUzsKKwkJ
CWdvdG8gZnN5bmNfZXhpdDsKKwkJfQorCisJCWlmICgoT1BFTl9GTU9ERShzbWJmaWxlLT5mX2Zs
YWdzKSAmIEZNT0RFX1dSSVRFKSA9PSAwKSB7CisJCQlzbWJmaWxlID0gZmluZF93cml0YWJsZV9m
aWxlKENJRlNfSShpbm9kZSksIEZJTkRfV1JfQU5ZKTsKKwkJCWlmIChzbWJmaWxlKSB7CisJCQkJ
cmMgPSBzZXJ2ZXItPm9wcy0+Zmx1c2goeGlkLCB0Y29uLCAmc21iZmlsZS0+ZmlkKTsKKwkJCQlj
aWZzRmlsZUluZm9fcHV0KHNtYmZpbGUpOworCQkJfSBlbHNlCisJCQkJY2lmc19kYmcoRllJLCAi
aWdub3JlIGZzeW5jIGZvciBmaWxlIG5vdCBvcGVuIGZvciB3cml0ZVxuIik7CisJCX0gZWxzZQor
CQkJcmMgPSBzZXJ2ZXItPm9wcy0+Zmx1c2goeGlkLCB0Y29uLCAmc21iZmlsZS0+ZmlkKTsKIAl9
CiAKK2ZzeW5jX2V4aXQ6CiAJZnJlZV94aWQoeGlkKTsKIAlyZXR1cm4gcmM7CiB9Ci0tIAoyLjMy
LjAKCg==
--000000000000733db905d06a91b8--
