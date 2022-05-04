Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22EDAC433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  4 May 2022 01:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343866AbiEDCAV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 May 2022 22:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344196AbiEDB7T (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 May 2022 21:59:19 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A007B397
        for <linux-cifs@vger.kernel.org>; Tue,  3 May 2022 18:55:07 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 0758F7FC20;
        Wed,  4 May 2022 01:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1651629305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dwNFwCRChxlF1KBbAXAX4++Fz1Y4biDFvUf4yQwdrfU=;
        b=m2WfpqzPHFL4/HL0RpBO6/sKPv5f4pIw2JcDW7FW/XzG8ktGFDUUaMdDLHcaSE1p7B+SoO
        Y6yMM/gZDLp/cOeHjIbFIpFi03GSsg5cCLUdTiIgcDyidEl3JZIRTbKPDXphqQI3369fRg
        oE9N3HE6yF1vdOUp/KwELsyF12wPYd/WiclSJpgyvBCJogqs0hyFiHEzDk1uq+41e/6hLe
        bDn92IJOtDFjT/yrOeulHirT0xJFD6T9+zzu3vD5w7fxmZc0kGOti7F40OJFqq0I8TvXI/
        P1jga+ijvwAKd5GqpWoTJ9C71TWYKeOToiJtT1YcPZWa4N9CYLq3T4tDeIl5vw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: cache dirent names for cached directories
In-Reply-To: <20220504014407.2301906-2-lsahlber@redhat.com>
References: <20220504014407.2301906-1-lsahlber@redhat.com>
 <20220504014407.2301906-2-lsahlber@redhat.com>
Date:   Tue, 03 May 2022 22:55:01 -0300
Message-ID: <8735hq2hai.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> Cache the names of entries for cached-directories while we have a lease held.
> This allows us to avoid expensive calls to the server when re-scanning
> a cached directory.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsglob.h |  84 ++++++++++++++--------
>  fs/cifs/misc.c     |   2 +
>  fs/cifs/readdir.c  | 173 ++++++++++++++++++++++++++++++++++++++++++---
>  fs/cifs/smb2ops.c  |  18 ++++-
>  4 files changed, 236 insertions(+), 41 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
