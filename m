Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57B61DFF0;
	Wed, 16 Apr 2025 01:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744765420; cv=none; b=Vlnnioja1bESKgNBKGE0XWtDxjKhLKZy1dJwGR0PIMXE4HUmU0b1DWDC3/zetBYAayazIv/j7dvnrN/M3XwxxwUczXPxr1xxNAdiZ3ONjWjD7Koc40vhcHoDHps3+MxZ30Lnrkq/veJWAMPhnIep+IXe+aNoPlrYWsJw+4xFdYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744765420; c=relaxed/simple;
	bh=lxyuH2X+QrN69sG9sxQAyhR4CnxidVuoSmTUqIuey+8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JpC81mbWV6muCEXnS/fhWqXIfSovR5Trw7H5RLCFM+qP5G+WZ51hXSmt/c5P7TCgW68EQEDti3avrNwVO3x/nuPJpKtOP3RV+1mTqUdkPBkjFK3aVInrxm6bKSu1lkJCK5jMoJ2tFFaIwvmZOykD3yftXdt+EYYZXPL7r7Wm3QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53FLTtJh026884;
	Tue, 15 Apr 2025 18:02:57 -0700
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 45ykf3m1nq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 15 Apr 2025 18:02:56 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Tue, 15 Apr 2025 18:02:56 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Tue, 15 Apr 2025 18:02:53 -0700
From: <jianqi.ren.cn@windriver.com>
To: <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <jianqi.ren.cn@windriver.com>,
        <chenxiaosong@kylinos.cn>, <stfrench@microsoft.com>,
        <linkinjeon@kernel.org>, <sfrench@samba.org>,
        <senozhatsky@chromium.org>, <tom@talpey.com>,
        <linux-cifs@vger.kernel.org>
Subject: [PATCH 6.1.y] smb/server: fix potential null-ptr-deref of lease_ctx_info in smb2_open()
Date: Wed, 16 Apr 2025 09:02:52 +0800
Message-ID: <20250416010252.388173-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: EcdEvtXe86mEZEQLPT-ZqLkngM1F3jhd
X-Authority-Analysis: v=2.4 cv=Wd0Ma1hX c=1 sm=1 tr=0 ts=67ff01c0 cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=XR8D0OoHHMoA:10 a=yMhMjlubAAAA:8 a=t7CeM3EgAAAA:8 a=4MEYoKLddpgQIFStAo8A:9 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: EcdEvtXe86mEZEQLPT-ZqLkngM1F3jhd
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-15_09,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 clxscore=1011
 impostorscore=0 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2502280000
 definitions=main-2504160006

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 4e8771a3666c8f216eefd6bd2fd50121c6c437db ]

null-ptr-deref will occur when (req_op_level == SMB2_OPLOCK_LEVEL_LEASE)
and parse_lease_state() return NULL.

Fix this by check if 'lease_ctx_info' is NULL.

Additionally, remove the redundant parentheses in
parse_durable_handle_context().

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
[Drop the parentheses clean-up since the parentheses was introduced by
c8efcc786146 ("ksmbd: add support for durable handles v1/v2") in v6.9
 Minor context change fixed]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 fs/smb/server/oplock.c  | 2 +-
 fs/smb/server/smb2pdu.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index a3c016a11e27..2fcfabc35b06 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1515,7 +1515,7 @@ void create_lease_buf(u8 *rbuf, struct lease *lease)
  * @open_req:	buffer containing smb2 file open(create) request
  * @is_dir:	whether leasing file is directory
  *
- * Return:  oplock state, -ENOENT if create lease context not found
+ * Return: allocated lease context object on success, otherwise NULL
  */
 struct lease_ctx_info *parse_lease_state(void *open_req, bool is_dir)
 {
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index dbe272970c25..937c1cd2284e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3241,7 +3241,7 @@ int smb2_open(struct ksmbd_work *work)
 			goto err_out1;
 		}
 	} else {
-		if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE) {
+		if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE && lc) {
 			/*
 			 * Compare parent lease using parent key. If there is no
 			 * a lease that has same parent key, Send lease break
-- 
2.34.1

