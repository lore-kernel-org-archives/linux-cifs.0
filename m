From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Linux CIFS client module: login rate limiting
Date: Tue, 24 Jan 2017 15:27:59 +0530
Message-ID: <1485251879.17488.14.camel@redhat.com>
References: <58806F39.9010801@muenchen.de>
         <CAH2r5mtrOqucTBXE3Ni02gWGVBG+o-EbgdVarL1xZjWv0S2xyQ@mail.gmail.com>
         <1485169046.17488.5.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-BwSvFaozjtf13AfTOUA+"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Valentin Hilbig <externer.dl.hilbig-EnyPcy3oyxIb1SvskN2V4Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485169046.17488.5.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--=-BwSvFaozjtf13AfTOUA+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

On Mon, 2017-01-23 at 16:27 +0530, Sachin Prabhu wrote:
> On Fri, 2017-01-20 at 15:30 -0600, Steve French wrote:
> > A couple quick questions:
> > 1) I would not expect "hard" vs "soft" mount option makes no
> > difference here, but just doublechecking
> > 2) How does smb2 reconnect behave in the same scenario (because we
> > prefer smb3 to be used if the server is non-Samba)?
> > 
> > Looks like a fix is doable - see line 1464-1465 of fs/cifs/sess.c
> > 
> >     while (sess_data->func)
> >         sess_data->func(sess_data);
> > 
> > looking at cifs_reconnect in the case where the ip address is not
> > available we wait 3 seconds (if needed to retry), and when that
> > succeeds we schedule delayed work to issue an "echo" (see
> > cifs_reconnect) and then as we do cifs_reconnect_tcon we could wait
> > up
> > to 10 seconds at a time for the socket to come back. If socket is
> > ok
> > we do a negotiate protocol which is not necessarily retried on
> > failure
> > (depending on the request it can return EAGAIN - e.g.
> > read/write/lock/close).  If the negprot succeeds we get to your
> > case
> > where we call cifs_setup_session in fs/cifs/connect.c which calls
> > CIFS_SessSetup (in fs/cifs/sess.c) which looks like it will loop on
> > the sessionsetup retry for the cifs case - which should as you note
> > rate limit (especially on bad password case).
> > 
> > I also would like Sachin's feedback as he made some significant
> > cleanup of session establishment for cifs and rewrote this - wanted
> > to
> > see if he wanted to move the throttling of retries differently
> 
> I think the suggestion is perfectly valid and would be a nice
> addition
> to the cifs module. Maybe a better place to add this change would be
> at
> 
> cifs_reconnect_tcon()
> {
> ..
>         mutex_lock(&ses->session_mutex);
>         rc = cifs_negotiate_protocol(0, ses);
>         if (rc == 0 && ses->need_reconnect)
>                 rc = cifs_setup_session(0, ses, nls_codepage);
> ..
> }
> Where in case of EACCES, we can setup a delayed work to unlock ses-
> > session_mutex set to run after the required interval.
> 

Having given it another look, since it is unlikely to recover
automatically, I think it is better to cache the lookup and return the
cached lookup as long as the cache is still valid. I am also in favour
of a longer cache interval.

Attached is a patch which can work in this case. I use a cache interval
of 10 seconds which can be extended further.


--=-BwSvFaozjtf13AfTOUA+
Content-Disposition: attachment;
	filename="0001-cifs-Cache-Access-denied-errors-when-reconnecting.patch"
Content-Type: text/x-patch;
	name="0001-cifs-Cache-Access-denied-errors-when-reconnecting.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSA3Y2E5MTI1YmU1NTIyNjc5Yzc3N2E4ZTlhMjdhMGFmMjJhM2QyNzNkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTYWNoaW4gUHJhYmh1IDxzcHJhYmh1QHJlZGhhdC5jb20+CkRh
dGU6IFR1ZSwgMjQgSmFuIDIwMTcgMTI6NDM6MDMgKzA1MzAKU3ViamVjdDogW1BBVENIXSBjaWZz
OiBDYWNoZSBBY2Nlc3MgZGVuaWVkIGVycm9ycyB3aGVuIHJlY29ubmVjdGluZwoKSWYgaGUgYWNj
b3VudCBjcmVkZW50aWFscyBvbiBhIG1vdW50ZWQgc2hhcmUgaXMgY2hhbmdlZCB3aGlsZSBzdGls
bAptb3VudGVkLCByZW1vdW50cyB3aWxsIGZhaWwgd2l0aCAtRUFDQ0VTLiBTaW5jZSBhIG5ldyBz
ZXNzaW9uIHNldHVwIGNhbGwKaXMgbWFkZSBldmVyeSB0aW1lIGFuIGF0dGVtcHQgaXMgbWFkZSB0
byBhY2Nlc3MgdGhpcyBzaGFyZSwgYSBsYXJnZQpudW1iZXIgb2YgZmFpbGVkIHNlc3Npb24gc2V0
dXAgY2FsbHMgYXJlIG1hZGUuIFRoaXMgY2F1c2VzIHByb2JsZW1zIHdpdGgKY2VydGFpbiBzZXJ2
ZXIgc2V0dXBzIHdoaWNoIGNvbnNpZGVyIGl0IGFzIGFuIGF0dGFjayBvbiB0aGUgYWNjb3VudCBh
bmQKYmxvY2sgZnVydGhlciBhY2Nlc3MgZnJvbSB0aGUgYWNjb3VudC4gVG8gYXZvaWQgdGhpcywg
Y2FjaGUgYWxsIC1FQUNDRVMKZXJyb3JzIGFuZCBhdm9pZCB0aGlzIHByb2JsZW0uCgpTaWduZWQt
b2ZmLWJ5OiBTYWNoaW4gUHJhYmh1IDxzcHJhYmh1QHJlZGhhdC5jb20+Ci0tLQogZnMvY2lmcy9j
aWZzZ2xvYi5oIHwgIDQgKysrKwogZnMvY2lmcy9jaWZzc21iLmMgIHwgMjAgKysrKysrKysrKysr
KysrKysrLS0KIGZzL2NpZnMvY29ubmVjdC5jICB8IDE0ICsrKysrKysrKysrKysrCiAzIGZpbGVz
IGNoYW5nZWQsIDM2IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
ZnMvY2lmcy9jaWZzZ2xvYi5oIGIvZnMvY2lmcy9jaWZzZ2xvYi5oCmluZGV4IDdlYThhMzMuLjNj
N2MwYzYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2dsb2IuaAorKysgYi9mcy9jaWZzL2NpZnNn
bG9iLmgKQEAgLTc1LDYgKzc1LDggQEAKICNkZWZpbmUgU01CX0VDSE9fSU5URVJWQUxfTUFYIDYw
MAogI2RlZmluZSBTTUJfRUNIT19JTlRFUlZBTF9ERUZBVUxUIDYwCiAKKyNkZWZpbmUgU01CX05F
R0FUSVZFX0NBQ0hFX0lOVEVSVkFMIDEwCisKIC8qCiAgKiBEZWZhdWx0IG51bWJlciBvZiBjcmVk
aXRzIHRvIGtlZXAgYXZhaWxhYmxlIGZvciBTTUIzLgogICogVGhpcyB2YWx1ZSBpcyBjaG9zZW4g
c29tZXdoYXQgYXJiaXRyYXJpbHkuIFRoZSBXaW5kb3dzIGNsaWVudApAQCAtODMyLDYgKzgzNCw4
IEBAIHN0cnVjdCBjaWZzX3NlcyB7CiAJYm9vbCBzaWduOwkJLyogaXMgc2lnbmluZyByZXF1aXJl
ZD8gKi8KIAlib29sIG5lZWRfcmVjb25uZWN0OjE7IC8qIGNvbm5lY3Rpb24gcmVzZXQsIHVpZCBu
b3cgaW52YWxpZCAqLwogCWJvb2wgZG9tYWluQXV0bzoxOworCWJvb2wgY2FjaGVkX3JjOworCXN0
cnVjdCBkZWxheWVkX3dvcmsgY2xlYXJfY2FjaGVkX3JjOwogI2lmZGVmIENPTkZJR19DSUZTX1NN
QjIKIAlfX3UxNiBzZXNzaW9uX2ZsYWdzOwogCV9fdTggc21iM3NpZ25pbmdrZXlbU01CM19TSUdO
X0tFWV9TSVpFXTsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc3NtYi5jIGIvZnMvY2lmcy9jaWZz
c21iLmMKaW5kZXggYjQ3MjYxOC4uMjE5NmQxNiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzc21i
LmMKKysrIGIvZnMvY2lmcy9jaWZzc21iLmMKQEAgLTE3OSw4ICsxNzksMjQgQEAgY2lmc19yZWNv
bm5lY3RfdGNvbihzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCBpbnQgc21iX2NvbW1hbmQpCiAJICov
CiAJbXV0ZXhfbG9jaygmc2VzLT5zZXNzaW9uX211dGV4KTsKIAlyYyA9IGNpZnNfbmVnb3RpYXRl
X3Byb3RvY29sKDAsIHNlcyk7Ci0JaWYgKHJjID09IDAgJiYgc2VzLT5uZWVkX3JlY29ubmVjdCkK
LQkJcmMgPSBjaWZzX3NldHVwX3Nlc3Npb24oMCwgc2VzLCBubHNfY29kZXBhZ2UpOworCWlmIChy
YykgeworCQltdXRleF91bmxvY2soJnNlcy0+c2Vzc2lvbl9tdXRleCk7CisJCWdvdG8gb3V0Owor
CX0KKworCWlmIChzZXMtPm5lZWRfcmVjb25uZWN0KSB7CisJCWlmIChzZXMtPmNhY2hlZF9yYykg
eworCQkJcmMgPSBzZXMtPmNhY2hlZF9yYzsKKwkJfSBlbHNlIHsKKwkJCXJjID0gY2lmc19zZXR1
cF9zZXNzaW9uKDAsIHNlcywgbmxzX2NvZGVwYWdlKTsKKwkJCWlmIChyYyA9PSAtRUFDQ0VTKSB7
CisJCQkJcXVldWVfZGVsYXllZF93b3JrKGNpZnNpb2Rfd3EsCisJCQkJCSZzZXMtPmNsZWFyX2Nh
Y2hlZF9yYywKKwkJCQkJU01CX05FR0FUSVZFX0NBQ0hFX0lOVEVSVkFMICogSFopOworCQkJCXNl
cy0+Y2FjaGVkX3JjID0gcmM7CisJCQl9CisJCX0KKwl9CiAKIAkvKiBkbyB3ZSBuZWVkIHRvIHJl
Y29ubmVjdCB0Y29uPyAqLwogCWlmIChyYyB8fCAhdGNvbi0+bmVlZF9yZWNvbm5lY3QpIHsKZGlm
ZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXggMzVh
ZTQ5ZS4uZjgyYjI4MCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jb25uZWN0LmMKKysrIGIvZnMvY2lm
cy9jb25uZWN0LmMKQEAgLTIzNzUsNiArMjM3NSw3IEBAIGNpZnNfcHV0X3NtYl9zZXMoc3RydWN0
IGNpZnNfc2VzICpzZXMpCiAJbGlzdF9kZWxfaW5pdCgmc2VzLT5zbWJfc2VzX2xpc3QpOwogCXNw
aW5fdW5sb2NrKCZjaWZzX3RjcF9zZXNfbG9jayk7CiAKKwljYW5jZWxfZGVsYXllZF93b3JrX3N5
bmMoJnNlcy0+Y2xlYXJfY2FjaGVkX3JjKTsKIAlzZXNJbmZvRnJlZShzZXMpOwogCWNpZnNfcHV0
X3RjcF9zZXNzaW9uKHNlcnZlciwgMCk7CiB9CkBAIC0yNTEwLDYgKzI1MTEsMTYgQEAgY2lmc19z
ZXRfY2lmc2NyZWRzKHN0cnVjdCBzbWJfdm9sICp2b2wgX19hdHRyaWJ1dGVfXygodW51c2VkKSks
CiB9CiAjZW5kaWYgLyogQ09ORklHX0tFWVMgKi8KIAorc3RhdGljIHZvaWQgY2xlYXJfY2FjaGVk
X3JjKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKK3sKKwlzdHJ1Y3QgY2lmc19zZXMgKnNlcyA9
IGNvbnRhaW5lcl9vZih3b3JrLCBzdHJ1Y3QgY2lmc19zZXMsCisJCQkJCQljbGVhcl9jYWNoZWRf
cmMud29yayk7CisKKwltdXRleF9sb2NrKCZzZXMtPnNlc3Npb25fbXV0ZXgpOworCXNlcy0+Y2Fj
aGVkX3JjID0gMDsKKwltdXRleF91bmxvY2soJnNlcy0+c2Vzc2lvbl9tdXRleCk7Cit9CisKIHN0
YXRpYyBzdHJ1Y3QgY2lmc19zZXMgKgogY2lmc19nZXRfc21iX3NlcyhzdHJ1Y3QgVENQX1NlcnZl
cl9JbmZvICpzZXJ2ZXIsIHN0cnVjdCBzbWJfdm9sICp2b2x1bWVfaW5mbykKIHsKQEAgLTI1OTIs
NiArMjYwMyw5IEBAIGNpZnNfZ2V0X3NtYl9zZXMoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2Vy
dmVyLCBzdHJ1Y3Qgc21iX3ZvbCAqdm9sdW1lX2luZm8pCiAJc2VzLT5zZWN0eXBlID0gdm9sdW1l
X2luZm8tPnNlY3R5cGU7CiAJc2VzLT5zaWduID0gdm9sdW1lX2luZm8tPnNpZ247CiAKKwlzZXMt
PmNhY2hlZF9yYyA9IDA7CisJSU5JVF9ERUxBWUVEX1dPUksoJnNlcy0+Y2xlYXJfY2FjaGVkX3Jj
LCBjbGVhcl9jYWNoZWRfcmMpOworCiAJbXV0ZXhfbG9jaygmc2VzLT5zZXNzaW9uX211dGV4KTsK
IAlyYyA9IGNpZnNfbmVnb3RpYXRlX3Byb3RvY29sKHhpZCwgc2VzKTsKIAlpZiAoIXJjKQotLSAK
Mi45LjMKCg==


--=-BwSvFaozjtf13AfTOUA+--
