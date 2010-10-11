From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/15] cifs: eliminate oflags option from
 cifs_new_fileinfo
Date: Mon, 11 Oct 2010 14:52:04 -0400
Message-ID: <20101011145204.39fc8930@corrin.poochiereds.net>
References: <1286559072-29032-1-git-send-email-jlayton@redhat.com>
	<1286559072-29032-5-git-send-email-jlayton@redhat.com>
	<4CB2A392.9030400@suse.de>
	<20101011071322.3a6e090c@corrin.poochiereds.net>
	<AANLkTik4=achQnm=8XN+GWWKFL8QOddz4xVVaBs4X3sX@mail.gmail.com>
	<20101011131707.646b8532@corrin.poochiereds.net>
	<AANLkTik6tc0iJwDACT-nctOi2Ui5E31AihWN8-vCM2zo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik6tc0iJwDACT-nctOi2Ui5E31AihWN8-vCM2zo-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 11 Oct 2010 12:27:47 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> You are right - find_writeable_file is the common one, not
> find_readable_file (might make sense to reverse the ordering -
> readonly files at end instead of writeonly files at end - given
> find_readable_file is called less often).   There are cases with a
> file opened many times from different processes that I have seen.
> Not sure why removing the ordering matters much - it is a possible,
> albeit usually slight, performance benefit to keep file handles we are
> most likely to want at the top of the list.
> 

If we were really concerned about performance here, fine-grained
locking would get us much farther toward that goal. I'm concerned about
people breaking the list order, which has obviously been broken for
some time and no one has noticed.

Eventually I want to overhaul all of the find_readable/writable_file
code with a better interface. That will be simpler if I don't have
to deal with unnecessary complexity like the list ordering here.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
