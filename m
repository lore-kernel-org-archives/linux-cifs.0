Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24652C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Jun 2022 00:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiFCAWV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Jun 2022 20:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiFCAWU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Jun 2022 20:22:20 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020018.outbound.protection.outlook.com [52.101.61.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DF0FFA
        for <linux-cifs@vger.kernel.org>; Thu,  2 Jun 2022 17:22:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kkf8fzNF8xwDlzLUHxzKMcOtePW15aAHz8tkDxNYE+on+LZ74RM7zL3p53Ub0u2DGkNGtISAfiC17mvHSxoiTRwKxVRBpgZT3KT8Sb5X9EH9KZVDDSk2x4LNm2GGQX4gI3OCUtHJ6tO+O45ynGKDrYZ68SagI4PSc+QrPU8etnLP/626gmPh5cLQRA2DQdke5/YQdD+e+2RLXwjKTcVda5W/cHS5fXnhccmjSuH+3k8ZuJ3Ts5aAo7k5pk2Vtm1i0y2WCJWpUsVb3RiuhUh62Wt5Xk6ugpUOueSdWJtVlgnfFNM2rylePEzBl3E1rafkgzrO6Wv+8hd+HPEx2yJ/6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qKPbSv65Qjqt6V2g1WkN0jbAsL2o2aeSrhn5W22Y8Z8=;
 b=A36rEu/WZDdrI8jHp0z6y9Ih0r5JMhQsmJa0H6shvZrbEtHG+r8kmeYomx9mM6VinN1QqheVzPxXQ9A//eUR0/AytZHKFoYCU56rnSh1UV6tD5ZjUw6UnzZuSVgwEMhAgNc+0xCId/+nsho0+TwJxUgC5zCiMfDx08r92scwIs54SE/w85paw971VezeETFRZemHsNlsrz/pVrloSzmnGOupvzPrO2lC5I5qiuFcopFol/BiHeovLCZyAwiiBNEL/MWKrE2d1xKlEextTOfDE3MSk2AL+OjvOT5C/XwIU3wnq009HpnNZz8upsp7oocbeU8bHoNlTOKyF/epDAm/mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qKPbSv65Qjqt6V2g1WkN0jbAsL2o2aeSrhn5W22Y8Z8=;
 b=CrqxrvJg5xHCCPd0NbhsvqW5KiVNRVxRtS8zkiB0mwpLGbhiBn4GYKhNGGQC9UqZMiKZS16Uu5jXySf6qMl9WYYJxZZ2+ppz0r0g3GDEYTqfbR6TVMJ62WiGXctJMpOG9eSDQMFsMpeTrBMj8iud3lr1+lWnZx1DRvMq0/Imhx4=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by BL1PR21MB3234.namprd21.prod.outlook.com (2603:10b6:208:39a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.4; Fri, 3 Jun
 2022 00:07:47 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::25cf:72:6185:853c]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::25cf:72:6185:853c%6]) with mapi id 15.20.5332.005; Fri, 3 Jun 2022
 00:07:47 +0000
From:   Long Li <longli@microsoft.com>
To:     linkinjeon <linkinjeon@kernel.org>
CC:     tom <tom@talpey.com>, David Howells <dhowells@redhat.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: RE: RDMA (smbdirect) testing
Thread-Topic: RDMA (smbdirect) testing
Thread-Index: AQHYa8DmZteJXMAFqEqW9JAeO4Xmoq0m0pEAgAB0AoCAAMmbgIAAAsAAgAEolQCAAk43AIAA9YkAgAAWSoCAABDFAIAALPkAgABo7wCAAVERMIAOTR8AgAAI5GA=
Date:   Fri, 3 Jun 2022 00:07:47 +0000
Message-ID: <PH7PR21MB32638DEF77D5B541B3F0858CCEA19@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com>
 <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
 <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
 <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
 <84589.1653070372@warthog.procyon.org.uk>
 <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com>
 <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com>
 <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com>
 <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com>
 <307f1f2c-900b-8158-78a8-a3dd7564f2f8@talpey.com>
 <PH7PR21MB326344B83D7B4300683D2CEACED49@PH7PR21MB3263.namprd21.prod.outlook.com>
 <CAKYAXd861-sVicu3L-7QdctEZYfDtV5p=1t5E=gpr3e2Y3s2dQ@mail.gmail.com>
 <PH7PR21MB3263E3978006A32714AE5357CED79@PH7PR21MB3263.namprd21.prod.outlook.com>
 <CAKYAXd9SZQPkxO9TshgbHGbwzaDN1Hz6dhT-pNDYpD3icjB4HA@mail.gmail.com>
In-Reply-To: <CAKYAXd9SZQPkxO9TshgbHGbwzaDN1Hz6dhT-pNDYpD3icjB4HA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f682787b-9849-465a-be5d-0e9a2c09bb3b;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-06-03T00:03:51Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b63e097f-720c-4fd5-8f1b-08da44f51753
x-ms-traffictypediagnostic: BL1PR21MB3234:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BL1PR21MB3234FEE8A2BFE419671EC672CEA19@BL1PR21MB3234.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qKxa4nwOBPl7fw+tzJi6n3TnbHI2u9G6QV3mG782LSagdlVqoT+WDUCkQabkJXYq0DeA7kR5MfM44+U98nxZUNELllVaoi0wj89w92U7Z/2uYLaunpYyFA+H2gp8HUbIpMCEzDLHetxiAI1DRaht+IRVWZN9U5DQFjcJYvpeG9sRoSwRGfPwSLT+PKwcCNYGE8Dwg5MK4PH3YVFAM6Gfn/0FmTyfPyIYpHGOLz+5xxKNRVbeXpkvwO0mkyGSWonhnSo2E3grSrMnf/OxkryRoWOJOwiuRXOxE2DQ7S7cPiZdNbrmimJr5X7AYRmA6ooC+hH1epWDvofFpK+Cx9PHstvTj47+10MHqzbNDSM2hd2O3eYLv36CmmNSYkYdd7bXuWyaekHf04HczKyJc46qKlf3KFlVJevTND2WJ4hy/GaHJ2cMXwFrXRlDKw8JjJkkSU1Vi9Jzv1gsZaS2JuubQi9b+Xzj7n2p534fMRmK+kKSRcBJQQtbSyzmpyd0C2dM8zdcGsWZOIfUo+tnVwYavEu1+dU9ARAm6SaH1zopDhIgy8jxuhfndUBhd4yL9FKItEM4yzR1wI3jd0IGv8Ia3zgLB6BycatAcmzpkoGjju8nOfiyJHjxITnNCYReXROjj+LvEAzCUhDmC5YJBMIu7XZ9F03J6NJaPrXS45YK1NZuOaF84/1KTkjHb29DdJh6sAD0wlTE4bFvIafqqqYoMxkgPNwMQxkAhRW2CJTocdGRFl6Wo8PKPgh+aEBN1ekJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(10290500003)(54906003)(8990500004)(6916009)(52536014)(71200400001)(5660300002)(86362001)(316002)(66476007)(66946007)(66446008)(66556008)(76116006)(38100700002)(186003)(8936002)(122000001)(8676002)(2906002)(508600001)(33656002)(4326008)(64756008)(82950400001)(82960400001)(9686003)(38070700005)(7696005)(83380400001)(6506007)(55016003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0FHZG1VWDVWa1RzZGZ2M1l1Z1g3cEQyNXE2QTlnYkpNR1o4TjB1QnZIRUpT?=
 =?utf-8?B?UzNQZ1RuUmJicGxkY2FiTUN3dzByUmNIMzVlOFY2RHVwYzU4VitvMVNNQU1W?=
 =?utf-8?B?cWkxUEorQWtRZ016bjhQVjg3dXJEMGdGNk5TcHRkTHQ1ZUV3N21kU2ZwVnRw?=
 =?utf-8?B?UXJjSHp5Njl5QUVTdEYrdG13QkJWMEhFWVI3Z3FEa2YzSlhqWUxTa2dMMkJR?=
 =?utf-8?B?L1d2MnBDQkdyWVlrTXFNcVl3RFZMb0ovU0FYUW5OWXhPN2Y3K09EcjM1V3JG?=
 =?utf-8?B?RkY4cEVHVzVLVEYyOFVCMkl5eXBXY05mdTZ5aDA5S3AxSnVSdFpPQmlZVkxY?=
 =?utf-8?B?dXd5aGtYNzdiaDVrdWZKL3crU21Sakx1VG0zMEtZMk1oOGN0d1ZiRXBMa3E4?=
 =?utf-8?B?U0x5WkhuQTd4Y1ZLVk5HbkVtcHZnZUwwYVF4MnRCWHE4N2kzNFlkR2U2bDEy?=
 =?utf-8?B?MUZ4cjgzQ2p2RWhsamd1Mm5QNlh6M0xhS0IwK2dUcFZjYzVxdzJnN1RVYlhT?=
 =?utf-8?B?OTVUNDVQUmRNeURZZFRKcUhFcEF4dXB4cnpJdjBsN3FFcGpIS2NYVHd0aXkz?=
 =?utf-8?B?QisyWkQ2cDdwcWkrRm9DK29YNHV5T3RMcUhZQ2Fwb05xM2htVlNRYUhXL0ta?=
 =?utf-8?B?d0kyNjdsY2ZROVFJOTd0eVl4eUZMVlo4ZmdiamZORUVMNFZJdWpqVnY2RFVO?=
 =?utf-8?B?TEs1bThFcFVnR09GUEVtNVRlbnpsdVRmcE1tWlBRbWtmVlU4RVdhM05la3FB?=
 =?utf-8?B?eXIvZk55SWpkMXozVnh5NlFYM0szb3RHQU14bXlTMGFYdlMxNVJxM2hJQlhH?=
 =?utf-8?B?RWtwL0VjbXFBc3JLM1NGVmFpZTgyR2ptNnA3MU1kUk1VNmEybUxxTG53bWdy?=
 =?utf-8?B?ZnFkQWU4RFFhMTJUTDc2V0dKbURUZW5WZWNEeDYyRExBMTdRVUlxU0pNVjhp?=
 =?utf-8?B?eEpPQmFpbjFSdkNWREM3ZGk1bUw5cll0SEM2SXBZbGcvRk5zTlJPK0tGZFRX?=
 =?utf-8?B?VUlsZUUvL2wxTkxVSlV1c0pxVm8zbmJiVk8xeno3T0VJUzJPcDJuM1RpZTJl?=
 =?utf-8?B?OCthQUdsWUE5ZkVvVkd6V2hjK0hwRWlqVGVnRjdydWJnQ05jZ2wvdCtMZ3Q1?=
 =?utf-8?B?VTI4VXAzekYyYzZWcGlLNDlzbzVuRzhSd1lIYllRaTQwbXpKUzdxT3FydGhG?=
 =?utf-8?B?ZDZtajUvN20zRGIwaHVtM3VaZ1B4OWhYUTlEUE1NaER0elI3SzhsdUFWZFA1?=
 =?utf-8?B?MUVZYWkwV2o1bWpVWGNXK201N3lnWFkzN3U4WUNUUitlTno2Q1F2dElpdkpq?=
 =?utf-8?B?eDlPR2VseTRGVmZwT3dVWjU3S2JpRzlUeklsenZtMHViU2F3d2E5Sjg1ODE2?=
 =?utf-8?B?T2ttQkxqU0Jab0s2SEs0ZEsrVWp6WURjMXNzTlVnaWsrQ2prK3lVSjVXSXdr?=
 =?utf-8?B?dFFJbkgzNWc2YlhxWDJyVGR2TW1LaEdxclpFSTJYdDltc0tGWStzbkMzd2NY?=
 =?utf-8?B?Mll1c0RUVEh6eXdVaDl6Z0E4WjNua2VXTkM5clJqVU9FRDhRUm1vSDhoNVdw?=
 =?utf-8?B?SncxZEtuUU5BbGo1K3QyeWFDaXhFekZmT1BLUXBCMEx2NTVqMFk0TEZLYmE4?=
 =?utf-8?B?emFTc0E1ZzF4NFU5TUI3cm1NcWNhYjBSeWt3S25SbFM1U1FvYWM2TW85WVdh?=
 =?utf-8?B?S2Ewc3ZSanRPam9HRG5sdWhpUmlUK1BacmVodWN5c2JwNU11WVhiQjBJOVVx?=
 =?utf-8?B?RXFxY3lNeDRFNXE3c3ZhWGNZUEZIbUNtaFF1V2FXT0VoUG0wN1FpWitERFpk?=
 =?utf-8?B?N1JUOUVTdzZUdHRiUlVkV1pNSnUzd1k0cktqMEQ0dVYzU2NpODNGVGw4WWVB?=
 =?utf-8?B?V0xsSW1RZDdSRS9Od1UyeWpzN2xOL2JjOVNJb0RBVkcvNk5sdnlKbUNnZHA1?=
 =?utf-8?B?emxacGZOZldXb09QOTBTVDFFUHV2TXhkWTZUMnArYWhmejArcjdhRDNaL0VC?=
 =?utf-8?B?TTgrditwVTJMV3NBelZKZzE0VnRQdFE5bVBJYm1RVEpBelJ6R0Y1RlAwZjZ2?=
 =?utf-8?B?clF5eGVUbGlOTTB4dVd3L0xKc2tXbCtEWVM4TVcvMWs4dlY4VnkvUWdPRk9T?=
 =?utf-8?B?NWhCRjUxczRoT3ZVQUU4QnkyNTBoK3N3cHlMQm9RM1ZHWjluL2lzT3BVaE43?=
 =?utf-8?B?TlY3eWdSUSs5aWFySmJvMzhKU1JxWkxlK2U1UEZVNWcydUtpZGw5V29BUVBU?=
 =?utf-8?B?clVSaGsxSTdUamd4YlFhVU1ueS9sTnF1L013czFCcHd6WHhHSjhrMjZiSzIr?=
 =?utf-8?B?MlJoUWZSVnVuMDRSL0FHUlE5UUJXSDhXcGgzaTNNdWt5ZTR3R2VxUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b63e097f-720c-4fd5-8f1b-08da44f51753
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2022 00:07:47.4906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6S+sW9dVPp0RI98RzzUVMWoGHVuIJGzKeZsKjx7rpzvjqTH1SnBYChdX+IxqcZM9DmdJ/5mz3e+Oedcdjbxyig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR21MB3234
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

PiBMb25nLCBNeSBDaGVsc2lvKGlXQVJQKSBOSUMgcmVwb3J0cyB0aGlzIHZhbHVlIGFzIDQuIFdo
ZW4gSSBzZXQgaXQgd2l0aCBodw0KPiByZXBvcnQgdmFsdWUgaW4gY2lmcy5rbywgVGhlcmUgaXMg
a2VybmVsIG9vcHMgaW4gY2lmcy5rby4gSGF2ZSB5b3UgY2hlY2tlZCBzbWItDQo+IGRpcmVjdCBv
ZiBjaWZzLmtvIHdpdGggQ2hlbHNpbyBhbmQgYW55IGlXQVJQIE5JQ3MgYmVmb3JlID8gb3Igb25s
eSBNZWxsYW5veA0KPiBOSUNzID8NCj4gDQo+IFRoYW5rcyENCg0KWWVzLCBJIGhhdmUgdGVzdGVk
IG9uIENoZWxzaW8uIEkgZGlkbid0IHNlZSBrZXJuZWwgcGFuaWMuIEluIGZhY3QsIEkgY2FuIHBh
c3MgYSBsYXJnZXIgdmFsdWUgKDgpIGFuZCBzdWNjZXNzZnVsbHkgY3JlYXRlIGEgUVAgb24gQ2hl
bHNpby4NCg0KQ2FuIHlvdSBwYXN0ZSB5b3VyIGtlcm5lbCBwYW5pYyB0cmFjZT8NCg0KPiA+PiA+
IElmIHRoZSBDSUZTIHVwcGVyIGxheWVyIGV2ZXIgc2VuZHMgZGF0YSB3aXRoIGxhcmdlciBudW1i
ZXIgb2YgU0dFcywNCj4gPj4gPiB0aGUgc2VuZCB3aWxsIGZhaWwuDQo+ID4+ID4NCj4gPj4gPiBM
b25nDQo+ID4+ID4NCj4gPj4gPj4NCj4gPj4gPj4gVG9tLg0KPiA+PiA+Pg0KPiA+PiA+PiA+IGRp
ZmYgLS1naXQgYS9mcy9jaWZzL3NtYmRpcmVjdC5oIGIvZnMvY2lmcy9zbWJkaXJlY3QuaCBpbmRl
eA0KPiA+PiA+PiA+IGE4N2ZjYTgyYTc5Ni4uNzAwMzcyMmFiMDA0IDEwMDY0NA0KPiA+PiA+PiA+
IC0tLSBhL2ZzL2NpZnMvc21iZGlyZWN0LmgNCj4gPj4gPj4gPiArKysgYi9mcy9jaWZzL3NtYmRp
cmVjdC5oDQo+ID4+ID4+ID4gQEAgLTIyNiw3ICsyMjYsNyBAQCBzdHJ1Y3Qgc21iZF9idWZmZXJf
ZGVzY3JpcHRvcl92MSB7DQo+ID4+ID4+ID4gICB9IF9fcGFja2VkOw0KPiA+PiA+PiA+DQo+ID4+
ID4+ID4gICAvKiBEZWZhdWx0IG1heGltdW0gbnVtYmVyIG9mIFNHRXMgaW4gYSBSRE1BIHNlbmQv
cmVjdiAqLw0KPiA+PiA+PiA+IC0jZGVmaW5lIFNNQkRJUkVDVF9NQVhfU0dFICAgICAgMTYNCj4g
Pj4gPj4gPiArI2RlZmluZSBTTUJESVJFQ1RfTUFYX1NHRSAgICAgIDYNCj4gPj4gPj4gPiAgIC8q
IFRoZSBjb250ZXh0IGZvciBhIFNNQkQgcmVxdWVzdCAqLw0KPiA+PiA+PiA+ICAgc3RydWN0IHNt
YmRfcmVxdWVzdCB7DQo+ID4+ID4+ID4gICAgICAgICAgc3RydWN0IHNtYmRfY29ubmVjdGlvbiAq
aW5mbzsgZGlmZiAtLWdpdA0KPiA+PiA+PiA+IGEvZnMva3NtYmQvdHJhbnNwb3J0X3JkbWEuYyBi
L2ZzL2tzbWJkL3RyYW5zcG9ydF9yZG1hLmMgaW5kZXgNCj4gPj4gPj4gPiBlNjQ2ZDc5NTU0Yjgu
LjcwNjYyYjNiZDU5MCAxMDA2NDQNCj4gPj4gPj4gPiAtLS0gYS9mcy9rc21iZC90cmFuc3BvcnRf
cmRtYS5jDQo+ID4+ID4+ID4gKysrIGIvZnMva3NtYmQvdHJhbnNwb3J0X3JkbWEuYw0KPiA+PiA+
PiA+IEBAIC00Miw3ICs0Miw3IEBADQo+ID4+ID4+ID4gICAvKiBTTUJfRElSRUNUIG5lZ290aWF0
aW9uIHRpbWVvdXQgaW4gc2Vjb25kcyAqLw0KPiA+PiA+PiA+ICAgI2RlZmluZSBTTUJfRElSRUNU
X05FR09USUFURV9USU1FT1VUICAgICAgICAgICAxMjANCj4gPj4gPj4gPg0KPiA+PiA+PiA+IC0j
ZGVmaW5lIFNNQl9ESVJFQ1RfTUFYX1NFTkRfU0dFUyAgICAgICAgICAgICAgIDgNCj4gPj4gPj4g
PiArI2RlZmluZSBTTUJfRElSRUNUX01BWF9TRU5EX1NHRVMgICAgICAgICAgICAgICA2DQo+ID4+
ID4+ID4gICAjZGVmaW5lIFNNQl9ESVJFQ1RfTUFYX1JFQ1ZfU0dFUyAgICAgICAgICAgICAgIDEN
Cj4gPj4gPj4gPg0KPiA+PiA+PiA+ICAgLyoNCj4gPj4gPj4gPg0KPiA+PiA+PiA+IFRoYW5rcyEN
Cj4gPj4gPj4gPj4NCj4gPj4gPj4gPj4gVG9tLg0KPiA+PiA+PiA+Pg0KPiA+PiA+PiA+DQo+ID4+
ID4NCj4gPg0K
