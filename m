Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C193DC6FD1D
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Mar 2023 11:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjCQLP7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Mar 2023 07:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjCQLPz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Mar 2023 07:15:55 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE73317CEA
        for <linux-cifs@vger.kernel.org>; Fri, 17 Mar 2023 04:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=520otV0fl6ruNu3nsplI0Nj/cDIeqDOeqpQtnhOmWwY=; b=Q7MZ3vWRdpneWByKrxrcL66vpQ
        r0HDaq7+oIIjwk1JAsArk6EFdb2VqW9hcL+OUqBj6JlKpZYCtagG9WyGs4xBT2oNmJUyLyXzx5zQf
        r4OEdhpaqXHRb/mJoKYaZixxc9qhjhf0rPbr89CLUIsoum70fV5Aq+yFMTPM4E+cK0FKORRrI/7l/
        OPGZEI8xg3/E8LmAJXfj28N2dzJ/ymWsDvjQj5y0fpXWMmGAnSlN50Q+vGBD15tPCVH7MBKh2Pd1Q
        EHSVb/Z0Ef4SUHQpccTyI/WnzYk0rd98HfBtF1LzLM5N1606AG6CmTZPCJDcPyb+/nFPoK+BWf5sn
        AlPFk9JZ4f+bY6iJHDi0wIa2+IZxZnu1+urZTEaJUs3eOCUJNl5G8sDuogwU2QQlsY5UKoyqTkGJ+
        +5vT36LJV/S9QwbBnZLixQ9e+i9iXma0wyHWfORLiOekipdRAo0aY1YhxyEWUpC4KHBfGD0yQ+8iO
        0DG4V6VwzApmxb8/pF1HwqWS;
Received: from [2a01:4f8:252:410e::177:224] (port=37520 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1pd83n-003p4x-Q0; Fri, 17 Mar 2023 11:15:47 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 1/7] cifs: Avoid a cast in add_lease_context()
Date:   Fri, 17 Mar 2023 11:15:22 +0000
Message-Id: <bc478d334dca9a0508ced5f052ffa00132470d28.1679051552.git.vl@samba.org>
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
 fs/cifs/smb2pdu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 0e53265e1462..3eb745237459 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2148,10 +2148,11 @@ smb2_parse_contexts(struct TCP_Server_Info *server,
 }
 
 static int
-add_lease_context(struct TCP_Server_Info *server, struct kvec *iov,
+add_lease_context(struct TCP_Server_Info *server,
+		  struct smb2_create_req *req,
+		  struct kvec *iov,
 		  unsigned int *num_iovec, u8 *lease_key, __u8 *oplock)
 {
-	struct smb2_create_req *req = iov[0].iov_base;
 	unsigned int num = *num_iovec;
 
 	iov[num].iov_base = server->ops->create_lease_buf(lease_key, *oplock);
@@ -2833,7 +2834,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 		  (oparms->create_options & CREATE_NOT_FILE))
 		req->RequestedOplockLevel = *oplock; /* no srv lease support */
 	else {
-		rc = add_lease_context(server, iov, &n_iov,
+		rc = add_lease_context(server, req, iov, &n_iov,
 				       oparms->fid->lease_key, oplock);
 		if (rc)
 			return rc;
-- 
2.30.2

