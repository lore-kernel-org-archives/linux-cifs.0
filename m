Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F86C32793
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Jan 2023 22:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjARWR3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjARWRX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Jan 2023 17:17:23 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277373E0AD
        for <linux-cifs@vger.kernel.org>; Wed, 18 Jan 2023 14:17:17 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id DEBE07FC01;
        Wed, 18 Jan 2023 22:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1674080235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SJWIrtkSZwHLy57nXrC0AHQPiCjkb2wqflQNEno2RsA=;
        b=qf9dTfpKHZGx3hXnlOKlzTxukpUfMhISRaGBhcnoH2En6LReZY6R1OZ7XwzavUE1Yh1NGK
        kds25FUoNgEmSCdUdCizHnaHw1w3dInae+2KsIOr9FfNyOcPICpaVoaEUlGBUty0JGd00U
        3/wXsIbhlTuvOyQQvUwblTWGc9dpn+COZh5KYcDoxUwv4bKT05Ao3GA80+t6NVQaLBbUif
        mpGLklqu5TLYusO3DfqXnuEEeW1VmJvAU8HLhTdDOcK/8CjZ3QupAzOyNd0Bym1J1PkHS5
        L/uN5qv5OnHUpNPmLWWUjtu/TI8z8VQUrXDEHnZmFyMi8C5xX1DojD1Cxpi+SA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Steve French <smfrench@gmail.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH] cifs: do not include page data when checking signature
In-Reply-To: <CAH2r5muxweTSeBdGjcG1W_WjuM7fdd4JpqPCB7AqVXjn8QyhBw@mail.gmail.com>
References: <20230118170657.17585-1-ematsumiya@suse.de>
 <871qnrvc7z.fsf@cjr.nz>
 <CAH2r5muxweTSeBdGjcG1W_WjuM7fdd4JpqPCB7AqVXjn8QyhBw@mail.gmail.com>
Date:   Wed, 18 Jan 2023 19:17:11 -0300
Message-ID: <87tu0nwkrc.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:

> I wasn't able to reproduce this with generic/465 - at least not
> running to current Samba.  Any thoughts on how to reproduce the
> original problem?

The test actually doesn't fail.  You can, however, observe the signature
verification failures on dmesg while running it, e.g.

        CIFS: VFS: \\ada.test\test SMB signature verification returned error = -13
