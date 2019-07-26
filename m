Return-Path: <SRS0=vxna=VX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8818C7618B
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jul 2019 13:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8A9A218D4
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jul 2019 13:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564146345;
	bh=pkotHNdt+yFvlEm4ZJemYwQrX120R837wGXa9j6uZM0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=xxvMVuH+H9f66TEW9lmNkQ4l86/FGpNJBkcKDktNu3CVCvo35cdE69G/dZ/JifdUp
	 mYFtMWXFf3AZEHFkmUEb3OqMA3GidmrxKnlQIDBsZe/ceEbHLVihTHu9vfbeZzB6Uo
	 7EFmZfDafGarRQWjNC7nZraGd2EPBo9jfQ7TQZrg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbfGZNFp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Jul 2019 09:05:45 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54662 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfGZNFp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Jul 2019 09:05:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=v25fSyTOpn+HLVJ1/RYUYjo/p2HKkKXuypllJV6JuFU=; b=FGTl2rF5Ekw99U5eWA0qO4ViY
        ezxgPoNckrfd02rKeR5DfhI5n58vJTcEz7aQ3diHZkRmGndI5Rrlekc33Ay4TibbLOwpG1XKCSloG
        82pJRxtCcnQvPslNG7xO/8DHeER9qlTWSUhlaF/iNE0YUnkdxnIGvBgg9Brpdp4iVK9JkJjbm0TvY
        TcCvfrG3NaxcqzRwVsiX1+l5U3fjf1yQEEnGnZRs2iZazrP26MkKBj4gTVChmnzy3Hz3krFh/Kx2g
        S6dj3Qi5GKN2Rfpl0jR+wq9OXeL8jT6dpW75i/Mr7cpWYS51GnMWuFS7A6xMmFALsHG7f3ly85U0p
        sDY3Ty9HA==;
Received: from [179.95.31.157] (helo=coco.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hqzun-0004Yn-F9; Fri, 26 Jul 2019 13:05:42 +0000
Date:   Fri, 26 Jul 2019 10:05:33 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-rtc@vger.kernel.org,
        netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        openrisc@lists.librecores.org, devel@driverdev.osuosl.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        devel@lists.orangefs.org, dmaengine@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-mips@vger.kernel.org,
        linux-wireless@vger.kernel.org, rcu@vger.kernel.org
Subject: Re: [PATCH v2 00/26] ReST conversion of text files without .txt
 extension
Message-ID: <20190726100521.5d379300@coco.lan>
In-Reply-To: <cover.1564145354.git.mchehab+samsung@kernel.org>
References: <cover.1564145354.git.mchehab+samsung@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Em Fri, 26 Jul 2019 09:51:10 -0300
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:

> This series converts the text files under Documentation with doesn't end
> neither .txt or .rst and are not part of ABI or features.
> 
> This series is at:
> 	https://git.linuxtv.org/mchehab/experimental.git/log/?h=rst_for_5_4_v3
> 
> And it is based on yesterday's upstream tree.
> 
> After this series, we have ~320 files left to be converted to ReST.
> 
> v2:
>   - Added 3 files submitted for v5.3 that weren't merged yet;
>   - markdown patch broken into two, per Rob's request;
>   - rebased on the top of upstream master branch
> 
> Mauro Carvalho Chehab (26):

>   docs: ABI: remove extension from sysfs-class-mic.txt

    ^ In time: this one was already merged.

Thanks,
Mauro
