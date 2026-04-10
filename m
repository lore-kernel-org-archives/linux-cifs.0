Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503FB27CB02;
	Fri, 10 Apr 2026 06:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775803259; cv=none; b=m0aBqNter2NslrN0jp0Hfay0HKC3lpuKoQ5kKJkVl9vBRq65LLrHDf5GJlJirT16kio8AiWIH6+g1bdioIz9wuEMtgeYe9JMrH8XjaJtCyEyILBv1ee0hxLs26KEl6BPBosyFj9WCfbGfCmrw8PnrOCazlYKnDKcSQKhF+C0u1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775803259; c=relaxed/simple;
	bh=7A27I0VpgYSKZe0iTJ9/zo52B4o7mA8dFYwI3myEMGU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lNnyZfb6tgJKi1Y3slQnZ9ecmV3NJx395bXXPowclMV7a94Hgmh6pfQwkiKPXl5I1jnIL65ARRhCm617vzlb1xeNYimTlF4/NCvcz/8OFWwiQ3dK6GE3j9rUg7eSf9CIK5hzxqgDpGun3ncgM0v1ji68kCtSzVpV5eT+9uQcIZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rOdWdXN2; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rOdWdXN2"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639LdTGo2591197;
	Fri, 10 Apr 2026 06:40:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=sxAysYSHtVlYKud4KFqaFMzX4lQ70a+THljE9GHbm
	q8=; b=rOdWdXN2s/uE5qZx96ZX1RHz0m7v9zKMpIKOCrkezvH2Mrd9GCniUJGoG
	2HHzsdWMTu8UvJ0BASpfyCtHzr3N4gExdarUd5QpCuE8hJyq/8jESlKnVvfFkhxb
	aadE5mj5i0FUsZ2vRIJPqdxvpf/4PrlxOfo3BKevYFXaUwmVAG50uwG40p0a7PJ2
	ed1IyX62MrsNbHIuQxxKnmqPwRZ1K1Lr3urUwntjPOoKmoep/CWzzhw3OvV0b2kZ
	3bg08ZWrhMd0L9JkBwHVVTTPai7XJUMIYiXPtc/pB4YP4lCut9YPlJY5ivysK9x4
	tsYlMBGrAWbeiwP5DVuOamxRGUUQQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2egpt3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 06:40:43 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63A38jwi026723;
	Fri, 10 Apr 2026 06:40:42 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcmg86u3m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 06:40:42 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63A6edLK59638270
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 06:40:39 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2257E20040;
	Fri, 10 Apr 2026 06:40:39 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 53A4220043;
	Fri, 10 Apr 2026 06:40:35 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.61.241.130])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Apr 2026 06:40:34 +0000 (GMT)
From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
To: sfrench@samba.org, pc@manguebit.org
Cc: skb99@linux.ibm.com, maddy@linux.ibm.com, linux-cifs@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH v2] smb: client: add missing MODULE_DESCRIPTION() to smb1maperror_test
Date: Fri, 10 Apr 2026 12:10:30 +0530
Message-ID: <20260410064030.89137-1-venkat88@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: w9BU-AaUl27WPGcLoJewCwzJgYNepkQR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDA1NiBTYWx0ZWRfXzLQx2WBHzsR2
 E+XPOSX8vZkUQVKgGpVA8jNOu+rGVGIczkQiueYsY8CHdAgpTsYSHEeypWFbgFdVQql7T/HCBTg
 fkFHyudn2JEeCd/CiIUKJdrEf/8qvLmnOu2Ygp/KNoxWX0cs1ZwjfiANOLMamOZoRhIH0Bl1drW
 qM+Jcw6vwzw9MvP8fp7LcfiPZ156zpmzSXwXAVn/v+4A8ZaWCDszfmCBuWIya6mnKvUM3TYius/
 lno9hIlsAqGY0Trh+3hbvxX/qVt54fqe3OdcjlDEFlLoL/rUSCC0CjAcQTDLZVUXECtGkRlCwXD
 WWGqagMZzxpwKebb4dbkhnGE/XVStJLKWjxQXf3mx4QnwowA0qgrERmsiqsf9lyHwbUFSGNy8h2
 5Ssur7NN0wxCgQ5FeYMYbMhnsYpe4SArw+PKBugwTjDYgDQB3MNOa9IWYBepacPie3lSA/Lym7S
 UkhBfAlsNkKq1Evh7jw==
X-Authority-Analysis: v=2.4 cv=Cfw4Irrl c=1 sm=1 tr=0 ts=69d89b6b cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=GqDCs-o0AkJqZ4DDRDQA:9
X-Proofpoint-GUID: w9BU-AaUl27WPGcLoJewCwzJgYNepkQR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_02,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 clxscore=1015 adultscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604100056

On the latest linux-next following modpost warning is reported:

  WARNING: modpost: missing MODULE_DESCRIPTION() in
  fs/smb/client/smb1maperror_test.o

Add MODULE_DESCRIPTION() to the test module to fix the warning.

Signed-off-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
---
Changes in v2:
- Fix typo in MODULE_DESCRIPTION

 fs/smb/client/smb1maperror_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/smb1maperror_test.c b/fs/smb/client/smb1maperror_test.c
index 820c0dd3bcce..b93d3ac41f91 100644
--- a/fs/smb/client/smb1maperror_test.c
+++ b/fs/smb/client/smb1maperror_test.c
@@ -74,3 +74,4 @@ static struct kunit_suite maperror_suite = {
 kunit_test_suite(maperror_suite);
 
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("SMB1 error mapping selftest module");
-- 
2.45.2

