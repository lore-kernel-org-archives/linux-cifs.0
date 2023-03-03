Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B65B1C61DA4
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Mar 2023 22:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbjCCWMI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Mar 2023 17:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbjCCWLr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Mar 2023 17:11:47 -0500
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800D7918B0
        for <linux-cifs@vger.kernel.org>; Fri,  3 Mar 2023 14:02:09 -0800 (PST)
Message-Id: <4deb5a94a6d3dfbdd074c3b370399a35.pc.crab@mail.manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1677880527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8zo09FVyfJOxelQU7T4tlz5RAGHSi5xR1nCF07Bv6GI=;
        b=cvXU3CwK+wK8WD0b1aHAeE5jZvBrKhWMfDacARqVWVE23WMI8vvAfrBnCLO3XCOmki90EG
        D3O77Iuigi31Vl7M/n2q4IC1CgSKX0jy00+WA9Pa3k8UuLT9xYCM4tJ2aZ4+BhRit3r5JS
        u+swBbYWEPmwhy9eGQcaHn707pPes2BK+IDjdL7R4DUKQp2Vt8SMa+3XLExMRlIWk4W/r/
        nRTq7bc4iqakJ2RePF+xrG/pXAzIJwhq6FKrxuLHZpp41LiG389m0C+KjT+ZtVPWAbyH8D
        6H9jX4c5cIq+nT/haxdjd7dF9S7GC8GOK7EAf+5nLTP3lscztb4TN0vv+r8+dQ==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1677880527; a=rsa-sha256;
        cv=none;
        b=M3UouN37sbIreAQU+14uPHDN50/F6Yr42/Bwn2+IHMdVbd1DcmsaoujAzW9zT67/lsk9DZ
        rpBune1jwuXznjUXy0aaxfEvUZR1e8pW3QVoBkpT/R0QE0c660/aq3DAl4b37EWYFB7qhX
        tyMr+DDnxZ36dBOPyV99eMeuaXR5l0BXzCrNdlZYVeRY4O33BdgX/cf50zyWClXqFcfqgf
        Ceg5plGbvF9HsxB6B0578vapKGM+Yn9ZcIWpBgu3APL2YW5izYL0VR3Nr1X/GICifzVP9a
        FziUHQq6wB+HDzJM8QrVxN3CZzwoso/h3IwxlrapQ98VyDcGMUvCTmz1itC6kw==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1677880527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8zo09FVyfJOxelQU7T4tlz5RAGHSi5xR1nCF07Bv6GI=;
        b=LXczR94v5rk/ZPGFIZgbA19uiWYlTeZ0YqffgoHjwwqj5yDOIueVXcHdmeJojZMbbNPXKc
        d6skVBN6B/2OxO8bnJzALeLdtSiDKMQo+zJoHxAfkEBA/UTl3vhA416hdlucMxzILKG2hP
        ywXvRqYneMuavnKnfz/Oz3wh0409Dvg1+NcHxsOQEw3aTTgEuuxHNn51f88CMV4sNI1+sX
        fyt/XZlmXivXBSe+pBNgSSELh8Icm8/EcBUWQ56uNseEWP+Pg7ucOtfwu4X+pBatATiLqj
        sRjN/xa+xroNJuGLjbzQZIFTEzMopLj9XROUft50UyCa9HDqUioWI9i3hA8Inw==
From:   Paulo Alcantara <pc@manguebit.com>
To:     ChenXiaoSong <chenxiaosong2@huawei.com>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        linux-cifs@vger.kernel.org, sfrench@samba.org, smfrench@gmail.com
Cc:     lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com
Subject: Re: [PATCH v2 0/2] Fix some bug in cifs
In-Reply-To: <c6a6e4a0-a66b-e86c-8c67-fdd24fbfcce2@huawei.com>
References: <20221116031136.3967579-1-zhangxiaoxu5@huawei.com>
 <c6a6e4a0-a66b-e86c-8c67-fdd24fbfcce2@huawei.com>
Date:   Fri, 03 Mar 2023 18:55:22 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ChenXiaoSong <chenxiaosong2@huawei.com> writes:

> Do you have any suggestions for this patchset ?

Nope.  LGTM.

I was able to reproduce this use-after-free bug as well.

So, for the whole series

Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
