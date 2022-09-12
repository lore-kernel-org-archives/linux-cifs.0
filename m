Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 421CBC6FA82
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Sep 2022 15:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiILP5s (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 12 Sep 2022 11:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiILP5r (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 12 Sep 2022 11:57:47 -0400
Received: from mx.cjr.nz (unknown [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3A02B26E
        for <linux-cifs@vger.kernel.org>; Mon, 12 Sep 2022 08:57:37 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 8BDAD808BF;
        Mon, 12 Sep 2022 15:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1662998241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tcP+Kix1NJKx6HWwK5gA7P9Sh2U4FwXYpZz8WrIg3jc=;
        b=EzP3B8yGbJNJmOse5soVreDpigh6UixxxzXCXv75R4tHgdxEp9NJo2j5hMvJaifG5nxB3w
        SlLhVCBDNaVvBX1mu0B5i+jQx1I8YtHzsTa02uRjNaxgN0DxxymTTidul6OSUkqXZGitrK
        8BGrajiCXzzqu+sAxTcPQTr2vRliCPR57s8vkU9eZk9tbCsetgSy9NZTcycmot87e0GJoh
        5DSj95vRDhMMnOKcHlJmPs5fgblWoi4tYzFMhCtCLVwUbqpUazWt8Zf2YhuLYc6HRPSJM8
        DTcXZOMMLJMzLVs2umFpeadPtwGFEseYQbEfsIYsrb35I+/+mT/1sF6jw0pLLg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: Re: [PATCH] cifs: revalidate mapping when doing direct writes
In-Reply-To: <20220912030446.173296-2-lsahlber@redhat.com>
References: <20220912030446.173296-1-lsahlber@redhat.com>
 <20220912030446.173296-2-lsahlber@redhat.com>
Date:   Mon, 12 Sep 2022 08:57:17 -0700
Message-ID: <874jxcoaaq.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> Kernel bugzilla: 216301
>
> When doing direct writes we need to also invalidate the mapping in case
> we have a cached copy of the affected page(s) in memory or else
> subsequent reads of the data might return the old/stale content
> before we wrote an update to the server.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/file.c | 3 +++
>  1 file changed, 3 insertions(+)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
