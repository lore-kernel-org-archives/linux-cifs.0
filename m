From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: CIFS mount twice
Date: Tue, 15 Nov 2011 21:39:20 +0530
Message-ID: <4EC28EB0.6040100@suse.com>
References: <20111114172138.Horde.60sJZ1wlEB5OwQDKknIWLdA@mail.linuz.in> <loom.20111115T070545-916@post.gmane.org> <20111115054504.550248e0@tlielax.poochiereds.net> <20111115175612.Horde.N_P5LFwlEB5Owlpkz20HVLA@mail.linuz.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aravind M D <aravind-f8yKZFm1E5Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111115175612.Horde.N_P5LFwlEB5Owlpkz20HVLA-i9wRM+HIrml8vCsnxnN6bQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/15/2011 05:56 PM, Aravind M D wrote:
> Quoting Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> 
>> On Tue, 15 Nov 2011 06:07:39 +0000 (UTC)
>> Aravind M D <aravind-f8yKZFm1E5Q@public.gmane.org> wrote:
>>
>>> Aravind M D <aravind@...> writes:
>>>
>>>
>>> >
>>> > Hi,
>>> >
>>> >   I have some cifs mount points configured on my /etc/fstab.
>>> >
>>> >   When i am doing mount -a command mount points are mouting again.
>>> >
>>> >   If mount command is issued mount point is showing twice.
>>> >
>>> >   If i use mount through command line also i am facing the same issue.
>>> >
>>> >   Please help me.
>>> >
>>> >   Rgds,
>>> >   Aravind M D
>>> >
>>>
>>> Can someone help me with the below issue.
>>>
>>> Thanks in Advance
>>>
>>
>> Not with the description you've given as there's just hardly anything
>> there in the way of details...
>>
>> I set up my fedora rawhide test box with a cifs mount in /etc/fstab and
>> then ran mount -a several times. It was only mounted once.
>>
>> IIUC, it's the job of /bin/mount to only attempt to mount filesystems
>> that have not already been mounted when mount -a is run. If that's not
>> happening on your machine then it sounds like something is broken there.
>>
>> -- 
>> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> 
> Hi Jeff,
> 
> I have SLES 11 SAP systems on which some CIFS FS are configured on
> /etc/fstab.
> 
> ~#cat /etc/fstab
> //oese-sc1-osi01/osiris1       /oese-sc1-osi01/osiris1/
> cifs                  username=user1,password=pass1,uid=200,gid=200
> //oese-sc1-osi02/osiris2       /oese-sc1-osi02/osiris2/
> cifs                  username=user1,password=pass1,uid=200,gid=200
> //oese-sc1-osi99/osiris0       /oese-sc1-osi99/osiris0/
> cifs                  username=user1,password=pass1,uid=200,gid=200
> 
> Already these FS are mounted on my system. When i run mount -a and mount
> command below is the output.
> 
> ~#mount
> 
> //oese-sc1-osi01/osiris1 on /oese-sc1-osi01/osiris1 type cifs (rw,mand)
> //oese-sc1-osi02/osiris2 on /oese-sc1-osi02/osiris2 type cifs (rw,mand)
> //oese-sc1-osi99/osiris0 on /oese-sc1-osi99/osiris0 type cifs (rw,mand)
> //oese-sc1-osi01/osiris1 on /oese-sc1-osi01/osiris1 type cifs (rw,mand)
> //oese-sc1-osi02/osiris2 on /oese-sc1-osi02/osiris2 type cifs (rw,mand)
> //oese-sc1-osi99/osiris0 on /oese-sc1-osi99/osiris0 type cifs (rw,mand)
> 
> Mounts are showing twice.
> 
> I have tested the same on Debian 6 also i have faced same problem. But in
> the debian 6 i tried upgrading the cifs-utils to the latest version.
> 
> Once cifs-utils was upgraded the mount -a will mount partition only once.
> 

Looks like you are hitting problems with older version of cifs-utils.

I ran the "mount -a" tests on openSUSE 11.4 and SLES11 SP1 but I could
reproduce this problem. I don't have a SLES11 setup. I'll see if I could
get one. Some useful information that'll help include

a) version of cifs-utils/cifs-mount
b) version of util-linux
c) mount -a -vvv output


OTOH, if you have a support contract with SUSE/Novell, please open a bug
report on https://bugzilla.novell.com agaist the product and include me
in the Cc.



Thanks
Suresh
