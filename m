Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CDC7C001DE
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Aug 2023 16:50:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbjHKQuE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 11 Aug 2023 12:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235446AbjHKQuC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 11 Aug 2023 12:50:02 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9CF30C4
        for <linux-cifs@vger.kernel.org>; Fri, 11 Aug 2023 09:50:01 -0700 (PDT)
Message-ID: <cca8280bb933aa149de1bb9115d2fb3a.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1691772599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JkWyJoVs0o3TSppQZvNn3uASHYJ6pbsE+wpXtCUmwzk=;
        b=p4aCz9lnZuAm+XpXAEyKZRbK3rE4UClXeAAlWm5ePv6MveuLhph2LNjx0cHszAssTztPh9
        3U1P/OJkjDMR5UqYqd8JkYsPA/QJg58lLSqUdKERVk6VFMwD2Na6xgnvfxmCVABghGUlS2
        vmjAYWJ8NcPkOadqeY7TLHmDwUJNqxJ9qRtv0Kb1pjuX//gVRsZ8wRKMiwHOYYjtnUsHva
        VTyjUmziPH97QGwCrUlhY/TTeaiAVHNUE4hn5iBI/McgPq1IWcKtYH1uiVw0XgnRFtB5o3
        nn3hiVqU/JTSf9EBo3fhRamCZzK7RxJq/fnVz6OQk/v8c5CIaS79XOcMS63DgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1691772599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JkWyJoVs0o3TSppQZvNn3uASHYJ6pbsE+wpXtCUmwzk=;
        b=cpMhgUsq5gODgH7twB4bXmz42cp2cwQchfFy2V9MLdCBAjiRIL7LThbHPpLuLIZa1ctdZ1
        q/aJbP/FCNmXABZrWDZ16a93VMdz0nHW3iB+vRATmPZelkGRWJazePy2aU3Ar2aBWZRDw5
        AvUmI7Fy0UcM4OsTI0qYqQl0rxI9+xVwNJX0UPlhj+1GK0f2juSbW0dnUXKa0VgN9OLv41
        q9mPtQtgYBWChieBJjHJoYkOiUhC5CJ2kns/4W8MpeYDxgGjw8mP+Vt+qGaKydJJ6gF8GL
        NowkGJS4N35hxClEUhGGIr4KgdeIzNioNOdHF7+9yaXwheuuBrKdFuL9w+9PqA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1691772599; a=rsa-sha256;
        cv=none;
        b=bMYFNyjtFMN1uDXpGvuc1QA+gjD97gHYV3h6ITvjmPutdfleJ+63l88GHtQ5N8579OLPx4
        HFPx4lU4TPveuqBM0YRRotTESpUeBXZ/1jBGOfN3aPS7GPl+oN5gXfddMINHW4YWyliy+G
        VxbLLFJqDYRTQ6B1YTgFC1ARyufoihgqkHoEWmmfjHd/UDglCLPkIFHW/YwkVrXaYYc/Cz
        AuzE+KAG3wrwONB2uLHYdaEbF8Fr9tmMgxHrlFnGZMQ006CpDWKyGqvIeew+8VecfP9xpH
        xYGbaecJdO4KuccUv+YnrtS2LXUbROYZKdSijdF+lEVotUg+clPijAvkJU89pA==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Jeff Layton <jlayton@kernel.org>, Steve French <smfrench@gmail.com>
Cc:     =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Jay Shin <jaeshin@redhat.com>,
        Roberto Bergantinos Corpas <rbergant@redhat.com>
Subject: Re: [PATCH] cifs: missing null pointer check in cifs_mount
In-Reply-To: <7f1c7940764425cbcf6f6585d138ef38e6618581.camel@kernel.org>
References: <CAH2r5mvxp8OZthKPQGCv82xEkNW+z7SN_QhdRUMnHJ2Fm4pJqA@mail.gmail.com>
 <875yy4red3.fsf@suse.com> <B3F6DE12-CA6D-47BD-9383-B4BD2F73FCBC@cjr.nz>
 <CAH2r5mspWoea04K3Veuy9b-4k_TOLvuA13Xxnc8o0c=8g8zJrg@mail.gmail.com>
 <84c22724edac345b01e1e4b5527426e00b0be3e7.camel@kernel.org>
 <169d12e72d7d732d32051d22f255c5df.pc@manguebit.com>
 <7f1c7940764425cbcf6f6585d138ef38e6618581.camel@kernel.org>
Date:   Fri, 11 Aug 2023 13:49:53 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> Thanks for the confirmation. There were some oopses on some RHEL8 (5.14
> based kernels). The stack looked something like this:
>
> PID: 2415716  TASK: ffff937139090000  CPU: 3    COMMAND: "ls"
>  #0 [ffff9ef946b23728] machine_kexec at ffffffffac867cfe
>  #1 [ffff9ef946b23780] __crash_kexec at ffffffffac9ad94d
>  #2 [ffff9ef946b23848] crash_kexec at ffffffffac9ae881
>  #3 [ffff9ef946b23860] oops_end at ffffffffac8274f1
>  #4 [ffff9ef946b23880] no_context at ffffffffac879a03
>  #5 [ffff9ef946b238d8] __bad_area_nosemaphore at ffffffffac879d64
>  #6 [ffff9ef946b23920] do_page_fault at ffffffffac87a617
>  #7 [ffff9ef946b23950] page_fault at ffffffffad20111e
>     [exception RIP: cifs_mount+1126]
>     RIP: ffffffffc08e8826  RSP: ffff9ef946b23a00  RFLAGS: 00010246
>     RAX: 0000000000000000  RBX: ffff936c8221ea00  RCX: ffff936f8018b320
>     RDX: 0000000000000001  RSI: ffff936f8018b420  RDI: ffff936c8221ea00
>     RBP: ffff9ef946b23a90   R8: 5346445756535c5c   R9: 6765642e50313031
>     R10: 65622e666f6f7267  R11: 0063696c6275505c  R12: ffff9370b192fc00
>     R13: ffff936f8018b420  R14: 00000000003097ad  R15: 0000000000000000
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>  #8 [ffff9ef946b23a98] cifs_smb3_do_mount at ffffffffc08d11f2 [cifs]
>  #9 [ffff9ef946b23aa0] cifs_smb3_do_mount at ffffffffc08d11f2 [cifs]
> #10 [ffff9ef946b23b08] smb3_get_tree at ffffffffc0930ae0 [cifs]
> #11 [ffff9ef946b23b30] vfs_get_tree at ffffffffacb52365
> #12 [ffff9ef946b23b50] fc_mount at ffffffffacb7485e
> #13 [ffff9ef946b23b60] vfs_kern_mount at ffffffffacb748ec
> #14 [ffff9ef946b23b80] cifs_dfs_do_automount at ffffffffc093552e [cifs]
> #15 [ffff9ef946b23bc0] cifs_dfs_d_automount at ffffffffc0935880 [cifs]
> #16 [ffff9ef946b23bd0] follow_managed at ffffffffacb5bdaf
> #17 [ffff9ef946b23c10] lookup_fast at ffffffffacb5c7e5
> #18 [ffff9ef946b23c68] walk_component at ffffffffacb5d258
> #19 [ffff9ef946b23cc8] path_lookupat at ffffffffacb5e215
> #20 [ffff9ef946b23d28] filename_lookup at ffffffffacb62710
> #21 [ffff9ef946b23e40] vfs_statx at ffffffffacb55874
> #22 [ffff9ef946b23e98] __do_sys_statx at ffffffffacb5692b
> #23 [ffff9ef946b23f38] do_syscall_64 at ffffffffac8043ab
> #24 [ffff9ef946b23f50] entry_SYSCALL_64_after_hwframe at
> ffffffffad2000a9
>     RIP: 00007ff6a2637edf  RSP: 00007ffe040017d0  RFLAGS: 00000246
>     RAX: ffffffffffffffda  RBX: 00007ffe04001910  RCX: 00007ff6a2637edf
>     RDX: 0000000000000100  RSI: 00007ffe04001910  RDI: 00000000ffffff9c
>     RBP: 0000000000000100   R8: 00007ffe040017f0   R9: 00000000ffffff9c
>     R10: 0000000000000002  R11: 0000000000000246  R12: 00007ffe040017f0
>     R13: 0000000000000000  R14: 0000000000000003  R15: 000055ce1a3ae1b8
>     ORIG_RAX: 000000000000014c  CS: 0033  SS: 002b
>
> Analysis of the vmcore by Roberto showed that we had ended up past that
> point with tcon==NULL and rc==0.

Interesting.  Thanks for sharing the backtrace!

So it actually ended up with NULL @tcon and rc == 0 while mounting a DFS
link.  Nice catch!

> Steve's patch would have fixed the panic there, but I think the host
> would have ended up with a successful mount, but with a broken
> superblock. The current code seems a bit less fragile, and I didn't see
> any similar brokenness there, but I didn't look too hard either.

Yeah, makes sense.

> In any case, we'll plan to fix this up with a one-off in RHEL/Centos.
> Thanks again for the sanity check!

Would you mind to propose a patch that fixes the above and mark it for
v5.14..v5.15?
