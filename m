From: Daniel Taualii <dtaualii-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mount.cifs hangs when connecting
Date: Thu, 18 Apr 2013 10:21:40 -0600
Message-ID: <CAJV-E0pggon=o_i47Bcy+G97VeLpgwq7uNBU_Rs0LF=HB=s-sg@mail.gmail.com>
References: <CAJV-E0rWpTK08u3bFszkEHL69qEm0noh=LLmUmo_kY5aTxyORw@mail.gmail.com>
	<1366296016.6759.2.camel@localhost>
	<CAJV-E0qB3u4pcLf-zG45cCchonRMi30_Skn-XwC_ZLctzoBW4Q@mail.gmail.com>
	<1366299506.6759.5.camel@localhost>
	<CAH2r5muOTECmyi9DemPfhFLcKXwbP-pWxYtUuwaJzqU8XAtgGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muOTECmyi9DemPfhFLcKXwbP-pWxYtUuwaJzqU8XAtgGw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I must be doing something wrong:

root@daniel:tmp# gdb /lib/modules/3.2.0-40-generic/kernel/fs/cifs/cifs.ko
GNU gdb (Ubuntu/Linaro 7.4-2012.04-0ubuntu2.1) 7.4-2012.04
Copyright (C) 2012 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
For bug reporting instructions, please see:
<http://bugs.launchpad.net/gdb-linaro/>...
Reading symbols from
/lib/modules/3.2.0-40-generic/kernel/fs/cifs/cifs.ko...(no debugging
symbols found)...done.
(gdb) list *(crypto_larval_kill+0x2b)
No symbol table is loaded.  Use the "file" command.

I don't know which crypto file to look in

others are having this problem:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1114673


On Thu, Apr 18, 2013 at 9:50 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> If 110 is ETIMEDOUT, cifs isn't likely to have returned this directly
> (although on SMB2 mounts it could be mapped) so problems with build of
> the crypto libraries seems more likely as you suggested.
>
> On Thu, Apr 18, 2013 at 10:38 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> On Thu, 2013-04-18 at 09:14 -0600, Daniel Taualii wrote:
>>> http://pastebin.com/nW1utsYB
>>
>> From the pastebin,
>>
>> [  156.124070] CIFS VFS: could not setup hash structures rc -110
>> [  156.124095] BUG: unable to handle kernel NULL pointer dereference at
>> 0000000000000008
>> [  156.124098] IP: [<ffffffff812deb2b>] crypto_larval_kill+0x2b/0x90
>> [  156.124104] PGD 226547067 PUD 22669f067 PMD 0
>> [  156.124108] Oops: 0002 [#1] SMP
>> [  156.124110] CPU 2
>> [  156.124111] Modules linked in: vmnet(O) vsock(O) vmci(O) vmmon(O)
>> ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE
>>
>> You seem to have had an Oops.
>> The message "CIFS VFS: could not setup hash structures rc -110" suggests
>> that there was a problem enabling the crypto structures which are used
>> for the hashing of the passwords and signing of packets.
>>
>> Can you please provide the entire Oops message along with a few lines
>> which preceed it since it should contain the reason why we were not able
>> to allocate the structure.
>>
>> Sachin Prabhu
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Thanks,
>
> Steve
