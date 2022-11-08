Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A92C433FE
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Nov 2022 00:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbiKHAyI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Nov 2022 19:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbiKHAyF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Nov 2022 19:54:05 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFE01D9
        for <linux-cifs@vger.kernel.org>; Mon,  7 Nov 2022 16:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=FvedlRkE0K7poFPRe12hH4HcfrW+0d77Kd0Ugb9xiIY=; b=2cw8HEFmxNZLpe0+O5eApVXIHI
        Ec/Yr5VXGJuhAXCOC9dYrMNFfSh2ifXKqhtW6mgGZQy+v1QsI0Q2RWx5oNAZ+Q56sibW9m2t/o+sF
        1GwrmxC5Q1toLt2zYWJdS2qtwN4gAZPGHzM3g/toWtWraHL/bHBf8QdokTpKXsm3351VYlzAPv5km
        5ixMxtoEXhT8FmxlHeB7Eo6ssshEBQr0jEJZSrthTsjy38PFIyJHNaX2bT3L59RCX6owgS6ZaPRe5
        YRZ8/6iFrfFZlhYls7pkXLTY/Pjd7Ypjmns5GsEU6LXv8kG2ktc0nmgN7UY1NRl/0g2DnP6lRQ4Ap
        aKGCZCoV764/Bj7C/fSo5e8YFzbHNb0C1YBuaJBmZsqmwRmrGGLlciA/caHj+6f7FaBR1jTkSRkvA
        0qcVwWVTOEzGURrLje8yOk5duHFncwxEC5pN7eWFnNzhkMs8rCu9UBa4Q3Tx65GexWa10mppQGahw
        LxQE0Zd3+7Ol6zOxFvscUvYi;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1osCs5-007cBl-Eo; Tue, 08 Nov 2022 00:53:45 +0000
Date:   Mon, 7 Nov 2022 16:53:42 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Steve French <smfrench@gmail.com>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: reflink support and Samba running over XFS
Message-ID: <Y2molp4pVGNO+kaw@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5mtc6rHC=zfWCjmGMex0qJrYKeuAcryW95-ru0KyZsaqpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5mtc6rHC=zfWCjmGMex0qJrYKeuAcryW95-ru0KyZsaqpA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Nov 07, 2022 at 06:45:38PM -0600, Steve French wrote:
>I noticed that reflink (FSCTL_DUPLICATE_EXTENTS) is not supported on
>Samba when run over XFS but is with the vfs_btrfs.
>
>I can do reflink locally on the XFS mount point, but not remotely
>unless it is BTRFS (or to Windows eg. when the share is on REFS).
>
>Any idea if there is a way to enable reflink (FSCTL_DUPLICATE_EXTENT)
>support for Samba when not running on btrfs (e.g. on xfs)?
>
>duplicate extents is needed for various Linux client features
>(especially various fallocate operations)

This is implemented in vfs_btrfs.c via:

ret = ioctl(fsp_get_io_fd(dest_fsp), BTRFS_IOC_CLONE_RANGE, &cr_args);

what ioctls are used for this in XFS ?

We'd need a VFS module that implements them for XFS.
