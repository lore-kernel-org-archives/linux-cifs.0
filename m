Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 083B1C4338F
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Aug 2021 03:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C41C16109E
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Aug 2021 03:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236420AbhHMDYM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Aug 2021 23:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234337AbhHMDYM (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 12 Aug 2021 23:24:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B7E760FBF;
        Fri, 13 Aug 2021 03:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628825025;
        bh=AwT0XFgBaJlBrijTTYjpKGhqHHFKKuByMomK7FOOMo4=;
        h=Date:From:To:Cc:Subject:From;
        b=BzPhJ7JrzY9EjJkAl2szj9CnaReu9rn9+wXPHRJFL63bVlx9IFPcrWT8ZzL4ZgtUv
         yayNE4wbzaAoEMQZduYp7VAJJV5A8Q2u74qHtRhto3/UgqQucd6/RNIADjZSmU6vsN
         +ArrYYUqHOoSh9c4VsFNgCNbwyCH8+jOmuQoOYH1YXjKUytv1zPtxcjUyEhyhwgq1F
         rt/mhV6fiRDv3BTPHsTFoOJHcFpvGAH3B7caA0JGWI2yY6u03PWBh34D4rGtiiSeOz
         MeWprl6sLTbwfDoijxEjhQSAcnGHQcSZd1vd90Y3LJvmaRtmFlkxjLte0Aj0LwXps8
         im6ql+iUyVtGw==
Date:   Thu, 12 Aug 2021 20:23:44 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>
Cc:     samba-technical@lists.samba.org, linux-crypto@vger.kernel.org
Subject: Building cifs.ko without any support for insecure crypto?
Message-ID: <YRXlwDBfQql36wJx@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi!

We should be working to eliminate any uses of insecure crypto algorithms (e.g.
DES, ARC4, MD4, MD5) from the kernel.  In particular, it should be possible to
build a kernel for a modern system without including any such algorithms.

Currently, CONFIG_CIFS is problematic because it selects all these algorithms
(kconfig options: CONFIG_CRYPTO_LIB_DES, CONFIG_CRYPTO_LIB_ARC4,
CONFIG_CRYPTO_MD4, CONFIG_CRYPTO_MD5).

It looks like these algorithms might only be used by SMB2.0 and earlier, and the
more modern SMB versions don't use them.  Is that the case?  It mostly looks
like that, but there's one case I'm not sure about -- there's a call chain which
appears to use ARC4 and HMAC-MD5 even with the most recent SMB version:

    smb311_operations.sess_setup()
      SMB2_sess_setup()
        SMB2_sess_auth_rawntlmssp_authenticate()
          build_ntlmssp_auth_blob()
            setup_ntlmv2_rsp()

Also, there's already an option CONFIG_CIFS_ALLOW_INSECURE_LEGACY=n which
disables support for SMB2.0 and earlier.  However, it doesn't actually compile
out the code but rather just prevents it from being used.  That means that the
DES and ARC4 library interfaces are still depended on at link time, so they
can't be omitted.  Have there been any considerations towards making
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=n compile out the code for SMB2.0 and earlier?

- Eric
