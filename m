Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54920C4167B
	for <linux-cifs@archiver.kernel.org>; Sat,  4 Nov 2023 19:00:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjKDTAc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 4 Nov 2023 15:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjKDTAb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 4 Nov 2023 15:00:31 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D444184
        for <linux-cifs@vger.kernel.org>; Sat,  4 Nov 2023 12:00:25 -0700 (PDT)
Message-ID: <6eb760f70f3dc394866364109ad166c3.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1699124422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6kHOvqc06aHPzE9iXBT5wgYB4SJt7n+s2RoSQs0NxCc=;
        b=OOM1Hn5+6mPhDmG+ctsbmk8MQ5Sty/+K1zwac/vWy4k0qR9CL1PgHqSabldwT+5Q0zsgzQ
        0W5WnEa27PGwhQgE2h98J7hBgXdHq7HQt0ZrmcwuxC2g9CleY7i1GU8nn3N2CGP0Qc1zFi
        vTegSfZsLKRnHUej8pyxitGFpG7jspeC3N29i4EYMGicyLXiVvYofqmYaY5gb4scobiS06
        hutX3xKBCMOygLqjKi0M8heIHQjB0KFlFp80eyPsfZJDQMJYjoQmroi1qtKwwG3P3XlxAf
        ECef78h8fLzkjp0wTRgkZYwNASdHsFcGEPN13d8RVvn9QgBpvV/5Nqvqv7j1cg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1699124422; a=rsa-sha256;
        cv=none;
        b=lL92X8OAeCplyR8kGDvhocY+jub5Ejr6B8vUyA8LJ63pEqYCP+42OHxyMxqm+wOxFxfWqg
        Gq3ZlJoI4R/7vZQihpschsI5sImfIsYrlKbdYWxrUNdB9LGDlp4wsRNopoLw1t4dI0W5l8
        SLp6cnv2dOmZIFcd8DtR9RKfASBSHMSZWAod/JKQ8qJzjqf1IOfK4BBvR2BCwHLeIZVZcQ
        9/h9lItIjVEPkA6xhFmUkCTeYloo/FD4ZfhpI40YaE2u9xjCfyPOT4UNe1f/7+v2SjxV/b
        5bwrY7O+j9l31BPRfmcK1n9brNoHx+VG6+Bpposs423Wy032oTcrDW8IjUcS0A==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1699124422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6kHOvqc06aHPzE9iXBT5wgYB4SJt7n+s2RoSQs0NxCc=;
        b=PdBJlybwX+awuesqPPNgJXQOih0tpakPxoKJ6YBy+4Tnt0K3ZX38G1niGh3Ak9HBvzCRUD
        msfyAIiGZ+6qtdiJzc5N+7ywEBWovAc+FBO7JbUrRVlo8HV1W41RK+dDug9jPc71YtRYSc
        xEhBTw9ZghQiKuNBQMbo/MiDxhQFAmMZWd3tuXRkyd0+N/UbdzzPAM9dkxQ4BH3jReH67k
        V9Yw3++hAnyNVO4otHHrZycidxxt9BfQl9xO2JC5pKS1SoFwTWtS247TmyHGTTTX1JC9NM
        /XZkF1KFtBMYegMKo8enSZDIXdOilzL5Z8Er+ds34m6ax0LwZNHXK7AykHkHGg==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     smfrench@gmail.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 13/14] cifs: display the endpoint IP details in DebugData
In-Reply-To: <CANT5p=pna6WxpSy5fXwsDGRJFRVpRaVCzp8uLFV4keOXcdvv5A@mail.gmail.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
 <20231030110020.45627-13-sprasad@microsoft.com>
 <d1c99946663662e7160bf1ed0a6b2dc6.pc@manguebit.com>
 <CANT5p=pna6WxpSy5fXwsDGRJFRVpRaVCzp8uLFV4keOXcdvv5A@mail.gmail.com>
Date:   Sat, 04 Nov 2023 16:00:19 -0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Shyam,

Shyam Prasad N <nspmangalore@gmail.com> writes:

> On Wed, Nov 1, 2023 at 7:42=E2=80=AFPM Paulo Alcantara <pc@manguebit.com>=
 wrote:
>>
>> Paulo Alcantara <pc@manguebit.com> writes:
>>
>> >> @@ -515,7 +573,18 @@ static int cifs_debug_data_proc_show(struct seq_=
file *m, void *v)
>> >>                              seq_printf(m, "\n\n\tExtra Channels: %zu=
 ",
>> >>                                         ses->chan_count-1);
>> >>                              for (j =3D 1; j < ses->chan_count; j++) {
>> >> +                                    /*
>> >> +                                     * kernel_getsockname can block =
inside
>> >> +                                     * cifs_dump_channel. so drop th=
e lock first
>> >> +                                     */
>> >> +                                    server->srv_count++;
>> >> +                                    spin_unlock(&cifs_tcp_ses_lock);
>> >> +
>> >>                                      cifs_dump_channel(m, j, &ses->ch=
ans[j]);
>> >> +
>> >> +                                    cifs_put_tcp_session(server, 0);
>> >> +                                    spin_lock(&cifs_tcp_ses_lock);
>> >
>> > Here you are re-acquiring @cifs_tcp_ses_lock spinlock under
>> > @ses->chan_lock, which will introduce deadlocks in threads calling
>> > cifs_match_super(), cifs_signal_cifsd_for_reconnect(),
>> > cifs_mark_tcp_ses_conns_for_reconnect(), cifs_find_smb_ses(), ...
>>
>
> Good points.
> I'm just wondering why I'm unable to repro the same though.
> I have lockdep enabled on my kernel too. But the same steps do not
> throw this warning.

That's weird as I can always reproduce it when mounting a Windows Server
2022 share with 'username=3Dfoo,password=3Dbar,multichannel' options
followed by `cat /proc/fs/cifs/DebugData`.

Here is the relevant part of my .config

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=3Dy
CONFIG_PROVE_LOCKING=3Dy
# CONFIG_PROVE_RAW_LOCK_NESTING is not set
CONFIG_LOCK_STAT=3Dy
CONFIG_DEBUG_RT_MUTEXES=3Dy
CONFIG_DEBUG_SPINLOCK=3Dy
CONFIG_DEBUG_MUTEXES=3Dy
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=3Dy
CONFIG_DEBUG_RWSEMS=3Dy
CONFIG_DEBUG_LOCK_ALLOC=3Dy
CONFIG_LOCKDEP=3Dy
CONFIG_LOCKDEP_BITS=3D15
CONFIG_LOCKDEP_CHAINS_BITS=3D16
CONFIG_LOCKDEP_STACK_TRACE_BITS=3D19
CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS=3D14
CONFIG_LOCKDEP_CIRCULAR_QUEUE_BITS=3D12
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=3Dy
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
# CONFIG_WW_MUTEX_SELFTEST is not set
# CONFIG_SCF_TORTURE_TEST is not set
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)
