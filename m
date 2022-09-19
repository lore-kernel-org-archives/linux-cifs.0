Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F204C54EE9
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Sep 2022 14:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiISOpj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Sep 2022 10:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiISOpi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Sep 2022 10:45:38 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EB413E81
        for <linux-cifs@vger.kernel.org>; Mon, 19 Sep 2022 07:45:37 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 5B35D7FC6E;
        Mon, 19 Sep 2022 14:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1663598736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FxKBjChpW5etHhOC3ZVnbplyls8DZbq0m5wr0mHHWDI=;
        b=F2bd0aTgvZ7Aksz6Z7hA06SB5PisJBWslm0i+WOelMIG57WD0Yl47TecVdWpD5ey1JwCxe
        eJ60IexklboKZARqIPUka9o5soVnNB7+V5sptg8Fxkoq1959QnFW9PNZcsnV2PYY71NMKW
        q6C7Bxv3iyvUCOdjwwDbZJ02AD6lyLeBsXb77lUt/tEfBiKvvKt3naEJEeWqS73bVW0Fli
        H2YlCVcfkIiDZDO8Bd/evMk9xA2aynbOYceFCeeI/fP+wJQyJU2LQeLybbvJJ0Eyy0QymM
        4XJtA62mVnvhSygetaodgX5UMQ/85haQqy/R8xcKCsRbn9EBIIIuP57HJ5PTOg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: Re: [PATCH] cifs: destage dirty pages before re-reading them for
 cache=none
In-Reply-To: <20220919053901.465232-2-lsahlber@redhat.com>
References: <20220919053901.465232-1-lsahlber@redhat.com>
 <20220919053901.465232-2-lsahlber@redhat.com>
Date:   Mon, 19 Sep 2022 11:46:09 -0300
Message-ID: <871qs7l8we.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> This is the opposite case of kernel bugzilla 216301.
> If we mmap a file using cache=none and then proceed to update the mmapped
> area these updates are not reflected in a later pread() of that part of the
> file.
> To fix this we must first destage any dirty pages in the range before
> we allow the pread() to proceed.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/file.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
