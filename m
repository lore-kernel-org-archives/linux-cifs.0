Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5211547E0;
	Mon,  9 Dec 2024 03:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733716665; cv=none; b=QicVSaA2xL97oo/HOQJiGLVazapEJ2kGLF7sOc7K7VmzoJAdEF+aXfT8HshJy0E2zdWMsZ36/ZgMmMt+BvVv+1cc7tPse+foj33H0MRezg2gYG1mOPsn1pPzKVqQR3QwAQA63iYaWXQ1+BJRzBXWUkjiOX0XLng+iIkkSYCeFis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733716665; c=relaxed/simple;
	bh=09hEUddsuybwb/3hgJNYu8Cbem4ayci3fV2D5RZd7gw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aVrlUSfuNW8C3sdyVbopFz6WiU4ypLk8eDo+1wzONR/v2osBwGYVhOmV94i8FSnAZ1vM4yyAAxjMDrWVzNNNS3cFUJ5V/oxu+ftyQS9mxAN9FRCHEVD7QtlcnVJW7SXoCYxLUwiseqHHVrCVFKcXnRwNPZovFkMAI3sUuGzkpi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B93J35X010788;
	Mon, 9 Dec 2024 03:24:56 GMT
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 43cwy3gx3r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 09 Dec 2024 03:24:56 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Sun, 8 Dec 2024 19:24:55 -0800
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Sun, 8 Dec 2024 19:24:52 -0800
From: <jianqi.ren.cn@windriver.com>
To: <pc@manguebit.com>, <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <sfrench@samba.org>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>,
        <linux-cifs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <samba-technical@lists.samba.org>
Subject: [PATCH 6.1.y] smb: client: fix potential UAF in cifs_dump_full_key()
Date: Mon, 9 Dec 2024 12:22:44 +0800
Message-ID: <20241209042244.3426179-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: WbkC3adcDjBeNNp58r9eAc7T7Y7aK3Fp
X-Proofpoint-ORIG-GUID: WbkC3adcDjBeNNp58r9eAc7T7Y7aK3Fp
X-Authority-Analysis: v=2.4 cv=D7O9KuRj c=1 sm=1 tr=0 ts=67566308 cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=RZcAm9yDv7YA:10 a=Li1AiuEPAAAA:8 a=VwQbUJbxAAAA:8 a=yMhMjlubAAAA:8 a=t7CeM3EgAAAA:8 a=1_rInJw21EjIxf1COpsA:9
 a=qGKPP_lnpMOaqR3bcYHU:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-08_11,2024-12-06_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 mlxscore=0 impostorscore=0 phishscore=0
 clxscore=1011 classifier=spam authscore=0 adjust=0 reason=mlx scancount=1
 engine=8.21.0-2411120000 definitions=main-2412090026

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 58acd1f497162e7d282077f816faa519487be045 ]

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
---
 fs/smb/client/ioctl.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index ae9905e2b9d4..173c8c76d31f 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -246,17 +246,23 @@ static int cifs_dump_full_key(struct cifs_tcon *tcon, struct smb3_full_key_debug
 		spin_lock(&cifs_tcp_ses_lock);
 		list_for_each_entry(server_it, &cifs_tcp_ses_list, tcp_ses_list) {
 			list_for_each_entry(ses_it, &server_it->smb_ses_list, smb_ses_list) {
-				if (ses_it->Suid == out.session_id) {
+				spin_lock(&ses_it->ses_lock);
+				if (ses_it->ses_status != SES_EXITING &&
+				    ses_it->Suid == out.session_id) {
 					ses = ses_it;
 					/*
 					 * since we are using the session outside the crit
 					 * section, we need to make sure it won't be released
 					 * so increment its refcount
 					 */
+
+					lockdep_assert_held(&cifs_tcp_ses_lock);
 					ses->ses_count++;
+					spin_unlock(&ses_it->ses_lock);
 					found = true;
 					goto search_end;
 				}
+				spin_unlock(&ses_it->ses_lock);
 			}
 		}
 search_end:
-- 
2.25.1

