From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: CIFS data coherency problem
Date: Wed, 8 Sep 2010 10:49:13 +0400
Message-ID: <AANLkTi=_eMSC99K1a2zWpgW5nc8UArzKj2MWHaRmCXzK@mail.gmail.com>
References: <AANLkTin2iSc=Ob3DkhARJRV7CzwRUBJSGRMUJNJM+82k@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=005045015678572d1e048fb9e956
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin2iSc=Ob3DkhARJRV7CzwRUBJSGRMUJNJM+82k-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--005045015678572d1e048fb9e956
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: quoted-printable

---------- Forwarded message ----------
From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: 2010/9/8
Subject: CIFS data coherency problem
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
=EB=CF=D0=C9=D1: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Hello!

I faced with a problem of the wrong cifs cache behavior while adapting
CIFS VFS client for working with the application which uses file
system as a mechanism for storing data and organizing paralell access
from several client. If we look at CIFS code, we can see that it uses
kernel cache mechanism all the time (do_sync_read, do_sync_write, etc)
and delegate all the checking for validating data to cifs_revalidate
call.

cifs_revalidate call uses QueryInfo protocol command for checking
mtime and file size. I noticed that the server doesn't update mtime
every time we writng to the server - that's why we can't use it.

On another hand CIFS spec says that the client can't use cache for if
it doesn't have an oplock - if we don't follow the spec, we can faced
with other problems.

Even more: if we use a Windows server and the mandatory locking style,
now we can read from locking by other clients range (if we have this
data in cache) - it's not right.

As the solution, I suggest to follow the spec in every it's part: to
do cache write/read if we have Exclusive oplock, to do cache read if
we have Oplock Level II and as for other cases - use direct operations
with the server.

I attached the test (cache_problem.py) that shows the problem.

What do you think about it? I have the code that do read/write
according to the spec but I want to discuss this question before
posting the patch because I think it's rather important

--
Best regards,
Pavel Shilovsky.



--=20
Best regards,
Pavel Shilovsky.

--005045015678572d1e048fb9e956
Content-Type: application/octet-stream; name="cache_problem.py"
Content-Disposition: attachment; filename="cache_problem.py"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gdttgufe1

IyEvYmluL2VudiBweXRob24KIwojIFdlIGhhdmUgdG8gbW91bnQgdGhlIHNhbWUgc2hhcmUgdG8g
dGVzdCwgdGVzdDEsIHRlc3QyIGRpcmVjdG9yaWVzIHRoYXQgbG9jYXRlIGluIHRoZSBkaXJlY3Rv
cnkgd2UKIyBleGVjdXRlIHRoaXMgc2NyaXB0IGZyb20uCgpmcm9tIG9zIGltcG9ydCBvcGVuLCBj
bG9zZSwgT19SRFdSLCBPX0NSRUFULCB3cml0ZSwgcmVhZCwgT19SRE9OTFksIE9fV1JPTkxZLCBP
X1RSVU5DLCBsc2VlawoKZiA9IG9wZW4oJ3Rlc3QvX3Rlc3Q0MzIxXycsIE9fUkRXUiB8IE9fQ1JF
QVQgfCBPX1RSVU5DKQp3cml0ZShmLCAnJy5qb2luKCdhJyBmb3IgXyBpbiByYW5nZSg0MDk2KSkp
CmNsb3NlKGYpCgpmMSA9IG9wZW4oJ3Rlc3QxL190ZXN0NDMyMV8nLCBPX1JEV1IpCmYyID0gb3Bl
bigndGVzdDIvX3Rlc3Q0MzIxXycsIE9fUkRXUikKCndyaXRlKGYxLCAneCcpCnByaW50ICd4IGlz
IHdyaXR0ZW4gdGhyb3VnaCBmMScKcHJpbnQgJyVjIGlzIHJlYWQgZnJvbSBmMicgJSByZWFkKGYy
LCAxKQoKd3JpdGUoZjEsICd5JykKcHJpbnQgJ3kgaXMgd3JpdHRlbiB0aHJvdWdoIGYxJwpwcmlu
dCAnJWMgaXMgcmVhZCBmcm9tIGYyJyAlIHJlYWQoZjIsIDEpCgp3cml0ZShmMSwgJ3onKQpwcmlu
dCAneiBpcyB3cml0dGVuIHRocm91Z2ggZjEnCnByaW50ICclYyBpcyByZWFkIGZyb20gZjInICUg
cmVhZChmMiwgMSkKCmNsb3NlKGYxKQpjbG9zZShmMikK
--005045015678572d1e048fb9e956--
