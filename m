Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F94C38145
	for <linux-cifs@archiver.kernel.org>; Sat,  3 Sep 2022 02:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiICCLr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Sep 2022 22:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiICCLq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 2 Sep 2022 22:11:46 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020021.outbound.protection.outlook.com [52.101.61.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BC6E1935
        for <linux-cifs@vger.kernel.org>; Fri,  2 Sep 2022 19:11:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PmltJVnna9Y80doyBC858lh1twjnDZ8aCsg4pw+vbGULYBTowS2/I/8crP6RLLz6amRaPEnYwlFkuM8kCGxc8qG7TGMahWHeaHMbz/ZXKZRonT2XNZneUIf4yVTxHNgLSVYia6QOSYoF6E0SMoFhNvMGEPdw0vOIVuAl2UWcmTuPcuorftztmW8lFi5wNLa7Z9IEPqB3dHVPdFickhxGNH2/7LL30M1oTrENZSPV6w5yLhs5OdwCQSm7RrdxFbpH/FxVAVaiPSXSYVDeXtxnSbuxChBalb2vQkLciOnGTLa70zU+AP2qwIrmSB5ijmdxCVJXLzjPJzoYoeiJuDgoIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2NYgRT7iseVJNpmTbm9dTKQez35uJDrzVj6IDO3JXQo=;
 b=iiuYObbG41DelTsletFC+N3JQk4OmrDC3F2mwRgc6Z/vsmEqV3y6KwGP+CNs2BMNS9h7R9BkJKtYXiCwFV9g3mKm+JcZv4wcZcKMXfC6rW/s1WJTd60nq6Kic5nBxUMDz/esxTvUNTVW9EhJXk01AVE2tHhecty2EVvip/ba5+okbdi6RWL4sL/XXwTLtIyyAhpnDB3azpHa7s93nWVH5hH2lYQ3Red5DD1a74OeJ+2jWuK7pBxPkY3kJ+FIa9ota30Ed6P3UGn0TBMql3OmnGdNHvTwh9iYS3DGjYlYEMsMPVRXIwBjmqmaragQ+6+uzMM8+wtWKegYS9DtG1uDRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2NYgRT7iseVJNpmTbm9dTKQez35uJDrzVj6IDO3JXQo=;
 b=HWO5moHLgYuyLbJz3m3jKpwHvjdGYUHe+kThN+CQ6E5QyBinQzCeaE/iwXvqPnKz13kLErCFF7bGVbDMGQmrOriNn4uMompj/4Vpg75khqY8qiihgKqMqw4nkYpQh9qvGOmwntVmw1VpIYW+wvqTzSQrhnoIfPpKHkXgBeRP8FI=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by DM4PR21MB3419.namprd21.prod.outlook.com (2603:10b6:8:ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.5; Sat, 3 Sep
 2022 02:11:42 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::c42c:5004:23c1:bcac]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::c42c:5004:23c1:bcac%8]) with mapi id 15.20.5612.006; Sat, 3 Sep 2022
 02:11:42 +0000
From:   Long Li <longli@microsoft.com>
To:     tom <tom@talpey.com>
CC:     CIFS <linux-cifs@vger.kernel.org>
Subject: RE: smbd_max_receive_size == 8192?
Thread-Topic: smbd_max_receive_size == 8192?
Thread-Index: AQHYt9Bpd9xiHKZglka8MbFRg1Ixsa3ITHwAgAS2JxA=
Date:   Sat, 3 Sep 2022 02:11:41 +0000
Message-ID: <PH7PR21MB326340D5131AD6CAAD6100DCCE7D9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <4a349c98-0359-acc9-0d6f-0ccac6f53377@talpey.com>
 <54374c8c-4a16-1c18-a295-c5ea229e67ea@talpey.com>
In-Reply-To: <54374c8c-4a16-1c18-a295-c5ea229e67ea@talpey.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=26bfd823-2673-4ae4-91aa-a3b81985700f;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-03T02:01:51Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|DM4PR21MB3419:EE_
x-ms-office365-filtering-correlation-id: 9e0544f9-6805-4c2c-89d3-08da8d51a49b
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ffDhyjl9yok+9XOoMZwuAkiFkirB7VrZdj8NApga4+JzFOHhZB92jgwi0YzDu//HzUeNhposmtx7+8zzzpES7Z3Iu+bWr3GX5TN8pVnWctXz1L3jDLNVhdg9DtJ4gjpL+9YAUwaH87aFDROKZU/supGNGoVXCJxCF3gbXsfx2QWUayi8xjU/nTg3AbFSd8WoB+nTayIFZ/fvmpy1VpHBmrKYVw0fF4jQ/gAs4lkLeKwWkvK226xSu1XCUCPPE1JMBuZdSIlafHmC4W59uPS3oPec96RGyGiqnRBMfgfERYv0ZJNkkeIYKhJwcXPHUM2WHwlMONIdT1uD8bQsgagxbG7dC6NqD+oaAeyyXcy04C8hxCxGbmIv2U+9gkFlSP4xzDn4NDR4Cdu+pbUNW/zfVjEXTAZeQT7uk9s/L9IynDtcjjaSN3pNg9yx6ZKPC0C7zfyskM9ozd9vwxPNm8O5lCfKPwclEoJ+8RGPWtHf6+YCcxhRQpIVr1CUtY/dMKj1c3yLBV8MU2efWn2fEhbIf1nfuD4waPtGLnWUUDPBDai8afYulX16aGUr/ccGmlcfwDAooRS7ynEKoWKlIns4jAGZ3I885SOP4nHA4JXvVQD+/Hdh2t/BzUrt9XYu/61FhpAwmojIJXyYSCVnVnnMlpAs+QFLQdluQnGXFTPtfsvKZH7Epj/ChmwyVm952CnyGr6thHYTVOJYLxalJODEvlXB75TuhGLGKj2l5vsQdyx0zRskUshyYmjp6WXo/XzyzYl6OdJDO2pUUcLeIINuSz3GTF7dJSGsOQG2fWVHCVQXtsCcJNLu2R30GwL4Mhu7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199009)(9686003)(478600001)(76116006)(64756008)(66476007)(4326008)(66446008)(66946007)(8676002)(66556008)(122000001)(316002)(6916009)(10290500003)(38070700005)(53546011)(38100700002)(7696005)(6506007)(82950400001)(2906002)(71200400001)(186003)(55016003)(8990500004)(82960400001)(86362001)(33656002)(41300700001)(8936002)(83380400001)(5660300002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2UzMnJCT09Yam9ITE1IRDJ4UnI5M0VzcEZSRjFQVytzZS9JYXZWWndlNVVS?=
 =?utf-8?B?a1V5LzQ0NlFTU1E0RGZqOTBNTTB5NTJOQngyNXpMaS9icFdKRHlTcWE2Z1NE?=
 =?utf-8?B?TjhiN2xUSjQ4UzZJN3VZbmVMVVh1bWtheFh6WHA4WDZrQnRBKzQxOHZ2R0J3?=
 =?utf-8?B?Y2pxa2hsVms0V1JobkdOenU5emRmYktBek04ZTVxZUk4RXhvb2NSZ2QwKzdG?=
 =?utf-8?B?THJKbEVmVHN6eTdNV3Z1d2ZvVk1mZWtoSEhNV0VSV3p2MWxISklRMXd4Ymht?=
 =?utf-8?B?N2NlSjZUbmxFQ0pHdTIwOWJRUFdKN1FXbXZTVlYwTXpwczNyYW0zdHZJS21P?=
 =?utf-8?B?MWREYzBmcXB5UWNhN09KNmdpeXprNU1kMjdYdFZ1TUFWaGM3ZTNsdmdKVXFG?=
 =?utf-8?B?Z2xSY2FoQ3RSRWpUQTdQVDVBV3YxSXdkbnYvdWlHRWJvZVQ4alB1NndNVG5s?=
 =?utf-8?B?Wm1xdUtJRGt5bG10VjdqWmZxOHI1dlUzeCtjMStzcURnMUdYWVZFVU90Tlhq?=
 =?utf-8?B?Um53ckxOZXZmNUU1ZzlhUkMzaENDODBsR2pQQ3ZXUzVSKythVnliS1E5TzRZ?=
 =?utf-8?B?RTBrWE1vc2Fyai9STkJ6WWJ2NDh3OEw4citMY3p2Z2MzQnpqUUozZTI0eWhz?=
 =?utf-8?B?SGIyTDJISDVOaCt0cHY0alpyUm11dFFWRmY3c2g2eVp1T0p6T2J3eUVHeGZi?=
 =?utf-8?B?UzB3WjFvS3JRUWZHSkZ2cXpScWZCS3dRdXZmRjZJZlFQYlV4MUdDdVE2YzBG?=
 =?utf-8?B?ZitGMDJaYXpwTTlBWDJKWkRPdVNSdnNMTG9PWFV1dE1UQzBjb0lBOGlzSU9n?=
 =?utf-8?B?NGpkK2dhajRsTlI0eXBOR1hQUFpLOS9Ldzk4a3RFekFOUkdHQTkzSkFSWXFw?=
 =?utf-8?B?SUswZ2FPTlZCaWIxbWJ2bG9LQzRDQTRUSVFNOEd0a0poS3AvNlZvWFhjUDh4?=
 =?utf-8?B?dDdPWFNocFFWdVorcE45ZWRiVmZKT0lXQjZabFFkMHJ2bXFJaTdZZ2ZQZzN4?=
 =?utf-8?B?RVNUYWVYWGUxYmFtM21sRk5jMlJvem9neFFmMnphZ1ZGY2htaHpVclBVSldS?=
 =?utf-8?B?ZjRzcldkU3lRWG5sY1FIVmNuSW1ncEp5M1JnRUc4ZDdtU1B1TmtpNjNjTVZY?=
 =?utf-8?B?RUZhUVZxamljcjhxaS9iOWtmVDZLUlM0T3VSQVhwM29VTVUraCtxN2NlcWNL?=
 =?utf-8?B?ZGZvd3JpQ05aOTg5Z3B1S0dGclBrbjBEY25jUTFocTNRNHhpSGRodVBJc3hZ?=
 =?utf-8?B?QnJNSHdFMk94S2ljcVNmdUdzZWRsNWJVZ2FXSW96K0dkTXpMdnVlckh6eG5i?=
 =?utf-8?B?M3QxSnluWXZFZ0ltczJYdDNPWXlZUkdkaVpYaTM0bUhEdmJobVBpOEVSRDFh?=
 =?utf-8?B?bkJiMFIwNGZWQnBvQUlvUEwzbFNlYi9xcEljRlRmYzJmNk13WU41QlV5eXc1?=
 =?utf-8?B?RnZxQi9LVEF1OUM3M1N2b0ZTYVRFRTZHNkxsOWhkdFdvYzRXY1ExVUtvQjJD?=
 =?utf-8?B?dW9MQktxK3B5K1BWd2VtK0tMa2tBdlE4SENvVnhSUFlUd3gydkluUDBhUEph?=
 =?utf-8?B?WWF1OVVlYkx6MnJ3Uk5nMktwWm52MTE1YVIzNlgxNnUvcWRQaG1VWk42N05W?=
 =?utf-8?B?VTlJeDVxUGVFQXdMTDhla01BbVhkWnUvM3prOVc4QTdhWFd3REJhR2JCd25K?=
 =?utf-8?B?am13Z2FSbENXczdnSG94blJwU3NpbnJSMWN6ZW5ReFJsaWwrYTZUcE03K3p2?=
 =?utf-8?B?NWtqUkw4SmE1RCt5QWVISitEWTdTM0I3K2R0ZHJqNGM5SngyNzRaZ1NkcUpZ?=
 =?utf-8?B?cG9tOFM1bmVkSldBOFMzalpwb1BNRXdjLzBFRFlzelRySjF5N2s1dlNDYkRG?=
 =?utf-8?B?d0Q3TjcrRHZJWDFsMGtaMnlkdUxMcVlCaEg0d3VFM2NGWDh3ZXZ3RTFiQTZH?=
 =?utf-8?B?NVUxcEpjTWNyM2IwUE90YWJ2azR5eDM5K09UZlZvdUVLamNJVnVOUm9KQXNM?=
 =?utf-8?B?L1B5MXFSTkhwOWVmUDV1UGJOc01tM1V1M0tsbzNUVkxQc0h0UitYYUpXNkNl?=
 =?utf-8?B?WitxaG1WdXNZS2xJSGlndkRpTm1GSDVFcUFtam5wSnhZcDZnRitvWXNOZXFz?=
 =?utf-8?B?emk2MXVabU1WemRzeHFpZVVYK05xS3ZyaGhMcDJEWnJuRWxCL1JlZ1Z6em9m?=
 =?utf-8?Q?UZQKGVTXO9gPOcFf1NPIi0I/waJwWspHSTMctC8iq12U?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3419
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

PiBTdWJqZWN0OiBSZTogc21iZF9tYXhfcmVjZWl2ZV9zaXplID09IDgxOTI/DQo+IA0KPiAuLi5w
aW5nPw0KPiANCj4gSSBoYXZlIHNpbmNlIG5vdGljZWQgdGhhdCB0aGUgc21iZGlyZWN0IGRlZmF1
bHQgbWF4IHNlbmQgc2l6ZSBpcyAxMzY0LCBzbyBJJ20NCj4gZXZlbiBtb3JlIGNvbmZ1c2VkIG9u
IHRoZSA4MTkyLiBBbmQsIGtzbWJkIHNldHMgYm90aCBzaXplcyB0byA4MTkyLg0KDQpZZXMsIGl0
IHNlZW1zIGl0IGNhbiBiZSByZWR1Y2VkIHRvIGEgc21hbGxlciB2YWx1ZS4gSSBkb24ndCByZW1l
bWJlciB0aGUgcmVhc29uIHdoeSBpdCB3YXMgc2V0IHRvIDgxOTIgaW5pdGlhbGx5Lg0KDQpUaGlz
IHZhbHVlIGlzIGZ1cnRoZXIgb3ZlcnJpZGUgYnkgdGhlIHByZWZlcnJlZF9zZW5kX3NpemUgaW4g
U01CRCBuZWdvdGlhdGlvbiByZXNwb25zZSBmcm9tIHRoZSBzZXJ2ZXIuIEluIHByYWN0aWNlLCBp
dCBjb3VsZCBiZSBtdWNoIGxvd2VyIHRoYW4gODE5Mi4NCg0KPiANCj4gT24gOC8yNC8yMDIyIDEx
OjQ0IEFNLCBUb20gVGFscGV5IHdyb3RlOg0KPiA+IExvbmcsIEkgbm90aWNlIHRoYXQgc21iZGly
ZWN0LmMgc2V0cyB0aGUgbWF4IHJlY2VpdmUgc2l6ZSB0byA4MTkyLg0KPiA+IEl0J3MgdHVuYWJs
ZSwgYnV0IEknbSBjdXJpb3VzIHdoeSB0aGUgZGVmYXVsdCBpcyBzbyBsYXJnZS4gVGhlDQo+ID4g
U01CRGlyZWN0IHByb3RvY29sIG5vcm1hbGx5IGxpbWl0cyBpdHMgcGFja2V0cyB0byAxMzY0IGJ5
dGVzLg0KPiA+DQo+ID4gV2l0aCBhbiBTTUJEaXJlY3QgY3JlZGl0IGxpbWl0IG9mIDI1NSwgdGhl
IHByZXNlbnQgZGVmYXVsdCBhbGxvY2F0ZXMNCj4gPiBvdmVyIDUwMCBwYWdlcy9jb25uZWN0aW9u
LCBpbiBPKDIpIGdyYW51bGFyaXR5LCB3aGVuIDg1IE8oMSkgcGFnZXMNCj4gPiB3b3VsZCBzdWZm
aWNlLiBLZXJuZWwgdmlydHVhbCBtYXBwaW5nIHdvdWxkIGFsc28gYmUgZ3JlYXRseSByZWR1Y2Vk
IGFzDQo+ID4gYnVmZmVycyBjYW4gYmUgYXJyYW5nZWQgdG8gc2hhcmUsIGFuZCBuZXZlciBleHRl
bmQgYmV5b25kLCBhIHBhZ2UuDQo+ID4NCj4gPiBBbnkgaW5zaWdodCBpbnRvIHRoZSA4MTkyPyBU
aGFua3MuDQo+ID4NCj4gPiBUb20uDQo+ID4NCg==
