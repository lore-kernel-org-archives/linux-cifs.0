From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: Linux CIFS and Nexenta compatibility issue
Date: Sun, 9 Jun 2013 18:05:41 -0500
Message-ID: <CAH2r5muox1aQf10wPuB+tkAhDQV+rwUm3VQa-u3D9cq5eNCV4w@mail.gmail.com>
References: <CAPcdcpJ4CjPDVB0SLNkouugubuif_z0JiV24QwwrQwPMFoTefQ@mail.gmail.com>
	<20130607131811.1902afab@tlielax.poochiereds.net>
	<CAH2r5muxk49kE_f=-TduqZyD_TziUR-W_t8_T6Ou29DzAhwkrA@mail.gmail.com>
	<CAPcdcp+k+wnZM3vZa8t=_CEqd3cNSw7=gTrLZzTdn82HWw9yVQ@mail.gmail.com>
	<CAH2r5muExvQeX=NfhPRuupHEMi9zx-46mvzAfF4du-VWKjQ_uA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ketil Froyn <ketil-wcohQK4BhvFBDLzU/O5InQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muExvQeX=NfhPRuupHEMi9zx-46mvzAfF4du-VWKjQ_uA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Some background: the default authentication method was changed for the
cifs kernel client from ntlm to ntlmv2 since ntlmv2 is considerably
more secure, but when we tested the upgrade from "raw ntlm" to "raw
ntlmv2" (ie changing from "sec=ntlm" to "sec=ntlmv2" as default - "raw
ntlmv2" means password hash is not encapsulated in NTLMSSP) we ran
into compatibility problems with one server (not Windows or Samba) so
we had to change to ntlmv2 encapsulated in ntlmssp (ie changing to
"sec=ntlmssp") but that caused compatibility problems (we think) with
a different set of servers (fortunately not Samba or Windows, nor the
other most popular NAS, which were the easiest ones for us to test
with)

So we ended up with a tough problem to deal with:
- upgrading is still needed for better security so we can't go back to
ntlm default
- at least one server breaks with raw ntlmv2 (otherwise this would
have been chosen as our default since it is so simple)
- at least one server (perhaps two) breaks with (ntlmv2 in) ntlmssp
(our current default authentication mechanism)

so we have to make changes to better detect when the target server can
support "extended security" (which can be tough since we don't know
what flags the server sends back on negotiate protocol until we
actually begin negotiating) - and perhaps improve fallback when the
server rejects ntlmssp.

Jeff's (security/auth flags) patchset may help here (which is
partially meged in cifs-2.6.git), but will probably not make any
difference if you are able to show a failure on newer cifs with
"sec=krb5" which does not fail with older cifs (specfifying
"sec=krb5")

---------- Forwarded message ----------
Date: Sun, Jun 9, 2013 at 5:07 PM
Subject: Re: Linux CIFS and Nexenta compatibility issue
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


It would be easier to tell If you check whether behavior has changed
specifying the same type of authentication on mount ie sec=krb5 on
both older and newer versions of Linux client

On Jun 9, 2013 4:36 PM, "Ketil Froyn" <ketil-wcohQK4BhvFBDLzU/O5InQ@public.gmane.org> wrote:
>
> On 7 June 2013 19:23, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >
> > On Fri, Jun 7, 2013 at 12:18 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> >>
> >> On Fri, 7 Jun 2013 13:15:53 +0200
> >> Ketil Froyn <ketil-wcohQK4BhvFBDLzU/O5InQ@public.gmane.org> wrote:
> >>
> >> > Hi,
> >> >
> >> > I have a Nexenta system (based on OpenSolaris/IllumOS) running ZFS
> >> > shared with CIFS. After upgrading to Ubuntu 13.04, I'm unable to mount
> >> > the Nexenta CIFS shares. I've posted an Ubuntu bug report here with
> >> > details (though I'm not sure cifs-utils was the right place to report
> >> > this), including cifsFYI enabled trace of the mount operation:
> >> >
> >> > https://bugs.launchpad.net/ubuntu/+source/cifs-utils/+bug/1185025
> >> >
> >> > In the test results shown, I had specified my username and password to
> >> > mount. I have since discovered that when specifying my
> >> > username/password directly to mount, I am able to mount the shares
> >> > with the sec=ntlm or sec=ntlmv2 options. However, I've used
> >> > Likewise-Open to sign my desktop into the AD domain, so that any AD
> >> > user ID can log on to Ubuntu, and then get CIFS shares automounted
> >> > with the user's credentials. I guess mount uses sec=krb5 to mount
> >> > these shares.  That still fails with the same log output. This works
> >> > fine on all the shares except Nexenta shares, and with Ubuntu 12.10
> >> > the Nexenta shares worked fine.
> >> >
> >> > So there appears to be some sort of CIFS compatibility issue between
> >> > Nexenta OS 3.1.3.5 and Ubuntu 13.04. In short, all other OS-es
> >> > (Windows, Mac, other versions of Ubuntu) work with the Nexenta OS
> >> > 3.1.3.5 CIFS server and all other CIFS servers in the domain, and
> >> > Ubuntu 13.04 works with all other CIFS servers in the domain, but not
> >> > the Nexenta 3.1.3.5 server. So something in the linux CIFS codebase
> >> > between Ubuntu 12.10 and 13.04 appears to have triggered this error.
> >> >
> >> > Is there anything else I can do to find out exactly what is happening,
> >> > and whether this is linux CIFS' or Nexenta OS's fault, or a
> >> > combination?
> >> >
> >> > Ubuntu 13.04 uses cifs-utils 5.5, presumably with some Ubuntu patches,
> >> > and linux kernel 3.8.0, presumably also with Ubuntu patches.
> >> >
> >> > Regards, Ketil
> >>
> >> Likely more fallout from the change to sec=ntlmssp by default. I wonder
> >> if the nexenta server doesn't support extended security? In any case,
> >> does this work if you mount with sec=ntlmv2 in the options? If that
> >> doesn't work, can you try sec=ntlm?
> >>
> >
> > Ketil said: "I am able to mount the shares with the sec=ntlm or sec=ntlmv2
> > options" so presumably is related to the lack of extended security support
> > and our need to build in some sort of retry logic to workaround the bugs in
> > the servers which require ntlmssp and the servers with bugs handling ntlmssp
> > - so we have to be able to try both since we have servers with both types of
> > bugs to workaround
> >
> > --
> > Thanks,
> >
> > Steve
>
> Thanks for the feedback. I'm trying to understand what's going on -
> does this mean that there's a bug in the nexenta cifs server that the
> linux cifs client has to work, or perhaps a configuration issue? I'm
> not sure what ntlmssp's role in this error is. As I understand it,
> likewise-open has set up automount using kerberos tickets, so I guess
> it's using sec=krb5, not sec=ntlmssp.
>
> I'm hoping perhaps there are some configuration switches I can play
> with on the linux or nexenta end to get things working without
> downgrading linux cifs or waiting for a new linux cifs release.
>
> Regards, Ketil


-- 
Thanks,

Steve
