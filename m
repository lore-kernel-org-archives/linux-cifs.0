Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AEECC433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 18 May 2022 16:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240033AbiERQWN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 May 2022 12:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239398AbiERQWM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 May 2022 12:22:12 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5037B46141
        for <linux-cifs@vger.kernel.org>; Wed, 18 May 2022 09:22:11 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id F16687FD1E;
        Wed, 18 May 2022 16:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1652890929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=is1CzbZ984kfmEi20fzRg4TbSSaTu61+sY33wblUz8M=;
        b=K57EPLRQ0G7i/YUFNPbIpX5qTMYg2gd1sy4hVorDk5aV/LYglDGt6pbTeNNXt26idH6Xue
        zJH+vASvlE1fraD9tpCnTu5R/8epPSOgu2hVRZWx0PtlG0kjg4O62VsYilOONKUHYUQNxb
        sQixTYFCVMwBJ6dl/rKA53twn/biMduEQKL1mmz/SutZ7RMIPWSw9AU5oXltQPANHM0eR2
        1sdBZF+dlgQAqxvCDLXxh1CCL2GRC7qhSIGbFILmejbyJT8XR5oBT4VfLukBAUD1cZXaNc
        tzGYY1iWqdJ2H4zhtCPeo7ykulL9OmkEF/oTMPh734Fa+JTD2NDVrEobpeQ8WA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, Enzo Matsumiya <ematsumiya@suse.de>
Subject: Re: [PATCH] cifs: print TIDs as hex
In-Reply-To: <20220518144105.21913-2-ematsumiya@suse.de>
References: <20220518144105.21913-1-ematsumiya@suse.de>
 <20220518144105.21913-2-ematsumiya@suse.de>
Date:   Wed, 18 May 2022 13:22:05 -0300
Message-ID: <87a6be3j6a.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Enzo Matsumiya <ematsumiya@suse.de> writes:

> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/cifs/connect.c  | 2 +-
>  fs/cifs/smb2misc.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
