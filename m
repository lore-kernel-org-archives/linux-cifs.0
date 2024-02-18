Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B74B5B5DE;
	Sun, 18 Feb 2024 11:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708254953; cv=none; b=qV3of2w6i2ZB7okH/17y19tnUnK4pQjB/ndBiJWJChteYT0J7qU6t9ZD3tWP8q81lhCvTfnyBLPDoyx51PUvMsR1AkHgFdtSzJRFK9egn+68yEqVrd6RH0l44IVgSPolCJL+BbSceGLC8/nvklPqgvgVi9D5wkQlCTM51pV0TH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708254953; c=relaxed/simple;
	bh=3RCAC2tGPp94QxUIfOSNRlkwK8c+7r6xMMR+D5gQG6M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gmdhp2+/T9KjCiv069Lo9kIwMeqcMdHiwhG9k9bTKoATVkHfHJiena//FiVbzevhB3SdIu6wiZD1o5cCDdTdR182ZxfHo3Pymh/esIbndxus/S/SVUaoUyA4KNOv3y7TitOp02XOQlh7pD9fuj9l1H//oDp3yV+kChNq3Hmome8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id B1E4C72C90D;
	Sun, 18 Feb 2024 14:15:47 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [193.43.10.9])
	by imap.altlinux.org (Postfix) with ESMTPSA id A290936D016F;
	Sun, 18 Feb 2024 14:15:47 +0300 (MSK)
From: Vitaly Chikunov <vt@altlinux.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Vitaly Chikunov <vt@altlinux.org>,
	Kees Cook <keescook@chromium.org>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1.y] cifs: Convert struct fealist away from 1-element array
Date: Sun, 18 Feb 2024 14:15:38 +0300
Message-ID: <20240218111538.2592901-1-vt@altlinux.org>
X-Mailer: git-send-email 2.42.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

commit 398d5843c03261a2b68730f2f00643826bcec6ba upstream.

The kernel is globally removing the ambiguous 0-length and 1-element
arrays in favor of flexible arrays, so that we can gain both compile-time
and run-time array bounds checking[1].

While struct fealist is defined as a "fake" flexible array (via a
1-element array), it is only used for examination of the first array
element. Walking the list is performed separately, so there is no reason
to treat the "list" member of struct fealist as anything other than a
single entry. Adjust the struct and code to match.

Additionally, struct fea uses the "name" member either as a dynamic
string, or is manually calculated from the start of the struct. Redefine
the member as a flexible array.

No machine code output differences are produced after these changes.

[1] For lots of details, see both:
    https://docs.kernel.org/process/deprecated.html#zero-length-and-one-element-arrays
    https://people.kernel.org/kees/bounded-flexible-arrays-in-c

Cc: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@cjr.nz>
Cc: Ronnie Sahlberg <lsahlber@redhat.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ vt: Tested to not break build on x86_64 over v6.1.78. Bug report at [1]. ]
Link: https://lore.kernel.org/all/qjyfz2xftsbch6aozgplxyjfyqnuhn7j44udrucls4pqa5ey35@adxvvrdtagqf/
Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
---
 fs/smb/client/cifspdu.h |  4 ++--
 fs/smb/client/cifssmb.c | 16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 97bb1838555b..96ed0a4a2ce2 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -2593,7 +2593,7 @@ struct fea {
 	unsigned char EA_flags;
 	__u8 name_len;
 	__le16 value_len;
-	char name[1];
+	char name[];
 	/* optionally followed by value */
 } __attribute__((packed));
 /* flags for _FEA.fEA */
@@ -2601,7 +2601,7 @@ struct fea {
 
 struct fealist {
 	__le32 list_len;
-	struct fea list[1];
+	struct fea list;
 } __attribute__((packed));
 
 /* used to hold an arbitrary blob of data */
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 67c5fc2b2db9..784fc5ba2c44 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -5697,7 +5697,7 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/* account for ea list len */
 	list_len -= 4;
-	temp_fea = ea_response_data->list;
+	temp_fea = &ea_response_data->list;
 	temp_ptr = (char *)temp_fea;
 	while (list_len > 0) {
 		unsigned int name_len;
@@ -5812,7 +5812,7 @@ CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 	else
 		name_len = strnlen(ea_name, 255);
 
-	count = sizeof(*parm_data) + ea_value_len + name_len;
+	count = sizeof(*parm_data) + 1 + ea_value_len + name_len;
 	pSMB->MaxParameterCount = cpu_to_le16(2);
 	/* BB find max SMB PDU from sess */
 	pSMB->MaxDataCount = cpu_to_le16(1000);
@@ -5836,14 +5836,14 @@ CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 	byte_count = 3 /* pad */  + params + count;
 	pSMB->DataCount = cpu_to_le16(count);
 	parm_data->list_len = cpu_to_le32(count);
-	parm_data->list[0].EA_flags = 0;
+	parm_data->list.EA_flags = 0;
 	/* we checked above that name len is less than 255 */
-	parm_data->list[0].name_len = (__u8)name_len;
+	parm_data->list.name_len = (__u8)name_len;
 	/* EA names are always ASCII */
 	if (ea_name)
-		strncpy(parm_data->list[0].name, ea_name, name_len);
-	parm_data->list[0].name[name_len] = 0;
-	parm_data->list[0].value_len = cpu_to_le16(ea_value_len);
+		strncpy(parm_data->list.name, ea_name, name_len);
+	parm_data->list.name[name_len] = '\0';
+	parm_data->list.value_len = cpu_to_le16(ea_value_len);
 	/* caller ensures that ea_value_len is less than 64K but
 	we need to ensure that it fits within the smb */
 
@@ -5851,7 +5851,7 @@ CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 	     negotiated SMB buffer size BB */
 	/* if (ea_value_len > buffer_size - 512 (enough for header)) */
 	if (ea_value_len)
-		memcpy(parm_data->list[0].name+name_len+1,
+		memcpy(parm_data->list.name + name_len + 1,
 		       ea_value, ea_value_len);
 
 	pSMB->TotalDataCount = pSMB->DataCount;
-- 
2.42.1

