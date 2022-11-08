Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20646C433FE
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Nov 2022 17:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234734AbiKHRvy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 8 Nov 2022 12:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234732AbiKHRvx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 8 Nov 2022 12:51:53 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C408313
        for <linux-cifs@vger.kernel.org>; Tue,  8 Nov 2022 09:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=4HCzvnYYJ4FTBcGnxPniMTg08AG209PkLi4tYI8BtcA=; b=YEFaKWh2f1V1luwzh1kJXlR2jY
        QCWJnz84MSfqocRUZJfayG8UYfLBmxdsMULb/0bjX5O3re21Jp0KebMC36b4E+2rrsnDb4yvbOlIR
        WD6Qj3qB2lC1q+lD7pm2zReLVjr5a4f1PxP9VSpp+JPdkLWJYdyvJThrezbIYRifTVJkU0vY6X+Kv
        6yF+ca52bOEKK/gU+lLS5nrZqZELXAjQtCW2MX/ZymrHCPXl93zlOV6ViqDw8qz8eUz/UDxrtg5f7
        RTqBBcYKXncdc/OH3h3KYlG4vmxUZqL1QqwdTovaLIpJXDPOxjLdSxCxu+kFT6WxkfQwPPlqo6f7G
        GRMY/zE9v0vnvRVFwKvljmdwSfZUyaVliaJW7beJ+pL0FB++OwW/8K8cLvz1aU4l89369je/J8//+
        3umMblf8xSl1zQQbtsdWwy0iYeHlRr2MyPYLobxCGuImri7PCoUljDx59Gd7sqBmemaNWhkPj5xfE
        Pq9faB1GrLUBquVXh0bHH0v7;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1osSlD-007jQH-Ho; Tue, 08 Nov 2022 17:51:43 +0000
Date:   Tue, 8 Nov 2022 09:51:40 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: Re: reflink support and Samba running over XFS
Message-ID: <Y2qXLNM5xvxZHuLQ@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5mtc6rHC=zfWCjmGMex0qJrYKeuAcryW95-ru0KyZsaqpA@mail.gmail.com>
 <Y2molp4pVGNO+kaw@jeremy-acer>
 <Y2n7lENy0jrUg7XD@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y2n7lENy0jrUg7XD@infradead.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Nov 07, 2022 at 10:47:48PM -0800, Christoph Hellwig wrote:
>On Mon, Nov 07, 2022 at 04:53:42PM -0800, Jeremy Allison via samba-technical wrote:
>> ret = ioctl(fsp_get_io_fd(dest_fsp), BTRFS_IOC_CLONE_RANGE, &cr_args);
>>
>> what ioctls are used for this in XFS ?
>>
>> We'd need a VFS module that implements them for XFS.
>
>That ioctl is now implemented in the Linux VFS and supported by btrfs,
>ocfs2, xfs, nfs (v4.2), cifs and overlayfs.

I'm assuming it's this:

https://man7.org/linux/man-pages/man2/ioctl_ficlonerange.2.html

Yeah ? I'll write some test code and see if I can get it
into the vfs_default code.
