Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8AACC4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Oct 2023 15:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344998AbjJaP1k (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Oct 2023 11:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344992AbjJaP1j (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Oct 2023 11:27:39 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E824E4
        for <linux-cifs@vger.kernel.org>; Tue, 31 Oct 2023 08:27:37 -0700 (PDT)
Message-ID: <92001e6cc16020d2990229c411b6f78c.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1698766055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L0G7dOQQ5LERiozG2dDhHhRMzmDtEjtbmydtLfbxVsI=;
        b=DNiCSJe9Qvoplhi4Nby3Ud2qwqGskKoyDimQYEl1OU0hz+/WWO7H1y957Hv7sr1Kr8qYNa
        Q0/hOhVLCU/WwX3DKOtEe+Y+bs7MJoN1ybzwQtXj3cchawjOqqIogUt7OJfSMuvo7iHaAi
        u0RjJQTAkwK4V57EKv0gAHAVQXrG8yWHqW9H6rBxFBZ+1Vo/khceXVQfxjJHaFMdAz85gK
        s4zqBuU7IFniQpy+R0z53v0sBhaFL41OgN/ZB+DXxoQimW6jMfqJogJm5SSu1H/6RXRWPX
        XiAv7qFNn46an01mniXGVNuKzZAFbRwl+jzLk+9+Bftb0qG/eXKfAgI7CczH4A==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1698766055; a=rsa-sha256;
        cv=none;
        b=I8sP2oNKTuMDuVZIJyMmNDLsGpSKY/g/O2R9TC4VnmXBTsItjU7NPQ0QRxBDibjDHqbmi1
        z3ej1t5e5PsZ9rJl/UI0DDx5aNq9cmbeVUyFl7HD/iTto8lHDZaXdwyy+dx8c8/vPoHjkT
        AjEoUSErReoq+Z7YAJECiWec3OVT1qFeNkz4NhvLgpp68Nue/TRSGUNHdTtYg3R4l+DiR9
        Yf2eK/1AdJZNwS11yEWwRvpCCVnfEzU5IFGbE/eUyZrCKTYQR7Qlt6/CM4HgQDWj+BK34Z
        kHwiLv4z7DQ+l7OKJfpjpPmZk7AlfLaiiqiHOHd4K3atQ9REDARufzBT1NsA6w==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1698766055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L0G7dOQQ5LERiozG2dDhHhRMzmDtEjtbmydtLfbxVsI=;
        b=VGZjLugnelOm4SRL+LKqFpIRmvkCtFBStRnYAeECACZnPCI0rl0bTFids+sEgNcqLbV3cQ
        5WU+RZyisiaW8Tm1qzmdIrFC3BJ77p9o9Y0P0nybcehtesyrDARoYHoKqujABQSV73cPLV
        ys1E8J64h8nTn/fmIHk/wNVMVFFhF1exr+qKuupR3X9SmwX2ZhaEA2N8CiDXYvkHW/NjBG
        xFyZhUpyubpIC/wj0EUMQqp1bZBBTt9uB0+jxuTTDMgEDKbb2TWtPFcJZEVeAqiko8ATkw
        nV5O9k9WtaHFKfT5aVOdgp/EfHdxYVct+jmx+Wp/KLBBqGlLrI8RE+jA6YlVZQ==
From:   Paulo Alcantara <pc@manguebit.com>
To:     nspmangalore@gmail.com, smfrench@gmail.com,
        bharathsm.hsk@gmail.com, linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 03/14] cifs: reconnect helper should set reconnect for
 the right channel
In-Reply-To: <20231030110020.45627-3-sprasad@microsoft.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
 <20231030110020.45627-3-sprasad@microsoft.com>
Date:   Tue, 31 Oct 2023 12:27:31 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

nspmangalore@gmail.com writes:

> From: Shyam Prasad N <sprasad@microsoft.com>
>
> We introduced a helper function to be used by non-cifsd threads to
> mark the connection for reconnect. For multichannel, when only
> a particular channel needs to be reconnected, this had a bug.
>
> This change fixes that by marking that particular channel
> for reconnect.
>
> Fixes: dca65818c80c ("cifs: use a different reconnect helper for non-cifsd threads")
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/connect.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
