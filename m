From: Aravind M D <aravind-f8yKZFm1E5Q@public.gmane.org>
Subject: Re: CIFS mount twice
Date: Tue, 15 Nov 2011 17:56:12 +0530
Message-ID: <20111115175612.Horde.N_P5LFwlEB5Owlpkz20HVLA@mail.linuz.in>
References: <20111114172138.Horde.60sJZ1wlEB5OwQDKknIWLdA@mail.linuz.in>
 <loom.20111115T070545-916@post.gmane.org>
 <20111115054504.550248e0@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; DelSp=Yes
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111115054504.550248e0-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Quoting Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:

> On Tue, 15 Nov 2011 06:07:39 +0000 (UTC)
> Aravind M D <aravind-f8yKZFm1E5Q@public.gmane.org> wrote:
>
>> Aravind M D <aravind@...> writes:
>>
>>
>> >
>> > Hi,
>> >
>> >   I have some cifs mount points configured on my /etc/fstab.
>> >
>> >   When i am doing mount -a command mount points are mouting again.
>> >
>> >   If mount command is issued mount point is showing twice.
>> >
>> >   If i use mount through command line also i am facing the same issue.
>> >
>> >   Please help me.
>> >
>> >   Rgds,
>> >   Aravind M D
>> >
>>
>> Can someone help me with the below issue.
>>
>> Thanks in Advance
>>
>
> Not with the description you've given as there's just hardly anything
> there in the way of details...
>
> I set up my fedora rawhide test box with a cifs mount in /etc/fstab and
> then ran mount -a several times. It was only mounted once.
>
> IIUC, it's the job of /bin/mount to only attempt to mount filesystems
> that have not already been mounted when mount -a is run. If that's not
> happening on your machine then it sounds like something is broken there.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

Hi Jeff,

I have SLES 11 SAP systems on which some CIFS FS are configured on /etc/fstab.

~#cat /etc/fstab
//oese-sc1-osi01/osiris1       /oese-sc1-osi01/osiris1/
cifs                  username=user1,password=pass1,uid=200,gid=200
//oese-sc1-osi02/osiris2       /oese-sc1-osi02/osiris2/
cifs                  username=user1,password=pass1,uid=200,gid=200
//oese-sc1-osi99/osiris0       /oese-sc1-osi99/osiris0/
cifs                  username=user1,password=pass1,uid=200,gid=200

Already these FS are mounted on my system. When i run mount -a and mount
command below is the output.

~#mount

//oese-sc1-osi01/osiris1 on /oese-sc1-osi01/osiris1 type cifs (rw,mand)
//oese-sc1-osi02/osiris2 on /oese-sc1-osi02/osiris2 type cifs (rw,mand)
//oese-sc1-osi99/osiris0 on /oese-sc1-osi99/osiris0 type cifs (rw,mand)
//oese-sc1-osi01/osiris1 on /oese-sc1-osi01/osiris1 type cifs (rw,mand)
//oese-sc1-osi02/osiris2 on /oese-sc1-osi02/osiris2 type cifs (rw,mand)
//oese-sc1-osi99/osiris0 on /oese-sc1-osi99/osiris0 type cifs (rw,mand)

Mounts are showing twice.

I have tested the same on Debian 6 also i have faced same problem. But in
the debian 6 i tried upgrading the cifs-utils to the latest version.

Once cifs-utils was upgraded the mount -a will mount partition only once.

But when i mount the same FS using command line in debian it will show twice.

Why CIFS FS is mounting on already mounted mount points.

-  Aravin
