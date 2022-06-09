Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81CDEC43334
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jun 2022 15:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237651AbiFIPWA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jun 2022 11:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242027AbiFIPV4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Jun 2022 11:21:56 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FAD4AE00
        for <linux-cifs@vger.kernel.org>; Thu,  9 Jun 2022 08:21:53 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 008C77FD43;
        Thu,  9 Jun 2022 15:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1654788112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j/nvVhAmnS6k2SZH7rHPa6dcOKt9AeK6wFHxfKCMVZU=;
        b=j4M+Ki9afpcsR+OwDDF6tKXRFNqJRkTB1pYkNCC87d95o5OKvzwOFi8cS6uHaClZqMaLs+
        Djp8dQ49578/0Xsv82i4L5wBz782NuhCAzZgZ0RGnT8e25tgjP/rUST7TUI9dbfPLfl1ae
        yb+jyOEiGse+IY9g8mvZUStx4Wgv/a5u9JwVm4MzSNld6AE8IJsg5g1Bz/4K+t7Rm3eItn
        Mu7XHmWLFFvbuzgJ4ROqnYkBmGiHbbiImY5pVpNV+poqBSNCncIK/HBpTZghSDjU5K6BKx
        1VLHjNb+IbJ51R/GmJsKYZpnH+KehJ7el+pa2T2NYsAc8ARMj7srmp7pjeuM5Q==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH 0/2] Introduce dns_interval procfs setting
In-Reply-To: <20220609151427.nolyifmbozaoxzzk@cyberdelia>
References: <20220608215444.1216-1-ematsumiya@suse.de>
 <87czfhx50m.fsf@cjr.nz> <20220609151427.nolyifmbozaoxzzk@cyberdelia>
Date:   Thu, 09 Jun 2022 12:21:47 -0300
Message-ID: <87a6alx3p0.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Enzo Matsumiya <ematsumiya@suse.de> writes:

> The initial value is the same as before (SMB_DNS_RESOLVE_INTERVAL_DEFAULT, 600s).
>
> The user don't need to know a value to be used, unless they know the
> value the server uses (either manually set by themselves or by some
> external script) and then they can use that same value for this new
> dns_interval setting.
>
> A very simple example on how one could do it, if there's no desire to
> use the default 600s:
>
> # TTL=$(dig +noall +answer my.server.domain | awk '{ print $2 }')
> # echo $TTL > /proc/fs/cifs/dns_interval

That's not what I meant.  Sorry if I was unclear.

If the upcalled program sets the record TTL (key's expire time), then
any values set in /proc/fs/cifs/dns_interval will not work.  The user
might expect it to work, though.
