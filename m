Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81681C433FE
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Mar 2022 15:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbiCWPSL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Mar 2022 11:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiCWPSK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 23 Mar 2022 11:18:10 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F35251D0CB
        for <linux-cifs@vger.kernel.org>; Wed, 23 Mar 2022 08:16:40 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id DA87780856;
        Wed, 23 Mar 2022 15:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1648048598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=39A1HkfuafpokWm0k73RRcFfqaTkeUqBcqm5eaH+Po8=;
        b=SftU4ugt1ZqHWeG6gAgCzk0K8kW0SbKHGHu2K1j2jDw8loEkRpCb+vJkTDEJ0ZdlsZKQdj
        9irlfMRV6AZjAjz8D5fPnhgkvTV57F4eNIPvQ8Hc5SN6nDUoZz/iTnzVo/Ls7epDKKzifn
        sBkdfbBqX1C9MvDyfSjS4IFHhxozRUuY0LhWq4Y7qZl2qJDNc+Wd097l7L3FWyYSoCToaM
        1g5y/OQ5JbwDmmyZ3sbV8ZJyno569drdtHMsJzsZrDsJqpQcAJT+5QvKY8UzkhQPiZWuJq
        HvVM2PoPRqAAmMBdE9oVSBjT+qNwbbt40bPIc5bbg7cljO367hj0CO/BlWO2Wg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 1/2] cifs: convert the path to utf16 in
 smb2_query_info_compound
In-Reply-To: <20220322062903.849005-1-lsahlber@redhat.com>
References: <20220322062903.849005-1-lsahlber@redhat.com>
Date:   Wed, 23 Mar 2022 12:16:33 -0300
Message-ID: <87wngkitri.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> and not in the callers.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2ops.c   | 23 ++++++++++++-----------
>  fs/cifs/smb2proto.h |  2 +-
>  2 files changed, 13 insertions(+), 12 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
