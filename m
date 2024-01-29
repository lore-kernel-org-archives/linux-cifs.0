Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7513C157047;
	Mon, 29 Jan 2024 16:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706545684; cv=fail; b=YJeUMgKuQdhM4Qy41Vz6SiqaA3r0XasRU/5QsE8LdN+vQ4OYFPdFCsriiTzMp9HpnwG0MUMjQAihlqdcusZvO2CwIxy9ZzlgTiTGXGcmZp0Yh8zLRiZ2uSSIjspb+NJvSb0PTgx+eD9Q049NWMnl9wD+koLkPgNbcK2lYJuG3jQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706545684; c=relaxed/simple;
	bh=nnX5cUclL2Fw8PesWFxDG8iLcGGd3Lbv9DLPOgd+D/8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sKzBV0mSTkZXq6GY0pty2tnf24hI6u4Ww+QYSZ4bk2uLaxNl6MR0W/alHw3J53ClfL+/6/R2zZnpRqcwjIbJp5EvIaCR81z+i0u0L4xT7bm10kt6r0s6msLg0mci24LMVY28BKjPLvRCb/BsOCTUjzdEoimrxaMPr/4UTz05EwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jACsVPGr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ubptPM5Q; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jACsVPGr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ubptPM5Q"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40TG51qp023277;
	Mon, 29 Jan 2024 16:27:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=98Kp6iNic04i7jbeB09v3CM2rO6DoTPBvQp+JC1ZQd0=;
 b=jACsVPGrLpbvxl6KuFBWmQLQ0vK4y90mMW3nNo91z7Gej/raAMKv5FEF3iuUR6SyUtUu
 q9xUs/R8C3W35eijb70RjqpQvsapSqZrCtFr5Zu6rr2hsNk3ECF428E1S24VpPxVK2BC
 wphxTE46Cl5IvzBRbqKTEgkl6oaOGeY1e2waAaOqOgDtsmOsMkJ66FN0/oAXtrsxRBjS
 EkoQckKT+3+SWHKC4tXVeltOJJbwIUCbwdxNc6ZThlbBJyC/nY0H9wICyuQouucNN55g
 8aQvAGtHgPdpMTiHwZeejrn7iCCMxjT3zaxTcCnYTaHXUznAYGEJC9CokWgib6jkyHPq IA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvsqav9qu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 16:27:53 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40TFt7oH040195;
	Mon, 29 Jan 2024 16:27:52 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr95yrt1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 16:27:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjeTd9nNUr6itBKGLUpeTPphXvz4tGuPc7VdXUiwLWj5zuUwmfiadBz7lSY3a8iNevg1i5LsozvjKaxkxyzj6IwfA8vBs9SXwozRYIRSmRAdSPCBfsVKM8F0xvigvk6PZG3fG1Khz2Rgp2UC6dcUteUbFtlmOsF+F651yxfMYoHkWxySRDm8rESknIlRiS1mqHxlJpDGPeh3zOa/wxo0qs33aOHWIg7pyv/Wy7S9jA7FmfL4DhrYUPp36Ldj5DNtNJjapm1chVSuA5cT/y9W/SJJPRsHZaQBtkoAvr4VoZK7nqjYdyeeYT6/zyUCXE8ttqehsLVGwDguiPd4ZIKFBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=98Kp6iNic04i7jbeB09v3CM2rO6DoTPBvQp+JC1ZQd0=;
 b=T/GRUpiPwgzeUWP2jFkmQ9RYsHlORHJfnmszPyRdDKPo5zraVh9IW+PRpmSSoKtxjIAlQPhln4Y+S8IzuPpZY7peYLBYB0559AO5Gez0wqMtaOyA9oII80C07bJ29jQiUubQbmiAmhowOk3tcqXEFnCb0UexZMnEOyFmHrr7emo6fk6+4CsLHV+T/Xg8HDIwbZugMrGuvP4R5sEd2+h1x4ACaDV1yPOEmrWqfcQT6HvnhpNeLH52+ajBZ2PPok4KevtRIVDGrhTStINl1tQMGDHyH8bRikMUzQTUVW9ASSQlqbFRrGPCP10lb7MT/sho6A4U2PXVXV4Bteu2PSw8VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98Kp6iNic04i7jbeB09v3CM2rO6DoTPBvQp+JC1ZQd0=;
 b=ubptPM5Qe1vxA4UDO2FIE1XHI0vGio7Mmzp3BU3FcAi5vIcy4RISAUfB6Uz/VtPCzrXsuOza+DSZM/3lQaI4TudotRqSPW9dF6ijUCyPW/ojuClvJ8aAMO3Im+7RSScKat9tx1D7mxAOXkQQ6IpcjOZ55GzGAR3HHdjHUKBlLts=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by CH3PR10MB7435.namprd10.prod.outlook.com (2603:10b6:610:15c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.32; Mon, 29 Jan
 2024 16:27:50 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::f41b:4111:b10e:4fa5]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::f41b:4111:b10e:4fa5%4]) with mapi id 15.20.7228.029; Mon, 29 Jan 2024
 16:27:50 +0000
Message-ID: <88f25b32-033c-4e1c-b1d5-18bbc2ec91c9@oracle.com>
Date: Mon, 29 Jan 2024 21:57:40 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10.y] cifs: fix off-by-one in SMB2_query_info_init()
Content-Language: en-US
To: kovalev@altlinux.org, stable@vger.kernel.org
Cc: abuehaze@amazon.com, smfrench@gmail.com, greg@kroah.com,
        linux-cifs@vger.kernel.org, keescook@chromium.org,
        darren.kenny@oracle.com, pc@manguebit.com, nspmangalore@gmail.com,
        vegard.nossum@oracle.com
References: <20240129054342.2472454-1-harshit.m.mogalapalli@oracle.com>
 <06bddf4e-a15f-bf1b-b9e5-d173cdacf4d0@basealt.ru>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <06bddf4e-a15f-bf1b-b9e5-d173cdacf4d0@basealt.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0177.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::21) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|CH3PR10MB7435:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b848060-001a-43e1-04d0-08dc20e73c04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	wFxL323xuven0P7Dh67/kH8tY2ihV5xrUpcXIpi5gmRMZAhcCaEa87XQtye9QURwE2GFHSueSHDoaZ4OqzJsMUQnfDwdmb4rWsZ/xdZTfdeimZYQ6tCE9gETmRFQVx07GDT4IOGO2GBR8pZNNQvdv7DGqLKZ0qUE6IWTQsn6r9gA/AGjAnWs/heccesylRJY44lmnZ/PmFeF6tk18t9dgWSiXFinXxkuD/iWCv8mNCUvxtbgoj+ZMCzwGd50od7TPfZ/8tbNAZ3GpD3XqOdjKWAq8/CAQEwvU9w0EVq9nKNCsfex5CoYtiRhSLb+W5h1rQcfOt4YH07ZNj2b7chHWorsezabXVSjUFKtLmVIvHgMtWACsPlOTjKUkAKjistBbALr+RcTJIPAtNdsIuO2nL5OmT6wy62guxmyHBN3JnxqRlBsZ2PJcVTHATDPtPRN1Nqx85aY/FFd7cfVzYasXsa+rcqXvKJiykrm+hlIWCyaYXApLVSnly3ObAzRlog/h1ogYYLWDETLKeKIjWp58S5nSfA/U2qY2dkSCpjcW4ywmgNxADhf+OjSZSuywR8tQ1J5q9CvxeYxmNaz6B9kGQvBiEItN4pUx4yQxKKkALqCRxDiMthSIoI9PRrhjbd+tcsIiGJScnw8MSBYLlEErA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(396003)(136003)(39860400002)(376002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(86362001)(38100700002)(53546011)(26005)(107886003)(2616005)(6506007)(6666004)(478600001)(966005)(66556008)(316002)(66946007)(31696002)(66476007)(6486002)(5660300002)(8936002)(4326008)(8676002)(2906002)(36756003)(6512007)(31686004)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SmZmSyt0a0VQRStEcWlxSkdpM2Qxb2pjNWpJbkFlWjViRjd6MWRlbEN5dlhD?=
 =?utf-8?B?SGNjUjlCUEovenRXbUNNS2F4RWF2KzFScE1HaHFUTzFHNEtrR2NvNTJCeWQ1?=
 =?utf-8?B?Zmt5dHlQRXFDZTBQODhvTU1weGVnSkdBaWxlNVRRMWgxQkJ3Ynd0aFdaMTlQ?=
 =?utf-8?B?aVE0WTcvWlZwS0NIUmhXa3dJMjNCTzVJTTE0YlNyVXVoRWcwOEtwWGY4ejMv?=
 =?utf-8?B?VGdmaVA5SXlWVTVoU3Z0R3FxdkFUc0RiWFBnMVowVDhQS3dzVEpjQyt4NGR2?=
 =?utf-8?B?M29ySGdEQ25jZW9TNndpZVdjYUZoTVRlWmhFM3hxSDJnRU9Bb2NEU3A2MXp1?=
 =?utf-8?B?UnoxS082Q1pJenhQSjRNSGIrZWMzUXJqNHhkdmgxTGdtNm5DQzJFUXVQb1JE?=
 =?utf-8?B?ejVSQ1hSL2daaHFhSk5MZXlhNkJFazVYVE5Pc2YwR3dQWDcrcnZFNCs5OU5w?=
 =?utf-8?B?RVhtVVZUVnVidTQxeXNKa1ZFTm14ODI3SUZyOTVIRXB3cThkNWJpOFFMdlJQ?=
 =?utf-8?B?NG96RmpzYkh1NEJzbzdHWmsvQmdtbDZFcVZWaDJ4SzVKbDRwNFRETUtQSy9o?=
 =?utf-8?B?bW5QMWJ0ZWh0K0JIanJjR0Nab0I4K2E1V2ozZ0Y0UHJ0RVZEcXNJZ2FWVnFB?=
 =?utf-8?B?c2doeUhWTk5tdEREbWlGMGxwd1dCaGY5c1BKdXhacEdaSHRobEZJejNwZHRn?=
 =?utf-8?B?SUlyT2ZrbkFMbjNKV3JJRVI5OC9MOUU2ZGx6ZStxZlBIU1BsQzJCUWsvQWVy?=
 =?utf-8?B?R1dac2RtVUc5S2tmdXBYbG4vQ0NCRDZqWDVhMGZ4cmpvc2dJY3FGTTRCMG5B?=
 =?utf-8?B?RmFQVVJsSXBONGhOMmR1NFVIWCthTCtXZVZuYjVZUnNzTHZqSWhQT0pBbkJz?=
 =?utf-8?B?SFF0dk5ocFJXUDlLakJJQndXY3QzWFBiUDBTeXA5RlFGNklPcTFLZTVRMjBt?=
 =?utf-8?B?K2dZaW50bjcyQzdMNGRabHBoakdEWWhKeVhsa1BZY3RzZE5yaGlGK21JQzEy?=
 =?utf-8?B?Nkh2RHQzWmlhQVV2WEVjUm1nUkJmSWZuV1VEZ05TRmNyRUdUZ3ZCZXNtbWM3?=
 =?utf-8?B?dnJyNjVqUWdxWTJITkpCK3krSTE1N1JXL0VGT1RhSVNBNVdyY1NaT29pM3VY?=
 =?utf-8?B?UmFCNllCNEc4WmQ5NjVxMTFHSUM0QWlvZEFOMUhOVFNqemkwcFFPT0o5WGRr?=
 =?utf-8?B?M3BnRnZ4anpNNXI4TlhjUmZpVFI0dXRDbDk0UTl4ZHNkUFFkYTQ2bStrUmFZ?=
 =?utf-8?B?YmV4K3ZLeG9aR3FER1pBbTQzeFRVYU5ld1ordUVVdHBEbW9RS2E3TkswM0lV?=
 =?utf-8?B?YkMxLzhZeU90NnZtdi9XT1k5TkFvMDJxK0lOaTBMYWpYU3hWdTA2Yk1yN200?=
 =?utf-8?B?bFFDWVNEeEtmUzlnUEljVjdudlRBMVhWbWtMbHYzWDlKMzR3U3FoaG81V0Fu?=
 =?utf-8?B?bzlHNnFSTFdCT200VzU0SFV1NXVrRmlnamRCbWE3cG5RQThrUlkxRHA0WXUv?=
 =?utf-8?B?VUUyUm5XckRVaXl5VlFFQVNDbkR2YlQxSlNnTWhUVTFNL2dPNUJCRXNIVXpQ?=
 =?utf-8?B?aW42TUZrblNhU0Z2b3dhTEttcFM5bVNxMTJWcGZLUjVndVorQkprWW05NXIz?=
 =?utf-8?B?blgvdFg3azk2VlZuTmVDZHozNURjREdFSXBjYVBjMVd5aVhxWVQ5YWxmWWNY?=
 =?utf-8?B?KytIanBOZDJkMDVFdnlqN0VvVjNSdjNSbklWRk5Oek9wTnVqK2JUbFEyVWw3?=
 =?utf-8?B?YU02UDNHT1BCaEpsQ1NQQzd2VWJqZWpFVXlHUmUzN2pDOGFVZUdMUkpET2M5?=
 =?utf-8?B?V2hQM09CUkE4NnMzNkJwMmNDeElkWVFHZHRKYXE1UTBicGwrN3JZb3ByM2R3?=
 =?utf-8?B?WkFPMG0zWHJRREdPZXlXVktGM21uVXZFbCtuTEttbFFGUFRWNTN1T0RhaDg5?=
 =?utf-8?B?VnoyTExYY3NRcUdWc0J1MXJZbDRGbmQrUDBkVXdJd0JWbmw5WStKOElwY3NW?=
 =?utf-8?B?N1pNdS80VHJMa2xpWFhkNVUvRWpkemxhSDZIY1pUM1RnRFRYWEdUb3R3eU12?=
 =?utf-8?B?bit1RUZ3WE9mWUNzeCt2aUFGZzhScHc5V012bGlVd08rNlFWLzIrUHF6K2lu?=
 =?utf-8?B?a0tFUEJlOXVIOHl3QVd0S1g1M2VqdTRvV1c0WEFrN0x2bkxCdnQzS1hXcUtT?=
 =?utf-8?Q?YYT3DPU478HbJ/nJjn/U+3I=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	CsGvtpWEwhXw+0WE2m57lgpT8qbZBdi9O//QBJXJu4JEJjXHPP7k1za9KlGSGdTeWBvwW5lcfVVD0qiYhAxeMe348fMrLlDfNK282Nsvro5QuCv5Wk6Fk5pkkRFoeJmAgxu5DFseslBn1ar8gAoRqi/aw24r6wnJsg2aHSbuJGyrUCKfPDgo7JznDJ4y54GwPRvgY8kTAlrZYHIa+qkH0MHX5BhhPvRfmlgMNCX04vX4fxoyXsg+Q0oM0G75AN3HXGJhYoXnzop8NtvJW1+PRK/dEgXzdQ0wlmL4RCKlpAC1NxQHvHOPsxSXhw9ISINOeUeqrAJGSAAlbYoBhnkGYGozqqkgZtmefGqS8AlZHOujwoUCKFuRt+WZ3ASc4po96pb3KNNNQhEuKxk/moez0hmroF090EqDtkHdHxBpvqKC3v1PEis7DQgVKOr5U+YvhqDSiJxsxoajSyyySFJKJN81uqPCPiglWPFf9PTZgnbRKBw0seUO2TvtdBuGyIBOnaqPnrClU5gjghuFXc7rW3N2VyFhdKq3SHgu6EVoFQ2EF6MBD720TpkDHNC46EbFSI/99z4i1JRTktzk+1xEWee/NqBf4vskqBm538R3q6I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b848060-001a-43e1-04d0-08dc20e73c04
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2024 16:27:49.8767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JRT4CdCDFHOWB4s9JH4kCkGtyWdevQaaSQIXivhBIXtD7aWSyjR+TtKzQ/3QgQb+B8kCxZLmbODf4cbafieIeh/md6nXmTACxbdDAG980+agVkDQ2fBHWfWkbms2/zNe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7435
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-29_10,2024-01-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401290120
X-Proofpoint-GUID: 2erONFcq8RViZ7BWgsDSmWpPdsXifowV
X-Proofpoint-ORIG-GUID: 2erONFcq8RViZ7BWgsDSmWpPdsXifowV

Hi Kovalev,

On 29/01/24 1:49 pm, kovalev@altlinux.org wrote:
> 29.01.2024 08:43, Harshit Mogalapalli wrote:
>> This patch is only for v5.10.y stable kernel.
>> I have tested the patched kernel, after mounting it doesn't become
>> unavailable.
>>
>> Context:
>> [1] 
>> https://lore.kernel.org/all/CAH2r5mv2ipr4KJfMDXwHgq9L+kGdnRd1C2svcM=PCoDjA7uALA@mail.gmail.com/#t
>>
>> Note to Greg: This is alternative way to fix by not taking commit
>> eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with
>> flex-arrays").
>> before applying this patch a patch in the queue needs to be removed: 
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.10/smb3-replace-smb2pdu-1-element-arrays-with-flex-arrays.patch
> Maybe I don't understand something, but isn't there a goal when fixing 
> bugs to keep the code of stable branches with upstream code as much as 
> possible? Otherwise, the following fixes will not be compatible..

I agree, but at the same time we also should observe this:
eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with flex-arrays") 
is not in 5.15.y so we probably shouldn't queue it up for 5.10.y.

Ref from stable kernel rules document:
https://www.kernel.org/doc/html/v6.7/process/stable-kernel-rules.html#:~:text=When%20using%20option,to%205.15.y.
(Just above Option 1 description)

Thanks,
Harshit
> 

