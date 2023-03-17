Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04097C7618B
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Mar 2023 11:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjCQLP4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Mar 2023 07:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCQLPz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Mar 2023 07:15:55 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294D43B21D
        for <linux-cifs@vger.kernel.org>; Fri, 17 Mar 2023 04:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=BzNjhH9ScODyxjxIjrrBhUvgn9xEEkoimnXm3TQJdAo=; b=Rjwgz9zizpAeOU35055wAln+L2
        44huYE/+zO0ObjYnX0RtPlwkX5MaPRpQ2J0O3apNC/+2khwV8+4828H2WaMqp62h8mFawkum4ZK5E
        sl5IyK4y8wxgCsOGZOrP3Y0YwkLuM4Y5J9SpXzb+I73LHouNmEKbUAs5Nhq8rpt73LSQB1ww356+J
        vAk2FB2MxveZegO/HdOjRAzzjEVfACQwrahdD4voEZI9DoCMTiqVmU8KW2NxZrITQTzkBxHgTF+Gh
        oXKzBtZZksfL75Usc6U1wzW6o2DBgNoQqOQ5wsNJzPppq1LlMEFkyXkX5RXOOSxqMyFuydkRIFzI5
        nQTcMMD0vrrtiitL0pajOTqy02rq+Ajq7QGrQpCgrQ3gLl8898N0dVhWYbg/bH8YNDKtpmIUPbmDL
        2EVV6satvDWCJ+NLhgqz7aj4yngj/Nb1iWcfKZB9qXqP3kkQ85z5a76i4zXx3vOdvQA/OvD9XRa39
        F8bDzoapxcd3FM8CMcn2txoW;
Received: from [2a01:4f8:252:410e::177:224] (port=37520 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1pd83o-003p4x-6G; Fri, 17 Mar 2023 11:15:48 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 3/7] cifs: Avoid a cast in add_posix_context()
Date:   Fri, 17 Mar 2023 11:15:24 +0000
Message-Id: <7344eac4bab0f3d162ca5a401d9620d468ea3292.1679051552.git.vl@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1679051552.git.vl@samba.org>
References: <cover.1679051552.git.vl@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We have the correctly-typed struct smb2_create_req * available in the
caller.

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/smb2pdu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index cebb8d9837d2..6b6790d8d0ee 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -795,9 +795,9 @@ create_posix_buf(umode_t mode)
 }
 
 static int
-add_posix_context(struct kvec *iov, unsigned int *num_iovec, umode_t mode)
+add_posix_context(struct smb2_create_req *req,
+		  struct kvec *iov, unsigned int *num_iovec, umode_t mode)
 {
-	struct smb2_create_req *req = iov[0].iov_base;
 	unsigned int num = *num_iovec;
 
 	iov[num].iov_base = create_posix_buf(mode);
@@ -2694,7 +2694,7 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 
 	if (tcon->posix_extensions) {
 		/* resource #3: posix buf */
-		rc = add_posix_context(iov, &n_iov, mode);
+		rc = add_posix_context(req, iov, &n_iov, mode);
 		if (rc)
 			goto err_free_req;
 		pc_buf = iov[n_iov-1].iov_base;
@@ -2863,7 +2863,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 				cpu_to_le32(iov[n_iov-1].iov_len);
 		}
 
-		rc = add_posix_context(iov, &n_iov, oparms->mode);
+		rc = add_posix_context(req, iov, &n_iov, oparms->mode);
 		if (rc)
 			return rc;
 	}
-- 
2.30.2

