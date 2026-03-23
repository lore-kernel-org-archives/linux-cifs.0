Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92C735959;
	Mon, 23 Mar 2026 15:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278973; cv=none; b=KdXguf0fClsFLS31o5MIZM15tim0YES9Jc/m7UxZUg/LUZOckHIV07GJ68u0QrBL3qoALPwa8lJuQn6fn4sHS0KDccrN+bwcPCQPpCPpmNvvrN0HovHwkmcWk+T9LjLi3M+WUdB3trlvC5okmRsAF2ip9jjdi/CCEYYX9Z7Ps9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278973; c=relaxed/simple;
	bh=s5FJcUZoPLWYk84xyQlrsFNTEV+Pja7E98BNt7kDAhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FefRDnVF0p3dHT8LChupG7dP/gTBBi0VDd+NJPHHFL0Jm1tX51bgCKPiYMlX6DmIcc92yQv8CgUGfKkB6Xe3beYL3k+8Gow97OEzmHx7UvtIEx8GfhKXPmhnUusbpQgQNL0UR5w0cRgLE5c12VfPtcozNssmJbZrizfH4/15hsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgFugTnn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgFugTnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4153FC2BCB1;
	Mon, 23 Mar 2026 15:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278973;
	bh=s5FJcUZoPLWYk84xyQlrsFNTEV+Pja7E98BNt7kDAhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgFugTnnmZcD8/C2f4M6c8psWFgg0g+cxRS4pBLvGHSn71vC9RUsooX6l1A8b6Qj1
	 CLj01vxYZrsLPJMW68qGv0gvwBxCZCR1MLH/P7gwK03Hiy5K+Xfx66AkZ7QXXiW+Zx
	 H1JE/HzszeNaPVPvUtVuENcvZy6U+zCeBeHZ0zxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oscar Santos <ossantos@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 461/567] smb: client: fix krb5 mount with username option
Date: Mon, 23 Mar 2026 14:46:21 +0100
Message-ID: <20260323134545.388984932@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 12b4c5d98cd7ca46d5035a57bcd995df614c14e1 upstream.

Customer reported that some of their krb5 mounts were failing against
a single server as the client was trying to mount the shares with
wrong credentials.  It turned out the client was reusing SMB session
from first mount to try mounting the other shares, even though a
different username= option had been specified to the other mounts.

By using username mount option along with sec=krb5 to search for
principals from keytab is supported by cifs.upcall(8) since
cifs-utils-4.8.  So fix this by matching username mount option in
match_session() even with Kerberos.

For example, the second mount below should fail with -ENOKEY as there
is no 'foobar' principal in keytab (/etc/krb5.keytab).  The client
ends up reusing SMB session from first mount to perform the second
one, which is wrong.

```
$ ktutil
ktutil:  add_entry -password -p testuser -k 1 -e aes256-cts
Password for testuser@ZELDA.TEST:
ktutil:  write_kt /etc/krb5.keytab
ktutil:  quit
$ klist -ke
Keytab name: FILE:/etc/krb5.keytab
KVNO Principal
 ---- ----------------------------------------------------------------
   1 testuser@ZELDA.TEST (aes256-cts-hmac-sha1-96)
$ mount.cifs //w22-root2/scratch /mnt/1 -o sec=krb5,username=testuser
$ mount.cifs //w22-root2/scratch /mnt/2 -o sec=krb5,username=foobar
$ mount -t cifs | grep -Po 'username=\K\w+'
testuser
testuser
```

Reported-by: Oscar Santos <ossantos@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1922,6 +1922,10 @@ static int match_session(struct cifs_ses
 	case Kerberos:
 		if (!uid_eq(ctx->cred_uid, ses->cred_uid))
 			return 0;
+		if (strncmp(ses->user_name ?: "",
+			    ctx->username ?: "",
+			    CIFS_MAX_USERNAME_LEN))
+			return 0;
 		break;
 	case NTLMv2:
 	case RawNTLMSSP:


