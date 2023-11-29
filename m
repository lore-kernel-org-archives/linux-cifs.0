Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W/Q9VVwp"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D34BE
	for <linux-cifs@vger.kernel.org>; Wed, 29 Nov 2023 08:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701276988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mwPpdhlYYaHD0bYeEis0CU8df9ASTS3wuKo9KB9sGXI=;
	b=W/Q9VVwpAbkLo1nz7pa4sfH4ISanKb/PPpoxN5PTsBliITwwgNpmNhYN7AukXROpV/SGVM
	jPRMYgVcRwi5mCnilwk3hvxmi/htjRuXAo4+MQoJLoou8fCqNXyERnryPBGBunMGgqPLS1
	B4YoVszJcC30cotA+425NJ7x5u7CPL8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-LUmdmRd7NrCAEP8vXLpuJw-1; Wed, 29 Nov 2023 11:56:24 -0500
X-MC-Unique: LUmdmRd7NrCAEP8vXLpuJw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16518185A794;
	Wed, 29 Nov 2023 16:56:24 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.161])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9A1C51C060BB;
	Wed, 29 Nov 2023 16:56:22 +0000 (UTC)
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
Subject: [PATCH 0/3] cifs: Fixes for copy_file_range() and FALLOC_FL_INSERT/ZERO_RANGE
Date: Wed, 29 Nov 2023 16:56:16 +0000
Message-ID: <20231129165619.2339490-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Hi Steve,

Here are three patches for cifs:

 (1) Fix FALLOC_FL_ZERO_RANGE support to change i_size if the file is
     extended.

 (2) Fix FALLOC_FL_INSERT_RANGE support to change i_size after it moves the
     EOF on the server.

 (3) Fix copy_file_range() support to handle invalidation and flushing of
     overlapping dirty data correctly, to move the EOF on the server to
     deal with lazy flushing of locally dirty data and to set the i_size
     afterwards if the copy extended the file.

I've pushed the patches here also:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=cifs-fixes

David

David Howells (3):
  cifs: Fix FALLOC_FL_ZERO_RANGE by setting i_size if EOF moved
  cifs: Fix FALLOC_FL_INSERT_RANGE by setting i_size after EOF moved
  cifs: Fix flushing, invalidation and file size with copy_file_range()

 fs/smb/client/cifsfs.c  | 80 +++++++++++++++++++++++++++++++++++++++--
 fs/smb/client/smb2ops.c | 13 +++++--
 2 files changed, 88 insertions(+), 5 deletions(-)

