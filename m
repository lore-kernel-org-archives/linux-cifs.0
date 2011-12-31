From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs: ls of mount point gives input/output error (probably
 related to CIFS: getdents() broken for large dirs)
Date: Fri, 30 Dec 2011 23:43:15 -0600
Message-ID: <CADT32eJ8NgYTOknQd0-=cD=HzH0Q8JHuiMezVH0+PbncL593HA@mail.gmail.com>
References: <4EFBAF99.3010208@gmail.com>
	<20111228210420.2a422d11@corrin.poochiereds.net>
	<4EFC413A.80302@gmail.com>
	<20111229083930.77fafba8@tlielax.poochiereds.net>
	<4EFC7124.3060900@gmail.com>
	<4EFD7EBB.2060708@gmail.com>
	<20111230081120.3f7710f1@tlielax.poochiereds.net>
	<4EFDFC4E.30102@gmail.com>
	<4EFE3130.8030500@gmail.com>
	<4EFE7080.5060302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantinos Skarlatos <k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EFE7080.5060302-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Dec 30, 2011 at 8:16 PM, Konstantinos Skarlatos
<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On 30/12/2011 11:46 =EC=EC, Konstantinos Skarlatos wrote:
>>
>> On 30/12/2011 8:00 =EC=EC, Konstantinos Skarlatos wrote:
>>>
>>> On 30/12/2011 3:11 =EC=EC, Jeff Layton wrote:
>>>>
>>>> On Fri, 30 Dec 2011 11:04:59 +0200
>>>> Konstantinos Skarlatos<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>
>>>>> On 29/12/2011 3:54 =EC=EC, Konstantinos Skarlatos wrote:
>>>>>>
>>>>>> On =D0=DD=EC=F0=F4=E7, 29 =C4=E5=EA=DD=EC=E2=F1=E9=EF=F2 2011 3:=
39:30 =EC=EC, Jeff Layton wrote:
>>>>>>>
>>>>>>> On Thu, 29 Dec 2011 12:30:18 +0200
>>>>>>> Konstantinos Skarlatos<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>>>>
>>>>>>>> On 29/12/2011 4:04 =F0=EC, Jeff Layton wrote:
>>>>>>>>>
>>>>>>>>> On Thu, 29 Dec 2011 02:08:57 +0200
>>>>>>>>> Konstantinos Skarlatos<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>>>>>>
>>>>>>>>>> I mount via cifs a windows XP share, df gives me correct siz=
es,
>>>>>>>>>> but when
>>>>>>>>>> I ls the mount point i get input/output error.
>>>>>>>>>> strace: http://pastebin.com/WXf8M1nu
>>>>>>>>>>
>>>>>>>>>> mount --verbose -t cifs -o
>>>>>>>>>> username=3Dadministrator,password=3Dblahblah
>>>>>>>>>> //192.168.0.11/jobs /mnt/backups/montaz/jobs
>>>>>>>>>> mount.cifs kernel mount options:
>>>>>>>>>>
>>>>>>>>>> ip=3D192.168.0.11,unc=3D\\192.168.0.11\jobs,,ver=3D1,user=3D=
administrator,pass=3D********
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> df
>>>>>>>>>> //192.168.0.11/jobs 114464
>>>>>>>>>> 105196 9268 92% /mnt/backups/montaz/jobs
>>>>>>>>>>
>>>>>>>>>> ls /mnt/backups/montaz/jobs/
>>>>>>>>>> ls: reading directory /mnt/backups/montaz/jobs/: Input/outpu=
t
>>>>>>>>>> error
>>>>>>>>>> total 0
>>>>>>>>>>
>>>>>>>>>> the fun thing is that i can cd to a lower level directory, a=
nd ls
>>>>>>>>>> works
>>>>>>>>>> fine there! only the mount point has the problem
>>>>>>>>>>
>>>>>>>>>> ls /mnt/backups/montaz/jobs/test
>>>>>>>>>> total 44K
>>>>>>>>>> drwxr-xr-x 1 root root 0 Apr 30 2010 blah blah/
>>>>>>>>>> ......
>>>>>>>>>>
>>>>>>>>>> kernel version 3.2rc7
>>>>>>>>>>
>>>>>>>>>> this seems to be related to :
>>>>>>>>>> https://lkml.org/lkml/2011/8/1/427
>>>>>>>>>> Re: [3.0.0+][Regression][Bisected] CIFS: getdents() broken f=
or
>>>>>>>>>> large dirs
>>>>>>>>>>
>>>>>>>>> Hmmm, maybe. What makes you think that it's related? What sor=
t of
>>>>>>>>> server are you seeing this against?
>>>>>>>>
>>>>>>>> Windows XP service pack 2 (greek)
>>>>>>>
>>>>>>>
>>>>>>> How many files are in the directory?
>>>>>>>
>>>>>> 140 folders and 20 files
>>>>>>
>>>>> Attached is a tcp dump of my session.
>>>>
>>>> I tried reproducing this here, but wasn't able to. Testing against=
 my
>>>> xp box worked fine.
>>>>
>>>> Most likely, the FIND_FILE responses are falling afoul of the code=
 in
>>>> coalesce_t2 or check2ndT2. Unfortunately that code is pretty
>>>> complicated and I'm not certain what the problem actually is...
>>>>
>>>> One thing that's interesting is that the total data being sent in =
the
>>>> request is rather large (16336 bytes). I think that's legit, but m=
aybe
>>>> it's exceeding the end of the buffer once we try to coalesce it.
>>>>
>>>> Would it be possible to get the cFYI output from this test?
>>>
>>> I did not get a cFYI output from that test, but i redid a
>>> mount-ls-umount and am attaching the tcpdump
>>> Also here http://pastebin.com/J20uC6kU you can find the cifsFYI and
>>> the contents of /proc/fs/cifs/DebugData form the same test
>>>>
>>>>
>>>> Is this a regression? Did it work with earlier kernels and only
>>>> recently start failing?
>>>>
>>> I do not know, and i am a bit afraid to downgrade this machine belo=
w
>>> 3.0 due to some changes arch linux has introduced recently. I can
>>> always set up a few virtual machines though, and i can even request
>>> permission from my company to give you shell access if you like. Wh=
ich
>>> kernel versions would you like me to test?
>>
>> I just tested 3.1.5-1-ARCH on a virtual machine and it works, so it =
is
>> probably a regression... On the same virtual machine 3.2-rc7 produce=
s
>> input/output error. The virtual machine is a fresh install of arch l=
inux.
>> here is the relevant pastebin http://pastebin.com/BwX2DqJC
>> and attached is the tcpdump
>> As a am a noob to all this, what should I do next in order to help y=
ou?
>> maybe compile a 3.1 kernel from official sources to make sure no pat=
ches
>> from arch linux interfere?
>>
> After some testing, vanilla 3.1.6 does not have this bug and 3.2.0-rc=
1 has
> it.

I suspect 3.2.0-rc1 cifs will work correctly against a Windows 2003 or
Windows 7 or Window 2008 server.
