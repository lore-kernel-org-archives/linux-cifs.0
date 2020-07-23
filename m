Return-Path: <SRS0=laBL=BC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F95FC433DF
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 19:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A7022086A
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jul 2020 19:55:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bEgqr0yI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725979AbgGWTzY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Jul 2020 15:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgGWTzX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Jul 2020 15:55:23 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E645C0619DC
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2020 12:55:23 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id i18so5365220ilk.10
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2020 12:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=au/KI04BzEMMzHNo8EdTR2muZRy1qvYooaiEGXtDifI=;
        b=bEgqr0yIqTDgqZY1HwSOt4Q27ebAuKSpiPn/rh6rfSDA8n2o4XPTiunqYIp8jzoC1w
         NtsevFdmusUNebgVitEhG1fjqiXN785HVu5slRqfB8j3+Yts++kf1ErhW3/sxkylX/Dg
         5xH5o/r3nlDnhoT0sylaXWJu1H1bZu51xQ8R9nm/CE5X0f+iUh7toyOEGRWX4tjL8wos
         vJwIplIhP9LKoW+GDSSl4QfxaAw+0GV8J8hQtJ/wVgabfb6D/o/SC0pR5E2Udcst6j8R
         pNUgtSmVOnldXYBwZUOROd9k1BQr3YJUZZhIjNmb34vYALFBGb8nBZdtfDHm7e1FVLrs
         mRHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=au/KI04BzEMMzHNo8EdTR2muZRy1qvYooaiEGXtDifI=;
        b=o4ttxyQ4R24nLQVwA/Ao2/GhtdyzChjdjZc0TXAPlrRzYmH3sfJCJAq+J/M29ozwZh
         uPPgwL4Id3An/ucAbycy9k+pJjEUOCgMAlHnjHIet+2SDoEJ8ZfyiJpOIhZb6N3YNe1b
         SGxtm4kyLtgeUpCZSEKSX2xEcfxk4+NHZVknZs4T5ezlTkTOxSjpucTXTP78U6WpTH4v
         F42nTyOVezSCRmBY7/7zJ1OKbVtqoHj6hPszcYom39YZDuKGvISgJ3Dqait+bYBNFuaC
         dus5m7bXH9yULVnguzWVyRFR+4azr60Pf/S13/9AWmJMuAp9hhyQpzJn40v+0btXeRNi
         S2oQ==
X-Gm-Message-State: AOAM532MuD0dzYizxw0liWB6FcaQ1mFjpxgD3tJJOfDimzZUEvBt/jQ5
        u7bTe2VSPXxqLeEkYa2Ac3o1y/wqgRio71Nn+XkeuNKM
X-Google-Smtp-Source: ABdhPJzs4PbRaCPRcgfRPZBeio1quZo1MWjzIOpdEAl/6LXYkZpdfPCUDYVX8KoXGuGwA5IRjBteBXJz3W8L2ChvrJI=
X-Received: by 2002:a92:7309:: with SMTP id o9mr6235220ilc.5.1595534121360;
 Thu, 23 Jul 2020 12:55:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAD737DGhAiRUb6WZz_RQ6GwfXwH3CFB_5iOmzvnJwSPoncXdLg@mail.gmail.com>
 <d8dbaf42-0f81-f25e-ea47-28b29c44fcd1@huawei.com>
In-Reply-To: <d8dbaf42-0f81-f25e-ea47-28b29c44fcd1@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 23 Jul 2020 14:55:10 -0500
Message-ID: <CAH2r5mtmuCH5offu-rv1-Kvf_oiQYmHx1rTONe2mEW5JgbXcdQ@mail.gmail.com>
Subject: Re: PROBLEM: mv command fails: "File exists" on cifs mount on kernel>=5.7.8
To:     "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
Cc:     Patrick Fernie <patrick.fernie@gmail.com>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="00000000000088060a05ab213c67"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000088060a05ab213c67
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

patch reverted


On Tue, Jul 21, 2020 at 8:52 AM zhangxiaoxu (A) <zhangxiaoxu5@huawei.com> w=
rote:
>
> Thanks for your report.
>
> Since commit 9ffad9263b46 ("cifs: Fix the target file was deleted
> when rename failed.") want to fix the problem when rename(file1, file2)
> with file2 exist, the server return -EACESS, then cifs client will
> delete the file2 and rename it again, but 2nd rename on server also
> return -EACESS, then the file2 was deleted.
>
> It can be reproduce by xfstests generic/035.
> When 't_rename_overwrite file1 file2':
>    open(file2)
>    rename(file1, file2)
>    fstat(file2).st_nlink should be 0.
>
> The solution on commit 9ffad9263b46 ("cifs: Fix the target file was
> deleted when rename failed.") was wrong. we should revert it.
>
> The root cause of the file2 deleted maybe the file2 was opened
> when rename(file1, file2), I will re-debug it.
>
> =E5=9C=A8 2020/7/21 1:09, Patrick Fernie =E5=86=99=E9=81=93:
> > # One line summary of the problem:
> >
> > mv command fails: "File exists" on cifs mount on kernel>=3D5.7.8
> >
> > # Full description of the problem/report:
> >
> > Since v5.7.8 (v5.4.51 for -lts), there appears to be a regression with
> > cifs mounts; mv commands fail with a "File exists" when attempting to
> > overwrite a file. Similarly, rsync commands which create a temporary
> > file during transfer and then attempt to move it into place after
> > copying fail ("File Exists (17)"). I believe this is related to this
> > commit: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.gi=
t/commit/fs/cifs/inode.c?id=3D9ffad9263b467efd8f8dc7ae1941a0a655a2bab2
> >
> > The mount in question is from a Drobo FS NAS device, and is forced to
> > SMB1 (`vers=3D1.0` specified).
> >
> > Running v5.7.7 or 5.4.50 does not exhibit this behavior, behavior was
> > confirmed on 5.7.8, 5.7.9, 5.4.51 and 5.4.52.
> >
> > These users appear to be experiencing the same issue:
> > 1) https://serverfault.com/questions/1025734/cifs-automounts-suddenly-s=
topped-working
> > 2) https://unix.stackexchange.com/questions/599281/cifs-mount-is-return=
ing-errors-when-operating-on-remote-files-file-exists-inte
> >
> > # Most recent kernel version which did not have the bug:
> >
> > 5.7.7 / 5.4.50
> >
> > # A small shell script or example program which triggers the problem
> > (if possible):
> >
> > [vagrant@archlinux ~]$ uname -a
> > Linux archlinux 5.7.9-arch1-1 #1 SMP PREEMPT Thu, 16 Jul 2020 19:34:49
> > +0000 x86_64 GNU/Linux
> > # Same behavior seen on Linux archlinux 5.4.52-1-lts #1 SMP Thu, 16
> > Jul 2020 19:35:06 +0000 x86_64 GNU/Linux
> > [vagrant@archlinux ~]$ cd /mnt/drobo/Share/cifs-test/
> > [vagrant@archlinux cifs-test]$ touch a b
> > [vagrant@archlinux cifs-test]$ mv a b
> > mv: cannot move 'a' to 'b': File exists
> > [vagrant@archlinux cifs-test]$ mkdir -p /tmp/sync_dir
> > [vagrant@archlinux cifs-test]$ touch /tmp/sync_dir/foo
> > [vagrant@archlinux cifs-test]$ rsync -rap /tmp/sync_dir .
> > [vagrant@archlinux cifs-test]$ touch /tmp/sync_dir/foo
> > [vagrant@archlinux cifs-test]$ rsync -rap /tmp/sync_dir .
> > rsync: [receiver] rename
> > "/mnt/drobo/Share/cifs-test/sync_dir/.foo.FQiit5" -> "sync_dir/foo":
> > File exists (17)
> > rsync error: some files/attrs were not transferred (see previous
> > errors) (code 23) at main.c(1287) [sender=3D3.2.2]
> >
> > ## Behavior as expected on older kernel:
> >
> > [vagrant@archlinux ~]$ uname -a
> > Linux archlinux 5.7.7-arch1-1 #1 SMP PREEMPT Wed, 01 Jul 2020 14:53:16
> > +0000 x86_64 GNU/Linux
> > # Same behavior seen on Linux archlinux 5.4.50-1-lts #1 SMP Wed, 01
> > Jul 2020 14:53:03 +0000 x86_64 GNU/Linux
> > [vagrant@archlinux ~]$ cd /mnt/drobo/Share/cifs-test/
> > [vagrant@archlinux cifs-test]$ touch a b
> > [vagrant@archlinux cifs-test]$ mv a b
> > [vagrant@archlinux cifs-test]$ mkdir -p /tmp/sync_dir
> > [vagrant@archlinux cifs-test]$ touch /tmp/sync_dir/foo
> > [vagrant@archlinux cifs-test]$ rsync -rap /tmp/sync_dir .
> > [vagrant@archlinux cifs-test]$ touch /tmp/sync_dir/foo
> > [vagrant@archlinux cifs-test]$ rsync -rap /tmp/sync_dir .
> > [vagrant@archlinux cifs-test]$
> >
> > # Environment:
> >
> > Arch Linux
> >
> > CIFS mount (vers=3D1.0) from Drobo FS NAS device
> >
> > CIFS share mount information:
> >
> > systemd-1 on /mnt/drobo/Share type autofs
> > (rw,relatime,fd=3D44,pgrp=3D1,timeout=3D0,minproto=3D5,maxproto=3D5,dir=
ect,pipe_ino=3D12139)
> > //10.76.9.11/Share on /mnt/drobo/Share type cifs
> > (rw,relatime,vers=3D1.0,cache=3Dstrict,username=3DXXXXXXX,uid=3D0,nofor=
ceuid,gid=3D0,noforcegid,addr=3D10.76.9.11,file_mode=3D0775,dir_mode=3D0775=
,nocase,soft,nounix,serverino,mapposix,nobrl,noperm,rsize=3D61440,wsize=3D6=
5536,bsize=3D1048576,echo_interval=3D60,actimeo=3D1,x-systemd.automount)
> >
> > Regards,
> > Patrick Fernie
> >
> > .
> >
>


--=20
Thanks,

Steve

--00000000000088060a05ab213c67
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-Revert-cifs-Fix-the-target-file-was-deleted-when-ren.patch"
Content-Disposition: attachment; 
	filename="0001-Revert-cifs-Fix-the-target-file-was-deleted-when-ren.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kcz7sjcu0>
X-Attachment-Id: f_kcz7sjcu0

RnJvbSBmYTFmZDJkOGVlZjg5YmIxNjk2YzY0YjgxYTkxMWMxZjdhMTIyMjJkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMjMgSnVsIDIwMjAgMTQ6NDE6MjkgLTA1MDAKU3ViamVjdDogW1BBVENIXSBS
ZXZlcnQgImNpZnM6IEZpeCB0aGUgdGFyZ2V0IGZpbGUgd2FzIGRlbGV0ZWQgd2hlbiByZW5hbWUK
IGZhaWxlZC4iCgpUaGlzIHJldmVydHMgY29tbWl0IDlmZmFkOTI2M2I0NjdlZmQ4ZjhkYzdhZTE5
NDFhMGE2NTVhMmJhYjIuCgpVcG9uIGFkZGl0aW9uYWwgdGVzdGluZyB3aXRoIG9sZGVyIHNlcnZl
cnMsIGl0IHdhcyBmb3VuZCB0aGF0CnRoZSBvcmlnaW5hbCBjb21taXQgaW50cm9kdWNlZCBhIHJl
Z3Jlc3Npb24gd2hlbiB1c2luZyB0aGUgb2xkIFNNQjEKZGlhbGVjdCBhbmQgcnN5bmNpbmcgb3Zl
ciBhbiBleGlzdGluZyBmaWxlLgoKVGhlIHBhdGNoIHdpbGwgbmVlZCB0byBiZSByZXNwdW4gdG8g
YWRkcmVzcyB0aGlzLCBsaWtlbHkgaW5jbHVkaW5nCmEgbGFyZ2VyIHJlZmFjdG9yaW5nIG9mIHRo
ZSBTTUIxIGFuZCBTTUIzIHJlbmFtZSBjb2RlIHBhdGhzIHRvIG1ha2UKaXQgbGVzcyBjb25mdXNp
bmcgYW5kIGFsc28gdG8gYWRkcmVzcyBzb21lIGFkZGl0aW9uYWwgcmVuYW1lIGVycm9yCmNhc2Vz
IHRoYXQgU01CMyBtYXkgYmUgYWJsZSB0byB3b3JrYXJvdW5kLgoKU2lnbmVkLW9mZi1ieTogU3Rl
dmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgpSZXBvcnRlZC1ieTogUGF0cmljayBG
ZXJuaWUgPHBhdHJpY2suZmVybmllQGdtYWlsLmNvbT4KQ0M6IFN0YWJsZSA8c3RhYmxlQHZnZXIu
a2VybmVsLm9yZz4KQWNrZWQtYnk6IFBhdmVsIFNoaWxvdnNreSA8cHNoaWxvdkBtaWNyb3NvZnQu
Y29tPgpBY2tlZC1ieTogWmhhbmcgWGlhb3h1IDx6aGFuZ3hpYW94dTVAaHVhd2VpLmNvbT4KLS0t
CiBmcy9jaWZzL2lub2RlLmMgfCAxMCArKy0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNl
cnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvaW5vZGUuYyBi
L2ZzL2NpZnMvaW5vZGUuYwppbmRleCA0OWMzZWE4YWE4NDUuLmNlOTU4MDFlOWI2NiAxMDA2NDQK
LS0tIGEvZnMvY2lmcy9pbm9kZS5jCisrKyBiL2ZzL2NpZnMvaW5vZGUuYwpAQCAtMjA0NCw3ICsy
MDQ0LDYgQEAgY2lmc19yZW5hbWUyKHN0cnVjdCBpbm9kZSAqc291cmNlX2Rpciwgc3RydWN0IGRl
bnRyeSAqc291cmNlX2RlbnRyeSwKIAlGSUxFX1VOSVhfQkFTSUNfSU5GTyAqaW5mb19idWZfdGFy
Z2V0OwogCXVuc2lnbmVkIGludCB4aWQ7CiAJaW50IHJjLCB0bXByYzsKLQlib29sIG5ld190YXJn
ZXQgPSBkX3JlYWxseV9pc19uZWdhdGl2ZSh0YXJnZXRfZGVudHJ5KTsKIAogCWlmIChmbGFncyAm
IH5SRU5BTUVfTk9SRVBMQUNFKQogCQlyZXR1cm4gLUVJTlZBTDsKQEAgLTIxMjEsMTMgKzIxMjAs
OCBAQCBjaWZzX3JlbmFtZTIoc3RydWN0IGlub2RlICpzb3VyY2VfZGlyLCBzdHJ1Y3QgZGVudHJ5
ICpzb3VyY2VfZGVudHJ5LAogCSAqLwogCiB1bmxpbmtfdGFyZ2V0OgotCS8qCi0JICogSWYgdGhl
IHRhcmdldCBkZW50cnkgd2FzIGNyZWF0ZWQgZHVyaW5nIHRoZSByZW5hbWUsIHRyeQotCSAqIHVu
bGlua2luZyBpdCBpZiBpdCdzIG5vdCBuZWdhdGl2ZQotCSAqLwotCWlmIChuZXdfdGFyZ2V0ICYm
Ci0JICAgIGRfcmVhbGx5X2lzX3Bvc2l0aXZlKHRhcmdldF9kZW50cnkpICYmCi0JICAgIChyYyA9
PSAtRUFDQ0VTIHx8IHJjID09IC1FRVhJU1QpKSB7CisJLyogVHJ5IHVubGlua2luZyB0aGUgdGFy
Z2V0IGRlbnRyeSBpZiBpdCdzIG5vdCBuZWdhdGl2ZSAqLworCWlmIChkX3JlYWxseV9pc19wb3Np
dGl2ZSh0YXJnZXRfZGVudHJ5KSAmJiAocmMgPT0gLUVBQ0NFUyB8fCByYyA9PSAtRUVYSVNUKSkg
ewogCQlpZiAoZF9pc19kaXIodGFyZ2V0X2RlbnRyeSkpCiAJCQl0bXByYyA9IGNpZnNfcm1kaXIo
dGFyZ2V0X2RpciwgdGFyZ2V0X2RlbnRyeSk7CiAJCWVsc2UKLS0gCjIuMjUuMQoK
--00000000000088060a05ab213c67--
