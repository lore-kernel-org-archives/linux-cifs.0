Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DFAEC433FE
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Nov 2022 16:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbiKHQrF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 8 Nov 2022 11:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbiKHQrA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 8 Nov 2022 11:47:00 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A996C4E438
        for <linux-cifs@vger.kernel.org>; Tue,  8 Nov 2022 08:46:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CcOuA9PWkTMcu1grKYuAzRMkFVCAp0vmRTDpsdG2mubyoai0TftCKiJuR8Ka0iDjMvh1wUYZN3nLqDL8id4HGUpnBGwynn6W0C4MzmjKUIVJuiL08zGr6QfaHjU3Dp0Dl1W/2AK0K+uPoZHfxECqJwcAdAtaOMbtOIRdTpExehwvarc6nHopB+p07zVLaec75jM+X3bDJLE11/0prBiayTD7sY9zdPebPqK9djdXseX8WoAeIXSAP1CW9R4rG33Rmoh7PpePH5HPStujGmKXwkE1n+wlpdpEJfaBWI2m6xyUUm9uKqG0ks2uyNkjM88ceuJ3rxm4Lio6tLeFpJueoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=luwj2BaRKFZ53vE5EdEFhIOyM9tiUQYQEa4az/wicEs=;
 b=ISNxdwVyr3FzWCVHXqPDvacKRyXkNFVVv0X9sqOts3tkp7mJk1Csj+oL7CEzug0alR7zT/Ob4mMvrDy8Wfh18iN0f8A15I6f7txOuJTl6ddZuXKjYeyOyhOci0mUQYcCVQSz+3Ns9yec9SirgHxkBaVUI1BmQ0C9etG5z5SRJDNEnQ0QDBqmY+3JXNnETMitEzcC97B2dV0WN2rF+fUqoFNZX9BktgqwO4bA+eMBqnSZSEVOXbHD8dHdSeuo59HUh/zIZbKpOy0NswLMK0llUo+M7snTIt2lpKKdf/ENANQ0UNR1I8gb1LUYYIW+xGupS6qNNqoPvbY5DyWxXDlg6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB5014.prod.exchangelabs.com (2603:10b6:a03:78::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.25; Tue, 8 Nov 2022 16:46:54 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::4869:f99b:94c1:b502]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::4869:f99b:94c1:b502%7]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 16:46:53 +0000
Message-ID: <68bc143d-393d-574b-c600-1575b38a5e81@talpey.com>
Date:   Tue, 8 Nov 2022 11:46:52 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] cifs: avoid reconnect race in setting session and tcon
 status
Content-Language: en-US
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        CIFS <linux-cifs@vger.kernel.org>,
        Bharath S M <bharathsm@microsoft.com>
References: <CANT5p=pW_CMrD4EacJnwKGK74nW1sRxa2ummheWxujwXtfh0cA@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CANT5p=pW_CMrD4EacJnwKGK74nW1sRxa2ummheWxujwXtfh0cA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR15CA0004.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::17) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|BYAPR01MB5014:EE_
X-MS-Office365-Filtering-Correlation-Id: 37ce8b04-c208-4d3c-b2cf-08dac1a8d740
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZR3P60Ds62Btluwa2spnHBvk8fdQKynjQEFXRdr0iC/kb+aPVOo5mE6JJd8TbYUdA/wGeCJQG2EBEeFEf34+gnzyAS3ddjQAmV1Hq9fwtJQw/XXEI+ABNks5Cevi7ra6My+6wMIkRsztANLuAgQ6rWBdVsIGEB9qWAq/mrZ7zeGeDnDtIOUnpr/78sUImkIUP3WQWAO6c5tSWd7T6R+kFeWMZnAeCtMCHdPTmUdvI9QskL6ATSefpPV//nIlkLvsd176s78GWs/oKB9PBMIOwit+haThc1g8yYVTmsVKi5Sx9CgXTdFGdT2HHKFjYtG/oxitghXb2HRPBh/QLKoJ6GEU0cAkIyQUIAqBgT2BlJI4i6M51axjYZ4aaAh5pfEapWHpnBR2cdgmMA9qzhcRwxbhC3/l0+4q/BTjiO5FRPspSq2jMyI/MLAtMQZMI1iCMm6xbN+erb8Ab+LRn45RgNGl7zKnTxtAwqlYgLk7Fat70zf0BlJf1g26ju/SfkZ+H5+ugjZELR6AF1UDZs5Di4bumfczne92JBed2WUJyipn6Q4YjZTu/5C74frjTvISSpvJQ1pym4fPIgpxQaG07E8GKKhH5j4+IHssqsGIUyJxjK/kfW0YMSiFUKo5/sCkK1gJYkxTW/q8n/y8sERaDMhpZBoz8NKYSVkxw2UVxcIIdaqO+WzXWPjesEFTbS5RBBKqog9l28qV6oGYzzO0cdgk1vQFb65oqaLxteNZAS1QKEC3lZW4Sxrprf05FG6asyLSuXeM79Znv52MpkuClKRqUQc3Be9B+tW753GPiXbHLORammKKfNwex4bwYrbu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(396003)(346002)(39830400003)(451199015)(8676002)(966005)(6486002)(66556008)(66476007)(110136005)(45080400002)(316002)(41300700001)(66946007)(2906002)(38100700002)(6506007)(38350700002)(8936002)(6512007)(53546011)(186003)(52116002)(83380400001)(478600001)(31686004)(2616005)(26005)(86362001)(31696002)(5660300002)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ME1nak00b2xGS2wzdGpDb3g2UFVobmJkYWRzNkxzQlpHTVFBdUp1ZWFlc1RZ?=
 =?utf-8?B?dWUrTFRzMU90VWhyUkdFc3oremo2U203T2psT3lMRFFLZGFFZHl6MFo4T280?=
 =?utf-8?B?TktQT3pvRXpHL1B4dy8yd0h1Z1lyeDNoQjJqQUo4RVF1NmN3TjFhWk04UGNp?=
 =?utf-8?B?c2tRN3lvZEU1a1E5Y0toU1ZJcjI0c2VnMmQ4SUVzbGFuV1BIa2dLQ01TRFl6?=
 =?utf-8?B?dDBYR0FGZ042Y2RoQWJ5NzNGMzkzbVF0WmQ0b2o2N0JjWmVhRlU3UTN3WTAv?=
 =?utf-8?B?dU1GcGtMUnc2MlhncWlFTHZDZU5GSXpXcmNTbE4wVVZtQ0kyUHlRV3NqWFNR?=
 =?utf-8?B?RUpVQkhiR2QxV1BVRTRjNTJ4OGRJNlY3VHhBT0g5Y3RIYkxZMU9vNEFoWER0?=
 =?utf-8?B?Y2VFbW84MlV5NEY4dkcxRTkrRDFRTC9qYVJqdEYvcTlrdlZ3ZzFLakRKQit6?=
 =?utf-8?B?QmUzcXJUQ1E3M0Z1WUdXaEFvRjlhR2UvSnpPVE8rWndabWQ3TU0yOEJGVmlI?=
 =?utf-8?B?VW9UTzZYcDlqMURUL0xuZS90SUlWWVh0Z1BEbHRqUHJqejlvL09WUllLS2dt?=
 =?utf-8?B?SnlLNUwrVlh1RnRCR2cxTXZyeVg4Q1NXT0xxSS9NM1JZY3Jta2FjQ1R0OU9j?=
 =?utf-8?B?T2NSSXhJQk1mK3hWU0Q2RlBDbkZ1Uitzem9YMXNGMGZPQzdOTUlYZlE2ODNB?=
 =?utf-8?B?Q3ZDN0tkK1ZiSFMzLzNOQmVrcVovUzhMQldsWGhCeVZJcWFac0pIZCs5MER1?=
 =?utf-8?B?cTVBcnl5eHFPS1cxd20ra2ZaTHZrQTI1VVBHcVlSQUd5d0h4QjBXeGZuQldh?=
 =?utf-8?B?ZDY2NXJsWXpiUjU4dWdsckt4RXNxbDEvTHdZRS9DQXBYeVU2amQrVlE2SGRh?=
 =?utf-8?B?cUdrTDM1YWtpaUp5azJISnViUW5WeVBYcyt4ZjVWQUI0d1R1NlhXTENlUE5L?=
 =?utf-8?B?Y3JJQlc5ZmVrbXc4aFJRWXd0QkFSRzJqcHpEVURlWVJhRVJKVlBFTzN6ZHc1?=
 =?utf-8?B?QlplbC9yRmF1RGdTTlZxY2h3TytFWERpWkZDelp3VTROSnBsS2NIOXRmZEpw?=
 =?utf-8?B?MU1UU3gva0ZFSW50Rm5XZjN3ZFJXekNHaXJXRjI3R0dGTnA3YStVdkZVYTN5?=
 =?utf-8?B?N2pwa3R3cExZYU1OdnpHd2xpVUVXc0RLWWFMd0dweThVRUM0VjFURmQwamtv?=
 =?utf-8?B?VXNsVXZWYmFIN1JLYmdtUEtoWTNpWHlsRCtJdVB5bGcrdjhBSVZRbnljcDhv?=
 =?utf-8?B?ZFBZZVA2aTA2OTliZW0rMU5hTkloV1hON2ZDK2Y4RnZJb3Y0WGZENUZLckhC?=
 =?utf-8?B?OW9WWUpJeWgyTStJQ1VyNTFyL0Z3VW5PaFZGeG1sTVl2ZnBjcTVHRG54cXds?=
 =?utf-8?B?U3Q0T0dnbFFNQ2NwMGZUUHJ5N0xwODlmcSt6TEJvZFRHU1lndEkxTm0zM3U2?=
 =?utf-8?B?NndGa1Q4TWdpcmVKTFlNOHExd0dLNGVraDN6aWlhUWMrRnhiN1hWTmZSWnk4?=
 =?utf-8?B?VTV5TDZNdExoT05ERXN2bUZETFJkOXhJdk9WcjYwNUJiNHpjWUhvYkFaSFZV?=
 =?utf-8?B?TXFFU1Z1VkxrS2gvUTBjSTJpemRaeDFndWNuN2JkT0N5elNoRjRhcThCZERv?=
 =?utf-8?B?dTJYQldrcFJNL1lGRWdoVk5zbFBSTzl1bG4wQ29kNitpMHZsejVTWGdLZmtS?=
 =?utf-8?B?bTQ3L1FZQjl2WmJ5RnVaTHNQL3dVaG9NZ3M5eHhnSFd2ZnpoQlA2YkxtS0NE?=
 =?utf-8?B?alVLTTBNNkU3V3VWUXEyS1ZhK1MwMzFXdSt6OFF4d2dQZWx2aWxSdk1URXpE?=
 =?utf-8?B?NWZ2c0xscmR2dE9Yb1Y5U05LbTNSblFsZUU2aVRGTDBCbER0YmczOGpSV0k4?=
 =?utf-8?B?SVZ5aStTRGdnVXVuYmJIZG85OS9PRzBpQW1EMVpkbEw3VzBsS05lQVhaRnA5?=
 =?utf-8?B?MDBlN0NiK3ZJSEd3NTFoNmdkUmFXVVltVFFZcGI1WTdZNzkwQ2xjUDA1Y25E?=
 =?utf-8?B?SGZka1ZHWldwbTlyU242UVBrSmw1NlYwTUdaRHdlMkh1SGl0Slc4V0dhWlBU?=
 =?utf-8?B?blZhN2hDNFRDMkNybEFnem9HMHdmMlZtUVFOcmhRK2NiUWpXMCtIOTZNOXJ0?=
 =?utf-8?Q?VKdU=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37ce8b04-c208-4d3c-b2cf-08dac1a8d740
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 16:46:53.7916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ci4/uLWthz6k7d+oMgMwgi8rUcyDaXfN4Ow4OAB+2+FFVovxR2Cx8eChOo3q2Gjb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB5014
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 11/8/2022 11:33 AM, Shyam Prasad N wrote:
> Came across a couple of race conditions between cifsd and i/o threads.
> Fixed them here. Please review the changes.
> 
> This change should also ensure that binding session requests do not
> race with the primary session request.
> 
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/c4ed4d985488640469acfc621bed5c3a55d67ac6.patch
> 

Copy/pasting from that page:

@@ -4111,6 +4111,16 @@ cifs_setup_session(const unsigned int xid, struct 
cifs_ses *ses,
  	else
  		scnprintf(ses->ip_addr, sizeof(ses->ip_addr), "%pI4", &addr->sin_addr);

+	/*
+	 * if primary channel is still being setup,
+	 * we cannot bind to it. try again after sometime
+	 */
+	if (ses->ses_status == SES_IN_SETUP) {
+		spin_unlock(&ses->ses_lock);
+		msleep(10);
+		return -EAGAIN;
+	}
+
  	if (ses->ses_status != SES_GOOD &&
  	    ses->ses_status != SES_NEW &&
  	    ses->ses_status != SES_NEED_RECON) {

Sleeping for 10ms is really an ugly approach. Apart from making a
completely arbitrary timing choice, blocking the caller uninterruptibly
is pretty rude. And if the existing setup fails, this will blindly
retry it, immediately.

Can't this take a more formal queued approach, with a proper wakeup on
success, or bail out on interrupt, timeout or fail?

Tom.
