Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D29F13AFF;
	Tue, 16 Jan 2024 10:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cu4DpmLD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LsFjljdo"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40G6hulD010767;
	Tue, 16 Jan 2024 10:23:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=18wJtvzBGKsKjO9k2nkJ+BYFCv/4ZNlwCENA3+QeNvo=;
 b=cu4DpmLDMsrB0bXOTRZpgeznEG0FVtT7IoRo4sY3zYYl1sDCDc0w7APEvoQJ1KUBB+Ya
 4uk60tdwM3Udzwbjo5MSLpiHLswMi8XgL8v/SqKve0GRkbZe8EATPptYqmQpQcTRPct6
 hrz+gI8GA3U4DsRYp2eXX2/4spKuLimdbvJy+Dcn3fGdWiBWHloBLL62N/jDCbjD9wzD
 1bi6H0fwOzj9TIzBldubR7wJlFNi2lSeU7vS4CbJTJ5oFJvZ33PrPjHoiJ3V3TZ90aUs
 ZcsR7ByRvqyjGs5cMWtxdnZ1jtn/FYURCZTGKGCyOyb2Jn9q5ykEPA9QguNMExwl+8iJ Lw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vkm2hmas0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jan 2024 10:23:35 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40GAF51m023357;
	Tue, 16 Jan 2024 10:23:34 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vkgy7nrsr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jan 2024 10:23:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kdo0BwmqyTaBxqQbTNlLTfRV02irM13iriSQjUNfqbXr8AVycS4qhMuWW4MRsB9/63XeKoxzxurDp2CqfKgqilON8vgYPkd/AbapyFdTg86IKtp+0+PfLqTZTUu35VRzwsLAsR/OJGMCrkXtHkdsB8EyZQZxM7iqYcXMcupmI30Fg8VrMBsp2cr7ju8HexcuPFbfbhwdEdJLV5LtwG2LMIa0yy/5MMvk6lMI97wIbzhdllu2Vyd4uPtA/MzBUOdhg3SejWOmXWT3qHSGaXFZLToHMhsbqBky/dbeI22kUO+52SgAsN+H90vYcR0yeUcWzC8xQIHWq6G9VIhuYo0+Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=18wJtvzBGKsKjO9k2nkJ+BYFCv/4ZNlwCENA3+QeNvo=;
 b=EeNg5bH44hPNzMqn+b46F63Hz9jQ7re8uiqV/eNcUIDlk1zMOqTVRclKvPMwEh59TbJv/sJEYSKn8IV/yum/v6gebWIxLj7/hd30BDJ+7/LRJrdRmKrrTpf1QckkdSYn6BKEw8kfZ0DTqRfdqWA5+dIHVNUEYZLPZl0lmDG9QXReqLZvq5p8+re/b44+DhNnVVPubsroRimgVwO5OTcmxXxpVArFIVIGCCR8kcjiwQlG2znVA/zJp9VuN8vE+SRO7KXpGcJN4GKBgcD1VkQNxRX98pLrchHqnw3uWjhcoO6Rsk0maWJK2xyb/ZqvCNuoGroEEHeYFkQNl9mrbor0eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18wJtvzBGKsKjO9k2nkJ+BYFCv/4ZNlwCENA3+QeNvo=;
 b=LsFjljdoIv/DOpl2QbNUaCvCYndr3EP+us8AKiQCh4b4rUsR4jJWqeExDRbochKgUey9Q1fqJ55xjPdzep/1EeSHHd3aQ3gLBTYRXdzsyED1suHxTiW6dbwXwqqcDcCASwaZm4ewlqhRxF8Zlc185m6grnAsLqfmEQXSGLoDJRw=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by SJ0PR10MB4574.namprd10.prod.outlook.com (2603:10b6:a03:2dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.26; Tue, 16 Jan
 2024 10:23:32 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::f41b:4111:b10e:4fa5]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::f41b:4111:b10e:4fa5%4]) with mapi id 15.20.7181.027; Tue, 16 Jan 2024
 10:23:32 +0000
Message-ID: <09738f0f-53a2-43f1-a09d-a2bef48e1344@oracle.com>
Date: Tue, 16 Jan 2024 15:53:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
Content-Language: en-US
To: "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>,
        "pc@manguebit.com" <pc@manguebit.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "leonardo@schenkel.net" <leonardo@schenkel.net>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "m.weissbach@info-gate.de" <m.weissbach@info-gate.de>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "sairon@sairon.cz" <sairon@sairon.cz>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Ramanan Govindarajan <ramanan.govindarajan@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>, david.flynn@oracle.com
References: <53F11617-D406-47C6-8CA7-5BE26EB042BE@amazon.com>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <53F11617-D406-47C6-8CA7-5BE26EB042BE@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:4:194::15) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|SJ0PR10MB4574:EE_
X-MS-Office365-Filtering-Correlation-Id: c3c22d94-0efe-4d69-25c6-08dc167d30a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	JocQn0RwV5U5WgcxlqO3mwGYSDcBRPZdd1DLcqT/8mr98sWooTBBluojNO8GVuhlmzoDkmA5fHxcwV9FDRQ0AlSStSHAOGfV+h0y3G75uqykgG5jPef/lIXlJHNzdgVIu1oaCAKLa84XoH061hW6Tti57wn5zNszT3ToO+HCSEzKu+TfIV0/946pE3I5SEQD0Hgqz5Bo/pa6CuaNCKmLaIGc2Z0SPdge18+GWyhwy6cIXM7E8FrxXnfPMc39SXO2yncunmknqQPVpXfDFiotfAmnhYPo8usQVu5k5nIqffJBAWl5o7E7R2h0zcXUsrxechkF+EM2S+hPhc0DumnffSD9fWvYn4/xUSdDKYReWN6YNZVqsI4ID+z6W/8VQbYGWVcBN6iz6PyCFG5wyGrhaxX+S74OJ2QKspXi+jYg7gGPe85p4aV79cFw0GxSBfIUjyeHDS8sededi1kO+jfxbbaueIbQJ34diFz3Lo8gh4qXJeTmffdEGwOm37CIspaEVXI3cZna7OU/FCTEM+pmSZFdhXWSaXwd2Y5G9PqJhUn+AKXzO8rECp61n/r61zs29wEr4NWsnPSFkfTXI893dQcCv0WUhL+3yUG+nUE1PmWp6dSAebDZO2Gl43yrPicdkyPkYIZvE4IWACFJM/K2BQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(39860400002)(346002)(366004)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(31686004)(6666004)(478600001)(53546011)(6506007)(6512007)(107886003)(26005)(2616005)(86362001)(31696002)(38100700002)(36756003)(966005)(2906002)(7416002)(4326008)(83380400001)(41300700001)(5660300002)(8676002)(8936002)(66556008)(6486002)(66946007)(66476007)(316002)(54906003)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RDVUTm95dUZiZUZEQnpNQk1tU0N2blE3Q3ltOUI2UkNmclJXbWpNTURZQlM3?=
 =?utf-8?B?Y0wxVmxnR1VLTVk1VmR6SEZ3dDJGL2UxZ0V3Um1OMEs1YnNCbnBXdGFMQkQ2?=
 =?utf-8?B?NktsdlBtQkdrZDFIVE8zODgxbnorRnB3MEFtZklIa1BPRWxtbHp2RHMxMlYy?=
 =?utf-8?B?emw3WjhBRU85NlZqUDgva05yUjJrRzc4ZmZ4MmlrODIxQUgrUDF4TS9pWTh2?=
 =?utf-8?B?Z0JHcmxQR09PQmtBc0szUFMvVXdzOEsrVlNTMGFsbmVxM2NXTStJZ0FvYUhP?=
 =?utf-8?B?TGROdVFmVTJscjkxNmVUbHZmczYwLy9GaG1FMWJ4YXJ5UWpnTWxicFV6bGsw?=
 =?utf-8?B?a1dHT2MwSUZJWWFzRWxXbi9PbUNXYUdaVXAyQm9lNTdqOUl3Rk5CcW9uR2xB?=
 =?utf-8?B?L3pCc09TVWlSanNvMEdrTkRldW56ODFiejViVnZEV25Da2JnYmkyZWJyMm9G?=
 =?utf-8?B?a2ZjNjlrVVgzUXVxNElTWFBxQ3NycUU1VEo3NnFoQWVGejVCc2pUdGNMMkhC?=
 =?utf-8?B?N29lK2MxeWtUenNXUW9NZExJZ0tOWlh6UW5MbjBSRUNYeGZxamdWY0xrZzlq?=
 =?utf-8?B?OWV2cG9vMHlhdGtDcmpDMnlsUUtraVF2bWFjZVhUenhXRUVzSFM4S2lnTmRK?=
 =?utf-8?B?Q0tkRVcyQlArak1PcGJDcFIraHZ6U1MxNnVrY2JtdmhjQ0JWQ1lsaVZmeHRE?=
 =?utf-8?B?UHU5VjNCWDF4VXJ1a2s3SUViNUFGSS9zTnQrZ21lcnV1U1Bta0FLQm0xYVdk?=
 =?utf-8?B?ckhXMlNGbW4wTkxBaCtvMHJuVzlPOHAwaDRPMkRrbWJZWXcxS3FZSURGVlNj?=
 =?utf-8?B?VmluMUNtOVZCK0t6b2ltOXUwc2FKdzNTMUJYWTR6RE5iSm5vcDNYVE1yQlpx?=
 =?utf-8?B?L0dmQXVpTmtzR3FzdVFNTFgvam9OWXA5OVJkdm9oL0RuRWxRRGRTNGRkZjBQ?=
 =?utf-8?B?bDRYY2tQb3hVM1lqaWZ5U2d2aHhENU93cVNhM3QxV21QRXlIYXNMTFd3T2ZG?=
 =?utf-8?B?VE91N0Rac1d4K3NKaWMvdzljOEgvL0szamJqdUtucW1iblNKNHhSNGdyZGo5?=
 =?utf-8?B?cFVSbkRSQzRPR1ZjdG8zQWVlMEJUMkJ5c3QzeEpkV2pxYUt4VlFFUWgwdEFN?=
 =?utf-8?B?S1FEMis1WkYzTU1tTmV6TGhacXRiVXA5ajh4VmFyNlpyYWF5OWJPeHk5aks1?=
 =?utf-8?B?S0VpYlphNnJKNzM0S3NkdHRSTUx4Uis4MmRLVzkyRVNMRHZ3d29zYU85TGpa?=
 =?utf-8?B?WDNoeGhDV1c3cWh1SHh0MEtsUnlMQStEQVMycDVhd05LRGpJSVJKQmJaRjk5?=
 =?utf-8?B?MmRIYWIrQzhGTE4yYjBGVWdValFZcDIrbERiUU1BV01PMlBBTVVvWXZ0SytZ?=
 =?utf-8?B?R2FnR3FYZlFSNWt4NndxcTYxSDVpTlNQdkYzVTJRdGlJanMrNGxvWHVYbTJs?=
 =?utf-8?B?Y09CUko0cVBPSGx1QlM0N1V2SklsOVpvL2hka2JUN045Zm9lM005Q1k2Z1Fy?=
 =?utf-8?B?VGRQaFV6Nm55Q2hDdjB6VDl6dmRoUzdSTGRXb2NIdi83Z3RyMjh1RW1OeVdm?=
 =?utf-8?B?ajJlSC9vb2lqZ1M4eFFmekk1RlBFTzMydDlBaU51dW5yYXQ4S3JaSkpSaVJq?=
 =?utf-8?B?emI5RUREU2V5Um5vNUpkVktTSXJwTG40eUZOaXUxWXptZFAwTUEybUloblFi?=
 =?utf-8?B?S21BWGRQTWRNZWR5RDQ1VmwrbkU0ZlZDVjBwN1ptakNDWjBiQXVaMXphVlZP?=
 =?utf-8?B?TVRGVGNhWVdVaG4weVhoVG13UVJLQVZlTm40Y0o1NGJ5d01QZGhPRnU2MElv?=
 =?utf-8?B?cWZCRVFzU1dpK2RxMHdCWExzZXhDd2hMUVRyQWljTkdkSHpidUZVckdDR05S?=
 =?utf-8?B?NVpOeUxOYzhTdkRRSEJDSlBwRnpaRmRKNzV0emJhdFpQN2pOaHdqRWtDaURB?=
 =?utf-8?B?cld6bVphN2lPbGlFODFiRDZuN09BemVyb09lVEFRbWpPYTcvbDMrV240T0dz?=
 =?utf-8?B?R01JUUQ2QkcvUGtXODN3bktPck84dFNEZmV3Wmh2RUxBdHZWVGl4c1pOYzNB?=
 =?utf-8?B?M1NINXJjbU4yRUlDTDR2UndmSVo4dm9pL2xvRWY4MmFGN2puSllDVGh0bVlP?=
 =?utf-8?B?cXAvd0VNUklCSVV4alJrejdCM1prUHhieXFLN1NYZnFYazIrRFRHREFyS3Fj?=
 =?utf-8?Q?+oAgFc1opP1EYFjvR38vOFs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	chM5PxV2TTFH1Og/QRKtZhPI2MieZyjmPbknfNfRRl6akkj+T350mOaB0UU3o3VXPVgXpe4zsduh7YYWOwbPRTmy8XgEpneq9cc8+/1oZqn/VaOLXwZdqBeZmz6QNpOGpIcbxtXhUKAhbHiJjZDQ33CpjYxFI5Pv3rxeW1uPkVXlVQY1iBj7gQuS5d/iMsH8ihm75NayT7fSEadfl5brZd8aNWCRCOyQ0w9XL+LozThrWnzUXe/odHOt6RoQvNZW4UurKlA/MF0byLPSpyXDanbiNRSGQdYGjPu+tMvVJEl+My7G4jPh0AsRRPokv/DzAUv9XPGdyFH3guD5b6ziFGT3ueA72KaFxpczG6nlEVcu2T8zhSdPAzi+uxBF8Scl7EWoeH6SsTKex7pCwq+BsyHrwDjEkrWQTT9uuOrANUHiXdDq92+JHo4dNF28Tu8GsvKW6aTovX6K8SvRze4YIrW7fj9hpSUa8pXyhQAehHfCbgHZWMgPU1HkV8Tq3rAvQtgP312E1ZjUYwBf7vj/dE8Xh/LqzkULtjUPRIow4dirHTNr+cA+EXCZYU2SiHSH0kFXB4sp9sniQxB92YN1Ig3kVqLNG+9Oi4i8W3w0e40=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3c22d94-0efe-4d69-25c6-08dc167d30a5
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2024 10:23:32.5433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OC1AJvzVBCf5H02JhtE3ORJnX8oJUREYq7dlG3dvzgFOnpGYcGrRlM6QLgkafkv6myQ/F3cX7u1xIcnO+d4pvJXQ/+UdAEqR9/G4GMfFDITlmJn8G3tHokppEs4fe0Vm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4574
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-16_05,2024-01-15_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401160082
X-Proofpoint-GUID: 2TG7h2XIF5lLcNYXIlfUeTR9An104Y4t
X-Proofpoint-ORIG-GUID: 2TG7h2XIF5lLcNYXIlfUeTR9An104Y4t

Hi,

On 15/01/24 7:52 pm, Mohamed Abuelfotoh, Hazem wrote:
> It looks like both 5.15.146 and 5.10.206 are impacted by this regression as they both have the
> bad commit 33eae65c6f (smb: client: fix OOB in SMB2_query_info_init()). We tried to
> apply the proposed fix eb3e28c1e89b ("smb3: Replace smb2pdu 1-element
> arrays with flex-arrays”) but there are a lot of dependencies required to do the backport.
> Is it possible to consider the simple fix that Paulo proposed as a solution for 5.10 and 5.15.
> We were lucky with 5.4 as it doesn’t have the bad commit because of merge conflict reported
> in https://lore.kernel.org/all/2023122857-doubling-crazed-27f4@gregkh/T/#m3aa009c332999268f71361237ace6ded9110f0d0
> 

I think we are also seeing the same error on running xfstests with cifs.

[root@vm xfstests-dev]# ./check -g quick -s smb3
TEST_DEV=//<SERVER_IP>/TEST is mounted but not a type cifs filesystem

This is with 5.15.147 stable kernel.

I started seeing this since 5.15.146 and on bisection it points to the 
same commit:

commit bfd18c0f570e ("smb: client: fix OOB in SMB2_query_info_init()"), 
reverting that commit fixed the issue and also when I applied the below 
diff provided in this thread, the tests run fine.

[root@vm xfstests-dev]# ./check -g quick -s smb3 cifs/001
SECTION       -- smb3
FSTYP         -- cifs
PLATFORM      -- Linux/x86_64 vm 5.15.147-master.el9.v5.x86_64 #1 SMP 
Mon Jan 15 22:39:33 PST 2024
MKFS_OPTIONS  -- //<SERVER_IP>/SCRATCH
MOUNT_OPTIONS -- 
-ousername=root,password=PASSWORD,noperm,mfsymlinks,actimeo=0 
//<SERVER_IP>/SCRATCH /mnt/scratch

cifs/001 1s ...  1s
generic/001 16s ...

Thanks,
Harshit

> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> 	index 05ff8a457a3d..aed5067661de 100644
> 	--- a/fs/smb/client/smb2pdu.c
> 	+++ b/fs/smb/client/smb2pdu.c
> 	@@ -3556,7 +3556,7 @@ SMB2_query_info_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
> 	
> 	 	iov[0].iov_base = (char *)req;
> 	 	/* 1 for Buffer */
> 	-	iov[0].iov_len = len;
> 	+	iov[0].iov_len = len - 1;
> 	 	return 0;
> 	 }
> 
> Hazem

