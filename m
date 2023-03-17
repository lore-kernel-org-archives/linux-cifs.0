Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59DE7C74A5B
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Mar 2023 12:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjCQMg2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Mar 2023 08:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbjCQMg1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Mar 2023 08:36:27 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFF194A47
        for <linux-cifs@vger.kernel.org>; Fri, 17 Mar 2023 05:36:02 -0700 (PDT)
Message-ID: <4913391e6b2ed4672fd427b479460eae.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1679056505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vHoMkyfGjxnHLflN/ohKYeEJ8K7Scd0ZrRo3bqjfyVk=;
        b=CTN7Pxm8TuLH56mfNnbbMb8lnKhbFNg+azBVMPy92SCx+IPbR3i9T7p0DvFyn0GscXJLwe
        D6ZyD9BHVOC9/se+DJTemapTz2I2lcvOI+ANJdwYWk7puiqDXlgpNod1nFKX6SQwe1h3aA
        OkoUuWwYUfomgOm5h7YuscFIuGcgQDLBR4g9M5juMrHbOgfPr5d2bohvKEdfC/k9TFA18N
        vf0uFsYKe23xpW5Gc42YA2AoLwEWr8nBY6K2JhNrTfLZr+DHhXcIHqQBWtNkC/idodtqLY
        59HSZVxaDexf0bCpIYExb4HY2IdUA6o083pf1nXMvfH+w9DUwf5CEPkixPKHOQ==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1679056505; a=rsa-sha256;
        cv=none;
        b=IpFlVihUReGKzjTkc4qmWpp3zJJLgjK4X+yLnkPOYt8xcE9ydpU01OhyzGC6CLMxc/cok7
        VU9z4cDy7Gu0h481N/OctZmKSD6spK5KjaarkY09hKWXtZXL04bgB5AxNyGgOLRPLtdvgU
        FVC98SEH4lXKYrEfb22Wjvne2/4K9P4weYuHk7u/bRc/Fyu/uD+jOFfNOgsnvZYXzq3oiD
        P1oTe5DH9CnjN6K2m5nmSc1NJZ6EYz29zhfPFn9cpsG5uYRwFxabhB6Uj3dHQbk7X4Z3Cl
        kINKocXVL0XvmmavhGRdxEWwyfowQRlzSo965ZO2hHRgc6Ek7R0/xLicoR6o7Q==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1679056505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vHoMkyfGjxnHLflN/ohKYeEJ8K7Scd0ZrRo3bqjfyVk=;
        b=eMZTVsa8azcLz1Vp3T53Qt4GBJY+HvFrmzlxkezwsjXIVCyVE1QoyYXQhfI6ZW20YZEDLj
        +fCB4+TeyleFydBmX1VIzKowpwnHQe2OjGlB4QvzZguUccQJpVwX0xEO2Trl0exmKFIxgm
        FJJRTShx5eoLK6QzoC8d7iC6VKaSmkAwFdrbwXIeF2trrOq6z6sozMzTw69hgaFVdrSmok
        U4W4oI+Oi12h1wrL9kb75vPcIf9Bwgt7niBgV9HKFA8cGCeRbRcb7+lv24v2rhdXN+v/Hc
        AS6yivZEovdJ5g6Y5nfPtNiAdnbrLGrfpqYvOmxMdqPOTro8DbMmNPLKikz7Wg==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     smfrench@gmail.com, bharathsm.hsk@gmail.com, tom@talpey.com,
        linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 01/11] cifs: fix tcon status change after tree connect
In-Reply-To: <CANT5p=qyFkJn0cCfiyJma3RFcmeBcjq4C4qDhw7CL8A+fiAUEQ@mail.gmail.com>
References: <20230310153211.10982-1-sprasad@microsoft.com>
 <95f468756e26ebfb41f00b01f13d09da.pc.crab@mail.manguebit.com>
 <CANT5p=pfZNefhzGSytg9tuGXhNgvesVecTGoZFhWnUmnLxb-9g@mail.gmail.com>
 <ee7ad068976dcf1a7356fb6cd230fb69.pc@manguebit.com>
 <CANT5p=qyFkJn0cCfiyJma3RFcmeBcjq4C4qDhw7CL8A+fiAUEQ@mail.gmail.com>
Date:   Fri, 17 Mar 2023 09:35:01 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:

> Here's the updated patch.

Thanks!

Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
