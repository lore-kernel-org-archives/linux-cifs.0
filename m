Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4605C43334
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Jun 2022 16:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347003AbiFAQR3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Jun 2022 12:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240224AbiFAQR2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Jun 2022 12:17:28 -0400
Received: from GCC02-DM3-obe.outbound.protection.outlook.com (mail-dm3gcc02on2128.outbound.protection.outlook.com [40.107.91.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DEB746140
        for <linux-cifs@vger.kernel.org>; Wed,  1 Jun 2022 09:17:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXwFJayhb3DnyZf+rZjlICZ5+fCZXIRTB5chnhs0YeqxqKnSyFWG3DBX7BUftwP4O4dMlo8wR5k/MxW2UBTpesi1BTq8n/0AwQx+NgYWiovEHdsI785DvO3o7OOuEWdWJTTQDSgcDrqpoUMqfiee+BdRbTBHyFvVuAKubLdMrhPw7fH6bT+nYdIzOyEhDTfuKIctcn8/sMbekiHxiQEbY/GOrXYvNo87Dumq9mcSe9BXkA6h57LfMD5BFac3TG0x2oiBOCYRGtLVAgVryrVg5caih3TRNSfYWuI9YP+f9Zsel5VEMQdqDYVB7NssRDHW31oxK1W8ojNyuGbzimpkFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0+nwyxVGY9l+3skzQ47+CqBHM5Ks9MIbdzr1R4hCdkE=;
 b=T7aH41y6nt0PDYkHO9N11WL1xA/CCItDGeU2B4yN4PUM9xMRVHmw12ArUpSDqYg8gQHxRtKPUC0Zp6xIMfRCsP6FHZ7RazD5JP4UlYJGWEmcmiWxIz6ntFzcUVOMsoea9vDu6wWiDo4T14k+J82DBQFvFJ912LVdJH+Ii3IPu5kQopJJfc/dUaAEtV4KWPTPp9Os0RkMcjYafw9Bq/f01v2ZekzvxliJQv5Lq0dfozqpMWqPEfJVTcT6dcrtETYgEhmmpPr7h71hIJvui1A5KbCGrnEZG1laY+4lY2xOe3NOPFpl05T5wOWy1FC2FDAaWVxAub4+n5APeDgVaY/TGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nwra.com; dmarc=pass action=none header.from=nwra.com;
 dkim=pass header.d=nwra.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nwra.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+nwyxVGY9l+3skzQ47+CqBHM5Ks9MIbdzr1R4hCdkE=;
 b=1Yvo17O7E3fcbOL5O+hJrhDNxCvROp7/BzteA3dMOqZrubKKxjN06ORwpGK10H3AP9kFwvqTOEKOKYomwGaWT4N+HQ3hEksYOR4TezsUgQ1F8YZozBHvgVLQobc5NjvAyhk8voUsVwrv/OgAGGqJJcJ4i5IIDSnnwqXmt0cZEtSq2L/tF5cFCDiBQNnc+S25goMnVx3KLex+ebOFNDVwuPfzzit5JnDszqB7gQkxWLOWr/Nga34af5KKmpKeASW8r9ZLOSa/rXphB0XBhOQTWvZWbdDHoOJJKJkNX0QDutGYI9AmuqmfZKp6cPavb3GP14FuNwjtFPYZYnm5mMTo3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nwra.com;
Received: from SJ0PR09MB6318.namprd09.prod.outlook.com (2603:10b6:a03:26b::14)
 by SA1PR09MB8160.namprd09.prod.outlook.com (2603:10b6:806:183::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Wed, 1 Jun
 2022 16:17:25 +0000
Received: from SJ0PR09MB6318.namprd09.prod.outlook.com
 ([fe80::adad:368e:3553:5368]) by SJ0PR09MB6318.namprd09.prod.outlook.com
 ([fe80::adad:368e:3553:5368%5]) with mapi id 15.20.5314.013; Wed, 1 Jun 2022
 16:17:25 +0000
Message-ID: <c0c6d353-5868-01bb-8139-331bcf3e5782@nwra.com>
Date:   Wed, 1 Jun 2022 10:17:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     linux-cifs@vger.kernel.org
From:   Orion Poplawski <orion@nwra.com>
Subject: User loosing access to cifs mount
Organization: NWRA
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms020203010605020305050001"
X-ClientProxiedBy: CY5PR15CA0014.namprd15.prod.outlook.com
 (2603:10b6:930:14::35) To SJ0PR09MB6318.namprd09.prod.outlook.com
 (2603:10b6:a03:26b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 879da23b-b628-4f3e-c8c6-08da43ea3700
X-MS-TrafficTypeDiagnostic: SA1PR09MB8160:EE_
X-Microsoft-Antispam-PRVS: <SA1PR09MB8160B4E1012F4AD72A927D5ACADF9@SA1PR09MB8160.namprd09.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QsM3VR3r0OtYbMdOWKTXhUFFUfLt8BOBJZTkcG86aNeMmUnj7mA8BXAk0k4S8Ymn0ItyXYZpt+Us18tFsAwulYmaN06x0+IYtHpCKWGvKY7arREwTbHZCLKtYLAqyY/RVXmMyHNtJTCApuaOs7DUMxsHneOBVV7n2cE0lTb/lsfeIKpJw5eMW8KYBBEBEyNJWunOghEoF0ycrnbmI1muBbS6oslLz94Mpls2gpLPHa7ZMw2uC+EFedcK5VzGwEfDvSkVMeCL/DHGnrWsn15z1TC5Zt1R2FC3n130PLnYPx8ro2R3sQfYCpt1Or0xyvr0KmOWnc0Uaf3WQe/LJFP+106m0MOfhAgin1agqD79F29QO2pVgXZTXol4ccS546xc775QlxF0HpiCK4ucz9kE1Q+Nvs7aM1Ch02Qmqi1BrB6gunNgjIlg05ZO9GfMT/2sESbIfl9VYcbNv04Qw7htwSo+4LroMTtA7Wwy8u6x7X3htefaDAikinlXnZb9fTAIsP4r5pEMRcJxumP5J7uw8MD1Ob0/sAQ57RnhTLKWAV9G9mutPdVdVo37wGR4aNNTKHScCmvTwi5oh/hLVpyb8iTek1uZ5lXfJI8VPSLS+u4+ibK/30HYdbh2Wx9XKng1fJtpd/gAEEoX0Rex0AK0DyGQDSaFCRu4olKeN+93gRO9J+9rOr84yebfMp2NRnLzKX4/HsW6cd9vNKFnerXHP+Cjkv1bkPVSCMNeUlDMZRovnnfrgqKdm/PBRDcsJJLed9Z5ADv9dvOsbPRf6CnknUUTEuGx7h82+OeC/st3G2R1iEtKrFQPfdmNu4pcxyF7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR09MB6318.namprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39840400004)(136003)(396003)(366004)(346002)(376002)(6486002)(6666004)(6506007)(36756003)(31686004)(8676002)(66556008)(66476007)(6916009)(316002)(26005)(38100700002)(2906002)(6512007)(40140700001)(36916002)(508600001)(41300700001)(33964004)(8936002)(86362001)(31696002)(966005)(83380400001)(5660300002)(2616005)(235185007)(186003)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2JOLytMWEtRbmprMDFqMHZMbDQ0VFA3dkNtYjlSRUd3S1NrbytWbG5La3V2?=
 =?utf-8?B?TGFmc3NIYlRkdXdveW9ncExPU0l6M1ZCUXBBeTVGRVc4S1VhTVVDc2xTWmRy?=
 =?utf-8?B?TC9GeXp6QXJqVjRIQWtnZlZCdUNYV0RWVkMwVlROTHA0UEJ5WFNSOXB2MFVG?=
 =?utf-8?B?a3I0Q2tWYll4eTY0WjNkZzBkaXFwWmVaaVd1N2ZOMS9BTW1lQjl4SVlRWkh2?=
 =?utf-8?B?cld4MExQWjhicUhra3Q2ZUJYZXo5YVkvK0hFZjBrcTdXeDZBWkJXL25kZDBr?=
 =?utf-8?B?UXJQWVBrMWFjSk03M3pnWk9YNVcwdXR5U1BBUXBoRXBPVGUzd0lkejU0ckRD?=
 =?utf-8?B?UXRnZmJldUV0N0tTUlJzR2V3aTZ4VXJBemRtSFFhaHNFVjRKRm1jS2NBSDE5?=
 =?utf-8?B?V3FvUGgwRE1CMFptMWx3YlNORkxmSXB3YjRSYmNsa0k5SlNvSlN1SXJGMlhN?=
 =?utf-8?B?ME5IV0lHa3pETmZrTjNkL0UwdGo4ckMrWStMMEFSRkR3d0hkVjI5Q2g4U2kx?=
 =?utf-8?B?cElIM2M0UWdleWZ4Qno4L0F5NFFScklSaEJvU3lGWElUbDEyTnNoYzM5K1pP?=
 =?utf-8?B?YzRnL1JWRUZaRWZ3L0Z2aEQxdG5GZ0c0T1p5aGZEZW1PQ1dtY2dhbHFHLzlD?=
 =?utf-8?B?N0tzeE5sMGkvZTJ1VXRxSnpSdlRaM2I3b2dtNGhvL3ltaURPaEF5WDB6RC9v?=
 =?utf-8?B?Qm9qanJQV2RVd0w5MXhoUVlVeVhrai8vZEw5NUliYkF2aVBEdHBoR1pWaVlY?=
 =?utf-8?B?RktzTWFKUnRWeGYvcjNrTkl3OUQ2blF3RFloQW82Vmgxak1KRWN1bk1HSWNx?=
 =?utf-8?B?SXN1OWdva3ErSlFuUWhuUXl3bzlxWGRiZnAxaUxtU3dSQTZkMHJVYXZsZ2Jt?=
 =?utf-8?B?RkN1QXRCR0NYV0NoaUNtTlNXQkdBa0sxVGRySlhMOFBEdFF5aUxnM0VLOHNs?=
 =?utf-8?B?T1hWR0VrampMR29CeGVFb0J4ZzNJcFB6U1VPWWFpeTFZNnVpUVRLc1g5Uzdu?=
 =?utf-8?B?SzRvZjNFbHJmYkZjTVBHOXV6NEpWa1U3RktFcWkrVklsL0JZRVQ2S1UvTWZS?=
 =?utf-8?B?OGJBRUlLYVIwUi9IbDkwZTZoaHVXcG5KTERyMFFaYW1ncnl0bWlkbG0rTy9B?=
 =?utf-8?B?M3VsZXZQbWlUa210eEV6Tm5MYXhmRXRoajlJS2R2dWxPUEs0amxzcy96dmsy?=
 =?utf-8?B?Z1ZzMk0zY3pNamNlV3o2U0JmVnh2ZzZtUHZiZ3JpdXhTbXlILys2TzU4aXpJ?=
 =?utf-8?B?QmRSN2RoaVZLTmpkcFIzT0FaL1FDM2p5dFJ6MlBEQjhiVTg1ZkUwUW0ySVoy?=
 =?utf-8?B?TTdrSTluV2hFZnNXNk1zNGhvWUduN1pDWDJwYmk0aXpHbnpDL2ZucFBjM0JO?=
 =?utf-8?B?OTV0eU9pM0NISWVYYjNsRmQvT1ArZU41WVZrM2t2bnN3U1FqRXo1c2xZT2lr?=
 =?utf-8?B?QzRPYXdqMWUvTEdUZTQvNUhQZUdTYURJc0g3NDdYdVpMUmNkUlpHREo2OXc5?=
 =?utf-8?B?aUFETnVzTDEwbXBvQTR4WWNrY01jR1krWFVXWGhTcWQrK1R3MGRyNCtkbHcr?=
 =?utf-8?B?RmpFbUwxZGF3VFJvT2FGcE1ndHRjbzFrU2c5Qk1vV3Z6QWNkaC8rWTJZeHd0?=
 =?utf-8?B?R3krY2U3VUtUb3UwemVlVURjWXYrVkdhMHZvbWpabUV2bndtODR4VFA5bDBh?=
 =?utf-8?B?NDlIdnlENDUwaVhTUEpoNHZLcUJUUXYvWHV0UVJoUlpiRWtxNTJIZnZqM0lR?=
 =?utf-8?B?Nk43aW1Pa243czZaSysvaUdFVzdmVDd1N1hZbHRRU0VrRVA1QVNEKzFGSktt?=
 =?utf-8?B?WGc1bTNOdU9uQ25VWDhtSjRxaHdaU0F5ZURXbUJoU2d4ZWQzQ244MlVzMy9j?=
 =?utf-8?B?dnVzcExpeUNHQlhNN2ZkQnJKVms5bFUwU1kzamNhU0FiUWxDNEJsQjhUZWZJ?=
 =?utf-8?B?cUxnSXEwcGdxa01hZ0MvdzN2bkZWYkNzTW9KajB1RVM2aURuQ0FjSC9lYnAr?=
 =?utf-8?B?RUQzTkJPU1VtWFRJdjVMaDBxc0g4cndkd2h6dk9VRzZVd2VuUC9XOGtHU2hG?=
 =?utf-8?B?cDlsamYwOTh1bEpOd1I3NnY2RDB1VXRYT3paRUxPMXh0YTEvc0xNanJrWnkx?=
 =?utf-8?B?c2xvTXpDSUpBZ1dRR1AyV1c4TFl1eDBnUGY3VTJEMUVzNjRPa3pPUEtLOW9o?=
 =?utf-8?B?ZmhkTzhZRGwrLytsTHR2Rk9QbGZpVVlnSS9xU3p5RHlzTnczVWN1V2xSQ2FE?=
 =?utf-8?B?eDYvNTE4NU9TdTloMjJ4cDdPYkRKN25uM0ZJSWw0dUJkdEJJelhhK3NkYWQ1?=
 =?utf-8?B?bTFVS2hTU3lQeFR5SU5uNHFrcy9VUmFpVFV5OG14MkFycUZ3ckRldz09?=
X-OriginatorOrg: nwra.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 879da23b-b628-4f3e-c8c6-08da43ea3700
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR09MB6318.namprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 16:17:25.1490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 761303a3-2ec2-424e-8122-be8b689b4996
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR09MB8160
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--------------ms020203010605020305050001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

We're using multiuser automounted cifs mounts.  Generally works fine, but
sometimes a user looses access:

$ klist
Ticket cache: KEYRING:persistent:XXXX:krb_ccache_pPI2o2r
Default principal: user@REALM

Valid starting       Expires              Service principal
06/01/2022 08:53:25  06/01/2022 18:08:51  cifs/server@REALM
        renew until 06/07/2022 17:49:23
06/01/2022 08:08:51  06/01/2022 18:08:51  krbtgt/REALM@REALM
        renew until 06/07/2022 17:49:23

$ ls -la /nwra/monterey/csp/
ls: cannot access '/nwra/monterey/csp/': Permission denied

mount shows:

//SERVER/csp on /nwra/monterey/csp type cifs
(rw,relatime,vers=3.1.1,sec=krb5,cruid=XXXX,cache=strict,multiuser,uid=0,noforceuid,gid=0,noforcegid,addr=XXXX,file_mode=0755,dir_mode=0755,soft,nounix,serverino,mapposix,noperm,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=60,actimeo=15)

The cruid is the id of the user without access.  Another user of the system
does have access.

Fedora 34 - 5.17.5-100.fc34.x86_64

If the directory unmounts and gets remounted then access is restored.

Any idea what to test and how to debug?

Thanks!

-- 
Orion Poplawski
IT Systems Manager                         720-772-5637
NWRA, Boulder/CoRA Office             FAX: 303-415-9702
3380 Mitchell Lane                       orion@nwra.com
Boulder, CO 80301                 https://www.nwra.com/

--------------ms020203010605020305050001
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
CmMwggUVMIID/aADAgECAhEArxwEsqyM/5sAAAAAUc4Y4zANBgkqhkiG9w0BAQsFADCBtDEU
MBIGA1UEChMLRW50cnVzdC5uZXQxQDA+BgNVBAsUN3d3dy5lbnRydXN0Lm5ldC9DUFNfMjA0
OCBpbmNvcnAuIGJ5IHJlZi4gKGxpbWl0cyBsaWFiLikxJTAjBgNVBAsTHChjKSAxOTk5IEVu
dHJ1c3QubmV0IExpbWl0ZWQxMzAxBgNVBAMTKkVudHJ1c3QubmV0IENlcnRpZmljYXRpb24g
QXV0aG9yaXR5ICgyMDQ4KTAeFw0yMDA3MjkxNTQ4MzBaFw0yOTA2MjkxNjE4MzBaMIGlMQsw
CQYDVQQGEwJVUzEWMBQGA1UEChMNRW50cnVzdCwgSW5jLjE5MDcGA1UECxMwd3d3LmVudHJ1
c3QubmV0L0NQUyBpcyBpbmNvcnBvcmF0ZWQgYnkgcmVmZXJlbmNlMR8wHQYDVQQLExYoYykg
MjAxMCBFbnRydXN0LCBJbmMuMSIwIAYDVQQDExlFbnRydXN0IENsYXNzIDIgQ2xpZW50IENB
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxDKNQtCeGZ1bkFoQTLUQACG5B0je
rm6A1v8UUAboda9rRo7npU+tw4yw+nvgGZH98GOtcUnzqBwfqzQZIE5LVOkAk75wCDHeiVOs
V7wk7yqPQtT36pUlXRR20s2nEvobsrRcYUC9X91Xm0RV2MWJGTxlPbno1KUtwizT6oMxogg8
XlmuEi4qCoxe87MxrgqtfuywSQn8py4iHmhkNJ0W46Y9AzFAFveU9ksZNMmX5iKcSN5koIML
WAWYxCJGiQX9o772SUxhAxak+AqZHOLAxn5pAjJXkAOvAJShudzOr+/0fBjOMAvKh/jVXx9Z
UdiLC7k4xljCU3zaJtTb8r2QzQIDAQABo4IBLTCCASkwDgYDVR0PAQH/BAQDAgGGMB0GA1Ud
JQQWMBQGCCsGAQUFBwMEBggrBgEFBQcDAjASBgNVHRMBAf8ECDAGAQH/AgEAMDMGCCsGAQUF
BwEBBCcwJTAjBggrBgEFBQcwAYYXaHR0cDovL29jc3AuZW50cnVzdC5uZXQwMgYDVR0fBCsw
KTAnoCWgI4YhaHR0cDovL2NybC5lbnRydXN0Lm5ldC8yMDQ4Y2EuY3JsMDsGA1UdIAQ0MDIw
MAYEVR0gADAoMCYGCCsGAQUFBwIBFhpodHRwOi8vd3d3LmVudHJ1c3QubmV0L3JwYTAdBgNV
HQ4EFgQUCZGluunyLip1381+/nfK8t5rmyQwHwYDVR0jBBgwFoAUVeSB0RGAvtiJuQijMfmh
JAkWuXAwDQYJKoZIhvcNAQELBQADggEBAD+96RB180Kn0WyBJqFGIFcSJBVasgwIf91HuT9C
k6QKr0wR7sxrMPS0LITeCheQ+Xg0rq4mRXYFNSSDwJNzmU+lcnFjtAmIEctsbu+UldVJN8+h
APANSxRRRvRocbL+YKE3DyX87yBaM8aph8nqUvbXaUiWzlrPEJv2twHDOiGlyEPAhJ0D+MU0
CIfLiwqDXKojK+n/uN6nSQ5tMhWBMMgn9MD+zxp1zIe7uhGhgmVQBZ/zRZKHoEW4Gedf+EYK
W8zYXWsWkUwVlWrj5PzeBnT2bFTdxCXwaRbW6g4/Wb4BYvlgnx1AszH3EJwv+YpEZthgAk4x
ELH2l47+IIO9TUowggVGMIIELqADAgECAhEAyiICIp1F+xAAAAAATDn2WDANBgkqhkiG9w0B
AQsFADCBpTELMAkGA1UEBhMCVVMxFjAUBgNVBAoTDUVudHJ1c3QsIEluYy4xOTA3BgNVBAsT
MHd3dy5lbnRydXN0Lm5ldC9DUFMgaXMgaW5jb3Jwb3JhdGVkIGJ5IHJlZmVyZW5jZTEfMB0G
A1UECxMWKGMpIDIwMTAgRW50cnVzdCwgSW5jLjEiMCAGA1UEAxMZRW50cnVzdCBDbGFzcyAy
IENsaWVudCBDQTAeFw0yMDEyMTQyMDQzMDlaFw0yMzEyMTUyMTEzMDhaMIGTMQswCQYDVQQG
EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEmMCQGA1UEChMd
Tm9ydGhXZXN0IFJlc2VhcmNoIEFzc29jaWF0ZXMxNTAWBgNVBAMTD09yaW9uIFBvcGxhd3Nr
aTAbBgkqhkiG9w0BCQEWDm9yaW9uQG53cmEuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAxBJrIv9eGtrQLaU9pIGsIGBTiW0vZIYmz+5Eoa69sj6t6QANvg0IuVgWZajH
2fu8R+7m/AbZ8Wsuzz+ovtDHiVqUGvGzYyN9a5Ssx94SwNp9zLPfdCRMdh3zJB7gc4GYE/fA
kMkieO8u05f/hSyf9zU5gpjl7SW6p8IjkoyxNOr7KCbI4CQ3+1LG8pn6tz/QJwQ/BJZa4dE0
asXfNlZf5kZtyWtJhwub76zH5uXeODDxY3RooWj1l4V2fQCoFX2ov1ENUW4hRov1cMAD2QHJ
KL0Boir36wISvzq8Z65MSMCGNRiWwRaclVwVZ+QYnlhGZ0g6tMvxVrK+sHnxxr/LOwIDAQAB
o4IBfzCCAXswDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcD
BDBCBgNVHSAEOzA5MDcGC2CGSAGG+mwKAQQCMCgwJgYIKwYBBQUHAgEWGmh0dHA6Ly93d3cu
ZW50cnVzdC5uZXQvcnBhMGoGCCsGAQUFBwEBBF4wXDAjBggrBgEFBQcwAYYXaHR0cDovL29j
c3AuZW50cnVzdC5uZXQwNQYIKwYBBQUHMAKGKWh0dHA6Ly9haWEuZW50cnVzdC5uZXQvMjA0
OGNsYXNzMnNoYTIuY2VyMDQGA1UdHwQtMCswKaAnoCWGI2h0dHA6Ly9jcmwuZW50cnVzdC5u
ZXQvY2xhc3MyY2EuY3JsMBkGA1UdEQQSMBCBDm9yaW9uQG53cmEuY29tMB8GA1UdIwQYMBaA
FAmRpbrp8i4qdd/Nfv53yvLea5skMB0GA1UdDgQWBBSpChQTknhqMfb9Exia9G14q4j9ZzAJ
BgNVHRMEAjAAMA0GCSqGSIb3DQEBCwUAA4IBAQA15stihwBRGI8nFvZZalsmOHR954D+vrOZ
7cC0kl9K+S9u8j/E5nZd+A6PTKoDpAEYmPUYpe45tZLblnvfJC0yovSIIMTo1z3mRzldHYAt
ttjShH+M6s3xrqDtHfNAwt3TCf6H83sEpBi6wtbALfkIjKuDitgkdZsyUURoeglaaqVRhi2L
5wOOChQAyfsumjT1Gzk9qRtiv8aXzWiLeVKhzRO7a6o0jSdg1skyYKx3SPbIU4po/aT2Ph7V
niN0oqJHI11Fg6BfAey12aj5Uy96ztotiZRQuhWZPOc4d3df2N8RsdWViBp4jXt2hQjNr0Kw
pUPWRO/PENBVS1Uo1oXfMYIEYjCCBF4CAQEwgbswgaUxCzAJBgNVBAYTAlVTMRYwFAYDVQQK
Ew1FbnRydXN0LCBJbmMuMTkwNwYDVQQLEzB3d3cuZW50cnVzdC5uZXQvQ1BTIGlzIGluY29y
cG9yYXRlZCBieSByZWZlcmVuY2UxHzAdBgNVBAsTFihjKSAyMDEwIEVudHJ1c3QsIEluYy4x
IjAgBgNVBAMTGUVudHJ1c3QgQ2xhc3MgMiBDbGllbnQgQ0ECEQDKIgIinUX7EAAAAABMOfZY
MA0GCWCGSAFlAwQCAQUAoIICdzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3
DQEJBTEPFw0yMjA2MDExNjE3MjFaMC8GCSqGSIb3DQEJBDEiBCD+1rKOdRfqPG6fAhY0ywUm
WNQWAcIsDZ5IRYYoE6rhHzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsO
AwIHMA0GCCqGSIb3DQMCAgEoMIHMBgkrBgEEAYI3EAQxgb4wgbswgaUxCzAJBgNVBAYTAlVT
MRYwFAYDVQQKEw1FbnRydXN0LCBJbmMuMTkwNwYDVQQLEzB3d3cuZW50cnVzdC5uZXQvQ1BT
IGlzIGluY29ycG9yYXRlZCBieSByZWZlcmVuY2UxHzAdBgNVBAsTFihjKSAyMDEwIEVudHJ1
c3QsIEluYy4xIjAgBgNVBAMTGUVudHJ1c3QgQ2xhc3MgMiBDbGllbnQgQ0ECEQDKIgIinUX7
EAAAAABMOfZYMIHOBgsqhkiG9w0BCRACCzGBvqCBuzCBpTELMAkGA1UEBhMCVVMxFjAUBgNV
BAoTDUVudHJ1c3QsIEluYy4xOTA3BgNVBAsTMHd3dy5lbnRydXN0Lm5ldC9DUFMgaXMgaW5j
b3Jwb3JhdGVkIGJ5IHJlZmVyZW5jZTEfMB0GA1UECxMWKGMpIDIwMTAgRW50cnVzdCwgSW5j
LjEiMCAGA1UEAxMZRW50cnVzdCBDbGFzcyAyIENsaWVudCBDQQIRAMoiAiKdRfsQAAAAAEw5
9lgwDQYJKoZIhvcNAQEBBQAEggEAQXI6i01iMeoYmsfoZshwvXARNLdaO9Y3u4pqhNWnfzvh
J0zvFdXPt0h9yZbhEEh8WnZ8Dhk2nzcIj31G9XE7+nDfG1CUB2CbpVDywORDN6j71GuzxTit
vWDnEVPyoNcHcnZ+lbFVzLbpispwo8r3S0Jp7CJlqwob33A2XtRmzcxKzq7gLV2zgJkwUA/g
lnDsMTFgeEbBTPjs6GcQNVwbXSk8H0n/XgaXiyHk8LObM00TOlRyvWaPw+95AhaMku++MWH3
yRjVx9O/ZsAF7jgwjhwU7ecxRwL2AtqfD7mNBq9jZWSy0aw33cc1cV/sennYOdGEo09ACS2C
C8pPvt2t5QAAAAAAAA==

--------------ms020203010605020305050001--
