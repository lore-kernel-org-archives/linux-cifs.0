From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [SMB3] Handle O_SYNC/DSYNC and O_DIRECT flags on SMB3 opens
Date: Fri, 22 Sep 2017 01:47:46 -0500
Message-ID: <CAH2r5mv4ZN9dtpmhDk8_enVPwJqPBoewrVBtV6Hv64QE+saj5Q@mail.gmail.com>
References: <CAH2r5msgp0GsR8zj9ku7CKHB2amUavj1Bd42YELYUqTcVtJ0EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="089e082682f460b7200559c19752"
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msgp0GsR8zj9ku7CKHB2amUavj1Bd42YELYUqTcVtJ0EA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--089e082682f460b7200559c19752
Content-Type: text/plain; charset="UTF-8"

---------- Forwarded message ----------
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Fri, Sep 22, 2017 at 1:43 AM
Subject: [SMB3] Handle O_SYNC/DSYNC and O_DIRECT flags on SMB3 opens
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


We were only handling them on CIFS POSIX/Unix mounts.

Fix them for SMB3 (and non-POSIX CIFS) mounts



--
Thanks,

Steve


-- 
Thanks,

Steve

--089e082682f460b7200559c19752
Content-Type: text/x-patch; charset="US-ASCII";
	name="0001-SMB3-Ensure-that-O_SYNC-O_DSYNC-and-O_DIRECT-flags-a.patch"
Content-Disposition: attachment;
	filename="0001-SMB3-Ensure-that-O_SYNC-O_DSYNC-and-O_DIRECT-flags-a.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j7visjax0

RnJvbSBiZWE5OWFiNzMzZjAzM2MyZGNlZGI4YjYwNDk2MzQ2MmZhMmQ0MDYyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogRnJpLCAyMiBTZXAgMjAxNyAwMTo0MDoyNyAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIFtTTUIz
XSBFbnN1cmUgdGhhdCBPX1NZTkMvT19EU1lOQyBhbmQgT19ESVJFQ1QgZmxhZ3MgYXJlCiBob25v
cmVkIG9uIFNNQjMgbW91bnRzCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNo
QGdtYWlsLmNvbT4KQ0M6IFN0YWJsZSA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4KLS0tCiBmcy9j
aWZzL2ZpbGUuYyB8IDcgKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKQoK
ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvZmlsZS5jIGIvZnMvY2lmcy9maWxlLmMKaW5kZXggODIyMzEx
OS4uOTJmZGY5YyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9maWxlLmMKKysrIGIvZnMvY2lmcy9maWxl
LmMKQEAgLTIyNCw2ICsyMjQsMTMgQEAgY2lmc19udF9vcGVuKGNoYXIgKmZ1bGxfcGF0aCwgc3Ry
dWN0IGlub2RlICppbm9kZSwgc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwKIAlpZiAoYmFj
a3VwX2NyZWQoY2lmc19zYikpCiAJCWNyZWF0ZV9vcHRpb25zIHw9IENSRUFURV9PUEVOX0JBQ0tV
UF9JTlRFTlQ7CiAKKwkvKiBPX1NZTkMgYWxzbyBoYXMgYml0IGZvciBPX0RTWU5DIHNvIGZvbGxv
d2luZyBjaGVjayBwaWNrcyB1cCBlaXRoZXIgKi8KKwlpZiAoZl9mbGFncyAmIE9fU1lOQykKKwkJ
Y3JlYXRlX29wdGlvbnMgfD0gQ1JFQVRFX1dSSVRFX1RIUk9VR0g7CisKKwlpZiAoZl9mbGFncyAm
IE9fRElSRUNUKQorCQljcmVhdGVfb3B0aW9ucyB8PSBDUkVBVEVfTk9fQlVGRkVSOworCiAJb3Bh
cm1zLnRjb24gPSB0Y29uOwogCW9wYXJtcy5jaWZzX3NiID0gY2lmc19zYjsKIAlvcGFybXMuZGVz
aXJlZF9hY2Nlc3MgPSBkZXNpcmVkX2FjY2VzczsKLS0gCjIuNy40Cgo=
--089e082682f460b7200559c19752--
