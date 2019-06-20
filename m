Return-Path: <SRS0=yIrz=UT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837F7C43613
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Jun 2019 03:28:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 529DF20861
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Jun 2019 03:28:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jtf3/GfZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfFTD22 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 19 Jun 2019 23:28:28 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:46046 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfFTD22 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 19 Jun 2019 23:28:28 -0400
Received: by mail-io1-f68.google.com with SMTP id e3so2517240ioc.12;
        Wed, 19 Jun 2019 20:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pAFpiri2f2t5SNQ1oqnI5SugxmE4elTmy073WdMMsRI=;
        b=Jtf3/GfZuWy5wsExbbdNhkbTF4s4dwCZGIIIaz7MBHQBuFoU0HYV1cZEKrDwvI73w1
         EZvI8h3Wl41uOapIbzo8WcI1JLz7UbqDlZ5Wa3teCmj9DG2bqVrBWyKWrJ7A4SNtfdXb
         kWVPbUMEQOow9bXRp6peiIsh1G9LNMrJU3eC6g3ZQ/yPczzx5xDMF7aafQ4tOuUaaGS8
         RztteGoPFK5I5zLuyoh2IZbw5VTaY+vbdr+pFggUT+kRqopdEv7rX7/7t5TdaaGFdyzE
         JDwz8PmZA1LOBd4Y11mzU2Lr49ZtRyFtdPqE1IeLon7anvR1qEq37zueGW/ksky4ahqZ
         2nFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pAFpiri2f2t5SNQ1oqnI5SugxmE4elTmy073WdMMsRI=;
        b=fzi/ZnTX6CaTKTru1nqfcExrMAg9er+/8WcnEmZCeeX7b1d4NrIsp2EQbg7f7Ve+DC
         OiqVSwXXT287j8bxZT4AqmxTirVtYdDfmIUoIyzISOvb7OdD7hcIvodkXSgWZ0xTOFkA
         uRrlJ2iECVEKYd9SMVoHY5At9D8VeyKeyT4FVjzydIYx6Gb57TbAhnXOSJPYKyQHyE+G
         dudJ2L4v6XayOkTPJhm5SkrGUXUZfOKxiyEOCjMm6Se/i8QxUx83i24fgbn33ITuzdPt
         QnAE+8BlfvKvp+tL2S6Uk7otVJPdtfWQGsLEgC08GGyVULEAgRYAaGLNx4S2o68qsZaI
         haAw==
X-Gm-Message-State: APjAAAUfqYRrs34TI71NNSWGkETpfGBpMGKV5zyTlMXZpokTlhKs8Csw
        sGq/gSLheJ6bXuiJQ3dsJKCAm00GUa6IuTTgScU=
X-Google-Smtp-Source: APXvYqyS9VJQZ/l6B688xMlfZqGkZDorP5yUodbs5DrUkTwIy4NL3bVs6yQ2dwM2SAbTtl2G176jyXp1eXvW6C+MRoU=
X-Received: by 2002:a6b:4f14:: with SMTP id d20mr4211820iob.219.1561001307883;
 Wed, 19 Jun 2019 20:28:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms8f_wTwBVofvdRF=tNH2NJHvJC6sWYCJyG6E5PVGTwZQ@mail.gmail.com>
 <CAN05THSoKCKCFXkzfSiKC0XUb3R1S3B9nc2b9B+8ksKDn+NE_A@mail.gmail.com> <CAH2r5mu0kZFhOyg3sXw6NVaAjyVGKuNdRGP=r_MoKqtJSqXJbw@mail.gmail.com>
In-Reply-To: <CAH2r5mu0kZFhOyg3sXw6NVaAjyVGKuNdRGP=r_MoKqtJSqXJbw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 20 Jun 2019 13:28:16 +1000
Message-ID: <CAN05THRq6CM-3ZHK5WNE-VA60N0MxSHTxeM7sp-hz-ehOTeEOA@mail.gmail.com>
Subject: Re: [SMB3][PATCH] fix copy_file_range when copying beyond end of
 source file
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Guess we need a fix to the man page.

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>

On Thu, Jun 20, 2019 at 1:19 PM Steve French <smfrench@gmail.com> wrote:
>
> Local file systems that I tried, seem to agree with xfstest and return
> 0 if you try to copy beyond end of src file but do create a zero
> length target file
>
> On Wed, Jun 19, 2019 at 9:14 PM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
> >
> > On Thu, Jun 20, 2019 at 11:45 AM Steve French via samba-technical
> > <samba-technical@lists.samba.org> wrote:
> > >
> > > Patch attached fixes the case where copy_file_range over an SMB3 mount
> > > tries to go beyond the end of file of the source file.  This fixes
> > > xfstests generic/430 and generic/431
> > >
> > > Amir's patches had added a similar change in the VFS layer, but
> > > presumably harmless to have the check in cifs.ko as well to ensure
> > > that we don't try to copy beyond end of the source file (otherwise
> > > SMB3 servers will return an error on copychunk rather than doing the
> > > partial copy (up to end of the source file) that copy_file_range
> > > expects).
> >
> > + if (src_off >= inode->i_size) {
> > + cifs_dbg(FYI, "nothing to do on copychunk\n");
> > + goto cchunk_out; /* nothing to do */
> > + } else if (src_off + len > inode->i_size) {
> > + /* consider adding check to see if src oplocked */
> > + len = inode->i_size - src_off;
> > + cifs_dbg(FYI, "adjust copychunk len %lld less\n", len);
> > + }
> >
> > This makes us return rc == 0 when this triggers. Is that what we want?
> > Looking at "man copy_file_range" suggests we should return -EINVAL in
> > both these cases.
> >
> >
> >
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
>
>
>
> --
> Thanks,
>
> Steve
