From: Long Li <longli@microsoft.com>
Subject: RE: [Patch v3 2/6] cifs: Allocate validate negotiation request
 through kmalloc
Date: Wed, 18 Apr 2018 17:11:14 +0000
Message-ID: <MWHPR2101MB072909460F3898C6D13B4D4CCEB60@MWHPR2101MB0729.namprd21.prod.outlook.com>
References: <20180418003358.25098-1-longli@linuxonhyperv.com>
 <d7e569b6-d268-b8c1-e91d-d6dc0e7cdfc2@talpey.com>
 <e9e7f77032c5402e848de0293e4db3ee@AcuMS.aculab.com>
 <b8e56b14-a746-2a22-cb8d-94f1ba7d646b@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>
To: Tom Talpey <tom@talpey.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b8e56b14-a746-2a22-cb8d-94f1ba7d646b@talpey.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

PiBTdWJqZWN0OiBSZTogW1BhdGNoIHYzIDIvNl0gY2lmczogQWxsb2NhdGUgdmFsaWRhdGUgbmVn
b3RpYXRpb24gcmVxdWVzdCB0aHJvdWdoDQo+IGttYWxsb2MNCj4gDQo+IE9uIDQvMTgvMjAxOCA5
OjA4IEFNLCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+ID4gRnJvbTogVG9tIFRhbHBleQ0KPiA+PiBT
ZW50OiAxOCBBcHJpbCAyMDE4IDEyOjMyDQo+ID4gLi4uDQo+ID4+IE9uIDQvMTcvMjAxOCA4OjMz
IFBNLCBMb25nIExpIHdyb3RlOg0KPiA+Pj4gRnJvbTogTG9uZyBMaSA8bG9uZ2xpQG1pY3Jvc29m
dC5jb20+DQo+ID4+Pg0KPiA+Pj4gVGhlIGRhdGEgYnVmZmVyIGFsbG9jYXRlZCBvbiB0aGUgc3Rh
Y2sgY2FuJ3QgYmUgRE1BJ2VkLCBhbmQgaGVuY2UNCj4gPj4+IGNhbid0IHNlbmQgdGhyb3VnaCBS
RE1BIHZpYSBTTUIgRGlyZWN0Lg0KPiA+Pg0KPiA+PiBUaGlzIGNvbW1lbnQgaXMgY29uZnVzaW5n
LiBBbnkgcmVnaXN0ZXJlZCBtZW1vcnkgY2FuIGJlIERNQSdkLCBuZWVkDQo+ID4+IHRvIHN0YXRl
IHRoZSByZWFzb24gZm9yIHRoZSBjaG9pY2UgaGVyZSBtb3JlIGNsZWFybHkuDQo+ID4NCj4gPiBU
aGUgc3RhY2sgY291bGQgYmUgYWxsb2NhdGVkIHdpdGggdm1hbGxvYygpLg0KPiA+IEluIHdoaWNo
IGNhc2UgdGhlIHBhZ2VzIG1pZ2h0IG5vdCBiZSBwaHlzaWNhbGx5IGNvbnRpZ3VvdXMgYW5kIHRo
ZXJlDQo+ID4gaXMgbm8NCj4gPiAoc2Vuc2libGUpIGNhbGwgdG8gZ2V0IHRoZSBwaHlzaWNhbCBh
ZGRyZXNzIHJlcXVpcmVkIGJ5IHRoZSBkbWENCj4gPiBjb250cm9sbGVyIChvciBvdGhlciBidXMg
bWFzdGVyKS4NCj4gDQo+IE1lbW9yeSByZWdpc3RyYXRpb24gZG9lcyBub3QgcmVxdWlyZXMgcGFn
ZXMgdG8gYmUgcGh5c2ljYWxseSBjb250aWd1b3VzLg0KPiBSRE1BIFJlZ2lvbnMgY2FuIGFuZCBk
byBzdXBwb3J0IHZlcnkgbGFyZ2UgcGh5c2ljYWwgcGFnZSBzY2F0dGVyL2dhdGhlciwNCj4gYW5k
IHRoZSBhZGFwdGVyIERNQSdzIHRoZW0gcmVhZGlseS4gSXMgdGhpcyB0aGUgb25seSByZWFzb24/
DQoNCmliX2RtYV9tYXBfcGFnZSB3aWxsIHJldHVybiBhbiBpbnZhbGlkIERNQSBhZGRyZXNzIGZv
ciBhIGJ1ZmZlciBvbiBzdGFjay4gRXZlbiB3b3JzZSwgdGhpcyBpbmNvcnJlY3QgYWRkcmVzcyBj
YW4ndCBiZSBkZXRlY3RlZCBieSBpYl9kbWFfbWFwcGluZ19lcnJvci4gU2VuZGluZyBkYXRhIGZy
b20gdGhpcyBhZGRyZXNzIHRvIGhhcmR3YXJlIHdpbGwgbm90IGZhaWwsIGJ1dCB0aGUgcmVtb3Rl
IHBlZXIgd2lsbCBnZXQganVuayBkYXRhLg0KDQpJIHRoaW5rIGl0IG1ha2VzIHNlbnNlIGFzIHN0
YWNrIGlzIGR5bmFtaWMgYW5kIGNhbiBzaHJpbmsgYXMgSS9PIHByb2NlZWRzLCBzbyB0aGUgYnVm
ZmVyIGlzIGdvbmUuIE90aGVyIGtlcm5lbCBjb2RlIHVzZSBvbmx5IGRhdGEgb24gdGhlIGhlYXAg
Zm9yIERNQSwgZS5nLiBCTEsvU0NTSSBsYXllciBuZXZlciB1c2UgYnVmZmVyIG9uIHRoZSBzdGFj
ayB0byBzZW5kIGRhdGEuDQoNCj4gDQo+IFRvbS4NCg==
