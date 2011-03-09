From: Jeff Layton <jlayton@redhat.com>
Subject: Re: stable page writes: wait_on_page_writeback and packet signing
Date: Wed, 9 Mar 2011 18:54:27 -0500
Message-ID: <20110309185427.7858c29b@corrin.poochiereds.net>
References: <AANLkTinFx9KGKDWSdUvFSvT4S6f9QjBzX=6Uo17oO89+@mail.gmail.com>
	<20110309215148.GW15097@dastard>
	<AANLkTinDmqah6pQnHugoVxh-gDq+6+MDMuh-TyVAQ7LP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>, linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Mingming Cao <mcao@us.ibm.com>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTinDmqah6pQnHugoVxh-gDq+6+MDMuh-TyVAQ7LP@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Wed, 9 Mar 2011 16:01:30 -0600
Steve French <smfrench@gmail.com> wrote:

> 
> Except we don't need to wait that long with the page locked
> ie for a response from the cifs server (such as Samba or Windows
> or NetApp), just need to wait for it to get on the wire.
> Waiting for us to get the server response would
> take 10 or 100 times longer.   In any case we can't resend
> the same request to the server (the signature changes on the
> resend since the sequence number is incremented on every
> request/response so we have to recalc the checksum anyway) and
> cifs requests can't get lost (as with nfs over udp).  Keeping
> a page locked for 10milliseconds seems like a bad idea - but
> it is a little more complicated to implement (for the cifs case)
> so that we end page writeback (for the non-WB_SYNC)
> as quickly as reasonably possible so we don't kill perf.
> 

The problem here is that the socket layer doesn't have a mechanism
to notify us of a TCP ACK. So, we have to wait for the next-best thing
-- a response from the server.

-- 
Jeff Layton <jlayton@redhat.com>
