From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs: ls of mount point gives input/output error (probably
 related to CIFS: getdents() broken for large dirs)
Date: Fri, 30 Dec 2011 16:18:13 -0600
Message-ID: <CADT32e+KQGeZn9h7pZnMzzXu=iqWNJZ5KinbZx5WS1kEpAMj-Q@mail.gmail.com>
References: <4EFBAF99.3010208@gmail.com>
	<20111228210420.2a422d11@corrin.poochiereds.net>
	<4EFC413A.80302@gmail.com>
	<20111229083930.77fafba8@tlielax.poochiereds.net>
	<4EFC7124.3060900@gmail.com>
	<4EFD7EBB.2060708@gmail.com>
	<20111230081120.3f7710f1@tlielax.poochiereds.net>
	<4EFDFC4E.30102@gmail.com>
	<4EFE3130.8030500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantinos Skarlatos <k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EFE3130.8030500-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Dec 30, 2011 at 3:46 PM, Konstantinos Skarlatos
<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On 30/12/2011 8:00 =EC=EC, Konstantinos Skarlatos wrote:
>>
>> On 30/12/2011 3:11 =EC=EC, Jeff Layton wrote:
>>>
>>> On Fri, 30 Dec 2011 11:04:59 +0200
>>> Konstantinos Skarlatos<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =A0wrote:
>>>
>>>> On 29/12/2011 3:54 =EC=EC, Konstantinos Skarlatos wrote:
>>>>>
>>>>> On =D0=DD=EC=F0=F4=E7, 29 =C4=E5=EA=DD=EC=E2=F1=E9=EF=F2 2011 3:3=
9:30 =EC=EC, Jeff Layton wrote:
>>>>>>
>>>>>> On Thu, 29 Dec 2011 12:30:18 +0200
>>>>>> Konstantinos Skarlatos<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =A0 wrote:
>>>>>>
>>>>>>> On 29/12/2011 4:04 =F0=EC, Jeff Layton wrote:
>>>>>>>>
>>>>>>>> On Thu, 29 Dec 2011 02:08:57 +0200
>>>>>>>> Konstantinos Skarlatos<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =A0 =A0wrote:
>>>>>>>>
>>>>>>>>> I mount via cifs a windows XP share, df gives me correct size=
s,
>>>>>>>>> but when
>>>>>>>>> I ls the mount point i get input/output error.
>>>>>>>>> strace: http://pastebin.com/WXf8M1nu
>>>>>>>>>
>>>>>>>>> mount --verbose -t cifs -o username=3Dadministrator,password=3D=
blahblah
>>>>>>>>> //192.168.0.11/jobs /mnt/backups/montaz/jobs
>>>>>>>>> mount.cifs kernel mount options:
>>>>>>>>>
>>>>>>>>> ip=3D192.168.0.11,unc=3D\\192.168.0.11\jobs,,ver=3D1,user=3Da=
dministrator,pass=3D********
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> df
>>>>>>>>> //192.168.0.11/jobs =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 114464
>>>>>>>>> 105196 =A0 =A0 =A09268 =A092% /mnt/backups/montaz/jobs
>>>>>>>>>
>>>>>>>>> ls /mnt/backups/montaz/jobs/
>>>>>>>>> ls: reading directory /mnt/backups/montaz/jobs/: Input/output=
 error
>>>>>>>>> total 0
>>>>>>>>>
>>>>>>>>> the fun thing is that i can cd to a lower level directory, an=
d ls
>>>>>>>>> works
>>>>>>>>> fine there! only the mount point has the problem
>>>>>>>>>
>>>>>>>>> ls /mnt/backups/montaz/jobs/test
>>>>>>>>> total 44K
>>>>>>>>> drwxr-xr-x 1 root root =A0 =A00 Apr 30 =A02010 blah blah/
>>>>>>>>> ......
>>>>>>>>>
>>>>>>>>> kernel version 3.2rc7
>>>>>>>>>
>>>>>>>>> this seems to be related to :
>>>>>>>>> https://lkml.org/lkml/2011/8/1/427
>>>>>>>>> Re: [3.0.0+][Regression][Bisected] CIFS: getdents() broken fo=
r
>>>>>>>>> large dirs
>>>>>>>>>
>>>>>>>> Hmmm, maybe. What makes you think that it's related? What sort=
 of
>>>>>>>> server are you seeing this against?
>>>>>>>
>>>>>>> Windows XP service pack 2 (greek)
>>>>>>
>>>>>>
>>>>>> How many files are in the directory?
>>>>>>
>>>>> 140 folders and 20 files
>>>>>
>>>> Attached is a tcp dump of my session.
>>>
>>> I tried reproducing this here, but wasn't able to. Testing against =
my
>>> xp box worked fine.
>>>
>>> Most likely, the FIND_FILE responses are falling afoul of the code =
in
>>> coalesce_t2 or check2ndT2. Unfortunately that code is pretty
>>> complicated and I'm not certain what the problem actually is...
>>>
>>> One thing that's interesting is that the total data being sent in t=
he
>>> request is rather large (16336 bytes). I think that's legit, but ma=
ybe
>>> it's exceeding the end of the buffer once we try to coalesce it.
>>>
>>> Would it be possible to get the cFYI output from this test?
>>
>> I did not get a cFYI output from that test, but i redid a mount-ls-u=
mount
>> and am attaching the tcpdump
>> Also here http://pastebin.com/J20uC6kU you can find the cifsFYI and =
the
>> contents of /proc/fs/cifs/DebugData form the same test
>>>
>>>
>>> Is this a regression? Did it work with earlier kernels and only
>>> recently start failing?
>>>
>> I do not know, and i am a bit afraid to downgrade this machine below=
 3.0
>> due to some changes arch linux has introduced recently. I can always=
 set up
>> a few virtual machines though, and i can even request permission fro=
m my
>> company to give you shell access if you like. Which kernel versions =
would
>> you like me to test?
>
> I just tested =A03.1.5-1-ARCH on a virtual machine and it works, so i=
t is
> probably a regression... On the same virtual machine 3.2-rc7 produces
> input/output error. The virtual machine is a fresh install of arch li=
nux.
> here is the relevant pastebin http://pastebin.com/BwX2DqJC
> and attached is the tcpdump
> As a am a noob to all this, what should I do next in order to help yo=
u?
> maybe compile a 3.1 kernel from official sources to make sure no patc=
hes
> from arch linux interfere?
>

It is the same request from the cifs client in both the successful and
unsuccessful cases. trans2, findfirst2, infolevel of 261 and search cou=
nt
of 150.
So nothing has changed from what is emanating from cifs client.

In the error case, Windows XP responds with search count of 142 whereas
in successful case, Windows XP responds with search count of significan=
tly
less number, e.g. 36.

Are files/directories in  jobs  directory less now i.e. has anything ch=
anged
in this directory on the server 192.168.0.11 i.e. have files been delet=
ed,
directories removed etc. since the failure was noticed the very first t=
ime?
