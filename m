From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 0/4] cifs: pave way for change to "strictcache" by
 default
Date: Mon, 30 Apr 2012 12:05:17 -0400
Message-ID: <20120430120517.07d76ed1@corrin.poochiereds.net>
References: <1335524179-1671-1-git-send-email-jlayton@redhat.com>
	<20120430072846.69d489aa@corrin.poochiereds.net>
	<CAH2r5msnmF0d_bmctzKtzSQ-+y9VRa2=USDO8kV=QF9KV+J=7g@mail.gmail.com>
	<20120430114547.3c9580c1@corrin.poochiereds.net>
	<CAH2r5mue-u8cDYhsxxHqTTwOyb4_qEok2CLB3N8+9EfK0_JmHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mue-u8cDYhsxxHqTTwOyb4_qEok2CLB3N8+9EfK0_JmHQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 30 Apr 2012 10:50:25 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Apr 30, 2012 at 10:45 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> > On Mon, 30 Apr 2012 10:11:43 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> There is a related question of how deferring writes slightly (e.g. to
> >> buffer a full page or a full smb buffer) could corrupt data?
> >>
> >
> > You're returning from write(2) without actually sending it to the
> > backing store, but a read(2) will go to that backing store. So,
> > applications that expect the results of that write to be visible to
> > other clients (or even on the same client) won't see it.
> 
> well the results of the write MUST be visible to others reading
> on the same client.  In what case would they not be
> (other than perhaps some odd private memory mapping case)
> 
> 

If you're delaying the write, how are you going to satisfy that read?

Where will the results of that write be stored such that the read can
then see it? Typically the answer would be "the pagecache" but you
can't use it in this case.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
