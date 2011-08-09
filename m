From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: regression with prefixpath mounts
Date: Tue, 9 Aug 2011 20:49:57 +0400
Message-ID: <CAKywueSkf+5Sq9=nsfcwe2zohn1Nb_QmWmxaxCueVjEQ054YFw@mail.gmail.com>
References: <20110804102932.4adf33bf@barsoom.rdu.redhat.com>
	<CAKywueQEP72GEWmG3pxC9G0YfNchKWm9=WjCaNZNQSfSUQ0isA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQEP72GEWmG3pxC9G0YfNchKWm9=WjCaNZNQSfSUQ0isA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/8/4 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> 2011/8/4 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> Hi Pavel,
>>
>> We have a bit of a problem...
>>
>> =A0 =A0https://bugzilla.redhat.com/show_bug.cgi?id=3D727834
>>
>> The shared superblock patches seem to have broken the ability to mou=
nt
>> directories that live under other directories to which the mounting
>> user doesn't have permissions.
>>
>> IOW, suppose we have this shared out:
>>
>> =A0 =A0/share/dir1/dir2
>>
>> ...if the permissions on dir1 don't allow the mounting user to acces=
s
>> it, then cifs_get_root will fail. We'll need to come up with a new
>> scheme for handling this that doesn't require access to every compon=
ent
>> of the prefixpath.
>>
>> I'm not sure what the right fix is here...we may need to come up wit=
h a
>> scheme more like NFS does. It will alter the tree when it discovers
>> that a root dir that it previously was working on is actually a subd=
ir
>> of another mount.
>>
>> Thoughts?
>> --
>> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>
> Thanks for the report. I understand the problem, let me think how to
> fix it right.
>
> --
> Best regards,
> Pavel Shilovsky.
>

According to https://bugzilla.redhat.com/show_bug.cgi?id=3D727834, it
seems to me that the problem is fixed. If the situation changes, let
me know, please.

--=20
Best regards,
Pavel Shilovsky.
