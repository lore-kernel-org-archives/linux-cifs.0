Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013037.outbound.protection.outlook.com [52.101.72.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1975527453;
	Wed,  5 Aug 2026 00:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785888304; cv=fail; b=hg481YE5wJ04DxwEKrsfCv1fk5LVgqsLUpjt01gLLy6JppReDxSap6bh3zPFQK1WCizxLVwst0srB9tHEcgrCwx2wm2IyekXEe3vz82VOGAeDQzQYMd0bD7vmq2DNyVhLFc/M+NyekX8Yx3R3YY0WqoEgDwzdFlQ+MvT618BsB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785888304; c=relaxed/simple;
	bh=29Sp+AC5W4NSz5z0kBz1NxobIIJC2hpwou4wCI9Cavs=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=hs4vmHq828edISW6cGKm4AphvSSC+/RWLHKqn3AyB5PhWXCFYkw6tKqI+mdkFxuADTTa3eu3sFoQxhVJdHeh/LNevgE5EL6rBDoKQ+XtWk+KHdXripEKr+EghHOmWSTpwE/+cUchifDzfbqjtnzZHhu8KExkraEDPgLjmBcXByI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech; spf=pass smtp.mailfrom=est.tech; dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b=YDfC3mcL; arc=fail smtp.client-ip=52.101.72.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=est.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b="YDfC3mcL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z5E9W0+d784JRaAMAZl/4vqp/PWuOo6HK/kmZvr8kcW5BZDl1+9s7AuyB5YqFZvD9+3aljhhCptLi/dIK9ntnFLCEklw3EQZOWFOc+jNgQ67CMcMzaJqY2qGAPqmvty8KOYp5QRinRhahEcFVcNDlNd/EQtB4d9EQG0DO72pE71XtlPhA2V+BNY8EwBcD2HTRHe518SQJ7wf19IM+3Wm0XXqR86McFihzhm+qveEOHLBAsz1EgWe/+k8FZByqX194OC/59np430UKHpRBb1YtR1ZHTd7U8ELdoMyh+1Tm7upqjiKAHoQZ649jlZ22oDSz/irmw8ot8J6WHfyM3t/MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fELu33VuGmlYeOuiXuRp1B6j9jFg93tmlzG24gsqukU=;
 b=Xpq61dsLzkQtlSVlqQyRNDRaFPybx/6ct9fHtlDcxeVS4WoC7NTiinWxaihksl++ZKGgChgt8+Dq+Ea99gVKdMTpTzBJPXxLgWbxU3IsripoPGYzvt8twJRzwdLoWTMRJxAUHXcR2j7ykExcD/90XagUvKwn7NIpxX1w5MGC3sgGuzFQllBpeNDZl3QNdraXRTm2ezxb+q2Aiby9ckEwDzkEIvXdn87oRtQBVowvGVVV8brgt11etYWK78fjnAN+gRSji8YzPllxHZzubXNT5x8mgUZQ5dLjSY+rbfd0fGbj1FgsluVsrrtlrrUov+7Ca4Bv4Cg9JJnAOWK1+YRFtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fELu33VuGmlYeOuiXuRp1B6j9jFg93tmlzG24gsqukU=;
 b=YDfC3mcLe4PchUIzCv2iNpVo2gQXNdwUWDyfcs1Mx1lAoA8+fCmXtE0iY+2tXrhD2a2pG+0IjDJhBj/XNqG8ORLpQLyI7y1kg+TazoiR/keNVIslrrEXL5JkycD/j1Qw9mKA4kn4Ofg0W7X12V/We4zFN3Y2tGdhmyKJr7dMaxR3uONwWN2H2un+r60jclqYvhaWtDmMKIlsx82q3iaoRztt36KfUuOC/M/Keym3LolcpyYRb+OuiYRxjbeTTj4UXgluxl29P6vFkUiU8ruE8R6xxOR4iLHioA5jeIgQGrSdwrX2fJYOj4G0Lt+ySIf3G1xhRNdq6UBucQmQaEpioA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by DU0P189MB2140.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:3b4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.16; Wed, 5 Aug
 2026 00:04:57 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%6]) with mapi id 15.21.0292.015; Wed, 5 Aug 2026
 00:04:57 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Jacob Moroni <jmoroni@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Cc: Stefan Metzmacher <metze@samba.org>,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	Yunseong Kim <yunseong.kim@ericsson.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Yunseong Kim <yunseong.kim@est.tech>
Subject: [RFC PATCH] RDMA/iwcm: allow aborting an active connect awaiting CONNECT_REPLY
Date: Wed,  5 Aug 2026 02:02:00 +0200
Message-ID: <20260805000159.321645-2-yunseong.kim@est.tech>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV2PEPF000239C8.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:400::1a9) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|DU0P189MB2140:EE_
X-MS-Office365-Filtering-Correlation-Id: 925e1703-3105-40a6-79bc-08def2852f5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|7416014|23010399003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	SNajOqAOJoGkChp/VOh8uZwaKxrLb5i/9rn94NxAzh+8FU6EpBm5vq2V2tiR+xgGU6PAONLw88jU9wx0UF8ieWvpWLkbh1akL6b2ree2X0VrukR7lWERkyOHX/lxLhuD8UjJUehxlTbc6gJweK2pi37ueu5RToFLXrXtB+2iHPFTCbSEC1hr4s0pOUDtzK3Z3actXfqApaB0DJhSlaiwIJ8Z5Oq/T2pr/3y1aqWdud9fpdrk6uKxH5rlzGtzXRHV1P8Hyar+hAqysDfpv6I9ShMRRbJ4Pc5yjE+Cv1vekAz9+DFL85r5tsZePx9nu4gQShyL6KSuxlGfTRXf1OXW2VPa3R7iLk29/MS7CFTYZR1OmsHFC1epq+b+kBb/2dA3S5m6JsNn7WIutwaJ7Q+zaDcJEexnq0AccO05fCQ2Dn++B5eiYqiohwye34sGW9ZQdgHRSHFioxyCIRuzfhxQK/ZLj1x72dfjI8WC2yHQZCpPZNKpjt6jQYA3Kg++3e+YhHE9p3Mp+oeltOjzHn+O85DqRKC3c2cyusez+c6e+BASsIiw9ACNBeE6XjVbFJP7cfc4X/eGL74vYrM3W8j/Z4dTJap8ZV66Q4072rl0fNKq75+IZau4boE4LuUC1Xf0nhQYTeD8P5wDTYU0GI7hs9QA7ONdV5Tpx8rCq3ZmGdI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(7416014)(23010399003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AprqRHpdK6vfovEgPDB+0B03PAzAVAeC8+t+AMbiL0OS4B+MdKdG0PfH/NYs?=
 =?us-ascii?Q?49Hb2UOeBoQ54KVAsCAi3jWR116m+yDc7l8y63iTKBc5EGJW5fgn79v5aZfn?=
 =?us-ascii?Q?fKW2xg4YUJZm3vwwHcqzlWunV2LXRim0RgwwouAXNCkBzMxwkDeHqqZd3k1V?=
 =?us-ascii?Q?YeugfLry0c3ILLLCvJtAlEKskZp8jaEatRBFQwD1JTn6uWY8d4Z6UCCH4URO?=
 =?us-ascii?Q?PsY5Qacy6j8+6/Cf96hAyHls0poKA3Qmxo+ILg0wwaH777y6avpc8hRu2Uw5?=
 =?us-ascii?Q?6hBQ5pUGvSWiGqzpbckmVX1tqnyBEvMHAYNumpg1ROhFC8ES9s1d1yL0YRYB?=
 =?us-ascii?Q?k+HCLRqWQHRQV7GjuvFgke4PUOJ8Y2H7uhj6GQ9C1pH3EaqhZjuh5tTWKA9/?=
 =?us-ascii?Q?neiXr/7lHGKBZD5xGLEriPKlg6wUHUta/VuRVgAQIZsw67/3jvSOWf/rzvD1?=
 =?us-ascii?Q?XGotkz5BA+uZMLwttWuHZyHV0lI9T1yeaoWUPCIaE+/gxS0NT9ZQlZ9d2d1C?=
 =?us-ascii?Q?2hbbOFkNePKXPYi36utDYHDUmg3m5ioj36ve0VtFEScICtX7gaT4sisjIFOZ?=
 =?us-ascii?Q?QlBsoGvOzNNQRhWyiDMQB9jCbjGFYEm6bwsei7T7s4kuruS0BdeRw4ES0KIf?=
 =?us-ascii?Q?xQXyYgYALtK7p/wPbvtYjINmmsvZHykAnAQjiJCdKRBHRdRu11Vp4tSJmjqB?=
 =?us-ascii?Q?ud02u3yR0VMeWiSqcQFO6vopFYjXzMJUWlhgcKxDd7p8LHLLPdS/Lw3Wk7PF?=
 =?us-ascii?Q?qvBXKktJE4M67KpINSQihOEFskL2ldNVFzg6SZB4PUSmCfTdfzxunrweGpQL?=
 =?us-ascii?Q?1TtqdJBaNY93g1MXTjbc4upEB+TpAU31j6caJ1wdWsnOrJ5qjg0Xny9Gwe9W?=
 =?us-ascii?Q?+XsPBbtHKF6XZlYWjiw9NvavrZx/4YuQ5Lx/ABcd9JHBtZ5Qm2ZDTHn7WG9v?=
 =?us-ascii?Q?/6rxNp5PtUxiTFDelvxXypU6uO2cg19eg1zKexHhEN1A2l2OTXivjuEZbFXm?=
 =?us-ascii?Q?ULnmTnzJfqjg/KV+m8tD9Zq6KP96nKAua9+eyn4f/pBzskd6W6UzJoBVRN40?=
 =?us-ascii?Q?+C0kaZmn073TQiWBz1Ha5ZyzRE9TIfp217FmyOKs/nch3tMcjxfnmKZT5dEq?=
 =?us-ascii?Q?Oj96c4xr5INyuq2qBxB+T3yPkQgx50VedFh6zighLn8Idhs753CvXRwsrkuu?=
 =?us-ascii?Q?Srh8BnUvLtn2HylKL2eJImEDtxhVDu8B4cCbg8NBP2kWO1UVJP1UNgE6uFEF?=
 =?us-ascii?Q?sQyFp/TWgLjnEbQMl8cLlWtfxYSOv5vKeidOtipvvvkQzzJmaFA+L/DWToig?=
 =?us-ascii?Q?J/P/su7iuPyqkgc/wmZUVnpTV3vVoaBC1uePvyhdzVUNIwwBPNpaluwEkf0n?=
 =?us-ascii?Q?tKpLYXEI6ABkAJR4NpQpTI6/7ys6EDZKbnCsUupFB2Gu0Im2BTlp9r9V1Tu6?=
 =?us-ascii?Q?jMY5VidvXPOvj1bKe9qMVdRKKLRdQtckiiJspG9RSMXuXvLZhYKj/uNtwfQ5?=
 =?us-ascii?Q?two8ShoRR8zMN6mI0wzO2J/yDe6dqfMH8i0VofFHazP84IN2n5vRTT1ZybrD?=
 =?us-ascii?Q?5QSBUEfj9SIB8lRqETkdXoq6lPA3NNU62KRS4n06aKyK2erMb8SLarRtZW1h?=
 =?us-ascii?Q?CpXQmHfoXLlhwnLz1YS0ZOKbiEnDP5QvZE2pqc1GSXmAKNd5NNlY2U7Wd9DJ?=
 =?us-ascii?Q?suDvH0YBMkxN98m6yhnZMz1dr4j610OFZi2cl+ijAnj7By5j62kvzbhWqbVz?=
 =?us-ascii?Q?xRzqMDNDeS5ZR7G5u/n95rA5UoHxDM4XkLYr42CXwRW7uvyQ9yITeQNUXfii?=
X-MS-Exchange-AntiSpam-MessageData-1: 6wsBgZc2SfRr4w==
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 925e1703-3105-40a6-79bc-08def2852f5e
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 00:04:57.3949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qkLEatf3Hi59XelxvS/KWYfhxKV6vU/hvAHfNfJZNiUsPWPH/sslp5Tag/KrwiPRJMepGgVEgCdxo4nbetQR8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0P189MB2140

After a successful connect downcall, iw_cm_connect() returns with
IWCM_F_CONNECT_WAIT still set and the cm_id in IW_CM_STATE_CONN_SENT.
The only thing that clears the flag is the provider delivering
IW_CM_EVENT_CONNECT_REPLY (cm_conn_rep_handler()).  Until that event
arrives, iw_cm_disconnect() and destroy_cm_id() sleep uninterruptibly
in

	wait_event(cm_id_priv->connect_wait,
		   !test_bit(IWCM_F_CONNECT_WAIT, &cm_id_priv->flags));

and both state machines treat IW_CM_STATE_CONN_SENT as BUG(), so the
API has no way to cancel a pending active connect.  If the provider
never generates the reply, because the peer died in the middle of
connection setup or because of a provider bug, every teardown path
(rdma_disconnect(), rdma_destroy_id()) blocks in D state forever and
the ULP cannot recover: there is no way to disconnect after
rdma_connect() was called without risking an unbounded hang.

This class of problem is not theoretical.  The pending smbdirect
change "smb: smbdirect: bound the disconnect wait in destroy_sync" [1]
had to work around it on the ULP side:
smbdirect_socket_destroy_sync() waited unbounded for the socket to
reach SMBDIRECT_SOCKET_DISCONNECTED, a transition that depends on an
asynchronous RDMA CM disconnect event, and when the peer died abruptly
(a killed client, or Soft-RoCE/RXE where no graceful disconnect
completes) that event never arrived.  The destroy ran on the single
ksmbd-conn-release workqueue, every later connection release queued
behind it in D state, and the whole server wedged until hung_task
fired.  That change bounded the wait and drove the socket state
machine to DISCONNECTED locally on timeout; ULPs should not have to
resort to that, the CM should offer a teardown they can rely on.

IWCM_F_CONNECT_WAIT currently guards two different windows:

 * the connect/accept downcall into the provider being in progress;
   teardown must keep waiting for that, it is short and bounded;

 * an issued active connect waiting for CONNECT_REPLY, which is
   potentially unbounded.

Mark the second window with a new flag, IWCM_F_CONNECT_SENT: set by
iw_cm_connect() once the downcall has returned successfully, cleared
by cm_conn_rep_handler().  The teardown waits now complete when either
the downcall has finished (!IWCM_F_CONNECT_WAIT, as before) or the
pending-reply window has been entered (IWCM_F_CONNECT_SENT), and the
previously BUG() CONN_SENT cases become:

 * iw_cm_disconnect(): return -ENOTCONN; there is no established
   connection to disconnect, aborting is the destroy path's job;

 * destroy_cm_id(): abort the pending connect locally by moving to
   DESTROYING and putting the QP into error so the provider tears the
   connection attempt down.

A CONNECT_REPLY that arrives after the abort is dropped: either
cm_work_handler() sees IWCM_F_DROP_EVENTS, or cm_conn_rep_handler()
now recognizes IW_CM_STATE_DESTROYING (the abort and the reply
serialize on cm_id_priv->lock) and frees the event without touching
the QP that destroy_cm_id() already released.  The cm_id memory stays
valid for such a late reply because the provider holds its own
reference (cm_id->add_ref) for as long as it can deliver events.

The passive side has a sibling gap, where after a successful accept
downcall the flag stays set until the provider's ESTABLISHED event
arrives, which this patch deliberately does not change.

[1] https://github.com/smfrench/smb3-kernel/commit/26d0f82a02c8a9c9c8cdfc138acb7ed0bf8e01a9

Suggested-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 drivers/infiniband/core/iwcm.c | 76 +++++++++++++++++++++++++++++-----
 drivers/infiniband/core/iwcm.h |  1 +
 2 files changed, 67 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 0b7246ec559e..4fb36ac92cc5 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -308,9 +308,18 @@ int iw_cm_disconnect(struct iw_cm_id *cm_id, int abrupt)
 	struct ib_qp *qp = NULL;
 
 	cm_id_priv = container_of(cm_id, struct iwcm_id_private, id);
-	/* Wait if we're currently in a connect or accept downcall */
+	/*
+	 * Wait if we're currently in a connect or accept downcall.  A
+	 * pending active connect whose downcall already returned
+	 * (IWCM_F_CONNECT_SENT) is not waited for: the CONNECT_REPLY that
+	 * would end such a wait comes from the provider and may never
+	 * arrive if the peer died during connection setup, so the
+	 * CONN_SENT state is handled below instead of sleeping without
+	 * bound here.
+	 */
 	wait_event(cm_id_priv->connect_wait,
-		   !test_bit(IWCM_F_CONNECT_WAIT, &cm_id_priv->flags));
+		   !test_bit(IWCM_F_CONNECT_WAIT, &cm_id_priv->flags) ||
+		   test_bit(IWCM_F_CONNECT_SENT, &cm_id_priv->flags));
 
 	spin_lock_irqsave(&cm_id_priv->lock, flags);
 	switch (cm_id_priv->state) {
@@ -338,7 +347,14 @@ int iw_cm_disconnect(struct iw_cm_id *cm_id, int abrupt)
 		 */
 		break;
 	case IW_CM_STATE_CONN_SENT:
-		/* Can only get here if wait above fails */
+		/*
+		 * Active connect still waiting for the provider's
+		 * CONNECT_REPLY: there is no established connection to
+		 * disconnect.  Tell the caller; aborting the pending
+		 * connect is iw_destroy_cm_id()'s job.
+		 */
+		ret = -ENOTCONN;
+		break;
 	default:
 		BUG();
 	}
@@ -375,10 +391,15 @@ static void destroy_cm_id(struct iw_cm_id *cm_id)
 	cm_id_priv = container_of(cm_id, struct iwcm_id_private, id);
 	/*
 	 * Wait if we're currently in a connect or accept downcall. A
-	 * listening endpoint should never block here.
+	 * listening endpoint should never block here.  A pending active
+	 * connect whose downcall already returned (IWCM_F_CONNECT_SENT)
+	 * is not waited for, since its CONNECT_REPLY may never arrive if
+	 * the peer died during connection setup; it is aborted locally
+	 * in the CONN_SENT case below.
 	 */
 	wait_event(cm_id_priv->connect_wait,
-		   !test_bit(IWCM_F_CONNECT_WAIT, &cm_id_priv->flags));
+		   !test_bit(IWCM_F_CONNECT_WAIT, &cm_id_priv->flags) ||
+		   test_bit(IWCM_F_CONNECT_SENT, &cm_id_priv->flags));
 
 	/*
 	 * Since we're deleting the cm_id, drop any events that
@@ -422,6 +443,21 @@ static void destroy_cm_id(struct iw_cm_id *cm_id)
 		spin_lock_irqsave(&cm_id_priv->lock, flags);
 		break;
 	case IW_CM_STATE_CONN_SENT:
+		/*
+		 * Abort a pending active connect: the connect downcall has
+		 * returned (IWCM_F_CONNECT_SENT) but the provider has not
+		 * delivered CONNECT_REPLY.  Move the QP to error so the
+		 * provider tears the connection attempt down.  A late
+		 * CONNECT_REPLY is dropped via IWCM_F_DROP_EVENTS or the
+		 * DESTROYING check in cm_conn_rep_handler(), and the
+		 * provider's own reference (cm_id->add_ref) keeps this
+		 * cm_id alive until that reply has been delivered.
+		 */
+		cm_id_priv->state = IW_CM_STATE_DESTROYING;
+		spin_unlock_irqrestore(&cm_id_priv->lock, flags);
+		(void)iwcm_modify_qp_err(qp);
+		spin_lock_irqsave(&cm_id_priv->lock, flags);
+		break;
 	case IW_CM_STATE_DESTROYING:
 	default:
 		BUG();
@@ -689,9 +725,11 @@ EXPORT_SYMBOL(iw_cm_accept);
 /*
  * Active Side: CM_ID <-- CONN_SENT
  *
- * If successful, results in the generation of a CONNECT_REPLY
- * event. iw_cm_disconnect and iw_cm_destroy will block until the
- * CONNECT_REPLY event is received from the provider.
+ * If successful, results in the generation of a CONNECT_REPLY event.
+ * IWCM_F_CONNECT_SENT marks the window between the connect downcall
+ * returning and that CONNECT_REPLY arriving; during it
+ * iw_cm_disconnect() returns -ENOTCONN and iw_destroy_cm_id() aborts
+ * the pending connect locally instead of blocking on the provider.
  */
 int iw_cm_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *iw_param)
 {
@@ -728,8 +766,16 @@ int iw_cm_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *iw_param)
 	ret = iw_cm_map(cm_id, true);
 	if (!ret)
 		ret = cm_id->device->ops.iw_connect(cm_id, iw_param);
-	if (!ret)
+	if (!ret) {
+		/*
+		 * The downcall is done; only the provider's CONNECT_REPLY
+		 * is outstanding.  Let teardown waiters proceed so they
+		 * can abort instead of depending on that reply.
+		 */
+		set_bit(IWCM_F_CONNECT_SENT, &cm_id_priv->flags);
+		wake_up_all(&cm_id_priv->connect_wait);
 		return 0;	/* success */
+	}
 
 	spin_lock_irqsave(&cm_id_priv->lock, flags);
 	qp = cm_id_priv->qp;
@@ -882,7 +928,7 @@ static int cm_conn_rep_handler(struct iwcm_id_private *cm_id_priv,
 {
 	struct ib_qp *qp = NULL;
 	unsigned long flags;
-	int ret;
+	int ret = 0;
 
 	spin_lock_irqsave(&cm_id_priv->lock, flags);
 	/*
@@ -890,6 +936,15 @@ static int cm_conn_rep_handler(struct iwcm_id_private *cm_id_priv,
 	 * iw_cm_disconnect will not wait and deadlock this thread
 	 */
 	clear_bit(IWCM_F_CONNECT_WAIT, &cm_id_priv->flags);
+	clear_bit(IWCM_F_CONNECT_SENT, &cm_id_priv->flags);
+	if (cm_id_priv->state == IW_CM_STATE_DESTROYING) {
+		/*
+		 * destroy_cm_id() aborted the pending connect and already
+		 * released the QP; drop the late reply.
+		 */
+		spin_unlock_irqrestore(&cm_id_priv->lock, flags);
+		goto out;
+	}
 	BUG_ON(cm_id_priv->state != IW_CM_STATE_CONN_SENT);
 	if (iw_event->status == 0) {
 		cm_id_priv->id.m_local_addr = iw_event->local_addr;
@@ -908,6 +963,7 @@ static int cm_conn_rep_handler(struct iwcm_id_private *cm_id_priv,
 		cm_id_priv->id.device->ops.iw_rem_ref(qp);
 	ret = cm_id_priv->id.cm_handler(&cm_id_priv->id, iw_event);
 
+out:
 	if (iw_event->private_data_len)
 		kfree(iw_event->private_data);
 
diff --git a/drivers/infiniband/core/iwcm.h b/drivers/infiniband/core/iwcm.h
index b56fb12edece..74ce33616863 100644
--- a/drivers/infiniband/core/iwcm.h
+++ b/drivers/infiniband/core/iwcm.h
@@ -57,5 +57,6 @@ struct iwcm_id_private {
 
 #define IWCM_F_DROP_EVENTS	  1
 #define IWCM_F_CONNECT_WAIT       2
+#define IWCM_F_CONNECT_SENT       3
 
 #endif /* IWCM_H */
-- 
2.43.0

