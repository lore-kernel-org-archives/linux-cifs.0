Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F338C4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Oct 2023 14:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344323AbjJaO5m (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Oct 2023 10:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344312AbjJaO5m (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Oct 2023 10:57:42 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E823BE4
        for <linux-cifs@vger.kernel.org>; Tue, 31 Oct 2023 07:57:39 -0700 (PDT)
Message-ID: <24f65f57980f7010cdc44f17023d475b.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1698764258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mwcYmzMGLrIJAKwwPAsSOg0b5letFz0OQC+Kd8SAaXA=;
        b=I1e1Nm3/SfRhcsEPVlr3BsdMch/5F6GBpdFrsAg1JJujq9CXM8y4rxR24iCsA7o6/kyGZp
        1eCCN7BrEhrlr29kw8EycGIAC+5VDuUcJYePQHMu2vEAmJ4yxojoixAajxg0pawMUhgVTX
        QDBrcp7oSZRLbOeOSt7aOJyvxUcicZECrSuV0JKJEDb6DYVjDr21xE7l+QvMMYABmigplc
        1AfzaAYXQ6e8jTxHcF/kWRS333VQxMV5+N5KodR26RDwk7QubXRb6jXNnXjJsdQLu+XTkp
        Nf4mYapUIelWMsR6I/nkAX8L5IccpK/9kI4hTmeWRvj/Fbm/AJn6/sj1G1lvTA==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1698764258; a=rsa-sha256;
        cv=none;
        b=i9bohQPBrDXw9uor/Yysn5EWlj4iUdv06t7PRa/UiMtTBkwnQGge9pdjQJ7Hr8Xo2+WfyW
        SieYjt/UzTwhv/9WosiDwa+kun/pe0Z/IjNKc2fZh99Qv/HkIFTw7fCrLyIDgjdacLaGrN
        Rn9CgiFZozdDnrPWH/jjr1OOL7SxCqPXFMXu4hMA1CxTniOzpzVWDGXkuHOBe+VCmGx6BT
        cuosu+OfgYR0WR54D6OHSv65Cm+flu3+5SCyeQHx+grfkHOhnRC12eP3K/J7c7csP1zH3W
        VJ9Cfisoru1tmYPhBa9Mu4fPdfjldAJE3wfeQABw9KWg2Ofd9ojtH76FtOovPg==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1698764258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mwcYmzMGLrIJAKwwPAsSOg0b5letFz0OQC+Kd8SAaXA=;
        b=VdZSD1LxJvjK1IQrc4FCTSyQxFh1H5WvOt5KnTyBWEXhcC4ghqf1GKZrrG9YF5/S9sPf6E
        mffkbQaRcqyisi6hXv0k4N3cjRcZVVgS5K1Jn8EsFN3fYV+ZRUeFDgqLtLIpT/F+CFSOq1
        P8NibH9fLliAA47kBmqFGG9sGy0OT5Jr+oGkvDRZaBZa8am/gcvTGpenflRKK4mzZ+kXv/
        +sbZjFouzCUDeI8IkKk1wKIyheRybaI9KkOKSXSKwwtg6+cIBF3MS+OLd1V5h45cBZGwsw
        kTcjrWtxPpG4a357qe2phi913waBylEG2q5+mzCBqdLDiUShTaah+tIhQTMmHw==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] smb: use crypto_shash_digest() in symlink_hash()
In-Reply-To: <20231029050300.154832-1-ebiggers@kernel.org>
References: <20231029050300.154832-1-ebiggers@kernel.org>
Date:   Tue, 31 Oct 2023 11:57:33 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> writes:

> From: Eric Biggers <ebiggers@google.com>
>
> Simplify symlink_hash() by using crypto_shash_digest() instead of an
> init+update+final sequence.  This should also improve performance.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/smb/client/link.c | 16 ++--------------
>  1 file changed, 2 insertions(+), 14 deletions(-)
>
> diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
> index c66be4904e1f..a1da50e66fbb 100644
> --- a/fs/smb/client/link.c
> +++ b/fs/smb/client/link.c

Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
