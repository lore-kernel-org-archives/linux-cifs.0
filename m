Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4C5C77B75
	for <linux-cifs@archiver.kernel.org>; Tue,  9 May 2023 07:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjEIHXn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 May 2023 03:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjEIHXm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 May 2023 03:23:42 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31F3173C
        for <linux-cifs@vger.kernel.org>; Tue,  9 May 2023 00:23:39 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id 3f1490d57ef6-ba5e37f60f0so584928276.0
        for <linux-cifs@vger.kernel.org>; Tue, 09 May 2023 00:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683617019; x=1686209019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0z7kuOsiTr7ntrsc0k5TrSWyDWzgG8oq3eJD9a4NwIE=;
        b=QAz8EJDuU6Jf2yjFX93BccI/AN9ZyEHQZOAapIpLTRM5+b7LZi6w2zXStExmMN/7r+
         tpaVL7wVDbTYgo8pa3TKG8mdRcxaQWo1tYibyj5IcjXt8Tr7rchThiGV+RJqCtkC7aC4
         Fqq7RNI5yKTin62L5JSyfRbzHGG+u+WBfnplmGcMpb8giIP32M2oOIsJbnB5wfPkHPwa
         +o1+xys/e5oxiB7+qf7m+GJKXZRi6atPyFgAg1fhA6BprUy6IxAVoZeZxWu+Tx3HOise
         13zvuGHcVrnqntTwJBdHNgIy88CqvQZpR1h0+2iZCok0dPlhrTY2WmPjlgmjDa+YDzyO
         KX/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683617019; x=1686209019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0z7kuOsiTr7ntrsc0k5TrSWyDWzgG8oq3eJD9a4NwIE=;
        b=ZmLi/KVySHRH1qXgfAVjD++Tlu66jECX4BkPUQmsj6d9+pDZxFjKGBG6HJ43XsHnpv
         qrAXBEGMlHLz4itPPPk5tU/X+zuJVbzBL5yobFG783D1kCJOETtMEWDVt/FzUaVsEqo7
         nq7roa/Y/lAeKp7HLpB9kRJBVJJUS2/E1Oewm38MgXrOGD1GisDo5EBoolkh7Z0268x1
         yvrhkVs4RFaSQyRCJPi0K1SdONrZRNBq6cUF5g0metm/YNvEOBZPPwubjFDJ4lbjlU7y
         4PAb9HNqDoJr0SyqpjEPDU9WIz0VXI/l1uzIjiPYBB+trRwQzYCYln0ApYC9kIXEfSjr
         FHhQ==
X-Gm-Message-State: AC+VfDzwCsUyJhLnDQKMRoLrHk4FD8TpaJ5ytaHvGos6+i/dymhltOTD
        qnSB4GHRxkwnMATxGazR7yF18gthpaYpud33lzAMN1yd7U0=
X-Google-Smtp-Source: ACHHUZ5lILYB/1+SR/wGBKqLGS/Mn9sFwbtL50/GrCEebzCgCuFQi0Y0T38f2weqfZeM4KPJK+ILy7gOvFd8aLsxRtc=
X-Received: by 2002:a25:c5d3:0:b0:b9d:a3e5:76ff with SMTP id
 v202-20020a25c5d3000000b00b9da3e576ffmr15329440ybe.32.1683617018994; Tue, 09
 May 2023 00:23:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvqK0CkcR_DOwUfDVzsWco-SXb4rTt14b-YF5CpqCNrZQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvqK0CkcR_DOwUfDVzsWco-SXb4rTt14b-YF5CpqCNrZQ@mail.gmail.com>
From:   Bharath SM <bharathsm.hsk@gmail.com>
Date:   Tue, 9 May 2023 12:53:28 +0530
Message-ID: <CAGypqWyuCdiEmuFzefEY05zDiBhP+g7y2e0p-9nts4rM5keRpg@mail.gmail.com>
Subject: Re: [PATCH] SMB3: force unmount was failing to close deferred close files
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Bharath S M <bharathsm@microsoft.com>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ack by me.

On Tue, May 9, 2023 at 12:05=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> In investigating a failure with xfstest generic/392 it
> was noticed that mounts were reusing a superblock that should
> already have been freed. This turned out to be related to
> deferred close files keeping a reference count until the
> closetimeo expired.
>
> Currently the only way an fs knows that mount is beginning is
> when force unmount is called, but when this, ie umount_begin(),
> is called all deferred close files on the share (tree
> connection) should be closed immediately (unless shared by
> another mount) to avoid using excess resources on the server
> and to avoid reusing a superblock which should already be freed.
>
> In umount_begin, close all deferred close handles for that
> share if this is the last mount using that share on this
> client (ie send the SMB3 close request over the wire for those
> that have been already closed by the app but that we have
> kept a handle lease open for and have not sent closes to the
> server for yet).
>
> Reported-by: David Howells <dhowells@redhat.com>
> Cc: <stable@vger.kernel.org>
> Fixes: 78c09634f7dc ("Cifs: Fix kernel oops caused by deferred close
> for files.")
>
> See attached
> --
> Thanks,
>
> Steve
