Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F27ECAAD1
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 13:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbiHaNqQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Aug 2022 09:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbiHaNqN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 31 Aug 2022 09:46:13 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E15C2BB2D
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 06:45:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E9B0F220FC;
        Wed, 31 Aug 2022 13:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661953508; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=bPKixSIr2rEG389G+f3MPIEDDpR1lqy9lY73XzOXz9U=;
        b=1joK23/F3ZT2puw/luGOcuG9CaDQ70HRC4PEC5zXL8F934OPRgvKSuBd4EneDK6RbzUIiS
        BnMDFOH0eW//LpKglUmfooI9uznSMTVRzJ6gCAVYbUy0ablJQcHdL53c/06HrFR4rehYzX
        CrE2iZtqmp5DYuQfs3BiPmjzCRDSQlY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661953508;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=bPKixSIr2rEG389G+f3MPIEDDpR1lqy9lY73XzOXz9U=;
        b=Zw9n3mj61fQX25frS8JgaICX3jQjXHYYRfMUrcXvDc4cjl919wRmqEQpD2pEOmCNDB4JWq
        KtyXuMfg9v7YQTBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 684CB1332D;
        Wed, 31 Aug 2022 13:45:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VZ2oCuRlD2PyPgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 31 Aug 2022 13:45:08 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, dan.carpenter@oracle.com
Subject: [PATCH v2 0/3] cifs: introduce support for AES-GMAC signing
Date:   Wed, 31 Aug 2022 10:44:41 -0300
Message-Id: <20220831134444.26252-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

This patch series introduce the support for AES-GMAC signing for SMB 3.1.1,
when the negotiate signing context is successfully negotiated.

This is an implementation of the MS-SMB2 spec, section 3.1.4.1 "Signing An
Outgoing Message".

AES-GMAC uses AES-128-GCM (kernel crypto algorithm "gcm(aes)" from the gcm
module) as its base.

AES-GCM, an authenticated encryption algorithm, takes 4 inputs for encryption:
1. a secret key
2. an initialization vector (IV), or nonce
3. the plaintext data (the message to be encrypted)
4. an extra buffer called Additional Authenticated data (AAD), or sometimes
   Associated Data (AD)

Superficially describing it, it encrypts the plaintext using the key and then
uses the nonce to generate an authentication tag (our signature, in this
context).  It then produces 2 outputs; the encrypted data, along with its
computed authentication tag.  The AAD buffer is left intact.

Because of this design, AES-GCM can be used to "encrypt" an empty plaintext
buffer, and still run its authentication generation algorithm over the AAD
buffer (which is set to our SMB2 message), making it practically a MAC
algorithm.

Compared to AES-CMAC, AES-GMAC has shown (*) to be much faster because its
internal authentication algorithm can be paralellized by taking advantage of
especialized, optimized CPU instructions (on certain supported platforms).

With these patches, I hope cifs.ko can get a performance improvemente when
AES-GMAC is used for message signing.

Patch 1/3: add the core functions to perform AES-GMAC signing (see commit
	   message for more details)
Patch 2/3: set the "enable_negotiate_signing" module param as deprecated,
	   making cifs.ko always try to negotiate AES-GMAC first, but use
	   AES-CMAC if fail
Patch 3/3: show the signing algorithm name being used in DebugData

To do/discuss:
- serious benchmark and comparison (vs AES-CMAC) on cifs.ko workloads (*)
- complete removal of "enable_negotiate_signing" module param
- RDMA/SMB Direct; I have no experience with it, nor an RDMA-capable setup
- bugs?

Any kind of feedback is welcome.


Cheers,

Enzo Matsumiya (3):
  cifs: introduce AES-GMAC signing support for SMB 3.1.1
  cifs: deprecate 'enable_negotiate_signing' module param
  cifs: show signing algorithm name in DebugData

v2: update patch 1/3 to fix some warnings from kernel test robot (see patch for details)

 fs/cifs/cifs_debug.c    |   7 +-
 fs/cifs/cifsencrypt.c   |   5 +
 fs/cifs/cifsfs.c        |   8 +-
 fs/cifs/cifsglob.h      |  12 +-
 fs/cifs/sess.c          |   2 +
 fs/cifs/smb2glob.h      |  10 +
 fs/cifs/smb2misc.c      |   4 +
 fs/cifs/smb2ops.c       | 482 +++++++++++++++++++++++++++++++++-------
 fs/cifs/smb2pdu.c       |  97 ++++++--
 fs/cifs/smb2proto.h     |   9 +-
 fs/cifs/smb2transport.c |  87 ++++++--
 11 files changed, 590 insertions(+), 133 deletions(-)

-- 
2.35.3

