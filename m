Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8AADC77B7A
	for <linux-cifs@archiver.kernel.org>; Tue, 16 May 2023 19:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjEPTIG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 May 2023 15:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjEPTIF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 May 2023 15:08:05 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492A5E7A
        for <linux-cifs@vger.kernel.org>; Tue, 16 May 2023 12:08:04 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4f00d41df22so6295362e87.1
        for <linux-cifs@vger.kernel.org>; Tue, 16 May 2023 12:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684264082; x=1686856082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z1Ddzgar7RPOdlkzXuXLkT8rvtt8pUPgnmzCxBA0oDw=;
        b=JQMSBQ3ZxFvdNHhYDJ+sQMmGmu1m4UV2eNzZQdLUmcKDWICKKDwvBfYwVO28Iqq9Mq
         ox7AJkR/02hGT5QhcpmcqEc0zt3Np+O8gVTFXZQ1WHXbCuWwNzI5lH0RcMF7KXHMxlTb
         3B1zdb+7qCtNgcxVlaPB0Oi4HHTtiRn/YS4kQIM1hU50VTgI62vMlGgz+/lb+OkxkMQC
         As0U92ClPtPPdIhmBd2yHL4CI3ETIqXxujTX8mniy5i6YLxkrAhU8kYdHDGSU/gh4xW4
         l2xSNWSHld0qjjuL2+O+LZFWG8C5bL4rdjYn144rUymzK1a6ajd8DoKRzMl4NzU/KEFz
         Dv3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684264082; x=1686856082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z1Ddzgar7RPOdlkzXuXLkT8rvtt8pUPgnmzCxBA0oDw=;
        b=ha7XQYJTYsQIVBmqBX7UgTsLUvp0XcyjWadwr4XCQ5Wo7mj8kJlEYHIn122C6jeqDX
         oVUnQNxTV9a0B9m6Lql4kgRszhs650Y9rDQgmrz+b5v+0mFjSMvbLoAhT2h0MBzL/kmu
         mzg8plL54ayUJQca3LsT/u8lp5U8Hlzhpqw+C2JGIkevKOWFzmvLszUD6xZkfrkhYJdA
         iZXdbEjS3LRpaxIn9qrlGlYQKpxLDxhzkcv68tYLB/1RTf/6Doy0PZjnwBa4UMuPDdpQ
         yHMM1aK+3A1WOrRxjO4JL8gDGM4qrLajCkRJ+yyg7dsdsfCzW3V2naD6jVdw4HolEyei
         6MsA==
X-Gm-Message-State: AC+VfDydZeBPD92bX9znHJ1cvL6clxz0k4UDw0EJTFnmUxcP8yom6c6M
        v3PbEfrQ7TkkjFaHqDM0LVSli2Fn2DObv98HUyk=
X-Google-Smtp-Source: ACHHUZ7kpTiS2+L8tDImS6CeswPwd8IDbkLTRcCYE/5ofogMZEUzxaGcNJdeAmebpz2q34nLHQHW4KGLpXMg7P+6Dsg=
X-Received: by 2002:a05:6512:33d4:b0:4f0:3e1:9ada with SMTP id
 d20-20020a05651233d400b004f003e19adamr8700365lfg.31.1684264082257; Tue, 16
 May 2023 12:08:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvqK0CkcR_DOwUfDVzsWco-SXb4rTt14b-YF5CpqCNrZQ@mail.gmail.com>
 <CAGypqWyuCdiEmuFzefEY05zDiBhP+g7y2e0p-9nts4rM5keRpg@mail.gmail.com> <CANT5p=pWYfn-CGTn3QdgVo4JWh85vqjJQoeZCbmPOOCaYogPXw@mail.gmail.com>
In-Reply-To: <CANT5p=pWYfn-CGTn3QdgVo4JWh85vqjJQoeZCbmPOOCaYogPXw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 16 May 2023 14:07:50 -0500
Message-ID: <CAH2r5ms83NK1FbtTUQdQdT4ES+k8nuVdci3RowRsEddMaebqeA@mail.gmail.com>
Subject: Re: [PATCH] SMB3: force unmount was failing to close deferred close files
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Bharath SM <bharathsm.hsk@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Bharath S M <bharathsm@microsoft.com>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, May 16, 2023 at 1:51=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Tue, May 9, 2023 at 1:03=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.co=
m> wrote:
> >
> > Ack by me.
> >
> > On Tue, May 9, 2023 at 12:05=E2=80=AFPM Steve French <smfrench@gmail.co=
m> wrote:
> > >
> > > In investigating a failure with xfstest generic/392 it
> > > was noticed that mounts were reusing a superblock that should
> > > already have been freed. This turned out to be related to
> > > deferred close files keeping a reference count until the
> > > closetimeo expired.
> > >
> > > Currently the only way an fs knows that mount is beginning is
> > > when force unmount is called, but when this, ie umount_begin(),
> > > is called all deferred close files on the share (tree
> > > connection) should be closed immediately (unless shared by
> > > another mount) to avoid using excess resources on the server
> > > and to avoid reusing a superblock which should already be freed.
> > >
> > > In umount_begin, close all deferred close handles for that
> > > share if this is the last mount using that share on this
> > > client (ie send the SMB3 close request over the wire for those
> > > that have been already closed by the app but that we have
> > > kept a handle lease open for and have not sent closes to the
> > > server for yet).
> > >
> > > Reported-by: David Howells <dhowells@redhat.com>
> > > Cc: <stable@vger.kernel.org>
> > > Fixes: 78c09634f7dc ("Cifs: Fix kernel oops caused by deferred close
> > > for files.")

> cifs_put_tcon sounds like a more logical place to do this. When the
> ref count has dropped to 0.
>
> --
> Regards,
> Shyam

The problem with waiting till cifs_put_tcon (although it wouldn't hurt
to also call close_all_deferred_files() there or in cifs_kill_sb) is
that that is too late.

We don't get notified when umount begins except on force umount
("umount_begin") so a simple scenario like:

          echo "data in new file" >> /mnt2/newfile ; umount /mnt2

will wait until the deferred close timeout ("closetimeo") before
closing these files and then sending the tree disconnect, so in that
example tree discconnect was unnecessarily delayed (although "umount"
completes immediately, we can't send the tree disconnect until all the
closetimeouts expire since we will not receive the "kill_sb()" call
until the deferred close references are released).

Closing deferred files in various scenarios ("umount -f" and calls to
"shutdown") can help us send the tree disconnect faster and not tie up
resources on the server longer for files we won't be using


--=20
Thanks,

Steve
