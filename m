From: Noel Power <nopower-IBi9RG/b67k@public.gmane.org>
Subject: cifs client not forgiving enough when neg prot smb1 (with extended
 security)
Date: Wed, 27 May 2015 13:06:23 +0100
Message-ID: <5565B33F.2020302@suse.com>
Reply-To: noel.power-IBi9RG/b67k@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040501090706050606000409"
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040501090706050606000409
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi Steve,

Just came across a situation where cifs client was failing to mount a
share with ntlmssp served by cifsd based server.
The server is misbehaving in that is should have set the
EncryptionKeyLength to zero (when offering extended security).
Regardless though, a windows client will happily continue whereas the
cifs client will return IO(5) error. Looking in the MS-SMB spec 
(2.2.4.5.2.1) mentions

"ChallengeLength (1 byte): When the CAP_EXTENDED_SECURITY bit is set,
the server MUST set this value to zero and clients MUST ignore this value."

I attach a patch to cifs for this

thanks,

Noel

--------------040501090706050606000409
Content-Type: text/plain; charset=UTF-8;
 name="0001-client-MUST-ignore-EncryptionKeyLength-if-CAP_EXTEND.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-client-MUST-ignore-EncryptionKeyLength-if-CAP_EXTEND.pa";
 filename*1="tch"

RnJvbSBjY2Q5OWE5MWYzYjczZTQyODFjYWJkOGRkODRiMGU0NmJmZjcxODY1IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBOb2VsIFBvd2VyIDxub2VsLnBvd2VyQHN1c2UuY29t
PgpEYXRlOiBXZWQsIDI3IE1heSAyMDE1IDA5OjIyOjEwICswMTAwClN1YmplY3Q6IFtQQVRD
SF0gY2xpZW50IE1VU1QgaWdub3JlIEVuY3J5cHRpb25LZXlMZW5ndGggaWYKIENBUF9FWFRF
TkRFRF9TRUNVUklUWSBpcyBzZXQKCltNUy1TTUJdIDIuMi40LjUuMi4xIHN0YXRlczoKCiJD
aGFsbGVuZ2VMZW5ndGggKDEgYnl0ZSk6IFdoZW4gdGhlIENBUF9FWFRFTkRFRF9TRUNVUklU
WSBiaXQgaXMgc2V0LAogdGhlIHNlcnZlciBNVVNUIHNldCB0aGlzIHZhbHVlIHRvIHplcm8g
YW5kIGNsaWVudHMgTVVTVCBpZ25vcmUgdGhpcwogdmFsdWUuIgoKU2lnbmVkLW9mZi1ieTog
Tm9lbCBQb3dlciA8bm9lbC5wb3dlckBzdXNlLmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNzbWIu
YyB8IDUgKystLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDMgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzc21iLmMgYi9mcy9jaWZzL2NpZnNz
bWIuYwppbmRleCA1ZjFmMzI4Li5lYTkzOGE4IDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNz
bWIuYworKysgYi9mcy9jaWZzL2NpZnNzbWIuYwpAQCAtNjI5LDkgKzYyOSw4IEBAIENJRlNT
TUJOZWdvdGlhdGUoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfc2VzICpz
ZXMpCiAJCXNlcnZlci0+bmVnZmxhdm9yID0gQ0lGU19ORUdGTEFWT1JfVU5FTkNBUDsKIAkJ
bWVtY3B5KHNlcy0+c2VydmVyLT5jcnlwdGtleSwgcFNNQnItPnUuRW5jcnlwdGlvbktleSwK
IAkJICAgICAgIENJRlNfQ1JZUFRPX0tFWV9TSVpFKTsKLQl9IGVsc2UgaWYgKChwU01Cci0+
aGRyLkZsYWdzMiAmIFNNQkZMRzJfRVhUX1NFQyB8fAotCQkJc2VydmVyLT5jYXBhYmlsaXRp
ZXMgJiBDQVBfRVhURU5ERURfU0VDVVJJVFkpICYmCi0JCQkJKHBTTUJyLT5FbmNyeXB0aW9u
S2V5TGVuZ3RoID09IDApKSB7CisJfSBlbHNlIGlmIChwU01Cci0+aGRyLkZsYWdzMiAmIFNN
QkZMRzJfRVhUX1NFQyB8fAorCQkJc2VydmVyLT5jYXBhYmlsaXRpZXMgJiBDQVBfRVhURU5E
RURfU0VDVVJJVFkpIHsKIAkJc2VydmVyLT5uZWdmbGF2b3IgPSBDSUZTX05FR0ZMQVZPUl9F
WFRFTkRFRDsKIAkJcmMgPSBkZWNvZGVfZXh0X3NlY19ibG9iKHNlcywgcFNNQnIpOwogCX0g
ZWxzZSBpZiAoc2VydmVyLT5zZWNfbW9kZSAmIFNFQ01PREVfUFdfRU5DUllQVCkgewotLSAK
MS44LjUuNgoK
--------------040501090706050606000409--
