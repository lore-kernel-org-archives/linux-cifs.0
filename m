Return-Path: <SRS0=cCOQ=RU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFD1C43381
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Mar 2019 09:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F20FE20811
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Mar 2019 09:24:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p/m2r4D6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfCQJY0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 17 Mar 2019 05:24:26 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:45018 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfCQJY0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 17 Mar 2019 05:24:26 -0400
Received: by mail-yw1-f67.google.com with SMTP id c4so10645139ywa.11;
        Sun, 17 Mar 2019 02:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zNdZv04hkELM486EFTY5ruq3v/9DTgEEQnJL9e/9cPk=;
        b=p/m2r4D6RK6UzEtRUzvG0Fq+wxKtMFtjzwztZ4Fi3ncKH0YhbgPsZEm7Zk6x5GY+Nv
         /A66WcKTF4AtKPmNs5QCvOjTmxJ6bjsrDReoSHuueYOl4MZaM+Jkf50BETA++672Uw1Z
         vzFG/ETrQ50Te5ThigaRnYfbNaZWNJ5fPS6vcNuRSjqhNnlnhEX7RwTPXSRYx4J5Urkd
         sWfEI0/5b3+mh3EPKNucW5oZKN2yY1LCqj8c3F2qL1e2NtzcqTFP/qNsAWQNtX3R5qF7
         0C6I3xbzVgBWVc1+hJu2kC1Dek0ofz7WAETq7mEWUUMwmsqAcZ1veGV8zBRgR3XOtCJU
         yt/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zNdZv04hkELM486EFTY5ruq3v/9DTgEEQnJL9e/9cPk=;
        b=sBqdjYmFMdeRLaNyWYBu5ZTVvrQtgmpXl2TSPzDMUG6qUsp6GoCu1eImHHFnnOUawE
         o5nyWOnnBULbXPKNhaMO4wbkm8sEghEvHFUY4gXxAEOfJQeNKZqxGLloAdH+AAoOGu+E
         6S+EzvqXR8PhYx5tAvVZ9BUWhTBYmbK33RZrGAzfTlDUWl+RtJpDK6wEpjaT2B0XCROZ
         GahCPGG2XEdouktBS0igwaDUK0smsuO1cNjFDg5RNgNWlVaJF6fjdrlg0KTJ3awq9z/3
         kFJB9BSTTc8pOhZrsYgqiDxsK6Wsdje5Kf6fmAzsHNnI8vnxStjNu2g2PzTjbFnyxyL9
         KfjA==
X-Gm-Message-State: APjAAAVN5RO+ga/29HX1DyFAltA70lbPg/vHEjnePVgbsybFdXThtEL/
        M0cQtu1CmwVmyCbs4o73uczUUtR7YiJUF+LxI3k=
X-Google-Smtp-Source: APXvYqyi8341elAr+BCLgI9F5CvJKFmR+UClgVcjhGAiTsAGo5yFriPLR+yqi2SdgV2bcHrWvBvelZR/YMEEhNOP1jI=
X-Received: by 2002:a81:110c:: with SMTP id 12mr9527805ywr.241.1552814665034;
 Sun, 17 Mar 2019 02:24:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv0e3aZ1upukVL5ZJt8AtqjVQbpw=KuHH1DjYydKoyAaQ@mail.gmail.com>
 <CAN05THQTim0tqoje3A7ar3cBSkGkX-p8AM7EbjR2+tCAwk9-mw@mail.gmail.com>
In-Reply-To: <CAN05THQTim0tqoje3A7ar3cBSkGkX-p8AM7EbjR2+tCAwk9-mw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 17 Mar 2019 11:24:14 +0200
Message-ID: <CAOQ4uxg1t1+11OjBo7kAGz-r9LLtkKw=PVKa7uWF95Y2wDft8w@mail.gmail.com>
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

On Sun, Mar 17, 2019 at 10:57 AM ronnie sahlberg via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> ENOENT / ENOTSUPP / EINVAL?
>
> ENOENT feels appropriate since this is not a permanent condition.
> Someone could create the object buffer after which it will exist and
> there will no longer be an errror when asking for it.
>
> I guess for a long time smbinfo.c will be the only consumer for this
> on the non-windows side  so whatever we decide will be what will be
> how things are and others will follow.
>
> On Sun, Mar 17, 2019 at 6:40 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Any thoughts as to the best POSIX error code to map status code
> > "0xC00002F0 STATUS_OBJECTID_NOT_FOUND" to?
> >
> > It means an object ID was not found for the file, which is a
> > reasonably common situation over the network even to Windows servers.
> >
> > I was mapping it to EIO for cases where tools asks for the object id
> > of the file (or volume).
> >

If I am reading NTFS documentation correctly, then Object ID is
a similar beast to NFS file handle you get with name_to_handle_at().
NTFS supports Object IDs since Windows 2000, but an upgrade
doesn't set object ids to existing files - those can be added manually.

In Linux, a file system either supports NFS file handles or it doesn't.
In the first case, ENOTSUPP is returned from name_to_handle_at().
IMO, its a valid case to return ENOTSUPP per file, but if you
consider that NTFS treats Object ID as extra information attached to
the inode, returning ENOATTR (like from getxattr) may be a valid
option for cifs. It really depends on which tools would see this
errors and what errors they would expect.

Thanks,
Amir.
