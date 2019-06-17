Return-Path: <SRS0=A3cw=UQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C6F9C31E5B
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Jun 2019 21:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F40D420673
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Jun 2019 21:33:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XE2SJOVQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfFQVdk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Jun 2019 17:33:40 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34389 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730090AbfFQVZr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Jun 2019 17:25:47 -0400
Received: by mail-lj1-f194.google.com with SMTP id p17so10837692ljg.1
        for <linux-cifs@vger.kernel.org>; Mon, 17 Jun 2019 14:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lNiBYiT9Pp+8r96YA0aKnZr+U8uH85TDSFdJzYqr6D4=;
        b=XE2SJOVQalk107+qXDQFQ7uRbMDEC9StP/hD1gLK5jroSSbBi0yGep2Lv3/zDbICoH
         BxNZmSIruCqWjQ9omDJalBm7/m2y/G26bl0jhvlda2EAhR7zOi1ABUYPtQMSDl97Tv3K
         MlcRt58kacpdun1Mf6lwK4UWu8wPtQgk79MPUNLnEZ/QoYiaTiLOSKUb5OqH5LzPnWKh
         Gd0amh3GjDHh1gQV5bHYHnCXVRg+CvPbuT48HLdySZRo5zv/n7nYRnCcyZfd0lXKZhQt
         GCXGkTQ1aW6EZ+rlXt4k31P15K/3+/SHF5KijJUvTLwLTj17Brr8/H/o2Tr3OgSZFzGJ
         buTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lNiBYiT9Pp+8r96YA0aKnZr+U8uH85TDSFdJzYqr6D4=;
        b=HLjgMMJKdWxRpak8ILNlsGzU1SX6uB1zazFCQm1HFsqSjg09DPnK/yIDZM/vQSMpVx
         PdeRerT7xrtXPC5cA1jbCDotHpl0RRoEbQ63gt8sbrc7KoWX1BAa/RvTDzqJ0edCgooT
         v6oskvzRT50plwbZzfbvTlKAZ/T23zEdy2t+rW/E5XxHCVqK0RYFMBFBPTj+kxHZLLRR
         bY2XS1iuWJnqE9zACREYyAl7NDkDc8cWec3cqNK7NxLEvd4jRuXmQP1LA9StDh2AeU2B
         S1cF2Jf7enT2A5ApKudPhIfAuw4AP8/I40jOkd6mt0sam3QOQrbYMQ1HE0iNN393pekj
         oL0A==
X-Gm-Message-State: APjAAAWyWK1V8xxhaz8H25dNIKqis0v78bBnLlZOoh/f7mqoQUADoBIe
        fs+OBIL2WMxVboPbZ5CcCSQgK0DPTMecM80C8A==
X-Google-Smtp-Source: APXvYqyoez6UPHcVwWSuagUzE5RNM2VqcFD21F/eyWDl99tmpBjI0HtWiguGNyHXd1hXO7pQx2nk7YurVLszM2FZEbc=
X-Received: by 2002:a05:651c:87:: with SMTP id 7mr43496971ljq.184.1560806744685;
 Mon, 17 Jun 2019 14:25:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvo9sWf8VoPb8puCDh4HM6WnrMgjs+HyhUzqEZXtuQwtA@mail.gmail.com>
 <CAH2r5mtC5cXkhAVrioy_cLeoTq_4Jq0nw3CR4HTiEP_twSSKJg@mail.gmail.com> <CAN05THQaHUATgVy=5AKksQ+FciLxP=uuC1PwHe5gLm+g=Qz-aw@mail.gmail.com>
In-Reply-To: <CAN05THQaHUATgVy=5AKksQ+FciLxP=uuC1PwHe5gLm+g=Qz-aw@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 17 Jun 2019 14:25:33 -0700
Message-ID: <CAKywueSMK8Cns9B5gKwuiyzP0V8nbJ3H0YKamDn7Zu9M7nzWDw@mail.gmail.com>
Subject: Re: NT_STATUS_INSUFFICIENT_RESOURCES and retrying writes to Windows
 10 servers
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Paulo Alcantara <paulo@paulo.ac>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky

=D0=BF=D0=BD, 17 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 13:46, ronnie sahl=
berg <ronniesahlberg@gmail.com>:
>
> Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
>
> On Tue, Jun 18, 2019 at 5:51 AM Steve French <smfrench@gmail.com> wrote:
> >
> > Attached is a patch with updated comments and cc:stable:
> >
> >
> > On Sat, Jun 15, 2019 at 11:18 PM Steve French <smfrench@gmail.com> wrot=
e:
> > >
> > > By default large file copy to Windows 10 can return MANY potentially
> > > retryable errors on write (which we don't retry from the Linux cifs
> > > client) which can cause cp to fail.
> > >
> > > It did look like my patch for the problem worked (see below).  Window=
s
> > > 10 returns *A LOT* (about 1/3 of writes in some cases I tried) of
> > > NT_STATUS_INSUFFICIENT_RESOURCES errors (presumably due to the
> > > 'blocking operation credit' max of 64 in Windows 10 - see note 203 of
> > > MS-SMB2).
> > >
> > > "<203> Section 3.3.4.2: Windows-based servers enforce a configurable
> > > blocking operation credit,
> > > which defaults to 64 on Windows Vista SP1, Windows 7, Windows 8,
> > > Windows 8.1, and, Windows 10,
> > > and defaults to 512 on Windows Server 2008, Windows Server 2008 R2,
> > > Windows Server 2012 ..."
> > >
> > > This patch did seem to work around the problem, but perhaps we should
> > > use far fewer credits when mounting to Windows 10 even though they ar=
e
> > > giving us enough credits for more? Or change how we do writes to not
> > > do synchronous writes? I haven't seen this problem to Windows 2016 or
> > > 2019 but perhaps the explanation on note 203  is all we need to know
> > > ... ie that clients can enforce a lower limit than 512
> > >
> > > ~/cifs-2.6/fs/cifs$ git diff -a
> > > diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
> > > index e32c264e3adb..82ade16c9501 100644
> > > --- a/fs/cifs/smb2maperror.c
> > > +++ b/fs/cifs/smb2maperror.c
> > > @@ -457,7 +457,7 @@ static const struct status_to_posix_error
> > > smb2_error_map_table[] =3D {
> > >         {STATUS_FILE_INVALID, -EIO, "STATUS_FILE_INVALID"},
> > >         {STATUS_ALLOTTED_SPACE_EXCEEDED, -EIO,
> > >         "STATUS_ALLOTTED_SPACE_EXCEEDED"},
> > > -       {STATUS_INSUFFICIENT_RESOURCES, -EREMOTEIO,
> > > +       {STATUS_INSUFFICIENT_RESOURCES, -EAGAIN,
> > >                                 "STATUS_INSUFFICIENT_RESOURCES"},
> > >         {STATUS_DFS_EXIT_PATH_FOUND, -EIO, "STATUS_DFS_EXIT_PATH_FOUN=
D"},
> > >         {STATUS_DEVICE_DATA_ERROR, -EIO, "STATUS_DEVICE_DATA_ERROR"},
> > >
> > >
> > > e.g. see the number of write errors in my 8GB copy in my test below
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
> > > Total vfs operations: 363 maximum at one time: 2
> > >
> > > 1) \\10.0.3.4\public-share
> > > SMBs: 14879
> > > Bytes read: 0  Bytes written: 8589934592
> > > Open files: 2 total (local), 0 open on server
> > > TreeConnects: 3 total 0 failed
> > > TreeDisconnects: 0 total 0 failed
> > > Creates: 12 total 0 failed
> > > Closes: 10 total 0 failed
> > > Flushes: 0 total 0 failed
> > > Reads: 0 total 0 failed
> > > Writes: 14838 total 5624 failed
> > > ...
> > >
> > > Any thoughts?
> > >
> > > Any risk that we could run into places where EAGAIN would not be
> > > handled (there are SMB3 commands other than read and write where
> > > NT_STATUS_INSUFFICIENT_RESOURCES could be returned in theory)
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
