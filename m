Return-Path: <SRS0=cCOQ=RU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D89C43381
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Mar 2019 09:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80F4621019
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Mar 2019 09:36:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MA1nC1OB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfCQJgm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 17 Mar 2019 05:36:42 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33850 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbfCQJgl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 17 Mar 2019 05:36:41 -0400
Received: by mail-qt1-f196.google.com with SMTP id k2so14836333qtm.1;
        Sun, 17 Mar 2019 02:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kQ2M9X1kpdPuaOt6PmsEkEkCiiD78H7MLdm6MgLd9zs=;
        b=MA1nC1OBiKb4RgjJm9UDHwA236MpnxmB3QTn15I6H5J/Y6U4BY+EZjrPApwTwgUKvX
         kTBOXSKuxhIt3BYOYaOTRi2Tc45gX3Rp08ULGlbEhKIaqjRABQyqyquqpURs8SPfwi+e
         gUXm9ffY90G9VajXO6C06uvJ/WUvO8XXsE7ONgae9yuznRbaZM0RYC1CkWYfIF6Ks8Tr
         2ytqY+H+JaRdGbfJViYp3D5yBG9XmdNvL7lVEReW9a/Ybx76nPC168/FYKE6uGU3AApv
         IrBX7A9oPp+ymfO/PXP0IcnsnvAIgWxmNtLDbIRVYNsP6XFZVnpiwPadNYNHqzzuPn08
         NAnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kQ2M9X1kpdPuaOt6PmsEkEkCiiD78H7MLdm6MgLd9zs=;
        b=guSyf4vz/dZ3vIIFG/OFUc/Jthatu+2XAr6JjWx41opg+qWBDd1Tg8CO+LwHyeFgbr
         vJaUrttwOcYUXuzeE8yJJjo/gKtVlC8mgIagDidvWYb112JYrlRY+XnHdPaPxJ+xrXh4
         1DHSD/lMZttkubaG6wm9F/e4j1+ArCsS/xB2x7NKRRTlq/+gjAkZxdfEWz5zAIcrDTDD
         aE2Mrg6TBYdYxK/OooMhibRqFFNgAcxc9u07yz1KCHNKYDU1kpQ62S6FDCy7jkUZ4YGG
         DTE1p2oMX23tGbdpfF+By0nMzMmrfEbZ2kGO5xo12vCDex9KfFr/+HyAsHJIdRjA3zRq
         l6gA==
X-Gm-Message-State: APjAAAWTzluMVLDtxAQgf4BfRAOCZs7KpMGHRMO58zawUNQJEdZybwfy
        rOpg/c1szES+kjOt5E01K63iDtYsRI8LEQqM0Fo=
X-Google-Smtp-Source: APXvYqyiJd60nIqMKo84klCWr2PkabVLxGLAec1PwceD0DS8P0Ps1snma/zj04nN0iv0WzORESEtS6GUf3tHDJ7iwXI=
X-Received: by 2002:aed:3947:: with SMTP id l65mr9049437qte.86.1552815400912;
 Sun, 17 Mar 2019 02:36:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv0e3aZ1upukVL5ZJt8AtqjVQbpw=KuHH1DjYydKoyAaQ@mail.gmail.com>
 <CAN05THQTim0tqoje3A7ar3cBSkGkX-p8AM7EbjR2+tCAwk9-mw@mail.gmail.com> <CAOQ4uxg1t1+11OjBo7kAGz-r9LLtkKw=PVKa7uWF95Y2wDft8w@mail.gmail.com>
In-Reply-To: <CAOQ4uxg1t1+11OjBo7kAGz-r9LLtkKw=PVKa7uWF95Y2wDft8w@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Sun, 17 Mar 2019 19:36:29 +1000
Message-ID: <CAN05THRBqi2RoEq5CcM15Z7M_A1V7Vn27x8v9w5EPHarMgTsuQ@mail.gmail.com>
Subject: Re: Suggestions for POSIX error code mapping for OBJECTID_NOT_FOUND
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I think they are a little bit different in that NFS handles are only
temporal while these guys are supposed to be immutable forever once
created.

NTFS object ids are supposed to be persistent across infinite time
once they are created.
I.e. once a file has for example a Birth-Object-Id, I think that is
immutable for the lifetime of the fs object.
Not all objects in NTFS automatically get a ObjId assigned as far as
my testing goes
but if it is missing we can just switch to the Create-Or-Get-Object-Id
fcntl call in which case the server will make one up and assign to the
object if there is none yet.

On Sun, Mar 17, 2019 at 7:24 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Sun, Mar 17, 2019 at 10:57 AM ronnie sahlberg via samba-technical
> <samba-technical@lists.samba.org> wrote:
> >
> > ENOENT / ENOTSUPP / EINVAL?
> >
> > ENOENT feels appropriate since this is not a permanent condition.
> > Someone could create the object buffer after which it will exist and
> > there will no longer be an errror when asking for it.
> >
> > I guess for a long time smbinfo.c will be the only consumer for this
> > on the non-windows side  so whatever we decide will be what will be
> > how things are and others will follow.
> >
> > On Sun, Mar 17, 2019 at 6:40 PM Steve French <smfrench@gmail.com> wrote:
> > >
> > > Any thoughts as to the best POSIX error code to map status code
> > > "0xC00002F0 STATUS_OBJECTID_NOT_FOUND" to?
> > >
> > > It means an object ID was not found for the file, which is a
> > > reasonably common situation over the network even to Windows servers.
> > >
> > > I was mapping it to EIO for cases where tools asks for the object id
> > > of the file (or volume).
> > >
>
> If I am reading NTFS documentation correctly, then Object ID is
> a similar beast to NFS file handle you get with name_to_handle_at().
> NTFS supports Object IDs since Windows 2000, but an upgrade
> doesn't set object ids to existing files - those can be added manually.
>
> In Linux, a file system either supports NFS file handles or it doesn't.
> In the first case, ENOTSUPP is returned from name_to_handle_at().
> IMO, its a valid case to return ENOTSUPP per file, but if you
> consider that NTFS treats Object ID as extra information attached to
> the inode, returning ENOATTR (like from getxattr) may be a valid
> option for cifs. It really depends on which tools would see this
> errors and what errors they would expect.
>
> Thanks,
> Amir.
