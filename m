Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B93BC07E95
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 16:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57935613B2
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 16:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhGGQ3M (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Jul 2021 12:29:12 -0400
Received: from mx.cjr.nz ([51.158.111.142]:50090 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230297AbhGGQ3J (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 7 Jul 2021 12:29:09 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 653B57FD1E;
        Wed,  7 Jul 2021 16:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1625675186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XkdILNGBwWcw+f26uNyjz6J9sGUbbb42F+YdiZ+NoNE=;
        b=MwGYbQ1ITdrRriGiLdNw/arXskvtX+hS8ItfVxHRw4yQkuDR/Nr2LXD6ejOn9RRFayPw3S
        Ux9i2O2xKkF4CSXhfhPD6WmKv2Bgb90nrVLszEY9GtsH4xyXLIqa1Elu0FZIYU1dQdb1fS
        sLaDSwsreOII5IwSDfayvgbuXCy6cPDkD+W0/JDcS5m3vt1irmlJkiYwCDecAmhH8wkmzU
        77WdOl9k/EmMw5b/AiV8rAzEnBh+e4gjbAKAjxw8EK8sVDFjmD70dYewEdR5p4+ZG1gr54
        M/C+T5BMTGK7ygVMd+Pkl9qoeitCnVKQs2Ly53qwdtLO67nsR5LAetrkQs1BOg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH][CIFS] Clarify code for SMB1 SetFileSize
In-Reply-To: <CAH2r5muHMjdmmK1GvhqEuqdvvncTvWYwWcd8avER1iQoGAt7LQ@mail.gmail.com>
References: <CAH2r5muHMjdmmK1GvhqEuqdvvncTvWYwWcd8avER1iQoGAt7LQ@mail.gmail.com>
Date:   Wed, 07 Jul 2021 13:26:21 -0300
Message-ID: <87fswq5bv6.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:

> Coverity also complains about the way we calculate the offset
> (starting from the address of a 4 byte array within the header
> structure rather than from the beginning of the struct plus
> 4 bytes) for setting the file size using SMB1. This changeset
> doesn't change the address but makes it slightly clearer.
>
> Addresses-Coverity: 711525 ("Out of bounds write")
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/cifssmb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
