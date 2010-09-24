From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Zero size and zero blocks mountpoint.
Date: Fri, 24 Sep 2010 13:08:25 -0500
Message-ID: <AANLkTinTNE+TJXfzP=4SzTXMMWbkb7hJ8OmQq6MBGYhF@mail.gmail.com>
References: <AANLkTinLwfXhcsAOPEK8reNRyWeyQnzGKm7uQOpYhM_5@mail.gmail.com>
	<20100924073515.7b441fa3@corrin.poochiereds.net>
	<AANLkTim5dVdQuihXizVSey7VmRZOEKDh9STqKzxy1Vv2@mail.gmail.com>
	<20100924140210.719a8f46@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Perez <quimicefa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100924140210.719a8f46-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks like an Apache bug if they rely on the value of st_size for
directories.  See
http://www.opengroup.org/onlinepubs/000095399/basedefs/sys/stat.h.html

"For regular files, the file size in bytes. For symbolic links, the
length in bytes of the pathname contained in the symbolic link." ...
"For other file types, the use of this field is unspecified."

I don't really mind setting it to a minimum.  What does Windows return
as allocation size on directories?

On Fri, Sep 24, 2010 at 1:02 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Fri, 24 Sep 2010 19:44:30 +0200
> Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> 2010/9/24 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>>
>> >> how can I fix the directory-size that apache is receiving?
>> >>
>> >
>> > Honestly, that sounds like an apache bug. You may want to report t=
hat
>> > to them.
>> >
>> > I asked Stef this question question and didn't get an answer howev=
er:
>> >
>> > Does POSIX offer any guidance about what the size of a directory s=
hould
>> > represent?
>>
>> I'm happy to see this question is again an issue.
>>
>> I do not know about POSIX, but my common sense says that a directory=
,
>> even it is a
>> network directory, never has zero size.
>>
>> As you mention, it's the space reserved for the directoryobject.
>>
>
> That's not a given. Maybe the directories are generated on the fly an=
d
> have no persistent storage (even in memory)?
>
> How about /proc? Most directories there (and many of the pseudofiles)
> also have a zero size. Obviously there's no space reserved for them -=
-
> their contents are often generated on an as-needed basis.
>
>> With a network fs (and every virtual fs) the link with the object on
>> the harddrive isn't there,
>> but a directory takes always some memory! In C there would be an ent=
ry
>> object allocated, I do not have to explain that. The size will
>> probably will be much less than the 4Kb with Ext2/3/4,
>> but my point is it is never zero.
>>
>
> AFAICT, the fact that it's not zero on those filesystems is an
> implementation detail. The size for directories in Linux CIFS *is*
> zero. We generate or match dentries on the fly based on
> FIND_FIRST/FIND_NEXT responses and then discard the response data.
> There are no pagecache pages attached to CIFS directory inodes, so a =
0
> size for directory inodes is actually correct by your definition.
>
> Again, I'll be happy to entertain patches to change this (and even he=
lp
> write them), but we need more information about what the correct
> behavior is.
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
