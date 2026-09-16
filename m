Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazolkn19013087.outbound.protection.outlook.com [52.103.33.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66F630D410;
	Wed, 16 Sep 2026 14:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.33.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570277; cv=fail; b=RWW9VFRKzjPRry1pL3lNqyOXaW50DfIVZiSgWHikkFxSjUdxdHWSHuBTLYGEKFIN8DCVFFqhRJKGjoFo7joE/0ukWo1BbrNZ29fo5hNJ6NOcKsQBL+x+MdvYiYYaG0Y7oUbJp+q0uvNtArq8Yg/HGxPX+8ALycog119JqHCt+P0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570277; c=relaxed/simple;
	bh=jSAMiyoZBWCi/g5yDzYe4iJhIi6KK9oAYq/S4CoY/oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rmYE6RxqRiPbZ4GKgSG7+W077u/umU3OadCNk2QS+OlHKEdyW3+eo62ycSKkcYIVmwjHKPOiGN1KWiSCCXRG9FMzumFQ0w43JlVsKtiWjKjVh+FoQq7EpxH4Hwnpv0g5mOoj1GyhsjbHp20cix4nxLvJxtDVt18dojOKx9cnQB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=Yfny83Ae; arc=fail smtp.client-ip=52.103.33.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="Yfny83Ae"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IHX1ccxaHIR9v5Bgvk0zQzh+rQRm9iKVPGe4yv/YltnRb0PnX0Cz9iqH+sZ7TiPlY/DvQUj4ch38Mbh2cZ5+Ekl8LgUqKbRkQWUdEF6DN1JjmUyOaLc4sMTsdchJz7qsqUa290hQHXR9o3d3bSejkUMvAQIY8c5ZoSKdxpaUrm4pLwuzKMNm/f5/igdriKriN8fM6EgldP2EzIEi1fz+9rh2nq7SxN8vmkdUM2ZSIyRx7/kif7qmNc//+/ESIpsghYH/4Sze2+BMFt7yOgMbpF26n+ypJYzivRk0D0SafUmX2XcGAW6dhjlBHH3TLGyKf9sPbAaiaJ7CMajhjBoZYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vA2gfjTy+sY3i4lCKxbpWGqke061qf/KmmppcNa5hM4=;
 b=CoJpwifpwMxtPNtWCalExaI3rfk2SF/r3hLiIjL+eLt0HEg/3t4EJss8lIBjWHYpl86HiM8+DHDd0X4T0/bHxgWEHx3DwGBNknAoT+W/oLg3BFR8kDAoUqMyRAVwk4XN794v2CNozMu1VSqAW9D+lOhyx25XPmZNjflgzSsmw8q/JxfEjqpStTxI6ofxfQEMqTYKeID9e/qCB7Cwhatj70aeTa854Lf0/XYinS6bIROh/hspAK/h0k17X3jcvY1FZwL74d0AI/TaBUvUzR9FyiforAsjxdOrB/W3ODgBD3XXLkSF8MVU4GrBdbkoImQpc89H0SfHk/JUDCXd4J/r6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vA2gfjTy+sY3i4lCKxbpWGqke061qf/KmmppcNa5hM4=;
 b=Yfny83Aeju/+NvBrWUCR/Fnc92+mwFx8dmgLTzZWwRbM0HohMEFejMPgUP0AJ3QaZk3XLUYCl9Stt1nKc2RUYZPSK5/+BxmblZh+0a1v7beDFnfCmRYEJeTz74gjNpt9jT4Melq/3LJjC6/EC56g4EuukMD9P4na0XzSl9qCM7qfJplIx+DH0AfTOZYzn9TI2kaDDgGnZ5ps7trTk807388N9kjybk5xS1AAMnM4YVnOhoeYQ0uHPq+tdb18a0m6TNzByztIgmkWqrYzaxPIZMasXXl9tUloU8yPUIMSunsWmquO8/TY0iHKkfCfIHuD2Frez4XoMN2vJDa6TUVCdg==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by PA1PPF6DAE47C59.EURP251.PROD.OUTLOOK.COM (2603:10a6:108:1::219) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 14:51:13 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%3]) with mapi id 15.21.0428.008; Wed, 16 Sep 2026
 14:51:13 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Aamir Ahmed <elb12345@hotmail.co.uk>,
	Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ksmbd: deny access for an empty DACL instead of granting the request
Date: Wed, 16 Sep 2026 15:51:07 +0100
Message-ID:
 <AS8P251MB00015CF4B8D5C12B335A5291C8B92@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.53.0.windows.1
In-Reply-To: <AS8P251MB000152D9BF4B8E0601640661C8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
References: <AS8P251MB000152D9BF4B8E0601640661C8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0083.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::20) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID: <20260916145107.903-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|PA1PPF6DAE47C59:EE_
X-MS-Office365-Filtering-Correlation-Id: 925fd119-9a36-4071-d108-08df1401f36f
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5072599009|15080799012|23021999003|25031999004|37011999003|8060799015|19110799012|51005399006|55001999006|25010399006|24021099003|4302099013|440099028|3412199025|26104999009|1602099012|2607281247196008|40105399003|10035399007|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+N+LkRKNEqxQkM34qwizAuh9XRZJqwbvYevS9Y1njPVg5PWfAA7ewrEeXxr6?=
 =?us-ascii?Q?/q96I+siLikUvLBgO22CBrYBpoIB1Ov3xrQ3TidilZQuPgcEvt3WLGppEYS4?=
 =?us-ascii?Q?4z5SRAWmG5KZA1zfgdMqz4+LNjQEHqMrW+lNL7YqHa37YNwJzKmsawetzYww?=
 =?us-ascii?Q?E13AawchMojhWSp+kLc7N4QCFtqSneNkLmJNF3VCheEcIKfvaG5IkkbXtfAC?=
 =?us-ascii?Q?S2+2aL3iitm7YC6wds5orvz+gh/aUWqcqUaAbGG1AJlFwrXbEIhdJkXI4pKO?=
 =?us-ascii?Q?f4fkLzoq1opKBCj1nVqHyGwOFFm+Lrvlu1taI4+Of7/0QbgSHH6mQ1Cxhj5Y?=
 =?us-ascii?Q?21msF/FHFtGzeARqfR9b3C5/E5nMMDxMEhXTxSvFkgmvf1ovxI07nr6Q9Gvs?=
 =?us-ascii?Q?3GYbPmcqxd/i6zDAf7tllKeklN+53p4u2FH14wyV3vdlRZV64Gw1oqcIxRrm?=
 =?us-ascii?Q?xeB1SEa7nFDNOrBr7Gk5gmM1hMJuJs4cNnthNW6CI+3tc/LGfny1frT3js1F?=
 =?us-ascii?Q?KeMuLJunvTctMbqa3+bP8Y4jgrTLzF3sSOaOL/Bj5eZXwKHXZft6PfSZSvyl?=
 =?us-ascii?Q?miBEIz5X20rGQvGZrJjWpQwWLzJMo/ZZ4EhEr35VB16Ai3Q30/Ma+EGixgVF?=
 =?us-ascii?Q?2gTrEb0vTOXe54ttpetVLySHa1Fl5OuWBDdMpo7TazUFnEuTrs8nh9ai15IY?=
 =?us-ascii?Q?B6jUIWjLhrJBy3UMk+1jLT+Biwp5SpTnq4LeaeaTRUXiRZffJjO68dtsuSCl?=
 =?us-ascii?Q?SyyzrND6iN4rGeNUuD4MfocrO/bVbVxk5T1dInVP+qhoY1mI6t1cgvS+ewJT?=
 =?us-ascii?Q?JIQ32/1bqEcu9S7gxB8Ku60Rz3XxrV5Xoji0DrrCWvcRIeDQRiqu473+yNmC?=
 =?us-ascii?Q?MsgH6b7hc1NOMduA7LYcmifAcpzk7AXENFfc6zpWZ4x6+D3wgF1B65ucALAb?=
 =?us-ascii?Q?Q12yOOKGV9zIvoNrz2oUMNFmPm2dKBH1XMteewcerWJP/tQpxEqLXTMwzJFE?=
 =?us-ascii?Q?pltVLXtKgG+HX3dp4qj8siSo22OL0/kymiseU9D4pupqp42U5L7HATEmkSo+?=
 =?us-ascii?Q?Krc6K78Ijbc4fFQp8u9A5zIPQZ4NFTx9EP3dNq0JVEtTug+rlqa8v4xCKpBt?=
 =?us-ascii?Q?MI0Ib7pKeyBMFuXNu9xTKkOh/2NV3y0Hbg=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+Ht+UuJp71mKnwLOPeL4jbQow4SS8tiVaLjtuc6gO7N2k+nUqA+uaQaa+Lq8?=
 =?us-ascii?Q?+qHBK++ID4MzgWXyvBQUB5/5miHhkC/7+KOAZtvDvRsXWLXZY4A9MQPe3WTQ?=
 =?us-ascii?Q?6vPvzdQ+yunQ3FrHUhSU22mBe3kRHFlfhS8itToc2CQXcS8cawvE6VLCJp6l?=
 =?us-ascii?Q?0mtNeeKNwqUSk2SCKw8935pzJIs6q1W6vUmydrxCbqQM7mhLzVDLbW1e26CB?=
 =?us-ascii?Q?oxzulPX8Tl1BqgXPjbtjK8P1ydvCVckoxpqxmKh6CxBrmKzEEEowc6Hmz+7m?=
 =?us-ascii?Q?pDGiRsQhuwZXUnZEIPsE33yNkz4pTR/owVsL4xiQixVzxsZ/DdtUHJeQlkdd?=
 =?us-ascii?Q?K6vd2QHGn9cyWldgwW1+fLHuB4mVirNEjKpQbri3ADhwbPj9JNKI5x6Lx4l0?=
 =?us-ascii?Q?1u/JHmKdzveYGjBAyIgBCaJJTs+ruhnlGWb28Qu2RjIulUq95bD2jnMWdDyP?=
 =?us-ascii?Q?aGFtPlyID09KWRladAWW7rKiTxCfIUbdJeSK26lcFlFG1QWWV+djOdKqHLxH?=
 =?us-ascii?Q?Ql/5ElYM2ZRm8h4NmFJ0Mb0M0cASFxE9UyFTGC6JLuu5dovi6nm2r+CgJbdT?=
 =?us-ascii?Q?ck0RJZLXvrmKdEPa2wj9vMnRRg2Z9twkkt8tjLl7BLgIJLv3nKh6CcPR8noP?=
 =?us-ascii?Q?144TOiSHfoj+9PDjFde37cfzRKFXEgpqJBmC0u/zWk40HAE2eVLulNdgoC88?=
 =?us-ascii?Q?j5fHD8soZ+X6jhdiFZ0Q/KBZ3eusVjSWFv1gtg2rm3VaF1orJBDlcJFaG/jo?=
 =?us-ascii?Q?KI7s13bRcp+MNKR5NI0VT7ELoR6+lQwJAeFFvrq38MX2Uxy5xzwCMp/XSJ0+?=
 =?us-ascii?Q?P+lC1GEqSM4qumv6sVqY0cAH9QbhvKEWnlsoDaoF/7IgXhbVgtEK/x0HVFyX?=
 =?us-ascii?Q?RS6OWsmbJp3/Oouyhli7BUsorM3BlIcSRQl3lhsLQ1QP/vzvKXwGhWqbAxnv?=
 =?us-ascii?Q?Fl7QYUQWIFUYD2cGfvgCQpL8aXGhQdDHr9z7qnRyEnHu2OFuvr1q9Y++XJyj?=
 =?us-ascii?Q?BBw6tSXen48g7JUQ/XV2wkDxNYmx2j7AjQw0qaTFv9EPZx007OV0j6lWzZdm?=
 =?us-ascii?Q?IuC4wiLjEIT5tjH1cKTTftGENbOBHEs5Xe6dRpxyQySCa2Jkz7Sp5NURt8mQ?=
 =?us-ascii?Q?my5gFWDH50uM52LPRFui9/rcUQ6c7Uv8OuKcVU7tf0qF/QgYpoAksiU3z0ZK?=
 =?us-ascii?Q?B5qUpps4Eq32rV6A3Ml8skvtIdnRMK6srZWxJxeJLY9K3syfu8gNpxotVHl9?=
 =?us-ascii?Q?bdn88jCvaRmMdh1J7dyggaHPbUxNeveShep/4CODhsBoTnh6Q0D9Oc8VFpps?=
 =?us-ascii?Q?ZjmEWkhJTnNll1vwWxz8fOjcimQDKMnkDBHZIJHpQN4c/Zh7XzIRDULvddCs?=
 =?us-ascii?Q?AuqkjOYycIXQIhHzSVb03caM1MF/iFozZsPYu5uZUWQPcJ330z7F+XwQtjPu?=
 =?us-ascii?Q?l96FmISxsmM8TZe8/Xpop3zHGI5FrDZi?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 925fd119-9a36-4071-d108-08df1401f36f
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 14:51:13.0562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA1PPF6DAE47C59

Superseded by v2 (adds the missing Assisted-by tag; code unchanged):

  https://lore.kernel.org/linux-cifs/AS8P251MB000104EEF679ECC44D8791F2C8B92@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM/

Kind Regards
Aamir A.
