From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: RE: [Patch v5 08/21] CIFS: SMBD: Upper layer reconnects to SMB Direct
 session
Date: Wed, 1 Nov 2017 19:44:30 +0000
Message-ID: <BN6PR21MB083455CADF03A6BD40863968CB5F0@BN6PR21MB0834.namprd21.prod.outlook.com>
References: <20171018230920.21042-1-longli@exchange.microsoft.com>
 <20171018230920.21042-9-longli@exchange.microsoft.com>
 <CAKywueRMRGhkw1zFh5HEBqV748hoq0DVsjGoVg8ttD22sTsYOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        "Stephen Hemminger" <sthemmin@microsoft.com>,
        Long Li <longli@microsoft.com>
To: Pavel Shilovsky <piastryyy@gmail.com>,
        Long Li <longli@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKywueRMRGhkw1zFh5HEBqV748hoq0DVsjGoVg8ttD22sTsYOQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

RnJvbTogUGF2ZWwgU2hpbG92c2t5IFttYWlsdG86cGlhc3RyeXl5QGdtYWlsLmNvbV0NCj4gMjAx
Ny0xMC0xOCAxNjowOSBHTVQtMDc6MDAgTG9uZyBMaSA8bG9uZ2xpQGV4Y2hhbmdlLm1pY3Jvc29m
dC5jb20+Og0KPiA+IEZyb206IExvbmcgTGkgPGxvbmdsaUBtaWNyb3NvZnQuY29tPg0KPiA+DQo+
ID4gRG8gYSByZWNvbm5lY3Qgb24gU01CIERpcmVjdCB3aGVuIGl0IGlzIHVzZWQgYXMgdGhlIGNv
bm5lY3Rpb24uIFJlY29ubmVjdA0KPiBjYW4NCj4gPiBoYXBwZW4gZm9yIG1hbnkgcmVhc29ucyBh
bmQgaXQncyBtb3N0bHkgdGhlIGRlY2lzaW9uIG9mIFNNQjIgdXBwZXIgbGF5ZXIuDQo+ID4NCj4g
PiBTaWduZWQtb2ZmLWJ5OiBMb25nIExpIDxsb25nbGlAbWljcm9zb2Z0LmNvbT4NCj4gPiAtLS0N
Cj4gPiAgZnMvY2lmcy9jb25uZWN0LmMgfCA3ICsrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQs
IDcgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5j
IGIvZnMvY2lmcy9jb25uZWN0LmMNCj4gPiBpbmRleCAyYzBiMzRhLi44Y2EzYzEzIDEwMDY0NA0K
PiA+IC0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jDQo+ID4gKysrIGIvZnMvY2lmcy9jb25uZWN0LmMN
Cj4gPiBAQCAtNDA2LDcgKzQwNiwxNCBAQCBjaWZzX3JlY29ubmVjdChzdHJ1Y3QgVENQX1NlcnZl
cl9JbmZvICpzZXJ2ZXIpDQo+ID4NCj4gPiAgICAgICAgICAgICAgICAgLyogd2Ugc2hvdWxkIHRy
eSBvbmx5IHRoZSBwb3J0IHdlIGNvbm5lY3RlZCB0byBiZWZvcmUgKi8NCj4gPiAgICAgICAgICAg
ICAgICAgbXV0ZXhfbG9jaygmc2VydmVyLT5zcnZfbXV0ZXgpOw0KPiA+ICsjaWZkZWYgQ09ORklH
X0NJRlNfU01CX0RJUkVDVA0KPiA+ICsgICAgICAgICAgICAgICBpZiAoc2VydmVyLT5yZG1hKQ0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHJjID0gc21iZF9yZWNvbm5lY3Qoc2VydmVyKTsN
Cj4gPiArICAgICAgICAgICAgICAgZWxzZQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHJj
ID0gZ2VuZXJpY19pcF9jb25uZWN0KHNlcnZlcik7DQo+IA0KPiBNaW5vcjogaGVyZSBhbmQgaW4g
b3RoZXIgc2ltaWxhciBwbGFjZXMgd2UgY2FuIHJlbW92ZSAjZWxzZSBwYXJ0IGJlbG93DQo+IGFu
ZCBwdXQgI2VuZGlmIGJlZm9yZSBlbHNlIGJsb2NrIGFib3ZlLg0KPiANCj4gPiArI2Vsc2UNCj4g
PiAgICAgICAgICAgICAgICAgcmMgPSBnZW5lcmljX2lwX2Nvbm5lY3Qoc2VydmVyKTsNCj4gPiAr
I2VuZGlmDQoNCkknZCBzdWdnZXN0IHJhdGhlcjoNCg0KI2lmZGVmIENPTkZJR19DSUZTX1NNQl9E
SVJFQ1QNCiNkZWZpbmUgY2lmc19yZG1hX2VuYWJsZWQoc2VydmVyKQkoKHNlcnZlciktPnJkbWEp
DQojZWxzZQ0KI2RlZmluZSBjaWZzX3JkbWFfZW5hYmxlZChzZXJ2ZXIpCTANCiNlbmRpZg0KDQpU
aGVuIHdlIGRvbid0IG5lZWQgYW4gaWZkZWYgaW4gdGhlIHVzZXJzLCBqdXN0Og0KDQoJaWYgKGNp
ZnNfcmRtYV9lbmFibGVkKHNlcnZlcikpDQoJCXJjID0gc21iZF9yZWNvbm5lY3Qoc2VydmVyKTsN
CgllbHNlDQoJCXJjID0gZ2VuZXJpY19pcF9jb25uZWN0KHNlcnZlcik7DQoNCg==
