From: Steve French <smfrench@gmail.com>
Subject: Re: cifs client timeouts and hard/soft mounts
Date: Sun, 5 Dec 2010 20:16:46 -0600
Message-ID: <AANLkTik4Vh5hqWwVngjCC7v1ST1YxAP9LvQbcqKDhWHp@mail.gmail.com>
References: <20101203212811.17594274@tlielax.poochiereds.net>
	<E1POnFL-00BKfp-6h@intern.SerNet.DE>
	<AANLkTi=MCgZb=we2OEtxJ4DZ==sVmRLd8aQKeMU7vvKt@mail.gmail.com>
	<20101205210634.602b076b@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs@vger.kernel.org, cifs-protocol@samba.org,
	Volker.Lendecke@sernet.de, samba-technical@lists.samba.org
To: Jeff Layton <jlayton@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20101205210634.602b076b@corrin.poochiereds.net>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Sun, Dec 5, 2010 at 8:06 PM, Jeff Layton <jlayton@samba.org> wrote:

> On Sun, 5 Dec 2010 19:42:30 -0600
> Steve French <smfrench@gmail.com> wrote:
>
> > On Sat, Dec 4, 2010 at 2:12 AM, Volker Lendecke
> > <Volker.Lendecke@sernet.de>wrote:
> >
> > > On Fri, Dec 03, 2010 at 09:28:11PM -0500, Jeff Layton wrote:
> > > > So, what does this mean for CIFS clients? I believe that the best
> > > > behavior for the client is to *never* time out an individual request,
> > > > aside from SMB echoes.
> > >
> > > I like this concept.
> > >
> > >
> > That will break apps that can't take ctl-c though ...
> >
>
> How will waiting indefinitely for a response break applications?
> Returning an error just because the server is slow seems far more
> likely to break applications.
>
> Now, in the (IMO unlikely) event that a server is responding to
> echoes but not other calls, you'd have an that application will hang
> until someone kills it. I think that's acceptable however:
>
> It's an unlikely situation, and anyone who has a client faced with it
> has a way to recover from the hang. They can kill the application. The
> server in this case would be clearly broken however.
>
>
I am more worried about firewall rule changes and similar events
than about broken servers - but the idea of waiting forever on stat
to a server that is never going to respond seems odd.

-- 
Thanks,

Steve
