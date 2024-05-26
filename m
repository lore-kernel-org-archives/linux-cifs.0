Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591F51758E;
	Sun, 26 May 2024 16:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716742411; cv=none; b=auE4NCjdjaPFfZnSvLziyeL0ZAh7NqQVKuVuuiWEsPWZFNYIYVW3Ha8NBH0iEwDzVws+A4qyjj+43MbJ+bnjXRUz/R6dhCWT7y+Uj2NSTIytVKH9E6RVaGLI04Hv4lfPCBMLNmamcwnEepmH+pAIpZ/U2Yi5J8FYmlNxiUCos4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716742411; c=relaxed/simple;
	bh=DuIz6G9RKoV38cQtkSpR7QLaH8zvhm1mIsUnPVSj5EU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=cKckwT/jQaHzztS8PTCpuLHnC7aeEPtV4eTAEp0RZIzPw/rdEvVBohEVc8xcEUktiQudKHU79RBa1JwjPPRtdJ3ed/qLr3b7jVuQ+SoF8fYPyvkPz00OX0m6i3nszvOXerzy2TPH9POgAXPTrmKO7w7lXAoY4DdoNv9ami9xa1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=pkJEcoth; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="pkJEcoth"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44QFG8tu023549;
	Sun, 26 May 2024 16:52:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=hY+Lcx03LqVtjb+9FRb6Ft
	CCsw4wjlH7Z9n5CV1t0Q8=; b=pkJEcoth7/ngITw2ovnH6IUE5rfeLdtmAWW/mj
	qs9yBXsply4oHAtHA8guyPm6kb4YJ0cQ60pGknubZkro21Iv2ifpNjXKzFTn2ca8
	pIWMOd7a4AV0UjYKgLD2EPaAoy25TG8RPiuEzSQIhCPJ3YKdiBurQ7ZF8syhz+ZQ
	LgHsmIbbII449gQnHVyRHtgFYvzOiyTA3yaV38W0GkazmuvruAdPHIWqvTE6puF3
	cdKytB4YaW3rxuzx5zjqz02uI63RljfbrSk2YwFXrhMAZzn35+ApD0pwRhL3nsQy
	de2svwJCXvqF2wl5gkwdjeCr42qftS5LPSyATlK4KAEhGuYg==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yba0g1y6a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 26 May 2024 16:52:52 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 44QGqoGB032274
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 26 May 2024 16:52:51 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sun, 26 May
 2024 09:52:50 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Sun, 26 May 2024 09:52:48 -0700
Subject: [PATCH] fs: smb: common: add missing MODULE_DESCRIPTION() macros
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240526-md-fs-smb-common-v1-1-564a0036abe9@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAN9oU2YC/x3MywrCMBCF4Vcps3YgTb2/irjIZWIHnKRktFRK3
 93o8oNz/hWUKpPCtVuh0szKJTf0uw7C6PKDkGMzWGP35mCPKBGToorHUERKRrpYM/TpFM8hQbt
 NlRIv/+Tt3uydEvrqchh/oSfn94Li9EUVp0+bwrZ9AeNt1M6HAAAA
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>, Paulo Alcantara <pc@manguebit.com>,
        Ronnie Sahlberg
	<ronniesahlberg@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        "Bharath
 SM" <bharathsm@microsoft.com>
CC: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "Jeff
 Johnson" <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 3GqhrWkK7rjr073_-pZPlNwb3zAV88Zu
X-Proofpoint-ORIG-GUID: 3GqhrWkK7rjr073_-pZPlNwb3zAV88Zu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-26_09,2024-05-24_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxlogscore=672 malwarescore=0 lowpriorityscore=0 clxscore=1011
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2405260140

Fix the 'make W=1' warnings:
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/smb/common/cifs_arc4.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/smb/common/cifs_md4.o

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 fs/smb/common/cifs_arc4.c | 1 +
 fs/smb/common/cifs_md4.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/smb/common/cifs_arc4.c b/fs/smb/common/cifs_arc4.c
index 043e4cb839fa..df360ca47826 100644
--- a/fs/smb/common/cifs_arc4.c
+++ b/fs/smb/common/cifs_arc4.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include "arc4.h"
 
+MODULE_DESCRIPTION("ARC4 Cipher Algorithm");
 MODULE_LICENSE("GPL");
 
 int cifs_arc4_setkey(struct arc4_ctx *ctx, const u8 *in_key, unsigned int key_len)
diff --git a/fs/smb/common/cifs_md4.c b/fs/smb/common/cifs_md4.c
index 50f78cfc6ce9..7ee7f4dad90c 100644
--- a/fs/smb/common/cifs_md4.c
+++ b/fs/smb/common/cifs_md4.c
@@ -24,6 +24,7 @@
 #include <asm/byteorder.h>
 #include "md4.h"
 
+MODULE_DESCRIPTION("MD4 Message Digest Algorithm (RFC1320)");
 MODULE_LICENSE("GPL");
 
 static inline u32 lshift(u32 x, unsigned int s)

---
base-commit: 416ff45264d50a983c3c0b99f0da6ee59f9acd68
change-id: 20240526-md-fs-smb-common-e92031f7d8cf

