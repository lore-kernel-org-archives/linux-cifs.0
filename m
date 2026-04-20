Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1DA34216C;
	Mon, 20 Apr 2026 16:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701422; cv=none; b=NyjFYudA267g+smJEe8s/VdZBrYZ6i9zc1XX/Xksze+KNIyfmDNl/wj/kgDCed1IC1W0VMCvn8J4FBbSz9fW8JoqZ8SNvX+43CN7JVX9Zp+A9v8NcHxuJUOKYcXJbQYm12ZzT0QVhtjOhPlmmCY4ZSr9T22nViEiAV2myEPRXb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701422; c=relaxed/simple;
	bh=zRjqlA3FUqwtDjU1flQlzv/f0TlTFLAFyfYAwfsZg7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKAYXSIkNR4ZQyzkt1KZoRXjXUzwYDvVuGIhCoiLqu4Jg18/kWDqBDU7G8p3fJbgPEzuBDEpBFeiEzjb0yObrHZ5dOoI9zX7v006eXW+QChgOMaCUB7BMWoBZsBFQXSf/yxqEtQfQUqdsYuZ9qwxsPKgGZdWZG3Uzc6fUatXwME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xOORXfko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xOORXfko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984D8C19425;
	Mon, 20 Apr 2026 16:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701421;
	bh=zRjqlA3FUqwtDjU1flQlzv/f0TlTFLAFyfYAwfsZg7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xOORXfkopuZrY3tmh9ckxcZ64Vg52TO4V1L+acjcdi4dwRSoMbJT7zP0yLfdHi0ul
	 XpOStppuaPFrxZiG7+Qz4/db/ff3qsoko98dt8VAUzaEbq00DN4Q5XtbuWkhQ+oToU
	 9A5kF0PJ0YIgrhGpNavkT4SH3uFcSDVxIVcMhEQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	stable <stable@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 107/162] smb: client: fix off-by-8 bounds check in check_wsl_eas()
Date: Mon, 20 Apr 2026 17:42:19 +0200
Message-ID: <20260420153930.916061173@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 3d8b9d06bd3ac4c6846f5498800b0f5f8062e53b upstream.

The bounds check uses (u8 *)ea + nlen + 1 + vlen as the end of the EA
name and value, but ea_data sits at offset sizeof(struct
smb2_file_full_ea_info) = 8 from ea, not at offset 0.  The strncmp()
later reads ea->ea_data[0..nlen-1] and the value bytes follow at
ea_data[nlen+1..nlen+vlen], so the actual end is ea->ea_data + nlen + 1
+ vlen.  Isn't pointer math fun?

The earlier check (u8 *)ea > end - sizeof(*ea) only guarantees the
8-byte header is in bounds, but since the last EA is placed within 8
bytes of the end of the response, the name and value bytes are read past
the end of iov.

Fix this mess all up by using ea->ea_data as the base for the bounds
check.

An "untrusted" server can use this to leak up to 8 bytes of kernel heap
into the EA name comparison and influence which WSL xattr the data is
interpreted as.

Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -125,7 +125,7 @@ static int check_wsl_eas(struct kvec *rs
 		nlen = ea->ea_name_length;
 		vlen = le16_to_cpu(ea->ea_value_length);
 		if (nlen != SMB2_WSL_XATTR_NAME_LEN ||
-		    (u8 *)ea + nlen + 1 + vlen > end)
+		    (u8 *)ea->ea_data + nlen + 1 + vlen > end)
 			return -EINVAL;
 
 		switch (vlen) {


