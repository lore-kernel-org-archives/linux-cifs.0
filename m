Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11012011.outbound.protection.outlook.com [40.107.193.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5FF28EC
	for <linux-cifs@vger.kernel.org>; Thu, 27 Mar 2025 19:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.193.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743103890; cv=fail; b=aEnX5a/jL1SMJb13rvWJswn6+3nOm6/7hZ8qBnAObQGIJEQ7QhqBEow8IhQWMEBFSN0aE3nOxje2rx+c4nki681pWb2ZRXOWOYjUm12LtjSgtl4wdpfzJxa3cJcOYsXSCBLxE9yp6zc3JZeL9VphKrW0uDPqb6TFYYAn/SHyUv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743103890; c=relaxed/simple;
	bh=LjtnADDtOefRNAJ23I8PEVFFdn0OPHfwO696I5EMOow=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OHurBL174jEDCgIT5s4NdgMJZ1WZSSjia8LlsuZCuAvzO4eKIee9iV2Um5zvBv8w1MTYRKNnLgruiYAMcfk76yZBw4MCRiIxpXNodY9ijNk4btyOgzppyWKeadjXKcmCCoU666v+1HSYchIVpIkFiMu/yEq3fWGUMY4qWV8G9L0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opentext.com; spf=pass smtp.mailfrom=opentext.com; dkim=pass (1024-bit key) header.d=opentext.com header.i=@opentext.com header.b=XMrPtW2f; arc=fail smtp.client-ip=40.107.193.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opentext.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opentext.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=opentext.com header.i=@opentext.com header.b="XMrPtW2f"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aGTkUUqvUIWnaQqwCHXSPHY/y/uiZz//NpiOsBmpyWnyVwzhe8e0EcTxsQlhKsGNj9yREgVrWMnn8ozevbSQpLxxpryYr3rjOuXMYNNAO6AKijn7dFrp7+y9D5xTxL4VPj1FUd9/kb4dOLMW5pjRRhQYJxaQ9Yx+FsT1kLyfttpJJWCetWhnWDTl10/3lYFmf8N6t1L1NE5+4fz+pAmx33i2hfODl7RPfd1tmTmZjFrDivwwWI1eozvp9gVmLaRg6x5VmA5Z+c70AJRq0XKt73gQz56aIyAsOQSc65MtDhU9STBua9+x2vRpaH96nALKFybcski1nz/+lnbGmLYc4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LjtnADDtOefRNAJ23I8PEVFFdn0OPHfwO696I5EMOow=;
 b=VZ93iYe71QNe+H1hIH9Si67JDRHqqy3DHV7n1POJPbaQG1DHLaap+0FADRf6W7tPxUW/fkqwXtEbt/ZIlJ/U7syNLfp6Pglz8fcrWbxZWNTd2IhyN/39IIB6bhPWBTtvfRUvEEYMMNNdSWA8WsalT6ln+zhoW51N/ZcvxqxR8pc2eWFN7gKLx0A3DoP8FRzbBWX+bFNB6Ootw81+Or3rRoIJv9L/AxwugMhGi/AePDvI548R80ojSpibjmCSm3TE4XaU9AXWSRUfatZKOqx7BUsj57SKQs8IF7NStAGrNn33TIfMyU0ZChFSOrb6guY5Ts0xnzyZ/D5E/0LBBBKUJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opentext.com; dmarc=pass action=none header.from=opentext.com;
 dkim=pass header.d=opentext.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=opentext.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LjtnADDtOefRNAJ23I8PEVFFdn0OPHfwO696I5EMOow=;
 b=XMrPtW2fhtpb/f6jH72xBSs0MZqhhMKEim6FW1x4zn2rN56FxYuCOWMh9BQ0rx8q7PyB4HgGxr3FW3sv7iAwjCDcj/blW6H5QO/KxMa3WiD3I4sKwXkoMddafkByvMHUPYyaghohCFqUCHm+aaKmJxoER7rLK84FVoQAwLS/kK8=
Received: from YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:aa::5)
 by YT5PR01MB11232.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:137::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.47; Thu, 27 Mar
 2025 19:31:26 +0000
Received: from YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::a233:82d0:bb5c:678d]) by YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::a233:82d0:bb5c:678d%6]) with mapi id 15.20.8534.043; Thu, 27 Mar 2025
 19:31:26 +0000
From: Mark A Whiting <whitingm@opentext.com>
To: Enzo Matsumiya <ematsumiya@suse.de>
CC: Steve French <smfrench@gmail.com>, "Heckmann, Ilja"
	<heckmann@izw-berlin.de>, "linux-cifs@vger.kernel.org"
	<linux-cifs@vger.kernel.org>, "henrique.carvalho@suse.com"
	<henrique.carvalho@suse.com>
Subject: RE: [EXTERNAL] - Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption
 when writing, x86_64, kernel 6.6.71
Thread-Topic: [EXTERNAL] - Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption
 when writing, x86_64, kernel 6.6.71
Thread-Index: AQHbnxaMdZRI0DQNpUKr5IityG/s9rOG9BoAgABpc6A=
Date: Thu, 27 Mar 2025 19:31:25 +0000
Message-ID:
 <YT1PR01MB9451F1974E92DFCE800BBE3DB3A12@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
References:
 <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de>
 <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com>
 <uildcjpqxzc5nckupgdeeifkrqwrau2qxuc2df2uxuyys3i2k2@iz2bmi6yojyu>
 <YT1PR01MB945191C652AEE173CEADBA3EB3A12@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop>
In-Reply-To: <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opentext.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: YT1PR01MB9451:EE_|YT5PR01MB11232:EE_
x-ms-office365-filtering-correlation-id: 299df4d6-eb20-4c8b-9873-08dd6d65f6e2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?9NpwXXk8V6b5xJfAk5GMc8NOBGHadrlokhSmZ3ZTi3ze81JFzarwtznjONUo?=
 =?us-ascii?Q?uscQ6pt7FSQunLzJR79t3aFX6tCE2utQgH8U+fEzYutEEw2wT7AL0AmkV482?=
 =?us-ascii?Q?xQ59ITUpA7MkZZkAsIdKf8swgZa/gsI/TD9jeaGaexSznAw3W1mXpFjX/4UV?=
 =?us-ascii?Q?GolIiSQTkamCRcLIbmaCU8w7JgqqQCHFFpvpgcJV180Wux1tAYkAQwlD00cA?=
 =?us-ascii?Q?xzI5Cg2GspJ+DxsOYlZieJrObyM2sEZtB35z/bu/gG0BDv6iO/B1SAggn5T+?=
 =?us-ascii?Q?++2Vyp9ZK90lkQ89T5Jn5Wtjk8sfo9pOflwfCzhsg4OXhf9SBHFK2w+naZOu?=
 =?us-ascii?Q?7pOMPL2zkMo5D2mEcuzmj3ixm774ORWSbsvs1uqQ/wLw7AhGhmfKgKHv445N?=
 =?us-ascii?Q?vnyYCyXpUmhfevOjTKQjr2qJWWVx077EcU4axB4z2K8P42b0+4kNYdGdowf6?=
 =?us-ascii?Q?xuduOnf7LSn60bCxyk1WwTU5D7yDfDUtMBBfi4xaR1X9hf69NpM1wHUK0xJ4?=
 =?us-ascii?Q?RIY4oar44uCzqXxNOokWXUlDHBqaMOUF/Q+eTLgUWur74xGBeEXhWF39WWmH?=
 =?us-ascii?Q?fgUdxF9iePEp/erxurtH8CgL/DjScy3gUrpQ2MfxiBUo/OdhJas3B5ycY8V2?=
 =?us-ascii?Q?N0m4BhGWufYzp76aaL3L/F51RQIgGz8Psm3OmFRHGECZvibAHvbpXCJlmCzt?=
 =?us-ascii?Q?joYeD+5VzsNYvUejUSaG18tFPnswfTuFiaVk5QPJBeRtfkAbfIxFeStEdoAj?=
 =?us-ascii?Q?6YnQ7F1nY2L3kldu5DV0b2NzVfBY6aclJZLE0Tc0JlRlzpFMXEHKa3TM4B81?=
 =?us-ascii?Q?o3AX6TiG2DbnPkO4S3kiG6QvxSC6Bj8KuTPhS/mH+SqeRoU5GCfze1pjti7+?=
 =?us-ascii?Q?yzRtPJWPZ3UCsxuiIFPmN6KAR06wm74Yq4BtTS20wkyO7qk95Hl/yurFlTor?=
 =?us-ascii?Q?2TMQUOpp9SIV2psiGI0v16ZHL/oGtzB/tdAR5mNN8Yvqzro24KNAGstqcddi?=
 =?us-ascii?Q?ArIX8yaJmx3Rhi/GzSOiKo5pF8B9njCdKVDnWPzjyNjr1t6MpNReDBFs8EfT?=
 =?us-ascii?Q?6zgrz4yBwR1pCs+RBIY4KBJZl37B4qJNVBw9viX0ulxiXxEUjYj/yc0rQ/ng?=
 =?us-ascii?Q?A/itkPnBrXhwpJRhCBN0jOhszaHugBi0pq2Mt293lEDdNc3b6BA65iuu+5/p?=
 =?us-ascii?Q?Avg0vigRaLb1W7PnFKtmBucRcuoOUV1ZDmsadQrgAYEYzdMUkp24lngQhfP1?=
 =?us-ascii?Q?37tbSn95sw90B4fAZN7317Q3ekPpDI5AlFiyer4nl7auc0tCAOc8xoKQq2e9?=
 =?us-ascii?Q?Q60jyIqhtO7oIH10RYASLRMkRSDrWeoQ/0ymiErFG41oYMqZCQ5XF8RNsKro?=
 =?us-ascii?Q?Z/wDwTONI2IAJ9ITRaZblqLzoGy1?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?EDFgFNYBJD1RM2Ujtd1P5mzKb5JPnEFkdVHt+FXk56B+aKl/3hHzpCFlAFCj?=
 =?us-ascii?Q?e5rkUpt0GSDjv6EPPdWXMIipuCsmvPc2Zh+0SoUy9IMnbMhIj1Fvy2YBeL3S?=
 =?us-ascii?Q?pbZFnqBQij7r3Pmu9chxfsHCLojL8VzUkdtF/3HRYGyF3p8ORqJ1C2lhUuAc?=
 =?us-ascii?Q?lmhlovnTcOiVEmmJPww8Fbi62+xVwGWyBNFcc46GzdWFRpe3Pxq17HPdQuXH?=
 =?us-ascii?Q?2vLk2sEtWsjbNqdeCKX6ZswejE3EnWbcJHiPDW96HN3jECH8qdYXdBaJY0o5?=
 =?us-ascii?Q?5HBX/RSXAS22c9tlEIh5LytkyMjcjf8i0HXAgsihgQJKs5WcB3Iwxo9XC2Y9?=
 =?us-ascii?Q?8X+qeaLpM8Legc5SIBk0ChxmI+bD9UierVVvZ/dhjFTdzMGAk0pRc5LoJVIQ?=
 =?us-ascii?Q?qKLQrJmBGgEmxQPHmyT4jW5XcKkhsGnKFT5hoMSq6SkADZRUgz5oO/y6ILNp?=
 =?us-ascii?Q?5dETD4V4ln+gJ2NFGpKS6dIaXJ5sqHhvlDHt219PMsXDeKsPDJKmHR3HitNr?=
 =?us-ascii?Q?YKnDRDePc6+pfRuXw/a252Fdzi8C0EMbVcAQr8jzIgRcoZ6B66fsT5HsQDSG?=
 =?us-ascii?Q?mg6XpNPX4Nd9szNnc18OOSLCdDrTcXm8RHoVYunbe/ALlMcVjrnAGhPtGxwb?=
 =?us-ascii?Q?nFhUKpuYSMgLJPQkjLi1PIGFZ6Lj7Rb8cw3I49exuwkZrvXoxo/9EnbY9ZCW?=
 =?us-ascii?Q?HjOQuz8nBtr5WEVk5xVhIzh/EFTmBp3yAr4Fg/4gE34nWyTeZGq0WLlCA3TO?=
 =?us-ascii?Q?atC7WjncW8cE3vJiTXZc96nNc/LenBLy7vGWAG+aDmSH+MzYxSKw9Pu50fzK?=
 =?us-ascii?Q?+q8Kcyb1FYCdMte1oJg3mGkXiMFi5e+0ukBhLH0F2lWf2jLE4E9FIiWJNPoz?=
 =?us-ascii?Q?Mdz2yqyxUIlOZU/hVXq107XkyXtFo+omWyfRhToGNQp2yIigIV8L5Fe5FR9C?=
 =?us-ascii?Q?tkFJkDCU4goEuZggq0iM+8PX8jEzs+hezOq396o5Xxse+F9/YaALCsJthdHa?=
 =?us-ascii?Q?MHFEFTXQHM7ZK2Wm0UMGm5cOgNVFu4NxCWfYOHZ3sdqD4iTUkDX1SrHGHpRX?=
 =?us-ascii?Q?OCOP2Rw559pMCBrIXPajmjwuJ6+5bNDZjim/+PruUWjONeOS0RWLZPB7srvf?=
 =?us-ascii?Q?a9onKNLYQgbyxureg4Xtbv5inf05PiaYCJdF5g19EWlxgDMsurxWCrRqU2sI?=
 =?us-ascii?Q?fXRqzAnHFoUT8wpdcoWYdQQS0DSr2yTtXmUMJXgZj1NDGs3MdUdzrlAwZ5dF?=
 =?us-ascii?Q?kk0l0NiZVjGl1j5pgF6JXprqSpuRNWM6uYgugUHJX3d6kSv+uqxJcD0pM+mh?=
 =?us-ascii?Q?r2sNWeAfajMqvw1dFdnZot1KTJ7Mii7+JqJz/N6rLfGBdCuRkXfwvgTRydGF?=
 =?us-ascii?Q?oTHTU6SyYbUh45O8PaZKxv5fLfjoOP03/erSeo9x3F+d9vUYdAIUOGSKO/mj?=
 =?us-ascii?Q?nzMlSw5Gr2eSFcKojN7x7vLyfIdWuYIrdOqouVTS1Q4MyGFqvHFk2Klbau7b?=
 =?us-ascii?Q?O+sQOzhmtYm5KQjJFtvpAZpFrZ8ibS2I5MNkhR4kHy6hSqABe10jW4VOBCOL?=
 =?us-ascii?Q?GkYgcgscdZSdEbxtKklA5NP38sSW9+XBqW2BbVtu?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: opentext.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 299df4d6-eb20-4c8b-9873-08dd6d65f6e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2025 19:31:25.7438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 10a18477-d533-4ecd-a78d-916dbd849d7c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JMhLn2jTAxdQdQ9L6r/9r7zF27NiHvhX/aNBxBFRguCh61xI6d/uvqmvPK67K98FFux897q/E1Enzw6gcYOHaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT5PR01MB11232

Hi Enzo,

>Hi Mark,
>
>On 03/27, Mark A Whiting wrote:
>>>This is the fix we used (rebased on top of v6.6.71 tag):
>>>https://urldefense.com/v3/__https://git.exis.tech/linux.git/commit/?h=3D=
data_corruption_v6.x&id=3D8d4c40e084f3d132434d5d3d068175c8db59ce65__;!!Obbc=
k6kTJA!fc_giYPJqNz1XnCor_bLo9SweW3OpnLjx3UuSQUa4VtQQTpf3tIPquZbE99cQ-MmSQiL=
AnryvGEZSMpEY3qeSQ$
>>
>>I tried following the link but it gave me a "502 Bad Gateway" error, I al=
so tried the link on my personal machine at home in case it was my corporat=
e network blocking things, same result. I don't know how big the patch is.=
=20
>>
>>I would be happy to try it out.
> Any chance you could just drop it in this thread?
>
>Yes, sorry about that, I'm having problems on that server.
>Patch is attached.
>
>>>@Ilja @Mark could you test it with your reproducer please?
>>>@Steve can you try it with the reproducer mentioned in the commit messag=
e please?
>>>
>Thanks, I'm eager to know the results.
>
>
>Cheers,
>
>Enzo
>

This patch seems to have solved my issue. Before the patch I was seeing a j=
ob failure rate of about 50%. After applying the patch I've run 30 jobs in =
a row without a failure. I'm going to spend the afternoon getting this into=
 a build I can send over to our QA and let them stress test it for a few da=
ys. They have all the fancy 10G networking equipment. I'll let you know if =
they discover any issues.

Thank you for your help.
Mark
