Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 101F3C6FD1D
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Mar 2023 22:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjCNWUp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Mar 2023 18:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbjCNWUF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 Mar 2023 18:20:05 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008BB5B41D
        for <linux-cifs@vger.kernel.org>; Tue, 14 Mar 2023 15:19:26 -0700 (PDT)
Message-Id: <95f468756e26ebfb41f00b01f13d09da.pc.crab@mail.manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1678832360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t9rOyuquRTMOIVUpzgcYzK3YdsAgenvIWMRQpPFfYAk=;
        b=LgyS+eB1FGjdn0Bh7EVLi/JjtQbuD/27r5e1B6R95G3L8kafMkJjRjvlgG2o6JGqHDC2DT
        smZn9XWPOkEpxd7opGvqUxcv5QN7ahtD+S7hF7XY1hSdWLrjKUJi57qdhceiP5rCG0PwA5
        EuR9s8DqEr+gDuXOlzi/jrzyLzeOaUrCvoe6kpHa6mMnT2jUZAEEchmnoNF2anbmgefDGO
        yHkOi76e+6UtpaDbmaw5bJ+1PdkdeMl/90vIwOHXNQuxpAuDTFRjmM7SIrXPVWazbYzcOn
        Af4rhSEomEBWjVkrAK8NipCG8SOmcpFEk+0cDX6+v/aL9x/OoDKylRbhr/Ec7Q==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1678832360; a=rsa-sha256;
        cv=none;
        b=FUjKmWiVkUl2gLioieRVyuu1ufvdqFbaatsJF6bdxUquBXhSGiYYumGS21apcfOsJv8ixe
        PdlY2D9z55ohSEYjpHh0jysthA7dn20UAYK2Epe+NHUb1ZWk2HAi4iY3T1H59XdMad4N2d
        FGzoRVvt2GaC20YPzywCHJ22VBVss/oda7LvErIyzswYKVouRRJ6Yfzv/bl1PGgwnJcer2
        chUPpiNtF6C7R3prZkUqWYGT3RwsE9Ow1ZFzxlEyGqWIYKONopt2qwcY2JLYHo9cUiHOq5
        5JmUQueZ8Tl7/NT6KUtnEGDp4x7EZaoJM2p+394J/JVRkntYnjbPwkJhBRR/UQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1678832360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t9rOyuquRTMOIVUpzgcYzK3YdsAgenvIWMRQpPFfYAk=;
        b=mvAcDmCXH+jnvu9MfE8x3k3WfImLV2Hn2QdPDpyYLcxuNvYD9BKInyFRUl5DNlUqrj8mw8
        M0R+PL+7MIDuqyPBi1yaKeek3Ss7HbI8d0ZHh1ySXGMGtVjZ7ljUYjoL5RKRCi15gbZH6e
        EoppQfo6HbuE/xd6/XH73hoGOIOfWBcFAbb0/9iZnQGQSYQlKM+0m6H5wNiZlDW4yq6lsC
        lDQtltNcrBzyJITGlqy3UoPp96TyYIrHffuRRNU/lRpE41rEqVrjUn6JUxE/MHeUnDbtZ6
        +B8iWEt0IaJD9Mr+PL0mmVY9GJDWli3saECwTE17RFDcUkUrKeAUDqoOHNkGaQ==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>, smfrench@gmail.com,
        bharathsm.hsk@gmail.com, tom@talpey.com, linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 01/11] cifs: fix tcon status change after tree connect
In-Reply-To: <20230310153211.10982-1-sprasad@microsoft.com>
References: <20230310153211.10982-1-sprasad@microsoft.com>
Date:   Tue, 14 Mar 2023 19:19:15 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Shyam,

Shyam Prasad N <nspmangalore@gmail.com> writes:

> After cifs_tree_connect, tcon status should not be
> set to TID_GOOD. There could still be files that need
> reopen. The status should instead be changed to
> TID_NEED_FILES_INVALIDATE. That way, after reopen of
> files, the status can be changed to TID_GOOD.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/cifs/cifsglob.h |  2 +-
>  fs/cifs/connect.c  | 14 ++++++++++----
>  fs/cifs/dfs.c      | 16 +++++++++++-----
>  fs/cifs/file.c     | 10 +++++-----
>  4 files changed, 27 insertions(+), 15 deletions(-)

With this patch, the status of TID_GOOD is no longer set after
reconnecting tcons.  I've noticed that when the DFS cache refresher
attempted to get a new referral for updating a cached entry but the IPC
tcon status was still set to TID_NEED_FILES_INVALIDATE, therefore
skipping the I/O as it thought the IPC tcon was disconnected.

IOW, the TID_NEED_FILES_INVALIDATE status remains set for both types of
tcons after reconnect.

Besides, could you please split this patch into two?  The first one
would fix the checking of tcon statuses by using the appropriate spin
lock, and the second would make use of TID_NEED_FILES_INVALIDATE on
non-IPC tcons and set the TID_GOOD status afterwards.

Thanks.
