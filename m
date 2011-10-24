From: sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: Re: cifs and win2k8
Date: Mon, 24 Oct 2011 09:35:35 +0200
Message-ID: <20111024073534.GB7086@cobija.connexer.com>
References: <CAKywueSZzVmXvzB+PhTyxitrKTWL-o=4qqhRqcdzw=wfaj_wtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Terrence Shipclark <terrence.shipclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKywueSZzVmXvzB+PhTyxitrKTWL-o=4qqhRqcdzw=wfaj_wtw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <20111023065534.566a0aad-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Jeff, Pavel,

On Sun, Oct 23, 2011 at 06:55:34AM -0400, Jeff Layton wrote:
> 3.0 got a patchset to allow superblocks to be shared, but that
> regressed the above use case (mounting a directory that you have access
> to but not the stuff below it).

I also seem to recall there being a problem with the request on the target
directory (existing behavior, not a regression), that it used the SMB
QueryFileAllInfo or whatever it's called, instead of just QueryFileInfo,
which is the motivation for needing the "read file attributes" permission.

My memory is a bit hazy here, but i have a vague recollection of looking
at smbclient using the same credentials only doing a QueryFileInfo and
succeeding.

On Sun, Oct 23, 2011 at 11:10:01PM +0400, Pavel Shilovsky wrote:
> Also, if you are interested, I can send you the right version of the
> patch I've already posted.

Please do :)  I can't promise that I have any time to look at it but
it would be good to have regardless.


	sean
