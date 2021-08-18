Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ACCFC4338F
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 14:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00E44610CF
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 14:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239606AbhHROrO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Aug 2021 10:47:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238799AbhHROrK (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 18 Aug 2021 10:47:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 904FB610CB;
        Wed, 18 Aug 2021 14:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629297995;
        bh=5aoQRtG2q72qoZysMHWqLQqHnUVvIzSZLuN+xGxl7CY=;
        h=From:To:Cc:Subject:Date:From;
        b=aSkQE0sjxMYm4ZODFeZIbIWbqNi7lylBeO03gIFAWgmOiiBq8p/A+d0UrTJm+omnU
         107UephuHebEu3cFpVxLIazaPXU2C1l8qbKjEKZUPtJ90ipXlt3nuul4S80Rgr2Wqf
         r9q/hpUhiJgxZ6MtSaS7TR+N8eIewgS8zFXc96rzcuGvfHDifmw1Jz/yYK8t9zWXpU
         IyN+qRlVAXQB96z84vYxX5R/SwGt+TN3xTzpesr7c+TFiDW0r+evtzhc2TLn7Gux/x
         7LpVko1g0GyKllR+oHoZmy6sixH8mDswa1RvOrYg9Cb+ZlkT7lcWpy7AoI8Mg6nbXX
         2FDFXxjdg39hw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
Subject: [PATCH 0/2] crypto: remove MD4 generic shash
Date:   Wed, 18 Aug 2021 16:46:15 +0200
Message-Id: <20210818144617.110061-1-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

As discussed on the list [0], MD4 is still being relied upon by the CIFS
driver, even though successful attacks on MD4 are as old as Linux
itself.

So let's move the code into the CIFS driver, and remove it from the
crypto API so that it is no longer exposed to other subsystems or to
user space via AF_ALG.

Note: this leaves the code in crypto/asymmetric_keys that is able to
parse RSA+MD4 keys if an "md4" shash is available. Given that its
Kconfig symbol does not select CRYPTO_MD4, it only has a runtime
dependency on md4 and so we can either decide remove it later, or just
let it fail on the missing MD4 shash as it would today if the module is
not enabled.

[0] https://lore.kernel.org/linux-cifs/YRXlwDBfQql36wJx@sol.localdomain/

Cc: Eric Biggers <ebiggers@kernel.org>
Cc: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs <linux-cifs@vger.kernel.org>
Cc: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org

Ard Biesheuvel (2):
  fs/cifs: Incorporate obsolete MD4 crypto code
  crypto: md4 - Remove obsolete algorithm

 crypto/Kconfig       |   6 -
 crypto/Makefile      |   1 -
 crypto/md4.c         | 241 --------------------
 crypto/tcrypt.c      |  14 +-
 crypto/testmgr.c     |   6 -
 crypto/testmgr.h     |  42 ----
 fs/cifs/Kconfig      |   1 -
 fs/cifs/cifsfs.c     |   1 -
 fs/cifs/smbencrypt.c | 200 ++++++++++++++--
 9 files changed, 178 insertions(+), 334 deletions(-)
 delete mode 100644 crypto/md4.c

-- 
2.20.1

