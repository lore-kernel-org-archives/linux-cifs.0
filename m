Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1BAC433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 28 May 2022 01:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238672AbiE1B6N (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 May 2022 21:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352363AbiE1B6K (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 27 May 2022 21:58:10 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B113E0C6
        for <linux-cifs@vger.kernel.org>; Fri, 27 May 2022 18:58:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JgE3ZYnXJGQuRJ7VAKZtpC8kVslN0icp3mAx5MdBo6sep7p+YAppMf/GHpBw5BqZtY+LWM59W0ynfpgW3T0Gdd0Rw//XO/2WMQYc+huSrCZHf2PPTMdqQ/bH4NlXNxpU1JWltFUzMlSjVwqmae/fFyk908tAIME90s4Eyk9OZQ3+ZCwEfaF1buWKWM0WiMurcS/VIhOg29efogXQp0F0e2P6476thP9Q/cRb7YrUJ61L+X4zwsSNBcTFRSHjDdMF5MX0wwRypAvI7g1XQ0gVSsfWmvKG5qX673Ei67gI9+nuJ9ZhVN81teyzO+9uYGpBaML0PkuEt0N/q26HxzI3Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xn+wRLCvTSjhjKY+eda9KIVljYIPWkgS/dS21PBhi1M=;
 b=fQmvMYy3vqeDkquuQRdMRACTZdd7ufl5HSwkfWeLcE2mXrFhqrKFRDlMfjns5lcXp0lfvcQSVd7MU1ypKJYa1G0SXyTXqUYQhm1pIL41kh2PbFgSkfC3wdgkl4Nj4KMcVxQjbXgL9RRiVx8LRJbgvfMWb/MmpHKDojqI50iflNuh0hgVqdO7fv6HAyqJZQXVEYfivv5G2QDAH20wR7UrTY3tCTK1UrU/c46Dvb3OmnmHNcyWKtmSFgdBz2fhgLo4rhfYDoS4XLcKbfSmN5343lCE2GrQcO8XdMCpbSJnXbmoGU/MJhDyMLx4L9DprSRIFWXqW2Or68lbsi2nOo3M3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BL1PR01MB7577.prod.exchangelabs.com (2603:10b6:208:385::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.15; Sat, 28 May 2022 01:58:06 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::f135:e76f:7ddd:f21]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::f135:e76f:7ddd:f21%3]) with mapi id 15.20.5293.015; Sat, 28 May 2022
 01:58:06 +0000
Date:   Sat, 28 May 2022 01:57:57 +0000 (UTC)
From:   Tom Talpey <tom@talpey.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Message-ID: <f0379e80-380b-4396-878a-b0d066742565@talpey.com>
In-Reply-To: <CAKYAXd8VVQrB1N-cnE+OjQtbzOYQAPSUrbrg13uNjq=k1Zxgtw@mail.gmail.com>
References: <20220526235054.29434-1-hyc.lee@gmail.com> <CAKYAXd8VVQrB1N-cnE+OjQtbzOYQAPSUrbrg13uNjq=k1Zxgtw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: smbd: relax the count of sges required
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Correlation-ID: <f0379e80-380b-4396-878a-b0d066742565@talpey.com>
X-ClientProxiedBy: MN2PR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:208:23a::9) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84ded125-6ec0-473f-2cef-08da404d81b9
X-MS-TrafficTypeDiagnostic: BL1PR01MB7577:EE_
X-Microsoft-Antispam-PRVS: <BL1PR01MB75778DEB9937CAACDE267DB4D6DB9@BL1PR01MB7577.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JrxcXijDA50nJ5ooyqFWNbiCerzMIU8A+WefNDNZzXgsloFFEAcQjWoM0mAEZzJGh7lJtYHhK+sEmljygWT/c7YzEKU3ZgOiNiB5jNQSfh3Y/5KOpkmy85YZQZPZrVrtxsTcmBBUPwMnp6iFcx2ObdjjlMcJyOiOrdDC+OVcEvPeQCB7xgA88Je3IsTffSc+6BWF6i4F5cLegVJXgli+9WQSAcG7lxF1t6O/M4/h7RwRdShjZ+uBqSiAKolEUjRJwNRHl9T+elyfX0bs3+RPbCdQoDqi+oN3TtIidVLZlfKj1u6lFzQozYWCs1OTRntoKaUdbyeWw3/2jMnrS4nXfTHqddZm/VZJAPoBlr4eBwzhxZwYssY0PKrCh+rGWvIyx3aJAWsqJFcUx+yVL1hHiqKF/3XdL0l4L6z7oT99hbz5whBBtaMMZ7qdP4hPBPEwD2I/uySOEV7+P5DCCNZNTLOkpaGOAOabc494J/Umv4/b9NXFPEIW5k6TzyniNEuV1VfEODg3A4xRo4/THndu+QiB2Yz+4YST6SY5oChsFJQAmAUrLfJB7LJxCxL6+68+IiLTny0qERRTwOpIjyGbJd8Io79WZo5VoPTvpA8XRN1BI8h8m6gIlZLQQvoWVmXpq3hS1YtYLaprUrYtkPLwrQhfWE2u0l0PGkzsgSGC6ey0sfCJ6/UT3AHuGBfdTXBZ2zD71bTFZlGjvbuUCNZjFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(396003)(346002)(136003)(366004)(376002)(41300700001)(86362001)(52116002)(6486002)(508600001)(31686004)(31696002)(5660300002)(38350700002)(38100700002)(8936002)(36756003)(4326008)(66946007)(8676002)(66476007)(66556008)(186003)(4744005)(2906002)(6666004)(54906003)(316002)(26005)(2616005)(6916009)(6512007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ykx1ODB5MUU3dFgxUkFjY1NvVFljTS9zeXdxSENCbUMvVldFa2YvbjVndm1p?=
 =?utf-8?B?bVVHMXRaallUR1hJS2srNk9HL0RHZXVZWkhlUFN1NEFhei9lOEpTYXVEbmNI?=
 =?utf-8?B?OVpnellsNXh1UXpIc210QnkzQWNPNDU0WFJxNk1LdXBBVEFpRDJJc2IxSHRo?=
 =?utf-8?B?bE1QNWhkU2VtS3l3MVVDcFM5YVJGMERuUEdYclM3QURqUUtoaDdoSENVQk1N?=
 =?utf-8?B?U1VXWFpVTTZZL2RLK0l6Tk1RRGFXTklqdzVScWRuVWRUWGg4QUNmODEyd3VL?=
 =?utf-8?B?NHBGckhreU1SbXAra1BXaHN5L01CamhrbFFBbDRSNFh0ak5xLzBaWjlvbERx?=
 =?utf-8?B?c241cTBGZ21oU1lDS3E2WndyQndCWUpsKzQ0SGVMWTZWTFRZTExvQktTVUds?=
 =?utf-8?B?QjFwTmRudmx3RlAxNktMdXN5TWV4OGxaR0M5MG1zRmZBUm0yc3N1M1ZqS0Y1?=
 =?utf-8?B?SWprMktHZlNLbkxtNCtjNmJPM0g0aUVUNldZY21ZQ2FadWN6NVl6QllIK0FR?=
 =?utf-8?B?T1dNT2tJc2RXbFFBUFNKdnlkaGdhejVWZmRINkZnNUs2ZlVieEE1RDdsOVZ0?=
 =?utf-8?B?WjQ2b1QrOGk1NG4rc2VRS0VsMkUyNTIyMWVPUC9oL2o2Mi8zY0srV0ppQXF3?=
 =?utf-8?B?c0xzYTJtdFA4N1VCMWdHNCtnQWpLNVVsd0QzOGlObEpseE1FSjdDYlpYV2o0?=
 =?utf-8?B?TXk5UmJhcFp4a3V2WWRIeWVIaWNLbHlGNGZSZTdSRE5sajJtNHpDclpSMUt5?=
 =?utf-8?B?Z2F6VkZBa0tQU3lTQnFpWnpjZnUrMFloZWNqczNPeEJ3Mk5rQmlsNjdXa0NG?=
 =?utf-8?B?dVJnSTRXZUlLWldZazd3cDMzZEZINXBJZStVakVNNHRkL3pTWnpESG1PU1RT?=
 =?utf-8?B?MFVKUlNsNlZPNEVDVzBCclRnZXRVOWkzQ0lnV3dkNUtjWEM3Wi9KQURxQ3dT?=
 =?utf-8?B?bHppMEduVXNkQzkwVDZCTTB1QktmVm5KbCtDa3RCdFhKYlhSRjBhNlNLSGtz?=
 =?utf-8?B?aG9nRXh0STdka3FLV2JPOVhHYXpPODA4SHp1aUx4VnlRYzBRa2dudHhidmNN?=
 =?utf-8?B?TlMrZVVRTzY3clBxcUszSTRFRE9UODc0NDlzbVUyM0lRS1hHa2orN0I2c1hl?=
 =?utf-8?B?YnZhT1hSU0xFdWRpMGIxWHhKUk9RM3hLSmFONEtDWENReWQ4Z3l1eVQwU3FF?=
 =?utf-8?B?SHdzNU5XZHREbDZFdWFyWkIrNWtwRWhpSERrUFcrWmM5ZWlrbnYyb1N3aFFO?=
 =?utf-8?B?UFIxaUQzL3BQdlVETEVXQW5LdTlqV2xGaFgzNVJReHVuMldpMkltQjNIbTFX?=
 =?utf-8?B?VVNQZzBEekJRdmtrZWVydU9iWHAweUd6SFJPNktIZy9yUkNHRlpYRlNwZGZI?=
 =?utf-8?B?RXhDK3ZHRWdBMEQ5cjd5elJWTlBxeTZIdlBDL3c3aG1jbUo4c0ZBVXZ6RUN0?=
 =?utf-8?B?dVRHdHk1a3Bwb2ZuZHJwMHFhVGZTbGFFQ3FVVnVDdEp4dXBRNE5LMXVENzRq?=
 =?utf-8?B?RmJEMTNaSjBtUE5qb0pRV3NyUVUyMFE0MDRYWXFRL2FGOEVvK2k0NVZUODVR?=
 =?utf-8?B?SVFrSm9mQ2pBcGZEVDdxSkNNbnBTWkhBcFRwTUs3YUszQUt5d3ZYS2RsRE5k?=
 =?utf-8?B?dVpmZFl2NHh6amwzWE9QeGVyOFloQVhuL3pUYkNGZDdwK28zdGtzdThVU2dC?=
 =?utf-8?B?eFlydHYvaEVLVmlQNXNhZzBPdDg2WDZyV2NNM2l0WmRJWmZSSkxwc1dhNHJE?=
 =?utf-8?B?WExaTjBmS3U0d3FYVGxqelAyZXVsUnRkcEc5MVlJODRDSER0TmdWbmFNajRY?=
 =?utf-8?B?VTBDWjZta09peXFSdmRaYlNCc1Jwb2IrcTJ5eUdnRld4NDR4cFEvMmk2MkZB?=
 =?utf-8?B?My9MMWNLUlJ0dmhzTU5WZWljNUUrdTZhNTljZVA0QXJEaytmTnMxTWNsdDJT?=
 =?utf-8?B?VnViQXkvcFlwOHQydVR0SDB3QjFwem5iVm5MNHErMWRpWldIUEIvM0JFUm1G?=
 =?utf-8?B?c09vN3d6NXA5cGV0SXMrc0tLUzQ1M1F0QVIrSlgvZ1NMNlVaalNudHl0aGVM?=
 =?utf-8?B?Q29UTFBWY3Z1akhaZEMya3U0WTdJbEo1d3Nrenh0NVRFQWk1ekNHMjlCNGF3?=
 =?utf-8?B?akF2MHZnbGc3c3gvTHdaNHpqYzhwWjlCNllsbS9aL1JqbmZWSGFKMis5TDlJ?=
 =?utf-8?B?WG5sSTdTTUFUMWVlVnNLcHJFR1dyWVdOZE9QSG93dFJmdUJUdU1SY1M3ZDU5?=
 =?utf-8?B?YkUycnAwNVA2dDUzd3ZybUQ5U2QzRlBmZldBakJlMERsVUJEdkw4dlNaY0Zu?=
 =?utf-8?Q?ZDEs0YzWbkmDLcx7NB?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84ded125-6ec0-473f-2cef-08da404d81b9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2022 01:58:06.1121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rS04uva14WqH2ZIMmxnqV64zavFJFUkPFvkUC0EvWNWYAG1fxIk3Sx7OmRm5zJRF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR01MB7577
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Solid. Maybe add some slack space to pull up the header buffers and get the count down to 3 later :)

Reviewed-by: Tom Talpey <tom@talpey.com>

May 27, 2022 6:47:49 PM Namjae Jeon <linkinjeon@kernel.org>:

> 2022-05-27 8:50 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
>> Remove the condition that the count of sges
>> must be greater than or equal to
>> SMB_DIRECT_MAX_SEND_SGES(8).
>> Because ksmbd needs sges only for SMB direct
>> header, SMB2 transform header, SMB2 response,
>> and optional payload.
>> 
>> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
> 
> Thanks!
