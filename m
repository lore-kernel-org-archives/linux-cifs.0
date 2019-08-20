Return-Path: <SRS0=G0ZP=WQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13727C3A589
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Aug 2019 17:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3EAD22DA7
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Aug 2019 17:48:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="isqqC7Ka"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfHTRsH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Aug 2019 13:48:07 -0400
Received: from mail-eopbgr800138.outbound.protection.outlook.com ([40.107.80.138]:36951
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729827AbfHTRsH (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 20 Aug 2019 13:48:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KcTyihVMB4qp01n5/4V+HOVsArPYgakiVUaLlI9ep9i9SNVnKwfnmCkkEQj5t1Of97Mi3olvGWIYhcDGdmXAZbigTMJM3tf+wAmn5odrZlZikOD7apWaEq1YWqJ47qOsI1R4LMgun3me3u3zfwp5rX0Fr/EfFKgcO43VTmjCkYNU5+hwJw6VGJ/2FhU3a2qb27pJuvMhesl+OWUXUduiXLgooYo9NLDB95bKmsWRBxvmGR9IlJ5CZkfi7RWpCUUPNZslzAAwVv8qq9mgSqqxuT6L/NBh3wtPKL3//i7PMg+nNpE7dkF5/BRE6gsxuUV/h4uFlTly4hpGzinEjDz6DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zMfZW1MwzYp+0r2+2KEhFUZxoP2EUd6rnK4KPtTLkXs=;
 b=Y7UlXYuaynE55IRheD0+dlRR8nvmE9pwtCI99W3uNtbUoFan0W/cFR97+erhKNGUq8zNcxQUvCjEGxViH8Ak4FUmyG8YewB0s4/kGJ6U51J95SzyBck4voXnmqFIOEfFrNqluL3rGh0fjO5XFrSIRTtXROmxNCwzNAwhxzMeeHtHmDlCJuWZgWPTrmZ3SnKXcKKfIQqUTrHd0+4bvHuxxIdw6PQ6YTMpLzdBV5NTxq55yEuwOqN+tV83G6ZMT+vygyFyqSdF1xOSA4PGyehJSf/wUSPu2SccFHXZB3rPej9FvaC+UuwFY6DoB7IPDJkzE/7n5/ILjj8qcF88s5ZyQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zMfZW1MwzYp+0r2+2KEhFUZxoP2EUd6rnK4KPtTLkXs=;
 b=isqqC7Kazf6iKkEwE4zz7u+NZKK6fOhZD4gtqBW10qSDFxWMFTK5EBgd9ksNWB3GTScJIR2RcxtVr5PyJbp2Vam7ao4kXQJ1ewYqN8M8FHFD+UC6HXnaQWHhZIQr1GPIQbbyiqcWh617oMzUS0Ri0pTlH8qYF/yYJL7Ef3JdEXA=
Received: from MWHPR2101MB0731.namprd21.prod.outlook.com (10.167.238.165) by
 MWHPR2101MB0729.namprd21.prod.outlook.com (10.167.161.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.6; Tue, 20 Aug 2019 17:47:24 +0000
Received: from MWHPR2101MB0731.namprd21.prod.outlook.com
 ([fe80::e950:3464:b81f:80e5]) by MWHPR2101MB0731.namprd21.prod.outlook.com
 ([fe80::e950:3464:b81f:80e5%8]) with mapi id 15.20.2199.004; Tue, 20 Aug 2019
 17:47:24 +0000
From:   Tom Talpey <ttalpey@microsoft.com>
To:     David Disseldorp <ddiss@suse.de>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
CC:     linux-cifs <linux-cifs@vger.kernel.org>
Subject: RE: FSCTL_QUERY_ALLOCATED_RANGES issue with Windows2016
Thread-Topic: FSCTL_QUERY_ALLOCATED_RANGES issue with Windows2016
Thread-Index: AQHVUzMIxVep5FyrWkKPdfdBy87zGqb8W3sAgACs1ACAACmngIAFftmAgABcvgCAAUSL4A==
Date:   Tue, 20 Aug 2019 17:47:23 +0000
Message-ID: <MWHPR2101MB07318FE687DAC9C78A54D1D3A0AB0@MWHPR2101MB0731.namprd21.prod.outlook.com>
References: <CAN05THT0OkbAoNu8ZVSHF-xY7w0ZW4q4i-jTxjNManrnz0OMfg@mail.gmail.com>
        <20190815174854.05661672@suse.de>
        <CAN05THThHLkSF=oVBezJQBsre7QoH6eS=SLbxo3Z=w8M+fa=RQ@mail.gmail.com>
        <CAN05THT3NF+eAd=H+gpmZQp0SWBQ0iFe32TT0VB5_rmibcN2Cw@mail.gmail.com>
        <20190819183151.15642e8f@suse.de> <20190820000348.440ee8ce@suse.de>
In-Reply-To: <20190820000348.440ee8ce@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=ttalpey@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-20T17:47:22.1247189Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=be082812-fae5-4ec4-8490-ea3fab99cea9;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ttalpey@microsoft.com; 
x-originating-ip: [24.218.182.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5784b9e-d274-4078-e87d-08d72596757f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600158)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MWHPR2101MB0729;
x-ms-traffictypediagnostic: MWHPR2101MB0729:
x-microsoft-antispam-prvs: <MWHPR2101MB0729EEC0726F823630E9DF05A0AB0@MWHPR2101MB0729.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(376002)(39860400002)(396003)(136003)(346002)(13464003)(199004)(189003)(66556008)(74316002)(8936002)(66476007)(66946007)(76116006)(6246003)(478600001)(55016002)(71200400001)(81166006)(53936002)(10290500003)(64756008)(81156014)(305945005)(7736002)(14454004)(25786009)(9686003)(6506007)(53546011)(76176011)(316002)(7696005)(14444005)(229853002)(256004)(110136005)(66446008)(10090500001)(4326008)(8990500004)(2906002)(8676002)(99286004)(102836004)(486006)(52536014)(71190400001)(186003)(33656002)(446003)(86362001)(6116002)(3846002)(6436002)(11346002)(66066001)(22452003)(476003)(5660300002)(26005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2101MB0729;H:MWHPR2101MB0731.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 77Ctiq7BV8m6Ikj+KzE2g3w2CnkQpZcO6zcO7GV1pMg2leS92Po1QlopywTkfkOKWQuR4ItYqQJ5wWo22ke1NNwdIK1TOR1OF8EvgNDuzHv30+pDVJevqcSRXIrEQ8H8ljHoRUnPis7iVGjuqqro+m218ONZjWF67RbI0Xgc51PB6M4uk2q4Yy+gxb7JKNW5ctzwAyF5RLvW1hgFpIxrcITGMqtW+OO60M1QoIsmdh1CUYdVRV72zCOD5idZVy6/6ozUKgNhUkOaMR4R6c3uwJBRqHfW3nmamT1ENgep8cwqbTcRbuJUKiMkwzZg0kaAwiEIR1hnGOsDa0EmbKjd6WL2/xpcqoWatGN7oULrnfFT8TCUFHA+4Bi0mxmu8KlKOvyKEVCEFiWQeH5cdBNrNkCdZ8LZpxZFb9J20imMjmk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5784b9e-d274-4078-e87d-08d72596757f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 17:47:24.0944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 44dtbv0oOtXyg4v0a4+WD94OUYj/i07MiGjVYvLRf4Ts75KqxzejzTIqJqeVeh3DtVf4nSPMEkOwRtj8JfeswQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2101MB0729
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jaWZzLW93bmVyQHZn
ZXIua2VybmVsLm9yZyA8bGludXgtY2lmcy1vd25lckB2Z2VyLmtlcm5lbC5vcmc+IE9uDQo+IEJl
aGFsZiBPZiBEYXZpZCBEaXNzZWxkb3JwDQo+IFNlbnQ6IE1vbmRheSwgQXVndXN0IDE5LCAyMDE5
IDY6MDQgUE0NCj4gVG86IHJvbm5pZSBzYWhsYmVyZyA8cm9ubmllc2FobGJlcmdAZ21haWwuY29t
Pg0KPiBDYzogbGludXgtY2lmcyA8bGludXgtY2lmc0B2Z2VyLmtlcm5lbC5vcmc+DQo+IFN1Ympl
Y3Q6IFJlOiBGU0NUTF9RVUVSWV9BTExPQ0FURURfUkFOR0VTIGlzc3VlIHdpdGggV2luZG93czIw
MTYNCj4gDQo+IE9uIE1vbiwgMTkgQXVnIDIwMTkgMTg6MzE6NTEgKzAyMDAsIERhdmlkIERpc3Nl
bGRvcnAgd3JvdGU6DQo+IA0KPiA+IE5vdGhpbmcgc3RhbmRzIG91dCBpbiB0aGUgY2FwdHVyZXMg
dG8gbWUsIGJ1dCBJJ2QgYmUgY3VyaW91cyB3aGV0aGVyIHlvdQ0KPiA+IHNlZSBhbnkgZGlmZmVy
ZW5jZXMgaW4gYmVoYXZpb3VyIGlmIHlvdSBzZXQgd3JpdGUtdGhyb3VnaCBvbiBvcGVuIG9yDQo+
ID4gZXhwbGljaXRseSBGTFVTSCBhZnRlciB0aGUgU0VULVNQQVJTRSBjYWxsLg0KPiANCj4gSG1t
IGFjdHVhbGx5IGl0IGxvb2tzIGxpa2UgdGhlcmUncyBhbHJlYWR5IGEgRkxVU0ggc2hvcnRseSBh
ZnRlciB0aGUNCj4gbXRpbWUgdXBkYXRlIGZvbGxvd2luZyB0aGUgU2V0SW5mbyhFT0YpLiBPbmUg
dGhpbmcgdGhhdCBkb2VzIGxvb2sgYQ0KPiBsaXR0bGUgd2VpcmQgaXMgdGhlIEFsbG9jYXRpb25T
aXplIGZpZWxkIGJlZm9yZSB0aGF0IEZMVVNIIC0gaW4NCj4gc2Vla19iYWQuY2FwLmd6IGl0J3Mg
Mk0sIHdoZXJlYXMgaXQncyB+Nk0gaW4gc2Vla19nb29kLmNhcC5nei4NCg0KQW5vdGhlciBvZGRp
dHkgaXMgdGhhdCB0aGUgRlNDVExfU0VUX1NQQVJTRSBjb21lcyAqYWZ0ZXIqIHRoZSAyTUINCndy
aXRlLiBJdCBzZWVtcyBlbnRpcmVseSBwb3NzaWJsZSB0aGF0IGZpbGVzeXN0ZW0gbWF5IGhhdmUg
ZGVjaWRlZCB0bw0KYWxsb2NhdGUgYWRkaXRpb25hbCBibG9ja3MgZHVyaW5nIHRoZSB3cml0ZSwg
aW4gZXhwZWN0YXRpb24gb2YgbW9yZQ0Kd3JpdGVzLiBTaW5jZSB0aGUgRU9GIHBvaW50ZXIgaXMg
c3RpbGwgMk1CLCBJIGJlbGlldmUgdGhlIGZpbGVzeXN0ZW0gbWF5DQpiZSB3ZWxsIHdpdGhpbiBp
dHMgcmlnaHRzIHRoZXJlLiBJbiBhbnkgZXZlbnQgdGhlcmUgbWF5IGJlIGEgdGltaW5nIHRoaW5n
DQpnb2luZyBvbiwgYmVjYXVzZSBpdCdzIGRvaW5nIGltbWVkaWF0ZWx5Og0KDQp3cml0ZSAyTUIN
CmZzY3RsIFNFVF9TUEFSU0UNCnNldGluZm8gRU9GPTRNQg0KY29tcG91bmQgb3BlbittdGltZStj
bG9zZSAod2h5IGEgbmV3IGhhbmRsZSBmb3Igc2V0dGluZyBtdGltZSBidHc/KQ0KZ2V0aW5mbw0K
Zmx1c2gNCmZzY3RsIFFVRVJZX0FMTE9DQVRFRF9SQU5HRVMNCg0KDQpUaGUgTlRGUyBkZXZlbG9w
ZXJzIHdlcmUga2luZCBvZiBza2VwdGljYWwgb2YgdGhlIGFwcHJvYWNoIG9mIGxvb2tpbmcNCmF0
IHRoZSBibG9jayBhbGxvY2F0aW9uIGNvdW50cyB0byBkZXRlY3QgaG9sZXMuIFRoZSBmaXJzdCBl
eGFtcGxlIHRoZXkNCm1lbnRpb25lZCB3YXMgYSBzbWFsbCBmaWxlLCBsaWtlIDQwMCBieXRlcywg
Zm9yIHdoaWNoIHRoZSBlbnRpcmUgY29udGVudA0Kd291bGQgZmFsbCBpbnRvIHRoZSBNRlQgcmVj
b3JkLiBTdWNoIGEgZmlsZSB3b3VsZCBzaG93IHplcm8gYmxvY2tzDQphbGxvY2F0ZWQsIHJlZ2Fy
ZGxlc3Mgb2Ygc3BhcnNlbmVzcy4NCg0KVG9tLg0KDQo=
