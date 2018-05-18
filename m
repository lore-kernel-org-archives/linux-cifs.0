From: Long Li <longli@microsoft.com>
Subject: RE: [RFC PATCH 09/09] Introduce cache=rdma moutning option
Date: Fri, 18 May 2018 20:58:08 +0000
Message-ID: <MWHPR2101MB0729D163B903A0198A85AB4BCE900@MWHPR2101MB0729.namprd21.prod.outlook.com>
References: <20180518002214.5657-1-longli@linuxonhyperv.com>
 <20180518002214.5657-10-longli@linuxonhyperv.com>
 <20180518072631.GA19250@infradead.org>
 <MWHPR2101MB07297B07D495D66A1C9416FACE900@MWHPR2101MB0729.namprd21.prod.outlook.com>
 <CAH2r5mtzUJUakbPr_kzrDcqVPC9QuS7K8MXejNz7F=Uii6K5Kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Christoph Hellwig <hch@infradead.org>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5mtzUJUakbPr_kzrDcqVPC9QuS7K8MXejNz7F=Uii6K5Kg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

PiBTdWJqZWN0OiBSZTogW1JGQyBQQVRDSCAwOS8wOV0gSW50cm9kdWNlIGNhY2hlPXJkbWEgbW91
dG5pbmcgb3B0aW9uDQo+IA0KPiBPbiBGcmksIE1heSAxOCwgMjAxOCBhdCAxMjowMCBQTSwgTG9u
ZyBMaSB2aWEgc2FtYmEtdGVjaG5pY2FsIDxzYW1iYS0NCj4gdGVjaG5pY2FsQGxpc3RzLnNhbWJh
Lm9yZz4gd3JvdGU6DQo+ID4+IFN1YmplY3Q6IFJlOiBbUkZDIFBBVENIIDA5LzA5XSBJbnRyb2R1
Y2UgY2FjaGU9cmRtYSBtb3V0bmluZyBvcHRpb24NCj4gPj4NCj4gPj4gT24gVGh1LCBNYXkgMTcs
IDIwMTggYXQgMDU6MjI6MTRQTSAtMDcwMCwgTG9uZyBMaSB3cm90ZToNCj4gPj4gPiBGcm9tOiBM
b25nIExpIDxsb25nbGlAbWljcm9zb2Z0LmNvbT4NCj4gPj4gPg0KPiA+PiA+IFdoZW4gY2FjaGU9
cmRtYSBpcyBlbmFibGVkIG9uIG1vdW50IG9wdGlvbnMsIENJRlMgZG8gbm90IGFsbG9jYXRlDQo+
ID4+ID4gaW50ZXJuYWwgZGF0YSBidWZmZXIgcGFnZXMgZm9yIEkvTywgZGF0YSBpcyByZWFkL3dy
aXRlbiBkaXJlY3RseSB0bw0KPiA+PiA+IHVzZXINCj4gPj4gbWVtb3J5IHZpYSBSRE1BLg0KPiA+
Pg0KPiA+PiBJIGRvbid0IHRoaW5rIHRoaXMgc2hvdWxkIGJlIGFuIG9wdGlvbi4gIEZvciBkaXJl
Y3QgSS9PIHdpdGhvdXQNCj4gPj4gc2lnbmluZyBvciBlbmNyeXB0aW9uIENJRlMgc2hvdWxkIGFs
d2F5cyB1c2UgZ2V0X3VzZXJfcGFnZXMsIHdpdGggb3INCj4gd2l0aG91dCBSRE1BLg0KPiA+DQo+
ID4gWWVzIHRoaXMgc2hvdWxkIGJlIGRvbmUgZm9yIGFsbCB0cmFuc3BvcnQuIElmIHRoZXJlIGFy
ZSBubyBvYmplY3Rpb25zLCBJJ2xsIHNlbmQNCj4gcGF0Y2hlcyB0byBjaGFuZ2UgdGhpcy4NCj4g
DQo+IFdvdWxkIHRoaXMgaGVscC9jaGFuZ2UgcGVyZm9ybWFuY2UgbXVjaD8NCg0KT24gUkRNQSwg
aXQgaGVscHMgd2l0aCBJL08gbGF0ZW5jeSBhbmQgcmVkdWNlcyBDUFUgdXNhZ2Ugb24gY2VydGFp
biBJL08gcGF0dGVybnMuDQoNCkJ1dCBJIGhhdmVuJ3QgdGVzdGVkIG9uIFRDUC4gTWF5YmUgaXQg
d2lsbCBoZWxwIGEgbGl0dGxlIGJpdC4NCg0KPiANCj4gDQo+IA0KPiAtLQ0KPiBUaGFua3MsDQo+
IA0KPiBTdGV2ZQ0K
