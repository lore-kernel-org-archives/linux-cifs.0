From: Pavel Shilovskiy <pshilov@microsoft.com>
Subject: RE: [PATCH][cifs-next] cifs: set oparms.create_options rather than
 or'ing in CREATE_OPEN_BACKUP_INTENT
Date: Thu, 6 Jul 2017 01:01:34 +0000
Message-ID: <CY4PR21MB0135AAAA14C1E9BBD39FC7CEB6D50@CY4PR21MB0135.namprd21.prod.outlook.com>
References: <20170705124734.12816-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Colin King <colin.king@canonical.com>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170705124734.12816-1-colin.king@canonical.com>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

MjAxNy0wNy0wNSA1OjQ3IEdNVC0wNzowMCBDb2xpbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNh
bC5jb20+Og0KPiBGcm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29t
Pg0KPg0KPiBDdXJyZW50bHkgb3Bhcm1zLmNyZWF0ZV9vcHRpb25zIGlzIHVuaW5pdGlhbGl6ZWQg
YW5kIHRoZSBjb2RlIGlzIGxvZ2ljYWxseQ0KPiBvcidpbmcgaW4gQ1JFQVRFX09QRU5fQkFDS1VQ
X0lOVEVOVCBvbnRvIGEgZ2FyYmFnZSB2YWx1ZSBvZg0KPiBvcGFybXMuY3JlYXRlX29wdGlvbnMg
ZnJvbSB0aGUgc3RhY2suICBGaXggdGhpcyBieSBqdXN0IHNldHRpbmcgdGhlIHZhbHVlDQo+IHJh
dGhlciB0aGFuIG9yJ2luZyBpbiB0aGUgc2V0dGluZy4NCj4NCj4gRGV0ZWN0ZWQgYnkgQ292ZXJp
dHlTY2FuLCBDSUQjMTQ0NzIyMCAoIlVuaXRpYWxpemVkIHNjYWxlIHZhbHVlIikNCj4NCj4gU2ln
bmVkLW9mZi1ieTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtpbmdAY2Fub25pY2FsLmNvbT4NCj4g
LS0tDQo+ICBmcy9jaWZzL3NtYjJvcHMuYyB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIy
b3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMuYw0KPiBpbmRleCA5NDFjNDBiN2E4NzAuLmM4MDViNzYx
OTA4MyAxMDA2NDQNCj4gLS0tIGEvZnMvY2lmcy9zbWIyb3BzLmMNCj4gKysrIGIvZnMvY2lmcy9z
bWIyb3BzLmMNCj4gQEAgLTEzMzksNyArMTMzOSw3IEBAIGdldF9zbWIyX2FjbF9ieV9wYXRoKHN0
cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IsDQo+ICAgICAgICAgeGlkID0gZ2V0X3hpZCgpOw0K
Pg0KPiAgICAgICAgIGlmIChiYWNrdXBfY3JlZChjaWZzX3NiKSkNCj4gLSAgICAgICAgICAgICAg
IG9wYXJtcy5jcmVhdGVfb3B0aW9ucyB8PSBDUkVBVEVfT1BFTl9CQUNLVVBfSU5URU5UOw0KPiAr
ICAgICAgICAgICAgICAgb3Bhcm1zLmNyZWF0ZV9vcHRpb25zID0gQ1JFQVRFX09QRU5fQkFDS1VQ
X0lOVEVOVDsNCj4gICAgICAgICBlbHNlDQo+ICAgICAgICAgICAgICAgICBvcGFybXMuY3JlYXRl
X29wdGlvbnMgPSAwOw0KPg0KDQoNClJldmlld2VkLWJ5OiBQYXZlbCBTaGlsb3Zza3kgPHBzaGls
b3ZAbWljcm9zb2Z0LmNvbT4NCg0KLS0NCkJlc3QgcmVnYXJkcywNClBhdmVsIFNoaWxvdnNreQ0K
DQo=
