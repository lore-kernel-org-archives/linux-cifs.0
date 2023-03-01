Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 671A5C7EE23
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Mar 2023 22:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjCAWhR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Mar 2023 17:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjCAWhQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Mar 2023 17:37:16 -0500
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1555153296
        for <linux-cifs@vger.kernel.org>; Wed,  1 Mar 2023 14:37:11 -0800 (PST)
Message-ID: <514a3d90d263bd8422e9d13bd4c6e269.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1677710229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gALyuQKLRq964aT9CJHJRq9r17dtEsWRBt/83ePf9SA=;
        b=mXy8o1AX40Uqfvcf/5v5HvFYKDU0efCPnNNF7IB68Y86GnNSnMGR66fQftA5rHnzGv8AqR
        rKCtFzJdZ3O2b1TCopK1EmhzbTbhEw5JqdVwHbSmPPAJiYNh9CVqrwN7GS7SxBAOMTAZoG
        X4kainvZU3bACqKIwmIa0n3SK7uJ9fTNq94eZNtaB4oifNZ+b5GGWID0x5Aqox99/5iLrl
        ceMHtxWYc+bBT/ks57iRd870EdLsywdW7nF5pX7myFg2As94cQ++hggqnJwS/0M6ZMk76W
        OVdY8VC91cF0zNEOpO7dB/AF1+l0X5n/VEJWMXFcatpRqkNfd1+bJCxh37r/Rg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1677710229; a=rsa-sha256;
        cv=none;
        b=HsdBysU7G8aoYE8AO2rqe53wSENVD/hCkXDLgCZZHPbuVLYx5kneSM9/52ovD9G/2ZpbJE
        140xJxLx4soxRYOvgptYlFxB83T07NlRo8n8cT1XgezajBLEUfeNVxv17jj4cjcbo1l2Pb
        8bgwrTG1DmnA5IBnsOdp/xdVRfSNBcZgwosxe+rQ3l0FUKGTAXiLobFUcEgND+MiWdCO+a
        NVooyU0924WpmFnkQ7mkz3WZlcoSHSvs+LZKW9IbEaXILfDi9vWPq1jLNnm6t+1vUOoGio
        ZSWWLOEeHMjMBnaBuSYR/8NvYrBIB5nlfXWqrXRBx/nCmPqpL2QYd3WvegHemA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1677710229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gALyuQKLRq964aT9CJHJRq9r17dtEsWRBt/83ePf9SA=;
        b=mYH42ocmnZ5IaeYhfaqWu/OskekBUp8CMZvywPWJOFhk8RnRBa4FGuCKOUjt/KWKiXnXGi
        lQsNSflah1DUL++MgDzSmTVzwzWG0zJaV9hb58jurKMr9HoeTAokmaqVHnugtJdN7neVXY
        bA4rNa6dHlBqIjPqMlwU1wZHIG7or9aZ0YHZOuLVrXQqACHtL7QulqxOYxN8aVzTwImve7
        zGJXHQnwKmv1C6d9oHS+XMxwepcEVd7zp9Yb+SBwcoXoRQdmLcb+4z6zC8zIS+ZgYkO00X
        i6Llb8YGaC4IoFjFPI8e/Cq9tJsN4PddSy3FuLNIQsEgcCmTbQm7cEIbxB5tHw==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Andrew Walker <awalker@ixsystems.com>, linux-cifs@vger.kernel.org
Subject: Re: Nested NTFS volumes within Windows SMB share may result in
 inode collisions in linux client
In-Reply-To: <CAB5c7xoUXH6Xy+79Wz8M4yC70E=rwUL0ZRD_ApAFWv=C7S_uxg@mail.gmail.com>
References: <CAB5c7xoUXH6Xy+79Wz8M4yC70E=rwUL0ZRD_ApAFWv=C7S_uxg@mail.gmail.com>
Date:   Wed, 01 Mar 2023 19:37:03 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Andrew Walker <awalker@ixsystems.com> writes:

> On my Windows server I mounted multiple NTFS volumes within the same
> share and played around until I was able to create directories with
> the same fileid number.

Did you try it with 'noserverino' mount option?  For more information,
see mount.cifs(8).

Did it work with older kernels?

> Windows identifies mounted volumes via reparse point:
> https://learn.microsoft.com/en-us/windows/win32/fileio/determining-whether-a-directory-is-a-volume-mount-point

Perhaps we could conditionally stop trusting file ids sent by the server
as we currently do for hardlinks when we see these reparse points as
well.
