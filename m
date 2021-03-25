Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83F6FC433C1
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Mar 2021 15:34:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DF98619A3
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Mar 2021 15:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhCYPeR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Mar 2021 11:34:17 -0400
Received: from mx.cjr.nz ([51.158.111.142]:63870 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231349AbhCYPeM (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 25 Mar 2021 11:34:12 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 8D8BF80342;
        Thu, 25 Mar 2021 15:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1616686451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1See2PqZ00r1f1GEX43c+QqhEBjANqyHHBMAyAEeGLc=;
        b=nGBIXAlNN2TR5zhUT6rhC2uLYPhGixo+mfBTHVmvqFaqER40IiPyeZmXgwJPu+vaPIyDAH
        DvVFrgJOlOS5sDG0B+wh33qMxoNhPkOlHWOGv2a5l820helqe/5bHr1WELm96D4a79OB88
        WFcCE8xlCJspAAZVxAzaW21UZhkb4ZAbiBNS3hrntGB6DydS7C1/qgYeAG3ovOwUgjs2cR
        GlkJSbZAtQO3bO5tUfVWgHv49JzX0Q8LU50iPaFfxRgJvqFrSi44IuF8KKs6XEINKkYJEn
        P4ZX3jmJ2dOI5cjhrytXDScTVKDpSdrpLhYKG9dCSVEPpCLrYDte1lgqrBNJDg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: revalidate mapping when we open files for SMB1 POSIX
In-Reply-To: <20210325062635.43370-1-lsahlber@redhat.com>
References: <20210325062635.43370-1-lsahlber@redhat.com>
Date:   Thu, 25 Mar 2021 12:34:08 -0300
Message-ID: <87y2ebdz7z.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> RHBZ: 1933527
>
> Under SMB1 + POSIX, if an inode is reused on a server after we have read and
> cached a part of a file, when we then open the new file with the
> re-cycled inode there is a chance that we may serve the old data out of cache
> to the application.
> This only happens for SMB1 (deprecated) and when posix are used.
> The simplest solution to avoid this race is to force a revalidate
> on smb1-posix open.
>
>  Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/file.c | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
