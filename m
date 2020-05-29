Return-Path: <SRS0=w1sk=7L=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15639C433E1
	for <linux-cifs@archiver.kernel.org>; Fri, 29 May 2020 18:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB434206A4
	for <linux-cifs@archiver.kernel.org>; Fri, 29 May 2020 18:18:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mcqu79Oj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgE2SSy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 May 2020 14:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgE2SSx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 29 May 2020 14:18:53 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B76C03E969
        for <linux-cifs@vger.kernel.org>; Fri, 29 May 2020 11:18:53 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id n123so1567170ybf.11
        for <linux-cifs@vger.kernel.org>; Fri, 29 May 2020 11:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xzzgh/2sH7jIVA7sN7ONrOXqfM84bt8RN/5Ywd7CWhc=;
        b=mcqu79OjunjTsSLd4vf9Xx+kthN6oaKq0kAhXckVty1q58vTKpUW9guQg+VSUx1YfA
         fxbrbYmQs4FR+oZQARIgc9Y+nO045Br4NHWy/xdrctUrERkENA3XWQybDAi8gOyXXZ82
         LSdYsgE58gyEhXn4l1Gns68LsUlxRdfAx5YW8UBUWI+aC45Iy8oEPtlKBbIWEbm7wDGI
         5VxCFRCuAARMAXCF4jhqRUYK2gkaQRnzxXE3tTqxBLm91lfldSRrHE5tDfaRcppdUXFf
         1xeSewMcLxRqpRgPG8dI1thNcjJdxN2zfUT+P/GtD5PZBFjDrPEKEJPXR7cwVXCMGt4Q
         qw1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xzzgh/2sH7jIVA7sN7ONrOXqfM84bt8RN/5Ywd7CWhc=;
        b=ZVt0EqTC5Ak+xZ1MRyjiuqS4JL8I0DBPlbMcj1eB6q933SsCWKftx7sFmdzYMPQEeF
         HuBeoM/VMYNZiTwt+n0sF2xrEFdtWLz0gwq0soYT3yVp+mSAEX5NTTE7iEwTXv6kyhki
         ulKFJTeSl80O/WpQjOZwb8MorTTLek5f1pBPIBMgiu98dLwuHxh83q1EcBPzc6Tp1BoT
         WiUPjwrTaPSwsuo+dTPQntfCB8ZrlqvaGArM9rKUk1bnFQEnIUpKcDymcjsKmZYy6Gm8
         KeV02+hm49MA/H3nvcTHJHreQ4DJzj3m7v42SCqJg9Nw9KrgQg3EGTXuSxrRmxiKZs//
         J3eQ==
X-Gm-Message-State: AOAM530kMfYVBWdsETEg3dHkI2E4o+P6bk0zYKCWNs4wcf+KVreIUwKl
        hynQfgYg9TFVfxgzPmZNjQ9B7s8VYyxC0hvko70=
X-Google-Smtp-Source: ABdhPJyhcOMEWBKAFhyO9pO16M/ck8MnPusHPv8g+LTOVINq38gF8DFNeB4242jqSYeoq3cvyMzT58F0YD4Vm/Tv+KQ=
X-Received: by 2002:a25:6c6:: with SMTP id 189mr5060672ybg.375.1590776332800;
 Fri, 29 May 2020 11:18:52 -0700 (PDT)
MIME-Version: 1.0
References: <c9a53d2c-98ab-84a3-b395-aff537b9c882@meduniwien.ac.at>
 <CAH2r5msOOQ3BY+4L4MNDEJU1Lrer1gt0ZwdjE2K0zdurabthsQ@mail.gmail.com>
 <ad562231-c263-aebf-e1bb-a055c3aea211@meduniwien.ac.at> <CAKywueQ6H=pJQXGWeF3mHUstSjjWMeC64DdKNSYBNSEQO=ss=A@mail.gmail.com>
In-Reply-To: <CAKywueQ6H=pJQXGWeF3mHUstSjjWMeC64DdKNSYBNSEQO=ss=A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 29 May 2020 13:18:41 -0500
Message-ID: <CAH2r5mtEGY=qfDagw7s6sTiTPhy2h6vOdA_iH0PCJBROQ9RmfQ@mail.gmail.com>
Subject: Re: almost no CIFS stats?
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Matthias Leopold <matthias.leopold@meduniwien.ac.at>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHEL7 (and related like CentOS7) did not enable stats by default in
the build (unless Ronnie changed it in later service packs) but the
last 3 RHEL version (RHEL8.2, 8.1, 8.0 and CentOS equivalents) do have
stats enabled.  Remember the 3.10 kernel is 7 years old so many things
are missing from it.

Note that for additional stats, including timing (slowest, fastest,
and total time by command), private builds can be done of cifs.ko with
CONFIG_CIFS_STATS2.

I suggest trying it on a more recent version of RHEL or CentOS if
possible (although even for this 7 year old kernel rebuilding cifs.ko
with CONFIG_CIFS_STATS enabled is not too hard if you have the source
RPMs installed).

On Fri, May 29, 2020 at 11:22 AM Pavel Shilovsky <piastryyy@gmail.com> wrot=
e:
>
> HI Matthias,
>
> I remember Stats not working on CentOS 7 - showing zeros as you reported.
>
> Adding Ronnie to comment.
>
> --
> Best regards,
> Pavel Shilovsky
>
> =D0=BF=D1=82, 29 =D0=BC=D0=B0=D1=8F 2020 =D0=B3. =D0=B2 01:18, Matthias L=
eopold
> <matthias.leopold@meduniwien.ac.at>:
> >
> > CentOS 7 has kernel 3.10 (modified by Red Hat)
> >
> > Am 28.05.20 um 23:31 schrieb Steve French:
> > > Stats should show counters for most rows.   See example below:
> > >
> > > # cat /proc/fs/cifs/Stats
> > > Resources in use
> > > CIFS Session: 1
> > > Share (unique mount targets): 2
> > > SMB Request/Response Buffer: 1 Pool size: 5
> > > SMB Small Req/Resp Buffer: 1 Pool size: 30
> > > Operations (MIDs): 0
> > >
> > > 0 session 0 share reconnects
> > > Total vfs operations: 36 maximum at one time: 2
> > >
> > > Max requests in flight: 3
> > > 1) \\localhost\test
> > > SMBs: 67
> > > Bytes read: 90177536  Bytes written: 2
> > > Open files: 0 total (local), 0 open on server
> > > TreeConnects: 1 total 0 failed
> > > TreeDisconnects: 0 total 0 failed
> > > Creates: 12 total 0 failed
> > > Closes: 13 total 1 failed
> > > Flushes: 1 total 0 failed
> > > Reads: 22 total 0 failed
> > > Writes: 1 total 0 failed
> > > Locks: 0 total 0 failed
> > > IOCTLs: 1 total 1 failed
> > > QueryDirectories: 2 total 0 failed
> > > ChangeNotifies: 0 total 0 failed
> > > QueryInfos: 12 total 0 failed
> > > SetInfos: 2 total 0 failed
> > > OplockBreaks: 0 sent 0 failed
> > >
> > >
> > > Are you running an old kernel (pre-5.0 e.g.)?
> > >
> > > On Thu, May 28, 2020 at 3:39 PM Matthias Leopold
> > > <matthias.leopold@meduniwien.ac.at> wrote:
> > >>
> > >> Hi,
> > >>
> > >> I'm trying to debug the performance of rsync reading from a Windows =
2012
> > >> R2 share mounted readonly in CentOS 7. I tried to use cifsiostat, wh=
ich
> > >> doesn't print any stats. I looked into /proc/fs/cifs/Stats and saw t=
hat
> > >> it contains mostly "0" for counters (I would expect to see some numb=
ers
> > >> for eg "Reads"). What am I doing wrong?
> > >>
> > >> options from /proc/mounts are
> > >> ro,relatime,vers=3D3.0,cache=3Dstrict,username=3Dfoo,domain=3Dxxx,ui=
d=3D1706,forceuid,gid=3D1676,forcegid,addr=3D10.110.81.122,file_mode=3D0660=
,dir_mode=3D0770,soft,nounix,serverino,mapposix,rsize=3D61440,wsize=3D10485=
76,echo_interval=3D60,actimeo=3D1
> > >>
> > >> thx
> > >> Matthias
> > >
> > >
> > >
> >
> > --
> > Matthias Leopold
> > IT Systems & Communications
> > Medizinische Universit=C3=A4t Wien
> > Spitalgasse 23 / BT 88 /Ebene 00
> > A-1090 Wien
> > Tel: +43 1 40160-21241
> > Fax: +43 1 40160-921200



--=20
Thanks,

Steve
