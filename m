From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] cifs: stop trying to use virtual circuits
Date: Wed, 18 Sep 2013 11:05:35 -0400
Message-ID: <20130918110535.6abc3372@tlielax.poochiereds.net>
References: <1379345025-10868-1-git-send-email-jlayton@redhat.com>
	<E1VMJ0n-001ZxR-I8@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sauron99@gmx.de, smfrench@gmail.com, samba-technical@lists.samba.org, linux-cifs@vger.kernel.org
To: Volker.Lendecke@SerNet.DE
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <E1VMJ0n-001ZxR-I8@intern.SerNet.DE>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Wed, 18 Sep 2013 07:42:09 -0700
Volker Lendecke <Volker.Lendecke@SerNet.DE> wrote:

> On Mon, Sep 16, 2013 at 11:23:45AM -0400, Jeff Layton wrote:
> > Currently, we try to ensure that we use vcnum of 0 on the first
> > established session on a connection and then try to use a different
> > vcnum on each session after that.
> > 
> > This is a little odd, since there's no real reason to use a different
> > vcnum for each SMB session. I can only assume there was some confusion
> > between SMB sessions and VCs. That's somewhat understandable since they
> > both get created during SESSION_SETUP, but the documentation indicates
> > that they are really orthogonal. The comment on max_vcs in particular
> > looks quite misguided. An SMB session is already uniquely identified
> > by the SMB UID value -- there's no need to again uniquely ID with a
> > VC.
> > 
> > Furthermore, a vcnum of 0 is a cue to the server that it should release
> > any resources that were previously held by the client. This sounds like
> > a good thing, until you consider that:
> > 
> > a) it totally ignores the fact that other programs on the box (e.g.
> > smbclient) might have connections established to the server. Using a
> > vcnum of 0 causes them to get kicked off.
> > 
> > b) it causes problems with NAT. If several clients are connected to the
> > same server via the same NAT'ed address, whenever one connects to the
> > server it kicks off all the others, which then reconnect and kick off
> > the first one...ad nauseum.
> > 
> > I don't see any reason to ignore the advice in "Implementing CIFS" which
> > has a comprehensive treatment of virtual circuits. In there, it states
> > "...and contrary to the specs the client should always use a VcNumber of
> > one, never zero."
> > 
> > Have the client just use a hardcoded vcnum of 1, and stop abusing the
> > special behavior of vcnum 0.
> 
> It's kindof a tough choice, but I like this patch. It does
> solve real problems. The downside certainly is that we have
> worse cleanup behaviour of dead connections, but I would
> prefer not killing NATed connections.
> 
> Volker
> 

Agreed, but I'm not convinced that there's really a downside.

We don't currently use share modes, so that shouldn't be an issue.
Pavel's patchset may eventually change that, but I don't see it
happening anytime too soon.

My initial thinking was that we might end up not getting an oplock on a
reconnect when we held one before. OTOH, one would think that if the
client was reclaiming the open file, the server would try to issue an
oplock break on the previous connection. At that point, it should find
that it's dead anyway, so that also shouldn't be an issue.

Implementing CIFS clearly states that VC handling by servers is spotty
at best, so I think we're best off avoiding any use of them.

In principle, we could add a knob that tells the server to use vcnum==0
on the first session to allow it to opt-in to this behavior, but I'd
prefer not to do that until someone demonstrates a clear need for it so
we can understand how best to implement it.

If we did need to do that, there's clearly no need to use a different
vcnum on every session. Simply using vcnum==0 on the first one and then
vcnum==1 on every subsequent one would be sufficient.

-- 
Jeff Layton <jlayton@redhat.com>
