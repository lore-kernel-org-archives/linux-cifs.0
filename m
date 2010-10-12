From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: initial stab at a design document for SMB transport layer
 overhaul
Date: Tue, 12 Oct 2010 14:39:42 -0400
Message-ID: <20101012143942.4370777a@corrin.poochiereds.net>
References: <20101012134317.78a3ecea@corrin.poochiereds.net>
	<AANLkTi=6_WKDH9uz4rCTW+BdWf=g91ygdj2N9JOYTima@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=6_WKDH9uz4rCTW+BdWf=g91ygdj2N9JOYTima-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 12 Oct 2010 22:11:35 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2010/10/12 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> >
> > The code will use a state machine to manage the socket's receive path,
> > and will overload the sk_* functions to handle the socket without
> > needing a dedicated thread for this. When the sk_data_ready callback
> > fires, data will be recevied off the socket in interrupt context until
> > we can get down to the MID in the header. At that point, we'll be able
> > to wake up whatever thread is waiting for the reply to do the rest. If
> 
> Should we read a whole request by state machine and then wake up
> awaiting thread?
> 
> > it's an async request, a workqueue task will be queued to a smbiod
> > workqueue to handle it.
> 
> So, do you mean that there will be another thread that awaits all
> async requests on smbiod workqueue and then calls callback for
> handling?
> 

In interrupt context, we'll read the header down to the MID and look up
the request in a table (similar to how we do today in CIFS). For sync
requests, we'll wake up the waiting thread which would copy the header
info read so far into the buffer, and read the rest of the reply off
the socket. The smb layer will provide functions that the upper layers
can use to read in the rest of the reply (not 100% sure of the best way
to do that yet).

async requests will require the caller to set up a callback function to
handle the reply. That callback function will be queued to the
workqueue. It'll need to read in the rest of the reply off the socket
and then process the result.

I think this is a cleaner and more efficient approach than having more
threads.

> 
> In general, the doc looks very good to me. May be you move it to Google Docs?
> 

Thanks for looking. I'm trying to make sure I have the design at least
somewhat finalized before I start coding.

I may move it to the samba wiki once it's a bit more finalized. I'm not
a huge fan of google docs ;).

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
