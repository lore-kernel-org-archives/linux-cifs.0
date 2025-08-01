Received: from mx2.pasteur.fr (mx2.pasteur.fr [157.99.45.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AE32561D4
	for <linux-cifs@vger.kernel.org>; Fri,  1 Aug 2025 15:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=157.99.45.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754061395; cv=none; b=KcuCx3ympAMTLTIsUYQX4OmwhtVP9c8e+B/NTCovJJdPGdsi8YXRRpETZx+0plvtZQDdvuD/M/CnTg/m91OwYrBD1VEe0O9yN4rJP5zvhzeKYLDKG79EApYMUmR51u/1czlVPa+SCrSLfBHPVP9uBjzaip3B/IwmVKIvyLYMK60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754061395; c=relaxed/simple;
	bh=m6Geuwm5XPRYj94Dv6B0cnOUPHTxyTDeZ2wryXrss5A=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HPIvkNwoDP61Uv8qie4zoeQM9B0rFJCDC82cSgcn6tTme8TcbAh0nUwVgS+LsoajSK63s43f775LrEERKWz0JoeNXjToin6HfMETu8BiK2OAycbvPETjQtiJaX/eniETPikWtkPoXgck+ga6khIfyJsDnjJ5JnSb1G4i318szog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pasteur.fr; spf=pass smtp.mailfrom=pasteur.fr; dkim=pass (2048-bit key) header.d=pasteur.fr header.i=@pasteur.fr header.b=fchRJTUl; arc=none smtp.client-ip=157.99.45.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pasteur.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pasteur.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pasteur.fr header.i=@pasteur.fr header.b="fchRJTUl"
Received: from pps.filterd (proofpoint01.pasteur.fr [127.0.0.1])
	by proofpoint01.pasteur.fr (8.18.1.2/8.18.1.2) with ESMTP id 571DLFZ8229495;
	Fri, 1 Aug 2025 17:16:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pasteur.fr; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=DKIM2020;
 bh=m6Geuwm5XPRYj94Dv6B0cnOUPHTxyTDeZ2wryXrss5A=;
 b=fchRJTUliEDl3VxY6FbcJ+uGbU5d96PxFxsDxWUo1QhGXyfZuc7pXLvJBKbt0ZDjYZde
 LLXPEL8GRDGzXGbt5Oov+E+T0BXJpxMdElA1HCr/kQ5E/j3ZnxskHSwmj6nun+G5PjR9
 2YBLUf/pIUxZdfJv9qe7yF1ST4as1TKeid9cx0XEZHxq6/eNlmWy8wOko71uQaCsSZwm
 6FzVwiP9ZYoW/d/i/r/7gJHpaiW7CjfBrivt9+Gvk/qtLEstGr8pJrVzoKEH9WLSb2Z/
 4rcdQDs7m0n0tssSvl99GosnykoZqKKLLaEc8pI6PEjOBmvCRNuATA48E9gSzMX0hheH wg== 
Received: from exchange11.corp.pasteur.fr (exchange11.corp.pasteur.fr [10.37.3.11])
	by proofpoint01.pasteur.fr (PPS) with ESMTPS id 488xd20ec8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 01 Aug 2025 17:16:06 +0200
Received: from [10.7.0.51] (157.99.101.117) by exchange11.corp.pasteur.fr
 (10.37.3.11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.27; Fri, 1 Aug
 2025 17:16:06 +0200
Message-ID: <d6ff088e-21b1-4cae-bb9f-289f37979f02@pasteur.fr>
Date: Fri, 1 Aug 2025 17:16:05 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Samba] Sequence of actions resulting in data loss
To: Ralph Boehme <slow@samba.org>, Steve French <smfrench@gmail.com>
CC: "samba@lists.samba.org" <samba@lists.samba.org>,
        CIFS
	<linux-cifs@vger.kernel.org>
References: <16aeb380-30d4-4551-9134-4e7d1dc833c0@pasteur.fr>
 <a70fe80e-5563-467a-8c1f-9fd635662be4@samba.org>
 <fac383c2-2835-448c-a3fc-561f8aec02fa@pasteur.fr>
 <dd2f2bf1-f68d-496d-bca6-3f68672952aa@pasteur.fr>
 <6309360d-088e-49c1-b2db-9ef3169a32d4@pasteur.fr>
 <39705f0a-eb2d-42a1-a135-8751c8c851b0@samba.org>
 <86ae837a-3d30-4450-b91c-3186098178ca@pasteur.fr>
 <20250801121517.32376ad4@devstation.samdom.example.com>
 <62884dd9-0667-4111-afe6-f22ea7468d8e@pasteur.fr>
 <2d2289d7-f536-462f-9505-0ba700ad40b7@samba.org>
 <20250801134029.28a4d9a9@devstation.samdom.example.com>
 <fa99ce33-4eb7-4928-bdb8-8ff162f79856@pasteur.fr>
 <50971413-289b-46af-8f74-b77ca7e94d22@samba.org>
Content-Language: en-US, fr
From: Jean-Baptiste Denis <jbdenis@pasteur.fr>
In-Reply-To: <50971413-289b-46af-8f74-b77ca7e94d22@samba.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: exchange11.corp.pasteur.fr (10.37.3.11) To
 exchange11.corp.pasteur.fr (10.37.3.11)
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODAxMDExNyBTYWx0ZWRfX59cioNPL2+LJ KZiX3zc1Um0OV3Ul71Dek21LKEY8f9qPGRx69cP/yZ65e9p30LgfT9pUumuThuzAqzqcpClA3u5 ViZljLEI77S0wQv/Cayxbhh4KD6epELwYdjy4fDrBOh7fxyFbuOOUfshF+UJPZY3iEPSDl2jXmh
 qV9wKUG/6751zOjZ43K6tJM/UO2Im2a2LMoKZpbpLGEPHfnI9Qr4jyHFdf10CFeUCIamQ/iA3KB 9Va3kXXFhhXxu1sr7FjBeubtoVDkUoMAbUo6MQK3ic2CEl19D6qyoOz4RFd3SDIRqrxVCI71gf7 Zj5UsyIzGOrGQff1N3gfBeyef8IX8LRAr4SVPvyiqpRegLHiIpHs4lp8mMcGt34GPPgrP+Iwy+h 7GEOsxYD
X-Proofpoint-ORIG-GUID: cBkdPeEaudBOgjza8gy42Xj7v_-wONs5
X-Proofpoint-GUID: cBkdPeEaudBOgjza8gy42Xj7v_-wONs5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-01_05,2025-08-01_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=771 spamscore=0
 malwarescore=0 mlxscore=0 clxscore=1011 lowpriorityscore=0 suspectscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508010117

On 8/1/25 5:10 PM, Ralph Boehme wrote:
> so it seems to be something in the cifs kernel client doing this. Can you somewhere
 > post a network trace that covers this?

Here it is:

https://dl.pasteur.fr/fop/aAxGNfJR/file_delete_reproducer_c.pcap

Jean-Baptiste

