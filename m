Received: from SY8PR01CU002.outbound.protection.outlook.com (mail-australiaeastazon11020133.outbound.protection.outlook.com [52.101.150.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9720369980
	for <linux-cifs@vger.kernel.org>; Wed, 11 Feb 2026 12:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.150.133
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770814224; cv=fail; b=FReceexa7r6V7jraHDdGHno3z+aH2MFSisosdsVXo5o/kcUVysbU0Rg2GLJKZftX7hWGgcDx3RRXgNs7LKfJSYlbbHPwG7e4Y0o81iOo3ogStvJIguiXEIyarVmteG1Wc4+6s478aNwKwx6c9NnhFRrX60R4hxiXw8UHK7AKVHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770814224; c=relaxed/simple;
	bh=mvEbNZZCbR6rwpSsyFWbnnsQ6MZz2tiUaIMKjEnVD0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=Cxr833qwe3LovNg2PMVWxypvvTaBgKDhR84O+31VXrYZhM6BzzVYT7QqWmy1uLSTLhbfVIA/EVvAD9Xw1lyAxA74P9urHdmAo4Kat5EGRc27y81jjr3SM4fjeaqQv8XwTK2qS9JTA+QfwQHGmll00YThYRyuM2LXo2Q3KKHzv34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=heitbaum.com; spf=pass smtp.mailfrom=heitbaum.com; arc=fail smtp.client-ip=52.101.150.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=heitbaum.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heitbaum.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zI9LgCYROFKRJPS+80Fgdl4svdenEjuy44A3SA6iXkHMEODm8Gz6VCK8/Tvqo9MfmWWHciLRoq6fQ9CKEtkw1P0jaP/5CVJMWFAxlLB9z2k2uoxTZLxThIoFdpwCS1RuHDX0L9KEIhYS2A/ZKij0vCJoUyRY96THdVtyk8wuQh7fj9OH61cFAnHQ0NPS127pbNoqhanGMP3rm89s/URc2sH0pwbybkABPV/ByJspLf+8xa4Q7ys55IADScFVWp162rPEC+iMIqWpBTmpuG2LE2M3mTUvfGaUdCUMEJEOzNcFAKWUCwJNwapzCbfcIT2l+UXK61uvYHJFhHxOMHBNkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QfUdh3toxcBfjc6FIvLEJlrfd5psuNCgbZuO9+ydYjE=;
 b=mGAaytFMJNNRmcC071b4uODdYalhsmKgs32Zj39HdGGRP19/WbObpJbSDFvL9oSv/S2QnrbRp0snOmz5wU0bzuA/SxHTHOVi2CFa9lZiiFA1zMkcTt72qZJ5yJMdKEi48azVZBjenBvUnuCO6CP2LOsFk6EC5RIjapX1TxXVCUkp82u2vZF4tofH8WwftqVVGLzc7LpqQPv/2LsLy5vHQc5ZhPSSVMckvc5rQzgUbZ/Daj/+X6MGN6YePJBFLY0JGYJ/zPWbncqV3QxFAz+cE3/XrjD80nWqMwY7FhrsN+gGi/E/jhj2zLLYbHHW5IiEERZNUy9EcT7nU6EGA/sKrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=heitbaum.com; dmarc=pass action=none header.from=heitbaum.com;
 dkim=pass header.d=heitbaum.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=heitbaum.com;
Received: from SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:73::13) by
 ME3P282MB1714.AUSP282.PROD.OUTLOOK.COM (2603:10c6:220:ad::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.20; Wed, 11 Feb 2026 12:50:18 +0000
Received: from SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM
 ([fe80::7340:fb70:eaa2:ee1f]) by SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM
 ([fe80::7340:fb70:eaa2:ee1f%4]) with mapi id 15.20.9587.017; Wed, 11 Feb 2026
 12:50:16 +0000
Date: Wed, 11 Feb 2026 12:50:02 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: linux-cifs@vger.kernel.org
Cc: rudi@heitbaum.com
Subject: [BUG] cifs-utils: mount.cifs.c/parse_options: const variable is
 being modified
Message-ID: <aYx6-kjK8mJ6cKSB@4c764e5e3841>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ME0P282CA0114.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:235::31) To SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:73::13)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYYP282MB0960:EE_|ME3P282MB1714:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ed83ce9-e4ac-479d-403e-08de696c1aee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gYPVMcbscCdyKoBwfF4xKcDQC9COP2fO3L268uXvHLKfidSSQOF4dmmM/bZK?=
 =?us-ascii?Q?9Upd4YKXbhBPugL0R+JVgRbiPzpCuzXoRGLx806y9Oath2llt+9FiPJXTbrH?=
 =?us-ascii?Q?rRKN42a7sbXkyOIW6VORXzWVwcR1YIfbiWCbBhPoRPpL1mbD/eg4x1UQqKuO?=
 =?us-ascii?Q?AXqtMBA0KejgEqRyPLHmvBCKKxu8iMKK230Emvw8YBfh53KIIPEdsYcbbaLf?=
 =?us-ascii?Q?pwZTwWzwTKxzf5mHiZxgEsgBpYatoJIqEwCCxEWIGrzEPG0cKcLnn8CJJBui?=
 =?us-ascii?Q?Wqx8bo+oHyLs68kngHVDFPc7PXInWGPAG75eEp0qd8CkpS1w2ZXObXDaLr/F?=
 =?us-ascii?Q?vhtOx6TZz5KyaZrsXJiEfnBcgL2ZkZ+vwwexLG6iwGtx7nwPoRTPYafoqr06?=
 =?us-ascii?Q?8CYrX2RDik6LkjQABHG+5QttlPtdx8wsUVI4rt+uB67Z2qXlgawvr7rZFW5+?=
 =?us-ascii?Q?YiUpIPsOj1BQ98VFg5Gqc9m2k1zzrQRxv83VD2O2Uq+hbjDwyoqiZ1xbmp3i?=
 =?us-ascii?Q?03Anb/khCEbegWQ1rgo79IWFF2o/8CYCtKojm0c5njCHI+M8cjdL/6aVwIRA?=
 =?us-ascii?Q?9/gCA/jDCWzj8DUSibvvonKxVB/MusxGGr2U/DhBwZI2PSXR8xhisjGvSu3m?=
 =?us-ascii?Q?AC/Wvjp69yP2ysny2gEGa6u9/kmoz1YFGgeHUTYb8fiBsHX+K5T7n5BP+oM8?=
 =?us-ascii?Q?qnLzAzNTHJSDCtmIeo/i2dfR9Ld6fAh7haN7rOsliDWLifV3J/rQmkw+2Ilu?=
 =?us-ascii?Q?F3pob6wzav/QbPvP5btkONF+sOoyw/0djMcuRukQ4KzBCnSQLjIiamQSh0Lz?=
 =?us-ascii?Q?8t22VBY1GIL7ir1SG0HePp4jlQVJwFsUCiIPiMqQfFwhuF++tPpKxL/nBnDL?=
 =?us-ascii?Q?xERQ9cf5n9UV3eNeQCTm51a52tYM9+faW0OV7F7yaWsjjUWbbvvUFMrdkpIV?=
 =?us-ascii?Q?1j33mQOXdXFzDJqs17BnMP59s/sUf1x8eVfar3VpssdROT5A8AXIQ0ZQru6T?=
 =?us-ascii?Q?sJKYQGrItB914vszZMJ1uF5eY4H+QZQvQDzWbGlgJEDo/YYwhwT8XpYqwxO5?=
 =?us-ascii?Q?k0icPKFg00lH91g9Ci4c84yKXQhYyNw1SAmJ/2tgEke2RsBvy6vuuE/h0BLX?=
 =?us-ascii?Q?0OlTSBvrDkQS85NDpXX4SUDn6HaKkinmgF84A74CoiKYx796rlv4efNirGwo?=
 =?us-ascii?Q?4VAOr4rSrDQ+yiVtVrcQyLDBvWBmZseGnIdUBIElVTm3hjs/wekzydwyf9ek?=
 =?us-ascii?Q?HS9wWwY7oycqz66pllirbivIC5rDyyoLomfjUq65CSD161CSNua3hdeVYTtj?=
 =?us-ascii?Q?RKmn2qgH2tE7zgXyw3NKBjPBnMbr4YEMBaS+8RjsVNXwdZSfmym7hzsIsx3t?=
 =?us-ascii?Q?8X5Uw4eFXxvSzKTKYZMZPQSrDV12N2EXoBjVr/js+IutQBL/HlJxhr73wDwO?=
 =?us-ascii?Q?4BH3zRbkR0lrr/JOlB4EYbglNs5ATteZBEHY0Aq9tzW8TlcwSGvFvTCE69dz?=
 =?us-ascii?Q?Bq/rgzGMa6gtl1k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jZ3i7yNiO+4wfZ2OvWJwZmvhrKutsHTggAZZ0MvIUSefnlTur6oRRcZxOIk5?=
 =?us-ascii?Q?MNTQlKvL7+ixAkGVx5jGzWF2Y0sf4sUcrGObETKwfp/rudUdMDmJVN9njhs8?=
 =?us-ascii?Q?uSvwRn5czjCgvChCYuDzqcwSQZC6iLlyUO4t9ZnaHGIMPOC0k7orfhFPIGYr?=
 =?us-ascii?Q?yNbAqGpi8vpV6rAkQhYEjR/lKXdmotb+k0WDkvYytIzemg5TGl4bYyV26iw2?=
 =?us-ascii?Q?UDuVI2ZJKzjXkLlgjEZMnBK7TP3U7hqi91jC6Z4KvkpIbNFNnFbRymf6gkIo?=
 =?us-ascii?Q?YcaXX7JpCuSoUKx2fo7eWXQSq3wASU+2+Z49x5rJw0E/twhXsNay1vvc39u8?=
 =?us-ascii?Q?p98onwy93ZxSXLPBvKMBmkZ9+UEyveoBcbjSUhkGja+IKKix94lf9Q96WXTj?=
 =?us-ascii?Q?tGAT2sZHxkv7Wqf3EOFB9GlMmYnCHI9Ls8IlaHJALO01/jJNUq66dHSb3oyN?=
 =?us-ascii?Q?3b+Hwzj6WV0aOPUrXuVir83nNHz8UPpWWVrD4e1AG7TYdLU6yh02oZx0q1uo?=
 =?us-ascii?Q?6LriHTvTz2wMmo1AuujBUbj87Hn76/B8OOXfmJxb9hnicxDZ8AqCN2AMNUjR?=
 =?us-ascii?Q?M/VRqJkr9YJvTVaA24EPXKXul/Ag2c4XAXcV+WnoymLEqBiyDui3YlkwHOds?=
 =?us-ascii?Q?Lkp0XlxvrPBAx5hag4Vy+f1TnFUUiIWze3D4W5BSUyp5hMhgSm0Y1GMhTKwF?=
 =?us-ascii?Q?xm5/Hl0DMdPnQV6webO4jawCAaqill5C9c+LafE26eWUwtt9g0UFTT+WKhjU?=
 =?us-ascii?Q?kkKEzWEYyZWwRMl6OsdpNz0ynwZFkz22YwreIEVqsyqov8RQSJTqhClNIbOq?=
 =?us-ascii?Q?aeR2j8U6F139AZXOxBwSJJiT7E6xJmDPkcLcfsxXkyAsRHfNs80yC85nzLoB?=
 =?us-ascii?Q?aS4ULzNAPI+S9Q22L3XH6hiAJMd3TN36eA214yvJQBRRlUDRhGQZZbb1mHqf?=
 =?us-ascii?Q?u1/IEJjn4SmVn7QFbooWq+a35POKb3Z+ZyI9onBx3Sos1MdsjSLlbBlPTSpV?=
 =?us-ascii?Q?79R/aPY70R9OTqczokE2NO8aa5iE/32hAVGTWZdXYD43VakB4mREtLEbRqdd?=
 =?us-ascii?Q?PA3gfv3+NPYaIwWkJqB++S6AhEKGP8CAptZWT2fNkLpFmngLMOMXteaIVhGA?=
 =?us-ascii?Q?i0JCvKNhuHSDu5F8xA5sMeaOLjHbraXqjc16FjmhmlmENsBGVEvvNf1LCtmF?=
 =?us-ascii?Q?gmJveQf7quRKtwqgkLgBCM7iWOGQCCsWJCBQEj3vfvNeQYLuqOGYdjFZwh3h?=
 =?us-ascii?Q?mjCyiY0PAH0pFMTmibhAVGtC3706MIpowQHCQcCuswN2fcBp6kl3ondi3O+E?=
 =?us-ascii?Q?QJljHxefoBpJ+g93Vlxlbiz9W/HhhlstOfQ4xfARTXn/edHaq9I8KmR/pZK5?=
 =?us-ascii?Q?bZpLk8kFaf4BoUAX+t0GsbzlvUc5KVhDlS7VApl5QwHD+fwQ8oToPQDUvlcU?=
 =?us-ascii?Q?8qMTnIRCrWkYUpzpUT+UK220Eob518FIJhykvrCVu9AcbGpkZEpFVwciuFyb?=
 =?us-ascii?Q?bwIMJ2d0nAECbpgGAIQ2E5Cc4zztM0rLlOjZMtaAjmHX98vZpbChprCBCZOQ?=
 =?us-ascii?Q?PCIed66Ypf1umkDFapGmkKf54TMUhYzD1Z7wSD8RBHex4plHfjWSZ0l3jD9h?=
 =?us-ascii?Q?7YYIcNgaqWjZJre27ajR33M8knLUB9vk5qN5ffitk0Ic43pJnJoEfPTpmTeE?=
 =?us-ascii?Q?dYjcaAiIr/kjwfEkwDnZ4oLpDusy1XvLmNCHgv4VAXeiBvIa?=
X-OriginatorOrg: heitbaum.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed83ce9-e4ac-479d-403e-08de696c1aee
X-MS-Exchange-CrossTenant-AuthSource: SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 12:50:16.3606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 35ffebb5-7282-4da6-8519-efab29b0108e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vs+5bnvhpYc0lgH2Wu5cCyRvruTDeffRq95hKW3h6RcprvKZk4VsOC2fb+eFQYN2jsyEjnoRCa/GRUWcpXLtTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ME3P282MB1714

In the mount.cifs.c/parse_options function - data is passed in as const
char*. 

strchr returns a warning that the const has been discarded since the
latest glibc / ISO C22.

code in question is:

https://git.samba.org/?p=cifs-utils.git;a=blob;f=mount.cifs.c;h=192391360bcaa29de964b65f77f0bf93dea64be5;hb=HEAD#l888

889: next_keyword = strchr(data, ','); - returns a const
890: *next_keyword++ = 0; - modifies a const

897: if ((equals = strchr(data, '=')) != NULL) { - returns a const
898: *equals = '\0'; - modifies a const

The warnings are:

../mount.cifs.c: In function 'parse_options':
../mount.cifs.c:889:30: warning: assignment discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
  889 |                 next_keyword = strchr(data, ',');       /* BB handle sep= */
      |                              ^
../mount.cifs.c:897:29: warning: assignment discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
  897 |                 if ((equals = strchr(data, '=')) != NULL) {
      |                             ^

Regards
Rudi
