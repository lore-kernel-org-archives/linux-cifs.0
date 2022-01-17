Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C852C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Jan 2022 21:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiAQVOK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Jan 2022 16:14:10 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:48366 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiAQVOJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Jan 2022 16:14:09 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 59A9F1F39B;
        Mon, 17 Jan 2022 21:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1642454048; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EeqxpD1RxWxWo1eKvUtdi3vom9jFUH9xC1bDnMxTmAg=;
        b=eqHNfAFFFkieJItG85Ht0dpmjB1JzDEI/3Nx1Beoby93G3/qEgCCnjwZT+4A3uqqx46fjl
        jlFlrAND+nECbkw3+bE+rUKpkAHscMsWXZV7c6wzNtd0aXqRHwACzCeSvaoEFKpmyTE9zQ
        Gq2Qhh9Ifn8hmEd/uwN3GNPkmUEkKOY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1642454048;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EeqxpD1RxWxWo1eKvUtdi3vom9jFUH9xC1bDnMxTmAg=;
        b=Q60z17RuODFcOSRWgjfjD3AR7PDvDV44az+sL5WsRq2P8JEygmO5OKKQIY5a5IduYEcl2K
        U+2CvnSGJTZtVrAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DA08213E95;
        Mon, 17 Jan 2022 21:14:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id O0gmKR/c5WHbZAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 17 Jan 2022 21:14:07 +0000
Date:   Mon, 17 Jan 2022 18:14:05 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Eugene Korenevsky <ekorenevsky@astralinux.ru>
Cc:     linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>
Subject: Re: [PATCH v2 2/2] cifs: quirk for STATUS_OBJECT_NAME_INVALID
 returned for non-ASCII dfs refs
Message-ID: <20220117211305.ambdxok747u6kwlm@cyberdelia>
References: <YeHUxJ9zTVNrKveF@himera.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <YeHUxJ9zTVNrKveF@himera.home>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 01/14, Eugene Korenevsky wrote:
>Windows SMB server responds with STATUS_OBJECT_NAME_INVALID code to
>SMB2 QUERY_INFO request for "\<server>\<dfsname>\<linkpath>" DFS reference,
>where <dfsname> contains non-ASCII unicode symbols.
>
>Check such DFS reference and emulate -EREMOTE if it is actual.
>
>BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=3D215440
>Signed-off-by: Eugene Korenevsky <ekorenevsky@astralinux.ru>

The patch fixes the initial issue (mount and listing files) as per
reported in the mentioned bugzilla, but it still fails to create files:

% echo "test" | sudo tee myfile
tee: myfile: No such file or directory
test

% dmesg
=2E..
[20510.826644] CIFS: fs/cifs/dfs_cache.c: cache_refresh_path: search path: =
\w19-addc.mori.test\=D0=B4=D1=84=D1=81\test
[20510.826653] CIFS: fs/cifs/dfs_cache.c: get_dfs_referral: get an DFS refe=
rral for \w19-addc.mori.test\=D0=B4=D1=84=D1=81\test                       =
                                                                      [45/5=
04]
[20510.826658] CIFS: fs/cifs/smb2ops.c: smb2_get_dfs_refer: path: \w19-addc=
=2Emori.test\=D0=B4=D1=84=D1=81\test
[20510.826665] CIFS: fs/cifs/smb2pdu.c: SMB2 IOCTL
[20510.826670] CIFS: fs/cifs/transport.c: wait_for_free_credits: remove 1 c=
redits total=3D577
[20510.826690] CIFS: fs/cifs/transport.c: Sending smb: smb_len=3D184
[20510.828315] CIFS: fs/cifs/connect.c: RFC1002 header 0x12a
[20510.828331] CIFS: fs/cifs/smb2misc.c: SMB2 data length 186 offset 112
[20510.828336] CIFS: fs/cifs/smb2misc.c: SMB2 len 298
[20510.828342] CIFS: fs/cifs/smb2ops.c: smb2_add_credits: added 10 credits =
total=3D587
[20510.828364] CIFS: fs/cifs/transport.c: cifs_sync_mid_result: cmd=3D11 mi=
d=3D41 state=3D4
[20510.828397] CIFS: fs/cifs/misc.c: Null buffer passed to cifs_small_buf_r=
elease
[20510.828406] CIFS: fs/cifs/misc.c: num_referrals: 1 dfs flags: 0x3 ...
[20510.828432] CIFS: fs/cifs/misc.c: DFS ref '\w19-addc.mori.test\=D0=B4=D1=
=84=D1=81\test' is not found, emulate -ENOENT
=2E..


Cheers,

Enzo
