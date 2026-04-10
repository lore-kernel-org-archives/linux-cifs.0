Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9A021CC5A;
	Fri, 10 Apr 2026 06:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775800966; cv=none; b=Yjiw8fBLXxbwkULZ37DvmB7BJI9snUmAc5bQ+ot58ymw8quFBXjesNunkd0FR/ZjX/W5CcueiNNuuB5nY+VDMwPF8Y07gXpX32vuq+pOAZ6iDqrsHY65/bOhp4rFLBZtMSyufu4OKpS2+2o2k9aVjHC+XpJg+fw2fijD+huy7L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775800966; c=relaxed/simple;
	bh=2C1QmRHjAPidmr5LPOXxgo1KvdANmLrqZbokm2zqR8U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dBzZVI3wQ6zN5Jzn7Xp9mSXsLh/g1Pa6/4bcIP6BRrcXASei8KkEsKNulQaSzLAuPnW1gJf+AsxgNrHjIqdBOxjnbkiKD3Z/mDJGQKQJchL7WzmOEGTFfzsKvfRqn59ZweKdmzG21Enom+mZn3jIgIaNMhq0RIQsGEBYgU2FHD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rRUV7S+k; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rRUV7S+k"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639LKZtP2302702;
	Fri, 10 Apr 2026 06:02:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=6pepys90R88tiggDD22B9pLFDfMvkbVT6D79aK6uq
	KU=; b=rRUV7S+kfG76K+ykT0ChJ9ar+EdFtrhw1+7bDc2NYh58Xk4tn+Ju6s5yQ
	TrqZ4QfI/M3bEzPOMwYcladnVQxKgCbEKO6S7wWsCLWUNOevxpNXujl95SAHHbhh
	mcCt9g++r9mMrMvf6qJD/+A6v+rcbmxefKVnpbghsnKMO/il6ilB06aD1Qum8nnf
	sh3Hg17pJYZL/drXOOGT50PEoqtvDAAswmSVIcSDCvR/jFX8NErBEKlSBfSU7lPr
	x2kxZItcVwHgKTLoppZCWIWGHhdG3Zq/szvLIh6R818tJDrsW2CcPcU1E05h4ESF
	9bk6nlhlBOknCQWGO8qiWHZHfIFGw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2frhbf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 06:02:28 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63A2Yi8q029863;
	Fri, 10 Apr 2026 06:02:27 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dcme7prcc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 06:02:27 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63A62NYE52887910
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 06:02:23 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 964F620043;
	Fri, 10 Apr 2026 06:02:23 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 91BC320040;
	Fri, 10 Apr 2026 06:02:18 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.61.241.130])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Apr 2026 06:02:18 +0000 (GMT)
From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
To: sfrench@samba.org, pc@manguebit.org
Cc: skb99@linux.ibm.com, maddy@linux.ibm.com, linux-cifs@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH] smb: client: add missing MODULE_DESCRIPTION() to smb1maperror_test
Date: Fri, 10 Apr 2026 11:32:11 +0530
Message-ID: <20260410060211.88944-1-venkat88@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDA1MSBTYWx0ZWRfX+jsqm+3+W918
 PsPfLRJciTyeMAieDwxGfrX+7cWT/JG0EkVSlALxubbGH93suReXnEl7ovPonGfoztUgpFYmInK
 R7hQCtq6Ms7oiWpCZvoSMnO4kW2sxBE4UhJKpTqwb4MhSnPWICFdkXFi2B0j698Ey83c9EmIRIo
 cSQec3sSxP8kqrD9m/md6jhEHBh9GOSx0nyBmOl28aQYLhdge6zeF8NnAOjxKbXQil7NQ0QMRx7
 iIZVhneiXjI3ueUKzBMYzRswCFKpn8k4EfBJA0ON4USFydT/umjVCRc6llpbfpAEoF7wD+Ad5ha
 ptseJerncFf7A1Mm4N4PD2dn6RykeT+aIsxFUGb9D9fz1SuslttoNitJFc/SG5NKgQoypvMwd4I
 FAmhefgzM6/i7axcs1TiV5Rdos5Fmrvxnm3gTnX4QAPpzCIEUCaj5DS057tyXYtfjKlGPgydcSg
 oslLIbm5E6RaqIbNXKQ==
X-Authority-Analysis: v=2.4 cv=FsY1OWrq c=1 sm=1 tr=0 ts=69d89274 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=kNQELbV3vDtd0-r0qvwA:9
X-Proofpoint-ORIG-GUID: FQceTmxicb1Jjq5BIXN8ttNQQ-msRDZt
X-Proofpoint-GUID: FQceTmxicb1Jjq5BIXN8ttNQQ-msRDZt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_01,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1011 adultscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604100051

On the latest linux-next following modpost warning is reported:

  WARNING: modpost: missing MODULE_DESCRIPTION() in
  fs/smb/client/smb1maperror_test.o

Add MODULE_DESCRIPTION() to the test module to fix the warning.

Signed-off-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
---
 fs/smb/client/smb1maperror_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/smb1maperror_test.c b/fs/smb/client/smb1maperror_test.c
index 820c0dd3bcce..0a816aea4fd6 100644
--- a/fs/smb/client/smb1maperror_test.c
+++ b/fs/smb/client/smb1maperror_test.c
@@ -74,3 +74,4 @@ static struct kunit_suite maperror_suite = {
 kunit_test_suite(maperror_suite);
 
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("MB1 error mapping selftest module");
-- 
2.45.2

