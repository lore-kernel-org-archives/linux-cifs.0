Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 964B6C6379F
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Feb 2023 13:38:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjBQNiC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Feb 2023 08:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjBQNiC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Feb 2023 08:38:02 -0500
X-Greylist: delayed 68659 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 17 Feb 2023 05:38:00 PST
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3ED32CFCB
        for <linux-cifs@vger.kernel.org>; Fri, 17 Feb 2023 05:38:00 -0800 (PST)
Message-Id: <16d7d475fd223ebe40d685951665b7cb@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1676641078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WNIVYhA4z7T81Cl+kry7LYM79DA6LaBkiLML1GvbCRg=;
        b=hGBViTWZDSomD7pfbjUlvp5+XqVue05jkAtonWNGiID0iY8rgXVcaodWOgzFiVDSi0r7Gl
        2rXx6ZOGkcJIWg4nFuGyfNNnqxkm4KCsiBWk/ZmG8SQPxqTKk7sr0Fav6SiaetwOiW8V85
        zrZ9OQjYr59aosYOOLzDPkXObNJranrhiN8ZxtzMX7AG5Yq8Hy6b/77JDDJ+ntgsbkaDqM
        mi42AstxPPuDVE2dQaJ6yQARueJW01ksaIvrNlzt0ClKpozmEyojQfe77rpYOFO2+ToXDW
        7A41z9Rd4x+s/SEHQ5u8tpMcSXxHCSvU7NMWHtYbWLCkfrAScqonn6aTefaJcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1676641078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WNIVYhA4z7T81Cl+kry7LYM79DA6LaBkiLML1GvbCRg=;
        b=gt6NYKGUmBYG6F06w7MMhW3WcqxJfg0g6NCyHBuJqpt6XJeUcAeVYNPeOb6uX3O2X0oEle
        x9oYDeGTNBpvOTTBt9kNZxAyj+ItJI4tExpHbhagn9/x4s09xPuw/eqeIMwY9p6L9Ilikk
        0h2ByC2bQvUTC+n3jKEex9dGSpissqFiJJH462p7p2W5rT1oFAPSYzlh+VnKy4vCKiIBAu
        /W/YlhakTQCRiZ3eOhVwpxGOSYm7OWGrCuq1pyfz12+pu9Ge43AgSKXhC+Y+moMdcvLeXI
        JtNE0m97Z3HwczrDeDriBu4NjRb009Z57LC6qPDnvGv6WHI9B4rG2KgcHIVGcQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1676641078; a=rsa-sha256;
        cv=none;
        b=A7vF2TuneDmDWh6fgC5UH33xuoc1CSoi9zeHbhElD0UlT2JtHFkSir1xjXnC7Q8W2kQnTk
        bGySbyLBx6riOJtqytj9ERjPbPbs/5G+Tk8n0u+Vv+upJxTBARXWBNt9ab1QQNqWyJ6XzG
        0+IJHd2n59V2fMtmAgn+4tEuSbbEjAFJ+PSB7liatVpbFqT59GFsbSq7BeluKUX3qLG3di
        nWShD1Pema5YnKmQUNqhR6tzEdjdP/UdnU1LXlCOSi7tpub+aEXCBgb5WdQ4gI0vzyMPnQ
        5VasihiHqh0UV9M0ghTdfjAYNU8nTXdgCt2wXohxYKwDHx4q+s5Bo413k/VFdA==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 1/2] cifs: Check the lease context if we actually got a
 lease
In-Reply-To: <20230217033501.2591185-1-lsahlber@redhat.com>
References: <20230217033501.2591185-1-lsahlber@redhat.com>
Date:   Fri, 17 Feb 2023 10:37:51 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> Some servers may return that we got a lease in rsp->OplockLevel
> but then in the lease context contradict this and say we got no lease
> at all.  Thus we need to check the context if we have a lease.
> Additionally, IF we do not get a lease we need to make sure we close
> the handle before we return an error to the caller.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cached_dir.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
