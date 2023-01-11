Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A73C46467
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Jan 2023 17:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238344AbjAKRFH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Jan 2023 12:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235934AbjAKREs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Jan 2023 12:04:48 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55CA3F12B
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jan 2023 09:02:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLyUSU+LEa8bRfswUibYlo/BitGsmrdEk71OhkfecelMXL0FrWJjJZGBTGKoDWMee6P2viIRhdQIHJ2h6TcFTLRC4RnD2XcbdvypVJuluQql382K3bwC5TtEkLa9zMF09TdG+QA+0pUMJAINfAx4wm1ZnClus5Yh/nab53L2nsIgmIDRivDEGdlgeX4RAyFUdDShhpZhNDOBA0PgI5TTcGpjYaTXGO+mXosWJdrJrxX0dSOn+2PdjjesxBHBtuf56fnx5mUtH2PwRSriRnH/5YuGBJwPcyEwGquUpcbFzaHq5s3Z525KdEL2dJEZlj4N9n15gB4MjHRJ9cW/Gekl6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vlRBG0XOUofNLrgaNhR1YdyiMpub5xa13mQxACaM88c=;
 b=h5tyz/FQNqByRDPSQC2434W23N8rPT2OgM4ZF0MwN5Xpjkk+wLnB0fXH4MWhplmrC6XObGIC7i6pj2CuL+nQ98Xj8PfjtKNZ+fzRnsBcTHq54xCfWnItyGAJd37plLqtw/h+b9l9dG5BJwaK9+lWfLYjGddLoa/DNmu112YixsdG+0lP+LSKyGvsOipxUS+DWIjmWyEElgXgAukvtwhJOtzkk/K0ufD7JGzCoLKvvT9fDd4/DlGRfzX4V9rLoTKjKlG7GYcwVutX2n4I86rsTVC2u5SkJbHHij3OaKY/5XzV8nUII3sHcf2J3L6PhxWzRX68eRPINskytGhtx2ciZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SN6PR01MB3936.prod.exchangelabs.com (2603:10b6:805:22::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Wed, 11 Jan 2023 17:01:55 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5%7]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 17:01:55 +0000
Message-ID: <73c34084-7302-0739-4356-a3abf55e6894@talpey.com>
Date:   Wed, 11 Jan 2023 12:01:52 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Connection sharing in SMB multichannel
Content-Language: en-US
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aurelien.aptel@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
References: <CANT5p=p5vHbitjNMCJ56xT48m0amNaWKhfnASCwcHha3ZvTErQ@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CANT5p=p5vHbitjNMCJ56xT48m0amNaWKhfnASCwcHha3ZvTErQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:208:32b::16) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SN6PR01MB3936:EE_
X-MS-Office365-Filtering-Correlation-Id: b751bf84-52f5-44f4-e63e-08daf3f58a6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u6gKN0SvMU7BhTRKq9i+VgJUPNfDNl2Z7R+w7ZvJgZAnea2r52BnuY6x3/Q7otiGQy6B8Ii6ssDGVf0StnIfokhj7ARvqQZebD/YuNsp7K+QRMmLAl35rtlWQfPzir9L4YsCxVvf69R1izauxd3oFAw00nkFJ5wz+nHsKq3+Li6GehfECt8zQ7+HvnqQs/myxP1gLHfsKVxg8tMDkr19rDRNFqctXMSC4quhz6KVO6Uwwh1NTQ7kz2tkVfKV8R7yt5VKm8WWOkUrSXAno/IkgG1KhwyOhUwCRcaVtbqqIYM4kcWOvkpxGrS3J74z0xZsN1CdtrhYWY/Cd3fLFPe0vbQYzmndhyQAedOCxhI8wgA7oot4J7wD9HUARYyEi59qhNO35V8AhhzqkfA1GrAhPjMK/G8OKW5NgFAqfUdpULJkJqsoxQBM+kfnm8G0TBmL9bItmzRBItbHdLt1a//cA7PsKlhV5fYELEhhouzbRfvSmiK8bx5u6nMM1+5p8iVSdITdcnptElxS16t+ZuOPZUxhsYjs/j85qWsiKQhu4ejsq2hpEfzC2L0aFBRlXwyCFoVSC4SuNaDVLP0Eh9MCXquS9DQfVFHr5wrh4kvy2rsnJuuhlxgTNfXIGukjEe7hjDzlw1FuWifayb8motPjXfOnDR7bnY2QKen/ra7AtFjgTCkkKKaSr37XAzCcg4I76zgOac92DP/5n2yY2ZeMIyMxhY+2bZqC9DQfvrbrwDQqhuHawrF0UjqcSZRwFvHM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39830400003)(376002)(346002)(136003)(451199015)(66556008)(41300700001)(31686004)(66476007)(66946007)(8676002)(5660300002)(8936002)(316002)(110136005)(2906002)(86362001)(38100700002)(966005)(36756003)(478600001)(6486002)(52116002)(38350700002)(6512007)(6666004)(45080400002)(186003)(31696002)(53546011)(26005)(6506007)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmJzUDlsenVqRjZuOG1mRmRkR1dJR09zZ1Vqcm5VWkNSaGpHVzFoaVJPZ2Nv?=
 =?utf-8?B?ZFdSWjJjWk1iejdqck5qREk2N1J2QnRJemNBTzJIaFBIaW52WFVMcTJ2eFZl?=
 =?utf-8?B?R0FCb0RnU2hGYUpka1Z4akJQVzFaS09VZjg3dnNnMnpvQm9lSXVLWGZuNU9s?=
 =?utf-8?B?emE3TCtudHMwMGhPRzhvUllIZGRoTGsrWEJDMHFNOGV1MUxYTkllenRuSkdZ?=
 =?utf-8?B?U1VsaHRKWSs5MG4vMjdzVU5tTDY4bUEwcHRzMWwvZktpZDJIR1FPQS9EMTBC?=
 =?utf-8?B?Z3lUOWlyK282RTdlZit0bE9XOUtlaS9Rd3IwRGNjYzJieUtSbHloT295d1hP?=
 =?utf-8?B?NDFObkdya042WWZFbDRJZWlycm9HY0RNZUFHRUJKSHlKTWwvbUZRQ1RiTVVo?=
 =?utf-8?B?cklRN1ZucnlVeUpoNGxzSGlLekNUV3dRMXJiWEVXZFg5aEVybytueXBEWFM0?=
 =?utf-8?B?YlllYm41UVVPWUJoS0k5ZTI4VjZmZXMrZkdtU3N4OXJIbFUwWUt6SUw0TkNJ?=
 =?utf-8?B?QVFCOXNpaEFmV1Y5dktvd2JSRjE0ZjJQd25pdEpjNXZhQVNacmZGMHJEMC8y?=
 =?utf-8?B?dXpJck05NnhVRXdMZzh6ZURiM2g1NDhHUmpOMU1kMVhzUUIvSkFOTXRNRUJS?=
 =?utf-8?B?YURnazZGTUpkd3JUK3dXTjkxL09PZ0g3YWg3TmxvYURjS21wZWY4REdQSUFw?=
 =?utf-8?B?KzVrcXhIMG5RYUlnUHE3dyt1RUY2bzUwK3lydUtPZDhxVWN6VjJFcUxkM2FW?=
 =?utf-8?B?RlMwQjVmTHRMV05tNk03by9NeHlXVEN0RDVseTVaMGxsd1pqUjBIYXdKNnA5?=
 =?utf-8?B?WU4rTGZ3NUc2ZWQ3emVjckN0T3V6S0FtWlJDWHEvNWxhQkhscUhlN0tERFdM?=
 =?utf-8?B?Q1F5bEZQRnpma3BJOFNjYXkwdXZ2WHEyeUttQUo1V0R5MlEvTTNJNlJHOU1a?=
 =?utf-8?B?Wjg5RmtoUVFPSStMSHg4cXJNQWRvZjRhaGFucEZaeWtYTEF1dkdBbFZOQ2py?=
 =?utf-8?B?cXYrL3BqUWJjUHZkQUNJdHArK3R5ckRTSXp3ZWVWY3EvSWx4a0EwYkxLTmFh?=
 =?utf-8?B?RnhjYWRvT2VnSVF4WFc3cUVDWk12VEI4QWFwUGRzd2xYUTI4Wk1oMUFWQkVW?=
 =?utf-8?B?SE9iT3hNT2tTU2hmZUVUdTFVNmNtZlBMUGVQVENUQ3FUN1BYU2Vlb01YaElL?=
 =?utf-8?B?a1Npa1J6T09IbzZiUW96UDhzZ0syd3UxWnNmSDlVNHZGb28wY3VGUkFoZHpU?=
 =?utf-8?B?ekVSN3d4eVBMbFExc0t2bk8zSm5idVVHWVZGcVF1Y1Z0dS9lSm1FbHBXNEcr?=
 =?utf-8?B?RzNKeVgvYm9heURlZkFDWDQwRU1XL20zdjFPUGRpMUdHMFRMSHFWL0NWaE1y?=
 =?utf-8?B?cUJjOG95cTNVSzUvM1hwaTVzczRXN1lyUHZ4WGxLMTRpOW5GMHJ5ZFIxZ0Ir?=
 =?utf-8?B?OEo3Z0FUV2ZuUWVIUFVLMHU1R2dWVmYrRFZOMG5hM0d6aCtyYzFqT01qN0Vp?=
 =?utf-8?B?Zkd2NkgrZmlYcW9Cb1ZVSlBZSDZQM0diYllxa04xRWJyOGtWSGMvb0w4bHRD?=
 =?utf-8?B?RTRRR05QT1huQktqT0dHQTBnWVFrcjk0bG1KZmVxQm1KazFmQkxOSzZMY2NC?=
 =?utf-8?B?aFRqYi93THVNNnJSdUE2aGdEQWlUaHNqaEhqbW1qY2NXQ29vY2gxQ1ByNDNR?=
 =?utf-8?B?ek5TM1Y4N1FvcmZvVDh6MlNSeXEvWUo2RE1URzJDKzIrWmduZGdFdEhZMUpM?=
 =?utf-8?B?OWNRSjdNbTQ5UndSTmdqdFBtV2h3RlU0UUdyRW1tenNqUVV3MlRNblB4eWU5?=
 =?utf-8?B?ejhGS0xFbENVUHpmeWhQUlF3T1dnV1d5Sit0amJ1ajJVSTVRM2tIM0tna1Qw?=
 =?utf-8?B?TnlKcVdUalh2UWFCS1l0eUszaE5rZ1B5TGJDZXJGdDk3MkdUbGg2UE02NlZv?=
 =?utf-8?B?azdrNzNRd0N1bmpRVXh1RGVTeFR4dlA3SU5ETTJKaHN3SDlBZ1FoTTV5OVhj?=
 =?utf-8?B?NG95T2x6L29ZOVpwS3RzMXFVVWl5K1VHOSs0aHgrVHhTM1R6Ym50NWRYdUh3?=
 =?utf-8?B?Tm9nQjBBN1M3SCswVU5FU3dmNTFQSzk2Q0ROZUhoa2ZzMi9iYy95K0tuUzdS?=
 =?utf-8?Q?ye6rLWi0pe69A9aZIYQbEsdQ1?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b751bf84-52f5-44f4-e63e-08daf3f58a6f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 17:01:55.2253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C2XfUab12zNcO0T3hv5dfINKbtCeWQVYr1GPuCtVezh3MeJvHQu7GJmTSk3gL7g2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB3936
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 1/10/2023 4:16 AM, Shyam Prasad N wrote:
> 3.
> I saw that there was a bug in iface_cmp, where we did not do full
> comparison of addresses to match them.
> Fixed it here:
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/cef2448dc43d1313571e21ce8283bccacf01978e.patch
> 
> @Tom Talpey Was this your concern with iface_cmp?

Took a look at this and I do have some comments.

Regarding the new address comparator cifs_ipaddr_cmp(), why
does it return a three-value result? It seems to prefer
AF_INET over AF_UNSPEC, and AF_INET6 over AF_INET. Won't
this result in selecting the same physical interface more
than once?

Also, it is comparing the entire contents of the sockaddrs,
including padding and scope id's, which have no meaning on
this end of the wire. That will lead to mismatch.


Regarding the interface comparator, which I'll requote here:

+/*
+ * compare two interfaces a and b
+ * return 0 if everything matches.

This is fine, assuming the address comparator is fixed. Matching
everything is the best result.

+ * return 1 if a has higher link speed, or rdma capable, or rss capable

I'm still uneasy about selecting link speed first. If the mount
specifies RDMA, I think RDMA should be the preferred parameter.
The code you propose would select an ordinary interface, if it
were one bps faster.

+ * return -1 otherwise.

Ok on this. :)

+ */
+static int
+iface_cmp(struct cifs_server_iface *a, struct cifs_server_iface *b)
+{
+	int cmp_ret = 0;
+
+	WARN_ON(!a || !b);
+	if (a->speed == b->speed) {
+		if (a->rdma_capable == b->rdma_capable) {
+			if (a->rss_capable == b->rss_capable) {

RSS is meaningless on an RDMA adapter. The RDMA kernel API uses
Queue Pairs to direct completion interrupts, totally different
and independent from RSS. It's only meaningful if rdma_capable
is false.

+				cmp_ret = cifs_ipaddr_cmp((struct sockaddr *) &a->sockaddr,
+						       (struct sockaddr *) &b->sockaddr);
+				if (!cmp_ret)
+					return 0;
+				else if (cmp_ret > 0)
+					return 1;

Again, I don't agree that the address family has anything to do
with preferring an interface. This should return -1.

+				else
+					return -1;
+			} else if (a->rss_capable > b->rss_capable)
+				return 1;

It's good to prefer an RSS-capable interfgace over non-RSS, but
again, only if the interface is not RDMA.

+			else
+				return -1;
+		} else if (a->rdma_capable > b->rdma_capable)
+			return 1;

And it's good to prefer RDMA over non-RDMA, but again, it's going
to have very strange results if the client starts sending traffic
over both interfaces for the same flow!

+		else
+			return -1;
+	} else if (a->speed > b->speed)
+		return 1;
+	else
+		return -1;
+}

And again, speeds are only one kind of tiebreaker. This code
only looks at the RSS and RDMA attributes when the speeds
match. The Windows client, for example, *always* prefers RDMA
if available. But Windows has no explicit RDMA mode, it always
starts with TCP. The Linux client is different, yet this code
doesn't seem to check.

Personally, I think that without an explicit -o rdma, the code
should attempt to connect to any discovered RDMA server
interfaces, via RDMA, and use them exclusively if they work.
Otherwise, it should stay on TCP.

OTOH, if -o rdma was specified, the client should ignore TCP,
or at least, not silently fall back to TCP.

In other words, these tests are still too simplistic, and too
likely to result in unexpected mixes of channels. Should we step
back and write a flowchart?

Tom.
