Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 904E0C433FE
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Nov 2022 06:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiKHGrz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 8 Nov 2022 01:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiKHGry (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 8 Nov 2022 01:47:54 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0076264B2
        for <linux-cifs@vger.kernel.org>; Mon,  7 Nov 2022 22:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6ZjC2Z9pJhd6LI9EDKmT/K7rAJbA5xGUE4Au2jRNhR4=; b=UcL8wKS+s0sQImYuafrsXbBNGl
        YMta9vrsUUNsLN/MoLu9VTwOofkrdmlABaamGFjK+Y0lyk1LZKOmw2VtyEIbDvWi3vJz0DG/2Bpww
        1Z3j315wmC0+8H95w2OmkOZFImFAKCJSmSdc7QoHq4SNB5G8h86fI1Ir4rd/iBlbpU5IpVeudQhWE
        elkPyp2ZJNSVoud1WL87ranb+Z0l4kFNlpgCb7IUZeG5xL0uG1XNcslAVye6+VHJ7vgwfD0TOgxXI
        fJXi93oRRghN7rie3bMaEAC4Lrnakr219K9/7yOPtkOws/25C1mNbKP13Rrg6IYcDeEbxhPswEBO/
        2twFbtXQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1osIOi-003FcT-JP; Tue, 08 Nov 2022 06:47:48 +0000
Date:   Mon, 7 Nov 2022 22:47:48 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jeremy Allison <jra@samba.org>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: Re: reflink support and Samba running over XFS
Message-ID: <Y2n7lENy0jrUg7XD@infradead.org>
References: <CAH2r5mtc6rHC=zfWCjmGMex0qJrYKeuAcryW95-ru0KyZsaqpA@mail.gmail.com>
 <Y2molp4pVGNO+kaw@jeremy-acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2molp4pVGNO+kaw@jeremy-acer>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Nov 07, 2022 at 04:53:42PM -0800, Jeremy Allison via samba-technical wrote:
> ret = ioctl(fsp_get_io_fd(dest_fsp), BTRFS_IOC_CLONE_RANGE, &cr_args);
> 
> what ioctls are used for this in XFS ?
> 
> We'd need a VFS module that implements them for XFS.

That ioctl is now implemented in the Linux VFS and supported by btrfs,
ocfs2, xfs, nfs (v4.2), cifs and overlayfs.
