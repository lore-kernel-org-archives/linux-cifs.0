Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BBAC19F2A
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Aug 2022 13:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbiHKNQW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 09:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235084AbiHKNQS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 09:16:18 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B3D6AA1F
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 06:16:17 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 9211E8026A;
        Thu, 11 Aug 2022 13:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1660223776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6bgJcS1h+x31PQZs/LNR+wbwi14DA3aniPWc5Q+Kq8A=;
        b=UiyhIchVTuKAFVcnKNblWmXHimEwIDEtCMFLKFtwh5E5p5X5YxjgKG188bGDqVW8nekR8m
        f5KoLMmK4SrGQdRrQ+V/X8UJA5+0PH4FVfwlyZJmpEKtppUVTXyDlKzOnk0dAU+c6xrtqP
        /gq4m0awidbuJxxcCbQaZm8B7QB0962nPBly5I+8YtHiAtZtm0FiIvzS00SiuEYW9ke6Yr
        v+AgcTY+5N0NYyrBpoZ6YrYjACbDRPmWISyDfMZHi9XfcTOkmoqmr8OByzYVD2M8yMchlV
        fw2wvdrEdfWxSJrw+uPJ1hUgzeSOGGTVp+pfuT5KET77V0iesIb3mwdqILqG4A==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: Re: [PATCH 4/9] cifs: Make tcon contain a wrapper structure
 cached_fids instead of cached_fid
In-Reply-To: <20220809021156.3086869-5-lsahlber@redhat.com>
References: <20220809021156.3086869-1-lsahlber@redhat.com>
 <20220809021156.3086869-5-lsahlber@redhat.com>
Date:   Thu, 11 Aug 2022 10:16:28 -0300
Message-ID: <87o7wqudhv.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> This wrapper structure will later be expanded to contain a list of
> fids that are cached and not just the root fid.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cached_dir.c | 50 ++++++++++++++++++++++++--------------------
>  fs/cifs/cached_dir.h |  8 +++++--
>  fs/cifs/cifsglob.h   |  2 +-
>  fs/cifs/misc.c       |  6 +++---
>  fs/cifs/smb2ops.c    |  2 +-
>  5 files changed, 38 insertions(+), 30 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
