Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 276B5C19F2A
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Aug 2022 13:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbiHKNhZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 09:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbiHKNhY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 09:37:24 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0045B6DFA6
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 06:37:23 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 85F828026A;
        Thu, 11 Aug 2022 13:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1660225042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8pXjQDq3L8G4VxjvVNiXHkaQ3+MzxNXEFZrInhNGz5w=;
        b=GYGDCU6a3J1DC9FXkrVajDtnanJgjtMSesKghh/QPI/m9kQ+RGvPPQkY+6JVpOu+RX4xho
        eK3CcIEFgzIt7mooNgVB0jo8rbU5iTXHRuUNOw5fmjNNgBRQBLNdI9IHALU8dT0S/m5ryC
        LVCZj/iaZNqn1tHFoiYkOQ5lx+HJ8LM1QTjpegvFbdOcsXQr6tXrX0n/hDm+7jJFwvXUi9
        vREES9BDKHAgdTW4yhEDMUP1S1i//295T7jNsgLrHfwSCcNlqPgBGRS9CuFqfkm6OM7GRK
        wdyF3j1ITxf2UGUMqpqpt4u9db8IE7fzKHjJ/3usduwkDYJTu1fJDr4aSkWarA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: Re: [PATCH 7/9] cifs: store a pointer to a fid in the cfid
 structure instead of the struct
In-Reply-To: <20220809021156.3086869-8-lsahlber@redhat.com>
References: <20220809021156.3086869-1-lsahlber@redhat.com>
 <20220809021156.3086869-8-lsahlber@redhat.com>
Date:   Thu, 11 Aug 2022 10:37:34 -0300
Message-ID: <87edxmucip.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> also create a constructor that takes a path name and stores it in the fid.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cached_dir.c | 63 ++++++++++++++++++++++++++++++++++++++------
>  fs/cifs/cached_dir.h |  4 ++-
>  2 files changed, 58 insertions(+), 9 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
