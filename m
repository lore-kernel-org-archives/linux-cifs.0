Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9525154BF0;
	Mon, 29 Jan 2024 16:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706547150; cv=fail; b=WR+eTpNTF9+hNctNT4U/9T1fGqLS4rhletHhzw/WXgJhyDUKJLmjOwW4aXAhApCaT4CE+aJ3L32trl4FsyfREVydHk+ChIIndA20XXqHi8LQ51bgCTJIlNHCzU/QpV2AYOJe25B8BUGzLIDfDzf2C/Hh5efJpv2HcBoeqEiGMW4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706547150; c=relaxed/simple;
	bh=swBKGeBQYoGLEcM5S67KcsdPBpwcjRtPGfradq+RqGw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kNb4xU7BpllVnSTkb57d485VG51EzLJHeLeeVkfTxO986U1aTVg1561yfIu4FZQ7ksH8QPgU7r5y2O/4rXE7cYCI1znStx3vtxEBxcUaSapHwN2wwrW/KzFTMBI0fsxhukbeg2RtcBdu8DMJjkBLHoVIWCWu7Xh+1PUqGOd+jX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=h/MYCPla; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yxUnWQOM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h/MYCPla";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yxUnWQOM"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40TGmwKb007151;
	Mon, 29 Jan 2024 16:52:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=4+lSyDgH28rXgsMLfUqQE679tQwdMnCBl4EU3DJdzf4=;
 b=h/MYCPlatDupD+GCO9MwneAm3dJkgfClLRXSHRaBbZeqFr9TNryyLtibEehsltSY4D0M
 CgZwW5eAutTvzeeSojg/5OnAeYwUORQCxHL+hYCgKZoG+HEdCBHS/oLelsR+ARS+5SK0
 P+W15hPRdFQHi5J1ItE3p9PaQo4bGdYvmQT5Vh9XyJle7SnvpLB+NrfbKqaUQiiGbh7i
 wG6FcDjwaBkq/Fgd4WQPWe2qKAqG9lURrDaVwlf7qj4ZPMC8t9vO4nPWYLPAWLkaZtoD
 7PfBNZ/QuirwOD28VhUq8HjrhctbISrMSKOIrE6VRFD6HuUr4BMJEhb/fQ5Ds56GOHsU aw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvrm3veyu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 16:52:18 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40TG4G8o014564;
	Mon, 29 Jan 2024 16:52:17 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr95w021-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 16:52:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iEyMbuordprpAsaD1SFeeIHRnqvv1TqMArYANSLu813K3ZxTZ8hhBXK/n2pyk0XmGPpixsb1EtL3vEr4emm+JwApLq0sK9n/jxndGrPFuQPu99FMSkWoUyxUp5YfaFvqLAvB+Dc0mFid5x2Ol+8d5ruVHAcCm0ruaxMJN2bzlbLLoqOeTU+FAPLElEf0XedPKyFVulF9ZjfHT4Q9Pt3wfWnhxlHlpDeqke0+ujpU089l/4LHh3Fjw3/A6QpEuaZ4X7cdKZD5sPbvoPA6zNxWX6XM0zWjricqxuYeqo1TvhghEVrwpVFRerAfqWyTnpye9xH/AmRVx4JfrA0+GN42vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4+lSyDgH28rXgsMLfUqQE679tQwdMnCBl4EU3DJdzf4=;
 b=gZLsAM1IX2apuea6DQK8qlogDR6szcC/5eK7e6yxXkzq1WMSF3ctDFQlQl/bZC5QC5QBNRFaMN9Rik66WtDfjzSeexmrNVEQuTu96Q5LRzidw1LVrl4aQViR0RRkG0cGOu14E16hlRH55DYQXfftCnD6xNYHv4Sjy8txeoW386A+5JD9Hc1wengBsjEduLik79Nt2LmrB2lMYbTcswhi7frwAXYy4QfDtLiJeacTVKqDLMNkBOUuyAashjN8kmxPrGhAqKXC/2MqIs48xT/p0qcnXuf2JLTyOTVePswWs3GgEOuMqZpwwZvGW+wBBbm0MaeQvzjwMATUgrDmM3HERA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4+lSyDgH28rXgsMLfUqQE679tQwdMnCBl4EU3DJdzf4=;
 b=yxUnWQOMvY502n26i+qJw0ALBUMq9OmfVBRPY3LR7PiJfg/btLPYcDBO78ZNhbUw1crWdrslGjhr6zBXVDKM3jZuNcjXPz1Azwt1hUIgLCoTJ1PYDwgIOlvo0LMquETxkY/fLUdBsCJfdQbYqDaLwxShhAUEVKO+UbweAAW4DR8=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.30; Mon, 29 Jan
 2024 16:52:14 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::f41b:4111:b10e:4fa5]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::f41b:4111:b10e:4fa5%4]) with mapi id 15.20.7228.029; Mon, 29 Jan 2024
 16:52:14 +0000
Message-ID: <0ab7f5c7-1bf7-4291-adb1-d83f44a187e2@oracle.com>
Date: Mon, 29 Jan 2024 22:22:05 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10.y] cifs: fix off-by-one in SMB2_query_info_init()
Content-Language: en-US
To: Greg KH <greg@kroah.com>
Cc: kovalev@altlinux.org, stable@vger.kernel.org, abuehaze@amazon.com,
        smfrench@gmail.com, linux-cifs@vger.kernel.org, keescook@chromium.org,
        darren.kenny@oracle.com, pc@manguebit.com, nspmangalore@gmail.com,
        vegard.nossum@oracle.com
References: <20240129054342.2472454-1-harshit.m.mogalapalli@oracle.com>
 <06bddf4e-a15f-bf1b-b9e5-d173cdacf4d0@basealt.ru>
 <88f25b32-033c-4e1c-b1d5-18bbc2ec91c9@oracle.com>
 <2024012916-dictator-wrangle-e90c@gregkh>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <2024012916-dictator-wrangle-e90c@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0103.apcprd02.prod.outlook.com
 (2603:1096:4:92::19) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|SA2PR10MB4795:EE_
X-MS-Office365-Filtering-Correlation-Id: bc0771b2-faa7-4610-1ae2-08dc20eaa532
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	9QD6VZ+T8Puv5A++EXWuMJki43Wuec8ykGor4Itaj3n7dNNfAMZtlWoJjEyyXA7ED4dgU3ktMemweIJ0syjkOuyRcLGvodiN0pdorvLvQRBJfU5hhzT2LWhudY64b3rZBok5iMu986+lj8XNHIIkBN1t6U/tIT/dmn4yJTvdwtY9OAItAZGHjtJoTAL17o0TkNdb2fiAvSgCBva1j3yQzM/g0nz+TVpjdnskxrIclenkF5uU9g11ypQJDj9lrByduryhLnQQZDat9MfRkmCLUdAZFJTpxvIOzpBVcz4frYaI1mJBd+Okl/0SuMBfMwmZ8UQT14r86fFdqlMCPP2WEAC5F58mX/2N34TUsIa1jUBNGBikyyZstB6r+LgYtL+HHb0nFfHPb8Lt31C4u5iw36rIAY2EnC30C65etY/0S3d8MYhdZ5l2WmhEDpo+FA6NLu1pKHRSumzJfTMhuyWlvXaS+ASQVA85SUvVE72Ypt3ZWpsFfCGsoIwpVGvOAec3GBBk9ulRMFVIvO5ICSZqzzvxAU80W0+NAd+LvCmpoHam2RFsYuje7NwQevIKWMHBBMbCqD3RCBhN5zgXq3hPq+LIMgkAEOcg5SHVWnTR33y9RpDLNajSwBPw5CfqjAO3PIQyGHFWih0JG+9g9B0V4Q==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(366004)(396003)(346002)(376002)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(31686004)(83380400001)(31696002)(86362001)(36756003)(38100700002)(26005)(6512007)(107886003)(2616005)(6666004)(66556008)(6916009)(53546011)(6506007)(6486002)(2906002)(966005)(8676002)(478600001)(316002)(66946007)(66476007)(41300700001)(4326008)(8936002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Q0YwcEtOaldCNVhoZkczOVNITkNraXdtRVhlQWF2NU0zVm9lMStTSUpMdE9r?=
 =?utf-8?B?eHdJVlJiU0w2WEtQRi9DT2lrT0h4SzM4aE9BUWJFdndrdGZKUVN0akJJUjY5?=
 =?utf-8?B?L1UyQk01ZGFmUmM3YXduVkNQL1dGaTB2V25BRUhCY01ZMzVsSytzMnROK0ox?=
 =?utf-8?B?aDlZOGlUL0lIcUlUb3dnT3gvRmszTWlDc0RzV3l6UmY3cVIvelNyakxuVDBy?=
 =?utf-8?B?TjFSd0IzZlUzTWhlU1h6a3lVT0lhcWRVcWhTOU43MW9ObmR5UEtJNnBSTU9X?=
 =?utf-8?B?Ulg3QTU2VU1wL2FFVmVoeGhjTzV6VlJmUU9rTk95VUtkUFNxVHc0eUttRk1B?=
 =?utf-8?B?akt1MnBoVS85eW1uV0srREREUklQR3pIS3hUSjhnTkVrYkN0OHFYa2p4TUVK?=
 =?utf-8?B?NGUxZnZIZ3ltUGdqaysrSk9kS2JkOXVCdVZZSC92VS93YTlQa1ZrbUNVWTla?=
 =?utf-8?B?WDdNOGVvMWRWbXJzV2lROXF2RllKZElkMVRnbmN5LytDVU9jZkp3akdFSHlT?=
 =?utf-8?B?anZBMTdNbFgxTDFhN2tISGVudVlZekxoam5GenRUMFdLNE1XcTZLM3c2NWhU?=
 =?utf-8?B?dW1MQXBjdEtrVjVubGVZU09hSFMxbWlvejdZU29vY0lxUnNhTE43RHVtSGVp?=
 =?utf-8?B?N1FTT3BDdWUwMDBBRTV5WDk2L3lQNDRnSnU1MnIyTGU1bVRDMVkvQ242bGVr?=
 =?utf-8?B?UUpVRUFnMnl5K1NpalljMTh2eHhxamxOZHgzQVBQcVpyMXJRV1oyMmtXUWxk?=
 =?utf-8?B?YWlzMEppQS8yaTFsOW9wMGR4c25DR3RRZ2JIZUU3WTh3NTl6RXhpbVJramhk?=
 =?utf-8?B?QWdPZW93ZEplLzFsZk0xWDZYWHR1ZzFHbS9vZm9vakhxU3FxNThCdDRpbVNY?=
 =?utf-8?B?cHdxS2IwbU5KOVNxdXh2aEozOGpITEZjWkx2Mm1jWlJYMDFkSVphY3VYRi9P?=
 =?utf-8?B?WXZZR3k5WW42RlZOZUlFa0xoK3h5RE5GR1lyWXhFd2ZhQkRkQWcrcnBmUy9u?=
 =?utf-8?B?c1ZtS2RHTG9PcFNpN2FiMmxrQ0UzSlVUZ3pzUjA2RU02bTdCZ1czeko0NUhO?=
 =?utf-8?B?NW0vcmxsMldmeG56c2FFUVFMdnBxZFF6WmNGZ0xBNk95czN6T29ZandBaE5R?=
 =?utf-8?B?K0tFSHBtYVpUcTcwSXJYa0VqazRudUxLOXp6RHdodWp2RWRLSUxEYUlucWdU?=
 =?utf-8?B?QWo3SlVDbEcwLzZSR0RZK2xScGxQREIwcGVoNkpvbjVWaVZld1lkZDRzTWcr?=
 =?utf-8?B?cTljcGlyR0p4Q1BzeU9BemJIS1dudlIrM3dGZFlKdGQrTGFYRVc4N0k4ck1L?=
 =?utf-8?B?OGxNYXMvZC9lYVJMejd6VngyOWEwd2REVVNWd2lQcWw4TndqaW5EQml3akFE?=
 =?utf-8?B?TkZzbHJxdlNJSGxmeUZJMmJvSUJQY240R2JoSElLbzlCVUU2NWIyQzNuNEVB?=
 =?utf-8?B?RklqcHFmTzgwUTczdlVsOCsyMHYxU3pDYzJEL1pKZDdQSDdTM09tWEEvWWp3?=
 =?utf-8?B?UU15Yk1kck92eXo5RGFrVmRMN1UvZE5nbUZ4YnhwaTl4VkNyNHJtYTVKd1Mr?=
 =?utf-8?B?aVpDdTNOT0Z2aVl0RUx3Z1IzQ3c1K215U2lnaGxHWkQ4bURENnZRaUlEQ1R2?=
 =?utf-8?B?ZU05NkUzN1l5UVFrWjdyVUJrZUtqa09NOWY4Q0Q0ZlVubEQ2SjJWSjYrU3Fk?=
 =?utf-8?B?WHhzTEYxWXpYUVk1a0VDQ0JJNnNyWkZaMXd4bmhHM1hYT1Y2YWdYejZESXpW?=
 =?utf-8?B?ZkNrelVSLzBmNHRBOWpyaDBIb1ljSkZIK2s2aVpDcDc2ZG5LYS8xdCtFNjFT?=
 =?utf-8?B?THpTZWgvR21rQ1RBRkNub1FXZnJSN29PUTQ4MmRDWUN5K1FzNnoxaGxUZExP?=
 =?utf-8?B?NCtiUE1MUWE1SXlIMkZMSVdCeDBaSVJLUmZ4cjRUMitHdlhXL2piU1YzYzNh?=
 =?utf-8?B?N0c2VnZJNmdmanhCbGFlYjY3UGl1dnI1RnB3MkU4RjgrVzBjNEQ0UTJwaGZv?=
 =?utf-8?B?STkvUFlYUi9QUzFMZFM3cjhWZ0dpVmR0bHYxUGZLVWkvVW5MUk1yanJOOHgx?=
 =?utf-8?B?THc5a1lOVWFIT2lwZjdvMFdTOUFOR3QzaGhUKzR0SWtYV0hmL3VGQy85Yy90?=
 =?utf-8?B?N1BXRnpxWURiYTZFQW02V0Y2UlozYWFCZmpRZkdHRGtUSEw4R0k1Y3VEaWF5?=
 =?utf-8?B?UVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	cywfCzZAVJyU6LhIbpw8aXnCp+UclDB/H2dywvJ3JxwCI0mgPJXySsIcn69lMPy4jB7OntPIAfpEaSwlNjYwLxf5hHi5ZWH9fZ64I0st98YpWa2kf7O6t9RE+/roCbcVn9XP7qmZQY/DNczAH+3ftqxk6dY7bdnntn+WY9pKSie3sGyOt857gc3ynvdAJpBV5R+1oD5P40xoXg2wiZUrHBo0lc0v8blXlqbpvp0YDHShywobfP1KsjbE2LSsSExwPqlD6o0RG82lYMgMlhvB27k1cun2JcaRyEoxTGWqWpnWPuYX5WcxhiUQLkcOJQx4DmBG3KJg5RiHCcEh1BSt/k/QKkL+6K/DX6EH8eFO6nOA907qjJRfL2D8emmv2Ksel7BW/MY0jZT0BZFj3cucXDuaUi/52Z/p7Z3PjzjItZf8qc5ade22mQtrYYjdGlv9ATjOFnNHwE6WgaIymUpSEddTFspCykQLJRYF23j+d7sjueIzZgRQ246JjkZh8zT+KmBfUzwtwCrF51ez8xbUZAypz8uFgDH8JzBTn4bwZM7geX1YgQi5baKzuhTA0P2WKJxZ9AIE/QBhx2dHhaobeFPYyT+VWlAPB55phC0kbuI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc0771b2-faa7-4610-1ae2-08dc20eaa532
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2024 16:52:14.8547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: msIOY7vvI1RTnTtxufCYG5d1qlQ7+43EQM/iAMGpTOv348bzGFMGE+ySjzEyh2CQ1AJ8NwCtN/QN/pqgVD15u3Qy1NZ2L3MnRl6zuQ3JDDR3ImQlweTQSC+oudSeoux1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-29_10,2024-01-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401290124
X-Proofpoint-GUID: pM45a-Tz_TCeV2giHGqhIABa8wSR2Vp4
X-Proofpoint-ORIG-GUID: pM45a-Tz_TCeV2giHGqhIABa8wSR2Vp4

On 29/01/24 10:07 pm, Greg KH wrote:
> On Mon, Jan 29, 2024 at 09:57:40PM +0530, Harshit Mogalapalli wrote:
>> Hi Kovalev,
>>
>> On 29/01/24 1:49 pm, kovalev@altlinux.org wrote:
>>> 29.01.2024 08:43, Harshit Mogalapalli wrote:
>>>> This patch is only for v5.10.y stable kernel.
>>>> I have tested the patched kernel, after mounting it doesn't become
>>>> unavailable.
>>>>
>>>> Context:
>>>> [1] https://lore.kernel.org/all/CAH2r5mv2ipr4KJfMDXwHgq9L+kGdnRd1C2svcM=PCoDjA7uALA@mail.gmail.com/#t
>>>>
>>>> Note to Greg: This is alternative way to fix by not taking commit
>>>> eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with
>>>> flex-arrays").
>>>> before applying this patch a patch in the queue needs to be removed: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.10/smb3-replace-smb2pdu-1-element-arrays-with-flex-arrays.patch
>>> Maybe I don't understand something, but isn't there a goal when fixing
>>> bugs to keep the code of stable branches with upstream code as much as
>>> possible? Otherwise, the following fixes will not be compatible..
>>
>> I agree, but at the same time we also should observe this:
>> eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with flex-arrays") is
>> not in 5.15.y so we probably shouldn't queue it up for 5.10.y.
> 
Hi Greg,

> It is queued up for 5.10, but not 5.15 for some reason?
> 

Context: 
https://lore.kernel.org/all/472d92aa-1b49-43c9-a91f-80dfc8f25ad3@oracle.com/

I think the above commit eb3e28c1e89b ("smb3: Replace smb2pdu 1-element 
arrays with flex-arrays") got queued up from the above backport.

I did try applying on 5.15.y but I noticed many conflicts, so I asked 
which is the preferred way:
  1. Resolving conflicts by backporting above commit(flex-arrays one), 
which touches more code.
  2. Or go with one line change.

I thought one liner is is a simpler change although it is not a upstream 
commit. Steve French also agreed with approach 2(which Paul suggested 
here [1], so I made patch(approach 2) for 5.15.y and 5.10.y and tested 
both after patching, they work.

[1] 
https://lore.kernel.org/all/446860c571d0699ed664175262a9e84b@manguebit.com/

Thanks,
Harshit

> confused,
> 
> greg k-h

