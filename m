Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C2FC433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  6 May 2022 11:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391345AbiEFLcg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 6 May 2022 07:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391342AbiEFLcf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 6 May 2022 07:32:35 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B83B13F7F
        for <linux-cifs@vger.kernel.org>; Fri,  6 May 2022 04:28:52 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id m20so13853820ejj.10
        for <linux-cifs@vger.kernel.org>; Fri, 06 May 2022 04:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=PCF/pPZzicnL9gJhCZ5TOR8bjHK7/VkPyt8svZeH40U=;
        b=jq4DqjB9wol9gzIfr+ZtjEfp2mNQzQLZreBuovKbI1xQ6BLSDGrdOlkp0YlXeTN7MH
         BveXV8zNtw66kxaiOVBPIF9pu0qeEpV9IkC/azswIsM+gn1f80ty2UmFV1zBlgIIIfQE
         +0/20GirY1EeHRGjSXuVUKLsbH/KLvUEiq2Kxzr1GyQNFTvOszjHFxeq1N0LRRAt7Buv
         30EVSwhhHBBMgBbiBNdFwJbXxq2oBX7LR4Xm2Q4zrL65YFfIu+gyxYbnztRw9jZdxz+p
         V9F3aq6iAwkQU/V4NFZGAFQYLhHc7VMPyboAz+vSQfiqZzux4M8b9dYDr1NasFF4ETv6
         MPVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=PCF/pPZzicnL9gJhCZ5TOR8bjHK7/VkPyt8svZeH40U=;
        b=XbGzKrWqJMEiwj1IekelafZw163zwn3oWFb8jwYzGT3IrXMKnzS0ZTaaZ2xj14Kl7v
         5FMTEn/qNVZoaKJ7DuIGpl1U73SWDVHVRQVLvQ3OxnOAPM+hi1KonLqx9zst/R5q7jbk
         VJSAIOxZA8uLEyQ9WBkVh6EClcX0H8qxjNqJpGfZNLXCZS44v/i4dYFSjWUtqichDYCC
         cpMwpt20J/D2wSKKkYhW4LoUHpMjy4ZXYUBNrtLYfUi6inGdtB4F3ipNN/JkiqSKY9Ny
         l5FhA/24Yhtzhsjbq2WsufX/kOc+N/rg7Vm5y87oPXjeI01/DIuN/qb3RqV8CU6Fu3zO
         LgEg==
X-Gm-Message-State: AOAM530diKv5n90CeJ7Kdxj3K1qVDNLqWj3OR/1CvEPHzfbFqGIBN22u
        306kwzm/1Wow9Ncd/EaXJH+yN+8QSeT0KF9SHFJXA8cXFoevfg==
X-Google-Smtp-Source: ABdhPJzXvg/GlzDQ+eZZpjtGFuM5Vskskvk1eazq9iLFvbkmehyuMHvDhBATAzwRnizFqzhU7VCGn4If7TjRK9giDDQ=
X-Received: by 2002:a17:907:7f2a:b0:6f4:a358:c826 with SMTP id
 qf42-20020a1709077f2a00b006f4a358c826mr2497483ejc.404.1651836530943; Fri, 06
 May 2022 04:28:50 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 6 May 2022 16:58:39 +0530
Message-ID: <CANT5p=rgt8bcy4PrEP8r-KXFwu2msTk2pRNFSbHrpVSFrAYkaQ@mail.gmail.com>
Subject: Improving perf for async i/o path
To:     CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

This is a question for anyone who understands the async I/O codepath
better than I do:

Today, we have the esize mount option, which delegates the task of
decryption to worker threads. But the task of encryption still happens
in the context of the i/o thread.

If the i/o process does synchronous read/write, it isn't such a big
deal. But if it's an async i/o, there is a potentially significant
perf gain that we can make if we can offload the heavy lifting to
worker threads, and let the main thread move on to the next request.

What do you all feel about moving the server->ops->async_writev (and
async_readv) to a worker thread? Do you see any potential challenges
if we go that route?

-- 
Regards,
Shyam
