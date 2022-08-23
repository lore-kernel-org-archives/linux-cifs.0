Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0502FC32772
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 19:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiHWTU7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 15:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbiHWTUZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 15:20:25 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489ABCCE3C
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 10:59:14 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 0C00480267;
        Tue, 23 Aug 2022 17:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1661275379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D8O39aDSyoHshLtgawD2QrGzZEa1ygDYhueKqI445B4=;
        b=QexrAlMZvOhLfsTbN+F7pP2f2cLML0M/v91pi3Vg+d11Txsg6ax3hJthgM7XAc7UVOmrgD
        OOANKVdRyRqNPqTh0/SVHTojaxqwg8uU3Tl8uvrNB0SatlpHRlAU7ZJ9RhVTTcJKmVwL6L
        pYQd4xoRSecvzBjDCdPhaTSp0Rw/+h44vQpvMW10vp5kAIdeEA1x3eqic4265pkGnnzKpE
        mb0hTsakAVbyCjFovUuMTefTrhkflyfM0j6T6fGLrzp93jGKA1b3ycTc1Z52zaMMknyg8u
        TeerFGDCrBbRAsgRu84BmE99sQnsVRvKfAVlU7rTELlrPaq55kIpX8DlZhSE/A==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, linux-cifs@vger.kernel.org,
        zhangxiaoxu5@huawei.com, sfrench@samba.org, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com
Subject: Re: [PATCH -next 0/3] cifs: Use some helper function for preamble size
In-Reply-To: <20220823125202.1156172-1-zhangxiaoxu5@huawei.com>
References: <20220823125202.1156172-1-zhangxiaoxu5@huawei.com>
Date:   Tue, 23 Aug 2022 14:23:17 -0300
Message-ID: <877d2yj2m2.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Zhang Xiaoxu <zhangxiaoxu5@huawei.com> writes:

>
> *** BLURB HERE ***
> The unfolded expression of header_preamble_size is too long, in addition, 
> some expressions have specific semantics, e.g.:
>   calculate the position of the mid,
>   confirm it's smb2+ server or not.
>
> Zhang Xiaoxu (3):
>   cifs: Use help macro to get the header preamble size
>   cifs: Use help macro to get the mid header size
>   cifs: Add helper function to check smb2+ server
>
>  fs/cifs/cifsencrypt.c |  3 +--
>  fs/cifs/cifsglob.h    |  7 +++++++
>  fs/cifs/connect.c     | 28 +++++++++++-----------------
>  fs/cifs/transport.c   | 21 ++++++++++-----------
>  4 files changed, 29 insertions(+), 30 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
