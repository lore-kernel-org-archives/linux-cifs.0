Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB970C433DB
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 16:06:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96A5D64EAA
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 16:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbhBIQGJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Feb 2021 11:06:09 -0500
Received: from mx.cjr.nz ([51.158.111.142]:14690 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232608AbhBIQGI (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 9 Feb 2021 11:06:08 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 2B73F7FF6A;
        Tue,  9 Feb 2021 16:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1612886726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X6PIj5FqGeauQiZydp7KHG/9uqq5ACIrmzdIjCeoyHk=;
        b=CWTmXya/oORSE1j0PifZ20wlXTn2cZ6PeLwFexVAfN1N+ROBbNR80Nas5yT05xBXYVHC7q
        LakqRu8McbnwyLVUJCg5PO7NZdoTiO60d/BubQCAVIcacT3QJcZFCZtdWdyAQyBNi4OFOB
        cK8aaM2fSmSKPBNqeGwm3V2b/4kmHtTHrNf03+xqBEA9YJEsu+cVJpceB+TezvIC0hUMlW
        SL9qBuFtUUy2od6/sRgh5ZNDxPdB26bIl2LSQkJuaAFJeOfRuvh+KFlympCAiI9aN/juDq
        DuMFosv0MdH+ZjyNQxQiaZp++j8tTAC8ngHpgUn2JDnDBuDZs0OdvW7Cjdt1/w==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: fix dfs-links
In-Reply-To: <20210208064831.19126-1-lsahlber@redhat.com>
References: <20210208064831.19126-1-lsahlber@redhat.com>
Date:   Tue, 09 Feb 2021 13:05:20 -0300
Message-ID: <878s7xw7jz.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> This fixes a regression following dfs links that was introduced in the
> patch series for the new mount api.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/connect.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>

Thanks Ronnie!
