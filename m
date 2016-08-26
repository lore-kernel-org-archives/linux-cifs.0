From: Simo <simo@samba.org>
Subject: Re: [cifs-utils PATCHv2 0/6] cifs.upcall: cleanup and overhaul of
 the cifs.upcall krb5 handling code
Date: Fri, 26 Aug 2016 09:54:06 -0400
Message-ID: <1472219646.17759.11.camel@samba.org>
References: <1472134665-4014-1-git-send-email-jlayton@samba.org>
 <CAC-fF8S_K49oDzNMQ8PrjWyWEokdsRo2gC5xUQobWe4TTBYaCA@mail.gmail.com>
 <1472143488.3160.7.camel@samba.org>
 <CAC-fF8RE-D=2wiSixiyXw7mR3Z8OeHD5GWtRkibuP9DNseGQuA@mail.gmail.com>
 <1472158299.2599.10.camel@samba.org> <1472216025.17759.9.camel@samba.org>
 <1472219051.2603.3.camel@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-cifs@vger.kernel.org, jfdey@fredhutch.org,
 samba-technical@lists.samba.org
To: Jeff Layton <jlayton@samba.org>, Isaac Boukris <iboukris@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1472219051.2603.3.camel@samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical/>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Errors-To: samba-technical-bounces@lists.samba.org
Sender: "samba-technical" <samba-technical-bounces@lists.samba.org>
List-Id: linux-cifs.vger.kernel.org

On Fri, 2016-08-26 at 09:44 -0400, Jeff Layton wrote:
> On Fri, 2016-08-26 at 08:53 -0400, Simo wrote:
> > 
> > On Thu, 2016-08-25 at 16:51 -0400, Jeff Layton wrote:
> > > 
> > > 
> > > On Thu, 2016-08-25 at 22:59 +0300, Isaac Boukris wrote:
> > > > 
> > > > 
> > > > 
> > > > > 
> > > > > > 
> > > > > > > 
> > > > > > > On Thu, Aug 25, 2016 at 7:44 PM, Jeff Layton <jlayton@sam
> > > > > > > ba.org>
> > > > wrote:
> > > > > 
> > > > > 
> > > > > 
> > > > > 
> > > > > On Thu, 2016-08-25 at 19:05 +0300, Isaac Boukris wrote:
> > > > > > 
> > > > > > 
> > > > > > 
> > > > > > 
> > > > > > However, it gets more complicated when it comes to SPNEGO.
> > > > > > First, when I call gss_init_sec_context with SPNEGO mech it
> > > > > > will
> > > > > > always return GSS_S_CONTINUE_NEEDED as it need server
> > > > > > response
> > > > > > in
> > > > > > order to complete (even if mutual auth is not requested).
> > > > > > This causes (I think) the call to
> > > > > > gss_inquire_sec_context_by_oid
> > > > > > to
> > > > > > fail.
> > > > > > Also, we need to support continuation anyway for mutual
> > > > > > auth
> > > > > > and
> > > > > > NTLM
> > > > > > fallback.
> > > > > > 
> > > > > Ahh that's interesting. I didn't realize we'd be stuck having
> > > > > to
> > > > > handle
> > > > > a multi-stage negotiation if we use gss_init_sec_context.
> > > > > That is
> > > > > sort
> > > > > of difficult to handle with the way the upcall currently
> > > > > works.
> > > > > 
> > > > > I may still play with it just to verify that I understand
> > > > > what
> > > > > you're
> > > > > saying but it does make sense.
> > > > You may take look at my (dirty) draft:
> > > > https://github.com/frenche/cifs-utils/tree/gssapi_upcall
> > > > 
> > > Neat. Do you have a companion kernel patch? I'm wondering about
> > > how
> > > to
> > > handle backward compatibility there. I guess we could try SPNEGO
> > > first
> > > and fall back to using the *KRB5 if that fails.
> > > 
> > > Another thing (not directly related) that I've been considering
> > > is
> > > whether we can use anonymous krb5 creds to handle the initial
> > > mount
> > > for
> > > sec=krb5 mounts. It would be nice to be able to do multiuser
> > > mounts
> > > without any client side setup.
> > You could use the workstation credentials if you are joined to a
> > domain, but even better would be to let gss-proxy decide it by
> > telling
> > it you are acting as the "root" user, or passing an option in the
> > gss-
> > proxy protocol.
> > 
> > Really please let's not add another half-assed "gssapi upcall
> > mechanism
> > here".
> > 
> Agreed. I'm planning to merge these cleanup patches unless anyone has
> objections, but I'm less inclined to spend time on a new upcall
> mechanism as well.
> 
> I wouldn't NAK it outright, since there is some value in not needing
> to
> run a daemon, but I'd rather just wire cifs.ko up to gssproxy and be
> done with it.
> 
> > 
> > > 
> > > 
> > > > 
> > > > 
> > > > 
> > > > > 
> > > > > 
> > > > > 
> > > > > 
> > > > > If we're going to go down the road of changing the upcall to
> > > > > handle
> > > > > that then I think I'd prefer to just change cifs.ko over to
> > > > > use
> > > > > gssproxy directly, like knfsd already does.
> > > > > 
> > > > > It would be one less special snowflake to deal with and most
> > > > > of
> > > > > the
> > > > > plumbing is already in place. We could leave the old upcall
> > > > > in
> > > > > place
> > > > > for legacy userland case, and only do it if the gssproxy
> > > > > negotiation
> > > > > failed. It's a bit of a project, but would be totally doable.
> > > > The cifs kernel module will need some changes anyway to handle
> > > > multi-stage negotiation I think.
> > > > Using gssproxy sounds like an excellent idea, though I'm only
> > > > vaguely
> > > > familiar with it so I'll have to look it up.
> > > > 
> > > > On the other hand I think there may still be an interest for
> > > > stateless
> > > > mechanism (alongside) which wouldn't require a running daemon.
> > > > I'm trying to think of an alternative to exporting the gss
> > > > context,
> > > > perhaps by keeping the upcall process running and continuing
> > > > the
> > > > conversation with the kernel module somehow.
> > > >  
> > > Yeah, not having a running daemon is certainly simpler for
> > > users. 
> > Although it may be simpler it makes little sense, in most cases
> > when
> > you use kerberos you are probably joined to a domain and already
> > have
> > winbindd or sssd running, and kerberos/gssapi is complex enough
> > that
> > having to run a daemon is not a big deal.
> > However you could always try to start the gssproxy daemon if it is
> > not
> > running. It won't do much good if it has no configuration, however
> > distributions that allow to start it via the kernel could make sure
> > to
> > have defaults that would work as well as any upcall mechanism you
> > can
> > come up with.
> > 
> > I say this because we are working to add more and more features to
> > the
> > system to handle GSSAPI well, both for krb5 and NTLM protocols, and
> > other less known ones eventually, and doing it in one place and
> > avoiding duplications everywhere would concentrate efforts and get
> > you
> > expert help, as well as a consistent experience across protocols
> > (both
> > nfs and cifs).
> > 
> > 
> Yeah, that makes sense. There's also the problem that the UMH upcalls
> (like that used by the keys API) don't play well in containers
> currently. That may change one day, but for now that's also a good
> reason to avoid them.

Indeed, with a socket we can be a lot more container friendly (or
unfriendly if we want) by just bind mounting the right stuff in the
right place.

We are going to handle ccaches for containers via SSSD in the not too
distant future and we are adding (yet another I know) ccache mechanism
to address better all use cases that are cropping up.
We'll make sure this interacts properly with gssproxy, how other tools
will handle it will vary...

Simo.
