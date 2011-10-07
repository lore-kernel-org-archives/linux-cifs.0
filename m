From: Vini <vini-d6Y6gO9EMTtAfugRpC6u6w@public.gmane.org>
Subject: Re: [Samba] SMB Signing issues... smbclient works, mount does not...
Date: Sat, 08 Oct 2011 00:35:53 +1100
Message-ID: <4E8F0039.7020306@fugspbr.org>
References: <CAOCnWPJDHeyTEai1vcGLbRNMiv3Z0ztT_GaE+Yhu=uKY8zA76Q@mail.gmail.com> <CADT32eKNq5b0BxiMAiT+yKzH_4peewj1wDtCq+4ViewZ4vymHw@mail.gmail.com> <4E8E8C39.80401@fugspbr.org> <CADT32eJQK=6+BQprB6W5-9Fa9oX-zfS5L=V6bAjC8YxAc1MG7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eJQK=6+BQprB6W5-9Fa9oX-zfS5L=V6bAjC8YxAc1MG7Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Shirish Pargaonkar said the following on 8/10/11 12:20 AM:
> On Fri, Oct 7, 2011 at 12:20 AM, Vini <vini-d6Y6gO9EMTtAfugRpC6u6w@public.gmane.org> wrote:
>> On 7/10/2011 1:18 PM, Shirish Pargaonkar wrote:
>>> On Thu, Oct 6, 2011 at 10:10 PM, Vini <vini-d6Y6gO9EMTtAfugRpC6u6w@public.gmane.org> wrote:
>>>> Hi All,
>>>>
>>>> I seem to have exactly the same problem which was described in this thread a
>>>> while ago. I have gone through every piece of information I was able to find
>>>> on mailing list archives but all I found was people reporting similar
>>>> problems and not a solution to it.
>>>>
>>>> As in the original discussion if I use smbclient it works fine but if I use
>>>> mount.cifs it does not work at all. To make smbclient work I have had to add
>>>> "client ntlmv2 auth = yes" to the sbm.conf file.
>>>>
>>>> The server I am connecting to is a Windows 2008 R2 and the security policy
>>>> only allows NTLMv2.
>>>>
>>>> I am trying to connect from a Centos 5.5
>>>>
>>>> 2.6.18-274.3.1.el5 #1 SMP Tue Sep 6 20:14:03 EDT 2011 i686 i686 i386
>>>> GNU/Linux
>>>>
>>>> libsmbclient-3.5.4-68.2
>>>> samba-3.5.4-68.2
>>>> samba-common-3.5.4-68.2
>>>> samba-client-3.5.4-68.2
>>>> samba-winbind-clients-3.5.4-68.2
>>>> cifs-utils-4.4-5.2
>>>>
>>>> ls /proc/fs/cifs/
>>>> cifsFYI
>>>> DebugData
>>>> Experimental
>>>> LinuxExtensionsEnabled
>>>> LookupCacheEnabled
>>>> MultiuserMount
>>>> OplockEnabled
>>>> SecurityFlags
>>>> Stats
>>>> traceSMB
>>>>
>>>> modinfo cifs
>>>> filename:       /lib/modules/2.6.18-274.3.1.el5/kernel/fs/cifs/cifs.ko
>>>> version:        1.60RH
>>>> description:    VFS to access servers complying with the SNIA CIFS
>>>> Specification e.g. Samba and Windows
>>>> license:        GPL
>>>> author:         Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>>>> srcversion:     4A9C63C35E60B4C015318F5
>>>> depends:
>>>> vermagic:       2.6.18-274.3.1.el5 SMP mod_unload 686 REGPARM 4KSTACKS
>>>> gcc-4.1
>>>> parm:           CIFSMaxBufSize:Network buffer size (not including header).
>>>> Default: 16384 Range: 8192 to 130048 (int)
>>>> parm:           cifs_min_rcv:Network buffers in pool. Default: 4 Range: 1 to
>>>> 64 (int)
>>>> parm:           cifs_min_small:Small network buffers in pool. Default: 30
>>>> Range: 2 to 256 (int)
>>>> parm:           cifs_max_pending:Simultaneous requests to server. Default:
>>>> 50 Range: 2 to 256 (int)
>>>> module_sig:
>>>> 883f3504e66bf24104f42edc2b0f945112c79009d1e1918c363e6545d5644af26235486a0faee309e3e516f3731905cd551976d305e8c32b5f117ae9b
>>>>
>>>>
>>>> This works without issues:
>>>>
>>>> smbclient -U username //192.168.20.129/share
>>>>
>>>> But this does not work at all:
>>>>
>>>> mount.cifs //192.168.20.129/share /mnt/ -o
>>>> user=username,password=XXXXXXX,sec=ntlmv2
>>>>
>>>> For the record I have tried sec=ntlmv2i, ntlmssp, krb5i, krb5.
>>>>
>>>> Here is what I get when I try:
>>>>
>>>>
>>>>
>>>> With sec=ntlmv2i
>>>>
>>>> mount error(22): Invalid argument
>>>> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>>>>
>>>> and dmesg gives:
>>>>
>>>>  CIFS VFS: Unexpected SMB signature
>>>> Status code returned 0xc000000d NT_STATUS_INVALID_PARAMETER
>>>>  CIFS VFS: Send error in SessSetup = -22
>>>>  CIFS VFS: cifs_mount failed w/return code = -22
>>>>
>>>>
>>>>
>>>> With sec=ntlmv2
>>>>
>>>> mount error(95): Operation not supported
>>>> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>>>>
>>>> and dmesg gives:
>>>>
>>>>  CIFS VFS: Server requires packet signing to be enabled in
>>>> /proc/fs/cifs/SecurityFlags.
>>>>  CIFS VFS: cifs_mount failed w/return code = -95
>>>>
>>>>
>>>>
>>>> With sec=ntlmssp
>>>>
>>>> mount error(95): Operation not supported
>>>> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>>>>
>>>> and dmesg gives:
>>>>
>>>>  CIFS VFS: Server requires packet signing to be enabled in
>>>> /proc/fs/cifs/SecurityFlags.
>>>>  CIFS VFS: cifs_mount failed w/return code = -95
>>>>
>>>>
>>>> I have tried changing the values /proc/fs/cifs/SecurityFlags but no
>>>> difference at all.
>>>>
>>>> may use packet signing                          0x00001
>>>> must use packet signing                         0x01001
>>>> may use NTLM (most common password hash)        0x00002
>>>> must use NTLM                                   0x02002
>>>> may use NTLMv2                                  0x00004
>>>> must use NTLMv2                                 0x04004
>>>> may use Kerberos security                       0x00008
>>>> must use Kerberos                               0x08008
>>>> may use lanman (weak) password hash             0x00010
>>>> must use lanman password hash                   0x10010
>>>> may use plaintext passwords                     0x00020
>>>> must use plaintext passwords                    0x20020
>>>>
>>>> Reference on line 588
>>>> http://www.disy.cse.unsw.edu.au/lxr/source/fs/cifs/?v=linux-2.6.32
>>>>
>>>> One funny thing is that there should be a pseudo-file called
>>>> /proc/fs/cifs/PacketSigningEnabled but it does not exist, even on much newer
>>>> kernels it does not exist.
>>>>
>>>>
>>>> Has anyone been able to overcome this problem?
>>>>
>>>> Thanks
>>>> Vini
>>>> --
>>>> To unsubscribe from this list go to the following URL and read the
>>>> instructions:  https://lists.samba.org/mailman/options/samba
>>>>
>>>
>>> You probably need this patch installed on the Windows 2008 server
>>>  http://support.microsoft.com/kb/957441/en-us
>>
>> I have tried this and it did not work either, once I apply it the login
>> fails with "NT_STATUS_LOGON_FAILURE"
>>
> 
> A wireshark trace would be useful.  But if you can use latest cifs code
> from 3.1 kernel on the mainline, that has a NTLMv2 fix, which might
> fix this problem.
> You can try either sec=ntlmssp or sec=ntlmsspi (If signing is enabled
> on the server) mount option and see that helps.

Unfortunately I cannot use the latest kernel, the amount of work to
upgrade it wouldn't be justifiable.

Do you want me to use anything special in the mount command when
capturing the traffic?

--
Vini
