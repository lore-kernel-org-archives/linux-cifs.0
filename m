From: Ira Cooper <ira@wakeful.net>
Subject: Interop Issue: SMB2+ async replies, and the kernel,
 Samba side fix enclosed.
Date: Tue, 23 Feb 2016 07:55:59 -0500
Message-ID: <CAAPGDwLnp90t7wiRb_tw-Md0jv-8w0Ye66jNcsRNioganVe2xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11c02116c5ed21052c6f79f7
Cc: sfrench <sfrench@samba.org>
To: Samba Technical <samba-technical@lists.samba.org>,
 linux-cifs@vger.kernel.org
Return-path: <samba-technical-bounces@lists.samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical/>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Errors-To: samba-technical-bounces@lists.samba.org
Sender: "samba-technical" <samba-technical-bounces@lists.samba.org>
List-Id: linux-cifs.vger.kernel.org

--001a11c02116c5ed21052c6f79f7
Content-Type: text/plain; charset=UTF-8

If the server sends an interim response, then the real response, the real
response, is handled by standard_receive3() in the kernel, instead of the
proper function, and this causes a disconnect.  If there isn't a
disconnect, I believe the reply will just be discarded if I understand the
code correctly.  (That is a big if here ;) )

I've written a patch for Samba to stop sending interim replies on SMB2_READ
and SMB2_WRITE, when non-compounded to stop the impact of this issue.  We
may want to add SMB2_CREATE to the list of ops we don't send async replies
for non-compounded, but I'm not sold either way, I know we CAN go async
there!  I want some opinions here.

This is not hidden behind a flag because compatibility issues that don't
impact protocol correctness usually aren't.

Setting req->async_te = talloc_new(NULL); is just ugly, though it works.
If you have a cleaner approach, I welcome it.

I request you please ASK me before pushing this one, yes, that means you
jra!

For those interested in reproduction: I'd suggest using a server that's
rebuilt with a lower timeout set in smb2_read.c, though we've hit it with
vfs_glusterfs straight up, in our testing.

Thanks,

-Ira / ira@(samba.org|redhat.com|wakeful.net)

--001a11c02116c5ed21052c6f79f7
Content-Type: application/mbox;
	name="0001-smbd-Work-around-for-AIO-with-the-Linux-CIFS-client-.patch"
Content-Disposition: attachment;
	filename="0001-smbd-Work-around-for-AIO-with-the-Linux-CIFS-client-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ikzegzi90

RnJvbSAyOTFkMWUxZjZkZjQxMWM0MmY0MDYwZTljMjFhNTVlNjk3ZTk5OWNmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBJcmEgQ29vcGVyIDxpcmFAc2FtYmEub3JnPgpEYXRlOiBUdWUs
IDIzIEZlYiAyMDE2IDAwOjUzOjIyIC0wNTAwClN1YmplY3Q6IFtQQVRDSF0gc21iZDogV29yayBh
cm91bmQgZm9yIEFJTyB3aXRoIHRoZSBMaW51eCBDSUZTIGNsaWVudCArIFNNQjIrLgoKVGhlIGtl
cm5lbCBjbGllbnQgY2FuJ3QgaGFuZGxlIGFzeW5jIHJlcGxpZXMgYXQgdGhpcyB0aW1lLCBzbwp0
aGlzIGNvZGUgZGlzYWJsZXMgYXN5bmMgcmVwbGllcyBmb3Igbm9uLWNvbXBvdW5kZWQgcmVhZHMg
YW5kCndyaXRlcy4KCkFkZGluZyBjcmVhdGUgdG8gdGhlIGxpc3Qgd291bGQgYmUgdmFsaWQgYXMg
d2VsbCwgYnV0IHdlIGhhdmVuJ3QKcnVuIGludG8gdGhhdCBjYXNlIHlldC4KClNpZ25lZC1vZmYt
Ynk6IElyYSBDb29wZXIgPGlyYUBzYW1iYS5vcmc+Ci0tLQogc291cmNlMy9zbWJkL3NtYjJfc2Vy
dmVyLmMgfCAyNiArKysrKysrKysrKysrKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDI2
IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9zb3VyY2UzL3NtYmQvc21iMl9zZXJ2ZXIuYyBi
L3NvdXJjZTMvc21iZC9zbWIyX3NlcnZlci5jCmluZGV4IGFjOTIyYTEuLmJjOWExNDcgMTAwNjQ0
Ci0tLSBhL3NvdXJjZTMvc21iZC9zbWIyX3NlcnZlci5jCisrKyBiL3NvdXJjZTMvc21iZC9zbWIy
X3NlcnZlci5jCkBAIC0xNDM3LDcgKzE0MzcsMzMgQEAgTlRTVEFUVVMgc21iZF9zbWIyX3JlcXVl
c3RfcGVuZGluZ19xdWV1ZShzdHJ1Y3Qgc21iZF9zbWIyX3JlcXVlc3QgKnJlcSwKIAkJCWZsYWdz
ID0gKElWQUwob3V0aGRyLCBTTUIyX0hEUl9GTEFHUykgJiB+U01CMl9IRFJfRkxBR19DSEFJTkVE
KTsKIAkJCVNJVkFMKG91dGhkciwgU01CMl9IRFJfRkxBR1MsIGZsYWdzKTsKIAkJfQorCX0gZWxz
ZSB7CisJCWNvbnN0IHVpbnQ4X3QgKmluaGRyID0gTlVMTDsKKwkJdWludDE2X3Qgb3Bjb2RlID0g
MHhGRkZGOworCisJCS8qIFZlcmlmeSB0aGF0IHRoaXMgaXMgbm90IGEgY29tcG91bmQgKi8KKwkJ
aWYgKHJlcS0+aW4udmVjdG9yX2NvdW50ID09IDEgKyBTTUJEX1NNQjJfTlVNX0lPVl9QRVJfUkVR
KSB7CisJCQlpbmhkciA9IFNNQkRfU01CMl9JTl9IRFJfUFRSKHJlcSk7CisJCQlvcGNvZGUgPSBT
VkFMKGluaGRyLCBTTUIyX0hEUl9PUENPREUpOworCisJCQkvKgorCQkJICogQmxvY2sgc2VuZGlu
ZyBhbiBpbnRlcmltIHJlcGx5IG9uIFNNQjJfUkVBRC9TTUIyX1dSSVRFCisJCQkgKiBiZWNhdXNl
IG9mIGEgYnVnIGluIHRoZSBMaW51eCBDSUZTIGNsaWVudCBpbiBoYW5kbGluZworCQkJICogYXN5
bmMgcmVwbGllcy4KKwkJCSAqLworCQkJaWYgKG9wY29kZSA9PSBTTUIyX09QX1JFQUQgfHwgb3Bj
b2RlID09IFNNQjJfT1BfV1JJVEUpIHsKKwkJCQkvKgorCQkJCSAqIFNldHRpbmcgdGhlIGFzeW5j
X3RlIHdpbGwgc3RvcCBhbnkgZnVydGhlcgorCQkJCSAqIGFzeW5jIHByb2Nlc3NpbmcuICBUaGFu
a2Z1bGx5IG5vdGhpbmcgaGFuZGxlcworCQkJCSAqIHRoZSB0aW1lciBkaXJlY3RseSwgb3IgdGhp
cyBoYWNrIHdvdWxkIG5vdAorCQkJCSAqIHdvcmsuCisJCQkJICovCisJCQkJcmVxLT5hc3luY190
ZSA9IHRhbGxvY19uZXcoTlVMTCk7CisJCQkJcmV0dXJuIE5UX1NUQVRVU19PSzsKKwkJCX0KKwkJ
fQogCX0KKwogCWlmIChyZXEtPmxhc3Rfa2V5Lmxlbmd0aCA+IDApIHsKIAkJZGF0YV9ibG9iX2Ns
ZWFyX2ZyZWUoJnJlcS0+bGFzdF9rZXkpOwogCX0KLS0gCjIuNS4wCgo=
--001a11c02116c5ed21052c6f79f7--
