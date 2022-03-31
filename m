Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1039AC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Mar 2022 23:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242657AbiCaXyt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 31 Mar 2022 19:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiCaXyt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 31 Mar 2022 19:54:49 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD0E24A8BD
        for <linux-cifs@vger.kernel.org>; Thu, 31 Mar 2022 16:52:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4EBDB1F7AC;
        Thu, 31 Mar 2022 23:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648770778; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=9tTS7Z4WAu0Fen7w1wgaZ5bVLFlVnx0mYtU9iLCktQ4=;
        b=KobdTOFV+Hr8re6I35R4r2EoMQ4c1YBbYj3/gO9QSxDLZf/Bf05bO0fwzzBHSnMiBs0hrX
        CLk0WmE/yjxI9XX+TvBysfdjB39Ya7ORWy8qznOB5bW3fFzplhZ0fHHbIqU8URK4wcy/go
        EjqPdzz04WXNJJWDnEf9+7Ni/Ah8fjE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648770778;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=9tTS7Z4WAu0Fen7w1wgaZ5bVLFlVnx0mYtU9iLCktQ4=;
        b=35jTFHR1prXBCx8neIQgD6/R5X1Sh5bbtFuaHnXJpzBRUkH71sxQQui67DK4CuHSthMrOT
        hmM3eoPR1aECvMAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C3F24132DC;
        Thu, 31 Mar 2022 23:52:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +X1pIdk+RmL4KgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 31 Mar 2022 23:52:57 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     pshilovsky@samba.org, smfrench@gmail.com, pc@cjr.nz,
        Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH] mount.cifs.rst: add FIPS information
Date:   Thu, 31 Mar 2022 20:52:51 -0300
Message-Id: <20220331235251.4753-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add FIPS 140-2 compliance information regarding mounting SMB shares.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 mount.cifs.rst | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/mount.cifs.rst b/mount.cifs.rst
index 9d4446f035b6..4ca46976fee6 100644
--- a/mount.cifs.rst
+++ b/mount.cifs.rst
@@ -376,6 +376,10 @@ sec=arg
   may be enabled automatically. Packet signing may also be enabled
   automatically if it's enabled in */proc/fs/cifs/SecurityFlags*.
 
+  For environments that requires FIPS 140-2 compliance, only ``sec=krb5`` and
+  ``sec=krb5i`` are valid. See also ``vers``. See section `SECURITY`_
+  for more information.
+
 seal
   Request encryption at the SMB layer. The encryption algorithm used
   is AES-128-CCM. Requires SMB3 or above (see ``vers``).
@@ -624,6 +628,9 @@ vers=arg
   kernels prior to v4.13, the default was ``1.0``. For kernels
   between v4.13 and v4.13.5 the default is ``3.0``.
 
+  For environments that requires FIPS 140-2 compliance, only version ``2.0`` or
+  or newer is allowed. See section `SECURITY`_ for more information.
+
 --verbose
   Print additional debugging information for the mount. Note that this
   parameter must be specified before the ``-o`` . For example::
@@ -923,6 +930,29 @@ by default at mount time. Old dialects such as CIFS (SMB1, ie vers=1.0)
 have much weaker security. Use of CIFS (SMB1) can be disabled by
 modprobe cifs disable_legacy_dialects=y.
 
+For environments that requires FIPS 140-2 compliance, the following applies:
+
+- SMB1 (``vers=1.0``) is not allowed
+- SMB2 and newer are only allowed with ``sec=krb5`` or ``sec=krb5i`` security
+  modes
+
+This is because FIPS 140-2 does not approve MD4/MD5 hashing algorithms, which
+are used either by SMB1 or the other security modes.
+
+When running a kernel in FIPS mode (i.e. with ``fips=1`` in boot command line),
+the above will be enforced, and running ``mount.cifs`` might fail.
+In the failing cases, the following error message (or similar, depending on the
+security mode) will appear in the ring buffer:
+
+  "CIFS VFS: could not allocate crypto hmacmd5"
+
+When not running a kernel in FIPS mode, the above serves only as informational
+purpose as ``mount.cifs`` does not enforce any of that.
+
+References:
+FIPS 140-2 Implementation Guide, G.6
+`https://csrc.nist.gov/csrc/media/projects/cryptographic-module-validation-program/documents/fips140-2/fips1402ig.pdf<https://csrc.nist.gov/csrc/media/projects/cryptographic-module-validation-program/documents/fips140-2/fips1402ig.pdf>`_
+
 ****
 BUGS
 ****
-- 
2.34.1

