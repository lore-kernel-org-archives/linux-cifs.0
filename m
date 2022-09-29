Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7057C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 20:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiI2Ug7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 16:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiI2Ug7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 16:36:59 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFE01323E5
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 13:36:58 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D94F71F38D;
        Thu, 29 Sep 2022 20:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664483816; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=exVd8QvphenmmlVLFJTPlV4Si2wg2eu56DbJt4whMFE=;
        b=br5e5bwpyp2NT6smHlacweJ89cLqNRpet6TuYo5ZzCddvFd/sUj6TIEiBvNJfVpwWsG2Ij
        LPi5SH+QyGWTpWwHIEx+feiXEuY+8IFITIdaeqUUz4Oo0Zc1xDw/QqfLay3lE9jiC8qU6L
        mllgM38fok5gJyoM4ChWxUW6IJ/SB/8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664483816;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=exVd8QvphenmmlVLFJTPlV4Si2wg2eu56DbJt4whMFE=;
        b=+rsAB90PsS5fADDNduADqjWqZoWgmqKmKTZD+du3FX+asjh7ZpqDQ6aCet45HVwJgGDARM
        +XakkKeYju+5DbCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 502BB1348E;
        Thu, 29 Sep 2022 20:36:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0YJRBOgBNmPjTAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 29 Sep 2022 20:36:56 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com, metze@samba.org
Subject: [PATCH v4 0/8] cifs: introduce support for AES-GMAC signing
Date:   Thu, 29 Sep 2022 17:36:48 -0300
Message-Id: <20220929203652.13178-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

v4:
Patches 3/8 and 6/8:
  - fix checkpatch errors (thanks to Steve)

Patch 5/8:
  - rename smb311_calc_signature to smb311_calc_aes_gmac, and use SMB3_AES_GCM_NONCE
    instead of hardcoded '12' (suggested by metze)
  - update commit message to include the reasoning to move ->calc_signature op

Patch 8/8: 
  - move SMB2_PADDING_BUF to smb2glob.h
  - check if iov is SMB2_PADDING_BUF in the free functions where
    smb2_padding was previously used (pointed out by metze)

Enzo Matsumiya (8):
  smb3: rename encryption/decryption TFMs
  cifs: secmech: use shash_desc directly, remove sdesc
  cifs: allocate ephemeral secmechs only on demand
  cifs: create sign/verify secmechs, don't leave keys in memory
  cifs: introduce AES-GMAC signing support for SMB 3.1.1
  cifs: deprecate 'enable_negotiate_signing' module param
  cifs: show signing algorithm name in DebugData
  cifs: use MAX_CIFS_SMALL_BUFFER_SIZE-8 as padding buffer

 fs/cifs/cifs_debug.c    |   7 +-
 fs/cifs/cifsencrypt.c   | 157 ++++-------
 fs/cifs/cifsfs.c        |  14 +-
 fs/cifs/cifsglob.h      |  70 +++--
 fs/cifs/cifsproto.h     |   5 +-
 fs/cifs/link.c          |  13 +-
 fs/cifs/misc.c          |  49 ++--
 fs/cifs/sess.c          |  12 -
 fs/cifs/smb1ops.c       |   6 +
 fs/cifs/smb2glob.h      |  15 ++
 fs/cifs/smb2misc.c      |  29 +-
 fs/cifs/smb2ops.c       | 102 ++-----
 fs/cifs/smb2pdu.c       |  77 ++++--
 fs/cifs/smb2pdu.h       |   2 -
 fs/cifs/smb2proto.h     |  13 +-
 fs/cifs/smb2transport.c | 581 +++++++++++++++++++++-------------------
 16 files changed, 577 insertions(+), 575 deletions(-)

-- 
2.35.3

