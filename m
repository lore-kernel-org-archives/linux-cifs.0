Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78373C433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Mar 2022 03:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbiCSDVy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Mar 2022 23:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiCSDVx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 18 Mar 2022 23:21:53 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778D5DD963
        for <linux-cifs@vger.kernel.org>; Fri, 18 Mar 2022 20:20:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8E7BB210FD;
        Sat, 19 Mar 2022 03:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647660031; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=P5HVMst4XokfGKAJRjIs1cTmZO3fVYAodwoctjMKPfQ=;
        b=bNb23TSIRlsbZCu3Vh6STEuRsnhmLndGfnHCpuP7x1hgM4Rwjdjtbd+3gDAMb59SIWCugB
        oIYT2q273lfVDs9c2TasubyZAkysMlLlZ0dyhAmtmN/6cpiWcfHSnrS1rOWQcWbQqujPSQ
        iadHIN/vHcu09onAVdNMcOCqWaP5td0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647660031;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=P5HVMst4XokfGKAJRjIs1cTmZO3fVYAodwoctjMKPfQ=;
        b=iaG9qMJdhJl4jLpvtNUAx9Yoxin0t+B+m4yPJOlLT9s+T0ttctN4J4fbwWyikqRllHZYXJ
        DJSbEyCVwzCoBlDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0B2D1132C1;
        Sat, 19 Mar 2022 03:20:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id f1JdL/5LNWKQRgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Sat, 19 Mar 2022 03:20:30 +0000
Date:   Sat, 19 Mar 2022 00:20:25 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     samba-technical@lists.samba.org, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com
Subject: Signature check for LOGOFF response
Message-ID: <20220319032012.46ezg2pxjlrsdlpq@cyberdelia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

The LOGOFF command response is not signed (=> signature is 0x0), but we
check it anyway, displaying "sign fail" errors in ring buffer.

As far as I checked, an explicit LOGOUT is only sent when tlink pruning
happens (i.e. TLINK_IDLE_EXPIRE expires), but we have a case of this
causing issues on production env.

I didn't find LOGOFF being a signature check exception in MS-SMB2 rev64.
Relevant sections:

2.2.7 SMB2 LOGOFF Request
2.2.8 SMB2 LOGOFF Response
3.2.5.4 Receiving an SMB2 LOGOFF Response
3.3.5.6 Receiving an SMB2 LOGOFF Request

If this is implementation defined, maybe something like this could work?
(100% untested)

--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -667,6 +667,7 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
         if ((shdr->Command == SMB2_NEGOTIATE) ||
             (shdr->Command == SMB2_SESSION_SETUP) ||
             (shdr->Command == SMB2_OPLOCK_BREAK) ||
+           (shdr->Command == SMB2_LOGOFF) ||
             server->ignore_signature ||
             (!server->session_estab))
                 return 0;

Thoughts?


Enzo
