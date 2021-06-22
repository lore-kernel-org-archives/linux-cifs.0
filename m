Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D25AAC2B9F4
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 06:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB333610EA
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 06:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhFVGvo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 02:51:44 -0400
Received: from mail-mw2nam12on2114.outbound.protection.outlook.com ([40.107.244.114]:58528
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229628AbhFVGvn (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 22 Jun 2021 02:51:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P9OOV0hFOwE62LjySCDlnLYvYReTxfuRfI9LFnB45jENIa4omnuFtuUbRlhVnyDkIcdVFBXW96mgNx76Zl2c9Iy600sTPyvy3gfFtRJlEU0a10afSoI+zyWK1sYH5BJjdXA++mtGn/0c2U3ZUo70AfSC6egMHf6RbFDPyx9cveAXVzEKopGNkWXd1gXilLOMvy1YukxI/t0do56DWDoQ6rBQce8rTmhZmKB+48Im9Ksg8G+e+TgK1OcI7ZcVvkZ36pc6vQKbqV2PG0H5I4g5yHWPPX+u0I10P7WpSrBVTsB08M1IJ/cp50H/cAdkPYwGpxaOgxefseft2efFcUTvBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TrVtrAMk3s7Thea0MJ6Fd4V17Qd2mU6NAMaQ0tKaX74=;
 b=BORaV1DnUxcK7jQPrMNJr1MAT2kCg35GxzrNaNBor0tjaSTsgow+NS8v2ZrBc9y7M8NPGEA8zmKzKMZlTf5nnidqiKcjcuvNmjirBhxNx0S8N3mJVU/OwroWqHMdCCjpZIrZCmmjOuq3Z46mVLbTx5+gDmhg+RnV406DBTyGV/7SpSB2w9oUId/RCe/99Q5Nz9jt434Fd0aUiB8BEznbU1Znq3SYm+qJG9F0jXSIeyKyZnvUBotutP3CjbF3BSanLjroomx783PYVRq8SsltVw+eAn49h/5TsxMlWm9CiFJN44phO55dAJISd19H57RwJnkBYFn00f70dXxCryMvxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TrVtrAMk3s7Thea0MJ6Fd4V17Qd2mU6NAMaQ0tKaX74=;
 b=fqzsOCtK0FhZW+kqG+DVx+YmeTY9O2NC2+P0Wew6t3wkL7Wvmx3W/hQXXXABbYmHzUjIv/FHGohHkdRGCizQMte5zstwaJuK0DQjz7g9UmxXXYNV+tpaDoSie/VPzTBNfyU5P3qhVX1iuNhHT4JVImW5mTFDDfZMtWub+Mu0mP4=
Received: from BY5PR21MB1506.namprd21.prod.outlook.com (2603:10b6:a03:23d::12)
 by BYAPR21MB1702.namprd21.prod.outlook.com (2603:10b6:a02:c3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.5; Tue, 22 Jun
 2021 06:49:26 +0000
Received: from BY5PR21MB1506.namprd21.prod.outlook.com
 ([fe80::6997:e2d1:e305:eeea]) by BY5PR21MB1506.namprd21.prod.outlook.com
 ([fe80::6997:e2d1:e305:eeea%8]) with mapi id 15.20.4264.011; Tue, 22 Jun 2021
 06:49:26 +0000
From:   Long Li <longli@microsoft.com>
To:     Steve French <smfrench@gmail.com>
CC:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [SMBDIRECT][PATCH] missing rc checks while waiting for SMB3 over
 RDMA events
Thread-Topic: [SMBDIRECT][PATCH] missing rc checks while waiting for SMB3 over
 RDMA events
Thread-Index: AQHXZuTnIcEzEyM85kOjDu4IG5shy6sfl47w
Date:   Tue, 22 Jun 2021 06:49:26 +0000
Message-ID: <BY5PR21MB1506569FF2459DF87041EEC5CE099@BY5PR21MB1506.namprd21.prod.outlook.com>
References: <CAH2r5msOSLaZT42-jFMjJrB1YiYTZBzdM18ieqQY2v=YwXzcrA@mail.gmail.com>
In-Reply-To: <CAH2r5msOSLaZT42-jFMjJrB1YiYTZBzdM18ieqQY2v=YwXzcrA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=86c86a1d-180a-4d6b-bd64-8fe557c052a6;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-06-22T06:48:56Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24aeb94b-d7f8-468a-e8b7-08d93549e05b
x-ms-traffictypediagnostic: BYAPR21MB1702:
x-microsoft-antispam-prvs: <BYAPR21MB170207BB706897614ED38EF6CE099@BYAPR21MB1702.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x+Imavsw6B931FL5430mo4EBz25PwJe0oFBj9kxQY333i666z8Ru36e3NJ5LB7jcmvRHPtBbb5CL6NaNCzraqWHEPA6IB3IkIEQiCJipQ9HJqwccjhXRaH6zhFoaUjuQXS/UqcDA6qe55pMifOIo9izrAxDrUeKVKwY87ieJovvHUMCWxBgG7nasnlwPfqL95QWJV0KtpjC3bkrKOZMXjVy9HHkFqEt18oRcKImqOYb/HRgksRq4+NYp6XQVxq3AW80CNi+hpdC3S5ClzRVQg0t2PaLO7VHh+r3KPTnDF6jl0ti08HhcsRGtuWZeE3F9qg1fVIDweFrjf4nl+ckKS/qEL/vShazI1rXsgQh3GKfnP4KlOcArbkpm1eUOL3o+blTnvJ9twYKU3ZtK9iCkQPCTzwpNu9EEphucFTcPswdhYTgOwtG0Yzrn9PAx3LlsaTmuZeeu816qPtOAUjMHuQPikX2x+E2teFpe+noJpD9gPxnXn6tuMhwkC02QGqCApWd0GxlzauuM/B+hQynDzzGk1TnpCsTB9crEgNQGxCmQ5mbY6sfA0JFt3UADi4HeTzyYu/x6qwGoIUWXAG16XchNdlCrRfVpc4RwCenE2x/PBU2H/J1eS97cD4LcZDWrPN1+STlbIb7dT6KhJu6RDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1506.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(82950400001)(33656002)(82960400001)(55016002)(5660300002)(4326008)(66476007)(54906003)(64756008)(8676002)(316002)(71200400001)(86362001)(6506007)(8936002)(66446008)(38100700002)(186003)(122000001)(2906002)(7696005)(66946007)(76116006)(66556008)(10290500003)(52536014)(8990500004)(26005)(6916009)(478600001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ck5EeGpBUkRqTmlxZk9oVGR1bm1xMlEwUTkwSWVHQldITkc3RDliWkVaMndu?=
 =?utf-8?B?MmNuMU1BenZyQkdxQVV1aUFxamZ0SFlBeEpKSnRuVXBNQ2xycVhQZFZEMFFT?=
 =?utf-8?B?YnlPNk85YjNhWWloV0M5czNYTjY2MytsdXBEaWpVRFUrWGhQbHRQYkEzNVZE?=
 =?utf-8?B?UDhqRlFENEwyNTVLNTVybVZxNnpSOXNxTVNFazJDemdrbHhxQ09FTW5iaTJz?=
 =?utf-8?B?TDd1SW5iWnRTZW80MDM2Rks0TVEvK0kyWjB2dVlIQjd6NVQ4SEY5eld3VVFJ?=
 =?utf-8?B?b0RZM1VtbXliY2tyNGtaWnJRTzNjZjRvRjMyVW9qVkpmWE0wTDN1ZlYzeWZ0?=
 =?utf-8?B?MlRvMTZybG9JSStwdWd4ekZYZ3p0TFpNZlBhZFRQSlRqdDZaY0R6aHA4V1p5?=
 =?utf-8?B?clY5TG5SVlhGNUVxSnpCUFo0ZkRPOTQrc3kzdUdRK1NsTnNXcHBMUU5CbENU?=
 =?utf-8?B?WVVNekZ0ZjhQTTRqUHVkQXE0NlpQbWlaTnBKelVvTG80cE9GRE54V2JmVjRI?=
 =?utf-8?B?c3ZoUXU1KzJ5S0ZXeHVJb3ozSWF2VW5zaFVHTVpyaHZCWHBtaFJrNE93NG9M?=
 =?utf-8?B?cDBVU3BFZk8weW9LQjZFVWorZHZqUytsV3krUEo2bkVpSWFPUnk0eHYrQlhJ?=
 =?utf-8?B?K3N6K2lBaHJoRXBYWXNPdkJTVE0razZTUi8xb0dwNGVPekNIUFliWTVrL1hk?=
 =?utf-8?B?OUFrTVBnT3dNNkRndGtGSkpZN0lsZ2RpNysxUG4vb3BKc2ZEQmRuY2M2RWx0?=
 =?utf-8?B?dngyWmpXcERCV0tJNXdsbUJpaE5tWlFqWjc5dHFVR3gvUE8zUktVUnF4M21C?=
 =?utf-8?B?K1Z6VDMvVER6d2ZDZVdJenhUUFdpV0VmZDJBMHZPOTgwbTRWZkZ6U1JHeTNF?=
 =?utf-8?B?cVMvUWRFMFBGQTFobCtrTlZRSzdRd1I0OHpjUmFhL0lyeGY1TUpUOVVQcVlR?=
 =?utf-8?B?bjZLVWJ4cHo5bUNyRUttLzNXY3Jxdy9mcjd2ckg1bU9vWDBLTjR5R0ZCOGFV?=
 =?utf-8?B?aStsZ1RoTVlXWGdINXZ5d2hsU1dxNTVHd3laYlFzVVVvK0g1SlN5OFJhSGhV?=
 =?utf-8?B?Y014OTlKSmoxNjJBTTFyeVVxYkQ4K2daZUZTdVpCakhCYUdFSGphUDZKeC9R?=
 =?utf-8?B?b3Zya2hXcXIyZUh6MWlmSy85enlJcWJVSkNtdnZ0d3pVemRMTVgwcGVIbGs4?=
 =?utf-8?B?eW1CNlVSdjdsbS9sSzhIUCtvYWtlQ0VEaEg4Sm9uUHovb2xXTzZuTmY2bi9u?=
 =?utf-8?B?YVp0WENFa0R6RGp2bVRkMEJlUmE3ZElzdXVoWjAxSDhoazVnMnFHVTVYTmRZ?=
 =?utf-8?B?QlB1ekpLbWs5UFRTd3JpYndTN2VFU09IZG1TbVg2UzRPM2NzY0Nwd24rT0lT?=
 =?utf-8?B?TzNxVzlrS2E3dU4xWWhuRUV4OEdHVlZWbXRVZFFZUGtoZ29wZG1vUm55MGZ3?=
 =?utf-8?B?WjBvMEMyblEvWWo1NHNYLzlmcXdqaUplWlRZNmpzS0IyNHVDRUh0KythOENI?=
 =?utf-8?B?SitlU1JIUTViVmVkTXdTbEV1dktwMjVoQ1ZUNXg5c29OTnZKMHd0YmJsZjZ5?=
 =?utf-8?B?clh2OC96bXpKbDh5bmVINmRoME91ZTZvMFBFdlFFa3hxWjdqcEZhMjlvYm91?=
 =?utf-8?B?MDlhU0ZTT3hnbWN5VnVrcklRL0R5K2VqVXA1M01GbWJOWSsyMTRESTQ0Z2sr?=
 =?utf-8?B?RFF1ZXp6Sy95Z2IvRUw5aEZvNnNsUk9hcUkyUGpNVWcyZ2FYVDZjRTFFc0Iv?=
 =?utf-8?Q?9ySPcFoYfA36mGeM04=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1506.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24aeb94b-d7f8-468a-e8b7-08d93549e05b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2021 06:49:26.2331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TDH3I8w6zN4WProZd2sH9zaoWsxnvkS6FKdd+yzxN0AUAmk770j/nBO6Xu3N1ri1B3Ig2vglqzNFeBpxdiOlkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1702
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

PiBTdWJqZWN0OiBbU01CRElSRUNUXVtQQVRDSF0gbWlzc2luZyByYyBjaGVja3Mgd2hpbGUgd2Fp
dGluZyBmb3IgU01CMyBvdmVyDQo+IFJETUEgZXZlbnRzDQo+IA0KPiAgICAgVGhlcmUgd2VyZSB0
d28gcGxhY2VzIHdoZXJlIHdlIHdlcmVuJ3QgY2hlY2tpbmcgZm9yIGVycm9yDQo+ICAgICAoZS5n
LiBFUkVTVEFSVFNZUykgd2hpbGUgd2FpdGluZyBmb3IgcmRtYSByZXNvbHV0aW9uLg0KPiANCj4g
ICAgIEFkZHJlc3Nlcy1Db3Zlcml0eTogMTQ2MjE2NSAoIlVuY2hlY2tlZCByZXR1cm4gdmFsdWUi
KQ0KPiAgICBTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5j
b20+DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWJkaXJlY3QuYyBiL2ZzL2NpZnMvc21i
ZGlyZWN0LmMgaW5kZXgNCj4gMTBkZmU1MDA2NzkyLi5hZTA3NzMyZjc1MGYgMTAwNjQ0DQo+IC0t
LSBhL2ZzL2NpZnMvc21iZGlyZWN0LmMNCj4gKysrIGIvZnMvY2lmcy9zbWJkaXJlY3QuYw0KPiBA
QCAtNTcyLDggKzU3MiwxMSBAQCBzdGF0aWMgc3RydWN0IHJkbWFfY21faWQgKnNtYmRfY3JlYXRl
X2lkKA0KPiAgICAgICAgICAgICAgICAgbG9nX3JkbWFfZXZlbnQoRVJSLCAicmRtYV9yZXNvbHZl
X2FkZHIoKSBmYWlsZWQgJWlcbiIsIHJjKTsNCj4gICAgICAgICAgICAgICAgIGdvdG8gb3V0Ow0K
PiAgICAgICAgIH0NCj4gLSAgICAgICB3YWl0X2Zvcl9jb21wbGV0aW9uX2ludGVycnVwdGlibGVf
dGltZW91dCgNCj4gKyAgICAgICByYyA9IHdhaXRfZm9yX2NvbXBsZXRpb25faW50ZXJydXB0aWJs
ZV90aW1lb3V0KA0KPiAgICAgICAgICAgICAgICAgJmluZm8tPnJpX2RvbmUsIG1zZWNzX3RvX2pp
ZmZpZXMoUkRNQV9SRVNPTFZFX1RJTUVPVVQpKTsNCj4gKyAgICAgICAvKiAtRVJFU1RBUlRTWVMs
IHJldHVybmVkIHdoZW4gaW50ZXJydXB0ZWQsIGlzIHRoZSBvbmx5IHJjIG1lbnRpb25lZA0KPiAq
Lw0KPiArICAgICAgIGlmIChyYyA8IDApDQo+ICsgICAgICAgICAgICAgICBnb3RvIG91dDsNCj4g
ICAgICAgICByYyA9IGluZm8tPnJpX3JjOw0KPiAgICAgICAgIGlmIChyYykgew0KPiAgICAgICAg
ICAgICAgICAgbG9nX3JkbWFfZXZlbnQoRVJSLCAicmRtYV9yZXNvbHZlX2FkZHIoKSBjb21wbGV0
ZWQgJWlcbiIsIHJjKTsNCj4gQEAgLTU4Niw4ICs1ODksMTAgQEAgc3RhdGljIHN0cnVjdCByZG1h
X2NtX2lkICpzbWJkX2NyZWF0ZV9pZCgNCj4gICAgICAgICAgICAgICAgIGxvZ19yZG1hX2V2ZW50
KEVSUiwgInJkbWFfcmVzb2x2ZV9yb3V0ZSgpIGZhaWxlZCAlaVxuIiwgcmMpOw0KPiAgICAgICAg
ICAgICAgICAgZ290byBvdXQ7DQo+ICAgICAgICAgfQ0KPiAtICAgICAgIHdhaXRfZm9yX2NvbXBs
ZXRpb25faW50ZXJydXB0aWJsZV90aW1lb3V0KA0KPiArICAgICAgIHJjID0gd2FpdF9mb3JfY29t
cGxldGlvbl9pbnRlcnJ1cHRpYmxlX3RpbWVvdXQoDQo+ICAgICAgICAgICAgICAgICAmaW5mby0+
cmlfZG9uZSwgbXNlY3NfdG9famlmZmllcyhSRE1BX1JFU09MVkVfVElNRU9VVCkpOw0KPiArICAg
ICAgIGlmIChyYyA8IDApICAvKiBlLmcuIGlmIGludGVycnVwdGVkIGFuZCByZXR1cm5zIC1FUkVT
VEFSVFNZUyAqLw0KPiArICAgICAgICAgICAgICAgZ290byBvdXQNCj4gICAgICAgICByYyA9IGlu
Zm8tPnJpX3JjOw0KPiAgICAgICAgIGlmIChyYykgew0KPiAgICAgICAgICAgICAgICAgbG9nX3Jk
bWFfZXZlbnQoRVJSLCAicmRtYV9yZXNvbHZlX3JvdXRlKCkgY29tcGxldGVkICVpXG4iLCByYyk7
DQo+IA0KPiANCj4gLS0NCj4gVGhhbmtzLA0KPiANCj4gU3RldmUNCg0KUmV2aWV3ZWQtYnk6IExv
bmcgTGkgPGxvbmdsaUBtaWNyb3NvZnQuY29tPg0K
