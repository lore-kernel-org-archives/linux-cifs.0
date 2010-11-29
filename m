From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/6] Add strict cache mode (try #4)
Date: Mon, 29 Nov 2010 15:22:44 +0300
Message-ID: <AANLkTikKVrV2046nmZWFH4puHPmD66cmGOm0d5aYAX4T@mail.gmail.com>
References: <1290931972-2770-1-git-send-email-piastryyy@gmail.com>
	<4CF3864E.50901@suse.de>
	<AANLkTinLbS7V=Ok_Eje=mnrBOkZEJJo9iQ9SYwHsbsag@mail.gmail.com>
	<4CF3995C.4080709@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016364c7556112ec504963021d3
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CF3995C.4080709-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--0016364c7556112ec504963021d3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

2010/11/29 Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>:
> On 11/29/2010 04:30 PM, Pavel Shilovsky wrote:
>> 2010/11/29 Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>:
>>> On 11/28/2010 01:42 PM, Pavel Shilovsky wrote:
>>>> Re-posting the whole set of strict cache patches.
>>>
>>> I try to explain here the "strict cache" semantics as I'm not sure
>>> whether I understand it clearly. Please correct me if I'm wrong.
>>>
>>> Strict cache semantics
>>>
>>> =EF=BF=BDo provides stricter cache coherency among cifs clients that ac=
cess
>>> =EF=BF=BD =EF=BF=BDthe same files.
>>> =EF=BF=BDo The clients will read data from the Server always, except wh=
en they
>>> =EF=BF=BD =EF=BF=BDhold read oplock or Level II oplock on the file.
>>> =EF=BF=BDo The clients will write data to the Server always, except whe=
n they
>>> =EF=BF=BD =EF=BF=BDhold exclusive oplock on the file.
>>> =EF=BF=BDo When we close the last filehandle of the inode, file should =
be
>>> =EF=BF=BD =EF=BF=BDmarked for revalidation as it is possible for the cl=
ient to access
>>> =EF=BF=BD =EF=BF=BDstale data from the cache when we open it again with=
 a read
>>> =EF=BF=BD =EF=BF=BDoplock.
>>> =EF=BF=BDo On fsync/mmap, invalidate inode if read oplock has not been =
set.
>>>
>>>
>>> Is this the semantics being proposed? Did I miss anything?
>>
>> Yes, you are right - it is exactly what I mean.
>>
>
> Also, would be good to know what level of testing these patches have
> undergone. Could you share the test results as well?
>

I don't run big stress tests over it but I have tree small tests that
shows the problem this mode is going to fix.

--=20
Best regards,
Pavel Shilovsky.

--0016364c7556112ec504963021d3
Content-Type: text/x-python; charset=US-ASCII; name="close_problem.py"
Content-Disposition: attachment; filename="close_problem.py"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gh3bwtfg0

IyEvYmluL2VudiBweXRob24KIwojIFdlIGhhdmUgdG8gbW91bnQgdGhlIHNhbWUgc2hhcmUgdG8g
dGVzdCwgdGVzdDEsIHRlc3QyIGRpcmVjdG9yaWVzIHRoYXQgbG9jYXRlIGluIHRoZSBkaXJlY3Rv
cnkgd2UKIyBleGVjdXRlIHRoaXMgc2NyaXB0IGZyb20uCgpmcm9tIG9zIGltcG9ydCBvcGVuLCBj
bG9zZSwgT19SRFdSLCBPX0NSRUFULCB3cml0ZSwgcmVhZCwgT19SRE9OTFksIE9fV1JPTkxZLCBP
X1RSVU5DLCBsc2VlaywgU0VFS19FTkQsIFNFRUtfU0VUCgpmID0gb3BlbigndGVzdC9fdGVzdDQz
MjFfJywgT19SRFdSIHwgT19DUkVBVCB8IE9fVFJVTkMpCmNsb3NlKGYpCgpmMSA9IG9wZW4oJ3Rl
c3QxL190ZXN0NDMyMV8nLCBPX1JEV1IpCndyaXRlKGYxLCAnYScpCmNsb3NlKGYxKQoKZjIgPSBv
cGVuKCd0ZXN0Mi9fdGVzdDQzMjFfJywgT19XUk9OTFkpCndyaXRlKGYyLCAneCcpCmNsb3NlKGYy
KQoKZjMgPSBvcGVuKCd0ZXN0MS9fdGVzdDQzMjFfJywgT19SRE9OTFkpCnByaW50ICdtdXN0IGJl
IHg6JywgcmVhZChmMywgMSkKCmNsb3NlKGYzKQo=
--0016364c7556112ec504963021d3
Content-Type: text/x-python; charset=US-ASCII; name="mtime_problem.py"
Content-Disposition: attachment; filename="mtime_problem.py"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gh3bxoj81

IyEvYmluL2VudiBweXRob24KIwojIFdlIGhhdmUgdG8gbW91bnQgdGhlIHNhbWUgc2hhcmUgdG8g
dGVzdCwgdGVzdDEsIHRlc3QyIGRpcmVjdG9yaWVzIHRoYXQgbG9jYXRlIGluIHRoZSBkaXJlY3Rv
cnkgd2UKIyBleGVjdXRlIHRoaXMgc2NyaXB0IGZyb20uCgpmcm9tIG9zIGltcG9ydCBvcGVuLCBj
bG9zZSwgT19SRFdSLCBPX0NSRUFULCB3cml0ZSwgcmVhZCwgT19SRE9OTFksIE9fV1JPTkxZLCBP
X1RSVU5DLCBsc2VlaywgU0VFS19FTkQsIFNFRUtfU0VUCgpmID0gb3BlbigndGVzdC9fdGVzdDQz
MjFfJywgT19SRFdSIHwgT19DUkVBVCB8IE9fVFJVTkMpCmNsb3NlKGYpCgpmMSA9IG9wZW4oJ3Rl
c3QxL190ZXN0NDMyMV8nLCBPX1JEV1IpCndyaXRlKGYxLCAnYScpCgpmMiA9IG9wZW4oJ3Rlc3Qy
L190ZXN0NDMyMV8nLCBPX1dST05MWSkKd3JpdGUoZjIsICd4JykKCmYzID0gb3BlbigndGVzdDEv
X3Rlc3Q0MzIxXycsIE9fUkRPTkxZKQpwcmludCAnbXVzdCBiZSB4OicsIHJlYWQoZjMsIDEpCgpj
bG9zZShmMSkKY2xvc2UoZjIpCmNsb3NlKGYzKQo=
--0016364c7556112ec504963021d3
Content-Type: text/x-python; charset=US-ASCII; name="cache_problem.py"
Content-Disposition: attachment; filename="cache_problem.py"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gh3bxtv12

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
--0016364c7556112ec504963021d3--
