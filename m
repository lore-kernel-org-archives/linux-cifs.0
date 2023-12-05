Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448D66AA0;
	Tue,  5 Dec 2023 03:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VydX8MOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5374C433C8;
	Tue,  5 Dec 2023 03:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746446;
	bh=qV+4zjXL0TiXHvziRqiFxYdBP/t+/R2IGWMDhPZyiUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VydX8MOTMvUnt9hciP15OIJEQNNaSgSXtJyUJwA17GQEcN5DQTyvLDHj5BAebJXXB
	 opS6EO+NdDhNSUltVwlOoU7M5qD4+Hin8uyb2KD09wDXERRiOaqn0JwmtZUd3FCX+D
	 RoK7kCxDsy2Z2aCZdH2SZmg5gFkhW3w+bW+dgRjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	Rohith Surabattula <rohiths.msft@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-mm@kvack.org,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 003/134] cifs: Fix FALLOC_FL_INSERT_RANGE by setting i_size after EOF moved
Date: Tue,  5 Dec 2023 12:14:35 +0900
Message-ID: <20231205031535.410691213@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 88010155f02b2c3b03c71609ba6ceeb457ece095 upstream.

Fix the cifs filesystem implementations of FALLOC_FL_INSERT_RANGE, in
smb3_insert_range(), to set i_size after extending the file on the server
and before we do the copy to open the gap (as we don't clean up the EOF
marker if the copy fails).

Fixes: 7fe6fe95b936 ("cifs: add FALLOC_FL_INSERT_RANGE support")
Cc: stable@vger.kernel.org
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Paulo Alcantara <pc@manguebit.com>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
cc: linux-mm@kvack.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3739,6 +3739,9 @@ static long smb3_insert_range(struct fil
 	if (rc < 0)
 		goto out_2;
 
+	truncate_setsize(inode, old_eof + len);
+	fscache_resize_cookie(cifs_inode_cookie(inode), i_size_read(inode));
+
 	rc = smb2_copychunk_range(xid, cfile, cfile, off, count, off + len);
 	if (rc < 0)
 		goto out_2;


