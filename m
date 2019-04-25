Return-Path: <SRS0=4Yi2=S3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF2F7C43218
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Apr 2019 16:29:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4971420717
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Apr 2019 16:29:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="mp0HlSDA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbfDYQ3s (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:29:48 -0400
Received: from mail-eopbgr800131.outbound.protection.outlook.com ([40.107.80.131]:6072
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726020AbfDYQ3r (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 25 Apr 2019 12:29:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=xrEQkbwmZPOntY1GIBPgrD9p5DZdnjJPVnHfyw1oT94qisd6AFyO/qwpZByi8EfkB1hmwsxg3WxmpwScaI/ECmn4uFssv4ppQJfNrJM5NzPDmXqau8AopE77YnsmzBYQ/GrDW6RMTH/s6TPj7weSM47uw55uWNivoNIbhSSvrZs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3bDDrqoD4j1PdlBcTn6oosn/AA4/M6MrhcZPmb++y/Y=;
 b=yBifPq2IlzMYx4+/PsZfMwiUm25Xu7BJhkIBKjIDH7EreuOrxCB7Ao9cyLaiy03GaRwl2x7Cb4qbQXw2bHNDB/UhuavhAer+ygAqAziwzsxxZToOoWDWE2WAX2AuDw2TFJXaCI6aPGUeRLfRPk6wdu45Nbq3z2u9+AF78hUJ1Ds=
ARC-Authentication-Results: i=1; test.office365.com 1;spf=none;dmarc=none
 action=none header.from=microsoft.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3bDDrqoD4j1PdlBcTn6oosn/AA4/M6MrhcZPmb++y/Y=;
 b=mp0HlSDATtdcq0WwhoKLaL0pzMRkpHtCTfTRnVD+gs+nlFJzM6cEOosBDGJLCK0Vb+OoOqILwkeOO/Yra5mXn6pv8gsh0DoKeaOanGgW1PsqfddRli3keNRzOB7Tl24LuIHJihr4N/GpJskwsmsfq/kTCoXvQYsrG9XFRxQqx1g=
Received: from BN8PR21MB1186.namprd21.prod.outlook.com (20.179.73.78) by
 BN8PR21MB1233.namprd21.prod.outlook.com (20.179.73.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.1; Thu, 25 Apr 2019 16:29:44 +0000
Received: from BN8PR21MB1186.namprd21.prod.outlook.com
 ([fe80::fd3b:ec19:62af:45a2]) by BN8PR21MB1186.namprd21.prod.outlook.com
 ([fe80::fd3b:ec19:62af:45a2%9]) with mapi id 15.20.1835.000; Thu, 25 Apr 2019
 16:29:44 +0000
From:   Tom Talpey <ttalpey@microsoft.com>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Subject: RE: SMB2 SET_ZERO_DATA and PUNCH_HOLE
Thread-Topic: SMB2 SET_ZERO_DATA and PUNCH_HOLE
Thread-Index: AQHU+zfkS8oaY+xehUCwun9z6GB/kqZND12w
Date:   Thu, 25 Apr 2019 16:29:44 +0000
Message-ID: <BN8PR21MB1186AD53D79EFCD404B82E14A03D0@BN8PR21MB1186.namprd21.prod.outlook.com>
References: <CAN05THSthhyGctyByj5eun6C_KK58xWgNYer+7TKBrqyObNZsw@mail.gmail.com>
In-Reply-To: <CAN05THSthhyGctyByj5eun6C_KK58xWgNYer+7TKBrqyObNZsw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=ttalpey@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-04-25T16:29:43.0788250Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a14364e9-c27f-4dcc-847b-557f0fea266c;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ttalpey@microsoft.com; 
x-originating-ip: [2601:18f:901:8a17::1005]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f9d3b2d-b08c-45e0-f2a3-08d6c99b39e0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:BN8PR21MB1233;
x-ms-traffictypediagnostic: BN8PR21MB1233:
x-microsoft-antispam-prvs: <BN8PR21MB123344F26EDB703AD611A73DA03D0@BN8PR21MB1233.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0018A2705B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(366004)(39860400002)(396003)(346002)(189003)(199004)(13464003)(14454004)(305945005)(22452003)(110136005)(99286004)(71200400001)(2906002)(71190400001)(8990500004)(486006)(6506007)(68736007)(11346002)(476003)(10290500003)(46003)(478600001)(7736002)(8936002)(8676002)(81156014)(316002)(53546011)(86362001)(446003)(66946007)(81166006)(73956011)(86612001)(66446008)(74316002)(97736004)(66556008)(64756008)(66476007)(52536014)(55016002)(9686003)(33656002)(7696005)(5660300002)(76176011)(186003)(102836004)(4744005)(53936002)(10090500001)(256004)(6116002)(6436002)(25786009)(229853002)(6246003)(76116006);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR21MB1233;H:BN8PR21MB1186.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: y6V9oIV8k40HLQXxtCeV7a3zNY7dv/d93BW9zDJGX6hUHdkekZvE+15XtIt7zuYqbMHRhY4pv8vQ0hKdUdiUtaLGcTKTo6XiFzHvgddRbVTh8zNj7/Xm0ZyZXBKjTttQYIPebXHkkU59zCY+3JQlFqLF/vFoqWl5P73AICP5E059jIq7PcqIpb9rz2d3KHxxoZ7n7bkogCJO6bH8s/lDJZUNk7xO1c0N6aJHET2mbUruKmcyGwuyYm9QRdwjZgQwE7ym/C9bv7OVrE9PVagzORH8WNBhpFOBPYgfsAgTaEp/OpbBAhZgi0zKZzvpNRZN/tE/dYnkVSJDL1KO8kXU2GnefRm32A/QYlXWt6oLNBsO/h2C56SY5d7v4889ZckZ2M8KNqxSv+LWlXhbXdeXHJN6KC1Fb3pbhl1TfObEP1Y=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f9d3b2d-b08c-45e0-f2a3-08d6c99b39e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2019 16:29:44.5919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1233
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jaWZzLW93bmVyQHZn
ZXIua2VybmVsLm9yZyA8bGludXgtY2lmcy1vd25lckB2Z2VyLmtlcm5lbC5vcmc+IE9uDQo+IEJl
aGFsZiBPZiByb25uaWUgc2FobGJlcmcNCj4gU2VudDogVGh1cnNkYXksIEFwcmlsIDI1LCAyMDE5
IDM6MjQgQU0NCj4gVG86IGxpbnV4LWNpZnMgPGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPjsg
U3RldmUgRnJlbmNoDQo+IDxzbWZyZW5jaEBnbWFpbC5jb20+DQo+IFN1YmplY3Q6IFNNQjIgU0VU
X1pFUk9fREFUQSBhbmQgUFVOQ0hfSE9MRQ0KPiANCj4gRm9sa3MuDQo+IA0KPiBJbiB0aGUgY2lm
cyBjbGllbnQgIHdlIHVzZSBGU0NUTF9TRVRfWkVST19EQVRBIHdoZW4gdXNlcnNwYWNlIHdhbnRz
IHRvDQo+IHB1bmNoIGEgaG9sZSBpbiBhIGZpbGUuIFNFVF9aRVJPX0RBVEEgbWFwcyBxdWl0ZSB3
ZWxsIHRvIHRoZQ0KPiBQVU5DSF9IT0xFIHNlbWFudGljcyBpbiB0aGF0IGl0IHdpbGwgZGVhbGxv
Y2F0ZSB3aGF0IGl0IGNhbiBhbmQNCj4gb3ZlcndyaXRlIHdoYXQgaXQgY2FuIG5vdCB3aXRoIDAu
DQo+IA0KPiBPbiB3aW5kb3dzIDE2L250ZnMgdGhlIGRlYWxsb2NhdGUgYmxvY2tzaXplIGlzIDY0
ay4NCg0KVGhpcyBwcm9jZXNzaW5nIGlzIGRlZmluZWQgaW4gTVMtRlNBIHNlY3Rpb24gMi4xLjUu
OS4zNSBhbmQgaXQncyBub3QgYSBjb25zdGFudA0KYnV0IGlzIGRlcGVuZGVudCBvbiBhIG51bWJl
ciBvZiBmaWxlc3lzdGVtIHBhcmFtZXRlcnMsIHByaW1hcmlseSB0aGUgY2x1c3Rlcg0Kc2l6ZSAo
YWthIHRoZSAiYWxsb2NhdGlvbiB1bml0IikuDQoNCj4gRG9lcyBhbnlvbmUga25vdyBpZiB0aGlz
IGlzIGFsd2F5cyA2NGsgb3IgaWYgdGhlcmUgaXMgYSB3YXkgdG8gcXVlcnkNCj4gdGhlIHNlcnZl
ciBmb3IgdGhpcz8NCg0KQ2x1c3RlciBzaXplIGNhbiBiZSBxdWVyaWVkIHZpYSBmaWxlc3lzdGVt
LXNwZWNpZmljIGZzY3RsJ3MsIGJ1dCBiZXdhcmUgdGhlIHNwZWNpYWwNCmNhc2VzLi4uIA0KDQpU
b20uDQoNCg==
