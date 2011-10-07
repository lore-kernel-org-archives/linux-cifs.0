From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Samba] SMB Signing issues... smbclient works, mount does not...
Date: Fri, 7 Oct 2011 09:48:16 -0500
Message-ID: <CADT32eJoEXutC2g4PjUBq04KbHHmSHE2piaajS7tjGSmEkxUgA@mail.gmail.com>
References: <CAOCnWPJDHeyTEai1vcGLbRNMiv3Z0ztT_GaE+Yhu=uKY8zA76Q@mail.gmail.com>
	<CADT32eKNq5b0BxiMAiT+yKzH_4peewj1wDtCq+4ViewZ4vymHw@mail.gmail.com>
	<4E8E8C39.80401@fugspbr.org>
	<CADT32eJQK=6+BQprB6W5-9Fa9oX-zfS5L=V6bAjC8YxAc1MG7Q@mail.gmail.com>
	<4E8F0039.7020306@fugspbr.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Vini <vini-d6Y6gO9EMTtAfugRpC6u6w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E8F0039.7020306-d6Y6gO9EMTtAfugRpC6u6w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Oct 7, 2011 at 8:35 AM, Vini <vini-d6Y6gO9EMTtAfugRpC6u6w@public.gmane.org> wrote:
> Shirish Pargaonkar said the following on 8/10/11 12:20 AM:
>> On Fri, Oct 7, 2011 at 12:20 AM, Vini <vini-d6Y6gO9EMTtAfugRpC6u6w@public.gmane.org> wrote:
>>> On 7/10/2011 1:18 PM, Shirish Pargaonkar wrote:
>>>> On Thu, Oct 6, 2011 at 10:10 PM, Vini <vini-d6Y6gO9EMTtAfugRpC6u6w@public.gmane.org> wrote:
>>>>> Hi All,
>>>>>
>>>>> I seem to have exactly the same problem which was described in th=
is thread a
>>>>> while ago. I have gone through every piece of information I was a=
ble to find
>>>>> on mailing list archives but all I found was people reporting sim=
ilar
>>>>> problems and not a solution to it.
>>>>>
>>>>> As in the original discussion if I use smbclient it works fine bu=
t if I use
>>>>> mount.cifs it does not work at all. To make smbclient work I have=
 had to add
>>>>> "client ntlmv2 auth =3D yes" to the sbm.conf file.
>>>>>
>>>>> The server I am connecting to is a Windows 2008 R2 and the securi=
ty policy
>>>>> only allows NTLMv2.
>>>>>
>>>>> I am trying to connect from a Centos 5.5
>>>>>
>>>>> 2.6.18-274.3.1.el5 #1 SMP Tue Sep 6 20:14:03 EDT 2011 i686 i686 i=
386
>>>>> GNU/Linux
>>>>>
>>>>> libsmbclient-3.5.4-68.2
>>>>> samba-3.5.4-68.2
>>>>> samba-common-3.5.4-68.2
>>>>> samba-client-3.5.4-68.2
>>>>> samba-winbind-clients-3.5.4-68.2
>>>>> cifs-utils-4.4-5.2
>>>>>
>>>>> ls /proc/fs/cifs/
>>>>> cifsFYI
>>>>> DebugData
>>>>> Experimental
>>>>> LinuxExtensionsEnabled
>>>>> LookupCacheEnabled
>>>>> MultiuserMount
>>>>> OplockEnabled
>>>>> SecurityFlags
>>>>> Stats
>>>>> traceSMB
>>>>>
>>>>> modinfo cifs
>>>>> filename: =A0 =A0 =A0 /lib/modules/2.6.18-274.3.1.el5/kernel/fs/c=
ifs/cifs.ko
>>>>> version: =A0 =A0 =A0 =A01.60RH
>>>>> description: =A0 =A0VFS to access servers complying with the SNIA=
 CIFS
>>>>> Specification e.g. Samba and Windows
>>>>> license: =A0 =A0 =A0 =A0GPL
>>>>> author: =A0 =A0 =A0 =A0 Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>>>>> srcversion: =A0 =A0 4A9C63C35E60B4C015318F5
>>>>> depends:
>>>>> vermagic: =A0 =A0 =A0 2.6.18-274.3.1.el5 SMP mod_unload 686 REGPA=
RM 4KSTACKS
>>>>> gcc-4.1
>>>>> parm: =A0 =A0 =A0 =A0 =A0 CIFSMaxBufSize:Network buffer size (not=
 including header).
>>>>> Default: 16384 Range: 8192 to 130048 (int)
>>>>> parm: =A0 =A0 =A0 =A0 =A0 cifs_min_rcv:Network buffers in pool. D=
efault: 4 Range: 1 to
>>>>> 64 (int)
>>>>> parm: =A0 =A0 =A0 =A0 =A0 cifs_min_small:Small network buffers in=
 pool. Default: 30
>>>>> Range: 2 to 256 (int)
>>>>> parm: =A0 =A0 =A0 =A0 =A0 cifs_max_pending:Simultaneous requests =
to server. Default:
>>>>> 50 Range: 2 to 256 (int)
>>>>> module_sig:
>>>>> 883f3504e66bf24104f42edc2b0f945112c79009d1e1918c363e6545d5644af26=
235486a0faee309e3e516f3731905cd551976d305e8c32b5f117ae9b
>>>>>
>>>>>
>>>>> This works without issues:
>>>>>
>>>>> smbclient -U username //192.168.20.129/share
>>>>>
>>>>> But this does not work at all:
>>>>>
>>>>> mount.cifs //192.168.20.129/share /mnt/ -o
>>>>> user=3Dusername,password=3DXXXXXXX,sec=3Dntlmv2
>>>>>
>>>>> For the record I have tried sec=3Dntlmv2i, ntlmssp, krb5i, krb5.
>>>>>
>>>>> Here is what I get when I try:
>>>>>
>>>>>
>>>>>
>>>>> With sec=3Dntlmv2i
>>>>>
>>>>> mount error(22): Invalid argument
>>>>> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>>>>>
>>>>> and dmesg gives:
>>>>>
>>>>> =A0CIFS VFS: Unexpected SMB signature
>>>>> Status code returned 0xc000000d NT_STATUS_INVALID_PARAMETER
>>>>> =A0CIFS VFS: Send error in SessSetup =3D -22
>>>>> =A0CIFS VFS: cifs_mount failed w/return code =3D -22
>>>>>
>>>>>
>>>>>
>>>>> With sec=3Dntlmv2
>>>>>
>>>>> mount error(95): Operation not supported
>>>>> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>>>>>
>>>>> and dmesg gives:
>>>>>
>>>>> =A0CIFS VFS: Server requires packet signing to be enabled in
>>>>> /proc/fs/cifs/SecurityFlags.
>>>>> =A0CIFS VFS: cifs_mount failed w/return code =3D -95
>>>>>
>>>>>
>>>>>
>>>>> With sec=3Dntlmssp
>>>>>
>>>>> mount error(95): Operation not supported
>>>>> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>>>>>
>>>>> and dmesg gives:
>>>>>
>>>>> =A0CIFS VFS: Server requires packet signing to be enabled in
>>>>> /proc/fs/cifs/SecurityFlags.
>>>>> =A0CIFS VFS: cifs_mount failed w/return code =3D -95
>>>>>
>>>>>
>>>>> I have tried changing the values /proc/fs/cifs/SecurityFlags but =
no
>>>>> difference at all.
>>>>>
>>>>> may use packet signing =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A00x00001
>>>>> must use packet signing =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 0x01001
>>>>> may use NTLM (most common password hash) =A0 =A0 =A0 =A00x00002
>>>>> must use NTLM =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 0x02002
>>>>> may use NTLMv2 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A00x00004
>>>>> must use NTLMv2 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 0x04004
>>>>> may use Kerberos security =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 0x00008
>>>>> must use Kerberos =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 0x08008
>>>>> may use lanman (weak) password hash =A0 =A0 =A0 =A0 =A0 =A0 0x000=
10
>>>>> must use lanman password hash =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 0x10010
>>>>> may use plaintext passwords =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 0x00020
>>>>> must use plaintext passwords =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A00x20020
>>>>>
>>>>> Reference on line 588
>>>>> http://www.disy.cse.unsw.edu.au/lxr/source/fs/cifs/?v=3Dlinux-2.6=
=2E32
>>>>>
>>>>> One funny thing is that there should be a pseudo-file called
>>>>> /proc/fs/cifs/PacketSigningEnabled but it does not exist, even on=
 much newer
>>>>> kernels it does not exist.
>>>>>
>>>>>
>>>>> Has anyone been able to overcome this problem?
>>>>>
>>>>> Thanks
>>>>> Vini
>>>>> --
>>>>> To unsubscribe from this list go to the following URL and read th=
e
>>>>> instructions: =A0https://lists.samba.org/mailman/options/samba
>>>>>
>>>>
>>>> You probably need this patch installed on the Windows 2008 server
>>>> =A0http://support.microsoft.com/kb/957441/en-us
>>>
>>> I have tried this and it did not work either, once I apply it the l=
ogin
>>> fails with "NT_STATUS_LOGON_FAILURE"
>>>
>>
>> A wireshark trace would be useful. =A0But if you can use latest cifs=
 code
>> from 3.1 kernel on the mainline, that has a NTLMv2 fix, which might
>> fix this problem.
>> You can try either sec=3Dntlmssp or sec=3Dntlmsspi (If signing is en=
abled
>> on the server) mount option and see that helps.
>
> Unfortunately I cannot use the latest kernel, the amount of work to
> upgrade it wouldn't be justifiable.
>
> Do you want me to use anything special in the mount command when
> capturing the traffic?
>
> --
> Vini
>

No, nothing special as such. Just a regular wireshark trace while mount=
ing
a filesystem.  I think sec=3Dntlmssp/i will work though, that uses ntlm=
v2
authentication also.

Regards,

Shirish
