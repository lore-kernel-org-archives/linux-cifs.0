Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 574F8C4361A
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 18:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9AB82085B
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 18:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgLCSzt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Dec 2020 13:55:49 -0500
Received: from mx.cjr.nz ([51.158.111.142]:63740 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbgLCSzt (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 3 Dec 2020 13:55:49 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id D68007FD0A;
        Thu,  3 Dec 2020 18:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1607021704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5o6T3szsdPmZuFb+tY3qW1+bxBDNqi0a1z4TOI7y1Cs=;
        b=O2iHPCSNCdT05uQXGgZI0BUNRwDBbXsnPYgyNnNJdB9ApB/fd3pn11xwxQsna8c3dPp23N
        90NgP/wiWm/TOXnVSEo2vUgGGC7siWI7OBHWr7FDPIZ4HRdA030MK2vX8VRCc8J84tupV1
        4K3MZM23IokYr0E8CMK0DVQHaRSjJi5sX933LaK6N+ftapKB1JKNNzLyo7xkHtrn5qXoe8
        lpwwdfADSRYiPW4D0FJDXmsUsEaYVGsKkk5p+UQSYv8a/vKGId4b72JFoVyr+pcxgpsny3
        9mmhuOPmVh2NcwKrXFGh7/O9GRFdBexxvTQSdf9hnBGMZy47x7wK/AOyPaSJOg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>,
        linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: Re: [PATCH] cifs: add NULL check for ses->tcon_ipc
In-Reply-To: <20201203184608.8384-1-aaptel@suse.com>
References: <20201203184608.8384-1-aaptel@suse.com>
Date:   Thu, 03 Dec 2020 15:54:58 -0300
Message-ID: <87a6uura7x.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aur=C3=A9lien Aptel <aaptel@suse.com> writes:

> From: Aurelien Aptel <aaptel@suse.com>
>
> In some scenarios (DFS and BAD_NETWORK_NAME) set_root_set() can be
> called with a NULL ses->tcon_ipc.
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> ---
>  fs/cifs/connect.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
