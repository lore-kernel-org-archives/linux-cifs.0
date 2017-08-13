From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs-utils: setcifsacl receives STATUS_INVALID_SECURITY_DESCR
 reply from custom CIFS implementation
Date: Sat, 12 Aug 2017 20:33:00 -0500
Message-ID: <CADT32e+9G5qp1+0t00uY=pCCjpNk4Rn=-qa9LSUF+0P6fHkA3Q@mail.gmail.com>
References: <CAFoiuNiOdjSRwFWmEqSU2WWotUOL_ywrOpj8oSk8UWBC=_cujw@mail.gmail.com>
 <CADT32eKnksmhQNpuQfo91ybQKAiUgdpa3SG5GxSyxGCnTXeH6w@mail.gmail.com>
 <CAFoiuNjj6s8179EMh_f-a2zCjTatGLZtrM5H6Bk7D=mGndNgDg@mail.gmail.com>
 <CADT32e+jR+5h=K1ujnScnGoHuDMgqinOSpKUdigQafaY8-MBWw@mail.gmail.com>
 <CADT32eKtWMF+8+jf=UWh8hsuNGA6GoTqP-+s0H8E3U=6uhX61A@mail.gmail.com> <CAFoiuNj1BiAXu4nPacmBxTvck4-TLeTWVEHN+_miR8WaTLv8DA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Paul van Schayck <polleke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFoiuNj1BiAXu4nPacmBxTvck4-TLeTWVEHN+_miR8WaTLv8DA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Somehow I missed this response. Out till Friday, will submit this
patch once I am back, next week. Thanks for testing the patch.

Regards,

Shirish

On Tue, Jul 11, 2017 at 7:13 AM, Paul van Schayck <polleke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
> Hi Shirish,
>
> I've tested the patch, and as far as I can see it works perfectly. The
> extra zero bytes are no longer in the request and the server now
> accepts them. I've tested on a number of directories, with a number of
> different ACEs, adding and deleting, and could not find an issue so
> far.
>
> I've not tested the smb2 patches for setting acl's yet, as I do not
> have an environment ready to go for recompiling the cifs kernel
> module.
>
> The server we are using is a Hitachi HNAS:
> https://www.hds.com/en-us/products-solutions/storage/network-attached-sto=
rage-platform.html
>
> Thanks,
>
> Paul
>
> On Wed, Jul 5, 2017 at 7:08 AM, Shirish Pargaonkar
> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Can you try this patch, I did preliminary testing...
>>
>>
>>
>> On Tue, Jul 4, 2017 at 4:17 PM, Shirish Pargaonkar
>> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> Hi Paul,
>>>
>>> So something like this works with smb 2.1 with the patchset I posted
>>> on the mailing list
>>> to make set acl work over smb 2 onwards...
>>>
>>> $ sudo ls -l /mnt/
>>> total 1
>>> -rwx------ 1 root root 32 Jan 26  2015 file1.txt
>>> -rwx------ 1 root root  0 Nov 30  2014 file2.txt
>>> drwx------ 2 root root  0 Nov 30  2014 folder1
>>> drwx------ 2 root root  0 Dec 22  2014 folder2
>>>
>>> $ sudo setcifsacl -S
>>> "ACL:S-1-5-21-609720889-20222076-3464071719-1001:ALLOWED/0x0/FULL,ACL:S=
-1-5-21-609720889-20222076-3464071719-513:ALLOWED/0x0/0x1f01b9,ACL:\Everyon=
e:ALLOWED/0x0/0x1f01b9"
>>> /mnt/file1.txt
>>>
>>> $ sudo ls -l /mnt/
>>> total 1
>>> -rwxr-xr-x 1 root root 32 Jan 26  2015 file1.txt
>>> -rwx------ 1 root root  0 Nov 30  2014 file2.txt
>>> drwx------ 2 root root  0 Nov 30  2014 folder1
>>> drwx------ 2 root root  0 Dec 22  2014 folder2
>>>
>>> I then changed it back to 700 using smb1 set cifs acl and it worked too=
.
>>>
>>> $ sudo setcifsacl -S
>>> "ACL:S-1-5-21-609720889-20222076-3464071719-1001:ALLOWED/0x0/FULL,ACL:S=
-1-5-21-609720889-20222076-3464071719-513:ALLOWED/0x0/0x120088,ACL:\Everyon=
e:ALLOWED/0x0/0x120088"
>>> /mnt/file1.txt
>>>
>>> $ sudo ls -l /mnt/
>>> total 1
>>> -rwx------ 1 root root 32 Jan 26  2015 file1.txt
>>> -rwx------ 1 root root  0 Nov 30  2014 file2.txt
>>> drwx------ 2 root root  0 Nov 30  2014 folder1
>>> drwx------ 2 root root  0 Dec 22  2014 folder2
>>>
>>> What type of Windows server is this?  These requests succeed but I do
>>> see extra bytes
>>> at the end of the security descriptor in both the requests, trying to
>>> figure out why is it allocated in the first place...
>>>
>>>
>>> On Tue, Jun 27, 2017 at 5:43 AM, Paul van Schayck <polleke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
>>>> Hi Shirish,
>>>>
>>>> Thank you for your answer.
>>>>
>>>> Attached you can find three pcap files.
>>>>
>>>> 1. linux-fail.pcap: Using the setcifsacl 6.7 version.
>>>> 2. linux-succes.pcap: Using the modified setcifsacl with the patch
>>>> above (note, I had to change to len + 4 in trim_request())
>>>> 3. windows-succes-trimmed.pcap: Using the dialog in Windows. Note that
>>>> this is over smbv2. The file was trimmed down, because windows was
>>>> noisy.
>>>>
>>>> The command I used was
>>>>
>>>> setcifsacl -S "ACL:S-1-5-21-1572361299-1184395705-1606240830-247332:AL=
LOWED/OI|CI/CHANGE,ACL:S-1-5-21-1572361299-1184395705-1606240830-544559:ALL=
OWED/I/FULL,ACL:S-1-3-0:ALLOWED/OI|CI|IO|I/FULL,ACL:S-1-5-21-1572361299-118=
4395705-1606240830-512:ALLOWED/OI|CI|I/FULL,ACL:S-1-5-21-1572361299-1184395=
705-1606240830-549266:ALLOWED/OI|CI|I/FULL,ACL:S-1-5-21-1572361299-11843957=
05-1606240830-544559:ALLOWED/OI|CI|IO|I/FULL,ACL:S-1-5-18:ALLOWED/OI|CI|I/F=
ULL"
>>>> cifs-test/
>>>>
>>>> In Windows I used the dialog to set the same ACEs. Between the
>>>> linux-success and linux-fail file you can see the difference in the
>>>> number of zero bytes after the DACL.
>>>>
>>>> If this test case is still a bit noisy for you, I can try to build a
>>>> more simple ACE list. But I have to setup a new share for this.
>>>>
>>>> Thanks,
>>>>
>>>> Paul van Schayck
>>>>
>>>> On Tue, Jun 27, 2017 at 6:40 AM, Shirish Pargaonkar
>>>> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>> if you can provide tcpdumpas well as the command you are using of/for
>>>>> both Windows and Linux way, that would be helpful
>>>>>
>>>>> On Mon, Jun 26, 2017 at 8:04 AM, Paul van Schayck via samba-technical
>>>>> <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org> wrote:
>>>>>> Dear samba-technical,
>>>>>>
>>>>>> If this list is inappropriate for this question then please redirect
>>>>>> me to a better one.
>>>>>>
>>>>>> I'm working with a HDS HNAS (Hitachi NAS) which has its own
>>>>>> implementation of the CIFS protocol. Mounting, and interactions all =
go
>>>>>> fine using linux-cifs and related tools.
>>>>>>
>>>>>> However, when sending a `setcifsacl -a ACE /dir` the response is
>>>>>> "main: setxattr error: Input/output error". Upon further digging usi=
ng
>>>>>> tcpdump/wireshark it became clear that the HNAS is responding with
>>>>>>
>>>>>> NT Status: STATUS_INVALID_SECURITY_DESCR (0xc0000079)
>>>>>>
>>>>>> Setting the same ACE using a Windows client did work. So further
>>>>>> examining of the request being sent showed that the only difference
>>>>>> between the Windows client and setcifsacl was the addition of a lot =
of
>>>>>> padding zero bytes at the end of the security descriptor.
>>>>>>
>>>>>> Examining the code of setcifsacl.c and the request more it seems lik=
e
>>>>>> the request was not properly trimmed down to the number of aces bein=
g
>>>>>> sent. More buffer was allocated that the number of aces being sent. =
So
>>>>>> I made the attached patch to trim down the request. This fixes some =
of
>>>>>> the problems with setcifsacl, but for example breaks deleting aces. =
I
>>>>>> also think it's most likely an ugly fix, and the problem needs to be
>>>>>> solved elsewhere most likely.
>>>>>>
>>>>>> So my question is if someone can point me at the correct way to fix
>>>>>> this in setcifsacl, or help me fix it properly. If necessary I can
>>>>>> provide tcpdump's of Windows and Linux clients performing the reques=
t.
>>>>>>
>>>>>> Thanks,
>>>>>>
>>>>>> Paul van Schayck
>>>>>>
>>>>>> diff --git a/setcifsacl.c b/setcifsacl.c
>>>>>> index 7eeeaa6..4ada3c8 100644
>>>>>> --- a/setcifsacl.c
>>>>>> +++ b/setcifsacl.c
>>>>>> @@ -761,6 +761,20 @@ setacl_action(struct cifs_ntsd *pntsd, struct
>>>>>> cifs_ntsd **npntsd,
>>>>>>         return rc;
>>>>>>  }
>>>>>>
>>>>>> +ssize_t
>>>>>> +trim_request(ssize_t bufsize, struct cifs_ntsd *npntsd) {
>>>>>> +       int i, len =3D 0;
>>>>>> +       char *a =3D (char *) npntsd;
>>>>>> +
>>>>>> +       for( i =3D 0; i < bufsize; i++) {
>>>>>> +               if ( a[i] !=3D 0 )
>>>>>> +                       len =3D i;
>>>>>> +       }
>>>>>> +
>>>>>> +       return (ssize_t) len + 2;
>>>>>> +}
>>>>>> +
>>>>>> +
>>>>>>  static void
>>>>>>  setcifsacl_usage(const char *prog)
>>>>>>  {
>>>>>> @@ -902,7 +916,7 @@ cifsacl:
>>>>>>         if (rc)
>>>>>>                 goto setcifsacl_action_ret;
>>>>>>
>>>>>> -       attrlen =3D setxattr(filename, ATTRNAME, ntsdptr, bufsize, 0=
);
>>>>>> +       attrlen =3D setxattr(filename, ATTRNAME, ntsdptr,
>>>>>> trim_request(bufsize, ntsdptr), 0);
>>>>>>         if (attrlen =3D=3D -1) {
>>>>>>                 printf("%s: setxattr error: %s\n", __func__, strerro=
r(errno));
>>>>>>                 goto setcifsacl_facenum_ret;
>>>>>>
