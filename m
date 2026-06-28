Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.75.44.102])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6FD6221FCD
	for <linux-cifs@vger.kernel.org>; Sun, 28 Jun 2026 09:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.75.44.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782638442; cv=none; b=TsRJja+sTlFBvVzj1TwCmE3E4SPQTlrToEH4/3ahTn4gctH7jGnrNbgrH9PfYVk3VALXhafMaQnYJ0oY6GhJ7u1wqGPhAeUNb9oswdwmxuOXbDdrSlokfegCIn6AyaHH98abffIb4Zo/xhb+9gADuEwEkhebFKhcEr+et9wfyVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782638442; c=relaxed/simple;
	bh=WSznJapsT0ykGfpe19Q4PHH+VlxCzN/+fhZ9ucslV0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlOHeT2r/IJ3e+3rl1zED+2qvyd4r6d1yyPzIatSMrG3VfFRhSmdO/v3N8BmwUrhqgx2ZetURkJrwy+lbDJk2TZsZwAOjzX3CDFeJcQsF7BVXA5Sw55JBOiDm18Yibe1IubBYoac2pYNEe0nsD6f65k9XRXUwo6bK8EFMkaFu6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=13.75.44.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowAC31L4t50BqTo2+AA--.53613S3;
	Sun, 28 Jun 2026 17:19:46 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: sfrench@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	pshilov@microsoft.com,
	aaptel@suse.com,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	xizh2024@lzu.edu.cn,
	n05ec@lzu.edu.cn
Subject: [PATCH 1/2] smb: client: fix create context out-of-bounds reads
Date: Sun, 28 Jun 2026 17:19:23 +0800
Message-ID: <eb1bc35611f91bd10a4772400b37fac26f660956.1782579150.git.xizh2024@lzu.edu.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1782579149.git.xizh2024@lzu.edu.cn>
References: <cover.1782579149.git.xizh2024@lzu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowAC31L4t50BqTo2+AA--.53613S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZw4UJr4UAw1kJr4fXFykuFg_yoW5WF4xpF
	W7Gr15CrZ3Jr1ayF9Yy3Wjga4ftrykJa1DKrZ3t3Z3tFnavr1ruwn8KrnFvrnYkay8Gr40
	9r45tF1IgFWYkFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
	87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
	Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_Jw0_GFylc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY2
	0_Gr4l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQsMCWpA2VUAkwAAs6

From: Zihan Xi <xizh2024@lzu.edu.cn>

smb2_parse_contexts() validates generic create-context layout but does
not ensure each handler's minimum size before parsing. A malicious
server can supply a truncated QFid (Query On Disk ID) context with
DataLength zero; parse_query_id_ctxt() then reads fixed offsets past
the context boundary and triggers a slab out-of-bounds read.

Bound each context by its Next field and reject lease, QFid, and POSIX
contexts that are shorter than their parsers require.

Fixes: 89a5bfa350fa ("smb3: optimize open to not send query file internal info")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zihan Xi <xizh2024@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 fs/smb/client/smb2pdu.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 3bd300347f16..840bc81718da 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2405,6 +2405,7 @@ int smb2_parse_contexts(struct TCP_Server_Info *server,
 	struct smb2_create_rsp *rsp = rsp_iov->iov_base;
 	struct create_context *cc;
 	size_t rem, off, len;
+	size_t cc_len;
 	size_t doff, dlen;
 	size_t noff, nlen;
 	char *name;
@@ -2427,9 +2428,18 @@ int smb2_parse_contexts(struct TCP_Server_Info *server,
 		buf->IndexNumber = 0;
 
 	while (rem >= sizeof(*cc)) {
+		off = le32_to_cpu(cc->Next);
+		if (off) {
+			if ((off & 0x7) || off > rem)
+				return -EINVAL;
+			cc_len = off;
+		} else {
+			cc_len = rem;
+		}
+
 		doff = le16_to_cpu(cc->DataOffset);
 		dlen = le32_to_cpu(cc->DataLength);
-		if (check_add_overflow(doff, dlen, &len) || len > rem)
+		if (check_add_overflow(doff, dlen, &len) || len > cc_len)
 			return -EINVAL;
 
 		noff = le16_to_cpu(cc->NameOffset);
@@ -2441,16 +2451,23 @@ int smb2_parse_contexts(struct TCP_Server_Info *server,
 		switch (nlen) {
 		case 4:
 			if (!strncmp(name, SMB2_CREATE_REQUEST_LEASE, 4)) {
+				if (cc_len < server->vals->create_lease_size)
+					return -EINVAL;
 				*oplock = server->ops->parse_lease_buf(cc, epoch,
 								       lease_key);
 			} else if (buf &&
 				   !strncmp(name, SMB2_CREATE_QUERY_ON_DISK_ID, 4)) {
+				if (cc_len < sizeof(struct create_disk_id_rsp))
+					return -EINVAL;
 				parse_query_id_ctxt(cc, buf);
 			}
 			break;
 		case 16:
-			if (posix && !memcmp(name, smb3_create_tag_posix, 16))
+			if (posix && !memcmp(name, smb3_create_tag_posix, 16)) {
+				if (dlen < 3 * sizeof(__le32) + MIN_SID_LEN + 2)
+					return -EINVAL;
 				parse_posix_ctxt(cc, buf, posix);
+			}
 			break;
 		default:
 			cifs_dbg(FYI, "%s: unhandled context (nlen=%zu dlen=%zu)\n",
-- 
2.43.0

