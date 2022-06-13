Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BB1CCA47D
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Jun 2022 19:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245357AbiFMTT4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Jun 2022 15:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350116AbiFMTTD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 13 Jun 2022 15:19:03 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09BE27CEB
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jun 2022 10:16:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HOKXX2sIM0em6GwSVKG5pSp481GqgsACQGxuYPr7v/hBrYEXi3AM1oFokhqReK/kFRq8IeCBqIH4JFHfr9yzSMs+4vCzGv37AiAxKoXmRfuIroI5w2sLoBhJYgxkAGG46KSgxAFYEoHPUe1AMTNzlRhm37KcIKV2WgdwUgtoJmbLw8lcAcWAIHENu7rSj8YKmQ3iGmji58tMGTgvmnvunOiflqAPuRrENKlQDvjs42sYXFnzzZpP2R0NoXcv3/3YM4ZfgU32B1IzcurqCQebTtuI4hOogo64zhkY84/KKTPSoo+XdMOyhUgBlhe8sO1RWARY2xXr196WY9JnjS6K5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kog5bvj/hCmZeZhMTcvadN96qHX1eT1mM9SHnAyE+cs=;
 b=h1d0G1mCC2AiitBnc3Gbkf3GhaB9m+R1KM0LEebj7BQn6F+NA+SfamTDFtpJTrhjUW3hnt9FY8s6IZ0YH9QneeLu3CNTE0KI03ueYj0m2SFfVmOhero455K/2WoYJHVSvJCnZvRqG/rlHQ5EziOAWlWJTQmBcjIJj0wTHQTnXMfXsh/IvP4hH+xiK8d2KZr0JN2uNS5lsh5ruTDjxGmBpiiITqFOtDVcmoMR1I/0oMpu6WrJjZK57Fbh9lQJwazMPyySxkTi6oQfHgE/THLLXvc+L41Fap2uC3gjn8qAI3LMmJ+BrScBL1wV4pN5lYnYDw3SSIQP3ibOOKX3k+SzFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB4839.prod.exchangelabs.com (2603:10b6:a03:8c::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.17; Mon, 13 Jun 2022 17:16:02 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::1883:4cf0:e35d:b6f]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::1883:4cf0:e35d:b6f%6]) with mapi id 15.20.5332.021; Mon, 13 Jun 2022
 17:16:01 +0000
Message-ID: <4e69d335-491a-a9f5-9bf7-e5f8bdd9dccd@talpey.com>
Date:   Mon, 13 Jun 2022 13:16:00 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] cifs: introduce dns_interval mount option
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>,
        Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
References: <20220609224342.892-1-ematsumiya@suse.de>
 <CANT5p=pWqH=1LhakCyfkwDjUCUvkcy2PcNGK0SsR+04v32=KtQ@mail.gmail.com>
 <20220610171616.op43k3b76o4wqna3@cyberdelia>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220610171616.op43k3b76o4wqna3@cyberdelia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR18CA0023.namprd18.prod.outlook.com
 (2603:10b6:208:23c::28) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5e25632-66ce-4243-97c9-08da4d606404
X-MS-TrafficTypeDiagnostic: BYAPR01MB4839:EE_
X-Microsoft-Antispam-PRVS: <BYAPR01MB4839056E3027B0B046B903ACD6AB9@BYAPR01MB4839.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NGl9atou8PGS51HZyeSRpnzb7kUsWdiXszxtFdt4SztZj5oN56yr8FhlaTBDZf5aj0Z9fMk/dtm3CHE3YMIYR5gZJfIt21+i//9/UPylNzug+DNFZOz3AJIGS3c934SiBrO8XVLJSqcNfIWdTmg46KWq7c4zI4RwRc+tVm1bwi4uVpkZ0g212omldt0z/WquZEizVsbKKoRChDGU3pE3jeMuLlMitpMpekL/dNb6qO0/Me6O+0vl8hNMUTTqQ4m42BEPbKWATiL0jnmarnRVkv1swuibBjShOOAVlC+hK4tMzX/r+CaGym0cu0KmFSmkFJxBCfkiU5jxW/h6ICc3FXe2XpO1zIAth2QAxVH9MxHsGiPRMIsBDVbgNsBSgoUVlIhqSA86Uo+XS/59XON6b8hetFrveClNl8q98W3xn49ZS67ddcEC++l6es5UB49T9HAuOIg+rF7yoq7BV6drUubttZ4rTrNk+48E0s5Ka5bta68jhPi08uE98RfJXO70if5X9eI13cs/eRqgtuHX3gIieP40bEJQTQY549T2jPhslwE2g5mirA5rS7yNjta/qOhHppyPY5Lqt9njKXv5KHjBiuJfAIix5WOZW41rDctQy13yOvtTZ+kVbFWgTWM+eyI7096qlBwmtfiDa8hAMy8oDfiOa8aC81qHBHaHRGPtil5D8kCS+cRxgk+hYMlCwilnyuZkcKZqc+tc+RnHIg6lTsLERYsOGBzvQT+cYxo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(39830400003)(346002)(136003)(53546011)(52116002)(38100700002)(38350700002)(2616005)(41300700001)(6512007)(83380400001)(508600001)(31686004)(26005)(8936002)(6506007)(5660300002)(2906002)(36756003)(31696002)(66556008)(8676002)(86362001)(66476007)(54906003)(4326008)(186003)(6486002)(110136005)(66946007)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFZnSTU4cmtCd2JGakZmbXhyZDdzR0pKekFIdjM2cXFDbVh0a1k1ZXdnU2h1?=
 =?utf-8?B?QlhkQWNveExCcEhIejV6UFFzRnFNOFdzWVRMMkRtRkFBZW1POVlNOGhMZXow?=
 =?utf-8?B?dTVPTTM5T1orNHphcGQvNytyWmc2ZXNhY0dLTVVnY2FBcHk3ejNuR0tiVFpK?=
 =?utf-8?B?Y0F0MHN0OEJYdmE0ay9kMEhqR2pXekNIOW04Z0M1QzUybTQ5dk1NWXZsL2pz?=
 =?utf-8?B?cThGZ0gxeEhQYXJTNzNRQ1g5Z3NLT3ltMEdrTWFLdTN1eTIzNHJlMGE2MzlL?=
 =?utf-8?B?WmtGOEIrZi8weUFOZGxJOUUrS1VkN1Y3WkdpUTFGdExQem5mWi9qaHI1L0p3?=
 =?utf-8?B?bHRNQVErWEwwK2JsMGd6UmNwTVBRSkZERGw1OWdyelZ3bG05YmQzeTZnTlha?=
 =?utf-8?B?MEpzQldIMUFZdkVZTEh6Nlk4NkZkbThsUXZxRU1PVm81aXNXb25VeUFYd3FX?=
 =?utf-8?B?M2lGUGVHdkVKb0ZQMEg5UlVwMVhncms5YnlWTm9oQkUvNTNONUNESGF4b01L?=
 =?utf-8?B?Q3laVEh5N3R0SDRvcmpSTFBvd3NrQ1J6UFlTWTk3ZlBTU2VNd2N0NENSNk5L?=
 =?utf-8?B?cTFGMFdkRGx2c2x5U0FXd213ZkxscVZiYUhMN3h6eEFXSVlCOWRZdVZpdDl2?=
 =?utf-8?B?SUVDMXMvTDV0ZjNZS29NcndkMHlNMUpLSGc0TEVOa2I5ZmpkeVJQZ25RWElQ?=
 =?utf-8?B?M3VBSGJuQjRPeC9vNkovRmdZODA4VFNIc1EySzladlB1T0V6cUR3QXd3d1Ev?=
 =?utf-8?B?UHlvLzZKV3F2YkVtMVl2KzVJNmhYdkxEcDd1dUYwZ2wxMWF2WmZ2VjdCaEZK?=
 =?utf-8?B?MkcvR2dSMWNIR3UxRXcrSWtjVkRpUTZjTHZxL1cyU01SendvMlRkN3ZFY3RZ?=
 =?utf-8?B?a0RJM0dvbEtTTUNxclcrMXE0OUo2a2NQNmxFQ3BCYjBOV1FMZGMvRUoyajFM?=
 =?utf-8?B?STVVeHR2YTBWMllXaWI5R1RKMi9tZUhxbFY3QUVrQjhZQ2FpUVo1anU2WTdD?=
 =?utf-8?B?MTNMVmV1dFpRc2pqTlROeEQvamJPcUJBQXZsMCtPR2JBR2xGY1RwMDdQb1J6?=
 =?utf-8?B?TWx6aUxSM0xxQzljbjU4MDRjVnJEMFE0allxa0pXRDlqS0Vvek5kT3NtTHEy?=
 =?utf-8?B?UXNSNGNCNjYwOGlEYXFFYWVLK3dxRDRrWVJmSXhOdVJjZm5DcFhKczZBdGdl?=
 =?utf-8?B?ako0dXJHZXFFakMrNjRySkFQRTlYVjZJaHhyWk5TMzJ1OTlEa2xDdnN4Zk52?=
 =?utf-8?B?aEYrZG4zbUhYdU5kdHlvZnI1VlNSR2JHc0oxc3ptZnF6RzZ5Z216YklmYlR3?=
 =?utf-8?B?dTVmeW15VldzU3pIM0c4YkwvNVRBaitDd3E1eDQrQ0s5WXgwQ0wyR3gwa0pV?=
 =?utf-8?B?UjNTNlpzV3lZNFhhRzlWOThrYTBVcW1Wdy9aNU9aOERVWUM4ZHh5ck9OVDZF?=
 =?utf-8?B?aXZjcHlkMlJZb1NQc0Rtdzg3NWlLTkg4a3Z6UVVET0Q1Z2g2WnhyTnEvRFJu?=
 =?utf-8?B?NzFqU1NhcmZSTy9WL25yblQweGNnb2dSZzQxMWV1bGhoTU1SZ1RKc2pDZ25X?=
 =?utf-8?B?bjFaY0pTT0xPQ25meDMxMWVlZGFwT013cGhpS1BSQ2k5TS9WRnFPRW1VaUxo?=
 =?utf-8?B?SFpKQmd1U240am11bjRyYlJGM1lWSENoT1BUQ3RkQjZBWjdUanBEOFhLN2tr?=
 =?utf-8?B?bVNwNEduak5TMmtXZk5yNFFKQ1M0US9nNlVtVGVkRUdOdkdOM2N3TmgyODdR?=
 =?utf-8?B?Y3J1TTdzSXQvT0tQRisydDBXQVphTlBNaE1ib2FXc0dMVi9WQ0pKUWs1L0Iv?=
 =?utf-8?B?bUkxZUZ6Q0lXaTZUU2gxMEUwTjQ3NmFYYS9vNElKR2UwSFdLS1JrdktWSmRi?=
 =?utf-8?B?RzVHb3JyYk9HekFtNG13d0pOOThnV0V2ajR5T3VqcEQ3VzZOWTFSa0NPemo2?=
 =?utf-8?B?Zks0OGI2SHhtaHF3UGFJQzB6V3VJeS9JMS9qU0FXL0NMY3pXVjdJekJ2Q1lQ?=
 =?utf-8?B?Y3JtUDdyR3RaNW8ra3NDMDE1d3paQk5oUk10YTdxTUZvWWQ4ckg3ME9FRHZl?=
 =?utf-8?B?VlR5V2s0WUZPcU44M1NSQmRCbStnREZxbmpnVG1YMHk5eGZPVEZVZjBSR0Z0?=
 =?utf-8?B?TmV6MGRta29YYldodGFUdm5WNXZ5T1N0azV3clJITUdvTXo1V2x6b3B0Mzcr?=
 =?utf-8?B?NTZ3amtNWGQ0MTltWFd5N0lFR21wbC9tRUk0YXdOZ3BlR2RIZXozcjRTRG1Z?=
 =?utf-8?B?QWorMGNqOWNUZ2JSdDdPbFZKZEpmTmJKNEpOOVU4Y3FwMUR3dUJCMjRxMjFB?=
 =?utf-8?Q?i1P+wDukemo/bNurib?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5e25632-66ce-4243-97c9-08da4d606404
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 17:16:01.9224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QAERKYabfwevLQajHEIxsg0tcj7sRjGitPQ+/csWCw5i79eka/X8y3l0gKbq2g5M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4839
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This change looks good to me. I'm not usually a fan of mount
options, but it's entirely logical here, and the option can
easily be no-oped or tweaked in the future in compatible ways
when the upcall is fully implemented.

Reviewed-by: Tom Talpey <tom@talpey.com>

On 6/10/2022 1:16 PM, Enzo Matsumiya wrote:
> On 06/10, Shyam Prasad N wrote:
>> On Fri, Jun 10, 2022 at 4:14 AM Enzo Matsumiya <ematsumiya@suse.de> 
>> wrote:
>>>
>>> This patch introduces a `dns_interval' mount option, used to configure
>>> the interval that the DNS resolve worker should be run.
>>>
>>> Enforces the minimum value SMB_DNS_RESOLVE_INTERVAL_MIN (currently 
>>> 120s),
>>> or uses the default SMB_DNS_RESOLVE_INTERVAL_DEFAULT (currently 600s).
>>>
>>> Since this is a mount option, each derived connection from it, e.g. DFS
>>> root targets, will share the same DNS interval from the primary server
>>> since the TCP session options are passed down to them.
>>>
>>> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>>> ---
>>>  fs/cifs/cifsfs.c     |  3 +++
>>>  fs/cifs/cifsglob.h   |  1 +
>>>  fs/cifs/connect.c    | 20 ++++++++++++++------
>>>  fs/cifs/fs_context.c | 11 +++++++++++
>>>  fs/cifs/fs_context.h |  2 ++
>>>  fs/cifs/sess.c       |  1 +
>>>  6 files changed, 32 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>>> index 325423180fd2..ad980b235699 100644
>>> --- a/fs/cifs/cifsfs.c
>>> +++ b/fs/cifs/cifsfs.c
>>> @@ -665,6 +665,9 @@ cifs_show_options(struct seq_file *s, struct 
>>> dentry *root)
>>>         if (tcon->ses->server->max_credits != 
>>> SMB2_MAX_CREDITS_AVAILABLE)
>>>                 seq_printf(s, ",max_credits=%u", 
>>> tcon->ses->server->max_credits);
>>>
>>> +       if (tcon->ses->server->dns_interval != 
>>> SMB_DNS_RESOLVE_INTERVAL_DEFAULT)
>>> +               seq_printf(s, ",dns_interval=%u", 
>>> tcon->ses->server->dns_interval);
>>> +
>>>         if (tcon->snapshot_time)
>>>                 seq_printf(s, ",snapshot=%llu", tcon->snapshot_time);
>>>         if (tcon->handle_timeout)
>>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>>> index f873379066c7..e28a23b617ef 100644
>>> --- a/fs/cifs/cifsglob.h
>>> +++ b/fs/cifs/cifsglob.h
>>> @@ -679,6 +679,7 @@ struct TCP_Server_Info {
>>>         struct smbd_connection *smbd_conn;
>>>         struct delayed_work     echo; /* echo ping workqueue job */
>>>         struct delayed_work     resolve; /* dns resolution workqueue 
>>> job */
>>> +       unsigned int dns_interval; /* interval for resolve worker */
>>>         char    *smallbuf;      /* pointer to current "small" buffer */
>>>         char    *bigbuf;        /* pointer to current "big" buffer */
>>>         /* Total size of this PDU. Only valid from 
>>> cifs_demultiplex_thread */
>>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>>> index 06bafba9c3ff..e6bedced576a 100644
>>> --- a/fs/cifs/connect.c
>>> +++ b/fs/cifs/connect.c
>>> @@ -92,7 +92,7 @@ static int reconn_set_ipaddr_from_hostname(struct 
>>> TCP_Server_Info *server)
>>>         int len;
>>>         char *unc, *ipaddr = NULL;
>>>         time64_t expiry, now;
>>> -       unsigned long ttl = SMB_DNS_RESOLVE_INTERVAL_DEFAULT;
>>> +       unsigned int ttl = server->dns_interval;
>>>
>>>         if (!server->hostname ||
>>>             server->hostname[0] == '\0')
>>> @@ -129,13 +129,15 @@ static int 
>>> reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
>>>                         /*
>>>                          * To make sure we don't use the cached 
>>> entry, retry 1s
>>>                          * after expiry.
>>> +                        *
>>> +                        * dns_interval is guaranteed to be >= 
>>> SMB_DNS_RESOLVE_INTERVAL_MIN
>>>                          */
>>> -                       ttl = max_t(unsigned long, expiry - now, 
>>> SMB_DNS_RESOLVE_INTERVAL_MIN) + 1;
>>> +                       ttl = max_t(unsigned long, expiry - now, 
>>> server->dns_interval) + 1;
>>>         }
>>>         rc = !rc ? -1 : 0;
>>>
>>>  requeue_resolve:
>>> -       cifs_dbg(FYI, "%s: next dns resolution scheduled for %lu 
>>> seconds in the future\n",
>>> +       cifs_dbg(FYI, "%s: next dns resolution scheduled for %u 
>>> seconds in the future\n",
>>>                  __func__, ttl);
>>>         mod_delayed_work(cifsiod_wq, &server->resolve, (ttl * HZ));
>>>
>>> @@ -1608,6 +1610,12 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
>>>                 tcp_ses->echo_interval = ctx->echo_interval * HZ;
>>>         else
>>>                 tcp_ses->echo_interval = SMB_ECHO_INTERVAL_DEFAULT * HZ;
>>> +
>>> +       if (ctx->dns_interval >= SMB_DNS_RESOLVE_INTERVAL_MIN)
>>> +               tcp_ses->dns_interval = ctx->dns_interval;
>>> +       else
>>> +               tcp_ses->dns_interval = 
>>> SMB_DNS_RESOLVE_INTERVAL_DEFAULT;
>>> +
>> Hi Enzo,
>>
>> Is the above line a mistake? Shouldn't that be set to
>> SMB_DNS_RESOLVE_INTERVAL_MIN value in the else case?
>> Rest looks good to me. You can add my RB.
> 
> Hy Shyam,
> 
> SMB_DNS_RESOLVE_INTERVAL_MIN is just for boundary-checking. In case
> dns_interval is < than that, we fallback to the default value (I've copied
> echo_interval behaviour, and also the current behaviour).
> 
> IMHO we shouldn't use SMB_DNS_RESOLVE_INTERVAL_MIN as a fallback value
> because it's too far from the default values used by the servers I've
> checked (Windows Server 2019, 600s, samba "name cache timeout" = 660s).
> 
> 
> Thanks,
> 
> Enzo
> 
