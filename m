Return-Path: <SRS0=CZtn=BN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 893DCC433DF
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Aug 2020 18:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D72D206D4
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Aug 2020 18:36:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p68gfOi4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgHCSgs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Aug 2020 14:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHCSgs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Aug 2020 14:36:48 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161D9C06174A
        for <linux-cifs@vger.kernel.org>; Mon,  3 Aug 2020 11:36:48 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id c16so20168780ils.8
        for <linux-cifs@vger.kernel.org>; Mon, 03 Aug 2020 11:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=seXX3JFlODwhYuziTgkf5LhwE3gVUmZ6n9r7aMdwrlo=;
        b=p68gfOi4R9tp4ai9lxwzec5KkdbFkxqknakmatvZnkUJGJkFfBtqW1619TaUl32Fku
         5daK6G7a9GEQCzF+6pEy9RwtqRvtiQMAeVdxTjehVijyENAbFNhzdViSBYoj0chkJegP
         ejJISGHCHYr1gg402lIixHZoSfOIzV096S8CR+ihGqRcSBEMkLzpLCEJkOA+hDYSk7IN
         F6dRoCCi3KTUlF4/9yGevSIH60xTYMdMH95NdjS6DQwleFZlBiCN85V6CreGIj2E7mLF
         xh1XWuWuMnpqUXj8aWO6MPYX4kUEMjV/FJvragjFgmcfjzt7GNS38FUUtw/xDEYJ5O1L
         tWqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=seXX3JFlODwhYuziTgkf5LhwE3gVUmZ6n9r7aMdwrlo=;
        b=hufa15lG1CagcglsVvMNF9aUWicAQ8iExJFvrf9ie3uoLo66mCwnsYJqcch+2BW4al
         fYuL5fCFnAn/w/pbM8mqeLzOiqCmiNIw9lBiA+axE8mrwyvTRhyg5MSQvkrxib4yfKB/
         zOVuoZjfX/crcdlDGvgitiQ35xGrsOK1IUS2eDmDsavYQwLqf/9tL3lvJb9w+YuM8YCO
         ifrLpIILsOAeN0BdhHjI/0sSTPOjbGrQXl8chtgUWPUOa5oD9M6JyK3Ifn6ZA8IHLbZM
         mVJv4fhWmUFrDZc3oXG26ES/HecGQfc+d+ULxHf1e8orcLKHQ28UGswAwFpimWrdg4aK
         G4Tw==
X-Gm-Message-State: AOAM531qVpRDsn5MsCIsXF6cQmy+lz0XLin/il2vw6r0+FJmT8zydlw2
        aJFLXzHwXCplVTEleLdFL22O5wsPx+kMiomwp2581qC7
X-Google-Smtp-Source: ABdhPJzZ4boSCWKvK/iguS768TLKovcRM2CwOfOKn1oayM/vGOYfm1LW6BofTJyJWI/MEttZzHIGZNEPivGQLlaC+b0=
X-Received: by 2002:a92:890d:: with SMTP id n13mr745429ild.5.1596479807346;
 Mon, 03 Aug 2020 11:36:47 -0700 (PDT)
MIME-Version: 1.0
References: <1119714633.44793917.1596421202774.JavaMail.zimbra@redhat.com>
 <506179292.44794805.1596422888744.JavaMail.zimbra@redhat.com> <CAH2r5muKciTKUjMa6o62J28Tvq=qaQryOGvfC8NRWkV29yiDaQ@mail.gmail.com>
In-Reply-To: <CAH2r5muKciTKUjMa6o62J28Tvq=qaQryOGvfC8NRWkV29yiDaQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 3 Aug 2020 13:36:36 -0500
Message-ID: <CAH2r5muYQB-OaX8Njhr60LVy58LRcp2bSHMK1abA4Mqg4uFdQw@mail.gmail.com>
Subject: Re: fallocate can't change the cifs disk space usage
To:     Xiaoli Feng <xifeng@redhat.com>,
        samba-technical <samba-technical@lists.samba.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

One of the things that Samba server appears to be doing wrong is that
Samba is creating the file as a sparse file and returning that it is
not a sparse file - this obviously creates a problem because an
fallocate on a non-sparse file can be a no op ... but the server
didn't tell us it was a sparse file ...

On Mon, Aug 3, 2020 at 10:59 AM Steve French <smfrench@gmail.com> wrote:
>
> So locally on xfs this works, but Samba when receiving the request
> remotely apparently isn't doing the fallocate.  Would be curious if
> this works with vfs_btrfs and btrfs filesystem on the share - or a
> Samba server bug.
>
> On Sun, Aug 2, 2020 at 9:55 PM Xiaoli Feng <xifeng@redhat.com> wrote:
> >
> > Hello all,
> >
> > Recently when I'm investigating the xfstests generic/213 generic/228 fa=
ilures for cifs.
> > Found that fallocate can't change the cifs disk space usage. Comparing =
xfs fileystem,
> > fallocate can update space usage.
> >
> > My tests is in 5.8.0-rc7+. I also file a bug for this issue.
> >   https://bugzilla.kernel.org/show_bug.cgi?id=3D208775
> >
> > # cat /etc/samba/smb.conf
> > [cifs]
> > path=3D/mnt/cifs
> > writeable=3Dyes
> > # mount //localhost/cifs cifs -o user=3Droot,password=3Dredhat,cache=3D=
none,actimeo=3D0
> > # df -h cifs
> > Filesystem        Size  Used Avail Use% Mounted on
> > //localhost/cifs   36G   23G   13G  66% /root/cifs
> > #  fallocate -o 0 -l 2g /root/cifs/file1
> > # df -h cifs
> > Filesystem        Size  Used Avail Use% Mounted on
> > //localhost/cifs   36G   23G   13G  66% /root/cifs
> > ]# ls -l cifs
> > total 1
> > -rwxr-xr-x. 1 root root 2147483648 Aug  2 21:57 file1
> >
> > Thanks.
> >
> > --
> > Best regards!
> > XiaoLi Feng =E5=86=AF=E5=B0=8F=E4=B8=BD
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
