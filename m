Received: from DEU01-BE0-obe.outbound.protection.outlook.com (mail-be0deu01on2066.outbound.protection.outlook.com [40.107.127.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7108F10799
	for <linux-cifs@vger.kernel.org>; Wed, 17 Jan 2024 13:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.127.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705497948; cv=fail; b=rWRvO3N2MSA1T/CtNXqq+CrZEftUdizhG2Ncxaasm2/iIxGtiVRoqribjOHv53+EzgndYykGpul6ymMg8S8D+Qa/Yx6ZBqWsvZnYgdr8pF0C9w6YJzUNNRfp6ncyFM6X/VKFAznt6v6G/6OMxOs+FcvLoAIZgv3FN5xqQShGHDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705497948; c=relaxed/simple;
	bh=kS/sdL0Cu4xPD0dDxEWXvr5NvoYxNUZftDoEjpgDWEk=;
	h=ARC-Message-Signature:ARC-Authentication-Results:DKIM-Signature:
	 Received:Received:X-MS-Exchange-Authentication-Results:
	 Received-SPF:Received:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-AtpMessageProperties:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-OriginatorOrg:X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped; b=gMShHYN1RY7Jg40bqJt01zKWCEUmPpKVOMku1dzO4j4/zJFn6++LaBQ0PhHLJTUPmOEijtzzRD4LwLLddyscSSOfGibOfh0N+HzURiX/X5K3fyI7Yuw/apGeNNX1AbuEy9Yl96XdBrVnoOlfZWp2xZbxxZbp/tPAI0tZLRo3jzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=seven.one; spf=pass smtp.mailfrom=seven.one; dkim=pass (2048-bit key) header.d=seven.one header.i=@seven.one header.b=nv8hz+Xb; arc=fail smtp.client-ip=40.107.127.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=seven.one
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seven.one
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=seven.one header.i=@seven.one header.b="nv8hz+Xb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S120SyiYZtoMxOFLdTct5P8cJtZTPtrJNIUXx3/B2jzKbOUw01En0VTzPI4IVKiQFKN0Q5xYBJ3CR8qJj98SsSwWGPX6fzU1gfPlvor6Ybfhcx2c4/kDEBgSKztWDscg0OPGz4tjCT2IhbyY36Z+gFyVr6SkCRj1fZM2LRPQwBms8K/VJwr2aOz4TA13MAxkx0j9PKSPav/twQ3DOFq2JDp4nxWXOcra1xovAhhiYAKvYWu/LTeNI0xeHn/fGqsPdJlJbMDKoVGnX3pShm9/LxvAEO+YHIsQOgGJgACs8mzz12w5W59sNYDgqFGFoWZn3PA5kFUqttaEX9K7X0AepA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cLRZlwPba8q2YhgFCLrw3+jy9hEo1OHelCEpMprRJJM=;
 b=AYLo/FXQx1P2DmGMHv6EaLpwI0BAxre5DAyZAzZBcFxicKqO2XVRhoDTJYeN2EiMWVlf9Vcu1/pEahFENliMqRJ43p5CJweMYam7yyYrCCU1AJ5HI9bGbHpxcHfoGWWr4SH4J3kRDhv0JFI/no0WrubP+dUQc0DN+a3IbijdED4qd4m/+QgA4O3e+GuUVvm5LxwTxq/026crddHG8kWRf2cP8SrZy39cniHYwRkHZQkG26rCv9YUipGtsBdWNvSXCOnEtFWtmdj6eJ1jqomotKgxtkyV90adpQ1ClsIvml7z+VtNPBkV7I6fu21hMicb5QCWMQk7tMag9OeWcYERtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 81.93.117.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=seven.one;
 dmarc=none action=none header.from=seven.one; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seven.one;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLRZlwPba8q2YhgFCLrw3+jy9hEo1OHelCEpMprRJJM=;
 b=nv8hz+Xb5lqvPFEygpB/kZkBR1qOIr1o4CiE3oPnPskvH+CGqNubZp3aiaHhf9lVAvkDkk8rVDEqU0nxXkSO/nfcBAbURNMIplzovyk9nShsRNC42w/x6sDe0zBivv97+3O1L9g9pr+jfOkBh9mQPxffcOlgxXuFc/pVGEvB7iYszHCbr3U9BVWr9t/5SZvk8pjFkN8B1waF7ePj+738hSGK0jHdy465Jm4Mom4SVHzpoXnE/ydvuC199Cx3pOsz2z4rRSK6mwQ14L/mnEVHnYL3sNkuA/lngcrE5WEiKMAgkXsOydDJNZFARGTgKdNFEj0BwgJDTka3GzQfPffzPA==
Received: from AM5PR1001CA0058.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::35) by FR3P281MB2284.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:37::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.23; Wed, 17 Jan
 2024 13:25:42 +0000
Received: from AMS1EPF00000047.eurprd04.prod.outlook.com
 (2603:10a6:206:15:cafe::84) by AM5PR1001CA0058.outlook.office365.com
 (2603:10a6:206:15::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.23 via Frontend
 Transport; Wed, 17 Jan 2024 13:25:42 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 81.93.117.34)
 smtp.mailfrom=seven.one; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seven.one;
Received-SPF: Fail (protection.outlook.com: domain of seven.one does not
 designate 81.93.117.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=81.93.117.34; helo=mail.p7s1.net;
Received: from mail.p7s1.net (81.93.117.34) by
 AMS1EPF00000047.mail.protection.outlook.com (10.167.16.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7202.16 via Frontend Transport; Wed, 17 Jan 2024 13:25:42 +0000
Received: from com-exc-vw1.belgium.fhm.de (172.21.12.41) by
 com-exc-vw2.belgium.fhm.de (172.21.12.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1118.40; Wed, 17 Jan 2024 14:25:40 +0100
Received: from smtpgwint1.fhm.de (172.21.12.31) by com-exc-vw1.belgium.fhm.de
 (172.21.12.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1118.40 via Frontend
 Transport; Wed, 17 Jan 2024 14:25:40 +0100
Received: from app-degfx-vy1.fhm.de (app-degfx-vy1.fhm.de [172.22.145.38])
	by smtpgwint1.fhm.de (8.14.7/8.14.7) with ESMTP id 40HDPe4Z028484;
	Wed, 17 Jan 2024 14:25:40 +0100
From: Florian Schwalm <Florian.Schwalm@seven.one>
To: <linux-cifs@vger.kernel.org>
CC: Florian Schwalm <Florian.Schwalm@seven.one>
Subject: [PATCH 0/1] cifs.upcall: enable ccache init from keytab for multiuser mount sessions
Date: Wed, 17 Jan 2024 14:25:33 +0100
Message-ID: <20240117132534.2623424-1-Florian.Schwalm@seven.one>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AMS1EPF00000047:EE_|FR3P281MB2284:EE_
X-MS-Office365-Filtering-Correlation-Id: 29560bf6-8632-48ea-fda8-08dc175fce32
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XiwShTwjmRpt/7L5uUnsYQKVeqb3P5aSvKXt+UuQEEannV82NoDMJ61KzYLreaQUDQgKYAPZD2aOt8ZOp3NTWo7K6lloD0pnjr25/B6z96uDc0z2ibarqV8pmYoF8MRuGH0y771nN02Z11JZSwlmSw2VPmaqGHoJO1f2iRsXtxvQvRnD0T+2G2OvJeWBI7JfdcH5hn21W6vFV2sK4op8ONsUOFJmfQezsW7nI6nh3VnoOw+w0Sfg6stZ70tie/7XfJdO8fl9nTcsWSfmDZginbcC81mS135SFTiy3dnWZXjLSFM+75afLhopNdhRcVsEm3bbZJaKrYtGbA1bMOhURHMK8lrkJYWXpxNScK/AayKpHfVsRiLtV71Hzf2IgCGS4/FMWeOSNk+Et83dZ7CbrMd1Dd4qtF9omIhe5wZuo/rk/HK15kQBmWVkAurscAEeAWidkz6Hfc8nXE9c4RmXvnceNFZjOf0pwLYTPrxw04sNe/Ch4rbS5OftRjQRkPBKqCq1X8ky5JufZ5I5QU/LD4+3UpCWQtf6Va4hznhrS3SZvwk2jsWvDrbO/YmUv7Wbzl2O/D1tXUfZ4rCYNCMd4G4iiCwVSTWrs0R9isx+0FmMRiGpVysT29czVxNGP8aUwH9J8gM1Xi2aNJWUPAnV5gKLkwPvG6sxNSmHpnloS+NzFscKSq+jCkaI1gDxub1GX8NKyuwNFkSRtS4yy/iGGELQR0rpNKc2HTVJPqIlYtGHVXmUxW4BzZUtiiAGOiT55HkkpdnCmYCvRjvhon0HMA==
X-Forefront-Antispam-Report:
	CIP:81.93.117.34;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.p7s1.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(376002)(346002)(136003)(82310400011)(451199024)(1800799012)(186009)(64100799003)(46966006)(40470700004)(36840700001)(5660300002)(41300700001)(2906002)(36756003)(70586007)(316002)(70206006)(6916009)(86362001)(83380400001)(336012)(26005)(2616005)(107886003)(1076003)(47076005)(40460700003)(40480700001)(6666004)(478600001)(36860700001)(8936002)(8676002)(4326008)(82740400003)(81166007)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: seven.one
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2024 13:25:42.8079
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29560bf6-8632-48ea-fda8-08dc175fce32
X-MS-Exchange-CrossTenant-Id: 3825a6f3-24cb-47d4-8aa2-35d3e5891324
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3825a6f3-24cb-47d4-8aa2-35d3e5891324;Ip=[81.93.117.34];Helo=[mail.p7s1.net]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000047.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR3P281MB2284

While trying to configure kerberized SMB on some of my department's machines
I failed to achieve the desired scenario. The idea was that multiple service
users on the machines each authenticate with their own credentials on a multiuser mount.
Since those service users are used for non-interactive tasks the
credentials should be initialized automatically from the keytab provided to cifs.upcall.
In debugging the connection and looking at the source code of
cifs.upcall as well as the cifs kernel module I noticed that the keytab
is only used if the key description provided by the kernel specifies a
username. This is not the case for individual user sessions of a
multiuser mount. Since we already scrape a gid from the passwd nss db
based on the provided uid, I thought there would be no harm in doing so
as well for the username in case none is provided. This is what the
provided patch implements. By deriving the username for the user
sessions we enable those sessions to initialize themselves from the
keytab as well.

If there is an established way to configure this without requiring my
patch, please tell me where to look.

Also, please take extra care in reviewing this patch. I haven't written
any C in a long time.

Florian Schwalm (1):
  cifs.upcall: enable ccache init from keytab for multiuser mount
    sessions

 cifs.upcall.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

-- 
2.39.3

