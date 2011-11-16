From: Aravind M D <aravind-f8yKZFm1E5Q@public.gmane.org>
Subject: Re: CIFS mount twice
Date: Wed, 16 Nov 2011 10:49:05 +0530
Message-ID: <20111116104905.Horde.LHPMe1wlEB5Ow0fJqKaxJcA@mail.linuz.in>
References: <20111114172138.Horde.60sJZ1wlEB5OwQDKknIWLdA@mail.linuz.in>
 <loom.20111115T070545-916@post.gmane.org>
 <20111115054504.550248e0@tlielax.poochiereds.net>
 <20111115175612.Horde.N_P5LFwlEB5Owlpkz20HVLA@mail.linuz.in>
 <CAH2r5mtf0cPXAFA6uRBztALbaWsV+K8+wyfwOq4n3zy1zJmZ_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; DelSp=Yes
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtf0cPXAFA6uRBztALbaWsV+K8+wyfwOq4n3zy1zJmZ_g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Quoting Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:

> On Tue, Nov 15, 2011 at 6:26 AM, Aravind M D <aravind-f8yKZFm1E5Q@public.gmane.org> wrote:
>> Once cifs-utils was upgraded the mount -a will mount partition only once.
>>
>> But when i mount the same FS using command line in debian it will  
>> show twice.
>>
>> Why CIFS FS is mounting on already mounted mount points.
>
> I tried a few experiments here, and although I get different errors
> with /sbin/mount.cifs present vs. without, I don't see the problem
> you a describing.   First obvious question ... what version of
> cifs-utils are you using.   Type "/sbin/mount.cifs -V" to
> see if you are using the roughly the same version on all.
>
>
> --
> Thanks,
>
> Steve

Hi Steve,

Please find the details of  cifs-utils i am using.

Debian
------------

root@ser1:~# cat /etc/debian_version
6.0
root@ser1:~# mount.cifs -V
mount.cifs version: 4.5

SLES
------------

ser2:~ # cat /etc/SuSE-release
SUSE Linux Enterprise Server 11 (x86_64)
VERSION = 11
PATCHLEVEL = 1

ser2:~ # mount.cifs -V
mount.cifs version: 1.12-3.4.3-1.17.2-2359-SUSE-CODE11

- Aravind
