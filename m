Return-Path: <SRS0=SV7R=YL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7223CCA9EA0
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Oct 2019 22:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29FF620679
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Oct 2019 22:45:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="IbRrRiNB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730838AbfJRWpo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Oct 2019 18:45:44 -0400
Received: from mail-eopbgr740118.outbound.protection.outlook.com ([40.107.74.118]:31541
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726458AbfJRWpo (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 18 Oct 2019 18:45:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGbfNa+3iKMmkLPTfSLmNBmKBAMybZpiToB8AYb6AhcgsRodtJqOUQeq20TfjYW2WOextehisA6D4PQKKJqKWyi9X7kJLY/3EzBbs8VBLVb2HP7wWH3wnnCyjtwjVhn5BiXg5QVWEZUhSfrOPOJv0dZAl81RVR9nr8UF4EYM0XdlU0sF+lNoH1oWFVWmYZ9EY5CMaMq1jmYiZyErLl2GTZtf/8QSIG9Od2FJfhq9CGCX4EIO2/zpN6bQEy4Kwn5pF+ZrQgdVAcOl4p6g6ZJThAW8X9+bToOteEtAKpFW2ODce8d3xtDcMfURf6kEAQiarrf9OCwpC3ckL761uJtPYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ReIK8voV0Xcs1Mic+mHEJd3ilxy1PhvCmfnCXuw5PDk=;
 b=FR8ATEyzyuz0YvvY3m/venVDCUUtfW5j6jmtus+tvXW+TewayaB8Nc3nMDL1WU8RMHDS7w3j/Da4t+U3WghWSNoPN1b+Nz9LEH5tGVqPoFBRpD4CbROwfOJuk1+drly0WMHjud0VS8F7DzdIXKLaYhtQjoDuqx3Z+5yATq2kolGhodilC9SAzLkYpY7A2TobVDnXVEIi5/zqdcSbo5cUahdsBpGOrDaDpcz61xCTNbeF6Firb8NtammNGy3bE417LsbiMEUbW9z1VjXAdUm/mYaN6v7tysEiAk6RQgPvT+EPwkESd9NqLolRAKf0rbGXwWm8uvSFrJX6xTwSMoPhng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ReIK8voV0Xcs1Mic+mHEJd3ilxy1PhvCmfnCXuw5PDk=;
 b=IbRrRiNBhqaDs47Ar+1QTVvmRFPqTTXvIqvKYJUhTSLgA3EUbw8CbJJNv9R7gKPk1qDYciWSpvcCJokMpBH0ITfTl5ZqStO8QZ8F0HcDKu0bxQBJJKYSRbnUyjQNH0zSfn9NASJ5PoWQddIKwJHVf1AT41SeFunJTMrVNl0Qfl4=
Received: from DM5PR21MB0185.namprd21.prod.outlook.com (10.173.173.136) by
 DM5PR21MB0746.namprd21.prod.outlook.com (10.173.172.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.8; Fri, 18 Oct 2019 22:45:40 +0000
Received: from DM5PR21MB0185.namprd21.prod.outlook.com
 ([fe80::40b9:1196:e1ef:8fa4]) by DM5PR21MB0185.namprd21.prod.outlook.com
 ([fe80::40b9:1196:e1ef:8fa4%11]) with mapi id 15.20.2387.010; Fri, 18 Oct
 2019 22:45:40 +0000
From:   Pavel Shilovskiy <pshilov@microsoft.com>
To:     David Wysochanski <dwysocha@redhat.com>
CC:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Frank Sorenson <sorenson@redhat.com>
Subject: RE: list_del corruption while iterating retry_list in cifs_reconnect
 still seen on 5.4-rc3
Thread-Topic: list_del corruption while iterating retry_list in cifs_reconnect
 still seen on 5.4-rc3
Thread-Index: AQHVhFfJ9oP6OHPYNEeW5MnF2E27oqdd98kAgACTlgCAACvBAIAAKOAAgAAWtQCAADArYIAAEQ8AgAAJKVCAAArhgIAAE4yAgAAC0eDft33iN6BJL9qAgAATzgCAAAxsgIAAsG0AgAAKh4CAAAZ5gIAABw4Q
Date:   Fri, 18 Oct 2019 22:45:40 +0000
Message-ID: <DM5PR21MB01851871D57ABCF685712C76B66C0@DM5PR21MB0185.namprd21.prod.outlook.com>
References: <CALF+zOkugWpn6aCApqj8dF+AovgbQ8zgC-Hf8_0uvwqwHYTPiw@mail.gmail.com>
 <CALF+zO=8ZJkqR951NsxOf4hDDyUZzMfyiEN-j8DgA+i+FzcfGw@mail.gmail.com>
 <DM5PR21MB018515AFDDDE766D318BC489B66D0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <CALF+zOmz5LFkzHrLpLGWcfwkOD7s-VhVz39pFgMNAFRT9_-KYg@mail.gmail.com>
 <58429039.7213410.1571348691819.JavaMail.zimbra@redhat.com>
 <DM5PR21MB0185FD6A138A5682BB9DE310B66D0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <106934753.7215598.1571352823170.JavaMail.zimbra@redhat.com>
 <CALF+zOn-J9KyDDTL6dJ23RbQ9Gh+V3ti+4-O051zqOur6Fv-PA@mail.gmail.com>
 <1884745525.7250940.1571390858862.JavaMail.zimbra@redhat.com>
 <CALF+zOkmFMtxsnrUR-anXOdMzUFxtAWG+VYLAQuq3DJuH=eDMw@mail.gmail.com>
 <DM5PR21MB0185857761946DBE12AEB3ADB66C0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <CALF+zO=heBJSLW4ELPAwKegL3rJQiSebCLAh=4syEtPYoaevgA@mail.gmail.com>
 <CALF+zO=BUC2pCcz=n6hBx7ZPsL8gABLqx_hBQXVC=OOLJ-DDig@mail.gmail.com>
In-Reply-To: <CALF+zO=BUC2pCcz=n6hBx7ZPsL8gABLqx_hBQXVC=OOLJ-DDig@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=pshilov@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-18T22:45:38.6877333Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=01011192-3e96-42cf-84e8-82d1eed5c61e;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pshilov@microsoft.com; 
x-originating-ip: [2001:4898:80e8:0:2c8b:427a:370f:b81]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30c3e9c1-e1da-4038-12c0-08d7541ce6db
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM5PR21MB0746:
x-microsoft-antispam-prvs: <DM5PR21MB0746496775C8DA3940726FAAB66C0@DM5PR21MB0746.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(396003)(346002)(39860400002)(366004)(136003)(51914003)(189003)(199004)(10290500003)(71200400001)(52536014)(2906002)(33656002)(10090500001)(478600001)(76176011)(102836004)(6506007)(66476007)(8990500004)(53546011)(99286004)(5660300002)(4326008)(66556008)(22452003)(9686003)(54906003)(6436002)(8936002)(305945005)(7696005)(71190400001)(55016002)(81166006)(66446008)(81156014)(6246003)(316002)(64756008)(8676002)(74316002)(66946007)(5024004)(6916009)(76116006)(486006)(14454004)(476003)(186003)(256004)(14444005)(11346002)(7736002)(6116002)(46003)(446003)(229853002)(25786009)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR21MB0746;H:DM5PR21MB0185.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MUgiktydF7Ez/WAJ5VquBsLS3fSLNKz1ORvd/as0dz9CFZ2NflumhaMUzdPyuEPrSrMQA+FhNtWPRHmyp/MmiyexjvWu0BQK88grU1lh14HJKiLTkZK7N4u6K9mULqESKV7DCQH5zNMRT2o7UPIRRjRmrijrpOxtRH0+OfQCMEZM9pkVu+TjfUSKYwM/llxbp+MqNTBiqj7sJqodHbkmd+E/wJhwkzlKiv3Zt6wXOi6P0/iz6c+G7U69v8ogZe6GLqWt5jVWJ6vMG5tfO2U7pUnezo94tT7CxqHU7mkWa70ddIo02gYeRraw/nOE9IFWJDF83fbx7tY+FPuATHQhWe34SyiOKOm1kX1KKs/JRQqJ+PREbTsVXjUuJMVOsTxUEuio1i0Q9bo37FQIKKZM6V7S4KlBvOcRYuc0Y2QXcFY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30c3e9c1-e1da-4038-12c0-08d7541ce6db
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 22:45:40.3977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QwyKXwwvmNmHARBPUzGSQi6z76Bd4yKOe2TxZO0XmYOzfXpdGNX+YmBtKq3xt14+JHIpQMMMcLrgxgJYSpu7kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0746
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

T24gRnJpLCBPY3QgMTgsIDIwMTkgYXQgNToyMSBQTSBEYXZpZCBXeXNvY2hhbnNraSA8ZHd5c29j
aGFAcmVkaGF0LmNvbT4gd3JvdGU6DQo+DQo+IE9uIEZyaSwgT2N0IDE4LCAyMDE5IGF0IDQ6NTkg
UE0gUGF2ZWwgU2hpbG92c2tpeSA8cHNoaWxvdkBtaWNyb3NvZnQuY29tPiB3cm90ZToNCj4gPg0K
PiA+IFRoYW5rcyBmb3IgdGhlIGdvb2QgbmV3cyB0aGF0IHRoZSBwYXRjaCBpcyBzdGFibGUgaW4g
eW91ciB3b3JrbG9hZCENCj4gPg0KPiBUaGUgYXR0YWNoZWQgcGF0Y2ggSSByYW4gb24gdG9wIG9m
IDUuNC1yYzMgZm9yIG92ZXIgNSBocnMgdG9kYXkgb24gdGhlIA0KPiByZWJvb3QgdGVzdCAtIGJl
Zm9yZSBpdCB3b3VsZCBjcmFzaCBhZnRlciBhIGZldyBtaW51dGVzIHRvcHMuDQoNClRoaXMgaXMg
Z3JlYXQhIFRoYW5rcyBmb3IgdmVyaWZ5aW5nIHRoZSBmaXguDQoNCj4gPiBUaGUgZXh0cmEgZmxh
ZyBtYXkgbm90IGJlIG5lY2Vzc2FyeSBhbmQgd2UgbWF5IHJlbHkgb24gYSBNSUQgc3RhdGUgYnV0
IHdlIHdvdWxkIG5lZWQgdG8gaGFuZGxlIHR3byBzdGF0ZXMgYWN0dWFsbHk6IE1JRF9SRVRSWV9O
RUVERUQgYW5kIE1JRF9TSFVURE9XTiAtIHNlZSBjbGVhbl9kZW11bHRpcGxleF9pbmZvKCkgd2hp
Y2ggaXMgZG9pbmcgdGhlIHNhbWUgdGhpbmdzIHdpdGggbWlkIGFzIGNpZnNfcmVjb25uZWN0KCku
IFBsZWFzZSBhZGQgcmVmIGNvdW50aW5nIHRvIGJvdGggZnVuY3Rpb25zIHNpbmNlIHRoZXkgYm90
aCBjYW4gcmFjZSB3aXRoIHN5c3RlbSBjYWxsIHRocmVhZHMuDQo+ID4NCg0KPiBJIGFncmVlIHRo
YXQgbG9vcCBoYXMgdGhlIHNhbWUgcHJvYmxlbS4gIEkgY2FuIGFkZCB0aGF0IHlvdSdyZSBvayB3
aXRoIHRoZSBtaWRfc3RhdGUgYXBwcm9hY2guICBJIHRoaW5rIHRoZSBvbmx5IG90aGVyIG9wdGlv
biBpcyBwcm9iYWJseSBhIGZsYWcgbGlrZSBSb25uaWUNCj4gc3VnZ2VzdGVkLg0KPiBJIHdpbGwg
aGF2ZSB0byByZXZpZXcgdGhlIHN0YXRlIG1hY2hpbmUgbW9yZSB3aGVuIEkgYW0gbW9yZSBhbGVy
dCBpZiB5b3UgYXJlIGNvbmNlcm5lZCBhYm91dCBwb3NzaWJsZSBzdWJ0bGUgcmVncmVzc2lvbnMu
DQoNCkkgYW0gb2sgd2l0aCBib3RoIGFwcHJvYWNoZXMgYXMgbG9uZyBhcyB0aGUgc3RhYmxlIHBh
dGNoIGlzIG1pbmltYWwuIFRoaW5raW5nIGFib3V0IHRoaXMgY29uZGl0aW9uYWwgYXNzaWdubWVu
dCBvZiB0aGUgbWlkIHJldHJ5IHN0YXRlOiBJIGRvbid0IHRoaW5rIHRoZXJlIGlzIGFueSBjYXNl
IGluIHRoZSBjdXJyZW50IGNvZGUgYmFzZSB3aGVyZSB0aGUgV0FSTl9PTiB5b3UgcHJvcG9zZWQg
d291bGQgZmlyZSBidXQgSSBjYW4ndCBiZSBzdXJlIGFib3V0IGFsbCBwb3NzaWJsZSBzdGFibGUg
a2VybmVsIHRoYXQgdGhlIHN0YWJsZSBwYXRjaCBpcyBnb2luZyB0byBiZSBhcHBsaWVkLg0KDQpB
bm90aGVyIG1vcmUgZ2VuZXJhbCB0aG91Z2h0OiB3ZSBoYXZlIGNpZnNfZGVsZXRlX21pZCAtPiBE
ZWxldGVNaWRRRW50cnkgLT4gX2NpZnNfbWlkX3FfZW50cnlfcmVsZWFzZSBjaGFpbiBvZiBjYWxs
cyBhbmQgZXZlcnkgZnVuY3Rpb24gZnJlZXMgaXRzIG93biBwYXJ0IG9mIHRoZSBtaWQgZW50cnku
IEkgdGhpbmsgd2Ugc2hvdWxkIG1lcmdlIHRoZSBsYXN0IHR3byBhdCBsZWFzdC4gSXQgd291bGQg
YWxsb3cgdXMgdG8gZ3VhcmFudGVlIHRoYXQgaG9sZGluZyBhIHJlZmVyZW5jZSB0byB0aGUgbWlk
IG1lYW5zOg0KDQoxKSB0aGUgbWlkIGl0c2VsZiBpcyB2YWxpZDsNCjIpIHRoZSBtaWQgcmVzcG9u
c2UgYnVmZmVyIGlzIHZhbGlkOw0KMykgdGhlIG1pZCBpcyBpbiBhIGxpc3QgaWYgaXQgaXMgUkVR
VUVTVF9TVUJNSVRURUQsIFJFVFJZX05FRURFRCBvciBTSFVURE9XTiBhbmQgaXMgbm90IGluIGEg
bGlzdCBpZiBpdCBpcyBBTExPQ0FURUQsIFJFU1BPTlNFX1JFQ0VJVkVELCBSRVNQT05TRV9NQUxG
T1JNRUQgb3IgRlJFRTsgdGhlIHJlbGVhc2UgZnVuY3Rpb24gc2hvdWxkIHJlbW92ZSB0aGUgbWlk
IGZyb20gdGhlIGxpc3Qgb3Igd2FybiBhcHByb3ByaWF0ZWx5IGRlcGVuZGluZyBvbiBhIHN0YXRl
IG9mIHRoZSBtaWQuDQoNClRoZSBtaWQgc3RhdGUgYW5kIGxpc3QgbG9jYXRpb24gYXJlIGNoYW5n
ZWQgb25seSB3aGVuIHRoZSBHbG9iYWxNaWRfTG9jayBpcyBoZWxkLiBJbiB0aGlzIGNhc2UgY2lm
c19kZWxldGVfbWlkIGlzIG5vdCBuZWVkZWQgdG9vIGJlY2F1c2UgYWxsIHdoYXQgaXQgZG9lcyB3
aWxsIGJlIGRvbmUgaW4gdGhlIHJlbGVhc2UgZnVuY3Rpb24uIEkgdGhpbmsgdGhpcyB3b3VsZCBh
bGxvdyB0byBhdm9pZCBhbGwgdGhlIHByb2JsZW1zIGRpc2N1c3NlZCBpbiB0aGlzIHRocmVhZCBi
dXQgbG9va3MgdG9vIHJpc2t5IGZvciBzdGFibGUuDQoNCi0tDQpCZXN0IHJlZ2FyZHMsDQpQYXZl
bCBTaGlsb3Zza3kNCg==
