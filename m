Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5BAC433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Feb 2022 17:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiBARae (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Feb 2022 12:30:34 -0500
Received: from mx.cjr.nz ([51.158.111.142]:23852 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237932AbiBARae (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 1 Feb 2022 12:30:34 -0500
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Feb 2022 12:30:34 EST
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 01CD57FC04;
        Tue,  1 Feb 2022 17:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1643736166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XJVS/zfGSJS1nWVTocDhdFSQ4lxt518B7EZStlYw84s=;
        b=dX7aoeMyzpJc2Fqzv+iHikFNhzqn4OXZDODOztZILk8ZluqurIXR3UyI2FKP0w5/uHKeHv
        M2+p6oA3tzsqX/zujajU0MuaDv6P4RNZn2AqQwFrx7HOwEdeKQ/8fTdN19NDlP5DRXyXdL
        4MYoe9IxN+IQ8ZMhzCnAGzob7pSBirEv3Z6VsvQmNGEL2m6qcL26O2kWj4mq+t8RsrjZ8u
        mXi6hWVGjEVSO2y89+Ke+STuXzgFeoRhMG3I08COL5uxrxxR/04VRDIGqVm5a4RTXPAuBK
        6Pw6F6QreIgq0GjeemnO19LqNFAa0JKNVe5czmfEDsHDrt1feask0E111ObVXw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Ryan Bair <ryandbair@gmail.com>, linux-cifs@vger.kernel.org
Cc:     Ryan Bair <ryandbair@gmail.com>
Subject: Re: [PATCH] cifs: fix workstation_name for multiuser mounts
In-Reply-To: <20211222160405.3174438-2-ryandbair@gmail.com>
References: <20211222160405.3174438-1-ryandbair@gmail.com>
 <20211222160405.3174438-2-ryandbair@gmail.com>
Date:   Tue, 01 Feb 2022 14:22:41 -0300
Message-ID: <87y22uqz6m.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ryan Bair <ryandbair@gmail.com> writes:

> Set workstation_name from the master_tcon for multiuser mounts.
>
> Just in case, protect size_of_ntlmssp_blob against a NULL workstation_name.
>
> Signed-off-by: Ryan Bair <ryandbair@gmail.com>
> ---
>  fs/cifs/connect.c | 13 +++++++++++++
>  fs/cifs/sess.c    |  6 +++++-
>  2 files changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 1060164b984a..cefd0e9623ba 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>

Steve, could you pick this up?  Please also add the following tags:

        Fixes: 49bd49f983b5 ("cifs: send workstation name during ntlmssp session setup")
        Cc: stable@vger.kernel.org # 5.16

Thanks.
