Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E280C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Nov 2021 18:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245519AbhK3Suj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Nov 2021 13:50:39 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:44854 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245666AbhK3Sug (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Nov 2021 13:50:36 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6FE9B1FD5A;
        Tue, 30 Nov 2021 18:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638298036; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=6le2Lp8mwkypvf+f792seCB4yi8vatEHChF5kDKT37g=;
        b=V0AyubJo1cJ2zoU6DJUTSP1dNN8R6EEaVmvrFcfq1xW4qwii6VtrKlkIoKDIeI8nSrtL6H
        YGOK+JsQkoRgPgZgNHRz/KrrhDsXcE5JypJQSTEIiCN9LStNhVfRvjbqmcnHXbliiRaeIR
        mDxC7HNSvWqu2AqdsL1lTCU/m8KYM64=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638298036;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=6le2Lp8mwkypvf+f792seCB4yi8vatEHChF5kDKT37g=;
        b=QcUyIFNbGX/304arrQyl4L35taVMgd8hfwJ2MNMmHYWKnENMRaXRlhRFBRYxyzvdybnR+j
        A8KcRku5SKBGNVAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1CD4013D5F;
        Tue, 30 Nov 2021 18:47:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id FOqBM7JxpmHmNQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 30 Nov 2021 18:47:14 +0000
Date:   Tue, 30 Nov 2021 15:47:10 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linkinjeon@kernel.org, linux-cifs@vger.kernel.org
Subject: [RFC] Unify all programs into a single 'ksmbdctl' binary
Message-ID: <20211130184710.r7dzzfhak4w3eoi6@cyberdelia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Namjae, list,

I've been working on the unification of all ksmbd-tools programs into a
single 'ksmbdctl' binary, and I would like to invite everyone to test
and/or provide me feedback on the implementation.

Since this a big-ish refactor, for now I'm sharing the code via my
GitHub repo:

https://github.com/ematsumiya/ksmbd-tools/tree/ksmbdctl

I can split it into smaller commits later on, if approved for merge.

Commit message below, for a better explanation.

Cheers,

Enzo

==================================
commit 1135e0f6b592fb48d6b20b919c44ddb961d0c51d
Author: Enzo Matsumiya <ematsumiya@suse.de>
Date:   Tue Nov 30 15:22:35 2021 -0300

     Unify all programs into a single 'ksmbdctl' binary

     This commit unifies all existing programs
     (ksmbd.{adduser,addshare,control,mountd}) into a single ksmbdctl binary.

     The intention is to make it more like other modern tools (e.g. git,
     nvme, virsh, etc) which have more clear user interface, readable
     commands, and also makes it easier to script.

     Example commands:
       # ksmbdctl share add myshare -o "guest ok=yes, writable=yes, path=/mnt/data"
       # ksmbdctl user add myuser
       # ksmbdctl user add -i $HOME/mysmb.conf anotheruser
       # ksmbdctl daemon start
     
     Besides adding a new "share list" command, any previously working
     functionality shouldn't be affected.

     Basic testing was done manually. Updated README to reflect these
     modifications.

     TODO:
     - run more complex tests in more complext environments
     - implement tests (for each command and subcommand)
     - create an abstract command interface, to make it easier to add/modify
       the commands
     - find and fix obvious bugs I missed

     Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>

