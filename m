Return-Path: <SRS0=EeRJ=6F=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 267C6C54FCC
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Apr 2020 02:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E913E20781
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Apr 2020 02:45:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="L2vHT9O0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgDUCpB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Apr 2020 22:45:01 -0400
Received: from mx.cjr.nz ([51.158.111.142]:24984 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgDUCpB (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 20 Apr 2020 22:45:01 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id B4721804E0;
        Tue, 21 Apr 2020 02:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1587437100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LoWESeIpMF7OxmcC/QgUNWBUj7YSsoAc3GveT4i4nAA=;
        b=L2vHT9O0iEUyHqHb+FcgupeoFzDokY+TXw71mVSfz3q3dJVu9eWbq6/Gw1YBtK/x4CvsTP
        IwdAtLc98J6JXvRA+evcpJFJ6u/SV8UHM1uuFcB/3jND1zfPZPcXl5+IqzOpJmESQVA6iN
        9WvQaqF8l/usubvxUf9Qh4GokFrY9zjluu/xHhbR7+imXuhZKtap/Ct0T1zz6NTblPmZEq
        7OEzJl88w20yk9keDc5EZ3MKuRPyjS2e4WUi/x05aL4fiXvOIdn8kfQc9ZZJG7pd51k60X
        9Cn1CqscVhadv6v87ke0qYYZDU8cccEzaLuxw4zWB7ctUd9xm+hbObKR4YkyxA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        samba-technical@lists.samba.org
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 3/3] cifs: fix uninitialised lease_key in open_shroot()
Date:   Mon, 20 Apr 2020 23:44:24 -0300
Message-Id: <20200421024424.3112-3-pc@cjr.nz>
In-Reply-To: <20200421024424.3112-1-pc@cjr.nz>
References: <20200421024424.3112-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

SMB2_open_init() expects a pre-initialised lease_key when opening a
file with a lease, so set pfid->lease_key prior to calling it in
open_shroot().

This issue was observed when performing some DFS failover tests and
the lease key was never randomly generated.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/smb2ops.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index b36c46f48705..f829f4165d38 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -687,6 +687,11 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
+	if (!server->ops->new_lease_key)
+		return -EIO;
+
+	server->ops->new_lease_key(pfid);
+
 	memset(rqst, 0, sizeof(rqst));
 	resp_buftype[0] = resp_buftype[1] = CIFS_NO_BUFFER;
 	memset(rsp_iov, 0, sizeof(rsp_iov));
-- 
2.26.0

