From: Paulo Alcantara <paulo@paulo.ac>
Subject: Re: [PATCH 1/2] cifs: use timespec64 internally
Date: Tue, 19 Jun 2018 13:36:31 -0300
Message-ID: <8736xibunk.fsf@paulo.ac>
References: <20180619153255.3634720-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-cifs@vger.kernel.org, Kees Cook <keescook@chromium.org>,
 Arnd Bergmann <arnd@arndb.de>, y2038@lists.linaro.org,
 linux-kernel@vger.kernel.org, Long Li <longli@microsoft.com>,
 samba-technical@lists.samba.org, Aurelien Aptel <aaptel@suse.com>,
 Ronnie Sahlberg <lsahlber@redhat.com>, Pavel Shilovsky <pshilov@microsoft.com>
To: Arnd Bergmann <arnd@arndb.de>, Steve French <sfrench@samba.org>
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20180619153255.3634720-1-arnd@arndb.de>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
List-Id: linux-cifs.vger.kernel.org

QXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4gd3JpdGVzOgoKPiBJbiBjaWZzLCB0aGUgdGlt
ZXN0YW1wcyBhcmUgc3RvcmVkIGluIG1lbW9yeSBpbiB0aGUgY2lmc19mYXR0ciBzdHJ1Y3R1cmUs
Cj4gd2hpY2ggdXNlcyB0aGUgZGVwcmVjYXRlZCAndGltZXNwZWMnIHN0cnVjdHVyZS4gTm93IHRo
YXQgdGhlIFZGUyBjb2RlCj4gaGFzIG1vdmVkIG9uIHRvICd0aW1lc3BlYzY0JywgdGhlIG5leHQg
c3RlcCBpcyB0byBjaGFuZ2Ugb3ZlciB0aGUgZmF0dHIKPiBhcyB3ZWxsLgo+Cj4gVGhpcyBhbHNv
IG1ha2VzIDMyLWJpdCBhbmQgNjQtYml0IHN5c3RlbXMgYmVoYXZlIHRoZSBzYW1lIHdheSwgYW5k
Cj4gbm8gbG9uZ2VyIG92ZXJmbG93IHRoZSAzMi1iaXQgdGltZV90IGluIHllYXIgMjAzOC4KPgo+
IFNpZ25lZC1vZmYtYnk6IEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+Cj4gLS0tCj4gIGZz
L2NpZnMvY2lmc2VuY3J5cHQuYyB8ICA0ICsrLS0KPiAgZnMvY2lmcy9jaWZzZ2xvYi5oICAgIHwg
IDYgKysrLS0tCj4gIGZzL2NpZnMvY2lmc3Byb3RvLmggICB8ICA2ICsrKy0tLQo+ICBmcy9jaWZz
L2NpZnNzbWIuYyAgICAgfCAxMiArKysrKystLS0tLS0KPiAgZnMvY2lmcy9pbm9kZS5jICAgICAg
IHwgMzQgKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLQo+ICBmcy9jaWZzL25ldG1p
c2MuYyAgICAgfCAxOSArKysrKysrKysrLS0tLS0tLS0tCj4gIDYgZmlsZXMgY2hhbmdlZCwgNDAg
aW5zZXJ0aW9ucygrKSwgNDEgZGVsZXRpb25zKC0pCgpSZXZpZXdlZC1ieTogUGF1bG8gQWxjYW50
YXJhIDxwYWxjYW50YXJhQHN1c2UuZGU+CgpUaGFua3MKUGF1bG8KX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWTIwMzggbWFpbGluZyBsaXN0ClkyMDM4QGxp
c3RzLmxpbmFyby5vcmcKaHR0cHM6Ly9saXN0cy5saW5hcm8ub3JnL21haWxtYW4vbGlzdGluZm8v
eTIwMzgK
