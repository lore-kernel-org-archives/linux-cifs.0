From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Interop Issue: SMB2+ async replies, and the kernel, Samba side
 fix enclosed.
Date: Sat, 27 Feb 2016 12:26:33 +0300
Message-ID: <CAKywueT52EeF58tRiEKFqqm5D2uMuMqWXJyr7FPUa8p5mjMMtA@mail.gmail.com>
References: <CAAPGDwLnp90t7wiRb_tw-Md0jv-8w0Ye66jNcsRNioganVe2xg@mail.gmail.com>
	<CAKywueSMFrvreB8JMtwj8kt1BY1Yyq-Guy3Q3=wZFzuLCCOjZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11380a16f2d4f7052cbd0249
Cc: Samba Technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	sfrench <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Ira Cooper <ira-mA6sH8tAw6XR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueSMFrvreB8JMtwj8kt1BY1Yyq-Guy3Q3=wZFzuLCCOjZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--001a11380a16f2d4f7052cbd0249
Content-Type: text/plain; charset=UTF-8

2016-02-27 12:11 GMT+03:00 Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>
> 2016-02-23 15:55 GMT+03:00 Ira Cooper <ira-mA6sH8tAw6XR7s880joybQ@public.gmane.org>:
>>
>> If the server sends an interim response, then the real response, the real
>> response, is handled by standard_receive3() in the kernel, instead of the
>> proper function, and this causes a disconnect.  If there isn't a
>> disconnect, I believe the reply will just be discarded if I understand the
>> code correctly.  (That is a big if here ;) )
>>
>> I've written a patch for Samba to stop sending interim replies on SMB2_READ
>> and SMB2_WRITE, when non-compounded to stop the impact of this issue.  We
>> may want to add SMB2_CREATE to the list of ops we don't send async replies
>> for non-compounded, but I'm not sold either way, I know we CAN go async
>> there!  I want some opinions here.
>>
>> This is not hidden behind a flag because compatibility issues that don't
>> impact protocol correctness usually aren't.
>>
>> Setting req->async_te = talloc_new(NULL); is just ugly, though it works.
>> If you have a cleaner approach, I welcome it.
>>
>> I request you please ASK me before pushing this one, yes, that means you
>> jra!
>>
>> For those interested in reproduction: I'd suggest using a server that's
>> rebuilt with a lower timeout set in smb2_read.c, though we've hit it with
>> vfs_glusterfs straight up, in our testing.
>>
>> Thanks,
>>
>> -Ira / ira@(samba.org|redhat.com|wakeful.net)
>
>
>
> Thank you for catching this!
>
> It is the issue in the kernel client - a check for interim responses is missed for SMB2_READ command. I created a patch that should fix the problem.
>
> Could you please test it?
>
> --
> Best regards,
> Pavel Shilovsky

CC'ing @samba-technical (my original email was rejected by the server).

Sorry for the spam.

-- 
Best regards,
Pavel Shilovsky

--001a11380a16f2d4f7052cbd0249
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-CIFS-Fix-SMB2-interim-response-processing-for-read-r.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-Fix-SMB2-interim-response-processing-for-read-r.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_il4x25ex1

RnJvbSAwOTkwNGJmMGM2YTFlY2M3ZjYxZDQ3NTVkYjMzYjc2MmI1MzE3NmQ2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQYXZlbCBTaGlsb3Zza3kgPHBzaGlsb3Zza3lAc2FtYmEub3Jn
PgpEYXRlOiBTYXQsIDI3IEZlYiAyMDE2IDExOjU4OjE4ICswMzAwClN1YmplY3Q6IFtQQVRDSF0g
Q0lGUzogRml4IFNNQjIrIGludGVyaW0gcmVzcG9uc2UgcHJvY2Vzc2luZyBmb3IgcmVhZCByZXF1
ZXN0cwoKRm9yIGludGVyaW0gcmVzcG9uc2VzIHdlIG9ubHkgbmVlZCB0byBwYXJzZSBhIGhlYWRl
ciBhbmQgdXBkYXRlCmEgbnVtYmVyIGNyZWRpdHMuIE5vdyBpdCBpcyBkb25lIGZvciBhbGwgU01C
MisgY29tbWFuZCBleGNlcHQKU01CMl9SRUFEIHdoaWNoIGlzIHdyb25nLiBGaXggdGhpcyBieSBh
ZGRpbmcgc3VjaCBwcm9jZXNzaW5nLgoKU2lnbmVkLW9mZi1ieTogUGF2ZWwgU2hpbG92c2t5IDxw
c2hpbG92c2t5QHNhbWJhLm9yZz4KLS0tCiBmcy9jaWZzL2NpZnNzbWIuYyB8IDIxICsrKysrKysr
KysrKysrKysrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDMgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzc21iLmMgYi9mcy9jaWZzL2NpZnNzbWIu
YwppbmRleCA5MGI0ZjlmLi43NmZjYjUwIDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNzbWIuYwor
KysgYi9mcy9jaWZzL2NpZnNzbWIuYwpAQCAtMTM5NiwxMSArMTM5NiwxMCBAQCBvcGVuUmV0cnk6
CiAgKiBjdXJyZW50IGJpZ2J1Zi4KICAqLwogc3RhdGljIGludAotY2lmc19yZWFkdl9kaXNjYXJk
KHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwgc3RydWN0IG1pZF9xX2VudHJ5ICptaWQp
CitkaXNjYXJkX3JlbWFpbmluZ19kYXRhKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcikK
IHsKIAl1bnNpZ25lZCBpbnQgcmZjbGVuID0gZ2V0X3JmYzEwMDJfbGVuZ3RoKHNlcnZlci0+c21h
bGxidWYpOwogCWludCByZW1haW5pbmcgPSByZmNsZW4gKyA0IC0gc2VydmVyLT50b3RhbF9yZWFk
OwotCXN0cnVjdCBjaWZzX3JlYWRkYXRhICpyZGF0YSA9IG1pZC0+Y2FsbGJhY2tfZGF0YTsKIAog
CXdoaWxlIChyZW1haW5pbmcgPiAwKSB7CiAJCWludCBsZW5ndGg7CkBAIC0xNDE0LDEwICsxNDEz
LDIwIEBAIGNpZnNfcmVhZHZfZGlzY2FyZChzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIs
IHN0cnVjdCBtaWRfcV9lbnRyeSAqbWlkKQogCQlyZW1haW5pbmcgLT0gbGVuZ3RoOwogCX0KIAot
CWRlcXVldWVfbWlkKG1pZCwgcmRhdGEtPnJlc3VsdCk7CiAJcmV0dXJuIDA7CiB9CiAKK3N0YXRp
YyBpbnQKK2NpZnNfcmVhZHZfZGlzY2FyZChzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIs
IHN0cnVjdCBtaWRfcV9lbnRyeSAqbWlkKQoreworCWludCBsZW5ndGg7CisJc3RydWN0IGNpZnNf
cmVhZGRhdGEgKnJkYXRhID0gbWlkLT5jYWxsYmFja19kYXRhOworCisJbGVuZ3RoID0gZGlzY2Fy
ZF9yZW1haW5pbmdfZGF0YShzZXJ2ZXIpOworCWRlcXVldWVfbWlkKG1pZCwgcmRhdGEtPnJlc3Vs
dCk7CisJcmV0dXJuIGxlbmd0aDsKK30KKwogaW50CiBjaWZzX3JlYWR2X3JlY2VpdmUoc3RydWN0
IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLCBzdHJ1Y3QgbWlkX3FfZW50cnkgKm1pZCkKIHsKQEAg
LTE0NDYsNiArMTQ1NSwxMiBAQCBjaWZzX3JlYWR2X3JlY2VpdmUoc3RydWN0IFRDUF9TZXJ2ZXJf
SW5mbyAqc2VydmVyLCBzdHJ1Y3QgbWlkX3FfZW50cnkgKm1pZCkKIAkJcmV0dXJuIGxlbmd0aDsK
IAlzZXJ2ZXItPnRvdGFsX3JlYWQgKz0gbGVuZ3RoOwogCisJaWYgKHNlcnZlci0+b3BzLT5pc19z
dGF0dXNfcGVuZGluZyAmJgorCSAgICBzZXJ2ZXItPm9wcy0+aXNfc3RhdHVzX3BlbmRpbmcoYnVm
LCBzZXJ2ZXIsIDApKSB7CisJCWRpc2NhcmRfcmVtYWluaW5nX2RhdGEoc2VydmVyKTsKKwkJcmV0
dXJuIC0xOworCX0KKwogCS8qIFdhcyB0aGUgU01CIHJlYWQgc3VjY2Vzc2Z1bD8gKi8KIAlyZGF0
YS0+cmVzdWx0ID0gc2VydmVyLT5vcHMtPm1hcF9lcnJvcihidWYsIGZhbHNlKTsKIAlpZiAocmRh
dGEtPnJlc3VsdCAhPSAwKSB7Ci0tIAoyLjEuNAoK
--001a11380a16f2d4f7052cbd0249--
