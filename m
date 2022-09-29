Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FBEFC32771
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 01:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbiI2B5B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 21:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbiI2B5A (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 21:57:00 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA9B74B8A
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 18:56:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 670D721CAB;
        Thu, 29 Sep 2022 01:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664416618; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=HB9d3qG0ezv4bBJTZnke+hvZx+U80tR64mbEkesg+mU=;
        b=rEV3OQxnIzrlCgBDdhaqAfrPRBmuGnlL2UkZVoir3h+nHfoVfM6BJuw2nBe3XivFR/xkoj
        BJ38an7kmwoOyP3YYAnljIZqCafHJZ2o+xNKPhijNXNM+9jRjbiUHDeoweRqCQddOyr5go
        20DE3uj0n/CGgmunP1dHYyqMEPueqzA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664416618;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=HB9d3qG0ezv4bBJTZnke+hvZx+U80tR64mbEkesg+mU=;
        b=RFO2tfKMLtBlUVb2BjXUw0gkMHzVbWYt4trL+EusSPlhXev7qfer47CFJFEIa7iQSz2bsa
        6Uds+wxV9iOVyLAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DE478139B3;
        Thu, 29 Sep 2022 01:56:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id JHciKGn7NGNteQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 29 Sep 2022 01:56:57 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com, metze@samba.org
Subject: [PATCH v3 0/8] cifs: introduce support for AES-GMAC signing
Date:   Wed, 28 Sep 2022 22:56:29 -0300
Message-Id: <20220929015637.14400-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi all,

This is v3 of this series.  Please refer to the original cover letter here:
https://lore.kernel.org/linux-cifs/20220829213354.2714-1-ematsumiya@suse.de/

Major changes from v2:
- added patches 1-4 as some groundwork (see more below)
- the core function is now smb311_calc_signature(), and it's been simplified a
  lot, and removed the "merge" with crypt_message() (thanks metze for the help!)
- fix a very specific bug when AES-GMAC was used with KASAN enabled (patch 8/8)

Summary of each patch below.  Please refer to each individual commit message
for more details:

- Patch 1/8: smb3: rename encryption/decryption TFMs
Rename the encryption/decryption TFMs to more meaningful names.

- Patch 2/8: cifs: secmech: use shash_desc directly, remove sdesc
This patch removes the sdesc struct and uses the crypto API shash_desc directly
instead.  It's what the API use anyway, so no need for a wrapper.

- Patch 3/8: cifs: allocate ephemeral secmechs only on demand
Remove the ephemeral, single-use TFMs from cifs_secmech, and allocate/free them
only when they're used (on session setup), making the only long lived TFMs the
signing and encrypting ones.

- Patch 4/8: cifs: create sign/verify secmechs, don't leave keys in memory
This patch goes further and completely remove the algorithm-specific TFMs from
cifs_secmech, and introduce `sign' and `verify' TFMs.  This removes the need to
allocate a new TFM on every signature verification.  Another added benefit is
that's no longer necessary to keep the generated private keys in memory, as
they're set right after negprot and the TFMs will use the expanded version of
the keys internally.

- Patch 5/8: cifs: introduce AES-GMAC signing support for SMB 3.1.1
Several changes needed to be made in this patch, see the commit message/changes
for more details.

- Patch 6/8: cifs: deprecate 'enable_negotiate_signing' module param
- Patch 7/8: cifs: show signing algorithm name in DebugData
The above patches are pretty much the same as v2.

- Patch 8/8: cifs: use MAX_CIFS_SMALL_BUFFER_SIZE-8 as padding buffer
I hit a use-after-free on the crypto API when using AES-GMAC, with KASAN
enabled, and on a very specific test that used the smb2_padding array.  In
summary, KASAN was not happy with the stack-allocated array so this is the fix
the I ended up with (of all the several forms of fix that I implemented).

I welcome and expect all kinds of feedback and reviews.


Cheers,

Enzo

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
 fs/cifs/cifsglob.h      |  68 +++--
 fs/cifs/cifsproto.h     |   5 +-
 fs/cifs/link.c          |  13 +-
 fs/cifs/misc.c          |  49 ++--
 fs/cifs/sess.c          |  12 -
 fs/cifs/smb1ops.c       |   6 +
 fs/cifs/smb2glob.h      |  10 +
 fs/cifs/smb2misc.c      |  29 +-
 fs/cifs/smb2ops.c       | 103 ++-----
 fs/cifs/smb2pdu.c       |  78 ++++--
 fs/cifs/smb2pdu.h       |   2 -
 fs/cifs/smb2proto.h     |  15 +-
 fs/cifs/smb2transport.c | 581 +++++++++++++++++++++-------------------
 16 files changed, 572 insertions(+), 577 deletions(-)

-- 
2.35.3

