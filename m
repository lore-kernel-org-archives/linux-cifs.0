Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805B814AD0E;
	Mon,  9 Dec 2024 06:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733724067; cv=fail; b=jIHwV72QuZ5PsEKg3LOZqYOhCqFLSbJz59pV28jJquZKMYx08NLdlwvwX98urB3UQTgfwTmftONC3G7JuJrQYK/UgM0+yarIAfG2Lo8WFUU5mKmnqNI4k1vRU9+NowZuvETHKkG3WI7LW2Bg8DdgNshT4szS+Rh0Ejj36rP+ZNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733724067; c=relaxed/simple;
	bh=ri5Es8upk+V/2QG/AMjOnS/Xl5YEA0E3DnLppGekS7Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ig2SRCsI005L0LERh/DCFL6czru7PANrQmwkklu1nfGyzMaT/OXaGfWX6rTZ0CGrb5AOF4uBRBlm+c/3R8dBK8eGkTh6CaX1OHrPuEK0F3N0Jx2ETZ1Y5XVCVheMBXxqL/vZduybGMjN0NGiIczX3fekITUpBQooOnXmPpljvEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=P0/y3dWM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DZU8BaUg; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P0/y3dWM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DZU8BaUg"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B8L2QEh029019;
	Mon, 9 Dec 2024 06:00:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=N4igpVyGsosKVKVI3+c+IjZZI0TTrVslXHDuwdwxY/4=; b=
	P0/y3dWMCrIYeDlaxyqt1AP0bQ+/KjhbC2u1hyra3MAt3J+eZvvd3rLMPFZr2yEk
	hHldun8TNRYFaF56yToProb22ahc3gCkxY+CJKgG6pBDTiQtt4S5/2RJfSKQXvbO
	v0ZxjofryU36rzmhscZRVpBw6rU2LgjmRN3sM0qyghxzaL28VLDYTVlu7zQLgUph
	+UBGV1WzBd/1r+ML03yS7OrwbP79l27lYkwoZ4RCjZpO2JVISeICvpXci/6x1ojf
	R1gx6/z3VI7ZaALw1/v+LhLydSf1aqjkahIzCctpgsz9XSshIQwUBcI3Sj1rf8gA
	Q9p7ZjSO/nftVa1uamacEQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43ce892e40-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Dec 2024 06:00:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B95PZgl019329;
	Mon, 9 Dec 2024 06:00:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43cct6ukmr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Dec 2024 06:00:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eGsDCLfETU7BhT5Qv8xo41/KDyzsxPIvEFeBrjA6FhOo81fE2ICyNZBl/ryltGWuV7RqbLmIePgAdZkSJ+dcuC+RgydgwvPRJwnM9/C0TeBfZpSJalil6APzQOYCnFEgk2p0pFiO5vPbRkhH4PXODcQ35fuHzbt6wKpTHbOp6fajCHWOo96zTkLsKIG6U/Me2Gl2Tg2e73o3sOZDTCk0L5usxvNiHrC0Q2ShWiAYhUXoO1DnYeDu4y2xX6asDCp7VVB05pn6/3ZrYUwi+flHS6gGeRDF4SwOc3SKP3ov52T8lkjfVWQeeDWsWeDRc3Upa1luTIetoGDVttatS9jX+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N4igpVyGsosKVKVI3+c+IjZZI0TTrVslXHDuwdwxY/4=;
 b=ASxc9HH3T4mgsk9aX4UZYoLI89554jXQoq12iOcYvMstMzXn4HbJ+ZapU+3Lf2fObwQeWJGk/I/TZh/7m1HGpbi7++vOYAVjXPW/q7BqOmBzLfXh7YkKkgolUzWhb9OMIfflDWmdlFEejKlGyzFDqsa3JqucmCU5ye76hps6fvSu/LIIkZoqsNeTQJeE4iln9XmbRXkNKRH4xv8NoX4/d/nb1SEgfOgMU11OifwxeJcOmAfMAGKRPbzGvhN5NTclz00EQ/IWBWUDnYs5nk5IuozCgOvBPmSyTozS7xpxMYVIRP4hDwpPn8B1hhat8Vi776nkNbSOPOD+NWvtM3Jcdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N4igpVyGsosKVKVI3+c+IjZZI0TTrVslXHDuwdwxY/4=;
 b=DZU8BaUgZsU4+ih/Qf5PedN9TWzJhR72V6Ii9KhW9n/hVh50j/WqDvPXuRzvnU52Bue2fTPUzFeFDe1K9JbA/khpvp1hDk1rhTgCxBa3dATC4SyAdq1Myhz6FsWL/7KLVw8Nuks8zMMt9/w8VfjVsgxGSbtCzDfz7hv8i21CEfw=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by LV8PR10MB7991.namprd10.prod.outlook.com (2603:10b6:408:1f8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Mon, 9 Dec
 2024 06:00:18 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%6]) with mapi id 15.20.8207.017; Mon, 9 Dec 2024
 06:00:18 +0000
Message-ID: <b5748a5a-3ca9-4cbd-8391-864909c98e6c@oracle.com>
Date: Mon, 9 Dec 2024 11:30:09 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1.y] smb: client: fix potential UAF in
 cifs_dump_full_key()
To: jianqi.ren.cn@windriver.com, pc@manguebit.com, gregkh@linuxfoundation.org
Cc: stable@vger.kernel.org, sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20241209042244.3426179-1-jianqi.ren.cn@windriver.com>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241209042244.3426179-1-jianqi.ren.cn@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:3:17::26) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|LV8PR10MB7991:EE_
X-MS-Office365-Filtering-Correlation-Id: bc7a755f-0679-4d5f-8d52-08dd1816c214
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cjY5VmRlWVdYV1hGSW9rYjFkZk1hMGZ2TFJrTmRmZkJxV1hsd0xTZTM5cG81?=
 =?utf-8?B?ak5WaTB2YktwNXNVZUd5cVNTVjR5MXhITDc5NzVDSDZRYTgzU3hFaFdGU3Jj?=
 =?utf-8?B?RVV5V0NVamZ6SmdmVUo1K1NmWnk1YXEzUmV3S3Rtb1dJOE9EK1c4SjN3QXQ3?=
 =?utf-8?B?cy9TUDVXVnVDSXFFMURiYnMzOEptZytLTlpaTzV5NmRJb3N1MlhlQW90b2tq?=
 =?utf-8?B?Mzkrbys2M1FXRkwxZy9xOGRoUjRzaWRvRW4xb2kzS3FsSDFlcXYxUHBBYldZ?=
 =?utf-8?B?YW9hN0lidW9ucGw2Rkd3MVFqNjIwRlp0UGpVbUt3ZGpUbGdWZkZySlZXR0Q5?=
 =?utf-8?B?WWRMNVh0eTJ5TW1oWElGRDRsT1JTNWltc1NwQmlSUEpXSzdxZ1Q3VmluQ2NQ?=
 =?utf-8?B?MXZIODlVdkJ6M21hR1dCQW1jc3NPSWEyenB4WDRpZmVuTUlFZ3BqdW9ad05o?=
 =?utf-8?B?R09sQW8vUnorNkVKZlV0YTl2MlAxWmt3YnMrOWd5eXZ0MDhFRWZ5K1FTcFVH?=
 =?utf-8?B?N0dwN2ZEdWFPQmhMbVQvYzdiSFFsYkp5M0FVT0JSa296SnhEVkJBeGtzVzRu?=
 =?utf-8?B?YWxEUWxSaWptaVpLbVFnQTdtSStock5xV0MyRE9NYlh4K3VwN2JXUjFNdzF2?=
 =?utf-8?B?cVRVQlJyaU0rVW8rWCtyWGJmVEpvak95NDBvZEhvL3hEZWFOa0NlMkl0ZXB4?=
 =?utf-8?B?cDVtM3ZJZWd6WmVKbHlHNm9HQitQbWtyd3IxaHVtRUtPSUt3Y2w4NXRkV0Ju?=
 =?utf-8?B?QVM1WGdvNFBuMTNKV2hYWmZiazRiSm5qU1kxZlQwTXZGYk9HMk5zVEQzcVFB?=
 =?utf-8?B?bXNHdjl3bjdIT0RPRklKdGJhNjVObHdIZHBJZUhTODRQZlBrV3E3TFYwY3BB?=
 =?utf-8?B?YVBFRnZ6LzFnRTJNNzlrRFJ0NDFtOStmOC9RRlZ0MVp6aWRBd0FlY0hjdUZJ?=
 =?utf-8?B?UXpRbmd5R0RuRTZzcjB0YjVZUmJESnVpbGJRZElxeFJlUTFKK2NncnV5RjVI?=
 =?utf-8?B?OXdQWFJpc0F6bjV4U1VvZ1poRGJualRUVS90UVJLMlJucS9JTEhPb0xhQ3g4?=
 =?utf-8?B?WUk0VWxMYzUrZFVTQjZNZE5yUVhVUXdpYXp5aFRjZzMvVUdwVkNlWGVYMU5L?=
 =?utf-8?B?Y2hsbkdCMGJpaFRmWG5oSWYrc3diT1NjREVPQnVkNWJuVnhkVFBhTDdReEE5?=
 =?utf-8?B?RjVqZzNYL2ZDb1RsQi9IVWpJaUFIWDI3RkptckdLL0dIT0ZTNmF0OHpEdXpa?=
 =?utf-8?B?STJucUpqWFlQWVBqK0RieXluWVdTRzBjdGhTT0ZKdEJ1cW01L3YxS1lTSVJP?=
 =?utf-8?B?ei93MjEwMUJ1YkhjTkJqbE1IVy9GM2JQK1VZWWp3S0JMZHd0aFFuSDJTOVRx?=
 =?utf-8?B?aDMzaTRpYWE4YkZZWlN3VHdUSllxZGZYZVpWejdqVHFybCsxK2JkYVpDdy85?=
 =?utf-8?B?VFhHMU80b01LUDlPL2hvamxoMGlpenRRS1FYTkEyTDMxQVF6MGVNSGdRbTE1?=
 =?utf-8?B?YTBUMWNjUFFYaXdnclBYYUplOUZGcFZ4NW4yUEtMMGdNamtJRlhVYlBTMEZy?=
 =?utf-8?B?TEdMWDdWcnJ1MUsrcnNFNlhMdEFMTzc4MWVJcXpJN3pDSzR6aUFYUnhYaThW?=
 =?utf-8?B?VlJzTjFaNjI4bCtkTGdJWHhXVDdkL0J1OGRHeHBXckFGNWNMR2hTOUliNERF?=
 =?utf-8?B?VVhKeVhjekhYZWVFVkZDZmYyYWROMkd6NjlWMGo3aUR0M2N2TC9jZnBpb20y?=
 =?utf-8?B?eVhIaTF0U2lLQ0l4emwzNDV0SWg5Tm9Lbzh1MFNMcjhNMzVJK1lMOHRPSmV3?=
 =?utf-8?B?Q0JKQ0g4T1hkTEJOMDZOdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y3ZHamtPYytlK0tzdi9wU0VNOERoa0JaQWpkTVF1UjkyNkJyTGZ4SytKOTZl?=
 =?utf-8?B?Zy85eitnbXIzQ0N6S2pqWExZdWJEbitsY2NxOFBsMVZqN29NOVNtTHRKYzhn?=
 =?utf-8?B?QzI1SVVDWUJCMWpNNWMrTUxZbFB0a3hoRHB0TURDc296cWZJbzROVnI3UW9T?=
 =?utf-8?B?dTBrMm1Hd1h2MXlqYnNUQUpWckp4Y3FnNXVpMDF4YjZmY2pKUGF1YUlmd1BV?=
 =?utf-8?B?MjNrQkpnbGFWWGt0ZlEvUEYrcGMvb1R1SDBCazdwdG1BVDJNNlVIYlZQQlMw?=
 =?utf-8?B?eEhBT3RXRjBiVTBrR08xZVFaUyt0U3kyZTFpUWp0dzlla2YvUUo4OW1JOHNl?=
 =?utf-8?B?NnJvWk5scUNERENPd2ZzL2JsMlBhNURwMlp3NHlDUGpuZzEwUnRNakxGWXlE?=
 =?utf-8?B?OE9kOW1ORThHMW43YnROR1d2eEtSWjhveFF3NHgzVmJjd2dPamk1dzlvRTU1?=
 =?utf-8?B?TXBiQXE3OGErQitXQmlHWVRGSG5XaHhVSldLVktNMGU3SDBMUDRCaW5jVFp3?=
 =?utf-8?B?M011WkVUK0RGcnJkTW5pbTVQTjNNZWN5eWlBbmMvNEVpSXJRNU90bThBYnBk?=
 =?utf-8?B?amFwek90Mk5xellvZ0FsUXRSS0FoQXRFekpEM2plUVRQbjFXaVJqZWZBK1JJ?=
 =?utf-8?B?RTIvdDhSeWtTNHNGZ1h5ckp5T0dmcjB6cHd2SzJodmQySEhSdG1HY3k5bG8x?=
 =?utf-8?B?QjVKN0oyMTMrM3Y4d1pyK05sa056SHN3SnBQSDdMMFg3TkhnVmkrNHZoOXJE?=
 =?utf-8?B?cU5uakhVemdaTGZKdnNHTkg5VEFLYVVSVEYxUmNnRUtRVFZBdm00RjhoVEpn?=
 =?utf-8?B?ekNpR1hRSnpvL3FKRlptSnlZblNrbUV5TlpIdzVNRTJ2bmxzbGR3RHV1UVhI?=
 =?utf-8?B?M3lyelJCNzgrdDJuNjFUK2U1YVBTUkhtbWVNY1ExNjFna1ZNamhaY2RieGh2?=
 =?utf-8?B?eGZ6R1R1aURlVk1Ea1lTZTlhd2F1ZTBYZWZ6Slc3QXpmVVc1OWhjM2ZoRG5Y?=
 =?utf-8?B?aXFaMndOdDNKTnF6T2ZrcXBFMUNRVTF5b2NPUjlybWhMNVlQZ0RXS3FqQkRt?=
 =?utf-8?B?YU92MEdnaklVWGdXanM1U0VQTmk5MDZydG1ReGs1UUxjcFhKQytHQTJSRm14?=
 =?utf-8?B?dHoxaHRXMFZOU1BvQitCUGpEbUJWbFhOdDkzNmNGSy9BSUtObXpUY2N2ekxm?=
 =?utf-8?B?d1ZrRzBzVmxPUUZLSTArNmJRM3ZtZ2k2Q1JBWk0rYzhMYlVsRDR0RWM4STBU?=
 =?utf-8?B?NmozR1JMbzlCYlhjT2FBUWxkcjVOT2ZuczhjNEp3TExaRWRuanpoVUg0dkJB?=
 =?utf-8?B?KzVPVmlRKzFTZWEyWE1uNUlzYW0xc2lzVDgxVHNjMnFpWmxtTm9FcWdqaXdO?=
 =?utf-8?B?ZkdWWjFBeTRiNkJGYkI4bUJFczRhSXRtaDZBNTdya01ZREtqeWIzOXU2UCtM?=
 =?utf-8?B?SE9JOFZweXl1YzFCUEgyMWplRHJSNlIxWS9sSnF0SGRLSVUrWVpVRlduRkNl?=
 =?utf-8?B?SFJISktGWDBxNVlmSk82a2Y5Z1lUTHFTTGd0UkJVQ3lhTFBSR3hRVDk0b05H?=
 =?utf-8?B?bC80RmNwODVxM3FVckkzMkdNUlBLRENCcVA1dERkY0IxVThJdkx2dU9jZHRa?=
 =?utf-8?B?d0NGc1pWRWRDRWpIdWZWeCt3WUhhMUlnd1h2R0ZHQTd0TVJYNjArSk1rL29I?=
 =?utf-8?B?Z2haVlBFb21qWG91YW1IOXlzVldJV3ZNamx4VzVCT3JNVUJZWHlWY1ZTMzJB?=
 =?utf-8?B?Z3ZxNlhxdzhVclM3N1JDMFVobHJwUjdxWGhmdGpsUFo4TVVXdXNESEFmUWtQ?=
 =?utf-8?B?ZDhXR3labWh1YUlBM01JUlRhYW1wQUMxb0xmdFU0MzhwemUxMlFmWTV3M0xD?=
 =?utf-8?B?ZlFMTlQ4cmFGbC9HMjhWVmtycm43Z1JuT2dmWVE2VGFURGc0RHRlYUpTRHJ6?=
 =?utf-8?B?VncxUTNKdTlFdit2TUJzZkxadkFSQkZxWTl2d1EwYmsxRjNDaUdTYzdzZmhI?=
 =?utf-8?B?OXpKUnI1c01iRElyMFF0VEZTNS9GVGo5YytQY3pUTHFSRWNiRDIrQ1RGcGdY?=
 =?utf-8?B?ZGZabXE4TFI0TGpLam9EQndvcnJBdGh4U0NXTGgwU3h6NHZ2Z3p2dU1YbkNV?=
 =?utf-8?B?WUFjTDBOeUhoL1o2d1BCV1ZYSXJlVUFXd28wL1h1RzNlajJQciszaHd0UW9i?=
 =?utf-8?Q?ejj6WC1IADauN/Qrsp5laEQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TM1/u5zNduAYuV/VrbTO7EKwq3TGxuGAkhov0IFqec4Nv7Mji2w+puWL0HSvDwcddaxYnxSvOIno3mM93EIoYsFTX4PUa28KL/UBPDNfLeobu/BLu7NabPPGQ2ikcrVZZ9Yvc1L7XoiP2i4bczTxKpQQjNdmCn0h3zs7bjwnDrhK4BvLbguKqSHv5jQvRPE+jpUVw60rVXB2b/UD1E2eNn4En9lCAjuNbzHMuaDu6M08TIq2YU3MZr2CtntlR7oRXCLrCcg3sUJLGesKMMqTcA/sgVFw9++1t74NSbZHDmQnLZiP1BtXYdHF6QaHZN98YFw9xkSfL3jYZS78JXL9/IJLN3A2hq7787fep/cC1rBEhMHeRDyG6QZRBxkVNSQmIOvf9vyf2KM59PoDVNK1ZGcg94kXqrydKHsmmAOflJi+f7vbSL/j4azwjnYvilzJqczjgrJNHEU+IMwIQYtaGGkvhp1lH08KA/c8muKRl4bP9g8s4Fw0LqyJYpLo78SsTtmnJjqpnt4M1mUpmmIG3z+u8nSZpPXaUF1cpyHrXDNuRSqwjmDLpcRtl0I57/zZBXjWwL6nxUYjDenninTZheYPlvhMIXyOYwtJoJ5dekc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc7a755f-0679-4d5f-8d52-08dd1816c214
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 06:00:18.4613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9J2YDjlvTWSltyAsLivPC/a6X5OG9Fx1H546DFZGvy7NFVSlpz2/bnamiI5ykQUAXMDWavQej+zyKJvIUZdtxlRqQJfKKgtoLJHptMdeBtAHt5XLMqkBtcT8+BX7ya1W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7991
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-09_02,2024-12-09_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412090048
X-Proofpoint-GUID: OsU-3YXMVt9l_U5BZ2iIeQSzPbHql3aE
X-Proofpoint-ORIG-GUID: OsU-3YXMVt9l_U5BZ2iIeQSzPbHql3aE

Hi Jianqi,

On 09/12/24 09:52, jianqi.ren.cn@windriver.com wrote:
> From: Paulo Alcantara <pc@manguebit.com>
> 
> [ Upstream commit 58acd1f497162e7d282077f816faa519487be045 ]
> 
> Skip sessions that are being teared down (status == SES_EXITING) to
> avoid UAF.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
> ---
>   fs/smb/client/ioctl.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
> index ae9905e2b9d4..173c8c76d31f 100644
> --- a/fs/smb/client/ioctl.c
> +++ b/fs/smb/client/ioctl.c
> @@ -246,17 +246,23 @@ static int cifs_dump_full_key(struct cifs_tcon *tcon, struct smb3_full_key_debug
>   		spin_lock(&cifs_tcp_ses_lock);
>   		list_for_each_entry(server_it, &cifs_tcp_ses_list, tcp_ses_list) {
>   			list_for_each_entry(ses_it, &server_it->smb_ses_list, smb_ses_list) {
> -				if (ses_it->Suid == out.session_id) {
> +				spin_lock(&ses_it->ses_lock);
> +				if (ses_it->ses_status != SES_EXITING &&
> +				    ses_it->Suid == out.session_id) {
>   					ses = ses_it;
>   					/*
>   					 * since we are using the session outside the crit
>   					 * section, we need to make sure it won't be released
>   					 * so increment its refcount
>   					 */
> +
> +					lockdep_assert_held(&cifs_tcp_ses_lock);

^^ This doesn't exist in upstream commit, why is this needed ?

Thanks,
Harshit
>   					ses->ses_count++;
> +					spin_unlock(&ses_it->ses_lock);
>   					found = true;
>   					goto search_end;
>   				}
> +				spin_unlock(&ses_it->ses_lock);
>   			}
>   		}
>   search_end:

