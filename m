Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D84A1C32772
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 19:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbiHWTTQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 15:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbiHWTS7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 15:18:59 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10310128D32
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 10:57:01 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id DA91580273;
        Tue, 23 Aug 2022 17:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1661277419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3J2etJ3POCzpgYkik3JW0CwEg6/ZUwjXQXZl7DCNwbk=;
        b=aXauAMZJ7j0pS/UFdyAk7XfNaHYfU0n4lZq7XYwG+rvkhal08tlSwwB5TjaJKl/OmaF/i6
        Wxc544LX970y4fbye+U5G16TRqn57p4Yxgvp0prJdkq3IJfG8ooaAB/loBPrDUgLfqUhvv
        gbH2mOwc5ZwLy0czZj+VZaryU4kmJ/4O213koSvNO0bmcLDrKfmoBHH6fY4ZxBPGgAhovP
        DRNT3ttpPi8/c/47/JriHlYau7bJMVrrDTh0nFEsdgath5V6lsKwu74UjOP7dPKxZpsJZx
        4rn+R/EMcwSwB1u6P6AtBEiLrHwCK8xyuyjkggq3/q8dy2m/cbmZcS574/f8Eg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, linux-cifs@vger.kernel.org,
        zhangxiaoxu5@huawei.com, sfrench@samba.org, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com
Subject: Re: [PATCH -next 0/2] add release callback to cifs_writedata
In-Reply-To: <20220823130637.1164764-1-zhangxiaoxu5@huawei.com>
References: <20220823130637.1164764-1-zhangxiaoxu5@huawei.com>
Date:   Tue, 23 Aug 2022 14:57:17 -0300
Message-ID: <87zgfuhmgy.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Zhang Xiaoxu <zhangxiaoxu5@huawei.com> writes:

> The release function of struct cifs_writedata is determined when its
> allocated, so add it to the struct and remove the extra parameter about
> async_writev
>
> Zhang Xiaoxu (2):
>   cifs: Add release function to cifs_writedata
>   cifs: remove the release parameter form async_writev
>
>  fs/cifs/cifsglob.h  |  4 ++--
>  fs/cifs/cifsproto.h |  9 +++----
>  fs/cifs/cifssmb.c   |  5 ++--
>  fs/cifs/file.c      | 58 +++++++++++++++++++++++----------------------
>  fs/cifs/smb2pdu.c   |  5 ++--
>  fs/cifs/smb2proto.h |  3 +--
>  6 files changed, 42 insertions(+), 42 deletions(-)

Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
