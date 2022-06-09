Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 123F0C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jun 2022 15:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343835AbiFIPtr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jun 2022 11:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237201AbiFIPtq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Jun 2022 11:49:46 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7003E10789B
        for <linux-cifs@vger.kernel.org>; Thu,  9 Jun 2022 08:49:45 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 2197B7FD43;
        Thu,  9 Jun 2022 15:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1654789783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9/xbQTrw77xsE8BBhGetXqZR0i/uBJQH1ZEcVVxSXgo=;
        b=HLb2QlXrO4ZcsfEUzdQwHC/u78YJTZ6t/9KLpJFunq4PuxBdioZg+87f6kCUbNUcLlrCyN
        BPTASXKdmx17RMkhdwbUTLbVXrtR5t9iyKlV1Sael0WeTsnjaCB/iCI59GKMekcTwWPH/o
        3Qx6m4zfMLUecLmGQxn50Z8MFGiX7mMh7IFUsqkV8+S8bXjqzLT+RUtEUPtal9Gm+gWkoK
        v8X8H0lae4ODpj8RXJULw7quqBMV6G20J7gZO0BjIpc3+9lfoOnh1QurOZoNYJ8oXHE1c9
        ZyW+I9SabnuTO0+yGrhrLQvtSxp8jUq0Ps4Fw3ml1+5Rq5jA3P0OhJXH/u+0xw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH 0/2] Introduce dns_interval procfs setting
In-Reply-To: <20220609153046.pbb6pazfsnaweayv@cyberdelia>
References: <20220608215444.1216-1-ematsumiya@suse.de>
 <87czfhx50m.fsf@cjr.nz> <20220609151427.nolyifmbozaoxzzk@cyberdelia>
 <87a6alx3p0.fsf@cjr.nz> <20220609153046.pbb6pazfsnaweayv@cyberdelia>
Date:   Thu, 09 Jun 2022 12:49:40 -0300
Message-ID: <877d5px2ej.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Enzo Matsumiya <ematsumiya@suse.de> writes:

> Currently, key.dns_resolver uses getaddrinfo() to resolve names, which
> doesn't contain the TTL for the record, hence *always* returns 0 to cifs.ko.
> This patch is just a way to provide some flexibility to the user, in
> case they don't want to use the currently-always-fixed 600s.

It is not limited to key.dns_resolver.  The user is free to choose
whatever program he/she wants to be upcalled for dns_resolver key.

For instance, some distros might still be using cifs.upcall(8) that
actually set record TTL, thus making it impossible for the user to
change default via /proc/fs/cifs/dns_interval.
