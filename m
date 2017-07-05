From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs-utils: setcifsacl receives STATUS_INVALID_SECURITY_DESCR
 reply from custom CIFS implementation
Date: Wed, 5 Jul 2017 00:08:42 -0500
Message-ID: <CADT32eKtWMF+8+jf=UWh8hsuNGA6GoTqP-+s0H8E3U=6uhX61A@mail.gmail.com>
References: <CAFoiuNiOdjSRwFWmEqSU2WWotUOL_ywrOpj8oSk8UWBC=_cujw@mail.gmail.com>
 <CADT32eKnksmhQNpuQfo91ybQKAiUgdpa3SG5GxSyxGCnTXeH6w@mail.gmail.com>
 <CAFoiuNjj6s8179EMh_f-a2zCjTatGLZtrM5H6Bk7D=mGndNgDg@mail.gmail.com> <CADT32e+jR+5h=K1ujnScnGoHuDMgqinOSpKUdigQafaY8-MBWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="94eb2c19ce2e78a76c05538afeba"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Paul van Schayck <polleke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32e+jR+5h=K1ujnScnGoHuDMgqinOSpKUdigQafaY8-MBWw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--94eb2c19ce2e78a76c05538afeba
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Can you try this patch, I did preliminary testing...



On Tue, Jul 4, 2017 at 4:17 PM, Shirish Pargaonkar
<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Paul,
>
> So something like this works with smb 2.1 with the patchset I posted
> on the mailing list
> to make set acl work over smb 2 onwards...
>
> $ sudo ls -l /mnt/
> total 1
> -rwx------ 1 root root 32 Jan 26  2015 file1.txt
> -rwx------ 1 root root  0 Nov 30  2014 file2.txt
> drwx------ 2 root root  0 Nov 30  2014 folder1
> drwx------ 2 root root  0 Dec 22  2014 folder2
>
> $ sudo setcifsacl -S
> "ACL:S-1-5-21-609720889-20222076-3464071719-1001:ALLOWED/0x0/FULL,ACL:S-1=
-5-21-609720889-20222076-3464071719-513:ALLOWED/0x0/0x1f01b9,ACL:\Everyone:=
ALLOWED/0x0/0x1f01b9"
> /mnt/file1.txt
>
> $ sudo ls -l /mnt/
> total 1
> -rwxr-xr-x 1 root root 32 Jan 26  2015 file1.txt
> -rwx------ 1 root root  0 Nov 30  2014 file2.txt
> drwx------ 2 root root  0 Nov 30  2014 folder1
> drwx------ 2 root root  0 Dec 22  2014 folder2
>
> I then changed it back to 700 using smb1 set cifs acl and it worked too.
>
> $ sudo setcifsacl -S
> "ACL:S-1-5-21-609720889-20222076-3464071719-1001:ALLOWED/0x0/FULL,ACL:S-1=
-5-21-609720889-20222076-3464071719-513:ALLOWED/0x0/0x120088,ACL:\Everyone:=
ALLOWED/0x0/0x120088"
> /mnt/file1.txt
>
> $ sudo ls -l /mnt/
> total 1
> -rwx------ 1 root root 32 Jan 26  2015 file1.txt
> -rwx------ 1 root root  0 Nov 30  2014 file2.txt
> drwx------ 2 root root  0 Nov 30  2014 folder1
> drwx------ 2 root root  0 Dec 22  2014 folder2
>
> What type of Windows server is this?  These requests succeed but I do
> see extra bytes
> at the end of the security descriptor in both the requests, trying to
> figure out why is it allocated in the first place...
>
>
> On Tue, Jun 27, 2017 at 5:43 AM, Paul van Schayck <polleke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
>> Hi Shirish,
>>
>> Thank you for your answer.
>>
>> Attached you can find three pcap files.
>>
>> 1. linux-fail.pcap: Using the setcifsacl 6.7 version.
>> 2. linux-succes.pcap: Using the modified setcifsacl with the patch
>> above (note, I had to change to len + 4 in trim_request())
>> 3. windows-succes-trimmed.pcap: Using the dialog in Windows. Note that
>> this is over smbv2. The file was trimmed down, because windows was
>> noisy.
>>
>> The command I used was
>>
>> setcifsacl -S "ACL:S-1-5-21-1572361299-1184395705-1606240830-247332:ALLO=
WED/OI|CI/CHANGE,ACL:S-1-5-21-1572361299-1184395705-1606240830-544559:ALLOW=
ED/I/FULL,ACL:S-1-3-0:ALLOWED/OI|CI|IO|I/FULL,ACL:S-1-5-21-1572361299-11843=
95705-1606240830-512:ALLOWED/OI|CI|I/FULL,ACL:S-1-5-21-1572361299-118439570=
5-1606240830-549266:ALLOWED/OI|CI|I/FULL,ACL:S-1-5-21-1572361299-1184395705=
-1606240830-544559:ALLOWED/OI|CI|IO|I/FULL,ACL:S-1-5-18:ALLOWED/OI|CI|I/FUL=
L"
>> cifs-test/
>>
>> In Windows I used the dialog to set the same ACEs. Between the
>> linux-success and linux-fail file you can see the difference in the
>> number of zero bytes after the DACL.
>>
>> If this test case is still a bit noisy for you, I can try to build a
>> more simple ACE list. But I have to setup a new share for this.
>>
>> Thanks,
>>
>> Paul van Schayck
>>
>> On Tue, Jun 27, 2017 at 6:40 AM, Shirish Pargaonkar
>> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> if you can provide tcpdumpas well as the command you are using of/for
>>> both Windows and Linux way, that would be helpful
>>>
>>> On Mon, Jun 26, 2017 at 8:04 AM, Paul van Schayck via samba-technical
>>> <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org> wrote:
>>>> Dear samba-technical,
>>>>
>>>> If this list is inappropriate for this question then please redirect
>>>> me to a better one.
>>>>
>>>> I'm working with a HDS HNAS (Hitachi NAS) which has its own
>>>> implementation of the CIFS protocol. Mounting, and interactions all go
>>>> fine using linux-cifs and related tools.
>>>>
>>>> However, when sending a `setcifsacl -a ACE /dir` the response is
>>>> "main: setxattr error: Input/output error". Upon further digging using
>>>> tcpdump/wireshark it became clear that the HNAS is responding with
>>>>
>>>> NT Status: STATUS_INVALID_SECURITY_DESCR (0xc0000079)
>>>>
>>>> Setting the same ACE using a Windows client did work. So further
>>>> examining of the request being sent showed that the only difference
>>>> between the Windows client and setcifsacl was the addition of a lot of
>>>> padding zero bytes at the end of the security descriptor.
>>>>
>>>> Examining the code of setcifsacl.c and the request more it seems like
>>>> the request was not properly trimmed down to the number of aces being
>>>> sent. More buffer was allocated that the number of aces being sent. So
>>>> I made the attached patch to trim down the request. This fixes some of
>>>> the problems with setcifsacl, but for example breaks deleting aces. I
>>>> also think it's most likely an ugly fix, and the problem needs to be
>>>> solved elsewhere most likely.
>>>>
>>>> So my question is if someone can point me at the correct way to fix
>>>> this in setcifsacl, or help me fix it properly. If necessary I can
>>>> provide tcpdump's of Windows and Linux clients performing the request.
>>>>
>>>> Thanks,
>>>>
>>>> Paul van Schayck
>>>>
>>>> diff --git a/setcifsacl.c b/setcifsacl.c
>>>> index 7eeeaa6..4ada3c8 100644
>>>> --- a/setcifsacl.c
>>>> +++ b/setcifsacl.c
>>>> @@ -761,6 +761,20 @@ setacl_action(struct cifs_ntsd *pntsd, struct
>>>> cifs_ntsd **npntsd,
>>>>         return rc;
>>>>  }
>>>>
>>>> +ssize_t
>>>> +trim_request(ssize_t bufsize, struct cifs_ntsd *npntsd) {
>>>> +       int i, len =3D 0;
>>>> +       char *a =3D (char *) npntsd;
>>>> +
>>>> +       for( i =3D 0; i < bufsize; i++) {
>>>> +               if ( a[i] !=3D 0 )
>>>> +                       len =3D i;
>>>> +       }
>>>> +
>>>> +       return (ssize_t) len + 2;
>>>> +}
>>>> +
>>>> +
>>>>  static void
>>>>  setcifsacl_usage(const char *prog)
>>>>  {
>>>> @@ -902,7 +916,7 @@ cifsacl:
>>>>         if (rc)
>>>>                 goto setcifsacl_action_ret;
>>>>
>>>> -       attrlen =3D setxattr(filename, ATTRNAME, ntsdptr, bufsize, 0);
>>>> +       attrlen =3D setxattr(filename, ATTRNAME, ntsdptr,
>>>> trim_request(bufsize, ntsdptr), 0);
>>>>         if (attrlen =3D=3D -1) {
>>>>                 printf("%s: setxattr error: %s\n", __func__, strerror(=
errno));
>>>>                 goto setcifsacl_facenum_ret;
>>>>

--94eb2c19ce2e78a76c05538afeba
Content-Type: text/x-patch; charset="US-ASCII"; name="setcifsacl.070417.2.patch"
Content-Disposition: attachment; filename="setcifsacl.070417.2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j4qjlqeq0

ZGlmZiAtLWdpdCBhL3NldGNpZnNhY2wuYyBiL3NldGNpZnNhY2wuYwppbmRleCA3ZWVlYWE2Li4w
ZDRiMTVmIDEwMDY0NAotLS0gYS9zZXRjaWZzYWNsLmMKKysrIGIvc2V0Y2lmc2FjbC5jCkBAIC01
MCwyNCArNTAsMzMgQEAgZW51bSBzZXRjaWZzYWNsX2FjdGlvbnMgewogc3RhdGljIHZvaWQgKnBs
dWdpbl9oYW5kbGU7CiBzdGF0aWMgYm9vbCBwbHVnaW5fbG9hZGVkOwogCi1zdGF0aWMgdm9pZAor
c3RhdGljIGludAogY29weV9jaWZzX3NpZChzdHJ1Y3QgY2lmc19zaWQgKmRzdCwgY29uc3Qgc3Ry
dWN0IGNpZnNfc2lkICpzcmMpCiB7Ci0JaW50IGk7CisJaW50IGksIHNpemUgPSAwOwogCiAJZHN0
LT5yZXZpc2lvbiA9IHNyYy0+cmV2aXNpb247CisJc2l6ZSArPSBzaXplb2YodWludDhfdCk7CisK
IAlkc3QtPm51bV9zdWJhdXRoID0gc3JjLT5udW1fc3ViYXV0aDsKKwlzaXplICs9IHNpemVvZih1
aW50OF90KTsKKwogCWZvciAoaSA9IDA7IGkgPCBOVU1fQVVUSFM7IGkrKykKIAkJZHN0LT5hdXRo
b3JpdHlbaV0gPSBzcmMtPmF1dGhvcml0eVtpXTsKKwlzaXplICs9IChzaXplb2YodWludDhfdCkg
KiBOVU1fQVVUSFMpOworCiAJZm9yIChpID0gMDsgaSA8IHNyYy0+bnVtX3N1YmF1dGg7IGkrKykK
IAkJZHN0LT5zdWJfYXV0aFtpXSA9IHNyYy0+c3ViX2F1dGhbaV07CisJc2l6ZSArPSAoc2l6ZW9m
KHVpbnQzMl90KSAqIHNyYy0+bnVtX3N1YmF1dGgpOworCisJcmV0dXJuIHNpemU7CiB9CiAKIHN0
YXRpYyB2b2lkCiBjb3B5X3NlY19kZXNjKGNvbnN0IHN0cnVjdCBjaWZzX250c2QgKnBudHNkLCBz
dHJ1Y3QgY2lmc19udHNkICpwbm50c2QsCi0JCWludCBudW1hY2VzLCBpbnQgYWNlc3NpemUpCisJ
CWludCBudW1hY2VzLCBpbnQgYWNlc3NpemUsIHNzaXplX3QgKmJ1ZnNpemUpCiB7Ci0JaW50IG9z
aWRzb2Zmc2V0LCBnc2lkc29mZnNldCwgZGFjbG9mZnNldDsKKwlpbnQgc2l6ZSwgb3NpZHNvZmZz
ZXQsIGdzaWRzb2Zmc2V0LCBkYWNsb2Zmc2V0OwogCXN0cnVjdCBjaWZzX3NpZCAqb3duZXJfc2lk
X3B0ciwgKmdyb3VwX3NpZF9wdHI7CiAJc3RydWN0IGNpZnNfc2lkICpub3duZXJfc2lkX3B0ciwg
Km5ncm91cF9zaWRfcHRyOwogCXN0cnVjdCBjaWZzX2N0cmxfYWNsICpkYWNsX3B0ciwgKm5kYWNs
X3B0cjsKQEAgLTc3LDI4ICs4NiwzNCBAQCBjb3B5X3NlY19kZXNjKGNvbnN0IHN0cnVjdCBjaWZz
X250c2QgKnBudHNkLCBzdHJ1Y3QgY2lmc19udHNkICpwbm50c2QsCiAJZ3NpZHNvZmZzZXQgPSBs
ZTMydG9oKHBudHNkLT5nc2lkb2Zmc2V0KTsKIAlkYWNsb2Zmc2V0ID0gbGUzMnRvaChwbnRzZC0+
ZGFjbG9mZnNldCk7CiAKKwlzaXplID0gc2l6ZW9mKHN0cnVjdCBjaWZzX250c2QpOwogCXBubnRz
ZC0+cmV2aXNpb24gPSBwbnRzZC0+cmV2aXNpb247CiAJcG5udHNkLT50eXBlID0gcG50c2QtPnR5
cGU7CiAJcG5udHNkLT5vc2lkb2Zmc2V0ID0gcG50c2QtPm9zaWRvZmZzZXQ7CiAJcG5udHNkLT5n
c2lkb2Zmc2V0ID0gcG50c2QtPmdzaWRvZmZzZXQ7CiAJcG5udHNkLT5kYWNsb2Zmc2V0ID0gcG50
c2QtPmRhY2xvZmZzZXQ7CisJKmJ1ZnNpemUgPSAqYnVmc2l6ZSArIHNpemU7CiAKIAlkYWNsX3B0
ciA9IChzdHJ1Y3QgY2lmc19jdHJsX2FjbCAqKSgoY2hhciAqKXBudHNkICsgZGFjbG9mZnNldCk7
CiAJbmRhY2xfcHRyID0gKHN0cnVjdCBjaWZzX2N0cmxfYWNsICopKChjaGFyICopcG5udHNkICsg
ZGFjbG9mZnNldCk7CiAKKwlzaXplID0gYWNlc3NpemUgKyBzaXplb2Yoc3RydWN0IGNpZnNfY3Ry
bF9hY2wpOwogCW5kYWNsX3B0ci0+cmV2aXNpb24gPSBkYWNsX3B0ci0+cmV2aXNpb247Ci0JbmRh
Y2xfcHRyLT5zaXplID0gaHRvbGUxNihhY2Vzc2l6ZSArIHNpemVvZihzdHJ1Y3QgY2lmc19jdHJs
X2FjbCkpOworCW5kYWNsX3B0ci0+c2l6ZSA9IGh0b2xlMTYoc2l6ZSk7CiAJbmRhY2xfcHRyLT5u
dW1fYWNlcyA9IGh0b2xlMzIobnVtYWNlcyk7CisJKmJ1ZnNpemUgPSAqYnVmc2l6ZSArIHNpemU7
CiAKIAkvKiBjb3B5IG93bmVyIHNpZCAqLwogCW93bmVyX3NpZF9wdHIgPSAoc3RydWN0IGNpZnNf
c2lkICopKChjaGFyICopcG50c2QgKyBvc2lkc29mZnNldCk7CiAJbm93bmVyX3NpZF9wdHIgPSAo
c3RydWN0IGNpZnNfc2lkICopKChjaGFyICopcG5udHNkICsgb3NpZHNvZmZzZXQpOwotCWNvcHlf
Y2lmc19zaWQobm93bmVyX3NpZF9wdHIsIG93bmVyX3NpZF9wdHIpOworCXNpemUgPSBjb3B5X2Np
ZnNfc2lkKG5vd25lcl9zaWRfcHRyLCBvd25lcl9zaWRfcHRyKTsKKwkqYnVmc2l6ZSA9ICpidWZz
aXplICsgc2l6ZTsKIAogCS8qIGNvcHkgZ3JvdXAgc2lkICovCiAJZ3JvdXBfc2lkX3B0ciA9IChz
dHJ1Y3QgY2lmc19zaWQgKikoKGNoYXIgKilwbnRzZCArIGdzaWRzb2Zmc2V0KTsKIAluZ3JvdXBf
c2lkX3B0ciA9IChzdHJ1Y3QgY2lmc19zaWQgKikoKGNoYXIgKilwbm50c2QgKyBnc2lkc29mZnNl
dCk7Ci0JY29weV9jaWZzX3NpZChuZ3JvdXBfc2lkX3B0ciwgZ3JvdXBfc2lkX3B0cik7CisJc2l6
ZSA9IGNvcHlfY2lmc19zaWQobmdyb3VwX3NpZF9wdHIsIGdyb3VwX3NpZF9wdHIpOworCSpidWZz
aXplID0gKmJ1ZnNpemUgKyBzaXplOwogCiAJcmV0dXJuOwogfQpAQCAtMTU2LDEwICsxNzEsMTAg
QEAgY29tcGFyZV9hY2VzKHN0cnVjdCBjaWZzX2FjZSAqc2FjZSwgc3RydWN0IGNpZnNfYWNlICpk
YWNlLCBpbnQgY29tcGZsYWdzKQogfQogCiBzdGF0aWMgaW50Ci1nZXRfc2VjX2Rlc2Nfc2l6ZShz
dHJ1Y3QgY2lmc19udHNkICpwbnRzZCwgc3RydWN0IGNpZnNfbnRzZCAqKm5wbnRzZCwKLQkJCWlu
dCBhY2VzLCBzc2l6ZV90ICpidWZzaXplLCBzaXplX3QgKmFjZXNvZmZzZXQpCithbGxvY19zZWNf
ZGVzYyhzdHJ1Y3QgY2lmc19udHNkICpwbnRzZCwgc3RydWN0IGNpZnNfbnRzZCAqKm5wbnRzZCwK
KwkJCWludCBhY2VzLCBzaXplX3QgKmFjZXNvZmZzZXQpCiB7Ci0JdW5zaWduZWQgaW50IHNpemUs
IGFjZXNzaXplLCBkYWNsb2Zmc2V0OworCXVuc2lnbmVkIGludCBzaXplLCBhY2Vzc2l6ZSwgYnVm
c2l6ZSwgZGFjbG9mZnNldDsKIAogCXNpemUgPSBzaXplb2Yoc3RydWN0IGNpZnNfbnRzZCkgKwog
CQkyICogc2l6ZW9mKHN0cnVjdCBjaWZzX3NpZCkgKwpAQCAtMTY5LDkgKzE4NCw5IEBAIGdldF9z
ZWNfZGVzY19zaXplKHN0cnVjdCBjaWZzX250c2QgKnBudHNkLCBzdHJ1Y3QgY2lmc19udHNkICoq
bnBudHNkLAogCiAJKmFjZXNvZmZzZXQgPSBkYWNsb2Zmc2V0ICsgc2l6ZW9mKHN0cnVjdCBjaWZz
X2N0cmxfYWNsKTsKIAlhY2Vzc2l6ZSA9IGFjZXMgKiBzaXplb2Yoc3RydWN0IGNpZnNfYWNlKTsK
LQkqYnVmc2l6ZSA9IHNpemUgKyBhY2Vzc2l6ZTsKKwlidWZzaXplID0gc2l6ZSArIGFjZXNzaXpl
OwogCi0JKm5wbnRzZCA9IG1hbGxvYygqYnVmc2l6ZSk7CisJKm5wbnRzZCA9IG1hbGxvYyhidWZz
aXplKTsKIAlpZiAoISpucG50c2QpIHsKIAkJcHJpbnRmKCIlczogTWVtb3J5IGFsbG9jYXRpb24g
ZmFpbHVyZSIsIF9fZnVuY19fKTsKIAkJcmV0dXJuIGVycm5vOwpAQCAtMTg4LDcgKzIwMyw3IEBA
IGFjZV9zZXQoc3RydWN0IGNpZnNfbnRzZCAqcG50c2QsIHN0cnVjdCBjaWZzX250c2QgKipucG50
c2QsIHNzaXplX3QgKmJ1ZnNpemUsCiAJc2l6ZV90IGFjZXNvZmZzZXQ7CiAJY2hhciAqYWNlc3B0
cjsKIAotCXJjID0gZ2V0X3NlY19kZXNjX3NpemUocG50c2QsIG5wbnRzZCwgbnVtY2FjZXMsIGJ1
ZnNpemUsICZhY2Vzb2Zmc2V0KTsKKwlyYyA9IGFsbG9jX3NlY19kZXNjKHBudHNkLCBucG50c2Qs
IG51bWNhY2VzLCAmYWNlc29mZnNldCk7CiAJaWYgKHJjKQogCQlyZXR1cm4gcmM7CiAKQEAgLTE5
OCw5ICsyMTMsOCBAQCBhY2Vfc2V0KHN0cnVjdCBjaWZzX250c2QgKnBudHNkLCBzdHJ1Y3QgY2lm
c19udHNkICoqbnBudHNkLCBzc2l6ZV90ICpidWZzaXplLAogCQlhY2Vzc2l6ZSArPSBzaXplOwog
CQlhY2VzcHRyICs9IHNpemU7CiAJfQotCWNvcHlfc2VjX2Rlc2MocG50c2QsICpucG50c2QsIG51
bWNhY2VzLCBhY2Vzc2l6ZSk7Ci0JYWNlc3B0ciA9IChjaGFyICopKm5wbnRzZCArIGFjZXNvZmZz
ZXQ7CiAKKwljb3B5X3NlY19kZXNjKHBudHNkLCAqbnBudHNkLCBudW1jYWNlcywgYWNlc3NpemUs
IGJ1ZnNpemUpOwogCiAJcmV0dXJuIDA7CiB9CkBAIC0yMTUsNyArMjI5LDcgQEAgYWNlX2FkZChz
dHJ1Y3QgY2lmc19udHNkICpwbnRzZCwgc3RydWN0IGNpZnNfbnRzZCAqKm5wbnRzZCwgc3NpemVf
dCAqYnVmc2l6ZSwKIAljaGFyICphY2VzcHRyOwogCiAJbnVtYWNlcyA9IG51bWZhY2VzICsgbnVt
Y2FjZXM7Ci0JcmMgPSBnZXRfc2VjX2Rlc2Nfc2l6ZShwbnRzZCwgbnBudHNkLCBudW1hY2VzLCBi
dWZzaXplLCAmYWNlc29mZnNldCk7CisJcmMgPSBhbGxvY19zZWNfZGVzYyhwbnRzZCwgbnBudHNk
LCBudW1hY2VzLCAmYWNlc29mZnNldCk7CiAJaWYgKHJjKQogCQlyZXR1cm4gcmM7CiAKQEAgLTIz
MCw3ICsyNDQsOCBAQCBhY2VfYWRkKHN0cnVjdCBjaWZzX250c2QgKnBudHNkLCBzdHJ1Y3QgY2lm
c19udHNkICoqbnBudHNkLCBzc2l6ZV90ICpidWZzaXplLAogCQlhY2VzcHRyICs9IHNpemU7CiAJ
CWFjZXNzaXplICs9IHNpemU7CiAJfQotCWNvcHlfc2VjX2Rlc2MocG50c2QsICpucG50c2QsIG51
bWFjZXMsIGFjZXNzaXplKTsKKworCWNvcHlfc2VjX2Rlc2MocG50c2QsICpucG50c2QsIG51bWFj
ZXMsIGFjZXNzaXplLCBidWZzaXplKTsKIAogCXJldHVybiAwOwogfQpAQCAtMjQ5LDcgKzI2NCw3
IEBAIGFjZV9tb2RpZnkoc3RydWN0IGNpZnNfbnRzZCAqcG50c2QsIHN0cnVjdCBjaWZzX250c2Qg
KipucG50c2QsIHNzaXplX3QgKmJ1ZnNpemUsCiAJCXJldHVybiAtMTsKIAl9CiAKLQlyYyA9IGdl
dF9zZWNfZGVzY19zaXplKHBudHNkLCBucG50c2QsIG51bWZhY2VzLCBidWZzaXplLCAmYWNlc29m
ZnNldCk7CisJcmMgPSBhbGxvY19zZWNfZGVzYyhwbnRzZCwgbnBudHNkLCBudW1mYWNlcywgJmFj
ZXNvZmZzZXQpOwogCWlmIChyYykKIAkJcmV0dXJuIHJjOwogCkBAIC0yNzAsNyArMjg1LDcgQEAg
YWNlX21vZGlmeShzdHJ1Y3QgY2lmc19udHNkICpwbnRzZCwgc3RydWN0IGNpZnNfbnRzZCAqKm5w
bnRzZCwgc3NpemVfdCAqYnVmc2l6ZSwKIAkJYWNlc3NpemUgKz0gc2l6ZTsKIAl9CiAKLQljb3B5
X3NlY19kZXNjKHBudHNkLCAqbnBudHNkLCBudW1mYWNlcywgYWNlc3NpemUpOworCWNvcHlfc2Vj
X2Rlc2MocG50c2QsICpucG50c2QsIG51bWZhY2VzLCBhY2Vzc2l6ZSwgYnVmc2l6ZSk7CiAKIAly
ZXR1cm4gMDsKIH0KQEAgLTI5NCw3ICszMDksNyBAQCBhY2VfZGVsZXRlKHN0cnVjdCBjaWZzX250
c2QgKnBudHNkLCBzdHJ1Y3QgY2lmc19udHNkICoqbnBudHNkLCBzc2l6ZV90ICpidWZzaXplLAog
CQlyZXR1cm4gLTE7CiAJfQogCi0JcmMgPSBnZXRfc2VjX2Rlc2Nfc2l6ZShwbnRzZCwgbnBudHNk
LCBudW1mYWNlcywgYnVmc2l6ZSwgJmFjZXNvZmZzZXQpOworCXJjID0gYWxsb2Nfc2VjX2Rlc2Mo
cG50c2QsIG5wbnRzZCwgbnVtZmFjZXMsICZhY2Vzb2Zmc2V0KTsKIAlpZiAocmMpCiAJCXJldHVy
biByYzsKIApAQCAtMzE3LDcgKzMzMiw4IEBAIGFjZV9kZWxldGUoc3RydWN0IGNpZnNfbnRzZCAq
cG50c2QsIHN0cnVjdCBjaWZzX250c2QgKipucG50c2QsIHNzaXplX3QgKmJ1ZnNpemUsCiAJCXBy
aW50ZigiJXM6IE5vdGhpbmcgdG8gZGVsZXRlXG4iLCBfX2Z1bmNfXyk7CiAJCXJldHVybiAxOwog
CX0KLQljb3B5X3NlY19kZXNjKHBudHNkLCAqbnBudHNkLCBudW1hY2VzLCBhY2Vzc2l6ZSk7CisK
Kwljb3B5X3NlY19kZXNjKHBudHNkLCAqbnBudHNkLCBudW1hY2VzLCBhY2Vzc2l6ZSwgYnVmc2l6
ZSk7CiAKIAlyZXR1cm4gMDsKIH0K
--94eb2c19ce2e78a76c05538afeba--
