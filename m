From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: mark CONFIG_CIFS_NFSD_EXPORT as BROKEN
Date: Mon, 23 May 2011 09:02:55 -0500
Message-ID: <BANLkTikBOdYnb5nqf=fM3Lh1EptBmkqwbQ@mail.gmail.com>
References: <1306065324-24604-1-git-send-email-jlayton@redhat.com>
	<20110522115938.GA27941@infradead.org>
	<20110522081707.72cce108@corrin.poochiereds.net>
	<BANLkTim_K__5bqJG5snk+Bb+CW5dB70aQA@mail.gmail.com>
	<20110523071208.5dc935f8@corrin.poochiereds.net>
	<BANLkTikRqxGo3mm7h3w3-JL+Si6ZJYGPZQ@mail.gmail.com>
	<20110523095027.2746e7c0@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110523095027.2746e7c0-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, May 23, 2011 at 8:50 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Mon, 23 May 2011 08:42:39 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Mon, May 23, 2011 at 6:12 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> > On Sun, 22 May 2011 20:12:04 -0500
>> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> On Sun, May 22, 2011 at 7:17 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>=
 wrote:
>> >> > On Sun, 22 May 2011 07:59:38 -0400
>> >> > Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>> >> >
>> >> >> On Sun, May 22, 2011 at 07:55:24AM -0400, Jeff Layton wrote:
>> >> >> > This will never work properly with CIFS, as the protocol has=
 no ability
>> >> >> > whatsoever for looking up files by filehandle. It *might* be=
 possible to
>> >> >> > eventually do this with SMB2, but that remains to be seen.
>>
>> Shirish had done some experiments (and AFAIK has a small patch
>> that fixed NFS export over CIFS which works, with the usual restrict=
ions
>> about having to return ESTALE if the NFS client tries to access
>> an inode which has been flushed from the cache on the server side).
>>
>
> That restriction is not usual for servers, and makes the whole scheme
> unreliable.

It must be reasonably common - as it was one of the motivations for
ESTALE return code, and was a motivation for the explicit "volatile
file handle" type that was introduced in nfs v4 (which makes it easier
for the client to tell when it has to be able to revalidate a file
handle).  I see mention of this in Solaris, Oracle so it is presumably
fairly common.

>> >> For nfs v3 clients that can't handle ESTALE, we are probably
>> >> stuck with having to wait for Samba to implement the flag
>> > Flag?
>>
>> NTCreateX: =A0FILE_OPEN_BY_FILE_ID
>>
>> IIRC Shirish verified that the Windows client will emit this flag, b=
ut their
>> server had not gotten around to implementing it (although Samba coul=
d
>> implement it now that their is an open-by-handle syscall).
>>
>
> Again, that does absolutely nothing for directories which also need t=
o
> be retrievable by filehandle.

Why wouldn't that work?   Samba and Windows both support opening
directories - why wouldn't queryfileinfo work on those handles?


> I think it would be best to remove this code, but if that's
> unacceptable for some reason it should at least be marked BROKEN.

if Shirish's patch can't (or doesn't) make it work I agree that it
should be removed or marked broken - but I have not tested his patch.


--=20
Thanks,

Steve
