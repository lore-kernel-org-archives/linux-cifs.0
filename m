From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: fix warning message on cifs-utils build - alternate package name
 for krb5.h
Date: Mon, 9 Sep 2013 12:03:12 -0500
Message-ID: <CAH2r5murcaTu3pKC2_-sJ8vLRQXDxbOWD9ZCBNTyGW4qaqDuzA@mail.gmail.com>
References: <CAH2r5mtfa65ok=pCxT-y=xbdBMApsu5VExh33Bz_Ukkx5iD-Rg@mail.gmail.com>
	<20130909130047.4378559f@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b2e1211115c0504e5f65d6d
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130909130047.4378559f-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--047d7b2e1211115c0504e5f65d6d
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Sep 9, 2013 at 12:00 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Mon, 9 Sep 2013 09:59:38 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> commit 5c69761267eb54ce0d94f3a30c3ad015efd3a806
>> Author: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Date:   Mon Sep 9 09:55:46 2013 -0500
>>
>>     [CIFS-UTILS] Add another suggested package name for krb5 headers
>>
>>     Added an alternate package name for krb5 headers.
>>
>>     Noticed the following suggestion asks for the wrong package (at least
>>     wrong for FC17)
>>
>>     checking krb5.h presence... no
>>     checking for krb5.h... no
>>     checking krb5/krb5.h usability... no
>>     checking krb5/krb5.h presence... no
>>     checking for krb5/krb5.h... no
>>     configure: WARNING: krb5.h not found, consider installing
>>     krb5-libs-devel. Disabling cifs.upcall.
>>
>>     [sfrench@w500smf cifs-utils]$ sudo yum install krb5-libs-devel
>>     Loaded plugins: langpacks, presto, refresh-packagekit
>>     No package krb5-libs-devel available.
>>     Error: Nothing to do
>>     [sfrench@w500smf cifs-utils]$ sudo yum install krb5-devel
>>
>>     (installing krb5-devel worked, but not krb5-libs-devel for this version)
>>
>>     Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> diff --git a/configure.ac b/configure.ac
>> index b5f7c49..c69ede4 100644
>> --- a/configure.ac
>> +++ b/configure.ac
>> @@ -135,9 +135,9 @@ if test $enable_cifsupcall != "no"; then
>>   if test x$ac_cv_header_krb5_krb5_h != xyes ; then
>>   if test x$ac_cv_header_krb5_h != xyes ; then
>>   if test "$enable_cifsupcall" = "yes"; then
>> - AC_MSG_ERROR([krb5.h not found, consider installing krb5-libs-devel.])
>> + AC_MSG_ERROR([krb5.h not found, consider installing krb5-devel or
>> krb5-libs-devel.])
>>   else
>> - AC_MSG_WARN([krb5.h not found, consider installing krb5-libs-devel.
>> Disabling cifs.upcall.])
>> + AC_MSG_WARN([krb5.h not found, consider installing krb5-devel or
>> krb5-libs-devel. Disabling cifs.upcall.])
>>   enable_cifsupcall="no"
>>   fi
>>   fi
>>
>
> Looks like your mailer is mangling your patches:
>
> patch -p1 < fix\ warning\ message\ on\ cifs-utils\ build\ -\ alternate\ package\ name\ for\ krb5.h
> patching file configure.ac
> patch: **** malformed patch at line 89: krb5-libs-devel.])
>
> I'm guessing you pasted the patch into your mail client? That generally
> doesn't work well. You may want to resend using git-send-email.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>



-- 
Thanks,

Steve

--047d7b2e1211115c0504e5f65d6d
Content-Type: application/octet-stream;
	name="0001-CIFS-UTILS-Add-another-suggested-package-name-for-kr.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-UTILS-Add-another-suggested-package-name-for-kr.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hldxvqz40

RnJvbSA1YzY5NzYxMjY3ZWI1NGNlMGQ5NGYzYTMwYzNhZDAxNWVmZDNhODA2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogTW9uLCA5IFNlcCAyMDEzIDA5OjU1OjQ2IC0wNTAwClN1YmplY3Q6IFtQQVRDSF0gW0NJRlMt
VVRJTFNdIEFkZCBhbm90aGVyIHN1Z2dlc3RlZCBwYWNrYWdlIG5hbWUgZm9yIGtyYjUKIGhlYWRl
cnMKCkFkZGVkIGFuIGFsdGVybmF0ZSBwYWNrYWdlIG5hbWUgZm9yIGtyYjUgaGVhZGVycy4KCk5v
dGljZWQgdGhlIGZvbGxvd2luZyBzdWdnZXN0aW9uIGFza3MgZm9yIHRoZSB3cm9uZyBwYWNrYWdl
IChhdCBsZWFzdAp3cm9uZyBmb3IgRkMxNykKCmNoZWNraW5nIGtyYjUuaCBwcmVzZW5jZS4uLiBu
bwpjaGVja2luZyBmb3Iga3JiNS5oLi4uIG5vCmNoZWNraW5nIGtyYjUva3JiNS5oIHVzYWJpbGl0
eS4uLiBubwpjaGVja2luZyBrcmI1L2tyYjUuaCBwcmVzZW5jZS4uLiBubwpjaGVja2luZyBmb3Ig
a3JiNS9rcmI1LmguLi4gbm8KY29uZmlndXJlOiBXQVJOSU5HOiBrcmI1Lmggbm90IGZvdW5kLCBj
b25zaWRlciBpbnN0YWxsaW5nCmtyYjUtbGlicy1kZXZlbC4gRGlzYWJsaW5nIGNpZnMudXBjYWxs
LgoKW3NmcmVuY2hAdzUwMHNtZiBjaWZzLXV0aWxzXSQgc3VkbyB5dW0gaW5zdGFsbCBrcmI1LWxp
YnMtZGV2ZWwKTG9hZGVkIHBsdWdpbnM6IGxhbmdwYWNrcywgcHJlc3RvLCByZWZyZXNoLXBhY2th
Z2VraXQKTm8gcGFja2FnZSBrcmI1LWxpYnMtZGV2ZWwgYXZhaWxhYmxlLgpFcnJvcjogTm90aGlu
ZyB0byBkbwpbc2ZyZW5jaEB3NTAwc21mIGNpZnMtdXRpbHNdJCBzdWRvIHl1bSBpbnN0YWxsIGty
YjUtZGV2ZWwKCihpbnN0YWxsaW5nIGtyYjUtZGV2ZWwgd29ya2VkLCBidXQgbm90IGtyYjUtbGli
cy1kZXZlbCBmb3IgdGhpcyB2ZXJzaW9uKQoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxz
bWZyZW5jaEBnbWFpbC5jb20+Ci0tLQogY29uZmlndXJlLmFjIHwgNCArKy0tCiAxIGZpbGUgY2hh
bmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2NvbmZp
Z3VyZS5hYyBiL2NvbmZpZ3VyZS5hYwppbmRleCBiNWY3YzQ5Li5jNjllZGU0IDEwMDY0NAotLS0g
YS9jb25maWd1cmUuYWMKKysrIGIvY29uZmlndXJlLmFjCkBAIC0xMzUsOSArMTM1LDkgQEAgaWYg
dGVzdCAkZW5hYmxlX2NpZnN1cGNhbGwgIT0gIm5vIjsgdGhlbgogCWlmIHRlc3QgeCRhY19jdl9o
ZWFkZXJfa3JiNV9rcmI1X2ggIT0geHllcyA7IHRoZW4KIAkJaWYgdGVzdCB4JGFjX2N2X2hlYWRl
cl9rcmI1X2ggIT0geHllcyA7IHRoZW4KIAkJCWlmIHRlc3QgIiRlbmFibGVfY2lmc3VwY2FsbCIg
PSAieWVzIjsgdGhlbgotCQkJCUFDX01TR19FUlJPUihba3JiNS5oIG5vdCBmb3VuZCwgY29uc2lk
ZXIgaW5zdGFsbGluZyBrcmI1LWxpYnMtZGV2ZWwuXSkKKwkJCQlBQ19NU0dfRVJST1IoW2tyYjUu
aCBub3QgZm91bmQsIGNvbnNpZGVyIGluc3RhbGxpbmcga3JiNS1kZXZlbCBvciBrcmI1LWxpYnMt
ZGV2ZWwuXSkKIAkJCWVsc2UKLQkJCQlBQ19NU0dfV0FSTihba3JiNS5oIG5vdCBmb3VuZCwgY29u
c2lkZXIgaW5zdGFsbGluZyBrcmI1LWxpYnMtZGV2ZWwuIERpc2FibGluZyBjaWZzLnVwY2FsbC5d
KQorCQkJCUFDX01TR19XQVJOKFtrcmI1Lmggbm90IGZvdW5kLCBjb25zaWRlciBpbnN0YWxsaW5n
IGtyYjUtZGV2ZWwgb3Iga3JiNS1saWJzLWRldmVsLiBEaXNhYmxpbmcgY2lmcy51cGNhbGwuXSkK
IAkJCQllbmFibGVfY2lmc3VwY2FsbD0ibm8iCiAJCQlmaQogCQlmaQotLSAKMS43LjExLjcKCg==
--047d7b2e1211115c0504e5f65d6d--
