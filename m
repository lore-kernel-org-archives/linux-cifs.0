From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/15] cifs: eliminate oflags option from
 cifs_new_fileinfo
Date: Mon, 11 Oct 2010 13:17:07 -0400
Message-ID: <20101011131707.646b8532@corrin.poochiereds.net>
References: <1286559072-29032-1-git-send-email-jlayton@redhat.com>
	<1286559072-29032-5-git-send-email-jlayton@redhat.com>
	<4CB2A392.9030400@suse.de>
	<20101011071322.3a6e090c@corrin.poochiereds.net>
	<AANLkTik4=achQnm=8XN+GWWKFL8QOddz4xVVaBs4X3sX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik4=achQnm=8XN+GWWKFL8QOddz4xVVaBs4X3sX-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 11 Oct 2010 12:04:09 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> find readable file is a common operation and the number of open files
> can be huge (thousands)
> 

I don't think so. It gets called from:

    get_cifs_acl
    set_cifs_acl

...and those are only used when the cifsacl mount option is used, which
no one in their right mind does.

Opening the same inode thousands of times is a pretty atypical
workload. Even if it isn't though, we still return as soon as we find
the first usable open file.

But lets assume worst case -- we have some application that opens the
same inode thousands of times and none of them are usable. I'd still
argue that walking the entire list is a trivial amount of cpu time.

Keeping a list ordered like this is fragile and easily broken. I think
we shouldn't rely on it here.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
