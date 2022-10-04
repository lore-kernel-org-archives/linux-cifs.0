Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DEC6C433FE
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Oct 2022 18:48:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiJDSsu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 Oct 2022 14:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiJDSss (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 Oct 2022 14:48:48 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37FA6A493
        for <linux-cifs@vger.kernel.org>; Tue,  4 Oct 2022 11:48:46 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id C1B028079F;
        Tue,  4 Oct 2022 18:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1664909324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/ghUdGV0RGiF1y25BXe5nwF2cFsX8H+FKNFXxQzlHww=;
        b=BQjJ/Jm3JPeRmBfEdFt5gkGePz1n4sRD0oFTK0/C2GY3VKuagKI9iJ3D8xMDgcZe8gYx4j
        hryHa8TVh5qVyLUPI2ZlDuCrRLJYyec3j1ko6R3vHjv86ySnw2QljFHWDjKRMYN20rglqg
        1p/TQYUMtymGUalw8rDxd5Dc+zpFURg56T/1X3dGtKmP1DYdKopxRshEEhwB70dhdMrBQn
        JXWsFPV4IYUIz+8PL9rcVAx87krtaGj8olVC2w/fcNpKCgaUlN10yRgsFFZOORDM+MwHLx
        FjhOj31t3dZtOE6PvnnN0gz0hHYwTNURFjuz8yWK13p4lUkNZgXANhIvPMx0ug==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com, metze@samba.org
Subject: Re: [PATCH v4 1/8] smb3: rename encryption/decryption TFMs
In-Reply-To: <20220929203652.13178-2-ematsumiya@suse.de>
References: <20220929203652.13178-1-ematsumiya@suse.de>
 <20220929203652.13178-2-ematsumiya@suse.de>
Date:   Tue, 04 Oct 2022 15:49:34 -0300
Message-ID: <87y1tv4e69.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Enzo Matsumiya <ematsumiya@suse.de> writes:

> Detach the TFM name from a specific algorithm (AES-CCM) as
> AES-GCM is also supported, making the name misleading.
>
> s/ccmaesencrypt/enc/
> s/ccmaesdecrypt/dec/
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/cifs/cifsencrypt.c   | 12 ++++++------
>  fs/cifs/cifsglob.h      |  4 ++--
>  fs/cifs/smb2ops.c       |  3 +--
>  fs/cifs/smb2transport.c | 12 ++++++------
>  4 files changed, 15 insertions(+), 16 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
