Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58FC0C05027
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Feb 2023 12:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjBAMFP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Feb 2023 07:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjBAMFP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Feb 2023 07:05:15 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE2F29E29
        for <linux-cifs@vger.kernel.org>; Wed,  1 Feb 2023 04:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=ckIKHSSh7ZXwZqAGA+y+Om+tLDlRLH0yoGEQVhYOAuM=; b=EOdkW0NpFg1tzreXX3tHHPisqt
        ggjcjBudtVUYbCgDFVTr9ucJF7VXH9KHU/z4TraNOVLmuv+WvSYpOV7NoCgOckPGyPi/iMzgGYKXa
        1OS3etMBroEnO6WqUgUS8hQRoLO4dxToKfBqkjV4+0SedalAva8G2s/3TvjmRhQqfUus/gTp6QgiQ
        KtG25urBy7DttyzTpFSgyYHoH4e9jXfcF3OVmj6auaUjx4GIj0+c0nbmTP654r8+v7eFNv2vasbNf
        zrecL3Gid5m8nbRw/9nyzFSDbCO/GwBkBDNNtkDa+/2KmH94cai8H9BDK3WnvZvf/bVhy7c+CXna4
        xckrHARBjMgRR5z2geLs2RSSbhgUuAjresaDPv4rnDrAWU2YeEbA2/x3eRm2MCkXMcWJSW2Gj+r3/
        +e22zdVIyJcVUUrURleGTGJ6me1TFpKpIYTXlVrQCDads2YsQ+44IHM4GBGwLuwZgDThic7zThcgw
        VQFrtc3VNm7Hl+L+g5Wow6KE;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pNBrQ-00BE5d-5r; Wed, 01 Feb 2023 12:05:08 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        David Howells <dhowells@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 0/3] avoid plaintext rdma offset if encryption is required
Date:   Wed,  1 Feb 2023 13:04:40 +0100
Message-Id: <cover.1675252643.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I think it is a security problem to send confidential data in plaintext
over the wire, so we should avoid doing that even if rdma is in use.

We already have a similar check to prevent data integrity problems
for rdma offload.

Modern Windows servers support signed and encrypted rdma offload,
but we don't support this yet...

Stefan Metzmacher (3):
  cifs: introduce cifs_io_parms in smb2_async_writev()
  cifs: split out smb3_use_rdma_offload() helper
  cifs: don't try to use rdma offload on encrypted connections

 fs/cifs/smb2pdu.c | 89 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 70 insertions(+), 19 deletions(-)

-- 
2.34.1

