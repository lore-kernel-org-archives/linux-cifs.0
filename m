Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4824DC433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 04:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 235FC60EB9
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 04:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhKDFAg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Nov 2021 01:00:36 -0400
Received: from mail-eopbgr1310101.outbound.protection.outlook.com ([40.107.131.101]:3552
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230119AbhKDFAf (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 4 Nov 2021 01:00:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYIPiukeLsl6zSwILM1TDBhbJtCFP4E+QyKxLLGwGl28yWXBKOeN03EUpivtujVJsnP9G0c/m5KiTjKWdOemFCT74kPvOvHtzbnbtfJlrafn8xcayv9p7zihis7wFDOhTwhEf8jSm9dAM3NxkkBYAXpugHmFXLSrJExMMwA7HoA3Ifmh6udZ7qUmlcqo4EwwEgD/DlEIJbhiarLL2m1V/67vBQOMymCwK5GBf2y0co/nQHkY5V/KqbdWzyan2kKb+xZsn2wbpXqLLR5dklQWUFCaQKWTGMcKiszIMjLBXSjOGv8jPFLOfTG4SbBM0kO5Vr+9W3EDW148nc3nrlJx2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SERWW2MxtXBspydJkayC/doLaN+XGHwX70OHWeXQl0I=;
 b=d7uhSS+edqK0+lUWqHTeswxGsimTvnih3xnXzBEyvAH3ri1aVxfxcPOMwVtrLl3xW4W0I8fmF9fI+dlT4nb7VMEGTnGtEhLMRfqrl3Qs3T2wGLB3KCfAlnaz7CxNQ8CPEpeBO7ag3w75RjnXc28cA3fXXuad0OYJbGFbv6ORn60p9mVyhPalfyLPLmY2MIaDcfsV/6uf6zriXjDEnUOKoKIY+9pRs6RjL9fEaZ80FoKDFnopvzxhN8S964xkhXOCQmLiZfco5poelVzrK1cxfgilcnFLDU3csPmdlCQdYs/YwuPotTVdN6kdFthVmu6R8VC8eSV6wBPDUmMUBbkpYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SERWW2MxtXBspydJkayC/doLaN+XGHwX70OHWeXQl0I=;
 b=qDfkIjvTNnbs4d+acg5cjxjLCsBMD4dG6p/XCBgfZzWmIcC53Gk/zmfaFuLgQGPpT/6mp3Z6M9336n51dtt6V4h9rrgsObWWvht16915q6CyCPirTD9M7uuGr1XUM/lodVcsf7u+97vZKNGMureaz7JmFq7NdeiIO6qfBGi78Bs=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by HK0PR06MB2883.apcprd06.prod.outlook.com (2603:1096:203:30::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Thu, 4 Nov
 2021 04:57:51 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::814a:4668:a3bd:768]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::814a:4668:a3bd:768%7]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 04:57:51 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Guo Zhengkui <guozhengkui@vivo.com>
Subject: [PATCH] ksmbd: fix flexible_array.cocci warnings
Date:   Thu,  4 Nov 2021 12:57:18 +0800
Message-Id: <20211104045718.30388-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HK2PR04CA0079.apcprd04.prod.outlook.com
 (2603:1096:202:15::23) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
Received: from localhost.localdomain (203.90.234.87) by HK2PR04CA0079.apcprd04.prod.outlook.com (2603:1096:202:15::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 04:57:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2536a8f-280c-4187-d7f3-08d99f4fa75c
X-MS-TrafficTypeDiagnostic: HK0PR06MB2883:
X-Microsoft-Antispam-PRVS: <HK0PR06MB28831DD21A401401CEDEDC07C78D9@HK0PR06MB2883.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5TvZlbyCAFVp17Ehg5BLWKFnAjageNaU+YkDtLkRD9IR173tVTLAHQ5C8KXQBABn7XmnujJcCKVpU0pulWGwh0mxChAubqUduY/6nxCydMSSbwkd3pLdlHW4NZlw8d/fAKLK/UNVlULpuJgdxX3PFiDBdFNTgL28JkkeJwADz9LX821lRk7J4v2xlEAdKEFUe57Yfe+cfSH4vnXhDt0bsCBPRLBfRynLE1hLSag2oA2kbasuaUt/m1heSPUuvJ0TQ+sWFQY5/A3FXetgNMs46jQA4g7KmIbj6FBTBcgTpwUPL/Ih0/efz/kk7TuFIDn4F3POCrgthRk3/gcQqp3EqHZYssikT5Tve5qMa/rffjEx/tNk95IsdeecMqG/g+8pSIIAuBzrebwEM5Hi4JGUM++qDvxV0wXzwQe2IvYRGBlF0ImbbN0IZZ9ykaq7+om2F+7zGeGZIuVDGADfSPsE5LlzBpscoj9X2sBkQF88sTYlLQEP0UV+itMloaI5ItVY3uLIJJmdCNwzxAapAE3JKKErRsOjsuYHeMCbtWOyRB+dq05DfuNGwvIhonhsTtRX1VsCgxmAAUS6tP8k+WmHX9AyFPerjl3lGLm2Px7HFxB6TpzJe3hVEEjwqgyZAQHnWiOCuX+6IzBZjiUAGV8ayBA8pAZ6AURlepnSMj7ibkXfC1TKEWmM47kNn04otyPd70LvNMScBiiJU6cFJ5COJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(1076003)(6506007)(66556008)(8676002)(110136005)(8936002)(316002)(6486002)(38350700002)(508600001)(30864003)(52116002)(107886003)(36756003)(66476007)(83380400001)(86362001)(26005)(38100700002)(6512007)(186003)(5660300002)(66946007)(956004)(2616005)(6666004)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXFoa0Q2NEx6WnVUbW13bnEyTDRSM0VIWjc3cXdsTjJSVGNqSUM2QkdsNENp?=
 =?utf-8?B?MHE3QjhSQ0Jzd2k4MFE0TkYzZ2NrODNEZXdlbjZ1dm9BZWdVdW1aNzBwTTg5?=
 =?utf-8?B?MDVDZDZYcnZIM3l3OW5JbzNCUDhYeGo0SHB3NjJBbTVSMnhhaHZTdUtJSDhm?=
 =?utf-8?B?ZkJWT0Fzc3AzTklvbmNkS2FJNHlrVWp0R0ZzRGt5eTh5YU9zRG5wMHdTRFlQ?=
 =?utf-8?B?bGVoK1VaQVJ4a0lKZi9pdnE5Q0txTGtwZU1mYjJ1VnNMclBCL3FtT1dRUWIr?=
 =?utf-8?B?MG53SzVTS2VaOTBuN1plVW02ZG1qTlU2M2hENE5ZUW4vaCsrT1o4aHp6anZL?=
 =?utf-8?B?dkhrdGw3OE9hOUpmb3Z0cTgwcjl0b25xa0Zxdm5pcXIvOGs4dzQvWDFVM1gz?=
 =?utf-8?B?NWtYM01kMXRMbDRGVGovT0NQbXZrNG9NdTBNbUpIUHpLSkJqL2x3UkRzMzQ2?=
 =?utf-8?B?M01JcEtwNUVBS1YyakQzZ294R3BkSllpQTFsR0srLzBIV1NZODRlZm50OGw2?=
 =?utf-8?B?OTg1bUl0djExZnl0MTIxaTJ6VWQ3Q0NGMjdkd2lrdzhKQnhRVXphcjFjeUlB?=
 =?utf-8?B?aU9pek1PMVphZmR5L2tuZXN4MnlLTm9TVmNBb2VLZUd2SHovK1lMeUJNSkwr?=
 =?utf-8?B?QlBtWDNMT3FJU05zWlgrSDRxeXh2ZUcwNHlLMVdEUW1WL2ZvaytWYjJRVloy?=
 =?utf-8?B?aEl1SlhVNC9GMlZ0NnZuN3ZWVXpaNEF6d3VmYWtpY0k4MGR6Q3FGV0VlT1RF?=
 =?utf-8?B?aW93VnFXM05JZjQ2SU5yYUd1NzhiWFB2TmR5WWs1TCtqZE5FeHRQOUlSNytC?=
 =?utf-8?B?VExmUkRhQ1lHQmkvZ1RoUVdxRW9ySzZBclpReStVcnlEc3FaOWlZM0JRNjVI?=
 =?utf-8?B?anF5bnUrMlFrUXhzYjUzemVHbGVOOWZSWFpxUTUzeTJzVHBySldjdmFYbWZQ?=
 =?utf-8?B?THozREl4UHJlTGFmSnNjTjF1emQ5S2c2RnlpY01SdmhzZWkvU2FIa0FDczdK?=
 =?utf-8?B?Zlg3enVRVEhUNGMvZlZvb0JrdEd3TG5ULzBpcHlOMnVNcHpJNmUybUJUcWc2?=
 =?utf-8?B?S0JLVGJhWUduZGptTXI0Vys0eEduRCtidmJTU2tOdDByY2F3OXVwL3lyQktJ?=
 =?utf-8?B?NVlqc2VySUErWGluSThaQVBRYndwak9UbHpsRExHeW5WeVhKYmVSM1NjbkM0?=
 =?utf-8?B?Y0lEUVN6UGw0OGZpdnJkWEQzZzlXYmFtcWJieTllT21mbHVCQ29EVXA1Y3dO?=
 =?utf-8?B?T0xZeXVIdkY4ek9GbFNUVVlFRzRuempmbEJwYjRqdWVZZVFpSHFZajZaU3Mx?=
 =?utf-8?B?OXpodUJFNWc5Qll1T3QxalhteFJWUWl5OUtGbEZERjY5RThwc3g1T252cUhr?=
 =?utf-8?B?UzJJd09iQmJuaUsxR2hzVjhrVmVEUW9PSEo2UDRvUUU1NmlsWnlhK0VjSjJV?=
 =?utf-8?B?TEprOWZ2TlErMGQ1UUkzVGFoY1loVUYzL3F1YW1sTmF4SGk5N2ZQM055T01V?=
 =?utf-8?B?L2VMT0lpTTMvVy9wU0YxR1JQdjBwbjVKUVVZbEs2bDk4ejA5M01pYXpOd0E2?=
 =?utf-8?B?QU9vYUZLZGNQa2FQTlNvb1VScFQzaFRLL2pGRGdGTzlhamxaM09xQnNkaVlp?=
 =?utf-8?B?Sk5pQzY5a214cmNxSTVQdng4MUIyenBEbVZNVnlLVnd6ZURtMzIrMXdzNmly?=
 =?utf-8?B?TzVzTCs4Sk1KNDk0Wjg1dk5sU0svSG9HUWJGMjd6OXVQR2d1OWJONHJHUldn?=
 =?utf-8?B?SlZJOUUwVHlMSzBVU2tRUjZJVG1EMkZQZk12bFlQelVrM2JwdXgrMXExOGhq?=
 =?utf-8?B?TTBENEZ5ZXNlWWhJMlV3NExjdmZrSjRuMmNLMW52VHh6ZXVad1lXSS9ERlRL?=
 =?utf-8?B?TUNOVktEc1BrS005R2hrYitmWkh4WDFKM3o0R2NrT0VYZVNHU3VRT1hSMVFy?=
 =?utf-8?B?ZkRtSWFmYWovQUF0bTIva0tWYzJSZjJFT1FmNFhzcVVxQ01yMnpJZHBkbDVX?=
 =?utf-8?B?ZFN3QW5sYzF5QW9HUDNnZFYxNjVBb3JmMWVmK095VWVFSS9LSnUrNlFEb1Bq?=
 =?utf-8?B?WUVBeHFDKysvZjBUTkJYaDhPSFZVMmkxVmVoRG1XWEpHZkswQWRBeHdBR3k2?=
 =?utf-8?B?YmtpMkloM3NuMDUzeGRHNVFJWVlTN0Jub3lWRWhYQ2VwNjBLNE9nUTVaNlow?=
 =?utf-8?Q?UUGJw0rqJfdbNEfnqI0LfYM=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2536a8f-280c-4187-d7f3-08d99f4fa75c
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 04:57:51.0297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tPCIHXzO0yKNhyI76uMhkV3CXLZ5izJgJBPumfOrBLjwIk1cO2YTy1UhnvGEpvTAGLPjdOnyS7UR9TYBo4rsUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2883
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix following coccicheck warnings:
./fs/ksmbd/xxxxxx: WARNING use flexible-array member instead.

There is a regular need in the kernel to provide a way to declare
having a dynamically sized set of trailing elements in a structure.
Kernel code should always use “flexible array members” for these
cases. The older style of one-element or zero-length arrays should
no longer be used.

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 fs/ksmbd/ksmbd_netlink.h  |  2 +-
 fs/ksmbd/ntlmssp.h        |  6 ++--
 fs/ksmbd/smb2pdu.h        | 62 +++++++++++++++++++--------------------
 fs/ksmbd/smb_common.h     | 20 ++++++-------
 fs/ksmbd/transport_rdma.c |  2 +-
 fs/ksmbd/xattr.h          |  2 +-
 6 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
index c6718a05d347..71d018c2e016 100644
--- a/fs/ksmbd/ksmbd_netlink.h
+++ b/fs/ksmbd/ksmbd_netlink.h
@@ -231,7 +231,7 @@ struct ksmbd_rpc_command {
 struct ksmbd_spnego_authen_request {
 	__u32	handle;
 	__u16	spnego_blob_len;	/* the length of spnego_blob */
-	__u8	spnego_blob[0];		/*
+	__u8	spnego_blob[];		/*
 					 * the GSS token from SecurityBuffer of
 					 * SMB2 SESSION SETUP request
 					 */
diff --git a/fs/ksmbd/ntlmssp.h b/fs/ksmbd/ntlmssp.h
index adaf4c0cbe8f..f13153c18b4e 100644
--- a/fs/ksmbd/ntlmssp.h
+++ b/fs/ksmbd/ntlmssp.h
@@ -95,7 +95,7 @@ struct security_buffer {
 struct target_info {
 	__le16 Type;
 	__le16 Length;
-	__u8 Content[0];
+	__u8 Content[];
 } __packed;
 
 struct negotiate_message {
@@ -108,7 +108,7 @@ struct negotiate_message {
 	 * struct security_buffer for version info not present since we
 	 * do not set the version is present flag
 	 */
-	char DomainString[0];
+	char DomainString[];
 	/* followed by WorkstationString */
 } __packed;
 
@@ -140,7 +140,7 @@ struct authenticate_message {
 	 * struct security_buffer for version info not present since we
 	 * do not set the version is present flag
 	 */
-	char UserString[0];
+	char UserString[];
 } __packed;
 
 struct ntlmv2_resp {
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index ff5a2f01d34a..b415a4b914a4 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -206,7 +206,7 @@ struct smb2_err_rsp {
 	__u8   ErrorContextCount;
 	__u8   Reserved;
 	__le32 ByteCount;  /* even if zero, at least one byte follows */
-	__u8   ErrorData[1];  /* variable length */
+	__u8   ErrorData[];  /* variable length */
 } __packed;
 
 struct smb2_negotiate_req {
@@ -221,7 +221,7 @@ struct smb2_negotiate_req {
 	__le32 NegotiateContextOffset; /* SMB3.1.1 only. MBZ earlier */
 	__le16 NegotiateContextCount;  /* SMB3.1.1 only. MBZ earlier */
 	__le16 Reserved2;
-	__le16 Dialects[1]; /* One dialect (vers=) at a time for now */
+	__le16 Dialects[]; /* One dialect (vers=) at a time for now */
 } __packed;
 
 /* SecurityMode flags */
@@ -364,7 +364,7 @@ struct smb2_negotiate_rsp {
 	__le16 SecurityBufferOffset;
 	__le16 SecurityBufferLength;
 	__le32 NegotiateContextOffset;	/* Pre:SMB3.1.1 was reserved/ignored */
-	__u8   Buffer[1];	/* variable length GSS security buffer */
+	__u8   Buffer[];	/* variable length GSS security buffer */
 } __packed;
 
 /* Flags */
@@ -389,7 +389,7 @@ struct smb2_sess_setup_req {
 	__le16 SecurityBufferOffset;
 	__le16 SecurityBufferLength;
 	__le64 PreviousSessionId;
-	__u8   Buffer[1];	/* variable length GSS security buffer */
+	__u8   Buffer[];	/* variable length GSS security buffer */
 } __packed;
 
 /* Flags/Reserved for SMB3.1.1 */
@@ -405,7 +405,7 @@ struct smb2_sess_setup_rsp {
 	__le16 SessionFlags;
 	__le16 SecurityBufferOffset;
 	__le16 SecurityBufferLength;
-	__u8   Buffer[1];	/* variable length GSS security buffer */
+	__u8   Buffer[];	/* variable length GSS security buffer */
 } __packed;
 
 struct smb2_logoff_req {
@@ -426,7 +426,7 @@ struct smb2_tree_connect_req {
 	__le16 Reserved;	/* Flags in SMB3.1.1 */
 	__le16 PathOffset;
 	__le16 PathLength;
-	__u8   Buffer[1];	/* variable length */
+	__u8   Buffer[];	/* variable length */
 } __packed;
 
 struct smb2_tree_connect_rsp {
@@ -594,7 +594,7 @@ struct smb2_create_req {
 	__le16 NameLength;
 	__le32 CreateContextsOffset;
 	__le32 CreateContextsLength;
-	__u8   Buffer[0];
+	__u8   Buffer[];
 } __packed;
 
 struct smb2_create_rsp {
@@ -615,7 +615,7 @@ struct smb2_create_rsp {
 	__le64  VolatileFileId;
 	__le32 CreateContextsOffset;
 	__le32 CreateContextsLength;
-	__u8   Buffer[1];
+	__u8   Buffer[];
 } __packed;
 
 struct create_context {
@@ -625,7 +625,7 @@ struct create_context {
 	__le16 Reserved;
 	__le16 DataOffset;
 	__le32 DataLength;
-	__u8 Buffer[0];
+	__u8 Buffer[];
 } __packed;
 
 struct create_durable_req_v2 {
@@ -840,7 +840,7 @@ struct smb2_read_req {
 	__le32 RemainingBytes;
 	__le16 ReadChannelInfoOffset; /* Reserved MBZ */
 	__le16 ReadChannelInfoLength; /* Reserved MBZ */
-	__u8   Buffer[1];
+	__u8   Buffer[];
 } __packed;
 
 struct smb2_read_rsp {
@@ -851,7 +851,7 @@ struct smb2_read_rsp {
 	__le32 DataLength;
 	__le32 DataRemaining;
 	__u32  Reserved2;
-	__u8   Buffer[1];
+	__u8   Buffer[];
 } __packed;
 
 /* For write request Flags field below the following flag is defined: */
@@ -870,7 +870,7 @@ struct smb2_write_req {
 	__le16 WriteChannelInfoOffset; /* Reserved MBZ */
 	__le16 WriteChannelInfoLength; /* Reserved MBZ */
 	__le32 Flags;
-	__u8   Buffer[1];
+	__u8   Buffer[];
 } __packed;
 
 struct smb2_write_rsp {
@@ -881,7 +881,7 @@ struct smb2_write_rsp {
 	__le32 DataLength;
 	__le32 DataRemaining;
 	__u32  Reserved2;
-	__u8   Buffer[1];
+	__u8   Buffer[];
 } __packed;
 
 #define SMB2_0_IOCTL_IS_FSCTL 0x00000001
@@ -909,7 +909,7 @@ struct smb2_ioctl_req {
 	__le32 MaxOutputResponse;
 	__le32 Flags;
 	__le32 Reserved2;
-	__u8   Buffer[1];
+	__u8   Buffer[];
 } __packed;
 
 struct smb2_ioctl_rsp {
@@ -925,7 +925,7 @@ struct smb2_ioctl_rsp {
 	__le32 OutputCount;
 	__le32 Flags;
 	__le32 Reserved2;
-	__u8   Buffer[1];
+	__u8   Buffer[];
 } __packed;
 
 struct validate_negotiate_info_req {
@@ -933,7 +933,7 @@ struct validate_negotiate_info_req {
 	__u8   Guid[SMB2_CLIENT_GUID_SIZE];
 	__le16 SecurityMode;
 	__le16 DialectCount;
-	__le16 Dialects[1]; /* dialect (someday maybe list) client asked for */
+	__le16 Dialects[]; /* dialect (someday maybe list) client asked for */
 } __packed;
 
 struct validate_negotiate_info_rsp {
@@ -996,7 +996,7 @@ struct copychunk_ioctl_req {
 	__le64 ResumeKey[3];
 	__le32 ChunkCount;
 	__le32 Reserved;
-	__u8 Chunks[1]; /* array of srv_copychunk */
+	__u8 Chunks[]; /* array of srv_copychunk */
 } __packed;
 
 struct srv_copychunk {
@@ -1067,7 +1067,7 @@ struct smb2_notify_rsp {
 	__le16 StructureSize; /* Must be 9 */
 	__le16 OutputBufferOffset;
 	__le32 OutputBufferLength;
-	__u8 Buffer[1];
+	__u8 Buffer[];
 } __packed;
 
 /* SMB2 Notify Action Flags */
@@ -1102,7 +1102,7 @@ struct smb2_lock_req {
 	__le64  PersistentFileId;
 	__le64  VolatileFileId;
 	/* Followed by at least one */
-	struct smb2_lock_element locks[1];
+	struct smb2_lock_element locks[];
 } __packed;
 
 struct smb2_lock_rsp {
@@ -1140,7 +1140,7 @@ struct smb2_query_directory_req {
 	__le16 FileNameOffset;
 	__le16 FileNameLength;
 	__le32 OutputBufferLength;
-	__u8   Buffer[1];
+	__u8   Buffer[];
 } __packed;
 
 struct smb2_query_directory_rsp {
@@ -1148,7 +1148,7 @@ struct smb2_query_directory_rsp {
 	__le16 StructureSize; /* Must be 9 */
 	__le16 OutputBufferOffset;
 	__le32 OutputBufferLength;
-	__u8   Buffer[1];
+	__u8   Buffer[];
 } __packed;
 
 /* Possible InfoType values */
@@ -1184,7 +1184,7 @@ struct smb2_query_info_req {
 	__le32 Flags;
 	__le64  PersistentFileId;
 	__le64  VolatileFileId;
-	__u8   Buffer[1];
+	__u8   Buffer[];
 } __packed;
 
 struct smb2_query_info_rsp {
@@ -1192,7 +1192,7 @@ struct smb2_query_info_rsp {
 	__le16 StructureSize; /* Must be 9 */
 	__le16 OutputBufferOffset;
 	__le32 OutputBufferLength;
-	__u8   Buffer[1];
+	__u8   Buffer[];
 } __packed;
 
 struct smb2_set_info_req {
@@ -1206,7 +1206,7 @@ struct smb2_set_info_req {
 	__le32 AdditionalInformation;
 	__le64  PersistentFileId;
 	__le64  VolatileFileId;
-	__u8   Buffer[1];
+	__u8   Buffer[];
 } __packed;
 
 struct smb2_set_info_rsp {
@@ -1426,7 +1426,7 @@ struct smb2_file_rename_info { /* encoding of request for level 10 */
 	__u8   Reserved[7];
 	__u64  RootDirectory;  /* MBZ for network operations (why says spec?) */
 	__le32 FileNameLength;
-	char   FileName[0];     /* New name to be assigned */
+	char   FileName[];     /* New name to be assigned */
 } __packed; /* level 10 Set */
 
 struct smb2_file_link_info { /* encoding of request for level 11 */
@@ -1435,7 +1435,7 @@ struct smb2_file_link_info { /* encoding of request for level 11 */
 	__u8   Reserved[7];
 	__u64  RootDirectory;  /* MBZ for network operations (why says spec?) */
 	__le32 FileNameLength;
-	char   FileName[0];     /* Name to be assigned to new link */
+	char   FileName[];     /* Name to be assigned to new link */
 } __packed; /* level 11 Set */
 
 /*
@@ -1463,7 +1463,7 @@ struct smb2_file_all_info { /* data block encoding of response to level 18 */
 	__le32 Mode;
 	__le32 AlignmentRequirement;
 	__le32 FileNameLength;
-	char   FileName[1];
+	char   FileName[];
 } __packed; /* level 18 Query */
 
 struct smb2_file_basic_info { /* data block encoding of response to level 18 */
@@ -1477,7 +1477,7 @@ struct smb2_file_basic_info { /* data block encoding of response to level 18 */
 
 struct smb2_file_alt_name_info {
 	__le32 FileNameLength;
-	char FileName[0];
+	char FileName[];
 } __packed;
 
 struct smb2_file_stream_info {
@@ -1485,7 +1485,7 @@ struct smb2_file_stream_info {
 	__le32  StreamNameLength;
 	__le64 StreamSize;
 	__le64 StreamAllocationSize;
-	char   StreamName[0];
+	char   StreamName[];
 } __packed;
 
 struct smb2_file_eof_info { /* encoding of request for level 10 */
@@ -1566,7 +1566,7 @@ struct smb2_ea_info {
 	__u8   Flags;
 	__u8   EaNameLength;
 	__le16 EaValueLength;
-	char name[1];
+	char name[];
 	/* optionally followed by value */
 } __packed; /* level 15 Query */
 
@@ -1629,7 +1629,7 @@ struct smb2_posix_info {
 	__le32 Mode;
 	u8 SidBuffer[40];
 	__le32 name_len;
-	u8 name[1];
+	u8 name[];
 	/*
 	 * var sized owner SID
 	 * var sized group SID
diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
index 6e79e7577f6b..619fad7dd887 100644
--- a/fs/ksmbd/smb_common.h
+++ b/fs/ksmbd/smb_common.h
@@ -240,7 +240,7 @@ struct smb_hdr {
 struct smb_negotiate_req {
 	struct smb_hdr hdr;     /* wct = 0 */
 	__le16 ByteCount;
-	unsigned char DialectsArray[1];
+	unsigned char DialectsArray[];
 } __packed;
 
 struct smb_negotiate_rsp {
@@ -265,7 +265,7 @@ struct smb_negotiate_rsp {
 		/* then security blob if cap_extended_security negotiated */
 		struct {
 			unsigned char GUID[SMB1_CLIENT_GUID_SIZE];
-			unsigned char SecurityBlob[1];
+			unsigned char SecurityBlob[];
 		} __packed extended_response;
 	} __packed u;
 } __packed;
@@ -274,7 +274,7 @@ struct filesystem_attribute_info {
 	__le32 Attributes;
 	__le32 MaxPathNameComponentLength;
 	__le32 FileSystemNameLen;
-	__le16 FileSystemName[1]; /* do not have to save this - get subset? */
+	__le16 FileSystemName[]; /* do not have to save this - get subset? */
 } __packed;
 
 struct filesystem_device_info {
@@ -287,7 +287,7 @@ struct filesystem_vol_info {
 	__le32 SerialNumber;
 	__le32 VolumeLabelSize;
 	__le16 Reserved;
-	__le16 VolumeLabel[1];
+	__le16 VolumeLabel[];
 } __packed;
 
 struct filesystem_info {
@@ -324,14 +324,14 @@ struct file_directory_info {
 	__le64 AllocationSize;
 	__le32 ExtFileAttributes;
 	__le32 FileNameLength;
-	char FileName[1];
+	char FileName[];
 } __packed;   /* level 0x101 FF resp data */
 
 struct file_names_info {
 	__le32 NextEntryOffset;
 	__u32 FileIndex;
 	__le32 FileNameLength;
-	char FileName[1];
+	char FileName[];
 } __packed;   /* level 0xc FF resp data */
 
 struct file_full_directory_info {
@@ -346,7 +346,7 @@ struct file_full_directory_info {
 	__le32 ExtFileAttributes;
 	__le32 FileNameLength;
 	__le32 EaSize;
-	char FileName[1];
+	char FileName[];
 } __packed; /* level 0x102 FF resp */
 
 struct file_both_directory_info {
@@ -364,7 +364,7 @@ struct file_both_directory_info {
 	__u8   ShortNameLength;
 	__u8   Reserved;
 	__u8   ShortName[24];
-	char FileName[1];
+	char FileName[];
 } __packed; /* level 0x104 FFrsp data */
 
 struct file_id_both_directory_info {
@@ -384,7 +384,7 @@ struct file_id_both_directory_info {
 	__u8   ShortName[24];
 	__le16 Reserved2;
 	__le64 UniqueId;
-	char FileName[1];
+	char FileName[];
 } __packed;
 
 struct file_id_full_dir_info {
@@ -401,7 +401,7 @@ struct file_id_full_dir_info {
 	__le32 EaSize; /* EA size */
 	__le32 Reserved;
 	__le64 UniqueId; /* inode num - le since Samba puts ino in low 32 bit*/
-	char FileName[1];
+	char FileName[];
 } __packed; /* level 0x105 FF rsp data */
 
 struct smb_version_values {
diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 6330dfc302ff..ca62060acd2b 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -198,7 +198,7 @@ struct smb_direct_rdma_rw_msg {
 	struct completion	*completion;
 	struct rdma_rw_ctx	rw_ctx;
 	struct sg_table		sgt;
-	struct scatterlist	sg_list[0];
+	struct scatterlist	sg_list[];
 };
 
 static inline int get_buf_page_count(void *buf, int size)
diff --git a/fs/ksmbd/xattr.h b/fs/ksmbd/xattr.h
index 8857c01093d9..16499ca5c82d 100644
--- a/fs/ksmbd/xattr.h
+++ b/fs/ksmbd/xattr.h
@@ -76,7 +76,7 @@ struct xattr_acl_entry {
 struct xattr_smb_acl {
 	int count;
 	int next;
-	struct xattr_acl_entry entries[0];
+	struct xattr_acl_entry entries[];
 };
 
 /* 64bytes hash in xattr_ntacl is computed with sha256 */
-- 
2.20.1

