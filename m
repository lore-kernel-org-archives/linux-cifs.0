Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE242FFDE3;
	Fri, 10 Apr 2026 08:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775809889; cv=none; b=aiMsptNfoIJL0KEpRncZ416RsyRuQxCeXi5VMWFGXtb9Qr/CWk811b3Vo7bTG4f2kmIVgtKBeXxDfs+K2AZ/TJxx8itXSLMhpUz4TYGJ2FE9sudFUXov+2Cd2FAgQaGDHeVRl0BimB+9C3o6c85PB4rLl/Wru3adCAZ9C14aJws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775809889; c=relaxed/simple;
	bh=NmOdHocq9NZVQvuW5G6tqmi9wA5k4gvmSwBJZ5IiBTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q4Mg//LKYrGmPs5itiWjGzo7jA4zpzzCd6IUTaThfbQT1lKDz6uyTbOSqwUN1a8jEyxsawqJMl1rDUg044ap3teTGT4OVItV9uA/f8P8tWoJFORvlqX9kyjaxwIRv5naYKWq5WrU52mVy1wogrfHA86KE9a6bbDkrGkjGaX9f/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jJdG0XgX; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jJdG0XgX"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639N4PC02590969;
	Fri, 10 Apr 2026 08:31:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=oalC71NthxjF2IHi+j+iB7+sMItMez
	bV3s289G4ZAHM=; b=jJdG0XgX4YSBrT2nCr85vRhHjgc9kTdLnHI1MXXja1094p
	X987OXMewpkg3V7Vtfpivz4BduBqi+JnLLCVtSzdwmj9FlY80vzUPTxL24+b9wLp
	Ag8g7OlibRswjkveoblFzXVe1KxQkLtUzDSVhT0gj6og0PLFM9tcCHsTz3JLrWB7
	JkbpPVM3/NhNxoIXDINp6ZKXukXfIzDUY/YpG6uwToum6aQC3r6p5v6NbvknaOba
	onjKip6YNqtCT+ZiAPaezWJWd88p05MTHp4mfkPGPVVOy0xdFs/Ro1aHK/o/Quqh
	YrxILeQhZe2b3ivr7Ai1LuHBjEASkrcqjwsWy6LQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2eh2hq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 08:31:11 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63A8Mb8p013878;
	Fri, 10 Apr 2026 08:31:10 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dcmf4f75y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 08:31:10 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63A8V6UI49611026
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 08:31:06 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 354DA2004B;
	Fri, 10 Apr 2026 08:31:06 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AF7E720049;
	Fri, 10 Apr 2026 08:31:03 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.39.25.13])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 10 Apr 2026 08:31:03 +0000 (GMT)
Date: Fri, 10 Apr 2026 14:01:00 +0530
From: Saket Kumar Bhaskar <skb99@linux.ibm.com>
To: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: sfrench@samba.org, pc@manguebit.org, maddy@linux.ibm.com,
        linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] smb: client: add missing MODULE_DESCRIPTION() to
 smb1maperror_test
Message-ID: <adi1RHPWcz-zsYUP@linux.ibm.com>
References: <20260410064030.89137-1-venkat88@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410064030.89137-1-venkat88@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vwUHglSaTSDqtT2GOSAioSh0wy-subu3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDA3NiBTYWx0ZWRfXwU+tc1CJq4kS
 tp9rYgi9kewu/55tT1BlE2BPeHjVdhC2pcUUBHDdxTiuQx1qkAzIUSwUUjIzbglNzx6YSVMbNod
 +/f7nKuGO+1OSebTQPQ7BFMr6wD2IlrFwbShiVDwEWnOF+0q9HX3flx4vJww/XRM/RlgTuBCJdS
 mKwsoxLjzqf/my2tYJI91MCD5XKa8WXeXuos/gU+i1hUCVgMUaFPTIw6x6ROdW6MYJswIaQn40c
 9Nbyasi/NxZA3z11AZ9FplzWRRHUImvpHD9CK35V6hBxrhp6W52lKkMo+9SNXnxKB8FFXlNJA2H
 IhXeLGmZKvD+2dNgixxZiBW0fZMLYGVMqZ02kEeMg61MyKfB35ymeznhlV6H+Py6qlMHvC3OcJl
 it6srOaADWM4FYSdqtGVtE82JNJMb1fR7LzbOQvLVYPjCPakt12Qc716f84iRgGQikWmf1dc+qa
 HE665Ka/1cgQM57lZcg==
X-Authority-Analysis: v=2.4 cv=Cfw4Irrl c=1 sm=1 tr=0 ts=69d8b54f cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=R1CsO3-lcjsMNQs7bYsA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: vwUHglSaTSDqtT2GOSAioSh0wy-subu3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_02,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 clxscore=1015 adultscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604100076

On Fri, Apr 10, 2026 at 12:10:30PM +0530, Venkat Rao Bagalkote wrote:
> On the latest linux-next following modpost warning is reported:
> 
>   WARNING: modpost: missing MODULE_DESCRIPTION() in
>   fs/smb/client/smb1maperror_test.o
> 
> Add MODULE_DESCRIPTION() to the test module to fix the warning.
> 
> Signed-off-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> ---
> Changes in v2:
> - Fix typo in MODULE_DESCRIPTION
> 
>  fs/smb/client/smb1maperror_test.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/smb/client/smb1maperror_test.c b/fs/smb/client/smb1maperror_test.c
> index 820c0dd3bcce..b93d3ac41f91 100644
> --- a/fs/smb/client/smb1maperror_test.c
> +++ b/fs/smb/client/smb1maperror_test.c
> @@ -74,3 +74,4 @@ static struct kunit_suite maperror_suite = {
>  kunit_test_suite(maperror_suite);
>  
>  MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("SMB1 error mapping selftest module");
> -- 
> 2.45.2
> 
LGTM, feel free to add below tag:
Reviewed-by: Saket Kumar Bhaskar <skb99@linux.ibm.com>
