Return-Path: <SRS0=fxvP=RX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E1DC43381
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Mar 2019 13:52:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 702E021850
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Mar 2019 13:52:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="CN5B1qls"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfCTNwQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Mar 2019 09:52:16 -0400
Received: from mail-eopbgr680104.outbound.protection.outlook.com ([40.107.68.104]:38720
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726239AbfCTNwP (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 20 Mar 2019 09:52:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w5RgDSLCOir+g1Qbp1Vz4KMMppJ6awwuwZdomZkcchM=;
 b=CN5B1qlsI7m8NBkxqtVD6INAjKZGqWJiFqUWRI/1S9QdtgpMeS4esocUiG78wH/OSiYXSylWnSvNyFOy7xDz0hHGMlLakNxRPz1vkERd3NaLxGo7Mn/DM4wTExb9wVEJpkPGN8Q+WoeFeFg0+0n+UJ9r2h22hWzcH1FGYfZB45U=
Received: from SN4PR2101MB0736.namprd21.prod.outlook.com (10.167.151.155) by
 SN4PR2101MB0815.namprd21.prod.outlook.com (10.167.151.157) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.7; Wed, 20 Mar 2019 13:52:11 +0000
Received: from SN4PR2101MB0736.namprd21.prod.outlook.com
 ([fe80::804d:6cd0:c000:791c]) by SN4PR2101MB0736.namprd21.prod.outlook.com
 ([fe80::804d:6cd0:c000:791c%3]) with mapi id 15.20.1750.005; Wed, 20 Mar 2019
 13:52:11 +0000
From:   Tom Talpey <ttalpey@microsoft.com>
To:     =?utf-8?B?QXVyw6lsaWVuIEFwdGVs?= <aaptel@samba.org>,
        Stefan Metzmacher <metze@samba.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
CC:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: RE: Buildbot cifs/smb3 testing improvements
Thread-Topic: Buildbot cifs/smb3 testing improvements
Thread-Index: AQHU3sOC4OnwWEzSh0GqHSpasc+0FqYUK5AAgAACMoCAACHogIAAOYZg
Date:   Wed, 20 Mar 2019 13:52:11 +0000
Message-ID: <SN4PR2101MB0736DEDE79137997EC1B63DEA0410@SN4PR2101MB0736.namprd21.prod.outlook.com>
References: <CAH2r5msUqScwN99iUnyEKBYOic4fMCpnjFmc=dfaJJax0XnxdA@mail.gmail.com>
 <CAN05THTHPoTiYOZN55rVaxDhy0U8SmfQ_UJX6CpoDLyjK9edkQ@mail.gmail.com>
 <3915ebdc-50d7-62d4-3433-47df38e78f94@samba.org> <874l7x6e4a.fsf@suse.com>
In-Reply-To: <874l7x6e4a.fsf@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=ttalpey@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-03-20T13:52:09.5532957Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a788c3a6-8d87-4cb7-b4ab-966bc2273684;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
x-originating-ip: [198.214.84.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 229ceee6-2268-4bb7-af25-08d6ad3b4036
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:SN4PR2101MB0815;
x-ms-traffictypediagnostic: SN4PR2101MB0815:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <SN4PR2101MB08159AFACE6D0FA1FB0D07EBA0410@SN4PR2101MB0815.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(366004)(136003)(376002)(346002)(189003)(199004)(13464003)(66574012)(4326008)(10290500003)(6246003)(11346002)(4744005)(71190400001)(6506007)(71200400001)(99286004)(81166006)(256004)(102836004)(8676002)(476003)(53546011)(305945005)(8990500004)(76176011)(446003)(93886005)(229853002)(7736002)(14444005)(74316002)(7696005)(52536014)(81156014)(25786009)(53936002)(86612001)(3846002)(54906003)(6116002)(110136005)(66066001)(97736004)(966005)(6306002)(26005)(478600001)(186003)(316002)(33656002)(55016002)(9686003)(106356001)(2906002)(5660300002)(6346003)(10090500001)(14454004)(68736007)(6436002)(86362001)(8936002)(105586002)(22452003)(486006);DIR:OUT;SFP:1102;SCL:1;SRVR:SN4PR2101MB0815;H:SN4PR2101MB0736.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ttalpey@microsoft.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RXKn2nonMaIK8lioQ1aOU0pdCYuWUiAvzIojRbByJT/8J7ZlscELpGLhSX6Qzx7mFql2q53QOuGCGpVaqclrz8Duz69iSY7yshJmKgcQjDYz9rUywSjP2MTYCpZmOhLD78fDe2BNM+YIwvSgW7S+qtlHMqpBPvTfHKZEfmmsF6azOPfD7h7ygzJsqjKdGoZdP6bBZmJ1kMH6F/LA2Ji3wB+QWfLUA1QjmB0cNHR/DKsJWBKJZHp4wqnYBb2sS5YbMTLT56I4VTKOvPoyfBzktLH1nD4gYaj+/BqgG9vBtAdfD/LwGFDsFbXmoKSdSDUmX0HJ0rMSbTYh3yPYlJE5N84rZU1YKuL3oXERsGl72Uu+UM4m0PhalcYVg+GLj1x5MOVU+BBeyjKLj89y4wgobLkdII0tlHkmFmHI4hf2HHk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 229ceee6-2268-4bb7-af25-08d6ad3b4036
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 13:52:11.0267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR2101MB0815
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jaWZzLW93bmVyQHZn
ZXIua2VybmVsLm9yZyA8bGludXgtY2lmcy1vd25lckB2Z2VyLmtlcm5lbC5vcmc+IE9uDQo+IEJl
aGFsZiBPZiBBdXLDqWxpZW4gQXB0ZWwNCj4gU2VudDogV2VkbmVzZGF5LCBNYXJjaCAyMCwgMjAx
OSA1OjIxIEFNDQo+IFRvOiBTdGVmYW4gTWV0em1hY2hlciA8bWV0emVAc2FtYmEub3JnPjsgcm9u
bmllIHNhaGxiZXJnDQo+IDxyb25uaWVzYWhsYmVyZ0BnbWFpbC5jb20+OyBTdGV2ZSBGcmVuY2gg
PHNtZnJlbmNoQGdtYWlsLmNvbT4NCj4gQ2M6IENJRlMgPGxpbnV4LWNpZnNAdmdlci5rZXJuZWwu
b3JnPjsgc2FtYmEtdGVjaG5pY2FsIDxzYW1iYS0NCj4gdGVjaG5pY2FsQGxpc3RzLnNhbWJhLm9y
Zz4NCj4gU3ViamVjdDogUmU6IEJ1aWxkYm90IGNpZnMvc21iMyB0ZXN0aW5nIGltcHJvdmVtZW50
cw0KPiANCj4gU3RlZmFuIE1ldHptYWNoZXIgPG1ldHplQHNhbWJhLm9yZz4gd3JpdGVzOg0KPiA+
IFNvIGZhciBJIHdhc24ndCBhYmxlIHRvIHVzZSB0aGUgdXBzdHJlYW0gY2lmcy5rbyB3aXRoIHNt
YmRpcmVjdCB3aXRoIGFueQ0KPiA+IGtpbmQgb2YgUkRNQSBkcml2ZXIgYXQgYWxsIGFnYWluc3Qg
V2luZG93cy4NCj4gDQo+IEkndmUgbWFuYWdlZCB0byB0ZXN0IGl0IGxhc3QgeWVhciBvbiBhY3R1
YWwgaGFyZHdhcmUgYWdhaW5zdA0KPiBXaW5kb3dzLiBZb3Ugc2hvdWxkIGFzayBMb25nIExpLCBo
ZSBpcyBzdGlsbCB3b3JraW5nIG9uIGl0Lg0KDQpGWUksIHRoZSBTb2Z0IGlXQVJQIGNvZGUgaXMg
dmVyeSBjbG9zZSB0byBiZWluZyByZWFkeSB0byBnbyB1cHN0cmVhbSwgaXQgbWF5IHByb3ZpZGUg
YW5vdGhlciAoYW5kIGxlc3MgYnVnZ3kpIHRlc3Qgb3Bwb3J0dW5pdHkgdGhhbiBTb2Z0IFJvQ0Uu
IEknbSBhdCB0aGUgT3BlbiBGYWJyaWNzIFdvcmtzaG9wIHJpZ2h0IG5vdyB3aXRoIEJlcm5hcmQg
TWV0emxlciwgdGhlIFNJVyBhdXRob3IsIGFuZCBjYW4gY2hhdCB3aXRoIGhpbSBhbmQgb3RoZXIg
UkRNQSBtYWludGFpbmVycyBhYm91dCB0aGlzLg0KDQpodHRwczovL3d3dy5zcGluaWNzLm5ldC9s
aXN0cy9saW51eC1yZG1hL21zZzc1NzE4Lmh0bWwNCg0KVG9tLg0KDQo=
