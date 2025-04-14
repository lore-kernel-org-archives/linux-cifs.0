Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2098510F9;
	Mon, 14 Apr 2025 08:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744621154; cv=none; b=KgQ+OHn4UWciR+vQaZXxbrdQFv1h1/6GkekGCq3X3b60F16zSOfFVfrRogCwRxXpECK9+p/n8fQmPsDmK8PP/xu6Zjde5DQb7m9iCHNVnugknj07n9I7FuSdiCzIAjDtj+Af7gr7zKcPeUgGCSvUHH4B3Q8M+5sllMzY7Ok4Taw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744621154; c=relaxed/simple;
	bh=679JyxtqUTtjXOCtuELbbzQlbnCOHolevxYOM+wI9WM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lBKXb3UxpV5qMNZLhUe/uKCoMc1fd8AY4FJkAn00jb2iPz/rgHbW6fx5bTIkNyGevd4XQcc0+8B8xEwl9QcqvG/aKcTKTUc+daEKUZhAUPAVvClkwgpocfkT18rErFxgV+ZHXCtC2ZjCUess7Yw7BwOWFX+ASUfrnuRsuPLZF+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53E5KVxg026809;
	Mon, 14 Apr 2025 08:58:21 GMT
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 45ydd1hup2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 14 Apr 2025 08:58:21 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Mon, 14 Apr 2025 01:58:20 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Mon, 14 Apr 2025 01:58:17 -0700
From: <jianqi.ren.cn@windriver.com>
To: <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <jianqi.ren.cn@windriver.com>,
        <ematsumiya@suse.de>, <stfrench@microsoft.com>, <sfrench@samba.org>,
        <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>
Subject: [PATCH 5.15.y 1/2] smb: client: fix UAF in async decryption
Date: Mon, 14 Apr 2025 16:58:16 +0800
Message-ID: <20250414085816.1631807-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 4x5p8KcGYi6M9WbulcPqMSRP6arYfMyV
X-Proofpoint-GUID: 4x5p8KcGYi6M9WbulcPqMSRP6arYfMyV
X-Authority-Analysis: v=2.4 cv=HecUTjE8 c=1 sm=1 tr=0 ts=67fcce2d cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=XR8D0OoHHMoA:10 a=ID6ng7r3AAAA:8 a=yMhMjlubAAAA:8 a=t7CeM3EgAAAA:8 a=DEdtFxlGgKspwUSy9V0A:9 a=AkheI1RvQwOzcTXhi5f4:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-14_02,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 priorityscore=1501 spamscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 impostorscore=0 suspectscore=0 clxscore=1011
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.21.0-2502280000
 definitions=main-2504140064

From: Enzo Matsumiya <ematsumiya@suse.de>

commit b0abcd65ec545701b8793e12bc27dc98042b151a upstream.

Doing an async decryption (large read) crashes with a
slab-use-after-free way down in the crypto API.

Reproducer:
    # mount.cifs -o ...,seal,esize=1 //srv/share /mnt
    # dd if=/mnt/largefile of=/dev/null
    ...
    [  194.196391] ==================================================================
    [  194.196844] BUG: KASAN: slab-use-after-free in gf128mul_4k_lle+0xc1/0x110
    [  194.197269] Read of size 8 at addr ffff888112bd0448 by task kworker/u77:2/899
    [  194.197707]
    [  194.197818] CPU: 12 UID: 0 PID: 899 Comm: kworker/u77:2 Not tainted 6.11.0-lku-00028-gfca3ca14a17a-dirty #43
    [  194.198400] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.2-3-gd478f380-prebuilt.qemu.org 04/01/2014
    [  194.199046] Workqueue: smb3decryptd smb2_decrypt_offload [cifs]
    [  194.200032] Call Trace:
    [  194.200191]  <TASK>
    [  194.200327]  dump_stack_lvl+0x4e/0x70
    [  194.200558]  ? gf128mul_4k_lle+0xc1/0x110
    [  194.200809]  print_report+0x174/0x505
    [  194.201040]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
    [  194.201352]  ? srso_return_thunk+0x5/0x5f
    [  194.201604]  ? __virt_addr_valid+0xdf/0x1c0
    [  194.201868]  ? gf128mul_4k_lle+0xc1/0x110
    [  194.202128]  kasan_report+0xc8/0x150
    [  194.202361]  ? gf128mul_4k_lle+0xc1/0x110
    [  194.202616]  gf128mul_4k_lle+0xc1/0x110
    [  194.202863]  ghash_update+0x184/0x210
    [  194.203103]  shash_ahash_update+0x184/0x2a0
    [  194.203377]  ? __pfx_shash_ahash_update+0x10/0x10
    [  194.203651]  ? srso_return_thunk+0x5/0x5f
    [  194.203877]  ? crypto_gcm_init_common+0x1ba/0x340
    [  194.204142]  gcm_hash_assoc_remain_continue+0x10a/0x140
    [  194.204434]  crypt_message+0xec1/0x10a0 [cifs]
    [  194.206489]  ? __pfx_crypt_message+0x10/0x10 [cifs]
    [  194.208507]  ? srso_return_thunk+0x5/0x5f
    [  194.209205]  ? srso_return_thunk+0x5/0x5f
    [  194.209925]  ? srso_return_thunk+0x5/0x5f
    [  194.210443]  ? srso_return_thunk+0x5/0x5f
    [  194.211037]  decrypt_raw_data+0x15f/0x250 [cifs]
    [  194.212906]  ? __pfx_decrypt_raw_data+0x10/0x10 [cifs]
    [  194.214670]  ? srso_return_thunk+0x5/0x5f
    [  194.215193]  smb2_decrypt_offload+0x12a/0x6c0 [cifs]

This is because TFM is being used in parallel.

Fix this by allocating a new AEAD TFM for async decryption, but keep
the existing one for synchronous READ cases (similar to what is done
in smb3_calc_signature()).

Also remove the calls to aead_request_set_callback() and
crypto_wait_req() since it's always going to be a synchronous operation.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
[In linux-5.15, dec and enc fields are named ccmaesdecrypt and ccmaesencrypt.]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 fs/cifs/smb2ops.c | 48 +++++++++++++++++++++++++++--------------------
 fs/cifs/smb2pdu.c |  6 ++++++
 2 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 7bce1ab86c4d..da9305f0b6f5 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4541,7 +4541,7 @@ smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc, u8 *key)
  */
 static int
 crypt_message(struct TCP_Server_Info *server, int num_rqst,
-	      struct smb_rqst *rqst, int enc)
+	      struct smb_rqst *rqst, int enc, struct crypto_aead *tfm)
 {
 	struct smb2_transform_hdr *tr_hdr =
 		(struct smb2_transform_hdr *)rqst[0].rq_iov[0].iov_base;
@@ -4552,8 +4552,6 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 	u8 key[SMB3_ENC_DEC_KEY_SIZE];
 	struct aead_request *req;
 	u8 *iv;
-	DECLARE_CRYPTO_WAIT(wait);
-	struct crypto_aead *tfm;
 	unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
 	void *creq;
 
@@ -4564,15 +4562,6 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 		return rc;
 	}
 
-	rc = smb3_crypto_aead_allocate(server);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: crypto alloc failed\n", __func__);
-		return rc;
-	}
-
-	tfm = enc ? server->secmech.ccmaesencrypt :
-						server->secmech.ccmaesdecrypt;
-
 	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||
 		(server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
 		rc = crypto_aead_setkey(tfm, key, SMB3_GCM256_CRYPTKEY_SIZE);
@@ -4611,11 +4600,7 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 	aead_request_set_crypt(req, sg, sg, crypt_len, iv);
 	aead_request_set_ad(req, assoc_data_len);
 
-	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				  crypto_req_done, &wait);
-
-	rc = crypto_wait_req(enc ? crypto_aead_encrypt(req)
-				: crypto_aead_decrypt(req), &wait);
+	rc = enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);
 
 	if (!rc && enc)
 		memcpy(&tr_hdr->Signature, sign, SMB2_SIGNATURE_SIZE);
@@ -4704,7 +4689,7 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
 	/* fill the 1st iov with a transform header */
 	fill_transform_hdr(tr_hdr, orig_len, old_rq, server->cipher_type);
 
-	rc = crypt_message(server, num_rqst, new_rq, 1);
+	rc = crypt_message(server, num_rqst, new_rq, 1, server->secmech.ccmaesencrypt);
 	cifs_dbg(FYI, "Encrypt message returned %d\n", rc);
 	if (rc)
 		goto err_free;
@@ -4730,8 +4715,9 @@ decrypt_raw_data(struct TCP_Server_Info *server, char *buf,
 		 unsigned int npages, unsigned int page_data_size,
 		 bool is_offloaded)
 {
-	struct kvec iov[2];
+	struct crypto_aead *tfm;
 	struct smb_rqst rqst = {NULL};
+	struct kvec iov[2];
 	int rc;
 
 	iov[0].iov_base = buf;
@@ -4746,9 +4732,31 @@ decrypt_raw_data(struct TCP_Server_Info *server, char *buf,
 	rqst.rq_pagesz = PAGE_SIZE;
 	rqst.rq_tailsz = (page_data_size % PAGE_SIZE) ? : PAGE_SIZE;
 
-	rc = crypt_message(server, 1, &rqst, 0);
+	if (is_offloaded) {
+		if ((server->cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
+		    (server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
+			tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
+		else
+			tfm = crypto_alloc_aead("ccm(aes)", 0, 0);
+		if (IS_ERR(tfm)) {
+			rc = PTR_ERR(tfm);
+			cifs_server_dbg(VFS, "%s: Failed alloc decrypt TFM, rc=%d\n", __func__, rc);
+
+			return rc;
+		}
+	} else {
+		if (unlikely(!server->secmech.ccmaesdecrypt))
+			return -EIO;
+
+		tfm = server->secmech.ccmaesdecrypt;
+	}
+
+	rc = crypt_message(server, 1, &rqst, 0, tfm);
 	cifs_dbg(FYI, "Decrypt message returned %d\n", rc);
 
+	if (is_offloaded)
+		crypto_free_aead(tfm);
+
 	if (rc)
 		return rc;
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index bd7aeb4dcacf..2b2c3330ba96 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1063,6 +1063,12 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 		else
 			cifs_server_dbg(VFS, "Missing expected negotiate contexts\n");
 	}
+
+	if (server->cipher_type && !rc) {
+		rc = smb3_crypto_aead_allocate(server);
+		if (rc)
+			cifs_server_dbg(VFS, "%s: crypto alloc failed, rc=%d\n", __func__, rc);
+	}
 neg_exit:
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
-- 
2.34.1

