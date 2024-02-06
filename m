Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A517316F;
	Tue,  6 Feb 2024 07:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707205616; cv=fail; b=f/hTjKktc7jyzY4LZmvEs8Ubpyo0CfrcOVJXyYD+OIpkq997yH0wb8YotBh4Ajf4nSyin8Z3cZkWuXUAg0aR+sm0BIKbiqXMJm3WOsaG3rW8bLQYBJtXM5hjqm65xIfXACWzz5t9nHujBVy84XvNzcB5b+JN+7JeArAsgqhN9/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707205616; c=relaxed/simple;
	bh=HpqJBrV5B3VkXbU5c7AgU4XKYNGhl8QjUFHc0cD4nB4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YEIhbLoDsQX+S0LgyljePrI/GyVDqlMG/AqpuQWOlV04zBtPDZ6HlSChueYA+suxHwbeMvmXXSL+Rz8ftSOyRNXL23jQ1lf9CSMdxaCQsOLsX3NUwzjqFMLasPiKMWIS+6p5mgiefx249JEepCr8VlMyzF70CG+MxepNVP6D9vk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KAKajfuk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OEZ9JjAm; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KAKajfuk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OEZ9JjAm"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4161EUTn005158;
	Tue, 6 Feb 2024 07:46:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=uJ5qEIWPA5dbWoqCuFmdZcvTrqSt9mt6F/EdCoxmBvw=;
 b=KAKajfukm7eYEOyj7PM1RsIXiDwp4f2MmyEXgV3QFSS5QkXLdf/1g8JFVbG0fn5cnPt/
 Tx9bKX6hwuy6cDppdBzs+K/YLx4BjNzp6oh1irA6Jbw7le3+jGhFww6+td4RByMWDpkI
 /CXVCw+38L0ms/gIhDipsmHvgBptYe0rGBAkZO97gXg8WKq65F2UwjIk6v4+3NqKEu1+
 qtJwDEQz4cLdhACLKR1pJLNM7JThbL7ZX8/oZut465+nvH6Bf2robc1BIPhY318ylzgT
 Kx/l5WeWuDJYEBm+Np7zluxlLAKvQULS7WveqQN2rcAPVdfpNVRjkxASFrGh3ew945AQ zw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1c93x447-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Feb 2024 07:46:14 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41660mg5038255;
	Tue, 6 Feb 2024 07:46:13 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx6ww6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Feb 2024 07:46:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yvh8fph7ws2NHQvH1exCLTnAFAQPDgj8ZC/w0r7/R/rbgxvx+0hg4pSB9FZCKM8UQf1837phMQRGZRPfVi5H2992WZOwNreAyf4EsHjb2tzUVQVUgj6QTTq8I/dZN1jmPR5ESb+kkzafb+WmHkYgSAZze1eVBpa6eBbay66lo47AdYQg2pDiD+qMgoGG/D7mH28QubIWhAmJ3kacGBc6NzbxcbWUjGruYeOnZIRgueT3p1GQ3euvd2k++eq2I8J8sFyzgIlbJLGl7jwNCBdtwioSuYh8W4cs+vlxNmubJuHpM/5Rw54sOxYEgP7wRWACfMY+b4oZ3sp3HGtRRyERuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uJ5qEIWPA5dbWoqCuFmdZcvTrqSt9mt6F/EdCoxmBvw=;
 b=VBlrF4pFFwN3k2rA27NO1Ae29zJAoDQVzDGswmLGaLUbYNz377vO2XWM/VmVIgXvpNa8bo/rpOInCQTDulvP4owS2R7NFDChSDhtOHw7YJ3yK2POc3/8CicLn9pIhQfR0tuB5hI20M5NPvkdaRkbbfxBUUiZwpPK+X+UBpttm8WWd/pv760M54efykGl3d9keKcApiF38Pa6+I6MKaS1CM6CKb+pPNoMg/VfOSFNpa6WFFKDXrrngBTr9m+ZLbls43xNpWPnM74vujkA2vaz0xmMQ4Y+LW/O6hGPlUjs3d2OWs2LHpvTTXjB+N1iwIWAAN1YrR/YlST0z1wxr1WJbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uJ5qEIWPA5dbWoqCuFmdZcvTrqSt9mt6F/EdCoxmBvw=;
 b=OEZ9JjAm84RkOX3Fk+j++4voggfK7L81+IPlpgiNJQIMzFumQ8SAD3kPVEIyNwMsQjZHqmlpZykz888YYZEjFxLBVjFTIjhKsi3r63mGV++T/5wCZy2y85VgDCljrXQBuIcD9zBwkrHQrQSKpNbFOafd1+nvqUGC4NlBSUr+8LI=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by CO1PR10MB4580.namprd10.prod.outlook.com (2603:10b6:303:98::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Tue, 6 Feb
 2024 07:46:10 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::f41b:4111:b10e:4fa5]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::f41b:4111:b10e:4fa5%4]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 07:46:10 +0000
Message-ID: <61fde07c-f767-42b0-9bfa-ef915b28fb77@oracle.com>
Date: Tue, 6 Feb 2024 13:16:01 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
To: Salvatore Bonaccorso <carnil@debian.org>,
        "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>,
        kovalev@altlinux.org
Cc: Paulo Alcantara <pc@manguebit.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "leonardo@schenkel.net" <leonardo@schenkel.net>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "m.weissbach@info-gate.de" <m.weissbach@info-gate.de>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "sairon@sairon.cz" <sairon@sairon.cz>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <53F11617-D406-47C6-8CA7-5BE26EB042BE@amazon.com>
 <9B20AAD6-2C27-4791-8CA9-D7DB912EDC86@amazon.com>
 <2024011521-feed-vanish-5626@gregkh>
 <716A5E86-9D25-4729-BF65-90AC2A335301@amazon.com>
 <ZbnpDbgV7ZCRy3TT@eldamar.lan>
 <848c0723a10638fcf293514fab8cfa2e@manguebit.com>
 <3bfc7bc4-05cd-4353-8fca-a391d6cb9bf4@amazon.com>
 <Zb5eL-AKcZpmvYSl@eldamar.lan>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <Zb5eL-AKcZpmvYSl@eldamar.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0024.apcprd02.prod.outlook.com
 (2603:1096:4:195::18) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|CO1PR10MB4580:EE_
X-MS-Office365-Filtering-Correlation-Id: 39d49321-1912-486c-4ca2-08dc26e7af2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	rHcAtJavzRFUG7pPVM8cvy0+vU5OQAcTwhQtmdWY58fQXmT+ixS+0rqKbbFypdl+4Y4KM1mFk/f4dGg2fqJFHmQ6Fj/akD5csoVcRrZDs0l/9F+BAXbR2jX8TeAvxsnua2+l08+URu9JYaEvjndKEZaLwULhKrbOZshWTtsR96onfDRXmiM1awBncIdn0n5PQEXldDj/SXRUwGKcw/Xnz/a0oosFjHrOWpF5AirB9F1xEFiDyIUup/wthx+fW4s4NFD1pdFrHxXIOMG9X8k0FIiSDcaf4OLwbfi0ZekT0fhxOxigQxuc9GGP1gzGCHfRbVqbRaYEFhNJCNFKqWSBuwWnXCv/Ey8SQbVTJH/UV49KO0++wYD8lHOKOhz4Zp2/s62Po+YM25LtaPUa2UTySa1nKpNoXcojKJ03fnaMKdun8ZVnu1bZFylJERtAaMge5BQLl+fI6dk7xliMrWLgkZpsCh17qBgwDAj1oxknA0neN/X3H84qwInqVR6nlgLhPuUb7xo7M5+rp3cHGPtiXFU/o/1UxKB97VH8Ozq67uzrx3wYrhIi/G4WaNSplgJ9d83r7dVxBC+UgJQ2mA6vmwx70uU2IHHYeFsVm+shykBdRIuIG7J+xqZ0Z/x88pTC67KzXeo4/YTWdD8oMHS+Wg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(376002)(346002)(396003)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(316002)(41300700001)(26005)(8676002)(4326008)(8936002)(2906002)(6506007)(5660300002)(7416002)(966005)(36756003)(478600001)(6486002)(6666004)(53546011)(6512007)(110136005)(54906003)(107886003)(66556008)(66476007)(2616005)(66946007)(86362001)(31696002)(31686004)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cDlIK1VSTUVmc3lZRnd6KzZQTlQzcVNqWllOK044djZ4dzVBbTJBNmltdHQ0?=
 =?utf-8?B?N0FGRlluYzB6dEhHV0dudUZGZkthaS8vZlVtemJGYmQvVm5MRTUrMS9Eamlz?=
 =?utf-8?B?aDF0WUxST05ZTGE2djVaU2JCS2JPQzhkZ3BaUEdWWWJpeHhUR3lJYlFWSk9Q?=
 =?utf-8?B?WVZsVkJ4M2FBUDlXRVVhV3l3N20vYTJza1dHbnZYem01TzhkaEdhOTFVK3Bq?=
 =?utf-8?B?RG1sVXh0dEZNaVAwcGlWMWR5eC9jci9hYkJMVU95bWF4c2hzWXBQeWZGZGVh?=
 =?utf-8?B?dEFVS0tScHNoWWlidmNnWmxsLysrK2ZDVTFQbUM4NitJMHc5OS84Rmo3cVd6?=
 =?utf-8?B?NEZ2WEgra0w0SzdkZDh5RWQ2UkFxOG4rcEZWMDAyZlBKY2RCWjZCU1BncGtu?=
 =?utf-8?B?d1p6cXRLQm5PcldpdjNjMzJndEgvUVA1aU9oSmNsSnFhblB6YTREbVJNQ0VV?=
 =?utf-8?B?N3dxdjhEYS9ocEREcEtucXcyYlZnQzU3TnhaV2NoN3IvdkZ6djlLTUZIeHQy?=
 =?utf-8?B?Y3dGREE1Wkk0VlVLRVAyRTk0R2U0bXNOSDdxMzBqcFA0aFczNVdSM2lRYkti?=
 =?utf-8?B?aFNEdnFuRStySkQyUVZqL0JTTFMzZlVPWnJxNTkvMlVXQlhVR01NcURPeE0r?=
 =?utf-8?B?N21kVm1naVpaNUkzc1JZa3BGSmZjMXNzL29LMjJnZFZFMVVwOXdjTmNzRGp3?=
 =?utf-8?B?dGczVjZNNG8xR0FwaUF6eTVoRzJxRUtIeUdPVE5qT1RIKzZHcnpsUVNud0Fv?=
 =?utf-8?B?ZGthMGNTbFZaa1FGVStGUFFTVWsxeSs5WEtBRFZtNHhqdFhqOFFoajdtVVdX?=
 =?utf-8?B?WnBWb2M0dE1RcmpHYmovUytqZktKanFjTjBwY2I4QTVyVE5iaGl6bEVqZDVJ?=
 =?utf-8?B?RzdkN3lxYjNuSW52bC9XMmpUdEExVTBoRXc4UVY3azcwSnMyOTJlLzNac1hs?=
 =?utf-8?B?SnoybVBhbVFweHR6TlVHVEx5RHdmZnY2cDVUZ2w1c29OdC9GYjFqZitoOWYy?=
 =?utf-8?B?U1M2SjBCckJzME44NnFhVUFWZ21OM3ZNakgzdmh5cEp5NktQcnpFalc4L3pw?=
 =?utf-8?B?NUlVVEprcWI1M2N2UStNMThibTJZb1lJQ2Z4VmFDQXRWWXhGL0RoeXhBZEU5?=
 =?utf-8?B?OVphZER5WTRlUitCWmdCSkQyVVQ5bTRVNHF1ckdLSEJWNkU4L3NDRzZES01O?=
 =?utf-8?B?cks2bWtEYU1tS0ZKOVJVK2E2WFRrUlg5RTU5TUU4VFV5U0xzOGE1QjYrUFdQ?=
 =?utf-8?B?MmJkN0ZocytVVVNjVEVudkFpaGg2Ly9zcXozTkJBL0JBblRxVlhkamE4bkph?=
 =?utf-8?B?S3UrUkhtU0dLMUVUd1ZSYUtoeFlkZkttZUdXQWIwU2RFL1l6RWJ2NDRDa3Fo?=
 =?utf-8?B?QnBzRUhvOGQzUmNuREFNUytqMVdFcWtYQ3BScFFyZkdmbk5DK0hwNE84ZmxO?=
 =?utf-8?B?MC9POWlvSTB5RW5uaDh2RnVndGdmOFhGdU1uNGtlTm10THhCQjduM3o4cXht?=
 =?utf-8?B?WjRnUTRrQzRXSjc4N0lDN0lrRzJvRlIvUmlaYmtwU0l6dncyV25QcE45Vm10?=
 =?utf-8?B?RUozcHRSTVQzeFpVMzhFUGVXMHZERnNNRDU1bHR0R3JUK3lMV3JGSUtJeTFK?=
 =?utf-8?B?QUZRZHAyYXdyRzFQcW1ZeDV3cGpTbmc1T2UwbDNSc2R5eXNOeDZuTjZNSVR0?=
 =?utf-8?B?Wnh1TFJBdzFDRzE5T28vUzZmeTV4TElCTHZvbkM0M01DcUkyUHpZZUZrUkVt?=
 =?utf-8?B?UzAyeWtyRDNpSGI1RytlelFaZGhDQm9tMW5TOTV0MEx6eVZZZU5NeFJjUncw?=
 =?utf-8?B?Z1cyazZETGVlZmpCUlk3YVl3Qys4NUROWm5HOWx6VjRDdk00eGdaanJNMjR2?=
 =?utf-8?B?Ky90aHRJTXdUeTd0L1hsdUlweGlCUzRYeDh3dGhCVW1WL3B3U2lhUk1RZWlz?=
 =?utf-8?B?cVNMKy84K3RiVWlpWGtKVk1yclQyYW9uRTlmUFRiRkE2dU9EaUpsaFB5SWdz?=
 =?utf-8?B?d09uRklQM0tRRDhQNE9URGt5NnNSMHMzMXlJcCt1dzd5WDZEVnNaQ2ZHeDhP?=
 =?utf-8?B?bFF0ZVZEQno4S2h1aVN4Q2VFNEhLRE1ScjRXMTlZQ2pWVVZtbGJQL2cwUkty?=
 =?utf-8?B?S214VGlFWkpTdkNYd2ZFUjhHMWNRTTN3SC9oUTcyT3BuVjhkaGsyK2MxNzZo?=
 =?utf-8?Q?WRet6JMfz0qXkldFaTsJ3ZM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	VRHv35s1caqMy2xvxJLgJ7AJ83luapkyiLgfyrdOYxeUuq9zhqE9yW9BYoN+MiPDbAijssY0F2PCU2e34dpdQ2UWZueBFP/kXOCX3iMqvmCQKMFpCdXYGgR4By/a7Vr5NmWLIqAmmREIBBOeDlZTP0D4q/h0TDH77o0RyLIIylkeRDUIt9n6V1No9G3v+k2HclmexKZ+Pkq3Q5nJ7Gb5EBBuX0jco15N4nrgkGlQTLTKcYA4mhhqawc3bIogMFO92JlhWkO5kqNpdbBuXevdDRpn4KG9k+Lb8s9U0IBYqw9hzNids79T91v7Mdy+EgEBdujNbZkCVQm1RBCwNdOq8ApwZl2PuYwT1fk9N2cdj+1jiYF1dx71Y5HKw3C9qU2NLmH3aWHiEMnj1kj6G97+R/+9z8M0yE12C92nXHBICWK7OlWhC4HsfwIN/fz242gMubE91BbdBWSVKCyNgLHuro5kv/5hM13rmN0YjWld6PpARyV6SLRulUhYFd2KTtSRm9p2yHpRy0rUn6pvFV8PGL6cswxBJGy5vWTjHR3IPdc+qH9vomNmaMn8dxuw6ginkSXQaCtWMb/jliFfbqL9mmFKy9BmSgjlGnZQEzbm5OU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39d49321-1912-486c-4ca2-08dc26e7af2d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 07:46:10.0857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PWs1p+wlykjW+H4VPNK8Q/zceJuuNl8ZEKLrmXnXc1NBfnHo8w6b6D8aSChgk+1j954bfVECp7EJOiEsiJ/Wwq4pro7cx/ufg+Fm0qjLGH/kbW/N4SLSsvn7l0ic1eit
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4580
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-06_02,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402060053
X-Proofpoint-ORIG-GUID: a2WSCT7ukZbPHao9qlAWF3AjgjFNr6ck
X-Proofpoint-GUID: a2WSCT7ukZbPHao9qlAWF3AjgjFNr6ck

Hi Salvatore,

Adding kovalev here(who backported it to 5.10.y)

On 03/02/24 9:09 pm, Salvatore Bonaccorso wrote:
> Hi,
> 
> On Thu, Feb 01, 2024 at 12:58:28PM +0000, Mohamed Abuelfotoh, Hazem wrote:
>>
>> On 31/01/2024 17:19, Paulo Alcantara wrote:
>>> Greg, could you please drop
>>>
>>>           b3632baa5045 ("cifs: fix off-by-one in SMB2_query_info_init()")
>>>
>>> from v5.10.y as suggested by Salvatore?
>>>
>>> Thanks.
>>
>> Are we dropping b3632baa5045 ("cifs: fix off-by-one in
>> SMB2_query_info_init()") from v5.10.y while keeping it on v5.15.y? if we are
>> dropping it from v5.15.y as well then we should backport 06aa6eff7b smb3:
>> Replace smb2pdu 1-element arrays with flex-arrays to v5.15.y I remember
>> trying to backport this patch on v5.15.y but there were some merge conflicts
>> there.
>>
>> 06aa6eff7b smb3: Replace smb2pdu 1-element arrays with flex-arrays
> 
> While I'm not eligible to say what should be done, my understading is
> that Greg probably would prefer to have the "backport 06aa6eff7b"
> version. What we know is that having now both commits in the
> stable-rc/linux-5.10.y queue breaks  cifs and the backport variants
> seens to work fine (Paulo Alcantara probably though can comment best).
> 
Having both one-liner fix that I have sent and the above commit isn't 
correct.

> As 06aa6eff7b smb3: Replace smb2pdu 1-element arrays with flex-arrays
> was backportable to 5.10.y it should now work as well for the upper
> one 5.15.y.

Correct, I agree. I had to send one-liner fix as we have the 
backport("06aa6eff7b smb3: Replace smb2pdu 1-element arrays with 
flex-arrays") missing in 5.15.y and when I tried backporting it to 
5.15.y I saw many conflicts.

If we have backport for 5.15.y similar to 5.10.y we could ask greg to 
remove one liner fix from both 5.10.y and 5.15.y: 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.10/cifs-fix-off-by-one-in-smb2_query_info_init.patch

Thanks,
Harshit


> 
> Regards,
> Salvatore
> 

