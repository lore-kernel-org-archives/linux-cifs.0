Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F713C433FE
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Nov 2022 14:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235327AbiKROum (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Nov 2022 09:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241997AbiKROuU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 18 Nov 2022 09:50:20 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751CB903B1;
        Fri, 18 Nov 2022 06:50:14 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 58D2A7FD25;
        Fri, 18 Nov 2022 14:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1668783013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/rePAaj+Om/SnbzekquTM/6DwN9lHDTUpeQeQgkp3dc=;
        b=ALBdruPCG8kg8CYj1aspn86VITy01IRFclshjVb2AwcDl8G1yzf4K5Al5ZT9tY/bLaEOSI
        QsMHqTCpnef89BxB9MMnSY/wCPcrIvjcjZ5mJA8LKIvl6KxgNX7xPS0qv/ppW8FPu7/tx4
        eCJz6Qib+sZYvXRMc4qBPho+BTcxdi2fdvtlmWDxwFr76oz/tOzM+/wEl7iVU0TUuAvcAS
        y37bI7Ut0k3jwPo5FGYoCaeNY3CP6r0OmiZfq2faMsDntPF8BEGakXmwuxMKILpFwPA/kD
        NHSeR/x3vn1v7ocZstjtUz52mhlyjyIOK6vcILJwqyxMGV6b6OrE8YS19P4CsA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Anastasia Belova <abelova@astralinux.ru>,
        Steve French <sfrench@samba.org>
Cc:     Anastasia Belova <abelova@astralinux.ru>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>, Aurelien Aptel <aaptel@suse.com>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] cifs: add check for returning value of SMB2_close_init
In-Reply-To: <20221115142701.27074-1-abelova@astralinux.ru>
References: <20221115142701.27074-1-abelova@astralinux.ru>
Date:   Fri, 18 Nov 2022 11:51:31 -0300
Message-ID: <877czsjoy4.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Anastasia Belova <abelova@astralinux.ru> writes:

> If the returning value of SMB2_close_init is an error-value, 
> exit the function.
>
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>
> Fixes: 352d96f3acc6 ("cifs: multichannel: move channel selection above transport layer")
>
> Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
> ---
>  fs/cifs/smb2ops.c | 2 ++
>  1 file changed, 2 insertions(+)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
