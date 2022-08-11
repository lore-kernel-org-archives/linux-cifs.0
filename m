Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F64C19F2D
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Aug 2022 13:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233918AbiHKNhz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 09:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234733AbiHKNhz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 09:37:55 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8016078BF1
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 06:37:54 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 8005A8026A;
        Thu, 11 Aug 2022 13:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1660225073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S4J0JArikfYKr/hIet9pga7Qm2XbT6v2y7kwEonfHvo=;
        b=OdGJ1IW3edYc2baKqeXOIWFDd0+c8ocDLp3VcEgeqtZc4sZTQPSYOeswdrsAgTdDN2ruOO
        Fjb6CIEenyuwGBVOVbZeVuLW7/U4DGCrg8bKbspR2tLacib/srlWXD8YTWbZ3QVO828oP9
        DESpbmViVOXREo00eAOHZZkYY342IJhZmlfr5ctshrrlrLgIMJaTyyYO25htfBH5dceLtW
        H8//AtuB+DWftD93tNpcepf5KyAc/nCVNP0rbsEPstwzewdORIypUl4eqv0+NOGHsZj6PO
        zspgA51Z0Pr3NrTgZi9+N++Gi6ItR6Z6UEdLD4mxeA1IrV2ucqjXNPOhTcla6w==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: Re: [PATCH 8/9] cifs: don't unlock cifs_tcp_ses_lock in
 cached_dir_lease_break()
In-Reply-To: <20220809021156.3086869-9-lsahlber@redhat.com>
References: <20220809021156.3086869-1-lsahlber@redhat.com>
 <20220809021156.3086869-9-lsahlber@redhat.com>
Date:   Thu, 11 Aug 2022 10:38:05 -0300
Message-ID: <87bksquchu.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> Unlock it from the caller, which is also where the lock is taken.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cached_dir.c | 1 -
>  fs/cifs/smb2misc.c   | 4 +++-
>  2 files changed, 3 insertions(+), 2 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
