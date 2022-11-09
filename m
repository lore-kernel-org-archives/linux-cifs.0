Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9DACC4332F
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Nov 2022 09:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiKIJcp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Nov 2022 04:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiKIJcn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Nov 2022 04:32:43 -0500
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A3A2251F
        for <linux-cifs@vger.kernel.org>; Wed,  9 Nov 2022 01:32:42 -0800 (PST)
Received: by mail-vs1-xe31.google.com with SMTP id 3so16025935vsh.5
        for <linux-cifs@vger.kernel.org>; Wed, 09 Nov 2022 01:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=THb68An7mfXpt0g3Ic/C3ZXToG90RI2yCfZeF6+B/ow=;
        b=HUGPGsm20IbfwA5GyEqowBP3i+al6ZnVpjpIXj7t75JmZOYCJ411wPpyPGq102bAIa
         C/qUw1PniqVHxGEVsHVw1M37bspjbfZ3PrnEoJOFpR5qoCCslZiiHKdjYsSMljIdgo7G
         u1VUEkQ1ADuFsJm7WqML/PVb8p/8WsmUUmU9wD9s4VKOBhEZ4HfyM6JTs3U1g2PDY5EV
         yOb802ScGQhcYs9kVL8GXRFoob0YLFwAVRC1D2bV+PNWPlxOGD7uXbSLr4iRiIvpSRo4
         QdO5gOX0kfWWHvq0xrnUOmGIZAuJ1i52GLVCt/RB/CCf5A5zQIMGCJ0A4komqef71U/l
         zidw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=THb68An7mfXpt0g3Ic/C3ZXToG90RI2yCfZeF6+B/ow=;
        b=ySF17GBAR5vtyDwseDGAFBrImCMd8F9ysWLIadG93g36+rgC+MFq7TmtDQPK0nrubb
         YaxiM/H+Kwl6Ktk+MyuY/pzLb4gSy5J7zLeurfSztr6/2GFEF41r1tPQo6rDwqrQzLz6
         EVv/xi7KKQPb2xc4qe3sSo8UnrFILC6qv2VcJfaoXI66G0XvLavsn2R8AFByriHJoMiX
         b2oAIneZn+k/vfZbGM8XkeX8kDGSLAg/3OB5yonDQwRc/mgD5uXMv9qLCILp+kgc20l8
         IlymqqaKrRpxzPvjhXF9KvyjHLHpFPZb+zoQ8HSPlMpkiB60ULCprOQvOxxxeTtsVKTO
         FrsA==
X-Gm-Message-State: ACrzQf2xYhqUUUY0olJ0FGEE37Re5uk2buUbFF84iVSXuyg+RyFY6yPq
        N5Ho9qiGW0T1yVzIkqwYvfQX8RZKoQZVMUzg9vc=
X-Google-Smtp-Source: AMsMyM5LH22jLKQC76s3HOT5UdE9nLihj8jTFUKP5CrdBli9QohEuz15EJhSCagrQWFXtVnGQ4PuN9Z5Thu2oC56JuI=
X-Received: by 2002:a67:c990:0:b0:3aa:320a:90a7 with SMTP id
 y16-20020a67c990000000b003aa320a90a7mr982645vsk.3.1667986361406; Wed, 09 Nov
 2022 01:32:41 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtc6rHC=zfWCjmGMex0qJrYKeuAcryW95-ru0KyZsaqpA@mail.gmail.com>
 <Y2molp4pVGNO+kaw@jeremy-acer> <Y2n7lENy0jrUg7XD@infradead.org> <Y2qXLNM5xvxZHuLQ@jeremy-acer>
In-Reply-To: <Y2qXLNM5xvxZHuLQ@jeremy-acer>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 9 Nov 2022 11:32:30 +0200
Message-ID: <CAOQ4uxgyXtr6DU-eAP+kR1a7NsS-zDhXi5-0BJ7i=-erLa3-kg@mail.gmail.com>
Subject: Re: reflink support and Samba running over XFS
To:     Jeremy Allison <jra@samba.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Steve French <smfrench@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>, Ralph Boehme <slow@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Nov 8, 2022 at 7:53 PM Jeremy Allison via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> On Mon, Nov 07, 2022 at 10:47:48PM -0800, Christoph Hellwig wrote:
> >On Mon, Nov 07, 2022 at 04:53:42PM -0800, Jeremy Allison via samba-technical wrote:
> >> ret = ioctl(fsp_get_io_fd(dest_fsp), BTRFS_IOC_CLONE_RANGE, &cr_args);
> >>
> >> what ioctls are used for this in XFS ?
> >>
> >> We'd need a VFS module that implements them for XFS.
> >
> >That ioctl is now implemented in the Linux VFS and supported by btrfs,
> >ocfs2, xfs, nfs (v4.2), cifs and overlayfs.
>
> I'm assuming it's this:
>
> https://man7.org/linux/man-pages/man2/ioctl_ficlonerange.2.html
>
> Yeah ? I'll write some test code and see if I can get it
> into the vfs_default code.
>

Looks like this was already discussed during the work on generic
implementation of FSCTL_SRV_COPYCHUNK:
https://bugzilla.samba.org/show_bug.cgi?id=12033#c3

Forgotten?
Left for later?

Thanks,
Amir.
