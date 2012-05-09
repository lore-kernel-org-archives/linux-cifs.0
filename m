From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: linux-next workflow question for cifs
Date: Wed, 9 May 2012 13:52:19 -0400
Message-ID: <20120509175219.GA26477@fieldses.org>
References: <CAH2r5mtBK-C0Uc6gVY0Dk+YfbaFE+OfCbM+A_2BmiTVzZMchmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mtBK-C0Uc6gVY0Dk+YfbaFE+OfCbM+A_2BmiTVzZMchmQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, May 09, 2012 at 08:19:05AM -0500, Steve French wrote:
> Trying to figure out the easiest way for the workflow for the new
> cifs-2.6.git linux-next branch for this scenario:
> 
> - push a series of patches to cifs-2.6.git linux-next
> - someone adds an ack to a patch in the middle, or even a coding
> change to a patch in the middle
> - how do I easiest make this change and repush (without constantly
> doing git push --force)

The other way to deal with it is:
	- if there's a coding change, add another patch on top.
	- if an ack or attribution got lost, apologize and try to
	  do better next time.

There are advantages to clean bisectable history, and there are also
advantages to real append-only history:
	- if someone's doing extra work on top of your branch, then
	  rebasing their stuff becomes easier.
	- if someone finds a bug in your branch and fixes it, then you
	  have a record of how that actually happened.

My personal balance is to have one append-only branch that's what gets
pulled into next, and then a different tree with any works in progress
that I can point someone to if necessary.

And I try not to push to the append-only branch until I'm pretty sure
there's been a chance for review, etc.

Not saying that's perfect--there are times when I would've liked to get
a patch some more testing in -next before really committing to it, and
at least one case when someone was annoyed not to be able to improve the
change log on something they submitted.

--b.
