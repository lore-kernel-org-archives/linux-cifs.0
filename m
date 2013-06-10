From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Linux CIFS and Nexenta compatibility issue
Date: Sun, 9 Jun 2013 20:55:28 -0400
Message-ID: <20130609205528.21082443@corrin.poochiereds.net>
References: <CAPcdcpJ4CjPDVB0SLNkouugubuif_z0JiV24QwwrQwPMFoTefQ@mail.gmail.com>
	<20130607131811.1902afab@tlielax.poochiereds.net>
	<CAH2r5muxk49kE_f=-TduqZyD_TziUR-W_t8_T6Ou29DzAhwkrA@mail.gmail.com>
	<CAPcdcp+k+wnZM3vZa8t=_CEqd3cNSw7=gTrLZzTdn82HWw9yVQ@mail.gmail.com>
	<CAH2r5muExvQeX=NfhPRuupHEMi9zx-46mvzAfF4du-VWKjQ_uA@mail.gmail.com>
	<CAH2r5muox1aQf10wPuB+tkAhDQV+rwUm3VQa-u3D9cq5eNCV4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ketil Froyn <ketil-wcohQK4BhvFBDLzU/O5InQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muox1aQf10wPuB+tkAhDQV+rwUm3VQa-u3D9cq5eNCV4w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 9 Jun 2013 18:05:41 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Some background: the default authentication method was changed for the
> cifs kernel client from ntlm to ntlmv2 since ntlmv2 is considerably
> more secure, but when we tested the upgrade from "raw ntlm" to "raw
> ntlmv2" (ie changing from "sec=ntlm" to "sec=ntlmv2" as default - "raw
> ntlmv2" means password hash is not encapsulated in NTLMSSP) we ran
> into compatibility problems with one server (not Windows or Samba) so
> we had to change to ntlmv2 encapsulated in ntlmssp (ie changing to
> "sec=ntlmssp") but that caused compatibility problems (we think) with
> a different set of servers (fortunately not Samba or Windows, nor the
> other most popular NAS, which were the easiest ones for us to test
> with)
> 
> So we ended up with a tough problem to deal with:
> - upgrading is still needed for better security so we can't go back to
> ntlm default
> - at least one server breaks with raw ntlmv2 (otherwise this would
> have been chosen as our default since it is so simple)
> - at least one server (perhaps two) breaks with (ntlmv2 in) ntlmssp
> (our current default authentication mechanism)
> 
> so we have to make changes to better detect when the target server can
> support "extended security" (which can be tough since we don't know
> what flags the server sends back on negotiate protocol until we
> actually begin negotiating) - and perhaps improve fallback when the
> server rejects ntlmssp.
> 
> Jeff's (security/auth flags) patchset may help here (which is
> partially meged in cifs-2.6.git), but will probably not make any
> difference if you are able to show a failure on newer cifs with
> "sec=krb5" which does not fail with older cifs (specfifying
> "sec=krb5")
> 

Yeah, I had assumed that the Nexenta server wasn't setting the extended
security bit in its NEGOTIATE response. I suppose it could be, but
doesn't support NTLMSSP? In any case, then you might still need a sec=
option to mount even with that patchset in place.

What might be interesting actually is a capture of one of these failed
mount attempts? That might tell us for certain...

    http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Wire_Captures

Thanks,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
