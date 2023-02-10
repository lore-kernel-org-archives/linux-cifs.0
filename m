Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA01C636D4
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Feb 2023 23:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjBJXe4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Feb 2023 18:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjBJXeg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Feb 2023 18:34:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647CE749B4
        for <linux-cifs@vger.kernel.org>; Fri, 10 Feb 2023 15:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676071947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZbR1ERx60swPmHLlvc4O0e0pHhwkZikBmUg0OVIfTvo=;
        b=InFeVYqZxWwzSHwBnjHs2VZCO+jMMZ8UJwsfA1WRV3tMQODePmWTfy4e6BOYx7Ok4et6PV
        NHLxc5C+lsU0Gb4dEz80F7ha47ER3iA5Dj9a1mO6bLn4p+Hx0x5w8xGT7Ju8lqHTiI/K+k
        Za01vt5MIw8gzDpeb+1DG4TzeYkfAc0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-70-GqZrSFZvN8esdIMG-wCbww-1; Fri, 10 Feb 2023 18:32:24 -0500
X-MC-Unique: GqZrSFZvN8esdIMG-wCbww-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D09E738060FE;
        Fri, 10 Feb 2023 23:32:23 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44BD340398A0;
        Fri, 10 Feb 2023 23:32:22 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Tom Talpey <tom@talpey.com>,
        Stefan Metzmacher <metze@samba.org>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steve French <sfrench@samba.org>
Subject: [PATCH 06/11] cifs: Add a function to read into an iter from a socket
Date:   Fri, 10 Feb 2023 23:32:00 +0000
Message-Id: <20230210233205.1517459-7-dhowells@redhat.com>
In-Reply-To: <20230210233205.1517459-1-dhowells@redhat.com>
References: <20230210233205.1517459-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add a helper function to read data from a socket into the given iterator.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org

Link: https://lore.kernel.org/r/164928617874.457102.10021662143234315566.stgit@warthog.procyon.org.uk/ # v1
Link: https://lore.kernel.org/r/165211419563.3154751.18431990381145195050.stgit@warthog.procyon.org.uk/ # v1
Link: https://lore.kernel.org/r/165348879662.2106726.16881134187242702351.stgit@warthog.procyon.org.uk/ # v1
Link: https://lore.kernel.org/r/165364826398.3334034.12541600783145647319.stgit@warthog.procyon.org.uk/ # v3
Link: https://lore.kernel.org/r/166126395495.708021.12328677373159554478.stgit@warthog.procyon.org.uk/ # v1
Link: https://lore.kernel.org/r/166697258876.61150.3530237818849429372.stgit@warthog.procyon.org.uk/ # rfc
Link: https://lore.kernel.org/r/166732031039.3186319.10691316510079412635.stgit@warthog.procyon.org.uk/ # rfc
---
 fs/cifs/cifsproto.h |  3 +++
 fs/cifs/connect.c   | 14 ++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 1207b39686fb..cb7a3fe89278 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -244,6 +244,9 @@ extern int cifs_read_page_from_socket(struct TCP_Server_Info *server,
 					struct page *page,
 					unsigned int page_offset,
 					unsigned int to_read);
+int cifs_read_iter_from_socket(struct TCP_Server_Info *server,
+			       struct iov_iter *iter,
+			       unsigned int to_read);
 extern int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb);
 void cifs_mount_put_conns(struct cifs_mount_ctx *mnt_ctx);
 int cifs_mount_get_session(struct cifs_mount_ctx *mnt_ctx);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b2a04b4e89a5..152b457b849f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -765,6 +765,20 @@ cifs_read_page_from_socket(struct TCP_Server_Info *server, struct page *page,
 	return cifs_readv_from_socket(server, &smb_msg);
 }
 
+int
+cifs_read_iter_from_socket(struct TCP_Server_Info *server, struct iov_iter *iter,
+			   unsigned int to_read)
+{
+	struct msghdr smb_msg = { .msg_iter = *iter };
+	int ret;
+
+	iov_iter_truncate(&smb_msg.msg_iter, to_read);
+	ret = cifs_readv_from_socket(server, &smb_msg);
+	if (ret > 0)
+		iov_iter_advance(iter, ret);
+	return ret;
+}
+
 static bool
 is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 {

