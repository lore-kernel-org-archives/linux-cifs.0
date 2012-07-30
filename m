From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: locking around modifications to i_nlink
Date: Sun, 29 Jul 2012 23:41:49 -0500
Message-ID: <CAH2r5muLTTUYq5KWqyh54-090TSZZqcyyE8K65rhp4TiCLaDHw@mail.gmail.com>
References: <CAH2r5muYbJrPYXtnAikVt1Sf_O7bdGsH7qLs=vjJ_EALXJDeQg@mail.gmail.com>
	<20120727135745.75a95171@tlielax.poochiereds.net>
	<87B676B3-14E0-4BB9-AA3C-01A97DBA9F90@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87B676B3-14E0-4BB9-AA3C-01A97DBA9F90-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Jul 29, 2012 at 2:40 AM,  <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On 27.07.2012, at 21:57, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On Fri, 27 Jul 2012 11:48:39 -0500
>> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> Presumably to address the cifs equivalent of NFS bug (drop_nlink warning):
>>>
>>> https://bugzilla.redhat.com/show_bug.cgi?id=822703
>>>
>>> your patch which wraps drop_nlink in i_lock spinlock (as Jeff noted
>>> addresses only part of the problem)
>>> http://git.altlinux.org/people/piastry/public/cifs-2.6.git?p=cifs-2.6.git;a=patch;h=df2d6b1fbf2401c5ee04f2ac143ea0954e3a87a6
>>>
>>> shouldn't it also wrap the three places in fs/cifs/inode.c which do set_nlink?
>>>
>>
>> It might not hurt to serialize all inode attribute updates under the
>> i_lock. If two updates are racing and the CPU ends up reording things,
>> you could end up with an inode that has a mix of attrs returned by
>> calls. The NFS client did this quite some time ago...
>>
>> --
>> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> Ok. I agree with your points. Since I am on vacations now I suggest to drop this patch from the series - I will respin it further. So, let's not stop on this one.

It created a series of merge conflicts to drop this, it may be easier
for me to do something similar to what Jeff suggested in a followon
patch on top of it.

-- 
Thanks,

Steve
