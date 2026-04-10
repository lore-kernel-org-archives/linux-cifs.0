Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6762B3D902C;
	Fri, 10 Apr 2026 15:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775833950; cv=none; b=CDTAQ1wO+8mIzU0QZAvtx84lPNeKWVS9AU29CCM0MYhC5UzHPqRTEdiNOMgyCjzu6Sj97TsRXxCiHVH9iD0tJJmIuCMEoEoz5tEYfzXED58WmOQLNpyA/7j/FRNmUhq1BdIe/XlQgjo+trALAP+JLNk3KVGMbuvjRgVs4R8nx50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775833950; c=relaxed/simple;
	bh=Fp/6/wpaCuVPWQsttotjhlHLI0XodETKe6J4+sl4Gm4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S3uwITj1a/944xSeIYI2nNDF3JspgbocOZe8RQapLlgCeydlDBuNqxdOhYunAHiHNV+OnEM3BvVCs43Ow2w3XIcbYri2GWBbWXXc0K2ryPreUPWawq23Pc3ZJt/hubPxhSQw8d/g38W2eCN9OXQeKCmGrs/Op/ir27jtTBTF7Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ecs3fhxD; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ecs3fhxD"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63AEeCnu2590966;
	Fri, 10 Apr 2026 15:12:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=csItvN
	YBlrMXr5N2TKGW06yCbfG3CvABPIB87GyeRlM=; b=ecs3fhxDwKHllOIMN8B1RI
	jzKpxFB8b6wTWqraE4KCYf4j3OGedRvY77/xyLJgndnUPPrNSd01vHUxdoFRljva
	CncumJWBB5n6RqV3ySX+sRrWGTb0/iyD0spXlaVtlWJgCpbjzMzITvE5cij4KJeK
	jWwm83umZBL5fHkp9MhILU0HbB8KvuIkLK29Zct9nnfSxPTs6tOhGN7q8qXFLfNg
	YdOFpmaryQPASBZgjV75GYfQApWpdM5a3sE4o8uHQZD86kwa+oULSsejXc8D9/Nc
	a6aA+jkZ0kHcvn/tSkVpeGkJuB+E087GAOvvXVgGZ2ncrapNsBSx8YKGBWmEoUcA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2ejmqg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 15:12:00 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63ADAQYx018987;
	Fri, 10 Apr 2026 15:11:59 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcme9rjxe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 15:11:59 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63AFBwbn22086314
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 15:11:58 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3BF005805A;
	Fri, 10 Apr 2026 15:11:58 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B6D25803F;
	Fri, 10 Apr 2026 15:11:54 +0000 (GMT)
Received: from [9.61.247.193] (unknown [9.61.247.193])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Apr 2026 15:11:54 +0000 (GMT)
Message-ID: <da63cafd-a9dc-485a-92b3-54bbf2078c18@linux.ibm.com>
Date: Fri, 10 Apr 2026 20:41:52 +0530
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] smb: client: add missing MODULE_DESCRIPTION() to
 smb1maperror_test
Content-Language: en-GB
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, sfrench@samba.org,
        pc@manguebit.org
Cc: skb99@linux.ibm.com, maddy@linux.ibm.com, linux-cifs@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260410064030.89137-1-venkat88@linux.ibm.com>
 <d7ed8f4a-dcc5-4654-abd6-53409685f161@chenxiaosong.com>
From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
In-Reply-To: <d7ed8f4a-dcc5-4654-abd6-53409685f161@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SBgYdd1Ycj1KNG8Pavrc1q6ZhLDEnI4l
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDEzOSBTYWx0ZWRfX8+01xoD5OS9i
 Nv0eWXd+kfpsmQ05jy/5Rye8ofHSyzR8tr4NVR9jw61Vv74E5Dq0UWDJ8PcebPNfey3dkU5tdve
 r3HZEBHbUi964Nv9mX75Cy4AqXiyak/Rpok97E/j38eL3q6xg3kvxGXoO9XKFU/jCz8ojGsWkns
 Un3l0BhiBoVuNVSbEsEbjWLz8M1McPs9ixUA2PflqA1LVSR8N2LCGDwfT5U+Di+8DsjyytV5P4N
 uCRh+MsBEkT9EYCC4Z2UidRyVWuHaDASQNTm0RWzPUa5TYD741VNKCNFPtY0oOCEa7dSEyGMXnb
 618oTpR0lsiNXIK3fF6GWmrGpCPpWtDiUzws7Od+LbrRHFbpkZm/+seHQm0M8LlHOCs8j3a9Vk9
 3E7ft4yCmUPy0EB3/BZ51zToY09bWERIF1D3UN3hP7qcP+qgP/CT4ZRQPHTaNFPxrkVGJa1p04H
 qdjlWsdxxKIzC/ZfVwQ==
X-Authority-Analysis: v=2.4 cv=Cfw4Irrl c=1 sm=1 tr=0 ts=69d91340 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=oaAmmnu4hYEVD3ufF7IA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: SBgYdd1Ycj1KNG8Pavrc1q6ZhLDEnI4l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 clxscore=1011 adultscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604100139


On 10/04/26 7:22 pm, ChenXiaoSong wrote:
> Thanks for your patch. It is "KUnit test" rather than "selftest".
>
> Perhaps the following description would be better: "KUnit tests of 
> SMB1 maperror".
>
> On 2026/4/10 14:40, Venkat Rao Bagalkote wrote:
>> +MODULE_DESCRIPTION("SMB1 error mapping selftest module");

Thank you for the review. I have sent v3, with proposed changes. Please 
review v3.

https://lore.kernel.org/all/20260410150247.93178-2-venkat88@linux.ibm.com/


Regards,

Venkat.


