Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0997C6FA90
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 07:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbiI2HRz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 03:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235095AbiI2HRx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 03:17:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9441176C3
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 00:17:52 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28T6pC8U022009;
        Thu, 29 Sep 2022 07:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=0e43JBKLXJfCcWxpqiiW1EJdShQ09SELwL94KjFMhoY=;
 b=IPuH9GvsU6WP17mS8vRolOy/6x7kYzsDtflhRV4VZ/oUmqo8TuVlg8HW3i7NAuZ5hULN
 a/akG4xJ2hI15LGNVIvp0SeGDcnlwPcsFQ4pLBWz5Zmg8QcGBkvgpq8Rvr1ml59kkdh9
 ZYQD7D5a5Jh1Qlqbwe1wL7EbJ7w5KjweXyTsFMqmfqPw/p41/rUCzNoB7tyqnOM1V7+t
 8ToPbtnvIaFTAES45XdJvxtNd25GGzy9Z96jXu0jl2RumOvqUJWWirMqvXYDl9i1jgGD
 S4hMVMjOnLuBj/s/VOnVb9jrZ7AzeF8yHKfytNrpCSob7yX08mbFE4Ht1WCcSioO6KNw yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jw6eygqcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Sep 2022 07:17:44 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28T6rMaU028393;
        Thu, 29 Sep 2022 07:17:43 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jw6eygqc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Sep 2022 07:17:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jz5Ud8Bq6nKveMqNKq12suEly3dvov1dO4/IGroLG58V3Zbcjt6wYbdJBod/aqgeZrbhuWeaf8Z4Pjf+3atx0HX02b+9mYqR4WFAI1yoHucg0yRbCoyowyIEmvAeADVibqdRxq44RVh4+8aZfMQU/SECpCchTqBpVtXDg9HG8OeDyTG6/KOdFKimUT1caMYswgyEKkvOrLOWuEVVSHTDG1fAM/s1dIFfeOzGUo8Ayt8ypJPYi39J4I7OkmgN3NNnABkZMX2AmyHV/wzPp8u3yhW19bxoiMswHCS74hBx7VTG7ijkRqylfsRqLbbVMTGseRHIxtI2px4XnwS+hzbWZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0e43JBKLXJfCcWxpqiiW1EJdShQ09SELwL94KjFMhoY=;
 b=PaMxdgPBF/r2PGmBbKGCmkg4ZpkQLpkQlPD6iuoTuJBSWAkJovuC0ki2YtZf0pVYGUUidv1CwZmy5CdjnjQCu3qpQmjiSj4/nJciukGIJq//aWBQjxO5DosAnK7QO/Or98GQ9JWwiZaI9NVdxT50V8/WYwwznu3ppzw4/KJDNt4av469s4/7WCV+pG8Jqht9rQRTunElPw9Ey/OK2mXtxQCuhRCQqunL5yl1yRYMZN9ZH7kLCyUF6q5BDiu9aEP+YjAnLDoVWpZcTCH4JISbiFPyTuI5jZZ1bz8qJeWYUu31Um4CTvkrqM1fq13ZVhABHH74QBSP+n9OCTjQSCeRJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=zurich.ibm.com; dmarc=pass action=none
 header.from=zurich.ibm.com; dkim=pass header.d=zurich.ibm.com; arc=none
Received: from SA0PR15MB3919.namprd15.prod.outlook.com (2603:10b6:806:91::20)
 by SA1PR15MB4642.namprd15.prod.outlook.com (2603:10b6:806:19d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Thu, 29 Sep
 2022 07:17:41 +0000
Received: from SA0PR15MB3919.namprd15.prod.outlook.com
 ([fe80::199f:5743:f34e:9bd3]) by SA0PR15MB3919.namprd15.prod.outlook.com
 ([fe80::199f:5743:f34e:9bd3%6]) with mapi id 15.20.5676.019; Thu, 29 Sep 2022
 07:17:41 +0000
From:   Bernard Metzler <BMT@zurich.ibm.com>
To:     Tom Talpey <tom@talpey.com>, Namjae Jeon <linkinjeon@kernel.org>
CC:     "smfrench@gmail.com" <smfrench@gmail.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "longli@microsoft.com" <longli@microsoft.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>
Subject: RE: Re: [PATCH v2 4/6] Reduce server smbdirect max send/receive
 segment sizes
Thread-Topic: Re: [PATCH v2 4/6] Reduce server smbdirect max send/receive
 segment sizes
Thread-Index: AQHY09OQITFGuSOCgUuUPEh6SZCWfw==
Date:   Thu, 29 Sep 2022 07:17:41 +0000
Message-ID: <SA0PR15MB39198D1888B890CC75F03E5399579@SA0PR15MB3919.namprd15.prod.outlook.com>
References: <cover.1663961449.git.tom@talpey.com>
 <f5fab678eedae83e79f25e4385bc1381ed554599.1663961449.git.tom@talpey.com>
 <CAKYAXd97ZrGVPj3astSWz3ESHKYFQ9JAxeq3z65mB6wmoiujrQ@mail.gmail.com>
 <11e7b888-460e-efd1-0a8c-3dbf594d9429@talpey.com>
 <CAKYAXd8JiF5N_Ve65=wHPyW+twRT5WOoHH=j6+u0YAAjCV-n2Q@mail.gmail.com>
 <80b2dae4-afe4-4d51-b198-09e2fdc9f10b@talpey.com>
 <SA0PR15MB39196C2A49C71FF1838B27D499559@SA0PR15MB3919.namprd15.prod.outlook.com>
 <8fa8a09e-599b-df31-d500-9c8b8bc7a7cc@talpey.com>
In-Reply-To: <8fa8a09e-599b-df31-d500-9c8b8bc7a7cc@talpey.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA0PR15MB3919:EE_|SA1PR15MB4642:EE_
x-ms-office365-filtering-correlation-id: 16f56b59-e667-4713-85d4-08daa1eab28f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VvIOH3q/3aiK9j33KtkQm0+/adNByP4QK9Ij6xo5izHaRzK7OE83FNuDb4cOtx9uZ8JCWOIZcTDMOEQzbol5Mb9whW+PArK5ZDNo8RuY4cyr38tbbQPCVanBf6sCA6hhi/+sn2Sg1+a7eFEVfJhEx6TsUb0cOQ+l3gshegQJ+yY4BQLsv896WepWk5A6ZUaNYMw31DjsoD/4rUnwJR4ZUKT7c2PLWUYsWpay6Fq/ws/OeSRazWDrGnmdRfPlkEjTfbWG6fA515Uae+iW2KNLQ0tFKcM1lf4N+Mi0g68uyjMqR2pS6at/Y6PoJArjHVaw2mDo8lUODZGxIDsGxKxNwI6sidpc0YIL8trV7atPVzYx0BWccR+uO4Ywei0b7B+vugbDHRjqZunJia5caVTtwy6Pmw9sSrRy7/FqD8+3j3F6L8cAL6yePrjUI79a1C8hnf6XS/Z3W2IZVLazzp/giyLnnG5ZD81XjkQe+Ce/bMaQfQ/K7C9xjp2eEnfKyhoCWHDoi6JoWr9qQ9jc2oHRHjPI0tRFl5UIkECBAOWMBHIoeQBMv52+E/hTz8AOeN0D4MPdRYnyKcxXYOAMe1JdaGqMQ1TzS+MaHaFyslH44uyrNPpkYRHMrjeqYWAx3gMogYA4v0EawRouc0xxYWidJKVWyMv5/7Ny5OkcindRErU6bLEZdhEpqWpWeVHwyu1p//62SXswThbzpbKYY1AG6+bQsuLIQS7bsUbpZyLbgZvwwUJSDt+/i+F7UbWaQQTOUlIallAQZ96MwQA3yPEa7A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR15MB3919.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(346002)(376002)(39860400002)(451199015)(186003)(83380400001)(38100700002)(122000001)(9686003)(38070700005)(41300700001)(2906002)(8936002)(52536014)(478600001)(316002)(71200400001)(53546011)(7696005)(6506007)(5660300002)(66556008)(64756008)(66446008)(66476007)(55016003)(4326008)(45080400002)(8676002)(76116006)(66946007)(110136005)(54906003)(33656002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M0E0SkREcWozYjZTMXhLMDBnVkJyeUNtRUVvUkgzekR6MisxdFZZVzN6NmE1?=
 =?utf-8?B?ckRMdTFnWEY2Sjk0V0pJSlZkd2llemZDZ0huTFNTRG51SDg2ZXQzaEowSzd0?=
 =?utf-8?B?WDZVdnpTK29HSEh3anN1b0I4Y1NTeisrZVl2OTJ5a2loSjZTMGtEZGQ5ZTFa?=
 =?utf-8?B?LzNxeTRlRThIQTVUK3daS2J4cW53U0pwMGNpblBpQklFWnZBcC9LL1dLeDlW?=
 =?utf-8?B?eVpMNlBGVW1LbzlWMGRjV29rM1dQMWVVeW5CMUpuK29aTnlhbStNTzhTV1lr?=
 =?utf-8?B?blRmN3o3QUZVeVZGN0lzaWtQZFV3cTBJVXFQTzFpT253RSt5R0hPTnpoRGJ2?=
 =?utf-8?B?ZFhKbm5iUFhEZzR4cHB3Rkoxc1VsQXhkbGFWdnE0Q2VvNU5UNDZHdXJlY2Fo?=
 =?utf-8?B?SnNEYmJKK1o4NEZBb1FpQ0M0MmtBN1NhK3pHeExFZjlMUlgrSFJBRndCczlm?=
 =?utf-8?B?SVBJVG9oZmhZcmxJRkkwSGZoQ0FlM1FTYnA3Zi94S1FmRnFuU2J1MzdFN1pk?=
 =?utf-8?B?TFpXT0FocDV5UlhOUVFFcUdYRmhaWHpoM0ozUE96ZW1FYkloYzBIV2JucHFU?=
 =?utf-8?B?V2lSMTlxTWgvZFNwSHQ2aFNkdjZQUEFCUHU1R2hvbjduRFAyUGNGYzJIWTRz?=
 =?utf-8?B?NTB3aGZ3bjlFSHdMSDMvTGM4eTV2eTJ2VS9mT25oUGE2RGFIZVloU3VYaUVG?=
 =?utf-8?B?YXdMSUkxMUgxWmZCSHJId1FzUE9MY0YvcWRNUGY1K1UycnM0NnJEWTcvT0l6?=
 =?utf-8?B?SzI1WnBBY2JMeFZ1UVdnOUU4cVhSQW04VmpOZ3drREhWZnc2TkRmT09ZN3hX?=
 =?utf-8?B?VHVFRitadkxLZGwxMysyYlNtWXAxc1QyMktPOWx3UHB5bFBVOXZPY2pVU2tv?=
 =?utf-8?B?ajVFVHl3d1hvRGYxUUlmS1pucFlaVFBnZ1l2SCttK3lPSnN2SmZDcXhrYmlu?=
 =?utf-8?B?LzdJd2gzbWpQVEE3L3ZpQXpnVWl2UHRXbnZUb3F6ZDFuYW5QdXF4aHhleU0x?=
 =?utf-8?B?anA0a3FvMGJqQjYyd1hFc1dmZ1hkVURjc3l5d1UwMlpna0cyeVd5OXZlajVx?=
 =?utf-8?B?ZG1OQk9lMDhwMXRQZTE2cVN4c2VLUFBwbVZiaktPL2hSRzhWVXNwNnM2Smpr?=
 =?utf-8?B?Y096VnJWTEpHVjc0UjF2eGVCaXdjT0NZbms1T1JBeTJyUmlReWJscUhyRS92?=
 =?utf-8?B?WUFleFdRYkl2TS9TMkxpWkZYU3d5OVByaVRybUsweDBaMmI5YUg2VStoTFlY?=
 =?utf-8?B?UkVTY2lScFNOZGNpdHJpUGRLbHFUbHRnd2dZcUZhK1Z1M1N3VzlsSW5MRnZn?=
 =?utf-8?B?ZCtUUndQdElaR3NaSlFjbmJFN2tuUVE2c3RaL2RpYnZrc2ZIRkhtQXRYTCt6?=
 =?utf-8?B?MWhQSFpYb0cxbWs1ZHFlQVV3aGZhUWVZWWRrck1zNklYcFdSUFV3bnl4V0Mr?=
 =?utf-8?B?U1lUbHpjRFEzTkY4V3I3UnVhUDFsQmdDM0FHU2VuOVZKRHNUWjUvbFI1Um05?=
 =?utf-8?B?QklpbkltNUVFeFNvV2lYTnlCSWJjOUVSM0pOeHZvbXh0bmwvcnFFRTNENUNF?=
 =?utf-8?B?OXdwNkZkdFc4Y1NPVmNiYi9LNklvSlZFWENWcW1qV1dLVTNaUHI3c0d0QWIy?=
 =?utf-8?B?aEo1OC9aOFM1c05qTmdkenlYUEI4OElrb1NOcEczb3V1OHVnV0wybXpZbDZX?=
 =?utf-8?B?SEpFVHNNRlFMVW52M0lUL2pZTDlpVnRBdHZMOTVsYTFvT2QxaGlIcmh0bUtj?=
 =?utf-8?B?TC9waUpQRFduWGlVZWJsYzVRU295U3VhZy85amdqUzVSRkh5SWpMR003V0dz?=
 =?utf-8?B?MGowTnh4SkxucUtnRmJjc01hVit1QWozeXRDOVFCcHZoRlMzWnJvMnVvd1Jp?=
 =?utf-8?B?NERTekRSTHdHY1IxcXhXN3FKSFR6N2NvRG9GY2M0bFkzSWFTbjJaK2ZTL0hP?=
 =?utf-8?B?UmdBTGh1cmxYV0VhUHVmcGdMMFNvQVI0UzR6QkpNQzBrV05FdXdoTElwdHNt?=
 =?utf-8?B?NEk3UCtKMFVyL3B4ZFBKendvY2dNb2ZaNWJrdDRJY3N1Z0lDaTF4UGQ3c0Ro?=
 =?utf-8?B?aUI0NXcrU3JUaS9qcUtmYy84UlJzZytOV05aa0xzWFBXd21sZUhJNUY5bzM2?=
 =?utf-8?B?WWgzS2x3MmlrOVY2dTlmSnFXdDh1a2xjTWNhbHVJMTlmSXRxZnY5Uk03R1FN?=
 =?utf-8?Q?ICn2vDSsBvzNhEYT1AZckL/0+ZwJ/R1bYRX+nZJ7KnQ+?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Zurich.ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR15MB3919.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16f56b59-e667-4713-85d4-08daa1eab28f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2022 07:17:41.6047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AjLVncajBOZeOtBvpwi5JwYFk+YEgm8DCWNp0zPOo/N3c0Ft9Vfe7LAe96CQX+2bV+haAPoSjpMgwEvqYKpxSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4642
X-Proofpoint-ORIG-GUID: 4PYJaw5-hJONjQbRMP_sSZEofa7YArya
X-Proofpoint-GUID: 6iNgmkSocSMwBB-Ht7gqmVCHACESNzXl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_04,2022-09-29_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290041
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVG9tIFRhbHBleSA8dG9t
QHRhbHBleS5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgMjggU2VwdGVtYmVyIDIwMjIgMTY6NTQN
Cj4gVG86IEJlcm5hcmQgTWV0emxlciA8Qk1UQHp1cmljaC5pYm0uY29tPjsgTmFtamFlIEplb24N
Cj4gPGxpbmtpbmplb25Aa2VybmVsLm9yZz4NCj4gQ2M6IHNtZnJlbmNoQGdtYWlsLmNvbTsgbGlu
dXgtY2lmc0B2Z2VyLmtlcm5lbC5vcmc7DQo+IHNlbm96aGF0c2t5QGNocm9taXVtLm9yZzsgbG9u
Z2xpQG1pY3Jvc29mdC5jb207IGRob3dlbGxzQHJlZGhhdC5jb20NCj4gU3ViamVjdDogW0VYVEVS
TkFMXSBSZTogW1BBVENIIHYyIDQvNl0gUmVkdWNlIHNlcnZlciBzbWJkaXJlY3QgbWF4DQo+IHNl
bmQvcmVjZWl2ZSBzZWdtZW50IHNpemVzDQo+IA0KPiBPbiA5LzI3LzIwMjIgMTA6NTkgQU0sIEJl
cm5hcmQgTWV0emxlciB3cm90ZToNCj4gPg0KPiA+DQo+ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2Fn
ZS0tLS0tDQo+ID4+IEZyb206IFRvbSBUYWxwZXkgPHRvbUB0YWxwZXkuY29tPg0KPiA+PiBTZW50
OiBNb25kYXksIDI2IFNlcHRlbWJlciAyMDIyIDE5OjI1DQo+ID4+IFRvOiBOYW1qYWUgSmVvbiA8
bGlua2luamVvbkBrZXJuZWwub3JnPg0KPiA+PiBDYzogc21mcmVuY2hAZ21haWwuY29tOyBsaW51
eC1jaWZzQHZnZXIua2VybmVsLm9yZzsNCj4gPj4gc2Vub3poYXRza3lAY2hyb21pdW0ub3JnOyBC
ZXJuYXJkIE1ldHpsZXIgPEJNVEB6dXJpY2guaWJtLmNvbT47DQo+ID4+IGxvbmdsaUBtaWNyb3Nv
ZnQuY29tOyBkaG93ZWxsc0ByZWRoYXQuY29tDQo+ID4+IFN1YmplY3Q6IFtFWFRFUk5BTF0gUmU6
IFtQQVRDSCB2MiA0LzZdIFJlZHVjZSBzZXJ2ZXIgc21iZGlyZWN0IG1heA0KPiA+PiBzZW5kL3Jl
Y2VpdmUgc2VnbWVudCBzaXplcw0KPiA+Pg0KPiA+PiBPbiA5LzI1LzIwMjIgOToxMyBQTSwgTmFt
amFlIEplb24gd3JvdGU6DQo+ID4+PiAyMDIyLTA5LTI2IDA6NDEgR01UKzA5OjAwLCBUb20gVGFs
cGV5IDx0b21AdGFscGV5LmNvbT46DQo+ID4+Pj4gT24gOS8yNC8yMDIyIDExOjQwIFBNLCBOYW1q
YWUgSmVvbiB3cm90ZToNCj4gPj4+Pj4gMjAyMi0wOS0yNCA2OjUzIEdNVCswOTowMCwgVG9tIFRh
bHBleSA8dG9tQHRhbHBleS5jb20+Og0KPiA+Pj4+Pj4gUmVkdWNlIGtzbWJkIHNtYmRpcmVjdCBt
YXggc2VnbWVudCBzZW5kIGFuZCByZWNlaXZlIHNpemUgdG8gMTM2NA0KPiA+Pj4+Pj4gdG8gbWF0
Y2ggcHJvdG9jb2wgbm9ybXMuIExhcmdlciBidWZmZXJzIGFyZSB1bm5lY2Vzc2FyeSBhbmQgYWRk
DQo+ID4+Pj4+PiBzaWduaWZpY2FudCBtZW1vcnkgb3ZlcmhlYWQuDQo+ID4+Pj4+Pg0KPiA+Pj4+
Pj4gU2lnbmVkLW9mZi1ieTogVG9tIFRhbHBleSA8dG9tQHRhbHBleS5jb20+DQo+ID4+Pj4+PiAt
LS0NCj4gPj4+Pj4+ICAgICBmcy9rc21iZC90cmFuc3BvcnRfcmRtYS5jIHwgNCArKy0tDQo+ID4+
Pj4+PiAgICAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkN
Cj4gPj4+Pj4+DQo+ID4+Pj4+PiBkaWZmIC0tZ2l0IGEvZnMva3NtYmQvdHJhbnNwb3J0X3JkbWEu
YyBiL2ZzL2tzbWJkL3RyYW5zcG9ydF9yZG1hLmMNCj4gPj4+Pj4+IGluZGV4IDQ5NGI4ZTVhZjRi
My4uMDMxNWJjYTNkNTNiIDEwMDY0NA0KPiA+Pj4+Pj4gLS0tIGEvZnMva3NtYmQvdHJhbnNwb3J0
X3JkbWEuYw0KPiA+Pj4+Pj4gKysrIGIvZnMva3NtYmQvdHJhbnNwb3J0X3JkbWEuYw0KPiA+Pj4+
Pj4gQEAgLTYyLDEzICs2MiwxMyBAQCBzdGF0aWMgaW50IHNtYl9kaXJlY3RfcmVjZWl2ZV9jcmVk
aXRfbWF4ID0gMjU1Ow0KPiA+Pj4+Pj4gICAgIHN0YXRpYyBpbnQgc21iX2RpcmVjdF9zZW5kX2Ny
ZWRpdF90YXJnZXQgPSAyNTU7DQo+ID4+Pj4+Pg0KPiA+Pj4+Pj4gICAgIC8qIFRoZSBtYXhpbXVt
IHNpbmdsZSBtZXNzYWdlIHNpemUgY2FuIGJlIHNlbnQgdG8gcmVtb3RlIHBlZXIgKi8NCj4gPj4+
Pj4+IC1zdGF0aWMgaW50IHNtYl9kaXJlY3RfbWF4X3NlbmRfc2l6ZSA9IDgxOTI7DQo+ID4+Pj4+
PiArc3RhdGljIGludCBzbWJfZGlyZWN0X21heF9zZW5kX3NpemUgPSAxMzY0Ow0KPiA+Pj4+Pj4N
Cj4gPj4+Pj4+ICAgICAvKiAgVGhlIG1heGltdW0gZnJhZ21lbnRlZCB1cHBlci1sYXllciBwYXls
b2FkIHJlY2VpdmUgc2l6ZQ0KPiA+PiBzdXBwb3J0ZWQNCj4gPj4+Pj4+ICovDQo+ID4+Pj4+PiAg
ICAgc3RhdGljIGludCBzbWJfZGlyZWN0X21heF9mcmFnbWVudGVkX3JlY3Zfc2l6ZSA9IDEwMjQg
KiAxMDI0Ow0KPiA+Pj4+Pj4NCj4gPj4+Pj4+ICAgICAvKiAgVGhlIG1heGltdW0gc2luZ2xlLW1l
c3NhZ2Ugc2l6ZSB3aGljaCBjYW4gYmUgcmVjZWl2ZWQgKi8NCj4gPj4+Pj4+IC1zdGF0aWMgaW50
IHNtYl9kaXJlY3RfbWF4X3JlY2VpdmVfc2l6ZSA9IDgxOTI7DQo+ID4+Pj4+PiArc3RhdGljIGlu
dCBzbWJfZGlyZWN0X21heF9yZWNlaXZlX3NpemUgPSAxMzY0Ow0KPiA+Pj4+PiBDYW4gSSBrbm93
IHdoYXQgdmFsdWUgd2luZG93cyBzZXJ2ZXIgc2V0IHRvID8NCj4gPj4+Pj4NCj4gPj4+Pj4gSSBj
YW4gc2VlIHRoZSBmb2xsb3dpbmcgc2V0dGluZ3MgZm9yIHRoZW0gaW4gTVMtU01CRC5wZGYNCj4g
Pj4+Pj4gQ29ubmVjdGlvbi5NYXhTZW5kU2l6ZSBpcyBzZXQgdG8gMTM2NC4NCj4gPj4+Pj4gQ29u
bmVjdGlvbi5NYXhSZWNlaXZlU2l6ZSBpcyBzZXQgdG8gODE5Mi4NCj4gPj4+Pg0KPiA+Pj4+IEds
YWQgeW91IGFza2VkLCBpdCdzIGFuIGludGVyZXN0aW5nIHNpdHVhdGlvbiBJTU8uDQo+ID4+Pj4N
Cj4gPj4+PiBJbiBNUy1TTUJELCB0aGUgZm9sbG93aW5nIGFyZSBkb2N1bWVudGVkIGFzIGJlaGF2
aW9yIG5vdGVzOg0KPiA+Pj4+DQo+ID4+Pj4gQ2xpZW50LXNpZGUgKGFjdGl2ZSBjb25uZWN0KToN
Cj4gPj4+PiAgICAgQ29ubmVjdGlvbi5NYXhTZW5kU2l6ZSBpcyBzZXQgdG8gMTM2NC4NCj4gPj4+
PiAgICAgQ29ubmVjdGlvbi5NYXhSZWNlaXZlU2l6ZSBpcyBzZXQgdG8gODE5Mi4NCj4gPj4+Pg0K
PiA+Pj4+IFNlcnZlci1zaWRlIChwYXNzaXZlIGxpc3Rlbik6DQo+ID4+Pj4gICAgIENvbm5lY3Rp
b24uTWF4U2VuZFNpemUgaXMgc2V0IHRvIDEzNjQuDQo+ID4+Pj4gICAgIENvbm5lY3Rpb24uTWF4
UmVjZWl2ZVNpemUgaXMgc2V0IHRvIDgxOTIuDQo+ID4+Pj4NCj4gPj4+PiBIb3dldmVyLCB0aGVz
ZSBhcmUgb25seSB0aGUgaW5pdGlhbCB2YWx1ZXMuIER1cmluZyBTTUJEDQo+ID4+Pj4gbmVnb3Rp
YXRpb24sIHRoZSB0d28gc2lkZXMgYWRqdXN0IGRvd253YXJkIHRvIHRoZSBvdGhlcidzDQo+ID4+
Pj4gbWF4aW11bS4gVGhlcmVmb3JlLCBXaW5kb3dzIGNvbm5lY3RpbmcgdG8gV2luZG93cyB3aWxs
IHVzZQ0KPiA+Pj4+IDEzNjQgb24gYm90aCBzaWRlcy4NCj4gPj4+Pg0KPiA+Pj4+IEluIGNpZnMg
YW5kIGtzbWJkLCB0aGUgY2hvaWNlcyB3ZXJlIG1lc3NpZXI6DQo+ID4+Pj4NCj4gPj4+PiBDbGll
bnQtc2lkZSBzbWJkaXJlY3QuYzoNCj4gPj4+PiAgICAgaW50IHNtYmRfbWF4X3NlbmRfc2l6ZSA9
IDEzNjQ7DQo+ID4+Pj4gICAgIGludCBzbWJkX21heF9yZWNlaXZlX3NpemUgPSA4MTkyOw0KPiA+
Pj4+DQo+ID4+Pj4gU2VydmVyLXNpZGUgdHJhbnNwb3J0X3JkbWEuYzoNCj4gPj4+PiAgICAgc3Rh
dGljIGludCBzbWJfZGlyZWN0X21heF9zZW5kX3NpemUgPSA4MTkyOw0KPiA+Pj4+ICAgICBzdGF0
aWMgaW50IHNtYl9kaXJlY3RfbWF4X3JlY2VpdmVfc2l6ZSA9IDgxOTI7DQo+ID4+Pj4NCj4gPj4+
PiBUaGVyZWZvcmUsIHBlZXJzIGNvbm5lY3RpbmcgdG8ga3NtYmQgd291bGQgdHlwaWNhbGx5IGVu
ZCB1cA0KPiA+Pj4+IG5lZ290aWF0aW5nIDEzNjQgZm9yIHNlbmQgYW5kIDgxOTIgZm9yIHJlY2Vp
dmUuDQo+ID4+Pj4NCj4gPj4+PiBUaGVyZSBpcyBhbG1vc3Qgbm8gZ29vZCByZWFzb24gdG8gdXNl
IGxhcmdlciBidWZmZXJzLiBCZWNhdXNlDQo+ID4+Pj4gUkRNQSBpcyBoaWdobHkgZWZmaWNpZW50
LCBhbmQgdGhlIHNtYmRpcmVjdCBwcm90b2NvbCB0cml2aWFsbHkNCj4gPj4+PiBmcmFnbWVudHMg
bG9uZ2VyIG1lc3NhZ2VzLCB0aGVyZSBpcyBubyBzaWduaWZpY2FudCBwZXJmb3JtYW5jZQ0KPiA+
Pj4+IHBlbmFsdHkuDQo+ID4+Pj4NCj4gPj4+PiBBbmQsIGJlY2F1c2Ugbm90IG1hbnkgU01CMyBt
ZXNzYWdlcyByZXF1aXJlIDgxOTIgYnl0ZXMgb3Zlcg0KPiA+Pj4+IHNtYmRpcmVjdCwgaXQncyBh
IGNvbG9zc2FsIHdhc3RlIG9mIHZpcnR1YWxseSBjb250aWd1b3VzIGtlcm5lbA0KPiA+Pj4+IG1l
bW9yeSB0byBhbGxvY2F0ZSA4MTkyIHRvIGFsbCByZWNlaXZlcy4NCj4gPj4+Pg0KPiA+Pj4+IEJ5
IHNldHRpbmcgYWxsIGZvdXIgdG8gdGhlIHByYWN0aWNhbCByZWFsaXR5IG9mIDEzNjQsIGl0J3Mg
YQ0KPiA+Pj4+IGNvbnNpc3RlbnQgYW5kIGVmZmljaWVudCBkZWZhdWx0LCBhbmQgYWxpZ25zIExp
bnV4IHNtYmRpcmVjdA0KPiA+Pj4+IHdpdGggV2luZG93cy4NCj4gPj4+IFRoYW5rcyBmb3IgeW91
ciBkZXRhaWxlZCBleHBsYW5hdGlvbiEgIEFncmVlIHRvIHNldCBib3RoIHRvIDEzNjQgYnkNCj4g
Pj4+IGRlZmF1bHQsIElzIHRoZXJlIGFueSB1c2FnZSB0byBpbmNyZWFzZSBpdD8gSSB3b25kZXIg
aWYgdXNlcnMgbmVlZCBhbnkNCj4gPj4+IGNvbmZpZ3VyYXRpb24gcGFyYW1ldGVycyB0byBhZGp1
c3QgdGhlbS4NCj4gPj4NCj4gPj4gSW4gbXkgb3BpbmlvbiwgcHJvYmFibHkgbm90LiBJIGdpdmUg
c29tZSByZWFzb25zIHdoeSBsYXJnZSBmcmFnbWVudHMNCj4gPj4gYXJlbid0IGFsd2F5cyBoZWxw
ZnVsIGp1c3QgYWJvdmUuIEl0J3MgdGhlIHNhbWUgbnVtYmVyIG9mIHBhY2tldHMhIEp1c3QNCj4g
Pj4gYSBxdWVzdGlvbiBvZiB3aGV0aGVyIFNNQkRpcmVjdCBvciBFdGhlcm5ldCBkb2VzIHRoZSBm
cmFnbWVudGF0aW9uLCBhbmQNCj4gPj4gdGhlIGJ1ZmZlciBtYW5hZ2VtZW50Lg0KPiA+Pg0KPiA+
DQo+ID4gT25lIHNpbXBsZSByZWFzb24gZm9yIGxhcmdlciBidWZmZXJzIEkgYW0gYXdhcmUgb2Yg
aXMgcnVubmluZw0KPiA+IGVmZmljaWVudGx5IG9uIHNvZnR3YXJlIG9ubHkgUkRNQSBwcm92aWRl
cnMgbGlrZSBzaXcgb3IgcnhlLg0KPiA+IEZvciBzaXcgSSdkIGd1ZXNzIHdlIGN1dCB0byBsZXNz
IHRoYW4gaGFsZiB0aGUgcGVyZm9ybWFuY2Ugd2l0aA0KPiA+IDEzNjQgYnl0ZXMgYnVmZmVycy4g
QnV0IG1heWJlIHRoYXQgaXMgbm8gY29uY2VybiBmb3IgdGhlIHNldHVwcw0KPiA+IHlvdSBoYXZl
IGluIG1pbmQuDQo+IA0KPiBJJ20gc2tlcHRpY2FsIG9mICJsZXNzIHRoYW4gaGFsZiIgdGhlIHBl
cmZvcm1hbmNlLCBhbmQgd29uZGVyIHdoeQ0KPiB0aGF0IG1pZ2h0IGJlLCBidXQuLi4NCj4gDQo+
IEFnYWluLCBpdCdzIHJhdGhlciB1bmNvbW1vbiB0aGF0IHRoZXNlIGlubGluZSBtZXNzYWdlcyBh
cmUgZXZlcg0KPiBsYXJnZS4gQnVsayBkYXRhIChyL3cgPj00S0IpIGlzIGFsd2F5cyBjYXJyaWVk
IGJ5IFJETUEsIGFuZCBkb2VzDQo+IG5vdCBhcHBlYXIgYXQgYWxsIGluIHRoZXNlIGRhdGFncmFt
cywgZm9yIGV4YW1wbGUuDQo+IA0KPiBUaGUgY29kZSBjdXJyZW50bHkgaGFzIGEgc2luZ2xlIHN5
c3RlbS13aWRlIGRlZmF1bHQsIHdoaWNoIGlzIG5vdA0KPiB0dW5hYmxlIHBlciBjb25uZWN0aW9u
IGFuZCByZXF1aXJlcyBib3RoIHNpZGVzIG9mIHRoZSBjb25uZWN0aW9uDQo+IHRvIGRvIHNvLiBJ
dCdzIG5vdCByZWFzb25hYmxlIHRvIGRlcGVuZCBvbiBXaW5kb3dzLCBjaWZzLmtvIGFuZA0KPiBr
c21iZC5rbyB0byBhbGwgc29tZWhvdyBtYWdpY2FsbHkgZG8gdGhlIHNhbWUgdGhpbmcuIFNvIHRo
ZSBiZXN0DQo+IGRlZmF1bHQgaXMgdGhlIG1vc3QgY29uc2VydmF0aXZlLCBsZWFzdCB3YXN0ZWZ1
bCBzZXR0aW5nLg0KPiANCg0KT2gsIHNvcnJ5LCBteSBiYWQuIEkgd2FzIHVuZGVyIHRoZSBpbXBy
ZXNzaW9uIHdlIHRhbGsgYWJvdXQgYnVsaw0KZGF0YSwgaWYgOGsgYnVmZmVycyBhcmUgdGhlIGRl
ZmF1bHQuIFNvIEkgY29tcGxldGVseSBhZ3JlZSB3aXRoDQp5b3VyIHBvaW50Lg0KDQpCZXN0LA0K
QmVybmFyZC4NCg0KPiBUb20uDQo+IA0KPiANCj4gPiBCZXN0LA0KPiA+IEJlcm5hcmQuDQo+ID4N
Cj4gPj4gVGhlcmUgbWlnaHQgY29uY2VpdmFibHkgYmUgYSBjYXNlIGZvciAqc21hbGxlciosIGZv
ciBleGFtcGxlIG9uIElCIHdoZW4NCj4gPj4gaXQncyBjcmFua2VkIGRvd24gdG8gdGhlIG1pbmlt
dW0gKDI1NkIpIE1UVS4gQnV0IGl0IHdpbGwgd29yayB3aXRoIHRoaXMNCj4gPj4gZGVmYXVsdC4N
Cj4gPj4NCj4gPj4gSSdkIHNheSBsZXQncyBkb24ndCBvdmVyLWVuZ2luZWVyIGl0IHVudGlsIHdl
IGFkZHJlc3MgdGhlIG1hbnkgb3RoZXINCj4gPj4gaXNzdWVzIGluIHRoaXMgY29kZS4gTWVyZ2lu
ZyB0aGUgdHdvIHNtYmRpcmVjdCBpbXBsZW1lbnRhdGlvbnMgaXMgbXVjaA0KPiA+PiBtb3JlIGlt
cG9ydGFudCB0aGFuIGFkZGluZyB0d2Vha3kgbGl0dGxlIGtub2JzIHRvIGJvdGguIE1ITy4NCj4g
Pj4NCj4gPj4gVG9tLg0KPiA+Pg0KPiA+Pj4+Pg0KPiA+Pj4+PiBXaHkgZG9lcyB0aGUgc3BlY2lm
aWNhdGlvbiBkZXNjcmliZSBzZXR0aW5nIGl0IHRvIDgxOTI/DQo+ID4+Pj4+Pg0KPiA+Pj4+Pj4g
ICAgIHN0YXRpYyBpbnQgc21iX2RpcmVjdF9tYXhfcmVhZF93cml0ZV9zaXplID0gU01CRF9ERUZB
VUxUX0lPU0laRTsNCj4gPj4+Pj4+DQo+ID4+Pj4+PiAtLQ0KPiA+Pj4+Pj4gMi4zNC4xDQo+ID4+
Pj4+Pg0KPiA+Pj4+Pj4NCj4gPj4+Pj4NCj4gPj4+Pg0KPiA+Pj4NCg==
