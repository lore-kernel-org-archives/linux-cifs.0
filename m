Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F7C2505C3;
	Mon, 24 Mar 2025 07:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742800467; cv=none; b=o/jjqLZXEtGfrvoxfb9syQft+rKTCNvxrZf4f0L2prktti9yUXLsrBg3oxjce1MZEe63DlA71kuSecGv8xJdkF/O3lfZjsT/9Fl6lKWsTpP3vRz+nqyKt6u+09uNqyMoHsMVqJseKdDjYLPoxzA6iQs6pGdk50acKAXxQhJ/6AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742800467; c=relaxed/simple;
	bh=kEBFPGNKRmD867OotAxEjTRBog9XzrLq+S+e6KpyV3U=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uurmA8ZGcCcqyPGtl+xSQSklkqSoOKAdO4Dnk+m3bPHl7VIknf4zwksUfTtwXzFviHBko+lhYBOUTCLbAUU+dWMMvRVyueWwLplyOiwoQZlK2hqBPxWJ+ugt0eFdDSRh+m7JxPeBtyLbauL6QPfXIEWoT+OuJ7JKQVgVY5nvFpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52O60OU9018528;
	Mon, 24 Mar 2025 00:13:32 -0700
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 45hrg41m8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 24 Mar 2025 00:13:32 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Mon, 24 Mar 2025 00:13:31 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Mon, 24 Mar 2025 00:13:29 -0700
From: <jianqi.ren.cn@windriver.com>
To: <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <jianqi.ren.cn@windriver.com>,
        <sfrench@samba.org>, <linux-cifs@vger.kernel.org>,
        <samba-technical@lists.samba.org>, <pc@manguebit.com>,
        <stfrench@microsoft.com>
Subject: [PATCH 5.10.y] smb: client: fix potential UAF in cifs_debug_files_proc_show()
Date: Mon, 24 Mar 2025 15:13:28 +0800
Message-ID: <20250324071328.3796049-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=HZwUTjE8 c=1 sm=1 tr=0 ts=67e1061c cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=Vs1iUdzkB0EA:10 a=Li1AiuEPAAAA:8 a=VwQbUJbxAAAA:8 a=yMhMjlubAAAA:8 a=t7CeM3EgAAAA:8 a=F951-fjzzYaKpzs5SyQA:9
 a=qGKPP_lnpMOaqR3bcYHU:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: cr_-suQoDhQQRyiZKq9F-V8BUXZ247Th
X-Proofpoint-ORIG-GUID: cr_-suQoDhQQRyiZKq9F-V8BUXZ247Th
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-24_03,2025-03-21_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 phishscore=0 malwarescore=0 adultscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501
 mlxlogscore=995 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2502280000
 definitions=main-2503240051

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit ca545b7f0823f19db0f1148d59bc5e1a56634502 ]

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[This patch removes lock/unlock operation in routine cifs_ses_exiting()
for ses_lock is not present in v5.10 and not ported yet. ses->status
is protected by a global lock, cifs_tcp_ses_lock, in v5.10.]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 fs/cifs/cifs_debug.c | 2 ++
 fs/cifs/cifsglob.h   | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 53588d7517b4..8b88b0705481 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -183,6 +183,8 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 				    tcp_ses_list);
 		list_for_each(tmp, &server->smb_ses_list) {
 			ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
+			if (cifs_ses_exiting(ses))
+				continue;
 			list_for_each(tmp1, &ses->tcon_list) {
 				tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
 				spin_lock(&tcon->open_file_lock);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 92a7628560cc..b4aa7cd3a914 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -2115,4 +2115,12 @@ static inline struct scatterlist *cifs_sg_set_buf(struct scatterlist *sg,
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

