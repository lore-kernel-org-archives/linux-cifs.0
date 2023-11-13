Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F8A20B3F
	for <linux-cifs@vger.kernel.org>; Mon, 13 Nov 2023 14:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail.astralinux.ru (mail.astralinux.ru [217.74.38.119])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13BC1727;
	Mon, 13 Nov 2023 06:53:14 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.astralinux.ru (Postfix) with ESMTP id 617051869BC8;
	Mon, 13 Nov 2023 17:53:11 +0300 (MSK)
Received: from mail.astralinux.ru ([127.0.0.1])
	by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id nYCq2uBFoeUm; Mon, 13 Nov 2023 17:53:11 +0300 (MSK)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.astralinux.ru (Postfix) with ESMTP id 6BE171869B23;
	Mon, 13 Nov 2023 17:53:10 +0300 (MSK)
X-Virus-Scanned: amavisd-new at astralinux.ru
Received: from mail.astralinux.ru ([127.0.0.1])
	by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id zc-H-Ba6Jp82; Mon, 13 Nov 2023 17:53:10 +0300 (MSK)
Received: from rbta-msk-lt-106062.astralinux.ru (unknown [10.177.20.25])
	by mail.astralinux.ru (Postfix) with ESMTPSA id 365101863BDD;
	Mon, 13 Nov 2023 17:53:08 +0300 (MSK)
From: Anastasia Belova <abelova@astralinux.ru>
To: Steve French <sfrench@samba.org>
Cc: Anastasia Belova <abelova@astralinux.ru>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Jeff Layton <jlayton@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Ekaterina Esina <eesina@astralinux.ru>
Subject: [PATCH] cifs: spnego: add ';' in HOST_KEY_LEN
Date: Mon, 13 Nov 2023 17:52:32 +0300
Message-Id: <20231113145232.12448-1-abelova@astralinux.ru>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

"host=3D" should start with ';' (as in cifs_get_spnego_key)
So its length should be 6.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 7c9c3760b3a5 ("[CIFS] add constants for string lengths of keynames=
 in SPNEGO upcall string")
Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
Co-developed-by: Ekaterina Esina <eesina@astralinux.ru>
Signed-off-by: Ekaterina Esina <eesina@astralinux.ru>
---
 fs/smb/client/cifs_spnego.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifs_spnego.c b/fs/smb/client/cifs_spnego.c
index 6f3285f1dfee..af7849e5974f 100644
--- a/fs/smb/client/cifs_spnego.c
+++ b/fs/smb/client/cifs_spnego.c
@@ -64,8 +64,8 @@ struct key_type cifs_spnego_key_type =3D {
  * strlen(";sec=3Dntlmsspi") */
 #define MAX_MECH_STR_LEN	13
=20
-/* strlen of "host=3D" */
-#define HOST_KEY_LEN		5
+/* strlen of ";host=3D" */
+#define HOST_KEY_LEN		6
=20
 /* strlen of ";ip4=3D" or ";ip6=3D" */
 #define IP_KEY_LEN		5
--=20
2.30.2

