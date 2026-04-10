Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32848339B3D;
	Fri, 10 Apr 2026 06:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775802054; cv=none; b=Y2huTW+7sWLtWEA/dw+TxcDbDp4YjKsvIZmhYb28aGNETUSWlB5y5Q72W6EHr9JW7TnEvoG0/TUPFkwz0qvyU+E80xjtZrJSxVAqXuKiEeT+MvloC1o+A1SymbKyMAfB4CRNwkh6gGRxRp6R3TpMTp2DiR2kvzNqxLmttsfp3x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775802054; c=relaxed/simple;
	bh=RzoVSQeToEN2Jpt+UWQQABqqCg6eETLuFzBdl+vHvjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=knaFeqSCpZmM6oD0Dno6cGU9P5Tevje4tUF7GKpQM+OWs+CRrTKMnwa2YJLWgk5fDOp+Pj1Am5Y077yku7Lq7eL1ZMo0JD/PTgtxfJF3zsKGQl1iQZ/SXe22awepg3WwoJi5PrGhsvWuqJEuaXyb8z8tURLhOOw+uYlNO9iCvX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JlqtQwCQ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JlqtQwCQ"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63A3Bppr2326198;
	Fri, 10 Apr 2026 06:20:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=gklkDHhFPaT03oIPJBfkAC+f2RMKVX
	msDeyEn1CqeII=; b=JlqtQwCQ9gS8fV7rg8psWovn1jBp/kK4S4KBMZTbcfGXlU
	PWcJ0+s13TxpTOZQrM5U3ys6VYi6AyAb43Ytk2dPU8HERS/rZZOE7Yryw2LgXV4b
	ZgIPBaeNnjNlS4SCEGW1NR5/CajNky/fbeEL/mm3M+pw/T4VG+ZD3ag938Yi5hIr
	pe1eJ5v5jwLCz+dUVk4ae/bRQ45twuydO0HWgT4u6OMBuxh9ucuR+HCrzEENnEqN
	qo7a+TSdsCx5ZotgzNt3YIA2vWMrJmKbiOtJbRORy/eZ/QEdCiq1Rd/f5RaEXs8C
	drODFMPAOSNm1AtEDCzOdBtb18kSU9k89bpv58oQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2kqhg0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 06:20:36 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63A2qIse019113;
	Fri, 10 Apr 2026 06:20:35 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcme9ptrm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 06:20:35 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63A6KVne20579062
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 06:20:31 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7C3572004D;
	Fri, 10 Apr 2026 06:20:31 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D21E20040;
	Fri, 10 Apr 2026 06:20:29 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.39.25.13])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 10 Apr 2026 06:20:28 +0000 (GMT)
Date: Fri, 10 Apr 2026 11:50:25 +0530
From: Saket Kumar Bhaskar <skb99@linux.ibm.com>
To: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: sfrench@samba.org, pc@manguebit.org, maddy@linux.ibm.com,
        linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smb: client: add missing MODULE_DESCRIPTION() to
 smb1maperror_test
Message-ID: <adiWqW7KlQO1VcK-@linux.ibm.com>
References: <20260410060211.88944-1-venkat88@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410060211.88944-1-venkat88@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDA1NiBTYWx0ZWRfXxlg4lefvLdMo
 tGMsnHY1vC/uWDOsPI3D9NRyvXcFflsHqhsICGDcBU0rKG83iv3li4AhIqYAsqwdW241x0RNwQu
 tI0QbOwtMJae64DrvekYZ4WaXtn2N2XMhpE3NFOzjDZm8bAyiecpWvJND+gC+fklSXYCVctm5Ag
 ciIrvV2FLPjA5d4tMMMggDU11uihOKgVwUYJsvwb0SfjHu+0KRfagCpIyYowtz1jDCfv9S8aqQ/
 m+8T5hf+lOCfUb7WKdYMldqP1byIR+slPdBuD0pnb7HqWMOq5NZSlm9M9xK+DsqbSm7+yVZrhrs
 XkqoLaa2RavsK0FYWNbvhVEbfBuinOkPRC6uAS0/wnaCCxPXZdvQiGtPhnuojsvTnhtCXmO4W8T
 o0ZYIp3iEnLbOpxm/RzM1MK7JYcf8sYL52d3u+iWD0tBC8jMVgF71IVNEFnVdPZU2BEtES2AYFl
 RCT8mR6OtrFt6chTcXA==
X-Proofpoint-ORIG-GUID: Gi57KzBQN9lvSnOZSkC1IIC947AXVZnt
X-Authority-Analysis: v=2.4 cv=e9k2j6p/ c=1 sm=1 tr=0 ts=69d896b4 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=YhCFa1l7bhxZKq0x1IoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: Gi57KzBQN9lvSnOZSkC1IIC947AXVZnt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_02,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 impostorscore=0 malwarescore=0 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604100056

On Fri, Apr 10, 2026 at 11:32:11AM +0530, Venkat Rao Bagalkote wrote:
> On the latest linux-next following modpost warning is reported:
> 
>   WARNING: modpost: missing MODULE_DESCRIPTION() in
>   fs/smb/client/smb1maperror_test.o
> 
> Add MODULE_DESCRIPTION() to the test module to fix the warning.
> 
> Signed-off-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> ---
>  fs/smb/client/smb1maperror_test.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/smb/client/smb1maperror_test.c b/fs/smb/client/smb1maperror_test.c
> index 820c0dd3bcce..0a816aea4fd6 100644
> --- a/fs/smb/client/smb1maperror_test.c
> +++ b/fs/smb/client/smb1maperror_test.c
> @@ -74,3 +74,4 @@ static struct kunit_suite maperror_suite = {
>  kunit_test_suite(maperror_suite);
>  
>  MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("MB1 error mapping selftest module");
Typo: MB1 -> SMB1

Thanks,
Saket
> -- 
> 2.45.2
> 
