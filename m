Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD98C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Mar 2022 09:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343563AbiCOJzm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Mar 2022 05:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346869AbiCOJzl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Mar 2022 05:55:41 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E36ABED
        for <linux-cifs@vger.kernel.org>; Tue, 15 Mar 2022 02:54:29 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id v62so20171349vsv.1
        for <linux-cifs@vger.kernel.org>; Tue, 15 Mar 2022 02:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=29U2Y37ya/nYB6jU5h4WfAmZBLEXi35+S+4/hPc/D9U=;
        b=RCd2RuHGiL8/9nWR40w/PU5GbxMRWUGXctB74HXPvnzl8RB2n90sYwBDwxRq6JCd5o
         UmvkV9hZzCLn7jdyc7b6QnFYtFGqZvT7zCKoeipGjJuFTaMu52rkkSj6TmAU6EU8anHa
         S2NQYWljKGQJlBFG/leCSlriRyQybhw7HjwDqex1eow+jmDZbX1QvwMtcq6Zu6qnrR6X
         hYFL+L58y3hZ3q8mO72CoaegHB4zswv+LXblysdmysb3yCbE1xnWB9e0YUs+Uope7f8z
         yYVehy2IQ8UuM8BoDcPLejwg8H5kEcJe7uw3ete+0FKb6WHK3iHy4Lu2+HHZZODbxHBu
         kDng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=29U2Y37ya/nYB6jU5h4WfAmZBLEXi35+S+4/hPc/D9U=;
        b=Q1W32r8SRIPFbkoJ0iZNp+Xv/kws9qeD3zBYWjBAq05makI3Apncs3c4k2Uxfvayy/
         51ZOoqafipuBbaZI1zregzk7ik31b9zHmYJQ1VCm4IR5C5gKgwtLYKdRjynNaBB9qmKC
         cI3t/Z6lAD+RpEHZ6djSxlt+tmu7YnR/o2TLuHrGrK64QyCuQ4gtv/uuMgW02A5/lvHO
         S9YO5pj3ETK3pyQ/OzVdksLZsu00LS/XSfw2BRvUUkNlPXtZSIJYdQwe7uOpJwTQXFC1
         4AusvbdfRL7W2rxoya46eA8KYbsJxGYkI3oYTdaO+0zqNpNlATDmQgR9fqpn7eb5wJXx
         T46w==
X-Gm-Message-State: AOAM533Vv4UtjCEZ6KQTr/80EBZo0QcuyIHk6afA7Ye+AOojdDWLwp+r
        Sgj+SNM1Ahf7sGorR0/NXfOOp2XojMo0FlXdIYY369qiOHA=
X-Google-Smtp-Source: ABdhPJxgXXtFnYeQPp7bTrStj9bI5mMAvPwzky3MIBfnLhizc3gk4Jj4jW9Mun6BLHfuEP49n6WSj0iIISde8sbD1LQ=
X-Received: by 2002:a05:6102:40d:b0:322:a0f5:c8fe with SMTP id
 d13-20020a056102040d00b00322a0f5c8femr10073962vsq.40.1647338068111; Tue, 15
 Mar 2022 02:54:28 -0700 (PDT)
MIME-Version: 1.0
References: <2314914.1646986773@warthog.procyon.org.uk> <2315193.1646987135@warthog.procyon.org.uk>
 <CACdtm0Y_F7JjoqvC63+3CU0brETf+iEQ_UjMyx+WzhtwE1HGSw@mail.gmail.com>
In-Reply-To: <CACdtm0Y_F7JjoqvC63+3CU0brETf+iEQ_UjMyx+WzhtwE1HGSw@mail.gmail.com>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Tue, 15 Mar 2022 15:24:17 +0530
Message-ID: <CACdtm0YuO+t46wQf9pKu9-U-=vguvwpEu6VXrkXV3JDocFM2qg@mail.gmail.com>
Subject: Re: cifs conversion to netfslib
To:     David Howells <dhowells@redhat.com>
Cc:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>, jlayton@kernel.org,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi David,

I noticed 2 other issues while running xfstests.

Noticed kernel OOPS during test generic/286:
folio_test_writeback returned false which means PG_writeback flag has
been cleared. I am not sure whether head page has PG_writeback flag
set initially? Can you please confirm.

[ 2275.941096] CIFS: bad 2000 @64f0000 page 64f0 64f1
[ 2275.945785] ------------[ cut here ]------------
[ 2275.945787] kernel BUG at
/home/lxsmbadmin/latest_14mar/linux-fs/fs/cifs/cifssmb.c:1954!
[ 2275.952198] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[ 2275.956500] CPU: 0 PID: 3369 Comm: kworker/0:7 Tainted: G
OE     5.17.0-rc6+ #1
[ 2275.962573] Hardware name: Microsoft Corporation Virtual
Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 10/27/2020
[ 2275.969812] Workqueue: cifsiod cifs_writev_complete [cifs]
[ 2275.974909] RIP: 0010:cifs_pages_written_back+0x1e1/0x1f0 [cifs]
[ 2275.975570] CIFS: bad 2000 @64f0000 page 64f0 64f1
[ 2275.980619] Code: 00 48 8b 07 f6 c4 04 0f 84 92 84 06 00 e8 77 a6
e6 db 48 89 c1 49 89 d8 4c 89 e2 44 89 ee 48 c7 c7 e0 f5 8e c0 e8 a4
9d 71 dc <0f> 0b e8 58 f5 76 dc 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
55 48
[ 2275.980622] RSP: 0018:ffffac614177fdc8 EFLAGS: 00010246
[ 2275.980625] RAX: 0000000000000026 RBX: 00000000000064f1 RCX: 00000000000=
00000
[ 2275.980626] RDX: 0000000000000000 RSI: ffffffff9d767af1 RDI: 00000000fff=
fffff
[ 2275.980628] RBP: ffffac614177fe28 R08: 0000000000000000 R09: ffffac61417=
7fbc0
[ 2275.980629] R10: ffffac614177fbb8 R11: ffffffff9df52b68 R12: 00000000064=
f0000
[ 2275.980631] R13: 0000000000002000 R14: 0000000000000000 R15: ffff9c8193b=
c7e40
[ 2275.980632] FS:  0000000000000000(0000) GS:ffff9c8337c00000(0000)
knlGS:0000000000000000
[ 2275.980636] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2275.980638] CR2: 00007fd099e56b90 CR3: 00000001028e4006 CR4: 00000000003=
706f0
[ 2275.980639] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 2275.980640] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[ 2275.980641] Call Trace:
[ 2275.980643]  <TASK>
[ 2275.980648]  cifs_writev_complete+0x43d/0x500 [cifs]

Noticed that with netfs integration, file open with O_DIRECT flag is
not supported.

Regards,
Rohith

On Tue, Mar 15, 2022 at 9:20 AM Rohith Surabattula
<rohiths.msft@gmail.com> wrote:
>
> Hi David,
>
> Below change needs to be applied on top of your branch.
>
> lxsmbadmin@netfsvm:~/latest_14mar/linux-fs$ git diff
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index af7483c246ac..447934ff80b8 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2969,6 +2969,12 @@ cifs_write_from_iter(loff_t offset, size_t len,
> struct iov_iter *from,
>
>                 cur_len =3D min_t(const size_t, len, wsize);
>
> +               if (!cur_len) {
> +                       rc =3D -EAGAIN;
> +                       add_credits_and_wake_if(server, credits, 0);
> +                       break;
> +               }
> +
>                 wdata =3D cifs_writedata_alloc(cifs_uncached_writev_compl=
ete);
>                 if (!wdata) {
>                         rc =3D -ENOMEM;
>
> lxsmbadmin@netfsvm:~/xfstests-dev$ sudo ./check generic/013
> SECTION       -- smb3
> FSTYP         -- cifs
> PLATFORM      -- Linux/x86_64 netfsvm 5.17.0-rc6+ #1 SMP PREEMPT Mon
> Mar 14 09:05:47 UTC 2022
> MKFS_OPTIONS  -- //127.0.0.1/sambashare_scratch
> MOUNT_OPTIONS -- -ousername=3D,password=3D,noperm,vers=3D3.0,actimeo=3D0
> //127.0.0.1/sambashare_scratch /mnt/xfstests_scratch
>
> generic/013      149s
> Ran: generic/013
> Passed all 1 tests
>
> SECTION       -- smb3
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> Ran: generic/013
> Passed all 1 tests
>
> Regards,
> Rohith
>
> On Fri, Mar 11, 2022 at 1:56 PM David Howells <dhowells@redhat.com> wrote=
:
> >
> >
> > David Howells <dhowells@redhat.com> wrote:
> >
> > > The other issue is that if I run splice to an empty file, it works; r=
unning
> > > another splice to the same file will result in the server giving
> > > STATUS_ACCESS_DENIED when cifs_write_begin() tries to read from the f=
ile:
> > >
> > >     7 0.009485249  192.168.6.2 =E2=86=92 192.168.6.1  SMB2 183 Read R=
equest Len:65536 Off:0 File: x
> > >     8 0.009674245  192.168.6.1 =E2=86=92 192.168.6.2  SMB2 143 Read R=
esponse, Error: STATUS_ACCESS_DENIED
> > >
> > > Actually - that might be because the file is only 65536 bytes long be=
cause the
> > > first splice finished short.
> >
> > Actually, it's because I opened the output file O_WRONLY.  If I open it
> > O_RDWR, it works.  The test program is attached below.
> >
> > David
> > ---
> > #define _GNU_SOURCE
> > #include <stdio.h>
> > #include <stdlib.h>
> > #include <string.h>
> > #include <unistd.h>
> > #include <fcntl.h>
> >
> > int main(int argc, char *argv[])
> > {
> >         off64_t opos;
> >         size_t len;
> >         int in, out;
> >
> >         if (argc !=3D 4) {
> >                 printf("Format: %s size in out\n", argv[0]);
> >                 exit(2);
> >         }
> >
> >         len =3D atol(argv[1]);
> >
> >         if (strcmp(argv[2], "-") !=3D 0) {
> >                 in =3D open(argv[2], O_RDONLY);
> >                 if (in < 0) {
> >                         perror(argv[2]);
> >                         return 1;
> >                 }
> >         } else {
> >                 in =3D 0;
> >         }
> >
> >         if (strcmp(argv[3], "-") !=3D 0) {
> >                 out =3D open(argv[3], O_WRONLY);  // Change to O_RDWR
> >                 if (out < 0) {
> >                         perror(argv[3]);
> >                         return 1;
> >                 }
> >         } else {
> >                 out =3D 1;
> >         }
> >
> >         opos =3D 3;
> >         if (splice(in, NULL, out, &opos, len, 0) < 0) {
> >                 perror("splice");
> >                 return 1;
> >         }
> >
> >         if (close(in) < 0) {
> >                 perror("close/in");
> >                 return 1;
> >         }
> >
> >         if (close(out) < 0) {
> >                 perror("close/out");
> >                 return 1;
> >         }
> >
> >         return 0;
> > }
> >
