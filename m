Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ABEEC5479D
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Jan 2023 13:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbjAKN5o (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Jan 2023 08:57:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbjAKN5n (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Jan 2023 08:57:43 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A86767A
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jan 2023 05:57:40 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 709BB7FC04;
        Wed, 11 Jan 2023 13:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673445459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kFJhoXftab68nHdjhSd+QX4PDaLr4cXXg9hq8cbu9FY=;
        b=I1YpE8ZPG82cRFrPk/ptxDDR534uDERW9AAmVobq/tikuW/74qE98gYB9w95WYeB2vHuB4
        X6/8iUpFRgK0mfCpnS3DzO5/Yy3lsopzNuV5gXl1z2OO7I9bWpliDG+9aEVf9BQEP6L7/m
        es9vz+kGqLSrYTCE5VT/856mBrx/H6Zg7Ce3/TKQVfmaW7jeG+cxyPS8TJR2F/C+YGfoc5
        ZIhvH83xDLbzrKy8sHcXXDltBU2pJEPBJMkXpr9S6SRujwf8nGz0r8Q6z1IbwtIuUjgAEp
        pnMgSU8lvppAPS42l+6dyEWbpYplyy5N76ZTd0WLihLBS2j/f+TIx8LkDGaMCA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Volker.Lendecke@sernet.de, linux-cifs@vger.kernel.org
Subject: Re: Fix posix 311 symlink creation mode
In-Reply-To: <Y76gvH9ADxSgAxSw@sernet.de>
References: <Y76gvH9ADxSgAxSw@sernet.de>
Date:   Wed, 11 Jan 2023 10:57:33 -0300
Message-ID: <87sfghkwc2.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Volker Lendecke <Volker.Lendecke@sernet.de> writes:

> Attached find a patch that fixes an uninitialized memory read when
> creating symlinks using the smb311 posix extensions.
>
> Volker
> From 482fa85ef97505626b6b146155834e6bc36012fa Mon Sep 17 00:00:00 2001
> From: Volker Lendecke <vl@samba.org>
> Date: Wed, 11 Jan 2023 12:37:58 +0100
> Subject: [PATCH] cifs: Fix uninitialized memory read for smb311 posix symlink
>  create
>
> If smb311 posix is enabled, we send the intended mode for file
> creation in the posix create context. Instead of using what's there on
> the stack, create the mfsymlink file with 0644.
>
> Signed-off-by: Volker Lendecke <vl@samba.org>
> ---
>  fs/cifs/link.c | 1 +
>  1 file changed, 1 insertion(+)

Looks good to me.  Thanks!

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
