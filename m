From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [Patch v3 2/6] cifs: Allocate validate negotiation request
 through kmalloc
Date: Wed, 18 Apr 2018 13:08:53 +0000
Message-ID: <e9e7f77032c5402e848de0293e4db3ee@AcuMS.aculab.com>
References: <20180418003358.25098-1-longli@linuxonhyperv.com>
 <d7e569b6-d268-b8c1-e91d-d6dc0e7cdfc2@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>
To: 'Tom Talpey' <tom@talpey.com>,
        "longli@microsoft.com" <longli@microsoft.com>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d7e569b6-d268-b8c1-e91d-d6dc0e7cdfc2@talpey.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

RnJvbTogVG9tIFRhbHBleQ0KPiBTZW50OiAxOCBBcHJpbCAyMDE4IDEyOjMyDQouLi4NCj4gT24g
NC8xNy8yMDE4IDg6MzMgUE0sIExvbmcgTGkgd3JvdGU6DQo+ID4gRnJvbTogTG9uZyBMaSA8bG9u
Z2xpQG1pY3Jvc29mdC5jb20+DQo+ID4NCj4gPiBUaGUgZGF0YSBidWZmZXIgYWxsb2NhdGVkIG9u
IHRoZSBzdGFjayBjYW4ndCBiZSBETUEnZWQsIGFuZCBoZW5jZSBjYW4ndCBzZW5kDQo+ID4gdGhy
b3VnaCBSRE1BIHZpYSBTTUIgRGlyZWN0Lg0KPiANCj4gVGhpcyBjb21tZW50IGlzIGNvbmZ1c2lu
Zy4gQW55IHJlZ2lzdGVyZWQgbWVtb3J5IGNhbiBiZSBETUEnZCwgbmVlZCB0bw0KPiBzdGF0ZSB0
aGUgcmVhc29uIGZvciB0aGUgY2hvaWNlIGhlcmUgbW9yZSBjbGVhcmx5Lg0KDQpUaGUgc3RhY2sg
Y291bGQgYmUgYWxsb2NhdGVkIHdpdGggdm1hbGxvYygpLg0KSW4gd2hpY2ggY2FzZSB0aGUgcGFn
ZXMgbWlnaHQgbm90IGJlIHBoeXNpY2FsbHkgY29udGlndW91cyBhbmQgdGhlcmUgaXMgbm8NCihz
ZW5zaWJsZSkgY2FsbCB0byBnZXQgdGhlIHBoeXNpY2FsIGFkZHJlc3MgcmVxdWlyZWQgYnkgdGhl
IGRtYSBjb250cm9sbGVyDQoob3Igb3RoZXIgYnVzIG1hc3RlcikuDQoNCglEYXZpZA0KDQo=
