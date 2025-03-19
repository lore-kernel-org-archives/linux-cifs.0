Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA71524F;
	Wed, 19 Mar 2025 03:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742353355; cv=none; b=P6rCECVXwJLqxHwtD6S4xY5Na5NVeEv9CKTAqzpl2snkh3Q2v9zb8IszOsPQlzm2p/Me7mAX/pUxZxe/Lf3//opCc00hb8QrJxQNUtkawFXjPihWrZuj08zAQDz1bW0mDcRvVWRGzz7dYAsL2rL9+m3hVuGFLVjKfKdCNTtf5v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742353355; c=relaxed/simple;
	bh=73sJN9RX4iQ9NGIl0uW9R3rvI9b1tby7yCaJMySlhX8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SjC732YH00tfVZaTSLEjwoZReIlSUoNO13ieAa/WvojSBqOpz8dAXY+Q4dwyB2eHUA2w60oBMA5Rq2FQhepV7HxXYMdu7Ay7PHT3xRWVCzf0hbGUqJd9YR0f8+67lclYHmLk6Qvc0eVg5oeFvAg7QoOUzix9PnVqV6x/pnHYRDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52J1qtxJ005416;
	Tue, 18 Mar 2025 20:01:43 -0700
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 45d92jus4b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 18 Mar 2025 20:01:43 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Tue, 18 Mar 2025 20:01:43 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Tue, 18 Mar 2025 20:01:40 -0700
From: <jianqi.ren.cn@windriver.com>
To: <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <jianqi.ren.cn@windriver.com>,
        <sfrench@samba.org>, <linux-cifs@vger.kernel.org>,
        <samba-technical@lists.samba.org>, <pc@manguebit.com>,
        <stfrench@microsoft.com>
Subject: [PATCH 5.15.y] smb: client: fix potential UAF in cifs_debug_files_proc_show()
Date: Wed, 19 Mar 2025 11:01:39 +0800
Message-ID: <20250319030139.953922-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=QdRmvtbv c=1 sm=1 tr=0 ts=67da3397 cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=Vs1iUdzkB0EA:10 a=Li1AiuEPAAAA:8 a=VwQbUJbxAAAA:8 a=yMhMjlubAAAA:8 a=t7CeM3EgAAAA:8 a=F951-fjzzYaKpzs5SyQA:9
 a=qGKPP_lnpMOaqR3bcYHU:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: l-zFfN9MBIYO6W5Jpo0ILgYzr1VYOz2D
X-Proofpoint-GUID: l-zFfN9MBIYO6W5Jpo0ILgYzr1VYOz2D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-18_10,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=997 impostorscore=0
 mlxscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.21.0-2502280000
 definitions=main-2503190020

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit ca545b7f0823f19db0f1148d59bc5e1a56634502 ]

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[This patch removes lock/unlock operation in routine cifs_ses_exiting()
for ses_lock is not present in v5.15 and not ported yet. ses->status
is protected by a global lock, cifs_tcp_ses_lock, in v5.15.]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 fs/cifs/cifs_debug.c | 2 ++
 fs/cifs/cifsglob.h   | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index e7501533c2ec..8eb91bd18439 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -183,6 +183,8 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
 		list_for_each(tmp, &server->smb_ses_list) {
 			ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
+			if (cifs_ses_exiting(ses))
+				continue;
 			list_for_each(tmp1, &ses->tcon_list) {
 				tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
 				spin_lock(&tcon->open_file_lock);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 2ee67a27020d..7b57cc5d7022 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -2041,4 +2041,12 @@ static inline struct scatterlist *cifs_sg_set_buf(struct scatterlist *sg,
 	return sg;
 }
 
+static inline bool cifs_ses_exiting(struct cifs_ses *ses)
+{
+	bool ret;
+
+	ret = ses->status == CifsExiting;
+	return ret;
+}
+
 #endif	/* _CIFS_GLOB_H */
-- 
2.25.1

