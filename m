From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: broken mandatory locking behavior
Date: Tue, 4 Oct 2011 06:54:51 -0400
Message-ID: <20111004065451.41bc3d2f@tlielax.poochiereds.net>
References: <CAKywueSgXNhmoA7V82U5Y0=N+DQWysekAwDdsiLMPt6L0OV55Q@mail.gmail.com>
	<20111001083636.247525dc@tlielax.poochiereds.net>
	<CAKywueTN=QTBA+tqT79ObfXYmKmA4Rcx9N-XBDoJCURk0JPu+g@mail.gmail.com>
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
In-Reply-To: <CAKywueTN=QTBA+tqT79ObfXYmKmA4Rcx9N-XBDoJCURk0JPu+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 4 Oct 2011 13:42:24 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2011/10/1 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > I'm not sure I understand what you're saying here. IIUC, windows does
> > not allow the merging of lock ranges.
> 
> Yes, in CIFS we allow to unlock all locks that appears in unlock
> region for mandatory locks (by unlocking each one in an order), but
> Windows doesn't.
> 
> >
> > While I'd agree that the situation with locking is far from ideal, I'm
> > not sure that the above really adequately describes the situation...
> >
> > With cifs.ko, our goal is generally do attempt to map POSIX behavior on
> > top of what the CIFS/SMB protocol allows. Locking is one of those
> > unfortunate places where this mapping really falls short.
> >
> > Windows locks are always mandatory -- full stop. POSIX locks are
> > usually advisory (it is possible to do mandatory locking too, but
> > applications rarely do). POSIX allows the merging of lock ranges.
> > Windows does not. There are other differences too...
> >
> > Now, most of our users don't care about the intricacies of what the
> > protocol allows. They just want their applications to work. So, we
> > attempt to accomodate that by mapping POSIX advisory locking on top of
> > windows locks. It's imperfect, but we do the best we can.
> >
> > Your email above is rather vague -- I get that you want to change
> > *something*, but I'm not sure specifically what it is. Perhaps you can
> > clarify? What changes will users see with your proposal?
> 
> Ok, sorry for wasn't clear. I suggest to follow Windows semantic
> fluently for Windows locks - to unlock exactly the lock (one lock)
> that is requested and no others. So, the end users will need to unlock
> every lock they set before. On close, Windows remove locks itself -
> so, we don't need to unlock them explicitly.
> 

The VFS calls down to the filesystem to unlock all of the locks prior
to ->release. How do you propose to tell the difference?

All cifs.ko will see is an unlock from the VFS -- it has no way to know
whether it's a "normal" unlock or an unlock that's occurring due to a
close() syscall (and therefore can be skipped).

IOW, doing what you propose here will require VFS-level changes.

> As we can't follow POSIX semantic Windows locks fluently, I don't
> think we need to support it partly. So, as the results, we end up with
> two opposite mode for brlocks: Windows and POSIX. If someone needs
> such sort mixing as we have now, we can add extra mount option for
> this further (or vice versa - a mount option for the new mode).
> 
> Thoughts?
> 

I think this is tantamount to insisting that applications be specially
written for cifs.ko if they want to do locking.

The larger goal for cifs.ko (as I see it) is to allow applications to
mostly run unchanged on top of windows servers. Naturally, this is
impossible since windows doesn't follow POSIX semantics, so the best we
can do is closely approximate it.

There's certainly room for improvement here, but what you're proposing
sounds like a step backward from that goal. It will break a lot of
existing applications that run successfully on top of cifs.ko today.

I'm also not sure I understand the benefit here either. What do you
think that such a change would gain us?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
