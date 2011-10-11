From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH 3/4] sunrpc: make rpc_wait_bit_killable handle freeze
 events
Date: Tue, 11 Oct 2011 06:12:21 -0400
Message-ID: <20111011061221.2a4a212f@tlielax.poochiereds.net>
References: <1317210761-11518-1-git-send-email-jlayton@redhat.com>
	<1317210761-11518-4-git-send-email-jlayton@redhat.com>
	<20111011061923.GC1377@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: trond.myklebust@netapp.com, smfrench@gmail.com, rjw@sisk.pl,
	linux-pm@lists.linux-foundation.org, linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org, john@Calva.COM,
	linux-kernel@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111011061923.GC1377@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, 11 Oct 2011 08:19:23 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> On Wed 2011-09-28 07:52:40, Jeff Layton wrote:
> > Allow the wait_on_bit_killable sleeps in SUNRPC layer to respect the
> > freezer. This should allow suspend and hibernate events to occur, even
> > when there are RPC's pending on the wire.
> 
> Will the RPC protocols used handle that correctly? What will happen
> during resume?
> 

That depends on the state of the socket during resume. If the
suspend/resume is quick enough, then the socket may still be connected,
or if we're using UDP then we might just get the reply and carry on
successfully. Otherwise, the call will eventually time out, or will be
cancelled when the kernel finds that the socket has been closed.

Either way, this should do the right thing.

-- 
Jeff Layton <jlayton@redhat.com>
