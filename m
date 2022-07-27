Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35412C04A68
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jul 2022 19:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbiG0TYM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Jul 2022 15:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234913AbiG0TYL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Jul 2022 15:24:11 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E21D7
        for <linux-cifs@vger.kernel.org>; Wed, 27 Jul 2022 12:24:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B1F66203CF;
        Wed, 27 Jul 2022 19:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658949849; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5mlm3xx4QFbBTsErOqFzgXML5nFhMiLzkMNjVePo4Qo=;
        b=HmudG/OJqGXfru6GJfUiYTyEjPZ5g0BgLoCgjemXLcxGfuaCj5DiuVZzpuPdGHwVeoObzC
        vgfb5c8trF1f0LHRvH76NbqthxPe/ETP7nh/VSfO7A28enprA8QEvTPCabach+QNh9qhav
        38+/GbNnkggQJJbrde3Eu8iFp0hX7qM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658949849;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5mlm3xx4QFbBTsErOqFzgXML5nFhMiLzkMNjVePo4Qo=;
        b=SMSK26Tj3zOr5LbL+xdr8y0DAnbqDwwbjFHnhiVNpXFMQCn69ztZB7kcb8k0Iw1QHkwAna
        OOma3Vsz7/BJFZAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3377D13A8E;
        Wed, 27 Jul 2022 19:24:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Tn2bOdiQ4WLSRwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 27 Jul 2022 19:24:08 +0000
Date:   Wed, 27 Jul 2022 16:24:06 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Fwd: [RFC PATCH v2 03/10] cifs: rename "TCP_Server_Info" struct
 to "cifs_server_info"
Message-ID: <20220727192406.a3oqszjap5cpmmed@cyberdelia>
References: <20220725223707.14477-1-ematsumiya@suse.de>
 <20220725223707.14477-4-ematsumiya@suse.de>
 <CAH2r5msHgxzC6HYhj70cMce+=t6Fz2p1C5X3HCM1WKFEq7rnhQ@mail.gmail.com>
 <20220727153836.sllbblfagnstcza7@cyberdelia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220727153836.sllbblfagnstcza7@cyberdelia>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

[ resending this as the other one bounced ]

On 07/27, Steve French wrote:
>Of the first three patches, I think this one makes the most sense, but
>the rename should be "TCP_Server_Info" to something like
>"tcp_server_info" (or TCP_server_info) or something that indicates it
>is for the transport level info, info related to the network
>connection, the socket etc.

Noted.

>(and not using the word "cifs" unless
>related to SMB1)

The "cifs" prefix is for the bigger picture (SMB1 isolation and/or
module renaming) so I can later on do something like:
"sed -i 's/cifs_/<newname>_/g' *.c"

>---------- Forwarded message ---------
>From: Enzo Matsumiya <ematsumiya@suse.de>
>Date: Mon, Jul 25, 2022 at 5:37 PM
>Subject: [RFC PATCH v2 03/10] cifs: rename "TCP_Server_Info" struct to
>"cifs_server_info"
>To: <linux-cifs@vger.kernel.org>
>Cc: <smfrench@gmail.com>, <pc@cjr.nz>, <ronniesahlberg@gmail.com>,
><nspmangalore@gmail.com>
>
>
>Rename the TCP_Server_Info struct to "cifs_server_info",
>making it look more like a cifs.ko struct by using the standard "cifs_"
>prefix.
>
>Also upgrades from Camel_Case to snake_case.
>
>Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>---
>fs/cifs/asn1.c          |   4 +-
>fs/cifs/cifs_debug.c    |  14 ++--
>fs/cifs/cifs_debug.h    |   4 +-
>fs/cifs/cifs_spnego.c   |   2 +-
>fs/cifs/cifs_spnego.h   |   2 +-
>fs/cifs/cifs_swn.h      |   8 +--
>fs/cifs/cifsencrypt.c   |  14 ++--
>fs/cifs/cifsfs.c        |   6 +-
>fs/cifs/cifsglob.h      | 140 ++++++++++++++++++++--------------------
>fs/cifs/cifsproto.h     | 114 ++++++++++++++++----------------
>fs/cifs/cifssmb.c       |  24 +++----
>fs/cifs/connect.c       | 134 +++++++++++++++++++-------------------
>fs/cifs/dfs_cache.c     |  10 +--
>fs/cifs/dir.c           |   6 +-
>fs/cifs/file.c          |  60 ++++++++---------
>fs/cifs/fscache.c       |   2 +-
>fs/cifs/inode.c         |  22 +++----
>fs/cifs/ioctl.c         |   2 +-
>fs/cifs/link.c          |   4 +-
>fs/cifs/misc.c          |  10 +--
>fs/cifs/netmisc.c       |   2 +-
>fs/cifs/ntlmssp.h       |   6 +-
>fs/cifs/readdir.c       |   4 +-
>fs/cifs/sess.c          |  52 +++++++--------
>fs/cifs/smb1ops.c       |  26 ++++----
>fs/cifs/smb2inode.c     |   2 +-
>fs/cifs/smb2misc.c      |  14 ++--
>fs/cifs/smb2ops.c       |  86 ++++++++++++------------
>fs/cifs/smb2pdu.c       | 122 +++++++++++++++++-----------------
>fs/cifs/smb2proto.h     |  58 ++++++++---------
>fs/cifs/smb2transport.c |  44 ++++++-------
>fs/cifs/smbdirect.c     |  10 +--
>fs/cifs/smbdirect.h     |  16 ++---
>fs/cifs/transport.c     |  48 +++++++-------
>34 files changed, 536 insertions(+), 536 deletions(-)
