From: Simo <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: pam module to set cifs credentials in key store
Date: Thu, 14 Nov 2013 11:15:50 -0500
Message-ID: <1384445750.4226.71.camel@pico.ipa.ssimo.org>
References: <loom.20131113T002139-562@post.gmane.org>
	 <20131112212536.6061477e@corrin.poochiereds.net>
	 <5283E835.2090508@cora.nwra.com>
	 <1384382099.4226.63.camel@pico.ipa.ssimo.org>
	 <52840177.80901@cora.nwra.com> <52840237.2010206@cora.nwra.com>
	 <1384385539.4226.67.camel@pico.ipa.ssimo.org>
	 <20131114080854.546b6069@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Orion Poplawski <orion-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131114080854.546b6069-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2013-11-14 at 08:08 -0500, Jeff Layton wrote:
> On Wed, 13 Nov 2013 18:32:19 -0500
> Simo <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> 
> > On Wed, 2013-11-13 at 15:50 -0700, Orion Poplawski wrote:
> > > On 11/13/2013 03:47 PM, Orion Poplawski wrote:
> > > > On 11/13/2013 03:34 PM, Simo wrote:
> > > >>
> > > >> Uhm doesn't this code store the user password in the clear in a key that
> > > >> is explicitly made readable to any process of the user in the same
> > > >> session ?
> > > >>
> > > >> Simo.
> > > >>
> > > >
> > > > I tried to mimic exactly what the cifscreds program does, but I may have made
> > > > a mistake.  Or perhaps cifscreds is also doing a bad thing.  The key
> > > > permissions are set to:
> > > >
> > > > #define CIFS_KEY_PERMS (KEY_POS_VIEW|KEY_POS_WRITE|KEY_POS_SEARCH| \
> > > >                          KEY_USR_VIEW|KEY_USR_WRITE|KEY_USR_SEARCH)
> > > >
> > > >
> > > 
> > > We're not setting KEY_*_READ, so one cannot read the contents of the key, IIUIC.
> > 
> > My bad, my eyes saw VIEW but read READ.
> > 
> > Simo.
> > 
> 
> Yep, and furthermore...
> 
> These keys are saved as a "logon" keytype (see kernel commit
> 9f6ed2ca257). Those are basically just like the "user" keytype except
> that there is no mechanism to report the payload to userland. So even
> if the permissions we such that you could read them, there's no way for
> the kernel to do so.
> 
> About the only way to get the password out of the kernel would be to
> poke around in /dev/mem or the equivalent. Unfortunately, there's not
> much we can do about that...

We could (reversibly) encrypt them with a key held in a TPM chip :-)

Simo.
