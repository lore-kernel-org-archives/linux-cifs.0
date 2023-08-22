Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F87CEE49AB
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Aug 2023 23:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjHVXdU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Aug 2023 19:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbjHVXdU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Aug 2023 19:33:20 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3A9CD2
        for <linux-cifs@vger.kernel.org>; Tue, 22 Aug 2023 16:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=+tCPkHp+YBUmbMrqpbllANfy8ELVykQMBIWn/DNGp9k=; b=InM8KhCVLdqSG3EVOYBvxRU1FH
        kZuRpYjyMl95tJi0k0BxRlcFJXJ8fMzR4BNbDU/9aAxvUrETtGee4Qv6d3W30ljwUdwm0HinqE7dg
        3C+nX1G186YYjjG8Dfxk2O0lvflr0SKZqfSvWqbD+SUJLQq5yjknfjANsdRYCzWbqiTd7V3j6frDi
        LQgZfwEWu8EOz83SWG84PNYxIp7vDo0lJmKnqaJFif1xcopTsn5PbHj5PkR7346hpIqS+tGxiDY4U
        qCXbCepNQ05Mfo7GwPivUPMcTfRUfD3b+7P1TL+lmhtCN/AA7M1HvP5+1kDFKVRz6qxgwPRUits4w
        boeo6wEZ882oHKWOdGZha2+n6fGdTgu9HajTrssN1epDk5OqCfhVzHTF2ZAw4eB63tvfTV8hBvdHg
        yYGbVWAy7t4Zqt3jVAkUlOKWBpkiXqGH+EtcJs3vm9LPhV7cHf2XV9SBldKGVoAJpA3QPm34hXpXN
        NYNmmAFpA7AjMZlVrCpez2+q;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qYas7-009UCm-1D;
        Tue, 22 Aug 2023 23:33:15 +0000
Date:   Tue, 22 Aug 2023 16:33:12 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Steven French <sfrench@samba.org>
Cc:     Xin Long <lucien.xin@gmail.com>, samba-technical@lists.samba.org,
        CIFS <linux-cifs@vger.kernel.org>, wedsonaf@gmail.com,
        jra@samba.org
Subject: Re: where to get the patches for samba over quic support
Message-ID: <ZOVFuPKFu67gbhwd@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CADvbK_eHYFJWL3xaZeciUMPjWXqkP_Kp3DrpP-3XPyopY1yZmg@mail.gmail.com>
 <1c535816-0a9c-6924-642f-508e82cd0237@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1c535816-0a9c-6924-642f-508e82cd0237@samba.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Aug 22, 2023 at 05:02:26PM -0500, Steven French wrote:
>I was very interested in this as well and there seems to be a logical 
>use case for SMB3.1.1 mounts from the kernel client (cifs.ko) since 
>multiple servers already support QUIC for SMB3.1.1 mounts (e.g. 
>Windows and apparently also an embedded server that demoed at Storage 
>Developer Conference last year).  Key question remains how much of the 
>code can stay in userspace (so only the key socket read/write code 
>must be in kernel, not necessarily the connection setup).   There are 
>also some interesting points that the Microsoft QUIC (open source 
>project in github) project guys mentioned including that for testing 
>you can often do "unencrypted QUIC" as a first step (which also has 
>performance benefits over TCP)
>
>We can discuss more details if you want, but Wedson had some great 
>ideas about doing some of this in Rust (and looks there are already 3 
>work in progress user space opensource QUIC implementations in Rust - 
>so some of the code could be reused)
>
>
>On 8/21/23 09:55, Xin Long wrote:
>>Hi, Samba Team,
>>
>>I'm currently working on QUIC implementation in Linux Kernel, and thinking
>>of applying it to fs/smb for SMB over QUIC in kernel. For interoperability
>>testing, I'm looking for an existing userspace implementation for SMB over
>>QUIC in Linux.
>>
>>I heard there are already some internal patches in samba for SMB over QUIC
>>support, anyone knows where I can get it for this testing?

I just did some research, and this engine (in C) appears to be easiest
to use for Samba.

https://github.com/litespeedtech/lsquic/blob/master/docs/tutorial.rst

The tutorial shows an example being used with libevent, we could
adapt this to libtevent.
