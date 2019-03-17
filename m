Return-Path: <SRS0=cCOQ=RU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D9BFC10F05
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Mar 2019 10:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D5B621871
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Mar 2019 10:01:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KfX3jmOB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfCQKBT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 17 Mar 2019 06:01:19 -0400
Received: from mail-yw1-f46.google.com ([209.85.161.46]:39903 "EHLO
        mail-yw1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbfCQKBS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 17 Mar 2019 06:01:18 -0400
Received: by mail-yw1-f46.google.com with SMTP id z191so10684719ywa.6;
        Sun, 17 Mar 2019 03:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J6+B8aim9iVOKMj7CAQmho1OiVrlDiToHXMxwUMZpyE=;
        b=KfX3jmOBCt4WOdE5QzWj6VN9FNJpynFiErHj6Nrlrc/QI2fm3dufclpV4r/Nmlc9vK
         MpYbr/1uJElwWA3MPOcaKUJUhkKictrjpI3cfBFA1Bl5zAMZ2+g2UEjRPvG5NbxE2sl4
         wqmThKxz+PUVvRiQO0Np4/M7xbOw1nhxkb29193b3lo6TiyCywBiyO54QWH86/9CQnFP
         7GSWip2Cs/Dik/PQGAFiEV/KyBC+qWNilu2up38QTmsp4wDBfPYUVEPSgRRgG6PwRM3Q
         pb2R7AgPwQm0LOTbQD4PbQttdKLOJAIGm7fxR2S6sDEYXkAig7tcy5rVPphf8tsYFvXJ
         NNpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J6+B8aim9iVOKMj7CAQmho1OiVrlDiToHXMxwUMZpyE=;
        b=syXVNPr3naEHbRkfCD6lo/PPevt37DNjdq+wUQVvrMzsbS9NOLeUComwgRLaWoCTtc
         zlwPOv/0WZgB6WI0n/RjxapxUSIBpAGEc95O9oxb/uegq7EYEbhcsWlN1YqyzrnV/ot4
         CQ83mn7obMGsugnrrJSQnWsWXNt/pIP2qKl3rEGGIjlD+vfL7yMIPB+DGAsi34cN2jSm
         o97UqHzWbgx+qBEkDHXI33o+HDXaR1WbJzrUeteh8I0RSj/jf8ysUBbf2cfbCUfz8kuE
         USRcqx+Zs2QPwRosqlq9P6xzV8J2scskHPjonMFn+GYmzTbh3rFmDB92UMzF8wl1eYHG
         lDTA==
X-Gm-Message-State: APjAAAVQ2Ql8cVISt/n9ttgULDLMXaYUQmqE7RU+1zrpi+l4iAonfpm2
        osI/Mc/y8sk0AHNUY5NpDcifPfyeypSkiqxqbJ0=
X-Google-Smtp-Source: APXvYqwe87blpKm6v8oII8mRTLhaua1GuXaGcUx8/cfn0oLBvqqALpgzptcmXu3se+9HimlG/NS7ESaRaVkdsC/JKY8=
X-Received: by 2002:a5b:c05:: with SMTP id f5mr10162218ybq.337.1552816877558;
 Sun, 17 Mar 2019 03:01:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv0e3aZ1upukVL5ZJt8AtqjVQbpw=KuHH1DjYydKoyAaQ@mail.gmail.com>
 <CAN05THQTim0tqoje3A7ar3cBSkGkX-p8AM7EbjR2+tCAwk9-mw@mail.gmail.com>
 <CAOQ4uxg1t1+11OjBo7kAGz-r9LLtkKw=PVKa7uWF95Y2wDft8w@mail.gmail.com> <CAN05THRBqi2RoEq5CcM15Z7M_A1V7Vn27x8v9w5EPHarMgTsuQ@mail.gmail.com>
In-Reply-To: <CAN05THRBqi2RoEq5CcM15Z7M_A1V7Vn27x8v9w5EPHarMgTsuQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 17 Mar 2019 12:01:06 +0200
Message-ID: <CAOQ4uxgQHn7tRSnXF+ZLpLdVyjNiZj3M9LpFaucq3AaaSf_GKQ@mail.gmail.com>
Subject: Re: Suggestions for POSIX error code mapping for OBJECTID_NOT_FOUND
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Mar 17, 2019 at 11:36 AM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> I think they are a little bit different in that NFS handles are only
> temporal while these guys are supposed to be immutable forever once
> created.
>

NFS handles are not temporal. On the contrary. They are expected to
persist a server reboot. Most filesystems implement them as a combination
of (at least) inode number and generation number.

> NTFS object ids are supposed to be persistent across infinite time
> once they are created.
> I.e. once a file has for example a Birth-Object-Id, I think that is
> immutable for the lifetime of the fs object.
> Not all objects in NTFS automatically get a ObjId assigned as far as
> my testing goes
> but if it is missing we can just switch to the Create-Or-Get-Object-Id
> fcntl call in which case the server will make one up and assign to the
> object if there is none yet.
>
> On Sun, Mar 17, 2019 at 7:24 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Sun, Mar 17, 2019 at 10:57 AM ronnie sahlberg via samba-technical
> > <samba-technical@lists.samba.org> wrote:
> > >
> > > ENOENT / ENOTSUPP / EINVAL?
> > >
> > > ENOENT feels appropriate since this is not a permanent condition.
> > > Someone could create the object buffer after which it will exist and
> > > there will no longer be an errror when asking for it.
> > >
> > > I guess for a long time smbinfo.c will be the only consumer for this
> > > on the non-windows side  so whatever we decide will be what will be
> > > how things are and others will follow.
> > >
> > > On Sun, Mar 17, 2019 at 6:40 PM Steve French <smfrench@gmail.com> wrote:
> > > >
> > > > Any thoughts as to the best POSIX error code to map status code
> > > > "0xC00002F0 STATUS_OBJECTID_NOT_FOUND" to?
> > > >
> > > > It means an object ID was not found for the file, which is a
> > > > reasonably common situation over the network even to Windows servers.
> > > >
> > > > I was mapping it to EIO for cases where tools asks for the object id
> > > > of the file (or volume).
> > > >
> >
> > If I am reading NTFS documentation correctly, then Object ID is
> > a similar beast to NFS file handle you get with name_to_handle_at().
> > NTFS supports Object IDs since Windows 2000, but an upgrade
> > doesn't set object ids to existing files - those can be added manually.
> >
> > In Linux, a file system either supports NFS file handles or it doesn't.
> > In the first case, ENOTSUPP is returned from name_to_handle_at().
> > IMO, its a valid case to return ENOTSUPP per file, but if you
> > consider that NTFS treats Object ID as extra information attached to
> > the inode, returning ENOATTR (like from getxattr) may be a valid
> > option for cifs. It really depends on which tools would see this
> > errors and what errors they would expect.
> >
> > Thanks,
> > Amir.
