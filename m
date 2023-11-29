Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S1WbJC++"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F80DB6
	for <linux-cifs@vger.kernel.org>; Wed, 29 Nov 2023 08:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701276990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ElC8RAQdfN2Ln/hT1ay+FjIT1Y57onjWn6huuiDhwuM=;
	b=S1WbJC++xKQLKNmsY9vGwTVIwRqvtwz+sles6ThBD33NZK3gkrmpKRezU9+I6z9DbI6OAq
	fyka0itu4tuNGVcCHEw0DLagtECny8gPv6U6G3AgbRAeMYembBhZA3cKJqxc0IB8va3972
	zpKOkega7BzSExX6mHcYnnOI1jfkEsc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-331-HkqjQLWeM0mvcv48uRBM8w-1; Wed, 29 Nov 2023 11:56:26 -0500
X-MC-Unique: HkqjQLWeM0mvcv48uRBM8w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30CB7185A7A9;
	Wed, 29 Nov 2023 16:56:26 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.161])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B90BD112130A;
	Wed, 29 Nov 2023 16:56:24 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	Rohith Surabattula <rohiths.msft@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/3] cifs: Fix FALLOC_FL_ZERO_RANGE by setting i_size if EOF moved
Date: Wed, 29 Nov 2023 16:56:17 +0000
Message-ID: <20231129165619.2339490-2-dhowells@redhat.com>
In-Reply-To: <20231129165619.2339490-1-dhowells@redhat.com>
References: <20231129165619.2339490-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Fix the cifs filesystem implementations of FALLOC_FL_ZERO_RANGE, in
smb3_zero_range(), to set i_size after extending the file on the server.

Fixes: 72c419d9b073 ("cifs: fix smb3_zero_range so it can expand the file-size when required")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.com>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
cc: linux-mm@kvack.org
---
 fs/smb/client/smb2ops.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index a959ed2c9b22..572d2c22a703 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3307,6 +3307,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	struct inode *inode = file_inode(file);
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 	struct cifsFileInfo *cfile = file->private_data;
+	unsigned long long new_size;
 	long rc;
 	unsigned int xid;
 	__le64 eof;
@@ -3337,10 +3338,15 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	/*
 	 * do we also need to change the size of the file?
 	 */
-	if (keep_size == false && i_size_read(inode) < offset + len) {
-		eof = cpu_to_le64(offset + len);
+	new_size = offset + len;
+	if (keep_size == false && (unsigned long long)i_size_read(inode) < new_size) {
+		eof = cpu_to_le64(new_size);
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 				  cfile->fid.volatile_fid, cfile->pid, &eof);
+		if (rc >= 0) {
+			truncate_setsize(inode, new_size);
+			fscache_resize_cookie(cifs_inode_cookie(inode), new_size);
+		}
 	}
 
  zero_range_exit:

