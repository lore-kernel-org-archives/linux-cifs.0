Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45724C5479D
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Jan 2023 20:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbjAKUTE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Jan 2023 15:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236651AbjAKUSg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Jan 2023 15:18:36 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E989665DB
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jan 2023 12:18:35 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id n5so16681594ljc.9
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jan 2023 12:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OuAqUbtewGwr+v/Y8W0XWbbzzUwXB74wwOYjozDMCO0=;
        b=ZVoNA2Rc0sNojqfTHc0RrdD1pWVZcmltdMJu7OCGAgMLG6falJpRZzG2LdGRgzznH4
         EC7A5v3JoEocKCTKWagktCVew5yTyHCBQV40TLirClrKb8I91V0lhbNrh3Rn0mdCNgMm
         B6tMm3X+c4KGUNqqRL0MuWfzTwfKCWcsLNRNFUyi2sGFS5m3tXFdRFRFFzQbQCEvBK3l
         JsIKoIDnsNNfACGRJJW6Y4dFZXEp55Z5c6If25cEykPoHmKK5F3bk/U/Mr1B06EKdMoD
         w7SWZPIxuxmQUz4ZEUOHlx/PRdf3Qpd/hwhWKCvbGU707ereS/CQYpMYcptEe2i3MvLn
         Stlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OuAqUbtewGwr+v/Y8W0XWbbzzUwXB74wwOYjozDMCO0=;
        b=LFTJEOriKfuKYhMyz6yDJGK3sPdO2+HKBO1nx1lVyrRqxV41PBbLrkcBrFStjC5obN
         CLB2S5aTC/OHgBvC5vb6h+dGS+PIsau+aGgjJlda3tSKIlUDnEe8eMfKWkjsdcsFHGPK
         nvIgJlV1HAcaBdwlYgpsAL7yVzM6wuabL3UlzWjoUxaNTQ2leXtAlXVAVAXbf4PQEKts
         KzeOEbFNiwf6LwDlYm2nlIpILvZ+lsn8rEQlroSTRbl/bUi9YXaCDuEtAFY33d+F+o3N
         L99NCDyL+4vzU420uIRsBjpvjyxp/xRCMevLWmes85Ky6kCs31bCoTXQd/f/WC8hZSy/
         Jofw==
X-Gm-Message-State: AFqh2kq0ci+fiqAK9SwOx4uUblNiJEGeHGHRm1QoduUN3htbCJAjbnkL
        WAziG+Z2YJvBkvl8pU9a98bUSHvWZhsjbv3P5zg=
X-Google-Smtp-Source: AMrXdXsOd2vDnZb5UKAEJ5XdQ/XRLOr3dMzb9VHF8WGDxV/rJhIgwKRNwbqP93fbT/pMTXFsk9yRkqmOxAAQOEWlh+g=
X-Received: by 2002:a05:651c:1616:b0:280:1eda:77d4 with SMTP id
 f22-20020a05651c161600b002801eda77d4mr1272771ljq.226.1673468314107; Wed, 11
 Jan 2023 12:18:34 -0800 (PST)
MIME-Version: 1.0
References: <Y76gvH9ADxSgAxSw@sernet.de> <CAH2r5muTjUB7LBevcKE6oxWHPrm6yxY7H5jRuECMLbebQyRXpg@mail.gmail.com>
 <Y77pJ5LqbeU5uj8N@sernet.de>
In-Reply-To: <Y77pJ5LqbeU5uj8N@sernet.de>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 11 Jan 2023 14:18:22 -0600
Message-ID: <CAH2r5mvw-i2aLv5sH4L1LUPT-OBWGeHhso7T=yiK8YDSm6GyaA@mail.gmail.com>
Subject: Re: Fix posix 311 symlink creation mode
To:     Volker.Lendecke@sernet.de
Cc:     CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>,
        Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending testing

On Wed, Jan 11, 2023 at 10:51 AM Volker Lendecke
<Volker.Lendecke@sernet.de> wrote:
>
> Am Wed, Jan 11, 2023 at 10:21:07AM -0600 schrieb Steve French:
> > Should this be 0777 instead of 0644?
> >
> > I noticed the man page for symlink says:
> >
> >      "On Linux, the permissions of an ordinary symbolic link are not
> >        used in any operations; the permissions are always 0777 (read,
> >        write, and execute for all user categories), and can't be
> >        changed."
>
> I thought about that as well. If you "ls -l" such a symlink once
> created, it will show as 0777, probably the client does it
> somehow. The problem however is that if you create it with 0777
> server-side, everybody can mess with that file that the client view as
> a symlink. That's why I thought that 0644 is the best approximation.
>
> Regards, Volker



-- 
Thanks,

Steve
