Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C88EB64DA
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jun 2023 18:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjFVSqi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Jun 2023 14:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbjFVSqh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Jun 2023 14:46:37 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7582111
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jun 2023 11:46:30 -0700 (PDT)
Message-ID: <34cffb207bfa6afe2b92b15355471e48.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1687459588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l2MB61tEOCO4Ly3C1bZxOl9GVljz+PXsjJGm0D5iE5w=;
        b=PS/6aIRxW00OPPhtAIRlwM6LbwjiACad1k/3kDr/CeKJ0+tnvGImTlroOhp798D95SPtf1
        Z05v5Cj8KZqAzJf/VJBcp5LUqVs7cF5OeYQJo1vps0xjnqv2CHooWeo4aMYF0iMIBsmEXX
        iJ4FXdFcUmdJ4xwfbA9kqs0BwhsjOjTPVhgd3ubIbrLORgZ0/EJ+C/m4GLZWMlnMz3z66t
        Z263Coq077xQ+BMhqBvHoXRFHpLeXCHuoZqf2w4giUJZrZaJ+htoEdlJk6qSw8kWeRxvlP
        ItXqpKk7TGIQ3RaN8yU95bxB7pDhshpcprlrEzx1KXQ/PVD/G7PnDxT7JtJWuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1687459588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l2MB61tEOCO4Ly3C1bZxOl9GVljz+PXsjJGm0D5iE5w=;
        b=KDKt73kbSlnFWgDo4onAYutmaW7zXH3u5gEsToz58bRQ+kXbnybUp+eboz2pxZujNO5AB+
        toBj7JfKIzE4vvxEUejLEbWTWrWIX97Ce9Fw3KvK/QebPiqkIMaOrDspPkdOMlaz9+MbY7
        mYSOr8ERhm/KVeB+oYhLtHWg36ZyEzyK/u3hRIqC84wK5XfdW0P7ZuiT300Z6jcGuFV2JZ
        VGEuD7Ywk6NCEG3FJhg1Afggkxilp7H6odUI7H/xUAe7lrhlVCY09U9b7cnTRGnTI5SOD+
        et7dDMwfVZK1xptFhd880UdXzqG2IECTZhhPClyNADJnJqAvxDGLOmuLeVWXjg==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1687459588; a=rsa-sha256;
        cv=none;
        b=GeB7YPlwtHs2myxTNXqBSfOIZlGKyHMfWfvDR4EkAvx72a4ryUQh2ocdQVD3hKZQ+7+Avl
        o4BV8fVOZx3IEyYdHw8y+D0bj5t4bmrMt8nEXpndVHs5LErad4GzAH06fmEmWWUdnnEeF4
        b678TqJCE1vP8bWYwEV4UBKYOOvMf86r2/Lk9D/v4lE4nemXUAFhywqq3PUjHpB+LOsDmB
        0o1Sg/2nhafPkX3DoVSEgLmiDxO6r69jlQHtOeB900hpvcUprsQSWU7iamXkH5bxKoBuFc
        wWrOBq2mlBXKibyOU2xXzvDtZJ8MfS0uwF9nvyhn7Foz+xsp8HxVj5JD50iM4Q==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cifs@vger.kernel.org, smfrench@gmail.com, ematsumiya@suse.de,
        bharathsm.hsk@gmail.com
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 2/3] cifs: prevent use-after-free by freeing the cfile
 later
In-Reply-To: <20230622181604.4788-2-sprasad@microsoft.com>
References: <20230622181604.4788-1-sprasad@microsoft.com>
 <20230622181604.4788-2-sprasad@microsoft.com>
Date:   Thu, 22 Jun 2023 15:46:24 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:

> In smb2_compound_op we have a possible use-after-free
> which can cause hard to debug problems later on.
>
> This was revealed during stress testing with KASAN enabled
> kernel. Fixing it by moving the cfile free call to
> a few lines below, after the usage.
>
> Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
> CC: Paulo Alcantara (SUSE) <pc@cjr.nz>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/smb2inode.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
