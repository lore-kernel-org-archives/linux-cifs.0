From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH][v2][CIFS] Fix setting time before epoch (negative time values)
Date: Tue, 16 Sep 2014 00:51:10 -0500
Message-ID: <CAH2r5mtLFMqkyoJKVzxUBLfSVwo+3i+XVB6S-_ahQ8ZkpFsD0g@mail.gmail.com>
References: <CAH2r5mscOTdr9WzazvhydC9DazgBs1MrEkdzQSzarF4XVmfjiA@mail.gmail.com>
 <20140915171405.GA21353@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b67784ad25e5a0503285763
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140915171405.GA21353-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--047d7b67784ad25e5a0503285763
Content-Type: text/plain; charset=UTF-8

Resending as attachment to avoid mailer issues

On Mon, Sep 15, 2014 at 12:14 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>>      /* Subtract the NTFS time offset, then convert to 1s intervals. */
>> -    u64 t;
>> +    s64 t = le64_to_cpu(ntutc) - NTFS_TIME_OFFSET;
>> +
>> +    /*
>
> The patch looks whitespace damaged.
>



-- 
Thanks,

Steve

--047d7b67784ad25e5a0503285763
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-CIFS-Fix-setting-time-before-epoch-negative-time-val.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-Fix-setting-time-before-epoch-negative-time-val.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i04to8940

RnJvbSAyYWU4M2JmOTM4ODJkMWVjMGNkNzc1YzQ4OWJkMWJlZTYxMWY3OTJlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogU3VuLCAxNCBTZXAgMjAxNCAxNzowNjozNiAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggMS80XSBb
Q0lGU10gRml4IHNldHRpbmcgdGltZSBiZWZvcmUgZXBvY2ggKG5lZ2F0aXZlIHRpbWUKIHZhbHVl
cykKCnhmc3Rlc3QgZ2VuZXJpYy8yNTggc2V0cyB0aGUgdGltZSBvbiBhIGZpbGUgdG8gYSBuZWdh
dGl2ZSB2YWx1ZQooYmVmb3JlIDE5NzApIHdoaWNoIGZhaWxzIHNpbmNlIGRvX2RpdiBjYW4gbm90
IGhhbmRsZSBuZWdhdGl2ZQpudW1iZXJzLiAgSW4gYWRkaXRpb24gJ25vcm1hbCcgZGl2aXNpb24g
b2YgNjQgYml0IHZhbHVlcyBkb2VzCm5vdCBidWlsZCBvbiAzMiBiaXQgYXJjaCBzbyBoYXZlIHRv
IHdvcmthcm91bmQgdGhpcyBieSBzcGVjaWFsCmNhc2luZyBuZWdhdGl2ZSB2YWx1ZXMgaW4gY2lm
c19OVHRpbWVUb1VuaXgKClNhbWJhIHNlcnZlciBhbHNvIGhhcyBhIGJ1ZyB3aXRoIHRoaXMgKHNl
ZSBzYW1iYSBidWd6aWxsYSA3NzcxKQpidXQgaXQgd29ya3MgdG8gV2luZG93cyBzZXJ2ZXIuCgpT
aWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KLS0tCiBmcy9j
aWZzL25ldG1pc2MuYyB8IDIwICsrKysrKysrKysrKysrKystLS0tCiAxIGZpbGUgY2hhbmdlZCwg
MTYgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL25l
dG1pc2MuYyBiL2ZzL2NpZnMvbmV0bWlzYy5jCmluZGV4IDY4MzRiOWMuLmIzMzNmZjYgMTAwNjQ0
Ci0tLSBhL2ZzL2NpZnMvbmV0bWlzYy5jCisrKyBiL2ZzL2NpZnMvbmV0bWlzYy5jCkBAIC05MjUs
MTEgKzkyNSwyMyBAQCBjaWZzX05UdGltZVRvVW5peChfX2xlNjQgbnR1dGMpCiAJLyogQkIgd2hh
dCBhYm91dCB0aGUgdGltZXpvbmU/IEJCICovCiAKIAkvKiBTdWJ0cmFjdCB0aGUgTlRGUyB0aW1l
IG9mZnNldCwgdGhlbiBjb252ZXJ0IHRvIDFzIGludGVydmFscy4gKi8KLQl1NjQgdDsKKwlzNjQg
dCA9IGxlNjRfdG9fY3B1KG50dXRjKSAtIE5URlNfVElNRV9PRkZTRVQ7CisKKwkvKgorCSAqIFVu
Zm9ydHVuYXRlbHkgY2FuIG5vdCB1c2Ugbm9ybWFsIDY0IGJpdCBkaXZpc2lvbiBvbiAzMiBiaXQg
YXJjaCwgYnV0CisJICogdGhlIGFsdGVybmF0aXZlLCBkb19kaXYsIGRvZXMgbm90IHdvcmsgd2l0
aCBuZWdhdGl2ZSBudW1iZXJzIHNvIGhhdmUKKwkgKiB0byBzcGVjaWFsIGNhc2UgdGhlbQorCSAq
LworCWlmICh0IDwgMCkgeworCQl0ID0gLXQ7CisJCXRzLnR2X25zZWMgPSAobG9uZykoZG9fZGl2
KHQsIDEwMDAwMDAwKSAqIDEwMCk7CisJCXRzLnR2X25zZWMgPSAtdHMudHZfbnNlYzsKKwkJdHMu
dHZfc2VjID0gLXQ7CisJfSBlbHNlIHsKKwkJdHMudHZfbnNlYyA9IChsb25nKWRvX2Rpdih0LCAx
MDAwMDAwMCkgKiAxMDA7CisJCXRzLnR2X3NlYyA9IHQ7CisJfQogCi0JdCA9IGxlNjRfdG9fY3B1
KG50dXRjKSAtIE5URlNfVElNRV9PRkZTRVQ7Ci0JdHMudHZfbnNlYyA9IGRvX2Rpdih0LCAxMDAw
MDAwMCkgKiAxMDA7Ci0JdHMudHZfc2VjID0gdDsKIAlyZXR1cm4gdHM7CiB9CiAKLS0gCjEuOS4x
Cgo=
--047d7b67784ad25e5a0503285763--
