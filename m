From: Franck Eyraud <franck+linux-cifs-ici3nDnK79kZQKRGMNo+Zg@public.gmane.org>
Subject: Re: DFS referrals support ?
Date: Sat, 13 Dec 2014 10:35:40 +0100
Message-ID: <548C086C.8050102@nospam.yrnm.net>
References: <548AD6D5.7080901@nospam.yrnm.net> <dda8f4838ed40871acc3092c5440d396.squirrel@mail.balsover.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <dda8f4838ed40871acc3092c5440d396.squirrel-vQd1aa0lCeAC/Zx7Cl00UAC/G2K4zDHf@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Bob,

Thank you for your answer.
Yes, upgrading the kernel can be an option for us, I just wanted to be=20
sure it was worth trying.

I could not find back the bug you mention, to understand how old it is=20
and if it is supposed to be inserted in the kernels we use.
However, I'm not sure this connection issue between two servers is our=20
problem since :
1/ we get the problem even when a DFS links goes to the same IP as the=20
mounted share
2/ we do not get problem when fetching a DFS link to the top level of a=
=20
share which is on a different IP (i.e mounting another filer works well=
)

I'll try anyway to upgrade the kernel and test, since you confirmed tha=
t=20
this is supposed to work.

Have a nice week-end,

=46ranck

Le 12/12/2014 20:50, Bob Balsover a =E9crit :
> Hello Franck,
>
> Yes, DFS is fully supported on the current kernels, but there were so=
me
> problems on earlier kernels. I can't be certain from the information =
that
> you may be running into the remote namespace bug where the final targ=
et is
> not located on the domain controller or the server that you are initi=
ally
> pointed at and the kernel tried to use the existing network connectio=
n to
> communicate with the new machine; you may need to upgrade your kernel=
=2E 3.2
> is not current.  I have personally patched an older 2.6 kernel to wor=
k
> with remote namespaces because management was not in favor of upgradi=
ng
> our kernel but if you are not familiar with the technical details of =
DFS
> then that is probably not the right path for you so if you can upgrad=
e
> your kernel.
>
> -Bob
>
>> Hi,
>>
>> We are meeting some issues with DFS referrals when using CIFS for li=
nux.
>> I don't know much about technical details on DFS, but before studyin=
g
>> further, I would like to know if this feature is even supposed to be
>> supported by the Linux CIFS client.
>>
>> To explain the situation, we have several shares :
>>
>> \\filer\main(main entry point)
>> \\filer\share1(scattered volumes with data)
>> \\filer\share2
>>
>> if \\filer\main\share1points to \\filer\share1(top level) we manage =
to
>> access the share1 content correctly (so DFS mechanism seems to work)
>>
>> but if \\filer\main\some\directory\remote\locationpoints to
>> \\filer\share2\dir1\dir2\inside\locationhere we get stuck.
>>
>> The client can have the following behaviours, more or less with no
>> apparent logic up to now :
>>      * "Object is remote" error
>>      * "No such file or directory" error
>>      * sometimes locked in infinite loop (with the older versions, s=
ee
>> below)
>>      * accesses it, but lists the content of \\filer\share2(top  lev=
el of
>> the share) not the content of \\filer\share2\dir1\dir2\inside\locati=
onso
>> we loose part of the link's path
>>
>> With Windows 7 clients, the expected behaviour occurs correctly.
>>
>> We use up-to-date debian 6.0.10 & 7.6, and CentOS 6.5 (i.e kernels
>> 2.6.32 & 3.2.x) with stock cifs-utils package (2:4.5-2, 2:5.5-1) and=
 the
>> CIFS server is NetApp OnTap 8, with the widelink feature (translatio=
n of
>> linux symlinks)
>>
>> If this should be supported, can you provide information of the
>> parameters to set correctly, or if we have to compile a newer versio=
n,
>> which one ?
>>
>> Thank you,
>>
>> Franck
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
