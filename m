Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021121.outbound.protection.outlook.com [40.93.194.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B876195B1A
	for <linux-cifs@vger.kernel.org>; Tue,  6 Oct 2026 01:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.121
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791250463; cv=fail; b=sNBqHsXQzT2e4WCiPfRXdSA4MN/3aC48rdl6W/aBMk/9ZXrpBZCnvzufp7UYATNxoGKItUpVwLB9RYj6/TUTrBYvzeSXel0L9qeqPRBWMDhmCwIsWC9XanBf5o7Gvt1QybfrffKwTnFMThKvbaBDcAqHyeVmdhcDr5O1hppXtTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791250463; c=relaxed/simple;
	bh=SPiHmE6jHEE4E77aBLzSHeTFfPaZzVsjm7/X0xoRZTY=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=NnsjDv1jA6eQob2nhwXd2ufjjz/MopQIhnyiz6raasbXJTRsUAEgSh9WozsaNlvDp+sXPKqbfdq9RzsKzcwlkb2+cR1P+HwLpfBL5NYEIe3PZBt1qbDUTItZgrZC8HgqQHCKucgyM6ZY7JYOIZdGVGGbZiWmWStRkXiCOtuUAVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.93.194.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IVDIMZksWupok0sLH8c2fX1MJFIoY+vLkhsDRog6cPoOsq8L3qxHuwx/ASuAFjgyoMhsuhhZ/cheCR3ePl2ig41kVteJZBiJChLg6wk30gT97KOIw+N/7xKR8jjoGbVgqf7044dDxj1gKDMp98kBk9pTiE9p5buKJczf/Qi46uM4hxudYqiY39xvSZ81miZxrVmnzDMems3K61xoZh+AFhKTOFhw+DJj/1iz1e7+IfcgsnyrOeHsxKg58BKSR0+OrxtZzI8yDrDMvxnnsfZKo9sPqdboqH9bQKhYOovbUISFYkX3rb91+IdZlzt2vrrYC7G/hdSX9+trewYmJDP5Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SPiHmE6jHEE4E77aBLzSHeTFfPaZzVsjm7/X0xoRZTY=;
 b=bFCIQHJSJrniiT2IlbhVh7O9X69PsQFpdVR3J0T2KNrCC4VydN5oC3EVvy+QfgN3SOLKfXGZ7c0QEMC9F48N6iem0u315UPCfr2bFTNmNlhRgAa2lJS3vSWPvNUEFh5GPpegVBSn8d77TXMPsx6K2Efz9z0Y40pb0jY6vcwDkDBBX8sAwwgeFiITadNPJX5U/jWRV7yeiCMlryqjbkizkiQeA2+Ec/vFHywkgmXtSVWtTfzCKkw3k6udQ8zWm1XprXR0MptJcDxOjvD+jyMItmR1zrsfP9hVA4mRZEmKSN/rN855aH31UswccR8JzeR6Rwmp/b0exTyJ1BqGe5LoWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from MW4PR01MB6338.prod.exchangelabs.com (2603:10b6:303:7b::15) by
 DM8PR01MB7175.prod.exchangelabs.com (2603:10b6:5:314::12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.20; Tue, 6 Oct 2026 01:34:19 +0000
Received: from MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761]) by MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761%2]) with mapi id 15.21.0472.016; Tue, 6 Oct 2026
 01:34:18 +0000
Date: Mon, 5 Oct 2026 21:34:08 -0400
From: Tom Talpey <tom@talpey.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: =?UTF-8?B?7J207ISx7ZiE?= <ihopenre@gmail.com>,
	Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, Paulo Alcantara <pc@manguebit.org>
Message-ID: <6981e5e5-e856-4613-a3fb-c8cdc7a9219d@talpey.com>
In-Reply-To: <CAKYAXd-2uBhGZuSFdLM00D+Sty2+DdGbZLWiA1DG0jGvfJjUWA@mail.gmail.com>
References: <cover.1791229120.git.metze@samba.org> <CANTrAmwHqivuuH9UhPL=744OQTZ=qzahqHV6k5eLEPgap3uBdg@mail.gmail.com> <CAKYAXd-2uBhGZuSFdLM00D+Sty2+DdGbZLWiA1DG0jGvfJjUWA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] smb: smbdirect: fix listener backlog leak and
 teardown races
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <6981e5e5-e856-4613-a3fb-c8cdc7a9219d@talpey.com>
X-ClientProxiedBy: YQBPR0101CA0127.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::30) To MW4PR01MB6338.prod.exchangelabs.com
 (2603:10b6:303:7b::15)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR01MB6338:EE_|DM8PR01MB7175:EE_
X-MS-Office365-Filtering-Correlation-Id: 843c51ed-937a-44ea-2c9c-08df2349f093
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|23010399003|366016|1800799024|10067099003|56012099006|4143699003|38350700014|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZYmIxN3LP3a2DDXdMKeZ0ku3c1tuMaO5b/mnkQdL7U4XN5+RX7xPXGCHpDDKEc4StsbLJ3zRrnYx5mKtARm2B5Cyz4z7etUnrWZn2DmMFhz424EYoGAdr9mKRjszKnUCt+91qVZTfSpL12tHYY61Udpo3V0qKIv/pQNFmlbDcl7YxjESwmw1Dj1UyYv+NBQ69Vd2pt/1CdmsAEr+oC3p0Muc7+bs71uagX/Y3+urzeXlPwA8P3xy1L8Mof3XMawQF6xRXbYlMq4saRDh586QgWLMZYUObeCXXa861keF7D3NxpgjMf+XPkQtal/oLFAu4JzNMQDIvsCTxpRqhAUpN5AVDSTIaAQSmzEwmWsUamdrKroQBi7NyaN34I8r+qasLfw4PumgFoBhTJwhqTEi77qPoqEeEa92KN5YWFfhQ30N3TtfiM/dXuRp1hMjtD4kvHWQkjkZ6/Cs1jXGtyVo5ACoJcotgRm05VyU3akJcq4NJ/r4rEDmq3EuzJHdG93XmuQkC2aPk7qGrVl6IX8UhVOrxPE+j6eWY+qZP9LWUHtdw9vsfuo0yiqSnLNAXmsrlWxn30DM5fZLt7F3jbrEmw6MY2ks7v0Xk+Mn5BizNLirthAH2atRrk9kMppkZNlJgATwJWN+d50Mu13vDy9Ftlsfp+rj8hApUCZ5n2mjj++cFZkkMAaqKUl/8XQswgCESdEAKeWmw8qWennWFaB6OwBOKCNqhCUDrLweFi/1yNI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR01MB6338.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(23010399003)(366016)(1800799024)(10067099003)(56012099006)(4143699003)(38350700014)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NWRaZXNkNVpnVlRyMjAwRTlZYWVOMDh3OXZLaDk2cWxXYlZNN3pmQXY3Z1R2?=
 =?utf-8?B?b1JtRHlSSlRCeEhKMndPWno5TmY1RVVjU0lpbGhFY0I1d04wMXVmZTJjR2s2?=
 =?utf-8?B?bU1HcXpPVTVvMmV1eU80dFNFVE5XRFJWOWlSRVlXY0dwT3dKUHByVVpTMVoz?=
 =?utf-8?B?cHROQlVnRXUyaVlRQjNaZUpHU0lVQURzTjJRN3hqWmorUVg2dTdJRy81VXdM?=
 =?utf-8?B?bTFtSGFqT2NyZU9FbVR3Uy9JUHVuamlxUFVFMnRXMlhpOWlMUEpJSCtLRElz?=
 =?utf-8?B?cHhqRUlGcDlQTkRTSXNKVXIwbUFOYkZXSkpsbG9EKzFYR1puRXB5U2VkWXQz?=
 =?utf-8?B?ditlZWZUc2RKSkd2Q0JMdERqNUZwSzJwMGZWY1o3N0JyYVdRRW56ckVIelIy?=
 =?utf-8?B?RXNJUTdLR0c3ZFVCMWYrd1ZQUWpWblQxVUpsL1dTTFBjdHVZblRBTEV2ajhs?=
 =?utf-8?B?TjMyZEx6dTQxRlpYblUxVmduQkdkdDNCVTBOazRBQm5sSnpjS3oxb3JOa3Zk?=
 =?utf-8?B?ZW5hRW5yUDk5bWFXWVdMcjB2a2xkcjE3VzBhdCs4NUZIMWpWNFFyZ3EvbmZo?=
 =?utf-8?B?RUZZMFdBblEvN0JNWmFWU09zbGs4MTJaYXdyK3B1dmVlM3FRL251L0xQNUZK?=
 =?utf-8?B?VWNYS3h1SW9icis1azBaSzE1UG94S1FSVm1yWG84ODJKVjJzQXdjbDFUaHV4?=
 =?utf-8?B?WWk2T2sxRWwzWWE0akNFU0t3ckpjMFFzQnVENThpbFNFYlNjU2VBenZ3TUhN?=
 =?utf-8?B?SUR5alJHaW5IWTN3UWM2eUZvSHBNNks4d2FmOWNnamlDM0YwSnluTVVYbzNv?=
 =?utf-8?B?aER6dXdoY2Z0R1pQRzdITE5lVkJtVmdrSTBVcEpxTnFaZmd6TGFuUkFFZUpo?=
 =?utf-8?B?UjZacm1UcWVqUXZTNjRUSE44VUUwQnJGY3ZzMUowNndCRTlvMVFTY2R1dEJy?=
 =?utf-8?B?elFJOVZlWkxvUGJVUUxUTGZFTE5nWG5STG9TN3lJMWVKZzFiYkMwaEcxMEtE?=
 =?utf-8?B?cjJyeURFbVhIR3FyVmhPRi83WUdrOXlEOGdOK1NEQ1o2YnNkd3BZellIcndP?=
 =?utf-8?B?NWEzc3ZvRnFNUXkvTC81ZE1OY0lpSnNDNnY3WFB1ajNRVFZsNEpNRnJ6VUJ3?=
 =?utf-8?B?Q0hqaDlTMUl0OVFucXV4d1BGVmVFQll2OWJQcld0RUYxcWM1WWdrS0dYY21N?=
 =?utf-8?B?b3MwQk1LeUpYR2xKZ1AxVUxQcFhKd2Y0VjV5T3BRTFREcU9jbWVtT3pYYWpv?=
 =?utf-8?B?aXprOGhMUkxreTJWQjJIUW43QVIxbjRkRW5LMGFZcFZqanZlOUJHV1ViTUgz?=
 =?utf-8?B?NDRLdHMvR1ZnQkZmdG05cFZxdHR2YXRzSllxdmM4WkgzSHhGUFlkdDJDMldv?=
 =?utf-8?B?cUgxQm0wWVhjYWE0WEYxaDBkMDBJVlU2akhYUmxEc3pEZlpCcHdyZ0R6dTdk?=
 =?utf-8?B?TlBTejJvNEVWZnZONVJub0QrNElWODl0bnRxUnljNVpuRlY0MC84SHZFbU5Z?=
 =?utf-8?B?L3RQRGViS2ovclo3T2lqY3V3eHZQU1UzK1RVRWNKTm1FUTU2TEpQT2t3V244?=
 =?utf-8?B?bnBsa2xBbU1IRkREeXF3SUN6ZHdhN2dHTlJweEY2MjJBM3BaN0dXN25BTStN?=
 =?utf-8?B?MlhUajlUeUVhODlxRUxVZko2MFdBb2dGRFdlb1R2dXdyWVB3cjBCcnNvVzJ5?=
 =?utf-8?B?QlRydEg2OTNzb3NxQ01hWVB5YWJyaWgxcERNUk1IeUFhK2JOcC90Vmg3aCsx?=
 =?utf-8?B?Uy82ZzB1SG1aQ0t2KzEzdzI2dUhZMmVRV2pmODV0ZGNSQ2E2ZHZFNGhuYTJx?=
 =?utf-8?B?TVNmSExmRlI2TjQ0aE05dGdvT2dqQ1BtZXp5VU1uR1VBQUFvYjRMR2hGVlh2?=
 =?utf-8?B?eXl5Y3FOSG5nblRDZmxpRTRxMm9naWR3WkFEVjNFQnY4MkE0Z2Jia21TeCtN?=
 =?utf-8?B?QXJaTllCWXhXTXYxd1FYUStZb2dpalVTL1hDWGJWTnhRcjQ4TnJnajladk8w?=
 =?utf-8?B?TnJ2YU9TRXAzQ0gvMko1UnpsSWZyeGVoZjN3QUltN0dnSXFjb042cU1wTWQv?=
 =?utf-8?B?THVSU3lFRjdrdDQwKzFEbGxUZnVPSWxOTklVZlc2OFh5V3cwejlmdDFwUUdJ?=
 =?utf-8?B?ajdjODc4SWVEUmdzaHlPY0VBYkI0Y1NCdVhVZm1PWm5vUjd2SnhCVmJJWFVJ?=
 =?utf-8?B?ZUtpUWduUC9uZVgzaStWMkN3blZIYTV4N3BlTjJldG5KSWVSTnJ0TzBUVy9N?=
 =?utf-8?B?Qk9sSkV1aExOckQ0Q3RMekxjcm41MU80ZmFnSHpoeDFZcjFxVlRMY1dRUCsv?=
 =?utf-8?Q?3LOfEi1as2g1PK8Nzx?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 843c51ed-937a-44ea-2c9c-08df2349f093
X-MS-Exchange-CrossTenant-AuthSource: MW4PR01MB6338.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 01:34:18.6744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2A9oyuPWl92dj7qKiZAxW20dcFEMfEPLvqT7X5C0fZUsxB6rnKDOAinzsSHKLZb9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR01MB7175

FYI I am hoping to be able to test these and tge others Tuesday (tomorrow) =
to verify they fix the issues we saw at IOLab. Some were not available when=
 the test network shut down.

Tom.

Oct 5, 2026 9:23:57 PM Namjae Jeon <linkinjeon@kernel.org>:

> On Tue, Oct 6, 2026 at 9:19=E2=80=AFAM =EC=9D=B4=EC=84=B1=ED=98=84 <ihope=
nre@gmail.com> wrote:
>>=20
>> [PATCH v2 0/3] smb: smbdirect: fix listener backlog leak and teardown ra=
ces
>>=20
>> Hi Stefan,
>>=20
>> Thanks a lot for the fix and for crediting me.
>>=20
>> Could you please use my real name instead of the display name in the
>> Reported-by: tags (patch 2/3) and in the cover letter, i.e.:
>>=20
>> =C2=A0 Reported-by: Lee Seong Hyeon <ihopenre@gmail.com>
>>=20
>> The address stays the same. If it is easier for you, I'm also fine with
>> you fixing it up when applying, or with Namjae doing it.
> Okay, I will directly update it when applying this patch-set.
>=20
> Thanks.
