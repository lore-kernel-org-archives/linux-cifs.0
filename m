Received: from DEU01-FR2-obe.outbound.protection.outlook.com (mail-fr2deu01on2089.outbound.protection.outlook.com [40.107.135.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D6F1EB4B
	for <linux-cifs@vger.kernel.org>; Wed, 17 Jan 2024 13:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.135.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705497949; cv=fail; b=mQswcFqOhPY/hksQQk8w7iiCQHoVxOuevq4x1afwpG4biZn2zl428y1EiZfbbmxFqabQwDUOAUOdH+WDXx8/5g5cVnTP+CwUygWlCwPN8reFOwHPquLKDnq7H7ihAxLgZQqwHG96OSssXPFRUseARIp2xpd2YovxlAWB4sGYysU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705497949; c=relaxed/simple;
	bh=GVUJN2+6WFzPFQ+008BMXGpok6lQkY5TrPEUAPnLXWo=;
	h=ARC-Message-Signature:ARC-Authentication-Results:DKIM-Signature:
	 Received:Received:X-MS-Exchange-Authentication-Results:
	 Received-SPF:Received:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
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
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped; b=tZLcXZ76qC6PUKA50RtKaZ5yfwCH5EzmAuStNidL8otYb1qfK4Pwit2sW00b9EETIgChhUW8X+rGdtEWRN3yhRyqOwXLJO5wjkTXa4tabiBbgxWpghQqAKmJyMAYn8bTS3kzIQQIwwQwS44y41gn8b7969YVp7MESLQswoz72vg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=seven.one; spf=pass smtp.mailfrom=seven.one; dkim=pass (2048-bit key) header.d=seven.one header.i=@seven.one header.b=HbrHBfeb; arc=fail smtp.client-ip=40.107.135.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=seven.one
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seven.one
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=seven.one header.i=@seven.one header.b="HbrHBfeb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BHDpGMM+fKKZGOWXrFc8NmTtJ/H4DJj37wH6H+xg+pW+Z2SAFHj/uYYidojINGI0KuGk/HMmlTCHrtL0+rzz2TlBWLo8mPH2rYD/AWJjaxJzbyZ64SlA5CCthCqBEqplg7tgh0cPJnh+ydJeXaFKY10ONJp4DXJLFT7zwKZjkKGFbQpXOpgwcU6oic2pwK9qOO+vmu3lAr09qcqw0yQ7+aJwkw2IjMH7YSENeA2Ddde3UtGOZ+qDuJxaG/iZ10AsTQdpYvm5JgFih0T2X98w2yqK+U0KFVLWS3YEQ9uTfN/PEqbqdU2ytnso0UHrE82YH6qGf4coA2wbnWOnWSSKLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rn8Z0KTmEGSkpqlma+NWwCFcn5sPPee8nOmNIXsb33Q=;
 b=W7AyTWjGCkTgUCUFPbSHoLQuhW8hnNw3FRNfjMIoJ3zvAgKy2Uh7ehKOyDi+bZMIumIMPLDBBkYR1x5DPdKI3DKVwRF6cJ9LGAwYGdM1sTwzabTHAp1VZF/L7ZcjTsYR9sYDqVT1ZRulXK1DC75planQNPTsro78ajPUP+dCka0yh6SUXos5VwWYoe3aT0KdLHXQjIeLUMpim1fz8Hamh3ZS7etB2M7ZSRMhprY97Wqec5ESUQS/+5gis6k15fDNWPP3khKU1Z+OGDYntSZIwVfbOegNVqjQa7Z4xT/h/wP9Y8jGWNotBbxjy+oHtri9FAHy1IONwy/eJuD7cSp2Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 81.93.117.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=seven.one;
 dmarc=none action=none header.from=seven.one; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seven.one;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rn8Z0KTmEGSkpqlma+NWwCFcn5sPPee8nOmNIXsb33Q=;
 b=HbrHBfebrqxsd0TZd/lAEjTZbKsMiyEB5jcGTvmniqBjqlVfRsbTlXPzX61ZEZHPWzukxxWvvn4D3aFTqrYUDwvYfBDLH35312SJXxLkQw9spfOta8bFevH2uHfHQhu2AKXZeGYu1iIIxcMwB7E1yNp7zEGg9rk2+7apR6NlagsbSaucrlJQcww1751NFG5INIoGQGnLoSu1OP3gUG2Omt3Prr4TzhABsuL1E1Q63lDSoHYtGYV+5wYN2lQmFk5/9qXSjtMae24N+KXGgFY9Y0UMn9NnZiPnmUFbLvQyl5mq0slZhiPJ6jzmV7bEwk0dxm72yj799dxK7KPNGcvV2Q==
Received: from AM5PR1001CA0057.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::34) by FR3P281MB3055.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:5a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.23; Wed, 17 Jan
 2024 13:25:43 +0000
Received: from AMS1EPF00000047.eurprd04.prod.outlook.com
 (2603:10a6:206:15:cafe::d7) by AM5PR1001CA0057.outlook.office365.com
 (2603:10a6:206:15::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.28 via Frontend
 Transport; Wed, 17 Jan 2024 13:25:43 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 81.93.117.34)
 smtp.mailfrom=seven.one; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seven.one;
Received-SPF: Fail (protection.outlook.com: domain of seven.one does not
 designate 81.93.117.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=81.93.117.34; helo=mail.p7s1.net;
Received: from mail.p7s1.net (81.93.117.34) by
 AMS1EPF00000047.mail.protection.outlook.com (10.167.16.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7202.16 via Frontend Transport; Wed, 17 Jan 2024 13:25:43 +0000
Received: from com-exc-vw2.belgium.fhm.de (172.21.12.42) by
 com-exc-vw2.belgium.fhm.de (172.21.12.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1118.40; Wed, 17 Jan 2024 14:25:40 +0100
Received: from smtpgwint1.fhm.de (172.21.12.31) by com-exc-vw2.belgium.fhm.de
 (172.21.12.42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1118.40 via Frontend
 Transport; Wed, 17 Jan 2024 14:25:40 +0100
Received: from app-degfx-vy1.fhm.de (app-degfx-vy1.fhm.de [172.22.145.38])
	by smtpgwint1.fhm.de (8.14.7/8.14.7) with ESMTP id 40HDPe4a028484;
	Wed, 17 Jan 2024 14:25:40 +0100
From: Florian Schwalm <Florian.Schwalm@seven.one>
To: <linux-cifs@vger.kernel.org>
CC: Florian Schwalm <Florian.Schwalm@seven.one>
Subject: [PATCH 1/1] cifs.upcall: enable ccache init from keytab for multiuser mount sessions
Date: Wed, 17 Jan 2024 14:25:34 +0100
Message-ID: <20240117132534.2623424-2-Florian.Schwalm@seven.one>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240117132534.2623424-1-Florian.Schwalm@seven.one>
References: <20240117132534.2623424-1-Florian.Schwalm@seven.one>
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
X-MS-TrafficTypeDiagnostic: AMS1EPF00000047:EE_|FR3P281MB3055:EE_
X-MS-Office365-Filtering-Correlation-Id: 7df86924-7d2c-40e4-0f3d-08dc175fce65
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	L5OzuyTCgA3b1LM7IuU2FDb78gx3AsbX8utTsOQsN0RO8QA7yOB5G6m5Dzt62EC+UEI38TXtpF3gffcSQd4TTo4xshk5JVw4JsbHe5QYEaFj37HWYU92nTUTqY6C9mS01prIWIIytTwSizCpd+9NWTJ5s2B4PCwChFYo8Z72hvCv3BtpU7WOgh8hhvbM/fVsSCChM7piEsGIqXmMGWwAGDgw3HFFgTHzo9inaCs+Xbzw3SFt/iKpjIpEFGYVK8XM3RL1HJp05GtWtV7Nk8yrsnuUv7XZDfUWqdKRpxry49ZCuqRVgk6ts9M5y+S3xK2woilq2f+wxsqYx8U6XVb4V5JpDPsTIyUwyUootVXlhCcRmntFSQ1bZZVrNPPkCMjPDvNyVMSIfyMZ4HXRNt6vZRGZLBhyjVgKzRFH5iIPqITxbGAplkyAlSjceUX8U49nMXrQMHGp6kj3L+bqVv1OVBUn8cBQuDcu65GD9P/I2X7D1SrxloRmVL5EVyzdmYoFyZsaD/Pv1YN2b3W5r2yPt1F/ikTPHETtRYrJaVqZ1bBV+OM6gg3NLaoHyeZa2+XBkEkotaeShsLIgVW9xXLgA2osamUzatpVDWd+c1REMUPyxE4Gw7SBDXBl1ofn/jDBJ9RhzBApTSiDrASLEDjyGNlJ2wdyaVqrUksAx4vD6KBc9BK6JxJ+QDwJzVGYMBhPwBlIaJwfYgykonX1Okslzp1zzi9Sr7JqhUW+vrc8PrqdJgmhIBonMzBNtffgVivRBbSpiETPkywEohuxtNpFIQ==
X-Forefront-Antispam-Report:
	CIP:81.93.117.34;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.p7s1.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(346002)(376002)(136003)(1800799012)(186009)(451199024)(82310400011)(64100799003)(36840700001)(46966006)(40470700004)(47076005)(1076003)(26005)(2616005)(336012)(107886003)(81166007)(356005)(36860700001)(41300700001)(82740400003)(8676002)(8936002)(6916009)(316002)(5660300002)(2906002)(70206006)(4326008)(70586007)(6666004)(478600001)(36756003)(86362001)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: seven.one
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2024 13:25:43.1516
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7df86924-7d2c-40e4-0f3d-08dc175fce65
X-MS-Exchange-CrossTenant-Id: 3825a6f3-24cb-47d4-8aa2-35d3e5891324
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3825a6f3-24cb-47d4-8aa2-35d3e5891324;Ip=[81.93.117.34];Helo=[mail.p7s1.net]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000047.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR3P281MB3055

Initializing the credentials cache from the provided keytab relies on
the username/principal to be known.
The kernel doesn't pass down a username for the individual user sessions
of a multiuser mount, though, we only get a uid.
This patch adds derival of a missing username based on the uid just as is
already done for the gid.
This way the keytab can also be used for initialization of user
sessions.

Signed-off-by: Florian Schwalm <Florian.Schwalm@seven.one>
---
 cifs.upcall.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 52c0328..492fcb6 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -1515,6 +1515,21 @@ int main(const int argc, char *const argv[])
 		goto out;
 	}
 
+	/*
+	 * The kernel doesn't pass down the username for individual sessions
+	 * of a multiuser mount, so we resort here to scraping one
+	 * out of the passwd nss db.
+	 */
+	if(arg->username[0] == '\0') {
+		if (strlen(pw->pw_name) > sizeof(arg->username)-1) {
+			syslog(LOG_ERR, "pw_name value too long for buffer");
+		} else {
+			memset(arg->username, 0, sizeof(arg->username));
+			strncpy(arg->username, pw->pw_name, strlen(pw->pw_name));
+			syslog(LOG_DEBUG, "Added username derived from uid:%s", arg->username);
+		}
+	}
+
 	ccache = get_existing_cc(env_cachename);
 	/* Couldn't find credcache? Try to use keytab */
 	if (ccache == NULL && arg->username[0] != '\0')
-- 
2.39.3

