Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3566C3DA7A
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Dec 2022 22:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbiL2WNR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Dec 2022 17:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiL2WNQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Dec 2022 17:13:16 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5264E3C
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 14:13:15 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 4A94D7FC20;
        Thu, 29 Dec 2022 22:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1672351994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a1b1yMejAXbU9i9Rl0DG1yZnHQV2zcDbaspzR5IGp/w=;
        b=vLGFxAVDNg27ohVsRpc95TPaKEaRSCTlK1Yf4Hsm5ZBZ9bloepBi3jknwCMjnPxBMoNCBC
        OxXShIqKmo4qitu7SZzpRlbTV2w75Y2KQAmKLXDQW4+lZ13c0dEKDM2ZPQMC+1jUOS2Pzn
        Ko9Nro54HYKSvPr5blf/srDHB7XWwPak+hf47lp3TprSv/pHsbY8Jw3BUi3z0fihs0H+Gg
        yGQtg3uyn5PVaS3EEhkFYSv8EZY8lQPcCBSq4znDAgxNYJDWQnOOmELMIkbH5EKSiCKcQJ
        Ar5nkwD6lsvnHgn7avKOhzAr5V6cZySQt/mR2jcS7/ENkMYhPhGYTJpe+bKI9A==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Ira Weiny <ira.weiny@intel.com>, Ira Weiny <ira.weiny@intel.com>
Cc:     Steve French <sfrench@samba.org>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: Re: [PATCH] cifs: Fix kmap_local_page() unmapping
In-Reply-To: <20221229-cifs-kmap-v1-1-c70d0e9a53eb@intel.com>
References: <20221229-cifs-kmap-v1-1-c70d0e9a53eb@intel.com>
Date:   Thu, 29 Dec 2022 19:13:09 -0300
Message-ID: <874jtd505m.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ira Weiny <ira.weiny@intel.com> writes:

> kmap_local_page() requires kunmap_local() to unmap the mapping.  In
> addition memcpy_page() is provided to perform this common memcpy
> pattern.
>
> Replace the kmap_local_page() and broken kunmap() with memcpy_page()
>
> Fixes: d406d26745ab ("cifs: skip alloc when request has no pages")
> Cc: Paulo Alcantara <pc@cjr.nz>
> Cc: Steve French <sfrench@samba.org>
> Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  fs/cifs/smb2ops.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
