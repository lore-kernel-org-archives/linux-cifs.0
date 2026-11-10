Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=173.212.254.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794301313;
	b=Vm0B7kk8K0EFXVMNUQ+uHtpP2BNpT5FR9kewfWJMhR2Xal496UsDoB3UJP4sXIETNnrS
	 bJukXuWk/ycFO8l3dL6pIhB2RVQGKc0mR6HiYXJVapSik2aIB8vKKKo26F+sa+YshX0v6
	 pSVRSbgUkiOYK2VVPDhb6Cq5TIrftbe9GiJTfuAyXklJzUEbnBfJ1X2XqrETk1Gq4R2hO
	 T0Pfa9rkPHvVNieibh0v5JvU6wBtfHAzZia/0/kWzITFytQ12/xJtxvHd/VBwFoF+od3B
	 nJ3Ug8Od3LVv8ZfulyQnYbHe0itgYgSNmFUHhMn0CaTdPfkBDiCUbS5NZPqwrDjpyqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794301313;
	h=DMARC-Filter:DKIM-Signature:X-Virus-Scanned:Received:From:To:Cc:
	 Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=tdvwiNlqaiNgnQeeDxlcwnYpnhQBbwCpT74p9vzgZbc=;
	b=IEqBOASOR6tArBAA/1fO5kWeMdRsUneyKRo9Yo6tvZYmgI8fQpwuyPbxkUyEtFrdB6nm
	 aL9BHRj2X+X2kpl6UZ0DUCNEmDtwmMcIO1fPgUQzz6k31ccDBydQK8hxht4Rw0S0CYq09
	 QTcDksnUJTy9GtRHLgwvNdh4ZwAz7L63JPOZ2leY9IYpPH/cRoZxKU+/KLzhcShAnUNWT
	 oVqdctZIC4B3B2cu+q9rg4qM0MYZcQBJXoCWH9a9A2WFnZLaZE2mrfq9pmlRhqhlnRnTW
	 BGZZvO2/gEBv9xSCUWS9RUaqBcEtk+b2Nuo/QBFChf0zmJnmGxZ+E9B/RNNQF3qvSFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tuxist.de;
	spf=pass smtp.mailfrom=tuxist.de;
	dkim=pass header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b=LxnN5cpN;
	arc=none smtp.remote-ip=173.212.254.19
Received: from proxyplus-primary (groupware.tuxist.de [173.212.254.19])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB723606A333;
	Tue, 10 Nov 2026 09:01:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB723606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tuxist.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxist.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b=LxnN5cpN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tuxist.de; s=201705; h=from:to:subject:date:message-id; bh=tdvwiNlqaiNgnQeeDxlcwnYpnhQBbwCpT74p9vzgZbc=; b=LxnN5cpN8XJ0h92RHN7CfIqWh3ls2CW7+cCitxb9OvfBU0/S9qpIhB873+L1X6jds5AWIHU6Qbpwj+nbMx6I7mCyE+WL4uGlJMz1tiHN+RAI0+QeADTVgz5pzI7Q1vJKfnQN2ewuj82ZZa9dEd+qNKXfCsqW80CHGi9918+E7KGa3fuVX3Aaux5u9GUJ0IyMYtHCa1vyfYMDuIfmibrFVcSZjqCRmHlvgYEzk2szPTG3mImI9mX4kPBdQxtvlH2WyqDFNSTpH7gQeaCfifSJoJnbFBsIHN6CR9vMxrUn6DFjiNMFjr8wdFyMJrgaJWvJPgfuwUVRP+Tcey8ZKB6Rxg==
Authentication-Results: proxyplus-primary; auth=pass smtp.auth=713ee033-d4f8-4c9d-9e24-a891eb9c547d
X-Virus-Scanned: proxyplus-clamav builtin
Received: from groupi3 ([10.1.2.47]) by proxyplus-primary (ProxyPlus) with ESMTPSA; Tue, 10 Nov 2026 09:01:21 +0000
From: Jan Koester <jan.koester@tuxist.de>
To: linkinjeon@kernel.org, smfrench@gmail.com
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, brauner@kernel.org, linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/6] ksmbd: keep named ACL entries effective when a DACL sets a POSIX ACL
Date: Tue, 10 Nov 2026 09:02:33 +0000
Message-ID: <13deb997dee36bdc7f75e2ae@groupi3>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

parse_dacl() turns ACEs for other users into named POSIX ACL entries
with an rwx mask, but leaves the group bits of fattr->cf_mode as the
owning group's ACE made them. set_info_sec() sets the ACL first and
then the mode, and on an inode with an extended ACL the mode's group
bits are the mask: a DACL without an ACE for the owning group (as
Windows writes them) left the mask at --- and every named entry
without effect.

Put the mask into the mode's group bits when there are named entries.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Jan Koester <jan.koester@tuxist.de>
---
 fs/smb/server/smbacl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index d1cf63a9fe..b3daf65798 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -680,6 +680,12 @@ static int parse_dacl(struct mnt_idmap *idmap,
 
 	if (acl_state.users->n || acl_state.groups->n) {
 		acl_state.mask.allow = 0x07;
+		/*
+		 * With named entries the mode's group bits are the ACL's mask:
+		 * the chmod after setting the ACL mustn't mask them all off.
+		 */
+		fattr->cf_mode = (fattr->cf_mode & ~0070) |
+				 (acl_state.mask.allow << 3);
 
 		if (IS_ENABLED(CONFIG_FS_POSIX_ACL)) {
 			fattr->cf_acls =
-- 
2.56.0
