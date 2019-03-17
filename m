Return-Path: <SRS0=cCOQ=RU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C89C43381
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Mar 2019 17:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C78442087C
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Mar 2019 17:13:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jP5un/AH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfCQRNq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 17 Mar 2019 13:13:46 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34492 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726639AbfCQRNq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 17 Mar 2019 13:13:46 -0400
Received: by mail-pf1-f196.google.com with SMTP id v64so9639586pfb.1;
        Sun, 17 Mar 2019 10:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w5WwgpJibWnoRYA72AGkiArywQzyCHHAAXsA+7daLXY=;
        b=jP5un/AHcgWSo1lnrpiCwOVHH80aqj807zuTZqGromsvme2HOPzXOUMeHn2xSJibOR
         W+/gplFCnuORz3iM/AKU8U1CdQsOeBcfnQrfRqEF+0yQGlDq9DVhUHoBH7KRwUeiN250
         oruM8sjeCgud0qEAT+mqrLvESh2te8QWZ+7vbiQYq/SUW2951Uhhhjl6pzV5caCVkXYD
         Zs64dhEupbfvzmmuW5q6ygzRMHG1DxZDDs/v6IuoN3NrFqGt45HmedgGbUyMFtVG9pmx
         sDDyaBdA9lOZU8sDK6m9Hcy6NlJfX37Qzqk89yLrkqCjrDoqY3xYvfA9aLxlfMtnV0xD
         1lWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w5WwgpJibWnoRYA72AGkiArywQzyCHHAAXsA+7daLXY=;
        b=ngBUh1qTzC/rx5pkLf66kaHL/kviVVlnGRHQnsC/C+G2b+5+GiswigH0GZRxS2Km9j
         JyAKCz6Myhx+pSiR08gLM/01xUUhzaJSIP7b9L9ZL+R7DfVzeeIWHxVCw5587xizj9ec
         35KzNXB77HGChRCcnvbDrWK29+zCiKstl1FQC742jpjF99xajAIGChW1gZLuDAfB6m7I
         R0R6AO3NiBh+NVwmReo+h1/JYI6R+aDBlowe50BP23dphTSNqGQbYOLMr86x6BqdAomA
         tv6anZc7Bg5CjgfWXjZP3nqNeWW5QzsU1lbVbfLJXwLGNzYRtiyx6tR7h6OB7hqNZVtZ
         gqCg==
X-Gm-Message-State: APjAAAWkOlsUuhQ+1UG73gvm4Ww1aAlqmeMFM/vYoYqFlwwUfRmOzYRs
        eEDwoDAld1GzVlllig3NlzMnklLouKyDprldzG4=
X-Google-Smtp-Source: APXvYqzJG6XhzoKib91Fxu/0ka/KfFDo1VUOwFTiKTctjqd1JOUE0J/oTzvB1yHTcPahBRRAyLhzJ1sfEdgJJsO/PEw=
X-Received: by 2002:a17:902:822:: with SMTP id 31mr15474034plk.290.1552842825112;
 Sun, 17 Mar 2019 10:13:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv0e3aZ1upukVL5ZJt8AtqjVQbpw=KuHH1DjYydKoyAaQ@mail.gmail.com>
 <CAN05THQTim0tqoje3A7ar3cBSkGkX-p8AM7EbjR2+tCAwk9-mw@mail.gmail.com> <CAOQ4uxg1t1+11OjBo7kAGz-r9LLtkKw=PVKa7uWF95Y2wDft8w@mail.gmail.com>
In-Reply-To: <CAOQ4uxg1t1+11OjBo7kAGz-r9LLtkKw=PVKa7uWF95Y2wDft8w@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 17 Mar 2019 12:13:33 -0500
Message-ID: <CAH2r5mtUrWF0a-TjVS6QEpDJGEA4-frzdST6TZfM0p-esTt3OA@mail.gmail.com>
Subject: Re: Suggestions for POSIX error code mapping for OBJECTID_NOT_FOUND
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I like the idea of ENOATTR as Amir suggested as in some sense it is
just extra metadata that this particular object doesn't have

On Sun, Mar 17, 2019 at 4:24 AM Amir Goldstein <amir73il@gmail.com> wrote:
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



-- 
Thanks,

Steve
