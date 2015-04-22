From: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Subject: Re: [PATCH] cifs: When "refer file directly", make new inode cache
 if "uniqueid is different"
Date: Wed, 22 Apr 2015 15:31:51 +0900
Message-ID: <55374057.6010908@nttcom.co.jp>
References: <549A249A.3080000@nttcom.co.jp>	<20150407064551.36374c43@tlielax.poochiereds.net>	<CAH2r5ms5wn1ii563gK=+=koeQEmy5gY=xTP+Y8_GGjyPJwznzQ@mail.gmail.com>	<5526335C.3030701@nttcom.co.jp>	<20150410091647.39fb6515@synchrony.poochiereds.net>	<CADT32eK6Zb7arYFyCPc+yt509P3pgg65bModxgNLyN1vb-a2-w@mail.gmail.com> <20150413164235.2f4bd67b@synchrony.poochiereds.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------020309040604010702020300"
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150413164235.2f4bd67b-08S845evdOaAjSkqwZiSMmfYqLom42DlXqFh9Ls21Oc@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--------------020309040604010702020300
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On 2015/04/14 5:42, Jeff Layton wrote:
> On Sun, 12 Apr 2015 23:24:59 -0500
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
>> I am not sure if ESTALE or ENOENT would have an effect on a dcache entry.
>> A dcache entry and dentry are two different things, as I understand.
> 
> Oh, in this case I was specifically referring to the kernel's cache of
> dentries as the dcache.
> 
>> In this case, dcache entry has not changed, what has changed is the dentry,
>> specifically the inode it points to, so there is really no reason to purge
>> and reinstate a dcache entry.
>>
> 
> No, the dentry has changed. We did an operation against the server and
> found that the underlying inode type is different.
> 
> In practical terms, the Linux dcache should handle that by dropping the
> old dentry and instantiating a new one. So, I think that returning
> ESTALE is a better error there since it should trigger the upper VFS
> layers to do just that.
> 
>> On Fri, Apr 10, 2015 at 8:16 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>>> On Thu, 9 Apr 2015 17:07:56 +0900
>>> Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org> wrote:
>>>
>>>> On 2015/04/07 23:39, Steve French wrote:
>>>>> On Tue, Apr 7, 2015 at 5:45 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>>>>>> On Wed, 24 Dec 2014 11:27:38 +0900
>>>>>> Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org> wrote:
>>>>>>
>>>>>>> When refer file "directly" (e.g. ls -li <filename>),
>>>>>>>  if file is same name, old inode cache is used.
>>>>>>> This causes that client shows wrong(old) inode number.
>>>>>>> So this patch is that if uniqueid is different, return error.
>>>>>>>
>>>>>>> ## But this patch is applicable to when Server is UNIX.
>>>>>>> ## When Server is Windows, we need another new patch.
>>>>>>>
>>>>>>>
>>>>>>> Reproducible sample :
>>>>>>> 1. create file 'a' at cifs client.
>>>>>>> 2. rm 'a' and touch 'b a' at server.
>>>>>>> 3. ls -li 'a' at client, then client shows wrong(old) inode number.
>>>>>>>
>>>>>>> Bug link:
>>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=90021
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Signed-off-by: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
>>>>>>> diff -uprN -X linux-3.18-vanilla/Documentation/dontdiff linux-3.18-vanilla/fs/cifs/inode.c linux-3.18/fs/cifs/inode.c
>>>>>>> --- linux-3.18-vanilla/fs/cifs/inode.c        2014-12-08 07:21:05.000000000 +0900
>>>>>>> +++ linux-3.18/fs/cifs/inode.c        2014-12-19 11:07:59.127000000 +0900
>>>>>>> @@ -402,9 +402,18 @@ int cifs_get_inode_info_unix(struct inod
>>>>>>>                       rc = -ENOMEM;
>>>>>>>       } else {
>>>>>>>               /* we already have inode, update it */
>>>>>>> +
>>>>>>> +             /* if uniqueid is different, return error */
>>>>>>> +             if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
>>>>>>> +                 CIFS_I(*pinode)->uniqueid != fattr.cf_uniqueid)) {
>>>>>>> +                     rc = -ENOENT;
>>>>>>> +                     goto cgiiu_exit;
>>>>>>> +             }
>>>>>>> +
>>>>>>>               cifs_fattr_to_inode(*pinode, &fattr);
>>>>>>>       }
>>>>>>>
>>>>>>> +cgiiu_exit:
>>>>>>>       return rc;
>>>>>>>  }
>>>>>>>
>>>>>>
>>>>>> Returning ENOENT here seems like the wrong error to me. That path does
>>>>>> exist, it just no longer refers to the same file as before.
>>>>>>
>>>>>> Maybe ESTALE would be better as it would allow the VFS layer
>>>>>> to revalidate the dcache and invalidate the old dentry?
>>>>>>
>>>>>> --
>>>>>> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>>>>>
>>>>> Similar to what Jeff mentioned, isn't the nfs_relavidate_inode path
>>>>> roughly equivalent to what we want here (where nfs.ko returns ESTALE
>>>>> on various cases where we detect an inode that doesn't match what we
>>>>> expect)?
>>>>
>>>> If uniqueid is different, return -ESTALE.
>>>> If filetype is different, return -ENOENT.
>>>> That's right?
>>>>
>>>> +             /* if filetype is different, return error */
>>>> +             if (unlikely(((*pinode)->i_mode & S_IFMT) !=
>>>> +                 (fattr.cf_mode & S_IFMT))) {
>>>> +                     rc = -ENOENT;
>>>> +                     goto cgiiu_exit;
>>>> +             }
>>>>
>>>
>>> No, I don't think so. In both cases, the dcache is wrong and the dentry
>>> should be dropped and reinstantiated to point to a new inode. An ESTALE
>>> return is the trigger for that to occur. An ENOENT return is going to
>>> mean a stat() failure in your testcase, I think.
>>>
>>> So I think you want to return ESTALE in both cases. That said, please
>>> do test it and ensure that it does the right thing.
>>>
>>> --
>>> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>


I fixed to return -ESTALE in cifs_get_inode_info_unix().

This case (ls <filename>, cat <filename>) passes through following paths.
ls <filename>
-> lookup_fast
-> .d_revalidate
-> cifs_d_revalidate          (even though EATALE or ENOENT, return 0)
-> cifs_revalidate_dentry
-> cifs_revalidate_dentry_attr
-> cifs_get_inode_info_unix   (return ESTALE)

In either ESTALE or ENOENT, cifs_d_revalidate() returns 0.


I didn't find out
 what commands path through
 other passes not including cifs_d_revalidate().
   (cifs_do_create, cifs_mknod, cifs_lookup, cifs_symlink, etc..) 
But I checked that this patch works properly by various commands/patterns.




>From 0ff83baa2069c86aa35a8081cdb6e4f4380e66a1 Mon Sep 17 00:00:00 2001
From: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Date: Wed, 22 Apr 2015 15:24:44 +0900
Subject: [PATCH] Fix to check Unique id and FileType when client refer file directly.

When you refer file directly on cifs client,
 (e.g. ls -li <filename>, cd <dir>, stat <filename>)
 the function return old inode number and filetype from old inode cache,
 though server has different inode number or filetype.

When server is Windows, cifs client has same problem.
When Server is Windows
, This patch fixes bug in different filetype, 
  but does not fix bug in different inode number.
Because QUERY_PATH_INFO response by Windows does not include inode number(Index Number) .

BUG INFO
https://bugzilla.kernel.org/show_bug.cgi?id=90021
https://bugzilla.kernel.org/show_bug.cgi?id=90031

Reported-by: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Signed-off-by: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---
 fs/cifs/inode.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 3e126d7..0d42354 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -402,9 +402,25 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 			rc = -ENOMEM;
 	} else {
 		/* we already have inode, update it */
+
+		/* if uniqueid is different, return error */
+		if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
+		    CIFS_I(*pinode)->uniqueid != fattr.cf_uniqueid)) {
+			rc = -ESTALE;
+			goto cgiiu_exit;
+		}
+
+		/* if filetype is different, return error */
+		if (unlikely(((*pinode)->i_mode & S_IFMT) !=
+		    (fattr.cf_mode & S_IFMT))) {
+			rc = -ESTALE;
+			goto cgiiu_exit;
+		}
+
 		cifs_fattr_to_inode(*pinode, &fattr);
 	}
 
+cgiiu_exit:
 	return rc;
 }
 
@@ -839,6 +855,15 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 		if (!*inode)
 			rc = -ENOMEM;
 	} else {
+		/* we already have inode, update it */
+
+		/* if filetype is different, return error */
+		if (unlikely(((*inode)->i_mode & S_IFMT) !=
+		    (fattr.cf_mode & S_IFMT))) {
+			rc = -ESTALE;
+			goto cgii_exit;
+		}
+
 		cifs_fattr_to_inode(*inode, &fattr);
 	}
 
-- 
1.7.1


--------------020309040604010702020300
Content-Type: text/plain; charset="Shift_JIS";
	name="0001-Fix-to-check-Unique-id-and-FileType-when-client-refe.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename*0="0001-Fix-to-check-Unique-id-and-FileType-when-client-refe.pa";
	filename*1="tch"

RnJvbSAwZmY4M2JhYTIwNjljODZhYTM1YTgwODFjZGI2ZTRmNDM4MGU2NmExIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBOYWthamltYSBBa2lyYSA8bmFrYWppbWEuYWtpcmFA
bnR0Y29tLmNvLmpwPgpEYXRlOiBXZWQsIDIyIEFwciAyMDE1IDE1OjI0OjQ0ICswOTAwClN1
YmplY3Q6IFtQQVRDSF0gRml4IHRvIGNoZWNrIFVuaXF1ZSBpZCBhbmQgRmlsZVR5cGUgd2hl
biBjbGllbnQgcmVmZXIgZmlsZSBkaXJlY3RseS4KCldoZW4geW91IHJlZmVyIGZpbGUgZGly
ZWN0bHkgb24gY2lmcyBjbGllbnQsCiAoZS5nLiBscyAtbGkgPGZpbGVuYW1lPiwgY2QgPGRp
cj4sIHN0YXQgPGZpbGVuYW1lPikKIHRoZSBmdW5jdGlvbiByZXR1cm4gb2xkIGlub2RlIG51
bWJlciBhbmQgZmlsZXR5cGUgZnJvbSBvbGQgaW5vZGUgY2FjaGUsCiB0aG91Z2ggc2VydmVy
IGhhcyBkaWZmZXJlbnQgaW5vZGUgbnVtYmVyIG9yIGZpbGV0eXBlLgoKV2hlbiBzZXJ2ZXIg
aXMgV2luZG93cywgY2lmcyBjbGllbnQgaGFzIHNhbWUgcHJvYmxlbS4KV2hlbiBTZXJ2ZXIg
aXMgV2luZG93cwosIFRoaXMgcGF0Y2ggZml4ZXMgYnVnIGluIGRpZmZlcmVudCBmaWxldHlw
ZSwgCiAgYnV0IGRvZXMgbm90IGZpeCBidWcgaW4gZGlmZmVyZW50IGlub2RlIG51bWJlci4K
QmVjYXVzZSBRVUVSWV9QQVRIX0lORk8gcmVzcG9uc2UgYnkgV2luZG93cyBkb2VzIG5vdCBp
bmNsdWRlIGlub2RlIG51bWJlcihJbmRleCBOdW1iZXIpIC4KCkJVRyBJTkZPCmh0dHBzOi8v
YnVnemlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9OTAwMjEKaHR0cHM6Ly9idWd6
aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD05MDAzMQoKUmVwb3J0ZWQtYnk6IE5h
a2FqaW1hIEFraXJhIDxuYWthamltYS5ha2lyYUBudHRjb20uY28uanA+ClNpZ25lZC1vZmYt
Ynk6IE5ha2FqaW1hIEFraXJhIDxuYWthamltYS5ha2lyYUBudHRjb20uY28uanA+ClJldmll
d2VkLWJ5OiBTaGlyaXNoIFBhcmdhb25rYXIgPHNoaXJpc2hwYXJnYW9ua2FyQGdtYWlsLmNv
bT4KCi0tLQogZnMvY2lmcy9pbm9kZS5jIHwgICAyNSArKysrKysrKysrKysrKysrKysrKysr
KysrCiAxIGZpbGVzIGNoYW5nZWQsIDI1IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9pbm9kZS5jIGIvZnMvY2lmcy9pbm9kZS5jCmluZGV4
IDNlMTI2ZDcuLjBkNDIzNTQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvaW5vZGUuYworKysgYi9m
cy9jaWZzL2lub2RlLmMKQEAgLTQwMiw5ICs0MDIsMjUgQEAgaW50IGNpZnNfZ2V0X2lub2Rl
X2luZm9fdW5peChzdHJ1Y3QgaW5vZGUgKipwaW5vZGUsCiAJCQlyYyA9IC1FTk9NRU07CiAJ
fSBlbHNlIHsKIAkJLyogd2UgYWxyZWFkeSBoYXZlIGlub2RlLCB1cGRhdGUgaXQgKi8KKwor
CQkvKiBpZiB1bmlxdWVpZCBpcyBkaWZmZXJlbnQsIHJldHVybiBlcnJvciAqLworCQlpZiAo
dW5saWtlbHkoY2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgJiBDSUZTX01PVU5UX1NFUlZFUl9J
TlVNICYmCisJCSAgICBDSUZTX0koKnBpbm9kZSktPnVuaXF1ZWlkICE9IGZhdHRyLmNmX3Vu
aXF1ZWlkKSkgeworCQkJcmMgPSAtRVNUQUxFOworCQkJZ290byBjZ2lpdV9leGl0OworCQl9
CisKKwkJLyogaWYgZmlsZXR5cGUgaXMgZGlmZmVyZW50LCByZXR1cm4gZXJyb3IgKi8KKwkJ
aWYgKHVubGlrZWx5KCgoKnBpbm9kZSktPmlfbW9kZSAmIFNfSUZNVCkgIT0KKwkJICAgIChm
YXR0ci5jZl9tb2RlICYgU19JRk1UKSkpIHsKKwkJCXJjID0gLUVTVEFMRTsKKwkJCWdvdG8g
Y2dpaXVfZXhpdDsKKwkJfQorCiAJCWNpZnNfZmF0dHJfdG9faW5vZGUoKnBpbm9kZSwgJmZh
dHRyKTsKIAl9CiAKK2NnaWl1X2V4aXQ6CiAJcmV0dXJuIHJjOwogfQogCkBAIC04MzksNiAr
ODU1LDE1IEBAIGNpZnNfZ2V0X2lub2RlX2luZm8oc3RydWN0IGlub2RlICoqaW5vZGUsIGNv
bnN0IGNoYXIgKmZ1bGxfcGF0aCwKIAkJaWYgKCEqaW5vZGUpCiAJCQlyYyA9IC1FTk9NRU07
CiAJfSBlbHNlIHsKKwkJLyogd2UgYWxyZWFkeSBoYXZlIGlub2RlLCB1cGRhdGUgaXQgKi8K
KworCQkvKiBpZiBmaWxldHlwZSBpcyBkaWZmZXJlbnQsIHJldHVybiBlcnJvciAqLworCQlp
ZiAodW5saWtlbHkoKCgqaW5vZGUpLT5pX21vZGUgJiBTX0lGTVQpICE9CisJCSAgICAoZmF0
dHIuY2ZfbW9kZSAmIFNfSUZNVCkpKSB7CisJCQlyYyA9IC1FU1RBTEU7CisJCQlnb3RvIGNn
aWlfZXhpdDsKKwkJfQorCiAJCWNpZnNfZmF0dHJfdG9faW5vZGUoKmlub2RlLCAmZmF0dHIp
OwogCX0KIAotLSAKMS43LjEKCg==
--------------020309040604010702020300--
