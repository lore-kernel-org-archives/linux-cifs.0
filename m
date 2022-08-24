Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 559A4C32796
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Aug 2022 15:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239569AbiHXP1T (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Aug 2022 11:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239554AbiHXP1R (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Aug 2022 11:27:17 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3129A687
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 08:27:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4lMchKPt7hh8e8HTsHU86ZftDg0Sbi9tWQayNUWKPkUAJb5O/xEP/zzuwfYw8OQEFxD6+Q07p0QNIECcZK79V3V8PNEvwnW6i+EwVbLhG/Gb1Cq8NSo4mKIFd9FvcOcmSxebQgf8LPHJDk8nIQNv+gciw4OWbzDNxrFD90sE3zxg5SiOJppRctVLOQMsnuyAGFUwl/mEjk57DwtrRpHoEiL/Xgb0WyOYrJkdUfTfhk6+6lCtLfzZuZmIK7mz/agnab6Yj3oo1SwQ1YhxiyW89jjaDESGoANRydWRKjE9GilNUzRzqOSM5vKzxP7+nVHF0F7GyGLJVu1N9fojDda+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ge6SxbFXf9kUsplqWlOAjhpLZDEalqoOTfXiiYib2w=;
 b=TpjkOcTFCFo58n1Sw7+objvB+Dmop6m9l1ThRRrhdAxeAmv+TWXvkZtM2QONlXIfP0cE3aWS1IqFFX8s1WfNiyFisW49sMP3mH1hrh/cqsimu08dlc4W5gI3Y50pRPrh13MlWKsqsFuaJZQQlYqiXITXN/9h9/Lmtr0jpU36fL4xSMLZq86SRAeS7OvQEwy1yvDy2RbAHErG2jcUfY414q/v+ylBrqKmH5nZ01H0D+tKxZSTS9vn8rZR5na9RzgIt8cbkL+Op6dLUo7NiJNHG+9Uh5jSi+2/BoHA/rPwSHoYdZiuE8B/f1umUCn4qaVBdbTx8WDAbeTWSyvSIvcmQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB5318.prod.exchangelabs.com (2603:10b6:a03:11e::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.18; Wed, 24 Aug 2022 15:27:11 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5546.019; Wed, 24 Aug 2022
 15:27:10 +0000
Message-ID: <6f6a2e87-4764-114b-2780-184c845a84c2@talpey.com>
Date:   Wed, 24 Aug 2022 11:27:08 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
Subject: [RFC PATCH] Reduce smbdirect send/receive SGE sizes
To:     Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:208:23b::15) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e790537-f929-4c33-b2d1-08da85e51d0f
X-MS-TrafficTypeDiagnostic: BYAPR01MB5318:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /j7GOQ0oBu7YCM2LflG/m83eDbVfjfTAq+FrCNaFwMplQpFBicBrIb6LnY8Zej4eEpiuo98cfW1cMZygzVJdazJcAzDhrT6Am/tKqGfnerzNraeJxxOT1eoyM4GsIL0YB4aYRZBiO5slYyi3jW2L79k/9D3ehMZaFJMWbBIxKrhvxIRrcPyuxtiA/+jhvG31cVxdye6rNMSFSPrf/Mdpx8NkmzAHKYp0nRA4jAVQUtVTxKLwQq4RKQTwLJ3tYPGbdQciJfwIDEf06vU2DKiPnLyO1ZwhlooqOxz2XcTgcHPOSyeHDt3KBojsdb7ZgCu+mfugKpVTJdtwcAsOoHidG2UzMYhS5QJUski6K6FaIU/BjqDNfDy7LFtFMGx5K3iQ1BWTEn4ICYVkKHsp56V5uXg+uE8h6S3ZjI4Js23gHoQJnqYnE3zMsqo6zRvtMiJ1LypxvtVEOU7Ml1LBNwX3mHQJKqxfZ8TCTFzKv0w8K4rGADiccwBtj9oBy/YWo56N8NIiSCRY1QXtEangh6nKuddpAi2o38kkCYr+u9vPHrpzcX/5QLMNjcz3+g4BYp+ZDBjMhTJxFONTUTdaI1Ej+yzZXrUbHVOOgG2jLaonA/on7sTEZLCY/0pxveI5rJS9sNE6r940rOY8rUXt6OUKx8/3Vh3bZfVUncT23aF/4Ow/yPGPyXqas1Nd9eudZvlaTlB5gsRqIWPhwZMLwLOiONfHAFfxptaaXD8CTovmpwS7fut5utD3TQ6X/LnINI3WkAlc7rzw5j0/Te0lQY595G0xYvpFFXdfrmcWv0J/vvU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39830400003)(366004)(376002)(346002)(136003)(5660300002)(6506007)(41300700001)(6486002)(83380400001)(52116002)(8936002)(186003)(26005)(6512007)(478600001)(2616005)(316002)(2906002)(38100700002)(110136005)(66946007)(8676002)(66476007)(66556008)(38350700002)(31686004)(31696002)(86362001)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S21rQ2NPUmhFVEM5VTYyT1poSHVlOTBKVGpialZrTTNkdFd2U1N4Rjd4OGt1?=
 =?utf-8?B?RURhL283SWRZVnRpcjh3djFVejdvREtQeXI5T25XZWZCOGt2emN1Z3dRekZP?=
 =?utf-8?B?ZTJKdTdwdXVxMjRGV0ZPUEJtbmJIQ0FDM1NETllJMTlBM0VGNDQ4dDlWMEJV?=
 =?utf-8?B?VG1OQkpqTWI3emVkb2pnMmRCRjlEUC9xSjh4cWpkTE03b3pmUlFlRW9TTlA5?=
 =?utf-8?B?SGtCZDROYWR6YXRzWUNiR0tLWG00MVdqVVdSejlZeXE4UVR2TTlQRkVJQWpE?=
 =?utf-8?B?cklIcFhaN3l4K0l5MHdPbCtsNHBOc1hiZG9jUUlFZlN5ZnNYb1Z0REoxclV5?=
 =?utf-8?B?WWd5NFZzUkxUdXlwWVhQUVFydkpTZHRvUmZWU1BJRFBNWkhzMUl6UUNEZnFa?=
 =?utf-8?B?VE92My9YQWdhSXBlZ0wxcVAxeTdUNE1IcTRqZGhObjNQRFpHK1lJcGdlWUxC?=
 =?utf-8?B?R1YvR25qenluT0MyVXJpYitRcU80YnZJamVVd1ZIUW9hV0JJS3pqNUxTUGxK?=
 =?utf-8?B?TFBHeDNLdW4ycjNBM21RQkhlUHM2dFV1aERrS00rakpRTFZuY3U2Q2lXUlNM?=
 =?utf-8?B?TFJST2VkdDJkQ1VwbjJvcnBxeTJRSmcweE00TkhiVWFWSzd1aExvUGhJRDFa?=
 =?utf-8?B?OC9zMHZZUmlZbDJ4TXM3bFV4UmZkUUduY1BSNTZiWmJ0NjdkdFNiYytkK2Er?=
 =?utf-8?B?QlgwV3pMUHBlb2E5aUxQaGQwZnJXd2p1QnJHYjN4SnVndUtDQ1ZmL2dMUEZp?=
 =?utf-8?B?S2ZCaHQ1V1lQL3lDdU84Q2Z3TGREOWhPQmdsV3hpS3hvdS9mdmJwTEtURGNX?=
 =?utf-8?B?dWlVRVhuRE5nQ3Jzb1ZCQ3VhSUkyaWRyNElzWXBnZ2w4djF2VlNSemgza0Jw?=
 =?utf-8?B?Nm5sUEJmdVkrQURGbkxTMElBaXR2RURjVWJsTlFNQlZxMk9tMGJZbDJzWm5s?=
 =?utf-8?B?bnlESldjeElhcGdmSk4wTVZGTm92bzNiak9sMXdpanBycU9JNmVzT1c5MjQr?=
 =?utf-8?B?SzU4aTBqeGZSYTBBdHZiMWNCVTZIR1BVV3E3T2RVVkZvcHhBV29YTGlVYSs3?=
 =?utf-8?B?ZWQ1ekMyME5PcEVTTVdTa0FhSnBSS1BvK2NWcUVKbW9JK0pYWG9maEVmaDAr?=
 =?utf-8?B?YVRRa3FRK25BMW84VzBjeHFsdDFEcnlyVWwralNMZFBwZlVFS0VGSXgvaHNM?=
 =?utf-8?B?OE1OczdDYXg4U3Z0aTk5UnhWa2pYVysyL2dOY2NCMHlvQjMyNXhhQXR0SE04?=
 =?utf-8?B?a2QwZ1lvTWY1NXZuY05yZWNpS2wyNEE3bUlFVk9pOXdxbDdoVmp6YVUwQS80?=
 =?utf-8?B?NXM0QnkyTk9ELzNXUVFVQmpJREF6YlhnY0pKeUtmTkZFMm9qQ3RibHZaMlM0?=
 =?utf-8?B?a0g1c2l6cUhQL2hOc2J4K3BBQkZqcFNUWXpkeDJYMlhEeUxOQlc2cUdYS1JZ?=
 =?utf-8?B?aVBraEN2aVVIK01LTkNNM0lkVDUyNEhNM3lteE8xbXVhZVN1Y24rUllkMVlI?=
 =?utf-8?B?NnZjU29RYlV4eU92YnhKSmNHSUlFaDdIU0szRkEzMXVxcFlKdGlEMXA0cUVu?=
 =?utf-8?B?RHhRK21OVWdpSDY2T1ZVTlpTOWNXR0Z2bXFEbG1DZjdMa2FuVmpKWWgyaXJE?=
 =?utf-8?B?U0E2V2JBTHR4MENiMUpMb1Job1JVV1ZseEVBRi9DY1pnci9JeFgrRzgzSnA3?=
 =?utf-8?B?YnJ3S1NRNXhzRkJ6bzRXbkJrTTh2bDFha3ZIYWRXQmpDTkM4d1V3MkRNOTVt?=
 =?utf-8?B?bGxaUDJjRzhPRFlQcFRXNitDK3E1TUxPNEdqeEJaMXk3STZVd3dQUXJDT1Bm?=
 =?utf-8?B?WWZxMHd6OHNENi9YV2Vtc0IvdU1UVDJwd1V1Vjh5UXlvSmF4ZTNjTWxQWW9l?=
 =?utf-8?B?cWpoY1ZsR3lTbFVXeEZ3WnZGRlBYNlJxZHhZeFplejZVSDVReGtuR3hBMHVy?=
 =?utf-8?B?SlREam9MYTNoTDRwNFUwMmFVSkYrQkNtY1ZVakh3a1h3YzRSRUJwNW0wcmpw?=
 =?utf-8?B?SHpJcnN0cUV0SXNNVkNoVThGRHpGS3lFY3Z6UkhWVFBNQ2tlVUtGMUlzbUFi?=
 =?utf-8?B?aWovbFJwYmdwY0pNcmdSam1wUTRLOFN1ejA2NGkvelpGQUl4UDlVTktBQnpF?=
 =?utf-8?Q?ijCI=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e790537-f929-4c33-b2d1-08da85e51d0f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 15:27:10.9325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B0k/NDbaO8lYQGqdaLaN8zBfd0wy2/G2iYfvlYh8m8uIqI3cBLuqkqgR1x+cAXMG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB5318
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reduce the number of SGEs requested by the smbdirect layer.
Previously 16 for both send and receive, these values were
unnecessarily high, and failed on the siw provider.

Also reword the fast-register page array maximum size, which
incorrectly stated it was related to SGE. Consider reducing
this (very) large value later.

This patch is UNTESTED and RFC at this time. 5 send SGEs and
1 receive SGE are expected to succeed with no loss of function.
It should fix operation on softiWARP, and improve efficiency on
all providers.

I don't have sufficient RDMA hardware or workload infrastructure.
Can anyone help test?

Signed-off-by: Tom Talpey <tom@talpey.com>

  fs/cifs/smbdirect.c | 24 ++++++++++--------------
  fs/cifs/smbdirect.h | 14 +++++++++-----
  2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 5fbbec22bcc8..d96d420a1589 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -99,7 +99,7 @@ int smbd_keep_alive_interval = 120;
   * User configurable initial values for RDMA transport
   * The actual values used may be lower and are limited to hardware 
capabilities
   */
-/* Default maximum number of SGEs in a RDMA write/read */
+/* Default maximum number of pages in a single RDMA write/read */
  int smbd_max_frmr_depth = 2048;

  /* If payload is less than this byte, use RDMA send/recv not read/write */
@@ -1017,9 +1017,9 @@ static int smbd_post_send_data(
  {
  	int i;
  	u32 data_length = 0;
-	struct scatterlist sgl[SMBDIRECT_MAX_SGE];
+	struct scatterlist sgl[SMBDIRECT_MAX_SEND_SGE];

-	if (n_vec > SMBDIRECT_MAX_SGE) {
+	if (n_vec > SMBDIRECT_MAX_SEND_SGE) {
  		cifs_dbg(VFS, "Can't fit data to SGL, n_vec=%d\n", n_vec);
  		return -EINVAL;
  	}
@@ -1562,17 +1562,13 @@ static struct smbd_connection *_smbd_get_connection(
  	info->max_receive_size = smbd_max_receive_size;
  	info->keep_alive_interval = smbd_keep_alive_interval;

-	if (info->id->device->attrs.max_send_sge < SMBDIRECT_MAX_SGE) {
+	if (info->id->device->attrs.max_send_sge < SMBDIRECT_MAX_SEND_SGE ||
+	    info->id->device->attrs.max_recv_sge < SMBDIRECT_MAX_RECV_SGE) {
  		log_rdma_event(ERR,
-			"warning: device max_send_sge = %d too small\n",
-			info->id->device->attrs.max_send_sge);
-		log_rdma_event(ERR, "Queue Pair creation may fail\n");
-	}
-	if (info->id->device->attrs.max_recv_sge < SMBDIRECT_MAX_SGE) {
-		log_rdma_event(ERR,
-			"warning: device max_recv_sge = %d too small\n",
+			"device max_send_sge/max_recv_sge = %d/%d too small\n",
+			info->id->device->attrs.max_send_sge,
  			info->id->device->attrs.max_recv_sge);
-		log_rdma_event(ERR, "Queue Pair creation may fail\n");
+		goto config_failed;
  	}

  	info->send_cq = NULL;
@@ -1598,8 +1594,8 @@ static struct smbd_connection *_smbd_get_connection(
  	qp_attr.qp_context = info;
  	qp_attr.cap.max_send_wr = info->send_credit_target;
  	qp_attr.cap.max_recv_wr = info->receive_credit_max;
-	qp_attr.cap.max_send_sge = SMBDIRECT_MAX_SGE;
-	qp_attr.cap.max_recv_sge = SMBDIRECT_MAX_SGE;
+	qp_attr.cap.max_send_sge = SMBDIRECT_MAX_SEND_SGE;
+	qp_attr.cap.max_recv_sge = SMBDIRECT_MAX_RECV_SGE;
  	qp_attr.cap.max_inline_data = 0;
  	qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
  	qp_attr.qp_type = IB_QPT_RC;
diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
index a87fca82a796..2a9b2b12d6aa 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -91,7 +91,7 @@ struct smbd_connection {
  	/* Memory registrations */
  	/* Maximum number of RDMA read/write outstanding on this connection */
  	int responder_resources;
-	/* Maximum number of SGEs in a RDMA write/read */
+	/* Maximum number of pages in a single RDMA write/read on this 
connection */
  	int max_frmr_depth;
  	/*
  	 * If payload is less than or equal to the threshold,
@@ -225,21 +225,25 @@ struct smbd_buffer_descriptor_v1 {
  	__le32 length;
  } __packed;

-/* Default maximum number of SGEs in a RDMA send/recv */
-#define SMBDIRECT_MAX_SGE	16
+/* Maximum number of SGEs needed by smbdirect.c in a send work request */
+#define SMBDIRECT_MAX_SEND_SGE	5
+
  /* The context for a SMBD request */
  struct smbd_request {
  	struct smbd_connection *info;
  	struct ib_cqe cqe;

-	/* the SGE entries for this packet */
-	struct ib_sge sge[SMBDIRECT_MAX_SGE];
+	/* the SGE entries for this work request */
+	struct ib_sge sge[SMBDIRECT_MAX_SEND_SGE];
  	int num_sge;

  	/* SMBD packet header follows this structure */
  	u8 packet[];
  };

+/* Maximum number of SGEs needed by smbdirect.c in a receive work 
request */
+#define SMBDIRECT_MAX_RECV_SGE	1
+
  /* The context for a SMBD response */
  struct smbd_response {
  	struct smbd_connection *info;
