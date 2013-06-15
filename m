From: Simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2 06/14] locks: don't walk inode->i_flock list in locks_show
Date: Sat, 15 Jun 2013 11:04:11 -0400
Message-ID: <51BC826B.5060805@samba.org>
References: <1370948948-31784-1-git-send-email-jlayton@redhat.com> <1370948948-31784-7-git-send-email-jlayton@redhat.com> <20130613194545.GC19218@fieldses.org> <20130613162648.176979bc@tlielax.poochiereds.net> <51BB040C.3050101@samba.org> <20130615070535.6367eed9@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, matthew-Ztpu424NOJ8@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130615070535.6367eed9-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 06/15/2013 07:05 AM, Jeff Layton wrote:
> On Fri, 14 Jun 2013 07:52:44 -0400
> Simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
>> On 06/13/2013 04:26 PM, Jeff Layton wrote:
>>> The only real solution I can think of is to put flock locks into the
>>> blocked_list/blocked_hash too, or maybe giving them a simple hlist to
>>> sit on.
>>>
>>> I'll fix that up in the next iteration. It'll probably make flock()
>>> tests run slower, but such is the cost of preserving this procfile...
>> How hard would it be to make the procfile stuff optional ?
>> So that those that need performance can decide to not use it ?
>> Maybe even something that can be disabled at run time ? Not just compile
>> time.
>>
> (re-adding back the cc lists...)
>
> It'd be tricky, especially if you want to do it at runtime. The
> procfile itself is not a problem per-se. The real problem is the
> tracking you have to do in order to eventually present the procfile. So
> a boot-time or compile-time switch might be reasonable, but a runtime
> switch will probably never really be.

Just to be clear, I meant for a switch to turn it off at runtime, I 
understand very well that it would be way too hard to turn on at 
runtime. But killing the perf problem might be desirable on a system you 
cannot just reboot.

> I have a new patchset that I'm testing now though that should address
> Bruce's concerns about iterating over that global list. So far, it
> seems to be at least as fast as the latest patchset I posted.
>
> It makes the (spin)locking a bit more complex, but hopefully I can
> document this well enough that it's not a great concern.
>
> Stay tuned...

Thanks Jeff,
this is very valuable work.

Simo.
