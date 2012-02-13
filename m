From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix mkdir/rmdir bug for the non-POSIX case
Date: Mon, 13 Feb 2012 10:00:05 -0600
Message-ID: <CAH2r5msQm=3EAqBmjHqWVHP2Gu_X8UMhwcjfC8agqvvc1boEsg@mail.gmail.com>
References: <1328810892-21925-1-git-send-email-piastry@etersoft.ru>
	<20120210132216.03badf59@tlielax.poochiereds.net>
	<4F38BB30.9030107@suse.com>
	<20120213083544.486aa192@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120213083544.486aa192-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Feb 13, 2012 at 7:35 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Mon, 13 Feb 2012 12:56:40 +0530
> Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
>
>> On 02/10/2012 11:52 PM, Jeff Layton wrote:
>> > On Thu, =A09 Feb 2012 21:08:12 +0300
>> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>> >
>> >> Currently we do inc_nlink/drop_nlink for a parent directory for e=
very
>> >> mkdir and rmdir calls. That's wrong when POSIX extensions are dis=
abled
>> >> because in this case a server doesn't do the same things and retu=
rns
>> >> the old value on the next QueryInfo request. As the result, we up=
date
>> >> our value with the server one and then decrement it on every rmdi=
r
>> >> call - go to negative nlink values.
>> >>
>> >> Fix this by doing inc_nlink/drop_nlink for parent directory in mk=
dir
>> >> and rmdir in POSIX case only. Also add cERROR when nlink value <=3D=
 2
>> >> and we still try to decrement it (possible broken servers).
>> >>
>> >
>> > Rather than doing that, I think it would be better not to do the
>> > inc/dec_nlink in either case and instead to set cifsi->time on the
>> > parent to 0 for both cases.
>> >
>> > That should force it to have the directory attributes refetched at=
 the
>> > next opportunity. Since we're not doing that now, we're likely mis=
sing
>> > out on stuff like directory mtime changes as well.
>> >
>>
>> Hmm.. don't we have to do both? Keep the nlink value sane and force
>> refetching attrs. Wondering if we don't update nlink what will happe=
n in
>> cases
>>
>> =A0 =A0(a) when mkdir/rmdir is run in a tight loop
>> =A0 =A0(b) when a dir is moved from one to another within the cifs m=
ount
>>
>
> I don't think so -- we either need to fake i_nlink and ignore the val=
ue
> from the server, or treat the server as authoritative.
>
> Trying to monkey with the nlink value on the client and overwriting i=
t
> with the value from the server is always going to be racy. I think th=
e
> only time it really matters is if you're using generic_drop_inode,
> which we do when CIFS_MOUNT_SERVER_INUM is set.
>
> That said, the values we get out of some servers for i_nlink are
> non-sensical. Perhaps we'd be best off to just fake the i_nlink value
> across the board. We have had people in the past complain that i_nlin=
k
> is always 0 in some cases.

=46or the non-Unix case, you may be right.  We wouldn't want to
add a big performance penalty to do QueryPathInfo more often
for a value which the server may report wrong anyway.


--=20
Thanks,

Steve
