Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AD45C7EE23
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Mar 2023 01:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjCBBdx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Mar 2023 20:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCBBdw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Mar 2023 20:33:52 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02AF71ACEF
        for <linux-cifs@vger.kernel.org>; Wed,  1 Mar 2023 17:33:52 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 132so8872635pgh.13
        for <linux-cifs@vger.kernel.org>; Wed, 01 Mar 2023 17:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ixsystems.com; s=google; t=1677720831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lLeNdKrtAHPtUqY7PjIQ73OelcWsCQC+T2XDCBdour0=;
        b=XYhA8hgXMWYP2R6xH9NYzHdn/yR80g8tAK0roqdtFDoeihKhAodKrteUFD5zBKfrTU
         mVTg8aLIzhmKav1WMKkvlal+QRi/PAMfuhAK4iTt/kY6NFLLzCyJC1ZfFQVIWJiqx2O2
         bsRgeyZHCLUTBu4eC+rdAuxjstZEBaKxp+gFqw8pNHaiu4ANq+/zyn9CydmYkmzV/EwD
         bh0mRdzpFhv0sC0A6rvA1IwwYsxMr0ifzBkVIBAswvxcBDwGWF0NPubI/x7yMTmN4Y0l
         yf8ZIfvSoyeoS2f5WtOTzE7I5vQd6Sc877lneRzLUAUr6bBykFtc8+PS2tTXXmzw7zx5
         UGDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677720831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lLeNdKrtAHPtUqY7PjIQ73OelcWsCQC+T2XDCBdour0=;
        b=WUrdBA885/vckGuizzKxNcho6gYizBvHCbW3joKk4b1fO0Pmp9zJ72fJf9EsL19L6X
         ExHsjod6LPDIdk2LIzj6LDehZqYGSo87cf6wpyqVMOLIYjUFOft82LO2HNALwDn4pc+9
         ZBnlEoU3GM3DxT5UXX5Lt1SqKP3wDXr4gz0MIWOTrVLLBQAkPS7LSzrVTkM3nEVSkoha
         W1NtzDd/UFPFWXKX0Oj5gK23E8OOJBC5onV+FPpY9/0fJ5b5ZwsAiZJoH+5BrUf2dH84
         UDqGKE1hYx2TjgUc/HS/JyGqrRVbhOToMTg0DgN8Irb2GcBI/2yUMWT502ptZkXAPYf4
         qh/w==
X-Gm-Message-State: AO0yUKUgKxNFElkaC68YAiq4b/cNwU7UcNDVwHMiBWbpQxyN04Z4zG1M
        QbqnwOUcy0+rDHDvJ34+kWRWjn48sYLMmwipYOi14JbyN+pwFz081zY=
X-Google-Smtp-Source: AK7set/7FlFAahjwjnxK0fSc38QHD1LRmH0caf73zaA2E1JSlEQMOj3arJ9+XdiLdShHMb7p46hCy2fHZ3W8pFZ9reM=
X-Received: by 2002:a63:b21b:0:b0:503:a8:2792 with SMTP id x27-20020a63b21b000000b0050300a82792mr2831182pge.5.1677720831442;
 Wed, 01 Mar 2023 17:33:51 -0800 (PST)
MIME-Version: 1.0
References: <CAB5c7xoUXH6Xy+79Wz8M4yC70E=rwUL0ZRD_ApAFWv=C7S_uxg@mail.gmail.com>
 <514a3d90d263bd8422e9d13bd4c6e269.pc@manguebit.com>
In-Reply-To: <514a3d90d263bd8422e9d13bd4c6e269.pc@manguebit.com>
From:   Andrew Walker <awalker@ixsystems.com>
Date:   Wed, 1 Mar 2023 20:33:40 -0500
Message-ID: <CAB5c7xrdKSO4YE_vUQ6tg+p=WwxEdquj+VrRpwKxi8Jd0vPyAQ@mail.gmail.com>
Subject: Re: Nested NTFS volumes within Windows SMB share may result in inode
 collisions in linux client
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Mar 1, 2023 at 5:37=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> Andrew Walker <awalker@ixsystems.com> writes:
>
> > On my Windows server I mounted multiple NTFS volumes within the same
> > share and played around until I was able to create directories with
> > the same fileid number.
>
> Did you try it with 'noserverino' mount option?  For more information,
> see mount.cifs(8).

Yes. In this case I get a unique inode number

> Did it work with older kernels?
I only tested with 5.15 kernel. Was there a different algorithm in
older kernels that's worth testing?

> Perhaps we could conditionally stop trusting file ids sent by the server
> as we currently do for hardlinks when we see these reparse points as
> well.

Maybe fail chdir with EXDEV unless mount is with noserverino?
