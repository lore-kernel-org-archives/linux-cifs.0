From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: broken mandatory locking behavior
Date: Sat, 1 Oct 2011 08:36:36 -0400
Message-ID: <20111001083636.247525dc@tlielax.poochiereds.net>
References: <CAKywueSgXNhmoA7V82U5Y0=N+DQWysekAwDdsiLMPt6L0OV55Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueSgXNhmoA7V82U5Y0=N+DQWysekAwDdsiLMPt6L0OV55Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 25 Sep 2011 15:39:34 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi all!
> 
> Now I have been working on lock cache capability for cifs module and
> simplification of lock code. So, I faced with a such an interesting
> place - mandatory style unlock code.
> 
> The problem is that mandatory semantic doesn't allow to specify a
> range and remove all locks from there. But cifs module allows it. The
> reason why it is so can be that cifs module tries to follow posix
> semantic for mandatory locks. I think it's not what we want at all.
> 
> We have two lock mode for cifs module: posix and mandatory. And as for
> me, we should follow posix semantic for posix locks and mandatory for
> mandatory locks. If we mix these two semantic for mandatory lock mode,
> we reach nothing: no posix (because mandatory locks doesn't allow to
> perform io ops on the locked region by other processes) and no
> mandatory (because we can setup unlock from 0 to infinity and remove
> all locks at once).
> 

I'm not sure I understand what you're saying here. IIUC, windows does
not allow the merging of lock ranges. 

> The another problem is that this 'broken' code lives on kernel for a
> long time. So, I suggest to discuss it now - while I am here I can
> include this fix into my patchset as well.
> 

While I'd agree that the situation with locking is far from ideal, I'm
not sure that the above really adequately describes the situation...

With cifs.ko, our goal is generally do attempt to map POSIX behavior on
top of what the CIFS/SMB protocol allows. Locking is one of those
unfortunate places where this mapping really falls short.

Windows locks are always mandatory -- full stop. POSIX locks are
usually advisory (it is possible to do mandatory locking too, but
applications rarely do). POSIX allows the merging of lock ranges.
Windows does not. There are other differences too...

Now, most of our users don't care about the intricacies of what the
protocol allows. They just want their applications to work. So, we
attempt to accomodate that by mapping POSIX advisory locking on top of
windows locks. It's imperfect, but we do the best we can.

Your email above is rather vague -- I get that you want to change
*something*, but I'm not sure specifically what it is. Perhaps you can
clarify? What changes will users see with your proposal?

We haven't discussed locking on the list in a while -- the last time
was here:

http://lists.samba.org/archive/linux-cifs-client/2007-July/002088.html
http://lists.samba.org/archive/linux-cifs-client/2007-August/002167.html

I'd make sure what you're proposing jives with the limitations that
Jeremy outlined. 
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
