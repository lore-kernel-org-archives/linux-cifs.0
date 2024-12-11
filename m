Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A6D1D89F5;
	Wed, 11 Dec 2024 09:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907755; cv=none; b=DfBVWJSe2DsV8vuU1By+mOmRlhzhiDDTKho7RoTQQNUqgfuoWMyGQKB8uwLsKPfuHfVs0B4tFLV3NfbGkyBgZKyRB13A8zNBSJFChhUAgPJsa9cVjhOJ4neDwAeLFt+CLD6FYEptxnqa/PTF7HNsP43NeVwhEV2/45ZfbTamQ88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907755; c=relaxed/simple;
	bh=kVo6a6DxVmOCyCoM54sp8e3Cs5dhcsi76qwqIuAEqeg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LADUqgPSt0NmEilCthAbAE8AxLRlMDNaZaMTS8MbE6+64N+Ve6wWlzEg1AmBuc2jvlwqSyFJs4EtXEWR14V5Khds/L2TFonSveeci1mUP3Ct9nL3rh5echiver0t8dQMypxlFkjjR3TAsiHVKTf+Tz4Ay0z4L/ja2iDSPffy2/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BB5x2FA012144;
	Wed, 11 Dec 2024 09:02:01 GMT
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 43cx4xby0q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 11 Dec 2024 09:02:00 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Wed, 11 Dec 2024 01:01:59 -0800
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Wed, 11 Dec 2024 01:01:56 -0800
From: <jianqi.ren.cn@windriver.com>
To: <pc@manguebit.com>, <gregkh@linuxfoundation.org>
CC: <stfrench@microsoft.com>, <stable@vger.kernel.org>, <sfrench@samba.org>,
        <pc@cjr.nz>, <lsahlber@redhat.com>, <sprasad@microsoft.com>,
        <tom@talpey.com>, <linux-cifs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <samba-technical@lists.samba.org>
Subject: [PATCH 6.1.y] smb: client: fix potential UAF in cifs_dump_full_key()
Date: Wed, 11 Dec 2024 17:59:50 +0800
Message-ID: <20241211095950.2069548-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: hV0_1fjkQGckBZqL0vkKdYPHkPWW26Zm
X-Proofpoint-ORIG-GUID: hV0_1fjkQGckBZqL0vkKdYPHkPWW26Zm
X-Authority-Analysis: v=2.4 cv=Y/UCsgeN c=1 sm=1 tr=0 ts=67595508 cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=RZcAm9yDv7YA:10 a=Li1AiuEPAAAA:8 a=VwQbUJbxAAAA:8 a=yMhMjlubAAAA:8 a=t7CeM3EgAAAA:8 a=1_rInJw21EjIxf1COpsA:9
 a=qGKPP_lnpMOaqR3bcYHU:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-11_08,2024-12-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 clxscore=1011 malwarescore=0 priorityscore=1501
 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 classifier=spam authscore=0 adjust=0 reason=mlx
 scancount=1 engine=8.21.0-2411120000 definitions=main-2412110067

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 58acd1f497162e7d282077f816faa519487be045 ]

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
---
 fs/smb/client/ioctl.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index ae9905e2b9d4..7402070b7a06 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -246,7 +246,9 @@ static int cifs_dump_full_key(struct cifs_tcon *tcon, struct smb3_full_key_debug
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
@@ -254,9 +256,11 @@ static int cifs_dump_full_key(struct cifs_tcon *tcon, struct smb3_full_key_debug
 					 * so increment its refcount
 					 */
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

