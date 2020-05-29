Return-Path: <SRS0=w1sk=7L=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE84C433DF
	for <linux-cifs@archiver.kernel.org>; Fri, 29 May 2020 16:22:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 298A520C09
	for <linux-cifs@archiver.kernel.org>; Fri, 29 May 2020 16:22:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KtS/AZQ+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgE2QWs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 May 2020 12:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgE2QWs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 29 May 2020 12:22:48 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259FEC03E969
        for <linux-cifs@vger.kernel.org>; Fri, 29 May 2020 09:22:48 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id h21so2649634ejq.5
        for <linux-cifs@vger.kernel.org>; Fri, 29 May 2020 09:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xaH5wbqNtWNgcsNXw6Z6IK+vQ1NL/GRp0P6v65+530E=;
        b=KtS/AZQ+VyvPS/e73QZP3FxRC5GsAhxzL0+fhVeTeniDOIYqFWN3KQgOvHXbxnNnxz
         /IKocdUpSBRq1CVqs11o/XQjq5jN8suKkc2a4IzfSY1XQnYthkNe7e8i7hMcMMkGznDl
         AznFtoVDaN0sL3g4laZ5078hRw2VD92gL11L6Nmv/yN7AFH054FsA4PdrSg1I5XXlw+z
         UvLfO0moAKqy62TlR0oKZmVjEx/ju+cd8PC3MCak4hbk0pdqUVxGOUCYBHwGV81X7nwo
         19jn4AihKV55v2MOPIMh7gc/Qlh7WyepIbwcs52hHIBCH084/Of2yDjWKUUrZ5ALQYjh
         akeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xaH5wbqNtWNgcsNXw6Z6IK+vQ1NL/GRp0P6v65+530E=;
        b=dvCmtdHbyklRwAYikbIpiG7QFSFfhOyD6yNGtjO/pCkQZznPvkjBdWIQOTXKcSpjF2
         ZDS256tVoFRafmzAiEJqKn+2fJUZimUYqHepVBDupD43QQrS+mvQKlzTCS32NfxUZNTA
         1cKiAxxV5sLbQHWjwESzS+tbBKXS+hmkRwjjIDiKL4k7Y9cHcEfy1ufQ77k3csqXosbd
         2DZHXB/blSNWzZlJt0HNxtqDsleHmsZCwRy6vyN+xPVTHuJUBpIrNYQYvyCoKsQL051M
         1S+CuSOaK6wYr4Y34gdHxQhODSKNCn072U0JDwgF7+tN3gMoI1FAK3jIkXsx4Eg+pdtb
         4tBg==
X-Gm-Message-State: AOAM531uCm09NZHP5H0QpXoOGK2lDwqB9HZWkRMuGfzyjkWJPf3BBbZB
        YuZ+gAB1We4siggWKg9OchXBCG+USykDQbwxtw==
X-Google-Smtp-Source: ABdhPJy9uv1DG/RNW3gvfpddcq4KdP+Q3aSLOXcHNo1g/oCSIpm4EqGSek/t07+1IFQPP1POK6KkhX/kDUdw4uMl2wI=
X-Received: by 2002:a17:906:9404:: with SMTP id q4mr8281618ejx.138.1590769366767;
 Fri, 29 May 2020 09:22:46 -0700 (PDT)
MIME-Version: 1.0
References: <c9a53d2c-98ab-84a3-b395-aff537b9c882@meduniwien.ac.at>
 <CAH2r5msOOQ3BY+4L4MNDEJU1Lrer1gt0ZwdjE2K0zdurabthsQ@mail.gmail.com> <ad562231-c263-aebf-e1bb-a055c3aea211@meduniwien.ac.at>
In-Reply-To: <ad562231-c263-aebf-e1bb-a055c3aea211@meduniwien.ac.at>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 29 May 2020 09:22:35 -0700
Message-ID: <CAKywueQ6H=pJQXGWeF3mHUstSjjWMeC64DdKNSYBNSEQO=ss=A@mail.gmail.com>
Subject: Re: almost no CIFS stats?
To:     Matthias Leopold <matthias.leopold@meduniwien.ac.at>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

HI Matthias,

I remember Stats not working on CentOS 7 - showing zeros as you reported.

Adding Ronnie to comment.

--
Best regards,
Pavel Shilovsky

=D0=BF=D1=82, 29 =D0=BC=D0=B0=D1=8F 2020 =D0=B3. =D0=B2 01:18, Matthias Leo=
pold
<matthias.leopold@meduniwien.ac.at>:
>
> CentOS 7 has kernel 3.10 (modified by Red Hat)
>
> Am 28.05.20 um 23:31 schrieb Steve French:
> > Stats should show counters for most rows.   See example below:
> >
> > # cat /proc/fs/cifs/Stats
> > Resources in use
> > CIFS Session: 1
> > Share (unique mount targets): 2
> > SMB Request/Response Buffer: 1 Pool size: 5
> > SMB Small Req/Resp Buffer: 1 Pool size: 30
> > Operations (MIDs): 0
> >
> > 0 session 0 share reconnects
> > Total vfs operations: 36 maximum at one time: 2
> >
> > Max requests in flight: 3
> > 1) \\localhost\test
> > SMBs: 67
> > Bytes read: 90177536  Bytes written: 2
> > Open files: 0 total (local), 0 open on server
> > TreeConnects: 1 total 0 failed
> > TreeDisconnects: 0 total 0 failed
> > Creates: 12 total 0 failed
> > Closes: 13 total 1 failed
> > Flushes: 1 total 0 failed
> > Reads: 22 total 0 failed
> > Writes: 1 total 0 failed
> > Locks: 0 total 0 failed
> > IOCTLs: 1 total 1 failed
> > QueryDirectories: 2 total 0 failed
> > ChangeNotifies: 0 total 0 failed
> > QueryInfos: 12 total 0 failed
> > SetInfos: 2 total 0 failed
> > OplockBreaks: 0 sent 0 failed
> >
> >
> > Are you running an old kernel (pre-5.0 e.g.)?
> >
> > On Thu, May 28, 2020 at 3:39 PM Matthias Leopold
> > <matthias.leopold@meduniwien.ac.at> wrote:
> >>
> >> Hi,
> >>
> >> I'm trying to debug the performance of rsync reading from a Windows 20=
12
> >> R2 share mounted readonly in CentOS 7. I tried to use cifsiostat, whic=
h
> >> doesn't print any stats. I looked into /proc/fs/cifs/Stats and saw tha=
t
> >> it contains mostly "0" for counters (I would expect to see some number=
s
> >> for eg "Reads"). What am I doing wrong?
> >>
> >> options from /proc/mounts are
> >> ro,relatime,vers=3D3.0,cache=3Dstrict,username=3Dfoo,domain=3Dxxx,uid=
=3D1706,forceuid,gid=3D1676,forcegid,addr=3D10.110.81.122,file_mode=3D0660,=
dir_mode=3D0770,soft,nounix,serverino,mapposix,rsize=3D61440,wsize=3D104857=
6,echo_interval=3D60,actimeo=3D1
> >>
> >> thx
> >> Matthias
> >
> >
> >
>
> --
> Matthias Leopold
> IT Systems & Communications
> Medizinische Universit=C3=A4t Wien
> Spitalgasse 23 / BT 88 /Ebene 00
> A-1090 Wien
> Tel: +43 1 40160-21241
> Fax: +43 1 40160-921200
