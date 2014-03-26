From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [CIFS][PATCH] Return correct error code on query xattr when empty
 xattr list
Date: Tue, 25 Mar 2014 19:53:40 -0500
Message-ID: <CAH2r5msaxk6hGCL_HiQ+ZGK4L7Ryr=uKYyhwTfrz7CvtSgd7Pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b15a52b8a6bed04f577e77a
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--047d7b15a52b8a6bed04f577e77a
Content-Type: text/plain; charset=ISO-8859-1

In working on getting xfstest working on cifs found the following problem.

>From c6845613066b4544978de749cd5c73fb14ed936b Mon Sep 17 00:00:00 2001
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Tue, 25 Mar 2014 19:46:36 -0500
Subject: [PATCH] [CIFS] Return correct error on query of xattr on file with
 empty xattrs

xfstest 020 detected a problem with cifs xattr handling.  When a file
had an empty xattr list, we returned success (with an empty xattr value)
on query of particular xattrs rather than returning ENODATA.
This patch fixes it so that query of an xattr returns ENODATA when the
xattr list is empty for the file.

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifssmb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index f3264bd..6ce4e09 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -6197,6 +6197,9 @@ QAllEAsRetry:
     cifs_dbg(FYI, "ea length %d\n", list_len);
     if (list_len <= 8) {
         cifs_dbg(FYI, "empty EA list returned from server\n");
+        /* didn't find the named attribute */
+        if (ea_name)
+            rc = -ENODATA;
         goto QAllEAsOut;
     }

-- 
1.8.5.3

-- 
Thanks,

Steve

--047d7b15a52b8a6bed04f577e77a
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-CIFS-Return-correct-error-on-query-of-xattr-on-file-.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-Return-correct-error-on-query-of-xattr-on-file-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ht7wf4ob0

RnJvbSBjNjg0NTYxMzA2NmI0NTQ0OTc4ZGU3NDljZDVjNzNmYjE0ZWQ5MzZiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogVHVlLCAyNSBNYXIgMjAxNCAxOTo0NjozNiAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIFtDSUZT
XSBSZXR1cm4gY29ycmVjdCBlcnJvciBvbiBxdWVyeSBvZiB4YXR0ciBvbiBmaWxlIHdpdGgKIGVt
cHR5IHhhdHRycwoKeGZzdGVzdCAwMjAgZGV0ZWN0ZWQgYSBwcm9ibGVtIHdpdGggY2lmcyB4YXR0
ciBoYW5kbGluZy4gIFdoZW4gYSBmaWxlCmhhZCBhbiBlbXB0eSB4YXR0ciBsaXN0LCB3ZSByZXR1
cm5lZCBzdWNjZXNzICh3aXRoIGFuIGVtcHR5IHhhdHRyIHZhbHVlKQpvbiBxdWVyeSBvZiBwYXJ0
aWN1bGFyIHhhdHRycyByYXRoZXIgdGhhbiByZXR1cm5pbmcgRU5PREFUQS4KVGhpcyBwYXRjaCBm
aXhlcyBpdCBzbyB0aGF0IHF1ZXJ5IG9mIGFuIHhhdHRyIHJldHVybnMgRU5PREFUQSB3aGVuIHRo
ZQp4YXR0ciBsaXN0IGlzIGVtcHR5IGZvciB0aGUgZmlsZS4KClNpZ25lZC1vZmYtYnk6IFN0ZXZl
IEZyZW5jaCA8c21mcmVuY2hAZ21haWwuY29tPgotLS0KIGZzL2NpZnMvY2lmc3NtYi5jIHwgMyAr
KysKIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9jaWZz
L2NpZnNzbWIuYyBiL2ZzL2NpZnMvY2lmc3NtYi5jCmluZGV4IGYzMjY0YmQuLjZjZTRlMDkgMTAw
NjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc3NtYi5jCisrKyBiL2ZzL2NpZnMvY2lmc3NtYi5jCkBAIC02
MTk3LDYgKzYxOTcsOSBAQCBRQWxsRUFzUmV0cnk6CiAJY2lmc19kYmcoRllJLCAiZWEgbGVuZ3Ro
ICVkXG4iLCBsaXN0X2xlbik7CiAJaWYgKGxpc3RfbGVuIDw9IDgpIHsKIAkJY2lmc19kYmcoRllJ
LCAiZW1wdHkgRUEgbGlzdCByZXR1cm5lZCBmcm9tIHNlcnZlclxuIik7CisJCS8qIGRpZG4ndCBm
aW5kIHRoZSBuYW1lZCBhdHRyaWJ1dGUgKi8KKwkJaWYgKGVhX25hbWUpCisJCQlyYyA9IC1FTk9E
QVRBOwogCQlnb3RvIFFBbGxFQXNPdXQ7CiAJfQogCi0tIAoxLjguNS4zCgo=
--047d7b15a52b8a6bed04f577e77a--
