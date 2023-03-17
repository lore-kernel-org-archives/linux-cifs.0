Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B5EC76195
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Mar 2023 11:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjCQLP7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Mar 2023 07:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjCQLP5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Mar 2023 07:15:57 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289BB4DE19
        for <linux-cifs@vger.kernel.org>; Fri, 17 Mar 2023 04:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=v+q5i6vrNO9Nw/a7tIgrYAXPnkqCk0gQ0rPEzPqZFRU=; b=filQbofNyKS09x9d3AT1lGLuJe
        3qj+iIGNVTIjP+0QXWHsPGmsp7yDEy9ZyIR0PcsliSoh02CINgOrCkavylckPl2FqqIdeFbW0Uw+Q
        SQj4eqxzKS9k9sNHT4r6BmxZUpq5RPLOCy4MsJnrkdwB6lafTEd5dqSj6ROYFIzHn1FFwb/+JTOSW
        c9I2FHKDIo/9ucaRUU7xImUC+Xi4OedDV9k4vx/EXnC9LRVOqeGnRS3jCv7ByW4ekxr9cld+se1hp
        BtiIVJwcDnkcBUFrJB4xNrd4xXhGxclii8/LMSZvaP6XiLFGym9cfkQNdC/zJNS7/YUlEn53/P2Dd
        Xdalk70EFKv83h1Unnjzi8Qhp44Tx090X29ajm2yQyhIUM90+wH8wYhUe3o6yJhUOFbHn6/tO6sNo
        qqZy0pWb7A1LJTjPI1TlOlfNf5iA0lmuVcAtb5ce737JDqewog3TnxtHLafZpsJBx79mhhTjXhcoe
        diYzBMEhl8RhnW6Ypyg7Lk69;
Received: from [2a01:4f8:252:410e::177:224] (port=37520 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1pd83o-003p4x-MI; Fri, 17 Mar 2023 11:15:48 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 6/7] cifs: Avoid a cast in add_durable_reconnect_v2_context()
Date:   Fri, 17 Mar 2023 11:15:27 +0000
Message-Id: <598f783f2701a596fe8e4bbadf2fa6d97edd91cd.1679051552.git.vl@samba.org>
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
index 6d4a14efa79f..9e9267da28a2 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2261,10 +2261,10 @@ add_durable_v2_context(struct smb2_create_req *req,
 }
 
 static int
-add_durable_reconnect_v2_context(struct kvec *iov, unsigned int *num_iovec,
+add_durable_reconnect_v2_context(struct smb2_create_req *req,
+				 struct kvec *iov, unsigned int *num_iovec,
 		    struct cifs_open_parms *oparms)
 {
-	struct smb2_create_req *req = iov[0].iov_base;
 	unsigned int num = *num_iovec;
 
 	/* indicate that we don't need to relock the file */
@@ -2293,7 +2293,8 @@ add_durable_context(struct smb2_create_req *req,
 
 	if (use_persistent) {
 		if (oparms->reconnect)
-			return add_durable_reconnect_v2_context(iov, num_iovec,
+			return add_durable_reconnect_v2_context(req,
+								iov, num_iovec,
 								oparms);
 		else
 			return add_durable_v2_context(req, iov, num_iovec,
-- 
2.30.2

