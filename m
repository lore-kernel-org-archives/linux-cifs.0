Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 027F0C7EE26
	for <linux-cifs@archiver.kernel.org>; Tue, 23 May 2023 02:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjEWCXq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 May 2023 22:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjEWCXp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 May 2023 22:23:45 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662A2CD
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 19:23:44 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-255401f977dso1776961a91.2
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 19:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ixsystems.com; s=google; t=1684808623; x=1687400623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nXoS4COc3uOsHLWII8yrlNklENgmiiw8Okld7fOckYw=;
        b=bZerPBWvFjWj3lHKWEuE9nFqVXtPNqaErujjnl7eoIciWOjEc/711pDVhaWJmm/XHL
         4M1yQq7Hb+qvqsCw5i2J4LaHEaNEzUTOZyuWChBf+Vm4n0guPauG6D9z8oPx2sZaNA7R
         IzQ5gvZOdW+6eVijv9VrKKy5NrTscXG+j6KXB9A8Jdn+Fg/bFrNP9Cd5+aEM8xKsnqIS
         gNeOARZDKtqpeXk99OX4aVulEs9c/J1PEWYV+iRrEDpeTh7flRk/ej9SyGwWrVUd94Jx
         6ms8Z3eeR7XuigZWEXR9PM2rtW7cj6D04Elpkc/bqzJPnhyTad6xj9CBiHXgzHk3GyxU
         Leew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684808623; x=1687400623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nXoS4COc3uOsHLWII8yrlNklENgmiiw8Okld7fOckYw=;
        b=ajuIh+vphRJ2gzEAt4nUwxYJcRGKqP4k1lbNBOFBUVYeQCjZcvN8e+8BoM3vV+6qNV
         AtQ9goZPaQDX0Vc07JsipC95ycIcMNrUxUVA2Onp3lU6rfGBqTLGNB9cA4pxoZR+jsRF
         Tzds8ufKLbQDEQetOLvZN2/DhRMZSSe4A7chMMc01LYIY9QrLC1pXfVe6LZ3IwPGrrvf
         wmg+F5Mek4yPxrdUsHCtQ11/DN/YqQo5f7IWFSmsNLZAEc4dtOFBrLrtbCNDrjbKwBLl
         ujrjLObn/HjsnKNLF/+4R3wbW+eLergZTeJISGXkR0tCTU485fIlcnGgrn9frEU572jI
         zJNQ==
X-Gm-Message-State: AC+VfDyJlNJqRgdmeWa7w51e5E5nuuDabs8I3EWZ7MU64sCOfyYkl5wP
        SGKQw7UGNm5oKVJGnUgdDZTWTK0r3h6pTlF1TUTa8Tgx4jGaQ/hja/g=
X-Google-Smtp-Source: ACHHUZ7VywKeoJEBV52DtThs8m9BNjnWkIsfHBqS3ufWy3AIVn6sscsoMQM9O6w9qIMLacF5QPU6G+rxDhOu8jDdfrA=
X-Received: by 2002:a17:90a:6be2:b0:24e:e6c:794c with SMTP id
 w89-20020a17090a6be200b0024e0e6c794cmr12697912pjj.38.1684808623656; Mon, 22
 May 2023 19:23:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv8nAncg-f=Z5u8LkH4o7kfJLJdtoksYQgiguF7efKZkQ@mail.gmail.com>
 <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com>
 <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com>
 <ZGuWhzP98U9Niog+@jeremy-rocky-laptop> <CAN05THRnHcZtTMLxUSCYQXULVHiOXVYDU9TRy9K+_wBQQ1CFAw@mail.gmail.com>
In-Reply-To: <CAN05THRnHcZtTMLxUSCYQXULVHiOXVYDU9TRy9K+_wBQQ1CFAw@mail.gmail.com>
From:   Andrew Walker <awalker@ixsystems.com>
Date:   Mon, 22 May 2023 21:23:32 -0500
Message-ID: <CAB5c7xqcwn6a_D=OwyKDMRgEiKEnGHeubwafVU09o34cQ2G30A@mail.gmail.com>
Subject: Re: Displaying streams as xattrs
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Jeremy Allison <jra@samba.org>, Steve French <smfrench@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, May 22, 2023 at 8:00=E2=80=AFPM ronnie sahlberg via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Yeah, I don't think we should surface these as xattrs.
> Xattrs are already way too small for most of the usecases of ADS on
> windows (file metadata for explorer etc)
> and they are also just an atomic blob and not a proper filedescriptor.
> Since ADS is still just a file, any application that in the future
> will use ADS features should only do so via
> a proper filedescriptors, where it is possible to
> seek/read/write/truncate/...  so IMHO we shouldn't offer them an
> alternative but inferior API. Because they might mistakenly start to use =
it. :-(
>
> There are no real applications, yet, for linux that uses ADS but there
> are many that potentially could use ADS or
> become ADS aware. GUI Filebrowsers would be a nice usecase. As would
> making 'cp', 'mv', 'tar', 'rsync', ... ADS aware.
>
> So let's not do it with xattrs.
> No one needs/asks for this right now so it would be code we will have
> to maintain but has no users.
>
>
> What we should do though is think about and talk with the NTFS folks
> so that we make sure our aims and APIs will align with the plans they
> have.
> And once we have multiple filesystems supporting it (cifs.ko and ntfs)
> then we can start thinking about how to encourage external users and
> applications to use it.
> There are really nice use-cases for ADS where one can store additional
> metadata within the "file" itself.
>
> regards
> ronnie s
>
> On Tue, 23 May 2023 at 02:21, Jeremy Allison <jra@samba.org> wrote:
> >
> > On Mon, May 22, 2023 at 01:39:50AM -0500, Steve French wrote:
> > >On Sun, May 21, 2023 at 11:33=E2=80=AFPM ronnie sahlberg
> > ><ronniesahlberg@gmail.com> wrote:
> > >>
> > >> A problem  we have with xattrs today is that we use EAs and these ar=
e
> > >> case insensitive.
> > >> Even worse I think windows may also convert the names to uppercase :=
-(
> > >> And there is no way to change it in the registry :-(
> > >
> > >But for alternate data streams if we allowed them to be retrieved via =
xattrs,
> > >would case sensitivity matter?  Alternate data streams IIRC are alread=
y
> > >case preserving.   Presumably the more common case is for a Linux user
> > >to read (or backup) an existing alternate data stream (which are usual=
ly
> > >created by Windows so case sensitivity would not be relevant).
> >
> > Warning Will Robinson ! Mixing ADS and xattrs on the client side is a r=
eceipe for
> > confusion and disaster IMHO.
> >
> > They really are different things. No good will come of trying to mix
> > the two into one client namespace.
>

Solaris / Illumos had a neat feature where you could say openat(fd,
O_RDWR | O_XATTR) to open a stream on ZFS and then do normal file IO
to the stream (pread, pwrite, etc).
