Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE9FC6FD1D
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Mar 2023 15:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjCNPR3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Mar 2023 11:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbjCNPR2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 Mar 2023 11:17:28 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB307AF6A8
        for <linux-cifs@vger.kernel.org>; Tue, 14 Mar 2023 08:17:08 -0700 (PDT)
Message-Id: <acf686eff206150b27aab2763a4d28b5.pc.crab@mail.manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1678807025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6cAqWR0tmB+MH/2dthUnST10KAhPLZVppPETaAlnbZQ=;
        b=GYqtkGl83I/sQzaMzYBudWwB98Dzk8jYVYAxl+w6FUYFXWzcug5T6qH3vo8TD6x/ILb0yY
        pxLAO3T2t4YtE4vaLHZy2rGTKLwS24gZiVlBdS9fSQT+OleBVVuyXCpRZl+BhmE8SpSXMh
        Mh2BfvBywtVFuvUXleVOBk40T1e1vi5TOk7cjL6II4AWdD9ybbHpVdBvElHitwCaTR0Yu1
        WrF6OUCyeGZZssRTbtJ7yUwqPSMu/odC/26jHtoDku/KGeKCSq/inq5qSx2pITQojQM6FS
        z9UsToZPu4eaUaqkThtR4y9SaQOuNNkBukCyWl8lpsipFehVnEWIe6qhD5L2TQ==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1678807025; a=rsa-sha256;
        cv=none;
        b=e34zxYA94ogIol4uXpCCP4noutD20Yb8Iya8Ov49qL8GrbIw6nn8ytpuWSfGzof/ebQ5vp
        Gi9bThDEUDogaCMhQmOVC9/I8X0ZODihWWNiKkAAED+uJjKifg27y4q3nzzWgxiPA/uCN/
        puKucATYBszyFgcCaf9aO3Uw8G5Pa3OL0vOmGslksfX0Ei8eX3BW2P9o5Z0x01ALleudkG
        mmaic7LsOSzSzvLi6FO6m3SqB18wnsYtlEfSnSxyfD9WkA/CCPmb1tB3Rxfc8Pi83rY075
        n9ilEKDw6iNfYpn+IctMHsHf+1D1MsrXP+n7PCTxU1pqoHsiKKKa4P7ZYq5nUQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1678807025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6cAqWR0tmB+MH/2dthUnST10KAhPLZVppPETaAlnbZQ=;
        b=RqbOh5b2HR/i0TPkgYNiN17DMdt9mFKLX19gHRHvMjFgCVNrX+Huc+1yLs1L0gY9XTids6
        i9TKivKfRd9W+uQmSKZhyxlL9uHKeBx0FuRrwWMKia14ZLiJiSxZIa74+9jdwPl7vEKLz7
        t/lJq9hmzXewH/U6PZXmqXEFJ01sM+grAJL/EcI9YRO9a+VeVBMPohtxtHGCATRmTi5C55
        /QJ5qwTCZ/1tG3MH+ISTOvYl7oHVJSjkasBjGCOwISIjKpT9BCGpBmF3tBiKuA09+GY8L0
        gGngNZ8aNBnAZpokqux48bVN+DToMNAB15XZ1aX+mZs8bOcjiIs/absfQVvibQ==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Volker.Lendecke@sernet.de, linux-cifs@vger.kernel.org
Subject: Re: Fix setting EOF
In-Reply-To: <ZA9EgUzqLhHGfTPZ@sernet.de>
References: <ZA8/B2wzQP8mEtRn@sernet.de> <ZA9ASbdsD0AJH6wV@sernet.de>
 <ZA9BJaoO4TJfjh3C@sernet.de> <ZA9EgUzqLhHGfTPZ@sernet.de>
Date:   Tue, 14 Mar 2023 12:16:59 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Volker Lendecke <Volker.Lendecke@sernet.de> writes:

> Am Mon, Mar 13, 2023 at 04:28:37PM +0100 schrieb Volker Lendecke:
> From 41e6250b60b5ba3d262b50f97e8b01df67ccecc4 Mon Sep 17 00:00:00 2001
> From: Volker Lendecke <vl@samba.org>
> Date: Mon, 13 Mar 2023 16:09:54 +0100
> Subject: [PATCH] cifs: Fix smb2_set_path_size()
>
> If cifs_get_writable_path() finds a writable file, smb2_compound_op()
> must use that file's FID and not the COMPOUND_FID.
>
> Signed-off-by: Volker Lendecke <vl@samba.org>
> ---
>  fs/cifs/smb2inode.c | 31 ++++++++++++++++++++++++-------
>  1 file changed, 24 insertions(+), 7 deletions(-)

Looks good.  Thanks!

Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
