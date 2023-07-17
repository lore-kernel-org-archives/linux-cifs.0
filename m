Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 475D1EB64DC
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Jul 2023 15:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjGQPCG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Jul 2023 11:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjGQPCF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Jul 2023 11:02:05 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4661BA6;
        Mon, 17 Jul 2023 08:02:04 -0700 (PDT)
Message-ID: <8497337677209ff8a9418f1a4873eb3a.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1689606122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=54qdC8498DlkNTDRty9QASCfdA85ErVQYd+x/s04498=;
        b=k8q+A4gkndJTbnEPkIuS9+QR9OOpVfxVQHERfYjIvdXh4fI4g0PfO+xxJ9Yfh+cixbR95+
        v4F9SCgrveGVFTpCfhQPtge3Owkzp0vbc2JN2aUT+8OdgBGsdPq6GAt1IV/8IZhII01wMj
        P8cXp9hA0R92fk+QNLophm9g2Vms5ZaLk8X7TRKhobwwZvvIG67HYpxhVWwUl3tK7CmcNt
        QFgUvoDNcSMWr94XpkB02E1Uj0no9fur1IgpgVtuaR3+g31YUku6BtatSsEBTt0lgjOMRd
        tL1oqAg3XX2f+jfCpP3e6tuZULJx0sNr5ZOly+pXDb8EnT5o/8oIKsveX46NYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1689606122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=54qdC8498DlkNTDRty9QASCfdA85ErVQYd+x/s04498=;
        b=MeM7Jod02x1RYPt9w6clN6xvoH1mCYf8JxxTqdWsAz7t0H/lqCvWId8vM3NVpz2khcM61p
        1tvuFsX/pUEjO8VrQ8wnN64r/um7G/7KMgN+bEwDLuuFvfxICPehEYKL5U9g3hTOdRrgL2
        mspnL0FdEVJkbRadOa/jD5Yga5+u6wd2sfZEsu6j6tUWNxhIHktzyb8ELVmPQDiX0gR4+5
        udIh3XsFsD5hSU0iI8CrrH/J20+z/aqfoOIfdr3dAtlT7SOgRiCY4QOnljF3vchbz7naZp
        vp4z1wWqd5kjVfAunNS6I+R+icfxlGPlR4nTJgV+rbJCw+GTKm1rSucFhT3gOA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1689606122; a=rsa-sha256;
        cv=none;
        b=kjKjMjIZ7n3pH4ia5nwuowMMBdcFkB+DxOECGgRLhGm0fJWgjv/JXYhMXMOw4AcSwRWPAI
        koJe43EcG24B47zRFT+l4yq5RheHvyASG/eoJo7YiGHLUbpINvJ7BGEulnCWLD2vS/t4O+
        SaPk0sMjETcdQp9nHH6xIRhPjIxkPcdT2yFV9r8/xzNQh3p+Rhv1LcEeilFahaomvjczXw
        Ik7dNvCCNJwju/BndLwqiIkIm9iPLMgWwsft1EZkm3ozjuNJo6wOkXsfEG/Tu3VJfwbT+a
        aV7YtZf9wMQ0yo+kWqqXjdUwbhAfGaXVi0faPps2gYu47bEUWP5Smm5FoNIiEQ==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-cifs@vger.kernel.org,
        Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 4/4] smb: client: improve DFS mount check
In-Reply-To: <2023071646-freeness-untrue-230d@gregkh>
References: <20230628002450.18781-1-pc@manguebit.com>
 <20230628002450.18781-4-pc@manguebit.com>
 <0bb4a367ebd7ae83dd1538965e3c0d2b.pc@manguebit.com>
 <2023071306-nearly-saved-a419@gregkh>
 <b95eb538478eab38fac638dbeaf97e70.pc@manguebit.com>
 <2023071646-freeness-untrue-230d@gregkh>
Date:   Mon, 17 Jul 2023 12:01:58 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Thu, Jul 13, 2023 at 06:48:00PM -0300, Paulo Alcantara wrote:
>> Hi Greg,
>> 
>> Greg KH <gregkh@linuxfoundation.org> writes:
>> 
>> > On Wed, Jul 12, 2023 at 06:10:27PM -0300, Paulo Alcantara wrote:
>> >> Paulo Alcantara <pc@manguebit.com> writes:
>> >> 
>> >> > Some servers may return error codes from REQ_GET_DFS_REFERRAL requests
>> >> > that are unexpected by the client, so to make it easier, assume
>> >> > non-DFS mounts when the client can't get the initial DFS referral of
>> >> > @ctx->UNC in dfs_mount_share().
>> >> >
>> >> > Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
>> >> > ---
>> >> >  fs/smb/client/dfs.c | 5 +++--
>> >> >  1 file changed, 3 insertions(+), 2 deletions(-)
>> >> >
>> >> > diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
>> >> > index afbaef05a1f1..a7f2e0608adf 100644
>> >> 
>> >> Stable team, could you please pick this up as a fix for
>> >> 
>> >>         8e3554150d6c ("cifs: fix sharing of DFS connections")
>> >> 
>> >> The upstream commit is 5f2a0afa9890 ("smb: client: improve DFS mount check").
>> >
>> > Does not apply cleanly, can you provide a working backport?
>> 
>> Find attached backport of
>
>> >From 435048ee0f477947d1d93f5a9b60b2d2df2b7554 Mon Sep 17 00:00:00 2001
>> From: Paulo Alcantara <pc@manguebit.com>
>> Date: Tue, 27 Jun 2023 21:24:50 -0300
>> Subject: [PATCH stable v6.3] smb: client: improve DFS mount check
>
> I'm confused, 6.3.y is end-of-life, and:
>
>> 
>> Some servers may return error codes from REQ_GET_DFS_REFERRAL requests
>> that are unexpected by the client, so to make it easier, assume
>> non-DFS mounts when the client can't get the initial DFS referral of
>> @ctx->UNC in dfs_mount_share().
>> 
>> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
>> Signed-off-by: Steve French <stfrench@microsoft.com>
>> ---
>>  fs/cifs/dfs.c | 5 +++--
>
> This file is not in the 6.4.y or any older kernel tree.
>
> So what tree did you make this against, and where should it be applied
> to?

Err, sorry about missing the EOL of 6.3.y.  The attached patch was based
on v6.3.13 from the stable tree[1], where it didn't have the rename
from "fs/cifs" to "fs/smb/client" yet.  Please ignore the attached
patch.

So, the commit

        5f2a0afa9890 ("smb: client: improve DFS mount check")

should be applied to 6.4.y.  I've checked that it applies cleanly
against linux-6.4.y from the linux-stable-rc tree[2].

Thanks.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
[2] git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
