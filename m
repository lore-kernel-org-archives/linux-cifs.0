Return-Path: <SRS0=KBsq=VB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9FEC0651F
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Jul 2019 21:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ED3E20659
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Jul 2019 21:08:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U/AassZK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfGDVIS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Jul 2019 17:08:18 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45091 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbfGDVIR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Jul 2019 17:08:17 -0400
Received: by mail-lf1-f67.google.com with SMTP id u10so4961084lfm.12
        for <linux-cifs@vger.kernel.org>; Thu, 04 Jul 2019 14:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OFepJf0HRUsDqi2lQGNpJ3ZgpbP6Pq3HjiFWKOeBJ3Q=;
        b=U/AassZKZ+D9gHOjPMLVEzT2ASJddyqakAGhpMneZ8w8k7befLNkDpR5wdtBeYNqZ0
         VXwX3Fx+nb+FngB9aW12rP22TV76rGbcRCe8hhvgFXBnBFZ3IUDFDLaUscw6xEvfeiq7
         rhKazpqqyC84CHcAH3SGea5S9alH72vkMTxYeANrysSGPVgOuhgbg8kbbH4nr/QsTNAH
         c+DsJNSVHY4lk3FkoTCBO7V7HotETLE+xRw79fethzLQKFNZbK71VLnxeSO62pCnLY5C
         TNQ6EcXwLsvzyVvg5ydBWXW9j7mnO01ZbuP5BG1ykxCsyst4tybR7qSNBQLK+Bc4qWgW
         BNdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OFepJf0HRUsDqi2lQGNpJ3ZgpbP6Pq3HjiFWKOeBJ3Q=;
        b=kkpskVpYWpISYHfmTY90DG3hlY3pTVastb3fSRYuYmO+fauFJKke9vtrxIrxEYGvqZ
         MhGRabuLpY1RXq2pGxjSqrk47bysL2SHk8fzZOVBm9Beb9pZnboCZHKqTFjyuxGRXgbp
         MtjUMb6jAYHbZsbfJVDxjeYL0MxysZ09JEtQ8TGEJck/BOzgBpGCihfRdPfsYKB2yAiX
         foe7KofF7VB8gZQuAEkYILYNQ97fJEfnTrSFVgfBymSiMCjMxDAMcK4U1wHoq/TyHavF
         qntWSmw7Lh5wsJhbGshLrNnbsQSQG2lwYifKgVTS58dO09JH4LxZNpgR6Q6AxwGRmvDR
         fnXA==
X-Gm-Message-State: APjAAAXzZWiA9hh8FYdGHZGjBtpRKsOvVhCbA59n2AqFl/XhkpHQxkLi
        QEP5djGTtLYmFy8aIjcIhYUWfnKoCNAKGtaBSLdW
X-Google-Smtp-Source: APXvYqw6tOUsFXI1KEtIznHtJJvkhHRxassbrk1XPFEKtfljQ47IXrOL5JywE7iO0tyEUqg6GKFNGjaMQ50ZqTlhPQo=
X-Received: by 2002:ac2:50cd:: with SMTP id h13mr273472lfm.36.1562274495069;
 Thu, 04 Jul 2019 14:08:15 -0700 (PDT)
MIME-Version: 1.0
References: <684ed01c-cbca-2716-bc28-b0a59a0f8521@prodrive-technologies.com>
 <875zojx70t.fsf@suse.com> <1fc4f6d0-6cdc-69a5-4359-23484d6bdfc9@prodrive-technologies.com>
 <8736jmxcwi.fsf@suse.com>
In-Reply-To: <8736jmxcwi.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 4 Jul 2019 14:08:03 -0700
Message-ID: <CAKywueT2AV5V46ovb25a4287DbS0etuM64VZpkmCFW38abQR4Q@mail.gmail.com>
Subject: Re: Many processes end up in uninterruptible sleep accessing cifs mounts
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

+ Ronnie, Steve

Good analysis, thanks!

One way to fix it is to drop the mutex before entering any PDU
functions, then acquire it again and double check if any concurrent
process has already initialize the handle. The complication here is
that the current kernel diverged from 4.20.y stable kernel in this
code path, so this would require separate patches for the current and
stable kernels.

--
Best regards,
Pavel Shilovsky

=D1=87=D1=82, 4 =D0=B8=D1=8E=D0=BB. 2019 =D0=B3. =D0=B2 04:24, Aur=C3=A9lie=
n Aptel <aaptel@suse.com>:
>
> Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com> writes:
> >> Are there any kernel oops/panic with stack traces and register dumps i=
n
> >> the log?
> >>
> >> You can inspect the kernel stack trace of the hung processes (to see w=
here
> >> they are stuck) by printing the file /proc/<pid>/stack.
> >
> > These are the stacks of all processes that are D, most of them being df=
.
> > I also attached the cifs Stats output below.
>
> Ok thanks. What about Oops or BUG or panic in dmesg logs, did you see
> any?
>
> The individual stack dumps are pretty useful. Here is my theory:
>
> > pid: 9505
> > syscall: 4 0x56550a2ec470 0x7ffede42e9a0 0x7ffede42e9a0 0x83a 0x3 0x20
> > 0x7ffede42e8f8 0x7f7f8928f295
> > [<0>] open_shroot+0x43/0x200 [cifs]
> > [<0>] smb2_query_path_info+0x93/0x220 [cifs]
>
> Almost all of the processes have the same stack trace. They are stuck at
> open_shroot()+0x43 which is probably
>
>     mutex_lock(&tcon->crfid.fid_mutex);
>
> Then there are only 2 other processes stuck somewhere in the same code pa=
th
> (open_shroot) but deeper, meaning they have the locks that the other
> processes are waiting for:
>
>
> > pid: 22858
> > syscall: 4 0x564b46285d10 0x7ffcea3f9a80 0x7ffcea3f9a80 0x83a 0x3 0x20
> > 0x7ffcea3f99d8 0x7f6cc78c7295
> > [<0>] cifs_mark_open_files_invalid+0x54/0xa0 [cifs]
> > [<0>] smb2_reconnect+0x2d6/0x4b0 [cifs]
> > [<0>] smb2_plain_req_init+0x30/0x240 [cifs]
> > [<0>] SMB2_open_init+0x6d/0x7c0 [cifs]
> > [<0>] SMB2_open+0x150/0x520 [cifs]
> > [<0>] open_shroot+0x12f/0x200 [cifs]
> > [<0>] smb2_query_path_info+0x93/0x220 [cifs]
> > [<0>] cifs_get_inode_info+0x580/0xb10 [cifs]
> > [<0>] cifs_revalidate_dentry_attr+0xdc/0x3e0 [cifs]
> > [<0>] cifs_getattr+0x5b/0x1b0 [cifs]
> > [<0>] vfs_statx+0x89/0xe0
> > [<0>] __do_sys_newstat+0x39/0x70
> > [<0>] do_syscall_64+0x55/0x100
> > [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > [<0>] 0xffffffffffffffff
>
>
> > pid: 20027
> > syscall: 4 0x55a3c7d767d0 0x7ffe51432ab0 0x7ffe51432ab0 0x83a
> > 0x55a3c7d75c40 0x20 0x7ffe51432a08 0x7f5f7c4e7295
> > [<0>] cifs_mark_open_files_invalid+0x54/0xa0 [cifs]
> > [<0>] smb2_reconnect+0x2d6/0x4b0 [cifs]
> > [<0>] smb2_plain_req_init+0x30/0x240 [cifs]
> > [<0>] SMB2_open_init+0x6d/0x7c0 [cifs]
> > [<0>] SMB2_open+0x150/0x520 [cifs]
> > [<0>] open_shroot+0x12f/0x200 [cifs]
> > [<0>] smb2_query_path_info+0x93/0x220 [cifs]
> > [<0>] cifs_get_inode_info+0x580/0xb10 [cifs]
> > [<0>] cifs_revalidate_dentry_attr+0xdc/0x3e0 [cifs]
> > [<0>] cifs_getattr+0x5b/0x1b0 [cifs]
> > [<0>] vfs_statx+0x89/0xe0
> > [<0>] __do_sys_newstat+0x39/0x70
> > [<0>] do_syscall_64+0x55/0x100
> > [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > [<0>] 0xffffffffffffffff
>
> Due to timeouts maybe the Open request needs
> to reconnect the server/ses/tcon and to do this it calls
> cifs_mark_open_files_invalid() and gets stuck somewhere there.
>
>         spin_lock(&tcon->open_file_lock);
>         list_for_each_safe(tmp, tmp1, &tcon->openFileList) {
>                 open_file =3D list_entry(tmp, struct cifsFileInfo, tlist)=
;
>                 open_file->invalidHandle =3D true;
>                 open_file->oplock_break_cancelled =3D true;
>         }
>         spin_unlock(&tcon->open_file_lock);
>
>         mutex_lock(&tcon->crfid.fid_mutex); <=3D=3D=3D most likely here
>         tcon->crfid.is_valid =3D false;
>         memset(tcon->crfid.fid, 0, sizeof(struct cifs_fid));
>         mutex_unlock(&tcon->crfid.fid_mutex);
>
> I think these processes are trying to lock the same lock twice: one in
> open_shroot() and since Open ends up having to reconnect, once again in
> mark_open_files_invalid(). I think it's the same lock because I don't
> see why the tcon pointers would be different in those 2 spots. Kernel
> mutexes are not reentrant so this is a deadlock.
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 21284 (AG N=C3=
=BCrnberg)
