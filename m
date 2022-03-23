Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFD8C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Mar 2022 15:17:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbiCWPTR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Mar 2022 11:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiCWPTR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 23 Mar 2022 11:19:17 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA2521251
        for <linux-cifs@vger.kernel.org>; Wed, 23 Mar 2022 08:17:47 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 70EF180856;
        Wed, 23 Mar 2022 15:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1648048666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OfzSGUxlwgcmk5Zs9o9yFHWizF+fKltKR4S8l+JAllQ=;
        b=XYLFsJLyqE1FmPM05oCOaoIklHmQnCDEBiRq2CzhVtVLtx1jVONDSTYVbiM5GmFwuzxUTw
        2u2ZRVnefj77yu3FPEiGKjsfDzlQskztE4mPdiaAb7c0S6WxX6iv5Al31qfFJvcBsCQvqW
        bfaIkZA0poo7mR8bA1kPf2VrPfvuUPylrUCs270bmZdHrmhrKnZFHJBsB/u9nhCWBoYP7m
        wlMoQjbe/RT6U9fk/cKDYpBKHc4BB/RInxxbRhto41mvABAhuYn6od5SFrLvv0PvFYVtUv
        3d0SJ4HIEsodfm8eW7qJPXmJr26vSPvS55+QmkDhb6T9vc9zet5IjdRHm/8Bjg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 2/2] cifs: change smb2_query_info_compound to use a
 cached fid, if available
In-Reply-To: <20220322062903.849005-2-lsahlber@redhat.com>
References: <20220322062903.849005-1-lsahlber@redhat.com>
 <20220322062903.849005-2-lsahlber@redhat.com>
Date:   Wed, 23 Mar 2022 12:17:41 -0300
Message-ID: <87tuboitpm.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> This will reduce the number of Open/Close we send on the wire and replace
> a Open/GetInfo/Close compound with just a simple GetInfo request
> IF we have a cached handle for the object.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2ops.c | 45 +++++++++++++++++++++++++++++++++++----------
>  1 file changed, 35 insertions(+), 10 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
