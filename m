Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7EDDC4332F
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Nov 2023 21:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjKCVDa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Nov 2023 17:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjKCVD3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Nov 2023 17:03:29 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD5DD55
        for <linux-cifs@vger.kernel.org>; Fri,  3 Nov 2023 14:03:26 -0700 (PDT)
Message-ID: <ffa541bac7417c9dea79c73e22de1eda.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1699045389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qe7hP/Y5IxAcEKtKfdU55O3dqGhnJd8hWYZMbPWGrds=;
        b=fxchevonHjTgO9UQXX548SmoHOT0TVa3fVCoGBFZrHHVPm6RJwuiqx90Q8Z9fKAi1+pfgP
        UNyaXukhQ/y+Ru4sG6D+8hErNiAnEbLls4hp9c9sYQz+kNwdQbmzoRaoaiWYOKaIU4r6mO
        HGvOSj7hnCJRtPysZYZ1l7oXZJu20bmOiSjZkLB2CDGHCMEGJxPD3x46aYNA6VuKVORhiE
        Kj+ZgeD+YdiaQRT0lowGYBdBQusT2ltprQjcBG5vFp87Cp+k/YZ6SEz0yKXSGJBDAGxywZ
        WyWO28Z6c2FtjCtC5twOyXysHF0BtWVfo+Wi+8JbTqCYvp2gH2xgpbqOJIqtmw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1699045389; a=rsa-sha256;
        cv=none;
        b=cmKvAACluosL3uA7RSjo2/zu5VYQmSOQEit58F08KRNXD0lT7ZrQnWsDL6//ca3JC/Ula7
        dZzjmeBUwgZynpXv/+8bS0qmeqk06mN53Hz5wVkoOwbLWNEvcflu/BknX8xAmx40uX71el
        I3A33qGBlvmZELFqbpLAiX6+FQSUYMC3RgT2dGlukJVHzSBR9kAxODwC8NV/hfrnJZNdHn
        JQmDLs1+hJb+nQqCWiwHdHQyMeBpt7FEdm65SnOwGKjG5Sf5y5d38LVeIxxHexAihspSyQ
        VvKG4BfXwudwNVqY+ow+fwSZCYDnEqDjGfPAKNT+MW9i1w1bF3mi51jxv2IqVA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1699045389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qe7hP/Y5IxAcEKtKfdU55O3dqGhnJd8hWYZMbPWGrds=;
        b=bRYikDyX8KAEBV4OJcDJ5NZ6+Ksdf0SQZEbgqTBaOP7UkQXd9wTaS88CNkUVdryDcIBX53
        Ascki+JryjBBUQoiM5Gy/vj3hx2eFC76LI/6QuxupXBJGQhaQG9VsHK/ogmcNpA4E2yD7n
        ZzTxQx/skoOIgxFH23zjNoQG7hcihEKy0PUbr/TlPZuUebf+WMjRyVLA7OsmHazaCeZ2dY
        P/IZoqFSkQ+kOjI0MVie+2azMrhnPiggdT8GFZ/7UXc+xGEvv6PcttuPjiUYXjKEglfAm/
        bmtO/mKDad2S5Etb4z3thl2ZMWNGUuSL9K6G5urBggOw/vrfI722YmMPcLkhdQ==
From:   Paulo Alcantara <pc@manguebit.com>
To:     nspmangalore@gmail.com, smfrench@gmail.com,
        bharathsm.hsk@gmail.com, linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 09/14] cifs: add a back pointer to cifs_sb from tcon
In-Reply-To: <20231030110020.45627-9-sprasad@microsoft.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
 <20231030110020.45627-9-sprasad@microsoft.com>
Date:   Fri, 03 Nov 2023 18:03:05 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

nspmangalore@gmail.com writes:

> From: Shyam Prasad N <sprasad@microsoft.com>
>
> Today, we have no way to access the cifs_sb when we
> just have pointers to struct tcon. This is very
> limiting as many functions deal with cifs_sb, and
> these calls do not directly originate from VFS.
>
> This change introduces a new cifs_sb field in cifs_tcon
> that points to the cifs_sb for the tcon. The assumption
> here is that a tcon will always map to this cifs_sb and
> will never change.
>
> Also, refcounting should not be necessary, since cifs_sb
> will never be freed before tcon.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifsglob.h | 1 +
>  fs/smb/client/connect.c  | 2 ++
>  2 files changed, 3 insertions(+)

This is wrong as a single tcon may be shared among different
superblocks.  You can, however, map those superblocks to a tcon by using
the cifs_sb_master_tcon() helper.

If you do something like this

	mount.cifs //srv/share /mnt/1 -o ...
	mount.cifs //srv/share /mnt/1 -o ... -> -EBUSY

tcon->cifs_sb will end up with the already freed superblock pointer that
was compared to the existing one.  So, you'll get an use-after-free when
you dereference tcon->cifs_sb as in patch 11/14.
