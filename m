Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AF637E2FC;
	Fri, 10 Apr 2026 15:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775833463; cv=none; b=CNLdumcoNxT2+kBonib85c8smHmTY5IHVqjoP1fTpgGwLLweprSCJzilRBz0NPmsHuqXFbXJR3SV448K7l4mTkfHE2UNszZ+4cwO5LapbIjCskfGX4z/g/jtXknPxTwxmhRmGW18NKkoLcUE7NjnhLfpwMlsP0h1Mbbd89nFIOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775833463; c=relaxed/simple;
	bh=J/S4mg7JzVVwRGvWYR6ZpzPYxEol30c6kRVjxlHGKZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UuOK2kvEKzYV0q7cHMekdrRAcuvTWzgAB6kN0AuNZ9u6cy2Hdr4hmXN+dqE0/0LGjLKGrc+WSWdpn4kX076W3VNpIDx3HT9elo5XIuNaMNmkiswRENHJnl2tzt7f86hijbDlK1K1CgAbs+eGwWY8qQsPVwit3k+IvZilwvWBd/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NfNZuotE; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NfNZuotE"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63AC6wJr2213384;
	Fri, 10 Apr 2026 15:03:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=GrUN8fL93Y7h7936is0ZlEFRFZNBWptAHMgvgxMol
	/k=; b=NfNZuotEQ4t/4TPYNmwqdJUSAmk9sXe4eOy4OrMP1foMJGmK5LtA8gZzf
	vU7SqqQ3FFVEmNam1yDEuC0TJlAwkW9+XBHbol2WHOAJt1tJmh+omi/4BjfOfamT
	bGSuXC1Y+ROD1jlyQhSPac1Hfblq1wPm9kcC6hXRi2IYW9kW3Q/bk0d9UsGmIiLV
	nY9VS78oqkuyGCw7//NB9PeG5GufCIU1SsJ5TAcEkwOjZcg6/kTM1/jK8Dih5VIm
	yzB6xzhWRunnJD+1ZDc5k37oZ5Q7FCIi731khP9eRgNFEochv8Rz0TySE/0xySdd
	LTl8mkAjJUs3LvNQzPMMgTksEftRw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2hsdb6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 15:03:33 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63ACp7Ql026714;
	Fri, 10 Apr 2026 15:03:32 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcmg88fpm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 15:03:32 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63AF3Set53543416
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 15:03:28 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A667B20043;
	Fri, 10 Apr 2026 15:03:28 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 12CBB2004B;
	Fri, 10 Apr 2026 15:03:24 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.61.247.193])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Apr 2026 15:03:23 +0000 (GMT)
From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
To: sfrench@samba.org, pc@manguebit.org
Cc: skb99@linux.ibm.com, maddy@linux.ibm.com, chenxiaosong@chenxiaosong.com,
        linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH v3] smb: client: add missing MODULE_DESCRIPTION() to smb1maperror_test
Date: Fri, 10 Apr 2026 20:32:48 +0530
Message-ID: <20260410150247.93178-2-venkat88@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDEzOSBTYWx0ZWRfX2BpZOIkFtY30
 WFclJ4jGmHrIHI+8HxEnIivkt1D19GGareuzKwjFDBAW1YYJT5U2vdmR0re8X62VUQV9AHPcqrA
 oWpdYMtkmbrDNXwqo2kvMnUV8lFP9HCzgz4/dDqyxysAboJ6lt/xJxwnrf+6P1LL47rbZ4n70SS
 3lBRbeeSXJfFnJM0tGhIDigTaT1SaFbuQ90Mlw/LpfqSfFCs5CjTdnMncNd2dC9RvwMBrkIkfYd
 8WUjS2qFB3BOtz9L9TCidUEKYtPDToj3DWaA9XItue58EKp/DqMxnNRWFYP2z6TSdO4bHS9q5wm
 Enk8+9781CYSSnr054hNZ+NBVaRHGhd+HF2vdjYPTCOUpqD7KFVCtj35ZQIwx7KzkFO+IlCCr0d
 d6w5j0bcNmp/XcRsIrPGAlySmRjR24zSKKph171mcKuf1Rp9Qa/jmAc3fFKbyKxczX+3Mducmv7
 6d7Lg/0T0qchxyV49Ag==
X-Proofpoint-GUID: 8Rr-8p9OxDbnoKuCv-eB3t7Ga3OJef9s
X-Authority-Analysis: v=2.4 cv=a/wAM0SF c=1 sm=1 tr=0 ts=69d91145 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=Q8Al3GYf2AzKIbZmJxYA:9
X-Proofpoint-ORIG-GUID: 8Rr-8p9OxDbnoKuCv-eB3t7Ga3OJef9s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1011 spamscore=0 impostorscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604100139

On the latest linux-next following modpost warning is reported:

  WARNING: modpost: missing MODULE_DESCRIPTION() in
  fs/smb/client/smb1maperror_test.o

Add MODULE_DESCRIPTION() to the test module to fix the warning.

Signed-off-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
---
Changes in v3:
- Update MODULE_DESCRIPTION as suggested in review

 fs/smb/client/smb1maperror_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/smb1maperror_test.c b/fs/smb/client/smb1maperror_test.c
index 820c0dd3bcce..2caaf11228ef 100644
--- a/fs/smb/client/smb1maperror_test.c
+++ b/fs/smb/client/smb1maperror_test.c
@@ -74,3 +74,4 @@ static struct kunit_suite maperror_suite = {
 kunit_test_suite(maperror_suite);
 
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("KUnit tests of SMB1 maperror");
-- 
2.45.2

