Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF6A0C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 23 May 2022 19:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiEWTcx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 May 2022 15:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiEWTco (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 May 2022 15:32:44 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11021015.outbound.protection.outlook.com [52.101.62.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4A536E21
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 12:17:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ORxG0iH7F+PQ3p4VCtSmkXcHnHyZBBOPRhuTW4sKnlxo6PvyRZdyJyMQpxt+UyQDTS2glmERD1BatMLpLa+ciWWmHLPKFUZMz9o0JzoubHr55g1BBCbKx50oLydQ2zV4unMDvPp7sBRtQ3aZu5m5VY+pvN3zStmWf1ZrwKVJjuAL2j2sn6kcmrG5y+suF8PQ8pAgYZQUARfGw4F7qj9YXBl3HX0q1E332858BMVETxuZTp+5E5+pwAGYbfSnabU0M3gywsHiOE5YsiLf2Itpqz1FvLfS4YYt2yHSmc4gX1rHBsnHSPxS9S6E4ZxIFTwB+H/4zAqVWJUAAFianwYbLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FTIbc12g/ruHzWX4f5Rmz3ldGGAnaC6IItiFKIlc9B0=;
 b=EXwyjV3083PuaUoWLIdDjuYOzFbb9rb4shyQ8Bzb0ZXyc0wq503tAaFbdW2FzFXUVe2SFg77ob2Tpcxwo9gsitxbi48etJo48/P1aiE2QVveEmwRyuggPyUyACeaA3wHvD0NGCk4RwP7AGbBIOPr4q6pzPayv1DVVnoEY+OdPFRid1lJssZtgwyT+XXF7d4SmKMF6OtNFpPWmQBwlOWcH5vLaAZzft2rLX1lXvUW7l6FGw/RBH9Pyg8V6dit/6b5xBuMsx/aflDCN1fhKAquG3DYCahH9dOmEwEWFuIxcTHQnFy1wIo2LmaK8gsywL+2ZOpS6J7jmvLZnUFW3SWn+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FTIbc12g/ruHzWX4f5Rmz3ldGGAnaC6IItiFKIlc9B0=;
 b=bKVj9Zd59LigyNcufKRJGKzILo1Sc+wLw+TOmTAwqkBjfPbDFCrcVolNFj5RpQg2nBGiVdk9QYT+r6ciHNLl3O8jyubSBR1sT4czn4VW2uA8jRVq4PouysHE8z4cmL0M9yHsCuXyANBEU9yHO6/sIPtHGGlumkJedO7vKG71bxY=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by BY5PR21MB1457.namprd21.prod.outlook.com (2603:10b6:a03:21f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.3; Mon, 23 May
 2022 19:17:11 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::bdc5:cad:529a:4cdd]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::bdc5:cad:529a:4cdd%7]) with mapi id 15.20.5293.007; Mon, 23 May 2022
 19:17:11 +0000
From:   Long Li <longli@microsoft.com>
To:     tom <tom@talpey.com>, linkinjeon <linkinjeon@kernel.org>
CC:     David Howells <dhowells@redhat.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: RE: RDMA (smbdirect) testing
Thread-Topic: RDMA (smbdirect) testing
Thread-Index: AQHYa8DmZteJXMAFqEqW9JAeO4Xmoq0m0pEAgAB0AoCAAMmbgIAAAsAAgAEolQCAAk43AIAA9YkAgAAWSoCAABDFAIAALPkA
Date:   Mon, 23 May 2022 19:17:11 +0000
Message-ID: <PH7PR21MB326344B83D7B4300683D2CEACED49@PH7PR21MB3263.namprd21.prod.outlook.com>
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
In-Reply-To: <307f1f2c-900b-8158-78a8-a3dd7564f2f8@talpey.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=260fab37-7d96-4cad-aee8-9fec5664cdd4;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-05-23T18:46:23Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b10f10ea-3f5d-4d71-3cb4-08da3cf0d67e
x-ms-traffictypediagnostic: BY5PR21MB1457:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BY5PR21MB1457185D74206146FA89E60ECED49@BY5PR21MB1457.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cJ+5aCQh4Yn5BqULXY15VMFi4TeCKLPYXBCSYtApaZbD6+uXNdxpSNpAYd3srUWkE9wBPWiaRAEcighdmnPQ7KZe5YqXJ2+aDKQhAHy9IeSzz7BZBgQhrpLgJVeBpTLUBGbBUZheO1NDbVbDzTOocTPEYrHD85bdgtQ7qBcn8kbJGxS5F/Njp3CfBsyClb5fgeq/pMT8yJUH6T2UXa+YzGVYFTBhbmvl/V8EWG21HHG9Dq1yvkPTwhyBTDdG1cMMCjJhB4JCeAyefE4NP2Uvxz0d0Ka5VXc6cDUZ8l0DZvQxEN4Y32IR/7wzoNwxHmMPbKffzawpMwcQAfE3XBoNLYCqpo3nbZkEz2nohM3kM+F9L4LXouZgZr/++W5XRNNGZgLCickY71Uru9dbS9sJoub7uIxu7m+AI1ciuOkBe+gmBMAwogJ6oqLT6fK1mGOL9uUa9W/hnwTQmF4KZxIm3SqPXIrHSq685ovJnGZp7FecjgPeQ9Q0j/ifXVzPO4n+Dzljva3l3e8CSUMCfU/bSBy0ZoJQ0kyH523auheOkBG5Q/CmmqVV0OuEx3AXEYPr7ALUlW6d4N1408frq0MMl91pk8wodBJczTm3xI8uDaU6jmjmpue4YZM0seUQxr/uDsSz2cY9V16NtseV2n5sF6tIHVbYsTJbMkK8Demt5hR5mfsKbkD9IcH5YnnfmgvEo2PuJdDmPVUzInmjQsDHoQr7+gqdpUysa3wIhwwg24+YgIjpJTB89hJMd3pg8qZW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(38100700002)(316002)(54906003)(5660300002)(110136005)(9686003)(66946007)(71200400001)(33656002)(4326008)(55016003)(8676002)(66556008)(64756008)(66446008)(66476007)(38070700005)(122000001)(10290500003)(83380400001)(2906002)(26005)(508600001)(52536014)(86362001)(8936002)(7696005)(186003)(82950400001)(8990500004)(76116006)(82960400001)(53546011)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RC9zQkNBRWZYSUY3SUtmbHlvK1JtUFlVK3VFN2w2ejhTSDdmRnZzVmdyM0NX?=
 =?utf-8?B?ZTRpOUZyRnNRYVVJeStzWmw1SVZTOVo2b1JHVVU3bUI1bEFXNE9RRnJVWm1h?=
 =?utf-8?B?TXJzMEMzaGU3enpWTXdIcWxlRWVRNVBaZStROXVtcGlNUHZFVWEyU1FjRnZs?=
 =?utf-8?B?VHF6WmlZaUt3U0N1OUdseEZHdmNEUXZOSDB3YTZuL3BmZWZXc0xrUkZtNTUw?=
 =?utf-8?B?YVB3U0pNa0RHYitsRmZuTmUwSnpBT0piVEFYTnhSbWNLVE5mS3IxekU5RlIw?=
 =?utf-8?B?L2NtVW1TZ21Cb3ByODZpVG9ERTExbE1mempRWUJ5WEVTdS9OTkx5WVFYNlVB?=
 =?utf-8?B?cE56NHJ4V2hCWEJBRmxkcHk2QVRzc01JaFZEVklybktKNWlkZU9ZR2ZLeFFO?=
 =?utf-8?B?eU0veCs1dVFMdG1UdnRKTDQvV1RFOE02SStQTFM3WmF5OHJTNVZ6eFpraVM3?=
 =?utf-8?B?Mk5CaXZvK0hheTY3OVlFbDcySEVwM3RmMXZib1hKdFp0LzdEZlBjSVl3TEJm?=
 =?utf-8?B?d3V1RnY1bjRSbGtSWHBnb1BVQ1c4TWY2V0s2QWMwYnpmOUVYMVhQSDRzdHlx?=
 =?utf-8?B?bmYvWFFwd1FudnNqd0IrK25IbHczY2lCZUJTMWhqWmRsNUNrWjNPSjg1MHNC?=
 =?utf-8?B?RUs1ckU4MWE5T2FlWFo1amZtdE1WSHE0bkFSK3h5VThmdUdSRXVNVFk2WXNU?=
 =?utf-8?B?WTFGL1JKckhMb05OWlMxcWM1VWhXRmtQNEcxdDBDNDNzTHJkdEZGRTd3NXE2?=
 =?utf-8?B?ZGdjTFNFS0M3VXRZbEZYaERIWUpycVQxd2ROK0NDaVkvRExCcFRwVzBJRVIr?=
 =?utf-8?B?RExudUFnakZGSGdjQmx1UmtPSTZkblB1N1RVdlI5VGhlblN5WXhnQy82a056?=
 =?utf-8?B?NERFMFdmbkpGV2hzTEZIUGd6bjNISUFtbXYxSzBFbXdDNW85cEUzM1ZzaEsr?=
 =?utf-8?B?ZythYzZrN1lXdHdobTFzM3BmRDJpS3Fyc0liVnlOdzN1eW9XUWE3RExVMUdI?=
 =?utf-8?B?NDBEYnVMclRKbTExeVpOYmR3eDByaWp3a0RNMWJiSmY0Y3NSVERQUE14dVgx?=
 =?utf-8?B?VEZaRWlZTTNHcTMzUWV5SG4rNFowb2hQWE9nZUZPSkpyK1IrUjhCQk1YU3VX?=
 =?utf-8?B?T083TDhFSlNWSEFzdEVQVHNjR0Q0d3hUQ2F2aUpjN1dZOEtYaVl2d2pBc2FG?=
 =?utf-8?B?R1dIMnJPZm5SN1c5RWZCalZMWEdkVGFXNEEvRWZqSHdQVllHdVBoeXUwaXR6?=
 =?utf-8?B?aDFwUXlnK1h6TWRZMVl4MmxPOUpaTEg1ZGNZOVBWQ3BrU0FDSEZHWnhlSjJi?=
 =?utf-8?B?UUVxTU5qYXZGdHdLZmlzemJwdE9xc3o2azl3cE4zUzJlem1UaFZDMGExbkQz?=
 =?utf-8?B?Z2tSU2VGRHNBZkM2MUFMRmFYTjlNa3hkWnNHZ2hEZ2JNTE1SQ0crNFBHZ2JQ?=
 =?utf-8?B?dGJaMTNvTjlHUmpkMlNwZ1poS1I5YTNNTUM3SnB6MDRjN29RNDBwT01TRmtB?=
 =?utf-8?B?RmE1WTI1YkNNNTh4Q3pXN1BNOC9NQkMzNDc0a25jb1AvRHRqMlp6eGppczA3?=
 =?utf-8?B?V0ZUMm1KUUJoZUowL2hnQTM0N00vazVrcnN5Ti9YRmNNbkw0SzdKbElOM0ZI?=
 =?utf-8?B?OXNCa3R4aXVCL3c4ZDJseUk5VVpFTFhhbmhMUE9IaFJCQ0VKblY5OUk0NHQr?=
 =?utf-8?B?alVPVUw3OTcyS0tWK1J1ekw5eTAxczVBdTRHcEVzU3h2MHV1WnBQb3FWVDlV?=
 =?utf-8?B?VmlZRU1wTVlhWEZjeUt2U25CdWxrbHlOY1hpUGJBWEs5TTU1VXhibFZ3ZitL?=
 =?utf-8?B?N1JzTVNMRUhzSzV5L3huaUNZOFE2VkUvbCtpNm5JbUNLR1ZyT3FNVG4xVFRP?=
 =?utf-8?B?NXd0NTNoaXpzL2NNRVNkSk9BUWw0di81MkNGNDBGbWI3MjNNaWJVZnJRRjVT?=
 =?utf-8?B?YUFTNUxUOHVxc1RMOVdJaGxvZG9pTm5qZlk1ME5TMnRTUlBKTENZWHNUVFNN?=
 =?utf-8?B?b0hmUm03WWhxakxzbXJoR1QvQWU4KzRCZzE0T2MyTytxWXF5OWNKYUJKa21j?=
 =?utf-8?B?K1d5K3pSV0JtR01majU5YlNxRFJnd25BL3hoTFR4cGRTeUdtajVrOXd3citR?=
 =?utf-8?B?QjAyZ3BrYUFkdE5FQ3ltbENDcEw3aEo0RytBcERpVGQyekpjSE1iaWxkN1Vu?=
 =?utf-8?B?ZHo5VHVwNjk2anlmQ2hJaEdISEZFSUJ3ZExSdmdLRmV0MHM4OXloTi9YYTFj?=
 =?utf-8?B?ek9XTU03Y29mcUFPcG8xaDk2YVhhQUI1SzkvSFVaRnJwVUxkNTNiNWZTOURK?=
 =?utf-8?B?RTFueU9teGRLQzhDS2orZE9UK1dRVmNwOVFQMmhQN0pyNTZDMlRXUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b10f10ea-3f5d-4d71-3cb4-08da3cf0d67e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2022 19:17:11.3811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9olTPBMsvO2aJdjTj+mgbLj/fOVSnVqtr80GqQ9zK1iiKF/TSOItEKRm9fkeKePAHCzxGyTRsYPRUJDKklgdyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1457
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

PiBTdWJqZWN0OiBSZTogUkRNQSAoc21iZGlyZWN0KSB0ZXN0aW5nDQo+IA0KPiBPbiA1LzIzLzIw
MjIgMTE6MDUgQU0sIE5hbWphZSBKZW9uIHdyb3RlOg0KPiA+IDIwMjItMDUtMjMgMjI6NDUgR01U
KzA5OjAwLCBUb20gVGFscGV5IDx0b21AdGFscGV5LmNvbT46DQo+ID4+IE9uIDUvMjIvMjAyMiA3
OjA2IFBNLCBOYW1qYWUgSmVvbiB3cm90ZToNCj4gPj4+IDIwMjItMDUtMjEgMjA6NTQgR01UKzA5
OjAwLCBUb20gVGFscGV5IDx0b21AdGFscGV5LmNvbT46DQo+ID4+Pj4gLi4uDQo+ID4+Pj4gV2h5
IGRvZXMgdGhlIGNvZGUgcmVxdWlyZQ0KPiA+Pj4+IDE2IHNnZSdzLCByZWdhcmRsZXNzIG9mIG90
aGVyIHNpemUgbGltaXRzPyBOb3JtYWxseSwgaWYgdGhlIGxvd2VyDQo+ID4+Pj4gbGF5ZXIgc3Vw
cG9ydHMgZmV3ZXIsIHRoZSB1cHBlciBsYXllciB3aWxsIHNpbXBseSByZWR1Y2UgaXRzIG9wZXJh
dGlvbiBzaXplcy4NCj4gPj4+IFRoaXMgc2hvdWxkIGJlIGFuc3dlcmVkIGJ5IExvbmcgTGkuIEl0
IHNlZW1zIHRoYXQgaGUgc2V0IHRoZQ0KPiA+Pj4gb3B0aW1pemVkIHZhbHVlIGZvciB0aGUgTklD
cyBoZSB1c2VkIHRvIGltcGxlbWVudCBSRE1BIGluIGNpZnMuDQo+ID4+DQo+ID4+ICJPcHRpbWl6
ZWQiIGlzIGEgZnVubnkgY2hvaWNlIG9mIHdvcmRzLiBJZiB0aGUgcHJvdmlkZXIgZG9lc24ndA0K
PiA+PiBzdXBwb3J0IHRoZSB2YWx1ZSwgaXQncyBub3QgbXVjaCBvZiBhbiBvcHRpbWl6YXRpb24g
dG8gaW5zaXN0IG9uIDE2Lg0KPiA+PiA6KQ0KPiA+IEFoLCBJdCdzIG9idmlvdXMgdGhhdCBjaWZz
IGhhdmVuJ3QgYmVlbiB0ZXN0ZWQgd2l0aCBzb2Z0LWlXQVJQLiBBbmQNCj4gPiB0aGUgc2FtZSB3
aXRoIGtzbWJkLi4uDQo+ID4+DQo+ID4+IFBlcnNvbmFsbHksIEknZCB0cnkgYnVpbGRpbmcgYSBr
ZXJuZWwgd2l0aCBzbWJkaXJlY3QuaCBjaGFuZ2VkIHRvDQo+ID4+IGhhdmUgU01CRElSRUNUX01B
WF9TR0Ugc2V0IHRvIDYsIGFuZCBzZWUgd2hhdCBoYXBwZW5zLiBZb3UgbWlnaHQgaGF2ZQ0KPiA+
PiB0byByZWR1Y2UgdGhlIHIvdyBzaXplcyBpbiBtb3VudCwgZGVwZW5kaW5nIG9uIGFueSBvdGhl
ciBpc3N1ZXMgdGhpcw0KPiA+PiBtYXkgcmV2ZWFsLg0KPiA+IEFncmVlZCwgYW5kIGtzbWJkIHNo
b3VsZCBhbHNvIGJlIGNoYW5nZWQgYXMgd2VsbCBhcyBjaWZzIGZvciB0ZXN0LiBXZQ0KPiA+IGFy
ZSBwcmVwYXJpbmcgdGhlIHBhdGNoZXMgdG8gaW1wcm92ZSB0aGlzIGluIGtzbWJkLCByYXRoZXIg
dGhhbg0KPiA+IGNoYW5naW5nL2J1aWxkaW5nIHRoaXMgaGFyZGNvZGluZyBldmVyeSB0aW1lLg0K
PiANCj4gU28sIHRoZSBwYXRjaCBpcyBqdXN0IGZvciB0aGlzIHRlc3QsIHJpZ2h0PyBCZWNhdXNl
IEkgZG9uJ3QgdGhpbmsgYW55IGtlcm5lbC1iYXNlZA0KPiBzdG9yYWdlIHVwcGVyIGxheWVyIHNo
b3VsZCBldmVyIG5lZWQgbW9yZSB0aGFuIDIgb3IgMy4NCj4gSG93IG1hbnkgbWVtb3J5IHJlZ2lv
bnMgYXJlIHlvdSBkb2luZyBwZXIgb3BlcmF0aW9uPyBJIHdvdWxkIGV4cGVjdCBvbmUgZm9yDQo+
IHRoZSBTTUIzIGhlYWRlcnMsIGFuZCBhbm90aGVyLCBpZiBuZWVkZWQsIGZvciBkYXRhLg0KPiBU
aGVzZSB3b3VsZCBhbGwgYmUgbG1yLXR5cGUgYW5kIHdvdWxkIG5vdCByZXF1aXJlIGFjdHVhbCBu
ZXcgbWVtcmVnJ3MuDQo+IA0KPiBBbmQgZm9yIGJ1bGsgZGF0YSwgSSB3b3VsZCBob3BlIHlvdSdy
ZSB1c2luZyBmYXN0LXJlZ2lzdGVyLCB3aGljaCB0YWtlcyBhDQo+IGRpZmZlcmVudCBwYXRoIGFu
ZCBkb2Vzbid0IHVzZSB0aGUgc2FtZSBzZ2Uncy4NCj4gDQo+IEdldHRpbmcgdGhpcyByaWdodCwg
YW5kIGtlZXBpbmcgdGhpbmdzIGVmZmljaWVudCBib3RoIGluIFNHRSBib29ra2VlcGluZyBhcyB3
ZWxsDQo+IGFzIG1lbW9yeSByZWdpc3RyYXRpb24gZWZmaWNpZW5jeSwgaXMgdGhlIHJvY2tldCBz
Y2llbmNlIGJlaGluZCBSRE1BDQo+IHBlcmZvcm1hbmNlIGFuZCBjb3JyZWN0bmVzcy4gU2xhcHBp
bmcgIjE2IiBvciAiNiIgb3Igd2hhdGV2ZXIgaXNuJ3QgdGhlIGxvbmctDQo+IHRlcm0gZml4Lg0K
DQpJIGZvdW5kIG1heF9zZ2UgaXMgZXh0cmVtZWx5IGxhcmdlIG9uIE1lbGxhbm94IGhhcmR3YXJl
LCBidXQgc21hbGxlciBvbiBvdGhlciBpV0FSUCBoYXJkd2FyZS4NCg0KSGFyZGNvZGluZyBpdCB0
byAxNiBpcyBjZXJ0YWlubHkgbm90IGEgZ29vZCBjaG9pY2UuIEkgdGhpbmsgd2Ugc2hvdWxkIHNl
dCBpdCB0byB0aGUgc21hbGxlciB2YWx1ZSBvZiAxKSBhIHByZWRlZmluZWQgdmFsdWUgKGUuZy4g
OCksIGFuZCB0aGUgMikgdGhlIG1heF9zZ2UgdGhlIGhhcmR3YXJlIHJlcG9ydHMuDQoNCklmIHRo
ZSBDSUZTIHVwcGVyIGxheWVyIGV2ZXIgc2VuZHMgZGF0YSB3aXRoIGxhcmdlciBudW1iZXIgb2Yg
U0dFcywgdGhlIHNlbmQgd2lsbCBmYWlsLg0KDQpMb25nDQoNCj4gDQo+IFRvbS4NCj4gDQo+ID4g
ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iZGlyZWN0LmggYi9mcy9jaWZzL3NtYmRpcmVjdC5oIGlu
ZGV4DQo+ID4gYTg3ZmNhODJhNzk2Li43MDAzNzIyYWIwMDQgMTAwNjQ0DQo+ID4gLS0tIGEvZnMv
Y2lmcy9zbWJkaXJlY3QuaA0KPiA+ICsrKyBiL2ZzL2NpZnMvc21iZGlyZWN0LmgNCj4gPiBAQCAt
MjI2LDcgKzIyNiw3IEBAIHN0cnVjdCBzbWJkX2J1ZmZlcl9kZXNjcmlwdG9yX3YxIHsNCj4gPiAg
IH0gX19wYWNrZWQ7DQo+ID4NCj4gPiAgIC8qIERlZmF1bHQgbWF4aW11bSBudW1iZXIgb2YgU0dF
cyBpbiBhIFJETUEgc2VuZC9yZWN2ICovDQo+ID4gLSNkZWZpbmUgU01CRElSRUNUX01BWF9TR0Ug
ICAgICAxNg0KPiA+ICsjZGVmaW5lIFNNQkRJUkVDVF9NQVhfU0dFICAgICAgNg0KPiA+ICAgLyog
VGhlIGNvbnRleHQgZm9yIGEgU01CRCByZXF1ZXN0ICovDQo+ID4gICBzdHJ1Y3Qgc21iZF9yZXF1
ZXN0IHsNCj4gPiAgICAgICAgICBzdHJ1Y3Qgc21iZF9jb25uZWN0aW9uICppbmZvOyBkaWZmIC0t
Z2l0DQo+ID4gYS9mcy9rc21iZC90cmFuc3BvcnRfcmRtYS5jIGIvZnMva3NtYmQvdHJhbnNwb3J0
X3JkbWEuYyBpbmRleA0KPiA+IGU2NDZkNzk1NTRiOC4uNzA2NjJiM2JkNTkwIDEwMDY0NA0KPiA+
IC0tLSBhL2ZzL2tzbWJkL3RyYW5zcG9ydF9yZG1hLmMNCj4gPiArKysgYi9mcy9rc21iZC90cmFu
c3BvcnRfcmRtYS5jDQo+ID4gQEAgLTQyLDcgKzQyLDcgQEANCj4gPiAgIC8qIFNNQl9ESVJFQ1Qg
bmVnb3RpYXRpb24gdGltZW91dCBpbiBzZWNvbmRzICovDQo+ID4gICAjZGVmaW5lIFNNQl9ESVJF
Q1RfTkVHT1RJQVRFX1RJTUVPVVQgICAgICAgICAgIDEyMA0KPiA+DQo+ID4gLSNkZWZpbmUgU01C
X0RJUkVDVF9NQVhfU0VORF9TR0VTICAgICAgICAgICAgICAgOA0KPiA+ICsjZGVmaW5lIFNNQl9E
SVJFQ1RfTUFYX1NFTkRfU0dFUyAgICAgICAgICAgICAgIDYNCj4gPiAgICNkZWZpbmUgU01CX0RJ
UkVDVF9NQVhfUkVDVl9TR0VTICAgICAgICAgICAgICAgMQ0KPiA+DQo+ID4gICAvKg0KPiA+DQo+
ID4gVGhhbmtzIQ0KPiA+Pg0KPiA+PiBUb20uDQo+ID4+DQo+ID4NCg==
