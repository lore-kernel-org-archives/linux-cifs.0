Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F54BC433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Oct 2022 05:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbiJJFMq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Oct 2022 01:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiJJFMq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 10 Oct 2022 01:12:46 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB9F4BA7D
        for <linux-cifs@vger.kernel.org>; Sun,  9 Oct 2022 22:12:44 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id sc25so16378923ejc.12
        for <linux-cifs@vger.kernel.org>; Sun, 09 Oct 2022 22:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jB3nG4+B2WH6Et3d9aPNbzwAm7rzDSVmOLywPfSEQrU=;
        b=R9a89/jfAu/MJrQmt8Dn3d/pTavdUtgjzLfc5ZWsKMPcah3xgUVp59D4iEqUNGTuV+
         Mj7uFMlvy24WAMvR0H0BvI3PE0p6L5qOJXNMiQKLUu0GYmJQqV+wJgAxiTxFHU7QJ/kZ
         wDazVqr0yXpPqkMHK4StAGXwDD+x2dVr7XK7L3SgMMYj9teoIVzPWdpJB4ankb9Zxq9P
         KZ7PU4WugdkuucfJBPGlpQHfBGd4dh19/QXIqLrFMUTFUdu1YX5Q6WIyhXrRV86xQkkr
         lW8xAnqL/YAkVHxN3u/y4JTCkBFOg5bzIwKsROvDnZAcoV4zFEF9MxIvS5eF+csUV1X4
         qBNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jB3nG4+B2WH6Et3d9aPNbzwAm7rzDSVmOLywPfSEQrU=;
        b=uNeBQ8lTnorsoZDNu19ISbxaXL77gidbD3ZWv2hlM8RqZRc6mj91zR+szSWyydfE3o
         5PrOUxGOStvxukq2evzJMmLEWbecYb6Sj8tMDleqlW4Bk8cGk0mE61SnYgSXtPU2z2Ta
         o38tVxPf73vOARrWbm1qxZtcuV/0ZWukEBKFvNoH6fhukkiRAySrQPfsyC59sdNNuBlP
         iviKWA21bXDDuedcqw8l6Ga5frMnxH0oftJ1JigtGcXxcbx+gOerFR1u/WCbxQcqEwbU
         aFmn0+woxFCS6F2IcsHS3ODFArfYSuv6KZpPYliPlN+AYTvnORFoEGyWymukjcWyd+YF
         xRlA==
X-Gm-Message-State: ACrzQf09ufvKnZHvGKVN1T4fSjn0eDvwJl+z9twVE0vj04ARXgbS4Rj7
        YDaPDMJZQe5ZHlfeRtDfVuCAXMs9H/6Ds06jwYA=
X-Google-Smtp-Source: AMsMyM5YOEie43WaSBnbPFPq72vT4462Hg4cOpgx34ERxe+4hVF4/r52hSohb5hUsRMTEIwyhKN9eeHfYFjLaqjFgpQ=
X-Received: by 2002:a17:907:9717:b0:78d:9fb4:16dd with SMTP id
 jg23-20020a170907971700b0078d9fb416ddmr5922878ejc.720.1665378763383; Sun, 09
 Oct 2022 22:12:43 -0700 (PDT)
MIME-Version: 1.0
References: <20221006043609.1193398-1-lsahlber@redhat.com> <20221006043609.1193398-2-lsahlber@redhat.com>
 <CA+5B0FM0t5vF8oHCbhc8Cj3vQ6eUas3WPFH7d0RmqC2c+TRAbQ@mail.gmail.com>
In-Reply-To: <CA+5B0FM0t5vF8oHCbhc8Cj3vQ6eUas3WPFH7d0RmqC2c+TRAbQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Mon, 10 Oct 2022 15:12:31 +1000
Message-ID: <CAN05THTyJ3+iFLs8SjKUzu71G2PyJRfaYj9UqQ0zXXmMPH67Cg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix skipping to incorrect offset in emit_cached_dirents
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aurelien.aptel@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, 10 Oct 2022 at 04:04, Aur=C3=A9lien Aptel <aurelien.aptel@gmail.com=
> wrote:
>
> Hi,
>
> Make sure you're not re-introducing the bug where the first few files
> are missing when mounting the root of a Windows drive.
>
> See fix https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/commit/fs/cifs/smb2ops.c?id=3D0595751f267994c3c7027377058e4185b3a28e75
>
> And bug https://bugzilla.samba.org/show_bug.cgi?id=3D13107

Yeah.
What confuses things is that we do not create a contignous sequence of
index positions when we emit a directory.
For the dir_context, ctx->pos starts at 0 for the first entry and then
increments by one for each other entry.
We do not currently create a contignous space but one with one or two
holes in it.
We start by explicitely emitting '.' and '..' and these are at
position 0 and 2 respectively.
But then, for a server that for example DOES return entries for '.'
and '..' we skip emitting these entries but still increment pos,
thus we end up with a sequence for index positions of the entries of
0,1,4,5,6,7,...
I.e. there is a hole in the sequence where 2 and 3 are missing becasue
these were the dot directories that the server responded
and that we did not emit, but we incremented pos.

This should ideally be fixed because otherwise, what would lseek(3), mean ?
>
> Cheers,
