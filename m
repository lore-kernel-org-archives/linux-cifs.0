Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8229224F599;
	Mon, 24 Mar 2025 07:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742800101; cv=none; b=dffSnVu9n8ObctKK/vNM29ZadXU0AK9ribNMEb9KW8CGIcK127OybTLMv2a7X73se/oRS6dBPQI8jRMRYUCxUkcrpPRX/CYJFPjGzO2M8nUa5sJb2OfnsgPWMKisLNGcsM/x957+ao7xKqIC7YWEjQ7sdKpJl1RR8gCPEO+GBkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742800101; c=relaxed/simple;
	bh=lT/G5ebUQsfhVTZGeDZJIGq6e6SHkR/ih9Do+8d01Tw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lFxBWXhUdfpqAYMTp5kFbuvK+6ZXJdEIf3Dm2REiK/hOuS8DO7KDplsINuBZ9EzvBlD6HkU+bRp1Ta6iwtqnu08V0eOotNEn3OgcngTjpbmdWrUEWVsdga15icxaQpzqZ1QkOcWwTpuwIt+L4jx/2DHRxWCxl4/hOqsgCMfWOlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52O5NIpn006164;
	Mon, 24 Mar 2025 07:07:30 GMT
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 45hje1htv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 24 Mar 2025 07:07:29 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Mon, 24 Mar 2025 00:07:28 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Mon, 24 Mar 2025 00:07:25 -0700
From: <jianqi.ren.cn@windriver.com>
To: <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <jianqi.ren.cn@windriver.com>,
        <sfrench@samba.org>, <linux-cifs@vger.kernel.org>,
        <samba-technical@lists.samba.org>, <pc@manguebit.com>,
        <stfrench@microsoft.com>
Subject: [PATCH 5.15.y] smb: client: fix potential UAF in cifs_dump_full_key()
Date: Mon, 24 Mar 2025 15:07:25 +0800
Message-ID: <20250324070725.3795964-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=KPVaDEFo c=1 sm=1 tr=0 ts=67e104b1 cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=Vs1iUdzkB0EA:10 a=Li1AiuEPAAAA:8 a=VwQbUJbxAAAA:8 a=yMhMjlubAAAA:8 a=t7CeM3EgAAAA:8 a=gpnyTqItCnq42K53HI0A:9
 a=qGKPP_lnpMOaqR3bcYHU:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: jWlaP7A7xVBIQgn3nbhROLKWb8Vbiv5J
X-Proofpoint-ORIG-GUID: jWlaP7A7xVBIQgn3nbhROLKWb8Vbiv5J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-24_03,2025-03-21_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 adultscore=0 impostorscore=0 mlxlogscore=971 malwarescore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2502280000
 definitions=main-2503240051

From: Paulo Alcantara <pc@manguebit.com>

commit 58acd1f497162e7d282077f816faa519487be045 upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[This patch removes lock/unlock operation in routine cifs_dump_full_key()
for ses_lock is not present in v5.15 and not ported yet. ses->status
is protected by a global lock, cifs_tcp_ses_lock, in v5.15.]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 fs/cifs/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 71883ba9e567..e846c18b71d2 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -232,7 +232,8 @@ static int cifs_dump_full_key(struct cifs_tcon *tcon, struct smb3_full_key_debug
 		spin_lock(&cifs_tcp_ses_lock);
 		list_for_each_entry(server_it, &cifs_tcp_ses_list, tcp_ses_list) {
 			list_for_each_entry(ses_it, &server_it->smb_ses_list, smb_ses_list) {
-				if (ses_it->Suid == out.session_id) {
+				if (ses_it->status != CifsExiting &&
+				    ses_it->Suid == out.session_id) {
 					ses = ses_it;
 					/*
 					 * since we are using the session outside the crit
-- 
2.25.1

