Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA73C4338F
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20F1861037
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhHWPPb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Aug 2021 11:15:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhHWPPa (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 23 Aug 2021 11:15:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1973D61361;
        Mon, 23 Aug 2021 15:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629731688;
        bh=QoQePeyda/DBBwpM7QysbQ9w9IP2Pen9ymMP8UdyQtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UBY9VPIKFlKIRTAYRP9YEKV50qATa2XyS0z1nJfkCGoBjxsgknbPEZ+rT4UfzkU8I
         BM+1VE/Ppgim2274PoAfVac/t9cN0xBYOwnEvRMU3wHe9UKPBDgLv8dj9tNDuaQ1t/
         rPH0bC6DfMDHVfIIFDUXh0erPaA5+RWlCYBy/8mrtPu60Hwtav05aP7inmP/DH3jKU
         Jj5XLhEQi93ODbnSC1P0DKUjzsypx7pNf/qPwfqYNH8GW699+gvTWlyQekV0j9WoFi
         7WZyEmWvkM9VFRG6CY6yB4J6CiKIRZTPQXyy/eJ8/U+6Q5/QgOiGde17bYT8Wn3d4q
         3yz6IBESckNpw==
From:   Christian Brauner <brauner@kernel.org>
To:     Steve French <stfrench@microsoft.com>,
        Christoph Hellwig <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifs@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 00/11] ksmbd: various fixes
Date:   Mon, 23 Aug 2021 17:13:46 +0200
Message-Id: <20210823151357.471691-1-brauner@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823025816.7496-1-namjae.jeon@samsung.com>
References: <20210823025816.7496-1-namjae.jeon@samsung.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2173; h=from:subject; bh=C/qBrzFXL17NsuZft2wK7r41LZ5FUE7ZcIuS+XQPB0g=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQq7zaonKh9fxJj5du5p1Mcju9Z6fGou+pUxtN9323F1aMY L8cJdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEykdhnD/9jGxnsXN81PmslxeN2NaP 2ErxvulXOECSodM6tMnXtcIYCRYcPT7ye6xFi3/HT++axiiXNb4bQbPHf4o2xsV/LI3c/fxggA
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Hey everyone,

I took the time to look at ksmbd last week and today. I performed
various tests, read a bunch of code and discovered a few bugs that I
addressed in this series. Most of them simply deal with the translation
of ownership between samba ids and unix ids.

The server client model makes it a bit harder to reason about things but
in essence ksmbd behaves like a very simple shim sitting on top of the
underlying filesystem and thus bares some _vague_ resemblance to
overlayfs and other overlay-style filesystems. The crucial thing is that
ksmbd calls into the lower filesystem to create and manage filesystem
objects. This is inherently a tricky thing to get right as it
essentially involves two-level thinking all of the time. The easiest
conceptual model I came up with for me is that ksmbd is similar to a
userspace process that calls into the filesystem. With this model in
mind it becomes a lot clearer how ownership needs to be managed. I tried
to reflect that thinking in the commit message explaining why what
happens.

Thanks!
Christian

Christian Brauner (11):
  ksmbd: fix lookup on idmapped mounts
  ksmbd: fix translation in smb2_populate_readdir_entry()
  ksmbd: fix translation in create_posix_rsp_buf()
  smb2pdu: fix translation in ksmbd_acls_fattr()
  ksmbd: fix translation in acl entries
  ksmbd: fix subauth 0 handling in sid_to_id()
  ksmbd: fix translation in sid_to_id()
  ndr: fix translation in ndr_encode_posix_acl()
  ksmbd: ensure error is surfaced in set_file_basic_info()
  ksmbd: remove setattr preparations in set_file_basic_info()
  ksmbd: defer notify_change() call

 fs/ksmbd/ndr.c        |  4 +--
 fs/ksmbd/oplock.c     |  6 ++--
 fs/ksmbd/smb2pdu.c    | 43 +++++++++++++--------------
 fs/ksmbd/smb_common.c |  4 +--
 fs/ksmbd/smb_common.h |  1 -
 fs/ksmbd/smbacl.c     | 69 +++++++++++++++++++++++++++----------------
 fs/ksmbd/smbacl.h     | 25 ++++++++++++++++
 fs/ksmbd/vfs.c        | 47 ++++++++++++++++-------------
 fs/ksmbd/vfs.h        |  3 +-
 9 files changed, 125 insertions(+), 77 deletions(-)


base-commit: 0bffa153a2f46dcbced4a48167e91522d8aabe58
-- 
2.30.2

