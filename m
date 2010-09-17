From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: samba changing mode of files on rename
Date: Fri, 17 Sep 2010 12:28:52 -0500
Message-ID: <AANLkTi=LRTj8V5f+gJwLhj3tgz9KUPSg8jBqPL3GCjn2@mail.gmail.com>
References: <20100917130005.23d0864a@corrin.poochiereds.net>
	<20100917131558.13a00c53@corrin.poochiereds.net>
	<AANLkTikctbnerDjPa8HS0JuB0jGv2ACjtt8AQ97LFVP9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikctbnerDjPa8HS0JuB0jGv2ACjtt8AQ97LFVP9-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Sep 17, 2010 at 12:27 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
>
>
> On Fri, Sep 17, 2010 at 12:15 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wro=
te:
>>
>> On Fri, 17 Sep 2010 13:00:05 -0400
>> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>>
>> > I recently noticed a regression in samba in the last few weeks. He=
re's
>> > a simple way to reproduce it:
>> >
>> > 1) use smbclient to put a file on a samba share
>> > 2) change the mode of the file to something without the owner exec=
ute bit set
>> > 3) rename the file using smbclient
>> >
>> > When you do this, the newly renamed file will magically end up wit=
h the
>> > owner execute bit set. It seems like samba ought not be changing t=
he
>> > mode of files when renaming them so I consider this a regression.
>> >
>> > I've reported the bug in the Fedora BTS, and attached some info th=
ere.
>> > Anyone more familiar with this code willing to have a look?
>> >
>> > =A0 =A0 https://bugzilla.redhat.com/show_bug.cgi?id=3D617771
>> >
>> > I've was able to reproduce it today using the most recent samba ve=
rsion
>> > available in the Fedora repos (3.5.5).
>> >
>> > Thanks,
>>
>> Volker pointed out a workaround on IRC...
>>
>> If I set "map archive =3D no" then this doesn't seem to happen. So, =
I
>> guess something has happened relatively recently to make renames set
>> the archive bit?
>
> Interesting - but I would expect that rename would set the archive bi=
t
> (creates, file modifications also set the bit in Windows). =A0In Wind=
ows
> rename sets the archive bit (although we don't need to track the arch=
ive bit
> for Linux cifs.ko we probably could report it via xattrs for backup
> applications to use - much like Windows backup apps check/clear it).
> See below:
> C:\Users\stevef>echo newfile > new
> C:\Users\stevef>attrib new
> A =A0 =A0 =A0 =A0 =A0 =A0C:\Users\stevef\new
> C:\Users\stevef>attrib -a new
> C:\Users\stevef>rename new newer
> C:\Users\stevef>attrib newer
> A =A0 =A0 =A0 =A0 =A0 =A0C:\Users\stevef\newer
> --
> Thanks,
>
> Steve

Interesting - but I would expect that rename would set the archive bit
(creates, file modifications also set the bit in Windows).  In Windows
rename sets the archive bit (although we don't need to track the archiv=
e bit
for Linux cifs.ko we probably could report it via xattrs for backup
applications to use - much like Windows backup apps check/clear it).

See below:

C:\Users\stevef>echo newfile > new

C:\Users\stevef>attrib new
A            C:\Users\stevef\new

C:\Users\stevef>attrib -a new

C:\Users\stevef>rename new newer

C:\Users\stevef>attrib newer
A            C:\Users\stevef\newer

--
Thanks,

Steve
