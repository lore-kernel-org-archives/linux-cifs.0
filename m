Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB06C05027
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Feb 2023 13:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjBQNiS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Feb 2023 08:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjBQNiR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Feb 2023 08:38:17 -0500
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E60A31E31
        for <linux-cifs@vger.kernel.org>; Fri, 17 Feb 2023 05:38:16 -0800 (PST)
Message-Id: <1ba6aed922e5a6b09a665c8df07b55ce@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1676641094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cfMlq4qsHiUGaRFnO8A89OrnEGFsbguBVPxFT8JGe10=;
        b=cfaOMGAlxCfBW8w97Yv6rtkqtZE5UFtQSzTQgmeVB6GcPx1KB69uzUgnKLIjmAz086tkNE
        Lznh7plt+eBhrZK5DnsdvtwCR9wQhIHMZ2ZqJHeZjSlJdp26M4lH85RoNVd50qZRR732pL
        SxWS0/1/S7zTsO3XwTlbo8gKDjGS36H9Pz1zdAKSHoCjGGmKmCOtfivoFsMB9bhZ1qI50g
        JNAY4FwNn0yR/O/ysI/1+I8qxWCdsr4we2FqGdk/doE4EUZc469Xz3UF9P84ibm59Cly0/
        V9kEvX2cPBldBzp90UEox9i84+CriU/ufPVEeN+ZwTUHNHW7LJk1DSsgkM1nTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1676641094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cfMlq4qsHiUGaRFnO8A89OrnEGFsbguBVPxFT8JGe10=;
        b=QtCR3DFMM8ccA6t6BQktqniGIXa4HbdX2UyZWcvI01lwffQ2fyJTFGiyqrJYKFsbZuBSML
        p+RJ5dpSmoWitWR/aTTgmFbro88bzc/6ojW6PPzn+XfKIaRXU8pn1dGo06FnWp163Gavo6
        Ur/6SFyeg1F8/vk10HTc7tu4bIQW+DAln3RxqEySLEreMAHhLAMritU/ISDduo7p6ulrGB
        9LD+lwoFRGerXo7GsbflJ50NqEpcOrUVcngvbnV150m3vh1QX8HEj6nsktez5pNs+qKmRC
        KYIGpOZQXD6T5nfUlvDzwS+rmFfmS/v84hL/pLHC78acEE0fTXKiBaO2PPwcAw==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1676641094; a=rsa-sha256;
        cv=none;
        b=lu7VfpyT6jYK48W50v75vMSfYkSwwVGWWwXclWP8lZKjF5e+++S7Pn1CztEGin7w1alnX4
        /UN6LQfXOaheGqSWlaUbKiEAlQ9u62VW0Gg3KTRxCPWPAujpIce0GNFXHaW8iEUTaYT1GC
        YT5MtmzKMoszcisDEUF+LOEQM1dAqmaLY3kpThG7MAfAhKXjaujAu6QWKu0xfKWhbmRUHs
        gZ0DfsPuaqAsQNxYoHqZn+hgojqDuiaqqwarY58BRxi9JCFb3m3Oq3B+rUu64qNTrWY2Ci
        TP2KncqL0dN6pgdcKmaS3eglMry3WLLAi2ryXEOcx5iY9xtRlEqgOXHxu3e1NA==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 2/2] cifs: return a single-use cfid if we did not get a
 lease
In-Reply-To: <20230217033501.2591185-2-lsahlber@redhat.com>
References: <20230217033501.2591185-1-lsahlber@redhat.com>
 <20230217033501.2591185-2-lsahlber@redhat.com>
Date:   Fri, 17 Feb 2023 10:38:10 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> If we did not get a lease we can still return a single use cfid to the caller.
> The cfid will not have has_lease set and will thus not be shared with any
> other concurrent users and will be freed immediately when the caller
> drops the handle.
>
> This avoids extra roundtrips for servers that do not support directory leases
> where they would first fail to get a cfid with a lease and then fallback
> to try a normal SMB2_open()
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cached_dir.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
