Return-Path: <SRS0=9w6c=D5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6920FC4363A
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Oct 2020 17:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D15824630
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Oct 2020 17:14:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iui+pE1G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506907AbgJVROp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Oct 2020 13:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2898782AbgJVROp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Oct 2020 13:14:45 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC397C0613CF
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2020 10:14:44 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id l28so3186221lfp.10
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2020 10:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UwpJJ65yL94f4bb05RoonEVZnLTZ+mFKc2HAkf7PWFw=;
        b=Iui+pE1GhbXAIgBY/myfaDXAn5MYQd5pY34W7nRQpCliI744EuXm48N+wkajUYzaho
         lWd0RDmXc6SGeuK7QM/H6r2vfu66TrkbIpbyBkSam7rsD2dZu8IWQOFXGIWWA5rGBM+5
         rFONJ+MCnkdQjVPtD84j8Up8sX5E3RV8/xtzsycE4tUT1KbnlG4kXFASrPN+70HdSz4Z
         sZ3GvasFGeU5++GfniLr/YeSrQumyDeXijTRjHfhFiSfDVBty5xJjhbwTHSgp28TVI0l
         fTzdhSgQn7xLT0tCHrhe7uE9X/HPC0sxRRzLGukUbg16L8hEvl/hyJhF2Zz0syyD25jW
         YGng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UwpJJ65yL94f4bb05RoonEVZnLTZ+mFKc2HAkf7PWFw=;
        b=fY0t+VXKYTY1JRv4yBnsryCak8VmHhhCm9ne4ouhXjXBAfWHMk0mEeAUxfFj+7u/4Y
         +As6OxxrjT85r/UZt7d+utQE8/na26SjsUiVaC+1ZO444V1PvaPlUmWHqEzcxeiTx5px
         ORZeBN1bz4ARqCPlvfSkQgSWId8fYNhkqFIvqYWs3ZFVdqyNDA92dMZHlzOzEIRSuiEn
         l9P1Vcf/8EImtMSSLgfXWXmI3sunoPJ6UmrprFB/dUN5S/v2yXWw9FC4EmWYV6+zBj7J
         fNHNJUQt3NuGu9/5QNZUIhWz/6SssBgRfnFt3ekTGMM9GH0JDMGGoE9un3yu99KxJe5b
         XCFA==
X-Gm-Message-State: AOAM533H4w24byVV5cRIMc7Ce9DY2+r6sFD29Fwe5H5I35iaOUAWT2NT
        gmm6fkwuUxwXz0DFqMUfXiQkkCNdtF9svdgH7/pg+wbcr3o=
X-Google-Smtp-Source: ABdhPJx6Bv9I/cz3aIWdHhjVto/AxkrWOH3NBC37niei6lGnoAykZV4c/aNJi2LiFfBKlWc4b2vNZwvdEuO3aNtXCI4=
X-Received: by 2002:a19:241:: with SMTP id 62mr1306713lfc.165.1603386883217;
 Thu, 22 Oct 2020 10:14:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtmPxUKYYK-PbouTFpt9T8AU-41pRZu1CEO=+XLZZ+vSA@mail.gmail.com>
 <87wnziv6dw.fsf@suse.com>
In-Reply-To: <87wnziv6dw.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 22 Oct 2020 12:14:32 -0500
Message-ID: <CAH2r5mvfhURSj1qOZs4QCaMiqdZbrTRo2+MJgOfaG_RS8OYZYA@mail.gmail.com>
Subject: Re: [PATCH][WIP] query smb3 reparse tags for special files
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

on query dir I see the EAsize set to the reparse tag as expected (in
query dir), but not on FILE_ALL_INFO (query info).

So as you indicated, there are only the query dir info levels (not
query info ones) which allow returning what we need for reparse point
special files - so will have to use fsctl as in smb2_query_symlink.


On Thu, Oct 22, 2020 at 6:37 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> Steve French <smfrench@gmail.com> writes:
> > smbfsctl.h:#define IO_REPARSE_TAG_LX_SYMLINK    0xA000001D
> > smbfsctl.h:#define IO_REPARSE_TAG_LX_FIFO            0x80000024
> > smbfsctl.h:#define IO_REPARSE_TAG_LX_CHR             0x80000025
> > smbfsctl.h:#define IO_REPARSE_TAG_LX_BLK             0x80000026
> >
> > These also make sense for us to use more broadly because it simplifies =
readdir
> >
> > but ... my first attempt at querying this using infolevel 33
> > FileReparsePointInformation (see MS-FSCC section 2.4.35) failed ...
> > with Windows 10 returning STATUS_NOT_SUPPORTED when querying various
> > reparse points (created by WSL indirectly) including fifos, symlinks
> > and char devices.
> >
> > I can switch approaches and try to do the smb3 fsctl to query reparse
> > info instead but was hoping that query info would work.  Any idea if
> > there is another info level that would allow me to query the tag?
>
> According to [MS-FSCC] if the file has the REPARSE_TAG attribute, the
> EaSize field must be interpreted as a reparse tag for these info levels:
>
> * FileFullDirectoryInfo
> * FileBothDirectoryInfo
> * FileIdFullDirectoryInfo
> * FileIdBothDirectoryInfo
>
> Otherwise we have code for querying the reparse tag in
> smb2_query_symlink():
>
>         rc =3D SMB2_ioctl_init(tcon, server,
>                              &rqst[1], fid.persistent_fid,
>                              fid.volatile_fid, FSCTL_GET_REPARSE_POINT,
>                              true /* is_fctl */, NULL, 0,
>                              CIFSMaxBufSize -
>                              MAX_SMB2_CREATE_RESPONSE_SIZE -
>                              MAX_SMB2_CLOSE_RESPONSE_SIZE);
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>


--=20
Thanks,

Steve
