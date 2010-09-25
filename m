From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: cifs_flush should wait for writeback to complete
 before proceeding
Date: Sat, 25 Sep 2010 00:31:41 -0500
Message-ID: <AANLkTim+2Jrn1VWpDnW+WGWd1yL+oYSUR8KE1q5WgR2d@mail.gmail.com>
References: <1285333153-9113-1-git-send-email-jlayton@redhat.com>
	<AANLkTimdoOPyAmhWw0kTtnZan6+gudJZn=vgqTNpEL+A@mail.gmail.com>
	<20100924141137.4cb03197@tlielax.poochiereds.net>
	<20100925042330.GA11930@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100925042330.GA11930-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Sep 24, 2010 at 11:23 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>=
 wrote:
> On Fri, Sep 24, 2010 at 02:11:37PM -0400, Jeff Layton wrote:
>> On Fri, 24 Sep 2010 12:58:55 -0500
>> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> > We need to see the performance impact. =A0As you say cifs_writepag=
es is
>> > synchronous so we should be ok without it. =A0Any test results
>> > before/after?
>> >
>>
>> No, I haven't tested this for performance. It is a correctness issue
>> though. We absolutely can't put the last reference to the last open
>> filehandle without flushing all of the data first.
>>
>> My expectation here though is that this may help performance in some
>> cases since this patch also has it skip the flush on files open
>> read-only.
>
> ->flush is called on every close call, ->release on the last close fo=
r a
> given file pointer. =A0Maybe you want a filemap_flush in ->flush and
> filemap_write_and_wait in ->release?

seems reasonable



--=20
Thanks,

Steve
