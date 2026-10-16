Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.187.6.220])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFF5A2FE042
	for <linux-cifs@vger.kernel.org>; Fri, 16 Oct 2026 07:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.187.6.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792134700; cv=none; b=JIC+pg0Q3Qvj0Z9FvtbT4CK33XEjPEEDYZ+y2CqcR25l0KRIUKWhHPvhzVjKetjaGEEUccm4MFLWNutn7JYVmLrOT3E4XgdTUaL3KqQw02zPTvMcozjpGMQUlPYqz7cVFV9mjE+3pRz0dBzV9Kg4zJK8eqM76FyOiWYWOaUKlmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792134700; c=relaxed/simple;
	bh=IxnozIHw9vEoDcWWde7eDrq5mbWBI0Dh7wL3Y5E2B40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYqY6K0eEWURaLnQ9wuthC2csSkCfnRcEVY65P+Hn3IWKTWWyfAHCfcEym350yh1CSAh0wrm3rv75XWsXZoMzS+ywY84C+8C5SPWkR+9l8tkHp2SkIeZnt3mgL8r1xqrhJ3nWyYBUdARsbwwqW+Y9gzpPOBTT+ZCOwyYn0SpwvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=52.187.6.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [219.141.235.82])
	by app1 (Coremail) with SMTP id ygmowACHqMIJztFq5utlAg--.20812S3;
	Fri, 16 Oct 2026 15:11:07 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	smfrench@gmail.com,
	jlayton@kernel.org,
	bird@lzu.edu.cn,
	rakukuip@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH v2 1/1] cifs: fix buffer overflow in SMB2_tcon
Date: Fri, 16 Oct 2026 15:11:01 +0800
Message-ID: <20261016071101.1800770-2-n05ec@lzu.edu.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261016071101.1800770-1-n05ec@lzu.edu.cn>
References: <20261016071101.1800770-1-n05ec@lzu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowACHqMIJztFq5utlAg--.20812S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWrWDuF1rtw4ftr1ktFW8WFg_yoW5Gw15pr
	W3tFyqgF90qw1Svw4DtFyFgas8Ca1kJF1UGwsrJw47uwn3Ja1xZ34qkr1qvr93Aw40qryj
	9ryDtayFgF45uaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBI1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
	z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
	6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r1q6r43MxkIecxEwVAFwVW8CwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7
	Cv6cx26r4rMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2Iq
	xVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42
	IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY
	6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aV
	CY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbS_M3UUUUU==
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQsCCWrRf7gHLgAAsU

From: Luxiao Xu <rakukuip@gmail.com>

In SMB2_tcon(), unc_path is allocated with a fixed buffer size of
MAX_SHARENAME_LENGTH * 2 bytes (672 bytes). However, the user-controlled
UNC path (tree) length is passed to cifs_strtoUTF16(), which assumes the
destination buffer is large enough and writes strlen(tree) + 1 UTF-16 code
units.

Commit 62a1a439e0fd ("cifs: clean up handling of unc= option") removed the
length check on UNC mount options, allowing mount paths to exceed
MAX_SHARENAME_LENGTH while retaining the fixed-size buffer allocation in
SMB2_tcon(). Consequently, an oversized UNC string causes cifs_strtoUTF16()
to write past the end of the heap object, resulting in a slab-out-of-bounds
write. Furthermore, if a tree exceeds MAX_TREE_SIZE characters, strscpy()
truncates it in cifs_tcon::tree_name, causing subsequent reconnects or
failovers to fail.

Fix this by first verifying that the length of tree does not exceed
MAX_TREE_SIZE, returning -EINVAL if it does. Then, dynamically allocate
unc_path based on the length of tree so that it safely accommodates all
UTF-16 code units for paths within MAX_TREE_SIZE.

Fixes: 62a1a439e0fd ("cifs: clean up handling of unc= option")
Cc: stable@vger.kernel.org
Reported-by: Xin Liu <bird@lzu.edu.cn>
Closes: https://bugtracker.nebusec.ai/f/3292
Assisted-by: LLM
Suggested-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
v1 -> v2:
 - Validate tree length against MAX_TREE_SIZE, log an error message
   via cifs_server_dbg(VFS, ...), and return -EINVAL to avoid
   truncating tree_name across reconnects (per Paulo Alcantara).
 - Keep dynamic allocation of unc_path for trees within MAX_TREE_SIZE.
 - v1 Link: https://lore.kernel.org/all/cover.1791865501.git.rakukuip@gmail.com/

 fs/smb/client/smb2pdu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index cfe3c4b4abe7..03050921804f 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2150,7 +2150,12 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	if (!server || !tree)
 		return smb_EIO(smb_eio_trace_null_pointers);
 
-	unc_path = kmalloc(MAX_SHARENAME_LENGTH * 2, GFP_KERNEL);
+	if (strlen(tree) > MAX_TREE_SIZE) {
+		cifs_server_dbg(VFS, "%s: tree name too long\n", __func__);
+		return -EINVAL;
+	}
+
+	unc_path = kmalloc((strlen(tree) + 1) * 2, GFP_KERNEL);
 	if (unc_path == NULL)
 		return -ENOMEM;
 
-- 
2.43.0

