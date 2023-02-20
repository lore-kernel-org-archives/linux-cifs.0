Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B422EC636CC
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Feb 2023 13:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjBTNcD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Feb 2023 08:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbjBTNcC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Feb 2023 08:32:02 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D77618A8D
        for <linux-cifs@vger.kernel.org>; Mon, 20 Feb 2023 05:32:00 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id a30so1304460ljr.0
        for <linux-cifs@vger.kernel.org>; Mon, 20 Feb 2023 05:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xYX/f5fzXl1pVBDq/BuBBDIqeS2gCNyCmk8oOemvz3w=;
        b=oCSqZxzCF9IpxIE3EQrwonjLZaO/F68hcuGuck5ErVF9FRNFd4dyo4CTxoGIhXPgtV
         sUueyn2KZQelxNkve8CObiiNF8YfiHWWA7eQqOPy+BaVcmR36kD8B9FR/WLK9TVHujpb
         xaZzYceK8+p+d6HtZaXFdr/J8wL3MKzrtqIl/+NzT/qLBHUgxp+FW9xvXiv7aDuRN9Vs
         cm1csnym0pDkmuMXO090LwXHPTi7PLWGMzCykBcyGzVYLXXOfCPEqHixLgpPKfJoR3ky
         neN9jvLq8PvfNdC6ewL00HrmxosYHCmf6f7f9nAuFkkDxgHyV4OyE1h8Ff8iqUVpAwLJ
         bdnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xYX/f5fzXl1pVBDq/BuBBDIqeS2gCNyCmk8oOemvz3w=;
        b=mtgoQeSyDpyS2xjUID/nJbWC6ZFycC6Sqr/YrMZ3QH/8eSunMoXbU/c7hAd8lV0/aT
         cRYrnuH2rHmd59Rr+7hCg7f7kNFbK2v1qtDNl81QPygCBXpKkY1dZePru6UTfOP9v6Wn
         XRcdAZ1EkNa9/fBbuEtncGFlmA/ODzdWSUC2fzI5lVeyh+NrzPYbI6fQXp++XnU1FY9m
         tSd4Yfb9iUZXVcYoMcg7+LmLf4fm3m/qZ2P1/uk8c/0Lv5qvyQSwJ5trynVEyuowho7G
         wrO3OdI/vMJ/hnwpxOwALV5B+77kMs2wsvH+2my5oGlhZs4R+OOLh/K6NyWYpz+rGzRC
         2fLw==
X-Gm-Message-State: AO0yUKUyy9zu0EuY3So4hi04bkrw5t4mZS63O05rZ4ZO57BPdTl4HT9Z
        6gGCPY2ri0UXj0m2DnW+r8tREzVi0L9KSd0ZfDc=
X-Google-Smtp-Source: AK7set9MWNZppCuuMQDeyxrVbiqtiDX3BF2A1esoBR6yWW7L+SZKZqiSubUnmevCP7Qr2rBLma0wB6N1j8FhmCB2pCA=
X-Received: by 2002:a05:651c:10ab:b0:28b:e4ad:14b6 with SMTP id
 k11-20020a05651c10ab00b0028be4ad14b6mr651952ljn.5.1676899918668; Mon, 20 Feb
 2023 05:31:58 -0800 (PST)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 20 Feb 2023 19:01:47 +0530
Message-ID: <CANT5p=pOGn4Gc3T1FOQCmhFxM=-Wn_0GcV9owty8NELjQ1r0vA@mail.gmail.com>
Subject: Fixes to multichannel reconnects
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Bharath S M <bharathsm@microsoft.com>,
        Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Stress testing of multichannel reconnect in Microsoft uncovered a few
bugs in multichannel reconnect codepath (particularly when reconnects
happen in parallel).

I have fixed those in the following commits:
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/a87bb308b7d126b522d4390dbf37f63e743133ac.patch
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/0a95e989840d2617940ad4670c52b43646b491ad.patch
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/5640b4cd537b70a690e3c1a6aa22afced71c8c87.patch

Also fixed a couple of regressions:
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/30a563a20e00f99899b703f32feb30793b04bfcb.patch
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/0c1c85c0720ef8fa3bac3819315e8d9311926915.patch

All the above are critical fixes that we should probably CC stable.

And a minor fix:
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/be94b055601c48f4156e48da7b282d51970bad07.patch

I've tried to break up the changes into separate patches. Please review.

-- 
Regards,
Shyam
